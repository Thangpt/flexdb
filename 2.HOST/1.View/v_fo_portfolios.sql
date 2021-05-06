CREATE OR REPLACE FORCE VIEW V_FO_PORTFOLIOS AS
SELECT se.afacctno ACCTNO, sbs.SYMBOL, se.trade,
    se.mortage, nvl(st.RT0, 0) + nvl(st.RT1, 0) +  nvl(st.RT2, 0) receiving, se.costprice AVGPRICE,
    nvl(st.RT0, 0) RT0, nvl(st.RT1, 0) RT1,
    nvl(st.RT2, 0) RT2, nvl(st.RT3, 0) RT3,
    CASE WHEN mr.MRTYPE='N' AND af.autoadv='N' THEN '0'
             WHEN mr.MRTYPE='N' AND af.autoadv='Y' THEN '1'
             WHEN mr.MRTYPE='T' AND mr.ISPPUSED='0' THEN '2'
             WHEN mr.MRTYPE='T' AND mr.ISPPUSED='1' THEN '4' ELSE '0' END RTN,
    nvl(st.ST0, 0) ST0,
    nvl(st.ST1, 0) ST1, nvl(st.ST2, 0) ST2,
    nvl(st.ST3, 0) ST3, nvl(se.blocked, 0) STN, --Lay cho Blocked
    nvl(od.BUYINGQTTY, 0) BUYINGQTTY,
    nvl(od.SELLINGQTTY, 0) SELLINGQTTY,
    0 BUYINGQTTYMORT,  -- Khong co mua chung khoan cam co
    nvl(od.SELLINGQTTYMORT, 0) SELLINGQTTYMORT,
    0 ASSETQTTY, -- Chua biet lay ra ntn
    NVL(afpr.MARKED,0) MARKED,
    NVL(afpr.MARKEDCOM,0) MARKEDCOM,
    NVL(sepit.pitqtty,0) pitqtty,
    NVL(sepit.taxrate,0) taxrate
FROM
semast se, afmast af, aftype typ, mrtype mr,
sbsecurities sbs,
(SELECT
 NVL (SUM(CASE WHEN afpr.restype = 'S' THEN NVL (afpr.prinused, 0) ELSE 0 END),0) MARKED,
 NVL (SUM(CASE WHEN afpr.restype = 'M' THEN NVL (afpr.prinused, 0) ELSE 0 END), 0) MARKEDCOM,
 afpr.codeid, afpr.AFACCTNO
 FROM vw_afpralloc_all  afpr
 GROUP BY afpr.codeid, afpr.AFACCTNO ) afpr,
(SELECT ST.AFACCTNO, ST.CODEID, ST.SYMBOL,
        SUM(ST.REMAINQTTY) REMAINQTTY,
        SUM(ST.SECURITIES_RECEIVING_T0) RT0,
        SUM(ST.SECURITIES_RECEIVING_T1) RT1,
        SUM(ST.SECURITIES_RECEIVING_T2) RT2,
        SUM(ST.SECURITIES_RECEIVING_T3) RT3,
        SUM(ST.SECURITIES_RECEIVING_TN) RTN,
        SUM(ST.SECURITIES_SENDING_T0) ST0,
        SUM(ST.SECURITIES_SENDING_T1) ST1,
        SUM(ST.SECURITIES_SENDING_T2) ST2,
        SUM(ST.SECURITIES_SENDING_T3) ST3,
        SUM(ST.SECURITIES_SENDING_TN) STN
    FROM
    (SELECT ST.*,
            (CASE WHEN ST.DUETYPE='RS' AND ST.TDAY=0 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_RECEIVING_T0,
           (CASE WHEN ST.DUETYPE='RS' AND ST.TDAY=1 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_RECEIVING_T1,
           (CASE WHEN ST.DUETYPE='RS' AND ST.TDAY=2 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_RECEIVING_T2,
           (CASE WHEN ST.DUETYPE='RS' AND ST.TDAY=3 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_RECEIVING_T3,
           (CASE WHEN ST.DUETYPE='RS' AND ST.TDAY>3 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_RECEIVING_TN,
           (CASE WHEN ST.DUETYPE='RM' AND ST.TRFDAY=0 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_SENDING_T0,
           (CASE WHEN ST.DUETYPE='RM' AND ST.TRFDAY=1 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_SENDING_T1,
           (CASE WHEN ST.DUETYPE='RM' AND ST.TRFDAY=2 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_SENDING_T2,
           (CASE WHEN ST.DUETYPE='RM' AND ST.TRFDAY=3 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_SENDING_T3,
           (CASE WHEN ST.DUETYPE='RM' AND ST.TRFDAY > 3 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_SENDING_TN,
           (CASE WHEN ST.DUETYPE='SS' AND ST.NDAY=0 THEN ST.ST_QTTY ELSE 0 END) REMAINQTTY
        FROM VW_BD_PENDING_SETTLEMENT ST
        WHERE DUETYPE='RS' OR DUETYPE='SS' OR DUETYPE = 'RM'
        ) ST
    GROUP BY ST.AFACCTNO, ST.CODEID, ST.SYMBOL
    ) st,
  (SELECT seacctno, SUM(BUYINGQTTY) BUYINGQTTY,
            SUM(SELLINGQTTY) SELLINGQTTY,
            0 BUYINGQTTYMORT, SUM(SELLINGQTTYMORT) SELLINGQTTYMORT
        FROM
        (
            SELECT seacctno , exectype,
                CASE WHEN exectype = 'NB' THEN SUM (remainqtty+execqtty) ELSE 0 END BUYINGQTTY,
                CASE WHEN exectype = 'NS' THEN SUM (remainqtty+execqtty) ELSE 0 END SELLINGQTTY,
                0 BUYINGQTTYMORT, -- Khong co chung khoan mua cam co
                CASE WHEN exectype = 'MS' THEN SUM (remainqtty+execqtty) ELSE 0 END SELLINGQTTYMORT
                                FROM   odmast
                                WHERE   exectype IN ('NB','NS','MS')
                                    AND stsstatus <> 'C'
                                    AND deltd <> 'Y' AND remainqtty+execqtty > 0
                                    AND txdate = getcurrdate()
                            GROUP BY   seacctno, exectype)
                GROUP BY seacctno) od,
    (SELECT acctno,SUM(qtty - mapqtty) pitqtty, MAX(pitrate) taxrate   --1.8.2.5: dong bo quyen len FO
       FROM sepitlog WHERE deltd <> 'Y' AND qtty - mapqtty > 0
      GROUP BY acctno) sepit
WHERE se.codeid = sbs.codeid
AND se.AFACCTNO =  st.AFACCTNO(+)
AND se.codeid   =  st.codeid(+)
AND se.acctno=od.seacctno(+)
AND se.afacctno = afpr.afacctno(+)
AND se.codeid  =afpr.codeid(+)
AND sbs.tradeplace <> '006' AND sbs.sectype <> '004'
AND se.afacctno =af.acctno
AND af.actype = typ.actype AND typ.mrtype = mr.actype
AND se.acctno = sepit.acctno (+)
AND (NVL(se.trade,0) + NVL(se.mortage,0) + NVL(se.blocked,0) + nvl(st.RT0, 0)+ nvl(st.RT1, 0) +  nvl(st.RT2, 0)  + nvl(st.RT3, 0) + NVL(sepit.pitqtty,0) <> 0 OR   NVL(afpr.MARKED,0) + NVL(afpr.MARKEDCOM,0) <> 0)
;
