delete from search where SEARCHCODE = 'CF0041';
insert into search (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE)
values ('CF0041', 'Bảng tra cứu trạng thái EMAIL/SMS', 'Bảng tra cứu trạng thái EMAIL/SMS', 'Select createtime,SENTTIME,email,templateid,subject,decode
(b.type,''E'',''EMAIL'',''S'',''SMS'') type ,
decode(status,''A'',''Cho gui'',''S'',''Da gui'',''R'',''Loi'') 
STATUS  ,datasource
     from emaillog a, templates b 
where a.templateid = b.code and b.code not in (''0330'', ''0335'', ''0213'', ''0209'')
union all
Select createtime,SENTTIME,email,templateid,subject,decode
(b.type,''E'',''EMAIL'',''S'',''SMS'') type , 
decode(status,''A'',''Cho gui'',''S'',''Da gui'',''R'',''Loi'') 
STATUS,datasource from emailloghist a, templates b 
where a.templateid = b.code and b.code not in (''0330'', ''0335'', ''0213'', ''0209'')
union all 
Select createtime,SENTTIME,email,templateid,subject,decode
(b.type,''E'',''EMAIL'',''S'',''SMS'') type ,
decode(status,''A'',''Cho gui'',''S'',''Da gui'',''R'',''Loi'') 
STATUS  ,'''' datasource
     from emaillog a, templates b 
where a.templateid = b.code and b.code in (''0330'', ''0335'', ''0213'', ''0209'')
union all
Select createtime,SENTTIME,email,templateid,subject,decode
(b.type,''E'',''EMAIL'',''S'',''SMS'') type , 
decode(status,''A'',''Cho gui'',''S'',''Da gui'',''R'',''Loi'') 
STATUS,'''' datasource from emailloghist a, templates b 
where a.templateid = b.code and b.code in (''0330'', ''0335'', ''0213'', ''0209'')', 'CFMAST', null, null, null, null, 50, 'N', 30, 'NYNNYYYNNN', 'Y', 'T');
commit;