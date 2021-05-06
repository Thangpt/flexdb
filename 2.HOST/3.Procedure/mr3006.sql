CREATE OR REPLACE PROCEDURE mr3006 (
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
-- PURPOSE: BAO CAO IN GIAY DE NGHI GIAI NGAN KIEM KHE UOC NHAN NO
-- MODIFICATION HISTORY
-- PERSON       DATE        COMMENTS
-- THENN        05-APR-2012 CREATED
-- ---------    ------      -------------------------------------------

    V_STROPTION         VARCHAR2  (5);
    V_STRBRID           VARCHAR2(100);
    V_CUSTBANK          varchar2(10);
    V_IN_DATE           VARCHAR2(15);
    V_LOANAUTOID          VARCHAR2(10);
    V_LOANAMT           NUMBER;


BEGIN
    -- GET REPORT'S PARAMETERS
    V_STROPTION := OPT;
    --V_BRID := BRID;
    V_LOANAUTOID := LOANAUTOID;

    -- TINH DU NO THEO NGUON
    /*SELECT loan.loanamt
    INTO V_LOANAMT
    FROM lnschd lns, lnmast ln, cfmast cf, afmast af,
        (SELECT cf.custid, nvl(ln.custbank,'KBSV') custbank, sum(ln.prinnml+ln.prinovd+ln.oprinnml+ln.oprinovd) loanamt
        FROM lnmast ln, cfmast cf, afmast af
        WHERE cf.custid = af.custid AND ln.trfacctno = af.acctno
        GROUP BY cf.custid, ln.custbank
        ) loan
    WHERE cf.custid = af.custid AND ln.trfacctno = af.acctno
        and lns.acctno = ln.acctno
        AND cf.custid = loan.custid AND nvl(ln.custbank, 'KBSV') = loan.custbank
        AND lns.autoid = V_LOANAUTOID;*/

    -- LAY DU LIEU CHO BAO CAO
    OPEN PV_REFCURSOR FOR
        SELECT CF.custid, CF.custodycd, AF.acctno, cf.fullname, to_char(cf.dateofbirth,'DD/mm/yyyy') dateofbirth,
            cf.idcode, to_char(cf.iddate,'dd/mm/yyyy') iddate, cf.idplace, cf.address, cf.email, cf.phone, cf.fax,
            af.mrirate, af.mrmrate, af.mrlrate, lns.autoid, LNS.acctno lnacctno, cf.mrloanlimit,
            to_char(lns.rlsdate,'dd/mm/yyyy') rlsdate, RLS.rlsamt,
            to_char(lns.overduedate,'dd/mm/yyyy') overduedate, lns.intnmlacr+lns.intdue+lns.intovd+lns.intovdprin intprin,
            lns.feeintnmlacr+lns.feeintovdacr+lns.feeintnmlovd+lns.feeintdue+lns.feeintdue+lns.feeintovd feeintprin,
            RLS.seass SECAMOUNT,
            RLS.totalodamt LOANAMT,
            NVL(RLS.CUSTBANK,'KBSV') CUSTBANK, NVL(CF2.FULLNAME,'KBSV') BANKNAME, nvl(cf2.shortname,'KBSV') bankshortname,
            RLS.totalprinamt aft_lnamt,
            RLS.rate intrate, RLS.cfrate feerate,
            RLS.marginrate marginrate, RLS.mrcrlimitmax MRLIMIT
        FROM CFMAST CF, AFMAST AF, CFMAST CF2, rlsrptlog_eod RLS,vw_lnschd_all LNS
                            --aftype aft, mrtype mrt
        WHERE CF.custid = AF.custid
            --AND af.actype = aft.actype AND aft.mrtype = mrt.actype AND mrt.mrtype IN ('S','T')
            AND lns.autoid = RLS.lnschdid
            and RLS.afacctno = af.acctno
            and af.custid = cf.custid
            AND RLS.CUSTBANK = CF2.CUSTID (+)
            AND LNS.autoid = V_LOANAUTOID
        ;

        /*SELECT a.*, CASE WHEN a.custbank = 'KBSV' THEN a.mrloanlimit
                ELSE CASE WHEN a.custid IN (SELECT custid FROM cflimitext cfle WHERE cfle.lmsubtype = 'DFMR') THEN nvl(cfle.lmamt,0)
                            ELSE nvl(cfl.lmamt,0) END END mrlimit
        FROM
        (
            SELECT CF.custid, CF.custodycd, AF.acctno, cf.fullname, to_char(cf.dateofbirth,'DD/mm/yyyy') dateofbirth,
                cf.idcode, to_char(cf.iddate,'dd/mm/yyyy') iddate, cf.idplace, cf.address, cf.email, cf.phone, cf.fax,
                af.mrirate, af.mrmrate, af.mrlrate, lns.autoid, ln.acctno lnacctno, cf.mrloanlimit,
                to_char(lns.rlsdate,'dd/mm/yyyy') rlsdate, lns.nml+lns.ovd+lns.paid rlsamt,
                to_char(lns.overduedate,'dd/mm/yyyy') overduedate, lns.intnmlacr+lns.intdue+lns.intovd+lns.intovdprin intprin,
                lns.feeintnmlacr+lns.feeintovdacr+lns.feeintnmlovd+lns.feeintdue+lns.feeintdue+lns.feeintovd feeintprin,
                ROUND(DECODE(AF.IST2,'Y',LEAST(sec.SEMAXCALLASS, sec.MRCRLIMITMAX), LEAST(sec.SETOTALCALLASS, sec.MRCRLIMITMAX))) SECAMOUNT,
                --ROUND(DECODE(AF.IST2,'Y',CASE WHEN sec.OUTSTANDINGT2 > 0 THEN 0 ELSE ABS(sec.OUTSTANDINGT2) END,CASE WHEN sec.OUTSTANDING > 0 THEN 0 ELSE ABS(sec.OUTSTANDING) END)) LOANAMT,
                V_LOANAMT LOANAMT,
                NVL(LN.CUSTBANK,'KBSV') CUSTBANK, NVL(CF2.FULLNAME,'KBSV') BANKNAME, nvl(cf2.shortname,'KBSV') bankshortname,
                --ROUND(DECODE(AF.IST2,'Y',CASE WHEN sec.OUTSTANDINGT2 > 0 THEN 0 ELSE ABS(sec.OUTSTANDINGT2) END,CASE WHEN sec.OUTSTANDING > 0 THEN 0 ELSE ABS(sec.OUTSTANDING) END)) aft_lnamt,
                V_LOANAMT aft_lnamt,
                CASE WHEN ln.oprinnml+ln.oprinovd+ln.oprinpaid>0 THEN ln.orate2 ELSE ln.rate2 END intrate, ln.cfrate2 feerate,
                decode(AF.IST2,'Y',sec.rlsmarginrate,sec.marginrate) marginrate
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
                AND LNS.autoid = V_LOANAUTOID
        ) a, cflimitext cfle, cflimit cfl
        WHERE a.custbank = cfl.bankid (+)
            AND a.custbank = cfle.bankid (+)
            AND a.custid = cfle.custid (+)
        ;*/

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

