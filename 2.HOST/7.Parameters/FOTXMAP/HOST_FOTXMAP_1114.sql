--
--
/
DELETE FOTXMAP WHERE TLTXCD = '1114';
insert into fotxmap (TLTXCD, TXCODE, ACCTNO, AMOUNT, EXTRA, QTTY, CODEID, DOC, SYMBOL, ACTION, RUNMOD, TXTYPE)
values ('1114', 'tx5001', '03', null, '11', null, null, 'C', null, 'P', 'NET', null);
insert into fotxmap (TLTXCD, TXCODE, ACCTNO, AMOUNT, EXTRA, QTTY, CODEID, DOC, SYMBOL, ACTION, RUNMOD, TXTYPE)
values ('1114', 'tx5001', '03', '10', null, null, null, 'C', null, 'A', 'NET', null);
COMMIT;
/
