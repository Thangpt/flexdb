CREATE OR REPLACE PACKAGE txpks_#8842ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#8842EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      22/10/2012     Created
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

CREATE OR REPLACE PACKAGE BODY txpks_#8842ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_orderid          CONSTANT CHAR(2) := '01';
   c_custodycd        CONSTANT CHAR(2) := '02';
   c_afacctno         CONSTANT CHAR(2) := '03';
   c_ciacctno         CONSTANT CHAR(2) := '04';
   c_custbank         CONSTANT CHAR(2) := '05';
   c_rrtype           CONSTANT CHAR(2) := '44';
   c_stautoid         CONSTANT CHAR(2) := '09';
   c_adlautoid        CONSTANT CHAR(2) := '19';
   c_txdate           CONSTANT CHAR(2) := '20';
   c_cleardate        CONSTANT CHAR(2) := '21';
   c_codeid           CONSTANT CHAR(2) := '07';
   c_symbol           CONSTANT CHAR(2) := '08';
   c_exectype         CONSTANT CHAR(2) := '22';
   c_matchamt         CONSTANT CHAR(2) := '14';
   c_aamt             CONSTANT CHAR(2) := '10';
   c_feeamt           CONSTANT CHAR(2) := '11';
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
    l_margintype    varchar2(1);
    l_pp            NUMBER;
    l_ADVT0AMT      NUMBER;
    l_aamt          number;
    l_MSVSDADVAMT   NUMBER;
    l_MBLOCK        NUMBER;
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
    -- Kiem tra suc mua + BLTM cua tieu khoan phai du de hoan tra ung truoc
    SELECT mr.mrtype, CI.mblock
    INTO l_margintype, l_MBLOCK
    FROM afmast mst, aftype af, mrtype mr, CIMAST CI
    WHERE mst.actype = af.actype
        AND af.mrtype = mr.actype
        AND MST.acctno = CI.afacctno
        AND mst.acctno = p_txmsg.txfields(c_afacctno).value;
    -- Lay suc mua cua TK
    SELECT getavlpp(p_txmsg.txfields(c_afacctno).value) INTO l_pp FROM dual;
    -- Lay han muc BL con lai trong ngay
    l_ADVT0AMT:=0;

    IF l_margintype IN ('S','T') THEN

        FOR REC IN
            (
                SELECT nvl(adv.advt0amt,0)ADVT0AMT
                FROM VW_ACCOUNT_ADVT0 adv
                WHERE adv.acctno = p_txmsg.txfields(c_afacctno).value
            )
        LOOP
            l_ADVT0AMT:= NVL( REC.ADVT0AMT,0);
        END LOOP ;

        /*SELECT NVL(AF.advanceline,0)
        INTO l_ADVT0AMT
        FROM AFMAST AF WHERE acctno = p_txmsg.txfields(c_afacctno).value;*/

    ELSE
        l_ADVT0AMT := 0;
    END IF;

    l_MSVSDADVAMT := 0;
    -- Lay len so tien UT doi voi lenh ban cam co VSD
    IF p_txmsg.txfields(c_exectype).value = 'MS' THEN
        SELECT nvl(sum(adl.aamt - round(ads.feeamt/(ads.amt+ads.feeamt)*adl.aamt)),0) adamt
        INTO l_MSVSDADVAMT
        FROM (SELECT * FROM odmapext UNION ALL SELECT * FROM odmapexthist) odm,
            adschd ads, adschddtl adl, vw_tllog_all tlg, vw_tllogfld_all tlfld
        WHERE odm.orderid = adl.orderid AND odm.isvsd = 'Y'
            AND ads.txdate = adl.txdate AND ads.txnum = adl.txnum
            AND tlg.txdate = tlfld.txdate AND tlg.txnum = tlfld.txnum
            AND tlg.txdate = ads.txdate AND tlg.txnum = ads.txnum
            AND tlfld.fldcd = '60' AND tlfld.cvalue = '1'
            AND adl.orderid = p_txmsg.txfields(c_orderid).value
            AND adl.autoid = to_number(p_txmsg.txfields(c_adlautoid).value);
    END IF;
    IF l_MBLOCK < l_MSVSDADVAMT THEN
        l_MSVSDADVAMT := l_MBLOCK;
    END IF;

    -- Ko cho hoan ung neu thieu tien
    IF NOT (GREATEST(to_number(l_PP),0) + l_ADVT0AMT + l_MSVSDADVAMT >= to_number(ROUND(p_txmsg.txfields(c_aamt).value-p_txmsg.txfields(c_feeamt).value,0))) THEN
        p_err_code := '-400116';
        plog.setendsection (pkgctx, 'fn_txAftAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
     END IF;
    -- khong hoan ung qua so tien da ung con lai cua lenh

    select aamt-paidamt INTO l_aamt  from stschd where orgorderid =  p_txmsg.txfields('01').value and duetype ='RM' AND DELTD <>'Y';

    IF p_txmsg.txfields(c_aamt).value > l_aamt   THEN
        p_err_code := '-400220';
        plog.setendsection (pkgctx, 'fn_txAftAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
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
    l_count NUMBER;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txPreAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txPreAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC PROCESS HERE. . DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    -- Kiem tra da co GD nao dc duyet hay chua, neu da co GD 8842 thuc hien roi thi ko cho thuc hien nua
    l_count := 0;
    SELECT count(tl.tltxcd)
    INTO l_count
    FROM tllog tl, tllogfld tlf, tllogfld tlf2
    WHERE tl.txdate = tlf.txdate AND tl.txnum = tlf.txnum
        AND tl.txdate = tlf2.txdate AND tl.txnum = tlf2.txnum
        and tl.tltxcd = '8842' AND tlf.fldcd = c_orderid
        AND tl.msgacct = p_txmsg.txfields(c_afacctno).value
        AND tlf.cvalue = p_txmsg.txfields(c_orderid).value
        AND tlf2.nvalue = to_number(p_txmsg.txfields(c_adlautoid).value);
    IF l_count > 0 THEN
        p_err_code := errnums.C_SA_TRANS_APPROVED;
        plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
        RETURN errnums.C_BIZ_RULE_INVALID;
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
    l_count         NUMBER;
    l_MSVSDADVAMT   NUMBER;
    l_MBLOCK        NUMBER;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    -- Neu lenh hoan ung la ban cam co VSD thi ghi nhan giam so tien cam co VSD
    l_MSVSDADVAMT := 0;
    -- Lay len so tien UT doi voi lenh ban cam co VSD
    IF p_txmsg.txfields(c_exectype).value = 'MS' THEN
        -- Lay so tien MBLOCK hien tai
        SELECT ci.mblock
        INTO l_MBLOCK
        FROM cimast ci
        WHERE ci.afacctno = p_txmsg.txfields(c_afacctno).value;
        SELECT nvl(sum(adl.aamt - round(ads.feeamt/(ads.amt+ads.feeamt)*adl.aamt)),0) adamt
        INTO l_MSVSDADVAMT
        FROM (SELECT * FROM odmapext UNION ALL SELECT * FROM odmapexthist) odm,
            adschd ads, adschddtl adl, vw_tllog_all tlg, vw_tllogfld_all tlfld
        WHERE odm.orderid = adl.orderid AND odm.isvsd = 'Y'
            AND ads.txdate = adl.txdate AND ads.txnum = adl.txnum
            AND tlg.txdate = tlfld.txdate AND tlg.txnum = tlfld.txnum
            AND tlg.txdate = ads.txdate AND tlg.txnum = ads.txnum
            AND tlfld.fldcd = '60' AND tlfld.cvalue = '1'
            AND adl.orderid = p_txmsg.txfields(c_orderid).value
            AND adl.autoid = to_number(p_txmsg.txfields(c_adlautoid).value);

        IF l_MBLOCK < l_MSVSDADVAMT THEN
            l_MSVSDADVAMT := l_MBLOCK;
        END IF;

        IF l_MSVSDADVAMT > 0 THEN
            -- Cap nhat CIMAST
            UPDATE cimast SET
                balance = balance + l_MSVSDADVAMT,
                mblock = mblock - l_MSVSDADVAMT
            WHERE acctno = p_txmsg.txfields(c_afacctno).value;
            -- Ghi nhan CITRAN
            -- 0012: Credit BALANCE
            INSERT INTO CITRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields (c_afacctno).value,'0012',l_MSVSDADVAMT,NULL,p_txmsg.txfields ('01').value,p_txmsg.deltd,p_txmsg.txfields ('01').value,seq_CITRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');
            -- 0053: Debit MBLOCK
            INSERT INTO CITRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields (c_afacctno).value,'0053',l_MSVSDADVAMT,NULL,p_txmsg.txfields ('01').value,p_txmsg.deltd,p_txmsg.txfields ('01').value,seq_CITRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

        END IF;
    END IF;

    -- Cap nhat tung giao dich ung truoc
    FOR rec IN
    (
        SELECT ADL.txdate, ADL.txnum, ADL.aamt
        FROM adschddtl ADL
        WHERE ADL.orderid = p_txmsg.txfields('01').value
            AND adl.autoid = to_number(p_txmsg.txfields(c_adlautoid).value)
        ORDER BY ADL.txdate, ADL.txnum
    )
    LOOP
        -- UPDATE ADSCHD
        UPDATE ADSCHD SET
            PAIDAMT = PAIDAMT + REC.aamt,
            PAIDDATE = p_txmsg.txdate
        WHERE TXDATE = REC.txdate AND TXNUM = REC.txnum;

        -- UPDATE STSCHD
        UPDATE STSCHD SET
            PAIDAMT = PAIDAMT + REC.aamt
        WHERE DUETYPE = 'RM' AND ORGORDERID = p_txmsg.txfields('01').value;

        -- UPDATE ADSCHDDTL
        UPDATE adschddtl SET
            DELTD = 'Y'
        WHERE TXDATE = REC.txdate AND TXNUM = REC.txnum AND orderid = p_txmsg.txfields('01').value;

    END LOOP;

    -- Kiem tra neu da hoan ung het thi cap nhat ODMAST
    l_count := 0;
    SELECT count(autoid)
    INTO l_count
    FROM adschddtl ADL
    WHERE ADL.orderid = p_txmsg.txfields(c_orderid).value;
    IF l_count = 0 THEN
        UPDATE ODMAST SET
            ERRSTS = 'A', LAST_CHANGE = SYSTIMESTAMP
        WHERE ORDERID=p_txmsg.txfields('01').value;
        INSERT INTO ODTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
        VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('01').value,'0051',0,'A','',p_txmsg.deltd,'',seq_ODTRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');
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
         plog.init ('TXPKS_#8842EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#8842EX;
/

