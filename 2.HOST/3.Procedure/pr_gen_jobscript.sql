CREATE OR REPLACE PROCEDURE pr_gen_jobscript
   ( p_jobname IN varchar2
    )
   IS
--
-- To modify this template, edit file PROC.TXT in TEMPLATE
-- directory of SQL Navigator
--
-- Purpose: Briefly explain the functionality of the procedure
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- TheNN       22-Feb-2012  Created
-- ---------   ------  -------------------------------------------
   v_job_type   varchar2(2000);
   v_job_action   varchar2(2000);
   v_start_date   varchar2(2000);
   v_end_date   varchar2(2000);
   v_repeat_interval   varchar2(2000);
   v_enabled   varchar2(2000);
   v_comments   varchar2(2000);
   v_jobtext     clob;
   v_job_name   varchar2(2000);

   -- Declare program variables as shown above
BEGIN
    -- GET JOB' INFORMATIONS
    IF p_jobname IS NOT NULL THEN
        SELECT J.job_type, j.job_action, j.start_date, j.end_date, j.repeat_interval, j.enabled, j.comments
        INTO v_job_type, v_job_action, v_start_date, v_end_date, v_repeat_interval, v_enabled, v_comments
        FROM user_scheduler_jobs J
        WHERE J.job_name = p_jobname;
        -- DROP JOB
        v_jobtext :=
        'BEGIN
              DBMS_SCHEDULER.DROP_JOB (
                 job_name         =>  ' || '''' || p_jobname || '''' || ');
          END;
          /
          ';
        -- CREATE JOB
        v_jobtext :=
        v_jobtext ||
        'BEGIN
          DBMS_SCHEDULER.CREATE_JOB (
             job_name         =>  ' || '''' || p_jobname || '''' || ',
             job_type           =>  ' || '''' || v_job_type || '''' || ',
             job_action       =>  ' || '''' || v_job_action || '''' || ',
             start_date       =>  sysdate,
             repeat_interval  =>  ' || '''' || v_repeat_interval || '''' || ',
             enabled           => ' || v_enabled || ',
             comments         => ' || '''' || v_comments || '''' || ');
          END;
          /
          ';
        -- INSERT TO TABLE TEMP
        INSERT INTO TBLTEMP_GEN_JOB (DATETIME,ID_NAME,DATA)
        VALUES (SYSDATE, p_jobname, v_jobtext);
        COMMIT;

    ELSE
        -- GET ALL JOB AND GEN SCRIPT
        -- ONE JOB IN ONE ROW
        FOR REC IN
            (
                SELECT j.job_name, J.job_type, j.job_action, j.start_date, j.end_date, j.repeat_interval, j.enabled, j.comments
                FROM user_scheduler_jobs J
            )
            LOOP
                -- DROP JOB
                v_jobtext :=
                'BEGIN
                      DBMS_SCHEDULER.DROP_JOB (
                         job_name         =>  ' || '''' || rec.job_name || '''' || ');
                  END;
                  /
                  ';
                -- CREATE JOB
                v_jobtext :=
                v_jobtext ||
                'BEGIN
                  DBMS_SCHEDULER.CREATE_JOB (
                     job_name         =>  ' || '''' || rec.job_name || '''' || ',
                     job_type           =>  ' || '''' || rec.job_type || '''' || ',
                     job_action       =>  ' || '''' || rec.job_action || '''' || ',
                     start_date       =>  sysdate,
                     repeat_interval  =>  ' || '''' || rec.repeat_interval || '''' || ',
                     enabled           => ' || rec.enabled || ',
                     comments         => ' || '''' || rec.comments || '''' || ');
                  END;
                  /
                  ';
                -- INSERT TO TABLE TEMP
                INSERT INTO TBLTEMP_GEN_JOB (DATETIME,ID_NAME,DATA)
                VALUES (SYSDATE, rec.job_name, v_jobtext);
                COMMIT;
            END LOOP;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RETURN ;
END; -- Procedure
/

