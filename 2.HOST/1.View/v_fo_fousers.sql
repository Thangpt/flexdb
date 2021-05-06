create or replace force view v_fo_fousers as
Select TLID, tlname USERNAME,
    null AUTHTYPE, pin PWDLOGIN,
    null PWDTRADE, 'B' TYPE
From tlprofiles Where Active = 'Y'
UNION ALL
Select null TLID, USERNAME, AUTHTYPE,
    loginpwd PWDLOGIN,
    tradingpwd PWDTRADE, 'O' TYPE
From userlogin Where Status = 'A';

