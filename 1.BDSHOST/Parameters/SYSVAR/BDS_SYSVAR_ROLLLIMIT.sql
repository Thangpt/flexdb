--
--
/
DELETE SYSVAR WHERE VARNAME = 'ROLLLIMIT';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('MARGIN','ROLLLIMIT','50','Tỉ lệ tối đa dùng trong đảo tài sản tầng hệ thống','Limit to roll over col','Y');
COMMIT;
/
