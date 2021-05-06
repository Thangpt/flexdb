-- Start of DDL Script for Procedure HOSTMSBST.LN0016
-- Generated 14/09/2018 2:33:11 PM from HOSTMSBST@FLEX_111

CREATE OR REPLACE 
PROCEDURE ln0016 (
    PV_REFCURSOR    IN OUT   PKG_REPORT.REF_CURSOR,
    p_OPT           IN       VARCHAR2,
    p_BRID          IN       VARCHAR2,
    p_FRDATE        IN       VARCHAR2,
    p_TODATE        IN       VARCHAR2,
    p_CUSTODYCD     IN       VARCHAR2,
    p_AFACCTNO      IN       VARCHAR2,
    p_RESTYPE       IN       VARCHAR2
)
IS
    l_OPT varchar2(10);
    l_BRID varchar2(1000);
    l_BRID_FILTER varchar2(1000);
    l_CUSTODYCD varchar2(10);
    l_AFACCTNO varchar2(10);

BEGIN

-- Prepare Parameters
    l_OPT:=p_OPT;

    IF (l_OPT = 'A') THEN
      l_BRID_FILTER := '%';
    ELSE if (l_OPT = 'B') then
            select brgrp.mapid into l_BRID_FILTER from brgrp where brgrp.brid = p_BRID;
        else
            l_BRID_FILTER := p_BRID;
        end if;
    END IF;

    if p_CUSTODYCD = 'A' or p_CUSTODYCD = 'ALL' then
        l_CUSTODYCD:= '%%';
    else
        l_CUSTODYCD:= p_CUSTODYCD;
    end if;

    if p_AFACCTNO = 'A' or p_AFACCTNO = 'ALL' then
        l_AFACCTNO:= '%%';
    else
        l_AFACCTNO:= p_AFACCTNO;
    end if;

    OPEN PV_REFCURSOR
    FOR
    SELECT * FROM
    (SELECT to_char(ls.autoid) autoid, ls.rlsdate, cf.custodycd, ln.trfacctno, nvl(cfb.shortname,'KBSV') shortname, decode(ln.ftype||ls.reftype,'AFGP','BL','AFP','CL','DFP','DF','') rlstype, cf.fullname,
        CASE WHEN ln.ftype||ls.reftype = 'AFGP' THEN ln.orate2 ELSE ln.rate2 END rate, ls.nml + ls.ovd lnprin,
        ls.nml + ls.ovd + ls.paid paid, null paiddate, '1' stt
    FROM vw_lnmast_all ln, vw_lnschd_all ls, cfmast cf, afmast af, cfmast cfb
    WHERE ln.acctno = ls.acctno AND ln.trfacctno = af.acctno AND cf.custid = af.custid
        and instr(ls.reftype,'P') <> 0 and ln.custbank = cfb.custid(+)
        and case when p_RESTYPE = 'ALL' then 1
                when ln.rrtype = 'C' and p_RESTYPE = 'KBSV' then 1
                when ln.rrtype = 'B' and p_RESTYPE = nvl(cfb.shortname,'KBSV') then 1
                else 0 end <> 0
        and cf.custodycd like l_CUSTODYCD
        and af.acctno like l_AFACCTNO
        and ls.rlsdate >= to_date(p_FRDATE,'DD/MM/RRRR') AND ls.rlsdate <= to_date(p_TODATE,'DD/MM/RRRR')
    UNION ALL
    SELECT to_char(ls.autoid) autoid, ls.rlsdate, cf.custodycd, ln.trfacctno, nvl(cfb.shortname,'KBSV') shortname, decode(ln.ftype||ls.reftype,'AFGP','BL','AFP','CL','DFP','DF','') rlstype, cf.fullname,
        CASE WHEN ln.ftype||ls.reftype = 'AFGP' THEN ln.orate2 ELSE ln.rate2 END rate, ls.nml + ls.ovd lnprin,
        nvl(-lg1.paid,0) paid, lg1.txdate paiddate, '2' stt
    FROM vw_lnmast_all ln, vw_lnschd_all ls, cfmast cf, afmast af, cfmast cfb,
        (select autoid, sum(paid) paid, txdate
        from (select * from lnschdlog union all select * from lnschdloghist) lg
        where --lg.txdate >= to_date(p_FRDATE,'DD/MM/RRRR') AND lg.txdate <= to_date(p_TODATE,'DD/MM/RRRR')
            --AND
            paid > 0
        group by autoid, txdate) lg1
    WHERE ln.acctno = ls.acctno AND ln.trfacctno = af.acctno AND cf.custid = af.custid
        and instr(ls.reftype,'P') <> 0 and ln.custbank = cfb.custid(+) and ls.autoid = lg1.autoid(+)
        AND nvl(lg1.paid,0) > 0
        and case when p_RESTYPE = 'ALL' then 1
                when ln.rrtype = 'C' and p_RESTYPE = 'KBSV' then 1
                when ln.rrtype = 'B' and p_RESTYPE = nvl(cfb.shortname,'KBSV') then 1
                else 0 end <> 0
        and cf.custodycd like l_CUSTODYCD
        and af.acctno like l_AFACCTNO
        and ls.rlsdate >= to_date(p_FRDATE,'DD/MM/RRRR') AND ls.rlsdate <= to_date(p_TODATE,'DD/MM/RRRR')
    )
    ORDER BY custodycd, trfacctno, autoid, stt, rlsdate, paiddate
;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/



-- End of DDL Script for Procedure HOSTMSBST.LN0016

