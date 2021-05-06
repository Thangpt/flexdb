CREATE OR REPLACE FORCE VIEW VW_CHECK_HSX_FO AS
SELECT o.orderid, o.symbol, o.custodycd, o.acctno, o.quote_qtty, o.quote_price
    FROM orders@dbl_fo o, instruments@dbl_fo i WHERE o.symbol = i.symbol AND i.board = 'HSX' and substatus ='BB'
    AND NOT EXISTS (SELECT order_number FROM file_1i f WHERE f.ORDER_NUMBER = o.rootorderid);

