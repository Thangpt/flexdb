CREATE OR REPLACE PROCEDURE mr0009 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   PV_CUSTODYCD         IN       VARCHAR2,
   PV_ACCTNO         IN       VARCHAR2

 )
IS
--
-- created by Chaunh at 06/03/2013
-- ---------   ------  -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (40);        -- USED WHEN V_NUMOPTION > 0
   V_INBRID           VARCHAR2 (4);

    V_CUSTODYCD         VARCHAR2 (10);
    V_ACCTNO            VARCHAR2 (10);

BEGIN
   V_STROPTION := upper(OPT);
   V_INBRID := BRID;

   IF (V_STROPTION = 'A') THEN
      V_STRBRID := '%';
   ELSE if (V_STROPTION = 'B') then
            select brgrp.mapid into V_STRBRID from brgrp where brgrp.brid = V_INBRID;
        else
            V_STRBRID := V_INBRID;
        end if;
   END IF;

   IF PV_CUSTODYCD = 'ALL' OR PV_CUSTODYCD IS NULL
   THEN
        V_CUSTODYCD := '%';
   ELSE
        V_CUSTODYCD := PV_CUSTODYCD;
   END IF;

   IF PV_ACCTNO = 'ALL' OR PV_ACCTNO IS NULL
   THEN
        V_ACCTNO := '%';
   ELSE
        V_ACCTNO := PV_ACCTNO;
   END IF;

OPEN PV_REFCURSOR
  FOR
select cf.custodycd, af.acctno,cf.fullname
    , mrt.MRtype , cf.opndate
    ,cf.mrloanlimit, cf.t0loanlimit,
    af.mrcrlimitmax, round(ci.dfodamt) dfodamt,
        round(af.mrcrlimitmax - ci.dfodamt - nvl(mramt,0)) mrcrlimitremain,
        nvl(T0af.AFT0USED,0) AFT0USED,
    round(af.advanceline - nvl(b.trft0amt,0)) advanceline,
    round(cf.mrloanlimit)-ROUND(nvl(MR.CUSTMRUSED,0)) avlmrloanlimit,round(cf.t0loanlimit)-ROUND(nvl(T0.CUSTT0USED,0)) avlt0loanlimit,
    round(nvl(dfamt,0)) dfamt, round(nvl(dfprinamt,0)) dfprinamt, round(nvl(dfintamt,0)) dfintamt,
    round(nvl(mramt,0)) mramt, round(nvl(mrprinamt,0)) mrprinamt, round(nvl(mrintamt,0)) mrintamt,
    round(nvl(ln.t0amt,0)) t0amt
from afmast af, cfmast cf, cimast ci, aftype aft, mrtype mrt,
    v_getbuyorderinfo b,
    (select sum(acclimit) CUSTT0USED, af.CUSTID from useraflimit us, afmast af where af.acctno = us.acctno and us.typereceive = 'T0' group by custid) T0,
    (select sum(acclimit) AFT0USED, acctno from useraflimit us where us.typereceive = 'T0' group by acctno) T0af,
    (select sum(mrcrlimitmax) CUSTMRUSED, CUSTID from afmast group by custid) MR,
    (select trfacctno,
        sum(decode(ftype,'DF',1,0)*(prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd)) dfamt,
        sum(decode(ftype,'DF',1,0)*(prinnml+prinovd)) dfprinamt,
        sum(decode(ftype,'DF',1,0)*(intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd)) dfintamt,
        sum(decode(ftype,'AF',1,0)*(prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd)) mramt,
        sum(decode(ftype,'AF',1,0)*(prinnml+prinovd)) mrprinamt,
        sum(decode(ftype,'AF',1,0)*(intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd)) mrintamt,
        sum(decode(ftype,'AF',1,0)*(oprinnml+oprinovd+ointnmlacr+ointdue+ointovdacr+ointnmlovd)) t0amt
    from lnmast
    group by trfacctno) ln
where af.custid=cf.custid
    and af.acctno = ci.acctno
    and af.actype =aft.actype
    and aft.mrtype =mrt.actype
    and af.acctno = T0af.acctno(+)
    and cf.custid = T0.custid(+)
    and cf.custid = MR.custid(+)
    and af.acctno = b.afacctno(+)
    and af.acctno = ln.trfacctno(+)
    AND AF.STATUS <> 'C'
    AND CF.CUSTODYCD LIKE V_CUSTODYCD
    AND AF.ACCTNO LIKE V_ACCTNO
;



EXCEPTION
   WHEN OTHERS
   THEN

      RETURN;
End;
/

