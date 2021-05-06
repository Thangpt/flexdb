CREATE OR REPLACE PROCEDURE sp_bd_getsemastposition_sum(PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR, CUSTODYCD IN VARCHAR2)
  IS
  V_PARAFILTER VARCHAR2(10);
  V_CUSTID     VARCHAR2(10);
BEGIN
    V_PARAFILTER:=CUSTODYCD;
    SELECT CUSTID INTO V_CUSTID FROM CFMAST WHERE CUSTODYCD = V_PARAFILTER;
    OPEN PV_REFCURSOR FOR
    SELECT SUBACCTNO,SYMBOL , SUM(TOTAL_QTTY) TOTAL_QTTY,
    SUM(TRADE_QTTY) TRADE_QTTY,SUM(WTRADE) WTRADE, SUM(DEALFINANCING_QTTY) DEALFINANCING_QTTY,
    SUM(ORDERQTTY_NORMAL) ORDERQTTY_NORMAL, SUM(ORDERQTTY_BLOCKED) ORDERQTTY_BLOCKED,
    SUM(ORDERQTTY_BUY) ORDERQTTY_BUY,
    SUM(MORTGAGE_QTTY) MORTGAGE_QTTY,
    SUM(NETTING_QTTY) NETTING_QTTY, SUM(BLOCKED_QTTY) BLOCKED_QTTY,
    SUM(SECURITIES_RECEIVING_T0) SECURITIES_RECEIVING_T0,
    SUM(SECURITIES_RECEIVING_T1) SECURITIES_RECEIVING_T1,
    SUM(SECURITIES_RECEIVING_T2) SECURITIES_RECEIVING_T2,
    SUM(SECURITIES_RECEIVING_T3) SECURITIES_RECEIVING_T3,
    SUM(SECURITIES_RECEIVING_TN) SECURITIES_RECEIVING_TN,
    SUM(SECURITIES_SENDING_T0) SECURITIES_SENDING_T0,
    SUM(SECURITIES_SENDING_T1) SECURITIES_SENDING_T1,
    SUM(SECURITIES_SENDING_T2) SECURITIES_SENDING_T2,
    SUM(SECURITIES_SENDING_T3) SECURITIES_SENDING_T3,
    SUM(SECURITIES_SENDING_TN) SECURITIES_SENDING_TN


     FROM (
    SELECT AF.Acctno SUBACCTNO,SB.SYMBOL, MAX(MST.TRADE+MST.MORTAGE+MST.BLOCKED+MST.NETTING+MST.WTRADE) TOTAL_QTTY,
    MAX(MST.TRADE)-MAX(NVL(REFORDER.SECUREAMT,0)) TRADE_QTTY,MAX(MST.WTRADE) WTRADE, MAX(NVL(DF.DEALQTTY,0)) DEALFINANCING_QTTY,
    MAX(NVL(REFORDER.SECUREAMT,0)) ORDERQTTY_NORMAL, MAX(NVL(REFORDER.SECUREMTG,0)) ORDERQTTY_BLOCKED,
    MAX(NVL(REFORDER_BUY.SERECEIVING,0)) ORDERQTTY_BUY, MAX(-MST.STANDING) MORTGAGE_QTTY,
    MAX(MST.NETTING) NETTING_QTTY, MAX(MST.BLOCKED) BLOCKED_QTTY,
    SUM(CASE WHEN ST.DUETYPE='RS' AND ST.TDAY=0 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END) SECURITIES_RECEIVING_T0,
    SUM(CASE WHEN ST.DUETYPE='RS' AND ST.TDAY=1 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END) SECURITIES_RECEIVING_T1,
    SUM(CASE WHEN ST.DUETYPE='RS' AND ST.TDAY=2 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END) SECURITIES_RECEIVING_T2,
    SUM(CASE WHEN ST.DUETYPE='RS' AND ST.TDAY=3 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END) SECURITIES_RECEIVING_T3,
    SUM(CASE WHEN ST.DUETYPE='RS' AND ST.TDAY>3 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END) SECURITIES_RECEIVING_TN,
    SUM(CASE WHEN ST.DUETYPE='SS' AND ST.NDAY=0 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END) SECURITIES_SENDING_T0,
    SUM(CASE WHEN ST.DUETYPE='SS' AND ST.NDAY=-1 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END) SECURITIES_SENDING_T1,
    SUM(CASE WHEN ST.DUETYPE='SS' AND ST.NDAY=-2 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END) SECURITIES_SENDING_T2,
    SUM(CASE WHEN ST.DUETYPE='SS' AND ST.NDAY=-3 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END) SECURITIES_SENDING_T3,
    SUM(CASE WHEN ST.DUETYPE='SS' AND ST.NDAY<-3 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END) SECURITIES_SENDING_TN
    FROM SEMAST MST, AFMAST AF, CFMAST CF, (SELECT * FROM SBSECURITIES WHERE SECTYPE<>'004') SB, V_GETSELLORDERINFO REFORDER,V_GETBUYORDERINFO_BY_SYMBOL REFORDER_BUY,
    (SELECT DF.CODEID, DF.AFACCTNO,  SUM(DF.DFQTTY+DF.RCVQTTY+DF.BLOCKQTTY+DF.CARCVQTTY) DEALQTTY
    FROM DFMAST DF WHERE DF.STATUS IN ('P','A','N') GROUP BY DF.CODEID, DF.AFACCTNO) DF,
    (SELECT * FROM VW_BD_PENDING_SETTLEMENT WHERE DUETYPE='RS' OR DUETYPE='SS') ST
    WHERE MST.AFACCTNO=AF.ACCTNO AND AF.CUSTID=CF.CUSTID AND MST.CODEID=SB.CODEID AND AF.Custid=V_CUSTID
    AND MST.ACCTNO=REFORDER.SEACCTNO (+) AND MST.ACCTNO=REFORDER_BUY.SEACCTNO (+) AND MST.CODEID=DF.CODEID (+) AND MST.AFACCTNO=DF.AFACCTNO (+) AND MST.AFACCTNO=ST.AFACCTNO (+) AND MST.CODEID=ST.CODEID (+)
    GROUP BY (SB.SYMBOL,AF.ACCTNO)
    HAVING MAX(MST.TRADE)+MAX(MST.MORTAGE) + MAX(NVL(DF.DEALQTTY,0)) + MAX(MST.blocked)
    +SUM(CASE WHEN ST.DUETYPE='RS' AND ST.TDAY=0 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END)
    +SUM(CASE WHEN ST.DUETYPE='RS' AND ST.TDAY=1 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END)
    +SUM(CASE WHEN ST.DUETYPE='RS' AND ST.TDAY=2 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END)
    +SUM(CASE WHEN ST.DUETYPE='RS' AND ST.TDAY=3 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END)
    +SUM(CASE WHEN ST.DUETYPE='RS' AND ST.TDAY>3 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END)
    +SUM(CASE WHEN ST.DUETYPE='SS' AND ST.NDAY=0 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END)
    +SUM(CASE WHEN ST.DUETYPE='SS' AND ST.NDAY=-1 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END)
    +SUM(CASE WHEN ST.DUETYPE='SS' AND ST.NDAY=-2 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END)
    +SUM(CASE WHEN ST.DUETYPE='SS' AND ST.NDAY=-3 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END)
    +SUM(CASE WHEN ST.DUETYPE='SS' AND ST.NDAY<-3 THEN ST.ST_QTTY-ST.ST_AQTTY ELSE 0 END)>0
    )

     GROUP BY Rollup(SYMBOL,subACCTNO);
EXCEPTION
    WHEN others THEN
        return;
END;
/

