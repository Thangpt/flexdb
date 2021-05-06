CREATE OR REPLACE PROCEDURE re0081 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   CUSTID         IN       VARCHAR2,
   REGRP         IN       VARCHAR2
 )
IS
--bao cao gia tri giao dich
--created by Chaunh at 17/04/2014
    V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID          VARCHAR2 (40);    -- USED WHEN V_NUMOPTION > 0
    V_INBRID     VARCHAR2 (5);

    VF_DATE DATE;
    VT_DATE DATE;
    V_CUSTID varchar2(10);
    V_REGRP varchar2(10);
    V_REERNAME varchar2(50);
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

   ------------------------
   IF (REGRP <> 'ALL' OR trim(REGRP) is null)
   THEN
    V_REGRP := REGRP;
   ELSE
    V_REGRP := '%';
   END IF;
   -----------------------

   IF (CUSTID <> 'ALL' OR trim(CUSTID) IS NULL)
   THEN
        V_CUSTID := CUSTID;
   ELSE
    V_CUSTID := '%';
   END IF;
   ------------------------------
   VF_DATE := to_date(F_DATE,'DD/MM/RRRR');
   VT_DATE := to_date(T_DATE,'DD/MM/RRRR');
OPEN PV_REFCURSOR FOR
select V_CUSTID , V_REGRP ,RE.* from
    (
        SELECT GR.AUTOID ma_nhom, GR.FULLNAME ten_nhom, GR.CUSTID, GR.LEADER_NAME
            --, RE.ACCTNO, RE.REROLE, RE.TYPENAME, RE.FULLNAME
            , SUM(RE.INTBAL - NVL(DSF.MATCHAMT,0)) mg_gtgd
            , SUM(RE.INTAMT - NVL(DSF.FEEACR,0)) MG_PHIGD
            , SUM(RE.RFMATCHAMT - NVL(DSF.RFMATCHAMT,0)) MG_PHITRASO
            , SUM(RE.INTAMT - NVL(DSF.FEEACR,0) - (RE.RFMATCHAMT - NVL(DSF.RFMATCHAMT,0))) MG_PHITHUAN
            , SUM(NVL(DSF.MATCHAMT,0)) DSF_MATCHAMT
            , SUM(NVL(DSF.FEEACR,0)) DSF_FEEACR
            , SUM(NVL(DSF.RFMATCHAMT,0)) DSF_RFMATCHAMT
            , SUM(NVL(DSF.FEEACR,0) - NVL(DSF.RFMATCHAMT,0)) DSF_PHITHUAN
        FROM
        (
        SELECT TR.ACCTNO, TR.TODATE, RT.REROLE, RT.TYPENAME, CF.FULLNAME, SUM(INTBAL) INTBAL, SUM(INTAMT) INTAMT, SUM(RFMATCHAMT) RFMATCHAMT
        FROM (select * from reinttran union all select * from reinttrana) tr, RETYPE RT, CFMAST CF
        WHERE SUBSTR(TR.ACCTNO,11,4) = RT.ACTYPE AND SUBSTR(TR.ACCTNO,1,10) = CF.CUSTID
        AND RT.RETYPE = 'D' AND TR.TODATE BETWEEN VF_DATE and  VT_DATE
        GROUP BY TR.ACCTNO, TR.TODATE, RT.REROLE, RT.TYPENAME, CF.FULLNAME
        ) RE
        LEFT JOIN
        (
        SELECT REACCTNO, TODATE, SUM(MATCHAMT) MATCHAMT, SUM(FEEACR) FEEACR, SUM(RFMATCHAMT) RFMATCHAMT
        FROM REREVDGALL DSF WHERE TODATE BETWEEN VF_DATE and  VT_DATE
        GROUP BY REACCTNO, TODATE
        ) DSF ON RE.ACCTNO = DSF.REACCTNO AND RE.TODATE = DSF.TODATE
        LEFT JOIN
        (
        SELECT G.AUTOID, G.FULLNAME, G.CUSTID, CF.FULLNAME LEADER_NAME, G.EFFDATE, G.EXPDATE, GL.REACCTNO, GL.FRDATE, NVL(GL.CLSTXDATE -1 , GL.TODATE) TODATE
        FROM (SELECT * FROM REGRP UNION ALL SELECT * FROM REGRPHIST) G, REGRPLNK GL , CFMAST CF
        WHERE GL.REFRECFLNKID = G.AUTOID AND CF.CUSTID = G.CUSTID
        ) GR ON RE.ACCTNO = GR.REACCTNO AND RE.TODATE BETWEEN GR.EFFDATE AND GR.EXPDATE
                                        AND RE.TODATE BETWEEN GR.FRDATE AND GR.TODATE
        group by GR.AUTOID , GR.FULLNAME , GR.CUSTID, GR.LEADER_NAME
                --,RE.ACCTNO, RE.REROLE, RE.TYPENAME, RE.FULLNAME
    ) re
where TO_CHAR(RE.ma_nhom) like V_REGRP  AND re.custid like V_CUSTID
;

EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
End;
/

