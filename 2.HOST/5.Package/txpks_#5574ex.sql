CREATE OR REPLACE PACKAGE txpks_#5574ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#5574EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      02/11/2011     Created
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

CREATE OR REPLACE PACKAGE BODY txpks_#5574ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_autoid           CONSTANT CHAR(2) := '01';
   c_afacctno         CONSTANT CHAR(2) := '04';
   c_acctno           CONSTANT CHAR(2) := '03';
   c_custodycd        CONSTANT CHAR(2) := '02';
   c_custname         CONSTANT CHAR(2) := '14';
   c_overduedate      CONSTANT CHAR(2) := '90';
   c_todate           CONSTANT CHAR(2) := '05';
   c_productname      CONSTANT CHAR(2) := '13';
   c_desc             CONSTANT CHAR(2) := '30';
   c_rlsdate          CONSTANT CHAR(2) := '91';
   c_prinperiod       CONSTANT CHAR(2) := '92';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS

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
    plog.debug (pkgctx, '<<END OF fn_txPreAppCheck');
    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'fn_txPreAppCheck');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txPreAppCheck;

FUNCTION fn_txAftAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    l_strTmpDate  Varchar2(20);
    l_count NUMBER(4);
    l_MarginAllow Char(1);
    l_MaxDebtDays NUMBER(4);
    l_MaxTotalDebtDays NUMBER(4);
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
    --Check ngay gia han khong duoc be hon ngay hien tai
    IF p_txmsg.txdate >= TO_DATE(p_txmsg.txfields(c_todate).VALUE, 'DD/MM/RRRR')  THEN
        p_err_code := '-540214';
        plog.setendsection (pkgctx, 'fn_txAftAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;

    --Check ngay den han ko be hon hay bang ngay den han cu
    IF TO_DATE(p_txmsg.txfields(c_overduedate).VALUE, 'DD/MM/RRRR') >= TO_DATE(p_txmsg.txfields(c_todate).VALUE, 'DD/MM/RRRR')  THEN
        p_err_code := '-540219';
        plog.setendsection (pkgctx, 'fn_txAftAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;

    --Check isWorkingDay
    select COUNT(sbcldr.holiday) into l_count from sbcldr where sbdate =  TO_DATE( p_txmsg.txfields(c_todate).VALUE ,'DD/MM/RRRR' )and  sbcldr.holiday  = 'Y';
    IF l_count > 0 THEN
        p_err_code := '-540212';
        plog.setendsection (pkgctx, 'fn_txAftAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;

    --If LNACCTNO is CHKSYSCTRL = Y then
    select count(1) into l_count from lnmast ln, lntype lnt where ln.actype = lnt.actype and ln.acctno = p_txmsg.txfields(c_acctno).VALUE and chksysctrl = 'Y';
    if l_count > 0 then
        --Check Margin Allow
        SELECT SYS.VARVALUE INTO l_MarginAllow FROM SYSVAR SYS WHERE GRNAME = 'MARGIN'  AND VARNAME = 'MARGINALLOW';
        IF l_MarginAllow <> 'Y' THEN
                p_err_code := '-200099';
                plog.setendsection (pkgctx, 'fn_txAftAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;

        SELECT to_number(VARVALUE) INTO l_MaxDebtDays FROM SYSVAR WHERE GRNAME = 'MARGIN' AND VARNAME = 'MAXDEBTDAYS' ;
        SELECT to_number(VARVALUE) INTO l_MaxTotalDebtDays FROM SYSVAR WHERE GRNAME = 'MARGIN' AND VARNAME = 'MAXTOTALDEBTDAYS';

        --Check MaxDebtDays
        IF to_number(TO_DATE(p_txmsg.txfields(c_todate).VALUE  ,'DD/MM/RRRR') - TO_DATE( p_txmsg.txfields(c_overduedate).VALUE ,'DD/MM/RRRR')) > l_MaxDebtDays THEN
            p_err_code := '-540217';
            plog.setendsection (pkgctx, 'fn_txAftAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;

        --Check MaxTotalDebtDays
        --select count(*) DAYS INTO l_MaxTotalDebtDays from sbcldr where sbdate BETWEEN TO_DATE(p_txmsg.txfields(c_rlsdate).VALUE ,'DD/MM/RRRR') and TO_DATE(p_txmsg.txfields(c_todate).VALUE ,'DD/MM/RRRR') and cldrtype = '000';
        IF to_number(TO_DATE(p_txmsg.txfields(c_todate).VALUE ,'DD/MM/RRRR') - TO_DATE(p_txmsg.txfields(c_rlsdate).VALUE ,'DD/MM/RRRR')) > l_MaxTotalDebtDays THEN
            p_err_code := '-540218';
            plog.setendsection (pkgctx, 'fn_txAftAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;
    end if;

    --Check ngay gia han moi phai lon hon ngay het han cua deal
    IF TO_DATE( p_txmsg.txfields(c_todate).VALUE,'DD/MM/RRRR') - TO_DATE(p_txmsg.txfields(c_overduedate).VALUE  ,'DD/MM/RRRR') <= 0 THEN
        p_err_code := '-540219';
        plog.setendsection (pkgctx, 'fn_txAftAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;


   plog.debug (pkgctx, '<<END OF fn_txAftAppCheck>>');
   plog.setendsection (pkgctx, 'fn_txAftAppCheck');
   RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
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
      plog.error (pkgctx, SQLERRM);
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
    UPDATE LNSCHD
    SET OVERDUEDATE = TO_DATE(p_txmsg.txfields(c_todate).VALUE ,'DD/MM/RRRR')
    WHERE AUTOID = p_txmsg.txfields(c_autoid).VALUE;

    plog.debug (pkgctx, '<<END OF fn_txAftAppUpdate');
    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
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
         plog.init ('TXPKS_#5574EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#5574EX;
/

