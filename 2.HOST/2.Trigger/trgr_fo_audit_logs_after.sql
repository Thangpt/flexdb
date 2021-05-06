CREATE OR REPLACE TRIGGER "TRGR_FO_AUDIT_LOGS_AFTER"
 AFTER
  INSERT
 ON fo_audit_logs
REFERENCING NEW AS NEWVAL OLD AS OLDVAL
 FOR EACH ROW
               WHEN (NEWVAL.action_type = 'I') declare
  pkgctx plog.log_ctx;
  logrow tlogdebug%rowtype;

  l_afacctno varchar2(20);

  type afmast_cursor is ref cursor;

  c_afmast afmast_cursor;

  afmastrow afmast%rowtype;

  type ty_afmast is table of afmast%rowtype index by binary_integer;

  afmast_list ty_afmast;

  l_afmast_cache_size number(23) := 20;

  l_row pls_integer;
  l_cnt pls_integer;
begin
  -- Initialization log
  for i in (select * from tlogdebug)
  loop
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  end loop;

  pkgctx := plog.init('trgr_event_audit_log',
                      plevel                => nvl(logrow.loglevel, 30),
                      plogtable             => (nvl(logrow.log4table, 'N') = 'Y'),
                      palert                => (nvl(logrow.log4alert, 'N') = 'Y'),
                      ptrace                => (nvl(logrow.log4trace, 'N') = 'Y'));

  plog.setBeginSection(pkgctx, 'trgr_event_audit_log');

  if fopks_api.fn_is_ho_active then

    msgpks_system.sp_notification_obj('LOGON', :NEWVAL.username, :NEWVAL.channel);

    open c_afmast for
      select a.acctno afacctno, u.username, :NEWVAL.channel channel, a.acctno || ' - ' || c.fullname || ' - ID: ' || c.idcode
        from cfmast c, afmast a, userlogin u
       where a.custid = c.custid and c.username = u.username
         and c.status = 'A'
         and u.username = :NEWVAL.username;

    loop
      fetch c_afmast bulk collect
        into afmast_list limit l_afmast_cache_size;

      exit when afmast_list.count = 0;

      plog.debug(pkgctx, 'List count ' || afmast_list.count);

      l_row := afmast_list.FIRST;

      while (l_row is not null)
      loop

        afmastrow  := afmast_list(l_row);
        l_afacctno := afmastrow.acctno;

          begin
            select count(afacctno)
              into l_cnt
              from ol_account_ci
             where afacctno = l_afacctno;

            if l_cnt = 0 then
              plog.debug(pkgctx, 'Init all buffer for ' || l_afacctno);
              msgpks_system.sp_notification_obj('INIT_PORTFILO', '', l_afacctno);
              msgpks_system.sp_notification_obj('IOD', '', l_afacctno);
            else
              plog.debug(pkgctx, 'Resend from buffer for ' || l_afacctno);
              msgpks_system.sp_notification_obj('GET_CIFULL', l_afacctno, l_afacctno);
              msgpks_system.sp_notification_obj('GET_ALL_SEMAST', '', l_afacctno);
              msgpks_system.sp_notification_obj('GET_ALL_ORDERBOOK', '', l_afacctno);
              msgpks_system.sp_notification_obj('GET_ALL_IOD', '', l_afacctno);
            end if;
          end;

        /*        begin
          select count(afacctno)
            into l_cnt
            from ol_account_se
           where afacctno = l_afacctno;

          if l_cnt = 0 then
            plog.debug(pkgctx, 'Init SE buffer for ' || l_afacctno);
            msgpks_system.sp_notification_obj('SEMAST',
                                              l_afacctno,
                                              l_afacctno);
          end if;
        end;*/

        l_row := afmast_list.NEXT(l_row);
      end loop;

    end loop;
  end if;

exception
  when others then
    plog.error(pkgctx, sqlerrm);
    plog.setEndSection(pkgctx, 'trgr_event_audit_log');
end;
/

