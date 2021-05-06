CREATE OR REPLACE FORCE VIEW VW_CHECK_HNX_FLEX AS
SELECT o.orderid, od.symbol, od.custodycd, o.afacctno , o.orderqtty, o.quoteprice, o.pricetype , o.txtime
    FROM odmast o, ood od
    WHERE o.orderid = od.orgorderid AND od.oodstatus ='B' AND o.pricetype ='LO'
    AND NOT EXISTS (SELECT 1 FROM   sts_orders_hnx sts, sts_stocks_info sif
                            WHERE   sts.stock_id = sif.stock_info_id
                               AND  sts.order_price =o.quoteprice
                               AND  sts.account_no = od.custodycd
                               AND  sif.code = od.symbol
                               AND  sts.order_qtty = o.orderqtty
                               AND  decode(o.exectype,'NB','1','2') = sts.oorb
                               )
UNION ALL  --ATC
SELECT o.orderid, od.symbol, od.custodycd, o.afacctno , o.orderqtty, o.quoteprice , o.pricetype , o.txtime
    FROM odmast o, ood od
    WHERE o.orderid = od.orgorderid AND od.oodstatus ='B' AND o.pricetype ='ATC'
    AND NOT EXISTS (SELECT 1 FROM   sts_orders_hnx sts, sts_stocks_info sif
                            WHERE   sts.stock_id = sif.stock_info_id
                               AND  sts.order_price ='0'
                               AND  sts.account_no = od.custodycd
                               AND  sif.code = od.symbol
                               AND  sts.order_qtty = o.orderqtty
                               AND  decode(o.exectype,'NB','1','2') = sts.oorb
                               )
;

