CREATE OR REPLACE PROCEDURE pr_t_fo_poolroom( pv_policytype IN VARCHAR2 DEFAULT NULL,
                                              pv_policycode IN VARCHAR2 DEFAULT NULL,
                                              pv_refsymbol IN VARCHAR2 DEFAULT NULL)
IS
    l_policytype VARCHAR2(20);
    l_policycode VARCHAR2(20);
    l_refsymbol  VARCHAR2(50);
BEGIN
    IF pv_policytype IS NULL OR pv_policytype = 'ALL' THEN
        l_policytype := '%';
    END IF;
    IF pv_policycode IS NULL OR pv_policytype = 'ALL' THEN
        l_policycode := '%';
    END IF;
    IF pv_refsymbol IS NULL OR pv_policytype = 'ALL' THEN
        l_refsymbol := '%';
    END IF;

    DELETE FROM t_fo_poolroom
          WHERE policytype LIKE l_policytype
                AND policycd LIKE l_policytype
                AND refsymbol LIKE l_refsymbol;

    INSERT INTO t_fo_poolroom (policycd, policytype, refsymbol, granted, inused, lastchange )
    SELECT policycd, policytype, refsymbol, granted, inused, SYSTIMESTAMP lastchange
      FROM v_fo_poolroom
     WHERE policytype LIKE l_policytype
           AND policycd LIKE l_policytype
           AND refsymbol LIKE l_refsymbol;
    COMMIT;
EXCEPTION WHEN OTHERS THEN
    NULL;
END;
/

