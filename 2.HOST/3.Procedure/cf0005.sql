CREATE OR REPLACE PROCEDURE cf0005 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2
 )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE       COMMENTS
-- Diennt      13/10/2011 Create
-- ---------   ------     -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (4);        -- USED WHEN V_NUMOPTION > 0
-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE

BEGIN
-- INSERT INTO TEMP_BUG(TEXT) VALUES('CF0001');COMMIT;
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;


OPEN PV_REFCURSOR
  FOR

  SELECT cf.fullname,cf.custodycd, tl.MAKER_DT, TL.FROM_FULLNAME, TL.TO_FULLNAME,tl.FROM_IDCODE, tl.TO_IDCODE, tl.FROM_IDDATE, tl.TO_IDDATE,
       tl.FROM_IDPLACE, tl.TO_IDPLACE, tl.FROM_ADDRESS, tl.TO_ADDRESS, tl.FROM_COUNTRY,
       tl.TO_COUNTRY, (CASE WHEN TL.FROM_BUSINESSTYPE='006' then TL.FROM_POSITION else '' end) FROM_POSITION,
       (CASE WHEN TL.TO_BUSINESSTYPE='006' then TL.FROM_POSITION else '' end) TO_POSITION
    FROM
    (select record_key,maker_dt,maker_time,
        max(case when  column_name ='FULLNAME' then from_value else '' end ) FROM_FULLNAME,
        max(case when column_name ='FULLNAME' then to_value else '' end ) TO_FULLNAME,
        max(case when  column_name ='IDCODE' then from_value else '' end ) FROM_IDCODE,
        max(case when column_name ='IDCODE' then to_value else '' end ) TO_IDCODE,
        max(case when column_name ='IDDATE' then from_value else '' end ) FROM_IDDATE,
        max(case when column_name ='IDDATE' then to_value else '' end ) TO_IDDATE,
        max(case when column_name ='IDPLACE' then from_value else '' end ) FROM_IDPLACE,
        max(case when column_name ='IDPLACE' then to_value else '' end ) TO_IDPLACE,
        max(case when column_name ='ADDRESS' then from_value else '' end ) FROM_ADDRESS,
        max(case when column_name ='ADDRESS' then to_value else '' end ) TO_ADDRESS,
        max(case when column_name ='COUNTRY' then nvl(a1.cdcontent,'') else '' end ) FROM_COUNTRY,
        max(case when column_name ='COUNTRY' then nvl(a2.cdcontent,'') else '' end ) TO_COUNTRY,
        max(case when column_name ='POSITION' then nvl(a3.cdcontent,'') else '' end ) FROM_POSITION,
        max(case when column_name ='POSITION' then nvl(a4.cdcontent,'') else '' end ) TO_POSITION,
        max(case when column_name ='BUSINESSTYPE' then from_value else '' end ) FROM_BUSINESSTYPE,
        max(case when column_name ='BUSINESSTYPE' then to_value else '' end ) TO_BUSINESSTYPE
    from maintain_log
        left join allcode a1 on from_value = a1.cdval and a1.cdname ='COUNTRY' and a1.cdtype='CF'
        left join allcode a2 on to_value = a2.cdval and a2.cdname ='COUNTRY' and a2.cdtype='CF'
        left join allcode a3 on from_value = a3.cdval and a3.cdname ='COUNTRY' and a3.cdtype='CF'
        left join allcode a4 on to_value = a4.cdval and a4.cdname ='COUNTRY' and a4.cdtype='CF'
    where table_name ='CFMAST'
        and column_name in ('IDCODE','IDDATE','IDPLACE','ADDRESS','COUNTRY', 'FULLNAME')
        AND action_flag='EDIT'
    group by record_key,maker_dt, maker_time) tl,cfmast cf
    WHERE
        cf.custid=substr(trim(TL.record_key),11,10)
    and tl.maker_dt <= to_date(T_DATE,'DD/MM/YYYY' )
    AND tl.maker_dt >= to_date(F_DATE,'DD/MM/YYYY' )
;

EXCEPTION
   WHEN OTHERS
   THEN

      RETURN;
End;
/

