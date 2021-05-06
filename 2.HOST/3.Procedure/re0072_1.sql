CREATE OR REPLACE PROCEDURE re0072_1 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
    --P_FREEORAMOUNT     in      varchar2,
    PV_RECUSTID        in      varchar2,
    --F_AMOUNT         in      varchar2,
    --T_AMOUNT         in      varchar2,
   --O_DATE           in      varchar2,
    --C_DATE           in      varchar2,
    PV_REGRPID      IN        VARCHAR2,
    PV_TLID         in        varchar2
 )
IS

    V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID          VARCHAR2 (40);    -- USED WHEN V_NUMOPTION > 0
    V_INBRID     VARCHAR2 (5);
    V_CUSTODYCD varchar2(10);
    I_DATE      date;
    V_RECUSTID varchar2(10);
    V_REGRPID  varchar2(10);
    V_CUSTID   varchar2(4);
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

   SELECT to_date(varvalue, 'DD/MM/RRRR') into I_DATE from sysvar where varname = 'CURRDATE';

   /*begin
    select cf.CUSTID into V_CUSTID from reuserlnk u, recfdef cd, recflnk c, cfmast cf
    where u.refrecflnkid = c.autoid and u.refrecflnkid = cd.refrecflnkid and cf.custid = c.custid
    and I_DATE between cd.opendate and nvl(cd.closedate -1, cd.expdate) and u.tlid = PV_TLID;
    EXCEPTION
        when OTHERS
        then
            V_CUSTID := 'xxxxXXXXXX';
    end;
*/

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

OPEN PV_REFCURSOR FOR
select  ci.*, se.GT_CP_sohuu
    , nvl(c.fullname,'') nv_quanly
    , nvl(re.autoid,'') ma_nhom, nvl(re.fullname,'KH Tu Do') ten_nhom
    , I_DATE ngay_tra_cuu
from
    (
    select afacctno, custodycd, sum(REALASS) GT_CP_sohuu--sum(ts_t2) GT_CP_sohuu
    from vw_mr9004
    group by afacctno, custodycd
    ) se,
    (
    select cf.custodycd, cf.custid, cf.fullname , cf.email, nvl(cf.mobile, cf.phone), ci.afacctno,
            sum(nvl(ci.balance,0))  TIEN_MAT, -- tong tien
            sum(nvl(ci.depofeeamt,0)) PHI_LK, --no phi luu ky
            sum(nvl(vlad.depoamt,0)) UTTB,
            sum(nvl(t0amt,0)) NO_BL, -- No bao lanh
            sum(nvl(marginamt,0)) NO_CL, -- no CL
            --sum(nvl(ci.balance,0)) +  sum(nvl(vlad.depoamt,0)) + sum(nvl(adv.amt,0)) SO_DU_TIEN,
            sum(nvl(ci.balance,0)) +  sum(nvl(vlad.depoamt,0)) + sum(nvl(vlad.aamt,0)) SO_DU_TIEN,
            sum(nvl(vlad.depoamt,0)) + sum(nvl(t0amt,0)) +   sum(nvl(marginamt,0)) + sum(nvl(adv.amt,0)) NO
    from cimast ci, v_getaccountavladvance vlad , vw_lngroup_all ln, cfmast cf
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
        and ci.custid = cf.custid
        /*and cf.opndate BETWEEN to_date(O_DATE,'DD/MM/RRRR') and to_date(C_DATE,'DD/MM/RRRR')
        AND (substr(cf.custid,1,4) LIKE V_STRBRID  OR instr(V_STRBRID,substr(cf.custid,1,4))<> 0)*/
    group by  cf.custodycd, cf.custid, cf.fullname , cf.email, nvl(cf.mobile, cf.phone), ci.afacctno
    )ci,
    (select g.autoid, g.fullname,g.custid g_custid, r.afacctno, r.reacctno
            , substr(r.reacctno,1,10) recustid
    from reaflnk r, retype rt, regrplnk gl, regrp g, recfdef cd, recflnk cl, reuserlnk U
    where r.status = 'A' and substr(r.reacctno,11,4) = rt.actype and rt.rerole in ('BM','RM')
        and gl.reacctno = r.reacctno and g.autoid = gl.refrecflnkid and gl.status = 'A'
        and cd.refrecflnkid = cl.autoid and gl.reacctno = cl.custid || cd.reactype and cd.status = 'A'
        AND U.REFRECFLNKID = CL.AUTOID AND U.TLID = PV_TLID
    ) re,
    cfmast c
where se.afacctno = ci.afacctno
    --AND (substr(ci.custid,1,4) LIKE V_STRBRID or instr(V_STRBRID,substr(ci.custid,1,4)) <> 0)
    and ci.afacctno  = re.afacctno
    and substr(re.reacctno,1,10) = c.custid
    --and c.CUSTID  = V_CUSTID
    and nvl(re.autoid,0) like V_REGRPID
    and nvl(re.recustid,' ') like V_RECUSTID
    /*and case when P_FREEORAMOUNT = 0 then se.GT_CP_sohuu + ci.SO_DU_TIEN - ci.NO
            when P_FREEORAMOUNT = 1 then se.GT_CP_sohuu
            when P_FREEORAMOUNT = 2 then ci.SO_DU_TIEN end <= T_AMOUNT
    and case when P_FREEORAMOUNT = 0 then se.GT_CP_sohuu + ci.SO_DU_TIEN - ci.NO
            when P_FREEORAMOUNT = 1 then se.GT_CP_sohuu
            when P_FREEORAMOUNT = 2 then ci.SO_DU_TIEN end >= F_AMOUNT*/
order by ci.custodycd, ci.afacctno
;

EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
End;
/

