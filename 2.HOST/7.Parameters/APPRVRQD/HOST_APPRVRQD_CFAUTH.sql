--
--
/
DELETE APPRVRQD WHERE OBJNAME = 'CFAUTH';
INSERT INTO APPRVRQD (OBJNAME,RQDSTRING,MAKERID,MAKERDT,APPRVID,APPRVDT,MODNUM)
VALUES ('CFAUTH','ALL',null,null,null,null,'1');
COMMIT;
/
