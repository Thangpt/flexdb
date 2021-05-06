DELETE SYSVAR WHERE VARNAME='TDATE_AFCHALLENGE';
insert into SYSVAR (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW)
values ('SA', 'TDATE_AFCHALLENGE', '31/08/2020', 'Ngày kết thúc cuộc thi KB Challenge', 'Ngày kết thúc cuộc thi KB Challenge', 'Y');
COMMIT;

