--
--
/
DELETE SYSVAR WHERE VARNAME = 'RCVSECTIME';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('OD','RCVSECTIME','CN','Thời điểm xử lý nhận CK mua về (DN/CN)','The time of processing received bought securities (DN/CN)','N');
COMMIT;
/
