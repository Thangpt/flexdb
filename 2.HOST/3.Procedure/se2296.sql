CREATE OR REPLACE PROCEDURE SE2296(
   PV_REFCURSOR     IN OUT   PKG_REPORT.REF_CURSOR,
   OPT              IN       VARCHAR2,
   BRID             IN       VARCHAR2,
   F_DATE           IN       VARCHAR2,
   T_DATE           IN       VARCHAR2
        )
   IS
--
-- To modify this template, edit file PROC.TXT in TEMPLATE
-- directory of SQL Navigator
-- Purpose: Briefly explain the functionality of the procedure
-- BANG KE KHAI CAM CO
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- PHUONGNN   15-APR-10  CREATE
-- ---------   ------  -------------------------------------------

    V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0


BEGIN
    -- GET REPORT'S PARAMETERS
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;
   
 OPEN PV_REFCURSOR
    FOR
    select cf.fullname, vw.filtercd, dtl.afacctno, dtl.txdate, dtl.codeid, dtl.mortage
    from semortagedtl dtl , vw_custodycd_subaccount vw , cfmast cf
    where  dtl.afacctno = vw.value  
    and  cf.custid = dtl.afacctno and dtl.deltd = 'N' and dtl.status = 'C'
    and dtl.txdate >= to_date(F_DATE , 'DD/MM/RRRR')
    and dtl.txdate <= to_date(T_DATE , 'DD/MM/RRRR');
    
EXCEPTION
    WHEN OTHERS
   THEN
      RETURN;
END;
/

