--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'MRI023';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('MRI023','Quan ly han muc cap bao lanh cho tieu khoan','General view of allocated to account','
SELECT A.*, nvl(T0af.AFT0USED,0) AFT0USED,NVL(T0.CUSTT0USED,0) CUSTT0USED,least (A.T0CAL - A.ADVANCELINE ,A.T0LOANLIMIT - nvl(t0.CUSTT0USED,0)) T0REAL
    ,A.T0LOANLIMIT - NVL(T0.CUSTT0USED,0) CUSTT0REMAIN
    ,nvl(urlt.t0,0) - nvl(uflt.t0acclimit,0) urt0limitremain
    ,a.t0cal - a.advanceline T0Remain, 0 T0OVRQ, imp.t0limit t0amt
FROM (SELECT CF.CUSTID, CF.CUSTODYCD, AF.ACCTNO,CF.FULLNAME,cf.t0loanrate, AF.ADVANCELINE, CF.MRLOANLIMIT, CF.T0LOANLIMIT,af.CAREBY, af.actype, CF.CONTRACTCHK
    ,nvl((ci.balance - NVL(v_getbuy.secureamt,0)) + NVL(ADV.avladvance,0) + v_getsec.senavamt - (NVL(ln.marginamt,0) + NVL(ln.t0amt,0)),0) navamt
    ,nvl(v_getsec.SELIQAMT,0) SELIQAMT, NVL(ln.marginamt,0) + NVL(ln.t0amt,0) totalloan
    , setotal + (ci.balance - NVL(v_getbuy.secureamt,0)) + NVL(ADV.avladvance,0) setotal
    ,ROUND(least (nvl((ci.balance - NVL(v_getbuy.secureamt,0)) + NVL(ADV.avladvance,0) + v_getsec.senavamt - (NVL(ln.marginamt,0) + NVL(ln.t0amt,0)),0) * cf.t0loanrate /100, nvl(v_getsec.SELIQAMT,0) )) T0CAL
    ,GREATEST(0, NVL(NVL(ln.t0amt,0) - NVL(ci.balance +  NVL(v_getbuy.secureamt,0) + NVL(ADV.avladvance,0),0),0)) T0DEB
    ,buf.MARGINRATE
    FROM CFMAST CF, CIMAST CI, AFMAST AF,
        (select sum(aamt) aamt,sum(depoamt) avladvance,sum(paidamt) paidamt, sum(advamt) advanceamount,afacctno from v_getAccountAvlAdvance group by afacctno) adv
        ,( select trfacctno, trunc(sum(prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd),0) marginamt,
                     trunc(sum(oprinnml+oprinovd+ointnmlacr+ointdue+ointovdacr+ointnmlovd),0) t0amt,
                     trunc(sum(prinovd+intovdacr+intnmlovd+feeintovdacr+feeintnmlovd + nvl(ls.dueamt,0) + intdue + feeintdue),0) marginovdamt,
                     trunc(sum(oprinovd+ointovdacr+ointnmlovd),0) t0ovdamt
            from lnmast ln, lntype lnt,
                    (select acctno, sum(nml) dueamt from lnschd, (select * from sysvar where varname = ''CURRDATE'' and grname = ''SYSTEM'') sy
                     where reftype = ''P'' and overduedate = to_date(varvalue,''DD/MM/RRRR'') group by acctno) ls
            where ftype = ''AF'' and ln.actype = lnt.actype and ln.acctno = ls.acctno(+)
            group by ln.trfacctno
        ) ln
        , v_getbuyorderinfo v_getbuy
        , v_getsecmargininfo_ALL v_getsec
        , buf_ci_account buf
    WHERE AF.ACCTNO = CI.ACCTNO
        AND AF.CUSTID = CF.CUSTID (+)
        AND AF.ACCTNO = ADV.AFACCTNO (+)
        and af.acctno = v_getbuy.afacctno (+)
        and af.acctno = v_getsec.afacctno (+)
        and af.acctno = ln.trfacctno (+)
        and af.acctno = buf.afacctno(+)
        and cf.contractchk = ''Y''
    ) A
,(SELECT CUSTID, SUM(ADVANCELINE) TOTALADVLINE FROM AFMAST GROUP BY CUSTID) v_t0
, (select sum(acclimit) CUSTT0USED, af.CUSTID from useraflimit us, afmast af where af.acctno = us.acctno and us.typereceive = ''T0'' group by custid) T0
, (select sum(acclimit) AFT0USED, acctno from useraflimit us where us.typereceive = ''T0'' group by acctno) T0af
, (select tliduser,allocatelimmit,usedlimmit,acctlimit,t0,t0max from userlimit where TLIDUSER = ''<$TELLERID>'') urlt
,(select tliduser,sum(decode(typereceive,''T0'',acclimit, 0)) t0acclimit,sum(decode(typereceive,''MR'',acclimit, 0)) mracclimit  from useraflimit where typeallocate = ''Flex'' and TLIDUSER = ''<$TELLERID>'' group by tliduser
) uflt
, tlprofiles tlp
, TLGROUPS GRP
, t0aflimit_import imp
WHERE A.CUSTID = v_t0.custid (+)
AND A.custid = t0.custid (+)
and a.acctno = T0af.acctno(+)
and a.t0loanrate >=0 and a.acctno = imp.afacctno and imp.status = ''A''
and tlp.tlid = uflt.tliduser(+) and tlp.tlid = urlt.tliduser(+) and tlp.tlid = ''<$TELLERID>''
AND a.CAREBY = GRP.GRPID AND GRP.GRPTYPE = ''2''
AND a.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = ''<$TELLERID>'')
','MRTYPE',null,null,'1810',null,50,'N',30,'NYNNYYYNNN','Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'MRI023';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (29,'T0DEB','No BL chua tra','N','MRI023',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'T0DEB','N','43',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (27,'T0OVRQ','BL cap qua ly thuyet','N','MRI023',100,null,'<,<=,=,>=,>','#,##0','N','N','N',100,null,'T0OVRQ','N','42',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (25,'T0REMAIN','BL con lai (ly thuyet)','N','MRI023',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'T0REMAIN','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (24,'CONTRACTCHK','Hop dong khung','C','MRI023',100,null,'LIKE,=','#,##0','N','N','N',100,null,'CONTRACTCHK','N','86',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (23,'AFT0USED','Han muc da duoc cap cho TK','N','MRI023',100,null,'<,<=,=,>=,>','#,##0','N','N','N',100,null,'URT0LIMITREMAIN','N','13',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (19,'CUSTT0USED','Han muc da duoc cap cho KH','N','MRI023',100,null,'<,<=,=,>=,>','#,##0','N','N','N',100,null,'URT0LIMITREMAIN','N','11',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (17,'URT0LIMITREMAIN','HM con lai user','N','MRI023',100,null,'<,<=,=,>=,>','#,##0','N','N','N',100,null,'URT0LIMITREMAIN','N','12',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (13,'CUSTT0REMAIN','HM con lai cua KH','N','MRI023',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'CUSTT0REMAIN','N','16',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (12,'SELIQAMT','Gia tri thanh khoan','N','MRI023',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'SELIQAMT','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (11,'T0LOANRATE','Ty le cap bao lanh cua tieu khoan','N','MRI023',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'NAVAMT','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (10,'NAVAMT','Gia tri TS rong','N','MRI023',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'NAVAMT','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (9,'TOTALLOAN','Tong no','N','MRI023',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'TOTALLOAN','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (8,'SETOTAL','Tong tai san','N','MRI023',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'SETOTAL','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'MARGINRATE','Ty le Credit line thuc te','N','MRI023',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'MARGINRATE','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'ADVANCELINE','BL cap trong ngay','N','MRI023',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'ADVANCELINE','N','41',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'T0CAL','Bao lanh ly thuyet','N','MRI023',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'T0CAL','N','40',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'FULLNAME','Ho ten KH','C','MRI023',100,null,'=, LIKE',null,'Y','Y','N',80,null,'Custody code','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'T0AMT','Han muc cap','N','MRI023',100,null,'<,<=,=,>=,>','#,##0','Y','Y','N',100,null,'T0REAL','N','10',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'ACCTNO','So tieu khoan','C','MRI023',100,null,'<,<=,=,>=,>','#,##0','Y','Y','Y',80,null,'ACCTNO','N','03',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'CUSTODYCD','So TK luu ky','C','MRI023',100,null,'=, LIKE',null,'Y','Y','N',80,null,'Custody code','N','88',null,'N',null,null,null,'N');
COMMIT;
/
