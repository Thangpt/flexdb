create or replace force view cuongpv_test3 as
Select distinct CUSTODYCD from OODHIST where TXDATE >='01-Jan-2017' and TXDATE <= '31-Dec-2017';

