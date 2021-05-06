DELETE FROM cmdmenu WHERE CMDID = '111403';

insert into cmdmenu (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
values ('111403', '111400', 3, 'Y', 'M', 'OD0030  ', 'OD', 'BLORDER', 'Sổ lệnh Bloomberg', 'Bloomberg Order', 'NYNNYYYNNYN', null);

COMMIT;

