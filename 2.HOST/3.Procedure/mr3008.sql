CREATE OR REPLACE PROCEDURE mr3008 (
   PV_REFCURSOR                 IN OUT   PKG_REPORT.REF_CURSOR,
   PV_OPT                       IN       VARCHAR2,
   PV_BRID                      IN       VARCHAR2,
   I_DATE                       IN       VARCHAR2
   )
IS
-- MODIFICATION HISTORY
-- BAO CAO TONG HOP MARGIN CALL THEO NGAY
-- PERSON   DATE  COMMENTS
-- LINHLNB  13-04-2012  CREATED
-- ---------   ------  -------------------------------------------
l_NEXTDATE varchar2(10);
l_CURRDATE  varchar2(10);
l_OPT varchar2(10);
l_BRID varchar2(1000);
l_BRID_FILTER varchar2(1000);
BEGIN

select varvalue into l_NEXTDATE from sysvar where varname = 'NEXTDATE';
select varvalue into l_CURRDATE from sysvar where varname = 'CURRDATE';
l_OPT:=PV_OPT;

IF (l_OPT = 'A') THEN
  l_BRID_FILTER := '%';
ELSE if (l_OPT = 'B') then
        select brgrp.mapid into l_BRID_FILTER from brgrp where brgrp.brid = PV_BRID;
    else
        l_BRID_FILTER := PV_BRID;
    end if;
END IF;

select '[' || brid || ']: ' || brname into l_BRID
from brgrp
where brid = PV_BRID;

if l_CURRDATE = I_DATE then --Lay du lieu trong ngay

    OPEN PV_REFCURSOR
    FOR
        select *
        from (
        select l_OPT OPT,l_BRID BRID, l_NEXTDATE RPTDATE,'AF' FTYPE,cf.custodycd, af.acctno afacctno, '' dfgroupid, cf.fullname,
        sec.rlsmarginrate marginrate, af.mrmrate,
            ci.odamt, sec.NAVACCOUNT,
            greatest(round((case when nvl(sec.rlsmarginrate,0) * af.mrirate =0 then - outstandingt2 else
                             greatest( 0,- outstandingt2 - navaccountt2 *100/af.mrmrate) end),0)) addvnd,
        re.refullname

        from cfmast cf, afmast af, cimast ci, aftype aft, mrtype mrt, v_getsecmarginratio_all sec,
        (select re.afacctno, MAX(cf.fullname) refullname
            from reaflnk re, sysvar sys, cfmast cf,RETYPE
            where to_date(varvalue,'DD/MM/RRRR') between re.frdate and re.todate
            and substr(re.reacctno,0,10) = cf.custid
            and varname = 'CURRDATE' and grname = 'SYSTEM'
            and re.status <> 'C' and re.deltd <> 'Y'
            AND   substr(re.reacctno,11) = RETYPE.ACTYPE
            AND  rerole IN ( 'RM','BM')
            GROUP BY AFACCTNO
        ) re
        where cf.custid = af.custid and af.acctno = sec.afacctno
        and af.actype = aft.actype and af.acctno = ci.acctno
        and aft.mrtype = mrt.actype and mrt.mrtype = 'T'
        and ROUND(ci.ovamt) = 0
        and af.acctno = re.afacctno(+)
        and ( (af.mrlrate < sec.rlsmarginrate AND sec.rlsmarginrate < af.mrmrate))
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
       /* and af.acctno not in (select distinct afacctno from mr3009_logall a where log_action = 'AF-END'
                            and a.txdate = getcurrdate
                     )*/


        and case when l_OPT = 'A' then 1 else instr(l_BRID_FILTER,substr(af.acctno,1,4)) end  <> 0

        union all

        SELECT l_OPT OPT,l_BRID BRID, l_NEXTDATE RPTDATE,'DF' FTYPE,custodycd,afacctno, groupid dfgroupid,fullname, rtt, mrate, DDF, tadf, ODSELLDF,
        refullname
        FROM ( select al1.cdcontent DEALFLAGTRIGGER,DF.GROUPID,CF.CUSTODYCD,CF.FULLNAME,AF.ACCTNO AFACCTNO,CF.ADDRESS,CF.IDCODE,nvl(DF.CONTRACTCHK,'N') CONTRACTCHK,DECODE(DF.LIMITCHK,'N',0,1) LIMITCHECK ,
        DF.ORGAMT -DF.RLSAMT AMT, DF.LNACCTNO , DF.STATUS DEALSTATUS ,DF.ACTYPE ,DF.RRTYPE, DF.DFTYPE, DF.CUSTBANK, DF.CIACCTNO,DF.FEEMIN,
        DF.TAX,DF.AMTMIN,DF.IRATE,DF.MRATE,DF.LRATE,DF.RLSAMT,DF.DESCRIPTION, lns.rlsdate, lns.overduedate,
        to_date (lns.overduedate,'DD/MM/RRRR') - to_date ((SELECT VARVALUE FROM SYSVAR WHERE VARNAME='CURRDATE'),'DD/MM/RRRR') duenum,
        (case when df.ciacctno is not null then df.ciacctno when df.custbank is not null then   df.custbank else '' end )
        RRID , decode (df.RRTYPE,'O',1,0) CIDRAWNDOWN,decode (df.RRTYPE,'B',1,0) BANKDRAWNDOWN,
        decode (df.RRTYPE,'C',1,0) CMPDRAWNDOWN,dftype.AUTODRAWNDOWN,df.calltype,LN.RLSAMT AMTRLS,
        LN.RATE1,LN.RATE2,LN.RATE3,LN.CFRATE1,LN.CFRATE2,LN.CFRATE3,
        A1.CDCONTENT PREPAIDDIS,A2.CDCONTENT INTPAIDMETHODDIS,A3.CDCONTENT AUTOAPPLYDIS,TADF,DDF, RTTDF RTT, ODCALLDF, ODCALLSELLRCB,ODCALLSELLMRATE, ODCALLSELLMRATE - NVL(od.sellamount,0) ODSELLDF, ODCALLSELLRXL, ODCALLRTTDF, ODCALLRTTDF ODCALLRTTF,
        CURAMT, CURINT, CURFEE, LNS.PAID, DF.DFBLOCKAMT, vndselldf, vndwithdrawdf, tadf - ddf*(v.irate/100) vwithdrawdf,
        LEAST(ln.MInterm, TO_NUMBER( TO_DATE(lns.OVERDUEDATE,'DD/MM/RRRR') - TO_DATE(lns.RLSDATE,'DD/MM/RRRR')) )  MInterm, ln.intpaidmethod, lnt.WARNINGDAYS,
        A4.CDCONTENT RRTYPENAME, AF.FAX1, CF.EMAIL, ODDF, re.refullname,
        nvl(ln.prinovd+ln.intovdacr+ln.intnmlovd+ln.feeintovdacr+ln.feeintnmlovd,0)  df_ovdamt
        from dfgroup df, dftype, lnmast ln, lntype lnt ,lnschd lns, afmast af , cfmast cf, allcode al1,
           ALLCODE A1, ALLCODE A2, ALLCODE A3, v_getgrpdealformular v , allcode A4, v_getdealsellamt od,
        (select re.afacctno, MAX(cf.fullname) refullname
            from reaflnk re, sysvar sys, cfmast cf,RETYPE
            where to_date(varvalue,'DD/MM/RRRR') between re.frdate and re.todate
            and substr(re.reacctno,0,10) = cf.custid
            and varname = 'CURRDATE' and grname = 'SYSTEM'
            and re.status <> 'C' and re.deltd <> 'Y'
            AND   substr(re.reacctno,11) = RETYPE.ACTYPE
            AND  rerole IN ( 'RM','BM')
            GROUP BY AFACCTNO
        ) re
        where df.lnacctno= ln.acctno and ln.acctno=lns.acctno and ln.actype=lnt.actype and lns.reftype='P' and df.afacctno= af.acctno and af.custid= cf.custid and df.actype=dftype.actype
        and A1.cdname = 'YESNO' and A1.cdtype ='SY' AND A1.CDVAL = LN.PREPAID
        and A2.cdname = 'INTPAIDMETHOD' and A2.cdtype ='LN' AND A2.CDVAL = LN.INTPAIDMETHOD
        and A3.cdname = 'AUTOAPPLY' and a3.cdtype ='LN' AND A3.CDVAL = LN.AUTOAPPLY
        and A4.cdname = 'RRTYPE' and A4.cdtype ='DF' AND A4.CDVAL = DF.RRTYPE
        and df.flagtrigger=al1.cdval and al1.cdname='FLAGTRIGGER' and df.groupid=v.groupid(+)
        and df.groupid=od.groupid(+) and df.afacctno=od.afacctno(+)
        and df.afacctno = re.afacctno(+)
        and case when l_OPT = 'A' then 1 else instr(l_BRID_FILTER,substr(af.acctno,1,4)) end  <> 0
        ) WHERE ODDF>0 AND ( RTT <= MRATE AND RTT> LRATE) and df_ovdamt <=0
        ) order by custodycd, dfgroupid;

else --Lau du lieu trong qua khu
    OPEN PV_REFCURSOR
    FOR
    SELECT l_OPT OPT,l_BRID BRID, l_NEXTDATE RPTDATE, FTYPE,custodycd, afacctno, dfgroupid, fullname,
    marginrate, mrmrate,odamt, NAVACCOUNT,addvnd,refullname
    from mr3008_log lg
    where txdate = to_date(I_DATE,'DD/MM/RRRR')
    and log_action ='AF-END'
    and case when l_OPT = 'A' then 1 else instr(l_BRID_FILTER,substr(afacctno,1,4)) end  <> 0
    order by custodycd, dfgroupid;

end if;

EXCEPTION
   WHEN OTHERS
   THEN
 --   pr_error('MR3008','Error when others then:'||SQLERRM);
      RETURN;
END;
/

