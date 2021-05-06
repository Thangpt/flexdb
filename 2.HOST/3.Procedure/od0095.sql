CREATE OR REPLACE PROCEDURE od0095 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2
   )
IS

   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID          VARCHAR2 (40);    -- USED WHEN V_NUMOPTION > 0
    V_INBRID     VARCHAR2 (5);            -- USED WHEN V_NUMOPTION > 0
   V_STRCUSTODYCD  VARCHAR2 (20);
   V_STRAFACCTNO               VARCHAR2(20);
   v_FrDate                DATE;
   V_ToDate                 DATE;
   V_TXTYPE                 varchar2(20);
   l_BRID_FILTER        VARCHAR2(50);



BEGIN
   V_STROPTION := upper(OPT);
   V_INBRID := BRID;

   if(V_STROPTION = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := BRID;
        end if;
    end if;
   v_FrDate := to_date(F_DATE,'DD/MM/RRRR');
   v_ToDate   := to_date(T_DATE,'DD/MM/RRRR');






OPEN PV_REFCURSOR
FOR

/*
SELECT B.MONTHS, NVL(a.ORDTOTAL,0) ORDTOTAL, NVL(A.ORDNUM,0) ORDNUM, NVL(A.ORDVALUE,0) ORDVALUE, NVL(A.ORDMATCH,0) ORDMATCH,
    NVL(A.ORDFEE,0) ORDFEE, B.ACCNUM, C.TOTALACC
FROM (
        SELECT TO_CHAR(VALDATE,'MM/RRRR') MONTHS, COUNT(*) ACCNUM FROM otright where valdate BETWEEN v_FrDate AND v_ToDate
            GROUP BY TO_CHAR(VALDATE,'MM/RRRR')
        ) B LEFT JOIN
     (
        SELECT TO_CHAR(A.TXDATE,'MM/RRRR') MONTHS,C.ORDTOTAL,  COUNT(ORDERID) ORDNUM , SUM(QUOTEPRICE*ORDERQTTY) ORDVALUE,
         SUM(execamt) ORDMATCH, SUM(feeamt) ORDFEE
        FROM VW_ODMAST_ALL A LEFT JOIN
            (SELECT COUNT(*) ORDTOTAL  FROM  OTRIGHT) C ON 1=1
        WHERE A.VIA='O' AND A.TXDATE BETWEEN  v_FrDate AND v_ToDate
        GROUP BY TO_CHAR(A.TXDATE,'MM/RRRR'),C.ORDTOTAL

    ) A ON B.MONTHS=A.MONTHS  LEFT JOIN
   (    SELECT COUNT(*) TOTALACC FROM otright where valdate BETWEEN v_FrDate AND v_ToDate
   )C ON 1 =1

ORDER BY B.MONTHS
*/

SELECT B.MONTHS, NVL(a.ORDTOTAL,0) ORDTOTAL, NVL(A.ORDNUM,0) ORDNUM, NVL(A.ORDVALUE,0) ORDVALUE, NVL(A.ORDMATCH,0) ORDMATCH,
    NVL(A.ORDFEE,0) ORDFEE, B.ACCNUM, C.TOTALACC
FROM (
      SELECT TO_CHAR(VALDATE,'MM/RRRR') MONTHS, COUNT(*) ACCNUM FROM otright where valdate BETWEEN v_FrDate AND v_ToDate
            GROUP BY TO_CHAR(VALDATE,'MM/RRRR')
        ) B LEFT JOIN
     (
        SELECT TO_CHAR(T.TXDATE,'MM/RRRR') MONTHS,C.ORDTOTAL, COUNT(T.ORDERID) ORDNUM,
                SUM(T.QUOTEPRICE * T.ORDERQTTY ) ORDVALUE,
                SUM(t.execamt) ORDMATCH, SUM(T.feeamt) ORDFEE
        FROM
           (SELECT AF.ACCTNO,CF.CUSTODYCD,OD.TXDATE,OD.ORDERID, OD.contraorderid,
                   OD.EXECTYPE, A1.CDCONTENT PUTTYPE, SB.SYMBOL ,od.quoteprice , od.orderqtty,OD.FEEAMT,od.execamt,
                   A2.CDCONTENT  MATCHTYPE, A3.CDCONTENT EXECTYPENAME,
                  --to_char(getduedate(od.txdate, od.clearcd, '000', od.clearday),'DD/MM/RRRR') clearday,
                  OD.cancelqtty
             FROM  SBSECURITIES SB, AFMAST AF, CFMAST CF, ALLCODE A1,
                    ALLCODE A2, ALLCODE A3, vw_odmast_all OD
             WHERE  OD.CODEID = SB.CODEID
                   AND OD.CIACCTNO = AF.ACCTNO
                   AND od.deltd <> 'Y'
                   AND OD.EXECTYPE IN ('NB','NS','SS','BC','MS','AB','AS','CB','CS')
                   AND AF.CUSTID = CF.CUSTID
                   AND A1.CDNAME = 'PUTTYPE' AND A1.CDVAL = OD.PUTTYPE AND A1.CDTYPE = 'OD'
                   AND A2.CDNAME = 'MATCHTYPE' AND A2.CDVAL = OD.MATCHTYPE AND A2.CDTYPE = 'OD'
                   AND A3.CDNAME = 'EXECTYPE' AND A3.CDVAL = OD.EXECTYPE AND A3.CDTYPE = 'OD'
                   AND OD.TXDATE BETWEEN v_FrDate AND v_ToDate
                   AND (substr(af.acctno,1,4) LIKE V_STRBRID OR instr(V_STRBRID,substr(af.acctno,1,4))<> 0)
                   AND OD.VIA like 'O'
          ) T
          left join
          ( select * from vw_odmast_all where EXECTYPE IN ('AB','AS')
              AND TXDATE BETWEEN v_FrDate AND v_ToDate
              AND VIA like 'O'
          ) odab
          on T.orderid = odab.reforderid
          LEFT JOIN
               (SELECT COUNT(*) ORDTOTAL  FROM  OTRIGHT) C ON 1=1
          GROUP BY TO_CHAR(T.TXDATE,'MM/RRRR'),C.ORDTOTAL

    ) A ON B.MONTHS=A.MONTHS  LEFT JOIN
   (    SELECT COUNT(*) TOTALACC FROM otright where valdate BETWEEN v_FrDate AND v_ToDate
   )C ON 1 =1

ORDER BY B.MONTHS

;


EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

