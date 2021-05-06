CREATE OR REPLACE PACKAGE txpks_#2290ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#2290EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      04/05/2012     Created
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
CREATE OR REPLACE PACKAGE BODY txpks_#2290ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_afacctno         CONSTANT CHAR(2) := '02';
   c_acctno           CONSTANT CHAR(2) := '03';
   c_symbol           CONSTANT CHAR(2) := '04';
   c_status           CONSTANT CHAR(2) := '05';
   c_trade            CONSTANT CHAR(2) := '06';
   c_dtoclose         CONSTANT CHAR(2) := '10';
   c_dtblocked        CONSTANT CHAR(2) := '11';
   c_description      CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
l_seacctno VARCHAR2(20);
l_count NUMBER;
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

   IF p_txmsg.DELTD ='N' THEN
        UPDATE semastdtl SET status='N' WHERE status='F' AND qttytype IN ('002','007','011') AND acctno = p_txmsg.txfields('03').value;
   ELSE
        UPDATE semastdtl SET status='F' WHERE status='N' AND qttytype IN ('002','007','011') AND acctno = p_txmsg.txfields('03').value;
   END IF;
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
l_RIGHTQTTY NUMBER;
l_RIGHTOFFQTTY NUMBER;
l_CAQTTYRECEIV NUMBER;
l_CAQTTYDB NUMBER;
l_CAAMTRECEIV NUMBER;
l_SEACCTNO VARCHAR2(20);
L_CODEIDWFT VARCHAR2(6);
--1.8.2.5: thue quyen
v_custid VARCHAR2(10);
v_txdate DATE;
v_txnum VARCHAR2(10);
l_caqtty NUMBER;
v_codeid VARCHAR2(10);
v_count NUMBER;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    -- ghi jam so luong CA cho ve theo thu tu uu tien
    l_RIGHTQTTY :=to_number(p_txmsg.txfields('18').value);
    l_RIGHTOFFQTTY :=to_number(p_txmsg.txfields('14').value);
    l_CAQTTYRECEIV :=to_number(p_txmsg.txfields('15').value);
    l_CAQTTYDB :=to_number(p_txmsg.txfields('16').value);
    l_CAAMTRECEIV :=to_number(p_txmsg.txfields('17').value);
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
          
           --1.8.2.5: check tai khoan fo va modefo
           l_caqtty := p_txmsg.txfields('19').value;
           IF l_caqtty > 0 THEN
              FOR rec IN (
                    SELECT * FROM se2247_log
                     WHERE acctno = p_txmsg.txfields(c_acctno).value AND deltd<>'Y'
                       AND qtty > 0
                     ORDER BY autoid DESC
                    )
                LOOP
                       FOR rec1 IN (
                          SELECT * FROM sepitallocate s WHERE s.orgorderid = rec.autoid AND s.txnum = rec.txnum AND s.txdate = rec.txdate
                          )
                        LOOP
                           SELECT COUNT(1) INTO v_count FROM sepitlog WHERE deltd<> 'Y' AND afacctno=rec1.afacctno AND codeid=rec1.codeid AND autoid = rec1.sepitlog_id;
                            IF v_count > 0 THEN
                              UPDATE sepitlog set mapqtty = mapqtty - rec1.qtty ,
                                    status=(case when status='C' then 'N' else status end)
                                    where autoid = rec1.sepitlog_id;
                            ELSE
                              SELECT COUNT(1) INTO v_count FROM SEMAST WHERE ACCTNO=rec1.afacctno||rec1.codeid AND TRADE >0;
                              IF v_count > 0 THEN
                                INSERT INTO sepitlog ( autoid,acctno,txdate,txnum,qtty,mapqtty,codeid,camastid,afacctno,price,pitrate,catype,modifieddate)
                                SELECT seq_sepitlog.nextval,rec1.afacctno||rec1.codeid,rec1.txdate,rec1.txnum,rec1.qtty,0,
                                rec1.codeid, rec1.camastid,rec1.afacctno,price,pitrate,catype,p_txmsg.txdate
                                FROM sepitlog WHERE autoid = rec1.sepitlog_id;
                              ELSE
                                INSERT INTO sepitlog ( autoid,acctno,txdate,txnum,qtty,mapqtty,codeid,camastid,afacctno,price,pitrate,catype,modifieddate)
                                SELECT seq_sepitlog.nextval,p_txmsg.txfields('03').value,p_txmsg.txdate,p_txmsg.txnum,rec1.qtty,0,
                                rec1.codeid, rec1.camastid,p_txmsg.txfields('02').value,price,pitrate,catype,p_txmsg.txdate
                                FROM sepitlog WHERE autoid = rec1.sepitlog_id;
                              END IF;
                            END IF;
                        END LOOP;
                        
                        update se2247_log set deltd = 'Y' where autoid = rec.autoid and txnum = rec.txnum and txdate = rec.txdate;
                        
                        INSERT INTO sepitallocate_hist
                        SELECT s.* FROM sepitallocate s
                        WHERE s.orgorderid = rec.autoid and s.txnum = rec.txnum and s.txdate = rec.txdate;
                        
                        DELETE sepitallocate where orgorderid = rec.autoid and txnum = rec.txnum and txdate = rec.txdate;
                END LOOP;
              END IF;
           --
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
         plog.init ('TXPKS_#2290EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#2290EX;

-- End of DDL Script for Package Body HOSTTEST2.TXPKS_#2290EX
/
