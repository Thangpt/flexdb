CREATE OR REPLACE PROCEDURE cf1011 (
   PV_REFCURSOR     IN OUT   PKG_REPORT.REF_CURSOR,
   OPT              IN       VARCHAR2,
   BRID             IN       VARCHAR2,
   LOANAUTOID       IN      VARCHAR2
--   CUSTBANK         IN      VARCHAR2,
  -- PV_CUSTODYCD     IN       VARCHAR2,
  -- PV_AFACCTNO      IN       VARCHAR2
       )
IS

--
-- PURPOSE: BAO CAO IN HOP DONG MO TIEU KHOAN GIAO DICH KY QUY
-- MODIFICATION HISTORY
-- PERSON       DATE        COMMENTS
-- THENN        05-APR-2012 CREATED
-- ---------    ------      -------------------------------------------

    V_STROPTION         VARCHAR2  (5);
    V_STRBRID           VARCHAR2(100);
    V_CUSTBANK          varchar2(10);
    V_IN_DATE           VARCHAR2(15);
    V_LOANAUTOID          VARCHAR2(10);


BEGIN
    -- GET REPORT'S PARAMETERS
    V_STROPTION := OPT;
    --V_BRID := BRID;
    V_LOANAUTOID := LOANAUTOID;

     OPEN PV_REFCURSOR FOR
        SELECT CF.custid, CF.custodycd, AF.acctno, cf.fullname, to_char(cf.dateofbirth,'DD/mm/yyyy') dateofbirth,
            cf.idcode, to_char(cf.iddate,'dd/mm/yyyy') iddate, cf.idplace, cf.address, cf.email, cf.phone, cf.fax,
            AF.mrcrlimit mrlimit, af.mrirate, af.mrmrate, af.mrlrate, lns.autoid, ln.acctno lnacctno,
            to_char(lns.rlsdate,'dd/mm/yyyy') rlsdate, lns.nml+lns.ovd+lns.paid rlsamt,
            to_char(lns.overduedate,'dd/mm/yyyy') overduedate, lns.intnmlacr+lns.intdue+lns.intovd+lns.intovdprin intprin,
            lns.feeintnmlacr+lns.feeintovdacr+lns.feeintnmlovd+lns.feeintdue+lns.feeintdue+lns.feeintovd feeintprin,
            ROUND(DECODE(AF.IST2,'Y',LEAST(sec.SEMAXCALLASS, sec.MRCRLIMITMAX), LEAST(sec.SETOTALCALLASS, sec.MRCRLIMITMAX))) SECAMOUNT,
            ROUND(DECODE(AF.IST2,'Y',CASE WHEN sec.OUTSTANDINGT2 > 0 THEN 0 ELSE ABS(sec.OUTSTANDINGT2) END,CASE WHEN sec.OUTSTANDING > 0 THEN 0 ELSE ABS(sec.OUTSTANDING) END)) LOANAMT,
            NVL(LN.CUSTBANK,'BVSC') CUSTBANK, NVL(CF2.FULLNAME,'BVSC') BANKNAME, 0 aft_lnamt
        FROM CFMAST CF,
            (SELECT AF.*, CASE WHEN AF.TRFBUYEXT * AF.TRFBUYRATE > 0 THEN 'Y' ELSE 'N' END IST2 FROM AFMAST AF) AF,
            aftype aft, mrtype mrt, v_getsecmarginratio sec, lnmast ln, lnschd lns, cfmast cf2
        WHERE CF.custid = AF.custid
            AND af.actype = aft.actype AND aft.mrtype = mrt.actype AND mrt.mrtype IN ('S','T')
            AND lns.acctno = ln.acctno
            and ln.trfacctno = af.acctno
            and af.custid = cf.custid
            and lns.reftype in ('P','GP')
            and ln.ftype = 'AF'
            AND sec.afacctno = af.acctno
            AND LN.CUSTBANK = CF2.CUSTID (+)
            AND LNS.autoid = V_LOANAUTOID;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

