CREATE OR REPLACE PROCEDURE cf0017 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   I_BRIDGD       IN       VARCHAR2
 )
IS
--
-- PURPOSE: BAO CAO DSKH MO TK (GUI HNX)
-- MODIFICATION HISTORY
-- PERSON      DATE      COMMENTS
-- QUOCTA   23-12-2011   CREATED
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
      V_BRNAME   :=  ' To�n c�ng ty ';
   END IF;

   -- GET REPORT'S DATA

OPEN PV_REFCURSOR
FOR

    SELECT CF.FULLNAME,case when cf.custatcom = 'Y' then '005' else 'N/A' end  TVCODE, CF.CUSTODYCD, CF.IDCODE, CF.ADDRESS, CF.IDDATE, CF.IDPLACE,
           (CASE WHEN CF.CUSTTYPE = 'I' THEN 'CN' WHEN CF.CUSTTYPE = 'B' THEN 'TC' END) CUSTTYPE_NAME,
           CASE WHEN a2.cdval = '005' THEN '1'
                WHEN a2.cdval = '008' THEN '2'
                WHEN a2.cdval = '006' THEN '3'
                WHEN a2.cdval = '007' THEN '4'
                WHEN a2.cdval = '010' THEN '6'
                WHEN a2.cdval = '011' THEN '7'
                WHEN a2.cdval = '012' THEN '8'
                WHEN a2.cdval = '013' THEN '10'
                WHEN a2.cdval = '014' THEN '5'
                ELSE '99'
           END businesstype,--a2.cdcontent businesstype,
           CF.OPNDATE, AL.CDCONTENT COUNTRY_NAME, V_BRNAME BRNAME
    FROM  CFMAST CF, ALLCODE AL, allcode a2
    WHERE CF.COUNTRY = AL.CDVAL
    AND   AL.CDNAME  = 'COUNTRY'
    AND   AL.CDTYPE  = 'CF'
    AND     a2.cdname = 'BUSINESSTYPE'
    AND     a2.cdtype = 'CF'
    AND     a2.cdval = cf.businesstype
    --and   cf.status='A'
    --and   cf.custatcom = 'Y'
    AND   CF.OPNDATE >= V_F_DATE AND cf.opndate <= V_T_DATE
    AND   CF.BRID    LIKE V_I_BRIDGD
    ORDER BY CF.CUSTODYCD
/*
001 Cty nh� nu?c
002 Cty c? ph?n
003 Cty TNHH
004 Cty FDI
005 Ng�n h�ng
006 Cty ch?ng kho�n
007 Cty b?o hi?m
008 Qu? d?u tu
009 Kh�c
-----------------
1: Ng�n h�ng
2: Qu? d?u tu
3: CTCK
4: CT B?o hi?m
5: CT�T t�i ch�nh
6: CT�T ch?ng kho�n
7: CT Qu?n l� qu?
8: CT ni�m y?t (c? TT NY v� Upcom)
10: Qu? d?u tu th�nh l?p theo Plu?t VN (ch� � n?u l� Q�T th�nh l?p theo PL VN th� ghi lo?i l� 2,10)
99: kh�c
C�ch ghi: C�n b? ki?m tra c�c T�i kho?n c?a  t? ch?c ph�t sinh trong th�ng xem t? ch?c d� c� thu?c lo?i h�nh g� d? ghi theo quy d?nh
N?u 1 t? ch?c thu?c nhi?u lo?i h�nh t? ch?c th� c�c lo?i h�nh t? ch?c ghi c�ch nhau b?i d?u ph?y, kh�ng c� d?u c�ch
*/
;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;


-- End of DDL Script for Procedure HOST.CF0017
/

