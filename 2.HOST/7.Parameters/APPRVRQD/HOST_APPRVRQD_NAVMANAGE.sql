--
--
/
DELETE apprvrqd WHERE objname ='NAVMANAGE';
insert into apprvrqd (OBJNAME, RQDSTRING, MAKERID, MAKERDT, APPRVID, APPRVDT, MODNUM)
values ('NAVMANAGE', 'ALL', null, null, null, null, 1);
COMMIT;
/
