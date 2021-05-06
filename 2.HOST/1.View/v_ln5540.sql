create or replace force view v_ln5540
(careby, custbank, autoid, acctno, trfacctno, lntype, desc_lntype, custodycd, t0odamt, t0prinnml, t0prindue, t0prinovd, prinovd, prindue, prinnml, feeovd, sumintnmlovd, intnmlovd, t0intnmlovd, feeintnmlovd, sumintovdacr, intovdacr, t0intovdacr, feeintovdacr, feedue, sumintdue, intdue, t0intdue, feeintdue, fee, sumintnmlacr, intnmlacr, t0intnmlacr, feeintnmlacr, intnmlacrbank, advpay, advpayfee, odamt, nmlamt, prinnmlamt, intnmlamt, prinodamt, intodamt, status, minterm, avlbal, rlsdate, overduedate, lsreftype, reftype)
as
select af.careby, nvl(cfb.shortname,'CT') custbank, ls.autoid, ln.ACCTNO, ln.TRFACCTNO, ln.LNTYPE, cd1.CDCONTENT DESC_LNTYPE, CF.CUSTODYCD,
ROUND(case when reftype = 'GP' then nml + ovd else 0 end) T0ODAMT,
ROUND(case when reftype = 'GP' and ls.overduedate > to_date(sy.varvalue,'DD/MM/RRRR') then ls.nml else 0 end) T0PRINNML,
ROUND(case when reftype = 'GP' and ls.overduedate = to_date(sy.varvalue,'DD/MM/RRRR') then ls.nml else 0 end) T0PRINDUE,
ROUND(case when reftype = 'GP' then ovd else 0 end) T0PRINOVD,
ROUND(case when reftype = 'P' then ovd else 0 end) PRINOVD,
ROUND(case when reftype = 'P' and ls.overduedate = to_date(sy.varvalue,'DD/MM/RRRR') then ls.nml else 0 end) PRINDUE,
ROUND(case when reftype = 'P' and ls.overduedate > to_date(sy.varvalue,'DD/MM/RRRR') then ls.nml else 0 end) PRINNML,
ROUND(case when reftype = 'P' then ls.feeovd else 0 end) FEEOVD,
ROUND(ls.intovd + ls.feeintnmlovd) SUMINTNMLOVD,
ROUND(case when reftype = 'P' then ls.intovd else 0 end) INTNMLOVD,
ROUND(case when reftype = 'GP' then ls.intovd else 0 end) T0INTNMLOVD,
ROUND(case when reftype = 'P' then ls.feeintnmlovd else 0 end) FEEINTNMLOVD,
ROUND(ls.intovdprin + ls.feeintovdacr) SUMINTOVDACR,
ROUND(case when reftype = 'P' then ls.intovdprin else 0 end) INTOVDACR,
ROUND(case when reftype = 'GP' then ls.intovdprin else 0 end) T0INTOVDACR,
ROUND(case when reftype = 'P' then ls.feeintovdacr else 0 end) FEEINTOVDACR,
ROUND(case when reftype = 'P' then ls.feedue else 0 end) FEEDUE,
ROUND(ls.intdue + ls.feeintdue) SUMINTDUE,
ROUND(case when reftype = 'P' then ls.intdue else 0 end) INTDUE,
round(case when reftype = 'GP' then ls.intdue else 0 end) T0INTDUE,
round(case when reftype = 'P' then ls.feeintdue else 0 end) FEEINTDUE,
ROUND(case when reftype = 'P' then ls.fee else 0 end) FEE,
ROUND(ls.intnmlacr + ls.feeintnmlacr) SUMINTNMLACR,
ROUND(case when reftype = 'P' then ls.intnmlacr else 0 end) INTNMLACR,
ROUND(case when reftype = 'GP' then ls.intnmlacr else 0 end) T0INTNMLACR,
ROUND(case when reftype = 'P' then ls.feeintnmlacr else 0 end) FEEINTNMLACR,
ROUND(case when reftype = 'P' then ls.intnmlacrbank else 0 end) INTNMLACRBANK,
cd2.cdcontent ADVPAY,
ROUND(ln.advpayfee) advpayfee,
ROUND(ls.nml)+ROUND(ls.ovd)+ROUND(ls.intnmlacr)+ROUND(ls.intdue)+ROUND(ls.intovd)+ROUND(ls.intovdprin)+ROUND(ls.fee)+ROUND(ls.feedue)+ROUND(ls.feeovd)+ROUND(ls.feeintnmlacr)+ROUND(ls.feeintovdacr)+ROUND(ls.feeintnmlovd)+ROUND(ls.feeintdue) ODAMT,
case when reftype = 'P' and ls.overduedate > to_date(sy.varvalue,'DD/MM/RRRR') then
    ROUND(ls.nml)+ROUND(ls.fee)+ROUND(ls.feeintnmlacr)+ROUND(ls.intnmlacr) else 0 end NMLAMT,
case when reftype = 'P' and ls.overduedate > to_date(sy.varvalue,'DD/MM/RRRR') then
    ROUND(ls.nml) else 0 end PRINNMLAMT,
case when reftype = 'P' and ls.overduedate > to_date(sy.varvalue,'DD/MM/RRRR') then
    ROUND(ls.fee)+ROUND(ls.intnmlacr)+ROUND(ls.feeintnmlacr) else 0 end INTNMLAMT,
ROUND(nml+ovd) PRINODAMT,
ROUND(ls.feeovd)+ROUND(ls.intovd)+ROUND(ls.intovdprin)+ROUND(ls.feeintnmlacr)+ROUND(ls.intnmlacr)+ROUND(ls.feeintovdacr)+ROUND(ls.feeintdue)+ROUND(ls.intdue)+ROUND(ls.feeintnmlovd)+ROUND(ls.fee)+ROUND(ls.feedue) INTODAMT,
cd3.cdcontent status, ln.minterm, Least(fnc_fo_getcash4paymentdebt(af.acctno),ROUND(fn_getAVLBAL(af.acctno, ls.autoid)))AVLBAL,
ls.RLSDATE, ls.OVERDUEDATE,
case when ls.reftype ='P' then 'Credit line' else 'Bao lanh' end LSREFTYPE,
case WHEN ls.reftype <> 'P' AND LS.OVERDUEDATE > GETCURRDATE then 'T0'
     WHEN ls.reftype <> 'P' AND LS.OVERDUEDATE <= GETCURRDATE then 'T1'
     WHEN ls.reftype = 'P' AND NVL(lnt.chksysctrl,'N') ='Y' AND LS.OVERDUEDATE > GETCURRDATE THEN  'U0'
     WHEN ls.reftype = 'P' AND NVL(lnt.chksysctrl,'N') ='Y' AND LS.OVERDUEDATE <= GETCURRDATE THEN  'U1'
     WHEN ls.reftype = 'P' AND NVL(lnt.chksysctrl,'N') <> 'Y' AND LS.OVERDUEDATE > GETCURRDATE THEN  'M0'
     ELSE 'M1' end
from cfmast cf, afmast af, lnmast ln, lnschd ls,
    allcode cd1, allcode cd2, allcode cd3,
    sysvar sy, cfmast cfb, lntype lnt
where cf.custid = af.custid
and af.acctno = ln.trfacctno
and ln.acctno = ls.acctno
and ln.custbank = cfb.custid(+)
and ln.ftype = 'AF' and ls.reftype in ('P','GP')
and cd1.cdtype = 'LN' and cd1.cdname = 'LNTYPE' and cd1.cdval = ln.LNTYPE
and cd2.cdtype = 'SY' and cd2.cdname = 'YESNO' and cd2.cdval = ln.ADVPAY
and cd3.cdtype = 'LN' and cd3.cdname = 'STATUS' and cd3.cdval = ln.STATUS
and sy.grname = 'SYSTEM' and sy.varname = 'CURRDATE'
AND ln.actype = lnt.actype;

