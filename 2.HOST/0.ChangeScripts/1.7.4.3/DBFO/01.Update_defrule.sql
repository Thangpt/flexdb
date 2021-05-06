update defrules set REFNVAL = 1 where REFCODE = 'HNX.BOND' and RULENAME = 'MINCROSS';
update defrules set REFNVAL = 1 where REFCODE = 'HNX.BOND' and RULENAME = 'MINCROSS_DB';
commit;
