CREATE OR REPLACE PROCEDURE pr_t_fo_portfolios
IS
i number(20);
BEGIN
    i:=0;
    DELETE FROM t_fo_portfolios;

    FOR j IN  (SELECT * FROM V_FO_PORTFOLIOS)
    LOOP
       INSERT INTO t_fo_portfolios (acctno, symbol, trade, mortage, receiving, avgprice, rt0, rt1, rt2, rt3,
                                 rtn, st0, st1, st2, st3, stn, buyingqtty, sellingqtty, buyingqttymort,
                                 sellingqttymort, assetqtty, lastchange, marked, markedcom, pitqtty, taxrate)
            VALUES (j.acctno, j.symbol, j.trade, j.mortage, j.receiving, j.avgprice, j.rt0, j.rt1, j.rt2, j.rt3,
                                     j.rtn, j.st0, j.st1, j.st2, j.st3, j.stn, j.buyingqtty, j.sellingqtty, j.buyingqttymort,
                                     j.sellingqttymort, j.assetqtty, SYSTIMESTAMP, j.marked,j.markedcom, j.pitqtty, j.taxrate);
       i:=i+1;
       IF i > 1000 THEN
         i:=0;
         COMMIT;
       END IF;


    END LOOP;
    COMMIT;

EXCEPTION WHEN OTHERS THEN
    NULL;
END;
/
