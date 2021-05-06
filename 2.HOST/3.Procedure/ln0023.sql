CREATE OR REPLACE PROCEDURE ln0023 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   MAKER          IN       VARCHAR2,
   CAREBY         IN       VARCHAR2,
   I_BRID         IN       VARCHAR2

   )
IS
   V_STROPTION      VARCHAR2 (5);             -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID         VARCHAR2 (5);

   V_CUSTODYCD      VARCHAR2 (20);
   V_AFACCTNO       VARCHAR2 (20);
   V_STRBRGID       VARCHAR2 (10);
   V_CAREBY         VARCHAR2 (20);
   V_MAKER          VARCHAR2 (20);
   V_BRID           VARCHAR2 (20);
   V_FROMDATE       DATE;
   V_TODATE         DATE;

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

    IF(MAKER <> 'ALL') THEN
        V_MAKER := MAKER;
    ELSE
        V_MAKER := '%';
    END IF;

    IF(CAREBY <> 'ALL') THEN
        V_CAREBY := CAREBY;
    ELSE
        V_CAREBY := '%';
    END IF;

    IF(I_BRID <> 'ALL') THEN
        V_BRID := I_BRID;
    ELSE
        V_BRID := '%';
    END IF;

    V_FROMDATE :=      TO_DATE(F_DATE,'DD/MM/RRRR');
    V_TODATE :=        TO_DATE(T_DATE,'DD/MM/RRRR');

OPEN PV_REFCURSOR
FOR

SELECT ol1.userid, ol1.tlfullname, sum(ol1.errnum) errnum, sum(ol1.errnum1) errnum1, ol1.grpname, ol1.brname
FROM
(   --user cap la MG quan ly cua TK
    SELECT ol.userid, cf.fullname tlfullname, 0 errnum, 1 errnum1, rg.fullname grpname, br.brname, rl.reftlid
    FROM olndetail ol, brgrp br, reaflnk re, recflnk rl, regrplnk gl, regrp rg, retype rt, cfmast cf
    WHERE ol.acctno = re.afacctno AND substr(re.reacctno,1,10) = rl.custid
        AND rl.custid = cf.custid AND rl.brid = br.brid
        AND ol.duedate >= re.frdate AND ol.duedate <= nvl(re.clstxdate-1,re.todate)
        AND ol.duedate >= gl.frdate AND ol.duedate <= nvl(gl.clstxdate-1,gl.todate)
        AND re.reacctno = gl.reacctno AND gl.refrecflnkid = rg.autoid
        --AND ol.duedate >= rg.effdate AND ol.duedate <= rg.expdate
        AND ol.duedate >= rl.effdate AND ol.duedate <= rl.expdate
        AND ol.userid = nvl(rl.reftlid,'xxx') AND substr(re.reacctno,11,6) = rt.actype AND rt.rerole IN ('BM')
        AND ol.status = 'E' AND rl.reftlid LIKE V_MAKER
        AND ol.date0037 BETWEEN V_FROMDATE AND V_TODATE
        AND rl.brid LIKE V_BRID AND rg.autoid LIKE V_CAREBY
UNION ALL
    --user cap ko la MG quan ly cua TK
    SELECT ol.userid, cf.fullname tlfullname, 1 errnum, 0 errnum1, rg.fullname grpname, br.brname, rl.reftlid
    FROM olndetail ol, brgrp br, recflnk rl, regrp rg, cfmast cf, reaflnk re, recflnk rl2, retype rt,
        (SELECT DISTINCT gl.custid, gl.refrecflnkid, max(frdate) frdate, max(todate) todate, max(clstxdate) clstxdate FROM regrplnk gl GROUP BY gl.custid, gl.refrecflnkid) gl
    WHERE ol.userid = nvl(rl.reftlid,'xxx') AND rl.custid = gl.custid
        AND rl.custid = cf.custid AND rl.brid = br.brid
        AND ol.acctno = re.afacctno AND substr(re.reacctno,1,10) = rl2.custid AND ol.userid <> nvl(rl2.reftlid,'xxx')
        AND ol.duedate >= rl.effdate AND ol.duedate <= rl.expdate
        AND ol.duedate >= gl.frdate AND ol.duedate <= nvl(gl.clstxdate-1,gl.todate)
        AND ol.duedate >= re.frdate AND ol.duedate <= nvl(re.clstxdate-1,re.todate)
        AND gl.refrecflnkid = rg.autoid AND substr(re.reacctno,11,6) = rt.actype AND rt.rerole IN ('BM')
        --AND ol.duedate >= rg.effdate AND ol.duedate <= rg.expdate
        AND ol.status = 'E' AND ol.userid LIKE V_MAKER
        AND ol.date0037 BETWEEN V_FROMDATE AND V_TODATE
        AND rl.brid LIKE V_BRID AND rg.autoid LIKE V_CAREBY
UNION ALL
    --MG quan ly cua TK
    SELECT rl.reftlid userid, cf.fullname tlfullname, 0 errnum, 1 errnum1, rg.fullname grpname, br.brname, ol.userid reftlid
    FROM olndetail ol, brgrp br, reaflnk re, recflnk rl, regrplnk gl, regrp rg, retype rt, cfmast cf
    WHERE ol.acctno = re.afacctno AND substr(re.reacctno,1,10) = rl.custid
        AND rl.custid = cf.custid AND rl.brid = br.brid
        AND ol.duedate >= re.frdate AND ol.duedate <= nvl(re.clstxdate-1,re.todate)
        AND ol.duedate >= gl.frdate AND ol.duedate <= nvl(gl.clstxdate-1,gl.todate)
        AND re.reacctno = gl.reacctno AND gl.refrecflnkid = rg.autoid
        --AND ol.duedate >= rg.effdate AND ol.duedate <= rg.expdate
        AND ol.duedate >= rl.effdate AND ol.duedate <= rl.expdate
        AND ol.userid <> nvl(rl.reftlid,'xxx') AND substr(re.reacctno,11,6) = rt.actype AND rt.rerole IN ('BM')
        AND ol.status = 'E' AND rl.reftlid LIKE V_MAKER
        AND ol.date0037 BETWEEN V_FROMDATE AND V_TODATE
        AND rl.brid LIKE V_BRID AND rg.autoid LIKE V_CAREBY
) ol1
GROUP BY ol1.userid, ol1.tlfullname, ol1.grpname, ol1.brname
ORDER BY ol1.tlfullname
;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

