--
--
/
DELETE FILEMASTER WHERE FILECODE = 'I038';
insert into FILEMASTER (EORI, FILECODE, FILENAME, FILEPATH, TABLENAME, SHEETNAME, ROWTITLE, DELTD, EXTENTION, PAGE, PROCNAME, PROCFILLTER, OVRRQD, MODCODE, RPTID, CMDCODE)
values ('T', 'I038', 'Danh sách KH hưởng chính sách ưu đãi', null, 'TBCFPREFERENTIAL', '1', 1, 'N', '.xls', 100, 'PR_CFLN_PREFERENTIAL_APPROVE', 'PR_CFLN_PREFERENTIAL', 'Y', null, null, 'CF');
COMMIT;
/
