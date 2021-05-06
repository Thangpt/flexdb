CREATE OR REPLACE PACKAGE txpks_#5573ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#5573EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      04/05/2011     Created
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

CREATE OR REPLACE PACKAGE BODY txpks_#5573ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_autoid           CONSTANT CHAR(2) := '01';
   c_acctno           CONSTANT CHAR(2) := '03';
   c_afacctno         CONSTANT CHAR(2) := '04';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_custname         CONSTANT CHAR(2) := '90';
   c_productname      CONSTANT CHAR(2) := '13';
   c_address          CONSTANT CHAR(2) := '91';
   c_license          CONSTANT CHAR(2) := '92';
   c_todate           CONSTANT CHAR(2) := '05';
   c_overduedate      CONSTANT CHAR(2) := '06';
   c_amt              CONSTANT CHAR(2) := '10';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
V_TODATE date;
V_OVERDUEDATE date;
V_CURRDATE  DATE ;
l_count  number;
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

    SELECT TO_DATE(VARVALUE,'DD/MM/YYYY') INTO V_CURRDATE  FROM SYSVAR WHERE VARNAME ='CURRDATE' ;
    V_TODATE := TO_DATE( p_txmsg.txfields(c_todate).VALUE,'DD/MM/RRRR');
    V_OVERDUEDATE := TO_DATE(p_txmsg.txfields(c_overduedate).VALUE,'DD/MM/RRRR');

    IF V_TODATE <= V_OVERDUEDATE  THEN
        p_err_code:= '-540214'    ;
        RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;
    IF V_TODATE <= V_CURRDATE  THEN
        p_err_code:= '-540218';
        RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;

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
v_strAFACCTNO varchar2(20);
v_strACCTNO varchar2(20);
v_nAMT number;
v_txnum varchar2(20);
V_txdate date;
V_TODATE date;
V_OVERDUEDATE date;
V_CURRDATE  DATE ;
V_AUTOID VARCHAR2(300);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    SELECT TO_DATE(VARVALUE,'DD/MM/RRRR') INTO V_CURRDATE  FROM SYSVAR WHERE VARNAME ='CURRDATE' ;
    V_AUTOID := p_txmsg.txfields('01').VALUE;
    v_strAFACCTNO := p_txmsg.txfields('04').VALUE;
    v_strACCTNO := p_txmsg.txfields('03').VALUE;
    v_nAMT := p_txmsg.txfields('10').VALUE;
    V_TODATE := TO_DATE( p_txmsg.txfields('05').VALUE,'DD/MM/YYYY');
    V_OVERDUEDATE := TO_DATE(p_txmsg.txfields('06').VALUE,'DD/MM/YYYY');
    v_txnum:= p_txmsg.txnum;
    V_txdate:= p_txmsg.txdate;


    --TRONG HAN

    IF V_CURRDATE < V_OVERDUEDATE THEN
        UPDATE lnschd SET overduedate = V_TODATE WHERE AUTOID = V_AUTOID;
    END IF;

    -- DEN HAN
    IF V_CURRDATE = V_OVERDUEDATE THEN
        UPDATE lnschd SET overduedate = V_TODATE WHERE AUTOID = V_AUTOID;
        UPDATE CIMAST SET dueamt= dueamt - v_nAMT WHERE ACCTNO = v_strAFACCTNO;
    END IF;

    -- QUA HAN
    IF V_CURRDATE > V_OVERDUEDATE THEN
        UPDATE lnschd SET overduedate = V_TODATE WHERE AUTOID = V_AUTOID;
        UPDATE CIMAST SET ovamt= ovamt - v_nAMT WHERE ACCTNO = v_strAFACCTNO;

        UPDATE lnschd SET ovd=ovd-v_nAMT,nml=nml+v_nAMT WHERE AUTOID = V_AUTOID;
        UPDATE lnmast SET prinovd=prinovd-v_nAMT, prinnml=prinnml-v_nAMT WHERE acctno  = v_strACCTNO;
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
         plog.init ('TXPKS_#5573EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#5573EX;
/

