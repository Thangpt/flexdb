CREATE OR REPLACE PACKAGE txpks_#6638ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#6695EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      14/06/2017     Created
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

CREATE OR REPLACE PACKAGE BODY txpks_#6638ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_acctno           CONSTANT CHAR(2) := '03';
   c_reqid            CONSTANT CHAR(2) := '20';
   c_trfcode          CONSTANT CHAR(2) := '21';
   c_objkey           CONSTANT CHAR(2) := '22';
   c_rdate            CONSTANT CHAR(2) := '23';
   c_custodycd        CONSTANT CHAR(2) := '04';
   c_custname         CONSTANT CHAR(2) := '90';
   c_codeid           CONSTANT CHAR(2) := '01';
   c_qtty             CONSTANT CHAR(2) := '24';
   c_msgacct          CONSTANT CHAR(2) := '25';
   c_msgstatus        CONSTANT CHAR(2) := '26';
   c_change           CONSTANT CHAR(2) := '27';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
v_tltx VARCHAR2(50);
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
/*    SELECT req.objname INTO v_tltx FROM vsdtxreq req WHERE req.reqid = p_txmsg.txfields('20').value;
    IF v_tltx = '2245' THEN
      IF p_txmsg.txfields('27').VALUE = 'F' THEN
         p_err_code := '-900146'; -- Pre-defined in DEFERROR table
         plog.setendsection (pkgctx, 'fn_txPreAppCheck');
         RETURN errnums.C_BIZ_RULE_INVALID;
      END IF;
    END IF;
*/

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
v_tltx VARCHAR2(50);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/

    SELECT req.objname INTO v_tltx FROM vsdtxreq req WHERE req.reqid = p_txmsg.txfields('20').value;
    --Xu ly gd luu ky
    IF v_tltx = '2241' THEN
      IF p_txmsg.txfields('27').VALUE = 'F' THEN
        -- GOI GD 2246
        AUTO_CALL_TRANSAC.auto_call_txpks_2246(p_txmsg.txfields('20').value,0,p_txmsg.busdate,p_txmsg.tlid);
      ELSE
        --GOI GD 2231
        AUTO_CALL_TRANSAC.auto_call_txpks_2231(p_txmsg.txfields('20').value,0,p_txmsg.busdate,p_txmsg.tlid);
      update vsdtxreq
           set status = 'R', msgstatus = 'R' --boprocess = 'Y'
      where reqid = p_txmsg.txfields('20').value;
      END IF;
    END IF;

    -- XU LY GD RUT LUU KY
    IF v_tltx = '2292' THEN
      IF p_txmsg.txfields('27').VALUE = 'F' THEN
        AUTO_CALL_TRANSAC.auto_call_txpks_2201(p_txmsg.txfields('20').value,0,p_txmsg.busdate,p_txmsg.tlid);
      ELSE
        AUTO_CALL_TRANSAC.auto_call_txpks_2294(p_txmsg.txfields('20').value,0,p_txmsg.busdate,p_txmsg.tlid);
        update vsdtxreq
           set status = 'R', msgstatus = 'R' --boprocess = 'Y'
      where reqid = p_txmsg.txfields('20').value;
      END IF;
    END IF;

    --XU LY LUONG CHUYEN KHOAN TAT TOAN TAI KHOAN
    IF v_tltx = '2247' THEN
      IF p_txmsg.txfields('27').VALUE = 'F' THEN
        AUTO_CALL_TRANSAC.auto_call_txpks_2248(p_txmsg.txfields('20').value,0,p_txmsg.busdate,p_txmsg.tlid);
      ELSE
        AUTO_CALL_TRANSAC.auto_call_txpks_2290(p_txmsg.txfields('20').value,0,p_txmsg.busdate,p_txmsg.tlid);
        update vsdtxreq
           set status = 'R', msgstatus = 'R' --boprocess = 'Y'
      where reqid = p_txmsg.txfields('20').value;
      END IF;
    END IF;

    --chuy?n kho?n kh?ch? s? h?u/ chuy?n kho?n to?b? ch?ng kho?kh?? t?kho?n:
    IF v_tltx = '2255' THEN
      IF p_txmsg.txfields('27').VALUE = 'F' THEN
        AUTO_CALL_TRANSAC.auto_call_txpks_2266(p_txmsg.txfields('20').value,0,p_txmsg.busdate,p_txmsg.tlid);
      ELSE
        AUTO_CALL_TRANSAC.auto_call_txpks_2265(p_txmsg.txfields('20').value,0,p_txmsg.busdate,p_txmsg.tlid);
        update vsdtxreq
           set status = 'R', msgstatus = 'R' --boprocess = 'Y'
      where reqid = p_txmsg.txfields('20').value;
      END IF;
    END IF;

    -- Quy trinh gd lo le
    IF v_tltx = '8815' THEN
      IF p_txmsg.txfields('27').VALUE = 'F' THEN
        AUTO_CALL_TRANSAC.auto_call_txpks_8879(p_txmsg.txfields('20').value,0,p_txmsg.busdate,p_txmsg.tlid);
      ELSE
        AUTO_CALL_TRANSAC.auto_call_txpks_8816(p_txmsg.txfields('20').value,0,p_txmsg.busdate,p_txmsg.tlid);
        update vsdtxreq
           set status = 'R', msgstatus = 'R' --boprocess = 'Y'
      where reqid = p_txmsg.txfields('20').value;
      END IF;
    END IF;

    --  Nh?n chuy?n kho?n ch?ng kho?
    IF v_tltx = '2245' THEN
        IF p_txmsg.txfields('27').VALUE = 'R' THEN
            update vsdtxreq
            set status = 'R', msgstatus = 'R' --boprocess = 'Y'
            where reqid = p_txmsg.txfields('20').value;
        ELSIF  p_txmsg.txfields('27').VALUE = 'F' THEN
            update vsdtxreq
            set status = 'C', msgstatus = 'F' --boprocess = 'Y'
            where reqid = p_txmsg.txfields('20').value;
        END IF;
    END IF;

    -- mo tk
    IF v_tltx = '0043' THEN
      IF p_txmsg.txfields('27').VALUE = 'F' THEN
        update cfmast
        set activests = 'Y',
            nsdstatus = 'C'
        where custodycd = p_txmsg.txfields('04').value;
         update vsdtxreq
           set status = 'C', msgstatus = 'F' --boprocess = 'Y'
      where reqid = p_txmsg.txfields('20').value;
      ELSE
        update vsdtxreq
           set status = 'R', msgstatus = 'R' --boprocess = 'Y'
        where reqid = p_txmsg.txfields('20').value;
        UPDATE cfmast cf
        SET cf.nsdstatus = 'R',
            cf.activests = 'N'
        WHERE CF.CUSTODYCD = p_txmsg.txfields('04').value;
      END IF;
    END IF;

    --Dong TK
    IF v_tltx = '0059' THEN
      IF p_txmsg.txfields('27').VALUE = 'F' THEN
        update cfmast
        set status = 'C',
            nsdstatus = 'C'
        where custodycd = p_txmsg.txfields('04').value;
         update vsdtxreq
         set status = 'C', msgstatus = 'F' --boprocess = 'Y'
         where reqid = p_txmsg.txfields('20').value;
      ELSE
        update vsdtxreq
           set status = 'R', msgstatus = 'R' --boprocess = 'Y'
        where reqid = p_txmsg.txfields('20').value;
        UPDATE cfmast cf
        SET cf.nsdstatus = 'R',
            cf.status = 'A'
        WHERE CF.CUSTODYCD = p_txmsg.txfields('04').value;
      END IF;
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
         plog.init ('txpks_#6638EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END txpks_#6638EX;
/

