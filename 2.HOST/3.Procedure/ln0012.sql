CREATE OR REPLACE PROCEDURE ln0012 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   CUSTODYCD      IN       VARCHAR2,
   CIACCTNO       IN       VARCHAR2,
   BRGID          IN       VARCHAR2
   )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- BANG KE PHAT VAY BAO LANH.
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- DUNGNH   17-MAY-10  CREATED
-- ---------   ------  -------------------------------------------

   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0

   V_STRCUSTODYCD VARCHAR2 (20);
   V_STRCIACCTNO  VARCHAR2 (20);
   V_STRBRGID  VARCHAR2 (10);


   V_FROMDATE     DATE;
   V_TODATE       DATE;

BEGIN
   V_STROPTION := OPT;

   IF V_STROPTION = 'A' THEN     -- TOAN HE THONG
      V_STRBRID := '%';
   ELSIF V_STROPTION = 'B' THEN
      V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
   ELSE
      V_STRBRID := BRID;
   END IF;

   IF(CUSTODYCD <> 'ALL') THEN
     V_STRCUSTODYCD := CUSTODYCD;
   ELSE
     V_STRCUSTODYCD := '%';
   END IF;

   IF(CIACCTNO <> 'ALL') THEN
     V_STRCIACCTNO := CIACCTNO;
   ELSE
     V_STRCIACCTNO := '%';
   END IF;

   IF(BRGID <> 'ALL') THEN
     V_STRBRGID := BRGID;
   ELSE
     V_STRBRGID := '%';
   END IF;


   V_FROMDATE  :=    TO_DATE(F_DATE,'DD/MM/YYYY');
   V_TODATE    :=    TO_DATE(T_DATE,'DD/MM/YYYY');

OPEN PV_REFCURSOR
FOR

SELECT CF.CUSTODYCD, AF.ACCTNO, CF.FULLNAME,
    NVL(FROM_TO_TR_B.AMT,0) AMT,
    NVL(FROM_TO_TR_A.PRINPAID,0) PRINPAID,
    ROUND(MST.PRINPAID - NVL(TO_MST_B.AMT,0) + NVL(TO_MST_A.PRINPAID,0)) CURR_AMT,
    BR.BRNAME, TLPR.TLNAME
FROM AFMAST AF, CFMAST CF, TLPROFILES TLPR, BRGRP BR,
    (--SO DU HIEN TAI CUA KHACH HANG VAY BAO LANH
        SELECT MST.TRFACCTNO,
            SUM(SCHD.NML+SCHD.OVD) PRINPAID
        FROM (SELECT * FROM LNSCHD UNION ALL SELECT * FROM LNSCHDHIST) SCHD, VW_LNMAST_ALL MST
        WHERE MST.ACCTNO = SCHD.ACCTNO
            AND SCHD.REFTYPE IN ('P','GP')
            AND MST.FTYPE = 'AF'
            GROUP BY MST.TRFACCTNO
    )MST,
    (--GIAO DICH HOAN TRA PHAT VAY BAO LANH
        SELECT LN.TRFACCTNO,
            SUM(CASE WHEN APP.FIELD IN ('PRINPAID','OPRINPAID') THEN LNTR.NAMT ELSE 0 END) PRINPAID
        FROM VW_LNTRAN_ALL LNTR, APPTX APP, VW_LNMAST_ALL LN
        WHERE LNTR.TXCD = APP.TXCD
            AND LNTR.ACCTNO = LN.ACCTNO
            AND LN.FTYPE = 'AF'
            AND APP.FIELD IN ('PRINPAID','OPRINPAID')
            AND APP.APPTYPE LIKE 'LN'
            AND LNTR.NAMT > 1
            AND LNTR.TXDATE >= V_TODATE
        GROUP BY LN.TRFACCTNO
    )TO_MST_A ,
    (--GIAO DICH PHAT VAY BAO LANH.
        SELECT LN.TRFACCTNO, SUM(LNTR.NAMT) AMT
        FROM VW_LNTRAN_ALL LNTR, APPTX APP, VW_LNMAST_ALL LN
        WHERE LNTR.TXCD = APP.TXCD
            AND LN.FTYPE = 'AF'
            AND APP.APPTYPE = 'LN'
            AND APP.FIELD IN ('RLSAMT','ORLSAMT')
            AND APP.TXTYPE = 'C'
            AND LNTR.ACCTNO = LN.ACCTNO
            AND LNTR.NAMT > 1
            AND LNTR.TXDATE >= V_TODATE
        GROUP BY LN.TRFACCTNO
    )TO_MST_B,
    (--GIAO DICH HOAN TRA PHAT VAY BAO LANH TU NGAY FROM_DATE DEN TO_DATE
        SELECT LN.TRFACCTNO,
            SUM(CASE WHEN APP.FIELD IN ('PRINPAID','OPRINPAID') THEN LNTR.NAMT ELSE 0 END) PRINPAID
        FROM VW_LNTRAN_ALL LNTR, APPTX APP, VW_LNMAST_ALL LN
        WHERE LNTR.TXCD = APP.TXCD
            AND LNTR.ACCTNO = LN.ACCTNO
            AND LN.FTYPE = 'AF'
            AND APP.FIELD IN ('PRINPAID','OPRINPAID')
            AND APP.APPTYPE LIKE 'LN'
            AND LNTR.NAMT > 1
            AND LNTR.TXDATE >= V_FROMDATE
            AND LNTR.TXDATE < V_TODATE
        GROUP BY LN.TRFACCTNO
    )FROM_TO_TR_A ,
    (--GIAO DICH PHAT VAY BAO LANH TU NGAY FROM_DATE DEN TO_DATE
        SELECT LN.TRFACCTNO, SUM(LNTR.NAMT) AMT
        FROM VW_LNTRAN_ALL LNTR, APPTX APP, VW_LNMAST_ALL LN
        WHERE LNTR.TXCD = APP.TXCD
            AND LN.FTYPE = 'AF'
            AND APP.APPTYPE = 'LN'
            AND APP.FIELD IN ('RLSAMT','ORLSAMT')
            AND APP.TXTYPE = 'C'
            AND LNTR.ACCTNO = LN.ACCTNO
            AND LNTR.NAMT > 1
            AND LNTR.TXDATE >= V_FROMDATE
            AND LNTR.TXDATE < V_TODATE
        GROUP BY LN.TRFACCTNO
    )FROM_TO_TR_B
WHERE MST.TRFACCTNO = TO_MST_A.TRFACCTNO(+)
    AND MST.TRFACCTNO = TO_MST_B.TRFACCTNO(+)
    AND MST.TRFACCTNO = FROM_TO_TR_A.TRFACCTNO(+)
    AND MST.TRFACCTNO = FROM_TO_TR_B.TRFACCTNO(+)
    AND MST.TRFACCTNO = AF.ACCTNO
    AND AF.CUSTID = CF.CUSTID
    AND CF.TLID = TLPR.TLID
    AND TLPR.BRID = BR.BRID
    AND CF.CUSTODYCD LIKE V_STRCUSTODYCD
    AND AF.ACCTNO LIKE V_STRCIACCTNO
    AND BR.BRID LIKE V_STRBRGID
    AND CF.CUSTODYCD LIKE fn_get_companycd||'%'
    AND CF.CUSTODYCD <> fn_get_companycd||'P000002'
    AND (
         FROM_TO_TR_B.AMT > 1 OR
         FROM_TO_TR_A.PRINPAID > 1 OR
         (MST.PRINPAID-NVL(TO_MST_B.AMT,0)+NVL(TO_MST_A.PRINPAID,0)) > 1
        )
 ORDER BY CF.CUSTODYCD
;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/
