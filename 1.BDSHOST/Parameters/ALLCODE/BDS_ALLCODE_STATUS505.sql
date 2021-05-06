--
--
/
DELETE ALLCODE WHERE CDNAME = 'STATUS505';
insert into allcode (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('LN', 'STATUS505', 'A', 'Hoạt động', 0, 'Y', 'Hoạt động');

insert into allcode (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('LN', 'STATUS505', 'C', 'Đóng', 1, 'Y', 'Đóng');
COMMIT;
/
