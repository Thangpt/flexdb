CREATE OR REPLACE PACKAGE txpks_#1121ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1121EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      16/03/2011     Created
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

CREATE OR REPLACE PACKAGE BODY txpks_#1121ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_custodycd        CONSTANT CHAR(2) := '88';
   c_dacctno          CONSTANT CHAR(2) := '03';
   c_dleader          CONSTANT CHAR(2) := '04';
   c_castbal          CONSTANT CHAR(2) := '87';
   c_fullname         CONSTANT CHAR(2) := '31';
   c_custname         CONSTANT CHAR(2) := '90';
   c_address          CONSTANT CHAR(2) := '91';
   c_license          CONSTANT CHAR(2) := '92';
   c_iddate           CONSTANT CHAR(2) := '96';
   c_idplace          CONSTANT CHAR(2) := '97';
   c_custodycd        CONSTANT CHAR(2) := '89';
   c_cacctno          CONSTANT CHAR(2) := '05';
   c_cleader          CONSTANT CHAR(2) := '06';
   c_custname2        CONSTANT CHAR(2) := '93';
   c_address2         CONSTANT CHAR(2) := '94';
   c_license2         CONSTANT CHAR(2) := '95';
   c_refid            CONSTANT CHAR(2) := '79';
   c_iddate2          CONSTANT CHAR(2) := '98';
   c_idplace2         CONSTANT CHAR(2) := '99';
   c_amt              CONSTANT CHAR(2) := '10';
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
    l_lngErrCode number(20,0);
    l_strDAcctNo varchar2(10);
    l_strCAcctNo varchar2(10);
    l_dblAmount number(30,4);
    l_strDLeader varchar2(10);
    l_strCLeader varchar2(10);
    l_dblAbvailBal number(30,4);
    l_blnReversal boolean;
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
    l_lngErrCode:= errnums.C_BIZ_RULE_INVALID;
    p_err_code:=0;


    if p_txmsg.deltd='Y' then
        l_blnReversal:=true;
    else
        l_blnReversal:=false;
    end if;

    if not l_blnReversal then
        l_strDAcctNo := p_txmsg.txfields(c_dacctno).value;
        l_strCAcctNo := p_txmsg.txfields(c_cacctno).value;
        l_dblAmount := p_txmsg.txfields(c_amt).value;
        l_strDLeader := '';
        l_strCLeader := '';
        l_dblAbvailBal :=0;

        --Check TK li?th?hay ko
        SELECT GROUPLEADER INTO l_strDLeader FROM AFMAST WHERE ACCTNO=l_strDAcctNo;
        IF l_strDLeader IS NULL THEN
            p_err_code := errnums.C_CF_AFMAST_GLEADER_NOTFOUNDED;
            return l_lngErrCode;
        END IF;

        SELECT GROUPLEADER INTO l_strCLeader FROM AFMAST WHERE ACCTNO=l_strCAcctNo;
        IF l_strCLeader IS NULL THEN
            p_err_code := errnums.C_CF_AFMAST_GLEADER_NOTFOUNDED;
            return l_lngErrCode;
        END IF;

        IF l_strDLeader <> l_strCLeader THEN
            p_err_code := errnums.C_CF_AFMAST_GLEADER_NOTMATCHED;
            return l_lngErrCode;
        END IF;

        SELECT CI.BALANCE + NVL(ADV.ADVAMT,0) INTO l_dblAbvailBal
        FROM CIMAST CI,v_getAccountAvlAdvance ADV
        WHERE CI.AFACCTNO=ADV.AFACCTNO(+) AND CI.AFACCTNO=l_strDAcctNo;

        plog.debug (pkgctx, 'Avail Bal : ' || l_dblAbvailBal || ' - Amount : ' || l_dblAmount);

        IF l_dblAmount>l_dblAbvailBal THEN
            p_err_code := errnums.c_CI_CIMAST_BALANCE_NOTENOUGHT;
            return l_lngErrCode;
        END IF;
    end if;

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
    l_lngErrCode number(20,0);
    l_strAcctNo varchar2(10);
    l_dblAmount number(30,4);
    l_strRefID varchar2(50);
    l_strDesc varchar2(500);
    l_blnReversal boolean;
    l_strBRID varchar2(30);
    l_strTXDATE varchar2(30);
    l_strTXNUM varchar2(30);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    l_lngErrCode:= errnums.C_BIZ_RULE_INVALID;

    if p_txmsg.deltd='Y' then
        l_blnReversal:=true;
    else
        l_blnReversal:=false;
    end if;

    l_strBRID :=p_txmsg.BRID;
    l_strTXDATE :=p_txmsg.TXDATE;
    l_strTXNUM :=p_txmsg.TXNUM;

    l_strAcctNo := p_txmsg.txfields(c_dacctno).value;
    l_dblAmount := p_txmsg.txfields(c_amt).value;
    l_strRefID := p_txmsg.txfields(c_refid).value;
    l_strDesc := p_txmsg.txfields(c_desc).value;

    if not l_blnReversal then
        INSERT INTO CICUSTWITHDRAW (AUTOID,AFACCTNO,REF,TXNUM,TXDATE,AMT,TXDESC)
        VALUES(seq_cicustwithdraw.nextval,l_strAcctNo,l_strRefID,l_strTXNUM,TO_DATE(l_strTXDATE,'DD/MM/RRRR'),l_dblAmount,l_strDesc);
    else
        DELETE CICUSTWITHDRAW WHERE TXNUM = l_strTXNUM AND TRUNC(TXDATE) = TO_DATE(l_strTXDATE,'DD/MM/RRRR');
    end if;

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
         plog.init ('TXPKS_#1121EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1121EX;
/

