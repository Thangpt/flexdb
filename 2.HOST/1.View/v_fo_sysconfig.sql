create or replace force view v_fo_sysconfig as
Select 'TRADE_DATE' CFGKEY, varvalue CFGVALUE, '' DESCRIPTIONS from sysvar where Grname = 'SYSTEM' And Varname = 'CURRDATE'
UNION ALL
Select 'FIRM' CFGKEY, varvalue CFGVALUE, '' DESCRIPTIONS from sysvar where Grname = 'SYSTEM' And Varname = 'FIRM'
UNION ALL
Select 'PRICELIMIT' CFGKEY, varvalue CFGVALUE, '' DESCRIPTIONS from sysvar where Grname = 'SYSTEM' And Varname = 'PRICELIMIT'
UNION ALL
Select 'FEE_RATE' CFGKEY, varvalue CFGVALUE, '' DESCRIPTIONS from sysvar where Grname = 'SYSTEM' And Varname = 'FEE_RATE';
