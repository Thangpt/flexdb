CREATE OR REPLACE TRIGGER trg_semast_after
 AFTER
  INSERT OR UPDATE
 ON semast
REFERENCING NEW AS NEWVAL OLD AS OLDVAL
 FOR EACH ROW
declare
  --v_afacctno varchar2(20);
  --v_errmsg varchar2(3000);
/*  l_symbol     varchar2(10);
  l_amount     number;
  l_custodycd  varchar2(10);
  l_smsmobile  varchar2(15);
  l_templateid varchar2(10);
  l_datasource varchar2(1000);*/
  p_err_code varchar2(200);
begin
  if fopks_api.fn_is_ho_active then
    /*v_afacctno := :newval.afacctno;
    msgpks_system.sp_notification_obj('SEMAST',
                                  :newval.acctno,
                                  v_afacctno);*/
    --Begin GianhVG Log trigger for buffer
    fopks_api.pr_trg_account_log(:newval.acctno, 'SE');
    if :newval.trade <> :oldval.trade then
      fopks_api.pr_trg_account_log(:newval.afacctno, 'CI');
    end if;
    --End Log trigger for buffer
    if :oldval.trade is null or :newval.trade <> :oldval.trade then
      cspks_seproc.pr_execute_trigger_log(:newval.afacctno, :newval.codeid, :newval.trade - nvl(:oldval.trade,0), 0);
    end if;

    --Neu chuyen tu check Room chung sang room rieng hoac nguoc lai thi thuc hien danh dau lai cho tai khoan
    if :oldval.roomchk <> :newval.roomchk then
        if fn_markedafpralloc(:newval.afacctno,
                            null,
                            'A',
                            'T',
                            :newval.acctno,
                            'N',
                            'N',
                            getcurrdate,
                            '',
                            p_err_code) <> systemnums.C_SUCCESS then
                null;
            end if;
    end if;
/*    if UPDATING and :newval.trade > 0 then
      begin

        select custodycd, af.fax1
          into l_custodycd, l_smsmobile
          from cfmast cf, afmast af
         where cf.custid = af.custid
           and af.acctno = :newval.afacctno;

        select symbol into l_symbol from sbsecurities where codeid = :newval.codeid;

        l_amount := abs(:newval.trade - :oldval.trade);

        if :newval.trade > :oldval.trade then
          l_templateid := '325E';
        elsif :newval.trade < :oldval.trade then
          l_templateid := '325F';
        else
          l_templateid := '';
        end if;

        l_datasource := 'select ''' || l_custodycd || ''' custodycode, ''' ||
                        to_char(getcurrdate, 'DD/MM/RRRR') || ''' txdate, ''' || :newval.trade ||
                        ''' trade, ''' || l_amount || ''' amount, ''' || l_symbol || ''' symbol, '''' txdesc from dual';

        if l_smsmobile is not null and Length(l_smsmobile) > 0 and length(l_templateid) > 0 then

          insert into emaillog
            (autoid, email, templateid, datasource, status, createtime)
          values
            (seq_emaillog.nextval, l_smsmobile, l_templateid, l_datasource, 'A', sysdate);

        end if;
      end;
    end if;
  */
  end if;
end;
/

