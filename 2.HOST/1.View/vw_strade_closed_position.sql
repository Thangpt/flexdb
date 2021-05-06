CREATE OR REPLACE FORCE VIEW VW_STRADE_CLOSED_POSITION AS
SELECT CF.CUSTODYCD, SE.AFACCTNO, SB.SYMBOL, SE.TOTALSELLQTTY,
decode(se.totalsellqtty, 0, 0, round(totalbuyamt/SE.totalsellqtty, 4)) AVGBUYCOSTPRICE,
decode(se.totalsellqtty, 0, 0, round(totalsellamt/SE.totalsellqtty, 4)) AVGSELLPRICE, dealintpaid,
nvl(TOTALSELL.TOTALSELLQTTY,0) - SE.TOTALSELLQTTY TOTALQTTY, ACCUMULATEPNL
FROM SEMAST SE, SBSECURITIES SB, AFMAST AF, CFMAST CF,
(
select afacctno, codeid, sum(execqtty) TOTALSELLQTTY from vw_odmast_all a, (SELECT to_date(varvalue, 'dd/mm/yyyy') varvalue FROM sysvar WHERE varname = 'CURRDATE') b
where exectype in ('NS','MS') AND a.txdate <> b.varvalue
AND a.txdate >= '31-may-2010'
--AND a.afacctno = '0001103952'
group by afacctno, codeid
) totalsell
WHERE (nvl(TOTALSELL.TOTALSELLQTTY,0) - SE.TOTALSELLQTTY > 0 OR SE.TOTALSELLQTTY > 0) AND SE.CODEID = SB.CODEID AND AF.ACCTNO = SE.AFACCTNO
AND CF.CUSTID = AF.CUSTID AND TOTALSELL.AFACCTNO(+) = SE.AFACCTNO AND TOTALSELL.CODEID(+) = SE.CODEID
--AND se.totalsellqtty = 0
--AND cf.custodycd = '017C340012'
AND SECTYPE <> '004'
AND TRADEPLACE IN ('001','002')
ORDER BY CF.CUSTODYCD, SB.SYMBOL
;

