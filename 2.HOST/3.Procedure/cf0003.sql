CREATE OR REPLACE PROCEDURE cf0003 (
   pv_refcursor   IN OUT   pkg_report.ref_cursor,
   opt            IN       VARCHAR2,
   brid           IN       VARCHAR2,
   status         IN       VARCHAR2,
   aftype         IN       VARCHAR2
)
IS
--
-- Purpose: Briefly explain the functionality of the procedure
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- MinhTK   21-Nov-06  Created
-- ---------   ------  -------------------------------------------
   v_stroption   VARCHAR2 (5);            -- A: All; B: Branch; S: Sub-branch
   v_strbrid     VARCHAR2 (4);                   -- Used when v_numOption > 0
   v_strstatus   VARCHAR2 (20);
   v_straftype   VARCHAR2 (4);
-- Declare program variables as shown above
BEGIN
   v_stroption := opt;

   IF (v_stroption <> 'A') AND (brid <> 'ALL')
   THEN
      v_strbrid := brid;
   ELSE
      v_strbrid := '%%';
   END IF;

   -- Get report's parameters
   IF (status <> 'ALL')
   THEN
      v_strstatus := status;
   ELSE
      v_strstatus := '%%';
   END IF;

   IF (aftype <> 'ALL')
   THEN
      v_straftype := aftype;
   ELSE
      v_straftype := '%%';
   END IF;

   -- End of getting report's parameters

   -- Get report's data
   IF (v_stroption <> 'A') AND (brid <> 'ALL')
   THEN
      OPEN pv_refcursor
       FOR
            SELECT status, aftype, country country,total
            FROM (SELECT   status, aftype, country, COUNT (status) total
                      FROM (SELECT a2.cdcontent aftype, a1.cdcontent status ,a3.cdcontent country
                              FROM afmast af,
                                   allcode a1,
                                   allcode a2,
                                   brgrp br,
                                   cfmast cf,
                                   allcode a3
                             WHERE a1.cdtype = 'CF'
                               AND a1.cdname = 'STATUS'
                               AND a1.cdval = af.status
                               AND a2.cdtype = 'CF'
                               AND a2.cdname = 'AFTYPE'
                               AND a2.cdval = af.aftype
                               AND a3.cdname='COUNTRY'
                               AND cf.country=a3.cdval
                               AND af.custid=cf.custid
                               AND SUBSTR (af.acctno, 1, 4) = TRIM (br.brid)
                        AND TRIM(af.status) LIKE trim(v_strstatus)
                         and TRIM(af.aftype)    LIKE trim(v_straftype)
                         and trim(br.brid) LIKE trim(v_strbrid)
                    )
                  GROUP BY status, aftype,country
);
   ELSE
      OPEN pv_refcursor
       FOR
            SELECT status, aftype, country country,total
            FROM (SELECT   status, aftype, country, COUNT (status) total
                      FROM (SELECT a2.cdcontent aftype, a1.cdcontent status ,a3.cdcontent country
                              FROM afmast af,
                                   allcode a1,
                                   allcode a2,
                                   brgrp br,
                                   cfmast cf,
                                   allcode a3
                             WHERE a1.cdtype = 'CF'
                               AND a1.cdname = 'STATUS'
                               AND a1.cdval = af.status
                               AND a2.cdtype = 'CF'
                               AND a2.cdname = 'AFTYPE'
                               AND a2.cdval = af.aftype
                               AND a3.cdname='COUNTRY'
                               AND cf.country=a3.cdval
                               AND af.custid=cf.custid
                               AND SUBSTR (af.acctno, 1, 4) = TRIM (br.brid)                                AND TRIM(af.status) LIKE trim(v_strstatus)
                               AND TRIM(af.aftype)    LIKE trim(v_straftype) )
                  GROUP BY status, aftype,country
  
);
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- Procedure
/

