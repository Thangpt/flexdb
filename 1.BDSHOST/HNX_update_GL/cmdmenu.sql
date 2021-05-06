DELETE FROM cmdmenu WHERE cmdid ='112800';

insert into cmdmenu (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
values ('112800', '100000', 2, 'N', 'P', null, null, null, 'Thông tin GDTT', 'OnlineTrade Information', 'YYYYYYYYYYN', null);

COMMIT; 

DELETE FROM cmdmenu WHERE cmdid ='112801';

insert into cmdmenu (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
values ('112801', '112800', 3, 'N', 'T', 'SY0001 ', 'SY', null, 'Giao dịch', 'Transaction', 'YYYYYYYYYYN', null);

COMMIT; 

DELETE FROM cmdmenu WHERE cmdid ='112802';
insert into cmdmenu (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
values ('112802', '112800', 3, 'Y', 'A', 'SY0002  ', 'SY', 'ODGENERALVIEW', 'Tra cứu tổng hợp', 'OD General view', 'NYNNYYYYYYN', null);

COMMIT; 
