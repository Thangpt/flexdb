CREATE OR REPLACE PROCEDURE pr_externalupdateafmast(pv_err_code in out varchar2, pv_acctno in varchar2, pv_applyacctno in varchar2, pv_tlmakerid in varchar2)
is
v_custid varchar2(20);
v_mrtype char(1);
v_corebank char(1);
v_txnum varchar(10);
v_currentdate date;
v_recheckbm number;
v_recheckdsf number;
v_dsftemp varchar(14);
v_brtemp varchar(14);
begin
    --Cap nhat thong tin tu khach hang sang tieu khoan.
    --select custid into v_custid from afmast where acctno = pv_acctno;
    SELECT TO_DATE (varvalue, systemnums.c_date_format)
               INTO v_currentdate
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    select af.custid, mrt.mrtype, af.corebank into v_custid , v_mrtype, v_corebank from afmast af, aftype aft, mrtype mrt
    where af.actype = aft.actype and aft.mrtype= mrt.actype
    and af.acctno = pv_acctno;
    --Cap nhat cho Ung truoc tu dong
    if v_corebank <> 'Y' and v_mrtype='N' then
        for rec in (
        select af.autoadv
        from afmast af, aftype aft, mrtype mrt
            where af.actype = aft.actype and aft.mrtype= mrt.actype
            --and af.corebank <>'Y' and mrt.mrtype ='N'
            and af.acctno=pv_applyacctno)
        loop
            update afmast set autoadv= rec.autoadv where acctno = pv_acctno;
        end loop;
    end if;

    for rec in (select * from afmast where acctno=pv_applyacctno)
    loop
        --Dich vu SMS
        insert into AFTEMPLATES (autoid, afacctno, template_code)
        select seq_AFTEMPLATES.nextval , pv_acctno afacctno, template_code from AFTEMPLATES where afacctno =rec.acctno;
        --Thong tin uy quyen
        INSERT INTO cfauth (AUTOID,ACCTNO,CUSTID,FULLNAME,ADDRESS,TELEPHONE,LICENSENO,VALDATE,EXPDATE,DELTD,LINKAUTH,SIGNATURE,ACCOUNTNAME,BANKACCOUNT,BANKNAME,LNPLACE,LNIDDATE)
        select seq_cfauth.nextval, pv_acctno ACCTNO,CUSTID,FULLNAME,ADDRESS,TELEPHONE,LICENSENO,VALDATE,EXPDATE,DELTD,LINKAUTH,SIGNATURE,ACCOUNTNAME,BANKACCOUNT,BANKNAME,LNPLACE,LNIDDATE
        from cfauth where acctno =rec.acctno;
        --GD qua ?
        --Giao dich Online
        update afmast set tradefloor=rec.tradefloor, tradetelephone=rec.tradetelephone, tradeonline= rec.tradeonline
        where acctno =pv_acctno;
        --Thong tin chuyen khoan
        INSERT INTO cfotheracc (AUTOID,AFACCTNO,CIACCOUNT,CINAME,CUSTID,BANKACC,BANKACNAME,BANKNAME,TYPE,ACNIDCODE,ACNIDDATE,ACNIDPLACE,FEECD,CITYEF,CITYBANK, VIA, USERNAME, TLID, CREATEDATE, BANKID, BANKORGNO )
        select seq_cfotheracc.nextval, pv_acctno AFACCTNO,CIACCOUNT,CINAME,CUSTID,BANKACC,BANKACNAME,BANKNAME,TYPE,ACNIDCODE,ACNIDDATE,ACNIDPLACE,FEECD,CITYEF,CITYBANK, VIA, USERNAME, null, sysdate, BANKID, BANKORGNO
        from cfotheracc where afacctno = rec.acctno;
        --TT dang ky dich vu giao dich truc tuyen
        -- 1.5.3.0bo di vi lam theo tai khoan
        --INSERT INTO otright (AUTOID,AFACCTNO,AUTHCUSTID,AUTHTYPE,VALDATE,EXPDATE,DELTD,LASTDATE,LASTCHANGE)
        --select seq_otright.nextval,pv_acctno AFACCTNO,AUTHCUSTID,AUTHTYPE,VALDATE,EXPDATE,DELTD,LASTDATE,sysdate
        --from otright where afacctno =  rec.acctno;
       -- INSERT INTO otrightdtl (AUTOID,AFACCTNO,AUTHCUSTID,OTMNCODE,OTRIGHT,DELTD)
        --select seq_otrightdtl.nextval,pv_acctno AFACCTNO,AUTHCUSTID,OTMNCODE,OTRIGHT,DELTD
        --from otrightdtl where AFACCTNO = rec.acctno;
        --thong tin moi gioi
        plog.error('pr_externalupdateafmast begin insert reaflnk: ' || pv_acctno);
        select nvl(count(*),0) into v_recheckbm from reaflnk re, retype rt
            where substr(re.reacctno,11,4) = rt.actype and rt.rerole in ('BM','RM') and re.afacctno = rec.acctno and re.status = 'A';
        if v_recheckbm = 0 then
            select brtemp into v_brtemp from afmast where acctno = rec.acctno;
            update afmast set brtemp = v_brtemp where acctno = pv_acctno;

            INSERT INTO maintain_log (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY,MAKER_TIME)
            VALUES('AFMAST','ACCTNO = '''|| pv_acctno ||'''',pv_tlmakerid,TO_DATE(v_currentdate, systemnums.C_DATE_FORMAT),'Y',null,null,0,'BRTEMP',NULL,v_brtemp,'ADD',NULL,NULL,to_char(sysdate,systemnums.C_TIME_FORMAT));
        else
            select re.reacctno into v_brtemp from reaflnk re, retype rt
                where substr(re.reacctno,11,4) = rt.actype and rt.rerole in ('BM','RM') and re.afacctno = rec.acctno and re.status = 'A';
            update afmast set brtemp = v_brtemp where acctno = pv_acctno;

            INSERT INTO maintain_log (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY,MAKER_TIME)
            VALUES('AFMAST','ACCTNO = '''|| pv_acctno ||'''',pv_tlmakerid,TO_DATE(v_currentdate, systemnums.C_DATE_FORMAT),'Y',null,null,0,'BRTEMP',NULL,v_brtemp,'ADD',NULL,NULL,to_char(sysdate,systemnums.C_TIME_FORMAT));
        end if;


        select nvl(count(*),0) into v_recheckdsf from reaflnk re, retype rt
            where substr(re.reacctno,11,4) = rt.actype and rt.rerole in ('RD') and re.afacctno = rec.acctno and re.status = 'A';
        if v_recheckdsf = 0 then
            select dsftemp into v_dsftemp from afmast where acctno = rec.acctno;
            update afmast set dsftemp = v_dsftemp where acctno = pv_acctno;

            INSERT INTO maintain_log (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY,MAKER_TIME)
            VALUES('AFMAST','ACCTNO = '''|| pv_acctno ||'''',pv_tlmakerid,TO_DATE(v_currentdate, systemnums.C_DATE_FORMAT),'Y',null,null,0,'DSFTEMP',NULL,v_dsftemp,'ADD',NULL,NULL,to_char(sysdate,systemnums.C_TIME_FORMAT));
        else
            select re.reacctno into v_dsftemp from reaflnk re, retype rt
                where substr(re.reacctno,11,4) = rt.actype and rt.rerole in ('RD') and re.afacctno = rec.acctno and re.status = 'A';
            update afmast set dsftemp = v_dsftemp where acctno = pv_acctno;

            INSERT INTO maintain_log (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY,MAKER_TIME)
            VALUES('AFMAST','ACCTNO = '''|| pv_acctno ||'''',pv_tlmakerid,TO_DATE(v_currentdate, systemnums.C_DATE_FORMAT),'Y',null,null,0,'DSFTEMP',NULL,v_dsftemp,'ADD',NULL,NULL,to_char(sysdate,systemnums.C_TIME_FORMAT));
        end if;

        --select nvl(dsftemp,''), nvl(brtemp,'') into v_dsftemp, v_brtemp from afmast where acctno = rec.acctno;
        --update afmast set dsftemp = v_dsftemp, brtemp = v_brtemp where acctno = pv_acctno;
        --neu tai khoan da them moi gioi thi khong add nua

        Return;--Chi cap nhat dich vu theo tai khoan dau tien
    end loop;
end;
/
