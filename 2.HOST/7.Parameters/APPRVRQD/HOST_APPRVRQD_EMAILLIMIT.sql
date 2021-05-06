--
--
/
DELETE apprvrqd WHERE objname ='EMAILLIMIT';
insert into apprvrqd (OBJNAME, RQDSTRING, MAKERID, MAKERDT, APPRVID, APPRVDT, MODNUM)
values ('EMAILLIMIT', 'ALL', null, null, null, null, 1);
COMMIT;
/
