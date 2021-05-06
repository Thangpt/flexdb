CREATE OR REPLACE PROCEDURE OD9905 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   SYMBOL         IN       VARCHAR2,
   EXECTYPE       IN       VARCHAR2,
   TRADEPLACE     IN       VARCHAR2,
   VOUCHER        IN       VARCHAR2,
   Pricetype      In       Varchar2,  
   Matchtype      In       Varchar2,
   Via            In       Varchar2,
   I_Brid         In       Varchar2,
   CAREBY         IN       VARCHAR2
   )
IS
--

-- ---------   ------  -------------------------------------------
   V_STROPTION          VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID            VARCHAR2 (4);               -- USED WHEN V_NUMOPTION > 0
   V_STREXECTYPE        VARCHAR2 (5);
   V_STRSYMBOL          VARCHAR2 (5);
   V_STRTRADEPLACE      VARCHAR2 (3);
   V_STRVOUCHER         VARCHAR2 (3);
  -- V_STRTYPEORDER       VARCHAR2 (3);
   V_STRPRICETYPE       VARCHAR2 (10);
   V_STRVIA             VARCHAR2 (10);
   V_NUMFEEACR          NUMBER := 0;
   V_NUMFEEACR_BRO      NUMBER := 0;
   V_NUMEXECAMT__BRO    NUMBER := 0;
   V_STRMATCHTYPE         VARCHAR2 (5);
   /*V_NUMFEEACR          := 0;
   V_NUMFEEACR_BRO      := 0;
   V_NUMEXECAMT__BRO    := 0;
    */
   V_Stri_Brid               Varchar2(5);
   V_STRCAREBY               VARCHAR2(5);
     
   CUR            PKG_REPORT.REF_CURSOR;

-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%';
   END IF;

    -- GET REPORT'S PARAMETERS
   IF (TRADEPLACE <> 'ALL')
   THEN
      V_STRTRADEPLACE := TRADEPLACE;
   ELSE
      V_STRTRADEPLACE := '%';
   END IF;
   --
    IF (SYMBOL <> 'ALL')
   THEN
      V_STRSYMBOL := SYMBOL;
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
   Else
      V_STRVOUCHER := '%';
   END IF;

   IF (VIA <> 'ALL')
   THEN
      V_STRVIA := VIA;
   ELSE
      V_STRVIA := '%';
   END IF;

    --IF (TYPEORDER <> 'ALL')
  -- THEN
    --  V_STRTYPEORDER := TYPEORDER;
  -- ELSE
   --   V_STRTYPEORDER := '%%';
 ---  END IF;

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

  IF (I_BRID = 'ALL' or I_BRID is null)
   THEN
      V_STRI_BRID := '%';
   ELSE
      V_STRI_BRID := I_BRID;
   End If;

   IF(CAREBY = 'ALL' OR CAREBY IS NULL)
    THEN
       V_STRCAREBY := '%';
   ELSE
       V_Strcareby := Careby;
   END IF;

   --- TINH GT KHOP MG

OPEN CUR
 FOR

Select Nvl(Sum(Io.Matchprice*Io.Matchqtty),0) 
FROM (  SELECT * FROM  ODMAST OD  WHERE OD.DELTD <>'Y'
        AND  OD.TXDATE <= TO_DATE (T_DATE ,'DD/MM/YYYY') AND OD.TXDATE >= TO_DATE (F_DATE ,'DD/MM/YYYY')
        AND OD.EXECTYPE LIKE  V_STREXECTYPE AND  OD.VOUCHER  LIKE V_STRVOUCHER
        AND  OD.PRICETYPE LIKE V_STRPRICETYPE AND OD.via LIKE V_STRVIA
        AND(SUBSTR(OD.ORDERID,1,4) LIKE V_STRBRID OR SUBSTR(OD.AFACCTNO,1,4) LIKE V_STRBRID)
        UNION  ALL
        SELECT * FROM  ODMASTHIST OD  WHERE OD.DELTD <>'Y'
        AND  OD.TXDATE <= TO_DATE (T_DATE ,'DD/MM/YYYY') AND OD.TXDATE >= TO_DATE (F_DATE ,'DD/MM/YYYY')
        AND OD.EXECTYPE LIKE  V_STREXECTYPE AND  OD.VOUCHER  LIKE V_STRVOUCHER
        AND  OD.PRICETYPE LIKE V_STRPRICETYPE AND OD.via LIKE V_STRVIA
        AND(SUBSTR(OD.ORDERID,1,4) LIKE V_STRBRID OR SUBSTR(OD.AFACCTNO,1,4) LIKE V_STRBRID)
      ) OD ,
      (SELECT * FROM IOD where DELTD<> 'Y' AND SUBSTR(custodycd,4,1)  ='P' UNION ALL SELECT * FROM IODHIST where DELTD<> 'Y'AND SUBSTR(custodycd,4,1)  ='P')IO,
      (SELECT * FROM SBSECURITIES WHERE SYMBOL  LIKE  V_STRSYMBOL AND TRADEPLACE  LIKE V_STRTRADEPLACE)sb
Where Od.Orderid= Io.Orgorderid And  Od.Codeid=Sb.Codeid;

LOOP
  FETCH CUR
       INTO V_NUMEXECAMT__BRO ;
       EXIT WHEN CUR%NOTFOUND;
  END LOOP;
CLOSE CUR;
--- TINH TONG PHI

OPEN CUR FOR
SELECT SUM(AMT.FEEACR)
FROM (
        SELECT SUM(FEEACR) FEEACR FROM ODMAST,(SELECT * FROM SBSECURITIES WHERE SYMBOL  LIKE  V_STRSYMBOL AND TRADEPLACE  LIKE V_STRTRADEPLACE)sb
         WHERE DELTD <>'Y'
        AND  TXDATE <= TO_DATE (T_DATE ,'DD/MM/YYYY') AND TXDATE >= TO_DATE (F_DATE ,'DD/MM/YYYY')
        AND  EXECTYPE LIKE  V_STREXECTYPE AND ODMAST.CODEID=SB.CODEID
        AND  VOUCHER  LIKE V_STRVOUCHER  AND PRICETYPE LIKE V_STRPRICETYPE
        AND (SUBSTR(ORDERID,1,4) LIKE V_STRBRID OR SUBSTR(AFACCTNO,1,4) LIKE V_STRBRID)
        AND via LIKE V_STRVIA
        UNION ALL
        SELECT SUM(FEEACR) FEEACR FROM ODMASTHIST,(SELECT * FROM SBSECURITIES WHERE SYMBOL  LIKE  V_STRSYMBOL AND TRADEPLACE  LIKE V_STRTRADEPLACE)sb WHERE DELTD <>'Y'
        AND  TXDATE <= TO_DATE (T_DATE ,'DD/MM/YYYY') AND TXDATE >= TO_DATE (F_DATE ,'DD/MM/YYYY')
        AND EXECTYPE LIKE  V_STREXECTYPE
        -- AND  VOUCHER  LIKE V_STRTYPEORDER
        AND PRICETYPE LIKE V_STRPRICETYPE
        AND ODMASTHIST.CODEID=SB.CODEID
        AND (SUBSTR(ORDERID,1,4) LIKE V_STRBRID OR SUBSTR(AFACCTNO,1,4) LIKE V_STRBRID)
        AND via LIKE V_STRVIA
    )AMT;
LOOP
  FETCH CUR
       INTO V_NUMFEEACR ;
       EXIT WHEN CUR%NOTFOUND;
  END LOOP;
CLOSE CUR;

--- TINH TONG PHI MOI GIOI
OPEN CUR FOR
 Select Sum(Amt.Feeacr)
 FROM (
        Select Sum(Feeacr) Feeacr 
        FROM ODMAST OD,AFMAST AF ,CFMAST CF,(SELECT * FROM SBSECURITIES WHERE SYMBOL  LIKE  V_STRSYMBOL AND TRADEPLACE  LIKE V_STRTRADEPLACE)sb
        WHERE OD.DELTD <>'Y' AND  OD.afacctno = AF.acctno AND AF.custid =CF.custid
        AND  OD.TXDATE <= TO_DATE (T_DATE ,'DD/MM/YYYY') AND OD.TXDATE >= TO_DATE (F_DATE ,'DD/MM/YYYY')
        AND SUBSTR(CF.custodycd,4,1)  ='P' AND OD.CODEID=SB.CODEID
        AND OD.EXECTYPE LIKE  V_STREXECTYPE AND  OD.VOUCHER  LIKE V_STRVOUCHER  AND OD.PRICETYPE LIKE V_STRPRICETYPE
        AND (SUBSTR(OD.ORDERID,1,4) LIKE V_STRBRID OR SUBSTR(OD.AFACCTNO,1,4) LIKE V_STRBRID)
        AND OD.via LIKE V_STRVIA
        UNION ALL
        SELECT SUM(FEEACR) FEEACR FROM ODMASTHIST OD,AFMAST AF ,CFMAST CF,(SELECT * FROM SBSECURITIES WHERE SYMBOL  LIKE  V_STRSYMBOL AND TRADEPLACE  LIKE V_STRTRADEPLACE)sb
        WHERE OD.DELTD <>'Y' AND  OD.afacctno = AF.acctno AND AF.custid =CF.custid
        AND  OD.TXDATE <= TO_DATE (T_DATE ,'DD/MM/YYYY') AND OD.TXDATE >= TO_DATE (F_DATE ,'DD/MM/YYYY')
        AND SUBSTR(CF.custodycd,4,1)  ='P' AND OD.CODEID=SB.CODEID
        AND OD.EXECTYPE LIKE  V_STREXECTYPE AND  OD.VOUCHER  LIKE V_STRVOUCHER  AND OD.PRICETYPE LIKE V_STRPRICETYPE
        AND (SUBSTR(OD.ORDERID,1,4) LIKE V_STRBRID OR SUBSTR(OD.AFACCTNO,1,4) LIKE V_STRBRID)
        AND OD.via LIKE V_STRVIA
    )AMT;

LOOP
  FETCH CUR
       INTO V_NUMFEEACR_BRO ;
       EXIT WHEN CUR%NOTFOUND;
  END LOOP;
CLOSE CUR;

-- GET REPORT'S DATA
OPEN PV_REFCURSOR FOR
   Select Nvl(V_Numfeeacr,0) V_Numfeeacr, Nvl(V_Numfeeacr_Bro,0) V_Numfeeacr_Bro ,Nvl(V_Numexecamt__Bro,0) V_Numexecamt__Bro,
          T.*,Nvl(Io.Matchqtty,0) Matchqtty,Nvl(Io.Matchprice,0) Matchprice 
   From
       ( Select Od.Orderid,Od.Txdate,Sb.Symbol,(Case When Od.Pricetype In ('ATO','ATC')Then  Od.Pricetype  Else   To_Char(Od.Quoteprice) End )Quoteprice ,
                Od.Orderqtty,Od.Ciacctno,Cf.Fullname,Od.Feeacr,
                Sb.Tradeplace Tradeplace,Cf.Custodycd , decode(Od.Via,'O','Online','F','San','W','DLy','T','DT','B','Broker') Via, 
                Od.Txtime,Od.Matchtype,
                (Case  When Od.Reforderid Is Not Null Then 'C' Else Od.Exectype End)Exty,Od.Exectype,
                (Case  When Od.Reforderid Is Not Null Then 'C' Else 'O' End ) Tyorder,
                tl1.tlid,nvl(tl1.tlname,'ONLINE') tlname ,br.brname,gr.grpname
        From ( Select *
               From Odmast
               Where Deltd <>'Y' And (Substr(Orderid,1,4) Like V_Strbrid Or Substr(Afacctno,1,4) Like V_Strbrid)
               
               Union All
               
               Select * 
               From Odmasthist
               Where Deltd <>'Y' And (Substr(Orderid,1,4) Like V_Strbrid Or Substr(Afacctno,1,4) Like V_Strbrid) )Od,
              vw_tllog_all vl,
              Sbsecurities Sb,Afmast Af ,Cfmast Cf, Tlprofiles Uf, Brgrp Br,tlgroups gr,tlprofiles tl1 
              
        WHERE  OD.CODEID=SB.CODEID
             AND OD.CIACCTNO=AF.ACCTNO
             AND AF.CUSTID=CF.CUSTID
             AND OD.TXDATE >= TO_DATE (F_DATE, 'DD/MM/YYYY')
             AND OD.TXDATE <= TO_DATE (T_DATE, 'DD/MM/YYYY')
             AND SB.SYMBOL LIKE V_STRSYMBOL
             AND OD.EXECTYPE LIKE V_STREXECTYPE
             AND OD.MATCHTYPE like V_STRMATCHTYPE
             AND SB.TRADEPLACE LIKE  V_STRTRADEPLACE
             AND OD.PRICETYPE LIKE V_STRPRICETYPE
             AND nvl(OD.VOUCHER,'N') LIKE V_STRVOUCHER
             And Od.Via Like V_Strvia
             --new
             And Cf.Tlid = Uf.Tlid
             And Uf.Brid = Br.Brid  
             And Br.Brid Like V_Stri_Brid
             and cf.careby = gr.grpid
             And Cf.Careby Like V_Strcareby
             And Od.txnum = vl.txnum and od.txdate = vl.txdate
             and vl.tlid = tl1.Tlid(+)
      )T
      LEFT JOIN
      ( Select * 
        FROM IOD
        Where Deltd<>'Y'
        
        Union All
        
        Select * 
        FROM IODHIST
        Where Deltd<>'Y'
      ) IO ON IO.ORGORDERID=T.ORDERID
       -- WHERE T.TYORDER LIKE V_STRTYPEORDER
  ORDER BY  T.EXECTYPE, T.SYMBOL,T.TXDATE,T.CIACCTNO;

EXCEPTION
   WHEN OTHERS
   THEN
      Return;
End;
/

