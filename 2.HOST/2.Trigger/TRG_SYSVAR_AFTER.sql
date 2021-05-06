CREATE OR REPLACE TRIGGER TRG_SYSVAR_AFTER
 AFTER INSERT OR UPDATE ON sysvar
REFERENCING NEW AS NEWVAL OLD AS OLDVAL
 FOR EACH ROW
DECLARE
BEGIN
   -- Dong bo tham so sang HFT
   IF updating THEN 
     IF :newval.varname IN ('PRICELIMIT', 'FEE_RATE') AND :newval.varvalue <> :oldval.varvalue THEN
       INSERT INTO t_fo_event(autoid, txnum, txdate, acctno, tltxcd, logtime, processtime, process, errcode, errmsg, nvalue, cvalue)
             VALUES (
                    seq_fo_event.NEXTVAL,
                    '',
                    '',
                    '',
                    'CHGSYSVAR',
                    SYSTIMESTAMP,
                    NULL,
                    'N',
                    '0',
                    NULL,
                    NULL,
                    :newval.varname);
     END IF;
     
     IF :newval.varname = 'HOSTATUS' AND :newval.varvalue <> :oldval.varvalue THEN
        pr_notifyhostatus2fo(:newval.varvalue);
     END IF;    
   END IF;
END;
/
