CREATE OR REPLACE PACKAGE txpks_#1818ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1818EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      05/03/2015     Created
 **
 ** (c) 2008 by Financial Software Solutions. JSC.
 ** ----------------------------------------------------------------------------------------------------*/
IS
FUNCTION fn_txPreAppCheck(p_txmsg IN OUT tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
END;
/
CREATE OR REPLACE PACKAGE BODY txpks_#1818ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_custodycd        CONSTANT CHAR(2) := '88';
   c_userid           CONSTANT CHAR(2) := '01';
   c_acctno           CONSTANT CHAR(2) := '03';
   c_t0deb            CONSTANT CHAR(2) := '43';
   c_period           CONSTANT CHAR(2) := '21';
   c_t0amtused        CONSTANT CHAR(2) := '22';
   c_t0amtpending     CONSTANT CHAR(2) := '23';
   c_toamt            CONSTANT CHAR(2) := '10';
   c_tlid             CONSTANT CHAR(2) := '26';
   c_rlimit           CONSTANT CHAR(2) := '12';
   c_acclimit         CONSTANT CHAR(2) := '11';
   c_custavllimit     CONSTANT CHAR(2) := '16';
   c_accused          CONSTANT CHAR(2) := '13';
   c_desc             CONSTANT CHAR(2) := '30';
   c_deal             CONSTANT CHAR(2) := '47';
FUNCTION fn_txPreAppCheck(p_txmsg IN OUT tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
v_count NUMBER;
v_remainAMT NUMBER;
v_t0limitall NUMBER;
v_deal1816 VARCHAR2(1);
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
    --Ktra deal da duoc phe duyet chua
     SELECT nvl(COUNT(*),0) INTO v_count FROM olndetail  WHERE autoid =p_txmsg.txfields('02').value     AND status ='P';
     IF v_count=0 THEN
        p_err_code := '-100151';
        RETURN errnums.C_BIZ_RULE_INVALID;
      END IF;
      v_count:=0;
    --Ktra MG va cap phe duyet phai cung chi nhanh
     SELECT nvl(COUNT(*),0)  INTO v_count FROM tlprofiles WHERE tlid =p_txmsg.txfields('01').value AND brid =p_txmsg.brid;
     IF v_count = 0 THEN
         p_err_code := '-100147';
        RETURN errnums.C_BIZ_RULE_INVALID;
     END IF;
     --Ktra han muc cua cap phe duyet
      SELECT max(t0limitall) INTO v_t0limitall  FROM usert0limit WHERE tlid =p_txmsg.txfields('26').value;
      SELECT v_t0limitall- nvl(SUM(T0AMTPENDING),0)  -  p_txmsg.txfields('23').value INTO v_remainAMT FROM OLNDETAIl
              WHERE  STATUS IN ('A','E')
              AND  tlid = p_txmsg.txfields('26').value
              AND duedate =getcurrdate ;
       IF  v_remainAMT <  0 THEN
                 p_err_code := '-100150';
                 RETURN errnums.C_BIZ_RULE_INVALID;
       END IF;
    
    -- 1.5.8.9|iss:2050
    -- Canh bao khi thay doi gia tri Deal duyet rieng
    SELECT deal1816 INTO v_deal1816 FROM olndetail 
    WHERE autoid = p_txmsg.txfields('02').value;
    
    IF v_deal1816 <> p_txmsg.txfields(c_deal).value then
       p_txmsg.txWarningException('-1800571').value:= cspks_system.fn_get_errmsg('-180057');
       p_txmsg.txWarningException('-1800571').errlev:= '1';
    END IF;
    
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

    l_t0amt_all     number(20,4);
    l_t0amt_inday   number(20,4);
    l_t0amt_max     number(20,4);
    l_t0amt_1818    number(20,4);
    l_intnmlpbl     number(20,4);

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

    ----Check han muc BL toan cong ty
    SELECT to_number(varvalue) INTO l_t0amt_max FROM sysvar WHERE varname = 'ADVALCELINE_MAX';
    --SELECT nvl(sum(t0amt),0) INTO l_t0amt_all FROM vw_lngroup_all;
    SELECT nvl(sum(af.advanceline),0) INTO l_t0amt_inday FROM afmast af, cfmast cf
    where af.custid = cf.custid and cf.custatcom = 'Y';-- luu ky tai cong ty ;
    SELECT nvl(sum(toamt),0) INTO l_t0amt_1818 FROM olndetail WHERE duedate = getcurrdate AND status = 'P';
    --SELECT nvl(sum(intnmlpbl),0) INTO l_intnmlpbl FROM lnmast WHERE ftype <> 'DF';

    --IF l_t0amt_all + l_t0amt_inday + l_intnmlpbl + p_txmsg.txfields('10').value > l_t0amt_max THEN
    --Sua CT HM da cap trong ngay + so tien cap <= HM BL toan cty
    IF l_t0amt_inday + p_txmsg.txfields('10').value > l_t0amt_max THEN
        p_err_code := '-180059';
        RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;
    --End Check han muc BL toan cong ty

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
v_usertype VARCHAR2(50);
v_countSymbol NUMBER;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    --update trang thai
    UPDATE olndetail
    SET status ='A',
        PSTATUS='P',
        deal1818 = p_txmsg.txfields(c_deal).value, -- 1.5.8.8|iss:2050
        duedate =getcurrdate,
        time1818=systimestamp,
        tlid1818=p_txmsg.tlid
    WHERE autoid =p_txmsg.txfields('02').value
         AND status ='P';
    plog.debug (pkgctx, '<<END OF fn_txAftAppUpdate');
    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');

      SELECT Usertype INTO v_usertype FROM userlimit WHERE tliduser = p_txmsg.txfields(c_userid).value;
    --Ghi lich thanh toan
        INSERT INTO T0LIMITSCHD(AUTOID, TLID, TYPEALLOCATE, ACCTNO, ALLOCATEDDATE, ALLOCATEDLIMIT, RETRIEVEDLIMIT, refautoid)
        VALUES(SEQ_T0LIMITSCHD.NEXTVAL, p_txmsg.txfields(c_userid).value, v_usertype, p_txmsg.txfields(c_acctno).value,
        p_txmsg.txdate, to_number(p_txmsg.txfields(c_toamt).value), 0,p_txmsg.txfields('02').value);

    --insert vao afserule
    IF p_txmsg.txfields('24').value <> 'ALL' THEN
        FOR rec IN
        (
            SELECT regexp_substr(p_txmsg.txfields('24').value,'[^,;|/]+',1,level) symbol FROM dual
            connect by regexp_substr(p_txmsg.txfields('24').value,'[^,;|/]+',1,level) is not NULL
        )
        LOOP
            --check da ton tai voi tieu tri cung ma CK, tk, loai hinh, trang thai, ngay hieu luc thi ko insert
            SELECT COUNT (*) INTO v_countSymbol FROM afserule afse, sbsecurities sb
            WHERE afse.refid = p_txmsg.txfields('03').value AND afse.afseruletype = 'BL'
                AND sb.codeid = afse.codeid AND sb.symbol = rec.symbol AND afse.status = 'A' AND afse.effdate = getcurrdate;
            IF v_countSymbol = 0 THEN
                INSERT INTO afserule (AUTOID,BORS,TYPORMST,REFID,CODEID,FOA,TERMVAL,TERMRATIO,EFFDATE,EXPDATE,STATUS,AFSERULETYPE)
                VALUES(seq_afserule.NEXTVAL,'B','M',p_txmsg.txfields('03').value,(SELECT codeid FROM sbsecurities WHERE symbol = rec.symbol),'F',0,0,TO_DATE(getcurrdate,'DD/MM/RRRR'),TO_DATE(getcurrdate,'DD/MM/RRRR'),'A','BL');
            END IF;
        END LOOP;

        --log DS CK co the dc mua
        INSERT INTO afseruledetail (REFID,SYMBOL,AFSERULETYPE,MAKER,APPROVE,ACTION,TXDATE,TXTIME)
        VALUES(p_txmsg.txfields('03').value,p_txmsg.txfields('24').value,'BL',p_txmsg.txfields('01').value,p_txmsg.tlid,'GD1818',getcurrdate,to_char(SYSTIMESTAMP,'hh24:mi:ss'));
        --end log DS CK

    END IF;
    --end insert
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
         plog.init ('TXPKS_#1818EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1818EX;
/
