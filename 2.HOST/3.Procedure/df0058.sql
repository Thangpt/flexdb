CREATE OR REPLACE PROCEDURE df0058 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BBRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   --PV_RLSTYPE     IN       VARCHAR2,
   PV_BANKNAME    IN       VARCHAR2,
   PV_SYMBOL      IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2,
   PV_NUM      IN          VARCHAR2
   )
IS
   V_STROPTION      VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRI_TYPE      VARCHAR2 (5);

   V_I_DATE       DATE;
   v_CUSTODYCD    varchar2(100);
   v_AFAcctno     varchar2(100);
   V_STRNUM       VARCHAR2(20);
   l_BRID_FILTER        VARCHAR2(50);
   l_BANKNAME   varchar2(100);
   L_RLSTYPE   varchar2(100);
    V_SYMBOL VARCHAR2(10);

   BEGIN

   V_STROPTION := OPT;
   l_BANKNAME:=PV_BANKNAME; -- ALL, MSBS, CF.SHORTNAME
   --L_RLSTYPE:= PV_RLSTYPE;

    IF (V_STROPTION = 'A') THEN
      l_BRID_FILTER := '%';
    ELSif (V_STROPTION = 'B') then
        select brgrp.mapid into l_BRID_FILTER from brgrp where brgrp.brid = BBRID;
    else
        l_BRID_FILTER := BBRID;
    END IF;


    IF (PV_CUSTODYCD <> 'ALL' OR PV_CUSTODYCD <> '' OR PV_CUSTODYCD <> NULL) THEN
        v_CUSTODYCD := PV_CUSTODYCD;
    ELSE
        v_CUSTODYCD  := '%';
    END IF;

    IF (PV_AFACCTNO <> 'ALL' OR PV_AFACCTNO <> '' OR PV_AFACCTNO <> NULL) THEN
        v_AFAcctno := PV_AFACCTNO;
    ELSE
        v_AFAcctno  := '%';
    END IF;

   IF (PV_NUM ='ALL') THEN
      V_STRNUM :='%';
   ELSE
      V_STRNUM := PV_NUM;
   END IF;
   IF (PV_SYMBOL ='ALL') THEN
      V_SYMBOL :='%';
   ELSE
      V_SYMBOL := PV_SYMBOL;
   END IF;




V_I_DATE := TO_DATE (I_DATE,'DD/MM/RRRR');

OPEN PV_REFCURSOR
FOR
/*
SELECT * FROM (
   SELECT LNM.RRTYPE,LNM.CUSTBANK,CF.CUSTODYCD, AF.ACCTNO AFACCTNO, LNM.OPNDATE, LNS.DUEDATE, DF.GROUPID, DF.ACCTNO, SB.SYMBOL
    , parvalue , DF.DFQTTY - NVL(ODM.SELLQTTY,0) TRADE,
     CASE WHEN sb.markettype = '001' AND sb.sectype IN ('003','006','222','333','444') THEN utf8nums.c_const_df_marketname
    WHEN  nvl(sb.tradeplace,'') = '001' THEN '2. HOSE'
    WHEN  nvl(sb.tradeplace,'') = '002' THEN '1. HNX'
    WHEN  nvl(sb.tradeplace,'') = '005' THEN '3. UPCOM'  END tradeplace,
    cf.fullname, cf.idcode, cf.idplace, cf.iddate, cf.address, cf.phone, cf.fax,
    lnM.rrtype || case when lnM.rrtype = 'B' then cf.shortname when lnM.rrtype = 'C' then 'MSBS' else null end rsctype,
           case when lnM.rrtype = 'C' then 'MSBS'
            when lnM.rrtype = 'B' then cfb.fullname
            else '' end rsctype_desc,
    CASE WHEN L_RLSTYPE = 'ALL' THEN NVL(ODM.EXECQTTY,0) + NVL(SE.NAMT,0)
            WHEN L_RLSTYPE = 'ODM' AND NVL(ODM.EXECQTTY,0) > 0 THEN NVL(ODM.EXECQTTY,0)
            WHEN L_RLSTYPE = 'SET' AND NVL(SE.NAMT,0) > 0 THEN NVL(SE.NAMT,0)
        ELSE 0 END RLSQTTY

FROM DFTYPE DFT, AFMAST AF, CFMAST CF, vw_lnschd_all LNS,  SBSECURITIES SB, vw_dfmast_all DF
    LEFT JOIN
        ( SELECT OD.TXDATE, REFID, SUM(ODM.QTTY) SELLQTTY, SUM(ODM.EXECQTTY) EXECQTTY FROM ODMAPEXT ODM, vw_odmast_all OD
            WHERE ODM.DELTD <> 'Y' AND ODM.ORDERID = OD.ORDERID
            AND OD.TXDATE= V_I_DATE
            GROUP BY OD.TXDATE, REFID
          UNION ALL
          SELECT OD.TXDATE, REFID, SUM(ODM.QTTY) SELLQTTY, SUM(ODM.EXECQTTY) EXECQTTY FROM ODMAPEXTHIST ODM, vw_odmast_all OD
          WHERE ODM.DELTD <> 'Y' AND ODM.ORDERID = OD.ORDERID
          AND OD.TXDATE= V_I_DATE
            GROUP BY OD.TXDATE,REFID
        ) ODM
        ON DF.ACCTNO = ODM.REFID
    LEFT JOIN
        (SELECT * FROM vw_setran_GEN WHERE TLTXCD LIKE '%2626%'
            AND FIELD = 'TRADE' AND TXTYPE = 'C' AND DELTD <> 'Y'
            AND TXDATE = V_I_DATE
        ) SE ON DF.ACCTNO = SE.REF,
    vw_lnmast_all LNM left join cfmast cfb on lnm.custbank = cfb.custid
    WHERE DF.ACTYPE=DFT.ACTYPE AND DF.AFACCTNO = AF.ACCTNO AND AF.CUSTID = CF.CUSTID
    AND DF.LNACCTNO = LNS.ACCTNO AND DF.LNACCTNO = LNM.ACCTNO AND DF.CODEID = SB.CODEID
    AND LNS.REFTYPE = 'P' AND DFT.ISVSD='Y'
    AND CF.CUSTODYCD LIKE v_CUSTODYCD
    AND AF.ACCTNO LIKE v_AFAcctno
    AND df.groupid LIKE V_STRNUM
    AND DF.CODEID LIKE V_SYMBOL
    and case when l_BANKNAME = 'ALL' then 1
                when l_BANKNAME = 'MSBS' and LNM.rrtype = 'C' then 1
                when cfB.shortname = l_BANKNAME and LNM.rrtype = 'B' then 1
            else 0 end = 1

    AND CASE WHEN L_RLSTYPE = 'ALL' THEN 1
            WHEN L_RLSTYPE = 'ODM' AND ODM.EXECQTTY > 0 THEN 1
            WHEN L_RLSTYPE = 'SET' AND NVL(SE.NAMT,0) > 0 THEN 1
        ELSE 0 END = 1
    AND case when V_STROPTION = 'A' then 1 else instr(l_BRID_FILTER,substr(AF.ACCTNO,1,4)) end  <> 0
) A WHERE     A. RLSQTTY > 0
order by tradeplace, RSCTYPE_DESC,custodycd, acctno, GROUPID, ACCTNO
*/

SELECT SYMBOL,PARVALUE,TRADEPLACE,DEBIT, CREDIT,SUM(RLSQTTY) RLSQTTY, BBRID v_strbrid FROM (

 SELECT SB.SYMBOL
    , parvalue , DF.DFQTTY TRADE,
     CASE WHEN sb.markettype = '001' AND sb.sectype IN ('003','006','222','333','444') THEN utf8nums.c_const_df_marketname
    WHEN  nvl(sb.tradeplace,'') = '001' THEN ' HOSE'
    WHEN  nvl(sb.tradeplace,'') = '002' THEN ' HNX'
    WHEN  nvl(sb.tradeplace,'') = '005' THEN ' UPCOM'  END tradeplace,
    cf.fullname, cf.idcode, cf.idplace, cf.iddate, cf.address, cf.phone, cf.fax,
    lnM.rrtype || case when lnM.rrtype = 'B' then cf.shortname when lnM.rrtype = 'C' then 'MSBS' else null end rsctype,
           case when lnM.rrtype = 'C' then 'MSBS'
            when lnM.rrtype = 'B' then cfb.fullname
            else '' end rsctype_desc,
    SE.NAMT RLSQTTY,
    case when substr(cf.custodycd,4,1) = 'C' then '01232.091'
        when substr(cf.custodycd,4,1) = 'P' then '01231.091'
        else '01233.005' end  CREDIT,
    case when substr(cf.custodycd,4,1) = 'C' then '01212.091'
        when substr(cf.custodycd,4,1) = 'P' then '01211.091'
        else '01213.005' end  DEBIT

FROM DFTYPE DFT, AFMAST AF, CFMAST CF, SBSECURITIES SB, vw_dfmast_all DF,
        (
                SELECT TXDATE, ACCTNO, SUM(AMT_CREDIT) - SUM(AMT_DEBIT) namt FROM (
                    SELECT TXDATE, ACCTNO, CASE WHEN TXTYPE ='C' THEN NAMT ELSE 0 END AMT_CREDIT,  CASE WHEN TXTYPE ='D' THEN NAMT ELSE 0 END AMT_DEBIT
                        FROM vw_dftran_all v, apptx a WHERE v.txcd = a.txcd and a.apptype ='DF' and tltxcd IN ('2615','2616')
                        AND V.TXDATE = V_I_DATE
                        and field = 'RELEVSDQTTY' and deltd <> 'Y'
                )
                GROUP BY TXDATE, ACCTNO
        ) SE,
    vw_lnmast_all LNM left join cfmast cfb on lnm.custbank = cfb.custid
    WHERE DF.ACTYPE=DFT.ACTYPE AND DF.AFACCTNO = AF.ACCTNO AND AF.CUSTID = CF.CUSTID
    AND DF.LNACCTNO = LNM.ACCTNO AND DF.CODEID = SB.CODEID
    AND DFT.ISVSD='Y'
    and DF.ACCTNO = SE.acctno
    AND CF.CUSTODYCD LIKE v_CUSTODYCD
    AND AF.ACCTNO LIKE v_AFAcctno
    AND df.groupid LIKE V_STRNUM
    AND SB.SYMBOL LIKE V_SYMBOL
    and case when l_BANKNAME = 'ALL' then 1
                when l_BANKNAME = 'MSBS' and LNM.rrtype = 'C' then 1
                when cfB.shortname = l_BANKNAME and LNM.rrtype = 'B' then 1
            else 0 end = 1

    AND case when V_STROPTION = 'A' then 1 else instr(l_BRID_FILTER,substr(AF.ACCTNO,1,4)) end  <> 0


) A WHERE     A. RLSQTTY > 0
GROUP BY SYMBOL,PARVALUE,TRADEPLACE,DEBIT, CREDIT
order by tradeplace, SYMBOL

;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

