CREATE OR REPLACE PROCEDURE od0023 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   SYMBOL         IN       VARCHAR2,
   EXECTYPE       IN       VARCHAR2,
   TRADEPLACE     IN       VARCHAR2,
   VOUCHER        IN       VARCHAR2,
   TYPEORDER      IN       VARCHAR2,
   PRICETYPE      IN       VARCHAR2

   )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- TONG HOP KET QUA KHOP LENH
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- NAMNT   21-NOV-06  CREATED
-- ---------   ------  -------------------------------------------

   V_STROPTION          VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID            VARCHAR2 (4);               -- USED WHEN V_NUMOPTION > 0
   V_STREXECTYPE        VARCHAR2 (5);
   V_STRSYMBOL          VARCHAR2 (30);
   V_STRTRADEPLACE      VARCHAR2 (3);
   V_STRVOUCHER         VARCHAR2 (3);
   V_STRTYPEORDER       VARCHAR2 (3);
   --ThanhTC sua them tham so PriceType, va tinh phi
   V_STRPRICETYPE       VARCHAR2 (10);
   V_NUMFEEACR          NUMBER;
   V_NUMFEEACR_BRO      NUMBER;
   V_NUMFEE_TD           NUMBER;
   CUR                  PKG_REPORT.REF_CURSOR;
   --ThanhTC end.
-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

    -- GET REPORT'S PARAMETERS
   IF (TRADEPLACE <> 'ALL')
   THEN
      V_STRTRADEPLACE := TRADEPLACE;
   ELSE
      V_STRTRADEPLACE := '%%';
   END IF;
   --
    IF (SYMBOL <> 'ALL')
   THEN
      V_STRSYMBOL :=replace(SYMBOL,' ','_');
   ELSE
      V_STRSYMBOL := '%%';
   END IF;
   --
   IF (EXECTYPE <> 'ALL')
   THEN
      V_STREXECTYPE := EXECTYPE;
   ELSE
      V_STREXECTYPE := '%%';
   END IF;

   IF (VOUCHER <> 'ALL')
   THEN
      V_STRVOUCHER := VOUCHER;
   ELSE
      V_STRVOUCHER := '%%';
   END IF;

    IF (TYPEORDER <> 'ALL')
   THEN
      V_STRTYPEORDER := TYPEORDER;
   ELSE
      V_STRTYPEORDER := '%%';
   END IF;

   IF (PRICETYPE <> 'ALL')
   THEN
      V_STRPRICETYPE := PRICETYPE;
   ELSE
      V_STRPRICETYPE := '%%';
   END IF;


--- TINH TONG PHI

OPEN CUR
 FOR
SELECT NVL(SUM(AMT.FEEACR),0)
FROM (
SELECT SUM(FEEACR) FEEACR FROM ODMAST,(SELECT * FROM SBSECURITIES WHERE SYMBOL  LIKE  V_STRSYMBOL AND TRADEPLACE  LIKE V_STRTRADEPLACE)sb
 WHERE DELTD <>'Y'
AND  TXDATE <= TO_DATE (T_DATE ,'DD/MM/YYYY') AND TXDATE >= TO_DATE (F_DATE ,'DD/MM/YYYY')
AND  EXECTYPE LIKE  V_STREXECTYPE AND ODMAST.CODEID=SB.CODEID
AND  VOUCHER  LIKE V_STRVOUCHER  AND PRICETYPE LIKE V_STRPRICETYPE
UNION ALL
SELECT SUM(FEEACR) FEEACR FROM ODMASTHIST,(SELECT * FROM SBSECURITIES WHERE SYMBOL  LIKE  V_STRSYMBOL AND TRADEPLACE  LIKE V_STRTRADEPLACE)sb WHERE DELTD <>'Y'
AND  TXDATE <= TO_DATE (T_DATE ,'DD/MM/YYYY') AND TXDATE >= TO_DATE (F_DATE ,'DD/MM/YYYY')
AND EXECTYPE LIKE  V_STREXECTYPE AND  VOUCHER  LIKE V_STRTYPEORDER
AND PRICETYPE LIKE V_STRPRICETYPE
AND ODMASTHIST.CODEID=SB.CODEID
)AMT

;

LOOP
  FETCH CUR
       INTO V_NUMFEEACR ;
       EXIT WHEN CUR%NOTFOUND;
  END LOOP;
CLOSE CUR;

--KET THUC TINH TONG PHI


--- TINH TONG PHI MOI GIOI

OPEN CUR
 FOR
 SELECT NVL(SUM(AMT.FEEACR),0)
FROM (
SELECT SUM(FEEACR) FEEACR FROM ODMAST,(SELECT * FROM SBSECURITIES WHERE SYMBOL  LIKE  V_STRSYMBOL AND TRADEPLACE  LIKE V_STRTRADEPLACE)sb WHERE DELTD <>'Y'
AND  TXDATE <= TO_DATE (T_DATE ,'DD/MM/YYYY') AND TXDATE >= TO_DATE (F_DATE ,'DD/MM/YYYY')
AND AFACCTNO NOT IN('0001222222')AND ODMAST.CODEID=SB.CODEID
AND EXECTYPE LIKE  V_STREXECTYPE AND  VOUCHER  LIKE V_STRVOUCHER  AND PRICETYPE LIKE V_STRPRICETYPE
UNION ALL
SELECT SUM(FEEACR) FEEACR FROM ODMASTHIST,(SELECT * FROM SBSECURITIES WHERE SYMBOL  LIKE  V_STRSYMBOL AND TRADEPLACE  LIKE V_STRTRADEPLACE)sb WHERE DELTD <>'Y'
AND  TXDATE <= TO_DATE (T_DATE ,'DD/MM/YYYY') AND TXDATE >= TO_DATE (F_DATE ,'DD/MM/YYYY')
AND AFACCTNO NOT IN('0001222222')AND ODMASTHIST.CODEID=SB.CODEID
AND  EXECTYPE LIKE  V_STREXECTYPE AND  VOUCHER  LIKE V_STRVOUCHER  AND PRICETYPE LIKE V_STRPRICETYPE
)AMT
  ;

LOOP
  FETCH CUR
       INTO V_NUMFEEACR_BRO ;
       EXIT WHEN CUR%NOTFOUND;
  END LOOP;
CLOSE CUR;
--KET THUC TINH PHI MOI GIOI



--- TINH GIA TRI KHOP TU DOANH
OPEN CUR
 FOR

 SELECT NVL(SUM(IO.MATCHPRICE*IO.MATCHQTTY),0) FROM
(
    SELECT * FROM  ODMAST WHERE DELTD <>'Y'
    AND  TXDATE <= TO_DATE (T_DATE ,'DD/MM/YYYY') AND TXDATE >= TO_DATE (F_DATE ,'DD/MM/YYYY')
    AND EXECTYPE LIKE  V_STREXECTYPE AND  VOUCHER  LIKE V_STRVOUCHER
    AND  PRICETYPE LIKE V_STRPRICETYPE AND AFACCTNO LIKE '0001222222'
    UNION  ALL
    SELECT *  FROM ODMASTHIST WHERE DELTD <>'Y'
    AND  TXDATE <= TO_DATE (T_DATE ,'DD/MM/YYYY') AND TXDATE >= TO_DATE (F_DATE ,'DD/MM/YYYY')
    AND   EXECTYPE LIKE  V_STREXECTYPE AND  VOUCHER  LIKE V_STRVOUCHER
    AND PRICETYPE LIKE V_STRPRICETYPE AND AFACCTNO LIKE '0001222222'
 ) OD ,
(SELECT * FROM IOD UNION ALL SELECT * FROM IODHIST)IO,
(SELECT * FROM SBSECURITIES WHERE SYMBOL  LIKE  V_STRSYMBOL AND TRADEPLACE  LIKE V_STRTRADEPLACE)sb
 WHERE OD.ORDERID= IO.ORGORDERID AND  OD.CODEID=SB.CODEID
;
LOOP
  FETCH CUR
       INTO V_NUMFEE_TD ;
       EXIT WHEN CUR%NOTFOUND;
  END LOOP;
CLOSE CUR;
--KET THUC TINH GIA TRI KHOP TU DOANH


OPEN PV_REFCURSOR
   FOR
   SELECT V_NUMFEEACR V_NUMFEEACR, V_NUMFEEACR_BRO V_NUMFEEACR_BRO,V_NUMFEE_TD V_NUMFEE_TD,OD.*
FROM
( SELECT  OD.ORDERID,OD.TXDATE,SB.SYMBOL,OD.ORDERQTTY,OD.QUOTEPRICE,OD.CIACCTNO,CF.FULLNAME,
                         SB.TRADEPLACE TRADEPLACE,CF.CUSTODYCD,od.VOUCHER,
                   (CASE  when TL.TLTXCD IN ('8882','8883','8884','8885') THEN 'C' ELSE od.EXECTYPE END)EXTY,od.EXECTYPE,
                   (CASE  when TL.TLTXCD IN ('8882','8883','8884','8885') THEN 'C' else 'O' END ) TYORDER,round(STS.AMT/STS.QTTY)  MATCHPRICE, STS.QTTY MATCHQTTY,
                   (CASE WHEN STS.MARK =1 THEN OD.FEEACR ELSE 0 END ) FEEACR
FROM
(select * from odmast where deltd<>'Y' union ALL SELECT * FROM  odmasthist where deltd<>'Y')od,
(SELECT STS.* , (CASE WHEN STS.AUTOID=STS_MAX.AUTOID  THEN 1 ELSE 0 END) MARK FROM
(SELECT * FROM STSCHD WHERE DELTD <>'Y'AND DUETYPE IN ('SS','SM') UNION ALL
 SELECT * FROM STSCHDHIST WHERE DELTD <>'Y'AND DUETYPE IN ('SS','SM'))STS,
(SELECT MAX(AUTOID) AUTOID,ORGORDERID FROM STSCHDHIST WHERE DUETYPE IN ('SS','SM') AND DELTD <>'Y' GROUP BY ORGORDERID
UNION ALL
SELECT MAX(AUTOID) AUTOID,ORGORDERID FROM STSCHD WHERE DUETYPE IN ('SS','SM') AND DELTD <>'Y' GROUP BY ORGORDERID )STS_MAX
WHERE STS.ORGORDERID = STS_MAX.ORGORDERID
ORDER BY STS.ORGORDERID)STS,
(select * from tllog where deltd <> 'Y' UNION ALL select * from tllogall where deltd <> 'Y' )tl,
 SBSECURITIES SB,AFMAST AF ,CFMAST CF
where TL.TXDATE = OD.TXDATE AND TL.TXNUM=OD.TXNUM
 and OD.ORDERID =STS.ORGORDERID
  AND OD.CIACCTNO=AF.ACCTNO
  AND AF.CUSTID=CF.CUSTID
  AND OD.CODEID=SB.CODEID
 AND OD.TXDATE >= TO_DATE (F_DATE, 'DD/MM/YYYY')
  AND OD.TXDATE <= TO_DATE (T_DATE, 'DD/MM/YYYY')
    AND SB.SYMBOL LIKE V_STRSYMBOL
    AND OD.EXECTYPE LIKE V_STREXECTYPE
    AND SB.TRADEPLACE LIKE  V_STRTRADEPLACE
    AND SUBSTR (OD.AFACCTNO, 1, 4) LIKE V_STRBRID
    and od.VOUCHER like V_STRVOUCHER) OD
    WHERE OD.TYORDER LIKE  V_STRTYPEORDER
      ORDER BY  OD.CIACCTNO, OD.TXDATE , OD.ORDERID;

/*/
   ELSE
      OPEN PV_REFCURSOR
       FOR
              SELECT  V_NUMFEEACR V_NUMFEEACR, V_NUMFEEACR_BRO V_NUMFEEACR_BRO , V_NUMFEE_TD V_NUMFEE_TD, T.*,NVL(IO.MATCHQTTY,0) MATCHQTTY,NVL(IO.MATCHPRICE,0) MATCHPRICE FROM
                 (SELECT OD.ORDERID,OD.TXDATE,SB.SYMBOL, (CASE WHEN OD.PRICETYPE IN ('ATO','ATC')THEN  OD.PRICETYPE  ELSE  TO_CHAR(OD.QUOTEPRICE) END )QUOTEPRICE ,
                         OD.ORDERQTTY, OD.CIACCTNO,CF.FULLNAME,OD.FEEACR,
                         SB.TRADEPLACE TRADEPLACE,CF.CUSTODYCD,od.VOUCHER,
                   (CASE  when TL.TLTXCD IN ('8882','8883','8884','8885') THEN 'C' ELSE od.EXECTYPE END)EXTY,od.EXECTYPE,
                   (CASE  when TL.TLTXCD IN ('8882','8883','8884','8885') THEN 'C' else 'O' END ) TYORDER
                  FROM (SELECT* FROM ODMAST
                        WHERE TXDATE >= TO_DATE (F_DATE, 'DD/MM/YYYY')
                        AND TXDATE <= TO_DATE (T_DATE, 'DD/MM/YYYY')
                        UNION ALL
                        SELECT * FROM ODMASTHIST
                        WHERE TXDATE >= TO_DATE (F_DATE, 'DD/MM/YYYY')
                        AND TXDATE <= TO_DATE (T_DATE, 'DD/MM/YYYY')
                        )OD,
                       (SELECT * FROM TLLOG
                           WHERE DELTD<>'Y'
                        AND TXDATE >= TO_DATE (F_DATE, 'DD/MM/YYYY')
                        AND TXDATE <= TO_DATE (T_DATE, 'DD/MM/YYYY')
                        UNION ALL
                        SELECT * FROM TLLOGALL
                        WHERE DELTD<>'Y'
                        AND TXDATE >= TO_DATE (F_DATE, 'DD/MM/YYYY')
                        AND TXDATE <= TO_DATE (T_DATE, 'DD/MM/YYYY')
                      )TL  , SBSECURITIES SB,AFMAST AF ,CFMAST CF
                  WHERE  OD.CODEID=SB.CODEID
                       AND TL.TXDATE = OD.TXDATE
                       AND TL.TXNUM=OD.TXNUM
                       AND OD.CIACCTNO=AF.ACCTNO
                       AND AF.CUSTID=CF.CUSTID
                       AND SB.SYMBOL LIKE V_STRSYMBOL
                       AND OD.EXECTYPE LIKE V_STREXECTYPE
                       --THANHTC THEM THAM SO PRICETYPE
                       AND OD.PRICETYPE LIKE V_STRPRICETYPE
                       --THANHTC END.
                       AND SB.TRADEPLACE LIKE  V_STRTRADEPLACE
                       and od.VOUCHER like V_STRVOUCHER
                       )T
                  LEFT JOIN
                  ( SELECT * FROM IOD
                  UNION ALL
                   SELECT * FROM IODHIST
                  ) IO
                  ON IO.ORGORDERID=T.ORDERID
                  WHERE T.TYORDER LIKE  V_STRTYPEORDER
                  ORDER BY  T.CIACCTNO, T.TXDATE , T.ORDERID
          ;

*/

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

