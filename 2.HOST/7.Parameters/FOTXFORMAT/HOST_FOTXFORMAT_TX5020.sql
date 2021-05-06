--
--
/
DELETE FOTXFORMAT WHERE TXCODE = 'tx5020';
INSERT INTO FOTXFORMAT (TXCODE, MSGFORMAT, STATUS)
VALUES ('tx5020', '{"msgtype" : "<$MSGTYPE>", "acctno" : "<$ACCTNO>", "amount" : <$AMOUNT>, "doc" : "<$COD>", "deal" : "<$TYPE>" }', 'Y');
COMMIT;
/
