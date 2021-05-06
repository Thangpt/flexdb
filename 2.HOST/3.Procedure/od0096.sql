CREATE OR REPLACE PROCEDURE od0096 (
       PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
       OPT            IN       VARCHAR2,
       BRID           IN       VARCHAR2,
       F_DATE         IN       VARCHAR2,
       T_DATE         IN       VARCHAR2,
       P_CUSTODYCD    IN       VARCHAR2,
       P_AFACCTNO     IN       VARCHAR2,
       P_EXECTYPE     IN       VARCHAR2,
       P_SYMBOL       IN       VARCHAR2,
       P_TRADERID     IN       VARCHAR2
)
IS
   l_frDate                DATE;
   l_toDate                DATE;
   l_custodycd             VARCHAR2(30);
   l_afAcctno              VARCHAR2(30);
   l_symbol                VARCHAR2(100);
   l_traderId              VARCHAR2(100);
   l_execType              VARCHAR2(100);
   l_odFeeRate             NUMBER := 0.15/100;
   l_tax                   NUMBER := to_number(cspks_system.fn_get_sysvar('SYSTEM','ADVSELLDUTY')) / 100;
BEGIN
  l_frDate := TO_DATE(F_DATE, systemnums.C_DATE_FORMAT);
  l_toDate := TO_DATE(T_DATE, systemnums.C_DATE_FORMAT);
  l_custodycd := CASE WHEN upper(NVL(P_CUSTODYCD, 'ALL')) = 'ALL' THEN '%' ELSE P_CUSTODYCD END;
  l_afAcctno := CASE WHEN upper(NVL(P_AFACCTNO, 'ALL')) = 'ALL' THEN '%' ELSE P_AFACCTNO END;
  l_symbol := CASE WHEN upper(NVL(P_SYMBOL, 'ALL')) = 'ALL' THEN '%' ELSE P_SYMBOL END;
  l_execType := CASE WHEN upper(NVL(P_EXECTYPE, 'ALL')) = 'ALL' THEN '%' ELSE P_EXECTYPE END;
  l_traderId := CASE WHEN upper(NVL(P_TRADERID, 'ALL')) = 'ALL' THEN '%' ELSE P_TRADERID END;


  OPEN PV_REFCURSOR
  FOR
    SELECT TO_CHAR(od.txdate, 'rrrrmmdd') tradingDate,
           TO_CHAR(getduedate(od.txdate, 'B', '001', 2), 'rrrrmmdd') settelementDate,
           '' TRADERID,
           cf.custodycd,
           cf.fullname,
           NVL(reg.blacctno,cf.custodycd) blacctno,
           od.side,
           'KBSV'  broker,
           od.AFACCTNO,
           isin.bltickercode,
           isin.isincode,
           isin.isinname,
           execQtty,
           ROUND(execAmt/execQtty, 4)   avgPrice,
           'VND'    Currency,
           execAmt,
           ROUND(execAmt * l_odFeeRate, 2)     FeeAmt,
           ROUND(decode(side, 'B', 0, execAmt) * l_tax, 2)   taxAmt,
           ROUND(execAmt - decode(side, 'B', -1, 1) * execAmt * l_odFeeRate
                         - decode(side, 'B', 0, execAmt) * l_tax, 2)            netAmount,
           0 otherFee,
           'VN'   Market
    FROM (
      SELECT od.TXDATE,
             substr(od.EXECTYPE, 2, 1) SIDE,
             --od.TRADERID,
             --NVL(od.FIXCOMPID, 'KBSV') broker,
             od.SYMBOL,
             od.AFACCTNO,
             SUM(od.EXECQTTY)          execQtty,
             SUM(od.EXECAMT)           execAmt,
             od.CUSTODYCD
      FROM vw_bl_odmast_all od
      WHERE od.TXDATE BETWEEN l_frDate AND l_toDate
      AND od.EXECTYPE IN ('NB','NS') AND od.EXECTYPE <> 'M'
      AND od.EXECQTTY > 0
      AND od.custodycd LIKE l_custodycd
      AND od.AFACCTNO LIKE l_afAcctno
      AND od.SYMBOL LIKE l_symbol
      AND od.EXECTYPE LIKE l_execType
      AND NVL(od.TRADERID,'x') LIKE l_traderId
      GROUP BY od.AFACCTNO, /*od.TRADERID, */od.TXDATE, /*NVL(od.FIXCOMPID, 'KBSV'),*/ od.SYMBOL, od.CUSTODYCD, od.EXECTYPE
    ) od, bl_isin_Code isin, cfmast cf, 
    (SELECT * FROM bl_register reg WHERE reg.regdate >= l_frDate AND reg.regdate <= l_toDate AND (reg.clsdate IS NULL OR reg.clsdate >= l_toDate)) reg
    WHERE od.SYMBOL = isin.vnticker
    AND od.AFACCTNO = reg.afacctno(+)
    AND od.CUSTODYCD = cf.custodycd
    ORDER BY od.TXDATE, NVL(reg.blacctno,cf.custodycd), isin.vnticker
  ;


EXCEPTION
  WHEN OTHERS THEN
    RETURN;
END;
/
