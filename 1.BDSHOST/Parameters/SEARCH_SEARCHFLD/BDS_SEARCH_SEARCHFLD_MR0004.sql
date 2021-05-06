--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'MR0004';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('MR0004','Tra cứu hạn mức vay theo tiểu khoản','View sub account margin limit','select cf.custodycd, af.acctno,cf.fullname ,cf.mrloanlimit, cf.t0loanlimit,
    af.mrcrlimitmax, round(ci.dfodamt) dfodamt,
        round(af.mrcrlimitmax - ci.dfodamt - nvl(mramt,0)) mrcrlimitremain,
        nvl(T0af.AFT0USED,0) AFT0USED,
    round(af.advanceline - nvl(b.trft0amt,0)) advanceline,
    round(cf.mrloanlimit)-ROUND(nvl(MR.CUSTMRUSED,0)) avlmrloanlimit,round(cf.t0loanlimit)-ROUND(nvl(T0.CUSTT0USED,0)) avlt0loanlimit,
    round(nvl(dfamt,0)) dfamt, round(nvl(dfprinamt,0)) dfprinamt, round(nvl(dfintamt,0)) dfintamt,
    round(nvl(mramt,0)) mramt, round(nvl(mrprinamt,0)) mrprinamt, round(nvl(mrintamt,0)) mrintamt,
    round(nvl(ln.t0amt,0)) t0amt
from afmast af, cfmast cf, cimast ci, aftype aft, mrtype mrt,
v_getbuyorderinfo b,
(select sum(acclimit) CUSTT0USED, af.CUSTID from useraflimit us, afmast af where af.acctno = us.acctno and us.typereceive = ''T0'' group by custid) T0,
(select sum(acclimit) AFT0USED, acctno from useraflimit us where us.typereceive = ''T0'' group by acctno) T0af,
(select sum(mrcrlimitmax) CUSTMRUSED, CUSTID from afmast group by custid) MR,
(select trfacctno,
        sum(decode(ftype,''DF'',1,0)*(prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd)) dfamt,
        sum(decode(ftype,''DF'',1,0)*(prinnml+prinovd)) dfprinamt,
        sum(decode(ftype,''DF'',1,0)*(intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd)) dfintamt,
        sum(decode(ftype,''AF'',1,0)*(prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd)) mramt,
        sum(decode(ftype,''AF'',1,0)*(prinnml+prinovd)) mrprinamt,
        sum(decode(ftype,''AF'',1,0)*(intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd)) mrintamt,
        sum(decode(ftype,''AF'',1,0)*(oprinnml+oprinovd+ointnmlacr+ointdue+ointovdacr+ointnmlovd)) t0amt
    from lnmast
    group by trfacctno) ln
where af.custid=cf.custid
and af.acctno = ci.acctno
and af.actype =aft.actype
and aft.mrtype =mrt.actype
and af.acctno = T0af.acctno(+)
and cf.custid = T0.custid(+)
and cf.custid = MR.custid(+)
and af.acctno = b.afacctno(+)
and af.acctno = ln.trfacctno(+)','MRTYPE',null,null,null,null,50,'N',30,'NYNNYYYNNN','Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'MR0004';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (70,'T0AMT','Nợ bảo lãnh (gốc, lãi)','N','MR0004',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',120,null,'Available margin limit','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (65,'MRINTAMT','Nợ lãi margin','N','MR0004',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',120,null,'Available margin limit','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (60,'MRPRINAMT','Nợ gốc margin','N','MR0004',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',120,null,'Available margin limit','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (55,'MRAMT','Nợ CL (gốc, lãi)','N','MR0004',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',120,null,'Available margin limit','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (50,'DFINTAMT','Nợ lãi DF','N','MR0004',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',120,null,'Available margin limit','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (45,'DFPRINAMT','Nợ gốc DF','N','MR0004',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',120,null,'Available margin limit','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (40,'DFAMT','Nợ DF (gốc, lãi)','N','MR0004',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',120,null,'Available margin limit','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (35,'AVLT0LOANLIMIT','Hạn mức bảo lãnh KH còn lại','N','MR0004',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',120,null,'Available margin limit','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (30,'AVLMRLOANLIMIT','Hạn mức margin KH còn lại','N','MR0004',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',120,null,'Available margin limit','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (25,'ADVANCELINE','Bảo lãnh được cấp trong ngày','N','MR0004',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',120,null,'Allocated T0','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (24,'AFT0USED','Bảo lãnh đã cấp','N','MR0004',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',120,null,'Available margin limit','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (22,'MRCRLIMITREMAIN','Hạn mức margin còn lại','N','MR0004',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',120,null,'Remain margin limit','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (21,'DFODAMT','Hạn mức DF đã dùng','N','MR0004',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',120,null,'DF amount','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (20,'MRCRLIMITMAX','Hạn mức margin được cấp','N','MR0004',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',120,null,'Allocated margin limit','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (15,'T0LOANLIMIT','Hạn mức bảo lãnh khách hàng','N','MR0004',200,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',120,null,'Customer margin limit','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (10,'MRLOANLIMIT','Hạn mức MR khách hàng','N','MR0004',200,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',120,null,'Customer margin limit','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'FULLNAME','Tên khách hàng','C','MR0004',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Customer name','Y',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'ACCTNO','Số tiểu khoản','C','MR0004',100,null,'LIKE,=','_','Y','Y','Y',100,null,'Customer ID','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (-100,'CUSTODYCD','Số TK lưu ký','C','MR0004',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Custody code','N','88',null,'N',null,null,null,'N');
COMMIT;
/
