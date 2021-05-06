-- Start of DDL Script for View HOSTMSTRADE.V_FO_ACCOUNT_OPN
-- Generated 11/04/2017 3:44:17 PM from HOSTMSTRADE@FLEX_111

CREATE OR REPLACE VIEW v_fo_account_opn (
   acctno,
   actype,
   custid,
   dof,
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
   bod_td,
   bod_balance,
   bod_intbal,
   bod_intacr,
   bod_payable,
   bod_rcasht0,
   bod_rcasht1,
   bod_rcasht2,
   bod_rcasht3,
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
   bod_d_margin_ub )
AS
SELECT  af.acctno, af.actype, af.custid,
        CASE WHEN SUBSTR(cf.custodycd,4,1) = 'P' THEN 'P' ELSE CASE WHEN cf.country = '234' THEN 'D' ELSE 'F' END END  dof,
        cf.custodycd GRNAME, typ.POLICYCD,
        CASE WHEN af.POOLCHK ='N' THEN NULL
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
        af.STATUS, 0 TRFBUYAMT,
        typ.trfbuyext TRFBUYEXT,
        CASE WHEN af.COREBANK='Y'  THEN 'B'
            ELSE 'N' END BANKLINK,
        af.bankacctno BANKACCTNO, af.bankname BANKCODE,
        to_char(nvl(odt.RATE_BRK_S, 0),'990.999') RATE_BRK_S, to_char(NVL(odt.RATE_BRK_B,0),'990.999') RATE_BRK_B,
        to_char(CASE WHEN NVL(typ.vat,'Y') = 'Y' THEN round(NVL(vat.rate_tax,0),4) ELSE 0 END ,'990.999')  rate_tax,
        nvl(ad.ADVRATE, 0) RATE_ADV,
        nvl(af.mrirate, 0) RATIO_INIT,
        nvl(af.mrmrate, 0) RATIO_MAIN,
        nvl(af.mrlrate, 0) RATIO_EXEC,
        0 BOD_NAV,
        0 BOD_SEAMT,
        0 BOD_SEASS,
        0 BOD_ADV,
        0 BOD_DEBT,
        0 BOD_DEBT_M,
        0 BOD_TD,
        0 BOD_BALANCE, 0 BOD_INTBAL,
        0 BOD_INTACR, 0 BOD_PAYABLE,
        0 BOD_RCASHT0,
        0 BOD_RCASHT1,
        0 BOD_RCASHT2,
        0 BOD_RCASHT3,
        0 BOD_RCASHTN,
        0 BOD_SCASHT0,
        0 BOD_SCASHT1,
        0 BOD_SCASHT2,
        0 BOD_SCASHT3,
        0 BOD_SCASHTN,
        af.mrcrlimitmax BOD_CRLIMIT,
        af.advanceline BOD_T0VALUE,
        0 CALC_RATIO, 0 CALC_ADVBAL, 0 CALC_PP0,
        0 CALC_ASSET, 0 CALC_ODRAMT, 0 CALC_TRFBUY, 100-af.mriratio RATE_UB,
        0 bod_d_margin_ub
FROM    afmast af, cfmast cf, aftype typ, lntype lnt, mrtype mr, lnsebasket afsebasket, adtype ad,
       (SELECT ai.aftype, lns.basketid
           FROM afidtype ai, lntype ln , lnsebasket lns
          WHERE ai.actype = ln.actype  AND ai.objname ='LN.LNTYPE' AND ln.actype = lns.actype AND ln.chksysctrl ='Y') bks2,
        (SELECT MIN(prtype) prtype FROM typeidmap WHERE typeid = 'ALL') prall,
        (SELECT typeid, prtype FROM typeidmap WHERE typeid <> 'ALL') prtype,
        (Select TO_BINARY_DOUBLE(varvalue) RATE_TAX from sysvar where grname = 'SYSTEM' AND varname = 'ADVSELLDUTY') vat,
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
          GROUP BY aftype) odt
WHERE   af.custid = cf.custid  --AND af.status = 'A' --AND cf.status = 'A' AND custodycd IS NOT NULL
        AND af.actype = typ.actype AND typ.actype = prtype.typeid (+)
        AND typ.lntype = lnt.actype (+) AND typ.mrtype = mr.actype
        AND typ.lntype = afsebasket.actype (+)
        AND odt.aftype = af.actype
        AND typ.adtype = ad.actype (+)
        AND af.actype = bks2.aftype(+)
/


-- End of DDL Script for View HOSTMSTRADE.V_FO_ACCOUNT_OPN

