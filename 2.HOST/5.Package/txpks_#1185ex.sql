CREATE OR REPLACE PACKAGE txpks_#1185ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1185EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      19/02/2013     Created
 **
 ** (c) 2008 by Financial Software Solutions. JSC.
 ** ----------------------------------------------------------------------------------------------------*/
IS
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppCheck(p_txmsg in out tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
END;
/

CREATE OR REPLACE PACKAGE BODY txpks_#1185ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_autoid           CONSTANT CHAR(2) := '00';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_acctno           CONSTANT CHAR(2) := '03';
   c_custname         CONSTANT CHAR(2) := '90';
   c_fullname         CONSTANT CHAR(2) := '64';
   c_address          CONSTANT CHAR(2) := '65';
   c_license          CONSTANT CHAR(2) := '69';
   c_iddate           CONSTANT CHAR(2) := '67';
   c_idplace          CONSTANT CHAR(2) := '68';
   c_ioro             CONSTANT CHAR(2) := '09';
   c_$feecd           CONSTANT CHAR(2) := '66';
   c_castbal          CONSTANT CHAR(2) := '89';
   c_amt              CONSTANT CHAR(2) := '10';
   c_feeamt           CONSTANT CHAR(2) := '11';
   c_vatamt           CONSTANT CHAR(2) := '12';
   c_trfamt           CONSTANT CHAR(2) := '13';
   c_benefcustname    CONSTANT CHAR(2) := '82';
   c_benefacct        CONSTANT CHAR(2) := '81';
   c_receividplace    CONSTANT CHAR(2) := '96';
   c_receivlicense    CONSTANT CHAR(2) := '83';
   c_receividdate     CONSTANT CHAR(2) := '95';
   c_refid            CONSTANT CHAR(2) := '79';
   c_bankid           CONSTANT CHAR(2) := '05';
   c_benefbank        CONSTANT CHAR(2) := '80';
   c_citybank         CONSTANT CHAR(2) := '84';
   c_cityef           CONSTANT CHAR(2) := '85';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
v_count NUMBER;
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
     --Check co cap han muc bao lanh thi ko duoc rut tien
    SELECT nvl(count(*),0)   INTO v_count  FROM afmast WHERE advanceline>0 AND acctno =p_txmsg.txfields('03').value;
    IF v_count>0 THEN
        p_err_code := '-100148'; -- Pre-defined in DEFERROR table
        RETURN errnums.C_BIZ_RULE_INVALID;
      END IF ;

    IF p_txmsg.txfields('89').value < p_txmsg.txfields('16').value THEN
       p_err_code := '-400110'; -- Pre-defined in DEFERROR table
       RETURN errnums.C_BIZ_RULE_INVALID;
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

FUNCTION fn_txAftAppCheck(p_txmsg in out tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    v_strCHKRQS char(1);
    l_lngErrCode number(20,0);
    l_err_param varchar2(1000);
    l_strOVRRQD varchar2(100);
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

   SELECT OVRRQD INTO v_strCHKRQS FROM TLTX WHERE TLTXCD = '1185';

    plog.debug (pkgctx, 'OVRRQD : ' || v_strCHKRQS);

    if v_strCHKRQS <> 'Y' then
        if (p_txmsg.txfields('25').value = 'T' AND p_txmsg.txfields('26').value = 'Y') or (p_txmsg.txfields('25').value = 'F' AND p_txmsg.txfields('27').value = 'Y') then
            l_strOVRRQD := l_strOVRRQD || errnums.OVRRQS_CHECKER_CONTROL;
            p_txmsg.ovrrqd := l_strOVRRQD;
        end if;
    end if;

    plog.debug (pkgctx, 'l_strOVRRQD : ' || l_strOVRRQD || ' p_txmsg.chkid: ' || p_txmsg.chkid);

    If length(Trim(Replace(l_strOVRRQD, errnums.OVRRQS_CHECKER_CONTROL, ''))) > 0 And (length(p_txmsg.chkid) = 0 or p_txmsg.chkid is null) Then
        p_err_code :=errnums.C_CHECKER1_REQUIRED;
    Else
        If InStr(l_strOVRRQD, errnums.OVRRQS_CHECKER_CONTROL) > 0 And (Length(p_txmsg.offid)  = 0 or p_txmsg.offid is null) Then
            p_err_code :=errnums.C_CHECKER2_REQUIRED;
        End If;
    End If;

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
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF CSPKS_CIPROC.fn_GenRemittanceTrans(p_txmsg,p_err_code) <> systemnums.C_SUCCESS THEN
       RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;

    plog.debug (pkgctx, 'p_txmsg.txstatus END: ' || p_txmsg.txstatus);

    if p_txmsg.deltd <> 'Y' then
          INSERT INTO cirewithdraw (TLTXCD, TXDATE, TXNUM, ACCTNO,BANKID, BENEFBANK, BENEFACCT, BENEFCUSTNAME, BENEFLICENSE, AMT, FEEAMT, DELTD, RMSTATUS,
        BENEFIDDATE, BENEFIDPLACE,FEETYPE,CITYEF, CITYBANK)
        VALUES (p_txmsg.tltxcd, TO_DATE(p_txmsg.txdate,systemnums.c_date_format), p_txmsg.txnum,p_txmsg.txfields('03').value,
        p_txmsg.txfields('05').value,p_txmsg.txfields('80').value,
        p_txmsg.txfields('81').value,p_txmsg.txfields('82').value,
        p_txmsg.txfields('69').value,p_txmsg.txfields('10').value,p_txmsg.txfields('15').value,'N', 'P',
        TO_DATE(p_txmsg.txfields('67').value,systemnums.c_date_format),p_txmsg.txfields('68').value,'0',
        p_txmsg.txfields('85').value,p_txmsg.txfields('84').value);
    else
        delete cirewithdraw WHERE TXNUM = p_txmsg.txnum AND TXDATE = p_txmsg.txdate;
    end if;
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
         plog.init ('TXPKS_#1185EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1185EX;
/

