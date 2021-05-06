--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'SECURITIES_RISK';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('SECURITIES_RISK','Tham số hệ thống chứng khoán ký quỹ tài khoản','Securities system parameter for credit line','SELECT SB.SYMBOL, A.CODEID,A.MRMAXQTTY,A.MRRATIORATE,A.MRRATIOLOAN,A.MRPRICERATE,A.MRPRICELOAN,A.MRMAXQTTY- nvl(od.seqtty,0) AVLMRQTTY, c1.cdcontent ISMARGINALLOW
FROM SECURITIES_RISK A, SBSECURITIES SB,ALLCODE C1,
     (select se.symbol,se.seqtty + nvl(od.seqtty,0) seqtty from
    (select sb.symbol,sum (se.trade+se.receiving) seqtty
    from semast se, afmast af, aftype aft, mrtype mrt,sbsecurities sb,
    (SELECT ln.trfacctno,
                             SUM(ls.nml + ls.intnmlacr + ls.fee + ls.intdue +
                                  ls.feedue + ls.ovd + ls.intovd + ls.intovdprin +
                                  ls.feeovd) debt
                        FROM lnschd ls, lnmast ln
                       WHERE ln.acctno = ls.acctno
                       GROUP BY ln.trfacctno) ls, cimast ci
  where se.afacctno =af.acctno and af.actype =aft.actype
    and aft.mrtype =mrt.actype and mrt.mrtype in (''S'',''T'')
    and se.codeid=sb.codeid
     AND ls.trfacctno = af.acctno
                AND af.acctno = ci.acctno
                AND (ls.debt - (ci.balance + ci.receiving)) > 0
    group by sb.symbol) se
    left join
     (select sb.symbol,sum(case when od.exectype in (''NS'',''MS'') then (case when od.ORSTATUS<>''2'' then -execqtty else -execqtty-remainqtty end )  when od.exectype in (''NB'',''BC'') then remainqtty + execqtty else 0 end) seqtty
     from odmast od, afmast af, aftype aft, mrtype mrt,sbsecurities sb,
     (SELECT ln.trfacctno,
                                 SUM(ls.nml + ls.intnmlacr + ls.fee +
                                      ls.intdue + ls.feedue + ls.ovd +
                                      ls.intovd + ls.intovdprin + ls.feeovd) debt
                            FROM lnschd ls, lnmast ln
                           WHERE ln.acctno = ls.acctno
                           GROUP BY ln.trfacctno) ls, cimast ci
  where od.afacctno =af.acctno and af.actype =aft.actype
  AND od.txdate = (select to_date(VARVALUE,''DD/MM/YYYY'') from sysvar where grname=''SYSTEM'' and varname=''CURRDATE'')
    and aft.mrtype =mrt.actype and mrt.mrtype <>''N'' and od.deltd <> ''Y''
    and od.codeid=sb.codeid
    AND ls.trfacctno = af.acctno
                    AND af.acctno = ci.acctno
                    AND (ls.debt - (ci.balance + ci.receiving)) > 0
    group by sb.symbol) od
    on se.symbol= od.symbol) od
WHERE A.CODEID=SB.CODEID and c1.cdtype = ''SY'' and c1.cdname = ''YESNO'' and c1.cdval = A.ISMARGINALLOW
and SB.symbol= od.symbol (+) AND 0=0','SECURITIES_RISK','frmSECURITIES_RISK',null,null,null,50,'N',30,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'SECURITIES_RISK';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'ISMARGINALLOW','Được margin UBCK','C','SECURITIES_RISK',100,null,'LIKE,=','#,##0','Y','Y','N',100,'SELECT CDVAL VALUECD, CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE=''SY'' AND CDNAME= ''YESNO'' AND CDUSER = ''Y'' ORDER BY LSTODR','Is margin allow','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'MRPRICELOAN','Giá vay','N','SECURITIES_RISK',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Margin loan price','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'MRPRICERATE','Giá ký quỹ','N','SECURITIES_RISK',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Margin price','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'AVLMRQTTY','KL còn lại','N','SECURITIES_RISK',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Available argin quantity','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'MRMAXQTTY','KL tối đa','N','SECURITIES_RISK',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Maximum argin quantity','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'SYMBOL','Chứng khoán','C','SECURITIES_RISK',100,null,'LIKE,=',null,'Y','Y','N',70,null,'Symbol','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'CODEID','Chứng khoán','C','SECURITIES_RISK',100,null,'LIKE,=',null,'N','N','Y',70,null,'Symbol','N',null,null,'N',null,null,null,'N');
COMMIT;
/
