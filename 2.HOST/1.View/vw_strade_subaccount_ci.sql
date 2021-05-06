CREATE OR REPLACE FORCE VIEW VW_STRADE_SUBACCOUNT_CI
(custid, custodycd, cash_on_hand, outstanding, availcash, purchasingpower, avail_advanced_bal, advanced_balance, pending_advanced_bal, org_cash_receiving_t0, org_cash_receiving_t1, org_cash_receiving_t2, org_cash_receiving_t3, org_cash_receiving_tn, cash_adv_receiving_t0, cash_adv_receiving_t1, cash_adv_receiving_t2, cash_adv_receiving_t3, cash_adv_receiving_tn, cash_receiving_t0, cash_receiving_t1, cash_receiving_t2, cash_receiving_t3, cash_receiving_tn, cash_sending_t0, cash_sending_t1, cash_sending_t2, cash_sending_t3, cash_sending_tn, avail_advance_t1, avail_advance_t2, avail_advance_t3, ca_receving_cash_dividend, last_change)
AS
SELECT CF.CUSTID, CF.CUSTODYCD, SUM(nvl(MST.BALANCE,0))-MAX(NVL(REFORDER.SECUREAMT,0)) CASH_ON_HAND, SUM(nvl(MST.ODAMT,0)) OUTSTANDING,
SUM(nvl(MST.BALANCE,0))-SUM(NVL(REFORDER.SECUREAMT,0))+SUM(nvl(adv.PPAVLADVANCE,0)) - sum(nvl(mst.odamt,0)) - sum(nvl(dfintdebtamt,0)) - sum(nvl(dfdebtamt,0)) AVAILCASH,
SUM(nvl(MST.BALANCE,0))-SUM(NVL(REFORDER.SECUREAMT,0))+SUM(nvl(adv.PPAVLADVANCE,0)) + SUM(nvl(af.advanceline,0)) - sum(nvl(mst.odamt,0)) - sum(nvl(dfintdebtamt,0)) - sum(nvl(dfdebtamt,0)) PURCHASINGPOWER,
SUM(NVL(AVLADVANCE,0)), SUM(NVL(ADVANCED_BALANCE,0)), 0 PENDING_ADVANCED_BAL,
SUM(NVL(ORG_CASH_RECEIVING_T0,0)),SUM(NVL(ORG_CASH_RECEIVING_T1,0)), SUM(NVL(ORG_CASH_RECEIVING_T2,0)), SUM(NVL(ORG_CASH_RECEIVING_T3,0)),SUM(NVL(ORG_CASH_RECEIVING_TN,0)),
SUM(NVL(CASH_ADV_RECEIVING_T0,0)),SUM(NVL(CASH_ADV_RECEIVING_T1,0)), SUM(NVL(CASH_ADV_RECEIVING_T2,0)), SUM(NVL(CASH_ADV_RECEIVING_T3,0)),SUM(NVL(CASH_ADV_RECEIVING_TN,0)),
SUM(NVL(CASH_RECEIVING_T0,0)),SUM(NVL(CASH_RECEIVING_T1,0)), SUM(NVL(CASH_RECEIVING_T2,0)), SUM(NVL(CASH_RECEIVING_T3,0)),SUM(NVL(CASH_RECEIVING_TN,0)),
SUM(NVL(CASH_SENDING_T0,0)), SUM(NVL(CASH_SENDING_T1,0)), SUM(NVL(CASH_SENDING_T2,0)), SUM(NVL(CASH_SENDING_T3,0)),
SUM(NVL(CASH_SENDING_TN,0)),SUM(NVL(AVAIL_ADVANCE_T1,0)), SUM(NVL(AVAIL_ADVANCE_T2,0)), SUM(NVL(AVAIL_ADVANCE_T3,0)), sum(nvl(carcv.amt,0)) CA_RECEVING_CASH_DIVIDEND,
max(MST.last_change) last_change
FROM        CIMAST MST, AFMAST AF, CFMAST CF, aftype aftyp, mrtype mr,
            (SELECT     AFACCTNO,
                        SUM(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY<=3 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END) AVAIL_ADVANCED_BAL,
                        SUM(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY<=3 THEN ST.ST_AAMT ELSE 0 END) ADVANCED_BALANCE,
                        SUM(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=0 THEN ST.ST_AMT ELSE 0 END) ORG_CASH_RECEIVING_T0, --tong so tien ban cho ve T0
                        SUM(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=1 THEN ST.ST_AMT ELSE 0 END) ORG_CASH_RECEIVING_T1, --tong so tien ban cho ve T1
                        SUM(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=2 THEN ST.ST_AMT ELSE 0 END) ORG_CASH_RECEIVING_T2, --tong so tien ban cho ve T2
                        SUM(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=3 THEN ST.ST_AMT ELSE 0 END) ORG_CASH_RECEIVING_T3, --tong so tien ban cho ve T3
                        SUM(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY>3 THEN ST.ST_AMT ELSE 0 END) ORG_CASH_RECEIVING_TN, --tong so tien ban cho ve TN
                        SUM(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=0 THEN ST.ST_AAMT+ST.ST_FAMT ELSE 0 END) CASH_ADV_RECEIVING_T0, --tong so tien UT tren cho ve T0
                        SUM(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=1 THEN ST.ST_AAMT+ST.ST_FAMT ELSE 0 END) CASH_ADV_RECEIVING_T1, --tong so tien UT tren cho ve T1
                        SUM(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=2 THEN ST.ST_AAMT+ST.ST_FAMT ELSE 0 END) CASH_ADV_RECEIVING_T2, --tong so tien UT tren cho ve T2
                        SUM(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=3 THEN ST.ST_AAMT+ST.ST_FAMT ELSE 0 END) CASH_ADV_RECEIVING_T3, --tong so tien UT tren cho ve T3
                        SUM(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY>3 THEN ST.ST_AAMT+ST.ST_FAMT ELSE 0 END) CASH_ADV_RECEIVING_TN, --tong so tien UT tren cho ve TN
                        SUM(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=0 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END) CASH_RECEIVING_T0, --tong so cho ve T0 con lai
                        SUM(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=1 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END) CASH_RECEIVING_T1, --tong so cho ve T1 con lai
                        SUM(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=2 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END) CASH_RECEIVING_T2, --tong so cho ve T2 con lai
                        SUM(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=3 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END) CASH_RECEIVING_T3, --tong so cho ve T3 con lai
                        SUM(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY>3 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END) CASH_RECEIVING_TN, --tong so cho ve TN con lai
                        SUM(CASE WHEN ST.DUETYPE='SM' AND ST.TDAY=0 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END) CASH_SENDING_T0,
                        SUM(CASE WHEN ST.DUETYPE='SM' AND ST.TDAY=1 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END) CASH_SENDING_T1,
                        SUM(CASE WHEN ST.DUETYPE='SM' AND ST.TDAY=2 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END) CASH_SENDING_T2,
                        SUM(CASE WHEN ST.DUETYPE='SM' AND ST.TDAY=3 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END) CASH_SENDING_T3,
                        SUM(CASE WHEN ST.DUETYPE='SM' AND ST.TDAY>3 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END) CASH_SENDING_TN
            FROM        VW_STRADE_PENDING_SETTLEMENT ST
            WHERE       DUETYPE='RM' OR DUETYPE='SM'
            GROUP BY    AFACCTNO) ST, V_GETBUYORDERINFO REFORDER,
            (SELECT     AFACCTNO,
                        SUM(DECODE(ST.TDAY,1, DEPOAMT, 0)) AVAIL_ADVANCE_T1,
                        SUM(DECODE(ST.TDAY,2, DEPOAMT, 0)) AVAIL_ADVANCE_T2,
                        SUM(DECODE(ST.TDAY,3, DEPOAMT, 0)) AVAIL_ADVANCE_T3,
                        SUM(DEPOAMT) - fn_getdealpaid(afacctno) PPAVLADVANCE,
                        SUM(DEPOAMT) AVLADVANCE
            FROM        v_getaccountavladvance_TDAY ST
            GROUP BY    AFACCTNO) adv,
            (SELECT cas.afacctno , SUM(CASE WHEN isci='N' THEN amt ELSE 0 END) amt
            FROM caschd cas, camast ca
            WHERE ca.camastid = cas.camastid AND ca.catype in ('010','011')
            AND cas.status <> 'C' AND cas.deltd <> 'Y'
            GROUP BY cas.afacctno) carcv
WHERE   MST.AFACCTNO=AF.ACCTNO AND AF.CUSTID=CF.CUSTID AND MST.AFACCTNO=ST.AFACCTNO (+)
        AND MST.AFACCTNO=REFORDER.AFACCTNO (+)
        and mst.afacctno=adv.AFACCTNO (+)
        AND mst.afacctno= carcv.afacctno (+)
        and af.actype=aftyp.actype and aftyp.mrtype=mr.actype
        and mr.mrtype in ('N','L')
GROUP BY CF.CUSTID, CF.CUSTODYCD
;
