CREATE OR REPLACE PROCEDURE mr4001(
       PV_REFCURSOR         IN OUT PKG_REPORT.ref_cursor,
       PV_OPT               IN     VARCHAR2,
       BRID                 IN     VARCHAR2,
       I_DATE               IN     VARCHAR2,
       P_REID               IN     VARCHAR2,
       P_BRGRP              IN     VARCHAR2,
       P_CUSTODYCD          IN     VARCHAR2,
       PV_TLID              IN     VARCHAR2

) is
       v_date               date;
       v_custodycd          varchar2(20);
       v_brgrp              varchar2(50);
       v_reid               varchar2(20);
       v_CurrDate           DATE;

begin

   IF (P_CUSTODYCD <> 'ALL')
    THEN
       v_custodycd:=P_CUSTODYCD;
   ELSE
       v_custodycd:='%';
   END IF;

   IF (P_BRGRP<>'ALL')
     THEN
       v_brgrp:=P_BRGRP;
   ELSE
     v_brgrp:='%';
     END IF;

   IF (P_REID<>'ALL')
     THEN
       v_reid:=P_REID;
   ELSE
         v_reid:='%';
   END IF;

   SELECT max(sbdate) INTO v_date  FROM sbcurrdate WHERE sbtype ='B' AND sbdate <=  to_date(I_DATE,'DD/MM/RRRR');
   select to_date(varvalue,'DD/MM/RRRR') into v_CurrDate from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM';

IF v_date = v_CurrDate THEN

   OPEN PV_REFCURSOR
   FOR
SELECT mre.cusname,mre.custodycd, mre.acctno , crm.re_fullname, crm.fullname, mre.ms_margin, mre.mr_topup, mre.Rtt, crm.brname
FROM
    (
       select    cf.fullname cusname, cf.custodycd, af.acctno ,
                 sum(case when ln.rrtype = 'C' then (ls.nml + ls.ovd + ls.intnmlacr + ls.intdue + ls.intovd + ls.intovdprin +
                ls.feeintnmlacr + ls.feeintdue + ls.feeintnmlovd + ls.feeintovdacr+ls.feeovd )
                    else  0 end)  ms_margin ,
                sum(case when ln.rrtype = 'B' then (ls.nml + ls.ovd + ls.intnmlacr + ls.intdue + ls.intovd + ls.intovdprin +
                ls.feeintnmlacr + ls.feeintdue + ls.feeintnmlovd + ls.feeintovdacr+ls.feeovd )
                    else 0 end)  mr_topup ,va.marginrate  Rtt

      from       vw_lnmast_all ln, vw_lnschd_all ls, cfmast cf, afmast af,
                v_getsecmarginratio_all va
      where     ln.acctno = ls.acctno and ls.reftype='P'
                and ln.trfacctno = va.afacctno(+) and cf.custodycd like v_custodycd
                and  AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = PV_TLID)
                and ln.trfacctno = af.acctno and af.custid = cf.custid
                AND (ls.nml + ls.ovd + ls.intnmlacr + ls.intdue + ls.intovd + ls.intovdprin +
                ls.feeintnmlacr + ls.feeintdue + ls.feeintnmlovd + ls.feeintovdacr+ls.feeovd ) > 0.5
        group by cf.fullname, cf.custodycd, af.acctno, va.marginrate
            ) mre,
      (
        SELECT amr.*, crm.fullname
        from
        (
             select  (cf.fullname) re_fullname, re.reacctno, re.afacctno, brgrp.brname
                  from reaflnk re, cfmast cf, RETYPE, brgrp, recflnk rcf
                 where to_date(I_DATE,'DD/MM/RRRR') between re.frdate and nvl(re.clstxdate-1,re.todate)
                   and rcf.custid = substr(re.reacctno,1,10)
                   and substr(re.reacctno, 0, 10) = cf.custid
                   and re.deltd <> 'Y'
                   AND substr(re.reacctno, 11) = RETYPE.ACTYPE
                   AND rerole IN ('RM', 'BM')
                   and rcf.brid like v_brgrp
                   and rcf.brid= brgrp.brid
        ) amr,
        (
            select  reg.refrecflnkid, reg.reacctno, rg.fullname
            from regrplnk reg , regrp rg
            where reg.refrecflnkid = rg.autoid
                  and reg.frdate <= to_date(I_DATE,'DD/MM/RRRR')
                  and nvl(reg.clstxdate-1,reg.todate) >= to_date(I_DATE,'DD/MM/RRRR')
                  and reg.refrecflnkid like  v_reid

        ) crm

    where  amr.reacctno = crm.reacctno(+)
    )crm
where  mre.acctno = crm.afacctno (+)
ORDER by   mre.cusname,mre.custodycd, mre.acctno;

ELSE

  OPEN PV_REFCURSOR
   FOR

SELECT mre.cusname,mre.custodycd, mre.acctno , crm.re_fullname, crm.fullname, mre.ms_margin, mre.mr_topup, mre.Rtt, crm.brname
FROM
    (
       select cf.fullname cusname, cf.custodycd, af.acctno , (log.mramt + log.mrint + log.mrfee - nvl(log.t0amt,0) - nvl(log.t0int,0)) ms_margin,
            (log.mramttopup +log.mrinttopup + log.mrfeetopup) mr_topup, mr.marginrate Rtt
        from
             cfmast cf, afmast af, (SELECT * FROM mr5005_log mr WHERE mr.txdate=v_date and mr.rrtype='C') mr, log_sa0015 log
        where af.custid=cf.custid
            and mr.afacctno(+) = log.afacctno
            and af.acctno= log.afacctno
            AND log.txdate = v_date
            and log.custodycd = cf.custodycd
            and (log.mramt + log.mrint + log.mramttopup + log.mrinttopup >0)
            and cf.custodycd like v_custodycd
            and  AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = PV_TLID)
    ) mre,
    (
        SELECT amr.*, crm.fullname
        from
        (
             select  (cf.fullname) re_fullname, re.reacctno, re.afacctno, brgrp.brname
                  from reaflnk re, cfmast cf, RETYPE, brgrp, recflnk rcf
                 where v_date between re.frdate and nvl(re.clstxdate-1,re.todate)
                   and rcf.custid = substr(re.reacctno,1,10)
                   and substr(re.reacctno, 0, 10) = cf.custid
                   and re.deltd <> 'Y'
                   AND substr(re.reacctno, 11) = RETYPE.ACTYPE
                   AND rerole IN ('RM', 'BM')
                   and rcf.brid like v_brgrp
                   and rcf.brid= brgrp.brid
        ) amr,
        (
            select  reg.refrecflnkid, reg.reacctno, rg.fullname
            from regrplnk reg , regrp rg
            where reg.refrecflnkid = rg.autoid
                  and reg.frdate <= v_date
                  and nvl(reg.clstxdate-1,reg.todate) >= v_date
                  and reg.refrecflnkid like  v_reid

        ) crm

    where  amr.reacctno = crm.reacctno(+)
    )crm
where  mre.acctno = crm.afacctno (+)
ORDER by   mre.cusname,mre.custodycd, mre.acctno ;

end if;
  EXCEPTION
  WHEN OTHERS
   THEN
      Return;

end MR4001;
/

