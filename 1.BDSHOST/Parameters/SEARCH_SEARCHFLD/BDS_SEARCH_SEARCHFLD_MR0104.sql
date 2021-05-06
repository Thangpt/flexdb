--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'MR0104';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('MR0104','Danh sách tài sản đánh dấu Margin','Marked Asset Management','SELECT af.custodycd, af.afacctno, af.actype, af.codeid, af.marginprice, af.marginrefprice, af.codeid_num,
    nvl(a.prinused,0) prinused, nvl(a.syprinused,0) syprinused, nvl(b.grp_prinused,0) grp_prinused,
    nvl(a.prinused,0)*nvl(afm.mrratioloan,0)/100*LEAST(af.marginrefprice,afm.mrpriceloan) PRINCALLMARGIN,
    nvl(a.SYPRINUSED,0)*nvl(afs.mrratioloan,0)/100*LEAST(af.marginprice,afs.mrpriceloan) SYSCALLMARGIN,
    nvl(b.grp_prinused,0)*nvl(afs.mrratioloan,0)/100*af.marginprice GRPCALLMARGIN,
    nvl(afs.mrratioloan,0) mrratioloan_sys, nvl(afs.mrratioloan,0) mrratioloan_grp, nvl(afm.mrratioloan,0) mrratioloan_74
FROM
(
    SELECT cf.custodycd, se.afacctno, af.actype, sb.symbol codeid, sb.marginprice, sb.marginrefprice,
        sb.codeid codeid_num
    FROM semast se, afmast af, cfmast cf, securities_info sb
    WHERE af.custid = cf.custid AND se.afacctno = af.acctno AND se.codeid = sb.codeid
) af,
(
    SELECT afacctno, codeid,
        SUM(case when AFPR.restype = ''M'' then PRINUSED else 0 end) PRINUSED,
        SUM(case when AFPR.restype = ''S'' then PRINUSED else 0 end) SYPRINUSED
    FROM vw_afpralloc_all AFPR
    GROUP BY afacctno, codeid
) a,
(
    SELECT grp.afacctno, grp.codeid, sum(grp_prinused) grp_prinused
    FROM v_getsecprgrpinfo grp
    GROUP BY grp.afacctno, grp.codeid
) b,
afserisk afs,
afmrserisk afm
WHERE af.afacctno = a.afacctno(+) AND af.codeid_num = a.codeid(+)
    AND af.afacctno = b.afacctno(+) AND af.codeid_num = b.codeid(+)
    AND af.actype = afs.actype(+) AND af.codeid_num = afs.codeid(+)
    AND af.actype = afm.actype(+) AND af.codeid_num = afm.codeid(+)
    AND nvl(a.prinused,0) + nvl(a.syprinused,0) + nvl(b.grp_prinused,0) > 0','AFPRALLOC',null,null,null,null,50,'N',30,'NYNNYYYNNN','Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'MR0104';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (10,'GRPCALLMARGIN','Dư nợ nhóm','N','MR0104',20,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'In used','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (9,'SYSCALLMARGIN','Dư nợ hệ thống','N','MR0104',20,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'In used','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (8,'PRINCALLMARGIN','Dư nợ margin','N','MR0104',20,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'In used','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'GRP_PRINUSED','Room nhóm đã sử dụng','N','MR0104',20,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'In used','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'SYPRINUSED','Room hệ thống đã sử dụng','N','MR0104',20,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'In used','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'PRINUSED','Room margin đã sử dụng','N','MR0104',20,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'In used','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'CODEID','Mã chứng khoán','C','MR0104',3,null,'=,LIKE',null,'Y','Y','N',60,null,'Type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'AFACCTNO','Số tiểu khoản','C','MR0104',250,null,'=,LIKE','_','Y','Y','N',90,null,'Poom/Room Name','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'CUSTODYCD','Số TK lưu ký','C','MR0104',250,null,'=,LIKE','_','Y','Y','N',90,null,'Poom/Room Name','N',null,null,'N',null,null,null,'N');
COMMIT;
/
