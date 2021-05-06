--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'CF0045';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('CF0045','Tra cứu trạng thái tiền','View cash statement','SELECT cf.custodycd,  ci.acctno, cf.fullname, af.actype, ci.balance - NVL(v.ADVAMT,0)- NVL(v.SECUREAMT,0) balance, ci.odamt,
       NVL (c.aamt, 0) receiving, NVL (b.execamt, 0) execamt,
       NVL(v.ADVAMT,0) + NVL(v.SECUREAMT,0) securedamt, NVL (b.matchedamt, 0) matchedamt
  FROM cimast ci,
       afmast af,
       cfmast cf,
       (SELECT   af.acctno,
                 SUM (CASE
                         WHEN od.exectype IN (''NS'', ''SS'')
                            THEN execamt
                         ELSE 0
                      END
                     ) execamt,
                 SUM (CASE
                         WHEN od.exectype IN (''NB'', ''BC'')
                            THEN securedamt - rlssecured
                         ELSE 0
                      END
                     ) securedamt,
                 SUM (CASE
                         WHEN od.exectype IN (''NB'', ''BC'')
                            THEN execamt
                         ELSE 0
                      END
                     ) matchedamt
            FROM odmast od, afmast af, odtype typ, sysvar SYS
           WHERE SYS.varname = ''CURRDATE''
             AND SYS.grname = ''SYSTEM''
             AND od.actype = typ.actype
             AND af.acctno = od.afacctno
             AND od.txdate = TO_DATE (SYS.varvalue, ''DD/MM/YYYY'')
             AND deltd <> ''Y''
        GROUP BY af.acctno) b,
       (SELECT   afacctno acctno,
                 SUM (amt - aamt - famt + paidamt + paidfeeamt) aamt
            FROM stschd
           WHERE duetype = ''RM'' AND status = ''N'' AND deltd <> ''Y''
        GROUP BY afacctno) c,
        v_getbuyorderinfo v
 WHERE af.acctno = ci.acctno
   AND af.custid = cf.custid
   AND ci.acctno = b.acctno(+)
   AND ci.acctno = c.acctno(+)
   and ci.acctno = v.AFACCTNO(+)','CFMAST',null,null,null,null,50,'N',30,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'CF0045';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (8,'MATCHEDAMT','Giá trị khớp mua','N','CF0045',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'matched buy','N','15',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'EXECAMT','Bán khớp','N','CF0045',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Matched sell','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'SECUREDAMT','KQ mua','N','CF0045',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Buy secured','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'RECEIVING','Chờ về','N','CF0045',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Receiving','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'ODAMT','Thấu chi','N','CF0045',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Overdraft amount','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'BALANCE','Số dư GD','N','CF0045',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',100,null,'Balance','N','14',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'FULLNAME','Tên khách hàng','C','CF0045',4,null,'LIKE,=','_','Y','Y','N',100,null,'Full name','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'ACTYPE','Loại hình','C','CF0045',4,'9999','LIKE,=','_','Y','Y','N',100,null,'Account type','N','04',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'ACCTNO','Mã tiểu khoản','C','CF0045',4,'9999.999999','LIKE,=','_','Y','Y','N',100,null,'Account Number','N','03',null,'N',null,null,null,'N');
COMMIT;
/
