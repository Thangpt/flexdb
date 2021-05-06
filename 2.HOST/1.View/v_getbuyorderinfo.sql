CREATE OR REPLACE VIEW V_GETBUYORDERINFO
(overamt, afacctno, advamt, secureamt, buyamt, buyfeeacr, execbuyamt, execbuyamtfee, trft0amt, trfexeamt, trfsecuredamt, trft0addamt, trfbuyamt_in, trfbuyamt_over, trft0amt_over, trfbuyamtnofee_in, trfbuyamtnofee)
AS
(select nvl(a.overamt,0) + nvl(aboveramt,0) overamt, af.acctno afacctno,
        case when hosts=0 then 0 else greatest(nvl(a.overamt,0) + nvl(aboveramt,0) - greatest(af.mrcrlimitmax-ci.dfodamt,0),0) end advamt,
        case when hosts=0 then nvl(execbuyamt,0) else nvl(a.secureamt,0) + nvl(b.absecured,0) end secureamt,
        case when hosts=0 then nvl(execbuyamtnofee,0) else nvl(buyamtnofee,0) + nvl(absecurednofee,0) end buyamt,
        case when hosts=0 then nvl(execbuyamtfee,0) else (nvl(buyfeeacr,0)+ nvl(abfeeacr,0)) end buyfeeacr,
        nvl(execbuyamt,0), nvl(execbuyamtfee,0) execbuyamtfee, nvl(c.trft0amt,0) trft0amt, nvl(c.trfexeamt,0) trfexeamt, nvl(c.trfsecuredamt,0) trfsecuredamt,
        nvl(c.trft0addamt,0) trft0addamt, nvl(c.trfbuyamt_in,0) trfbuyamt_in, nvl(c.trfbuyamt_over,0) trfbuyamt_in, nvl(trft0amt_over,0) trft0amt_over,
        nvl(trfbuyamtnofee_in,0) trfbuyamtnofee_in, nvl(trfbuyamtnofee,0) trfbuyamtnofee
    from
    (SELECT
            SUM (  quoteprice * remainqtty * (1 + typ.deffeerate / 100-od.bratio/100)
                        + execamt* (1-(case when execqtty<=0 then 0 else dfqtty/execqtty end)) * (1 + typ.deffeerate / 100-od.bratio/100)   ) overamt,
            round(SUM (    quoteprice* remainqtty* (od.bratio/100)
                        + execamt * (od.bratio/100)
                        + execamt * (case when execqtty<=0 then 0 else dfqtty/execqtty end) * (1 + typ.deffeerate / 100 - od.bratio/100) ),0) secureamt,
            sum(od.execamt+od.feeacr) execbuyamt,
            sum(od.execamt) execbuyamtnofee,
            sum(od.execamt + od.quoteprice * od.remainqtty) buyamtnofee,
            sum((od.execamt + od.quoteprice * od.remainqtty) * typ.deffeerate/100) buyfeeacr,
            sum(od.feeacr) execbuyamtfee,
            od.afacctno afacctno,
            to_number(nvl(max(sy_HOSTATUS.varvalue),0)) hosts
    FROM odmast od, odtype typ, sysvar sy_HOSTATUS, sysvar sy_CURRDATE
   WHERE od.actype = typ.actype
     AND od.txdate = to_date(sy_CURRDATE.VARVALUE,'DD/MM/RRRR')
     AND deltd <> 'Y'
     AND od.exectype IN ('NB', 'BC')
     and od.stsstatus <> 'C'
     --AND od.errod = 'N'
     and sy_HOSTATUS.grname='SYSTEM' and sy_HOSTATUS.varname='HOSTATUS'
     and sy_CURRDATE.grname='SYSTEM' and sy_CURRDATE.varname='CURRDATE'
     group by od.afacctno) A,
     (select od.afacctno,
        --sum(greatest(od.ORDERQTTY * od.BRATIO/100 * (od.QUOTEPRICE - org.QUOTEPRICE), 0)) absecured,
        sum(greatest((od.remainqtty+od.execqtty-org.execqtty) * od.BRATIO/100 * od.QUOTEPRICE - org.remainqtty * org.QUOTEPRICE * org.BRATIO/100  ,0)) absecured,
        --sum(greatest(od.ORDERQTTY * (od.QUOTEPRICE - org.QUOTEPRICE), 0)) absecurednofee,
        sum(greatest((od.remainqtty+od.execqtty-org.execqtty) * od.QUOTEPRICE - org.remainqtty * org.QUOTEPRICE ,0)) absecurednofee,
        --sum(greatest(od.ORDERQTTY * (od.QUOTEPRICE - org.QUOTEPRICE), 0) * typ.deffeerate / 100) abfeeacr,
        sum(greatest((od.remainqtty+od.execqtty-org.execqtty) *  typ.deffeerate/100 * od.QUOTEPRICE - org.remainqtty * org.QUOTEPRICE *  typ.deffeerate/100  ,0))  abfeeacr,
        --sum(greatest(od.ORDERQTTY * (1 + typ.deffeerate / 100-od.BRATIO/100) * (od.QUOTEPRICE - org.QUOTEPRICE), 0)) aboveramt
        sum(greatest((od.remainqtty+od.execqtty-org.execqtty)* (1 + typ.deffeerate / 100-od.BRATIO/100) * od.QUOTEPRICE - org.remainqtty * org.QUOTEPRICE * (1 + typ.deffeerate / 100-od.BRATIO/100)  ,0))  aboveramt
         from odmast od,odmast org, ood, odtype typ
        where od.orderid=ood.orgorderid
            and od.REFORDERID=org.orderid
            and od.actype=typ.actype
            and OODSTATUS='N' and od.exectype ='AB'
            and od.deltd <> 'Y' and org.deltd <>'Y'
            group by od.afacctno
      ) B,
      (select sts.afacctno,
            sum(trft0amt) trft0amt,
            sum(case when to_date(sy_CURRDATE.varvalue,'DD/MM/RRRR') < sts.trfbuydt then
                            amt else 0 end) trfbuyamtnofee_in,
            sum(amt) trfbuyamtnofee,
            min(0) trft0addamt, -- Tham so nay reset ve 0 de khoi sua cac cong thuc lien quan.
            sum(case when to_date(sy_CURRDATE.varvalue,'DD/MM/RRRR') = sts.trfbuydt
                                and to_date(sy_CURRDATE.varvalue,'DD/MM/RRRR') <> sts.txdate
                        then trft0amt else 0 end) trft0amt_over,
            sum(trfexeamt) trfexeamt, --so tien da cat thanh toan
            sum(greatest(amt-aamt+feeacr-feeamt-trft0amt -trfexeamt,0)) trfsecuredamt, --kyquy PP0 (co.c)
            sum(case when to_date(sy_CURRDATE.varvalue,'DD/MM/RRRR') < sts.trfbuydt then
                            amt-aamt+feeacr-feeamt-trfexeamt
                     else 0
                end) trfbuyamt_in,
            sum(case when to_date(sy_CURRDATE.varvalue,'DD/MM/RRRR') = sts.trfbuydt
                                and to_date(sy_CURRDATE.varvalue,'DD/MM/RRRR') <> sts.txdate
                        then amt-aamt+feeacr-feeamt-trfexeamt else 0 end) trfbuyamt_over
        from stschd sts, odmast od, sysvar sy_CURRDATE
        where sts.orgorderid = od.orderid and duetype = 'SM' and sts.deltd <> 'Y' and trfbuyrate > 0 and trfbuyext > 0 and trfbuysts <> 'Y'
            and sy_CURRDATE.grname='SYSTEM' and sy_CURRDATE.varname='CURRDATE'
            and sts.status = 'C'
            --AND od.errod = 'N'
            and to_date(sy_CURRDATE.varvalue,'DD/MM/RRRR') <= nvl(sts.trfbuydt,to_date(sy_CURRDATE.varvalue,'DD/MM/RRRR'))
        group by sts.afacctno) C,
      afmast af, cimast ci
    where af.acctno = ci.afacctno
        and af.acctno = a.afacctno
        and af.acctno = b.afacctno(+)
        and af.acctno = c.afacctno(+)
)
;
