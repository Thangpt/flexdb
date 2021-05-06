CREATE OR REPLACE PROCEDURE ci0009(
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   CUSTODYCD      IN       VARCHAR2,
   TLID           IN       VARCHAR2
 )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- BAO CAO TINH PHI THAU CHI CUA KHACH HANG
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- NAMNT   20-DEC-06  CREATED
-- HUNG.LB 10-SEP-10  UPDATED
-- ANH.PT  14-SEP-10  UPDATED
-- ---------   ------  -------------------------------------------
   V_STROPTION     VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID       VARCHAR2 (40);                   -- USED WHEN V_NUMOPTION > 0
   V_INBRID        VARCHAR2 (4);

   V_STRCUSTODYCD   VARCHAR2 (20);
   v_SubBRID  varchar2(4);
   v_TLID  varchar2(4);

BEGIN
   V_STROPTION := upper(OPT);
   V_INBRID := BRID;

   IF (V_STROPTION = 'A') THEN
      V_STRBRID := '%';
   ELSE IF (V_STROPTION = 'B') THEN
            select brgrp.mapid into V_STRBRID from brgrp where brgrp.brid = V_INBRID;
        ELSE
            V_STRBRID := V_INBRID;
        END IF;
   END IF;

   -- GET REPORT'S PARAMETERS
  IF (CUSTODYCD <> 'ALL')
   THEN
      V_STRCUSTODYCD :=  CUSTODYCD;
   ELSE
      V_STRCUSTODYCD := '%%';
   END IF;

   v_TLID:=TLID;
   select brid into v_SubBRID from tlprofiles where tlid = v_TLID;

   -- GET REPORT'S DATA

OPEN  PV_REFCURSOR FOR
select tl.txdate , tl.busdate , tl.txnum , fcf.custodycd fcustodycd,tl.msgacct  f_acctno,
    fcf.fullname  ffullname ,tcf.custodycd tcustodycd, ci.acctno t_acctno, tcf.fullname  tfullname,
    ci.namt ,mk.tlname  maker , ck.tlname checker, tl.txdesc, tl.autoid
from tllogall tl , citrana ci , afmast faf , afmast taf , cfmast fcf ,
    cfmast tcf , tlprofiles mk , tlprofiles ck
where tl.txnum = ci.txnum
and tl.txdate = ci.txdate
and tl.deltd  <> 'Y'
and tl.tltxcd in ('1120','1134','1188')
and ci.txcd ='0012'
and tl.msgacct = faf.acctno
and faf.custid = fcf.custid
and ci.acctno = taf.acctno
and taf.custid = tcf.custid
and tl.TLID =mk.tlid
and tl.offid =ck.tlid(+)
and (tl.brid like V_STRBRID or INSTR(V_STRBRID,tl.brid) <> 0)
and tl.busdate BETWEEN to_date (F_DATE,'DD/MM/YYYY') and to_date (T_DATE ,'DD/MM/YYYY')
and exists (select faf.acctno from vw_custodycd_subaccount vw
where
/*vw.filtercd like V_STRCUSTODYCD and */
faf.acctno =  vw.value)
---and ( case when substr(tl.txnum,1,1)='9' then '0001' else  tl.brid end) = v_SubBRID
union all
select tl.txdate , tl.busdate , tl.txnum , fcf.custodycd fcustodycd ,tl.msgacct  f_acctno  ,
    fcf.fullname  ffullname ,tcf.custodycd tcustodycd,ci.acctno t_acctno, tcf.fullname  tfullname,
    ci.namt ,mk.tlname  maker , ck.tlname checker, tl.txdesc,tl.autoid
from tllog tl , citran ci , afmast faf , afmast taf , cfmast fcf , cfmast tcf ,
    tlprofiles mk , tlprofiles ck
where tl.txnum = ci.txnum
and tl.txdate = ci.txdate
and tl.deltd  <> 'Y'
and tl.tltxcd in ('1120','1134','1188')
and ci.txcd ='0012'
and tl.msgacct = faf.acctno
and faf.custid = fcf.custid
and ci.acctno = taf.acctno
and taf.custid = tcf.custid
and tl.TLID =mk.tlid
and tl.offid =ck.tlid(+)
and (tl.brid like V_STRBRID or INSTR(V_STRBRID,tl.brid) <> 0)
and tl.busdate BETWEEN to_date (F_DATE,'DD/MM/YYYY') and to_date (T_DATE ,'DD/MM/YYYY')
--and ( case when substr(tl.txnum,1,1)='9' then '0001' else  tl.brid end) = v_SubBRID
and exists (select faf.acctno from vw_custodycd_subaccount vw
where
/*vw.filtercd like V_STRCUSTODYCD and */
faf.acctno =  vw.value)
order by busdate, autoid ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

