CREATE OR REPLACE PROCEDURE se2000 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         in       varchar2,
   PV_CUSTODYCD         IN       VARCHAR2,
   PV_CFRELATION    IN  VARCHAR2,
   PV_PLSENT    IN VARCHAR2
 )
IS

    V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID          VARCHAR2 (40);    -- USED WHEN V_NUMOPTION > 0
    V_INBRID     VARCHAR2 (5);
    V_advsellduty       number;


BEGIN

   V_STROPTION := upper(OPT);
   V_INBRID := BRID;

   if(V_STROPTION = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := BRID;
        end if;
    end if;
    select to_number(varvalue) into V_advsellduty  from sysvar where varname like 'ADVSELLDUTY';

OPEN PV_REFCURSOR FOR
select main.*, s.symbol, al.cdcontent san, c.custodycd,  c.fullname, c.idcode, c.idplace, c.iddate, c.address,
       UQ.fullname UQ_name, UQ.chuc_vu UQ_chucvu, UQ.iddate UQ_IDDATE, UQ.IDPLACE UQ_IDPLACE, UQ.IDCODE UQ_IDCODE,
       S.VARVALUE MS_FULLNAME,S.VARDESC MS_POSITION,S2.VARVALUE MSB_AUTH, V_INBRID chi_nhanh,
       case when aft.vat = 'Y' then V_advsellduty else 0 end advsellduty
from
(
    select tl.txdate, tl.txnum,  ci.acctno, se.codeid,
       se.namt so_CK, ci.namt so_Tien
    from vw_tllog_all tl, vw_citran_gen ci, vw_setran_gen se
    where tl.tltxcd = '8878' and tl.txnum = ci.txnum and tl.txdate = ci.txdate and tl.txnum = se.txnum and tl.txdate = se.txdate
    and se.field = 'NETTING'
    union
    -- giao dich chua duyet
    select txdate, txnum , acctno, codeid, so_CK, gia*so_CK so_Tien from
    (
        select tl.txdate, tl.txnum ,
               max(case when fldcd = '02' then cvalue end) acctno,
               max(case when fldcd = '01' then cvalue end) codeid,
               max(case when fldcd = '10' then nvalue end) so_CK,
               max(case when fldcd = '11' then nvalue end) gia
        from tllog4dr tl, tllogfld4dr fl
        where tl.txdate = fl.txdate and tl.txnum = fl.txnum and tl.tltxcd = '8878'
        group by tl.txdate, tl.txnum
    )
)main, cfmast c, afmast a, sbsecurities s , aftype aft,
(
    select trim(r.custid) custid, c.fullname, c.idcode, c.iddate, c.idplace,  a.cdcontent chuc_vu
    from CFRELATION r, cfmast c, allcode a
    where c.custid = trim(r.recustid) and a.cdname = 'RETYPE' and a.cdtype = 'CF' and a.cdval = r.retype AND C.CUSTID = NVL(PV_CFRELATION,' ')
) UQ , SYSVAR S, SYSVAR S2, allcode al
where c.custid = a.custid and a.acctno = main.acctno
and c.custodycd like PV_CUSTODYCD
and main.txdate = to_date(I_DATE, 'DD/MM/RRRR')
and main.codeid = s.codeid
and al.cdname = 'TRADEPLACE' and al.cdtype = 'OD' and al.cdval = s.tradeplace
and c.custid = UQ.custid (+)
and a.actype = aft.actype
AND S.GRNAME = 'REPRESENT' AND S.VARNAME = PV_PLSENT AND S2.GRNAME = 'REPRESENT'
AND CASE WHEN PV_PLSENT ='MSBSREP01' THEN 'MSBSREPAUTH01'
        WHEN PV_PLSENT ='MSBSREP02' THEN 'MSBSREPAUTH02'
        WHEN PV_PLSENT ='MSBSREP03' THEN 'MSBSREPAUTH03' END = S2.VARNAME

/*
SELECT
--KH
C.CUSTID, C.FULLNAME CM_FULLNAME,A.ACCTNO CM_ACCTNO,C.IDCODE CM_IDCODE,C.IDDATE CM_IDATE,C.IDPLACE CM_IDPLACE,C.CUSTODYCD CM_CUSTODYCD ,
B.FULLNAME RE_NAME,B.CHUC_VU RE_POSITION,
--MSB
S.VARVALUE MS_FULLNAME,S.VARDESC MS_POSITION,S2.VARVALUE MSB_AUTH,
V_INBRID chi_nhanh
FROM CFMAST C, AFMAST A ,
    (
    select trim(r.custid) custid, c.fullname, a.cdcontent chuc_vu
    from CFRELATION r, cfmast c, allcode a
    where c.custid = trim(r.recustid) and a.cdname = 'RETYPE' and a.cdtype = 'CF' and a.cdval = r.retype AND C.CUSTID = NVL(PV_CFRELATION,' ')
    ) B, SYSVAR S, SYSVAR S2
WHERE C.CUSTID = A.CUSTID
AND C.CUSTID = B.CUSTID(+)
AND S.GRNAME = 'REPRESENT' AND S.VARNAME = PV_PLSENT AND S2.GRNAME = 'REPRESENT'
AND CASE WHEN PV_PLSENT ='MSBSREP01' THEN 'MSBSREPAUTH01'
        WHEN PV_PLSENT ='MSBSREP02' THEN 'MSBSREPAUTH02'
        WHEN PV_PLSENT ='MSBSREP03' THEN 'MSBSREPAUTH03' END = S2.VARNAME
AND C.CUSTODYCD LIKE PV_CUSTODYCD
AND A.ACCTNO LIKE PV_AFACCTNO*/
;
EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
End;
/

