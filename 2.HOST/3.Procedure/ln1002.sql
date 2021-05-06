CREATE OR REPLACE PROCEDURE ln1002 (
   PV_REFCURSOR     IN OUT   PKG_REPORT.REF_CURSOR,
   p_OPT              IN       VARCHAR2,
   p_BRID             IN       VARCHAR2,
   p_I_DATE           IN      VARCHAR2,
   p_CUSTBANK         IN      VARCHAR2,
   p_SERVICETYPE      IN       VARCHAR2,
   p_SIGNTYPE         IN      VARCHAR2,
   PV_CUSTODYCD     IN       VARCHAR2,
   PV_AFACCTNO      IN       VARCHAR2

       )
IS

--
-- PURPOSE: BAO CAO THANH TOAN TIEN VAY
-- MODIFICATION HISTORY
-- PERSON       DATE        COMMENTS
-- THENN        05-APR-2012 CREATED
-- ---------    ------      -------------------------------------------

    V_STROPTION         VARCHAR2  (5);
    V_STRBRID           VARCHAR2(100);
    V_CUSTBANK          varchar2(10);
    V_SVTYPE            VARCHAR2(5);
    V_IN_DATE           VARCHAR2(15);
    V_SIGNTYPE          VARCHAR2(10);
    V_BRID              VARCHAR2(4);
    V_CUSTODYCD       VARCHAR2(10);
    V_AFACCTNO         VARCHAR2(10);
BEGIN
/*pr_error('LN1002','p_I_DATE:'||p_I_DATE);
pr_error('LN1002','p_CUSTBANK:'||p_CUSTBANK);
pr_error('LN1002','p_SERVICETYPE:'||p_SERVICETYPE);
pr_error('LN1002','p_SIGNTYPE:'||p_SIGNTYPE);*/

    -- GET REPORT'S PARAMETERS
    V_STROPTION := p_OPT;
    V_BRID := p_BRID;

    IF V_STROPTION = 'A' THEN
        V_STRBRID := '%%';
    ELSIF V_STROPTION = 'B' AND V_BRID <> 'ALL' AND V_BRID IS NOT NULL THEN
        SELECT MAPID INTO V_STRBRID FROM BRGRP WHERE BRID = V_BRID;
    ELSIF V_STROPTION = 'S' AND V_BRID <> 'ALL' AND V_BRID IS NOT NULL THEN
        V_STRBRID := V_BRID;
    ELSE
        V_STRBRID := V_BRID;
    END IF;

    V_IN_DATE := p_I_DATE;
    V_SIGNTYPE := p_SIGNTYPE;

       IF PV_CUSTODYCD = 'ALL' OR PV_CUSTODYCD IS NULL THEN
       V_CUSTODYCD := '%%';
    ELSE
        V_CUSTODYCD := UPPER( PV_CUSTODYCD);
    END IF;

    IF PV_AFACCTNO = 'ALL' OR PV_AFACCTNO IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := UPPER( PV_AFACCTNO);
    END IF;

    IF p_CUSTBANK = 'ALL' OR p_CUSTBANK IS NULL THEN
        V_CUSTBANK := '%%';
    ELSE
        V_CUSTBANK := p_CUSTBANK;
    END IF;

    IF p_SERVICETYPE = 'ALL' OR p_SERVICETYPE IS NULL THEN
        V_SVTYPE := '%%';
    ELSE
        V_SVTYPE := p_SERVICETYPE;
    END IF;

    OPEN PV_REFCURSOR FOR
        SELECT MAX(A.CUSTODYCD) CUSTODYCD, MAX(A.AFACCTNO) AFACCTNO, MAX(A.FULLNAME) FULLNAME, A.TXDATE, MAX(A.overduedate) overduedate,
            A.lnacctno, A.AUTOID, A.RLSDATE, MAX(A.LOANRATE) LOANRATE,MAX(A.LOANPERIOD) LOANPERIOD,
                MAX(A.BE_ORGLNAMT) BE_ORGLNAMT, SUM(A.ORGPAIDAMT) ORGPAIDAMT,
                SUM(A.INTPAIDAMT) INTPAIDAMT, SUM(A.FEEPAIDAMT) FEEPAIDAMT, MAX(A.LOANTYPE) LOANTYPE,
                MAX(A.custbank) custbank, MAX(A.BANKNAME) BANKNAME, MAX(A.CUSTBANKVL) CUSTBANKVL, MAX(A.BANKSHORTNAME) BANKSHORTNAME,
                SUM(A.BANKINTPAIDAMT) BANKINTPAIDAMT,
                SUM(A.BANKFEEPAIDAMT) BANKFEEPAIDAMT,
                MAX(A.BANKPAIDMETHOD) BANKPAIDMETHOD, MAX(A.lastpaid) lastpaid,MAX(V_SIGNTYPE) SIGNER
        FROM
        (
            -- DF
            SELECT CF.CUSTODYCD, cf.acctno AFACCTNO, CF.FULLNAME, TO_CHAR(lnt.TXDATE,'DD/MM/YYYY') TXDATE, LN.overduedate, lnt.lnacctno, LN.AUTOID,
                to_char(LN.RLSDATE,'DD/MM/YYYY') RLSDATE, LN.LOANRATE, --LN.LOANPERIOD,
                to_date(V_IN_DATE,'DD/MM/YYYY') - ln.rlsdate LOANPERIOD,
                LN.prinamt + NVL(PS.ORGPAIDAMT,0) BE_ORGLNAMT, NVL(lnt.ORGPAIDAMT,0) ORGPAIDAMT,
                NVL(lnt.INTPAIDAMT,0) INTPAIDAMT, NVL(lnt.FEEPAIDAMT,0) FEEPAIDAMT, 'DF' LOANTYPE,
                CASE WHEN NVL(LNT.OVDPAIDAMT,0) = 0 OR LN.CUSTBANK = '' THEN ln.custbank ELSE 'OVDB' END custbank,
                LN.CUSTBANK CUSTBANKVL, LN.BANKSHORTNAME,
                CASE WHEN NVL(LNT.OVDPAIDAMT,0) = 0 OR LN.CUSTBANK = '' THEN LN.BANKNAME ELSE 'OVDB' END BANKNAME,
                CASE WHEN NVL(LNT.OVDPAIDAMT,0) >0 OR ln.BANKPAIDMETHOD = 'I' THEN NVL(lnt.INTPAIDAMT,0)
                    WHEN ln.BANKPAIDMETHOD = 'A' AND LNT.lastpaid = 'N' THEN 0
                    WHEN ln.BANKPAIDMETHOD = 'A' AND LNT.lastpaid = 'Y' THEN LN.intpaid
                    WHEN ln.BANKPAIDMETHOD = 'P' AND NVL(lnt.ORGPAIDAMT,0) = 0 THEN 0
                    WHEN ln.BANKPAIDMETHOD = 'P' AND NVL(lnt.ORGPAIDAMT,0) > 0 THEN
                        fn_calc_lnintpaid(LN.AUTOID, TO_CHAR(LNT.TXDATE,'DD/MM/YYYY'), LNT.LNTAUTOID, 'DF')
                    ELSE 0 END BANKINTPAIDAMT,
                /*CASE WHEN ln.BANKPAIDMETHOD = 'I' THEN NVL(lnt.FEEPAIDAMT,0)
                    WHEN ln.BANKPAIDMETHOD = 'A' AND LNT.lastpaid = 'N' THEN 0
                    WHEN ln.BANKPAIDMETHOD = 'A' AND LNT.lastpaid = 'Y' THEN LN.FEEINTPAID
                    WHEN ln.BANKPAIDMETHOD = 'P' AND NVL(lnt.ORGPAIDAMT,0) = 0 THEN 0
                    WHEN ln.BANKPAIDMETHOD = 'P' AND NVL(lnt.ORGPAIDAMT,0) > 0 THEN
                        fn_calc_lnfeepaid(LN.AUTOID, TO_CHAR(LNT.TXDATE,'DD/MM/YYYY'), LNT.LNTAUTOID, 'DF')
                    ELSE 0 END BANKFEEPAIDAMT,*/
                NVL(lnt.FEEPAIDAMT,0) BANKFEEPAIDAMT,
                CASE WHEN NVL(LNT.OVDPAIDAMT,0) >0 THEN 'I' ELSE ln.BANKPAIDMETHOD END BANKPAIDMETHOD, LNT.lastpaid
                --ln.custbank, ln.BANKNAME
            FROM
                (
                    SELECT max(lnt.ref) afacctno, lnt.txdate, lnt.acctno lnacctno,
                        sum(CASE WHEN lnt.txcd = '0014' THEN lnt.namt ELSE 0 end) ORGPAIDAMT,
                        sum(CASE WHEN lnt.txcd = '0024' THEN lnt.namt ELSE 0 end) INTPAIDAMT,
                        sum(CASE WHEN lnt.txcd = '0090' THEN lnt.namt ELSE 0 end) FEEPAIDAMT,
                        sum(CASE WHEN lnt.txcd IN ('0017','0027','0083') THEN lnt.namt ELSE 0 end) OVDPAIDAMT,
                        max(lng.lastpaid) lastpaid, MAX(LNT.AUTOID) LNTAUTOID
                    FROM vw_lntran_all lnt,
                        (SELECT lng.txdate, lng.txnum, lng.autoid, max(lng.lastpaid) lastpaid, max(lns.acctno) acctno
                        from vw_lnschdlog_all lng, vw_lnschd_all lns
                        WHERE lng.autoid = lns.autoid AND lns.reftype IN ('P','GP')
                        GROUP BY lng.txdate, lng.txnum, lng.autoid) lng
                    WHERE lnt.txdate = lng.txdate AND lnt.txnum = lng.txnum AND lnt.acctno = lng.acctno
                        AND lnt.tltxcd IN ('2646','2648','2636','2665')
                        AND lnt.txdate = to_date(V_IN_DATE,'DD/MM/YYYY')
                        AND lnt.txcd NOT IN ('0017','0027','0083') -- TheNN bo phan qua han
                    GROUP BY lnt.txdate, /*lnt.txnum,*/ lnt.acctno
                ) lnt
                INNER JOIN
                (
                    SELECT ln.acctno, ln.trfacctno, ln.rlsdate,LNS.overduedate, lns.rate2 LOANRATE, ln.prinperiod LOANPERIOD,
                        ln.prinnml + LN.prinovd prinamt, DECODE(LN.RRTYPE,'C','', NVL(LN.CUSTBANK,'')) CUSTBANK,
                        NVL(CF.FULLNAME,'') BANKNAME, NVL(CF.shortname,'') BANKSHORTNAME,
                        ln.BANKPAIDMETHOD, LNS.FEEINTPAID, LNS.intpaid, LNS.autoid
                    FROM vw_lnmast_all LN, vw_lnschd_all lns, cfmast cf
                    WHERE ln.acctno = lns.acctno AND LN.FTYPE = 'DF' AND LNS.reftype IN ('P','GP')
                        AND LNS.overduedate >= TO_DATE(V_IN_DATE,'DD/MM/YYYY')
                        AND LN.CUSTBANK = CF.CUSTID (+)
                ) ln
                ON lnt.lnacctno = LN.acctno --AND ln.CUSTBANK LIKE V_CUSTBANK
                INNER JOIN
                (
                    SELECT CF.custodycd, AF.acctno, CF.fullname
                    FROM CFMAST CF, AFMAST AF
                    WHERE CF.custid = AF.custid
                    AND AF.ACCTNO LIKE V_AFACCTNO
                    AND CF.CUSTODYCD LIKE V_CUSTODYCD
                ) CF
                ON LN.trfacctno = CF.ACCTNO
                LEFT JOIN
                (
                    SELECT lnt.acctno lnacctno, sum(lnt.namt) ORGPAIDAMT
                    FROM vw_lntran_all lnt
                    WHERE lnt.tltxcd IN ('2646','2648','2636','2665') AND lnt.TXCD ='0014'
                        AND lnt.txdate >= to_date(V_IN_DATE,'DD/MM/YYYY')
                    GROUP BY lnt.acctno
                ) PS
                ON lnt.lnacctno = PS.lnacctno
            UNION ALL
            -- KHOAN VAY DF TOI HAN
            SELECT CF.CUSTODYCD, CF.ACCTNO AFACCTNO, CF.FULLNAME, TO_CHAR(ln.overduedate,'DD/MM/YYYY') TXDATE, LN.overduedate, ln.ACCTNO lnacctno, LN.AUTOID,
                to_char(LN.RLSDATE,'DD/MM/YYYY') RLSDATE,LN.LOANRATE,
                to_date(V_IN_DATE,'DD/MM/YYYY') - ln.rlsdate LOANPERIOD,
                LN.prinamt + NVL(PS.ORGPAIDAMT,0) BE_ORGLNAMT,
                LN.prinamt + NVL(PS.ORGPAIDAMT,0) - NVL(lnt.ORGPAIDAMT,0) ORGPAIDAMT,
                --round(ln.remainint + nvl(ps.INTPAIDAMT,0) - NVL(lnt.INTPAIDAMT,0)) INTPAIDAMT,
                0 INTPAIDAMT,
                --round(ln.remainfee + nvl(ps.FEEPAIDAMT,0) - NVL(lnt.FEEPAIDAMT,0)) FEEPAIDAMT,
                0 FEEPAIDAMT,
                'DF' LOANTYPE,
                CASE WHEN NVL(LNT.OVDPAIDAMT,0) = 0 OR LN.CUSTBANK = '' THEN ln.custbank ELSE 'OVDB' END custbank,
                LN.CUSTBANK CUSTBANKVL, LN.BANKSHORTNAME,
                CASE WHEN NVL(LNT.OVDPAIDAMT,0) = 0 OR LN.CUSTBANK = '' THEN LN.BANKNAME ELSE 'OVDB' END BANKNAME,
                round(CASE WHEN ln.BANKPAIDMETHOD = 'I' THEN ln.remainint + nvl(ps.INTPAIDAMT,0) - NVL(lnt.INTPAIDAMT,0)
                    WHEN ln.BANKPAIDMETHOD = 'A' AND nvl(LNT.lastpaid,'N') = 'Y' THEN 0
                    WHEN ln.BANKPAIDMETHOD = 'A' AND LN.prinamt + NVL(PS.ORGPAIDAMT,0) = 0 THEN 0
                    WHEN ln.BANKPAIDMETHOD = 'A' AND LN.prinamt + NVL(PS.ORGPAIDAMT,0) > 0 THEN round(LN.intpaid + ln.remainint /*+ nvl(ps.INTPAIDAMT,0) - NVL(lnt.INTPAIDAMT,0)*/)
                    --WHEN ln.BANKPAIDMETHOD = 'P' AND NVL(lnt.ORGPAIDAMT,0) = 0 THEN 0
                    WHEN ln.BANKPAIDMETHOD = 'P' /*AND NVL(lnt.ORGPAIDAMT,0) > 0*/ THEN
                        round(ln.remainint + nvl(ps.INTPAIDAMT,0) - NVL(lnt.INTPAIDAMT,0)) +
                            CASE WHEN NVL(lnt.ORGPAIDAMT,0) >0 THEN 0
                                WHEN LN.prinamt + NVL(PS.ORGPAIDAMT,0) - NVL(lnt.ORGPAIDAMT,0) = 0 THEN 0
                                ELSE fn_calc_lnintpaid(LN.autoid, TO_CHAR(LN.overduedate,'DD/MM/YYYY'), NVL(LNT.LNTAUTOID,0), 'DF') /*- NVL(lnt.INTPAIDAMT,0)*/ END
                    ELSE 0 END) BANKINTPAIDAMT,
                /*round(CASE WHEN ln.BANKPAIDMETHOD = 'I' THEN ln.remainfee + nvl(ps.FEEPAIDAMT,0) - NVL(lnt.FEEPAIDAMT,0)
                    WHEN ln.BANKPAIDMETHOD = 'A' THEN LN.FEEINTPAID + round(ln.remainfee + nvl(ps.FEEPAIDAMT,0) - NVL(lnt.FEEPAIDAMT,0))
                    WHEN ln.BANKPAIDMETHOD = 'P' THEN
                        round(ln.remainfee + nvl(ps.FEEPAIDAMT,0) - NVL(lnt.FEEPAIDAMT,0)) + CASE WHEN NVL(lnt.ORGPAIDAMT,0) >0 THEN 0 ELSE fn_calc_lnfeepaid(LN.autoid, TO_CHAR(LN.overduedate,'DD/MM/YYYY'), NVL(LNT.LNTAUTOID,0), 'MR') END
                    ELSE 0 END) BANKFEEPAIDAMT,*/
                ln.remainfee + nvl(ps.FEEPAIDAMT,0) - NVL(lnt.FEEPAIDAMT,0) BANKFEEPAIDAMT,
                ln.BANKPAIDMETHOD, NVL(LNT.lastpaid,'N') LASTPAID
            FROM
            (
                SELECT ln.acctno, ln.trfacctno, ln.rlsdate,LNS.overduedate, lns.rate2 LOANRATE, ln.prinperiod LOANPERIOD,
                    ln.prinnml + LN.prinovd prinamt,
                    lns.intnmlacr+lns.intdue+lns.intovd remainint,
                    lns.feeintnmlacr+lns.feeintnmlovd+lns.feeintdue+lns.feeintnml+lns.feeintovd remainfee,
                    DECODE(LN.RRTYPE,'C','', NVL(LN.CUSTBANK,'')) CUSTBANK,
                    NVL(CF.FULLNAME,'') BANKNAME, NVL(CF.shortname,'') BANKSHORTNAME,
                    ln.BANKPAIDMETHOD, LNS.FEEINTPAID, LNS.intpaid, LNS.autoid
                FROM vw_lnmast_all LN, vw_lnschd_all lns, cfmast cf
                WHERE ln.acctno = lns.acctno AND LN.FTYPE = 'DF' AND LNS.reftype IN ('P','GP')
                    AND LNS.overduedate = TO_DATE(V_IN_DATE,'DD/MM/YYYY')
                    AND LN.custbank IS NOT NULL AND LN.bankpaidmethod <> 'I'
                    AND LN.CUSTBANK = CF.CUSTID (+)
        /*    SELECT lns.autoid, ln.acctno, ln.trfacctno, lns.rlsdate, lns.overduedate, ln.rate2 LOANRATE, ln.prinperiod MRLOANPERIOD,
                    LN.oprinperiod GRLOANPERIOD,
                    lns.nml + lns.ovd MRprinamt, lns.nml + lns.ovd GRPRINAMT,
                    lns.intnmlacr+lns.intdue+lns.intovd+lns.intovdprin remainint,
                    lns.feeintnmlacr+lns.feeintovdacr+lns.feeintnmlovd+lns.feeintdue+lns.feeintnml+lns.feeintovd remainfee,
                    DECODE(LN.RRTYPE,'C','', NVL(LN.CUSTBANK,'')) CUSTBANK, NVL(CF.FULLNAME,'') BANKNAME,
                    ln.BANKPAIDMETHOD, LNS.FEEINTPAID, LNS.intpaid, 'DF' LOANTYPE
                FROM vw_lnmast_all LN, vw_lnschd_all lns, cfmast cf
                WHERE ln.acctno = lns.acctno AND LN.ftype = 'DF'
                    AND LNS.overduedate = TO_DATE(V_IN_DATE,'DD/MM/YYYY')
                    AND LN.custbank IS NOT NULL
                    AND LNS.reftype = 'P'
                    AND LN.CUSTBANK = CF.CUSTID (+)*/

            ) ln
            INNER JOIN
            (
                SELECT CF.custodycd, AF.acctno, CF.fullname
                FROM CFMAST CF, AFMAST AF
                WHERE CF.custid = AF.custid
                  AND AF.ACCTNO LIKE V_AFACCTNO
                 AND CF.CUSTODYCD LIKE V_CUSTODYCD
            ) CF
            ON LN.trfacctno = CF.ACCTNO
            LEFT JOIN
            (
                SELECT lnt.acctno lnacctno,
                    sum(CASE WHEN lnt.txcd = '0014' THEN lnt.namt ELSE 0 end) ORGPAIDAMT,
                                    sum(CASE WHEN lnt.txcd = '0024' THEN lnt.namt ELSE 0 end) INTPAIDAMT,
                                    sum(CASE WHEN lnt.txcd = '0090' THEN lnt.namt ELSE 0 end) FEEPAIDAMT,
                    lnt.acctref lnsautoid
                FROM vw_lntran_all lnt
                WHERE lnt.tltxcd IN ('2646','2648','2636','2665') --AND lnt.TXCD IN ('0014','0065')
                    AND lnt.txdate >= to_date(V_IN_DATE,'DD/MM/YYYY')
                GROUP BY lnt.acctno, lnt.acctref
            ) PS
            ON ln.acctno = PS.lnacctno --AND ln.autoid = ps.lnsautoid
            LEFT JOIN
            (
                SELECT lnt.txdate, lnt.acctno lnacctno, lng.autoid lnsautoid,
                    sum(CASE WHEN lnt.txcd = '0014' THEN lnt.namt ELSE 0 end) ORGPAIDAMT,
                                    sum(CASE WHEN lnt.txcd = '0024' THEN lnt.namt ELSE 0 end) INTPAIDAMT,
                                    sum(CASE WHEN lnt.txcd = '0090' THEN lnt.namt ELSE 0 end) FEEPAIDAMT,
                                    sum(CASE WHEN lnt.txcd IN ('0017','0027','0083') THEN lnt.namt ELSE 0 end) OVDPAIDAMT,
                    max(lng.lastpaid) lastpaid, MAX(LNT.AUTOID) LNTAUTOID
                FROM vw_lntran_all lnt,
                    (SELECT lng.txdate, lng.txnum, lng.autoid, max(lng.lastpaid) lastpaid, max(lns.acctno) acctno
                        from vw_lnschdlog_all lng, vw_lnschd_all lns
                        WHERE lng.autoid = lns.autoid AND lns.reftype IN ('P','GP')
                        GROUP BY lng.txdate, lng.txnum, lng.autoid) lng
                    WHERE lnt.txdate = lng.txdate AND lnt.txnum = lng.txnum AND lnt.acctno = lng.acctno
                    AND lnt.tltxcd IN ('2646','2648','2636','2665') --AND lnt.TXCD IN ('0014','0024','0090')
                    AND lnt.txdate = to_date(V_IN_DATE,'DD/MM/YYYY')
                GROUP BY lnt.txdate, lnt.acctno, lng.autoid
            ) lnt
            ON LN.ACCTNO = LNT.lnacctno AND ln.autoid = lnt.lnsautoid

            UNION ALL
            -- MARGIN & BAO LANH TIEN MUA
            SELECT CF.CUSTODYCD, CF.ACCTNO AFACCTNO, CF.FULLNAME, TO_CHAR(lnt.TXDATE,'DD/MM/YYYY') TXDATE, LN.overduedate, lnt.lnacctno, LN.AUTOID,
                to_char(LN.RLSDATE,'DD/MM/YYYY') RLSDATE,
                DECODE(LN.LOANTYPE,'MR',LN.MRLOANRATE,LN.GRLOANRATE) LOANRATE,
                --DECODE(LNT.LOANTYPE,'MR',LN.MRLOANPERIOD,LN.GRLOANPERIOD) LOANPERIOD,
                to_date(V_IN_DATE,'DD/MM/YYYY') - ln.rlsdate LOANPERIOD,
                DECODE(LN.LOANTYPE,'MR',LN.MRprinamt,LN.GRprinamt) + NVL(PS.ORGPAIDAMT,0) BE_ORGLNAMT, NVL(lnt.ORGPAIDAMT,0) ORGPAIDAMT,
                NVL(lnt.INTPAIDAMT,0) INTPAIDAMT, NVL(lnt.FEEPAIDAMT,0) FEEPAIDAMT, LN.LOANTYPE,
                CASE WHEN NVL(LNT.OVDPAIDAMT,0) = 0 OR LN.CUSTBANK = '' THEN ln.custbank ELSE 'OVDB' END custbank,
                LN.CUSTBANK CUSTBANKVL, LN.BANKSHORTNAME,
                CASE WHEN NVL(LNT.OVDPAIDAMT,0) = 0 OR LN.CUSTBANK = '' THEN LN.BANKNAME ELSE 'OVDB' END BANKNAME,
                CASE WHEN NVL(LNT.OVDPAIDAMT,0) >0 OR ln.BANKPAIDMETHOD = 'I' THEN NVL(lnt.INTPAIDAMT,0)
                    WHEN ln.BANKPAIDMETHOD = 'A' AND LNT.lastpaid = 'N' THEN 0
                    WHEN ln.BANKPAIDMETHOD = 'A' AND LNT.lastpaid = 'Y' THEN LN.intpaid
                    WHEN ln.BANKPAIDMETHOD = 'P' AND NVL(lnt.ORGPAIDAMT,0) = 0 THEN 0
                    WHEN ln.BANKPAIDMETHOD = 'P' AND NVL(lnt.ORGPAIDAMT,0) > 0 THEN
                        fn_calc_lnintpaid(LNT.LNSAUTOID, TO_CHAR(LNT.TXDATE,'DD/MM/YYYY'), LNT.LNTAUTOID, 'MR')
                    ELSE 0 END BANKINTPAIDAMT,
                /*CASE WHEN ln.BANKPAIDMETHOD = 'I' THEN NVL(lnt.FEEPAIDAMT,0)
                    WHEN ln.BANKPAIDMETHOD = 'A' AND LNT.lastpaid = 'N' THEN 0
                    WHEN ln.BANKPAIDMETHOD = 'A' AND LNT.lastpaid = 'Y' THEN LN.FEEINTPAID
                    WHEN ln.BANKPAIDMETHOD = 'P' AND NVL(lnt.ORGPAIDAMT,0) = 0 THEN 0
                    WHEN ln.BANKPAIDMETHOD = 'P' AND NVL(lnt.ORGPAIDAMT,0) > 0 THEN
                        fn_calc_lnfeepaid(LNT.LNSAUTOID, TO_CHAR(LNT.TXDATE,'DD/MM/YYYY'), LNT.LNTAUTOID, 'MR')
                    ELSE 0 END BANKFEEPAIDAMT,*/
                NVL(lnt.FEEPAIDAMT,0) BANKFEEPAIDAMT,
                CASE WHEN NVL(LNT.OVDPAIDAMT,0) >0 THEN 'I' ELSE ln.BANKPAIDMETHOD END BANKPAIDMETHOD, LNT.lastpaid

            FROM
                (
                    SELECT lnt.txdate, /*lnt.txnum, */lnt.acctno lnacctno, lnt.acctref lnsautoid,
                        sum(CASE WHEN lnt.txcd IN ('0014','0065') THEN lnt.namt ELSE 0 end) ORGPAIDAMT,
                        sum(CASE WHEN lnt.txcd IN ('0024','0075') THEN lnt.namt ELSE 0 end) INTPAIDAMT,
                        sum(CASE WHEN lnt.txcd IN ('0090','0073') THEN lnt.namt ELSE 0 end) FEEPAIDAMT,
                        --CASE WHEN SUM(CASE WHEN lnt.txcd IN ('0065','0075','0073') THEN lnt.namt ELSE 0 end) > 0 THEN 'GR' ELSE 'MR' END LOANTYPE,
                        SUM(CASE WHEN lnt.txcd IN ('0017','0027','0058','0060','0066','0083') THEN lnt.namt ELSE 0 end) OVDPAIDAMT,
                        max(lng.lastpaid) lastpaid, MAX(LNT.AUTOID) LNTAUTOID
                    FROM vw_lntran_all lnt,
                        (SELECT lng.txdate, lng.txnum, lng.autoid, max(lng.lastpaid) lastpaid
                        from vw_lnschdlog_all lng
                        GROUP BY lng.txdate, lng.txnum, lng.autoid) lng
                    WHERE lnt.txdate = lng.txdate AND lnt.txnum = lng.txnum AND lnt.acctref = lng.autoid
                        AND lnt.tltxcd IN ('5540','5567') --AND lnt.TXCD IN ('0014','0024','0090')
                        AND lnt.txdate = to_date(V_IN_DATE,'DD/MM/YYYY')
                        AND lnt.txcd NOT IN ('0017','0027','0058','0060','0066','0083') -- TheNN bo phan qua han
                    GROUP BY lnt.txdate, /*lnt.txnum, */lnt.acctno, lnt.acctref
                ) lnt
                INNER JOIN
                (
                    SELECT lns.autoid, ln.acctno, ln.trfacctno, lns.rlsdate, LNS.overduedate, lns.rate2 MRLOANRATE, ln.prinperiod MRLOANPERIOD,
                        LN.orate2 GRLOANRATE, LN.oprinperiod GRLOANPERIOD,
                        lns.nml + lns.ovd MRprinamt, lns.nml + lns.ovd GRPRINAMT,
                        DECODE(LN.RRTYPE,'C','', NVL(LN.CUSTBANK,'')) CUSTBANK, NVL(CF.FULLNAME,'') BANKNAME,
                        ln.BANKPAIDMETHOD, LNS.FEEINTPAID, LNS.intpaid, NVL(CF.shortname,'') BANKSHORTNAME,
                        decode(lns.reftype,'P','MR','GP','GR','MR') LOANTYPE
                    FROM vw_lnmast_all LN, vw_lnschd_all lns, cfmast cf
                    WHERE ln.acctno = lns.acctno AND LN.FTYPE = 'AF' AND LNS.reftype IN ('P','GP')
                        AND LNS.overduedate >= TO_DATE(V_IN_DATE,'DD/MM/YYYY')
                        AND LN.CUSTBANK = CF.CUSTID (+)
                ) ln
                ON lnt.lnacctno = LN.acctno AND lnt.lnsautoid = ln.autoid --AND ln.CUSTBANK LIKE V_CUSTBANK
                INNER JOIN
                (
                    SELECT CF.custodycd, AF.acctno, CF.fullname
                    FROM CFMAST CF, AFMAST AF
                    WHERE CF.custid = AF.custid
                     AND AF.ACCTNO LIKE V_AFACCTNO
                    AND CF.CUSTODYCD LIKE V_CUSTODYCD
                ) CF
                ON LN.trfacctno = CF.ACCTNO
                LEFT JOIN
                (
                    SELECT lnt.acctno lnacctno, sum(lnt.namt) ORGPAIDAMT, lnt.acctref lnsautoid
                    FROM vw_lntran_all lnt
                    WHERE lnt.tltxcd IN ('5540','5567') AND lnt.TXCD IN ('0014','0065')
                        AND lnt.txdate >= to_date(V_IN_DATE,'DD/MM/YYYY')
                    GROUP BY lnt.acctno, lnt.acctref
                ) PS
                ON lnt.lnacctno = PS.lnacctno AND lnt.lnsautoid = ps.lnsautoid
            UNION ALL
            -- KHOAN VAY MR/CL TOI HAN
            SELECT CF.CUSTODYCD, CF.ACCTNO AFACCTNO, CF.FULLNAME, TO_CHAR(ln.overduedate,'DD/MM/YYYY') TXDATE, LN.overduedate, ln.ACCTNO lnacctno, LN.AUTOID,
                to_char(LN.RLSDATE,'DD/MM/YYYY') RLSDATE,
                DECODE(LN.LOANTYPE,'MR',LN.MRLOANRATE,LN.GRLOANRATE) LOANRATE,
                to_date(V_IN_DATE,'DD/MM/YYYY') - ln.rlsdate LOANPERIOD,
                DECODE(LN.LOANTYPE,'MR',LN.MRprinamt,LN.GRprinamt) + NVL(PS.ORGPAIDAMT,0) BE_ORGLNAMT,
                DECODE(LN.LOANTYPE,'MR',LN.MRprinamt,LN.GRprinamt) + NVL(PS.ORGPAIDAMT,0) - NVL(lnt.ORGPAIDAMT,0) ORGPAIDAMT,
                --round(ln.remainint + nvl(ps.INTPAIDAMT,0) - NVL(lnt.INTPAIDAMT,0)) INTPAIDAMT,
                0 INTPAIDAMT,
                --round(ln.remainfee + nvl(ps.FEEPAIDAMT,0) - NVL(lnt.FEEPAIDAMT,0)) FEEPAIDAMT,
                0 FEEPAIDAMT,
                LN.LOANTYPE,
                CASE WHEN NVL(LNT.OVDPAIDAMT,0) = 0 OR LN.CUSTBANK = '' THEN ln.custbank ELSE 'OVDB' END custbank,
                LN.CUSTBANK CUSTBANKVL, LN.BANKSHORTNAME,
                CASE WHEN NVL(LNT.OVDPAIDAMT,0) = 0 OR LN.CUSTBANK = '' THEN LN.BANKNAME ELSE 'OVDB' END BANKNAME,
                round(CASE WHEN ln.BANKPAIDMETHOD = 'I' THEN ln.remainint + nvl(ps.INTPAIDAMT,0) - NVL(lnt.INTPAIDAMT,0)
                    WHEN ln.BANKPAIDMETHOD = 'A' AND nvl(LNT.lastpaid,'N') = 'Y' THEN 0
                    WHEN ln.BANKPAIDMETHOD = 'A' AND DECODE(LN.LOANTYPE,'MR',LN.MRprinamt,LN.GRprinamt) + NVL(PS.ORGPAIDAMT,0) = 0 THEN 0
                    WHEN ln.BANKPAIDMETHOD = 'A' AND DECODE(LN.LOANTYPE,'MR',LN.MRprinamt,LN.GRprinamt) + NVL(PS.ORGPAIDAMT,0) > 0 THEN round(LN.intpaid + ln.remainint/* + nvl(ps.INTPAIDAMT,0) - NVL(lnt.INTPAIDAMT,0)*/)
                    --WHEN ln.BANKPAIDMETHOD = 'P' AND NVL(lnt.ORGPAIDAMT,0) = 0 THEN 0
                    WHEN ln.BANKPAIDMETHOD = 'P' /*AND NVL(lnt.ORGPAIDAMT,0) > 0*/ THEN
                        round(ln.remainint + nvl(ps.INTPAIDAMT,0) - NVL(lnt.INTPAIDAMT,0)) +
                            CASE WHEN NVL(lnt.ORGPAIDAMT,0) >0 THEN 0
                                 WHEN DECODE(LN.LOANTYPE,'MR',LN.MRprinamt,LN.GRprinamt) + NVL(PS.ORGPAIDAMT,0) - NVL(lnt.ORGPAIDAMT,0) = 0 THEN 0
                                 else fn_calc_lnintpaid(LN.autoid, TO_CHAR(LN.overduedate,'DD/MM/YYYY'), NVL(LNT.LNTAUTOID,0), 'MR')/* - NVL(lnt.INTPAIDAMT,0)*/ END
                    ELSE 0 END) BANKINTPAIDAMT,
                /*round(CASE WHEN ln.BANKPAIDMETHOD = 'I' THEN ln.remainfee + nvl(ps.FEEPAIDAMT,0) - NVL(lnt.FEEPAIDAMT,0)
                    WHEN ln.BANKPAIDMETHOD = 'A' THEN LN.FEEINTPAID + round(ln.remainfee + nvl(ps.FEEPAIDAMT,0) - NVL(lnt.FEEPAIDAMT,0))
                    WHEN ln.BANKPAIDMETHOD = 'P' THEN
                        round(ln.remainfee + nvl(ps.FEEPAIDAMT,0) - NVL(lnt.FEEPAIDAMT,0)) + CASE WHEN NVL(lnt.ORGPAIDAMT,0) >0 THEN 0 ELSE fn_calc_lnfeepaid(LN.autoid, TO_CHAR(LN.overduedate,'DD/MM/YYYY'), NVL(LNT.LNTAUTOID,0), 'MR') END
                    ELSE 0 END) BANKFEEPAIDAMT,*/
                ln.remainfee + nvl(ps.FEEPAIDAMT,0) - NVL(lnt.FEEPAIDAMT,0) BANKFEEPAIDAMT,
                ln.BANKPAIDMETHOD, NVL(LNT.lastpaid,'N') LASTPAID
            FROM
            (
                SELECT lns.autoid, ln.acctno, ln.trfacctno, lns.rlsdate, lns.overduedate, lns.rate2 MRLOANRATE, ln.prinperiod MRLOANPERIOD,
                    LN.orate2 GRLOANRATE, LN.oprinperiod GRLOANPERIOD,
                    lns.nml + lns.ovd MRprinamt, lns.nml + lns.ovd GRPRINAMT,
                    lns.intnmlacr+lns.intdue+lns.intovd remainint,
                    lns.feeintnmlacr+lns.feeintnmlovd+lns.feeintdue+lns.feeintnml+lns.feeintovd remainfee,
                    DECODE(LN.RRTYPE,'C','', NVL(LN.CUSTBANK,'')) CUSTBANK, NVL(CF.FULLNAME,'') BANKNAME,
                    NVL(CF.shortname,'') BANKSHORTNAME,
                    ln.BANKPAIDMETHOD, LNS.FEEINTPAID, LNS.intpaid, decode(lns.reftype,'P','MR','GP','GR','MR') LOANTYPE
                FROM vw_lnmast_all LN, vw_lnschd_all lns, cfmast cf
                WHERE ln.acctno = lns.acctno
                    AND LNS.overduedate = TO_DATE(V_IN_DATE,'DD/MM/YYYY')
                    AND LN.custbank IS NOT NULL AND LN.bankpaidmethod <> 'I'
                    AND LN.FTYPE = 'AF' AND LNS.reftype IN ('P','GP')
                    AND LN.CUSTBANK = CF.CUSTID (+)

            ) ln
            INNER JOIN
            (
                SELECT CF.custodycd, AF.acctno, CF.fullname
                FROM CFMAST CF, AFMAST AF
                WHERE CF.custid = AF.custid
                 AND AF.ACCTNO LIKE V_AFACCTNO
                 AND CF.CUSTODYCD LIKE V_CUSTODYCD
            ) CF
            ON LN.trfacctno = CF.ACCTNO
            LEFT JOIN
            (
                SELECT lnt.acctno lnacctno,
                    sum(CASE WHEN lnt.txcd IN ('0014','0065') THEN lnt.namt ELSE 0 end) ORGPAIDAMT,
                    sum(CASE WHEN lnt.txcd IN ('0024','0075') THEN lnt.namt ELSE 0 end) INTPAIDAMT,
                    sum(CASE WHEN lnt.txcd IN ('0090','0073') THEN lnt.namt ELSE 0 end) FEEPAIDAMT,
                    lnt.acctref lnsautoid
                FROM vw_lntran_all lnt
                WHERE lnt.tltxcd IN ('5540','5567') --AND lnt.TXCD IN ('0014','0065')
                    AND lnt.txdate >= to_date(V_IN_DATE,'DD/MM/YYYY')
                GROUP BY lnt.acctno, lnt.acctref
            ) PS
            ON ln.acctno = PS.lnacctno AND ln.autoid = ps.lnsautoid
            LEFT JOIN
            (
                SELECT lnt.txdate, lnt.acctno lnacctno, lnt.acctref lnsautoid,
                    sum(CASE WHEN lnt.txcd IN ('0014','0065') THEN lnt.namt ELSE 0 end) ORGPAIDAMT,
                    sum(CASE WHEN lnt.txcd IN ('0024','0075') THEN lnt.namt ELSE 0 end) INTPAIDAMT,
                    sum(CASE WHEN lnt.txcd IN ('0090','0073') THEN lnt.namt ELSE 0 end) FEEPAIDAMT,
                    --CASE WHEN SUM(CASE WHEN lnt.txcd IN ('0065','0075','0073') THEN lnt.namt ELSE 0 end) > 0 THEN 'GR' ELSE 'MR' END LOANTYPE,
                    SUM(CASE WHEN lnt.txcd IN ('0017','0027','0058','0060','0066','0083') THEN lnt.namt ELSE 0 end) OVDPAIDAMT,
                    max(lng.lastpaid) lastpaid, MAX(LNT.AUTOID) LNTAUTOID
                FROM vw_lntran_all lnt,
                    (SELECT lng.txdate, lng.txnum, lng.autoid, max(lng.lastpaid) lastpaid
                    from vw_lnschdlog_all lng
                    GROUP BY lng.txdate, lng.txnum, lng.autoid) lng
                WHERE lnt.txdate = lng.txdate AND lnt.txnum = lng.txnum AND lnt.acctref = lng.autoid
                    AND lnt.tltxcd IN ('5540','5567') --AND lnt.TXCD IN ('0014','0024','0090')
                    AND lnt.txdate = to_date(V_IN_DATE,'DD/MM/YYYY')
                GROUP BY lnt.txdate, lnt.acctno, lnt.acctref
            ) lnt
            ON LN.ACCTNO = LNT.lnacctno AND ln.autoid = lnt.lnsautoid
        ) A
        WHERE A.LOANTYPE LIKE V_SVTYPE
            AND nvl(A.BANKSHORTNAME,'-') LIKE V_CUSTBANK
            AND (SUBSTR(A.AFACCTNO,1,4) LIKE V_STRBRID OR INSTR(V_STRBRID,SUBSTR(A.AFACCTNO,1,4)) >0)
            AND A.ORGPAIDAMT >=0
            /*AND CASE WHEN A.BANKPAIDMETHOD = 'I' THEN A.ORGPAIDAMT+A.BANKINTPAIDAMT+A.BANKFEEPAIDAMT
                                                ELSE A.ORGPAIDAMT END > 0*/
        GROUP BY A.TXDATE, A.LNACCTNO, A.AUTOID, A.RLSDATE
        HAVING CASE WHEN MAX(A.BANKPAIDMETHOD) = 'I' THEN SUM(A.ORGPAIDAMT+A.BANKINTPAIDAMT+A.BANKFEEPAIDAMT)
                                                ELSE SUM(A.ORGPAIDAMT) END > 0
        ORDER BY MAX(A.custodycd), MAX(A.AFACCTNO), A.RLSDATE, A.lnacctno;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

