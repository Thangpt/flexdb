--
--
/
delete from sysvar where varname = 'MAX_DRAFT_ORDERS';
insert into sysvar (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW)
values ('SYSTEM', 'MAX_DRAFT_ORDERS', '100', 'So luong lenh nhap toi da cua 1 nhom lenh nhap', 'So luong lenh nhap toi da cua 1 nhom lenh nhap', 'Y');
commit;
/
