CREATE OR REPLACE PROCEDURE pr_t_fo_fousers
IS
BEGIN
    DELETE FROM t_fo_fousers;
    /*
    INSERT INTO t_fo_fousers (tlid, username, authtype, pwdlogin, pwdtrade, type, lastchange)
    SELECT tlid, username, authtype, pwdlogin, pwdtrade, type, SYSTIMESTAMP lastchange
      FROM v_fo_fousers;
    */

EXCEPTION WHEN OTHERS THEN
    NULL;
END;
/

