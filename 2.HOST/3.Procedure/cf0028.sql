CREATE OR REPLACE PROCEDURE cf0028 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   AFACCTNO       IN       VARCHAR2
  )
IS
-- Bao cao: Bao cao tuoi no cua khac hang
-- MODIFICATION HISTORY
-- hie.vu   DATE 28/04/2011
-- Tester .
-- Diennt    edit  24/10/2011
-- ---------   ------  -------------------------------------------
   CUR         PKG_REPORT.REF_CURSOR;
   V_STROPTION    VARCHAR2 (5);
   V_STRBRID      VARCHAR2 (4);
   V_STRAFACCTNO  VARCHAR2 (20);
   V_CURDATEE      VARCHAR2(20);
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

Select VARVALUE INTO V_CURDATEE from sysvar where VARNAME='CURRDATE';

OPEN PV_REFCURSOR
FOR

SELECT   lnm.trfacctno afacctno, cf.fullname fullname,
         lns.rlsdate ngay_phat_sinh, lns.overduedate ngay_het_han,
         lns.paid goc_da_tra, (lns.nml + lns.ovd) goc_chua_tra,
         ROUND(lns.intnmlacr + lns.intovdprin + lns.intovd + lns.INTDUE) lai_cong_don,
         ROUND(lns.intnmlacr + lns.INTDUE) lai_trong_han,ROUND(lns.intovdprin + lns.intovd) lai_qua_han,
         V_CURDATEE ngay_tao_bc,lns.REFTYPE,
         (CASE WHEN lns.reftype ='GP' THEN
                    'T0'
               WHEN lns.reftype IN('P','I') THEN
                    (CASE WHEN lnm.ftype = 'AF' THEN 'CL'
                          WHEN lnm.ftype ='DF' THEN 'ML' END)
               ELSE '' END) L_TYPE,
         (SELECT COUNT(*) FROM SBCLDR
                WHERE
                sbdate BETWEEN lns.rlsdate AND to_date(V_CURDATEE,'dd/mm/yyyy')
                AND cldrtype = '000') Tuoi_mon_no
    FROM lnschd lns, lnmast lnm, afmast af, cfmast cf
   WHERE lns.acctno = lnm.acctno(+)
     AND lns.reftype IN ('GP', 'P')
     AND lnm.trfacctno = af.acctno
     AND af.custid = cf.custid
     AND lnm.trfacctno = V_STRAFACCTNO
ORDER BY ngay_phat_sinh, ngay_het_han;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

