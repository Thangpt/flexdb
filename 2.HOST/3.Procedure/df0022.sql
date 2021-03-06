CREATE OR REPLACE PROCEDURE df0022 (
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
-- BAO CAO SU DU TK VAY BAO LANH TINH THEO KHACH HANG
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
SELECT CITR.TXDATE, BR.BRNAME, CITR.TXNUM,
    (CASE WHEN SUBSTR(CITR.TXNUM,1,2) = '99' THEN TL.MSGACCT ELSE NULL END) DEAL,
    CF.CUSTODYCD, AF.ACCTNO, CF.FULLNAME, CITR.NAMT,tl.tltxcd,CITR.tltxcd
FROM VW_CITRAN_ALL CITR, APPTX APP, AFMAST AF, CFMAST CF, VW_TLLOG_ALL TL, BRGRP BR
WHERE CITR.TXCD = APP.TXCD
    AND APP.TXTYPE = 'C'
    AND AF.CUSTID = CF.CUSTID
    AND CITR.ACCTNO = AF.ACCTNO
    AND CITR.TXNUM = TL.TXNUM
    AND CITR.TXDATE = TL.TXDATE
    AND (CASE WHEN SUBSTR(CITR.TXNUM,1,2) = '99' THEN SUBSTR(TL.MSGACCT,1,4) ELSE TL.BRID END) = BR.BRID
    AND APP.FIELD LIKE 'DFDEBTAMT'
    AND CITR.NAMT <> 0
    AND APP.APPTYPE = 'CI'
    AND CITR.TXDATE BETWEEN V_FROMDATE AND V_TODATE
    AND CF.CUSTODYCD LIKE V_STRCUSTODYCD
    AND AF.ACCTNO LIKE V_STRCIACCTNO
    AND BR.BRID LIKE V_STRBRGID
ORDER BY AF.ACCTNO
;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

