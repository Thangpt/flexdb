CREATE OR REPLACE PROCEDURE prc_ol_recreatejob IS

 CURSOR c_job

          IS

              SELECT job, what, INTERVAL

              FROM user_jobs;

          v_job     c_job%ROWTYPE;

          v_jobid   NUMBER;

       BEGIN

        update ordersys set sysvalue='N' where sysname in('ISPROCESSOL','PROCESSINGOL','ISSENDFO2BO','SENDINGFO2BO');

        commit;  

        FOR v_job IN c_job

          LOOP

             DBMS_JOB.remove (v_job.job);

             DBMS_JOB.submit (v_jobid, v_job.what, SYSDATE, v_job.INTERVAL);

          END LOOP;

          COMMIT;

           update ordersys set sysvalue='Y' where sysname in('ISPROCESSOL','ISSENDFO2BO');

         commit;

       EXCEPTION

          WHEN OTHERS

          THEN

             ROLLBACK;

       END;
/

