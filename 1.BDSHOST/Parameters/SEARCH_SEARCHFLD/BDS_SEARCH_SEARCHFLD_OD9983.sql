--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'OD9983';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('OD9983','Danh sách lệnh mua bán cùng tài khoản','Trade buy sell in an account','SELECT a.orderid, a.txdate, a.ordernumber, a.refordernumber, a.custodycd,
       a.symbol, a.bsca bors, a.norp, a.ordertype, a.volume QTTY, a.price, a.traderid,
       a.memberid, a.board,issend
  FROM (SELECT a.orderid, a.txdate, a.ordernumber, a.refordernumber,
               a.custodycd, a.symbol, a.bsca, a.norp, a.ordertype, a.volume,
               a.price, a.traderid, a.memberid, a.board, ''N'' issend
          FROM stcorderbook a
        UNION ALL
        SELECT '''' orderid, a.txdate, a.ordernumber, a.refordernumber,
               a.custodycd, a.symbol, a.bsca, a.norp, a.ordertype, a.volume,
               a.price, a.traderid, a.memberid, a.board, ''N'' issend
          FROM stcorderbookexp a
        UNION ALL
        SELECT a.orgorderid orderid, a.txdate, '''' ordernumber,
               '''' refordernumber, a.custodycd, TO_CHAR (a.symbol),
               a.bors bsca, a.norp, '''' ordertype, a.qtty volume, a.price,
               '''' traderid, '''' memberid, '''' board , ''N'' issend
          FROM ood a
         WHERE a.oodstatus = ''N'') a
 WHERE (a.custodycd, a.symbol) IN (
          SELECT   a.custodycd, a.symbol
              FROM (SELECT a.custodycd, a.symbol, a.bsca
                      FROM stcorderbook a
                    UNION ALL
                    SELECT a.custodycd, a.symbol, a.bsca
                      FROM stcorderbookexp a
                    UNION ALL
                    SELECT a.custodycd, TO_CHAR (a.symbol), a.bors bsca
                      FROM ood a
                     WHERE a.oodstatus = ''N'') a
          GROUP BY a.custodycd, a.symbol
            HAVING COUNT (DISTINCT a.bsca) > 1)
','ODMAST',null,null,null,null,50,'N',30,'NYNNYYYNNN','Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'OD9983';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (10,'TXDATE','Ngày giao dịch','D','OD9983',100,null,'=',null,'Y','Y','N',80,null,'Tx.Date','N','  ',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (8,'QTTY','Khối lượng','N','OD9983',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',80,null,'Quantity','N','30',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'NORP','Thường / Thỏa thuận','C','OD9983',100,null,'=','_','Y','Y','N',100,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''OD'' AND CDNAME = ''BORS'' ORDER BY LSTODR','Normal/Putthrough','N','30',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'BORS','Mua / Bán','C','OD9983',100,null,'=','_','Y','Y','N',80,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''OD'' AND CDNAME = ''BORS'' ORDER BY LSTODR','Buy/Sell','N','30',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'PRICE','Giá','C','OD9983',100,null,'LIKE,=','_','Y','Y','N',80,null,'Price','N','  ',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'SYMBOL','Chứng khoán','C','OD9983',110,null,'LIKE,=','_','Y','Y','N',80,null,'Symbol','N','  ',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'CUSTODYCD','Mã lưu ký','C','OD9983',110,'ccc.c.cccccc','LIKE,=','_','Y','Y','N',80,null,'Custody Code','N','  ',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'ORDERID','Số hiệu lệnh','C','OD9983',150,null,'LIKE,=',null,'Y','Y','Y',110,null,'Order ID','N','01',null,'N',null,null,null,'N');
COMMIT;
/
