--
--
/
DELETE SYSVAR WHERE VARNAME = 'BVSCBANK';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('DEFINED','BVSCBANK','NGÂN HÀNG BẢO VIỆT','NGÂN HÀNG BVSC MỞ TK',null,'N');
COMMIT;
/
