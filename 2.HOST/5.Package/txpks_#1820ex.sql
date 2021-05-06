CREATE OR REPLACE PACKAGE txpks_#1820ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1820EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      09/07/2012     Created
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

CREATE OR REPLACE PACKAGE BODY txpks_#1820ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_custodycd        CONSTANT CHAR(2) := '88';
   c_applid           CONSTANT CHAR(2) := '03';
   c_custname         CONSTANT CHAR(2) := '05';
   c_idcode           CONSTANT CHAR(2) := '06';
   c_omrirate         CONSTANT CHAR(2) := '14';
   c_omriratio        CONSTANT CHAR(2) := '24';
   c_mrirate          CONSTANT CHAR(2) := '15';
   c_mriratio         CONSTANT CHAR(2) := '25';
   c_omrmrate         CONSTANT CHAR(2) := '16';
   c_omrmratio        CONSTANT CHAR(2) := '26';
   c_mrmrate          CONSTANT CHAR(2) := '17';
   c_mrmratio         CONSTANT CHAR(2) := '27';
   c_omrlrate         CONSTANT CHAR(2) := '28';
   c_omrlratio        CONSTANT CHAR(2) := '18';
   c_mrlrate          CONSTANT CHAR(2) := '29';
   c_mrlratio         CONSTANT CHAR(2) := '19';
   c_desc             CONSTANT CHAR(2) := '30';
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
    for rec in
    (
        SELECT MRT.ICCFTIED,MRT.MRIRATE,MRT.MRMRATE,MRT.MRLRATE,MRT.MRIRATELINE,MRT.MRMRATELINE,MRT.MRLRATELINE,
        MRT.MRIRATIO,MRT.MRMRATIO,MRT.MRLRATIO
        FROM AFMAST AF,AFTYPE AFT,MRTYPE MRT
        WHERE AF.ACTYPE=AFT.ACTYPE AND AFT.MRTYPE=MRT.ACTYPE AND ACCTNO=p_txmsg.txfields(c_applid).value AND MRT.MRTYPE <> 'N'
    )
    loop
        if rec.ICCFTIED = 'Y' then
            if to_number(p_txmsg.txfields(c_mrirate).value) > rec.mrirate + rec.mrirateline
                    or to_number(p_txmsg.txfields(c_mrirate).value) < rec.mrirate - rec.mrirateline then
                p_err_code := '-180010'; -- Pre-defined in DEFERROR table
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
            if to_number(p_txmsg.txfields(c_mrmrate).value) > rec.mrmrate + rec.mrmrateline
                    or to_number(p_txmsg.txfields(c_mrmrate).value) < rec.mrmrate - rec.mrmrateline then
                p_err_code := '-180011'; -- Pre-defined in DEFERROR table
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
            if to_number(p_txmsg.txfields(c_mrlrate).value) > rec.mrlrate + rec.mrlrateline
                    or to_number(p_txmsg.txfields(c_mrlrate).value) < rec.mrlrate - rec.mrlrateline then
                p_err_code := '-180012'; -- Pre-defined in DEFERROR table
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;


            if to_number(p_txmsg.txfields(c_mriratio).value) > rec.mriratio + rec.mrirateline
                    or to_number(p_txmsg.txfields(c_mriratio).value) < rec.mriratio - rec.mrirateline
                    or to_number(p_txmsg.txfields(c_mriratio).value) < to_number(cspks_system.fn_get_sysvar('MARGIN', 'IRATIO')) then
                p_err_code := '-180049'; -- Pre-defined in DEFERROR table
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
            if to_number(p_txmsg.txfields(c_mrmratio).value) > rec.mrmratio + rec.mrmrateline
                    or to_number(p_txmsg.txfields(c_mrmratio).value) < rec.mrmratio - rec.mrmrateline
                    or to_number(p_txmsg.txfields(c_mrmratio).value) < to_number(cspks_system.fn_get_sysvar('MARGIN', 'MRATIO'))
                    or to_number(p_txmsg.txfields(c_mrmratio).value) > to_number(cspks_system.fn_get_sysvar('MARGIN', 'IRATIO')) then
                p_err_code := '-180050'; -- Pre-defined in DEFERROR table
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
            if to_number(p_txmsg.txfields(c_mrlratio).value) > rec.mrlratio + rec.mrlrateline
                    or to_number(p_txmsg.txfields(c_mrlratio).value) < rec.mrlratio - rec.mrlrateline
                    or to_number(p_txmsg.txfields(c_mrlratio).value) < to_number(cspks_system.fn_get_sysvar('MARGIN', 'LRATIO'))
                    or to_number(p_txmsg.txfields(c_mrlratio).value) > to_number(cspks_system.fn_get_sysvar('MARGIN', 'MRATIO')) then
                p_err_code := '-180051'; -- Pre-defined in DEFERROR table
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        else
            p_err_code := '-180027'; -- Pre-defined in DEFERROR table
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;
    end loop;
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
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
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
         plog.init ('TXPKS_#1820EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1820EX;
/

