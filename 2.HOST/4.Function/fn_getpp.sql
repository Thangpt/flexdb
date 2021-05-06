CREATE OR REPLACE FUNCTION fn_getpp(pv_afacctno varchar2)
return number
is
    v_pp number;
    v_avladvance number;
    v_paidamt number;
    v_trfsecuredamt number;
    v_trft0addamt   number;
    v_buyamt    number;
    v_buyfeeacr number;
    l_count number;
    l_isChkSysCtrlDefault char(1);
    v_currdate date;
    l_ADVSELLDUTY number;
    l_ADVVATDUTY number;
    l_AUTOADV char(1);
    l_advrate   number;
    l_advbankrate number;
    l_advminfeebank number;
    l_advminfee number;
    l_custatcom char(1);
    l_trfbuyrate number;
    l_mrcrlimit number;
    l_mrcrlimitmax number;
    l_actype varchar2(10);
    l_mriratio number;
    l_margintype char(1);
    l_cimastcheck_arr txpks_check.cimastcheck_arrtype;
    l_isstopadv       varchar2(10);
BEGIN
l_isstopadv := cspks_system.fn_get_sysvar('MARGIN','ISSTOPADV');
v_pp:=0;
l_custatcom:='N';
select to_date(varvalue,'dd/mm/rrrr') into v_currdate from sysvar where grname ='SYSTEM' and varname ='CURRDATE';
select count(1)
     into l_count
from afmast af
where af.acctno = pv_afacctno
and exists (select 1 from aftype aft, lntype lnt where aft.actype = af.actype and aft.lntype = lnt.actype and lnt.chksysctrl = 'Y');

if l_count > 0 then
 l_isChkSysCtrlDefault:='Y';
else
 l_isChkSysCtrlDefault:='N';
end if;
--Lay ra avladvance
 --pr_error('getPP', 'Begin fn_getdealgrppaid');
 v_paidamt:=fn_getdealgrppaid(pv_afacctno);
 --pr_error('getPP', 'End fn_getdealgrppaid');
 --pr_error('getPP', 'Begin get v_avladvance');

 l_ADVSELLDUTY:= to_number(cspks_system.fn_get_sysvar('SYSTEM', 'ADVSELLDUTY'));
 l_ADVVATDUTY:= to_number(cspks_system.fn_get_sysvar('SYSTEM', 'ADVVATDUTY'));
 --pr_error('getPP', 'l_ADVSELLDUTY:' || l_ADVSELLDUTY);
 ---- AFMAST
 select cf.custatcom,af.autoadv,adt.advrate,adt.advbankrate,adt.advminfeebank,adt.advminfee,
    af.trfbuyrate,af.mrcrlimit, af.mrcrlimitmax,af.actype, af.mriratio, mrt.mrtype
    into l_custatcom,l_AUTOADV, l_advrate,l_advbankrate,l_advminfeebank,l_advminfee,
    l_trfbuyrate, l_mrcrlimit, l_mrcrlimitmax, l_actype, l_mriratio, l_margintype
    from cfmast cf, afmast af, aftype aft, adtype adt, mrtype mrt
    where af.acctno = pv_afacctno
    and af.custid = cf.custid
    and af.actype = aft.actype and aft.adtype = adt.actype
    and aft.mrtype = mrt.actype ;
if l_margintype='T' then
    if l_custatcom='Y' then
         begin
         select sum(case when l_AUTOADV = 'Y' then depoamt-paidamt else least(depoamt-paidamt,0) end)  into v_avladvance
                    from (
                            select  pv_afacctno afacctno,--sum(sts.aamt) aamt,
                                sum(
                                    greatest(
                                        floor(
                                            least(
                                                (sts.amt - exfeeamt)*(1-(sts.days*l_advrate/100/360+sts.days*l_advbankrate/100/360)),
                                                (sts.amt - exfeeamt)*(1-sts.days*l_advbankrate/100/360)-l_advminfee,
                                                (sts.amt - exfeeamt)*(1-sts.days*l_advrate/100/360)-l_advminfeebank,
                                                (sts.amt - exfeeamt-l_advminfee-l_advminfeebank)
                                            )
                                        )
                                    ,0)
                                ) depoamt,v_paidamt paidamt
                            from
                            (
                                select mt.afacctno,cleardate,
                                                 sum(MT.FEEACR + MT.TAXSELLAMT + MT.RIGHTVAT)  exfeeamt,
                                                 sum(mt.execamt) execamt, sum(mt.amt) amt,
                                                 MAX(MT.DAYS) DAYS
                                          from  (SELECT STS.AFACCTNO,STS.CLEARDATE,max(STS.TXDATE) TXDATE, --MST.ACTYPE,
                                                    SUM(STS.AMT) EXECAMT,SUM(STS.AMT-STS.AAMT-STS.FAMT+STS.PAIDAMT+STS.PAIDFEEAMT) AMT,SUM(STS.FAMT) FAMT,SUM(STS.AAMT) AAMT,
                                                    SUM(STS.PAIDAMT) PAIDAMT,SUM(STS.PAIDFEEAMT) PAIDFEEAMT,
                                                    max(odt.deffeerate) DEFFEERATE, max(to_number(l_ADVSELLDUTY)) TAXSELLRATE,
                                                    SUM(CASE WHEN MST.FEEACR >0 THEN MST.FEEACR ELSE MST.EXECAMT*ODT.DEFFEERATE/100 END) FEEACR,
                                                    SUM(CASE WHEN MST.TAXSELLAMT >0 THEN MST.TAXSELLAMT ELSE MST.EXECAMT*TO_NUMBER(l_ADVSELLDUTY)/100 END) TAXSELLAMT,
                                                    SUM(sts.ARIGHT) RIGHTVAT, v_currdate CURRDATE,
                                                    (CASE WHEN STS.CLEARDATE - v_currdate =0 THEN 1 ELSE STS.CLEARDATE - v_currdate END) DAYS
                                                 FROM STSCHD STS,ODMAST MST, /*SYSVAR SYS,*/ ODTYPE ODT/*, SYSVAR SYS1*/--, sysvar sys2
                                                 WHERE STS.orgorderid=MST.orderid
                                                        and sts.afacctno=mst.afacctno
                                                        and mst.afacctno=pv_afacctno
                                                        AND STS.DELTD <> 'Y' AND STS.STATUS='N' AND STS.DUETYPE='RM'
                                                        and mst.actype = odt.actype
                                                 GROUP BY STS.AFACCTNO,STS.CLEARDATE) MT
                                          group by mt.afacctno,cleardate
                            ) sts
                            where sts.afacctno=pv_afacctno);
        exception when others then
            v_avladvance:=0;
        end;
    else
        v_avladvance:=0;
    end if;
    --pr_error('getPP', 'End get v_avladvance');
    --pr_error('GetPP','v_avladvance:' || v_avladvance);
    --Lay cac thanh phan trong OrderbyInfo
    --pr_error('getPP', 'Begin get v_getbuyorderinfo');
    commit;
    begin
    select  case when hosts=0 then nvl(a.execbuyamtnofee,0) else nvl(a.buyamtnofee,0) end buyamt,
            case when hosts=0 then nvl(a.execbuyamtfee,0) else nvl(a.buyamtnofee,0) * nvl(a.DEFFEERATE,0) end buyfeeacr
            into v_buyamt,v_buyfeeacr
        from
        (SELECT od.afacctno,max(odt.deffeerate/100) deffeerate,
                sum(od.execamt) execbuyamtnofee,
                sum(od.execamt + od.quoteprice * od.remainqtty) buyamtnofee,
                sum(od.feeamt ) execbuyamtfee,
                to_number(nvl(max(sy_HOSTATUS.varvalue),0)) hosts
        FROM odmast od,odtype odt, sysvar sy_HOSTATUS--, sysvar sy_CURRDATE
       WHERE od.txdate = v_currdate--to_date(sy_CURRDATE.VARVALUE,'DD/MM/RRRR')
        and od.afacctno=pv_afacctno
        and od.actype = odt.actype
         AND deltd <> 'Y'
         AND od.exectype IN ('NB', 'BC')
         and od.stsstatus <> 'C'
         and sy_HOSTATUS.grname='SYSTEM' and sy_HOSTATUS.varname='HOSTATUS'
         --and sy_CURRDATE.grname='SYSTEM' and sy_CURRDATE.varname='CURRDATE'
         group by od.afacctno) A;
     exception when others then
        v_buyamt    :=0;
        v_buyfeeacr :=0;
     end;
    begin
    select min(0) trft0addamt, -- Tham so nay reset ve 0 de khoi sua cac cong thuc lien quan.
                sum(case when v_currdate <> sts.txdate
                            then greatest(amt-aamt+feeacr-feeamt-trft0amt -trfexeamt,0) else 0 end ) trfsecuredamt
                into v_trfsecuredamt,v_trft0addamt
            from stschd sts, odmast od--, sysvar sy_CURRDATE
            where sts.orgorderid = od.orderid and duetype = 'SM' and trfbuyrate > 0 and trfbuyext > 0 and trfbuysts <> 'Y'
                and sts.afacctno=pv_afacctno and sts.afacctno=od.afacctno
                --and sy_CURRDATE.grname='SYSTEM' and sy_CURRDATE.varname='CURRDATE'
                and v_currdate <= nvl(sts.trfbuydt,v_currdate)
            group by sts.afacctno;
     exception when others then
        v_trfsecuredamt:=0;
        v_trft0addamt :=0;
     end;
     --pr_error('getPP', 'End get v_getbuyorderinfo');
    /* --pr_error('GetPP','v_trfsecuredamt:' || v_trfsecuredamt);
     --pr_error('GetPP','v_trft0addamt:' || v_trft0addamt);
     --pr_error('GetPP','v_buyamt:' || v_buyamt);
     --pr_error('GetPP','v_buyfeeacr:' || v_buyfeeacr);*/
     --pr_error('getPP', 'Begin get v_getsecmargininfo');

    --pr_error('getPP', 'Begin insert t_seod 1');
    insert into t_seod (BUYQTTY,TOTALBUYQTTY,EXECQTTY,afacctno, codeid)
    select sum(BUYQTTY) BUYQTTY,sum(TOTALBUYQTTY) TOTALBUYQTTY, sum(EXECQTTY) EXECQTTY , AFACCTNO, CODEID
                                from (
                                    SELECT (case when od.exectype IN ('NB','BC')
                                                then (case when (af.trfbuyext * af.trfbuyrate) > 0 then 0 else REMAINQTTY end)
                                                        + (case when nvl(sts_trf.islatetransfer,0) > 0 then 0 else EXECQTTY - DFQTTY end)
                                                else 0 end) BUYQTTY,
                                                (case when od.exectype IN ('NB','BC') then REMAINQTTY + EXECQTTY - DFQTTY else 0 end) TOTALBUYQTTY,
                                            (case when od.exectype IN ('NS','MS') then EXECQTTY - nvl(dfexecqtty,0) else 0 end) EXECQTTY,AFACCTNO, CODEID
                                    FROM odmast od, afmast af,
                                        (select orgorderid, (trfbuyext * trfbuyrate * (amt - trfexeamt)) islatetransfer from stschd where afacctno = pv_afacctno and duetype = 'SM') sts_trf,
                                        (select orderid, sum(execqtty) dfexecqtty from odmapext where type = 'D' group by orderid) dfex
                                       where od.afacctno = af.acctno and od.orderid = sts_trf.orgorderid(+) and od.orderid = dfex.orderid(+)
                                       and af.acctno = pv_afacctno
                                       and od.txdate =v_currdate
                                       AND od.deltd <> 'Y'
                                       and not(od.grporder='Y' and od.matchtype='P') --Lenh thoa thuan tong khong tinh vao
                                       AND od.exectype IN ('NS', 'MS','NB','BC'))
                         group by AFACCTNO, CODEID;
    --pr_error('getPP', 'End insert t_seod 1');
    --pr_error('getPP', 'Begin insert t_seod 2');
    insert into t_seod (afacctno, codeid,RECEIVING,TOTALRECEIVING)
    SELECT STS.AFACCTNO,STS.CODEID,
                                SUM(CASE WHEN DUETYPE ='RS' and nvl(sts_trf.islatetransfer,0) = 0 AND STS.TXDATE <> v_currdate THEN QTTY-AQTTY ELSE 0 END) RECEIVING,
                                SUM(CASE WHEN DUETYPE ='RS' AND STS.TXDATE <> v_currdate THEN QTTY-AQTTY ELSE 0 END) TOTALRECEIVING
                            FROM STSCHD STS,
                            (select orgorderid, (trfbuyext * trfbuyrate * (amt - trfexeamt)) islatetransfer, trfbuydt from stschd where duetype = 'SM') sts_trf
                            WHERE STS.DUETYPE IN ('RM','RS') AND STS.STATUS ='N'
                                AND STS.DELTD <>'Y'
                                and sts.afacctno = pv_afacctno
                                and sts.orgorderid = sts_trf.orgorderid
                                GROUP BY STS.AFACCTNO,STS.CODEID;
    --pr_error('getPP', 'End insert t_seod 2');
    --pr_error('getPP', 'Begin insert t_seod 3');
    insert into t_seod (afacctno, codeid,prinused,sy_prinused)
    select afacctno, codeid,
                                nvl(sum(case when restype = 'M' then prinused else 0 end),0) prinused,
                                nvl(sum(case when restype = 'S' then prinused else 0 end),0) sy_prinused
                            from vw_afpralloc_all
                            where afacctno = pv_afacctno
                            group by afacctno, codeid;
    --pr_error('getPP', 'End insert t_seod 3');
    --pr_error('getPP', 'Begin insert t_seod 4');
    insert into t_seod (afacctno, codeid)
    select afacctno, codeid from semast where afacctno =pv_afacctno;
    --pr_error('getPP', 'End insert t_seod 4');

    SELECT case when l_isChkSysCtrlDefault = 'Y' then
                least(
                round(se.balance - (nvl(se.buyamt,0)/*OK*/ * (1-se.trfbuyrate/100) + (case when se.trfbuyrate > 0 then 0 else nvl(se.buyfeeacr,0) /*OK*/ end))
                    - nvl(trft0addamt,0)/*OK*/ -nvl(trfsecuredamt,0) /*OK*/ + decode(l_isstopadv,'Y',0,NVL(se.avladvance,0)) + least(nvl(se.mrcrlimitmax,0) +nvl(se.mrcrlimit,0)- dfodamt,nvl(se.mrcrlimit,0) + nvl(se.semramt,0)) - nvl(se.odamt,0) - se.dfdebtamt - se.dfintdebtamt - se.ramt - se.depofeeamt,0),
                round(se.balance - (nvl(se.buyamt,0)/*OK*/ * (1-se.trfbuyrate/100) + (case when se.trfbuyrate > 0 then 0 else nvl(se.buyfeeacr,0) /*OK*/ end))
                    - nvl(trft0addamt,0)/*OK*/ -nvl(trfsecuredamt,0) /*OK*/ + decode(l_isstopadv,'Y',0,NVL(se.avladvance,0)) + least(nvl(se.mrcrlimitmax,0)+nvl(se.mrcrlimit,0) - dfodamt,nvl(se.mrcrlimit,0) + nvl(se.seamt,0) /*OK*/) - nvl(se.odamt,0) - se.dfdebtamt - se.dfintdebtamt - se.ramt  - se.depofeeamt,0)
                )
           else
                round(se.balance - (nvl(se.buyamt,0)/*OK*/ * (1-se.trfbuyrate/100) + (case when se.trfbuyrate > 0 then 0 else nvl(se.buyfeeacr,0) /*OK*/ end))
                    - nvl(trft0addamt,0)/*OK*/ -nvl(trfsecuredamt,0) /*OK*/ + decode(l_isstopadv,'Y',0,NVL(se.avladvance,0)) + least(nvl(se.mrcrlimitmax,0)+nvl(se.mrcrlimit,0) - dfodamt,nvl(se.mrcrlimit,0) + nvl(se.seamt,0) /*OK*/) - nvl(se.odamt,0)
                    - se.dfdebtamt - se.dfintdebtamt - ramt  - se.depofeeamt,0)
           end PP into v_pp
           --round(se.balance - (nvl(se.buyamt,0)/*OK*/ * (1-se.trfbuyrate/100) + (case when se.trfbuyrate > 0 then 0 else nvl(se.buyfeeacr,0) /*OK*/ end))
           --         - nvl(trft0addamt,0)/*OK*/ -nvl(trfsecuredamt,0) /*OK*/ + nvl(se.avladvance,0) + least(nvl(se.mrcrlimitmax,0) - dfodamt,nvl(se.mrcrlimit,0) + nvl(se.seamt,0) /*OK*/) - nvl(se.odamt,0)
           --         - se.dfdebtamt - se.dfintdebtamt - ramt  - se.depofeeamt,0) into v_PP*/
      from (--select * from v_getsecmarginratio where afacctno = pv_afacctno
           select ci.acctno afacctno, ci.balance, ci.odamt , ci.dfdebtamt ,
            ci.dfintdebtamt ,ci.ramt ,ci.depofeeamt,ci.dfodamt,
            l_trfbuyrate trfbuyrate, l_mrcrlimit mrcrlimit,
            --af.trfbuyrate,af.mrcrlimit,
            v_trfsecuredamt trfsecuredamt,
            v_trft0addamt trft0addamt, --OK
            v_buyamt buyamt, --OK
            v_buyfeeacr buyfeeacr,--OK
            nvl(se.seamt,0) seamt, --OK
            nvl(se.semramt,0) semramt, --OK
            v_avladvance avladvance, --OK
            --af.mrcrlimitmax --OK
            l_mrcrlimitmax mrcrlimitmax
            from cimast ci, --afmast af,
            --v_getsecmargininfo se
            (
            select se.afacctno ,
                        sum (least(trade + receiving - execqtty + buyqtty,nvl(sy_pravlremain,0) + nvl(sy_prinused,0)) * nvl(rsk1.mrratioloan,0)/100 * least(sb.MARGINPRICE,nvl(rsk1.mrpriceloan,0))) SEAMT,
                        sum (least(trade + receiving - execqtty + buyqtty, nvl(pravlremain,0) + nvl(prinused,0) ) * least(nvl(rsk2.mrratioloan,0),100-l_mriratio)/100 * least(sb.MARGINREFPRICE,nvl(rsk2.mrpriceloan,0))) SEMRAMT
                    from
                    (select se.codeid, se.afacctno,se.acctno,
                        se.trade ,
                        tmp.receiving,
                        tmp.BUYQTTY,
                        tmp.EXECQTTY,
                        tmp.prinused,
                        tmp.sy_prinused
                        from semast se,
                        (select afacctno, codeid, sum(BUYQTTY) BUYQTTY, sum(TOTALBUYQTTY) TOTALBUYQTTY,
                            sum(EXECQTTY) EXECQTTY,sum(RECEIVING) RECEIVING, sum(TOTALRECEIVING) TOTALRECEIVING,
                            sum(prinused) prinused, sum(sy_prinused) sy_prinused
                         from t_seod group by afacctno, codeid) tmp
                         where se.afacctno = tmp.afacctno and se.codeid= tmp.codeid
                        /*left join
                        (select sum(BUYQTTY) BUYQTTY,sum(TOTALBUYQTTY) TOTALBUYQTTY, sum(EXECQTTY) EXECQTTY , AFACCTNO, CODEID
                                from (
                                    SELECT (case when od.exectype IN ('NB','BC')
                                                then (case when (af.trfbuyext * af.trfbuyrate) > 0 then 0 else REMAINQTTY end)
                                                        + (case when nvl(sts_trf.islatetransfer,0) > 0 then 0 else EXECQTTY - DFQTTY end)
                                                else 0 end) BUYQTTY,
                                                (case when od.exectype IN ('NB','BC') then REMAINQTTY + EXECQTTY - DFQTTY else 0 end) TOTALBUYQTTY,
                                            (case when od.exectype IN ('NS','MS') then EXECQTTY - nvl(dfexecqtty,0) else 0 end) EXECQTTY,AFACCTNO, CODEID
                                    FROM odmast od, afmast af,
                                        (select orgorderid, (trfbuyext * trfbuyrate * (amt - trfexeamt)) islatetransfer from stschd where afacctno = pv_afacctno and duetype = 'SM') sts_trf,
                                        (select orderid, sum(execqtty) dfexecqtty from odmapext where type = 'D' group by orderid) dfex
                                       where od.afacctno = af.acctno and od.orderid = sts_trf.orgorderid(+) and od.orderid = dfex.orderid(+)
                                       and af.acctno = pv_afacctno
                                       and od.txdate =v_currdate
                                       AND od.deltd <> 'Y'
                                       and not(od.grporder='Y' and od.matchtype='P') --Lenh thoa thuan tong khong tinh vao
                                       AND od.exectype IN ('NS', 'MS','NB','BC')
                                    )
                         group by AFACCTNO, CODEID
                         ) OD
                        on OD.afacctno =se.afacctno and OD.codeid=se.codeid
                        left join
                        (SELECT STS.CODEID,STS.AFACCTNO,
                                SUM(CASE WHEN DUETYPE ='RS' and nvl(sts_trf.islatetransfer,0) = 0 AND STS.TXDATE <> v_currdate THEN QTTY-AQTTY ELSE 0 END) RECEIVING,
                                SUM(CASE WHEN DUETYPE ='RS' AND STS.TXDATE <> v_currdate THEN QTTY-AQTTY ELSE 0 END) TOTALRECEIVING
                            FROM STSCHD STS,
                            (select orgorderid, (trfbuyext * trfbuyrate * (amt - trfexeamt)) islatetransfer, trfbuydt from stschd where duetype = 'SM') sts_trf
                            WHERE STS.DUETYPE IN ('RM','RS') AND STS.STATUS ='N'
                                AND STS.DELTD <>'Y'
                                and sts.afacctno = pv_afacctno
                                and sts.orgorderid = sts_trf.orgorderid
                                GROUP BY STS.AFACCTNO,STS.CODEID
                         ) sts
                        on sts.afacctno =se.afacctno and sts.codeid=se.codeid
                        left join
                        (
                            select afacctno, codeid,
                                nvl(sum(case when restype = 'M' then prinused else 0 end),0) prinused,
                                nvl(sum(case when restype = 'S' then prinused else 0 end),0) sy_prinused
                            from vw_afpralloc_all
                            where afacctno = pv_afacctno
                            group by afacctno, codeid
                        ) afpr  on afpr.afacctno =se.afacctno and afpr.codeid=se.codeid*/
                    ) se,
                    (select * from afserisk where actype =l_actype)rsk1,
                    (select * from afmrserisk where actype =l_actype) rsk2,
                    securities_info sb,
                    (
                        select pr.codeid,
                            greatest(pr.roomlimit - nvl(prinused,0),0) pravlremain,
                            greatest(pr.syroomlimit - pr.syroomused - nvl(sy_prinused,0),0) sy_pravlremain
                        from vw_marginroomsystem pr,
                        (select codeid, sum(case when restype = 'M' then nvl(prinused,0) else 0 end) prinused,
                                sum(case when restype = 'S' then nvl(prinused,0) else 0 end) sy_prinused
                        from vw_afpralloc_all group by codeid) afpr
                        where pr.codeid = afpr.codeid
                        /*select codeid, sum(case when restype = 'M' then nvl(prinused,0) else 0 end) prinused,
                                sum(case when restype = 'S' then nvl(prinused,0) else 0 end) sy_prinused
                        from vw_afpralloc_all group by codeid*/
                    ) pr
                    where se.codeid=sb.codeid
                    and se.codeid=rsk1.codeid --and se.actype =rsk1.actype
                    and se.codeid=rsk2.codeid --and se.actype =rsk2.actype
                    and se.codeid = pr.codeid
                    group by se.afacctno


            ) se
            where /*ci.afacctno = af.acctno
                  and */se.afacctno(+)=ci.acctno
           ) se
      WHERE se.afacctno = pv_afacctno;
else -- Tai khoan thuong
    l_CIMASTcheck_arr := txpks_check.fn_CIMASTcheck(pv_afacctno,'CIMAST','ACCTNO');
    v_pp := l_CIMASTcheck_arr(0).PP;

end if;
 --pr_error('getPP', 'End get v_getsecmargininfo');
--pr_error('GetPP','v_pp:' || v_pp);
return v_pp;
exception when others then
    return 0;
    --pr_error('GetPP','Error at line');
end;
/

