--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'CA3382';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('CA3382','Chuyển nhượng quyền mua trong nội bộ công ty','Transfer','SELECT MST.*, (CASE WHEN VW.ISSUERMEMBER=''Y''THEN ''Thành viên quản trị của TCPH'' ELSE ''Không'' END ) ISSUERMEMBER, M.VARVALUE FROMCUSADD, M.VARVALUE TOCUSADD,
(CASE WHEN VW.ISSUERMEMBER=''Y''THEN ''Y'' ELSE ''N'' END ) ISSUERMEMBERCD   FROM
(
      SELECT (CA.Pbalance) QTTY, (CA.Pbalance) PQTTY ,(CA.PBALANCE-CA.INBALANCE) RETAILBAL,CA.INBALANCE,
      SUBSTR(CAMAST.CAMASTID,1,4) ||''.''||
      SUBSTR(CAMAST.CAMASTID,5,6) ||''.''||
      SUBSTR(CAMAST.CAMASTID,11,6) CAMASTID,
      CA.AFACCTNO, CAMAST.optcodeid  CODEID,
      SYM.SYMBOL , A1.CDCONTENT STATUS,CA.AFACCTNO ||
      CAMAST.CODEID  SEACCTNO, CAMAST.CODEID SBCODEID,SYM.PARVALUE PARVALUE,
      CAMAST.REPORTDATE REPORTDATE,
      CAMAST.ACTIONDATE,CAMAST.EXPRICE, AFM.*, A2.CDCONTENT
      CATYPE, CAMAST.TRFLIMIT,iss.fullname ISSNAME,
      CA.autoid, SB2.SYMBOL TOSYMBOL, ISS2.FULLNAME TOISSNAME,
      sb2.codeid tocodeid, CAMAST.ISINCODE, CAMAST.VNCODE
      FROM  SBSECURITIES SYM, ALLCODE A1, CAMAST, CASCHD
      CA,issuers iss ,
            (    Select   AF.ACCTNO, CF.CUSTODYCD, CF.FULLNAME  CUSTNAME,
                               A1.CDCONTENT COUNTRY, cf.address,
                               --cf.idcode LICENSE,
                               (case when cf.country = ''234'' then cf.idcode else cf.tradingcode end) LICENSE,
                               (case when cf.country = ''234'' then cf.iddate else cf.tradingcodedt end) iddate,
                               cf.idplace
                 From afmast af, ALLCODE A1, cfmast cf
                 Where af.custid = cf.custid
                              and af.status  IN (''A'',''N'',''C'')
                              AND CF.COUNTRY = A1.CDVAL
                              AND A1.CDTYPE =''CF''
                              AND A1.CDNAME = ''COUNTRY''
             ) AFM, ALLCODE A2, SBSECURITIES SB2, issuers ISS2
      WHERE CA.AFACCTNO=AFM.ACCTNO AND A1.CDTYPE = ''CA''
       AND A1.CDNAME = ''CASTATUS'' AND A1.CDVAL = CA.STATUS AND
      CAMAST.CODEID = SYM.CODEID  AND CAMAST.status in
      (''V'',''S'',''M'')
      AND  CAMAST.catype=''014'' AND CA.camastid =
      CAMAST.camastid AND CA.status in(''V'',''S'',''M'') AND
      CA.DELTD <>''Y'' AND (CA.PBALANCE )  > 0
      AND CAMAST.CATYPE = A2.CDVAL AND A2.CDTYPE = ''CA''
      AND A2.CDNAME = ''CATYPE''
      AND iss.issuerid = sym.issuerid
      AND NVL(CAMAST.TOCODEID, CAMAST.CODEID) = SB2.CODEID
      AND ISS2.ISSUERID = SB2.ISSUERID
      AND camast.frdatetransfer <= GETCURRDATE() AND camast.todatetransfer >=GETCURRDATE()
) MST, ( Select VWW.*, ''Y''ISSUERMEMBER from VW_ISSUER_MEMBER VWW ) VW, (select VARVALUE from sysvar where VARNAME like ''%ISSUERMEMBER%'') M
WHERE  MST.CUSTODYCD = VW.CUSTODYCD  (+)
                AND MST.SYMBOL = VW.SYMBOL (+)','CAMAST',null,null,'3382',null,50,'N',30,'NYNNYYYNNN','Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'CA3382';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (48,'VNCODE','Mã thực hiện quyền trong nước','C','CA3382',100,null,'LIKE,=',null,'Y','Y','N',100,null,'VN CODE','N','11',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (47,'ISINCODE','Mã ISIN','C','CA3382',100,null,'LIKE,=',null,'Y','Y','N',100,null,'ISIN CODE','N','10',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (46,'TOCODEID','Mã CK nhận','C','CA3382',100,null,'LIKE,=',null,'Y','N','N',100,null,'ISSNAME','N','62',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (45,'TOISSNAME','Tên CK nhận','C','CA3382',100,null,'LIKE,=',null,'N','N','N',100,null,'ISSNAME','N','61',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (28,'TOCUSADD','TVLK bên nhận','C','CA3382',100,null,'LIKE,=',null,'Y','Y','N',100,null,'FROMCUSADD','N','85',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (27,'FROMCUSADD','TVLK bên chuyển','C','CA3382',100,null,'LIKE,=',null,'Y','Y','N',100,null,'FROMCUSADD','N','25',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (26,'ISSUERMEMBERCD','Thành viên quản trị TCPH','C','CA3382',50,null,'LIKE,=',null,'Y','N','N',50,null,'Issuer member','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (25,'ISSNAME','Tên chứng khoán ','C','CA3382',100,null,'LIKE,=',null,'Y','Y','N',100,null,'ISSNAME','N','79',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (20,'TRFLIMIT','Chuyển nhượng quyền mua','C','CA3382',1,null,'=',null,'N','N','N',80,null,'Tranfer limit','N','31',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (19,'IDPLACE','Nơi cấp ','C','CA3382',100,null,'LIKE,=',null,'Y','Y','N',100,null,'ID Place','N','94',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (18,'IDDATE','Ngày cấp','D','CA3382',100,'__/__/____','<,<=,=,>=,>,<>','##/##/####','Y','Y','N',100,null,'ID Date','N','93',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (17,'LICENSE','CMND Số','C','CA3382',100,null,'LIKE,=',null,'Y','Y','N',100,null,'ID Code','N','92',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (16,'COUNTRY','Quốc tịch','C','CA3382',200,null,'LIKE,=',null,'Y','Y','N',200,null,'COUNTRY','N','80',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (16,'ADDRESS','Địa chỉ','C','CA3382',200,null,'LIKE,=',null,'Y','Y','N',200,null,'Address','N','91',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (15,'CUSTNAME','Tên khách hàng','C','CA3382',200,null,'LIKE,=',null,'Y','Y','N',200,null,'Full Name','N','90',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (14,'EXPRICE','Giá','N','CA3382',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'EXPRICE','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (11,'INBALANCE','SLQM nhận chuyển nhượng','N','CA3382',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'Quantity','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (10,'QTTY','SLQM sở hữu','N','CA3382',100,null,'<,<=,=,>=,>','#,##0','N','Y','N',100,null,'Quantity','N','21',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (9,'RETAILBAL','SLQM được chốt','N','CA3382',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'Quantity','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (8,'PQTTY','Số lượng','N','CA3382',100,null,'<,<=,=,>=,>','#,##0','N','N','N',100,null,'Quantity','N','22',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'CODEID','Chứng khoán','C','CA3382',100,null,'=',null,'Y','Y','N',80,null,'Symbol','N','01',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'SBCODEID','Chứng khoán','C','CA3382',100,null,'=',null,'N','Y','N',80,null,'Symbol','N','07',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'CATYPE','Loại TH quyền','C','CA3382',100,null,'=',null,'Y','Y','N',100,null,'Coporate type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'STATUS','Trạng thái','C','CA3382',100,null,'LIKE,=',null,'Y','N','N',80,null,'Status','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'TOSYMBOL','CK nhận','C','CA3382',100,null,'LIKE,=',null,'Y','N','N',80,null,'Symbol','N','60',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'SYMBOL','CK chốt','C','CA3382',100,null,'LIKE,=',null,'Y','Y','N',80,null,'Symbol','N','35',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'AFACCTNO','Mã Tiểu khoản','C','CA3382',100,null,'=','_','Y','Y','N',100,null,'Contrac No','N','02',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'CUSTODYCD','Số TK lưu ký','C','CA3382',100,null,'=, LIKE','_','Y','Y','N',100,null,'Custody Code','N','36',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'ISSUERMEMBER','Thành viên quản trị TCPH','C','CA3382',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Issuer member','N','40',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'CAMASTID','Mã TH quyền','C','CA3382',100,'cccc.cccccc.cccccc','LIKE,=','_','Y','Y','N',120,null,'CA code','N','06',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'AUTOID','Số tự tăng','C','CA3382',100,null,'<,<=,=,>=,>',null,'N','N','N',100,null,'AutoId','N','09',null,'N',null,null,null,'N');
COMMIT;
/
