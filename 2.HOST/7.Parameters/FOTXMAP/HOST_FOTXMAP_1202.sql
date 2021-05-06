--
--
/
DELETE FOTXMAP WHERE TLTXCD = '1202';
insert into fotxmap (TLTXCD, TXCODE, ACCTNO, AMOUNT, EXTRA, QTTY, CODEID, DOC, SYMBOL, ACTION, RUNMOD, TXTYPE)
values ('1202', 'tx5001', '03', '10++11', null, null, null, 'C', null, 'A', 'NET', null);
INSERT into fotxmap (TLTXCD, TXCODE, ACCTNO, AMOUNT, EXTRA, QTTY, CODEID, DOC, SYMBOL, ACTION, RUNMOD, TXTYPE)
values ('1202', 'tx5001', '05', '12', null, null, null, 'D', null, 'A', 'NET', null);
COMMIT;
/
