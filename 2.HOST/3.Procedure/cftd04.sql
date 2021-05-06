CREATE OR REPLACE PROCEDURE CFTD04 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   CIACCTNO       IN       VARCHAR2,
   DEALER         IN       VARCHAR2,
   SYMBOL         IN       VARCHAR2,
   ECONOMIC       IN       VARCHAR2,
   TRADEPLACE     IN       VARCHAR2
   )
IS
--
-- PURPOSE: bao cao tinh trang lai lo cua khach hang
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- hien.vu   08-05-2011  CREATED
-- ---------   ------  -------------------------------------------
   V_STROPTION          VARCHAR2 (5);
   V_STRBRID            VARCHAR2 (4);
   V_STRSYMBOL          VARCHAR2 (10);
   V_STRTRADEPLACE      VARCHAR2 (10);
   V_STRDEALER          VARCHAR2 (4);
   V_STRECONIMIC        VARCHAR2 (30);
   V_STRAFACCTNO        VARCHAR2 (1000);

BEGIN
   V_STRAFACCTNO:=CIACCTNO;
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

    -- GET REPORT'S PARAMETERS
   IF (TRADEPLACE <> 'ALL')
   THEN
      V_STRTRADEPLACE := trim(TRADEPLACE);
   ELSE
      V_STRTRADEPLACE := '%%';
   END IF;
   --
   IF (SYMBOL <> 'ALL')
   THEN
      V_STRSYMBOL := SYMBOL;
   ELSE
      V_STRSYMBOL := '%%';
   END IF;
   --
   IF (DEALER <> 'ALL')
   THEN
      V_STRDEALER := DEALER;
   ELSE
      V_STRDEALER := '%%';
   END IF;
   --
   IF (ECONOMIC <> 'ALL')
   THEN
      V_STRECONIMIC := ECONOMIC;
   ELSE
      V_STRECONIMIC := '%%';
   END IF;

    OPEN PV_REFCURSOR
    FOR

      select mst.codeid,mst.afacctno,mst.symbol,mst.tradeplace ,mst.economic,mst.sellquantity, round(mst.GVTB,0) GVTB,round(mst.GBTB,0) GBTB,
               mst.feeamt, nvl(vat.vatamt,0) vatamt,0 roamt, round(PNL,0) PNL,round(mst.PPNL,2) PPNL
        from (
        select codeid,afacctno,symbol,tradeplace ,economic,sum(sellquantity) sellquantity,
               (case when sum(sellquantity)=0 then 0 else sum(costamt)/sum(sellquantity) end) GVTB,
               (case when sum(sellquantity)=0 then 0 else sum(sellamt)/sum(sellquantity) end) GBTB,
               sum(feeamt) feeamt,
               sum(sellamt)-sum(costamt)-sum(feeamt) PNL,
               (case when sum(costamt)=0 then 0 else (sum(sellamt)-sum(costamt)-sum(feeamt))/sum(costamt) * 100 end) PPNL
        from
        (select sb.codeid,sts.afacctno,sb.symbol,cd2.cdcontent tradeplace ,cd.cdcontent economic,sum(sts.QTTY) sellquantity,
                sum(sts.QTTY*sts.COSTPRICE) costamt,sum(sts.AMT) sellamt,
                sum(od.feeacr) feeamt
        from
            (select max(afacctno) afacctno, orgorderid, sum(qtty) qtty, max(costprice) COSTPRICE, sum(amt) amt from stschd where txdate >=to_date(F_DATE,'DD/MM/YYYY') and txdate <=to_date(T_DATE,'DD/MM/YYYY')  and duetype ='SS' group by orgorderid
                union
             select max(afacctno) afacctno, orgorderid, sum(qtty) qtty, max(costprice) COSTPRICE, sum(amt) amt from stschdhist where txdate >=to_date(F_DATE,'DD/MM/YYYY') and txdate <=to_date(T_DATE,'DD/MM/YYYY') and duetype ='SS' group by orgorderid
             ) sts,
            (select * from odmast where txdate >=to_date(F_DATE,'DD/MM/YYYY') and txdate <=to_date(T_DATE,'DD/MM/YYYY') and deltd <>'Y'
                union
            select * from odmasthist where txdate >=to_date(F_DATE,'DD/MM/YYYY') and txdate <=to_date(T_DATE,'DD/MM/YYYY')
            )od,
            (select * from tllog where txdate >=to_date(F_DATE,'DD/MM/YYYY') and txdate <=to_date(T_DATE,'DD/MM/YYYY')
                union
            select * from tllogall where txdate >=to_date(F_DATE,'DD/MM/YYYY') and txdate <=to_date(T_DATE,'DD/MM/YYYY')
            )tl, sbsecurities sb, issuers iss, allcode cd,allcode cd2
            where od.codeid=sb.codeid and sb.issuerid=iss.issuerid
            and sts.orgorderid=od.orderid
            and instr(V_STRAFACCTNO,sts.afacctno)>0
            and sb.symbol like V_STRSYMBOL
            and sb.tradeplace like V_STRTRADEPLACE
            and iss.econimic like V_STRECONIMIC
            and od.txdate =tl.txdate and od.txnum=tl.txnum
            and tl.tlid like V_STRDEALER
            and cd.cdname='ECONIMIC' and cd.CDTYPE='SA' and cd.cdval=iss.econimic
            and cd2.cdname='TRADEPLACE' and cd2.CDTYPE='SA' and cd2.cdval=sb.tradeplace
            group by sb.codeid,sts.afacctno,sb.symbol,cd2.cdcontent ,cd.cdcontent

            union all
        select sb.codeid, se.afacctno ,sb.symbol,cd2.cdcontent tradeplace ,cd.cdcontent economic,
            sum(tra.namt) sellquantity,sum (tra.namt*nvl(getcostprice(tra.acctno, to_char(tl.txdate,'DD/MM/YYYY')),0)) costamt,sum (tl.msgamt*tra.namt) sellamt ,0 feeamt
        from tllogall tl,setrana tra,semast se, sbsecurities sb,issuers iss, allcode cd,allcode cd2
            where tl.tltxcd ='8878'
            and tl.txnum=tra.txnum and tl.txdate =tra.txdate and tra.txcd='0011'
            and tl.txdate >=to_date(F_DATE,'DD/MM/YYYY') and tl.txdate <=to_date(T_DATE,'DD/MM/YYYY')
            and tra.acctno =se.acctno
            and se.codeid=sb.codeid and sb.issuerid=iss.issuerid
            and instr(V_STRAFACCTNO,se.afacctno)>0
            and sb.symbol like V_STRSYMBOL
            and sb.tradeplace like V_STRTRADEPLACE
            and iss.econimic like V_STRECONIMIC
            and tl.tlid like V_STRDEALER
            and cd.cdname='ECONIMIC' and cd.CDTYPE='SA' and cd.cdval=iss.econimic
            and cd2.cdname='TRADEPLACE' and cd2.CDTYPE='SA' and cd2.cdval=sb.tradeplace
            group by sb.codeid,se.afacctno,sb.symbol,cd2.cdcontent ,cd.cdcontent

        union all

        select sb.codeid, se.afacctno ,sb.symbol,cd2.cdcontent tradeplace ,cd.cdcontent economic,
            sum(tra.namt) sellquantity,sum (tra.namt *nvl(getcostprice(tra.acctno, to_char(tl.txdate,'DD/MM/YYYY')),0)) costamt,sum (tl.msgamt*tra.namt) sellamt ,0 feeamt
            from tllog tl,setran tra,semast se, sbsecurities sb,issuers iss, allcode cd,allcode cd2
            where tl.tltxcd ='8878'
            and tl.txnum=tra.txnum and tl.txdate =tra.txdate and tra.txcd='0011'
            and tl.txdate >=to_date(F_DATE,'DD/MM/YYYY') and tl.txdate <=to_date(T_DATE,'DD/MM/YYYY')
            and tra.acctno =se.acctno
            and se.codeid=sb.codeid and sb.issuerid=iss.issuerid
            and instr(V_STRAFACCTNO,se.afacctno)>0
            and sb.symbol like V_STRSYMBOL
            and sb.tradeplace like V_STRTRADEPLACE
            and iss.econimic like V_STRECONIMIC
            and tl.tlid like V_STRDEALER
            and cd.cdname='ECONIMIC' and cd.CDTYPE='SA' and cd.cdval=iss.econimic
            and cd2.cdname='TRADEPLACE' and cd2.CDTYPE='SA' and cd2.cdval=sb.tradeplace
            group by sb.codeid,se.afacctno,sb.symbol,cd2.cdcontent ,cd.cdcontent)
            group by codeid,afacctno,symbol,tradeplace ,economic

        ) mst
        left join
        (select sum(ci.namt) roamt,ca.codeid,ci.acctno
            from tllogall tl,citrana ci, camast ca  where tl.tltxcd ='3379'
            and tl.txnum=ci.txnum and tl.txdate =ci.txdate and ci.txcd ='0012' and tl.deltd <>'Y'
            and ci.ref=ca.camastid
            and instr(V_STRAFACCTNO,ci.acctno)>0
            and tl.txdate >=to_date(F_DATE,'DD/MM/YYYY') and tl.txdate <=to_date(T_DATE,'DD/MM/YYYY')
            group by ca.codeid,ci.acctno
         ) ca
        on mst.codeid=ca.codeid and mst.afacctno =ca.acctno
        left join
        (select sum(ci.namt) vatamt,ci.acctno
            from tllogall tl,citrana ci  where tl.tltxcd ='0066'
            and tl.txnum=ci.txnum and tl.txdate =ci.txdate and ci.txcd ='0011' and tl.deltd <>'Y'
            and instr(V_STRAFACCTNO,ci.acctno)>0
            and tl.txdate >=to_date(F_DATE,'DD/MM/YYYY') and tl.txdate <=to_date(T_DATE,'DD/MM/YYYY')
            group by ci.acctno
         ) vat
        on mst.afacctno=vat.acctno;
 
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

