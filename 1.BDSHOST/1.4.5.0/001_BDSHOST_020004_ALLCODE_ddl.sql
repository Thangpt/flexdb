delete FROM ALLCODE WHERE CDTYPE = 'SA' AND CDNAME in ('SECTYPE') AND cdval = '011';

insert into ALLCODE (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('SA', 'SECTYPE', '011', 'Chứng quyền', 10, 'Y', 'Covered Warrant');

COMMIT;

delete FROM ALLCODE WHERE CDTYPE = 'SA' AND CDNAME in ('SETTLEMENTTYPE','UNDERLYINGTYPE','CWTYPE');

insert into ALLCODE (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('SA', 'UNDERLYINGTYPE', 'I', 'Chỉ số', 1, 'Y', 'Index');

insert into ALLCODE (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('SA', 'UNDERLYINGTYPE', 'S', 'Cổ phiếu', 0, 'Y', 'Securities');

insert into ALLCODE (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('SA', 'UNDERLYINGTYPE', 'E', 'Chứng chỉ quỹ', 2, 'Y', 'Exchange Traded Fund (ETF)');

insert into ALLCODE (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('SA', 'CWTYPE', 'P', 'Chứng quyền bán', 2, 'Y', 'CW sell');

insert into ALLCODE (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('SA', 'CWTYPE', 'C', 'Chứng quyền mua', 1, 'Y', 'CW buy');

insert into ALLCODE (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('SA', 'SETTLEMENTTYPE', 'CWMS', 'Thanh toán bằng tiền', 1, 'Y', 'Paid Money');

insert into ALLCODE (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('SA', 'SETTLEMENTTYPE', 'CWTS', 'Chuyển giao chứng khoán', 2, 'Y', 'Transfer securities');

commit;
