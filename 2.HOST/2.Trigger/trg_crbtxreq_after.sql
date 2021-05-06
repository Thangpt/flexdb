CREATE OR REPLACE TRIGGER trg_crbtxreq_after
 AFTER
  UPDATE
 ON crbtxreq
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
declare
    pkgctx     plog.log_ctx;
    l_txmsg    tx.msg_rectype;
    l_fomsg     varchar2(4000);
    l_fodetail  varchar2(4000);
    v_strCURRDATE varchar2(20);
    v_errcode VARCHAR2(20);
    v_errmsg VARCHAR2(4000);
begin

    if (:NEW.Status = 'C' Or :NEW.Status = 'E') And (:OLD.Objname = 'NEWFO' OR (:OLD.Objname = '6600' AND :OLD.TRFCODE = 'HOLD')) then

        /*l_txmsg.tltxcd:='HOLD';

        --01  ACCTNO      C
        l_txmsg.txfields ('01').defname   := 'REQUESTID';
        l_txmsg.txfields ('01').TYPE      := 'C';
        l_txmsg.txfields ('01').VALUE     := :NEW.REQID;

        --03  ACCTNO      C
        l_txmsg.txfields ('03').defname   := 'ACCTNO';
        l_txmsg.txfields ('03').TYPE      := 'C';
        l_txmsg.txfields ('03').VALUE     := :NEW.AFACCTNO;

        --10  AMT         N
        l_txmsg.txfields ('10').defname   := 'AMOUNT';
        l_txmsg.txfields ('10').TYPE      := 'N';
        l_txmsg.txfields ('10').VALUE     := :NEW.TXAMT;

        --98  ERRORCODE         C
        l_txmsg.txfields ('98').defname   := 'ERRORCODE';
        l_txmsg.txfields ('98').TYPE      := 'C';
        l_txmsg.txfields ('98').VALUE     := TO_CHAR(:NEW.ERRORCODE);

        if :NEW.Status = 'C' then
            l_txmsg.txfields ('98').VALUE     := '0';
        end if;

        l_txmsg.txfields ('99').defname   := 'ERRORMSG';
        l_txmsg.txfields ('99').TYPE      := 'C';
        l_txmsg.txfields ('99').VALUE     := '';

        l_fomsg := '{"msgtype": "tx5100","txnum" : "<$TXNUM>", "txdate" : "<$TXDATE>", "action" : "A", "tlxtcd" : "tx5104",  "detail" : [ <$DETAIL> ]}';
            --Sinh dien de day sang FO
        l_fodetail := newfo_api.fn_GenFOMsg(l_txmsg);

        SELECT systemnums.C_BATCH_PREFIXED
                         || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                  INTO l_txmsg.txnum
                  FROM DUAL;

        SELECT VARVALUE into v_strCURRDATE FROM SYSVAR  WHERE VARNAME='CURRDATE';
        l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);


        l_fomsg := replace(l_fomsg, '<$TXNUM>',l_txmsg.txnum);
        l_fomsg := replace(l_fomsg, '<$TXDATE>',v_strCURRDATE);
        l_fomsg := replace(l_fomsg, '<$DETAIL>',l_fodetail);

        plog.error(pkgctx, 'trg_crbtxreq_after - before call FO: ' || l_fomsg);

        --Day dien sang FO
        PCK_SYN2FO.prc_callwebservice(l_fomsg, v_errcode, v_errmsg);

        plog.error(pkgctx, 'trg_crbtxreq_after - after call FO: ' || l_fomsg);

        if  v_errcode <> '0' Then
            plog.error(pkgctx, 'trg_crbtxreq_after - v_errcode: ' || v_errcode || ' - ' || v_errmsg);
        END if;*/

        if :NEW.Status = 'E' and  nvl(:NEW.errorcode,'ZZZ') = 'ZZZ' then
            v_errcode := '-1';
        elsif :NEW.Status = 'C' and  nvl(:NEW.errorcode,'ZZZ') = 'ZZZ' then
            v_errcode := '0';
        else
            v_errcode := :NEW.errorcode;
        end if;

        INSERT INTO t_fo_event (AUTOID, TLTXCD,LOGTIME,PROCESSTIME,PROCESS,ERRCODE,ERRMSG,NVALUE,CVALUE)
        VALUES(seq_fo_event.NEXTVAL,'HOLD',systimestamp,systimestamp,'N',v_errcode,NULL,NULL,:NEW.REQID);

    end if;
exception
  when others then
    plog.error(pkgctx, 'trg_crbtxreq_after: ' || SQLERRM);
    plog.setEndSection(pkgctx, 'trg_crbtxreq_after');
end;
/

