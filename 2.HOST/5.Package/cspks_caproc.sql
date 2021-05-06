CREATE OR REPLACE PACKAGE cspks_caproc
IS
    /*----------------------------------------------------------------------------------------------------
     ** Module   : COMMODITY SYSTEM
     ** and is copyrighted by FSS.
     **
     **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
     **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
     **    graphic, optic recording or otherwise, translated in any language or computer language,
     **    without the prior written permission of Financial Software Solutions. JSC.
     **
     **  MODIFICATION HISTORY
     **  Person      Date           Comments
     **  FSS      20-mar-2010    Created
     ** (c) 2008 by Financial Software Solutions. JSC.
     ----------------------------------------------------------------------------------------------------*/

PROCEDURE pr_exec_money_cop_action (p_camastid varchar2, p_errcode in out varchar2);
PROCEDURE pr_exec_sec_cop_action (p_camastid varchar2, p_errcode in out varchar2);
PROCEDURE pr_send_cop_action (p_camastid varchar2, p_errcode in out varchar2);

procedure pr_allocate_right_stock(p_orgorderid varchar2);
PROCEDURE pr_3380_send_cop_action(p_txmsg in tx.msg_rectype,p_err_code  OUT varchar2);
PROCEDURE pr_3350_exec_money_CA(p_txmsg in tx.msg_rectype,p_err_code  OUT varchar2);
PROCEDURE pr_3351_Exec_Sec_CA(p_txmsg in tx.msg_rectype,p_err_code  OUT varchar2);
FUNCTION fn_ExecuteContractCAEvent(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
END;
/
CREATE OR REPLACE PACKAGE BODY cspks_caproc
IS
   -- declare log context
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;


--PROCEDURE pr_exec_money_cop_action (pv_refcursor in out pkg_report.ref_cursor,p_camastid varchar2)--, p_errcode in out varchar2, p_errmessage in out varchar2)
PROCEDURE pr_exec_money_cop_action (p_camastid varchar2, p_errcode in out varchar2)
IS
p_txmsg               tx.msg_rectype;
v_dtCURRDATE date;
v_count number;
v_numcmt number;
i number;
v_tradelot_hsx        NUMBER;
v_tradelot_hnx        NUMBER;
BEGIN
    plog.setbeginsection(pkgctx, 'pr_exec_money_cop_action');
    --open pv_refcursor for
    --    select sysdate from dual;
    --p_errcode:='0';
    --p_errmessage:='';
    select count(1) into v_count
    from camast a, sbsecurities b
    where a.codeid = b.codeid and a.status ='I' and a.deltd<>'Y'
        and (select count(1) from caschd where camastid = a.camastid and status <> 'C' and isCI ='N') >0
        and a.camastid = p_camastid;
    if v_count=0 THEN
        p_errcode:='-1';
        --p_errmessage:='Su kien quyen can thuc hien khong hop le!';
        plog.Error(pkgctx, 'Su kien quyen can thuc hien khong hop le :' || p_camastid );
        plog.setbeginsection(pkgctx, 'pr_exec_money_cop_action');
        return;
    end if;
    
    --Lay thong tin lo default
    BEGIN
      SELECT to_number(varvalue) INTO v_tradelot_hsx FROM sysvar WHERE varname = 'HSX_DEFAULT_TRADELOT';
      SELECT to_number(varvalue) INTO v_tradelot_hnx FROM sysvar WHERE varname = 'HNX_DEFAULT_TRADELOT';
    EXCEPTION WHEN OTHERS THEN
      v_tradelot_hsx := 100;
      v_tradelot_hnx := 100;
    END;
    
    select count(1) into v_count from caexec_temp;
    if v_count=0 then
        --001.Tao du lieu temp de thuc hien
        plog.debug(pkgctx, 'Begin exec caaction :' || p_camastid );
        plog.debug(pkgctx, '  Begin temporary update camast status :' || p_camastid );
        UPDATE CAMAST SET STATUS='X',LASTDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT) WHERE CAMASTID=p_camastid;
        --commit;
        plog.debug(pkgctx, '  End temporary update camast status :' || p_camastid );
        delete from caexec_temp where camastid =p_camastid;
        --commit;
        plog.debug(pkgctx, '  Begin log caexec_temp');
        insert into caexec_temp (TLAUTOID,txnum,autoid, balance, camastid, afacctno, catype, codeid,
               excodeid, qtty, amt, aqtty, aamt, symbol, status,
               seacctno, exseacctno, parvalue, exparvalue, reportdate,
               actiondate, postingdate, description, taskcd, dutyamt,
               fullname, idcode, custodycd,custid,TRADEPLACE, SECTYPE,CAVAT, SCHDVAT)
        SELECT seq_tllog.NEXTVAL,systemnums.C_BATCH_PREFIXED
                                 || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0') txnum, CA.AUTOID, CA.BALANCE, ca.CAMASTID, CA.AFACCTNO,CAMAST.CATYPE, CA.CODEID,
                CA.EXCODEID, CA.QTTY, ROUND(CA.AMT) AMT, ROUND(CA.AQTTY) AQTTY,ROUND(CA.AAMT) AAMT, SYM.SYMBOL, CA.STATUS,
                CASE WHEN camast.catype = '017' THEN CA.AFACCTNO || CA.EXCODEID ELSE CA.AFACCTNO || CA.CODEID END SEACCTNO,
                CASE WHEN camast.catype = '017' THEN CA.AFACCTNO || CA.CODEID else CA.AFACCTNO || (CASE WHEN CAMAST.EXCODEID IS NULL THEN CAMAST.CODEID ELSE CAMAST.EXCODEID END) end EXSEACCTNO,
                SYM.PARVALUE PARVALUE, EXSYM.PARVALUE EXPARVALUE, CAMAST.REPORTDATE REPORTDATE, CAMAST.ACTIONDATE ,CAMAST.ACTIONDATE  POSTINGDATE,
                    camast.description, camast.taskcd,
      (CASE WHEN TYP.VAT='Y' THEN ( CASE WHEN CAMAST.CATYPE IN ('016','023') THEN CAMAST.pitrate*CA.INTAMT/100 ELSE CAMAST.pitrate*CA.AMT/100 END) ELSE 0 END) DUTYAMT,
                       CF.FULLNAME, CF.IDCODE, CF.CUSTODYCD, cf.custid, SYM.TRADEPLACE, SYM.SECTYPE,
                      CAMAST.PITRATEMETHOD CAVAT,(case when CA.PITRATEMETHOD='##' then CAMAST.PITRATEMETHOD else CA.PITRATEMETHOD end) SCHDVAT
                FROM caschd CA,
                    SBSECURITIES SYM, SBSECURITIES EXSYM, CAMAST, AFMAST AF , CFMAST CF , AFTYPE TYP, SYSVAR SYS
                WHERE CA.CAMASTID = CAMAST.CAMASTID AND CAMAST.CODEID = SYM.CODEID
                and camast.camastid =p_camastid
                AND nvl(CAMAST.EXCODEID,CAMAST.CODEID)  = EXSYM.CODEID
                AND CA.AFACCTNO = AF.ACCTNO AND AF.CUSTID = CF.CUSTID
                AND CA.DELTD ='N' AND CA.STATUS ='S' and CAMAST.STATUS ='X' AND CA.ISCI ='N' --AND CA.ISSE='N'
                AND CA.AMT>0 AND CA.ISEXEC='Y'
                AND AF.ACTYPE = TYP.ACTYPE AND SYS.GRNAME='SYSTEM' AND SYS.VARNAME='CADUTY';
        --commit;
        plog.debug(pkgctx, '  End log caexec_temp');
        --002.Thuc hien quyen dua tren du lieu temp
        SELECT TO_DATE (varvalue, systemnums.c_date_format)
                   INTO v_dtCURRDATE
                   FROM sysvar
                   WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
        p_txmsg.msgtype:='T';
        p_txmsg.local:='N';
        p_txmsg.tlid        := systemnums.c_system_userid;
        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                 SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
          INTO p_txmsg.wsname, p_txmsg.ipaddress
        FROM DUAL;
        p_txmsg.off_line    := 'N';
        p_txmsg.deltd       := txnums.c_deltd_txnormal;
        p_txmsg.txstatus    := txstatusnums.c_txcompleted;
        p_txmsg.msgsts      := '0';
        p_txmsg.ovrsts      := '0';
        p_txmsg.batchname   := 'CAEXECBF';
        p_txmsg.txdate:=v_dtCURRDATE;
        p_txmsg.busdate:=v_dtCURRDATE;
        p_txmsg.tltxcd:='3350';

        --*1. Tao tllog
        plog.debug(pkgctx, '  Begin log tllog');
        INSERT /*+ append */ INTO tllogall(autoid, txnum, txdate, txtime, brid, tlid,
                offid, ovrrqs, chid, chkid, tltxcd, ibt, brid2, tlid2, ccyusage,off_line,
                deltd, brdate, busdate, txdesc, ipaddress,wsname, txstatus, msgsts,
                ovrsts, batchname, msgamt,msgacct, chktime, offtime)
        select
               REC.TLAUTOID,
               rec.txnum,--p_txmsg.txnum,
               TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
               TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT),--p_txmsg.txtime,
               substr(rec.AFACCTNO,1,4),--p_txmsg.brid,
               p_txmsg.tlid,
               p_txmsg.offid,
               p_txmsg.ovrrqd,
               p_txmsg.chid,
               p_txmsg.chkid,
               p_txmsg.tltxcd,
               p_txmsg.ibt,
               p_txmsg.brid2,
               p_txmsg.tlid2,
               p_txmsg.ccyusage,
               p_txmsg.off_line,
               p_txmsg.deltd,
               TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
               TO_DATE(p_txmsg.busdate, systemnums.C_DATE_FORMAT),
               rec.DESCRIPTION,--NVL(p_txmsg.txfields('30').value,p_txmsg.txdesc),
               p_txmsg.ipaddress,
               p_txmsg.wsname,
               p_txmsg.txstatus,
               p_txmsg.msgsts,
               p_txmsg.ovrsts,
               p_txmsg.batchname,
               rec.AMT,--p_txmsg.txfields('10').value ,
               rec.AFACCTNO,--p_txmsg.txfields('03').value ,
               decode(p_txmsg.chktime,NULL,TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT),p_txmsg.chktime),
               decode(p_txmsg.offtime,NULL,TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT),p_txmsg.offtime)
        from caexec_temp rec where camastid =p_camastid;
        --commit;
        plog.debug(pkgctx, '  End log tllog');
        --*2. Insert vao tllogall

        --*3. Insert vao cac bang tran
        plog.debug(pkgctx, '  Begin log CITRAN Dr Receiving');
        INSERT  INTO CITRANA(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                select rec.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),rec.AFACCTNO,'0045',ROUND(rec.amt,0),NULL,rec.CAMASTID,p_txmsg.deltd,rec.CAMASTID,seq_CITRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || ''
                from caexec_temp rec where rec.amt>0;
        --commit;
        INSERT  INTO citran_gen (CUSTODYCD,CUSTID,
                                         TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BUSDATE,TRDESC,
                                         TXTIME,BRID,TLID,OFFID,CHID,DFACCTNO,OLD_DFACCTNO,TXTYPE,FIELD,TLLOG_AUTOID,TXDESC)
        select        REC.custodycd, REC.custid,
                      rec.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT), rec.AFACCTNO, '0045', ROUND(rec.amt,0),NULL, rec.CAMASTID, p_txmsg.deltd, rec.CAMASTID,seq_CITRAN.NEXTVAL,p_txmsg.tltxcd, p_txmsg.busdate,'' || '' || '',
                      TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT), p_txmsg.brid, p_txmsg.tlid, p_txmsg.offid, p_txmsg.chid,'' dfacctno,'' old_dfacctno,'D', 'RECEIVING' ,REC.TLAUTOID, rec.DESCRIPTION trdesc
        from caexec_temp rec where rec.amt>0;

        --COMMIT;
        plog.debug(pkgctx, '  End  log CITRAN Dr receiving');

        plog.debug(pkgctx, '  Begin log CITRAN Cr balance thu thue tai TCPH');

        INSERT /*+ append */ INTO CITRANA(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                select rec.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),rec.AFACCTNO,'0012',ROUND(rec.AMT-rec.DUTYAMT,0),NULL,rec.CAMASTID,p_txmsg.deltd,rec.CAMASTID,seq_CITRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || ''
                from caexec_temp rec where camastid =p_camastid and rec.AMT>0 and rec.schdvat='IS';
        --commit;
        INSERT /*+ append */ INTO citran_gen (CUSTODYCD,CUSTID,
                                         TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BUSDATE,TRDESC,
                                         TXTIME,BRID,TLID,OFFID,CHID,DFACCTNO,OLD_DFACCTNO,TXTYPE,FIELD,TLLOG_AUTOID,TXDESC)
        select        REC.custodycd, REC.custid,
                      rec.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),rec.AFACCTNO,'0012',ROUND(rec.AMT-rec.DUTYAMT,0),NULL,rec.CAMASTID,p_txmsg.deltd,rec.CAMASTID,seq_CITRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '',
                      TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT), p_txmsg.brid, p_txmsg.tlid, p_txmsg.offid, p_txmsg.chid,'' dfacctno,'' old_dfacctno,'C', 'BALANCE' ,REC.TLAUTOID, rec.DESCRIPTION trdesc
        from caexec_temp rec where camastid =p_camastid and rec.amt>0 and rec.schdvat='IS';
        --COMMIT;
        plog.debug(pkgctx, '  End log CITRAN Cr balance thu thue tai TCPH');

        plog.debug(pkgctx, '  Begin log CITRAN Cr balance thu thue tai CTy');

        INSERT /*+ append */ INTO CITRANA(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                select rec.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),rec.AFACCTNO,'0012',ROUND(rec.AMT,0),NULL,rec.CAMASTID,p_txmsg.deltd,rec.CAMASTID,seq_CITRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || ''
                from caexec_temp rec where camastid =p_camastid and rec.AMT>0 and rec.schdvat<>'IS';
        --commit;
        INSERT /*+ append */ INTO citran_gen (CUSTODYCD,CUSTID,
                                         TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BUSDATE,TRDESC,
                                         TXTIME,BRID,TLID,OFFID,CHID,DFACCTNO,OLD_DFACCTNO,TXTYPE,FIELD,TLLOG_AUTOID,TXDESC)
        select        REC.custodycd, REC.custid,
                      rec.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),rec.AFACCTNO,'0012',ROUND(rec.AMT,0),NULL,rec.CAMASTID,p_txmsg.deltd,rec.CAMASTID,seq_CITRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '',
                      TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT), p_txmsg.brid, p_txmsg.tlid, p_txmsg.offid, p_txmsg.chid,'' dfacctno,'' old_dfacctno,'C', 'BALANCE' ,REC.TLAUTOID, rec.DESCRIPTION trdesc
        from caexec_temp rec where camastid =p_camastid and rec.amt>0 and rec.schdvat<>'IS';

        INSERT /*+ append */ INTO CITRANA(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                select rec.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),rec.AFACCTNO,'0011',ROUND(rec.DUTYAMT,0),NULL,rec.CAMASTID,p_txmsg.deltd,rec.CAMASTID,seq_CITRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || ''
                from caexec_temp rec where camastid =p_camastid and rec.DUTYAMT>0 and rec.schdvat<>'IS';
        --commit;
        INSERT /*+ append */ INTO citran_gen (CUSTODYCD,CUSTID,
                                         TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BUSDATE,TRDESC,
                                         TXTIME,BRID,TLID,OFFID,CHID,DFACCTNO,OLD_DFACCTNO,TXTYPE,FIELD,TLLOG_AUTOID,TXDESC)
        select        REC.custodycd, REC.custid,
                      rec.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),rec.AFACCTNO,'0011',ROUND(rec.DUTYAMT,0),NULL,rec.CAMASTID,p_txmsg.deltd,rec.CAMASTID,seq_CITRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '',
                      TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT), p_txmsg.brid, p_txmsg.tlid, p_txmsg.offid, p_txmsg.chid,'' dfacctno,'' old_dfacctno,'D', 'BALANCE' ,REC.TLAUTOID, rec.DESCRIPTION trdesc
        from caexec_temp rec where camastid =p_camastid and rec.DUTYAMT>0 and rec.schdvat<>'IS';
        --COMMIT;
        plog.debug(pkgctx, '  End log CITRAN Cr balance thu thue tai CTy');

        --*3. Cap nhat vao bang mast
        plog.debug(pkgctx, '  Begin log Update master table');
        for rec in (select tmp.*, chd.isci, chd.isse from caexec_temp tmp, caschd chd where tmp.autoid = chd.autoid)
        loop
            UPDATE CIMAST
             SET
               BALANCE = BALANCE + (ROUND(rec.AMT-rec.DUTYAMT,0)),
               LASTDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
               RECEIVING = RECEIVING - (ROUND(rec.AMT,0)),
               CRAMT = CRAMT + (ROUND(rec.AMT-rec.DUTYAMT,0)), LAST_CHANGE = SYSTIMESTAMP
            WHERE ACCTNO=rec.AFACCTNO and ROUND(rec.AMT,0)>0;

            if rec.isse='Y' or rec.qtty + rec.aqtty=0 then
                update caschd set isci='Y', status ='C' where autoid = rec.autoid;
            else
                update caschd set isci='Y' where autoid = rec.autoid;
            end if;
        end loop;


        plog.debug(pkgctx, '  End log Update master table');

        --*4. Cap nhat extention
        --Neu khong con dong lich nao can thuc hien tien hoac chung khoan thi chuyen trang thai va backup su kie nquyen
        select count(1) into v_count from caschd
        where ((isci='N' and amt+aamt>0) or (isse='N' and qtty+aqtty>0))
        and camastid = p_camastid  and deltd <>'Y' and isexec='Y'
        AND status <> 'O';
        if v_count=0 then
            UPDATE CAMAST SET STATUS='C',LASTDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT) WHERE CAMASTID=p_camastid;
            --Tinh ap dung cho cac truong hop dac biet
            for rec_mt in (
                select ca.*, sb.symbol from camast ca, sbsecurities sb where ca.codeid= sb.codeid
            )
            loop
                if rec_mt.catype ='012' or rec_mt.catype ='013' then --Tach va gop co phieu
                    UPDATE SBSECURITIES SET PARVALUE = PARVALUE * rec_mt.SPLITRATE WHERE CODEID=rec_mt.codeid;
                elsif rec_mt.catype ='019' then --Chuyen doi san giao dich
                    UPDATE SBSECURITIES SET TRADEPLACE =rec_mt.TOTRADEPLACE WHERE CODEID=rec_mt.codeid;
                    DELETE SECURITIES_TICKSIZE WHERE CODEID=rec_mt.codeid;
                    if rec_mt.TOTRADEPLACE='001' then --san HCM
                        INSERT INTO SECURITIES_TICKSIZE (AUTOID,CODEID,SYMBOL,TICKSIZE,FROMPRICE,TOPRICE,STATUS)
                        VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL,rec_mt.codeid,rec_mt.symbol,100,0,49900,'Y');
                        INSERT INTO securities_ticksize (AUTOID,CODEID,SYMBOL,TICKSIZE,FROMPRICE,TOPRICE,STATUS)
                        VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL,rec_mt.codeid,rec_mt.symbol,500,50000,99500,'Y');
                        INSERT INTO securities_ticksize (AUTOID,CODEID,SYMBOL,TICKSIZE,FROMPRICE,TOPRICE,STATUS)
                        VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL,rec_mt.codeid,rec_mt.symbol,1000,100000,100000000000,'Y');
                        UPDATE  SECURITIES_INFO SET  TRADELOT =v_tradelot_hsx WHERE CODEID = rec_mt.codeid;
                    else
                        INSERT INTO securities_ticksize (AUTOID,CODEID,SYMBOL,TICKSIZE,FROMPRICE,TOPRICE,STATUS)
                        VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL,rec_mt.codeid,rec_mt.symbol,100,0,1000000000,'Y');
                        UPDATE  SECURITIES_INFO SET  TRADELOT =v_tradelot_hnx WHERE CODEID = rec_mt.codeid;
                    end if;
                end if;
            end loop;
            --Thuc hien backup du lieu
            insert into camasthist select * from camast where CAMASTID =p_camastid;--in (select camastid from caexec_temp) and status ='C';
            --commit;
            delete from camast where CAMASTID =p_camastid;-- in (select camastid from caexec_temp) and status ='C';
            --commit;
            insert into caschdhist select * from caschd where camastid =p_camastid;--where autoid in (select autoid from caexec_temp) and status ='C';
            --commit;
            delete from caschd where camastid =p_camastid; --where autoid in (select autoid from caexec_temp) and status ='C';
            --commit;
        else
            --Tra ve trang thai cu cho su kien quyen
            UPDATE CAMAST SET STATUS='I' WHERE CAMASTID=p_camastid;
            p_errcode:='-1';
            --commit;
        end if;
        delete from caexec_temp where camastid =p_camastid;
        --commit;
    end if;
    plog.setendsection(pkgctx, 'pr_exec_money_cop_action');
exception when others then
    p_errcode:='-1';
    --p_errmessage:='Co loi he thong xay ra';
    plog.setendsection(pkgctx, 'pr_exec_money_cop_action');
   --rollback;
    UPDATE CAMAST SET STATUS='I' WHERE CAMASTID=p_camastid;
    --commit;
end;


--PROCEDURE pr_exec_sec_cop_action (pv_refcursor in out pkg_report.ref_cursor,p_camastid varchar2)--, p_errcode in out varchar2, p_errmessage in out varchar2)
PROCEDURE pr_exec_sec_cop_action (p_camastid varchar2, p_errcode in out varchar2)
IS
p_txmsg               tx.msg_rectype;
v_dtCURRDATE date;
v_count number;
v_numcmt number;
i number;
v_RightVATDuty varchar2(100);
v_codeid varchar2(6);
v_tocodeid varchar2(6);
v_righttype varchar2(50);
v_RightConvType number;
v_dblCARATE number;
v_tradelot_hsx        NUMBER;
v_tradelot_hnx        NUMBER;
BEGIN
    plog.setbeginsection(pkgctx, 'pr_exec_sec_cop_action');
    --open pv_refcursor for
    --    select sysdate from dual;
    --p_errcode:='0';
    --p_errmessage:='';
    select count(1) into v_count
    from camast a, sbsecurities b where a.codeid = b.codeid and a.status ='I' and a.deltd<>'Y'
        and (select count(1) from caschd where camastid = a.camastid and status <> 'C' and isSE ='N') >0
        and a.camastid = p_camastid;
    if v_count=0 THEN
        p_errcode:='-1';
        --p_errmessage:='Su kien quyen can thuc hien khong hop le!';
        plog.Error(pkgctx, 'Su kien quyen can thuc hien khong hop le :' || p_camastid );
        plog.setbeginsection(pkgctx, 'pr_exec_sec_cop_action');
        return;
    end if;
    
    --Lay thong tin lo default
    BEGIN
      SELECT to_number(varvalue) INTO v_tradelot_hsx FROM sysvar WHERE varname = 'HSX_DEFAULT_TRADELOT';
      SELECT to_number(varvalue) INTO v_tradelot_hnx FROM sysvar WHERE varname = 'HNX_DEFAULT_TRADELOT';
    EXCEPTION WHEN OTHERS THEN
      v_tradelot_hsx := 100;
      v_tradelot_hnx := 100;
    END;
    
    select count(1) into v_count from caexec_temp where camastid = p_camastid;
    if v_count=0 then
        --001.Tao du lieu temp de thuc hien
        plog.debug(pkgctx, 'Begin exec caaction :' || p_camastid );
        --plog.debug(pkgctx, '  Begin temporary update camast status :' || p_camastid );
        --UPDATE CAMAST SET STATUS='X',LASTDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT) WHERE CAMASTID=p_camastid;
        --commit;
        plog.debug(pkgctx, '  End temporary update camast status :' || p_camastid );
        delete from caexec_temp where camastid =p_camastid;
        --commit;
        plog.debug(pkgctx, '  Begin log caexec_temp');
        insert into caexec_temp (TLAUTOID,txnum,autoid, balance, camastid, afacctno, catype, codeid,
               excodeid, qtty, amt, aqtty, aamt, symbol, status,
               seacctno, exseacctno, parvalue, exparvalue, reportdate,
               actiondate, postingdate, description, taskcd, dutyamt,
               fullname, idcode, custodycd,custid,TRADEPLACE, SECTYPE, PITRATE, TOCODEID)
        /*SELECT seq_tllog.NEXTVAL,systemnums.C_BATCH_PREFIXED
                                 || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0') txnum, CA.AUTOID, CA.BALANCE, ca.CAMASTID, CA.AFACCTNO,CAMAST.CATYPE, CA.CODEID,
                CA.EXCODEID, CA.QTTY, ROUND(CA.AMT) AMT, ROUND(CA.AQTTY) AQTTY,ROUND(CA.AAMT) AAMT, SYM.SYMBOL, CA.STATUS,
                CASE WHEN camast.catype = '017' THEN CA.AFACCTNO || CA.EXCODEID ELSE CA.AFACCTNO || CA.CODEID END SEACCTNO,
                CASE WHEN camast.catype = '017' THEN CA.AFACCTNO || CA.CODEID else CA.AFACCTNO || (CASE WHEN CAMAST.EXCODEID IS NULL THEN CAMAST.CODEID ELSE CAMAST.EXCODEID END) end EXSEACCTNO,
                SYM.PARVALUE PARVALUE, EXSYM.PARVALUE EXPARVALUE, CAMAST.REPORTDATE REPORTDATE, CAMAST.ACTIONDATE ,CAMAST.ACTIONDATE  POSTINGDATE,
                      (CASE WHEN SUBSTR(CF.custodycd,4,1) = 'F' AND CAMAST.catype ='010'
                            THEN to_char( 'Cash dividend, '||SYM.SYMBOL ||', exdate on ' || to_char (camast.reportdate,'DD/MM/YYYY')||', yield ' ||camast.DEVIDENTRATE ||'%, '|| cf.fullname )
                      WHEN NVL(SUBSTR(CF.custodycd,4,1),'C') in('C','P') AND CAMAST.catype ='010'
                            THEN to_char( 'Co tuc bang tien, '||SYM.SYMBOL ||', ngay chot ' || to_char (camast.reportdate,'DD/MM/YYYY')||', ty le ' ||camast.DEVIDENTRATE ||'%, '|| cf.fullname )
                      WHEN SUBSTR(CF.custodycd,4,1) = 'F' AND CAMAST.catype ='011'
                            THEN to_char( 'Dividend in kind, '||SYM.SYMBOL ||' , exdate on ' || to_char (camast.reportdate,'DD/MM/YYYY')||', ratio ' ||camast.DEVIDENTSHARES ||', '|| cf.fullname )
                      WHEN NVL(SUBSTR(CF.custodycd,4,1),'C') in('C','P') AND CAMAST.catype ='011'
                            THEN to_char( 'Co tuc bang co phieu, '||SYM.SYMBOL ||', ngay chot ' || to_char (camast.reportdate,'DD/MM/YYYY')||', ty le ' ||camast.DEVIDENTSHARES ||', '|| cf.fullname )
                      WHEN SUBSTR(CF.custodycd,4,1) = 'F' AND CAMAST.catype ='014'
                            THEN  to_char('Secondary offer shares, '||SYM.SYMBOL ||', Exdate on ' || to_char (camast.reportdate,'DD/MM/YYYY')||', ratio ' ||camast.RIGHTOFFRATE ||', '|| cf.fullname  )
                      WHEN NVL(SUBSTR(CF.custodycd,4,1),'C')  in('C','P') AND CAMAST.catype ='014'
                            THEN  to_char('Co phieu mua them, '||SYM.SYMBOL ||', ngay chot ' || to_char (camast.reportdate,'DD/MM/YYYY')||', ty le ' ||camast.RIGHTOFFRATE ||', '|| cf.fullname  )
                      WHEN NVL(SUBSTR(CF.custodycd,4,1),'C')  in('C','P') AND CAMAST.catype ='021'
                            THEN  to_char('Co phieu thuong, '||SYM.SYMBOL ||', ngay chot ' || to_char (camast.reportdate,'DD/MM/YYYY')||', ty le ' ||camast.DEVIDENTSHARES ||', '|| cf.fullname  )
                      WHEN NVL(SUBSTR(CF.custodycd,4,1),'C')  = 'F' AND CAMAST.catype ='021'
                            THEN  to_char('Bonus share, '||SYM.SYMBOL ||', exdate on ' || to_char (camast.reportdate,'DD/MM/YYYY')||', Rate ' ||camast.DEVIDENTSHARES ||', '|| cf.fullname  )
                      WHEN SUBSTR(CF.custodycd,4,1) = 'F' AND CAMAST.catype ='012'  THEN  to_char('Stock split, '||SYM.SYMBOL ||', exdate on ' || to_char (camast.reportdate,'DD/MM/YYYY')||', ratio ' ||camast.SPLITRATE ||', '|| cf.fullname  )
                      WHEN SUBSTR(CF.custodycd,4,1) = 'F' AND CAMAST.catype ='013'  THEN  to_char('Stock merge, '||SYM.SYMBOL ||', exdate on ' || to_char (camast.reportdate,'DD/MM/YYYY')||', ratio ' ||camast.SPLITRATE ||', '|| cf.fullname  )
                      WHEN NVL(SUBSTR(CF.custodycd,4,1),'C')  in ('C','P') AND CAMAST.catype ='013'  THEN  to_char('Gop co phieu, '||SYM.SYMBOL ||', ngay chot ' || to_char (camast.reportdate,'DD/MM/YYYY')||', ty le ' ||camast.SPLITRATE ||', '|| cf.fullname  )
                      else  camast.description END)description, camast.taskcd,
                      (CASE WHEN TYP.VAT='Y' THEN SYS.VARVALUE*CA.AMT/100 ELSE 0 END) DUTYAMT, CF.FULLNAME, CF.IDCODE, CF.CUSTODYCD, cf.custid, SYM.TRADEPLACE, SYM.SECTYPE
                FROM caschd CA,
                    SBSECURITIES SYM, SBSECURITIES EXSYM, CAMAST, AFMAST AF , CFMAST CF , AFTYPE TYP, SYSVAR SYS
                WHERE CA.CAMASTID = CAMAST.CAMASTID AND CAMAST.CODEID = SYM.CODEID
                and camast.camastid =p_camastid
                AND nvl(CAMAST.EXCODEID,CAMAST.CODEID)  = EXSYM.CODEID
                AND CA.AFACCTNO = AF.ACCTNO AND AF.CUSTID = CF.CUSTID
                AND CA.DELTD ='N' AND CA.STATUS ='S' and CAMAST.STATUS ='X' --AND CA.ISCI ='N'
                AND CA.ISSE='N' AND CA.QTTY>0
                AND AF.ACTYPE = TYP.ACTYPE AND SYS.GRNAME='SYSTEM' AND SYS.VARNAME='CADUTY';*/
        SELECT seq_tllog.NEXTVAL,systemnums.C_BATCH_PREFIXED
                                 || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0') txnum,
               CA.AUTOID, CA.BALANCE, replace(ca.CAMASTID,'.','') CAMASTID, CA.AFACCTNO,ca.catypevalue CATYPE, CA.CODEID,
               CA.EXCODEID, CA.QTTY, ROUND(CA.AMT) AMT, ROUND(CA.AQTTY) AQTTY,ROUND(CA.AAMT) AAMT, CA.SYMBOL, mst.status,
               CA.SEACCTNO,CA.EXSEACCTNO,CA.PARVALUE, CA.EXPARVALUE, CA.REPORTDATE ,CA.ACTIONDATE ,CA.POSTINGDATE,
               CA.description, CA.taskcd,
               CA.DUTYAMT, CA.FULLNAME, CA.IDCODE, CA.CUSTODYCD, cf.custid, SYM.TRADEPLACE, SYM.SECTYPE, CA.PITRATE,
               CASE WHEN NVL(CA.TOCODEID,'A')='A' THEN CA.CODEID ELSE CA.TOCODEID END TOCODEID
        FROM v_ca3351 ca,caschd mst, cfmast cf,sbsecurities sym
        where ca.codeid = sym.codeid and ca.autoid = mst.autoid
              and replace(ca.CAMASTID,'.','')= p_camastid
              and ca.custodycd = cf.custodycd;
        --commit;
        plog.debug(pkgctx, '  End log caexec_temp');
        --002.Thuc hien quyen dua tren du lieu temp
        SELECT TO_DATE (varvalue, systemnums.c_date_format)
                   INTO v_dtCURRDATE
                   FROM sysvar
                   WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
        p_txmsg.msgtype:='T';
        p_txmsg.local:='N';
        p_txmsg.tlid        := systemnums.c_system_userid;
        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                 SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
          INTO p_txmsg.wsname, p_txmsg.ipaddress
        FROM DUAL;
        p_txmsg.off_line    := 'N';
        p_txmsg.deltd       := txnums.c_deltd_txnormal;
        p_txmsg.txstatus    := txstatusnums.c_txcompleted;
        p_txmsg.msgsts      := '0';
        p_txmsg.ovrsts      := '0';
        p_txmsg.batchname   := 'CAEXECBF';
        p_txmsg.txdate:=v_dtCURRDATE;
        p_txmsg.busdate:=v_dtCURRDATE;
        p_txmsg.tltxcd:='3351';

        --*1. Tao tllog
        plog.debug(pkgctx, '  Begin log tllog');
        INSERT /*+ append */ INTO tllogall(autoid, txnum, txdate, txtime, brid, tlid,
                offid, ovrrqs, chid, chkid, tltxcd, ibt, brid2, tlid2, ccyusage,off_line,
                deltd, brdate, busdate, txdesc, ipaddress,wsname, txstatus, msgsts,
                ovrsts, batchname, msgamt,msgacct, chktime, offtime)
        select
               REC.TLAUTOID,
               rec.txnum,--p_txmsg.txnum,
               TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
               TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT),--p_txmsg.txtime,
               substr(rec.AFACCTNO,1,4),--p_txmsg.brid,
               p_txmsg.tlid,
               p_txmsg.offid,
               p_txmsg.ovrrqd,
               p_txmsg.chid,
               p_txmsg.chkid,
               p_txmsg.tltxcd,
               p_txmsg.ibt,
               p_txmsg.brid2,
               p_txmsg.tlid2,
               p_txmsg.ccyusage,
               p_txmsg.off_line,
               p_txmsg.deltd,
               TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
               TO_DATE(p_txmsg.busdate, systemnums.C_DATE_FORMAT),
               rec.DESCRIPTION,--NVL(p_txmsg.txfields('30').value,p_txmsg.txdesc),
               p_txmsg.ipaddress,
               p_txmsg.wsname,
               p_txmsg.txstatus,
               p_txmsg.msgsts,
               p_txmsg.ovrsts,
               p_txmsg.batchname,
               rec.AMT,--p_txmsg.txfields('10').value ,
               rec.AFACCTNO,--p_txmsg.txfields('03').value ,
               decode(p_txmsg.chktime,NULL,TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT),p_txmsg.chktime),
               decode(p_txmsg.offtime,NULL,TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT),p_txmsg.offtime)
        from caexec_temp rec where camastid =p_camastid;
        --commit;
        plog.debug(pkgctx, '  End log tllog');
        --*2. Insert vao tllogall

        --*3. Insert vao cac bang tran
        plog.debug(pkgctx, '  Begin log SETRAN cr Trade');
        INSERT INTO SETRANA(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                select rec.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),rec.SEACCTNO,'0012',ROUND(rec.QTTY,0),NULL,rec.CAMASTID,p_txmsg.deltd,rec.CAMASTID,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || ''
                from caexec_temp rec where camastid =p_camastid and  rec.QTTY>0;
        --commit;
        INSERT INTO setran_gen (CUSTODYCD,CUSTID,
                            TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BUSDATE,TRDESC,
                            TXTIME,BRID,TLID,OFFID,CHID,AFACCTNO,SYMBOL,
                            SECTYPE,TRADEPLACE,TXTYPE,FIELD,CODEID,TLLOG_AUTOID,TXDESC)
        select REC.custodycd, REC.custid,
                      rec.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),rec.SEACCTNO,'0012',ROUND(rec.QTTY,0),NULL,rec.CAMASTID,p_txmsg.deltd,rec.CAMASTID,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '',
            TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT), p_txmsg.brid, p_txmsg.tlid, p_txmsg.offid, p_txmsg.chid,REC.afacctno, REC.symbol,
            REC.sectype, REC.tradeplace, 'C', 'TRADE', REC.codeid ,REC.TLAUTOID, rec.DESCRIPTION trdesc
        from caexec_temp rec where camastid =p_camastid and  rec.QTTY>0;
        --commit;
        plog.debug(pkgctx, '  End  log SETRAN cr trade');
        plog.debug(pkgctx, '  Begin log SETRAN dr receiving');
        INSERT INTO SETRANA(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                select rec.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),rec.SEACCTNO,'0015',ROUND(rec.QTTY,0),NULL,rec.CAMASTID,p_txmsg.deltd,rec.CAMASTID,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || ''
                from caexec_temp rec where rec.QTTY>0;
        --commit;
        INSERT INTO setran_gen (CUSTODYCD,CUSTID,
                            TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BUSDATE,TRDESC,
                            TXTIME,BRID,TLID,OFFID,CHID,AFACCTNO,SYMBOL,
                            SECTYPE,TRADEPLACE,TXTYPE,FIELD,CODEID,TLLOG_AUTOID,TXDESC)
        select REC.custodycd, REC.custid,
                      rec.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),rec.SEACCTNO,'0015',ROUND(rec.QTTY,0),NULL,rec.CAMASTID,p_txmsg.deltd,rec.CAMASTID,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '',
            TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT), p_txmsg.brid, p_txmsg.tlid, p_txmsg.offid, p_txmsg.chid,REC.afacctno, REC.symbol,
            REC.sectype, REC.tradeplace, 'D', 'RECEIVING', REC.codeid ,REC.TLAUTOID, rec.DESCRIPTION trdesc
        from caexec_temp rec where rec.QTTY>0;
        --commit;
        plog.debug(pkgctx, '  End  log SETRAN dr receiving');
        plog.debug(pkgctx, '  Begin log SETRAN dr trade aqtty');
        INSERT INTO SETRANA(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                select rec.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),rec.EXSEACCTNO,'0040',ROUND(rec.AQTTY,0),NULL,rec.CAMASTID,p_txmsg.deltd,rec.CAMASTID,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || ''
                from caexec_temp rec where camastid =p_camastid and  rec.AQTTY>0;
        --commit;
        INSERT INTO setran_gen (CUSTODYCD,CUSTID,
                            TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BUSDATE,TRDESC,
                            TXTIME,BRID,TLID,OFFID,CHID,AFACCTNO,SYMBOL,
                            SECTYPE,TRADEPLACE,TXTYPE,FIELD,CODEID,TLLOG_AUTOID,TXDESC)
        select REC.custodycd, REC.custid,
                      rec.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),rec.EXSEACCTNO,'0040',ROUND(rec.AQTTY,0),NULL,rec.CAMASTID,p_txmsg.deltd,rec.CAMASTID,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '',
            TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT), p_txmsg.brid, p_txmsg.tlid, p_txmsg.offid, p_txmsg.chid,REC.afacctno, REC.symbol,
            REC.sectype, REC.tradeplace, 'D', 'TRADE', REC.codeid ,REC.TLAUTOID, rec.DESCRIPTION trdesc
        from caexec_temp rec where camastid =p_camastid and  rec.AQTTY>0;
        --commit;
        plog.debug(pkgctx, '  End  log SETRAN dr trade aqtty');

        --- HaiLT them de cap nhap vao SEPITLOG de phan bo chung khoan quyen su dung cho tinh thue TNCN
        --- doi voi CATYPE is gc_CA_CATYPE_STOCK_DIVIDEND OR gc_CA_CATYPE_KIND_STOCK

        SELECT VARVALUE INTO v_RightVATDuty FROM sysvar WHERE GRNAME='SYSTEM' AND VARNAME='RIGHTVATDUTY';

        INSERT INTO SEPITLOG(AUTOID,TXDATE,TXNUM,QTTY,MAPQTTY,CODEID,CAMASTID,ACCTNO,MODIFIEDDATE,AFACCTNO,PRICE,PITRATE)
                select SEQ_SEPITLOG.NEXTVAL, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT), rec.txnum,ROUND(rec.QTTY,0),0,
                --case when rec.catype='009' then rec.tocodeid else rec.codeid end codeid,
                 rec.tocodeid codeid,
                    rec.camastid, rec.afacctno||rec.tocodeid, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT), rec.afacctno,0, rec.pitrate
                from caexec_temp rec where camastid =p_camastid and  INSTR(v_RightVATDuty,rec.catype) > 0 ;

        --- End of HaiLT them de cap nhap vao SEPITLOG de phan bo chung khoan quyen su dung cho tinh thue TNCN

        --HaiLT them de update trong SEPITLOG doi voi nhung quyen chuyen co phieu sang co phieu khac

        SELECT nvl(instr((SELECT VARVALUE FROM sysvar WHERE GRNAME='SYSTEM' AND VARNAME='RIGHTCONVERTTYPE'),catype),0) into v_RightConvType  FROM CAMAST WHERE CAMASTID= p_camastid;
/*
        if v_RightConvType>0 then
            select codeid, tocodeid into v_codeid, v_tocodeid from caexec_temp where camastid =p_camastid;
            UPDATE SEPITLOG SET PCAMASTID=CAMASTID, CAMASTID= p_camastid, CODEID = v_tocodeid WHERE CODEID= v_codeid;
        end if;

*/
        begin
          select codeid, tocodeid into v_codeid, v_tocodeid from caexec_temp where camastid =p_camastid;

          SELECT VARVALUE into v_righttype FROM SYSVAR WHERE VARNAME='RIGHTCONVERTTYPE';


            if v_RightConvType>0 then

                for rec in (
                    SELECT * FROM SEPITLOG WHERE  CAMASTID=p_camastid AND
                        CAMASTID IN (SELECT CAMASTID  FROM CAMAST WHERE INSTR(v_righttype,CATYPE)>0 )
                    )
                loop
                    SELECT to_number(substr(DEVIDENTSHARES,0,instr(DEVIDENTSHARES,'/')-1)) / to_number(substr(DEVIDENTSHARES,instr(DEVIDENTSHARES,'/')+1)) into v_dblCARATE FROM CAMAST WHERE CAMASTID=p_camastid;

                    if rec.MAPQTTY>0 then
                        --- v_CARATE Ti le chia moi khi chuyen sang co phieu khac, de tinh lai so co phieu ban dau
                        --- Co phieu chua phan bo = co phieu chua phan bo x ti le chia (v_dblCARATE)
                        insert into sepitlog (AUTOID,TXDATE,TXNUM,QTTY,MAPQTTY,CODEID,PCAMASTID,CAMASTID,ACCTNO,MODIFIEDDATE,AFACCTNO,PRICE,PITRATE,CARATE)
                          values(SEQ_SEPITLOG.NEXTVAL, TO_DATE (rec.txdate, 'DD/MM/RRRR'),'', to_number(rec.QTTY-rec.MAPQTTY) * v_dblCARATE,0, v_tocodeid, rec.CAMASTID,p_txmsg.txfields('02').value,
                              rec.ACCTNO, TO_DATE (p_txmsg.txdate, 'DD/MM/RRRR'), rec.AFACCTNO, rec.PRICE, rec.PITRATE,to_number(nvl(rec.CARATE,1)) * v_dblCARATE) ;

                        UPDATE SEPITLOG SET QTTY=MAPQTTY
                            WHERE AUTOID=rec.AUTOID;

                    else

                        UPDATE SEPITLOG SET PCAMASTID=CAMASTID, QTTY= to_number(QTTY*v_dblCARATE),
                                CAMASTID= p_txmsg.txfields('02').value,
                                CODEID = v_tocodeid, CARATE=to_number(nvl(rec.CARATE,1)) * v_dblCARATE
                            WHERE AUTOID=rec.AUTOID;
                    end if;

                end loop;

            end if;
        exception when others then
            null;
        end;







        --END of HaiLT them de update trong SEPITLOG doi voi nhung quyen chuyen co phieu sang co phieu khac

        --*3. Cap nhat vao bang mast
        plog.debug(pkgctx, '  Begin log Update master table');
        for rec in (select tmp.*, chd.isci, chd.isse from caexec_temp tmp, caschd chd where tmp.autoid = chd.autoid)
        loop
            UPDATE SEMAST
             SET
               TRADE = TRADE - (ROUND(rec.AQTTY,0)), LAST_CHANGE = SYSTIMESTAMP
            WHERE ACCTNO=rec.EXSEACCTNO and rec.aqtty>0;

            UPDATE SEMAST
             SET
               TRADE = TRADE + (ROUND(rec.QTTY,0)),
               RECEIVING = RECEIVING - (ROUND(rec.QTTY,0)), LAST_CHANGE = SYSTIMESTAMP
            WHERE ACCTNO=rec.SEACCTNO and rec.QTTY>0;

            if rec.isci='Y' or rec.amt + rec.aamt=0 then
                update caschd set isse='Y', status ='C' where autoid = rec.autoid;
            else
                update caschd set isse='Y' where autoid = rec.autoid;
            end if;
        end loop;


        plog.debug(pkgctx, '  End log Update master table');

        --*4. Cap nhat extention
        --Neu khong con dong lich nao can thuc hien tien hoac chung khoan thi chuyen trang thai va backup su kie nquyen
        select count(1) into v_count from caschd
        where ((isci='N' and amt+aamt>0) or (isse='N' and qtty+aqtty>0))
        and camastid = p_camastid  and deltd <>'Y'
        AND status <> 'O';
        if v_count=0 then
            UPDATE CAMAST SET STATUS='C',LASTDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT) WHERE CAMASTID=p_camastid;
            --Tinh ap dung cho cac truong hop dac biet
            for rec_mt in (
                select ca.*, sb.symbol from camast ca, sbsecurities sb where ca.codeid= sb.codeid
            )
            loop
                if rec_mt.catype ='012' or rec_mt.catype ='013' then --Tach va gop co phieu
                    UPDATE SBSECURITIES SET PARVALUE = PARVALUE * rec_mt.SPLITRATE WHERE CODEID=rec_mt.codeid;
                elsif rec_mt.catype ='019' then --Chuyen doi san giao dich
                    UPDATE SBSECURITIES SET TRADEPLACE =rec_mt.TOTRADEPLACE WHERE CODEID=rec_mt.codeid;
                    DELETE SECURITIES_TICKSIZE WHERE CODEID=rec_mt.codeid;
                    if rec_mt.TOTRADEPLACE='001' then --san HCM
                        INSERT INTO SECURITIES_TICKSIZE (AUTOID,CODEID,SYMBOL,TICKSIZE,FROMPRICE,TOPRICE,STATUS)
                        VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL,rec_mt.codeid,rec_mt.symbol,100,0,49900,'Y');
                        INSERT INTO securities_ticksize (AUTOID,CODEID,SYMBOL,TICKSIZE,FROMPRICE,TOPRICE,STATUS)
                        VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL,rec_mt.codeid,rec_mt.symbol,500,50000,99500,'Y');
                        INSERT INTO securities_ticksize (AUTOID,CODEID,SYMBOL,TICKSIZE,FROMPRICE,TOPRICE,STATUS)
                        VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL,rec_mt.codeid,rec_mt.symbol,1000,100000,100000000000,'Y');
                        UPDATE  SECURITIES_INFO SET  TRADELOT =v_tradelot_hsx WHERE CODEID = rec_mt.codeid;
                    else
                        INSERT INTO securities_ticksize (AUTOID,CODEID,SYMBOL,TICKSIZE,FROMPRICE,TOPRICE,STATUS)
                        VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL,rec_mt.codeid,rec_mt.symbol,100,0,1000000000,'Y');
                        UPDATE  SECURITIES_INFO SET  TRADELOT =v_tradelot_hnx WHERE CODEID = rec_mt.codeid;
                    end if;
                end if;
            end loop;
            --Thuc hien backup du lieu
            insert into camasthist select * from camast where CAMASTID =p_camastid;-- in (select camastid from caexec_temp) and status ='C';
            --commit;
            delete from camast where CAMASTID  =p_camastid;--in (select camastid from caexec_temp) and status ='C';
            --commit;
            insert into caschdhist select * from caschd where camastid  =p_camastid;--autoid in (select autoid from caexec_temp) and status ='C';
            --commit;
            delete from caschd where camastid =p_camastid;--autoid in (select autoid from caexec_temp) and status ='C';
            --commit;
        else
            --Tra ve trang thai cu cho su kien quyen
            --UPDATE CAMAST SET STATUS='I' WHERE CAMASTID=p_camastid;
            plog.debug(pkgctx,'Dang chay su kien khac');
            p_errcode:='-1';
            --commit;
        end if;
        delete from caexec_temp where camastid =p_camastid;
        --commit;
    end if;
    plog.setendsection(pkgctx, 'pr_exec_sec_cop_action');
exception when others then
    p_errcode:='-1';
    --p_errmessage:='Co loi he thong xay ra';
    plog.setendsection(pkgctx, 'pr_exec_sec_cop_action');
   --rollback;
    UPDATE CAMAST SET STATUS='I' WHERE CAMASTID=p_camastid;
    --commit;
end;

--PROCEDURE pr_send_cop_action (pv_refcursor in out pkg_report.ref_cursor,p_camastid varchar2)--, p_errcode in out varchar2, p_errmessage in out varchar2)
PROCEDURE pr_send_cop_action (p_camastid varchar2, p_errcode in out varchar2)
IS
p_txmsg               tx.msg_rectype;
v_dtCURRDATE date;
v_count number;
v_numcmt number;
i number;
BEGIN
    plog.setbeginsection(pkgctx, 'pr_send_cop_action');
    --open pv_refcursor for
    --    select sysdate from dual;
    --p_errcode:='0';
    --p_errmessage:='';
    select count(1) into v_count
    from camast a, sbsecurities b where a.codeid = b.codeid and a.status IN ('A','S','M') and a.deltd='N'
        and a.camastid = p_camastid;
    if v_count=0 THEN
        p_errcode:='-1';
        --p_errmessage:='Su kien quyen can xac nhan khong hop le!';
        plog.Error(pkgctx, 'Su kien quyen can xac nhan khong hop le :' || p_camastid );
        plog.setbeginsection(pkgctx, 'pr_send_cop_action');
        return;
    end if;
    select count(1) into v_count from casend_temp;
    if v_count=0 then
        --001.Tao du lieu temp de thuc hien
        plog.debug(pkgctx, 'Begin send caaction :' || p_camastid );
        plog.debug(pkgctx, '  Begin temporary update camast status :' || p_camastid );
        --UPDATE CAMAST SET STATUS='X',LASTDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT) WHERE CAMASTID=p_camastid;
        --commit;
        plog.debug(pkgctx, '  End temporary update camast status :' || p_camastid );
        delete from casend_temp where camastid =p_camastid;
        --commit;
        plog.debug(pkgctx, '  Begin log casend_temp');
       insert into casend_temp (tlautoid, txnum, autoid, balance, camastid, afacctno,
       catype, codeid, excodeid, qtty, amt, aqtty, aamt,
       symbol, status, statuscd, seacctno, exseacctno,
       parvalue, exparvalue, reportdate, actiondate,
       description, custodycd, fullname, idcode, isrightoff,custid,TRADEPLACE, SECTYPE)
       SELECT seq_tllog.NEXTVAL,systemnums.C_BATCH_PREFIXED
                                 || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0') txnum,
               ca.autoid, ca.balance, replace(ca.camastid,'.','') camastid, ca.afacctno,
               ca.catype, ca.codeid, ca.excodeid, ca.qtty, ca.amt, ca.aqtty, ca.aamt,
               ca.symbol, ca.status, ca.statuscd, ca.seacctno, ca.exseacctno,
               ca.parvalue, ca.exparvalue, ca.reportdate, ca.actiondate,
               ca.description, ca.custodycd, ca.fullname, ca.idcode, ca.isrightoff, af.custid, sb.tradeplace, sb.sectype
        FROM v_ca3380 CA, afmast af, sbsecurities sb where ca.afacctno = af.acctno and replace(ca.camastid,'.','') =p_camastid
            and ca.codeid = sb.codeid;
        --commit;
        plog.debug(pkgctx, '  End log casend_temp');
        --002.Thuc hien quyen dua tren du lieu temp
        SELECT TO_DATE (varvalue, systemnums.c_date_format)
                   INTO v_dtCURRDATE
                   FROM sysvar
                   WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
        p_txmsg.msgtype:='T';
        p_txmsg.local:='N';
        p_txmsg.tlid        := systemnums.c_system_userid;
        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                 SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
          INTO p_txmsg.wsname, p_txmsg.ipaddress
        FROM DUAL;
        p_txmsg.off_line    := 'N';
        p_txmsg.deltd       := txnums.c_deltd_txnormal;
        p_txmsg.txstatus    := txstatusnums.c_txcompleted;
        p_txmsg.msgsts      := '0';
        p_txmsg.ovrsts      := '0';
        p_txmsg.batchname   := 'CAEXECBF';
        p_txmsg.txdate:=v_dtCURRDATE;
        p_txmsg.busdate:=v_dtCURRDATE;
        p_txmsg.tltxcd:='3380';

        --*1. Tao tllog
        plog.debug(pkgctx, '  Begin log tllog');
        INSERT /*+ append */ INTO tllogall(autoid, txnum, txdate, txtime, brid, tlid,
                offid, ovrrqs, chid, chkid, tltxcd, ibt, brid2, tlid2, ccyusage,off_line,
                deltd, brdate, busdate, txdesc, ipaddress,wsname, txstatus, msgsts,
                ovrsts, batchname, msgamt,msgacct, chktime, offtime)
        select
               REC.TLAUTOID,
               rec.txnum,--p_txmsg.txnum,
               TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
               TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT),--p_txmsg.txtime,
               substr(rec.AFACCTNO,1,4),--p_txmsg.brid,
               p_txmsg.tlid,
               p_txmsg.offid,
               p_txmsg.ovrrqd,
               p_txmsg.chid,
               p_txmsg.chkid,
               p_txmsg.tltxcd,
               p_txmsg.ibt,
               p_txmsg.brid2,
               p_txmsg.tlid2,
               p_txmsg.ccyusage,
               p_txmsg.off_line,
               p_txmsg.deltd,
               TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
               TO_DATE(p_txmsg.busdate, systemnums.C_DATE_FORMAT),
               rec.DESCRIPTION,--NVL(p_txmsg.txfields('30').value,p_txmsg.txdesc),
               p_txmsg.ipaddress,
               p_txmsg.wsname,
               p_txmsg.txstatus,
               p_txmsg.msgsts,
               p_txmsg.ovrsts,
               p_txmsg.batchname,
               rec.AMT,--p_txmsg.txfields('10').value ,
               rec.AFACCTNO,--p_txmsg.txfields('03').value ,
               decode(p_txmsg.chktime,NULL,TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT),p_txmsg.chktime),
               decode(p_txmsg.offtime,NULL,TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT),p_txmsg.offtime)
        from casend_temp rec where camastid =p_camastid;
        --commit;
        plog.debug(pkgctx, '  End log tllog');
        --*2. Insert vao tllogall

        --*3. Insert vao cac bang tran
        plog.debug(pkgctx, '  Begin log CITRAN Cr Receiving');
        INSERT  INTO CITRANA(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                select rec.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),rec.AFACCTNO,'0046',ROUND(rec.amt,0),NULL,rec.CAMASTID,p_txmsg.deltd,rec.CAMASTID,seq_CITRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || ''
                from casend_temp rec where rec.amt>0;
        --commit;
        INSERT  INTO citran_gen (CUSTODYCD,CUSTID,
                                         TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BUSDATE,TRDESC,
                                         TXTIME,BRID,TLID,OFFID,CHID,DFACCTNO,OLD_DFACCTNO,TXTYPE,FIELD,TLLOG_AUTOID,TXDESC)
        select        REC.custodycd, REC.custid,
                      rec.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT), rec.AFACCTNO, '0046', ROUND(rec.amt,0),NULL, rec.CAMASTID, p_txmsg.deltd, rec.CAMASTID,seq_CITRAN.NEXTVAL,p_txmsg.tltxcd, p_txmsg.busdate,'' || '' || '',
                      TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT), p_txmsg.brid, p_txmsg.tlid, p_txmsg.offid, p_txmsg.chid,'' dfacctno,'' old_dfacctno,'C', 'RECEIVING' ,REC.TLAUTOID, rec.DESCRIPTION trdesc
        from casend_temp rec where rec.amt>0;

        --COMMIT;
        plog.debug(pkgctx, '  End  log CITRAN Cr receiving');

        plog.debug(pkgctx, '  Begin log SETRAN cr receiving');
        INSERT INTO SETRANA(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                select rec.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),rec.SEACCTNO,'0016',ROUND(rec.QTTY,0),NULL,rec.CAMASTID,p_txmsg.deltd,rec.CAMASTID,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || ''
                from casend_temp rec where rec.QTTY>0;
        --commit;
        INSERT INTO setran_gen (CUSTODYCD,CUSTID,
                            TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BUSDATE,TRDESC,
                            TXTIME,BRID,TLID,OFFID,CHID,AFACCTNO,SYMBOL,
                            SECTYPE,TRADEPLACE,TXTYPE,FIELD,CODEID,TLLOG_AUTOID,TXDESC)
        select REC.custodycd, REC.custid,
                      rec.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),rec.SEACCTNO,'0016',ROUND(rec.QTTY,0),NULL,rec.CAMASTID,p_txmsg.deltd,rec.CAMASTID,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '',
            TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT), p_txmsg.brid, p_txmsg.tlid, p_txmsg.offid, p_txmsg.chid,REC.afacctno, REC.symbol,
            REC.sectype, REC.tradeplace, 'C', 'RECEIVING', REC.codeid ,REC.TLAUTOID, rec.DESCRIPTION trdesc
        from casend_temp rec where rec.QTTY>0;
        --commit;
        plog.debug(pkgctx, '  End  log SETRAN cr receiving');

        plog.debug(pkgctx, '  Begin log SETRAN cr netting');
        INSERT INTO SETRANA(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                select rec.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),rec.EXSEACCTNO,'0019',ROUND(rec.AQTTY,0),NULL,rec.CAMASTID,p_txmsg.deltd,rec.CAMASTID,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || ''
                from casend_temp rec where rec.AQTTY>0;
        --commit;
        INSERT INTO setran_gen (CUSTODYCD,CUSTID,
                            TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BUSDATE,TRDESC,
                            TXTIME,BRID,TLID,OFFID,CHID,AFACCTNO,SYMBOL,
                            SECTYPE,TRADEPLACE,TXTYPE,FIELD,CODEID,TLLOG_AUTOID,TXDESC)
        select REC.custodycd, REC.custid,
                      rec.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),rec.EXSEACCTNO,'0019',ROUND(rec.AQTTY,0),NULL,rec.CAMASTID,p_txmsg.deltd,rec.CAMASTID,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '',
            TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT), p_txmsg.brid, p_txmsg.tlid, p_txmsg.offid, p_txmsg.chid,REC.afacctno, REC.symbol,
            REC.sectype, REC.tradeplace, 'C', 'NETTING', REC.codeid ,REC.TLAUTOID, rec.DESCRIPTION trdesc
        from casend_temp rec where rec.AQTTY>0;
        --commit;
        plog.debug(pkgctx, '  End  log SETRAN cr netting');

        --*3. Cap nhat vao bang mast
        plog.debug(pkgctx, '  Begin log Update master table');
        for rec in (
            --select * from caschd where camastid=p_camastid and status ='A' and deltd <> 'Y'
            select * from casend_temp where camastid=p_camastid
        )
        loop
            update cimast set receiving = receiving + ROUND(rec.amt,0) where acctno = rec.afacctno;
            update semast set receiving = receiving + ROUND(rec.QTTY,0) where acctno =rec.SEACCTNO;--afacctno = rec.afacctno and  codeid = rec.codeid;
            update semast set NETTING = NETTING + ROUND(rec.AQTTY,0) where acctno =rec.EXSEACCTNO;--afacctno = rec.afacctno and codeid = rec.excodeid;
        end loop;

        update caschd set status ='S' where camastid = p_camastid and deltd <> 'Y';-- and status ='A';
        update camast set status ='S' where camastid = p_camastid and deltd <> 'Y';-- and status ='X';
    end if;
    delete from casend_temp where camastid =p_camastid;
    --commit;
    plog.setendsection(pkgctx, 'pr_exec_money_cop_action');

exception when others then
    p_errcode:='-1';
    --p_errmessage:='Co loi he thong xay ra';
    plog.setendsection(pkgctx, 'pr_exec_money_cop_action');
   --rollback;
    --UPDATE CAMAST SET STATUS='A' WHERE CAMASTID=p_camastid;
    --commit;
end;


/*PROCEDURE pr_allocate_right_stock(p_orgorderid varchar2)
   IS
   v_dtCURRDATE DATE;
   v_parvalue number(20,4);
   v_dblPrice number(20,4);
   v_dblDelPrice number(20,4);
   v_dblDelMatchQtty number(20,4);
   v_deltd varchar2(1);
   v_recSTSCHD number(20,4);
   v_rec number(20,4);
BEGIN
---
    plog.setbeginsection(pkgctx, 'pr_allocate_right_stock');

    SELECT TO_DATE (varvalue, systemnums.c_date_format)
                   INTO v_dtCURRDATE
                   FROM sysvar
                   WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

    plog.debug (pkgctx, 'begin pr_allocate_right_stock ' ||v_dtCURRDATE );


    SELECT DELTD,MATCHPRICE,MATCHQTTY into v_deltd,v_dblDelPrice,v_dblDelMatchQtty FROM
        (SELECT * FROM IOD WHERE ORGORDERID=p_orgorderid ORDER BY TXTIME DESC) WHERE ROWNUM=1 ;
        plog.debug (pkgctx, 'pr_allocate_right_stock, DELTD= ' ||v_deltd );
    ---Xoa lenh khop thi cap nhap lai ARIGHT va RIGHTQTTY
    if v_deltd<>'N' then

        for recSTSCHD in (
            SELECT * FROM (
                SELECT * FROM STSCHD WHERE DUETYPE='RM' AND TXDATE= v_dtCURRDATE and orgorderid=p_orgorderid ORDER BY AUTOID DESC ) WHERE ROWNUM=1
        )
        LOOP
            SELECT PARVALUE INTO v_parvalue from sbsecurities where codeid=recSTSCHD.codeid;

            if v_dblDelPrice < v_parvalue then
                v_parvalue := v_dblDelPrice;
            end if;

            for rec in (
                SELECT * FROM SEPITLOG WHERE AFACCTNO=recSTSCHD.afacctno AND CODEID=recSTSCHD.codeid AND MAPQTTY>0 ORDER BY TXDATE, AUTOID
            )
            loop
                --- Neu so luong da phan bo > so luong xoa' khop
                if v_dblDelMatchQtty <= rec.MAPQTTY then
                    UPDATE STSCHD SET RIGHTQTTY= RIGHTQTTY - v_dblDelMatchQtty, ARIGHT=ARIGHT - v_dblDelMatchQtty * rec.CARATE * v_parvalue * rec.PITRATE/100
                        WHERE AUTOID=recSTSCHD.AUTOID;

                    UPDATE SEPITLOG SET MAPQTTY= MAPQTTY - v_dblDelMatchQtty, STATUS='N'  WHERE AUTOID=rec.AUTOID;

                    DELETE FROM SEPITALLOCATE WHERE CAMASTID = rec.CAMASTID AND AFACCTNO = rec.AFACCTNO AND CODEID = rec.CODEID AND
                        ORGORDERID = p_orgorderid AND QTTY= v_dblDelMatchQtty AND TXNUM = rec.TXNUM;

                    exit;

                else

                    UPDATE STSCHD SET RIGHTQTTY= RIGHTQTTY- rec.MAPQTTY, ARIGHT=ARIGHT - rec.MAPQTTY * rec.CARATE * v_parvalue * rec.PITRATE/100
                        WHERE AUTOID=recSTSCHD.AUTOID;

                    UPDATE SEPITLOG SET MAPQTTY= MAPQTTY - rec.MAPQTTY, STATUS='N'  WHERE AUTOID=rec.AUTOID;

                    DELETE FROM SEPITALLOCATE WHERE CAMASTID = rec.CAMASTID AND AFACCTNO = rec.AFACCTNO AND CODEID = rec.CODEID AND
                        ORGORDERID = p_orgorderid AND QTTY= rec.MAPQTTY AND TXNUM = rec.TXNUM;

                    v_dblDelMatchQtty:=v_dblDelMatchQtty - rec.MAPQTTY;

                end if;

            end loop;

        END LOOP;


    else -- lenh khop

        for recSTSCHD in (
            SELECT * FROM STSCHD WHERE DUETYPE='RM' AND STATUS='N' AND TXDATE= v_dtCURRDATE  AND
                AFACCTNO IN (SELECT AFACCTNO FROM SEPITLOG WHERE STATUS <>'C' AND DELTD <>'Y') and orgorderid=p_orgorderid
                 --   ORDER BY AFACCTNO,CODEID,ORGORDERID
        )
        LOOP

            plog.debug (pkgctx, 'LOOP recSTSCHD' || recSTSCHD.orgorderid);

            SELECT PARVALUE INTO v_parvalue from sbsecurities where codeid=recSTSCHD.codeid;


            SELECT MATCHPRICE INTO v_dblPrice FROM (
                SELECT * FROM IOD WHERE ORGORDERID=p_orgorderid ORDER BY TXTIME DESC) WHERE ROWNUM=1 ;
            plog.debug (pkgctx, 'MATCH: ' || v_dblPrice);

            --Lay them gia khop
            --if recSTSCHD.amt/recSTSCHD.qtty < v_parvalue then
            plog.debug (pkgctx, 'v_parvalue: ' || v_parvalue);
            if v_dblPrice<v_parvalue then
                --v_parvalue:=recSTSCHD.amt/recSTSCHD.qtty;
                v_parvalue:=v_dblPrice;
            end if;

            v_recSTSCHD:=recSTSCHD.QTTY - recSTSCHD.RIGHTQTTY;

            for rec in (
                SELECT * FROM SEPITLOG WHERE AFACCTNO=recSTSCHD.afacctno AND CODEID=recSTSCHD.codeid AND QTTY-MAPQTTY>0 ORDER BY TXDATE, AUTOID
                    --AND STATUS <> 'C' AND DELTD <> 'Y'

            )
            loop
                 plog.debug (pkgctx, 'LOOP rec KL Khop : ' || recSTSCHD.QTTY || ' - ' || recSTSCHD.RIGHTQTTY ||
                 '        KL REC: ' || rec.QTTY || ' - ' ||rec.MAPQTTY);

--                 v_rec:=rec.QTTY-rec.MAPQTTY;

                IF v_recSTSCHD < rec.QTTY-rec.MAPQTTY then

                    plog.debug (pkgctx, 'LOOP rec 1' || recSTSCHD.orgorderid || ' KL Khop: ' || recSTSCHD.QTTY || ' - ' || recSTSCHD.RIGHTQTTY);

                    UPDATE STSCHD SET RIGHTQTTY= RIGHTQTTY + v_recSTSCHD,
                        ARIGHT = ARIGHT + v_recSTSCHD * rec.CARATE * v_parvalue * rec.PITRATE/100
                        WHERE DUETYPE='RM' AND ORGORDERID=recSTSCHD.orgorderid AND AFACCTNO=rec.afacctno AND CODEID=rec.codeid AND
                        DELTD <> 'Y' AND STATUS='N';

                    UPDATE SEPITLOG SET MAPQTTY= MAPQTTY + v_recSTSCHD
                        WHERE AFACCTNO=rec.afacctno AND CODEID=rec.codeid AND TXDATE= rec.txdate AND TXNUM=rec.txnum;

                    INSERT INTO SEPITALLOCATE (CAMASTID,AFACCTNO,CODEID,PITRATE,QTTY,PRICE,ARIGHT,ORGORDERID,TXNUM,TXDATE,CARATE) VALUES(
                            rec.CAMASTID, rec.AFACCTNO, rec.CODEID, rec.PITRATE,v_recSTSCHD, v_parvalue, v_recSTSCHD * rec.CARATE * v_parvalue * rec.PITRATE/100,
                            recSTSCHD.orgorderid, rec.TXNUM,recSTSCHD.TXDATE,rec.CARATE);

                    EXIT;

                else --recSTSCHD.QTTY  - recSTSCHD.RIGHTQTTY >= rec.QTTY-rec.MAPQTTY then
                    plog.debug (pkgctx, 'LOOP rec 2  KL Khop: ' || rec.qtty || ' - ' || rec.mapqtty);

                    UPDATE STSCHD SET RIGHTQTTY = RIGHTQTTY + rec.qtty - rec.mapqtty,
                        ARIGHT = ARIGHT + (rec.qtty - rec.mapqtty) * rec.CARATE * v_parvalue * rec.PITRATE/100
                        WHERE DUETYPE='RM' AND ORGORDERID=recSTSCHD.orgorderid AND AFACCTNO=rec.afacctno AND CODEID=rec.codeid AND
                        DELTD <> 'Y' AND STATUS='N';

                    UPDATE SEPITLOG SET MAPQTTY = MAPQTTY + rec.qtty - rec.mapqtty, STATUS='C' WHERE
                        AFACCTNO=rec.afacctno AND CODEID=rec.codeid AND TXDATE= rec.txdate AND TXNUM=rec.txnum;

                    INSERT INTO SEPITALLOCATE (CAMASTID,AFACCTNO,CODEID,PITRATE,QTTY,PRICE,ARIGHT,ORGORDERID,TXNUM,TXDATE,CARATE) VALUES(
                            rec.CAMASTID, rec.AFACCTNO, rec.CODEID, rec.PITRATE,rec.qtty - rec.mapqtty, v_parvalue, (rec.qtty - rec.mapqtty) * rec.CARATE * v_parvalue * rec.PITRATE/100,
                            recSTSCHD.orgorderid, rec.TXNUM,recSTSCHD.TXDATE,rec.CARATE);

                    v_recSTSCHD:=v_recSTSCHD- (rec.qtty - rec.mapqtty);

                end if;


            End loop;



        --UPDATE STSCHD SET RIGHTQTTY= DECODE(SIGN(QTTY-rec.qtty-rec.mapqtty), 1, rec.qtty-rec.mapqtty,0,rec.qtty-rec.mapqtty,-, QTTY)
        --WHERE DUETYPE='RM' AND AFACCTNO=rec.afacctno AND CODEID=rec.codeid AND DELTD <> 'Y' AND STATUS='N';
       End loop;
    end if;
   --commit;

   EXCEPTION WHEN OTHERS THEN
    plog.debug(pkgctx,'pr_allocate_right_stock: ' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'pr_allocate_right_stock');
   --rollback;

END;*/


PROCEDURE pr_allocate_right_stock(p_orgorderid varchar2)
   IS
   v_dtCURRDATE DATE;
   v_parvalue number(20,4);
   v_dblPrice number(20,4);
   v_dblDelPrice number(20,4);
   v_dblDelMatchQtty number(20,4);
   v_deltd varchar2(1);
   v_recSTSCHD number(20,4);
BEGIN
---
    plog.setbeginsection(pkgctx, 'pr_allocate_right_stock');

    SELECT TO_DATE (varvalue, systemnums.c_date_format)
                   INTO v_dtCURRDATE
                   FROM sysvar
                   WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

    plog.debug (pkgctx, 'begin pr_allocate_right_stock ' ||v_dtCURRDATE );

    for recIOD in (
        SELECT *  FROM (SELECT IOD.*, od.afacctno FROM IOD,stschd od WHERE iod.orgorderid= od.orgorderid and od.duetype='RM' and iod.ORGORDERID=p_orgorderid ORDER BY iod.TXTIME DESC, iod.TXNUM DESC) WHERE ROWNUM=1
    )
    loop
        v_deltd:= recIOD.deltd;
        if v_deltd<>'N' then --Xoa lenh khop
            SELECT PARVALUE INTO v_parvalue from sbsecurities where codeid=recIOD.codeid;
            v_dblDelPrice:= recIOD.matchprice;
            if v_dblDelPrice < v_parvalue then
                v_parvalue := v_dblDelPrice;
            end if;

            for rec in (
                select * from SEPITALLOCATE where txnum= recIOD.txnum and txdate = recIOD.txdate
            )
            loop
                UPDATE STSCHD SET RIGHTQTTY= RIGHTQTTY - rec.QTTY, ARIGHT=ARIGHT - rec.ARIGHT
                WHERE  orgorderid=rec.orgorderid and duetype ='RM';
                update SEPITLOG set MAPQTTY= MAPQTTY - rec.QTTY where autoid=rec.sepitlog_id;
            end loop;
            delete from SEPITALLOCATE where txnum= recIOD.txnum and txdate = recIOD.txdate;

        else --Lenh khop
            SELECT PARVALUE INTO v_parvalue from sbsecurities where codeid=recIOD.codeid;
            plog.debug (pkgctx, 'LOOP rec iod: ' || recIOD.orgorderid);

            SELECT PARVALUE INTO v_parvalue from sbsecurities where codeid=recIOD.codeid;
            v_dblPrice:= recIOD.MATCHPRICE;

            plog.debug (pkgctx, 'MATCH: ' || v_dblPrice);
            plog.debug (pkgctx, 'v_parvalue: ' || v_parvalue);

            if v_dblPrice<v_parvalue then
                v_parvalue:=v_dblPrice;
            end if;

            v_recSTSCHD:=recIOD.matchqtty;
            for rec in (
                SELECT * FROM SEPITLOG WHERE AFACCTNO=recIOD.afacctno
                AND CODEID=recIOD.codeid AND QTTY-MAPQTTY>0 AND DELTD <> 'Y' ORDER BY TXDATE, AUTOID
            )
            loop
                 IF v_recSTSCHD < rec.QTTY-rec.MAPQTTY then

                    UPDATE STSCHD SET RIGHTQTTY= RIGHTQTTY + v_recSTSCHD,
                        ARIGHT = ARIGHT + v_recSTSCHD * rec.CARATE * v_parvalue * rec.PITRATE/100
                        WHERE DUETYPE='RM' AND ORGORDERID=reciod.orgorderid
                        AND AFACCTNO=rec.afacctno AND CODEID=rec.codeid
                        AND DELTD <> 'Y' AND STATUS='N';

                    UPDATE SEPITLOG SET MAPQTTY= MAPQTTY + v_recSTSCHD
                        WHERE AFACCTNO=rec.afacctno AND CODEID=rec.codeid AND TXDATE= rec.txdate AND TXNUM=rec.txnum;

                    INSERT INTO SEPITALLOCATE (CAMASTID,AFACCTNO,CODEID,PITRATE,QTTY,PRICE,ARIGHT,ORGORDERID,TXNUM,TXDATE,CARATE,SEPITLOG_ID) VALUES(
                            rec.CAMASTID, rec.AFACCTNO, rec.CODEID, rec.PITRATE,v_recSTSCHD, v_parvalue, v_recSTSCHD * rec.CARATE * v_parvalue * rec.PITRATE/100,
                            recIOD.orgorderid, recIOD.TXNUM,recIOD.TXDATE,rec.CARATE,rec.AUTOID);

                    EXIT;

                else
                    UPDATE STSCHD SET RIGHTQTTY = RIGHTQTTY + rec.qtty - rec.mapqtty,
                        ARIGHT = ARIGHT + (rec.qtty - rec.mapqtty) * rec.CARATE * v_parvalue * rec.PITRATE/100
                        WHERE DUETYPE='RM' AND ORGORDERID=reciod.orgorderid AND AFACCTNO=rec.afacctno AND CODEID=rec.codeid AND
                        DELTD <> 'Y' AND STATUS='N';

                    UPDATE SEPITLOG SET MAPQTTY = MAPQTTY + rec.qtty - rec.mapqtty, STATUS='C' WHERE
                        AFACCTNO=rec.afacctno AND CODEID=rec.codeid AND TXDATE= rec.txdate AND TXNUM=rec.txnum;

                    INSERT INTO SEPITALLOCATE (CAMASTID,AFACCTNO,CODEID,PITRATE,QTTY,PRICE,ARIGHT,ORGORDERID,TXNUM,TXDATE,CARATE,SEPITLOG_ID) VALUES(
                            rec.CAMASTID, rec.AFACCTNO, rec.CODEID, rec.PITRATE,rec.qtty - rec.mapqtty, v_parvalue, (rec.qtty - rec.mapqtty) * rec.CARATE * v_parvalue * rec.PITRATE/100,
                            recIOD.orgorderid, recIOD.TXNUM,recIOD.TXDATE,rec.CARATE,rec.AUTOID);

                    v_recSTSCHD:=v_recSTSCHD- (rec.qtty - rec.mapqtty);
                end if;
                exit when v_recSTSCHD<=0;
            End loop;
        end if;
   end loop;

   EXCEPTION WHEN OTHERS THEN
    plog.debug(pkgctx,'pr_allocate_right_stock: ' || dbms_utility.format_error_backtrace);
    plog.debug(pkgctx,'Error: ' || SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'pr_allocate_right_stock');
   --rollback;

END;

---------------------------------pr_3380_send_cop_action------------------------------------------------
  PROCEDURE pr_3380_send_cop_action(p_txmsg in tx.msg_rectype,p_err_code  OUT varchar2)
  IS
      l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      l_err_param varchar2(300);

  BEGIN
    plog.setbeginsection(pkgctx, 'pr_3380_send_cop_action');
    SELECT varvalue
         INTO v_strCURRDATE
         FROM sysvar
         WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    begin
        plog.debug (pkgctx, 'p_txmsg.TLID' || p_txmsg.TLID);
        l_txmsg.tlid        := p_txmsg.TLID;
    exception when others then
        l_txmsg.tlid        := systemnums.c_system_userid;
    end;
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    /*begin
        l_txmsg.batchname        := p_txmsg.txnum;
        plog.debug (pkgctx, 'p_txmsg.txnum' || p_txmsg.txnum);
    exception when others then
        l_txmsg.batchname        := 'DAY';
    end;*/
    l_txmsg.batchname        := 'DAY';
    l_txmsg.busdate:= p_txmsg.busdate;

    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd:='3380';
    l_txmsg.reftxnum := p_txmsg.txnum;
    for rec in
    (
        select AUTOID,BALANCE,replace(CAMASTID,'.','') CAMASTID,AFACCTNO,CATYPE,CODEID,EXCODEID,
            QTTY,AMT,AQTTY,AAMT,SYMBOL,SYMBOLDIS,STATUS,STATUSCD,SEACCTNO,EXSEACCTNO,
            PARVALUE,EXPARVALUE,REPORTDATE,ACTIONDATE,DESCRIPTION,CUSTODYCD,FULLNAME,
            IDCODE,ISRIGHTOFF,QTTYDIS,costprice,
            ISCDCROUTAMT,ACCTNO_CR_UPDATECOST,ACCTNO_DB_UPDATECOST,AQTTY2,NMQTTY
        from v_ca3380
        where replace(CAMASTID,'.','') =p_txmsg.txfields('03').value
    )
    loop
        --Set txnum
        SELECT systemnums.C_BATCH_PREFIXED
                         || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                  INTO l_txmsg.txnum
                  FROM DUAL;
        --Set txtime
        select to_char(sysdate,'hh24:mi:ss') into l_txmsg.txtime from dual;
        --Set brid
        begin
            l_txmsg.brid        := p_txmsg.BRID;
        exception when others then
            l_txmsg.brid        := substr(rec.AFACCTNO,1,4);
        end;

        --Set cac field giao dich

        --01  AUTOID      C
        l_txmsg.txfields ('01').defname   := 'AUTOID';
        l_txmsg.txfields ('01').TYPE      := 'C';
        l_txmsg.txfields ('01').VALUE     := rec.AUTOID;
        --02  CAMASTID    C
        l_txmsg.txfields ('02').defname   := 'CAMASTID';
        l_txmsg.txfields ('02').TYPE      := 'C';
        l_txmsg.txfields ('02').VALUE     := rec.CAMASTID;
        --03  AFACCTNO    C
        l_txmsg.txfields ('03').defname   := 'AFACCTNO';
        l_txmsg.txfields ('03').TYPE      := 'C';
        l_txmsg.txfields ('03').VALUE     := rec.AFACCTNO;
        --04  SYMBOL      C
        l_txmsg.txfields ('04').defname   := 'SYMBOL';
        l_txmsg.txfields ('04').TYPE      := 'C';
        l_txmsg.txfields ('04').VALUE     := rec.SYMBOL;
        --05  CATYPE      C
        l_txmsg.txfields ('05').defname   := 'CATYPE';
        l_txmsg.txfields ('05').TYPE      := 'C';
        l_txmsg.txfields ('05').VALUE     := rec.CATYPE;
        --06  REPORTDATE  C
        l_txmsg.txfields ('06').defname   := 'REPORTDATE';
        l_txmsg.txfields ('06').TYPE      := 'C';
        l_txmsg.txfields ('06').VALUE     := to_char(rec.REPORTDATE,'dd/mm/rrrr');
        --07  ACTIONDATE  C
        l_txmsg.txfields ('07').defname   := 'ACTIONDATE';
        l_txmsg.txfields ('07').TYPE      := 'C';
        l_txmsg.txfields ('07').VALUE     := to_char(rec.ACTIONDATE,'dd/mm/rrrr');
        --08  SEACCTNO    C
        l_txmsg.txfields ('08').defname   := 'SEACCTNO';
        l_txmsg.txfields ('08').TYPE      := 'C';
        l_txmsg.txfields ('08').VALUE     := rec.SEACCTNO;
        --09  EXSEACCTNO  C
        l_txmsg.txfields ('09').defname   := 'EXSEACCTNO';
        l_txmsg.txfields ('09').TYPE      := 'C';
        l_txmsg.txfields ('09').VALUE     := rec.EXSEACCTNO;
        --10  AMT         N
        l_txmsg.txfields ('10').defname   := 'AMT';
        l_txmsg.txfields ('10').TYPE      := 'N';
        l_txmsg.txfields ('10').VALUE     := rec.AMT;
        --11  QTTY        N
        l_txmsg.txfields ('11').defname   := 'QTTY';
        l_txmsg.txfields ('11').TYPE      := 'N';
        l_txmsg.txfields ('11').VALUE     := rec.QTTY;
        --12  AAMT        N
        l_txmsg.txfields ('12').defname   := 'AAMT';
        l_txmsg.txfields ('12').TYPE      := 'N';
        l_txmsg.txfields ('12').VALUE     := rec.AAMT;
        --13  AQTTY       N
        l_txmsg.txfields ('13').defname   := 'AQTTY';
        l_txmsg.txfields ('13').TYPE      := 'N';
        l_txmsg.txfields ('13').VALUE     := rec.AQTTY;
        --14  PARVALUE    N
        l_txmsg.txfields ('14').defname   := 'PARVALUE';
        l_txmsg.txfields ('14').TYPE      := 'N';
        l_txmsg.txfields ('14').VALUE     := rec.PARVALUE;
        --15  EXPARVALUE  N
        l_txmsg.txfields ('15').defname   := 'EXPARVALUE';
        l_txmsg.txfields ('15').TYPE      := 'N';
        l_txmsg.txfields ('15').VALUE     := rec.EXPARVALUE;
        --20  SYMBOLDIS   C
        l_txmsg.txfields ('20').defname   := 'SYMBOLDIS';
        l_txmsg.txfields ('20').TYPE      := 'C';
        l_txmsg.txfields ('20').VALUE     := rec.SYMBOLDIS;
        --30  DESCRIPTION C
        l_txmsg.txfields ('30').defname   := 'DESCRIPTION';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').VALUE     := rec.DESCRIPTION;
        --40  STATUS      C
        l_txmsg.txfields ('40').defname   := 'STATUS';
        l_txmsg.txfields ('40').TYPE      := 'C';
        l_txmsg.txfields ('40').VALUE     := rec.STATUSCD;
        --66  ISRIGHTOFF  N
        l_txmsg.txfields ('66').defname   := 'ISRIGHTOFF';
        l_txmsg.txfields ('66').TYPE      := 'N';
        l_txmsg.txfields ('66').VALUE     := rec.ISRIGHTOFF;
        --21 QTTYDIS
        l_txmsg.txfields ('21').defname   := 'TRADE';
        l_txmsg.txfields ('21').TYPE      := 'N';
        l_txmsg.txfields ('21').VALUE     := rec.QTTYDIS;
            --32: COSTPRICE
        l_txmsg.txfields ('32').defname   := 'COSTPRICE';
        l_txmsg.txfields ('32').TYPE      := 'N';
        l_txmsg.txfields ('32').VALUE     := rec.COSTPRICE;
        --33  AQTTY2  N
        l_txmsg.txfields ('33').defname   := 'AQTTY2';
        l_txmsg.txfields ('33').TYPE      := 'N';
        l_txmsg.txfields ('33').VALUE     := rec.AQTTY2;
        --34 ACCTNO_CR_UPDATECOST
        l_txmsg.txfields ('34').defname   := 'ACCTNO_CR_UPDATECOST';
        l_txmsg.txfields ('34').TYPE      := 'C';
        l_txmsg.txfields ('34').VALUE     := rec.ACCTNO_CR_UPDATECOST;
          --35 ACCTNO_DB_UPDATECOST
        l_txmsg.txfields ('35').defname   := 'ACCTNO_DB_UPDATECOST';
        l_txmsg.txfields ('35').TYPE      := 'C';
        l_txmsg.txfields ('35').VALUE     := rec.ACCTNO_DB_UPDATECOST;
                  --60 ACCTNO_DB_UPDATECOST
        l_txmsg.txfields ('60').defname   := 'ISCDCROUTAMT';
        l_txmsg.txfields ('60').TYPE      := 'C';
        l_txmsg.txfields ('60').VALUE     := rec.ISCDCROUTAMT;

           --36 CUSTODYCD
        l_txmsg.txfields ('36').defname   := 'CUSTODYCD';
        l_txmsg.txfields ('36').TYPE      := 'C';
        l_txmsg.txfields ('36').VALUE     := rec.CUSTODYCD;
           --22 CODEID
        l_txmsg.txfields ('22').defname   := 'CODEID';
        l_txmsg.txfields ('22').TYPE      := 'C';
        l_txmsg.txfields ('22').VALUE     := rec.CODEID;
           --19  NMQTTY  N
        l_txmsg.txfields ('19').defname   := 'NMQTTY';
        l_txmsg.txfields ('19').TYPE      := 'N';
        l_txmsg.txfields ('19').VALUE     := rec.NMQTTY;
        BEGIN
            IF txpks_#3380.fn_batchtxprocess (l_txmsg,
                                             p_err_code,
                                             l_err_param
               ) <> systemnums.c_success
            THEN
               plog.debug (pkgctx,
                           'got error 3380: ' || p_err_code
               );
               ROLLBACK;
               RETURN;
            END IF;
        END;
    end loop;
    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_3380_send_cop_action');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_3380_send_cop_action');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_3380_send_cop_action');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_3380_send_cop_action;

---------------------------------pr_3350_exec_money_CA------------------------------------------------
  PROCEDURE pr_3350_exec_money_CA(p_txmsg in tx.msg_rectype,p_err_code  OUT varchar2)
  IS
      l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      l_err_param varchar2(300);

  BEGIN
    plog.setbeginsection(pkgctx, 'pr_3350_exec_money_CA');
    SELECT varvalue
         INTO v_strCURRDATE
         FROM sysvar
         WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    begin
        plog.debug (pkgctx, 'p_txmsg.TLID' || p_txmsg.TLID);
        l_txmsg.tlid        := p_txmsg.TLID;
    exception when others then
        l_txmsg.tlid        := systemnums.c_system_userid;
    end;
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    /*begin
        l_txmsg.batchname        := p_txmsg.txnum;
        plog.debug (pkgctx, 'p_txmsg.txnum' || p_txmsg.txnum);
    exception when others then
        l_txmsg.batchname        := 'DAY';
    end;*/
    l_txmsg.batchname        := 'DAY';
    l_txmsg.busdate:= p_txmsg.busdate;

    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.reftxnum := p_txmsg.txnum;

    for rec in
    (
        SELECT CA.AUTOID, CA.BALANCE, ca.CAMASTID, CA.AFACCTNO,CAMAST.CATYPE, CA.CODEID,
                CA.EXCODEID, CA.QTTY, ROUND(CA.AMT) AMT, ROUND(CA.AQTTY) AQTTY,ROUND(CA.AAMT) AAMT, SYM.SYMBOL, CA.STATUS,
                CASE WHEN camast.catype = '017' THEN CA.AFACCTNO || CA.EXCODEID ELSE CA.AFACCTNO || CA.CODEID END SEACCTNO,
                CASE WHEN camast.catype = '017' THEN CA.AFACCTNO || CA.CODEID else CA.AFACCTNO || (CASE WHEN CAMAST.EXCODEID IS NULL THEN CAMAST.CODEID ELSE CAMAST.EXCODEID END) end EXSEACCTNO,
                SYM.PARVALUE PARVALUE, EXSYM.PARVALUE EXPARVALUE, CAMAST.REPORTDATE REPORTDATE, CAMAST.ACTIONDATE ,CAMAST.ACTIONDATE  POSTINGDATE,
                    camast.description, camast.taskcd,
      (CASE WHEN AF.ISFCT='Y' THEN
             ( CASE WHEN CAMAST.CATYPE in ('016','023') THEN round(CAMAST.pitrate*CA.INTAMT/100)
					--1.6.1.0: thue CW
					WHEN CAMAST.CATYPE in ('028')
                         then LEAST(round(CAMAST.pitrate * CA.BALANCE * CAMAST.EXPRICE / (to_number(SUBSTR(SYM.EXERCISERATIO,0,INSTR(SYM.EXERCISERATIO,'/') - 1)) / to_number( SUBSTR(SYM.EXERCISERATIO,INSTR(SYM.EXERCISERATIO,'/')+1,LENGTH(SYM.EXERCISERATIO))))/100), CA.AMT)
				else round(CAMAST.pitrate*CA.AMT/100)
             end )
       ELSE 0 END) DUTYAMT,
                CF.FULLNAME, CF.IDCODE, CF.CUSTODYCD, cf.custid, SYM.TRADEPLACE, SYM.SECTYPE,
                CAMAST.PITRATEMETHOD CAVAT,(case when CA.PITRATEMETHOD='##' then CAMAST.PITRATEMETHOD else CA.PITRATEMETHOD end) SCHDVAT,
                (CASE WHEN CAMAST.catype in ('016','023') THEN 1 ELSE 0 END) ISDEBITSE,
                CASE WHEN CI.COREBANK='Y' THEN 0 ELSE 1 END ISCOREBANK,
                CASE WHEN CI.COREBANK='Y' THEN 'Yes' ELSE 'No' END ISCOREBANKTEXT,
                round( CA.INTAMT) INTAMT,nvl(se.trade,0) trade,round(CA.DFAMT) DFAMT,
                (CASE WHEN CAMAST.catype IN ('016','023','015') THEN 0 ELSE 1 END) NOTINTAMT
                FROM caschd CA,
                    SBSECURITIES SYM, SBSECURITIES EXSYM, CAMAST, AFMAST AF, CIMAST CI , CFMAST CF , AFTYPE TYP, SYSVAR SYS,
                    semast se
                WHERE CA.CAMASTID = CAMAST.CAMASTID AND CAMAST.CODEID = SYM.CODEID
                and camast.camastid =p_txmsg.txfields('03').value
                AND nvl(CAMAST.EXCODEID,CAMAST.CODEID)  = EXSYM.CODEID
                AND CA.AFACCTNO = AF.ACCTNO AND AF.CUSTID = CF.CUSTID and af.acctno = ci.acctno
                AND CA.DELTD ='N' AND CA.STATUS  IN ('S','H','W') and CAMAST.STATUS  IN ('I','H') AND CA.ISCI ='N' --AND CA.ISSE='N'
                AND CA.AMT>0 AND CA.ISEXEC='Y'
                AND se.acctno(+)= ca.afacctno||ca.codeid
                AND AF.ACTYPE = TYP.ACTYPE AND SYS.GRNAME='SYSTEM' AND SYS.VARNAME='CADUTY'
    )
    loop
        if rec.SCHDVAT='IS' then
            --Thu thue tai TCPH
            l_txmsg.tltxcd:='3354';
        else
            --Thu thue tai Cong ty
            l_txmsg.tltxcd:='3350';
        end if;
        --Set txnum
        SELECT systemnums.C_BATCH_PREFIXED
                         || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                  INTO l_txmsg.txnum
                  FROM DUAL;
        --Set txtime
        select to_char(sysdate,'hh24:mi:ss') into l_txmsg.txtime from dual;
        --Set brid
        begin
            l_txmsg.brid        := p_txmsg.BRID;
        exception when others then
            l_txmsg.brid        := substr(rec.AFACCTNO,1,4);
        end;

        --Set cac field giao dich
        --01  AUTOID      C
        l_txmsg.txfields ('01').defname   := 'AUTOID';
        l_txmsg.txfields ('01').TYPE      := 'C';
        l_txmsg.txfields ('01').VALUE     := rec.AUTOID;
        --02  CAMASTID    C
        l_txmsg.txfields ('02').defname   := 'CAMASTID';
        l_txmsg.txfields ('02').TYPE      := 'C';
        l_txmsg.txfields ('02').VALUE     := rec.CAMASTID;
        --03  AFACCTNO    C
        l_txmsg.txfields ('03').defname   := 'AFACCTNO';
        l_txmsg.txfields ('03').TYPE      := 'C';
        l_txmsg.txfields ('03').VALUE     := rec.AFACCTNO;
        --04  SYMBOL      C
        l_txmsg.txfields ('04').defname   := 'SYMBOL';
        l_txmsg.txfields ('04').TYPE      := 'C';
        l_txmsg.txfields ('04').VALUE     := rec.SYMBOL;
        --05  CATYPE      C
        l_txmsg.txfields ('05').defname   := 'CATYPE';
        l_txmsg.txfields ('05').TYPE      := 'C';
        l_txmsg.txfields ('05').VALUE     := rec.CATYPE;
        --06  REPORTDATE  C
        l_txmsg.txfields ('06').defname   := 'REPORTDATE';
        l_txmsg.txfields ('06').TYPE      := 'C';
        l_txmsg.txfields ('06').VALUE     := to_char(rec.REPORTDATE,'dd/mm/rrrr');
        --07  ACTIONDATE  C
        l_txmsg.txfields ('07').defname   := 'ACTIONDATE';
        l_txmsg.txfields ('07').TYPE      := 'C';
        l_txmsg.txfields ('07').VALUE     := to_char(rec.ACTIONDATE,'dd/mm/rrrr');
        --08  SEACCTNO    C
        l_txmsg.txfields ('08').defname   := 'SEACCTNO';
        l_txmsg.txfields ('08').TYPE      := 'C';
        l_txmsg.txfields ('08').VALUE     := rec.SEACCTNO;
        --09  EXSEACCTNO  C
        l_txmsg.txfields ('09').defname   := 'EXSEACCTNO';
        l_txmsg.txfields ('09').TYPE      := 'C';
        l_txmsg.txfields ('09').VALUE     := rec.EXSEACCTNO;
        --10  AMT         N
        l_txmsg.txfields ('10').defname   := 'AMT';
        l_txmsg.txfields ('10').TYPE      := 'N';
        l_txmsg.txfields ('10').VALUE     := rec.AMT;
        --12  AAMT        N
        l_txmsg.txfields ('12').defname   := 'AAMT';
        l_txmsg.txfields ('12').TYPE      := 'N';
        l_txmsg.txfields ('12').VALUE     := rec.AAMT;
        --14  PARVALUE    N
        l_txmsg.txfields ('14').defname   := 'PARVALUE';
        l_txmsg.txfields ('14').TYPE      := 'N';
        l_txmsg.txfields ('14').VALUE     := rec.PARVALUE;
        --15  EXPARVALUE  N
        l_txmsg.txfields ('15').defname   := 'EXPARVALUE';
        l_txmsg.txfields ('15').TYPE      := 'N';
        l_txmsg.txfields ('15').VALUE     := rec.EXPARVALUE;
        --16  TASKCD   C
        l_txmsg.txfields ('16').defname   := 'TASKCD';
        l_txmsg.txfields ('16').TYPE      := 'C';
        l_txmsg.txfields ('16').VALUE     := '';
        --17  FULLNAME    C
        l_txmsg.txfields ('17').defname   := 'FULLNAME';
        l_txmsg.txfields ('17').TYPE      := 'C';
        l_txmsg.txfields ('17').VALUE     := rec.FULLNAME;
        --18  IDCODE      C
        l_txmsg.txfields ('18').defname   := 'IDCODE';
        l_txmsg.txfields ('18').TYPE      := 'C';
        l_txmsg.txfields ('18').VALUE     := rec.IDCODE;
        --19  CUSTODYCD   C
        l_txmsg.txfields ('19').defname   := 'CUSTODYCD';
        l_txmsg.txfields ('19').TYPE      := 'C';
        l_txmsg.txfields ('19').VALUE     := rec.CUSTODYCD;
        --20  DUTYAMT     N
        l_txmsg.txfields ('20').defname   := 'DUTYAMT';
        l_txmsg.txfields ('20').TYPE      := 'C';
        l_txmsg.txfields ('20').VALUE     := rec.DUTYAMT;
        --30  DESCRIPTION C
        l_txmsg.txfields ('30').defname   := 'DESCRIPTION';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').VALUE     := rec.DESCRIPTION;
        --60  ISCOREBANK C
        l_txmsg.txfields ('60').defname   := 'DESCRIPTION';
        l_txmsg.txfields ('60').TYPE      := 'C';
        l_txmsg.txfields ('60').VALUE     := rec.ISCOREBANK;
        --61  ISDEBITSE C
        l_txmsg.txfields ('61').defname   := 'ISDEBITSE';
        l_txmsg.txfields ('61').TYPE      := 'C';
        l_txmsg.txfields ('61').VALUE     := rec.ISDEBITSE;

        --11 BALANCE-trade     N
        l_txmsg.txfields ('11').defname   := 'BALANCE';
        l_txmsg.txfields ('11').TYPE      := 'N';
        l_txmsg.txfields ('11').VALUE     := rec.trade;

            --13 INTAMT     N
        l_txmsg.txfields ('13').defname   := 'INTAMT';
        l_txmsg.txfields ('13').TYPE      := 'N';
        l_txmsg.txfields ('13').VALUE     := rec.INTAMT;

          --21 DFAMT     N
        l_txmsg.txfields ('21').defname   := 'DFAMT';
        l_txmsg.txfields ('21').TYPE      := 'N';
        l_txmsg.txfields ('21').VALUE     := rec.DFAMT;

         --62  NOTINTAMT N
        l_txmsg.txfields ('62').defname   := 'NOTINTAMT';
        l_txmsg.txfields ('62').TYPE      := 'N';
        l_txmsg.txfields ('62').VALUE     := rec.NOTINTAMT;

        if l_txmsg.tltxcd ='3350' THEN
            BEGIN
                IF txpks_#3350.fn_batchtxprocess (l_txmsg,
                                                 p_err_code,
                                                 l_err_param
                   ) <> systemnums.c_success
                THEN
                   plog.debug (pkgctx,
                               'got error 3350: ' || p_err_code
                   );
                   ROLLBACK;
                   RETURN;
                END IF;
            END;
        else
            BEGIN
                IF txpks_#3354.fn_batchtxprocess (l_txmsg,
                                                 p_err_code,
                                                 l_err_param
                   ) <> systemnums.c_success
                THEN
                   plog.debug (pkgctx,
                               'got error 3350: ' || p_err_code
                   );
                   ROLLBACK;
                   RETURN;
                END IF;
            END;
        end if;
       -- Begin processing 4 fo
       /*IF pck_newfo.fn_syn_info_2_fo(p_txmsg, p_err_code) <> systemnums.C_SUCCESS THEN
            plog.debug (pkgctx,
                               'got error 3350: ' || p_err_code
                   );
            plog.setendsection(pkgctx, 'pr_3350_exec_money_CA');
            ROLLBACK;
            RETURN;
       END IF;*/
       -- End processing 4 fo
    end loop;
    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_3350_exec_money_CA');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_3350_exec_money_CA');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_3350_exec_money_CA');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_3350_exec_money_CA;

---------------------------------pr_3351_Exec_Sec_CA------------------------------------------------
  PROCEDURE pr_3351_Exec_Sec_CA(p_txmsg in tx.msg_rectype,p_err_code  OUT varchar2)
  IS
      l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      l_err_param varchar2(300);

  BEGIN
    plog.setbeginsection(pkgctx, 'pr_3351_Exec_Sec_CA');
    SELECT varvalue
         INTO v_strCURRDATE
         FROM sysvar
         WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    begin
        plog.debug (pkgctx, 'p_txmsg.TLID' || p_txmsg.TLID);
        l_txmsg.tlid        := p_txmsg.TLID;
    exception when others then
        l_txmsg.tlid        := systemnums.c_system_userid;
    end;
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    /*begin
        l_txmsg.batchname        := p_txmsg.txnum;
        plog.debug (pkgctx, 'p_txmsg.txnum' || p_txmsg.txnum);
    exception when others then
        l_txmsg.batchname        := 'DAY';
    end;*/
    l_txmsg.batchname        := 'DAY';
    l_txmsg.busdate:= p_txmsg.busdate;

    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd:='3351';
    l_txmsg.reftxnum := p_txmsg.txnum;
    for rec in
    (
        select AUTOID, BALANCE, replace(CAMASTID,'.','') CAMASTID, AFACCTNO, CATYPE, CODEID, EXCODEID, QTTY, AMT,
            AQTTY,BLOCKEDQTTY, AAMT, SYMBOL, PITRATE, TOCODEID, STATUS, SEACCTNO, EXSEACCTNO, PARVALUE,
            EXPARVALUE, REPORTDATE, ACTIONDATE, POSTINGDATE, DESCRIPTION, TASKCD, DUTYAMT,
            FULLNAME, IDCODE, CUSTODYCD, PRICEACCOUNTING, CATYPEVALUE,COSTPRICE,ISCDCROUTAMT
        from v_ca3351
        where replace(CAMASTID,'.','') =p_txmsg.txfields('03').value
    )
    loop
        --Set txnum
        SELECT systemnums.C_BATCH_PREFIXED
                         || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                  INTO l_txmsg.txnum
                  FROM DUAL;
        --Set txtime
        select to_char(sysdate,'hh24:mi:ss') into l_txmsg.txtime from dual;
        --Set brid
        begin
            l_txmsg.brid        := p_txmsg.BRID;
        exception when others then
            l_txmsg.brid        := substr(rec.AFACCTNO,1,4);
        end;
        --Set ngay hach toan giao dich
        l_txmsg.busdate:= rec.POSTINGDATE;
        --Set cac field giao dich
        --01  AUTOID      C
        l_txmsg.txfields ('01').defname   := 'AUTOID';
        l_txmsg.txfields ('01').TYPE      := 'C';
        l_txmsg.txfields ('01').VALUE     := rec.AUTOID;
        --02  CAMASTID    C
        l_txmsg.txfields ('02').defname   := 'CAMASTID';
        l_txmsg.txfields ('02').TYPE      := 'C';
        l_txmsg.txfields ('02').VALUE     := rec.CAMASTID;
        --03  AFACCTNO    C
        l_txmsg.txfields ('03').defname   := 'AFACCTNO';
        l_txmsg.txfields ('03').TYPE      := 'C';
        l_txmsg.txfields ('03').VALUE     := rec.AFACCTNO;
        --04  SYMBOL      C
        l_txmsg.txfields ('04').defname   := 'SYMBOL';
        l_txmsg.txfields ('04').TYPE      := 'C';
        l_txmsg.txfields ('04').VALUE     := rec.SYMBOL;
        --05  CATYPE      C
        l_txmsg.txfields ('05').defname   := 'CATYPE';
        l_txmsg.txfields ('05').TYPE      := 'C';
        l_txmsg.txfields ('05').VALUE     := rec.CATYPE;
        --06  REPORTDATE  C
        l_txmsg.txfields ('06').defname   := 'REPORTDATE';
        l_txmsg.txfields ('06').TYPE      := 'C';
        l_txmsg.txfields ('06').VALUE     := to_char(rec.REPORTDATE,'dd/mm/rrrr');
        --07  ACTIONDATE  C
        l_txmsg.txfields ('07').defname   := 'ACTIONDATE';
        l_txmsg.txfields ('07').TYPE      := 'C';
        l_txmsg.txfields ('07').VALUE     := to_char(rec.ACTIONDATE,'dd/mm/rrrr');
        --08  SEACCTNO    C
        l_txmsg.txfields ('08').defname   := 'SEACCTNO';
        l_txmsg.txfields ('08').TYPE      := 'C';
        l_txmsg.txfields ('08').VALUE     := rec.SEACCTNO;
        --09  EXSEACCTNO  C
        l_txmsg.txfields ('09').defname   := 'EXSEACCTNO';
        l_txmsg.txfields ('09').TYPE      := 'C';
        l_txmsg.txfields ('09').VALUE     := rec.EXSEACCTNO;
        --11  QTTY        N
        l_txmsg.txfields ('11').defname   := 'QTTY';
        l_txmsg.txfields ('11').TYPE      := 'N';
        l_txmsg.txfields ('11').VALUE     := rec.QTTY;
        --13  AQTTY       N
        l_txmsg.txfields ('13').defname   := 'AQTTY';
        l_txmsg.txfields ('13').TYPE      := 'N';
        l_txmsg.txfields ('13').VALUE     := rec.AQTTY;

        --25  BLOCKEDQTTY       N --Add by ManhTV: them hoach toan cat truong blocked trong semast
        l_txmsg.txfields ('25').defname   := 'BLOCKEDQTTY';
        l_txmsg.txfields ('25').TYPE      := 'N';
        l_txmsg.txfields ('25').VALUE     := rec.BLOCKEDQTTY;

        --14  PARVALUE    N
        l_txmsg.txfields ('14').defname   := 'PARVALUE';
        l_txmsg.txfields ('14').TYPE      := 'N';
        l_txmsg.txfields ('14').VALUE     := rec.PARVALUE;
        --15  EXPARVALUE  N
        l_txmsg.txfields ('15').defname   := 'EXPARVALUE';
        l_txmsg.txfields ('15').TYPE      := 'N';
        l_txmsg.txfields ('15').VALUE     := rec.EXPARVALUE;
        --16  TASKCD          C
        l_txmsg.txfields ('16').defname   := 'TASKCD';
        l_txmsg.txfields ('16').TYPE      := 'C';
        l_txmsg.txfields ('16').VALUE     := rec.TASKCD;
        --17  FULLNAME          C
        l_txmsg.txfields ('17').defname   := 'FULLNAME';
        l_txmsg.txfields ('17').TYPE      := 'C';
        l_txmsg.txfields ('17').VALUE     := rec.FULLNAME;
        --18  IDCODE          C
        l_txmsg.txfields ('18').defname   := 'IDCODE';
        l_txmsg.txfields ('18').TYPE      := 'C';
        l_txmsg.txfields ('18').VALUE     := rec.IDCODE;
        --19  CUSTODYCD          C
        l_txmsg.txfields ('19').defname   := 'CUSTODYCD';
        l_txmsg.txfields ('19').TYPE      := 'C';
        l_txmsg.txfields ('19').VALUE     := rec.CUSTODYCD;
        --20  DUTYAMT  N
        l_txmsg.txfields ('20').defname   := 'DUTYAMT';
        l_txmsg.txfields ('20').TYPE      := 'N';
        l_txmsg.txfields ('20').VALUE     := rec.DUTYAMT;
        --21  PRICEACCOUNTING N
        l_txmsg.txfields ('21').defname   := 'PRICEACCOUNTING';
        l_txmsg.txfields ('21').TYPE      := 'N';
        l_txmsg.txfields ('21').VALUE     := rec.PRICEACCOUNTING;
        --22  CATYPEVALUE     C
        l_txmsg.txfields ('22').defname   := 'CATYPEVALUE';
        l_txmsg.txfields ('22').TYPE      := 'C';
        l_txmsg.txfields ('22').VALUE     := rec.CATYPEVALUE;
        --30  DESCRIPTION C
        l_txmsg.txfields ('30').defname   := 'DESCRIPTION';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').VALUE     := rec.DESCRIPTION;
        --40  STATUS      C
        l_txmsg.txfields ('40').defname   := 'STATUS';
        l_txmsg.txfields ('40').TYPE      := 'C';
        l_txmsg.txfields ('40').VALUE     := rec.STATUS;
          --12  COSTPRICE  N
        l_txmsg.txfields ('12').defname   := 'COSTPRICE';
        l_txmsg.txfields ('12').TYPE      := 'N';
        l_txmsg.txfields ('12').VALUE     := rec.COSTPRICE;
        --60    ISCDCROUTAMT N
        l_txmsg.txfields ('60').defname   := 'ISCDCROUTAMT';
        l_txmsg.txfields ('60').TYPE      := 'N';
        l_txmsg.txfields ('60').VALUE     := rec.ISCDCROUTAMT;
        BEGIN
            IF txpks_#3351.fn_batchtxprocess (l_txmsg,
                                             p_err_code,
                                             l_err_param
               ) <> systemnums.c_success
            THEN
               plog.debug (pkgctx,
                           'got error 3351: ' || p_err_code
               );
               ROLLBACK;
               RETURN;
            END IF;
        END;
    end loop;
    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_3351_Exec_Sec_CA');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_3351_Exec_Sec_CA');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_3351_Exec_Sec_CA');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_3351_Exec_Sec_CA;


FUNCTION fn_ExecuteContractCAEvent(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
v_blnREVERSAL boolean;
l_lngErrCode    number(20,0);
v_count number(20,0);
v_dblFEEAMT number(20,4);
v_strRIGHTTYPE varchar2(50);
v_catype varchar2(10);
v_codeid varchar2(50);
v_righttype varchar2(50);
v_tocodeid varchar2(50);
v_dblDFQTTY number;
v_dblCARATE number;
v_strtocodeid varchar2(50);
v_strIswtf char(1);
v_countCI NUMBER(20,0);
v_countSE NUMBER(20,0);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_ExecuteContractCAEvent');
    plog.debug (pkgctx, '<<BEGIN OF fn_ExecuteContractCAEvent');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    v_blnREVERSAL:=case when p_txmsg.deltd ='Y' then true else false end;
    l_lngErrCode:= errnums.C_BIZ_RULE_INVALID;
    SELECT VARVALUE into v_strRIGHTTYPE FROM SYSVAR WHERE VARNAME='RIGHTCONVERTTYPE';
    if not v_blnREVERSAL then
        for rec in (
            SELECT STATUS ,ISCI, ISSE, AMT, AAMT, QTTY, AQTTY,DFQTTY,DFAMT
            FROM CASCHD WHERE AUTOID=p_txmsg.txfields('01').value AND DELTD ='N'
        )
        loop
            if rec.STATUS='C' THEN
                p_err_code:='-300012';
                plog.setendsection (pkgctx, 'fn_ExecuteContractCAEvent');
                return l_lngErrCode;
            else
                if p_txmsg.tltxcd='3351' then
                    --HaiLT them de phan bo vao SEPITLOG
                    insert into caexec_temp (TLAUTOID,txnum,autoid, balance, camastid, afacctno, catype, codeid,
                          excodeid, qtty, amt, aqtty, aamt, symbol, status,seacctno, exseacctno, parvalue, exparvalue, reportdate,
                          actiondate, postingdate, description, taskcd, dutyamt,
                          fullname, idcode, custodycd,custid,TRADEPLACE, SECTYPE, PITRATE, TOCODEID)
                          SELECT seq_tllog.NEXTVAL, '99' || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0') txnum,
                          CA.AUTOID, CA.BALANCE, replace(ca.CAMASTID,'.','') CAMASTID, CA.AFACCTNO,ca.catypevalue CATYPE, CA.CODEID,
                          CA.EXCODEID, CA.QTTY, ROUND(CA.AMT) AMT, ROUND(CA.AQTTY) AQTTY,ROUND(CA.AAMT) AAMT, CA.SYMBOL, mst.status,
                          CA.SEACCTNO,CA.EXSEACCTNO,CA.PARVALUE, CA.EXPARVALUE, CA.REPORTDATE ,CA.ACTIONDATE ,CA.POSTINGDATE,
                          CA.description, CA.taskcd, CA.DUTYAMT, CA.FULLNAME, CA.IDCODE, CA.CUSTODYCD, cf.custid, SYM.TRADEPLACE, SYM.SECTYPE, CA.PITRATE,
                          CASE WHEN NVL(CA.TOCODEID,'A')='A' THEN CA.CODEID ELSE CA.TOCODEID END TOCODEID
                          FROM v_ca3351 ca,caschd mst, cfmast cf,sbsecurities sym where(CA.codeid = sym.codeid And CA.autoid = mst.autoid)
                          and replace(ca.CAMASTID,'.','')= p_txmsg.txfields('02').value and ca.custodycd = cf.custodycd AND mst.AUTOID=p_txmsg.txfields('01').value;

                    INSERT INTO SEPITLOG(AUTOID,TXDATE,TXNUM,QTTY,MAPQTTY,CODEID,CAMASTID,ACCTNO,MODIFIEDDATE,AFACCTNO,PRICE,PITRATE)
                          select SEQ_SEPITLOG.NEXTVAL, TO_DATE (p_txmsg.txdate, 'DD/MM/RRRR'), rec.txnum,ROUND(rec.QTTY,0),0,
                          --case when rec.catype IN ('009','011','021') and LENGTH(nvl(rec.tocodeid,''))>0 then rec.tocodeid else rec.codeid end codeid,
                          rec.tocodeid codeid,
                          rec.camastid, rec.afacctno||rec.tocodeid, TO_DATE (p_txmsg.txdate, 'DD/MM/RRRR'), rec.afacctno,rec.parvalue, rec.pitrate
                          from caexec_temp rec where camastid = p_txmsg.txfields('02').value and afacctno=  p_txmsg.txfields('03').value
                          and INSTR((SELECT VARVALUE FROM sysvar WHERE GRNAME='SYSTEM' AND VARNAME='RIGHTVATDUTY'),rec.catype) > 0;

                    delete from caexec_temp where camastid = p_txmsg.txfields('02').value ;

                    begin
                        SELECT CAMAST.catype, camast.codeid, camast.tocodeid into v_catype, v_codeid, v_tocodeid
                            FROM CAMAST
                            WHERE CAMASTID=p_txmsg.txfields('02').value;
                        SELECT VARVALUE into v_righttype FROM SYSVAR WHERE VARNAME='RIGHTCONVERTTYPE';


                        If InStr(v_righttype, v_catype) > 0 Then

                            SELECT to_number(substr(ca.DEVIDENTSHARES,0,instr(ca.DEVIDENTSHARES,'/')-1)) / to_number(substr(ca.DEVIDENTSHARES,instr(ca.DEVIDENTSHARES,'/')+1)),
                                   case when ca.iswft='Y' then nvl(sb.codeid,ca.tocodeid) else ca.tocodeid end, ca.iswft
                                into v_dblCARATE, v_strtocodeid, v_strIswtf
                            FROM CAMAST ca, sbsecurities sb
                            WHERE ca.CAMASTID=p_txmsg.txfields('02').value and ca.tocodeid= sb.refcodeid(+);

                            for rec in (
                                  SELECT * FROM SEPITLOG WHERE CODEID=v_codeid and afacctno=  p_txmsg.txfields('03').value
--                                SELECT * FROM SEPITLOG WHERE  CAMASTID=p_txmsg.txfields('02').value AND
--                                    CAMASTID IN (SELECT CAMASTID  FROM CAMAST WHERE INSTR(v_righttype,CATYPE)>0 )
                                )
                            loop

                                /*if rec.MAPQTTY>0 then
                                    --- v_CARATE Ti le chia moi khi chuyen sang co phieu khac, de tinh lai so co phieu ban dau
                                    --- Co phieu chua phan bo = co phieu chua phan bo x ti le chia (v_dblCARATE)
                                    insert into sepitlog (AUTOID,TXDATE,TXNUM,QTTY,MAPQTTY,CODEID,PCAMASTID,CAMASTID,ACCTNO,MODIFIEDDATE,AFACCTNO,PRICE,PITRATE,CARATE)
                                      values(SEQ_SEPITLOG.NEXTVAL, TO_DATE (rec.txdate, 'DD/MM/RRRR'),'', ceil(to_number(rec.QTTY-rec.MAPQTTY) / v_dblCARATE),0, v_strtocodeid, rec.CAMASTID,p_txmsg.txfields('02').value,
                                          substr(rec.ACCTNO,1,10) || v_strtocodeid, TO_DATE (p_txmsg.txdate, 'DD/MM/RRRR'), rec.AFACCTNO, rec.PRICE, rec.PITRATE,round(to_number(nvl(rec.CARATE,1)) / v_dblCARATE,4)) ;

                                    UPDATE SEPITLOG SET QTTY=MAPQTTY
                                        WHERE AUTOID=rec.AUTOID;

                                else

                                    UPDATE SEPITLOG SET PCAMASTID=CAMASTID, QTTY=QTTY*v_dblCARATE,
                                            CAMASTID= p_txmsg.txfields('02').value,
                                            CODEID = v_tocodeid, CARATE=to_number(nvl(rec.CARATE,1)) * v_dblCARATE
                                        WHERE AUTOID=rec.AUTOID;
                                end if;*/
                                insert into sepitlog (AUTOID,TXDATE,TXNUM,QTTY,MAPQTTY,CODEID,PCAMASTID,CAMASTID,ACCTNO,MODIFIEDDATE,AFACCTNO,PRICE,PITRATE,CARATE)
                                     values(SEQ_SEPITLOG.NEXTVAL, TO_DATE (rec.txdate, 'DD/MM/RRRR'),'', floor(to_number(rec.QTTY-rec.MAPQTTY) / v_dblCARATE),0, v_strtocodeid, rec.CAMASTID,p_txmsg.txfields('02').value,
                                         substr(rec.ACCTNO,1,10) || v_strtocodeid, TO_DATE (p_txmsg.txdate, 'DD/MM/RRRR'), rec.AFACCTNO, rec.PRICE, rec.PITRATE,to_number(nvl(rec.CARATE,1)) * v_dblCARATE) ;

                                UPDATE SEPITLOG SET QTTY=MAPQTTY
                                    WHERE AUTOID=rec.AUTOID;

                            end loop;

                        end if;
                    exception when others then
                        null;
                    end;

                    --End of HaiLT them de phan bo vao SEPITLOG
                end if;
                v_dblDFQTTY:= rec.DFQTTY;
                If v_dblDFQTTY > 0 And rec.ISSE = 'N' Then
                    CSPKS_DFPROC.pr_CADealReceive(p_txmsg.txfields('01').value,v_dblDFQTTY,p_err_code);
                end if;
                if p_txmsg.tltxcd in ('3350','3352','3354') THEN
                  --PhuongHT edit: doi trang thai sau khi phan bo tien
                    UPDATE CASCHD SET ISCI='Y',pstatus=pstatus||status,
                    status= (CASE WHEN ((status='H' OR status='W' OR qtty= 0) AND aqtty =0) THEN 'J' ELSE 'G' END)
                    WHERE AUTOID=p_txmsg.txfields('01').value AND DELTD ='N';
                   -- neu la caschd cuoi cung thi update trong camast
                   -- kiem tra xem co tai khoan nao chua dc phan bo tien khong
                   if not length(trim(p_txmsg.reftxnum))=10 then
                        SELECT count(1) into v_countCI FROM CASCHD
                          WHERE  CAMASTID=p_txmsg.txfields('02').value  AND DELTD ='N'
                          AND amt> 0 AND ISCI='N' AND isexec='Y'
                          AND status <> 'O';
                         -- kiem tra xem co tai khoan nao chua dc phan bo CK khong
                          SELECT count(1) into v_countSE FROM CASCHD
                          WHERE  CAMASTID=p_txmsg.txfields('02').value  AND DELTD ='N'
                          AND qtty> 0 AND ISSE='N'
                          AND status <> 'O';
                          -- update trang thai trong CAMAST
                          if(v_countCI = 0 AND v_countSE = 0) THEN
                          UPDATE CAMAST SET STATUS ='J'
                          WHERE CAMASTID=p_txmsg.txfields('02').value;
                          ELSIF (v_countCI= 0 AND v_countSE > 0) THEN
                          UPDATE CAMAST SET STATUS ='G'
                          WHERE CAMASTID=p_txmsg.txfields('02').value;
                          END IF;
                   end if;

                    --HaiLT them de khi Tien CA ve thi giai toa trong DFMAST va chuyen vao DFAMT trong DFGROUP
                    if p_txmsg.tltxcd in ('3350') AND rec.DFAMT>0 then
                        for rec1 in (select * from dfmast where dfref = p_txmsg.txfields('01').value and DEALTYPE='T')
                            loop
                                UPDATE DFMAST SET CACASHQTTY=CACASHQTTY-rec1.CACASHQTTY where acctno=rec1.ACCTNO;
                                UPDATE DFGROUP SET DFAMT =DFAMT + rec1.CACASHQTTY WHERE GROUPID=rec1.GROUPID;
                                UPDATE CASCHD SET DFAMT=DFAMT - rec1.CACASHQTTY WHERE AUTOID= rec1.dfref;
                            end loop;
                    end if;
                    --End of HaiLT them de khi Tien CA ve thi giai toa trong DFMAST va chuyen vao DFAMT trong DFGROUP

                elsif p_txmsg.tltxcd='3351' then
                    UPDATE CASCHD SET ISSE='Y',  pstatus=pstatus||status,
                    status=(CASE WHEN (status='G' OR amt= 0) THEN 'J' ELSE 'H' END)

                     WHERE AUTOID=p_txmsg.txfields('01').value AND DELTD ='N';
                      -- neu la caschd cuoi cung thi update trong camast
                   -- kiem tra xem co tai khoan nao chua dc phan bo tien khong
                   if not length(trim(p_txmsg.reftxnum))=10 then
                     SELECT count(1) into v_countCI FROM CASCHD
                      WHERE  CAMASTID=p_txmsg.txfields('02').value  AND DELTD ='N'
                      AND amt> 0 AND ISCI='N' AND isexec='Y'
                      AND status <>'O';
                     -- kiem tra xem co tai khoan nao chua dc phan bo CK khong
                      SELECT count(1) into v_countSE FROM CASCHD
                      WHERE  CAMASTID=p_txmsg.txfields('02').value  AND DELTD ='N'
                      AND qtty> 0 AND ISSE='N'
                      AND status <> 'O';
                      -- update trang thai trong CAMAST
                      if(v_countCI = 0 AND v_countSE = 0) THEN
                      UPDATE CAMAST SET STATUS ='J'
                      WHERE CAMASTID=p_txmsg.txfields('02').value;
                      ELSIF (v_countCI> 0 AND v_countSE = 0) THEN
                      UPDATE CAMAST SET STATUS ='H'
                      WHERE CAMASTID=p_txmsg.txfields('02').value;
                      END IF;
                   end if;
                end if;
                If Not ((p_txmsg.tltxcd = '3350' Or p_txmsg.tltxcd = '3352' Or p_txmsg.tltxcd = '3351' Or p_txmsg.tltxcd = '3354')
                            And ((rec.ISCI = 'N' And rec.AMT+rec.AAMT > 0)
                             Or (rec.ISSE = 'N') And rec.QTTY + rec.AQTTY > 0)) Then
                    plog.debug(pkgctx,'GianhVG-Updatestatus');
                    --UPDATE CASCHD SET STATUS='C' WHERE AUTOID=p_txmsg.txfields('01').value AND DELTD ='N';
                end if;
            end if;
            exit when 0=0;
        end loop;
    else
        --UPDATE CASCHD SET STATUS='S' WHERE status='C' AND AUTOID=p_txmsg.txfields('01').value AND DELTD ='N';
        if p_txmsg.tltxcd in ('3350','3352','3354') then


               UPDATE CASCHD SET ISCI='N', PSTATUS = PSTATUS||STATUS,
                               status=(  CASE WHEN (substr(PSTATUS,length(PSTATUS),1)) ='W' THEN 'W'
                                              WHEN (status='G' OR qtty=0) THEN 'S'
                                                  ELSE 'H' END)
               WHERE AUTOID=p_txmsg.txfields('01').value AND DELTD ='N';
              -- kiem tra xem co tai khoan nao chua dc phan bo tien khong
                    if not length(trim(p_txmsg.reftxnum))=10 then
                     SELECT count(1) into v_countCI FROM CASCHD
                      WHERE  CAMASTID=p_txmsg.txfields('02').value  AND DELTD ='N'
                      AND  ISCI='N' AND isexec='Y'
                      AND status <> 'O';
                     -- kiem tra xem co tai khoan nao chua dc phan bo CK khong
                      SELECT count(1) into v_countSE FROM CASCHD
                      WHERE  CAMASTID=p_txmsg.txfields('02').value  AND DELTD ='N'
                      AND  ISSE='N'
                      AND status <> 'O';
                      -- update trang thai trong CAMAST
                      if(v_countCI > 0 AND v_countSE > 0) THEN
                      UPDATE CAMAST SET STATUS ='I'
                      WHERE CAMASTID=p_txmsg.txfields('02').value;
                      ELSIF (v_countCI> 0 AND v_countSE = 0) THEN
                      UPDATE CAMAST SET STATUS ='H'
                      WHERE CAMASTID=p_txmsg.txfields('02').value;
                      ELSIF (v_countCI= 0 AND v_countSE > 0) THEN
                      UPDATE CAMAST SET STATUS ='G'
                      WHERE CAMASTID=p_txmsg.txfields('02').value;
                      END IF;
                    end if;


             --HaiLT them de khi Tien CA ve thi giai toa trong DFMAST va chuyen vao DFAMT trong DFGROUP
            if p_txmsg.tltxcd in ('3350') then
                for rec1 in (select * from dfmast where dfref = p_txmsg.txfields('01').value and DEALTYPE='T')
                    loop
                        UPDATE DFMAST SET CACASHQTTY= CACASHQTTY + rec1.AMT * 100 / rec1.DFRATE  where acctno=rec1.ACCTNO;
                        UPDATE DFGROUP SET DFAMT =DFAMT - rec1.AMT WHERE GROUPID=rec1.GROUPID;
                    end loop;
            end if;
            --End of HaiLT them de khi Tien CA ve thi giai toa trong DFMAST va chuyen vao DFAMT trong DFGROUP

        elsif p_txmsg.tltxcd='3351' then
             UPDATE CASCHD SET ISSE='N',PSTATUS = PSTATUS||STATUS,
             status=( CASE WHEN (status='H' OR amt=0) THEN 'S' ELSE 'G' END)
             WHERE AUTOID=p_txmsg.txfields('01').value AND DELTD ='N';
                -- kiem tra xem co tai khoan nao chua dc phan bo tien khong
                    if not length(trim(p_txmsg.reftxnum))=10 then
                     SELECT count(1) into v_countCI FROM CASCHD
                      WHERE  CAMASTID=p_txmsg.txfields('02').value  AND DELTD ='N'
                      AND ISCI='N' AND isexec='Y'
                      AND status <> 'O';
                     -- kiem tra xem co tai khoan nao chua dc phan bo CK khong
                      SELECT count(1) into v_countSE FROM CASCHD
                      WHERE  CAMASTID=p_txmsg.txfields('02').value  AND DELTD ='N'
                      AND ISSE='N'
                      AND status <> 'O';
                      -- update trang thai trong CAMAST
                      if(v_countCI > 0 AND v_countSE > 0) THEN
                      UPDATE CAMAST SET STATUS ='I'
                      WHERE CAMASTID=p_txmsg.txfields('02').value;
                      ELSIF (v_countCI> 0 AND v_countSE = 0) THEN
                      UPDATE CAMAST SET STATUS ='H'
                      WHERE CAMASTID=p_txmsg.txfields('02').value;
                      ELSIF (v_countCI= 0 AND v_countSE > 0) THEN
                      UPDATE CAMAST SET STATUS ='G'
                      WHERE CAMASTID=p_txmsg.txfields('02').value;
                      END IF;
                    end if;

        end if;
        if p_txmsg.tltxcd='3351' then
            --HaiLT them de xoa trong SEPITLOG khi xoa gd 3351
            for rec in (
                SELECT CAS.*, CAM.TOCODEID FROM CASCHD CAS, CAMAST CAM
                WHERE CAS.AUTOID = p_txmsg.txfields('01').value
                    AND CAS.CAMASTID=CAM.CAMASTID AND CAS.CAMASTID= p_txmsg.txfields('02').value
            )
            loop
                UPDATE SEPITLOG SET CAMASTID=PCAMASTID,
                        PCAMASTID= '',
                        CODEID = rec.CODEID
                    WHERE CODEID=rec.TOCODEID and afacctno=  p_txmsg.txfields('03').value;
            end loop;
            DELETE FROM SEPITLOG WHERE CAMASTID = p_txmsg.txfields('02').value and afacctno=  p_txmsg.txfields('03').value;
            --End of HaiLT de xoa trong SEPITLOG khi xoa gd 3351
        end if;
    end if;

    /*If Not v_blnREVERSAL Then
        SELECT count(1) into v_count
        FROM CASCHD WHERE STATUS<>'C'
        AND CAMASTID=p_txmsg.txfields('02').value AND DELTD ='N';
        if v_count =0 then
            UPDATE CAMAST SET STATUS='C' WHERE CAMASTID=p_txmsg.txfields('02').value;
            --AP DUNG CHO TRUONG HOP DAC BIET
            for rec in (
                SELECT CAMAST.*,SBSECURITIES.SYMBOL FROM CAMAST,SBSECURITIES
                    WHERE CAMASTID=p_txmsg.txfields('02').value
                        AND CAMAST.CODEID=SBSECURITIES.CODEID
            )
            loop
                if rec.catype ='012' or rec.catype ='013' then
                    SELECT count(1) into v_count FROM CASCHD
                        WHERE STATUS<>'C' AND CAMASTID=p_txmsg.txfields('02').value AND DELTD ='N';
                    if v_count= 0 then
                        UPDATE SBSECURITIES SET PARVALUE = PARVALUE * (rec.SPLITRATE) WHERE CODEID=rec.codeid;
                    end if;
                elsif rec.catype ='019' then
                    UPDATE SBSECURITIES SET TRADEPLACE =rec.TOTRADEPLACE WHERE CODEID=rec.CODEID;
                    DELETE SECURITIES_TICKSIZE WHERE CODEID=rec.codeid;
                    if rec.TOTRADEPLACE='001' then --San HCM
                        INSERT INTO SECURITIES_TICKSIZE (AUTOID,CODEID,SYMBOL,TICKSIZE,FROMPRICE,TOPRICE,STATUS) VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL,rec.codeid,rec.symbol,100,0,49900,'Y');
                        INSERT INTO securities_ticksize (AUTOID,CODEID,SYMBOL,TICKSIZE,FROMPRICE,TOPRICE,STATUS) VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL,rec.codeid,rec.symbol,500,50000,99500,'Y');
                        INSERT INTO securities_ticksize (AUTOID,CODEID,SYMBOL,TICKSIZE,FROMPRICE,TOPRICE,STATUS) VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL,rec.codeid,rec.symbol,1000,100000,100000000000,'Y');
                    elsif rec.TOTRADEPLACE='002' then --San HNX
                       INSERT INTO securities_ticksize (AUTOID,CODEID,SYMBOL,TICKSIZE,FROMPRICE,TOPRICE,STATUS) VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL,rec.codeid,rec.symbol,100,0,1000000000,'Y') ;
                    end if;
                    if rec.TOTRADEPLACE='001' then --San HCM
                        UPDATE  SECURITIES_INFO SET  TRADELOT ='100' WHERE CODEID = rec.codeid;
                    elsif rec.TOTRADEPLACE='002' then --San HNX
                        UPDATE  SECURITIES_INFO SET  TRADELOT ='100' WHERE CODEID = rec.codeid;
                    end if;
                end if;
                exit when 0=0;
            end loop;
        end if;
    else
        SELECT count(1) into v_count FROM CASCHD WHERE STATUS='C' AND CAMASTID=p_txmsg.txfields('02').value AND DELTD ='N';
        if v_count=0 then
            UPDATE CAMAST SET STATUS='I' WHERE CAMASTID=p_txmsg.txfields('02').value;
            --'AP DUNG CHO TRUONG HOP DAC BIET
            for rec in (
                SELECT CAMAST.*,SBSECURITIES.SYMBOL
                    FROM CAMAST,SBSECURITIES
                    WHERE CAMASTID=p_txmsg.txfields('02').value AND CAMAST.CODEID=SBSECURITIES.CODEID
            )
            loop
                if rec.catype ='012' or rec.catype ='013' then
                    SELECT count(1) into v_count FROM CASCHD
                        WHERE STATUS<>'C' AND CAMASTID=p_txmsg.txfields('02').value AND DELTD ='N';
                    if v_count= 0 then
                        UPDATE SBSECURITIES SET PARVALUE =rec.PARVALUE WHERE CODEID=rec.codeid;
                    end if;
                elsif rec.catype ='019' then
                    UPDATE SBSECURITIES SET TRADEPLACE =rec.FRTRADEPLACE WHERE CODEID=rec.CODEID;
                    DELETE SECURITIES_TICKSIZE WHERE CODEID=rec.codeid;
                    if rec.FRTRADEPLACE='001' then --San HCM
                        INSERT INTO SECURITIES_TICKSIZE (AUTOID,CODEID,SYMBOL,TICKSIZE,FROMPRICE,TOPRICE,STATUS) VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL,rec.codeid,rec.symbol,100,0,49900,'Y');
                        INSERT INTO securities_ticksize (AUTOID,CODEID,SYMBOL,TICKSIZE,FROMPRICE,TOPRICE,STATUS) VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL,rec.codeid,rec.symbol,500,50000,99500,'Y');
                        INSERT INTO securities_ticksize (AUTOID,CODEID,SYMBOL,TICKSIZE,FROMPRICE,TOPRICE,STATUS) VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL,rec.codeid,rec.symbol,1000,100000,100000000000,'Y');
                    elsif rec.FRTRADEPLACE='002' then --San HNX
                       INSERT INTO securities_ticksize (AUTOID,CODEID,SYMBOL,TICKSIZE,FROMPRICE,TOPRICE,STATUS) VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL,rec.codeid,rec.symbol,100,0,1000000000,'Y');
                    end if;
                    if rec.FRTRADEPLACE='001' then --San HCM
                        UPDATE  SECURITIES_INFO SET  TRADELOT ='100' WHERE CODEID = rec.codeid;
                    elsif rec.FRTRADEPLACE='002' then --San HNX
                        UPDATE  SECURITIES_INFO SET  TRADELOT ='100' WHERE CODEID = rec.codeid;
                    end if;
                end if;
                exit when 0=0;

            end loop;
        end if;
    end if;*/

    plog.debug (pkgctx, '<<END OF fn_ExecuteContractCAEvent');
    plog.setendsection (pkgctx, 'fn_ExecuteContractCAEvent');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
       plog.setendsection (pkgctx, 'fn_ExecuteContractCAEvent');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_ExecuteContractCAEvent;
-- initial LOG
BEGIN
   SELECT *
   INTO logrow
   FROM tlogdebug
   WHERE ROWNUM <= 1;

   pkgctx    :=
      plog.init ('cspks_caproc',
                 plevel => logrow.loglevel,
                 plogtable => (logrow.log4table = 'Y'),
                 palert => (logrow.log4alert = 'Y'),
                 ptrace => (logrow.log4trace = 'Y')
      );
END;
/
