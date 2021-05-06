create or replace force view vw_marginroomsystem_fo as
select se.codeid, se.symbol, case when rsk.ismarginallow = 'Y' then least(se.roomlimit,se.roomlimitmax) else 10000000000 end roomlimit,
se.syroomlimit, se.syroomused
from securities_info se, securities_risk rsk
where se.codeid = rsk.codeid(+) AND (se.syroomlimit >0 OR se.syroomused >0 OR least(se.roomlimit,se.roomlimitmax) >0);

