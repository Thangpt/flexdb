--
--
/
DELETE SYSVAR WHERE VARNAME = 'MAXDEBTQTTYRATE';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('MARGIN','MAXDEBTQTTYRATE','5','Tỷ lệ so với số lượng  lưu hành của từng mã để xác định khối lượng tài sản  (%)','Max debt quantity rate','Y');
COMMIT;
/
