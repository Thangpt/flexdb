CREATE OR REPLACE PROCEDURE CI0031 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   CUSTODYCD      IN       VARCHAR2
 )
IS
--
-- PURPOSE: BAO CAO TINH PHI LUU KY CHO TUNG TIEU KHOAN
-- MODIFICATION HISTORY
-- PERSON      DATE      COMMENTS
-- QUYETKD   13-05-2011  CREATED
-- ---------   ------  -------------------------------------------
   V_STROPTION     VARCHAR2  (5);
   V_STRBRID       VARCHAR2  (4);
   V_STRCUSTODYCD   VARCHAR2 (20);

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

   -- GET REPORT'S DATA

   OPEN PV_REFCURSOR
       FOR
       SELECT
cf.custodycd ,
cf.fullname ,
af.acctno afacctno,
FE.txdate txdate,
(case when nvl(FE.FEELK_DATRA,0) - nvl(FE.FEE_LK,0) > 0 then  nvl(FE.FEELK_DATRA,0) - nvl(FE.FEE_LK,0) else 0 end ) FEE_LK_KT,
nvl(FE.FEE_LK,0) FEE_LK,
nvl(FE.FEELK_DATRA,0) FEELK_DATRA
FROM
afmast af ,
cfmast cf ,
(
Select txdate ,afacctno ,sum(FEELK_DATRA) FEELK_DATRA , sum(FEE_LK) FEE_LK from
(
Select txdate , msgacct afacctno , nvl(round(msgamt),0) FEELK_DATRA , 0 FEE_LK from
(
Select * from tllog where tltxcd in ('1180','1182')
and txdate >= to_date(F_DATE,'dd/MM/yyyy')
and txdate <= to_date(T_DATE,'dd/MM/yyyy')
union all
Select * from tllogALL where tltxcd in   ('1180','1182')
and txdate >= to_date(F_DATE,'dd/MM/yyyy')
and txdate <= to_date(T_DATE,'dd/MM/yyyy')
)
union all
Select todate txdate , afacctno ,0 FEELK_DATRA,  nvl(round(cidepofeeacr),0) FEE_LK
from cidepofeetran
where
 todate >= to_date(F_DATE,'dd/MM/yyyy')
and todate <= to_date(T_DATE,'dd/MM/yyyy')
)
group by  txdate ,afacctno
)FE
where af.custid=cf.custid
and af.acctno =FE.afacctno(+)
and Cf.Custodycd Like V_STRCUSTODYCD
order by FE.txdate
;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

