--
--
/
DELETE APPRVRQD WHERE OBJNAME = 'AFPOLICYMST';
INSERT INTO APPRVRQD (OBJNAME,RQDSTRING,MAKERID,MAKERDT,APPRVID,APPRVDT,MODNUM)
VALUES ('AFPOLICYMST','ALL',null,null,null,null,'1');
COMMIT;
/
