CREATE OR REPLACE TRIGGER trg_tllog_after
 AFTER
 INSERT OR UPDATE
 ON tllog
REFERENCING NEW AS NEWVAL OLD AS OLDVAL
 FOR EACH ROW
declare
  -- local variables here
  -- l_datasource varchar2(1000);
  l_msg_type varchar2(200);
  pkgctx     plog.log_ctx;
  logrow     tlogdebug%ROWTYPE;
  L_COUNT    number(5);
  l_search   varchar2(100);
begin

  FOR i IN (SELECT * FROM tlogdebug) LOOP
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  END LOOP;
  pkgctx := plog.init('trg_tllog_after',
                      plevel           => NVL(logrow.loglevel, 30),
                      plogtable        => (NVL(logrow.log4table, 'N') = 'Y'),
                      palert           => (NVL(logrow.log4alert, 'N') = 'Y'),
                      ptrace           => (NVL(logrow.log4trace, 'N') = 'Y'));

  plog.setbeginsection(pkgctx, 'trg_tllog_after');
  if fopks_api.fn_is_ho_active then
    if :NEWVAL.tltxcd in
       ('1100', '1108', '1109', '1111', '1132', '1133', '1136') and
       :newval.txstatus = '1' and
       :newval.txstatus <> NVL(:oldval.txstatus, '-') then

      --Begin TheNN Log trigger for buffer
      fopks_api.pr_trg_account_log(:newval.msgacct, 'CI');
      --End Log trigger for buffer

    end if;

    if :NEWVAL.tltxcd = '0380' and :newval.txstatus = '1' and
       :newval.txstatus <> NVL(:oldval.txstatus, '-') then

      emailLOG_reaflink(:newval.TXNUM, :newval.TXDATE);

    end if;

    --Insert vao t_fo_event de GEN Msg sang FO
    --Rieng trg hop tltxcd = 1816 da insert trong txpks_1816EX
    if ((SUBSTR(:NEWVAL.TXNUM,1,4) = '6800' AND :NEWVAL.TLTXCD NOT IN ('1816','1120','1101','3384','2242','8878')) --issMSBS-2623: 8878 khong theo luong SYN qua t_fo_event lên FO
            OR (:NEWVAL.TLID = '0000'  AND :NEWVAL.TLTXCD NOT IN ('1816','2242'))
            OR (SUBSTR(:NEWVAL.TXNUM,1,4) = '9900' AND :NEWVAL.TLTXCD IN ('2246','8879','2290','8868'))) AND INSERTING  THEN
        INSERT INTO t_fo_event (AUTOID, TXNUM, TXDATE, ACCTNO, TLTXCD,LOGTIME,PROCESSTIME,PROCESS,ERRCODE,ERRMSG,NVALUE,CVALUE)
        SELECT seq_fo_event.NEXTVAL, :NEWVAL.txnum, :NEWVAL.txdate, :NEWVAL.msgacct,:NEWVAL.tltxcd,systimestamp,systimestamp,'N','0',NULL, NULL, SUBSTR(:NEWVAL.TXNUM,1,4)
            FROM DUAL WHERE EXISTS (SELECT TLTXCD FROM FOTXMAP WHERE TLTXCD = :NEWVAL.tltxcd);
    END IF;

  end if;
  ----------------------------------------------
  --plog.error(pkgctx, '[DEBUG] :newval.txstatus' || :newval.txstatus || ':oldval.txstatus' || :oldval.txstatus);
  if :newval.txstatus = '1' and
     (:oldval.txstatus is null or :oldval.txstatus <> '1') then

    --------------------------------------------------------
    if :newval.tltxcd = '1816' then

      insert into log_notify_event
        (autoid,
         msgtype,
         keyvalue,
         status,
         CommandType,
         CommandText,
         logtime)
      values
        (seq_log_notify_event.nextval,
         'TRAN1816',
         :newval.txnum,
         'A',
         'P',
         'GENERATE_TEMPLATES',
         sysdate);

    else
      begin
        select msgtype
          into l_msg_type
          from tltx
         where tltxcd = :newval.tltxcd;
      exception
        when NO_DATA_FOUND then
          l_msg_type := '';
      end;

      if length(l_msg_type) > 0 then

        insert into log_notify_event
          (autoid,
           msgtype,
           keyvalue,
           status,
           CommandType,
           CommandText,
           logtime)
        values
          (seq_log_notify_event.nextval,
           'TRANSACT',
           :newval.txnum,
           'A',
           'P',
           'GENERATE_TEMPLATES',
           sysdate);
      end if;

    end if;

  end if;

    --------------------------------------------------------
  if :newval.txstatus = '1' and (:oldval.txstatus is null or :oldval.txstatus <> '1')
    THEN
      -- PHuongHT edit for VSD
    SELECT COUNT(*) INTO L_COUNT FROM VSDTRFCODE VSD WHERE VSD.TLTXCD=:NEWVAL.TLTXCD AND VSD.STATUS='Y' AND VSD.TYPE IN ('REQ','EXREQ');

    IF L_COUNT >0 THEN
  l_search := '%';
      -- Neu la cac giao dich Gui, Rut, Chuyen khoan CK WFT
      if instr('/2241/2255/2292/8815/', :newval.tltxcd) > 0 then

        begin
          select case
                   when instr(symbol, '_WFT') > 0 then
                    '%CLAS//PEND%'
                   else
                    '%CLAS//NORM%'
                 end
            into l_search
            from sbsecurities
           where codeid = :newval.ccyusage;
        exception
          when no_data_found then
            l_search := '%CLAS//NORM%';
        end;

      end if;

       FOR REC IN (
                  SELECT TRFCODE FROM VSDTRFCODE WHERE TLTXCD=:NEWVAL.TLTXCD AND STATUS='Y' AND (TYPE = 'REQ'
                   AND TRFCODE LIKE L_SEARCH) OR (TYPE = 'EXREQ' AND TLTXCD=:NEWVAL.TLTXCD))
       LOOP
           Insert into VSD_PROCESS_LOG(AUTOID,TRFCODE,TLTXCD,TXNUM,TXDATE,PROCESS,MSGACCT,BRID,TLID)
           values (SEQ_VSD_PROCESS_LOG.NEXTVAL,REC.TRFCODE,:NEWVAL.TLTXCD,:NEWVAL.TXNUM,GETCURRDATE,'N',:NEWVAL.MSGACCT,:NEWVAL.BRID,:NEWVAL.TLID);
       END LOOP;
    END IF;
    -- end of PhuongHT edit
    END IF;
exception
  when others then
    plog.error(pkgctx, SQLERRM);
    plog.setEndSection(pkgctx, 'trg_tllog_after');
end;
/
