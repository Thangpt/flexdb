--
--
/
DELETE RPTMASTER WHERE RPTID = 'LN0016';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('LN0016','HOST','LN','12','5','5','60','5','5','BÁO CÁO DƯ NỢ KỲ ĐÁNH GIÁ','Y',1,'1','L','LN0016','Y','S','N','R','N','N','M','000','S',-1,'BẢNG ĐỀ NGHỊ SỬ DỤNG HẠN MỨC THẤU CHI',null,'0','0','0','0','N','N','Y');
COMMIT;
/
