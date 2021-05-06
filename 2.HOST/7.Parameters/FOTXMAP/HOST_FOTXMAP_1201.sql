--
--
/
DELETE FOTXMAP WHERE TLTXCD = '1201';
insert into fotxmap (TLTXCD, TXCODE, ACCTNO, AMOUNT, EXTRA, QTTY, CODEID, DOC, SYMBOL, ACTION, RUNMOD, TXTYPE)
values ('1201', 'tx5001', '03', '16', null, null, null, 'D', null, 'A', 'NET', null);
COMMIT;
/
