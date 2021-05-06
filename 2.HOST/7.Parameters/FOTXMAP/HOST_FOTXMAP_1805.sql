--
--
/
DELETE FOTXMAP WHERE TLTXCD = '1805';
insert into fotxmap (TLTXCD, TXCODE, ACCTNO, AMOUNT, EXTRA, QTTY, CODEID, DOC, SYMBOL, ACTION, RUNMOD, TXTYPE)
values ('1805', 'tx5020', '03', '08', null, null, null, 'D', null, 'A', 'NET', '47');
COMMIT;
/
