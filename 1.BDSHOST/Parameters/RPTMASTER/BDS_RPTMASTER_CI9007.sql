--
--
/
DELETE RPTMASTER WHERE RPTID = 'CI9007';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('CI9007','HOST','CI','12','5','5','60','5','5','DUYỆT ỨNG TRƯỚC TIỀN BÁN THEO NGÀY (1155)','Y',1,'1','P','CI1155','N','A','N','V','N','N','M','000','S',-1,null,null,'0','0','0','0','N','N','Y');
COMMIT;
/
