CREATE OR REPLACE FORCE VIEW VW_STSCHD_DEALGROUP AS
SELECT (to_char(sts.txdate,'DD/MM/YYYY') || sts.afacctno || sts.codeid || to_char(sts.clearday)) autoid,
sts.afacctno, sts.acctno seacctno, sts.txdate, sts.clearday,sts.cleardate,sts.codeid, sts.duetype,
sum(sts.amt) amt, sum(sts.aamt) aamt, sum(sts.qtty) qtty, sum(sts.aqtty) aqtty, sum(sts.famt) famt,
sum(sts.paidamt) paidamt, sum(sts.paidfeeamt) paidfeeamt ,
case WHEN SUM(sts.qtty) > 0 THEN round(SUM(sts.amt)/SUM(sts.qtty),0) ELSE 0 END  matchprice
FROM stschd sts, odmast od
WHERE sts.orgorderid = od.orderid
    AND od.errod = 'N'
    and sts.status <> 'C' AND sts.deltd <> 'Y' AND sts.duetype = 'RS' and sts.orgorderid not in
    (SELECT ORGORDERID FROM STSCHD WHERE DUETYPE = 'SM' AND trfbuydt > TO_DATE((SELECT VARVALUE FROM SYSVAR WHERE VARNAME = 'CURRDATE'),'DD/MM/RRRR')
    AND AMT - TRFEXEAMT >0 AND trfbuyrate * trfbuyext >0 )
GROUP BY sts.afacctno, sts.acctno , sts.txdate, sts.clearday,sts.cleardate,sts.codeid, sts.duetype;

