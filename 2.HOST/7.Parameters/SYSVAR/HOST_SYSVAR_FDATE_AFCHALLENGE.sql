DELETE SYSVAR WHERE VARNAME='FDATE_AFCHALLENGE';
insert into SYSVAR (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW)
values ('SA', 'FDATE_AFCHALLENGE', '02/03/2020', 'Ngày bắt đầu cuộc thi KB Challenge', 'Ngày bắt đầu cuộc thi KB Challenge', 'Y');
COMMIT;

