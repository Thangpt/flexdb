create or replace procedure SE0047(
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
  -- T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD    IN       VARCHAR2,
   PV_AFACCTNO     IN       VARCHAR2,
   SYMBOL          IN       VARCHAR2
) is

   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH

   V_STRPV_CUSTODYCD VARCHAR2(20);
   V_STRPV_AFACCTNO VARCHAR2(20);
   V_INBRID        VARCHAR2(4);
   V_STRBRID      VARCHAR2 (50);
   V_SYMBOL        VARCHAR2 (50);

   v_fromdate   date;
   --v_todate     date;
begin
   V_STROPTION := UPPER(OPT);
   V_INBRID := BRID;

    if(V_STROPTION = 'A') then
        V_STRBRID := '%%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := V_INBRID;
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

   IF(SYMBOL <> 'ALL')THEN
        V_SYMBOL  := SYMBOL;
   ELSE
        V_SYMBOL := '%%';
   END IF;

   v_fromdate := to_date(I_DATE,'dd/MM/rrrr');


   open PV_REFCURSOR
   for
   select distinct se.custodycd, cf.fullname, cf.idcode, cf.iddate,se.namt, se.busdate,se.txdesc,
                    (CASE WHEN se.TRADEPLACE='002' THEN 'Sàn HNX'
                          WHEN se.TRADEPLACE='001' THEN 'Sàn HOSE'
                          WHEN se.TRADEPLACE='005' THEN 'Sàn UPCOM'
                          ELSE '' END) SAN_GD, se.symbol
   from vw_setran_gen se, cfmast cf
   where se.custodycd=cf.custodycd
                 and case when tltxcd ='2232' AND field IN ('EMKQTTY','BLOCKED') THEN 1 ELSE 0 END > 0
                 AND SE.busdate = v_fromdate
                 AND SE.custodycd LIKE V_STRPV_CUSTODYCD
                 AND SE.afacctno LIKE V_STRPV_AFACCTNO
                 AND SE.SYMBOL LIKE V_SYMBOL
     order by se.busdate, se.symbol;
   EXCEPTION
   WHEN OTHERS
   THEN

      RETURN;


end SE0047;
/

