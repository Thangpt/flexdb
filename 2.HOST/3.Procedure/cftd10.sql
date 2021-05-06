CREATE OR REPLACE PROCEDURE cftd10 (
   PV_REFCURSOR   in out   PKG_REPORT.REF_CURSOR,
   OPT            in       varchar2,
   BRID           in       varchar2,
   F_DATE         in       varchar2,
   T_DATE         in       varchar2,
   CIACCTNO       in       varchar2,
   SYMBOL         in       varchar2,
   ECONOMIC       in       varchar2,
   TRADEPLACE     in       varchar2
   )
is
--
-- PURPOSE: bao cao tinh trang lai lo cua khach hang
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- Hienvu   08-05-2011  CREATED
-- ---------   ------  -------------------------------------------
   V_STROPTION          varchar2 (5);
   V_STRBRID            varchar2 (4);
   V_STRSYMBOL          varchar2 (10);
   V_STRTRADEPLACE      varchar2 (10);
   V_STRECONIMIC        varchar2 (30);
   V_STRAFACCTNO        varchar2 (1000);
   v_strnextfrdate      date;
   v_strnexttodate      date;
begin
    select min(sbdate) into v_strnextfrdate from sbcldr where cldrtype='000' and sbdate > to_date(F_DATE,'DD/MM/YYYY') and HOLIDAY='N';
    select min(sbdate) into v_strnexttodate from sbcldr where cldrtype='000' and sbdate > to_date(T_DATE,'DD/MM/YYYY') and HOLIDAY='N';
   V_STRAFACCTNO:=CIACCTNO;
   V_STROPTION := OPT;

   if (V_STROPTION <> 'A') and (BRID <> 'ALL')
   then
      V_STRBRID := BRID;
   else
      V_STRBRID := '%%';
   end if;

    -- GET REPORT'S PARAMETERS
   if (TRADEPLACE <> 'ALL')
   then
      V_STRTRADEPLACE := trim(TRADEPLACE);
   else
      V_STRTRADEPLACE := '%%';
   end if;
   --
   if (SYMBOL <> 'ALL')
   then
      V_STRSYMBOL := SYMBOL;
   else
      V_STRSYMBOL := '%%';
   end if;
   --
   if (ECONOMIC <> 'ALL')
   then
      V_STRECONIMIC := ECONOMIC;
   else
      V_STRECONIMIC := '%%';
   end if;

    open PV_REFCURSOR
    for
        --Ton dau ky
select acc.symbol,acc.tradeplace,acc.econimic,acc.acctno ,acc.afacctno,
round(acc.trade+acc.mortage+acc.secured+acc.blocked+acc.receiving-nvl(benum.amt,0)) be_balance, nvl(becost.costprice,0) becostprice,
round(acc.trade+acc.mortage+acc.secured+acc.blocked+acc.receiving-nvl(benum.amt,0)) * nvl(becost.costprice,0) beamt,
round(acc.trade+acc.mortage+acc.secured+acc.blocked+acc.receiving-nvl(afnum.amt,0)) af_balance, nvl(afcost.costprice,0) afcostprice,
round(acc.trade+acc.mortage+acc.secured+acc.blocked+acc.receiving-nvl(afnum.amt,0)) * nvl(afcost.costprice,0) afamt,
nvl(benum.cramt,0)-nvl(afnum.cramt,0) crqtty,
nvl(benum.dramt,0)-nvl(afnum.dramt,0) drqtty,
nvl(psnum.dcramt,0) dcramt,
nvl(psnum.ddroutamt,0) + nvl(sellnum.costamt,0) ddroutamt,
nvl(psnum.ddroutamt,0)+ nvl(sellnum.samt,0) ddrsellamt,
round(acc.trade+acc.mortage+acc.secured+acc.blocked+acc.receiving-nvl(afnum.amt,0)) * nvl(afcost.costprice,0) -
    (nvl(psnum.dcramt,0))
    + (nvl(psnum.ddroutamt,0) + nvl(sellnum.costamt,0))
    - round(acc.trade+acc.mortage+acc.secured+acc.blocked+acc.receiving-nvl(benum.amt,0)) * nvl(becost.costprice,0)  adnum ,
nvl(psnum.ddroutamt,0)+ nvl(sellnum.samt,0)
- nvl(psnum.ddroutamt,0) - nvl(sellnum.costamt,0) PNL
from
(select  se.afacctno  afacctno,se.mortage,se.trade,se.acctno ,se.secured,se.blocked,se.receiving,sb.symbol ,cd2.cdcontent tradeplace, cd.cdcontent econimic
        from semast se,sbsecurities sb,issuers iss,allcode cd, allcode cd2
        where se.status ='A'
        and se.afacctno =V_STRAFACCTNO
        and se.codeid=sb.codeid
        and sb.sectype <> '004'
        and sb.symbol like V_STRSYMBOL
        and sb.tradeplace like V_STRTRADEPLACE
        and sb.issuerid=iss.issuerid
        and iss.econimic like V_STRECONIMIC
        and cd.cdname='ECONIMIC' and cd.CDTYPE='SA' and cd.cdval=iss.econimic
        and cd2.cdname='TRADEPLACE' and cd2.cdtype='SA' and cd2.cdval=sb.tradeplace
        )acc
left join
(select nvl(sum(amt ),0) amt,nvl(sum(dramt ),0) dramt,nvl(sum(cramt ),0) cramt, acctno
      from
    ( select sum(amt) amt,
            sum(case when amt>0 then amt else 0 end) cramt,
            sum(case when amt<0 then -amt else 0 end) dramt,acctno
            from (
            select   sum ((case when app.txtype = 'D'then -tr.namt when
              app.txtype = 'C' then tr.namt else 0  end )) amt,
              tr.acctno acctno
                from apptx app, setran tr, tllog tl
                where tr.txcd = app.txcd
                and tl.txnum =tr.txnum
                and app.apptype = 'SE'
                and app.txtype in ('C', 'D')
                and tl.deltd <>'Y'
                and  tr.namt<>0
                and tl.busdate>=to_date (F_DATE ,'DD/MM/YYYY')
                and app.field in   ('MORTAGE','TRADE','SECURED','BLOCKED','RECEIVING')
                group by  tr.acctno, tl.txnum, tl.txdate ) group by acctno
  union all
        select sum(amt) amt,
            sum(case when amt>0 then amt else 0 end) cramt,
            sum(case when amt<0 then -amt else 0 end) dramt,acctno
            from
          (select   sum ((case when app.txtype = 'D'then -tr.namt when
         app.txtype = 'C' then tr.namt else 0 end )) amt,
         tr.acctno acctno
         from apptx app, setrana tr ,tllogall tl
         where tr.txcd = app.txcd
               and tl.txnum =tr.txnum
               and tl.txdate =tr.txdate
               and app.apptype = 'SE'
               and app.txtype in ('C', 'D')
               and tl.deltd <>'Y'
               and  tr.namt<>0
               and tl.busdate  >=to_date (F_DATE  ,'DD/MM/YYYY')
               and app.field in   ('MORTAGE','TRADE','SECURED','BLOCKED','RECEIVING')
               group by tr.acctno, tl.txdate , tl.txnum) group by  acctno
                )
    group by acctno
       ) benum
on benum.acctno= acc.acctno

left join
(select a.acctno ,round(a.costprice,2) costprice
    from secostprice a,
    (select max(autoid) autoid,max(txdate) txdate, acctno from secostprice where txdate <= to_date(F_DATE,'DD/MM/YYYY')
    group by acctno) b
    where a.txdate =b.txdate and a.acctno =b.acctno and a.autoid=b.autoid
 ) becost
on acc.acctno =becost.acctno

left join
(select nvl(sum(amt ),0) amt,nvl(sum(dramt ),0) dramt,nvl(sum(cramt ),0) cramt, acctno
      from
    ( select sum(amt) amt,
            sum(case when amt>0 then amt else 0 end) cramt,
            sum(case when amt<0 then -amt else 0 end) dramt,acctno
            from (
            select   sum ((case when app.txtype = 'D'then -tr.namt when
              app.txtype = 'C' then tr.namt else 0  end )) amt,
              tr.acctno acctno
                from apptx app, setran tr, tllog tl
                where tr.txcd = app.txcd
                and tl.txnum =tr.txnum
                and app.apptype = 'SE'
                and app.txtype in ('C', 'D')
                and tl.deltd <>'Y'
                and  tr.namt<>0
                and tl.busdate>to_date (T_DATE ,'DD/MM/YYYY')
                and app.field in   ('MORTAGE','TRADE','SECURED','BLOCKED','RECEIVING')
                group by  tr.acctno, tl.txnum, tl.txdate ) group by acctno
  union all
        select sum(amt) amt,
            sum(case when amt>0 then amt else 0 end) cramt,
            sum(case when amt<0 then -amt else 0 end) dramt,acctno
            from
          (select   sum ((case when app.txtype = 'D'then -tr.namt when
         app.txtype = 'C' then tr.namt else 0 end )) amt,
         tr.acctno acctno
         from apptx app, setrana tr ,tllogall tl
         where tr.txcd = app.txcd
               and tl.txnum =tr.txnum
               and tl.txdate =tr.txdate
               and app.apptype = 'SE'
               and app.txtype in ('C', 'D')
               and tl.deltd <>'Y'
               and  tr.namt<>0
               and tl.busdate  >to_date (T_DATE  ,'DD/MM/YYYY')
               and app.field in   ('MORTAGE','TRADE','SECURED','BLOCKED','RECEIVING')
               group by tr.acctno, tl.txdate , tl.txnum) group by  acctno
                )
    group by acctno
       ) afnum
on afnum.acctno= acc.acctno

left join
(select a.acctno ,round(a.costprice,2) costprice
    from secostprice a,
    (select max(autoid) autoid,max(txdate) txdate, acctno from secostprice where txdate <= v_strnexttodate
    group by acctno) b
    where a.txdate =b.txdate and a.acctno =b.acctno and a.autoid=b.autoid
 ) afcost
on acc.acctno =afcost.acctno

left join
(select nvl(sum(dcramt ),0) dcramt,nvl(sum(ddroutamt ),0) ddroutamt, acctno
      from
    ( select   sum ((case when app.txtype = 'C' and app.field='DCRAMT' then tr.namt else 0 end )) dcramt,
               sum ((case when app.txtype = 'C' and app.field='DDROUTAMT' then tr.namt else 0 end )) ddroutamt,
               tr.acctno acctno
        from apptx app, setran tr, tllog tl
        where tr.txcd = app.txcd
            and tl.txnum =tr.txnum
            and app.apptype = 'SE'
            and app.txtype in ('C', 'D')
            and tl.deltd <>'Y'
            and  tr.namt<>0
            and tl.busdate  >=to_date (F_DATE  ,'DD/MM/YYYY')
            and tl.busdate  <=to_date (T_DATE  ,'DD/MM/YYYY')
            and app.field in   ('DCRAMT','DDROUTAMT')
            group by  tr.acctno
  union all
      select   sum ((case when app.txtype = 'C' and app.field='DCRAMT' then tr.namt else 0 end )) dcramt,
               sum ((case when app.txtype = 'C' and app.field='DDROUTAMT' then tr.namt else 0 end )) ddroutamt,
               tr.acctno acctno
         from apptx app, setrana tr ,tllogall tl
         where tr.txcd = app.txcd
               and tl.txnum =tr.txnum
               and tl.txdate =tr.txdate
               and app.apptype = 'SE'
               and app.txtype in ('C', 'D')
               and tl.deltd <>'Y'
               and  tr.namt<>0
               and tl.busdate  >=to_date (F_DATE  ,'DD/MM/YYYY')
               and tl.busdate  <=to_date (T_DATE  ,'DD/MM/YYYY')
               and app.field in   ('DCRAMT','DDROUTAMT')
               group by  tr.acctno
                )
               group by acctno
       ) psnum
on psnum.acctno= acc.acctno

left join
(select sum(AMT) samt,acctno, sum (qtty*costprice) costamt
    from (select * from stschd union select * from stschdhist) where  duetype='SS' and deltd <>'Y'
    and TXDATE  >=to_date (F_DATE  ,'DD/MM/YYYY')
    and TXDATE  <=to_date (T_DATE  ,'DD/MM/YYYY')
    group by acctno
) sellnum
on sellnum.acctno =acc.acctno

left join
(select sum(msgamt) adamt,MSGACCT acctno
    from (select * from tllog union select * from tllogall) tl where  tltxcd='2222' and deltd <>'Y'
    and tl.busdate  >=to_date (F_DATE  ,'DD/MM/YYYY')
    and tl.busdate  <=to_date (T_DATE  ,'DD/MM/YYYY')
    group by MSGACCT
) adnum
on adnum.acctno =acc.acctno
where
(acc.trade+acc.mortage+acc.secured+acc.blocked+acc.receiving-nvl(benum.amt,0))  +
(acc.trade+acc.mortage+acc.secured+acc.blocked+acc.receiving-nvl(afnum.amt,0))  +
(nvl(benum.cramt,0)-nvl(afnum.cramt,0)) +
(nvl(benum.dramt,0)-nvl(afnum.dramt,0)) +
nvl(sellnum.costamt,0) + nvl(psnum.ddroutamt,0)+ nvl(sellnum.samt,0) >0
order by acc.symbol;
exception
   when OTHERS
   then
      return;
end;
/

