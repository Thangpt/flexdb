CREATE OR REPLACE PACKAGE txpks_#2265ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#2265EX
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

CREATE OR REPLACE PACKAGE BODY txpks_#2265ex
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


BEGIN
    plog.setbeginsection (pkgctx, 'fn_txPreAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txPreAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECaIFIC PROCESS HERE. . DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    l_trade:=p_txmsg.txfields('10').value;
    l_blocked:=p_txmsg.txfields('06').value;
    l_caqtty:=p_txmsg.txfields('13').value;

    if(p_txmsg.deltd <> 'Y') THEN
        BEGIN
                 SELECT COUNT(*) INTO L_count
                 FROM sesendout
                 WHERE autoid=p_txmsg.txfields('18').value
                 AND ((strade < l_trade) OR(sblocked<l_blocked) OR(scaqtty<l_caqtty))
                 AND deltd='N';
        EXCEPTION WHEN OTHERS THEN
                  p_err_code:='-200403';
                  plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
                  RETURN errnums.C_BIZ_RULE_INVALID;
        END;
         IF(l_count >0) THEN
            p_err_code := '-200403'; -- Pre-defined in DEFERROR table
            plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
            RETURN errnums.C_BIZ_RULE_INVALID;
         END IF;
    ELSE-- check khi xoa jao dich
         BEGIN
             SELECT COUNT(*) INTO L_count
             FROM sesendout
             WHERE autoid=p_txmsg.txfields('18').value
             AND ((trade < l_trade) OR(blocked<l_blocked) OR(caqtty<l_caqtty))
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
l_SEACCTNO VARCHAR2(20);
l_CODEIDWFT VARCHAR2(6);
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
    l_RIGHTOFFQTTY :=to_number(p_txmsg.txfields('14').value);--Quyen mua
    l_CAQTTYRECEIV :=to_number(p_txmsg.txfields('15').value);--Chung khoan CA cho ve
    l_CAQTTYDB :=to_number(p_txmsg.txfields('16').value);--Chung khoan CA cho giam
    l_CAAMTRECEIV :=to_number(p_txmsg.txfields('17').value);--Tien CA

    if(p_txmsg.deltd <> 'Y') THEN
        UPDATE sesendout
        SET strade=strade-l_trade ,
            sblocked=sblocked-l_blocked,
            scaqtty=scaqtty-l_caqtty,
            trade=trade+l_trade ,
            blocked=blocked+l_blocked,
            caqtty=caqtty+l_caqtty,
            srightqtty = srightqtty - l_RIGHTQTTY,
            scaamtreceiv = scaamtreceiv - l_CAAMTRECEIV,
            scaqttydb = scaqttydb - l_CAQTTYDB,
            scaqttyreceiv = scaqttyreceiv - l_CAQTTYRECEIV,
            srightoffqtty = srightoffqtty - l_RIGHTOFFQTTY,
            rightqtty = rightqtty + l_RIGHTQTTY,
            caamtreceiv = caamtreceiv + l_CAAMTRECEIV,
            caqttydb = caqttydb + l_CAQTTYDB,
            caqttyreceiv = caqttyreceiv + l_CAQTTYRECEIV,
            rightoffqtty = rightoffqtty + l_RIGHTOFFQTTY,
            status='N'
        WHERE autoid= p_txmsg.txfields('18').value;
    ELSE -- xoa jao dich
        UPDATE sesendout
        SET strade=strade+l_trade ,sblocked=sblocked+l_blocked, scaqtty=scaqtty+l_caqtty,
        trade=trade-l_trade ,blocked=blocked-l_blocked, caqtty=caqtty-l_caqtty,
        srightqtty = srightqtty + l_RIGHTQTTY, scaamtreceiv = scaamtreceiv + l_CAAMTRECEIV,
        scaqttydb = scaqttydb + l_CAQTTYDB,scaqttyreceiv = scaqttyreceiv + l_CAQTTYRECEIV,
        srightoffqtty = srightoffqtty + l_RIGHTOFFQTTY,
        rightqtty = rightqtty - l_RIGHTQTTY, caamtreceiv = caamtreceiv - l_CAAMTRECEIV,
        caqttydb = caqttydb - l_CAQTTYDB,caqttyreceiv = caqttyreceiv - l_CAQTTYRECEIV,
        rightoffqtty = rightoffqtty - l_RIGHTOFFQTTY,
        status='S'
        WHERE autoid= p_txmsg.txfields('18').value;
    END IF;

    /*-- ghi jam so luong CA cho ve theo thu tu uu tien
    l_RIGHTQTTY :=to_number(p_txmsg.txfields('19').value);
    l_RIGHTOFFQTTY :=to_number(p_txmsg.txfields('14').value);
    l_CAQTTYRECEIV :=to_number(p_txmsg.txfields('15').value);
    l_CAQTTYDB :=to_number(p_txmsg.txfields('16').value);
    l_CAAMTRECEIV :=to_number(p_txmsg.txfields('17').value);
     IF p_txmsg.txfields('97').value = '598' THEN
      FOR rec IN (
                 SELECT schd.autoid, schd.codeid, schd.afacctno,(schd.afacctno||schd.codeid) seacctno,
                 schd.SENDPBALANCE  RIGHTOFFQTTY,
                 schd.SENDAMT CAAMTRECEIV,
                 schd.SENDAQTTY CAQTTYDB,
                 (CASE WHEN (ca.catype IN ('005','006','022')) THEN schd.SENDQTTY ELSE 0 END) RIGHTQTTY,
                 (CASE WHEN (ca.catype NOT IN ('005','006','022'))THEN schd.SENDQTTY ELSE 0 END) CAQTTYRECEIV,
                 ca.catype,ca.iswft,ca.optcodeid
                FROM (
                SELECT schd.autoid,schd.status,camast.catype,camast.duedate,camast.status castatus,schd.afacctno,camast.codeid,
                camast.tocodeid, schd.camastid,schd.balance,schd.qtty,schd.aqtty,schd.amt,schd.aamt,schd.pbalance,schd.pqtty ,
                schd.isci,schd.isse ,SENDPBALANCE,SENDAMT,SENDAQTTY,
                (CASE WHEN (catype IN ('017','020','023')) THEN 0 ELSE SENDQTTY END )SENDQTTY
                FROM caschd schd ,camast WHERE schd.status='O' AND schd.camastid=camast.camastid AND schd.deltd='N' AND camast.deltd='N' AND camast.status <> 'C'
                UNION ALL
                SELECT schd.autoid,  schd.status,camast.catype,camast.duedate,camast.status castatus,schd.afacctno, camast.tocodeid codeid,
                '',schd.camastid,0,schd.qtty,0,0,0,0,0,
                schd.isci,schd.isse  ,0,0,0,  SENDQTTY
                FROM caschd schd, camast
                WHERE  schd.status='O' AND  schd.camastid=camast.camastid AND camast.catype IN ('017','020','023')AND schd.deltd='N' AND camast.deltd='N' AND camast.status <> 'C'

                 ) schd, camast ca
                  WHERE schd.camastid=ca.camastid
                  AND  (schd.afacctno|| schd.codeid)=replace(p_txmsg.txfields('03').value,',')

                  ORDER BY reportdate
               )
    LOOP
               if(rec.catype <> '016') THEN

                   UPDATE caschd SET
                                     sendpbalance=sendpbalance-LEAST(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY),
                                     sendqtty=sendqtty-LEAST(rec.CAQTTYRECEIV,l_CAQTTYRECEIV)-LEAST(rec.RIGHTQTTY,l_RIGHTQTTY),
                                     sendaqtty=sendaqtty-LEAST(rec.CAQTTYDB,l_CAQTTYDB),
                                     sendamt=sendamt-LEAST(rec.CAAMTRECEIV,l_CAAMTRECEIV),
                                     pbalance=pbalance+LEAST(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY),
                                     qtty=qtty+LEAST(rec.CAQTTYRECEIV,l_CAQTTYRECEIV),
                                     rqtty=rqtty+LEAST(rec.RIGHTQTTY,l_RIGHTQTTY),
                                     aqtty=aqtty+LEAST(rec.CAQTTYDB,l_CAQTTYDB),amt=amt+LEAST(rec.CAAMTRECEIV,l_CAAMTRECEIV)

                   WHERE autoid=rec.autoid;
               ELSE
                    UPDATE caschd SET
                                     sendpbalance=sendpbalance-LEAST(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY),
                                     sendqtty=sendqtty-LEAST(rec.CAQTTYRECEIV,l_CAQTTYRECEIV)-LEAST(rec.RIGHTQTTY,l_RIGHTQTTY),
                                     sendaqtty=sendaqtty-LEAST(rec.CAQTTYDB,l_CAQTTYDB),
                                     sendamt=sendamt-LEAST(rec.CAAMTRECEIV,l_CAAMTRECEIV),
                                     pbalance=pbalance+LEAST(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY),
                                     qtty=qtty+LEAST(rec.CAQTTYRECEIV,l_CAQTTYRECEIV),
                                     rqtty=rqtty+LEAST(rec.RIGHTQTTY,l_RIGHTQTTY),
                                     amt=amt+LEAST(rec.CAAMTRECEIV,l_CAAMTRECEIV)

                   WHERE autoid=rec.autoid;
               END IF;
               -- chi chuyen trang thai khi tat ca deu da dc revert
               UPDATE caschd SET status=SUBSTR(pstatus,LENGTH(pstatus)),
                                 pstatus=pstatus||status
               WHERE autoid=rec.autoid
               AND sendpbalance+sendqtty+sendaqtty+sendamt=0
               AND NVL(pstatus,'z') <> 'z'  ;


               -- CONG RECEIVING TRONG SEMAST
                    IF(LEAST(rec.CAQTTYRECEIV,l_CAQTTYRECEIV) >0) THEN
                        IF(REC.ISWFT='Y') THEN
                           SELECT CODEID INTO L_CODEIDWFT FROM SBSECURITIES WHERE REFCODEID=REC.CODEID;
                           l_SEACCTNO:=REC.AFACCTNO||L_CODEIDWFT;
                        ELSE
                           l_SEACCTNO:=REC.AFACCTNO||REC.CODEID;
                        END IF;

                        UPDATE SEMAST SET RECEIVING=RECEIVING+LEAST(rec.CAQTTYRECEIV,l_CAQTTYRECEIV)
                        WHERE ACCTNO=l_SEACCTNO;

                         INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                         VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),l_SEACCTNO,
                         '0016',LEAST(rec.CAQTTYRECEIV,l_CAQTTYRECEIV),NULL,NULL,p_txmsg.deltd,NULL,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

                    END IF;
                -- cong semast cua ck quyen
                if(rec.catype='014') THEN
                  UPDATE semast SET trade=trade+LEAST(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY)
                  WHERE acctno=rec.afacctno+rec.optcodeid;
                END IF;
                l_RIGHTQTTY :=l_RIGHTQTTY-LEAST(rec.RIGHTQTTY,l_RIGHTQTTY);
                l_RIGHTOFFQTTY :=l_RIGHTOFFQTTY-LEAST(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY);
                l_CAQTTYRECEIV :=l_CAQTTYRECEIV-LEAST(rec.CAQTTYRECEIV,l_CAQTTYRECEIV);
                l_CAQTTYDB :=l_CAQTTYDB-LEAST(rec.CAQTTYDB,l_CAQTTYDB);
                l_CAAMTRECEIV :=l_CAAMTRECEIV-LEAST(rec.CAAMTRECEIV,l_CAAMTRECEIV);
                EXIT WHEN (l_RIGHTQTTY+l_RIGHTOFFQTTY+l_CAQTTYRECEIV+l_CAQTTYDB+l_CAAMTRECEIV=0);

    END LOOP;
    END IF;*/
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
         plog.init ('TXPKS_#2265EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#2265EX;
/

