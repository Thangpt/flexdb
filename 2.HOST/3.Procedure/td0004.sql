CREATE OR REPLACE PROCEDURE td0004 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   AFACCTNO       IN       VARCHAR2,
   TLTXCD         IN       VARCHAR2,
   ACCTNO         IN       VARCHAR2,
   CAREBY         IN       VARCHAR2
   )
IS
-- MODIFICATION HISTORY
-- Bao cao tinh trang no qua han
-- PERSON           DATE        COMMENTS
-- DUNGNH       24-MAR-2011     CREATED
-- ---------       ------   -------------------------------------------
   V_STROPTION      VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0

   V_FROMDATE       DATE;
   V_TODATE         DATE;
   V_STRAFACCTNO    VARCHAR2 (10);
   V_STRACCTNO      VARCHAR2 (20);
   V_STRTLTXCD      VARCHAR2 (10);
   V_STR_CAREBY     varchar2(100);
-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
   V_STROPTION := OPT;
   V_STR_CAREBY:=  CAREBY;
   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

    -- GET REPORT'S PARAMETERS

   if(upper(AFACCTNO) <> 'ALL') then
        V_STRAFACCTNO :=  AFACCTNO;
   else
        V_STRAFACCTNO := '%';
   end if;

   if(upper(ACCTNO) <> 'ALL') then
        V_STRACCTNO := ACCTNO;
   else
        V_STRACCTNO := '%';
   end if;

   if(upper(TLTXCD) <> 'ALL') then
        V_STRTLTXCD := TLTXCD;
   else
        V_STRTLTXCD := '%';
   end if;


   V_FROMDATE := to_date(F_DATE,'dd/mm/yyyy');
   V_TODATE := to_date(T_DATE,'dd/mm/yyyy');

   -- GET REPORT'S DATA
OPEN PV_REFCURSOR
       FOR

select td.txdate, td.tltxcd, td.acctno, td.afacctno, td.fullname,
    td.actype, td.msgamt, td.frdate, td.todate,
    (case when td.schdtype = 'F' then td.intrate else nvl(TDMSTSCHM.intrate,td.intrate) end) intrate,
    0 NAMT, td.INTAVLAMT, 0 intamt, td.txdesc txdesc, td.cdcontent
from
(
select tl.txdate, tl.tltxcd, TD.acctno, td.afacctno, cf.fullname,
    td.actype, tl.msgamt, td.frdate, td.todate, td.intrate,
    fn_tdmastintratio(td.acctno,td.todate,td.orgamt) INTAVLAMT, td.tdterm,
    td.orgamt, td.schdtype, tl.txdesc, (td.tdterm || ' ' || al.cdcontent) cdcontent
from
(
    SELECT * FROM TLLOG WHERE TLTXCD = '1670' and txdate BETWEEN V_FROMDATE and V_TODATE
        and tltxcd like V_STRTLTXCD

    UNION ALL
    SELECT * FROM TLLOGALL WHERE TLTXCD = '1670' and txdate BETWEEN V_FROMDATE and V_TODATE
        and tltxcd like V_STRTLTXCD
) TL,
(
    select txdate, txnum, acctno, afacctno, actype, orgamt, balance, opndate,
        frdate, todate, intrate, tdterm, schdtype, termcd
    from tdmasthist
    union all
    select txdate, txnum, acctno, afacctno, actype, orgamt, balance, opndate,
        frdate, todate, intrate, tdterm, schdtype, termcd
    from tdmast
) TD, afmast af, cfmast cf, allcode al
where tl.txnum = td.txnum
    and tl.txdate = td.txdate
    and td.afacctno = af.acctno
    and af.custid = cf.custid
    and td.acctno like V_STRACCTNO
    and af.acctno like V_STRAFACCTNO
    and al.cdtype = 'TD' and al.cdname = 'TERMCD'
    and td.termcd = al.cdval
    AND CF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = V_STR_CAREBY)
) td
left join
TDMSTSCHM
on td.acctno = TDMSTSCHM.acctno(+)
    and td.orgamt >= TDMSTSCHM.framt(+)
    and td.orgamt < TDMSTSCHM.toamt(+)
    and td.tdterm >= TDMSTSCHM.FRTERM(+)
    and td.tdterm < TDMSTSCHM.toterm(+)

UNION ALL

select td.txdate, td.tltxcd, td.acctno, td.afacctno, td.fullname,
    td.actype, td.orgamt msgamt, td.frdate, td.todate,
    (case when td.schdtype = 'F' then td.intrate else nvl(TDMSTSCHM.intrate,td.intrate) end) intrate,
    TD.namt NAMT, 0 INTAVLAMT, TD.intpaid intamt, td.txdesc, td.cdcontent
FROM
(
select tr.txdate, tl.tltxcd, tr.acctno, td.afacctno, cf.fullname,
    td.actype, td.orgamt, td.frdate, td.todate,
    max(case when tr.txcd = '0026' then tr.namt else 0 end) intpaid,
    max(case when tr.txcd = '0023' then tr.namt else 0 end) namt,
    tr.txnum, TD.intrate, TD.schdtype, TD.tdterm, max(tl.txdesc) txdesc,
    max(td.tdterm || ' ' || al.cdcontent) cdcontent
from afmast af, cfmast cf, allcode al,
(
    select txdate, txnum, acctno, afacctno, actype, orgamt, balance, opndate,
        frdate, todate, intrate, tdterm, schdtype, termcd
    from tdmasthist
    union all
    select txdate, txnum, acctno, afacctno, actype, orgamt, balance, opndate,
        frdate, todate, intrate, tdterm, schdtype, termcd
    from tdmast
) TD,
( select * from tdtran union all select * from tdtrana ) TR,
( select * from tllog union all select * from tllogall ) tl
where tr.txcd in ('0023','0026')
    and tl.tltxcd like V_STRTLTXCD
    and tr.txdate BETWEEN V_FROMDATE and V_TODATE
    and tr.txnum = tl.txnum
    and tr.txdate = tl.txdate
    and tr.acctno = td.acctno
    and td.afacctno = af.acctno
    and af.custid = cf.custid
    and al.cdtype = 'TD' and al.cdname = 'TERMCD'
    and td.termcd = al.cdval
    and td.acctno like V_STRACCTNO
    and af.acctno like V_STRAFACCTNO
    AND CF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = V_STR_CAREBY)
group by tr.txnum, tr.txdate, tr.txdate, tl.tltxcd, tr.acctno, td.afacctno, cf.fullname,
    td.actype, td.orgamt, td.frdate, td.todate, TD.intrate, TD.tdterm, TD.schdtype
) TD
left join
TDMSTSCHM
on td.acctno = TDMSTSCHM.acctno(+)
    and td.namt >= TDMSTSCHM.framt(+)
    and td.namt < TDMSTSCHM.toamt(+)
    and td.tdterm >= TDMSTSCHM.FRTERM(+)
    and td.tdterm < TDMSTSCHM.toterm(+)
;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

