
DELETE FROM Ordersys_Ha WHERE sysname ='GWUSERNAME'; 

insert into Ordersys_Ha (SYSNAME, SYSVALUE, SYSDESC)
values ('GWUSERNAME', '002', 'User dang nhap GDTT');

DELETE FROM Ordersys_Ha WHERE sysname ='GWPASSWORD'; 

insert into Ordersys_Ha (SYSNAME, SYSVALUE, SYSDESC)
values ('GWPASSWORD', '123456', 'Pass dang nhap GDTT');

Delete from ordersys_ha where SYSNAME='NOTIFYSMS';

INSERT INTO ordersys_ha (SYSNAME,SYSVALUE,SYSDESC) 
VALUES('NOTIFYSMS','0988xxxxxx','Tele nhan gui yeu cau doi pass');

COMMIT; 