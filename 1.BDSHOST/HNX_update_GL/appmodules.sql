DELETE FROM appmodules WHERE modcode ='SY'; 

insert into appmodules (TXCODE, MODCODE, MODNAME, CLASSNAME)
values ('70', 'SY', 'Quản trị hê thống GW', 'SY');

COMMIT; 
