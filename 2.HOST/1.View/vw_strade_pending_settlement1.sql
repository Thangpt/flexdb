CREATE OR REPLACE FORCE VIEW VW_STRADE_PENDING_SETTLEMENT1 AS
SELECT ST.AFACCTNO, ST.DUETYPE, TO_DATE(MAX(SYSVAR.VARVALUE),'DD/MM/RRRR') CURRATE, ST.TXDATE, ST.CLEARCD, ST.CLEARDAY, SB.SYMBOL,
DECODE(ST.DUETYPE, 'SS', -1, 1) * (ST.CLEARDAY-SP_BD_GETCLEARDAY(ST.CLEARCD, MAX(SB.TRADEPLACE), ST.TXDATE, TO_DATE(MAX(SYSVAR.VARVALUE),'DD/MM/RRRR'))) TDAY,
--MAX(st.cleardate)-TO_DATE(MAX(SYSVAR.VARVALUE),'DD/MM/RRRR') tDAY,
SUM(ST.QTTY) ST_QTTY, SUM(ST.AQTTY) ST_AQTTY, SUM(ST.AMT) ST_AMT, SUM(ST.AAMT) ST_AAMT, SUM(ST.FAMT) ST_FAMT,
MAX(CD1.CDCONTENT) EN_DUETYPE_DESC, MAX(CD1.CDCONTENT) DUETYPE_DESC, MAX(ST.CODEID) CODEID
FROM STSCHD ST, SYSVAR, SBSECURITIES SB, ALLCODE CD1
WHERE SYSVAR.VARNAME='CURRDATE' AND ST.CODEID=SB.CODEID AND ((ST.STATUS='C' AND ST.DUETYPE ='SS') OR (ST.status = 'N'))
AND CD1.CDTYPE='OD' AND CD1.CDNAME='DUETYPE' AND ST.DUETYPE=CD1.CDVAL
                        AND AFACCTNO = '0001002062'
GROUP BY ST.AFACCTNO, ST.DUETYPE, ST.TXDATE, ST.CLEARCD, ST.CLEARDAY, SB.SYMBOL
;

