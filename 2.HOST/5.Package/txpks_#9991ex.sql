-- Start of DDL Script for Package Body HOSTMSTRADE.TXPKS_#9991EX
-- Generated 01/02/2019 4:44:42 PM from HOSTMSTRADE@FLEX_111

CREATE OR REPLACE 
PACKAGE txpks_#9991ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#9991EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      14/03/2016     Created
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


CREATE OR REPLACE 
PACKAGE BODY txpks_#9991ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_exchange         CONSTANT CHAR(2) := '01';
   c_sessionex        CONSTANT CHAR(2) := '02';
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


    plog.debug (pkgctx, 'p_txmsg.txfields(02).value=' || p_txmsg.txfields('02').value);
    plog.debug (pkgctx, 'p_txmsg.txfields(01).value=' || p_txmsg.txfields('01').value);

    IF p_txmsg.txfields('02').value = 'BOPN' AND p_txmsg.txfields('01').value <> 'HSX' THEN
        p_err_code := -909991;
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN p_err_code;
    END IF;

    IF p_txmsg.txfields('02').value = 'BCNT' AND p_txmsg.txfields('01').value  NOT IN ('HNX','UPCOM','BOND') THEN
        p_err_code := -909991;
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN p_err_code;
    END IF;

    IF p_txmsg.txfields('02').value = 'L5M' AND p_txmsg.txfields('01').value <> 'HNX' THEN
        p_err_code := -909991;
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN p_err_code;
    END IF;

    IF p_txmsg.txfields('02').value = 'LB' AND p_txmsg.txfields('01').value NOT IN ('HNX','HSX') THEN
        RETURN -909991;
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
    v_strMsg varchar2(4000);
    v_ErrMsg     VARCHAR2(4000);
    gc_Success           varchar2(10):='0';
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    plog.debug (pkgctx, '<<END OF fn_txAftAppUpdate');
    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');

    PCK_SYN2FO.PRC_GEN9000MSG2FO(v_EXCHANGE  => p_txmsg.txfields('01').value,
                                    v_SESSIONEX  => p_txmsg.txfields('02').value,
                                    v_strMsg=>v_strMsg ,
                                    v_errcode=>p_err_code,
                                    v_errmsg=>v_ErrMsg
                                    );

     plog.debug (pkgctx, 'PRC_GEN9000MSG2FO v_strMsg ' ||v_strMsg ||' p_txmsg.txnum '||p_txmsg.txnum);
     plog.debug (pkgctx, 'PRC_GEN9000MSG2FO p_err_code '||p_err_code);
    IF p_err_code <> gc_Success THEN
      plog.error (pkgctx, v_strMsg);
      RAISE errnums.E_SYSTEM_ERROR;
    END IF;

    IF v_strMsg IS NOT NULL THEN
        PCK_SYN2FO.PRC_CALLWEBSERVICE(pv_StrMessage => v_strMsg,
                                      v_errcode     => p_err_code,
                                      v_errmsg      => v_ErrMsg,
                                      v_type        => 'FO');
     plog.debug (pkgctx, 'PRC_CALLWEBSERVICE v_strMsg ' ||v_strMsg);
     plog.debug (pkgctx, 'PRC_CALLWEBSERVICE p_err_code '||p_err_code);
      IF p_err_code <> gc_Success THEN
          plog.error (pkgctx, v_strMsg);
          RETURN p_err_code;
        END IF;
      END IF;

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
         plog.init ('TXPKS_#9991EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#9991EX;
/


-- End of DDL Script for Package Body HOSTMSTRADE.TXPKS_#9991EX
