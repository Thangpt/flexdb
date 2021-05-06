--
--
/
DELETE SYSVAR WHERE VARNAME = 'RUNFLAG';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('BANKGW','RUNFLAG','Y','Co tam dung khong cho ngan hang ket noi','Co tam dung khong cho ngan hang ket noi','N');
COMMIT;
/
