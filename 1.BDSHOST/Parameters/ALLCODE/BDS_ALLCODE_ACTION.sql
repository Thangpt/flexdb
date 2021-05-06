--
--
/
DELETE allcode WHERE cdname = 'ACTION' AND cdtype = 'CI';
insert into allcode (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('CI', 'ACTION', 'A', 'Duyệt', 1, 'Y', 'Duyệt');
INSERT into allcode (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('CI', 'ACTION', 'R', 'Từ chối', 2, 'Y', 'Rejected');
COMMIT;
/
