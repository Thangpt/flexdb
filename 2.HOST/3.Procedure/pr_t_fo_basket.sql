CREATE OR REPLACE PROCEDURE pr_t_fo_basket
IS
BEGIN
    DELETE FROM t_fo_basket;

    INSERT INTO t_fo_basket (basketid, symbol, price_margin, price_asset, rate_buy, rate_margin, rate_asset, txdate, lastchange)
    SELECT basketid, symbol, price_margin, price_asset, rate_buy, rate_margin, rate_asset, txdate, SYSTIMESTAMP lastchange
      FROM v_fo_basket;


EXCEPTION WHEN OTHERS THEN
    NULL;
END;
/

