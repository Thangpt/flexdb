create or replace force view v_smscv as
select CF.custodycd , AF.FAX1 mobilesms,CF.BRID FROM cfmast CF, AFMAST AF where CF.CUSTID = AF.CUSTID AND LENGTH( AF.FAX1)>1
order by custodycd;

