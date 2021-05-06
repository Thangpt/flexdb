CREATE OR REPLACE PACKAGE txpks_#0021ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#0021EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      08/07/2015     Created
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

CREATE OR REPLACE PACKAGE BODY txpks_#0021ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_id               CONSTANT CHAR(2) := '01';
   c_status           CONSTANT CHAR(2) := '40';
   c_notes            CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    v_PStatus varchar2(50);
    v_Status varchar2(1);
    v_count number;
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

    Select PSTATUS, STATUS into v_PStatus, v_Status from cfintro where ID = p_txmsg.txfields('01').value;

    if nvl(p_txmsg.txfields('06').value,'ZZZ') = 'ZZZ' AND nvl(p_txmsg.txfields('40').value,'ZZZ') ='A' then
        p_err_code := -200901;
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        plog.setendsection (pkgctx, 'fn_txAftAppCheck');
        RETURN p_err_code;
    end if;

    if LENGTH(nvl(v_PStatus,'Z')) >= 2 then
        p_err_code := -260168;
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        plog.setendsection (pkgctx, 'fn_txAftAppCheck');
        RETURN p_err_code;
    end if;

    if v_Status = 'D' then
        p_err_code := -660004;
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        plog.setendsection (pkgctx, 'fn_txAftAppCheck');
        RETURN p_err_code;
    end if;

    if v_Status = p_txmsg.txfields('40').value then
        p_err_code := -660004;
        plog.error (pkgctx, p_txmsg.txfields('40').value);
        plog.setendsection (pkgctx, 'fn_txAftAppCheck');
        RETURN p_err_code;
    end if;

    if v_Status = 'P' And p_txmsg.txfields('40').value NOT IN ('A','R') then
        p_err_code := -660004;
        plog.error (pkgctx, p_txmsg.txfields('40').value);
        plog.setendsection (pkgctx, 'fn_txAftAppCheck');
        RETURN p_err_code;
    end if;

    if v_Status = 'A' And p_txmsg.txfields('40').value NOT IN ('R') then
        p_err_code := -660004;
        plog.error (pkgctx, p_txmsg.txfields('40').value);
        plog.setendsection (pkgctx, 'fn_txAftAppCheck');
        RETURN p_err_code;
    end if;

    if v_Status = 'R' And p_txmsg.txfields('40').value NOT IN ('A') then
        p_err_code := -660004;
        plog.error (pkgctx, p_txmsg.txfields('40').value);
        plog.setendsection (pkgctx, 'fn_txAftAppCheck');
        RETURN p_err_code;
    end if;

    if  p_txmsg.txfields('40').value = 'A' And nvl(v_PStatus,'ZZZ') IN ('ZZZ','P','R') then
        Select Count(IDCODE) INTO v_count From cfmast where status <> 'C' and IDCODE = p_txmsg.txfields('06').value;
        if v_count > 0 THEN
                p_err_code := -200020;
                plog.error (pkgctx, p_txmsg.txfields('40').value);
                plog.setendsection (pkgctx, 'fn_txAftAppCheck');
                RETURN p_err_code;
        end if;

        Select Count(IDCODEINTRO) INTO v_count From cfintro where status = 'A' and IDCODEINTRO = p_txmsg.txfields('06').value;
        if v_count > 0 THEN
                p_err_code := -200020;
                plog.error (pkgctx, p_txmsg.txfields('40').value);
                plog.setendsection (pkgctx, 'fn_txAftAppCheck');
                RETURN p_err_code;
        end if;
    end if;

    /*Select Count(ID) into v_count From cfintro Where Id = p_txmsg.txfields('01').value AND Status <> 'P';
    if v_count > 0 then
        p_err_code := -540001; -- Trang thai khong hop le
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        plog.setendsection (pkgctx, 'fn_txAftAppCheck');
        RETURN p_err_code;
    end if;*/

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

    Update cfintro Set Status = p_txmsg.txfields('40').value,
        idcodeintro = p_txmsg.txfields('06').value,
        DESCRIPTION = p_txmsg.txfields('30').value,
        PSTATUS = PSTATUS || STATUS
    Where ID = p_txmsg.txfields('01').value;

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
         plog.init ('TXPKS_#0021EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#0021EX;
/

