CREATE OR REPLACE FUNCTION fn_getmrcrlimitmax(p_afacctno varchar2)
return number
is
l_maxdebtcf number(20,0);
l_mrcrlimitmax number(20,0);
begin
l_maxdebtcf:= to_number(cspks_system.fn_get_sysvar('MARGIN','MAXDEBTCF'));
select case when nvl(lnt.chksysctrl,'N') = 'Y' then least(af.mrcrlimitmax,l_maxdebtcf) else af.mrcrlimitmax end into l_mrcrlimitmax
from afmast af, aftype aft, lntype lnt
where af.actype = aft.actype and aft.lntype = lnt.actype(+) and af.acctno = p_afacctno;

return l_mrcrlimitmax;
exception when others then
return 0;
end;
/

