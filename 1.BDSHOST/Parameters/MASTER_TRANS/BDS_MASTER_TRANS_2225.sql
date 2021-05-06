--
--
/
DELETE FLDVAL WHERE OBJNAME = '2225';
INSERT INTO FLDVAL (FLDNAME,OBJNAME,ODRNUM,VALTYPE,OPERATOR,VALEXP,VALEXP2,ERRMSG,EN_ERRMSG,TAGFIELD,TAGVALUE,CHKLEV)
VALUES ('14','2225',17,'V','>=','@0',null,'Số chứng khoán ĐKQM/nhận CP phải lớn hơn hoặc bằng 0',' The quantity register cant be less than 0',null,null,'0');
COMMIT;
/
