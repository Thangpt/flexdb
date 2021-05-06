CREATE OR REPLACE PROCEDURE se2002 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         in       varchar2,
   T_DATE         in       varchar2,
   PV_CUSTODYCD         IN       VARCHAR2,
   PV_CFRELATION    IN  VARCHAR2
 )
IS

    V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID          VARCHAR2 (40);    -- USED WHEN V_NUMOPTION > 0
    V_INBRID     VARCHAR2 (5);



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


OPEN PV_REFCURSOR FOR
select se.acctno, se.namt, se.txnum, se.txdate, a.cdcontent tradeplace,se.symbol,
    cf.fullname, cf.idcode, cf.iddate, cf.idplace, cf.address, cf.custodycd,
    to_date(fl.cvalue,'DD/MM/RRRR') ngay_phong_toa, se.txdesc,
    UQ.fullname UQ_nam, UQ.idcode UQ_code, UQ.iddate UQ_IDDATE, UQ.idplace UQ_idplace, UQ.chuc_vu UQ_Position
from vw_setran_gen se , cfmast cf, vw_tllogfld_all fl, allcode a,
  (
  select trim(r.custid) custid, c.fullname, c.idcode, c.iddate, c.idplace,  a.cdcontent chuc_vu
  from CFRELATION r, cfmast c, allcode a
  where c.custid = trim(r.recustid) and a.cdname = 'RETYPE' and a.cdtype = 'CF' and a.cdval = r.retype AND C.CUSTID = NVL(PV_CFRELATION,' ')
  ) UQ
where se.tltxcd = '2203' and se.field = 'BLOCKED'
and a.cdname = 'TRADEPLACE' and a.cdtype = 'SE' and a.cdval = se.tradeplace
and se.custid = cf.custid
and fl.txnum = se.txnum and fl.txdate = se.txdate and fl.fldcd = '26'
and cf.custid = UQ.custid (+)
and cf.custodycd =  PV_CUSTODYCD
and se.txdate <= to_date(T_DATE, 'DD/MM/RRRR')
and se.txdate >= to_date(F_DATE, 'DD/MM/RRRR')


;
EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
End;
/

