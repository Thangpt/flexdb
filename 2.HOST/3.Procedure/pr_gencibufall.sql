CREATE OR REPLACE PROCEDURE pr_gencibufall is
    v_FOMODE VARCHAR2(10);
BEGIN
    delete from buf_ci_account;

    BEGIN
       SELECT varvalue INTO v_FOMODE FROM sysvar WHERE varname = 'FOMODE';
    EXCEPTION WHEN OTHERS THEN
       v_FOMODE := 'OFF';
    END;


    INSERT INTO buf_ci_account
        (CUSTODYCD,ACTYPE,AFACCTNO,DESC_STATUS,LASTDATE,
        BALANCE,INTBALANCE,DFDEBTAMT,CRINTACR,AAMT,BAMT,
        EMKAMT,FLOATAMT,ODAMT,RECEIVING, NETTING, AVLADVANCE,MBLOCK,APMT,PAIDAMT,
        ADVANCELINE,ADVLIMIT,MRIRATE,MRMRATE,MRLRATE,DEALPAIDAMT,
        AVLWITHDRAW,BALDEFOVD,PP,AVLLIMIT,NAVACCOUNT,OUTSTANDING,
        MARGINRATE,CIDEPOFEEACR,OVDCIDEPOFEE,
        CASH_RECEIVING_T0,CASH_RECEIVING_T1,CASH_RECEIVING_T2,CASH_RECEIVING_T3,CASH_RECEIVING_TN,
        CASH_SENDING_T0,CASH_SENDING_T1,CASH_SENDING_T2,CASH_SENDING_T3,CASH_SENDING_TN,CAREBY,
        MRODAMT,T0ODAMT,DFODAMT,ACCOUNTTYPE,EXECBUYAMT,AUTOADV,AVLADV_T3,AVLADV_T1,AVLADV_T2,
        CASH_PENDWITHDRAW,CASH_PENDTRANSFER,CASH_PENDING_SEND, PPREF,BALDEFTRFAMT,
        CASHT2_SENDING_T0,CASHT2_SENDING_T1,CASHT2_SENDING_T2,CARECEIVING,
        --PhuongHT add ngay 01.03.2016
        trfbuyamt_over,set0amt, rlsmarginrate_ex,
        NYOVDAMT, marginrate_Ex,
        semaxtotalcallass, secallass,
        CLAMT,navaccountt2_EX,
        outstanding_EX,
        navaccount_ex, MARGINRATE5,
        outstanding5,ODAMT_EX,
        outstandingT2_EX,
        semaxcallass,
        secureamt_inday,
        trfsecuredamt_inday,
        avladvance_EX
        --end of PhuongHT add ngay 01.03.2016
        ,fowithdraw -- 1.5.9.0|iss:2066
        ,tax_sell_sending, fee_sell_sending
        )

    SELECT
        cf.CUSTODYCD, buf.actype actype, mst.afacctno, cd1.cdcontent desc_status,buf.lastdate lastdate,
        buf.balance balance,
        mst.balance intbalance, buf.dfdebtamt DFDEBTAMT,
        buf.crintacr crintacr, buf.aamt aamt,
        buf.bamt bamt, mst.emkamt,mst.floatamt,
        mst.odamt, mst.receiving, mst.netting,trunc(buf.advanceamount) avlAdvance, mst.mblock,
        trunc(buf.advanceamount) apmt,buf.paidamt paidamt,
        buf.advanceline,nvl(af.mrcrlimitmax,0) advlimit, af.mrirate,af.mrmrate,af.mrlrate,
        buf.dealpaidamt dealpaidamt,
        buf.baldefovd avlwithdraw,
        buf.baldefovd baldefovd,
        buf.pp pp,
        buf.avllimit avllimit,
        buf.navaccount  NAVACCOUNT,
        buf.OUTSTANDING OUTSTANDING,
        buf.marginrate,
/*        round((case when mst.balance+buf.avladvance- mst.odamt- mst.dfdebtamt - mst.dfintdebtamt
                        -buf.bamt - mst.ramt-nvl(mst.depofeeamt,0)>=0 then 100000
                    else (nvl(af.MRCLAMT,0) + buf.SEASS
                        + buf.avladvance)
                        / abs(mst.balance+buf.avladvance- mst.odamt- mst.dfdebtamt - mst.dfintdebtamt
                                -buf.bamt - mst.ramt-nvl(mst.depofeeamt,0)) end),4) * 100 MARGINRATE,*/
        mst.cidepofeeacr,
        nvl(mst.depofeeamt,0) OVDCIDEPOFEE,
        nvl(CASH_RECEIVING_T0,0) CASH_RECEIVING_T0,
        nvl(CASH_RECEIVING_T1,0) CASH_RECEIVING_T1,
        nvl(CASH_RECEIVING_T2,0) CASH_RECEIVING_T2,
        nvl(CASH_RECEIVING_T3,0) CASH_RECEIVING_T3,
        nvl(CASH_RECEIVING_TN,0) CASH_RECEIVING_TN,
        nvl(CASH_SENDING_T0,0) CASH_SENDING_T0,
        nvl(CASH_SENDING_T1,0) CASH_SENDING_T1,
        nvl(CASH_SENDING_T2,0)  CASH_SENDING_T2,
        nvl(CASH_SENDING_T3,0) CASH_SENDING_T3,
        nvl(CASH_SENDING_TN,0) CASH_SENDING_TN,
        af.careby,
        nvl(ln.mrodamt,0) MRODAMT,nvl(ln.t0odamt,0) T0ODAMT,nvl(dfg.dfamt,0) DFODAMT,
        (case when cf.custatcom ='N' then 'O' when af.corebank ='Y' then 'B' else 'C' end) ACCOUNTTYPE,
        buf.EXECBUYAMT EXECBUYAMT, af.autoadv, nvl(ST.AVLADV_T3,0) AVLADV_T3, nvl(ST.avladv_t1,0) avladv_t1,
        nvl(ST.avladv_t2,0) avladv_t2, nvl(pw.pdwithdraw,0) pdwithdraw, nvl(pdtrf.pdtrfamt,0) pdtrfamt,
        buf.bamt/*+NVL (al.advamt,0)*/+nvl(CASH_SENDING_T0,0)+nvl(CASH_SENDING_T1,0)+nvl(ST.BUY_FEEACR,0)
            - nvl(ST.EXECAMTINDAY,0)+nvl(pw.pdwithdraw,0)+nvl(pdtrf.pdtrfamt,0) CASH_PENDING_SEND,
        buf.PPREF, buf.BALDEFTRFAMT,
        nvl(CT2.CASHT2_SENDING_T0,0) CASHT2_SENDING_T0,
        nvl(CT2.CASHT2_SENDING_T1,0) CASHT2_SENDING_T1,
        nvl(CT2.CASHT2_SENDING_T2,0) CASHT2_SENDING_T2, nvl(ca.careceiving,0) careceiving,
        --PhuongHT add ngay 01.03.2016
        buf.trfbuyamt_over,buf.set0amt,buf.rlsmarginrate_ex,
        buf.NYOVDAMT, buf.marginrate_Ex,
        buf.semaxtotalcallass, buf.secallass,
        buf.CLAMT,buf.navaccountt2_EX,
        buf.outstanding_EX,
        buf.navaccount_ex, buf.MARGINRATE5,
        buf.outstanding5,buf.ODAMT_EX,
        buf.outstandingT2_EX,
        buf.semaxcallass,
        buf.secureamt_inday,
        buf.trfsecuredamt_inday,
        buf.avladvance
       --end of PhuongHT add ngay 01.03.2016
       ,/*CASE WHEN v_FOMODE = 'ON' AND af.isfo = 'Y' THEN fnc_fo_getwithdrawnormal(af.acctno)
             ELSE NULL END*/ -- 1.5.9.0|iss:2066
        0 --MSBS-2621 
       ,NVL(TAX_SELL_SENDING,0) TAX_SELL_SENDING, NVL(TAX_SELL_SENDING,0) TAX_SELL_SENDING
   FROM  v_cimastcheck buf,
        cimast mst ,
         afmast af ,
         cfmast cf ,
       (select * from allcode cd1
        where cd1.cdtype = 'CI' AND cd1.cdname = 'STATUS') cd1,
       (SELECT AFACCTNO,
                    SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=0 THEN ST.ST_AMT ELSE 0 END,0)) CASH_RECEIVING_T0,
                    SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=1 THEN ST.ST_AMT ELSE 0 END,0)) CASH_RECEIVING_T1,
                    SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=2 THEN ST.ST_AMT ELSE 0 END,0)) CASH_RECEIVING_T2,
                    SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=3 THEN ST.ST_AMT ELSE 0 END,0)) CASH_RECEIVING_T3,
                    SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY>3 THEN ST.ST_AMT ELSE 0 END,0)) CASH_RECEIVING_TN,
                    SUM(NVL(CASE WHEN ST.DUETYPE='RS' AND ST.TRFDAY=1 THEN ST.ST_AMT ELSE 0 END,0)) CASH_SENDING_T0,
                    SUM(NVL(CASE WHEN ST.DUETYPE='RS' AND ST.TRFDAY=2 THEN ST.ST_AMT ELSE 0 END,0)) CASH_SENDING_T1,
                    SUM(NVL(CASE WHEN ST.DUETYPE='RS' AND ST.TRFDAY=3 THEN ST.ST_AMT ELSE 0 END,0)) CASH_SENDING_T2,
                    SUM(NVL(CASE WHEN ST.DUETYPE='RS' AND ST.TRFDAY=4 THEN ST.ST_AMT ELSE 0 END,0)) CASH_SENDING_T3,
                    SUM(NVL(CASE WHEN ST.DUETYPE='RS' AND ST.TRFDAY>4 THEN ST.ST_AMT ELSE 0 END,0)) CASH_SENDING_TN,
                    SUM(NVL(CASE WHEN ST.DUETYPE='RS' AND ST.TRFDAY>=1 AND ST.TRFDAY<=3 AND ST.TXDATE < ST.CURRDATE THEN ST.FEEACR ELSE 0 END,0)) BUY_FEEACR,
                    sum(NVL(CASE WHEN ST.DUETYPE='RS' AND ST.TRFDAY=1 THEN ST.EXECAMTINDAY ELSE 0 END,0)) EXECAMTINDAY,
                    SUM(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=1 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT+ST.ST_PAIDAMT+ST.ST_PAIDFEEAMT-ST.FEEACR-ST.TAXSELLAMT ELSE 0 END) avladv_t1,
                    SUM(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=2 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT+ST.ST_PAIDAMT+ST.ST_PAIDFEEAMT-ST.FEEACR-ST.TAXSELLAMT ELSE 0 END) avladv_t2,
                    SUM(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=3 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT+ST.ST_PAIDAMT+ST.ST_PAIDFEEAMT-ST.FEEACR-ST.TAXSELLAMT ELSE 0 END) avladv_t3,
                    SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY < 3 THEN ST.TAXSELLAMT ELSE 0 END,0)) TAX_SELL_SENDING,
                    SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY < 3 THEN ST.FEEACR ELSE 0 END,0)) FEE_SELL_SENDING
                    --SUM(NVL(CASE WHEN ST.DUETYPE='SM' AND ST.ist2 = 'Y' AND st.T2DT = 0 THEN ST.ST_AMT + ST.FEEACR ELSE 0 END,0)) CASHT2_SENDING_T0,
                    --SUM(NVL(CASE WHEN ST.DUETYPE='SM' AND ST.ist2 = 'Y' AND st.T2DT = 1 THEN ST.ST_AMT + ST.FEEACR ELSE 0 END,0)) CASHT2_SENDING_T1,
                    --SUM(NVL(CASE WHEN ST.DUETYPE='SM' AND ST.ist2 = 'Y' AND st.T2DT = 2 THEN ST.ST_AMT + ST.FEEACR ELSE 0 END,0)) CASHT2_SENDING_T2
            FROM
                VW_BD_PENDING_SETTLEMENT ST WHERE (DUETYPE='RM' OR DUETYPE='SM' OR DUETYPE = 'RS')
            GROUP BY AFACCTNO) ST,
           (select     df.afacctno, sum(
                    ln.PRINNML + ln.PRINOVD + round(ln.INTNMLACR,0) + round(ln.INTOVDACR,0) +
                    round(ln.INTNMLOVD,0)+round(ln.INTDUE,0)+
                    ln.OPRINNML+ln.OPRINOVD+round(ln.OINTNMLACR,0)+round(ln.OINTOVDACR,0)+round(ln.OINTNMLOVD,0) +
                    round(ln.OINTDUE,0)+round(ln.FEE,0)+round(ln.FEEDUE,0)+round(ln.FEEOVD,0) +
                    round(ln.FEEINTNMLACR,0) + round(ln.FEEINTOVDACR,0) +round(ln.FEEINTNMLOVD,0)+round(ln.FEEINTDUE,0)
                    ) dfAMT
             from dfgroup df, lnmast ln
            where df.lnacctno = ln.acctno
            group by afacctno) dfg,
          (
            select trfacctno afacctno,
                sum(ln.PRINNML + ln.PRINOVD + ln.INTNMLACR + ln.INTOVDACR + ln.INTNMLOVD+ln.INTDUE
                    + ln.fee+ln.feedue+ln.feeovd+ln.feeintnmlacr+ln.feeintovdacr+ln.feeintnmlovd+ln.feeintdue+ln.feefloatamt) mrodamt,
                sum(ln.OPRINNML+ln.OPRINOVD+ln.OINTNMLACR+ln.OINTOVDACR+
                ln.OINTNMLOVD+ln.OINTDUE) t0odamt
                from lnmast ln
                where ftype ='AF'
                    and ln.PRINNML + ln.PRINOVD + ln.INTNMLACR + ln.INTOVDACR +
                        ln.INTNMLOVD+ln.INTDUE + ln.OPRINNML+ln.OPRINOVD+ln.OINTNMLACR+ln.OINTOVDACR+
                        ln.OINTNMLOVD+ln.OINTDUE >0
                           group by trfacctno
            ) ln,
                           (
             SELECT tl.msgacct, sum(tl.msgamt) pdwithdraw
             FROM tllog tl
             WHERE tl.tltxcd IN ('1100','1121','1110','1144','1199','1107','1108','1110','1131','1132','1133','1136') AND tl.txstatus = '4' AND tl.deltd = 'N'
                                  GROUP BY tl.msgacct
         ) pw,
                           (
             SELECT cir.acctno, sum(amt+feeamt) pdtrfamt
             FROM ciremittance cir
             WHERE cir.rmstatus = 'P' AND cir.deltd = 'N'
                                GROUP BY cir.acctno
         ) pdtrf,
         (
            SELECT ST.AFACCTNO,
                SUM(NVL(CASE WHEN st.T2DT = 0 THEN ST.ST_AMT ELSE 0 END,0)) CASHT2_SENDING_T0,
                SUM(NVL(CASE WHEN st.T2DT = 1 THEN ST.ST_AMT ELSE 0 END,0)) CASHT2_SENDING_T1,
                SUM(NVL(CASE WHEN st.T2DT = 2 THEN ST.ST_AMT ELSE 0 END,0)) CASHT2_SENDING_T2
            FROM
            (
                SELECT ST.afacctno, ST.txdate, ST.clearday, MAX(ST.cleardate) CLEARDATE, MAX(ST.trfbuydt) trfbuydt,
                    SUM(ST.AMT + CASE WHEN OD.FEEACR >0 THEN OD.FEEACR ELSE OD.EXECAMT * (OD.BRATIO -100)/100 END) ST_AMT,
                    MAX(CASE WHEN ST.trfbuyrate*ST.trfbuyext > 0 THEN 'Y' ELSE 'N' END) IST2,
                    SP_BD_GETCLEARDAY(ST.CLEARCD, MAX(SB.TRADEPLACE), TO_DATE(MAX(SYSVAR.VARVALUE),'DD/MM/RRRR'),max(ST.trfbuydt)) T2DT
                FROM vw_stschd_all ST, SYSVAR, ODMAST OD, sbsecurities SB
                WHERE OD.ORDERID = ST.ORGORDERID AND ST.codeid = SB.codeid
                    AND SYSVAR.VARNAME='CURRDATE'
                    AND st.deltd = 'N' AND ST.DUETYPE = 'SM'
                    AND ST.trfbuyrate*ST.trfbuyext > 0
                    AND TO_DATE(SYSVAR.VARVALUE,'DD/MM/RRRR') <= ST.trfbuydt
                    --AND ST.AFACCTNO = V_ACCTNO
                GROUP BY ST.AFACCTNO, ST.DUETYPE, ST.TXDATE, ST.CLEARCD, ST.CLEARDAY
            ) ST
            GROUP BY ST.AFACCTNO
         ) CT2,

        (SELECT SUM(amt) careceiving, afacctno  FROM caschd WHERE  status IN ('I','S','H') AND ISEXEC ='Y' AND deltd <> 'Y'   --T2_HoangND
        GROUP BY afacctno) ca

    where buf.acctno=mst.acctno
        and   mst.afacctno=af.acctno
        and   cf.custid = af.custid
        and   mst.status = cd1.cdval(+)
        and   MST.acctno = ST.AFACCTNO(+)
        and   MST.acctno = dfg.AFACCTNO(+)
        and   MST.acctno = ln.AFACCTNO(+)
        and   mst.acctno = pw.msgacct(+)
        and  mst.acctno = pdtrf.acctno(+)
        AND mst.acctno = CT2.AFACCTNO(+)
        AND mst.acctno = ca.afacctno (+)
    ;

END; -- Procedure
/
