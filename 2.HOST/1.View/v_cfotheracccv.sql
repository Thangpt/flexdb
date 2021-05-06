create or replace force view v_cfotheracccv as
select cf.custodycd ,cfo.BANKACC, NVL(cfo.BANKACNAME,' ')BANKACNAME,NVL(cfo.BANKNAME,' ')BANKNAME , nvl(cfo.CITYBANK,' ') CITYBANK
 ,nvl(CITYEF,' ') CITYEF,nvl(ACNIDCODE,' ') ACNIDCODE, nvl( TO_char( acniddate,'DD-MM-YYYY') ,' ')    ACNIDDATE,nvl(ACNIDPLACE,' ') ACNIDPLACE
from cfotheracc cfo,afmast af,cfmast cf
where cfo.afacctno= af.acctno and af.custid = cf.custid
order by cf.custodycd ,cfo.BANKACC;

