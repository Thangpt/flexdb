--
--
/
DELETE RPTMASTER WHERE RPTID = 'CA0023';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CA0023','HOST','CA','12','5','5','60','5','5','BÁO CÁO XÁC NHẬN DANH SÁCH NGƯỜI SỞ HỮU LƯU KÝ CK','Y',1,'1','L','CA0023','N','S','N','R','N','N','M','000','S',-1,'Báo cáo xác nhận danh sách người sở hữu lưu ký CK',null,'0','0','0','0','N','N','Y');
COMMIT;
/
