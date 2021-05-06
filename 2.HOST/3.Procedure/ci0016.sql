CREATE OR REPLACE PROCEDURE ci0016 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   TXNUM          IN       VARCHAR2

       )
IS
--
-- PURPOSE: BANG KE UY NHIEM CHI
-- PERSON      DATE    COMMENTS
-- TRUONGLD   21-MAY-10  CREATED
-- ---------   ------  -------------------------------------------

   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0
   V_STRTXNUM     VARCHAR2 (20);

   CUR            PKG_REPORT.REF_CURSOR;

   V_DATE         DATE;
   V_CURR_DATE    DATE;

BEGIN

   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;


   V_STRTXNUM := TXNUM;

   V_DATE := TO_DATE(F_DATE,'DD/MM/RRRR');

   SELECT TO_DATE(VARVALUE,'DD/MM/RRRR') INTO V_CURR_DATE  FROM SYSVAR WHERE VARNAME='CURRDATE';
   -- GET REPORT'S PARAMETERS



OPEN PV_REFCURSOR  FOR
SELECT CIR.TXNUM, CF.CUSTODYCD, CI.AFACCTNO, CIR.BENEFCUSTNAME,
CIR.BENEFBANK, CIR.BENEFACCT, CIR.AMT, cir.txdate, cir.potxdate, CIR.POTXNUM, blog.requestid, CIR.txdesc, CF.Idcode, CF.Iddate, cir.FEETYPE
FROM CFMAST CF, CIMAST CI,
(SELECT CIR.*, TL.TXDESC FROM CIREMITTANCE CIR, VW_TLLOG_ALL TL WHERE CIR.deltd <> 'Y' AND TL.TXNUM=CIR.TXNUM AND TL.TXDATE=CIR.TXDATE) cir,
(SELECT * FROM borqslog UNION ALL SELECT * FROM borqsloghist) blog
WHERE CF.CUSTID = CI.CUSTID
  AND CI.ACCTNO = CIR.ACCTNO
  AND CIR.RMSTATUS ='C'
  AND CIR.TXNUM = blog.txnum (+)
  AND (BLOG.TXDATE  = to_date(CIR.Txdate,'DD/MM/RRRR') OR BLOG.TXDATE IS NULL)
  AND cir.potxnum = V_STRTXNUM
  AND cir.potxdate = V_DATE
ORDER BY CIR.Txdate, cir.TXNUM;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

