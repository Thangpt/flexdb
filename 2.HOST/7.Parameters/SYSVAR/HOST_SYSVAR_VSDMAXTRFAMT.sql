--
--
/
DELETE SYSVAR WHERE VARNAME = 'VSDMAXTRFAMT';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','VSDMAXTRFAMT','500000','Phí chuyển khoản chứng khoán bù trừ tối đa','Phi chuyen khoan chung khoan bu tru toi da','Y');
COMMIT;
/
