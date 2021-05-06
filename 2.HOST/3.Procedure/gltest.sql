CREATE OR REPLACE PROCEDURE GLTEST (
   pv_refcursor   IN OUT   pkg_report.ref_cursor,
   f_date         IN       VARCHAR2,
   t_date         IN       VARCHAR2
  
  

)
IS
--
-- Purpose: Briefly explain the functionality of the procedure
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- MinhTK   21-Nov-06  Created
-- ---------   ------  -------------------------------------------
   v_stroption        VARCHAR2 (5);       -- A: All; B: Branch; S: Sub-branch
  

-- Declare program variables as shown above
BEGIN
 
OPEN pv_refcursor
       FOR
          SELECT   * FROM GLHIST;
         
               

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

