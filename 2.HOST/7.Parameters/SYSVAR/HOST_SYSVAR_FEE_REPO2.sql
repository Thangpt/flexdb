--
--
/
DELETE SYSVAR WHERE VARNAME = 'FEE_REPO2';
insert into sysvar (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW)
values ('SYSTEM', 'FEE_REPO2', 'N', 'Phí Repo lần 2', 'Phí Repo lần 2', 'N');
commit;
/
