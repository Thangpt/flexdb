--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'LNSCHD_T0';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('LNSCHD_T0','Giải ngân trong ngày','Customer loan account management','
select cf.custodycd, tr.txnum rlstxnum, to_char(tr.txdate,''DD/MM/RRRR'') rlstxdate, tr.lnacctno, tr.ciacctno acctno, tr.rlsamt, ls.lnschdid, ls.lntype
from
cfmast cf, afmast af,
(
select t.txnum, t.txdate,
    max(decode(f.fldcd,''03'', cvalue, null)) lnacctno,
    max(decode(f.fldcd,''05'', cvalue, null)) ciacctno,
    max(case when decode(f.fldcd,''10'', nvalue, 0)> 0 then ''P''
            when decode(f.fldcd,''11'', nvalue, 0)> 0 then ''GP''
            else null end) reftype,
    sum(decode(f.fldcd,''10'', nvalue, 0) + decode(f.fldcd,''11'', nvalue, 0)) rlsamt
from tllog t, tllogfld f
where tltxcd = ''5566'' and deltd <> ''Y''
    and t.txnum = f.txnum
    and t.txdate = f.txdate
group by t.txnum, t.txdate
) tr,
(
select ls.acctno, ls.nml, ls.ovd, ls.reftype, ln.trfacctno, ls.autoid lnschdid, lnt.actype || '': '' || lnt.typename lntype
from lnmast ln, lnschd ls, lntype lnt
where ln.acctno = ls.acctno AND ln.actype = lnt.actype
and ls.reftype = ''P''
and ls.rlsdate = (select to_date(varvalue,''DD/MM/RRRR'') from sysvar where varname = ''CURRDATE'')
) ls
where cf.custid = af.custid
and af.acctno = ls.trfacctno
and tr.lnacctno = ls.acctno
and tr.reftype = ls.reftype
and tr.rlsamt = ls.nml+ls.ovd
and af.acctno = tr.ciacctno
','LNSCHD_T0','frmLNMAST',null,null,null,50,'N',0,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'LNSCHD_T0';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (30,'RLSTXDATE','Ngày chứng từ giải ngân','C','LNSCHD_T0',100,null,'LIKE,=','_','Y','Y','N',100,null,'Product type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (25,'RLSTXNUM','Số chứng từ giải ngân','C','LNSCHD_T0',100,null,'LIKE,=','_','Y','Y','Y',100,null,'Product type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (20,'RLSAMT','Số tiền giải ngân','N','LNSCHD_T0',250,null,'<,<=,=,>=,>,<>','#,##0.###0','Y','N','N',100,null,'Loan amount','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (15,'LNSCHDID','Mã hiệu lịch vay','C','LNSCHD_T0',100,null,'LIKE,=','_','Y','Y','N',100,null,'Product type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (10,'LNACCTNO','Số tiểu khoản vay','C','LNSCHD_T0',100,null,'LIKE,=','_','Y','Y','N',100,null,'Product type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'ACCTNO','Số tiểu khoản','C','LNSCHD_T0',100,null,'LIKE,=','_','Y','Y','N',100,null,'Product type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'CUSTODYCD','Số TK lưu ký','C','LNSCHD_T0',100,null,'LIKE,=','_','Y','Y','N',100,null,'Product type','N',null,null,'N',null,null,null,'N');
COMMIT;
/
