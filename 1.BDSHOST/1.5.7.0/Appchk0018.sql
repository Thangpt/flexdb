delete from Appchk where TLTXCD='0018';
insert into Appchk (TLTXCD, APPTYPE, ACFLD, RULECD, AMTEXP, FLDKEY, DELTDCHK, ISRUN, CHKLEV)
values ('0018', 'CF', '05', '33', '@NC', 'ACCTNO', 'N', '@1', 0);
commit;

