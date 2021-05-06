CREATE OR REPLACE PACKAGE txpks_#2246ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#2246EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      08/10/2010     Created
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
CREATE OR REPLACE PACKAGE BODY txpks_#2246ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_autoid           CONSTANT CHAR(2) := '05';
   c_codeid           CONSTANT CHAR(2) := '01';
   c_afacctno         CONSTANT CHAR(2) := '02';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_acctno           CONSTANT CHAR(2) := '03';
   c_custname         CONSTANT CHAR(2) := '90';
   c_address          CONSTANT CHAR(2) := '91';
   c_license          CONSTANT CHAR(2) := '92';
   c_depotrade        CONSTANT CHAR(2) := '06';
   c_depoblock        CONSTANT CHAR(2) := '04';
   c_qttytype         CONSTANT CHAR(2) := '08';
   c_qtty             CONSTANT CHAR(2) := '10';
   c_parvalue         CONSTANT CHAR(2) := '11';
   c_price            CONSTANT CHAR(2) := '09';
   c_desc             CONSTANT CHAR(2) := '30';
   c_pdate            CONSTANT CHAR(2) := '07';
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

    IF p_txmsg.deltd = 'N' THEN
        if txpks_prchk.fn_afRoomLimitCheck(p_txmsg.txfields('02').value, p_txmsg.txfields('01').value,
            greatest(to_number(p_txmsg.txfields('06').value),0), p_err_code) <> 0 then
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;
    end if;

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
v_strTYPEDEPOBLOCK varchar2(20);
v_nAMT number;
v_nPRICE number;
v_nDEPOTRADE number;
v_nDEPOBLOCK number;
v_txnum varchar2(20);
V_txdate date;
v_rdate date ;
v_currmonth VARCHAR2(10);
v_TBALDT DATE;
v_count_days NUMBER;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/


    v_strAFACCTNO := p_txmsg.txfields('02').VALUE;
    v_strACCTNO := p_txmsg.txfields('03').VALUE;
    v_nAMT := p_txmsg.txfields('10').VALUE;
    v_nDEPOTRADE := p_txmsg.txfields('06').VALUE;
    v_nDEPOBLOCK := p_txmsg.txfields('04').VALUE;
    v_strTYPEDEPOBLOCK := p_txmsg.txfields('08').VALUE;
    v_rdate := to_date(p_txmsg.txfields('13').VALUE,'dd/mm/yyyy');

    v_txnum:= p_txmsg.txnum;
    V_txdate:= p_txmsg.txdate;
    v_TBALDT:= Greatest(to_date ( p_txmsg.txfields('32').value,'DD/MM/RRRR')+1, p_txmsg.busdate);
    -- so ngay tinh phi luu ky chua den han
    v_count_days:= p_txmsg.txdate - v_TBALDT;
    v_currmonth := to_char(to_date(V_txdate,'DD/MM/RRRR'),'RRRRMM');

    IF p_txmsg.deltd <> 'Y' THEN
        UPDATE SEDEPOSIT SET STATUS='C' WHERE AUTOID = p_txmsg.txfields('05').VALUE;
        INSERT INTO SEMASTDTL (ACCTNO,QTTY,QTTYTYPE,TXNUM,TXDATE,DELTD,DFQTTY,STATUS,AUTOID)
        VALUES(v_strACCTNO,v_nDEPOBLOCK,v_strTYPEDEPOBLOCK,v_txnum,V_txdate,'N',0,'N',SEQ_SEMASTDTL.NEXTVAL);

        -- chi tang phi luu ky voi TK nhan
        IF ( p_txmsg.txfields('33').VALUE > 0 ) THEN
         INSERT INTO SEDEPOBAL (AUTOID, ACCTNO, TXDATE, DAYS, QTTY, DELTD,ID,amt)
         VALUES (SEQ_SEDEPOBAL.NEXTVAL, p_txmsg.txfields('03').value,v_TBALDT,v_count_days, p_txmsg.txfields('12').value, 'N',to_char(V_txdate)||V_txnum, p_txmsg.txfields('33').VALUE );
         END IF;
         -- ghi nhan them mot dong phi LK den han
         IF ( p_txmsg.txfields('15').VALUE > 0 ) THEN
            IF cspks_ciproc.fn_FeeDepoMaturityBackdate(p_txmsg,p_err_code) <> systemnums.C_SUCCESS THEN
               RETURN errnums.C_BIZ_RULE_INVALID;
            END IF;
         END IF;
         --1.8.2.5: them phan nhan ck quyen
         IF p_txmsg.txfields('16').value > 0 THEN
           INSERT INTO sepitlog ( autoid,acctno,txdate,txnum,qtty,mapqtty,codeid,camastid,afacctno,price,pitrate,catype,modifieddate)
                SELECT seq_sepitlog.nextval,p_txmsg.txfields('03').value,p_txmsg.txdate,p_txmsg.txnum,p_txmsg.txfields('16').value,0,
                      p_txmsg.txfields('01').value, to_char(p_txmsg.txdate,'DD/MM/RRRR')||p_txmsg.txnum,p_txmsg.txfields('02').VALUE,
                      PARVALUE,p_txmsg.txfields('17').value,'011',p_txmsg.txdate
                      FROM sbsecurities WHERE codeid=p_txmsg.txfields('01').value;
         END IF;
         IF p_txmsg.txfields('18').value > 0 THEN
           INSERT INTO sepitlog ( autoid,acctno,txdate,txnum,qtty,mapqtty,codeid,camastid,afacctno,price,pitrate,catype,modifieddate)
                SELECT seq_sepitlog.nextval,p_txmsg.txfields('03').value,p_txmsg.txdate,p_txmsg.txnum,p_txmsg.txfields('18').value,0,
                      p_txmsg.txfields('01').value, to_char(p_txmsg.txdate,'DD/MM/RRRR')||p_txmsg.txnum,p_txmsg.txfields('02').VALUE,
                      PARVALUE,p_txmsg.txfields('19').value,'021',p_txmsg.txdate
                      FROM sbsecurities WHERE codeid=p_txmsg.txfields('01').value;
         END IF;
    Else
        UPDATE SEDEPOSIT SET STATUS='S' WHERE AUTOID = p_txmsg.txfields('05').VALUE;
        update semastdtl set deltd ='Y' where txdate = V_txdate and txnum = v_txnum ;

         -- PhuongHT edit: log phi luu ky backdate
        IF ( p_txmsg.txfields('33').VALUE > 0 ) THEN
        UPDATE sedepobal SET deltd='Y' WHERE id=to_char(V_txdate)||V_txnum ;
        END IF;
        IF ( p_txmsg.txfields('15').VALUE > 0 ) THEN
           IF cspks_ciproc.fn_FeeDepoMaturityBackdate(p_txmsg,p_err_code) <> systemnums.C_SUCCESS THEN
               RETURN errnums.C_BIZ_RULE_INVALID;
           END IF;
         END IF;
             -- end of PhuongHT
         --1.8.2.5: thue quyen
       IF p_txmsg.txfields('16').value > 0 OR p_txmsg.txfields('18').value > 0 THEN
         UPDATE sepitlog SET deltd = 'Y' WHERE acctno = p_txmsg.txfields('05').value AND camastid=to_char(p_txmsg.txdate,'DD/MM/RRRR')||p_txmsg.txnum;
       END IF;
    End if;

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
         plog.init ('TXPKS_#2246EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#2246EX;
/
