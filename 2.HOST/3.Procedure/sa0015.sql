CREATE OR REPLACE PROCEDURE sa0015 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   pv_OPT            IN       VARCHAR2,
   pv_BRID           IN       VARCHAR2,
   I_DATE            IN       VARCHAR2
)
IS
-- ---------   ------  -------------------------------------------
    V_STROPTION   VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID       VARCHAR2 (5);
   V_CurrDate        DATE;
   v_idate          DATE;
   v_coutdate     number;

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

    -- select to_date(varvalue,'DD/MM/RRRR') into v_CurrDate from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM';
     v_Idate := to_date(I_DATE,'DD/MM/RRRR');


 SELECT COUNT(*) INTO v_coutdate  from  sbcldr where cldrtype ='001' and holiday ='N' AND sbdate < v_Idate AND sbdate>= TRUNC(v_idate, 'month');



-- GET REPORT'S DATA
OPEN PV_REFCURSOR for

SELECT
v_Idate i_date,  v_coutdate coutdate,  RE.BRID,MIEN, ten_nhom , ma_nhom, giam_doc, round ( NVL(sum(ilog.balance),0)/1000000000,2) balance,round( NVL( sum(ilog.balancen),0)/1000000000,2) balancen, round(NVL( sum(ilog.mramt)/1000000000,0),2) mramt
,round( NVL( sum(ilog.mramttopup),0)/1000000000,2) mramttopup,round(NVL( sum(ilog. adamt),0)/1000000000,2) adamt,
round(NVL( sum(ilog.adfee),0)/1000000,2)  adfee,round(NVL( sum(ilog.mrint),0)/1000000,2 ) mrint,round(NVL( sum(ilog.mrinttopup),0)/1000000,2)  mrinttopup
, round(NVL( sum(ilog.payint),0)/1000000,2)  payint, round(NVL( sum(ilog.payinttopup),0)/1000000,2)  payinttopup,
round(NVL(sum(mlog.balance),0)/1000000000,2) mbalance, round(NVL( sum(mlog.balancen),0)/1000000000,2) mbalancen,round(NVL( sum(mlog.mramt),0)/1000000000,2)  mmramt, round(NVL(sum(mlog.mramttopup),0)/1000000000,2) mmramttopup,round(NVL( sum(mlog.adamt),0)/1000000000,2)  madamt,
round(NVL( sum(mlog.adfee),0)/1000000,2)  madfee,round(NVL( sum(mlog.mrint),0)/1000000,2)  mmrint, round(NVL( sum(mlog.mrinttopup),0)/1000000,2)  mmrinttopup
, round(NVL( sum(mlog.payint),0)/1000000,2)  mpayint, round(NVL( sum(mlog.payinttopup),0)/1000000,2)  mpayinttopup
FROM
    ( select  g.autoid, g.custid, g.fullname ten_nhom, g.autoid ma_nhom, cf.fullname giam_doc, substr(g.custid,1,4) BRID, substr(g.custid,1,2) MIEN
                   , a.afacctno , g.effdate, g.expdate, d.effdate d_effdate, nvl(d.closedate - 1, d.expdate) d_expdate, a.frdate a_frdate, nvl(a.clstxdate - 1, a.todate) a_todate

               from  recflnk c, recfdef d, (select * from regrp union all select * from regrphist) g
                   , regrplnk l, cfmast cf
                   , (select a.reacctno, a.frdate, a.todate, a.clstxdate, a.afacctno from  reaflnk a) a,retype rt
               where g.autoid = l.refrecflnkid and l.reacctno = a.reacctno and g.custid = cf.custid
               and c.autoid = d.refrecflnkid and substr(a.reacctno,1,10) = c.custid and substr(a.reacctno,11,4) = d.reactype
                and a.frdate <= v_Idate and nvl(a.clstxdate -1, a.todate) >= v_Idate
               and d.effdate <= v_Idate and nvl(d.closedate -1, d.expdate) >= V_iDATE
               and l.frdate <=v_Idate and nvl(l.clstxdate -1 , l.todate) >= v_Idate
               and g.effdate <= v_Idate and g.expdate >= v_Idate
                and rt.actype = substr(a.reacctno,11,4)
                and   RT.REROLE IN ('BM','RM')
             --  and (substr(g.custid,1,4) LIKE V_STRBRID OR instr(V_STRBRID,substr(g.custid,1,4))<> 0)

               ) re,
               ( select * from log_sa0015  where txdate = v_idate ) ilog,
               ( select afacctno, sum (balance) balance,sum(balancen)  balancen, sum (mramt) mramt ,sum(mramttopup) mramttopup,sum(adamt) adamt,
                 sum(adfee) adfee,sum(mrint) mrint,sum(mrinttopup) mrinttopup,sum(payint) payint,sum(payinttopup) payinttopup
                    from log_sa0015
                     where txdate <= v_idate and txdate >= TRUNC(v_idate, 'month')
                    group by afacctno)  mlog,afmast af,cfmast cf
               where re.afacctno = ilog.afacctno (+)
               and re.afacctno = mlog.afacctno (+)
               and re.afacctno = af.acctno
               and af.custid = cf.custid
               and cf.custatcom ='Y'
               and af.corebank ='N'
        group by    ten_nhom , ma_nhom, giam_doc, RE.BRID,MIEN

;


 EXCEPTION
   WHEN OTHERS
   THEN
        RETURN;
END;
/

