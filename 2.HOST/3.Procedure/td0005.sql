CREATE OR REPLACE PROCEDURE td0005 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   AFACCTNO       IN       VARCHAR2,
   CAREBY         IN       VARCHAR2,
   ACCTNO         IN       VARCHAR2,
   GROUPTYPE      IN       VARCHAR2
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
   V_STRCAREBY      VARCHAR2 (10);

-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
   V_STROPTION := OPT;

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

   if(upper(CAREBY) <> 'ALL') then
        V_STRCAREBY :=  CAREBY;
   else
        V_STRCAREBY := '%';
   end if;

   V_FROMDATE := to_date(F_DATE,'dd/mm/yyyy');
   V_TODATE := to_date(T_DATE,'dd/mm/yyyy');

   -- GET REPORT'S DATA
OPEN PV_REFCURSOR
       FOR
select td.status , af.actype aftype, tl.grpname careby, td.acctno, td.afacctno, td.actype, td.orgamt,
    td.frdate, td.todate, (td.tdterm || ' ' || al.cdcontent) cdcontent,
    pck_bps.fnc_get_AdvIntRate (td.actype, td.orgamt) intrate , td.printpaid,
    fn_tdmastintratio(td.acctno, td.todate, td.orgamt) INTAMT, td.intpaid,
    fn_tdmastintratio(td.acctno, td.todate, td.orgamt) - td.intpaid chenhlechlai,
    fn_tdmastintratio(td.acctno, td.todate, td.balance) INTAVAMT, td.balance,
    GROUPTYPE strGROUPTYPE, cf.fullname
from tdmast td, afmast af, cfmast cf, allcode al, tlgroups tl
where td.afacctno = af.acctno and af.custid = cf.custid
    and al.cdtype = 'TD' and al.cdname = 'TERMCD'
    and td.termcd = al.cdval
    and cf.careby = tl.grpid
    and td.frdate BETWEEN V_FROMDATE and V_TODATE
    and af.acctno like V_STRAFACCTNO
    and td.acctno like V_STRACCTNO
    and cf.careby like V_STRCAREBY
    ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

