--
--
/
DELETE SYSVAR WHERE VARNAME = 'HSX_MAXBREAKSIZE_QTTY';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','HSX_MAXBREAKSIZE_QTTY','500000','Khá»‘i lÆ°á»£ng tÃ¡ch lá»‡nh tá»‘i Ä‘a','HSX: Maximum quantiy break size','N');
COMMIT;
/
