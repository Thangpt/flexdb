create or replace force view vw_mr0102 as
select af.groupleader, af.actype, aft.typename, DECODE(co_financing,'Y','YES','NO') co_financing, DECODE(ismarginacc,'Y','YES','NO') ismarginacc,
custodycd,af.acctno, af.trfbuyext, cf.fullname, af.fax1 phone1, af.email,
nvl(sec.marginratio,0) marginratio,
round(greatest((af.mriratio/100 - sec.marginratio/100) * (sec.semaxcallrealass + GREATEST(balance + nvl(avladvance,0) - round(nvl(ln.marginamt,0)),0)),0),0) rtnamt,
round(greatest((af.mriratio/100 - sec.marginratio/100) * (sec.semaxcallrealass + GREATEST(balance + ROUND(nvl(avladvance,0)) - ROUND(nvl(ln.marginamt,0)),0)),greatest(round(nvl(marginovdamt,0)) - balance - ROUND(avladvance),0)),0) addvnd,
round(greatest((af.mriratio/100 - sec.marginratio/100) * (sec.semaxcallrealass + GREATEST(balance + ROUND(nvl(avladvance,0)) - ROUND(nvl(ln.marginamt,0)),0)),greatest(ROUND(nvl(marginovdamt,0)) - balance - ROUND(avladvance),0)) - ROUND(nvl(od.sellamount,0)),0)  rtnremainamt,
af.mriratio, af.mrmratio, af.mrlratio, round(ci.balance + avladvance) totalvnd, nvl(t0.advanceline,0) advanceline, sec.semaxtotalcallass setotalcallass, af.mrcrlimit,
af.mrcrlimitmax, ROUND(ci.dfodamt) dfodamt,af.mrcrlimitmax - ROUND(ci.dfodamt) mrcrlimitremain, af.status, ROUND(nvl(marginovdamt,0)) ovdamount,
round(nvl(marginamt,0),0) totalodamt, ROUND(ci.trfbuyamt) trfbuyamt, round(nvl(od.sellamount,0)) RMAMT,
CALLDATE, CALLTIME

from cfmast cf, afmast af, cimast ci, aftype aft, v_getsecmarginratio_all sec,
    (select acctno, 'Y' ismarginacc from afmast af
          where exists (select 1 from aftype aft, lntype lnt where aft.actype = af.actype and aft.lntype = lnt.actype and lnt.chksysctrl = 'Y'
                          union all
                          select 1 from afidtype afi, lntype lnt where afi.aftype = af.actype and afi.objname = 'LN.LNTYPE' and afi.actype = lnt.actype and lnt.chksysctrl = 'Y')
          group by acctno) ismr,
    (select aftype, 'Y' co_financing from afidtype where objname = 'LN.LNTYPE' group by aftype) cof,
    (select trfacctno, trunc(sum(decode(lnt.chksysctrl,'Y',1,0)*(round(prinnml)+round(prinovd)+round(intnmlacr)+round(intdue)+round(intovdacr)+round(intnmlovd)+round(feeintnmlacr)+round(feeintdue)+round(feeintovdacr)+round(feeintnmlovd))),0) marginamt,
                 trunc(sum(decode(lnt.chksysctrl,'Y',1,0)*(round(prinovd)+round(intovdacr)+round(intnmlovd)+round(feeintovdacr)+round(feeintnmlovd) + round(nvl(ls.dueamt,0)) + round(feeintdue))),0) marginovdamt
        from lnmast ln, lntype lnt,
                (select acctno, round(sum(nml+intdue)) dueamt  from lnschd
                        where reftype = 'P' and overduedate = (select to_date(varvalue,'DD/MM/RRRR') from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM')
                        group by acctno) ls
        where ftype = 'AF' and ln.actype = lnt.actype
                and ln.acctno = ls.acctno(+)
        group by ln.trfacctno) ln,
(select acctno, sum(acclimit) advanceline from useraflimit where typereceive = 'T0' group by acctno) t0,
(select afacctno, round(sum(remainqtty*quoteprice)) sellamount from odmast where exectype in ('NS','MS') group by afacctno) od,
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
and ((af.mrlratio < sec.marginratio AND sec.marginratio<=af.mrmratio) or (ci.dueamt>1))
and nvl(ismr.ismarginacc,'N') = 'Y'
;

