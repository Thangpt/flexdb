--
--
/
DELETE SYSVAR WHERE VARNAME = 'MAXDEBTDAYS';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('MARGIN','MAXDEBTDAYS','90','Số ngày cho vay tối đa áp dụng với mỗi lần giải ngân hay gia hạn','Max debt day for each releasing time','Y');
COMMIT;
/
