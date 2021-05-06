CREATE OR REPLACE PROCEDURE cf0010 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   BRGID          IN       VARCHAR2,
   BRANCH         IN       varchar2
 )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE       COMMENTS
-- Diennt      28/12/2011 Create
-- ---------   ------     -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (4);        -- USED WHEN V_NUMOPTION > 0
   V_STRBRGID           VARCHAR2 (10);
   V_branch  varchar2(100);
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

     IF (BRGID  <> 'ALL')
   THEN
      V_STRBRGID  := BRGID;
   ELSE
      V_STRBRGID := '%%';
   END IF;
   select cdcontent into v_branch from allcode where cdname = 'BRANCH' and cdval = BRANCH;


OPEN PV_REFCURSOR
  FOR

  SELECT BRGID BRG, v_branch BRAN,cf.fullname, cf.idcode, cf.iddate, cf.idplace, cf.custodycd, cf.address,
       case when cf.idtype='001' then '1'
            when cf.idtype='002' then '2'
            when cf.idtype='003' then '3'
            when cf.idtype='005' then '5'
            else '4' end LOAI_DKSH,
       '1' CLOSE_OPEN,
       --case when status='A' then '1' else'0' end CLOSE_OPEN,
       case when substr(cf.custodycd,4,1) in ('C','P') and cf.custtype='I' then '1'
            when substr(cf.custodycd,4,1)='F' and cf.custtype='I' then '2'
            when substr(cf.custodycd,4,1)in ('C','P') and cf.custtype='B' then '3'
            when substr(cf.custodycd,4,1)='F' and cf.custtype='B' then '4'
             else '' end LOAI_HINH,
       al.cdcontent country
FROM cfmast cf ,allcode al
WHERE
    --cf.status in ('A','C') and
    cf.country = al.cdval and al.cdname='COUNTRY'
    and cf.custodycd is not NULL
    AND cf.custatcom = 'Y'
    and substr(cf.custid,1,4)  like V_STRBRGID
    and cf.opndate >=TO_DATE(F_DATE,'dd/mm/yyyy')
    and cf.opndate<=TO_DATE(T_DATE,'dd/mm/yyyy')

UNION ALL

SELECT BRGID BRG, v_branch BRAN,cf.fullname, cf.idcode, cf.iddate, cf.idplace, cf.custodycd, cf.address,
       case when cf.idtype='001' then '1'
            when cf.idtype='002' then '2'
            when cf.idtype='003' then '3'
            when cf.idtype='005' then '5'
            else '4' end LOAI_DKSH,
       CASE WHEN log.tltxcd = '0059' THEN '0'
            ELSE '1' END  CLOSE_OPEN,
       case when substr(cf.custodycd,4,1) in ('C','P') and cf.custtype='I' then '1'
            when substr(cf.custodycd,4,1)='F' and cf.custtype='I' then '2'
            when substr(cf.custodycd,4,1)in ('C','P') and cf.custtype='B' then '3'
            when substr(cf.custodycd,4,1)='F' and cf.custtype='B' then '4'
             else '' end LOAI_HINH,
       al.cdcontent country
FROM cfmast cf ,allcode al, vw_tllog_all log
WHERE log.msgacct = cf.custid AND log.tltxcd IN  ('0059','0067') AND log.deltd <> 'Y'
    and cf.country = al.cdval and al.cdname='COUNTRY'
    and cf.custodycd is not NULL
    AND cf.custatcom = 'Y'
    and substr(cf.custid,1,4)  like V_STRBRGID
    and log.txdate >=TO_DATE(F_DATE,'dd/mm/yyyy')
    and log.txdate <=TO_DATE(T_DATE,'dd/mm/yyyy')

;

EXCEPTION
   WHEN OTHERS
   THEN

      RETURN;
End;
/

