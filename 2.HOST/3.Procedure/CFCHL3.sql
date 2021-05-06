CREATE OR REPLACE PROCEDURE "CFCHL3" (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE                   IN       VARCHAR2,
   T_DATE                   IN       VARCHAR2,
   PV_CUSTODYCD     IN       VARCHAR2,
   ACTYPE       in       varchar2,
   CAREBY       IN       VARCHAR2,
   I_BRID       IN       VARCHAR2,
   TLID IN VARCHAR2

----   p_SIGNTYPE               IN       VARCHAR2
   )
IS
    V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (4);
    N                NUMBER;
     V_FDATE             DATE;
   V_TDATE             DATE;
   b_idate date;
    v_custodycd varchar2(20);
   v_actype     varchar2 (4);
    v_careby varchar2(4);
   v_brid varchar2(4);
   v_TLID varchar2(4);

BEGIN

     V_STROPTION := OPT;


   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;
    -- TO_DATE(F_DATE,'DD/MM/YYYY')
    V_FDATE              :=    TO_DATE(F_DATE, 'DD/MM/YYYY');
    V_TDATE              :=    TO_DATE(T_DATE, 'DD/MM/YYYY');
select V_TDATE - V_FDATE +1 into n from dual;
V_ACTYPE :=ACTYPE;
 v_TLID := TLID;

IF PV_CUSTODYCD ='ALL' THEN
        v_custodycd :='%%';
    ELSE
        v_custodycd := PV_CUSTODYCD;
    END IF;

    IF CAREBY='ALL' THEN
        v_careby :='%%';
    ELSE
        v_careby := CAREBY;
    END IF;

    IF I_BRID='ALL' THEN
        v_brid :='%%';
    ELSE
        v_brid := I_BRID;
    END IF;

 select max(bchdate) into B_IDATE
  from sbbatchsts ;

OPEN PV_REFCURSOR
FOR


select V_FDATE tu_ngay,V_TDATE den_ngay, AF.ACTYPE,cf.opndate OPNCUST, CF.CUSTODYCD, CF.FULLNAME CUSTNAME, CF.BRID,CF.EMAIL,RE.refullname,RE.REID,aF.acctno,sum(nvl(NAV_lk,0))NAV_lk,sum(nvl(NAV_lk_ck,0))NAV_lk_ck,sum(nvl(NAVBQ,0))NAVBQ,
 sum(nvl(ODEXECAMT,0))ODEXECAMT, sum(nvl(MRAMT,0))MRAMT,sum(nvl(PT_amt,0))PT_amt,sum(nvl(tranf_symbol,0))tranf_symbol, sum(nvl(withd_amt,0))withd_amt, brg.brname
 from  cfmast cf ,BRGRP brg,afmast af
LEFT JOIN (
--Lay từ ngày đến ngày
select afacctno, sum(ROUND((case when (nav_1 + depo_amt)<>0 then 100*(nav-nav_1 -depo_amt)/(nav_1 + depo_amt) else 0 end),3)) NAV_lk,0 NAV_lk_ck,0 NAVBQ, 0 ODEXECAMT, 0 MRAMT,0  PT_amt,0 tranf_symbol, 0 withd_amt
FROM
(
select  afacctno,txdate, sum(nav_1) nav_1,  sum(nav) nav,  sum(nav_1_Ck) nav_1_Ck, sum(NAV_CK) NAV_CK, sum(ODEXECAMT) ODEXECAMT, sum(MRAMT) MRAMT,sum(depo_amt) depo_amt
from
(
select  afacctno, lo.txdate, nav_1 nav_1, NAV nav ,0 nav_1_Ck, 0 NAV_CK, 0 ODEXECAMT, 0 MRAMT,0 depo_amt
from vw_log_sa0015 lo, afmast af
where af.acctno =lo.afacctno and af.actype = V_ACTYPE and  lo.custodycd like v_custodycd and lo.txdate  between V_FDATE and V_TDATE
union all
select af.acctno, v.txdate, 0 nav_1,0 NAV,0 nav_1_Ck, 0 NAV_CK,0 ODEXECAMT,0 MRAMT,sum(nvl(namt,0)+ nvl(camt,0)) depo_amt from vw_citran_gen v , afmast af
where af.acctno =v.acctno
and af.actype =V_ACTYPE and  field='BALANCE' and txtype='C'
and tltxcd in ( '1131','1141','1198','1120')
and v.custodycd like v_custodycd
and txdate   between V_FDATE and V_TDATE
group by af.acctno, v.txdate
) group by afacctno, txdate
 ) GROUP BY AFACCTNO
union all
-- Vong chung cuoc
select afacctno, 0 NAV_lk,sum(ROUND((case when (nav_1_ck + depo_amt)<>0 then 100*(nav_ck-nav_1_ck -depo_amt)/(nav_1_ck + depo_amt) else 0 end),3))  NAV_lk_ck,ROUND(SUM(NAV_CK)/183,0) NAVBQ,
ROUND(SUM(ODEXECAMT),0) ODEXECAMT, ROUND(SUM(MRAMT)/183,0) MRAMT,0  PT_amt,0 tranf_symbol, 0 withd_amt
FROM
(
select  afacctno,txdate, sum(nav_1) nav_1,  sum(nav) nav,  sum(nav_1_Ck) nav_1_Ck, sum(NAV_CK) NAV_CK, sum(ODEXECAMT) ODEXECAMT, sum(MRAMT) MRAMT,sum(depo_amt) depo_amt
from
(
select  afacctno, lo.txdate,0 nav_1, 0 nav, nav_1 nav_1_Ck, nav NAV_CK, ODEXECAMT, MRAMT,0 depo_amt from vw_log_sa0015 lo, afmast af
where af.acctno =lo.afacctno and af.actype = V_ACTYPE and lo.custodycd like v_custodycd and  lo.txdate between '02-mar-2020' and B_IDATE                 --between V_FDATE and V_TDATE
union all
select af.acctno, v.txdate,0 nav_1, 0 nav, 0 nav_1_Ck,0 NAV_CK,0 ODEXECAMT,0 MRAMT,sum(nvl(namt,0)+ nvl(camt,0)) depo_amt from vw_citran_gen v , afmast af
where af.acctno =v.acctno
and af.actype =V_ACTYPE and  field='BALANCE' and txtype='C'
and tltxcd in ( '1131','1141','1198','1120')
and v.custodycd like v_custodycd
and txdate    between  '02-mar-2020' and B_IDATE
group by af.acctno, v.txdate
)
group by afacctno,txdate)
GROUP BY AFACCTNO
union all
select afacctno, 0 NAV_lk,0 NAV_lk_ck,0 NAVBQ, 0 ODEXECAMT, 0 MRAMT,sum(execamt)  PT_amt,0 tranf_symbol, 0 withd_amt  from VW_ODMAST_ALL od
where od.MATCHTYPE ='P' and od.txdate   between V_FDATE and V_TDATE
group by afacctno
-- CK chuy?n
union all
select afacctno, 0 NAV_lk,0 NAV_lk_ck,0 NAVBQ, 0 ODEXECAMT, 0 MRAMT,0  PT_amt,sum(nvl(namt,0)+ nvl(camt,0))  tranf_symbol, 0 withd_amt
from vw_setran_gen
where txdate  between V_FDATE and V_TDATE
and tltxcd in ('2242', '2200'  ,'2242', '2246', '2245'  )
and field ='TRADE'
 group by afacctno
 -- Ti?n m?t rút
 union all
select acctno, 0 NAV_lk,0 NAV_lk_ck,0 NAVBQ, 0 ODEXECAMT, 0 MRAMT,0  PT_amt,0 tranf_symbol, sum (nvl(vw_ci1.namt,0)+ nvl(vw_ci1.camt,0))  withd_amt
  from vw_citran_gen vw_ci1
  where txdate   between V_FDATE and V_TDATE
  and vw_ci1.tltxcd in ('1101','1111','1118','1120','1129','1132','1133','1184','1185','1188','1199','1130')
   and vw_ci1.field='BALANCE' and vw_ci1.txtype='D'
   group by acctno) A ON AF.ACCTNO =A.AFACCTNO
 LEFT JOIN
 (
 select re.afacctno, MAX(cf.fullname) refullname, MAX (substr(re.reacctno,1,10)) reid
    from reaflnk re, sysvar sys, cfmast cf, retype
    where to_date(varvalue,'DD/MM/RRRR') between re.frdate and re.todate
        and substr(re.reacctno,0,10) = cf.custid
        and varname = 'CURRDATE' and grname = 'SYSTEM'
        and re.status <> 'C' and re.deltd <> 'Y'
        AND substr(re.reacctno,11) = retype.actype
        AND rerole IN ( 'RM','BM')
    GROUP BY afacctno) re on af.acctno =re.afacctno
    --left join BRGRP brg on brg.brid =af.brid
    where cf.custid =af.custid
    and cf.brid=brg.brid
    AND AF.ACTYPE =V_ACTYPE
 and cf.brid like v_brid
and cf.custodycd like v_custodycd
and af.careby like v_careby
and  exists (select gu.grpid from tlgrpusers gu where af.careby = gu.grpid and gu.tlid = v_TLID )

   group by cf.opndate , CF.CUSTODYCD, CF.FULLNAME , CF.BRID,CF.EMAIL,RE.refullname,RE.REID,AF.acctno,AF.ACTYPE,brg.brname;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
