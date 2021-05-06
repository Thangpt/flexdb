--
--
/
DELETE SYSVAR WHERE VARNAME = 'ONLINEMINREMAINTRF1133_AMT';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','ONLINEMINREMAINTRF1133_AMT','0','So tien chuyen khoan ra ngan hang bang CMT con lai toi thieu','So tien chuyen khoan ra ngan hang bang CMT con lai toi thieu','N');
COMMIT;
/
