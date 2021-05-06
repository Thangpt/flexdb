CREATE OR REPLACE PROCEDURE sp_trade_allocating IS

BEGIN
    
    while(cspks_system.fn_get_sysvar('SYSTEM','GXJBS_STATUS')='Y') loop

        dbms_lock.sleep(1/10);

        begin
            trdpks_auto.pr_trade_allocating;
        end;

    end loop;
      
END;
/

