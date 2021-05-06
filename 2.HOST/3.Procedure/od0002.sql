﻿CREATE OR REPLACE PROCEDURE od0002 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2,
   SYMBOL         IN       VARCHAR2,
   EXECTYPE       IN       VARCHAR2,
   TRADEPLACE     IN       VARCHAR2,
   VOUCHER        IN       VARCHAR2,
   PRICETYPE      IN       VARCHAR2,
   MATCHTYPE      IN       VARCHAR2,
   VIA            IN       VARCHAR2,
   GRCAREBY       IN       VARCHAR2,
   TLID           IN       VARCHAR2,
   SECTYPE                 IN       VARCHAR2,
   BONDTYPE                 IN       VARCHAR2
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
   V_STRCUSTODYCD       VARCHAR2 (20);
   V_STRAFACCTNO        VARCHAR2 (20);
   V_STRSYMBOL          VARCHAR2 (20);
   V_STRTRADEPLACE      VARCHAR2 (3);
   V_STRVOUCHER         VARCHAR2 (3);
   V_STRPRICETYPE       VARCHAR2 (10);
   V_STRVIA             VARCHAR2 (10);
   V_NUMFEEACR          NUMBER := 0;
   V_NUMFEEACR_BRO      NUMBER := 0;
   V_NUMEXECAMT__BRO    NUMBER := 0;
   V_STRMATCHTYPE       VARCHAR2 (5);
   V_StrCAREBY          VARCHAR2 (20);
   V_STRTLID            VARCHAR2(6);
   V_SECTYPE   	 VARCHAR2 (5);
   V_BONDTYPE    VARCHAR2 (5);
   V_CUR_DATE           DATE;
   CUR                  PKG_REPORT.REF_CURSOR;

-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
   V_STROPTION := OPT;
V_STRTLID:= TLID;
   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

    -- GET REPORT'S PARAMETERS

   IF(upper(PV_CUSTODYCD) <> 'ALL') THEN
        V_STRCUSTODYCD := trim(upper(PV_CUSTODYCD));
   ELSE
        V_STRCUSTODYCD := '%';
   END IF;

   IF(upper(PV_AFACCTNO) <> 'ALL') THEN
        V_STRAFACCTNO := trim(PV_AFACCTNO);
   ELSE
        V_STRAFACCTNO := '%';
   END IF;

   IF (TRADEPLACE <> 'ALL')
   THEN
      V_STRTRADEPLACE := TRADEPLACE;
   ELSE
      V_STRTRADEPLACE := '%%';
   END IF;
   --
    IF (SYMBOL <> 'ALL')
   THEN
      V_STRSYMBOL := replace(trim(SYMBOL),' ','_');
   ELSE
      V_STRSYMBOL := '%%';
   END IF;
   --
   IF (EXECTYPE <> 'ALL' and EXECTYPE <> 'DP')
   THEN
      V_STREXECTYPE := EXECTYPE;
   ---loai lenh la xy ly cam co
   elsif (EXECTYPE = 'DP') then
      V_STREXECTYPE := 'Y';
   ELSE
      V_STREXECTYPE := '%%';
   END IF;

    IF (VOUCHER <> 'ALL')
   THEN
      V_STRVOUCHER := VOUCHER;
   ELSE
      V_STRVOUCHER := '%%';
   END IF;

   IF (VIA <> 'ALL')
   THEN
      V_STRVIA := VIA;
   ELSE
      V_STRVIA := '%%';
   END IF;

   IF (PRICETYPE <> 'ALL')
   THEN
      V_STRPRICETYPE := PRICETYPE;
   ELSE
      V_STRPRICETYPE := '%%';
   END IF;

   if (MATCHTYPE <> 'ALL')
   then
    V_STRMATCHTYPE := MATCHTYPE;
   else
    V_STRMATCHTYPE := '%';
   end if;

   IF (GRCAREBY <> 'ALL')
   THEN
     V_StrCAREBY := GRCAREBY;
   ELSE
      V_StrCAREBY:='%';
   END IF;

   --- TINH GT KHOP MG
    --1.7.2.1: MSBS-2280 Thêm tiêu chí đầu vào để xuất riêng GTGD và phí cho TPCP
   IF (SECTYPE <> 'ALL')
   THEN
      V_SECTYPE := SECTYPE;
   ELSE
      V_SECTYPE := '%%';
   END IF;
   --
   IF (BONDTYPE <> 'ALL')
   THEN
      V_BONDTYPE := BONDTYPE;
   ELSE
      V_BONDTYPE := '%%';
   END IF;

OPEN CUR
 FOR

SELECT NVL(SUM(IO.MATCHPRICE*IO.MATCHQTTY),0)
FROM
    (
/*        SELECT od.* FROM  ODMAST OD, afmast af
        WHERE OD.DELTD <>'Y' and od.afacctno = af.acctno and af.careby like V_StrCAREBY
            AND  OD.TXDATE <= TO_DATE (T_DATE ,'DD/MM/YYYY') AND OD.TXDATE >= TO_DATE (F_DATE ,'DD/MM/YYYY')
            AND OD.EXECTYPE LIKE  V_STREXECTYPE AND  OD.VOUCHER  LIKE V_STRVOUCHER
            AND  OD.PRICETYPE LIKE V_STRPRICETYPE AND OD.via LIKE V_STRVIA
    UNION ALL
*/        SELECT od.* FROM  /*ODMASTHIST*/ vw_odmast_all OD, afmast af, cfmast cf
        WHERE OD.DELTD <>'Y' and od.afacctno = af.acctno and af.careby like V_StrCAREBY
            AND  OD.TXDATE <= TO_DATE (T_DATE ,'DD/MM/YYYY') AND OD.TXDATE >= TO_DATE (F_DATE ,'DD/MM/YYYY')
            AND OD.EXECTYPE LIKE  V_STREXECTYPE AND  OD.VOUCHER  LIKE V_STRVOUCHER
            AND  OD.PRICETYPE LIKE V_STRPRICETYPE AND OD.via LIKE V_STRVIA
            AND af.custid = cf.custid AND od.afacctno = af.acctno
            AND cf.custodycd LIKE V_STRCUSTODYCD AND af.acctno LIKE V_STRAFACCTNO
    ) OD,
    (SELECT * FROM IOD where DELTD<> 'Y' AND SUBSTR(custodycd,4,1)  ='P' AND TXDATE BETWEEN TO_DATE (F_DATE, 'DD/MM/YYYY') AND TO_DATE (T_DATE, 'DD/MM/YYYY')
    UNION ALL
    SELECT * FROM IODHIST where DELTD<> 'Y'AND SUBSTR(custodycd,4,1)  ='P' AND TXDATE BETWEEN TO_DATE (F_DATE, 'DD/MM/YYYY') AND TO_DATE (T_DATE, 'DD/MM/YYYY')
    ) IO,
    (SELECT * FROM SBSECURITIES WHERE SYMBOL  LIKE  V_STRSYMBOL AND TRADEPLACE  LIKE V_STRTRADEPLACE)sb
WHERE OD.ORDERID= IO.ORGORDERID AND  OD.CODEID=SB.CODEID
;
LOOP
  FETCH CUR
       INTO V_NUMEXECAMT__BRO ;
       EXIT WHEN CUR%NOTFOUND;
  END LOOP;
CLOSE CUR;
--- TINH TONG PHI

OPEN CUR
 FOR
SELECT SUM(AMT.FEEACR)
FROM
(
    SELECT sum(CASE WHEN OD.EXECAMT >0 AND OD.FEEACR =0 AND OD.STSSTATUS = 'N' AND OD.TXDATE = V_CUR_DATE AND decode(nvl(bs.bchsts,'N'),'Y','Y','N') = 'N'
        THEN ROUND(OD.EXECAMT * ODT.DEFFEERATE/100) ELSE OD.FEEACR END) FEEACR
    FROM ODMAST od,
        (SELECT * FROM SBSECURITIES WHERE SYMBOL  LIKE  V_STRSYMBOL AND TRADEPLACE  LIKE V_STRTRADEPLACE) sb,
        afmast af, cfmast cf, ODTYPE odt, (SELECT * FROM sbbatchsts bs WHERE bs.bchmdl = 'ODFEECAL') bs
    WHERE od.DELTD <>'Y' and od.afacctno = af.acctno and af.careby like V_StrCAREBY
        and odt.actype = OD.ACTYPE AND OD.TXDATE = bs.bchdate(+)
        AND  od.TXDATE <= TO_DATE (T_DATE ,'DD/MM/YYYY') AND od.TXDATE >= TO_DATE (F_DATE ,'DD/MM/YYYY')
        AND  od.EXECTYPE LIKE  V_STREXECTYPE AND od.CODEID=SB.CODEID
        AND  od.VOUCHER  LIKE V_STRVOUCHER  AND od.PRICETYPE LIKE V_STRPRICETYPE
        AND od.via LIKE V_STRVIA
        AND af.custid = cf.custid AND od.afacctno = af.acctno
        AND cf.custodycd LIKE V_STRCUSTODYCD AND af.acctno LIKE V_STRAFACCTNO
    UNION ALL
    SELECT sum(CASE WHEN OD.EXECAMT >0 AND OD.FEEACR =0 AND OD.STSSTATUS = 'N' AND OD.TXDATE = V_CUR_DATE AND decode(nvl(bs.bchsts,'N'),'Y','Y','N') = 'N'
        THEN ROUND(OD.EXECAMT * ODT.DEFFEERATE/100) ELSE OD.FEEACR END) FEEACR
    FROM ODMASTHIST od,(SELECT * FROM SBSECURITIES WHERE SYMBOL  LIKE  V_STRSYMBOL AND TRADEPLACE  LIKE V_STRTRADEPLACE)sb,
        afmast af, cfmast cf, ODTYPE odt, (SELECT * FROM sbbatchsts bs WHERE bs.bchmdl = 'ODFEECAL') bs
    WHERE od.DELTD <>'Y' and od.afacctno = af.acctno and af.careby like V_StrCAREBY
        and odt.actype = OD.ACTYPE AND OD.TXDATE = bs.bchdate(+)
        AND  od.TXDATE <= TO_DATE (T_DATE ,'DD/MM/YYYY') AND od.TXDATE >= TO_DATE (F_DATE ,'DD/MM/YYYY')
        AND od.EXECTYPE LIKE  V_STREXECTYPE
        AND od.PRICETYPE LIKE V_STRPRICETYPE
        AND od.CODEID=SB.CODEID
        AND od.via LIKE V_STRVIA
        AND af.custid = cf.custid AND od.afacctno = af.acctno
        AND cf.custodycd LIKE V_STRCUSTODYCD AND af.acctno LIKE V_STRAFACCTNO
)AMT

;
LOOP
  FETCH CUR
       INTO V_NUMFEEACR ;
       EXIT WHEN CUR%NOTFOUND;
  END LOOP;
CLOSE CUR;

--- TINH TONG PHI MOI GIOI
OPEN CUR
 FOR
SELECT SUM(AMT.FEEACR)
FROM
(
    SELECT sum(CASE WHEN OD.EXECAMT >0 AND OD.FEEACR =0 AND OD.STSSTATUS = 'N' AND OD.TXDATE = V_CUR_DATE AND decode(nvl(bs.bchsts,'N'),'Y','Y','N') = 'N'
            THEN ROUND(OD.EXECAMT * ODT.DEFFEERATE/100) ELSE OD.FEEACR END) FEEACR
    FROM ODMAST OD,AFMAST AF ,CFMAST CF,(SELECT * FROM SBSECURITIES WHERE SYMBOL  LIKE  V_STRSYMBOL AND TRADEPLACE  LIKE V_STRTRADEPLACE)sb
        , ODTYPE odt, (SELECT * FROM sbbatchsts bs WHERE bs.bchmdl = 'ODFEECAL') bs
    WHERE OD.DELTD <>'Y' AND  OD.afacctno = AF.acctno AND AF.custid =CF.custid
        and odt.actype = OD.ACTYPE
        and af.careby like V_StrCAREBY
        AND  OD.TXDATE <= TO_DATE (T_DATE ,'DD/MM/YYYY') AND OD.TXDATE >= TO_DATE (F_DATE ,'DD/MM/YYYY')
        AND SUBSTR(CF.custodycd,4,1)  ='P' AND OD.CODEID=SB.CODEID
        AND OD.EXECTYPE LIKE  V_STREXECTYPE AND  OD.VOUCHER  LIKE V_STRVOUCHER  AND OD.PRICETYPE LIKE V_STRPRICETYPE
        AND OD.via LIKE V_STRVIA
        AND cf.custodycd LIKE V_STRCUSTODYCD AND af.acctno LIKE V_STRAFACCTNO
    UNION ALL
    SELECT sum(CASE WHEN OD.EXECAMT >0 AND OD.FEEACR =0 AND OD.STSSTATUS = 'N' AND OD.TXDATE = V_CUR_DATE AND decode(nvl(bs.bchsts,'N'),'Y','Y','N') = 'N'
            THEN ROUND(OD.EXECAMT * ODT.DEFFEERATE/100) ELSE OD.FEEACR END) FEEACR
    FROM ODMASTHIST OD,AFMAST AF ,CFMAST CF,(SELECT * FROM SBSECURITIES WHERE SYMBOL  LIKE  V_STRSYMBOL AND TRADEPLACE  LIKE V_STRTRADEPLACE)sb
        , ODTYPE odt, (SELECT * FROM sbbatchsts bs WHERE bs.bchmdl = 'ODFEECAL') bs
    WHERE OD.DELTD <>'Y' AND  OD.afacctno = AF.acctno AND AF.custid =CF.custid
        and af.careby like V_StrCAREBY AND OD.TXDATE = bs.bchdate(+)
        and odt.actype = OD.ACTYPE
        AND  OD.TXDATE <= TO_DATE (T_DATE ,'DD/MM/YYYY') AND OD.TXDATE >= TO_DATE (F_DATE ,'DD/MM/YYYY')
        AND SUBSTR(CF.custodycd,4,1) = 'P' AND OD.CODEID=SB.CODEID
        AND OD.EXECTYPE LIKE  V_STREXECTYPE AND  OD.VOUCHER  LIKE V_STRVOUCHER  AND OD.PRICETYPE LIKE V_STRPRICETYPE
        AND OD.via LIKE V_STRVIA
        AND cf.custodycd LIKE V_STRCUSTODYCD AND af.acctno LIKE V_STRAFACCTNO
)AMT
;

LOOP
  FETCH CUR
       INTO V_NUMFEEACR_BRO ;
       EXIT WHEN CUR%NOTFOUND;
  END LOOP;
CLOSE CUR;

   SELECT TO_DATE(VARVALUE ,'DD/MM/YYYY') INTO V_CUR_DATE FROM SYSVAR WHERE VARNAME ='CURRDATE';


   -- GET REPORT'S DATA
OPEN PV_REFCURSOR FOR

    SELECT nvl(V_NUMFEEACR,0) V_NUMFEEACR, nvl(V_NUMFEEACR_BRO,0) V_NUMFEEACR_BRO ,nvl(V_NUMEXECAMT__BRO,0) V_NUMEXECAMT__BRO ,T.*,NVL(IO.MATCHQTTY,0) MATCHQTTY,NVL(IO.MATCHPRICE,0) MATCHPRICE
    FROM
        (
            SELECT OD.ORDERID,OD.TXDATE,SB.SYMBOL,(CASE WHEN OD.PRICETYPE IN ('ATO','ATC')THEN  OD.PRICETYPE
                ELSE TO_CHAR(OD.QUOTEPRICE) END )QUOTEPRICE ,OD.ORDERQTTY,OD.CIACCTNO,CF.FULLNAME,
                CASE WHEN OD.EXECAMT >0 AND OD.FEEACR =0 AND OD.STSSTATUS = 'N' AND OD.TXDATE = V_CUR_DATE AND decode(nvl(bs.bchsts,'N'),'Y','Y','N') = 'N'
                THEN ROUND(OD.EXECAMT * ODT.DEFFEERATE/100) ELSE OD.FEEACR END FEEACR,
                od.TRADEPLACE TRADEPLACE,CF.CUSTODYCD , OD.VIA  VIA, OD.TXTIME,OD.MATCHTYPE,
                (CASE  WHEN OD.REFORDERID IS NOT NULL THEN 'C' ELSE OD.EXECTYPE END)EXTY,
                case when OD.isdisposal = 'Y' then 'DP' else OD.EXECTYPE end EXECTYPE,
                (CASE  WHEN OD.REFORDERID IS NOT NULL THEN 'C' ELSE 'O' END ) TYORDER,
                OD.isdisposal
            FROM (SELECT * FROM vw_odmast_tradeplace_all WHERE deltd <>'Y' AND TXDATE BETWEEN TO_DATE (F_DATE, 'DD/MM/YYYY') AND TO_DATE (T_DATE, 'DD/MM/YYYY')) OD,
                SBSECURITIES SB,AFMAST AF ,CFMAST CF, ODTYPE odt, (SELECT * FROM sbbatchsts bs WHERE bs.bchmdl = 'ODFEECAL') bs
            WHERE  OD.CODEID=SB.CODEID AND OD.TXDATE = bs.bchdate(+)
                AND odt.actype = OD.ACTYPE
                AND OD.CIACCTNO=AF.ACCTNO
                AND AF.CUSTID=CF.CUSTID
                AND SB.SYMBOL LIKE V_STRSYMBOL
                AND (CASE WHEN V_STREXECTYPE = 'Y' THEN OD.isdisposal --loai lenh xy ly
                        ELSE OD.EXECTYPE END) LIKE V_STREXECTYPE
                AND OD.MATCHTYPE like V_STRMATCHTYPE
                AND od.TRADEPLACE LIKE  V_STRTRADEPLACE
                AND OD.PRICETYPE LIKE V_STRPRICETYPE
                AND nvl(OD.VOUCHER,'N') LIKE V_STRVOUCHER
                AND exists (select gu.grpid from tlgrpusers gu where af.careby = gu.grpid and gu.tlid = V_STRTLID )
                AND OD.Via LIKE V_STRVIA
                AND af.careby LIKE V_StrCAREBY
                AND cf.custodycd LIKE V_STRCUSTODYCD AND af.acctno LIKE V_STRAFACCTNO
                and sb.sectype like V_SECTYPE
                and sb.bondtype like V_BONDTYPE
        )T
    LEFT JOIN
        (
            SELECT * FROM IOD WHERE DELTD<>'Y' AND TXDATE BETWEEN TO_DATE (F_DATE, 'DD/MM/YYYY') AND TO_DATE (T_DATE, 'DD/MM/YYYY')
        UNION ALL
            SELECT * FROM IODHIST WHERE DELTD<>'Y' AND TXDATE BETWEEN TO_DATE (F_DATE, 'DD/MM/YYYY') AND TO_DATE (T_DATE, 'DD/MM/YYYY')
        ) IO ON IO.ORGORDERID=T.ORDERID
ORDER BY  T.EXECTYPE, T.SYMBOL,T.TXDATE,T.CIACCTNO

;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/
