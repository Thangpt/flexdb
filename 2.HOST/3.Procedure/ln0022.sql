CREATE OR REPLACE PROCEDURE ln0022 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   REID           IN       VARCHAR2,
   CAREBY         IN       VARCHAR2,
   I_BRID         IN       VARCHAR2

   )
IS
   V_STROPTION      VARCHAR2 (5);             -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID         VARCHAR2 (5);

   V_CUSTODYCD      VARCHAR2 (20);
   V_CAREBY         VARCHAR2 (20);
   V_REID           VARCHAR2 (20);
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

    IF(PV_CUSTODYCD <> 'ALL') THEN
        V_CUSTODYCD := PV_CUSTODYCD;
    ELSE
        V_CUSTODYCD := '%';
    END IF;

    IF(CAREBY <> 'ALL') THEN
        V_CAREBY := CAREBY;
    ELSE
        V_CAREBY := '%';
    END IF;

    IF(REID <> 'ALL') THEN
        V_REID := REID;
    ELSE
        V_REID := '%';
    END IF;

    IF (I_BRID <> 'ALL') THEN
        V_BRID := I_BRID;
    ELSE
        V_BRID := '%';
    END IF;

    V_FROMDATE :=      TO_DATE(F_DATE,'DD/MM/RRRR');
    V_TODATE :=        TO_DATE(T_DATE,'DD/MM/RRRR');

OPEN PV_REFCURSOR
FOR
SELECT custodycd, fullname,  sum(errnum) errnum, careby, brid, broker
FROM
(
    SELECT cf.custodycd, af.acctno, cf.fullname, COUNT (ol.status) errnum, rg.fullname careby, br.brname brid, cf2.fullname broker
    FROM olndetail ol, cfmast cf, afmast af, reaflnk raf, regrplnk rgl, regrp rg, brgrp br, recflnk rl, cfmast cf2
    WHERE cf.custid = af.custid AND ol.acctno = af.acctno AND ol.status = 'E' AND rl.custid = cf2.custid
        AND ol.acctno = raf.afacctno AND ol.duedate >= raf.frdate AND ol.duedate <= nvl(raf.clstxdate-1,raf.todate)
        AND raf.reacctno = rgl.reacctno AND ol.duedate >= rgl.frdate AND ol.duedate <= nvl(rgl.clstxdate-1,rgl.todate)
        AND rgl.refrecflnkid = rg.autoid AND SUBSTR(raf.reacctno,1,10) = rl.custid
        AND cf.brid = br.brid AND ol.duedate >= rl.effdate AND ol.duedate <= rl.expdate
        AND cf.custodycd LIKE V_CUSTODYCD
        AND SUBSTR(raf.reacctno,1,10) LIKE V_REID AND rg.autoid LIKE V_CAREBY
        AND cf.brid LIKE V_BRID
        AND ol.date0037 BETWEEN V_FROMDATE AND V_TODATE
    GROUP BY cf.custodycd, cf.fullname, af.acctno, rg.fullname, br.brname, cf2.fullname
)
GROUP BY custodycd, fullname, careby, brid, broker
;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

