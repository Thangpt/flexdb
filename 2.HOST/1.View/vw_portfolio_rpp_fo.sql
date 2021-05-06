CREATE OR REPLACE FORCE VIEW VW_PORTFOLIO_RPP_FO AS
SELECT
   is_trade,
   en_item,
   item,
   acctno,
   custodycd,
   trade,
   receiving,
   secured,
   basicprice,
   costprice,
   retail,
   s_remainqtty,
   profitandloss,
   pcpl,
   costpriceamt,
   total,
   wft_qtty,
   marketamt,
   receiving_right,
   receiving_t0,
   receiving_t1,
   receiving_t2,
   receiving_t3,
   stt
   FROM
(
SELECT '' IS_TRADE, ITEM EN_ITEM,ITEM, ACCTNO, CUSTODYCD, TRADE, RECEIVING,
       SECURED,
       BASICPRICE,
       COSTPRICE,
       RETAIL,
       S_REMAINQTTY,
       (BASICPRICE - COSTPRICE) *
           (TRUNC(TRADE) +  TRUNC(S_REMAINQTTY)+ WFT_QTTY +
            RECEIVING_RIGHT + RECEIVING_T0 + RECEIVING_T1 +
            RECEIVING_T2 + RECEIVING_T3
            ) PROFITANDLOSS,
        DECODE(ROUND(COSTPRICE),
        0,
        0,
        ROUND((BASICPRICE- ROUND(COSTPRICE))*100/(ROUND(COSTPRICE)+0.00001),2)) PCPL,
        COSTPRICE * (
                     TRUNC(TRADE) +  TRUNC(S_REMAINQTTY)+WFT_QTTY + RECEIVING_RIGHT + RECEIVING_T0 +
                     RECEIVING_T1 + RECEIVING_T2 + RECEIVING_T3
                     ) COSTPRICEAMT,
        (
        TRUNC(TRADE) +  TRUNC(S_REMAINQTTY)+ WFT_QTTY + RECEIVING_RIGHT + RECEIVING_T0 +
        RECEIVING_T1 + RECEIVING_T2 + RECEIVING_T3) TOTAL,
        WFT_QTTY,
        BASICPRICE * (TRUNC(TRADE) +  TRUNC(S_REMAINQTTY)+WFT_QTTY + RECEIVING_RIGHT +
                      RECEIVING_T0 + RECEIVING_T1 + RECEIVING_T2 + RECEIVING_T3)  MARKETAMT,
        RECEIVING_RIGHT,
        RECEIVING_T0,
        RECEIVING_T1,
        RECEIVING_T2,
        RECEIVING_T3,
        STT

  FROM(
    SELECT ITEM,ACCTNO, CUSTODYCD,
       SUM(CASE WHEN TRADEPLACE_WFT='006' THEN 0 ELSE TRADE -S_SECURED END) TRADE,
       SUM(CASE WHEN TRADEPLACE_WFT='006' THEN 0 ELSE RECEIVING END) RECEIVING,
       SUM(CASE WHEN TRADEPLACE_WFT='006' THEN 0 ELSE SECURED END) SECURED,
       SUM(S_EXECAMT) S_EXECAMT,
       SUM(CASE WHEN TRADEPLACE_WFT='006' THEN 0 ELSE S_REMAINQTTY END) S_REMAINQTTY,
       MAX(CASE WHEN TRADEPLACE_WFT='006' THEN BASICPRICE ELSE BASICPRICE END)  BASICPRICE,
       MAX(CASE WHEN TRADEPLACE_WFT='006' THEN COSTPRICE ELSE COSTPRICE END)     COSTPRICE,
       SUM(CASE WHEN TRADEPLACE_WFT='006' THEN 0 ELSE RETAIL END )     RETAIL,
       SUM(CASE WHEN TRADEPLACE_WFT='006' THEN  TRUNC(TRADE) +  TRUNC(S_REMAINQTTY) + RECEIVING_T0 +
                                          RECEIVING_T1 + RECEIVING_T2 + RECEIVING_T3 ELSE 0 END )  WFT_QTTY,
       SUM(RECEIVING_RIGHT)  RECEIVING_RIGHT,
       SUM(CASE WHEN TRADEPLACE_WFT='006' THEN 0 ELSE RECEIVING_T0 END )  RECEIVING_T0,
       SUM(CASE WHEN TRADEPLACE_WFT='006' THEN 0 ELSE RECEIVING_T1 END )  RECEIVING_T1,
       SUM(CASE WHEN TRADEPLACE_WFT='006' THEN 0 ELSE RECEIVING_T2 END) RECEIVING_T2,
       SUM(CASE WHEN TRADEPLACE_WFT='006' THEN 0 ELSE RECEIVING_T3 END) RECEIVING_T3, STT

      FROM
         (
            SELECT TO_CHAR(SB.SYMBOL) ITEM, SDTL.AFACCTNO ACCTNO, SDTL.CUSTODYCD,
              SB.TRADEPLACE_WFT,
              (CASE  WHEN SB.TRADEPLACE_WFT <> '006' THEN NVL(P_FO.TRADE,0)
                   ELSE  SDTL.TRADE  + sdtl.secured END) + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED+SDTL.WITHDRAW TRADE,
              SDTL.RECEIVING + NVL(OD.B_EXECQTTY_NEW,0) RECEIVING,
              NVL(OD.S_REMAINQTTY,0) + NVL(OD.S_EXEC_QTTY,0) S_SECURED,
              NVL(OD.REMAINQTTY,0) SECURED,
              NVL(OD.S_REMAINQTTY,0) S_REMAINQTTY,
              NVL(OD.S_EXECAMT,0) S_EXECAMT,
              CASE WHEN NVL( STIF.CLOSEPRICE,0)>0 THEN STIF.CLOSEPRICE ELSE  SEC.BASICPRICE END  BASICPRICE,
            ROUND((
                ROUND(NVL(SDTL1.COSTPRICE,SDTL.COSTPRICE))
                *(
                  (CASE  WHEN SB.TRADEPLACE_WFT <> '006' THEN NVL(P_FO.TRADE,0)
                   ELSE  SDTL.TRADE  + sdtl.secured END)  + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED +
                  SDTL.RECEIVING + NVL(SDTL_WFT.WFT_RECEIVING,0))
                  + NVL(OD.B_EXECAMT,0)
                ) /
                (
                 (CASE  WHEN SB.TRADEPLACE_WFT <> '006' THEN NVL(P_FO.TRADE,0)
                   ELSE  SDTL.TRADE  + sdtl.secured END) + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED+ NVL(SDTL_WFT.WFT_RECEIVING,0)
                 + SDTL.RECEIVING + NVL(OD.B_EXECQTTY,0) + 0.000001 )
                ) AS COSTPRICE,
            FN_GETCKLL_AF(SDTL.AFACCTNO, SB.CODEID) RETAIL,
            SDTL.RECEIVING - SDTL.SECURITIES_RECEIVING_T0 - SDTL.SECURITIES_RECEIVING_T1 RECEIVING_RIGHT,
            SDTL.SECURITIES_RECEIVING_T0 RECEIVING_T0,
            SDTL.SECURITIES_RECEIVING_T1 RECEIVING_T1,
            --SDTL.SECURITIES_RECEIVING_T2 RECEIVING_T2,
            nvl(P_FO.BOD_RT2,0) + nvl(PEX_FO.bod_rt3,0) RECEIVING_T2,
            SDTL.SECURITIES_RECEIVING_T3 RECEIVING_T3,
            3 STT

            FROM
                 (
                 SELECT NVL(SB1.PARVALUE,SB.PARVALUE) PARVALUE,  NVL(SB1.TRADEPLACE,SB.TRADEPLACE) TRADEPLACE, NVL(SB.SECTYPE,SB1.SECTYPE) SECTYPE ,SB.CODEID,
                 NVL(SB1.SYMBOL,SB.SYMBOL) SYMBOL, NVL(SB1.CODEID,SB.CODEID) REFCODEID,SB.TRADEPLACE TRADEPLACE_WFT
                 FROM SBSECURITIES SB, SBSECURITIES SB1
                 WHERE NVL(SB.REFCODEID,' ') = SB1.CODEID(+)
                 ) SB , SECURITIES_INFO SEC, BUF_SE_ACCOUNT SDTL
                 LEFT JOIN
                    (
                        SELECT SB.SYMBOL, SE.AFACCTNO||SB.CODEID ACCTNO, SE.AFACCTNO||NVL(SB.REFCODEID,SB.CODEID) REFACCTNO,
                                ROUND((
                                        ROUND(BUF.COSTPRICE)
                                        *(
                                           ( BUF.TRADE  + BUF.secured
                                                 )
                                               + BUF.DFTRADING + BUF.RESTRICTQTTY + BUF.ABSTANDING +
                                           BUF.BLOCKED + BUF.RECEIVING  + NVL(SDTL_WFT.WFT_RECEIVING,0) - NVL(WFT_3380,0)
                                          )
                                        + NVL(OD.B_EXECAMT,0)
                                      )/
                                      (
                                        ( BUF.TRADE  + BUF.secured
                                                 ) +
                                        BUF.DFTRADING + BUF.RESTRICTQTTY + BUF.ABSTANDING + BUF.BLOCKED + NVL(SDTL_WFT.WFT_RECEIVING,0) - NVL(WFT_3380,0) +
                                        + BUF.RECEIVING + NVL(OD.B_EXECQTTY,0) + 0.000001
                                      )
                                    ) AS COSTPRICE
                        FROM SEMAST SE, SBSECURITIES SB, BUF_SE_ACCOUNT BUF
                        LEFT JOIN
                        (

                          SELECT acctno, symbol,
                               SUM(o.REMAIN_QTTY) REMAINQTTY,
                               SUM(o.EXEC_QTTY) B_EXECQTTY,
                               SUM(o.EXEC_AMT)  B_EXECAMT,
                               SUM(o.EXEC_QTTY) B_EXECQTTY_NEW
                           FROM orders@dbl_fo o
                           WHERE  subside IN ('NB','AB')
                           GROUP BY acctno, symbol
                        ) OD ON BUF.AFACCTNO = OD.acctno AND BUF.SYMBOL = OD.SYMBOL
                        LEFT JOIN
                        (
                            SELECT AFACCTNO, REFCODEID, TRADE + RECEIVING  WFT_RECEIVING , NVL(SE.NAMT,0) WFT_3380
                            FROM  SEMAST SDTL, SBSECURITIES SB, (SELECT ACCTNO , NAMT FROM SETRAN WHERE TLTXCD = '3380' AND TXCD = '0052' AND DELTD <> 'Y') SE
                            WHERE SDTL.CODEID = SB.CODEID AND SB.REFCODEID IS NOT NULL AND SDTL.ACCTNO = SE.ACCTNO(+)
                        ) SDTL_WFT

                        ON BUF.CODEID = SDTL_WFT.REFCODEID AND BUF.AFACCTNO = SDTL_WFT.AFACCTNO
                        WHERE SB.CODEID = SE.CODEID AND SB.REFCODEID IS NOT NULL
                          AND SE.AFACCTNO||NVL(SB.REFCODEID,SB.CODEID) = BUF.ACCTNO

              ) SDTL1
              ON SDTL.ACCTNO = SDTL1.ACCTNO
        LEFT JOIN
            (
            SELECT TO_NUMBER( STOC.CLOSEPRICE) CLOSEPRICE,STOC.SYMBOL
            FROM STOCKINFOR STOC,SYSVAR SY
            WHERE  SY.GRNAME='SYSTEM' AND SY.VARNAME='CURRDATE'
            AND  STOC.TRADINGDATE = SY.VARVALUE
             ) STIF
            ON REPLACE(SDTL.SYMBOL,'_WFT','') = STIF.SYMBOL
        LEFT JOIN
            (
             /*
             SELECT SEACCTNO,
                    SUM(O.REMAINQTTY) REMAINQTTY,
                    SUM(DECODE(O.EXECTYPE, 'NB',0, O.REMAINQTTY  )) S_REMAINQTTY,
                    SUM(DECODE(O.EXECTYPE , 'NB',  O.EXECAMT ,0 )) B_EXECAMT,
                    SUM(DECODE(O.EXECTYPE , 'NB',  0, O.EXECQTTY  )) S_EXECAMT,
                    SUM(DECODE(O.EXECTYPE , 'NB',  O.EXECQTTY ,0 )) B_EXECQTTY,
                    SUM(CASE WHEN O.STSSTATUS <> 'C' THEN (DECODE(O.EXECTYPE , 'NB',  O.EXECQTTY ,0 )) ELSE 0 END)  B_EXECQTTY_NEW
            FROM ODMAST O,SYSVAR SY
            WHERE DELTD <>'Y' AND O.EXECTYPE IN('NS','NB','MS')
            AND SY.GRNAME='SYSTEM' AND SY.VARNAME='CURRDATE'
            AND O.TXDATE =   TO_DATE(SY.VARVALUE,'DD/MM/RRRR')
            GROUP BY SEACCTNO
            */
            SELECT acctno, symbol,
                               SUM(o.REMAIN_QTTY) REMAINQTTY,
                               SUM(CASE WHEN subside IN ('NS','AS') THEN o.REMAIN_QTTY ELSE 0 END)  S_REMAINQTTY,
                               SUM(CASE WHEN subside IN ('NS','AS') THEN o.EXEC_QTTY ELSE 0 END)  S_EXEC_QTTY,
                               SUM(CASE WHEN subside IN ('NB','AB') THEN o.EXEC_AMT ELSE 0 END)  B_EXECAMT,
                               SUM(CASE WHEN subside IN ('NS','AS') THEN o.EXEC_AMT ELSE 0 END)  S_EXECAMT,
                               SUM(CASE WHEN subside IN ('NB','AB') THEN o.EXEC_QTTY ELSE 0 END)  B_EXECQTTY,
                               SUM(CASE WHEN subside IN ('NB','AB') THEN o.EXEC_QTTY ELSE 0 END)  B_EXECQTTY_NEW
                           FROM orders@dbl_fo o
                           WHERE  subside IN ('NB','AB','NS','AS')
                           GROUP BY acctno, symbol
            ) OD
            ON SDTL.AFACCTNO = OD.acctno AND SDTL.SYMBOL = OD.SYMBOL
        LEFT JOIN
            (SELECT AFACCTNO, REFCODEID, TRADE + RECEIVING - SECURITIES_RECEIVING_T1 - SECURITIES_RECEIVING_T2 WFT_RECEIVING
            FROM BUF_SE_ACCOUNT SDTL, SBSECURITIES SB
            WHERE SDTL.CODEID = SB.CODEID AND SB.REFCODEID IS NOT NULL
            ) SDTL_WFT
          ON SDTL.CODEID = SDTL_WFT.REFCODEID
            AND SDTL.AFACCTNO = SDTL_WFT.AFACCTNO
         LEFT JOIN
                 PORTFOLIOS@DBL_FO P_FO
          ON SDTL.AFACCTNO =P_FO.ACCTNO AND SDTL.SYMBOL = P_FO.SYMBOL
         LEFT JOIN
                 PORTFOLIOSEX@DBL_FO PEX_FO
          ON SDTL.AFACCTNO =PEX_FO.ACCTNO AND SDTL.SYMBOL = PEX_FO.SYMBOL
        WHERE  SB.CODEID = SDTL.CODEID
        AND SDTL.CODEID = SEC.CODEID
        AND SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY +
        SDTL.ABSTANDING + SDTL.BLOCKED + SDTL.RECEIVING+SDTL.SECURITIES_RECEIVING_T0+
        SDTL.SECURITIES_RECEIVING_T1+SDTL.SECURITIES_RECEIVING_T2+
        SDTL.SECURITIES_RECEIVING_T3 + NVL(OD.REMAINQTTY,0) + nvl(OD.B_EXECQTTY,0) >0
 )
 GROUP BY ITEM, ACCTNO, CUSTODYCD,STT
 )
 UNION ALL
 SELECT '' IS_TRADE, ITEM EN_ITEM,ITEM, ACCTNO, CUSTODYCD,   TRADE TRADE, 0 RECEIVING,
       0 SECURED,
       BASICPRICE,
       COSTPRICE,
       0 RETAIL,
       0 S_REMAINQTTY,
       0 PROFITANDLOSS,
       0 PCPL,
       COSTPRICE * RECEIVING_T2 COSTPRICEAMT,
       TRADE + RECEIVING_T2 TOTAL,
       0 WFT_QTTY,
       BASICPRICE * (RECEIVING_T2 + TRADE)  MARKETAMT,
       0 RECEIVING_RIGHT,
       0 RECEIVING_T0,
       0 RECEIVING_T1,
       RECEIVING_T2,
       0 RECEIVING_T3,
       3 STT
FROM
(

  SELECT a.ACCTNO, a.CUSTODYCD, p_fo.SYMBOL ITEM, SUM(nvl(P_FO.BOD_RT2,0) + nvl(PEX_FO.bod_rt3,0)) RECEIVING_T2, nvl(P_FO.trade,0) TRADE,
  MAX(COSTPRICE) COSTPRICE,
  MAX(CASE WHEN NVL( STIF.CLOSEPRICE,0)>0 THEN STIF.CLOSEPRICE ELSE  SEC.BASICPRICE END)  BASICPRICE
  FROM accounts@dbl_fo a, portfolios@dbl_fo P_FO, PORTFOLIOSEX@DBL_FO PEX_FO,
    (
        SELECT acctno, symbol,
                                   SUM(o.REMAIN_QTTY) REMAINQTTY,
                                   SUM(CASE WHEN subside IN ('NS','AS') THEN o.REMAIN_QTTY ELSE 0 END)  S_REMAINQTTY,
                                   SUM(CASE WHEN subside IN ('NS','AS') THEN o.EXEC_QTTY ELSE 0 END)  S_EXEC_QTTY,
                                   SUM(CASE WHEN subside IN ('NB','AB') THEN o.EXEC_AMT ELSE 0 END)  B_EXECAMT,
                                   SUM(CASE WHEN subside IN ('NS','AS') THEN o.EXEC_AMT ELSE 0 END)  S_EXECAMT,
                                   SUM(CASE WHEN subside IN ('NB','AB') THEN o.EXEC_QTTY ELSE 0 END)  B_EXECQTTY,
                                   SUM(CASE WHEN subside IN ('NB','AB') THEN o.EXEC_QTTY ELSE 0 END)  B_EXECQTTY_NEW,
                                   MAX(exec_amt/decode(exec_qtty,0,1,exec_qtty)) COSTPRICE
                               FROM orders@dbl_fo o
                               WHERE  subside IN ('NB','AB','NS','AS')
                               GROUP BY acctno, symbol
              ) OD,
        (
            SELECT TO_NUMBER( STOC.CLOSEPRICE) CLOSEPRICE,STOC.SYMBOL
            FROM STOCKINFOR STOC,SYSVAR SY
            WHERE  SY.GRNAME='SYSTEM' AND SY.VARNAME='CURRDATE'
            AND  STOC.TRADINGDATE = SY.VARVALUE
         ) STIF, securities_info  sec

    WHERE
    NOT EXISTS (SELECT * FROM buf_se_account b WHERE b.afacctno  = P_FO.acctno AND b.symbol = P_FO.symbol)
    AND P_FO.acctno  = PEX_FO.acctno(+) AND  P_FO.symbol  = PEX_FO.symbol(+)
    AND P_FO.ACCTNO = OD.acctno(+) AND P_FO.SYMBOL = OD.SYMBOL(+)
    AND a.acctno = P_FO.acctno
    AND P_FO.SYMBOL = STIF.SYMBOL(+)
    AND P_FO.SYMBOL = SEC.SYMBOL(+)
    GROUP BY a.ACCTNO, a.CUSTODYCD, P_FO.SYMBOL,P_FO.TRADE
)
 ORDER BY CUSTODYCD,ACCTNO,ITEM
 )
;

