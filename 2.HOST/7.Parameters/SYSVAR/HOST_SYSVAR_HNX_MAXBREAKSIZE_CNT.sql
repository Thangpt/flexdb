--
--
/
DELETE SYSVAR WHERE VARNAME = 'HNX_MAXBREAKSIZE_CNT';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','HNX_MAXBREAKSIZE_CNT','1500','Sá»‘ lá»‡nh tÃ¡ch tá»‘i Ä‘a','HSX: Maximum order break size','N');
COMMIT;
/
