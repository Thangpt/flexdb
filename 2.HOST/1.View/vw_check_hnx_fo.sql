CREATE OR REPLACE FORCE VIEW VW_CHECK_HNX_FO AS
SELECT o.orderid, o.symbol, o.custodycd, o.acctno, o.quote_qtty, o.quote_price,  o.subside
FROM orders@dbl_fo o, instruments@dbl_fo i WHERE o.symbol = i.symbol AND i.board IN  ('HNX','UPCOM') and substatus ='BB'
AND o.subtypecd ='LO'
AND NOT EXISTS
    (SELECT 1 FROM   sts_orders_hnx sts, sts_stocks_info sif
                            WHERE   sts.stock_id = sif.stock_info_id
                               AND  sts.order_price =o.quote_price
                               AND  sts.account_no = o.custodycd
                               AND  sif.code = o.symbol
                               AND  sts.order_qtty = o.quote_qtty
                               AND  decode(o.subside,'NB','1','2') = sts.oorb
                               )
UNION ALL  --ATC
SELECT o.orderid, o.symbol, o.custodycd, o.acctno, o.quote_qtty, o.quote_price,  o.subside
FROM orders@dbl_fo o, instruments@dbl_fo i WHERE o.symbol = i.symbol AND i.board IN  ('HNX','UPCOM') and substatus ='BB'
AND o.subtypecd ='ATC'
    AND NOT EXISTS (SELECT 1 FROM   sts_orders_hnx sts, sts_stocks_info sif
                            WHERE   sts.stock_id = sif.stock_info_id
                               AND  sts.order_price ='0'
                               AND  sts.account_no = o.custodycd
                               AND  sif.code = o.symbol
                               AND  sts.order_qtty = o.quote_qtty
                               AND  decode(o.subside,'NB','1','2') = sts.oorb
                               )
;

