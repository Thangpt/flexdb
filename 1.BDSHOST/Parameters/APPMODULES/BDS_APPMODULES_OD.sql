--
--
/
DELETE APPMODULES WHERE MODCODE = 'OD';
INSERT INTO APPMODULES (TXCODE,MODCODE,MODNAME,CLASSNAME)
VALUES ('88','OD','Lệnh','OD');
COMMIT;
/
