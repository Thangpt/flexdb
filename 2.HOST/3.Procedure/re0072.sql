-- Start of DDL Script for Procedure RE0072
-- Generated 16/09/2020 5:42:19 PM from HOSTUAT@FLEXUAT

CREATE OR REPLACE 
PROCEDURE re0072 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   -- P_FREEORAMOUNT     in      varchar2,
    O_DATE           in      varchar2,
    PV_RECUSTID        in      varchar2,
    --F_AMOUNT         in      varchar2,
    --T_AMOUNT         in      varchar2,
    --C_DATE           in      varchar2,
    PV_REGRPID      IN        VARCHAR2,
    PV_TLID         in      varchar2
 )
IS

    V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID          VARCHAR2 (40);    -- USED WHEN V_NUMOPTION > 0
    V_INBRID     VARCHAR2 (5);
    V_CUSTODYCD varchar2(10);
    I_DATE      date;
    I_CURRDATE      date;
    V_RECUSTID varchar(10);
    V_REGRPID  varchar(10);
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

   SELECT to_date(varvalue, 'DD/MM/RRRR') into I_CURRDATE from sysvar where varname = 'CURRDATE';
   I_DATE :=   to_date(O_DATE, 'DD/MM/RRRR');



   if (PV_RECUSTID <> 'ALL')
   then
        V_RECUSTID := PV_RECUSTID;
   else
        V_RECUSTID := '%';
   end if;

   if (PV_REGRPID <> 'ALL')
   then
        V_REGRPID := PV_REGRPID;
   else
        V_REGRPID := '%';
   end if;
   ------------------------------

IF I_DATE = I_CURRDATE THEN
OPEN PV_REFCURSOR FOR
select  ci.*, nvl(se.GT_CP_sohuu,0) GT_CP_sohuu    --KB hotfix 20200831 loi ko co CK ko len bao cao
    , nvl(re.refullname,'') nv_quanly
    , nvl(re.autoid,'') ma_nhom, nvl(re.fullname,'KH Tu Do') ten_nhom
    , I_DATE ngay_tra_cuu from
(
select v.afacctno, v.custodycd
    , sum(case when sb.sectype in ('001', '002', '008', '111', '011') then v.realass else 0 end) GT_CP_sohuu
    --, sum(REALASS) GT_CP_sohuu--sum(ts_t2) GT_CP_sohuu
from vw_mr9004 v, sbsecurities sb where v.codeid = sb.codeid group by afacctno, custodycd
) se,
 (
 select cf.custodycd, cf.brid custid, cf.fullname , cf.email, nvl(cf.mobile, cf.phone), ci.afacctno,
        sum(nvl(ci.balance,0))  TIEN_MAT, -- tong tien
        sum(nvl(ci.depofeeamt,0)) PHI_LK, --no phi luu ky
         sum(nvl(vlad.depoamt,0)) UTTB,
         sum(nvl(ln.t0amt,0)) NO_BL, -- No bao lanh
         sum(nvl(marginamt,0)) NO_CL, -- no CL
         sum(nvl(ci.balance,0)) +  sum(nvl(vlad.depoamt,0)) - sum(NVL(v_getbuy.secureamt,0)) /*+ sum(nvl(vlad.aamt,0)) + sum(nvl(adv.amt,0))*/ SO_DU_TIEN,
          /*sum(nvl(ci.depofeeamt,0)) + */sum(nvl(ln.t0amt,0)) +   sum(nvl(marginamt,0)) NO, sum(nvl(adv.amt,0)) no_uttb --KB hotfix 20200911
from cimast ci, v_getaccountavladvance vlad , vw_lngroup_all ln, cfmast cf, afmast af, v_getbuyorderinfo v_getbuy
    , ( --du no UTTB
         SELECT  ACCTNO
            , SUM(NVL(ADS.AMT, 0) + NVL(ADS.FEEAMT, 0)- (case when I_DATE >= ads.cleardt then ads.paidamt else 0 end)) AMT
        FROM   VW_ADSCHD_ALL ADS
        WHERE     (ADS.AMT > 0   OR   ADS.PAIDDATE = I_DATE ) --V_CRRDATE
            AND    ADS.txdate     <=   I_DATE
        GROUP  BY  ACCTNO
        ) adv
where ci.afacctno = vlad.afacctno (+)
and ci.afacctno = ln.trfacctno (+)
and ci.afacctno = adv.acctno (+)
and ci.afacctno = v_getbuy.afacctno (+)
and af.custid = cf.custid  and ci.afacctno = af.acctno
and  EXISTS (SELECT GU.GRPID FROM TLGRPUSERS GU WHERE af.CAREBY = GU.GRPID AND GU.TLID = PV_TLID)
/*and nvl(cf.opndate,'01/01/1999') BETWEEN to_date(O_DATE,'DD/MM/RRRR') and to_date(C_DATE,'DD/MM/RRRR')*/
AND (cf.brid LIKE V_STRBRID  OR instr(V_STRBRID,cf.brid)<> 0)
group by  cf.custodycd, cf.brid, cf.fullname , cf.email, nvl(cf.mobile, cf.phone), ci.afacctno
 )ci,
(   select to_char(g.autoid) autoid, g.fullname,g.custid g_custid, a.afacctno, a.reacctno, a.recustid, f.fullname refullname --KB hotfix 20200831 loi ko co CK ko len bao cao
    from recflnk c, (select refrecflnkid, reactype, cf.effdate, nvl(cf.closedate -1, cf.expdate) expdate from recfdef cf) cf,
    (select afacctno, substr(a.reacctno,11,4) reactype, substr(a.reacctno,1,10) recustid, reacctno, a.frdate, nvl(a.clstxdate -1, a.todate) todate From reaflnk a where status = 'A') a,
    (select * from regrplnk where status = 'A') gl,
    (select * from regrp union all select * from regrphist) g, retype t, cfmast f
    where a.recustid = c.custid and c.autoid = cf.refrecflnkid and gl.reacctno =  a.reacctno and g.autoid = gl.refrecflnkid
        and a.reactype = cf.reactype    --KB hotfix 20200831 loi ko co CK ko len bao cao
        and cf.reactype = t.actype and t.rerole in ('BM','RM') AND c.custid = f.custid
        and I_DATE between gl.frdate and nvl(gl.clstxdate -1, a.todate)
        and I_DATE between g.effdate and g.expdate-1

) re--,
--cfmast c
where ci.afacctno = se.afacctno(+)    --KB hotfix 20200831 loi ko co CK ko len bao cao
--AND (substr(ci.custid,1,4) LIKE V_STRBRID or instr(V_STRBRID,substr(ci.custid,1,4)) <> 0)
and ci.afacctno  = re.afacctno (+)
--and substr(re.reacctno,1,10) = c.custid
and nvl(re.autoid,0) like V_REGRPID
and nvl(re.recustid,' ') like V_RECUSTID
and ci.SO_DU_TIEN+ci.NO+nvl(se.GT_CP_sohuu,0)>0     --KB hotfix 20200831 loi ko co CK ko len bao cao
/*and case when P_FREEORAMOUNT = 0 then se.GT_CP_sohuu + ci.SO_DU_TIEN - ci.NO
         when P_FREEORAMOUNT = 1 then se.GT_CP_sohuu
         when P_FREEORAMOUNT = 2 then ci.SO_DU_TIEN end <= T_AMOUNT
and case when P_FREEORAMOUNT = 0 then se.GT_CP_sohuu + ci.SO_DU_TIEN - ci.NO
         when P_FREEORAMOUNT = 1 then se.GT_CP_sohuu
         when P_FREEORAMOUNT = 2 then ci.SO_DU_TIEN end >= F_AMOUNT*/
order by ci.custodycd, ci.afacctno
;

ELSE


OPEN PV_REFCURSOR FOR
select  ci.*, nvl(se.GT_CP_sohuu,0) GT_CP_sohuu    --KB hotfix 20200831 loi ko co CK ko len bao cao
    , nvl(re.refullname,'') nv_quanly
    , nvl(re.autoid,'') ma_nhom, nvl(re.fullname,'KH Tu Do') ten_nhom
    , I_DATE ngay_tra_cuu from
(
select v.afacctno, v.custodycd
    , sum(case when sb.sectype in ('001', '002', '008', '111', '011') then v.realass else 0 end) GT_CP_sohuu
    --, sum(REALASS) GT_CP_sohuu--sum(ts_t2) GT_CP_sohuu
from vw_mr9004 v, sbsecurities sb where v.codeid = sb.codeid group by afacctno, custodycd
) se,
 (
 select cf.custodycd, cf.brid custid, cf.fullname , cf.email, nvl(cf.mobile, cf.phone), ci.afacctno,
        sum(nvl(ci.balance,0))  TIEN_MAT, -- tong tien
        sum(nvl(ci.depofeeamt,0)) PHI_LK, --no phi luu ky
         sum(nvl(vlad.depoamt,0)) UTTB,
         sum(nvl(ln.t0prinamt + ln.t0intamt,0)) NO_BL, -- No bao lanh
         sum(nvl(ln.mrprinamt + ln.mrintamt,0)) NO_CL, -- no CL
         sum(nvl(ci.balance,0)) +  sum(nvl(vlad.depoamt,0)) - sum(NVL(v_getbuy.secureamt,0)) /*+ sum(nvl(vlad.aamt,0)) + sum(nvl(adv.amt,0))*/ SO_DU_TIEN,
          /*sum(nvl(ci.depofeeamt,0)) +*/ sum(nvl(ln.t0prinamt + ln.t0intamt,0)) +   sum(nvl(ln.mrprinamt + ln.mrintamt,0)) NO, sum(nvl(adv.amt,0)) no_uttb --KB hotfix 20200831
from cimast ci, v_getaccountavladvance vlad , (SELECT afacctno, sum(t0prinamt) t0prinamt, sum(t0intamt) t0intamt, sum(mrprinamt) mrprinamt, sum(mrintamt) mrintamt FROM mr5005_log WHERE txdate = I_DATE GROUP BY afacctno) ln, cfmast cf, afmast af, v_getbuyorderinfo v_getbuy
    , ( --du no UTTB
         SELECT  ACCTNO
            , SUM(NVL(ADS.AMT, 0) + NVL(ADS.FEEAMT, 0)- (case when I_DATE >= ads.cleardt then ads.paidamt else 0 end)) AMT
        FROM   VW_ADSCHD_ALL ADS
        WHERE     (ADS.AMT > 0   OR   ADS.PAIDDATE = I_DATE ) --V_CRRDATE
            AND    ADS.txdate     <=   I_DATE
        GROUP  BY  ACCTNO
        ) adv
where ci.afacctno = vlad.afacctno (+)
and ci.afacctno = ln.afacctno (+)
and ci.afacctno = adv.acctno (+)
and ci.afacctno = v_getbuy.afacctno (+)
and af.custid = cf.custid  and ci.afacctno = af.acctno
and  EXISTS (SELECT GU.GRPID FROM TLGRPUSERS GU WHERE af.CAREBY = GU.GRPID AND GU.TLID = PV_TLID)
/*and nvl(cf.opndate,'01/01/1999') BETWEEN to_date(O_DATE,'DD/MM/RRRR') and to_date(C_DATE,'DD/MM/RRRR')*/
AND (cf.brid LIKE V_STRBRID  OR instr(V_STRBRID,cf.brid)<> 0)
group by  cf.custodycd, cf.brid, cf.fullname , cf.email, nvl(cf.mobile, cf.phone), ci.afacctno
 )ci,
(   select to_char(g.autoid) autoid, g.fullname,g.custid g_custid, a.afacctno, a.reacctno, a.recustid, f.fullname refullname --KB hotfix 20200831 loi ko co CK ko len bao cao
    from recflnk c, (select refrecflnkid, reactype, cf.effdate, nvl(cf.closedate -1, cf.expdate) expdate from recfdef cf) cf,
    (select afacctno, substr(a.reacctno,11,4) reactype, substr(a.reacctno,1,10) recustid, reacctno, a.frdate, nvl(a.clstxdate -1, a.todate) todate From reaflnk a) a,
    (select * from regrplnk) gl,
    (select * from regrp union all select * from regrphist) g, retype t, cfmast f
    where a.recustid = c.custid and c.autoid = cf.refrecflnkid and gl.reacctno =  a.reacctno and g.autoid = gl.refrecflnkid
        and a.reactype = cf.reactype    --KB hotfix 20200831 loi ko co CK ko len bao cao
        and cf.reactype = t.actype and t.rerole in ('BM','RM') AND c.custid = f.custid
        and I_DATE between cf.effdate and cf.expdate
        and I_DATE between a.frdate and a.todate
        and I_DATE between gl.frdate and nvl(gl.clstxdate -1, a.todate)
        and I_DATE between g.effdate and g.expdate-1

) re--,
--cfmast c
where ci.afacctno = se.afacctno(+)    --KB hotfix 20200831 loi ko co CK ko len bao cao
--AND (substr(ci.custid,1,4) LIKE V_STRBRID or instr(V_STRBRID,substr(ci.custid,1,4)) <> 0)
and ci.afacctno  = re.afacctno (+)
--and substr(re.reacctno,1,10) = c.custid
and nvl(re.autoid,0) like V_REGRPID
and nvl(re.recustid,' ') like V_RECUSTID
and ci.SO_DU_TIEN+ci.NO+nvl(se.GT_CP_sohuu,0)>0     --KB hotfix 20200831 loi ko co CK ko len bao cao
/*and case when P_FREEORAMOUNT = 0 then se.GT_CP_sohuu + ci.SO_DU_TIEN - ci.NO
         when P_FREEORAMOUNT = 1 then se.GT_CP_sohuu
         when P_FREEORAMOUNT = 2 then ci.SO_DU_TIEN end <= T_AMOUNT
and case when P_FREEORAMOUNT = 0 then se.GT_CP_sohuu + ci.SO_DU_TIEN - ci.NO
         when P_FREEORAMOUNT = 1 then se.GT_CP_sohuu
         when P_FREEORAMOUNT = 2 then ci.SO_DU_TIEN end >= F_AMOUNT*/
order by ci.custodycd, ci.afacctno
;

END IF;

EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
End;
/



-- End of DDL Script for Procedure HOSTUAT.RE0072

