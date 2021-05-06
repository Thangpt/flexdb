--
--
/
DELETE SYSVAR WHERE VARNAME = 'ONLINEMAXTRF1133_CNT';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','ONLINEMAXTRF1133_CNT','5','So lan chuyen khoan bang chung minh thu toi da trong ngay','So lan chuyen khoan bang chung minh thu toi da trong ngay','Y');
COMMIT;
/
