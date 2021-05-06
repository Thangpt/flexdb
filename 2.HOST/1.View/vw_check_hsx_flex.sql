CREATE OR REPLACE FORCE VIEW VW_CHECK_HSX_FLEX AS
SELECT o.orderid, od.symbol, od.custodycd, o.afacctno , o.orderqtty, o.quoteprice, o.pricetype , o.txtime
    FROM odmast o, ood od , ordermap om
    WHERE o.orderid = od.orgorderid AND od.oodstatus ='B'  AND o.orderid = om.orgorderid
    AND NOT EXISTS (SELECT order_number FROM file_1i f WHERE f.ORDER_NUMBER = om.ctci_order);

