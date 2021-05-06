create or replace procedure SE0048(
       PV_REFCURSOR     IN OUT PKG_REPORT.ref_cursor,
       OPT              IN       VARCHAR2,
       BRID             IN       VARCHAR2,
       I_DATE           IN       VARCHAR2,
       PV_CUSTODYCD    IN       VARCHAR2,
       PV_AFACCTNO     IN       VARCHAR2,
       SYMBOL          IN       VARCHAR2

) is
  -- RP: Thong bao giai toa chung khoan

   V_STROPTION        VARCHAR2 (5);
   V_CUSTODYCD VARCHAR2(20);
   V_AFACCTNO VARCHAR2(20);
   V_INBRID        VARCHAR2(4);
   V_STRBRID      VARCHAR2 (50);
   V_SYMBOL        VARCHAR2 (50);

   v_Ondate   date;
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
        V_CUSTODYCD  := PV_CUSTODYCD;
   ELSE
        V_CUSTODYCD  := '%%';
   END IF;

    IF(PV_AFACCTNO <> 'ALL')
   THEN
        V_AFACCTNO  := PV_AFACCTNO;
   ELSE
        V_AFACCTNO := '%%';
   END IF;

   IF(SYMBOL <> 'ALL')THEN
        V_SYMBOL  := SYMBOL;
   ELSE
        V_SYMBOL := '%%';
   END IF;

   v_Ondate := to_date(I_DATE,'dd/MM/rrrr');

  OPEN PV_REFCURSOR
  FOR
  SELECT cf.fullname, cf.idcode, cf.iddate, se.custodycd, se.busdate, se.namt,se.txdesc, SE.symbol,
       (case when se.tradeplace ='002' then 'Sàn HNX'
             when se.tradeplace ='001' then 'Sàn HOSE'
               when se.tradeplace ='005' then 'Sàn UPCOM'
               ELSE ' ' END ) SAN
 FROM vw_setran_gen se, cfmast cf
 WHERE se.custodycd = cf.custodycd AND tltxcd in ('2233') AND field IN ('TRADE','DEPOSIT','MORTAGE')
        and SE.busdate = v_Ondate
        AND SE.custodycd LIKE V_CUSTODYCD
        AND SE.afacctno LIKE V_AFACCTNO
        AND SE.symbol LIKE SYMBOL
    ORDER BY SE.busdate, SE.symbol;


    EXCEPTION
      WHEN OTHERS
        THEN
          RETURN;
end SE0048;
/

