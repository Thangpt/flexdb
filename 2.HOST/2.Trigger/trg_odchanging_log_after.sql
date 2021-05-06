CREATE OR REPLACE TRIGGER trg_odchanging_log_after
 AFTER
  INSERT
 ON odchanging_trigger_log
REFERENCING NEW AS NEWVAL OLD AS OLDVAL
 FOR EACH ROW
declare
l_err_code varchar2(100);
l_fomode    VARCHAR2(10);
l_afmode    VARCHAR2(10);
begin
    -- Danh dau nguon Pool/Room.
    plog.debug('TRG_ODMAST_AFTER:'||'Into inserting fn_markedafpralloc, match orderid:'||:newval.orderid);
    if inserting then
        plog.debug('TRG_ODMAST_AFTER:'||'Inside inserting fn_markedafpralloc, match orderid:'||:newval.orderid);
        SELECT nvl(varvalue,'OFF') INTO l_fomode FROM sysvar WHERE varname = 'FOMODE';
        SELECT nvl(af.isfo,'N') INTO l_afmode FROM afmast af WHERE acctno = :newval.afacctno;

        if instr('/M/', :newval.actionflag) > 0 then
                -- Begin Danh sau tai san LINHLNB
            begin
                IF l_fomode = 'OFF' OR l_afmode = 'N' THEN
                    for rec in
                    (
                        select nvl(sum(case when restype = 'M' then prinused else 0 end),0) prinused,
                                nvl(sum(case when restype = 'S' then prinused else 0 end),0) sy_prinused
                            from vw_afpralloc_all
                        where afacctno = :newval.afacctno and codeid = :newval.codeid
                    )
                    loop
                        INSERT INTO afpralloc (AUTOID,AFACCTNO,PRINUSED,CODEID,ALLOCTYP,ORGORDERID,TXDATE,TXNUM,RESTYPE)
                            VALUES(seq_afpralloc.nextval,:newval.afacctno,
                                -least(nvl(:newval.qtty,0), rec.sy_prinused),:newval.codeid,'M',null,
                                :newval.txdate, :newval.txnum,'S');


                        INSERT INTO afpralloc (AUTOID,AFACCTNO,PRINUSED,CODEID,ALLOCTYP,ORGORDERID,TXDATE,TXNUM,RESTYPE)
                            VALUES(seq_afpralloc.nextval,:newval.afacctno,
                                -least(nvl(:newval.qtty,0), rec.prinused),:newval.codeid,'M',null,
                                :newval.txdate, :newval.txnum,'M');
                    end loop;
                    pr_error('KhopLenh','Begin fn_markedafpralloc');
                    if fn_markedafpralloc(:newval.afacctno,
                                    null,
                                    'A',
                                    'T',
                                    :newval.orderid,
                                    'N',
                                    'N',
                                    :newval.txdate,
                                    :newval.txnum,
                                    l_err_code) <> systemnums.C_SUCCESS then
                       -- pr_error('KhopLenh','End fn_markedafpralloc Loi');
                        plog.debug('TRG_ODMAST_AFTER:'||'Error when fn_markedafpralloc, match orderid:'||:newval.orderid);
                    end if;
                    pr_error('KhopLenh','Begin fn_markedafpralloc');
                END IF;
            -- Xu ly Pool:
                if txpks_prchk.fn_SecuredUpdate('C', nvl(:newval.amt,0),
                        :newval.afacctno, :newval.txnum, :newval.txdate, l_err_code) <> systemnums.c_success then
                    plog.debug('TRG_ODMAST_AFTER:'||'Error when txpks_prchk.fn_SecuredUpdate, match orderid:'|| :newval.orderid);
                end if;
                -- End Danh dau tai san LINHLNB
            exception when others then
                null;
            end;
        end if;
        if instr('/C/', :newval.actionflag) > 0 then
            -- Begin Danh sau tai san LINHLNB
            --Danh dau room
            if fn_markedafpralloc(:newval.afacctno,
                        null,
                        'A',
                        'T',
                        :newval.orderid,
                        'N',
                        'N',
                        :newval.txdate,
                        :newval.txnum,
                        l_err_code) <> systemnums.C_SUCCESS then
                plog.debug('TRG_ODMAST_AFTER:'||'Error when fn_markedafpralloc, cancel orderid:'||:newval.orderid);
            end if;
            -- Xu ly Pool:
            if txpks_prchk.fn_SecuredUpdate('C',
                        nvl(:newval.amt,0)
                        , :newval.afacctno, :newval.txnum, :newval.txdate, l_err_code) <> systemnums.c_success then
                plog.debug('TRG_ODMAST_AFTER:'||'Error when txpks_prchk.fn_SecuredUpdate, cancel orderid:'||:newval.orderid);
            end if;
            -- End Danh dau tai san LINHLNB
        end if;
    end if;
    -- End Danh dau nguon Pool/Room.
end;
/

