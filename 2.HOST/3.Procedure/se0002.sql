CREATE OR REPLACE PROCEDURE se0002 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   CUSTODYCD      IN       VARCHAR2,
   CIACCTNO       IN       VARCHAR2,
   SYMBOL         IN       VARCHAR2
)
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- BAO CAO SO DU PHONG TOA CHUNG KHOAN
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- DUNGNH   11-JUL-10  CREATED
-- ---------   ------  -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0

   V_STRCIACCTNO      VARCHAR (20);
   V_STRSYMBOL        VARCHAR (20);
   V_STRCUSTODYCD     VARCHAR2 (20);

   V_INDATE           DATE;

-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
   V_STROPTION := OPT;

   IF V_STROPTION = 'A' THEN     -- TOAN HE THONG
      V_STRBRID := '%';
   ELSIF V_STROPTION = 'B' THEN
      V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
   ELSE
      V_STRBRID := BRID;
   END IF;

   -- GET REPORT'S PARAMETERS

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

   IF(SYMBOL  <> 'ALL')
   THEN
      V_STRSYMBOL := replace(SYMBOL,' ','_');
   ELSE
      V_STRSYMBOL := '%%';
   END IF;

   V_INDATE := to_date(I_DATE,'DD/MM/YYYY');


-- GET REPORT'S DATA
OPEN PV_REFCURSOR
    FOR
SELECT V_INDATE INDATE, CF.CUSTODYCD, AF.ACCTNO, CF.FULLNAME, SB.SYMBOL, (DF.DFQTTY-NVL(TR_DR.DFQTTY,0)) DFQTTY,
    (DF.RCVQTTY-NVL(TR_DR.RCVQTTY,0)) RCVQTTY, (DF.BLOCKQTTY-NVL(TR_DR.BLOCKQTTY,0)) BLOCKQTTY,
    (DF.CARCVQTTY-NVL(TR_DR.CARCVQTTY,0)) CARCVQTTY
FROM AFMAST AF, CFMAST CF, SBSECURITIES SB,
(--SO DU HIEN TAI
    SELECT AFACCTNO, CODEID, SUM(DFQTTY) DFQTTY, SUM(RCVQTTY)RCVQTTY,
        SUM(BLOCKQTTY) BLOCKQTTY, SUM(CARCVQTTY) CARCVQTTY
    FROM VW_DFMAST_ALL
    WHERE txdate < V_INDATE
    GROUP BY AFACCTNO, CODEID
) DF,
(--GIAO DICH THANH LY VA CHUYEN TRANG THAI CK
    SELECT DF.AFACCTNO, DF.CODEID,
        SUM(CASE WHEN APP.FIELD = 'DFQTTY'
            THEN (CASE WHEN APP.TXTYPE = 'D' THEN -DFTR.NAMT ELSE DFTR.NAMT END) ELSE 0 END ) DFQTTY,
        SUM(CASE WHEN APP.FIELD = 'RCVQTTY'
            THEN (CASE WHEN APP.TXTYPE = 'D' THEN -DFTR.NAMT ELSE DFTR.NAMT END) ELSE 0 END ) RCVQTTY,
        SUM(CASE WHEN APP.FIELD = 'BLOCKQTTY'
            THEN (CASE WHEN APP.TXTYPE = 'D' THEN -DFTR.NAMT ELSE DFTR.NAMT END) ELSE 0 END ) BLOCKQTTY,
        SUM(CASE WHEN APP.FIELD = 'CARCVQTTY'
            THEN (CASE WHEN APP.TXTYPE = 'D' THEN -DFTR.NAMT ELSE DFTR.NAMT END) ELSE 0 END ) CARCVQTTY
    FROM VW_DFTRAN_ALL DFTR, APPTX APP, VW_DFMAST_ALL DF
    WHERE DFTR.TXCD = APP.TXCD
        AND APP.FIELD IN ('DFQTTY','RCVQTTY','BLOCKQTTY','CARCVQTTY')
        AND APPTYPE = 'DF'
        AND APP.TXTYPE IN ('D','C')
        AND DFTR.NAMT <> 0
        AND DFTR.ACCTNO = DF.ACCTNO
        AND DF.txdate < V_INDATE
        AND DFTR.TXDATE >= V_INDATE
    GROUP BY DF.AFACCTNO, DF.CODEID
)TR_DR
WHERE DF.AFACCTNO = TR_DR.AFACCTNO(+)
    AND DF.CODEID = TR_DR.CODEID(+)
    AND AF.ACCTNO = DF.AFACCTNO
    AND AF.CUSTID = CF.CUSTID
    AND SB.CODEID = DF.CODEID
    AND (
        (DF.DFQTTY-NVL(TR_DR.DFQTTY,0)) <> 0
        OR
        (DF.RCVQTTY-NVL(TR_DR.RCVQTTY,0)) <> 0
        OR
        (DF.BLOCKQTTY-NVL(TR_DR.BLOCKQTTY,0)) <> 0
        OR
        (DF.CARCVQTTY-NVL(TR_DR.CARCVQTTY,0)) <> 0
        )
    AND SB.SYMBOL LIKE V_STRSYMBOL
    AND CF.CUSTODYCD LIKE V_STRCUSTODYCD
    AND AF.ACCTNO LIKE V_STRCIACCTNO
ORDER BY CF.CUSTODYCD, AF.ACCTNO, CF.FULLNAME, SB.SYMBOL
;


 EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

