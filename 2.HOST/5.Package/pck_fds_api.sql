CREATE OR REPLACE PACKAGE pck_fds_api IS
  FUNCTION fn_get_error_message(p_errorcode IN VARCHAR2) RETURN VARCHAR2;
  PROCEDURE prc_controller_transact(transact    IN VARCHAR2,
                                    json_object IN VARCHAR2,
                                    p_errcode   IN OUT VARCHAR2);
  /*FUNCTION fn_CreateFdsAccount(json_object IN VARCHAR2) RETURN VARCHAR2;
  FUNCTION fn_CloseFdsAccount(json_object IN VARCHAR2) RETURN VARCHAR2;*/
  FUNCTION fn_call_txpks_deposit(json_object IN VARCHAR2) RETURN VARCHAR2;
  FUNCTION fn_call_txpks_seblock(json_object IN VARCHAR2) RETURN VARCHAR2;
  FUNCTION fn_call_txpks_withdraw(json_object IN VARCHAR2) RETURN VARCHAR2;
  FUNCTION fn_call_txpks_sereceive(json_object IN VARCHAR2) RETURN VARCHAR2;
  FUNCTION fn_call_txpks_setransferIn(json_object IN VARCHAR2) RETURN varchar2;
  FUNCTION fn_call_txpks_setranferout(json_object IN VARCHAR2) RETURN varchar2;
  FUNCTION fn_call_txpks_seunblock(json_object IN VARCHAR2) RETURN varchar2;
  FUNCTION prc_del_transact(json_object IN VARCHAR2) RETURN varchar2;
  /*PROCEDURE pr_gen_bank_request (p_txdate    VARCHAR2,
                                 p_txnum     VARCHAR2,
                                 p_tltxcd    VARCHAR2,
                                 p_afAcctno  VARCHAR2,
                                 p_amount    NUMBER,
                                 p_desc      VARCHAR2,
                                 pv_err_code IN OUT VARCHAR2);*/
END;
/
CREATE OR REPLACE PACKAGE BODY pck_fds_api IS

  pkgctx        plog.log_ctx;
  logrow        tlogdebug%rowtype;
  ownerschema   varchar2(50);
  databaseCache boolean;
  FUNCTION fn_check_hostatus (p_txdate   IN VARCHAR2) RETURN VARCHAR2 IS
    l_currdate    DATE;
    l_hostatus    VARCHAR2(10);
  BEGIN
    l_currdate := TO_DATE(cspks_system.fn_get_sysvar('SYSTEM', 'CURRDATE'), systemnums.C_DATE_FORMAT);
    /*IF TO_DATE(p_txdate, systemnums.C_DATE_FORMAT) <> l_currdate THEN
      RETURN -92006;
    END IF;*/

    l_hostatus := cspks_system.fn_get_sysvar('SYSTEM', 'HOSTATUS');
    IF NOT l_hostatus = '1' THEN
      RETURN -100023;
    END IF;
    RETURN systemnums.C_SUCCESS;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN errnums.C_SYSTEM_ERROR;
  END;
  FUNCTION fn_get_error_message(p_errorcode IN VARCHAR2) RETURN VARCHAR2 IS
    l_error_message VARCHAR2(2000);
  BEGIN
    SELECT errdesc
      INTO l_error_message
      FROM deferror
     WHERE errnum = p_errorcode;
    RETURN '{"ErrorCode": "' || p_errorcode || '", "ErrorMessage": "' || l_error_message || '"}';
  EXCEPTION
    WHEN OTHERS THEN
      RETURN '{"ErrorCode": "' || p_errorcode || '", "ErrorMessage": "Loi chua duoc dinh nghia!"}';
  END fn_get_error_message;

  PROCEDURE prc_controller_transact(transact    IN VARCHAR2,
                                    json_object IN VARCHAR2,
                                    p_errcode   IN OUT VARCHAR2) IS
    p_err_code VARCHAR2(1000);
    l_json_data   json;
    v_reftxdate   VARCHAR2(100);
  BEGIN
    plog.setbeginsection(pkgctx, 'prc_controller_transact');
    p_errcode := '0';
    plog.info(pkgctx, 'transact: ' || transact);
    l_json_data := json_parser.parser(json_object);
    v_reftxdate    := json_ext.get_string(l_json_data, 'fdstxdate', 1);
    p_errcode := fn_check_hostatus(v_reftxdate);
    IF p_errcode <> systemnums.C_SUCCESS THEN
      plog.setendsection(pkgctx, 'prc_controller_transact');
      RETURN;
    END IF;
    /*IF transact = 'CreateFdsAccount' THEN
      p_err_code := fn_CreateFdsAccount(json_object);
    ELSIF transact = 'CloseFdsAccount' THEN
      p_err_code := fn_CloseFdsAccount(json_object);
    END IF;*/
    IF transact = 'deposit' THEN                       -- Rut Tien Ky Quy         1179
      p_err_code := fn_call_txpks_deposit(json_object);
    ELSIF transact = 'seblock' THEN                    -- Phong Toa CK Ky Quy     2202
      p_err_code := fn_call_txpks_seblock(json_object);
    ELSIF transact = 'withdraw' THEN                   -- Nop Tien Ky Quy         1170
      p_err_code := fn_call_txpks_withdraw(json_object);
    ELSIF transact = 'sereceive' THEN                  -- Nhan CK Ky Quy          2245
      p_err_code := fn_call_txpks_sereceive(json_object);
    ELSIF transact = 'seunblock' THEN                  -- Giai Toa CK Ky Quy      2205
      p_err_code := fn_call_txpks_seunblock(json_object);
    ELSIF transact = 'setransferIn' THEN               -- Chuyen Khoan CK Noi Bo  2242
      p_err_code := fn_call_txpks_setransferIn(json_object);
    ELSIF transact = 'setranferout' THEN               -- Chuyen CK Ky Quy Ra Ngoai  2259
      p_err_code := fn_call_txpks_setranferout(json_object);
    ELSIF transact = 'deletetransaction' THEN
      p_err_code := prc_del_transact(json_object);
    ELSE
      p_err_code := errnums.C_SYSTEM_ERROR;
    END IF;
    p_errcode := p_err_code;
    plog.setendsection(pkgctx, 'prc_controller_transact');

  EXCEPTION
    WHEN OTHERS THEN
      p_errcode := '-1';
      plog.setendsection(pkgctx, 'prc_controller_transact');
  END prc_controller_transact;
------------------------------------------------ fn_CreateFdsAccount-----------------------------------------------
  /*FUNCTION fn_CreateFdsAccount(json_object IN VARCHAR2) RETURN VARCHAR2
  IS
  l_count       NUMBER;
  l_status      VARCHAR2(10);
  l_json_data   json;
  l_custid      VARCHAR2(20);
  l_afacctno    VARCHAR2(20);
  BEGIN
    plog.setBeginSection(pkgctx, 'fn_CreateFdsAccount');
    l_json_data := json_parser.parser(json_object);
    l_custid    := json_ext.get_string(l_json_data, 'custid');
    l_afacctno  := json_ext.get_string(l_json_data, 'accountNo');

    -- check custid, afacctno ton tai va tren cung 1 tk
    SELECT COUNT(1) INTO l_count
    FROM cfmast cf, afmast af
    WHERE cf.custid = af.custid
    AND cf.custid = l_custid
    AND af.acctno = l_afacctno;
    IF NOT l_count = 1 THEN
      plog.setEndSection(pkgctx, 'fn_CreateFdsAccount');
      RETURN '-200002';
    END IF;

    -- check ton tai trong fdsaccountlog
    SELECT COUNT(1) INTO l_count FROM fdsaccountlog WHERE afacctno = l_afacctno;

    IF l_count = 0 THEN
      INSERT INTO fdsaccountlog (custid,
                                 afacctno,
                                 createddt,
                                 last_change)
      VALUES (l_custid,
              l_afacctno,
              systimestamp,
              systimestamp);
      plog.setEndSection(pkgctx, 'fn_CreateFdsAccount');
      RETURN systemnums.C_SUCCESS;
    END IF;

    -- co ton tai --> kiem tra trang thai, neu close thi active lai
    SELECT status INTO l_status FROM fdsaccountlog WHERE afacctno = l_afacctno;
    IF l_status = 'A' THEN -- tk
      plog.setEndSection(pkgctx, 'fn_CreateFdsAccount');
      RETURN '-200035';
    ELSIF l_status = 'C' THEN
      UPDATE fdsaccountlog SET status = 'A', last_change = systimestamp WHERE afacctno = l_afacctno;
    END IF;

    plog.setEndSection(pkgctx, 'fn_CreateFdsAccount');
    RETURN systemnums.C_SUCCESS;
  EXCEPTION
    WHEN OTHERS THEN
      plog.setEndSection(pkgctx, 'fn_CreateFdsAccount');
      RETURN errnums.C_SYSTEM_ERROR;
  END;
------------------------------------------------ fn_CreateFdsAccount-----------------------------------------------
  /*FUNCTION fn_CloseFdsAccount(json_object IN VARCHAR2) RETURN VARCHAR2
  IS
  l_count       NUMBER;
  l_status      VARCHAR2(10);
  l_json_data   json;
  l_custid      VARCHAR2(20);
  l_afacctno    VARCHAR2(20);
  BEGIN
    plog.setBeginSection(pkgctx, 'fn_CloseFdsAccount');
    l_json_data := json_parser.parser(json_object);
    l_custid    := json_ext.get_string(l_json_data, 'custid');
    l_afacctno  := json_ext.get_string(l_json_data, 'accountNo');

    -- check custid, afacctno ton tai va tren cung 1 tk
    SELECT COUNT(1) INTO l_count
    FROM cfmast cf, afmast af
    WHERE cf.custid = af.custid
    AND cf.custid = l_custid
    AND af.acctno = l_afacctno;
    IF NOT l_count = 1 THEN
      plog.setEndSection(pkgctx, 'fn_CloseFdsAccount');
      RETURN '-200002';
    END IF;

    -- kiem tra trang thai trong fdsaccountlog: A --> close
    BEGIN
      SELECT status INTO l_status FROM fdsaccountlog WHERE afacctno = l_afacctno;
    EXCEPTION
      WHEN OTHERS THEN
        plog.setEndSection(pkgctx, 'fn_CloseFdsAccount');
        RETURN '-200002';
    END;
    IF l_status <> 'A' THEN
      plog.setEndSection(pkgctx, 'fn_CloseFdsAccount');
      RETURN '-200104';
    ELSE
      UPDATE fdsaccountlog SET status = 'C',
                               closeddt = systimestamp,
                               last_change = systimestamp
      WHERE afacctno = l_afacctno;
    END IF;

    plog.setEndSection(pkgctx, 'fn_CloseFdsAccount');
    RETURN systemnums.C_SUCCESS;
  EXCEPTION
    WHEN OTHERS THEN
      plog.setEndSection(pkgctx, 'fn_CloseFdsAccount');
      RETURN errnums.C_SYSTEM_ERROR;
  END;*/
  PROCEDURE build_txmsg_deposit( pv_acctno IN VARCHAR2,
                                pv_amount IN NUMBER,
                                pv_desc IN VARCHAR2,
                                pv_reftxnum IN VARCHAR2,
                                pv_err_code IN OUT VARCHAR2) IS
    v_custname    VARCHAR2(2000);
    v_address     VARCHAR2(3000);
    v_license     VARCHAR2(500);
    v_iddate      DATE;
    v_idplace     VARCHAR2(1000);
    l_custodycd   VARCHAR2(20);
    v_strcurrdate VARCHAR2(20);
    l_tltxcd      VARCHAR2(4);
    l_err_param   VARCHAR2(1000);
    l_sqlerrnum   VARCHAR2(200);
    l_txmsg       tx.msg_rectype;
    l_txmsg_reset tx.msg_rectype;
    l_coreBank    VARCHAR2(10);
  BEGIN
    plog.setBeginSection(pkgctx,'build_txmsg_deposit');
    SELECT cf.fullname,cf.address,cf.idcode,cf.iddate,cf.idplace,cf.custodycd, af.corebank
      INTO v_custname,v_address,v_license,v_iddate,v_idplace,l_custodycd, l_coreBank
      FROM cfmast cf, afmast af
     WHERE cf.custid = af.custid
       AND af.acctno = pv_acctno;

    l_tltxcd              := '1179';
    l_txmsg_reset.tltxcd  := l_tltxcd;
    l_txmsg_reset.msgtype := 'T';
    l_txmsg_reset.local   := 'N';
    l_txmsg_reset.tlid    := systemnums.c_system_userid;

    SELECT SYS_CONTEXT('USERENV', 'HOST'),
           SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg_reset.wsname, l_txmsg_reset.ipaddress
      FROM DUAL;

    l_txmsg_reset.off_line  := 'N';
    l_txmsg_reset.deltd     := txnums.c_deltd_txnormal;
    l_txmsg_reset.txstatus  := txstatusnums.c_txcompleted;
    l_txmsg_reset.msgsts    := '0';
    l_txmsg_reset.ovrsts    := '0';
    l_txmsg_reset.batchname := 'FDS';
    l_txmsg_reset.txdate    := getcurrdate;
    l_txmsg_reset.brid      := '0001'; -- can sua lai them brid vao day
    l_txmsg_reset.busdate   := getcurrdate;

    SELECT systemnums.c_batch_prefixed ||
           lpad(seq_batchtxnum.nextval, 8, '0')
      INTO l_txmsg_reset.txnum
      FROM DUAL;

    SELECT TO_CHAR(SYSDATE, 'hh24:mi:ss')
      INTO l_txmsg_reset.txtime
      FROM DUAL;

    pv_err_code       := 0;
    l_txmsg          := l_txmsg_reset;
    l_txmsg.reftxnum := pv_reftxnum;

    --03     ACCTNO       C
    l_txmsg.txfields('03').defname := 'ACCTNO';
    l_txmsg.txfields('03').TYPE := 'C';
    l_txmsg.txfields('03').VALUE := pv_acctno;
    --10     AMT       N
    l_txmsg.txfields('10').defname := 'AMT';
    l_txmsg.txfields('10').TYPE := 'N';
    l_txmsg.txfields('10').VALUE := NVL(pv_amount, 0);
    --30     DESC       C
    l_txmsg.txfields('30').defname := 'DESC';
    l_txmsg.txfields('30').TYPE := 'C';
    l_txmsg.txfields('30').VALUE := pv_desc;
    --88     CUSTODYCD       C
    l_txmsg.txfields('88').defname := 'CUSTODYCD';
    l_txmsg.txfields('88').TYPE := 'C';
    l_txmsg.txfields('88').VALUE := l_custodycd;
    --90     CUSTNAME       C
    l_txmsg.txfields('90').defname := 'CUSTNAME';
    l_txmsg.txfields('90').TYPE := 'C';
    l_txmsg.txfields('90').VALUE := v_custname;
    --91     ADDRESS       C
    l_txmsg.txfields('91').defname := 'ADDRESS';
    l_txmsg.txfields('91').TYPE := 'C';
    l_txmsg.txfields('91').VALUE := v_address;
    --92     LICENSE       C
    l_txmsg.txfields('92').defname := 'LICENSE';
    l_txmsg.txfields('92').TYPE := 'C';
    l_txmsg.txfields('92').VALUE := v_license;
    --93     IDDATE       C
    l_txmsg.txfields('93').defname := 'IDDATE';
    l_txmsg.txfields('93').TYPE := 'C';
    l_txmsg.txfields('93').VALUE := TO_CHAR(v_iddate, systemnums.C_DATE_FORMAT);
    --94     IDPLACE       C
    l_txmsg.txfields('94').defname := 'IDPLACE';
    l_txmsg.txfields('94').TYPE := 'C';
    l_txmsg.txfields('94').VALUE := v_idplace;

    BEGIN
      IF txpks_#1179.fn_batchtxprocess(l_txmsg, pv_err_code, l_err_param) <>
         systemnums.c_success THEN
        plog.error(pkgctx, TO_CHAR(l_err_param));
        ROLLBACK;
        plog.setendsection(pkgctx, 'build_txmsg_deposit');
        RETURN;
      END IF;

      -- Khong Dong Bo HFT Neu La TK coreBank
      IF l_coreBank <> 'Y' THEN
        PCK_SYN2FO.PRC_CHECK_SYN2FO(v_txnum => l_txmsg.txnum,
                                   v_errcode => pv_err_code,
                                   v_errmsg => l_err_param);

        plog.debug (pkgctx, 'PRC_CHECK_SYN2FO p_err_code '||pv_err_code);
        IF pv_err_code <> systemnums.c_success THEN
            ROLLBACK;
            l_err_param := cspks_system.fn_get_errmsg(pv_err_code);
            plog.error (pkgctx, l_err_param);
            plog.setendsection(pkgctx, 'build_txmsg_deposit');
            RETURN;
        END IF;
      END IF;

      -- Gen crbtxreq
      /*IF l_coreBank = 'Y' THEN
        pck_fds_api.pr_gen_bank_request (p_txdate    => TO_CHAR(l_txmsg.txdate, systemnums.C_DATE_FORMAT),
                                         p_txnum     => l_txmsg.txnum,
                                         p_tltxcd    => l_txmsg.tltxcd,
                                         p_afAcctno  => pv_acctno,
                                         p_amount    => pv_amount,
                                         p_desc      => pv_desc,
                                         pv_err_code => pv_err_code);

      END IF;*/
    END;

    plog.setEndSection(pkgctx,'build_txmsg_deposit');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || DBMS_UTILITY.format_error_backtrace);
      ROLLBACK;
      pv_err_code := '-1';
      plog.setendsection(pkgctx, 'build_txmsg_deposit');
  END;

  PROCEDURE build_txmsg_withdraw( pv_acctno IN VARCHAR2,
                                  pv_amount IN NUMBER,
                                  pv_desc IN VARCHAR2,
                                  pv_reftxnum IN VARCHAR2,
                                  pv_err_code IN OUT VARCHAR2) IS
    v_strcurrdate VARCHAR2(20);
    l_strdesc     VARCHAR2(400);
    l_tltxcd      VARCHAR2(4);
    l_err_param   VARCHAR2(1000);
    l_sqlerrnum   VARCHAR2(200);
    v_custname    VARCHAR2(2000);
    v_address     VARCHAR2(3000);
    v_license     VARCHAR2(500);
    v_iddate      DATE;
    v_idplace     VARCHAR2(1000);
    v_custodycd   VARCHAR2(20);
    l_txmsg       tx.msg_rectype;
    l_txmsg_reset tx.msg_rectype;
    l_coreBank    VARCHAR2(10);

    l_reqId       crbtxreq.reqid%TYPE;
    l_bankAccount VARCHAR2(100);

  BEGIN
    plog.setBeginSection(pkgctx,'build_txmsg_withdraw');
    SELECT cf.fullname,cf.address,cf.idcode,cf.iddate,cf.idplace,cf.custodycd, af.corebank
      INTO v_custname,v_address,v_license,v_iddate,v_idplace,v_custodycd, l_coreBank
      FROM cfmast cf, afmast af
     WHERE cf.custid = af.custid
       AND af.acctno = pv_acctno;
    v_strcurrdate := cspks_system.fn_get_sysvar('SYSTEM', 'CURRDATE');
    l_tltxcd              := '1170';
    l_txmsg_reset.tltxcd  := l_tltxcd;
    l_txmsg_reset.msgtype := 'T';
    l_txmsg_reset.local   := 'N';
    l_txmsg_reset.tlid    := systemnums.c_system_userid;

    SELECT SYS_CONTEXT('USERENV', 'HOST'),
           SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg_reset.wsname, l_txmsg_reset.ipaddress
      FROM DUAL;

    l_txmsg_reset.off_line  := 'N';
    l_txmsg_reset.deltd     := txnums.c_deltd_txnormal;
    l_txmsg_reset.txstatus  := txstatusnums.c_txcompleted;
    l_txmsg_reset.msgsts    := '0';
    l_txmsg_reset.ovrsts    := '0';
    l_txmsg_reset.batchname := 'FDS';
    l_txmsg_reset.txdate    := getcurrdate;
    l_txmsg_reset.brid      := '0001'; -- can sua lai them brid vao day
    l_txmsg_reset.busdate   := getcurrdate;

    SELECT systemnums.c_batch_prefixed ||
           lpad(seq_batchtxnum.nextval, 8, '0')
      INTO l_txmsg_reset.txnum
      FROM DUAL;

    SELECT TO_CHAR(SYSDATE, 'hh24:mi:ss')
      INTO l_txmsg_reset.txtime
      FROM DUAL;

    pv_err_code      := 0;
    l_txmsg          := l_txmsg_reset;
    l_txmsg.reftxnum := pv_reftxnum;

    --03     ACCTNO       C
    l_txmsg.txfields('03').defname := 'ACCTNO';
    l_txmsg.txfields('03').TYPE := 'C';
    l_txmsg.txfields('03').VALUE := pv_acctno;
    --10     AMT       N
    l_txmsg.txfields('10').defname := 'AMT';
    l_txmsg.txfields('10').TYPE := 'N';
    l_txmsg.txfields('10').VALUE := NVL(pv_amount, 0);
    --30     DESC       C
    l_txmsg.txfields('30').defname := 'DESC';
    l_txmsg.txfields('30').TYPE := 'C';
    l_txmsg.txfields('30').VALUE := pv_desc;
    --88     CUSTODYCD       C
    l_txmsg.txfields('88').defname := 'CUSTODYCD';
    l_txmsg.txfields('88').TYPE := 'C';
    l_txmsg.txfields('88').VALUE := v_custodycd;
    --90     CUSTNAME       C
    l_txmsg.txfields('90').defname := 'CUSTNAME';
    l_txmsg.txfields('90').TYPE := 'C';
    l_txmsg.txfields('90').VALUE := v_custname;
    --91     ADDRESS       C
    l_txmsg.txfields('91').defname := 'ADDRESS';
    l_txmsg.txfields('91').TYPE := 'C';
    l_txmsg.txfields('91').VALUE := v_address;
    --92     LICENSE       C
    l_txmsg.txfields('92').defname := 'LICENSE';
    l_txmsg.txfields('92').TYPE := 'C';
    l_txmsg.txfields('92').VALUE := v_license;
    --98     IDDATE       C
    l_txmsg.txfields('98').defname := 'IDDATE';
    l_txmsg.txfields('98').TYPE := 'D';
    l_txmsg.txfields('98').VALUE := TO_CHAR(v_iddate, systemnums.C_DATE_FORMAT);
    --99     IDPLACE       C
    l_txmsg.txfields('99').defname := 'IDPLACE';
    l_txmsg.txfields('99').TYPE := 'C';
    l_txmsg.txfields('99').VALUE := v_idplace;

    BEGIN
      IF txpks_#1170.fn_batchtxprocess(l_txmsg, pv_err_code, l_err_param) <>
         systemnums.c_success THEN
        plog.error (pkgctx, l_err_param);
        ROLLBACK;
        plog.setendsection(pkgctx, 'build_txmsg_withdraw');
        RETURN;
      END IF;
      PCK_SYN2FO.PRC_CHECK_SYN2FO(v_txnum => l_txmsg.txnum,
                                 v_errcode => pv_err_code,
                                 v_errmsg => l_err_param);


      plog.debug (pkgctx, 'PRC_CHECK_SYN2FO p_err_code '||pv_err_code);
      IF pv_err_code <> systemnums.c_success THEN
          ROLLBACK;
          l_err_param := cspks_system.fn_get_errmsg(pv_err_code);
          plog.error (pkgctx, l_err_param);
          plog.setendsection(pkgctx, 'build_txmsg_withdraw');
          RETURN;
      END IF;

      -- Gen crbtxreq
      /*IF l_coreBank = 'Y' THEN
        pck_fds_api.pr_gen_bank_request (p_txdate    => TO_CHAR(l_txmsg.txdate, systemnums.C_DATE_FORMAT),
                                         p_txnum     => l_txmsg.txnum,
                                         p_tltxcd    => l_txmsg.tltxcd,
                                         p_afAcctno  => pv_acctno,
                                         p_amount    => pv_amount,
                                         p_desc      => pv_desc,
                                         pv_err_code => pv_err_code);

      END IF;*/
    END;
    plog.setEndSection(pkgctx,'build_txmsg_withdraw');
  EXCEPTION
    WHEN OTHERS THEN
      pv_err_code := '-1';
      ROLLBACK;
      plog.error(pkgctx, SQLERRM || DBMS_UTILITY.format_error_backtrace);
      plog.setEndSection(pkgctx, 'build_txmsg_withdraw');
  END;

  PROCEDURE build_txmsg_seblock( pv_acctno   IN VARCHAR2,
                                pv_symbol   IN VARCHAR2,
                                pv_codeid   IN VARCHAR2,
                                pv_qtty     IN NUMBER,
                                pv_desc     IN VARCHAR2,
                                pv_reftxnum IN VARCHAR2,
                                pv_err_code IN OUT VARCHAR2) IS
    v_custname  varchar2(2000);
    v_address   varchar2(3000);
    v_license   varchar2(500);
    l_symbol    VARCHAR2(30);
    l_codeid    VARCHAR2(10);
    l_maxqtty   NUMBER;
    l_custodycd VARCHAR2(20);
    l_tradelot  NUMBER(20);

    l_tltxcd      VARCHAR2(4) := '2202';
    l_txmsg       tx.msg_rectype;
    l_txmsg_reset tx.msg_rectype;
    v_strcurrdate VARCHAR2(20);
    l_err_param   VARCHAR2(1000);
    l_sqlerrnum   VARCHAR2(200);
    L_PARVALUE    NUMBER;
  BEGIN
    plog.setBeginSection(pkgctx,'build_txmsg_seblock');

    SELECT sec.symbol, SEC.CODEID, seinfo.tradelot, SEC.PARVALUE
      INTO l_symbol, l_codeid, l_tradelot, L_PARVALUE
      FROM SBSECURITIES SEC, SECURITIES_INFO SEINFO
     WHERE SEC.CODEID = SEINFO.CODEID
       AND (SEC.Symbol = pv_symbol OR sec.codeid = pv_codeid)
       AND ROWNUM = 1;

    SELECT se.trade
      INTO l_maxqtty
      FROM semast se
     WHERE se.acctno = pv_acctno || l_codeid;

    SELECT cf.fullname, cf.address, cf.idcode, cf.custodycd
      INTO v_custname, v_address, v_license, l_custodycd
      FROM cfmast cf, afmast af
     WHERE cf.custid = af.custid
       AND af.acctno = pv_acctno;

    l_txmsg_reset.tltxcd  := l_tltxcd;
    l_txmsg_reset.msgtype := 'T';
    l_txmsg_reset.local   := 'N';
    l_txmsg_reset.tlid    := systemnums.c_system_userid;

    SELECT SYS_CONTEXT('USERENV', 'HOST'),
           SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg_reset.wsname, l_txmsg_reset.ipaddress
      FROM DUAL;

    l_txmsg_reset.off_line  := 'N';
    l_txmsg_reset.deltd     := txnums.c_deltd_txnormal;
    l_txmsg_reset.txstatus  := txstatusnums.c_txcompleted;
    l_txmsg_reset.msgsts    := '0';
    l_txmsg_reset.ovrsts    := '0';
    l_txmsg_reset.batchname := 'FDS';
    l_txmsg_reset.txdate    := getcurrdate;
    l_txmsg_reset.brid      := '0001'; -- can sua lai them brid vao day
    l_txmsg_reset.busdate   := getcurrdate;

    SELECT systemnums.c_batch_prefixed ||
           lpad(seq_batchtxnum.nextval, 8, '0')
      INTO l_txmsg_reset.txnum
      FROM DUAL;

    SELECT TO_CHAR(SYSDATE, 'hh24:mi:ss')
      INTO l_txmsg_reset.txtime
      FROM DUAL;

    pv_err_code       := 0;
    l_txmsg          := l_txmsg_reset;
    l_txmsg.reftxnum := pv_reftxnum;

    --01   CODEID      C;
    l_txmsg.txfields ('01').defname   := 'CODEID';
    l_txmsg.txfields ('01').TYPE      := 'C';
    l_txmsg.txfields ('01').VALUE     := l_codeid;
    --02   AFACCTNO      C;
    l_txmsg.txfields ('02').defname   := 'AFACCTNO';
    l_txmsg.txfields ('02').TYPE      := 'C';
    l_txmsg.txfields ('02').VALUE     := pv_acctno;
    --03   ACCTNO      C;
    l_txmsg.txfields ('03').defname   := 'ACCTNO';
    l_txmsg.txfields ('03').TYPE      := 'C';
    l_txmsg.txfields ('03').VALUE     := pv_acctno || l_codeid ;
    --08   TAMT      N;
    l_txmsg.txfields ('08').defname   := 'TAMT';
    l_txmsg.txfields ('08').TYPE      := 'N';
    l_txmsg.txfields ('08').VALUE     := NVL(l_maxqtty, 0);
    --09   PRICE      N;
    l_txmsg.txfields ('09').defname   := 'PRICE';
    l_txmsg.txfields ('09').TYPE      := 'N';
    l_txmsg.txfields ('09').VALUE     := L_PARVALUE;
    --10   AMT      N;
    l_txmsg.txfields ('10').defname   := 'AMT';
    l_txmsg.txfields ('10').TYPE      := 'N';
    l_txmsg.txfields ('10').VALUE     := NVL(pv_qtty, 0);
    --11   PARVALUE      N;
    l_txmsg.txfields ('11').defname   := 'PARVALUE';
    l_txmsg.txfields ('11').TYPE      := 'N';
    l_txmsg.txfields ('11').VALUE     := L_PARVALUE;
    --12   QTTYTYPE      C;
    l_txmsg.txfields ('12').defname   := 'QTTYTYPE';
    l_txmsg.txfields ('12').TYPE      := 'C';
    l_txmsg.txfields ('12').VALUE     := '008';
    --30   DESC      C;
    l_txmsg.txfields ('30').defname   := 'DESC';
    l_txmsg.txfields ('30').TYPE      := 'C';
    l_txmsg.txfields ('30').VALUE     := pv_desc ;
    --88   CUSTODYCD      C;
    l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
    l_txmsg.txfields ('88').TYPE      := 'C';
    l_txmsg.txfields ('88').VALUE     := l_custodycd;
    --90   CUSTNAME      C;
    l_txmsg.txfields ('90').defname   := 'CUSTNAME';
    l_txmsg.txfields ('90').TYPE      := 'C';
    l_txmsg.txfields ('90').VALUE     := v_custname;
    --91   ADDRESS      C;
    l_txmsg.txfields ('91').defname   := 'ADDRESS';
    l_txmsg.txfields ('91').TYPE      := 'C';
    l_txmsg.txfields ('91').VALUE     := v_address;
    --92   LICENSE      C;
    l_txmsg.txfields ('92').defname   := 'LICENSE';
    l_txmsg.txfields ('92').TYPE      := 'C';
    l_txmsg.txfields ('92').VALUE     := v_license;

    BEGIN
      IF txpks_#2202.fn_batchtxprocess(l_txmsg, pv_err_code, l_err_param) <>
         systemnums.c_success THEN
        plog.info(pkgctx, TO_CHAR(pv_err_code));
        ROLLBACK;
        plog.setEndSection(pkgctx, 'build_txmsg_seblock');
        RETURN;
      END IF;
      PCK_SYN2FO.PRC_CHECK_SYN2FO(v_txnum => l_txmsg.txnum,
                                 v_errcode => pv_err_code,
                                 v_errmsg => l_err_param);


      plog.debug (pkgctx, 'PRC_CHECK_SYN2FO p_err_code '||pv_err_code);
      IF pv_err_code <> systemnums.c_success THEN
          ROLLBACK;
          l_err_param := cspks_system.fn_get_errmsg(pv_err_code);
          plog.error (pkgctx, l_err_param);
          plog.setendsection(pkgctx, 'build_txmsg_seblock');
          RETURN;
      END IF;
    END;

    plog.setEndSection(pkgctx, 'build_txmsg_seblock');
  EXCEPTION
    WHEN OTHERS THEN
      pv_err_code := '-1';
      plog.error(pkgctx, SQLERRM || DBMS_UTILITY.format_error_backtrace);
      plog.setEndSection(pkgctx, 'build_txmsg_seblock');
  END;

  PROCEDURE build_txmsg_sereceive( pv_acctno    IN VARCHAR2,
                              pv_symbol    IN VARCHAR2,
                              pv_codeid    IN VARCHAR2,
                              pv_BLOCKqtty IN NUMBER,
                              pv_TRADEqtty IN VARCHAR2,
                              pv_desc      IN VARCHAR2,
                              pv_reftxnum  IN VARCHAR2,
                              pv_err_code  IN OUT VARCHAR2) IS
    v_custname    VARCHAR2(2000);
    v_address     VARCHAR2(3000);
    v_license     VARCHAR2(500);
    v_iddate      DATE;
    v_idplace     VARCHAR2(1000);
    l_custodycd   VARCHAR2(20);
    v_symbol      VARCHAR2(30);
    v_codeid      VARCHAR2(10);
    v_DEPOLASTDT  DATE;
    l_tltxcd      VARCHAR2(4) := '2245';
    l_err_param   VARCHAR2(1000);
    l_txmsg       tx.msg_rectype;
    l_txmsg_reset tx.msg_rectype;
    v_price       NUMBER;
    v_parvalue    NUMBER;
    v_issuerid    VARCHAR2(100);
    v_issuername  VARCHAR2(1000);
    v_tradePlace  VARCHAR2(10);
  BEGIN
    plog.setBeginSection(pkgctx, 'build_txmsg_sereceive');
    SELECT cf.fullname,cf.address,cf.idcode,cf.iddate,cf.idplace,cf.custodycd
      INTO v_custname,v_address,v_license,v_iddate,v_idplace,l_custodycd
      FROM cfmast cf, afmast af
     WHERE cf.custid = af.custid AND af.acctno = pv_acctno;
    SELECT ci.depolastdt
      INTO v_DEPOLASTDT
      FROM cimast ci
     WHERE acctno = pv_acctno;
    SELECT SEC.Codeid, seinfo.basicprice, sec.parvalue, sec.issuerid, sec.tradeplace
      INTO v_codeid, v_price, v_parvalue, v_issuerid, v_tradePlace
      FROM SBSECURITIES SEC, SECURITIES_INFO SEINFO
     WHERE SEC.CODEID = SEINFO.CODEID
       AND SEC.SECTYPE <> '004'
       AND (sec.symbol = pv_symbol OR sec.codeid = pv_codeid)
       AND ROWNUM = 1;
     SELECT SHORTNAME || ': ' || FULLNAME ISSUERNAME
       INTO v_issuername
       FROM issuers
      WHERE issuerid = v_issuerid;


    l_txmsg_reset.tltxcd  := l_tltxcd;
    l_txmsg_reset.msgtype := 'T';
    l_txmsg_reset.local   := 'N';
    l_txmsg_reset.tlid    := systemnums.c_system_userid;

    SELECT SYS_CONTEXT('USERENV', 'HOST'),
           SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg_reset.wsname, l_txmsg_reset.ipaddress
      FROM DUAL;

    l_txmsg_reset.off_line  := 'N';
    l_txmsg_reset.deltd     := txnums.c_deltd_txnormal;
    l_txmsg_reset.txstatus  := txstatusnums.c_txcompleted;
    l_txmsg_reset.msgsts    := '0';
    l_txmsg_reset.ovrsts    := '0';
    l_txmsg_reset.batchname := 'FDS';
    l_txmsg_reset.txdate    := getcurrdate;
    l_txmsg_reset.brid      := '0001'; -- can sua lai them brid vao day
    l_txmsg_reset.busdate   := getcurrdate;

    SELECT systemnums.c_batch_prefixed || lpad(seq_batchtxnum.nextval, 8, '0')
      INTO l_txmsg_reset.txnum
      FROM DUAL;
    SELECT TO_CHAR(SYSDATE, 'hh24:mi:ss')
      INTO l_txmsg_reset.txtime
      FROM DUAL;

    pv_err_code       := 0;
    l_txmsg          := l_txmsg_reset;
    l_txmsg.reftxnum := pv_reftxnum;

    --00     FEETYPE       C
    l_txmsg.txfields('00').defname := 'FEETYPE';
    l_txmsg.txfields('00').TYPE := 'C';
    l_txmsg.txfields('00').VALUE := '';
    --01     CODEID       C
    l_txmsg.txfields('01').defname := 'CODEID';
    l_txmsg.txfields('01').TYPE := 'C';
    l_txmsg.txfields('01').VALUE := v_codeid;
    --02     REFID       C
    l_txmsg.txfields('02').defname := 'REFID';
    l_txmsg.txfields('02').TYPE := 'C';
    l_txmsg.txfields('02').VALUE := '';
    --03     INWARD       C
    l_txmsg.txfields('03').defname := 'INWARD';
    l_txmsg.txfields('03').TYPE := 'C';
    l_txmsg.txfields('03').VALUE := '';
    --04     AFACCT2      C
    l_txmsg.txfields('04').defname := 'AFACCT2';
    l_txmsg.txfields('04').TYPE := 'C';
    l_txmsg.txfields('04').VALUE := pv_acctno;
    --05     ACCT2       C
    l_txmsg.txfields('05').defname := 'ACCT2';
    l_txmsg.txfields('05').TYPE := 'C';
    l_txmsg.txfields('05').VALUE := pv_acctno || v_codeid;
    --06     DEPOBLOCK       N
    l_txmsg.txfields('06').defname := 'DEPOBLOCK';
    l_txmsg.txfields('06').TYPE := 'N';
    l_txmsg.txfields('06').VALUE := NVL(pv_BLOCKqtty,0);
    --09     PRICE       N
    l_txmsg.txfields('09').defname := 'PRICE';
    l_txmsg.txfields('09').TYPE := 'N';
    l_txmsg.txfields('09').VALUE := v_price;
    --10     AMT       N
    l_txmsg.txfields('10').defname := 'AMT';
    l_txmsg.txfields('10').TYPE := 'N';
    l_txmsg.txfields('10').VALUE := NVL(pv_TRADEqtty, 0);
    --11     PARVALUE       N
    l_txmsg.txfields('11').defname := 'PARVALUE';
    l_txmsg.txfields('11').TYPE := 'N';
    l_txmsg.txfields('11').VALUE := v_parvalue;
    --12     QTTY       N
    l_txmsg.txfields('12').defname := 'QTTY';
    l_txmsg.txfields('12').TYPE := 'N';
    l_txmsg.txfields('12').VALUE := NVL(pv_BLOCKqtty, 0) + NVL(pv_TRADEqtty, 0);
    --13     DEPOFEEACR       N
    l_txmsg.txfields('13').defname := 'DEPOFEEACR';
    l_txmsg.txfields('13').TYPE := 'N';
    l_txmsg.txfields('13').VALUE := 0;
    --14     QTTYTYPE       N
    l_txmsg.txfields('14').defname := 'QTTYTYPE';
    l_txmsg.txfields('14').TYPE := 'C';
    l_txmsg.txfields('14').VALUE := '008';
    --15     DEPOFEEAMT       N
    l_txmsg.txfields('15').defname := 'DEPOFEEAMT';
    l_txmsg.txfields('15').TYPE := 'N';
    l_txmsg.txfields('15').VALUE := 0;
    --20     ISSUERNAME       N
    l_txmsg.txfields('20').defname := 'ISSUERNAME';
    l_txmsg.txfields('20').TYPE := 'C';
    l_txmsg.txfields('20').VALUE := v_issuername;
    --21     TRADEPLACE       N
    l_txmsg.txfields('21').defname := 'TRADEPLACE';
    l_txmsg.txfields('21').TYPE := 'C';
    l_txmsg.txfields('21').VALUE := v_tradePlace;
    --25     ACCTNO_UPDATECOST       N
    l_txmsg.txfields('25').defname := 'ACCTNO_UPDATECOST';
    l_txmsg.txfields('25').TYPE := 'C';
    l_txmsg.txfields('25').VALUE := pv_acctno || v_codeid;
    --30     DES       C
    l_txmsg.txfields('30').defname := 'DES';
    l_txmsg.txfields('30').TYPE := 'C';
    l_txmsg.txfields('30').VALUE := pv_desc;
    --31     TRTYPE       C      --loai chuyen khoan
    l_txmsg.txfields('31').defname := 'TRTYPE';
    l_txmsg.txfields('31').TYPE := 'C';
    l_txmsg.txfields('31').VALUE := '010';
    --32     DEPOLASTDT       C
    l_txmsg.txfields('32').defname := 'DEPOLASTDT';
    l_txmsg.txfields('32').TYPE := 'D';
    l_txmsg.txfields('32').VALUE := v_DEPOLASTDT;
    --88     CUSTODYCD       C
    l_txmsg.txfields('88').defname := 'CUSTODYCD';
    l_txmsg.txfields('88').TYPE := 'C';
    l_txmsg.txfields('88').VALUE := l_custodycd;
    --90     CUSTNAME       C
    l_txmsg.txfields('90').defname := 'CUSTNAME';
    l_txmsg.txfields('90').TYPE := 'C';
    l_txmsg.txfields('90').VALUE := v_custname;
    --91     ADDRESS       C
    l_txmsg.txfields('91').defname := 'ADDRESS';
    l_txmsg.txfields('91').TYPE := 'C';
    l_txmsg.txfields('91').VALUE := v_address;
    --92     LICENSE       C
    l_txmsg.txfields('92').defname := 'LICENSE';
    l_txmsg.txfields('92').TYPE := 'C';
    l_txmsg.txfields('92').VALUE := v_license;
    --99     AUTOID       C
    l_txmsg.txfields('99').defname := 'AUTOID';
    l_txmsg.txfields('99').TYPE := 'C';
    l_txmsg.txfields('99').VALUE := 0;
    
     --16   CAQTTY011     N
    l_txmsg.txfields('16').defname := 'CAQTTY011';
    l_txmsg.txfields('16').type := 'N';
    l_txmsg.txfields('16').value := 0;
        
    --17    TAXRATE011     N
    l_txmsg.txfields('17').defname := 'TAXRATE011';
    l_txmsg.txfields('17').type := 'N';
    l_txmsg.txfields('17').value := 0;
        
    --18    CAQTTY021     N
    l_txmsg.txfields('18').defname := 'CAQTTY021';
    l_txmsg.txfields('18').type := 'N';
    l_txmsg.txfields('18').value := 0;
        
    --19    TAXRATE021     N
    l_txmsg.txfields('19').defname := 'TAXRATE021';
    l_txmsg.txfields('19').type := 'N';
    l_txmsg.txfields('19').value := 0;

    BEGIN
      IF txpks_#2245.fn_batchtxprocess(l_txmsg, pv_err_code, l_err_param) <>
         systemnums.c_success THEN
        plog.error(pkgctx, l_err_param);
        ROLLBACK;
        plog.setEndSection(pkgctx, 'build_txmsg_sereceive');
        RETURN;
      END IF;
      PCK_SYN2FO.PRC_CHECK_SYN2FO(v_txnum => l_txmsg.txnum,
                                 v_errcode => pv_err_code,
                                 v_errmsg => l_err_param);


      plog.debug (pkgctx, 'PRC_CHECK_SYN2FO p_err_code '||pv_err_code);
      IF pv_err_code <> systemnums.c_success THEN
          ROLLBACK;
          l_err_param := cspks_system.fn_get_errmsg(pv_err_code);
          plog.error (pkgctx, l_err_param);
          plog.setendsection(pkgctx, 'build_txmsg_sereceive');
          RETURN;
      END IF;
    END;
    plog.setEndSection(pkgctx, 'build_txmsg_sereceive');
  EXCEPTION
    WHEN OTHERS THEN
      pv_err_code := '-1';
      plog.error(pkgctx, SQLERRM || DBMS_UTILITY.format_error_backtrace);
      plog.setEndSection(pkgctx, 'build_txmsg_sereceive');
  END;

  PROCEDURE build_txmsg_setransferIn( pv_creditAcctno   IN VARCHAR2,
                                    pv_debitAcctno    IN VARCHAR2,
                                    pv_symbol         IN VARCHAR2,
                                    pv_codeid         IN VARCHAR2,
                                    pv_qtty           IN NUMBER,
                                    pv_desc           IN VARCHAR2,
                                    pv_reftxnum       IN VARCHAR2,
                                    pv_err_code       IN OUT VARCHAR2) IS
    v_codeid      VARCHAR2(10);
    v_parvalue    NUMBER;
    v_price       NUMBER;
    v_custodycd   VARCHAR2(10);
    v_custname    VARCHAR2(2000);
    v_address     VARCHAR2(3000);
    v_license     VARCHAR2(500);
    v_iddate      DATE;
    v_idplace     VARCHAR2(1000);
    v_strcurrdate VARCHAR2(20);
    l_strdesc     VARCHAR2(400);
    l_tltxcd      VARCHAR2(4) := '2242';
    l_err_param   VARCHAR2(1000);
    l_txmsg       tx.msg_rectype;
    l_txmsg_reset tx.msg_rectype;
 BEGIN
   plog.setBeginSection(pkgctx,'build_txmsg_setransferIn');
    SELECT cf.fullname,cf.address,cf.idcode,cf.iddate,cf.idplace,cf.custodycd
      INTO v_custname,v_address,v_license,v_iddate,v_idplace,v_custodycd
      FROM cfmast cf, afmast af
     WHERE cf.custid = af.custid
       AND af.acctno = pv_debitAcctno;
    SELECT SEC.CODEID, sec.basicprice, sb.parvalue
      INTO v_codeid, v_price, v_parvalue
      FROM SECURITIES_INFO SEC, sbsecurities sb
     WHERE sb.codeid = sec.codeid
       AND (sec.symbol = pv_symbol OR sec.codeid = pv_codeid)
       AND ROWNUM = 1;

    l_txmsg_reset.tltxcd  := l_tltxcd;
    l_txmsg_reset.msgtype := 'T';
    l_txmsg_reset.local   := 'N';
    l_txmsg_reset.tlid    := systemnums.c_system_userid;

    SELECT SYS_CONTEXT('USERENV', 'HOST'),
           SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg_reset.wsname, l_txmsg_reset.ipaddress
      FROM DUAL;

    l_txmsg_reset.off_line  := 'N';
    l_txmsg_reset.deltd     := txnums.c_deltd_txnormal;
    l_txmsg_reset.txstatus  := txstatusnums.c_txcompleted;
    l_txmsg_reset.msgsts    := '0';
    l_txmsg_reset.ovrsts    := '0';
    l_txmsg_reset.batchname := 'AUTO';
    l_txmsg_reset.txdate    := getcurrdate;
    l_txmsg_reset.brid      := '0001'; -- can sua lai them brid vao day
    l_txmsg_reset.busdate   := getcurrdate;

    SELECT systemnums.c_batch_prefixed || lpad(seq_batchtxnum.nextval, 8, '0')
      INTO l_txmsg_reset.txnum
      FROM DUAL;

    SELECT TO_CHAR(SYSDATE, 'hh24:mi:ss')
      INTO l_txmsg_reset.txtime
      FROM DUAL;

    pv_err_code       := 0;
    l_txmsg          := l_txmsg_reset;
    l_txmsg.reftxnum := pv_reftxnum;

    --01     CODEID       C
    l_txmsg.txfields('01').defname := 'CODEID';
    l_txmsg.txfields('01').TYPE := 'C';
    l_txmsg.txfields('01').VALUE := v_codeid;
    --02     AFACCTNO       C
    l_txmsg.txfields('02').defname := 'AFACCTNO';
    l_txmsg.txfields('02').TYPE := 'C';
    l_txmsg.txfields('02').VALUE := pv_debitAcctno;
    --03     ACCTNO       C
    l_txmsg.txfields('03').defname := 'ACCTNO';
    l_txmsg.txfields('03').TYPE := 'C';
    l_txmsg.txfields('03').VALUE := pv_debitAcctno || v_codeid;
    --04     AFACCT2       C
    l_txmsg.txfields('04').defname := 'AFACCT2';
    l_txmsg.txfields('04').TYPE := 'C';
    l_txmsg.txfields('04').VALUE := pv_creditAcctno;
    --05     ACCT2       C
    l_txmsg.txfields('05').defname := 'ACCT2';
    l_txmsg.txfields('05').TYPE := 'C';
    l_txmsg.txfields('05').VALUE := pv_creditAcctno || v_codeid;
    --06     DEPOBLOCK       N
    l_txmsg.txfields('06').defname := 'DEPOBLOCK';
    l_txmsg.txfields('06').TYPE := 'N';
    l_txmsg.txfields('06').VALUE := 0;
    --09     PRICE       N
    l_txmsg.txfields('09').defname := 'PRICE';
    l_txmsg.txfields('09').TYPE := 'N';
    l_txmsg.txfields('09').VALUE := 0;
    --10     AMT       N
    l_txmsg.txfields('10').defname := 'AMT';
    l_txmsg.txfields('10').TYPE := 'N';
    l_txmsg.txfields('10').VALUE := NVL(pv_qtty, 0);
    --11     PARVALUE       N
    l_txmsg.txfields('11').defname := 'PARVALUE';
    l_txmsg.txfields('11').TYPE := 'N';
    l_txmsg.txfields('11').VALUE := NVL(v_parvalue, 0);
    --12     QTTY       N
    l_txmsg.txfields('12').defname := 'QTTY';
    l_txmsg.txfields('12').TYPE := 'N';
    l_txmsg.txfields('12').VALUE := NVL(pv_qtty, 0);
    --13     TRADEWTF       N
    l_txmsg.txfields('13').defname := 'TRADEWTF';
    l_txmsg.txfields('13').TYPE := 'N';
    l_txmsg.txfields('13').VALUE := 0;
    --14     QTTYTYPE       C
    l_txmsg.txfields('14').defname := 'QTTYTYPE';
    l_txmsg.txfields('14').TYPE := 'C';
    l_txmsg.txfields('14').VALUE := '008';
    --15     DEPOFEEAMT       C
    l_txmsg.txfields('15').defname := 'DEPOFEEAMT';
    l_txmsg.txfields('15').TYPE := 'N';
    l_txmsg.txfields('15').VALUE := 0;
    --16     DEPOFEEACR       C
    l_txmsg.txfields('16').defname := 'DEPOFEEACR';
    l_txmsg.txfields('16').TYPE := 'N';
    l_txmsg.txfields('16').VALUE := 0;
    --17     DEPOBLOCK_CHK       C
    l_txmsg.txfields('17').defname := 'DEPOBLOCK_CHK';
    l_txmsg.txfields('17').TYPE := 'N';
    l_txmsg.txfields('17').VALUE := 0;
    --18     AUTOID       C
    l_txmsg.txfields('18').defname := 'AUTOID';
    l_txmsg.txfields('18').TYPE := 'N';
    l_txmsg.txfields('18').VALUE := -1;
    --19     ORGAMT       C
    l_txmsg.txfields('19').defname := 'ORGAMT';
    l_txmsg.txfields('19').TYPE := 'N';
    l_txmsg.txfields('19').VALUE := -1;
    --20     ORGTRADEWTF       C
    l_txmsg.txfields('20').defname := 'ORGTRADEWTF';
    l_txmsg.txfields('20').TYPE := 'N';
    l_txmsg.txfields('20').VALUE := 0;
    --21     AMT_CHK       C
    l_txmsg.txfields('21').defname := 'AMT_CHK';
    l_txmsg.txfields('21').TYPE := 'N';
    l_txmsg.txfields('21').VALUE := NVL(pv_qtty, 0);
    --22     MINTRADEWTF       C
    l_txmsg.txfields('22').defname := 'MINTRADEWTF';
    l_txmsg.txfields('22').TYPE := 'N';
    l_txmsg.txfields('22').VALUE := 0;
    --23     DB_ACCTNO_UPDATECOST       C
    l_txmsg.txfields('23').defname := 'DB_ACCTNO_UPDATECOST';
    l_txmsg.txfields('23').TYPE := 'C';
    l_txmsg.txfields('23').VALUE := pv_debitAcctno || v_codeid;
    --24     CODEID_UPDATECOST       C
    l_txmsg.txfields('24').defname := 'CODEID_UPDATECOST';
    l_txmsg.txfields('24').TYPE := 'C';
    l_txmsg.txfields('24').VALUE := v_codeid;
    --25     CD_ACCTNO_UPDATECOST       C
    l_txmsg.txfields('25').defname := 'CD_ACCTNO_UPDATECOST';
    l_txmsg.txfields('25').TYPE := 'C';
    l_txmsg.txfields('25').VALUE := pv_creditAcctno || v_codeid;
    --30     DESC       C
    l_txmsg.txfields('30').defname := 'DESC';
    l_txmsg.txfields('30').TYPE := 'C';
    l_txmsg.txfields('30').VALUE := pv_desc;
    --31     TRTYPE       C
    l_txmsg.txfields('31').defname := 'TRTYPE';
    l_txmsg.txfields('31').TYPE := 'C';
    l_txmsg.txfields('31').VALUE := '010';
    --32     TRTYPE       C
    l_txmsg.txfields('32').defname := 'DEPOLASTDT';
    l_txmsg.txfields('32').TYPE := 'D';
    l_txmsg.txfields('32').VALUE := TO_CHAR(getcurrdate,systemnums.C_DATE_FORMAT);
    --90     CUSTNAME       C
    l_txmsg.txfields('90').defname := 'CUSTNAME';
    l_txmsg.txfields('90').TYPE := 'C';
    l_txmsg.txfields('90').VALUE := v_custname;
    --91     ADDRESS       C
    l_txmsg.txfields('91').defname := 'ADDRESS';
    l_txmsg.txfields('91').TYPE := 'C';
    l_txmsg.txfields('91').VALUE := v_address;
    --92     LICENSE       C
    l_txmsg.txfields('92').defname := 'LICENSE';
    l_txmsg.txfields('92').TYPE := 'C';
    l_txmsg.txfields('92').VALUE := v_license;
    --93     CUSTNAME2       C
    l_txmsg.txfields('93').defname := 'CUSTNAME2';
    l_txmsg.txfields('93').TYPE := 'C';
    l_txmsg.txfields('93').VALUE := v_custname;
    --94     ADDRESS2       C
    l_txmsg.txfields('94').defname := 'ADDRESS2';
    l_txmsg.txfields('94').TYPE := 'C';
    l_txmsg.txfields('94').VALUE := v_address;
    --95     LICENSE2       C
    l_txmsg.txfields('95').defname := 'LICENSE2';
    l_txmsg.txfields('95').TYPE := 'C';
    l_txmsg.txfields('95').VALUE := v_license;
    --96     NEEDQTTY       C
    l_txmsg.txfields('96').defname := 'NEEDQTTY';
    l_txmsg.txfields('96').TYPE := 'N';
    l_txmsg.txfields('96').VALUE := 0;

    BEGIN
      IF txpks_#2242.fn_batchtxprocess(l_txmsg, pv_err_code, l_err_param) <>
         systemnums.c_success THEN
        plog.info(pkgctx, TO_CHAR(pv_err_code));
        ROLLBACK;
        plog.setEndSection(pkgctx, 'build_txmsg_setransferIn');
        RETURN;
      END IF;
      PCK_SYN2FO.PRC_CHECK_SYN2FO(v_txnum => l_txmsg.txnum,
                                 v_errcode => pv_err_code,
                                 v_errmsg => l_err_param);


      plog.debug (pkgctx, 'PRC_CHECK_SYN2FO p_err_code '||pv_err_code);
      IF pv_err_code <> systemnums.c_success THEN
          ROLLBACK;
          l_err_param := cspks_system.fn_get_errmsg(pv_err_code);
          plog.error (pkgctx, l_err_param);
          plog.setendsection(pkgctx, 'build_txmsg_setransferIn');
          RETURN;
      END IF;
    END;
    plog.setEndSection(pkgctx, 'build_txmsg_setransferIn');
  EXCEPTION
    WHEN OTHERS THEN
      pv_err_code := '-1';
      plog.error(pkgctx, SQLERRM || DBMS_UTILITY.format_error_backtrace);
      plog.setEndSection(pkgctx, 'build_txmsg_setransferIn');
  END;

  PROCEDURE build_txmsg_setranferout( v_acctno      IN VARCHAR2,
                                      v_symbol      IN VARCHAR2,
                                      v_codeid      IN VARCHAR2,
                                      v_BLOCKqtty   IN NUMBER,
                                      v_TRADEqtty   IN NUMBER,
                                      v_desc        IN VARCHAR2,
                                      v_reftxnum    IN VARCHAR2,
                                      p_err_code    IN OUT VARCHAR2) IS
    l_codeid    VARCHAR2(6);
    v_price     NUMBER;
    v_parvalue  NUMBER;
    v_custname  varchar2(50);
    v_address   varchar2(500);
    v_license   varchar2(50);
    v_iddate    DATE;
    v_idplace   VARCHAR2(1000);
    l_custodycd   varchar2(10);
    l_txmsg       tx.msg_rectype;
    l_txmsg_reset tx.msg_rectype;
    v_strcurrdate VARCHAR2(20);
    l_strdesc     VARCHAR2(400);
    l_tltxcd      VARCHAR2(4) := '2259';
    l_err_param   VARCHAR2(1000);
    l_sqlerrnum   VARCHAR2(200);
  BEGIN
    plog.setBeginSection(pkgctx, 'build_txmsg_setranferout');
    SELECT cf.fullname, cf.address, cf.idcode, cf.iddate, cf.idplace, cf.custodycd
      INTO v_custname, v_address, v_license, v_iddate, v_idplace, l_custodycd
      FROM cfmast cf, afmast af
     WHERE cf.custid = af.custid
       AND af.acctno = v_acctno;
    SELECT SEC.CODEID, sec.basicprice, sb.parvalue
      INTO l_codeid,v_price,v_parvalue
      FROM SECURITIES_INFO SEC, sbsecurities sb
     WHERE sb.codeid = sec.codeid
       AND (sec.symbol = v_symbol OR sec.codeid = v_codeid)
       AND ROWNUM = 1;

    l_txmsg_reset.tltxcd  := l_tltxcd;
    l_txmsg_reset.msgtype := 'T';
    l_txmsg_reset.local   := 'N';
    l_txmsg_reset.tlid    := systemnums.c_system_userid;

    SELECT SYS_CONTEXT('USERENV', 'HOST'),
           SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg_reset.wsname, l_txmsg_reset.ipaddress
      FROM DUAL;

    l_txmsg_reset.off_line  := 'N';
    l_txmsg_reset.deltd     := txnums.c_deltd_txnormal;
    l_txmsg_reset.txstatus  := txstatusnums.c_txcompleted;
    l_txmsg_reset.msgsts    := '0';
    l_txmsg_reset.ovrsts    := '0';
    l_txmsg_reset.batchname := 'FDS';
    l_txmsg_reset.txdate    := getcurrdate;
    l_txmsg_reset.brid      := '0001'; -- can sua lai them brid vao day
    l_txmsg_reset.busdate   := getcurrdate;

    SELECT systemnums.c_batch_prefixed ||
           lpad(seq_batchtxnum.nextval, 8, '0')
      INTO l_txmsg_reset.txnum
      FROM DUAL;

    SELECT TO_CHAR(SYSDATE, 'hh24:mi:ss')
      INTO l_txmsg_reset.txtime
      FROM DUAL;

    p_err_code       := 0;
    l_txmsg          := l_txmsg_reset;
    l_txmsg.reftxnum := v_reftxnum;

    --01     CODEID       C
    l_txmsg.txfields('01').defname := 'CODEID';
    l_txmsg.txfields('01').TYPE := 'C';
    l_txmsg.txfields('01').VALUE := l_codeid;
    --02     AFACCTNO       C
    l_txmsg.txfields('02').defname := 'AFACCTNO';
    l_txmsg.txfields('02').TYPE := 'C';
    l_txmsg.txfields('02').VALUE := v_acctno;
    --03     ACCTNO       C
    l_txmsg.txfields('03').defname := 'ACCTNO';
    l_txmsg.txfields('03').TYPE := 'C';
    l_txmsg.txfields('03').VALUE := v_acctno || l_codeid;
    --06     DEPOBLOCK       N
    l_txmsg.txfields('06').defname := 'DEPOBLOCK';
    l_txmsg.txfields('06').TYPE := 'N';
    l_txmsg.txfields('06').VALUE := NVL(v_BLOCKqtty, 0);
    --09     PRICE       N
    l_txmsg.txfields('09').defname := 'PRICE';
    l_txmsg.txfields('09').TYPE := 'N';
    l_txmsg.txfields('09').VALUE := v_price;
    --10     AMT       N
    l_txmsg.txfields('10').defname := 'AMT';
    l_txmsg.txfields('10').TYPE := 'N';
    l_txmsg.txfields('10').VALUE := NVL(v_TRADEqtty,0);
    --11     PARVALUE       N
    l_txmsg.txfields('11').defname := 'PARVALUE';
    l_txmsg.txfields('11').TYPE := 'N';
    l_txmsg.txfields('11').VALUE := v_parvalue;
    --12     QTTY       N
    l_txmsg.txfields('12').defname := 'QTTY';
    l_txmsg.txfields('12').TYPE := 'N';
    l_txmsg.txfields('12').VALUE := NVL(v_BLOCKqtty, 0) + NVL(v_TRADEqtty,0);
    --15     CUSTODYCD       N
    l_txmsg.txfields('15').defname := 'CUSTODYCD';
    l_txmsg.txfields('15').TYPE := 'C';
    l_txmsg.txfields('15').VALUE := '';
    --30     DESC       C
    l_txmsg.txfields('30').defname := 'DESC';
    l_txmsg.txfields('30').TYPE := 'C';
    l_txmsg.txfields('30').VALUE := v_desc;
    --90     CUSTNAME       C
    l_txmsg.txfields('90').defname := 'CUSTNAME';
    l_txmsg.txfields('90').TYPE := 'C';
    l_txmsg.txfields('90').VALUE := v_custname;
    --91     ADDRESS       C
    l_txmsg.txfields('91').defname := 'ADDRESS';
    l_txmsg.txfields('91').TYPE := 'C';
    l_txmsg.txfields('91').VALUE := v_address;
    --92     LICENSE       C
    l_txmsg.txfields('92').defname := 'LICENSE';
    l_txmsg.txfields('92').TYPE := 'C';
    l_txmsg.txfields('92').VALUE := v_license;
    --93     IDDATE       C
    l_txmsg.txfields('93').defname := 'IDDATE';
    l_txmsg.txfields('93').TYPE := 'C';
    l_txmsg.txfields('93').VALUE := TO_CHAR(v_iddate,systemnums.C_DATE_FORMAT);
    --94     IDPLACE       C
    l_txmsg.txfields('94').defname := 'IDPLACE';
    l_txmsg.txfields('94').TYPE := 'C';
    l_txmsg.txfields('94').VALUE := v_idplace;
    BEGIN
      IF txpks_#2259.fn_batchtxprocess(l_txmsg, p_err_code, l_err_param) <>
         systemnums.c_success THEN
        plog.info(pkgctx, TO_CHAR(p_err_code));
        ROLLBACK;
        plog.setendsection(pkgctx, 'build_txmsg_setranferout');
        RETURN;
      END IF;
      PCK_SYN2FO.PRC_CHECK_SYN2FO(v_txnum => l_txmsg.txnum,
                                 v_errcode => p_err_code,
                                 v_errmsg => l_err_param);


      plog.debug (pkgctx, 'PRC_CHECK_SYN2FO p_err_code '||p_err_code);
      IF p_err_code <> systemnums.c_success THEN
          ROLLBACK;
          l_err_param := cspks_system.fn_get_errmsg(p_err_code);
          plog.error (pkgctx, l_err_param);
          plog.setendsection(pkgctx, 'build_txmsg_setranferout');
          RETURN;
      END IF;
    END;
    plog.setEndSection(pkgctx,'build_txmsg_setranferout');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || DBMS_UTILITY.format_error_backtrace);
      p_err_code := '-1';
      plog.setEndSection(pkgctx,'build_txmsg_setranferout');
  END;
  PROCEDURE build_txmsg_seunblock( pv_acctno      IN VARCHAR2,
                                  pv_symbol      IN VARCHAR2,
                                  pv_codeid      IN VARCHAR2,
                                  pv_qtty        IN NUMBER,
                                  pv_desc        IN VARCHAR2,
                                  pv_reftxnum    IN VARCHAR2,
                                  pv_err_code    IN OUT VARCHAR2) IS
    v_custname  varchar2(2000);
    v_qtty      NUMBER;
    v_address   varchar2(3000);
    v_license   varchar2(500);
    v_iddate    DATE;
    v_idplace   VARCHAR2(1000);
    v_price     NUMBER;
    v_parvalue  NUMBER;
    v_codeid    VARCHAR2(10);
    l_txmsg       tx.msg_rectype;
    l_txmsg_reset tx.msg_rectype;
    v_strcurrdate VARCHAR2(20);
    l_tltxcd      VARCHAR2(4) := '2205';
    l_err_param   VARCHAR2(1000);
    l_sqlerrnum   VARCHAR2(200);
  BEGIN
    plog.setBeginSection(pkgctx,'build_txmsg_seunblock');
    SELECT cf.fullname, cf.address, cf.idcode, cf.iddate, cf.idplace
      INTO v_custname, v_address, v_license, v_iddate, v_idplace
      FROM cfmast cf, afmast af
     WHERE cf.custid = af.custid
       AND af.acctno = pv_acctno;
    SELECT SEC.CODEID, sec.basicprice, sb.parvalue
      INTO v_codeid, v_price, v_parvalue
      FROM SECURITIES_INFO SEC, sbsecurities sb
     WHERE sb.codeid = sec.codeid
       AND (sec.symbol = pv_symbol OR sec.codeid = pv_codeid)
       AND ROWNUM = 1;

    l_txmsg_reset.tltxcd  := l_tltxcd;
    l_txmsg_reset.msgtype := 'T';
    l_txmsg_reset.local   := 'N';
    l_txmsg_reset.tlid    := systemnums.c_system_userid;

    SELECT SYS_CONTEXT('USERENV', 'HOST'),
           SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg_reset.wsname, l_txmsg_reset.ipaddress
      FROM DUAL;

    l_txmsg_reset.off_line  := 'N';
    l_txmsg_reset.deltd     := txnums.c_deltd_txnormal;
    l_txmsg_reset.txstatus  := txstatusnums.c_txcompleted;
    l_txmsg_reset.msgsts    := '0';
    l_txmsg_reset.ovrsts    := '0';
    l_txmsg_reset.batchname := 'FDS';
    l_txmsg_reset.txdate    := getcurrdate;
    l_txmsg_reset.brid      := '0001'; -- can sua lai them brid vao day
    l_txmsg_reset.busdate   := getcurrdate;

    SELECT TO_CHAR(SYSDATE, 'hh24:mi:ss')
      INTO l_txmsg_reset.txtime
      FROM DUAL;
    v_qtty := pv_qtty;
    pv_err_code      := 0;
    l_txmsg          := l_txmsg_reset;
    l_txmsg.reftxnum := pv_reftxnum;

    SELECT systemnums.c_batch_prefixed ||
           lpad(seq_batchtxnum.nextval, 8, '0')
      INTO l_txmsg.txnum
      FROM DUAL;
    --01     CODEID       C
    l_txmsg.txfields('01').defname := 'CODEID';
    l_txmsg.txfields('01').TYPE := 'C';
    l_txmsg.txfields('01').VALUE := v_codeid;
    --02     AFACCTNO       C
    l_txmsg.txfields('02').defname := 'AFACCTNO';
    l_txmsg.txfields('02').TYPE := 'C';
    l_txmsg.txfields('02').VALUE := pv_acctno;
    --03     ACCTNO       C
    l_txmsg.txfields('03').defname := 'ACCTNO';
    l_txmsg.txfields('03').TYPE := 'C';
    l_txmsg.txfields('03').VALUE := pv_acctno || v_codeid;
    --09     PRICE       N
    l_txmsg.txfields('09').defname := 'PRICE';
    l_txmsg.txfields('09').TYPE := 'N';
    l_txmsg.txfields('09').VALUE := NVL(v_parvalue, 0);
    --11     PARVALUE       N
    l_txmsg.txfields('11').defname := 'PARVALUE';
    l_txmsg.txfields('11').TYPE := 'N';
    l_txmsg.txfields('11').VALUE := v_parvalue;
    --12     QTTYTYPE       N
    l_txmsg.txfields('12').defname := 'QTTYTYPE';
    l_txmsg.txfields('12').TYPE := 'C';
    l_txmsg.txfields('12').VALUE := '008';
    --14     TRADEAMT       N
    l_txmsg.txfields('10').defname := 'TRADEAMT';
    l_txmsg.txfields('10').TYPE := 'N';
    l_txmsg.txfields('10').VALUE := pv_qtty;
    --30     DESC       C
    l_txmsg.txfields('30').defname := 'DESC';
    l_txmsg.txfields('30').TYPE := 'C';
    l_txmsg.txfields('30').VALUE := pv_desc;
    --90     CUSTNAME       C
    l_txmsg.txfields('90').defname := 'CUSTNAME';
    l_txmsg.txfields('90').TYPE := 'C';
    l_txmsg.txfields('90').VALUE := v_custname;
    --91     ADDRESS       C
    l_txmsg.txfields('91').defname := 'ADDRESS';
    l_txmsg.txfields('91').TYPE := 'C';
    l_txmsg.txfields('91').VALUE := v_address;
    --92     LICENSE       C
    l_txmsg.txfields('92').defname := 'LICENSE';
    l_txmsg.txfields('92').TYPE := 'C';
    l_txmsg.txfields('92').VALUE := v_license;

    BEGIN
      IF txpks_#2205.fn_batchtxprocess(l_txmsg, pv_err_code, l_err_param) <>
         systemnums.c_success THEN
        plog.info(pkgctx, TO_CHAR(pv_err_code));
        ROLLBACK;
        plog.setEndSection(pkgctx,'build_txmsg_seunblock');
        RETURN;
      END IF;
      PCK_SYN2FO.PRC_CHECK_SYN2FO(v_txnum => l_txmsg.txnum,
                                 v_errcode => pv_err_code,
                                 v_errmsg => l_err_param);


      plog.debug (pkgctx, 'PRC_CHECK_SYN2FO p_err_code ' || pv_err_code);
      IF pv_err_code <> systemnums.c_success THEN
          ROLLBACK;
          l_err_param := cspks_system.fn_get_errmsg(pv_err_code);
          plog.error (pkgctx, l_err_param);
          plog.setendsection(pkgctx, 'build_txmsg_seunblock');
          RETURN;
      END IF;
    END;

    plog.setEndSection(pkgctx,'build_txmsg_seunblock');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || DBMS_UTILITY.format_error_backtrace);
      pv_err_code := '-1';
      plog.setEndSection(pkgctx,'build_txmsg_seunblock');
  END;


  FUNCTION fn_call_txpks_withdraw(json_object IN VARCHAR2) RETURN varchar2 IS
    l_json_data json;
    v_acctno    varchar2(20);
    v_amount    number;
    v_desc      varchar2(2000);
    v_reftxnum  VARCHAR2(10);
    p_err_code    NUMBER(20);
  BEGIN
    plog.setBeginSection(pkgctx, 'fn_call_txpks_withdraw');
    l_json_data := json_parser.parser(json_object);
    v_acctno    := json_ext.get_string(l_json_data, 'accountno', 1);
    v_amount    := TO_NUMBER(json_ext.get_string(l_json_data, 'amount', 1));
    v_desc      := json_ext.get_string(l_json_data, 'description', 1);
    v_reftxnum  := json_ext.get_string(l_json_data, 'fdstxnum', 1);
    build_txmsg_withdraw(v_acctno,v_amount,v_desc,v_reftxnum,p_err_code);
    plog.setendsection(pkgctx, 'fn_call_txpks_withdraw');
    RETURN TO_CHAR(p_err_code);
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || DBMS_UTILITY.format_error_backtrace);
      p_err_code := '-1';
      plog.setendsection(pkgctx, 'fn_call_txpks_withdraw');
  END ;

  FUNCTION fn_call_txpks_seblock(json_object IN VARCHAR2) RETURN varchar2 IS
    l_json_data json;
    l_acctno    varchar2(20);
    l_desc      varchar2(2000);
    l_symbol    VARCHAR2(30);
    l_codeid    VARCHAR2(10) := '';
    l_qtty      NUMBER;
    l_reftxnum  VARCHAR2(20);
    p_err_code    NUMBER(20);
  BEGIN
    plog.setBeginSection(pkgctx, 'fn_call_txpks_seblock');
    l_json_data := json_parser.parser(json_object);
    l_acctno    := json_ext.get_string(l_json_data, 'accountno', 1);
    l_symbol    := json_ext.get_string(l_json_data, 'symbol', 1);
    l_qtty      := TO_NUMBER(json_ext.get_string(l_json_data, 'qtty', 1));
    l_desc      := json_ext.get_string(l_json_data, 'description', 1);
    l_reftxnum  := json_ext.get_string(l_json_data, 'fdstxnum', 1);

    build_txmsg_seblock(l_acctno,l_symbol,l_codeid,l_qtty,l_desc,l_reftxnum,p_err_code);
    plog.setEndSection(pkgctx, 'fn_call_txpks_seblock');
    RETURN p_err_code;
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || DBMS_UTILITY.format_error_backtrace);
      p_err_code := '-1';
      plog.setendsection(pkgctx, 'fn_call_txpks_seblock');
  END;

  FUNCTION fn_call_txpks_deposit(json_object IN VARCHAR2) RETURN varchar2 IS
    l_json_data json;
    v_acctno    VARCHAR2(20);
    v_amount    NUMBER;
    v_desc      VARCHAR2(2000);
    v_reftxnum  VARCHAR2(10);
    p_err_code  NUMBER(20);

  BEGIN
    plog.setBeginSection(pkgctx, 'fn_call_txpks_deposit');
    l_json_data := json_parser.parser(json_object);
    v_acctno    := json_ext.get_string(l_json_data, 'accountno', 1);
    v_amount    := TO_NUMBER(json_ext.get_string(l_json_data, 'amount', 1));
    v_desc      := json_ext.get_string(l_json_data, 'description', 1);
    v_reftxnum  := json_ext.get_string(l_json_data, 'fdstxnum', 1);

    build_txmsg_deposit(v_acctno,v_amount,v_desc,v_reftxnum,p_err_code);
    plog.setEndSection(pkgctx, 'fn_call_txpks_deposit');
    RETURN TO_CHAR(p_err_code);
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || DBMS_UTILITY.format_error_backtrace);
      p_err_code := '-1';
      plog.setendsection(pkgctx, 'fn_call_txpks_deposit');
      RETURN TO_CHAR(p_err_code);
  END;

  FUNCTION fn_call_txpks_sereceive(json_object IN VARCHAR2) RETURN varchar2 IS
    l_json_data  json;
    v_acctno     VARCHAR2(20);
    v_qtty       NUMBER;
    v_desc       VARCHAR2(1000);
    v_reftxnum   VARCHAR2(10);
    v_symbol     VARCHAR2(30);
    p_err_code   NUMBER(20);
  BEGIN
    plog.setBeginSection(pkgctx, 'fn_call_txpks_sereceive');
    l_json_data := json_parser.parser(json_object);
    v_acctno    := json_ext.get_string(l_json_data, 'accountno', 1);
    v_symbol    := json_ext.get_string(l_json_data, 'symbol', 1);
    v_qtty      := TO_NUMBER(json_ext.get_string(l_json_data, 'qtty', 1));
    v_desc      := json_ext.get_string(l_json_data, 'description', 1);
    v_reftxnum  := json_ext.get_string(l_json_data, 'fdstxnum', 1);

    build_txmsg_sereceive(v_acctno,v_symbol,'',0,v_qtty,v_desc,v_reftxnum,p_err_code);

    plog.setEndSection(pkgctx, 'fn_call_txpks_sereceive');
    RETURN TO_CHAR(p_err_code);
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || DBMS_UTILITY.format_error_backtrace);
      plog.setendsection(pkgctx, 'fn_call_txpks_sereceive');
      p_err_code := '-1';
  END;

  FUNCTION fn_call_txpks_setransferIn(json_object IN VARCHAR2) RETURN varchar2 IS
    l_json_data       json;
    v_creditaccountno VARCHAR2(10);
    v_debitaccountno  VARCHAR2(10);
    v_symbol          VARCHAR2(100);
    v_codeid          VARCHAR2(100) := '';
    v_qtty            NUMBER;
    v_desc            VARCHAR2(1000);
    v_reftxnum        VARCHAR2(10);
    p_err_code        VARCHAR2(100);
  BEGIN
    plog.setBeginSection(pkgctx, 'fn_call_txpks_setransferIn');
    l_json_data       := json_parser.parser(json_object);
    v_creditaccountno := json_ext.get_string(l_json_data,'creditaccountno',1);
    v_debitaccountno  := json_ext.get_string(l_json_data,'debitaccountno',1);
    v_symbol          := json_ext.get_string(l_json_data, 'symbol', 1);
    v_qtty            := TO_NUMBER(json_ext.get_string(l_json_data,'qtty',1));
    v_desc            := json_ext.get_string(l_json_data, 'description', 1);
    v_reftxnum        := json_ext.get_string(l_json_data, 'fdstxnum', 1);

    build_txmsg_setransferIn(v_creditaccountno,v_debitaccountno,v_symbol,v_codeid,v_qtty,v_desc,v_reftxnum,p_err_code);

    plog.setEndSection(pkgctx, 'fn_call_txpks_setransferIn');
    RETURN TO_CHAR(p_err_code);
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || DBMS_UTILITY.format_error_backtrace);
      p_err_code := '-1';
      plog.setendsection(pkgctx, 'fn_call_txpks_setransferIn');
  END ;

  FUNCTION fn_call_txpks_setranferout(json_object IN VARCHAR2) RETURN varchar2 IS
    l_json_data json;
    v_acctno    varchar2(20);
    v_symbol    VARCHAR2(30);
    v_qtty      number;
    v_desc      varchar2(1000);
    v_reftxnum  VARCHAR2(10);
    p_err_code  NUMBER(20);
    v_type      VARCHAR2(20);
    v_blockqtty NUMBER(20) := 0;
    v_tradeqtty NUMBER(20) := 0;
  BEGIN
    plog.setBeginSection(pkgctx, 'fn_call_txpks_setranferout');
    l_json_data := json_parser.parser(json_object);
    v_acctno    := json_ext.get_string(l_json_data, 'accountno', 1);
    v_symbol    := json_ext.get_string(l_json_data, 'symbol', 1);
    v_qtty      := TO_NUMBER(json_ext.get_string(l_json_data, 'qtty', 1));
    v_desc      := json_ext.get_string(l_json_data, 'description', 1);
    v_reftxnum  := json_ext.get_string(l_json_data, 'fdstxnum', 1);
    v_type      := json_ext.get_string(l_json_data, 'type', 1);
    IF UPPER(v_type) = 'BLOCK' THEN
      v_blockqtty := v_qtty;
    ELSIF UPPER(v_type) = 'TRADE' THEN
      v_tradeqtty := v_qtty;
    ELSE
      RETURN errnums.C_SYSTEM_ERROR;
    END IF;
    build_txmsg_setranferout(v_acctno,v_symbol,'',v_blockqtty,v_tradeqtty,v_desc,v_reftxnum, p_err_code);

    plog.setEndSection(pkgctx, 'fn_call_txpks_setranferout');
    RETURN TO_CHAR(p_err_code);
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || DBMS_UTILITY.format_error_backtrace);
      p_err_code := '-1';
      plog.setendsection(pkgctx, 'fn_call_txpks_2259');
      RETURN p_err_code;
  END;
  FUNCTION fn_call_txpks_seunblock(json_object IN VARCHAR2) RETURN varchar2 IS
    l_json_data json;
    v_acctno    varchar2(20);
    v_symbol    VARCHAR2(30);
    v_qtty      number;
    v_desc      varchar2(1000);
    v_reftxnum  VARCHAR2(10);
    p_err_code    NUMBER(20);
  BEGIN
    plog.setBeginSection(pkgctx, 'fn_call_txpks_seunblock ');
    l_json_data := json_parser.parser(json_object);
    v_acctno    := json_ext.get_string(l_json_data, 'accountno', 1);
    v_symbol    := json_ext.get_string(l_json_data, 'symbol', 1);
    v_qtty      := TO_NUMBER(json_ext.get_string(l_json_data, 'qtty', 1));
    v_desc      := json_ext.get_string(l_json_data, 'description', 1);
    v_reftxnum  := json_ext.get_string(l_json_data, 'fdstxnum', 1);

    build_txmsg_seunblock(v_acctno,v_symbol,'',v_qtty,v_desc,v_reftxnum,p_err_code);

    plog.setEndSection(pkgctx, 'fn_call_txpks_seunblock');
    RETURN TO_CHAR(p_err_code);
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || DBMS_UTILITY.format_error_backtrace);
      plog.setendsection(pkgctx, 'fn_call_txpks_seunblock');
      p_err_code := '-1';
  END ;
  FUNCTION prc_del_transact(json_object IN VARCHAR2) RETURN varchar2 IS
    l_json_data json;
    v_acctno1    varchar2(20);
    v_acctno2    varchar2(20);
    v_codeid     VARCHAR2(30);
    v_qtty1      number;
    v_qtty2      number;
    v_amt        number;
    v_desc       varchar2(1000);
    v_reftxnum   VARCHAR2(10);
    p_err_code    NUMBER(20);
  BEGIN
    plog.setBeginSection(pkgctx, 'prc_del_transact');
    l_json_data := json_parser.parser(json_object);
    v_desc      := json_ext.get_string(l_json_data, 'description', 1);
    v_reftxnum  := json_ext.get_string(l_json_data, 'fdstxnum', 1);
    p_err_code := 0;
    FOR rec IN
    (
      SELECT tltxcd, txnum
        FROM tllog t
       WHERE reftxnum = v_reftxnum
         AND txstatus = '1'
         AND NOT EXISTS (SELECT 1 FROM tllog WHERE reftxnum = t.txnum)
    ) LOOP
      IF rec.tltxcd = '1179' THEN -- Rut Tien Ky Quy
        SELECT MAX(DECODE(fldcd,'03',cvalue,'')),
               MAX(DECODE(fldcd,'10',nvalue,''))
          INTO v_acctno1, v_amt
          FROM tllogfld
         WHERE txnum = rec.txnum;
         build_txmsg_withdraw(v_acctno1,v_amt,v_desc,rec.txnum,p_err_code);
      ELSIF rec.tltxcd = '1170' THEN -- Nop Ky Quy
        SELECT MAX(DECODE(fldcd,'03',cvalue,'')),
               MAX(DECODE(fldcd,'10',nvalue,''))
          INTO v_acctno1,v_amt
          FROM tllogfld
         WHERE txnum = rec.txnum;
         build_txmsg_deposit(v_acctno1,v_amt,v_desc,rec.txnum,p_err_code);
      ELSIF rec.tltxcd = '2259' THEN -- Chuyen Khoan CK Ra Ngoai
        SELECT MAX(DECODE(fldcd,'02',cvalue,'')),
               MAX(DECODE(fldcd,'01',cvalue,'')),
               MAX(DECODE(fldcd,'10',nvalue,'')),
               MAX(DECODE(fldcd,'06',nvalue,''))
          INTO v_acctno1,v_codeid, v_qtty1, v_qtty2
          FROM tllogfld
         WHERE txnum = rec.txnum;
         build_txmsg_sereceive( v_acctno1,'',v_codeid,v_qtty2,v_qtty1,v_desc,rec.txnum,p_err_code);
      ELSIF rec.tltxcd = '2202' THEN -- Phong Toa CK
        SELECT MAX(DECODE(fldcd,'02',cvalue,'')),
               MAX(DECODE(fldcd,'01',cvalue,'')),
               MAX(DECODE(fldcd,'10',nvalue,''))
          INTO v_acctno1,v_codeid,v_qtty1
          FROM tllogfld
         WHERE txnum = rec.txnum;
        build_txmsg_seunblock(v_acctno1,'',v_codeid,v_qtty1,v_desc,rec.txnum,p_err_code);
      ELSIF rec.tltxcd = '2205' THEN
        SELECT MAX(DECODE(fldcd,'02',cvalue,'')),
               MAX(DECODE(fldcd,'01',cvalue,'')),
               MAX(DECODE(fldcd,'10',nvalue,''))
          INTO v_acctno1, v_codeid, v_qtty1
          FROM tllogfld
         WHERE txnum = rec.txnum;
        build_txmsg_seblock(v_acctno1,'',v_codeid,v_qtty1,v_desc,rec.txnum,p_err_code);
      ELSIF rec.tltxcd = '2245' THEN -- Nhan CK Ky Quy, Nhan CK Thanh Toan
        SELECT MAX(DECODE(fldcd,'04',cvalue,'')),
               MAX(DECODE(fldcd,'01',cvalue,'')),
               MAX(DECODE(fldcd,'10',nvalue,'')),
               MAX(DECODE(fldcd,'06',nvalue,''))
          INTO v_acctno1,v_codeid,v_qtty1,v_qtty2
          FROM tllogfld
         WHERE txnum = rec.txnum;
        build_txmsg_setranferout(v_acctno1,'',v_codeid,v_qtty2,v_qtty1,v_desc,rec.txnum,p_err_code);
      ELSIF rec.tltxcd = '2242' THEN -- Chuyen Khoan Noi Bo
        SELECT MAX(DECODE(fldcd,'02',cvalue,'')),
               MAX(DECODE(fldcd,'04',cvalue,'')),
               MAX(DECODE(fldcd,'01',cvalue,'')),
               MAX(DECODE(fldcd,'10',nvalue,''))
          INTO v_acctno1,v_acctno2,v_codeid,v_qtty1
          FROM tllogfld
         WHERE txnum = rec.txnum;
        build_txmsg_setransferIn(v_acctno2,v_acctno1,'',v_codeid,v_qtty1,v_desc,rec.txnum,p_err_code);
      END IF;
      IF p_err_code <> systemnums.C_SUCCESS THEN
        plog.error(pkgctx,'Error Del transact tltxcd=' || rec.tltxcd || ' txnum=' || rec.txnum);
        plog.setEndSection(pkgctx, 'prc_del_transact');
        RETURN p_err_code;
      END IF;
    END LOOP;
    RETURN p_err_code;
    plog.setEndSection(pkgctx, 'prc_del_transact');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || DBMS_UTILITY.format_error_backtrace);
      p_err_code := '-1';
      plog.setEndSection(pkgctx, 'prc_del_transact');
      RETURN p_err_code;
  END ;

  /*PROCEDURE pr_gen_bank_request (p_txdate    VARCHAR2,
                                 p_txnum     VARCHAR2,
                                 p_tltxcd    VARCHAR2,
                                 p_afAcctno  VARCHAR2,
                                 p_amount    NUMBER,
                                 p_desc      VARCHAR2,
                                 pv_err_code IN OUT VARCHAR2)
  IS
    l_reqId         crbtxreq.reqid%TYPE;
    l_bankAccount   VARCHAR2(1000);
    l_bankCode      VARCHAR2(1000);
    l_txDate        DATE;
    v_VALUE       VARCHAR2(1000);
    v_extCMDSQL   VARCHAR2(5000);
    TYPE v_CurType  IS REF CURSOR;
    c0             v_CurType;
  BEGIN
    plog.setBeginSection (pkgctx, 'pr_gen_bank_request');
    l_reqId := seq_crbtxreq.nextval;
    l_txDate := TO_DATE(p_txdate, systemnums.C_DATE_FORMAT);
    FOR rec IN (
      SELECT * FROM CRBTXMAP crb
      WHERE objname = p_tltxcd
    ) LOOP
      BEGIN
        SELECT def.refacctno, af.bankname INTO l_bankAccount, l_bankCode
        FROM crbdefacct def, afmast af
        WHERE def.REFBANK = af.bankname
        AND trfcode = rec.trfcode AND af.acctno = p_afAcctno
        ;
      EXCEPTION
        WHEN OTHERS THEN
          l_bankAccount := '';
      END;
      IF l_bankAccount IS NOT NULL AND length(l_bankAccount) > 0 THEN
        INSERT INTO CRBTXREQ (REQID, OBJTYPE, OBJNAME, OBJKEY, TRFCODE, REFCODE,
                              TXDATE, AFFECTDATE, AFACCTNO, TXAMT, BANKCODE,
                              BANKACCT, STATUS, REFVAL, NOTES)
        VALUES (l_reqId, 'T', p_tltxcd, p_txnum, rec.trfcode, p_txdate || p_txnum,
                l_txDate, l_txDate, p_afAcctno, p_amount, l_bankCode, l_bankAccount, 'P', NULL, p_desc);
      END IF;
      FOR rc IN (
        SELECT * FROM crbtxmapext c WHERE OBJTYPE ='T'
                AND c.OBJNAME = rec.objname AND TRFCODE = rec.TRFCODE
      ) LOOP
        BEGIN
            IF NOT rc.AMTEXP IS NULL THEN
              v_VALUE := FN_EVAL_AMTEXP(p_txnum, p_txdate, rc.AMTEXP);
            END IF;
            IF NOT rc.CMDSQL IS NULL THEN
                BEGIN
                  v_extCMDSQL := REPLACE(rc.CMDSQL, '<$FILTERID>', v_VALUE);
                  BEGIN
                      OPEN c0 FOR v_extCMDSQL;
                      FETCH c0 INTO v_VALUE;
                      CLOSE c0;
                  EXCEPTION
                    WHEN OTHERS THEN
                        v_VALUE:='0';
                        plog.error(pkgctx,'Khong lay duoc gia tri tren cau lenh select dong : SQL-' || v_extCMDSQL);
                  END;
                END;
            END IF;

            INSERT INTO CRBTXREQDTL (AUTOID, REQID, FLDNAME, CVAL, NVAL)
              SELECT SEQ_CRBTXREQDTL.NEXTVAL, l_reqId, rc.FLDNAME,
              DECODE(rc.FLDTYPE, 'N', NULL, TO_CHAR(v_VALUE)),
              DECODE(rc.FLDTYPE, 'N', v_VALUE, 0) FROM DUAL;
        END;
      END LOOP;
    END LOOP;
    plog.setEndSection (pkgctx, 'pr_gen_bank_request');
  EXCEPTION
    WHEN OTHERS THEN
      pv_err_code := errnums.C_SYSTEM_ERROR;
      plog.setEndSection(pkgctx, 'pr_gen_bank_request');
  END;*/
BEGIN
  --get current schema
  SELECT SYS_CONTEXT('userenv', 'current_schema')
    INTO ownerschema
    FROM DUAL;

  databaseCache := false;

  FOR i IN (SELECT * FROM tlogdebug) LOOP
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  END LOOP;

  pkgctx := plog.init('pck_fds_api',
                      plevel     => NVL(logrow.loglevel, 30),
                      plogtable  => (NVL(logrow.log4table, 'Y') = 'Y'),
                      palert     => (logrow.log4alert = 'Y'),
                      ptrace     => (logrow.log4trace = 'Y'));

END;
/
