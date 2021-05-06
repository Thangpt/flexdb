CREATE OR REPLACE PROCEDURE PR_GETSEMASTDETAIL (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2
)
IS

   V_STRCUSTODYCD  VARCHAR2(20);                   -- USED WHEN V_NUMOPTION > 0
   V_STRAFACCTNO   VARCHAR2 (20);
   v_CurrDate DATE;
 BEGIN


      V_STRCUSTODYCD :=  trim(PV_CUSTODYCD);
      select to_date(varvalue,'DD/MM/RRRR') into v_CurrDate from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM';


   -- GET REPORT'S PARAMETERS
  IF (PV_AFACCTNO <> 'ALL')
   THEN
      V_STRAFACCTNO :=  PV_AFACCTNO;
   ELSE
      V_STRAFACCTNO := '%%';
   END IF;



      OPEN PV_REFCURSOR
       FOR
SELECT se.afacctno || ' - ' || aft.typename afacctno, sb.symbol
            , se.trade - nvl(order_today.trade_sell_qtty,0)  duoc_dat_lenh--   NVL(se.blocked, 0)  +  duoc_dat_lenh
            , nvl(odmast.orderBuyQtty,0) mua_cho_khop
            , nvl(odmast.orderSellQtty,0) ban_cho_khop
            , nvl(khop_qtty.execqtty,0) - NVL(retail.qtty,0) khop_ban
            , nvl(buf.blocked,0) phong_toa--, NVL(se.mortage, 0) phong_toa
            , nvl(buf.restrictqtty,0) HCCN-- , NVL(se.blocked, 0) HCCN
            , securities_receiving_T0 ,securities_receiving_T1,securities_receiving_T2,securities_receiving_T3
            , CASE WHEN nvl(buf.receiving,0) <> 0 THEN nvl(buf.receiving,0) - securities_receiving_T0 - securities_receiving_T1 - securities_receiving_T2 - securities_receiving_T3
                        ELSE 0 END  Cho_ve-- NVL(tr.ca_receiving,0) Cho_ve
           -- , se.receiving + NVL(tr.ca_receiving,0) + nvl(order_buy_today.receiving_qtty,0) Cho_ve_gom_CA
            , nvl(mr.rateCL,0) R_suc_mua, nvl(mr.priceCL,0) gia_tinh_suc_mua
            , nvl(mr.Ts_Sucmua,0) suc_mua_quy_doi
            , NVL(asr.MRRATIORATE,0) R_Taisan
            , nvl(mr.callpricecl,0) gia_tinh_ts
            , nvl(mr.ts_callt2,0) tai_san_quy_doi
            , nvl(sei.basicprice,0) giaTT
            , nvl(mr.realass,0) tong_ts
FROM   sbsecurities sb,/* sbsecurities sb_wft, */ securities_info sei, cfmast cf, afmast af, aftype aft,
(
SELECT se.*, aft.actype mraftype FROM semast se, afmast af, aftype aft
WHERE se.afacctno = af.acctno AND af.actype = aft.actype
) se
LEFT JOIN
(SELECT afacctno, codeid
             , sum(CASE WHEN INSTR(exectype, 'B') <> 0 THEN remainqtty  ELSE 0 END) orderBuyQtty
             , sum(CASE WHEN INSTR(exectype, 'S') <> 0 THEN remainqtty ELSE 0 END) orderSellQtty
FROM odmast WHERE  deltd <> 'Y' AND orderqtty - execqtty <> 0 AND exectype NOT IN ('CS','CB') -- huy mua, huy ban
AND edstatus = 'N' --khong lay lenh huy, sua
GROUP BY afacctno, codeid
) odmast
ON se.afacctno = odmast.afacctno AND se.codeid = odmast.codeid
LEFT JOIN
( select seacctno, sum(execqtty) execqtty
    from
    (
    select codeid, afacctno, seacctno, execqtty, txdate from odmast
    where execqtty > 0
        and exectype in ('MS','NS')
        and txdate <= v_CurrDate
        and deltd <> 'Y'
    union all
    select odhist.codeid, odhist.afacctno, seacctno, execqtty, odhist.txdate from odmasthist odhist, stschdhist  sthist
    where execqtty > 0
        and odhist.txdate <=v_CurrDate
        and exectype in ('MS','NS')
        AND sthist.orgorderid = odhist.orderid
        AND sthist.duetype = 'RM'
        AND sthist.cleardate > v_CurrDate
    )
    group by seacctno
)khop_qtty
ON se.acctno = khop_qtty.seacctno
LEFT JOIN
(   -- SO LUONG CK LO LE CHO BAN'
    SELECT TR.afacctno, tr.codeid, SUM(case when tr.txtype = 'D' then -tr.namt else tr.namt end) qtty
    FROM vw_setran_gen TR
    WHERE TR.TLTXCD IN ('8878','8879') AND TR.field = 'NETTING'
        AND TR.busdate > v_CurrDate
    GROUP BY TR.afACCTNO, tr.codeid
) Retail
ON  Retail.afacctno = se.afacctno AND Retail.codeid = se.codeid
LEFT JOIN
(SELECT * FROM buf_se_account) se_buf
ON se.acctno = se_buf.acctno
/*LEFT JOIN
(
SELECT  acctno, sum
        ( case when field = 'RECEIVING' and txcd in('3351','3350') then
                (case when tr.txtype = 'D' then -tr.namt else tr.namt end)
            else 0
            end
        ) CA_RECEIVING
from vw_setran_gen tr
    where tr.sectype <> '004'
        AND TR.deltd <> 'Y'
        and  tr.busdate =  v_CurrDate
        and tr.field in ('TRADE','MORTAGE','BLOCKED','NETTING','STANDING','RECEIVING','WITHDRAW','DTOCLOSE','SECURED')
  GROUP BY acctno
) tr
ON se.acctno = tr.acctno*/
left join
(   -- Phat sinh mua chung khoan ngay hom nay
    select se.acctno,
         SUM(qtty)  receiving_qtty
    from cfmast cf, afmast af, semast se, sbsecurities sb, stschd  st
    where cf.custid = af.custid and af.acctno = se.afacctno
        and se.codeid = sb.codeid
         and sb.sectype <>'004'
        and se.afacctno = st.acctno and st.duetype = 'SM' and st.status = 'N'
        and se.codeid = st.codeid
        and st.deltd <> 'Y'
        and st.txdate = v_CurrDate
    group by se.acctno
) order_buy_today on se.acctno = order_buy_today.acctno
left join
(   -- Phat sinh ban chung khoan ngay hom nay
    SELECT SEACCTNO, SUM( SECUREAMT) trade_sell_qtty,
        SUM( SECUREMTG ) mtg_sell_qtty,
        SUM (RECEIVING ) SERECEIVING,
        SUM( EXECQTTY ) khop_qtty
     FROM (
            SELECT OD.SEACCTNO,
                CASE WHEN OD.EXECTYPE IN ('NS', 'SS') THEN to_number(nvl(varvalue,0))* REMAINQTTY + EXECQTTY ELSE 0 END SECUREAMT,
                CASE WHEN OD.EXECTYPE = 'MS'  THEN to_number(nvl(varvalue,0)) * REMAINQTTY + EXECQTTY ELSE 0 END SECUREMTG,
                0 RECEIVING,
                 CASE WHEN OD.EXECTYPE IN ('NS', 'SS') THEN OD.EXECQTTY ELSE 0 END EXECQTTY
            FROM ODMAST OD, ODTYPE TYP, SYSVAR SY
            WHERE OD.EXECTYPE IN ('NS', 'SS','MS')
                and sy.grname='SYSTEM' and sy.varname='HOSTATUS'
                And OD.ACTYPE = TYP.ACTYPE
                AND OD.TXDATE = v_CurrDate
                AND NVL(OD.GRPORDER,'N') <> 'Y'
                and od.deltd <> 'Y'
        )
    GROUP BY SEACCTNO
) order_today on se.acctno = order_today.SEACCTNO
LEFT JOIN
(
SELECT * FROM vw_mr9004
) mr ON se.acctno = mr.acctno
LEFT JOIN
(
select a.actype aftype, c.typename, b.codeid, b.SYMBOL,a.MRRATIORATE,a.MRRATIOLOAN,a.MRPRICERATE,a.MRPRICELOAN
from AFSERISK  a, sbsecurities b, aftype c where a.codeid=b.codeid
and a.actype =c.actype
) asr ON se.codeid = asr.codeid AND se.mraftype = asr.aftype
LEFT JOIN
(
SELECT afacctno, codeid, blocked, restrictqtty, receiving FROM buf_se_account
) buf
ON buf.afacctno = se.afacctno AND buf.codeid = se.codeid

WHERE-- se.codeid = sb_wft.codeid AND sb.codeid = NVL(sb_wft.refcodeid, sb_wft.codeid)
se.codeid = sb.codeid
AND se.codeid = sei.codeid AND cf.custid = af.custid AND af.acctno = se.afacctno
AND af.actype = aft.actype
AND af.acctno LIKE V_strafacctno
AND cf.custodycd = V_STRCUSTODYCD
AND  se.trade + nvl(order_today.trade_sell_qtty,0)  + --   NVL(se.blocked, 0)  +  duoc_dat_lenh
             nvl(odmast.orderBuyQtty,0) +
             nvl(odmast.orderSellQtty,0) +
            nvl(khop_qtty.execqtty,0) - NVL(retail.qtty,0) +
             nvl(buf.blocked,0)  +
             nvl(buf.restrictqtty,0) +
             securities_receiving_T0 + securities_receiving_T1 + securities_receiving_T2 + securities_receiving_T3 +
            nvl(buf.receiving,0)  <> 0
 ;



EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

