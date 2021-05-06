CREATE OR REPLACE PROCEDURE cf0053 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   pv_OPT            IN       VARCHAR2,
   pv_BRID           IN       VARCHAR2,
   pv_FRDATE           in       varchar2,
   pv_TODATE           in       varchar2,
   pv_CUSTODYCD       IN       VARCHAR2,
   pv_AFACCTNO       IN       VARCHAR2,
   pv_ACTYPE       IN       VARCHAR2,
   pv_ISMARGIN       IN       VARCHAR2,
   pv_ISTN       IN       VARCHAR2,
   TLID IN VARCHAR2
)
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- LINHLNB   11-Apr-2012  CREATED
-- ---------   ------  -------------------------------------------
   l_OPT            VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   l_BRID_FILTER          VARCHAR2 (1000);
   l_AFACCTNO         VARCHAR2 (20);
   l_CUSTODYCD        varchar2(10);
   l_ACTYPE           varchar2(4);
   l_ISMARGIN           varchar2(10);
   l_ISTN           varchar2(10);
   l_count number;
   v_TLID varchar2(4);

-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
    l_OPT:=pv_OPT;
   v_TLID := TLID;
    IF (l_OPT = 'A') THEN
      l_BRID_FILTER := '%';
    ELSE
        if (l_OPT = 'B') then
            select brgrp.mapid into l_BRID_FILTER from brgrp where brgrp.brid = pv_BRID;
        else
            l_BRID_FILTER := pv_BRID;
        end if;
    END IF;


   IF (pv_CUSTODYCD <> 'A') AND (pv_CUSTODYCD <> 'ALL')
   THEN
      l_CUSTODYCD := pv_CUSTODYCD;
   ELSE
      l_CUSTODYCD := '%%';
   END IF;

   IF (pv_AFACCTNO <> 'A') AND (pv_AFACCTNO <> 'ALL')
   THEN
      l_AFACCTNO := pv_AFACCTNO;
   ELSE
      l_AFACCTNO := '%%';
   END IF;

   IF (pv_ACTYPE <> 'A') AND (pv_ACTYPE <> 'ALL')
   THEN
      l_ACTYPE := pv_ACTYPE;
   ELSE
      l_ACTYPE := '%%';
   END IF;


   IF (pv_ISMARGIN <> 'A') AND (pv_ISMARGIN <> 'ALL')
   THEN
      l_ISMARGIN := pv_ISMARGIN;
   ELSE
      l_ISMARGIN := 'ALL';
   END IF;


   IF (pv_ISTN <> 'A') AND (pv_ISTN <> 'ALL')
   THEN
      l_ISTN := pv_ISTN;
   ELSE
      l_ISTN := 'ALL';
   END IF;

   -- END OF GETTING REPORT'S PARAMETERS
   IF (pv_CUSTODYCD <> 'A') AND (pv_CUSTODYCD <> 'ALL') THEN
        select count(1) into l_count from cfmast cf, afmast af
        where cf.custid = af.custid and cf.custodycd = l_CUSTODYCD and af.acctno like l_AFACCTNO;
        if not l_count > 0 then
            return;
        end if;
   end if;

   -- GET REPORT'S DATA
    OPEN PV_REFCURSOR
        for
        select * from (
select cf.custodycd, cf.fullname, af.acctno, nvl(nvl(to_char(log.maker_dt,'DD/MM/RRRR'),to_char(log0.maker_dt,'DD/MM/RRRR')),'') txdate,
'[' || aft1.actype || ']:' || aft1.typename from_value,
'[' || aft2.actype || ']:' || aft2.typename to_value,
nvl(log0.to_value,nvl(lasttrfbuyrate, aft2.trfbuyrate)) trfbuyrate ,log.maker_dt
from cfmast cf, afmast af, aftype aft1, aftype aft2,
    (select substr(record_key,11,10) afacctno, from_value, to_value, maker_dt
        from maintain_log where table_name = 'AFMAST' and column_name = 'ACTYPE'
        and maker_dt between to_date(pv_FRDATE,'DD/MM/RRRR') and to_date(pv_TODATE,'DD/MM/RRRR')) log,
    (select substr(record_key,11,10) afacctno, nvl(from_value,to_value) lastactype
        from maintain_log log where table_name = 'AFMAST' and column_name = 'ACTYPE'
        and maker_dt > to_date(pv_TODATE,'DD/MM/RRRR')
        and maker_dt || maker_time = (select min(maker_dt || maker_time) from maintain_log log2
                            where table_name = 'AFMAST' and column_name = 'ACTYPE'
                            and maker_dt > to_date(pv_TODATE,'DD/MM/RRRR') and action_flag = 'EDIT'
                            and log.record_key = log2.record_key)) logaft,
    (select substr(record_key,11,4) aftype, from_value, to_value, maker_dt
        from maintain_log where table_name = 'AFTYPE' and column_name = 'TRFBUYRATE'
        and maker_dt between to_date(pv_FRDATE,'DD/MM/RRRR') and to_date(pv_TODATE,'DD/MM/RRRR')) log0,
    (select substr(record_key,11,4) aftype, nvl(from_value,to_value) lasttrfbuyrate
        from maintain_log log where table_name = 'AFTYPE' and column_name = 'TRFBUYRATE'
        and maker_dt > to_date(pv_TODATE,'DD/MM/RRRR')
        and maker_dt || maker_time = (select min(maker_dt || maker_time) from maintain_log log2
                            where table_name = 'AFMAST' and column_name = 'TRFBUYRATE'
                            and maker_dt > to_date(pv_TODATE,'DD/MM/RRRR') and action_flag = 'EDIT'
                            and log.record_key = log2.record_key)) aft0,
    (select actype, 'Y' ismarginacc from aftype af
          where exists (select 1 from lntype lnt where af.lntype = lnt.actype and lnt.chksysctrl = 'Y'
                          union all
                          select 1 from afidtype afi, lntype lnt where afi.aftype = af.actype and afi.objname = 'LN.LNTYPE' and afi.actype = lnt.actype and lnt.chksysctrl = 'Y')
          group by actype) ismr1,
    (select actype, 'Y' ismarginacc from aftype af
          where exists (select 1 from lntype lnt where af.lntype = lnt.actype and lnt.chksysctrl = 'Y'
                          union all
                          select 1 from afidtype afi, lntype lnt where afi.aftype = af.actype and afi.objname = 'LN.LNTYPE' and afi.actype = lnt.actype and lnt.chksysctrl = 'Y')
          group by actype) ismr2
where af.acctno = log.afacctno(+)
and af.acctno = logaft.afacctno(+)
and cf.custid = af.custid
and exists (select gu.grpid from tlgrpusers gu where af.careby = gu.grpid and gu.tlid = v_TLID )   -- check careby
and case when l_OPT = 'A' then 1 else instr(l_BRID_FILTER,substr(af.acctno,1,4)) end  <> 0
and nvl(nvl(log.from_value,log.to_value),nvl(lastactype,af.actype)) = aft1.actype
and nvl(log.to_value, nvl(lastactype,af.actype)) = aft2.actype
and aft2.actype = nvl(aft0.aftype(+),aft2.actype)
and aft2.actype = log0.aftype(+)
and cf.custodycd like l_CUSTODYCD
and af.acctno like l_AFACCTNO
and (nvl(nvl(log.from_value,log.to_value),nvl(lastactype,af.actype)) like l_ACTYPE
or nvl(log.to_value, nvl(lastactype,af.actype)) like l_ACTYPE)
and (l_ISTN = 'ALL' or (l_ISTN = 'N' and aft1.trfbuyrate = 0) or (l_ISTN = 'Y' and aft1.trfbuyrate > 0)
or l_ISTN = 'ALL' or (l_ISTN = 'N' and aft2.trfbuyrate = 0) or (l_ISTN = 'Y' and aft2.trfbuyrate > 0))
and aft1.actype = ismr1.actype(+)
and aft2.actype = ismr2.actype(+)
and (l_ISMARGIN = 'ALL' or nvl(ismr1.ismarginacc,'N') = l_ISMARGIN or nvl(ismr2.ismarginacc,'N') = l_ISMARGIN)
)a
where a.from_value <> a.to_value
order by a.acctno, nvl(a.maker_dt,to_date(pv_FRDATE,'DD/MM/RRRR'));



 EXCEPTION
   WHEN OTHERS
   THEN
        RETURN;
END;
/

