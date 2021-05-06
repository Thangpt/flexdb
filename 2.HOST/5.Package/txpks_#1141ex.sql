CREATE OR REPLACE PACKAGE txpks_#1141ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1141EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      27/08/2010     Created
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

CREATE OR REPLACE PACKAGE BODY txpks_#1141ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_custodycd        CONSTANT CHAR(2) := '82';
   c_acctno           CONSTANT CHAR(2) := '03';
   c_custname         CONSTANT CHAR(2) := '90';
   c_address          CONSTANT CHAR(2) := '91';
   c_license          CONSTANT CHAR(2) := '92';
   c_bankid           CONSTANT CHAR(2) := '02';
   c_bankacctno       CONSTANT CHAR(2) := '05';
   c_glmast           CONSTANT CHAR(2) := '06';
   c_amt              CONSTANT CHAR(2) := '10';
   c_refnum           CONSTANT CHAR(2) := '31';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    l_count NUMBER(20);
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
    --CHECK trung so chung tu ngan hang voi cung ngay, cung ngan hang.
        plog.error('1');
    plog.error(p_txmsg.busdate);
    SELECT count(1) INTO l_count FROM
    (
        SELECT * FROM tblcashdeposit WHERE deltd <> 'Y'
        UNION ALL
        SELECT th.* FROM tblcashdeposithist th, sysvar s
        WHERE busdate = p_txmsg.busdate AND deltd <> 'Y'
        AND s.grname = 'SYSTEM' AND s.varname = 'CURRDATE'
        AND th.txdate = to_date (s.varvalue,systemnums.c_date_format)
    )
    WHERE refnum = p_txmsg.txfields('31').value
    AND bankid = p_txmsg.txfields('02').value
    AND busdate = p_txmsg.busdate
    AND status = 'C';

    IF l_count <> 0 THEN
        p_err_code := '-400046'; -- double refnum.
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;

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
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'fn_txAftAppCheck');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAftAppCheck;

FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
l_count NUMBER(20);
l_avlwithdraw apprules.field%TYPE;
l_cimastcheck_arr txpks_check.cimastcheck_arrtype;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txPreAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txPreAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC PROCESS HERE. . DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF p_txmsg.deltd = 'Y' THEN
/*        SELECT COUNT(*) INTO l_Count
        FROM cimast
        WHERE ACCTNO=p_txmsg.txfields('03').value
        AND balance < ROUND(p_txmsg.txfields('10').value,0);

        IF l_count > 0 THEN
            p_err_code := '-400213';
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;*/

        l_CIMASTcheck_arr := txpks_check.fn_CIMASTcheck(p_txmsg.txfields('03').value,'CIMAST','ACCTNO');
        l_AVLWITHDRAW := l_CIMASTcheck_arr(0).AVLWITHDRAW;
        plog.debug (pkgctx, l_AVLWITHDRAW || ' <<' || p_txmsg.txfields('10').value);

        IF (to_number(l_AVLWITHDRAW) < to_number(p_txmsg.txfields('10').value)) THEN
            p_err_code := '-400005';
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;


    END IF;
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
    IF p_txmsg.deltd <> 'Y' THEN
        INSERT INTO tblcashdeposit (AUTOID,FILEID,BANKID,REFNUM,BUSDATE,CUSTODYCD,ACCTNO,AMT,DESCRIPTION,TXDATE,TLTXCD,TXNUM,STATUS,ERRORDESC,DELTD,LAST_CHANGE)
        VALUES
        (   seq_tblcashdeposit.nextval,
            to_char(SYSDATE,'RRRRMMDD') || '0000',
            p_txmsg.txfields('02').value,
            p_txmsg.txfields('31').value,
            to_date(p_txmsg.busdate,systemnums.c_date_format),
            p_txmsg.txfields('82').value,
            p_txmsg.txfields('03').value,
            p_txmsg.txfields('10').value,
            p_txmsg.txfields('30').value,
            to_date(p_txmsg.txdate,systemnums.c_date_format),
            p_txmsg.tltxcd,
            p_txmsg.txnum,
            'C',
            NULL,
            'N',
            SYSTIMESTAMP);
    ELSE
        UPDATE tblcashdeposit
        SET deltd = 'Y'
        WHERE txdate = to_date(p_txmsg.txdate,systemnums.c_date_format)
        AND txnum = p_txmsg.txnum
        AND refnum = p_txmsg.txfields('31').value
        AND bankid = p_txmsg.txfields('02').value
        AND fileid = to_char(SYSDATE,'RRRRMMDD') || '0000';






    END IF;

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
         plog.init ('TXPKS_#1141EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1141EX;
/

