--
--
/
alter table TEMPLATES add  
(PRIORITY  number default '2');
COMMIT;
/
update TEMPLATES set PRIORITY = '3' where code in ('0214', '0215', '2302', '2804')
commit;
/