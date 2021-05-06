delete from allcode  where CDNAME='PRODUCCODE';
insert into allcode (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('LN', 'PRODUCCODE', 'T10', 'Không dùng ứng trước trả nợ trong hạn', 0, 'Y', 'Do not use adv to pay loan');
commit;
