CREATE OR REPLACE PROCEDURE df0029 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   BRGID          IN       VARCHAR2,
   DFTYPE         IN       VARCHAR2
   )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- BANG KE HOP DONG GIAI NGAN
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- DUNGNH    16/07/10
-- ---------   ------  -------------------------------------------

   V_STROPTION      VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0


   V_STRBRGID  VARCHAR2 (10);


   V_INDATE     DATE;
   V_STRDFTYPE  VARCHAR2(5);

BEGIN
   V_STROPTION := OPT;

   IF V_STROPTION = 'A' THEN     -- TOAN HE THONG
      V_STRBRID := '%';
   ELSIF V_STROPTION = 'B' THEN
      V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
   ELSE
      V_STRBRID := BRID;
   END IF;

   IF(BRGID <> 'ALL') THEN
     V_STRBRGID := BRGID;
   ELSE
     V_STRBRGID := '%';
   END IF;

   IF(DFTYPE <> 'ALL') THEN
     V_STRDFTYPE := DFTYPE;
   ELSE
     V_STRDFTYPE := '%';
   END IF;

   V_INDATE  :=  TO_DATE(I_DATE,'DD/MM/YYYY');
    if  V_STRBRGID = '0001' then
            OPEN PV_REFCURSOR
            FOR
            SELECT DF.ACCTNO ,df.afacctno, DF.TXNUM, DF.TXDATE, SB.SYMBOL,
            (DF.dfqtty + DF.rcvqtty + DF.blockqtty + DF.carcvqtty) QTTY,
            TO_NUMBER(LN.OVERDUEDATE-DF.TXDATE) SONGAY,
                LN.OVERDUEDATE, DF.AMT, BR.BRNAME,DF.ACTYPE
            FROM VW_DFMAST_ALL DF, BRGRP BR, sbsecurities SB,
                (
                    SELECT ACCTNO, RLSDATE, OVERDUEDATE
                    FROM LNSCHD
                    WHERE REFTYPE IN ('GP','P')
                    UNION ALL
                    SELECT ACCTNO, RLSDATE, OVERDUEDATE
                    FROM LNSCHDHIST
                    WHERE REFTYPE IN ('GP','P')
                )LN
            WHERE DF.LNACCTNO = LN.ACCTNO
                AND SUBSTR(DF.TXNUM,1,4) = BR.BRID
                --AND DF.CIACCTNO not LIKE '0011026699'
                AND DF.TXDATE = V_INDATE
                AND DF.CODEID = SB.CODEID
                AND DF.ACTYPE like V_STRDFTYPE
                AND BR.BRID NOT LIKE '0021';
    else
            OPEN PV_REFCURSOR
            FOR
            SELECT DF.ACCTNO ,df.afacctno, DF.TXNUM, DF.TXDATE, SB.SYMBOL,
            (DF.dfqtty + DF.rcvqtty + DF.blockqtty + DF.carcvqtty) QTTY,
            TO_NUMBER(LN.OVERDUEDATE-DF.TXDATE) SONGAY,
                LN.OVERDUEDATE, DF.AMT, BR.BRNAME,DF.ACTYPE
            FROM VW_DFMAST_ALL DF, BRGRP BR, sbsecurities SB,
                (
                    SELECT ACCTNO, RLSDATE, OVERDUEDATE
                    FROM LNSCHD
                    WHERE REFTYPE IN ('GP','P')
                    UNION ALL
                    SELECT ACCTNO, RLSDATE, OVERDUEDATE
                    FROM LNSCHDHIST
                    WHERE REFTYPE IN ('GP','P')
                )LN
            WHERE DF.LNACCTNO = LN.ACCTNO
                AND SUBSTR(DF.TXNUM,1,4) = BR.BRID
                --AND DF.CIACCTNO not LIKE '0011026699'
                AND DF.TXDATE = V_INDATE
                AND DF.CODEID = SB.CODEID
                AND DF.ACTYPE like V_STRDFTYPE
                AND BR.BRID LIKE V_STRBRGID;
    end if;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

