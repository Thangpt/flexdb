--
--
/
DELETE APPMODULES WHERE MODCODE = 'CI';
INSERT INTO APPMODULES (TXCODE,MODCODE,MODNAME,CLASSNAME)
VALUES ('11','CI','Quản lý tiền đầu tư','CI');
INSERT INTO APPMODULES (TXCODE,MODCODE,MODNAME,CLASSNAME)
VALUES ('12','CI','Quản lý tiền đầu tư','CI');
COMMIT;
/
