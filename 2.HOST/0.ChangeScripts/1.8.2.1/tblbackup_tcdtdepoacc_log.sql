
DELETE tblbackup WHERE FRTABLE='TCDT2DEPOACC_LOG';
insert into tblbackup (FRTABLE, TOTABLE, TYPBK)
values ('TCDT2DEPOACC_LOG', 'TCDT2DEPOACC_LOG_HIST', 'N');
COMMIT;
