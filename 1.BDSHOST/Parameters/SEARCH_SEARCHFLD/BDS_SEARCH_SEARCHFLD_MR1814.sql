--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'MR1814';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('MR1814','Quản lý hạn mức User cấp cho Tiểu khoản','General view of allocated to account','select cf.custid , cf.fullname, cf.custodycd, nvl(AF.groupleader,'''') ACCTNOGROUP,
nvl(ual.mrcrlimitmax,0) mrcrlimitmax, ual.acctno, ual.tliduser, tl.tlname,
round(round(nvl(ual.mrcrlimitmax,0)) - round(ci.dfodamt) - round(ci.odamt)  - round(nvl (b.advamt, 0)) +
least(ci.balance - round(ci.trfbuyamt) - round(nvl(b.secureamt,0)) + round(nvl(adv.avladvance,0)) - round(ci.depofeeamt),0)) avlmrlimit
from cfmast cf, afmast af, cimast ci, tlprofiles tl,
(select acctno, tliduser, sum(acclimit) mrcrlimitmax from useraflimit where typereceive = ''MR'' and tliduser = ''<$TELLERID>'' group by acctno, tliduser) ual,
(select afacctno,sum(depoamt) avladvance from v_getAccountAvlAdvance  group by afacctno) adv, v_getbuyorderinfo b
where cf.custid = af.custid and af.acctno = ual.acctno and af.acctno = ci.afacctno and ual.tliduser = tl.tlid
and af.acctno = adv.afacctno(+) and af.acctno = b.afacctno(+) and nvl(ual.mrcrlimitmax,0) > 0','MRTYPE','frmSATLID','TLIDUSER','1814',null,50,'N',30,'NYNNYYYNNN','Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'MR1814';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (8,'FULLNAME','Tên KH','C','MR1814',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'FULLNAME','N','10',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'ACCTNOGROUP','Số TK trưởng nhóm','C','MR1814',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'GROUP LEADER','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'AVLMRLIMIT','HM có thể thu hồi','N','MR1814',100,null,'LIKE,=','#,##0','Y','Y','N',100,null,'available release limit','N','10',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'CUSTID','Mã khách hàng','C','MR1814',100,null,'<,<=,=,>=,>','#,##0','N','N','N',80,null,'CUSTID','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'MRCRLIMITMAX','HM được cấp','N','MR1814',100,null,'LIKE,=','#,##0','Y','Y','N',100,null,'mrcrlimitmax','N','11',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'ACCTNO','Số tiểu khoản','C','MR1814',100,null,'=,Like','_','Y','Y','Y',60,null,'ACCTNO','N','03',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'CUSTODYCD','Số TK lưu ký','C','MR1814',100,null,'=, LIKE',null,'Y','Y','N',80,null,'Custody code','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'TLNAME','Tên User','C','MR1814',200,null,'LIKE,=',null,'Y','Y','N',80,null,'TLNAME','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'TLIDUSER','Mã User','C','MR1814',10,null,'LIKE,=',null,'Y','Y','N',80,null,'USERID','N',null,null,'N',null,null,null,'N');
COMMIT;
/
