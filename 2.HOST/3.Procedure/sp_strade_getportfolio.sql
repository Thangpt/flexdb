CREATE OR REPLACE PROCEDURE sp_strade_getportfolio
   (
     PV_REFCURSOR   IN OUT PKG_REPORT.REF_CURSOR,
     pv_custodycd    IN varchar2
   )
   IS
BEGIN -- Proc
OPEN PV_REFCURSOR
    FOR
    SELECT cf.custodycd, instrument.symbol symbol,
                 sum(dtl.trade - NVL (v.secureamt, 0)) trading_qtty,
                 sum(nvl(sts.rcvqtty,0)) receiving_qtty,
                 sum(nvl(ca.carcvqtty,0)) ca_receiving_qtty,
                 sum((dtl.trade - NVL (v.secureamt, 0) ) *
                 case when dtl.dcrqtty+dtl.prevqtty-dtl.ddroutqtty>0 then
                     round((dtl.prevqtty*dtl.costprice+dtl.dcramt-dtl.ddroutamt)/
                            (dtl.dcrqtty+dtl.prevqtty-dtl.ddroutqtty)
                        ,4)
                 else
                     dtl.costprice
                 end
                 ) trading_amount,
                 sum(nvl(sts.rcvamt,0)) receiving_amount,
                 sum(nvl(ca.carcvamt,0)) ca_receiving_amount,
                 sum(nvl(ca.catrfamt,0)) ca_transfer_amount,
                 case when sum(dtl.trade - NVL (v.secureamt, 0) +nvl(sts.rcvqtty,0) + nvl(ca.carcvqtty,0) )>0 then
                     greatest(round(
                                sum(((dtl.trade - NVL (v.secureamt, 0) ) *
                                     case when dtl.dcrqtty+dtl.prevqtty-dtl.ddroutqtty>0 then
                                         round((dtl.prevqtty*dtl.costprice+dtl.dcramt-dtl.ddroutamt)/
                                                (dtl.dcrqtty+dtl.prevqtty-dtl.ddroutqtty)
                                            ,4)
                                     else
                                         dtl.costprice
                                     end) + nvl(rcvamt,0)+ nvl(catrfamt,0)-nvl(carcvamt,0)) /
                           sum(dtl.trade - NVL (v.secureamt, 0) +nvl(sts.rcvqtty,0) + nvl(ca.carcvqtty,0) )
                         ,0),0)
                  else 0 end avrprice,
                  sum(totalsellqtty + nvl(ssts.qtty,0))  total_sell_qtty,
                  sum(totalbuyamt + nvl(ssts.qtty,0) *
                        (case when dtl.dcrqtty+dtl.prevqtty-dtl.ddroutqtty>0 then
                             round((dtl.prevqtty*dtl.costprice+dtl.dcramt-dtl.ddroutamt)/
                                    (dtl.dcrqtty+dtl.prevqtty-dtl.ddroutqtty)
                                ,4)
                         else
                             dtl.costprice
                         end)
                  ) total_buy_amount,
                  sum(totalsellamt + nvl(ssts.amt,0)) total_sell_amount,
                  sum(accumulatepnl) accumulate_profit_loss

            FROM afmast mst,cfmast cf,
                 semast dtl,
                 securities_info instrument,
                 v_getsellorderinfo v,
				 sbsecurities sb,
                 (select acctno, sum(qtty) rcvqtty ,sum(amt) rcvamt
                    from stschd where duetype='RS' and status<>'C' and deltd <>'Y'
                    group by acctno) sts,
                 (select acctno, sum(qtty) qtty ,sum(amt) amt
                    from stschd where duetype='SS' and status<>'C' and deltd <>'Y'
                    group by acctno) ssts,
                 (SELECT afacctno || codeid seacctno, sum(CASE WHEN isse = 'N' THEN qtty ELSE 0 END) carcvqtty , sum(CASE WHEN isci = 'N' THEN amt ELSE 0 END)  carcvamt, sum(CASE WHEN isci = 'N' THEN aamt ELSE 0 END)  catrfamt
                    FROM caschd where status <>'C' and deltd <> 'Y'
                    group by afacctno , codeid) ca
           WHERE mst.acctno = dtl.afacctno
				 AND sb.codeid = dtl.codeid
				 AND sb.sectype <> '004'
                 AND mst.custid=cf.custid
                 AND dtl.acctno = v.seacctno(+)
                 AND dtl.codeid = instrument.codeid
                 AND cf.custodycd = pv_custodycd
                 AND (dtl.trade + dtl.mortage <> 0 OR sts.rcvqtty <> 0)
                 and dtl.acctno = sts.acctno (+)
                 and dtl.acctno = ssts.acctno (+)
                 and dtl.acctno = ca.seacctno (+)
           group by cf.custodycd,instrument.symbol
		ORDER BY instrument.symbol;
EXCEPTION
    WHEN others THEN
        return;
END;
/

