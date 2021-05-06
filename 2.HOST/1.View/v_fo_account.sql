-- Start of DDL Script for View HOSTMSTRADE.V_FO_ACCOUNT
-- Generated 11/04/2017 3:43:53 PM from HOSTMSTRADE@FLEX_111

CREATE OR REPLACE VIEW v_fo_account (
   acctno,
   actype,
   grname,
   policycd,
   poolid,
   roomid,
   acclass,
   custodycd,
   formulacd,
   basketid,
   basketid_ub,
   status,
   trfbuyamt,
   trfbuyext,
   banklink,
   bankacctno,
   bankcode,
   rate_brk_s,
   rate_brk_b,
   rate_tax,
   rate_adv,
   ratio_init,
   ratio_main,
   ratio_exec,
   bod_nav,
   bod_seamt,
   bod_seass,
   bod_adv,
   bod_debt,
   bod_debt_m,
   bod_debt_t0,
   bod_d_margin,
   bod_td,
   bod_balance,
   bod_intbal,
   bod_intacr,
   bod_payable,
   bod_rcasht3,
   bod_rcasht2,
   bod_rcasht1,
   bod_rcasht0,
   bod_rcashtn,
   bod_scasht0,
   bod_scasht1,
   bod_scasht2,
   bod_scasht3,
   bod_scashtn,
   bod_crlimit,
   bod_t0value,
   calc_ratio,
   calc_advbal,
   calc_pp0,
   calc_asset,
   calc_odramt,
   calc_trfbuy,
   rate_ub,
   bod_d_margin_ub,
   rate_t0loan,
   bod_deal)
AS
SELECT  af.acctno, af.actype, cf.custodycd GRNAME, typ.POLICYCD,
        CASE WHEN af.POOLCHK ='N' THEN af.acctno
             WHEN af.POOLCHK ='Y' AND NVL(lnt.chksysctrl,'N') = 'Y' THEN 'UB'
             ELSE  'SYSTEM'
         END poolid, CASE WHEN NVL(lnt.chksysctrl,'N') = 'Y' THEN 'UB' ELSE  'SYSTEM' END roomid,
        cf.class ACCLASS, cf.CUSTODYCD,
        CASE WHEN mr.MRTYPE='N' AND af.autoadv='N' THEN 'CASH'
             WHEN mr.MRTYPE='N' AND af.autoadv='Y' THEN 'ADV'
             WHEN mr.MRTYPE='T' AND mr.ISPPUSED='0' THEN 'PP0'
             WHEN mr.MRTYPE='T' AND mr.ISPPUSED='1' THEN 'PPSET0' ELSE 'CASH' END FORMULACD,
        nvl(afsebasket.basketid, 'NONE') BASKETID,
        CASE WHEN NVL(lnt.chksysctrl,'N') = 'Y' OR  bks2.basketid  IS NULL THEN nvl(afsebasket.basketid, 'NONE')
             WHEN  bks2.basketid IS NOT NULL  THEN bks2.basketid
             END basketid_ub,
        af.STATUS, ci.trfbuyamt TRFBUYAMT,
        typ.trfbuyext TRFBUYEXT,
        CASE WHEN af.COREBANK='Y'  THEN 'B'
            ELSE 'N' END BANKLINK,
        af.bankacctno BANKACCTNO, af.bankname BANKCODE,
        nvl(to_char(odt.RATE_BRK_S,'990.999'), 0) RATE_BRK_S, NVL( to_char(odt.RATE_BRK_B,'990.999') ,0) RATE_BRK_B,
        CASE WHEN NVL(typ.vat,'Y') ='Y' THEN  NVL(to_char(vat.rate_tax,'990.999') ,0)
        ELSE '0'
        END  rate_tax,
        to_char(nvl(ad.ADVRATE, 0) + NVL(ad.ADVBANKRATE,0),'990.999')  RATE_ADV,
        nvl(af.mrirate, 0) RATIO_INIT,
        nvl(af.mrmrate, 0) RATIO_MAIN,
        nvl(af.mrlrate, 0) RATIO_EXEC,
        nvl(sem.BOD_NAV, 0) BOD_NAV,
        NVL(v_ci.SEAMT,0) BOD_SEAMT,
        NVL(v_ci.SEASS,0) BOD_SEASS,
        nvl(adv.advanceamount, 0)- nvl(adv.advanceamount_T0, 0) BOD_ADV,
        Round(ci.odamt)  BOD_DEBT,
        CEIL(nvl(v_lnmast.bod_debt_m, 0) + NVL(lnm.intnmlpbl,0) ) BOD_DEBT_M,
        Round(nvl(v_lnmast_BOD.BOD_DEBT_T0, 0) ) BOD_DEBT_T0,
        Round(nvl(v_lnmast_BOD.BOD_D_MARGIN, 0)) BOD_D_MARGIN,
        nvl(td.mortgage, 0) BOD_TD,
        ci.balance BOD_BALANCE, ci.balance BOD_INTBAL,
        Round(ci.crintacr) BOD_INTACR, Ceil(ci.depofeeamt) BOD_PAYABLE,
        Floor(nvl(CASH_RECEIVING_T0,0)) BOD_RCASHT3,
        Floor(nvl(CASH_RECEIVING_T1,0)) BOD_RCASHT2,
        Floor(nvl(CASH_RECEIVING_T2,0)) BOD_RCASHT1,
        Floor(nvl(CASH_RECEIVING_T3,0)) BOD_RCASHT0,
        Floor(nvl(CASH_RECEIVING_TN,0)) BOD_RCASHTN,
        nvl(CASH_SENDING_T0,0) BOD_SCASHT0,
        nvl(CASH_SENDING_T1,0) BOD_SCASHT1,
        nvl(CASH_SENDING_T2,0) BOD_SCASHT2,
        nvl(CASH_SENDING_T3,0) BOD_SCASHT3,
        nvl(ceil(BOD_DEBT_NMLT0),0) BOD_SCASHTN,
        af.mrcrlimitmax BOD_CRLIMIT,
        af.advanceline BOD_T0VALUE,
        0 CALC_RATIO, TRUNC(NVL(advanceamount_T0,0),2) CALC_ADVBAL , 0 CALC_PP0,
        0 CALC_ASSET, 0 CALC_ODRAMT, 0 CALC_TRFBUY, 100-af.mriratio RATE_UB,
        Round(NVL(bod_d_margin_ub,0)) bod_d_margin_ub,
        cf.t0loanrate RATE_T0LOAN, af.deal BOD_DEAL
FROM    afmast af, cfmast cf, cimast ci, aftype typ, lntype lnt, mrtype mr, lnsebasket afsebasket, adtype ad,
        (SELECT ai.aftype, lns.basketid
           FROM afidtype ai, lntype ln , lnsebasket lns
          WHERE ai.actype = ln.actype  AND ai.objname ='LN.LNTYPE' AND ln.actype = lns.actype AND ln.chksysctrl ='Y') bks2,
        v_getsecmargininfo v_ci, (select sum(advamt) advanceamount,sum(advamt_T0) advanceamount_T0,afacctno from v_getAccountAvlAdvance group by afacctno) adv,
        (SELECT MIN(prtype) prtype FROM typeidmap WHERE typeid = 'ALL') prall,
        (SELECT typeid, prtype FROM typeidmap WHERE typeid <> 'ALL') prtype,
        (Select TO_number(varvalue) RATE_TAX from sysvar where grname = 'SYSTEM' AND varname = 'ADVSELLDUTY') vat,
        (SELECT aftype,
                MAX(RATE_BRK_S) RATE_BRK_S,
                MAX(RATE_BRK_B) RATE_BRK_B
           FROM
              (
                  Select a.actype, a.aftype,
                      CASE WHEN b.sectype IN ('000','001','002','011','111','333') THEN b.deffeerate ELSE 0 END RATE_BRK_S,
                      CASE WHEN b.sectype IN ('000','003','006','222','444') THEN b.deffeerate ELSE 0 END RATE_BRK_B
                      from afidtype a, odtype b
                      where b.actype = a.actype and  a.objname = 'OD.ODTYPE'
              )
          GROUP BY aftype) odt,
        (Select a.afacctno, SUM((a.trade + a.mortage) * b.basicprice) BOD_NAV
            from semast a
            INNER JOIN securities_info b ON a.codeid = b.codeid
            Group by a.afacctno) sem,
        (SELECT ceil(SUM(ls.nml + ls.ovd + ls.intdue + ls.intovd + ls.intovdprin + ls.intnmlacr)) bod_debt_m,
                     LN.trfacctno Acctno
                     FROM   lnmast LN, lnschd ls
                     WHERE   LN.acctno = ls.acctno
                       AND ( (reftype IN ('P','GP')  AND overduedate <= (SELECT   TO_DATE ( VARVALUE,'DD/MM/YYYY')
                                                                      FROM   SYSVAR
                                                                     WHERE   GRNAME = 'SYSTEM' AND VARNAME = 'CURRDATE'))
                           )
                       GROUP BY   LN.trfacctno
         ) v_lnmast,
         (SELECT SUM( CASE WHEN reftype IN ('GP')
                      THEN  ls.nml + ls.ovd + ls.intdue + ls.intovd + ls.intovdprin + ls.intnmlacr
                      ELSE 0 END
                      ) BOD_DEBT_T0,
                  SUM( CASE WHEN reftype IN ('P')
                      THEN  ls.nml + ls.ovd + ls.intdue + ls.intovd + ls.intovdprin + ls.intnmlacr
                      ELSE 0 END
                      ) BOD_D_MARGIN,
                  SUM( CASE WHEN reftype IN ('P') AND NVL(lt.chksysctrl,'N') ='Y'
                      THEN  ls.nml + ls.ovd + ls.intdue + ls.intovd + ls.intovdprin + ls.intnmlacr
                      ELSE 0 END
                      ) bod_d_margin_ub,
                  SUM(CASE WHEN reftype IN ('GP') AND ls.overduedate > (SELECT to_date(varvalue,'dd/mm/rrrr')
                                          FROM sysvar WHERE  grname ='SYSTEM' AND  varname ='CURRDATE')
                      THEN  ls.nml + ls.intnmlacr
                      ELSE 0 END
                      ) BOD_DEBT_NMLT0,
                     LN.trfacctno Acctno
                     FROM   lnmast LN, lnschd ls, lntype lt
                     WHERE   LN.acctno = ls.acctno AND ln.actype = lt.actype
                     GROUP BY   LN.trfacctno
         ) v_lnmast_BOD,
        (Select afacctno, SUM(mortgage) mortgage from tdmast where buyingpower = 'Y' group by afacctno ) td,
        (SELECT AFACCTNO,
                    SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.CLEARDAY-ST.TDAY=0 THEN ST.ST_AMT ELSE 0 END,0)) CASH_RECEIVING_T0,
                    SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.CLEARDAY-ST.TDAY=1 THEN ST.ST_AMT ELSE 0 END,0)) CASH_RECEIVING_T1,
                    SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.CLEARDAY-ST.TDAY=2 THEN ST.ST_AMT ELSE 0 END,0)) CASH_RECEIVING_T2,
                    SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.CLEARDAY-ST.TDAY=3 THEN ST.ST_AMT ELSE 0 END,0)) CASH_RECEIVING_T3,
                    SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.CLEARDAY-ST.TDAY>3 THEN ST.ST_AMT ELSE 0 END,0)) CASH_RECEIVING_TN,
                    SUM(NVL(CASE WHEN ST.DUETYPE='SM' AND ST.TRFDAY=0 THEN ST.ST_AMT ELSE 0 END,0)) CASH_SENDING_T0,
                    SUM(NVL(CASE WHEN ST.DUETYPE='SM' AND ST.TRFDAY=1 THEN ST.ST_AMT ELSE 0 END,0)) CASH_SENDING_T1,
                    SUM(NVL(CASE WHEN ST.DUETYPE='SM' AND ST.TRFDAY=2 THEN ST.ST_AMT ELSE 0 END,0)) CASH_SENDING_T2,
                    SUM(NVL(CASE WHEN ST.DUETYPE='SM' AND ST.TRFDAY=3 THEN ST.ST_AMT ELSE 0 END,0)) CASH_SENDING_T3,
                    SUM(NVL(CASE WHEN ST.DUETYPE='SM' AND ST.TRFDAY>3 THEN ST.ST_AMT ELSE 0 END,0)) CASH_SENDING_TN,
                    SUM(NVL(CASE WHEN ST.DUETYPE='SM' AND ST.TRFDAY>=1 AND ST.TRFDAY<=3 AND ST.TXDATE < ST.CURRDATE THEN ST.FEEACR ELSE 0 END,0)) BUY_FEEACR,
                    sum(NVL(CASE WHEN ST.DUETYPE='SM' AND ST.TRFDAY=1 THEN ST.EXECAMTINDAY ELSE 0 END,0)) EXECAMTINDAY,
                    SUM(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=2 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT+ST.ST_PAIDAMT+ST.ST_PAIDFEEAMT-ST.FEEACR-ST.TAXSELLAMT ELSE 0 END) avladv_t1,
                    SUM(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=1 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT+ST.ST_PAIDAMT+ST.ST_PAIDFEEAMT-ST.FEEACR-ST.TAXSELLAMT ELSE 0 END) avladv_t2,
                    SUM(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=0 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT+ST.ST_PAIDAMT+ST.ST_PAIDFEEAMT-ST.FEEACR-ST.TAXSELLAMT ELSE 0 END) avladv_t3
                FROM
                    VW_BD_PENDING_SETTLEMENT ST WHERE (DUETYPE='RM' OR DUETYPE='SM' OR DUETYPE = 'RS')
                GROUP BY AFACCTNO) ST,
                (SELECT sum(intnmlpbl) intnmlpbl, trfacctno afacctno FROM lnmast GROUP BY trfacctno) lnm
WHERE   af.custid = cf.custid AND af.status IN  ('A','P') AND cf.custodycd IS NOT NULL
        AND af.actype = typ.actype AND typ.actype = prtype.typeid (+)
        AND typ.lntype = lnt.actype (+) AND typ.mrtype = mr.actype
        AND typ.lntype = afsebasket.actype (+)
        AND af.acctno = ci.acctno AND odt.aftype = af.actype
        AND typ.adtype = ad.actype (+) AND af.acctno = sem.afacctno (+)
        AND af.acctno = v_ci.afacctno (+) AND af.acctno = adv.afacctno (+)
        AND af.acctno = v_lnmast.Acctno (+) AND af.acctno = v_lnmast_BOD.Acctno (+)
        AND af.acctno = td.afacctno (+) AND af.acctno = st.afacctno (+)
        AND af.acctno = lnm.afacctno(+)
        AND af.actype = bks2.aftype(+)
        --and af.isfo ='Y'
/


-- End of DDL Script for View HOSTMSTRADE.V_FO_ACCOUNT

