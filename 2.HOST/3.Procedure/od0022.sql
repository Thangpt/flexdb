CREATE OR REPLACE PROCEDURE od0022(
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   PV_CUSTODYCD      in       varchar2,
   TYPEDATE      IN       VARCHAR2,
   SYMBOL         IN       VARCHAR2,
   PV_TRADEPLACE IN VARCHAR2,
   PV_CLEARDAY in number

  )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- NAMNT   21-NOV-06  CREATED
-- ---------   ------  -------------------------------------------
    V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID          VARCHAR2 (40);    -- USED WHEN V_NUMOPTION > 0
    V_INBRID     VARCHAR2 (5);
    V_STRSYMBOL        VARCHAR2(10);
    V_CUSTODYCD      VARCHAR2(20);
    V_TYPEDATE     VARCHAR2(4);
    v_OnDate date;
    v_TradePlace varchar2(20);
    v_Clearday number(10);

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

    -- GET REPORT'S PARAMETERS
    v_OnDate := to_date(I_DATE,'DD/MM/RRRR');
    V_CUSTODYCD := replace (upper(PV_CUSTODYCD),'.','');
    V_STRSYMBOL := replace (upper(SYMBOL),'.','');
    v_TradePlace := PV_TRADEPLACE;

    IF  (PV_CUSTODYCD <> 'ALL') THEN
        V_CUSTODYCD := PV_CUSTODYCD;
    ELSE
        V_CUSTODYCD := '%';
    END IF;

    IF  (SYMBOL <> 'ALL') THEN
        V_STRSYMBOL := V_STRSYMBOL;
    ELSE
        V_STRSYMBOL := '%';
    END IF;

    IF  (v_TradePlace <> 'ALL') THEN
        v_TradePlace := v_TradePlace;
    ELSE
        v_TradePlace := '%';
    END IF;


    V_TYPEDATE := TYPEDATE;

    v_Clearday := PV_CLEARDAY;

IF  V_TYPEDATE ='001'   THEN    -- Ngay giao dich

    OPEN PV_REFCURSOR FOR
    SELECT V_TYPEDATE TYPEDATE, SETTDATE,CF.CUSTODYCD, SYMBOL, CF.FULLNAME, TRADATE, TRADEPLACE, cdcontent TRADEPLACE_NAME,
        NVL(D_BAMT,0) D_BAMT,       -- TU DOANH: MUA
        NVL(D_SAMT,0) D_SAMT,       -- TU DOANH: BAN
        NVL(BD_BAMT,0) BD_BAMT,     -- TRONG NUOC: MUA
        NVL(BD_SAMT,0) BD_SAMT,     -- TRUONG NUOC: BAN
        NVL(BF_BAMT,0) BF_BAMT,     -- NUOC NGOAI: MUA
        NVL(BF_SAMT,0) BF_SAMT      -- NUOC NGOAI: BAN

    FROM CFMAST CF, allcode cd ,
    (
        -- Tu Doanh
        SELECT af.custid, cleardate SETTDATE, CHD.TXDATE TRADATE,SB.symbol,chd.tradeplace,
            SUM(CHD.QTTY) D_BAMT,     -- Nhan CK
            0 D_SAMT,     -- Giao CK
            0 BD_BAMT,          --
            0 BD_SAMT,
            0 BF_BAMT,
            0 BF_SAMT
        FROM vw_stschd_tradeplace_all CHD, CFMAST CF, AFMAST AF, SBSECURITIES SB--, SEMAST SE
        WHERE CF.CUSTID = AF.CUSTID AND AF.ACCTNO = CHD.AFACCTNO AND SB.CODEID = CHD.CODEID
            --AND CHD.ACCTNO = SE.ACCTNO
            AND CHD.DUETYPE = 'RS' AND substr(CF.CUSTODYCD,4,1)= 'P' AND cf.custatcom='Y'
            AND CF.CUSTODYCD LIKE V_CUSTODYCD AND SB.SYMBOL LIKE V_STRSYMBOL
            AND CHD.TXDATE = v_OnDate
            AND chd.TRADEPLACE LIKE v_TradePlace
            AND CHD.CLEARDAY = v_Clearday
        GROUP BY af.custid, cleardate, CHD.TXDATE, SB.symbol, chd.tradeplace

        union all
        SELECT af.custid, cleardate SETTDATE, CHD.TXDATE TRADATE,SB.symbol,chd.tradeplace,
            0 D_BAMT,     -- Nhan CK
            SUM(CHD.QTTY) D_SAMT,     -- Giao CK
            0 BD_BAMT,          --
            0 BD_SAMT,
            0 BF_BAMT,
            0 BF_SAMT
        FROM vw_stschd_tradeplace_all CHD, CFMAST CF, AFMAST AF, SBSECURITIES SB--, SEMAST SE
        WHERE CF.CUSTID = AF.CUSTID AND AF.ACCTNO = CHD.AFACCTNO AND SB.CODEID = CHD.CODEID
            --AND CHD.AFACCTNO || CHD.CODEID = SE.ACCTNO
            AND CHD.DUETYPE = 'RM' AND   substr(CF.CUSTODYCD,4,1)= 'P' AND cf.custatcom='Y'
            AND CF.CUSTODYCD LIKE V_CUSTODYCD AND SB.SYMBOL LIKE V_STRSYMBOL
            AND CHD.TXDATE = v_OnDate
            AND chd.tradeplace LIKE v_TradePlace
            AND CHD.CLEARDAY = v_Clearday
        GROUP BY af.custid, cleardate, CHD.TXDATE, SB.symbol, chd.tradeplace

        -- Trong nuoc
        UNION ALL
        ----- Trong nuoc: mua ck
        SELECT af.custid, CLEARDATE SETTDATE, CHD.TXDATE TRADATE,SB.symbol,chd.tradeplace,
            0 D_BAMT,
            0 D_SAMT,
            SUM(CHD.QTTY) BD_BAMT,
            0 BD_SAMT,
            0 BF_BAMT,
            0 BF_SAMT
        FROM vw_stschd_tradeplace_all CHD, CFMAST CF, AFMAST AF, SBSECURITIES SB--, SEMAST SE
        WHERE CF.CUSTID = AF.CUSTID AND AF.ACCTNO = CHD.AFACCTNO AND SB.CODEID = CHD.CODEID
            --AND CHD.ACCTNO = SE.ACCTNO
            AND CHD.DUETYPE = 'RS' AND substr(CF.CUSTODYCD,4,1)= 'C' AND cf.custatcom='Y'
            AND CF.CUSTODYCD LIKE V_CUSTODYCD AND SB.SYMBOL LIKE V_STRSYMBOL
            AND CHD.TXDATE = v_OnDate
            AND chd.tradeplace LIKE v_TradePlace
            AND CHD.CLEARDAY = v_Clearday
        GROUP BY af.custid, CLEARDATE, CHD.TXDATE, SB.symbol, chd.tradeplace

        ----- Trong nuoc: ban ck
        UNION ALL
        SELECT af.custid, CLEARDATE SETTDATE, CHD.TXDATE TRADATE,SB.symbol,chd.tradeplace,
            0 D_BAMT,
            0 D_SAMT,
            0 BD_BAMT,
            SUM(CHD.QTTY) BD_SAMT,
            0 BF_BAMT,
            0 BF_SAMT
        FROM vw_stschd_tradeplace_all CHD, CFMAST CF, AFMAST AF, SBSECURITIES SB--, SEMAST SE
        WHERE CF.CUSTID = AF.CUSTID AND AF.ACCTNO = CHD.AFACCTNO AND SB.CODEID = CHD.CODEID
            --AND CHD.AFACCTNO || CHD.CODEID = SE.ACCTNO
            AND CHD.DUETYPE = 'RM'  AND substr(CF.CUSTODYCD,4,1)= 'C' AND cf.custatcom='Y'
            AND CF.CUSTODYCD LIKE V_CUSTODYCD AND SB.SYMBOL LIKE V_STRSYMBOL
            AND CHD.TXDATE = v_OnDate
            AND chd.tradeplace LIKE v_TradePlace
            AND CHD.CLEARDAY = v_Clearday
        GROUP BY af.custid, CLEARDATE, CHD.TXDATE, SB.symbol, chd.tradeplace

        -- Nuoc ngoai
        UNION ALL
        --------- Nuoc ngoai: Mua ck
        SELECT af.custid, CLEARDATE SETTDATE, CHD.TXDATE TRADATE,SB.symbol,chd.tradeplace,
            0 D_BAMT,
            0 D_SAMT,
            0 BD_BAMT,
            0 BD_SAMT,
            SUM(CHD.QTTY) BF_BAMT,
            0 BF_SAMT
        FROM vw_stschd_tradeplace_all CHD, CFMAST CF, AFMAST AF, SBSECURITIES SB--, SEMAST SE
        WHERE CF.CUSTID = AF.CUSTID AND AF.ACCTNO = CHD.AFACCTNO AND SB.CODEID = CHD.CODEID
            --AND CHD.ACCTNO = SE.ACCTNO
            AND CHD.DUETYPE = 'RS'  AND substr(CF.CUSTODYCD,4,1)= 'F' AND cf.custatcom='Y'
            AND CF.CUSTODYCD LIKE V_CUSTODYCD AND SB.SYMBOL LIKE V_STRSYMBOL
            AND CHD.TXDATE = v_OnDate
            AND chd.tradeplace LIKE v_TradePlace
            AND CHD.CLEARDAY = v_Clearday
        GROUP BY af.custid, CLEARDATE, CHD.TXDATE, SB.symbol, chd.tradeplace

        --------- Nuoc ngoai: Ban ck
        UNION ALL
        SELECT af.custid, CLEARDATE SETTDATE, CHD.TXDATE TRADATE,SB.symbol,chd.tradeplace,
            0 D_BAMT,
            0 D_SAMT,
            0 BD_BAMT,
            0 BD_SAMT,
            0 BF_BAMT,
            SUM(CHD.QTTY) BF_SAMT
        FROM vw_stschd_tradeplace_all CHD, CFMAST CF, AFMAST AF, SBSECURITIES SB--, SEMAST SE
        WHERE CF.CUSTID = AF.CUSTID AND AF.ACCTNO = CHD.AFACCTNO AND SB.CODEID = CHD.CODEID
            --AND CHD.AFACCTNO || CHD.CODEID = SE.ACCTNO
            AND CHD.DUETYPE = 'RM'  AND substr(CF.CUSTODYCD,4,1)= 'F' AND cf.custatcom='Y'
            AND CF.CUSTODYCD LIKE V_CUSTODYCD AND SB.SYMBOL LIKE V_STRSYMBOL
            AND CHD.TXDATE = v_OnDate
            AND chd.tradeplace LIKE v_TradePlace
            AND CHD.CLEARDAY = v_Clearday
        GROUP BY af.custid, CLEARDATE, CHD.TXDATE, SB.symbol, chd.tradeplace
    ) A
    WHERE CF.CUSTID = A.CUSTID and cdtype = 'OD' and cdname = 'TRADEPLACE' and a.tradeplace = cd.cdval
    AND (substr(CF.CUSTID,1,4) LIKE V_STRBRID OR instr(V_STRBRID,substr(CF.CUSTID,1,4))<> 0)
    order  by TRADATE;


ELSE    -- Ngay thanh toan
    OPEN PV_REFCURSOR FOR
    SELECT V_TYPEDATE TYPEDATE,  SETTDATE,CF.CUSTODYCD, symbol, CF.FULLNAME, TRADATE, tradeplace, cdcontent tradeplace_name,
        NVL(D_BAMT,0)   D_BAMT,
        NVL(D_SAMT,0)   D_SAMT,
        NVL(BD_BAMT,0)  BD_BAMT,
        NVL(BD_SAMT,0)  BD_SAMT,
        NVL(BF_BAMT,0)  BF_BAMT,
        NVL(BF_SAMT,0)  BF_SAMT
    FROM CFMAST CF, allcode cd,
    (
        -- TU DOANH
        SELECT CF.CUSTID, GETDUEDATE(CHD.TXDATE,'B','001',OD.CLEARDAY) SETTDATE, CHD.TXDATE TRADATE, SB.symbol ,chd.tradeplace,
            SUM(DECODE(CHD.DUETYPE, 'RS', CHD.QTTY, 0)) D_BAMT,
            SUM(DECODE(CHD.DUETYPE, 'SS', CHD.QTTY, 0)) D_SAMT,
            0 BD_BAMT,
            0 BD_SAMT,
            0 BF_BAMT,
            0 BF_SAMT
        FROM vw_stschd_tradeplace_all CHD, AFMAST AF, CFMAST CF,SBSECURITIES SB, --SEMAST SE,
        vw_odmast_all OD
        WHERE CF.CUSTID = AF.CUSTID AND AF.ACCTNO = CHD.AFACCTNO
            --AND CHD.ACCTNO = SE.ACCTNO
            AND CHD.ORGORDERID = OD.ORDERID
            AND SB.CODEID = CHD.CODEID
            AND CHD.DUETYPE IN ('RS', 'RS')  AND substr(CF.CUSTODYCD,4,1)= 'P' AND cf.custatcom='Y'   -- tu doanh
            AND CF.CUSTODYCD LIKE V_CUSTODYCD AND SB.SYMBOL LIKE V_STRSYMBOL
            AND GETDUEDATE(CHD.TXDATE,'B','001',CHD.CLEARDAY) = v_OnDate
            AND chd.tradeplace LIKE v_TradePlace
            AND OD.CLEARDAY = v_Clearday
        GROUP BY CF.CUSTID, GETDUEDATE(CHD.TXDATE,'B','001',OD.CLEARDAY), CHD.TXDATE, SB.symbol ,chd.tradeplace

        -- TRONG NUOC
        UNION ALL
        SELECT CF.CUSTID, GETDUEDATE(CHD.TXDATE,'B','001',OD.CLEARDAY) SETTDATE, CHD.TXDATE TRADATE, SB.symbol ,chd.tradeplace,
            SUM(DECODE(CHD.DUETYPE, 'RS', CHD.QTTY, 0)) D_BAMT,
            SUM(DECODE(CHD.DUETYPE, 'SS', CHD.QTTY, 0)) D_SAMT,
            0 BD_BAMT,
            0 BD_SAMT,
            0 BF_BAMT,
            0 BF_SAMT
        FROM vw_stschd_tradeplace_all CHD, AFMAST AF, CFMAST CF,SBSECURITIES SB, --SEMAST SE,
        vw_odmast_all OD
        WHERE CF.CUSTID = AF.CUSTID AND AF.ACCTNO = CHD.AFACCTNO
            --AND CHD.ACCTNO = SE.ACCTNO
            AND CHD.ORGORDERID = OD.ORDERID
            AND SB.CODEID = CHD.CODEID
            AND CHD.DUETYPE IN ('RS', 'RS')  AND substr(CF.CUSTODYCD,4,1)= 'C' AND cf.custatcom='Y'      -- trong nuoc
            AND CF.CUSTODYCD LIKE V_CUSTODYCD AND SB.SYMBOL LIKE V_STRSYMBOL
            AND GETDUEDATE(CHD.TXDATE,'B','001',CHD.CLEARDAY) = v_OnDate
            AND chd.tradeplace LIKE v_TradePlace
            AND OD.CLEARDAY = v_Clearday
        GROUP BY CF.CUSTID, GETDUEDATE(CHD.TXDATE,'B','001',OD.CLEARDAY), CHD.TXDATE, SB.symbol ,chd.tradeplace

        -- NUOC NGOAI
        UNION ALL
        SELECT CF.CUSTID, GETDUEDATE(CHD.TXDATE,'B','001',OD.CLEARDAY) SETTDATE, CHD.TXDATE TRADATE, SB.symbol ,chd.tradeplace,
            SUM(DECODE(CHD.DUETYPE, 'RS', CHD.QTTY, 0)) D_BAMT,
            SUM(DECODE(CHD.DUETYPE, 'SS', CHD.QTTY, 0)) D_SAMT,
            0 BD_BAMT,
            0 BD_SAMT,
            0 BF_BAMT,
            0 BF_SAMT
        FROM vw_stschd_tradeplace_all CHD, AFMAST AF, CFMAST CF,SBSECURITIES SB, --SEMAST SE,
        vw_odmast_all OD
        WHERE CF.CUSTID = AF.CUSTID AND AF.ACCTNO = CHD.AFACCTNO
            --AND CHD.ACCTNO = SE.ACCTNO
            AND CHD.ORGORDERID = OD.ORDERID
            AND SB.CODEID = CHD.CODEID
            AND CHD.DUETYPE IN ('RS', 'RS')  AND substr(CF.CUSTODYCD,4,1)= 'F' AND cf.custatcom='Y'      -- nuoc ngoai
            AND CF.CUSTODYCD LIKE V_CUSTODYCD AND SB.SYMBOL LIKE V_STRSYMBOL
            AND GETDUEDATE(CHD.TXDATE,'B','001',CHD.CLEARDAY) = v_OnDate
            AND chd.tradeplace LIKE v_TradePlace
            AND OD.CLEARDAY = v_Clearday
        GROUP BY CF.CUSTID, GETDUEDATE(CHD.TXDATE,'B','001',OD.CLEARDAY), CHD.TXDATE, SB.symbol ,chd.tradeplace
    ) B
    WHERE CF.CUSTID = B.CUSTID and cdtype = 'OD' and cdname = 'TRADEPLACE' and b.tradeplace = cd.cdval
    AND (substr(CF.CUSTID,1,4) LIKE V_STRBRID OR instr(V_STRBRID,substr(CF.CUSTID,1,4))<> 0)
    order by TRADATE;

END IF;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

