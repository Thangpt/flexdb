CREATE OR REPLACE PROCEDURE p_it_job_10h30_onetime
   IS
BEGIN
    UPDATE sbsecurities SET halt='N' WHERE symbol in ('TRI','DVD');
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
END; -- Procedure
/

