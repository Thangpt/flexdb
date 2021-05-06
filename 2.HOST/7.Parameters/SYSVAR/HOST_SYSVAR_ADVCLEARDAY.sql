--
--
/
DELETE SYSVAR WHERE VARNAME = 'ADVCLEARDAY';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('OD','ADVCLEARDAY','2','Số ngày thanh toán bù trừ của ngày hiện tại','Số ngày thanh toán bù trừ của ngày hiện tại','N');
COMMIT;
/
