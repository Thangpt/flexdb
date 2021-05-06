CREATE OR REPLACE PROCEDURE sa0008 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   pv_OPT            IN       VARCHAR2,
   pv_BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   PV_RECUSTID    IN       VARCHAR2,
   PV_CUSTODYCD      IN       VARCHAR2,
   PV_GRCAREBY    IN        VARCHAR2,
   PV_NBRID         IN        VARCHAR2
)
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- LINHLNB   11-Apr-2012  CREATED

-- ---------   ------  -------------------------------------------
    V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID     VARCHAR2 (5);
   l_AFACCTNO         VARCHAR2 (20);
   l_MRAMT          number(20,0);
   l_T0AMT          number(20,0);
   l_DFAMT          number(20,0);
   l_BALANCE        number(20,0);
   l_DEPOFEEAMT     number(20,0);
   l_DFODAMT        number(20,0);
   l_AVLADVANCE        number(20,0);
   l_MRCRLIMITMAX          number(20,0);
   l_trfbuyamt_in   number(20,0);
   l_trfbuyamt_over number(20,0);
   l_trfbuyamt_inday number(20,0);
   l_secureamt_inday number(20,0);
   v_IDATE           DATE; --ngay lam viec gan ngay idate nhat
   v_CurrDate        DATE;
   V_TLID           VARCHAR2(4);

   V_RECUSTID           VARCHAR2 (20);
   V_STRCUSTOCYCD           VARCHAR2 (20);
   V_CAREBY         varchar(20);
   V_NBRID            VARCHAR2 (4);


-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
   V_STROPTION := upper(pv_OPT);
   V_INBRID := pv_BRID;

   if(V_STROPTION = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := pv_BRID;
        end if;
    end if;

   IF (PV_NBRID <> 'ALL')
   THEN
      V_NBRID := PV_NBRID;
   ELSE
      V_NBRID := '%';
   END IF;

   IF (PV_CUSTODYCD <> 'ALL')
   THEN
      V_STRCUSTOCYCD := PV_CUSTODYCD;
   ELSE
      V_STRCUSTOCYCD := '%';
   END IF;

   IF (PV_GRCAREBY <> 'ALL')
   THEN
      V_CAREBY := PV_GRCAREBY;
   ELSE
      V_CAREBY:='%';
   END IF;

   IF (PV_RECUSTID <> 'ALL')
   THEN
      V_RECUSTID := PV_RECUSTID;
   ELSE
      V_RECUSTID:='%';
   END IF;

 --  pr_error('MR3007','l_AFACCTNO:'|| l_AFACCTNO);

 -- END OF GETTING REPORT'S PARAMETERS

   SELECT max(sbdate) INTO v_IDATE  FROM sbcurrdate WHERE sbtype ='B' AND sbdate <= to_date(I_DATE,'DD/MM/RRRR');

   select to_date(varvalue,'DD/MM/RRRR') into v_CurrDate from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM';


   IF v_idate <> v_CurrDate THEN
        l_T0AMT:=0;
        l_MRAMT:=0;
        l_DFAMT:=0;
        l_trfbuyamt_in :=0;
       l_trfbuyamt_over:=0;
       l_trfbuyamt_inday:=0;
       l_secureamt_inday:=0;
       l_MRCRLIMITMAX:=0;
       l_BALANCE:=0;
       l_DEPOFEEAMT:=0;
       l_DFODAMT:=0;
       l_AVLADVANCE:=0;
   END IF ;

IF   v_idate = v_CurrDate THEN
-- GET REPORT'S DATA
    OPEN PV_REFCURSOR
        for
    select  main.*
            , nvl(grpautoid,0) grpautoid, nvl(re.fullname,' ') refullname, nvl(re.gfullname,' ') gfullname, re.bridid
            , nvl(lng.t0amt,0) T0AMT, nvl(lng.marginamt,0) MRAMT--, nvl(ln.DFMAT,0) DFAMT
            , ci.balance + nvl(avl.depoamt,0) + nvl(avl.aamt,0) /*+ nvl(adv.amt,0)*/  BALANCE--, nvl(avl.depoamt,0) AVLADVANCE
            , ci.depofeeamt + nvl(adv.amt,0) DEPOFEEAMT--, nvl(ln.DFODAMT,0) DFODAMT
            , to_date(I_DATE,'DD/MM/RRRR') ngay_tra_cuu
            , re.bfullname, tlg.grpname, br.description  -- 1.5.1.3 MSBS-1810
    from
        (
        SELECT sum(v.trade) trade, sum(v.totalreceiving) totalreceiving, sum(v.sellmatchqtty) sellmatchqtty
            , sum(v.totalbuyqtty) totalbuyqtty, sum(v.realass) realass
            , cf.custid, v.afacctno, cf.fullname
            , cf.custodycd, cf.careby
            , sum(case when sb.sectype in ('001', '002', '008', '111', '011') then v.trade + v.totalreceiving - v.sellmatchqtty + v.totalbuyqtty else 0 end) kl_CP_CCQ
            , sum(case when sb.sectype in ('001', '002', '008', '111', '011') then v.realass else 0 end) gt_CP_CCQ
        from vw_mr9004 v, sbsecurities sb, cfmast cf
        where  v.codeid = sb.codeid and v.custodycd = cf.custodycd AND cf.custodycd LIKE V_STRCUSTOCYCD
               AND cf.careby LIKE V_CAREBY
               AND (cf.brid like  V_STRBRID or instr(V_STRBRID,cf.brid) <> 0)
               AND (cf.brid like  V_NBRID or instr(V_NBRID,cf.brid) <> 0)
        group by cf.custid, v.afacctno, cf.fullname, cf.custodycd, cf.careby
        ) main
        LEFT JOIN
        (SELECT grpname,grpid
         FROM TLGROUPS
        ) tlg
        ON main.careby = tlg.grpid
        LEFT JOIN
        (
             SELECT description,brid
             FROM brgrp
        ) br
        ON br.brid LIKE SUBSTR(main.afacctno,1,4)
        left join
        (select * from cimast) ci
        on main.afacctno = ci.acctno
        left join
        ( select nvl(sum(depoamt),0) depoamt, sum(nvl(aamt,0)) aamt,  afacctno
          from v_getaccountavladvance
          group by  afacctno
        ) avl on main.afacctno = avl.afacctno
        left join
        (select nvl(sum(t0amt),0) t0amt, nvl(sum(marginamt),0) marginamt, trfacctno
        from vw_lngroup_all
        group by trfacctno
           ) lng on main.afacctno = lng.trfacctno
        left join
        ( --du no UTTB
         SELECT  ACCTNO
            , SUM(NVL(ADS.AMT, 0) + NVL(ADS.FEEAMT, 0)- (case when v_CurrDate >= ads.cleardt then ads.paidamt else 0 end)) AMT
        FROM   VW_ADSCHD_ALL ADS
        WHERE     (ADS.AMT > 0   OR   ADS.PAIDDATE = v_CurrDate ) --V_CRRDATE
            AND    ADS.txdate     <=   v_CurrDate
        GROUP  BY  ACCTNO
        ) adv
        on main.afacctno = adv.acctno
        inner join
        (
        select to_char(g.autoid) grpautoid, g.fullname, a.afacctno,  cfm.fullname gfullname, substr(g.custid,1,4) bridid, cfb.fullname bfullname
        from recflnk c, recfdef cf, reaflnk a, regrplnk gl, (select * from regrp union all select * from regrphist) g, retype t, cfmast cfm, cfmast cfb
        where substr(a.reacctno,1,10) = c.custid and c.autoid = cf.refrecflnkid and gl.reacctno =  a.reacctno and g.autoid = gl.refrecflnkid
            and substr(a.reacctno,1,10) = c.custid and substr(a.reacctno,11,4) = cf.reactype
            and cfm.custid = g.custid
            and cf.reactype = t.actype and t.rerole in ('BM','RM')
            AND substr(a.reacctno,1,10) = cfb.custid
            AND substr(a.reacctno,1,10) LIKE V_RECUSTID
            and v_idate between cf.effdate and nvl(cf.closedate -1, cf.expdate)
            and v_idate between a.frdate and nvl(a.clstxdate -1, a.todate)
            and v_idate between gl.frdate and nvl(gl.clstxdate -1, a.todate)
            and v_idate between g.effdate and g.expdate
        ) re
        on main.afacctno  = re.afacctno
    ;

ELSE
  -- GET REPORT'S DATA
DELETE FROM SA0008_TEMP_3007;
DELETE FROM   SA0008_TEMP;
INSERT INTO SA0008_TEMP_3007

        select sum(v.trade) trade, sum(v.totalreceiving) totalreceiving, sum(v.sellmatchqtty) sellmatchqtty
            , sum(v.totalbuyqtty) totalbuyqtty, sum(v.realass) realass
            , cf.custid, v.afacctno, cf.fullname, cf.custodycd
            , T0AMT,  MRAMT,  DFAMT, tl.grpname, br.description
            , v.balance + nvl(adv.amt,0) + v.avladvance  /*+ nvl(adv.amt,0)*/  BALANCE
            , AVLADVANCE, v.depofeeamt + nvl(adv.amt,0) DEPOFEEAMT, DFODAMT
            , sum(case when sb.sectype in ('001', '002', '008', '111', '011') then v.trade + v.totalreceiving - v.sellmatchqtty + v.totalbuyqtty else 0 end) kl_CP_CCQ
            , sum(case when sb.sectype in ('001', '002', '008', '111', '011') then v.realass else 0 end) gt_CP_CCQ
            , to_date(I_DATE,'DD/MM/RRRR') ngay_tra_cuu
        from tbl_mr3007_log  v, sbsecurities sb, cfmast cf, TLGROUPS tl, brgrp br
            ,
             ( --du no UTTB
              SELECT  ACCTNO
                 , SUM(NVL(ADS.AMT, 0) + NVL(ADS.FEEAMT, 0)- (case when v_idate >= ads.cleardt then ads.paidamt else 0 end)) AMT
             FROM   VW_ADSCHD_ALL ADS
             WHERE     (ADS.AMT > 0   OR   ADS.PAIDDATE = v_CurrDate ) --V_CRRDATE
                 AND    ADS.txdate     <=   v_idate
             GROUP  BY  ACCTNO
             ) adv
        where txdate = v_idate and v.codeid = sb.codeid and cf.custodycd = v.custodycd and v.afacctno = adv.acctno(+)
               AND cf.custodycd LIKE V_STRCUSTOCYCD AND cf.careby LIKE V_CAREBY AND cf.careby = tl.grpid
               AND br.brid LIKE cf.brid
               AND (cf.brid like  V_STRBRID or instr(V_STRBRID,cf.brid) <> 0)
               AND (cf.brid like  V_NBRID or instr(V_NBRID,cf.brid) <> 0)
        group by cf.custid, v.afacctno, T0AMT,  MRAMT,  DFAMT,  BALANCE, AVLADVANCE, DEPOFEEAMT, DFODAMT,
              nvl(adv.amt,0), cf.fullname, cf.custodycd, tl.grpname, br.description;
 
INSERT INTO SA0008_TEMP
select to_char(g.autoid) grpautoid, g.fullname, a.afacctno, cfm.fullname gfullname,  substr(g.custid,1,4) bridid, cfb.fullname bfullname
  from recflnk c, recfdef cf, reaflnk a, regrplnk gl,(select * from regrp union all select * from regrphist) g, retype t, cfmast cfm, cfmast cfb
  where substr(a.reacctno,1,10) = c.custid and c.autoid = cf.refrecflnkid and gl.reacctno =  a.reacctno and g.autoid = gl.refrecflnkid
      and substr(a.reacctno,1,10) = c.custid and substr(a.reacctno,11,4) = cf.reactype
      and cf.reactype = t.actype and t.rerole in ('BM','RM')
      and cfm.custid = g.custid
      AND substr(a.reacctno,1,10) = cfb.custid
      AND substr(a.reacctno,1,10) LIKE V_RECUSTID
      and v_idate between cf.effdate and nvl(cf.closedate -1, cf.expdate)
      and v_idate between a.frdate and nvl(a.clstxdate -1, a.todate)
      and v_idate between gl.frdate and nvl(gl.clstxdate -1, a.todate)
      and v_idate between g.effdate and g.expdate;


    OPEN PV_REFCURSOR
        for
    select main.*, nvl(grpautoid,0) grpautoid, nvl(re.fullname,' ') refullname , nvl(re.gfullname,' ') gfullname, re.bridid, re.bfullname
    from
        SA0008_TEMP_3007 main
        ,
        SA0008_TEMP re
    where main.afacctno = re.afacctno
    ;

END IF ;


 EXCEPTION
   WHEN OTHERS
   THEN
        RETURN;
END;
/
