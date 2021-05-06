--
--
/
DELETE FOTXMAP WHERE TLTXCD = '1204';
insert into fotxmap (TLTXCD, TXCODE, ACCTNO, AMOUNT, EXTRA, QTTY, CODEID, DOC, SYMBOL, ACTION, RUNMOD, TXTYPE)
values ('1204', 'tx5001', '05', '10', null, null, null, 'C', null, 'A', 'NET', null);
COMMIT;
/
