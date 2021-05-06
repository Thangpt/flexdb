CREATE OR REPLACE PROCEDURE gl0031 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   BANKID           IN      VARCHAR2
  )
IS

-- ---------   ------  -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (4);              -- USED WHEN V_NUMOPTION > 0
   V_STRFILEID        VARCHAR2 (20);

   v_strbankid         varchar2(20);
   v_FrDate DATE;
   v_ToDate DATE;
-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
   V_STROPTION := OPT;
   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   -- GET REPORT'S PARAMETERS

    IF BANKID <> 'ALL' THEN
    v_strbankid:= BANKID;
    ELSE
    v_strbankid:= '%';
    END IF;

    v_FrDate:= to_date(F_DATE,'DD/MM/RRRR');
    v_ToDate:= to_date(T_DATE,'DD/MM/RRRR');


   OPEN PV_REFCURSOR
      FOR
      SELECT t.tltxcd, t.fileid, t.bankid, t.refnum, t.busdate, t.custodycd, t.acctno, t.amt, t.description, t.txdate, t.txnum, b.bankacctno, b.fullname ownername
        FROM tblcashdeposit t, banknostro b
        WHERE t.bankid = b.shortname
        AND t.status = 'C'
        AND t.deltd = 'N'  --- 26/10/2010 Sinh update
        AND bankid LIKE v_strbankid
        AND t.busdate BETWEEN v_FrDate AND v_ToDate
      UNION ALL
      SELECT t.tltxcd, t.fileid, t.bankid, t.refnum, t.busdate, t.custodycd, t.acctno, t.amt, t.description, t.txdate, t.txnum, b.bankacctno, b.fullname ownername
        FROM tblcashdeposithist t, banknostro b
        WHERE t.bankid = b.shortname
        AND t.status = 'C'
        AND t.deltd = 'N'  --- 26/10/2010 Sinh update
        AND bankid LIKE v_strbankid
        AND t.busdate BETWEEN v_FrDate AND v_ToDate;


EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

