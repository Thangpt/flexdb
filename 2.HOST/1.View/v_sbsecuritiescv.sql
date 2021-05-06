create or replace force view v_sbsecuritiescv as
select '0001' BRID, sb.SYMBOL,NVL( to_char( seinfo.TXDATE,'dd-mm-yyyy'),' ' )TXDATE ,nvl(sb.SECTYPE,' ')SECTYPE,   nvl( sb.PArVALUE,0 ) PArVALUE, nvl(sb.TRADEPLACE,' ')  TRADEPLACE
from sbsecurities sb ,securities_info seinfo
where sb.codeid = seinfo.codeid 
and sb.refcodeid is null 
order by sb.SYMBOL;

