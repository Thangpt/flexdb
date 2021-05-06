create or replace procedure LN0013(
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_BRID         IN       VARCHAR2,
   PV_CAREBY      IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_TLID        IN       VARCHAR2,
   PV_MRTYPE      IN       VARCHAR2,
   PV_AFTYPE      IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2
) is
 V_STROPTION      VARCHAR2 (5);             -- A: ALL; B: BRANCH; S: SUB-BRANCH
 V_STRBRID        VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
 V_INBRID         VARCHAR2 (5);
 V_I_BRID         VARCHAR2 (20);
 V_CAREBY         VARCHAR2 (20);
 V_CUSTODYCD      VARCHAR2 (10);
 V_TYPENAME       VARCHAR2 (200);
 V_TLID           VARCHAR2 (10);
 V_FROMDATE          DATE;
 V_TODATE          DATE;
 l_count          NUMBER;
 v_CurrDate          DATE;
 v_sdate             DATE; -- ngay lam viec truoc from date
 v_emdate            DATE; -- ngay lam viec ke tiep from date
 v_edate             DATE;
 v_emtdate           DATE;
begin
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
    IF(I_BRID <> 'ALL') THEN
     V_I_BRID := I_BRID;
   ELSE
     V_I_BRID := '%';
   END IF;
   IF(PV_CAREBY <> 'ALL') THEN
     V_CAREBY := PV_CAREBY;
   ELSE
     V_CAREBY := '%';
   END IF;
   IF(PV_CUSTODYCD  <> 'ALL') THEN
     V_CUSTODYCD  := PV_CUSTODYCD ;
   ELSE
     V_CUSTODYCD  := '%';
    END IF;
    IF(PV_TLID  <> 'ALL') THEN
     V_TLID  := PV_TLID ;
   ELSE
     V_TLID  := '%';
   END IF;
   IF(PV_AFTYPE  <> 'ALL') THEN
     V_TYPENAME  := PV_AFTYPE ;
   ELSE
     V_TYPENAME  := '%';
   END IF;
    V_FROMDATE :=   TO_DATE(F_DATE,'DD/MM/RRRR');
    V_TODATE :=   TO_DATE(T_DATE,'DD/MM/RRRR');


   SELECT to_date(varvalue,'DD/MM/RRRR') INTO v_CurrDate FROM sysvar WHERE varname = 'CURRDATE' AND grname = 'SYSTEM';

   SELECT CASE WHEN V_TODATE >= v_CurrDate THEN v_CurrDate - V_FROMDATE ELSE V_TODATE - V_FROMDATE +1 END into l_count from dual;

   SELECT min(to_date(sbdate,'DD/MM/RRRR'))  into v_emtdate FROM sbcldr WHERE to_date(sbdate,'DD/MM/RRRR') > V_TODATE AND holiday='N' AND cldrtype='000';

   SELECT max(to_date(sbdate,'DD/MM/RRRR'))  into v_edate FROM sbcldr WHERE to_date(sbdate,'DD/MM/RRRR') <= V_TODATE AND holiday='N' AND cldrtype='000';

   SELECT max(to_date(sbdate,'DD/MM/RRRR'))  into v_sdate FROM sbcldr WHERE to_date(sbdate,'DD/MM/RRRR') <= V_FROMDATE AND holiday='N' AND cldrtype='000';

   SELECT min(to_date(sbdate,'DD/MM/RRRR'))  into v_emdate FROM sbcldr WHERE to_date(sbdate,'DD/MM/RRRR') > V_FROMDATE AND holiday='N' AND cldrtype='000';

OPEN PV_REFCURSOR
FOR
SELECT brname, grpname, odexecamt, mramt, round(mrint/dcount,2) mrint , (case when mramt <> 0 then ROUND(mrint/dcount/mramt*36000,4) else 0 end) mrrate
FROM(
 SELECT br.brname, k.grpname, sum(k.odexecamt) odexecamt,CASE WHEN v_CurrDate< v_emtdate THEN (v_CurrDate - v_sdate) ELSE v_emtdate - v_sdate END  dcount,
           sum(CASE WHEN PV_MRTYPE = 'ALL' THEN (k.mravg + k.mravgtopup + k.advagv)
                WHEN PV_MRTYPE = 'Margin' THEN k.mravg
                WHEN PV_MRTYPE = 'Topup' THEN k.mravgtopup
                WHEN PV_MRTYPE = 'Ứng trước' THEN k.advagv
                ELSE 0 END) mramt,
           sum(CASE WHEN PV_MRTYPE = 'ALL' THEN k.mrint + k.mrinttopup
                WHEN PV_MRTYPE = 'Margin' THEN k.mrint
                WHEN PV_MRTYPE = 'Topup' THEN k.mrinttopup
                ELSE 0 END) mrint
FROM cfmast cf, brgrp br,
(SELECT lg.custodycd, lg.grpid,max(lg.grpname) grpname ,
            sum(CASE WHEN to_date(lg.txdate,'DD/MM/RRRR') < V_FROMDATE THEN 0 ELSE nvl(lg.odexecamt,0) END) odexecamt,
            sum(lg.mrint_beday-lg.t0int_beday) mrint, sum(lg.mrinttopup_beday-lg.t0inttopup_beday) mrinttopup,
            ROUND(sum(
                      CASE WHEN (to_date(lg.txdate,'DD/MM/RRRR')<V_TODATE and to_date(lg.txdate,'DD/MM/RRRR')>V_FROMDATE  and lg.txdate<>v_edate) or (v_CurrDate=V_TODATE) or (v_CurrDate=V_FROMDATE) THEN (lg.mramt-lg.t0amt)*lg.date_count
                           WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_edate and V_TODATE < v_CurrDate   AND v_edate<>v_sdate   THEN (lg.mramt-lg.t0amt)*((V_TODATE-v_edate)+1)
                           WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND V_FROMDATE< v_CurrDate  AND v_edate<>v_sdate   THEN (lg.mramt-lg.t0amt)*(v_emdate-V_FROMDATE)
                           WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND v_edate=v_sdate                                THEN (lg.mramt-lg.t0amt)*((V_TODATE-V_FROMDATE)+1)  END) /l_count
                             ) mravg,
             ROUND(sum(
                      CASE WHEN (to_date(lg.txdate,'DD/MM/RRRR')<V_TODATE and to_date(lg.txdate,'DD/MM/RRRR')>V_FROMDATE  and lg.txdate<>v_edate) or (v_CurrDate=V_TODATE) or (v_CurrDate=V_FROMDATE) THEN (lg.mramttopup-lg.t0amt_bank)*lg.date_count
                           WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_edate and V_TODATE < v_CurrDate   AND v_edate<>v_sdate  THEN (lg.mramttopup-lg.t0amt_bank)*((V_TODATE-v_edate)+1)
                           WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND V_FROMDATE< v_CurrDate  AND v_edate<>v_sdate  THEN (lg.mramttopup-lg.t0amt_bank)*(v_emdate-V_FROMDATE)
                           WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND v_edate=v_sdate                               THEN (lg.mramttopup-lg.t0amt_bank)*((V_TODATE-V_FROMDATE)+1)  END) /l_count
                             ) mravgtopup,
            ROUND(SUM(
                      CASE WHEN (to_date(lg.txdate,'DD/MM/RRRR')<V_TODATE and to_date(lg.txdate,'DD/MM/RRRR')>V_FROMDATE  and lg.txdate<>v_edate) or (v_CurrDate=V_TODATE) or (v_CurrDate=V_FROMDATE) THEN lg.adamt*lg.date_count
                           WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_edate and V_TODATE < v_CurrDate   AND v_edate<>v_sdate   THEN lg.adamt*((V_TODATE-v_edate)+1)
                           WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND V_FROMDATE< v_CurrDate  AND v_edate<>v_sdate   THEN lg.adamt*(v_emdate-V_FROMDATE)
                           WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND v_edate=v_sdate                                THEN lg.adamt*((V_TODATE-V_FROMDATE)+1)  END) /l_count
                             ) advagv
            FROM log_sa0015 lg
            WHERE lg.txdate BETWEEN v_sdate AND V_TODATE
            AND custodycd LIKE V_CUSTODYCD
            AND (CASE WHEN lg.grpid is null THEN '%' ELSE lg.grpid END) LIKE V_CAREBY
            AND (CASE WHEN lg.reid is null THEN '%' ELSE lg.reid END) LIKE V_TLID
            AND aftype IN (SELECT actype FROM aftype WHERE typename LIKE V_TYPENAME)
            GROUP BY lg.custodycd, lg.grpid) k
WHERE k.custodycd = cf.custodycd
AND cf.brid = br.brid
AND br.brid LIKE V_I_BRID
group by br.brname, k.grpname);
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/
