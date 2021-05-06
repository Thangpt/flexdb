DELETE FROM fotxformat WHERE TXCODE ='tx5101';

INSERT INTO fotxformat (TXCODE,MSGFORMAT,STATUS) 
VALUES('tx5101','{"msgtype" : "<$MSGTYPE>", "acctno" : "<$ACCTNO>", "actype" : "<$ACTYPE>", "custid" : "<$CUSTID>", "dof" : "<$DOF>", "grname" : "<$GRNAME>", "policycd" : "<$POLICYCD>", "poolid" : "<$POOLID>", "roomid" : "<$ROOMID>", "acclass" : "<$ACCLASS>", "custodycd" : "<$CUSTODYCD>", "formulacd" : "<$FORMULACD>", "basketid" : "<$BASKETID>", "status" : "<$STATUS>", "trfbuyamt" : <$TRFBUYAMT>, "trfbuyext" : <$TRFBUYEXT>, "banklink" : "<$BANKLINK>", "bankacctno" : "<$BANKACCTNO>", "bankcode" : "<$BANKCODE>", "rate_brk_s" : <$RATE_BRK_S>, "rate_brk_b" : <$RATE_BRK_B>, "rate_tax" : <$RATE_TAX>, "rate_adv" : <$RATE_ADV>, "ratio_init" : <$RATIO_INIT>, "ratio_main" : <$RATIO_MAIN>, "ratio_exec" : <$RATIO_EXEC>, "rate_ub" : <$RATE_UB>,"basketid_ub" : "<$BASKETID_UB>","bod_d_margin_ub" : <$BOD_D_MARGIN_UB>,"bod_t0value" : <$BOD_T0VALUE>
}','Y');

COMMIT;
