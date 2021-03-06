--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'RETAX';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('RETAX','Biểu phí TNCN môi giới','Remiser TAX','SELECT TYP.AUTOID, TYP.ACTYPE,TYP.ACNAME, A0.CDCONTENT STATUS FROM RETAX TYP , ALLCODE A0 WHERE A0.CDTYPE = ''SA'' AND A0.CDNAME = ''ICCFSTATUS'' AND A0.CDVAL = TYP.iccfstatus','RETAX','frmICCFTYPEDEF',null,null,null,-1,'N',30,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'RETAX';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'STATUS','Trạng thái','C','RETAX',100,null,'LIKE,=',null,'Y','Y','N',100,null,'STATUS','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'ACNAME','Tên biểu thuê','C','RETAX',100,null,'LIKE,=',null,'Y','Y','N',250,null,'Acname','Y',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'ACTYPE','Mã biểu thuế','C','RETAX',100,null,'LIKE,=',null,'Y','Y','Y',100,null,'Actype','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'AUTOID','Mã quản lý','N','RETAX',20,null,'=,<>,<,<=,>=,>','#,##0','N','Y','N',100,null,'Auto ID','N',null,null,'N',null,null,null,'N');
COMMIT;
/
