--
--
/
DELETE RPTMASTER WHERE RPTID = 'OD0089';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('OD0089','HOST','OD','12','5','5','60','5','5','BÁO CÁO ĐỐI CHIẾU TỔNG HỢP THANH TOÁN BÙ TRỪ THEO NGÀY THANH TOÁN','Y',1,'1','L','OD0089','Y','S','N','R','N','N','M','000','S',-1,' BÁO CÁO ĐỐI CHIẾU TỔNG HỢP THANH TOÁN BÙ TRỪ THEO NGÀY THANH TOÁN ',null,'0','0','0','0','N','N','Y');
COMMIT;
/
