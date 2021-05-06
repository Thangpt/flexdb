delete from allcode where cdname = 'SECTYPE' and cdval = '012' and cdtype = 'SA';
insert into allcode (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('SA', 'SECTYPE', '012', 'Trái phiếu doanh nghiệp ', 11, 'Y', 'Trai phieu doanh nghiep');
commit;
