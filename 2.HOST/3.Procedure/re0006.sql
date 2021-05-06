CREATE OR REPLACE PROCEDURE re0006 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   CUSTID         IN       VARCHAR2,
   GROUPID        IN       VARCHAR2,
   REROLE         IN       VARCHAR2
 )
IS

    V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID          VARCHAR2 (40);    -- USED WHEN V_NUMOPTION > 0
    V_INBRID     VARCHAR2 (5);
    V_CUSTID varchar2(10);
    V_REROLE varchar2(4);
    V_GROUPID varchar2(10);
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

    IF GROUPID <> 'ALL' THEN
        V_GROUPID := GROUPID;
    ELSE V_GROUPID := '%';
    END IF;

   ------------------------
   IF (REROLE <> 'ALL')
   THEN
    V_REROLE := REROLE;
   ELSE
    V_REROLE := '%';
   END IF;
   -----------------------

   IF (CUSTID <> 'ALL')
   THEN
        V_CUSTID := CUSTID;
   else
        V_CUSTID := '%';
   end if
   ;

   ------------------------------

OPEN PV_REFCURSOR FOR
SELECT  cfr.fullname fullname_re, cfl.fullname fullname_l,retype.actype ,retype.typename,al.cdcontent rerole
 ,frdate,todate,cfr.custodycd, cfr. mobile mobilesms,reg.autoid grpid,reg.fullname grpfullname, NVL(intbal,0) intbal, recf.retax taxcode,cfr.custodycd custid
 ,recf.rebankacct, recf.recontract, CASE WHEN retype.rerole ='RD' THEN   cfrel.fullname ELSE ' ' END  cfrel_fullname
FROM regrplnk regrl ,regrp reg, cfmast cfr, cfmast cfl, retype,ALLCODE AL ,recflnk recf,cfmast cfrel ,
(SELECT SUM(intbal) intbal, acctno FROM
 (SELECT * FROM reinttrana  UNION SELECT * FROM reinttran ) RE
  WHERE  frdate>= TO_DATE(F_DATE,'DD/MM/YYYY')
  AND todate <= TO_DATE(T_DATE,'DD/MM/YYYY')
GROUP BY  acctno) RE
WHERE regrl.refrecflnkid = reg.autoid
AND RE.ACCTNO = REGRL.REACCTNO
AND regrl.custid = cfr.custid
AND reg.custid = cfl.custid
AND substr(regrl.reacctno,11) = retype.actype
AND retype.rerole = al.cdval
AND al.cdname ='REROLE'
AND AL.CDTYPE='RE'
AND regrl.STATUS ='A'
AND recf.custid = substr( regrl.reacctno,1,10)
AND recf.relcustid = cfrel.custid(+)
AND regrl.reacctno = RE.ACCTNO(+)
AND cfr.custid LIKE V_CUSTID
AND retype.rerole LIKE V_REROLE
AND reg.autoid LIKE V_GROUPID
UNION ALL
SELECT DISTINCT   cfr.fullname fullname_re, NVL(cfl.fullname, CFLL.FULLNAME) fullname_l,retype.actype ,retype.typename,al.cdcontent rerole
 ,regrl.frdate,regrl.todate,cfr.custodycd, cfr. mobile mobilesms,reg.autoid grpid,nvl(reg.fullname,rl.fullname) grpfullname, NVL(intbal,0) intbal, recf.retax taxcode,cfr.custodycd custid
 ,recf.rebankacct, recf.recontract, CASE WHEN retype.rerole ='RD' THEN   cfrel.fullname ELSE ' ' END  cfrel_fullname
FROM regrplnk regrl ,regrp reg, cfmast cfr, cfmast cfl, retype,ALLCODE AL ,recflnk recf,cfmast cfrel ,REMAST REM,  regrplnk regrll,regrp RL ,RETYPE RETYPEL,CFMAST CFLL,
(SELECT SUM(intbal) intbal, acctno FROM
 (SELECT * FROM reinttrana  UNION SELECT * FROM reinttran ) RE
   WHERE  frdate>= TO_DATE(F_DATE,'DD/MM/YYYY')
  AND todate <= TO_DATE(T_DATE,'DD/MM/YYYY')
GROUP BY  acctno) RE
WHERE REM.ACCTNO = RE.ACCTNO
AND REM.CUSTID = CFR.CUSTID
AND REM.ACCTNO = REGRL.REACCTNO(+)
AND regrl.refrecflnkid = reg.autoid(+)
AND reg.custid = cfl.custid(+)
AND SUBSTR(REM.acctno,11) = retype.actype
AND retype.rerole = al.cdval
AND al.cdname ='REROLE'
AND AL.CDTYPE='RE'
AND RETYPE.rerole='RD'
AND regrl.STATUS ='A'
AND REM.CUSTID = RECF.CUSTID
AND recf.relcustid = cfrel.custid(+)
AND RECF.relcustid =regrll.custid
AND regrll.refrecflnkid = rl.autoid
AND RETYPEL.ACTYPE = SUBSTR(REGRLL.REACCTNO,11)
AND CFLL.CUSTID = regrll.CUSTID
AND cfr.custid LIKE V_CUSTID
AND retype.rerole LIKE V_REROLE
AND reg.autoid LIKE V_GROUPID

;

EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
End;
/

