--
--
/
DELETE FOTXMAP WHERE TLTXCD = '1810';
insert into fotxmap (TLTXCD, TXCODE, ACCTNO, AMOUNT, EXTRA, QTTY, CODEID, DOC, SYMBOL, ACTION, RUNMOD, TXTYPE)
values ('1810', 'tx5020', '03', '10', null, null, null, 'C', null, 'A', 'NET', '47');
COMMIT;
/
