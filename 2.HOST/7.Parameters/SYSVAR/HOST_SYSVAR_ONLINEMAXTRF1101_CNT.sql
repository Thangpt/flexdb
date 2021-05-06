--
--
/
DELETE SYSVAR WHERE VARNAME = 'ONLINEMAXTRF1101_CNT';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','ONLINEMAXTRF1101_CNT','5','So lan chuyen khoan ra ngan hang toi da trong ngay','So lan chuyen khoan ra ngan hang toi da trong ngay','Y');
COMMIT;
/
