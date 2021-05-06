CREATE OR REPLACE PROCEDURE cf0004(
   pv_refcursor   IN OUT   pkg_report.ref_cursor,
   opt            IN       VARCHAR2,
   brid           IN       VARCHAR2,
   status         IN       VARCHAR2,
   branchid       in       varchar2
)
IS
--
-- Purpose: Briefly explain the functionality of the procedure
-- BAO CAO TRANG THAI GIAO DICH CUA TAI KHOAN THEO CHI NHANH
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- NAMNT   21-Nov-06  Created
-- ---------   ------  -------------------------------------------
   v_stroption   VARCHAR2 (5);            -- A: All; B: Branch; S: Sub-branch
   v_strbrid     VARCHAR2 (4);                   -- Used when v_numOption > 0
   v_strstatus   VARCHAR2 (4);
   v_strbranchid   VARCHAR2 (4);

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
     IF (branchid  <> 'ALL')
   THEN
      v_strbranchid  := branchid ;
   ELSE
      v_strbranchid := '%%';
   END IF;
   
   -- End of getting report's parameters

   -- Get report's data
   IF (v_stroption <> 'A') AND (brid <> 'ALL')
   THEN
      OPEN pv_refcursor
       FOR  SELECT  status, branchID, country country,total
            FROM (SELECT branchID, status,country, COUNT(status) Total
                  FROM(
                    SELECT br.brname branchID, al.cdcontent status, a3.cdcontent country
                    FROM afmast af,
                         allcode al,
                         brgrp br,
                         cfmast cf,
                         allcode a3
                   WHERE al.cdtype = 'CF'
                     AND al.cdname = 'STATUS'
                     AND al.cdval = af.status
                     AND a3.cdname='COUNTRY'
                     AND cf.country=a3.cdval
                     AND af.custid=cf.custid
                     AND br.brid = SUBSTR (acctno, 1, 4)
                     and af.status like  v_strstatus
                     and br.brid  like v_strbranchid )
                     GROUP BY status, branchID,country
                     ) ;
      ELSE
      OPEN pv_refcursor
       FOR SELECT  status, branchID, country country,total
            FROM (SELECT branchID, status, country, COUNT(status) Total FROM(
                    SELECT br.brname branchID, al.cdcontent status, a3.cdcontent country
                    FROM afmast af,
                         allcode al,
                         brgrp br,
                         cfmast cf,
                         allcode a3
                   WHERE al.cdtype = 'CF'
                     AND al.cdname = 'STATUS'
                     AND al.cdval = af.status
                     AND a3.cdname='COUNTRY'
                     AND cf.country=a3.cdval
                     AND af.custid=cf.custid
                     AND br.brid = SUBSTR (acctno, 1, 4)
                     and af.status like  v_strstatus
                     and br.brid  like v_strbranchid )
                     GROUP BY status, branchID,country) ;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- Procedure
/

