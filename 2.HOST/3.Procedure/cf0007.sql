CREATE OR REPLACE PROCEDURE cf0007 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2
 )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE       COMMENTS
-- Diennt      30/09/2011 Create
-- ---------   ------     -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (4);        -- USED WHEN V_NUMOPTION > 0
-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
V_STRPV_CUSTODYCD VARCHAR2(20);
V_STRPV_AFACCTNO VARCHAR2(20);
BEGIN

   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;
   IF(PV_CUSTODYCD <> 'ALL')
   THEN
        V_STRPV_CUSTODYCD  := PV_CUSTODYCD;
   ELSE
        V_STRPV_CUSTODYCD  := '%%';
   END IF;

    IF(PV_AFACCTNO <> 'ALL')
   THEN
        V_STRPV_AFACCTNO  := PV_AFACCTNO;
   ELSE
        V_STRPV_AFACCTNO := '%%';
   END IF;

OPEN PV_REFCURSOR
  FOR

  SELECT  action_flag, cf.custodycd, af.acctno ,'AFMAST' ID,tl1.tlfullname maker_id, to_date(ma.maker_dt,'dd/mm/yyyy') maker_dt,
         tl2.tlfullname approve_id,ma.approve_dt, caption column_name, from_value, to_value
  FROM maintain_log ma, afmast af,tlprofiles tl1,tlprofiles tl2,fldmaster FLD ,cfmast cf
  WHERE
        ma.table_name='AFMAST'
    and ma.action_flag='EDIT'
    and af.acctno=substr(trim(ma.record_key),11,10)
    and tl1.tlid(+)=ma.maker_id
    and tl2.tlid(+)=ma.approve_id
    AND FLD.fldname = ma.column_name
    AND FLD.objname ='CF.AFMAST'
    and af.custid = cf.custid
    AND ma.maker_dt <= to_date(T_DATE,'DD/MM/YYYY' )
    AND ma.maker_dt >= to_date(F_DATE,'DD/MM/YYYY' )
    AND AF.ACCTNO LIKE V_STRPV_AFACCTNO
    and cf.custodycd like V_STRPV_CUSTODYCD
    --order by af.acctno
  UNION ALL
  SELECT action_flag, cf.custodycd, af.acctno ,'CFMAST' ID,tl1.tlfullname maker_id, to_date(ma.maker_dt,'dd/mm/yyyy') maker_dt,
         tl2.tlfullname approve_id,ma.approve_dt, caption column_name, from_value, to_value
  FROM maintain_log ma, cfmast cf,tlprofiles tl1,tlprofiles tl2,fldmaster FLD ,afmast af
  WHERE
        ma.table_name='CFMAST'
    and ma.action_flag='EDIT'
    and cf.custid=substr(trim(ma.record_key),11,10)
    and tl1.tlid(+)=ma.maker_id
    and tl2.tlid(+)=ma.approve_id
    AND FLD.fldname = ma.column_name
    AND FLD.objname ='CF.CFMAST'
    AND ma.maker_dt <= to_date(T_DATE,'DD/MM/YYYY' )
    AND ma.maker_dt >= to_date(F_DATE,'DD/MM/YYYY' )
      and af.custid = cf.custid
     AND AF.ACCTNO LIKE V_STRPV_AFACCTNO
    and cf.custodycd like V_STRPV_CUSTODYCD
    --order by cf.custid
;

EXCEPTION
   WHEN OTHERS
   THEN

      RETURN;
End;
/

