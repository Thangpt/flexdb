CREATE OR REPLACE PROCEDURE HDGDPS (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   PV_AUTOID      IN       NUMBER
)
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- mai.nguyenphuong
-- ---------   ------  -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (40);        -- USED WHEN V_NUMOPTION > 0
   V_INBRID           VARCHAR2 (4);

   V_CURRENTDATE      date;
-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
   V_STROPTION := upper(OPT);
   V_INBRID := BRID;

   IF (V_STROPTION = 'A') THEN
      V_STRBRID := '%';
   ELSE if (V_STROPTION = 'B') then
            select brgrp.mapid into V_STRBRID from brgrp where brgrp.brid = V_INBRID;
        else
            V_STRBRID := V_INBRID;
        end if;
   END IF;
   select to_date(varvalue,'DD/MM/RRRR') into V_CURRENTDATE from sysvar where varname = 'CURRDATE';

OPEN PV_REFCURSOR
FOR
    SELECT re.custodycd,V_CURRENTDATE txdate,
    re.customername,re.idcode,re.iddate
     FROM registeronline re
     WHERE re.autoid=PV_AUTOID and substr(nvl(re.REGISTERSERVICES, 'NNNNN'),5,1) = 'Y'  ; -- 1.8.1.9.P2: them dieu kien

 EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/
