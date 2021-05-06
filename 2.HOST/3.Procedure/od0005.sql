CREATE OR REPLACE PROCEDURE od0005 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   TRADEPLACE     IN       VARCHAR2,
   AFTYPE         IN       VARCHAR2
   )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- NAMNT   21-NOV-06  CREATED
-- ---------   ------  -------------------------------------------
   V_STROPTION          VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID            VARCHAR2 (4);              -- USED WHEN V_NUMOPTION > 0
   V_STRTRADEPLACE      VARCHAR2 (4);
   V_STRTYPEAF          VARCHAR2 (4);

-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE

BEGIN
   V_STROPTION := OPT;

   IF (OPT <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%';
   END IF;

   IF (UPPER(TRADEPLACE) = 'ALL')
   THEN
      V_STRTRADEPLACE := '%';
   ELSE
      V_STRTRADEPLACE := TRADEPLACE;
   END IF;

   IF (UPPER(AFTYPE) <> 'ALL')
   THEN
      V_STRTYPEAF := AFTYPE;
   ELSE
      V_STRTYPEAF := '%';
   END IF;

OPEN PV_REFCURSOR
FOR
SELECT SB.SYMBOL,SUM(CASE WHEN OD.EXECTYPE IN ('NB','BC') THEN  OD.ORDERQTTY ELSE 0 END ) B_ORDERQTTY,
       SUM(CASE WHEN OD.EXECTYPE IN ('NS','SS','MS') THEN  OD.ORDERQTTY ELSE 0 END ) S_ORDERQTTY,
      nvl( SUM(CASE WHEN OD.EXECTYPE IN ('NB','BC') THEN  IO.MATCHQTTY ELSE 0 END ),0) B_EXECQTTY,
      nvl( SUM(CASE WHEN OD.EXECTYPE IN ('NS','SS','MS') THEN  IO.MATCHQTTY ELSE 0 END ),0) S_EXECQTTY
    FROM (select * From (SELECT * FROM ODMAST WHERE DELTD<>'Y'
                                                and TXDATE <= TO_DATE (T_DATE ,'DD/MM/YYYY')
                                                AND TXDATE >= TO_DATE (F_DATE ,'DD/MM/YYYY')
                            UNION ALL
                        SELECT * FROM ODMASTHIST WHERE DELTD<>'Y'
                                                    and TXDATE <= TO_DATE (T_DATE ,'DD/MM/YYYY')
                                                    AND TXDATE >= TO_DATE (F_DATE ,'DD/MM/YYYY')
                        )
         )OD, SBSECURITIES SB, AFMAST AF, CFMAST CF,
        (select * From (SELECT IO.* FROM IOD IO ,TLLOG TL WHERE IO.DELTD <> 'Y' AND TL.txnum =IO.txnum AND TL.txdate = IO.txdate AND TL.tltxcd IN('8804','8809' )
                UNION ALL
            SELECT IO.* FROM IODHIST IO ,TLLOGALL TL WHERE IO.DELTD<>'Y'AND TL.txnum =IO.txnum AND TL.txdate = IO.txdate AND TL.tltxcd IN('8804','8809' ) )
        )IO
    WHERE OD.CODEID = SB.CODEID
        AND AF.ACCTNO = OD.AFACCTNO
        AND AF.CUSTID = CF.CUSTID
--        AND OD.TXDATE <= TO_DATE (T_DATE ,'DD/MM/YYYY')
--        AND OD.TXDATE >= TO_DATE (F_DATE ,'DD/MM/YYYY')
        AND SB.TRADEPLACE LIKE V_STRTRADEPLACE
        AND SUBSTR(OD.ORDERID,1,4) LIKE V_STRBRID
        AND OD.ORDERID = IO.ORGORDERID(+)
        AND af.aftype LIKE V_STRTYPEAF
    GROUP BY SB.SYMBOL
   ;


EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

