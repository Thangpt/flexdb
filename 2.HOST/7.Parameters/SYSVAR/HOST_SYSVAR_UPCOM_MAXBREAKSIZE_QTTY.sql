--
--
/
DELETE SYSVAR WHERE VARNAME = 'UPCOM_MAXBREAKSIZE_QTTY';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','UPCOM_MAXBREAKSIZE_QTTY','19990','Khối lượng tách lệnh tối đa','UPCOM: Maximum quantiy break size','N');
COMMIT;
/
