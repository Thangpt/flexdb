--
--
/
DELETE SYSVAR WHERE VARNAME = 'IRATIO';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('MARGIN','IRATIO','50','Tỷ lệ kí quỹ ban đầu tối thiểu UBCK (100% - tỉ lệ cho vay an toàn tối đa).','Initial Ratio','Y');
COMMIT;
/
