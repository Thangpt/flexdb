--
--
/
DELETE SYSVAR WHERE VARNAME = 'NAV-NO';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','NAV-NO','38','Tham số NAV/(Nợ - tiền) cho phép mua các mã chứng khoán bằng bảo lãnh','Tham số NAV/(Nợ - tiền) cho phép mua các mã chứng khoán bằng bảo lãnh','Y');
COMMIT;
/
