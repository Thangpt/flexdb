--
--
/
DELETE RPTMASTER WHERE RPTID = 'SE0086';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('SE0086','HOST','SE','12','5','5','60','5','5','THÔNG TIN SỐ DƯ TÀI KHOẢN LƯU KÝ CHỨNG KHOÁN','Y',1,'1','L','SE0086','Y','S','N','R','N','N','M','000','S',-1,'THÔNG TIN SỐ DƯ TÀI KHOẢN LƯU KÝ CHỨNG KHOÁN',null,'0','0','0','0','N','N','Y');
COMMIT;
/
