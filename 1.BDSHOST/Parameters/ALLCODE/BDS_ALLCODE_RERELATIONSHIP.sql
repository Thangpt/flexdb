delete allcode where cdtype = 'CF' and cdname  = 'RERELATIONSHIP';
insert into allcode (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('CF', 'RERELATIONSHIP', '001', 'Mới quen', 0, 'Y', 'Mới quen');

insert into allcode (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('CF', 'RERELATIONSHIP', '002', 'Quan hệ họ hàng', 1, 'Y', 'Quan hệ họ hàng');

insert into allcode (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('CF', 'RERELATIONSHIP', '003', 'Không quen biết', 2, 'Y', 'Không quen biết');

insert into allcode (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('CF', 'RERELATIONSHIP', '004', 'Giới thiệu', 3, 'Y', 'Giới thiệu');

insert into allcode (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('CF', 'RERELATIONSHIP', '005', 'Hình thức khác', 4, 'Y', 'Hình thức khác');

insert into allcode (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('CF', 'RERELATIONSHIP', '000', null, 5, 'N', null);

commit;
