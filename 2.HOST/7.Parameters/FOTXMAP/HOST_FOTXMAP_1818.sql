--
--
/
DELETE FOTXMAP WHERE TLTXCD = '1818';
insert into fotxmap (TLTXCD, TXCODE, ACCTNO, AMOUNT, EXTRA, QTTY, CODEID, DOC, SYMBOL, ACTION, RUNMOD, TXTYPE)
values ('1818', 'tx5020', '03', '10', null, null, null, 'C', null, 'A', 'NET', '47');
COMMIT;
/
