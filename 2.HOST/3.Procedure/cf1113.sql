CREATE OR REPLACE PROCEDURE cf1113 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   PV_CUSTODYCD         IN       VARCHAR2,
   PV_AFACCTNO        IN       VARCHAR2,
   PV_CFRELATION    IN  VARCHAR2,
   PV_PLSENT    IN VARCHAR2
 )
IS

    V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID          VARCHAR2 (40);    -- USED WHEN V_NUMOPTION > 0
    V_INBRID     VARCHAR2 (5);
    C_EMAIL varchar(1);
     C_SMS varchar(1);
      C_SK varchar(1);


BEGIN

   V_STROPTION := upper(OPT);
   V_INBRID := BRID;

   if(V_STROPTION = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := BRID;
        end if;
    end if;

OPEN PV_REFCURSOR FOR
SELECT
--KH
C.CUSTID, C.FULLNAME CM_FULLNAME,A.ACCTNO CM_ACCTNO,C.IDCODE CM_IDCODE,C.IDDATE CM_IDATE,C.IDPLACE CM_IDPLACE,C.CUSTODYCD CM_CUSTODYCD ,
B.FULLNAME RE_NAME,B.CHUC_VU RE_POSITION,
--MSB
S.VARVALUE MS_FULLNAME,S.VARDESC MS_POSITION,S2.VARVALUE MSB_AUTH, S2.EN_VARDESC MSB_AUTHDATE,
V_INBRID chi_nhanh
FROM CFMAST C, AFMAST A ,
    (
    select trim(r.custid) custid, c.fullname, a.cdcontent chuc_vu
    from CFRELATION r, cfmast c, allcode a
    where c.custid = trim(r.recustid) and a.cdname = 'RETYPE' and a.cdtype = 'CF' and a.cdval = r.retype AND C.CUSTID = NVL(PV_CFRELATION,' ')
    ) B, SYSVAR S, SYSVAR S2
WHERE C.CUSTID = A.CUSTID
AND C.CUSTID = B.CUSTID(+)
AND S.GRNAME = 'REPRESENT' AND S.VARNAME = PV_PLSENT AND S2.GRNAME = 'REPRESENT'
AND CASE WHEN PV_PLSENT ='MSBSREP01' THEN 'MSBSREPAUTH01'
        WHEN PV_PLSENT ='MSBSREP02' THEN 'MSBSREPAUTH02'
        WHEN PV_PLSENT ='MSBSREP03' THEN 'MSBSREPAUTH03' END = S2.VARNAME
AND C.CUSTODYCD LIKE PV_CUSTODYCD
AND A.ACCTNO LIKE PV_AFACCTNO
;
EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
End;
/

