--
--
/
DELETE FOTXMAP WHERE TLTXCD = '2244' AND TXCODE='tx5016';
INSERT INTO FOTXMAP (TLTXCD, TXCODE, ACCTNO, AMOUNT, EXTRA, QTTY, CODEID, DOC, SYMBOL, ACTION, RUNMOD, TXTYPE)
VALUES ('2244', 'tx5016', '02', null, null, '15', '01', 'D', null, 'A', 'NET', null);
COMMIT;
/
