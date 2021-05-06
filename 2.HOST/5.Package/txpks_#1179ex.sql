CREATE OR REPLACE PACKAGE TXPKS_#1179EX
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1179EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      04/01/2019     Created
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
CREATE OR REPLACE PACKAGE BODY TXPKS_#1179EX
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_custodycd        CONSTANT CHAR(2) := '88';
   c_acctno           CONSTANT CHAR(2) := '03';
   c_custname         CONSTANT CHAR(2) := '90';
   c_address          CONSTANT CHAR(2) := '91';
   c_license          CONSTANT CHAR(2) := '92';
   c_iddate           CONSTANT CHAR(2) := '93';
   c_idplace          CONSTANT CHAR(2) := '94';
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
l_isCoreBank    afmast.corebank%TYPE;
l_afAcctno      afmast.acctno%TYPE;
l_bankAccount   crbdefacct.refacctno%TYPE;
l_bankCode      afmast.bankname%TYPE;
l_strTxdate     VARCHAR2(10);
l_amount        NUMBER;
l_desc          VARCHAR2(1000);
v_VALUE       VARCHAR2(1000);
v_extCMDSQL   VARCHAR2(5000);
l_reqId         crbtxreq.reqid%TYPE;
TYPE v_CurType  IS REF CURSOR;
c0             v_CurType;
l_defBankAcct  crbdefacct.refacctno%TYPE;
l_defBankName  crbdefacct.refacctname%TYPE;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    l_afAcctno  := p_txmsg.txfields('03').value;
    l_strTxdate := TO_CHAR(p_txmsg.txdate, systemnums.C_DATE_FORMAT);
    l_amount    := p_txmsg.txfields('10').value;
    l_desc      := p_txmsg.txfields('30').value;
    IF p_txmsg.deltd <> 'Y' THEN
      SELECT corebank INTO l_isCoreBank FROM afmast WHERE acctno = l_afAcctno;
      IF l_isCoreBank = 'Y' THEN
        --Sinh Yeu Cau Chuyen Khoan Vao TK
        INSERT INTO CITRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
        VALUES (p_txmsg.txnum, p_txmsg.txdate, p_txmsg.txfields ('03').value,'0011',ROUND(p_txmsg.txfields('10').value,0),NULL,'',p_txmsg.deltd,'',seq_CITRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');
        INSERT INTO CITRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
        VALUES (p_txmsg.txnum, p_txmsg.txdate, p_txmsg.txfields ('03').value,'0016',ROUND(p_txmsg.txfields('10').value,0),NULL,'',p_txmsg.deltd,'',seq_CITRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');
        UPDATE CIMAST
         SET
           BALANCE = BALANCE - (ROUND(p_txmsg.txfields('10').value,0)),
           DRAMT = DRAMT + (ROUND(p_txmsg.txfields('10').value,0)),
           LASTDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT), LAST_CHANGE = SYSTIMESTAMP
        WHERE ACCTNO=p_txmsg.txfields('03').value;
        
        l_reqId := seq_crbtxreq.nextval;
        FOR rec IN (
          SELECT * FROM CRBTXMAP crb WHERE objname = p_txmsg.tltxcd
        ) LOOP
          BEGIN
            SELECT def.refacctno, af.bankname INTO l_bankAccount, l_bankCode
            FROM crbdefacct def, afmast af 
            WHERE def.REFBANK = af.bankname
            AND trfcode = rec.trfcode AND af.acctno = l_afAcctno
            ;
          EXCEPTION
            WHEN OTHERS THEN
              l_bankAccount := '';
          END;
          IF l_bankAccount IS NOT NULL AND length(l_bankAccount) > 0 THEN
            INSERT INTO CRBTXREQ (REQID, OBJTYPE, OBJNAME, OBJKEY, TRFCODE, REFCODE, 
                                  TXDATE, AFFECTDATE, AFACCTNO, TXAMT, BANKCODE, 
                                  BANKACCT, STATUS, REFVAL, NOTES)
            VALUES (l_reqId, 'T', p_txmsg.tltxcd, p_txmsg.txnum, rec.trfcode, l_strTxdate || p_txmsg.txnum, 
                    p_txmsg.txdate, p_txmsg.txdate, l_afAcctno, l_amount, l_bankCode, l_bankAccount, 'P', NULL, l_desc);
          END IF;
          FOR rc IN (
            SELECT * FROM crbtxmapext c WHERE OBJTYPE ='T'
                    AND c.OBJNAME = rec.objname AND TRFCODE = rec.TRFCODE
          ) LOOP
            BEGIN
                IF NOT rc.AMTEXP IS NULL THEN
                  v_VALUE := FN_EVAL_AMTEXP(p_txmsg.txnum, l_strTxdate, rc.AMTEXP);
                END IF;
                IF NOT rc.CMDSQL IS NULL THEN
                    BEGIN
                      v_extCMDSQL := REPLACE(rc.CMDSQL, '<$FILTERID>', v_VALUE);
                      BEGIN
                          OPEN c0 FOR v_extCMDSQL;
                          FETCH c0 INTO v_VALUE;
                          CLOSE c0;
                      EXCEPTION
                        WHEN OTHERS THEN
                            v_VALUE:='0';
                            plog.error(pkgctx,'Khong lay duoc gia tri tren cau lenh select dong : SQL-' || v_extCMDSQL);
                      END;
                    END;
                END IF;

                INSERT INTO CRBTXREQDTL (AUTOID, REQID, FLDNAME, CVAL, NVAL)
                  SELECT SEQ_CRBTXREQDTL.NEXTVAL, l_reqId, rc.FLDNAME,
                  DECODE(rc.FLDTYPE, 'N', NULL, TO_CHAR(v_VALUE)),
                  DECODE(rc.FLDTYPE, 'N', v_VALUE, 0) FROM DUAL;
            END;
          END LOOP;
          BEGIN
            SELECT REFACCTNO, REFACCTNAME
            INTO l_defBankAcct, l_defBankName
            FROM crbdefacct c
            WHERE c.trfcode = rec.trfcode AND c.refbank = l_bankCode;
          EXCEPTION
            WHEN OTHERS THEN
              l_defBankAcct := '';
              l_defBankName := '';
          END;
          INSERT INTO CRBTXREQDTL (AUTOID, REQID, FLDNAME, CVAL, NVAL) VALUES (SEQ_CRBTXREQDTL.NEXTVAL, l_reqId, 'DESACCTNO', l_defBankAcct, '');
          INSERT INTO CRBTXREQDTL (AUTOID, REQID, FLDNAME, CVAL, NVAL) VALUES (SEQ_CRBTXREQDTL.NEXTVAL, l_reqId, 'DESACCTNAME', l_defBankName, '');
        END LOOP;
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
         plog.init ('TXPKS_#1179EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1179EX;
/
