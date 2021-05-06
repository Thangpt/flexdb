--
--
/
DELETE ALLCODE WHERE CDNAME = 'TRANSFERTYPE';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('OA','TRANSFERTYPE','internal','Chuyển khoản nội bộ',1,'Y','Interal');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('OA','TRANSFERTYPE','external','Chuyển khoản ra ngân hàng',2,'Y','External');
insert into allcode (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('OA', 'TRANSFERTYPE', 'depoacc2transfer', 'Chuyển tiền sang tài khoản khác', 3, 'Y', 'Tranfer other Acct');
COMMIT;
/
