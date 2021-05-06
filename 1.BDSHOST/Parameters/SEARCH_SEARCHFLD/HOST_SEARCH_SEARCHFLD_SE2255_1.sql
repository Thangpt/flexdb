--
--
/
DELETE SEARCH WHERE SEARCHCODE='SE2255_1';
INSERT INTO search (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE)
VALUES ('SE2255_1', 'Danh sách xác nhận chứng khoán chuyển khoản', 'List of securities transfer confirmation', 'SELECT * FROM (SELECT cf.custodycd,ses.recustodycd,ses.txdate, ses.txnum,to_char(ses.autoid) autoid ,max(a.cdcontent) tradeplace,max(NVL(sb2.symbol,sb.symbol)) symbol,
            max(de.fullname) member_name,max(cf.fullname) fullname, max(cf.idcode) idcode, max(cf.iddate) iddate, max(ses.tltxcd) tltxcd
        FROM 
        (SELECT ''2244'' tltxcd, se.recustodycd, se.txnum, se.txdate, se.autoid,se.acctno,substr(se.acctno,1,10) afacctno, se.codeid
           FROM Sesendout se 
          WHERE se.deltd <> ''Y''
           AND se.trade + se.blocked + se.strade + se.sblocked > 0
        UNION ALL 
        SELECT ''2247'' tltxcd, se47.recustodycd, se47.txnum, se47.txdate, se47.autoid,se47.acctno,substr(se47.acctno,1,10) afacctno, se47.codeid
           FROM se2247_log se47
          WHERE se47.deltd <> ''Y''
            AND se47.qtty > 0
        ) ses, 
        afmast af, cfmast cf, deposit_member de, sbsecurities sb, allcode a, sbsecurities sb2,
        (SELECT s.*,NVL(ca.catype,s.catype) cacatype FROM SEPITALLOCATE s, CAMAST ca 
          WHERE s.camastid = ca.camastid(+) 
            AND NVL(ca.catype,''021'') IN (''021'',''011''))  sep
          WHERE sep.orgorderid(+) = to_char(ses.autoid)
            AND substr(ses.acctno,1,10) = af.acctno
            AND af.custid = cf.custid
            AND SUBSTR(ses.recustodycd,1,3) = de.depositid (+)
            AND sb.codeid = ses.codeid
            AND sb.refcodeid = sb2.codeid (+)
            AND a.cdval = NVL(sb2.tradeplace,sb.tradeplace) AND a.cdname=''TRADEPLACE'' AND a.cdtype=''SE''
      GROUP BY cf.custodycd,ses.recustodycd,ses.txdate, ses.txnum,ses.autoid
      ORDER BY ses.txdate DESC, ses.txnum) where 0=0', 'SE2255', 'frmSE2255', 'txdate,txnum DESC', null, 0, 50, 'N', 30, null, 'Y', 'T');
COMMIT;
/

DELETE searchfld WHERE SEARCHCODE='SE2255_1';
INSERT INTO SEARCHFLD (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
VALUES (0, 'AUTOID', 'Khóa của bảng', 'C', 'SE2255_1', 100, null, 'LIKE,=', null, 'N', 'N', 'Y', 200, null, 'Key', 'N', '31', null, 'N', null, null, null, 'N');
INSERT INTO SEARCHFLD (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
VALUES (0, 'TLTXCD', 'Giao dịch', 'C', 'SE2255_1', 50, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'Key', 'N', '31', null, 'N', null, null, null, 'N');
INSERT INTO SEARCHFLD (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
VALUES (1, 'TXDATE', 'Ngày chứng từ', 'D', 'SE2255_1', 50, null, '<,<=,=,>=,>,<>', 'DD/mm/YYYY', 'Y', 'Y', 'N', 100, null, 'Date', 'N', '90', null, 'N', null, null, null, 'N');
INSERT INTO SEARCHFLD (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
VALUES (2, 'TXNUM', 'Số chứng từ', 'C', 'SE2255_1', 100, '9999999999', 'LIKE,=', '_', 'Y', 'Y', 'N', 100, null, 'Voucher number', 'N', '07', null, 'N', null, null, null, 'N');
INSERT INTO SEARCHFLD (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
VALUES (3, 'CUSTODYCD', 'Số TK chuyển', 'C', 'SE2255_1', 70, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'CUSTODYCD', 'N', null, null, 'N', null, null, null, 'N');
INSERT INTO SEARCHFLD (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
VALUES (4, 'FULLNAME', 'Tên khách hàng chuyển', 'C', 'SE2255_1', 100, null, 'LIKE,=', '_', 'Y', 'Y', 'N', 100, null, 'Fullname', 'N', '90', null, 'N', null, null, null, 'N');
INSERT INTO SEARCHFLD (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
VALUES (5, 'RECUSTODYCD', 'Số TK nhận', 'C', 'SE2255_1', 70, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'CUSTODYCD', 'N', null, null, 'N', null, null, null, 'N');
INSERT INTO SEARCHFLD (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
VALUES (6, 'MEMBER_NAME', 'Công ty chứng khoản nhận', 'C', 'SE2255_1', 100, null, 'LIKE,=', '_', 'Y', 'Y', 'N', 100, null, 'Fullname', 'N', '90', null, 'N', null, null, null, 'N');
INSERT INTO SEARCHFLD (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
VALUES (7, 'TRADEPLACE', 'Sàn giao dịch', 'C', 'SE2255_1', 100, null, '=', null, 'Y', 'Y', 'N', 100, 'SELECT CDVAL VALUECD,CDVAL VALUE,CDCONTENT DISPLAY,CDCONTENT EN_DISPLAY FROM ALLCODE WHERE CDTYPE = ''SA'' AND CDNAME = ''TRADEPLACE'' ORDER BY LSTODR ', 'Trade place', 'N', null, null, 'N', null, null, null, 'N');
INSERT INTO SEARCHFLD (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY)
VALUES (8, 'SYMBOL', 'Chứng khoán', 'C', 'SE2255_1', 100, null, 'LIKE,=', null, 'Y', 'Y', 'N', 100, null, 'Symbol', 'N', '81', null, 'N', null, null, null, 'N');
COMMIT;


