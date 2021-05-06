CREATE OR REPLACE FORCE VIEW V_AFMASTCV AS
SELECT cf.custodycd, to_char(af.opndate,'DD-MM-YYYY') opndate,af.actype , af.status,AF.COREBANK,DECODE(COREBANK,'Y',AF.BANKNAME,'BOSC') BANKNAME,DECODE(COREBANK,'Y', AF.BANKACCTNO,' ') BANKACCTNO,nvl(af.advanceline,0)advanceline,
nvl(AF.TRADEONLINE,' ') ISONLINE,cf.brid
FROM AFMAST af, CFMAST cf 
WHERE cf.CUSTID = af.CUSTID 
order by cf.custodycd;

