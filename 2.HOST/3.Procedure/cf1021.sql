CREATE OR REPLACE PROCEDURE CF1021 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   pv_CODEID       IN       VARCHAR2

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
   V_branch  varchar2(5);
-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE

BEGIN

OPEN PV_REFCURSOR
  FOR
  Select * from registeronline where idcode=pv_CODEID ;

EXCEPTION
   WHEN OTHERS
   THEN

      RETURN;
End;
/

