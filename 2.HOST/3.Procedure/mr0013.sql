CREATE OR REPLACE PROCEDURE mr0013 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   p_OPT            IN       VARCHAR2,
   p_BRID           IN       VARCHAR2,
   p_DATE         in       VARCHAR2,
   p_RESTYPE      in       VARCHAR2,
   p_CUSTODYCD   IN       VARCHAR2,
   p_AFACCTNO    IN       VARCHAR2,
   p_FR_RLSDATE       in       VARCHAR2,
   p_TO_RLSDATE       in       VARCHAR2,
   p_FR_OVERDUEDATE       in       VARCHAR2,
   p_TO_OVERDUEDATE       in       VARCHAR2,
   p_RLSTYPE       in       VARCHAR2,
   p_ISVSD       in       VARCHAR2,
   p_PAIDSTATUS       in       VARCHAR2,
   p_PERIODSTATUS       in       VARCHAR2,
   p_USER       in       VARCHAR2
   )
IS
--

-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- NAMNT   12-APR-2012  CREATE
-- ---------   ------  -------------------------------------------

    l_OPT varchar2(10);
    l_BRID varchar2(1000);
    l_BRID_FILTER varchar2(1000);
    l_CUSTODYCD varchar2(10);
    l_AFACCTNO varchar2(10);
    l_ISVSD varchar2(10);
    k int;
BEGIN

-- Prepare Parameters
    l_OPT:=p_OPT;

    IF (l_OPT = 'A') THEN
      l_BRID_FILTER := '%';
    ELSE if (l_OPT = 'B') then
            select brgrp.mapid into l_BRID_FILTER from brgrp where brgrp.brid = p_BRID;
        else
            l_BRID_FILTER := p_BRID;
        end if;
    END IF;

    if p_CUSTODYCD = 'A' or p_CUSTODYCD = 'ALL' then
        l_CUSTODYCD:= '%%';
    else
        l_CUSTODYCD:= p_CUSTODYCD;
    end if;

    if p_AFACCTNO = 'A' or p_AFACCTNO = 'ALL' then
        l_AFACCTNO:= '%%';
    else
        l_AFACCTNO:= p_AFACCTNO;
    end if;

    IF p_ISVSD = 'ALL' then
        l_ISVSD := '%%';
    elsIF TRIM(p_ISVSD) = '001' THEN
        l_ISVSD := 'N';
    else
        l_ISVSD := 'Y';
    end if;
  select to_date(varvalue,'DD/MM/RRRR') -to_date(p_DATE,'DD/MM/RRRR') into k from sysvar  --K là s? ngày l?ch gi?a ngày l?y báo cáo và ngày h? th?ng hi?n t?i
    where VARNAME ='CURRDATE';
    if (k<0) then k:=0;
     end if;
     --FN_GETREDRAWDOWNDATE_Thaont(ls.autoid,k,lech_ngay) tuoi_no
--decode(to_date(ls.paiddate,'DD/MM/RRRR') -to_date(p_DATE,'DD/MM/RRRR'), 'to_date(ls.paiddate,''DD/MM/RRRR'') -to_date(p_DATE,''DD/MM/RRRR'')>0',to_date(ls.paiddate,'DD/MM/RRRR') -to_date(p_DATE,'DD/MM/RRRR'),0)
    OPEN PV_REFCURSOR
    FOR
    SELECT restype, rlstype, custodycd, afacctno, rlsdate, overduedate, lnschdid, rlsprin, paid, lnprin,brid,careby, intamt, feeintamt,rate1,rate2,rate3,orate1,orate2,orate3,fullname,typename,FN_GETREDRAWDOWNDATE_Thaont(lnschdid,k,case when lech_ngay1>0 then lech_ngay1 else 0 end,case when  (rlsprin- paid +intamt + feeintamt =0 )  then 0 else 1 end) tuoi_no,paiddate,p_PAIDSTATUS trangthai,k lech_ngay,fn_getrootid(lnschdid) KH_goc 
      FROM (
        select NVL(DF.ISVSD,'N') ISVSD, nvl(cfb.shortname,'KBSV') restype, decode (NVL(DF.ISVSD,'N'),'Y', decode(ln.ftype||ls.reftype,'AFGP','BL','AFP','CL','DFP','DF','')||'-VSD', decode(ln.ftype||ls.reftype,'AFGP','BL','AFP','CL','DFP','DF','') ) rlstype,
            cf.custodycd, af.acctno afacctno, ls.rlsdate, ls.overduedate, ls.autoid lnschdid,cfb.brid,af.careby,     --,info_br.brid,
            ls.nml + ls.ovd +ls.paid rlsprin,ls.rate1,ls.rate2,ls.rate3,cf.fullname, ln.orate1,ln.orate2,ln.orate3,aft.typename,to_date(ls.paiddate,'DD/MM/RRRR') -to_date(p_DATE,'DD/MM/RRRR') lech_ngay1, ls.paiddate,         -- Thaont: thêm ls.rate1,ls.rate2,ls.rate3: l?y lãi su?t gi?i ngân margin,orate1,orate2,orate3 l?y lãi su?t b?o lãnh
            ls.paid - nvl(lg.paid,0) paid, ls.nml + ls.ovd - nvl(lg.nml,0) - nvl(lg.ovd,0) lnprin,
            ls.intnmlacr + ls.intdue + ls.intovd + ls.intovdprin
            - nvl(lg.intnmlacr,0)- nvl(lg.intdue,0)- nvl(lg.intovd,0)- nvl(lg.intovdprin,0) intamt,
            ls.feeintnmlacr + ls.feeintdue + ls.feeintnmlovd + ls.feeintovdacr+ls.feeovd
            - nvl(lg.feeintnmlacr,0)- nvl(lg.feeintdue,0)- nvl(lg.feeintnmlovd,0)- nvl(lg.feeintovdacr,0) - nvl(lg.feeovd,0) feeintamt

        from vw_lnmast_all ln, vw_lnschd_all ls, cfmast cf, afmast af, cfmast cfb,aftype aft, --Thao them Lntype,aftype d? l?y tru?ng phân bi?t tái ký hay không
      /*  ( select tlu.grpid CAREBY,tlg.GRPNAME,tlu.TLID,tlp.TLNAME,tlp.TLFULLNAME,tlu.brid,REC.CUSTID ma_MG,b.fullname ten_MG,b.autoid Ma_TT,b.Ten_TT,b.NHOMTRUONG 
        from TLGRPUSERS tlu, TLGROUPS tlg,tlprofiles tlp,RECFLNK REC,
        (SELECT RE.AUTOID,RE.FULLNAME ten_TT,RELNK.CUSTID,RELNK.STATUS,CF.FULLNAME,(SELECT FULLNAME FROM CFMAST CF WHERE CF.CUSTID =RE.CUSTID ) NHOMTRUONG FROM regrp RE, regrplnk RELNK ,CFMAST CF
        WHERE RELNK.REFRECFLNKID =RE.AUTOID AND RELNK.STATUS ='A' AND CF.CUSTID =RELNK.CUSTID) B
         where tlu.grpid =tlg.GRPID and tlu.TLID =tlp.tlid AND REC.REFTLID =tlp.tlid AND B.CUSTID =REC.CUSTID) info_br,*/ -- Th?o thêm b?ng info_br d? l?y careby và brid chính xác
            (select autoid, sum(nml) nml, sum(ovd) ovd, sum(paid) paid,
                sum(intnmlacr) intnmlacr, sum(intdue) intdue, sum(intovd) intovd, sum(intovdprin) intovdprin,
                sum(feeintnmlacr) feeintnmlacr, sum(feeintdue) feeintdue, sum(feeintovd) feeintnmlovd, sum(feeintovdprin) feeintovdacr,sum(feeovd) feeovd
            from (select * from lnschdlog union all select * from lnschdloghist) lg
            where lg.txdate > to_date(p_DATE,'DD/MM/RRRR')
            group by autoid) lg,
            (/*select re.afacctno, cf.custid recustid
                from reaflnk re, sysvar sys, cfmast cf
                where to_date(varvalue,'DD/MM/RRRR') between re.frdate and re.todate
                and substr(re.reacctno,0,10) = cf.custid
                and varname = 'CURRDATE' and grname = 'SYSTEM'
                and re.status <> 'C' and re.deltd <> 'Y'
                GROUP BY re.afacctno, cf.custid*/

     select re.afacctno, MAX(cf.custid) recustid
    from reaflnk re, sysvar sys, cfmast cf,RETYPE
    where to_date(varvalue,'DD/MM/RRRR') between re.frdate and re.todate
    and substr(re.reacctno,0,10) = cf.custid
    and varname = 'CURRDATE' and grname = 'SYSTEM'
    and re.status <> 'C' and re.deltd <> 'Y'
    AND   substr(re.reacctno,11) = RETYPE.ACTYPE
    AND  rerole IN ( 'RM','BM')
    GROUP BY AFACCTNO

                ) re,
            (select lnacctno, df.actype dftype, dft.isvsd  from dfgroup df, dftype dft where df.actype=dft.actype) df
        where ln.acctno = ls.acctno and instr(ls.reftype,'P') <> 0  -- and info_br.careby =af.careby 
            and case when l_OPT = 'A' then 1 else instr(l_BRID_FILTER,CF.BRID) end  <> 0  -- Th?o thay d? l?y brid theo cfmast instr(l_BRID_FILTER,substr(af.acctno,1,4)) end  <> 0
            and ln.trfacctno = af.acctno and af.custid = cf.custid  and aft.actype =af.actype --Th?o thêm cho lntype 20190607
            and ln.custbank = cfb.custid(+)
            and ls.autoid = lg.autoid(+)
            and ln.acctno = df.lnacctno(+)
            and ln.trfacctno = re.afacctno(+)
            and case when p_RESTYPE = 'ALL' then 1
                    when ln.rrtype = 'C' and p_RESTYPE = 'MSBS' then 1
                    when ln.rrtype = 'B' and p_RESTYPE = nvl(cfb.shortname,'MSBS') then 1
                    else 0 end <> 0
            and cf.custodycd like l_CUSTODYCD
            and af.acctno like l_AFACCTNO
            and ls.rlsdate <= to_date(p_DATE,'DD/MM/RRRR')
            and ls.rlsdate between to_date(p_FR_RLSDATE,'DD/MM/RRRR') and to_date(p_TO_RLSDATE,'DD/MM/RRRR')
            and ls.overduedate between to_date(p_FR_OVERDUEDATE,'DD/MM/RRRR') and to_date(p_TO_OVERDUEDATE,'DD/MM/RRRR')
            and case when p_RLSTYPE = 'ALL' then p_RLSTYPE else decode(ln.ftype||ls.reftype,'AFGP','BL','AFP','CL','DFP','DF','') end = p_RLSTYPE
            and case when p_PAIDSTATUS = 'ALL' then 1
                    when p_PAIDSTATUS = '001'
                                        and
                                        abs(ls.nml + ls.ovd) +
                                            abs( ls.intnmlacr + ls.intdue + ls.intovd + ls.intovdprin
            - nvl(lg.intnmlacr,0)- nvl(lg.intdue,0)- nvl(lg.intovd,0)- nvl(lg.intovdprin,0)) +
                                             abs(ls.feeintnmlacr + ls.feeintdue + ls.feeintnmlovd + ls.feeintovdacr
            - nvl(lg.feeintnmlacr,0)- nvl(lg.feeintdue,0)- nvl(lg.feeintnmlovd,0)- nvl(lg.feeintovdacr,0)) <1 THEN 1

                    when p_PAIDSTATUS = '002' and
                                        abs(ls.nml + ls.ovd) +
                                            abs( ls.intnmlacr + ls.intdue + ls.intovd + ls.intovdprin
            - nvl(lg.intnmlacr,0)- nvl(lg.intdue,0)- nvl(lg.intovd,0)- nvl(lg.intovdprin,0)) +
                                             abs(ls.feeintnmlacr + ls.feeintdue + ls.feeintnmlovd + ls.feeintovdacr
            - nvl(lg.feeintnmlacr,0)- nvl(lg.feeintdue,0)- nvl(lg.feeintnmlovd,0)- nvl(lg.feeintovdacr,0)) >=1 THEN 1
                    else 0 end <> 0
            and case when p_PERIODSTATUS = 'ALL' then 1
                when to_date(p_DATE,'DD/MM/RRRR') between ls.rlsdate and ls.overduedate - 1 and p_PERIODSTATUS = '001' then 1
                when to_date(p_DATE,'DD/MM/RRRR') = ls.overduedate and p_PERIODSTATUS = '002' then 1
                when to_date(p_DATE,'DD/MM/RRRR') > ls.overduedate and p_PERIODSTATUS = '003' then 1
                else 0 end <> 0
            and case when p_USER = 'ALL' then 1 when nvl(re.recustid,'') = p_USER then 1 else 0 end <> 0
    ) A WHERE isvsd like l_ISVSD
    order by custodycd, afacctno, rlsdate, lnschdid;


EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE