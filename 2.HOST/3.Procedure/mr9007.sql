-- Start of DDL Script for Procedure HOSTMSTRADE.MR9007
-- Generated 11/04/2017 3:21:34 PM from HOSTMSTRADE@FLEX_111

CREATE OR REPLACE 
PROCEDURE mr9007 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   pv_OPT            IN       VARCHAR2,
   pv_BRID           IN       VARCHAR2,
   pv_CUSTDYCD       IN       VARCHAR2,
   pv_AFACCTNO       IN       VARCHAR2
)
IS
-- ---------   ------  -------------------------------------------
   V_STROPTION      VARCHAR2 (5);             -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID         VARCHAR2 (5);

   V_CUSTODYCD VARCHAR2(10);
   V_AFACCTNO VARCHAR2(10);
   V_CURRDATE DATE;


-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
   V_STROPTION := upper(pv_OPT);
   V_INBRID := pv_BRID;

   if(V_STROPTION = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := pv_BRID;
        end if;
    end if;

    SELECT TO_DATE(VARVALUE,'DD/MM/RRRR') INTO V_CURRDATE FROM SYSVAR WHERE VARNAME = 'CURRDATE';

    IF pv_CUSTDYCD = 'ALL' THEN
        V_CUSTODYCD := '%%';
    ELSE V_CUSTODYCD := pv_CUSTDYCD;
    END IF;

    IF pv_AFACCTNO = 'ALL' THEN
        V_AFACCTNO := '%%';
    ELSE V_AFACCTNO := pv_AFACCTNO;
    END IF;

  -- GET REPORT'S DATA
    OPEN PV_REFCURSOR FOR

SELECT ci.*, ci.OVD_NO_BL ovd_bl, ci.IN_NO_BL bl, se.GT_CP_sohuu,
    se.GT_CP_sohuu+ci.so_du_tien-ci.no nav, se.ts_nav_1+ci.so_du_tien-ci.no nav_1,
    se.ts_nav_2+ci.so_du_tien-ci.no nav_2, se.ts_nav_3+ci.so_du_tien-ci.no nav_3,
    ts_call, se.ts_nav_1 ts_call_1, se.ts_nav_2 ts_call_2, se.ts_nav_3 ts_call_3, re.broker, re.ppc, V_CURRDATE V_CURRDATE
FROM
(
    select v.afacctno, v.custodycd,
        sum(case when sb.sectype in ('001', '002', '008','011', '111') then v.realass else 0 end) GT_CP_sohuu,
        sum(v.ts_call) ts_call,
/*        sum(case when sb.tradeplace in ('005', '002') then (v.ts_call/decode(v.pricecl,0,1,v.pricecl))*fn_getrefprice(sb.tradeplace,v.pricecl*(1-0.1))
            else (v.ts_call/decode(v.pricecl,0,1,v.pricecl))*fn_getrefprice(sb.tradeplace,v.pricecl*(1-0.07)) end) ts_call_1,
        sum(case when sb.tradeplace in ('005', '002') then (v.ts_call/decode(v.pricecl,0,1,v.pricecl))*fn_getrefprice(sb.tradeplace,v.pricecl*(1-0.1)*(1-0.1))
            else (v.ts_call/decode(v.pricecl,0,1,v.pricecl))*fn_getrefprice(sb.tradeplace,v.pricecl*(1-0.07)*(1-0.07)) end) ts_call_2,
        sum(case when sb.tradeplace in ('005', '002') then (v.ts_call/decode(v.pricecl,0,1,v.pricecl))*fn_getrefprice(sb.tradeplace,v.pricecl*(1-0.1)*(1-0.1)*(1-0.1))
            else (v.ts_call/decode(v.pricecl,0,1,v.pricecl))*fn_getrefprice(sb.tradeplace,v.pricecl*(1-0.07)*(1-0.07)*(1-0.07)) end) ts_call_3,
*/        -------------------------------------
        sum(case when sb.tradeplace in ('005', '002') then (v.realass/decode(se.basicprice,0,1,se.basicprice))*fn_getrefprice(sb.tradeplace,se.basicprice*(1-0.1))
            else (v.realass/decode(se.basicprice,0,1,se.basicprice))*fn_getrefprice(sb.tradeplace,se.basicprice*(1-0.07)) end) ts_nav_1,
        sum(case when sb.tradeplace in ('005', '002') then (v.realass/decode(se.basicprice,0,1,se.basicprice))*fn_getrefprice(sb.tradeplace,se.basicprice*(1-0.1)*(1-0.1))
            else (v.realass/decode(se.basicprice,0,1,se.basicprice))*fn_getrefprice(sb.tradeplace,se.basicprice*(1-0.07)*(1-0.07)) end) ts_nav_2,
        sum(case when sb.tradeplace in ('005', '002') then (v.realass/decode(se.basicprice,0,1,se.basicprice))*fn_getrefprice(sb.tradeplace,se.basicprice*(1-0.1)*(1-0.1)*(1-0.1))
            else (v.realass/decode(se.basicprice,0,1,se.basicprice))*fn_getrefprice(sb.tradeplace,se.basicprice*(1-0.07)*(1-0.07)*(1-0.07)) end) ts_nav_3
    from vw_mr9004 v, sbsecurities sb, securities_info se where v.codeid = sb.codeid AND v.codeid = se.codeid
        AND v.afacctno LIKE V_AFACCTNO
        AND v.custodycd LIKE V_CUSTODYCD
    group by afacctno, custodycd
) se,
(
    select cf.custodycd, cf.custid, cf.fullname , cf.email, nvl(cf.mobile, cf.phone), ci.afacctno,
        sum(nvl(ci.balance,0))  TIEN_MAT, -- tong tien
        sum(nvl(ci.depofeeamt,0)) PHI_LK, --no phi luu ky
        sum(nvl(vlad.depoamt,0)) UTTB,
        sum(nvl(ln.t0amt,0)) NO_BL, -- No bao lanh
        sum(nvl(ln.in_t0amt,0)) IN_NO_BL, -- No bao lanh trong han
        sum(nvl(ln.ovd_t0amt,0)) OVD_NO_BL, -- No bao lanh qua han
        sum(nvl(marginamt,0)) NO_CL, -- no CL
        sum(nvl(ci.balance,0)) +  sum(nvl(vlad.depoamt,0)) - sum(NVL(v_getbuy.secureamt,0)) /*+ sum(nvl(vlad.aamt,0))*/ SO_DU_TIEN,
        sum(nvl(ci.depofeeamt,0)) + sum(nvl(ln.t0amt,0)) + sum(nvl(marginamt,0)) /*+ sum(nvl(adv.amt,0))*/ NO --bo no UTTB
    from cimast ci, v_getaccountavladvance vlad , vw_lngroup_all ln, cfmast cf, afmast af, v_getbuyorderinfo v_getbuy,
    ( --du no UTTB
        SELECT  ACCTNO,
            SUM(NVL(ADS.AMT, 0) + NVL(ADS.FEEAMT, 0)- (case when V_CURRDATE >= ads.cleardt then ads.paidamt else 0 end)) AMT
        FROM VW_ADSCHD_ALL ADS
        WHERE (ADS.AMT > 0 OR ADS.PAIDDATE = V_CURRDATE ) --V_CRRDATE
            AND ADS.txdate <= V_CURRDATE
        GROUP  BY  ACCTNO
    ) adv
    where ci.afacctno = vlad.afacctno (+)
        and ci.afacctno = ln.trfacctno (+)
        and ci.afacctno = adv.acctno (+)
        and ci.afacctno = v_getbuy.afacctno (+)
        AND ci.afacctno LIKE V_AFACCTNO
        AND cf.custodycd LIKE V_CUSTODYCD
        and af.custid = cf.custid  and ci.afacctno = af.acctno
        --and  EXISTS (SELECT GU.GRPID FROM TLGRPUSERS GU WHERE af.CAREBY = GU.GRPID AND GU.TLID = PV_TLID)
    group by  cf.custodycd, cf.custid, cf.fullname , cf.email, nvl(cf.mobile, cf.phone), ci.afacctno
)ci,
(
    SELECT af.afacctno, af.broker, gf.ppc
    FROM
    (
        SELECT af.*, c.fullname broker
        FROM reaflnk af, recflnk rf, cfmast c, retype re
        WHERE af.refrecflnkid = rf.autoid AND rf.custid = c.custid
        AND substr(af.reacctno,11,4) = re.actype AND re.rerole IN ('RM','BM')
            AND af.frdate <= V_CURRDATE AND nvl(af.clstxdate,af.todate-1) >= V_CURRDATE
    ) af,
    (
        SELECT gf.*, rg.fullname ppc
        FROM regrplnk gf, regrp rg
        WHERE gf.refrecflnkid = rg.autoid
            AND gf.frdate <= V_CURRDATE AND nvl(gf.clstxdate,gf.todate-1) >= V_CURRDATE
    ) gf
    WHERE af.reacctno = gf.reacctno(+)
) re
WHERE se.afacctno = ci.afacctno
    AND se.afacctno = re.afacctno(+)
    AND ci.so_du_tien + ci.no + se.GT_CP_sohuu <> 0
ORDER BY ci.custodycd, ci.afacctno
;
 EXCEPTION
   WHEN OTHERS
   THEN
        RETURN;
END;
/



-- End of DDL Script for Procedure HOSTMSTRADE.MR9007

