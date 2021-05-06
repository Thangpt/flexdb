--drop table AVGRATELNSCHD_TEMP
create table AVGRATELNSCHD_TEMP as
SELECT  l.autoid,
round((rate1 * greatest(least ( DUEDATE -RLSDATE, TO_DATE( s.VARVALUE,'DD/MM/RRRR') - RLSDATE ),0) + 
 rate2 * greatest(least (OVERDUEDATE - DUEDATE, TO_DATE( s.VARVALUE,'DD/MM/RRRR') - DUEDATE),0 ) +
 rate3  * greatest(TO_DATE( s.VARVALUE,'DD/MM/RRRR') - OVERDUEDATE,0)) /
  (greatest(least ( DUEDATE -RLSDATE, TO_DATE( s.VARVALUE,'DD/MM/RRRR') - RLSDATE ),0) + greatest(least (OVERDUEDATE - DUEDATE, TO_DATE( s.VARVALUE,'DD/MM/RRRR') - DUEDATE),0 ) + greatest(TO_DATE( s.VARVALUE,'DD/MM/RRRR') - OVERDUEDATE,0)),4) AVGRATE ,
 l.rlsdate , TO_DATE( s.VARVALUE,'DD/MM/RRRR') TXDATE, DATEDIFF('D',l.RLSDATE, TO_DATE( s.VARVALUE,'DD/MM/RRRR')) DAYS 
FROM LNSCHD l , sysvar s
WHERE REFTYPE IN ( 'P')AND DUENO = 0
and s.grname =  'SYSTEM' and s.varname = 'CURRDATE'
union all 
SELECT  l.autoid,
round((ln.orate1 * greatest(least ( l.DUEDATE -l.RLSDATE, TO_DATE( s.VARVALUE,'DD/MM/RRRR') - l.RLSDATE ),0) + 
 ln.orate2 * greatest(least (l.OVERDUEDATE - l.DUEDATE, TO_DATE( s.VARVALUE,'DD/MM/RRRR') - l.DUEDATE),0 ) +
 ln.orate3  * greatest(TO_DATE( s.VARVALUE,'DD/MM/RRRR') - OVERDUEDATE,0)) /
  (greatest(least ( l.DUEDATE -l.RLSDATE, TO_DATE( s.VARVALUE,'DD/MM/RRRR') - l.RLSDATE ),0) + greatest(least (l.OVERDUEDATE - l.DUEDATE, TO_DATE( s.VARVALUE,'DD/MM/RRRR') - DUEDATE),0 ) + greatest(TO_DATE( s.VARVALUE,'DD/MM/RRRR') - OVERDUEDATE,0)),4) AVGRATE ,
 l.rlsdate , TO_DATE( s.VARVALUE,'DD/MM/RRRR') TXDATE, DATEDIFF('D',l.RLSDATE, TO_DATE( s.VARVALUE,'DD/MM/RRRR')) DAYS 
FROM LNSCHD l,lnmast ln, sysvar s
WHERE ln.acctno = l.acctno and  l.REFTYPE IN ( 'GP')AND l.DUENO = 0
and s.grname =  'SYSTEM' and s.varname = 'CURRDATE';
/
begin
  for rec in (select * from AVGRATELNSCHD_TEMP) loop
update lnschd l set l.avgrate = rec.avgrate where l.autoid = rec.autoid;
commit;
end loop;
end;

/
create table lninttran_20200901 as
select  * from lninttran where lnschdid is not null;

update lninttran  set lnschdid = null where lnschdid is not null;
update lninttrana set lnschdid = null where lnschdid is not null;

commit;
