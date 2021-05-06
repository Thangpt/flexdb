CREATE OR REPLACE PROCEDURE ln0021 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   TLTITLE        IN       VARCHAR2
   )
IS
   V_STROPTION      VARCHAR2 (5);             -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID         VARCHAR2 (5);

   V_TLTITLE        VARCHAR2 (20);
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

    IF(TLTITLE <> 'ALL') THEN
        V_TLTITLE := TLTITLE;
    ELSE
        V_TLTITLE := '%';
    END IF;

    V_FROMDATE :=      TO_DATE(F_DATE,'DD/MM/RRRR');
    V_TODATE :=        TO_DATE(T_DATE,'DD/MM/RRRR');

OPEN PV_REFCURSOR
FOR

SELECT sum(ol.toamt) t0amtpending, ol.tlid, a1.cdcontent tltitle, tl.tlfullname,
    sum(CASE WHEN ol.period = 0 THEN nvl(ol.toamt,0) ELSE 0 END) T0,
    sum(CASE WHEN ol.period = 1 THEN nvl(ol.toamt,0) ELSE 0 END) T1,
    sum(CASE WHEN ol.period = 2 THEN nvl(ol.toamt,0) ELSE 0 END) T2,
    '0' T3
FROM olndetail ol, tlprofiles tl, allcode a1
WHERE ol.tlid = tl.tlid AND ol.status IN ('A','E') AND ol.t0amtpending > 0
    AND tl.tltitle LIKE V_TLTITLE
    AND tl.tltitle = a1.cdval AND a1.cdname = 'TLTITLE'
    AND ol.duedate BETWEEN V_FROMDATE AND V_TODATE
GROUP BY  ol.tlid, a1.cdcontent, tl.tlfullname
;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

