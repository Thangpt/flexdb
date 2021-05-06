CREATE OR REPLACE PROCEDURE cf0008 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   C_F_DATE       in        varchar2,
   C_T_DATE       in        varchar2,
   CUSTODYCD      IN       VARCHAR2,
   AFTYPE         IN       VARCHAR2,
   ACTYPE         IN       VARCHAR2,
   ACTIVE         in        varchar2,
   ISMATCHED      in        varchar2,
   INCOMERANGE    IN       VARCHAR2,
   EDUCATION      IN       VARCHAR2,
   SECTOR         IN       VARCHAR2,
   CAREBY         IN       VARCHAR2,
   PLACE          IN       VARCHAR2

)
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- Hien.vu
-- ---------   ------  -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (4);              -- USED WHEN V_NUMOPTION > 0
   V_ACTYPE           VARCHAR2 (16);
   V_STRINCOMERANGE   VARCHAR2 (50);
   V_STREDUCATION     VARCHAR2 (50);
   V_STRSECTOR        VARCHAR2 (50);
   V_STRAFTYPE        VARCHAR2 (10);
   V_STRCAREBY        VARCHAR2 (50);
   V_STRPLACE         VARCHAR2 (50);
   V_STRREFNAME       VARCHAR2 (50);
   v_text             varchar2(1000);
   V_ACTIVE           varchar2(3);
   V_ISMATCHED        varchar2(3);
   V_CURRENTDATE      date;
-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
-- insert into temp_bug(text) values('CF0001');commit;
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;
   select to_date(varvalue,'DD/MM/RRRR') into V_CURRENTDATE from sysvar where varname = 'CURRDATE';

   -- GET REPORT'S PARAMETERS
   IF (ACTYPE <> 'ALL')
   THEN
      V_ACTYPE := ACTYPE;
   ELSE
      V_ACTYPE := '%%';
   END IF;

   -- GET REPORT'S PARAMETERS
   IF (ACTIVE <> 'ALL')
   THEN
      V_ACTIVE := ACTIVE;
   ELSE
      V_ACTIVE := '%%';
   END IF;

   -- GET REPORT'S PARAMETERS
   IF (ISMATCHED <> 'ALL')
   THEN
      V_ISMATCHED := ISMATCHED;
   ELSE
      V_ISMATCHED := '%%';
   END IF;

   IF (INCOMERANGE <> 'ALL')
   THEN
      V_STRINCOMERANGE := INCOMERANGE;
   ELSE
      V_STRINCOMERANGE := '%%';
   END IF;

   IF (EDUCATION <> 'ALL')
   THEN
      V_STREDUCATION := EDUCATION;
   ELSE
      V_STREDUCATION := '%%';
   END IF;


   IF (CUSTODYCD <> 'ALL')
   THEN
      V_STRREFNAME:= CUSTODYCD;
   ELSE
      V_STRREFNAME := '%%';
   END IF;

   IF (SECTOR <> 'ALL')
   THEN
      V_STRSECTOR := SECTOR;
   ELSE
      V_STRSECTOR := '%%';
   END IF;

   IF (AFTYPE <> 'ALL')
   THEN
      V_STRAFTYPE := AFTYPE;
   ELSE
      V_STRAFTYPE := '%%';
   END IF;

   IF (CAREBY <> 'ALL')
   THEN
      V_STRCAREBY := CAREBY;
   ELSE
      V_STRCAREBY := '%%';
   END IF;
   IF (PLACE <> 'ALL')
   THEN
      V_STRPLACE := PLACE;
   ELSE
      V_STRPLACE := '%%';
   END IF;



   -- END OF GETTING REPORT'S PARAMETERS
   -- GET REPORT'S DATA
--   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
--   THEN
OPEN PV_REFCURSOR
FOR
SELECT   *  FROM
(
        SELECT   AF.OPNDATE OPNDATE, CF.FULLNAME FULLNAME, CF.DATEOFBIRTH DATEOFBIRTH,CF.IDCODE IDCODE, CF.ADDRESS ADDRESS,CF.IDPLACE IDPLACE,CF.IDDATE IDDATE,
        CF.CUSTID CUSTID, AF.ACCTNO ACCTNO, AF.ACTYPE ACTYPE,CF.BRID BRID,CF.CAREBY CAREBY,CF.CUSTTYPE CUSTTYPE,CF.CUSTODYCD CUSTODYCD,
        CTRY.CDCONTENT COUNTRY,ATYPE.CDCONTENT AFTYPE , cf.REFNAME, nvl(cf.mobile,cf.phone)||'/'||CF.email memail,
        case when cf.country = '234' and custtype = 'I' then 'CNTN'
             when cf.country = '234' and custtype = 'B' then 'TCTN'
             when cf.country <> '234' and custtype = 'I' then 'CNNN'
             when cf.country <> '234' and custtype = 'B' then 'TCNN' end loai_kh,
        case when AF.status in ('C','N') then (select max(txdate) from vw_tllog_all where tltxcd = '0088' and msgacct = af.acctno)
             else to_date('01/01/2020','DD/MM/RRRR') end ngay_dong,
             nvl(re.renam,' ') renam,nvl(od.txdate,'01-Jan-2000') txdate
        FROM     CFMAST CF, AFMAST AF, ALLCODE CTRY,ALLCODE ATYPE,
                (select cf.fullname renam, a.afacctno from reaflnk a, recflnk c, cfmast cf where c.custid = substr(a.reacctno,1,10) and nvl(a.clstxdate,a.todate -1) > V_CURRENTDATE
                        and a.frdate <= V_CURRENTDATE
                        and V_CURRENTDATE BETWEEN c.effdate and c.expdate and c.custid = cf.custid)re,
                (select afacctno, max(txdate) txdate  from  (select * from odmast union all select * from odmasthist) od where od.execamt <> 0 and deltd <> 'Y' group by afacctno) od
        WHERE    AF.CUSTID = CF.CUSTID
        AND      ATYPE.CDTYPE='CF'
        AND      ATYPE.CDNAME='AFTYPE'
        AND      AF.aftype=ATYPE.CDVAL
        AND      CTRY.CDTYPE='CF'
        AND      CTRY.CDNAME='COUNTRY'
        AND      CF.COUNTRY=CTRY.CDVAL
        and      AF.acctno = re.afacctno (+)
        and      af.acctno = od.afacctno (+)
        AND      AF.OPNDATE >= TO_DATE (F_DATE, 'DD/MM/YYYY')
        AND      AF.OPNDATE <= TO_DATE (T_DATE, 'DD/MM/YYYY')
        AND      CF.INCOMERANGE LIKE  V_STRINCOMERANGE
        AND      CF.EDUCATION   LIKE  V_STREDUCATION
        AND      CF.SECTOR      LIKE  V_STRSECTOR
        AND      AF.aftype      LIKE  V_STRAFTYPE
        AND      CF.CAREBY      LIKE  V_STRCAREBY
        and      case when AF.status in ('A','P') then 'Y'
                      else 'N' end like V_ACTIVE
        AND      SUBSTR(CF.CUSTID,1,4)  LIKE  V_STRBRID
        AND      SUBSTR(AF.acctno,1,4)  LIKE  V_STRPLACE
        ORDER BY AF.OPNDATE , AF.CUSTID
)
where loai_kh like V_ACTYPE
and custodycd like V_STRREFNAME
and ngay_dong >= to_date(C_F_DATE,'DD/MM/RRRR')
and ngay_dong <= to_date(C_T_DATE,'DD/MM/RRRR')
and case when ADD_MONTHS(txdate, 6) < v_currentdate then 'N'
         else 'Y' end like V_ISMATCHED


;



 EXCEPTION
   WHEN OTHERS
   THEN
    --insert into temp_bug(text) values('CF0001');commit;
      RETURN;
END;                                                              -- PROCEDURE
/

