--
--
/
DELETE SYSVAR WHERE VARNAME = 'ONLINEMAXTRF_CNT_1';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','ONLINEMAXTRF_CNT_1','0','Số tiền chuyển khoản khác chủ tài khoản tối đa/ 1 ngày','Số tiền chuyển khoản khác chủ tài khoản tối đa/ 1 ngày','Y');
COMMIT;
/
