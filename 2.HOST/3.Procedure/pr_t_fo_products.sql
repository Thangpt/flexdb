CREATE OR REPLACE PROCEDURE pr_t_fo_products
IS
BEGIN
    DELETE FROM t_fo_products;

    INSERT INTO t_fo_products (actype, acname, lastchange)
    SELECT actype, acname, SYSTIMESTAMP lastchange
      FROM v_fo_products;


EXCEPTION WHEN OTHERS THEN
    NULL;
END;
/

