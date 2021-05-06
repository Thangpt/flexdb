create or replace force view vw_mr0103 as
select af.groupleader, af.actype, aft.typename, DECODE(co_financing,'Y','YES','NO') co_financing, DECODE(ismarginacc,'Y','YES','NO') ismarginacc,
custodycd,af.acctno, af.trfbuyext, cf.fullname, af.fax1 phone1, af.email,
nvl(sec.marginratio,0) marginratio,
round(greatest((af.mrmratio/100 - sec.marginratio/100) * (sec.semaxcallrealass + GREATEST(balance + ROUND(nvl(avladvance,0)) - ROUND(nvl(ln.marginamt,0)),0)),0),0) rtnamt,
round(greatest((af.mrmratio/100 - sec.marginratio/100) * (sec.semaxcallrealass + GREATEST(balance + ROUND(nvl(avladvance,0)) - ROUND(nvl(ln.marginamt,0)),0)),greatest(ROUND(nvl(marginovdamt,0)) - balance - ROUND(nvl(avladvance,0)),0)),0) addvnd,
round(greatest((af.mrmratio/100 - sec.marginratio/100) * (sec.semaxcallrealass + GREATEST(balance + ROUND(nvl(avladvance,0)) - ROUND(nvl(ln.marginamt,0)),0)),greatest(nvl(marginovdamt,0) - balance - ROUND(nvl(avladvance,0)) - ROUND(nvl(lostass,0)),0)) - ROUND(nvl(od.sellamount,0)),0) rtnremainamt,
af.mriratio, af.mrmratio, af.mrlratio, round(ci.balance + nvl(avladvance,0)) totalvnd, ROUND(nvl(t0.advanceline,0)) advanceline, nvl(sec.semaxtotalcallass,0) setotalcallass, af.mrcrlimit,
af.mrcrlimitmax, ROUND(ci.dfodamt) dfodamt,round(af.mrcrlimitmax - ROUND(ci.dfodamt)) mrcrlimitremain, af.status, ROUND(nvl(marginovdamt,0)) ovdamount,
ROUND(nvl(marginamt,0)) totalodamt, ROUND(ci.trfbuyamt) trfbuyamt, ROUND(nvl(od.sellamount,0)) RMAMT,
CALLDATE, CALLTIME,af.mrmrate,

round(greatest((af.mrmratio/100 - sec.marginratio/100) * (sec.semaxcallrealass + GREATEST(balance + nvl(avladvance,0) - round(nvl(ln.marginamt,0)),0)),0),0) RTNAMOUNTREF,
round(greatest(round(nvl(marginovdamt,0)) - balance - nvl(avladvance,0),0),0) OVDAMOUNTREF,
round(nvl(lostass,0),0) SELLLOSTASSREF,
round(nvl(od.sellamount,0),0) SELLAMOUNTREF

from cfmast cf, afmast af, cimast ci, aftype aft, v_getsecmarginratio_all sec,
    (select acctno, 'Y' ismarginacc from afmast af
          where exists (select 1 from aftype aft, lntype lnt where aft.actype = af.actype and aft.lntype = lnt.actype and lnt.chksysctrl = 'Y'
                          union all
                          select 1 from afidtype afi, lntype lnt where afi.aftype = af.actype and afi.objname = 'LN.LNTYPE' and afi.actype = lnt.actype and lnt.chksysctrl = 'Y')
          group by acctno) ismr,
    (select aftype, 'Y' co_financing from afidtype where objname = 'LN.LNTYPE' group by aftype) cof,
    (select trfacctno, trunc(sum((decode(lnt.chksysctrl,'Y',1,0))*(round(prinnml)+round(prinovd)+round(intnmlacr)+round(intdue)+round(intovdacr)+round(intnmlovd)+round(feeintnmlacr)+round(feeintdue)+round(feeintovdacr)+round(feeintnmlovd))),0) marginamt,
                 trunc(sum((decode(lnt.chksysctrl,'Y',1,0))*(round(prinovd)+round(intovdacr)+round(intnmlovd)+round(feeintovdacr)+round(feeintnmlovd)+round(nvl(dueamt,0))+round(feeintdue))),0) marginovdamt
        from lnmast ln, lntype lnt,
                (select acctno, round(sum(nml+intdue)) dueamt  from lnschd
                        where reftype = 'P' and overduedate = (select to_date(varvalue,'DD/MM/RRRR') from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM')
                        group by acctno) ls
        where ftype = 'AF' and ln.actype = lnt.actype and lnt.chksysctrl = 'Y'
                and ln.acctno = ls.acctno(+)
        group by ln.trfacctno) ln,
(select acctno, sum(acclimit) advanceline from useraflimit where typereceive = 'T0' group by acctno) t0,
(select od.afacctno,
    round(greatest(sum(od.remainqtty*od.quoteprice*(1-odt.deffeerate/100-to_number(sy.varvalue)/100)*(1-nvl(rsk.advrate,0)*sy1.advclearday/360) - od.remainqtty*least(nvl(rsk.mrpriceloan,0),marginprice)*nvl(rsk.mrratiorate,0)/(case when nvl(rsk.mrmrate,100) = 0 then 100 else nvl(rsk.mrmrate,100) end) ),0)) sellamount,
    round(greatest(sum(od.remainqtty*least(nvl(rsk.mrpriceloan,0),marginprice)*nvl(rsk.mrratiorate,0)/(case when nvl(rsk.mrmrate,100) = 0 then 100 else nvl(rsk.mrmrate,100) end) ),0)) lostass
    from odmast od, odtype odt,
        (select af.acctno, af.mrmrate, nvl(adt.advrate,0)/100 advrate, rsk.*
            from afmast af, afmrserisk rsk, aftype aft, adtype adt
            where af.actype = rsk.actype(+)
            and af.actype = aft.actype and aft.adtype = adt.actype
            ) rsk,
        securities_info sec,
        sysvar sy, (select to_number(varvalue) advclearday from sysvar where varname = 'ADVCLEARDAY' AND grname = 'OD') sy1
    where od.exectype in ('NS','MS') and isdisposal = 'Y'
    and od.afacctno = rsk.acctno(+) and od.codeid = rsk.codeid(+)
    and od.codeid = sec.codeid
    and od.actype = odt.actype
    and sy.varname = 'ADVSELLDUTY'
    and od.remainqtty > 0
    group by afacctno) od,
(
   select max(txdate) CALLDATE, max(txtime) CALLTIME, acctno from sendmsglog group by acctno
) SMS
where cf.custid = af.custid
and cf.custatcom = 'Y'
and af.actype = aft.actype
and af.acctno = ci.acctno
and af.acctno = sec.afacctno
and af.acctno = ln.trfacctno(+)
and af.acctno = ismr.acctno(+)
and af.actype = cof.aftype(+)
and af.acctno = t0.acctno(+)
and af.acctno = sms.acctno(+)
and af.acctno = od.afacctno(+)
--and nvl(ln.marginamt,0) + nvl(ln.t0amt,0) + nvl(secureamt,0) > 0
and (nvl(MARGINRATIO,0)<=af.mrmratio or nvl(marginovdamt,0)>1)
and nvl(ismr.ismarginacc,'N') = 'Y'
--and af.acctno like '%%'
;

