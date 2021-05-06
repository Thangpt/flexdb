create or replace force view cuongpv_percent as
select sum(tong_gtgd) as MATCH_VALUE, BRAND from
(
select  a.moigioi,a.cn_mg,a.tong_gtgd,a.reacctno,
decode(b.brid ,'0001','SGD','0002','HN','0101', 'HCM') as BRAND
from
(
select count(distinct(orgorderid)) as TONG_LENH, MOIGIOI,CN_MG,SUM(MATCHPRICE*MATCHQTTY) as TONG_GTGD,
REACCTNO, to_char(SUM(MATCHPRICE*MATCHQTTY)/count(distinct(orgorderid)),'9,999,999,999,999.00') as GT_TRUNGBINH
from (
select a.orgorderid , a.TXDATE, a.CUSTODYCD, b.FULLNAME, a.BORS, a.SYMBOL, a.PRICE, a.QTTY, a.MATCHPRICE, a.MATCHQTTY
,b.CUSTID
,c.AFACCTNO, c.FEEAMT, c.FEEACR, c.execamt
,d.REACCTNO
,e.CUSTID as CN_MG
,f.FULLNAME as MOIGIOI
From IOD a
leFt join CFMAST b ON a.CUSTODYCD = b.CUSTODYCD
left join ODMAST c ON a.orgorderid = c.ORDERID
leFt join REAFLNK d ON d.AFACCTNO = c.AFACCTNO
leFt join retype r ON substr(d.reacctno,11,4)=r.actype
left join remast e ON e.ACCTNO = d. REACCTNO
left join CFMAST f ON f.CUSTID = e.CUSTID

where  d.Status = 'A' and r.REROLE <> 'RD'
)
Group by MOIGIOI,CN_MG, REACCTNO
) a
left join recflnk b on a.cn_mg=b.custid
)
Group by BRAND;

