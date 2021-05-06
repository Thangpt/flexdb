CREATE OR REPLACE PROCEDURE pr_t_fo_orderbook
IS
BEGIN
    DELETE FROM t_fo_orderbook;

    INSERT INTO t_fo_orderbook (orderid, reforderid, txdate, afacctno, df_se_code, exectype, quoteprice,
                                orderqtty, fullname, feeacr, df_se_floor_code, custodycd, via, txtime,
                                matchqtty, matchprice, execamt, confirm_no, lastchange)
    SELECT orderid, reforderid, txdate, afacctno, df_se_code, exectype, quoteprice,
           orderqtty, fullname, feeacr, df_se_floor_code, custodycd, via, txtime,
           matchqtty, matchprice, execamt, confirm_no, SYSTIMESTAMP lastchange
      FROM v_fo_orderbook;


EXCEPTION WHEN OTHERS THEN
    NULL;
END;
/

