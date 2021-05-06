CREATE OR REPLACE PACKAGE txpks_#2266ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#2266EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      27/08/2012     Created
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

CREATE OR REPLACE PACKAGE BODY txpks_#2266ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_autoid           CONSTANT CHAR(2) := '18';
   c_custodycd        CONSTANT CHAR(2) := '05';
   c_afacctno         CONSTANT CHAR(2) := '02';
   c_acctno           CONSTANT CHAR(2) := '03';
   c_custname         CONSTANT CHAR(2) := '90';
   c_symbol           CONSTANT CHAR(2) := '07';
   c_trade            CONSTANT CHAR(2) := '10';
   c_blocked          CONSTANT CHAR(2) := '06';
   c_caqtty           CONSTANT CHAR(2) := '13';
   c_qtty             CONSTANT CHAR(2) := '12';
   c_recustodycd      CONSTANT CHAR(2) := '23';
   c_recustname       CONSTANT CHAR(2) := '24';
   c_desc             CONSTANT CHAR(2) := '30';
   c_codeid           CONSTANT CHAR(2) := '01';
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
l_count NUMBER(20);
l_trade NUMBER(20);
l_blocked NUMBER(20);
l_caqtty NUMBER(20);

l_RIGHTQTTY NUMBER;
l_RIGHTOFFQTTY NUMBER;
l_CAQTTYRECEIV NUMBER;
l_CAQTTYDB NUMBER;
l_CAAMTRECEIV NUMBER;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txPreAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txPreAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC PROCESS HERE. . DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    l_trade:=p_txmsg.txfields('10').value;
    l_blocked:=p_txmsg.txfields('06').value;
    l_caqtty:=p_txmsg.txfields('13').value;

    l_RIGHTQTTY :=to_number(p_txmsg.txfields('19').value);--Quyen bieu quyet
    l_RIGHTOFFQTTY :=to_number(p_txmsg.txfields('20').value);--Quyen mua
    l_CAQTTYRECEIV :=to_number(p_txmsg.txfields('21').value);--Chung khoan CA cho ve
    l_CAQTTYDB :=to_number(p_txmsg.txfields('22').value);--Chung khoan CA cho giam
    l_CAAMTRECEIV :=to_number(p_txmsg.txfields('17').value);--Tien CA

    if(p_txmsg.deltd <> 'Y') THEN
        BEGIN
           SELECT COUNT(*) INTO L_count
           FROM sesendout
           WHERE autoid=p_txmsg.txfields('18').value
           AND ((strade < l_trade) OR(sblocked<l_blocked) OR(scaqtty<l_caqtty) OR
                (srightoffqtty < l_RIGHTOFFQTTY) OR (scaqttyreceiv < l_CAQTTYRECEIV) OR
                (scaqttydb < l_CAQTTYDB) OR (scaamtreceiv < l_CAAMTRECEIV) OR
                (srightqtty < l_RIGHTQTTY))
           AND deltd='N';
        EXCEPTION WHEN OTHERS THEN
                      p_err_code:='-200402';
                      plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
                      RETURN errnums.C_BIZ_RULE_INVALID;
         END;
       IF(l_count >0) THEN
          p_err_code := '-200402'; -- Pre-defined in DEFERROR table
          plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
          RETURN errnums.C_BIZ_RULE_INVALID;
       END IF;
    ELSE -- xoa jao dich
       BEGIN
             SELECT COUNT(*) INTO L_count
             FROM sesendout
             WHERE autoid=p_txmsg.txfields('18').value
             AND ((ctrade < l_trade) OR(cblocked<l_blocked) OR(ccaqtty<l_caqtty) OR
                    (crightoffqtty < l_RIGHTOFFQTTY) OR (ccaqttyreceiv < l_CAQTTYRECEIV) OR
                    (ccaqttydb < l_CAQTTYDB) OR (ccaamtreceiv < l_CAAMTRECEIV) OR
                    (crightqtty < l_RIGHTQTTY))
             AND deltd='N';
         EXCEPTION WHEN OTHERS THEN
                    p_err_code:='-200404';
                    plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
         END;
         IF(l_count >0) THEN
            p_err_code := '-200404'; -- Pre-defined in DEFERROR table
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
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
       plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txPreAppUpdate;

FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
l_trade NUMBER(20);
l_blocked NUMBER(20);
l_caqtty NUMBER(20);

l_RIGHTQTTY NUMBER;
l_RIGHTOFFQTTY NUMBER;
l_CAQTTYRECEIV NUMBER;
l_CAQTTYDB NUMBER;
l_CAAMTRECEIV NUMBER;
l_seacctno varchar2(30);
v_count NUMBER;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    l_trade:=p_txmsg.txfields('10').value;
    l_blocked:=p_txmsg.txfields('06').value;
    l_caqtty:=p_txmsg.txfields('13').value;

    l_RIGHTQTTY :=to_number(p_txmsg.txfields('19').value);--Quyen bieu quyet
    l_RIGHTOFFQTTY :=to_number(p_txmsg.txfields('20').value);--Quyen mua
    l_CAQTTYRECEIV :=to_number(p_txmsg.txfields('21').value);--Chung khoan CA cho ve
    l_CAQTTYDB :=to_number(p_txmsg.txfields('22').value);--Chung khoan CA cho giam
    l_CAAMTRECEIV :=to_number(p_txmsg.txfields('17').value);--Tien CA
    if(p_txmsg.deltd <> 'Y') THEN
        UPDATE sesendout
        SET strade=strade-l_trade ,sblocked=sblocked-l_blocked, scaqtty=scaqtty-l_caqtty,
        ctrade=ctrade+l_trade ,cblocked=cblocked+l_blocked, ccaqtty=ccaqtty+l_caqtty,

        srightoffqtty = srightoffqtty - l_RIGHTOFFQTTY,scaqttyreceiv= scaqttyreceiv - l_CAQTTYRECEIV,
        scaqttydb = scaqttydb -l_CAQTTYDB,scaamtreceiv=scaamtreceiv - l_CAAMTRECEIV,srightqtty =srightqtty-l_RIGHTQTTY,
        crightoffqtty= crightoffqtty + l_RIGHTOFFQTTY,ccaqttyreceiv = ccaqttyreceiv +l_CAQTTYRECEIV,
        ccaqttydb = ccaqttydb +l_CAQTTYDB,ccaamtreceiv=ccaamtreceiv +l_CAAMTRECEIV,crightqtty = crightqtty +l_RIGHTQTTY,
        status='C'
        WHERE autoid= p_txmsg.txfields('18').value;
    ELSE
        UPDATE sesendout
        SET strade=strade+l_trade ,sblocked=sblocked+l_blocked, scaqtty=scaqtty+l_caqtty,
        ctrade=ctrade-l_trade ,cblocked=cblocked-l_blocked, ccaqtty=ccaqtty-l_caqtty,
        srightoffqtty = srightoffqtty + l_RIGHTOFFQTTY,scaqttyreceiv= scaqttyreceiv + l_CAQTTYRECEIV,
        scaqttydb = scaqttydb +l_CAQTTYDB,scaamtreceiv=scaamtreceiv + l_CAAMTRECEIV,srightqtty =srightqtty + l_RIGHTQTTY,
        crightoffqtty= crightoffqtty - l_RIGHTOFFQTTY,ccaqttyreceiv = ccaqttyreceiv - l_CAQTTYRECEIV,
        ccaqttydb = ccaqttydb - l_CAQTTYDB,ccaamtreceiv=ccaamtreceiv - l_CAAMTRECEIV,crightqtty = crightqtty - l_RIGHTQTTY,
        status='S'
        WHERE autoid= p_txmsg.txfields('18').value;
    END IF;
    -- ghi jam so luong CA cho ve theo thu tu uu tien
    l_RIGHTQTTY :=to_number(p_txmsg.txfields('19').value);
    l_RIGHTOFFQTTY :=to_number(p_txmsg.txfields('20').value);
    l_CAQTTYRECEIV :=to_number(p_txmsg.txfields('21').value);
    l_CAQTTYDB :=to_number(p_txmsg.txfields('22').value);
    l_CAAMTRECEIV :=to_number(p_txmsg.txfields('17').value);
    l_seacctno:=p_txmsg.txfields('03').value;
    IF p_txmsg.txfields('97').value = '598' THEN
    if(p_txmsg.deltd <> 'Y') THEN
          FOR rec IN (
                     SELECT schd.autoid, schd.codeid, schd.afacctno,(schd.afacctno||schd.codeid) seacctno,
                     schd.SENDPBALANCE  RIGHTOFFQTTY,
                     schd.SENDAMT CAAMTRECEIV,
                     schd.SENDAQTTY CAQTTYDB,
                     (CASE WHEN (ca.catype IN ('005','006','022')) THEN schd.SENDQTTY ELSE 0 END) RIGHTQTTY,
                     (CASE WHEN (ca.catype NOT IN ('005','006','022'))THEN schd.SENDQTTY ELSE 0 END) CAQTTYRECEIV
                    FROM (
                    SELECT schd.autoid,schd.status,camast.catype,camast.duedate,camast.status castatus,schd.afacctno,camast.codeid,
                    camast.tocodeid, schd.camastid,schd.balance,schd.qtty,schd.aqtty,schd.amt,schd.aamt,schd.pbalance,schd.pqtty ,
                    schd.isci,schd.isse ,SENDPBALANCE,SENDAMT,SENDAQTTY,
                    (CASE WHEN (catype IN ('017','020','023')) THEN 0 ELSE SENDQTTY END )SENDQTTY
                    FROM caschd schd ,camast WHERE schd.status='O' AND schd.camastid=camast.camastid AND schd.deltd='N' AND camast.deltd='N'
                    UNION ALL
                    SELECT schd.autoid,  schd.status,camast.catype,camast.duedate,camast.status castatus,schd.afacctno, camast.tocodeid codeid,
                    '',schd.camastid,0,schd.qtty,0,0,0,0,0,
                    schd.isci,schd.isse  ,0,0,0,  SENDQTTY
                    FROM caschd schd, camast
                    WHERE  schd.status='O' AND schd.camastid=camast.camastid AND camast.catype IN ('017','020','023')AND schd.deltd='N' AND camast.deltd='N'

                     ) schd, camast ca
                      WHERE schd.camastid=ca.camastid
                      AND (schd.afacctno||schd.codeid)=l_seacctno
                      ORDER BY reportdate
                   )
        LOOP
                   UPDATE caschd SET sendpbalance=sendpbalance-rec.RIGHTOFFQTTY,
                                     sendqtty=sendqtty-rec.CAQTTYRECEIV-rec.RIGHTQTTY,
                                     sendaqtty=sendaqtty-rec.CAQTTYDB,sendamt=sendamt-rec.CAAMTRECEIV,
                                     cutpbalance=cutpbalance+rec.RIGHTOFFQTTY,
                                     cutqtty=cutqtty+rec.CAQTTYRECEIV+rec.RIGHTQTTY,
                                     cutaqtty=cutaqtty+rec.CAQTTYDB,cutamt=cutamt+rec.CAAMTRECEIV
                    WHERE autoid=rec.autoid;
                    l_RIGHTQTTY :=l_RIGHTQTTY-rec.RIGHTQTTY;
                    l_RIGHTOFFQTTY :=l_RIGHTOFFQTTY-rec.RIGHTOFFQTTY;
                    l_CAQTTYRECEIV :=l_CAQTTYRECEIV-rec.CAQTTYRECEIV;
                    l_CAQTTYDB :=l_CAQTTYDB-rec.CAQTTYDB;
                    l_CAAMTRECEIV :=l_CAAMTRECEIV-rec.CAAMTRECEIV;
                    EXIT WHEN (l_RIGHTQTTY+l_RIGHTOFFQTTY+l_CAQTTYRECEIV+l_CAQTTYDB+l_CAAMTRECEIV=0);

        END LOOP;
    l_seacctno := p_txmsg.txfields('03').value;
    ELSE -- xoa jao dich
     --check xoa gd
    IF p_txmsg.deltd = 'Y' THEN
        SELECT COUNT (*) INTO v_count FROM cfmast cf WHERE cf.status = 'C' AND cf.custodycd = p_txmsg.txfields('88').value;
        IF v_count > 0 THEN
            p_err_code := '-100151'; -- double refnum.
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;
        SELECT COUNT (*) INTO v_count FROM afmast af WHERE af.status = 'C' AND af.acctno = p_txmsg.txfields('02').value;
        IF v_count > 0 THEN
            p_err_code := '-100152'; -- double refnum.
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;
    END IF;
    --End check xoa
       FOR rec IN (
                     SELECT schd.autoid, schd.codeid, schd.afacctno,(schd.afacctno||schd.codeid) seacctno,
                     schd.CUTPBALANCE  RIGHTOFFQTTY,
                     schd.CUTAMT CAAMTRECEIV,
                     schd.CUTAQTTY CAQTTYDB,
                     (CASE WHEN (ca.catype IN ('005','006','022')) THEN schd.CUTQTTY ELSE 0 END) RIGHTQTTY,
                     (CASE WHEN (ca.catype NOT IN ('005','006','022'))THEN schd.CUTQTTY ELSE 0 END) CAQTTYRECEIV
                    FROM (
                    SELECT schd.autoid,schd.status,camast.catype,camast.duedate,camast.status castatus,schd.afacctno,camast.codeid,
                    camast.tocodeid, schd.camastid,schd.balance,schd.qtty,schd.aqtty,schd.amt,schd.aamt,schd.pbalance,schd.pqtty ,
                    schd.isci,schd.isse ,CUTPBALANCE,CUTAMT,CUTAQTTY,
                    (CASE WHEN (catype IN ('017','020','023')) THEN 0 ELSE CUTQTTY END )CUTQTTY
                    FROM caschd schd ,camast WHERE schd.status='O' AND schd.camastid=camast.camastid AND schd.deltd='N' AND camast.deltd='N'
                    UNION ALL
                    SELECT schd.autoid,  schd.status,camast.catype,camast.duedate,camast.status castatus,schd.afacctno, camast.tocodeid codeid,
                    '',schd.camastid,0,schd.qtty,0,0,0,0,0,
                    schd.isci,schd.isse  ,0,0,0,  CUTQTTY
                    FROM caschd schd, camast
                    WHERE  schd.status='O' AND schd.camastid=camast.camastid AND camast.catype IN ('017','020','023')AND schd.deltd='N' AND camast.deltd='N'

                     ) schd, camast ca
                      WHERE schd.camastid=ca.camastid
                      AND  (schd.afacctno||schd.codeid)=l_seacctno
                      ORDER BY reportdate
                   )
        LOOP
                   UPDATE caschd SET sendpbalance=sendpbalance+rec.RIGHTOFFQTTY,
                                     sendqtty=sendqtty+rec.CAQTTYRECEIV+rec.RIGHTQTTY,
                                     sendaqtty=sendaqtty+rec.CAQTTYDB,sendamt=sendamt+rec.CAAMTRECEIV,
                                     cutpbalance=cutpbalance-rec.RIGHTOFFQTTY,
                                     cutqtty=cutqtty-rec.CAQTTYRECEIV-rec.RIGHTQTTY,
                                     cutaqtty=cutaqtty-rec.CAQTTYDB,cutamt=cutamt-rec.CAAMTRECEIV
                    WHERE autoid=rec.autoid;
                    l_RIGHTQTTY :=l_RIGHTQTTY-rec.RIGHTQTTY;
                    l_RIGHTOFFQTTY :=l_RIGHTOFFQTTY-rec.RIGHTOFFQTTY;
                    l_CAQTTYRECEIV :=l_CAQTTYRECEIV-rec.CAQTTYRECEIV;
                    l_CAQTTYDB :=l_CAQTTYDB-rec.CAQTTYDB;
                    l_CAAMTRECEIV :=l_CAAMTRECEIV-rec.CAAMTRECEIV;
                    EXIT WHEN (l_RIGHTQTTY+l_RIGHTOFFQTTY+l_CAQTTYRECEIV+l_CAQTTYDB+l_CAAMTRECEIV=0);
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
         plog.init ('TXPKS_#2266EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#2266EX;
/

