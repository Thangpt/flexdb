CREATE OR REPLACE PROCEDURE PRC_OL_SynData

  Is

  Begin

   Delete ol_log;

   For V_Acc in (Select acctno from Afmast )

    Loop

         sp_bd_getaccountposition_ol(v_Acc.acctno);

    End loop;

   commit; 

   Delete OL_ACCOUNT_SE;

   Insert into ol_account_se  select * from VW_OL_ACCOUNT_SE;

   commit;

 End ;
/

