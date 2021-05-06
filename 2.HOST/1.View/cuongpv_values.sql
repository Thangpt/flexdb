create or replace force view cuongpv_values as
select sum (MATCH_VALUE) as MATCH_VALUE,cdcontent from (
Select a.symbol,a.bors, (matchprice*matchqtty) as MATCH_VALUE, c.cdcontent from IOD a
left join sbsecurities b on a.symbol = b.symbol
left join allcode c on b.tradeplace = c.cdval
where c.cdname = 'TRADEPLACE' AND c.CDTYPE = 'OD' and (c.cdcontent='HOSE' or c.cdcontent='HNX' or c.cdcontent='UPCOM'))
group by cdcontent;

