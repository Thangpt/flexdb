CREATE OR REPLACE PROCEDURE p_it_job_10h15_onetime
   IS
BEGIN
    UPDATE sbsecurities SET halt='N' WHERE symbol='TRI';
    rollback;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
END; -- Procedure
/

