--
--
/
DELETE RPTMASTER WHERE RPTID = 'SA1118';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('SA1118','HOST','SA','12','5','5','60','5','5','YÊU CẦU CHUYỂN TIỀN NỘI BỘ TỪ INTERNET (GIAO DỊCH 1118)','Y',1,'1','P','SA9001','Y','B','N','V','N','N','M','000','S',-1,'View pending internal transfer request from internet (wait for 1118)',null,'0','0','0','0','N','N','Y');
COMMIT;
/
