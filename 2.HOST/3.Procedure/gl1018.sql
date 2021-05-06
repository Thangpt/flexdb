CREATE OR REPLACE PROCEDURE gl1018 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   FDATE         IN        VARCHAR2,
   TDATE         IN       VARCHAR2,
   I_BRID         IN       VARCHAR2,
   TXBRID         IN       VARCHAR2

  )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- BAO CAO TAI KHOAN TIEN TONG HOP CUA NGUOI DAU TU
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- HUNG.LB    23/Aug/2010 UPDATED
-- TRUONGLD MODIFYED 10/04/2010
-- ---------   ------  -------------------------------------------

    CUR             PKG_REPORT.REF_CURSOR;
    V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);
    V_STRI_BRID    VARCHAR2 (20);
    V_STRTXBRID    VARCHAR2 (20);

BEGIN
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   IF (I_BRID <> 'ALL')
   THEN
      V_STRI_BRID := I_BRID;
   ELSE
      V_STRI_BRID := '%%';
   END IF;

      IF (TXBRID <> 'ALL')
   THEN
      V_STRTXBRID := TXBRID;
   ELSE
      V_STRTXBRID := '%%';
   END IF;

   -- GET REPORT'S PARAMETERS

--Tinh ngay nhan thanh toan bu tru


OPEN PV_REFCURSOR
   FOR

select txdate ,txnum, trans_type ,cf.custodycd , af.acctno,amount,TXBRID
from gl_exp_tran gl, afmast af,cfmast cf
where gl.custodycd = cf.custodycd
and cf.custid = af.custid   ;


EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

