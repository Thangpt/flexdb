--
--
/
DELETE search WHERE searchcode = 'CF0065';
insert into search (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE)
values ('CF0065', 'Danh sách khách hàng thỏa mãn kỳ đánh giá', 'List of customers satisfying the evaluation period', 'SELECT cfnav.refid, cf.custodycd, cf.fullname, cfnav.avlnav, tl.grpname careby, decode(af.lev, 0, '''', re.refullname) refullname, cf.brid
FROM cfnav, cfmast cf, tlgroups tl, (
   SELECT custid, afacctno, lev, MAX(lev) OVER (PARTITION BY custid) max_lev
   FROM (
      SELECT CASE WHEN aft.typename = ''MA'' THEN 2
                  WHEN aft.typename = ''SA'' THEN 1
                  ELSE 0
             END lev, af.custid, max(af.acctno) afacctno
      FROM afmast af, aftype aft 
      WHERE af.actype = aft.actype AND af.status <> ''C''
      GROUP BY af.custid, aft.typename
   ) 
) af, (
   SELECT re.afacctno, MAX(cf.fullname) refullname, re.reacctno
   FROM reaflnk re, sysvar sys, cfmast cf, retype
   WHERE to_date(varvalue, ''DD/MM/RRRR'') BETWEEN re.frdate AND re.todate
     AND SUBSTR(re.reacctno, 0, 10) = cf.custid
     AND varname = ''CURRDATE''
     AND grname = ''SYSTEM''
     AND re.status <> ''C''
     AND re.deltd <> ''Y''
     AND substr(re.reacctno, 11) = retype.actype
     AND rerole IN (''RM'', ''BM'')
   GROUP BY afacctno, reacctno
) re
WHERE cfnav.custid = cf.custid
  AND cf.careby = tl.grpid
  AND cf.custid = af.custid
  AND af.lev = af.max_lev
  AND af.afacctno = re.afacctno(+)
  AND CF.CAREBY IN (SELECT GRPID FROM TLGRPUSERS WHERE TLID = ''<$TELLERID>'')', 'CF0065', NULL, 'AVLNAV DESC', null, null, 50, 'N', 30, 'NNNNYYYNNN', 'Y', 'T');
COMMIT;
/
--
--
/
DELETE searchfld WHERE searchcode = 'CF0065';
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (0, 'REFID', 'Mã kỳ đánh giá', 'C', 'CF0065', 100, '9999', 'LIKE,=', '_', 'Y', 'Y', 'Y', 100, null, 'NAV Id', 'N', null, null, 'N', null, null, null, 'N');
INSERT into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (3, 'CUSTODYCD', 'Số tài khoản lưu ký', 'C', 'CF0065', 10, 'ccc.c.cccccc', 'LIKE,=', '_', 'Y', 'Y', 'N', 100, null, 'Custody code', 'N', null, null, 'N', null, null, null, 'N');
INSERT into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (6, 'FULLNAME', 'Tên khách hàng', 'C', 'CF0065', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 150, null, 'Customer name', 'N', null, null, 'N', null, null, null, 'N');
INSERT into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (9, 'AVLNAV', 'NAV trung bình', 'N', 'CF0065', 100, null, '<,<=,=,>=,>', '#,##0', 'Y', 'Y', 'N', 120, null, 'Avl nav', 'N', null, null, 'N', null, null, null, 'N');
INSERT into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (12, 'CAREBY', 'Nhóm careby', 'C', 'CF0065', 200, null, '=,LIKE', null, 'Y', 'Y', 'N', 150, null, 'Remiser name', 'N', null, null, 'N', null, null, null, 'N');
INSERT into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (15, 'REFULLNAME', 'Môi giới chăm sóc', 'C', 'CF0065', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 150, null, ' Re name', 'N', null, null, 'N', null, null, null, 'N');
INSERT into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (18, 'BRID', 'Chi nhánh', 'C', 'CF0065', 25, '9999', 'LIKE,=', '_', 'Y', 'Y', 'N', 80, 'SELECT BRID VALUE, BRID DISPLAY FROM BRGRP ORDER BY BRID', 'Branch', 'N', null, null, 'N', null, null, null, 'N');
COMMIT;
/
