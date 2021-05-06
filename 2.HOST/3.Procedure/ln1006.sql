CREATE OR REPLACE PROCEDURE ln1006 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   p_OPT            IN       VARCHAR2,
   p_BRID           IN       VARCHAR2,
   p_I_DATE         IN       VARCHAR2,
   p_BANKNAME       IN       VARCHAR2,
   p_LOANTYPE       IN       VARCHAR2,
   --p_SIGNTYPE       IN       VARCHAR2,
   PV_CUSTODYCD     IN       VARCHAR2,
   PV_AFACCTNO      IN       VARCHAR2
       )
IS

-- RP NAME : Giai Ngan Tien Vay
-- PERSON : LinhLNB
-- DATE : 04/04/2012
-- COMMENTS : Create New
-- ---------   ------  -------------------------------------------
l_LOANTYPE varchar2(100);
l_BANKNAME varchar2(100);
l_OPT varchar2(10);
l_BRID varchar2(1000);
l_BRID_FILTER varchar2(1000);
l_INITRLSDATE date;
 V_CUSTODYCD       VARCHAR2(10);
 V_AFACCTNO         VARCHAR2(10);
  V_BRID              VARCHAR2(4);
BEGIN
-- GET REPORT'S PARAMETERS
l_BANKNAME:=p_BANKNAME; -- ALL, KBSV, CF.SHORTNAME

l_LOANTYPE:=p_LOANTYPE; -- ALL, BL, CL, DF

l_OPT:=p_OPT;

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

IF (l_OPT = 'A') THEN
  l_BRID_FILTER := '%';
ELSE if (l_OPT = 'B') then
        select brgrp.mapid into l_BRID_FILTER from brgrp where brgrp.brid = p_BRID;
    else
        l_BRID_FILTER := p_BRID;
    end if;
END IF;

select nvl(min(rlsdate),to_date(p_I_DATE,'DD/MM/RRRR')+1) into l_INITRLSDATE from rlsrptlog_eod;

-- GET REPORT'S DATA
if to_date(p_I_DATE,'DD/MM/RRRR') >= l_INITRLSDATE then
    OPEN PV_REFCURSOR
     FOR
    select p_BRID hs_chinhanh,
            cf.custodycd, cf.idcode, to_char(cf.iddate,'DD/MM/RRRR') iddate, cf.idplace, l.afacctno,
           cf.fullname, b.contractno, b.bankacctno,
            l.rlsamt lnamt, l.totalprinamt lnprin
           , --to_char(l.overduedate,'DD/MM/RRRR') overduedate
            (select to_char(max(sbdate),'DD/MM/RRRR') from sbcldr where cldrtype = '000' and holiday = 'N' and sbdate <= l.rlsdate + (CASE WHEN l.rlsdate >= '04-Aug-2017' THEN 90 ELSE 180 END) ) overduedate --fix TPBANK mac dinh la ky han 6 thang
           , l.rlsdate,
            p_BRID BRID , l_BANKNAME  Nguon_GN
            , ln.rate2

    from rlsrptlog_eod l, cfmast cf, cfmast cfb, vw_lnmast_all ln, vw_lnschd_all ls,
        (
            SELECT b.*, cf.custid, cf.shortname, cf.fullname FROM bankcontractinfo b, cfmast cf
            WHERE b.bankcode = cf.shortname AND b.typecont ='DFMR'
        ) b
    where l.custid = cf.custid
        and l.custbank = cfb.custid(+)
        and l.custbank = b.custid(+)
        and ln.acctno = ls.acctno
        and ls.autoid = l.lnschdid
        and l.afacctno = b.acctno (+)
        AND L.AFACCTNO LIKE V_AFACCTNO
        AND CF.CUSTODYCD LIKE V_CUSTODYCD
        and l.rlsdate = to_date(p_I_DATE,'DD/MM/RRRR')
        and case when l_OPT = 'A' then 1 else instr(l_BRID_FILTER,substr(afacctno,1,4)) end  <> 0
        and case when l_BANKNAME = 'ALL' then 1
                when l_BANKNAME = 'KBSV' and l.rrtype = 'C' then 1
                when cfb.shortname = l_BANKNAME and l.rrtype = 'B' then 1
            else 0 end = 1
        and case when l_LOANTYPE = 'ALL' then 1
                when l_LOANTYPE = 'BL' and l.rrtype = 'C' and ftype = 'AF' and reftype = 'GP' then 1
                when l_LOANTYPE = 'CL' and ftype = 'AF' and reftype = 'P' then 1
                when l_LOANTYPE = 'DF' and ftype = 'DF' and reftype = 'P' then 1
            else 0 end = 1
    order by custodycd, afacctno;
else
    OPEN PV_REFCURSOR
     FOR
     select p_BRID hs_chinhanh,
        mst.custodycd, mst.idcode, mst.iddate, mst.idplace, mst.afacctno, mst.fullname,
            lnamt,
        greatest(
        case when mst.ftype = 'AF' and mst.reftypecd = 'GP' then nvl(lnorgc.t0amt,0)
            when mst.rrtype = 'B' and mst.reftypecd = 'P' then nvl(lnorgb.dfamt,0) + nvl(lnorgb.mramt,0)
            when mst.rrtype <> 'B' and mst.reftypecd = 'P' then nvl(lnorgc.dfcmpamt,0) + nvl(lnorgc.mrcmpamt,0)
            else 0 end
                ,0)
                lnprin,

            --rate2,
            (select to_char(max(sbdate),'DD/MM/RRRR') from sbcldr where cldrtype = '000' and holiday = 'N' and sbdate <= rlsdate + 180 ) overduedate --fix TPBANK mac dinh la ky han 6 thang
            , rlsdate, contractno, bankacctno,
            --,kRate,reftype,reftype_desc_org,reftype_desc,
           -- rsctype, rsctype_desc,

            p_BRID BRID,
            l_BANKNAME  Nguon_GN
            ,rate2

        from
        (select cf.custodycd,cf.custid, cf.idcode, to_char(cf.iddate,'DD/MM/RRRR') iddate, cf.idplace, af.acctno afacctno, cf.fullname,  b.contractno, b.bankacctno,
        --case when ln.ftype = 'AF' and ls.reftype = 'GP' then cf.t0loanlimit else cf.mrloanlimit end mrcrlimitmax,
        --greatest(case when ln.ftype = 'AF' and ls.reftype = 'GP' then cf.t0loanlimit - nvl(lnm.t0amt,0) else cf.mrloanlimit -nvl(lnm.dfamt,0)-nvl(lnm.mramt,0) end,0) mrcrlimitremain,
            (ls.nml+ls.ovd+ls.paid) lnamt,
            case when ln.ftype = 'AF' and ls.reftype = 'GP' then ln.oprinnml+ln.oprinovd else ln.prinnml+ln.prinovd end lnprin,
            --case when ln.ftype = 'AF' and ls.reftype = 'GP' then ln.orate2 else ln.rate2 end rate2,
            to_char(ls.overduedate,'DD/MM/RRRR') overduedate, ls.rlsdate,
            case when ln.ftype = 'DF' then 100 else round(sec.rlsmarginrate,2) end kRate,
            ln.ftype || ls.reftype reftype,
            decode(ln.ftype || ls.reftype,'AFGP',utf8nums.c_const_reftype_AFGP,'AFP',utf8nums.c_const_reftype_AFP,'DFP',utf8nums.c_const_reftype_DFP,'') reftype_desc_org,
            case when ln.ftype || ls.reftype = 'AFGP' then 'B?o lãnh'--utf8nums.c_const_RPT_LN1000_AFGP_DESC
                    when ln.ftype || ls.reftype = 'AFP' and ln.rrtype = 'C' then 'Ngu?n KBSV'--utf8nums.c_const_RPT_LN1000_AFPC_DESC
                    when  ln.ftype || ls.reftype = 'AFP' and ln.rrtype = 'B' then 'Ngu?n ngân hàng' --utf8nums.c_const_RPT_LN1000_AFPB_DESC
                    else ' '
                    end reftype_desc,
            ln.rrtype || case when ln.rrtype = 'B' then cfb.shortname when ln.rrtype = 'C' then 'KBSV' else null end rsctype,
            case when ln.rrtype = 'C' then 'KBSV'
                when ln.rrtype = 'B' then cfb.fullname
                else '' end rsctype_desc,
            ln.rrtype, ln.custbank, ln.ftype, ls.reftype reftypecd, cf.t0loanlimit, cf.mrloanlimit, nvl(lnm.t0amt,0) t0amt,  nvl(lnm.dfamt,0) dfamt , nvl(lnm.mramt,0) mramt
            ,ln.prinperiod
            , ln.rate2
        from cfmast cf, afmast af, vw_lnmast_all ln, vw_lnschd_all ls, cfmast cfb,
            v_getsecmarginratio sec,
            (
                SELECT b.*, cf.custid, cf.shortname, cf.fullname FROM bankcontractinfo b, cfmast cf
                WHERE b.bankcode = cf.shortname AND b.typecont ='DFMR'
            ) b,
            (select af.custid, sum(decode(ln.ftype,'DF',1,0)*(ls.nml+ls.ovd)) dfamt,
                round(sum(decode(ln.ftype,'AF',1,0)*decode(ls.reftype,'P',1,0)*(ls.nml+ls.ovd+ls.intnmlacr+ls.intdue+ls.intovd+ls.intovdprin+ls.feeintnmlacr+ls.feeintdue+ls.feeintovdacr+ls.feeintnmlovd)),0) mramt,
                round(sum(decode(ln.ftype,'AF',1,0)*decode(ls.reftype,'GP',1,0)*(ls.nml+ls.ovd+ls.intnmlacr+ls.intdue+ls.intovd+ls.intovdprin)),0) t0amt
            from afmast af, lnmast ln, lnschd ls
            where ln.acctno = ls.acctno and ln.trfacctno = af.acctno and ls.reftype in ('P','GP')
            and ls.rlsdate < to_date(p_I_DATE,'DD/MM/RRRR')
            group by af.custid) lnm
        where cf.custid = af.custid
            and ln.trfacctno = b.acctno(+)
            and ln.custbank = b.custid(+)
            and af.acctno = ln.trfacctno
            and cf.custid = lnm.custid(+)
            and ln.acctno = ls.acctno
            and af.acctno = sec.afacctno
            and ln.custbank = cfb.custid(+)
            AND AF.ACCTNO LIKE V_AFACCTNO
            AND CF.CUSTODYCD LIKE V_CUSTODYCD
            and ls.reftype in ('P','GP')
            and case when l_OPT = 'A' then 1 else instr(l_BRID_FILTER,substr(af.acctno,1,4)) end  <> 0
            and ls.rlsdate = to_date(p_I_DATE,'DD/MM/RRRR')
            and case when l_BANKNAME = 'ALL' then 1
                    when l_BANKNAME = 'KBSV' and ln.rrtype = 'C' then 1
                    when cfb.shortname = l_BANKNAME and ln.rrtype = 'B' then 1
                else 0 end = 1
            and case when l_LOANTYPE = 'ALL' then 1
                    when l_LOANTYPE = 'BL' and ln.rrtype = 'C' and ln.ftype = 'AF' and ls.reftype = 'GP' then 1
                    when l_LOANTYPE = 'CL' and ln.ftype = 'AF' and ls.reftype = 'P' then 1
                    when l_LOANTYPE = 'DF' and ln.ftype = 'DF' and ls.reftype = 'P' then 1
                else 0 end = 1
        ) mst,
        (select cfl.bankid,cfe.custid, nvl(cfe.lmamt,cfl.lmamt) lmamt from cflimit cfl,
                (select cf.custid, cfe.bankid, cfe.lmsubtype, cfe.lmchktyp, cfe.lmtyp, cfe.lmamt
                from cfmast cf, cflimitext cfe
                where cf.custid = cfe.custid(+)) cfe
                where cfl.bankid = nvl(cfe.bankid,cfl.bankid)
                and cfl.lmsubtype = nvl(cfe.lmsubtype,cfl.lmsubtype)
                and cfl.lmchktyp = nvl(cfe.lmchktyp,cfl.lmchktyp)
                and cfl.lmtyp = nvl(cfe.lmtyp,cfl.lmtyp)
        ) cfl,
        (select af.custid,ln.custbank, sum(decode(ln.ftype,'DF',1,0)*(ls.nml+ls.ovd)) dfamt,
                round(sum(decode(ln.ftype,'AF',1,0)*decode(ls.reftype,'P',1,0)*(ls.nml+ls.ovd+ls.intnmlacr+ls.intdue+ls.intovd+ls.intovdprin+ls.feeintnmlacr+ls.feeintdue+ls.feeintovdacr+ls.feeintnmlovd)),0) mramt,
                round(sum(decode(ln.ftype,'AF',1,0)*decode(ls.reftype,'GP',1,0)*(ls.nml+ls.ovd+ls.intnmlacr+ls.intdue+ls.intovd+ls.intovdprin)),0) t0amt
            from afmast af, lnmast ln, lnschd ls
            where ln.acctno = ls.acctno and ln.trfacctno = af.acctno and ls.reftype in ('P','GP')
            and ln.rrtype = 'B'
            and ls.rlsdate < to_date(p_I_DATE,'DD/MM/RRRR')
            group by af.custid, ln.custbank
        ) lnmb,
        (select af.custid,ln.custbank,
                sum(decode(ln.ftype,'DF',1,0)*decode(ln.rrtype,'B',1,0)
                        *(case when ls.rlsdate = to_date(p_I_DATE,'DD/MM/RRRR') then ls.nml+ls.ovd + ls.paid else ls.nml+ls.ovd end)) dfamt,
                round(sum(decode(ln.ftype,'AF',1,0)*decode(ln.rrtype,'B',1,0)*decode(ls.reftype,'P',1,0)
                        *(case when ls.rlsdate = to_date(p_I_DATE,'DD/MM/RRRR') then ls.nml+ls.ovd + ls.paid else ls.nml+ls.ovd end)),0) mramt
            from afmast af, lnmast ln, lnschd ls
            where ln.acctno = ls.acctno and ln.trfacctno = af.acctno and ls.reftype in ('P','GP')
            and ln.rrtype = 'B'
            and ls.rlsdate <= to_date(p_I_DATE,'DD/MM/RRRR')
            group by af.custid, ln.custbank
        ) lnorgb,
        (select af.custid,
                round(sum(decode(ln.ftype,'AF',1,0)*decode(ls.reftype,'GP',1,0)
                        *(case when ls.rlsdate = to_date(p_I_DATE,'DD/MM/RRRR') then ls.nml+ls.ovd + ls.paid else ls.nml+ls.ovd end)),0) t0amt,
                sum(decode(ln.ftype,'DF',1,0)*decode(ln.rrtype,'B',0,1)
                        *(case when ls.rlsdate = to_date(p_I_DATE,'DD/MM/RRRR') then ls.nml+ls.ovd + ls.paid else ls.nml+ls.ovd end)) dfcmpamt,
                round(sum(decode(ln.ftype,'AF',1,0)*decode(ln.rrtype,'B',0,1)*decode(ls.reftype,'P',1,0)
                        *(case when ls.rlsdate = to_date(p_I_DATE,'DD/MM/RRRR') then ls.nml+ls.ovd + ls.paid else ls.nml+ls.ovd end)),0) mrcmpamt
            from afmast af, lnmast ln, lnschd ls
            where ln.acctno = ls.acctno and ln.trfacctno = af.acctno and ls.reftype in ('P','GP')
            and ln.rrtype <> 'B'
            and ls.rlsdate <= to_date(p_I_DATE,'DD/MM/RRRR')
            group by af.custid
        ) lnorgc
        where mst.custbank = cfl.bankid(+)
        and mst.custid = cfl.custid(+)
        and mst.custbank = lnmb.custbank(+)
        and mst.custid = lnmb.custid(+)
        and mst.custbank = lnorgb.custbank(+)
        and mst.custid = lnorgb.custid(+)
        and mst.custid = lnorgc.custid(+)
        order by mst.custodycd, mst.afacctno;
end if;


EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

