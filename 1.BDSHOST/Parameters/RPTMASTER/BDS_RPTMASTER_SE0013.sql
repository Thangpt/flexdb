--
--
/
DELETE RPTMASTER WHERE RPTID = 'SE0013';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('SE0013','HOST','SE','12','5','5','60','5','5','BÁO CÁO DANH SÁCH GIAO DỊCH LƯU KÝ','Y',1,'1','L','SE0013','Y','S','N','R','N','N','M','000','S',-1,'Báo cáo danh sách giao dịch luư ký',null,'0','0','0','0','N','N','Y');
COMMIT;
/
