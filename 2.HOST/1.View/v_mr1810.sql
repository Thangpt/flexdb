CREATE OR REPLACE FORCE VIEW V_MR1810 AS
(
SELECT A."CUSTID",A."CUSTODYCD",A."ACCTNO",A."FULLNAME",A."T0LOANRATE",A."ADVANCELINE",A."MRLOANLIMIT",A."T0LOANLIMIT",A."CAREBY",A."ACTYPE",A."CONTRACTCHK",A."NAVAMT",A."SELIQAMT",A."TOTALLOAN",A."SETOTAL",A."T0CAL",A."T0DEB",A."MARGINRATE",A."PP",A."PERIOD", nvl(T0af.AFT0USED,0)

AFT0USED,NVL(T0.CUSTT0USED,0) CUSTT0USED,least (A.T0CAL - A.ADVANCELINE ,A.T0LOANLIMIT - nvl(t0.CUSTT0USED,0)) T0REAL
    ,A.T0LOANLIMIT - NVL(T0.CUSTT0USED,0)-- - NVL(CUSTT0PENDING,0)
  CUSTT0REMAIN    ,GREATEST(nvl(urlt.t0,0) - nvl(uflt.t0acclimit,0),0)
urt0limitremain    ,a.t0cal - a.advanceline T0Remain, 0 T0OVRQ , se2.MARGINRATE MARGINRATE2, tlp.tlid
FROM
 (
  SELECT CF.CUSTID, CF.CUSTODYCD, AF.ACCTNO,CF.FULLNAME,cf.t0loanrate, AF.ADVANCELINE, CF.MRLOANLIMIT, CF.T0LOANLIMIT,af.CAREBY, af.actype,
  CF.CONTRACTCHK    ,nvl((ci.balance - NVL(v_getbuy.secureamt,0)) + NVL(ADV.avladvance,0) + v_getsec.senavamt - (NVL(ln.marginamt,0) +
  NVL(ln.t0amt,0)),0) navamt    ,nvl(v_getsec.SELIQAMT,0) SELIQAMT, NVL(ln.marginamt,0) + NVL(ln.t0amt,0) totalloan  , setotal + (ci.balance -
  NVL(v_getbuy.secureamt,0)) + NVL(ADV.avladvance,0) setotal ,ROUND(least (nvl((ci.balance - NVL(v_getbuy.secureamt,0)) + NVL(ADV.avladvance,0) +
  v_getsec.senavamt - (NVL(ln.marginamt,0) + NVL(ln.t0amt,0)),0) * cf.t0loanrate /100,
  nvl(v_getsec.SELIQAMT,0) )) T0CAL    ,GREATEST(0, NVL(NVL(ln.t0amt,0) - NVL(ci.balance +  NVL(v_getbuy.secureamt,0) + NVL(ADV.avladvance,0),0),0))
  T0DEB    ,NVL(buf.MARGINRATE,0) MARGINRATE , BUF.PP , lnt.minterm  period FROM
  CFMAST CF, CIMAST CI, AFMAST AF, AFTYPE AFT, LNTYPE LNT,
        (select sum(aamt) aamt,sum(depoamt) avladvance,sum(paidamt) paidamt, sum(advamt) advanceamount,afacctno from v_getAccountAvlAdvance group by afacctno) adv
        ,( select trfacctno, trunc(sum(prinnml+prinovd+intnmlacr+intdue+intovdacr +intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd),0) marginamt,
trunc(sum(oprinnml+oprinovd+ointnmlacr+ointdue+ointovdacr+ointnmlovd),0) t0amt,
trunc(sum(prinovd+intovdacr+intnmlovd+feeintovdacr+feeintnmlovd + nvl(ls.dueamt,0) + intdue + feeintdue),0) marginovdamt,
trunc(sum(oprinovd+ointovdacr+ointnmlovd),0) t0ovdamt   from lnmast ln, lntype lnt,
(select acctno, sum(nml) dueamt from lnschd, (select * from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM') sy
 where reftype = 'P' and overduedate = to_date(varvalue,'DD/MM/RRRR') group by acctno) ls
 where ftype = 'AF' and ln.actype = lnt.actype
and ln.acctno = ls.acctno(+)
group by ln.trfacctno
        ) ln , v_getbuyorderinfo v_getbuy , v_getsecmargininfo_ALL v_getsec  , buf_ci_account
buf    WHERE AF.ACCTNO = CI.ACCTNO  AND AF.CUSTID = CF.CUSTID (+)
        AND AF.ACCTNO = ADV.AFACCTNO (+)
        and af.acctno = v_getbuy.afacctno (+)   and af.acctno = v_getsec.afacctno (+)
        and af.acctno = ln.trfacctno (+)
        and af.acctno = buf.afacctno(+)
        and cf.contractchk = 'Y'
        and af.actype = aft.actype
        and aft.t0lntype= lnt.actype
    ) A,(SELECT CUSTID, SUM(ADVANCELINE) TOTALADVLINE FROM AFMAST GROUP BY CUSTID) v_t0
, (select sum(acclimit) CUSTT0USED, af.CUSTID from useraflimit us, afmast af where af.acctno = us.acctno and
us.typereceive = 'T0' group by custid) T0
, (select sum(acclimit) AFT0USED, acctno from
useraflimit
us where us.typereceive = 'T0' group by
acctno) T0af
, (select tliduser,allocatelimmit,usedlimmit,acctlimit,t0,t0max from userlimit) urlt
,(select tliduser,sum(decode(typereceive,'T0',acclimit, 0)) t0acclimit,sum(decode(typereceive,'MR',acclimit, 0))
mracclimit  from useraflimit where typeallocate = 'Flex'
 group by tliduser
) uflt, tlprofiles tlp, TLGROUPS GRP, V_GETSECMARGINRATIO_ALL SE2
--,
--(SELECT SUM(NVL(T0AMTUSED,0)) CUSTT0PENDING, acctno FROM Olndetail WHERE status ='P' GROUP BY acctno ) OLN
WHERE A.CUSTID = v_t0.custid (+)
  --AND a.acctno =oln.acctno(+)
      AND A.custid = t0.custid (+)
      and a.acctno = T0af.acctno(+)
    AND se2.afacctno = a.acctno
      and a.t0loanrate >=0
      and tlp.tlid = uflt.tliduser(+)
      and tlp.tlid = urlt.tliduser(+)
--      and tlp.tlid = '<$TELLERID>'
      AND a.CAREBY = GRP.GRPID AND
      GRP.GRPTYPE = '2'
  --    AND a.CAREBY IN (SELECT TLGRP.GRPID
    --  FROM TLGRPUSERS TLGRP
     -- WHERE TLID = '<$TELLERID>')
    )
;

