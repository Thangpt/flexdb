CREATE OR REPLACE PROCEDURE ci0034 (
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
    select cf.custodycd, cf.fullname, af.acctno, cit.*
    from cfmast cf, afmast af,
          (select ci.acctno, sum(case when ci.txtype='C' then ci.NAMT else 0 end) PT,
                sum(case when ci.txtype='D' then ci.NAMT else 0 end) GT
          from vw_citran_gen ci
          where ci.field in ('EMKAMT')
                and ci.deltd = 'N'
                and ci.txdate >= to_date(F_DATE,'dd/mm/rrrr')
                and ci.txdate <= to_date(T_DATE,'dd/mm/rrrr')
          group by ci.acctno) cit
    where cf.custid = af.custid
          and af.acctno = cit.acctno
          and af.acctno like STR_CIACCTNO
          and cf.custodycd like V_STRCUSTODYCD
;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

