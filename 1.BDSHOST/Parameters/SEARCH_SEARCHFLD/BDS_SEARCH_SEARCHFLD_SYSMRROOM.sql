--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'SYSMRROOM';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('SYSMRROOM','Tra cứu Room CK margin (theo UBCK)','Pool/Room Master','select sb.codeid, sb.symbol, rm.roomlimit prlimit, nvl(afpr.prinused,0) prinused,
rm.roomlimit - nvl(afpr.prinused,0) pravllimit, sb.roomlimit, sb.roomlimitmax, sb.listingqtty,
nvl(afpr.prinused,0) markedqtty, c1.cdcontent ismarginallow, ''M'' roomtype
from vw_marginroomsystem rm, securities_info sb,
       (select codeid, sum(prinused) prinused from vw_afpralloc_all where restype = ''M'' group by codeid) afpr,
             securities_risk prallow,
             allcode c1
where rm.codeid = afpr.codeid(+) and rm.codeid = sb.codeid and rm.codeid = prallow.codeid(+) and nvl(prallow.ismarginallow,''N'') = ''Y''
and c1.cdname = ''YESNO'' and c1.cdtype = ''SY'' and c1.cdval = nvl(prallow.ismarginallow,''N'')','SYSMRROOM',null,null,'0104',null,50,'N',30,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'SYSMRROOM';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (11,'ROOMLIMITMAX','Room theo công ty','N','SYSMRROOM',20,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',150,null,'In used','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (9,'ROOMLIMIT','Room theo CK niêm yết','N','SYSMRROOM',20,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',150,null,'In used','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (8,'LISTINGQTTY','SL niêm yết','N','SYSMRROOM',20,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',150,null,'In used','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'PRAVLLIMIT','Room còn lại','N','SYSMRROOM',20,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',150,null,'In used','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'PRINUSED','Room đã sử dụng','N','SYSMRROOM',20,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',150,null,'In used','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'PRLIMIT','Room tối đa','N','SYSMRROOM',20,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',150,null,'Limit','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'ISMARGINALLOW','Margin UBCK','C','SYSMRROOM',10,null,'=,LIKE',null,'Y','Y','N',100,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''SY'' AND CDNAME = ''YESNO'' ORDER BY LSTODR','Symbol','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'SYMBOL','Mã chứng khoán','C','SYSMRROOM',10,null,'=,LIKE',null,'Y','Y','N',100,null,'Symbol','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'ROOMTYPE','Loại nguồn','C','SYSMRROOM',10,null,'=,LIKE',null,'N','N','N',20,null,'Room Type','N','29',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'CODEID','Tham chiếu chứng khoán','C','SYSMRROOM',10,null,'<,<=,=,',null,'N','N','Y',10,null,'Codeid','N','01',null,'N',null,null,null,'N');
COMMIT;
/
