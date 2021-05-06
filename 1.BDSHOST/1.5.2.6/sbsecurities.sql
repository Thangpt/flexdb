ALTER TABLE sbsecurities ADD IS_ETF VARCHAR2(10) DEFAULT 'N';

UPDATE sbsecurities SET IS_ETF = 'Y' WHERE symbol IN ('','');
COMMIT;
