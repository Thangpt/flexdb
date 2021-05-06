CREATE OR REPLACE FORCE VIEW STS_ORDER_ALL AS
SELECT a.order_id, a.org_order_id, a.floor_code, a.order_confirm_no,
       a.order_no, a.co_order_no, a.org_order_no, a.order_date,
       a.order_time, a.member_id, a.co_member_id, a.account_id,
       a.co_account_id, a.stock_id, a.order_type, a.priority, a.oorb,
       a.norp, a.norc, a.bore, a.aori, a.settlement_type, a.dorf,
       a.order_qtty, a.order_price, a.status, a.quote_price, a.state,
       a.quote_time, a.quote_qtty, a.exec_qtty, a.correct_qtty,
       a.cancel_qtty, a.reject_qtty, a.reject_reason, a.account_no,
       a.co_account_no, a.broker_id, a.co_broker_id, a.deleted,
       a.date_created, a.date_modified, a.modified_by, a.created_by,
       a.telephone, a.session_no, a.settle_day, a.aorc, a.yieldmat,
       a.dml_type, a.new_data
  FROM sts_orders_hnx a
 union all
 SELECT a.order_id, a.org_order_id, a.floor_code, a.order_confirm_no,
       a.order_no, a.co_order_no, a.org_order_no, a.order_date,
       a.order_time, a.member_id, a.co_member_id, a.account_id,
       a.co_account_id, a.stock_id, a.order_type, a.priority, a.oorb,
       a.norp, a.norc, a.bore, a.aori, a.settlement_type, a.dorf,
       a.order_qtty, a.order_price, a.status, a.quote_price, a.state,
       a.quote_time, a.quote_qtty, a.exec_qtty, a.correct_qtty,
       a.cancel_qtty, a.reject_qtty, a.reject_reason, a.account_no,
       a.co_account_no, a.broker_id, a.co_broker_id, a.deleted,
       a.date_created, a.date_modified, a.modified_by, a.created_by,
       a.telephone, a.session_no, a.settle_day, a.aorc, a.yieldmat,
       a.dml_type, a.new_data
  FROM sts_orders_upcom a;

