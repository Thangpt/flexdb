delete from filemaster where filecode in ('I0018','I0019') ;
insert into filemaster (EORI, FILECODE, FILENAME, FILEPATH, TABLENAME, SHEETNAME, ROWTITLE, DELTD, EXTENTION, PAGE, PROCNAME, PROCFILLTER, OVRRQD, MODCODE, RPTID, CMDCODE)
values ('T', 'I0018', 'I0018- Import đăng ký sử dụng sản phẩm', null, 'REGISTERPRODUCT_TEMP', '1', 1, 'N', '.xls', 100, 'PR_REGPRODUCT', 'PR_FILTERREGPRODUCT', 'Y', null, null, 'CF');
insert into filemaster (EORI, FILECODE, FILENAME, FILEPATH, TABLENAME, SHEETNAME, ROWTITLE, DELTD, EXTENTION, PAGE, PROCNAME, PROCFILLTER, OVRRQD, MODCODE, RPTID, CMDCODE)
values ('T', 'I0019', 'I0019- Import hủy đăng ký sử dụng sản phẩm', null, 'CANCELPRODUCT_TEMP', '1', 1, 'N', '.xls', 100, 'PR_DELPRODUCT', 'PR_FILTERDELPRODUCT', 'Y', null, null, 'CF');
commit;
