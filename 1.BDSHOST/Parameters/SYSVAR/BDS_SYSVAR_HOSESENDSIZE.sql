--
--
/
DELETE SYSVAR WHERE VARNAME = 'HOSESENDSIZE';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','HOSESENDSIZE','50','Send to HOSE queue size','Send to HOSE queue size','N');
COMMIT;
/
