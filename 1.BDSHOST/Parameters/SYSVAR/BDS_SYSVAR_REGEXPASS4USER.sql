delete from  SYSVAR WHERE VARNAME = 'REGEXPASS4USER' AND GRNAME ='SYSTEM';
insert into SYSVAR (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW)
values ('SYSTEM', 'REGEXPASS4USER', '8##[a-z]##[A-Z]##[0-9]##[!@#$%^&*+=]##', 'Chuỗi check PIN của USER', 'Check PIN for User', 'N');
commit;
