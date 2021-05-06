--
--
/
DELETE SYSVAR WHERE VARNAME = 'CHGBCHORDERSTARTDATE';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('OD','CHGBCHORDERSTARTDATE','04/01/2016','Ngày thay đổi thứ tự thanh toán bù trừ từ thời điểm đầu ngày sang thời điểm cuối ngày','On changing the order of clearing from the start date to the end of the day','N');
COMMIT;
/
