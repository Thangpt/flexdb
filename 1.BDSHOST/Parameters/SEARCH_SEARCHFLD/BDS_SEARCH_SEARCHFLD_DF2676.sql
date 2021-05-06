--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'DF2676';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('DF2676','View danh sách tiểu khoản margin','DF Deal margin account','select cf.custodycd, cf.fullname, cf.idcode, af.acctno afacctno,
-(ci.balance - nvl(b.secureamt,0) - nvl(b.overamt,0) + nvl(adv.avladvance,0)) outstanding,
dft.actype dftype, df.dfamt
from cfmast cf, afmast af,cimast ci, aftype aft, mrtype mrt, afidtype afid, dftype dft,
v_getbuyorderinfo b,
(select sum(depoamt) avladvance,afacctno from v_getAccountAvlAdvance group by afacctno) adv,
(select se.afacctno, dft.actype dftype,
    sum(case when dfbk.dealtype = ''N'' then (trade - nvl(execsellqtty,0) - nvl(od.remainsellqtty,0)) *
                (case when dfbk.DFPRICE <=0 then round((case when dfbk.REFPRICE<=0 then sb.BASICPRICE else least(dfbk.REFPRICE,sb.BASICPRICE) end)* dfbk.dfrate/100,0) else least(dfbk.DFPRICE,sb.BASICPRICE*dfbk.dfrate/100) end)
            when dfbk.dealtype = ''R'' then nvl(execbuyqtty,0) *
                (case when dfbk.DFPRICE <=0 then round((case when dfbk.REFPRICE<=0 then sb.BASICPRICE else least(dfbk.REFPRICE,sb.BASICPRICE) end)* dfbk.dfrate/100,0) else least(dfbk.DFPRICE,sb.BASICPRICE*dfbk.dfrate/100) end)
            when dfbk.dealtype = ''B'' then se.blocked *
                (case when dfbk.DFPRICE <=0 then round((case when dfbk.REFPRICE<=0 then sb.BASICPRICE else least(dfbk.REFPRICE,sb.BASICPRICE) end)* dfbk.dfrate/100,0) else least(dfbk.DFPRICE,sb.BASICPRICE*dfbk.dfrate/100) end)
        else 0 end) dfamt
from afmast af, afidtype afid, dftype dft, dfbasket dfbk, semast se, securities_info sb,
   (select afacctno, codeid,
        sum(case when duetype = ''SS'' then qtty - decode(status,''C'',qtty,aqtty) else 0 end) execsellqtty,
        sum(case when duetype = ''RS'' then qtty - decode(status,''C'',qtty,aqtty) else 0 end) execbuyqtty
   from stschd
   where duetype in (''SS'',''RS'')and deltd <> ''Y''
   group by afacctno, codeid) sts,
   (select afacctno, codeid,
       sum(remainqtty) remainsellqtty
       from odmast
       where exectype in (''NS'',''MS'')and deltd <> ''Y''
       group by afacctno, codeid) od
where se.afacctno = sts.afacctno (+) and se.codeid = sts.codeid (+)
and se.afacctno = od.afacctno (+) and se.codeid = od.codeid (+)
and af.acctno = se.afacctno
and af.actype = afid.aftype and afid.actype = dft.actype and afid.objname = ''DF.DFTYPE'' and dft.dfgroup = ''Y''
and dft.basketid = dfbk.basketid and dfbk.symbol = sb.symbol and sb.codeid = se.codeid
group by se.afacctno, dft.actype) df
where cf.custid = af.custid and af.acctno = ci.afacctno
and af.actype = aft.actype and aft.mrtype = mrt.actype and mrt.mrtype = ''T''
and aft.actype = afid.aftype and dft.actype = afid.actype and afid.objname = ''DF.DFTYPE''
and dft.dfgroup = ''Y'' and af.corebank <> ''Y''
and af.acctno = b.afacctno (+) and af.acctno = adv.afacctno(+)
and dft.rrtype = ''B'' and dft.custbank = ''<$CUSTBANK>''
and af.acctno = df.afacctno and dft.actype = df.dftype
and (ci.balance - nvl(b.secureamt,0) - nvl(b.overamt,0) + nvl(adv.avladvance,0)) < 0
and dft.actype = ''<$DFTYPE>''
and 0=0','DFMAST',null,null,'2676',null,50,'N',30,'NYNNYYYNNN','Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'DF2676';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'DFTYPE','Loại hình deal','C','DF2676',100,null,'=',null,'Y','N','N',100,'SELECT TYPENAME VALUE, TYPENAME DISPLAY FROM DFTYPE ORDER BY TYPENAME','DF Name','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'DFAMT','Số có thể phát vay','N','DF2676',100,null,'<,<=,=,>=,>,<>','#,##0.###0','Y','N','N',100,null,'DF Rate','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'OUTSTANDING','Dư nợ hiện tại','N','DF2676',100,null,'<,<=,=,>=,>,<>','#,##0.###0','Y','N','N',100,null,'DF Rate','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'AFACCTNO','Số tiểu khoản','C','DF2676',18,null,'LIKE,=','_','Y','N','N',100,null,'LN Account number','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'FULLNAME','Tên khách hàng','C','DF2676',18,null,'LIKE,=','_','Y','Y','Y',100,null,'DF Account number','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'CUSTODYCD','TK Lưu ký','C','DF2676',100,null,'LIKE,=','_','Y','Y','N',100,null,'Custody CD','N',null,null,'N',null,null,null,'N');
COMMIT;
/
