--
--
/
DELETE SYSVAR WHERE VARNAME = 'ONLINEENDORDERTIME';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','ONLINEENDORDERTIME','185959','Thoi gian ket thuc giao dich dat lenh tren online','Thoi gian ket thuc giao dich dat lenh tren online','N');
COMMIT;
/
