CREATE OR REPLACE PACKAGE txpks_#2244ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#2244EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      13/09/2011     Created
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
CREATE OR REPLACE PACKAGE BODY txpks_#2244ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_codeid           CONSTANT CHAR(2) := '01';
   c_afacctno         CONSTANT CHAR(2) := '02';
   c_acctno           CONSTANT CHAR(2) := '03';
   c_custname         CONSTANT CHAR(2) := '90';
   c_address          CONSTANT CHAR(2) := '91';
   c_license          CONSTANT CHAR(2) := '92';
   c_outward          CONSTANT CHAR(2) := '05';
   c_price            CONSTANT CHAR(2) := '09';
   c_amt              CONSTANT CHAR(2) := '10';
   c_depoblock        CONSTANT CHAR(2) := '06';
   c_parvalue         CONSTANT CHAR(2) := '11';
   c_qtty             CONSTANT CHAR(2) := '12';
   c_trtype           CONSTANT CHAR(2) := '31';
   c_qttytype         CONSTANT CHAR(2) := '14';
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
    --Check loai dien gui VSD = chuyen khoan khac chu so huu trade*block phai bang 0
    If instr(p_txmsg.txfields('97').value,'542') >0  and to_number(p_txmsg.txfields('06').value) * to_number(p_txmsg.txfields('10').value) >0 then
        p_err_code:= '-260042';
        plog.setendsection (pkgctx, 'fn_txAppAutoCheck');
        return errnums.C_BIZ_RULE_INVALID;
    end if ;
    --Check loai dien Tat toan 1 phan hoac CK khac chu so huu thi ko chuyen quyen CA
    --Check loai dien CK tat toan phai chuyen quyen CA
    if p_txmsg.txfields('25').value = '1' and p_txmsg.txfields('97').value in ('0','542') then
        p_err_code:= '-900147';
        plog.setendsection (pkgctx, 'fn_txAppAutoCheck');
        return errnums.C_BIZ_RULE_INVALID;
    elsif p_txmsg.txfields('25').value = '0' and p_txmsg.txfields('97').value in ('598') then
        p_err_code:= '-900148';
        plog.setendsection (pkgctx, 'fn_txAppAutoCheck');
        return errnums.C_BIZ_RULE_INVALID;
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
    l_Count number;
    v_blockqtty number;
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
   /*if  p_txmsg.txfields('06').VALUE > 0 Then
        Begin
            select Count(1) into l_Count from SEMASTDTL
            where acctno = p_txmsg.txfields('03').VALUE
                  and QTTYTYPE = p_txmsg.txfields('14').VALUE
                  and qtty >= p_txmsg.txfields('06').VALUE and autoid =(p_txmsg.txfields('18').value);
        EXCEPTION
        WHEN OTHERS THEN
            l_Count :=0;
        End;

        IF l_count = 0 THEN
            plog.error(pkgctx,'l_lngErrCode: ' || '-900055');
            p_err_code := -900055;
            return errnums.C_SYSTEM_ERROR;
        END IF;
   End if;*/
   if  p_txmsg.txfields('06').VALUE > 0 Then
        Begin
            select sum(qtty-dfqtty) into v_blockqtty from SEMASTDTL
            where acctno = p_txmsg.txfields('03').VALUE
                  and QTTYTYPE = p_txmsg.txfields('14').VALUE
                  group by acctno, qttytype;
                  --and qtty >= p_txmsg.txfields('06').VALUE --and autoid =(p_txmsg.txfields('18').value);
            if v_blockqtty <p_txmsg.txfields('06').VALUE then
                plog.error(pkgctx,'l_lngErrCode: ' || '-900055');
                p_err_code := -900055;
                return errnums.C_SYSTEM_ERROR;
            end if;
        EXCEPTION
        WHEN OTHERS THEN
            --l_Count :=0;
            plog.error(pkgctx,'l_lngErrCode: ' || '-900055');
            p_err_code := -900055;
            return errnums.C_SYSTEM_ERROR;
        End;

        /*IF l_count = 0 THEN
            plog.error(pkgctx,'l_lngErrCode: ' || '-900055');
            p_err_code := -900055;
            return errnums.C_SYSTEM_ERROR;
        END IF;*/
   End if;

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
l_count NUMBER(20);
l_trade NUMBER(20);
l_blocked NUMBER(20);
l_caqtty NUMBER(20);

l_RIGHTQTTY NUMBER;
l_RIGHTOFFQTTY NUMBER;
l_CAQTTYRECEIV NUMBER;
l_CAQTTYDB NUMBER;
l_CAAMTRECEIV NUMBER;
L_SEACCTNO VARCHAR2(20);
L_CODEIDWFT   VARCHAR2(6);

v_dblRIGHTQTTY NUMBER;
v_dblRIGHTOFFQTTY NUMBER;
v_dblCAQTTYRECEIV NUMBER;
v_dblCAQTTYDB NUMBER;
v_dblCAAMTRECEIV NUMBER;

BEGIN
    plog.setbeginsection (pkgctx, 'fn_txPreAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txPreAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC PROCESS HERE. . DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF p_txmsg.deltd = 'Y' THEN
     l_trade:=p_txmsg.txfields('10').value;
     l_blocked:=p_txmsg.txfields('06').value;
     l_caqtty:=p_txmsg.txfields('13').value;

          BEGIN
                   SELECT COUNT(*) INTO L_count
                   FROM sesendout
                   WHERE
                   txdate=p_txmsg.txdate AND TXnum=p_txmsg.txnum
                   AND  ((trade >= l_trade) AND (blocked >=l_blocked) AND(caqtty>=l_caqtty))
                   AND deltd='N';
          EXCEPTION WHEN OTHERS THEN
                    p_err_code:='-200404';
                    plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
          END;
           IF(l_count <=0) THEN
              p_err_code := '-200404'; -- Pre-defined in DEFERROR table
              plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
              RETURN errnums.C_BIZ_RULE_INVALID;
           END IF;
    END IF;
    --Add by ManhTV ghi giam so luong CA theo thu tu uu tien
    IF p_txmsg.deltd <> 'Y' THEN


       l_RIGHTQTTY :=to_number(p_txmsg.txfields('32').value);--Quyen bieu quyet
       l_RIGHTOFFQTTY :=to_number(p_txmsg.txfields('26').value);--Quyen mua
       l_CAQTTYRECEIV :=to_number(p_txmsg.txfields('27').value);--Chung khoan CA cho ve
       l_CAQTTYDB :=to_number(p_txmsg.txfields('28').value);--Chung khoan CA cho giam
       l_CAAMTRECEIV :=to_number(p_txmsg.txfields('29').value);--Tien CA

       plog.debug(pkgctx, 'Begin check sl CA thuc te');
       --Check so luong CA thuc te co du khong
       BEGIN
            SELECT ca.rightoffqtty,ca.caqttyreceiv, ca.caqttydb, ca.caamtreceiv, ca.rightqtty
                  INTO v_dblRIGHTOFFQTTY, v_dblCAQTTYRECEIV, v_dblCAQTTYDB, v_dblCAAMTRECEIV, v_dblRIGHTQTTY
                FROM v_ca_info CA
            WHERE ca.codeid = p_txmsg.txfields('01').value
                  AND  ca.afacctno = p_txmsg.txfields('02').value;
       EXCEPTION WHEN OTHERS THEN
            v_dblRIGHTQTTY := 0;
            v_dblRIGHTOFFQTTY := 0;
            v_dblCAQTTYRECEIV := 0;
            v_dblCAQTTYDB := 0;
            v_dblCAAMTRECEIV :=0;
       END;
       IF(v_dblRIGHTOFFQTTY < l_RIGHTOFFQTTY) THEN
            p_err_code:='-269009';
            plog.setendsection(pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
       END IF;
       plog.debug(pkgctx, 'v_dblCAQTTYRECEIV := '|| v_dblCAQTTYRECEIV || ', l_CAQTTYRECEIV := '|| l_CAQTTYRECEIV);
       IF(v_dblCAQTTYRECEIV < l_CAQTTYRECEIV) THEN
            p_err_code:='-269010';
            plog.setendsection(pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
       END IF;
       IF(v_dblCAQTTYDB < l_CAQTTYDB) THEN
            p_err_code:='-269011';
            plog.setendsection(pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
       END IF;
       IF(v_dblCAAMTRECEIV < l_CAAMTRECEIV) THEN
            p_err_code:='-269012';
            plog.setendsection(pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
       END IF;
       IF(v_dblRIGHTQTTY < l_RIGHTQTTY) THEN
            p_err_code:='-269013';
            plog.setendsection(pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
       END IF;
       plog.debug(pkgctx, 'End check sl CA thuc te');
       FOR rec IN (

                      SELECT schd.status,autoid,camastid,reportdate,catype,
                      schd.codeid, schd.afacctno,(schd.afacctno||schd.codeid) seacctno,
                      (CASE WHEN (schd.catype='014' AND schd.castatus NOT IN ('A','P','N','C') AND schd.duedate >=GETCURRDATE )
                      THEN schd.pbalance ELSE 0 END) RIGHTOFFQTTY,
                      (CASE WHEN (schd.catype='014' AND schd.status IN ('M','S','I','G','O','W') AND isse='N') THEN schd.qtty
                      WHEN (schd.catype IN ('017','020','023') AND schd.status IN ('G','S','I','O','W')  AND isse='N' AND istocodeid='Y') THEN schd.qtty
                      WHEN (schd.catype IN ('011','021') AND schd.status  IN ('G','S','I','O','W') AND isse='N' ) THEN schd.qtty
                      ELSE 0 END) CAQTTYRECEIV,
                      (CASE WHEN (schd.catype IN ('016') AND schd.status  IN ('G','S','I','O','W') AND isse='N') THEN nvl(se.trade,0)
                            WHEN (schd.catype IN ('017','020','023','027') AND schd.status  IN ('G','S','I','O','W') AND isse='N') THEN schd.aqtty
                            ELSE 0 END) CAQTTYDB,
                      (CASE  WHEN (schd.catype IN ('016') AND schd.status  IN ('G','S','I','O','W') AND isse='N' ) THEN 1 ELSE 0 END) ISDBSEALL,
                      (CASE WHEN  (schd.status  IN ('H','S','I','O','W') AND isci='N' AND schd.isexec='Y') THEN schd.amt ELSE 0 END) CAAMTRECEIV,
                      (CASE WHEN (schd.catype IN ('005','006','022') AND schd.status IN ('H','G','S','I','J','O','W')) THEN schd.rqtty ELSE 0 END) RIGHTQTTY,

                      ISWFT,optcodeid
                      FROM
                            (SELECT schd.rqtty,schd.autoid,schd.status,camast.catype,camast.duedate,camast.status castatus,schd.afacctno,camast.codeid,
                            camast.tocodeid, schd.camastid,schd.balance,schd.qtty,schd.aqtty,schd.amt,schd.aamt,schd.pbalance,schd.pqtty ,
                            schd.isci,schd.isexec,reportdate ,'N' istocodeid, NVL(ISWFT,'Y') ISWFT, camast.optcodeid, schd.isse
                            FROM caschd schd ,camast WHERE schd.camastid=camast.camastid AND schd.deltd='N' AND camast.deltd='N' AND camast.status <> 'C'
                            UNION ALL
                            SELECT schd.rqtty,schd.autoid,  schd.status,camast.catype,camast.duedate,camast.status castatus,schd.afacctno, camast.tocodeid codeid,
                            '',schd.camastid,0,schd.qtty,0,0,0,0,0,
                            schd.isci,schd.isexec ,reportdate ,'Y' istocodeid, NVL(ISWFT,'Y') ISWFT, camast.optcodeid, schd.isse
                            FROM caschd schd, camast
                            WHERE schd.camastid=camast.camastid AND camast.catype IN ('017','020','023')AND schd.deltd='N' AND camast.deltd='N' AND camast.status <> 'C'
                            ) SCHD, semast se
                       WHERE schd.codeid=p_txmsg.txfields('01').value
                       AND  schd.afacctno=p_txmsg.txfields('02').value
                       AND se.acctno(+)=(schd.afacctno||schd.codeid)
                      ORDER BY reportdate
                   )
        LOOP
                  /* -- check xem so luong co tron dong khong
                    if(l_RIGHTOFFQTTY <rec.RIGHTOFFQTTY) THEN
                    p_err_code:='-269009';
                    plog.setendsection(pkgctx, 'fn_txPreAppCheck');
                    RETURN errnums.C_BIZ_RULE_INVALID;

                    END IF;
                    if(l_CAQTTYRECEIV <rec.CAQTTYRECEIV) THEN
                    p_err_code:='-269010';
                    plog.setendsection(pkgctx, 'fn_txPreAppCheck');
                    RETURN errnums.C_BIZ_RULE_INVALID;

                    END IF;
                    if(l_CAQTTYDB <rec.CAQTTYDB) THEN
                    p_err_code:='-269011';
                    plog.setendsection(pkgctx, 'fn_txPreAppCheck');
                    RETURN errnums.C_BIZ_RULE_INVALID;

                    END IF;
                    if(l_CAAMTRECEIV <rec.CAAMTRECEIV) THEN
                    p_err_code:='-269012';
                    plog.setendsection(pkgctx, 'fn_txPreAppCheck');
                    RETURN errnums.C_BIZ_RULE_INVALID;

                    END IF;
                    if(l_RIGHTQTTY <rec.RIGHTQTTY) THEN
                    p_err_code:='-269013';
                    plog.setendsection(pkgctx, 'fn_txPreAppCheck');
                    RETURN errnums.C_BIZ_RULE_INVALID;

                    END IF;   */
                    plog.debug(pkgctx, 'Begin update chung khoan CA');
                 IF ( LEAST(rec.RIGHTQTTY,l_RIGHTQTTY)+LEAST(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY)+
                      LEAST(rec.CAQTTYRECEIV,l_CAQTTYRECEIV)+LEAST(rec.CAQTTYDB,l_CAQTTYDB)+
                      LEAST(rec.CAAMTRECEIV,l_CAAMTRECEIV)> 0) THEN
                    plog.debug(pkgctx, 'Begin process chung khoan CA');
                    IF(rec.catype <> '016') THEN
                         if(rec.status <> 'O' ) THEN
                             UPDATE caschd SET status='O',pbalance=pbalance-least(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY),
                                               qtty=qtty-least(rec.CAQTTYRECEIV,l_CAQTTYRECEIV),
                                               rqtty=rqtty-least(rec.RIGHTQTTY,l_RIGHTQTTY),
                                               aqtty=aqtty-least(rec.CAQTTYDB,l_CAQTTYDB),
                                               amt=amt-least(rec.CAAMTRECEIV,l_CAAMTRECEIV),
                                               SENDPBALANCE=SENDPBALANCE+least(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY),
                                               SENDQTTY=SENDQTTY+least(rec.CAQTTYRECEIV,l_CAQTTYRECEIV)
                                               +least(rec.RIGHTQTTY,l_RIGHTQTTY),
                                               SENDAQTTY=SENDAQTTY+least(rec.CAQTTYDB,l_CAQTTYDB),
                                               SENDAMT=SENDAMT+least(rec.CAAMTRECEIV,l_CAAMTRECEIV),
                                               pstatus= pstatus||status

                              WHERE autoid=rec.autoid;
                          ELSE
                              UPDATE caschd SET pbalance=pbalance-least(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY),
                                               qtty=qtty-least(rec.CAQTTYRECEIV,l_CAQTTYRECEIV),
                                               rqtty=rqtty-least(rec.RIGHTQTTY,l_RIGHTQTTY),
                                               aqtty=aqtty-least(rec.CAQTTYDB,l_CAQTTYDB),
                                               amt=amt-least(rec.CAAMTRECEIV,l_CAAMTRECEIV),
                                               SENDPBALANCE=SENDPBALANCE+least(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY),
                                               SENDQTTY=SENDQTTY+least(rec.CAQTTYRECEIV,l_CAQTTYRECEIV)
                                               +least(rec.RIGHTQTTY,l_RIGHTQTTY),
                                               SENDAQTTY=SENDAQTTY+least(rec.CAQTTYDB,l_CAQTTYDB),
                                               SENDAMT=SENDAMT+least(rec.CAAMTRECEIV,l_CAAMTRECEIV)


                              WHERE autoid=rec.autoid;
                          END IF;
                    ELSE -- su kien tra goc lai trai phieu: khong tru o aqtty
                        if(rec.status <> 'O' ) THEN
                             UPDATE caschd SET status='O',pbalance=pbalance-least(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY),
                                               qtty=qtty-least(rec.CAQTTYRECEIV,l_CAQTTYRECEIV),
                                               rqtty=rqtty-least(rec.RIGHTQTTY,l_RIGHTQTTY),
                                               amt=amt-least(rec.CAAMTRECEIV,l_CAAMTRECEIV),
                                               SENDPBALANCE=SENDPBALANCE+least(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY),
                                               SENDQTTY=SENDQTTY+least(rec.CAQTTYRECEIV,l_CAQTTYRECEIV)
                                               +least(rec.RIGHTQTTY,l_RIGHTQTTY),
                                               SENDAQTTY=SENDAQTTY+least(rec.CAQTTYDB,l_CAQTTYDB),
                                               SENDAMT=SENDAMT+least(rec.CAAMTRECEIV,l_CAAMTRECEIV),
                                               pstatus= pstatus||status

                              WHERE autoid=rec.autoid;
                          ELSE
                              UPDATE caschd SET pbalance=pbalance-least(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY),
                                               qtty=qtty-least(rec.CAQTTYRECEIV,l_CAQTTYRECEIV),
                                               rqtty=rqtty-least(rec.RIGHTQTTY,l_RIGHTQTTY),
                                               amt=amt-least(rec.CAAMTRECEIV,l_CAAMTRECEIV),
                                               SENDPBALANCE=SENDPBALANCE+least(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY),
                                               SENDQTTY=SENDQTTY+least(rec.CAQTTYRECEIV,l_CAQTTYRECEIV)
                                               +least(rec.RIGHTQTTY,l_RIGHTQTTY),
                                               SENDAQTTY=SENDAQTTY+least(rec.CAQTTYDB,l_CAQTTYDB),
                                               SENDAMT=SENDAMT+least(rec.CAAMTRECEIV,l_CAAMTRECEIV)


                              WHERE autoid=rec.autoid;
                          END IF;
                    END IF;
                     -- CAT RECEIVING TRONG SEMAST
                      IF(LEAST(rec.CAQTTYRECEIV,l_CAQTTYRECEIV) >0) THEN
                            IF(REC.ISWFT='Y') THEN
                               SELECT CODEID INTO L_CODEIDWFT FROM SBSECURITIES WHERE REFCODEID=REC.CODEID;
                               l_SEACCTNO:=REC.AFACCTNO||L_CODEIDWFT;
                            ELSE
                               l_SEACCTNO:=REC.AFACCTNO||REC.CODEID;
                            END IF;

                            UPDATE SEMAST SET RECEIVING=RECEIVING-LEAST(rec.CAQTTYRECEIV,l_CAQTTYRECEIV)
                            WHERE ACCTNO=l_SEACCTNO;

                             INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                             VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),l_SEACCTNO,
                             '0015',LEAST(rec.CAQTTYRECEIV,l_CAQTTYRECEIV),NULL,NULL,p_txmsg.deltd,NULL,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

                      END IF;
                        -- neu la sk quyen mua: tru o semast cua ck quyen
                      IF(rec.catype='014') THEN
                          UPDATE semast SET trade=trade-least(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY)
                          WHERE acctno=rec.afacctno||rec.optcodeid;
                      END IF;

                        l_RIGHTQTTY :=l_RIGHTQTTY-LEAST(rec.RIGHTQTTY,l_RIGHTQTTY);
                        l_RIGHTOFFQTTY :=l_RIGHTOFFQTTY-LEAST(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY);
                        l_CAQTTYRECEIV :=l_CAQTTYRECEIV-LEAST(rec.CAQTTYRECEIV,l_CAQTTYRECEIV);
                        l_CAQTTYDB :=l_CAQTTYDB-LEAST(rec.CAQTTYDB,l_CAQTTYDB);
                        l_CAAMTRECEIV :=l_CAAMTRECEIV-LEAST(rec.CAAMTRECEIV,l_CAAMTRECEIV);
                        EXIT WHEN (l_RIGHTQTTY+l_RIGHTOFFQTTY+l_CAQTTYRECEIV+l_CAQTTYDB+l_CAAMTRECEIV=0);
                plog.debug(pkgctx, 'End update chung khoan CA');
            END IF;
        END LOOP;
    ELSE
        FOR rec IN (
                 SELECT schd.autoid, schd.codeid, schd.afacctno,(schd.afacctno||schd.codeid) seacctno,
                 schd.SENDPBALANCE  RIGHTOFFQTTY,
                 schd.SENDAMT CAAMTRECEIV,
                 schd.SENDAQTTY CAQTTYDB,
                 (CASE WHEN (ca.catype IN ('005','006','022')) THEN schd.SENDQTTY ELSE 0 END) RIGHTQTTY,
                 (CASE WHEN (ca.catype NOT IN ('005','006','022'))THEN schd.SENDQTTY ELSE 0 END) CAQTTYRECEIV,
                 ca.catype,ISWFT,optcodeid
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
                WHERE schd.status='O' AND schd.camastid=camast.camastid AND camast.catype IN ('017','020','023')AND schd.deltd='N' AND camast.deltd='N' AND camast.status <> 'C'

                 ) schd, camast ca
                  WHERE schd.camastid=ca.camastid
                  ORDER BY reportdate
               )
            LOOP

            if(rec.catype <> '016') THEN
                  UPDATE caschd SET  status=SUBSTR(pstatus,LENGTH(pstatus)),
                                     pbalance=pbalance+least(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY),
                                     qtty=qtty+least(rec.CAQTTYRECEIV,l_CAQTTYRECEIV),
                                     rqtty=rqtty+ least(rec.RIGHTQTTY,l_RIGHTQTTY),
                                     aqtty=aqtty+least(rec.CAQTTYDB,l_CAQTTYDB),
                                     amt=amt+least(rec.CAAMTRECEIV,l_CAAMTRECEIV),
                                     SENDPBALANCE=SENDPBALANCE-least(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY),
                                     SENDQTTY=SENDQTTY-least(rec.CAQTTYRECEIV,l_CAQTTYRECEIV)
                                     -least(rec.RIGHTQTTY,l_RIGHTQTTY),
                                     SENDAQTTY=SENDAQTTY-least(rec.CAQTTYDB,l_CAQTTYDB),
                                     SENDAMT=SENDAMT-least(rec.CAAMTRECEIV,l_CAAMTRECEIV),
                                     pstatus=pstatus||status

                    WHERE autoid=rec.autoid;
              ELSE -- su kien tra goc lai trai phieu ko update o AQTTY
                     UPDATE caschd SET  status=SUBSTR(pstatus,LENGTH(pstatus)),
                                     pbalance=pbalance+least(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY),
                                     qtty=qtty+least(rec.CAQTTYRECEIV,l_CAQTTYRECEIV),
                                     rqtty=rqtty+ least(rec.RIGHTQTTY,l_RIGHTQTTY),
                                     amt=amt+least(rec.CAAMTRECEIV,l_CAAMTRECEIV),
                                     SENDPBALANCE=SENDPBALANCE-least(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY),
                                     SENDQTTY=SENDQTTY-least(rec.CAQTTYRECEIV,l_CAQTTYRECEIV)
                                     -least(rec.RIGHTQTTY,l_RIGHTQTTY),
                                     SENDAQTTY=SENDAQTTY-least(rec.CAQTTYDB,l_CAQTTYDB),
                                     SENDAMT=SENDAMT-least(rec.CAAMTRECEIV,l_CAAMTRECEIV),
                                     pstatus=pstatus||status
                    WHERE autoid=rec.autoid;
              END IF;

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

                    END IF;
                    if(rec.catype='014') THEN
                      UPDATE semast SET trade=trade+least(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY)
                      WHERE acctno=rec.afacctno+rec.optcodeid;
                    END IF;

                l_RIGHTQTTY :=l_RIGHTQTTY-LEAST(rec.RIGHTQTTY,l_RIGHTQTTY);
                l_RIGHTOFFQTTY :=l_RIGHTOFFQTTY-LEAST(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY);
                l_CAQTTYRECEIV :=l_CAQTTYRECEIV-LEAST(rec.CAQTTYRECEIV,l_CAQTTYRECEIV);
                l_CAQTTYDB :=l_CAQTTYDB-LEAST(rec.CAQTTYDB,l_CAQTTYDB);
                l_CAAMTRECEIV :=l_CAAMTRECEIV-LEAST(rec.CAAMTRECEIV,l_CAAMTRECEIV);
                EXIT WHEN (l_RIGHTQTTY+l_RIGHTOFFQTTY+l_CAQTTYRECEIV+l_CAQTTYDB+l_CAAMTRECEIV=0);
            END LOOP;
    END IF;
    --End Add
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
v_caqtty number;
v_nDEPOBLOCK number;

l_RIGHTQTTY NUMBER;
l_RIGHTOFFQTTY NUMBER;
l_CAQTTYRECEIV NUMBER;
l_CAQTTYDB NUMBER;
l_CAAMTRECEIV NUMBER;
--1.8.2.5: thue quyen
v_custid VARCHAR2(10);
v_count NUMBER;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    --1.8.2.5: check tai khoan fo va modefo
    SELECT custid INTO v_custid FROM afmast WHERE acctno = p_txmsg.txfields('02').value;
    v_caqtty:= p_txmsg.txfields('15').value;

    IF p_txmsg.deltd <> 'Y' THEN
       --Add by ManhTV
       l_RIGHTQTTY :=to_number(p_txmsg.txfields('32').value);--Quyen bieu quyet
       l_RIGHTOFFQTTY :=to_number(p_txmsg.txfields('26').value);--Quyen mua
       l_CAQTTYRECEIV :=to_number(p_txmsg.txfields('27').value);--Chung khoan CA cho ve
       l_CAQTTYDB :=to_number(p_txmsg.txfields('28').value);--Chung khoan CA cho giam
       l_CAAMTRECEIV :=to_number(p_txmsg.txfields('29').value);--Tien CA
       --End Add

        /*UPDATE SEMASTDTL
        SET QTTY=QTTY-(p_txmsg.txfields('06').value)
        WHERE autoid =(p_txmsg.txfields('18').value);*/
        v_nDEPOBLOCK:=p_txmsg.txfields('06').value;
        for rec in (
            select * from semastdtl
            where acctno = p_txmsg.txfields('03').value
            and QTTYTYPE=p_txmsg.txfields('14').VALUE and qtty-dfqtty>0
            order by txdate, txnum
        )
        loop
            if v_nDEPOBLOCK > rec.qtty-rec.dfqtty then
                update semastdtl set qtty = qtty - rec.qtty + rec.dfqtty where autoid = rec.autoid;
                v_nDEPOBLOCK:= v_nDEPOBLOCK - (rec.qtty-rec.dfqtty);
            else
                update semastdtl set qtty = qtty - v_nDEPOBLOCK where autoid = rec.autoid;
                v_nDEPOBLOCK:=0;
            end if;
            exit when v_nDEPOBLOCK<=0;
        end loop;


        --Phan bo phan chung khoan quyen, chuyen sang tai khoan nhan chuyen nhuong
       -- v_caqtty:= p_txmsg.txfields('13').value;

        IF v_caqtty >0 THEN
            FOR rec IN (SELECT * FROM (
                            SELECT se.*,NVL(ca.catype,se.catype) cacatype, decode(af.acctno,p_txmsg.txfields('02').value,0,1) lord FROM sepitlog se, afmast af, camast ca
                            WHERE se.afacctno = af.acctno
                              AND se.camastid = ca.camastid (+)
                              AND af.custid = v_custid
                              AND se.codeid = p_txmsg.txfields('01').value
                              AND se.deltd <> 'Y'
                              AND se.qtty - se.mapqtty >0)
                            ORDER BY lord, txdate , pitrate DESC
            )
            LOOP
                IF v_caqtty > rec.qtty - rec.mapqtty THEN

                    UPDATE sepitlog SET mapqtty = mapqtty + rec.qtty - rec.mapqtty WHERE autoid = rec.autoid;

                    INSERT INTO SEPITALLOCATE (Camastid,Afacctno,Codeid,Price,Pitrate,Qtty,Aright,Orgorderid,Txnum,Txdate,Carate,Sepitlog_Id,Catype)
                     VALUES (rec.camastid,rec.afacctno,rec.codeid,rec.price,rec.pitrate,rec.qtty-rec.mapqtty,0,to_char(p_txmsg.txdate,'DD/MM/RRRR')||p_txmsg.txnum,p_txmsg.txnum,p_txmsg.txdate,rec.carate, rec.autoid, rec.cacatype);

                    v_caqtty:=v_caqtty-(rec.qtty-rec.mapqtty);
                ELSE

                    UPDATE sepitlog SET mapqtty = mapqtty + v_caqtty, status ='C' WHERE autoid = rec.autoid;

                    INSERT INTO SEPITALLOCATE (Camastid,Afacctno,Codeid,Price,Pitrate,Qtty,Aright,Orgorderid,Txnum,Txdate,Carate,Sepitlog_Id,Catype)
                     VALUES (rec.camastid,rec.afacctno,rec.codeid,rec.price,rec.pitrate,v_caqtty,0,to_char(p_txmsg.txdate,'DD/MM/RRRR')||p_txmsg.txnum,p_txmsg.txnum,p_txmsg.txdate,rec.carate, rec.autoid, rec.cacatype);

                    v_caqtty:=0;
                END IF;
                EXIT WHEN v_caqtty<=0;
            END LOOP;
          END IF;
          --
        -- insert v?SESENDOUT
          INSERT INTO SESENDOUT
          (AUTOID, TXNUM, TXDATE, ACCTNO, TRADE,
          BLOCKED,CAQTTY,STRADE,SBLOCKED,SCAQTTY,CTRADE,CBLOCKED,CCAQTTY,DELTD,STATUS,RECUSTODYCD,RECUSTNAME,codeid,PRICE,OUTWARD,TRTYPE,QTTYTYPE,
          RIGHTOFFQTTY,CAQTTYRECEIV, CAQTTYDB, CAAMTRECEIV, RIGHTQTTY, VSDMESSAGETYPE)
          VALUES (SEQ_SESENDOUT.NEXTVAL, p_txmsg.txnum,p_txmsg.txdate,p_txmsg.txfields('03').value,
          p_txmsg.txfields('10').value, p_txmsg.txfields('06').value,p_txmsg.txfields('15').value,
          0,0,0,0,0,0,'N','N',p_txmsg.txfields('23').value,p_txmsg.txfields('24').value,p_txmsg.txfields('01').value,p_txmsg.txfields('09').value,p_txmsg.txfields('05').value,
          p_txmsg.txfields('31').value,p_txmsg.txfields('14').value,l_RIGHTOFFQTTY,l_CAQTTYRECEIV,l_CAQTTYDB,l_CAAMTRECEIV,l_RIGHTQTTY, p_txmsg.txfields('97').value);

    Else
        UPDATE SEMASTDTL
        SET QTTY=QTTY+(p_txmsg.txfields('06').value)
        WHERE autoid IN
           (SELECT * FROM
              (SELECT autoid
              FROM semastdtl
              WHERE acctno=  p_txmsg.txfields('03').value
              AND qttytype='002'
              AND deltd='N'
              AND status <> 'C'
              ORDER BY txdate DESC,txnum DESC )
           WHERE rownum=1);
       --1.8.2.5: thue quyen
       IF v_caqtty >0 THEN
         FOR rec IN (
            SELECT * FROM SEPITALLOCATE WHERE txnum=p_txmsg.txnum AND txdate=p_txmsg.txdate
        )
        LOOP
                 SELECT COUNT(1) INTO v_count FROM sepitlog WHERE deltd<> 'Y' AND afacctno=rec.afacctno AND codeid=rec.codeid AND autoid = rec.sepitlog_id;
                  IF v_count > 0 THEN
                    UPDATE sepitlog set mapqtty = mapqtty - rec.qtty ,
                          status=(case when status='C' then 'N' else status end)
                          where autoid = rec.sepitlog_id;
                  ELSE
                    SELECT COUNT(1) INTO v_count FROM SEMAST WHERE ACCTNO=rec.afacctno||rec.codeid AND TRADE >0;
                    IF v_count > 0 THEN
                      INSERT INTO sepitlog ( autoid,acctno,txdate,txnum,qtty,mapqtty,codeid,camastid,afacctno,price,pitrate,catype,modifieddate)
                      SELECT seq_sepitlog.nextval,rec.afacctno||rec.codeid,rec.txdate,rec.txnum,rec.qtty,0,
                      rec.codeid, rec.camastid,rec.afacctno,price,pitrate,catype,p_txmsg.txdate
                      FROM sepitlog WHERE autoid = rec.sepitlog_id;
                    ELSE
                      INSERT INTO sepitlog ( autoid,acctno,txdate,txnum,qtty,mapqtty,codeid,camastid,afacctno,price,pitrate,catype,modifieddate)
                      SELECT seq_sepitlog.nextval,p_txmsg.txfields('03').value,p_txmsg.txdate,p_txmsg.txnum,rec.qtty,0,
                      p_txmsg.txfields('01').value, rec.camastid,p_txmsg.txfields('02').value,price,pitrate,catype,p_txmsg.txdate
                      FROM sepitlog WHERE autoid = rec.sepitlog_id;
                    END IF;
                  END IF;
        END LOOP;
        DELETE SEPITALLOCATE WHERE txnum=p_txmsg.txnum AND txdate=p_txmsg.txdate;
       END IF;
        UPDATE sesendout SET deltd='Y' WHERE txnum=p_txmsg.txnum AND txdate=p_txmsg.txdate;
    End If;

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
         plog.init ('TXPKS_#2244EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#2244EX;
/
