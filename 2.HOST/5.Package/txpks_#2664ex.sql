CREATE OR REPLACE PACKAGE txpks_#2664ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#2664EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      24/08/2012     Created
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

CREATE OR REPLACE PACKAGE BODY txpks_#2664ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_groupid          CONSTANT CHAR(2) := '20';
   c_lnacctno         CONSTANT CHAR(2) := '21';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_afacctno         CONSTANT CHAR(2) := '03';
   c_custname         CONSTANT CHAR(2) := '57';
   c_address          CONSTANT CHAR(2) := '58';
   c_license          CONSTANT CHAR(2) := '59';
   c_amtpaid          CONSTANT CHAR(2) := '34';
   c_intpaid          CONSTANT CHAR(2) := '35';
   c_feepaid          CONSTANT CHAR(2) := '36';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
v_mblock number;
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
    select mblock into v_mblock from cimast where acctno = p_txmsg.txfields('03').value;

    if (v_mblock < p_txmsg.txfields('26').value)
        or ((getbaldeftrfamt(p_txmsg.txfields('03').value) + p_txmsg.txfields('26').value) < (p_txmsg.txfields('34').value + p_txmsg.txfields('35').value + p_txmsg.txfields('36').value)    ) then
           p_err_code:= -400039;
          RETURN -400039;
    end if;
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
V_INDATE DATE;
V_INTNML NUMBER;
V_FEENML NUMBER;
V_INTOVD NUMBER;
V_FEEOVD NUMBER;
V_INTDUE NUMBER;
v_paid  NUMBER;
v_nml   number;
v_ovd   number;
v_LNACCTNO varchar2(20);
v_REMAINLNAMT   NUMBER;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/

 /*   cspks_dfproc.pr_DFPaidDeal(p_txmsg,p_txmsg.txfields('20').value,p_txmsg.txfields('34').value,p_txmsg.txfields('35').value,p_txmsg.txfields('36').value,0,0,p_err_code);

    if p_err_code <> systemnums.C_SUCCESS then
       plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
       RETURN p_err_code;
    end if;
*/

    IF p_txmsg.txfields('26').value >= p_txmsg.txfields('34').value+p_txmsg.txfields('35').value+p_txmsg.txfields('36').value THEN

         UPDATE CIMAST SET
           BALANCE = BALANCE + (ROUND(p_txmsg.txfields('34').value+p_txmsg.txfields('35').value+p_txmsg.txfields('36').value,0)),
           MBLOCK = MBLOCK - (ROUND(p_txmsg.txfields('34').value+p_txmsg.txfields('35').value+p_txmsg.txfields('36').value,0))
        WHERE ACCTNO=p_txmsg.txfields('03').value;

        INSERT INTO CITRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('03').value,'0012',ROUND(p_txmsg.txfields('34').value+p_txmsg.txfields('35').value+p_txmsg.txfields('36').value,0),NULL,'',p_txmsg.deltd,'',seq_CITRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

        INSERT INTO CITRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('03').value,'0053',ROUND(p_txmsg.txfields('34').value+p_txmsg.txfields('35').value+p_txmsg.txfields('36').value,0),NULL,'',p_txmsg.deltd,'',seq_CITRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');
    ELSE
       UPDATE CIMAST SET
            BALANCE = BALANCE + p_txmsg.txfields('26').value,
           MBLOCK = MBLOCK - p_txmsg.txfields('26').value
        WHERE ACCTNO=p_txmsg.txfields('03').value;

      INSERT INTO CITRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('03').value,'0012',p_txmsg.txfields('26').value,NULL,'',p_txmsg.deltd,'',seq_CITRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

      INSERT INTO CITRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('03').value,'0053',p_txmsg.txfields('26').value,NULL,'',p_txmsg.deltd,'',seq_CITRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');
    END IF;



    V_INDATE:= cspks_system.fn_get_sysvar('SYSTEM','CURRDATE');

    V_INTNML:=0;
    V_FEENML:=0;
    V_INTOVD:=0;
    V_FEEOVD:=0;
    V_INTDUE:=0;


    FOR REC1 IN
        (SELECT * FROM LNSCHD
         WHERE ACCTNO = p_txmsg.txfields('21').value  AND REFTYPE ='P')
    LOOP
        if TO_DATE(V_INDATE,'dd/mm/yyyy') - TO_DATE(REC1.OVERDUEDATE,'DD/MM/RRRR') > 0 then
            -- Qua han
            INSERT INTO LNINTTRAN (AUTOID, ACCTNO, INTTYPE, FRDATE, TODATE, ICRULE, IRRATE, INTBAL, INTAMT,CFIRRATE,FEEINTAMT, LNSCHDID)
                VALUES(SEQ_CIINTTRAN.NEXTVAL, REC1.ACCTNO, 'O', REC1.ACRDATE, TO_DATE(V_INDATE,'dd/mm/yyyy'), 'S', REC1.RATE3, REC1.OVD, p_txmsg.txfields('35').value,rec1.cfrate3,0, REC1.AUTOID);
            INSERT INTO LNSCHDLOG(AUTOID, TXNUM, TXDATE, NML, OVD, PAID, INTNMLACR, FEE, INTDUE, INTOVD, INTOVDPRIN, FEEDUE, FEEOVD, INTPAID, FEEPAID,FEEINTOVDPRIN)
                VALUES(REC1.AUTOID, NULL, TO_DATE(V_INDATE,'dd/mm/yyyy'), 0, 0, 0, 0, 0, 0, p_txmsg.txfields('35').value, 0, 0, 0, 0, 0, 0);

            INSERT INTO LNINTTRAN (AUTOID, ACCTNO, INTTYPE, FRDATE, TODATE, ICRULE, IRRATE, INTBAL, INTAMT,CFIRRATE,FEEINTAMT,LNSCHDID)
                VALUES(SEQ_CIINTTRAN.NEXTVAL, REC1.ACCTNO, 'FO', REC1.ACRDATE, TO_DATE(V_INDATE,'dd/mm/yyyy'), 'S', REC1.RATE3, REC1.OVD, 0,rec1.cfrate3,p_txmsg.txfields('36').value, REC1.AUTOID);
            INSERT INTO LNSCHDLOG(AUTOID, TXNUM, TXDATE, NML, OVD, PAID, INTNMLACR, FEE, INTDUE, INTOVD, INTOVDPRIN, FEEDUE, FEEOVD, INTPAID, FEEPAID,FEEINTOVDPRIN)
                VALUES(REC1.AUTOID, NULL, TO_DATE(V_INDATE,'dd/mm/yyyy'), 0, 0, 0, 0, 0, 0, 0, 0, 0, p_txmsg.txfields('36').value, 0, 0, 0);

            UPDATE LNSCHD SET INTOVD = INTOVD + p_txmsg.txfields('35').value,
                FEEINTNMLOVD = FEEINTNMLOVD + p_txmsg.txfields('36').value WHERE AUTOID = REC1.AUTOID;

            V_INTOVD:= p_txmsg.txfields('35').value;
            V_FEEOVD:= p_txmsg.txfields('36').value;
            V_INTDUE:= REC1.INTDUE;
        else
            -- Trong han
            INSERT INTO LNINTTRAN (AUTOID, ACCTNO, INTTYPE, FRDATE, TODATE, ICRULE, IRRATE, INTBAL, INTAMT,CFIRRATE,FEEINTAMT, LNSCHDID)
                VALUES(SEQ_CIINTTRAN.NEXTVAL, REC1.ACCTNO, 'I', REC1.ACRDATE, TO_DATE(V_INDATE,'dd/mm/yyyy'), 'S', REC1.RATE1, REC1.NML, p_txmsg.txfields('35').value,rec1.cfrate1,p_txmsg.txfields('36').value, REC1.AUTOID);
            INSERT INTO LNSCHDLOG(AUTOID, TXNUM, TXDATE, NML, OVD, PAID, INTNMLACR, FEE, INTDUE, INTOVD, INTOVDPRIN, FEEDUE, FEEOVD, INTPAID, FEEPAID,FEEINTNMLACR)
                VALUES(REC1.AUTOID, NULL, TO_DATE(V_INDATE,'dd/mm/yyyy'), 0, 0, 0, p_txmsg.txfields('35').value, 0, 0, 0, 0, 0, 0, 0 ,0,p_txmsg.txfields('36').value);


            UPDATE LNSCHD SET INTNMLACR = INTNMLACR + p_txmsg.txfields('35').value,
                FEEINTNMLACR = FEEINTNMLACR + p_txmsg.txfields('36').value WHERE AUTOID = REC1.AUTOID;

            V_INTNML:= p_txmsg.txfields('35').value;
            V_FEENML:= p_txmsg.txfields('36').value;

        end if;
    END LOOP;


    update citran set ref = p_txmsg.txfields('20').value where txnum = p_txmsg.txnum;


    select least(ovd, p_txmsg.txfields('34').value), greatest(least(nml,  p_txmsg.txfields('34').value - ovd),0),
            least(ovd, p_txmsg.txfields('34').value)+ greatest(least(nml, p_txmsg.txfields('34').value-ovd),0), ACCTNO
    into v_ovd, v_nml,v_paid, v_LNACCTNO
    from lnschd
    where reftype='P' and ACCTNO = p_txmsg.txfields('21').value;


    update lnschd set ovd = ovd - v_ovd,
            nml = nml -  v_nml,
        paid = paid + v_paid
    where reftype='P' and ACCTNO IN (SELECT LNACCTNO FROM DFGROUP WHERE GROUPID= p_txmsg.txfields('20').value );

    INSERT INTO LNSCHDLOG (AUTOID, TXNUM, TXDATE, OVD, NML, PAID)
    SELECT AUTOID, p_txmsg.txnum, TO_DATE(p_txmsg.txdate,'DD/MM/RRRR'), -least(ovd, p_txmsg.txfields('34').value),
         - greatest(least(nml, p_txmsg.txfields('34').value-ovd),0),
         (least(ovd, p_txmsg.txfields('34').value)+ greatest(least(nml, p_txmsg.txfields('34').value-ovd),0)) from lnschd
       where reftype='P' and ACCTNO = p_txmsg.txfields('21').value;


    update lnschd set INTOVD= 0, INTNMLACR=0, INTPAID=INTPAID + p_txmsg.txfields('35').value,
               FEEINTNMLOVD = 0, FEEINTNMLACR =0, feeintpaid= feeintpaid + p_txmsg.txfields('36').value
           where reftype='P' and ACCTNO = p_txmsg.txfields('21').value;

     UPDATE LNSCHDLOG SET INTOVD=- v_INTOVD, INTNMLACR= -v_INTNML, INTPAID= p_txmsg.txfields('35').value,
            FEEINTOVDPRIN= - v_FEEOVD, FEEINTNMLACR = -v_FEENML, feeintpaid= p_txmsg.txfields('36').value
        WHERE (AUTOID, TXNUM, TXDATE) = (SELECT AUTOID, p_txmsg.txnum,TO_DATE(p_txmsg.txdate,'DD/MM/RRRR')
                    FROM LNSCHD  where reftype='P' and ACCTNO = p_txmsg.txfields('21').value );


    update lnschd set PAID = PAID + OVD + NML, OVD= OVD -  OVD, NML= NML - NML
                 where reftype='I' and ACCTNO = p_txmsg.txfields('21').value;

    INSERT INTO LNSCHDLOG (AUTOID, TXNUM, TXDATE, OVD, NML, PAID)
        SELECT AUTOID, p_txmsg.txnum, TO_DATE(p_txmsg.txdate,'DD/MM/RRRR'), -v_INTOVD, -v_INTDUE,
           v_INTOVD + v_INTDUE from lnschd
        where reftype='I' and ACCTNO = p_txmsg.txfields('21').value;


   INSERT INTO LNTRAN (AUTOID,TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,REF,DELTD,ACCTREF,TLTXCD,BKDATE,TRDESC)
    VALUES(SEQ_LNTRAN.NEXTVAL,p_txmsg.txnum,TO_DATE(p_txmsg.txdate,'DD/MM/RRRR'),v_LNACCTNO,'0014',v_paid,NULL,NULL,'N',NULL,p_txmsg.tltxcd,TO_DATE(p_txmsg.txdate,'DD/MM/RRRR'),NULL);

    INSERT INTO LNTRAN (AUTOID,TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,REF,DELTD,ACCTREF,TLTXCD,BKDATE,TRDESC)
    VALUES(SEQ_LNTRAN.NEXTVAL,p_txmsg.txnum,TO_DATE(p_txmsg.txdate,'DD/MM/RRRR'),v_LNACCTNO,'0015',v_nml,NULL,NULL,'N',NULL,p_txmsg.tltxcd,TO_DATE(p_txmsg.txdate,'DD/MM/RRRR'),NULL);

    INSERT INTO LNTRAN (AUTOID,TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,REF,DELTD,ACCTREF,TLTXCD,BKDATE,TRDESC)
    VALUES(SEQ_LNTRAN.NEXTVAL,p_txmsg.txnum,TO_DATE(p_txmsg.txdate,'DD/MM/RRRR'),v_LNACCTNO,'0017',v_ovd,NULL,NULL,'N',NULL,p_txmsg.tltxcd,TO_DATE(p_txmsg.txdate,'DD/MM/RRRR'),NULL);

    INSERT INTO LNTRAN (AUTOID,TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,REF,DELTD,ACCTREF,TLTXCD,BKDATE,TRDESC)
    VALUES(SEQ_LNTRAN.NEXTVAL,p_txmsg.txnum,TO_DATE(p_txmsg.txdate,'DD/MM/RRRR'),v_LNACCTNO,'0041',v_intnml,NULL,NULL,'N',NULL,p_txmsg.tltxcd,TO_DATE(p_txmsg.txdate,'DD/MM/RRRR'),NULL);

   INSERT INTO LNTRAN (AUTOID,TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,REF,DELTD,ACCTREF,TLTXCD,BKDATE,TRDESC)
    VALUES(SEQ_LNTRAN.NEXTVAL,p_txmsg.txnum,TO_DATE(p_txmsg.txdate,'DD/MM/RRRR'),v_LNACCTNO,'0027',v_intovd,NULL,NULL,'N',NULL,p_txmsg.tltxcd,TO_DATE(p_txmsg.txdate,'DD/MM/RRRR'),NULL);

    INSERT INTO LNTRAN (AUTOID,TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,REF,DELTD,ACCTREF,TLTXCD,BKDATE,TRDESC)
    VALUES(SEQ_LNTRAN.NEXTVAL,p_txmsg.txnum,TO_DATE(p_txmsg.txdate,'DD/MM/RRRR'),v_LNACCTNO,'0024',v_intnml+v_intovd,NULL,NULL,'N',NULL,p_txmsg.tltxcd,TO_DATE(p_txmsg.txdate,'DD/MM/RRRR'),NULL);

    INSERT INTO LNTRAN (AUTOID,TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,REF,DELTD,ACCTREF,TLTXCD,BKDATE,TRDESC)
    VALUES(SEQ_LNTRAN.NEXTVAL,p_txmsg.txnum,TO_DATE(p_txmsg.txdate,'DD/MM/RRRR'),v_LNACCTNO,'0083',v_FEEOVD,NULL,NULL,'N',NULL,p_txmsg.tltxcd,TO_DATE(p_txmsg.txdate,'DD/MM/RRRR'),NULL);

    INSERT INTO LNTRAN (AUTOID,TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,REF,DELTD,ACCTREF,TLTXCD,BKDATE,TRDESC)
    VALUES(SEQ_LNTRAN.NEXTVAL,p_txmsg.txnum,TO_DATE(p_txmsg.txdate,'DD/MM/RRRR'),v_LNACCTNO,'0078',v_FEENML,NULL,NULL,'N',NULL,p_txmsg.tltxcd,TO_DATE(p_txmsg.txdate,'DD/MM/RRRR'),NULL);

    INSERT INTO LNTRAN (AUTOID,TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,REF,DELTD,ACCTREF,TLTXCD,BKDATE,TRDESC)
    VALUES(SEQ_LNTRAN.NEXTVAL,p_txmsg.txnum,TO_DATE(p_txmsg.txdate,'DD/MM/RRRR'),v_LNACCTNO,'0090',v_FEEOVD+v_FEENML,NULL,NULL,'N',NULL,p_txmsg.tltxcd,TO_DATE(p_txmsg.txdate,'DD/MM/RRRR'),NULL);


    UPDATE LNMAST SET (prinpaid, prinnml, prinovd, intnmlacr, intovdacr, intnmlovd, intdue, intpaid, feeintnmlovd, feeintovdacr,
        feeintnmlacr, feeintdue, feeintpaid) = (SELECT nvl(paid,0) paid, nvl(nml,0) nml, nvl(ovd,0) ovd, nvl(intnmlacr,0) intnmlacr,
        nvl(INTOVDPRIN,0) INTOVDPRIN, nvl(intovd,0) intovd, nvl(intdue,0) intdue, nvl(intpaid,0) intpaid,nvl(FEEINTNMLOVD,0) FEEINTNMLOVD,
        nvl(FEEINTOVDACR,0) FEEINTOVDACR , nvl(FEEINTNMLACR,0) FEEINTOVDACR, nvl(FEEINTDUE,0) FEEINTOVDACR, nvl(feeintpaid,0) FEEINTOVDACR
    FROM LNSCHD WHERE LNMAST.ACCTNO=LNSCHD.ACCTNO AND LNSCHD.REFTYPE='P' ) WHERE LNMAST.ACCTNO = p_txmsg.txfields('21').value;

     SELECT trunc(lns.nml)+trunc(lns.ovd)+trunc(lns.INTOVDPRIN)+trunc(lns.INTOVD)+trunc(lns.INTDUE)+trunc(lns.INTNMLACR)
            +trunc(lns.FEEINTOVDACR)+trunc(lns.FEEINTNMLOVD)+trunc(lns.FEEINTDUE)+trunc(lns.FEEINTNMLACR)
     INTO v_REMAINLNAMT
     FROM lnschd lns
     WHERE lns.reftype='P' and lns.ACCTNO = p_txmsg.txfields('21').value;
     -- Neu la lan tra cuoi cung thi update vao LNSCHDLOG
     IF v_REMAINLNAMT <1 THEN
        UPDATE lnschdlog SET
            LASTPAID = 'Y'
        WHERE (AUTOID, TXNUM, TXDATE) = (SELECT AUTOID, p_txmsg.txnum,TO_DATE(p_txmsg.txdate,'DD/MM/RRRR')
                            FROM LNSCHD  where reftype='P' and ACCTNO = p_txmsg.txfields('21').value );
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
         plog.init ('TXPKS_#2664EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#2664EX;
/

