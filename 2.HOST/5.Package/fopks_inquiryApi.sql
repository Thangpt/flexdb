create or replace package fopks_inquiryApi is

  /** ----------------------------------------------------------------------------------------------------
  ** Module: FO - OpenAPI 3
  ** Description: OpenAPI 3 API for inquiry router
  ** and is copyrighted by FSS.
  **
  **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
  **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
  **    graphic, optic recording or otherwise, translated in any language or computer language,
  **    without the prior written permission of Financial Software Solutions. JSC.
  **
  **  MODIFICATION HISTORY
  **    Person            Date           Comments
  **  duyanh.hoang     05/09/2019         Created
  ** (c) 2018 by Financial Software Solutions. JSC.
  ----------------------------------------------------------------------------------------------------*/

  type ref_cursor is ref cursor;

  /*
  /inq/accounts/{accountId}/afacctnoInfor - Get customer's information
  */

  PROCEDURE pr_getAFAcountInfo (p_REFCURSOR   IN OUT PKG_REPORT.REF_CURSOR,
                               p_accountId   IN VARCHAR2);
  /*
  /inq/accounts/{accountId}/summaryAccount: - Get summaryAccount.
  */
  PROCEDURE pr_getSummaryAccount (pv_refCursor IN OUT ref_cursor,
                               p_custid     IN VARCHAR2,
                               p_accountId  IN VARCHAR2 DEFAULT 'ALL',
                               p_err_code   OUT VARCHAR2,
                               p_err_param  OUT VARCHAR2);

  PROCEDURE pr_getSummaryAccount_BK (pv_refCursor IN OUT ref_cursor,
                               p_custid     IN VARCHAR2,
                               p_accountId  IN VARCHAR2 DEFAULT 'ALL',
                               p_err_code   OUT VARCHAR2,
                               p_err_param  OUT VARCHAR2);

  /*
  /inq/accounts/{accountId}/infoForAdvance - Payment in advanced information
  */
  PROCEDURE pr_GetInfoForAdvance (pv_refCursor IN OUT ref_cursor,
                               p_accountId  IN VARCHAR2,
                               p_err_code   OUT VARCHAR2,
                               p_err_param  OUT VARCHAR2);

  /*
   /inq/accounts/{accountId}/rightOffList - Right register information
  */
  PROCEDURE pr_GetRightOffList (pv_refCursor IN OUT ref_cursor,
                               p_custid     IN VARCHAR2,
                               p_accountId  IN VARCHAR2 DEFAULT 'ALL',
                               p_err_code   OUT VARCHAR2,
                               p_err_param  OUT VARCHAR2);

  /*
   /inq/accounts/{accountId}/transferAccountList - Beneficiary accounts
  */
  PROCEDURE pr_GetTransferAccountlist (pv_refCursor IN OUT ref_cursor,
                               p_accountId  IN VARCHAR2,
                               transferType IN VARCHAR2,
                               p_err_code   OUT VARCHAR2,
                               p_err_param  OUT VARCHAR2);
  /*
   /inq/accounts/{accountId}/transferParam
  */
  PROCEDURE pr_getTransferParam (pv_refCursor IN OUT ref_cursor,
                                 p_accountId     VARCHAR2,
                                 p_tranferType   VARCHAR2,
                                 p_err_code      OUT VARCHAR2,
                                 p_err_param     OUT VARCHAR2);
  /*
   /inq/accounts/{accountId}/securitiesPortfolio -
  */
  PROCEDURE pr_getSecuritiesPortfolio (pv_refCursor IN OUT ref_cursor,
                                     p_custid     IN VARCHAR2,
                                     p_accountId  IN VARCHAR2 DEFAULT 'ALL',
                                     p_symbol     IN VARCHAR2 DEFAULT 'ALL',
                                     p_err_code   OUT VARCHAR2,
                                     p_err_param  OUT VARCHAR2);
  /*
   /inq/accounts/{accountId}/activeOrder - activeOrder
  */
  PROCEDURE pr_getActiveOrder (pv_refCursor IN OUT ref_cursor,
                               p_accountId  IN VARCHAR2,
                               p_execType   IN VARCHAR2 DEFAULT 'ALL',
                               p_symbol     IN VARCHAR2 DEFAULT 'ALL',
                               p_err_code   OUT VARCHAR2,
                               p_err_param  OUT VARCHAR2);
  /*
   /inq/accounts/{accountId}/stockTransferParam - transfer stock param
  */
  PROCEDURE pr_GetStockTransferList (pv_refCursor IN OUT ref_cursor,
                                   p_accountId     VARCHAR2,
                                   p_err_code      OUT VARCHAR2,
                                   p_err_param     OUT VARCHAR2);
  /*
  /inq/accounts/{accountId}/accountAsset - Get customer's information
  */
  PROCEDURE pr_GetAccountAsset (pv_refCursor IN OUT ref_cursor,
                               p_accountId  IN VARCHAR2,
                               p_err_code   OUT VARCHAR2,
                               p_err_param  OUT VARCHAR2);
  /*
  /inq/accounts/{accountId}/avlSellOddLot - List Of available Sell Odd Lot
  */
  PROCEDURE pr_GetAvlSellOddLot (pv_refCursor IN OUT ref_cursor,
                               p_custId     IN VARCHAR2,
                               p_accountId  IN VARCHAR2 DEFAULT 'ALL',
                               p_err_code   OUT VARCHAR2,
                               p_err_param  OUT VARCHAR2);
  /*
  /inq/accounts/{accountId}/bondsToSharesList - List Of bond 2 shares
  */
  PROCEDURE pr_GetBonds2SharesList (pv_refCursor IN OUT ref_cursor,
                               p_accountId  IN VARCHAR2,
                               p_err_code   OUT VARCHAR2,
                               p_err_param  OUT VARCHAR2);
  /*
  /inq/accounts/{accountId}/bankInfo - List Bank Account
  */
  PROCEDURE pr_getBankInfo (pv_refCursor IN OUT ref_cursor,
                           p_err_code    OUT VARCHAR2,
                           p_err_param   OUT VARCHAR2);
  /*
  /inq/accounts/{accountId}/bankBranchInfo - List Bank Account
  */
  PROCEDURE pr_getBankBranchInfo (pv_refCursor IN OUT ref_cursor,
                                 p_bankNo      IN VARCHAR2,
                                 p_err_code    OUT VARCHAR2,
                                 p_err_param   OUT VARCHAR2);
  /*
  /inq/accounts/{accountId}/templates - List Bank Account
  */
  PROCEDURE pr_getTemplates (pv_refCursor      IN OUT ref_cursor,
                            p_accountId        IN VARCHAR2,
                            p_type             IN VARCHAR2,
                            p_err_code    OUT VARCHAR2,
                            p_err_param   OUT VARCHAR2);
  /*
  / Get loan policy.
  */
  procedure pr_get_loan_policy(p_refcursor in out ref_cursor,
                           p_err_code  in out varchar2,
                           p_err_param in out varchar2);
  --------------------------------------------Others------------------------------------------------------------
  /*PROCEDURE pr_getSEList (pv_refCursor IN OUT ref_cursor,
                         p_accountId     VARCHAR2,
                         p_err_code      OUT VARCHAR2,
                         p_err_param     OUT VARCHAR2);*/
end fopks_inquiryApi;
/
create or replace package body fopks_inquiryApi is

  -- declare log context
  pkgctx   plog.log_ctx;
  logrow   tlogdebug%ROWTYPE;

  /*
  /inq/accounts/{accountId}/afacctnoInfor - Get customer's information
  */

  PROCEDURE pr_getAFAcountInfo (p_REFCURSOR   IN OUT PKG_REPORT.REF_CURSOR,
                               p_accountId   IN VARCHAR2)

  IS
  l_authType   VARCHAR2(10);
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_getAFAcountInfo');
    FOR rec IN (
      SELECT * FROM otright
      WHERE cfcustid = (SELECT custid FROM afmast WHERE acctno = p_accountId)
      AND cfcustid = authcustid
      AND via IN ('A', 'O') AND deltd = 'N'
      ORDER BY (CASE WHEN via = 'A' THEN 1 ELSE 0 END)
    ) LOOP
      l_authType := rec.authtype;
      EXIT ;
    END LOOP;

    OPEN p_REFCURSOR FOR
      SELECT CF.fullname,
             cf.idcode,
             cf.iddate,
             cf.idplace,
             CF.custid,
             CF.custodycd,
             cf.dateofbirth,
             cf.sex sex,
             cf.address,
             cfc.address addressKBSV,
             cf.mobilesms mobile1,
             cf.mobile mobile2,
             cf.email,
             re.rmname,
             re.rdname,
             (SELECT cdcontent FROM allcode WHERE cdname = 'OTAUTHTYPE' AND cdtype = 'CF' AND cdval = l_authType) OTAUTHTYPE,
             'CFOTAUTHTYPE_' || l_authType OTAUTHTYPE_code,
             af.tradeonline,
             af.mrcrlimitmax,
             af.corebank corebank,
             af.bankacctno,
             a1.cdname custRank,
             'CFCLASS_' || cf.class    custRank_code,
             bm.mobile                 custAgentMobile,
             bm.fullname               custAgentName,
             bm.email                  custAgentEmail,
             cf.custodycd || '.' || aft.typename   accountDesc
      FROM CFMAST CF, CFCONTACT cfc, AFMAST AF, aftype aft,
          (
              SELECT re.afacctno,
                     max(case when retype.rerole ='RM' then  cf.fullname end) rmname,
                     max(case when retype.rerole ='RD' then  cf.fullname end ) rdname
              from reaflnk re,retype, cfmast cf
              where SUBSTR(REACCTNO,11) = retype.actype
              and retype.rerole IN ('RD','RM')
              AND RE.STATUS ='A'
              and cf.custid = SUBSTR(REACCTNO,1,10)
              group by re.afacctno
          )re,
          (
              Select cf.fullname,cf.mobile,cf.email,  rl.afacctno
              From reaflnk rl, retype typ , recflnk rcl, cfmast cf
              Where rl.status='A'
               and substr(rl.reacctno,11,4)=typ.actype
               and typ.retype='D' and typ.rerole='BM'
               and rl.refrecflnkid = rcl.autoid
               and rcl.custid=cf.custid
               and rl.afacctno = p_accountId
          ) bm,
          allcode a1
      WHERE CF.CUSTID = AF.custid
        AND a1.cdname = 'CLASS' and a1.cdtype = 'CF' and a1.cdval in ('001','002','003','004') AND a1.cdval = cf.class
        and af.acctno = re.afacctno(+)
        AND af.acctno = bm.afacctno(+)
        AND cf.custid = cfc.custid(+)
        AND af.actype = aft.actype
        and AF.ACCTNO = p_accountId
    ;

    plog.setendsection(pkgctx, 'pr_getAFAcountInfo');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'pr_getAFAcountInfo');
  END pr_getAFAcountInfo;

  /*
  /inq/accounts/{accountId}/summaryAccount - Get customer's information
  */
  PROCEDURE pr_getSummaryAccount (pv_refCursor IN OUT ref_cursor,
                               p_custid     IN VARCHAR2,
                               p_accountId  IN VARCHAR2 DEFAULT 'ALL',
                               p_err_code   OUT VARCHAR2,
                               p_err_param  OUT VARCHAR2)
  IS
    l_currDate   DATE;
    l_custId     VARCHAR2(20);
    l_accountId  VARCHAR2(20);
  BEGIN
    plog.setBeginSection (pkgctx, 'pr_getSummaryAccount');
    p_err_code := systemnums.C_SUCCESS;
    p_err_param := '';

    l_currDate := getcurrdate;
    l_accountId := CASE WHEN UPPER(NVL(p_accountId, 'ALL')) = 'ALL' THEN '%' ELSE p_accountId END;
    l_custId := p_custid;

    OPEN pv_refCursor FOR
       SELECT CI.*, NVL(CA.AMT, 0) careceiving,ci.OVDCIDEPOFEE + nvl(LN.TOTALLOAN,0) TOTALDEBTAMT,
              nvl(mr.ADDVND,0) ADDVND, nvl(od.buyremainvalue,0) buyremainvalue
       FROM (
          SELECT afacctno,desc_status,ROUND(pp) PP,ROUND(balance) BALANCE,ROUND(advanceline) advanceline,
                 ROUND(baldefovd) baldefovd, ROUND(least(avlwithdraw,fn_getfowithdraw(ci.AFACCTNO))) avlwithdraw,
                 ROUND(AVLADV_T3+AVLADV_T1+AVLADV_T2) avladvance,ROUND(aamt) AAMT,ROUND(bamt) BAMT,
                 ROUND(odamt+DFODAMT) ODAMT,ROUND(dealpaidamt) dealpaidamt,
                 CASE WHEN outstanding < 0 THEN ROUND(abs(outstanding)) ELSE 0 END outstanding,
                 ROUND(floatamt) FLOATAMT,ROUND(receiving) receiving,ROUND(netting) netting,
                 ROUND(cash_receiving_t0) receivingT0,ROUND(cash_receiving_t1) receivingT1,
                 ROUND(cash_receiving_t2) receivingT2,ROUND(cash_receiving_t3) receivingT3,
                 ROUND(cash_sending_t0) sendingT0, ROUND(cash_sending_t1) sendingT1,
                 ROUND(CASH_PENDWITHDRAW) CASH_PENDWITHDRAW,ROUND(CASH_PENDTRANSFER) CASH_PENDTRANSFER,
                 ROUND(AVLADV_T3) AVLADV_T3, ROUND(AVLADV_T1) AVLADV_T1, ROUND(AVLADV_T2) AVLADV_T2,
                 ROUND(cash_pending_send) cash_pending_send,
                 ROUND(casht2_sending_t0+casht2_sending_t1+casht2_sending_t2) casht2sending,
                 ci.marginrate,
                 ci.marginrate_ex,
                 ADVANCELINE GUA,ci.OVDCIDEPOFEE
          FROM buf_ci_account ci, cfmast cf
          WHERE ci.custodycd = cf.custodycd
            AND cf.custid = l_custId
            AND ci.afacctno LIKE l_accountId
            AND EXISTS(
               SELECT cf.custodycd, af.acctno afacctno
               FROM afmast af, otright ot, cfmast cf
               WHERE CI.AFACCTNO = AF.ACCTNO AND af.custid = cf.custid
                 AND ot.authcustid = ot.cfcustid AND af.custid = ot.authcustid
                 AND ot.deltd = 'N'
                 AND ot.valdate <= l_currDate AND ot.expdate >= l_currDate
                 AND cf.custid = l_custId
                 AND af.acctno LIKE l_accountId
            )
       ) CI
       LEFT JOIN (
          SELECT mr.ADDVND, mr.acctno FROM vw_mr0003 mr, afmast af
          WHERE mr.acctno = af.acctno AND mr.acctno LIKE l_accountId  AND af.custid = l_custId
       ) mr ON ci.afacctno = mr.acctno
       LEFT JOIN (
          SELECT CA.AFACCTNO, SUM(NVL(CA.AMT,0) + nvl(ca.sendamt,0)+ nvl(ca.cutamt,0)) AMT
          FROM CAMAST CAM, CASCHD CA, AFMAST AF
          WHERE CA.CAMASTID = CAM.CAMASTID AND CAM.CATYPE IN ('010','015','016')
            AND CA.STATUS = 'S'
            AND CA.AFACCTNO = AF.ACCTNO
            AND CA.AFACCTNO LIKE l_accountId
            AND AF.CUSTID = l_custId
          GROUP BY CA.AFACCTNO
       ) CA ON CI.AFACCTNO = CA.AFACCTNO
       LEFT JOIN (
          SELECT A.ACCTNO,round(sum(A.TOTALLOAN)) TOTALLOAN
          FROM (
             SELECT AF.ACCTNO,(SCHD.INTOVDPRIN +LN.INTNMLPBL+
                    SCHD.FEEINTOVDACR+SCHD.INTNMLACR  + SCHD.INTOVD + SCHD.INTDUE + SCHD.FEEINTNMLACR + SCHD.FEEINTDUE + SCHD.FEEINTNMLOVD+SCHD.NML + SCHD.OVD) TOTALLOAN
             FROM (SELECT LNSCHD.* FROM LNSCHD WHERE REFTYPE IN ('GP', 'P') AND DUENO = 0) SCHD,
                  LNMAST LN, CFMAST CF, AFMAST AF
             WHERE SCHD.ACCTNO = LN.ACCTNO
               AND LN.TRFACCTNO like l_accountId
               AND CF.CUSTID  = l_custId
               AND AF.CUSTID=CF.CUSTID
               AND LN.TRFACCTNO=AF.ACCTNO
          ) A GROUP BY ACCTNO
       ) LN ON LN.ACCTNO=CI.AFACCTNO
       LEFT JOIN (
          SELECT afacctno, SUM(o.remainqtty * o.quoteprice) buyremainvalue
          from odmast o, afmast af
          where deltd <> 'Y'
            and o.exectype = 'NB'
            AND o.afacctno = af.acctno
            and o.txdate = l_currDate
            and o.afacctno LIKE l_accountId
            AND af.custid = l_custId
          GROUP BY o.afacctno
       ) od ON OD.AFACCTNO=CI.AFACCTNO
       ORDER BY ci.afacctno;
    plog.setEndSection (pkgctx, 'pr_getSummaryAccount');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_param := 'SYSTEM ERROR';
      plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_getSummaryAccount');
  END;

  PROCEDURE pr_getSummaryAccount_BK (pv_refCursor IN OUT ref_cursor,
                               p_custid     IN VARCHAR2,
                               p_accountId  IN VARCHAR2 DEFAULT 'ALL',
                               p_err_code   OUT VARCHAR2,
                               p_err_param  OUT VARCHAR2)
  IS
    l_currDate   DATE;
    l_custId     VARCHAR2(20);
    l_accountId  VARCHAR2(20);
  BEGIN
    plog.setBeginSection (pkgctx, 'pr_getSummaryAccount_BK');
    p_err_code := systemnums.C_SUCCESS;
    p_err_param := '';

    l_currDate := getcurrdate;
    l_accountId := CASE WHEN UPPER(NVL(p_accountId, 'ALL')) = 'ALL' THEN '%' ELSE p_accountId END;
    l_custId := p_custid;


    Open pv_refCursor for
       SELECT  acctno     accountId,
               --1.Tien tren tieu khoan
               BALANCE - holdbalance +  mst.careceiving balance, --Tien tren tieu khoan
               -- Tien khong ky han
               cibalance - holdbalance CIBALANCE ,
               -- Lai tien gui chua thanh toan
               INTBALANCE interestBalance,
               -- Tien co tuc cho ve
               mst.careceiving,
               ---Tien cho ve T0
               mst.cash_receiving_t0 receivingT0,
               ---Tien cho ve T1
               mst.avladv_t1 receivingT1,
               ---Tien cho ve T2
               mst.avladv_t2 receivingT2,
               -----Tien cho ve T3
               mst.avladv_t3 receivingT3,
               ---Tien cho giao T0
               mst.cash_sending_t0 sendingT0,
               ---Tien cho giao T1
               mst.cash_sending_t1 sendingT1,
               --2.Tong gia tri chung khoan
               TOTALSEAMT    securitiesAmt,
               --2.1 Chung khoan duoc phep ky quy
               MRQTTYAMT_CURR  marginQttyAmt,
               --2.2 Chung khoan khong duoc phep ky quy
               NONMRQTTYAMT_CURR nonMarginQttyAmt,
               --3.Tong phai tra
               TOTALODAMT     totalDebtAmt, --Tong phai tra
               --3.1 No T3 chua thanh toan, ky quy
               secureamt , --No ky quy
               --3.3 No vay margin
               MRAMT         marginAmt,
               --3.2 No bao lanh
               T0AMT        t0DebtAmt, --No bao lanh
               --3.4 No vay ung truoc
               rcvadvamt     advancedAmt,
               --3.7 No vay phi luu ky
               DEPOFEEAMT    depoFeeAmt,
         --4. Tai san thuc co = 1+2-3
               balance - holdbalance + totalseamt - totalodamt +  mst.careceiving netAssetValue,
         --5. Ky quy yeu cau
               SESECURED      requiredMarginAmt,
               --5.1 CHung khoan hien co
               SESECURED_AVL  seSecuredAvl,
               --5.2 CHung khoan cho ve
               SESECURED_BUY ,
          --6. Ky quy hien co
               (MRQTTYAMT) +  CIBALANCE + rcvamt - (totalodamt-dfodamt+paidamt)-AdvandFee ACCOUNTVALUE,
               --6.1 CHung khoan duoc phep ky quy
               --QTTYAMT ,
               (MRQTTYAMT) QTTYAMT,
               --6.5 No phai tra
               -(totalodamt-dfodamt+paidamt) debtAmt,
               --6.7 phi ung truoc toi da
               -AdvandFee advanceMaxAmtFee,
               --6.6 Tien cho ve
               rcvamt     receivingAmt,
               --7. Thang du tai san
               ROUND((MRQTTYAMT) +  CIBALANCE + rcvamt - (totalodamt-dfodamt+paidamt) -AdvandFee -SESECURED,15) basicPurchasingPower,
               --8. Ty le ky quy hien tai
               /*case when (MRQTTYAMT) +  CIBALANCE + rcvamt - (totalodamt-dfodamt+paidamt) -AdvandFee < 0 then 0 else
                    case when (MRQTTYAMT)=0 then 100 else
                        round(((MRQTTYAMT) +  least(CIBALANCE + rcvamt - (totalodamt-dfodamt+paidamt) -AdvandFee,0))/(MRQTTYAMT),3)*100
                    end
               end*/
               marginRate,
               holdbalance,
               avladvance,
               bamt buyAmt,
               addVnd,
               buyRemainValue,
               trfbuyamt,
               ROUND(least(avlwithdraw,fn_getfowithdraw(acctno))) avlwithdraw
    FROM
    (
        SELECT  --1.Tien tren tieu khoan
                round(ci.balance + ci.bamt  + ci.receiving + ci.crintacr) BALANCE, --Tien tren tieu khoan
                --1.1 --Tien khong ky han
                ci.balance + ci.bamt CIBALANCE,
                --1.3 Tien cho ve
                ci.cash_receiving_t0 + ci.cash_receiving_t1 + ci.cash_receiving_t2 + ci.cash_receiving_tn RCVAMT, -- Tien ban cho nhan ve
                --1.4 Lai tien gui chua thanh toan
                round(ci.crintacr) INTBALANCE,
                --2.Tong gia tri chung khoan
                nvl(sec.mrqttyamt_curr,0) + nvl(sec.nonmrqttyamt_curr,0) TOTALSEAMT,
                --2.1 Chung khoan duoc phep ky quy
                nvl(sec.mrqttyamt_curr,0) MRQTTYAMT_curr,
                nvl(sec.mrqttyamt,0) MRQTTYAMT,
                --2.2 Chung khoan khong duoc phep ky quy
                nvl(sec.NONMRQTTYAMT_curr,0) NONMRQTTYAMT_curr,
                nvl(sec.NONMRQTTYAMT,0) NONMRQTTYAMT,
                --3.Tong phai tra
                ci.dfodamt + ci.t0odamt + ci.mrodamt
                    + ci.ovdcidepofee + ci.execbuyamt + ci.aamt TOTALODAMT, --Tong phai tra
                --3.2 No bao lanh
                ci.t0odamt T0AMT, --No bao lanh
                ----3.3 No ky quy
                --ci.bamt-ci.trfbuyamt  secureamt, --No ky quy
                ci.execbuyamt secureamt, --No ky quy da khop
                --3.3 No vay margin
                ci.mrodamt MRAMT, --No Margin
                --3.4 No vay ung truoc
                ci.aamt rcvadvamt,
                --3.5 No vay cam co chung khoan, phai tra ban deal
                ci.dfodamt,ci.paidamt,
                --3.7 No vay phi luu ky
                ci.ovdcidepofee DEPOFEEAMT, --No phi luu ky
                --4. Tai san thuc co = 1+2-3
                --5. Ky quy yeu cau
                nvl(MRQTTYAMT,0)  - nvl(MR_QTTYAMT,0) + (ci.bamt - ci.execbuyamt) - nvl(MR_QTTYAMT_BUY,0)  SESECURED,
                --5.1 CHung khoan hien co
                nvl(MRQTTYAMT,0)  - nvl(MR_QTTYAMT,0) SESECURED_AVL,
                --5.2 CHung khoan cho ve
                (ci.bamt - ci.execbuyamt) - nvl(MR_QTTYAMT_BUY,0) SESECURED_BUY,
                --6. Ky quy hien co
                --6.1 CHung khoan duoc phep ky quy
                nvl(MRQTTYAMT,0)  QTTYAMT,
                --6.7 Phi ung truoc toi da
                 -(ci.avladvance - (ci.avladv_t1 + ci.avladv_t2 + ci.avladv_t3 - ci.aamt)) AdvandFee,
                --No phai tra
                --7. Thang du tai san
                --Ky quy hien co - Ky quy yeu cau
                --8. Ty le ky quy hien tai
                --Ky quy hien co / Chung khoan duoc phep ky quy
                af.mrcrlimitmax,
                ci.advanceline,
                ci.avllimit,
                cim.holdbalance,
                --Tien cho ve T1
                ci.avladv_t1,
                ---Tien cho ve T2
                ci.avladv_t2,
                -----Tien cho ve T3
                ci.avladv_t3,
                ---Tien co tuc cho ve
               -- ci.receiving-(ci.cash_receiving_t1+ci.cash_receiving_t2) careceiving
               ci.careceiving careceiving,
               ci.cash_sending_t0,
               ci.cash_receiving_t0,
               ci.cash_sending_t1,
               ci.marginrate,
               ROUND(AVLADV_T3+AVLADV_T1+AVLADV_T2) avladvance,
               NVL(mr.addvnd, 0) addVND,
               ci.bamt,
               buyRemainValue,
               cim.trfbuyamt,
               af.acctno,
               ci.avlwithdraw
          from buf_ci_account ci, afmast af, cimast cim, --smsfeemast sms,
               (SELECT afacctno,
                    --sum(case when mrratioloan>0 then  QTTY*BASICPRICE else 0 end) MRQTTYAMT,
                    sum(case when mrratioloan+mrratiorate>0 THEN QTTY * BASICPRICE else 0 end) MRQTTYAMT,
                    sum(case when mrratioloan+mrratiorate>0 then QTTY * currprice else 0 end) MRQTTYAMT_CURR,
                    sum(case when mrratioloan+mrratiorate>0 then QTTY * least(BASICPRICE,mrpriceloan) * mrratioloan/100  else 0 end) MR_QTTYAMT,
                    sum(case when mrratioloan+mrratiorate>0 then 0 else QTTY * BASICPRICE END + BASICPRICE * qttyAll) NONMRQTTYAMT,
                    sum(case when mrratioloan+mrratiorate>0 then 0 else QTTY * currprice END + currprice * qttyAll ) NONMRQTTYAMT_CURR,
                    sum(case when mrratioloan+mrratiorate>0 then buyingqtty * BASICPRICE else 0 end) MRQTTYAMT_BUY,
                    sum(case when mrratioloan+mrratiorate>0 then buyingqtty * least(BASICPRICE,mrpriceloan) * mrratioloan/100  else 0 end) MR_QTTYAMT_BUY,
                    sum(case when mrratioloan+mrratiorate>0 then 0 else buyingqtty * BASICPRICE end) NONMRQTTYAMT_BUY,
                    SUM(NVL(b_remainAmt, 0)) buyRemainValue
                 from (
                        select se.afacctno,
                               ris.mrratiorate,
                               ris.mrratioloan,
                               BASICPRICE,
                               nvl(st.closeprice, basicprice) currprice,
                               se.trade + se.securities_receiving_t0 + se.securities_receiving_t1 + se.securities_receiving_t2 + se.securities_receiving_tn
                                        - od.S_execqtty + NVL(B_remainqtty, 0) qtty,
                               nvl(mrpriceloan,0) mrpriceloan,
                               --KL chung khoan tinh cho tk khong ky quy
                               nvl(ABSTANDING,0) + nvl(se.RESTRICTQTTY,0) + nvl(se.BLOCKED,0) + nvl(se.withdraw,0) qttyAll,
                               od.B_remainqtty buyingqtty,
                               nvl(od.b_remainAmt, 0) b_remainAmt
                        FROM securities_info sb LEFT JOIN stockinfor st ON sb.symbol = st.symbol,
                             afmast af, buf_se_account se
                             LEFT JOIN (
                                 SELECT seacctno,
                                        sum(o.remainqtty) remainqtty,
                                        sum(decode(o.exectype, 'NB', o.remainqtty, 0)) B_remainqtty,
                                        sum(decode(o.exectype, 'NB', o.execamt, 0)) B_execamt,
                                        sum(decode(o.exectype, 'NB', o.execqtty, 0 )) B_execqtty,
                                        sum(decode(o.exectype, 'NS', o.execqtty, 0 )) S_execqtty,
                                        SUM(CASE WHEN o.stsstatus <> 'C' THEN (decode(o.exectype , 'NB', o.execqtty, 0)) ELSE 0 END)  B_execqtty_new,
                                        SUM(decode(o.exectype, 'NB', o.remainqtty * o.quoteprice, 0 ))    b_remainAmt
                                 from odmast o, afmast af
                                 where deltd <> 'Y' and o.exectype IN ('NS','NB','MS')
                                   AND o.afacctno = af.acctno
                                   and o.txdate = l_currDate
                                   and o.afacctno LIKE l_accountId
                                   AND af.custid = l_custId
                                group by seacctno
                             ) od ON se.acctno = od.seacctno
                             LEFT JOIN (
                                 SELECT af.acctno || ris.codeid seacctno,
                                        ris.codeid || ris.actype codeid,
                                        ris.mrpriceloan,
                                        ris.mrratioloan,
                                        ris.mrratiorate
                                 FROM afserisk ris, afmast af
                                 WHERE ris.actype=af.actype
                             ) ris ON se.acctno = ris.seacctno
                             WHERE se.afacctno = af.acctno
                             and se.codeid= sb.codeid
                             AND se.afacctno LIKE l_accountId
                             AND af.custid = l_custId
                      ) SE group by afacctno
                ) sec, aftype aft,
                ( select ADDVND, v.acctno from vw_mr0003 v, afmast af
                  WHERE v.acctno = af.acctno AND af.acctno LIKE l_accountId AND af.custid = l_custId) mr
            where ci.afacctno LIKE l_accountId  AND af.custid = l_custId
                  and ci.afacctno = af.acctno and af.acctno = cim.acctno
                  and  ci.afacctno = sec.afacctno(+)
                  AND ci.afacctno = mr.acctno(+)
                  AND af.actype= aft.actype
    ) MST;

    plog.setEndSection (pkgctx, 'pr_getSummaryAccount_BK');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_param := 'SYSTEM ERROR';
      plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_getSummaryAccount_BK');
  END;



  /*
  GET - /inq/accounts/{accountId}/infoForAdvance - Payment in advanced information
  */
  PROCEDURE pr_GetInfoForAdvance (pv_refCursor IN OUT ref_cursor,
                               p_accountId  IN VARCHAR2,
                               p_err_code   OUT VARCHAR2,
                               p_err_param  OUT VARCHAR2)
  IS
  v_currDate    DATE;
  V_AUTOADV     VARCHAR(1);
  l_count           NUMBER;
  v_clearday        NUMBER;
  v_existOrder2     NUMBER;
  v_existOrder1     NUMBER;

  BEGIN
    plog.setBeginSection(pkgctx, 'pr_GetInfoForAdvance');

    -- LAY THONG TIN NGAY HIEN TAI
    SELECT GETCURRDATE INTO V_CURRDATE FROM DUAL;
    -- LAY THONG TIN TIEU KHOAN CO TU DONG UT HAY KO
    SELECT AUTOADV INTO V_AUTOADV FROM AFMAST WHERE ACCTNO = p_accountId;

    select to_number(varvalue) into v_clearday from sysvar where varname='CLEARDAY' and grname='OD' and rownum <=1;

    select count(*) into l_count from vw_advanceschedule
    where acctno = p_accountId and txdate = fn_get_prevdate(V_CURRDATE,2) ;
    if l_count>0 then
      v_existOrder2:=1;
    else
       v_existOrder2:=0;
    end if;

    select count(*) into l_count from vw_advanceschedule
    where acctno = p_accountId and txdate = fn_get_prevdate(V_CURRDATE,1) ;
    if l_count>0 then
      v_existOrder1:=1;
    else
       v_existOrder1:=0;
    end IF;

    OPEN pv_refCursor FOR
        SELECT TO_CHAR(STS.txdate, 'DD/MM/RRRR') txdate,
               STS.EXECAMT,
               STS.AAMT                          advancedAmt,
               TO_CHAR(sts.DUEDATE, 'DD/MM/RRRR')      paidDate,
               STS.AMT-STS.AAMT-STS.FAMT               maxAdvanceAmt,
               STS.DUEDATE - GETCURRDATE               DAYS,
               AD.ADVMINFEE                            MINFEEAMT,
               AD.ADVMAXFEE                            MAXFEEAMT,
               AD.ADVRATE                              FEERATE,
               AD.ADVMINAMT                            advancedMinAmt,
               AD.ADVMAXAMT                            advancedMaxAmt,
               V_AUTOADV                               autoAdvance,
               0                                       pendingAdvance
        FROM
            (
                SELECT STS.TXDATE, STS.AFACCTNO, SUM(STS.EXECAMT-STS.FEEACR-STS.TAXSELLAMT-STS.RIGHTTAX) AMT, SUM(AAMT) AAMT, SUM(FAMT) FAMT,
                    STS.CLEARDAY, STS.CLEARCD, STS.cleardate DUEDATE,SUM(GREATEST(MAXAVLAMT-ROUND(DEALPAID,0),0)) MAXAVLAMT,
                    SUM(STS.EXECAMT) EXECAMT
                FROM
                (
                    SELECT STS.TXDATE, STS.ACCTNO AFACCTNO,STS.AMT, STS.AAMT, STS.FAMT,STS.EXECAMT, CASE WHEN aft.vat = 'Y' THEN STS.RIGHTTAX ELSE 0 END RIGHTTAX,
                    STS.brkfeeamt FEEACR, CASE WHEN aft.vat = 'Y' THEN STS.incometaxamt ELSE 0 END TAXSELLAMT, STS.CLEARDAY, STS.CLEARCD,STS.MAXAVLAMT,
                    (CASE WHEN STS.TXDATE =TO_DATE(SYS.VARVALUE,'DD/MM/RRRR') THEN fn_getdealgrppaid(STS.ACCTNO) ELSE 0 END)/
                    (1-ADT.ADVRATE/100/360*STS.days) DEALPAID, sts.days ,sts.cleardate cleardate            --T2_HoangND
                    FROM vw_advanceschedule STS,AFMAST AF, AFTYPE AFT ,ADTYPE ADT, SYSVAR SYS
                    WHERE STS.ACCTNO = p_accountId
                    AND AF.ACCTNO=STS.ACCTNO
                    AND STS.ISVSD='N'
                    AND SYS.GRNAME='SYSTEM'
                    AND SYS.VARNAME ='CURRDATE'
                    AND AF.ACTYPE=AFT.ACTYPE
                    AND AFT.ADTYPE=ADT.ACTYPE
                    AND sts.clearday <> 1
                    UNION ALL
                    SELECT V_CURRDATE TXDATE, p_accountId AFACCTNO, 0 AMT, 0 AAMT, 0 FAMT, 0 FEEACR,0 EXECAMT,0 RIGHTTAX, 0 TAXSELLAMT, v_clearday CLEARDAY, 'B' CLEARCD,0 MAXAVLAMT,0 DEALPAID,v_clearday days,
                           GETDUEDATE(V_CURRDATE,'B', '001', v_clearday) cleardate
                    FROM DUAL
                    UNION ALL
                    SELECT fn_get_prevdate(V_CURRDATE,1) TXDATE, p_accountId AFACCTNO, 0 AMT, 0 AAMT, 0 FAMT, 0 FEEACR,0 EXECAMT,0 RIGHTTAX, 0 TAXSELLAMT, v_clearday CLEARDAY, 'B' CLEARCD,0 MAXAVLAMT,0 DEALPAID,
                            GETDUEDATE(fn_get_prevdate(V_CURRDATE,1),'B', '001', v_clearday)-fn_get_prevdate(V_CURRDATE,1)  days,
                            GETDUEDATE(fn_get_prevdate(V_CURRDATE,1),'B', '001', v_clearday) cleardate

                    FROM DUAL
                    where v_existOrder1 <> 1
                    UNION ALL
                    SELECT fn_get_prevdate(V_CURRDATE,2) TXDATE, p_accountId AFACCTNO, 0 AMT, 0 AAMT, 0 FAMT, 0 FEEACR,0 EXECAMT,0 RIGHTTAX, 0 TAXSELLAMT, v_clearday CLEARDAY, 'B' CLEARCD,0 MAXAVLAMT,0 DEALPAID,
                            GETDUEDATE(fn_get_prevdate(V_CURRDATE,2),'B', '001', v_clearday)-fn_get_prevdate(V_CURRDATE,2) days,
                            GETDUEDATE(fn_get_prevdate(V_CURRDATE,2),'B', '001', v_clearday) cleardate
                    FROM DUAL
                    where v_existOrder2 <> 1
                ) STS
                GROUP BY STS.TXDATE, STS.AFACCTNO, STS.CLEARDAY, STS.CLEARCD, sts.cleardate
            ) STS,
            (
                SELECT AF.ACCTNO, AF.ACTYPE AFTYPE, AD.ACTYPE ADTYPE, AD.ADVMINFEE, AD.ADVMAXFEE, AD.ADVRATE, AD.ADVMINAMT, AD.ADVMAXAMT
                FROM AFTYPE AFT, AFMAST AF, ADTYPE AD
                WHERE AFT.ACTYPE = AF.ACTYPE AND AFT.ADTYPE = AD.ACTYPE
                    AND AF.ACCTNO = p_accountId
            ) AD,
            (SELECT * FROM sysvar WHERE GRNAME='MARGIN' AND VARNAME ='ISSTOPADV' AND VARVALUE = 'N') sy
            WHERE STS.AFACCTNO = AD.ACCTNO
            ORDER BY STS.TXDATE, STS.CLEARDAY DESC, STS.AFACCTNO;
    plog.setEndSection(pkgctx, 'pr_GetInfoForAdvance');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_param := 'System Error';
      plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'pr_GetInfoForAdvance');
  END ;

  /*
   /inq/accounts/{accountId}/rightOffList - Right register information
  */
  PROCEDURE pr_GetRightOffList (pv_refCursor IN OUT ref_cursor,
                               p_custid     IN VARCHAR2,
                               p_accountId  IN VARCHAR2 DEFAULT 'ALL',
                               p_err_code   OUT VARCHAR2,
                               p_err_param  OUT VARCHAR2)
  IS
  l_custId   VARCHAR2(20);
  l_accountId  VARCHAR2(20);
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_GetRightOffList');
    p_err_code := systemnums.C_SUCCESS;
    p_err_param := '';

    l_custId := p_custid;
    l_accountId := CASE WHEN NVL(upper(p_accountId), 'ALL') = 'ALL' THEN '%' ELSE p_accountId END;

    Open pv_refCursor
    FOR
        SELECT afAcctno          accountId,
               camastid,
               symbol,
               TRADE,
               ORGPBALANCE       balance,
               RETAILBAL         retailBalance,
               pQtty             rightBuyAvailable,
               NVL(regqtty, 0)   rightRegistered,
               exprice           price,
               totalMoney        amt,
               description,
               ISREGIS           allowRegist,
               TO_CHAR(dueDate, 'dd/mm/rrrr')      registLastDate,
               exrate,
               rightoffrate,
               TO_CHAR(frDatetransfer, 'dd/mm/rrrr')   fromDateTransfer,
               TO_CHAR(toDateTransfer, 'dd/mm/rrrr')   toDateTransfer,
               sectype,
               'SASECTYPE_' || sectypecd            sectype_code,
               parvalue,
               TO_CHAR(begindate, 'dd/mm/rrrr') begindate,
               TO_CHAR(reportDate, 'dd/mm/rrrr')  reportDate,
               isincode
        FROM (
           select a.SYMBOL, a.TRADE, a.ORGPBALANCE, a.RETAILBAL, a.PQTTY, a.REGQTTY, a.EXPRICE, a.CAMASTID, a.SECTYPE, a.DUEDATE,
                  a.RIGHTOFFRATE, a.FRDATETRANSFER, a.TODATETRANSFER, a.BEGINDATE, a.REPORTDATE ,a.en_sectype,
                  (CASE WHEN A.currdate < A.BEGINDATE THEN 'N'
                        ELSE (CASE WHEN A.PQTTY >0 THEN 'Y' ELSE 'N' END) END) ISREGIS,
                  (CASE WHEN A.currdate < A.BEGINDATE THEN '0'
                        ELSE (CASE WHEN A.PQTTY >0 THEN '1' ELSE '2' END) END) STATUS,
                  a.EXPRICE * a.PQTTY TOTALMONEY, afacctno, exrate, sectype sectypecd, isincode, parvalue, description
           FROM (
               SELECT CA.*, CA.PENDINGQTTY - NVL(RQ.MSGQTTY,0) pqtty
               FROM (
                   SELECT CA.AFACCTNO, sb.symbol,ca.trade,ca.pbalance RETAILBAL,ca.pbalance pbalance,
                          CASE WHEN ca.balance - ca.inbalance + ca.outbalance >0 THEN ca.balance - ca.inbalance + ca.outbalance ELSE 0 end orgbalance,
                          ca.orgpbalance,ca.balance,
                          ca.qtty regqtty, mst.exprice,mst.description,ca.pqtty*mst.exprice amt,sb.parvalue  ,
                          to_date(varvalue,'dd/mm/rrrr') currdate,
                          mst.camastid||to_char(ca.autoid) camastid, cd.cdcontent sectype,cd.en_cdcontent en_sectype, mst.duedate,mst.reportdate, mst.rightoffrate,mst.frdatetransfer,
                          mst.todatetransfer,mst.begindate, ca.pbalance + ca.balance allbalance, ca.pqtty PENDINGQTTY,
                          mst.isincode, mst.exrate
                   FROM caschd ca, sbsecurities sb, allcode cd, camast mst,sysvar sy, afmast af
                   WHERE mst.tocodeid = sb.codeid and ca.camastid = mst.camastid
                   and cd.cdname = 'SECTYPE' and cd.cdtype = 'SA' and cd.cdval = sb.sectype
                   AND ca.status IN( 'V','M') AND ca.status <>'Y' AND ca.deltd <> 'Y'
                   AND mst.catype='014' --and ca.pbalance > 0 and ca.pqtty > 0
                   --AND sb.sectype NOT IN ('004','009') -- Ko lay len cac CK quyen mua cho giao dich
                   and sy.grname = 'SYSTEM' AND sy.varname = 'CURRDATE'
                   AND ca.afacctno = af.acctno
                   AND af.acctno LIKE l_accountId AND af.custid = l_custId
                   and to_date(sy.VARVALUE,'dd/mm/rrrr') <= mst.DUEDATE
                   order by mst.begindate
               ) CA
               LEFT JOIN (
                   SELECT msgacct, keyvalue, sum(NVL(MSGQTTY,0)) MSGQTTY FROM borqslog l, afmast af
                   WHERE RQSTYP = 'CAR' AND l.STATUS IN ('W','P','H')
                   AND l.msgacct = af.acctno
                   AND af.acctno LIKE l_accountId AND af.custid = l_custId
                   GROUP BY msgacct, keyvalue
               ) RQ ON CA.camastid = RQ.keyvalue AND CA.afacctno = RQ.msgacct
           ) a
        )
    ;
    plog.setendsection(pkgctx, 'pr_GetRightOffList');
  exception
    when others then
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_param := 'System Error';
      plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'pr_GetRightOffList');
  end pr_GetRightOffList;

  /*
   /inq/accounts/{accountId}/transferAccountList - Beneficiary accounts
  */
  PROCEDURE pr_GetTransferAccountlist (pv_refCursor IN OUT ref_cursor,
                               p_accountId  IN VARCHAR2,
                               transferType IN VARCHAR2,
                               p_err_code   OUT VARCHAR2,
                               p_err_param  OUT VARCHAR2)
  IS
  l_type   VARCHAR2(10);
  BEGIN
    plog.setBeginSection (pkgctx, 'pr_GetTransferAccountlist');
    p_err_code := systemnums.C_SUCCESS;
    p_err_param := '';
    l_type :=  CASE WHEN lower(transferType) = 'internal' THEN '03'
                    WHEN lower(transferType) = 'depoacc2transfer' THEN '3' ELSE '1' END;
    OPEN pv_refCursor
    FOR
      SELECT a.reg_acctno              benefitAccount,
             a.reg_beneficary_name     benefitName,
            (CASE WHEN l_type <> '1' THEN a.REGCUSTODYCD ELSE a.acnidcode END) benefitLisenceCode,
            (CASE WHEN l_type <> '1' THEN a.CUSTODYCDTYPE ELSE a.reg_beneficary_info END)  benefitBankName,
             a.cityef                  benefitBankCity,
             a.citybank                benefitBankBranch,
             a.MNEMONIC                MNEMONIC,
             nvl(substr(a.bankid,0,3), inf.bank_no) benefitBankNo
      FROM VW_STRADE_MT_ACCOUNTS  A, bank_info inf
      where afacctno = p_accountId
      AND INSTR (l_type, A.TYPE) >0
      AND upper(a.reg_beneficary_info) = inf.full_name(+);
    plog.setEndSection (pkgctx, 'pr_GetTransferAccountlist');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_param := 'SYSTEM ERROR';
      plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_GetTransferAccountlist');
  END;

  /*
   /inq/accounts/{accountId}/transferParam
  */
  PROCEDURE pr_getTransferParam (pv_refCursor IN OUT ref_cursor,
                                 p_accountId     VARCHAR2,
                                 p_tranferType   VARCHAR2,
                                 p_err_code      OUT VARCHAR2,
                                 p_err_param     OUT VARCHAR2)
  IS
  BEGIN
    plog.setBeginSection (pkgctx, 'pr_getTransferParam');
    p_err_code := systemnums.C_SUCCESS;
    p_err_param := '';


    OPEN pv_refCursor FOR
      SELECT  ci.ACCTNO accountId,
              ci.balance - nvl(b.secureamt,0) - DECODE(sy.varvalue,'Y',0,nvl(b.advamt,0)) balance,
              DECODE(sy.varvalue,'Y',0,nvl(avl.maxavlamt,0)) availableAdvance,
              DECODE(sy.varvalue,'Y',0,nvl(GREATEST(avl.MAXAVLAMT-ROUND(avl.DEALPAID,0),0),0) - nvl(aaa.advamt,0)) feeAdvance,
              CASE WHEN round(nvl(buf.avlwithdraw,0),0) > fn_getfowithdraw(p_accountId) THEN  fn_getfowithdraw(p_accountid)
                   ELSE round(nvl(buf.avlwithdraw,0),0)
              END availableTransfer
      FROM (
          SELECT  VW.ACCTNO, sum(VW.MAXAVLAMT) MAXAVLAMT,
                  sum( (CASE WHEN VW.TXDATE =TO_DATE(SYS.VARVALUE,'DD/MM/RRRR') AND ISVSD='N'
                               THEN fn_getdealgrppaid(VW.ACCTNO)
                            ELSE 0 END)
                       / (1-ADT.ADVRATE/100/360*VW.days)) DEALPAID
          FROM VW_ADVANCESCHEDULE VW, SYSVAR SYS,AFMAST AF, AFTYPE AFT ,ADTYPE ADT
          WHERE SYS.GRNAME = 'SYSTEM' AND SYS.VARNAME = 'CURRDATE'
          AND VW.ACCTNO = AF.ACCTNo AND AF.ACTYPE=AFT.ACTYPE AND AFT.ADTYPE=ADT.ACTYPE
          group by VW.ACCTNO
      ) avl, cimast ci, v_getAccountAvlAdvance aaa , v_getbuyorderinfo b, v_getdealpaidbyaccount pd, buf_ci_account buf, sysvar sy
      WHERE  ci.acctno = avl.acctno(+) and ci.acctno = aaa.afacctno(+) and ci.acctno = buf.afacctno (+)
      and ci.acctno = b.afacctno (+) and ci.acctno = pd.afacctno (+)
      and sy.GRNAME='MARGIN' AND SY.VARNAME='ISSTOPADV'
      and ci.acctno = p_accountid
    ;
    plog.setEndSection (pkgctx, 'pr_getTransferParam');
  EXCEPTION
    when OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_param := 'SYSTEM ERROR';
      plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_getTransferParam');
  END;

  /*
   /inq/accounts/{accountId}/securitiesPortfolio -
  */
  PROCEDURE pr_getSecuritiesPortfolio (pv_refCursor IN OUT ref_cursor,
                                       p_custid     IN VARCHAR2,
                                       p_accountId  IN VARCHAR2 DEFAULT 'ALL',
                                       p_symbol     IN VARCHAR2 DEFAULT 'ALL',
                                       p_err_code   OUT VARCHAR2,
                                       p_err_param  OUT VARCHAR2)
  IS
  l_symbol    VARCHAR2(100);
  l_strCurrDate  VARCHAR2(100);
  l_custid    VARCHAR2(30);
  l_accountId VARCHAR2(30);
  BEGIN
    plog.setBeginSection (pkgctx, 'pr_getSecuritiesPortfolio');
    p_err_code := systemnums.C_SUCCESS;
    p_err_param := '';
    SELECT varvalue INTO l_strCurrDate FROM sysvar WHERE varname = 'CURRDATE' AND grname = 'SYSTEM';

    l_symbol := CASE WHEN UPPER(NVL(p_symbol, 'ALL')) = 'ALL' THEN '%' ELSE p_symbol END;
    l_accountId := CASE WHEN UPPER(NVL(p_accountId, 'ALL')) = 'ALL' THEN '%' ELSE p_accountId END;
    l_custid := p_custid;

    OPEN pv_refCursor FOR
       SELECT CUSTODYCD custodycd,
              ACCTNO accountId,
              ITEM symbol,
              TRUNC(TOTAL) total,
              TRUNC(TRADE) trade,
              TRUNC(BLOCKED) blocked,
              TRUNC(RECEIVING_RIGHT) receiving_right,
              TRUNC(RECEIVING_T0) receivingT0,
              TRUNC(RECEIVING_T1) receivingT1,
              TRUNC(RECEIVING_T2) receivingT2,
              TRUNC(SENDING_T0) sendingT0,
              TRUNC(SENDING_T1) sendingT1,
              TRUNC(SENDING_T2) sendingT2,
              TRUNC(COSTPRICE) costprice,
              TRUNC(COSTPRICEAMT) costPriceAmt,
              TRUNC(BASICPRICE) basicprice,
              TRUNC(MARKETAMT) basicPriceAmt,
              PCPL pnlRate,
              TRUNC(PROFITANDLOSS) pnlAmt,
              MORTAGE vsdMortgage,
              TRUNC(SECURED) REMAINQTTY
       FROM (
             SELECT ITEM, ACCTNO, CUSTODYCD, TRADE, RECEIVING, SECURED,
                    BASICPRICE, COSTPRICE, RETAIL, S_REMAINQTTY,
                    (BASICPRICE - COSTPRICE) * (TRUNC(TRADE) +  TRUNC(S_REMAINQTTY)+ WFT_QTTY + RECEIVING_RIGHT + RECEIVING_T0 + RECEIVING_T1 + RECEIVING_T2 + RECEIVING_T3 ) PROFITANDLOSS,
                    DECODE(ROUND(COSTPRICE), 0, 0, ROUND((BASICPRICE- ROUND(COSTPRICE))*100/(ROUND(COSTPRICE)+0.00001),2)) PCPL,
                    COSTPRICE * (TRUNC(TRADE) +  TRUNC(S_REMAINQTTY)+WFT_QTTY + RECEIVING_RIGHT + RECEIVING_T0 + RECEIVING_T1 + RECEIVING_T2 + RECEIVING_T3) COSTPRICEAMT,
                    (TRUNC(TRADE) +  TRUNC(S_REMAINQTTY)+ WFT_QTTY + RECEIVING_RIGHT + RECEIVING_T0 + RECEIVING_T1 + RECEIVING_T2 + RECEIVING_T3) TOTAL,
                    WFT_QTTY,
                    BASICPRICE * (TRUNC(TRADE) +  TRUNC(S_REMAINQTTY)+WFT_QTTY + RECEIVING_RIGHT + RECEIVING_T0 + RECEIVING_T1 + RECEIVING_T2 + RECEIVING_T3)  MARKETAMT,
                    RECEIVING_RIGHT, RECEIVING_T0, RECEIVING_T1, RECEIVING_T2, RECEIVING_T3,
                    BLOCKED, SENDING_T1, SENDING_T0, SENDING_T2, MORTAGE
             FROM (
                SELECT ITEM,ACCTNO, CUSTODYCD,
                       SUM(CASE WHEN TRADEPLACE_WFT='006' THEN 0 ELSE TRADE -S_SECURED END) TRADE,
                       SUM(CASE WHEN TRADEPLACE_WFT='006' THEN 0 ELSE RECEIVING END) RECEIVING,
                       SUM(CASE WHEN TRADEPLACE_WFT='006' THEN 0 ELSE SECURED END) SECURED,
                       SUM(S_EXECAMT) S_EXECAMT,
                       SUM(CASE WHEN TRADEPLACE_WFT='006' THEN 0 ELSE S_REMAINQTTY END) S_REMAINQTTY,
                       MAX(CASE WHEN TRADEPLACE_WFT='006' THEN BASICPRICE ELSE BASICPRICE END)  BASICPRICE,
                       MAX(CASE WHEN TRADEPLACE_WFT='006' THEN COSTPRICE ELSE COSTPRICE END) COSTPRICE,
                       SUM(CASE WHEN TRADEPLACE_WFT='006' THEN 0 ELSE RETAIL END ) RETAIL,
                       SUM(CASE WHEN TRADEPLACE_WFT='006' THEN  TRUNC(TRADE) +  TRUNC(S_REMAINQTTY) + RECEIVING_T0 + RECEIVING_T1 + RECEIVING_T2 + RECEIVING_T3 ELSE 0 END )  WFT_QTTY,
                       SUM(RECEIVING_RIGHT) RECEIVING_RIGHT,
                       SUM(CASE WHEN TRADEPLACE_WFT='006' THEN 0 ELSE RECEIVING_T0 END )  RECEIVING_T0,
                       SUM(CASE WHEN TRADEPLACE_WFT='006' THEN 0 ELSE RECEIVING_T1 END )  RECEIVING_T1,
                       SUM(CASE WHEN TRADEPLACE_WFT='006' THEN 0 ELSE RECEIVING_T2 END) RECEIVING_T2,
                       SUM(CASE WHEN TRADEPLACE_WFT='006' THEN 0 ELSE RECEIVING_T3 END) RECEIVING_T3,
                       SUM(CASE WHEN TRADEPLACE_WFT='006' THEN 0 ELSE BLOCKED END) BLOCKED,
                       SUM(CASE WHEN TRADEPLACE_WFT='006' THEN 0 ELSE SENDING_T0 END) SENDING_T0,
                       SUM(CASE WHEN TRADEPLACE_WFT='006' THEN 0 ELSE SENDING_T1 END) SENDING_T1,
                       SUM(CASE WHEN TRADEPLACE_WFT='006' THEN 0 ELSE SENDING_T2 END) SENDING_T2,
                       SUM(CASE WHEN TRADEPLACE_WFT='006' THEN 0 ELSE MORTAGE END) MORTAGE
                    FROM (
                       SELECT TO_CHAR(SB.SYMBOL) ITEM, SDTL.AFACCTNO ACCTNO, SDTL.CUSTODYCD, SB.TRADEPLACE_WFT,
                              CASE WHEN SB.TRADEPLACE_WFT <> '006' THEN NVL(P_FO.TRADE,0) ELSE  SDTL.TRADE  + sdtl.secured END + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED+SDTL.WITHDRAW TRADE,
                              SDTL.RECEIVING + NVL(OD.B_EXECQTTY_NEW,0) RECEIVING,
                              NVL(OD.S_REMAINQTTY,0) + NVL(OD.S_EXEC_QTTY,0) S_SECURED,
                              NVL(OD.REMAINQTTY,0) SECURED,
                              NVL(OD.S_REMAINQTTY,0) S_REMAINQTTY,
                              NVL(OD.S_EXECAMT,0) S_EXECAMT,
                              CASE WHEN NVL(STIF.CLOSEPRICE,0)>0 THEN STIF.CLOSEPRICE ELSE  SEC.BASICPRICE END  BASICPRICE,
                              ROUND(
                                 (ROUND(NVL(SDTL1.COSTPRICE,SDTL.COSTPRICE))*
                                          (CASE WHEN SB.TRADEPLACE_WFT <> '006' THEN NVL(P_FO.TRADE,0) ELSE  SDTL.TRADE  + sdtl.secured END +
                                               SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED +
                                               SDTL.RECEIVING + NVL(SDTL_WFT.WFT_RECEIVING,0)
                                         ) + NVL(OD.B_EXECAMT,0)
                                 ) /
                                 (CASE WHEN SB.TRADEPLACE_WFT <> '006' THEN NVL(P_FO.TRADE,0) ELSE  SDTL.TRADE  + sdtl.secured END +
                                       SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED+ NVL(SDTL_WFT.WFT_RECEIVING,0) +
                                       SDTL.RECEIVING + NVL(OD.B_EXECQTTY,0) + 0.000001
                                 )
                              ) AS COSTPRICE,
                              FN_GETCKLL_AF(SDTL.AFACCTNO, SB.CODEID) RETAIL,
                              SDTL.RECEIVING - SDTL.SECURITIES_RECEIVING_T0 - SDTL.SECURITIES_RECEIVING_T1 RECEIVING_RIGHT,
                              SDTL.SECURITIES_RECEIVING_T0 RECEIVING_T0,
                              SDTL.SECURITIES_RECEIVING_T1 RECEIVING_T1,
                              nvl(P_FO.BOD_RT2,0) + nvl(PEX_FO.bod_rt3,0) RECEIVING_T2,
                              SDTL.SECURITIES_RECEIVING_T3 RECEIVING_T3,
                              SDTL.BLOCKED,
                              SDTL.SECURITIES_SENDING_T0 SENDING_T0,
                              SDTL.SECURITIES_SENDING_T1 SENDING_T1,
                              SDTL.SECURITIES_SENDING_T2 SENDING_T2,
                              SDTL.MORTAGE
                       FROM (
                          SELECT NVL(SB1.PARVALUE,SB.PARVALUE) PARVALUE,  NVL(SB1.TRADEPLACE,SB.TRADEPLACE) TRADEPLACE, NVL(SB.SECTYPE,SB1.SECTYPE) SECTYPE ,SB.CODEID,
                                 NVL(SB1.SYMBOL,SB.SYMBOL) SYMBOL, NVL(SB1.CODEID,SB.CODEID) REFCODEID,SB.TRADEPLACE TRADEPLACE_WFT
                          FROM SBSECURITIES SB, SBSECURITIES SB1
                          WHERE NVL(SB.REFCODEID,' ') = SB1.CODEID(+)
                       ) SB , SECURITIES_INFO SEC, afmast af, BUF_SE_ACCOUNT SDTL
                       LEFT JOIN (
                          SELECT SB.SYMBOL, SE.AFACCTNO||SB.CODEID ACCTNO, SE.AFACCTNO||NVL(SB.REFCODEID,SB.CODEID) REFACCTNO,
                                 ROUND((ROUND(BUF.COSTPRICE) *(( BUF.TRADE  + BUF.secured) + BUF.DFTRADING + BUF.RESTRICTQTTY + BUF.ABSTANDING +
                                                     BUF.BLOCKED + BUF.RECEIVING  + NVL(SDTL_WFT.WFT_RECEIVING,0) - NVL(WFT_3380,0))
                                                     + NVL(OD.B_EXECAMT,0))/
                                                     ( ( BUF.TRADE  + BUF.secured) +
                                                     BUF.DFTRADING + BUF.RESTRICTQTTY + BUF.ABSTANDING + BUF.BLOCKED + NVL(SDTL_WFT.WFT_RECEIVING,0) - NVL(WFT_3380,0) +
                                                     + BUF.RECEIVING + NVL(OD.B_EXECQTTY,0) + 0.000001
                                                     )
                                 ) AS COSTPRICE
                          FROM SEMAST SE, AFMAST AF, SBSECURITIES SB, BUF_SE_ACCOUNT BUF
                          LEFT JOIN (
                             SELECT acctno, symbol,
                                    SUM(o.REMAIN_QTTY) REMAINQTTY,
                                    SUM(o.EXEC_QTTY) B_EXECQTTY,
                                    SUM(o.EXEC_AMT)  B_EXECAMT,
                                    SUM(o.EXEC_QTTY) B_EXECQTTY_NEW
                             FROM orders@dbl_fo o
                             WHERE  subside IN ('NB','AB')
                             GROUP BY acctno, symbol
                          ) OD ON BUF.AFACCTNO = OD.acctno AND BUF.SYMBOL = OD.SYMBOL
                          LEFT JOIN (
                             SELECT AFACCTNO, REFCODEID, TRADE + RECEIVING  WFT_RECEIVING , NVL(SE.NAMT,0) WFT_3380
                             FROM  SEMAST SDTL, SBSECURITIES SB, (SELECT ACCTNO , NAMT FROM SETRAN WHERE TLTXCD = '3380' AND TXCD = '0052' AND DELTD <> 'Y') SE
                             WHERE SDTL.CODEID = SB.CODEID AND SB.REFCODEID IS NOT NULL AND SDTL.ACCTNO = SE.ACCTNO(+)
                          ) SDTL_WFT ON BUF.CODEID = SDTL_WFT.REFCODEID AND BUF.AFACCTNO = SDTL_WFT.AFACCTNO
                          WHERE SB.CODEID = SE.CODEID AND SB.REFCODEID IS NOT NULL
                            AND SE.AFACCTNO||NVL(SB.REFCODEID,SB.CODEID) = BUF.ACCTNO
                            AND SE.AFACCTNO = AF.ACCTNO
                            AND BUF.AFACCTNO like l_accountId
                            AND BUF.Symbol LIKE l_symbol
                            AND AF.CUSTID = l_custid
                       ) SDTL1 ON SDTL.ACCTNO = SDTL1.ACCTNO
                       LEFT JOIN (
                          SELECT TO_NUMBER( STOC.CLOSEPRICE) CLOSEPRICE,STOC.SYMBOL
                          FROM STOCKINFOR STOC,SYSVAR SY
                          WHERE SY.GRNAME='SYSTEM' AND SY.VARNAME='CURRDATE'
                            AND STOC.TRADINGDATE = SY.VARVALUE
                       ) STIF ON REPLACE(SDTL.SYMBOL,'_WFT','') = STIF.SYMBOL
                       LEFT JOIN (
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
                       ) OD ON SDTL.AFACCTNO = OD.acctno AND SDTL.SYMBOL = OD.SYMBOL
                       LEFT JOIN (
                          SELECT AFACCTNO, REFCODEID, TRADE + RECEIVING - SECURITIES_RECEIVING_T1 - SECURITIES_RECEIVING_T2 WFT_RECEIVING
                          FROM BUF_SE_ACCOUNT SDTL, SBSECURITIES SB
                          WHERE SDTL.CODEID = SB.CODEID AND SB.REFCODEID IS NOT NULL
                       ) SDTL_WFT ON SDTL.CODEID = SDTL_WFT.REFCODEID AND SDTL.AFACCTNO = SDTL_WFT.AFACCTNO
                       LEFT JOIN PORTFOLIOS@DBL_FO P_FO ON SDTL.AFACCTNO =P_FO.ACCTNO AND SDTL.SYMBOL = P_FO.SYMBOL
                       LEFT JOIN PORTFOLIOSEX@DBL_FO PEX_FO ON SDTL.AFACCTNO =PEX_FO.ACCTNO AND SDTL.SYMBOL = PEX_FO.SYMBOL
                       WHERE SB.CODEID = SDTL.CODEID
                         AND SDTL.CODEID = SEC.CODEID
                         AND SDTL.AFACCTNO = af.acctno
                         AND af.custid = l_custid
                         AND SDTL.AFACCTNO LIKE l_accountId
                         AND SDTL.Symbol LIKE l_symbol
                         AND SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY +
                             SDTL.ABSTANDING + SDTL.BLOCKED + SDTL.RECEIVING+SDTL.SECURITIES_RECEIVING_T0+
                             SDTL.SECURITIES_RECEIVING_T1+SDTL.SECURITIES_RECEIVING_T2+
                             SDTL.SECURITIES_RECEIVING_T3 + NVL(OD.REMAINQTTY,0) + nvl(OD.B_EXECQTTY,0) > 0
                    )
                    GROUP BY ITEM, ACCTNO, CUSTODYCD
                 )
                 UNION ALL
                 SELECT ITEM, ACCTNO, CUSTODYCD, TRADE TRADE, 0 RECEIVING, 0 SECURED,
                        BASICPRICE, COSTPRICE, 0 RETAIL, 0 S_REMAINQTTY, 0 PROFITANDLOSS, 0 PCPL,
                        COSTPRICE * RECEIVING_T2 COSTPRICEAMT, TRADE + RECEIVING_T2 TOTAL,
                        0 WFT_QTTY, BASICPRICE * (RECEIVING_T2 + TRADE)  MARKETAMT,
                        0 RECEIVING_RIGHT, 0 RECEIVING_T0, 0 RECEIVING_T1, RECEIVING_T2, 0 RECEIVING_T3,
                        0 BLOCKED, 0 SENDING_T0, 0 SENDING_T1, 0 SENDING_T2, 0 MORTAGE
                 FROM (
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
                         ) OD, (
                            SELECT TO_NUMBER( STOC.CLOSEPRICE) CLOSEPRICE,STOC.SYMBOL
                            FROM STOCKINFOR STOC,SYSVAR SY
                            WHERE SY.GRNAME='SYSTEM' AND SY.VARNAME='CURRDATE'
                              AND STOC.TRADINGDATE = SY.VARVALUE
                         ) STIF, securities_info  sec, afmast af
                    WHERE NOT EXISTS (SELECT * FROM buf_se_account b WHERE b.afacctno  = P_FO.acctno AND b.symbol = P_FO.symbol)
                      AND P_FO.acctno  = PEX_FO.acctno(+) AND  P_FO.symbol  = PEX_FO.symbol(+)
                      AND P_FO.ACCTNO = OD.acctno(+) AND P_FO.SYMBOL = OD.SYMBOL(+)
                      AND a.acctno = P_FO.acctno
                      AND a.acctno = af.acctno
                      AND P_FO.SYMBOL = STIF.SYMBOL(+)
                      AND P_FO.SYMBOL = SEC.SYMBOL(+)
                      AND a.acctno LIKE l_accountId
                      AND P_FO.SYMBOL LIKE l_symbol
                      AND af.custid = l_custid
                    GROUP BY a.ACCTNO, a.CUSTODYCD, P_FO.SYMBOL,P_FO.TRADE
                 )
              )
       ORDER BY ACCTNO,ITEM;
    /*
       select *
       from (
          SELECT custodycd,
                 MST.ACCTNO    accountId,
                 ITEM          symbol,
                 trunc(TOTAL)  TOTAL,
                 trunc(trade)  trade,
                 trunc(blocked) blocked,
                 receiving_right,
                 receiving_t0    receivingT0,
                 receiving_t1    receivingT1,
                 receiving_t2    receivingT2,
                 sending_t0    sendingT0,
                 sending_t1    sendingT1,
                 sending_t2    sendingT2,
                 trunc(COSTPRICE) costprice,
                 trunc(TOTAL) * trunc(COSTPRICE)    costPriceAmt,
                 trunc(basicprice) basicprice,
                 trunc(TOTAL) * trunc(basicprice) basicPriceAmt,
                 ROUND((BASICPRICE - ROUND(COSTPRICE))*100/(ROUND(COSTPRICE)+0.00001),2)   pnlRate,
                 (BASICPRICE - COSTPRICE) * TOTAL     pnlAmt,
                 mortage   vsdMortgage, REMAINQTTY
          FROM (
              SELECT sdtl.custodycd,
                     TO_CHAR(SB.SYMBOL) ITEM,
                     SDTL.AFACCTNO ACCTNO,
                     SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED
                       + nvl(od.B_execqtty_new,0) + SDTL.RECEIVING + SDTL.SECURITIES_RECEIVING_T3 + nvl(od.REMAINQTTY,0) TOTAL,
                     SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED TRADE,
                     SDTL.receiving + nvl(od.B_execqtty_new,0) receiving,
                     nvl(od.REMAINQTTY,0) REMAINQTTY,
                     CASE WHEN nvl( stif.closeprice,0)>0 THEN stif.closeprice ELSE  SEC.BASICPRICE END  BASICPRICE,
                     sdtl.COSTPRICE,
                     GREATEST( nvl(stif.closeprice,0), SEC.BASICPRICE)  *
                     (SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED + SDTL.receiving +nvl(od.B_execqtty_new,0) + nvl(od.REMAINQTTY,0)) MARKETAMT,
                     nvl(od.B_execqtty_new,0) + SDTL.RECEIVING - SDTL.SECURITIES_RECEIVING_T0 - SDTL.SECURITIES_RECEIVING_T1 - SDTL.SECURITIES_RECEIVING_T2 RECEIVING_RIGHT,
                     SDTL.SECURITIES_RECEIVING_T0 receiving_t0,
                     SDTL.SECURITIES_RECEIVING_T1 receiving_t1,
                     SDTL.SECURITIES_RECEIVING_T2 receiving_t2,
                     SDTL.SECURITIES_RECEIVING_T3 receiving_t3,
                     sdtl.securities_sending_t0   sending_t0,
                     sdtl.securities_sending_t1   sending_t1,
                     sdtl.securities_sending_t2   sending_t2,
                     sdtl.blocked,
                     sdtl.mortage,
                     3 stt
                FROM BUF_SE_ACCOUNT SDTL, SBSECURITIES SB,
                    SECURITIES_INFO SEC, afmast af,
                    (select seacctno, sum(o.remainqtty) remainqtty, sum(decode(o.exectype , 'NB',  o.execamt ,0 )) B_execamt
                        , sum(decode(o.exectype , 'NB',  o.execqtty ,0 )) B_execqtty, SUM(CASE WHEN o.stsstatus <> 'C' THEN (decode(o.exectype , 'NB',  o.execqtty ,0 )) ELSE 0 END)  B_execqtty_new
                    from odmast o
                     where deltd <>'Y' and o.exectype in('NS','NB','MS')
                      and o.txdate =(select to_date(VARVALUE,'DD/MM/YYYY') from sysvar where grname='SYSTEM' and varname='CURRDATE')
                    group by seacctno) OD,
                (SELECT TO_NUMBER( closeprice) closeprice,symbol from stockinfor WHERE tradingdate = to_char(getcurrdate ,'dd/mm/yyyy')) stif
              WHERE af.acctno LIKE l_accountId AND af.custid = l_custid
                AND sdtl.symbol LIKE l_symbol
                AND af.acctno = sdtl.afacctno
                AND SB.CODEID = SDTL.CODEID
                AND SDTL.CODEID = SEC.CODEID
                and sdtl.acctno = od.seacctno(+)
                AND SDTL.symbol = stif.symbol(+)
                and SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED + SDTL.receiving+SDTL.SECURITIES_RECEIVING_T0+SDTL.SECURITIES_RECEIVING_T1+SDTL.SECURITIES_RECEIVING_T2+SDTL.SECURITIES_RECEIVING_T3 + nvl(od.REMAINQTTY,0) >0
              ) MST order by ITEM
          ) a
    ;
    */
    plog.setEndSection (pkgctx, 'pr_getSecuritiesPortfolio');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_param := 'SYSTEM ERROR';
      plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_getSecuritiesPortfolio');
  END;

  /*
   /inq/accounts/{accountId}/activeOrder - activeOrder
  */
  PROCEDURE pr_getActiveOrder (pv_refCursor IN OUT ref_cursor,
                               p_accountId  IN VARCHAR2,
                               p_execType   IN VARCHAR2 DEFAULT 'ALL',
                               p_symbol     IN VARCHAR2 DEFAULT 'ALL',
                               p_err_code   OUT VARCHAR2,
                               p_err_param  OUT VARCHAR2)
  IS
  l_execType     VARCHAR2(100);
  l_symbol       VARCHAR2(100);
  l_currDate     DATE;
  BEGIN
    plog.setBeginSection (pkgctx, 'pr_getActiveOrder');
    p_err_code := systemnums.C_SUCCESS;
    p_err_param := '';

    l_execType := CASE WHEN UPPER(NVL(p_execType, 'ALL')) = 'ALL' THEN '%' ELSE p_execType END;
    l_symbol := CASE WHEN UPPER(NVL(p_execType, 'ALL')) = 'ALL' THEN '%' ELSE p_symbol END;
    SELECT TO_DATE(varvalue, 'dd/mm/rrrr') INTO l_currDate FROM sysvar WHERE varname = 'CURRDATE' AND grname = 'SYSTEM';

    open pv_refCursor for
       SELECT od.custodycd,
              TO_CHAR(od.txdate, 'dd/mm/rrrr') txdate,
              od.afacctno,
              od.orderid,
              od.txtime,
              od.symbol,
              od.iscancel    allowCancel,
              od.isadmend    allowAmend,
              'FOEXECTYPE_' || od.exectype    side_code,
              a1.cdcontent                    side,
              round(od.quoteprice*1000,4) price,
              od.pricetype,
              'FOVIA_' || od.via              via_code,
              a2.cdcontent                    via,
              od.orderqtty                    Qtty,
              od.execqtty,
              od.execamt,
              round(case when od.execqtty > 0 then od.execamt/od.execqtty else 0 end,4) execprice,
              od.remainQtty,
              greatest(od.remainqtty*round(od.quoteprice*1000,4),0)  remainAmt,
              'ODORSTATUS_' || a3.cdval   status_code,
              od.orstatus                 status,
              decode(od.tlname, 'useronline', od.custodycd, od.tlname) tlname
      from buf_od_account od, allcode a1, allcode a2, allcode a3
      WHERE od.afacctno like p_accountId
         and od.exectype like l_execType
         and od.symbol like l_symbol
         and od.remainqtty > 0 AND od.txdate = l_currDate
         AND a1.cdname = 'EXECTYPE' AND a1.cdtype = 'FO' AND a1.cdval = od.exectype
         AND a2.cdname = 'VIA' AND a2.cdtype = 'OD' AND a2.cdcontent = od.via
         AND a3.cdname = 'ORSTATUS' AND a3.cdtype = 'OD' AND a3.cdval = od.orstatusvalue
      order by od.orderid;

    plog.setEndSection (pkgctx, 'pr_getActiveOrder');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_param := 'SYSTEM ERROR';
      plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_getActiveOrder');
  END;

  /*
   /inq/accounts/{accountId}/stockTransferParam - transfer stock param
  */
  PROCEDURE pr_GetStockTransferList (pv_refCursor IN OUT ref_cursor,
                                   p_accountId     VARCHAR2,
                                   p_err_code      OUT VARCHAR2,
                                   p_err_param     OUT VARCHAR2)
  IS
  l_accountId   VARCHAR2(30);
  BEGIN
    plog.setBeginSection (pkgctx, 'pr_GetStockTransferList');
    p_err_code := systemnums.C_SUCCESS;
    p_err_param := '';
    l_accountId := p_accountId;

    OPEN pv_refCursor
    FOR
        select afacctno      accountId,
               symbol,
               fullname      symbolName,
               trade + restrictblocked + blocked total,
               trade,
               restrictblocked,
               blocked
        from
        (
            select *
            FROM (SELECT sym.symbol,
                         iss.fullname,
                         semast.afacctno,
                         least(semast.trade,
                                (case when semast.trade >0 then
                                          fn_get_semast_avl_withdraw(semast.afacctno, semast.codeid)
                                      ELSE 0 END )
                                ) trade,
                         nvl(setl.restrictblocked,0) restrictblocked,
                         nvl(setl.blocked,0) blocked
                  FROM sbsecurities sym, issuers iss, semast,
                       (
                           select acctno,
                                  sum(DECODE(qttytype, '002', qtty, 0)) restrictblocked,
                                  sum(DECODE(qttytype, '007', qtty, 0)) blocked
                           from semastdtl
                           where status='N' AND DELTD <>'Y'
                           AND  qttytype IN ('002', '007')
                           and substr(acctno,1,10) = l_accountId
                           group by acctno
                       ) setl
                  WHERE sym.codeid = semast.codeid
                  AND semast.acctno = setl.acctno(+)
                  AND sym.issuerid = iss.issuerid
                  AND sym.sectype <> '004')
            WHERE trade + blocked > 0 and afacctno = l_accountId
            ORDER by symbol
        ) a
    ;
    plog.setEndSection (pkgctx, 'pr_GetStockTransferList');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_param := 'SYSTEM ERROR';
      plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_GetStockTransferList');
  END;

  /*
  /inq/accounts/{accountId}/accountAsset - Get account asset
  */
  PROCEDURE pr_GetAccountAsset (pv_refCursor IN OUT ref_cursor,
                               p_accountId  IN VARCHAR2,
                               p_err_code   OUT VARCHAR2,
                               p_err_param  OUT VARCHAR2)
  IS
  l_accountId   VARCHAR2(30);
  l_currDate    DATE;
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_GetAccountAsset');
    p_err_code := systemnums.C_SUCCESS;
    p_err_param := '';
    l_accountId := p_accountId;
    l_currDate := getcurrdate;

    OPEN pv_refCursor
    FOR
      SELECT accountId,
             stockAmt,
             balance - buyRemainAmt - buyAmt - buyFeeAmt
                     + avlAdvance + careceiving + CreditInterest     balance,
             balance      cash,
             buyRemainAmt,
             buyAmt,
             receivingT0,
             receivingT1,
             receivingT2,
             avlAdvance,
             advancedAmt,
             careceiving,
             CreditInterest,
             totalLoan,
             loanAmt,
             inPayTotal,
             depofeeamt,
             cidepofeeacr,
             stockAmt + (balance - buyRemainAmt - buyAmt - buyFeeAmt + avlAdvance + careceiving + CreditInterest) - totalLoan    nav,
             CallRate,
             ExecuteRate,
             LoanLimit,
             pp,
             marginRate,
             avlDrawDown,
             buyFeeAmt,
             sellFeeAmt,
             sellTaxAmt
      FROM
      (
          SELECT af.acctno       accountId,
                 NVL(se.marketamt, 0) stockAmt,
                 ci.balance,
                 NVL(se.buyRemainAmt, 0)     buyRemainAmt,
                 NVL(se.buyAmt, 0)           buyAmt,
                 bci.cash_receiving_t0       receivingT0,
                 bci.cash_receiving_t1       receivingT1,
                 bci.cash_receiving_t2       receivingT2,
                 bci.avladv_t1 + bci.avladv_t2 + bci.avladv_t3   avlAdvance,
                 bci.aamt                    advancedAmt,
                 NVL(CA.AMT, 0)         careceiving,
                 ci.crintacr                 CreditInterest,
                 NVL(ln.loanamt, 0)+NVL(ln.intnml, 0)+NVL(ad.feeamt, 0)+ci.depofeeamt+ci.cidepofeeacr totalLoan,
                 NVL(ln.loanamt, 0)          loanAmt,
                 NVL(ln.intnml, 0) + NVL(ad.feeamt, 0)    inPayTotal,
                 ci.depofeeamt                            depofeeamt,
                 ci.cidepofeeacr                          cidepofeeacr,
                 mrt.mrmrate                              CallRate,
                 mrt.mrlrate                              ExecuteRate,
                 af.mrcrlimitmax                          LoanLimit,
                 bci.pp                                   pp,
                 bci.marginrate                           marginRate,
                 CASE WHEN NVL(v.TS_T2,0) - NVL(lng.MRAMT,0) > nvl(af.MRCRLIMITMAX,0) - NVL(lnm.DFODAMT,0) THEN NVL(af.MRCRLIMITMAX,0) - NVL(lnm.DFODAMT,0)
                      WHEN NVL(v.TS_T2,0) - NVL(lng.MRAMT,0) > 0 THEN NVL(v.TS_T2,0) - NVL(lng.MRAMT,0)
                      ELSE 0
                 END avlDrawDown,
                 NVL(se.buyFeeAmt, 0)                     buyFeeAmt,
                 bci.fee_sell_sending                     sellFeeAmt,
                 bci.tax_sell_sending                     sellTaxAmt
          FROM cimast ci, afmast af, buf_ci_account bci, aftype aft, mrtype mrt,
              (
                  SELECT acctno,
                        SUM(basicprice * (trade + receiving + secured)) marketAmt,
                        SUM(buyRemainAmt)                               buyRemainAmt,
                        SUM(buyExecAmt)                                 buyAmt,
                        SUM(buyFeeAmt)                                  buyfeeAmt
                 FROM
                 (
                     SELECT sdtl.afacctno acctno,
                            nvl(st.closeprice,sb.basicprice) basicprice,--1.8.1.6|iss 2317
                            SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED TRADE,
                            nvl(od.REMAINQTTY,0) secured,
                            SDTL.receiving + nvl(od.B_execqtty_new,0) receiving,
                            NVL(od.B_remainamt, 0)                    buyRemainAmt,
                            NVL(od.B_execamt, 0)                      buyExecAmt,
                            NVL(od.B_feeamt, 0)                       buyFeeamt
                     FROM securities_info sb left join stockinfor st on sb.symbol = st.symbol, buf_se_account sdtl
                     LEFT JOIN (select seacctno,
                                       sum(decode(o.exectype , 'NB', o.remainqtty, 0)) B_remainqtty,
                                       sum(decode(o.exectype , 'NB', o.remainqtty * o.quoteprice, 0)) B_remainamt,
                                       sum(o.remainqtty) remainqtty,
                                       sum(decode(o.exectype , 'NB',  o.execamt ,0 )) B_execamt,
                                       sum(decode(o.exectype , 'NB',  o.execqtty ,0 )) B_execqtty,
                                       SUM(CASE WHEN o.stsstatus <> 'C' THEN (decode(o.exectype , 'NB',  o.execqtty ,0 )) ELSE 0 END)  B_execqtty_new,
                                       SUM(decode(o.exectype , 'NB', CASE WHEN o.execamt > 0 AND o.feeacr = 0 THEN round(o.execamt * typ.deffeerate/100) ELSE o.feeacr END, 0)) B_feeamt
                            from odmast o, odtype typ
                            where deltd <> 'Y' and o.exectype IN ('NS','NB','MS')
                                and o.txdate = l_currDate
                                and o.afacctno = l_accountId
                                AND o.actype = typ.actype
                            group by seacctno
                     ) od ON sdtl.acctno = od.seacctno
                     WHERE sb.codeid = sdtl.codeid
                  ) se
                  GROUP BY  se.acctno
              ) se,
              (
                  SELECT CA.AFACCTNO,
                         SUM(NVL(CA.AMT,0) + nvl(ca.sendamt,0) + nvl(ca.cutamt,0)) AMT
                  FROM CAMAST CAM, CASCHD CA
                  WHERE CA.CAMASTID = CAM.CAMASTID AND CAM.CATYPE IN ('010', '015', '016')
                      AND CA.STATUS = 'S'
                      AND CA.AFACCTNO = l_accountId
                  GROUP BY CA.AFACCTNO
              ) CA,
              (
                  SELECT ln.trfacctno,
                         sum(SCHD.nml + SCHD.ovd)   loanAmt,
                         sum(SCHD.INTNMLACR  + SCHD.INTOVD + SCHD.INTDUE + SCHD.FEEINTNMLACR + SCHD.FEEINTDUE + SCHD.FEEINTNMLOVD
                                             + SCHD.INTOVDPRIN + SCHD.FEEINTOVDACR)   intNml
                  FROM lnmast ln, lnschd SCHD
                  WHERE ln.acctno = SCHD.acctno
                  AND ln.trfacctno = l_accountId
                  GROUP BY ln.trfacctno
              ) ln,
              (
                  select acctno, sum(feeamt) feeamt
                  from ADSCHD
                  where txdate = l_currDate --<= to_date(T_DATE,'DD/MM/RRRR') and txdate >=to_date(F_DATE,'DD/MM/RRRR')
                  and acctno = l_accountId group by acctno
              ) ad,
              (SELECT afacctno, SUM(TS_T2) TS_T2 FROM VW_MR9004  WHERE afacctno = l_accountId GROUP BY afacctno) v,
              (SELECT trfacctno, sum(marginamt) MRAMT from vw_lngroup_all where trfacctno = l_accountId GROUP BY trfacctno) lng,
              (SELECT trfacctno, sum(prinnml+prinovd) DFODAMT from lnmast where trfacctno = l_accountId and ftype = 'DF' GROUP BY trfacctno) lnm
          WHERE ci.afacctno = af.acctno
          AND af.actype = aft.actype
          AND aft.mrtype = mrt.actype
          AND af.acctno = se.acctno (+)
          AND af.acctno = bci.afacctno (+)
          AND af.acctno = ca.afacctno(+)
          AND af.acctno = v.afacctno(+)
          AND af.acctno = lng.trfacctno (+)
          AND af.acctno = lnm.trfacctno (+)
          AND af.acctno = ln.trfacctno (+)
          AND af.acctno = ad.acctno (+)
          AND af.acctno = l_accountId
      )
    ;
    plog.setEndSection(pkgctx, 'pr_GetAccountAsset');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_param := 'SYSTEM ERROR';
      plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_GetAccountAsset');
  END;

  /*
  /inq/accounts/{accountId}/avlSellOddLot - List Of available Sell Odd Lot
  */
  PROCEDURE pr_GetAvlSellOddLot (pv_refCursor IN OUT ref_cursor,
                               p_custId     IN VARCHAR2,
                               p_accountId  IN VARCHAR2 DEFAULT 'ALL',
                               p_err_code   OUT VARCHAR2,
                               p_err_param  OUT VARCHAR2)
  IS
  l_custId      VARCHAR2(30);
  l_accountId   VARCHAR2(30);
  l_currDate    DATE;
  l_advSellDuty NUMBER;
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_GetAvlSellOddLot');
    p_err_code := systemnums.C_SUCCESS;
    p_err_param := '';
    l_custId := p_custId;
    l_accountId := CASE WHEN NVL(upper(p_accountId), 'ALL') = 'ALL' THEN '%' ELSE p_accountId END;
    l_currDate := getcurrdate;
    BEGIN
      SELECT VARVALUE INTO l_advSellDuty
      from sysvar where varname = 'ADVSELLDUTY';
    EXCEPTION
      WHEN OTHERS THEN
        l_advSellDuty := 0;
    END;
    OPEN pv_refCursor
    FOR
      SELECT acctno                   accountId,
             SYMBOL                   symbol,
             QUANTITY                 quantity,
             QUOTEPRICE               price,
             AMOUNT                   amount,
             FEEAMT                   feeAmt,
             TAXAMT                   taxAmt,
             AMOUNT - FEEAMT - TAXAMT receiveAmt
      FROM
      (
          SELECT acctno,
                 SYMBOL,
                 QUANTITY,
                 QUOTEPRICE,
                 QUANTITY * QUOTEPRICE amount,
                 FN_CAL_FEE_AMT(QUANTITY * QUOTEPRICE,FEETYPE) feeAmt,
                 ROUND(QUANTITY * QUOTEPRICE * (TAXRATE/100)) taxAmt
          FROM
          (
               SELECT c.custodycd,
                      s.codeid,
                      inf.symbol,
                      inf.floorprice quoteprice,
                      least(nvl(s.trade,0) - nvl(vw.secureamt,0),
                      /*fn_GetCKLL(c.custodycd, s.codeid),*/mod(s.trade-nvl(vw.SECUREAMT,0),tradelot)) quantity,--1.7.4.0|iss:2374
                      '00009' feetype,
                      CASE WHEN T.VAT ='Y' THEN l_advSellDuty ELSE 0 END taxrate,
                      a.acctno
               FROM SEMAST S, AFMAST A, CFMAST C,AFTYPE T, SECURITIES_INFO INF, sbsecurities sec, v_getsellorderinfo vw
               WHERE S.AFACCTNO = A.ACCTNO AND A.CUSTID = C.CUSTID
               AND INF.CODEID = S.CODEID
               AND INF.CODEID = SEC.CODEID
               AND SEC.sectype <> '004'
               AND SEC.tradeplace in ('001', '002', '005')
               AND s.acctno = vw.seacctno(+)
               AND A.ACTYPE = T.ACTYPE
               AND A.ACCTNO LIKE l_accountId AND a.custid = p_custId
          )
      ) WHERE QUANTITY > 0
      order BY symbol

    ;
    plog.setEndSection(pkgctx, 'pr_GetAvlSellOddLot');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_param := 'SYSTEM ERROR';
      plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_GetAvlSellOddLot');
  END;

  /*
  /inq/accounts/{accountId}/bondsToSharesList - List Of bond 2 shares
  */
  PROCEDURE pr_GetBonds2SharesList (pv_refCursor IN OUT ref_cursor,
                               p_accountId  IN VARCHAR2,
                               p_err_code   OUT VARCHAR2,
                               p_err_param  OUT VARCHAR2)
  IS
  l_accountId   VARCHAR2(30);
  l_currDate    DATE;
  l_advSellDuty NUMBER;
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_GetAvlSellOddLot');
    p_err_code := systemnums.C_SUCCESS;
    p_err_param := '';
    l_accountId := p_accountId;
    l_currDate := getcurrdate;

    OPEN pv_refCursor
    FOR
        SELECT symbol         symbol,
               toSymbol       toSymbol,
               reportDate     reportDate,
               trade,
               exrate         transferRate,
               pQtty          avlRegistQtty,
               qtty           registedQtty,
               TO_CHAR(beginDate, 'dd/mm/rrrr')   beginDate,
               TO_CHAR(dueDate, 'dd/mm/rrrr')     dueDate,
               autoid         caSchdId
        from
        (
            SELECT CA.CAMASTID,CF.CUSTODYCD,AF.ACCTNO AFACCTNO,SEC1.SYMBOL,SEC2.SYMBOL TOSYMBOL,
                CA.REPORTDATE,SCHD.PQTTY,SCHD.TRADE,(SCHD.PQTTY+SCHD.QTTY) MAXQTTY,
                SCHD.QTTY,CA.BEGINDATE,CA.DUEDATE,SCHD.AUTOID,SEC1.CODEID,SEC2.CODEID TOCODEID,CA.EXRATE
            FROM CAMAST CA, CASCHD SCHD,CFMAST CF, AFMAST AF,SBSECURITIES SEC1, SBSECURITIES SEC2
            WHERE CA.CAMASTID=SCHD.CAMASTID
                AND SCHD.AFACCTNO=AF.ACCTNO AND AF.CUSTID=CF.CUSTID
                AND CA.CODEID=SEC1.CODEID AND CA.TOCODEID=SEC2.CODEID
                AND TO_DATE(CA.BEGINDATE,'DD/MM/RRRR') <= l_currDate
                AND TO_DATE(CA.DUEDATE,'DD/MM/RRRR') >= l_currDate
                AND CA.CATYPE='023' AND SCHD.STATUS='V'
                AND SCHD.PQTTY>=1
                AND SCHD.DELTD='N'
                AND AF.ACCTNO = l_accountId
            ORDER BY CA.CAMASTID
        ) a
    ;
    plog.setEndSection(pkgctx, 'pr_GetAvlSellOddLot');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_param := 'SYSTEM ERROR';
      plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_GetAvlSellOddLot');
  END;

  /*
  /inq/accounts/{accountId}/bankInfo - List Bank Account
  */
  PROCEDURE pr_getBankInfo (pv_refCursor IN OUT ref_cursor,
                           p_err_code    OUT VARCHAR2,
                           p_err_param   OUT VARCHAR2)
  IS
  BEGIN
    plog.setBeginSection (pkgctx, 'pr_getBankInfo');
    OPEN pv_refCursor
    FOR
       select bank_no bankNo,
              full_Name fullName
       from BANK_INFO
	   where bankcode = 'MSB'
       order by full_name
    ;
    plog.setEndSection (pkgctx, 'pr_getBankInfo');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_param := 'SYSTEM ERROR';
      plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_getBankInfo');
  END;

  /*
  /inq/accounts/{accountId}/bankBranchInfo - List Bank Account
  */
  PROCEDURE pr_getBankBranchInfo (pv_refCursor IN OUT ref_cursor,
                                 p_bankNo      IN VARCHAR2,
                                 p_err_code    OUT VARCHAR2,
                                 p_err_param   OUT VARCHAR2)
  IS
  BEGIN
    plog.setBeginSection (pkgctx, 'pr_getBankBranchInfo');
    OPEN pv_refCursor
    FOR
      select sb_branch_code    branchCode,
             FULL_NAME         fullName,
             org_no            orgNo
      from bank_branch_info
      WHERE BANK_NO = p_bankNo and bankcode = 'MSB'
      order by full_name
    ;
    plog.setEndSection (pkgctx, 'pr_getBankBranchInfo');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_param := 'SYSTEM ERROR';
      plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_getBankBranchInfo');
  END;

  /*
  /inq/accounts/{accountId}/templates - List Bank Account
  */
  PROCEDURE pr_getTemplates (pv_refCursor      IN OUT ref_cursor,
                            p_accountId        IN VARCHAR2,
                            p_type             IN VARCHAR2,
                            p_err_code    OUT VARCHAR2,
                            p_err_param   OUT VARCHAR2)
  IS
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_getTemplates');
    OPEN pv_refCursor
    FOR
      select code,
             subject,
             TYPE,
             register
      from
      (
         SELECT t.code, t.subject, t.type, decode(a.template_code, null, 'N', 'Y') register
         FROM templates t, (select * from aftemplates where AFACCTNO = p_accountId )a
         Where t.code = a.template_code(+)
         AND T.REQUIRE_REGISTER = 'Y'
         and T.TYPE = p_type
         AND T.CODE NOT IN ('0208','0334','0808','324A','324B','0555')
         Order by t.type, t.code
      ) a
    ;
    plog.setEndSection(pkgctx, 'pr_getTemplates');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_param := 'SYSTEM ERROR';
      plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_getBankBranchInfo');
  END;

  /*
  / Get loan policy.
  */
  procedure pr_get_loan_policy (p_refcursor in out ref_cursor,
                          p_err_code  in out varchar2,
                          p_err_param in out varchar2)
  AS
     c_mrbasketid   VARCHAR2(20) := 'MS';
     c_tobasketid   VARCHAR2(20) := 'MS TopUp VB';
  begin
    plog.setbeginsection(pkgctx, 'pr_get_loan_policy');
    p_err_code  := 0;
    p_err_param := '';

    open p_refcursor for
      SELECT sb.symbol NAME, iss.fullname description,
             SUM(mrratioloan) mrratioloan, SUM(toratioloan) toratioloan
      FROM (
        SELECT symbol, mrratioloan mrratioloan, 0 toratioloan FROM secbasket where basketid = c_mrbasketid
        UNION ALL
        SELECT symbol, 0 mrratioloan, mrratioloan toratioloan FROM secbasket where basketid = c_tobasketid
      ) sec, sbsecurities sb, issuers iss
      WHERE sec.symbol = sb.symbol
        AND sb.issuerid = iss.issuerid
        AND sb.status = 'Y'
      GROUP BY sb.symbol, iss.fullname
      HAVING SUM(mrratioloan) + SUM(toratioloan) > 0
      ORDER BY sb.symbol;

    plog.setendsection(pkgctx, 'pr_get_loan_policy');
  exception
    when others then
      p_err_code := -1;
      p_err_param := 'System Error';
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'pr_get_loan_policy');
  end;
  --------------------------------------------Others------------------------------------------------------------
  /*PROCEDURE pr_getSEList (pv_refCursor IN OUT ref_cursor,
                         p_accountId     VARCHAR2,
                         p_err_code      OUT VARCHAR2,
                         p_err_param     OUT VARCHAR2)
  IS
  BEGIN
    plog.setBeginSection (pkgctx, 'pr_getSEList');
    p_err_code := systemnums.C_SUCCESS;
    p_err_param := '';

    OPEN pv_refCursor FOR
       SELECT ACCTNO           acountId,
              ITEM             symbol,
              TOTAL            total,
              TRADE            trade,
              COSTPRICE        costPrice,
              BASICPRICE       basicPrice,

              CUSTODYCD, ,RECEIVING, SECURED,, COSTPRICE,
                                 RETAIL, S_REMAINQTTY,PROFITANDLOSS,PCPL,COSTPRICEAMT,,WFT_QTTY,MARKETAMT, RECEIVING_RIGHT,
                                 RECEIVING_T0,RECEIVING_T1, RECEIVING_T2, RECEIVING_T3, STT
                          FROM (SELECT
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
                                                        AND BUF.AFACCTNO = p_accountId
                                          ) SDTL1
                                          ON SDTL.ACCTNO = SDTL1.ACCTNO
                                    LEFT JOIN
                                        (
                                        SELECT TO_NUMBER( STOC.CLOSEPRICE) CLOSEPRICE,STOC.SYMBOL
                                        FROM STOCKINFOR STOC,SYSVAR SY
                                        WHERE  SY.GRNAME='SYSTEM' AND SY.VARNAME='CURRDATE'
                                        AND STOC.TRADINGDATE = SY.VARVALUE
                                         ) STIF
                                        ON REPLACE(SDTL.SYMBOL,'_WFT','') = STIF.SYMBOL
                                    LEFT JOIN
                                        (
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
                                    AND SDTL.CODEID = SEC.CODEID AND SDTL.AFACCTNO = p_accountId
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
                                        AND STOC.TRADINGDATE = SY.VARVALUE
                                     ) STIF, securities_info  sec

                                WHERE
                                NOT EXISTS (SELECT * FROM buf_se_account b WHERE b.afacctno  = P_FO.acctno AND b.symbol = P_FO.symbol)
                                AND P_FO.acctno  = PEX_FO.acctno(+) AND  P_FO.symbol  = PEX_FO.symbol(+)
                                AND P_FO.ACCTNO = OD.acctno(+) AND P_FO.SYMBOL = OD.SYMBOL(+)
                                AND a.acctno = P_FO.acctno
                                AND P_FO.SYMBOL = STIF.SYMBOL(+)
                                AND P_FO.SYMBOL = SEC.SYMBOL(+)
                                AND a.acctno = p_accountId
                                GROUP BY a.ACCTNO, a.CUSTODYCD, P_FO.SYMBOL,P_FO.TRADE

                            )
                             ORDER BY CUSTODYCD,ACCTNO,ITEM
                             ))

                          WHERE ACCTNO = p_accountId
       ;
    plog.setEndSection (pkgctx, 'pr_getSEList');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_param := 'SYSTEM ERROR';
      plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_getSEList');
  END;
  */
begin
   SELECT *
   INTO logrow
   FROM tlogdebug
   WHERE ROWNUM <= 1;

   pkgctx    :=
      plog.init ('fopks_inquiryApi',
                 plevel => logrow.loglevel,
                 plogtable => (logrow.log4table = 'Y'),
                 palert => (logrow.log4alert = 'Y'),
                 ptrace => (logrow.log4trace = 'Y')
      );
end fopks_inquiryApi;
/
