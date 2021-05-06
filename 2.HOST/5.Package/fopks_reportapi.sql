create or replace package fopks_reportapi is

  /** ----------------------------------------------------------------------------------------------------
  ** Module: FO - OpenAPI 3
  ** Description: OpenAPI 3
  ** and is copyrighted by FSS.
  **
  **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
  **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
  **    graphic, optic recording or otherwise, translated in any language or computer language,
  **    without the prior written permission of Financial Software Solutions. JSC.
  **
  **  MODIFICATION HISTORY
  **    Person            Date           Comments
  **  duyanh.hoang     05/09/2019         Created
  ** (c) 2018 by Financial Software Solutions. JSC.
  ----------------------------------------------------------------------------------------------------*/

  type ref_cursor is ref cursor;
  /*
   /report/accounts/{accountId}/orderMatch - Orders matching history
  */
  PROCEDURE pr_getOrderMatch (p_refcursor in out ref_cursor,
                              p_custId    IN VARCHAR2,
                              p_accountId IN VARCHAR2 DEFAULT 'ALL',
                              p_fromDate  IN VARCHAR2,
                              p_toDate    IN VARCHAR2,
                              p_symbol    IN VARCHAR2 DEFAULT 'ALL',
                              p_execType  IN VARCHAR2 DEFAULT 'ALL',
                              p_err_code  IN OUT VARCHAR2,
                              p_err_param IN OUT VARCHAR2);
  /*
   /report/accounts/{accountId}/orderHist - Transfer history
  */
  PROCEDURE pr_getOrder (p_refcursor in out ref_cursor,
                        p_custid    IN VARCHAR2,
                        p_accountId IN VARCHAR2,
                        p_fromDate  IN VARCHAR2,
                        p_toDate    IN VARCHAR2,
                        p_symbol    IN VARCHAR2 DEFAULT 'ALL',
                        p_execType  IN VARCHAR2 DEFAULT 'ALL',
                        p_orsStatus IN VARCHAR2 DEFAULT 'ALL',
                        p_err_code  OUT VARCHAR2,
                        p_err_param OUT VARCHAR2);
  /*
   /report/accounts/{accountId}/cashStatementHist - Transfer history
  */
  PROCEDURE pr_getCashStatement (p_refcursor in out ref_cursor,
                                p_accountId IN VARCHAR2,
                                p_fromDate  IN VARCHAR2,
                                p_toDate    IN VARCHAR2,
                                p_err_code  IN OUT VARCHAR2,
                                p_err_param IN OUT VARCHAR2);
  /*
  /report/accounts/{accountId}/securitiesStatement - Stock transaction history
  */
  PROCEDURE pr_getSecuritiesStatement (p_refcursor in out ref_cursor,
                              p_accountId IN VARCHAR2,
                              p_fromDate  IN VARCHAR2,
                              p_toDate    IN VARCHAR2,
                              p_symbol    IN VARCHAR2 DEFAULT 'ALL',
                              p_err_code  IN OUT VARCHAR2,
                              p_err_param IN OUT VARCHAR2);
  /*
   /report/accounts/{accountId}/pnlExecuted - Realized profit and lost
  */
  PROCEDURE pr_getPnlExecuted (p_refcursor in out ref_cursor,
                              p_custid    IN VARCHAR2,
                              p_accountId IN VARCHAR2 DEFAULT 'ALL',
                              p_fromDate  IN VARCHAR2,
                              p_toDate    IN VARCHAR2,
                              p_symbol    IN VARCHAR2 DEFAULT 'ALL',
                              p_tradePlace IN VARCHAR2 DEFAULT 'ALL',
                              p_err_code  IN OUT VARCHAR2,
                              p_err_param IN OUT VARCHAR2);
  /*
   /report/accounts/{accountId}/advancedStatement - Payment in advanced history
  */
  PROCEDURE pr_GetAdvancedStatement (pv_refCursor IN OUT ref_cursor,
                                     p_accountId  IN VARCHAR2,
                                     p_fromDate   IN VARCHAR2,
                                     p_toDate     IN VARCHAR2,
                                     p_err_code   OUT VARCHAR2,
                                     p_err_param  OUT VARCHAR2);
  /*
   /report/accounts/{accountId}/cashTransferStatement - Cash transaction history
  */
  PROCEDURE pr_GetCashTransferStatement (pv_refCursor IN OUT ref_cursor,
                                         p_accountId  IN VARCHAR2,
                                         p_fromDate   IN VARCHAR2,
                                         p_toDate     IN VARCHAR2,
                                         p_err_code   OUT VARCHAR2,
                                         p_err_param  OUT VARCHAR2);
  /*
   /report/accounts/{accountId}/rightOffStatement - Right register history
  */
  PROCEDURE pr_GetRightOffStatement (pv_refCursor IN OUT ref_cursor,
                               p_custid     IN VARCHAR2,
                               p_accountId  IN VARCHAR2 DEFAULT 'ALL',
                               p_fromDate   IN VARCHAR2,
                               p_toDate     IN VARCHAR2,
                               p_err_code   OUT VARCHAR2,
                               p_err_param  OUT VARCHAR2);
  /*
   /report/accounts/{accountId}/loanList - List Of Account Loan
  */
  PROCEDURE pr_GetLoanList (pv_refCursor IN OUT ref_cursor,
                         p_custid     IN VARCHAR2,
                         p_accountId  IN VARCHAR2 DEFAULT 'ALL',
                         p_fromDate   IN VARCHAR2,
                         p_toDate     IN VARCHAR2,
                         p_err_code   OUT VARCHAR2,
                         p_err_param  OUT VARCHAR2);
  /*
   /report/accounts/{accountId}/paymentHist - payment
  */
  PROCEDURE pr_GetPaymentHist (pv_refCursor IN OUT ref_cursor,
                         p_custid     IN VARCHAR2,
                         p_accountId  IN VARCHAR2 DEFAULT 'ALL',
                         p_fromDate   IN VARCHAR2,
                         p_toDate     IN VARCHAR2,
                         p_err_code   OUT VARCHAR2,
                         p_err_param  OUT VARCHAR2);
  /*
   /report/accounts/{accountId}/stockTransferStatement - payment
  */
  PROCEDURE pr_GetStockTransferStatement (pv_refCursor IN OUT ref_cursor,
                         p_custid     IN VARCHAR2,
                         p_accountId  IN VARCHAR2 DEFAULT 'ALL',
                         p_fromDate   IN VARCHAR2,
                         p_toDate     IN VARCHAR2,
                         p_err_code   OUT VARCHAR2,
                         p_err_param  OUT VARCHAR2);
  /*
  /inq/accounts/{accountId}/sellOddLotHists - History Of available Sell Odd Lot
  */
  PROCEDURE pr_GetSellOddLotHist (pv_refCursor IN OUT ref_cursor,
                               p_custId     IN VARCHAR2,
                               p_accountId  IN VARCHAR2 DEFAULT 'ALL',
                               p_frDate     IN VARCHAR2,
                               p_toDate     IN VARCHAR2,
                               p_err_code   OUT VARCHAR2,
                               p_err_param  OUT VARCHAR2);
  /*
  /inq/accounts/{accountId}/bondsToSharesHist - History Of regist bond to shares
  */
  PROCEDURE pr_GetBondsToSharesHist (pv_refCursor IN OUT ref_cursor,
                               p_accountId  IN VARCHAR2,
                               p_frDate     IN VARCHAR2,
                               p_toDate     IN VARCHAR2,
                               p_err_code   OUT VARCHAR2,
                               p_err_param  OUT VARCHAR2);
  /*
  /report/accounts/{accountId}/confirmOrderHist - History Of available Sell Odd Lot
  */
  PROCEDURE pr_GetConfirmOrderHist (pv_refCursor IN OUT ref_cursor,
                               p_custId     IN VARCHAR2,
                               p_accountId  IN VARCHAR2 DEFAULT 'ALL',
                               p_err_code   OUT VARCHAR2,
                               p_err_param  OUT VARCHAR2);
end fopks_reportapi;

/
CREATE OR REPLACE PACKAGE BODY fopks_reportapi IS
  -- declare log context
  pkgctx   plog.log_ctx;
  logrow   tlogdebug%ROWTYPE;

  /*
   /report/accounts/{accountId}/orderMatch - Orders matching history
  */
  PROCEDURE pr_getOrderMatch (p_refcursor in out ref_cursor,
                              p_custId    IN VARCHAR2,
                              p_accountId IN VARCHAR2 DEFAULT 'ALL',
                              p_fromDate  IN VARCHAR2,
                              p_toDate    IN VARCHAR2,
                              p_symbol    IN VARCHAR2 DEFAULT 'ALL',
                              p_execType  IN VARCHAR2 DEFAULT 'ALL',
                              p_err_code  IN OUT VARCHAR2,
                              p_err_param IN OUT VARCHAR2)
  IS
  l_frDate    DATE;
  l_toDate    DATE;
  l_symbol    sbsecurities.symbol%TYPE;
  l_execType  VARCHAR2(10);
  v_sysvalue  NUMBER;
  l_accountId VARCHAR2(30);
  l_custId    VARCHAR2(30);
  BEGIN
    plog.setBeginSection (pkgctx, 'pr_getOrderMatch');
    p_err_code := systemnums.C_SUCCESS;
    p_err_param := '';

    l_frDate := TO_DATE(p_fromDate, systemnums.C_DATE_FORMAT);
    l_toDate := TO_DATE(p_toDate, systemnums.C_DATE_FORMAT);
    l_symbol := CASE WHEN NVL(upper(p_symbol), 'ALL') = 'ALL' THEN '%' ELSE upper(p_symbol) END;
    l_execType := CASE WHEN NVL(upper(p_execType), 'ALL') = 'ALL' THEN '%' ELSE upper(p_execType) END;
    SELECT ROUND(TO_NUMBER(SYS.VARVALUE)/100,5) INTO v_sysvalue FROM sysvar sys WHERE  SYS.GRNAME = 'SYSTEM' AND SYS.VARNAME = 'ADVSELLDUTY';
    l_accountId := CASE WHEN NVL(upper(p_accountId), 'ALL') = 'ALL' THEN '%' ELSE upper(p_accountId) END;
    l_custId := p_custId;

    OPEN p_REFCURSOR FOR
        SELECT od.AFACCTNO   accountId,
               OD.ORDERID,
               TO_CHAR(od.TXDATE, systemnums.C_DATE_FORMAT) txDate,
               OD.SYMBOL,
               od.EXECTYPE,
               iod.MATCHQTTY,
               iod.MATCHPRICE,
               iod.MATCHPRICE * iod.MATCHQTTY matchAmt,
               ROUND(IOD.MATCHQTTY*IOD.MATCHPRICE*OD.FEERATE) FEEAMT,
               CASE WHEN INSTR(OD.EXECTYPE,'S') > 0 and od.vat = 'Y' THEN IOD.MATCHQTTY * IOD.MATCHPRICE * OD.TAXRATE ELSE 0 END SELLTAXAMT,
               OD.tlname makerName,
               'SAVIA_' || od.via VIA_CODE,
                A2.Cdcontent via,
                iod.iodfeeacr   feeamt,
                TO_CHAR(schd.CLEARDATE, 'dd/mm/rrrr') clearDate,
                round(iod.iodfeeacr / (iod.matchprice * iod.matchqtty) * 100, 2)   feeRate
        FROM
        (
             SELECT CF.CUSTODYCD,OD.TXDATE, OD.EXECTYPE, OD.AFACCTNO,OD.AFACCTNO|| '-'|| aft.typename AFACCTNOFULL, OD.ORDERID, OD.CODEID, SB.SYMBOL, OD.EXECAMT, OD.EXECQTTY,
                CASE WHEN OD.EXECAMT >0 AND OD.FEEACR =0 AND OD.STSSTATUS = 'N' THEN ROUND(ODT.DEFFEERATE/100,5) ELSE ROUND(OD.FEEACR/OD.EXECAMT,5) END FEERATE,
                CASE WHEN OD.EXECAMT >0 AND INSTR(OD.EXECTYPE,'S')>0 AND OD.STSSTATUS = 'N'
                            THEN v_sysvalue ELSE OD.TAXRATE/100 END TAXRATE, aft.vat, TLP.tlname,
                od.VIA
            FROM VW_ODMAST_ALL OD, SBSECURITIES SB, AFMAST AF, aftype aft, ODTYPE ODT, cfmast cf, tlprofiles TLP
            WHERE OD.CODEID = SB.CODEID AND AF.ACCTNO = OD.AFACCTNO and af.custid = cf.custid and af.actype = aft.actype
                AND OD.ORSTATUS IN ('4','5','7','12') AND OD.EXECQTTY>0
                AND OD.ACTYPE = ODT.ACTYPE
                AND OD.TLID = TLP.TLID(+)
                AND OD.EXECTYPE NOT IN ('AB', 'AS')
                AND af.acctno LIKE l_accountId AND af.custid = l_custId
        ) OD, (SELECT * FROM iod UNION ALL SELECT * FROM iodhist) IOD, ALLCODE A1, allcode a2, vw_stschd_all schd
        WHERE OD.ORDERID = IOD.ORGORDERID
        AND A1.CDTYPE = 'OD' AND A1.CDNAME = 'EXECTYPE' AND A1.CDVAL = OD.EXECTYPE
        AND A2.CDTYPE = 'SA' AND A2.CDNAME = 'VIA' AND A2.CDVAL = OD.VIA
        AND od.ORDERID = schd.ORGORDERID
        AND schd.DUETYPE IN ('RM', 'RS')
        AND od.TXDATE between l_frDate AND l_toDate
        AND od.symbol LIKE l_symbol
        AND od.EXECTYPE LIKE l_execType
        ORDER BY OD.TXDATE DESC, SUBSTR(OD.ORDERID,11,6) DESC,OD.AFACCTNO, OD.EXECTYPE, OD.SYMBOL;

    plog.setEndSection (pkgctx, 'pr_getOrderMatch');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_param := 'SYSTEM ERROR';
      plog.setEndSection (pkgctx, 'pr_getOrderMatch');
  END;

  /*
   /report/accounts/{accountId}/orderHist - Transfer history
  */
  PROCEDURE pr_getOrder (p_refcursor in out ref_cursor,
                        p_custid    IN VARCHAR2,
                        p_accountId IN VARCHAR2,
                        p_fromDate  IN VARCHAR2,
                        p_toDate    IN VARCHAR2,
                        p_symbol    IN VARCHAR2 DEFAULT 'ALL',
                        p_execType  IN VARCHAR2 DEFAULT 'ALL',
                        p_orsStatus IN VARCHAR2 DEFAULT 'ALL',
                        p_err_code  OUT VARCHAR2,
                        p_err_param OUT VARCHAR2)
  IS
  l_frDate    DATE;
  l_toDate    DATE;
  l_currDate  DATE;
  l_symbol    sbsecurities.symbol%TYPE;
  l_execType  VARCHAR2(10);
  l_orsStatus VARCHAR2(10);

  l_accountId  VARCHAR2(30);
  l_custId     VARCHAR2(30);
  BEGIN
    plog.setBeginSection (pkgctx, 'pr_getOrder');
    p_err_code := systemnums.C_SUCCESS;
    p_err_param := '';

    l_custId := p_custid;
    l_accountId := CASE WHEN NVL(upper(p_accountId), 'ALL') = 'ALL' THEN '%' ELSE p_accountId END;

    l_frDate := TO_DATE(p_fromDate, systemnums.C_DATE_FORMAT);
    l_toDate := TO_DATE(p_toDate, systemnums.C_DATE_FORMAT);
    l_currDate := getcurrdate;
    l_symbol := CASE WHEN NVL(upper(p_symbol), 'ALL') = 'ALL' THEN '%' ELSE upper(p_symbol) END;
    l_execType := CASE WHEN NVL(upper(p_execType), 'ALL') = 'ALL' THEN '%' ELSE upper(p_execType) END;
    l_orsStatus := CASE WHEN NVL(upper(p_orsStatus), 'ALL') = 'ALL' THEN '%' ELSE upper(p_orsStatus) END;

    OPEN p_REFCURSOR
    FOR
      SELECT od.afacctno accountId,
             OD.ORDERID,
             TO_CHAR(od.txdate, 'dd/mm/rrrr') txDate,
             sb.symbol,
             od.exectype,
             od.ORDERQTTY,
             OD.QUOTEPRICE,
             OD.REMAINQTTY,
             OD.EXECQTTY,
             CASE WHEN OD.EXECQTTY>0 THEN ROUND(OD.EXECAMT/OD.EXECQTTY) ELSE 0 END EXECPRICE,
             OD.EXECAMT,
             'ODORSTATUS_' || od.ORSTATUSVALUE orStatus_code,
             a3.cdval orStatus,
             CASE WHEN OD.EXECAMT >0 AND OD.FEEACR =0 AND OD.STSSTATUS = 'N' THEN round(OD.EXECAMT*ODT.DEFFEERATE/100)
                  WHEN OD.EXECAMT >0 AND OD.FEEACR >0 THEN round(OD.FEEACR)
                  when od.txdate = l_currDate then round((OD.REMAINQTTY*OD.QUOTEPRICE + OD.EXECAMT)*ODT.DEFFEERATE/100)
                  else 0
             END feeAmt,
             CASE WHEN OD.EXECAMT >0 AND INSTR(OD.EXECTYPE,'S')>0 AND OD.STSSTATUS = 'N' THEN
                     CASE WHEN AFT.VAT = 'Y' THEN ROUND(OD.EXECAMT*TO_NUMBER(SYS.VARVALUE)/100)
                          ELSE 0
                     END
                 ELSE ROUND(OD.EXECAMT*OD.TAXRATE/100)
             END taxAmt,
             'SYYESNO_' || OD.CONFIRMED CONFIRMED_CODE,
             a4.cdcontent CONFIRMED,
             TLP.tlname makerName,
             'SAVIA_' || od.via VIA_CODE,
             A2.Cdcontent via
      FROM
          (SELECT MST.*,
                 (CASE WHEN MST.REMAINQTTY <> 0 AND MST.EDITSTATUS='C' THEN 'C'
                      WHEN MST.REMAINQTTY <> 0 AND MST.EDITSTATUS='A' THEN 'A'
                      WHEN MST.EDITSTATUS IS NULL AND MST.CANCELQTTY <> 0 THEN '5'
                      WHEN MST.REMAINQTTY = 0 AND MST.CANCELQTTY <> 0 AND MST.EDITSTATUS='C' THEN '3'
                      when MST.REMAINQTTY = 0 and MST.ADJUSTQTTY>0 AND mst.pricetype = 'MP' then '4'
                      when MST.REMAINQTTY = 0 and MST.ADJUSTQTTY>0 then '10'
                      WHEN MST.REMAINQTTY = 0 AND MST.EXECQTTY>0 AND MST.ORSTATUS = '4' THEN '12' ELSE MST.ORSTATUS END) ORSTATUSVALUE
              FROM
                  (SELECT OD1.*,OD2.EDSTATUS EDITSTATUS
                   from vw_odmast_all OD1,
                       (SELECT * FROM vw_odmast_all WHERE EDSTATUS IN ('C','A') and EXECTYPE NOT IN ('NB','NS')) OD2
                   WHERE OD1.ORDERID=OD2.REFORDERID(+) AND substr(OD1.EXECTYPE,1,1) <> 'C'
                   AND substr(OD1.EXECTYPE,1,1) <> 'A'
                   AND (od1.execqtty <> 0 or od1.edstatus NOT IN ('C','A')) --AND OD1.ORSTATUS <>'7'
                 ) MST
          ) OD, SBSECURITIES SB, AFMAST AF, ALLCODE A2, ALLCODE A3, ALLCODE A4, SYSVAR SYS, ODTYPE ODT, CFMAST CF,
          tlprofiles TLP, aftype aft
      WHERE OD.CODEID=SB.CODEID AND AF.ACCTNO = OD.AFACCTNO AND AF.CUSTID= CF.CUSTID
          AND af.actype = aft.actype
          AND OD.ACTYPE = ODT.ACTYPE
          AND OD.TLID = TLP.TLID(+)
          AND A2.CDTYPE = 'SA' AND A2.CDNAME = 'VIA' AND A2.CDVAL = OD.VIA
          AND A3.CDTYPE = 'OD' AND A3.CDNAME = 'ORSTATUS' AND A3.CDVAL = OD.ORSTATUSVALUE
          AND A4.CDTYPE = 'SY' AND A4.CDNAME = 'YESNO' AND A4.CDVAL = OD.confirmed
          AND SYS.GRNAME = 'SYSTEM' AND SYS.VARNAME = 'ADVSELLDUTY'
          --AND AF.ACCTNO = p_accountId
          AND af.acctno LIKE l_accountId AND af.custid = l_custId
          AND OD.ORSTATUSVALUE LIKE l_orsStatus
          AND SB.SYMBOL LIKE l_symbol
          AND OD.EXECTYPE LIKE l_execType
          AND OD.TXDATE BETWEEN l_frDate AND l_toDate
      ORDER BY OD.TXDATE DESC, SUBSTR(OD.ORDERID,11,6) DESC, OD.AFACCTNO, OD.EXECTYPE, SB.SYMBOL;
    plog.setEndSection (pkgctx, 'pr_getOrder');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      p_err_code := systemnums.C_SUCCESS;
      p_err_param := 'SYSTEM ERROR';
      plog.setEndSection (pkgctx, 'pr_getOrder');
  END;

  /*
   /report/accounts/{accountId}/cashStatementHist - Transfer history
  */
  PROCEDURE pr_getCashStatement (p_refcursor in out ref_cursor,
                                p_accountId IN VARCHAR2,
                                p_fromDate  IN VARCHAR2,
                                p_toDate    IN VARCHAR2,
                                p_err_code  IN OUT VARCHAR2,
                                p_err_param IN OUT VARCHAR2)
  IS
  l_toDate   DATE;
  l_frDate   DATE;
  l_currDate DATE;
  v_maxciautoid number;
  BEGIN
    plog.setBeginSection (pkgctx, 'pr_getCashStatements');
    p_err_code := systemnums.C_SUCCESS;
    p_err_param := '';

    l_toDate := TO_DATE(p_toDate, 'dd/mm/rrrr');
    l_frDate := TO_DATE(p_fromDate, 'dd/mm/rrrr');
    SELECT TO_DATE(varvalue, 'dd/mm/rrrr') INTO l_currDate FROM sysvar WHERE varname = 'CURRDATE' AND grname = 'SYSTEM';
    BEGIN
        SELECT MAX(autoid) INTO v_maxciautoid FROM citran;
    EXCEPTION WHEN OTHERS THEN
        v_maxciautoid := 999999999999999;
    END;

    OPEN p_REFCURSOR FOR
        select /*+ NO_REWRITE */ 
		       --a.autoid,
               a.afacctno,
               TO_CHAR(a.busdate, 'dd/mm/rrrr') busdate,
               a.txnum transactionNum,
               a.tltxcd transactionCode,
               case when a.autoid = -1 then 0 else a.ci_credit_amt end creditAmt,
               case when a.autoid = -1 then 0 else a.ci_debit_amt end debitAmt,
               a.txdesc,
               a.ci_begin_bal beginingBalance,
               a.ci_receiving_bal,
               a.ci_end_bal endingBalance,
               case when a.autoid = -1 then a.ci_credit_amt - a.ci_debit_amt
                    else sum(a.ci_credit_amt) over(order by a.odrnum, a.busdate, a.txorder, a.autoid, a.txtype,a.txnum asc)
                            - sum(a.ci_debit_amt) over(order by a.odrnum, a.busdate, a.txorder, a.autoid, a.txtype,a.txnum asc)
               end available
        from
           (SELECT 0 odrnum, -1 autoid, ci.acctno afacctno, null busdate, null txnum, null tltxcd,
                  case when  ci.balance + nvl(tr.total_period_amt,0) >=0 then  ci.balance + nvl(tr.total_period_amt,0) else 0 end ci_credit_amt,
                  case when  ci.balance + nvl(tr.total_period_amt,0) <0 then  ci.balance + nvl(tr.total_period_amt,0) else 0 end ci_debit_amt,
                  'Dau Ky' txdesc,
                  0 ci_begin_bal,
                  0 ci_receiving_bal,
                  0 ci_end_bal,
                  0 txorder,
                  '' txtype
            from cimast ci, afmast af,
                 (SELECT tci.acctno,
                         SUM (case WHEN tci.txtype = 'D' then +tci.namt else -tci.namt end) total_period_amt
                  FROM vw_CITRAN_gen tci
                  where  tci.busdate >= l_frDate
                  and tci.acctno = p_accountId
                  and tci.field = 'BALANCE'
                  GROUP BY tci.acctno) tr
            where ci.acctno = tr.acctno (+) and ci.acctno =  p_accountId and ci.acctno = af.acctno and af.acctno = p_accountId
            and af.corebank <> 'Y'
    UNION ALL
        select 1 odrnum, tr.autoid, tr.afacctno, tr.busdate,tr.txnum,tr.tltxcd,
                ROUND(nvl(ci_credit_amt,0)) ci_credit_amt, ROUND(nvl(ci_debit_amt,0)) ci_debit_amt,
                case when tr.tltxcd = '1143' and tr.txcd = '0077' then 'So tien den han phai thanh toan'
                     when tr.tltxcd in ('1143','1153') and tr.txcd = '0011' and tr.trdesc is null then 'Phi ung truoc'
                     else to_char(tr.txdesc)
                end txdesc,
                ROUND(ci.ci_balance - nvl(ci_move_fromdt.ci_total_move_frdt_amt,0))  ci_begin_bal,
                ROUND(CI_RECEIVING - nvl(ci_RECEIVING_move,0)) ci_receiving_bal,
                ROUND(ci.ci_balance - nvl(ci_move_fromdt.ci_total_move_frdt_amt,0) + nvl(tr_period.total_period_amt,0)) ci_end_bal,
                tr.txorder,
                tr.txtype
        from
              (-- Tong so du CI hien tai group by TK luu ky
                select ci.afacctno, ci.intbalance ci_balance,
                    ci.RECEIVING CI_RECEIVING,
                    ci.EMKAMT CI_EMKAMT,
                    ci.DFDEBTAMT CI_DFDEBTAMT
                from buf_ci_account ci, afmast af
                where ci.afacctno = p_accountId and ci.afacctno = af.acctno and af.acctno = p_accountId
                and af.corebank <> 'Y'
              ) ci
        INNER join
              (-- Danh sach giao dich CI: tu From Date den ToDate
               select tci.autoid orderid, tci.custid, tci.custodycd, tci.acctno afacctno, tci.tllog_autoid autoid,
                      tci.txtype, tci.busdate, nvl(tci.trdesc,tci.txdesc) txdesc,
                      '' symbol, 0 se_credit_amt, 0 se_debit_amt,
                      case when tci.txtype = 'C' then namt else 0 end ci_credit_amt,
                      case when tci.txtype = 'D' then namt else 0 end ci_debit_amt,
                      tci.txnum, '' tltx_name, tci.tltxcd, tci.txdate, tci.txcd, tci.dfacctno dealno,
                      tci.old_dfacctno description, tci.trdesc, tci.bkdate,
                      CASE WHEN EXISTS(SELECT app.tltxcd FROM appmap app WHERE app.tltxcd = tci.tltxcd and apptype = 'CI' AND apptxcd IN ('0012','0029'))
                          THEN 0 ELSE 1 END txorder
               from (
                       select ci.autoid, ci.custodycd, af.custid,
                            ci.txnum, ci.txdate, ci.acctno, ci.txcd, ci.namt,
                            ci.camt, ci.ref, nvl(ci.deltd, 'N') deltd, ci.acctref,
                            ci.tltxcd, ci.busdate, ci.txdesc, ci.txtime, ci.brid, ci.tlid, ci.offid, ci.chid,
                            ci.ref dfacctno,
                            ' ' old_dfacctno,
                            ci.txtype, ci.field, ci.tllog_autoid, ci.trdesc, nvl(ci.busdate, ci.txdate) bkdate
                       from  vw_citran_gen CI,
                            -- VW_TLLOG_ALL TL, cfmast cf,, apptx app
                              afmast af
                       WHERE  ci.acctno = af.acctno                      
                       and af.corebank <> 'Y'                      
                      
                       AND ci.namt <>  0
                       and ci.tltxcd not in ('6690','6691','6621','6660','6600','6601','6602')
                       AND ci.busdate   between l_frDate and l_toDate
                       UNION ALL
                       SELECT 0 AUTOID, CF.custodycd, cf.custid, TL.txnum, TL.txdate, TL.MSGacct acctno,'D' txcd,
                            (case when TL.TLTXCD = '6668' then tl.msgamt else 0 end) namt,
                            '' camt, '' ref, nvl(TL.deltd, 'N') deltd, TL.MSGacct acctref,
                            tl.tltxcd, tl.busdate, tl.txdesc, tl.txtime, tl.brid, tl.tlid, tl.offid, tl.chid,
                            '' dfacctno,' ' old_dfacctno,
                            (case when TL.TLTXCD = '6668' then 'C' else 'D' end) txtype, 'BALANCE' field,
                             tl.autoid+1 tllog_autoid,
                            '' trdesc, TL.txdate bkdate
                       FROM VW_TLLOG_ALL TL, cfmast cf, afmast af
                       WHERE cf.custid = af.custid
                       AND TL.MSGacct = af.acctno
                       AND tl.deltd <> 'Y'
                       AND TL.TLTXCD in ('3324','6668')
                       AND tl.txdate   between l_frDate and l_toDate
                    ) tci
               where  tci.bkdate between l_frDate and l_toDate
               and tci.acctno = p_accountId
               and tci.field = 'BALANCE'
               AND TCI.TLTXCD NOT IN ('8855','8865','8856','8866','0066','1144','1145','8889')
               union ALL
               -------Tach giao dich mua ban
               SELECT max(tci.autoid) orderid, tci.custid, tci.custodycd, tci.acctno afacctno, max(tci.tllog_autoid) autoid, tci.txtype,
                      tci.busdate, case when TCI.TLTXCD = '8865' then 'Tra tien mua CK ngay' || to_char(max(tci.oddate),'dd/mm/rrrr')
                                        when TCI.TLTXCD = '8889' then 'Tra tien mua CK ngay' || to_char(max(tci.oddate),'dd/mm/rrrr')
                                        when TCI.TLTXCD = '8856' then 'Tra phi ban CK ngay' || to_char(max(tci.oddate),'dd/mm/rrrr')
                                        when TCI.TLTXCD = '8866' then 'Nhan tien ban CK ngay' || to_char(max(tci.oddate),'dd/mm/rrrr')
                                        else  'Tra phi mua CK ngay' || to_char(max(tci.oddate),'dd/mm/rrrr')
                                   end TXDESC,
                       '' symbol, 0 se_credit_amt, 0 se_debit_amt,
                       SUM(case when tci.txtype = 'C' then namt else 0 end) ci_credit_amt,
                       SUM(case when tci.txtype = 'D' then namt else 0 end) ci_debit_amt,
                       '' txnum, '' tltx_name, tci.tltxcd,  tci.txdate, tci.txcd, '' dealno,
                       '' description, '' trdesc, tci.bkdate,
                       CASE WHEN EXISTS(SELECT app.tltxcd FROM appmap app WHERE app.tltxcd = tci.tltxcd and apptype = 'CI' AND apptxcd IN ('0012','0029'))
                            THEN 0 ELSE 1 END txorder
               from   (select ci.autoid, ci.custodycd, af.custid,
                             ci.txnum, ci.txdate, ci.acctno, ci.txcd, ci.namt,
                             ci.camt, ci.ref, nvl(ci.deltd, 'N') deltd, ci.acctref,
                             ci.tltxcd, ci.busdate, ci.txdesc, ci.txtime, ci.brid, ci.tlid, 
                             ci.offid, ci.chid,
                             ci.ref dfacctno,
                             ' ' old_dfacctno,
                            ci.txtype, ci.field, ci.tllog_autoid, ci.trdesc,
                            ci.busdate bkdate, od.txdate oddate
                       from vw_citran_gen CI,
                             vw_odmast_all od,  afmast af--, apptx app --, VW_DFMAST_ALL df
                       WHERE  ci.acctno = af.acctno                     
                       and af.corebank <> 'Y' 
                       AND ci.ref= od.orderid
                       AND ci.namt <>  0
                       AND ci.busdate  between l_frDate and l_toDate ) tci
               where  tci.bkdate between l_frDate and l_toDate
               and tci.acctno = p_accountId
               and tci.field = 'BALANCE'
               AND TCI.TLTXCD IN ('8855','8865','8856','8866','8889')
               GROUP BY tci.custid, tci.custodycd, tci.acctno ,  tci.txtype, tci.busdate, tci.tltxcd, tci.txcd,tci.txdate,tci.bkdate
               union all
               -----Thue TNCN:
               SELECT max(tci.autoid) orderid,  tci.custid, tci.custodycd, tci.acctno afacctno, max(tci.tllog_autoid) autoid, tci.txtype,
                      tci.busdate, tci.description TXDESC,
                       '' symbol, 0 se_credit_amt, 0 se_debit_amt,
                      SUM(case when tci.txtype = 'C' then namt else 0 end) ci_credit_amt,
                      SUM(case when tci.txtype = 'D' then namt else 0 end) ci_debit_amt,
                      '' txnum, '' tltx_name, tci.tltxcd, tci.txdate, tci.txcd, '' dealno,
                      '' description, '' trdesc, tci.bkdate,
                      CASE WHEN EXISTS(SELECT app.tltxcd FROM appmap app WHERE app.tltxcd = tci.tltxcd and apptype = 'CI' AND apptxcd IN ('0012','0029'))
                          THEN 0 ELSE 1 END txorder
               FROM (
                       select ci.autoid, ci.custodycd, af.custid,
                              ci.txnum, ci.txdate, ci.acctno, ci.txcd, ci.namt,
                              ci.camt, ci.ref, nvl(ci.deltd, 'N') deltd, ci.acctref,
                              ci.tltxcd, ci.busdate, ci.txdesc, ci.txtime, ci.brid, ci.tlid, ci.offid, ci.chid,
                              ci.ref dfacctno,
                              ' ' old_dfacctno,
                              ci.txtype, ci.field, ci.tllog_autoid, ci.trdesc, ci.busdate bkdate,
                              CASE WHEN ci.txcd = '0011' THEN ci.txdesc
                                   WHEN ci.txcd = '0028' THEN ci.trdesc || ' Ngay' || substr(ci.txdesc, length(ci.txdesc) -10, 10)
                                   END description
                       from vw_citran_gen CI,
                            afmast af
                       where   ci.acctno       =    af.acctno                     
                       and af.corebank <> 'Y'                       
                       and     ci.namt         <>  0 
                       AND ci.busdate  between l_frDate and l_toDate ) tci
               where  tci.bkdate between l_frDate and l_toDate
               and tci.acctno = p_accountId
               and tci.field = 'BALANCE'
               AND TCI.TLTXCD IN ('0066')
               GROUP BY tci.custid, tci.custodycd, tci.acctno ,  tci.txtype, tci.busdate, tci.tltxcd,
               tci.txcd,tci.txdate,tci.bkdate, tci.description) tr on ci.afacctno = tr.afacctno
        left join
                (-- Tong phat sinh tang giam CI: tu From Date den ToDate
                  SELECT tci.acctno,
                        sum(case when tci.txtype = 'D' then -tci.namt else tci.namt end) total_period_amt
                  from vw_CITRAN_gen tci
                  where  tci.busdate between l_frDate and l_toDate
                  and tci.acctno = p_accountId
                  and tci.field = 'BALANCE'
                  GROUP BY tci.acctno ) tr_period on ci.afacctno = tr_period.acctno
        left JOIN
                (-- Tong phat sinh CI tu From date den ngay hom nay
                  select tr.acctno,
                         sum(case when tr.txtype = 'D' then -tr.namt else tr.namt end) ci_total_move_frdt_amt
                  from vw_CITRAN_gen tr
                  where
                      tr.busdate >= l_frDate and tr.busdate <= l_currDate
                      and tr.acctno = p_accountId
                      and tr.field in ('BALANCE')
                  group by tr.acctno ) ci_move_fromdt on ci.afacctno = ci_move_fromdt.acctno
        left join
                (-- Tong phat sinh CI.RECEIVING tu Todate + 1 den ngay hom nay
                    SELECT tr.acctno,
                           sum(
                                case when field = 'RECEIVING' then
                                    case when tr.txtype = 'D' then -tr.namt else tr.namt end
                                else 0
                                end
                                ) ci_RECEIVING_move,
                           sum(
                                case when field IN ('EMKAMT') then
                                    case when tr.txtype = 'D' then -tr.namt else tr.namt end
                                else 0
                                end
                                ) ci_EMKAMT_move,
                           sum(
                                case when field = 'DFDEBTAMT' then
                                    case when tr.txtype = 'D' then -tr.namt else tr.namt end
                                else 0
                                end
                                ) ci_DFDEBTAMT_move
                    from vw_citran_gen tr
                    WHERE tr.busdate > l_toDate and tr.busdate <= l_currDate
                        and tr.acctno = p_accountId
                        and tr.field in ('RECEIVING','EMKAMT','DFDEBTAMT')
                    group by tr.acctno ) ci_RECEIV on ci.afacctno = ci_RECEIV.acctno
    UNION ALL
        SELECT 2 odrnum, (v_maxciautoid + 1)  autoid, p_accountId afaccnto, null busdate, null txnum, null tltxcd,
                0 ci_credit_amt,
                0 ci_debit_amt,
                'Cuoi Ky' txdesc,
                0 ci_begin_bal,
                0 ci_receiving_bal,
                0 ci_end_bal,
                0 txorder,
                '' txtype
            from dual ) a
        order by a.odrnum desc, a.busdate desc, a.txorder desc, a.autoid desc, a.txtype desc, a.txnum desc
		;
    plog.setEndSection (pkgctx, 'pr_getCashStatement');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      p_err_code := systemnums.C_SUCCESS;
      p_err_param := 'SYSTEM ERROR';
      plog.setEndSection (pkgctx, 'pr_getCashStatement');
  END;

  /*
  /report/accounts/{accountId}/securitiesStatement - Stock transaction history
  */
  PROCEDURE pr_getSecuritiesStatement (p_refcursor in out ref_cursor,
                              p_accountId IN VARCHAR2,
                              p_fromDate  IN VARCHAR2,
                              p_toDate    IN VARCHAR2,
                              p_symbol    IN VARCHAR2 DEFAULT 'ALL',
                              p_err_code  IN OUT VARCHAR2,
                              p_err_param IN OUT VARCHAR2)
  IS
  l_frDate    DATE;
  l_toDate    DATE;
  l_currDate  DATE;
  l_symbol    VARCHAR2(100);
  l_beginAmt  NUMBER := 0;
  l_endAmt    NUMBER := 0;
  BEGIN
    plog.setBeginSection (pkgctx, 'pr_getSecuritiesStatement');
    p_err_code := systemnums.C_SUCCESS;
    p_err_param := '';

    l_frDate := TO_DATE(p_fromDate, 'dd/mm/rrrr');
    l_toDate := TO_DATE(p_toDate, 'dd/mm/rrrr');
    SELECT TO_DATE(varvalue, 'dd/mm/rrrr') INTO l_currDate FROM sysvar WHERE varname = 'CURRDATE' AND grname = 'SYSTEM';
    l_symbol := CASE WHEN upper(NVL(p_symbol, 'ALL')) = 'ALL' THEN '%' ELSE upper(p_symbol) END;

    OPEN p_REFCURSOR FOR
      select TO_CHAR(tr.busdate, 'dd/mm/rrrr') busdate,
             TO_CHAR(tr.txdate, 'dd/mm/rrrr')  txdate,
             nvl(tr.symbol,' ')    symbol,
             nvl(se_credit_amt,0)  creditAmt,
             nvl(se_debit_amt,0)   debitAmt,
             tr.txdesc             txdesc,
             tr.type_transact      transactType
      from (SELECT * from afmast af WHERE af.acctno = p_accountId) af
      left JOIN (
          -- Toan bo phat sinh CK tu FromDate den Todate
          select tse.custid, tse.custodycd, tse.afacctno, max(tse.tllog_autoid) autoid, max(tse.txtype) txtype, max(tse.txcd) txcd , max(tse.autoid) orderid,
              tse.busdate, max(nvl(tse.trdesc,tse.txdesc)) txdesc, to_char(max(tse.symbol)) symbol,
              sum(case when tse.txtype = 'C' then tse.namt else 0 end) se_credit_amt,
              sum(case when tse.txtype = 'D' then tse.namt else 0 end) se_debit_amt,
              0 ci_credit_amt, 0 ci_debit_amt,
              max(tse.tltxcd) tltxcd, max(tse.trdesc) trdesc, max(tl.TXDESC) type_transact,
              tse.txdate
          from vw_setran_gen tse, tltx tl
          where tse.busdate between l_frDate and l_toDate
          and tse.afacctno = p_accountId
          and tse.field in ('TRADE','MORTAGE','BLOCKED')
          and sectype <> '004'
          and tse.tltxcd = tl.tltxcd --ngoc.vu them truong loai giao dich
          AND TSE.symbol LIKE l_symbol
          group by tse.custid, tse.custodycd, tse.afacctno, tse.busdate, to_char(tse.symbol), tse.txdate, tse.txnum
          having sum(case when tse.txtype = 'D' then -tse.namt else tse.namt end) <> 0
      ) tr on af.acctno = tr.afacctno
      order BY
              tr.busdate,tr.autoid, tr.txtype, tr.orderid,
               case when tr.tltxcd = '1143' and tr.txcd = '0077' then utf8nums.c_const_RPT_CF1000_1143
               when tr.tltxcd in ('1143','1153') and tr.txcd = '0011' and tr.trdesc is null then utf8nums.c_const_RPT_CF1000_1153
               else to_char(tr.txdesc)
              end
    ;
    plog.setEndSection (pkgctx, 'pr_getSecuritiesStatement');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      p_err_code := systemnums.C_SUCCESS;
      p_err_param := 'SYSTEM ERROR';
      plog.setEndSection (pkgctx, 'pr_getSecuritiesStatement');
  END;

  /*
   /report/accounts/{accountId}/pnlExecuted - Realized profit and lost
  */
  PROCEDURE pr_getPnlExecuted (p_refcursor in out ref_cursor,
                              p_custid    IN VARCHAR2,
                              p_accountId IN VARCHAR2 DEFAULT 'ALL',
                              p_fromDate  IN VARCHAR2,
                              p_toDate    IN VARCHAR2,
                              p_symbol    IN VARCHAR2 DEFAULT 'ALL',
                              p_tradePlace IN VARCHAR2 DEFAULT 'ALL',
                              p_err_code  IN OUT VARCHAR2,
                              p_err_param IN OUT VARCHAR2)
  IS
  l_frDate     DATE;
  l_toDate     DATE;
  l_currDate   DATE;
  l_symbol     VARCHAR2(100);
  l_tradePlace VARCHAR2(100);
  l_taxRate    NUMBER;
  l_custid     VARCHAR2(30);
  l_accountId  VARCHAR2(30);
  BEGIN
    plog.setBeginSection (pkgctx, 'pr_getPnlExecuted');
    p_err_code := systemnums.C_SUCCESS;
    p_err_param := '';

    l_frDate := TO_DATE(p_fromDate, 'dd/mm/rrrr');
    l_toDate := TO_DATE(p_toDate, 'dd/mm/rrrr');
    l_accountId := CASE WHEN upper(NVL(p_accountId, 'ALL')) = 'ALL' THEN '%' ELSE upper(p_accountId) END;
    l_custid := p_custid;
    l_currDate := getcurrdate;
    l_symbol := CASE WHEN upper(NVL(p_symbol, 'ALL')) = 'ALL' THEN '%' ELSE upper(p_symbol) END;
    l_tradePlace := CASE WHEN upper(NVL(p_tradePlace, 'ALL')) = 'ALL' THEN '%'
                         WHEN upper(p_tradePlace) = 'HNX' THEN '002'
                         WHEN upper(p_tradePlace) = 'HSX' THEN '001'
                         WHEN upper(p_tradePlace) = 'UPCOM' THEN '005' END;
    l_taxRate := to_number(cspks_system.fn_get_sysvar('SYSTEM','ADVSELLDUTY'));

    OPEN p_refcursor FOR
        SELECT TO_CHAR(TXDATE, 'dd/mm/rrrr') txdate,
               afacctno                      accountId,
               SYMBOL,
               EXECTYPE,
               EXECTYPE_CODE,
               greatest(DCRQTTY, DDROUTQTTY) quantity,
               execPrice,
               COSTPRICE,
               SELLAMT,
               FEEACR                        feeAmt,
               taxsellamt                    taxSellAmt,
               PROFITANDLOSS                 pnl,
               CASE WHEN COSTPRICE * greatest(DCRQTTY, DDROUTQTTY) = 0 THEN 0
                    ELSE round(PROFITANDLOSS / (COSTPRICE * greatest(DCRQTTY, DDROUTQTTY))*100, 2)
               END                           pnlRate,
               COSTPRICE * greatest(DCRQTTY, DDROUTQTTY)           costPriceValue,
               execPrice * greatest(DCRQTTY, DDROUTQTTY)           execPriceValue
        FROM
        (
            SELECT STS.TXDATE,
                   A1.CDCONTENT EXECTYPE,
                   'ODEXECTYPE_' || EXECTYPE EXECTYPE_CODE,
                   STS.AFACCTNO,
                   STS.ORDERID,
                   STS.CODEID,
                   STS.SYMBOL,
                   CASE WHEN INSTR(sts.EXECTYPE,'B') > 0 THEN sts.EXECQTTY ELSE 0 END DCRQTTY,
                   CASE WHEN INSTR(sts.EXECTYPE,'B') > 0 THEN sts.EXECAMT + STS.FEEACR ELSE 0 END DCRAMT,
                   CASE WHEN INSTR(sts.EXECTYPE,'S') > 0 THEN sts.EXECQTTY ELSE 0 END DDROUTQTTY,
                   CASE WHEN INSTR(sts.EXECTYPE,'S') > 0 THEN round(STS.COSTPRICE * sts.EXECQTTY) ELSE 0 END DDROUTAMT,
                   CASE WHEN INSTR(sts.EXECTYPE,'S') > 0 THEN sts.EXECAMT - STS.FEEACR ELSE 0 END SELLAMT,
                   STS.EXECPRICE,
                   STS.FEEACR,
                   sts.taxsellamt,
                   CASE WHEN INSTR(sts.EXECTYPE,'S') > 0 THEN sts.EXECAMT - STS.FEEACR - round(STS.COSTPRICE * sts.EXECQTTY) ELSE 0 END PROFITANDLOSS,
                   ROUND(STS.COSTPRICE) COSTPRICE,
                   CASE WHEN INSTR(sts.EXECTYPE,'B') > 0 THEN 1 ELSE 2 END ODR
            FROM
            (
                SELECT OD.TXDATE,
                       OD.EXECTYPE,
                       OD.AFACCTNO,
                       OD.ORDERID,
                       OD.CODEID,
                       SB.SYMBOL,
                       OD.EXECAMT,
                       OD.EXECQTTY,
                       ROUND(OD.EXECAMT/OD.EXECQTTY,2) EXECPRICE,
                       CASE WHEN OD.EXECAMT >0 AND OD.FEEACR =0 AND OD.STSSTATUS = 'N' THEN OD.EXECAMT*ODT.DEFFEERATE/100 ELSE OD.FEEACR END FEEACR,
                       0 taxSellAmt,
                       0 PROFITANDLOSS,
                       NVL(SC.costprice,0) COSTPRICE
                FROM VW_ODMAST_ALL OD, SBSECURITIES SB, AFMAST AF, ODTYPE ODT, SECOSTPRICE SC,
                     aftype aft
                WHERE OD.CODEID = SB.CODEID AND AF.ACCTNO = OD.AFACCTNO
                    AND OD.ORSTATUS IN ('4','5','7','12') AND OD.EXECQTTY>0 AND INSTR(OD.EXECTYPE,'B') >0
                    AND OD.ACTYPE = ODT.ACTYPE
                    AND OD.seacctno = SC.acctno AND OD.txdate = SC.txdate
                    AND od.txdate < l_currDate
                    AND AF.ACCTNO LIKE l_accountId
                    AND af.custid = l_custid
                    AND af.actype = aft.actype
                    AND SB.SYMBOL LIKE l_symbol
                    AND sb.tradeplace LIKE l_tradePlace
                    AND OD.TXDATE BETWEEN l_frDate AND l_toDate
                UNION ALL
                SELECT OD.TXDATE,
                       OD.EXECTYPE,
                       OD.AFACCTNO,
                       OD.ORDERID,
                       OD.CODEID,
                       SB.SYMBOL,
                       OD.EXECAMT,
                       OD.EXECQTTY,
                       ROUND(OD.EXECAMT/OD.EXECQTTY,2) EXECPRICE,
                       CASE WHEN OD.EXECAMT >0 AND OD.FEEACR =0 AND OD.STSSTATUS = 'N' THEN OD.EXECAMT*ODT.DEFFEERATE/100 ELSE OD.FEEACR END FEEACR,
                       CASE WHEN OD.EXECAMT >0 AND OD.STSSTATUS = 'N' THEN OD.EXECAMT*to_number(sys.varvalue)/100 ELSE OD.taxsellamt END taxsellamt,
                       (STS.AMT - STS.QTTY * (CASE WHEN STS.TXDATE = l_currDate THEN SE.COSTPRICE ELSE STS.COSTPRICE END)) PROFITANDLOSS,
                       CASE WHEN STS.TXDATE = l_currDate THEN SE.COSTPRICE ELSE STS.COSTPRICE END COSTPRICE
                FROM VW_STSCHD_ALL STS, SBSECURITIES SB, AFMAST AF, SEMAST SE, VW_ODMAST_ALL OD, ODTYPE ODT, SYSVAR SYS
                WHERE OD.CODEID = SB.CODEID AND AF.ACCTNO = OD.AFACCTNO
                    AND OD.ORSTATUS IN ('4','5','7','12') AND OD.EXECQTTY>0 AND INSTR(OD.EXECTYPE,'S') >0
                    AND OD.ACTYPE = ODT.ACTYPE
                    and STS.DUETYPE= 'SS'
                    AND STS.acctno = SE.acctno
                    AND OD.orderid = STS.orgorderid
                    AND SYS.grname = 'SYSTEM' AND SYS.varname = 'ADVSELLDUTY'
                    AND od.txdate < l_currDate
                    AND AF.ACCTNO LIKE l_accountId AND af.custid = l_custid
                    AND SB.SYMBOL LIKE l_symbol
                    AND sb.tradeplace LIKE l_tradePlace
                    AND OD.TXDATE BETWEEN l_frDate AND l_toDate
            ) STS, ALLCODE A1
            WHERE A1.CDTYPE = 'OD' AND A1.CDNAME = 'EXECTYPE' AND A1.CDVAL = STS.EXECTYPE
            UNION ALL
            -- Cac GD lam thay doi gia von
            SELECT SE.TXDATE,
                   A2.cdcontent EXECTYPE,
                   'OLCPEXECTYPE_' || execType   EXECTYPE_EN,
                   SE.AFACCTNO,
                   SE.ORDERID,
                   Sb.CODEID,
                   Sb.SYMBOL,
                   SE.DCRQTTY,
                   SE.DCRAMT,
                   SE.DDROUTQTTY,
                   SE.DDROUTAMT,
                   SE.SELLAMT,
                   SE.EXECPRICE,
                   SE.FEEACR,
                   se.taxsellamt,
                   SE.PROFITANDLOSS,
                   round(nvl(sc.costprice,0)) COSTPRICE,
                   CASE WHEN SE.DCRQTTY > 0 THEN 1 ELSE 2 END ODR
            FROM
            (
                SELECT SE.busdate TXDATE,
                       SE.TLTXCD EXECTYPE,
                       SE.AFACCTNO,
                       TO_CHAR(MAX(SE.autoid)) ORDERID,
                       SE.CODEID,
                       max(sb.codeid) codeid2,
                       se.symbol,
                       SUM(CASE WHEN SE.field IN ('DCRQTTY') THEN SE.namt ELSE 0 END) DCRQTTY,
                       SUM(CASE WHEN SE.field IN ('DCRAMT') THEN SE.namt ELSE 0 END) DCRAMT,
                       SUM(CASE WHEN SE.field IN ('DDROUTQTTY') THEN SE.namt ELSE 0 END) DDROUTQTTY,
                       0 DDROUTAMT,
                       0 FEEACR,
                       0 PROFITANDLOSS,
                       0 COSTPRICE,
                       0 SELLAMT,
                       0 taxSellAmt,
                       0 EXECPRICE
                FROM setran_gen SE, (SELECT sb.tradeplace, nvl(sb.refcodeid,sb.codeid) codeid, sb.symbol FROM  sbsecurities sb) sb
                WHERE SE.tltxcd IN ('2201','2242','2266','2245','2246','3380',/*'8879','8848','8849',*/'2222','3384','3386','3324','3326','3314' )
                AND SE.field IN ('DCRQTTY','DDROUTQTTY','DCRAMT','DDROUTAMT')
                AND se.symbol = sb.symbol
                AND SE.AFACCTNO LIKE l_accountId AND se.custid = l_custid
                AND SE.SYMBOL LIKE l_symbol
                AND sb.tradeplace LIKE l_tradePlace
                AND SE.busdate BETWEEN l_frDate AND l_toDate
            GROUP BY SE.busdate, SE.TLTXCD, SE.AFACCTNO,SE.CODEID, SE.SYMBOL
            UNION ALL
            SELECT se.TXDATE,
                   SE.EXECTYPE,
                   SE.AFACCTNO,
                   se.ORDERID,
                   SE.CODEID,
                   se.codeid2,
                   se.symbol,
                   se.DCRQTTY,
                   se.DCRAMT,
                   se.DDROUTQTTY,
                   round(sr.COSTPRICE * se.DDROUTQTTY) DDROUTAMT,
                   sr.feeamt FEEACR,
                   sr.taxamt taxSellAmt,
                   CASE WHEN se.DDROUTQTTY > 0 THEN round(se.DDROUTAMT - sr.feeamt-sr.taxamt - sr.costprice * sr.qtty) ELSE 0 end PROFITANDLOSS,
                   round(sr.COSTPRICE) COSTPRICE,
                   CASE WHEN se.DDROUTQTTY > 0 THEN se.DDROUTAMT - sr.feeamt-sr.taxamt ELSE 0 END SELLAMT,
                   CASE WHEN se.DDROUTQTTY > 0 THEN round(se.DDROUTAMT/se.DDROUTQTTY,2) ELSE 0 END EXECPRICE
            FROM
            (
                SELECT SE.busdate TXDATE,
                       SE.TLTXCD EXECTYPE,
                       SE.AFACCTNO,
                       TO_CHAR(MAX(SE.autoid)) ORDERID,
                       SE.CODEID,
                       max(sb.codeid) codeid2,
                       se.symbol,
                       SUM(CASE WHEN SE.field IN ('DCRQTTY') THEN SE.namt ELSE 0 END) DCRQTTY,
                       SUM(CASE WHEN SE.field IN ('DCRAMT') THEN SE.namt ELSE 0 END) DCRAMT,
                       SUM(CASE WHEN SE.field IN ('DDROUTQTTY') THEN SE.namt ELSE 0 END) DDROUTQTTY,
                       SUM(CASE WHEN SE.field IN ('DDROUTAMT') THEN SE.namt ELSE 0 END) DDROUTAMT,
                       0 FEEACR,
                       0 PROFITANDLOSS,
                       0 COSTPRICE,
                       max(se.acctref) acctref
                FROM setran_gen SE, (SELECT tradeplace, nvl(sb.refcodeid,sb.codeid) codeid, sb.symbol FROM  sbsecurities sb) sb
                WHERE SE.tltxcd ='8879'
                    AND SE.field IN ('DCRQTTY','DDROUTQTTY','DCRAMT','DDROUTAMT')
                    AND se.symbol = sb.symbol
                    AND SE.AFACCTNO LIKE l_accountId AND se.custid = l_custid
                    AND SE.SYMBOL LIKE l_symbol
                    AND sb.tradeplace LIKE l_tradePlace
                    AND SE.busdate BETWEEN l_frDate AND l_toDate
                GROUP BY SE.busdate, SE.TLTXCD, SE.AFACCTNO,SE.CODEID, SE.SYMBOL
                ) se, seretail sr
                WHERE sr.TXDATE = to_date(substr(se.acctref,1,10),'dd/mm/rrrr') AND sr.txnum = substr(se.acctref,11)
            ) SE, allcode a2, sbsecurities sb, secostprice sc
            WHERE A2.CDTYPE = 'OL' AND A2.CDNAME = 'CPEXECTYPE' AND A2.CDVAL = SE.EXECTYPE
                AND se.codeid2 = sb.codeid
                AND sc.acctno = se.afacctno||se.codeid2
                AND sc.txdate = (SELECT max(txdate) FROM secostprice sc2 WHERE sc2.acctno = sc.acctno AND sc2.txdate <= se.txdate)
        ) STS
        ORDER BY STS.TXDATE, STS.ODR, STS.AFACCTNO, STS.EXECTYPE, STS.SYMBOL
    ;
    plog.setEndSection (pkgctx, 'pr_getPnlExecuted');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      p_err_code := systemnums.C_SUCCESS;
      p_err_param := 'SYSTEM ERROR';
      plog.setEndSection (pkgctx, 'pr_getPnlExecuted');
  END;

  /*
   /report/accounts/{accountId}/advancedStatement - Payment in advanced history
  */
  PROCEDURE pr_GetAdvancedStatement (pv_refCursor IN OUT ref_cursor,
                                     p_accountId  IN VARCHAR2,
                                     p_fromDate   IN VARCHAR2,
                                     p_toDate     IN VARCHAR2,
                                     p_err_code   OUT VARCHAR2,
                                     p_err_param  OUT VARCHAR2)
  IS
  l_frDate    DATE;
  l_toDate    DATE;
  BEGIN
    plog.setBeginSection (pkgctx, 'pr_GetAdvancedStatement');
    p_err_code := systemnums.C_SUCCESS;
    p_err_param := '';
    l_frDate := TO_DATE(p_fromDate, systemnums.C_DATE_FORMAT);
    l_toDate := TO_DATE(p_toDate, systemnums.C_DATE_FORMAT);

    OPEN pv_refCursor
    FOR
      SELECT TO_CHAR(AD.ODDATE, 'dd/mm/rrrr')    orderDate,
             TO_CHAR(AD.TXDATE, 'dd/mm/rrrr')    TXDATE,
             TO_CHAR(AD.CLEARDT, 'dd/mm/rrrr')   clearDate,
             STS.AMT,
             AD.AMT + AD.FEEAMT advancedAmt,
             AD.FEEAMT,
             AD.AMT receiveAmt,
             AD.CLEARDT - AD.TXDATE advancedDays,
             A1.CDCONTENT advancedStatus,
             'ADADSTATUS_' || a1.cdval advancedStatus_code,
             A2.CDCONTENT advancedPlace,
             'SAVIA_' || a2.cdval      advancedPlace_code
        FROM
        (
            SELECT STS.TXDATE, STS.AFACCTNO, SUM(STS.AMT-STS.FEEACR-STS.TAXSELLAMT) AMT, SUM(AAMT) AAMT, SUM(FAMT) FAMT, STS.CLEARDATE
            FROM
            (
                SELECT STS.TXDATE, STS.AFACCTNO, STS.AMT, STS.AAMT, STS.FAMT, OD.FEEACR, OD.TAXSELLAMT, STS.CLEARDAY, STS.CLEARCD, STS.CLEARDATE
                FROM (SELECT * FROM vw_stschd_all WHERE deltd <> 'Y' AND duetype = 'RM') STS,buf_ci_account buf,
                    (
                        SELECT OD.ORDERID,
                         CASE WHEN OD.FEEACR >0 THEN OD.FEEACR ELSE OD.EXECAMT*ODT.DEFFEERATE/100 END FEEACR,
                         CASE WHEN OD.TAXSELLAMT >0 THEN OD.TAXSELLAMT ELSE OD.EXECAMT*TO_NUMBER(SYS.VARVALUE)/100 END TAXSELLAMT
                         FROM VW_ODMAST_ALL OD, SYSVAR SYS, ODTYPE ODT
                          WHERE INSTR(OD.EXECTYPE,'S')>0 AND OD.EXECAMT >0
                             AND OD.ACTYPE = ODT.ACTYPE
                             AND SYS.GRNAME = 'SYSTEM' AND SYS.VARNAME = 'ADVSELLDUTY'
                    ) OD
                WHERE STS.ORGORDERID = OD.ORDERID
                    AND STS.DUETYPE = 'RM' AND STS.DELTD = 'N'
                    AND STS.AFACCTNO = p_accountId
                    AND buf.afacctno = sts.afacctno
            ) STS
            GROUP BY STS.TXDATE, STS.AFACCTNO, STS.CLEARDAY, STS.CLEARCD, STS.CLEARDATE
        ) STS
        INNER JOIN
            VW_ADSCHD_ALL AD
        ON AD.ACCTNO = STS.AFACCTNO AND AD.ODDATE = STS.TXDATE AND AD.CLEARDT = STS.CLEARDATE
            AND ad.TXDATE BETWEEN l_frDate AND l_toDate
        INNER JOIN
            ALLCODE A1
        ON A1.CDTYPE = 'AD' AND A1.CDNAME = 'ADSTATUS' AND A1.CDVAL = AD.STATUS||AD.DELTD
        INNER JOIN
            ALLCODE A2
        ON A2.CDTYPE = 'SA' AND A2.CDNAME = 'VIA' AND A2.CDVAL = DECODE(SUBSTR(AD.TXNUM,1,2),systemnums.C_OL_PREFIXED,'O','F')
        ORDER BY AD.ODDATE DESC, AD.AUTOID DESC, substr(AD.TXNUM,5,6) DESC
    ;

    plog.setEndSection (pkgctx, 'pr_GetAdvancedStatement');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_param := 'SYSTEM ERROR';
      plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_GetAdvancedStatement');
  END;

  /*
   /report/accounts/{accountId}/cashTransferStatement - Cash transaction history
  */
  PROCEDURE pr_GetCashTransferStatement (pv_refCursor IN OUT ref_cursor,
                                         p_accountId  IN VARCHAR2,
                                         p_fromDate   IN VARCHAR2,
                                         p_toDate     IN VARCHAR2,
                                         p_err_code   OUT VARCHAR2,
                                         p_err_param  OUT VARCHAR2)
  IS
  l_frDate    DATE;
  l_toDate    DATE;
  BEGIN
    plog.setBeginSection (pkgctx, 'pr_GetCashTransferStatement');
    p_err_code := systemnums.C_SUCCESS;
    p_err_param := '';
    l_frDate := TO_DATE(p_fromDate, systemnums.C_DATE_FORMAT);
    l_toDate := TO_DATE(p_toDate, systemnums.C_DATE_FORMAT);

    OPEN pv_refCursor
    FOR
      SELECT TO_CHAR(tlg.txdate, 'dd/mm/rrrr')  txDate,
             TO_CHAR(BUSDATE, 'dd/mm/rrrr') busDate,
             tlg.txnum                          transactionNum,
             trfamt                         amt,
             a3.cdcontent                   transferType,
             'OATRANSFERTYPE_' || tlg.TRFTYPEVALUE  transferType_code,
             a1.cdval                       status,
             'CIRMSTATUS_' || RMSTATUS      status_code,
             TRFCUSTODYCD                   transferCustodycd,
             RECVFULLNAME                   receiverName,
             RECVCUSTODYCD                  receiverCustodycd,
             RECVAFACCTNO                   receiverAccount,
             BENEFBANK                      receiverBank,
             tlg.tXDESC                     description,
             a2.cdcontent                   transferPlace,
             'SAVIA_' || a2.cdval           transferPlace_code
      FROM
        (
            SELECT TLG.TXDATE, TLG.BUSDATE, TLG.TXNUM, TLG.ACCTNO AFACCTNO, TLG.TLTXCD, TLG.NAMT TRFAMT,
                   TL.TXDESC TRFTYPE, DECODE(TLG.TLTXCD, '1120', '',CIR.BENEFBANK) BENEFBANK,
                   case when TLG.TLTXCD IN ('1201') THEN 'KBSV'  ELSE CIR.BENEFCUSTNAME end RECVFULLNAME,
                   CF.CUSTODYCD TRFCUSTODYCD, CIR.BENEFACCT RECVAFACCTNO,
                   TLG.TXDESC, CIR.BENEFLICENSE, CIR.CITYBANK, CIR.CITYEF,
                   CASE WHEN CIR.RMSTATUS in('E','W','M') THEN 'P' ELSE CIR.RMSTATUS END RMSTATUS,
                   CASE WHEN TLG.TLTXCD IN ('1120') THEN 'internal'
						WHEN  TLG.TLTXCD IN ('1201') THEN 'depoacc2transfer'
                        ELSE 'external'
                   END TRFTYPEVALUE,
                   DECODE(TLG.TLTXCD, '1120', CIR.BENEFBANK, '') RECVCUSTODYCD, TLG.AUTOID
            FROM CFMAST CF, AFMAST AF, CIREMITTANCE CIR, TLTX TL, (
                   SELECT * FROM VW_CITRAN_GEN TLG
                   WHERE TLG.BUSDATE >= l_frDate
                     AND TLG.BUSDATE <= l_toDate
                     AND TLG.TLTXCD IN ('1101','1108','1133','1120','1185','1111', '1201')--,'1130','1188'
                     AND TLG.TXCD='0011'
                     AND TLG.ACCTNO = p_accountId
                 )TLG
            WHERE TLG.TXDATE = CIR.TXDATE AND TLG.TXNUM = CIR.TXNUM
              AND CF.CUSTID = AF.CUSTID
              AND TL.TLTXCD = TLG.TLTXCD
              AND TLG.ACCTNO = AF.ACCTNO
              AND AF.ACCTNO = p_accountId
            UNION ALL
            SELECT ci.txdate, ci.busdate, CI.TXNUM, ci.ACCTNO afacctno, ci.tltxcd, ci.namt TRFAMT,
                   tltx.TXDESC TRFTYPE, DECODE(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) BENEFBANK,
                   cf.fullname RECVFULLNAME,
                   '' TRFCUSTODYCD, af.acctno RECVAFACCTNO,
                   ci.TXDESC, '' BENEFLICENSE, '' CITYBANK, '' CITYEF,
                   'C' RMSTATUS , 'internal' TRFTYPEVALUE,
                   cf.custodycd RECVCUSTODYCD, ci.autoid
            FROM VW_CITRAN_GEN ci, afmast af, cfmast cf , tltx
            where ci.acctno = af.acctno
              and af.custid = cf.custid
              and ci.field = 'BALANCE'
              and ci.tltxcd in ('1132','1184')
              and ci.tltxcd = tltx.tltxcd
              AND AF.ACCTNO = p_accountId
              AND ci.BUSDATE >= l_frDate
              AND ci.BUSDATE <= l_toDate
            UNION ALL
            SELECT ci.txdate, ci.busdate, CI.TXNUM, ci.acctno afacctno, ci.tltxcd, ci.namt TRFAMT,
                   tltx.TXDESC TRFTYPE, DECODE(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) BENEFBANK,
                   cfc.fullname RECVFULLNAME,
                   cf.custodycd TRFCUSTODYCD, afc.acctno RECVAFACCTNO,
                   nvl(ci.trdesc,ci.txdesc) TXDESC, '' BENEFLICENSE, '' CITYBANK, '' CITYEF,
                   'C' RMSTATUS , 'internal' TRFTYPEVALUE,
                   cfc.custodycd RECVCUSTODYCD, NULL autoid
            from vw_citran_gen ci,afmast af, cfmast cf, afmast afc,cfmast cfc, tltx
            where ci.acctno= af.acctno and cf.custid =af.custid
            and ci.ref =afc.acctno and afc.custid =cfc.custid
            and tltx.tltxcd = ci.tltxcd
            and ci.tltxcd in ('1188','1130') and ci.field ='BALANCE'
            and ci.txcd in ('0011','0012') and ci.txtype = 'D'
            AND AF.ACCTNO = p_accountId
            AND ci.BUSDATE >= l_frDate
            AND ci.BUSDATE <= l_toDate
            UNION ALL
            SELECT REQ.TXDATE, REQ.TXDATE BUSDATE, '' TXNUM, REQ.AFACCTNO, TL.TLTXCD, REQ.AMOUNT TRFAMT,
                   TL.TXDESC TRFTYPE, REQ.BENEFBANK,
                   REQ.BENEFCUSTNAME RECVFULLNAME,
                   CF.CUSTODYCD TRFCUSTODYCD, REQ.BENEFACCT RECVAFACCTNO,
                   TL.TXDESC, REQ.BENEFLICENSE, CFO.CITYBANK, CFO.CITYEF,
                   'P' RMSTATUS, 'external' TRFTYPEVALUE,
                   '' RECVCUSTODYCD, NULL autoid
            FROM EXTRANFERREQ REQ, CFMAST CF, AFMAST AF, TLTX TL, CFOTHERACC CFO, (
                 SELECT to_date(varvalue, 'DD/MM/RRRR') CURRDATE
                 FROM sysvar WHERE grname = 'SYSTEM' AND varname = 'CURRDATE'
            ) GR
            WHERE REQ.AFACCTNO = AF.ACCTNO
              AND AF.CUSTID = CF.CUSTID
              AND REQ.STATUS = 'P'
              AND TL.TLTXCD = '1118'
              AND CFO.AFACCTNO = REQ.AFACCTNO
              AND CFO.BANKACC = REQ.BENEFACCT
              AND REQ.TXDATE = GR.CURRDATE
              AND AF.ACCTNO = p_accountId
              AND REQ.TXDATE >= l_frDate
              AND REQ.TXDATE <= l_toDate
        ) TLG, ALLCODE A1, ALLCODE A2, allcode a3, (
            SELECT * FROM IPLOG WHERE txdate BETWEEN l_frDate AND l_toDate
            UNION ALL
            SELECT * FROM IPLOGHIST WHERE txdate BETWEEN l_frDate AND l_toDate
        ) ILG
      WHERE TLG.TXDATE = ILG.TXDATE(+) AND TLG.TXNUM = ILG.TXNUM(+)
      AND A1.CDTYPE = 'CI' AND A1.CDNAME = 'RMSTATUS' AND A1.CDVAL = TLG.RMSTATUS
      AND A2.CDTYPE = 'SA' AND A2.CDNAME = 'VIA' AND A2.CDVAL = NVL(ILG.VIA,DECODE(SUBSTR(NVL(TLG.TXNUM,'68'),1,2),systemnums.C_OL_PREFIXED,'O','F'))
      AND a3.CDTYPE = 'OA' AND a3.CDNAME = 'TRANSFERTYPE' AND a3.CDVAL = tlg.TRFTYPEVALUE
      ORDER BY TLG.TXDATE DESC, TLG.AUTOID DESC, SUBSTR(TLG.TXNUM,5,6) DESC
    ;
    plog.setEndSection (pkgctx, 'pr_GetCashTransferStatement');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_param := 'SYSTEM ERROR';
      plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_GetCashTransferStatement');
  END;

  /*
   /report/accounts/{accountId}/rightOffStatement - Right register history
  */
  PROCEDURE pr_GetRightOffStatement (pv_refCursor IN OUT ref_cursor,
                               p_custid     IN VARCHAR2,
                               p_accountId  IN VARCHAR2 DEFAULT 'ALL',
                               p_fromDate   IN VARCHAR2,
                               p_toDate     IN VARCHAR2,
                               p_err_code   OUT VARCHAR2,
                               p_err_param  OUT VARCHAR2)
  IS
  l_frDate    DATE;
  l_toDate    DATE;
  l_custid    VARCHAR2(20);
  l_accountId VARCHAR2(20);
  BEGIN
    plog.setBeginSection (pkgctx, 'pr_GetRightOffStatement');
    p_err_code := systemnums.C_SUCCESS;
    p_err_param := '';
    l_frDate := TO_DATE(p_fromDate, systemnums.C_DATE_FORMAT);
    l_toDate := TO_DATE(p_toDate, systemnums.C_DATE_FORMAT);
    l_custid := p_custid;
    l_accountId := CASE WHEN NVL(upper(p_accountId), 'ALL') = 'ALL' THEN '%' ELSE p_accountId END ;

    OPEN pv_refCursor
    FOR
      SELECT TO_CHAR(txdate, 'dd/mm/rrrr')    txdate,
             TO_CHAR(busdate, 'dd/mm/rrrr')   busDate,
             txnum        transactionNum,
             MSGACCT      accountId,
             KEYVALUE     camastId,
             symbol,
             execQtty     qtty,
             a1.cdcontent status,
             'SABORQSLOGSTS_' || a1.cdval   status_code,
             a2.cdcontent description,
             'OARIGHTOFFSTMTTYPE_' || a2.cdval   description_code
      FROM
        (
            -- GD DANG KY QUYEN MUA DANG CHO THUC HIEN
            SELECT RQ.TXDATE, RQ.TXDATE BUSDATE, RQ.TXNUM, '3384' TLTXCD, RQ.MSGACCT, RQ.KEYVALUE, SB.SYMBOL, RQ.MSGQTTY EXECQTTY,
                RQ.STATUS TXSTATUS, 'regist' EXECTYPE, RQ.AUTOID TLLOG_AUTOID
            FROM BORQSLOG RQ, CAMAST CA, SBSECURITIES SB, AFMAST AF
            WHERE RQ.STATUS IN ('P','W','H')
                AND CA.CAMASTID = RQ.KEYVALUE AND CA.TOCODEID = SB.CODEID
                AND RQ.MSGACCT = AF.ACCTNO
                AND RQ.TXDATE BETWEEN l_frDate AND l_toDate
                AND RQ.MSGACCT LIKE l_accountId AND af.custid = l_custid
            UNION ALL
            -- CAC GD DA THUC HIEN
            SELECT CA.TXDATE, CA.BUSDATE, CA.TXNUM, CA.TLTXCD, CA.AFACCTNO, CA.CAMASTID, SB.SYMBOL, CA.EXECQTTY,
                TXSTATUS, CA.EXECTYPE, CA.TLLOG_AUTOID
            FROM
            (
                -- GD DANG KY QUYEN MUA
                SELECT CA.TOCODEID,TLG.TXDATE, TLG.BUSDATE, TLG.TXNUM, TLG.TLTXCD, TLG.ACCTNO AFACCTNO, CA.CAMASTID, CA.CODEID, TLG.NAMT/CA.EXPRICE EXECQTTY,
                    'A' TXSTATUS, 'regist' EXECTYPE, TLG.TLLOG_AUTOID
                FROM
                    (SELECT * FROM VW_CITRAN_GEN TLG
                        WHERE TLG.TLTXCD = '3384' AND TLG.DELTD = 'N' AND TLG.TXCD = '0028'
                            AND TLG.TXDATE BETWEEN l_frDate AND l_toDate
                    ) TLG, CAMAST CA,CASCHD CAS
                WHERE CAS.AUTOID = TLG.ACCTREF
                    AND TLG.ACCTNO LIKE l_accountId AND tlg.custid = p_custid
                    AND CAS.CAMASTID=CA.CAMASTID
                UNION ALL
                -- GD NHAN CHUYEN NHUONG QUYEN MUA
                SELECT CA.TOCODEID,TLG.TXDATE, TLG.BUSDATE, TLG.TXNUM, TLG.TLTXCD, SUBSTR(TLG.ACCTNO,1,10) AFACCTNO, CA.CAMASTID, CA.CODEID, TLG.NAMT EXECQTTY,
                    'A' TXSTATUS, 'receive' EXECTYPE, TLG.TLLOG_AUTOID
                FROM
                    (SELECT * FROM VW_SETRAN_GEN TLG
                        WHERE TLG.TLTXCD IN ('3385','3382') AND TLG.DELTD = 'N' AND TLG.TXCD = '0045'
                            AND TLG.TXDATE BETWEEN l_frDate AND l_toDate
                    ) TLG, CAMAST CA, AFMAST AF
                WHERE CA.CAMASTID = TLG.REF
                    AND AF.ACCTNO = SUBSTR(TLG.ACCTNO,1,10)
                    AND AF.ACCTNO LIKE l_accountId AND af.custid = l_custid

                UNION ALL
                -- GD CHUYEN NHUONG QUYEN RA NGOAI
                SELECT CA.TOCODEID,TLG.TXDATE, TLG.BUSDATE, TLG.TXNUM, TLG.TLTXCD, SUBSTR(TLG.ACCTNO,1,10) AFACCTNO, CA.CAMASTID, CA.CODEID, TLG.NAMT EXECQTTY,
                    'A' TXSTATUS, 'transfer' EXECTYPE, TLG.TLLOG_AUTOID
                FROM
                    (SELECT * FROM VW_SETRAN_GEN TLG
                        WHERE TLG.TLTXCD IN ('3383','3382') AND TLG.DELTD = 'N' AND TLG.TXCD = '0040'
                            AND TLG.TXDATE BETWEEN l_frDate AND l_toDate
                    ) TLG, CAMAST CA, AFMAST AF
                WHERE CA.CAMASTID = TLG.REF
                    AND AF.ACCTNO = SUBSTR(TLG.ACCTNO,1,10)
                    AND AF.ACCTNO LIKE l_accountId AND af.custid = l_custid

                UNION ALL
                -- GD HUY DANG KY QUYEN MUA
                SELECT CA.TOCODEID,TLG.TXDATE, TLG.BUSDATE, TLG.TXNUM, TLG.TLTXCD, SUBSTR(TLG.ACCTNO,1,10) AFACCTNO, CA.CAMASTID, CA.CODEID, TLG.NAMT EXECQTTY,
                    'A' TXSTATUS, 'cancelRegist' EXECTYPE, TLG.TLLOG_AUTOID
                FROM
                    (SELECT * FROM VW_SETRAN_GEN TLG
                        WHERE TLG.TLTXCD IN ('3386') AND TLG.DELTD = 'N' AND TLG.TXCD = '0045'
                            AND TLG.TXDATE BETWEEN l_frDate AND l_toDate
                    ) TLG, CAMAST CA, AFMAST AF
                WHERE CA.CAMASTID = TLG.REF
                    AND AF.ACCTNO = SUBSTR(TLG.ACCTNO,1,10)
                    AND AF.ACCTNO LIKE l_accountId AND af.custid = l_custid
                UNION ALL
                -- GD DK MUA CP PHAT HANH THEM KO CAT CI
                SELECT CA.TOCODEID,TLG.TXDATE, TLG.BUSDATE, TLG.TXNUM, TLG.TLTXCD, SUBSTR(TLG.ACCTNO,1,10) AFACCTNO, CA.CAMASTID, CA.CODEID, TLG.NAMT EXECQTTY,
                    'A' TXSTATUS, 'registNci' EXECTYPE, TLG.TLLOG_AUTOID
                FROM
                    (SELECT * FROM VW_SETRAN_GEN TLG
                        WHERE TLG.TLTXCD IN ('3324') AND TLG.DELTD = 'N' AND TLG.TXCD = '0016'
                            AND TLG.TXDATE BETWEEN l_frDate AND l_toDate
                    ) TLG, CAMAST CA, AFMAST AF, caschd cas
                WHERE CAs.autoid = TLG.REF
                    AND ca.camastid = cas.camastid AND af.acctno = cas.afacctno
                    AND AF.ACCTNO = SUBSTR(TLG.ACCTNO,1,10)
                    AND AF.ACCTNO LIKE l_accountId AND af.custid = l_custid
                UNION ALL
                -- GD HUY DK MUA CP PHAT HANH THEM KO CAT CI
                SELECT CA.TOCODEID,TLG.TXDATE, TLG.BUSDATE, TLG.TXNUM, TLG.TLTXCD, SUBSTR(TLG.ACCTNO,1,10) AFACCTNO, CA.CAMASTID, CA.CODEID, TLG.NAMT EXECQTTY,
                    'A' TXSTATUS, 'cancelRegistNci' EXECTYPE, TLG.TLLOG_AUTOID
                FROM
                    (SELECT * FROM VW_SETRAN_GEN TLG
                        WHERE TLG.TLTXCD IN ('3326') AND TLG.DELTD = 'N' AND TLG.TXCD = '0015'
                            AND TLG.TXDATE BETWEEN l_frDate AND l_toDate
                    ) TLG, CAMAST CA, AFMAST AF, caschd cas
                WHERE CAs.autoid = TLG.REF
                    AND ca.camastid = cas.camastid AND af.acctno = cas.afacctno
                    AND AF.ACCTNO = SUBSTR(TLG.ACCTNO,1,10)
                    AND AF.ACCTNO LIKE l_accountId AND  af.custid = l_custid
            ) CA, SBSECURITIES SB
            WHERE CA.TOCODEID = SB.CODEID
        ) A, ALLCODE A1, allcode a2
        WHERE a1.CDTYPE = 'SA' AND a1.CDNAME = 'BORQSLOGSTS' AND a1.cdval = a.txstatus
        AND a2.CDTYPE = 'OA' AND a2.CDNAME = 'RIGHTOFFSTMTTYPE' AND a2.cdval = a.EXECTYPE
        ORDER BY A.BUSDATE DESC, A.TLLOG_AUTOID DESC, SUBSTR(A.TXNUM,5,6) DESC
    ;
    plog.setEndSection (pkgctx, 'pr_GetRightOffStatement');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_param := 'SYSTEM ERROR';
      plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_GetRightOffStatement');
  END;

  /*
   /report/accounts/{accountId}/loanList - List Of Account Loan
  */
  PROCEDURE pr_GetLoanList (pv_refCursor IN OUT ref_cursor,
                         p_custid     IN VARCHAR2,
                         p_accountId  IN VARCHAR2 DEFAULT 'ALL',
                         p_fromDate   IN VARCHAR2,
                         p_toDate     IN VARCHAR2,
                         p_err_code   OUT VARCHAR2,
                         p_err_param  OUT VARCHAR2)
  IS
  l_frDate    DATE;
  l_toDate    DATE;
  l_custId    VARCHAR2(30);
  l_accountId VARCHAR2(30);
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_GetLoanList');
    p_err_code := systemnums.C_SUCCESS;
    p_err_param := '';
    l_frDate := TO_DATE(p_fromDate, systemnums.C_DATE_FORMAT);
    l_toDate := TO_DATE(p_toDate, systemnums.C_DATE_FORMAT);
    l_custId := p_custid;
    l_accountId := CASE WHEN NVL(upper(p_accountId), 'ALL') = 'ALL' THEN '%' ELSE p_accountId END;

    OPEN pv_refCursor
    FOR
        SELECT accountId,
               loanAccount,
               typeName,
               releaseDate,
               overDueDate,
               releaseAmt,
               paid,
               interestPaid,
               remainDebt,
               interest,
               totalLoan,
               DAYS,
               overDueinterest,
               AVGRATE,
               DESCRIPTION_CODE 
        from (
           SELECT af.acctno    accountId,
                  TY.TYPENAME  typeName,
                  TO_CHAR(SCHD.RLSDATE, 'dd/mm/rrrr')   releaseDate,
                  TO_CHAR(SCHD.OVERDUEDATE, 'dd/mm/rrrr')   overDueDate,
                  SCHD.NML + SCHD.OVD + SCHD.PAID           releaseAmt,
                  SCHD.PAID                                 paid,
                  SCHD.INTPAID + SCHD.FEEINTPAID + SCHD.FEEINTPREPAID interestPaid,
                  SCHD.NML + SCHD.OVD            remainDebt,
                  SCHD.INTNMLACR  + SCHD.INTOVD + SCHD.INTDUE + SCHD.FEEINTNMLACR + SCHD.FEEINTDUE + SCHD.FEEINTNMLOVD interest,
                  ROUND( SCHD.INTOVDPRIN + SCHD.FEEINTOVDACR+SCHD.INTNMLACR  + SCHD.INTOVD + SCHD.INTDUE + SCHD.FEEINTNMLACR + SCHD.FEEINTDUE + SCHD.FEEINTNMLOVD+SCHD.NML + SCHD.OVD) totalLoan,
                  case when ROUND( SCHD.INTOVDPRIN + SCHD.FEEINTOVDACR + SCHD.INTNMLACR + SCHD.INTOVD + SCHD.INTDUE + SCHD.FEEINTNMLACR + SCHD.FEEINTDUE + SCHD.FEEINTNMLOVD+SCHD.NML + SCHD.OVD) > 0 then   SCHD.DAYS
                       else DATEDIFF('D', schd.rlsdate, schd.PAIDDATE) end DAYS,
                  SCHD.INTOVDPRIN + SCHD.FEEINTOVDACR overDueinterest,
                  LN.ACCTNO loanAccount,
                   (case when lns.autoid is not null then nvl(SCHD.AVGRATE,0) else SCHD.RATE2 end ) AVGRATE,
                   (case when lns.autoid is not null then 'FODESCOUTSTANDING_S'
                         else (case when ls39.autoid is not null then 'FODESCOUTSTANDING_F' else 'FODESCOUTSTANDING_N' end )  end) DESCRIPTION_CODE
            FROM CFMAST CF, AFMAST AF, LNMAST LN, LNTYPE TY,
                 (SELECT LNSCHD.*,DATEDIFF('D', RLSDATE, GETCURRDATE) DAYS FROM LNSCHD WHERE REFTYPE IN ('GP', 'P') AND DUENO = 0
                    union all
                 select lnschdhist.*, DATEDIFF('D', RLSDATE, GETCURRDATE) DAYS FROM LNSCHDhist WHERE REFTYPE IN ('GP', 'P') AND DUENO = 0
                 ) SCHD,  
                 (select distinct ls.autoid from lnschdexthist ls group by ls.autoid) lns,
                 ( select ls.* from tblintchangehist t, lnmast ln, lnschd ls
                   where ln.acctno = ls.acctno and ln.trfacctno = t.afacctno 
                     and ln.actype = t.lntype and  t.ALLLNSCHD = 'Y' and t.deltd = 'Y' and ls.rate1 = t.rate1a 
                     and ls.rate2 = t.rate2a and ls.rate3 = t.rate3a and ls.rlsdate < t.fdate )ls39
           WHERE AF.CUSTID = CF.CUSTID
             AND AF.ACCTNO = LN.TRFACCTNO
             AND LN.ACTYPE = TY.ACTYPE
             AND SCHD.ACCTNO = LN.ACCTNO
			 AND lns.autoid (+)= SCHD.autoid 
			 AND ls39.autoid (+) = SCHD.autoid 
             AND SCHD.RLSDATE >= l_frDate
             AND SCHD.RLSDATE <= l_toDate
             AND AF.ACCTNO like l_accountId AND af.custid = l_custId
           ORDER BY SCHD.RLSDATE DESC, LN.ACCTNO
        ) a
    ;

    plog.setEndSection(pkgctx, 'pr_GetLoanList');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_param := 'SYSTEM ERROR';
      plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_GetLoanList');
  END;

  /*
   /report/accounts/{accountId}/paymentHist - payment
  */
  PROCEDURE pr_GetPaymentHist (pv_refCursor IN OUT ref_cursor,
                         p_custid     IN VARCHAR2,
                         p_accountId  IN VARCHAR2 DEFAULT 'ALL',
                         p_fromDate   IN VARCHAR2,
                         p_toDate     IN VARCHAR2,
                         p_err_code   OUT VARCHAR2,
                         p_err_param  OUT VARCHAR2)
  IS
  l_frDate    DATE;
  l_toDate    DATE;
  l_custid    VARCHAR2(30);
  l_accountId VARCHAR2(30);
  BEGIN
    p_err_code := systemnums.C_SUCCESS;
    p_err_param := '';
    l_frDate := TO_DATE(p_fromDate, 'dd/mm/rrrr');
    l_toDate := TO_DATE(p_toDate, 'dd/mm/rrrr');
    l_custId := p_custid;
    l_accountId := CASE WHEN NVL(upper(p_accountId), 'ALL') = 'ALL' THEN '%' ELSE p_accountId END;

    OPEN pv_refCursor FOR
       select accountId,
             loanAccount,
             releaseDate,
             overDueDate,
             txdate,
             orgLoan,
             prinPaid,
             interestPaid,
             remain
       FROM (
          select ln.trfacctno                          accountId,
                 ln.acctno                             loanAccount,
                 TO_CHAR(ls.rlsdate, 'dd/mm/rrrr')     releaseDate,
                 TO_CHAR(ls.overduedate, 'dd/mm/rrrr') overDueDate,
                 TO_CHAR(lntr.txdate, 'dd/mm/rrrr')    txdate,
                 ls.nml + ls.ovd + ls.paid             orgLoan,
                 ABS(lntr.prin_move)                   prinPaid,
                 lntr.int_move                         interestPaid,
                 ls.nml + ls.ovd - sum(nvl(lnmov.prin_move,0)) remain
          from (select * from VW_LNMAST_ALL where trfacctno IN (SELECT acctno FROM afmast WHERE custid = l_custid AND acctno LIKE l_accountId )) ln
               inner JOIN (select * from VW_LNSCHD_ALL where reftype in ('P','GP')  ) ls on ln.acctno = ls.acctno
               inner JOIN (
                  select autoid, txdate
                      ,sum((case when nml > 0 then 0 else nml end) + ovd) PRIN_MOVE
                      ,sum(intpaid) INT_MOVE
                  from VW_LNSCHDLOG_ALL lnslog
                  where (case when nml > 0 then 0 else nml end) + ovd + intpaid <> 0
                  and txdate >= l_frDate and txdate <= l_toDate
                  group by autoid,txdate ) LNTR  on ls.autoid = lntr.autoid
               left join
               (
                  select log.autoid, log.txdate,sum((case when log.nml > 0 then 0 else log.nml end) + log.ovd) PRIN_MOVE
                  from VW_LNSCHDLOG_ALL log, VW_LNMAST_ALL LN, VW_LNSCHD_ALL LM, afmast af
                  where (case when log.nml > 0 then 0 else log.nml end) + log.ovd <> 0
                  AND LOG.AUTOID = LM.AUTOID AND LN.ACCTNO=LM.ACCTNO
                  AND ln.trfacctno = af.acctno
                  AND LN.TRFACCTNO LIKE l_accountId AND af.custid = l_custid
                  group by log.autoid,log.txdate
              ) LNmov on lntr.autoid = lnmov.autoid and lnmov.txdate > lntr.txdate
          group by lntr.autoid, lntr.txdate, ln.acctno, ls.rlsdate, ls.overduedate,
                  ls.nml, ls.ovd, ls.paid, lntr.prin_move, lntr.int_move, ln.trfacctno
          order by lntr.txdate desc, lntr.autoid
        ) a
    ;
    plog.setEndSection (pkgctx, 'pr_GetPaymentHist');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_param := 'SYSTEM ERROR';
      plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_GetPaymentHist');
  END;

  /*
   /report/accounts/{accountId}/stockTransferStatement - payment
  */
  PROCEDURE pr_GetStockTransferStatement (pv_refCursor IN OUT ref_cursor,
                         p_custid     IN VARCHAR2,
                         p_accountId  IN VARCHAR2 DEFAULT 'ALL',
                         p_fromDate   IN VARCHAR2,
                         p_toDate     IN VARCHAR2,
                         p_err_code   OUT VARCHAR2,
                         p_err_param  OUT VARCHAR2)
  IS
  l_frDate    DATE;
  l_toDate    DATE;
  l_custId    VARCHAR2(30);
  l_accountId VARCHAR2(30);
  BEGIN
    plog.setBeginSection (pkgctx, 'pr_GetStockTransferStatement');
    l_frDate := TO_DATE(p_fromDate, 'dd/mm/rrrr');
    l_toDate := TO_DATE(p_toDate, 'dd/mm/rrrr');
    l_custId := p_custid;
    l_custId := p_custid;
    l_accountId := CASE WHEN NVL(upper(p_accountId), 'ALL') = 'ALL' THEN '%' ELSE p_accountId END;

    OPEN pv_refCursor
    FOR
      SELECT TO_CHAR(txdate, 'dd/mm/rrrr')   transactionDate, txnum,
             sb.symbol,
             receiveAccount,
             transferAccount,
             trade + blocked quantity,
             a.cdcontent   status,
             'SYTXSTATUS_' || tl.txstatus status_CODE
      FROM (
        SELECT tl.txdate,
               tl.txnum,
               tl.TXSTATUS,
               MAX(DECODE(fld.FLDCD, '03', SUBSTR(fld.CVALUE, 1, 10), '')) transferAccount,
               MAX(DECODE(fld.FLDCD, '05', SUBSTR(fld.CVALUE, 1, 10), '')) receiveAccount,
               MAX(DECODE(fld.FLDCD, '06', fld.nvalue, '')) blocked,
               MAX(DECODE(fld.FLDCD, '10', fld.nvalue, '')) trade,
               MAX(DECODE(fld.FLDCD, '01', fld.CVALUE, '')) codeid
        FROM vw_tllog_all tl, vw_tllogfld_all fld
        WHERE tl.TXDATE = fld.TXDATE AND tl.TXNUM = fld.TXNUM
        AND tl.TXDATE BETWEEN l_frDate AND l_toDate
        AND tl.TLTXCD = '2242'
        AND fld.FLDCD IN ('03','05','06','10', '01')
        AND deltd <> 'Y'
        GROUP BY tl.txdate, tl.txnum, tl.TXSTATUS
      ) tl, afmast af, sbsecurities sb, Allcode a
      WHERE tl.transferAccount = af.acctno
        AND tl.codeid = sb.codeid
        AND a.cdname = 'TXSTATUS' AND a.cdtype = 'SY' AND a.cdval = tl.TXSTATUS
        AND af.custid = l_custId AND af.acctno LIKE l_accountId
      ORDER BY txdate DESC, substr(TXNUM,5,6) DESC
    ;
    plog.setEndSection (pkgctx, 'pr_GetStockTransferStatement');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_param := 'SYSTEM ERROR';
      plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_GetStockTransferStatement');
  END;

  /*
  /report/accounts/{accountId}/sellOddLotHists - History Of available Sell Odd Lot
  */
  PROCEDURE pr_GetSellOddLotHist (pv_refCursor IN OUT ref_cursor,
                               p_custId     IN VARCHAR2,
                               p_accountId  IN VARCHAR2 DEFAULT 'ALL',
                               p_frDate     IN VARCHAR2,
                               p_toDate     IN VARCHAR2,
                               p_err_code   OUT VARCHAR2,
                               p_err_param  OUT VARCHAR2)
  IS
  l_custId      VARCHAR2(30);
  l_accountId   VARCHAR2(30);
  l_currDate    DATE;
  l_advSellDuty NUMBER;
  l_frDate      DATE;
  l_toDate      DATE;
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_GetSellOddLotHist');
    p_err_code := systemnums.C_SUCCESS;
    p_err_param := '';
    l_custId := p_custId;
    l_accountId := CASE WHEN NVL(upper(p_accountId), 'ALL') = 'ALL' THEN '%' ELSE p_accountId END;
    l_currDate := getcurrdate;
    l_frDate := TO_DATE(p_frDate, 'dd/mm/rrrr');
    l_toDate := TO_DATE(p_toDate, 'dd/mm/rrrr');
    BEGIN
      SELECT VARVALUE INTO l_advSellDuty
      from sysvar where varname = 'ADVSELLDUTY';
    EXCEPTION
      WHEN OTHERS THEN
        l_advSellDuty := 0;
    END;
    OPEN pv_refCursor
    FOR
        SELECT od.AFACCTNO      accountId,
               SYMBOL         symbol,
               QTTY           quantity,
               PRICE          price,
               QTTY * PRICE   amount,
               FEEAMT         feeamt,
               round(TAXAMT)  taxAmt,
               round((QTTY * PRICE) - FEEAMT - TAXAMT) expReceiveAmt,
               CASE WHEN NVL(tran.namt, 0) = 0 THEN 0 ELSE tran.namt - taxAmt - pitamt  END receiveAmt,
               status,
               TXNUM,
               TO_CHAR(TXDATE, 'dd/mm/rrrr') txdate
        FROM
        (
            SELECT FN_GET_LOCATION(AF.BRID) LOCATION, CF.CUSTODYCD,
                   C.CODEID, C.SYMBOL,
                   C.PARVALUE, A.AFACCTNO, B.* ,
                   CF.IDCODE ,A4.CDCONTENT TRADEPLACE,
                   A2.AFACCTNO AFACCTNO2
            FROM SEMAST A, SERETAIL B, SBSECURITIES C, AFMAST AF, CFMAST CF ,ALLCODE A4, SEMAST A2
            WHERE A.ACCTNO = B.ACCTNO AND A.CODEID = C.CODEID
            AND B.QTTY > 0
            --AND B.status ='N'
            AND AF.ACCTNO = A.AFACCTNO
            AND AF.CUSTID = CF.CUSTID
            AND A4.CDTYPE = 'SE' AND A4.CDNAME = 'TRADEPLACE' AND A4.CDVAL = C.TRADEPLACE
            AND A2.ACCTNO = B.DESACCTNO
            AND AF.ACCTNO LIKE l_accountId AND af.custid = l_custId
            AND b.txdate BETWEEN l_frDate AND l_toDate
        )od
        LEFT JOIN (SELECT ci.namt, ci.acctno, acctref
                   FROM vw_citran_gen ci
                   WHERE acctno = l_accountId
                   AND ci.tltxcd = '8894'
                   AND ci.field = 'RECEIVING') tran ON tran.acctref = to_char(od.txdate,'dd/mm/yyyy') || od.txnum
                                            AND tran.acctno = od.acctno
    ;
    plog.setEndSection(pkgctx, 'pr_GetSellOddLotHist');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_param := 'SYSTEM ERROR';
      plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_GetSellOddLotHist');
  END;

  /*
  /report/accounts/{accountId}/bondsToSharesHist - History Of regist bond to shares
  */
  PROCEDURE pr_GetBondsToSharesHist (pv_refCursor IN OUT ref_cursor,
                               p_accountId  IN VARCHAR2,
                               p_frDate     IN VARCHAR2,
                               p_toDate     IN VARCHAR2,
                               p_err_code   OUT VARCHAR2,
                               p_err_param  OUT VARCHAR2)
  IS
  l_accountId   VARCHAR2(30);
  l_currDate    DATE;
  l_advSellDuty NUMBER;
  l_frDate      DATE;
  l_toDate      DATE;
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_GetBondsToSharesHist');
    p_err_code := systemnums.C_SUCCESS;
    p_err_param := '';
    l_accountId := p_accountId;
    l_currDate := getcurrdate;
    l_frDate := TO_DATE(p_frDate, 'dd/mm/rrrr');
    l_toDate := TO_DATE(p_toDate, 'dd/mm/rrrr');
    OPEN pv_refCursor
    FOR
         SELECT af.acctno    accountId,
                TO_CHAR(tran.txdate, 'dd/mm/rrrr')   txdate,
                ca.symbol symbol,
                CASE WHEN tl.tltxcd = '3327' THEN tl.msgamt ELSE -tl.msgamt END Quantity,
                chd.amt amount,
                A1.CDCONTENT  STATUS,
                'SYTXSTATUS_1'  status_code
        FROM (SELECT * FROM catran UNION ALL SELECT * FROM catrana) tran,
             ALLCODE A1,
             vw_tllog_all tl, cfmast cf, afmast af,tlprofiles mk, tlprofiles ck,
            (
                SELECT camastid, sb.symbol symbol, tosb.symbol tosymbol
                FROM camast ca, sbsecurities tosb, sbsecurities sb
                WHERE nvl(ca.tocodeid, ca.codeid) = tosb.codeid
                AND ca.codeid = sb.codeid
            ) ca,
            vw_caschd_all chd
        WHERE tl.txdate = tran.txdate AND tl.txnum = tran.txnum
        AND cf.custid = af.custid AND af.acctno = tl.msgacct
        AND TL.TLID = MK.TLID (+) AND tl.offid = ck.TLID(+)
        AND ca.camastid = chd.camastid
        AND chd.autoid = tran.acctno
        AND tl.tltxcd IN ('3327','3328')
        AND TL.DELTD<>'Y'
        AND A1.CDTYPE='SY' AND A1.CDNAME='TXSTATUS' AND A1.CDVAL='1'
        AND tl.busdate BETWEEN l_frDate AND l_toDate
        AND AF.ACCTNO = l_accountId
        ORDER BY tran.TXDATE,tran.txnum,ca.symbol
    ;
    plog.setEndSection(pkgctx, 'pr_GetBondsToSharesHist');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_param := 'SYSTEM ERROR';
      plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_GetBondsToSharesHist');
  END;

  /*
  /report/accounts/{accountId}/confirmOrderHist - History Of available Sell Odd Lot
  */
  PROCEDURE pr_GetConfirmOrderHist (pv_refCursor IN OUT ref_cursor,
                               p_custId     IN VARCHAR2,
                               p_accountId  IN VARCHAR2 DEFAULT 'ALL',
                               p_err_code   OUT VARCHAR2,
                               p_err_param  OUT VARCHAR2)
  IS
  l_custId      VARCHAR2(30);
  l_accountId   VARCHAR2(30);
  l_currDate    DATE;
  l_advSellDuty NUMBER;
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_GetConfirmOrderHist');
    p_err_code := systemnums.C_SUCCESS;
    p_err_param := '';
    l_custId := p_custId;
    l_accountId := CASE WHEN NVL(upper(p_accountId), 'ALL') = 'ALL' THEN '%' ELSE p_accountId END;
    l_currDate := getcurrdate;
    
    OPEN pv_refCursor
    FOR
        select TO_CHAR(txdate, 'dd/mm/rrrr')   txdate,
               afacctno                        accountId,
               symbol,
               tradeplace,
               tradeplace_code,
               execType,
               execType_code,
               pricetype,
               via,
               via_code,
               orderQtty,
               quotePrice                      price,
               orderid
        from
        (
            SELECT OD.ORDERID,
                   OD.TXDATE,
                   OD.CODEID,
                   a0.cdval TRADEPLACE,
                   'ODTRADEPLACE_' || tradeplace   tradeplace_code,
                   A1.CDCONTENT EXECTYPE,
                   'ODEXECTYPE_' || execType       execType_code,
                   OD.PRICETYPE PRICETYPE,
                   A3.cdcontent VIA,
                   'ODPRICETYPE_' || od.VIA           via_code,
                   OD.ORDERQTTY,
                   OD.QUOTEPRICE,
                   OD.REFORDERID,
                   se.symbol,
                   od.afacctno,
                   cf.custodycd,
                   cf.fullname,
                   cspks_odproc.fn_OD_GetRootOrderID(od.orderid) ROOTORDERID
            FROM CONFIRMODRSTS CFMSTS,
                 (select * from ODMAST union all select * from odmasthist) OD, SBSECURITIES SE,
                 ALLCODE A0, ALLCODE A1, ALLCODE A2, ALLCODE A3,aLLCODE A4,
                 afmast af, cfmast cf
            WHERE CFMSTS.ORDERID(+)=OD.ORDERID
            AND OD.CODEID=SE.CODEID
            AND a0.cdtype = 'OD' AND a0.cdname = 'TRADEPLACE' AND a0.cdval = se.tradeplace
            AND A1.cdtype = 'OD' AND A1.cdname = 'EXECTYPE'
            AND A1.cdval =(case when nvl(od.reforderid,'a') <>'a' and OD.EXECTYPE = 'NB' then 'AB'
                                when  nvl(od.reforderid,'a') <>'a' and OD.EXECTYPE in ( 'NS','MS') then 'AS'
                                else od.EXECTYPE end)
            AND A2.cdtype = 'OD' AND A2.cdname = 'PRICETYPE' AND A2.cdval = OD.PRICETYPE
            AND A3.cdtype = 'OD' AND A3.cdname = 'VIA' AND A3.cdval = OD.VIA
            AND a4.cdtype = 'SY' AND a4.cdname = 'YESNO' AND a4.cdval = nvl(CFMSTS.CONFIRMED,'N')
            and ( (od.exectype in ('NB','NS','MS') AND od.via in ('F','T','H','E')) or (od.exectype  not in ('NB','NS','MS')))
            and od.exectype not in ('AB','AS') AND od.tlid <> systemnums.C_ONLINE_USERID
            and od.via not in( 'O','M','K')
            and od.txdate >=to_date('01/01/2013','DD/MM/YYYY')
            and od.afacctno=af.acctno and af.custid=cf.custid
            AND af.acctno LIKE l_accountId
            AND af.custid = l_custId
            and od.orderid not in (select orderid from CONFIRMODRSTS)
            ORDER BY OD.TXDATE DESC, OD.ORDERID
         ) a
    ;
    plog.setEndSection(pkgctx, 'pr_GetConfirmOrderHist');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_param := 'SYSTEM ERROR';
      plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_GetConfirmOrderHist');
  END;
-- initial LOG
BEGIN
   SELECT *
   INTO logrow
   FROM tlogdebug
   WHERE ROWNUM <= 1;

   pkgctx    :=
      plog.init ('fopks_reportapi',
                 plevel => logrow.loglevel,
                 plogtable => (logrow.log4table = 'Y'),
                 palert => (logrow.log4alert = 'Y'),
                 ptrace => (logrow.log4trace = 'Y')
      );
END fopks_reportapi;
/
