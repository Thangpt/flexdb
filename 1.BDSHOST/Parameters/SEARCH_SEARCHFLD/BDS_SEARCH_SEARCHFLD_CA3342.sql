--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'CA3342';
INSERT INTO SEARCH (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE)
VALUES ('CA3342', 'Thực hiện quyền phân bổ tiền vào tài khoản', 'Money execute CA','
select * from (
    select max(A.AUTOID) AUTOID,a.camastid, a.description, b.symbol, a.actiondate ,a.actiondate POSTINGDATE,
        sum (case when  (case when chd.PITRATEMETHOD <> ''##'' then chd.PITRATEMETHOD else a.PITRATEMETHOD end) <> ''SC'' or af.isfct=''N'' then chd.amt
             else (CASE WHEN a.catype in (''016'',''023'') THEN round(chd.amt - round(chd.intamt*a.pitrate/100))
					    WHEN a.CATYPE = ''028''
							then (chd.amt - LEAST(round(a.pitrate * chd.BALANCE * a.EXPRICE / (to_number(SUBSTR(b.EXERCISERATIO,0,INSTR(b.EXERCISERATIO,''/'') - 1)) / to_number( SUBSTR(b  .EXERCISERATIO,INSTR(b.EXERCISERATIO,''/'')+1,LENGTH(b.EXERCISERATIO))))/100), chd.AMT))  
				   ELSE  round(chd.amt - round(chd.amt*a.pitrate/100))  end)
		    END )allamt,
        sum(chd.amt) amt,
        sum (case when (case when chd.PITRATEMETHOD <>''##'' then chd.PITRATEMETHOD else a.PITRATEMETHOD end) = ''SC'' and af.isfct=''Y''
            then (CASE WHEN a.catype in (''016'',''023'') THEN round (chd.intamt * a.pitrate/100) 
                      when a.CATYPE in (''028'')
                       then LEAST(round(a.pitrate * chd.BALANCE * a.EXPRICE / (to_number(SUBSTR(b.EXERCISERATIO,0,INSTR(b.EXERCISERATIO,''/'') - 1)) / to_number( SUBSTR(b  .EXERCISERATIO,INSTR(b.EXERCISERATIO,''/'')+1,LENGTH(b.EXERCISERATIO))))/100), chd.AMT)
                  ELSE round( chd.amt * a.pitrate/100) END ) else 0 end) scvatamt,
        max(cd.cdcontent) catype,
        max(a.codeid) codeid
    from camast a, sbsecurities b , caschd chd,allcode cd, afmast af, aftype aft
    where a.codeid = b.codeid and a.status  in (''I'',''G'',''H'')
        and chd.afacctno = af.acctno and af.actype = aft.actype
        and a.deltd<>''Y''
        and a.camastid = chd.camastid
        and chd.deltd <> ''Y'' and chd.ISEXEC=''Y''
        and chd.status <> ''C'' and chd.isCI =''N''
        and (select count(1) from caschd where camastid = a.camastid and status <> ''C'' and isCI =''N'' AND ISEXEC=''Y'' and amt>0 and deltd=''N'') >0
        and cd.cdname =''CATYPE'' and cd.cdtype =''CA'' and cd.cdval = a.catype
        group by a.camastid, a.description, b.symbol, a.actiondate
        having sum(chd.amt) <>0
) where 0=0', 'CAMAST', null, 'AUTOID DESC', '3342', null, 50, 'N', 30, 'NYNNYYYNNN', 'Y', 'T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'CA3342';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (19,'POSTINGDATE','Ngày chứng từ','D','CA3342',100,null,'<,<=,=,>=,>','dd/MM/yyyy','Y','Y','N',80,null,'Posting date','N','PD',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (11,'AMT','Tổng tiền chốt','N','CA3342',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',150,null,'Total amount','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (10,'SCVATAMT','Thuế công ty thu','N','CA3342',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',150,null,'Total VAT at company','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (9,'ALLAMT','Tổng tiền phân bổ','N','CA3342',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',150,null,'Total Allocate amount','N','08',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'ACTIONDATE','Ngày thực hiện quyền','D','CA3342',100,null,'>,>=,=,<=,<',null,'Y','Y','N',100,null,'Action date','N','07',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'SYMBOL','Mã chứng khoán','C','CA3342',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Symbol','N','04',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'CODEID','Mã chứng khoán gốc','C','CA3342',100,null,'LIKE,=',null,'N','Y','N',100,null,'Symbol','N','06',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'CATYPE','Loại thực hiện quyền','C','CA3342',100,null,'LIKE,=',null,'Y','Y','N',200,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''CA''
AND CDNAME = ''CATYPE'' AND CDUSER=''Y''  ORDER BY LSTODR','Coporate action type','N','05',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'DESCRIPTION','Thông tin đợt TH quyền','C','CA3342',100,null,'LIKE,=',null,'Y','Y','N',300,null,'Description','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'CAMASTID','Mã TH quyền','C','CA3342',100,'cccc.cccccc.cccccc','LIKE,=','_','Y','Y','Y',120,null,'CA code','N','03',null,'N',null,null,null,'N');
COMMIT;
/
