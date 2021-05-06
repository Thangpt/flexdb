CREATE OR REPLACE TRIGGER "TRG_ODMAST_AFTER"
 AFTER
   INSERT OR UPDATE OF feeacr, taxsellamt, dfacctno, dfqtty, orderqtty, adjustqtty, errod, edstatus, codeid, afacctno, deltd, orstatus, execqtty, remainqtty, cancelqtty, seacctno, orderid
 ON odmast
REFERENCING NEW AS NEWVAL OLD AS OLDVAL
 FOR EACH ROW
DECLARE
    diff NUMBER(20,8);
    v_hostatus varchar2(10);
    v_errmsg varchar2(2000);
    v_custid varchar2(10);
    v_currdate date;
    v_symbol varchar2(10);
    v_debugmsg varchar2(1700);
    l_afacctno varchar2(20);
    l_seacctno varchar2(20);
    l_orderid varchar2(20);
    diff_cancel NUMBER(20,0);
    diff_exec NUMBER(20,0);
    l_err_code varchar2(100);
BEGIN
SELECT      VARVALUE
INTO        V_HOSTATUS
FROM        SYSVAR
WHERE       VARNAME = 'HOSTATUS';

IF V_HOSTATUS = '1' THEN
    /*--Begin ThongPM add cho phan day thong tin ra buffer
    l_afacctno := :newval.afacctno;
    if instr('/AB/AS/CB/CS/', :newval.exectype) > 0 then
      l_orderid := :newval.reforderid;
    else
      l_orderid := :newval.orderid;
    end if;

    msgpks_system.sp_notification_obj('ODMAST', l_orderid, l_afacctno);

    if instr('/NS/MS/SS/', :newval.exectype) > 0 then
      l_seacctno := :newval.seacctno;
      msgpks_system.sp_notification_obj('SEMAST', l_seacctno, l_afacctno);
    elsif instr('/NB/', :newval.exectype) > 0 then
      msgpks_system.sp_notification_obj('CIMAST', l_afacctno, l_afacctno);
    end if;

    Insert into OL_LOG(acctno,status,logtime,applytime)
    values (:NEWVAL.afacctno,'N',sysdate,null);
    --End ThongPM add*/

    --Begin GianhVG Log trigger for buffer
    l_afacctno := :newval.afacctno;
    if instr('/AB/AS/CB/CS/', :newval.exectype) > 0 then
      l_orderid := :newval.reforderid;
    else
      l_orderid := :newval.orderid;
    end if;
    fopks_api.pr_trg_account_log(l_orderid,'OD');

    if instr('/NS/MS/SS/', :newval.exectype) > 0 then
        fopks_api.pr_trg_account_log(:newval.seacctno,'SE');
        -- Lenh danh dau loi thi cap nhat lai buffer
        -- TheNN, 11-Oct-2012
        IF :newval.errod <> :oldval.errod THEN
            fopks_api.pr_trg_account_log(:newval.ciacctno,'CI');
        END IF;
        -- End: TheNN, 11-Oct-2012
    elsif instr('/NB/AB/', :newval.exectype) > 0 then
        fopks_api.pr_trg_account_log(:newval.ciacctno,'CI');
        if :newval.execqtty <> :oldval.execqtty then
            fopks_api.pr_trg_account_log(:newval.seacctno,'SE');
        end if;
    end if;
    --End GianhVG Log trigger for buffer


    --Gianh VG comment doan phan bo chung khoan quyen mua, dua sang trigger cua IOD de phan bo
    /*--Begin HaiLT add cho phan xu ly ban chung khoan quyen
    if updating then
        if nvl(:newval.execqtty,0) <> nvl(:oldval.execqtty,0) then
            if instr('/NS/MS/SS/', :newval.exectype) > 0 then
                cspks_caproc.pr_allocate_right_stock(:newval.orderid);
            end if;
        end if;
    end if;*/
/*
    if updating then
        --Neu la lenh ban thoa thuan tong bi huy
        if nvl(:newval.exectype,0) ='NS' and :newval.matchtype='P' and :newval.grporder='Y' and :newval.cancelqtty>0 and :newval.deltd<>'Y' then
            cspks_odproc.pr_CancelGroupOrder(:NEWval.orderid);
        end if;
    end if;
*/
    --End HaiLT add
    --Begin GianhVG Add xu ly cho lenh ban cam co, ban cam co tong
    if inserting then
        --Thuc hien ghi nhan cac deal cho lenh MS
        if :NEWval.exectype ='MS' then
            cspks_odproc.pr_MortgageSellAllocate(:NEWval.orderid,:NEWval.afacctno, :NEWval.codeid,:NEWval.dfacctno,:NEWval.orderqtty);
            if :NEWval.execqtty<>0 then
                cspks_odproc.pr_MortgageSellMatch(:NEWval.orderid,:NEWval.execqtty,:NEWval.execamt,:NEWval.afacctno, :NEWval.codeid);
            end if;
        end if;
    else
        --Thuc hien cap nhat ghi nhan cho cac deal cho lenh MS
        if :NEWval.exectype ='MS' then
            if :NEWval.deltd <> 'Y' then
                diff_cancel:=:NEWval.cancelqtty + :NEWval.adjustqtty-:OLDval.Cancelqtty-:Oldval.adjustqtty;
                if diff_cancel<>0 then
                    cspks_odproc.pr_MortgageSellRelease(:NEWval.orderid,:NEWval.afacctno, :NEWval.codeid,:NEWval.dfacctno,:NEWval.orderqtty,diff_cancel);
                end if;
                diff_exec:=:NEWval.execqtty - :Oldval.execqtty;
                if diff_exec<>0 then
                    cspks_odproc.pr_MortgageSellMatch(:NEWval.orderid,diff_exec,:NEWval.execamt - :Oldval.execamt,:NEWval.afacctno, :NEWval.codeid);
                end if;

            else
                update odmapext set deltd='Y' where orderid = :NEWval.orderid;
                if :NEWval.execqtty > 0 then
                    cspks_odproc.pr_MortgageSellMatch(:NEWval.orderid,-(:NEWval.execqtty),-(:NEWval.execamt),:NEWval.afacctno, :NEWval.codeid);
                end if;
            end if;
        end if;
    end if;
    --End GianhVG add

    if inserting then
        if instr('/NB/', :newval.exectype) > 0 then
            cspks_odproc.pr_semargininfoupdate(:newval.afacctno,:newval.codeid,:newval.remainqtty);
        end if;
    end if;
    if updating then
        if instr('/NS/MS/SS/', :newval.exectype) > 0 then
            if :newval.execqtty > :oldval.execqtty then
                cspks_odproc.pr_semargininfoupdate(:newval.afacctno,:newval.codeid,-((:newval.execqtty) - (:oldval.execqtty)) );
            end if;
        end if;
        if instr('/NB/', :newval.exectype) > 0 then
            if :newval.cancelqtty > :oldval.cancelqtty then
                cspks_odproc.pr_semargininfoupdate(:newval.afacctno,:newval.codeid,-((:newval.cancelqtty)-(:oldval.cancelqtty)));
            end if;
            --sua lenh
             if :newval.adjustqtty > :oldval.adjustqtty then
                cspks_odproc.pr_semargininfoupdate(:newval.afacctno,:newval.codeid,-((:newval.orderqtty)-(:newval.execqtty)));
            end if;
        end if;
    end if;
	--xu ly phan repo
    IF updating AND :oldval.repotype = 1 AND :newval.execqtty > :oldval.execqtty THEN
        UPDATE tbl_odrepo SET
            execqtty = :newval.execqtty,
            remainqtty = :newval.remainqtty,
            execamt = :newval.execamt
        WHERE orderid = :oldval.orderid;
    ELSIF updating AND :oldval.repotype = 2 AND :newval.execqtty > :oldval.execqtty THEN
        UPDATE tbl_odrepo SET
            execqtty2 = :newval.execqtty,
            remainqtty2 = :newval.remainqtty,
            execamt2 = :newval.execamt
        WHERE orderid2 = :oldval.orderid;
    END IF;
    --End add
END IF;
/*EXCEPTION
WHEN OTHERS THEN
    v_errmsg := substr(sqlerrm, 1, 200);
    pr_error(v_debugmsg || ' ' || v_errmsg, 'TRG_ODMAST_ACC_INFO');*/
END;
/

