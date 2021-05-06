create or replace force view v_gl_stock_info_hist as
select sbh.symbol , to_char(histdate,'YYYY-MM-DD' ) txdate  ,sbh.basicprice
from securities_info_hist sbh, sbsecurities sb
where sbh.codeid  = sb.codeid 
and sb.tradeplace in ('001','002','005') and  sb.sectype <>'004';

