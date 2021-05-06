create or replace force view v_it_branch_cust as
select tl.brid,br.brname, tl.tlid, tl.tlname, tl.tlfullname, tg.grpid, tg.grpname, cf.custodycd
from  cfmast cf
    left join tlprofiles tl on cf.tlid=tl.tlid
    left join brgrp br on br.brid=tl.brid
    left join tlgroups tg on cf.careby=tg.grpid
order by brid, tlname, tg.grpname, cf.custodycd;

