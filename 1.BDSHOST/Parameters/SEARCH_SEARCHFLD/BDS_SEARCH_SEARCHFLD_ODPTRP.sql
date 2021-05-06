--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'ODPTRP';
insert into SEARCH (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE)
values ('ODPTRP', 'Lệnh thỏa thuận Repo', 'Order Repo', 'SELECT * FROM (
    SELECT tbl.orderid, (tbl.custodycd) custodycd, (af.acctno) afacctno, (cf.fullname) fullname, (tbl.txdate) txdate,
        (tbl.quoteprice) quoteprice, (tbl.orderqtty) orderqtty, (sb.symbol) symbol, (tbl.clearday) clearday,
        (tbl.exectype) exectype, (nvl(tbl.price2,0)) price2, (nvl(tbl.exptdate,''01-Jan-2000'')) exptdate,
        (tbl.ref_custodycd) ref_custodycd, (tbl.ref_afacctno) ref_afacctno, (cf2.fullname) ref_fullname,
        (CASE WHEN tbl.ref_custodycd IS NULL THEN ''2'' ELSE ''1'' END) firm,
        (CASE WHEN tbl.txdate < reportdate AND tbl.exptdate>= reportdate
            THEN nvl(ca.description,'''')
            ELSE ''''
        END) CA_DESC,
        (tbl.execqtty) execqtty, (tbl.execqtty2) execqtty2, (nvl(tbl.quoteprice2,0)) quoteprice2,
        (nvl(tbl.orderqtty2,0)) orderqtty2, (cd2.cdcontent) grporder,
        (tbl.ref_orderid) ref_orderid, (nvl(tbl.orderid2,0)) orderid2,
        (tbl.remainqtty) remainqtty, (getcurrdate) currdate,
        (tbl.txdate2) od2_txdate, (nvl(tbl.remainqtty2,0)) remainqtty2

    FROM tbl_odrepo tbl, afmast af, cfmast cf, cfmast cf2, sbsecurities sb, allcode cd2,
        (
            SELECT codeid, max(reportdate) reportdate, max(description) description FROM
                (
                    SELECT  CODEID, fn_get_prevdate(reportdate,2) REPORTDATE ,description FROM CAMAST
                    WHERE CATYPE IN (''015'',''016'') AND DELTD=''N'' AND STATUS <> ''P''
                UNION ALL
                    SELECT codeid, to_date(''01-Jan-2000'',''DD/MM/RRRR'') REPORTDATE,'''' DESCRIPTION FROM sbsecurities
                    WHERE sectype IN (''003'',''006'')
                )
            GROUP BY codeid
        ) CA
    WHERE cf.custid = af.custid
        AND tbl.codeid = sb.codeid
        AND tbl.afacctno = af.acctno
        AND tbl.codeid = ca.codeid
        AND tbl.ref_custodycd = cf2.custodycd(+)
        AND cd2.cdtype =''SY'' AND cd2.cdname =''YESNO''
        AND tbl.grporder = cd2.cdval
    )
WHERE 0=0
', 'ODPTREPO', 'frmODMAST', 'ORDERID DESC', null, null, 50, 'N', 30, null, 'Y', 'T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'ODPTRP';
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (0, 'ORDERID', 'Số hiệu lệnh', 'C', 'ODPTRP', 100, null, 'LIKE,=', null, 'Y', 'Y', 'Y', 80, null, 'OrderID', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (1, 'EXPTDATE', 'Ngày đáo hạn', 'D', 'ODPTRP', 100, null, '<,<=,=,>=,>,<>', null, 'Y', 'Y', 'N', 100, null, 'EX  date', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (2, 'FIRM', 'Firms', 'C', 'ODPTRP', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 80, null, 'Firms', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (3, 'CUSTODYCD', 'TK lưu ký', 'C', 'ODPTRP', 120, 'cccc.cccccc', 'LIKE,=', '_', 'Y', 'Y', 'N', 100, null, 'Custody code', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (4, 'AFACCTNO', 'Số Tiểu khoản', 'C', 'ODPTRP', 100, null, 'LIKE,=', '_', 'Y', 'Y', 'N', 80, null, 'Contract No', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (5, 'FULLNAME', 'Tên khách hàng', 'C', 'ODPTRP', 100, null, 'LIKE,=', '_', 'Y', 'Y', 'N', 80, null, 'Fullname', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (6, 'EXECTYPE', 'Loại lệnh', 'C', 'ODPTRP', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 80, 'SELECT CDVAL VALUE, CDVAL DISPLAY FROM ALLCODE WHERE CDTYPE = ''OD'' AND CDNAME = ''EXECTYPE'' ORDER BY LSTODR', 'Type', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (7, 'SYMBOL', 'Mã chứng khoán', 'C', 'ODPTRP', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 80, null, 'Symbol', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (8, 'ORDERQTTY', 'Số lượng', 'N', 'ODPTRP', 100, null, '<,<=,=,>=,>,<>', '#,##0', 'Y', 'N', 'N', 100, null, 'Order quantity', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (9, 'EXECQTTY', 'Số lượng khớp', 'N', 'ODPTRP', 100, null, '<,<=,=,>=,>,<>', '#,##0', 'Y', 'N', 'N', 100, null, 'match quantity', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (10, 'QUOTEPRICE', 'Giá lần 1', 'N', 'ODPTRP', 100, null, '<,<=,=,>=,>,<>', '#,##0.############', 'Y', 'Y', 'N', 100, null, 'Order price', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (11, 'PRICE2', 'Giá lần 2(dự kiến)', 'N', 'ODPTRP', 100, null, '<,<=,=,>=,>,<>', '#,##0.############', 'Y', 'Y', 'N', 100, null, 'EX price2', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (12, 'REF_CUSTODYCD', 'TK LK đối ứng', 'C', 'ODPTRP', 120, 'cccc.cccccc', 'LIKE,=', '_', 'Y', 'Y', 'N', 100, null, 'Ref Custody code', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (13, 'REF_AFACCTNO', 'Số TK đối ứng', 'C', 'ODPTRP', 100, null, 'LIKE,=', '_', 'Y', 'Y', 'N', 80, null, 'Ref Contract No', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (14, 'REF_FULLNAME', 'Tên KH đối ứng', 'C', 'ODPTRP', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 80, null, 'Ref Fullname', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (15, 'REF_ORDERID', 'Lệnh đối ứng', 'C', 'ODPTRP', 100, null, 'LIKE,=', null, 'Y', 'Y', 'Y', 80, null, 'Ref OrderID', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (16, 'TXDATE', 'Ngày đặt lệnh', 'D', 'ODPTRP', 100, null, '<,<=,=,>=,>,<>', null, 'Y', 'Y', 'N', 100, null, 'Order date', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (17, 'GRPORDER', 'Lệnh tổng', 'C', 'ODPTRP', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 80, 'SELECT CDVAL VALUE, cdcontent DISPLAY FROM ALLCODE WHERE CDTYPE = ''SY'' AND CDNAME = ''YESNO'' ORDER BY LSTODR', 'Group Order', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (18, 'ORSTATUS', 'Trạng thái lệnh', 'C', 'ODPTRP', 100, null, '=', null, 'N', 'N', 'N', 100, 'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''OD'' AND CDNAME = ''ORSTATUS'' ORDER BY LSTODR', 'Order status', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (19, 'CA_DESC', 'Trạng thái CA', 'C', 'ODPTRP', 120, null, 'LIKE,=', '_', 'Y', 'Y', 'N', 100, null, 'CA', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (20, 'ORDERID2', 'SHL lần 2', 'C', 'ODPTRP', 100, null, 'LIKE,=', null, 'Y', 'Y', 'Y', 80, null, 'OrderID2', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (21, 'ORDERQTTY2', 'SL đặt lần 2', 'N', 'ODPTRP', 100, null, '<,<=,=,>=,>,<>', '#,##0', 'Y', 'N', 'N', 100, null, 'Order quantity2', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (22, 'QUOTEPRICE2', 'Giá đặt lần 2', 'N', 'ODPTRP', 100, null, '<,<=,=,>=,>,<>', '#,##0.############', 'Y', 'Y', 'N', 100, null, 'Order price 2', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (23, 'EXECQTTY2', 'SL khớp lần 2', 'N', 'ODPTRP', 100, null, '<,<=,=,>=,>,<>', '#,##0', 'Y', 'N', 'N', 100, null, 'match quantity 2', 'N', null, null, 'N', null, null, null, 'N');
insert into searchfld (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
values (24, 'REF_ORDERID2', 'Lệnh đối ứng 2', 'C', 'ODPTRP', 100, null, 'LIKE,=', null, 'Y', 'Y', 'Y', 80, null, 'Ref OrderID', 'N', null, null, 'N', null, null, null, 'N');
COMMIT;
/
