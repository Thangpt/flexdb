CREATE OR REPLACE PROCEDURE cf1013 (
   PV_REFCURSOR     IN OUT   PKG_REPORT.REF_CURSOR,
   OPT              IN       VARCHAR2,
   BRID             IN       VARCHAR2,
   PV_CUSTODYCD     IN       VARCHAR2,
   PV_AFACCTNO      IN       VARCHAR2
       )
IS

--
-- PURPOSE: BAO CAO IN DE NGHI UNG TRUOC TIEN BAN TU DONG
-- MODIFICATION HISTORY
-- PERSON       DATE        COMMENTS
-- THENN        10-APR-2012 CREATED
-- ---------    ------      -------------------------------------------

    V_STROPTION         VARCHAR2  (5);
    V_STRBRID           VARCHAR2(100);
    V_BRID              VARCHAR2(4);

BEGIN
    -- GET REPORT'S PARAMETERS
    V_STROPTION := OPT;
    V_BRID := BRID;

     OPEN PV_REFCURSOR FOR
        SELECT CF.custid, CF.custodycd, AF.acctno, cf.fullname, to_char(cf.dateofbirth,'DD/mm/yyyy') dateofbirth,
            decode(cf.country,'234',cf.idcode,cf.tradingcode) idcode, to_char(decode(cf.country,'234',cf.iddate,cf.tradingcodedt),'dd/mm/yyyy') iddate,
            cf.idplace, cf.address, cf.email, cf.phone, cf.fax,
            TO_CHAR(AF.opndate,'DD/MM/YYYY') opndate
        FROM CFMAST CF, AFMAST AF
        WHERE CF.custid = AF.custid
            AND CF.custodycd = PV_CUSTODYCD
            AND AF.acctno = PV_AFACCTNO;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

