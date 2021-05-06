CREATE OR REPLACE FORCE VIEW V_BUSTRADINGRESULT AS
(
SELECT CF.CUSTID,(CASE WHEN FLOOR_CODE='02'  THEN 'HOSTC'  WHEN FLOOR_CODE='10'  THEN 'HASTC' ELSE 'OTC' END) TRADEPLACE ,
'B' BORS,SEC_CODE,QUANTITY,PRICE,QUANTITY*PRICE AMOUNT,B_ACCOUNT_NO CUSTODYCD ,MATCH_TIME MATCHTIME,B_ORDER_NO ORDERID
FROM curr_trading_result RS ,CFMAST CF
WHERE  RS.B_ACCOUNT_NO=CF.CUSTODYCD
UNION ALL
SELECT CF.CUSTID,(CASE WHEN FLOOR_CODE='02'  THEN 'HOSTC'  WHEN FLOOR_CODE='10'  THEN 'HASTC' ELSE 'OTC' END) TRADEPLACE ,
'S' BORS,SEC_CODE,QUANTITY,PRICE,QUANTITY*PRICE AMOUNT,S_ACCOUNT_NO CUSTODYCD ,MATCH_TIME MATCHTIME ,S_ORDER_NO ORDERID
 FROM curr_trading_result RS ,CFMAST CF
WHERE  RS.S_ACCOUNT_NO=CF.CUSTODYCD
);

