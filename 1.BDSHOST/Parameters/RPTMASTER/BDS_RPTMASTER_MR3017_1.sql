--
--
/
DELETE RPTMASTER WHERE RPTID = 'MR3017_1';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('MR3017_1','HOST','MR','12','5','5','60','5','5','DANH SÁCH TÀI SẢN','Y',1,'1','P','MR3017_1','Y','S','N','R','N','N','M','000','S',-1,'DANH SÁCH TÀI SẢN ÐẢM BẢO',null,'0','0','0','0','N','N','Y');
COMMIT;
/
