CREATE OR REPLACE PROCEDURE CI0033 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   CUSTODYCD      IN       VARCHAR2,
   PV_CIACCTNO    IN       VARCHAR2
 )
IS
--
-- PURPOSE: BAO CAO TINH PHI LUU KY CHO TUNG TAI KHOAN
-- MODIFICATION HISTORY
-- PERSON      DATE      COMMENTS
-- QUYETKD    29-05-2011  CREATED
-- ---------   ------  -------------------------------------------
   V_STROPTION     VARCHAR2  (5);
   V_STRBRID       VARCHAR2  (4);
   V_STRCUSTODYCD   VARCHAR2 (20);
   STR_CIACCTNO      VARCHAR2(20);

BEGIN
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   -- GET REPORT'S PARAMETERS
  IF (CUSTODYCD <> 'ALL' or CUSTODYCD <> '')
   THEN
      V_STRCUSTODYCD :=  CUSTODYCD;
   ELSE
      V_STRCUSTODYCD := '%%';
   END IF;


 IF (PV_CIACCTNO <> 'ALL' or PV_CIACCTNO <> '')
   THEN
      STR_CIACCTNO :=  PV_CIACCTNO;
   ELSE
      STR_CIACCTNO := '%%';
   END IF;
   -- GET REPORT'S DATA

   OPEN PV_REFCURSOR
       FOR

SELECT
cf.custodycd custodycd,
cf.fullname,
ci.afacctno,
ci.frdate,
ci.todate,
ci.deporate,
ci.depoqtty,
Decode(depotype,'T','Trai phieu','Co phieu/CC Quy') depotype ,
ci.cidepofeeacr
from cidepofeetran ci , afmast af ,cfmast cf
Where ci.afacctno = af.acctno
and af.custid = cf.custid
and cf.custodycd = V_STRCUSTODYCD
and af.acctno like STR_CIACCTNO
and ci.todate >= to_date(F_DATE,'dd/mm/yyyy')
and ci.todate <= to_date(T_DATE,'dd/mm/yyyy')
order by ci.frdate,ci.todate
;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

