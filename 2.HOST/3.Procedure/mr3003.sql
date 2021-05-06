CREATE OR REPLACE PROCEDURE mr3003 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   p_OPT                    IN       VARCHAR2,
   p_BRID                   IN       VARCHAR2,
   PV_MON_DATE                 IN       VARCHAR2
  )
IS

--
-- BAO CAO DANH MUC CHUNG KHOAN THUC HIEN GIAO DICH KI QUY
-- MODIFICATION HISTORY
-- PERSON       DATE                COMMENTS
-- ---------   ------  -------------------------------------------
-- QUOCTA      17-02-2012           CREATED
--

   CUR                      PKG_REPORT.REF_CURSOR;
    l_OPT varchar2(10);
    l_BRID varchar2(1000);
    l_BRID_FILTER varchar2(1000);

   l_PrevFromDate               DATE;
   l_PrevToDate            DATE;
   l_FromDate               DATE;
   l_ToDate                 DATE;
   l_CurrDate               DATE;
   l_Fdate          DATE;
   l_nextfromdate         DATE;
   l_COUNTMRACC_BG          NUMBER(20,0);
   l_COUNTMRACC_END         NUMBER(20,0);
   l_MAXDEBT_BG                NUMBER(20,0);
   l_MAXDEBT_END                NUMBER(20,0);

   l_ODAMT_BG               NUMBER(20,0);
   l_ODAMT_END              NUMBER(20,0);

   l_SEREALASS_BG              NUMBER(20,0);
   l_SEREALASS_END              NUMBER(20,0);

   l_INTAMT_BG              NUMBER(20,0);
   l_INTAMT_END             NUMBER(20,0);

   l_FEEAMT_BG              NUMBER(20,0);
   l_FEEAMT_END             NUMBER(20,0);

   l_TOP5SYMBOL_BG             varchar2(30);
   l_TOP5SYMBOL_END             varchar2(30);
   l_count                 number;
   l_fromprinused          varchar2(3000);
   l_toprinused          varchar2(3000);


BEGIN

    l_OPT:=p_OPT;

    IF (l_OPT = 'A') THEN
      l_BRID_FILTER := '%';
    ELSE if (l_OPT = 'B') then
            select brgrp.mapid into l_BRID_FILTER from brgrp where brgrp.brid = p_BRID;
        else
            l_BRID_FILTER := p_BRID;
        end if;
    END IF;

  -- Lay ngay cuoi ki.
  select max(sbdate)
    into l_ToDate
  from sbcldr where cldrtype = '000' and trunc(sbdate,'MM') = to_date('01' || substr(PV_MON_DATE,3), SYSTEMNUMS.C_DATE_FORMAT);

  -- Lay ngay dau ki.
  l_FromDate:= trunc(to_date(l_ToDate,SYSTEMNUMS.C_DATE_FORMAT),'MM');

  select trunc(max(sbdate),'MM')
    into l_PrevFromDate
  from sbcldr where cldrtype = '000' and trunc(sbdate,'MM') < to_date('01' || substr( PV_MON_DATE,3), SYSTEMNUMS.C_DATE_FORMAT);

  l_PrevToDate:=last_day(l_PrevFromDate);

  select l_ToDate +1 into l_nextfromdate from dual ;

  select l_FromDate -1 into l_Fdate from dual ;

  --- LAY NGAY HE THONG
  SELECT TO_DATE(VARVALUE, SYSTEMNUMS.C_DATE_FORMAT)
  INTO   l_CurrDate
  FROM   SYSVAR
  WHERE  grname = 'SYSTEM' AND varname = 'CURRDATE';

  --- SO LUONG TAI KHOAN GIAO DICH KI QUI (DAU KI)
  /*SELECT COUNT(1)
    INTO l_COUNTMRACC_BG
  FROM   AFMAST AF, AFTYPE AFT, MRTYPE MRT, LNTYPE LNT,
    (select substr(record_key,11,10) afacctno, nvl(from_value,to_value) lastactype
        from maintain_log log where table_name = 'AFMAST' and column_name = 'ACTYPE'
        and maker_dt >= l_FromDate and action_flag = 'EDIT'
        and maker_dt || maker_time = (select min(maker_dt || maker_time) from maintain_log log2
                            where table_name = 'AFMAST' and column_name = 'ACTYPE'
                            and maker_dt >= l_FromDate and action_flag = 'EDIT'
                            and log.record_key = log2.record_key)) logaft
  WHERE  af.acctno = logaft.afacctno(+)
  and case when l_OPT = 'A' then 1 else instr(l_BRID_FILTER,substr(af.acctno,1,4)) end  <> 0
  and    nvl(logaft.lastactype,AF.ACTYPE)  = AFT.ACTYPE
  AND    AFT.MRTYPE = MRT.ACTYPE
  AND    MRT.MRTYPE = 'T'
  AND    AFT.LNTYPE = LNT.ACTYPE(+)
  AND    (NVL(LNT.CHKSYSCTRL, 'N') = 'Y'
            or exists (select 1 from afidtype afi, lntype lnt0
            where afi.objname = 'LN.LNTYPE' and afi.actype = lnt0.actype and afi.aftype = AFT.ACTYPE and lnt0.chksysctrl = 'Y'))
  AND    AF.OPNDATE < l_FromDate and l_FromDate >= to_date('16/04/2012','DD/MM/RRRR');*/


  select count(*) into l_COUNTMRACC_BG from
  (
      select * from
      (
          select af.*, aft.lntype  from
          (
            select af.acctno,  nvl( logaft.lastactype,af.actype) actype
            from afmast af
            ,(select substr(record_key,11,10) afacctno, nvl(from_value,to_value) lastactype
                from maintain_log log where table_name = 'AFMAST' and column_name = 'ACTYPE'
                and maker_dt >= l_FromDate  and action_flag = 'EDIT'
                and maker_dt || maker_time = (select min(maker_dt || maker_time) from maintain_log log2
                                    where table_name = 'AFMAST' and column_name = 'ACTYPE'
                                    and maker_dt >= l_FromDate /*- 1*/ and action_flag = 'EDIT' --chaunh commend
                                    and log.record_key = log2.record_key)) logaft
            where af.acctno = afacctno (+) and af.opndate < l_FromDate
          ) af,
          (
          select aft.actype, aft.mrtype, nvl(logln.lastactype, aft.lntype) lntype from aftype aft
          ,(select substr(record_key,11,4) actype, nvl(from_value,to_value) lastactype
                from maintain_log log where table_name = 'AFTYPE' and column_name = 'LNTYPE'
                and maker_dt >= l_FromDate and action_flag = 'EDIT'
                and maker_dt || maker_time = (select min(maker_dt || maker_time) from maintain_log log2
                                    where table_name = 'AFTYPE' and column_name = 'LNTYPE'
                                    and maker_dt >= l_FromDate and action_flag = 'EDIT'
                                    and log.record_key = log2.record_key)) logln

          where aft.actype =logln.actype(+)
          ) aft
          , mrtype mrt
          where af.actype = aft.actype and aft.mrtype = mrt.actype and mrt.mrtype = 'T'
      ) AF,
      (
        select lnt.actype lntactype, nvl(loglnt.lastlntype,lnt.chksysctrl) chksysctrl from lntype lnt
        ,(select substr(record_key,11,4) actype, nvl(from_value,to_value) lastlntype
            from maintain_log log where table_name = 'LNTYPE' and column_name = 'CHKSYSCTRL'
            and maker_dt >= l_FromDate and action_flag = 'EDIT'
            and maker_dt || maker_time = (select min(maker_dt || maker_time) from maintain_log log2
                                where table_name = 'LNTYPE' and column_name = 'CHKSYSCTRL'
                                and maker_dt >= l_FromDate and action_flag = 'EDIT'
                                and log.record_key = log2.record_key)) loglnt
        where lnt.actype = loglnt.actype (+)
      ) lnt,
      ( select afi.objname, nvl(logactype.lastactype, afi.actype) afiactype, nvl(logaftype.lastaftype,afi.aftype) afiaftype from afidtype afi
        ,(select  substr(child_record_key,11,length(trim(child_record_key))  - 11) autoid, nvl(from_value,to_value) lastactype
            from maintain_log log where table_name = 'AFTYPE' and column_name = 'ACTYPE' and child_table_name = 'AFIDTYPE'
            and maker_dt >= l_FromDate and action_flag = 'EDIT'
            and maker_dt || maker_time = (select min(maker_dt || maker_time) from maintain_log log2
                                where table_name = 'AFTYPE' and column_name in 'ACTYPE' and child_table_name = 'AFIDTYPE'
                                and maker_dt >= l_FromDate and action_flag = 'EDIT'
                                and log.record_key = log2.record_key)) logactype
        ,(select  substr(child_record_key,11,length(trim(child_record_key))  - 11) autoid, nvl(from_value,to_value) lastaftype
            from maintain_log log where table_name = 'AFTYPE' and column_name = 'AFTYPE' and child_table_name = 'AFIDTYPE'
            and maker_dt >= l_FromDate and action_flag = 'EDIT'
            and maker_dt || maker_time = (select min(maker_dt || maker_time) from maintain_log log2
                                where table_name = 'AFTYPE' and column_name in 'AFTYPE' and child_table_name = 'AFIDTYPE'
                                and maker_dt >= l_FromDate and action_flag = 'EDIT'
                                and log.record_key = log2.record_key)) logaFtype
        where afi.objname = 'LN.LNTYPE' and afi.autoid = logactype.autoid (+)  and afi.autoid = logaftype.autoid(+)
      ) afi
      where af.lntype  = lnt.lntactype and af.actype = afi.afiaftype(+)
  ) MAIN
  ,
  (
    select lnt.actype, nvl(loglnt.lastlntype,lnt.chksysctrl) chksysctrl00 from lntype lnt
    ,(select substr(record_key,11,4) actype, nvl(from_value,to_value) lastlntype
        from maintain_log log where table_name = 'LNTYPE' and column_name = 'CHKSYSCTRL'
        and maker_dt >= l_FromDate and action_flag = 'EDIT'
        and maker_dt || maker_time = (select min(maker_dt || maker_time) from maintain_log log2
                            where table_name = 'LNTYPE' and column_name = 'CHKSYSCTRL'
                            and maker_dt >= l_FromDate and action_flag = 'EDIT'
                            and log.record_key = log2.record_key)) loglnt
    where lnt.actype = loglnt.actype (+)
  ) lnt00
  where MAIN.afiactype = lnt00.actype(+)
  and decode(main.chksysctrl,'N',nvl(chksysctrl00,'N'),main.chksysctrl) = 'Y';



  --- SO LUONG TAI KHOAN GIAO DICH KI QUI (CUOI KI)
  /*SELECT COUNT(1)
    INTO l_COUNTMRACC_END
  FROM   AFMAST AF, AFTYPE AFT, MRTYPE MRT, LNTYPE LNT,
    (select substr(record_key,11,10) afacctno, nvl(from_value,to_value) lastactype
        from maintain_log log where table_name = 'AFMAST' and column_name = 'ACTYPE'
        and maker_dt > l_ToDate and action_flag = 'EDIT'
        and maker_dt || maker_time = (select min(maker_dt || maker_time) from maintain_log log2
                            where table_name = 'AFMAST' and column_name = 'ACTYPE'
                            and maker_dt > l_ToDate and action_flag = 'EDIT'
                            and log.record_key = log2.record_key)) logaft
  WHERE  af.acctno = logaft.afacctno(+)
  and case when l_OPT = 'A' then 1 else instr(l_BRID_FILTER,substr(af.acctno,1,4)) end  <> 0
  and    nvl(logaft.lastactype,AF.ACTYPE)  = AFT.ACTYPE
  AND    AFT.MRTYPE = MRT.ACTYPE
  AND    MRT.MRTYPE = 'T'
  AND    AFT.LNTYPE = LNT.ACTYPE(+)
  AND    (NVL(LNT.CHKSYSCTRL, 'N') = 'Y'
            or exists (select 1 from afidtype afi, lntype lnt0
            where afi.objname = 'LN.LNTYPE' and afi.actype = lnt0.actype and afi.aftype = AFT.ACTYPE and lnt0.chksysctrl = 'Y'))
  AND    AF.OPNDATE <= l_ToDate;*/
  select count(*) INTO l_COUNTMRACC_END from
  (
      select * from
      (
          select af.*, aft.lntype  from
          (
            select af.acctno,  nvl( logaft.lastactype,af.actype) actype
            from afmast af
            ,(select substr(record_key,11,10) afacctno, nvl(from_value,to_value) lastactype
                from maintain_log log where table_name = 'AFMAST' and column_name = 'ACTYPE'
                and maker_dt > l_ToDate and action_flag = 'EDIT'
                and maker_dt || maker_time = (select min(maker_dt || maker_time) from maintain_log log2
                                    where table_name = 'AFMAST' and column_name = 'ACTYPE'
                                    and maker_dt > l_ToDate and action_flag = 'EDIT'
                                    and log.record_key = log2.record_key)) logaft
            where af.acctno = afacctno (+) and af.opndate <= l_ToDate
          ) af,
          (
          select aft.actype, aft.mrtype, nvl(logln.lastactype, aft.lntype) lntype from aftype aft
          ,(select substr(record_key,11,4) actype, nvl(from_value,to_value) lastactype
                from maintain_log log where table_name = 'AFTYPE' and column_name = 'LNTYPE'
                and maker_dt > l_ToDate and action_flag = 'EDIT'
                and maker_dt || maker_time = (select min(maker_dt || maker_time) from maintain_log log2
                                    where table_name = 'AFTYPE' and column_name = 'LNTYPE'
                                    and maker_dt > l_ToDate and action_flag = 'EDIT'
                                    and log.record_key = log2.record_key)) logln

          where aft.actype =logln.actype(+)
          ) aft
          , mrtype mrt
          where af.actype = aft.actype and aft.mrtype = mrt.actype and mrt.mrtype = 'T'
      ) AF,
      (
        select lnt.actype lntactype, nvl(loglnt.lastlntype,lnt.chksysctrl) chksysctrl from lntype lnt
        ,(select substr(record_key,11,4) actype, nvl(from_value,to_value) lastlntype
            from maintain_log log where table_name = 'LNTYPE' and column_name = 'CHKSYSCTRL'
            and maker_dt > l_ToDate and action_flag = 'EDIT'
            and maker_dt || maker_time = (select min(maker_dt || maker_time) from maintain_log log2
                                where table_name = 'LNTYPE' and column_name = 'CHKSYSCTRL'
                                and maker_dt > l_ToDate and action_flag = 'EDIT'
                                and log.record_key = log2.record_key)) loglnt
        where lnt.actype = loglnt.actype (+)
      ) lnt,
      ( select afi.objname, nvl(logactype.lastactype, afi.actype) afiactype, nvl(logaftype.lastaftype,afi.aftype) afiaftype from afidtype afi
        ,(select  substr(child_record_key,11,length(trim(child_record_key))  - 11) autoid, nvl(from_value,to_value) lastactype
            from maintain_log log where table_name = 'AFTYPE' and column_name = 'ACTYPE' and child_table_name = 'AFIDTYPE'
            and maker_dt > l_ToDate and action_flag = 'EDIT'
            and maker_dt || maker_time = (select min(maker_dt || maker_time) from maintain_log log2
                                where table_name = 'AFTYPE' and column_name in 'ACTYPE' and child_table_name = 'AFIDTYPE'
                                and maker_dt > l_ToDate and action_flag = 'EDIT'
                                and log.record_key = log2.record_key)) logactype
        ,(select  substr(child_record_key,11,length(trim(child_record_key))  - 11) autoid, nvl(from_value,to_value) lastaftype
            from maintain_log log where table_name = 'AFTYPE' and column_name = 'AFTYPE' and child_table_name = 'AFIDTYPE'
            and maker_dt > l_ToDate and action_flag = 'EDIT'
            and maker_dt || maker_time = (select min(maker_dt || maker_time) from maintain_log log2
                                where table_name = 'AFTYPE' and column_name in 'AFTYPE' and child_table_name = 'AFIDTYPE'
                                and maker_dt > l_ToDate and action_flag = 'EDIT'
                                and log.record_key = log2.record_key)) logaFtype
        where afi.objname = 'LN.LNTYPE' and afi.autoid = logactype.autoid (+)  and afi.autoid = logaftype.autoid(+)
      ) afi
      where af.lntype  = lnt.lntactype and af.actype = afi.afiaftype(+)
  ) MAIN
  ,
  (
    select lnt.actype, nvl(loglnt.lastlntype,lnt.chksysctrl) chksysctrl00 from lntype lnt
    ,(select substr(record_key,11,4) actype, nvl(from_value,to_value) lastlntype
        from maintain_log log where table_name = 'LNTYPE' and column_name = 'CHKSYSCTRL'
        and maker_dt > l_ToDate and action_flag = 'EDIT'
        and maker_dt || maker_time = (select min(maker_dt || maker_time) from maintain_log log2
                            where table_name = 'LNTYPE' and column_name = 'CHKSYSCTRL'
                            and maker_dt > l_ToDate and action_flag = 'EDIT'
                            and log.record_key = log2.record_key)) loglnt
    where lnt.actype = loglnt.actype (+)
  ) lnt00
  where MAIN.afiactype = lnt00.actype(+)
  and decode(main.chksysctrl,'N',nvl(chksysctrl00,'N'),main.chksysctrl) = 'Y';




  --- HAN MUC TIN DUNG GIAO DICH KI QUI (DAU KI NHU CUOI KI VA LAY HIEN TAI)
  SELECT to_number(VARVALUE)
    INTO l_MAXDEBT_END
  FROM SYSVAR
  WHERE VARNAME = 'MAXDEBT'
  AND GRNAME = 'MARGIN';

  ------------ DU NO CHO VAY GIAO DICH KI QUY (GOC) -------------
  --------------------------------------------------------------------------

  SELECT nvl(A.ODAMT_CR,0) - nvl(B.ODAMT_FR_CR,0), nvl(A.ODAMT_CR,0) - nvl(C.ODAMT_TO_CR,0)
    INTO l_ODAMT_BG, l_ODAMT_END
  FROM
  --- TONG DU NO MARGIN HIEN TAI
  (SELECT SUM(LN.PRINNML + LN.PRINOVD) ODAMT_CR
  FROM   LNMAST LN, AFMAST AF, AFTYPE AFT, MRTYPE MRT, LNTYPE LNT
  WHERE  LN.FTYPE = 'AF'
  AND    LN.TRFACCTNO = AF.ACCTNO
  and case when l_OPT = 'A' then 1 else instr(l_BRID_FILTER,substr(af.acctno,1,4)) end  <> 0
  AND    AF.ACTYPE    = AFT.ACTYPE
  AND    AFT.MRTYPE   = MRT.ACTYPE
  AND    MRT.MRTYPE   = 'T'
  AND    LN.ACTYPE   = LNT.ACTYPE
  AND    LNT.CHKSYSCTRL = 'Y') A,

  --- TONG DU NO PHAT SINH TU NGAY FROM_DATE DEN NGAY HIEN TAI
  (SELECT NVL(SUM(CASE WHEN APP.TXTYPE = 'D' THEN -LNTR.NAMT ELSE LNTR.NAMT END), 0) ODAMT_FR_CR
  FROM  VW_LNTRAN_ALL LNTR, APPTX APP, VW_LNMAST_ALL LN, AFMAST AF, AFTYPE AFT, MRTYPE MRT, LNTYPE LNT
  WHERE   LNTR.TXCD = APP.TXCD
      AND APP.APPTYPE = 'LN'
      AND APP.FIELD IN ('PRINNML','PRINOVD')
      AND APP.TXTYPE IN ('C','D')
      AND LNTR.ACCTNO = LN.ACCTNO
      AND LN.FTYPE = 'AF'
      AND LN.TRFACCTNO = AF.ACCTNO
      and case when l_OPT = 'A' then 1 else instr(l_BRID_FILTER,substr(af.acctno,1,4)) end  <> 0
      AND AF.ACTYPE    = AFT.ACTYPE
      AND AFT.MRTYPE   = MRT.ACTYPE
      AND MRT.MRTYPE   = 'T'
      AND LN.ACTYPE   = LNT.ACTYPE
      AND LNT.CHKSYSCTRL = 'Y'
      AND LNTR.NAMT <> 0
      AND LNTR.DELTD <> 'Y'
      AND LNTR.BKDATE BETWEEN l_FromDate AND l_CurrDate) B,

   --- TONG DU NO PHAT SINH TU NGAY TO_DATE DEN NGAY HIEN TAI
  (SELECT NVL(SUM(CASE WHEN APP.TXTYPE = 'D' THEN -LNTR.NAMT ELSE LNTR.NAMT END), 0) ODAMT_TO_CR
  FROM  VW_LNTRAN_ALL LNTR, APPTX APP, VW_LNMAST_ALL LN, AFMAST AF, AFTYPE AFT, MRTYPE MRT, LNTYPE LNT
  WHERE   LNTR.TXCD = APP.TXCD
      AND APP.APPTYPE = 'LN'
      AND APP.FIELD IN ('PRINNML','PRINOVD')
      AND APP.TXTYPE IN ('C','D')
      AND LNTR.ACCTNO = LN.ACCTNO
      AND LN.FTYPE = 'AF'
      AND LN.TRFACCTNO = AF.ACCTNO
      and case when l_OPT = 'A' then 1 else instr(l_BRID_FILTER,substr(af.acctno,1,4)) end  <> 0
      AND AF.ACTYPE    = AFT.ACTYPE
      AND AFT.MRTYPE   = MRT.ACTYPE
      AND MRT.MRTYPE   = 'T'
      AND LN.ACTYPE   = LNT.ACTYPE
      AND LNT.CHKSYSCTRL = 'Y'
      AND LNTR.NAMT <> 0
      AND LNTR.DELTD <> 'Y'
      AND LNTR.BKDATE BETWEEN l_ToDate+1 AND l_CurrDate) C
  ;


 --ngoc.vu sua lay theo bang log, neu khong thi lay theo cau lenh phia duoi

 /* --- TONG GIA TRI CHUNG KHOAN KI QUY HIEN TAI
  select nvl(sum(prinused * least(sec0.marginrefprice,rsk.mrpriceloan)),0)   prinused
    into l_SEREALASS_BG
       from afmast af,
       (
           select codeid,afacctno, sum(prinused) prinused
           from (
               select * from afpralloc where txdate < l_FromDate and restype = 'M'
               union all
               select * from afprallochist where txdate < l_FromDate and restype = 'M'
           ) group by codeid, afacctno
       ) pr,
       (select * from securities_info_hist where histdate = (select max(histdate) from securities_info_hist where histdate < l_FromDate)) sec0,
       (select * from afmrseriskhist
                    where BACKUPDT = (select max(BACKUPDT) from afmrseriskhist where to_date(substr(BACKUPDT,1,10),'DD/MM/RRRR') < l_FromDate)) rsk
   where pr.codeid =  sec0.codeid
       and pr.afacctno = af.acctno
       and case when l_OPT = 'A' then 1 else instr(l_BRID_FILTER,substr(af.acctno,1,4)) end  <> 0
       and af.actype = rsk.actype
       and rsk.codeid = sec0.codeid;

  select nvl(sum(prinused * least(sec0.marginrefprice,rsk.mrpriceloan)),0)   prinused
    into l_SEREALASS_END
       from afmast af,
       (
           select codeid,afacctno, sum(prinused) prinused
           from (
               select * from afpralloc where txdate <= l_ToDate and restype = 'M'
               union all
               select * from afprallochist where txdate <= l_ToDate and restype = 'M'
           ) group by codeid, afacctno
       ) pr,
       (select * from securities_info_hist where histdate = (select max(histdate) from securities_info_hist where histdate <= l_ToDate)) sec0,
       (select * from afmrseriskhist
                    where BACKUPDT = (select max(BACKUPDT) from afmrseriskhist where to_date(substr(BACKUPDT,1,10),'DD/MM/RRRR') <= l_ToDate)) rsk
   where pr.codeid =  sec0.codeid
       and pr.afacctno = af.acctno
       and case when l_OPT = 'A' then 1 else instr(l_BRID_FILTER,substr(af.acctno,1,4)) end  <> 0
       and af.actype = rsk.actype
       and rsk.codeid = sec0.codeid;
*/



  ------------ DOANH THU TU HOAT DONG GIAO DICH KI QUI (LAI) -------------
  --------------------------------------------------------------------------

/*  SELECT greatest(nvl(A.INTAMT_CR,0) - nvl(B.INTAMT_FR_CR,0),0), greatest(nvl(A.INTAMT_CR,0) - nvl(C.INTAMT_TO_CR,0),0)
    INTO l_INTAMT_BG, l_INTAMT_END
  FROM
  --- TONG LAI MARGIN HIEN TAI
  (SELECT SUM(LN.INTPAID) INTAMT_CR
  FROM   LNMAST LN, AFMAST AF, AFTYPE AFT, LNTYPE LNT
  WHERE  LN.FTYPE = 'AF'
  AND    LN.TRFACCTNO = AF.ACCTNO
  AND    AF.ACTYPE    = AFT.ACTYPE
  AND    LN.ACTYPE   = LNT.ACTYPE
  and    ln.ftype = 'AF'
  AND    LNT.CHKSYSCTRL = 'Y') A,

  --- TONG LAI PHAT SINH TU NGAY FROM_DATE DEN NGAY HIEN TAI
  (select sum(log.INTPAID) INTAMT_FR_CR
    from vw_lnmast_all ln, lntype lnt, vw_lnschd_all ls,
    (select * from lnschdlog union all select * from lnschdloghist) log
    where ln.acctno = ls.acctno and ls.autoid = log.autoid and ls.reftype = 'P'
    and ln.actype = lnt.actype and lnt.chksysctrl = 'Y'
    and log.TXDATE BETWEEN l_FromDate AND l_CurrDate) B,

   --- TONG LAI PHAT SINH TU NGAY TO_DATE DEN NGAY HIEN TAI
  (select sum(log.INTPAID) INTAMT_TO_CR
    from vw_lnmast_all ln, lntype lnt, vw_lnschd_all ls,
    (select * from lnschdlog union all select * from lnschdloghist) log
    where ln.acctno = ls.acctno and ls.autoid = log.autoid and ls.reftype = 'P'
    and ln.actype = lnt.actype and lnt.chksysctrl = 'Y'
    and log.TXDATE  BETWEEN l_ToDate AND l_CurrDate) C;*/

    select nvl(sum(log.intpaid),0) into l_INTAMT_BG
    FROM
    vw_lnmast_all ln, lntype lnt, vw_lnschd_all ls,
    (select * from lnschdlog where intpaid <> 0 union all select * from lnschdloghist where intpaid <> 0) log
    where log.txdate between l_PrevFromDate and l_FromDate - 1
    and ln.acctno = ls.acctno and ls.autoid = log.autoid and ls.reftype = 'P'
    and ln.actype = lnt.actype and lnt.chksysctrl = 'Y'
    and case when l_OPT = 'A' then 1 else instr(l_BRID_FILTER,substr(ln.trfacctno,1,4)) end  <> 0
    and log.deltd <> 'Y';

    select nvl(sum(log.intpaid),0) into l_INTAMT_END
    FROM
    vw_lnmast_all ln, lntype lnt, vw_lnschd_all ls,
    (select * from lnschdlog where intpaid <> 0 union all select * from lnschdloghist where intpaid <> 0) log
    where log.txdate between l_FromDate and l_ToDate
    and ln.acctno = ls.acctno and ls.autoid = log.autoid and ls.reftype = 'P'
    and ln.actype = lnt.actype and lnt.chksysctrl = 'Y'
    and case when l_OPT = 'A' then 1 else instr(l_BRID_FILTER,substr(ln.trfacctno,1,4)) end  <> 0
    and log.deltd <> 'Y';



  ------------ DOANH THU TU HOAT DONG GIAO DICH KI QUI (PHI GD) -------------
  --------------------------------------------------------------------------
  select nvl(sum(decode(tx.txtype,'C',namt,-namt)),0) feeamt
        into l_FEEAMT_BG
    from
    (select * from odtran union all select * from odtrana) tr, apptx tx, vw_odmast_all od, afmast af, aftype aft, mrtype mrt,
    (select substr(record_key,11,10) afacctno, nvl(from_value,to_value) lastactype
        from maintain_log log where table_name = 'AFMAST' and column_name = 'ACTYPE'
        and maker_dt >= l_FromDate and action_flag = 'EDIT'
        and maker_dt || maker_time = (select min(maker_dt || maker_time) from maintain_log log2
                            where table_name = 'AFMAST' and column_name = 'ACTYPE'
                            and maker_dt >= l_FromDate and action_flag = 'EDIT'
                            and log.record_key = log2.record_key)) log
    where tr.acctno = od.orderid and tr.txcd = tx.txcd and tx.apptype = 'OD' and tx.field = 'FEEAMT' and tr.deltd <> 'Y'
    and od.afacctno = af.acctno and aft.actype = nvl(log.lastactype,af.actype)
    and aft.mrtype = mrt.actype and mrt.mrtype = 'T'
    and tr.txdate between l_PrevFromDate and l_FromDate - 1
    and af.acctno = log.afacctno(+)
    and case when l_OPT = 'A' then 1 else instr(l_BRID_FILTER,substr(af.acctno,1,4)) end  <> 0
    and od.txdate >= to_date('16/04/2012','DD/MM/RRRR')
    and exists (select 1 from lntype lnt0 where aft.lntype = lnt0.actype and lnt0.chksysctrl = 'Y'
        union all
        select 1 from afidtype afi, lntype lnt1
            where afi.objname = 'LN.LNTYPE' and afi.aftype = aft.actype and afi.actype  = lnt1.actype and lnt1.chksysctrl = 'Y')
    ;




  select nvl(sum(decode(tx.txtype,'C',namt,-namt)),0) feeamt
        into l_FEEAMT_END
    from
    (select * from odtran union all select * from odtrana) tr, apptx tx, vw_odmast_all od, afmast af, aftype aft, mrtype mrt,
    (select substr(record_key,11,10) afacctno, nvl(from_value,to_value) lastactype
        from maintain_log log where table_name = 'AFMAST' and column_name = 'ACTYPE'
        and maker_dt > l_ToDate
        and maker_dt || maker_time = (select min(maker_dt || maker_time) from maintain_log log2
                            where table_name = 'AFMAST' and column_name = 'ACTYPE'
                            and maker_dt > l_ToDate and action_flag = 'EDIT'
                            and log.record_key = log2.record_key)) log
    where  tr.acctno = od.orderid and tr.txcd = tx.txcd and tx.apptype = 'OD' and tx.field = 'FEEAMT' and tr.deltd <> 'Y'
    and od.afacctno = af.acctno and aft.actype = nvl(log.lastactype,af.actype)
    and aft.mrtype = mrt.actype and mrt.mrtype = 'T'
    and tr.txdate between l_FromDate and l_ToDate
    and af.acctno = log.afacctno(+)
    and case when l_OPT = 'A' then 1 else instr(l_BRID_FILTER,substr(af.acctno,1,4)) end  <> 0
    and od.txdate >= to_date('16/04/2012','DD/MM/RRRR')
    and exists (select 1 from lntype lnt0 where aft.lntype = lnt0.actype and lnt0.chksysctrl = 'Y'
        union all
        select 1 from afidtype afi, lntype lnt1
            where afi.objname = 'LN.LNTYPE' and afi.aftype = aft.actype and afi.actype  = lnt1.actype and lnt1.chksysctrl = 'Y')
    ;



   /* -- Top 5 Ma du no nhieu nhat.
    select max(decode(rn,1,symbol))
    || '-' || max(decode(rn,2,symbol))
    || '-' || max(decode(rn,3,symbol))
    || '-' || max(decode(rn,4,symbol))
    || '-' || max(decode(rn,5,symbol))
        into l_TOP5SYMBOL_END
    from
    (
        select rownum rn, codeid,symbol, prinused from (
          select codeid, symbol, prinused
          from (
            select pr.codeid,sec0.symbol, sum(prinused * rsk.mrratioloan * least(sec0.marginrefprice,rsk.mrpriceloan) / 100)   prinused
                from afmast af,
                (
                    select codeid,afacctno, sum(prinused) prinused
                    from (
                        select * from afpralloc where txdate <= l_ToDate and restype = 'M'
                        union all
                        select * from afprallochist where txdate <= l_ToDate and restype = 'M'
                    ) group by codeid, afacctno
                ) pr,
                \*securities_info sec0,
                afmrserisk rsk*\
                (select * from securities_info_hist where histdate = (select max(histdate) from securities_info_hist where histdate <= l_ToDate)) sec0,
                (select * from afmrseriskhist
                    where BACKUPDT = (select max(BACKUPDT) from afmrseriskhist where to_date(substr(BACKUPDT,1,10),'DD/MM/RRRR') <= l_ToDate)) rsk
            where pr.codeid =  sec0.codeid
                and pr.afacctno = af.acctno
                and af.actype = rsk.actype
                and rsk.codeid = sec0.codeid
            group by pr.codeid,sec0.symbol)
            order by prinused desc
        ) where rownum <= 5
    ) mst;*/
    l_count:=0;

    select count(*) into l_count from mr3003_log where prevdate=l_ToDate;
    if l_count >0 then
       select min(TOPSYMBOL), min(MPRINUSED) into l_TOP5SYMBOL_END,l_SEREALASS_END
       from mr3003_log where prevdate=l_ToDate;

    else
            select max(decode(rn,1,symbol))
                  || '-' || max(decode(rn,2,symbol))
                  || '-' || max(decode(rn,3,symbol))
                  || '-' || max(decode(rn,4,symbol))
                  || '-' || max(decode(rn,5,symbol)),
                  max(decode(rn,1,prinused))
                  || '-' || max(decode(rn,2,prinused))
                  || '-' || max(decode(rn,3,prinused))
                  || '-' || max(decode(rn,4,prinused))
                  || '-' || max(decode(rn,5,prinused))
                      into l_TOP5SYMBOL_END,l_toprinused
            from
            (
                select rownum rn, codeid,symbol, prinused from (
                  select codeid, symbol, prinused
                  from (
                    select pr.codeid,sec0.symbol, sum(prinused * rsk.mrratioloan * least(sec0.marginrefprice,rsk.mrpriceloan) / 100)   prinused
                        from afmast af,
                        (
                            select codeid,afacctno, sum(prinused) prinused
                            from (
                                select * from afpralloc where txdate <= l_ToDate and restype = 'M'
                                union all
                                select * from afprallochist where txdate <= l_ToDate and restype = 'M'
                            ) group by codeid, afacctno
                        ) pr,
                        (select * from securities_info_hist where histdate = (select max(histdate) from securities_info_hist where histdate <= l_ToDate)) sec0,
                        (/*select * from afmrseriskhist
                              where BACKUPDT = (select max(BACKUPDT) from afmrseriskhist where to_date(substr(BACKUPDT,1,10),'DD/MM/RRRR') <= '08/12/2015')
                           */
                            select af.*
                                  from afmrseriskhist af,
                                  (
                                      select af.actype, af.codeid, max(af.BACKUPDT) BACKUPDT
                                      from afmrseriskhist af,
                                      (
                                          select actype, codeid, max(to_date(substr(BACKUPDT,1,10),'DD/MM/RRRR')) BACKUPDT
                                          from afmrseriskhist where to_date(substr(BACKUPDT,1,10),'DD/MM/RRRR') <= l_ToDate
                                          group by actype, codeid
                                      ) af1
                                      where af.actype = af1.actype
                                      AND af.codeid = af1.codeid
                                      AND to_date(substr(af.BACKUPDT,1,10),'DD/MM/RRRR') = af1.BACKUPDT
                                      group by af.actype, af.codeid
                                  ) af2
                                  where af.actype = af2.actype
                                      AND af.codeid = af2.codeid
                                      AND af.BACKUPDT = af2.BACKUPDT
                          ) rsk
                    where pr.codeid =  sec0.codeid(+)
                        and pr.afacctno = af.acctno
                        and af.actype = rsk.actype(+)
                        and rsk.codeid = sec0.codeid
                    group by pr.codeid,sec0.symbol)
                    order by prinused  desc
                ) where rownum <= 5
            ) mst;
            select nvl(sum(prinused * least(sec0.marginrefprice,rsk.mrpriceloan)),0)   prinused
    into l_SEREALASS_END
       from afmast af,
       (
           select codeid,afacctno, sum(prinused) prinused
           from (
               select * from afpralloc where txdate <= l_ToDate and restype = 'M'
               union all
               select * from afprallochist where txdate <= l_ToDate and restype = 'M'
           ) group by codeid, afacctno
       ) pr,
       (select * from securities_info_hist where histdate = (select max(histdate) from securities_info_hist where histdate <= l_ToDate)) sec0,
       (select * from afmrseriskhist
                    where BACKUPDT = (select max(BACKUPDT) from afmrseriskhist where to_date(substr(BACKUPDT,1,10),'DD/MM/RRRR') <= l_ToDate)) rsk
   where pr.codeid =  sec0.codeid
       and pr.afacctno = af.acctno
       and case when l_OPT = 'A' then 1 else instr(l_BRID_FILTER,substr(af.acctno,1,4)) end  <> 0
       and af.actype = rsk.actype
       and rsk.codeid = sec0.codeid;


              /* select nvl(sum(prinused * least(sec0.marginrefprice,rsk.mrpriceloan)),0)   prinused
               into l_SEREALASS_END
                from afmast af,
                (
                    select codeid,afacctno, sum(prinused) prinused
                    from (
                        select * from afpralloc where txdate <= l_ToDate and restype = 'M'
                        union all
                        select * from afprallochist where txdate <= l_ToDate and restype = 'M'
                    ) group by codeid, afacctno
                ) pr,
                (select * from securities_info_hist where histdate = (select max(histdate) from securities_info_hist where histdate <= l_ToDate)) sec0,
                ( select af.*
                          from afmrseriskhist af,
                          (
                              select af.actype, af.codeid, max(af.BACKUPDT) BACKUPDT
                              from afmrseriskhist af,
                              (
                                  select actype, codeid, max(to_date(substr(BACKUPDT,1,10),'DD/MM/RRRR')) BACKUPDT
                                  from afmrseriskhist where to_date(substr(BACKUPDT,1,10),'DD/MM/RRRR') <= l_ToDate
                                  group by actype, codeid
                              ) af1
                              where af.actype = af1.actype
                              AND af.codeid = af1.codeid
                              AND to_date(substr(af.BACKUPDT,1,10),'DD/MM/RRRR') = af1.BACKUPDT
                              group by af.actype, af.codeid
                          ) af2
                          where af.actype = af2.actype
                              AND af.codeid = af2.codeid
                              AND af.BACKUPDT = af2.BACKUPDT
                  ) rsk
            where pr.codeid =  sec0.codeid(+)
                and pr.afacctno = af.acctno
                and af.actype = rsk.actype(+)
                and rsk.codeid = sec0.codeid;*/

            if l_CurrDate>l_ToDate then
                insert into MR3003_LOG(AUTOID,TXDATE,PREVDATE,NEXTDATE,TOPSYMBOL,PRINUSED, MPRINUSED)
                values(TO_CHAR(l_ToDate,'DDMMYYYY'),l_CurrDate, l_ToDate ,l_nextfromdate, l_TOP5SYMBOL_END, l_toprinused,l_SEREALASS_END);
            end if;
     End if;

    select count(*) into l_count from mr3003_log where nextdate=l_FromDate;
    if l_count >0 then
       select min(TOPSYMBOL), MIN(MPRINUSED) into l_TOP5SYMBOL_BG,l_SEREALASS_BG
       from mr3003_log where nextdate=l_FromDate;

    else

            select max(decode(rn,1,symbol))
                  || '-' || max(decode(rn,2,symbol))
                  || '-' || max(decode(rn,3,symbol))
                  || '-' || max(decode(rn,4,symbol))
                  || '-' || max(decode(rn,5,symbol)),
                  max(decode(rn,1,prinused))
                  || '-' || max(decode(rn,2,prinused))
                  || '-' || max(decode(rn,3,prinused))
                  || '-' || max(decode(rn,4,prinused))
                  || '-' || max(decode(rn,5,prinused))
                      into l_TOP5SYMBOL_BG, l_fromprinused
            from
            (
                select rownum rn, codeid,symbol, prinused from (
                  select codeid, symbol, prinused
                  from (
                    select pr.codeid,sec0.symbol, sum(prinused * rsk.mrratioloan * least(sec0.marginrefprice,rsk.mrpriceloan) / 100)   prinused
                        from afmast af,
                        (
                            select codeid,afacctno, sum(prinused) prinused
                            from (
                                select * from afpralloc where txdate < l_FromDate and restype = 'M'
                                union all
                                select * from afprallochist where txdate < l_FromDate and restype = 'M'
                            ) group by codeid, afacctno
                        ) pr,
                        (select * from securities_info_hist where histdate = (select max(histdate) from securities_info_hist where histdate < l_FromDate)) sec0,
                        (/*select * from afmrseriskhist
                              where BACKUPDT = (select max(BACKUPDT) from afmrseriskhist where to_date(substr(BACKUPDT,1,10),'DD/MM/RRRR') <= '08/12/2015')
                           */
                            select af.*
                                  from afmrseriskhist af,
                                  (
                                      select af.actype, af.codeid, max(af.BACKUPDT) BACKUPDT
                                      from afmrseriskhist af,
                                      (
                                          select actype, codeid, max(to_date(substr(BACKUPDT,1,10),'DD/MM/RRRR')) BACKUPDT
                                          from afmrseriskhist where to_date(substr(BACKUPDT,1,10),'DD/MM/RRRR') < l_FromDate
                                          group by actype, codeid
                                      ) af1
                                      where af.actype = af1.actype
                                      AND af.codeid = af1.codeid
                                      AND to_date(substr(af.BACKUPDT,1,10),'DD/MM/RRRR') = af1.BACKUPDT
                                      group by af.actype, af.codeid
                                  ) af2
                                  where af.actype = af2.actype
                                      AND af.codeid = af2.codeid
                                      AND af.BACKUPDT = af2.BACKUPDT
                          ) rsk
                    where pr.codeid =  sec0.codeid(+)
                        and pr.afacctno = af.acctno
                        and af.actype = rsk.actype(+)
                        and rsk.codeid = sec0.codeid
                    group by pr.codeid,sec0.symbol)
                    order by prinused  desc
                ) where rownum <= 5
            ) mst;

                    --- TONG GIA TRI CHUNG KHOAN KI QUY HIEN TAI
  select nvl(sum(prinused * least(sec0.marginrefprice,rsk.mrpriceloan)),0)   prinused
    into l_SEREALASS_BG
       from afmast af,
       (
           select codeid,afacctno, sum(prinused) prinused
           from (
               select * from afpralloc where txdate < l_FromDate and restype = 'M'
               union all
               select * from afprallochist where txdate < l_FromDate and restype = 'M'
           ) group by codeid, afacctno
       ) pr,
       (select * from securities_info_hist where histdate = (select max(histdate) from securities_info_hist where histdate < l_FromDate)) sec0,
       (select * from afmrseriskhist
                    where BACKUPDT = (select max(BACKUPDT) from afmrseriskhist where to_date(substr(BACKUPDT,1,10),'DD/MM/RRRR') < l_FromDate)) rsk
   where pr.codeid =  sec0.codeid
       and pr.afacctno = af.acctno
       and case when l_OPT = 'A' then 1 else instr(l_BRID_FILTER,substr(af.acctno,1,4)) end  <> 0
       and af.actype = rsk.actype
       and rsk.codeid = sec0.codeid;
            /*  select nvl(sum(prinused * least(sec0.marginrefprice,rsk.mrpriceloan)),0)   prinused
               into l_SEREALASS_BG
                from afmast af,
                (
                    select codeid,afacctno, sum(prinused) prinused
                    from (
                        select * from afpralloc where txdate < l_FromDate and restype = 'M'
                        union all
                        select * from afprallochist where txdate < l_FromDate and restype = 'M'
                    ) group by codeid, afacctno
                ) pr,
                (select * from securities_info_hist where histdate = (select max(histdate) from securities_info_hist where histdate < l_FromDate)) sec0,
                ( select af.*
                          from afmrseriskhist af,
                          (
                              select af.actype, af.codeid, max(af.BACKUPDT) BACKUPDT
                              from afmrseriskhist af,
                              (
                                  select actype, codeid, max(to_date(substr(BACKUPDT,1,10),'DD/MM/RRRR')) BACKUPDT
                                  from afmrseriskhist where to_date(substr(BACKUPDT,1,10),'DD/MM/RRRR') < l_FromDate
                                  group by actype, codeid
                              ) af1
                              where af.actype = af1.actype
                              AND af.codeid = af1.codeid
                              AND to_date(substr(af.BACKUPDT,1,10),'DD/MM/RRRR') = af1.BACKUPDT
                              group by af.actype, af.codeid
                          ) af2
                          where af.actype = af2.actype
                              AND af.codeid = af2.codeid
                              AND af.BACKUPDT = af2.BACKUPDT
                  ) rsk
            where pr.codeid =  sec0.codeid(+)
                and pr.afacctno = af.acctno
                and af.actype = rsk.actype(+)
                and rsk.codeid = sec0.codeid;*/

            IF l_CurrDate>l_Fdate THEN
                insert into MR3003_LOG(AUTOID,TXDATE,PREVDATE,NEXTDATE,TOPSYMBOL,PRINUSED,MPRINUSED)
                values(TO_CHAR(l_Fdate,'DDMMYYYY'),l_CurrDate,l_Fdate,l_FromDate , l_TOP5SYMBOL_BG, l_fromprinused,l_SEREALASS_BG);
            END IF;
     End IF;

   /* -- Top 5 Ma du no nhieu nhat.
    select max(decode(rn,1,symbol))
    || '-' || max(decode(rn,2,symbol))
    || '-' || max(decode(rn,3,symbol))
    || '-' || max(decode(rn,4,symbol))
    || '-' || max(decode(rn,5,symbol))
        into l_TOP5SYMBOL_BG
    from
    (
        select rownum rn, codeid,symbol, prinused from (
          select codeid, symbol, prinused
          from (
            select pr.codeid,sec0.symbol, sum(prinused * rsk.mrratioloan * least(sec0.marginrefprice,rsk.mrpriceloan) / 100)   prinused
                from afmast af,
                (
                    select codeid,afacctno, sum(prinused) prinused
                    from (
                        select * from afpralloc where txdate < l_FromDate and restype = 'M'
                        union all
                        select * from afprallochist where txdate < l_FromDate and restype = 'M'
                    ) group by codeid, afacctno
                ) pr,
                (select * from securities_info_hist where histdate = (select max(histdate) from securities_info_hist where histdate < l_FromDate)) sec0,
                (select * from afmrseriskhist
                    where BACKUPDT = (select max(BACKUPDT) from afmrseriskhist where to_date(substr(BACKUPDT,1,10),'DD/MM/RRRR') < l_FromDate)) rsk
            where pr.codeid =  sec0.codeid(+)
                and pr.afacctno = af.acctno
                and af.actype = rsk.actype(+)
                and rsk.codeid = sec0.codeid
            group by pr.codeid,sec0.symbol)
            order by prinused  desc
        ) where rownum <= 5
    ) mst;*/


OPEN PV_REFCURSOR FOR

SELECT l_COUNTMRACC_BG COUNTMRACC_BG, l_COUNTMRACC_END COUNTMRACC_END,
       nvl(l_MAXDEBT_BG,0) MAXDEBT_BG, l_MAXDEBT_END MAXDEBT_END, l_ODAMT_BG ODAMT_BG, l_ODAMT_END ODAMT_END,
       l_SEREALASS_BG SEREALASS_BG, l_SEREALASS_END SEREALASS_END,
       l_INTAMT_BG INTAMT_BG, l_INTAMT_END INTAMT_END, l_FEEAMT_BG FEEAMT_BG, l_FEEAMT_END FEEAMT_END,
       l_TOP5SYMBOL_BG TOP5SYMBOL_BG, l_TOP5SYMBOL_END TOP5SYMBOL_END,
       to_char(l_FromDate,'DD/MM/RRRR') FRDATE, to_char(l_ToDate,'DD/MM/RRRR') TODATE
FROM DUAL;

EXCEPTION
  WHEN OTHERS
   THEN
      RETURN;
END;
/

