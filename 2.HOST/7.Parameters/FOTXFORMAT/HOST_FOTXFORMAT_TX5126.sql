--
--
/
DELETE FOTXFORMAT WHERE TXCODE = 'tx5126';
INSERT INTO FOTXFORMAT (TXCODE, MSGFORMAT, STATUS)
VALUES ('tx5126', '{"msgtype" : "<$MSGTYPE>", "acctno" : "<$ACCTNO>", "amount" : <$AMOUNT>, "doc" : "<$COD>"}', 'Y');
COMMIT;
/
