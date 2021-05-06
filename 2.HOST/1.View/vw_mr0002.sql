CREATE OR REPLACE FORCE VIEW VW_MR0002 AS
select  af.actype, aft.typename, DECODE(co_financing,'Y','YES','NO') co_financing, DECODE(ismarginacc,'Y','YES','NO') ismarginacc,
custodycd,af.acctno, af.trfbuyext, cf.fullname, af.fax1 phone1, af.email,
nvl(sec.rlsmarginrate,0) rlsmarginrate, nvl(sec.marginrate,0) marginrate,
ROUND(greatest(round((case when nvl(sec.marginrate,0) * af.mrmrate =0 then - nvl(sec.outstanding,0) else
                     greatest( 0,- nvl(sec.outstanding,0) - nvl(sec.navaccount,0) *100/af.mrmrate) end),0),0)) rtnamt,
ROUND(greatest(round((case when nvl(sec.marginrate,0) * af.mrmrate =0 then - nvl(sec.outstanding,0) else
                     greatest( 0,- nvl(sec.outstanding,0) - nvl(sec.navaccount,0) *100/af.mrmrate) end),0),greatest(ROUND(dueamt)+ROUND(ovamt)+ROUND(depofeeamt)-nvl(ln.NYOVDAMT,0) - balance - avladvance,0))) addvnd,
ROUND(greatest(round((case when nvl(sec.rlsmarginrate,0) * af.mrmrate =0 then - nvl(outstandingt2,0) else
                     greatest( 0,- nvl(outstandingt2,0) - nvl(sec.navaccountt2,0)*100/af.mrmrate) end),0),0)) rtnamtt2,
ROUND(greatest(round((case when nvl(sec.rlsmarginrate,0) * af.mrmrate =0 then - nvl(outstandingt2,0) else
                     greatest( 0,- nvl(outstandingt2,0) - nvl(sec.navaccountt2,0)*100/af.mrmrate) end),0),greatest(ROUND(dueamt)+ROUND(ovamt)- nvl(ln.NYOVDAMT,0) +ROUND(depofeeamt) - balance - ROUND(avladvance),0))) addvndt2,
af.mrirate, af.mrmrate, af.mrlrate, ROUND(ci.balance + avladvance) totalvnd, nvl(t0.advanceline,0) advanceline, sec.semaxtotalcallass setotalcallass, af.mrcrlimit,
af.mrcrlimitmax, ROUND(ci.dfodamt) dfodamt,af.mrcrlimitmax - ROUND(ci.dfodamt) mrcrlimitremain, af.status, ROUND(ci.dueamt) dueamount, ROUND(ci.ovamt) - nvl(ln.NYOVDAMT,0) ovdamount,
CALLDATE, CALLTIME, SEC.clamt,SEC.odamt, tl.grpname CAREBY
,nvl(ln.NYOVDAMT,0) NYOVDAMT
, nvl(ln.MPOVDAMT,0) MPOVDAMT
,af.brid,re.REFULLNAME

from cfmast cf, afmast af, cimast ci, aftype aft,
--PhuongHT edit ngay 01.03.2016
-- v_getsecmarginratio_all sec,
(select  afacctno,avladvance_EX avladvance,trfbuyamt_over,set0amt, rlsmarginrate_ex rlsmarginrate,NYOVDAMT, marginrate_Ex marginrate,
         semaxtotalcallass, secallass,CLAMT,navaccountt2_EX navaccountt2,outstanding_ex outstanding,
         navaccount_ex navaccount, MARGINRATE5,
         outstanding5,ODAMT_EX ODAMT ,outstandingT2_EX outstandingT2,semaxcallass,secureamt_inday,trfsecuredamt_inday
 from buf_ci_account) sec,
--end of PhuongHT edit ngay 01.03.2016
    (select acctno, 'Y' ismarginacc from afmast af
          where exists (select 1 from aftype aft, lntype lnt where aft.actype = af.actype and aft.lntype = lnt.actype and lnt.chksysctrl = 'Y'
                          union all
                          select 1 from afidtype afi, lntype lnt where afi.aftype = af.actype and afi.objname = 'LN.LNTYPE' and afi.actype = lnt.actype and lnt.chksysctrl = 'Y')
          group by acctno) ismr,
    (select aftype, 'Y' co_financing from afidtype where objname = 'LN.LNTYPE' group by aftype) cof,

(select acctno, sum(acclimit) advanceline from useraflimit where typereceive = 'T0' group by acctno) t0,
(
   select max(txdate) CALLDATE, max(txtime) CALLTIME, acctno from sendmsglog group by acctno
) SMS,
(
    select trfacctno,
                     trunc(sum(NYOVDAMT),0) NYOVDAMT,
                     trunc(sum(MPOVDAMT),0) MPOVDAMT
            from lnmast ln,
                    (select acctno,
                            sum(case when mintermdate >= getcurrdate then   (nml + ovd + intdue + intovd + feedue + feeovd + intovdprin + intnmlacr
                            + feeintnmlacr + feeintovdacr + feeintnmlovd + feeintdue
                             + nmlfeeint + ovdfeeint + feeintnml + feeintovd ) else 0 end)  NYOVDAMT
                             ,  sum(case when mintermdate < getcurrdate then   (nml + ovd + intdue + intovd + feedue + feeovd + intovdprin + intnmlacr
                            + feeintnmlacr + feeintovdacr + feeintnmlovd + feeintdue
                             + nmlfeeint + ovdfeeint + feeintnml + feeintovd ) else 0 end) MPOVDAMT
                        from lnschd where reftype = 'GP'  group by acctno
                    ) l

            where ftype = 'AF'  and ln.acctno = l.acctno (+)
            group by ln.trfacctno
    ) ln,
    (SELECT rea.afacctno, MAX(cfmast.fullname) REFULLNAME FROM reaflnk rea, retype ,CFMAST
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
and af.acctno = ln.trfacctno (+)
and ROUND(ci.ovamt)- ROUND (nvl(LN.NYOVDAMT,0)) = 0
and af.acctno = ismr.acctno(+)
and af.actype = cof.aftype(+)
and af.acctno = t0.acctno(+)
and af.acctno = sms.acctno(+)
AND af.acctno =re.afacctno(+)
AND af.careby = tl.grpid(+)
--and nvl(ln.marginamt,0) + nvl(ln.t0amt,0) + nvl(secureamt,0) > 0
and (
    (af.mrlrate <= sec.rlsmarginrate AND sec.rlsmarginrate<af.mrmrate)
  --  or (ci.dueamt>1)
)
-- HaiLT them dieu kien de lay len 3 ngay lien tiep ti le thuc te < ti le canh bao
and  not EXISTS
    (
                        SELECT AFACCTNO FROM
                        (
                            SELECT DISTINCT A.AFACCTNO,COUNT(*) NUM FROM
                                (select distinct txdate , afacctno/*, marginrate*/ from  mr3008_log where log_action = 'BF-EOD' --group by txdate, afacctno, marginrate
                                union
                                select distinct txdate, afacctno/*,  marginrate*/ from mr3009_logall where log_action = 'BF-EOD'-- group by txdate, afacctno, marginrate
                                ) a, afmast b
                            where a.afacctno = b.acctno --AND LOG_ACTION = 'BF-EOD'
                            --and a.marginrate < b.mrmrate
                            AND A.TXDATE>=
                                           ( select sbdate from sbcurrdate where numday=-3 and sbtype='B')
                            GROUP BY a.AFACCTNO
                        )
                        WHERE NUM>=3 and af.acctno=afacctno
                    )
--Chaunh: neu dang doi xu ly thi khong call
--and af.acctno not in (select distinct afacctno from mr3009_logall a where log_action = 'AF-END'
--                            and a.txdate = getcurrdate/*(
--                                            select max(sbdate) from SBCLDR where CLDRTYPE='000' and  HOLIDAY <> 'Y'
 --                                            and sbdate < getcurrdate
--                                        )*/
 --                    );
;

