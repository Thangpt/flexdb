CREATE OR REPLACE FORCE VIEW VW_BD_SUBACCOUNT_SE AS
SELECT MAX(CF.CUSTID) CUSTID, MAX(CF.CUSTODYCD) CUSTODYCD, MST.AFACCTNO, SB.SYMBOL,
MAX(MST.TRADE+MST.MORTAGE+MST.BLOCKED+MST.NETTING) TOTAL_QTTY,
MAX(MST.TRADE)-MAX(NVL(REFORDER.SECUREAMT,0)) TRADE_QTTY,
MAX(NVL(DF.DEALQTTY,0)) DEALFINANCING_QTTY, MAX(MST.MORTAGE) MORTGAGE_QTTY,
MAX(MST.NETTING) NETTING_QTTY, MAX(MST.BLOCKED) BLOCKED_QTTY,
MAX(NVL(REFORDER.SECUREAMT,0)) ORDERQTTY_NORMAL, MAX(NVL(REFORDER.SECUREMTG,0)) ORDERQTTY_BLOCKED,
MAX(NVL(REFORDER.SERECEIVING,0)) ORDERQTTY_BUY,
SUM(CASE WHEN ST.DUETYPE='RS' AND ST.TDAY=0 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END) SECURITIES_RECEIVING_T0,
SUM(CASE WHEN ST.DUETYPE='RS' AND ST.TDAY=1 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END) SECURITIES_RECEIVING_T1,
SUM(CASE WHEN ST.DUETYPE='RS' AND ST.TDAY=2 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END) SECURITIES_RECEIVING_T2,
SUM(CASE WHEN ST.DUETYPE='RS' AND ST.TDAY=3 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END) SECURITIES_RECEIVING_T3,
SUM(CASE WHEN ST.DUETYPE='RS' AND ST.TDAY>3 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END) SECURITIES_RECEIVING_TN,
SUM(CASE WHEN ST.DUETYPE='SS' AND ST.TDAY=0 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END) SECURITIES_SENDING_T0,
SUM(CASE WHEN ST.DUETYPE='SS' AND ST.TDAY=1 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END) SECURITIES_SENDING_T1,
SUM(CASE WHEN ST.DUETYPE='SS' AND ST.TDAY=2 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END) SECURITIES_SENDING_T2,
SUM(CASE WHEN ST.DUETYPE='SS' AND ST.TDAY=3 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END) SECURITIES_SENDING_T3,
SUM(CASE WHEN ST.DUETYPE='SS' AND ST.TDAY>3 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END) SECURITIES_SENDING_TN
FROM SEMAST MST, AFMAST AF, CFMAST CF, SBSECURITIES SB, V_GETSELLORDERINFO REFORDER,
(SELECT DF.CODEID, DF.AFACCTNO,  SUM(DF.DFQTTY+DF.RCVQTTY+DF.BLOCKQTTY+DF.CARCVQTTY) DEALQTTY
FROM DFMAST DF WHERE DF.STATUS IN ('P','A','N') GROUP BY DF.CODEID, DF.AFACCTNO) DF,
(SELECT * FROM VW_BD_PENDING_SETTLEMENT WHERE DUETYPE='RS' OR DUETYPE='SS') ST
WHERE MST.AFACCTNO=AF.ACCTNO AND AF.CUSTID=CF.CUSTID AND MST.CODEID=SB.CODEID
AND MST.ACCTNO=REFORDER.SEACCTNO (+)
AND MST.CODEID=DF.CODEID (+) AND MST.AFACCTNO=DF.AFACCTNO (+)
AND MST.AFACCTNO=ST.AFACCTNO (+) AND MST.CODEID=ST.CODEID (+)
GROUP BY MST.AFACCTNO, SB.SYMBOL
HAVING MAX(MST.TRADE)+MAX(MST.MORTAGE)
+SUM(CASE WHEN ST.DUETYPE='RS' AND ST.TDAY=0 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END)
+SUM(CASE WHEN ST.DUETYPE='RS' AND ST.TDAY=1 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END)
+SUM(CASE WHEN ST.DUETYPE='RS' AND ST.TDAY=2 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END)
+SUM(CASE WHEN ST.DUETYPE='RS' AND ST.TDAY=3 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END)
+SUM(CASE WHEN ST.DUETYPE='RS' AND ST.TDAY>3 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END)
+SUM(CASE WHEN ST.DUETYPE='SS' AND ST.TDAY=0 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END)
+SUM(CASE WHEN ST.DUETYPE='SS' AND ST.TDAY=1 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END)
+SUM(CASE WHEN ST.DUETYPE='SS' AND ST.TDAY=2 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END)
+SUM(CASE WHEN ST.DUETYPE='SS' AND ST.TDAY=3 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END)
+SUM(CASE WHEN ST.DUETYPE='SS' AND ST.TDAY>3 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END)>0;

