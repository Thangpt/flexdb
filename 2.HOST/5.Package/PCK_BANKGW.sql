CREATE OR REPLACE PACKAGE pck_bankgw IS

  -- Author  : ADMINISTRATOR
  -- Created : 27/05/2020 13:19:20
  -- Purpose : Process For BankGW New

  PROCEDURE pr_getAccountList(
            pv_refCursor        OUT pkg_report.ref_cursor,
            p_custodycd         IN VARCHAR2,
            p_acctno            IN VARCHAR2,
            p_bankcode          IN VARCHAR2
  );

  PROCEDURE pr_putBatchTran(
            p_err_code          OUT VARCHAR2,
            p_err_message       OUT VARCHAR2,
            p_signature         IN VARCHAR2,
            p_bankCode          IN VARCHAR2,
            p_tranDate          IN VARCHAR2,
            p_batchID             IN VARCHAR2,
            p_custodyCode         IN VARCHAR2,
            p_accountNumber     IN VARCHAR2,
            p_bankAccNo         IN VARCHAR2,
            p_amount            IN NUMBER,
            p_ccycd             IN VARCHAR2,
            p_description         IN VARCHAR2
  );

  PROCEDURE pr_getBatchTranStatus(
            pv_refCursor        OUT pkg_report.ref_cursor,
            p_bankCode          IN VARCHAR2,
            p_batchID           IN VARCHAR2,
            p_bankAccNo         IN VARCHAR2
  );

  PROCEDURE pr_putFluctuation(
            p_err_code          OUT VARCHAR2,
            p_err_message       OUT VARCHAR2,
            p_bankCode          IN VARCHAR2,
            p_ref_number          IN VARCHAR2,
            p_time              IN NUMBER,
            p_amount            IN NUMBER,
            p_bank_trans_id     IN VARCHAR2,
            p_bank_trans_date     IN VARCHAR2,
            p_sec_bank_acc      IN VARCHAR2,
            p_description         IN VARCHAR2,
            p_currency          IN VARCHAR2,
            p_signature         IN VARCHAR2
  );

  PROCEDURE pr_getTransferRequest(
            pv_refCursor        OUT pkg_report.ref_cursor,
            p_bankcode          IN VARCHAR2,
            p_maxcount          IN NUMBER
  );

  PROCEDURE pr_completeTransferRequest(
            p_err_code          OUT VARCHAR2,
            p_err_message       OUT VARCHAR2,
            p_transactionid     IN VARCHAR2,
            p_messageid         IN VARCHAR2,
            p_bankid            IN VARCHAR2,
            p_banktime          IN VARCHAR2,
            p_res_code          IN VARCHAR2,
            p_res_message       IN VARCHAR2
  );

  PROCEDURE pr_rejectTransferRequest(
            p_err_code          OUT VARCHAR2,
            p_err_message       OUT VARCHAR2,
            p_transactionid     IN VARCHAR2
  );
  PROCEDURE pr_getRetryTransferRequest(
            pv_refCursor        OUT pkg_report.ref_cursor,
            p_maxcount          IN NUMBER
  );
  PROCEDURE pr_retryTransferRequest(
            p_err_code          OUT VARCHAR2,
            p_err_message       OUT VARCHAR2,
            p_transactionid     IN VARCHAR2
  );
  PROCEDURE pr_retryCountIncrease(
            p_err_code          OUT VARCHAR2,
            p_err_message       OUT VARCHAR2,
            p_transactionid     IN VARCHAR2
  );
  PROCEDURE pr_insertTransferRequest;

  PROCEDURE pr_excute_comparedata(
            p_err_code          OUT VARCHAR2,
            p_err_message       OUT VARCHAR2,
            pv_filename         IN VARCHAR2
  );
  PROCEDURE pr_excute_collectdata(
            p_err_code          OUT VARCHAR2,
            p_err_message       OUT VARCHAR2,
            pv_filename         IN VARCHAR2
  );
  PROCEDURE pr_getSuccessTrans(
            pv_refCursor        OUT pkg_report.ref_cursor
  );
  PROCEDURE pr_getAfterCompareTransaction(
            pv_refCursor        OUT pkg_report.ref_cursor,
            pv_status           IN VARCHAR2,
            pv_filename         IN VARCHAR2
  );
  PROCEDURE pr_getAfterCollectTransaction(
            pv_refCursor        OUT pkg_report.ref_cursor,
            pv_filename         IN VARCHAR2
  );
  PROCEDURE pr_getTransferTransaction(
            pv_refCursor        OUT pkg_report.ref_cursor,
            p_bankcode          IN VARCHAR2
  );

END PCK_BANKGW;
/
CREATE OR REPLACE PACKAGE BODY pck_bankgw IS
  -- declare log context
  pkgctx   plog.log_ctx;
  logrow   tlogdebug%ROWTYPE;

  PROCEDURE pr_getAccountList(
            pv_refCursor        OUT pkg_report.ref_cursor,
            p_custodycd         IN VARCHAR2,
            p_acctno            IN VARCHAR2,
            p_bankcode          IN VARCHAR2
  ) IS
     l_custodycd   VARCHAR2(50);
     l_acctno      VARCHAR2(50);
     l_bankcode    VARCHAR2(50);
  BEGIN
     plog.setBeginSection(pkgctx, 'pr_getAccountList');

     OPEN pv_refCursor FOR
        SELECT CF.CUSTODYCD, UPPER(PCK_GWTRANSFER.CORRECT_REMARK(CF.FULLNAME, 200)) FULLNAME,
               AF.ACCTNO, AF.ACCTNO || '.' || UPPER(PCK_GWTRANSFER.CORRECT_REMARK(CF.FULLNAME, 200)) || '.' || AFT.TYPENAME DESCRIPTION,
               BA.BANKACCTNO ACCTNOSUM, UPPER(PCK_GWTRANSFER.CORRECT_REMARK(BA.OWNERNAME, 200)) OWNERNAME
        FROM CFMAST CF, AFMAST AF, AFTYPE AFT, BANKNOSTRO BA
        WHERE CF.CUSTID = AF.CUSTID
          AND AF.ACTYPE = AFT.ACTYPE
          AND AF.STATUS IN ('A', 'P')
          AND BA.GLACCOUNT = p_bankcode
          AND p_custodycd = CF.CUSTODYCD
          AND NVL(p_acctno, AF.ACCTNO) = AF.ACCTNO;

     plog.setEndSection(pkgctx, 'pr_getAccountList');
  EXCEPTION WHEN OTHERS THEN
     plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
     plog.setEndSection (pkgctx, 'pr_getAccountList');
  END;

  PROCEDURE pr_putBatchTran(
            p_err_code          OUT VARCHAR2,
            p_err_message       OUT VARCHAR2,
            p_signature         IN VARCHAR2,
            p_bankCode          IN VARCHAR2,
            p_tranDate          IN VARCHAR2,
            p_batchID            IN VARCHAR2,
            p_custodyCode        IN VARCHAR2,
            p_accountNumber      IN VARCHAR2,
            p_bankAccNo         IN VARCHAR2,
            p_amount            IN NUMBER,
            p_ccycd              IN VARCHAR2,
            p_description        IN VARCHAR2
  ) IS
     v_reqid      NUMBER;
     v_currdate   DATE;

     v_fullname   cfmast.fullname%TYPE;
     v_address    cfmast.address%TYPE;
     v_idcode     cfmast.idcode%TYPE;
     v_iddate     cfmast.iddate%TYPE;
     v_idplace    cfmast.idplace%TYPE;
     v_afacctno   afmast.acctno%TYPE;

     l_txmsg      tx.msg_rectype;
     l_errcode    NUMBER;
     l_err_param  VARCHAR2(300);
     v_bankid     varchar2(200);
  BEGIN
     plog.setBeginSection(pkgctx, 'pr_putBatchTran');
     v_reqid := seq_tcdtreceiverequest.nextval;
     v_currdate := getcurrdate;
     v_afacctno := p_accountNumber;

     BEGIN
        INSERT INTO tcdtreceiverequestext(autoid, txdate, tranid, trandate, bankcode, bankaccno, custodycd, afacctno, amount, ccycd, trandesc, signature)
        VALUES(v_reqid, v_currdate, p_batchID, p_tranDate, p_bankCode, p_bankAccNo, p_custodyCode, p_accountNumber, p_amount, p_ccycd, p_description, p_signature);
        COMMIT;
     EXCEPTION WHEN OTHERS THEN
        p_err_code := '-670051';
        p_err_message := cspks_system.fn_get_en_errmsg(p_err_code);
        plog.setEndSection(pkgctx, 'pr_putBatchTran');
        RETURN;
     END;

     -- Uu tien chuyen tien vao tai khoan margin
     IF v_afacctno IS NULL THEN
        SELECT MIN(af.acctno) INTO v_afacctno
        FROM cfmast cf, afmast af, aftype aft, mrtype mrt
        WHERE cf.custid = af.custid AND af.status = 'A' AND af.corebank <> 'Y'
          AND af.actype = aft.actype
          AND aft.mrtype = mrt.actype AND mrt.mrtype = 'T'
          AND cf.custodycd = p_custodyCode;
     END IF;

     -- Neu khong co thi chuyen vao tai khoan thuong
     IF v_afacctno IS NULL THEN
        SELECT MIN(af.acctno) INTO v_afacctno
        FROM cfmast cf, afmast af
        WHERE cf.custid = af.custid AND af.status = 'A' AND af.corebank<>'Y'
        AND cf.custodycd = p_custodyCode;
     END IF;

     BEGIN
        SELECT cf.fullname, cf.address, cf.idcode, cf.iddate, cf.idplace
        INTO v_fullname, v_address, v_idcode, v_iddate, v_idplace
        FROM cfmast cf, afmast af
        WHERE cf.custid = af.custid
         AND cf.custodycd = p_custodyCode AND af.acctno = v_afacctno;
     EXCEPTION WHEN OTHERS THEN
        p_err_code := '-670032';
        p_err_message := cspks_system.fn_get_en_errmsg(p_err_code);
        UPDATE tcdtreceiverequestext SET status = 'E', errorcode = p_err_code, errordesc = p_err_message
        WHERE autoid = v_reqid;
        plog.setEndSection(pkgctx, 'pr_putBatchTran');
        RETURN;
     END;

     --thang.pham
     begin
       select glaccount into v_bankid
       from banknostro where shortname = '119';
     exception when others then
       v_bankid := 'VPB DD';
     end;
     --end

     l_txmsg.msgtype   := 'T';
     l_txmsg.local     := 'N';
     l_txmsg.tlid      := systemnums.c_system_userid;
     l_txmsg.off_line  := 'N';
     l_txmsg.deltd     := txnums.c_deltd_txnormal;
     l_txmsg.txstatus  := txstatusnums.c_txcompleted;
     l_txmsg.msgsts    := '0';
     l_txmsg.ovrsts    := '0';
     l_txmsg.batchname := 'DAY';
     l_txmsg.txdate    := v_currdate;
     l_txmsg.busdate   := v_currdate;
     l_txmsg.brid      := substr(p_accountNumber,1,4);
     l_txmsg.tltxcd    := '1141';

     SELECT SYS_CONTEXT ('USERENV', 'HOST'), SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
     INTO l_txmsg.wsname, l_txmsg.ipaddress FROM DUAL;

     -- Set txnum
     SELECT systemnums.C_BATCH_PREFIXED || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
     INTO l_txmsg.txnum FROM DUAL;

     l_txmsg.txfields ('82').defname   := 'CUSTODYCD';
     l_txmsg.txfields ('82').TYPE      := 'C';
     l_txmsg.txfields ('82').VALUE     := p_custodyCode;

     l_txmsg.txfields ('00').defname   := 'AUTOID';
     l_txmsg.txfields ('00').TYPE      := 'C';
     l_txmsg.txfields ('00').VALUE     := v_reqid;

     l_txmsg.txfields ('03').defname   := 'ACCTNO';
     l_txmsg.txfields ('03').TYPE      := 'C';
     l_txmsg.txfields ('03').VALUE     := v_afacctno;

     l_txmsg.txfields ('90').defname   := 'CUSTNAME';
     l_txmsg.txfields ('90').TYPE      := 'C';
     l_txmsg.txfields ('90').VALUE     := v_fullname;

     l_txmsg.txfields ('91').defname   := 'ADDRESS';
     l_txmsg.txfields ('91').TYPE      := 'C';
     l_txmsg.txfields ('91').VALUE     := v_address;

     l_txmsg.txfields ('92').defname   := 'LICENSE';
     l_txmsg.txfields ('92').TYPE      := 'C';
     l_txmsg.txfields ('92').VALUE     := v_idcode;

     l_txmsg.txfields ('93').defname   := 'IDDATE';
     l_txmsg.txfields ('93').TYPE      := 'C';
     l_txmsg.txfields ('93').VALUE     := to_date(v_iddate, 'DD/MM/RRRR');

     l_txmsg.txfields ('94').defname   := 'IDPLACE';
     l_txmsg.txfields ('94').TYPE      := 'C';
     l_txmsg.txfields ('94').VALUE     := v_idplace;

     l_txmsg.txfields ('02').defname   := 'BANKID';
     l_txmsg.txfields ('02').TYPE      := 'C';
     l_txmsg.txfields ('02').VALUE     := v_bankid;

     l_txmsg.txfields ('05').defname   := 'BANKACCTNO';
     l_txmsg.txfields ('05').TYPE      := 'C';
     l_txmsg.txfields ('05').VALUE     := '';

     l_txmsg.txfields ('06').defname   := 'GLMAST';
     l_txmsg.txfields ('06').TYPE      := 'C';
     l_txmsg.txfields ('06').VALUE     := '';

     l_txmsg.txfields ('10').defname   := 'AMT';
     l_txmsg.txfields ('10').TYPE      := 'N';
     l_txmsg.txfields ('10').VALUE     := p_amount;

     l_txmsg.txfields ('31').defname   := 'REFNUM';
     l_txmsg.txfields ('31').TYPE      := 'C';
     l_txmsg.txfields ('31').VALUE     := p_batchID;

     l_txmsg.txfields ('30').defname   := 'DESC';
     l_txmsg.txfields ('30').TYPE      := 'C';
     l_txmsg.txfields ('30').VALUE     := p_description;

     BEGIN
        IF txpks_#1141.fn_autotxprocess (l_txmsg, l_errcode, l_err_param)
          <> systemnums.c_success
        THEN
           p_err_code := l_errcode;
           p_err_message := cspks_system.fn_get_en_errmsg(p_err_code);
           UPDATE tcdtreceiverequestext SET status = 'E', errorcode = p_err_code, errordesc = p_err_message
           WHERE autoid = v_reqid;
           plog.setEndSection(pkgctx, 'pr_putBatchTran');
           RETURN;
        END IF;
     END;

     p_err_code := '0';
     p_err_message := 'Success' ;
     UPDATE tcdtreceiverequestext SET status = 'C', txnum = l_txmsg.txnum,
                                      errorcode = p_err_code, errordesc = p_err_message
     WHERE autoid = v_reqid;
     plog.setEndSection(pkgctx, 'pr_putBatchTran');
  EXCEPTION WHEN OTHERS THEN
     ROLLBACK;
     p_err_code := errnums.c_system_error;
     p_err_message := cspks_system.fn_get_en_errmsg(p_err_code);
     UPDATE tcdtreceiverequestext SET status = 'E', errorcode = p_err_code, errordesc = p_err_message
     WHERE autoid = v_reqid;
     plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
     plog.setEndSection(pkgctx, 'pr_putBatchTran');
  END;

  PROCEDURE pr_getBatchTranStatus(
            pv_refCursor        OUT pkg_report.ref_cursor,
            p_bankCode          IN VARCHAR2,
            p_batchID           IN VARCHAR2,
            p_bankAccNo         IN VARCHAR2
  ) IS

  BEGIN
     plog.setBeginSection(pkgctx, 'pr_getBatchTranStatus');

     OPEN pv_refCursor FOR
     SELECT req.tranid, req.txnum, req.custodycd, req.afacctno, req.bankaccno,
            req.amount, req.ccycd, req.trandesc, req.errorcode, req.errordesc
     FROM tcdtreceiverequestext req
     WHERE req.bankcode = p_bankCode
       AND nvl(p_bankAccNo, req.bankaccno) = req.bankaccno
       AND nvl(p_batchID, req.tranid) = req.tranid
     ORDER BY req.autoid DESC;

     plog.setEndSection(pkgctx, 'pr_getBatchTranStatus');
  EXCEPTION WHEN OTHERS THEN
     plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
     plog.setEndSection (pkgctx, 'pr_getBatchTranStatus');
  END;

  PROCEDURE pr_putFluctuation(
            p_err_code          OUT VARCHAR2,
            p_err_message       OUT VARCHAR2,
            p_bankCode          IN VARCHAR2,
            p_ref_number        IN VARCHAR2,
            p_time              IN NUMBER,
            p_amount            IN NUMBER,
            p_bank_trans_id      IN VARCHAR2,
            p_bank_trans_date    IN VARCHAR2,
            p_sec_bank_acc      IN VARCHAR2,
            p_description        IN VARCHAR2,
            p_currency          IN VARCHAR2,
            p_signature         IN VARCHAR2
  ) IS
   v_reqid                       number;
   v_currdate   DATE;

   v_fullname   cfmast.fullname%TYPE;
   v_address    cfmast.address%TYPE;
   v_idcode     cfmast.idcode%TYPE;
   v_iddate     cfmast.iddate%TYPE;
   v_idplace    cfmast.idplace%TYPE;
   v_afacctno   afmast.acctno%TYPE;
   v_custodycd  cfmast.custodycd%type;

   l_txmsg      tx.msg_rectype;
   l_errcode    NUMBER;
   l_err_param  VARCHAR2(300);
   v_description                 varchar2(500);
   v_count      NUMBER;
   v_bankid     varchar2(200);
  BEGIN
     plog.setBeginSection(pkgctx, 'pr_putFluctuation');
     p_err_code := '0';
     p_err_message := 'Success';
     v_currdate := getcurrdate;
     v_reqid := seq_putfluctuationlog.nextval;
     BEGIN
       insert into putfluctuationlog(autoid, bankcode,refnum,time,amount,tranid,trandate,bankacct,description,currency,signature, txdate )
       values(v_reqid, p_bankCode, p_ref_number, p_time, p_amount, p_bank_trans_id, to_date(substr(p_bank_trans_date,1,10),'dd/mm/rrrr'),
       p_sec_bank_acc, p_description, p_currency, p_signature, v_currdate);
       COMMIT;
     EXCEPTION WHEN OTHERS THEN
        p_err_code := '-670051';
        p_err_message := cspks_system.fn_get_en_errmsg(p_err_code);
        --UPDATE putfluctuationlog SET status = 'E', errcode = p_err_code, errmsg = p_err_message;
        plog.setEndSection(pkgctx, 'pr_putFluctuation');
        RETURN;
     END;
     v_description := UPPER(REPLACE(p_description,' '));

     v_custodycd := upper(case when instr(v_description,'091') > 0 and instr(substr(v_description,instr(v_description,'091'),10),' ') = 0 then substr(v_description,instr(v_description,'091'),10) else '' end);
     IF v_custodycd is not null then
       select count(*) into v_count
       from cfmast where custodycd = v_custodycd;
       if v_count = 0 then
          p_err_code := '-670032';
          p_err_message := cspks_system.fn_get_en_errmsg(p_err_code);
          UPDATE putfluctuationlog SET status = 'E', errcode = p_err_code, errmsg = p_err_message
          WHERE autoid = v_reqid;
          plog.setEndSection(pkgctx, 'pr_putFluctuation');
          RETURN;
       end if;
       v_afacctno := 'ZZ';
      FOR rec IN (
      SELECT cf.custodycd||aft.prodtype AFACCTNO, af.acctno FROM afmast af, cfmast cf, aftype aft
      WHERE af.custid = cf.custid
        AND cf.custodycd = v_custodycd
        AND af.status = 'A'
        AND af.corebank <> 'Y'
        AND af.actype = aft.actype
        ORDER BY af.acctno DESC
      )
      LOOP
        IF instr(v_description,rec.AFACCTNO) > 0 THEN
          v_afacctno := rec.acctno;
        END IF;
        EXIT WHEN v_afacctno <> 'ZZ';
      END LOOP;
       select count(*) into v_count
       from afmast where acctno = v_afacctno;

       if v_count = 0 then
         v_afacctno := '';
       end if;

       IF v_afacctno IS NULL THEN
          SELECT MIN(af.acctno) INTO v_afacctno
          FROM cfmast cf, afmast af, aftype aft, mrtype mrt
          WHERE cf.custid = af.custid AND af.status = 'A' AND af.corebank <> 'Y'
            AND af.actype = aft.actype
            AND aft.mrtype = mrt.actype AND mrt.mrtype = 'T'
            AND cf.custodycd = v_custodycd;
       END IF;

       -- Neu khong co thi chuyen vao tai khoan thuong
       IF v_afacctno IS NULL THEN
          SELECT MIN(af.acctno) INTO v_afacctno
          FROM cfmast cf, afmast af
          WHERE cf.custid = af.custid AND af.status = 'A' AND af.corebank<>'Y'
          AND cf.custodycd = v_custodycd;
       END IF;


       BEGIN
          SELECT cf.fullname, cf.address, cf.idcode, cf.iddate, cf.idplace
          INTO v_fullname, v_address, v_idcode, v_iddate, v_idplace
          FROM cfmast cf, afmast af
          WHERE cf.custid = af.custid
           AND cf.custodycd = v_custodycd AND af.acctno = v_afacctno;
       EXCEPTION WHEN OTHERS THEN
          p_err_code := '-670032';
          p_err_message := cspks_system.fn_get_en_errmsg(p_err_code);
          UPDATE putfluctuationlog SET status = 'E', errcode = p_err_code, errmsg = p_err_message
          WHERE autoid = v_reqid;
          plog.setEndSection(pkgctx, 'pr_putFluctuation');
          RETURN;
       END;

       --thang.pham
       begin
         select glaccount into v_bankid
         from banknostro where shortname = '111';
       exception when others then
         v_bankid := 'VPB HN';
       end;
       --end

       l_txmsg.msgtype   := 'T';
       l_txmsg.local     := 'N';
       l_txmsg.tlid      := systemnums.c_system_userid;
       l_txmsg.off_line  := 'N';
       l_txmsg.deltd     := txnums.c_deltd_txnormal;
       l_txmsg.txstatus  := txstatusnums.c_txcompleted;
       l_txmsg.msgsts    := '0';
       l_txmsg.ovrsts    := '0';
       l_txmsg.batchname := 'DAY';
       l_txmsg.txdate    := v_currdate;
       l_txmsg.busdate   := v_currdate;
       l_txmsg.brid      := substr(v_afacctno,1,4);
       l_txmsg.tltxcd    := '1141';

       SELECT SYS_CONTEXT ('USERENV', 'HOST'), SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
       INTO l_txmsg.wsname, l_txmsg.ipaddress FROM DUAL;

       -- Set txnum
       SELECT systemnums.C_BATCH_PREFIXED || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
       INTO l_txmsg.txnum FROM DUAL;

       l_txmsg.txfields ('82').defname   := 'CUSTODYCD';
       l_txmsg.txfields ('82').TYPE      := 'C';
       l_txmsg.txfields ('82').VALUE     := v_custodycd;

       l_txmsg.txfields ('00').defname   := 'AUTOID';
       l_txmsg.txfields ('00').TYPE      := 'C';
       l_txmsg.txfields ('00').VALUE     := v_reqid;

       l_txmsg.txfields ('03').defname   := 'ACCTNO';
       l_txmsg.txfields ('03').TYPE      := 'C';
       l_txmsg.txfields ('03').VALUE     := v_afacctno;

       l_txmsg.txfields ('90').defname   := 'CUSTNAME';
       l_txmsg.txfields ('90').TYPE      := 'C';
       l_txmsg.txfields ('90').VALUE     := v_fullname;

       l_txmsg.txfields ('91').defname   := 'ADDRESS';
       l_txmsg.txfields ('91').TYPE      := 'C';
       l_txmsg.txfields ('91').VALUE     := v_address;

       l_txmsg.txfields ('92').defname   := 'LICENSE';
       l_txmsg.txfields ('92').TYPE      := 'C';
       l_txmsg.txfields ('92').VALUE     := v_idcode;

       l_txmsg.txfields ('93').defname   := 'IDDATE';
       l_txmsg.txfields ('93').TYPE      := 'C';
       l_txmsg.txfields ('93').VALUE     := to_date(v_iddate, 'DD/MM/RRRR');

       l_txmsg.txfields ('94').defname   := 'IDPLACE';
       l_txmsg.txfields ('94').TYPE      := 'C';
       l_txmsg.txfields ('94').VALUE     := v_idplace;

       l_txmsg.txfields ('02').defname   := 'BANKID';
       l_txmsg.txfields ('02').TYPE      := 'C';
       l_txmsg.txfields ('02').VALUE     := v_bankid;

       l_txmsg.txfields ('05').defname   := 'BANKACCTNO';
       l_txmsg.txfields ('05').TYPE      := 'C';
       l_txmsg.txfields ('05').VALUE     := '';

       l_txmsg.txfields ('06').defname   := 'GLMAST';
       l_txmsg.txfields ('06').TYPE      := 'C';
       l_txmsg.txfields ('06').VALUE     := '';

       l_txmsg.txfields ('10').defname   := 'AMT';
       l_txmsg.txfields ('10').TYPE      := 'N';
       l_txmsg.txfields ('10').VALUE     := p_amount;

       l_txmsg.txfields ('31').defname   := 'REFNUM';
       l_txmsg.txfields ('31').TYPE      := 'C';
       l_txmsg.txfields ('31').VALUE     := p_ref_number;

       l_txmsg.txfields ('30').defname   := 'DESC';
       l_txmsg.txfields ('30').TYPE      := 'C';
       l_txmsg.txfields ('30').VALUE     := p_description;

       BEGIN
          IF txpks_#1141.fn_autotxprocess (l_txmsg, l_errcode, l_err_param)
            <> systemnums.c_success
          THEN
             p_err_code := l_errcode;
             p_err_message := cspks_system.fn_get_en_errmsg(p_err_code);
             UPDATE putfluctuationlog SET status = 'E', errcode = p_err_code, errmsg = p_err_message
             WHERE autoid = v_reqid;
             plog.setEndSection(pkgctx, 'pr_putFluctuation');
             RETURN;
          END IF;
       END;
       p_err_code := '0';
       p_err_message := 'Success' ;
       UPDATE putfluctuationlog SET status = 'C', txnum = l_txmsg.txnum,
                                        errcode = p_err_code, errmsg = p_err_message
       WHERE autoid = v_reqid;
       plog.setEndSection(pkgctx, 'pr_putFluctuation');
       RETURN;
     else
        p_err_code := '-670032';
        p_err_message := cspks_system.fn_get_en_errmsg(p_err_code);
        UPDATE putfluctuationlog SET status = 'E', errcode = p_err_code, errmsg = p_err_message
        WHERE autoid = v_reqid;
        plog.setEndSection(pkgctx, 'pr_putFluctuation');
        RETURN;
     end if;

     plog.setEndSection(pkgctx, 'pr_putFluctuation');
  EXCEPTION WHEN OTHERS THEN
     plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
     plog.setEndSection (pkgctx, 'pr_putFluctuation');
  END;


  PROCEDURE pr_getTransferRequest(
            pv_refCursor        OUT pkg_report.ref_cursor,
            p_bankcode          IN VARCHAR2,
            p_maxcount          IN NUMBER
  ) IS
     v_strBATCHID         VARCHAR(50);
     v_strTRANSACTIONID   VARCHAR(50);
     v_count              NUMBER;
     v_start      number;
     v_end        number;
     v_isholiday  varchar2(5);
     l_currTime   NUMBER;
  BEGIN
     plog.setBeginSection(pkgctx, 'pr_getTransferRequest');
     begin
       select holiday into v_isholiday
       from sbcldr
       where sbdate = getcurrdate
       and cldrtype = '000';
     exception when others then
       v_isholiday := 'Y';
     end;
     begin
       select to_number(varvalue) into v_start
       from sysvar
       where varname = 'START_TIME' and grname = 'SYSTEM';

       select to_number(varvalue) into v_end
       from sysvar
       where varname = 'END_TIME' and grname = 'SYSTEM';
     exception when others then
       v_start := 8;
       v_end   := 16;
     end;
     l_currTime := TO_CHAR(SYSDATE, 'hh24');

     SELECT p_bankcode || to_char(SYSDATE, 'yyyyMMddhh24missSSS') INTO v_strBATCHID FROM dual;
     v_count := 0;
     --v_strTRANSACTIONID := v_strBATCHID || lpad(to_char(v_count),4,'0');

     for rec in
       (
       select * from
       (select rownum col, log.*
       from newbankgw_log log
       where log.status in ('P')
       and log.transactionid is null)
       where rownum <= p_maxcount
      )
     loop
        update newbankgw_log set batchid = v_strBATCHID, transactionid = v_strBATCHID || lpad(to_char(rec.col),4,'0') where autoid = rec.autoid;
     end loop;
     commit;

     /*OPEN pv_refCursor FOR
     select  a.BATCHID, a.TRANSACTIONID, a.MESSAGEID, a.TRFTYPE, a.ACCTNOSUM, a.ACCOUNT, a.BENEFCUSTNAME, a.AMOUNT,
       a.CCYCD,a.REMARK,a.BANKNAME, a.BANKCODE
      from (select rownum list, log.* from newbankgw_log log where status in ('P') ) a
      where list <= p_maxcount
      and case when a.trftype in ('2','3') then 1 else
      (case when v_isholiday = 'N' and sysdate - trunc(sysdate) >= v_start /24
      and sysdate - trunc(sysdate) < v_end /24 then 1 else 0 end) end = 1
      and a.sendnum <=2;*/

     OPEN pv_refCursor FOR
       SELECT * FROM (
           SELECT a.autoid, a.BATCHID, a.TRANSACTIONID, a.MESSAGEID, a.TRFTYPE, a.ACCTNOSUM, a.ACCOUNT, a.BENEFCUSTNAME, a.AMOUNT,
                  a.CCYCD,a.REMARK,a.BANKNAME, a.BANKCODE
           FROM Newbankgw_Log a
           WHERE a.status = 'P'
           AND (case when a.trftype in ('2','3') then 1
                     when v_isholiday = 'N' AND l_currTime BETWEEN v_start AND v_end THEN 1
                     ELSE 0 END) = 1
           AND a.transactionid IS NOT NULL
       )
       WHERE rownum <= p_maxcount;

     plog.setEndSection(pkgctx, 'pr_getTransferRequest');
  EXCEPTION WHEN OTHERS THEN
     plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
     plog.setEndSection (pkgctx, 'pr_getTransferRequest');
  END;

PROCEDURE pr_completeTransferRequest(
            p_err_code          OUT VARCHAR2,
            p_err_message       OUT VARCHAR2,
            p_transactionid     IN VARCHAR2,
            p_messageid         IN VARCHAR2,
            p_bankid            IN VARCHAR2,
            p_banktime          IN VARCHAR2,
            p_res_code          IN VARCHAR2,
            p_res_message       IN VARCHAR2
  ) IS
     v_currdate   DATE;

     v_fullname   cfmast.fullname%TYPE;
     v_address    cfmast.address%TYPE;
     v_idcode     cfmast.idcode%TYPE;
     v_iddate     cfmast.iddate%TYPE;
     v_idplace    cfmast.idplace%TYPE;
     v_afacctno   afmast.acctno%TYPE;
     v_bankid     varchar2(10);
     v_txdate     ciremittance.txdate%type;
     v_txnum      ciremittance.txnum%type;
     v_amt        number;
     v_feeamt     number;
     v_desc       newbankgw_log.remark%type;
     v_benefbank  ciremittance.benefbank%type;
     v_benefacct  ciremittance.benefacct%type;
     v_benefcustname            ciremittance.benefcustname%type;
     v_citybank                 ciremittance.citybank%type;
     v_cityef                   ciremittance.cityef%type;

     l_txmsg      tx.msg_rectype;
     l_errcode    NUMBER;
     l_err_param  VARCHAR2(300);
     v_POTXNUM varchar2(100);
     v_strAutoID varchar2(100);
     l_bankDate  DATE;
  BEGIN
     plog.setBeginSection(pkgctx, 'pr_completeTransferRequest');
     p_err_code := '0';
     p_err_message := 'Success';
     plog.error('bankgw complete:'||p_transactionid);
     v_currdate := getcurrdate;

     if p_res_code = '0' THEN
       /*BEGIN
         l_bankDate := to_date(p_banktime, 'rrrr-mm-dd');
       EXCEPTION
         WHEN OTHERS THEN
           l_bankDate := trunc(SYSDATE);
       END;*/
       l_bankDate := trunc(SYSDATE);
       update newbankgw_log set status = 'C', errcode = p_res_code, errmsg = p_res_message, sendnum = sendnum + 1, messageid = p_messageid,
       bankid = p_bankid, banktime = p_banktime, bankDate = l_bankDate
       where transactionid = p_transactionid;
       l_txmsg.msgtype   := 'T';
       l_txmsg.local     := 'N';
       l_txmsg.tlid      := systemnums.c_system_userid;
       l_txmsg.off_line  := 'N';
       l_txmsg.deltd     := txnums.c_deltd_txnormal;
       l_txmsg.txstatus  := txstatusnums.c_txcompleted;
       l_txmsg.msgsts    := '0';
       l_txmsg.ovrsts    := '0';
       l_txmsg.batchname := 'DAY';
       l_txmsg.txdate    := v_currdate;
       l_txmsg.busdate   := v_currdate;
       l_txmsg.tltxcd    := '1104';

       SELECT SYS_CONTEXT ('USERENV', 'HOST'), SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
       INTO l_txmsg.wsname, l_txmsg.ipaddress FROM DUAL;

       -- Set txnum
       SELECT systemnums.C_BATCH_PREFIXED || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
       INTO l_txmsg.txnum FROM DUAL;

       for rec in
       (
            SELECT FN_GET_LOCATION(af.brid) LOCATION, SUBSTR(RM.TXNUM,1,4) BRID, CF.FULLNAME,T1.TLNAME MAKER,T2.TLNAME OFFICER, CF.CUSTODYCD CUSTODYCD, CD1.CDCONTENT DESC_IDTYPE, CF.IDCODE,
            AF.ACCTNO ACCTNO,CF.CUSTID, RM.TXDATE, RM.TXNUM, RM.BANKID,RM.BENEFBANK,RM.CITYEF,RM.CITYBANK, RM.BENEFACCT, RM.BENEFCUSTNAME, RM.BENEFLICENSE, RM.BENEFIDDATE, RM.BENEFIDPLACE, RM.AMT, RM.FEEAMT,AF.ACCTNO || ' : ' ||TL.TXDESC DESCRIPTION, RM.FEETYPE,
            CF.IDDATE,CF.IDPLACE,CF.ADDRESS,
            A1.CDCONTENT FEENAME,  b.glaccount GLACCTNO,  '' POTXNUM, '' POTXDATE, '' BANKNAME, '' BANKACC, '001' POTYPE
            FROM CIREMITTANCE RM, AFMAST AF, CFMAST CF, ALLCODE A1,  ALLCODE CD1,(SELECT TLID, TLNAME FROM TLPROFILES UNION ALL SELECT '____' TLID, '____' TLNAME FROM DUAL) T1,
            (SELECT TLID, TLNAME FROM TLPROFILES UNION ALL SELECT '____' TLID, '____' TLNAME FROM DUAL) T2,
                (select * from ((SELECT * FROM TLLOG WHERE TLTXCD in ('1101','1108','1111','1119','1133','1185') AND TXSTATUS='1' UNION SELECT * FROM TLLOGALL WHERE TLTXCD in ('1101','1108','1111','1119','1133','1185') AND TXSTATUS='1') TL)
                /*where
                ('<$BRID>' ='0001' AND ( (tl.tlid <> '6868' AND SUBSTR(tl.txnum,0,4) IN ('0001','0002','0003'))
                                     OR (tl.tlid = '6868' AND SUBSTR(tl.msgacct,0,4) IN ('0001','0002','0003')))
                  )
                  OR
                  ('<$BRID>' ='0101' AND ( (tl.tlid <> '6868' AND SUBSTR(tl.txnum,0,4) IN ('0101','0102','0103'))
                                     OR (tl.tlid = '6868' AND SUBSTR(tl.msgacct,0,4) IN ('0101','0102','0103')))
                  )*/) TL, newbankgw_log log, banknostro b
            WHERE CF.CUSTID=AF.CUSTID AND RM.ACCTNO=AF.ACCTNO AND RM.DELTD='N' AND RM.RMSTATUS in (/*'P','M'*/'W') AND TL.TXNUM=RM.TXNUM AND TL.TXDATE=RM.TXDATE
            AND CD1.CDTYPE='CF' AND CD1.CDNAME='IDTYPE' AND CD1.CDVAL=CF.IDTYPE
            AND A1.CDTYPE='SA' AND A1.CDNAME='IOROFEE' AND A1.CDVAL=NVL(RM.FEETYPE,'0')
            AND (CASE WHEN TL.TLID IS NULL THEN '____' ELSE TL.TLID END)=T1.TLID
            AND (CASE WHEN TL.OFFID IS NULL THEN '____' ELSE TL.OFFID END)=T2.TLID
            AND log.txdate = rm.txdate and log.txnum = rm.txnum and log.transactionid = p_transactionid
            and b.shortname = '118'
       )
       loop
          l_txmsg.brid      := substr(rec.acctno,1,4);

          --ACCTNO
          l_txmsg.txfields ('03').defname   := 'ACCTNO';
          l_txmsg.txfields ('03').TYPE   := 'C';
          l_txmsg.txfields ('03').VALUE   := REC.ACCTNO;
          --CUSTODYCD
          l_txmsg.txfields ('04').defname   := 'CUSTODYCD';
          l_txmsg.txfields ('04').TYPE   := 'C';
          l_txmsg.txfields ('04').VALUE   := REC.CUSTODYCD;
          --BANKID
          l_txmsg.txfields ('05').defname   := 'BANKID';
          l_txmsg.txfields ('05').TYPE   := 'C';
          l_txmsg.txfields ('05').VALUE   := REC.BANKID;
          --TXDATE
          l_txmsg.txfields ('06').defname   := 'TXDATE';
          l_txmsg.txfields ('06').TYPE   := 'D';
          l_txmsg.txfields ('06').VALUE   := REC.TXDATE;
          --TXNUM
          l_txmsg.txfields ('07').defname   := 'TXNUM';
          l_txmsg.txfields ('07').TYPE   := 'C';
          l_txmsg.txfields ('07').VALUE   := REC.TXNUM;
          --BANKACC
          l_txmsg.txfields ('08').defname   := 'BANKACC';
          l_txmsg.txfields ('08').TYPE   := 'C';
          l_txmsg.txfields ('08').VALUE   := REC.BANKACC;
          --IORO
          l_txmsg.txfields ('09').defname   := 'IORO';
          l_txmsg.txfields ('09').TYPE   := 'C';
          l_txmsg.txfields ('09').VALUE   := REC.FEETYPE;
          --AMT
          l_txmsg.txfields ('10').defname   := 'AMT';
          l_txmsg.txfields ('10').TYPE   := 'N';
          l_txmsg.txfields ('10').VALUE   := REC.AMT;
          --GLMAST
          l_txmsg.txfields ('15').defname   := 'GLMAST';
          l_txmsg.txfields ('15').TYPE   := 'C';
          l_txmsg.txfields ('15').VALUE   := REC.GLACCTNO;
          --POTYPE
          l_txmsg.txfields ('17').defname   := 'POTYPE';
          l_txmsg.txfields ('17').TYPE   := 'C';
          l_txmsg.txfields ('17').VALUE   := REC.POTYPE;
          --DESC
          l_txmsg.txfields ('30').defname   := 'DESC';
          l_txmsg.txfields ('30').TYPE   := 'C';
          l_txmsg.txfields ('30').VALUE   := REC.DESCRIPTION;
          --CITYBANK
          l_txmsg.txfields ('32').defname   := 'CITYBANK';
          l_txmsg.txfields ('32').TYPE   := 'C';
          l_txmsg.txfields ('32').VALUE   := REC.CITYBANK;
          --CITYEF
          l_txmsg.txfields ('33').defname   := 'CITYEF';
          l_txmsg.txfields ('33').TYPE   := 'C';
          l_txmsg.txfields ('33').VALUE   := REC.CITYEF;
          --IDDATE
          l_txmsg.txfields ('67').defname   := 'IDDATE';
          l_txmsg.txfields ('67').TYPE   := 'C';
          l_txmsg.txfields ('67').VALUE   := TO_CHAR(REC.IDDATE,'DD/MM/RRRR');
          --BENEFBANK
          l_txmsg.txfields ('80').defname   := 'BENEFBANK';
          l_txmsg.txfields ('80').TYPE   := 'C';
          l_txmsg.txfields ('80').VALUE   := REC.BENEFBANK;
          --BENEFACCT
          l_txmsg.txfields ('81').defname   := 'BENEFACCT';
          l_txmsg.txfields ('81').TYPE   := 'C';
          l_txmsg.txfields ('81').VALUE   := REC.BENEFACCT;
          --BENEFCUSTNAME
          l_txmsg.txfields ('82').defname   := 'BENEFCUSTNAME';
          l_txmsg.txfields ('82').TYPE   := 'C';
          l_txmsg.txfields ('82').VALUE   := REC.BENEFCUSTNAME;
          --RECEIVLICENSE
          l_txmsg.txfields ('83').defname   := 'RECEIVLICENSE';
          l_txmsg.txfields ('83').TYPE   := 'C';
          l_txmsg.txfields ('83').VALUE   := REC.BENEFLICENSE;
          --BANKNAME
          l_txmsg.txfields ('85').defname   := 'BANKNAME';
          l_txmsg.txfields ('85').TYPE   := 'C';
          l_txmsg.txfields ('85').VALUE   := REC.BANKNAME;
          --BANKACCNAME
          l_txmsg.txfields ('86').defname   := 'BANKACCNAME';
          l_txmsg.txfields ('86').TYPE   := 'C';
          l_txmsg.txfields ('86').VALUE   := '';
          --CUSTNAME
          l_txmsg.txfields ('90').defname   := 'CUSTNAME';
          l_txmsg.txfields ('90').TYPE   := 'C';
          l_txmsg.txfields ('90').VALUE   := REC.FULLNAME;
          --ADDRESS
          l_txmsg.txfields ('91').defname   := 'ADDRESS';
          l_txmsg.txfields ('91').TYPE   := 'C';
          l_txmsg.txfields ('91').VALUE   := REC.ADDRESS;
          --LICENSE
          l_txmsg.txfields ('92').defname   := 'LICENSE';
          l_txmsg.txfields ('92').TYPE   := 'C';
          l_txmsg.txfields ('92').VALUE   := REC.IDCODE;
          --RECEIVIDDATE
          l_txmsg.txfields ('95').defname   := 'RECEIVIDDATE';
          l_txmsg.txfields ('95').TYPE   := 'C';
          l_txmsg.txfields ('95').VALUE   := REC.BENEFIDDATE;
          --RECEIVIDPLACE
          l_txmsg.txfields ('96').defname   := 'RECEIVIDPLACE';
          l_txmsg.txfields ('96').TYPE   := 'C';
          l_txmsg.txfields ('96').VALUE   := REC.BENEFIDPLACE;

          SELECT NVL(MAX(ODR)+1,1) INTO v_strAutoID  FROM
                  (SELECT ROWNUM ODR, INVACCT
                  FROM (SELECT TXNUM INVACCT FROM POMAST WHERE BRID = REC.BRID ORDER BY TXNUM) DAT
                  ) INVTAB;

          v_POTXNUM := REC.BRID || LPAD(v_strAutoID,6,'0');

          --POTXDATE
          l_txmsg.txfields ('98').defname   := 'POTXDATE';
          l_txmsg.txfields ('98').TYPE   := 'D';
          l_txmsg.txfields ('98').VALUE   := REC.TXDATE;
          --POTXNUM
          l_txmsg.txfields ('99').defname   := 'POTXNUM';
          l_txmsg.txfields ('99').TYPE   := 'C';
          l_txmsg.txfields ('99').VALUE   := v_POTXNUM;

          BEGIN
          IF txpks_#1104.fn_autotxprocess (l_txmsg, l_errcode, l_err_param)
            <> systemnums.c_success
          THEN
             p_err_code := l_errcode;
             p_err_message := cspks_system.fn_get_en_errmsg(p_err_code);
             UPDATE newbankgw_log SET errcode = errcode||p_err_code, errmsg = errmsg||p_err_message
             WHERE transactionid = p_transactionid;
             plog.setEndSection(pkgctx, 'pr_completeTransferRequest');
             RETURN;
          END IF;
          END;

       end loop;

     elsif p_res_code = '-100006' then
       update newbankgw_log set status = 'E', errcode = p_res_code, errmsg = p_res_message, sendnum = sendnum + 1, messageid = p_messageid,
       bankid = p_bankid, banktime = p_banktime
       where transactionid = p_transactionid;
     else
       update newbankgw_log set status = 'R', errcode = p_res_code, errmsg = p_res_message, sendnum = sendnum + 1, messageid = p_messageid,
       bankid = p_bankid, banktime = p_banktime
       where transactionid = p_transactionid;

       l_txmsg.msgtype   := 'T';
       l_txmsg.local     := 'N';
       l_txmsg.tlid      := systemnums.c_system_userid;
       l_txmsg.off_line  := 'N';
       l_txmsg.deltd     := txnums.c_deltd_txnormal;
       l_txmsg.txstatus  := txstatusnums.c_txcompleted;
       l_txmsg.msgsts    := '0';
       l_txmsg.ovrsts    := '0';
       l_txmsg.batchname := 'DAY';
       l_txmsg.txdate    := v_currdate;
       l_txmsg.busdate   := v_currdate;
       l_txmsg.tltxcd    := '1114';

       SELECT SYS_CONTEXT ('USERENV', 'HOST'), SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
       INTO l_txmsg.wsname, l_txmsg.ipaddress FROM DUAL;

       -- Set txnum
       SELECT systemnums.C_BATCH_PREFIXED || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
       INTO l_txmsg.txnum FROM DUAL;

        select ci.acctno, substr(ci.bankid,1,3) bankid, ci.txdate, ci.txnum, ci.amt, ci.feeamt, log.remark descriptions, ci.benefbank,
        ci.benefacct, ci.benefcustname, ci.citybank, ci.cityef, cf.fullname, cf.address , cf.idcode
        into v_afacctno, v_bankid, v_txdate, v_txnum, v_amt, v_feeamt, v_desc, v_benefbank,
        v_benefacct, v_benefcustname, v_citybank, v_cityef, v_fullname, v_address, v_idcode
        from ciremittance ci, newbankgw_log log, afmast af, cfmast cf
        where ci.txdate = log.txdate and ci.txnum = log.txnum
        and af.acctno = ci.acctno and af.custid = cf.custid
        AND ci.rmstatus = 'W'
        and log.transactionid = p_transactionid;

        l_txmsg.brid      := substr(v_afacctno,1,4);

        --ACCTNO
        l_txmsg.txfields ('03').defname   := 'ACCTNO';
        l_txmsg.txfields ('03').TYPE   := 'C';
        l_txmsg.txfields ('03').VALUE   := v_afacctno;
        --BANKID
        l_txmsg.txfields ('05').defname   := 'BANKID';
        l_txmsg.txfields ('05').TYPE   := 'C';
        l_txmsg.txfields ('05').VALUE   := v_bankid;
        --TXDATE
        l_txmsg.txfields ('06').defname   := 'TXDATE';
        l_txmsg.txfields ('06').TYPE   := 'D';
        l_txmsg.txfields ('06').VALUE   := v_txdate;
        --TXNUM
        l_txmsg.txfields ('07').defname   := 'TXNUM';
        l_txmsg.txfields ('07').TYPE   := 'C';
        l_txmsg.txfields ('07').VALUE   := v_txnum;
        --AMT
        l_txmsg.txfields ('10').defname   := 'AMT';
        l_txmsg.txfields ('10').TYPE   := 'N';
        l_txmsg.txfields ('10').VALUE   := v_amt;
        --FEEAMT
        l_txmsg.txfields ('11').defname   := 'FEEAMT';
        l_txmsg.txfields ('11').TYPE   := 'N';
        l_txmsg.txfields ('11').VALUE   := v_feeamt;
        --DESC
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE   := 'C';
        l_txmsg.txfields ('30').VALUE   := v_desc;
        --BENEFBANK
        l_txmsg.txfields ('80').defname   := 'BENEFBANK';
        l_txmsg.txfields ('80').TYPE   := 'C';
        l_txmsg.txfields ('80').VALUE   := v_benefbank;
        --BENEFACCT
        l_txmsg.txfields ('81').defname   := 'BENEFACCT';
        l_txmsg.txfields ('81').TYPE   := 'C';
        l_txmsg.txfields ('81').VALUE   := v_benefacct;
        --BENEFCUSTNAME
        l_txmsg.txfields ('82').defname   := 'BENEFCUSTNAME';
        l_txmsg.txfields ('82').TYPE   := 'C';
        l_txmsg.txfields ('82').VALUE   := v_benefcustname;
        --CITYBANK
        l_txmsg.txfields ('84').defname   := 'CITYBANK';
        l_txmsg.txfields ('84').TYPE   := 'C';
        l_txmsg.txfields ('84').VALUE   := v_citybank;
        --CITYEF
        l_txmsg.txfields ('85').defname   := 'CITYEF';
        l_txmsg.txfields ('85').TYPE   := 'C';
        l_txmsg.txfields ('85').VALUE   := v_cityef;
        --CUSTNAME
        l_txmsg.txfields ('90').defname   := 'CUSTNAME';
        l_txmsg.txfields ('90').TYPE   := 'C';
        l_txmsg.txfields ('90').VALUE   := v_fullname;
        --ADDRESS
        l_txmsg.txfields ('91').defname   := 'ADDRESS';
        l_txmsg.txfields ('91').TYPE   := 'C';
        l_txmsg.txfields ('91').VALUE   := v_address;
        --LICENSE
        l_txmsg.txfields ('92').defname   := 'LICENSE';
        l_txmsg.txfields ('92').TYPE   := 'C';
        l_txmsg.txfields ('92').VALUE   := v_idcode;

        BEGIN
        IF txpks_#1114.fn_autotxprocess (l_txmsg, l_errcode, l_err_param)
          <> systemnums.c_success
        THEN
           p_err_code := l_errcode;
           p_err_message := cspks_system.fn_get_en_errmsg(p_err_code);
           UPDATE newbankgw_log SET errcode = errcode||p_err_code, errmsg = errmsg||p_err_message
           WHERE transactionid = p_transactionid;
           plog.setEndSection(pkgctx, 'pr_completeTransferRequest');
           RETURN;
        END IF;
     END;


     end if;
     --update newbankgw_log set status = 'C', errcode = p_res_code, errmsg = p_res_message  where transactionid = p_transactionid;
     plog.error('p_transactionid: ' || p_transactionid);
     plog.error('p_res_code: ' || p_res_code);
     plog.error('p_res_message: ' || p_res_message);

     plog.setEndSection(pkgctx, 'pr_completeTransferRequest');
  EXCEPTION WHEN OTHERS THEN
     plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
     plog.setEndSection (pkgctx, 'pr_completeTransferRequest');
  END;

  PROCEDURE pr_rejectTransferRequest(
            p_err_code          OUT VARCHAR2,
            p_err_message       OUT VARCHAR2,
            p_transactionid     IN VARCHAR2
  ) IS
  BEGIN
     plog.setBeginSection(pkgctx, 'pr_rejectTransferRequest');
     p_err_code := '0';
     p_err_message := 'Success';
     plog.error('bankgw reject:'||p_transactionid);
     update newbankgw_log set status = 'E' where transactionid = p_transactionid;
     plog.error('p_transactionid: ' || p_transactionid);

     plog.setEndSection(pkgctx, 'pr_rejectTransferRequest');
  EXCEPTION WHEN OTHERS THEN
     plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
     plog.setEndSection (pkgctx, 'pr_completeTransferRequest');
  END;

  PROCEDURE pr_getRetryTransferRequest(
            pv_refCursor        OUT pkg_report.ref_cursor,
            p_maxcount          IN NUMBER
  ) IS
  l_maxRetry NUMBER;
  l_txdate   DATE;
  BEGIN
     plog.setBeginSection(pkgctx, 'pr_getRetryTransferRequest');
     l_maxRetry := cspks_system.fn_get_sysvar('BANK', 'MAXRETRYCOUNT');
     l_txdate   := getcurrdate;
     OPEN pv_refCursor FOR
     select  BATCHID, TRANSACTIONID, MESSAGEID, TRFTYPE, ACCTNOSUM, ACCOUNT, BENEFCUSTNAME, AMOUNT,
             CCYCD,REMARK,BANKNAME, BANKCODE,
             CASE WHEN retrycount+1 >= l_maxRetry THEN 'Y' ELSE 'N' END PROCESS
      from (select rownum list, log.* from newbankgw_log log where status in ('E') AND txdate = l_txdate)
      where list <= p_maxcount;

     plog.setEndSection(pkgctx, 'pr_getRetryTransferRequest');
  EXCEPTION WHEN OTHERS THEN
     plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
     plog.setEndSection (pkgctx, 'pr_getRetryTransferRequest');
  END;


  PROCEDURE pr_retryTransferRequest(
            p_err_code          OUT VARCHAR2,
            p_err_message       OUT VARCHAR2,
            p_transactionid     IN VARCHAR2
  ) IS
  BEGIN
     plog.setBeginSection(pkgctx, 'pr_retryTransferRequest');
     p_err_code := '0';
     p_err_message := 'Success';
     plog.error('bankgw reject:'||p_transactionid);
     update newbankgw_log set status = 'P' where transactionid = p_transactionid;
     plog.error('p_transactionid: ' || p_transactionid);

     plog.setEndSection(pkgctx, 'pr_retryTransferRequest');
  EXCEPTION WHEN OTHERS THEN
     plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
     plog.setEndSection (pkgctx, 'pr_retryTransferRequest');
  END;
  PROCEDURE pr_retryCountIncrease(
            p_err_code          OUT VARCHAR2,
            p_err_message       OUT VARCHAR2,
            p_transactionid     IN VARCHAR2
  ) IS
  l_maxRetry   NUMBER;
  l_retryCount NUMBER;
  l_bankId     VARCHAR2(100);
  BEGIN
     plog.setBeginSection(pkgctx, 'pr_retryCountIncrease');
     p_err_code := '0';
     p_err_message := 'Success';
     update newbankgw_log set retrycount = retrycount + 1 where transactionid = p_transactionid
     RETURNING retryCount, bankId INTO l_retryCount, l_bankId;
     /*l_maxRetry := cspks_system.fn_get_sysvar('BANK', 'MAXRETRYCOUNT');
     --SELECT retrycount, bankId INTO l_retryCount, l_bankId FROM newbankgw_log where transactionid = p_transactionid;
     IF l_retryCount >= l_maxRetry THEN
       plog.error('Over MaxRetry --> Revert Transfer: p_transactionid=' || p_transactionid);
       pck_bankgw.pr_completeTransferRequest(p_err_code      => p_err_code,
                                             p_err_message   => p_err_message,
                                             p_transactionid => p_transactionid,
                                             p_messageid     => '',
                                             p_bankid        => l_bankId,
                                             p_banktime      => '',
                                             p_res_code      => '-100010',
                                             p_res_message   => 'Over max retry');
     END IF;
     plog.error('p_transactionid: ' || p_transactionid);*/

     plog.setEndSection(pkgctx, 'pr_retryCountIncrease');
  EXCEPTION WHEN OTHERS THEN
     plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
     plog.setEndSection (pkgctx, 'pr_retryCountIncrease');
  END;

  PROCEDURE pr_insertTransferRequest
  IS
   v_banklist   varchar2(100);
   v_bidvmode   varchar2(5);
   v_vpbamt     number;
   v_trftype    varchar2(5);
   v_bankcode   varchar2(50);
   v_branchname   varchar2(300);
   v_smlid        varchar2(50);
   v_bankname     varchar2(500);
   v_count        number;
  BEGIN
     plog.setBeginSection(pkgctx, 'pr_insertTransferRequest');
     v_banklist := '';
     select varvalue into v_bidvmode
     from sysvar where grname='SYSTEM' AND VARNAME='TCDTBIDV';
     for rec1 in
       (select * from bankgw_auth_info where bankmode = '1' and bankcode <> 'VPBANK')
     loop
       v_banklist := v_banklist||'|'||rec1.bank_no;
     end loop;
     if v_bidvmode = '0' then
       v_banklist := v_banklist||'|302';
     else
       v_banklist := v_banklist||'|202|302';
     end if;
     begin
       select to_number(varvalue) into v_vpbamt  from sysvar where grname = 'SYSTEM' and varname = 'VPBANKNAPAS';
     exception when others then
       v_vpbamt:= 300000000;
     end;


     for rec in
       (
     select --v_strBATCHID||lpad(to_char(SEQ_VPB_LOGS.nextval),4,'0') TRANSACTIONID,
       ci.txdate, ci.txnum,tl.TLTXCD,
       /*case when substr(ci.bankid,1,3) = '309' then '0' else
         (case when nvl(bk.isnapas,'0') = '1' then '2' else '1' end) end  TRFTYPE,*/
       nos.bankacctno ACCTNOSUM,
       ci.benefacct ACCOUNT,
       pck_gwtransfer.correct_remark(ci.benefcustname,250) BENEFCUSTNAME,
       ci.amt AMOUNT,
       'VND' CCYCD,
       pck_gwtransfer.correct_remark(case when tl.TLTXCD = '1201' then tl.TXDESC else af.acctno||' Chuyen khoan ra ngan hang '||cf.fullname||' '||cf.custodycd end,250)  REMARK,
       substr(ci.bankid,instr(ci.bankid,'.')+1) branchcode, substr(ci.bankid,1,instr(ci.bankid,'.')-1) bankcode, substr(cf.custodycd,4,1)  custype
       /*branch.short_name BANKNAME,
       case when substr(ci.bankid,1,3) = '309' then branch.sb_branch_code else
         (case when nvl(bk.isnapas,'0') = '1' then bk.banksmlid else branch.sb_branch_code end) end BANKCODE*/
      from ciremittance ci, cfmast cf, afmast af, banknostro nos, tllog tl
      where ci.acctno = af.acctno
      and af.custid = cf.custid
      and ci.rmstatus = 'P'
      /*and substr(ci.bankid,1,instr(ci.bankid,'.') - 1) = bk.bank_no
      and substr(ci.bankid,instr(ci.bankid,'.') + 1) = branch.sb_branch_code
      and nvl(branch.address,'zzzz') like nvl(ci.cityef,'zzzz')*/
      --and bk.bank_no = branch.bank_no
      and nos.glaccount = 'VPBANK'
      and ci.txdate = tl.TXDATE
      and ci.txnum = tl.TXNUM
      and (substr(ci.bankid,1,3) = '309'
          OR (instr(nvl(v_banklist,' '),substr(ci.bankid,1,3)) = 0 AND EXISTS(SELECT * FROM TCDTCASHLIMIT WHERE BANK_NAME = 'VPBANK' AND CI.AMT >= CASH_FROM AND CI.AMT <= CASH_TO))
          )
      /*and
      ( instr(v_banklist||'|202',substr(ci.bankid,1,3)) = 0 and EXISTS(select varvalue from sysvar where grname='SYSTEM' AND VARNAME='BANKTCDT' and varvalue='VPB')
       or
       (instr(nvl(v_banklist,' '),substr(ci.bankid,1,3)) = 0 and EXISTS(select varvalue from sysvar where grname='SYSTEM' AND VARNAME='TCDTBIDV' and varvalue='0')
       and EXISTS(select varvalue from sysvar where grname='SYSTEM' AND VARNAME='BANKTCDT' and varvalue='VPB'))
      )*/
      and tl.TXSTATUS = '1'
      and tl.DELTD = 'N'
      and tl.TLTXCD in ( '1101', '1201')
      and (ci.txdate||ci.txnum) not in (select a.txdate||a.txnum from newbankgw_log a)
      )
      loop
        /*insert into newbankgw_log (autoid,txdate,txnum,trftype,acctnosum,account,benefcustname,amount,ccycd,remark,bankname,bankcode)
        values(SEQ_NEWBANKGW_LOG.nextval,rec.txdate, rec.txnum, rec.trftype, rec.acctnosum, rec.account,
        rec.benefcustname, rec.amount, rec.ccycd, rec.remark, rec.bankname, rec.bankcode);*/
        if (rec.TLTXCD <> '1201') then
      select count(*) into v_count
      from branch_total_info a
      where a.bankcode = 'VPBANK'
      and a.branch_no = rec.branchcode and a.bank_no = rec.bankcode;

      if v_count = 0 then -- ko phai VPBANK
        BEGIN--lay branch theo ngan hang cua MSB
        select max(b.branch_name) branch_name, max(b.branch_no) branch_no, max(b.bank_smlid), max(a.sys_bank_name)
        into v_branchname, v_bankcode, v_smlid, v_bankname
        from branch_total_info a, (select * from branch_total_info where bankcode = 'VPBANK') b
        where a.branch_no = rec.branchcode and a.bank_no = rec.bankcode
        and a.sys_bank_name = b.sys_bank_name(+)
        and a.sys_branch_name = b.sys_branch_name(+);
        EXCEPTION WHEN OTHERS THEN
        v_branchname := '';
        v_bankcode := '';
        v_bankname := '';
        CONTINUE;
        END;
      else -- neu cua VPBANK
        begin
        select max(a.branch_name) branch_name, max(a.branch_no) branch_no, max(a.bank_smlid), max(a.sys_bank_name)
        into v_branchname, v_bankcode, v_smlid, v_bankname
        from branch_total_info a
        where a.bankcode = 'VPBANK'
        and a.branch_no = rec.branchcode and a.bank_no = rec.bankcode;
        EXCEPTION WHEN OTHERS THEN
          v_branchname := '';
          v_bankcode := '';
        END;
      end if;
      if v_bankcode is null then
        if v_bankname is null then
        CONTINUE;
        else
        BEGIN -- neu ko lay dc thi lay 1 branch cua ngan hang do
          select max(b.branch_name) branch_name, max(b.branch_no) branch_no, max(b.bank_smlid)
          into v_branchname, v_bankcode, v_smlid
          from (select * from branch_total_info where bankcode = 'VPBANK') b
          where b.sys_bank_name = v_bankname;
        EXCEPTION WHEN OTHERS THEN
          v_branchname := '';
          v_bankcode := '';
          CONTINUE;
        END;
        end if;
      end if;
    end if;
        v_trftype := case when rec.bankcode = '309' or rec.TLTXCD ='1201' then '0' else (case when rec.amount > v_vpbamt then '1'
        when rec.bankcode = '616' and rec.custype = 'F' then  '1'
        when v_smlid is null then '1' 
        else (case when length(rec.account) = 16 and substr(rec.account,1,2) = '97' then '3' else '2' end) end ) end;

        insert into newbankgw_log (autoid,txdate,txnum,trftype,acctnosum,account,benefcustname,amount,ccycd,remark,bankname,bankcode)
        values(SEQ_NEWBANKGW_LOG.nextval,rec.txdate, rec.txnum, v_trftype, rec.acctnosum, rec.account,
        rec.benefcustname, rec.amount, rec.ccycd, rec.remark, v_branchname,
        case when rec.amount > v_vpbamt then v_bankcode
        when v_trftype = '1' then  v_bankcode
        else nvl(v_smlid,v_bankcode) end);
        Update CIREMITTANCE CI Set rmstatus='W' where CI.txnum=Rec.txnum and Ci.Txdate =rec.txdate;
      end loop;
      commit;
     plog.setEndSection(pkgctx, 'pr_insertTransferRequest');
  EXCEPTION WHEN OTHERS THEN
     plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
     plog.setEndSection (pkgctx, 'pr_insertTransferRequest');
  END;


  PROCEDURE pr_excute_comparedata(
            p_err_code          OUT VARCHAR2,
            p_err_message       OUT VARCHAR2,
            pv_filename         IN VARCHAR2
  ) IS
  v_currdate                    date;
  v_fromdate                    date;
  v_todate                      date;
  v_workingday                  varchar2(5);
  l_banktime_mode               VARCHAR2(100);
  BEGIN
     plog.setBeginSection(pkgctx, 'pr_excute_comparedata');
     p_err_code := '0';
     p_err_message := 'Success';
     plog.error(pkgctx, 'begin excute comparedata :');
     l_banktime_mode := cspks_system.fn_get_sysvar('SYSTEM','BANK_MODE');
     IF l_banktime_mode = 'TEST' THEN
       v_currdate := trunc(SYSDATE);
     ELSE
       v_currdate := getcurrdate;
     END IF;
     --LAY NGAY LAM VIEC GAN NGAY HIEN TAI NHAT
     select max(sbdate) into v_fromdate
     from sbcldr sb
     where sb.cldrtype = '000' and sb.sbdate < v_currdate
     and sb.holiday = 'N';

     --CHECK NGAY HIEN TAI CO PHAI NGAY LAM VIEC KO
     select case when sb.holiday = 'N' then 'Y' else 'N' end into v_workingday
     from sbcldr sb where sb.cldrtype = '000' and sb.sbdate = v_currdate;

     for rec in
       (select b.*, a.transactionid, a.batchid , a.messageid, a.txnum, a.trftype,
       a.acctnosum, a.account, a.benefcustname, a.amount flexamount, a.ccycd, a.remark,
       a.bankname, a.bankcode, a.status flexstatus
       from newbankgw_log a, comparelist b
       where b.refnum = a.transactionid (+)
       and b.transactiontype = '2' /*and a.txdate <= v_currdate
       and a.txdate >= v_fromdate */and v_workingday = 'Y'
       --and b.txdate < v_currdate and b.txdate >= v_fromdate
       and b.status = 'P' and b.filename = pv_filename
       )
     loop
       if rec.flexamount is null then
         update comparelist set status = 'E', resultcollate = '02',
                                vpbstatus = '01'
         where id = rec.id and status = 'P';
         CONTINUE;
       elsif to_number(rec.amount) <> to_number(rec.flexamount) then
         update comparelist set status = 'E', resultcollate = '03',
                customerstatus = case when rec.flexstatus = 'C' then '01' else '' end,
                vpbstatus = '01'
         where id = rec.id and status = 'P';
         CONTINUE;
       end if;

       if rec.flexstatus <> 'C' then
         update comparelist set status = 'E', resultcollate = '03',
                                vpbstatus = '01'
         where id = rec.id and status = 'P';
         CONTINUE;
       end if;

       if rec.acctnosum <> rec.debitaccount then
         update comparelist set status = 'E', resultcollate = '03',
         customerstatus = case when rec.flexstatus = 'C' then '01' else '' end,
         vpbstatus = '01'
         where id = rec.id and status = 'P';
         CONTINUE;
       end if;

       if rec.benaccount <> rec.account then
         update comparelist set status = 'E', resultcollate = '03',
         customerstatus = case when rec.flexstatus = 'C' then '01' else '' end,
         vpbstatus = '01'
         where id = rec.id and status = 'P';
         CONTINUE;
       end if;

       if rec.benaccount <> rec.account then
         update comparelist set status = 'E', resultcollate = '03',
         customerstatus = case when rec.flexstatus = 'C' then '01' else '' end,
         vpbstatus = '01'
         where id = rec.id and status = 'P';
         CONTINUE;
       end if;

       update comparelist set status = 'C',
       customerstatus = '01',
       vpbstatus = '01',
       ResultCollate = '00'
       where id = rec.id and status = 'P';

     end loop;

     plog.setEndSection(pkgctx, 'pr_excute_comparedata');
  EXCEPTION WHEN OTHERS THEN
     plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
     plog.setEndSection (pkgctx, 'pr_excute_comparedata');
  END;

  PROCEDURE pr_excute_collectdata(
            p_err_code          OUT VARCHAR2,
            p_err_message       OUT VARCHAR2,
            pv_filename         IN VARCHAR2
  ) IS
  v_currdate                    date;
  v_fromdate                    date;
  v_todate                      date;
  v_workingday                varchar2(5);
  BEGIN
     plog.setBeginSection(pkgctx, 'pr_excute_collectdata');
     p_err_code := '0';
     p_err_message := 'Success';
     plog.error('pr_excute_collectdata :'||pv_filename);
     v_currdate := getcurrdate;
     --LAY NGAY LAM VIEC GAN NGAY HIEN TAI NHAT
     select max(sbdate) into v_fromdate
     from sbcldr sb
     where sb.cldrtype = '000' and sb.sbdate < v_currdate
     and sb.holiday = 'N';

     --CHECK NGAY HIEN TAI CO PHAI NGAY LAM VIEC KO
     select case when sb.holiday = 'N' then 'Y' else 'N' end into v_workingday
     from sbcldr sb where sb.cldrtype = '000' and sb.sbdate = v_currdate;

     for rec in
       (select a.*,
        b.tranid, b.amount bamount, b.custodycd bcustodycd, b.afacctno, b.bankaccno, b.status bstatus, b.errorcode, b.funcode
        from collectlist a, (select tcdt.*,substr(tcdt.tranid,instr(tcdt.tranid,'.')+1) funcode  from
        (select * from tcdtreceiverequestext
        union all
        select * from tcdtreceiverequestexthist) tcdt) b
        where a.refnum = b.funcode (+)
        --and a.txdate = b.txdate(+)
        --and b.txdate <= v_currdate
        --and b.txdate >= v_fromdate
        and a.filename = pv_filename
        and a.trantype = '1'
        and a.status = 'P'
       )
     loop
       if rec.bamount is null then
         update collectlist a set a.kbsstatus = 'Lech', a.status = 'E' where a.id = rec.id;
         CONTINUE;
       elsif to_number(rec.amount) <> rec.bamount then
         update collectlist a set a.kbsstatus = 'Lech', a.status = 'E' where a.id = rec.id;
         CONTINUE;
       elsif rec.refnum <> rec.funcode then
         update collectlist a set a.kbsstatus = 'Lech', a.status = 'E' where a.id = rec.id;
         CONTINUE;
       elsif rec.custodycd <> rec.bcustodycd then
         update collectlist a set a.kbsstatus = 'Lech', a.status = 'E' where a.id = rec.id;
         CONTINUE;
       elsif nvl(rec.accountno,'') <> rec.afacctno then
         update collectlist a set a.kbsstatus = 'Lech', a.status = 'E' where a.id = rec.id;
         CONTINUE;
       end if;
       update collectlist a set a.kbsstatus = 'Khop', a.status = 'C' where a.id = rec.id;
     end loop;

     plog.setEndSection(pkgctx, 'pr_excute_collectdata');
  EXCEPTION WHEN OTHERS THEN
     plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
     plog.setEndSection (pkgctx, 'pr_excute_collectdata');
  END;


  PROCEDURE pr_getSuccessTrans(
            pv_refCursor        OUT pkg_report.ref_cursor
  ) IS
     v_fromdate                 date;
     v_todate                   date;
     v_workingday              varchar2(5);
     v_firstRow                varchar2(200);
     v_lastRow                 varchar2(500);
     v_totalAmount             number;
     v_totalRow                number;
     l_banktime_mode               VARCHAR2(100);
  BEGIN
     plog.setBeginSection(pkgctx, 'pr_getSuccessTrans');
     l_banktime_mode := cspks_system.fn_get_sysvar('SYSTEM','BANK_MODE');
     IF l_banktime_mode = 'TEST' THEN
       v_todate := trunc(SYSDATE);
     ELSE
       v_todate := getcurrdate;
     END IF;
     --LAY NGAY LAM VIEC GAN NGAY HIEN TAI NHAT
     select max(sbdate) into v_fromdate
     from sbcldr sb
     where sb.cldrtype = '000' and sb.sbdate < v_todate
     and sb.holiday = 'N';

     --CHECK NGAY HIEN TAI CO PHAI NGAY LAM VIEC KO
     select case when sb.holiday = 'N' then 'Y' else 'N' end into v_workingday
     from sbcldr sb where sb.cldrtype = '000' and sb.sbdate = getcurrdate;

     select count(*), nvl(sum(amount),0) into v_totalRow, v_totalAmount
     from newbankgw_log log
     where log.status = 'C' and log.bankdate >= v_fromdate
     and log.bankdate < v_todate and v_workingday = 'Y';

     v_firstRow := 'RecordType,RefNum,BankId,TransferType,DebitAccount,BenAccount,BenName,BenBankName,BenBankCode,Amount,bankTime,Checksum';
     v_lastRow := '0009,'||to_char(v_totalRow)||','||to_char(v_totalAmount)||',KBS,'
                   ||to_char(sysdate,'yyyymmddhh24miss');

     OPEN pv_refCursor FOR
     select '0002' RECORDTYPE, LOG.TRANSACTIONID REFNUM, LOG.BANKID BANKID,
     LOG.TRFTYPE TRANSFERTYPE, LOG.ACCTNOSUM DEBITACCOUNT, LOG.ACCOUNT BENACCOUNT,
     LOG.BENEFCUSTNAME BENNAME, '' BENBANKNAME, '' BENBANKCODE, LOG.AMOUNT AMOUNT, to_char(TO_TIMESTAMP (LOG.BANKDATE),'yyyyMMddhh24miss') BANKTIME ,
     v_firstRow FIRSTROW, v_lastRow LASTROW,
     ('0002,'||LOG.TRANSACTIONID||','||LOG.BANKID||','||LOG.TRFTYPE||','||
     LOG.ACCTNOSUM||','||LOG.ACCOUNT||','||LOG.BENEFCUSTNAME||','||
     ''||','||''||','||TO_CHAR(LOG.AMOUNT)||','||to_char(TO_TIMESTAMP (LOG.BANKDATE),'yyyyMMddhh24miss')) DETAILS
     from newbankgw_log log
     where log.status = 'C' and log.bankdate >= v_fromdate
     and log.bankdate < v_todate and v_workingday = 'Y';

     plog.setEndSection(pkgctx, 'pr_getSuccessTrans');
  EXCEPTION WHEN OTHERS THEN
     plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
     plog.setEndSection (pkgctx, 'pr_getSuccessTrans');
  END;

  PROCEDURE pr_getAfterCompareTransaction(
            pv_refCursor        OUT pkg_report.ref_cursor,
            pv_status           IN VARCHAR2,
            pv_filename         IN VARCHAR2
  ) IS
     v_fromdate                 date;
     v_todate                   date;
     v_workingday              varchar2(5);
     v_firstRow                varchar2(200);
     v_lastRow                 varchar2(500);
     v_totalAmount             number;
     v_totalRow                number;
     l_banktime_mode               VARCHAR2(100);
  BEGIN
     plog.setBeginSection(pkgctx, 'pr_getAfterCompareTransaction');
     l_banktime_mode := cspks_system.fn_get_sysvar('SYSTEM','BANK_MODE');
     IF l_banktime_mode = 'TEST' THEN
       v_todate := trunc(SYSDATE);
     ELSE
       v_todate := getcurrdate;
     END IF;
     --LAY NGAY LAM VIEC GAN NGAY HIEN TAI NHAT
     select max(sbdate) into v_fromdate
     from sbcldr sb
     where sb.cldrtype = '000' and sb.sbdate < v_todate
     and sb.holiday = 'N';

     --CHECK NGAY HIEN TAI CO PHAI NGAY LAM VIEC KO
     select case when sb.holiday = 'N' then 'Y' else 'N' end into v_workingday
     from sbcldr sb where sb.cldrtype = '000' and sb.sbdate = getcurrdate;

     select count(*), nvl(sum(amount),0) into v_totalRow, v_totalAmount
     from (select '0002' RECORDTYPE, LOG.TRANSACTIONID REFNUM, LOG.BANKID BANKID,
     LOG.TRFTYPE TRANSFERTYPE, LOG.ACCTNOSUM DEBITACCOUNT, LOG.ACCOUNT BENACCOUNT,
     LOG.BENEFCUSTNAME BENNAME, '' BENBANKNAME, '' BENBANKCODE, LOG.AMOUNT AMOUNT, LOG.BANKTIME BANKTIME
     from newbankgw_log log , comparelist a
     where log.transactionid = a.refnum(+) and a.refnum is null
     and pv_status = 'E' and v_workingday = 'Y'
     --and log.status = 'C'
     and log.bankdate >= v_fromdate and log.bankdate < v_todate
     UNION ALL
     select '0002' RECORDTYPE, a.refnum REFNUM, a.bankid BANKID,
     nvl(LOG.TRFTYPE,'0') TRANSFERTYPE, a.debitaccount DEBITACCOUNT, a.benaccount BENACCOUNT,
     a.benname BENNAME, A.BENBANKNAME BENBANKNAME, A.BENBANKCODE BENBANKCODE, to_number(a.AMOUNT) AMOUNT, a.BANKTIME BANKTIME
     from newbankgw_log log , comparelist a
     where a.refnum = LOG.TRANSACTIONID(+)
     and A.STATUS = pv_status /*and a.txdate >= v_fromdate*/
     and a.transactiontype = '2'
     /*and a.txdate < v_todate */and v_workingday = 'Y' and a.filename = pv_filename
     );

     v_firstRow := 'RecordType,RefNum,BankId,TransferType,DebitAccount,BenAccount,BenName,BenBankName,BenBankCode,Amount,BankTime,StatusDoiTac,StatusVPB,ResultCollate,Checksum';
     v_lastRow := '0009,'||to_char(v_totalRow)||','||to_char(v_totalAmount)||',KBS,'
                   ||to_char(sysdate,'yyyymmddhh24miss');

     OPEN pv_refCursor FOR
     select '0002' RECORDTYPE, LOG.TRANSACTIONID REFNUM, LOG.BANKID BANKID,
     LOG.TRFTYPE TRANSFERTYPE, LOG.ACCTNOSUM DEBITACCOUNT, LOG.ACCOUNT BENACCOUNT,
     LOG.BENEFCUSTNAME BENNAME, '' BENBANKNAME, '' BENBANKCODE, to_char(LOG.AMOUNT) AMOUNT, to_char(TO_TIMESTAMP (LOG.BANKTIME, 'yyyy-MM-dd'),'yyyyMMddhh24miss') BANKTIME ,
     v_firstRow FIRSTROW, v_lastRow LASTROW,
     ('0002,'||LOG.TRANSACTIONID||','||LOG.BANKID||','||LOG.TRFTYPE||','||
     LOG.ACCTNOSUM||','||LOG.ACCOUNT||','||LOG.BENEFCUSTNAME||','||
     ''||','||''||','||TO_CHAR(LOG.AMOUNT)||','||to_char(TO_TIMESTAMP (LOG.BANKTIME, 'yyyy-MM-dd'),'yyyyMMddhh24miss')
     ||',' || CASE WHEN LOG.STATUS = 'C' THEN '00' ELSE '''' END || ',03') DETAILS,
     CASE WHEN LOG.STATUS = 'C' THEN '00' ELSE '' END CUSTOMERSTATUS,
     '' VPBSTATUS, '03' RESULTCOLLATE
     from newbankgw_log log , comparelist a
     where log.transactionid = a.refnum(+) and a.refnum is null
     and pv_status = 'E' and v_workingday = 'Y'
     --and log.status = 'C'
     and log.bankdate >= v_fromdate and log.bankdate < v_todate
     UNION ALL
     select '0002' RECORDTYPE, a.refnum REFNUM, a.bankid BANKID,
     nvl(LOG.TRFTYPE,'0') TRANSFERTYPE, a.debitaccount DEBITACCOUNT, a.benaccount BENACCOUNT,
     log.benefcustname BENNAME, A.BENBANKNAME BENBANKNAME, A.BENBANKCODE BENBANKCODE, a.AMOUNT AMOUNT, a.BANKTIME BANKTIME,
     v_firstRow FIRSTROW, v_lastRow LASTROW,
     ('0002,'||a.refnum||','||a.bankid||','||nvl(LOG.TRFTYPE,'0')||','||
     a.debitaccount||','||a.benaccount||','||LOG.BENEFCUSTNAME||','||
     A.BENBANKNAME||','||A.BENBANKCODE||','||A.AMOUNT||','||A.BANKTIME
     ||','||A.CUSTOMERSTATUS||','||A.VPBSTATUS||','||A.RESULTCOLLATE) DETAILS,
     A.CUSTOMERSTATUS CUSTOMERSTATUS,
     A.VPBSTATUS VPBSTATUS, A.RESULTCOLLATE RESULTCOLLATE
     from newbankgw_log log , comparelist a
     where a.refnum = LOG.TRANSACTIONID(+)
     and A.STATUS = pv_status and a.txdate >= v_fromdate
     and a.txdate < v_todate and v_workingday = 'Y' and a.filename = pv_filename
     ;

     plog.setEndSection(pkgctx, 'pr_getAfterCompareTransaction');
  EXCEPTION WHEN OTHERS THEN
     plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
     plog.setEndSection (pkgctx, 'pr_getAfterCompareTransaction');
  END;

  PROCEDURE pr_getAfterCollectTransaction(
            pv_refCursor        OUT pkg_report.ref_cursor,
            pv_filename         IN VARCHAR2
  ) IS
  BEGIN
     plog.setBeginSection(pkgctx, 'pr_getAfterCollectTransaction');

     OPEN pv_refCursor FOR
     select 'STT,MaGD,Sobuttoan,Sotien,Thoigian,SoTKGDCK,TenchuTKGD,Sotieukhoan,CIF,KenhGD,TKTTVpbank,TrangThaiGDKBS' firstrow, a.*
     from collectlist a where status <> 'P' and filename = pv_filename;

     plog.setEndSection(pkgctx, 'pr_getAfterCollectTransaction');
  EXCEPTION WHEN OTHERS THEN
     plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
     plog.setEndSection (pkgctx, 'pr_getAfterCollectTransaction');
  END;


  PROCEDURE pr_getTransferTransaction(
            pv_refCursor        OUT pkg_report.ref_cursor,
            p_bankcode          IN VARCHAR2
  ) IS
  BEGIN
     plog.setBeginSection(pkgctx, 'pr_getTransferTransaction');
     open pv_refCursor for
     select 'collect' type, '[TXDATE : '||TO_CHAR(A.TXDATE,'DD/MM/RRRR')||'],[TXNUM : '||A.TXNUM
     ||'],[TRANID : '||A.TRANID||'],[TRANDATE : '||A.TRANDATE||'],[BANKCODE : '||A.BANKCODE
     ||'],[BANKACCTNO : '||A.BANKACCNO||'],[CUSTODYCD : '||A.CUSTODYCD||'],[AFACCTNO : '||A.AFACCTNO
     ||'],[AMOUNT : '||TO_CHAR(A.AMOUNT)||'],[CCYCD : '||A.CCYCD||'],[TRANDESC : '||A.TRANDESC
     ||'],[STATUS : '||A.STATUS||'],[ERRCODE : '||A.ERRORCODE||'],[ERRMSG : '||A.ERRORDESC||']' description
     from tcdtreceiverequestext a
     WHERE A.TXDATE = getcurrdate AND A.BANKCODE = UPPER(p_bankcode)
     union all
     select 'pay' type, '[TXDATE : '||TO_CHAR(B.TXDATE,'DD/MM/RRRR')||'],[TXNUM : '||B.TXNUM
     ||'],[TRANID : '||B.TRANSACTIONID||'],[MSGID : '||B.MESSAGEID||'],[TRFTYPE : '||B.TRFTYPE
     ||'],[ACCTNOSUM : '||B.ACCTNOSUM||'],[ACCOUNT : '||B.ACCOUNT||'],[BENEFCUSTNAME : '||B.BENEFCUSTNAME
     ||'],[AMOUNT : '||TO_CHAR(B.AMOUNT)||'],[CCYCD : '||B.CCYCD||'],[TRANDESC : '||B.REMARK
     ||'],[BANKNAME : '||B.BANKNAME||'],[BANKCODE : '||B.BANKCODE||'],[BANKID : '||B.BANKID
     ||'],[STATUS : '||B.STATUS||'],[ERRCODE : '||B.ERRCODE||'],[ERRMSG : '||B.ERRMSG||']' description
     from newbankgw_log B
     where B.txdate = getcurrdate;

     plog.setEndSection(pkgctx, 'pr_getTransferTransaction');
  EXCEPTION WHEN OTHERS THEN
     plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
     plog.setEndSection (pkgctx, 'pr_getTransferTransaction');
  END;

BEGIN
   SELECT * INTO logrow FROM tlogdebug
   WHERE ROWNUM <= 1;

   pkgctx := plog.init ('pck_bankgw',
                 plevel => logrow.loglevel,
                 plogtable => (logrow.log4table = 'Y'),
                 palert => (logrow.log4alert = 'Y'),
                 ptrace => (logrow.log4trace = 'Y')
   );
END PCK_BANKGW;
/
