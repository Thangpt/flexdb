--
--
/
DELETE RPTMASTER WHERE RPTID = 'CF1021';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CF1021','HOST','CF','12','5','5','60','5','5','HỢP ĐỒNG MỞ TÀI KHOẢN QUA KÊNH ONLINE','Y',1,'1','P','CF1021','N','S','N','R','Y','Y','M','000','S',-1,' Hop dong mo tai khoan online ',null,'0','0','0','0','N','N','Y');
COMMIT;
/
