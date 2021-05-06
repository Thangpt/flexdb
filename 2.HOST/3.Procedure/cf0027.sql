CREATE OR REPLACE PROCEDURE cf0027 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   AFACCTNO       IN       VARCHAR2
  )
IS
-- Bao cao: Bang ke tinh lai cho tai khoan CL
-- MODIFICATION HISTORY
-- hien.vu      DATE 27/04/2011
-- Tester . Anh.vanha
-- ---------   ------  -------------------------------------------
   CUR         PKG_REPORT.REF_CURSOR;
   V_STROPTION    VARCHAR2 (5);
   V_STRBRID      VARCHAR2 (4);
   V_STRAFACCTNO  VARCHAR2 (20);
BEGIN
   V_STROPTION := OPT;
   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   IF (AFACCTNO <> 'ALL')
   THEN
      V_STRAFACCTNO :=  AFACCTNO;
   ELSE
      V_STRAFACCTNO := '%%';
   END IF;

OPEN PV_REFCURSOR
FOR

Select AF1.trfacctno  trfacctno , LNI.ACCTNO, LNI.frdate frdate ,LNi.todate todate, max(lni.intbal) so_du_tinh_lai ,
(Case when  DRATE='Y1' then IRRATE || '%' else (case when DRATE='D1' then  IRRATE*12 || '%' else '' end ) end) Rate_2,
LNi.irrate,sum(round(LNi.intamt)) Tien_lai, af1.fullname,
(CASE WHEN AF1.reftype ='GP' THEN 'T0'
      WHEN AF1.reftype IN('P','I') THEN (CASE WHEN AF1.ftype = 'AF' THEN 'CL' WHEN AF1.ftype ='DF' THEN 'ML' END)
      ELSE '' END) L_TYPE
from LNINTTRAN LNI,
(
SELECT ln1.acctno, ln1.trfacctno, cf.fullname, ln1.drate, lns.reftype, ln1.ftype
FROM lnmast ln1, afmast af, cfmast cf, lnschd lns
WHERE ln1.trfacctno = af.acctno AND af.custid = cf.custid AND lns.acctno = ln1.acctno(+) AND lns.reftype IN ('GP', 'P','I')
GROUP BY ln1.acctno, ln1.trfacctno, cf.fullname, ln1.drate, lns.reftype, ln1.ftype--36
)AF1
where LNI.ACCTNO=AF1.ACCTNO(+)
and trfacctno=AFACCTNO
and frdate >= to_date(F_DATE,'DD/MM/RRRR')
and todate <= to_date(T_DATE,'DD/MM/RRRR')
Group by AF1.trfacctno, LNI.ACCTNO,LNI.frdate  ,LNi.todate , (CASE WHEN AF1.reftype ='GP' THEN 'T0'
      WHEN AF1.reftype IN('P','I') THEN (CASE WHEN AF1.ftype = 'AF' THEN 'CL' WHEN AF1.ftype ='DF' THEN 'ML' END)
      ELSE '' END),
(Case when  DRATE='Y1' then IRRATE || '%' else (case when DRATE='D1' then  IRRATE*12 || '%' else '' end ) end) ,LNi.irrate,af1.fullname
order by frdate,todate;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

