CREATE OR REPLACE PACKAGE TXPKS_#1201EX
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1201EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      10/07/2020     Created
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
CREATE OR REPLACE PACKAGE BODY TXPKS_#1201EX
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_custodycd        CONSTANT CHAR(2) := '88';
   c_dacctno          CONSTANT CHAR(2) := '03';
   c_fullname         CONSTANT CHAR(2) := '31';
   c_license          CONSTANT CHAR(2) := '92';
   c_iddate           CONSTANT CHAR(2) := '96';
   c_custodycd        CONSTANT CHAR(2) := '89';
   c_cacctno          CONSTANT CHAR(2) := '05';
   c_custname2        CONSTANT CHAR(2) := '93';
   c_license2         CONSTANT CHAR(2) := '95';
   c_iddate2          CONSTANT CHAR(2) := '98';
   c_castbal          CONSTANT CHAR(2) := '87';
   c_amt              CONSTANT CHAR(2) := '10';
   c_feetype          CONSTANT CHAR(2) := '25';
   c_feeamt           CONSTANT CHAR(2) := '15';
   c_totalamt         CONSTANT CHAR(2) := '16';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
L_CCUSTID VARCHAR2(10);
L_DCUSTID VARCHAR2(10);
v_count NUMBER;
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
    IF UPPER(p_txmsg.txfields(88).value) = UPPER(p_txmsg.txfields(89).value) THEN
        p_err_code := '-200220'; -- Pre-defined in DEFERROR table
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
     END IF;

     -- Check so am
     If (p_txmsg.txfields('10').value <= 0 or p_txmsg.txfields('15').value < 0  or p_txmsg.txfields('16').value <= 0 ) then
         p_err_code := '-100810';
         plog.setendsection (pkgctx, 'fn_txPreAppCheck');
         RETURN errnums.C_BIZ_RULE_INVALID;
     End if;
    -- End check so am
    -- check tk nhan da dang ky chua
     SELECT COUNT(1) INTO v_count FROM cfotheracc WHERE TYPE='0' AND afacctno=p_txmsg.txfields(c_dacctno).value AND ciaccount=p_txmsg.txfields(c_cacctno).value;

     IF v_count = 0 THEN
        p_err_code := '-400127'; -- Pre-defined in DEFERROR table
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
     END IF;
    -- Check so tien toi thieu
    begin
      if to_number(cspks_system.fn_get_sysvar('SYSTEM','ONLINEMINTRFBIDV')) > p_txmsg.txfields('10').value then
          p_err_code:='-100137';
          plog.setendsection(pkgctx, 'fn_txPreAppCheck');
          RETURN errnums.C_BIZ_RULE_INVALID;
      end if;
    exception when others then
        plog.error(pkgctx, 'Error: Chua khai bao han muc chuyen khoan tien BIDV toi thieu');
    end;
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
    IF CSPKS_CIPROC.fn_GenRemittanceTrans(p_txmsg,p_err_code) <> systemnums.C_SUCCESS THEN
       RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;
    if p_txmsg.deltd <> 'Y' THEN
        INSERT INTO CICUSTWITHDRAW (AUTOID,AFACCTNO,REF,TXNUM,TXDATE,AMT,TXDESC)
        VALUES(seq_cicustwithdraw.nextval,p_txmsg.txfields(c_dacctno).value,'',p_txmsg.txnum,p_txmsg.txdate,to_number(p_txmsg.txfields(c_amt).value),p_txmsg.txdesc);

        INSERT INTO TCDT2DEPOACC_LOG (Txdate,Txnum,Dcustodycd,Dacctno,
                                      Ccustodycd,Cacctno,
                                      Amt,Feeamt,Rmstatus,Deltd,
                                      Tlid,Offid,Brid,Des)
        VALUES (p_txmsg.txdate,p_txmsg.txnum,p_txmsg.txfields(88).value,p_txmsg.txfields(c_dacctno).value,
                p_txmsg.txfields(89).value,p_txmsg.txfields(c_cacctno).value,
                to_number(p_txmsg.txfields(10).value),to_number(p_txmsg.txfields(15).value),'A','N',
                p_txmsg.tlid,p_txmsg.offid,p_txmsg.brid, p_txmsg.txdesc);
    else
        DELETE CICUSTWITHDRAW WHERE TXNUM = p_txmsg.txnum AND TXDATE = p_txmsg.txdate;

        DELETE TCDT2DEPOACC_LOG WHERE TXNUM = p_txmsg.txnum AND TXDATE = p_txmsg.txdate;
    end if;

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
         plog.init ('TXPKS_#1201EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1201EX;
/
