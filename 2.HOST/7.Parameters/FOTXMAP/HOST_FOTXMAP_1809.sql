--
--
/
DELETE FOTXMAP WHERE TLTXCD = '1809';
insert into fotxmap (TLTXCD, TXCODE, ACCTNO, AMOUNT, EXTRA, QTTY, CODEID, DOC, SYMBOL, ACTION, RUNMOD, TXTYPE)
values ('1809', 'tx5126', '88', '13', null, null, null, 'U', null, 'A', 'DB', NULL);
COMMIT;
/
