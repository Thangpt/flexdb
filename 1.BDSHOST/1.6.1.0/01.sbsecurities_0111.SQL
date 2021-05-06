
create table sbsecurities_0111 as
select * from sbsecurities where EXERCISERATIO is not null;

update sbsecurities set EXERCISERATIO = null  where EXERCISERATIO is not null;

ALTER TABLE sbsecurities MODIFY EXERCISERATIO VARCHAR2(20);

begin
  for rec in (select * from sbsecurities_0111)loop
    update sbsecurities set EXERCISERATIO = rec.EXERCISERATIO ||'/1' where codeid =rec.codeid;
   end loop;
   commit;
end;
