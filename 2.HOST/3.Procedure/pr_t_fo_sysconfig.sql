CREATE OR REPLACE PROCEDURE pr_t_fo_sysconfig
IS
BEGIN
    DELETE FROM t_fo_sysconfig;

    INSERT INTO t_fo_sysconfig (cfgkey, cfgvalue, descriptions, lastchange)
    SELECT cfgkey, cfgvalue, descriptions, SYSTIMESTAMP lastchange
      FROM v_fo_sysconfig;


EXCEPTION WHEN OTHERS THEN
    NULL;
END;
/

