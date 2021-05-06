CREATE OR REPLACE PROCEDURE mr0016(
   PV_REFCURSOR      IN OUT   PKG_REPORT.REF_CURSOR,
   PV_OPT            IN       VARCHAR2,
   PV_BRID           IN       VARCHAR2,
   I_DATE            IN       VARCHAR2,
   PV_SYMBOL         IN       VARCHAR2,
   pv_CUSTODYCD       IN       VARCHAR2,
   pv_AFACCTNO       IN       VARCHAR2,
   P_REID            IN       VARCHAR2,
   P_BRGRP           IN       VARCHAR2,
   PV_TLID           IN       VARCHAR2

) is
    -- ---------   ------  -------------------------------------------
    V_STROPTION        VARCHAR2 (5);         -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID          VARCHAR2 (40);        -- USED WHEN V_NUMOPTION > 0
    V_INBRID           VARCHAR2 (4);
   v_IDATE           DATE; --ngay lam viec gan ngay idate nhat
   v_CurrDate        DATE;
   V_TLID           VARCHAR2(4);
   V_REID           VARCHAR2(20);
   V_CUSTODYCD      VARCHAR2(20);
   V_AFACCTNO       VARCHAR2(20);
   v_brgrp          varchar2(10);
   v_symbol         varchar2(20);


-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN


   V_STROPTION := PV_OPT;

   IF (v_STROPTION <> 'A') AND (pv_BRID <> 'ALL')
   THEN
      V_STRBRID := pv_BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;
-------------------

   IF (P_BRGRP<>'ALL')
     THEN
       v_brgrp:=P_BRGRP;
   ELSE
     v_brgrp:='%';
     END IF;
-------------------
   V_TLID := PV_TLID;
-------------------
IF (pv_CUSTODYCD <> 'ALL')
    THEN
       v_custodycd:=pv_CUSTODYCD;
   ELSE
       v_custodycd:='%';
   END IF;
-------------------
   IF (P_REID<>'ALL')
     THEN
       v_reid:=P_REID;
   ELSE
         v_reid:='%';
   END IF;
--------------------
   IF (PV_SYMBOL<>'ALL')
     THEN
       v_symbol:= REPLACE(PV_SYMBOL,' ','_');
   ELSE
         v_symbol:='%';
   END IF;
---------------------
   --V_AFACCTNO  := replace(pv_AFACCTNO,'.','');
   IF (pv_AFACCTNO <> 'ALL')
    THEN
       V_AFACCTNO:=pv_AFACCTNO;
   ELSE
       V_AFACCTNO:='%';
   END IF;


   SELECT max(sbdate) INTO v_IDATE  FROM sbcurrdate WHERE sbtype ='B' AND sbdate <= to_date(I_DATE,'DD/MM/RRRR');

   select to_date(varvalue,'DD/MM/RRRR') into v_CurrDate from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM';



IF   v_idate = v_CurrDate THEN
-- GET REPORT'S DATA
    OPEN PV_REFCURSOR
        for
   SELECT   distinct amr.refullname, vmr.*,  amr.rg_grfullname--, v_CurrDate Ngay_HT
   FROM
   (
    SELECT v.*,v1.realass1, nvl(l_MRCRLIMITMAX,0) MRCRLIMITMAX,nvl(l_T0AMT,0) T0AMT, nvl(l_MRAMT,0) MRAMT, nvl(l_DFAMT,0) DFAMT,
        nvl(l_trfbuyamt_in,0) TRFBUYAMT_IN, nvl(l_trfbuyamt_over,0) TRFBUYAMT_OVER, nvl(l_trfbuyamt_inday,0) TRFBUYAMT_INDAY, nvl(l_secureamt_inday,0) SECUREAMT_INDAY,
        nvl(l_BALANCE,0) BALANCE, nvl(l_AVLADVANCE,0) AVLADVANCE, nvl(l_DEPOFEEAMT,0) DEPOFEEAMT, nvl(l_DFODAMT,0) DFODAMT, nvl(l_intnmlpbl,0) l_intnmlpbl
        , cf.fullname , cf.idcode,  nvl(va.marginrate,0) MARGINRATE_MR, to_date(I_DATE,'DD/MM/RRRR') ngay_tra_cuu

    FROM  (select sum(realass) realass1, afacctno from vw_mr9004 where afacctno like V_AFACCTNO and custodycd like V_CUSTODYCD group by afacctno) v1,
            (
                SELECT a1.cdcontent roomchk1, mr.*,
                    decode(mr.roomchk,'Y',mr.avlsysroom,mr.avlgrproom) avlsysroom1,
                    decode(mr.roomchk,'Y',mr.usedsysroom,mr.usedgrproom) usedsysroom1
                FROM vw_mr9004 mr, allcode a1
                WHERE a1.cdname = 'ROOMCHK' AND nvl(mr.roomchk,'Y') = a1.cdval AND a1.cdtype = 'MR'
            ) v, cfmast cf, AFMAST AF, v_getsecmarginratio_all va,
         (
          select vw.trfacctno, nvl(sum(vw.t0amt),0) l_T0AMT, nvl(sum(vw.marginamt),0) l_MRAMT
          from vw_lngroup_all vw, afmast af, cfmast cf
          where vw.trfacctno like V_AFACCTNO and vw.trfacctno = af.acctno
             and af.custid = cf.custid and cf.custodycd like V_CUSTODYCD
             AND AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = V_TLID)
          group by vw.trfacctno
          ) ln,
          (
          select ln.trfacctno, nvl(sum(ln.prinnml + ln.prinovd + ln.intnmlacr+ln.intnmlovd+ln.intovdacr+ln.intdue+ln.feeintnmlacr+ln.feeintnmlovd+ln.feeintovdacr+ln.feeintdue),0) l_DFAMT,
              nvl(sum(prinnml+prinovd),0) l_DFODAMT
           from lnmast  ln, afmast af, cfmast cf
           where trfacctno like V_AFACCTNO and ftype = 'DF' and ln.trfacctno = af.acctno
              and af.custid = cf.custid and cf.custodycd like V_CUSTODYCD
              AND AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = V_TLID)
          group by ln.trfacctno
          ) df,
         (
          select ln.trfacctno, nvl(sum(ln.intnmlpbl),0) l_intnmlpbl
           from lnmast ln , afmast af, cfmast cf
           where ln.trfacctno like V_AFACCTNO and ftype <> 'DF' and ln.trfacctno = af.acctno
              and af.custid = cf.custid and cf.custodycd like V_CUSTODYCD
              AND AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = V_TLID)
          group by ln.trfacctno
          ) pbl,
         (
          select vfo.afacctno, nvl(sum(trfbuyamt_in),0) l_trfbuyamt_in, nvl(sum(trfbuyamt_over),0)  l_trfbuyamt_over
          from v_getbuyorderinfo vfo, afmast af, cfmast cf
          where afacctno like V_AFACCTNO and vfo.afacctno = af.acctno
             and af.custid = cf.custid and cf.custodycd like V_CUSTODYCD
             AND AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = V_TLID)
           group by  vfo.afacctno
           ) vfo,
          (
            select vwi.afacctno, nvl(sum(trfsecuredamt_inday+trft0amt_inday),0) l_trfbuyamt_inday ,nvl(sum(secureamt_inday),0) l_secureamt_inday
               from vw_trfbuyinfo_inday vwi, afmast af, cfmast cf
               where vwi.afacctno like V_AFACCTNO and vwi.afacctno=af.acctno
                 and af.custid = cf.custid and cf.custodycd like V_CUSTODYCD
                 AND AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = V_TLID)
             group by vwi.afacctno
            )vwi,
           (
            select af.acctno, mrcrlimitmax  l_MRCRLIMITMAX
            from afmast af, cfmast cf
            where af.acctno like V_AFACCTNO and af.custid = cf.custid and cf.custodycd like V_CUSTODYCD
            --group by af.acctno
           ) afc,
           (
            select ci.acctno, balance l_BALANCE, depofeeamt  l_DEPOFEEAMT--, l_DFODAMT  , dfodamt
             from cimast ci, afmast af, cfmast cf
             where ci.acctno like V_AFACCTNO and af.custid = cf.custid and cf.custodycd like V_CUSTODYCD
                   and ci.acctno = af.acctno AND AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = V_TLID)
             --group by ci.acctno
           ) cif,
           (
             select ve.afacctno, nvl(sum(depoamt),0)  l_AVLADVANCE
             from v_getaccountavladvance ve, afmast af, cfmast cf
             where ve.afacctno like V_AFACCTNO and ve.afacctno = af.acctno and af.custid = cf.custid and cf.custodycd like V_CUSTODYCD
                   AND AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = V_TLID)
             group by ve.afacctno
           ) ve
    WHERE  v.afacctno = v1.afacctno and v.afacctno like V_AFACCTNO and cf.custodycd like v.custodycd AND V.AFACCTNO = AF.ACCTNO
           and va.afacctno = v.afacctno and v.usedsysroom1 >0 and v.custodycd like V_CUSTODYCD
           and v.afacctno = ln.trfacctno(+) and v.afacctno = df.trfacctno(+) and v.afacctno = pbl.trfacctno(+)
          and v.afacctno = vfo.afacctno(+) and v.afacctno = vwi.afacctno(+)
          and v.afacctno = afc.acctno(+) and v.afacctno = cif.acctno(+) and v.afacctno = ve.afacctno(+)
          AND AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = V_TLID) and v.symbol like v_symbol
          and v.trade + v.mortage + v.receiving + v.receivingt2 + v.totalreceiving + v.sellmatchqtty + v.buyqtty + v.totalbuyqtty > 0
          order by v.symbol
          ) vmr,
      (
          SELECT amr.*, crm.rg_grfullname
          FROM
              (
                 select  (cf.fullname) refullname, re.reacctno, re.afacctno
                        from reaflnk re, RETYPE, recflnk rcf, cfmast cf
                       where to_date(I_DATE,'DD/MM/RRRR') between re.frdate and nvl(re.clstxdate-1,re.todate)
                         and rcf.custid = substr(re.reacctno,1,10)
                         and substr(re.reacctno, 0, 10) = cf.custid
                         --and re.status <> 'C'
                         and re.deltd <> 'Y' AND rcf.custid = cf.custid
                         AND substr(re.reacctno, 11) = RETYPE.ACTYPE
                         AND rerole IN ('RM', 'BM')
                         and rcf.brid like v_brgrp
                ) amr,
                (select  reg.refrecflnkid, reg.reacctno, rg.fullname rg_grfullname
                      from regrplnk reg , regrp rg
                      where reg.refrecflnkid = rg.autoid
                            and reg.frdate <= to_date(I_DATE,'DD/MM/RRRR')
                            and nvl(reg.clstxdate-1,reg.todate) >= to_date(I_DATE,'DD/MM/RRRR')
                            and nvl(reg.refrecflnkid,'---') like  v_reid

                  ) crm
              WHERE amr.reacctno = crm.reacctno (+)
          ) amr
   WHERE vmr.afacctno = amr.afacctno (+)
   ORDER BY vmr.custodycd, vmr.afacctno, vmr.symbol;

ELSE
  -- GET REPORT'S DATA
  OPEN PV_REFCURSOR
  FOR
  SELECT  distinct amr.refullname, vmr.*,  amr.rg_grfullname, 0 l_intnmlpbl--, v_CurrDate Ngay_HT
   FROM
   (
    SELECT v.*, v1.realass1, cf.fullname, cf.idcode,
           mrl.marginrate MARGINRATE_MR,
           to_date(I_DATE,'DD/MM/RRRR') ngay_tra_cuu

    FROM  (select sum(realass) realass1, afacctno, txdate from tbl_mr3007_log where txdate = v_idate and afacctno like V_AFACCTNO and custodycd like V_CUSTODYCD group by afacctno, txdate) v1,
        (
            SELECT a1.cdcontent roomchk1, mr.*,
                decode(nvl(mr.roomchk,'Y'),'Y',mr.avlsysroom,mr.avlgrproom) avlsysroom1,
                decode(nvl(mr.roomchk,'Y'),'Y',mr.usedsysroom,mr.usedgrproom) usedsysroom1
            FROM tbl_mr3007_log mr, allcode a1
            WHERE mr.txdate = v_idate AND a1.cdname = 'ROOMCHK' AND nvl(mr.roomchk,'Y') = a1.cdval AND a1.cdtype = 'MR'
        ) v,
        cfmast cf, AFMAST AF, (select afacctno, max(marginrate) marginrate from mr5005_log where txdate = v_idate group by afacctno ) mrl

    WHERE v.afacctno = v1.afacctno and v.txdate = v1.txdate and v.afacctno like V_AFACCTNO and cf.custodycd = v.custodycd
        and AF.ACCTNO = V.AFACCTNO
        and v.custodycd like V_CUSTODYCD
        AND AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = V_TLID)and v.symbol like v_symbol
        and v.usedsysroom1 >0
        and af.acctno= mrl.afacctno(+)
        and v.trade + v.mortage + v.receiving + v.receivingt2 + v.totalreceiving + v.sellmatchqtty + v.buyqtty + v.totalbuyqtty > 0
        order by v.symbol
    )vmr,
    (
        SELECT amr.*, crm.rg_grfullname
        FROM
        (
           select  (cf.fullname) refullname, re.reacctno, re.afacctno
                  from reaflnk re, RETYPE, recflnk rcf, cfmast cf
                 where v_idate between re.frdate and nvl(re.clstxdate-1,re.todate)
                   and rcf.custid = substr(re.reacctno,1,10)
                   and substr(re.reacctno, 0, 10) = cf.custid
                   --and re.status <> 'C'
                   and re.deltd <> 'Y' AND rcf.custid = cf.custid
                   AND substr(re.reacctno, 11) = RETYPE.ACTYPE
                   AND rerole IN ('RM', 'BM')
                   and rcf.brid like v_brgrp
          ) amr,
          (select  reg.refrecflnkid, reg.reacctno, rg.fullname rg_grfullname
                from regrplnk reg , regrp rg
                where reg.refrecflnkid = rg.autoid
                      and reg.frdate <= v_idate
                      and nvl(reg.clstxdate-1,reg.todate) >= v_idate
                      and nvl(reg.refrecflnkid,'---') like  v_reid

            ) crm
        WHERE amr.reacctno = crm.reacctno(+)
    ) amr
   WHERE vmr.afacctno = amr.afacctno(+)
   ORDER BY vmr.custodycd, vmr.afacctno, vmr.symbol
   ;

 END IF;

EXCEPTION
   WHEN OTHERS
   THEN
        RETURN;


end MR0016;
/

