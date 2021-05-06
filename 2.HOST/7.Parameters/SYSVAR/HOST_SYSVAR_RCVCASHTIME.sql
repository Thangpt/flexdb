--
--
/
DELETE SYSVAR WHERE VARNAME = 'RCVCASHTIME';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('OD','RCVCASHTIME','DN','Thời điểm xử lý nhận tiền mua về (DN/CN)','The time of processing received bought cash (DN/CN)','N');
COMMIT;
/
