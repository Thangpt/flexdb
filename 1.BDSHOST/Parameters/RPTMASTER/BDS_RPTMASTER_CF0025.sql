--
--
/
DELETE RPTMASTER WHERE RPTID = 'CF0025';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CF0025','HOST','CF','12','5','5','60','5','5','BÁO CÁO TRẠNG THÁI TÀI KHOẢN GROUP (POSITION)','Y',1,'1','P','CF0025','N','S','N','R','Y','Y','M','000','S',-1,'BÁO CÁO TRẠNG THÁI TÀI KHOẢN GROUP',null,'0','0','0','0','N','N','Y');
COMMIT;
/
