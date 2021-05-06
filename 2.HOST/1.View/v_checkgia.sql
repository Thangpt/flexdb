create or replace force view v_checkgia as
select distinct symbol,basicprice
  from securities_info
  order by symbol asc;

