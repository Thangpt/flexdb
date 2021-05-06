CREATE TABLE TCDTCASHLIMIT 
(
BANK_NAME                 VARCHAR2(200),
CASH_FROM                 NUMBER,
CASH_TO                   NUMBER,
STATUS                    VARCHAR2(10) DEFAULT 'Y'
);

delete from tcdtcashlimit;
insert into tcdtcashlimit (BANK_NAME, CASH_FROM, CASH_TO, STATUS)
values ('VPBANK', 0, 300000000, 'Y');

insert into tcdtcashlimit (BANK_NAME, CASH_FROM, CASH_TO, STATUS)
values ('MSB', 300000001, 499999999, 'Y');

insert into tcdtcashlimit (BANK_NAME, CASH_FROM, CASH_TO, STATUS)
values ('BIDV', 500000000, 2000000000, 'Y');

insert into tcdtcashlimit (BANK_NAME, CASH_FROM, CASH_TO, STATUS)
values ('VPBANK', 2000000001, 9999999999, 'Y');

commit;
