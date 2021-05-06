CREATE OR REPLACE PROCEDURE ci1018_BK1404(
   PV_REFCURSOR     IN OUT   PKG_REPORT.REF_CURSOR,
   OPT              IN       VARCHAR2,
   BRID             IN       VARCHAR2,
   TYPEDATE         IN       VARCHAR2,
   F_DATE           IN       VARCHAR2,
   T_DATE           IN       VARCHAR2,
   TLTXCD           IN       VARCHAR2,
   MAKER            IN       VARCHAR2,
   CHECKER          IN       VARCHAR2,
   corebank         IN       VARCHAR2,
   PV_CUSTODYCD     IN       VARCHAR2,
   PV_AFACCTNO      IN       VARCHAR2,
   TYPEBRID         IN       VARCHAR2
        )
   IS
--
-- To modify this template, edit file PROC.TXT in TEMPLATE
-- directory of SQL Navigator
-- BAO CAO DANH SACH GIAO DICH LUU KY
-- Purpose: Briefly explain the functionality of the procedure
-- DANH SACH GIAO DICH LUU KY
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- NAMNT   11-APR-2012  MODIFIED
-- ---------   ------  -------------------------------------------

    V_STROPTION         VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRTLTXCD         VARCHAR (900);
    V_STRSYMBOL         VARCHAR (20);
    V_STRTYPEDATE       VARCHAR(5);
    V_STRCHECKER        VARCHAR(20);
    V_STRMAKER          VARCHAR(20);
    V_STRCOREBANK       VARCHAR(20);
    V_STROPT            VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID           VARCHAR2 (100);                   -- USED WHEN V_NUMOPTION > 0
    V_INBRID            VARCHAR2 (5);
    v_strIBRID          VARCHAR2 (4);
    vn_BRID             varchar2(50);
    V_STRPV_CUSTODYCD   varchar2(50);
    V_STRPV_AFACCTNO    varchar2(50);
   -- Declare program variables as shown above
BEGIN
    -- GET REPORT'S PARAMETERS


 V_STROPT := upper(OPT);
    V_INBRID := BRID;
    if(V_STROPT = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPT = 'B') then
            --select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
            V_STRBRID := substr(BRID,1,2) || '__' ;
        else
            V_STRBRID := BRID;
        end if;
    end if;

  V_STRTYPEDATE := TYPEDATE;

   IF(TLTXCD <> 'ALL')
   THEN
        V_STRTLTXCD := TLTXCD||'%';
      ELSE
        V_STRTLTXCD := '%%';
   END IF;

   IF(CHECKER <> 'ALL')
   THEN
        V_STRCHECKER := CHECKER;
   ELSE
        V_STRCHECKER := '%%';
   END IF;

   IF(MAKER <> 'ALL')
   THEN
        V_STRMAKER  := MAKER;
   ELSE
        V_STRMAKER  := '%%';
   END IF;

   IF(COREBANK <> 'ALL')
   THEN
        V_STRCOREBANK  := COREBANK;
   ELSE
        V_STRCOREBANK  := '%%';
   END IF;

    IF(PV_CUSTODYCD <> 'ALL')
   THEN
        V_STRPV_CUSTODYCD  := PV_CUSTODYCD;
   ELSE
        V_STRPV_CUSTODYCD  := '%%';
   END IF;

    IF(PV_AFACCTNO <> 'ALL')
   THEN
        V_STRPV_AFACCTNO  := PV_AFACCTNO;
   ELSE
        V_STRPV_AFACCTNO := '%%';
   END IF;

IF   TYPEBRID ='002' THEN

 OPEN PV_REFCURSOR
  FOR

  select A.*,
  case when txtype <> 'D' then amt else 0 end Credit,
  case when txtype <> 'C' then amt else 0 end Debit from (
select tl.tltxcd,tltx.txdesc ,tl.txnum,tl.busdate ,tl.txdate,cf.custodycd,af.acctno, cfc.custodycd custodycdc,afc.acctno acctnoc,tl.msgamt amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(AF.brid,'') brid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID,
''bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname,nvl(ci.trdesc,ci.txdesc) trdesc, ci.txtype
from vw_tllog_all TL ,vw_citran_gen ci,afmast af,cfmast cf, afmast afc,cfmast cfc ,tltx  , tlprofiles mk,tlprofiles ck
where tl.txnum =ci.txnum and tl.txdate =ci.txdate and ci.acctno= af.acctno and cf.custid =af.custid
and ci.ref =afc.acctno and afc.custid =cfc.custid
and tltx.tltxcd = tl.tltxcd
and  tl.tlid = mk.tlid(+)
and  tl.OFFID =ck.tlid(+)
and tl.tltxcd in ('1120','1130','1134','1188') and ci.field ='BALANCE'
and ci.txcd in ('0011','0012')
and /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate>=to_date(F_DATE,'DD/MM/YYYY')
AND /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate<=to_date(T_DATE,'DD/MM/YYYY')
AND TL.TLTXCD LIKE V_STRTLTXCD
and  nvl(AF.brid,V_STRBRID) like V_STRBRID
AND NVL( TL.TLID,'-') LIKE V_STRMAKER
AND NVL( TL.OFFID,'-') LIKE V_STRCHECKER
AND AF.COREBANK LIKE V_STRCOREBANK
AND CF.custodycd LIKE V_STRPV_CUSTODYCD
AND AF.acctno LIKE V_STRPV_AFACCTNO
union ALL
SELECT case when  tl.tltxcd in ('3350','3354') then '3342'
            when tl.tltxcd in ('1101', '1120','1130','1111','1185','1188')  and ci.txcd = '0028' then ' '
            else  tl.tltxcd end  tltxcd ,
        case when tl.tltxcd in ('1101','1120','1130','1111','1185','1188') and ci.txcd = '0028' then  utf8nums.c_const_RPT_CI1018_Phi_DESC
            else  tltx.txdesc end txdesc ,tl.txnum,tl.busdate ,tl.txdate,
cf.custodycd,af.acctno, '' custodycdc,'' acctnoc
, case when tl.tltxcd = '8894' and af.corebank = 'Y' then tl.msgamt
       else  ci.namt end /*tl.msgamt*/ amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,
nvl(AF.brid,'') brid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID,
''bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname ,
case when tl.tltxcd in ('1101','1120','1130','1111','1185','1188') and ci.txcd = '0028' then tltx.txdesc || ' - ' || tl.tltxcd
     when tl.tltxcd in ('2200','8894','3382','3383','0088','1113') and ci.txcd = '0011' then ci.trdesc else tl.txdesc end trdesc, ci.txtype
FROM vw_tllog_all TL,afmast af,cfmast cf ,tltx, tlprofiles mk,tlprofiles ck, vw_citran_gen ci
where/* substr(tl.msgacct,0,10)*/ ci.acctno =af.acctno and af.custid = cf.custid
and tltx.tltxcd = tl.tltxcd
and  tl.tlid = mk.tlid(+)
and  tl.OFFID =ck.tlid(+)
and tl.tltxcd in ('1140','1100','1107','1101','1133'
,'1104','1108','1111','1114','1104','1112','1145','1144'
,'1123','1124','1126','1127','1162','1180','1182','1184','1185','1189','6613','1105','1198','1199','8866'
,'8856','0066','8889','8894','8851','5541','3386'
,'1113', '2200','3382','3383','0088',
'1101','1120','1130','1111','1185','1188','5569') --Chaunh bo 3384, 1188
and ci.txdate = tl.txdate and ci.txnum = tl.txnum
and  ci.field in ('BAMT','BALANCE','MBLOCK','EMKAMT')
and case when tl.tltxcd in ('1113', '2200','3382','3383','0088') and ci.txcd <> '0011' then 0
     when tl.tltxcd in (/*'1101',*/'1120','1130',/*'1111',*/'1185','1188') and ci.txcd <> '0028' then 0 --14/10 bo 1101, 1111
    else 1 end = 1
and /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate>=to_date(F_DATE,'DD/MM/YYYY')
AND /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate<=to_date(T_DATE,'DD/MM/YYYY')
AND  case when  tl.tltxcd in ('3350','3354') then '3342' else  tl.tltxcd end  LIKE V_STRTLTXCD
and  nvl(AF.brid,V_STRBRID) like V_STRBRID
AND NVL( TL.TLID,'-') LIKE V_STRMAKER
AND NVL( TL.OFFID,'-') LIKE V_STRCHECKER
AND AF.COREBANK LIKE V_STRCOREBANK
AND CF.custodycd LIKE V_STRPV_CUSTODYCD
AND AF.acctno LIKE V_STRPV_AFACCTNO
and tl.msgamt >0

union ALL
SELECT   tl.tltxcd||'T'|| sts.trfbuyext  tltxcd ,tltx.txdesc ,tl.txnum,tl.busdate ,tl.txdate,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc,tl.msgamt amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(AF.brid,'') brid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID,
''bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname,nvl(ci.trdesc,ci.txdesc) trdesc, ci.txtype
FROM vw_tllog_all TL,afmast af,cfmast cf ,tltx, tlprofiles mk,tlprofiles ck,vw_citran_gen CI, vw_stschd_all sts
where tl.msgacct=af.acctno and af.custid = cf.custid
and tltx.tltxcd = tl.tltxcd
and  tl.tlid = mk.tlid(+)
and  tl.OFFID =ck.tlid(+)
AND TL.TXDATE = CI.TXDATE
AND TL.TXNUM = CI.TXNUM
AND CI.field ='BALANCE'
and tl.tltxcd ='8855'
and ci.ref = sts.orgorderid
and sts.duetype ='SM'
and /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate>=to_date(F_DATE,'DD/MM/YYYY')
AND /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate<=to_date(T_DATE,'DD/MM/YYYY')
AND  tl.tltxcd||'T'|| sts.trfbuyext  LIKE V_STRTLTXCD
and  nvl(AF.brid,V_STRBRID) like V_STRBRID
AND NVL( TL.TLID,'-') LIKE V_STRMAKER
AND NVL( TL.OFFID,'-') LIKE V_STRCHECKER
AND AF.COREBANK LIKE V_STRCOREBANK
AND CF.custodycd LIKE V_STRPV_CUSTODYCD
AND AF.acctno LIKE V_STRPV_AFACCTNO
union ALL
SELECT case when  tl.tltxcd in ('3350','3354') and  CI.TXCD ='0012'  then '3342'
            when  tl.tltxcd in ('3350','3354') and  CI.TXCD ='0011'  then '3343'
            else  tl.tltxcd end  tltxcd  ,tltx.txdesc ,tl.txnum,tl.busdate ,tl.txdate
            ,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc,ci.namt amt,nvl(mk.tlname,'') mk
            ,nvl(ck.tlname,'')  ck,nvl(AF.brid,'') brid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID,
''bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname,ci.trdesc, ci.txtype
FROM vw_tllog_all TL,afmast af,cfmast cf ,tltx, tlprofiles mk,tlprofiles ck,vw_citran_gen CI
where tl.msgacct=af.acctno and af.custid = cf.custid
and tltx.tltxcd = tl.tltxcd
and  tl.tlid = mk.tlid(+)
and  tl.OFFID =ck.tlid(+)
AND TL.TXDATE = CI.TXDATE
AND TL.TXNUM = CI.TXNUM
AND CI.TXCD in('0012','0011')
and tl.tltxcd IN('3350','3354')
and /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate>=to_date(F_DATE,'DD/MM/YYYY')
AND /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate<=to_date(T_DATE,'DD/MM/YYYY')
AND case when  tl.tltxcd in ('3350','3354') then '3342' else  tl.tltxcd end  LIKE V_STRTLTXCD
and  nvl(AF.brid,V_STRBRID) like V_STRBRID
AND NVL( TL.TLID,'-') LIKE V_STRMAKER
AND NVL( TL.OFFID,'-') LIKE V_STRCHECKER
AND AF.COREBANK LIKE V_STRCOREBANK
AND CF.custodycd LIKE V_STRPV_CUSTODYCD
AND AF.acctno LIKE V_STRPV_AFACCTNO
UNION ALL
SELECT  tl.tltxcd ,tltx.txdesc ,tl.txnum,tl.busdate ,tl.txdate,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc,CI.NAMT amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(AF.brid,'') brid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID,
''bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname,nvl(ci.trdesc,ci.txdesc) trdesc, ci.txtype
FROM vw_tllog_all TL,afmast af,cfmast cf ,tltx, tlprofiles mk,tlprofiles ck,vw_citran_gen CI
where tl.msgacct=af.acctno and af.custid = cf.custid
and tltx.tltxcd = tl.tltxcd
and  tl.tlid = mk.tlid(+)
and  tl.OFFID =ck.tlid(+)
AND TL.TXDATE = CI.TXDATE
AND TL.TXNUM = CI.TXNUM
AND CI.field ='BALANCE'
and tl.tltxcd in('1153','8865','1139')
and /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate>=to_date(F_DATE,'DD/MM/YYYY')
AND /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate<=to_date(T_DATE,'DD/MM/YYYY')
AND TL.TLTXCD LIKE V_STRTLTXCD
and  nvl(AF.brid,V_STRBRID) like V_STRBRID
AND NVL( TL.TLID,'-') LIKE V_STRMAKER
AND NVL( TL.OFFID,'-') LIKE V_STRCHECKER
AND AF.COREBANK LIKE V_STRCOREBANK
AND CF.custodycd LIKE V_STRPV_CUSTODYCD
AND AF.acctno LIKE V_STRPV_AFACCTNO
--1178
union ALL
SELECT tl.tltxcd,tltx.txdesc ,tl.txnum,tl.busdate ,tl.txdate,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc,ads.amt amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(AF.brid,'') brid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID,
'' bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname, tl.txdesc trdesc, ' ' txtype
FROM vw_tllog_all TL,adschd ads ,afmast af,cfmast cf,tltx, tlprofiles mk,tlprofiles ck
where tl.msgamt =ads.autoid
and TL.msgacct = af.acctno and af.custid = cf.custid
and tltx.tltxcd = tl.tltxcd
and  tl.tlid = mk.tlid(+)
and  tl.OFFID =ck.tlid(+)
and tl.tltxcd in ('1178')
and /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate>=to_date(F_DATE,'DD/MM/YYYY')
AND /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate<=to_date(T_DATE,'DD/MM/YYYY')
AND TL.TLTXCD LIKE V_STRTLTXCD
and  nvl(AF.brid,V_STRBRID) like V_STRBRID
AND NVL( TL.TLID,'-') LIKE V_STRMAKER
AND NVL( TL.OFFID,'-') LIKE V_STRCHECKER
AND AF.COREBANK LIKE V_STRCOREBANK
AND CF.custodycd LIKE V_STRPV_CUSTODYCD
AND AF.acctno LIKE V_STRPV_AFACCTNO
--nhom bank
--'1131','1132','1136','1141'
union ALL

SELECT   tl.tltxcd ,tltx.txdesc ,tl.txnum,tl.busdate ,tl.txdate,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc,tl.msgamt amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(AF.brid,'') brid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID
,nvl(bank.fullname,' ') bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname, tl.txdesc trdesc,
case when tl.tltxcd in ('1132','1136') then 'D' else 'C' end txtype
FROM vw_tllog_all TL,afmast af,cfmast cf ,tltx, tlprofiles mk,tlprofiles ck,vw_tllogfld_all tlfld,banknostro bank
where tl.msgacct=af.acctno and af.custid = cf.custid
and tltx.tltxcd = tl.tltxcd
and  tl.tlid = mk.tlid(+)
and  tl.OFFID =ck.tlid(+)
and tlfld.txdate = tl.txdate
and tlfld.txnum = tl.txnum
and tlfld.fldcd='02'
and tlfld.cvalue=bank.shortname(+)
and tl.tltxcd in ('1131','1132','1136','1141')
and /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate>=to_date(F_DATE,'DD/MM/YYYY')
AND /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate<=to_date(T_DATE,'DD/MM/YYYY')
AND TL.TLTXCD LIKE V_STRTLTXCD
and  nvl(AF.brid,V_STRBRID) like V_STRBRID
AND NVL( TL.TLID,'-') LIKE V_STRMAKER
AND NVL( TL.OFFID,'-') LIKE V_STRCHECKER
AND AF.COREBANK LIKE V_STRCOREBANK
AND CF.custodycd LIKE V_STRPV_CUSTODYCD
AND AF.acctno LIKE V_STRPV_AFACCTNO
-- dfgroup
union ALL
SELECT tl.tltxcd,tltx.txdesc ,tl.txnum,tl.busdate ,tl.txdate,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc,CI.NAMT amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(AF.brid,'') brid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID,
nvl(CFB.shortname,'') bankid ,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname, CI.trdesc trdesc, ci.txtype
FROM vw_tllog_all TL,dfgroup dfg ,afmast af,cfmast cf,tltx, tlprofiles mk,tlprofiles ck,
 lnmast ln,lntype , CFMAST CFB,vw_citran_gen CI
where tl.msgacct= dfg.groupid and dfg.afacctno = af.acctno and af.custid = cf.custid
and tltx.tltxcd = tl.tltxcd
and dfg.lnacctno =ln.acctno
and ln.actype =lntype.actype
AND LN.actype= LNTYPE.actype
AND LN.custbank = CFB.custid(+)
and tl.tlid = mk.tlid(+)
and tl.OFFID =ck.tlid(+)
AND CI.ref =LN.acctno
AND CI.txnum = TL.txnum
AND CI.txdate =TL.txdate
and tl.tltxcd in ('2646','2648','2665','2636')
AND CI.field ='BALANCE'
and /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate>=to_date(F_DATE,'DD/MM/YYYY')
AND /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate<=to_date(T_DATE,'DD/MM/YYYY')
AND TL.TLTXCD LIKE V_STRTLTXCD
and  nvl(AF.brid,V_STRBRID) like V_STRBRID
AND NVL( TL.TLID,'-') LIKE V_STRMAKER
AND NVL( TL.OFFID,'-') LIKE V_STRCHECKER
AND AF.COREBANK LIKE V_STRCOREBANK
AND CF.custodycd LIKE V_STRPV_CUSTODYCD
AND AF.acctno LIKE V_STRPV_AFACCTNO
union ALL
SELECT   tl.tltxcd ,tltx.txdesc ,tl.txnum,tl.busdate ,tl.txdate,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc,ci.NAMT amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(AF.brid,'') brid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID,
nvl(CFB.shortname,'') bankid ,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname,ci.trdesc, ci.txtype
FROM vw_tllog_all TL,afmast af,cfmast cf ,tltx, tlprofiles mk,tlprofiles ck,
 vw_citran_gen ci,
 lnmast ln,lntype , CFMAST CFB
where tl.msgacct=af.acctno and af.custid = cf.custid
and tltx.tltxcd = tl.tltxcd
and  tl.tlid = mk.tlid(+)
and  tl.OFFID =ck.tlid(+)
and tl.txnum= ci.txnum
and tl.txdate = ci.txdate
and ci.ref = ln.acctno and ci.field ='BALANCE'
AND LN.actype= LNTYPE.actype
AND LN.custbank = CFB.custid(+)
and tl.tltxcd in ('5540','5566','5567')
and /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate>=to_date(F_DATE,'DD/MM/YYYY')
AND /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate<=to_date(T_DATE,'DD/MM/YYYY')
AND TL.TLTXCD LIKE V_STRTLTXCD
and  nvl(AF.brid,V_STRBRID) like V_STRBRID
AND NVL( TL.TLID,'-') LIKE V_STRMAKER
AND NVL( TL.OFFID,'-') LIKE V_STRCHECKER
AND AF.COREBANK LIKE V_STRCOREBANK
AND CF.custodycd LIKE V_STRPV_CUSTODYCD
AND AF.acctno LIKE V_STRPV_AFACCTNO
union ALL
SELECT   tl.tltxcd ,tltx.txdesc ,tl.txnum,tl.busdate ,tl.txdate,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc,tl.msgamt amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(AF.brid,'') brid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID,
nvl(CFB.shortname,'') bankid ,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname, tl.txdesc trdesc, 'C' txtype
FROM vw_tllog_all TL,afmast af,cfmast cf ,tltx, tlprofiles mk,tlprofiles ck,  vw_tllogfld_all tlfld, lnmast ln,lntype , CFMAST CFB
where tl.msgacct=af.acctno and af.custid = cf.custid
and tltx.tltxcd = tl.tltxcd
and  tl.tlid = mk.tlid(+)
and  tl.OFFID =ck.tlid(+)
and tl.txnum= tlfld.txnum
and tl.txdate = tlfld.txdate
and tlfld.fldcd ='21'
and tlfld.cvalue = ln.acctno(+)
AND LN.actype= LNTYPE.actype
AND LN.custbank = CFB.custid(+)
AND LN.actype= LNTYPE.actype
AND LN.custbank = CFB.custid(+)
and tl.tltxcd ='2674'
and /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate>=to_date(F_DATE,'DD/MM/YYYY')
AND /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate<=to_date(T_DATE,'DD/MM/YYYY')
AND TL.TLTXCD LIKE V_STRTLTXCD
and  nvl(AF.brid,V_STRBRID) like V_STRBRID
AND NVL( TL.TLID,'-') LIKE V_STRMAKER
AND NVL( TL.OFFID,'-') LIKE V_STRCHECKER
AND AF.COREBANK LIKE V_STRCOREBANK
AND CF.custodycd LIKE V_STRPV_CUSTODYCD
AND AF.acctno LIKE V_STRPV_AFACCTNO
union ALL
SELECT  tl.tltxcd   tltxcd ,tltx.txdesc ,tl.txnum,tl.busdate ,tl.txdate,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc,ci.namt amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(AF.brid,'') brid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID,
''bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname,CI.trdesc, ci.txtype
FROM vw_tllog_all TL,afmast af,cfmast cf ,tltx, tlprofiles mk,tlprofiles ck,
 vw_citran_gen   ci
where ci.acctno=af.acctno and af.custid = cf.custid
and tltx.tltxcd = tl.tltxcd
and  tl.tlid = mk.tlid(+)
and  tl.OFFID =ck.tlid(+)
and tl.txdate = ci.txdate
and tl.txnum = ci.txnum
and tl.tltxcd  IN ('0088','1670','1610','1600','1620','1137','1138','3384','3394') --chaunh add 3384, 3394
and ci.field ='BALANCE'
and /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate>=to_date(F_DATE,'DD/MM/YYYY')
AND /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate<=to_date(T_DATE,'DD/MM/YYYY')
AND TL.TLTXCD LIKE V_STRTLTXCD
and  nvl(AF.brid,V_STRBRID) like V_STRBRID
AND NVL( TL.TLID,'-') LIKE V_STRMAKER
AND NVL( TL.OFFID,'-') LIKE V_STRCHECKER
AND AF.COREBANK LIKE V_STRCOREBANK
AND CF.custodycd LIKE V_STRPV_CUSTODYCD
AND AF.acctno LIKE V_STRPV_AFACCTNO
union all
--begin chaunh -- voi giao dich corebank
----- 8894
select tl.tltxcd, tl.txdesc, tl.txnum, tl.busdate, tl.txdate, cf.custodycd, af.acctno
    ,' ' custodycdc,'' acctnoc
    , tl.msgamt amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(AF.brid,'') brid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID
    ,' ' bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname, tl.txdesc trdesc
    ,  'C' txtype --tong tien ban
from vw_tllog_all tl, cfmast cf, semast se, afmast af, tlprofiles mk, tlprofiles ck
where  tl.tltxcd = '8894' and af.corebank = 'Y'
    and cf.custid = af.custid and tl.msgacct = se.acctno and se.afacctno = af.acctno
    and tl.tlid = mk.tlid(+) and tl.chkid = ck.tlid(+)
    and /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate>=to_date(F_DATE,'DD/MM/YYYY')
    AND /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate<=to_date(T_DATE,'DD/MM/YYYY')
    AND TL.TLTXCD LIKE V_STRTLTXCD
    and  nvl(AF.brid,V_STRBRID) like V_STRBRID
    AND NVL( TL.TLID,'-') LIKE V_STRMAKER
    AND NVL( TL.OFFID,'-') LIKE V_STRCHECKER
    AND AF.COREBANK LIKE V_STRCOREBANK
    AND CF.custodycd LIKE V_STRPV_CUSTODYCD
    AND AF.acctno LIKE V_STRPV_AFACCTNO
union all
select tl.tltxcd,case when  crb.trfcode = 'TRFODSRTL' then 'Phi ' || crb.notes else crb.notes end txdesc, tl.txnum, tl.busdate, tl.txdate, cf.custodycd, af.acctno
    ,' ' custodycdc,'' acctnoc
    ,case when crb.trfcode = 'TRFODSRTL' then  tl.msgamt - crb.txamt --phi ban
          when crb.trfcode = 'TRFODSRTDF' then crb.txamt end  amt --thue ban
    ,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(AF.brid,'') brid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID
    ,' ' bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname, tl.txdesc trdesc
    ,  'D'  txtype  --thue ban
from vw_tllog_all tl, (select * from CRBTXREQ union all select * from crbtxreqhist) crb, cfmast cf, semast se, afmast af, tlprofiles mk, tlprofiles ck
where tl.txnum = crb.refcode and tl.txdate = crb.txdate and tltxcd = '8894'
    and cf.custid = af.custid and tl.msgacct = se.acctno and se.afacctno = af.acctno
    and tl.tlid = mk.tlid(+) and tl.chkid = ck.tlid(+)
    and /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate>=to_date(F_DATE,'DD/MM/YYYY')
    AND /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate<=to_date(T_DATE,'DD/MM/YYYY')
    AND TL.TLTXCD LIKE V_STRTLTXCD
    and  nvl(AF.brid,V_STRBRID) like V_STRBRID
    AND NVL( TL.TLID,'-') LIKE V_STRMAKER
    AND NVL( TL.OFFID,'-') LIKE V_STRCHECKER
    AND AF.COREBANK LIKE V_STRCOREBANK
    AND CF.custodycd LIKE V_STRPV_CUSTODYCD
    AND AF.acctno LIKE V_STRPV_AFACCTNO
union all
--3386
select tl.tltxcd, crb.notes txdesc, tl.txnum, tl.busdate, tl.txdate, cf.custodycd, af.acctno
    ,' ' custodycdc,'' acctnoc,crb.txamt amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(AF.brid,'') brid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID
    ,' ' bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname, tl.txdesc trdesc
    , case when crb.trfcode='TRFCAUNREG' then 'D' end txtype
from vw_tllog_all tl, (select * from CRBTXREQ union all select * from crbtxreqhist) crb, cfmast cf, afmast af, tlprofiles mk, tlprofiles ck
where tl.txnum = crb.refcode and tl.txdate = crb.txdate and tl.tltxcd = '3386'
    and cf.custid = af.custid and tl.msgacct = af.acctno
    and tl.tlid = mk.tlid(+) and tl.chkid = ck.tlid(+)
    and /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate>=to_date(F_DATE,'DD/MM/YYYY')
    AND /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate<=to_date(T_DATE,'DD/MM/YYYY')
    AND TL.TLTXCD LIKE V_STRTLTXCD
    and  nvl(AF.brid,V_STRBRID) like V_STRBRID
    AND NVL( TL.TLID,'-') LIKE V_STRMAKER
    AND NVL( TL.OFFID,'-') LIKE V_STRCHECKER
    AND AF.COREBANK LIKE V_STRCOREBANK
    AND CF.custodycd LIKE V_STRPV_CUSTODYCD
    AND AF.acctno LIKE V_STRPV_AFACCTNO
union all
--3350,3354
SELECT case when  tl.tltxcd in ('3350','3354') and  ci.field in ( 'CRAMT','RECEIVING')  then '3342' --cong
            when  tl.tltxcd in ('3350','3354') and  CI.field = 'DRAMT'  then '3343' --tru
            else  tl.tltxcd end  tltxcd  ,tltx.txdesc ,tl.txnum,tl.busdate ,tl.txdate
            ,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc
            ,case when tl.tltxcd = '3354' then  tl.msgamt else ci.namt end amt
            ,nvl(mk.tlname,'') mk
            ,nvl(ck.tlname,'')  ck,nvl(AF.brid,'') brid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID
            ,''bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname,ci.trdesc
            , case when ci.field = 'CRAMT' and tl.tltxcd = '3350' then 'C'
                   when ci.field = 'RECEIVING' and tl.tltxcd = '3354' then 'C'
                   when ci.field = 'DRAMT' and tl.tltxcd = '3350' then 'D'
                   end txtype
FROM vw_tllog_all TL,afmast af,cfmast cf ,tltx, tlprofiles mk,tlprofiles ck,vw_citran_gen CI
where tl.msgacct=af.acctno and af.custid = cf.custid
and tltx.tltxcd = tl.tltxcd and af.corebank = 'Y'
and  tl.tlid = mk.tlid(+)
and  tl.OFFID =ck.tlid(+)
AND TL.TXDATE = CI.TXDATE
AND TL.TXNUM = CI.TXNUM
AND case when tl.tltxcd = '3350' and CI.field in('CRAMT','DRAMT') then 1
         when tl.tltxcd = '3354' and ci.field = 'RECEIVING' then 1
         else 0 end = 1
and tl.tltxcd IN('3350','3354')
and /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate>=to_date(F_DATE,'DD/MM/YYYY')
AND /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate<=to_date(T_DATE,'DD/MM/YYYY')
AND case when  tl.tltxcd in ('3350','3354') then '3342' else  tl.tltxcd end  LIKE V_STRTLTXCD
and  nvl(AF.brid,V_STRBRID) like V_STRBRID
AND NVL( TL.TLID,'-') LIKE V_STRMAKER
AND NVL( TL.OFFID,'-') LIKE V_STRCHECKER
AND AF.COREBANK LIKE V_STRCOREBANK
AND CF.custodycd LIKE V_STRPV_CUSTODYCD
AND AF.acctno LIKE V_STRPV_AFACCTNO
union all
--8866,8856,0066
SELECT tl.tltxcd  ,tl.txdesc ,tl.txnum,tl.busdate ,tl.txdate
            ,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc
            , tl.msgamt amt
            ,nvl(mk.tlname,'') mk
            ,nvl(ck.tlname,'')  ck,nvl(AF.brid,'') brid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID
            ,''bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname,tl.txdesc
            , case when tl.tltxcd = '8866' then 'C'
                   when  tl.tltxcd in ('8856','0066') then 'D'
                   end txtype
FROM vw_tllog_all TL,afmast af,cfmast cf ,tltx, tlprofiles mk,tlprofiles ck
where tl.msgacct=af.acctno and af.custid = cf.custid
and tltx.tltxcd = tl.tltxcd and af.corebank = 'Y'
and  tl.tlid = mk.tlid(+)
and  tl.OFFID =ck.tlid(+)
and tl.tltxcd IN('8866','8856','0066')
and /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate>=to_date(F_DATE,'DD/MM/YYYY')
AND /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate<=to_date(T_DATE,'DD/MM/YYYY')
AND case when  tl.tltxcd in ('3350','3354') then '3342' else  tl.tltxcd end  LIKE V_STRTLTXCD
and  nvl(AF.brid,V_STRBRID) like V_STRBRID
AND NVL( TL.TLID,'-') LIKE V_STRMAKER
AND NVL( TL.OFFID,'-') LIKE V_STRCHECKER
AND AF.COREBANK LIKE V_STRCOREBANK
AND CF.custodycd LIKE V_STRPV_CUSTODYCD
AND AF.acctno LIKE V_STRPV_AFACCTNO

--end chaunh
)A
where substr(a.custodycd,4,1) <> 'P'
ORDER BY A.TLTXCD ,a.busdate,A.TXNUM
;

ELSE

 OPEN PV_REFCURSOR
FOR
 select A.*,
  case when txtype <> 'D' then amt else 0 end Credit,
  case when txtype <> 'C' then amt else 0 end Debit from (
select tl.tltxcd,tltx.txdesc ,tl.txnum,tl.busdate ,tl.txdate,cf.custodycd,af.acctno, cfc.custodycd custodycdc,afc.acctno acctnoc,tl.msgamt amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(tl.brid,'') brid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID,
''bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname,nvl(ci.trdesc,ci.txdesc) trdesc, ci.txtype
from vw_tllog_all TL ,vw_citran_gen ci,afmast af,cfmast cf, afmast afc,cfmast cfc ,tltx  , tlprofiles mk,tlprofiles ck
where tl.txnum =ci.txnum and tl.txdate =ci.txdate and ci.acctno= af.acctno and cf.custid =af.custid
and ci.ref =afc.acctno and afc.custid =cfc.custid
and tltx.tltxcd = tl.tltxcd
and  tl.tlid = mk.tlid(+)
and  tl.OFFID =ck.tlid(+)
and tl.tltxcd in ('1120','1130','1134','1188') and ci.field ='BALANCE'
and ci.txcd in ('0011','0012')
and /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate>=to_date(F_DATE,'DD/MM/YYYY')
AND /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate<=to_date(T_DATE,'DD/MM/YYYY')
AND TL.TLTXCD LIKE V_STRTLTXCD
and  nvl(tl.brid,V_STRBRID) like V_STRBRID
AND NVL( TL.TLID,'-') LIKE V_STRMAKER
AND NVL( TL.OFFID,'-') LIKE V_STRCHECKER
AND AF.COREBANK LIKE V_STRCOREBANK
AND CF.custodycd LIKE V_STRPV_CUSTODYCD
AND AF.acctno LIKE V_STRPV_AFACCTNO

union ALL
SELECT case when  tl.tltxcd in ('3350','3354') then '3342'
            when tl.tltxcd in ('1101', '1120','1130','1111','1185','1188')  and ci.txcd = '0028' then ' '
            else  tl.tltxcd end  tltxcd ,
        case when tl.tltxcd in ('1101','1120','1130','1111','1185','1188') and ci.txcd = '0028' then  utf8nums.c_const_RPT_CI1018_Phi_DESC
            else  tl.txdesc/*tltx.txdesc*/ end txdesc ,tl.txnum,tl.busdate ,tl.txdate,cf.custodycd,af.acctno, '' custodycdc,
            '' acctnoc
        ,case when tl.tltxcd = '8894' and af.corebank = 'Y' then tl.msgamt else ci.namt end /*tl.msgamt*/ amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(tl.brid,'') brid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID,
''bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname ,
case when tl.tltxcd in ('1101','1120','1130','1111','1185','1188') and ci.txcd = '0028' then tl.txdesc/*tltx.txdesc*/ || ' - ' || tl.tltxcd
     when tl.tltxcd in ('2200','8894','3382','3383','0088','1113') and ci.txcd = '0011' then ci.trdesc else tl.txdesc end trdesc, ci.txtype
FROM vw_tllog_all TL,afmast af,cfmast cf ,--tltx,
tlprofiles mk,tlprofiles ck, vw_citran_gen ci
where /*substr(tl.msgacct,0,10)*/ci.acctno=af.acctno and af.custid = cf.custid
--and tltx.tltxcd = tl.tltxcd
and  tl.tlid = mk.tlid(+)
and  tl.OFFID =ck.tlid(+)
and tl.tltxcd in ('1140','1100','1107','1101','1133'
,'1104','1108','1111','1114','1104','1112','1145','1144'
,'1123','1124','1126','1127','1162','1180','1182','1184','1185','1189','6613','1105','1198','1199','8866'
,'8856','0066','8889','8894','8851','5541','3386'
,'1113', '2200','3382','3383','0088',
'1101','1120','1130','1111','1185','1188','5569') --Chaunh bo 3384,1188
and ci.txdate = tl.txdate and ci.txnum = tl.txnum
and  ci.field in ('BAMT','BALANCE','MBLOCK','EMKAMT')
and case when tl.tltxcd in ('1113', '2200','3382','3383','0088') and ci.txcd <> '0011' then 0
     when tl.tltxcd in (/*'1101',*/'1120','1130'/*,'1111'*/,'1185','1188') and ci.txcd <> '0028' then 0 --14/10 bo 1101, 1111
    else 1 end = 1
and /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate>=to_date(F_DATE,'DD/MM/YYYY')
AND /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate<=to_date(T_DATE,'DD/MM/YYYY')
AND TL.TLTXCD LIKE V_STRTLTXCD
and  nvl(tl.brid,V_STRBRID) like V_STRBRID
AND NVL( TL.TLID,'-') LIKE V_STRMAKER
AND NVL( TL.OFFID,'-') LIKE V_STRCHECKER
AND AF.COREBANK LIKE V_STRCOREBANK
AND CF.custodycd LIKE V_STRPV_CUSTODYCD
AND AF.acctno LIKE V_STRPV_AFACCTNO
and tl.msgamt >0
union ALL
SELECT   tl.tltxcd||'T'|| sts.trfbuyext  tltxcd ,substr(tl.txdesc,1,12) txdesc,--tltx.txdesc ,
tl.txnum,tl.busdate ,tl.txdate,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc,tl.msgamt amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(tl.brid,'') brid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID,
''bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname,nvl(ci.trdesc,ci.txdesc) trdesc, ci.txtype
FROM vw_tllog_all TL,afmast af,cfmast cf ,--tltx,
tlprofiles mk,tlprofiles ck,vw_citran_gen CI, vw_stschd_all sts
where tl.msgacct=af.acctno and af.custid = cf.custid
--and tltx.tltxcd = tl.tltxcd
and  tl.tlid = mk.tlid(+)
and  tl.OFFID =ck.tlid(+)
AND TL.TXDATE = CI.TXDATE
AND TL.TXNUM = CI.TXNUM
AND CI.field ='BALANCE'
and tl.tltxcd ='8855'
and ci.ref = sts.orgorderid
and sts.duetype ='SM'
and /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate>=to_date(F_DATE,'DD/MM/YYYY')
AND /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate<=to_date(T_DATE,'DD/MM/YYYY')
AND STS.TXDATE>=to_date(F_DATE,'DD/MM/YYYY')
AND STS.TXDATE<=to_date(T_DATE,'DD/MM/YYYY')
AND TL.TLTXCD LIKE V_STRTLTXCD
and  nvl(tl.brid,V_STRBRID) like V_STRBRID
AND NVL( TL.TLID,'-') LIKE V_STRMAKER
AND NVL( TL.OFFID,'-') LIKE V_STRCHECKER
AND AF.COREBANK LIKE V_STRCOREBANK
AND CF.custodycd LIKE V_STRPV_CUSTODYCD
AND AF.acctno LIKE V_STRPV_AFACCTNO
union ALL
SELECT case when  tl.tltxcd in ('3350','3354') and  CI.TXCD ='0012'  then '3342'
            when  tl.tltxcd in ('3350','3354') and  CI.TXCD ='0011'  then '3343'
            else  tl.tltxcd end  tltxcd ,tltx.txdesc ,tl.txnum,tl.busdate ,tl.txdate
            ,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc, ci.namt /*tl.msgamt*/ amt,nvl(mk.tlname,'') mk --chaunh comment 02/12/2013
            ,nvl(ck.tlname,'')  ck,nvl(tl.brid,'') brid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID,
''bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname,ci.trdesc, ci.txtype
FROM vw_tllog_all TL,afmast af,cfmast cf ,tltx, tlprofiles mk,tlprofiles ck,vw_citran_gen CI
where tl.msgacct=af.acctno and af.custid = cf.custid
and tltx.tltxcd = tl.tltxcd
and  tl.tlid = mk.tlid(+)
and  tl.OFFID =ck.tlid(+)
AND TL.TXDATE = CI.TXDATE
AND TL.TXNUM = CI.TXNUM
AND CI.TXCD in('0012','0011')
and tl.tltxcd IN('3350','3354')
and /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate>=to_date(F_DATE,'DD/MM/YYYY')
AND /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate<=to_date(T_DATE,'DD/MM/YYYY')
AND case when  tl.tltxcd in ('3350','3354') then '3342' else  tl.tltxcd end  LIKE V_STRTLTXCD
and  nvl(tl.brid,V_STRBRID) like V_STRBRID
AND NVL( TL.TLID,'-') LIKE V_STRMAKER
AND NVL( TL.OFFID,'-') LIKE V_STRCHECKER
AND AF.COREBANK LIKE V_STRCOREBANK
AND CF.custodycd LIKE V_STRPV_CUSTODYCD
AND AF.acctno LIKE V_STRPV_AFACCTNO

UNION ALL
SELECT  tl.tltxcd ,tltx.txdesc ,tl.txnum,tl.busdate ,tl.txdate,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc,CI.NAMT amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(tl.brid,'') brid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID,
''bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname,nvl(ci.trdesc,ci.txdesc) trdesc, ci.txtype
FROM vw_tllog_all TL,afmast af,cfmast cf ,tltx, tlprofiles mk,tlprofiles ck,vw_citran_gen CI
where tl.msgacct=af.acctno and af.custid = cf.custid
and tltx.tltxcd = tl.tltxcd
and  tl.tlid = mk.tlid(+)
and  tl.OFFID =ck.tlid(+)
AND TL.TXDATE = CI.TXDATE
AND TL.TXNUM = CI.TXNUM
AND CI.field ='BALANCE'
and tl.tltxcd in('1153','8865','1139')
and /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate>=to_date(F_DATE,'DD/MM/YYYY')
AND /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate<=to_date(T_DATE,'DD/MM/YYYY')
AND TL.TLTXCD LIKE V_STRTLTXCD
and  nvl(tl.brid,V_STRBRID) like V_STRBRID
AND NVL( TL.TLID,'-') LIKE V_STRMAKER
AND NVL( TL.OFFID,'-') LIKE V_STRCHECKER
AND AF.COREBANK LIKE V_STRCOREBANK
AND CF.custodycd LIKE V_STRPV_CUSTODYCD
AND AF.acctno LIKE V_STRPV_AFACCTNO

--1178
union ALL
SELECT tl.tltxcd,tltx.txdesc ,tl.txnum,tl.busdate ,tl.txdate,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc,ads.amt amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(tl.brid,'') brid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID,
'' bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname, tl.txdesc trdesc, '' txtype
FROM vw_tllog_all TL,adschd ads ,afmast af,cfmast cf,tltx, tlprofiles mk,tlprofiles ck
where tl.msgamt =ads.autoid
and TL.msgacct = af.acctno and af.custid = cf.custid
and tltx.tltxcd = tl.tltxcd
and  tl.tlid = mk.tlid(+)
and  tl.OFFID =ck.tlid(+)
and tl.tltxcd in ('1178')
and /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate>=to_date(F_DATE,'DD/MM/YYYY')
AND /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate<=to_date(T_DATE,'DD/MM/YYYY')
AND TL.TLTXCD LIKE V_STRTLTXCD
and  nvl(tl.brid,V_STRBRID) like V_STRBRID
AND NVL( TL.TLID,'-') LIKE V_STRMAKER
AND NVL( TL.OFFID,'-') LIKE V_STRCHECKER
AND AF.COREBANK LIKE V_STRCOREBANK
AND CF.custodycd LIKE V_STRPV_CUSTODYCD
AND AF.acctno LIKE V_STRPV_AFACCTNO
--nhom bank
--'1131','1132','1136','1141'
union ALL

SELECT   tl.tltxcd ,tltx.txdesc ,tl.txnum,tl.busdate ,tl.txdate,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc,tl.msgamt amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(tl.brid,'') brid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID
,nvl(bank.fullname,' ') bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname, tl.txdesc trdesc,
case when tl.tltxcd in ('1132','1136') then 'D' else 'C' end txtype
FROM vw_tllog_all TL,afmast af,cfmast cf ,tltx, tlprofiles mk,tlprofiles ck,vw_tllogfld_all tlfld,banknostro bank
where tl.msgacct=af.acctno and af.custid = cf.custid
and tltx.tltxcd = tl.tltxcd
and  tl.tlid = mk.tlid(+)
and  tl.OFFID =ck.tlid(+)
and tlfld.txdate = tl.txdate
and tlfld.txnum = tl.txnum
and tlfld.fldcd='02'
and tlfld.cvalue=bank.shortname(+)
and tl.tltxcd in ('1131','1132','1136','1141')
and /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate>=to_date(F_DATE,'DD/MM/YYYY')
AND /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate<=to_date(T_DATE,'DD/MM/YYYY')
AND TL.TLTXCD LIKE V_STRTLTXCD
and  nvl(tl.brid,V_STRBRID) like V_STRBRID
AND NVL( TL.TLID,'-') LIKE V_STRMAKER
AND NVL( TL.OFFID,'-') LIKE V_STRCHECKER
AND AF.COREBANK LIKE V_STRCOREBANK
AND CF.custodycd LIKE V_STRPV_CUSTODYCD
AND AF.acctno LIKE V_STRPV_AFACCTNO
-- dfgroup
union ALL
SELECT tl.tltxcd,tltx.txdesc ,tl.txnum,tl.busdate ,tl.txdate,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc,CI.NAMT amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(tl.brid,'') brid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID,
nvl(CFB.shortname,'') bankid ,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname, CI.trdesc trdesc, ci.txtype
FROM vw_tllog_all TL,dfgroup dfg ,afmast af,cfmast cf,tltx, tlprofiles mk,tlprofiles ck,
 lnmast ln,lntype , CFMAST CFB,vw_citran_gen CI
where tl.msgacct= dfg.groupid and dfg.afacctno = af.acctno and af.custid = cf.custid
and tltx.tltxcd = tl.tltxcd
and dfg.lnacctno =ln.acctno
and ln.actype =lntype.actype
AND LN.actype= LNTYPE.actype
AND LN.custbank = CFB.custid(+)
and tl.tlid = mk.tlid(+)
and tl.OFFID =ck.tlid(+)
AND CI.ref =LN.acctno
AND CI.txnum = TL.txnum
AND CI.txdate =TL.txdate
and tl.tltxcd in ('2646','2648','2665','2636')
AND CI.field ='BALANCE'
and /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate>=to_date(F_DATE,'DD/MM/YYYY')
AND /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate<=to_date(T_DATE,'DD/MM/YYYY')
AND TL.TLTXCD LIKE V_STRTLTXCD
and  nvl(tl.brid,V_STRBRID) like V_STRBRID
AND NVL( TL.TLID,'-') LIKE V_STRMAKER
AND NVL( TL.OFFID,'-') LIKE V_STRCHECKER
AND AF.COREBANK LIKE V_STRCOREBANK
AND CF.custodycd LIKE V_STRPV_CUSTODYCD
AND AF.acctno LIKE V_STRPV_AFACCTNO

union ALL
SELECT   ci.tltxcd ,ci.txdesc/*tltx.txdesc*/ ,ci.txnum,ci.busdate ,ci.txdate,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc,ci.NAMT amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(ci.brid,'') brid,nvl(ci.tlid,'') tlid,nvl(ci.OFFID,'') OFFID,
nvl(CFB.shortname,'') bankid ,af.corebank,decode(af.bankname,'---','MSBS',af.bankname) bankname,ci.trdesc, ci.txtype
FROM --vw_tllog_all TL,
afmast af,cfmast cf ,--tltx,
tlprofiles mk,tlprofiles ck,
 vw_citran_gen ci,
 lnmast ln,lntype , CFMAST CFB
where ci.acctno=af.acctno and af.custid = cf.custid
--and tltx.tltxcd = ci.tltxcd
and  ci.tlid = mk.tlid(+)
and  ci.OFFID =ck.tlid(+)
--and ci.txnum= ci.txnum
--and ci.txdate = ci.txdate
and ci.ref = ln.acctno and ci.field ='BALANCE'
AND LN.actype= LNTYPE.actype
AND LN.custbank = CFB.custid(+)
and ci.tltxcd in ('5540','5566','5567')
and /*decode (V_STRTYPEDATE,'002',ci.busdate,ci.txdate)*/ci.busdate>=to_date(f_date,'DD/MM/YYYY')
AND /*decode (V_STRTYPEDATE,'002',ci.busdate,ci.txdate)*/ci.busdate<=to_date(t_date,'DD/MM/YYYY')
AND ci.TLTXCD LIKE V_STRTLTXCD
and  nvl(ci.brid,V_STRBRID) like V_STRBRID
AND NVL( ci.TLID,'-') LIKE V_STRMAKER
AND NVL( ci.OFFID,'-') LIKE V_STRCHECKER
AND AF.COREBANK LIKE V_STRCOREBANK
AND CF.custodycd LIKE V_STRPV_CUSTODYCD
AND AF.acctno LIKE V_STRPV_AFACCTNO
union ALL

SELECT   tl.tltxcd ,tltx.txdesc ,tl.txnum,tl.busdate ,tl.txdate,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc,tl.msgamt amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(tl.brid,'') brid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID,
nvl(CFB.shortname,'') bankid ,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname, tl.txdesc trdesc, 'C' txtype
FROM vw_tllog_all TL,afmast af,cfmast cf ,tltx, tlprofiles mk,tlprofiles ck,  vw_tllogfld_all tlfld, lnmast ln,lntype , CFMAST CFB
where tl.msgacct=af.acctno and af.custid = cf.custid
and tltx.tltxcd = tl.tltxcd
and  tl.tlid = mk.tlid(+)
and  tl.OFFID =ck.tlid(+)
and tl.txnum= tlfld.txnum
and tl.txdate = tlfld.txdate
and tlfld.fldcd ='21'
and tlfld.cvalue = ln.acctno(+)
AND LN.actype= LNTYPE.actype
AND LN.custbank = CFB.custid(+)
AND LN.actype= LNTYPE.actype
AND LN.custbank = CFB.custid(+)
and tl.tltxcd ='2674'
and /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate>=to_date(F_DATE,'DD/MM/YYYY')
AND /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate<=to_date(T_DATE,'DD/MM/YYYY')
AND TL.TLTXCD LIKE V_STRTLTXCD
and  nvl(tl.brid,V_STRBRID) like V_STRBRID
AND NVL( TL.TLID,'-') LIKE V_STRMAKER
AND NVL( TL.OFFID,'-') LIKE V_STRCHECKER
AND AF.COREBANK LIKE V_STRCOREBANK
AND CF.custodycd LIKE V_STRPV_CUSTODYCD
AND AF.acctno LIKE V_STRPV_AFACCTNO

union ALL
SELECT  ci.tltxcd   tltxcd ,tltx.txdesc ,ci.txnum,ci.busdate ,ci.txdate,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc,
ci.namt amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(ci.brid,'') brid,nvl(ci.tlid,'') tlid,nvl(ci.OFFID,'') OFFID,
''bankid,af.corebank,decode(af.bankname,'---','MSBS',af.bankname) bankname,CI.trdesc, ci.txtype
FROM --vw_tllog_all TL,
  afmast af,cfmast cf ,tltx, tlprofiles mk,tlprofiles ck,
 vw_citran_gen   ci
where
 CI.busdate>=to_date(f_date,'DD/MM/YYYY')
AND ci.busdate<=to_date(t_date,'DD/MM/YYYY')
and ci.acctno=af.acctno and af.custid = cf.custid
and tltx.tltxcd = ci.tltxcd
and  ci.tlid = mk.tlid(+)
and  ci.OFFID =ck.tlid(+)
and ci.tltxcd  IN ('0088','1670','1610','1600','1620','1137','1138','3384','3394') --chaunh add 3384, 3394
and ci.field ='BALANCE'
AND ci.TLTXCD LIKE V_STRTLTXCD
and  nvl(ci.brid,V_STRBRID) like V_STRBRID
AND NVL( ci.TLID,'-') LIKE V_STRMAKER
AND NVL( ci.OFFID,'-') LIKE V_STRCHECKER
AND AF.COREBANK LIKE V_STRCOREBANK
AND CF.custodycd LIKE V_STRPV_CUSTODYCD
AND AF.acctno LIKE V_STRPV_AFACCTNO
union all
--begin chaunh -- voi giao dich corebank
----- 8894
select tl.tltxcd, tl.txdesc, tl.txnum, tl.busdate, tl.txdate, cf.custodycd, af.acctno
    ,' ' custodycdc,'' acctnoc
    , tl.msgamt amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(AF.brid,'') brid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID
    ,' ' bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname, tl.txdesc trdesc
    ,  'C' txtype --tong tien ban
from vw_tllog_all tl, cfmast cf, semast se, afmast af, tlprofiles mk, tlprofiles ck
where  tl.tltxcd = '8894' and af.corebank = 'Y'
    and cf.custid = af.custid and tl.msgacct = se.acctno and se.afacctno = af.acctno
    and tl.tlid = mk.tlid(+) and tl.chkid = ck.tlid(+)
    and /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate>=to_date(F_DATE,'DD/MM/YYYY')
    AND /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate<=to_date(T_DATE,'DD/MM/YYYY')
    AND TL.TLTXCD LIKE V_STRTLTXCD
    and  nvl(tl.brid,V_STRBRID) like V_STRBRID
    AND NVL( TL.TLID,'-') LIKE V_STRMAKER
    AND NVL( TL.OFFID,'-') LIKE V_STRCHECKER
    AND AF.COREBANK LIKE V_STRCOREBANK
    AND CF.custodycd LIKE V_STRPV_CUSTODYCD
    AND AF.acctno LIKE V_STRPV_AFACCTNO
union all
select tl.tltxcd,case when  crb.trfcode = 'TRFODSRTL' then 'Phi ' || crb.notes else crb.notes end txdesc, tl.txnum, tl.busdate, tl.txdate, cf.custodycd, af.acctno
    ,' ' custodycdc,'' acctnoc
    ,case when crb.trfcode = 'TRFODSRTL' then  tl.msgamt - crb.txamt --phi ban
          when crb.trfcode = 'TRFODSRTDF' then crb.txamt end  amt --thue ban
    ,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(AF.brid,'') brid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID
    ,' ' bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname, tl.txdesc trdesc
    ,  'D'  txtype
from vw_tllog_all tl, (select * from CRBTXREQ union all select * from crbtxreqhist) crb, cfmast cf, semast se, afmast af, tlprofiles mk, tlprofiles ck
where tl.txnum = crb.refcode and tl.txdate = crb.txdate and tltxcd = '8894'
    and cf.custid = af.custid and tl.msgacct = se.acctno and se.afacctno = af.acctno
    and tl.tlid = mk.tlid(+) and tl.chkid = ck.tlid(+)
    and /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate>=to_date(F_DATE,'DD/MM/YYYY')
    AND /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate<=to_date(T_DATE,'DD/MM/YYYY')
    AND TL.TLTXCD LIKE V_STRTLTXCD
    and  nvl(tl.brid,V_STRBRID) like V_STRBRID
    AND NVL( TL.TLID,'-') LIKE V_STRMAKER
    AND NVL( TL.OFFID,'-') LIKE V_STRCHECKER
    AND AF.COREBANK LIKE V_STRCOREBANK
    AND CF.custodycd LIKE V_STRPV_CUSTODYCD
    AND AF.acctno LIKE V_STRPV_AFACCTNO
union all
--3386
select tl.tltxcd, crb.notes txdesc, tl.txnum, tl.busdate, tl.txdate, cf.custodycd, af.acctno
    ,' ' custodycdc,'' acctnoc,crb.txamt amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(AF.brid,'') brid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID
    ,' ' bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname, tl.txdesc trdesc
    , case when crb.trfcode='TRFCAUNREG' then 'D' end txtype
from vw_tllog_all tl, (select * from CRBTXREQ union all select * from crbtxreqhist) crb, cfmast cf, afmast af, tlprofiles mk, tlprofiles ck
where tl.txnum = crb.refcode and tl.txdate = crb.txdate and tl.tltxcd = '3386'
    and cf.custid = af.custid and tl.msgacct = af.acctno
    and tl.tlid = mk.tlid(+) and tl.chkid = ck.tlid(+)
    and /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate>=to_date(F_DATE,'DD/MM/YYYY')
    AND /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate<=to_date(T_DATE,'DD/MM/YYYY')
    AND TL.TLTXCD LIKE V_STRTLTXCD
    and  nvl(tl.brid,V_STRBRID) like V_STRBRID
    AND NVL( TL.TLID,'-') LIKE V_STRMAKER
    AND NVL( TL.OFFID,'-') LIKE V_STRCHECKER
    AND AF.COREBANK LIKE V_STRCOREBANK
    AND CF.custodycd LIKE V_STRPV_CUSTODYCD
    AND AF.acctno LIKE V_STRPV_AFACCTNO
union all
--3350,3354
SELECT case when  tl.tltxcd in ('3350','3354') and  ci.field in ( 'CRAMT','RECEIVING')  then '3342' --cong
            when  tl.tltxcd in ('3350','3354') and  CI.field = 'DRAMT'  then '3343' --tru
            else  tl.tltxcd end  tltxcd  ,tltx.txdesc ,tl.txnum,tl.busdate ,tl.txdate
            ,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc
            ,case when tl.tltxcd = '3354' then  tl.msgamt else ci.namt end amt
            ,nvl(mk.tlname,'') mk
            ,nvl(ck.tlname,'')  ck,nvl(AF.brid,'') brid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID
            ,''bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname,ci.trdesc
            , case when ci.field = 'CRAMT' and tl.tltxcd = '3350' then 'C'
                   when ci.field = 'RECEIVING' and tl.tltxcd = '3354' then 'C'
                   when ci.field = 'DRAMT' and tl.tltxcd = '3350' then 'D'
                   end txtype
FROM vw_tllog_all TL,afmast af,cfmast cf ,tltx, tlprofiles mk,tlprofiles ck,vw_citran_gen CI
where tl.msgacct=af.acctno and af.custid = cf.custid
and tltx.tltxcd = tl.tltxcd and af.corebank = 'Y'
and  tl.tlid = mk.tlid(+)
and  tl.OFFID =ck.tlid(+)
AND TL.TXDATE = CI.TXDATE
AND TL.TXNUM = CI.TXNUM
AND case when tl.tltxcd = '3350' and CI.field in('CRAMT','DRAMT') then 1
         when tl.tltxcd = '3354' and ci.field = 'RECEIVING' then 1
         else 0 end = 1
and tl.tltxcd IN('3350','3354')
and /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate>=to_date(F_DATE,'DD/MM/YYYY')
AND /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate<=to_date(T_DATE,'DD/MM/YYYY')
AND '3342'   LIKE V_STRTLTXCD
and  nvl(tl.brid,V_STRBRID) like V_STRBRID
AND NVL( TL.TLID,'-') LIKE V_STRMAKER
AND NVL( TL.OFFID,'-') LIKE V_STRCHECKER
AND AF.COREBANK LIKE V_STRCOREBANK
AND CF.custodycd LIKE V_STRPV_CUSTODYCD
AND AF.acctno LIKE V_STRPV_AFACCTNO
union all
--8866,8856,0066
SELECT tl.tltxcd  ,tl.txdesc ,tl.txnum,tl.busdate ,tl.txdate
            ,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc
            , tl.msgamt amt
            ,nvl(mk.tlname,'') mk
            ,nvl(ck.tlname,'')  ck,nvl(AF.brid,'') brid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID
            ,''bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname,tl.txdesc
            , case when tl.tltxcd = '8866' then 'C'
                   when  tl.tltxcd in ('8856','0066') then 'D'
                   end txtype
FROM vw_tllog_all TL,afmast af,cfmast cf ,tltx, tlprofiles mk,tlprofiles ck
where tl.msgacct=af.acctno and af.custid = cf.custid
and tltx.tltxcd = tl.tltxcd and af.corebank = 'Y'
and  tl.tlid = mk.tlid(+)
and  tl.OFFID =ck.tlid(+)
and tl.tltxcd IN('8866','8856','0066')
and /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate>=to_date(F_DATE,'DD/MM/YYYY')
AND /*decode (V_STRTYPEDATE,'002',TL.busdate,TL.txdate)*/tl.busdate<=to_date(T_DATE,'DD/MM/YYYY')
AND  tl.tltxcd   LIKE V_STRTLTXCD
and  nvl(TL.brid,V_STRBRID) like V_STRBRID
AND NVL( TL.TLID,'-') LIKE V_STRMAKER
AND NVL( TL.OFFID,'-') LIKE V_STRCHECKER
AND AF.COREBANK LIKE V_STRCOREBANK
AND CF.custodycd LIKE V_STRPV_CUSTODYCD
AND AF.acctno LIKE V_STRPV_AFACCTNO

--end chaunh
)a
where substr(a.custodycd,4,1) <> 'P'
ORDER BY A.TLTXCD ,a.busdate,A.TXNUM
;
end if;


END; -- Procedure
/

