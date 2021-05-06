CREATE OR REPLACE PROCEDURE pr_cancel_order_reject(p_orderid VARCHAR2) IS
BEGIN
   
    update odmast set cancelqtty = remainqtty, remainqtty = 0 , edstatus = 'W' where orderid = p_orderid;
END;
/

