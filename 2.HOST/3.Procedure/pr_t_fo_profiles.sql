CREATE OR REPLACE PROCEDURE pr_t_fo_profiles
IS
BEGIN
    DELETE FROM t_fo_profiles;

    INSERT INTO t_fo_profiles (userid, acctno, roletype, authstr, lastchange)
    SELECT userid, acctno, roletype, authstr, SYSTIMESTAMP lastchange
      FROM v_fo_profiles;


EXCEPTION WHEN OTHERS THEN
    NULL;
END;
/

