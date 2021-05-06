CREATE OR REPLACE PROCEDURE pr_t_fo_instruments
IS
BEGIN
    DELETE FROM t_fo_instruments;

    INSERT INTO t_fo_instruments (symbol, fullname, cficode, exchange, board, price_ce, price_fl,
                price_rf, qttysum, fqtty, halt, lastchange,SYMBOLNUM, price_nav, qtty_avrtrade,parvalue)
    SELECT symbol, fullname, cficode, exchange, board, price_ce, price_fl,
                price_rf,  qttysum, fqtty, halt, SYSTIMESTAMP lastchange,SYMBOLNUM,price_nav, qtty_avrtrade,parvalue
      FROM v_fo_instruments;


EXCEPTION WHEN OTHERS THEN
    NULL;
END;
/
