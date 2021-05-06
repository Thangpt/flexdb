CREATE OR REPLACE FORCE VIEW VW_PORTFOLIO_RPP AS
select '' IS_TRADE, item en_item,item, acctno, custodycd, trade, receiving, secured, basicprice,  costprice,retail,S_REMAINQTTY,
               (basicprice - costprice) * (   trunc(trade) +  trunc(S_REMAINQTTY)+ wft_qtty + receiving_right + receiving_t0 + receiving_t1 + receiving_t2 + receiving_t3) PROFITANDLOSS,     --T2_HoangND edit
                DECODE(round(COSTPRICE),0,0, ROUND((BASICPRICE- round(COSTPRICE))*100/(round(COSTPRICE)+0.00001),2)) PCPL,
                costprice * ( trunc(trade) +  trunc(S_REMAINQTTY)+wft_qtty + receiving_right + receiving_t0 + receiving_t1 + receiving_t2 + receiving_t3) COSTPRICEAMT,
                ( trunc(trade) +  trunc(S_REMAINQTTY)+wft_qtty + receiving_right + receiving_t0 + receiving_t1 + receiving_t2 + receiving_t3) total,--tong cong
                 wft_qtty, --ck cho giao dich
                basicprice * ( trunc(trade) +  trunc(S_REMAINQTTY)+wft_qtty + receiving_right + receiving_t0 + receiving_t1 + receiving_t2 + receiving_t3)  MARKETAMT,--gia tri thi truong
                RECEIVING_RIGHT, receiving_t0, receiving_t1, receiving_t2, receiving_t3, stt

          from(
            select item,acctno, custodycd,sum(case when tradeplace_wft='006' then 0 else trade end) trade,
               sum(case when tradeplace_wft='006' then 0 else receiving end) receiving,
               sum(case when tradeplace_wft='006' then 0 else secured end) secured,SUM(S_execamt) S_execamt,
               sum(case when tradeplace_wft='006' then 0 else S_REMAINQTTY end) S_REMAINQTTY,
             /*max(case when tradeplace_wft='006' then basicprice else basicprice end)  basicprice,*/
                sum(case when tradeplace_wft='006' then 0 else basicprice end)  basicprice,
               max(case when tradeplace_wft='006' then costprice else costprice end)     costprice,
               sum(case when tradeplace_wft='006' then 0 else retail end )     retail,
               sum(case when tradeplace_wft='006' then  trunc(trade) +  trunc(S_REMAINQTTY) + receiving_t0 + receiving_t1 + receiving_t2 + receiving_t3 else 0 end )  wft_qtty, --ck cho giao dich
               sum(RECEIVING_RIGHT)  RECEIVING_RIGHT,
               sum(case when tradeplace_wft='006' then 0 else receiving_t0 end )  receiving_t0,
               sum(case when tradeplace_wft='006' then 0 else receiving_t1 end )  receiving_t1,
               sum(case when tradeplace_wft='006' then 0 else receiving_t2 end) receiving_t2,
               sum(case when tradeplace_wft='006' then 0 else receiving_t3 end) receiving_t3, stt

          from
            (
               SELECT TO_CHAR(SB.SYMBOL) ITEM, SDTL.AFACCTNO ACCTNO, sdtl.CUSTODYCD,
                      sb.tradeplace_wft,
                    SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED+sdtl.WITHDRAW TRADE,
                    SDTL.receiving + nvl(od.B_execqtty_new,0) receiving,       --T2_HoangND
                    nvl(od.REMAINQTTY,0) secured,nvl(od.S_REMAINQTTY,0) S_REMAINQTTY,NVL(OD.S_execamt,0) S_execamt,
                   CASE WHEN nvl( stif.closeprice,0)>0 THEN stif.closeprice ELSE  SEC.BASICPRICE END  BASICPRICE,
                    round((
                        round(nvl(sdtl1.costprice,sdtl.costprice)) -- gia_von_ban_dau ,
                        *(SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED + SDTL.RECEIVING + nvl(sdtl_wft.wft_receiving,0)  + sdtl.secured ) --tong_kl
                        + nvl(od.B_execamt,0) --gia_tri_mua --gia tri khop mua
                        )           /      (SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED+ nvl(sdtl_wft.wft_receiving,0) + sdtl.secured
                        + SDTL.RECEIVING + nvl(od.B_EXECQTTY,0) + 0.000001 )
                        ) as COSTPRICE,
                    fn_getckll_af(sdtl.afacctno, sb.codeid) retail,
                    nvl(od.B_execqtty_new,0) + SDTL.RECEIVING - SDTL.SECURITIES_RECEIVING_T0 - SDTL.SECURITIES_RECEIVING_T1 -SDTL.SECURITIES_RECEIVING_T2 /*+ nvl(sdtl_wft.wft_receiving,0)*/ RECEIVING_RIGHT,      --T2_HoangND
                    SDTL.SECURITIES_RECEIVING_T0 receiving_t0,
                    SDTL.SECURITIES_RECEIVING_T1 receiving_t1,
                    SDTL.SECURITIES_RECEIVING_T2 receiving_t2,
                    SDTL.SECURITIES_RECEIVING_T3 receiving_t3,
                    3 stt

                FROM
                (     select nVL(SB1.Parvalue,SB.Parvalue) Parvalue,  NVL(SB1.TRADEPLACE,SB.TRADEPLACE) TRADEPLACE, NVL(SB.SECTYPE,SB1.SECTYPE) SECTYPE ,SB.CODEID,
                          nvl(sb1.symbol,sb.symbol) symbol, nvl(sb1.CODEID,sb.CODEID) REFCODEID,SB.TRADEPLACE tradeplace_wft
                      from sbsecurities sb, sbsecurities sb1
                      where nvl(sb.refcodeid,' ') = sb1.codeid(+)
                 ) SB , SECURITIES_INFO SEC, BUF_SE_ACCOUNT SDTL
                LEFT JOIN
                (
                    SELECT sb.symbol, se.afacctno||sb.codeid acctno, se.afacctno||nvl(sb.refcodeid,sb.codeid) refacctno,
                        round((
                                round(BUF.costprice) -- gia_von_ban_dau ,
                                *(BUF.TRADE + BUF.DFTRADING + BUF.RESTRICTQTTY + BUF.ABSTANDING + BUF.BLOCKED + BUF.RECEIVING  + nvl(sdtl_wft.wft_receiving,0) - nvl(wft_3380,0) + BUF.secured ) --tong_kl
                                + nvl(od.B_execamt,0) --gia_tri_mua --gia tri khop mua
                              )            /
                              (BUF.TRADE + BUF.DFTRADING + BUF.RESTRICTQTTY + BUF.ABSTANDING + BUF.BLOCKED + nvl(sdtl_wft.wft_receiving,0) - nvl(wft_3380,0) + BUF.secured
                                + BUF.RECEIVING + nvl(od.B_EXECQTTY,0) + 0.000001 )
                            ) AS costprice
                    FROM semast se, sbsecurities sb, buf_se_account buf
                    left join
                    (
                        select seacctno, sum(o.remainqtty) remainqtty, sum(decode(o.exectype , 'NB',  o.execamt ,0 )) B_execamt
                        , sum(decode(o.exectype , 'NB',  o.execqtty ,0 )) B_execqtty, SUM(CASE WHEN o.stsstatus <> 'C' THEN (decode(o.exectype , 'NB',  o.execqtty ,0 )) ELSE 0 END)  B_execqtty_new
                        from odmast o,sysvar sy
                        where deltd <>'Y' and o.exectype in('NS','NB','MS')
                        and sy.GRNAME='SYSTEM' AND SY.VARNAME='CURRDATE'
                        and o.txdate =  TO_DATE(SY.VARVALUE,'DD/MM/RRRR')
                        group by seacctno
                    ) OD on buf.acctno = od.seacctno
                    left join
                    (
                        select afacctno, refcodeid, trade + receiving  wft_receiving , nvl(se.namt,0) wft_3380
                        from  semast sdtl, sbsecurities sb, (select acctno , namt from setran where tltxcd = '3380' and txcd = '0052' and deltd <> 'Y') se
                        where sdtl.codeid = sb.codeid and sb.refcodeid is not null and sdtl.acctno = se.acctno(+)
                    ) sdtl_wft on buf.codeid = sdtl_wft.refcodeid and buf.afacctno = sdtl_wft.afacctno
                    WHERE sb.codeid = se.codeid AND sb.refcodeid IS NOT NULL
                    AND se.afacctno||nvl(sb.refcodeid,sb.codeid) = buf.acctno
                ) sdtl1 ON sdtl.acctno = sdtl1.acctno
                LEFT JOIN
                (
                SELECT TO_NUMBER( STOC.closeprice) closeprice,STOC.symbol
                FROM stockinfor STOC,sysvar sy
                WHERE  sy.GRNAME='SYSTEM' AND SY.VARNAME='CURRDATE'
                AND  to_date(STOC.tradingdate,'dd/mm/rrrr') =   TO_DATE(SY.VARVALUE,'DD/MM/RRRR')
                 ) stif
                ON SDTL.symbol = stif.symbol
                left join
                (select seacctno, sum(o.remainqtty) remainqtty, sum(decode(o.exectype , 'NB',0,  o.remainqtty  )) S_REMAINQTTY,
                 sum(decode(o.exectype , 'NB',  o.execamt ,0 )) B_execamt, sum(decode(o.exectype , 'NB',0,  o.execqtty  )) S_execamt
                    , sum(decode(o.exectype , 'NB',  o.execqtty ,0 )) B_execqtty, SUM(CASE WHEN o.stsstatus <> 'C' THEN (decode(o.exectype , 'NB',  o.execqtty ,0 )) ELSE 0 END)  B_execqtty_new
                from odmast o,sysvar sy
                where deltd <>'Y' and o.exectype in('NS','NB','MS')
                and sy.GRNAME='SYSTEM' AND SY.VARNAME='CURRDATE'
                and o.txdate =   TO_DATE(SY.VARVALUE,'DD/MM/RRRR')
                group by seacctno
                ) OD on sdtl.acctno = od.seacctno
                   left join
                (select afacctno, refcodeid, trade + receiving - SECURITIES_RECEIVING_T1 - SECURITIES_RECEIVING_T2 wft_receiving
                from buf_se_account sdtl, sbsecurities sb
                where sdtl.codeid = sb.codeid and sb.refcodeid is not null
                ) sdtl_wft on sdtl.codeid = sdtl_wft.refcodeid and sdtl.afacctno = sdtl_wft.afacctno
                WHERE  SB.CODEID = SDTL.CODEID
                AND SDTL.CODEID = SEC.CODEID
                and SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED + SDTL.receiving+SDTL.SECURITIES_RECEIVING_T0+SDTL.SECURITIES_RECEIVING_T1+SDTL.SECURITIES_RECEIVING_T2+SDTL.SECURITIES_RECEIVING_T3 + nvl(od.REMAINQTTY,0) >0
            )
             group by      item, acctno, custodycd,stt
             ORDER BY custodycd,acctno,item
             )
;

