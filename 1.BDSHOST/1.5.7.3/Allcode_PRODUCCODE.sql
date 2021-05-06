

delete from allcode  where CDNAME='PRODUCCODE' and cdtype = 'LN';
insert into allcode (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('LN', 'PRODUCCODE', 'MAS10', 'Không dùng ứng trước trả nợ trong hạn', 0, 'Y', 'Do not use adv to pay loan');
commit;
