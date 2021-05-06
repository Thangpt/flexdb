create or replace force view v_afmastclosecv as
select CF.CUSTODYCD, TO_CHAR(AF.CLSDATE,'DD-MM-YYYY') CLOSEDATE,CF.BRID
 from afmast af,cfmast cf
where af.custid =cf.custid 
and af.status in ('C','N')
ORDER BY CUSTODYCD;

