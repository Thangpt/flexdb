--
--
/
DELETE RPTMASTER WHERE RPTID = 'ODPL09';
INSERT INTO RPTMASTER (RPTID,DSN,MODCODE,FONTSIZE,RHEADER,PHEADER,RDETAIL,PFOOTER,RFOOTER,DESCRIPTION,AD_HOC,RORDER,PSIZE,ORIENTATION,STOREDNAME,VISIBLE,AREA,ISLOCAL,CMDTYPE,ISCAREBY,ISPUBLIC,ISAUTO,ORD,AORS,ROWPERPAGE,EN_DESCRIPTION,STYLECODE,TOPMARGIN,LEFTMARGIN,RIGHTMARGIN,BOTTOMMARGIN,SUBRPT,ISCMP,ISDEFAULTDB)
VALUES ('ODPL09','HOST','OD','12','5','5','60','5','5','THÔNG BÁO TỔNG HỢP KẾT QUẢ THANH TOÁN TRỰC TIẾP TIỀN  CP, CCQ TRÊN SÀN HNX VÀ HOSE/ TRÁI PHIẾU NGOẠI TỆ','Y',1,'1','L','ODPL09','Y','S','N','R','N','N','M','000','S',-1,'THÔNG BÁO TỔNG HỢP KẾT QUẢ THANH TOÁN TRỰC TIẾP TIỀN  CP, CCQ TRÊN SÀN HNX VÀ HOSE/ TRÁI PHIẾU NGOẠI TỆ',null,'0','0','0','0','N','N','Y');
COMMIT;
/
