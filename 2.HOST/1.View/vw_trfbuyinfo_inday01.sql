create or replace force view vw_trfbuyinfo_inday01 as
select od.afacctno,
            least(sum(case when nvl(sts.trfbuyrate,0) * nvl(sts.trfbuyext,0) > 0
                                then sts.amt * (odt.deffeerate/100) + nvl(sts.amt,0) * nvl(sts.trfbuyrate,0) /100
                        else 0 end
                    + case when af.trfbuyrate * af.trfbuyext > 0 and sy_HOSTATUS.varvalue = '1'
                                then (od.remainqtty * od.quoteprice ) * (odt.deffeerate/100) + (od.remainqtty * od.quoteprice ) * af.trfbuyrate /100
                        else 0 end
                    ), max(af.advanceline - nvl(b.trft0amt,0))) TRFT0AMT_INDAY,

            sum(case when af.trfbuyrate * af.trfbuyext > 0 then (od.remainqtty * od.quoteprice) * (1+odt.deffeerate/100)
                    else 0 end
                + case when sts.trfbuyrate * sts.trfbuyext > 0 and sy_HOSTATUS.varvalue = '1' then nvl(sts.amt,0) * (1+odt.deffeerate/100)
                    else 0 end)
            - least(sum(case when nvl(sts.trfbuyrate,0) * nvl(sts.trfbuyext,0) > 0
                                then nvl(sts.amt,0) * (odt.deffeerate/100) + nvl(sts.amt,0) * nvl(sts.trfbuyrate,0) /100
                        else 0 end
                        + case when af.trfbuyrate * af.trfbuyext > 0 and sy_HOSTATUS.varvalue = '1'
                                then (od.remainqtty * od.quoteprice ) * (odt.deffeerate/100) + (od.remainqtty * od.quoteprice ) * af.trfbuyrate /100
                        else 0 end), max(af.advanceline - nvl(b.trft0amt,0)))
            TRFSECUREDAMT_INDAY,

            sum(case when af.trfbuyrate * af.trfbuyext = 0  and sy_HOSTATUS.varvalue = '1' then (od.remainqtty * od.quoteprice ) * (1+odt.deffeerate/100) else 0 end
                + case when nvl(sts.trfbuyrate,0) * nvl(sts.trfbuyext,0) = 0 then nvl(sts.amt,0) * (1+odt.deffeerate/100) else 0 end) SECUREAMT_INDAY

        from afmast af, (select * from stschd where duetype = 'SM') sts, odmast od, odtype odt, sysvar sy_CURRDATE,sysvar sy_HOSTATUS, v_getbuyorderinfo b
        where af.acctno = od.afacctno and af.acctno = b.afacctno(+) and sts.orgorderid(+) = od.orderid and od.actype = odt.actype
            and sy_CURRDATE.grname='SYSTEM' and sy_CURRDATE.varname='CURRDATE'
            and sy_HOSTATUS.grname='SYSTEM' and sy_HOSTATUS.varname='HOSTATUS'
            and od.txdate = to_date(sy_CURRDATE.varvalue,'DD/MM/RRRR') and od.deltd <> 'Y' and od.exectype in ('NB')
            and to_date(sy_CURRDATE.varvalue,'DD/MM/RRRR') <= nvl(sts.trfbuydt,to_date(sy_CURRDATE.varvalue,'DD/MM/RRRR'))
        group by od.afacctno;

