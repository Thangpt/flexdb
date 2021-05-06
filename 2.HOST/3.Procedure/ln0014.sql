CREATE OR REPLACE PROCEDURE ln0014 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   BRGID          IN       VARCHAR2,
   PV_TYPE        IN       VARCHAR2,
   GROUPID        IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   OPEN_F_DATE    IN       VARCHAR2,
   OPEN_T_DATE    IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   F_OVERDUEDATE  IN       VARCHAR2,
   T_OVERDUEDATE  IN       VARCHAR2,
   TLID IN VARCHAR2
   )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- BAO CAO REVIEW KHACH HÀN
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- MAI.NGUYENPHUONG   21-NOV-19  CREATED
-- ---------   ------  -------------------------------------------

   V_STROPTION         VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID           VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0

   V_STRBRGID          VARCHAR2 (10);
   V_STRGROUPID        VARCHAR2 (10);

   V_OPENFROMDATE      DATE;
   V_OPENTODATE        DATE;
   V_FROMDATE          DATE;
   V_TODATE            DATE;
   V_CUSTODYCD         VARCHAR2 (20);
   V_DUEFROMDATE       DATE;
   V_DUETODATE         DATE;

   l_count             NUMBER(20);
   l_count_N           NUMBER(20);
   v_CurrDate          DATE;
   v_date              DATE;
   v_sdate             DATE; -- ngay lam viec truoc from date
   v_emdate            DATE; -- ngay lam viec ke tiep from date
   v_edate             DATE;
v_TLID varchar2(4);
BEGIN
   V_STROPTION := OPT;

   IF V_STROPTION = 'A' THEN     -- TOAN HE THONG
      V_STRBRID := '%';
   ELSIF V_STROPTION = 'B' THEN
      V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
   ELSE
      V_STRBRID := BRID;
   END IF;

   IF(BRGID <> 'ALL') THEN
     V_STRBRGID := BRGID;
   ELSE
     V_STRBRGID := '%';
   END IF;

   IF(GROUPID <> 'ALL') THEN
     V_STRGROUPID := GROUPID;
   ELSE
     V_STRGROUPID := '%';
   END IF;

   IF(PV_CUSTODYCD <> 'ALL') THEN
     V_CUSTODYCD := PV_CUSTODYCD;
   ELSE
     V_CUSTODYCD := '%';
   END IF;

   V_OPENFROMDATE  :=    TO_DATE(OPEN_F_DATE,'DD/MM/RRRR');
   V_OPENTODATE    :=    TO_DATE(OPEN_T_DATE,'DD/MM/RRRR');

   V_FROMDATE  :=    TO_DATE(F_DATE,'DD/MM/RRRR');
   V_TODATE    :=    TO_DATE(T_DATE,'DD/MM/RRRR');

   V_DUEFROMDATE  :=    TO_DATE(F_OVERDUEDATE,'DD/MM/RRRR');
   V_DUETODATE    :=    TO_DATE(T_OVERDUEDATE,'DD/MM/RRRR');
   v_TLID := TLID;

   -- ngay hien tai
   SELECT to_date(varvalue,'DD/MM/RRRR') INTO v_CurrDate FROM sysvar WHERE varname = 'CURRDATE' AND grname = 'SYSTEM';
   -- so ngay tu fromdate den todate
   select CASE WHEN V_TODATE   >= v_CurrDate THEN v_CurrDate - V_FROMDATE ELSE V_TODATE   - V_FROMDATE +1 END into l_count from dual;
   -- ngay lam viec gan nhat =< todate
   SELECT max(to_date(sbdate,'DD/MM/RRRR'))  into v_edate FROM sbcldr WHERE to_date(sbdate,'DD/MM/RRRR') <= V_TODATE AND holiday='N' AND cldrtype='000';
   -- ngay lam viec gan nhat =< fromdate
   SELECT max(to_date(sbdate,'DD/MM/RRRR'))  into v_sdate FROM sbcldr WHERE to_date(sbdate,'DD/MM/RRRR') <= V_FROMDATE AND holiday='N' AND cldrtype='000';
   -- ngày lam viec gan nhat > fromdate
   SELECT min(to_date(sbdate,'DD/MM/RRRR'))  into v_emdate FROM sbcldr WHERE to_date(sbdate,'DD/MM/RRRR') > V_FROMDATE AND holiday='N' AND cldrtype='000';

      IF PV_TYPE<>'N' THEN
        OPEN PV_REFCURSOR
          FOR
            SELECT * FROM
                (SELECT lg.custodycd,/*lg.grpid,max(lg.grpname) grname, lg.reid mgid, max(lg.refullname) mgname,*/max(c.fullname) fullname,max(at.typename) typename, lg.afacctno, c.opndate,max(c.brid) brid,max(br.brname) brname,
                      NVL(sum(CASE WHEN to_date(lg.txdate,'DD/MM/RRRR')<V_FROMDATE THEN 0 ELSE lg.odexecamt END),0) odexecamt,
                      (CASE WHEN l_count>=30 THEN  NVL(round(sum(CASE WHEN to_date(lg.txdate,'DD/MM/RRRR')<V_FROMDATE THEN 0 ELSE lg.odexecamt END)*30/l_count),0) ELSE 0 END) turnover,
                      (CASE WHEN SUM(
                                 CASE WHEN ((to_date(lg.txdate,'DD/MM/RRRR')<V_TODATE and to_date(lg.txdate,'DD/MM/RRRR')>V_FROMDATE  and lg.txdate<>v_edate) or (v_CurrDate=V_TODATE) or (v_CurrDate=V_FROMDATE)) and lg.navamt>0 THEN lg.date_count
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_edate and V_TODATE < v_CurrDate   AND v_edate<>v_sdate and lg.navamt>0   THEN (V_TODATE-v_edate)+1
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND V_FROMDATE< v_CurrDate  AND v_edate<>v_sdate and lg.navamt>0   THEN v_emdate-V_FROMDATE
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND v_edate=v_sdate   and lg.navamt>0                              THEN (V_TODATE-V_FROMDATE)+1 ELSE 0  END) <>0
                       THEN NVL(round(sum(
                                CASE WHEN (to_date(lg.txdate,'DD/MM/RRRR')<V_TODATE and to_date(lg.txdate,'DD/MM/RRRR')>V_FROMDATE  and lg.txdate<>v_edate) or (v_CurrDate=V_TODATE) or (v_CurrDate=V_FROMDATE) THEN lg.navamt*lg.date_count
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_edate and V_TODATE < v_CurrDate   AND v_edate<>v_sdate   THEN lg.navamt*((V_TODATE-v_edate)+1)
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND V_FROMDATE< v_CurrDate  AND v_edate<>v_sdate   THEN lg.navamt*(v_emdate-V_FROMDATE)
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND v_edate=v_sdate                                THEN lg.navamt*((V_TODATE-V_FROMDATE)+1)  END)
                                /SUM(
                                 CASE WHEN ((to_date(lg.txdate,'DD/MM/RRRR')<V_TODATE and to_date(lg.txdate,'DD/MM/RRRR')>V_FROMDATE  and lg.txdate<>v_edate) or (v_CurrDate=V_TODATE) or (v_CurrDate=V_FROMDATE)) and lg.navamt>0 THEN lg.date_count
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_edate and V_TODATE < v_CurrDate   AND v_edate<>v_sdate and lg.navamt>0   THEN (V_TODATE-v_edate)+1
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND V_FROMDATE< v_CurrDate  AND v_edate<>v_sdate and lg.navamt>0   THEN v_emdate-V_FROMDATE
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND v_edate=v_sdate   and lg.navamt>0                              THEN (V_TODATE-V_FROMDATE)+1 ELSE 0  END)),0) ELSE 0 END) navamt,
                      NVL(max(ac.advrate),0) advrate,
                      (CASE WHEN SUM(
                                 CASE WHEN ((to_date(lg.txdate,'DD/MM/RRRR')<V_TODATE and to_date(lg.txdate,'DD/MM/RRRR')>V_FROMDATE  and lg.txdate<>v_edate) or (v_CurrDate=V_TODATE) or (v_CurrDate=V_FROMDATE)) and (lg.mramt-lg.t0amt)>0 THEN lg.date_count
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_edate and V_TODATE < v_CurrDate   AND v_edate<>v_sdate and (lg.mramt-lg.t0amt)>0   THEN (V_TODATE-v_edate)+1
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND V_FROMDATE< v_CurrDate  AND v_edate<>v_sdate and (lg.mramt-lg.t0amt)>0   THEN v_emdate-V_FROMDATE
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND v_edate=v_sdate   and (lg.mramt-lg.t0amt)>0                              THEN (V_TODATE-V_FROMDATE)+1 ELSE 0  END) <>0
                       THEN NVL(round(sum(
                                CASE WHEN (to_date(lg.txdate,'DD/MM/RRRR')<V_TODATE and to_date(lg.txdate,'DD/MM/RRRR')>V_FROMDATE  and lg.txdate<>v_edate) or (v_CurrDate=V_TODATE) or (v_CurrDate=V_FROMDATE) THEN (lg.mramt-lg.t0amt)*lg.date_count
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_edate and V_TODATE < v_CurrDate   AND v_edate<>v_sdate   THEN (lg.mramt-lg.t0amt)*((V_TODATE-v_edate)+1)
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND V_FROMDATE< v_CurrDate  AND v_edate<>v_sdate   THEN (lg.mramt-lg.t0amt)*(v_emdate-V_FROMDATE)
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND v_edate=v_sdate                                THEN (lg.mramt-lg.t0amt)*((V_TODATE-V_FROMDATE)+1)  END)
                                /SUM(
                                 CASE WHEN ((to_date(lg.txdate,'DD/MM/RRRR')<V_TODATE and to_date(lg.txdate,'DD/MM/RRRR')>V_FROMDATE  and lg.txdate<>v_edate) or (v_CurrDate=V_TODATE) or (v_CurrDate=V_FROMDATE)) and (lg.mramt-lg.t0amt)>0 THEN lg.date_count
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_edate and V_TODATE < v_CurrDate   AND v_edate<>v_sdate and (lg.mramt-lg.t0amt)>0   THEN (V_TODATE-v_edate)+1
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND V_FROMDATE< v_CurrDate  AND v_edate<>v_sdate and (lg.mramt-lg.t0amt)>0   THEN v_emdate-V_FROMDATE
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND v_edate=v_sdate   and (lg.mramt-lg.t0amt)>0                              THEN (V_TODATE-V_FROMDATE)+1 ELSE 0  END)),0) ELSE 0 END) mravg,
                       (CASE WHEN SUM(
                                 CASE WHEN ((to_date(lg.txdate,'DD/MM/RRRR')<V_TODATE and to_date(lg.txdate,'DD/MM/RRRR')>V_FROMDATE  and lg.txdate<>v_edate) or (v_CurrDate=V_TODATE) or (v_CurrDate=V_FROMDATE)) and (lg.mramttopup-lg.t0amt_bank)>0 THEN lg.date_count
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_edate and V_TODATE < v_CurrDate   AND v_edate<>v_sdate and (lg.mramttopup-lg.t0amt_bank)>0   THEN (V_TODATE-v_edate)+1
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND V_FROMDATE< v_CurrDate  AND v_edate<>v_sdate and (lg.mramttopup-lg.t0amt_bank)>0   THEN v_emdate-V_FROMDATE
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND v_edate=v_sdate   and (lg.mramttopup-lg.t0amt_bank)>0                              THEN (V_TODATE-V_FROMDATE)+1 ELSE 0  END) <>0
                        THEN NVL(round(sum(
                                CASE WHEN (to_date(lg.txdate,'DD/MM/RRRR')<V_TODATE and to_date(lg.txdate,'DD/MM/RRRR')>V_FROMDATE  and lg.txdate<>v_edate) or (v_CurrDate=V_TODATE) or (v_CurrDate=V_FROMDATE) THEN (lg.mramttopup-lg.t0amt_bank)*lg.date_count
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_edate and V_TODATE < v_CurrDate   AND v_edate<>v_sdate  THEN (lg.mramttopup-lg.t0amt_bank)*((V_TODATE-v_edate)+1)
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND V_FROMDATE< v_CurrDate  AND v_edate<>v_sdate  THEN (lg.mramttopup-lg.t0amt_bank)*(v_emdate-V_FROMDATE)
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND v_edate=v_sdate                               THEN (lg.mramttopup-lg.t0amt_bank)*((V_TODATE-V_FROMDATE)+1)  END)
                                /SUM(
                                 CASE WHEN ((to_date(lg.txdate,'DD/MM/RRRR')<V_TODATE and to_date(lg.txdate,'DD/MM/RRRR')>V_FROMDATE  and lg.txdate<>v_edate) or (v_CurrDate=V_TODATE) or (v_CurrDate=V_FROMDATE)) and (lg.mramttopup-lg.t0amt_bank)>0 THEN lg.date_count
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_edate and V_TODATE < v_CurrDate   AND v_edate<>v_sdate and (lg.mramttopup-lg.t0amt_bank)>0   THEN (V_TODATE-v_edate)+1
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND V_FROMDATE< v_CurrDate  AND v_edate<>v_sdate and (lg.mramttopup-lg.t0amt_bank)>0   THEN v_emdate-V_FROMDATE
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND v_edate=v_sdate   and (lg.mramttopup-lg.t0amt_bank)>0                              THEN (V_TODATE-V_FROMDATE)+1 ELSE 0  END)),0) ELSE 0 END) mravgtopup,
                        ----
                        (CASE WHEN sum(
                                 CASE WHEN ((to_date(lg.txdate,'DD/MM/RRRR')<V_TODATE and to_date(lg.txdate,'DD/MM/RRRR')>V_FROMDATE  and lg.txdate<>v_edate) or (v_CurrDate=V_TODATE) or (v_CurrDate=V_FROMDATE)) and (lg.mramt-lg.t0amt)>0 THEN lg.date_count
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_edate and V_TODATE < v_CurrDate   AND v_edate<>v_sdate and (lg.mramt-lg.t0amt)>0    THEN (V_TODATE-v_edate)+1
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND V_FROMDATE< v_CurrDate  AND v_edate<>v_sdate and (lg.mramt-lg.t0amt)>0   THEN v_emdate-V_FROMDATE
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND v_edate=v_sdate   and (lg.mramt-lg.t0amt)>0                              THEN (V_TODATE-V_FROMDATE)+1 ELSE 0  END) <>0
                       THEN sum(
                                 CASE WHEN ((to_date(lg.txdate,'DD/MM/RRRR')<V_TODATE and to_date(lg.txdate,'DD/MM/RRRR')>V_FROMDATE  and lg.txdate<>v_edate) or (v_CurrDate=V_TODATE) or (v_CurrDate=V_FROMDATE)) and (lg.mramt-lg.t0amt)>0  THEN lg.date_count
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_edate and V_TODATE < v_CurrDate   AND v_edate<>v_sdate and (lg.mramt-lg.t0amt)>0    THEN (V_TODATE-v_edate)+1
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND V_FROMDATE< v_CurrDate  AND v_edate<>v_sdate and (lg.mramt-lg.t0amt)>0   THEN v_emdate-V_FROMDATE
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND v_edate=v_sdate   and (lg.mramt-lg.t0amt)>0                             THEN (V_TODATE-V_FROMDATE)+1 ELSE 0  END) ELSE 0 END) MG_day,
                        ---
                        (CASE WHEN sum(
                                 CASE WHEN ((to_date(lg.txdate,'DD/MM/RRRR')<V_TODATE and to_date(lg.txdate,'DD/MM/RRRR')>V_FROMDATE  and lg.txdate<>v_edate) or (v_CurrDate=V_TODATE) or (v_CurrDate=V_FROMDATE)) and  (lg.mramttopup-lg.t0amt_bank)>0 THEN lg.date_count
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_edate and V_TODATE < v_CurrDate   AND v_edate<>v_sdate and  (lg.mramttopup-lg.t0amt_bank)>0   THEN (V_TODATE-v_edate)+1
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND V_FROMDATE< v_CurrDate  AND v_edate<>v_sdate and  (lg.mramttopup-lg.t0amt_bank)>0   THEN v_emdate-V_FROMDATE
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND v_edate=v_sdate   and  (lg.mramttopup-lg.t0amt_bank)>0                             THEN (V_TODATE-V_FROMDATE)+1 ELSE 0  END) <>0
                       THEN sum(
                                 CASE WHEN ((to_date(lg.txdate,'DD/MM/RRRR')<V_TODATE and to_date(lg.txdate,'DD/MM/RRRR')>V_FROMDATE  and lg.txdate<>v_edate) or (v_CurrDate=V_TODATE) or (v_CurrDate=V_FROMDATE)) and  (lg.mramttopup-lg.t0amt_bank)>0 THEN lg.date_count
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_edate and V_TODATE < v_CurrDate   AND v_edate<>v_sdate and  (lg.mramttopup-lg.t0amt_bank)>0   THEN (V_TODATE-v_edate)+1
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND V_FROMDATE< v_CurrDate  AND v_edate<>v_sdate and  (lg.mramttopup-lg.t0amt_bank)>0   THEN v_emdate-V_FROMDATE
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND v_edate=v_sdate   and  (lg.mramttopup-lg.t0amt_bank)>0                              THEN (V_TODATE-V_FROMDATE)+1 ELSE 0  END) ELSE 0 END) top_day,
                      NVL(round(sum(lg.adamt)/l_count),0) advagv,
                      NVL(sum(CASE WHEN to_date(lg.txdate,'DD/MM/RRRR')<V_FROMDATE THEN 0 ELSE lg.odfeeamt END),0) odfeeamt,
                      l_count count_d
                  FROM log_sa0015 lg, cfmast c, afmast af, adtype ac,AFDBNAVGRP av, aftype at, brgrp br
                  WHERE  lg.afacctno=af.acctno and af.custid=c.custid
                  AND at.adtype = ac.actype
                  AND av.afacctno=lg.afacctno AND af.actype=at.actype and c.brid=br.brid
                  AND lg.txdate BETWEEN v_sdate AND V_TODATE
                  AND av.refactype like V_STRGROUPID
                  AND c.opndate BETWEEN V_OPENFROMDATE AND V_OPENTODATE
                  AND c.brid LIKE V_STRBRGID
                   and  exists (select gu.grpid from tlgrpusers gu where af.careby = gu.grpid and gu.tlid = v_TLID )
                  GROUP BY lg.custodycd, lg.afacctno, c.opndate/*,lg.grpid, lg.reid*/) SA0015,
           (SELECT lm.trfacctno,ln.nml+ln.ovd nml,ln.rlsdate, ln.overduedate,lm.actype,ln.rate2 lnrate
              FROM  vw_lnschd_all ln, vw_lnmast_all lm
              WHERE ln.acctno=lm.acctno
              AND ln.reftype  in ('P')
              AND ln.overduedate between V_DUEFROMDATE and V_DUETODATE) LNS,
            (SELECT re.afacctno acctno,recf.custid mgid, cf.fullname mgname, rg.fullname grname,rg.autoid grpid
              from reaflnk re, retype ret, recflnk recf, cfmast cf, regrp rg, regrplnk rgk
                where re.refrecflnkid=recf.autoid and substr(re.reacctno,11,4)=ret.actype
                and ret.rerole='BM' and re.status='A' and rgk.status='A'
                and recf.custid=cf.custid and rg.autoid=rgk.refrecflnkid and rgk.reacctno=re.reacctno
                and cf.brid like V_STRBRGID
                --and to_date('29/05/2018','DD/MM/RRRR') between recf.effdate AND recf.expdate
                --and to_date('29/05/2018','DD/MM/RRRR')  between re.frdate AND re.todate
             ) b
         WHERE LNS.trfacctno=SA0015.afacctno
         AND SA0015.afacctno=b.acctno(+)
         ORDER BY b.mgname,b.grname,SA0015.fullname,SA0015.brname,SA0015.afacctno
          ;
      ELSE
        OPEN PV_REFCURSOR
          FOR
            SELECT * FROM
              (SELECT lg.custodycd,/*lg.grpid,max(lg.grpname) grname, lg.reid mgid, max(lg.refullname) mgname,*/max(c.fullname) fullname,max(at.typename) typename,lg.afacctno, c.opndate,max(c.brid) brid,max(br.brname) brname,
                      NVL(sum(CASE WHEN to_date(lg.txdate,'DD/MM/RRRR')<V_FROMDATE THEN 0 ELSE lg.odexecamt END),0) odexecamt,
                      (CASE WHEN l_count>=30 THEN  NVL(round(sum(CASE WHEN to_date(lg.txdate,'DD/MM/RRRR')<V_FROMDATE THEN 0 ELSE lg.odexecamt END)*30/l_count),0) ELSE 0 END) turnover,
                      (CASE WHEN SUM(
                                 CASE WHEN ((to_date(lg.txdate,'DD/MM/RRRR')<V_TODATE and to_date(lg.txdate,'DD/MM/RRRR')>V_FROMDATE  and lg.txdate<>v_edate) or (v_CurrDate=V_TODATE) or (v_CurrDate=V_FROMDATE)) and lg.navamt>0 THEN lg.date_count
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_edate and V_TODATE < v_CurrDate   AND v_edate<>v_sdate and lg.navamt>0   THEN (V_TODATE-v_edate)+1
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND V_FROMDATE< v_CurrDate  AND v_edate<>v_sdate and lg.navamt>0   THEN v_emdate-V_FROMDATE
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND v_edate=v_sdate   and lg.navamt>0                              THEN (V_TODATE-V_FROMDATE)+1 ELSE 0  END) <>0
                       THEN NVL(round(sum(
                                CASE WHEN (to_date(lg.txdate,'DD/MM/RRRR')<V_TODATE and to_date(lg.txdate,'DD/MM/RRRR')>V_FROMDATE  and lg.txdate<>v_edate) or (v_CurrDate=V_TODATE) or (v_CurrDate=V_FROMDATE) THEN lg.navamt*lg.date_count
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_edate and V_TODATE < v_CurrDate   AND v_edate<>v_sdate   THEN lg.navamt*((V_TODATE-v_edate)+1)
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND V_FROMDATE< v_CurrDate  AND v_edate<>v_sdate   THEN lg.navamt*(v_emdate-V_FROMDATE)
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND v_edate=v_sdate                                THEN lg.navamt*((V_TODATE-V_FROMDATE)+1)  END)
                                /SUM(
                                 CASE WHEN ((to_date(lg.txdate,'DD/MM/RRRR')<V_TODATE and to_date(lg.txdate,'DD/MM/RRRR')>V_FROMDATE  and lg.txdate<>v_edate) or (v_CurrDate=V_TODATE) or (v_CurrDate=V_FROMDATE)) and lg.navamt>0 THEN lg.date_count
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_edate and V_TODATE < v_CurrDate   AND v_edate<>v_sdate and lg.navamt>0   THEN (V_TODATE-v_edate)+1
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND V_FROMDATE< v_CurrDate  AND v_edate<>v_sdate and lg.navamt>0   THEN v_emdate-V_FROMDATE
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND v_edate=v_sdate   and lg.navamt>0                              THEN (V_TODATE-V_FROMDATE)+1 ELSE 0  END)),0) ELSE 0 END) navamt,
                      NVL(max(ac.advrate),0) advrate,
                      (CASE WHEN SUM(
                                 CASE WHEN ((to_date(lg.txdate,'DD/MM/RRRR')<V_TODATE and to_date(lg.txdate,'DD/MM/RRRR')>V_FROMDATE  and lg.txdate<>v_edate) or (v_CurrDate=V_TODATE) or (v_CurrDate=V_FROMDATE)) and (lg.mramt-lg.t0amt)>0 THEN lg.date_count
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_edate and V_TODATE < v_CurrDate   AND v_edate<>v_sdate and (lg.mramt-lg.t0amt)>0   THEN (V_TODATE-v_edate)+1
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND V_FROMDATE< v_CurrDate  AND v_edate<>v_sdate and (lg.mramt-lg.t0amt)>0   THEN v_emdate-V_FROMDATE
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND v_edate=v_sdate   and (lg.mramt-lg.t0amt)>0                              THEN (V_TODATE-V_FROMDATE)+1 ELSE 0  END) <>0
                       THEN NVL(round(sum(
                                CASE WHEN (to_date(lg.txdate,'DD/MM/RRRR')<V_TODATE and to_date(lg.txdate,'DD/MM/RRRR')>V_FROMDATE  and lg.txdate<>v_edate) or (v_CurrDate=V_TODATE) or (v_CurrDate=V_FROMDATE) THEN (lg.mramt-lg.t0amt)*lg.date_count
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_edate and V_TODATE < v_CurrDate   AND v_edate<>v_sdate   THEN (lg.mramt-lg.t0amt)*((V_TODATE-v_edate)+1)
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND V_FROMDATE< v_CurrDate  AND v_edate<>v_sdate   THEN (lg.mramt-lg.t0amt)*(v_emdate-V_FROMDATE)
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND v_edate=v_sdate                                THEN (lg.mramt-lg.t0amt)*((V_TODATE-V_FROMDATE)+1)  END)
                                /SUM(
                                 CASE WHEN ((to_date(lg.txdate,'DD/MM/RRRR')<V_TODATE and to_date(lg.txdate,'DD/MM/RRRR')>V_FROMDATE  and lg.txdate<>v_edate) or (v_CurrDate=V_TODATE) or (v_CurrDate=V_FROMDATE)) and (lg.mramt-lg.t0amt)>0 THEN lg.date_count
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_edate and V_TODATE < v_CurrDate   AND v_edate<>v_sdate and (lg.mramt-lg.t0amt)>0   THEN (V_TODATE-v_edate)+1
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND V_FROMDATE< v_CurrDate  AND v_edate<>v_sdate and (lg.mramt-lg.t0amt)>0   THEN v_emdate-V_FROMDATE
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND v_edate=v_sdate   and (lg.mramt-lg.t0amt)>0                              THEN (V_TODATE-V_FROMDATE)+1 ELSE 0  END)),0) ELSE 0 END) mravg,
                       (CASE WHEN SUM(
                                 CASE WHEN ((to_date(lg.txdate,'DD/MM/RRRR')<V_TODATE and to_date(lg.txdate,'DD/MM/RRRR')>V_FROMDATE  and lg.txdate<>v_edate) or (v_CurrDate=V_TODATE) or (v_CurrDate=V_FROMDATE)) and (lg.mramttopup-lg.t0amt_bank)>0 THEN lg.date_count
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_edate and V_TODATE < v_CurrDate   AND v_edate<>v_sdate and (lg.mramttopup-lg.t0amt_bank)>0   THEN (V_TODATE-v_edate)+1
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND V_FROMDATE< v_CurrDate  AND v_edate<>v_sdate and (lg.mramttopup-lg.t0amt_bank)>0   THEN v_emdate-V_FROMDATE
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND v_edate=v_sdate   and (lg.mramttopup-lg.t0amt_bank)>0                              THEN (V_TODATE-V_FROMDATE)+1 ELSE 0  END) <>0
                        THEN NVL(round(sum(
                                CASE WHEN (to_date(lg.txdate,'DD/MM/RRRR')<V_TODATE and to_date(lg.txdate,'DD/MM/RRRR')>V_FROMDATE  and lg.txdate<>v_edate) or (v_CurrDate=V_TODATE) or (v_CurrDate=V_FROMDATE) THEN (lg.mramttopup-lg.t0amt_bank)*lg.date_count
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_edate and V_TODATE < v_CurrDate   AND v_edate<>v_sdate  THEN (lg.mramttopup-lg.t0amt_bank)*((V_TODATE-v_edate)+1)
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND V_FROMDATE< v_CurrDate  AND v_edate<>v_sdate  THEN (lg.mramttopup-lg.t0amt_bank)*(v_emdate-V_FROMDATE)
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND v_edate=v_sdate                               THEN (lg.mramttopup-lg.t0amt_bank)*((V_TODATE-V_FROMDATE)+1)  END)
                                /SUM(
                                 CASE WHEN ((to_date(lg.txdate,'DD/MM/RRRR')<V_TODATE and to_date(lg.txdate,'DD/MM/RRRR')>V_FROMDATE  and lg.txdate<>v_edate) or (v_CurrDate=V_TODATE) or (v_CurrDate=V_FROMDATE)) and (lg.mramttopup-lg.t0amt_bank)>0 THEN lg.date_count
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_edate and V_TODATE < v_CurrDate   AND v_edate<>v_sdate and (lg.mramttopup-lg.t0amt_bank)>0   THEN (V_TODATE-v_edate)+1
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND V_FROMDATE< v_CurrDate  AND v_edate<>v_sdate and (lg.mramttopup-lg.t0amt_bank)>0   THEN v_emdate-V_FROMDATE
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND v_edate=v_sdate   and (lg.mramttopup-lg.t0amt_bank)>0                              THEN (V_TODATE-V_FROMDATE)+1 ELSE 0  END)),0) ELSE 0 END) mravgtopup,
                      ---
                      (CASE WHEN sum(
                                 CASE WHEN ((to_date(lg.txdate,'DD/MM/RRRR')<V_TODATE and to_date(lg.txdate,'DD/MM/RRRR')>V_FROMDATE  and lg.txdate<>v_edate) or (v_CurrDate=V_TODATE) or (v_CurrDate=V_FROMDATE)) and (lg.mramt-lg.t0amt)>0 THEN lg.date_count
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_edate and V_TODATE < v_CurrDate   AND v_edate<>v_sdate and (lg.mramt-lg.t0amt)>0    THEN (V_TODATE-v_edate)+1
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND V_FROMDATE< v_CurrDate  AND v_edate<>v_sdate and (lg.mramt-lg.t0amt)>0   THEN v_emdate-V_FROMDATE
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND v_edate=v_sdate   and (lg.mramt-lg.t0amt)>0                              THEN (V_TODATE-V_FROMDATE)+1 ELSE 0  END) <>0
                       THEN sum(
                                 CASE WHEN ((to_date(lg.txdate,'DD/MM/RRRR')<V_TODATE and to_date(lg.txdate,'DD/MM/RRRR')>V_FROMDATE  and lg.txdate<>v_edate) or (v_CurrDate=V_TODATE) or (v_CurrDate=V_FROMDATE)) and (lg.mramt-lg.t0amt)>0  THEN lg.date_count
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_edate and V_TODATE < v_CurrDate   AND v_edate<>v_sdate and (lg.mramt-lg.t0amt)>0    THEN (V_TODATE-v_edate)+1
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND V_FROMDATE< v_CurrDate  AND v_edate<>v_sdate and (lg.mramt-lg.t0amt)>0   THEN v_emdate-V_FROMDATE
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND v_edate=v_sdate   and (lg.mramt-lg.t0amt)>0                             THEN (V_TODATE-V_FROMDATE)+1 ELSE 0  END) ELSE 0 END) MG_day,
                        ---
                        (CASE WHEN sum(
                                 CASE WHEN ((to_date(lg.txdate,'DD/MM/RRRR')<V_TODATE and to_date(lg.txdate,'DD/MM/RRRR')>V_FROMDATE  and lg.txdate<>v_edate) or (v_CurrDate=V_TODATE) or (v_CurrDate=V_FROMDATE)) and  (lg.mramttopup-lg.t0amt_bank)>0 THEN lg.date_count
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_edate and V_TODATE < v_CurrDate   AND v_edate<>v_sdate and  (lg.mramttopup-lg.t0amt_bank)>0   THEN (V_TODATE-v_edate)+1
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND V_FROMDATE< v_CurrDate  AND v_edate<>v_sdate and  (lg.mramttopup-lg.t0amt_bank)>0   THEN v_emdate-V_FROMDATE
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND v_edate=v_sdate   and  (lg.mramttopup-lg.t0amt_bank)>0                             THEN (V_TODATE-V_FROMDATE)+1 ELSE 0  END) <>0
                       THEN sum(
                                 CASE WHEN ((to_date(lg.txdate,'DD/MM/RRRR')<V_TODATE and to_date(lg.txdate,'DD/MM/RRRR')>V_FROMDATE  and lg.txdate<>v_edate) or (v_CurrDate=V_TODATE) or (v_CurrDate=V_FROMDATE)) and  (lg.mramttopup-lg.t0amt_bank)>0 THEN lg.date_count
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_edate and V_TODATE < v_CurrDate   AND v_edate<>v_sdate and  (lg.mramttopup-lg.t0amt_bank)>0   THEN (V_TODATE-v_edate)+1
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND V_FROMDATE< v_CurrDate  AND v_edate<>v_sdate and  (lg.mramttopup-lg.t0amt_bank)>0   THEN v_emdate-V_FROMDATE
                                     WHEN to_date(lg.txdate,'DD/MM/RRRR')=v_sdate AND v_edate=v_sdate   and  (lg.mramttopup-lg.t0amt_bank)>0                              THEN (V_TODATE-V_FROMDATE)+1 ELSE 0  END) ELSE 0 END) top_day,
                      NVL(round(sum(lg.adamt)/l_count),0) advagv,
                      NVL(sum(CASE WHEN to_date(lg.txdate,'DD/MM/RRRR')<V_FROMDATE THEN 0 ELSE lg.odfeeamt END),0) odfeeamt,
                      l_count count_d
                  FROM log_sa0015 lg, cfmast c, afmast af, adtype ac, aftype at, brgrp br
                  WHERE  lg.afacctno=af.acctno and af.custid=c.custid
                  AND at.adtype = ac.actype
                  AND af.actype=at.actype and c.brid=br.brid
                  AND lg.txdate BETWEEN v_sdate AND V_TODATE
                  AND c.custodycd like V_CUSTODYCD
                  AND c.opndate BETWEEN V_OPENFROMDATE AND V_OPENTODATE
                  AND c.brid LIKE V_STRBRGID
                   and  exists (select gu.grpid from tlgrpusers gu where af.careby = gu.grpid and gu.tlid = v_TLID )
                  GROUP BY lg.custodycd, lg.afacctno, c.opndate/*,lg.grpid, lg.reid*/) SA0015,
           (SELECT lm.trfacctno,ln.nml+ln.ovd nml,ln.rlsdate, ln.overduedate,lm.actype, ln.rate2 lnrate
              FROM  vw_lnschd_all ln, vw_lnmast_all lm
              WHERE ln.acctno=lm.acctno
              AND ln.reftype  in ('P')
              AND ln.overduedate between V_DUEFROMDATE and V_DUETODATE) LNS,
           (SELECT re.afacctno acctno,recf.custid mgid, cf.fullname mgname, rg.fullname grname,rg.autoid grpid
              from reaflnk re, retype ret, recflnk recf, cfmast cf, regrp rg, regrplnk rgk
                where re.refrecflnkid=recf.autoid and substr(re.reacctno,11,4)=ret.actype
                and ret.rerole='BM' and re.status='A' and rgk.status='A'
                and recf.custid=cf.custid and rg.autoid=rgk.refrecflnkid and rgk.reacctno=re.reacctno
                and cf.brid like V_STRBRGID
             ) b
         WHERE LNS.trfacctno=SA0015.afacctno
         AND SA0015.afacctno=b.acctno(+)
         ORDER BY b.mgname,b.grname,SA0015.fullname,SA0015.brname,SA0015.afacctno
          ;
      END IF;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
-- PROCEDURE
/
