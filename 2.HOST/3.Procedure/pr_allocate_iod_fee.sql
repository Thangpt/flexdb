CREATE OR REPLACE PROCEDURE pr_allocate_iod_fee (pv_orderid varchar2)
IS
    v_dblrate number;
    v_dblfeeacr number;
    v_dbliodfeeacr number;
    v_dblGapamt number;
    v_repotype  NUMBER;
    v_voucher   VARCHAR2(20);
    v_feerepo2  VARCHAR2(2);
BEGIN
    --HoangND them phan co thu phi repo lan 2 hay ko? Y là co N la khong
    SELECT varvalue INTO v_feerepo2 FROM sysvar WHERE varname = 'FEE_REPO2';
    select case when od.execamt>0 then od.feeacr/od.execamt else 0 END, repotype
            into v_dblrate, v_repotype
    from odmast od where od.orderid = pv_orderid;
    IF v_feerepo2 = 'N' THEN
        IF v_dblrate>0 AND v_repotype <> 2  THEN
                update iod set iodfeeacr = floor(v_dblrate * iod.matchprice * iod.matchqtty) where iod.orgorderid=pv_orderid;
        end if;
    ELSE
        IF v_dblrate>0 THEN
                update iod set iodfeeacr = floor(v_dblrate * iod.matchprice * iod.matchqtty) where iod.orgorderid=pv_orderid;
        end if;
    END IF;
    --end HoangND
   select max(od.feeacr), sum(iod.iodfeeacr) iodfeeacr
        into v_dblfeeacr, v_dbliodfeeacr
    from odmast od, iod
    where od.orderid = iod.orgorderid
    and od.orderid = pv_orderid and iod.deltd <> 'Y'
    group by od.orderid;

    if v_dblfeeacr>v_dbliodfeeacr then
        v_dblGapamt:=v_dblfeeacr-v_dbliodfeeacr;
        for rec in (
            select  iod.* from iod, odmast od
            where od.orderid = pv_orderid
            and iod.deltd <> 'Y'
            and iod.orgorderid= od.orderid
            and od.feeacr>0 and od.execamt>0
            order by (iod.matchqtty* iod.matchprice * od.feeacr/od.execamt - floor(iod.matchqtty* iod.matchprice * od.feeacr/od.execamt)) desc, iod.orgorderid
        )
        loop
            update iod set iodfeeacr= iodfeeacr+1 where txnum = rec.txnum and txdate = rec.txdate and orgorderid =rec.orgorderid;
            v_dblGapamt:=v_dblGapamt-1;
            EXIT when v_dblGapamt<=0;
        end loop;
    end if;
exception when others then
    return;
end;
/