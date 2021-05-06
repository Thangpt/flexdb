CREATE OR REPLACE PROCEDURE pr_t_fo_customer
IS
BEGIN
    DELETE FROM t_fo_customer;

    INSERT INTO t_fo_customer (custid, custodycd, fullname, dof, lastchange)
    SELECT custid, custodycd, fullname, dof, SYSTIMESTAMP lastchange
      FROM v_fo_customer;


EXCEPTION WHEN OTHERS THEN
    NULL;
END;
/

