CREATE OR REPLACE FORCE VIEW VW_MR0003 AS
select custodycd,actype,acctno,fullname,
    marginrate,rlsmarginrate, GREATEST(rtnamt3 - asssellamt, T0OVDAMOUNT + OVDAMOUNT + CIDEPOFEEACR -NYOVDAMT - TOTALVND - realsellamt) rtnremainamt
    , GREATEST(rtnamt5 - asssellamt, T0OVDAMOUNT + OVDAMOUNT + CIDEPOFEEACR  - TOTALVND - realsellamt) rtnremainamt5
    , rtnamt,rtnamt2,rtnamtt2,
    T0OVDAMOUNT, OVDAMOUNT,CIDEPOFEEACR,TOTALVND, GREATEST(T0OVDAMOUNT + OVDAMOUNT + CIDEPOFEEACR -NYOVDAMT- TOTALVND,rtnamt3) addvnd, -- sua tong tien nop them phu thuoc vao tham so OSF
    realsellamt, asssellamt, mrirate, MRMRATE, MRLRATE, CALLDATE, CALLTIME,PHONE1, EMAIL,MR0003TYPE ,RTNAMOUNTREF , OVDAMOUNTREF,
    SELLLOSTASSREF, SELLAMOUNTREF,novdamt,trfbuyext,ADDVNDT2, OFS , totalodamt, outstandingt2, mrcrlimitmax, setotalcallass,SEMAXCALLASS, rtnamt3,rtnamt5
    , NYOVDAMT, MPOVDAMT, navaccount, secoutstanding, BRID,fullnamere,mobilesms, careby
FROM
(
select af.groupleader, af.actype, aft.typename, DECODE(co_financing,'Y','YES','NO') co_financing, DECODE(ismarginacc,'Y','YES','NO') ismarginacc,
ln.liqday,
custodycd,af.acctno, af.trfbuyext, cf.fullname, af.fax1 phone1, af.email,
nvl(sec.rlsmarginrate,0) rlsmarginrate, nvl(sec.marginrate,0) marginrate,ci.DEPOFEEAMT CIDEPOFEEACR, --ci.CIDEPOFEEACR thay cidepofeeacr thanh cidepofeeamt
round(greatest(round((case when nvl(sec.marginrate,0) * af.mrmrate =0 then - sec.outstanding + depofeeamt else
                     greatest( 0,- (sec.outstanding - depofeeamt) - sec.navaccount *100/decode(nvl(af.mrmrate,0),0,100,af.mrmrate)) end),0),0),0) rtnamt,
round(greatest(round((case when nvl(sec.marginrate,0) * af.mrirate =0 then - sec.outstanding  + depofeeamt else
                    greatest( 0,- (sec.outstanding - depofeeamt) - sec.navaccount *100/af.mrirate) end),0),0),0) rtnamt2, --- So tien nop them de ve R an toan
round(greatest(round((case when nvl(sec.marginrate,0) * af.mrirate =0 then - sec.outstanding  + depofeeamt else
                    greatest( 0,- (sec.outstanding - depofeeamt) - sec.navaccount *100
                    /decode(sys.ofs,'I',af.mrirate,decode(nvl(af.mrmrate,0),0,100,af.mrmrate))) end),0),0),0) rtnamt3,
round(greatest(round((case when nvl(sec.marginrate5,0) * af.mrirate =0 then - sec.outstanding5  + depofeeamt else
                    greatest( 0,- (sec.outstanding5 - depofeeamt) - sec.navaccount *100
                    /decode(sys.ofs,'I',af.mrirate,decode(nvl(af.mrmrate,0),0,100,af.mrmrate))) end),0),0),0) rtnamt5,

round(greatest(round((case when nvl(sec.marginrate,0) * af.mrmrate =0 then - sec.outstanding  + depofeeamt else
                     greatest( 0,- (sec.outstanding - depofeeamt) - sec.navaccount *100/af.mrmrate) end),0),
                     greatest(ovamt - balance - nvl(avladvance,0),0)),0) addvnd,
round(greatest(round((case when nvl(sec.marginrate,0) * af.mrirate =0 then - sec.outstanding  + depofeeamt else
                     greatest( 0,- (sec.outstanding - depofeeamt) - sec.navaccount *100/af.mrirate) end),0),
                     greatest(ovamt - balance - nvl(avladvance,0),0)),0) addvnd2, -- So tien nop them ve Ran toan va tra het no qua han
greatest(ovamt+depofeeamt - balance - nvl(avladvance,0),0) novdamt, -- So tien can nop them de tra het no qua han
round(greatest(round((case when nvl(sec.rlsmarginrate,0) * af.mrmrate =0 then - outstandingt2  + depofeeamt else
                     greatest( 0,- (outstandingt2 - round(depofeeamt)) - sec.navaccountt2*100/af.mrmrate) end),0),0),0) rtnamtt2,
round(greatest(round((case when nvl(sec.rlsmarginrate,0) * af.mrmrate =0 then - outstandingt2  + depofeeamt else
                     greatest( 0,- (outstandingt2 - round(depofeeamt)) - sec.navaccountt2*100/af.mrmrate) end),0),
                     greatest(ovamt - balance - round(nvl(avladvance,0)),0)),0) addvndt2,
round(greatest(round((case when nvl(sec.rlsmarginrate,0) * af.mrmrate =0 then - sec.outstandingt2  + depofeeamt else
                     greatest( 0,- (sec.outstandingt2 - round(depofeeamt)) - sec.navaccountt2 *100/af.mrmrate) end),0),
                     greatest(round(ovamt) - round(nvl(ln.NYOVDAMT,0),0) - balance - nvl(avladvance,0) - nvl(lostass,0),0))  - nvl(od.sellamount,0),0) rtnremainamt,
round(greatest(round((case when nvl(sec.rlsmarginrate,0) * af.mrirate =0 then - sec.outstandingt2  + depofeeamt else
                     greatest( 0,- (sec.outstandingt2 - round(depofeeamt)) - sec.navaccountt2 *100/af.mrirate) end),0),
                     greatest(round(ovamt) - balance - nvl(avladvance,0) - nvl(lostass,0),0))  - nvl(od.sellamount,0),0) rtnremainamt2, -- So tien con phai xu ly ve Rantoan va tra het no qua han

af.mrirate, af.mrmrate, af.mrlrate, ci.balance + nvl(avladvance,0) totalvnd, nvl(t0.advanceline,0) advanceline
, nvl(sec.semaxtotalcallass,0) setotalcallass,nvl(sec.semaxcallass,0) semaxcallass, af.mrcrlimit,
af.mrcrlimitmax, ci.dfodamt,af.mrcrlimitmax - ci.dfodamt mrcrlimitremain, af.status, nvl(ln.marginovdamt,0) ovdamount,round(nvl(ln.t0amt,0)) t0ovdamount,
round(ci.odamt) + round(nvl(trfbuyamt_over,0)) totalodamt, round(ci.trfbuyamt) trfbuyamt, round(nvl(od.sellamount,0),0) RMAMT,
CALLDATE, CALLTIME, nvl(sec.outstanding,0) outstanding, nvl(sec.outstandingt2,0) outstandingt2,
sys.ofs,
round(greatest(round((case when nvl(sec.rlsmarginrate,0) * af.mrirate =0 then - sec.outstandingt2 else
                     greatest( 0,- (sec.outstandingt2  - round(depofeeamt)) - sec.navaccountt2 *100
                            /decode(sys.ofs,'I',af.mrirate,decode(nvl(af.mrmrate,0),0,100,af.mrmrate))) end),0),0),0) RTNAMOUNTREF, --so tien can xu ly
round(greatest(ovamt+depofeeamt- round(nvl(ln.NYOVDAMT,0),0) - balance - nvl(avladvance,0),0),0) OVDAMOUNTREF,
round(nvl(lostass,0),0) SELLLOSTASSREF,
round(nvl(od.sellamount,0),0) SELLAMOUNTREF,
round(nvl(realsellamt,0),0) realsellamt,
round(nvl(realsellamt,0),0) - round(nvl(lostass,0),0) asssellamt,
round(nvl(ln.NYOVDAMT,0),0) NYOVDAMT,
round(nvl(ln.MPOVDAMT,0),0) MPOVDAMT,
-(sec.outstanding - depofeeamt) secoutstanding,
sec.navaccount navaccount,
case WHEN (sec.rlsmarginrate<af.mrlrate and af.mrlrate <> 0) AND (ci.ovamt >1 and ln.liqday >0) THEN 'Rxl-QH'
    when (sec.rlsmarginrate<af.mrlrate and af.mrlrate <> 0)  then 'Rxl'
    when (ci.ovamt - round(nvl(ln.NYOVDAMT,0),0))>1 then 'QH'
    ELSE 'Rcb'
end mr0003type,
af.brid,NVL(re.fullname,0) fullnamere,NVL(re.mobilesms,0) mobilesms, tl.grpname careby
from  (select varvalue ofs from sysvar where varname = 'OPTFORCESELL') sys,
    cfmast cf, afmast af, cimast ci, aftype aft,
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
    (
    select trfacctno, max(liqday) liqday, trunc(sum(round(prinnml)+round(prinovd)+round(intnmlacr)+round(intdue)+round(intovdacr)+round(intnmlovd)+round(feeintnmlacr)+round(feeintdue)+round(feeintovdacr)+round(feeintnmlovd)),0) marginamt,
                     trunc(sum(round(oprinnml)+round(oprinovd)+round(ointnmlacr)+round(ointdue)+round(ointovdacr)+round(ointnmlovd)),0) t0amt,
                     trunc(sum(round(prinovd)+round(intovdacr)+round(intnmlovd)+round(feeintovdacr)+round(feeintnmlovd)),0) marginovdamt,
                     trunc(sum(round(oprinovd)+round(ointovdacr)+round(ointnmlovd)),0)-  trunc(sum(NYOVDAMT),0) t0ovdamt,
                     trunc(sum(NYOVDAMT),0) NYOVDAMT,
                     trunc(sum(MPOVDAMT),0) MPOVDAMT,
                     sum(ln.intnmlpbl) intnmlpbl
            from lnmast ln,
                    (select acctno,
                            sum(case when mintermdate >= getcurrdate then   (nml + ovd + intdue + intovd + feedue + feeovd + intovdprin + intnmlacr
                            + feeintnmlacr + feeintovdacr + feeintnmlovd + feeintdue
                             + nmlfeeint + ovdfeeint + feeintnml + feeintovd ) else 0 end)  NYOVDAMT
                             ,  sum(case when mintermdate < getcurrdate then   (nml + ovd + intdue + intovd + feedue + feeovd + intovdprin + intnmlacr
                            + feeintnmlacr + feeintovdacr + feeintnmlovd + feeintdue
                             + nmlfeeint + ovdfeeint + feeintnml + feeintovd ) else 0 end) MPOVDAMT
                        from lnschd where reftype = 'GP'  group by acctno
                    ) l,
                    (select acctno, round(sum(nml+intdue)) dueamt  from lnschd
                            where reftype = 'P' and overduedate = (select to_date(varvalue,'DD/MM/RRRR') from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM')
                            group by acctno) ls,
                    (

                   /*  select ln.acctno,  case when  lnt.LIQOVDDAY <= fnc_getclearday(lns.overduedate,getcurrdate) then 1 else 0 end liqday from
                        ( select acctno, min(overduedate) overduedate from lnschd where reftype = 'P' group by acctno) lns,
                        lnmast ln, lntype lnt
                            where ln.acctno=lns.acctno(+) and ln.actype=lnt.actype*/
                  /*    select ln.acctno,
                       case when  fn_getworkday(nvl(lns.overduedate,to_date('01/01/2000','DD/MM/RRRR'))) <> 0 and
                           lnt.LIQOVDDAY <= fn_getworkday(nvl(lns.overduedate,to_date('01/01/2000','DD/MM/RRRR'))) then 1 else 0 end liqday
                    from
                        ( select acctno, min(overduedate) overduedate from lnschd where reftype in ('P','GP') group by acctno) lns, --no bao lanh thi khong check ngay
                        lnmast ln, lntype lnt
                    where ln.acctno=lns.acctno(+) and ln.actype=lnt.actype*/
                     select ln.acctno, case when  LIQOVDDAY_LNS <> 0 and
                           lnt.LIQOVDDAY <= LIQOVDDAY_LNS then 1 else 0 end liqday
                    from
                        (
                    select acctno, GREATEST(   MAX(-NUMDAY) ,0)  LIQOVDDAY_LNS
                    from lnschd A, SBCURRDATE B where reftype in ('P','GP')
                    AND B.SBTYPE ='B' AND B.sbdate=overduedate
                    group by acctno

                        ) lns, --no bao lanh thi khong check ngay
                        lnmast ln, lntype lnt
                    where ln.acctno=lns.acctno(+) and ln.actype=lnt.actype
                    ) lsa

            where ftype = 'AF' and ln.acctno = lsa.acctno and ln.acctno = l.acctno (+)
                    and ln.acctno = ls.acctno(+)
            group by ln.trfacctno
    ) ln,
(select acctno, sum(acclimit) advanceline from useraflimit where typereceive = 'T0' group by acctno) t0,
(select od.afacctno,
     round(sum(od.remainqtty*od.quoteprice*(1-odt.deffeerate/100-to_number(sy.varvalue)/100)*(1-nvl(rsk.advrate,adt.advrate/100)*sys1.advclearday/360)),0) realsellamt, --- so tien ban tru phi, thue, UTTB
    round(sum(od.remainqtty*od.quoteprice),0) asssellamt, --- so tien ban chua tru phi, thue, UTTB
    round(greatest(sum(od.remainqtty*od.quoteprice*(1-odt.deffeerate/100-to_number(sy.varvalue)/100)*(1-nvl(rsk.advrate,adt.advrate/100)*sys1.advclearday/360) - od.remainqtty*least(nvl(rsk.mrpriceloan,0),marginprice)*nvl(rsk.mrratiorate,0)/(case when nvl(decode(sys.ofs,'M',rsk.mrmrate,rsk.mrirate),100) = 0 then 100 else nvl(decode(sys.ofs,'M',rsk.mrmrate,rsk.mrirate),100) end) ),0)) sellamount,
    round(greatest(sum(od.remainqtty*least(nvl(rsk.mrpricerate,0),margincallprice)*nvl(rsk.mrratiorate,0)/(case when decode(sys.ofs,'I',nvl(rsk.mrirate,100),nvl(rsk.mrmrate,100)) = 0 then 100 else decode(sys.ofs,'I',nvl(rsk.mrirate,100),nvl(rsk.mrmrate,100)) end) ),0)) lostass
    from odmast od, odtype odt,afmast af, aftype aft, adtype adt,
        (select af.acctno, af.mrmrate,af.mrirate, nvl(adt.advrate,0)/100 advrate, rsk.*
            from afmast af, afserisk rsk, aftype aft, adtype adt
            where af.actype = rsk.actype(+)
            and af.actype = aft.actype and aft.adtype = adt.actype
            ) rsk,
        securities_info sec,
        sysvar sy,
        (select varvalue ofs from sysvar where varname = 'OPTFORCESELL') sys,
        (select to_number(varvalue) advclearday from sysvar where varname = 'ADVCLEARDAY' AND grname = 'OD') sys1   --T2_HoangND
    where od.exectype in ('NS','MS') and isdisposal = 'Y'
    and od.afacctno = af.acctno and af.actype = aft.actype and aft.adtype = adt.actype
    and od.afacctno = rsk.acctno(+) and od.codeid = rsk.codeid(+)
    and od.codeid = sec.codeid
    and od.actype = odt.actype
    and sy.varname = 'ADVSELLDUTY'
    and od.remainqtty > 0
    group by afacctno) od,
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

WHERE cf.custid = af.custid
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
AND af.acctno =re.afacctno(+)
AND af.careby = tl.grpid(+)
--and nvl(ln.marginamt,0) + nvl(ln.t0amt,0) + nvl(secureamt,0) > 0
and (
    (sec.rlsmarginrate<af.mrlrate and af.mrlrate <> 0) --or ci.ovamt >1
    -- HaiLT them dieu kien de lay len 3 ngay lien tiep ti le thuc te < ti le canh bao
    or (EXISTS  (
                        SELECT AFACCTNO FROM (
                            SELECT DISTINCT A.AFACCTNO,COUNT(*) NUM FROM
                                (select txdate , afacctno/*, marginrate */from  mr3008_log where log_action = 'BF-EOD' group by txdate, afacctno
                                union
                                select txdate, afacctno/*, -1 marginrate*/ from mr3009_logall where log_action = 'BF-EOD' group by txdate, afacctno
                                ) a, afmast b
                            where a.afacctno = b.acctno --AND LOG_ACTION = 'BF-EOD'
                            --and a.marginrate < b.mrmrate
                            AND A.TXDATE>= (select sbdate from sbcurrdate where numday=-3 and sbtype='B'
                                           )
                            GROUP BY a.AFACCTNO
                        )  WHERE NUM>=3 AND AFACCTNO=af.acctno
        )
        AND sec.rlsmarginrate < AF.mrmrate
    )

    or (ci.ovamt -nvl(ln.NYOVDAMT,0)-nvl(ln.intnmlpbl,0)>1 and ln.liqday >0)
    --chaunh
    --or ( sec.rlsmarginrate < AF.mrmrate
   --  and (af.acctno in (
     --                   select distinct afacctno from mr3009_logall a where log_action = 'AF-END'
    --                        and a.txdate = getcurrdate/*(
      --                                      select max(sbdate) from SBCLDR where CLDRTYPE='000' and  HOLIDAY <> 'Y'
     --                                        and sbdate < getcurrdate
      --                                   )*/
     --                   )
     --    )
    -- )
    )


)
;

