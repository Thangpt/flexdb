create or replace force view v_cfauthcv as
select cf1.custodycd , cf2.fullname , cf2.idcode,NVL( to_char(cf2.iddate,'dd-mm-yyyy'),' ') iddate,NVL(cf2.idplace,' ') idplace, NVL(to_char(cfa.valdate,'DD-MM-YYYY'),' ')valdate , to_char( cfa.expdate,'DD-MM-YYYY') expdate,cfa.linkauth,cf1.brid
from cfauth cfa, cfmast cf1, afmast af1,cfmast cf2
where cfa.acctno = af1.acctno and cf1.custid = af1.custid
and cfa.custid = cf2.custid 
ORDER BY cf1.custodycd, cf2.idcode,cfa.expdate;

