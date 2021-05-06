CREATE OR REPLACE PROCEDURE se0005 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2,
   PV_SYMBOL         in       varchar2,
   PV_TLID       in         varchar2
       )
IS

-- Sao ke chung khoan khach hang
-- created by Chaunh at 3/2/2012
-- ---------   ------  -------------------------------------------
    V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID     VARCHAR2 (5);

   V_STRAFACCTNO  VARCHAR2 (15);
   V_CUSTODYCD VARCHAR2 (15);
   V_SYMBOL varchar2(10);
   V_FROMDATE date;
   V_TODATE date;
BEGIN
-- GET REPORT'S PARAMETERS
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

   IF  (PV_CUSTODYCD <> 'ALL')
   THEN
         V_CUSTODYCD := PV_CUSTODYCD;
   ELSE
        V_CUSTODYCD := '%';
   END IF;


   IF  (PV_AFACCTNO <> 'ALL')
   THEN
         V_STRAFACCTNO := PV_AFACCTNO;
   ELSE
      V_STRAFACCTNO := '%';
   END IF;

   IF  (PV_SYMBOL <> 'ALL')
   THEN
         V_SYMBOL := replace(PV_SYMBOL,' ','_');
   ELSE
        V_SYMBOL := '%';
   END IF;

   V_FROMDATE:=to_date(F_DATE,'DD/MM/RRRR');
   V_TODATE:=to_date(T_DATE,'DD/MM/RRRR');

-- GET REPORT'S DATA
 OPEN PV_REFCURSOR
 FOR
 select * from
(   select '01' orderid, PV_CUSTODYCD rpt_custodycd, PV_AFACCTNO rpt_afacctno, PV_SYMBOL rpt_symbol, b.fullname,
        b.custodycd,b.txnum, b.txdate, b.afacctno, b.credit_amt, b.debit_amt, b.tltxcd,b.symbol, b.txdesc,
        (SE.TRADE + SE.BLOCKED + se.secured + SE.WITHDRAW + SE.MORTAGE +NVL(SE.netting,0) + NVL(SE.dtoclose,0)  + SE.WTRADE) - sum(a.amt) as so_du_dau_ky,
        0 tong_symbol
    from semast se,
        (select cf.fullname, tran.custodycd,  tran.txnum, tran.txdate, tran.acctno, tran.afacctno, tran.symbol, tran.tltxcd,
               CASE WHEN sum(nvl(od.execamt,0)) = 0 and tran.TLTXCD = '3350' THEN tran.trdesc || ' ' || tran.txdesc
                         when sum(nvl(od.execamt,0)) <> 0 then nvl(tran.trdesc,tran.txdesc) || ' gi? ' || round(sum(nvl(od.execamt,0)) / sum (nvl(od.execqtty,0)),0)
                        ELSE nvl(tran.trdesc,tran.txdesc) END txdesc,
                sum(case when tran.txtype = 'D' then  tran.namt else 0 end) debit_amt,
                sum(case when tran.txtype = 'C' then  tran.namt else 0 end) credit_amt

        from vw_setran_gen tran, cfmast cf, vw_odmast_all od, afmast af
        where tran.afacctno like  V_STRAFACCTNO and tran.symbol like V_SYMBOL and tran.custodycd like V_CUSTODYCD
        and EXISTS (SELECT GU.GRPID FROM TLGRPUSERS GU WHERE AF.CAREBY = GU.GRPID AND GU.TLID = PV_TLID)
        /*and cf.custodycd = tran.custodycd*/
        AND af.acctno = substr(tran.acctno,1,10) and cf.custid = af.custid AND tran.acctref = od.ORDERID (+)
        and tran.field in ('TRADE','BLOCKED','WITHDRAW','MORTAGE','SECURED','DTOCLOSE','WTRADE') --HaiLT bo 'NETTING',
        and tran.txtype in ('D','C') and tran.deltd <> 'Y'
        and tran.txdate <= V_TODATE and tran.txdate >= V_FROMDATE
        group by cf.fullname, tran.custodycd, tran.txnum, tran.txdate, tran.acctno, tran.afacctno, tran.symbol, tran.tltxcd,tran.trdesc,tran.txdesc
        --having sum(case when tran.txtype = 'D' then - tran.namt else tran.namt end) <> 0
        order by tran.txdate, tran.txnum) b,
        (select tran.custodycd,  tran.txnum, tran.txdate, tran.acctno, tran.afacctno, tran.symbol,
                sum(case when tran.txtype = 'D' then - tran.namt else tran.namt end)  amt
        from vw_setran_gen tran
        where tran.afacctno like  V_STRAFACCTNO
        and tran.symbol like V_SYMBOL
        and tran.custodycd like V_CUSTODYCD
        and tran.txdate >= V_FROMDATE
        --and (substr(tran.afacctno,1,4) like V_STRBRID or instr(V_STRBRID,substr(tran.afacctno,1,4)) <> 0)

        and tran.txtype in ('D','C') and tran.deltd <> 'Y'
        and tran.field in ('TRADE','BLOCKED','WITHDRAW','MORTAGE','SECURED','DTOCLOSE','WTRADE') -- 'NETTING',
        group by tran.custodycd, tran.txnum, tran.txdate, tran.acctno, tran.afacctno, tran.symbol
        --having sum(case when tran.txtype = 'D' then - tran.namt else tran.namt end) <> 0
        order by tran.txdate, tran.txnum) a
    where b.acctno = se.acctno
    and a.acctno = b.acctno
    and a.txnum >= (case when a.txdate = b.txdate then b.txnum
                         when a.txdate <  b.txdate then '9999999999'
                         else '0' end )
    group by b.fullname,b.custodycd,b.txnum, b.txdate, b.afacctno, b.credit_amt, b.debit_amt, b.tltxcd,b.symbol,b.txdesc,
            SE.TRADE , SE.BLOCKED , se.secured , SE.WITHDRAW , SE.MORTAGE ,NVL(SE.netting,0) , NVL(SE.dtoclose,0)  , SE.WTRADE
    order by b.txdate, b.txnum, b.afacctno, b.symbol
)

union all
(   select  '02' orderid, PV_CUSTODYCD rpt_custodycd, PV_AFACCTNO rpt_afacctno, PV_SYMBOL rpt_symbol, cf.fullname,
             cf.custodycd, '00000000000' txnum, to_date('01-Jan-2000','DD/MM/RRRR') txdate, '0000000000' afacctno, 0 credit_amt,0 debit_amt, '0000' tltxcd, sb.symbol,'not tranfer type' txdesc, 0 TT,
            (sum(SE.TRADE + SE.BLOCKED + se.secured + SE.WITHDRAW + SE.MORTAGE +NVL(SE.netting,0) + NVL(SE.dtoclose,0)  + SE.WTRADE) - nvl(c.amt,0)) tong_symbol
    from semast se, sbsecurities sb, cfmast cf, afmast af,
        (select tran.acctno,
                sum(case when tran.txtype = 'D' then - tran.namt else tran.namt end)  amt
        from vw_setran_gen tran
        where tran.afacctno like  V_STRAFACCTNO and tran.symbol like V_SYMBOL and tran.custodycd like V_CUSTODYCD
        and tran.txtype in ('D','C') and tran.deltd <> 'Y'
        and tran.txdate > V_TODATE
        and tran.field in ('TRADE','BLOCKED','WITHDRAW','MORTAGE','SECURED','DTOCLOSE','WTRADE') -- 'NETTING',
        group by tran.acctno
        ) c
    where se.codeid = sb.codeid and cf.custid = af.custid
    and se.acctno = c.acctno(+) and se.afacctno = af.acctno
    and se.afacctno like V_STRAFACCTNO and sb.symbol like V_SYMBOL and cf.custodycd like V_CUSTODYCD
    and EXISTS (SELECT GU.GRPID FROM TLGRPUSERS GU WHERE AF.CAREBY = GU.GRPID AND GU.TLID = PV_TLID)
    --and (substr(af.acctno,1,4) like V_STRBRID or instr(V_STRBRID,substr(af.acctno,1,4)) <> 0)
    group by cf.fullname, cf.custodycd, sb.symbol, nvl(c.amt,0)
)
;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

