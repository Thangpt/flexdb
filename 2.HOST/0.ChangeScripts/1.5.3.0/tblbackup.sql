DELETE tblbackup WHERE FRTABLE IN ('IPLOG','Logplaceorder');

insert into tblbackup (FRTABLE, TOTABLE, TYPBK)
values ('IPLOG', 'IPLOGHIST', 'N');

insert into tblbackup (FRTABLE, TOTABLE, TYPBK)
values ('Logplaceorder', 'Logplaceorderhist', 'N');

COMMIT;
