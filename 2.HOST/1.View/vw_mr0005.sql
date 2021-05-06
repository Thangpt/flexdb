CREATE OR REPLACE FORCE VIEW VW_MR0005 AS
select main.custodycd, main.acctno, main.fullname, main.phone1, main.email, main.marginrate,
    case when action = 'X' then GREATEST(rtnamt3 - asssellamt, T0OVDAMOUNT + OVDAMOUNT + CIDEPOFEEACR - NVL(NYOVDAMT,0) - TOTALVND - realsellamt)
         when action = 'C' then addvnd
    end remainamt,a.cdcontent action, refullname, careby, a.cdval cdaction
FROM
(
    select
    custodycd,af.acctno,  cf.fullname, af.fax1 phone1, af.email, refullname, af.careby,
    nvl(sec.marginrate,0) marginrate,
    round(nvl(ln.t0amt,0)) t0ovdamount,
    nvl(ln.marginovdamt,0) ovdamount,
    ci.DEPOFEEAMT CIDEPOFEEACR,
    ci.balance + nvl(avladvance,0) totalvnd,
    round(nvl(realsellamt,0),0) realsellamt,
    round(greatest(round((case when nvl(sec.marginrate,0) * af.mrirate =0 then - sec.outstanding  + depofeeamt else
                    greatest( 0,- (sec.outstanding - depofeeamt) - sec.navaccount *100
                    /decode(sys.ofs,'I',af.mrirate,decode(nvl(af.mrmrate,0),0,100,af.mrmrate))) end),0),0),0) rtnamt3,
    round(nvl(realsellamt,0),0) - round(nvl(lostass,0),0) asssellamt,
    ROUND(greatest(round((case when nvl(sec.marginrate,0) * af.mrmrate =0 then - nvl(sec.outstanding,0) else
                       greatest( 0,- nvl(sec.outstanding,0) - nvl(sec.navaccount,0) *100/af.mrmrate) end),0),greatest(ROUND(dueamt)+ROUND(ovamt)+ROUND(depofeeamt) - balance - avladvance,0))) addvnd,
    case when
      --(
        (sec.rlsmarginrate<af.mrlrate and af.mrlrate <> 0) then 'X'
        when
        (EXISTS   (
                          SELECT AFACCTNO FROM
                        (
                            SELECT DISTINCT A.AFACCTNO,COUNT(*) NUM FROM
                                (select distinct txdate , afacctno from  mr3008_log where log_action = 'BF-EOD' group by txdate, afacctno
                                union
                                select distinct txdate, afacctno from mr3009_logall where (log_action =  'BF-EOD') or (log_action = 'AF_END' and txdate <> getcurrdate) group by txdate, afacctno
                                ) a, afmast b
                            where a.afacctno = b.acctno --AND LOG_ACTION = 'BF-EOD'
                            --and a.marginrate < b.mrmrate
                            AND A.TXDATE>= (select sbdate from sbcurrdate where numday=-3 and sbtype='B'
                                           )
                            GROUP BY a.AFACCTNO
                        )  WHERE NUM>=3 AND af.acctno=AFACCTNO
                    )
          AND sec.rlsmarginrate < AF.mrmrate
          ) then 'X'
        when (ci.ovamt - NVL(sec.NYOVDAMT,0)>1 and ln.liqday >0) then 'X'
      --chaunh
        --when ( sec.rlsmarginrate < AF.mrmrate
       --      and (af.acctno in (
        --                  select distinct afacctno from mr3009_logall a where log_action = 'AF-END'
          --                    and a.txdate = getcurrdate
        --                  )
         --        )
        --    )
        --)
       -- then 'X'
    when (
            (  (af.mrlrate <= sec.rlsmarginrate AND sec.rlsmarginrate<af.mrmrate)
                or (ci.dueamt>1)
            )
    -- HaiLT them dieu kien de lay len 3 ngay lien tiep ti le thuc te < ti le canh bao
            and  not EXISTS
                    (
                        SELECT AFACCTNO FROM
                        (
                            SELECT DISTINCT A.AFACCTNO,COUNT(*) NUM FROM
                                (select distinct txdate , afacctno from  mr3008_log where log_action = 'BF-EOD' group by txdate, afacctno
                                union
                                select distinct txdate, afacctno from mr3009_logall where (log_action =  'BF-EOD') or (log_action = 'AF_END' and txdate <> getcurrdate) group by txdate, afacctno
                                ) a, afmast b
                            where a.afacctno = b.acctno --AND LOG_ACTION = 'BF-EOD'
                            --and a.marginrate < b.mrmrate
                            AND A.TXDATE>= (select sbdate from sbcurrdate where numday=-3 and sbtype='B'
                                           )
                            GROUP BY a.AFACCTNO
                        )  WHERE NUM>=3 AND af.acctno=AFACCTNO
                    )
    --Chaunh: neu dang doi xu ly thi khong call
            /*and af.acctno not in (select distinct afacctno from mr3009_logall a where log_action = 'AF-END'
                              and a.txdate = getcurrdate
                       )
*/

        )
        then 'C'
      end ACTION,NVL(sec.NYOVDAMT,0) NYOVDAMT

    from
      cfmast cf, afmast af, cimast ci, aftype aft, v_getsecmarginratio_all sec,
      (select varvalue ofs from sysvar where varname = 'OPTFORCESELL') sys,
      (
      select trfacctno, max(liqday) liqday,
              trunc(sum(round(oprinovd)+round(ointovdacr)+round(ointnmlovd)),0) t0ovdamt,
              trunc(sum(round(prinovd)+round(intovdacr)+round(intnmlovd)+round(feeintovdacr)+round(feeintnmlovd)),0) marginovdamt,
              trunc(sum(round(oprinnml)+round(oprinovd)+round(ointnmlacr)+round(ointdue)+round(ointovdacr)+round(ointnmlovd)),0) t0amt
              from lnmast ln,
                      (select acctno, round(sum(nml+intdue)) dueamt  from lnschd
                              where reftype = 'P' and overduedate = (select to_date(varvalue,'DD/MM/RRRR') from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM')
                              group by acctno) ls,
                      (
                        select ln.acctno,
                         case when  fn_getworkday(lns.overduedate) <> 0 and
                             lnt.LIQOVDDAY <= fn_getworkday(lns.overduedate) then 1 else 0 end liqday
                      from
                          ( select acctno, min(overduedate) overduedate from lnschd where reftype in ('P','GP') group by acctno) lns,
                          lnmast ln, lntype lnt
                      where ln.acctno=lns.acctno(+) and ln.actype=lnt.actype

                      ) lsa

              where ftype = 'AF' and ln.acctno = lsa.acctno
                      and ln.acctno = ls.acctno(+)
              group by ln.trfacctno
      ) ln,

    (select od.afacctno,
      round(sum(od.remainqtty*od.quoteprice*(1-odt.deffeerate/100-to_number(sy.varvalue)/100)*(1-nvl(rsk.advrate,adt.advrate/100)*sys1.advclearday/360)),0) realsellamt, --- so tien ban tru phi, thue, UTTB
      round(sum(od.remainqtty*od.quoteprice),0) asssellamt, --- so tien ban chua tru phi, thue, UTTB
      round(greatest(sum(od.remainqtty*od.quoteprice*(1-odt.deffeerate/100-to_number(sy.varvalue)/100)*(1-nvl(rsk.advrate,adt.advrate/100)*3/360) - od.remainqtty*least(nvl(rsk.mrpriceloan,0),marginprice)*nvl(rsk.mrratiorate,0)/(case when nvl(decode(sys.ofs,'M',rsk.mrmrate,rsk.mrirate),100) = 0 then 100 else nvl(decode(sys.ofs,'M',rsk.mrmrate,rsk.mrirate),100) end) ),0)) sellamount,
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
      group by afacctno) od
      , (select cf.fullname refullname, re.afacctno from reaflnk re, recfdef rc, cfmast cf, recflnk ra, retype rt
        where substr(re.reacctno,1,10) = cf.custid and substr(re.reacctno,11,4) = rc.reactype
        and re.status = 'A' and rc.status = 'A' and  rc.refrecflnkid = ra.autoid and cf.custid = ra.custid and rc.reactype = rt.actype and rt.rerole in ('BM','RM')) re

    where cf.custid = af.custid
    and cf.custatcom = 'Y'
    and af.actype = aft.actype
    and af.acctno = ci.acctno
    and af.acctno = sec.afacctno
    and af.acctno = ln.trfacctno(+)
    and af.acctno = od.afacctno(+)
    and af.acctno = re.afacctno(+)
) main, allcode a
where action is not null
and a.cdtype = 'MR' and a.cdname = 'ASTATUS' and a.cdval = main.action
;

