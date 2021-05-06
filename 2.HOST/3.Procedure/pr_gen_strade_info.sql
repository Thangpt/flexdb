CREATE OR REPLACE PROCEDURE pr_gen_strade_info
   IS
   v_errmsg varchar2(2000);
BEGIN
DELETE mttb_acc_ci_info;
DELETE mttb_acc_se_info;

INSERT INTO mttb_acc_se_info
       (custid, custodycd, symbol, trade_qtty,
       dealfinancing_qtty, blocked, securities_receiving_t0,
       securities_receiving_t1, securities_receiving_t2,
       securities_receiving_t3, securities_receiving_tn,
       securities_sending_t0, securities_sending_t1,
       securities_sending_t2, securities_sending_t3,
       securities_sending_tn, securities_stock_dividend, securities_stock_rightoff, last_change)
       
SELECT      CUSTID, CUSTODYCD, SYMBOL, TRADE_QTTY, DEALFINANCING_QTTY, BLOCKED, 
    SECURITIES_RECEIVING_T0, SECURITIES_RECEIVING_T1, SECURITIES_RECEIVING_T2, 
    SECURITIES_RECEIVING_T3, SECURITIES_RECEIVING_TN, SECURITIES_SENDING_T0, 
    SECURITIES_SENDING_T1, SECURITIES_SENDING_T2, SECURITIES_SENDING_T3, SECURITIES_SENDING_TN, 
    SECURITIES_STOCK_DIVIDEND, SECURITIES_STOCK_RIGHTOFF, LAST_CHANGE
FROM        VW_STRADE_SUBACCOUNT_SE A;

INSERT INTO mttb_acc_ci_info
    (custid, custodycd, cash_on_hand, outstanding, avlcash,
       purchasingpower, avail_advanced_bal, advanced_balance,
       pending_advanced_bal, org_cash_receiving_t0,
       org_cash_receiving_t1, org_cash_receiving_t2,
       org_cash_receiving_t3, org_cash_receiving_tn,
       cash_adv_receiving_t0, cash_adv_receiving_t1,
       cash_adv_receiving_t2, cash_adv_receiving_t3,
       cash_adv_receiving_tn, cash_receiving_t0,
       cash_receiving_t1, cash_receiving_t2, cash_receiving_t3,
       cash_receiving_tn, cash_sending_t0, cash_sending_t1,
       cash_sending_t2, cash_sending_t3, cash_sending_tn,
       avl_advance_t1, avl_advance_t2, avl_advance_t3,
       ca_receving_cash_dividend, last_change)
select      A.*
FROM        VW_STRADE_SUBACCOUNT_CI A;

EXCEPTION
    WHEN OTHERS THEN
    v_errmsg := substr(sqlerrm, 1, 2000);
    pr_error(v_errmsg, 'PR_GEN_STRADE_INFO');
END;
/

