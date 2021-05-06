CREATE OR REPLACE PROCEDURE se0042 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   INMONTH        IN       VARCHAR2,
   PLSENT         IN      VARCHAR2
   )
IS

--
-- PURPOSE: DSKH HUY, THAY DOI NOI DUNG UY QUYEN
-- MODIFICATION HISTORY
-- PERSON       DATE        COMMENTS
-- THENN        05-MAR-2012 CREATED
-- ---------    ------      -------------------------------------------
    V_F_DATE    DATE;
    V_T_DATE    DATE;
    V_PLSENT    VARCHAR2(2000);
    V_INMONTH   VARCHAR2(2);
    V_INYEAR    VARCHAR2(4);
    V_NUM_OW    NUMBER;
    V_NUM_NM    NUMBER;
    V_NUM_NM_QTTY  NUMBER;
    V_NUM_OW_QTTY  NUMBER;

BEGIN
    -- GET REPORT'S PARAMETERS
    IF TO_NUMBER(SUBSTR(INMONTH,1,2)) <= 12 THEN
        V_F_DATE := TO_DATE('01/' || SUBSTR(INMONTH,1,2) || '/' || SUBSTR(INMONTH,3,4),'DD/MM/YYYY');
    ELSE
        V_F_DATE := TO_DATE('31/12/9999','DD/MM/YYYY');
    END IF;
    V_T_DATE := LAST_DAY(V_F_DATE);
    V_PLSENT :=  PLSENT;
    V_INMONTH := SUBSTR(INMONTH,1,2);
    V_INYEAR :=  SUBSTR(INMONTH,3,4);

    -- TINH TOAN XEM CO CK TU DOANH HOAC THONG THUONG HAY KO
    -- TU DOANH
    SELECT COUNT(1) INTO V_NUM_OW
    FROM
        (
            -- SL CHUNG KHOAN CAM CO DAU THANG
            SELECT SE.CODEID, SE.QTTY + NVL(DTL.CR_QTTY,0) QTTY, se.acctype
            FROM
            (
                SELECT SE.CODEID, SUM(ABS(SE.standing)) QTTY,
                    CASE WHEN substr(cf.custodycd,4,1) = 'P' THEN 'O' ELSE 'N' END ACCTYPE
                FROM SEMAST SE, AFMAST AF, CFMAST CF
                WHERE SE.afacctno = AF.ACCTNO AND AF.CUSTID = CF.custid
                GROUP BY SE.CODEID, substr(cf.custodycd,4,1)
            ) SE,
            (
                SELECT DTL.CODEID,
                    SUM(CASE WHEN DTL.status IN ('S','N') THEN DTL.qtty
                            WHEN DTL.status = 'C' THEN - DTL.qtty ELSE 0 END) CR_QTTY, dtl.ACCTYPE
                FROM
                (
                    SELECT SUBSTR(DTL.ACCTNO,11,6) CODEID, DTL.QTTY, DTL.txdate, DTL.status,
                        CASE WHEN substr(cf.custodycd,4,1) = 'P' THEN 'O' ELSE 'N' END ACCTYPE
                    FROM semastdtl DTL, afmast af, cfmast cf
                    WHERE SUBSTR(DTL.ACCTNO,1,10) = af.acctno AND af.custid = cf.custid
                        and DTL.qttytype = '011' AND dtl.STATUS IN ('C','N','S') AND dtl.DELTD = 'N'
                        AND DTL.TXDATE >= V_F_DATE--'01-MAR-2012'
                        AND DTL.TXDATE <= V_T_DATE
                ) DTL
                GROUP BY DTL.CODEID, dtl.acctype
            ) DTL
            WHERE SE.CODEID = DTL.CODEID (+) AND se.acctype = dtl.acctype (+)
        ) MT
    WHERE MT.ACCTYPE = 'O' AND MT.QTTY > 0;
    -- THONG THUONG
    SELECT COUNT(1) INTO V_NUM_NM
    FROM
        (
            -- SL CHUNG KHOAN CAM CO DAU THANG
            SELECT SE.CODEID, SE.QTTY + NVL(DTL.CR_QTTY,0) QTTY, se.acctype
            FROM
            (
                SELECT SE.CODEID, SUM(ABS(SE.standing)) QTTY,
                    CASE WHEN substr(cf.custodycd,4,1) = 'P' THEN 'O' ELSE 'N' END ACCTYPE
                FROM SEMAST SE, AFMAST AF, CFMAST CF
                WHERE SE.afacctno = AF.ACCTNO AND AF.CUSTID = CF.custid
                GROUP BY SE.CODEID, substr(cf.custodycd,4,1)
            ) SE,
            (
                SELECT DTL.CODEID,
                    SUM(CASE WHEN DTL.status IN ('S','N') THEN DTL.qtty
                            WHEN DTL.status = 'C' THEN - DTL.qtty ELSE 0 END) CR_QTTY, dtl.ACCTYPE
                FROM
                (
                    SELECT SUBSTR(DTL.ACCTNO,11,6) CODEID, DTL.QTTY, DTL.txdate, DTL.status,
                        CASE WHEN substr(cf.custodycd,4,1) = 'P' THEN 'O' ELSE 'N' END ACCTYPE
                    FROM semastdtl DTL, afmast af, cfmast cf
                    WHERE SUBSTR(DTL.ACCTNO,1,10) = af.acctno AND af.custid = cf.custid
                        and DTL.qttytype = '011' AND dtl.STATUS IN ('C','N','S') AND dtl.DELTD = 'N'
                        AND DTL.TXDATE >= V_F_DATE--'01-MAR-2012'
                        AND DTL.TXDATE <= V_T_DATE
                ) DTL
                GROUP BY DTL.CODEID, dtl.acctype
            ) DTL
            WHERE SE.CODEID = DTL.CODEID (+) AND se.acctype = dtl.acctype (+)
        ) MT
    WHERE MT.ACCTYPE = 'N' AND MT.QTTY > 0;

    IF V_NUM_NM = 0 THEN
        V_NUM_NM_QTTY := 1;
    ELSE
        V_NUM_NM_QTTY := 0;
    END IF;

    IF V_NUM_OW = 0 THEN
        V_NUM_OW_QTTY := 1;
    ELSE
        V_NUM_OW_QTTY := 0;
    END IF;

    IF V_NUM_NM = 0 AND V_NUM_OW = 0 THEN
        V_NUM_NM_QTTY := 0;
        V_NUM_OW_QTTY := 0;
    END IF;

    -- GET REPORT'S DATA
    OPEN PV_REFCURSOR
    FOR
        SELECT A.*
        FROM
        (
            SELECT '---' CODEID, '' symbol, V_NUM_NM_QTTY QTTY, 0 MORTAGEQTTY, 0 CR_QTTY, 0 DR_QTTY, 'N' acctype,
                V_PLSENT SENTPLACE, V_INMONTH IN_MONTH, V_INYEAR IN_YEAR
            FROM DUAL
            UNION ALL
            SELECT '---' CODEID, '' symbol, V_NUM_OW_QTTY QTTY, 0 MORTAGEQTTY, 0 CR_QTTY, 0 DR_QTTY, 'O' acctype,
                V_PLSENT SENTPLACE, V_INMONTH IN_MONTH, V_INYEAR IN_YEAR
            FROM DUAL
            UNION ALL
            SELECT SE.CODEID, sb.symbol, SE.QTTY, MT.QTTY MORTAGEQTTY, NVL(DTL.CR_QTTY,0) CR_QTTY, NVL(DTL.DR_QTTY,0) DR_QTTY, se.acctype,
                V_PLSENT SENTPLACE, V_INMONTH IN_MONTH, V_INYEAR IN_YEAR
            FROM
            (
                -- SL CHUNG KHOAN TAI NGAY CUOI CUNG TRONG THANG
                SELECT se.codeid, se.qtty - nvl(tran.cr_qtty,0) qtty, se.acctype
                FROM
                (
                    SELECT se.codeid,
                        SUM(SE.TRADE + SE.BLOCKED + se.secured + SE.WITHDRAW + SE.MORTAGE +NVL(SE.netting,0) +
                            NVL(SE.dtoclose,0) + SE.WTRADE) qtty, se.acctype
                    FROM
                    (
                        SELECT se.codeid, SE.TRADE, SE.BLOCKED, se.secured, SE.WITHDRAW, SE.MORTAGE, SE.netting,SE.dtoclose,SE.WTRADE,
                            CASE WHEN substr(cf.custodycd,4,1) = 'P' THEN 'O' ELSE 'N' END ACCTYPE
                        FROM semast se, cfmast cf
                        WHERE se.custid = cf.custid AND se.status = 'A'
                    ) se
                    GROUP BY se.codeid, se.acctype
                ) se,
                (
                    SELECT TR.codeid, SUM(CASE WHEN tr.TXTYPE = 'D' THEN - TR.NAMT WHEN
                              tr.TXTYPE = 'C' THEN TR.NAMT ELSE 0 END) cr_qtty, tr.ACCTYPE
                    FROM
                        (SELECT tr.*, CASE WHEN substr(tr.custodycd,4,1) = 'P' THEN 'O' ELSE 'N' END ACCTYPE
                        FROM vw_setran_gen tr) tr
                    WHERE tr.DELTD <>'Y'
                        AND TR.NAMT<>0 AND tr.txtype IN ('D','C')
                        AND TR.txdate > V_T_DATE--to_date('31/03/2012','DD/MM/YYYY')
                        AND tr.FIELD IN ('TRADE','BLOCKED','WITHDRAW','MORTAGE','SECURED','NETTING','DTOCLOSE','WTRADE')
                    GROUP BY  TR.codeid, tr.ACCTYPE
                ) tran
                WHERE SE.codeid= tran.codeid (+) AND se.acctype = tran.acctype (+)
            ) SE, sbsecurities sb,
            (
                -- SL CHUNG KHOAN CAM CO DAU THANG
                SELECT SE.CODEID, SE.QTTY - NVL(DTL.CR_QTTY,0) QTTY, se.acctype
                FROM
                (
                    /*SELECT DTL.CODEID, SUM(CASE WHEN DTL.status IN ('S','N') THEN DTL.qtty
                                WHEN DTL.status = 'C' THEN - DTL.qtty ELSE 0 END) QTTY, dtl.acctype
                    FROM
                    (
                        SELECT SUBSTR(DTL.ACCTNO,11,6) CODEID, DTL.QTTY, DTL.txdate, DTL.status,
                            CASE WHEN substr(cf.custodycd,4,1) = 'P' THEN 'O' ELSE 'N' END ACCTYPE
                        FROM semastdtl DTL, afmast af, cfmast cf
                        WHERE SUBSTR(DTL.ACCTNO,1,10) = af.acctno AND af.custid = cf.custid
                            and DTL.qttytype = '011' AND dtl.STATUS IN ('C','N','S') AND dtl.DELTD = 'N'
                    ) DTL
                    GROUP BY DTL.CODEID, dtl.acctype*/
                    SELECT SE.CODEID, SUM(ABS(SE.standing)) QTTY,
                        decode(substr(cf.custodycd,4,1),'P','O','N') ACCTYPE
                    FROM SEMAST SE, AFMAST AF, CFMAST CF
                    WHERE SE.afacctno = AF.ACCTNO AND AF.CUSTID = CF.custid
                    GROUP BY SE.CODEID, decode(substr(cf.custodycd,4,1),'P','O','N')
                ) SE,
                (
                    SELECT DTL.CODEID,
                        SUM(CASE WHEN DTL.status IN ('S','N') THEN DTL.qtty
                                WHEN DTL.status = 'C' THEN - DTL.qtty ELSE 0 END) CR_QTTY, dtl.ACCTYPE
                    FROM
                    (
                        SELECT SUBSTR(DTL.ACCTNO,11,6) CODEID, DTL.QTTY, DTL.txdate, DTL.status,
                            CASE WHEN substr(cf.custodycd,4,1) = 'P' THEN 'O' ELSE 'N' END ACCTYPE
                        FROM semastdtl DTL, afmast af, cfmast cf
                        WHERE SUBSTR(DTL.ACCTNO,1,10) = af.acctno AND af.custid = cf.custid
                            and DTL.qttytype = '011' AND dtl.STATUS IN ('C','N','S') AND dtl.DELTD = 'N'
                            AND DTL.TXDATE >= V_F_DATE--'01-MAR-2012'
                    ) DTL
                    GROUP BY DTL.CODEID, dtl.acctype
                ) DTL
                WHERE SE.CODEID = DTL.CODEID (+) AND se.acctype = dtl.acctype (+)
            ) MT,
            (
                -- PHAT SINH CAM CO TRONG THANG
                SELECT DTL.CODEID,
                    SUM(CASE WHEN DTL.status IN ('S','N') THEN DTL.qtty ELSE 0 END) CR_QTTY,
                    SUM(CASE WHEN DTL.status IN ('C') THEN DTL.qtty ELSE 0 END) DR_QTTY, dtl.acctype
                FROM
                (
                    SELECT SUBSTR(DTL.ACCTNO,11,6) CODEID, DTL.QTTY, DTL.txdate, DTL.status,
                        CASE WHEN substr(cf.custodycd,4,1) = 'P' THEN 'O' ELSE 'N' END ACCTYPE
                    FROM semastdtl DTL, afmast af, cfmast cf
                    WHERE SUBSTR(DTL.ACCTNO,1,10) = af.acctno AND af.custid = cf.custid
                        and DTL.qttytype = '011' AND dtl.STATUS IN ('C','N','S') AND dtl.DELTD = 'N'
                        AND DTL.TXDATE >= V_F_DATE--'01-MAR-2012'
                        AND DTL.TXDATE <= V_T_DATE--'31-MAR-2012'
                ) DTL
                GROUP BY DTL.CODEID, dtl.acctype
            ) DTL
            WHERE se.codeid = sb.codeid
                AND SE.CODEID = MT.CODEID
                AND se.acctype = mt.acctype
                --AND DTL.CR_QTTY+DTL.DR_QTTY > 0
                AND MT.QTTY + nvl(DTL.CR_QTTY,0)+nvl(DTL.DR_QTTY,0) > 0
                AND SE.CODEID = DTL.CODEID(+)
                AND se.acctype = dtl.acctype (+)
        ) A
        WHERE A.QTTY + A.MORTAGEQTTY> 0
        order BY A.acctype, A.symbol
;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

