--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'LN5569';
insert into search (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE)
values ('LN5569', 'Thanh lý tài khoản vay', 'Customer loan account management', 'select cf.custodycd, af.acctno afacctno, ln.actype olntype, lnt.typename,ln.actype OLNTYPE_TK,
case when ls.reftype = ''GP'' then ''Bảo lãnh''
    when ls.reftype = ''P'' and ln.ftype = ''AF'' then ''Credit line''
    else '''' end LoanType, fn_getREDRAWDOWNDATE(ls.autoid) INTDAY,
case when ln.rrtype = ''C'' then ''Công ty'' else nvl(cfm.shortname,'''') end RRTYPE,
ROUND(ls.nml+ls.ovd+ls.paid) rlsamt,
round(ls.nml+ls.ovd,0) odprin, round(ls.nml+ls.ovd,0) odprin_tl,
decode (lnt.CHKSYSCTRL,''Y'',''Có'',''N'',''Không'') CHKSYSCTRL,LS.RLSDATE,LS.OVERDUEDATE DUEDATE,
--round(ls.intovd+ls.intovdprin,0)+round(ls.feeintovdacr+ls.feeintnmlovd,0) odint,
--round(ls.intovd+ls.intovdprin,0)+round(ls.feeintovdacr+ls.feeintnmlovd,0) odint_tl,
round(ls.feeintovdacr,0)  odint, round(ls.feeintovdacr,0) odint_tl,
round(ls.intnmlacr+ls.intdue+ls.intovd+ls.intovdprin,0) intamt,
round(ls.intnmlacr+ls.intdue+ls.intovd+ls.intovdprin,0) intamt_tl,
round(ls.feeintnmlacr+ls.feeintdue+ls.feeintnmlovd,0) feeintamt,
round(ls.feeintnmlacr+ls.feeintdue+ls.feeintnmlovd,0) feeintamt_tl,
round(ls.feeintovdacr,0) feeintovdacr,ls.intnmlacrbank,
ls.nml+ls.ovd+round(ls.intnmlacr+ls.intdue+ls.intovd+ls.intovdprin,0)+round(ls.feeintnmlacr+ls.feeintdue+ls.feeintovdacr+ls.feeintnmlovd,0) odamt,
ls.nml+ls.ovd+round(ls.intnmlacr+ls.intdue+ls.intovd+ls.intovdprin,0)+round(ls.feeintnmlacr+ls.feeintdue+ls.feeintovdacr+ls.feeintnmlovd,0) odamt_tk,
ls.autoid lnschdid, ls.acctno lnacctno,
nvl(greatest(getbaldeftrfamtex( af.ACCTNO),getbaldefovd( af.ACCTNO)),0) AVLBAL,
case WHEN ls.reftype <> ''P'' AND LS.OVERDUEDATE > GETCURRDATE then ''T0''
     WHEN ls.reftype <> ''P'' AND LS.OVERDUEDATE <= GETCURRDATE then ''T1''
     WHEN ls.reftype = ''P'' AND NVL(lnt.chksysctrl,''N'') =''Y'' AND LS.OVERDUEDATE > GETCURRDATE THEN  ''U0''
     WHEN ls.reftype = ''P'' AND NVL(lnt.chksysctrl,''N'') =''Y'' AND LS.OVERDUEDATE <= GETCURRDATE THEN  ''U1''
     WHEN ls.reftype = ''P'' AND NVL(lnt.chksysctrl,''N'') <> ''Y'' AND LS.OVERDUEDATE > GETCURRDATE THEN  ''M0''
     ELSE ''M1'' end reftype,GRP.GRPNAME CAREBY,RE.REFULLNAME,aft.actype ||''-''|| aft.typename aftypename, af.careby carebyid,aft.description ,nvl(a.RATE2A,0) IMPRATE2,a.FDATE, a.TDATE
from cfmast cf, afmast af left join
(
SELECT TXDATE, CUSTODYCD, AFACCTNO,RATE1A, RATE2A, RATE3A, FDATE, TDATE FROM TBLINTCHANGEHIST

 WHERE CUSTODYCD||TXDATE IN(
SELECT DISTINCT CUSTODYCD||MAX(TXDATE)  FROM TBLINTCHANGEHIST
  WHERE STATUS <>''C''
GROUP BY CUSTODYCD
)
AND STATUS <>''C''
AND SYSDATE BETWEEN FDATE AND TDATE) A ON A.AFACCTNO =AF.ACCTNO
,(select af.acctno,re.*
from (select re.afacctno, MAX(cf.fullname) refullname,re.reacctno
 from reaflnk re, sysvar sys, cfmast cf,RETYPE
 where to_date(varvalue,''DD/MM/RRRR'') between re.frdate and re.todate
 and substr(re.reacctno,0,10) = cf.custid
 and varname = ''CURRDATE'' and grname = ''SYSTEM''
 and re.status <> ''C'' and re.deltd <> ''Y''
 AND substr(re.reacctno,11) = RETYPE.ACTYPE
 AND rerole IN ( ''RM'',''BM'')
 GROUP BY AFACCTNO, reacctno
) re,afmast af where af.acctno=re.afacctno(+) ) re,AFTYPE AFT, TLGROUPS GRP,
lnmast ln, lnschd ls,
lntype lnt left join cfmast cfm on lnt.custbank =
cfm.custid
where ln.acctno = ls.acctno
AND AF.ACCTNO = re.acctno
AND AFT.ACTYPE = AF.ACTYPE
AND AF.CAREBY = GRP.GRPID AND GRP.GRPTYPE = ''2''
and ls.reftype in (''P'',''GP'') and ln.ftype = ''AF''
and ln.prinnml+ln.prinovd+ln.intnmlacr+ln.intdue+ln.intovdacr+ln.intnmlovd+ln.feeintnmlacr
+ln.feeintdue+ln.feeintovdacr+ln.feeintnmlovd
    +ln.oprinnml+ln.oprinovd+ln.ointnmlacr+ln.ointdue+ln.ointovdacr+ln.ointnmlovd> 0
and cf.custid = af.custid and af.acctno = ln.trfacctno and ln.acctno = ls.acctno and ln.actype =lnt.actype', 'LN5569', 'frmLNMAST', null, '5569', null, 50, 'N', 0, 'NYNNYYYNNN', 'Y', 'T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'LN5569';
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (0, 'LNSCHDID', 'Mã hiệu lịch vay', 'C', 'LN5569', 60, null, 'LIKE,=', '_', 'Y', 'Y', 'Y', 100, null, 'Product type', 'N', '01', null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (2, 'CUSTODYCD', 'Số TK lưu ký', 'C', 'LN5569', 100, null, 'LIKE,=', '_', 'Y', 'Y', 'N', 100, null, 'Product type', 'N', '88', null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (4, 'AFACCTNO', 'Số tiểu khoản', 'C', 'LN5569', 100, null, 'LIKE,=', '_', 'Y', 'Y', 'N', 100, null, 'Product type', 'N', '05', null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (5, 'AFTYPENAME', 'Tên tiểu khoản', 'C', 'LN5569', 150, null, 'LIKE,=', '_', 'Y', 'Y', 'N', 100, null, 'Product type', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (7, 'CAREBY', 'Nhóm careby', 'C', 'LN5569', 10, null, 'LIKE,=', '_', 'Y', 'Y', 'N', 100, null, 'Product type', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (8, 'REFULLNAME', 'Môi giới QL', 'C', 'LN5569', 200, null, 'LIKE,=', '_', 'Y', 'Y', 'N', 150, null, 'Product type', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (9, 'LNACCTNO', 'Số tiểu khoản vay', 'C', 'LN5569', 100, null, 'LIKE,=', '_', 'Y', 'Y', 'N', 100, null, 'Product type', 'N', '03', null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (10, 'REFTYPE', 'Loai vay', 'C', 'LN5569', 150, null, 'LIKE,=', null, 'Y', 'N', 'N', 100, null, 'Loai vay', 'N', '07', null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (11, 'LOANTYPE', 'Loại vay', 'C', 'LN5569', 150, null, 'LIKE,=', null, 'Y', 'N', 'N', 100, null, 'Loại vay', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (12, 'TYPENAME', 'Tên loại hình vay', 'C', 'LN5569', 300, null, 'LIKE,=', null, 'Y', 'N', 'N', 200, null, 'Loại vay', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (13, 'CHKSYSCTRL', 'Tuân thủ', 'C', 'LN5569', 150, null, 'LIKE,=', null, 'Y', 'N', 'N', 100, null, 'Tuân thủ', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (14, 'RLSDATE', 'Ngày giải ngân', 'D', 'LN5569', 100, '__/__/____', '<,<=,=,>=,>,<>', '##/##/####', 'Y', 'Y', 'N', 100, null, 'Release date', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (15, 'DUEDATE', 'Ngày đến hạn', 'D', 'LN5569', 100, '__/__/____', '<,<=,=,>=,>,<>', '##/##/####', 'Y', 'Y', 'N', 100, null, 'Due date', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (16, 'RRTYPE', 'Nguồn', 'C', 'LN5569', 150, null, 'LIKE,=', null, 'Y', 'N', 'N', 100, null, 'Loan amount', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (18, 'RLSAMT', 'Số tiền giải ngân', 'N', 'LN5569', 120, null, '<,<=,=,>=,>,<>', '#,##0', 'Y', 'N', 'N', 100, null, 'Release amount', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (20, 'ODAMT', 'Tổng dư nợ món vay', 'N', 'LN5569', 120, null, '<,<=,=,>=,>,<>', '#,##0', 'Y', 'N', 'N', 100, null, 'Loan amount', 'N', '10', null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (22, 'ODPRIN', 'Số dư nợ gốc món vay', 'N', 'LN5569', 120, null, '<,<=,=,>=,>,<>', '#,##0', 'Y', 'N', 'N', 100, null, 'Loan amount', 'N', '21', null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (22, 'ODPRIN_TL', 'Số dư nợ gốc món vay thanh lý', 'N', 'LN5569', 120, null, '<,<=,=,>=,>,<>', '#,##0', 'N', 'N', 'N', 100, null, 'Loan amount', 'N', '31', null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (26, 'INTAMT', 'Số dư nợ lãi món vay', 'N', 'LN5569', 120, null, '<,<=,=,>=,>,<>', '#,##0', 'Y', 'N', 'N', 100, null, 'Loan amount', 'N', '22', null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (26, 'INTAMT_TL', 'Số dư nợ lãi món vay thanh lý', 'N', 'LN5569', 120, null, '<,<=,=,>=,>,<>', '#,##0', 'N', 'N', 'N', 100, null, 'Loan amount', 'N', '32', null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (28, 'FEEINTAMT_TL', 'Số dư nợ phí món vay thanh lý', 'N', 'LN5569', 120, null, '<,<=,=,>=,>,<>', '#,##0', 'N', 'N', 'N', 100, null, 'Loan amount', 'N', '33', null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (28, 'FEEINTAMT', 'Số dư nợ phí món vay', 'N', 'LN5569', 120, null, '<,<=,=,>=,>,<>', '#,##0', 'Y', 'N', 'N', 100, null, 'Loan amount', 'N', '23', null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (29, 'ODINT_TL', 'Số dư nợ lãi/phí quá hạn thanh lý', 'N', 'LN5569', 120, null, '<,<=,=,>=,>,<>', '#,##0', 'N', 'N', 'N', 100, null, 'Loan amount', 'N', '34', null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (29, 'ODINT', 'Số dư nợ lãi/phí quá hạn', 'N', 'LN5569', 120, null, '<,<=,=,>=,>,<>', '#,##0', 'N', 'N', 'N', 100, null, 'Loan amount', 'N', '24', null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (29, 'INTNMLACRBANK', 'Số dư nợ lãi trả hộ', 'N', 'LN5569', 120, null, '<,<=,=,>=,>,<>', '#,##0', 'Y', 'N', 'N', 100, null, null, 'N', '86', null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (30, 'OLNTYPE_TK', 'LH vay', 'C', 'LN5569', 60, null, 'LIKE,=', null, 'N', 'N', 'N', 100, null, 'Loan amount', 'N', '06', null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (30, 'OLNTYPE', 'LH vay', 'C', 'LN5569', 60, null, 'LIKE,=', null, 'Y', 'N', 'N', 100, null, 'Loan amount', 'N', '02', null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (32, 'INTDAY', 'Số ngày vay', 'N', 'LN5569', 120, null, '<,<=,=,>=,>,<>', '#,##0', 'Y', 'N', 'N', 100, null, 'Loan amount', 'N', '90', null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (34, 'AVLBAL', 'Số dư tiền khả dụng', 'N', 'LN5569', 120, null, '<,<=,=,>=,>,<>', '#,##0', 'N', 'N', 'N', 100, null, 'Margin amount', 'N', '35', null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (6, 'DESCRIPTION', 'Tên loại hình', 'C', 'LN5569', 200, null, 'LIKE,=', null, 'Y', 'Y', 'N', 150, null, 'Margin amount', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (36, 'IMPRATE2', 'IMPRATE2', 'N', 'LN5569', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'Margin amount', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (37, 'FDATE', 'Từ ngày', 'D', 'LN5569', 100, '__/__/____', '<,<=,=,>=,>,<>', null, 'Y', 'Y', 'N', 100, null, 'Transaction Date', 'N', null, null, 'N', null, null, null, 'N');

insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (38, 'TDATE', 'Ðến ngày', 'D', 'LN5569', 100, null, '<,<=,=,>=,>,<>', null, 'Y', 'Y', 'N', 100, null, 'Transaction Date', 'N', null, null, 'N', null, null, null, 'N');
COMMIT;
/
