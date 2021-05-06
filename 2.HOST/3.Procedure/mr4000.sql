CREATE OR REPLACE PROCEDURE mr4000 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   CUSTODYCD       IN       VARCHAR2,
   AFACCTNO       IN       VARCHAR2
  )
IS


   V_STROPT     VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID    VARCHAR2 (40);                   -- USED WHEN V_NUMOPTION > 0
   V_INBRID     VARCHAR2 (5);                  -- USED WHEN V_NUMOPTION > 0
   v_FromDate date;
   v_ToDate date;
   v_CustodyCD varchar2(20);
   v_AFAcctno varchar2(20);


BEGIN


 V_STROPT := UPPER(OPT);
    V_INBRID := BRID;

    IF(V_STROPT = 'A') THEN
        V_STRBRID := '%';
    ELSE
        IF(V_STROPT = 'B') THEN
            SELECT BR.MAPID INTO V_STRBRID FROM BRGRP BR WHERE  BR.BRID = V_INBRID;
        ELSE
            V_STRBRID := BRID;
        END IF;
    END IF;

v_FromDate:= to_date(F_DATE,'DD/MM/RRRR');
v_ToDate:= to_date(T_DATE,'DD/MM/RRRR');
v_CustodyCD:= upper(replace(custodycd,'.',''));
v_AFAcctno:= upper(replace(AFACCTNO,'.',''));

if v_CustodyCD = 'ALL' or v_CustodyCD is null then
    v_CustodyCD := '%';
else
    v_CustodyCD := v_CustodyCD;
end if;

if v_AFAcctno = 'ALL' or v_AFAcctno is null then
    v_AFAcctno := '%';
else
    v_AFAcctno := v_AFAcctno;
end if;


OPEN PV_REFCURSOR FOR

    select mr.*, cf.custodycd, cf.fullname from
    log_mr4000 mr, afmast af, cfmast cf where mr.afacctno = af.acctno and af.custid = cf.custid
    and cf.custodycd like v_CustodyCD
    and af.acctno like v_afacctno
    and mr.txdate between v_FromDate and v_ToDate
    AND (AF.BRID LIKE V_STRBRID OR INSTR(V_STRBRID,AF.BRID) <> 0)
    and bamt <> 0 and  receiving <> 0
    order by cf.custodycd, mr.txdate
    ;

EXCEPTION
  WHEN OTHERS
   THEN
      Return;
End;
/

