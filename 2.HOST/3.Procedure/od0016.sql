CREATE OR REPLACE PROCEDURE od0016(
   pv_refcursor   IN OUT   pkg_report.ref_cursor,
   opt            IN       VARCHAR2,
   brid           IN       VARCHAR2,
   f_date         IN       VARCHAR2,
   t_date         IN       VARCHAR2
)
IS
-- BAO CAO THONG KE SO LUONG LENH THEO PHUONG THUC DAT LENH
-- Purpose: Briefly explain the functionality of the procedure
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- AnhLTV   20-Dec-06  Created
-- TheNN    23-Dec-06  Modified
-- ---------   ------  -------------------------------------------
   v_stroption        VARCHAR2 (5);       -- A: All; B: Branch; S: Sub-branch
   v_strbrid          VARCHAR2 (4);              -- Used when v_numOption > 0

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
   -- End of getting report's parameters

   -- Get report's data
   IF (v_stroption <> 'A') AND (brid <> 'ALL')
   THEN
      OPEN pv_refcursor
       FOR
          SELECT TXDATE, BRID, IODCOUNT, BODCOUNT, ODSUM,
                 IFODCOUNT, BFODCOUNT, FODSUM,
                 ITODCOUNT, BTODCOUNT, TODSUM,
                 IAODCOUNT, BAODCOUNT, AODSUM,
                 IOODCOUNT, BOODCOUNT, OODSUM
          FROM
            (SELECT TXDATE, BRID, IODCOUNT, BODCOUNT, IFODCOUNT,
                    BFODCOUNT, ITODCOUNT, BTODCOUNT,
                    IAODCOUNT, BAODCOUNT, IOODCOUNT, BOODCOUNT,
                    (IODCOUNT + BODCOUNT) ODSUM, (IFODCOUNT + BFODCOUNT) FODSUM,
                    (ITODCOUNT + BTODCOUNT) TODSUM, (IAODCOUNT + BAODCOUNT) AODSUM,
                    (IOODCOUNT + BOODCOUNT) OODSUM
                FROM (
                    SELECT TXDATE, BRID, SUM(IODCOUNT) IODCOUNT, SUM(BODCOUNT) BODCOUNT, SUM(IFODCOUNT) IFODCOUNT,
                        SUM(BFODCOUNT) BFODCOUNT, SUM(ITODCOUNT) ITODCOUNT, SUM(BTODCOUNT) BTODCOUNT,
                        SUM(IAODCOUNT) IAODCOUNT, SUM(BAODCOUNT) BAODCOUNT, SUM(IOODCOUNT) IOODCOUNT, SUM(BOODCOUNT) BOODCOUNT
                    FROM (
                        SELECT OD.TXDATE, CF.BRID, 1 IODCOUNT, 0 BODCOUNT, 0 IFODCOUNT, 0 BFODCOUNT,
                            0 ITODCOUNT, 0 BTODCOUNT, 0 IAODCOUNT, 0 BAODCOUNT, 0 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMAST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'I'
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 1 BODCOUNT, 0 IFODCOUNT, 0 BFODCOUNT, 0 ITODCOUNT, 0 BTODCOUNT, 0 IAODCOUNT,
                            0 BAODCOUNT, 0 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMAST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'B'
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 0 BODCOUNT, 1 IFODCOUNT, 0 BFODCOUNT, 0 ITODCOUNT, 0 BTODCOUNT, 0 IAODCOUNT,
                            0 BAODCOUNT, 0 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMAST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'I' AND OD.VIA = 'F'
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 0 BODCOUNT, 0 IFODCOUNT, 1 BFODCOUNT, 0 ITODCOUNT, 0 BTODCOUNT, 0 IAODCOUNT,
                            0 BAODCOUNT, 0 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMAST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'B' AND OD.VIA = 'F'                  
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 0 BODCOUNT, 0 IFODCOUNT, 0 BFODCOUNT, 1 ITODCOUNT, 0 BTODCOUNT, 0 IAODCOUNT,
                            0 BAODCOUNT, 0 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMAST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'I' AND OD.VIA = 'T'
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 0 BODCOUNT, 0 IFODCOUNT, 0 BFODCOUNT, 0 ITODCOUNT, 1 BTODCOUNT, 0 IAODCOUNT,
                            0 BAODCOUNT, 0 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMAST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'B' AND OD.VIA = 'T'
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 0 BODCOUNT, 0 IFODCOUNT, 0 BFODCOUNT, 0 ITODCOUNT, 0 BTODCOUNT, 1 IAODCOUNT,
                            0 BAODCOUNT, 0 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMAST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'I' AND OD.VIA = 'A'
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 0 BODCOUNT, 0 IFODCOUNT, 0 BFODCOUNT, 0 ITODCOUNT, 0 BTODCOUNT, 0 IAODCOUNT,
                            1 BAODCOUNT, 0 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMAST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'B' AND OD.VIA = 'A'
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 0 BODCOUNT, 0 IFODCOUNT, 0 BFODCOUNT, 0 ITODCOUNT, 0 BTODCOUNT, 0 IAODCOUNT,
                            0 BAODCOUNT, 1 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMAST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'I' AND OD.VIA = 'O'
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 0 BODCOUNT, 0 IFODCOUNT, 0 BFODCOUNT, 0 ITODCOUNT, 0 BTODCOUNT, 0 IAODCOUNT,
                            0 BAODCOUNT, 0 IOODCOUNT, 1 BOODCOUNT
                        FROM CFMAST CF, ODMAST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'B' AND OD.VIA = 'O')
                    GROUP BY TXDATE, BRID)
                
            UNION ALL
            SELECT TXDATE, BRID, IODCOUNT, BODCOUNT, IFODCOUNT,
                    BFODCOUNT, ITODCOUNT, BTODCOUNT,
                    IAODCOUNT, BAODCOUNT, IOODCOUNT, BOODCOUNT,
                    (IODCOUNT + BODCOUNT) ODSUM, (IFODCOUNT + BFODCOUNT) FODSUM,
                    (ITODCOUNT + BTODCOUNT) TODSUM, (IAODCOUNT + BAODCOUNT) AODSUM,
                    (IOODCOUNT + BOODCOUNT) OODSUM
                FROM (
                    SELECT TXDATE, BRID, SUM(IODCOUNT) IODCOUNT, SUM(BODCOUNT) BODCOUNT, SUM(IFODCOUNT) IFODCOUNT,
                        SUM(BFODCOUNT) BFODCOUNT, SUM(ITODCOUNT) ITODCOUNT, SUM(BTODCOUNT) BTODCOUNT,
                        SUM(IAODCOUNT) IAODCOUNT, SUM(BAODCOUNT) BAODCOUNT, SUM(IOODCOUNT) IOODCOUNT, SUM(BOODCOUNT) BOODCOUNT
                    FROM (
                        SELECT OD.TXDATE, CF.BRID, 1 IODCOUNT, 0 BODCOUNT, 0 IFODCOUNT, 0 BFODCOUNT,
                            0 ITODCOUNT, 0 BTODCOUNT, 0 IAODCOUNT, 0 BAODCOUNT, 0 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMASTHIST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'I'
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 1 BODCOUNT, 0 IFODCOUNT, 0 BFODCOUNT, 0 ITODCOUNT, 0 BTODCOUNT, 0 IAODCOUNT,
                            0 BAODCOUNT, 0 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMASTHIST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'B'
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 0 BODCOUNT, 1 IFODCOUNT, 0 BFODCOUNT, 0 ITODCOUNT, 0 BTODCOUNT, 0 IAODCOUNT,
                            0 BAODCOUNT, 0 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMASTHIST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'I' AND OD.VIA = 'F'
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 0 BODCOUNT, 0 IFODCOUNT, 1 BFODCOUNT, 0 ITODCOUNT, 0 BTODCOUNT, 0 IAODCOUNT,
                            0 BAODCOUNT, 0 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMASTHIST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'B' AND OD.VIA = 'F'                  
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 0 BODCOUNT, 0 IFODCOUNT, 0 BFODCOUNT, 1 ITODCOUNT, 0 BTODCOUNT, 0 IAODCOUNT,
                            0 BAODCOUNT, 0 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMASTHIST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'I' AND OD.VIA = 'T'
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 0 BODCOUNT, 0 IFODCOUNT, 0 BFODCOUNT, 0 ITODCOUNT, 1 BTODCOUNT, 0 IAODCOUNT,
                            0 BAODCOUNT, 0 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMASTHIST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'B' AND OD.VIA = 'T'
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 0 BODCOUNT, 0 IFODCOUNT, 0 BFODCOUNT, 0 ITODCOUNT, 0 BTODCOUNT, 1 IAODCOUNT,
                            0 BAODCOUNT, 0 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMASTHIST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'I' AND OD.VIA = 'A'
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 0 BODCOUNT, 0 IFODCOUNT, 0 BFODCOUNT, 0 ITODCOUNT, 0 BTODCOUNT, 0 IAODCOUNT,
                            1 BAODCOUNT, 0 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMASTHIST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'B' AND OD.VIA = 'A'
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 0 BODCOUNT, 0 IFODCOUNT, 0 BFODCOUNT, 0 ITODCOUNT, 0 BTODCOUNT, 0 IAODCOUNT,
                            0 BAODCOUNT, 1 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMASTHIST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'I' AND OD.VIA = 'O'
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 0 BODCOUNT, 0 IFODCOUNT, 0 BFODCOUNT, 0 ITODCOUNT, 0 BTODCOUNT, 0 IAODCOUNT,
                            0 BAODCOUNT, 0 IOODCOUNT, 1 BOODCOUNT
                        FROM CFMAST CF, ODMASTHIST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'B' AND OD.VIA = 'O')
                    GROUP BY TXDATE, BRID)                  
          ) v
          WHERE v.txdate >= TO_DATE(f_date, 'DD/MM/YYYY')
                AND v.txdate <= TO_DATE(t_date, 'DD/MM/YYYY')
                AND v.brid LIKE v_strbrid
          ORDER BY TXDATE;

   ELSE
      OPEN pv_refcursor
       FOR
         SELECT TXDATE, BRID, IODCOUNT, BODCOUNT, ODSUM,
                 IFODCOUNT, BFODCOUNT, FODSUM,
                 ITODCOUNT, BTODCOUNT, TODSUM,
                 IAODCOUNT, BAODCOUNT, AODSUM,
                 IOODCOUNT, BOODCOUNT, OODSUM
          FROM
            (SELECT TXDATE, BRID, IODCOUNT, BODCOUNT, IFODCOUNT,
                    BFODCOUNT, ITODCOUNT, BTODCOUNT,
                    IAODCOUNT, BAODCOUNT, IOODCOUNT, BOODCOUNT,
                    (IODCOUNT + BODCOUNT) ODSUM, (IFODCOUNT + BFODCOUNT) FODSUM,
                    (ITODCOUNT + BTODCOUNT) TODSUM, (IAODCOUNT + BAODCOUNT) AODSUM,
                    (IOODCOUNT + BOODCOUNT) OODSUM
                FROM (
                    SELECT TXDATE, BRID, SUM(IODCOUNT) IODCOUNT, SUM(BODCOUNT) BODCOUNT, SUM(IFODCOUNT) IFODCOUNT,
                        SUM(BFODCOUNT) BFODCOUNT, SUM(ITODCOUNT) ITODCOUNT, SUM(BTODCOUNT) BTODCOUNT,
                        SUM(IAODCOUNT) IAODCOUNT, SUM(BAODCOUNT) BAODCOUNT, SUM(IOODCOUNT) IOODCOUNT, SUM(BOODCOUNT) BOODCOUNT
                    FROM (
                        SELECT OD.TXDATE, CF.BRID, 1 IODCOUNT, 0 BODCOUNT, 0 IFODCOUNT, 0 BFODCOUNT,
                            0 ITODCOUNT, 0 BTODCOUNT, 0 IAODCOUNT, 0 BAODCOUNT, 0 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMAST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'I'
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 1 BODCOUNT, 0 IFODCOUNT, 0 BFODCOUNT, 0 ITODCOUNT, 0 BTODCOUNT, 0 IAODCOUNT,
                            0 BAODCOUNT, 0 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMAST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'B'
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 0 BODCOUNT, 1 IFODCOUNT, 0 BFODCOUNT, 0 ITODCOUNT, 0 BTODCOUNT, 0 IAODCOUNT,
                            0 BAODCOUNT, 0 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMAST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'I' AND OD.VIA = 'F'
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 0 BODCOUNT, 0 IFODCOUNT, 1 BFODCOUNT, 0 ITODCOUNT, 0 BTODCOUNT, 0 IAODCOUNT,
                            0 BAODCOUNT, 0 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMAST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'B' AND OD.VIA = 'F'                  
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 0 BODCOUNT, 0 IFODCOUNT, 0 BFODCOUNT, 1 ITODCOUNT, 0 BTODCOUNT, 0 IAODCOUNT,
                            0 BAODCOUNT, 0 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMAST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'I' AND OD.VIA = 'T'
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 0 BODCOUNT, 0 IFODCOUNT, 0 BFODCOUNT, 0 ITODCOUNT, 1 BTODCOUNT, 0 IAODCOUNT,
                            0 BAODCOUNT, 0 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMAST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'B' AND OD.VIA = 'T'
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 0 BODCOUNT, 0 IFODCOUNT, 0 BFODCOUNT, 0 ITODCOUNT, 0 BTODCOUNT, 1 IAODCOUNT,
                            0 BAODCOUNT, 0 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMAST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'I' AND OD.VIA = 'A'
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 0 BODCOUNT, 0 IFODCOUNT, 0 BFODCOUNT, 0 ITODCOUNT, 0 BTODCOUNT, 0 IAODCOUNT,
                            1 BAODCOUNT, 0 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMAST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'B' AND OD.VIA = 'A'
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 0 BODCOUNT, 0 IFODCOUNT, 0 BFODCOUNT, 0 ITODCOUNT, 0 BTODCOUNT, 0 IAODCOUNT,
                            0 BAODCOUNT, 1 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMAST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'I' AND OD.VIA = 'O'
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 0 BODCOUNT, 0 IFODCOUNT, 0 BFODCOUNT, 0 ITODCOUNT, 0 BTODCOUNT, 0 IAODCOUNT,
                            0 BAODCOUNT, 0 IOODCOUNT, 1 BOODCOUNT
                        FROM CFMAST CF, ODMAST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'B' AND OD.VIA = 'O')
                    GROUP BY TXDATE, BRID)
                
            UNION ALL
            SELECT TXDATE, BRID, IODCOUNT, BODCOUNT, IFODCOUNT,
                    BFODCOUNT, ITODCOUNT, BTODCOUNT,
                    IAODCOUNT, BAODCOUNT, IOODCOUNT, BOODCOUNT,
                    (IODCOUNT + BODCOUNT) ODSUM, (IFODCOUNT + BFODCOUNT) FODSUM,
                    (ITODCOUNT + BTODCOUNT) TODSUM, (IAODCOUNT + BAODCOUNT) AODSUM,
                    (IOODCOUNT + BOODCOUNT) OODSUM
                FROM (
                    SELECT TXDATE, BRID, SUM(IODCOUNT) IODCOUNT, SUM(BODCOUNT) BODCOUNT, SUM(IFODCOUNT) IFODCOUNT,
                        SUM(BFODCOUNT) BFODCOUNT, SUM(ITODCOUNT) ITODCOUNT, SUM(BTODCOUNT) BTODCOUNT,
                        SUM(IAODCOUNT) IAODCOUNT, SUM(BAODCOUNT) BAODCOUNT, SUM(IOODCOUNT) IOODCOUNT, SUM(BOODCOUNT) BOODCOUNT
                    FROM (
                        SELECT OD.TXDATE, CF.BRID, 1 IODCOUNT, 0 BODCOUNT, 0 IFODCOUNT, 0 BFODCOUNT,
                            0 ITODCOUNT, 0 BTODCOUNT, 0 IAODCOUNT, 0 BAODCOUNT, 0 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMASTHIST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'I'
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 1 BODCOUNT, 0 IFODCOUNT, 0 BFODCOUNT, 0 ITODCOUNT, 0 BTODCOUNT, 0 IAODCOUNT,
                            0 BAODCOUNT, 0 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMASTHIST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'B'
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 0 BODCOUNT, 1 IFODCOUNT, 0 BFODCOUNT, 0 ITODCOUNT, 0 BTODCOUNT, 0 IAODCOUNT,
                            0 BAODCOUNT, 0 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMASTHIST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'I' AND OD.VIA = 'F'
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 0 BODCOUNT, 0 IFODCOUNT, 1 BFODCOUNT, 0 ITODCOUNT, 0 BTODCOUNT, 0 IAODCOUNT,
                            0 BAODCOUNT, 0 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMASTHIST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'B' AND OD.VIA = 'F'                  
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 0 BODCOUNT, 0 IFODCOUNT, 0 BFODCOUNT, 1 ITODCOUNT, 0 BTODCOUNT, 0 IAODCOUNT,
                            0 BAODCOUNT, 0 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMASTHIST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'I' AND OD.VIA = 'T'
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 0 BODCOUNT, 0 IFODCOUNT, 0 BFODCOUNT, 0 ITODCOUNT, 1 BTODCOUNT, 0 IAODCOUNT,
                            0 BAODCOUNT, 0 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMASTHIST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'B' AND OD.VIA = 'T'
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 0 BODCOUNT, 0 IFODCOUNT, 0 BFODCOUNT, 0 ITODCOUNT, 0 BTODCOUNT, 1 IAODCOUNT,
                            0 BAODCOUNT, 0 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMASTHIST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'I' AND OD.VIA = 'A'
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 0 BODCOUNT, 0 IFODCOUNT, 0 BFODCOUNT, 0 ITODCOUNT, 0 BTODCOUNT, 0 IAODCOUNT,
                            1 BAODCOUNT, 0 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMASTHIST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'B' AND OD.VIA = 'A'
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 0 BODCOUNT, 0 IFODCOUNT, 0 BFODCOUNT, 0 ITODCOUNT, 0 BTODCOUNT, 0 IAODCOUNT,
                            0 BAODCOUNT, 1 IOODCOUNT, 0 BOODCOUNT
                        FROM CFMAST CF, ODMASTHIST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'I' AND OD.VIA = 'O'
                        UNION ALL
                        SELECT OD.TXDATE, CF.BRID, 0 IODCOUNT, 0 BODCOUNT, 0 IFODCOUNT, 0 BFODCOUNT, 0 ITODCOUNT, 0 BTODCOUNT, 0 IAODCOUNT,
                            0 BAODCOUNT, 0 IOODCOUNT, 1 BOODCOUNT
                        FROM CFMAST CF, ODMASTHIST OD
                        WHERE CF.CUSTID = OD.CUSTID AND CF.CUSTTYPE = 'B' AND OD.VIA = 'O')
                    GROUP BY TXDATE, BRID)                  
          ) v
          WHERE v.txdate >= TO_DATE(f_date, 'DD/MM/YYYY')
                AND v.txdate <= TO_DATE(t_date, 'DD/MM/YYYY')
          ORDER BY TXDATE;

   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- Procedure
/

