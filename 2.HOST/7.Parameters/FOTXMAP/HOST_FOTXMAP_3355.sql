--
--
/
DELETE FOTXMAP WHERE TLTXCD = '3355' AND TXCODE='tx5016';
INSERT INTO FOTXMAP (TLTXCD, TXCODE, ACCTNO, AMOUNT, EXTRA, QTTY, CODEID, DOC, SYMBOL, ACTION, RUNMOD, TXTYPE)
VALUES ('3355', 'tx5016', '02', null, '16', '15', '01', 'C', null, 'A', 'NET', null);
COMMIT;
/
