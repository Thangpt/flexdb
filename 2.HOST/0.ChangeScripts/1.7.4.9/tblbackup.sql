DELETE FROM tblbackup WHERE FRTABLE = 'FIX_MESSAGE_TEMP'
insert into tblbackup (FRTABLE, TOTABLE, TYPBK)
values ('FIX_MESSAGE_TEMP', 'FIX_MESSAGE_TEMP_HIST', 'N');
COMMIT; 