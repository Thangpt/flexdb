CREATE OR REPLACE PACKAGE txpks_#8832ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#8832EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      21/07/2017     Created
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

CREATE OR REPLACE PACKAGE BODY txpks_#8832ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_orderid          CONSTANT CHAR(2) := '03';
   c_fullname         CONSTANT CHAR(2) := '90';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_afacctno         CONSTANT CHAR(2) := '04';
   c_ciacctno         CONSTANT CHAR(2) := '05';
   c_seacctno         CONSTANT CHAR(2) := '06';
   c_exectype         CONSTANT CHAR(2) := '22';
   c_symbol           CONSTANT CHAR(2) := '07';
   c_amt              CONSTANT CHAR(2) := '08';
   c_qtty             CONSTANT CHAR(2) := '09';
   c_price            CONSTANT CHAR(2) := '16';
   c_parvalue         CONSTANT CHAR(2) := '44';
   c_feeamt           CONSTANT CHAR(2) := '12';
   c_vat              CONSTANT CHAR(2) := '13';
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
    l_count     NUMBER;
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

    SELECT count(*) INTO l_count FROM stschd WHERE status = 'N' AND duetype IN ('RM','RS') AND orgorderid = p_txmsg.txfields('03').value;
    IF l_count = 0 THEN
        p_err_code := '-707707';
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
    l_txmsg             tx.msg_rectype;
    v_strCURRDATE       varchar2(20);
    v_strPREVDATE       varchar2(20);
    v_strNEXTDATE       varchar2(20);
    v_strDesc           varchar2(1000);
    v_strEN_Desc        varchar2(1000);
    v_blnVietnamese     BOOLEAN;
    l_err_param         varchar2(300);
    v_dblProfit         number(20,0);
    v_dblLoss           number(20,0);
    v_dblAVLRCVAMT      number(20,0);
    v_dblVATRATE        number(20,0);
    v_dblAVLFEEAMT      number(20,0);
    v_dblFeeTemp        number(20,0);
    v_dblFEEAMT         number(20,0);
    v_strORGORDERID     varchar2(100);
    l_vatrate           number(20,6);
    l_rightrate         number(20,6);
    v_delta             number(20,6);
    l_ruletype          varchar2(10);
    l_ISCOREBANK        NUMBER;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/

SELECT TO_DATE (varvalue, systemnums.c_date_format) INTO v_strCURRDATE
FROM sysvar
WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

IF p_txmsg.txfields('22').value = 'NB' THEN
    SELECT TXDESC,EN_TXDESC into v_strDesc, v_strEN_Desc FROM  TLTX WHERE TLTXCD='8868';

    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := p_txmsg.tlid;
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := 'DAY';
    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    --l_txmsg.busdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd:='8868';

    FOR rec IN
    (
        SELECT SUBSTR(MAX(CUSTODYCD),4,1) CUSTODYCD,MAX(COSTPRICE) COSTPRICE ,CLR2.SBDATE, TO_DATE( v_strCURRDATE,systemnums.c_date_format) CURRDATE,
            SUM(CASE WHEN CLR1.HOLIDAY='Y' THEN 0 ELSE 1 END) WITHHOLIDAY,
            SUM(CASE WHEN CLR1.HOLIDAY='Y' THEN 1 ELSE 1 END) WITHOUTHOLIDAY,
            MST.AUTOID, MST.AFACCTNO,MAX(ODMST.ORDERQTTY) ORGORDERQTTY,MAX(ODMST.EXECTYPE) EXECTYPE,MAX(ODMST.QUOTEPRICE) ORGQUOTEPRICE, MST.ACCTNO, MIN(MST.DUETYPE) DUETYPE, MIN(MST.TXDATE) TXDATE, MIN(MST.ORGORDERID) ORGORDERID, MIN(MST.CLEARCD) CLEARCD, MIN(MST.CLEARDAY) CLEARDAY,
            MIN(SEC.CODEID) CODEID, MIN(SEC.SYMBOL) SYMBOL, MIN(SEC.PARVALUE) PARVALUE, MIN(TYP.VATRATE) VATRATE, MIN(ODMST.FEEACR-ODMST.FEEAMT) AVLFEEAMT, MIN(ODMST.FEEACR) FEEACR, MIN(ODMST.TXDATE) ODTXDATE, MIN(ODMST.FERROD) FERROD, MIN(SEC.TRADEPLACE) TRADEPLACE,
            MIN(MST.AMT) AMT, MIN(MST.AAMT) AAMT, MIN(MST.FAMT) FAMT, MIN(MST.QTTY) QTTY,MIN(ODMST.EXECQTTY) SQTTY , MIN(MST.AQTTY) AQTTY, ROUND(MIN(MST.AMT/MST.QTTY),4) MATCHPRICE
        FROM SBCLDR CLR1, SBCLDR CLR2, (SELECT A.*, ROWNUM ID FROM STSCHD A) MST, ODMAST ODMST,AFMAST AF,CFMAST CF, ODTYPE TYP, SBSECURITIES SEC
        WHERE ODMST.AFACCTNO=AF.ACCTNO AND AF.CUSTID=CF.CUSTID AND  CLR1.SBDATE>=MST.TXDATE AND CLR1.SBDATE<CLR2.SBDATE AND CLR2.SBDATE>=MST.TXDATE
            AND CLR1.CLDRTYPE=SEC.TRADEPLACE AND CLR2.CLDRTYPE=SEC.TRADEPLACE
            AND ODMST.ACTYPE=TYP.ACTYPE AND MST.ORGORDERID=ODMST.ORDERID AND MST.CODEID=SEC.CODEID AND SEC.TRADEPLACE <> '003'
            AND CLR2.SBDATE=TO_DATE( v_strCURRDATE,systemnums.c_date_format) AND MST.STATUS='N' AND MST.DELTD<>'Y'
            AND (MST.DUETYPE='RS' )
            AND  CF.CUSTATCOM ='Y'
            AND ODMST.ORDERID = p_txmsg.txfields('03').value AND SEC.BONDTYPE IN ('001','002','003') AND ODMST.MATCHTYPE = 'P' AND sec.sectype = '006'
        GROUP BY MST.AUTOID, CLR2.SBDATE, MST.AFACCTNO, MST.ACCTNO
        HAVING MIN(MST.CLEARDAY)<=
            (CASE WHEN MIN(MST.CLEARCD)='B' THEN SUM(CASE WHEN CLR1.HOLIDAY='Y' THEN 0 ELSE 1 END) ELSE SUM(CASE WHEN CLR1.HOLIDAY='Y' THEN 1 ELSE 1 END) END)
        ORDER BY ORGORDERID
    )
    LOOP
        --Set busdate
        l_txmsg.busdate:= CASE WHEN rec.ferrod = 'Y' THEN getduedate(rec.odtxdate,'B',rec.tradeplace,rec.clearday) ELSE to_date(v_strCURRDATE,systemnums.c_date_format) END;
        --Set txnum
        SELECT systemnums.C_BATCH_PREFIXED
                         || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                  INTO l_txmsg.txnum
                  FROM DUAL;
        l_txmsg.brid        := substr(rec.AFACCTNO,1,4);
        --Xac dinh xem nha day tu trong nuoc hay nuoc ngoai
        IF rec.custodycd='F' then
            v_blnVietnamese:= false;
        else
            v_blnVietnamese:= true;
        end if;

        --Set cac field giao dich
        --01   N   AUTOID
        l_txmsg.txfields ('01').defname   := 'AUTOID';
        l_txmsg.txfields ('01').TYPE      := 'N';
        l_txmsg.txfields ('01').VALUE     := rec.AUTOID;

        --03   C   ORGORDERID
        l_txmsg.txfields ('03').defname   := 'ORGORDERID';
        l_txmsg.txfields ('03').TYPE      := 'C';
        l_txmsg.txfields ('03').VALUE     := rec.ORGORDERID;
        --04   C   AFACCTNO
        l_txmsg.txfields ('04').defname   := 'AFACCTNO';
        l_txmsg.txfields ('04').TYPE      := 'C';
        l_txmsg.txfields ('04').VALUE     := rec.AFACCTNO;
        --05   C   CIACCTNO
        l_txmsg.txfields ('05').defname   := 'CIACCTNO';
        l_txmsg.txfields ('05').TYPE      := 'C';
        l_txmsg.txfields ('05').VALUE     := rec.AFACCTNO;
        --06   C   SEACCTNO
        l_txmsg.txfields ('06').defname   := 'SEACCTNO';
        l_txmsg.txfields ('06').TYPE      := 'C';
        l_txmsg.txfields ('06').VALUE     := rec.ACCTNO;
        --07   C   SYMBOL
        l_txmsg.txfields ('07').defname   := 'SYMBOL';
        l_txmsg.txfields ('07').TYPE      := 'C';
        l_txmsg.txfields ('07').VALUE     := rec.SYMBOL;
        --17   C   CODEID
        l_txmsg.txfields ('17').defname   := 'CODEID';
        l_txmsg.txfields ('17').TYPE      := 'C';
        l_txmsg.txfields ('17').VALUE     := rec.CODEID;
        --08   N   AMT
        l_txmsg.txfields ('08').defname   := 'AMT';
        l_txmsg.txfields ('08').TYPE      := 'N';
        l_txmsg.txfields ('08').VALUE     := round(rec.AMT,0);
        --09   N   QTTY
        l_txmsg.txfields ('09').defname   := 'QTTY';
        l_txmsg.txfields ('09').TYPE      := 'N';
        l_txmsg.txfields ('09').VALUE     := rec.QTTY;
        --10   N   MATCHPRICE
        l_txmsg.txfields ('10').defname   := 'MATCHPRICE';
        l_txmsg.txfields ('10').TYPE      := 'N';
        l_txmsg.txfields ('10').VALUE     := rec.MATCHPRICE;
        --11   N   RCVQTTY
        l_txmsg.txfields ('11').defname   := 'RCVQTTY';
        l_txmsg.txfields ('11').TYPE      := 'N';
        l_txmsg.txfields ('11').VALUE     := rec.QTTY;
        --12   N   PARVALUE
        l_txmsg.txfields ('12').defname   := 'PARVALUE';
        l_txmsg.txfields ('12').TYPE      := 'N';
        l_txmsg.txfields ('12').VALUE     := rec.PARVALUE;
        --13   N   FEEACR
        l_txmsg.txfields ('13').defname   := 'FEEACR';
        l_txmsg.txfields ('13').TYPE      := 'N';
        l_txmsg.txfields ('13').VALUE     := rec.FEEACR;
        --30   C   DESC
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        If v_blnVietnamese = True Then
            l_txmsg.txfields ('30').VALUE := v_strDesc || ' ' || trim(to_char(rec.SQTTY,'999,999,999,999,999,999,999')) || ' ' || rec.SYMBOL || ' ' || UTF8NUMS.C_CONST_DATE_VI || ' '  || substr(rec.ORGORDERID, 5, 2) || '/' || substr(rec.ORGORDERID, 7, 2) || '/' || substr(rec.ORGORDERID, 9, 2);
        Else
            l_txmsg.txfields ('30').VALUE := v_strEN_Desc || ' ' || trim(to_char(rec.SQTTY,'999,999,999,999,999,999,999')) || ' ' || rec.SYMBOL || ' date '  || substr(rec.ORGORDERID, 5, 2) || '/' || substr(rec.ORGORDERID, 7, 2) || '/' || substr(rec.ORGORDERID, 9, 2);
        End If;

        BEGIN
            IF txpks_#8868.fn_batchtxprocess (l_txmsg,
                                             p_err_code,
                                             l_err_param
               ) <> systemnums.c_success
            THEN
               plog.debug (pkgctx,
                           'got error 8868: ' || p_err_code
               );
               ROLLBACK;
               RETURN errnums.C_BIZ_RULE_INVALID;
            END IF;
        END;
    END LOOP;

ELSE
    SELECT TXDESC,EN_TXDESC into v_strDesc, v_strEN_Desc FROM  TLTX WHERE TLTXCD='8866';

    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := p_txmsg.tlid;
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := 'DAY';
    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    --l_txmsg.busdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd:='8866';
    v_dblProfit:=0;
    v_dblLoss:=0;
    for rec in
    (
        SELECT SUBSTR(MAX(CUSTODYCD),4,1) CUSTODYCD,MAX(COSTPRICE) COSTPRICE ,CLR2.SBDATE, TO_DATE( v_strCURRDATE,systemnums.c_date_format) CURRDATE,
            SUM(CASE WHEN CLR1.HOLIDAY='Y' THEN 0 ELSE 1 END) WITHHOLIDAY,
            SUM(CASE WHEN CLR1.HOLIDAY='Y' THEN 1 ELSE 1 END) WITHOUTHOLIDAY,
            CASE WHEN CI.COREBANK='Y' THEN 1 ELSE 0 END COREBANK,
            MST.AUTOID, MST.AFACCTNO,MAX(ODMST.ORDERQTTY) ORGORDERQTTY,MAX(ODMST.EXECTYPE) EXECTYPE,MAX(ODMST.QUOTEPRICE) ORGQUOTEPRICE, MST.ACCTNO, MIN(MST.DUETYPE) DUETYPE, MIN(MST.TXDATE) TXDATE, MIN(MST.ORGORDERID) ORGORDERID, MIN(MST.CLEARCD) CLEARCD, MIN(MST.CLEARDAY) CLEARDAY,
            MIN(SEC.CODEID) CODEID, MIN(SEC.SYMBOL) SYMBOL, MIN(SEC.PARVALUE) PARVALUE, MIN(TYP.VATRATE) VATRATE, MIN(ODMST.FEEACR-ODMST.FEEAMT) AVLFEEAMT, MIN(ODMST.TXDATE) ODTXDATE, MIN(ODMST.FERROD) FERROD, MIN(SEC.TRADEPLACE) TRADEPLACE,
            MIN(MST.AMT) AMT, MIN(MST.AAMT) AAMT, MIN(MST.FAMT) FAMT, MIN(MST.QTTY) QTTY,MIN(ODMST.EXECQTTY) SQTTY , MIN(MST.AQTTY) AQTTY, ROUND(MIN(MST.AMT/MST.QTTY),4) MATCHPRICE,MIN(ODMST.ACTYPE) ACTYPE
        FROM SBCLDR CLR1, SBCLDR CLR2, (SELECT A.*, ROWNUM ID FROM STSCHD A) MST, ODMAST ODMST,AFMAST AF,CFMAST CF,CIMAST CI, ODTYPE TYP, SBSECURITIES SEC
        WHERE ODMST.AFACCTNO=AF.ACCTNO AND AF.CUSTID=CF.CUSTID AND  CLR1.SBDATE>=MST.TXDATE AND CLR1.SBDATE<CLR2.SBDATE AND CLR2.SBDATE>=MST.TXDATE
            AND CLR1.CLDRTYPE=SEC.TRADEPLACE AND CLR2.CLDRTYPE=SEC.TRADEPLACE AND ODMST.AFACCTNO=CI.AFACCTNO
            AND ODMST.ACTYPE=TYP.ACTYPE AND MST.ORGORDERID=ODMST.ORDERID AND MST.CODEID=SEC.CODEID AND SEC.TRADEPLACE <> '003'
            AND CLR2.SBDATE=TO_DATE( v_strCURRDATE,systemnums.c_date_format) AND MST.STATUS='N' AND MST.DELTD<>'Y'
            AND (MST.DUETYPE='RM' )
            AND CF.CUSTATCOM ='Y'
            AND ODMST.ORDERID = p_txmsg.txfields('03').value AND SEC.BONDTYPE IN ('001','002','003') AND ODMST.MATCHTYPE = 'P' AND sec.sectype = '006'
        GROUP BY MST.AUTOID, CLR2.SBDATE, MST.AFACCTNO, MST.ACCTNO,CI.COREBANK
        HAVING MIN(MST.CLEARDAY)<=
            (CASE WHEN MIN(MST.CLEARCD)='B' THEN SUM(CASE WHEN CLR1.HOLIDAY='Y' THEN 0 ELSE 1 END) ELSE SUM(CASE WHEN CLR1.HOLIDAY='Y' THEN 1 ELSE 1 END) END)
        ORDER BY ORGORDERID
    )
    LOOP
        --Set busdate
        l_txmsg.busdate:= CASE WHEN rec.ferrod = 'Y' THEN getduedate(rec.odtxdate,'B',rec.tradeplace,rec.clearday) ELSE to_date(v_strCURRDATE,systemnums.c_date_format) END;
        --Set txnum
        SELECT systemnums.C_BATCH_PREFIXED
                         || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                  INTO l_txmsg.txnum
                  FROM DUAL;
        l_txmsg.brid        := substr(rec.AFACCTNO,1,4);
        --Xac dinh xem nha day tu trong nuoc hay nuoc ngoai
        IF rec.custodycd='F' then
            v_blnVietnamese:= false;
        else
            v_blnVietnamese:= true;
        end if;
        v_dblAVLRCVAMT := rec.AMT;
        v_dblVATRATE := rec.VATRATE;
        --Tinh gia tri lai lo cho tu doanh
        If rec.CUSTODYCD= 'P' Then
            If rec.AMT > rec.COSTPRICE * rec.QTTY Then
                v_dblProfit := round(rec.AMT - rec.COSTPRICE * rec.QTTY,0);
                v_dblLoss := 0;
            Else
                v_dblProfit := 0;
                v_dblLoss := round(rec.COSTPRICE * rec.QTTY - rec.AMT,0);
            End If;
        end if;
        --Set cac field giao dich
        --01   N   AUTOID
        l_txmsg.txfields ('01').defname   := 'AUTOID';
        l_txmsg.txfields ('01').TYPE      := 'N';
        l_txmsg.txfields ('01').VALUE     := rec.AUTOID;

        --03   C   ORGORDERID
        l_txmsg.txfields ('03').defname   := 'ORGORDERID';
        l_txmsg.txfields ('03').TYPE      := 'C';
        l_txmsg.txfields ('03').VALUE     := rec.ORGORDERID;
        --04   C   AFACCTNO
        l_txmsg.txfields ('04').defname   := 'AFACCTNO';
        l_txmsg.txfields ('04').TYPE      := 'C';
        l_txmsg.txfields ('04').VALUE     := rec.AFACCTNO;
        --05   C   CIACCTNO
        l_txmsg.txfields ('05').defname   := 'CIACCTNO';
        l_txmsg.txfields ('05').TYPE      := 'C';
        l_txmsg.txfields ('05').VALUE     := rec.ACCTNO;
        --06   C   SEACCTNO
        l_txmsg.txfields ('06').defname   := 'SEACCTNO';
        l_txmsg.txfields ('06').TYPE      := 'C';
        l_txmsg.txfields ('06').VALUE     := rec.AFACCTNO || rec.CODEID;
        --07   C   SYMBOL
        l_txmsg.txfields ('07').defname   := 'SYMBOL';
        l_txmsg.txfields ('07').TYPE      := 'C';
        l_txmsg.txfields ('07').VALUE     := rec.SYMBOL;
        --08   N   AMT
        l_txmsg.txfields ('08').defname   := 'AMT';
        l_txmsg.txfields ('08').TYPE      := 'N';
        l_txmsg.txfields ('08').VALUE     := round(rec.AMT,0);
        --09   N   QTTY
        l_txmsg.txfields ('09').defname   := 'QTTY';
        l_txmsg.txfields ('09').TYPE      := 'N';
        l_txmsg.txfields ('09').VALUE     := rec.QTTY;
        --10   N   RAMT
        l_txmsg.txfields ('10').defname   := 'RAMT';
        l_txmsg.txfields ('10').TYPE      := 'N';
        l_txmsg.txfields ('10').VALUE     := round(rec.AMT,0);
        --11   N   AAMT
        l_txmsg.txfields ('11').defname   := 'AAMT';
        l_txmsg.txfields ('11').TYPE      := 'N';
        l_txmsg.txfields ('11').VALUE     := round(rec.AAMT,0);
        --12   N   FEEAMT
        l_txmsg.txfields ('12').defname   := 'FEEAMT';
        l_txmsg.txfields ('12').TYPE      := 'N';
        l_txmsg.txfields ('12').VALUE     := 0;
        --13   N   VAT
        l_txmsg.txfields ('13').defname   := 'VAT';
        l_txmsg.txfields ('13').TYPE      := 'N';
        l_txmsg.txfields ('13').VALUE     := 0;
        --14   N   PROFITAMT
        l_txmsg.txfields ('14').defname   := 'PROFITAMT';
        l_txmsg.txfields ('14').TYPE      := 'N';
        l_txmsg.txfields ('14').VALUE     := v_dblProfit;
        --15   N   LOSSAMT
        l_txmsg.txfields ('15').defname   := 'LOSSAMT';
        l_txmsg.txfields ('15').TYPE      := 'N';
        l_txmsg.txfields ('15').VALUE     := v_dblLoss;
        --16   N   COSTPRICE
        l_txmsg.txfields ('16').defname   := 'COSTPRICE';
        l_txmsg.txfields ('16').TYPE      := 'N';
        l_txmsg.txfields ('16').VALUE     := rec.COSTPRICE;
        --31   N   COREBANK
        l_txmsg.txfields ('31').defname   := 'COREBANK';
        l_txmsg.txfields ('31').TYPE      := 'N';
        l_txmsg.txfields ('31').VALUE     := rec.COREBANK;
        --30   C   DESC
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').VALUE := utf8nums.c_const_TLTX_TXDESC_8866 ||' ' || trim(to_char(rec.SQTTY,'999,999,999,999,999')) || ' ' || rec.SYMBOL || ' ' || UTF8NUMS.C_CONST_DATE_VI || ' ' || to_char(rec.TXDATE,'DD/MM/RRRR');
        --44   N   PARVALUE
        l_txmsg.txfields ('44').defname   := 'PARVALUE';
        l_txmsg.txfields ('44').TYPE      := 'N';
        l_txmsg.txfields ('44').VALUE     := rec.PARVALUE;

        --53   N   MICD
        l_txmsg.txfields ('53').defname   := 'MICD';
        l_txmsg.txfields ('53').TYPE      := 'C';
        l_txmsg.txfields ('53').VALUE     := '';

        --60   N   ISMORTAGE
        l_txmsg.txfields ('60').defname   := 'ISMORTAGE';
        l_txmsg.txfields ('60').TYPE      := 'N';
        l_txmsg.txfields ('60').VALUE     := (case when rec.EXECTYPE='MS' then 1 else 0 end);
        BEGIN
            IF txpks_#8866.fn_batchtxprocess (l_txmsg,
                                             p_err_code,
                                             l_err_param
               ) <> systemnums.c_success
            THEN
               plog.debug (pkgctx,
                           'got error 8866: ' || p_err_code
               );
               ROLLBACK;
               RETURN errnums.C_SYSTEM_ERROR;
            END IF;
        END;
    end loop;


    SELECT TXDESC,EN_TXDESC into v_strDesc, v_strEN_Desc FROM  TLTX WHERE TLTXCD='8856';

    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := p_txmsg.tlid;
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := 'DAY';
    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd:='8856';
    v_strORGORDERID:='orderid';
    v_dblAVLFEEAMT:=0;
    v_dblProfit:=0;
    v_dblLoss:=0;
    for rec in
    (
        SELECT SUBSTR(MAX(CUSTODYCD),4,1) CUSTODYCD,MAX(COSTPRICE) COSTPRICE , CLR2.SBDATE, TO_DATE(v_strCURRDATE,systemnums.c_date_format) CURRDATE,
            SUM(CASE WHEN CLR1.HOLIDAY='Y' THEN 0 ELSE 1 END) WITHHOLIDAY,
            SUM(CASE WHEN CLR1.HOLIDAY='Y' THEN 1 ELSE 1 END) WITHOUTHOLIDAY,
            CASE WHEN CI.COREBANK='Y' THEN 1 ELSE 0 END COREBANK,
            MST.AUTOID, MST.AFACCTNO,MAX(ODMST.ORDERQTTY) ORGORDERQTTY,MAX(ODMST.EXECTYPE) EXECTYPE,MAX(ODMST.QUOTEPRICE) ORGQUOTEPRICE, MST.ACCTNO, MIN(MST.DUETYPE) DUETYPE, MIN(MST.TXDATE) TXDATE, MIN(MST.ORGORDERID) ORGORDERID, MIN(MST.CLEARCD) CLEARCD, MIN(MST.CLEARDAY) CLEARDAY,
            MIN(SEC.CODEID) CODEID, MIN(SEC.SYMBOL) SYMBOL, MIN(SEC.PARVALUE) PARVALUE, MIN(TYP.VATRATE) VATRATE, MIN(ODMST.FEEACR-ODMST.FEEAMT) AVLFEEAMT,
            MIN(MST.AMT) AMT, MIN(MST.AAMT) AAMT, MIN(MST.FAMT) FAMT, MIN(MST.QTTY) QTTY,MIN(ODMST.EXECQTTY) SQTTY , MIN(MST.AQTTY) AQTTY, ROUND(MIN(MST.AMT/MST.QTTY),4) MATCHPRICE,
            UTF8NUMS.c_const_TLTX_TXDESC_8856 ||' '||MIN(ODMST.EXECQTTY)||' '||MIN(SEC.SYMBOL)||' ' || UTF8NUMS.C_CONST_DATE_VI ||' ' || to_char(MAX(ODMST.TXDATE),systemnums.c_date_format)  txdesc
        FROM SBCLDR CLR1, SBCLDR CLR2, (SELECT A.*, ROWNUM ID FROM STSCHD A) MST, ODMAST ODMST,AFMAST AF,CFMAST CF,CIMAST CI, ODTYPE TYP, SBSECURITIES SEC
        WHERE ODMST.AFACCTNO=AF.ACCTNO AND AF.CUSTID=CF.CUSTID AND CLR1.SBDATE>=MST.TXDATE AND CLR1.SBDATE<CLR2.SBDATE AND CLR2.SBDATE>=MST.TXDATE
            AND CLR1.CLDRTYPE=SEC.TRADEPLACE AND CLR2.CLDRTYPE=SEC.TRADEPLACE AND AF.ACCTNO=CI.AFACCTNO
            AND CF.CUSTATCOM='Y'
            AND ODMST.ACTYPE=TYP.ACTYPE AND MST.ORGORDERID=ODMST.ORDERID AND MST.CODEID=SEC.CODEID AND SEC.TRADEPLACE <> '003'
            AND CLR2.SBDATE=TO_DATE(v_strCURRDATE,systemnums.c_date_format) AND ODMST.FEEACR>ODMST.FEEAMT AND MST.DELTD<>'Y'
            AND (MST.DUETYPE='RM')
            AND ODMST.ORDERID = p_txmsg.txfields('03').value AND SEC.BONDTYPE IN ('001','002','003') AND ODMST.MATCHTYPE = 'P' AND sec.sectype = '006'
        GROUP BY MST.AUTOID, CLR2.SBDATE, MST.AFACCTNO, MST.ACCTNO,CI.COREBANK
        HAVING MIN(MST.CLEARDAY)<=
            (CASE WHEN MIN(MST.CLEARCD)='B' THEN SUM(CASE WHEN CLR1.HOLIDAY='Y' THEN 0 ELSE 1 END) ELSE SUM(CASE WHEN CLR1.HOLIDAY='Y' THEN 1 ELSE 1 END) END)
        ORDER BY ORGORDERID
    )
    LOOP
        --Set txnum
        SELECT systemnums.C_BATCH_PREFIXED
                         || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                  INTO l_txmsg.txnum
                  FROM DUAL;
        l_txmsg.brid        := substr(rec.AFACCTNO,1,4);
        --Xac dinh xem nha day tu trong nuoc hay nuoc ngoai
        IF rec.custodycd='F' then
            v_blnVietnamese:= false;
        else
            v_blnVietnamese:= true;
        end if;
        If v_strORGORDERID <> rec.ORGORDERID Then
            v_strORGORDERID := rec.ORGORDERID;
            v_dblAVLFEEAMT := rec.AVLFEEAMT;
        End If;
        v_dblAVLRCVAMT := rec.AMT;
        v_dblVATRATE := rec.VATRATE;
        If v_dblAVLFEEAMT <= v_dblAVLRCVAMT Then
            v_dblFeeTemp := v_dblAVLFEEAMT;
        Else
            v_dblFeeTemp := v_dblAVLRCVAMT;
        End If;
        If v_dblFeeTemp > 0 Then
            --Set cac field giao dich

            --01   N   AUTOID
            l_txmsg.txfields ('01').defname   := 'AUTOID';
            l_txmsg.txfields ('01').TYPE      := 'N';
            l_txmsg.txfields ('01').VALUE     := rec.AUTOID;

            --03   C   ORGORDERID
            l_txmsg.txfields ('03').defname   := 'ORGORDERID';
            l_txmsg.txfields ('03').TYPE      := 'C';
            l_txmsg.txfields ('03').VALUE     := rec.ORGORDERID;
            --04   C   AFACCTNO
            l_txmsg.txfields ('04').defname   := 'AFACCTNO';
            l_txmsg.txfields ('04').TYPE      := 'C';
            l_txmsg.txfields ('04').VALUE     := rec.AFACCTNO;
            --05   C   CIACCTNO
            l_txmsg.txfields ('05').defname   := 'CIACCTNO';
            l_txmsg.txfields ('05').TYPE      := 'C';
            l_txmsg.txfields ('05').VALUE     := rec.ACCTNO;
            --06   C   SEACCTNO
            l_txmsg.txfields ('06').defname   := 'SEACCTNO';
            l_txmsg.txfields ('06').TYPE      := 'C';
            l_txmsg.txfields ('06').VALUE     := rec.AFACCTNO || rec.CODEID;
            --07   C   SYMBOL
            l_txmsg.txfields ('07').defname   := 'SYMBOL';
            l_txmsg.txfields ('07').TYPE      := 'C';
            l_txmsg.txfields ('07').VALUE     := rec.SYMBOL;
            --08   N   AMT
            l_txmsg.txfields ('08').defname   := 'AMT';
            l_txmsg.txfields ('08').TYPE      := 'N';
            l_txmsg.txfields ('08').VALUE     := 0;
            --09   N   QTTY
            l_txmsg.txfields ('09').defname   := 'QTTY';
            l_txmsg.txfields ('09').TYPE      := 'N';
            l_txmsg.txfields ('09').VALUE     := rec.QTTY;
            --10   N   RAMT
            l_txmsg.txfields ('10').defname   := 'RAMT';
            l_txmsg.txfields ('10').TYPE      := 'N';
            l_txmsg.txfields ('10').VALUE     := 0;
            --11   N   AAMT
            l_txmsg.txfields ('11').defname   := 'AAMT';
            l_txmsg.txfields ('11').TYPE      := 'N';
            l_txmsg.txfields ('11').VALUE     := 0;
            --12   N   FEEAMT
            l_txmsg.txfields ('12').defname   := 'FEEAMT';
            l_txmsg.txfields ('12').TYPE      := 'N';
            If v_dblAVLFEEAMT <= v_dblAVLRCVAMT Then
                v_dblFEEAMT := v_dblAVLFEEAMT;
                v_dblAVLFEEAMT := 0;
            Else
                v_dblFEEAMT := v_dblAVLRCVAMT;
                v_dblAVLFEEAMT := v_dblAVLFEEAMT - v_dblAVLRCVAMT;
            End If;
            l_txmsg.txfields ('12').VALUE     := round(v_dblFEEAMT,0);

            --13   N   VAT
            l_txmsg.txfields ('13').defname   := 'VAT';
            l_txmsg.txfields ('13').TYPE      := 'N';
            l_txmsg.txfields ('13').VALUE     := round(v_dblVATRATE * v_dblFEEAMT,0);
            --14   N   PROFITAMT
            l_txmsg.txfields ('14').defname   := 'PROFITAMT';
            l_txmsg.txfields ('14').TYPE      := 'N';
            l_txmsg.txfields ('14').VALUE     := v_dblProfit;
            --15   N   LOSSAMT
            l_txmsg.txfields ('15').defname   := 'LOSSAMT';
            l_txmsg.txfields ('15').TYPE      := 'N';
            l_txmsg.txfields ('15').VALUE     := v_dblLoss;
            --16   N   COSTPRICE
            l_txmsg.txfields ('16').defname   := 'COSTPRICE';
            l_txmsg.txfields ('16').TYPE      := 'N';
            l_txmsg.txfields ('16').VALUE     := rec.COSTPRICE;
            --30   C   DESC
            l_txmsg.txfields ('30').defname   := 'DESC';
            l_txmsg.txfields ('30').TYPE      := 'C';
            l_txmsg.txfields ('30').VALUE     := rec.txdesc;

            --44   N   PARVALUE
            l_txmsg.txfields ('44').defname   := 'PARVALUE';
            l_txmsg.txfields ('44').TYPE      := 'N';
            l_txmsg.txfields ('44').VALUE     := rec.PARVALUE;

            --53   N   MICD
            l_txmsg.txfields ('53').defname   := 'MICD';
            l_txmsg.txfields ('53').TYPE      := 'C';
            l_txmsg.txfields ('53').VALUE     := '';

            --60   N   ISMORTAGE
            l_txmsg.txfields ('60').defname   := 'ISMORTAGE';
            l_txmsg.txfields ('60').TYPE      := 'N';
            l_txmsg.txfields ('60').VALUE     := (case when rec.EXECTYPE='MS' then 1 else 0 end);

            --31   N   COREBANK
            l_txmsg.txfields ('31').defname   := 'COREBANK';
            l_txmsg.txfields ('31').TYPE      := 'N';
            l_txmsg.txfields ('31').VALUE     := rec.COREBANK;

            BEGIN
                IF txpks_#8856.fn_batchtxprocess (l_txmsg,
                                                 p_err_code,
                                                 l_err_param
                   ) <> systemnums.c_success
                THEN
                   plog.debug (pkgctx,
                               'got error 8856: ' || p_err_code
                   );
                   ROLLBACK;
                   RETURN errnums.C_SYSTEM_ERROR;
                END IF;
            END;
        end if;

    END LOOP;

    SELECT TXDESC,EN_TXDESC into v_strDesc, v_strEN_Desc FROM  TLTX WHERE TLTXCD='0066';

    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := p_txmsg.tlid;
    plog.debug(pkgctx, 'l_txmsg.tlid' || l_txmsg.tlid);
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := 'DAY';
    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd:='0066';
    plog.debug(pkgctx, 'Begin loop');
    --Default thu thue la 0.1%
    begin
    l_vatrate:=to_number(cspks_system.fn_get_sysvar('SYSTEM','ADVSELLDUTY'));
    exception when others then
        l_vatrate:=0.1;
    end;

    --- Lay ti le thue TNCN
    SELECT VARVALUE into l_rightrate FROM SYSVAR WHERE VARNAME='ADVVATDUTY' AND GRNAME='SYSTEM';

    v_delta:=0;
    --Xac dinh xem lenh co lich ung truoc ma CI khong du thanh toan
    for rec in
    (
        SELECT MST.ACCTNO,
            CASE WHEN CI.COREBANK='Y' THEN 1 ELSE 0 END COREBANK,
            MST.ACTYPE,TYP.VAT,
            SUM(ST.AMT) SELLAMT,
            SUM(OD.TAXSELLAMT) TAXSELLAMT,
            SUM(ST.ARIGHT) SELLRIGHTAMT, v_strDesc  || ' ' || to_char(st.txdate,'DD/MM/RRRR') trDesc
        FROM (SELECT A.*, ROWNUM ID FROM AFMAST A) MST,
            AFTYPE TYP,STSCHD ST, SBSECURITIES SB, ODMAST OD,CIMAST CI, CFMAST CF
        WHERE MST.ACTYPE = TYP.ACTYPE AND MST.ACCTNO=ST.ACCTNO
            AND ST.ORGORDERID= OD.ORDERID
            AND ST.CODEID=SB.CODEID AND MST.ACCTNO=CI.AFACCTNO
            AND ST.DUETYPE='RM' AND ST.CLEARDATE = to_date(v_strCURRDATE,systemnums.c_date_format)
            AND MST.STATUS<>'C' AND TYP.VAT='Y'
            AND st.deltd = 'N'
            AND CF.CUSTID = MST.CUSTID
            AND CF.CUSTATCOM='Y'
            AND OD.ORDERID = p_txmsg.txfields('03').value AND SB.BONDTYPE IN ('001','002','003') AND OD.MATCHTYPE = 'P' AND sb.sectype = '006'
        GROUP BY mst.ACCTNO , MST.ACTYPE, TYP.VAT,CI.COREBANK, st.txdate, st.cleardate
        ORDER BY mst.ACCTNO
    )
    LOOP
        if rec.TAXSELLAMT>0 or rec.SELLRIGHTAMT>0 then
            --Set txnum
            plog.debug(pkgctx, 'Loop for account:' || rec.ACCTNO || ' ngay' || v_strCURRDATE);
            SELECT systemnums.C_BATCH_PREFIXED
                             || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                      INTO l_txmsg.txnum
                      FROM DUAL;
            l_txmsg.brid        := substr(rec.ACCTNO,1,4);

            --Set cac field giao dich
            --03  ACCTNO      C
            l_txmsg.txfields ('03').defname   := 'ACCTNO';
            l_txmsg.txfields ('03').TYPE      := 'C';
            l_txmsg.txfields ('03').VALUE     := rec.ACCTNO;
             --07  PERCENT     N
            l_txmsg.txfields ('07').defname   := 'PERCENT';
            l_txmsg.txfields ('07').TYPE      := 'N';
            l_txmsg.txfields ('07').VALUE     := 100;
            --08  ICCFBAL     N
            l_txmsg.txfields ('08').defname   := 'ICCFBAL';
            l_txmsg.txfields ('08').TYPE      := 'N';
            l_txmsg.txfields ('08').VALUE     := round(REC.SELLAMT,0);
            --09  ICCFRATE    N
            l_txmsg.txfields ('09').defname   := 'FEEAMT';
            l_txmsg.txfields ('09').TYPE      := 'N';
            l_txmsg.txfields ('09').VALUE     := l_vatrate;
            --10  INTAMT      N
            l_txmsg.txfields ('10').defname   := 'INTAMT';
            l_txmsg.txfields ('10').TYPE      := 'N';
            l_txmsg.txfields ('10').VALUE     := rec.TAXSELLAMT;--round(l_vatrate/100*REC.SELLAMT,0);
            --11  RIGHTRATE    N
            l_txmsg.txfields ('11').defname   := 'FEEAMT';
            l_txmsg.txfields ('11').TYPE      := 'N';
            l_txmsg.txfields ('11').VALUE     := l_rightrate;
            --12  INTRIGHTAMT      N
            l_txmsg.txfields ('12').defname   := 'INTAMT';
            l_txmsg.txfields ('12').TYPE      := 'N';
            l_txmsg.txfields ('12').VALUE     := round(REC.SELLRIGHTAMT,0);
            --30    DESC        C
            l_txmsg.txfields ('30').defname   := 'DESC';
            l_txmsg.txfields ('30').TYPE      := 'C';
            l_txmsg.txfields ('30').VALUE     := rec.trDesc;
            --31    COREBANK        N
            l_txmsg.txfields ('31').defname   := 'COREBANK';
            l_txmsg.txfields ('31').TYPE      := 'N';
            l_txmsg.txfields ('31').VALUE     := rec.COREBANK;
            BEGIN
                IF txpks_#0066.fn_batchtxprocess (l_txmsg,
                                                 p_err_code,
                                                 l_err_param
                   ) <> systemnums.c_success
                THEN
                   plog.debug (pkgctx,
                               'got error 0066: ' || p_err_code
                   );
                   ROLLBACK;
                   RETURN errnums.C_SYSTEM_ERROR;
                END IF;
            END;
        END IF;
    END LOOP;

    SELECT TXDESC,EN_TXDESC into v_strDesc, v_strEN_Desc FROM  TLTX WHERE TLTXCD='8851';

    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := p_txmsg.tlid;
    plog.debug(pkgctx, 'l_txmsg.tlid' || l_txmsg.tlid);
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := 'DAY';
    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd:='8851';
    plog.debug(pkgctx, 'Begin loop');
    for rec in
    (
        SELECT MST.AUTOID,MST.ACCTNO,MST.ISMORTAGE,SUM(DTL.AAMT) AMT ,0 FEEAMT, 0 VATAMT, TO_CHAR(MST.TXDATE,'DD/MM/YYYY') TXDATE,
               MST.RRTYPE, MST.CIACCTNO, MST.CUSTBANK, MST.ODDATE, MST.PAIDDATE,
               decode(MST.RRTYPE, 'O', 1,0) CIDRAWNDOWN,
               decode(MST.RRTYPE, 'B', 1,0) BANKDRAWNDOWN,
               decode(MST.RRTYPE, 'C', 1,0) CMPDRAWNDOWN,
             ( UTF8NUMS.c_const_desc_8851 ||', ' || UTF8NUMS.c_const_desc_8851_ODDATE || ' ' ||
              to_char(mst.txdate,'DD/MM/RRRR')  || ', ' || UTF8NUMS.c_const_desc_8851_TXDATE ||' ' || to_char(MST.ODDATE,'DD/MM/RRRR') || '')  txdesc
        FROM ADSCHD MST, ADSCHDDTL DTL
        WHERE MST.STATUS='N' AND MST.DELTD <> 'Y'
            AND MST.CLEARDT<= TO_DATE( v_strCURRDATE,systemnums.c_date_format)
            AND mst.txnum = dtl.txnum AND mst.txdate = dtl.txdate
            AND dtl.ORDERID = p_txmsg.txfields('03').value
        GROUP BY dtl.ORDERID, MST.AUTOID,MST.ACCTNO,MST.ISMORTAGE, TO_CHAR(MST.TXDATE,'DD/MM/YYYY'),
            MST.RRTYPE, MST.CIACCTNO, MST.CUSTBANK, MST.ODDATE, MST.PAIDDATE,
               decode(MST.RRTYPE, 'O', 1,0),
               decode(MST.RRTYPE, 'B', 1,0),
               decode(MST.RRTYPE, 'C', 1,0),
             ( UTF8NUMS.c_const_desc_8851 ||', ' || UTF8NUMS.c_const_desc_8851_ODDATE || ' ' ||
              to_char(mst.txdate,'DD/MM/RRRR')  || ', ' || UTF8NUMS.c_const_desc_8851_TXDATE ||' ' || to_char(MST.ODDATE,'DD/MM/RRRR') || '')

        ORDER BY MST.AUTOID
    )
    loop
        select (case when corebank = 'Y' then 1 else 0 end) into l_ISCOREBANK from cimast where acctno = rec.acctno;
        --Set txnum
        plog.debug(pkgctx, 'Loop for autoid:' || rec.AUTOID);
        SELECT systemnums.C_BATCH_PREFIXED
                         || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                  INTO l_txmsg.txnum
                  FROM DUAL;
        l_txmsg.brid        := substr(rec.ACCTNO,1,4);
        --Set cac field giao dich

        --09   STAUTOID     N
        l_txmsg.txfields ('09').defname   := 'STAUTOID';
        l_txmsg.txfields ('09').TYPE      := 'N';
        l_txmsg.txfields ('09').VALUE     := rec.AUTOID;

        --03   ACCTNO       C
        l_txmsg.txfields ('03').defname   := 'ACCTNO';
        l_txmsg.txfields ('03').TYPE      := 'C';
        l_txmsg.txfields ('03').VALUE     := rec.ACCTNO;

        --10   PAIDAMT      N
        l_txmsg.txfields ('10').defname   := 'PAIDAMT';
        l_txmsg.txfields ('10').TYPE      := 'N';
        l_txmsg.txfields ('10').VALUE     := round(rec.AMT,0);
        --11   PAIDFEEAMT   N
        l_txmsg.txfields ('11').defname   := 'PAIDFEEAMT';
        l_txmsg.txfields ('11').TYPE      := 'N';
        l_txmsg.txfields ('11').VALUE     := round(rec.FEEAMT,0);
        --12   N   FEEAMT
        l_txmsg.txfields ('12').defname   := 'FEEAMT';
        l_txmsg.txfields ('12').TYPE      := 'N';
        l_txmsg.txfields ('12').VALUE     := 0;

        --30   C   DESC
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').VALUE := rec.txdesc ;

        --60   N   ISMORTAGE
        l_txmsg.txfields ('60').defname   := 'ISMORTAGE';
        l_txmsg.txfields ('60').TYPE      := 'N';
        l_txmsg.txfields ('60').VALUE     := rec.ISMORTAGE;


        --44   C   RRTYPE
        l_txmsg.txfields ('44').defname   := 'RRTYPE';
        l_txmsg.txfields ('44').TYPE      := 'C';
        l_txmsg.txfields ('44').VALUE     := rec.RRTYPE;

        --04   C   CIACCTNO
        l_txmsg.txfields ('04').defname   := 'CIACCTNO';
        l_txmsg.txfields ('04').TYPE      := 'C';
        l_txmsg.txfields ('04').VALUE     := rec.CIACCTNO;


        --05   C   CUSTBANK
        l_txmsg.txfields ('05').defname   := 'CUSTBANK';
        l_txmsg.txfields ('05').TYPE      := 'C';
        l_txmsg.txfields ('05').VALUE     := rec.CUSTBANK;

        --94   N   ISCOREBANK
        l_txmsg.txfields ('94').defname   := 'ISMORTAGE';
        l_txmsg.txfields ('94').TYPE      := 'N';
        l_txmsg.txfields ('94').VALUE     := l_ISCOREBANK; --1: la tai khoan corebank; 0: la tai khoan tai CTchung khoan

        --96   C   CIDRAWNDOWN
        l_txmsg.txfields ('96').defname   := 'CIDRAWNDOWN';
        l_txmsg.txfields ('96').TYPE      := 'C';
        l_txmsg.txfields ('96').VALUE     := rec.CIDRAWNDOWN;

        --97   C   BANKDRAWNDOWN
        l_txmsg.txfields ('97').defname   := 'BANKDRAWNDOWN';
        l_txmsg.txfields ('97').TYPE      := 'C';
        l_txmsg.txfields ('97').VALUE     := rec.BANKDRAWNDOWN;

        --98   C   CMPDRAWNDOWN
        l_txmsg.txfields ('98').defname   := 'CMPDRAWNDOWN';
        l_txmsg.txfields ('98').TYPE      := 'C';
        l_txmsg.txfields ('98').VALUE     := rec.CMPDRAWNDOWN;

        --99   C   ALLORONE         hoan ung 1 lenh hoac all
        l_txmsg.txfields ('99').defname   := 'ALLORONE';
        l_txmsg.txfields ('99').TYPE      := 'C';
        l_txmsg.txfields ('99').VALUE     := p_txmsg.txfields('03').value;

        BEGIN
            IF txpks_#8851.fn_batchtxprocess (l_txmsg,
                                             p_err_code,
                                             l_err_param
               ) <> systemnums.c_success
            THEN
               plog.debug (pkgctx,
                           'got error 8851: ' || p_err_code
               );
               ROLLBACK;
               RETURN errnums.C_SYSTEM_ERROR;
            END IF;
        END;
    END LOOP;

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
         plog.init ('TXPKS_#8832EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#8832EX;
/

