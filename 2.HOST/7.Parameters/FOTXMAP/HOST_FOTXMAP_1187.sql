--
--
/
DELETE FOTXMAP WHERE TLTXCD = '1187';
insert into fotxmap (TLTXCD, TXCODE, ACCTNO, AMOUNT, EXTRA, QTTY, CODEID, DOC, SYMBOL, ACTION, RUNMOD, TXTYPE)
values ('1187', 'tx5020', '03', '10', null, null, null, 'U', null, 'A', 'NET', '47');
COMMIT;
/
