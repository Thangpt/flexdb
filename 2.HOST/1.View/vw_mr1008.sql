CREATE OR REPLACE FORCE VIEW VW_MR1008 AS
select af.actype, aft.typename, DECODE(co_financing,'Y','YES','NO') co_financing, DECODE(ismarginacc,'Y','YES','NO') ismarginacc,
custodycd,af.acctno, af.trfbuyext, cf.fullname, af.fax1 phone1, af.email,
nvl(sec.rlsmarginrate,0) rlsmarginrate, nvl(sec.marginrate,0) marginrate, nvl(sec.MARGINRATE_LN,0) MARGINRATE_LN,
ROUND(greatest(round((case when nvl(sec.marginrate,0) * af.mrmrate =0 then - nvl(sec.outstanding,0) else
                     greatest( 0,- nvl(sec.outstanding,0) - nvl(sec.navaccount,0) *100/af.mrmrate) end),0),0)) rtnamt,
ROUND(greatest(round((case when nvl(sec.marginrate,0) * af.mrmrate =0 then - nvl(sec.outstanding,0) else
                     greatest( 0,- nvl(sec.outstanding,0) - nvl(sec.navaccount,0) *100/af.mrmrate) end),0),greatest(ROUND(dueamt)+ROUND(ovamt)+ROUND(depofeeamt) - balance - avladvance,0))) addvnd,
ROUND(greatest(round((case when nvl(sec.marginrate,0) * af.mrmrate =0 then - nvl(sec.outstanding,0) else
                     greatest( 0,- nvl(sec.outstanding,0) - nvl(sec.navaccount_LOAN,0) *100/af.mrmrate) end),0),greatest(ROUND(dueamt)+ROUND(ovamt)+ROUND(depofeeamt) - balance - avladvance,0))) addvnd_loan,
ROUND(greatest(round((case when nvl(sec.rlsmarginrate,0) * af.mrmrate =0 then - nvl(outstandingt2,0) else
                     greatest( 0,- nvl(outstandingt2,0) - nvl(sec.navaccountt2,0)*100/af.mrmrate) end),0),0)) rtnamtt2,
ROUND(greatest(round((case when nvl(sec.rlsmarginrate,0) * af.mrmrate =0 then - nvl(outstandingt2,0) else
                     greatest( 0,- nvl(outstandingt2,0) - nvl(sec.navaccountt2,0)*100/af.mrmrate) end),0),greatest(ROUND(dueamt)+ROUND(ovamt)+ROUND(depofeeamt) - balance - ROUND(avladvance),0))) addvndt2,
af.mrirate, af.mrmrate, af.mrlrate, ROUND(ci.balance + avladvance) totalvnd, nvl(t0.advanceline,0) advanceline, sec.semaxtotalcallass setotalcallass, af.mrcrlimit,
af.mrcrlimitmax, ROUND(ci.dfodamt) dfodamt,af.mrcrlimitmax - ROUND(ci.dfodamt) mrcrlimitremain, af.status, ROUND(ci.dueamt) dueamount, ROUND(ci.ovamt) ovdamount,
CALLDATE, CALLTIME, AF.fax1 SMSPHONE
,sec.navaccount_LOAN navaccount
,- sec.outstanding + ci.depofeeamt secoutstanding
, af.brid
, af.careby,FN_GET_EMAILMG(af.acctno,'EMAIL') emailibr,FN_GET_EMAILMG(af.acctno,'NAME') nameibr,FN_GET_EMAILMG(af.acctno,'EMAILPCC') EMAILPCC,FN_GET_EMAILMG(af.acctno,'EMAILCN') EMAILBRID,FN_GET_EMAILMG(af.acctno,'EMAILNV') EMAILNGHIEPVU
, tl.grpname
, re.fullname refullname
from cfmast cf, afmast af, cimast ci, aftype aft, v_getsecmarginratio_ALL sec,
    (select acctno, 'Y' ismarginacc from afmast af
          where exists (select 1 from aftype aft, lntype lnt where aft.actype = af.actype and aft.lntype = lnt.actype and lnt.chksysctrl = 'Y'
                          union all
                          select 1 from afidtype afi, lntype lnt where afi.aftype = af.actype and afi.objname = 'LN.LNTYPE' and afi.actype = lnt.actype and lnt.chksysctrl = 'Y')
          group by acctno) ismr,
    (select aftype, 'Y' co_financing from afidtype where objname = 'LN.LNTYPE' group by aftype) cof,
    (select trfacctno, trunc(sum(round(prinnml)+round(prinovd)+round(intnmlacr)+round(intdue)+round(intovdacr)
                                    +round(intnmlovd)+round(feeintnmlacr)+round(feeintdue)+round(feeintovdacr)+round(feeintnmlovd)),0) marginamt,
                 trunc(sum(round(oprinnml)+round(oprinovd)+round(ointnmlacr)+round(ointdue)+round(ointovdacr)+round(ointnmlovd)),0) t0amt,
                 trunc(sum(round(prinovd)+round(intovdacr)+round(intnmlovd)+round(feeintovdacr)+round(feeintnmlovd) + round(nvl(ls.dueamt,0)) + round(feeintdue)),0) marginovdamt,
                 trunc(sum(round(oprinovd)+round(ointovdacr)+round(ointnmlovd)),0) t0ovdamt
        from lnmast ln,
                (select acctno, sum(nml+intdue) dueamt  from lnschd
                        where reftype = 'P' and overduedate = (select to_date(varvalue,'DD/MM/RRRR') from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM')
                        group by acctno) ls
        where ftype = 'AF'
                and ln.acctno = ls.acctno(+)
        group by ln.trfacctno) ln,
(select acctno, sum(acclimit) advanceline from useraflimit where typereceive = 'T0' group by acctno) t0,
(
   select max(txdate) CALLDATE, max(txtime) CALLTIME, acctno from sendmsglog group by acctno
) SMS,
    (SELECT rea.afacctno, MAX(cfmast.fullname) fullname,MAX(CFMAST.mobilesms) mobilesms FROM reaflnk rea, retype ,CFMAST
        WHERE substr(rea.reacctno,11) = retype.actype
        AND   getcurrdate BETWEEN frdate AND todate
        AND rerole ='BM' AND rea.status ='A'
        AND SUBSTR(reacctno,1,10)=CFMAST.custid
    GROUP BY rea.afacctno
        )re,
    (SELECT * FROM TLGROUPS WHERE GRPTYPE = '2') TL
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
and nvl(sec.MARGINRATE_LN,0) < af.mrmrate
AND nvl(sec.MARGINRATE_LN,0)< nvl(sec.marginrate,0)
AND af.acctno =re.afacctno(+)
AND af.careby = tl.grpid(+)
--and nvl(sec.marginrate,0) >= af.mrmrate
--and nvl(ln.marginamt,0) + nvl(ln.t0amt,0) + nvl(secureamt,0) > 0
--and ((af.mrlrate < sec.rlsmarginrate AND sec.rlsmarginrate<af.mrmrate) or (ci.dueamt>1))
;

