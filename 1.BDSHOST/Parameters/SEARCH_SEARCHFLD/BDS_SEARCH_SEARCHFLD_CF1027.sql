--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'CF1027';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('CF1027','Theo dõi thông tin Pool đặc biệt','Theo dõi thông tin Pool đặc biệt','
select cf.custodycd, af.acctno, cf.fullname, af.poollimit,
               round(least(  af.poollimit, nvl(adv.avladvance,0)
                        + mst.balance
                        + af.poollimit
                        - mst.odamt
                        - mst.dfdebtamt
                        - mst.dfintdebtamt
                        - mst.depofeeamt
                        - NVL (advamt, 0)
                        - nvl(secureamt,0)
                        - ramt
                        - nvl(dealpaidamt,0)),0) poolavl

            from cimast mst,afmast af ,cfmast cf,
                (select * from v_getbuyorderinfo) al,
                (select sum(depoamt) avladvance,afacctno from v_getAccountAvlAdvance group by afacctno) adv,
                (select * from v_getdealpaidbyaccount p) pd
            where mst.acctno = af.acctno and af.custid = cf.custid
            and mst.acctno = al.afacctno(+)
            and adv.afacctno(+)=MST.acctno
            and pd.afacctno(+)=mst.acctno
            and af.poolchk =''N''
','AFMAST','frmAFMAST',null,null,null,50,'N',30,'NYNNYYYNNN','Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'CF1027';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (36,'POOLAVL','Hạn mức còn lại ','N','CF1027',100,null,'>,<,>=,<=,=,<>',null,'Y','Y','N',200,null,'Pool available','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (26,'POOLLIMIT','Hạn mức tối đa ','N','CF1027',100,null,'>,<,>=,<=,=,<>',null,'Y','Y','N',200,null,'Pool limit','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'FULLNAME','Tên khách hàng','C','CF1027',100,null,'LIKE,=',null,'Y','Y','N',300,null,'Customer name','Y',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'ACCTNO','Số tiểu khoản','C','CF1027',50,'9999999999','LIKE,=','_','Y','Y','Y',100,null,'Sub account','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'CUSTODYCD','Số TK lưu ký','C','CF1027',50,'cccccccccc','LIKE,=','_','Y','Y','N',100,null,'Custody code','N',null,null,'N',null,null,null,'N');
COMMIT;
/
