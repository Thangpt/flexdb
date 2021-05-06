CREATE OR REPLACE PROCEDURE ln1007_3 (
   PV_REFCURSOR     IN OUT   PKG_REPORT.REF_CURSOR,
   OPT              IN       VARCHAR2,
   BRID             IN       VARCHAR2,
   I_DATE           IN       VARCHAR2,
   CUSTBANK         IN       VARCHAR2,
   SERVICETYPE      IN       VARCHAR2,
   PV_CUSTODYCD     IN       VARCHAR2,
   PV_AFACCTNO      IN       VARCHAR2
       )
IS

-- ---------    ------      -------------------------------------------

    V_STROPTION         VARCHAR2  (5);
    V_STRBRID           VARCHAR2(100);
    V_CUSTBANK          varchar2(10);
    V_SVTYPE            VARCHAR2(5);
    V_IN_DATE           VARCHAR2(15);
    V_SIGNTYPE          VARCHAR2(10);
    V_BRID              VARCHAR2(4);
    V_CUSTODYCD         VARCHAR2(10);
    V_AFACCTNO          VARCHAR2(10);
    l_INITRLSDATE       date;
    l_CUSTBANK          VARCHAR2(15);
BEGIN
    -- GET REPORT'S PARAMETERS
    l_CUSTBANK := CUSTBANK;
    V_STROPTION := OPT;
    V_BRID := BRID;

    IF V_STROPTION = 'A' THEN
        V_STRBRID := '%%';
    ELSIF V_STROPTION = 'B' AND V_BRID <> 'ALL' AND V_BRID IS NOT NULL THEN
        SELECT MAPID INTO V_STRBRID FROM BRGRP WHERE BRID = V_BRID;
    ELSIF V_STROPTION = 'S' AND V_BRID <> 'ALL' AND V_BRID IS NOT NULL THEN
        V_STRBRID := V_BRID;
    ELSE
        V_STRBRID := V_BRID;
    END IF;

    V_IN_DATE := I_DATE;


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

    IF CUSTBANK = 'ALL' OR CUSTBANK IS NULL THEN
        V_CUSTBANK := '%%';
    ELSE
        V_CUSTBANK := CUSTBANK;
    END IF;

    IF SERVICETYPE = 'ALL' OR SERVICETYPE IS NULL THEN
        V_SVTYPE := '%%';
    ELSE
        V_SVTYPE := SERVICETYPE;
    END IF;

    select nvl(min(rlsdate),to_date(V_IN_DATE,'DD/MM/RRRR')+1) into l_INITRLSDATE from rlsrptlog_eod;

    OPEN PV_REFCURSOR FOR

    SELECT fullname khachhang, custodycd, contractno, bankacctno, lnprin amtad, orgpaidamt paidamt,  han_muc_thau_chi limitamt,
        rlsdate txdate, (SELECT max(sbdate) ovddate FROM sbcldr sb WHERE sb.sbdate <= to_date(rlsdate,'DD/MM/RRRR')+90 AND sb.holiday = 'Y' AND sb.cldrtype = '000') cleardt, txdate tx2

    FROM
    (
        SELECT
        a.custodycd, a.afacctno, a.fullname, a.txdate, a.lnacctno, a.rlsdate, a.custbank, a.bankname, a.bankshortname,
        a.contractno, a.bankacctno, a.overduedate
       , max(a.nml) lnprin
       , sum(a.orgpaidamt) orgpaidamt
       , case when a.rrtype = 'B' then 20000000000 else 0 end han_muc_thau_chi
        FROM
        (

            -- MARGIN & BAO LANH TIEN MUA
            SELECT CF.CUSTODYCD, CF.ACCTNO AFACCTNO, CF.FULLNAME, TO_CHAR(lnt.TXDATE,'DD/MM/YYYY') TXDATE, lnt.lnacctno
                , to_char(LN.RLSDATE,'DD/MM/YYYY') RLSDATE
                , NVL(lnt.ORGPAIDAMT,0) ORGPAIDAMT
                , LNT.LOANTYPE
                , CASE WHEN NVL(LNT.OVDPAIDAMT,0) = 0 or ln.custbank = 'KBSV' THEN ln.custbank ELSE ln.custbank || '-OVDB' END custbank
                , CASE WHEN NVL(LNT.OVDPAIDAMT,0) = 0 THEN LN.BANKNAME ELSE LN.BANKNAME END BANKNAME
                , LN.BANKSHORTNAME
                , contractno, bankacctno
                , (select to_char(max(sbdate),'DD/MM/RRRR') from sbcldr where cldrtype = '000' and holiday = 'N' and sbdate <= ln.rlsdate + 180 ) overduedate --fix TPBANK mac dinh la ky han 6 thang
                , ln.rrtype
                , ln.nml nml
            FROM
                (
                    SELECT lnt.txdate, lnt.acctno lnacctno, lnt.acctref lnsautoid,
                        sum(CASE WHEN lnt.txcd IN ('0014','0065') THEN lnt.namt ELSE 0 end) ORGPAIDAMT,
                        sum(CASE WHEN lnt.txcd IN ('0024','0075') THEN lnt.namt ELSE 0 end) INTPAIDAMT,
                        sum(CASE WHEN lnt.txcd IN ('0019') THEN lnt.namt ELSE 0 end) P_INTPAIDAMT,
                        sum(CASE WHEN lnt.txcd IN ('0090','0073') THEN lnt.namt ELSE 0 end) FEEPAIDAMT,
                        CASE WHEN SUM(CASE WHEN lnt.txcd IN ('0065','0075','0073') THEN lnt.namt ELSE 0 end) > 0 THEN 'GR' ELSE 'MR' END LOANTYPE,
                        SUM(CASE WHEN lnt.txcd IN ('0017','0027','0058','0060','0066','0083') THEN lnt.namt ELSE 0 end) OVDPAIDAMT
                    FROM vw_lntran_all lnt
                    WHERE lnt.tltxcd IN ('5540','5567') --AND lnt.TXCD IN ('0014','0024','0090')
                        AND lnt.txdate = to_date(V_IN_DATE,'DD/MM/YYYY')
                    GROUP BY lnt.txdate, lnt.acctno, lnt.acctref
                ) lnt
                INNER JOIN
                (
                    SELECT lns.autoid, ln.acctno, ln.trfacctno, lns.rlsdate,
                        DECODE(LN.RRTYPE,'C','KBSV', LN.CUSTBANK) CUSTBANK, b.FULLNAME BANKNAME ,b.shortname BANKSHORTNAME
                        ,ln.ftype, ln.rrtype, lns.reftype reftypecd, b.contractno, b.bankacctno, lns.overduedate
                        , l.nml
                    FROM vw_lnmast_all LN, vw_lnschd_all lns, cfmast cfb,
                        (
                            SELECT b.*, cf.custid, cf.shortname, cf.fullname FROM bankcontractinfo b, cfmast cf
                            WHERE b.bankcode = cf.shortname AND b.typecont ='DFMR'
                        ) b,
                        (select ln.trfacctno, ln.rrtype, sum(llog.nml) nml, ln.custbank, ls.autoid from
                           vw_lnschd_all ls, vw_lnmast_all ln,
                           (select autoid, sum(nml+ovd) nml from VW_LNSCHDLOG_ALL
                           where to_date(txdate,'DD/MM/RRRR') <= to_date(V_IN_DATE,'DD/MM/RRRR')
                           group by autoid
                           ) llog
                           where ls.acctno = ln.acctno and  ls.autoid = llog.autoid(+)
                                AND ls.reftype NOT IN ('I','GI')
                           group by ln.trfacctno, ln.rrtype, ln.custbank, ls.autoid
                        ) l
                    WHERE ln.acctno = lns.acctno AND ln.custbank = cfb.custid(+)
                        AND LN.CUSTBANK = b.CUSTID(+)
                        and ln.trfacctno = b.acctno(+) and lns.autoid = l.autoid (+)
                        --and ln.rrtype = l.rrtype (+) AND ln.custbank = l.custbank (+)
                        and case when l_CUSTBANK = 'ALL' then 1
                            when l_CUSTBANK = 'KBSV' and l.rrtype = 'C' then 1
                            when cfb.shortname = l_CUSTBANK and l.rrtype = 'B' then 1
                        else 0 end = 1
                ) ln
                ON lnt.lnacctno = LN.acctno AND lnt.lnsautoid = ln.autoid
                INNER JOIN
                (
                    SELECT CF.custodycd, AF.acctno, CF.fullname
                    FROM CFMAST CF, AFMAST AF
                    WHERE CF.custid = AF.custid
                    AND AF.ACCTNO LIKE V_AFACCTNO
                    AND CF.CUSTODYCD LIKE V_CUSTODYCD
                ) CF
                ON LN.trfacctno = CF.ACCTNO
        ) A
        WHERE A.LOANTYPE LIKE V_SVTYPE
            AND (SUBSTR(A.AFACCTNO,1,4) LIKE V_STRBRID OR INSTR(V_STRBRID,SUBSTR(A.AFACCTNO,1,4)) >0)
        group by  a.custodycd, a.afacctno, a.fullname, a.txdate, a.lnacctno, a.rlsdate, a.custbank, a.bankname, a.bankshortname,
        a.contractno, a.bankacctno, a.overduedate, case when a.rrtype = 'B' then 20000000000 else 0 end
        ORDER BY A.custodycd, A.AFACCTNO, A.RLSDATE, A.lnacctno
    )
;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

