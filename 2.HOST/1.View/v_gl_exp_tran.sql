CREATE OR REPLACE FORCE VIEW V_GL_EXP_TRAN AS
SELECT a.ref, to_char(a.txdate,'YYYY-MM-DD' ) TXDATE , a.txnum,to_char(a.busdate,'YYYY-MM-DD' ) busdate, a.custid, a.custodycd,
       a.custodycd_debit, a.custodycd_credit, a.bankid, a.trans_type,
       a.amount, a.symbol, a.symbol_qtty, a.symbol_price, a.costprice,
       a.txbrid, a.brid, a.tradeplace, a.iscorebank, a.status,
       a.custatcom, a.custtype, a.country, a.sectype, a.note,a.bankname,a.fullname
  FROM gl_exp_tran a;

