--
--
/
DELETE SYSVAR WHERE VARNAME = 'UPDPRICEPLO';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','UPDPRICEPLO','N','Cho phép cập nhật giá với những lệnh PLO trước phiên','Cho phép cập nhật giá với những lệnh PLO trước phiên','N');
COMMIT;
/
