--
--
alter table odmast
add repotype NUMBER default 0;
alter table odmasthist
add repotype NUMBER default 0;
commit;
