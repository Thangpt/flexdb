CREATE TABLE securities_info_bk_tradelot AS SELECT * FROM securities_info se WHERE EXISTS (SELECT * FROM sbsecurities s WHERE s.codeid = se.codeid AND s.tradeplace = '001' AND s.refcodeid IS NULL) AND tradelot = 10;
UPDATE securities_info se SET tradelot = 100
WHERE EXISTS (SELECT * FROM sbsecurities s WHERE s.codeid = se.codeid AND s.tradeplace = '001' AND s.refcodeid IS NULL) AND tradelot = 10;
COMMIT;
