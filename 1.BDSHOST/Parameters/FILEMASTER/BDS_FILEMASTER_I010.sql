--
--
/
DELETE filemaster WHERE filecode = 'I010';
insert into filemaster (EORI, FILECODE, FILENAME, FILEPATH, TABLENAME, SHEETNAME, ROWTITLE, DELTD, EXTENTION, PAGE, PROCNAME, PROCFILLTER, OVRRQD, MODCODE, RPTID, CMDCODE)
values ('T', 'I010', 'I010- Import hạn mức chuyển tiền riêng cho KH', null, 'CFTRFLIMIT_TEMP', '1', 1, 'N', '.xls', 100, 'PR_CFTRFLIMIT', 'PR_FILTERCFTRFLIMIT', 'Y', null, null, 'CF');
COMMIT;
/
