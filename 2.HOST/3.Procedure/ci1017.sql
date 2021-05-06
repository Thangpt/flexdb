CREATE OR REPLACE PROCEDURE ci1017(
   PV_REFCURSOR     IN OUT   PKG_REPORT.REF_CURSOR,
   OPT              IN       VARCHAR2,
   BRID             IN       VARCHAR2,
   F_DATE           IN       VARCHAR2,
   T_DATE           IN       VARCHAR2,
   PV_CUSTODYCD     IN       VARCHAR2,
   PV_AFACCTNO      IN       VARCHAR2
        )
   IS
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



 OPEN PV_REFCURSOR FOR

select a.tltxcd, a.txdesc, a.txdate, a.trdesc, a.acctno, a.custid, cf.fullname , cf.custodycd, sum(a.amt) amt from
(
SELECT case when  tl.tltxcd in ('3350','3354') then '3342'
            else  tl.tltxcd end  tltxcd
        ,case when tl.tltxcd in ('1101','1120','1130','1111','1185','1188') and ci.txcd = '0028' then  utf8nums.c_const_RPT_CI1018_Phi_DESC
            else  tltx.txdesc end txdesc
        ,tl.txdate
        , case when tl.tltxcd = '8894' and af.corebank = 'Y' then tl.msgamt
            else  ci.namt end /*tl.msgamt*/ amt
        ,case when tl.tltxcd in ('1101','1120','1130','1111','1185','1188') and ci.txcd = '0028' then tltx.txdesc || ' - ' || tl.tltxcd
            when tl.tltxcd in ('2200','8894','3382','3383','0088','1113') and ci.txcd = '0011' then ci.trdesc else tl.txdesc end trdesc
        ,af.acctno, af.custid
FROM vw_tllog_all TL,tltx, vw_citran_gen ci, afmast af,cfmast cf
where  tltx.tltxcd = tl.tltxcd and ci.acctno = af.acctno
and tl.tltxcd in ('1180','1182','1105','8855'
,'8856',/*'0066',*/'8894','1113', '2200','3382','3383','0088'
,'1101','1120','1130','1111','1185','1188')
and ci.txdate = tl.txdate and ci.txnum = tl.txnum
and case when tl.tltxcd in ('1101','1120','1130','1111','1185','1188') and ci.txcd = '0028' then 1
   when tl.tltxcd = '8894' and ci.txcd = '0011' and substr(ci.trdesc,1,3) <> 'Thu' then 1 --bo thue
   when tl.tltxcd not in ('1101','1120','1130','1111','1185','1188', '8894') then 1
   else 0 end = 1
and  ci.field in ('BAMT','BALANCE','MBLOCK','EMKAMT')
and case when tl.tltxcd in ('1113', '2200','3382','3383','0088') and ci.txcd <> '0011' then 0
        when tl.tltxcd in ('1120','1130','1185','1188') and ci.txcd <> '0028' then 0
else 1 end = 1
and tl.txdate>=to_date(F_DATE,'DD/MM/YYYY')
AND tl.txdate<=to_date(T_DATE,'DD/MM/YYYY')
and af.custid=cf.custid
and  nvl(cF.brid,V_STRBRID) like V_STRBRID


union all
----------------------------------------

SELECT  tl.tltxcd ,tltx.txdesc ,tl.txdate,CI.NAMT amt,nvl(ci.trdesc,ci.txdesc) trdesc,af.acctno, af.custid
FROM vw_tllog_all TL,afmast af ,tltx, vw_citran_gen CI,cfmast cf
where tl.msgacct=af.acctno
and tltx.tltxcd = tl.tltxcd
AND TL.TXDATE = CI.TXDATE
AND TL.TXNUM = CI.TXNUM
AND CI.field ='BALANCE'
and ci.txcd = '0011'
and tl.tltxcd in('1153','1139')
and tl.txdate>=to_date(F_DATE,'DD/MM/YYYY')
AND tl.txdate<=to_date(T_DATE,'DD/MM/YYYY')
and af.custid=cf.custid
and  nvl(cF.brid,V_STRBRID) like V_STRBRID

union all

SELECT  tl.tltxcd   tltxcd ,tltx.txdesc ,tl.txdate,ci.namt amt,CI.trdesc,af.acctno, af.custid
FROM vw_tllog_all TL,afmast af,tltx,vw_citran_gen   ci,cfmast cf
where ci.acctno=af.acctno
and tltx.tltxcd = tl.tltxcd
and tl.txdate = ci.txdate
and tl.txnum = ci.txnum
and ci.txcd = '0011'
and tl.tltxcd  IN ('0088','1137') --chaunh add 3384, 3394
and ci.field ='BALANCE'
and tl.txdate>=to_date(F_DATE,'DD/MM/YYYY')
AND tl.txdate<=to_date(T_DATE,'DD/MM/YYYY')
and af.custid=cf.custid
and  nvl(cF.brid,V_STRBRID) like V_STRBRID

union all
select tl.tltxcd,case when  crb.trfcode = 'TRFODSRTL' then 'Phi ' || crb.notes else crb.notes end txdesc,  tl.txdate
    , case when crb.trfcode = 'TRFODSRTL' then  tl.msgamt - crb.txamt --phi ban
             /*when crb.trfcode = 'TRFODSRTDF' then crb.txamt*/ end  amt --thue ban
    , tl.txdesc trdesc,af.acctno, af.custid

from vw_tllog_all tl, (select * from CRBTXREQ union all select * from crbtxreqhist) crb,  semast se, afmast af,cfmast cf
where tl.txnum = crb.refcode and tl.txdate = crb.txdate and tltxcd = '8894'
and tl.msgacct = se.acctno and se.afacctno = af.acctno
and crb.trfcode = 'TRFODSRTL' --chi lay phi
and tl.txdate>=to_date(F_DATE,'DD/MM/YYYY')
AND tl.txdate<=to_date(T_DATE,'DD/MM/YYYY')
and cf.custid=af.custid
and  nvl(cF.brid,V_STRBRID) like V_STRBRID

union all
--8866,8856,0066
SELECT tl.tltxcd  ,tl.txdesc ,tl.txdate
       , tl.msgamt amt
       ,tl.txdesc
       , af.acctno, af.custid
FROM vw_tllog_all TL,afmast af,tltx,cfmast cf
where tl.msgacct=af.acctno
and tltx.tltxcd = tl.tltxcd and af.corebank = 'Y'
and tl.tltxcd IN('8856')
and tl.txdate>=to_date(F_DATE,'DD/MM/YYYY')
AND tl.txdate<=to_date(T_DATE,'DD/MM/YYYY')
and cf.custid=af.custid
and  nvl(cF.brid,V_STRBRID) like V_STRBRID


union all

SELECT   tl.tltxcd ,tltx.txdesc ,tl.txdate,tran.NAMT amt
    ,'Trả nợ lãi '|| DECODE(ln.rrtype,'C',CASE WHEN tl.txdate >= '08-Jan-2017' THEN 'KBSV/'
                                               WHEN tl.txdate >= '07-Aug-2015' THEN 'MSI/'
                                          ELSE 'MSBS/' END,'MSB/')||DECODE(chd.reftype, 'GP','CL+/','CL/')|| to_char(ln.rlsdate,'DD.MM.RRRR') ||'/'|| trim(to_char((chd.nml + chd.ovd + chd.paid),'99,999,999,999,999')) trdesc
    , af.acctno, af.custid
FROM vw_tllog_all TL,afmast af ,tltx,
 lnmast ln,vw_lntran_all tran, vw_lnschd_all chd,cfmast cf
where tl.msgacct=af.acctno
and tltx.tltxcd = tl.tltxcd
and tl.txnum= tran.txnum and to_char(chd.autoid) = to_char(tran.acctref)
and tl.txdate = tran.txdate and tran.acctno = ln.acctno and tran.txcd in ('0024','0075') --INTPAIT, OINTPAID
and ln.trfacctno = tl.msgacct
and tl.tltxcd in ('5540','5567')
and TL.txdate>=to_date(F_DATE,'DD/MM/YYYY')
AND TL.txdate<=to_date(T_DATE,'DD/MM/YYYY')
and cf.custid=af.custid
and  nvl(CF.brid,V_STRBRID) like V_STRBRID

) a, cfmast cf
where a.custid = cf.custid
and a.acctno like V_STRPV_AFACCTNO
and cf.custodycd like V_STRPV_CUSTODYCD
group by a.tltxcd, a.txdesc, a.txdate, a.trdesc, a.acctno, a.custid, cf.fullname, cf.custodycd
order by a.txdate, a.custid, a.acctno, a.tltxcd

;




EXCEPTION
    WHEN OTHERS
   THEN
      RETURN;
END; -- Procedure
