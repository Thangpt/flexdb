--
--
/
DELETE SYSVAR WHERE VARNAME = 'MAX_BACKDATE_DAYS';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','MAX_BACKDATE_DAYS','90','Max number of day for back date transaction','Max number of day for back date transaction','N');
COMMIT;
/
