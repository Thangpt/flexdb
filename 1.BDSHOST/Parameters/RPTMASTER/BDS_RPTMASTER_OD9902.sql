--
--
/
DELETE RPTMASTER WHERE RPTID = 'OD9902';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('OD9902','HOST','OD','12','5','5','60','5','5','DOANH SỐ LỆNH ĐẶT ONLINE CỦA OT','Y',1,'1','L','OD9902','N','S','N','R','N','Y','M','000','S',-1,'Doanh s? l?nh d?t online c?a OT',null,'0','0','0','0','N','N','Y');
COMMIT;
/
