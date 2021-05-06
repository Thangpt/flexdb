CREATE OR REPLACE PACKAGE txpks_#1670ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1670EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      24/05/2011     Created
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

CREATE OR REPLACE PACKAGE BODY txpks_#1670ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_acctno           CONSTANT CHAR(2) := '03';
   c_custname         CONSTANT CHAR(2) := '90';
   c_address          CONSTANT CHAR(2) := '91';
   c_license          CONSTANT CHAR(2) := '92';
   c_actype           CONSTANT CHAR(2) := '81';
   c_tdterm           CONSTANT CHAR(2) := '82';
   c_termcd           CONSTANT CHAR(2) := '80';
   c_tdsrc            CONSTANT CHAR(2) := '87';
   c_ciacctno         CONSTANT CHAR(2) := '06';
   c_isci             CONSTANT CHAR(2) := '88';
   c_schdtype         CONSTANT CHAR(2) := '83';
   c_intrate          CONSTANT CHAR(2) := '84';
   c_spreadterm       CONSTANT CHAR(2) := '85';
   c_spreadrate       CONSTANT CHAR(2) := '86';
   c_mstterm          CONSTANT CHAR(2) := '12';
   c_mstrate          CONSTANT CHAR(2) := '11';
   c_amt              CONSTANT CHAR(2) := '10';
   c_t_desc           CONSTANT CHAR(2) := '30';
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
    v_blnREVERSAL boolean;
    l_afacctno varchar2(30);
    l_actype varchar2(4);
    l_amt number;
    l_mstrate number(20,4);
    l_mstterm number(20,4);
    l_desc varchar2(2000);
    v_count number;

    v_txnum varchar2(30);
    v_busdate date;
    v_txdate date;
    v_opdate date;
    v_frmdate date;
    v_todate date;
    v_fmdate varchar2(10);
    v_acctno varchar2(30);
    v_mortage number;
    v_tlid varchar2(10);
    v_offid varchar2(10);
    v_actype       tdtype.actype%TYPE;
    v_tdtype       tdtype.tdtype%TYPE;
    v_tdsrc        tdtype.tdsrc%TYPE;
    v_ciacctno     tdtype.ciacctno%TYPE;
    v_custid       tdtype.custid%TYPE;
    v_termcd       tdtype.termcd%TYPE;
    v_tdterm       tdtype.tdterm%TYPE;
    v_autopaid     tdtype.autopaid%TYPE;
    v_minamt       tdtype.minamt%TYPE;
    v_taxrate      tdtype.taxrate%TYPE;
    v_bonusrate    tdtype.bonusrate%TYPE;
    v_tpr          tdtype.tpr%TYPE;
    v_schdtype     tdtype.schdtype%TYPE;
    v_inttype      tdtype.inttype%TYPE;
    v_refintcd     tdtype.refintcd%TYPE;
    v_refintgap    tdtype.refintgap%TYPE;
    v_intrate      tdtype.intrate%TYPE;
    v_breakcd      tdtype.breakcd%TYPE;
    v_minbrterm    tdtype.minbrterm%TYPE;
    v_inttypbrcd   tdtype.inttypbrcd%TYPE;
    v_flintrate    tdtype.flintrate%TYPE;
    v_buyingpower  tdtype.buyingpower%TYPE;
    v_autornd      tdtype.autornd%TYPE;
    v_EXISTSVAL    NUMBER;
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
    --Lay Thong Tin Loai Hinh
      p_err_code:=0;
      v_blnREVERSAL := CASE WHEN p_txmsg.deltd ='Y' THEN TRUE ELSE FALSE END;
      l_afacctno := p_txmsg.txfields('03').value;
      l_actype := p_txmsg.txfields('81').value;
      l_amt := p_txmsg.txfields('10').value;
      l_mstrate := p_txmsg.txfields('11').value;
      l_mstterm := p_txmsg.txfields('12').value;
      l_desc := p_txmsg.txfields('30').value;
      v_busdate := p_txmsg.busdate;
      v_txdate := p_txmsg.txdate;
      v_txnum := p_txmsg.txnum;
      v_tlid := p_txmsg.tlid;
      v_offid := p_txmsg.offid;
       v_count := 1;
       IF p_txmsg.deltd <> 'Y' THEN
           BEGIN
                SELECT TYP.ACTYPE, TYP.TDTYPE, TYP.TDSRC, TYP.CIACCTNO, TYP.CUSTID,
                       TYP.TERMCD, TYP.TDTERM, TYP.AUTOPAID, TYP.MINAMT, TYP.TAXRATE,
                       TYP.BONUSRATE, TYP.TPR, TYP.SCHDTYPE, TYP.INTTYPE, TYP.REFINTCD,
                       TYP.REFINTGAP, TYP.INTRATE, TYP.BREAKCD, TYP.MINBRTERM, TYP.INTTYPBRCD,
                       TYP.FLINTRATE,  TYP.AUTORND
                INTO   v_actype, v_tdtype, v_tdsrc, v_ciacctno, v_custid, v_termcd, v_tdterm, v_autopaid,
                       v_minamt, v_taxrate, v_bonusrate, v_tpr, v_schdtype, v_inttype, v_refintcd, v_refintgap,
                       v_intrate, v_breakcd, v_minbrterm, v_inttypbrcd, v_flintrate, v_autornd
                FROM TDTYPE TYP
                WHERE TYP.ACTYPE=l_actype
                      AND TYP.EFFDATE<=v_busdate
                      AND TYP.EXPDATE>= v_busdate;
           EXCEPTION
             WHEN OTHERS THEN
                v_count := 0;
           END;
           IF v_count = 0 THEN
              p_err_code := '-570002';
              plog.setendsection (pkgctx, 'fn_OpenTermDeposit');
              RETURN errnums.C_BIZ_RULE_INVALID;
           END IF;
           -- check neu ko cho rut tu truoc han thi ko duoc tu dong cong vao suc mua
           v_buyingpower:=p_txmsg.txfields('15').value;
           IF (v_buyingpower='Y' AND v_breakcd='N')THEN
              p_err_code := '-570013';
              plog.setendsection (pkgctx, 'fn_OpenTermDeposit');
              RETURN errnums.C_BIZ_RULE_INVALID;
           END IF;
		   --check so ban dau khai tu dong rut = 'Y' can phai check minbrterm = 0 và breakcd = 'Y'
           IF (v_buyingpower='Y' AND v_minbrterm>0) THEN
              p_err_code := '-570014';
              plog.setendsection (pkgctx, 'fn_OpenTermDeposit');
              RETURN errnums.C_BIZ_RULE_INVALID;
           END IF;
           --check so du toi thieu
           IF l_amt < v_minamt THEN
              p_err_code := '-570003';
              plog.setendsection (pkgctx, 'fn_OpenTermDeposit');
              RETURN errnums.C_BIZ_RULE_INVALID;
           END IF;
           --end check
     end IF;
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
    IF cspks_tdproc.fn_OpenTermDeposit(p_txmsg,p_err_code) <> systemnums.C_SUCCESS THEN
       plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
       RETURN errnums.C_BIZ_RULE_INVALID;
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
l_tdacctno VARCHAR2(30);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    -- update td acctno vao ref trong citran de len bao cao
    SELECT acctno INTO l_tdacctno FROM tdmast
    WHERE txnum=p_txmsg.txnum AND txdate=p_txmsg.txdate
    AND afacctno=p_txmsg.txfields('03').VALUE;

    UPDATE citran SET ref=l_tdacctno,acctref=l_tdacctno
    WHERE txnum=p_txmsg.txnum AND txdate=p_txmsg.txdate;

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
         plog.init ('TXPKS_#1670EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1670EX;
/

