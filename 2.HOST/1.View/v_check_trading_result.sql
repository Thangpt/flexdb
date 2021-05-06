CREATE OR REPLACE FORCE VIEW V_CHECK_TRADING_RESULT AS
select "TRADING_DATE","ACCTNO","BORS","SEC_CODE","PRICE","QTTY","LECH","TRADEPLACE" from (
select a.trading_date,a.acctno,a.bors,a.sec_code,a.price,a.qtty , 
'SAN KHOP' LECH,b.tradeplace from  -------- trading_result minus IOD
(
select trading_date , acctno, bors, sec_code, price,  
qtty
from( -- trading_result sell                             
select h.trading_date,h.s_account_no acctno,'S' BORS, 
h.sec_code
,decode(h.floor_code,'02',h.price,h.price*1000) 
price,sum(h.quantity) qtty
 from trading_result h
where trading_date=(SELECT   TO_DATE (varvalue,'DD/MM/YYYY')
                   FROM  sysvar WHERE   varname = 'CURRDATE' AND grname = 'SYSTEM')
--and h.s_account_no like '091%'
and EXISTS (SELECT CUSTODYCD FROM CFMAST WHERE CUSTODYCD = h.s_account_no)
group by 
h.trading_date,h.s_account_no,h.sec_code,
decode(h.floor_code,'02',h.price,h.price*1000)
union all  -- trading_result buy  
select h.trading_date,h.b_account_no acctno,'B' BORS, 
h.sec_code
,decode(h.floor_code,'02',h.price,h.price*1000) 
price,sum(h.quantity) qtty
 from trading_result h
where trading_date=(SELECT   TO_DATE (varvalue,'DD/MM/YYYY')
                   FROM  sysvar WHERE   varname = 'CURRDATE' AND grname = 'SYSTEM')
--and h.b_account_no like '091%'
and EXISTS (SELECT CUSTODYCD FROM CFMAST WHERE CUSTODYCD = h.b_account_no)
group by 
h.trading_date,h.b_account_no,h.sec_code,
decode(h.floor_code,'02',h.price,h.price*1000)
union all --sts_order_all sell
 SELECT   h.order_date trading_date,
        h.account_no acctno,
        'S' bors,
        substr(h.order_no,1,3) sec_code,
        h.order_price price,
        SUM (h.order_qtty) qtty
 FROM   sts_order_all h
 where (h.norc = 5 OR (h.norc= 7 AND H.STATUS=4 )) --and h.oorb=1 and account_no like '091C%'
    and   h.order_date =(SELECT   TO_DATE (varvalue,'DD/MM/YYYY')
                   FROM  sysvar WHERE   varname = 'CURRDATE' AND grname = 'SYSTEM')
          AND (EXISTS
                 (SELECT   1
                    FROM   cfmast
                   WHERE   custodycd =h.account_no)
             OR h.account_no LIKE '091%')
 GROUP BY   h.order_date,
        h.account_no ,
        substr(h.order_no,1,3),
        h.order_price 
Union all  --sts_order_all buy
SELECT   h.order_date trading_date,
        h.co_account_no acctno,
        'B' bors,
        substr(h.order_no,1,3) sec_code,
        h.order_price price,
        SUM (h.order_qtty) qtty
 FROM   sts_order_all h
 where (h.norc = 5 OR (h.norc= 7 AND H.STATUS=4 )) --and h.oorb=1 and co_account_no like '091C%'
       and   h.order_date =(SELECT   TO_DATE (varvalue,'DD/MM/YYYY')
                   FROM  sysvar WHERE   varname = 'CURRDATE' AND grname = 'SYSTEM')
        AND (EXISTS
                 (SELECT   1
                    FROM   cfmast
                   WHERE   custodycd =h.co_account_no)
             OR h.co_account_no LIKE '091%')
 GROUP BY   h.order_date,
        h.co_account_no ,
        substr(h.order_no,1,3),
        h.order_price   
)
minus
select  i.txdate trading_date,i.custodycd 
acctno,i.bors,to_char(i.symbol) sec_code,
i.matchprice price, sum(i.matchqtty) qtty
from iod i
    where i.txdate = (SELECT   TO_DATE (varvalue,'DD/MM/YYYY')
                   FROM  sysvar WHERE   varname = 'CURRDATE' AND grname = 'SYSTEM')
    and i.deltd <>'Y'
group by i.txdate,i.custodycd,i.bors,i.symbol,
i.matchprice
) a, sbsecurities b where a.sec_code=b.symbol
UNION ALL -------- IOD minus trading_result
select a.trading_date,a.acctno,a.bors,a.sec_code,a.price,a.qtty, 
'FLEX KHOP' , b.tradeplace LECH from 
(
select  i.txdate trading_date,i.custodycd 
acctno,i.bors,to_char(i.symbol) sec_code,
i.matchprice price, sum(i.matchqtty) qtty 
from iod i
    where i.txdate = (SELECT   TO_DATE (varvalue,'DD/MM/YYYY')
                   FROM  sysvar WHERE   varname = 'CURRDATE' AND grname = 'SYSTEM')
    and i.deltd <>'Y'
group by i.txdate,i.custodycd ,i.bors,i.symbol ,
i.matchprice 
minus
select trading_date , acctno, bors, sec_code, price,  
qtty
from(                               
select h.trading_date,h.s_account_no acctno,'S' BORS, 
h.sec_code
,decode(h.floor_code,'02',h.price,h.price*1000) 
price,sum(h.quantity) qtty
 from trading_result h
where trading_date=(SELECT   TO_DATE (varvalue,'DD/MM/YYYY')
                   FROM  sysvar WHERE   varname = 'CURRDATE' AND grname = 'SYSTEM')
--and h.s_account_no like '091%'
and EXISTS (SELECT CUSTODYCD FROM CFMAST WHERE CUSTODYCD = h.s_account_no)
group by 
h.trading_date,h.s_account_no,h.sec_code,
decode(h.floor_code,'02',h.price,h.price*1000)
union all
select h.trading_date,h.b_account_no acctno,'B' BORS, 
h.sec_code
,decode(h.floor_code,'02',h.price,h.price*1000) 
price,sum(h.quantity) qtty
 from trading_result h
where trading_date=(SELECT   TO_DATE (varvalue,'DD/MM/YYYY')
                   FROM  sysvar WHERE   varname = 'CURRDATE' AND grname = 'SYSTEM')
--and h.b_account_no like '091%'
and EXISTS (SELECT CUSTODYCD FROM CFMAST WHERE CUSTODYCD = h.b_account_no)
group by 
h.trading_date,h.b_account_no,h.sec_code,
decode(h.floor_code,'02',h.price,h.price*1000)
union all --sts_order_all
 SELECT   h.order_date trading_date,
        h.account_no acctno,
        'S' bors,
        substr(h.order_no,1,3) sec_code,
        h.order_price price,
        SUM (h.order_qtty) qtty
 FROM   sts_order_all h
 where (h.norc = 5 OR (h.norc= 7 AND H.STATUS=4 ))-- and h.oorb=1 and account_no like '091C%'
    and   h.order_date =(SELECT   TO_DATE (varvalue,'DD/MM/YYYY')
                   FROM  sysvar WHERE   varname = 'CURRDATE' AND grname = 'SYSTEM')
          AND (EXISTS
                 (SELECT   1
                    FROM   cfmast
                   WHERE   custodycd =h.account_no)
             OR h.account_no LIKE '091%')
 GROUP BY   h.order_date,
        h.account_no ,
        substr(h.order_no,1,3),
        h.order_price 
Union all
SELECT   h.order_date trading_date,
        h.co_account_no acctno,
        'B' bors,
        substr(h.order_no,1,3) sec_code,
        h.order_price price,
        SUM (h.order_qtty) qtty
 FROM   sts_order_all h
 where (h.norc = 5 OR (h.norc= 7 AND H.STATUS=4 )) --and h.oorb=1 and co_account_no like '091C%'
       and   h.order_date =(SELECT   TO_DATE (varvalue,'DD/MM/YYYY')
                   FROM  sysvar WHERE   varname = 'CURRDATE' AND grname = 'SYSTEM')
        AND (EXISTS
                 (SELECT   1
                    FROM   cfmast
                   WHERE   custodycd =h.co_account_no)
             OR h.co_account_no LIKE '091%')
 GROUP BY   h.order_date,
        h.co_account_no ,
        substr(h.order_no,1,3),
        h.order_price   
)
) a, sbsecurities b where a.sec_code=b.symbol
) where 0=0
;

