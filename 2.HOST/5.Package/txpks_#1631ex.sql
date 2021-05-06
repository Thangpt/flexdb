CREATE OR REPLACE PACKAGE txpks_#1631ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1631EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      10/09/2012     Created
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

CREATE OR REPLACE PACKAGE BODY txpks_#1631ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_acctno           CONSTANT CHAR(2) := '03';
   c_actype           CONSTANT CHAR(2) := '08';
   c_custodycd        CONSTANT CHAR(2) := '04';
   c_afacctno         CONSTANT CHAR(2) := '05';
   c_balance          CONSTANT CHAR(2) := '10';
   c_frdate           CONSTANT CHAR(2) := '06';
   c_todate           CONSTANT CHAR(2) := '07';
   c_buyingpower      CONSTANT CHAR(2) := '09';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
v_strBreakCD VARCHAR(1);
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
    SELECT breakcd INTO v_strBreakCD
    FROM tdmast
    WHERE acctno=p_txmsg.txfields('03').value;
    if v_strBreakCD='N' then
            p_err_code := '-570013'; -- Pre-defined in DEFERROR table
            plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;

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

    v_blnREVERSAL boolean;
    l_tdacctno varchar2(30);
    v_txdate date;
    v_DD number;
    v_WW number;
    v_MM number;
    v_frdate date;
    v_todate date;
    v_termcd char(1);
    v_tdterm number;
    v_breakcd char(1);
    v_minbrterm number;
    v_rndno char(1);
    v_count number;
    v_crrterm number;
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
    l_tdacctno:=p_txmsg.txfields('03').value;
    v_txdate:=p_txmsg.txdate;
    v_count:=1;

        BEGIN

           SELECT TO_NUMBER(v_txdate - FRDATE) DD,
           FLOOR(v_txdate - FRDATE)/7 WW,
           FLOOR(MONTHS_BETWEEN(v_txdate ,FRDATE)) MM, FRDATE, TODATE, TERMCD,
           TDTERM, BREAKCD, MINBRTERM,RNDNO
           INTO v_DD, v_WW, v_MM, v_frdate, v_todate, v_termcd,v_tdterm, v_breakcd, v_minbrterm, v_rndno
           FROM TDMAST
           WHERE ACCTNO=l_tdacctno;
       EXCEPTION
         WHEN OTHERS THEN
           v_count := 0;

       END;

       IF v_count > 0 THEN
          IF v_breakcd ='N' AND v_todate >= v_txdate AND v_rndno=0 THEN
             p_err_code:= '-570012';
             plog.setendsection (pkgctx, 'fn_txAftAppCheck');
             RETURN errnums.C_BIZ_RULE_INVALID;
          ELSIF v_breakcd='Y' THEN
             IF v_termcd = 'D' THEN
                v_crrterm := v_DD;
             ELSIF v_termcd ='M' THEN
                v_crrterm := v_MM;
             ELSIF v_termcd ='W' THEN
                v_crrterm :=v_WW;
             END IF;
             IF v_minbrterm > v_crrterm THEN
                p_err_code :='-570012';
                plog.setendsection (pkgctx, 'fn_txAftAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
             END IF;
          END IF;

       END IF;

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

      if(p_txmsg.deltd <> 'Y') THEN
          UPDATE tdmast SET mortgage=balance WHERE acctno= p_txmsg.txfields('03').value;

          UPDATE afmast SET MRCRLIMIT =MRCRLIMIT+to_number( p_txmsg.txfields('10').value)
          WHERE acctno= p_txmsg.txfields('05').value;

          INSERT INTO TDLINK (TXDATE, TXNUM, AFACCTNO, ACCTNO, DORC, DELTD, AMT)
          VALUES (p_txmsg.txdate,p_txmsg.txnum,p_txmsg.txfields('05').value, p_txmsg.txfields('03').value,'C','N',to_number( p_txmsg.txfields('10').value));

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
         plog.init ('TXPKS_#1631EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1631EX;
/

