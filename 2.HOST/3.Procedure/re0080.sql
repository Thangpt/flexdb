CREATE OR REPLACE PROCEDURE re0080 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   CUSTID         IN       VARCHAR2,
   REGRP         IN       VARCHAR2
 )
IS
--bao cao gia tri giao dich
--created by Chaunh at 17/04/2014
    V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID          VARCHAR2 (40);    -- USED WHEN V_NUMOPTION > 0
    V_INBRID     VARCHAR2 (5);

    VF_DATE DATE;
    VT_DATE DATE;
    V_CUSTID varchar2(10);
    V_REGRP varchar2(10);
    V_REERNAME varchar2(50);
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

   ------------------------
   IF (REGRP <> 'ALL' OR trim(REGRP) is null)
   THEN
    V_REGRP := REGRP;
   ELSE
    V_REGRP := '%';
   END IF;
   -----------------------

   IF (CUSTID <> 'ALL' OR trim(CUSTID) IS NULL)
   THEN
        V_CUSTID := CUSTID;
   ELSE
    V_CUSTID := '%';
   END IF;
   ------------------------------
   VF_DATE := to_date(F_DATE,'DD/MM/RRRR');
   VT_DATE := to_date(T_DATE,'DD/MM/RRRR');
OPEN PV_REFCURSOR FOR
select V_CUSTID, V_REGRP,cf.fullname, nvl(gl.fullname,'') ten_nhom, nvl(gl.autoid,' ') ma_nhom, rt.typename, rt.rerole, re.* from
(
    select acctno, sum(mg_gtgd) mg_gtgd, sum(mg_phigd) mg_phigd, sum(mg_phitraso) mg_phitraso, sum(mg_phithuan) mg_phithuan
        , sum(dsf_phithuan) dsf_phithuan, sum(dsf_matchamt) dsf_matchamt, sum(dsf_feeacr) dsf_feeacr, sum(dsf_rfmatchamt) dsf_rfmatchamt
    from
    (
        select tr.acctno
            , intbal -   sum(nvl(re.matchamt,0)) mg_gtgd
            , intamt - sum(nvl(re.feeacr,0)) mg_phigd
            , tr.rfmatchamt - sum(nvl(re.rfmatchamt,0)) mg_phitraso
            , intamt - sum(nvl(re.feeacr,0)) - (tr.rfmatchamt - sum(nvl(re.rfmatchamt,0))) mg_phithuan
            , sum(nvl(re.feeacr,0)) - sum(nvl(re.rfmatchamt,0)) dsf_phithuan
            , sum(nvl(re.matchamt,0)) dsf_matchamt, sum(nvl(re.feeacr,0)) dsf_feeacr, sum(nvl(re.rfmatchamt,0)) dsf_rfmatchamt
        from retype rt,
            (select * from reinttran union all select * from reinttrana) tr
            left join rerevdgall re  on tr.todate = re.frdate and tr.acctno = re.reacctno
        where  tr.todate between VF_DATE and  VT_DATE
        and substr(tr.acctno,11,4) = rt.actype  and rt.retype = 'D'
        group by tr.acctno, tr.todate, tr.intbal, tr.intamt, tr.rfmatchamt
    )
    group by acctno
    having sum(mg_gtgd) + sum(mg_phigd) + sum(mg_phitraso)+ sum(mg_phithuan)+
         sum(dsf_phithuan) + sum(dsf_matchamt) + sum(dsf_feeacr) + sum(dsf_rfmatchamt) <> 0
) re
, cfmast cf, retype rt,
(select g.fullname,to_char(g.autoid) autoid, gl.reacctno from regrp g, regrplnk gl where gl.refrecflnkid = g.autoid
and gl.status = 'A' and gl.clstxdate is null) gl
where substr(re.acctno,1,10) = cf.custid and re.acctno = gl.reacctno (+) and rt.actype = substr(re.acctno,11,4)

and cf.custid like V_CUSTID
and nvl(gl.autoid,' ') like V_REGRP
order by cf.fullname, rt.rerole
;

EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
End;
/

