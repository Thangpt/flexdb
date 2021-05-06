CREATE OR REPLACE PROCEDURE pr_t_fo_ownpoolroom
IS
BEGIN
DELETE FROM t_fo_ownpoolroom;
INSERT INTO t_fo_ownpoolroom (prid,
                              acctno,
                              policytype,
                              refsymbol,
                              inused,
                              lastchange)
SELECT  prid,
        acctno,
        policytype,
        refsymbol,
        inused,
        SYSTIMESTAMP lastchange
      FROM v_fo_OWNPOOLROOM;
EXCEPTION WHEN OTHERS THEN
    NULL;
END;
/

