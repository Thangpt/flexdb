CREATE OR REPLACE PROCEDURE cf0019 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   I_BRIDGD       IN       VARCHAR2
 )
IS
--
-- PURPOSE: DSKH DA TAT TOAN TK (BC GUI HNX)
-- MODIFICATION HISTORY
-- PERSON      DATE      COMMENTS
-- QUOCTA   24-12-2011   CREATED - NOEL
-- ---------   ------  -------------------------------------------

   V_STROPTION         VARCHAR2  (5);
   V_STRBRID           VARCHAR2  (4);

   V_F_DATE            DATE;
   V_T_DATE            DATE;

   V_I_BRIDGD          VARCHAR2(100);
   V_BRNAME            NVARCHAR2(400);

BEGIN
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   -- GET REPORT'S PARAMETERS
   V_F_DATE        := TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
   V_T_DATE        := TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);

   IF (I_BRIDGD <> 'ALL' OR I_BRIDGD <> '')
   THEN
      V_I_BRIDGD :=  I_BRIDGD;
   ELSE
      V_I_BRIDGD := '%%';
   END IF;

   IF (I_BRIDGD <> 'ALL' OR I_BRIDGD <> '')
   THEN
      BEGIN
            SELECT BRNAME INTO V_BRNAME FROM BRGRP WHERE BRID LIKE I_BRIDGD;
      END;
   ELSE
      V_BRNAME   :=  'To?n c?ng ty';
   END IF;

   -- GET REPORT'S DATA

OPEN PV_REFCURSOR
FOR

    SELECT CF.FULLNAME, '005' TVCODE, CF.CUSTODYCD, CF.IDCODE, CF.ADDRESS, CF.IDDATE, CF.IDPLACE,
           (CASE WHEN CF.CUSTTYPE = 'I' THEN 'CN' WHEN CF.CUSTTYPE = 'B' THEN 'TC' END) CUSTTYPE_NAME,
           CF.OPNDATE, AL.CDCONTENT COUNTRY_NAME, CF.CFCLSDATE, V_BRNAME BRNAME
    FROM  CFMAST CF, ALLCODE AL
    WHERE CF.COUNTRY = AL.CDVAL
    AND   AL.CDNAME  = 'COUNTRY'
    AND   AL.CDTYPE  = 'CF'
    AND   CF.CFCLSDATE BETWEEN V_F_DATE AND V_T_DATE
    AND   CF.BRID      LIKE V_I_BRIDGD
    AND   CF.STATUS    = 'C'

;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;


-- End of DDL Script for Procedure HOST.CF0019
/

