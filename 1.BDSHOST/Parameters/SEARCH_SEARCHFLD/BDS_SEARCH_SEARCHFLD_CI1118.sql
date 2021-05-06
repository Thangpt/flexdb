--
--
--1.6.0.0 them cac cot: người phê duyệt,tiền ứng còn lại, tiền chuyển còn lại.
/
DELETE search WHERE searchcode = 'CI1118';
insert into search (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE)
values ('CI1118', 'Danh sách các yêu cầu chuyển tiền ra ngân hàng chờ duyệt', 'List of bank transfer requests waiting for approval', 'select A.CUSTODYCD, A.AFACCTNO, A.FULLNAME, A.AMOUNT, A.ADVAMT, A.CASHAMT,
     A.TOTALADVAMT, A.TOTALCASHAMT,A.TOTALCASHAMTEXT, A.AUTOID, tl.tlid, tl.tlname, NVL(tl.readvancelimit,0) READVANCE,
     NVL(tl.retotaltranlimit,0) RETRANFER, A.STATUS, A.APRVID, A.BENEFACCT, A.BENEFCUSTNAME
FROM (
   SELECT cf.brid, CF.CUSTODYCD, REQ.AFACCTNO, CF.FULLNAME, REQ.AMOUNT, REQ.ADVAMT, REQ.CASHAMT,
          REQ.CURADVAMT TOTALADVAMT, REQ.CURCASHAMT TOTALCASHAMT, REQ.AUTOID, REQ.Status, req.aprvid, REQ.BENEFACCT,
          REQ.BENEFCUSTNAME, REQ.CURCASHAMTEXT TOTALCASHAMTEXT
   FROM EXTRANFERREQ REQ, CFMAST CF, AFMAST AF
   WHERE REQ.AFACCTNO = AF.ACCTNO
     AND AF.CUSTID = CF.CUSTID
     AND REQ.STATUS = ''P''
     AND REQ.TXDATE = TO_DATE(''<$BUSDATE>'',''DD/MM/RRRR'')
     AND CF.BRID = DECODE(''<$BRID>'', ''<$HO_BRID>'', CF.BRID, ''<$BRID>'')
)A, TLEMAILLIMIT TL
WHERE A.aprvid=tl.tlid(+) and A.brid=tl.brid(+)', 'CI1118', 'frm', 'AUTOID DESC', '1118', null, 50, 'N', 30, 'NNNNYYYNNN', 'Y', 'T');
COMMIT;
/
--
--
/
DELETE searchfld WHERE searchcode = 'CI1118';
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (0, 'AUTOID', 'Mã yêu cầu', 'N', 'CI1118', 100, null, 'LIKE,=', null, 'N', 'N', 'Y', 80, null, 'Request ID', 'N', '01', null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (1, 'CUSTODYCD', 'Số tài khoản lưu ký', 'C', 'CI1118', 100, 'ccc.c.cccccc', 'LIKE,=', '_', 'Y', 'Y', 'N', 100, null, 'Custody code', 'N', '88', null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (2, 'AFACCTNO', 'Số tiểu khoản', 'C', 'CI1118', 100, null, 'LIKE,=', '_', 'Y', 'Y', 'N', 100, null, 'Contract number', 'N', '02', null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (4, 'BENEFACCT', 'Số TK ngân hàng', 'C', 'CI1118', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 150, null, 'Bank acount name', 'N', NULL, null, 'N', null, null, null, 'N');
INSERT into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (6, 'FULLNAME', 'Họ tên', 'C', 'CI1118', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 150, null, 'Customer name', 'N', '31', null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (9, 'AMOUNT', 'Số tiền chuyển', 'N', 'CI1118', 100, null, '<,<=,=,>=,>', '#,##0', 'Y', 'Y', 'N', 120, null, 'Amount', 'N', '14', null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (12, 'ADVAMT', 'Số tiền ứng trước cần chuyển', 'N', 'CI1118', 100, null, '<,<=,=,>=,>', '#,##0', 'Y', 'Y', 'N', 150, null, 'Avladvance', 'N', '15', null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (15, 'CASHAMT', 'Số tiền mặt cần chuyển', 'N', 'CI1118', 100, null, '<,<=,=,>=,>', '#,##0', 'Y', 'Y', 'N', 150, null, 'Cash', 'N', '16', null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (18, 'TOTALADVAMT', 'Số tiền ứng đã chuyển', 'N', 'CI1118', 100, null, '<,<=,=,>=,>', '#,##0', 'Y', 'Y', 'N', 150, null, 'Total avladvance', 'N', '17', null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (21, 'TOTALCASHAMT', 'Số tiền mặt đã chuyển', 'N', 'CI1118', 100, null, '<,<=,=,>=,>', '#,##0', 'Y', 'Y', 'N', 150, null, 'Total cash', 'N', '18', null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (22, 'TOTALCASHAMTEXT', 'Số tiền mặt đã chuyển khác chính chủ', 'N', 'CI1118', 100, null, '<,<=,=,>=,>', '#,##0', 'Y', 'Y', 'N', 150, null, 'Total cash', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (23, 'TLID', 'Người phê duyệt', 'C', 'CI1118', 100, null, 'LIKE,=', null, 'N', 'Y', 'N', 80, null, 'Approver', 'N', '20', null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (25, 'READVANCE', 'Số tiền ứng còn lại được duyệt', 'N', 'CI1118', 100, null, '<,<=,=,>=,>', '#,##0', 'Y', 'Y', 'N', 150, null, 'The remaining advance are approved', 'N', '22', null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (26, 'RETRANFER', 'Số tiền mặt còn lại được duyệt', 'N', 'CI1118', 100, null, '<,<=,=,>=,>', '#,##0', 'Y', 'Y', 'N', 150, null, 'The remaining transfer amount is approved', 'N', '21', null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (24, 'TLNAME', 'Người phê duyệt', 'C', 'CI1118', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 150, null, 'Approver', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (5, 'BENEFCUSTNAME', 'Họ tên người nhận', 'C', 'CI1118', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 150, null, 'BE Customer name', 'N', '32', null, 'N', null, null, null, 'N');
COMMIT;
/
