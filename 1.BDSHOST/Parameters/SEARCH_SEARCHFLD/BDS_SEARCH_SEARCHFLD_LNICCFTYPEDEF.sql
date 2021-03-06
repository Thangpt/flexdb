--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'LNICCFTYPEDEF';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('LNICCFTYPEDEF','Xu ly tu dong','Batch events','SELECT TYP.AUTOID, TYP.EVENTCODE, TYP.ACTYPE, APPEVENTS.EVENTNAME FROM ICCFTYPEDEF TYP, APPEVENTS WHERE TYP.EVENTCODE=APPEVENTS.EVENTCODE AND TYP.MODCODE=APPEVENTS.MODCODE AND TYP.MODCODE=''<$MODCODE>'' AND TYP.ACTYPE=''<$KEYVAL>'' ORDER BY TYP.EVENTCODE','LN.ICCFTYPEDEF','frmICCFTYPEDEF',null,null,null,50,'N',30,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'LNICCFTYPEDEF';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'EVENTNAME','Ten su kien','C','LNICCFTYPEDEF',100,null,'LIKE,=',null,'Y','Y','N',500,null,'Event name','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'EVENTCODE','Ma su kien','C','LNICCFTYPEDEF',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Event code','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'AUTOID','Ma quan ly','N','LNICCFTYPEDEF',20,null,'=,<>,<,<=,>=,>','#,##0','N','Y','Y',100,null,'Auto ID','N',null,null,'N',null,null,null,'N');
COMMIT;
/
