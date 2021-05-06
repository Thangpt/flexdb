CREATE OR REPLACE PROCEDURE ca1048 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN      VARCHAR2,
   BRID           IN      VARCHAR2,
   CAMASTID       IN       VARCHAR2,
  PV_AFACCTNO   IN    VARCHAR2
 )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- ---------   ------  -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (16);        -- USED WHEN V_NUMOPTION > 0
   V_STRTLTXCD              VARCHAR2 (6);
   V_STRCUSTOCYCD           VARCHAR2 (20);
   V_STRCAMASTID              VARCHAR2 (30);
-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
-- INSERT INTO TEMP_BUG(TEXT) VALUES('CF0001');COMMIT;
   V_STROPTION := upper(OPT);

      IF (CAMASTID <> 'ALL')
   THEN
      V_STRCAMASTID := CAMASTID;
   ELSE
      V_STRCAMASTID := '%%';
   END IF;


OPEN PV_REFCURSOR
  FOR
/*select cf.fullname,cf.idcode,cf.iddate,cf.idplace,cf.address,af.acctno
, iss.fullname SYMBOL_NAME,sb.symbol,sb.parvalue,ca.duedate,cas.trade balance, CA.description
from camast ca,caschd CAS,cfmast cf , afmast af,sbsecurities sb,issuers iss
where ca.camastid = cas.camastid
and cas.afacctno = af.acctno and af.custid = cf.custid
and ca.catype='014' and cas.codeid =sb.codeid  and sb.issuerid= iss.issuerid
and ca.camastid =V_STRCAMASTID and cf.custodycd =PV_CUSTODYCD;*/


select cf.custodycd, cf.fullname,cf.mobile ,cf.idcode,cf.iddate,cf.idplace,cf.address,af.acctno
, iss.fullname SYMBOL_NAME,sb.symbol,sb.parvalue,ca.duedate,sum(cas.trade) trade, CA.description, SUM(  cas.pqtty+cas.qtty) balance
,af.bankacctno,AL.cdcontent bankname,CA.exprice,af.corebank
from camast ca,caschd CAS,cfmast cf , afmast af,sbsecurities sb,issuers iss, allcode al
where ca.camastid = cas.camastid
and cas.afacctno = af.acctno and af.custid = cf.custid
and ca.catype='014'
and nvl(ca.tocodeid,ca.codeid) = sb.codeid--and cas.codeid =sb.codeid
and sb.issuerid= iss.issuerid
and al.cdval = AF.bankname AND AL.CDNAME ='BANKNAME' AND AL.cdtype ='CF'
and ca.camastid = V_STRCAMASTID
AND AF.ACCTNO LIKE PV_AFACCTNO  AND  CAS.DELTD  <>'Y'
group by cf.custodycd, cf.fullname,cf.mobile ,cf.idcode,cf.iddate,cf.idplace,cf.address,af.acctno
, iss.fullname ,sb.symbol,sb.parvalue,ca.duedate, CA.description
,af.bankacctno,AL.cdcontent ,CA.exprice,af.corebank ;


EXCEPTION
   WHEN OTHERS
   THEN

      RETURN;
End;
-- End of DDL Script for Procedure HOST.CA1018
/

