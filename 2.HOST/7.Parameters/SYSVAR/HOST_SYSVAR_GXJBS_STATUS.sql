--
--
/
DELETE SYSVAR WHERE VARNAME = 'GXJBS_STATUS';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','GXJBS_STATUS','Y','GXJBS_STATUS=Y run job fo2od','GXJBS_STATUS','N');
COMMIT;
/
