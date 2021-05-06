CREATE OR REPLACE PACKAGE TXPKS_#1118EX
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1118EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      20/05/2019     Created
 **
 ** (c) 2008 by Financial Software Solutions. JSC.
 ** ----------------------------------------------------------------------------------------------------*/
IS
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
END;
/
CREATE OR REPLACE PACKAGE BODY TXPKS_#1118EX
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_autoid           CONSTANT CHAR(2) := '01';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_afacctno         CONSTANT CHAR(2) := '02';
   c_fullname         CONSTANT CHAR(2) := '31';
   c_amount           CONSTANT CHAR(2) := '14';
   c_advamt           CONSTANT CHAR(2) := '15';
   c_cashamt          CONSTANT CHAR(2) := '16';
   c_totaladvam       CONSTANT CHAR(2) := '17';
   c_totalcasham      CONSTANT CHAR(2) := '18';
   c_action           CONSTANT CHAR(2) := '19';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
   v_count	    NUMBER;
   v_trfCount	  NUMBER;
BEGIN
   plog.setbeginsection (pkgctx, 'fn_txPreAppCheck');
   plog.debug(pkgctx,'BEGIN OF fn_txPreAppCheck');
   /***************************************************************************************************
    * PUT YOUR SPECIFIC RULE HERE, FOR EXAMPLE:
    * IF NOT <<YOUR BIZ CONDITION>> THEN
    *    p_err_code := '<<ERRNUM>>'; -- Pre-defined in DEFERROR table
    *    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    *    RETURN errnums.C_BIZ_RULE_INVALID;
    * END IF;
    ***************************************************************************************************/
    -- Yeu cau phai o trang thai cho xu ly
    SELECT COUNT(autoid) INTO v_count
    FROM extranferreq
    WHERE autoid = p_txmsg.txfields(c_autoid).value AND status = 'P';

    IF v_count = 0 THEN
       p_err_code := '-400126'; -- Pre-defined in DEFERROR table
       plog.setendsection (pkgctx, 'fn_txPreAppCheck');
       RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;
    -- Check trang thai tieu khoan
    SELECT COUNT(acctno) INTO v_count
    FROM afmast WHERE acctno = p_txmsg.txfields(c_afacctno).value AND status NOT IN ('C', 'N');

    IF v_count = 0 THEN
       p_err_code := '-200010'; -- Pre-defined in DEFERROR table
       plog.setendsection (pkgctx, 'fn_txPreAppCheck');
       RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;
    -- Neu la Duyet thi kiem tra lai so lan thuc hien theo han muc
    IF p_txmsg.txfields(c_action).value = 'A' THEN
       BEGIN
          SELECT trf.maxtrfcnt INTO v_trfCount
          FROM cftrflimit trf, afmast af
          WHERE trf.custid = af.custid AND trf.status = 'A'
          AND af.acctno = p_txmsg.txfields(c_afacctno).value;
       EXCEPTION WHEN OTHERS THEN
          v_trfCount := 0;
       END;

       SELECT COUNT(1) INTO v_count
       FROM tllog
       WHERE tltxcd = '1101' AND tlid = systemnums.C_ONLINE_USERID
       AND deltd <> 'Y' AND txstatus ='1'
       AND msgacct IN (
          SELECT af2.acctno FROM afmast af1, afmast af2
          WHERE af1.custid = af2.custid AND af1.acctno = p_txmsg.txfields(c_afacctno).value
       );

       IF v_count >= v_trfCount THEN
          p_err_code := '-100131'; -- Pre-defined in DEFERROR table
          plog.setendsection (pkgctx, 'fn_txPreAppCheck');
          RETURN errnums.C_BIZ_RULE_INVALID;
       END IF;
    END IF;
    plog.debug (pkgctx, '<<END OF fn_txPreAppCheck');
    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'fn_txPreAppCheck');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txPreAppCheck;

FUNCTION fn_txAftAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
BEGIN
   plog.setbeginsection (pkgctx, 'fn_txAftAppCheck');
   plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppCheck>>');
   /***************************************************************************************************
    * PUT YOUR SPECIFIC RULE HERE, FOR EXAMPLE:
    * IF NOT <<YOUR BIZ CONDITION>> THEN
    *    p_err_code := '<<ERRNUM>>'; -- Pre-defined in DEFERROR table
    *    plog.setendsection (pkgctx, 'fn_txAftAppCheck');
    *    RETURN errnums.C_BIZ_RULE_INVALID;
    * END IF;
    ***************************************************************************************************/
   plog.debug (pkgctx, '<<END OF fn_txAftAppCheck>>');
   plog.setendsection (pkgctx, 'fn_txAftAppCheck');
   RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'fn_txAftAppCheck');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAftAppCheck;

FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txPreAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txPreAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC PROCESS HERE. . DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    plog.debug (pkgctx, '<<END OF fn_txPreAppUpdate');
    plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
       plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txPreAppUpdate;

FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
   l_txmsg       tx.msg_rectype;
   l_err_param   VARCHAR2(300);
   v_feetype     VARCHAR2(10);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF p_txmsg.txfields(c_action).value <> 'A' THEN
       UPDATE extranferreq SET status = 'R', aprvid = p_txmsg.tlid
       WHERE autoid = p_txmsg.txfields(c_autoid).value;
    ELSE
       FOR i IN (
           SELECT req.*, cf.idcode, to_char(cf.iddate,'DD/MM/YYYY') iddate, cf.idplace,
                  cf.custodycd, cf.fullname, cfo.citybank, cfo.cityef
           FROM extranferreq req, afmast af, cfmast cf, cfotheracc cfo
           WHERE req.autoid = p_txmsg.txfields(c_autoid).value
             AND req.afacctno = af.acctno
             AND af.custid = cf.custid
             AND cfo.afacctno = req.afacctno
             AND cfo.bankacc = req.benefacct
       ) LOOP
          l_txmsg.msgtype := 'T';
          l_txmsg.local   := 'N';
          l_txmsg.tlid    := systemnums.C_ONLINE_USERID;

          SELECT SYS_CONTEXT('USERENV', 'HOST'), SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15)
          INTO l_txmsg.wsname, l_txmsg.ipaddress FROM DUAL;

          l_txmsg.ipaddress := nvl(i.ipaddress, l_txmsg.ipaddress);
          l_txmsg.off_line    := 'N';
          l_txmsg.deltd       := txnums.c_deltd_txnormal;
          l_txmsg.txstatus    := txstatusnums.c_txcompleted;
          l_txmsg.msgsts      := '0';
          l_txmsg.ovrsts      := '0';
          l_txmsg.batchname   := 'INT';
          l_txmsg.txdate      := p_txmsg.txdate;
          l_txmsg.busdate     := p_txmsg.busdate;
          l_txmsg.tltxcd      := '1101';
          l_txmsg.brid        := substr(i.afacctno, 1, 4);
          --Set txnum
          SELECT systemnums.C_OL_PREFIXED || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
          INTO l_txmsg.txnum FROM DUAL;

          --03   ACCTNO          C
          l_txmsg.txfields ('03').defname   := 'ACCTNO';
          l_txmsg.txfields ('03').TYPE      := 'C';
          l_txmsg.txfields ('03').VALUE     := i.afacctno;
          --05   BANKID          C
          l_txmsg.txfields ('05').defname   := 'BANKID';
          l_txmsg.txfields ('05').TYPE      := 'C';
          l_txmsg.txfields ('05').VALUE     := i.bankid;
          --09   IORO            C
          l_txmsg.txfields ('09').defname   := 'IORO';
          l_txmsg.txfields ('09').TYPE      := 'C';
          l_txmsg.txfields ('09').VALUE     := 0;
          --10   TRFAMT          N
          l_txmsg.txfields ('10').defname   := 'TRFAMT';
          l_txmsg.txfields ('10').TYPE      := 'N';
          l_txmsg.txfields ('10').VALUE     := round(i.amount,0)- round(i.feeamt,0)- round(i.vatamt,0);
          --11   FEEAMT          N
          l_txmsg.txfields ('11').defname   := 'FEEAMT';
          l_txmsg.txfields ('11').TYPE      := 'N';
          l_txmsg.txfields ('11').VALUE     := round(i.feeamt,0);
          --12   VATAMT          N
          l_txmsg.txfields ('12').defname   := 'VATAMT';
          l_txmsg.txfields ('12').TYPE      := 'N';
          l_txmsg.txfields ('12').VALUE     := round(i.vatamt,0);
          --13   AMT             N
          l_txmsg.txfields ('13').defname   := 'AMT';
          l_txmsg.txfields ('13').TYPE      := 'N';
          l_txmsg.txfields ('13').VALUE     := round(i.amount,0);
          --30   DESC            C
          l_txmsg.txfields ('30').defname   := 'DESC';
          l_txmsg.txfields ('30').TYPE      := 'C';
          l_txmsg.txfields ('30').VALUE     := i.txdesc;
          --64   FULLNAME        C
          l_txmsg.txfields ('64').defname   := 'FULLNAME';
          l_txmsg.txfields ('64').TYPE      := 'C';
          l_txmsg.txfields ('64').VALUE     := '';
          --65   ADDRESS        C
          l_txmsg.txfields ('65').defname   := 'ADDRESS';
          l_txmsg.txfields ('65').TYPE      := 'C';
          l_txmsg.txfields ('65').VALUE     := '';
          --67   IDDATE        C
          l_txmsg.txfields ('67').defname   := 'IDDATE';
          l_txmsg.txfields ('67').TYPE      := 'C';
          l_txmsg.txfields ('67').VALUE     := i.iddate;
          --68   IDPLACE        C
          l_txmsg.txfields ('68').defname   := 'IDPLACE';
          l_txmsg.txfields ('68').TYPE      := 'C';
          l_txmsg.txfields ('68').VALUE     := i.idplace;
          --69   LICENSE        C
          l_txmsg.txfields ('69').defname   := 'LICENSE';
          l_txmsg.txfields ('69').TYPE      := 'C';
          l_txmsg.txfields ('69').VALUE     := i.idcode;
          --80   BENEFBANK       C --Ten ngan hang thu huong
          l_txmsg.txfields ('80').defname   := 'BENEFBANK';
          l_txmsg.txfields ('80').TYPE      := 'C';
          l_txmsg.txfields ('80').VALUE     := i.benefbank;
          --81   BENEFACCT       C --So tai khoan thu huong
          l_txmsg.txfields ('81').defname   := 'BENEFACCT';
          l_txmsg.txfields ('81').TYPE      := 'C';
          l_txmsg.txfields ('81').VALUE     := i.benefacct;
          --82   BENEFCUSTNAME   C
          l_txmsg.txfields ('82').defname   := 'BENEFCUSTNAME';
          l_txmsg.txfields ('82').TYPE      := 'C';
          l_txmsg.txfields ('82').VALUE     := i.benefcustname;
          --83   BENEFLICENSE    C
          l_txmsg.txfields ('83').defname   := 'BENEFLICENSE';
          l_txmsg.txfields ('83').TYPE      := 'C';
          l_txmsg.txfields ('83').VALUE     := i.beneflicense;
          --84   CITYBANK    C
          l_txmsg.txfields ('84').defname   := 'CITYBANK';
          l_txmsg.txfields ('84').TYPE      := 'C';
          l_txmsg.txfields ('84').VALUE     := i.citybank;
          --85   CITYEF    C
          l_txmsg.txfields ('85').defname   := 'CITYEF';
          l_txmsg.txfields ('85').TYPE      := 'C';
          l_txmsg.txfields ('85').VALUE     := i.CITYEF;
          --88   CUSTODYCD   C
          l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
          l_txmsg.txfields ('88').TYPE      := 'C';
          l_txmsg.txfields ('88').VALUE     := '';
          --89   AVLCASH         N
          l_txmsg.txfields ('89').defname   := 'AVLCASH';
          l_txmsg.txfields ('89').TYPE      := 'N';
          l_txmsg.txfields ('89').VALUE     := 0;
          --90   CUSTNAME        C
          l_txmsg.txfields ('90').defname   := 'CUSTNAME';
          l_txmsg.txfields ('90').TYPE      := 'C';
          l_txmsg.txfields ('90').VALUE     := '';
          --95   BENEFIDDATE     C
          l_txmsg.txfields ('95').defname   := 'BENEFIDDATE';
          l_txmsg.txfields ('95').TYPE      := 'C';
          l_txmsg.txfields ('95').VALUE     := '';
          --96   BENEFIDPLACE    C
          l_txmsg.txfields ('96').defname   := 'BENEFIDPLACE';
          l_txmsg.txfields ('96').TYPE      := 'C';
          l_txmsg.txfields ('96').VALUE     := '';
          --97   LICENSE    C
          l_txmsg.txfields ('97').defname   := 'BANK_ORG_NO';
          l_txmsg.txfields ('97').TYPE      := 'C';
          l_txmsg.txfields ('97').VALUE     := '';
          --66   FEECD    C
          l_txmsg.txfields ('66').defname   := '$FEECD';
          l_txmsg.txfields ('66').TYPE      := 'C';
          l_txmsg.txfields ('66').VALUE     := '';
          --79   REFID    C
          l_txmsg.txfields ('79').defname   := 'REFID';
          l_txmsg.txfields ('79').TYPE      := 'C';
          l_txmsg.txfields ('79').VALUE     := '';
          --00   AUTOID    C
          l_txmsg.txfields ('00').defname   := 'AUTOID';
          l_txmsg.txfields ('00').TYPE      := 'C';
          l_txmsg.txfields ('00').VALUE     := '';
          -- Ducnv them phi
          If i.bankid like '302%'  or i.bankid like '202%' or i.bankid like '309%' then
             v_feetype:='00016';
          ELSE
             if to_number(i.amount) < 500000000 then
                v_feetype:='00017';
             else
                v_feetype:= '20000';
             end if;
          End if;

          l_txmsg.txfields ('35').defname   := 'FEETYPE';
          l_txmsg.txfields ('35').TYPE      := 'C';
          l_txmsg.txfields ('35').VALUE     := v_feetype;

          l_txmsg.txfields ('15').defname   := 'FEEAMT';
          l_txmsg.txfields ('15').TYPE      := 'N';
          l_txmsg.txfields ('15').VALUE     := fn_gettransfermoneyfee(i.amount, v_feetype);

          l_txmsg.txfields ('16').defname   := 'TOTALAMT';
          l_txmsg.txfields ('16').TYPE      := 'N';
          l_txmsg.txfields ('16').VALUE     := i.amount + fn_gettransfermoneyfee(i.amount, v_feetype);

          BEGIN
             IF txpks_#1101.fn_autotxprocess (l_txmsg, p_err_code, l_err_param ) <> systemnums.c_success THEN
                plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
             END IF;
             --ThanhNV sua them doan check FO, neu giao dich duoi FO khong thanh cong cung rollback.
             PCK_SYN2FO.PRC_CHECK_SYN2FO(l_txmsg.txnum,  p_err_code, l_err_param);
             IF p_err_code <> systemnums.c_success THEN
                plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
             END IF;
          END;
          --1.5.3.0
          pr_insertiplog( l_txmsg.txnum,  l_txmsg.txdate, i.ipaddress, i.via, i.validationtype, i.devicetype, i.device, p_err_code);
          --
          --1.6.0.0 : Update trạng thái và so tien han muc con lai duoc duyet
          UPDATE extranferreq SET status = 'A', aprvid = p_txmsg.txfields(20).value
          WHERE autoid = p_txmsg.txfields(c_autoid).value;

          UPDATE tlemaillimit tl
          SET tl.readvancelimit=tl.readvancelimit-p_txmsg.txfields(15).value,
              tl.retotaltranlimit=tl.retotaltranlimit-p_txmsg.txfields(16).value
          WHERE tl.tlid=p_txmsg.txfields(20).value;

       END LOOP;
    END IF;
    plog.debug (pkgctx, '<<END OF fn_txAftAppUpdate');
    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
       plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAftAppUpdate;

BEGIN
      FOR i IN (SELECT *
                FROM tlogdebug)
      LOOP
         logrow.loglevel    := i.loglevel;
         logrow.log4table   := i.log4table;
         logrow.log4alert   := i.log4alert;
         logrow.log4trace   := i.log4trace;
      END LOOP;
      pkgctx    :=
         plog.init ('TXPKS_#1118EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1118EX;
/
