--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'CI1104';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('CI1104','Tra c?u l?nh chuy?n kho?n sang Ngân hàng (1104)','View pending transfer to other bank (wait for 1104)',' SELECT FN_GET_LOCATION(af.brid) LOCATION, SUBSTR(RM.TXNUM,1,4) BRID, CF.FULLNAME,T1.TLNAME MAKER,T2.TLNAME OFFICER, SUBSTR(CF.CUSTODYCD,1,3) || ''.'' || SUBSTR(CF.CUSTODYCD,4,1) || ''.'' || SUBSTR(CF.CUSTODYCD,5,6) CUSTODYCD, CD1.CDCONTENT DESC_IDTYPE, CF.IDCODE,
  SUBSTR(AF.ACCTNO,1,4) || ''.'' || SUBSTR(AF.ACCTNO,5,6) ACCTNO,CF.CUSTID, RM.TXDATE, RM.TXNUM, RM.BANKID,RM.BENEFBANK,RM.CITYEF,RM.CITYBANK, RM.BENEFACCT, RM.BENEFCUSTNAME, RM.BENEFLICENSE, RM.BENEFIDDATE, RM.BENEFIDPLACE, RM.AMT, RM.FEEAMT,AF.ACCTNO || '' : '' ||TL.TXDESC DESCRIPTION, RM.FEETYPE,
  CF.IDDATE,CF.IDPLACE,CF.ADDRESS,
  A1.CDCONTENT FEENAME,  '''' GLACCTNO,  '''' POTXNUM, '''' POTXDATE, '''' BANKNAME, '''' BANKACC, ''001'' POTYPE
  FROM CIREMITTANCE RM, AFMAST AF, CFMAST CF, ALLCODE A1,  ALLCODE CD1,(SELECT TLID, TLNAME FROM TLPROFILES UNION ALL SELECT ''____'' TLID, ''____'' TLNAME FROM DUAL) T1,
  (SELECT TLID, TLNAME FROM TLPROFILES UNION ALL SELECT ''____'' TLID, ''____'' TLNAME FROM DUAL) T2,
      (select * from ((SELECT * FROM TLLOG WHERE TLTXCD in (''1101'',''1108'',''1111'',''1119'',''1133'',''1185'') AND TXSTATUS=''1'' UNION SELECT * FROM TLLOGALL WHERE TLTXCD in (''1101'',''1108'',''1111'',''1119'',''1133'',''1185'') AND TXSTATUS=''1'') TL)
      /*where
      (''<$BRID>'' =''0001'' AND ( (tl.tlid <> ''6868'' AND SUBSTR(tl.txnum,0,4) IN (''0001'',''0002'',''0003''))
                           OR (tl.tlid = ''6868'' AND SUBSTR(tl.msgacct,0,4) IN (''0001'',''0002'',''0003'')))
        )
        OR
        (''<$BRID>'' =''0101'' AND ( (tl.tlid <> ''6868'' AND SUBSTR(tl.txnum,0,4) IN (''0101'',''0102'',''0103''))
                           OR (tl.tlid = ''6868'' AND SUBSTR(tl.msgacct,0,4) IN (''0101'',''0102'',''0103'')))
        )*/) TL
  WHERE CF.CUSTID=AF.CUSTID AND RM.ACCTNO=AF.ACCTNO AND RM.DELTD=''N'' AND RM.RMSTATUS in (''P'',''M'') AND TL.TXNUM=RM.TXNUM AND TL.TXDATE=RM.TXDATE
  AND CD1.CDTYPE=''CF'' AND CD1.CDNAME=''IDTYPE'' AND CD1.CDVAL=CF.IDTYPE
  AND A1.CDTYPE=''SA'' AND A1.CDNAME=''IOROFEE'' AND A1.CDVAL=NVL(RM.FEETYPE,''0'')
  AND (CASE WHEN TL.TLID IS NULL THEN ''____'' ELSE TL.TLID END)=T1.TLID
  AND (CASE WHEN TL.OFFID IS NULL THEN ''____'' ELSE TL.OFFID END)=T2.TLID','CI.CIMAST',null,null,'1104',null,50,'N',30,'NYNNYYYNNN','Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'CI1104';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (200,'LOCATION','Khu vực','C','CI1104',100,null,'=',null,'Y','Y','N',100,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''SA'' AND CDNAME = ''LOCATION'' ORDER BY LSTODR','Location','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (102,'POTYPE','Loại UNC','C','CI1104',100,null,'=,LIKE','_','N','N','N',100,null,'POTYPE','N','17',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (101,'BANKACCNAME','Tên TK ngân hàng','C','CI1104',100,null,'=,LIKE','_','N','N','N',100,null,'Bankaccname','N','86',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (100,'POTXNUM','Số bảng kê','C','CI1104',100,'9999.999999','=,LIKE','_','N','N','N',100,null,'POTXNUM','N','99',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (100,'BANKNAME','Tên ngân hàng','C','CI1104',100,null,'LIKE,=','_','N','N','N',100,null,'BANKNAME','N','85',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (100,'GLACCTNO','Tài khoản kế toán','C','CI1104',100,'9999.999999','LIKE,=','_','N','N','N',100,null,'GL Account','N','15',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (100,'BANKACC','Số tài khoản','C','CI1104',100,null,'LIKE,=','_','N','N','N',100,null,'BANKACC','N','08',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (100,'FEETYPE','Loại phí','C','CI1104',100,null,'LIKE,=','_','N','N','N',100,null,'FEETYPE','N','09',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (100,'POTXDATE','Ngày bảng kê','C','CI1104',100,'9999.999999','=,LIKE','_','N','N','N',100,null,'POTXDATE','N','98',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (22,'BENEFIDPLACE','Nơi cấp','C','CI1104',100,null,'LIKE,=',null,'Y','N','N',100,null,'Beneficary Place','N','96',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (21,'BENEFIDDATE','Ngày cấp','D','CI1104',100,'99/99/9999','LIKE,=','99/99/9999','Y','N','N',100,null,'Beneficary Date','N','95',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (20,'BENEFCUSTNAME','Tên người thụ hưởng','C','CI1104',100,null,'LIKE,=','_','Y','Y','N',100,null,'Beneficary customer','N','82',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (20,'BENEFLICENSE','Số giấy tờ người thụ hưởng','C','CI1104',100,null,'LIKE,=','_','Y','Y','N',100,null,'Beneficary code','N','83',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (19,'DESCRIPTION','Diễn giải','C','CI1104',100,null,'LIKE,=','_','Y','Y','N',100,null,'Description','N','30',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (18,'CITYBANK','Chi nhánh NH thụ hưởng','C','CI1104',100,null,'LIKE,=','_','Y','Y','N',100,null,'City Bank','N','32',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (18,'CITYEF','Thành Phố','C','CI1104',100,null,'LIKE,=','_','Y','Y','N',100,null,'City','N','33',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (18,'BENEFBANK','Ngân hàng thụ hưởng','C','CI1104',100,null,'LIKE,=','_','Y','Y','N',100,null,'Beneficary bank','N','80',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (17,'FEEAMT','Số phí','N','CI1104',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Fee amount','N','11',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (16,'AMT','Số tiền chuyển','N','CI1104',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Transfer amount','N','10',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (15,'OFFICER','Officer','C','CI1104',100,null,'LIKE,=','_','Y','Y','N',100,null,'Officer','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (14,'MAKER','Maker','C','CI1104',100,null,'LIKE,=','_','Y','Y','N',100,null,'Maker','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (12,'BANKID','Mã Ngân hàng','C','CI1104',100,'9999999999','LIKE,=','_','Y','Y','N',100,null,'Bank ID','N','05',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (11,'BENEFACCT','Số tài khoản thụ hưởng','C','CI1104',100,null,'LIKE,=','_','Y','Y','N',100,null,'Beneficary account','N','81',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (10,'TXNUM','Số chứng từ','C','CI1104',100,'9999999999','LIKE,=','_','Y','Y','N',100,null,'Voucher number','N','07',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (9,'TXDATE','Ngày lập chứng từ','D','CI1104',100,'99/99/9999','LIKE,=','_','Y','Y','N',100,null,'Voucher date','N','06',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (8,'IDPLACE','Nơi cấp','C','CI1104',100,null,'LIKE,=',null,'Y','N','N',100,null,'Beneficary Place','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'IDDATE','Ngày cấp','D','CI1104',100,'99/99/9999','LIKE,=','99/99/9999','Y','N','N',100,null,'Beneficary Date','N','67',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'IDCODE','Số giấy tờ','C','CI1104',100,null,'LIKE,=','_','Y','N','N',100,null,'ID Code','N','92',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'DESC_IDTYPE','Loại giấy tờ','C','CI1104',100,null,'LIKE,=','_','Y','N','N',100,null,'ID Type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'CUSTODYCD','Số tài khoản lưu ký','C','CI1104',100,null,'LIKE,=','_','Y','Y','N',100,null,'Custody code','N','04',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'ADDRESS','Địa chỉ','C','CI1104',100,null,'LIKE,=','_','Y','N','N',100,null,'Customer name','N','91',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'FULLNAME','Tên khách hàng','C','CI1104',100,null,'LIKE,=','_','Y','N','N',100,null,'Customer name','N','90',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'ACCTNO','Số Tiểu khoản','C','CI1104',100,'9999.999999','LIKE,=','_','Y','Y','N',100,null,'Contract number','N','03',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'FEENAME','Loại phí','C','CI1104',100,null,'LIKE,=','_','Y','Y','N',100,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''SA'' AND CDNAME = ''IOROFEE'' ORDER BY LSTODR','Fee Type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'BRID','Mã chi nhánh','C','CI1104',100,'9999','Not Like, LIKE, =','_','Y','Y','N',100,null,'Branch ID','N',null,null,'N',null,null,null,'N');
COMMIT;
/
