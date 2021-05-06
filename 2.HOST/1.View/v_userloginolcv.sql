create or replace force view v_userloginolcv as
select username, nvl( loginpwd,' ') password, nvl(tradingpwd,' ') userlogin from userlogin 
order by username;

