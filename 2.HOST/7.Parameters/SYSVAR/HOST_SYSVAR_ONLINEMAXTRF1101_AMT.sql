--
--
/
DELETE SYSVAR WHERE VARNAME = 'ONLINEMAXTRF1101_AMT';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','ONLINEMAXTRF1101_AMT','1000000000','So tien chuyen khoan toi da ra ngan hang','So tien chuyen khoan toi da ra ngan hang','Y');
COMMIT;
/
