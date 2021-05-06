--
--
/
DELETE SYSVAR WHERE VARNAME = 'SYROLLLIMIT';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('MARGIN','SYROLLLIMIT','70','Tỉ lệ tối đa dùng trong đảo tài sản (Credit Line) tầng hệ thống','Limit to roll over col','Y');
COMMIT;
/
