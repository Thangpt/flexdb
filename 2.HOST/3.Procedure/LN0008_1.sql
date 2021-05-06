CREATE OR REPLACE PROCEDURE LN0008_1 (
    PV_REFCURSOR            IN OUT   PKG_REPORT.REF_CURSOR,
    OPT                     IN       VARCHAR2,
    BRID                    IN       VARCHAR2,
    I_BRID                  IN       VARCHAR2,
    CAREBY                  IN       VARCHAR2,
    TLID                    IN       VARCHAR2,
    --CUSTID                  IN       VARCHAR2,
    PV_CUSTODYCD            IN       VARCHAR2,
    AMTTYP                  IN       VARCHAR2,
    ACTYPE                  IN       VARCHAR2,
    F_DATE                  IN       VARCHAR2,
    T_DATE                  IN       VARCHAR2
  )
IS
   V_STROPTION              VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID                VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID                 VARCHAR2(5);

   V_I_BRID              VARCHAR(20);
   V_TLID                VARCHAR(20);
   --V_CUSTID              varchar(20);
   V_CUSTODYCD           varchar(20);
   V_AMTTYP              varchar(20);
   V_ACTYPE              varchar(20);
   V_CAREBY              varchar(20);
   V_FDATE               DATE;
   V_TDATE               DATE;
   --V_COUNTTX             NUMBER;
   V_CURRENT             DATE;
   V_EDATE               DATE;
   V_EMDATE              DATE;
   V_SDATE               DATE;
   V_COUNT               NUMBER;
BEGIN
   V_STROPTION := UPPER(OPT);
   V_INBRID := BRID;
   V_AMTTYP := AMTTYP;
   if(V_STROPTION = 'A') then
        V_STRBRID := '%';
    else
    if(V_STROPTION = 'B') then
     select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
    else
        V_STRBRID := BRID;
    end if;
    END IF;

    IF(I_BRID = 'ALL') THEN
       V_I_BRID := '%';
    ELSE
       V_I_BRID := I_BRID;
    END IF;

    IF (CAREBY = 'ALL') THEN
      V_CAREBY := '%';
    ELSE
      V_CAREBY := CAREBY;
    END IF;

--    IF (CUSTID = 'ALL') THEN
--       V_CUSTID := '%';
--    ELSE
--       V_CUSTID := CUSTID;
--    END IF;
    IF (TLID = 'ALL') THEN
      V_TLID := '%';
    ELSE
      V_TLID := TLID;
    END IF;

    if (PV_CUSTODYCD = 'ALL') then
        V_CUSTODYCD:= '%';
    else
        V_CUSTODYCD:= PV_CUSTODYCD;
    end IF;

    IF (ACTYPE = 'ALL') THEN
      V_ACTYPE := '%';
    ELSE
      V_ACTYPE := upper(ACTYPE);
    END IF;

    V_FDATE   := TO_DATE(F_DATE, 'DD/MM/RRRR');
    V_TDATE   := TO_DATE(T_DATE, 'DD/MM/RRRR');

    SELECT TO_DATE(VARVALUE,'DD/MM/RRRR') INTO V_CURRENT FROM SYSVAR WHERE VARNAME='CURRDATE' AND GRNAME='SYSTEM';

    IF V_TDATE >= V_CURRENT THEN
         SELECT V_CURRENT - V_FDATE INTO V_COUNT FROM DUAL;
    ELSE
         SELECT V_TDATE - V_FDATE +1 INTO V_COUNT FROM DUAL;
    END IF;


   SELECT max(to_date(sbdate,'DD/MM/RRRR'))  into v_edate FROM sbcldr WHERE to_date(sbdate,'DD/MM/RRRR') <= V_TDATE AND holiday='N' AND cldrtype='000';

   SELECT max(to_date(sbdate,'DD/MM/RRRR'))  into v_sdate FROM sbcldr WHERE to_date(sbdate,'DD/MM/RRRR') <= V_FDATE AND holiday='N' AND cldrtype='000';

   SELECT min(to_date(sbdate,'DD/MM/RRRR'))  into v_emdate FROM sbcldr WHERE to_date(sbdate,'DD/MM/RRRR') > V_FDATE AND holiday='N' AND cldrtype='000';

OPEN PV_REFCURSOR
FOR
      SELECT V_COUNT cnt, a.brname, a.grpname, a.reid, a.refullname, a.custodycd, a.txdate, a.mramt, a.mrint, (case a.amt when 0 then 0 else round(a.mrint*36000/a.amt,2) end) mrrate, a.amt,a.dcount, b.mrint_re,a.fullname
          FROM(
          SELECT br.brname,ma.grpid, ma.grpname,ma.reid,ma.refullname, ma.custodycd, ma.txdate,ma.dcount,cf.fullname,
                 (CASE V_AMTTYP
                    WHEN '000' THEN ma.am
                    when '001' then ma.amtopup
                    when '002' then ma.ad
                    else ma.am+ma.amtopup+ma.ad
                  end) mramt,
                  (case V_AMTTYP
                    when '000' then ma.mrint
                    when '001' then ma.mrinttopup
                    when '002' then 0
                    else ma.mrint+ma.mrinttopup
                   end) mrint ,
                  (case V_AMTTYP
                    when '000' then ma.mramt
                    when '001' then ma.mramttopup
                    when '002' then ma.adamt
                    else ma.mramt+ma.mramttopup+ma.adamt
                   end) amt
          FROM cfmast cf, brgrp br,
               (SELECT sa.custodycd, sa.grpid, max(sa.grpname) grpname, sa.reid, max(sa.refullname) refullname, sa.txdate,sum(sa.mramt-sa.t0amt) mramt,sum(sa.mramttopup-sa.t0amt_bank) mramttopup,sum(sa.adamt) adamt,sum(sa.mrint_beday-sa.t0int_beday) mrint,sum(sa.mrinttopup_beday-sa.t0inttopup_beday) mrinttopup,max(sa.date_count) dcount,
               round(sum(CASE WHEN (to_date(sa.txdate,'DD/MM/RRRR')<V_TDATE and to_date(sa.txdate,'DD/MM/RRRR')>V_FDATE  and sa.txdate<>v_edate) or (V_CURRENT=V_TDATE) or (V_CURRENT=V_FDATE) THEN (sa.mramt-sa.t0amt)*sa.date_count
                     WHEN (to_date(sa.txdate,'DD/MM/RRRR')=v_edate and V_TDATE < V_CURRENT   AND v_edate<>v_sdate)   THEN (sa.mramt-sa.t0amt)*(V_TDATE-v_edate+1)
                     WHEN (to_date(sa.txdate,'DD/MM/RRRR')=v_sdate AND V_FDATE< V_CURRENT  AND v_edate<>v_sdate)   THEN (sa.mramt-sa.t0amt)*(v_emdate-V_FDATE)
                     WHEN (to_date(sa.txdate,'DD/MM/RRRR')=v_sdate AND v_edate=v_sdate) THEN (sa.mramt-sa.t0amt)*((V_TDATE-V_FDATE)+1)
                     END
                 )/V_COUNT,4)am,

               round(sum(CASE WHEN (to_date(sa.txdate,'DD/MM/RRRR')<V_TDATE and to_date(sa.txdate,'DD/MM/RRRR')>V_FDATE  and sa.txdate<>v_edate) or (V_CURRENT=V_TDATE) or (V_CURRENT=V_FDATE) THEN (sa.mramttopup-sa.t0amt_bank)*sa.date_count
                     WHEN to_date(sa.txdate,'DD/MM/RRRR')=v_edate and V_TDATE < V_CURRENT   AND v_edate<>v_sdate   THEN (sa.mramttopup-sa.t0amt_bank)*((V_TDATE-v_edate)+1)
                     WHEN to_date(sa.txdate,'DD/MM/RRRR')=v_sdate AND V_FDATE< V_CURRENT  AND v_edate<>v_sdate   THEN (sa.mramttopup-sa.t0amt_bank)*(v_emdate-V_FDATE)
                     WHEN to_date(sa.txdate,'DD/MM/RRRR')=v_sdate AND v_edate=v_sdate THEN (sa.mramttopup-sa.t0amt_bank)*((V_TDATE-V_FDATE)+1)
                END
                )/V_COUNT,4) amtopup,

                round(sum(CASE WHEN (to_date(sa.txdate,'DD/MM/RRRR')<V_TDATE and to_date(sa.txdate,'DD/MM/RRRR')>V_FDATE  and sa.txdate<>v_edate) or (V_CURRENT=V_TDATE) or (V_CURRENT=V_FDATE) THEN sa.adamt*sa.date_count
                      WHEN to_date(sa.txdate,'DD/MM/RRRR')=v_edate and V_TDATE < V_CURRENT   AND v_edate<>v_sdate   THEN sa.adamt*((V_TDATE-v_edate)+1)
                      WHEN to_date(sa.txdate,'DD/MM/RRRR')=v_sdate AND V_FDATE< V_CURRENT  AND v_edate<>v_sdate   THEN sa.adamt*(v_emdate-V_FDATE)
                      WHEN to_date(sa.txdate,'DD/MM/RRRR')=v_sdate AND v_edate=v_sdate THEN sa.adamt*((V_TDATE-V_FDATE)+1)
                 END
                 )/V_COUNT,4) ad
                FROM log_sa0015 sa
                WHERE sa.txdate between v_sdate and V_TDATE
                AND sa.custodycd LIKE V_CUSTODYCD
                AND (CASE WHEN sa.grpid is null THEN '%' ELSE sa.grpid END) LIKE V_CAREBY
                AND (CASE WHEN sa.reid is null THEN '%' ELSE sa.reid END) LIKE V_TLID
                AND sa.aftype IN (SELECT actype FROM aftype WHERE upper(typename) LIKE V_ACTYPE)
                GROUP BY  sa.custodycd, sa.grpid, sa.reid, sa.txdate
                ) ma
          WHERE ma.custodycd = cf.custodycd
                AND cf.brid = br.brid
                AND br.brid LIKE V_I_BRID
          ORDER BY br.brname,ma.grpname,ma.refullname,cf.fullname,ma.txdate) a,
          (select grpid,reid,sum(mrint) mrint_re
             FROM
                (select ma.custodycd,ma.grpid,ma.reid,
                   round(sum(case V_AMTTYP
                            when '000' then ma.mrint
                            when '001' then ma.mrinttopup
                            when '002' then 0
                            else ma.mrint+ma.mrinttopup
                           end)/sum(ma.dcount),2) mrint
               FROM cfmast cf, brgrp br, (SELECT sa.custodycd, sa.grpid, sa.reid,sa.txdate,sum(sa.mrint_beday-sa.t0int_beday) mrint,sum(sa.mrinttopup_beday-sa.t0inttopup_beday) mrinttopup, max(sa.date_count) dcount
                    FROM log_sa0015 sa
                    WHERE sa.txdate between v_sdate and V_TDATE
                    AND sa.custodycd LIKE V_CUSTODYCD
                    AND (CASE WHEN sa.grpid is null THEN '%' ELSE sa.grpid END) LIKE V_CAREBY
                    AND (CASE WHEN sa.reid is null THEN '%' ELSE sa.reid END) LIKE V_TLID
                    AND sa.aftype IN (SELECT actype FROM aftype WHERE upper(typename) LIKE V_ACTYPE)
                    GROUP BY  sa.custodycd, sa.grpid, sa.reid,sa.txdate) ma
                 WHERE ma.custodycd = cf.custodycd
                    AND cf.brid = br.brid
                    AND br.brid LIKE V_I_BRID
               GROUP BY ma.custodycd,ma.grpid,ma.reid)
           GROUP BY grpid,reid) b
           WHERE case when a.reid is null then 'A' else a.reid end =case when b.reid is null then 'A' else b.reid end
           and case when a.grpid is null then 'A' else a.grpid end =case when b.grpid is null then 'A' else b.grpid end
                 AND a.mramt + a.mrint >0
      ;
EXCEPTION
  WHEN OTHERS
  THEN
    RETURN;
END;
/
