--
--
/
DELETE FOTXFORMAT WHERE TXCODE = 'tx5016';
INSERT INTO FOTXFORMAT (TXCODE, MSGFORMAT, STATUS)
VALUES ('tx5016', '{"msgtype" : "<$MSGTYPE>","acctno" : "<$ACCTNO>" , "symbol" : "<$SYMBOL>", "qtty" : <$QTTY>, "rate_tax" : <$TAXRATE>, "doc" : "<$COD>"}', 'Y');
COMMIT;
/
