﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'CF0100';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('CF0100','Màn hình tra soát – đánh dấu lỗi các deal bảo lãnh vi phạm','CF0100','
SELECT * FROM
(
    SELECT ol.autoid, ol.userid tlid, tl.tlname username, cf.custodycd, af.acctno afacctno,
        us.t0 t0limit, sum(CASE WHEN ol.t0amtpending = 0 THEN ol.t0amtused ELSE 0 END) t0limitexp, date0037 txdate,
        sum(CASE WHEN ol.t0amtpending = 0 THEN 0 ELSE ol.t0amtused END) t0limitapp, cf.fullname, (case when ol.status = ''E'' then ''Y'' else ''N'' END) status,
        ol.duedate, ol.period, tg.grpname, a1.cdcontent tltitle, rg.fullname broker
    FROM olndetail ol, cfmast cf, afmast af, tlprofiles tl, tlprofiles tl2, userlimit us, tlgroups tg, allcode a1, reaflnk re, recflnk rl, cfmast rg, retype ret,
        (SELECT DISTINCT ln.trfacctno, ls.rlsdate FROM lnschd ls, lnmast ln WHERE ln.acctno = ls.acctno AND ls.reftype = ''GP'' AND ls.mintermdate < getcurrdate) ls
    WHERE cf.custid = af.custid AND af.acctno = ol.acctno and ol.userid = us.tliduser AND af.careby = tg.grpid AND substr(re.reacctno,11,6) = ret.actype AND ret.rerole = ''BM''
        AND ol.userid = tl.tlid and ol.status in (''A'',''E'') AND ol.acctno = ls.trfacctno AND ol.duedate = ls.rlsdate
        AND ol.tlid = tl2.tlid(+) AND tl2.tltitle = a1.cdval(+) AND a1.cdname(+) = ''TLTITLE''
        AND ol.acctno = re.afacctno(+) AND substr(re.reacctno,1,10) = rl.custid AND rl.custid = rg.custid
        AND ol.duedate >= re.frdate(+) AND ol.duedate <= nvl(re.clstxdate-1,re.todate)
    GROUP BY ol.autoid, ol.userid, tl.tlname, cf.custodycd, a1.cdcontent, af.acctno, rg.fullname,
        us.t0, cf.fullname, case when ol.status = ''E'' then ''Y'' else ''N'' end, date0037, ol.duedate, ol.period, tg.grpname
)
WHERE t0limitexp+t0limitapp > 0
','CF0100','frmCF0100',null,'0037',null,50,'N',30,'NYNNYYYNNN','Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'CF0100';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (14,'BROKER','Môi giới quản lý','C','CF0100',100,null,'LIKE,=',null,'Y','Y','N',200,null,'FULLNAME','Y','07',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (13,'GRPNAME','Careby','C','CF0100',100,null,'LIKE,=',null,'Y','Y','N',200,null,'FULLNAME','Y','07',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (12,'TLTITLE','Cấp phê duyệt','C','CF0100',100,null,'LIKE,=',null,'Y','Y','N',200,null,'TLTITLE','Y',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (11,'PERIOD','Thời hạn cấp','C','CF0100',100,null,'LIKE,=',null,'Y','Y','N',200,null,'PERIOD','Y',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (10,'DUEDATE','Ngày tạo deal','D','CF0100',100,null,'<,<=,=,>=,>,<>','DD/MM/YYYY','Y','Y','N',100,null,'Val date','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (9,'STATUS','Trạng thái vi phạm','C','CF0100',100,null,'LIKE,=',null,'Y','Y','N',100,'SELECT CDVAL VALUE, CDVAL DISPLAY FROM ALLCODE WHERE CDTYPE = ''SY'' AND CDNAME = ''YESNO'' ORDER BY LSTODR','Status','Y','08',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (8,'TXDATE','Ngày đánh dấu gần nhất','D','CF0100',100,null,'<,<=,=,>=,>,<>','DD/MM/YYYY','Y','Y','N',100,null,'Val date','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'FULLNAME','Tên khách hàng','C','CF0100',100,null,'LIKE,=',null,'Y','Y','N',200,null,'FULLNAME','Y','07',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'T0LIMITAPP','Hạn mức BL sức mua phê duyệt đã cấp cho tiểu khoản','N','CF0100',100,null,'>=,<=,=','#,##0','Y','Y','N',200,null,'T0LIMITREMAIL','N','06',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'T0LIMITEXP','Hạn mức BL sức mua tự động đã cấp cho tiểu khoản','N','CF0100',100,null,'>=,<=,=','#,##0','Y','Y','N',200,null,'T0LIMITALL','N','05',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'T0LIMIT','Hạn mức BL của MG','N','CF0100',100,null,'>=,<=,=','#,##0','Y','Y','N',200,null,'T0LIMIT','N','04',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'AFACCTNO','Số tiểu khoản','C','CF0100',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Sub-account','N','03',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'CUSTODYCD','Số TK lưu ký','C','CF0100',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Custody code','N','88',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'USERNAME','Tên user','C','CF0100',100,null,'LIKE,=',null,'Y','Y','N',200,null,'FULLNAME','Y','02',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'TLID','Mã USER','C','CF0100',100,null,'LIKE,=',null,'Y','Y','N',80,null,'TLID','N','01',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (-1,'AUTOID','Mã quản lý','N','CF0100',100,null,'=,<>,<,<=,>=,>','#,##0','N','N','Y',100,null,'Auto ID','N','00',null,'N',null,null,null,'N');
COMMIT;
/
