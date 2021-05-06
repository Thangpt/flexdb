CREATE OR REPLACE PROCEDURE ln1008 (
   PV_REFCURSOR     IN OUT   PKG_REPORT.REF_CURSOR,
   OPT              IN       VARCHAR2,
   BRID             IN       VARCHAR2,
   F_DATE           in       varchar2,
   T_DATE           in      varchar2,
   CUSTBANK         IN      VARCHAR2,
   --SERVICETYPE      IN       VARCHAR2,
   SIGNTYPE         IN      VARCHAR2,
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

    V_SIGNTYPE          VARCHAR2(10);
    V_BRID              VARCHAR2(4);
    V_CUSTODYCD       VARCHAR2(10);
    V_AFACCTNO         VARCHAR2(10);

BEGIN
    -- GET REPORT'S PARAMETERS
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


    V_SIGNTYPE := SIGNTYPE;

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

    /*IF SERVICETYPE = 'ALL' OR SERVICETYPE IS NULL THEN
        V_SVTYPE := '%%';
    ELSE
        V_SVTYPE := SERVICETYPE;
    END IF;*/

    OPEN PV_REFCURSOR FOR
         SELECT A.*, V_SIGNTYPE SIGNER
        FROM
        (
            -- MARGIN & BAO LANH TIEN MUA
            SELECT CF.CUSTODYCD, CF.ACCTNO AFACCTNO, CF.FULLNAME, ln.autoid lnacctno,
                to_char(LN.RLSDATE,'DD/MM/YYYY') RLSDATE,
                LN.MRLOANRATE LOANRATE,
                CUST_LOANRATE, P_LOANRATE,
                --DECODE(LNT.LOANTYPE,'MR',LN.MRLOANPERIOD,LN.GRLOANPERIOD) LOANPERIOD,
                --lnt.txdate - ln.rlsdate LOANPERIOD,
                orgprinamt BE_ORGLNAMT--DECODE(LNT.LOANTYPE,'MR',LN.MRprinamt,LN.GRprinamt) /*+ NVL(PS.ORGPAIDAMT,0)*/ BE_ORGLNAMT
                , sum(NVL(lnt.ORGPAIDAMT,0)) ORGPAIDAMT,
                sum(NVL(lnt.INTPAIDAMT,0)) INTPAIDAMT,
                sum(NVL(lnt.P_INTPAIDAMT,0)) P_INTPAIDAMT,
                sum(NVL(lnt.FEEPAIDAMT,0)) FEEPAIDAMT,
                /*ln.intnmlacrbank +*/ sum(nvl(lg.acrbank,0)) IntCtoB,
                ln.intfeeamt - sum(nvl(lg.mov_intfeeamt,0)) intfeeamt,
                --'Margin' LOANTYPE,
                CASE WHEN  ln.custbank is null THEN 'KBSV' ELSE ln.custbank  END custbank,
                CASE WHEN ln.custbank is null THEN 'KBSV' ELSE LN.BANKNAME END BANKNAME,
                LN.BANKSHORTNAME
            FROM
                (
                    SELECT lns.autoid, ln.acctno, ln.trfacctno, lns.rlsdate,
                        lns.rate2 MRLOANRATE,
                        case when lns.ispaybank = 'Y' then lns.rate1 else lns.rate2 end CUST_LOANRATE,
                        GREATEST(lns.rate2 - lns.rate1, 0) P_LOANRATE,
                        ln.prinperiod MRLOANPERIOD,
                        LN.rate2 GRLOANRATE,
                        LN.oprinperiod GRLOANPERIOD,
                        lns.nml + lns.ovd + lns.paid orgprinamt,
                        lns.nml + lns.ovd MRprinamt, lns.nml + lns.ovd GRPRINAMT,
                        DECODE(LN.RRTYPE,'C','KBSV', NVL(LN.CUSTBANK,'KBSV')) CUSTBANK, NVL(CF.FULLNAME,'KBSV') BANKNAME ,NVL(CF.shortname,'KBSV') BANKSHORTNAME,
                         lns.intnmlacr + lns.intdue + lns.intovd + lns.intovdprin --intamt,
                         + lns.feeintnmlacr + lns.feeintdue + lns.feeintnmlovd + lns.feeintovdacr+lns.feeovd -- feeamt
                          intfeeamt,
                         lns.intnmlacrbank  --lai cty tra ho
                    FROM vw_lnmast_all LN, vw_lnschd_all lns, cfmast cf
                    WHERE ln.acctno = lns.acctno and lns.reftype in ('P') --chi lay margin
                        AND LN.CUSTBANK = CF.CUSTID (+)
                         AND lns.rlsdate between to_date(F_DATE,'DD/MM/YYYY') and to_date(T_DATE,'DD/MM/YYYY')
                 ) ln
                 left join
                (
                    SELECT /*lnt.txdate,*/ lnt.acctno lnacctno, lnt.acctref lnsautoid,
                        sum(CASE WHEN lnt.txcd IN ('0014','0065') THEN lnt.namt ELSE 0 end) ORGPAIDAMT,
                        sum(CASE WHEN lnt.txcd IN ('0024','0075') THEN lnt.namt ELSE 0 end) INTPAIDAMT,
                        sum(CASE WHEN lnt.txcd IN ('0019') THEN lnt.namt ELSE 0 end) P_INTPAIDAMT,
                        sum(CASE WHEN lnt.txcd IN ('0090','0073') THEN lnt.namt ELSE 0 end) FEEPAIDAMT,
                        CASE WHEN SUM(CASE WHEN lnt.txcd IN ('0065','0075','0073') THEN lnt.namt ELSE 0 end) > 0 THEN 'GR' ELSE 'MR' END LOANTYPE,
                        SUM(CASE WHEN lnt.txcd IN ('0017','0027','0058','0060','0066','0083') THEN lnt.namt ELSE 0 end) OVDPAIDAMT
                    FROM vw_lntran_all lnt
                    WHERE lnt.tltxcd IN ('5540','5567') --AND lnt.TXCD IN ('0014','0024','0090')
                      AND lnt.txdate between to_date(F_DATE,'DD/MM/YYYY') and to_date(T_DATE,'DD/MM/YYYY')
                    GROUP BY /*lnt.txdate, lnt.txnum,*/ lnt.acctno, lnt.acctref
                ) lnt
                ON LN.acctno = lnt.lnacctno   AND ln.autoid = lnt.lnsautoid
                left join
                (select autoid, /*txdate,*/ --sum(nml) nml, sum(ovd) ovd, sum(paid) paid,
                                sum (case when lg.txdate > to_date(T_DATE,'DD/MM/RRRR')
                                    then  (intnmlacr + intdue + intovd + intovdprin + feeintnmlacr + feeintdue + feeintovd + feeintovdprin + feeovd)
                                    else 0 end) mov_intfeeamt,
                                sum(case when lg.txdate between to_date(F_DATE,'DD/MM/YYYY') and to_date(T_DATE,'DD/MM/YYYY')
                                            and intnmlacrbank > 0 then intnmlacrbank
                                     else 0 end) acrbank
                        from (select * from lnschdlog union all select * from lnschdloghist) lg
                        where lg.txdate >= to_date(F_DATE,'DD/MM/RRRR')
                        group by autoid/*, txdate*/)
                lg on ln.autoid = lg.autoid
                INNER JOIN
                (
                    SELECT CF.custodycd, AF.acctno, CF.fullname
                    FROM CFMAST CF, AFMAST AF
                    WHERE CF.custid = AF.custid
                    AND AF.ACCTNO LIKE V_AFACCTNO
                    AND CF.CUSTODYCD LIKE V_CUSTODYCD
                ) CF
                ON LN.trfacctno = CF.ACCTNO
                group by CF.CUSTODYCD, CF.ACCTNO, CF.FULLNAME,  ln.autoid ,
                to_char(LN.RLSDATE,'DD/MM/YYYY') ,
                LN.MRLOANRATE ,
                CUST_LOANRATE, P_LOANRATE,
                ln.intfeeamt, ln.intnmlacrbank,
                ln.rlsdate ,
                orgprinamt ,
                --LNT.LOANTYPE,
                CASE WHEN  ln.custbank is null THEN 'KBSV' ELSE ln.custbank  END ,
                CASE WHEN ln.custbank is null THEN 'KBSV' ELSE LN.BANKNAME END  ,
                LN.BANKSHORTNAME
        ) A
        WHERE  A.BANKSHORTNAME LIKE V_CUSTBANK
            AND (SUBSTR(A.AFACCTNO,1,4) LIKE V_STRBRID OR INSTR(V_STRBRID,SUBSTR(A.AFACCTNO,1,4)) >0)
        ORDER BY  A.AFACCTNO, A.RLSDATE, A.lnacctno;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

