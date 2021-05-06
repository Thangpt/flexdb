CREATE OR REPLACE PACKAGE txpks_#3353ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#3353EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      03/11/2010     Created
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

CREATE OR REPLACE PACKAGE BODY txpks_#3353ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_camastid         CONSTANT CHAR(2) := '06';
   c_codeid           CONSTANT CHAR(2) := '01';
   c_afacctno         CONSTANT CHAR(2) := '02';
   c_acctno           CONSTANT CHAR(2) := '03';
   c_custodycd        CONSTANT CHAR(2) := '36';
   c_custname         CONSTANT CHAR(2) := '90';
   c_address          CONSTANT CHAR(2) := '91';
   c_license          CONSTANT CHAR(2) := '92';
   c_iddate           CONSTANT CHAR(2) := '93';
   c_issname          CONSTANT CHAR(2) := '38';
   c_idplace          CONSTANT CHAR(2) := '94';
   c_amt              CONSTANT CHAR(2) := '21';
   c_symbol           CONSTANT CHAR(2) := '35';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
L_STATUS CHAR(1);
l_camastStatus char(1);
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
    BEGIN
    SELECT STATUS INTO L_STATUS FROM CATRANSFER
    WHERE autoid= p_txmsg.txfields('31').VALUE;
    EXCEPTION WHEN OTHERS THEN
        L_STATUS:='C';
      END;
    IF(L_STATUS='C') THEN
    p_err_code:='-300050';
    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;
    -- check trang thai cua camast

     BEGIN
    SELECT STATUS INTO l_camastStatus FROM camast
    WHERE camastid= p_txmsg.txfields(c_camastid).VALUE AND deltd='N';
    EXCEPTION WHEN OTHERS THEN
        l_camastStatus:='C';
      END;
    IF(l_camastStatus NOT IN ('V','M')) THEN
    p_err_code:='-300013';
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
v_strCODEID varchar2(10);
v_strAFACCTNO varchar2(20);
v_strACCTNO varchar2(20);
v_strcamastid varchar2(20);
v_nAMT number;
v_txnum varchar2(20);
V_txdate date;
v_RIGHTOFRATE number;
v_LEFTOFRATE number;
v_ROUNDTYPE number;
v_EXPRICE number;

BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/

v_strCODEID := p_txmsg.txfields('01').VALUE;
v_strAFACCTNO := p_txmsg.txfields('02').VALUE;
v_nAMT := p_txmsg.txfields('21').VALUE;
v_txnum:= p_txmsg.txnum;
V_txdate:= p_txmsg.txdate;
v_strcamastid:= p_txmsg.txfields('06').VALUE;



SELECT   SUBSTR( rightoffrate,INSTR(rightoffrate,'/')+1 ) , SUBSTR( rightoffrate,1 ,INSTR(rightoffrate,'/')-1 ) ,ROUNDTYPE,EXPRICE
INTO v_RIGHTOFRATE,v_LEFTOFRATE,v_ROUNDTYPE,v_EXPRICE
FROM camast where camastid =v_strcamastid ;


 UPDATE CASCHD  SET PBALANCE = PBALANCE + v_nAMT  , RETAILBAL= RETAILBAL + v_nAMT ,
 PQTTY = TRUNC( FLOOR(( (PBALANCE +  v_nAMT  ) * v_RIGHTOFRATE ) / v_LEFTOFRATE )  , v_ROUNDTYPE ) ,
 PAAMT=  v_EXPRICE  * TRUNC(  FLOOR(( ( PBALANCE +v_nAMT ) *  v_RIGHTOFRATE)  /  v_LEFTOFRATE ) ,v_ROUNDTYPE ),
 outbalance= outbalance-v_nAMT
 WHERE AFACCTNO =v_strAFACCTNO  AND camastid =  v_strCAMASTID  and  deltd <> 'Y'
 AND autoid= p_txmsg.txfields('09').VALUE;

 UPDATE catransfer SET status='C' WHERE camastid=v_strCAMASTID AND AUTOID= p_txmsg.txfields('31').VALUE;

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
         plog.init ('TXPKS_#3353EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#3353EX;
/

