CREATE OR REPLACE PROCEDURE pr_t_fo_workingcalendar
IS
BEGIN
    DELETE FROM t_fo_WORKINGCALENDAR;

    /* Formatted on 18-Aug-2015 09:44:32 (QP5 v5.160) */
INSERT INTO t_fo_workingcalendar (todaydate,
                                  t1date,
                                  t2date,
                                  t3date,
                                  lastchange)
SELECT  todaydate,
        t1date,
        t2date,
        t3date,
        SYSTIMESTAMP lastchange
      FROM v_fo_WORKINGCALENDAR;


EXCEPTION WHEN OTHERS THEN
    NULL;
END;
/

