--
--
/
DELETE APPRVRQD WHERE OBJNAME = 'FNMAST';
INSERT INTO APPRVRQD (OBJNAME,RQDSTRING,MAKERID,MAKERDT,APPRVID,APPRVDT,MODNUM)
VALUES ('FNMAST','ALL',null,null,null,null,'1');
COMMIT;
/
