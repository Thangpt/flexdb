--
--
/
DELETE SYSVAR WHERE VARNAME = 'MAILHEADER';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','MAILHEADER','MAILHEADER','KÃ­nh gá»­i khÃ¡ch hÃ ng <FULLNAME>, ','KÃ­nh gá»­i khÃ¡ch hÃ ng <FULLNAME>, ','N');
COMMIT;
/
