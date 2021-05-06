CREATE OR REPLACE PROCEDURE mr0012 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         in       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2,
   I_STATUS       in       VARCHAR2,
   I_DUESTS       in       VARCHAR2,
   p_RESTYPE      in       VARCHAR2,
   p_FR_RLSDATE       in       VARCHAR2,
   p_TO_RLSDATE       in       VARCHAR2,
   p_FR_OVERDUEDATE       in       VARCHAR2,
   p_TO_OVERDUEDATE       in       VARCHAR2,
   TLID IN VARCHAR2 --thuyct them tham so user de check theo careby
   )
IS
--

-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- THANHNM   12-APR-2012  CREATE
-- ---------   ------  -------------------------------------------
  -- PV_A            PKG_REPORT.REF_CURSOR;
   V_STROPTION      VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0

   V_STRI_BRID      VARCHAR2 (5);
   V_STRI_TYPE      VARCHAR2 (5);
   V_STRCIACCTNO    VARCHAR2 (20);

   V_STRACCTNO      VARCHAR2 (20);

   V_STRFULLNAME    VARCHAR2 (100);
   V_STRCUSTODYCD   VARCHAR2 (20);
   V_CURRDATE       DATE;

   V_APMT           NUMBER(20,0);
   V_T0_APMT        NUMBER(20,0);
   V_T1_APMT        NUMBER(20,0);
   V_T2_APMT        NUMBER(20,0);
   V_BALANCE        NUMBER(20,0);
   V_DFDEBTAMT      NUMBER(20,0);
   V_ADVANCELINE    NUMBER(20,0);
   V_PAIDAMT        NUMBER(20,0);
   V_BALDEFOVD      NUMBER(20,0);
   V_MBLOCK         NUMBER(20,0);
   V_AAMT           NUMBER(20,0);
   V_SECUREAMT      NUMBER(20,0);
   V_T0ODAMT        NUMBER(20,0);
   V_TRFBUYAMT   NUMBER(20,0);
   V_MARGINAMT   NUMBER(20,0);
     V_T0AMT  NUMBER(20,0);
     V_DUEAMT   NUMBER(20,0);
     V_IDATE       date;
     V_STRSTATUS   varchar2(3);
     V_ADDVND   NUMBER(20,0);
     V_SETOTALCALLASS  number (20,0);
     v_TLID varchar2(4); -- thuyct add

   BEGIN
   V_STROPTION := OPT;

   IF V_STROPTION = 'A' THEN     -- TOAN HE THONG
      V_STRBRID := '%';
   ELSIF V_STROPTION = 'B' THEN
      V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
   ELSE
      V_STRBRID := BRID;
   END IF;

   V_IDATE := to_date (I_DATE,'DD/MM/RRRR');
   V_STRSTATUS:= I_STATUS;

 v_TLID := TLID; --thuyct add
   V_STRCUSTODYCD:=PV_CUSTODYCD;

      IF PV_AFACCTNO ='ALL' THEN
   V_STRCIACCTNO:='%%';
   ELSE
   V_STRCIACCTNO  := PV_AFACCTNO;
   END IF;
   V_T0_APMT:=0;      V_T1_APMT:=0;         V_T2_APMT:=0;         V_APMT:=0;
        V_AAMT:=0; V_MBLOCK:=0; V_APMT:=0; V_BALANCE:=0; V_DFDEBTAMT:=0; V_ADVANCELINE:=0;V_SECUREAMT:=0;V_T0ODAMT:=0; V_PAIDAMT:=0;
        V_TRFBUYAMT:=0; V_MARGINAMT:=0; V_T0AMT:=0; V_DUEAMT:=0;  V_BALDEFOVD:=0;
        V_ADDVND   :=0;         V_SETOTALCALLASS :=0;

select fullname, CUSTODYCD into V_STRFULLNAME,V_STRCUSTODYCD  from cfmast where CUSTODYCD = V_STRCUSTODYCD;

SELECT TO_DATE(VARVALUE,'DD/MM/YYYY') INTO V_CURRDATE FROM SYSVAR WHERE VARNAME LIKE 'CURRDATE' AND GRNAME = 'SYSTEM';
SELECT MAXAVLAMT INTO V_APMT FROM ( SELECT nvl(SUM(MAXAVLAMT),0)  MAXAVLAMT FROM
(
SELECT CF.CUSTODYCD, CLEARDATE,TXDATE,
    RF.EXECAMT-RF.AAMT-RF.BRKFEEAMT-RF.RIGHTTAX-RF.INCOMETAXAMT MAXAVLAMT,
    RF.EXECAMT
FROM AFMAST AF, CIMAST CI, CFMAST CF, SYSVAR SY1,
(SELECT STS.AFACCTNO, STS.CLEARDATE, STS.TXDATE,
    SUM(STS.AMT) EXECAMT, SUM(STS.AMT-STS.AAMT-STS.FAMT+STS.PAIDAMT+STS.PAIDFEEAMT) AMT,
    SUM(STS.FAMT) FAMT, SUM(STS.AAMT) AAMT, SUM(STS.PAIDAMT) PAIDAMT, SUM(STS.PAIDFEEAMT) PAIDFEEAMT,
    SUM(CASE WHEN MST.FEEACR<=0 THEN ODT.DEFFEERATE*STS.AMT/100 ELSE MST.FEEACR END) BRKFEEAMT,
    SUM(STS.ARIGHT) RIGHTTAX,
    SUM(round(TO_NUMBER(SY0.VARVALUE)*STS.AMT/100)) INCOMETAXAMT
FROM STSCHD STS, ODMAST MST, SYSVAR SY0, ODTYPE ODT, SBSECURITIES SB
WHERE STS.ORGORDERID=MST.ORDERID AND STS.CODEID=SB.CODEID AND MST.ACTYPE = ODT.ACTYPE
    AND STS.DELTD <> 'Y' AND STS.STATUS='N' AND STS.DUETYPE='RM'
    AND SY0.VARNAME = 'ADVSELLDUTY' AND SY0.GRNAME = 'SYSTEM'

GROUP BY STS.AFACCTNO, STS.CLEARDATE, STS.TXDATE) RF
WHERE RF.AFACCTNO=AF.ACCTNO AND CI.AFACCTNO=AF.ACCTNO
AND AF.CUSTID=CF.CUSTID AND CF.CUSTATCOM='Y'
    AND CI.COREBANK <> 'Y'
    AND SY1.VARNAME='CURRDATE' AND SY1.GRNAME='SYSTEM'
    AND CLEARDATE>=V_IDATE AND  RF.TXDATE <= V_IDATE
    AND CF.CUSTODYCD LIKE V_STRCUSTODYCD
    AND AF.ACCTNO LIKE V_STRCIACCTNO)) ;


--Lay balance
select sum(ci.balance) into V_BALANCE from cfmast cf, afmast af, cimast ci
where cf.custid = af.custid and af.acctno = ci.afacctno
and cf.custodycd like V_STRCUSTODYCD  and af.acctno like V_STRCIACCTNO;
--Lay thong tin So Tien Nop Them
if V_IDATE  = V_CURRDATE then
select nvl((case when V.trfbuyext = 0 then V.ADDVND else V.ADDVNDT2 end ),0)  into V_ADDVND
from  cfmast cf,vw_mr0003 v where cf.custodycd =V_STRCUSTODYCD
and cf.custodycd = v.custodycd (+);
else
V_ADDVND :=-1;
end if;

-- lay  Tai san
if V_IDATE  = V_CURRDATE then
--select SETOTALCALLASS  into V_SETOTALCALLASS from vw_mr0001 where custodycd = V_STRCUSTODYCD;
select sum(nvl(v.navaccountt2,0))  into V_SETOTALCALLASS from v_getsecmarginratio v, cfmast cf, afmast af
where
cf.custid = af.custid
and af.acctno = v.afacctno (+)
and cf.custodycd = V_STRCUSTODYCD
and af.acctno like V_STRCIACCTNO ;
else
V_SETOTALCALLASS:=-1;
end if;

--lay so tien tra cham T2
if V_IDATE  = V_CURRDATE then
select nvl(sum(nvl(sts.amt,0) + (case when od.feeacr = 0 then sts.amt*(od.bratio -100)/100 else  nvl(od.feeacr,0) end ) ),0)  into V_TRFBUYAMT
from cfmast cf, afmast af,odmast od, stschd sts
where
cf.custid = af.custid
and af.acctno = od.afacctno(+)
and af.acctno = sts.afacctno(+)
and od.orderid = sts.orgorderid
and sts.deltd <> 'Y' and sts.duetype = 'SM'
and sts.trfbuydt > fn_get_prevdate(V_IDATE,1) and sts.txdate <= V_IDATE
and sts.trfbuyext * sts.trfbuyrate > 0
and cf.custodycd like V_STRCUSTODYCD
and af.acctno like V_STRCIACCTNO;
else
select nvl(sum(nvl(sts.amt,0) + nvl(od.feeacr,0) ),0)  into V_TRFBUYAMT
from cfmast cf, afmast af,vw_odmast_all od, vw_stschd_all sts
where
cf.custid = af.custid
and af.acctno = od.afacctno(+)
and af.acctno = sts.afacctno(+)
and od.orderid = sts.orgorderid
and sts.deltd <> 'Y' and sts.duetype = 'SM'
and sts.trfbuydt > V_IDATE and sts.txdate <= V_IDATE
and sts.trfbuyext * sts.trfbuyrate > 0
and cf.custodycd like V_STRCUSTODYCD
and af.acctno like V_STRCIACCTNO;
end if;



if V_STRSTATUS ='001' then
    OPEN PV_REFCURSOR
    FOR
select  PV_AFACCTNO AFACCTNO, V_STRFULLNAME FULLNAME, V_STRCUSTODYCD CUSTODYCD,
    V_APMT APMT, V_BALANCE BALANCE, V_DFDEBTAMT DFDEBTAMT, V_ADVANCELINE ADVANCELINE,
    V_PAIDAMT PAIDAMT, V_TRFBUYAMT TRFBUYAMT,V_MARGINAMT MARGINAMT,V_T0AMT T0AMT,V_DUEAMT DUEAMT,
    V_BALDEFOVD BALDEFOVD, V_AAMT AAMT, V_MBLOCK MBLOCK,V_SECUREAMT  SECUREAMT,
    NVL(V_T0_APMT,0) T0_APMT, NVL(V_T1_APMT,0) T1_APMT, NVL(V_T2_APMT,0) T2_APMT,
        LN.ACCTNO  acctno,
        case when ln.ftype ='DF' then 'DF' else
           (case when ls.reftype ='GP' then 'BL' else 'CL' end) end  F_TYPE,
           to_char(ls.rlsdate,'DD/MM/RRRR') rlsdate,
           --ls.rlsdate,
           TO_CHAR(ls.overduedate,'DD/MM/RRRR') overduedate,
           ls.nml+ls.ovd+ls.paid F_GTGN,
           ls.PAID - nvl(LNTR.PRIN_MOVE,0) F_GTTL,
           ls.nml+ls.ovd  -  nvl(LNTR.PRIN_MOVE,0)  F_DNHT,
           ls.intnmlacr+ls.intdue+ls.intovd+ls.intovdprin +
           ls.feeintnmlacr + ls.feeintovdacr + ls.feeintnmlovd + ls.feeintdue -- +  ls.intpaid + ls.feeintpaid
           - nvl(LNTR.PRFEE_MOVE,0) F_LAI_PHI,
           '' F_LOAICB,  case when ln.ftype ='DF' then  to_char(ln.rate2) || ' - ' || to_char(ln.cfrate2)  else
           --bao lanh
           (case when ls.reftype ='GP' then to_char(ln.orate2) || ' - ' || to_char(ln.cfrate2) else
           --margin
           to_char(ls.rate2) || ' - ' || to_char(ln.cfrate2) end) end  F_TLLAI,
           (case when V_IDATE  <> V_CURRDATE then 0
           else   (  case when ln.ftype = 'DF' then 100 else round(sec.rlsmarginrate,2) end ) end) kRate,

           --ban due chua tat toan ODCALLSELLMR
           --(case when V_IDATE  <> V_CURRDATE then 0 else  NVL(V.VNDSELLDF,0) end) VNDSELLDF ,
           (case when V_IDATE  <> V_CURRDATE then -1 else  NVL(V.ODCALLSELLMRATE,0) end) VNDSELLDF ,
           (case when V_IDATE  <> V_CURRDATE then -1 else nvl(v.ODCALLDF,0) end) ODCALLDF,
           I_DATE  IDATE ,I_STATUS  ISTATUS,
           (case when V_IDATE  <> V_CURRDATE then -1 else V_ADDVND end)   ADDVND,
           (case when V_IDATE  <> V_CURRDATE then -1 else V_SETOTALCALLASS end) SETOTALCALLASS,
           I_DUESTS DUESTS

from (select * from lnmast union select * from lnmasthist) ln,
       (select * from lnschd union select * from lnschdhist) ls,
        (   select autoid,sum((case when nml > 0 then 0 else nml end )  +ovd) PRIN_MOVE,
            sum(intnmlacr +intdue+intovd+intovdprin +
            feeintnmlacr+ feeintdue+feeintovd+feeintovdprin) PRFEE_MOVE
            from ( select * from lnschdlog union all select * from lnschdloghist ) lnslog
            where nvl(deltd,'N') <>'Y' and txdate >V_IDATE
            group by autoid) LNTR,
      CFMAST CF, afmast af , v_getgrpdealformular v, v_getsecmarginratio sec
where ln.acctno = ls.acctno
and ls.reftype in ('P','GP')
and ln.rlsdate <= V_IDATE
and ls.rlsdate <=  V_IDATE
and ln.acctno = v.lnacctno(+)
and ls.autoid = LNTR.autoid(+)
and ls.rlsdate between to_date(p_FR_RLSDATE,'DD/MM/RRRR') and to_date(p_TO_RLSDATE,'DD/MM/RRRR')
and ls.overduedate between to_date(p_FR_OVERDUEDATE,'DD/MM/RRRR') and to_date(p_TO_OVERDUEDATE,'DD/MM/RRRR')

--Check trang thai Tat Toan
and ls.nml+ls.ovd - nvl(LNTR.PRIN_MOVE,0) = 0
--Check trang thai den han
and  (case  when  I_DUESTS ='ALL' then 1
            when  I_DUESTS ='001' then (case when V_IDATE < ls.overduedate  then 1 else 0 end)
            when  I_DUESTS ='002' then (case when V_IDATE = ls.overduedate  then 1 else 0 end)
            when  I_DUESTS ='003' then (case when V_IDATE > ls.overduedate  then 1 else 0 end)
            else  0 end) > 0
AND CF.CUSTID = AF.CUSTID
AND LN.trfacctno = AF.ACCTNO
AND CF.CUSTODYCD LIKE V_STRCUSTODYCD
AND AF.ACCTNO LIKE V_STRCIACCTNO
and af.acctno = sec.afacctno
and exists (select gu.grpid from tlgrpusers gu where af.careby = gu.grpid and gu.tlid = v_TLID )
;
 else
    OPEN PV_REFCURSOR
    FOR

select  PV_AFACCTNO AFACCTNO, V_STRFULLNAME FULLNAME, V_STRCUSTODYCD CUSTODYCD,
    V_APMT APMT, V_BALANCE BALANCE, V_DFDEBTAMT DFDEBTAMT, V_ADVANCELINE ADVANCELINE,
    V_PAIDAMT PAIDAMT, V_TRFBUYAMT TRFBUYAMT,V_MARGINAMT MARGINAMT,V_T0AMT T0AMT,V_DUEAMT DUEAMT,
    V_BALDEFOVD BALDEFOVD, V_AAMT AAMT, V_MBLOCK MBLOCK,V_SECUREAMT  SECUREAMT,
    NVL(V_T0_APMT,0) T0_APMT, NVL(V_T1_APMT,0) T1_APMT, NVL(V_T2_APMT,0) T2_APMT,
        LN.ACCTNO   acctno,
        case when ln.ftype ='DF' then 'DF' else
           (case when ls.reftype ='GP' then 'BL' else 'CL' end) end  F_TYPE,
           to_char(ls.rlsdate,'DD/MM/RRRR') rlsdate,
           --ls.rlsdate,
           TO_CHAR(ls.overduedate,'DD/MM/RRRR') overduedate,
            ls.nml+ls.ovd+ls.paid F_GTGN,
           ls.PAID - nvl(LNTR.PRIN_MOVE,0) F_GTTL,
           ls.nml+ls.ovd  -  nvl(LNTR.PRIN_MOVE,0)  F_DNHT,
           ls.intnmlacr+ls.intdue+ls.intovd+ls.intovdprin +
           ls.feeintnmlacr + ls.feeintovdacr + ls.feeintnmlovd + ls.feeintdue -- +  ls.intpaid + ls.feeintpaid
           - nvl(LNTR.PRFEE_MOVE,0) F_LAI_PHI,

           '' F_LOAICB,  case when ln.ftype ='DF' then  to_char(ln.rate2) || ' - ' || to_char(ln.cfrate2)  else
           --bao lanh
           (case when ls.reftype ='GP' then to_char(ln.orate2) || ' - ' || to_char(ln.cfrate2) else
           --margin
           to_char(ls.rate2) || ' - ' || to_char(ln.cfrate2) end) end  F_TLLAI,
           (case when V_IDATE  <> V_CURRDATE then 0 else
           (case when ln.ftype = 'DF' then 100 else round(sec.rlsmarginrate,2) end) end) kRate,


           --ban due chua tat toan ODCALLSELLMR
           --(case when V_IDATE  <> V_CURRDATE then 0 else  NVL(V.VNDSELLDF,0) end) VNDSELLDF ,
           (case when V_IDATE  <> V_CURRDATE then -1 else  NVL(V.ODCALLSELLMRATE,0) end) VNDSELLDF ,
           (case when V_IDATE  <> V_CURRDATE then -1 else nvl(v.ODCALLDF,0) end) ODCALLDF,
           I_DATE  IDATE ,I_STATUS  ISTATUS,
           (case when V_IDATE  <> V_CURRDATE then -1 else V_ADDVND end)   ADDVND,
           (case when V_IDATE  <> V_CURRDATE then -1 else V_SETOTALCALLASS end) SETOTALCALLASS,
           I_DUESTS DUESTS,
           nvl(cfb.shortname,'KBSV') restype, --- NGAN HANG GIAI NGAN
           LS.AUTOID
from (select * from lnmast union select * from lnmasthist) ln,
      (select * from lnschd union select * from lnschdhist) ls,
       (   select autoid,sum((case when nml>0 then 0 else nml end) +ovd) PRIN_MOVE,
            sum(intnmlacr +intdue+intovd+intovdprin +
            feeintnmlacr+ feeintdue+feeintovd+feeintovdprin) PRFEE_MOVE
            from ( select * from lnschdlog union all select * from lnschdloghist ) lnslog
            where nvl(deltd,'N') <>'Y' and txdate > V_IDATE
            group by autoid) LNTR,
      CFMAST CF, afmast af , v_getgrpdealformular v, v_getsecmarginratio sec,cfmast cfb
where ln.acctno = ls.acctno
and ls.reftype in ('P','GP')
and ln.rlsdate <= V_IDATE
and ls.rlsdate <=  V_IDATE
and ln.acctno = v.lnacctno (+)
and ls.autoid = LNTR.autoid(+)
and ln.custbank = cfb.custid(+)
and ls.rlsdate between to_date(p_FR_RLSDATE,'DD/MM/RRRR') and to_date(p_TO_RLSDATE,'DD/MM/RRRR')
and ls.overduedate between to_date(p_FR_OVERDUEDATE,'DD/MM/RRRR') and to_date(p_TO_OVERDUEDATE,'DD/MM/RRRR')

--check trang thai Tat Toan
and decode(V_STRSTATUS,'ALL',1,ls.nml+ls.ovd - nvl(LNTR.PRIN_MOVE,0)) > 0
--Check trang thai den han
and  (case  when  I_DUESTS ='ALL' then 1
            when  I_DUESTS ='001' then (case when V_IDATE < ls.overduedate  then 1 else 0 end)
            when  I_DUESTS ='002' then (case when V_IDATE = ls.overduedate  then 1 else 0 end)
            when  I_DUESTS ='003' then (case when V_IDATE > ls.overduedate  then 1 else 0 end)
            else  0 end) > 0
--CHEKC NGUON GIAI NGAN
and case when p_RESTYPE = 'ALL' then 1
                    when ln.rrtype = 'C' and p_RESTYPE = 'KBSV' then 1
                    when ln.rrtype = 'B' and p_RESTYPE = nvl(cfb.shortname,'KBSV') then 1
                    else 0 end <> 0
AND CF.CUSTID = AF.CUSTID
AND LN.trfacctno = AF.ACCTNO
AND CF.CUSTODYCD LIKE V_STRCUSTODYCD
AND AF.ACCTNO LIKE V_STRCIACCTNO
and af.acctno = sec.afacctno

and exists (select gu.grpid from tlgrpusers gu where af.careby = gu.grpid and gu.tlid = v_TLID )

;
 end if;



EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/
