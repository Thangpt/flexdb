--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'MR9001';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('MR9001','Danh sách tiểu khoản cần cấp bão lãnh trả chậm tối đa','View transfer buy management','select cf.custodycd, cf.fullname, af.acctno afacctno,
    round(case when af.trfbuyrate = 100 then
            greatest(least(cf.t0loanlimit - nvl(cflim.acclimit,0),
                nvl(ulim.t0max,0) - nvl(aflim.acclimit,0),
                nvl(ulim.t0,0) - nvl(ulim.acclimit,0),
                greatest(nvl(trft0amt_inday,0) - (af.advanceline - nvl(b.trft0amt,0)),0))
                ,0)
        else
            least(cf.t0loanlimit - nvl(cflim.acclimit,0),
                nvl(ulim.t0max,0) - nvl(aflim.acclimit,0),
                nvl(ulim.t0,0) - nvl(ulim.acclimit,0),
                round(greatest(least(af.mrcrlimitmax - dfodamt, nvl(sec.seamt,0) + af.mrcrlimit)
                                            + balance+nvl(avladvance,0)- ci.odamt - depofeeamt
                                            - nvl(b.trfsecuredamt,0) ,0)
                    ,0) * af.trfbuyrate / (100-af.trfbuyrate)
                    - (af.advanceline - nvl(b.trft0amt,0))
                )
        end,0) ADDADVANCELINE,
    least(nvl(ulim.t0max,0) - nvl(aflim.acclimit,0),
                nvl(ulim.t0,0) - nvl(ulim.acclimit,0) ) URT0LIMITREMAIN,
    nvl(aflim.acclimit,0) AFT0USED,
    nvl(cflim.acclimit,0) CUSTT0USED,
    (af.advanceline - nvl(b.trft0amt,0)) ADVANCELINE,
    cf.t0loanlimit,
    nvl(ulim.t0max,0) - nvl(aflim.acclimit,0) USERT0REMAIN,
    nvl(ulim.t0,0) - nvl(ulim.acclimit,0)  USERT0AFREMAIN,
        cf.t0loanlimit - nvl(cflim.acclimit,0) CUSTT0REMAIN,
        CF.CONTRACTCHK,
        CF.IDCODE,
        greatest(nvl(trft0amt_inday,0) - (af.advanceline - nvl(b.trft0amt,0)),0) T0NEED,
        ''Cap bao lanh toi da cho tieu khoan tra cham'' DESCRIPTION

from cimast ci, afmast af, cfmast cf, v_getbuyorderinfo b,
    v_getsecmargininfo sec,
    (select sum(depoamt) avladvance,afacctno from v_getAccountAvlAdvance_all group by afacctno) adv,
    (select acctno, sum(acclimit) acclimit from useraflimit where tliduser = ''<$TELLERID>'' and typereceive = ''T0'' group by acctno) aflim,
    (select custid, sum(acclimit) acclimit from useraflimit, afmast af where af.acctno = useraflimit.acctno and typereceive = ''T0'' group by custid) cflim,
    (select u.tliduser, u.t0, u.t0max, nvl(uused.acclimit,0) acclimit
        from userlimit u,
             (select tliduser, sum(acclimit) acclimit
                 from useraflimit
                 where tliduser = ''<$TELLERID>'' and typeallocate = ''Flex'' and typereceive = ''T0'' group by tliduser) uused
        where u.tliduser = ''<$TELLERID>'' and u.usertype = ''Flex''
        and u.tliduser = uused.tliduser(+)) ulim, TLGROUPS GRP, tlprofiles tlp,
    (select sts.afacctno,
            sum(case when sts.txdate <> to_date(sy.varvalue,''DD/MM/RRRR'') then sts.amt+od.feeacr-od.feeamt-trfexeamt -sts.trft0amt else 0 end) trfsecuredamt_in,
            sum(case when sts.txdate = to_date(sy.varvalue,''DD/MM/RRRR'') then sts.amt * sts.trfbuyrate/100 + sts.amt * (odt.deffeerate/100) else 0 end) trft0amt_inday
        from stschd sts, odmast od, odtype odt, (select * from sysvar where varname = ''CURRDATE'' and grname = ''SYSTEM'') sy
        where duetype = ''SM'' and sts.deltd <> ''Y'' and trfbuyrate*trfbuyext > 0 and trfbuysts <> ''Y''
        and sts.orgorderid = od.orderid and od.actype = odt.actype
        and trfbuydt <> to_date(sy.varvalue,''DD/MM/RRRR'')
        group by sts.afacctno) sts,
    vw_lngroup_all ln
WHERE ci.acctno=af.acctno
and cf.custid = af.custid
and (af.trfbuyrate * af.trfbuyext > 0 or nvl(trft0amt_inday,0) > 0)
and af.acctno = b.afacctno(+)
and af.acctno = adv.afacctno(+)
and af.acctno = aflim.acctno(+)
and cf.custid = cflim.custid(+)
and af.acctno = sec.afacctno(+)
and af.acctno = ln.trfacctno(+)
and af.acctno = sts.afacctno(+)
and tlp.tlid = ulim.tliduser(+)
AND AF.CAREBY = GRP.GRPID AND GRP.GRPTYPE = ''2''
and tlp.tlid = ''<$TELLERID>''
AND (SUBSTR(CF.CUSTID,1,4) = DECODE(''<$BRID>'', ''<$HO_BRID>'', SUBSTR(CF.CUSTID,1,4), ''<$BRID>'')
    OR AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = ''<$TELLERID>''))','MRTYPE',null,null,'1810',null,50,'N',30,'NYNNYYYNNN','Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'MR9001';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (14,'IDCODE','Chứng minh thư','C','MR9001',100,null,'LIKE,=','#,##0','N','N','N',100,null,'IDCODE','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (13,'DESCRIPTION','Mô tả','C','MR9001',100,null,'LIKE,=','#,##0','Y','Y','N',100,null,'DESCRIPTION','N','30',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (12,'CONTRACTCHK','Hợp đồng khung','C','MR9001',100,null,'LIKE,=','#,##0','N','N','N',100,null,'CONTRACTCHK','N','86',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (11,'USERT0AFREMAIN','Hạn mức tối đa user cấp cho TK','N','MR9001',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'available release limit','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (10,'T0LOANLIMIT','Hạn mức T0 tối đa của KH','N','MR9001',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'available release limit','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (9,'ADVANCELINE','Hạn mức T0 TK đã cấp trong ngày','N','MR9001',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'available release limit','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (8,'CUSTT0REMAIN','Hạn mức còn lại của KH','N','MR9001',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'available release limit','N','16',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'AFT0USED','HM đã cấp cho TK','N','MR9001',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'available release limit','N','13',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'CUSTT0USED','HM đã cấp cho KH','N','MR9001',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'available release limit','N','11',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'URT0LIMITREMAIN','Hạn mức còn lại của User','N','MR9001',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'available release limit','N','12',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'T0NEED','Ký quỹ trả chậm chưa cấp','N','MR9001',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'mrcrlimitmax','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'ADDADVANCELINE','Hạn mức cấp ','N','MR9001',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'mrcrlimitmax','N','10',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'FULLNAME','Họ tên KH','C','MR9001',100,null,'=, LIKE',null,'Y','Y','N',80,null,'Custody code','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'AFACCTNO','Số tiểu khoản','C','MR9001',100,null,'=, LIKE','#,##0','Y','Y','N',80,null,'CUSTID','N','03',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'CUSTODYCD','Số TK lưu ký','C','MR9001',100,null,'=, LIKE',null,'Y','Y','N',80,null,'Custody code','N','88',null,'N',null,null,null,'N');
COMMIT;
/
