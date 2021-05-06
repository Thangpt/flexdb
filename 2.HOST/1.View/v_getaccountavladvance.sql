create or replace force view v_getaccountavladvance as
(
    select afacctno,aamt, (case when autoadv = 'Y' then depoamt-paidamt else least(depoamt-paidamt,0) end)  depoamt,
    depoamt_T0 advamt_T0,
    paidamt, depoamt advamt from (
    select  sts.afacctno,sum(sts.aamt) aamt,
        sum(
            greatest(
                floor(
                    least(
                        (sts.amt - exfeeamt)*(1-(sts.days*ADVRATE/100/360+sts.days*ADVBANKRATE/100/360)),
                        (sts.amt - exfeeamt)*(1-sts.days*ADVBANKRATE/100/360)-sts.ADVMINFEE,
                        (sts.amt - exfeeamt)*(1-sts.days*ADVRATE/100/360)-sts.ADVMINFEEBANK,
                        (sts.amt - exfeeamt-sts.ADVMINFEE-sts.ADVMINFEEBANK)
                    )
                )
            ,0)
        ) depoamt,
        sum(
        CASE WHEN txdate = TO_DATE(sy2.varvalue, 'DD/MM/RRRR') THEN
            greatest(
                floor(
                    least(
                        (sts.amt - exfeeamt)*(1-(sts.days*ADVRATE/100/360+sts.days*ADVBANKRATE/100/360)),
                        (sts.amt - exfeeamt)*(1-sts.days*ADVBANKRATE/100/360)-sts.ADVMINFEE,
                        (sts.amt - exfeeamt)*(1-sts.days*ADVRATE/100/360)-sts.ADVMINFEEBANK,
                        (sts.amt - exfeeamt-sts.ADVMINFEE-sts.ADVMINFEEBANK)
                    )
                )
            ,0)
          ELSE 0 END
        ) depoamt_T0
        ,sum(rightvat) rightvat,
        max(case when sy.varvalue='0' then 0 else 0/*fn_getdealgrppaid(sts.afacctno)*/ end) paidamt,
        max(case when sy.varvalue='0' then 0 else 0/*fn_getdealgrppaid(sts.afacctno)*/ end) paidamt_T0
        , autoadv
    from
        v_advanceSchedule sts, --where AUTOADV='Y'
        sysvar sy,
        sysvar sy2
    where sy.grname = 'SYSTEM' and sy.varname ='HOSTATUS'
    AND sy2.grname = 'SYSTEM' and sy2.varname ='CURRDATE'
    group by sts.afacctno, autoadv)
)
;

