
CREATE OR REPLACE PACKAGE fopks_api IS

  /** ----------------------------------------------------------------------------------------------------
  ** Module: FO - API
  ** Description: FO API
  ** and is copyrighted by FSS.
  **
  **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
  **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
  **    graphic, optic recording or otherwise, translated in any language or computer language,
  **    without the prior written permission of Financial Software Solutions. JSC.
  **
  **  MODIFICATION HISTORY
  **  Person      Date           Comments
  **  ThongPM     14/04/2011     Created
  ** (c) 2008 by Financial Software Solutions. JSC.
  ----------------------------------------------------------------------------------------------------*/

  PROCEDURE pr_GetAccount(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                          CUSTODYCD   IN VARCHAR2,
                          AFACCTNO    IN VARCHAR2,
                          F_DATEBRID  IN VARCHAR2,
                          T_DATEBRID  IN VARCHAR2,
                          F_DATE      IN VARCHAR2,
                          T_DATE      IN VARCHAR2,
                          LN_RATE      IN VARCHAR2,
                          LN_YN    IN VARCHAR2,
                          TLID  IN VARCHAR2
                               );

  procedure sp_login(p_username      varchar2,
                     p_password      varchar2,
                     p_customer_id   in out varchar2,
                     p_customer_info in out varchar2,
                     p_err_code      in out varchar2,
                     p_err_param     in out varchar2);

  procedure sp_focore_login(USERNAME     varchar2,
                            PASSWORD     varchar2,
                            SenderCompID varchar2);

  function fn_logout(p_username  varchar2,
                     p_err_code  in out varchar2,
                     p_err_param out varchar2) return number;

  function fn_check_password_trading(p_username  varchar2,
                                     p_tpassword varchar2,
                                     p_err_code  in out varchar2,
                                     p_err_param out varchar2) return number;

  function fn_get_members(p_customer_id varchar2,
                          p_err_code    in out varchar2,
                          p_err_param   out varchar2) return number;

  procedure sp_audit_log(p_key varchar2, p_text varchar2);

  procedure sp_audit_authenticate(p_key  varchar2,
                                  p_type char,
                                  p_channel varchar2,
                                  p_text varchar2);

  function fn_is_ho_active return boolean;
  procedure pr_gen_buf_ci_account(p_acctno varchar2 default null);
  procedure pr_gen_buf_se_account(p_acctno varchar2 default null);
procedure pr_get_ciacount
    (p_refcursor in out pkg_report.ref_cursor,
    p_custodycd in VARCHAR2,
    p_afacctno  IN  varchar2);
procedure pr_get_seacount
    (p_refcursor in out pkg_report.ref_cursor,
    p_custodycd in VARCHAR2,
    p_afacctno  IN  varchar2);
PROCEDURE pr_gen_buf_od_account(p_acctno varchar2 default null);
PROCEDURE pr_CheckCashTransfer(p_account varchar,
                            p_type varchar2,
                            p_amount number,
                            p_RemainAmt number,
                            p_bankid varchar2,
                            p_err_code  OUT varchar2,
                            p_err_message out varchar2);
  PROCEDURE pr_InternalTransfer(p_account varchar,
                            p_toaccount  varchar2,
                            p_amount number,
                            p_desc varchar2,
                            p_err_code  OUT varchar2,
                            p_err_message out varchar2,
                            p_ipaddress in  varchar2 default '' , --1.5.3.0
                            p_via in varchar2 default '',
                            p_validationtype in varchar2 default '',
                            p_devicetype IN varchar2 default '',
                            p_device  IN varchar2 default '');
 PROCEDURE pr_ExternalTransfer(p_account varchar,
                            p_bankid varchar2,
                            p_benefbank varchar2,
                            p_benefacct varchar2,
                            p_benefcustname varchar2,
                            p_beneflicense varchar2,
                            p_amount number,
                            p_feeamt number,
                            p_vatamt number,
                            p_desc varchar2,
                            p_err_code  OUT varchar2,
                            p_err_message out varchar2,
                            p_ipaddress in  varchar2 default '' , --1.5.3.0
                            p_via in varchar2 default '',
                            p_validationtype in varchar2 default '',
                            p_devicetype IN varchar2 default '',
                            p_device  IN varchar2 default '');
 procedure pr_PlaceOrder(p_functionname in varchar2,
                        p_username in varchar2,
                        p_acctno in varchar2,
                        p_afacctno in varchar2,
                        p_exectype in varchar2,
                        p_symbol in varchar2,
                        p_quantity in number,
                        p_quoteprice in number,
                        p_pricetype in varchar2,
                        p_timetype in varchar2,
                        p_book in varchar2,
                        p_via in varchar2,
                        p_dealid in varchar2,
                        p_direct in varchar2,
                        p_effdate in varchar2,
                        p_expdate in varchar2,
                        p_tlid  IN  VARCHAR2,
                        p_quoteqtty in number,
                        p_limitprice in number,
                        p_err_code out varchar2,
                        p_err_message out VARCHAR2,
                        p_isdisposal IN  VARCHAR2 DEFAULT 'N',
                        p_ipaddress in  varchar2 default '' , --1.5.3.0
                        p_validationtype in varchar2 default '',
                        p_devicetype IN varchar2 default '',
                        p_device  IN varchar2 default '',
                        p_isdraft IN varchar2 default '',
                        p_draftid IN varchar2 default '',
                        p_issaved IN varchar2 default ''
                        );
procedure pr_get_rightofflist(p_refcursor in out pkg_report.ref_cursor,p_afacctno in varchar2);
PROCEDURE pr_trg_account_log (p_acctno in VARCHAR2, p_mod varchar2);
procedure pr_get_Portfolio(p_refcursor in out pkg_report.ref_cursor,
                             CUSTODYCD    IN VARCHAR2,
                             AFACCTNO       IN  VARCHAR2,
                             F_DATE         IN  VARCHAR2,
                             T_DATE         IN  VARCHAR2,
                             SYMBOL         IN  VARCHAR2,
                             GETTYPE        IN  VARCHAR2
                            ); -- Lay len danh muc dau tu cua khach hang
procedure pr_fo_fobannk2od(p_foorderid in varchar2);--dong bo lenh cua khach hang
PROCEDURE pr_GetOrder
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD    IN VARCHAR2,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     SYMBOL         IN  VARCHAR2,
     EXECTYPE      IN  VARCHAR2,
     STATUS         IN  VARCHAR2); -- Lay thong tin lenh giao dich
PROCEDURE pr_GetGTCOrder
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD    IN VARCHAR2,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     SYMBOL         IN  VARCHAR2,
     EXECTYPE      IN  VARCHAR2,
     STATUS         IN  VARCHAR2);
PROCEDURE pr_GetTradeDiary
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD    IN VARCHAR2,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     SYMBOL         IN  VARCHAR2,
     EXECTYPE      IN  VARCHAR2); -- Lay thong tin nhat ky giao dich
PROCEDURE pr_GetMatchOrder
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD    IN VARCHAR2,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     SYMBOL         IN  VARCHAR2,
     EXECTYPE      IN  VARCHAR2); -- Lay thong tin lenh khop

PROCEDURE pr_GetTotalInvesment
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,

     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2);

PROCEDURE pr_MoneyTransDetail
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2,
     P_STATUS       in  varchar2 default 'ALL',
     P_PLACE        in  varchar2 default 'ALL',
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2);

PROCEDURE pr_RightoffRegiter
    (p_camastid IN   varchar,
    p_account   IN   varchar,
    p_qtty      IN   number,
    p_desc      IN   varchar2,
    p_err_code  OUT varchar2,
    p_err_message  OUT varchar2,
    p_ipaddress in  varchar2 default '' , --1.5.3.0
    p_via in varchar2 default '',
    p_validationtype in varchar2 default '',
    p_devicetype IN varchar2 default '',
    p_device  IN varchar2 default ''
    );
PROCEDURE pr_GetInfor4AdvancePayment
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2
    ); -- LAY THONG TIN DE LAM DE NGHI UTTB
PROCEDURE pr_GetCashStatement
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN       VARCHAR2,
     T_DATE         IN       VARCHAR2
    ); -- Sao ke tien
PROCEDURE pr_GetSecuritiesStatement
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN       VARCHAR2,
     T_DATE         IN       VARCHAR2,
     SYMBOL         IN  VARCHAR2
    ); -- Sao ke chung khoan
PROCEDURE pr_GetCashTransfer
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD    IN VARCHAR2,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     STATUS         IN  VARCHAR2
     );    -- Lay thong tin chuyen khoan tien
PROCEDURE pr_GetRightOffInfor
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD    IN VARCHAR2,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2
     ); -- LAY THONG TIN GD QUYEN MUA
PROCEDURE pr_AdvancePayment
    (p_afacctno varchar,
     p_txdate varchar2,
     p_duedate varchar2,
     p_advamt number,
     p_feeamt NUMBER,
     p_advdays NUMBER,
     p_maxamt    NUMBER,
     p_desc varchar2,
     p_err_code  OUT varchar2,
     p_err_message  OUT VARCHAR2,
     p_ipaddress in  varchar2 default '' , --1.5.3.0
     p_via in varchar2 default '',
     p_validationtype in varchar2 default '',
     p_devicetype IN varchar2 default '',
     p_device  IN varchar2 default ''
    ); -- HAM THUC HIEN UNG TRUOC TIEN BAN
PROCEDURE pr_AdjustCostprice_Online
    (   p_afacctno varchar,
        p_symbol    VARCHAR2,
        p_newcostprice  number,
        p_desc varchar2,
        p_err_code  OUT varchar2,
        p_err_message  OUT varchar2
    ); -- HAM THUC HIEN DIEU CHINH GIA VON ONLINE
PROCEDURE pr_GetAdvancedPayment
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN VARCHAR2,
     T_DATE         IN VARCHAR2,
     STATUS         IN VARCHAR2,
     ADVPLACE       IN VARCHAR2
    ); -- LAY THONG TIN HOP DONG UNG TRUOC DA THUC HIEN
PROCEDURE pr_Allocate_Guarantee_BD
    (   p_custodycd VARCHAR,
        p_afacctno varchar,
        p_amount  number,
        p_userid    varchar,
        p_desc varchar2,
        p_err_code  OUT varchar2,
        p_err_message  OUT varchar2
    ); -- Thuc hien cap han muc bao lanh tien mua tren MHMG
PROCEDURE pr_GetSecureRatio
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2,
     SYMBOL         IN  VARCHAR2,
     EXECTYPE       IN  VARCHAR2,
     PRICETYPE      IN  VARCHAR2,
     TIMETYPE       IN  VARCHAR2,
     QUOTEPRICE     IN  NUMBER,
     ORDERQTTY      IN  NUMBER,
     VIA            IN  VARCHAR2 DEFAULT 'F'
    ); -- HAM LAY TY LE KY QUY
PROCEDURE pr_OnlineUpdateCustomerInfor
    (   p_custodycd VARCHAR,
        p_custid varchar,
        p_address   VARCHAR2,
        p_phone     VARCHAR2,
        p_coaddress    VARCHAR2,
        p_cophone  VARCHAR2,
        p_email     VARCHAR2,
        p_desc varchar2,
        p_err_code  OUT varchar2,
        p_err_message  OUT varchar2
    ); -- HAM THUC HIEN CAP NHAT THONG TIN KHACH HANG ONLINE
PROCEDURE pr_CashTransferWithIDCode
    (   p_afacctno varchar,
        p_BENEFCUSTNAME   VARCHAR2,
        p_RECEIVLICENSE     VARCHAR2,
        p_RECEIVIDDATE    VARCHAR2,
        p_RECEIVIDPLACE  VARCHAR2,
        p_BANKNAME     VARCHAR2,
        p_CITYBANK     VARCHAR2,
        p_CITYEF     VARCHAR2,
        p_AMT           NUMBER,
        p_desc varchar2,
        p_err_code  OUT varchar2,
        p_err_message  OUT varchar2
    ); -- HAM THUC HIEN CHUYEN KHOAN RA NGOAI VOI CMND
FUNCTION fn_GetODACTYPE
    (AFACCTNO       IN  VARCHAR2,
     SYMBOL         IN  VARCHAR2,
     CODEID         IN  VARCHAR2,
     TRADEPLACE     IN  VARCHAR2,
     EXECTYPE       IN  VARCHAR2,
     PRICETYPE      IN  VARCHAR2,
     TIMETYPE       IN  VARCHAR2,
     AFTYPE         IN  VARCHAR2,
     SECTYPE        IN  VARCHAR2,
     VIA            IN  VARCHAR2
    ) RETURN VARCHAR2; -- LAY THONG TIN LOAI HINH LENH
PROCEDURE pr_GetGroupDFInfor
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2
     ); -- LAY THONG TIN KHOAN VAY DF TONG CHUA THANH TOAN
PROCEDURE pr_GetDetailDFInfor
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2,
     GROUPDFID      IN  VARCHAR2
     ); -- LAY THONG TIN KHOAN VAY DF CHI TIET
PROCEDURE pr_PaidDealOnline
    (   p_afacctno varchar,
        p_groupdealid    VARCHAR2,
        p_paidamt  number,
        p_desc varchar2,
        p_err_code  OUT varchar2,
        p_err_message  OUT varchar2
    ); -- HAM THUC HIEN THANH TOAN DEAL VAY
function fn_CheckActiveSystem
    return NUMBER; -- Check host & branch active or inactive
PROCEDURE pr_GetDFTransHistory
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
    CUSTODYCD       IN VARCHAR2,
    AFACCTNO       IN  VARCHAR2,
    F_DATE         IN VARCHAR2,
    T_DATE         IN VARCHAR2,
    GROUPDFID      IN VARCHAR2,
    SYMBOL         IN   VARCHAR2
    ); -- Lay thong tin lich su giao dich cam co
PROCEDURE pr_AllocateAVDL3rdAccount
    (   p_custodycd VARCHAR,
        p_afacctno varchar,
        p_amount  number,
        p_userid    varchar,
        p_desc varchar2,
        p_err_code  OUT varchar2,
        p_err_message  OUT varchar2
    ); -- HAM THUC HIEN CAP HAN MUC BAO LANH CHO TK LUU KY TAI NOI KHAC
PROCEDURE pr_AllocateStock3rdAccount
    (   p_custodycd VARCHAR,
        p_afacctno varchar,
        p_symbol    VARCHAR,
        p_qtty  number,
        p_userid    varchar,
        p_desc varchar2,
        p_err_code  OUT varchar2,
        p_err_message  OUT varchar2
    ); -- HAM THUC HIEN CAP THEM SO DU CK CHO TK LUU KY TAI NOI KHAC
PROCEDURE pr_RightoffRegiter2BO
    (p_camastid IN   varchar,
    p_account   IN   varchar,
    p_qtty      IN   number,
    p_desc      IN   varchar2,
    p_txnum     OUT  VARCHAR2, --1.5.3.0
    p_err_code  OUT varchar2,
    p_err_message  OUT varchar2
    ); -- HAM THUC HIEN GD DANG KY QUYEN MUA
PROCEDURE pr_RORSyn2BO;
PROCEDURE pr_RORSynBank2BO
    (
    p_RQLogID   IN   NUMBER
    ); -- HAM THUC HIEN GOI GD DANG KY QUYEN MUA TH KET NOI NH
PROCEDURE pr_ROR2BO
    (
    p_RQLogID   IN   NUMBER,
    p_err_code  OUT  NUMBER,
    p_err_message   OUT  varchar2
    ); -- HAM THUC HIEN DANG KY QUYEN MUA CHO KHACH HANG KO KET NOI NH
FUNCTION fn_GetRootOrderID
    (p_OrderID       IN  VARCHAR2
    ) RETURN VARCHAR2; -- HAM THUC HIEN LAY SO HIEU LENH GOC CUA LENH
PROCEDURE pr_get_gtcorder_root_hist
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTID    IN VARCHAR2,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     SYMBOL         IN  VARCHAR2,
     EXECTYPE      IN  VARCHAR2,
     STATUS         IN  VARCHAR2); -- LAY LENH GOC CUA LENH GTC
PROCEDURE pr_GetDFPaidHistory
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
    pv_RowCount    IN OUT  NUMBER,
    pv_PageSize    IN  NUMBER,
    pv_PageIndex   IN  NUMBER,
    AFACCTNO       IN  VARCHAR2,
    GROUPDFID      IN VARCHAR2,
    F_DATE         IN VARCHAR2,
    T_DATE         IN VARCHAR2
    ); -- LAY THONG TIN THANH TOAN KHOAN VAY DF
PROCEDURE pr_GetGroupDFInforAll
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     pv_RowCount    IN OUT  NUMBER,
     pv_PageSize    IN  NUMBER,
     pv_PageIndex   IN  NUMBER,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2
     ); -- LAY THONG TIN KHOAN VAY DF
PROCEDURE pr_GetDetailDFInforAll
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     --pv_RowCount    IN OUT  NUMBER,
     --pv_PageSize    IN  NUMBER,
     --pv_PageIndex   IN  NUMBER,
     AFACCTNO       IN  VARCHAR2,
     GROUPDFID      IN  VARCHAR2
     --F_DATE         IN  VARCHAR2,
     --T_DATE         IN  VARCHAR2
     ); -- LAY THONG TIN KHOAN VAY DF CHI TIET
PROCEDURE pr_GetDFPaidDetail
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
    pv_TXDATE       IN  VARCHAR2,
    pv_TXNUM      IN VARCHAR2
    ); -- LAY CHI TIET SO CK GIAI TOA (GD 2246 ONLY)
PROCEDURE pr_RefreshCIAccount
    (   p_afacctno varchar,
        p_err_code  OUT varchar2,
        p_err_message  OUT varchar2
    ); -- HAM THUC HIEN CAP NHAT THONG TIN SUC MUA
procedure pr_get_rightinfo
    (p_refcursor in out pkg_report.ref_cursor,
    F_DATE in VARCHAR2,
    T_DATE  IN  varchar2,
    PV_CUSTODYCD  IN  VARCHAR2,
    PV_AFACCTNO  IN  VARCHAR2,
    ISCOM             IN       VARCHAR2);--Ham tra cuu su kien quyen
PROCEDURE pr_GetBonds2SharesList
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD    IN VARCHAR2,
     AFACCTNO       IN  VARCHAR2
     ); -- HAM LAY DANH SACH THQ CHUYEN TRAI PHIEU --> CO PHIEU
PROCEDURE pr_Bonds2SharesRegister
    (p_caschdautoid IN   varchar,
    p_afacctno   IN   varchar,
    p_qtty      IN   number,
    p_desc      IN   varchar2,
    p_err_code  OUT varchar2,
    p_err_message  OUT varchar2,
    p_ipaddress in  varchar2 default '' , --1.5.3.0
    p_via in varchar2 default '',
    p_validationtype in varchar2 default '',
    p_devicetype IN varchar2 default '',
    p_device  IN varchar2 default ''
    ); -- HAM THUC HIEN DANG KY CHUYEN TRAI PHIEU --> CO PHIEU
PROCEDURE pr_LoanHist
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD    IN VARCHAR2,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2
     );--HAM TRA CUU DU NO
 PROCEDURE pr_CreateTermDeposit
    (p_afacctno IN  varchar,
    p_tdactype  IN  VARCHAR,
    p_amt       IN  number,
    p_auto       IN  VARCHAR,
    p_desc      IN  varchar2,
    p_err_code  OUT varchar2,
    p_err_message  OUT varchar2
    ); -- HAM THUC HIEN GIAO DICH TAO HOP DONG TIET KIEM
PROCEDURE pr_TermDepositWithdraw
    (p_afacctno     IN  varchar,
    p_tdacctno      IN  VARCHAR,
    p_withdrawamt   IN  number,
    p_desc          IN  varchar2,
    p_err_code      OUT varchar2,
    p_err_message   OUT varchar2
    ); -- HAM THUC HIEN GIAO DICH RUT TIEN TIET KIEM
PROCEDURE pr_OnlineRegister(
      p_CustomerType IN VARCHAR2,
       p_CustomerName IN VARCHAR2,
       P_Sex in VARCHAR2,
       p_CustomerBirth IN VARCHAR2,
       p_IDType IN VARCHAR2,
       p_IDCode IN VARCHAR2,
       p_Iddate IN VARCHAR2,
       p_Idplace IN VARCHAR2,
       p_Address IN VARCHAR2,
       p_ContactAddress IN VARCHAR2,
       p_Taxcode IN VARCHAR2,
       p_PrivatePhone IN VARCHAR2,
       p_Mobile IN VARCHAR2,
       p_WorkMobile IN VARCHAR2,
       p_Fax IN VARCHAR2,
       p_Email IN VARCHAR2,
       p_Country IN VARCHAR2,
       p_CustomerCity IN VARCHAR2,
       p_Certificate      IN VARCHAR2,
       p_CertificateDate  in VARCHAR2,
       p_CertificatePlace IN VARCHAR2,
       p_Business         IN VARCHAR2,
       p_AgentName        IN VARCHAR2,
       p_AgentPosition    IN VARCHAR2,
       p_AgentCountry     IN VARCHAR2,
       p_AgentSex         IN VARCHAR2,
       p_AgentId          IN VARCHAR2,
       p_AgentPhone       IN VARCHAR2,
       p_AgentEmail       IN VARCHAR2,
       p_OtherAccount1 IN VARCHAR2,
       p_OtherCompany1 IN VARCHAR2,
       p_FixedIncome      IN VARCHAR2,
       p_LongGrowth      IN VARCHAR2,
       p_MidGrowth        IN VARCHAR2,
       p_ShortGrowth      IN VARCHAR2,
       p_LowRisk          IN VARCHAR2,
       p_MidRisk         IN VARCHAR2,
       p_HighRisk         IN VARCHAR2,
       p_ManageCompanyName    IN VARCHAR2,
       p_ShareholderCompanyName IN VARCHAR2,
       p_InvestKnowlegde      IN VARCHAR2,
       p_InvestExperience     IN VARCHAR2,
       p_IsTrustAcctno        IN VARCHAR2,
       p_TrustFullname        IN VARCHAR2,
       p_Relationship         IN VARCHAR2,
       p_DealStockType        IN VARCHAR2,
       p_DealMethod           IN VARCHAR2,
       p_DealResult           IN VARCHAR2,
       p_DealStatement        IN VARCHAR2,
       p_DealTax              IN VARCHAR2,
       p_BeneficiaryName      IN VARCHAR2,
       p_BeneficiaryBirthday  IN VARCHAR2,
       p_BeneficiaryPhone     IN VARCHAR2,
       p_BeneficiaryId        IN VARCHAR2,
       p_BeneficiaryIdDate    IN VARCHAR2,
       p_BeneficiaryIdPlace   IN VARCHAR2,
       p_AuthorizedName       IN VARCHAR2,
       p_AuthorizedPhone      IN VARCHAR2,
       p_AuthorizedId         IN VARCHAR2,
       p_AuthorizedIdDate     IN VARCHAR2,
       p_AuthorizedIdPlace    IN VARCHAR2,
       p_Custodycd            IN VARCHAR2,
       p_TrustPhone           IN VARCHAR2,
       p_AuthorizedBirthday   IN VARCHAR2,
       p_AgentIDDate in VARCHAR2,
       p_AgentIDPlace in varchar2,
       p_brid in varchar2,
       p_err_code  OUT varchar2,
       p_err_message  OUT varchar2
    );--Ham dang ky online
  PROCEDURE pr_GetTDhist
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2
     );--Ham tra cuu tiet kiem
PROCEDURE pr_GetNetAsset
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     p_AFACCTNO    IN VARCHAR2
     );--Ham tra cuu tong tai san
PROCEDURE pr_TermDepositRegister
    (p_afacctno     IN  varchar,
    p_tdacctno      IN  VARCHAR,
    p_desc          IN  varchar2,
    p_err_code      OUT varchar2,
    p_err_message   OUT varchar2
    );--Ham dang ky tu dong rut tiet kiem
PROCEDURE pr_GetConvertBondHist
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2
     );--Ham tra cuu chuyen doi trai phieu thanh co phieu
PROCEDURE pr_GetRePaymentHist
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     p_AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2
     );--Ham tra cuu thong tin tra no
PROCEDURE pr_GetConfirmOrderHist
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     EXECTYPE       IN  VARCHAR2
     );--Ham tra cuu lenh xac nhan
PROCEDURE pr_GetConfirmOrderHistByCust
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD      IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     EXECTYPE       IN  VARCHAR2
     );--Ham tra cuu lenh xac nhan
procedure pr_regtranferacc(p_check in varchar2,--check hay thuc hien luu luon           --1.5.1.3   OTP
                        p_type in varchar2,
                        p_afacctno in varchar2,
                        p_ciacctno in varchar2,
                        p_ciname in varchar2,
                        p_bankacc in varchar2,
                        p_bankacname in varchar2,
                        p_bankname in varchar2,
                        p_cityef in varchar2,
                        p_citybank in varchar2,
                        p_bankid in varchar2,
                        P_bankorgno in varchar2,
                        p_err_code out varchar2,
                        p_err_message out VARCHAR2,
                        p_ipaddress in  varchar2 default '' , --1.5.3.0
                        p_via in varchar2 default '',
                        p_validationtype in varchar2 default '',
                        p_devicetype IN varchar2 default '',
                        p_device  IN varchar2 default ''

                        );-- Ham dang ky so tk chuyen khoan
procedure pr_EditTranferacc(p_type in varchar2,-- 0 : Chuyen khoan noi bo.  1: Chuyen khoan ra NH
                        p_afacctno in varchar2,-- So tieu khoan goc
                        p_ciacctno in varchar2,-- So tieu khoan nhan trong truong hop chuyen khoan noi bo
                        p_ciname in varchar2,  -- Ten tieu khoan nhan trong truong hop chuyen khoan noi bo
                        p_bankacc in varchar2, -- So tk Ngan hang
                        p_bankacname in varchar2, -- Ten chu TK ngan hang
                        p_ciacctno_old in varchar2,-- So tieu khoan nhan cu trong truong hop chuyen khoan noi bo
                        p_bankacc_old in varchar2, -- So tk Ngan hang cu
                        p_err_code out varchar2,
                        p_err_message out VARCHAR2
                        );-- Ham sua so tk chuyen khoan
procedure pr_RemoveTranferacc(p_type in varchar2,-- 0 : Chuyen khoan noi bo.  1: Chuyen khoan ra NH
                        p_afacctno in varchar2,-- So tieu khoan goc
                        p_ciacctno in varchar2,-- So tieu khoan nhan trong truong hop chuyen khoan noi bo
                        p_bankacc in varchar2, -- So tk Ngan hang
                        p_err_code out varchar2,
                        p_err_message out VARCHAR2
                        );-- Ham xoa so tk chuyen khoan
PROCEDURE pr_resetpassonline(p_username varchar,
                            p_idcode  varchar2,
                            p_mobile number,
                            p_email varchar2,
                            p_err_code  OUT varchar2,
                            p_err_message out varchar2);
--Dang ky ban chung khoan lo le
PROCEDURE pr_Tradelot_Retail
    (   p_sellafacctno varchar2,
        p_symbol    VARCHAR2,
        p_quantity varchar2,
        p_quoteprice varchar2,
        p_err_code  OUT varchar2,
        p_err_message  OUT varchar2
    );
--Huy dang ky ban lo le.
PROCEDURE pr_Cancel_Tradelot_Retail(   p_sellafacctno varchar2,
                                p_symbol    VARCHAR2,
                                p_txnum varchar2,
                                p_txdate varchar2,
                                p_err_code  OUT varchar2,
                                p_err_message out varchar2);
--Chuyen khoan chung khoan noi bo
PROCEDURE pr_Transfer_SE_account(p_trfafacctno varchar2,
                                p_rcvafacctno varchar2,
                                p_symbol    VARCHAR2,
                                p_quantity varchar2,
                                p_blockedqtty varchar2,
                                p_err_code  OUT varchar2,
                                p_err_message out varchar2);
--Lay danh sach dang ky  ban lo le
procedure pr_get_TradelotRetail(p_refcursor in out pkg_report.ref_cursor,
          p_afacctno in varchar2,
          p_symbol in varchar,
          f_date in varchar2,
          t_date in varchar2,
          pv_status in varchar2);
-- Dang kys dich vu
procedure pr_regservice(p_afacctno in varchar2,
                        p_sertype in varchar2,
                        p_refid in varchar2,
                        p_err_code out varchar2,
                        p_err_message out VARCHAR2
                        );
-- Lay phi chuyen khoan ra ngoai
function fn_getExTransferMoneyFee(p_amount number,
                                  p_bankid varchar2
                                ) return number;
-- lay phi chuyen khoan noi bo
function fn_getInTransferMoneyFee(p_account varchar,
                                  p_toaccount  varchar2,
                                  p_amount number
                                ) return number ;
procedure pr_regalert(p_custid in varchar2,
                        p_regsms in varchar2,
                        p_err_code out varchar2,
                        p_err_message out VARCHAR2
                        );-- Dang k? dich vu canh bao

procedure pr_updateregalert(p_custid in varchar2,
                        p_stopalert in varchar2,
                        p_regsms in varchar2,
                        p_err_code out varchar2,
                        p_err_message out VARCHAR2
                        );-- Dk/huy dich vu canh bao

procedure pr_regalertfile(p_custid in varchar2,
                          p_fullname in varchar2,
                          p_altype in varchar2,
                          p_symbol in varchar2,
                          p_smsnotify in varchar2,
                          p_emailnotify in varchar2,
                          P_autoid out number,
                          p_err_code out varchar2,
                          p_err_message out VARCHAR2
                        );
procedure pr_regalertdtl(p_regfileid in varchar2,
                          p_alterid in varchar2,
                          p_alvalue in VARCHAR2,
                          p_err_code out varchar2,
                          p_err_message out VARCHAR2
                        );
PROCEDURE pr_GetAFTemplates
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     p_AFACCTNO    IN VARCHAR2
     );
PROCEDURE pr_EditAFTemplates
    (   p_AFACCTNO    IN VARCHAR2,
        p_template_code in varchar2,
        p_type in varchar2, -- ADD or REMOVE
        p_err_code out varchar2,
        p_err_message out VARCHAR2
     );
PROCEDURE pr_updatepassonline(p_username varchar,
                              P_pwtype   varchar2,
                              P_password   varchar2,
                              p_err_code  OUT varchar2,
                              p_err_message out varchar2);
function fn_getCustodycd return varchar2;
PROCEDURE pr_GetOnlineregister
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     p_CUSTODYCD    IN VARCHAR2,
     p_idcode       in varchar2
     );
procedure pr_EmailAlert(p_custid in varchar2,
                          p_alerttype in varchar2,
                          p_symbols in varchar2,
                          p_message in varchar2,
                          p_alertdt in varchar2,
                          p_err_code out varchar2,
                          p_err_message out VARCHAR2
                        );
PROCEDURE pr_GetMR1810
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     p_TLID    IN VARCHAR2
     );
PROCEDURE pr_GetNetAssetDetail
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     p_AFACCTNO    IN VARCHAR2
     );--Ham tra cuu tong tai san  chi tiet
PROCEDURE pr_GetNetAssetDetail_byCus
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     p_CUSTODYCD in varchar2,
     p_AFACCTNO    IN VARCHAR2
     );
PROCEDURE pr_AllocateGuaranteeT0(
                                P_USERID        VARCHAR2,
                                P_USERTYPE        VARCHAR2,
                                P_ACCTNO        VARCHAR2,
                                P_TOAMT        VARCHAR2,
                                P_ACCLIMIT        VARCHAR2,
                                P_RLIMIT        VARCHAR2,
                                P_ACCUSED        VARCHAR2,
                                P_DEAL              VARCHAR2, -- 1.5.8.9|iss:2046
                                P_CUSTAVLLIMIT        VARCHAR2,
                                P_MARGINRATE        VARCHAR2,
                                P_SETOTAL        VARCHAR2,
                                P_TOTALLOAN        VARCHAR2,
                                P_PP        VARCHAR2,
                                P_PERIOD        VARCHAR2,
                                P_T0AMTUSED        VARCHAR2,
                                P_T0AMTPENDING        VARCHAR2,
                                P_SYMBOLAMT        VARCHAR2,
                                P_SOURCE        VARCHAR2,
                                P_TLID        VARCHAR2,
                                P_DESC        VARCHAR2,
                                P_T0CAL        VARCHAR2,
                                P_ADVANCELINE        VARCHAR2,
                                P_T0OVRQ        VARCHAR2,
                                P_T0DEB        VARCHAR2,
                                P_CONTRACTCHK        VARCHAR2,
                                P_CUSTODYCD        VARCHAR2,
                                P_MARGINRATE_T0        VARCHAR2,
                                P_FULLNAME        VARCHAR2,
                                P_TLFULLNAME        VARCHAR2,
                                P_TLIDNAME        VARCHAR2,
                                P_TLGROUP           VARCHAR2,
                            p_err_code  OUT varchar2,
                            p_err_message out varchar2);
PROCEDURE pr_ReleaseGuaranteeT0(
                            P_USERID        varchar2,
                            P_ACCTNO     VARCHAR2,
                            P_ADVT0AMT      VARCHAR2,
                            P_ADVT0AMTMAX   VARCHAR2,
                            P_ADVAMTHIST     VARCHAR2,
                            P_ADVAMTHISTMAX      VARCHAR2,
                            P_DESC          varchar2,
                          --  P_DEAL          VARCHAR2,
                            p_err_code  OUT varchar2,
                            p_err_message out varchar2);
PROCEDURE pr_Getmrratioloan
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     p_afacctno in varchar2,
     p_symbol    IN VARCHAR2
     );
PROCEDURE pr_getEXT0AMT
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     p_afacctno in varchar2
     );
procedure pr_get_ciacount_short
    (p_refcursor in out pkg_report.ref_cursor,
    p_custodycd in VARCHAR2,
    p_afacctno  IN  varchar2);
PROCEDURE pr_GetCustomIntroduceList
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     p_custid    IN VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2
    );
PROCEDURE pr_CustomIntroduceDoing
    (   p_type varchar2,
        p_id    VARCHAR2,
        p_fullname  varchar2,
        p_sex  varchar2,
        p_mobile  varchar2,
        p_introDate  varchar2,
        p_desc varchar2,
        p_custidintro varchar2,
        p_err_code  OUT varchar2,
        p_err_message  OUT varchar2
    );
procedure pr_get_ADDVND
    (p_refcursor in out pkg_report.ref_cursor,
    p_custodycd in VARCHAR2,
    p_afacctno  IN  varchar2);
PROCEDURE pr_list_loan_t0 (
    PV_REFCURSOR        IN OUT  PKG_REPORT.REF_CURSOR,
    PV_AFACCTNO         IN      VARCHAR2,
    PV_TLID             IN      VARCHAR2
    );
PROCEDURE pr_Allocate_T0_Information (
    PV_REFCURSOR        IN OUT  PKG_REPORT.REF_CURSOR,
    PV_AFACCTNO         IN      VARCHAR2,
    PV_AMT              IN      VARCHAR2,
    PV_USERID           IN      VARCHAR2
    );

PROCEDURE pr_GetCustomRightoffList
(
    P_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
    P_CUSTODYCD     IN      VARCHAR2,
    P_FULLNAME      IN      VARCHAR2,
    P_CATYPE        IN      VARCHAR2,
    P_SYMBOL        IN      VARCHAR2,
    PV_TLID         IN      VARCHAR2
)  ;
PROCEDURE pr_updatepasspinonline(p_username IN varchar,
                              P_password   IN varchar2,
                              P_pin       IN   varchar2,
                              p_err_code  OUT varchar2,
                              p_err_message out VARCHAR2,
                              p_via  IN varchar2 default 'A'
);
PROCEDURE GET_MODULE_PERMISSION(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                                pv_strCUSTID IN VARCHAR2,
                                pv_strVIA IN VARCHAR2 DEFAULT 'A');
PROCEDURE pr_GETCONTRACTLIST(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                             pv_strCUSTID IN VARCHAR2,
                             pv_strVIA IN VARCHAR2 DEFAULT 'A');
PROCEDURE pr_GET_ACCOUNT_INFO_T0
    (p_REFCURSOR    IN OUT PKG_REPORT.REF_CURSOR,
     PV_CUSTODYCD   IN VARCHAR2,
     p_AFACCTNO       IN  VARCHAR2,
     p_TLID         IN VARCHAR2
    );

PROCEDURE pr_inquiry_draft_odgroup
    (p_REFCURSOR    IN OUT PKG_REPORT.REF_CURSOR,
     PV_USERID      IN VARCHAR2
    );
PROCEDURE pr_add_draft_odgroup
    (PV_USERID      IN VARCHAR2,
     PV_GROUPNAME   IN VARCHAR2,
   PV_NOTE        IN VARCHAR2,
     p_errcode      OUT VARCHAR2,
     p_err_message  OUT VARCHAR2
    );
PROCEDURE pr_edit_draft_odgroup
    (PV_ID          IN VARCHAR2,
     PV_USERID      IN VARCHAR2,
     PV_GROUPNAME   IN VARCHAR2,
   PV_NOTE        IN VARCHAR2,
     p_errcode      OUT VARCHAR2,
     p_err_message  OUT VARCHAR2
    );
PROCEDURE pr_delete_draft_odgroup
    (PV_ID          IN VARCHAR2,
     PV_USERID      IN VARCHAR2,
     p_errcode      OUT VARCHAR2,
     p_err_message  OUT VARCHAR2
    );
PROCEDURE pr_inquiry_draft_order
    (p_REFCURSOR    IN OUT PKG_REPORT.REF_CURSOR,
     PV_USERID      IN VARCHAR2,
     PV_GROUPID     IN VARCHAR2
    );
PROCEDURE pr_add_draft_order
    (PV_USERID      IN VARCHAR2,
     PV_GROUPID     IN VARCHAR2,
     PV_CUSTODYCD   IN VARCHAR2,
     PV_ACCTNO      IN VARCHAR2,
     PV_EXECTYPE    IN VARCHAR2,
     PV_SYMBOL      IN VARCHAR2,
     PV_PRICE       IN VARCHAR2,
     PV_QTTY        IN VARCHAR2,
     PV_PRICETYPE   IN VARCHAR2,
     p_errcode      OUT VARCHAR2,
     p_err_message  OUT VARCHAR2
    );
PROCEDURE pr_edit_draft_order
    (PV_AUTOID      IN VARCHAR2,
     PV_USERID      IN VARCHAR2,
     PV_GROUPID     IN VARCHAR2,
     PV_CUSTODYCD   IN VARCHAR2,
     PV_ACCTNO      IN VARCHAR2,
     PV_EXECTYPE    IN VARCHAR2,
     PV_SYMBOL      IN VARCHAR2,
     PV_PRICE       IN VARCHAR2,
     PV_QTTY        IN VARCHAR2,
     PV_PRICETYPE   IN VARCHAR2,
     p_errcode      OUT VARCHAR2,
     p_err_message  OUT VARCHAR2
    );
PROCEDURE pr_delete_draft_order
    (PV_AUTOID      IN VARCHAR2,
     p_errcode      OUT VARCHAR2,
     p_err_message  OUT VARCHAR2
    );
PROCEDURE pr_copy_draft_order
    (PV_AUTOID      IN VARCHAR2,
     PV_GROUPID     IN VARCHAR2,
     PV_USERID      IN VARCHAR2,
   PV_ISSAVE      IN VARCHAR2,
     p_errcode      OUT VARCHAR2,
     p_err_message  OUT VARCHAR2
    );
PROCEDURE pr_update_draft_order
    (pv_isdraft      IN VARCHAR2,
     pv_draftid      IN VARCHAR2,
     pv_issaved      IN VARCHAR2,
     pv_errcode      IN VARCHAR2,
     pv_errmsg       IN VARCHAR2
    );
PROCEDURE pr_Depoacc2Transfer(p_dcustodycd VARCHAR2,
                              p_dacctno  varchar2,
                              p_ccustodycd varchar2,
                              p_cacctno varchar2,
                              p_amount NUMBER,
                              p_err_code  OUT varchar2,
                              p_err_message out varchar2,
                              p_ipaddress in  varchar2 default '' ,
                              p_via in varchar2 default '',
                              p_validationtype in varchar2 default '',
                              p_devicetype IN varchar2 default '',
                              p_device  IN varchar2 default '',
                              p_desc VARCHAR2 default '');

PROCEDURE pr_GetTransferAccountlist (pv_refCursor IN OUT pkg_report.ref_cursor,
                               p_accountId  IN VARCHAR2,
                               transferType IN VARCHAR2);
END fopks_api;
/
CREATE OR REPLACE PACKAGE BODY fopks_api is

  -- Private type declarations

  -- Private constant declarations
  C_FO_LOGIN  constant char := 'I';
  C_FO_LOGOUT constant char := 'O';
  C_FO_LOG    constant char := 'L';

  C_FO_USER_DOES_NOT_EXISTED   constant number := -107;
  C_FO_NO_CONTRACT_IN_LIST     constant number := -108;
  C_FO_CUSTOMER_STATUS_INVALID constant number := -109;

  -- Private variable declarations
  pkgctx plog.log_ctx;
  logrow tlogdebug%rowtype;



  procedure sp_focore_login(USERNAME     varchar2,
                            PASSWORD     varchar2,
                            SenderCompID varchar2) as
    l_username  varchar2(5);
    l_status    char(1);
    l_err_code  varchar2(10);
    l_err_param varchar2(10);
  begin
    plog.setBeginSection(pkgctx, 'sp_login_via');

    l_err_code  := systemnums.C_SUCCESS;
    l_err_param := 'SUCCESS';

    sp_audit_authenticate(USERNAME,
                          C_FO_LOGIN,
                          SenderCompID, 'Login successful');

    plog.setEndSection(pkgctx, 'sp_login_via');
  exception
    when errnums.E_BIZ_RULE_INVALID then
      for i in (select errdesc, en_errdesc
                  from deferror
                 where errnum = l_err_code)
      loop
        l_err_param := i.errdesc;

        sp_audit_authenticate(USERNAME, C_FO_LOG, '', l_err_param);
      end loop;
      plog.setEndSection(pkgctx, 'sp_login_via');
    when others then
      l_err_code := errnums.C_SYSTEM_ERROR;
      plog.setEndSection(pkgctx, 'sp_login_via');
  end;

  -- Function and procedure implementations
  procedure sp_login(p_username      varchar2,
                     p_password      varchar2,
                     p_customer_id   in out varchar2,
                     p_customer_info in out varchar2,
                     p_err_code      in out varchar2,
                     p_err_param     in out varchar2) as
    l_username varchar2(50);
    l_status   char(1);
  begin

    plog.setBeginSection(pkgctx, 'sp_login');

    p_err_code  := systemnums.C_SUCCESS;
    p_err_param := 'SUCCESS';

    begin
      select u.username,
             c.custid,
             c.fullname || ' - Addr. : ' || c.address || ' - ID: ' ||
             c.idcode,
             c.status
        into l_username, p_customer_id, p_customer_info, l_status
        from userlogin u, cfmast c
       where u.username = c.username
         and upper(u.username) = upper(p_username)
         and u.loginpwd = genencryptpassword(p_password);

      if nvl(l_status, 'X') <> 'A' then
        p_err_code := C_FO_CUSTOMER_STATUS_INVALID;
        raise errnums.E_BIZ_RULE_INVALID;
      end if;

    exception
      when NO_DATA_FOUND then
        p_err_code := C_FO_USER_DOES_NOT_EXISTED;
        raise errnums.E_BIZ_RULE_INVALID;
    end;

    sp_audit_authenticate(p_username, C_FO_LOGIN, '', 'Login successful');
    plog.setEndSection(pkgctx, 'sp_login');
  exception
    when errnums.E_BIZ_RULE_INVALID then
      for i in (select errdesc, en_errdesc
                  from deferror
                 where errnum = p_err_code)
      loop
        p_err_param := i.errdesc;

        sp_audit_authenticate(p_username, C_FO_LOG, '', p_err_param);
      end loop;
      plog.setEndSection(pkgctx, 'sp_login');
    when others then
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.setEndSection(pkgctx, 'sp_login');
  end;

  -- Logout function
  function fn_logout(p_username  varchar2,
                     p_err_code  in out varchar2,
                     p_err_param out varchar2) return number as
  begin
    -- TO DO
    return systemnums.C_SUCCESS;
  exception
    when others then
      return errnums.C_SYSTEM_ERROR;
  end;

  -- Check trading password when user place order, transfer...
  function fn_check_password_trading(p_username  varchar2,
                                     p_tpassword varchar2,
                                     p_err_code  in out varchar2,
                                     p_err_param out varchar2) return number as
  begin
    -- TO DO
    return systemnums.C_SUCCESS;
  exception
    when others then
      return errnums.C_SYSTEM_ERROR;
  end;

  -- Get all member of customer
  function fn_get_members(p_customer_id varchar2,
                          p_err_code    in out varchar2,
                          p_err_param   out varchar2) return number as
  begin
    -- TO DO
    return systemnums.C_SUCCESS;
  exception
    when others then
      return errnums.C_SYSTEM_ERROR;
  end;

  -- Get all member of customer
  function fn_is_ho_active return boolean as
    l_status char(1);
  begin
    -- TO DO
    l_status := cspks_system.fn_get_sysvar('SYSTEM', 'HOSTATUS');

    if nvl(l_status, '0') = '0' then
      return false;
    end if;

    return true;
  exception
    when others then
      return false;
  end;

  -- Audit log
  procedure sp_audit_log(p_key varchar2, p_text varchar2) as
  begin
    plog.setbeginsection(pkgctx, 'sp_audit_log');
    --Ghi log xu ly
    insert into fo_audit_logs
      (action_date, username, action_desc)
    values
      (sysdate, p_key, p_text);

    plog.debug(pkgctx, p_text);
    plog.setendsection(pkgctx, 'sp_audit_log');
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'sp_audit_log');
  end;

  -- Audit login/ logout
  procedure sp_audit_authenticate(p_key  varchar2,
                                  p_type char,
                                  p_channel varchar2,
                                  p_text varchar2) as
    l_text varchar2(200);
  begin
    plog.setbeginsection(pkgctx, 'sp_audit_authenticate');

    plog.debug(pkgctx, l_text);

    l_text := p_key || ' - ' || p_text;
    --Ghi log xu ly
    insert into fo_audit_logs
      (action_date, username, channel, action_type, action_desc)
    values
      (sysdate, p_key, p_channel, p_type, l_text);

    plog.setendsection(pkgctx, 'sp_audit_authenticate');
    commit;
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'sp_audit_authenticate');
  end;

--Bat dau Ham xu ly dat lenh vao FOMAST--
procedure pr_PlaceOrder(p_functionname in varchar2,
                        p_username in varchar2,
                        p_acctno in varchar2,
                        p_afacctno in varchar2,
                        p_exectype in varchar2,
                        p_symbol in varchar2,
                        p_quantity in number,
                        p_quoteprice in number,
                        p_pricetype in varchar2,
                        p_timetype in varchar2,
                        p_book in varchar2,
                        p_via in varchar2,
                        p_dealid in varchar2,
                        p_direct in varchar2,
                        p_effdate in varchar2,
                        p_expdate in varchar2,
                        p_tlid  IN  VARCHAR2,
                        p_quoteqtty in number,
                        p_limitprice in number,
                        p_err_code out varchar2,
                        p_err_message out VARCHAR2,
                        p_ISDISPOSAL  IN  VARCHAR2 DEFAULT 'N',
                        p_ipaddress in  varchar2 default '' , --1.5.3.0
                        p_validationtype in varchar2 default '',
                        p_devicetype IN varchar2 default '',
                        p_device  IN varchar2 default '',
                        p_isdraft IN varchar2 default '',
                        p_draftid IN varchar2 default '',
                        p_issaved IN varchar2 default ''
                        )
  is
    v_strACCTNO varchar2(50);
    v_strAFACCTNO  varchar2(10);
    v_strACTYPE  varchar2(4);
    v_strCLEARCD  varchar2(10);
    v_strMATCHTYPE  varchar2(10);
    v_dblQUANTITY  number(20,0);
    v_dblPRICE  number(20,4);
    v_dblQUOTEPRICE  number(20,4);
    v_dblTRIGGERPRICE  number(20,4);
    v_dblCLEARDAY  number(20,0);
    v_strDIRECT  varchar2(10);
    v_strSPLITOPTION  varchar2(10);
    v_dblSPLITVALUE  number(20,0);
    v_strBOOK  varchar2(10);
    v_strVIA  varchar2(10);
    v_strEXECTYPE  varchar2(10);
    v_strPRICETYPE  varchar2(10);
    v_strTIMETYPE  varchar2(10);
    v_strNORK varchar2(10);
    v_strSYMBOL varchar2(50);
    v_strCODEID varchar2(20);
    v_sectype   varchar2(3);
    v_strODACTYPE  varchar2(4);
    v_strDEALID varchar2(100);
    v_strtradeplace varchar2(10);
    v_strATCStartTime varchar2(20);
    v_strMarketStatus varchar2(10);
    v_strFEEDBACKMSG varchar2(500);
    v_strUSERNAME varchar2(200);
    v_blnOK boolean;
    v_strSystemTime varchar2(20);
    v_count number(20,0);
    v_strORDERID varchar2(50);
    v_strBUSDATE varchar2(20);
    v_strSPLITVALUE number(20,0);
    v_strFOStatus char(1);
    v_strExpdate varchar2(20);
    v_strEffdate varchar2(20);
    v_strSTATUS char(1);
    v_strOrderStatus char(2);
    v_strTLID   varchar2(4);
    v_strISDISPOSAL varchar2(1);
    v_dblLIMITPRICE  number(20,4);
    v_dblQUOTEQTTY number(20,0);

    v_hnxmaxqtty number(20,0);
    v_orderqtty   number(20,0);

    v_corebank    varchar2(10);
    v_status       varchar2(10);
  v_temp         varchar2(50);
  begin
    plog.setbeginsection(pkgctx, 'pr_placeorder');
    p_err_code := systemnums.C_SUCCESS;

    -- Check host & branch active or inactive
    p_err_code := fn_CheckActiveSystem;
    IF p_err_code <> systemnums.C_SUCCESS THEN
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        pr_update_draft_order(p_isdraft,p_draftid,p_issaved,p_err_code,p_err_message);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_placeorder');
        return;
    END IF;
    -- End: Check host & branch active or inactive

    v_strDIRECT:=nvl(p_direct,'N');
    v_strSPLITOPTION:='N';
    v_dblSPLITVALUE:=0;
    v_strAFACCTNO:=p_afacctno;
    v_strISDISPOSAL:= nvl(p_ISDISPOSAL,'N');
    --plog.debug(pkgctx, 'p_book:' || p_book);
    v_strBOOK:=nvl(p_book,'A');
    --plog.debug(pkgctx, 'v_strVIA:' || v_strVIA);
    v_strVIA:=nvl(p_via,'F');
    v_strEXECTYPE:=p_exectype;
    v_strPRICETYPE:=p_pricetype;
    v_strTIMETYPE:= p_timetype;
    v_strMATCHTYPE:='N';
    v_strCLEARCD:='B';
    v_strNORK:='N';
    v_strSYMBOL:= p_symbol;
    v_strCODEID:='';
    --v_dblCLEARDAY:=3;
    v_dblQUANTITY:=p_quantity;
    v_dblQUOTEPRICE:=p_quoteprice;
    v_dblPRICE:=p_quoteprice;
    v_strDEALID:=nvl(p_dealid,'');
    v_strACCTNO:=p_acctno;
    v_strExpdate:=p_expdate;
    v_strEffdate:=p_effdate;
    v_strBUSDATE:=cspks_system.fn_get_sysvar('SYSTEM','CURRDATE');
    v_strSTATUS:='P';
    if v_strTIMETYPE ='T' then
        v_strExpdate:=v_strBUSDATE;
        v_strEffdate:=v_strBUSDATE;
    end if;
    IF p_Username IS NULL THEN
        SELECT CUSTID INTO v_strUSERNAME FROM AFMAST WHERE ACCTNO = p_afacctno;
    ELSE
        v_strUSERNAME:=p_Username;
    END IF;
    plog.debug(pkgctx, 'TLID: ' || p_tlid);
    IF p_tlid IS NULL OR p_via = 'O' THEN
        v_strTLID := systemnums.C_ONLINE_USERID;
    ELSE
        v_strTLID := p_tlid;
    END IF;
    v_dblQUOTEQTTY  :=p_quoteqtty;
    v_dblLIMITPRICE := p_limitprice;

    --Lay ra codeid theo symbol
    begin
        --plog.debug(pkgctx, 'Xac dinh ma CK');
        if p_functionname in ('CANCELORDER','AMENDMENTORDER','CANCELGTCORDER') then
            select codeid, tradeplace, sectype, symbol
            into v_strcodeid, v_strtradeplace, v_sectype, v_strSYMBOL
            from (
                (select sb.codeid, sb.tradeplace, sb.sectype, sb.symbol
                from odmast od, sbsecurities sb
                where od.codeid = sb.codeid and OD.orderid = p_acctno)
                 union all
                (select sb.codeid, sb.tradeplace, sb.sectype, sb.symbol
                from fomast od, sbsecurities sb
                where od.codeid = sb.codeid and OD.acctno = p_acctno)
            );
        else
            select SB.CODEID, SB.tradeplace, SB.sectype
            into v_strcodeid, v_strtradeplace, v_sectype
            from sbsecurities SB
            where SB.symbol =v_strsymbol;
        end if;
        --plog.debug(pkgctx, 'v_strcodeid:' || v_strcodeid);
    exception when others then
        p_err_code:=errnums.C_OD_SECURITIES_INFO_UNDEFINED;
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        pr_update_draft_order(p_isdraft,p_draftid,p_issaved,p_err_code,p_err_message);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_placeorder');
        return;
    end;

  --T2_HoangND lay lai CK thanh toan theo he thong
    BEGIN
    IF v_sectype = '012' AND v_strtradeplace = '002' THEN   --1.5.6.0
      select TO_NUMBER(VARVALUE) into v_dblCLEARDAY from sysvar where grname like 'OD' and varname='CLEARDAY_TPDN_HNX' and rownum<=1;
    ELSE
      select TO_NUMBER(VARVALUE) into v_dblCLEARDAY from sysvar where grname like 'OD' and varname='CLEARDAY' and rownum<=1;
    END IF;
    EXCEPTION WHEN OTHERS THEN
        v_dblCLEARDAY:=2;
    END;

    --- Chan huy/sua phien 3 theo thong tu 203
    If p_functionname in ('CANCELORDER','AMENDMENTORDER','CANCELGTCORDER')
     and fn_get_controlcode(v_strSYMBOL) in ('A','CLOSE','CLOSE_BL') then
           p_err_code:=-100113;--ERR_SA_INVALID_SECSSION
           p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
           plog.setendsection(pkgctx, 'pr_placeorder');
         return;
    end if;
    --------

    --HNX_update|MSBS-1774
    --HNX_update: Chan huy lenh PLO da duoc gui len So
    If p_functionname in ('CANCELORDER','BLBCANCELORDER') THEN
        SELECT COUNT(*) INTO v_status FROM ood , ODMAST OD
              WHERE OOD.orgorderid =p_acctno AND OOD.ORGORDERID=OD.ORDERID
                    AND OD.PRICETYPE='PLO' AND OOD.OODSTATUS IN ('B','S') ;
        IF v_status > 0 THEN
            p_err_code:=-700100;--C_OD_ORDER_SENDING
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.setendsection(pkgctx, 'pr_placeorder');
            return;
         END IF;
    ELSIF p_functionname IN ( 'AMENDMENTORDER','BLBAMENDMENTORDER') THEN
        SELECT pricetype
        INTO v_strPricetype
        FROM odmast
        WHERE orderid=p_acctno;
        -- chan lenh PLO khong duoc sua
        IF v_strPricetype='PLO' THEN
          p_err_code:=-700100;--C_OD_ORDER_SENDING
          p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
          plog.setendsection(pkgctx, 'pr_placeorder');
          return;
        END IF;
    END IF;
    --End HNX_update|MSBS-1774

  --check chung quyen dao han
     If p_functionname ='PLACEORDER' THEN
        if fn_check_cwsecurities(v_strsymbol) <> 0 then
            p_err_code:=-100128;
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            pr_update_draft_order(p_isdraft,p_draftid,p_issaved,p_err_code,p_err_message);
            plog.error(pkgctx, 'Error pr_placeorder.p_functionname:= '  || p_functionname
                            || ', v_strACCTNO:' || v_strACCTNO
                            || ', v_strsymbol:' || v_strsymbol
                            );
            plog.setendsection(pkgctx, 'pr_placeorder');
            return;
        end if;
     end if;

     If p_functionname in ('AMENDMENTORDER') THEN
        --chan tai khoan corebank
     Begin
     select status INTO v_status from FOMAST WHERE  ORGACCTNO=v_strACCTNO;
     EXCEPTION
      WHEN OTHERS THEN
        v_status:='A';
     end;
     select corebank into v_corebank from afmast where acctno =v_strAFACCTNO;
     if v_corebank='Y' and v_status='W' then
           p_err_code:=-900006;--ERR_SA_INVALID_SECSSION
           p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
           plog.setendsection(pkgctx, 'pr_placeorder');
         return;
     end if;
       --chan ko cho sua khoi luong vuot qua khoi luong xe lenh--case loi Jira msbs1069
          v_hnxmaxqtty:=cspks_system.fn_get_sysvar ('BROKERDESK', 'HNX_MAX_QUANTITY');
         Begin
         select orderqtty into v_orderqtty from odmast where orderid=v_strACCTNO;
         EXCEPTION
          WHEN OTHERS THEN
            v_orderqtty:=0;
         end;
       IF   v_dblQUANTITY > v_orderqtty  and v_dblQUANTITY> v_hnxmaxqtty THEN
           p_err_code:=-900005;--ERR_SA_INVALID_SECSSION
           p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
           plog.setendsection(pkgctx, 'pr_placeorder');
         return;
         END IF;
     end if;
    --------
    v_strATCStartTime:=cspks_system.fn_get_sysvar('SYSTEM','ATCSTARTTIME');
    select sysvalue into v_strMarketStatus  from ordersys where sysname='CONTROLCODE';
    SELECT TO_CHAR(SYSDATE,'HH24MISS') into v_strSystemTime FROM DUAL;
    --v_strMarketStatus=P: 8h30-->9h00 phien 1 ATO
    --v_strMarketStatus=O: 9h00-->10h15 phien 2 MP
    --v_strMarketStatus=A: 10h15-->10h30 phien 3 ATC
     If p_functionname ='PLACEORDER' AND v_strPRICETYPE NOT IN('LO','ATC','ATO','MAK','MOK','MP','MTL','PLO') THEN    --HNX_update|MSBS-1774
            p_err_code:=-100113;--ERR_SA_INVALID_SECSSION
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            pr_update_draft_order(p_isdraft,p_draftid,p_issaved,p_err_code,p_err_message);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_placeorder');
            return;
    END IF;
    If v_strPRICETYPE <> 'LO' And p_functionname ='PLACEORDER' And v_strBOOK = 'A' and v_strTIMETYPE='T' Then
      If v_strPRICETYPE = 'ATO' Then
          If v_strMarketStatus = 'O' Or v_strMarketStatus = 'A' Then
            p_err_code:=-100113;--ERR_SA_INVALID_SECSSION
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            pr_update_draft_order(p_isdraft,p_draftid,p_issaved,p_err_code,p_err_message);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_placeorder');
            return;
          End If;
      End If;
      /*If v_strPRICETYPE = 'ATC' Then
          If v_strMarketStatus = 'A' Then
            v_strPRICETYPE := 'ATC'; --Do nothing
          ElsIf v_strMarketStatus = 'O' And v_strSystemTime >= v_strATCStartTime Then
            v_strPRICETYPE := 'ATC'; --Do nothing
          Else
            p_err_code:=-100113;--ERR_SA_INVALID_SECSSION
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_placeorder');
            return;
          End If;
      End If;*/

      If v_strPRICETYPE = 'MO' Then
          If v_strMarketStatus <> 'O' Then
            p_err_code:=-100113;--ERR_SA_INVALID_SECSSION
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            pr_update_draft_order(p_isdraft,p_draftid,p_issaved,p_err_code,p_err_message);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_placeorder');
            RETURN;
          End If;
      End If;
    End If;
    If p_functionname in ('CANCELORDER','AMENDMENTORDER') And v_strTradePlace = '001' Then
        --plog.debug(pkgctx, 'Kiem tra phien giao dich :' || v_strMarketStatus);
        -- Kiem tra neu lenh da day vao ODMAST ma chua day len san thi ko check trang thai phien GD
        SELECT orstatus, PRICETYPE INTO v_strOrderStatus, v_strPRICETYPE FROM odmast od WHERE od.orderid = v_strACCTNO;
        plog.debug(pkgctx, 'v_strOrderStatus :' || v_strOrderStatus);
        IF trim(v_strOrderStatus) NOT IN ('8','11','5','9') THEN
            If v_strMarketStatus = 'P' Then
                p_err_code:=-100113;--ERR_SA_INVALID_SECSSION
                p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
                plog.error(pkgctx, 'Error:'  || p_err_message);
                plog.setendsection(pkgctx, 'pr_placeorder');
                RETURN;
            End If;
            If v_strMarketStatus = 'A' Then
                SELECT count(orderid) into v_count FROM odmast WHERE orderid = v_strACCTNO AND hosesession = 'A';
                 If v_count > 0 Then
                     p_err_code:=-100113;--ERR_SA_INVALID_SECSSION
                     p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
                     plog.error(pkgctx, 'Error:'  || p_err_message);
                     plog.setendsection(pkgctx, 'pr_placeorder');
                     RETURN;
                 End If;
                 -- Neu lenh ATC da day len san thi ko cho phep huy
                 IF v_strPRICETYPE = 'ATC' THEN
                     p_err_code:=-100113;--ERR_SA_INVALID_SECSSION
                     p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
                     plog.error(pkgctx, 'Error:'  || p_err_message);
                     plog.setendsection(pkgctx, 'pr_placeorder');
                     RETURN;
                 END IF;
            End If;


        END IF;
    End If;

    If p_functionname = 'PLACEORDER' Then
      select actype, (case when corebank='Y' AND p_exectype IN ('NB')  then 'W' else 'P' end) into v_strACTYPE, v_strSTATUS from afmast where acctno = v_strafacctno;
      -- Lay gia tri loai hinh lenh
      v_strODACTYPE := fopks_api.fn_GetODACTYPE(v_strAFACCTNO, p_symbol, v_strCODEID, v_strtradeplace, p_exectype,
                                    p_pricetype, p_timetype, v_strACTYPE, v_sectype, v_strVIA);
      select v_strBUSDATE || lpad(seq_fomast.nextval,10,'0') into v_strORDERID from dual;
      v_strFEEDBACKMSG := 'MSG_CONFIRMED_ORDER_RECEIVED';

      -- Kiem tra mua ban cung ngay
/*      IF v_strTIMETYPE<>'G' and fnc_check_buy_sell(v_strAFACCTNO,TO_DATE(v_strBUSDATE,'DD/MM/YYYY'), v_strCODEID, v_strEXECTYPE, v_strPRICETYPE, v_strMATCHTYPE, v_strtradeplace) = false THEN
            p_err_code:=-700016;--Ko duoc mua ban CK cung ngay
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_placeorder');
            RETURN;
      END IF;
*/
    --HNX_update|MSBS-1774
      IF v_strPRICETYPE IN ('PLO') THEN
        v_dblPRICE := FNC_GET_PRICE_PLO(v_strSYMBOL, v_strEXECTYPE);
        v_dblQUOTEPRICE := FNC_GET_PRICE_PLO(v_strSYMBOL, v_strEXECTYPE);
      END IF;

    --End HNX_update|MSBS-1774
      INSERT INTO FOMAST (ACCTNO, ORGACCTNO, ACTYPE, AFACCTNO, STATUS, EXECTYPE, PRICETYPE, TIMETYPE, MATCHTYPE, NORK, CLEARCD, CODEID, SYMBOL,
          CONFIRMEDVIA, BOOK, FEEDBACKMSG, ACTIVATEDT, CREATEDDT, CLEARDAY, QUANTITY, PRICE, QUOTEPRICE, TRIGGERPRICE, EXECQTTY, EXECAMT, REMAINQTTY,
          VIA, DIRECT, SPLOPT, SPLVAL, EFFDATE, EXPDATE, USERNAME, DFACCTNO,SSAFACCTNO, TLID, QUOTEQTTY, LIMITPRICE,ISDISPOSAL)
          VALUES (v_strORDERID,v_strORDERID,v_strODACTYPE,v_strAFACCTNO,v_strSTATUS,
          v_strEXECTYPE,v_strPRICETYPE,v_strTIMETYPE,v_strMATCHTYPE,
          v_strNORK,v_strCLEARCD,v_strCODEID,v_strSYMBOL,
          'N',v_strBOOK,v_strFEEDBACKMSG,TO_CHAR(SYSDATE,'DD/MM/RRRR HH24:MI:SS'),TO_CHAR(SYSDATE,'DD/MM/RRRR HH24:MI:SS'),
          v_dblCLEARDAY ,v_dblQUANTITY ,v_dblPRICE ,v_dblQUOTEPRICE ,v_dblTRIGGERPRICE ,0 ,0 ,v_dblQUANTITY ,
          v_strVIA,v_strDIRECT,v_strSPLITOPTION,v_strSPLITVALUE , TO_DATE(v_streffdate,'DD/MM/RRRR'),TO_DATE(v_strexpdate,'DD/MM/RRRR'),v_strUSERNAME,v_strDEALID,'', v_strTLID,v_dblQUOTEQTTY, v_dblLIMITPRICE,v_strISDISPOSAL);
      p_err_code := systemnums.C_SUCCESS;
      --Day lenh vao ODMAST luon neu la lenh Direct
      If v_strDIRECT='Y' and v_strBOOK='A' and v_strTIMETYPE ='T' and v_strSTATUS='P' Then
          --Goi thu tuc day ca lenh vao ODMAST
          TXPKS_AUTO.pr_fo2odsyn(v_strORDERID,p_err_code,v_strTIMETYPE);

          -- Neu lenh thieu suc mua thi dong bo lai ci
          IF nvl(p_err_code,'0') = '-400116' THEN
                fopks_api.pr_trg_account_log(v_strAFACCTNO, 'CI');
          END IF;

          If nvl(p_err_code,'0') <> '0' Then
              --Xoa luon lenh o FOMAST neu o mode direct
              UPDATE FOMAST SET DELTD='Y' WHERE ACCTNO=v_strORDERID;
              p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
              pr_update_draft_order(p_isdraft,p_draftid,p_issaved,p_err_code,p_err_message);
              plog.error(pkgctx, 'Error:'  || p_err_message);
              plog.setendsection(pkgctx, 'pr_placeorder');
              Return;
          End If;
      End If;
    --1.8.2.4 : EDit Xu ly lenh nhom
      if trim(p_isdraft) = 'Y' then
         select count(*) into v_count
         from rootordermap
         where foacctno = v_strORDERID;

         SELECT VARVALUE ||' '|| to_char (sysdate, 'hh:mi:ss') into v_strSystemTime
         FROM SYSVAR WHERE GRNAME = 'SYSTEM' AND VARNAME ='CURRDATE';

         if v_count > 0 then
             select orderid into v_temp
             from rootordermap
             where foacctno = v_strORDERID;

             update draft_order set status = 'C', bo_orderid = v_temp, fo_acctno = v_strORDERID,
                                     errcode = '0', errmsg = 'Giao dich thanh cong',
                                     lastordertime = v_strSystemTime, ACTCOUNT = ACTCOUNT + 1
             where autoid = trim(p_draftid);

            insert into draft_order_active(autoid, draft_id,txdate,boorderid,foacctno)
            values (SEQ_DRAFT_ORDER_ACTIVE.nextval,to_number(trim(p_draftid)),getcurrdate, v_temp,v_strORDERID );

         else
             update draft_order set status = 'C', fo_acctno = v_strORDERID,
                                 errcode = '0', errmsg = 'Giao dich thanh cong',
                                 lastordertime = v_strSystemTime, ACTCOUNT = ACTCOUNT + 1
             where autoid = to_number(trim(p_draftid));


             insert into draft_order_active(autoid, draft_id,txdate,foacctno)
            values (SEQ_DRAFT_ORDER_ACTIVE.nextval,to_number(trim(p_draftid)),getcurrdate, v_strORDERID );


         end if;

     end if;
  ElsIf p_functionname = 'ACTIVATEORDER' Then
      UPDATE FOMAST SET BOOK='A',ACTIVATEDT=TO_CHAR(SYSDATE,'DD/MM/RRRR HH24:MI:SS') WHERE BOOK='I' AND ACCTNO=v_strACCTNO;
      v_strFEEDBACKMSG := 'MSG_CONFIRMED_ORDER_ACTIVATED';
      p_err_code := systemnums.C_SUCCESS;
      --Day lenh vao ODMAST luon
      If v_strDIRECT='Y' and v_strSTATUS='P' Then
          --Goi thu tuc day ca lenh vao ODMAST
          TXPKS_AUTO.pr_fo2odsyn(v_strORDERID,p_err_code);
          If nvl(p_err_code,'0') <> '0' Then
              --Cap nhat trang thai tu choi
              UPDATE FOMAST SET STATUS='R' WHERE ACCTNO=v_strACCTNO;
              p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
              plog.error(pkgctx, 'Error:'  || p_err_message);
              plog.setendsection(pkgctx, 'pr_placeorder');
              Return;
          End If;
      End If;
  ElsIf p_functionname = 'CANCELGTCORDER' Then
      begin
            SELECT status into v_strFOStatus FROM fomast WHERE orgacctno = v_strACCTNO and TIMETYPE='G' and deltd <> 'Y';
            if v_strFOStatus='P' or v_strFOStatus='R'  or v_strFOStatus='W' THEN
                SELECT CDCONTENT
                INTO v_strFEEDBACKMSG
                FROM ALLCODE WHERE CDTYPE = 'OD' AND CDNAME = 'ORSTATUS' AND CDVAL = 'R';
                update fomast set
                    --deltd='Y',
                    CANCELQTTY = REMAINQTTY,
                    REMAINQTTY = 0,
                    STATUS = 'R',
                    FEEDBACKMSG = v_strFEEDBACKMSG
                where orgacctno = v_strACCTNO;
                p_err_code := systemnums.C_SUCCESS;
            ELSIF v_strFOStatus = 'A' THEN
                If v_strBOOK = 'A' Then
                  --Kiem tra da ton tai lenh huy hay chua - return message loi.
                  SELECT count(1) into v_count FROM fomast WHERE refacctno = v_strACCTNO AND substr(exectype,1,1) = 'C' and status <> 'R';
                  If v_count = 0 Then
                      -- Lenh da thuc hien huy tren OD?
                      SELECT count(1) into v_count FROM odmast WHERE reforderid = v_strACCTNO  AND substr(exectype,1,1) = 'C' AND ORSTATUS<>'6';
                      If v_count = 0 Then
                          -- Kiem tra xem con khoi luong chua khop hay khong.
                          SELECT count(1) into v_count FROM odmast WHERE orderid = v_strACCTNO  AND remainqtty > 0;
                          If v_count=0 Then
                              p_err_code:=-800002;--gc_ERRCODE_FO_INVALID_STATUS
                              p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
                              plog.error(pkgctx, 'Error:'  || p_err_message);
                              plog.setendsection(pkgctx, 'pr_placeorder');
                              return;
                          End If;
                      Else
                          p_err_code:=-800002;--gc_ERRCODE_FO_INVALID_STATUS
                          p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
                          plog.error(pkgctx, 'Error:'  || p_err_message);
                          plog.setendsection(pkgctx, 'pr_placeorder');
                          return;
                      End If;
                  Else
                      p_err_code:=-800002;--gc_ERRCODE_FO_INVALID_STATUS
                      p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
                      plog.error(pkgctx, 'Error:'  || p_err_message);
                      plog.setendsection(pkgctx, 'pr_placeorder');
                      return;
                  End If;

                      --Generate OrderID
                      select v_strBUSDATE || lpad(seq_fomast.nextval,10,'0') into v_strORDERID from dual;
                      v_strFEEDBACKMSG := 'MSG_CANCEL_ORDER_IS_RECEIVED';
                        -- SInh lenh huy
                      INSERT INTO FOMAST (ACCTNO, ORGACCTNO, ACTYPE, AFACCTNO, STATUS, EXECTYPE, PRICETYPE, TIMETYPE, MATCHTYPE, NORK, CLEARCD, CODEID, SYMBOL,
                          CONFIRMEDVIA, DIRECT, BOOK, FEEDBACKMSG, ACTIVATEDT, CREATEDDT, CLEARDAY, QUANTITY, PRICE, QUOTEPRICE, TRIGGERPRICE, EXECQTTY, EXECAMT, REMAINQTTY,
                          REFACCTNO, REFQUANTITY, REFPRICE, REFQUOTEPRICE,VIA,EFFDATE,EXPDATE,USERNAME, TLID,QUOTEQTTY, LIMITPRICE)
                      SELECT v_strORDERID,od.orderid ORGACCTNO, od.ACTYPE, od.AFACCTNO, 'P',
                         (CASE WHEN od.EXECTYPE='NB' OR od.EXECTYPE='CB' OR od.EXECTYPE='AB' THEN 'CB' ELSE 'CS' END) CANCEL_EXECTYPE,
                         od.PRICETYPE, od.TIMETYPE, od.MATCHTYPE, od.NORK, od.CLEARCD, od.CODEID, sb.SYMBOL,
                         'O' CONFIRMEDVIA,v_strDIRECT ,'A' BOOK, v_strFEEDBACKMSG ,
                         TO_CHAR(SYSDATE,'DD/MM/RRRR HH24:MI:SS'), TO_CHAR(SYSDATE,'DD/MM/RRRR HH24:MI:SS'),
                         od.CLEARDAY,od.exqtty QUANTITY,(od.exprice/1000) PRICE, (od.QUOTEPRICE/1000) QUOTEPRICE, 0 TRIGGERPRICE, od.EXECQTTY, od.EXECAMT,
                         od.REMAINQTTY, od.orderid REFACCTNO, 0 REFQUANTITY, 0 REFPRICE, (od.QUOTEPRICE/1000) REFQUOTEPRICE,
                         v_strVIA VIA,OD.TXDATE EFFDATE,OD.EXPDATE EXPDATE,
                         v_strUSERNAME USERNAME, v_strTLID TLID,v_dblQUOTEQTTY , v_dblLIMITPRICE
                         FROM ODMAST od, sbsecurities sb
                         WHERE orstatus IN ('1','2','4','8') AND orderid=v_strACCTNO and sb.codeid = od.codeid
                            and orderid not in (select REFACCTNO
                                                    from fomast
                                                    WHERE EXECTYPE IN ('CB','CS') AND STATUS <>'R'
                                               );
                      p_err_code := systemnums.C_SUCCESS;

              Else
                  DELETE FROM FOMAST WHERE BOOK='I' AND ORGACCTNO=v_strACCTNO;
                  v_strFEEDBACKMSG := 'MSG_CONFIRMED_ORDER_CANCALLED';
              End If;
            ELSE

             p_err_code:=errnums.c_od_order_sending;
             p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
             plog.error(pkgctx, 'Error:'  || p_err_message);
             plog.setendsection(pkgctx, 'pr_placeorder');
             return;
          end if;
      exception when others then
        p_err_code:=errnums.c_od_order_not_found;
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_placeorder');
        return;
      end;
  ElsIf p_functionname = 'CANCELORDER' Then
      If v_strBOOK = 'A' Then
          --Kiem tra da ton tai lenh huy hay chua - return message loi.
          SELECT count(1) into v_count FROM fomast WHERE refacctno = v_strACCTNO AND substr(exectype,1,1) = 'C' and status <> 'R';
          If v_count = 0 Then
              -- Lenh da thuc hien huy tren OD?
              SELECT count(1) into v_count FROM odmast WHERE reforderid = v_strACCTNO  AND substr(exectype,1,1) = 'C' AND ORSTATUS<>'6';
              If v_count = 0 Then
                  -- Kiem tra xem con khoi luong chua khop hay khong.
                  SELECT count(1) into v_count FROM odmast WHERE orderid = v_strACCTNO  AND remainqtty > 0;
                  If v_count=0 Then
                      p_err_code:=-800002;--gc_ERRCODE_FO_INVALID_STATUS
                      p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
                      plog.error(pkgctx, 'Error:'  || p_err_message);
                      plog.setendsection(pkgctx, 'pr_placeorder');
                      return;
                  End If;
              Else
                  p_err_code:=-800002;--gc_ERRCODE_FO_INVALID_STATUS
                  p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
                  plog.error(pkgctx, 'Error:'  || p_err_message);
                  plog.setendsection(pkgctx, 'pr_placeorder');
                  return;
              End If;
          Else
              p_err_code:=-800002;--gc_ERRCODE_FO_INVALID_STATUS
              p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
              plog.error(pkgctx, 'Error:'  || p_err_message);
              plog.setendsection(pkgctx, 'pr_placeorder');
              return;
          End If;

          --Kiem tra trang thai cua lenh
          SELECT count(STATUS) into v_count FROM FOMAST WHERE ORGACCTNO=v_strACCTNO  AND EXECTYPE IN ('NB','NS');
          If v_count > 0 Then
              --Lenh chua duoc huy lan nao
              --Kiem tra trang thai cua lenh, Neu la P thi xoa luon
              SELECT max(STATUS) into v_strFOStatus FROM FOMAST WHERE ORGACCTNO=v_strACCTNO  AND EXECTYPE IN ('NB','NS');
              If v_strFOStatus = 'P' Then
                  v_strFEEDBACKMSG := 'Order is cancelled when processing';
                  UPDATE FOMAST SET STATUS='R',FEEDBACKMSG=v_strFEEDBACKMSG  WHERE BOOK='A' AND ACCTNO=v_strACCTNO AND STATUS='P';
              ElsIf v_strFOStatus = 'A' Then
                  --Neu la A tuc la lenh da day vao he thong thi sinh lenh huy
                  v_blnOK := True;
              Else
                  v_strFEEDBACKMSG := 'MSG_REJECT_CANCEL_ORDER';
              End If;
          Else
              --LENH o trong he thong
              v_blnOK := True;
          End If;

          If v_blnOK Then
              --Generate OrderID
              select v_strBUSDATE || lpad(seq_fomast.nextval,10,'0') into v_strORDERID from dual;
              v_strFEEDBACKMSG := 'MSG_CANCEL_ORDER_IS_RECEIVED';
              -- Lay thong tin timetype
              SELECT od.timetype INTO v_strTIMETYPE FROM odmast od where od.orderid=v_strACCTNO;

              INSERT INTO FOMAST (ACCTNO, ORGACCTNO, ACTYPE, AFACCTNO, STATUS, EXECTYPE, PRICETYPE, TIMETYPE, MATCHTYPE, NORK, CLEARCD, CODEID, SYMBOL,
                  CONFIRMEDVIA, DIRECT, BOOK, FEEDBACKMSG, ACTIVATEDT, CREATEDDT, CLEARDAY, QUANTITY, PRICE, QUOTEPRICE, TRIGGERPRICE, EXECQTTY, EXECAMT, REMAINQTTY,
                  REFACCTNO, REFQUANTITY, REFPRICE, REFQUOTEPRICE,VIA,EFFDATE,EXPDATE,USERNAME, TLID,QUOTEQTTY, LIMITPRICE)
              SELECT v_strORDERID,od.orderid ORGACCTNO, od.ACTYPE, od.AFACCTNO, 'P',
                 (CASE WHEN od.EXECTYPE='NB' OR od.EXECTYPE='CB' OR od.EXECTYPE='AB' THEN 'CB' ELSE 'CS' END) CANCEL_EXECTYPE,
                 od.PRICETYPE, od.TIMETYPE, od.MATCHTYPE, od.NORK, od.CLEARCD, od.CODEID, sb.SYMBOL,
                 'O' CONFIRMEDVIA,v_strDIRECT ,'A' BOOK, v_strFEEDBACKMSG ,
                 TO_CHAR(SYSDATE,'DD/MM/RRRR HH24:MI:SS'), TO_CHAR(SYSDATE,'DD/MM/RRRR HH24:MI:SS'),
                 od.CLEARDAY,od.exqtty QUANTITY,(od.exprice/1000) PRICE, (od.QUOTEPRICE/1000) QUOTEPRICE, 0 TRIGGERPRICE, od.EXECQTTY, od.EXECAMT,
                 od.REMAINQTTY, od.orderid REFACCTNO, 0 REFQUANTITY, 0 REFPRICE, (od.QUOTEPRICE/1000) REFQUOTEPRICE,
                 v_strVIA VIA,TO_DATE(v_strBUSDATE,'DD/MM/RRRR') EFFDATE,TO_DATE(v_strBUSDATE,'DD/MM/RRRR') EXPDATE,
                 v_strUSERNAME USERNAME, v_strTLID TLID, v_dblQUOTEQTTY , v_dblLIMITPRICE
                 FROM ODMAST od, sbsecurities sb
                 WHERE orstatus IN ('1','2','4','8') AND orderid=v_strACCTNO and sb.codeid = od.codeid
                    and orderid not in (select REFACCTNO
                                            from fomast
                                            WHERE EXECTYPE IN ('CB','CS') AND STATUS <>'R'
                                       );
              p_err_code := systemnums.C_SUCCESS;
              --Day lenh vao ODMAST luon
              If v_strDIRECT='Y' Then
                  --Goi thu tuc day ca lenh vao ODMAST
                  TXPKS_AUTO.pr_fo2odsyn(v_strORDERID,p_err_code,v_strTIMETYPE);
                  If nvl(p_err_code,'0') <> '0' Then
                      --Cap nhat trang thai tu choi
                      UPDATE FOMAST SET DELTD='Y' WHERE ACCTNO=v_strACCTNO;
                      p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
                      plog.error(pkgctx, 'Error:'  || p_err_message);
                      plog.setendsection(pkgctx, 'pr_placeorder');
                      Return;
                  End If;
              End If;
          End If;
      Else
          DELETE FROM FOMAST WHERE BOOK='I' AND ACCTNO=v_strACCTNO;
          v_strFEEDBACKMSG := 'MSG_CONFIRMED_ORDER_CANCALLED';
      End If;

  ElsIf p_functionname = 'AMENDMENTORDER' Then
      plog.debug(pkgctx, 'p_functionname:'  || p_functionname);
      If v_strBOOK = 'A' Then
          --SELECT STATUS FROM FOMAST WHERE ORGACCTNO=v_strACCTNO AND EXECTYPE IN ('NB','NS');
          SELECT count(STATUS) into v_count FROM FOMAST WHERE ORGACCTNO=v_strACCTNO AND EXECTYPE IN ('NB','NS');
          If v_count > 0 Then
              --Lenh chua duoc sua lan nao
              --Kiem tra trang thai cua lenh, Neu la P thi xoa luon
              SELECT max(STATUS) into v_strFOStatus FROM FOMAST WHERE ORGACCTNO=v_strACCTNO AND EXECTYPE IN ('NB','NS');
              If v_strFOStatus = 'P' Then
                  v_strFEEDBACKMSG := 'Order is cancelled when processing';
                  UPDATE FOMAST SET STATUS='R',FEEDBACKMSG=v_strFEEDBACKMSG WHERE BOOK='A' AND ACCTNO=v_strACCTNO AND STATUS='P';
                  v_blnOK := True;
              ElsIf v_strFOStatus = 'A' Then
                  --Neu la A tuc la lenh da day vao he thong thi sinh lenh huy
                  v_blnOK := True;
              Else
                  v_strFEEDBACKMSG := 'MSG_REJECT_CANCEL_ORDER';
              End If;
          Else
              --LENH o trong he thong
              v_blnOK := True;
          End If;

          --Generate OrderID
          select v_strBUSDATE || lpad(seq_fomast.nextval,10,'0') into v_strORDERID from dual;
          v_strFEEDBACKMSG := 'MSG_ADMENT_ORDER_RECEIVED';
          plog.debug(pkgctx, 'Amend Orderid:'  || v_strORDERID);

          select (case when AF.corebank='Y' AND OD.exectype IN ('NB')  then 'W' else 'P' end) status, od.timetype
          into v_strSTATUS, v_strTIMETYPE
          from afmast AF, ODMAST OD
          WHERE OD.AFACCTNO = AF.ACCTNO AND OD.ORDERID = v_strACCTNO;
          plog.debug(pkgctx, 'v_strSTATUS: '  || v_strSTATUS);

          INSERT INTO FOMAST (ACCTNO, ORGACCTNO, ACTYPE, AFACCTNO, STATUS, EXECTYPE, PRICETYPE, TIMETYPE, MATCHTYPE, NORK, CLEARCD, CODEID, SYMBOL,
              CONFIRMEDVIA,DIRECT, BOOK, FEEDBACKMSG, ACTIVATEDT, CREATEDDT, CLEARDAY, QUANTITY, PRICE, QUOTEPRICE, TRIGGERPRICE, EXECQTTY, EXECAMT, REMAINQTTY,
              REFACCTNO, REFQUANTITY, REFPRICE, REFQUOTEPRICE,VIA,EFFDATE,EXPDATE,USERNAME, TLID, Quoteqtty,limitprice)
          SELECT v_strORDERID,od.orderid ORGACCTNO, od.ACTYPE, od.AFACCTNO, v_strSTATUS,
              (CASE WHEN od.EXECTYPE='NB' OR od.EXECTYPE='CB' OR EXECTYPE='AB' THEN 'AB' ELSE 'AS' END) CANCEL_EXECTYPE,
              (CASE When od.PRICETYPE ='MTL' THEN 'LO' ELSE  od.PRICETYPE END)PRICETYPE , od.TIMETYPE, od.MATCHTYPE, od.NORK, od.CLEARCD, od.CODEID, sb.SYMBOL,
              'O' CONFIRMEDVIA, v_strDIRECT,'A' BOOK, v_strFEEDBACKMSG  FEEDBACKMSG,TO_CHAR(SYSDATE,'DD/MM/RRRR HH24:MI:SS') ACTIVATEDT,TO_CHAR(SYSDATE,'DD/MM/RRRR HH24:MI:SS') CREATEDDT, od.CLEARDAY,
               v_dblQUANTITY , v_dblPRICE , v_dblQUOTEPRICE ,0 TRIGGERPRICE, 0 EXECQTTY, 0 EXECAMT,v_dblQUANTITY  REMAINQTTY,
              od.orderid REFACCTNO, ORDERQTTY REFQUANTITY, round(QUOTEPRICE/SIF.TRADEUNIT,2) REFPRICE, round(QUOTEPRICE/SIF.TRADEUNIT,2) REFQUOTEPRICE,
              v_strVIA  VIA ,TO_DATE(v_strBUSDATE,'DD/MM/RRRR') EFFDATE,TO_DATE(v_strBUSDATE,'DD/MM/RRRR') EXPDATE,
              v_strUSERNAME USERNAME, v_strTLID TLID ,  v_dblQUOTEQTTY,v_dblLIMITPRICE
           FROM ODMAST od, sbsecurities sb, securities_info SIF
           WHERE orstatus IN ('1','2','4','8') AND orderid=v_strACCTNO and sb.codeid = od.codeid AND SIF.CODEID = OD.CODEID
              and orderid not in (select REFACCTNO from fomast WHERE EXECTYPE IN ('CB','CS','AB','AS') AND STATUS <>'R' );
          --plog.debug(pkgctx, 'v_strDIRECT:'  || v_strDIRECT);
          p_err_code := systemnums.C_SUCCESS;
          --Day lenh vao ODMAST luon
           If v_strDIRECT='Y' Then

               --Goi thu tuc day ca lenh vao ODMAST
               TXPKS_AUTO.pr_fo2odsyn(v_strORDERID,p_err_code,v_strTIMETYPE);
               If nvl(p_err_code,'0') <> '0' Then
                   --Cap nhat trang thai tu choi
                   UPDATE FOMAST SET DELTD='Y' WHERE ACCTNO=v_strACCTNO;
                   p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
                   plog.error(pkgctx, 'Error:'  || p_err_message);
                   plog.setendsection(pkgctx, 'pr_placeorder');
                   Return;
               End If;
           End If;
      Else
          UPDATE FOMAST SET
          QUANTITY=v_dblQUANTITY ,
          PRICE=v_dblPRICE /1000,
          QUOTEPRICE=v_dblQUOTEPRICE /1000,
          Quoteqtty= v_dblQUOTEQTTY,
          Limitprice= v_dblLIMITPRICE
          WHERE BOOK='I' AND ACCTNO=v_strACCTNO;
          v_strFEEDBACKMSG := 'MSG_CONFIRMED_ORDER_ADMANMENT';
      End If;
  End If;

    IF p_err_code IS NULL  OR LENGTH(p_err_code)=0 THEN
        p_err_code := systemnums.C_SUCCESS;
    END IF;
    if p_err_message is null then
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
    end if;
    plog.setendsection(pkgctx, 'pr_placeorder');
  exception
    when others then
      p_err_code := errnums.C_SYSTEM_ERROR;
      pr_update_draft_order(p_isdraft,p_draftid,p_issaved,p_err_code,'');
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'pr_placeorder');
  end pr_placeorder;



  --Ket thuc Ham xu ly dat lenh vao FOMAST--

---------------------------------pr_InternalTransfer------------------------------------------------
------------------------------Bat dau Chuyen tien boi bo--------------------------------------------
 PROCEDURE pr_CheckCashTransfer(p_account varchar,
                                p_type varchar2,
                                p_amount number,
                                p_RemainAmt number,
                                p_bankid varchar2,
                                p_err_code  OUT varchar2,
                                p_err_message out varchar2)
  IS
      p_trfcount        number;
      v_keyMinAmt varchar2(50);
      v_keyMaxAmt varchar2(50);
      v_keyCNT varchar2(50);
      v_keyRemain varchar2(50);
      v_keyTransferName varchar2(50);
      l_custid varchar2(10);
      --1.5.7.6|iss:1976
      v_blnCheckCustomerLimit BOOLEAN;
      v_trfMaxAmount          NUMBER(20);
      v_trfCount              NUMBER(20);


        -- 1.6.0.7
      l_baldefovd             apprules.field%TYPE;
      l_cimastcheck_arr       txpks_check.cimastcheck_arrtype;
      v_feetype               varchar2(10);

        --1.6.0.3
      v_trfCurAmt             NUMBER(20);

BEGIN

plog.setBeginSection (pkgctx, 'pr_CheckCashTransfer');
--1.8.2.1.P1: tam thoi bo qua check voi Chuyen tien BIDV
--1.8.2.1.P2: Check so tien toi thieu vơi Chuyen tien BIDV
if (p_type = '004') THEN
  begin
      if to_number(cspks_system.fn_get_sysvar('SYSTEM','ONLINEMINTRFBIDV')) > p_amount then
          p_err_code:='-100137';
          p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
          plog.error(pkgctx, 'Error:'  || p_err_message || '::amount:' || p_amount);
          plog.setendsection(pkgctx, 'pr_CheckCashTransfer');
          return;
      end if;
    exception when others then
        plog.error(pkgctx, 'Error: Chua khai bao han muc chuyen khoan tien BIDV toi thieu');
    end;
   p_err_code:='0';
   return;
end if;
IF (p_type = '001')--Chuyen khoan noi bo
   THEN
   v_keyMinAmt:='ONLINEMINTRF1120_AMT';
   v_keyMaxAmt:='ONLINEMAXTRF1120_AMT';
   v_keyCNT:='ONLINEMAXTRF1120_CNT';
   v_keyRemain:='ONLINEMINREMAINTRF1120_AMT';
   v_keyTransferName:='1120';
   v_blnCheckCustomerLimit := FALSE; --1.5.7.6|iss:1976
   ELSIF  (p_type in ('002','003')) --Chuyen khoan ra ngan hang
   THEN
   v_keyMinAmt:='ONLINEMINTRF1101_AMT';
   v_keyMaxAmt:='ONLINEMAXTRF1101_AMT';
   v_keyCNT:='ONLINEMAXTRF1101_CNT';
   v_keyRemain:='ONLINEMINREMAINTRF1101_AMT';
   v_keyTransferName:='1101';
   --1.5.7.6|iss:1976
   BEGIN
      SELECT trf.maxtrfamt, trf.maxtrfcnt INTO v_trfMaxAmount, v_trfCount
      FROM cftrflimit trf, afmast af
      WHERE trf.custid = af.custid AND af.acctno = p_account AND trf.status = 'A';

      v_blnCheckCustomerLimit := TRUE;
   EXCEPTION WHEN OTHERS THEN
      v_blnCheckCustomerLimit := FALSE;
   END;
   ELSE--Chuyen khoan ra ben ngoai voi CMT
   v_keyMinAmt:='ONLINEMINTRF1133_AMT';
   v_keyMaxAmt:='ONLINEMAXTRF1133_AMT';
   v_keyCNT:='ONLINEMAXTRF1133_CNT';
   v_keyRemain:='ONLINEMINREMAINTRF1133_AMT';
   v_keyTransferName:='1133';
   v_blnCheckCustomerLimit := FALSE; --1.5.7.6|iss:1976
   END IF;

   IF p_type in ('002','003')
     THEN
    -- 1.6.0.7-2146
    -- 1.6.1.5
    --2021.01.0.02: 2614: MSB va BIDV cung bieu phi
    IF  P_bankid LIKE '302%' OR  P_bankid LIKE '202%' OR  P_bankid LIKE '309%' THEN
        v_feetype:='00016';
    ELSE
        IF to_number(p_amount) < 500000000 THEN
          v_feetype:='00017';
          ELSE v_feetype:= '20000';
        END IF;
    END IF;

     l_CIMASTcheck_arr := txpks_check.fn_CIMASTcheck(p_account,'CIMAST','ACCTNO');
     l_BALDEFOVD := l_CIMASTcheck_arr(0).BALDEFOVD;

     IF l_BALDEFOVD < p_amount + fn_gettransfermoneyfee(p_amount,v_feetype) THEN
           p_err_code:='-400110';
           p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
           plog.error(pkgctx, 'Error:'  || p_err_message);
           plog.setendsection(pkgctx, 'pr_CheckCashTransfer');
           return;
     end if;
   END IF;

   begin
       if to_number(cspks_system.fn_get_sysvar('SYSTEM',v_keyRemain)) > p_RemainAmt then
            p_err_code:='-100138';
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message || '::amount:' || p_amount);
            plog.setendsection(pkgctx, 'pr_CheckCashTransfer');
            return;
        end if;
    exception when others then
        plog.error(pkgctx, 'Error: Chua khai bao han muc chuyen khoan con lai toi thieu da qua kenh Online');
    end;

  begin
        if to_number(cspks_system.fn_get_sysvar('SYSTEM',v_keyMinAmt)) > p_amount then
            p_err_code:='-100137';
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message || '::amount:' || p_amount);
            plog.setendsection(pkgctx, 'pr_CheckCashTransfer');
            return;
        end if;
    exception when others then
        plog.error(pkgctx, 'Error: Chua khai bao han muc chuyen khoan tien toi thieu qua kenh Online');
    end;
    --1.5.7.6|iss:1976
    IF v_blnCheckCustomerLimit THEN
       if v_trfMaxAmount < p_amount then
            p_err_code:='-100135';
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message || '::amount:' || p_amount);
            plog.setendsection(pkgctx, 'pr_CheckCashTransfer');
            return;
        end if;
    ELSE
    BEGIN
       if to_number(cspks_system.fn_get_sysvar('SYSTEM',v_keyMaxAmt)) < p_amount then
            p_err_code:='-100135';
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message || '::amount:' || p_amount);
            plog.setendsection(pkgctx, 'pr_CheckCashTransfer');
            return;
        end if;
    exception when others then
        plog.error(pkgctx, 'Error: Chua khai bao han muc chuyen khoan tien toi da qua kenh Online');
    end;
    END IF;

    select custid into l_custid from afmast where acctno = p_account;
    --begin 1.5.4.3|iss1895
    If  (p_type = '001') then
       select count(1), sum(msgamt) into p_trfcount, v_trfCurAmt from tllog
       where tltxcd = '1120' and tlid =systemnums.C_ONLINE_USERID
       and deltd <> 'Y' and txstatus ='1'
       and msgacct in (select acctno from afmast where custid = l_custid);
    elsif p_type IN ('002', '003') THEN --Chuyen khoan ra ngan hang
       select count(1), sum(msgamt) into p_trfcount, v_trfCurAmt from tllog
       where tltxcd ='1101' and tlid =systemnums.C_ONLINE_USERID
       and deltd <> 'Y' and txstatus ='1'
       and msgacct in (select acctno from afmast where custid = l_custid);
    else
       select count(1), sum(msgamt) into p_trfcount, v_trfCurAmt from tllog
       where tltxcd ='1133' and tlid =systemnums.C_ONLINE_USERID
       and deltd <> 'Y' and txstatus ='1'
       and msgacct in (select acctno from afmast where custid = l_custid);
    end if;

    --Kiem tra so lan chuyen khoan toi da
    BEGIN
        --end 1.5.4.3|iss1895
        --select count(1) into p_trfcount from tllog where tltxcd =v_keyTransferName and tlid =systemnums.C_ONLINE_USERID and deltd <> 'Y' and txstatus ='1' and msgacct = p_account;
        --1.5.7.6|iss:1976
        IF v_blnCheckCustomerLimit THEN
           IF v_trfCount <= p_trfcount then
              p_err_code:='-100136';
              p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
              plog.error(pkgctx, 'Error:'  || p_err_message);
              plog.setendsection(pkgctx, 'pr_CheckCashTransfer');
              return;
           end if;
        ELSE
           if to_number(cspks_system.fn_get_sysvar('SYSTEM',v_keyCNT)) <= p_trfcount then
              p_err_code:='-100136';
              p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
              plog.error(pkgctx, 'Error:'  || p_err_message);
              plog.setendsection(pkgctx, 'pr_CheckCashTransfer');
              return;
           end if;
        END IF;
    exception when others then
        plog.error(pkgctx, 'Error: Chua khai bao so lan chuyen khoan toi da trong mot ngay qua kenh Online');
    end;

    --1.6.0.3: tong han muc trong ngay
    BEGIN
       IF p_type IN ('002', '003') AND NOT v_blnCheckCustomerLimit THEN
          if to_number(cspks_system.fn_get_sysvar('SYSTEM', 'ONLINEMAXTRF_CNT')) < nvl(v_trfCurAmt,0) + p_amount then
             p_err_code:='-100167';
             p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
             plog.error(pkgctx, 'Error:'  || p_err_message);
             plog.setendsection(pkgctx, 'pr_CheckCashTransfer');
             return;
          end if;
       END IF;
    exception when others then
       plog.error(pkgctx, 'Error: Chua khai bao so tien chuyen khoan toi da trong mot ngay qua kenh Online');
    END;
    --
 p_err_code:='0';
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_CheckCashTransfer');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_CheckCashTransfer');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_CheckCashTransfer;

 PROCEDURE pr_InternalTransfer(p_account varchar,
                            p_toaccount  varchar2,
                            p_amount number,
                            p_desc varchar2,
                            p_err_code  OUT varchar2,
                            p_err_message out varchar2,
                            p_ipaddress in  varchar2 default '' , --1.5.3.0
                            p_via in varchar2 default '',
                            p_validationtype in varchar2 default '',
                            p_devicetype IN varchar2 default '',
                            p_device  IN varchar2 default '')
  IS
      l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      l_err_param varchar2(300);
      v_recvcustodycd   varchar2(10);
      v_recvCUSTNAME    varchar2(200);
      v_recvLICENSE    varchar2(200);

      p_trfcount        number;
      v_feetype         varchar2(10);
      l_custid varchar2(10);
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_InternalTransfer');

    -- Check host & branch active or inactive
    p_err_code := fn_CheckActiveSystem;
    IF p_err_code <> systemnums.C_SUCCESS THEN
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_InternalTransfer');
        return;
    END IF;
    -- End: Check host & branch active or inactive

    --Them buoc chan theo quy dinh chong rua tien
    --Doi voi giao dich qua kenh giao dich truc tuyen
    --Kiem tra so tien chuyen khoan toi da
    begin
        if to_number(cspks_system.fn_get_sysvar('SYSTEM','ONLINEMAXTRF1120_AMT')) < p_amount then
            p_err_code:='-100135';
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_InternalTransfer');
            return;
        end if;
    exception when others then
        plog.error(pkgctx, 'Error: Chua khai bao han muc chuyen khoan tien toi da qua kenh Online');
    end;
    --Kiem tra so lan chuyen khoan toi da
    begin

            select custid into l_custid from afmast where acctno = p_account;

        select count(1) into p_trfcount from tllog
        where tltxcd = '1120' and tlid =systemnums.C_ONLINE_USERID--1.5.4.3|iss1895
        and deltd <> 'Y' and txstatus ='1'
        --and msgacct = p_account;
                and msgacct in (select acctno from afmast where custid = l_custid);


        if to_number(cspks_system.fn_get_sysvar('SYSTEM','ONLINEMAXTRF1120_CNT')) <= p_trfcount then
            p_err_code:='-100136';
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_InternalTransfer');
            return;
        end if;
    exception when others then
        plog.error(pkgctx, 'Error: Chua khai bao so lan chuyen khoan toi da trong mot ngay qua kenh Online');
    end;

    SELECT TO_DATE (varvalue, systemnums.c_date_format)
               INTO v_strCURRDATE
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := systemnums.C_ONLINE_USERID;
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    --1.5.3.0
    if (p_ipaddress is not null ) then l_txmsg.ipaddress:= substr(p_ipaddress,1,20); end if;--1.6.1.9; MSBS-2209  substr
    --
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := 'DAY';
    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd:='1120';

    --Set txnum
    SELECT systemnums.C_OL_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO l_txmsg.txnum
              FROM DUAL;
    l_txmsg.brid        := substr(p_account,1,4);


    -- Lay thong tin khach hang
    SELECT CF.custodycd, CF.fullname, CF.idcode
    INTO v_recvcustodycd, v_recvCUSTNAME, v_recvLICENSE
    FROM CFMAST CF, AFMAST AF
    WHERE CF.custid = AF.custid AND AF.acctno = p_toaccount;

    --p_txnum:=l_txmsg.txnum;
    --p_txdate:=l_txmsg.txdate;
    --Set cac field giao dich
    --03   DACCTNO     C
    l_txmsg.txfields ('03').defname   := 'DACCTNO';
    l_txmsg.txfields ('03').TYPE      := 'C';
    l_txmsg.txfields ('03').VALUE     := p_account;
    --05   CACCTNO     C
    l_txmsg.txfields ('05').defname   := 'CACCTNO';
    l_txmsg.txfields ('05').TYPE      := 'C';
    l_txmsg.txfields ('05').VALUE     := p_toaccount;
    --10   AMT         N
    l_txmsg.txfields ('10').defname   := 'AMT';
    l_txmsg.txfields ('10').TYPE      := 'N';
    l_txmsg.txfields ('10').VALUE     := round(p_amount,0);
    --30   DESC        C
    l_txmsg.txfields ('30').defname   := 'DESC';
    l_txmsg.txfields ('30').TYPE      := 'C';
    l_txmsg.txfields ('30').VALUE     := UTF8NUMS.c_const_TXDESC_1120_OL || p_desc;
    --31   FULLNAME            C
    l_txmsg.txfields ('31').defname   := 'FULLNAME';
    l_txmsg.txfields ('31').TYPE      := 'C';
    l_txmsg.txfields ('31').VALUE :='';
    --87   AVLCASH     N
    l_txmsg.txfields ('87').defname   := 'AVLCASH';
    l_txmsg.txfields ('87').TYPE      := 'N';
    l_txmsg.txfields ('87').VALUE     := 0;
    --88   CUSTODYCD   C
    l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
    l_txmsg.txfields ('88').TYPE      := 'C';
    l_txmsg.txfields ('88').VALUE :='';
    --89   CUSTODYCD   C
    l_txmsg.txfields ('89').defname   := 'CUSTODYCD';
    l_txmsg.txfields ('89').TYPE      := 'C';
    l_txmsg.txfields ('89').VALUE     := v_recvcustodycd;
    --90   CUSTNAME    C
    l_txmsg.txfields ('90').defname   := 'CUSTNAME';
    l_txmsg.txfields ('90').TYPE      := 'C';
    l_txmsg.txfields ('90').VALUE :='';
    --91   ADDRESS     C
    l_txmsg.txfields ('91').defname   := 'ADDRESS';
    l_txmsg.txfields ('91').TYPE      := 'C';
    l_txmsg.txfields ('91').VALUE :='';
    --92   LICENSE     C
    l_txmsg.txfields ('92').defname   := 'LICENSE';
    l_txmsg.txfields ('92').TYPE      := 'C';
    l_txmsg.txfields ('92').VALUE :='';
    --93   CUSTNAME2   C
    l_txmsg.txfields ('93').defname   := 'CUSTNAME2';
    l_txmsg.txfields ('93').TYPE      := 'C';
    l_txmsg.txfields ('93').VALUE     := v_recvCUSTNAME;
    --94   ADDRESS2    C
    l_txmsg.txfields ('94').defname   := 'ADDRESS2';
    l_txmsg.txfields ('94').TYPE      := 'C';
    l_txmsg.txfields ('94').VALUE :='';
    --95   LICENSE2    C
    l_txmsg.txfields ('95').defname   := 'LICENSE2';
    l_txmsg.txfields ('95').TYPE      := 'C';
    l_txmsg.txfields ('95').VALUE     := v_recvLICENSE;
    --96   IDDATE      C
    l_txmsg.txfields ('96').defname   := 'IDDATE';
    l_txmsg.txfields ('96').TYPE      := 'C';
    l_txmsg.txfields ('96').VALUE :='';
    --97   IDPLACE     C
    l_txmsg.txfields ('97').defname   := 'IDPLACE';
    l_txmsg.txfields ('97').TYPE      := 'C';
    l_txmsg.txfields ('97').VALUE :='';
    --98   IDDATE2     C
    l_txmsg.txfields ('98').defname   := 'IDDATE2';
    l_txmsg.txfields ('98').TYPE      := 'C';
    l_txmsg.txfields ('98').VALUE :='';
    --99   IDPLACE2    C
    l_txmsg.txfields ('99').defname   := 'IDPLACE2';
    l_txmsg.txfields ('99').TYPE      := 'C';
    l_txmsg.txfields ('99').VALUE :='';
    --79   REFID    C
    l_txmsg.txfields ('79').defname   := 'REFID';
    l_txmsg.txfields ('79').TYPE      := 'C';
    l_txmsg.txfields ('79').VALUE :='';
    -- Ducnv them bieu phi
    v_feetype:='00015';
    -- Truong hop cung so luu ky
    For rec in (Select 1
                From afmast a1, afmast a2
                Where a1.acctno=p_account  and a2.acctno= p_toaccount  and a1.custid = a2.custid )loop
                     v_feetype:='00014';
                End loop;

    l_txmsg.txfields ('25').defname   := 'FEETYPE';
    l_txmsg.txfields ('25').TYPE      := 'C';
    l_txmsg.txfields ('25').VALUE     := v_feetype;

    l_txmsg.txfields ('15').defname   := 'FEEAMT';
    l_txmsg.txfields ('15').TYPE      := 'N';
    l_txmsg.txfields ('15').VALUE     := fn_gettransfermoneyfee(p_amount,v_feetype);

    l_txmsg.txfields ('16').defname   := 'TOTALAMT';
    l_txmsg.txfields ('16').TYPE      := 'N';
    l_txmsg.txfields ('16').VALUE     := p_amount + fn_gettransfermoneyfee(p_amount,v_feetype);

    BEGIN
        IF txpks_#1120.fn_autotxprocess (l_txmsg,
                                         p_err_code,
                                         l_err_param
           ) <> systemnums.c_success
        THEN
           plog.debug (pkgctx,
                       'got error 1120: ' || p_err_code
           );
           ROLLBACK;
           p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
           plog.error(pkgctx, 'Error:'  || p_err_message);
           plog.setendsection(pkgctx, 'pr_InternalTransfer');
           RETURN;
        END IF;

        --ThanhNV sua them doan check FO, neu giao dich duoi FO khong thanh cong cung rollback.
        PCK_SYN2FO.PRC_CHECK_SYN2FO(v_txnum =>l_txmsg.txnum,
                                     v_errcode => p_err_code,
                                     v_errmsg => p_err_message);


        plog.debug (pkgctx, 'PRC_CHECK_SYN2FO p_err_code '||p_err_code);
        IF p_err_code <> systemnums.c_success THEN
            ROLLBACK;
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error (pkgctx, p_err_message);
            plog.setendsection(pkgctx, 'pr_InternalTransfer');
            RETURN;
        END IF;

    END;
    p_err_code:='0';
    --1.5.3.0
    pr_insertiplog( l_txmsg.txnum,  l_txmsg.txdate, l_txmsg.ipaddress, p_via, p_validationtype, p_devicetype, p_device, p_err_code);
    plog.setendsection(pkgctx, 'pr_InternalTransfer');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_InternalTransfer');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_InternalTransfer');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_InternalTransfer;

---------------------------------pr_ExternalTransfer------------------------------------------------
  PROCEDURE pr_ExternalTransfer(p_account varchar,
                            p_bankid varchar2,
                            p_benefbank varchar2,
                            p_benefacct varchar2,
                            p_benefcustname varchar2,
                            p_beneflicense varchar2,
                            p_amount number,
                            p_feeamt number,
                            p_vatamt number,
                            p_desc varchar2,
                            p_err_code  OUT varchar2,
                            p_err_message out varchar2,
                            p_ipaddress in  varchar2 default '' , --1.5.3.0
                            p_via in varchar2 default '',
                            p_validationtype in varchar2 default '',
                            p_devicetype IN varchar2 default '',
                            p_device  IN varchar2 default '')
  IS
      l_txmsg               tx.msg_rectype;
      l_err_param varchar2(300);
      v_idcode varchar2(50);
      v_iddate  varchar2(20);
      v_idplace varchar2(200);
      v_citybank    varchar2(200);
      v_CITYEF      varchar2(200);
      v_custodycd   varchar2(200);
      v_fullname    varchar2(1000);
      p_trfcount number; --So lan chuyen khoan trong ngay
      v_feetype varchar2(10);
      l_custid varchar2(10);
      --1.5.7.6|iss:1976
      v_blnCheckCustomerLimit BOOLEAN;
      v_trfAutoID             NUMBER;
      v_trfMaxTotalAmount     NUMBER(20);
      v_trfMaxTotalAmount_1   NUMBER(20);
      v_trfAmountext_temp     NUMBER(20);
      v_trfMaxAmount          NUMBER(20);
      v_trfRemaxtrfamt        NUMBER(20);
      v_trfCount              NUMBER(20);

      v_trfCurAmt             NUMBER(20);
      v_trfCurAmtExt          NUMBER(20);
      v_trfCurCashAmt         NUMBER(20);
      v_trfCurAdvAmt          NUMBER(20);
      v_trfCashAmt            NUMBER(20);
      v_trfAdvAmt             NUMBER(20);

      v_iTrfCurAmt            NUMBER(20);
      v_iTrfCurCashAmt        NUMBER(20);
      v_iTrfCurAdvAmt         NUMBER(20);
      v_balance               NUMBER(20);
      v_currdate              DATE := getcurrdate;

       -- 1.6.0.7
      l_baldefovd             apprules.field%TYPE;
      l_cimastcheck_arr       txpks_check.cimastcheck_arrtype;
BEGIN
    plog.setbeginsection(pkgctx, 'pr_ExternalTransfer');

    -- Check host & branch active or inactive
    p_err_code := fn_CheckActiveSystem;
    IF p_err_code <> systemnums.C_SUCCESS THEN
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_ExternalTransfer');
        return;
    END IF;
    -- End: Check host & branch active or inactive

    --Them buoc chan theo quy dinh chong rua tien
    --Doi voi giao dich qua kenh giao dich truc tuyen
    --Kiem tra so tien chuyen khoan toi da
    --1.5.7.6|iss:1976
    BEGIN
       SELECT trf.maxtrfamt, trf.maxtrfcnt, trf.maxtotaltrfamt, trf.remaxtrfamt, trf.maxtotaltrfamt_1
       INTO v_trfMaxAmount, v_trfCount, v_trfMaxTotalAmount, v_trfRemaxtrfamt, v_trfMaxTotalAmount_1
       FROM cftrflimit trf, afmast af, cfmast cf
       WHERE trf.custid = af.custid AND trf.status = 'A'
         AND af.acctno = p_account AND af.custid = cf.custid;
       v_blnCheckCustomerLimit := TRUE;
    EXCEPTION WHEN OTHERS THEN
       v_blnCheckCustomerLimit := FALSE;
    END;

    -- 1.6.0.7-2146
    -- Ducnv them phi
     If P_bankid like '302%' or  P_bankid like '202%' or  P_bankid like '309%' then
        v_feetype:='00016';
     ELSE
        if to_number(p_amount) < 500000000 then
          v_feetype:='00017';
          else v_feetype:= '20000';
        end if;
     End if;

     l_CIMASTcheck_arr := txpks_check.fn_CIMASTcheck(p_account,'CIMAST','ACCTNO');
     l_BALDEFOVD := l_CIMASTcheck_arr(0).BALDEFOVD;

     IF l_BALDEFOVD < p_amount + fn_gettransfermoneyfee(p_amount,v_feetype) THEN
            p_err_code:='-400110';
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_ExternalTransfer');
            return;
     end if;

    IF v_blnCheckCustomerLimit THEN
        IF v_trfMaxAmount < p_amount THEN
            p_err_code:='-100131';
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_ExternalTransfer');
            return;
        end if;
    ELSE
    begin
        if to_number(cspks_system.fn_get_sysvar('SYSTEM','ONLINEMAXTRF1101_AMT')) < p_amount  THEN
            p_err_code:='-100131';
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_ExternalTransfer');
            return;
        end if;
    exception when others then
        plog.error(pkgctx, 'Error: Chua khai bao han muc chuyen khoan tien toi da qua kenh Online');
    end;
    END IF;

    -- Lay thong tin khach hang
    SELECT CF.CUSTID, CF.IDCODE, TO_CHAR(CF.IDDATE,'DD/MM/YYYY'), CF.IDPLACE, CF.CUSTODYCD, CF.FULLNAME
    INTO l_custid, v_idcode, v_iddate, v_idplace, v_custodycd, v_fullname
    FROM CFMAST CF, AFMAST AF
    WHERE CF.CUSTID = AF.CUSTID AND AF.ACCTNO = p_account;

    select count(1), NVL(sum(tl.msgamt),0), NVL(SUM(decode(
           upper(translate(fld.cvalue, utf8nums.c_findtext, utf8nums.c_repltext)),
           upper(translate(v_fullname, utf8nums.c_findtext, utf8nums.c_repltext)),
           0, tl.msgamt)),0)
    into p_trfcount, v_trfCurAmt, v_trfCurAmtExt
    from tllog tl, tllogfld fld
    where tl.tltxcd ='1101' and tl.tlid =systemnums.C_ONLINE_USERID--1.5.4.3|iss1895
    and tl.deltd <> 'Y' and tl.txstatus ='1'
    and tl.msgacct in (select acctno from afmast where custid = l_custid)
    AND tl.txdate = fld.txdate AND tl.txnum = fld.txnum AND fld.fldcd = '82';


     -- 1.8.1.4: so tien da chuyen khac chinh chu chua duyet
    select NVL(SUM(decode(
           upper(translate(benefcustname, utf8nums.c_findtext, utf8nums.c_repltext)),
           upper(translate(v_fullname, utf8nums.c_findtext, utf8nums.c_repltext)),
           0, AMOUNT)),0)
    INTO v_trfAmountext_temp
    from EXTRANFERREQ
    where status='P' AND txdate=v_currdate
    and afacctno in (select acctno from afmast where custid = l_custid);


    --Kiem tra so lan chuyen khoan toi da
    IF v_blnCheckCustomerLimit THEN
       IF v_trfCount <= p_trfcount then
          p_err_code:='-100132';
          p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
          plog.error(pkgctx, 'Error:'  || p_err_message);
          plog.setendsection(pkgctx, 'pr_ExternalTransfer');
          return;
       end if;
    ELSE
    begin
       if to_number(cspks_system.fn_get_sysvar('SYSTEM','ONLINEMAXTRF1101_CNT')) <= p_trfcount then
          p_err_code:='-100132';
          p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
          plog.error(pkgctx, 'Error:'  || p_err_message);
          plog.setendsection(pkgctx, 'pr_ExternalTransfer');
          return;
       end if;
    exception when others then
        plog.error(pkgctx, 'Error: Chua khai bao so lan chuyen khoan toi da trong mot ngay qua kenh Online');
    end;
    END IF;

    -- Kiem tra so tien chuyen khoan toi da 1 ngay
    IF upper(translate(p_benefcustname, utf8nums.c_findtext, utf8nums.c_repltext))
          <> upper(translate(v_fullname, utf8nums.c_findtext, utf8nums.c_repltext)) THEN
       IF v_blnCheckCustomerLimit THEN
          IF v_trfMaxTotalAmount_1 <  v_trfCurAmtExt + v_trfAmountext_temp + p_amount THEN  --  han muc tam khac chinh chu con lai < so tien chuyen khac chinh chu
             p_err_code:='-100168';
             p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
             plog.error(pkgctx, 'Error:'  || p_err_message);
             plog.setendsection(pkgctx, 'pr_ExternalTransfer');
             RETURN;
          end if;
       ELSE
       BEGIN
          IF to_number(cspks_system.fn_get_sysvar('SYSTEM', 'ONLINEMAXTRF_CNT_1')) < nvl(v_trfCurAmtExt,0) + p_amount THEN
             p_err_code:='-100168';
             p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
             plog.error(pkgctx, 'Error:'  || p_err_message);
             plog.setendsection(pkgctx, 'pr_ExternalTransfer');
             RETURN;
          END IF;
       EXCEPTION WHEN OTHERS THEN
          plog.error(pkgctx, 'Error: Chua khai bao so tien chuyen khoan khac chu toi da trong mot ngay qua kenh Online');
       END;
       END IF;
    END IF;

    IF NOT v_blnCheckCustomerLimit THEN
       BEGIN
          IF to_number(cspks_system.fn_get_sysvar('SYSTEM', 'ONLINEMAXTRF_CNT')) < nvl(v_trfCurAmt,0) + p_amount THEN
             p_err_code:='-100167';
             p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
             plog.error(pkgctx, 'Error:'  || p_err_message);
             plog.setendsection(pkgctx, 'pr_ExternalTransfer');
             RETURN;
          END IF;
       EXCEPTION WHEN OTHERS THEN
          plog.error(pkgctx, 'Error: Chua khai bao so tien chuyen khoan toi da trong mot ngay qua kenh Online');
       END;
    ELSE
       -- 1.5.7.6|iss:1976
       -- Neu la KH dc khai bao han muc rieng
       -- Them buoc duyet neu vi pham HAN MUC Tong gia tri chuyen tien, chuyen tien cho ve
       FOR rec IN (
           SELECT af2.acctno afacctno FROM afmast af1, afmast af2
           WHERE af1.custid = af2.custid AND af1.acctno = p_account
       ) LOOP
          SELECT SUM(msgamt) INTO v_iTrfCurAmt FROM tllog
          WHERE tltxcd ='1101' AND tlid =systemnums.C_ONLINE_USERID
          AND deltd <> 'Y' AND txstatus ='1' AND msgacct = rec.afacctno;

          SELECT balance INTO v_balance FROM cimast WHERE afacctno = rec.afacctno;

          v_iTrfCurCashAmt := GREATEST(LEAST(nvl(v_iTrfCurAmt, 0), v_balance + nvl(v_iTrfCurAmt, 0)), 0);
          v_iTrfCurAdvAmt  := nvl(v_iTrfCurAmt, 0) - v_iTrfCurCashAmt;
          v_trfCurCashAmt  := nvl(v_trfCurCashAmt, 0) + v_iTrfCurCashAmt;
          v_trfCurAdvAmt   := nvl(v_trfCurAdvAmt, 0) + v_iTrfCurAdvAmt;

          IF rec.afacctno = p_account THEN
             v_trfCashAmt := GREATEST(LEAST(p_amount, v_balance), 0);
             v_trfAdvAmt  := p_amount - v_trfCashAmt;
          END IF;
       END LOOP;

       IF v_trfCurCashAmt + v_trfCurAdvAmt + p_amount
                               > v_trfMaxTotalAmount OR
          v_trfCurAdvAmt + v_trfAdvAmt
                               > v_trfRemaxtrfamt THEN
          v_trfAutoID := seq_extranferreq.nextval;
          -- Luu log yeu cau chuyen khoan
          --1.6.1.9; MSBS-2209  substr
          INSERT INTO EXTRANFERREQ(AUTOID, TXDATE, AFACCTNO, BANKID, BENEFBANK, BENEFACCT,
          BENEFCUSTNAME, BENEFLICENSE, AMOUNT, FEEAMT, VATAMT, TXDESC, IPADDRESS, VIA,
          VALIDATIONTYPE, DEVICETYPE, DEVICE, STATUS, CASHAMT, ADVAMT, CURCASHAMT, CURADVAMT,CURCASHAMTEXT)
          VALUES(v_trfAutoID, v_currdate, p_account, p_bankid, p_benefbank, p_benefacct,
          p_benefcustname, p_beneflicense, p_amount, p_feeamt, p_vatamt, p_desc, substr(p_ipaddress,1,20), p_via,
          p_validationtype, p_devicetype, p_device, 'P', v_trfCashAmt, v_trfAdvAmt, v_trfCurCashAmt,v_trfCurAdvAmt,v_trfCurAmtExt);
          -- Gui Email thong bao cho nguoi co lien quan
          NMPKS_EMS.GenTemplateEmailLimit(v_trfAutoID);
          -- Thong bao loi
          p_err_code:='-100122';
          p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
          plog.error(pkgctx, 'Error:'  || p_err_message);
          plog.setendsection(pkgctx, 'pr_ExternalTransfer');
          RETURN;
       END IF;
    END IF;

    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := systemnums.C_ONLINE_USERID;
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    --1.5.3.0
    if (p_ipaddress is not null ) then l_txmsg.ipaddress:= substr(p_ipaddress,1,20); end if;--1.6.1.9; MSBS-2209  substr
    --
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := 'INT';
    l_txmsg.txdate:=v_currdate;
    l_txmsg.busdate:=v_currdate;
    l_txmsg.tltxcd:='1101';

    --Set txnum
    SELECT systemnums.C_OL_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO l_txmsg.txnum
              FROM DUAL;
    l_txmsg.brid        := substr(p_account,1,4);

    -- Lay thong tin ngan hang
    SELECT CF.citybank, CF.cityef
    INTO v_citybank, v_CITYEF
    FROM cfotheracc CF
    WHERE CF.afacctno = p_account AND CF.bankacc = p_benefacct;

  --p_txnum:=l_txmsg.txnum;
  --p_txdate:=l_txmsg.txdate;
  --Set cac field giao dich
    --03   ACCTNO          C
    l_txmsg.txfields ('03').defname   := 'ACCTNO';
    l_txmsg.txfields ('03').TYPE      := 'C';
    l_txmsg.txfields ('03').VALUE     := p_account;
    --05   BANKID          C
    l_txmsg.txfields ('05').defname   := 'BANKID';
    l_txmsg.txfields ('05').TYPE      := 'C';
    l_txmsg.txfields ('05').VALUE     := p_bankid;
    --09   IORO            C
    l_txmsg.txfields ('09').defname   := 'IORO';
    l_txmsg.txfields ('09').TYPE      := 'C';
    l_txmsg.txfields ('09').VALUE     := 0;
    --10   TRFAMT          N
    l_txmsg.txfields ('10').defname   := 'TRFAMT';
    l_txmsg.txfields ('10').TYPE      := 'N';
    l_txmsg.txfields ('10').VALUE     := round(p_amount,0)-round(p_feeamt,0)-round(p_vatamt,0);
    --11   FEEAMT          N
    l_txmsg.txfields ('11').defname   := 'FEEAMT';
    l_txmsg.txfields ('11').TYPE      := 'N';
    l_txmsg.txfields ('11').VALUE     := round(p_feeamt,0);
    --12   VATAMT          N
    l_txmsg.txfields ('12').defname   := 'VATAMT';
    l_txmsg.txfields ('12').TYPE      := 'N';
    l_txmsg.txfields ('12').VALUE     := round(p_vatamt,0);
    --13   AMT             N
    l_txmsg.txfields ('13').defname   := 'AMT';
    l_txmsg.txfields ('13').TYPE      := 'N';
    l_txmsg.txfields ('13').VALUE     := round(p_amount,0);
    --30   DESC            C
    l_txmsg.txfields ('30').defname   := 'DESC';
    l_txmsg.txfields ('30').TYPE      := 'C';
    --l_txmsg.txfields ('30').VALUE     := UTF8NUMS.c_const_TXDESC_1101_OL || '/ ' || v_fullname || '/ ' || v_custodycd;
    l_txmsg.txfields ('30').VALUE     := p_desc;

    --64   FULLNAME        C
    l_txmsg.txfields ('64').defname   := 'FULLNAME';
    l_txmsg.txfields ('64').TYPE      := 'C';
    l_txmsg.txfields ('64').VALUE     := v_fullname;
    --65   ADDRESS        C
    l_txmsg.txfields ('65').defname   := 'ADDRESS';
    l_txmsg.txfields ('65').TYPE      := 'C';
    l_txmsg.txfields ('65').VALUE :='';
    --67   IDDATE        C
    l_txmsg.txfields ('67').defname   := 'IDDATE';
    l_txmsg.txfields ('67').TYPE      := 'C';
    l_txmsg.txfields ('67').VALUE     := v_iddate;
    --68   IDPLACE        C
    l_txmsg.txfields ('68').defname   := 'IDPLACE';
    l_txmsg.txfields ('68').TYPE      := 'C';
    l_txmsg.txfields ('68').VALUE     := v_idplace;
    --69   LICENSE        C
    l_txmsg.txfields ('69').defname   := 'LICENSE';
    l_txmsg.txfields ('69').TYPE      := 'C';
    l_txmsg.txfields ('69').VALUE     := v_idcode;
    --80   BENEFBANK       C --Ten ngan hang thu huong
    l_txmsg.txfields ('80').defname   := 'BENEFBANK';
    l_txmsg.txfields ('80').TYPE      := 'C';
    l_txmsg.txfields ('80').VALUE :=p_benefbank;
    --81   BENEFACCT       C --So tai khoan thu huong
    l_txmsg.txfields ('81').defname   := 'BENEFACCT';
    l_txmsg.txfields ('81').TYPE      := 'C';
    l_txmsg.txfields ('81').VALUE :=p_benefacct;
    --82   BENEFCUSTNAME   C
    l_txmsg.txfields ('82').defname   := 'BENEFCUSTNAME';
    l_txmsg.txfields ('82').TYPE      := 'C';
    l_txmsg.txfields ('82').VALUE :=p_benefcustname;
    --83   BENEFLICENSE    C
    l_txmsg.txfields ('83').defname   := 'BENEFLICENSE';
    l_txmsg.txfields ('83').TYPE      := 'C';
    l_txmsg.txfields ('83').VALUE :=p_beneflicense;
    --84   CITYBANK    C
    l_txmsg.txfields ('84').defname   := 'CITYBANK';
    l_txmsg.txfields ('84').TYPE      := 'C';
    l_txmsg.txfields ('84').VALUE     := v_citybank;
    --85   CITYEF    C
    l_txmsg.txfields ('85').defname   := 'CITYEF';
    l_txmsg.txfields ('85').TYPE      := 'C';
    l_txmsg.txfields ('85').VALUE     := v_CITYEF;
    --88   CUSTODYCD   C
    l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
    l_txmsg.txfields ('88').TYPE      := 'C';
    l_txmsg.txfields ('88').VALUE :='';
    --89   AVLCASH         N
    l_txmsg.txfields ('89').defname   := 'AVLCASH';
    l_txmsg.txfields ('89').TYPE      := 'N';
    l_txmsg.txfields ('89').VALUE :=0;
    --90   CUSTNAME        C
    l_txmsg.txfields ('90').defname   := 'CUSTNAME';
    l_txmsg.txfields ('90').TYPE      := 'C';
    l_txmsg.txfields ('90').VALUE :='';
    /*--91   ADDRESS         C
    l_txmsg.txfields ('91').defname   := 'ADDRESS';
    l_txmsg.txfields ('91').TYPE      := 'C';
    l_txmsg.txfields ('91').VALUE :='';
    --92   LICENSE         C
    l_txmsg.txfields ('92').defname   := 'LICENSE';
    l_txmsg.txfields ('92').TYPE      := 'C';
    l_txmsg.txfields ('92').VALUE :='';
    --93   IDDATE          C
    l_txmsg.txfields ('93').defname   := 'IDDATE';
    l_txmsg.txfields ('93').TYPE      := 'C';
    l_txmsg.txfields ('93').VALUE :='';
    --94   IDPLACE         C
    l_txmsg.txfields ('94').defname   := 'IDPLACE';
    l_txmsg.txfields ('94').TYPE      := 'C';
    l_txmsg.txfields ('94').VALUE :='';*/
    --95   BENEFIDDATE     C
    l_txmsg.txfields ('95').defname   := 'BENEFIDDATE';
    l_txmsg.txfields ('95').TYPE      := 'C';
    l_txmsg.txfields ('95').VALUE :='';
    --96   BENEFIDPLACE    C
    l_txmsg.txfields ('96').defname   := 'BENEFIDPLACE';
    l_txmsg.txfields ('96').TYPE      := 'C';
    l_txmsg.txfields ('96').VALUE :='';
    --97   LICENSE    C
    l_txmsg.txfields ('97').defname   := 'BANK_ORG_NO';
    l_txmsg.txfields ('97').TYPE      := 'C';
    l_txmsg.txfields ('97').VALUE :='';
    /*--98   IDDATE    C
    l_txmsg.txfields ('98').defname   := 'IDDATE';
    l_txmsg.txfields ('98').TYPE      := 'C';
    l_txmsg.txfields ('98').VALUE :='';
    --99   IDPLACE    C
    l_txmsg.txfields ('99').defname   := 'IDPLACE';
    l_txmsg.txfields ('99').TYPE      := 'C';
    l_txmsg.txfields ('99').VALUE :='';*/
    --66   FEECD    C
    l_txmsg.txfields ('66').defname   := '$FEECD';
    l_txmsg.txfields ('66').TYPE      := 'C';
    l_txmsg.txfields ('66').VALUE :='';
    --79   REFID    C
    l_txmsg.txfields ('79').defname   := 'REFID';
    l_txmsg.txfields ('79').TYPE      := 'C';
    l_txmsg.txfields ('79').VALUE :='';
    --00   AUTOID    C
    l_txmsg.txfields ('00').defname   := 'AUTOID';
    l_txmsg.txfields ('00').TYPE      := 'C';
    l_txmsg.txfields ('00').VALUE     :='';
    -- Ducnv them phi
    -- If P_bankid like '302%' then
    --    v_feetype:='00016';
    --ELSE
    --   if to_number(p_amount) < 500000000 then
    --       v_feetype:='00017';
    --    else v_feetype:= '20000';
    --    end if;
    -- End if;


     l_txmsg.txfields ('35').defname   := 'FEETYPE';
     l_txmsg.txfields ('35').TYPE      := 'C';
     l_txmsg.txfields ('35').VALUE     := v_feetype;

    l_txmsg.txfields ('15').defname   := 'FEEAMT';
    l_txmsg.txfields ('15').TYPE      := 'N';
    l_txmsg.txfields ('15').VALUE     := fn_gettransfermoneyfee(p_amount,v_feetype);

    l_txmsg.txfields ('16').defname   := 'TOTALAMT';
    l_txmsg.txfields ('16').TYPE      := 'N';
    l_txmsg.txfields ('16').VALUE     := p_amount + fn_gettransfermoneyfee(p_amount,v_feetype);


    BEGIN
        IF txpks_#1101.fn_autotxprocess (l_txmsg,
                                         p_err_code,
                                         l_err_param
           ) <> systemnums.c_success
        THEN
           plog.debug (pkgctx,
                       'got error 1101: ' || p_err_code
           );
           ROLLBACK;
           p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
           plog.error(pkgctx, 'Error:'  || p_err_message);
           plog.setendsection(pkgctx, 'pr_ExternalTransfer');
           RETURN;
        END IF;
        --ThanhNV sua them doan check FO, neu giao dich duoi FO khong thanh cong cung rollback.
         PCK_SYN2FO.PRC_CHECK_SYN2FO(v_txnum =>l_txmsg.txnum,
                                     v_errcode => p_err_code,
                                     v_errmsg => p_err_message);


        plog.debug (pkgctx, 'PRC_CHECK_SYN2FO p_err_code '||p_err_code);
        IF p_err_code <> systemnums.c_success THEN
            ROLLBACK;
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error (pkgctx, p_err_message);
            plog.setendsection(pkgctx, 'pr_ExternalTransfer');
            RETURN;
        END IF;
    END;
    p_err_code:=0;
    --1.5.3.0
    pr_insertiplog( l_txmsg.txnum,  l_txmsg.txdate, l_txmsg.ipaddress, p_via, p_validationtype, p_devicetype, p_device, p_err_code);
    plog.setendsection(pkgctx, 'pr_ExternalTransfer');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_ExternalTransfer');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_ExternalTransfer');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_ExternalTransfer;

---------------------------------pr_InternalTransfer------------------------------------------------
  PROCEDURE pr_RevertTransfer(p_tltxcd IN VARCHAR2,
                            p_txdate IN  varchar2,
                            p_txnum IN  VARCHAR2,
                            p_err_code  OUT varchar2,
                            p_err_message out varchar2)
  IS
      l_err_param varchar2(300);

  BEGIN
    plog.setbeginsection(pkgctx, 'pr_RevertTransfer');

    BEGIN
        IF p_tltxcd = '1120' THEN
            IF txpks_#1120.fn_txrevert(p_txnum, p_txdate, p_err_code, l_err_param) <> systemnums.c_success
            THEN
               plog.debug (pkgctx,
                           'got error 1120 revert: ' || p_err_code
               );
               ROLLBACK;
               p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
               plog.error(pkgctx, 'Error:'  || p_err_message);
               plog.setendsection(pkgctx, 'pr_RevertTransfer');
               RETURN;
            END IF;
        ELSE
            IF txpks_#1101.fn_txrevert(p_txnum, p_txdate, p_err_code, l_err_param) <> systemnums.c_success
            THEN
               plog.debug (pkgctx,
                           'got error 1101 revert: ' || p_err_code
               );
               ROLLBACK;
               p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
               plog.error(pkgctx, 'Error:'  || p_err_message);
               plog.setendsection(pkgctx, 'pr_RevertTransfer');
               RETURN;
            END IF;
        END IF;
    END;
    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_RevertTransfer');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_RevertTransfer');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_RevertTransfer');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_RevertTransfer;

---------------------------------pr_AllocateGuaranteeT0------------------------------------------------
  PROCEDURE pr_AllocateGuaranteeT0(
                                P_USERID        VARCHAR2,
                                P_USERTYPE        VARCHAR2,
                                P_ACCTNO        VARCHAR2,
                                P_TOAMT        VARCHAR2,
                                P_ACCLIMIT        VARCHAR2,
                                P_RLIMIT        VARCHAR2,
                                P_ACCUSED        VARCHAR2,
                                P_DEAL              VARCHAR2, -- 1.5.8.9|iss:2046
                                P_CUSTAVLLIMIT        VARCHAR2,
                                P_MARGINRATE        VARCHAR2,
                                P_SETOTAL        VARCHAR2,
                                P_TOTALLOAN        VARCHAR2,
                                P_PP        VARCHAR2,
                                P_PERIOD        VARCHAR2,
                                P_T0AMTUSED        VARCHAR2,
                                P_T0AMTPENDING        VARCHAR2,
                                P_SYMBOLAMT        VARCHAR2,
                                P_SOURCE        VARCHAR2,
                                P_TLID        VARCHAR2,
                                P_DESC        VARCHAR2,
                                P_T0CAL        VARCHAR2,
                                P_ADVANCELINE        VARCHAR2,
                                P_T0OVRQ        VARCHAR2,
                                P_T0DEB        VARCHAR2,
                                P_CONTRACTCHK        VARCHAR2,
                                P_CUSTODYCD        VARCHAR2,
                                P_MARGINRATE_T0        VARCHAR2,
                                P_FULLNAME        VARCHAR2,
                                P_TLFULLNAME        VARCHAR2,
                                P_TLIDNAME        VARCHAR2,
                                P_TLGROUP           VARCHAR2,
                            p_err_code  OUT varchar2,
                            p_err_message out varchar2)


  IS
      l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      l_err_param varchar2(300);
      V_RLIMIT NUMBER;
      v_count number;
      v_maxt0OVRQ number;
      v_brid VARCHAR2(4);
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_AllocateGuaranteeT0');

    -- Check host & branch active or inactive
    p_err_code := fn_CheckActiveSystem;
    IF p_err_code <> systemnums.C_SUCCESS THEN
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_AllocateGuaranteeT0');
        return;
    END IF;

    --Check 10 > 0
    IF to_number(P_TOAMT) <= 0 THEN
        p_err_code:=-100157;--ERR_SA_INVALID_SECSSION
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_AllocateGuaranteeT0');
        return;
    END IF;
    --Check 22 > 0
    IF to_number(P_T0AMTUSED) <= 0 THEN
        p_err_code:=-100158;--ERR_SA_INVALID_SECSSION
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_AllocateGuaranteeT0');
        return;
    END IF;
    --Check 10 >= 16 Han muc BL cua KH
    IF to_number(P_TOAMT) > to_number(P_CUSTAVLLIMIT) THEN
        p_err_code:=-180032;--ERR_SA_INVALID_SECSSION
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_AllocateGuaranteeT0');
        return;
    END IF;

    --Check 10 >= 12 Han muc BL cua User
    IF to_number(P_TOAMT) > to_number(P_RLIMIT) THEN
        p_err_code:=-100155;--ERR_SA_INVALID_SECSSION
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_AllocateGuaranteeT0');
        return;
    END IF;

    SELECT TO_DATE (varvalue, systemnums.c_date_format)
               INTO v_strCURRDATE
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := systemnums.C_ONLINE_USERID;
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := 'DAY';
    l_txmsg.txdate      :=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate     :=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd      :='1816';

    --Set txnum
    SELECT systemnums.C_OL_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO l_txmsg.txnum
              FROM DUAL;
   SELECT brid INTO v_brid FROM tlprofiles WHERE tlid =substr(P_USERID,1,4);
    l_txmsg.brid        := v_brid;

    --Set cac field giao dich
      l_txmsg.txfields ('01').defname   := 'USERID';
       l_txmsg.txfields ('01').TYPE   := 'C';
        l_txmsg.txfields ('01').VALUE   := P_USERID;

      l_txmsg.txfields ('02').defname   := 'USERTYPE';
       l_txmsg.txfields ('02').TYPE   := 'C';
        l_txmsg.txfields ('02').VALUE   := P_USERTYPE;

      l_txmsg.txfields ('03').defname   := 'ACCTNO';
       l_txmsg.txfields ('03').TYPE   := 'C';
        l_txmsg.txfields ('03').VALUE   := P_ACCTNO;

      l_txmsg.txfields ('10').defname   := 'TOAMT';
       l_txmsg.txfields ('10').TYPE   := 'N';
        l_txmsg.txfields ('10').VALUE   := P_TOAMT;

      l_txmsg.txfields ('11').defname   := 'ACCLIMIT';
       l_txmsg.txfields ('11').TYPE   := 'N';
        l_txmsg.txfields ('11').VALUE   := P_ACCLIMIT;

      l_txmsg.txfields ('12').defname   := 'RLIMIT';
       l_txmsg.txfields ('12').TYPE   := 'N';
        l_txmsg.txfields ('12').VALUE   := P_RLIMIT;

      l_txmsg.txfields ('13').defname   := 'ACCUSED';
       l_txmsg.txfields ('13').TYPE   := 'N';
        l_txmsg.txfields ('13').VALUE   := P_ACCUSED;

      l_txmsg.txfields ('16').defname   := 'CUSTAVLLIMIT';
       l_txmsg.txfields ('16').TYPE   := 'N';
        l_txmsg.txfields ('16').VALUE   := P_CUSTAVLLIMIT;

      l_txmsg.txfields ('17').defname   := 'MARGINRATE';
       l_txmsg.txfields ('17').TYPE   := 'N';
        l_txmsg.txfields ('17').VALUE   := P_MARGINRATE;

      l_txmsg.txfields ('18').defname   := 'SETOTAL';
       l_txmsg.txfields ('18').TYPE   := 'N';
        l_txmsg.txfields ('18').VALUE   := P_SETOTAL;

      l_txmsg.txfields ('19').defname   := 'TOTALLOAN';
       l_txmsg.txfields ('19').TYPE   := 'N';
        l_txmsg.txfields ('19').VALUE   := P_TOTALLOAN;

      l_txmsg.txfields ('20').defname   := 'PP';
       l_txmsg.txfields ('20').TYPE   := 'N';
        l_txmsg.txfields ('20').VALUE   := P_PP;

      l_txmsg.txfields ('21').defname   := 'PERIOD';
       l_txmsg.txfields ('21').TYPE   := 'N';
        l_txmsg.txfields ('21').VALUE   := P_PERIOD;

      l_txmsg.txfields ('22').defname   := 'T0AMTUSED';
       l_txmsg.txfields ('22').TYPE   := 'N';
        l_txmsg.txfields ('22').VALUE   := P_T0AMTUSED;

      l_txmsg.txfields ('23').defname   := 'T0AMTPENDING';
       l_txmsg.txfields ('23').TYPE   := 'N';
        l_txmsg.txfields ('23').VALUE   := P_T0AMTPENDING;

      l_txmsg.txfields ('24').defname   := 'SYMBOLAMT';
       l_txmsg.txfields ('24').TYPE   := 'C';
        l_txmsg.txfields ('24').VALUE   := P_SYMBOLAMT;

      l_txmsg.txfields ('93').defname   := 'TLGROUP';
       l_txmsg.txfields ('93').TYPE   := 'C';
        l_txmsg.txfields ('93').VALUE   := P_TLGROUP;

      l_txmsg.txfields ('25').defname   := 'SOURCE';
       l_txmsg.txfields ('25').TYPE   := 'C';
        l_txmsg.txfields ('25').VALUE   := P_SOURCE;

      l_txmsg.txfields ('26').defname   := 'TLID';
       l_txmsg.txfields ('26').TYPE   := 'C';
        l_txmsg.txfields ('26').VALUE   := P_TLID;

      l_txmsg.txfields ('30').defname   := 'DESC';
       l_txmsg.txfields ('30').TYPE   := 'C';
        l_txmsg.txfields ('30').VALUE   := fn_gen_desc_1816(P_DESC, P_ACCTNO, P_T0AMTUSED);

      l_txmsg.txfields ('40').defname   := 'T0CAL';
       l_txmsg.txfields ('40').TYPE   := 'N';
        l_txmsg.txfields ('40').VALUE   := P_T0CAL;

      l_txmsg.txfields ('41').defname   := 'ADVANCELINE';
       l_txmsg.txfields ('41').TYPE   := 'N';
        l_txmsg.txfields ('41').VALUE   := P_ADVANCELINE;

      l_txmsg.txfields ('42').defname   := 'T0OVRQ';
       l_txmsg.txfields ('42').TYPE   := 'N';
        l_txmsg.txfields ('42').VALUE   := P_T0OVRQ;

      l_txmsg.txfields ('43').defname   := 'T0DEB';
       l_txmsg.txfields ('43').TYPE   := 'N';
        l_txmsg.txfields ('43').VALUE   := P_T0DEB;

      l_txmsg.txfields ('44').defname   := 'NAVNO';
       l_txmsg.txfields ('44').TYPE   := 'N';
        l_txmsg.txfields ('44').VALUE   := fn_get_nav_no(P_CUSTODYCD,P_ACCTNO);

      l_txmsg.txfields ('86').defname   := 'CONTRACTCHK';
       l_txmsg.txfields ('86').TYPE   := 'C';
        l_txmsg.txfields ('86').VALUE   := P_CONTRACTCHK;

      l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
       l_txmsg.txfields ('88').TYPE   := 'C';
        l_txmsg.txfields ('88').VALUE   := P_CUSTODYCD;

      l_txmsg.txfields ('89').defname   := 'MARGINRATE_T0';
       l_txmsg.txfields ('89').TYPE   := 'N';
        l_txmsg.txfields ('89').VALUE   := P_MARGINRATE_T0;

      l_txmsg.txfields ('90').defname   := 'FULLNAME';
       l_txmsg.txfields ('90').TYPE   := 'C';
        l_txmsg.txfields ('90').VALUE   := P_FULLNAME;

      l_txmsg.txfields ('91').defname   := 'TLFULLNAME';
       l_txmsg.txfields ('91').TYPE   := 'C';
        l_txmsg.txfields ('91').VALUE   := P_TLFULLNAME;

      l_txmsg.txfields ('92').defname   := 'TLIDNAME';
       l_txmsg.txfields ('92').TYPE   := 'C';
        l_txmsg.txfields ('92').VALUE   := P_TLIDNAME;

    -- 1.5.8.9|iss:2046
    l_txmsg.txfields ('47').defname   := 'DEAL';
       l_txmsg.txfields ('47').TYPE   := 'C';
        l_txmsg.txfields ('47').VALUE   := P_DEAL;


    BEGIN
        IF txpks_#1816.fn_autotxprocess (l_txmsg,
                                         p_err_code,
                                         l_err_param
           ) <> systemnums.c_success
        THEN
           plog.debug (pkgctx,
                       'got error 1816: ' || p_err_code
           );
           ROLLBACK;
           p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
           plog.error(pkgctx, 'Error:'  || p_err_message);
           plog.setendsection(pkgctx, 'pr_AllocateGuaranteeT0');
           RETURN;
        END IF;
    END;
    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_AllocateGuaranteeT0');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_AllocateGuaranteeT0');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_AllocateGuaranteeT0');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_AllocateGuaranteeT0;

---------------------------------pr_ReleaseGuaranteeT0------------------------------------------------
  PROCEDURE pr_ReleaseGuaranteeT0(
                            P_USERID        varchar2,
                            P_ACCTNO     VARCHAR2,
                            P_ADVT0AMT      VARCHAR2,
                            P_ADVT0AMTMAX   VARCHAR2,
                            P_ADVAMTHIST     VARCHAR2,
                            P_ADVAMTHISTMAX      VARCHAR2,
                            P_DESC          varchar2,
                            --P_DEAL          VARCHAR2,
                            p_err_code  OUT varchar2,
                            p_err_message out varchar2)

  IS
      l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      l_err_param varchar2(300);
      V_RLIMIT NUMBER;
      v_count number;
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_ReleaseGuaranteeT0');

    -- Check host & branch active or inactive
    p_err_code := fn_CheckActiveSystem;
    IF p_err_code <> systemnums.C_SUCCESS THEN
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_ReleaseGuaranteeT0');
        return;
    END IF;
    --check trang thai tieu khoan
    select count(1) into v_count from afmast where acctno = P_ACCTNO and status in ('A','N','T');
    if v_count < 1 then
        p_err_code:= -200010;
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_ReleaseGuaranteeT0');
    end if;


    SELECT TO_DATE (varvalue, systemnums.c_date_format)
               INTO v_strCURRDATE
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    --l_txmsg.tlid        := systemnums.C_ONLINE_USERID;
    l_txmsg.tlid        := P_USERID;
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := 'DAY';
    l_txmsg.txdate      :=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate     :=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd      :='1811';

    --Set txnum
    SELECT systemnums.C_OL_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO l_txmsg.txnum
              FROM DUAL;
    l_txmsg.brid        := substr(P_ACCTNO,1,4);

/*
01  1811    USERID      M?gu?i s? d?ng            UserID                      0   C
03  1811    ACCTNO      S? Ti?u kho?n               Acctno                      0   C
08  1811    ADVT0AMT    Thu h?i b?o l? T0         Release guarantee T0        1   N
09  1811    ADVT0AMT    Thu h?i BL T0 t?i da        Release guarantee T0 max    2   N
10  1811    ADVAMTHIST  Thu h?i BL qu?h?          Release guarantee T0        4   N
11  1811    ADVAMTHIST  Thu h?i BL qu?h? t?i da   Release guarantee T0 max    3   N
30  1811    DESC        Di?n gi?i                   Description                 10  C
*/

    --Set cac field giao dich
--01  CUSTODYCD
    l_txmsg.txfields ('01').defname   := 'USERID';
    l_txmsg.txfields ('01').TYPE      := 'C';
    l_txmsg.txfields ('01').VALUE     := P_USERID;
--03  ACCTNO
    l_txmsg.txfields ('03').defname   := 'ACCTNO';
    l_txmsg.txfields ('03').TYPE      := 'C';
    l_txmsg.txfields ('03').VALUE     := P_ACCTNO;
--08  ADVT0AMT
    l_txmsg.txfields ('08').defname   := 'ADVT0AMT';
    l_txmsg.txfields ('08').TYPE      := 'N';
    l_txmsg.txfields ('08').VALUE     := P_ADVT0AMT;
--09  ADVT0AMTMAX
    l_txmsg.txfields ('09').defname   := 'ADVT0AMT';
    l_txmsg.txfields ('09').TYPE      := 'N';
    l_txmsg.txfields ('09').VALUE     := P_ADVT0AMTMAX;
--10  ADVAMTHIST
    l_txmsg.txfields ('10').defname   := 'ADVAMTHIST';
    l_txmsg.txfields ('10').TYPE      := 'N';
    l_txmsg.txfields ('10').VALUE     := P_ADVAMTHIST;
--11  ADVAMTHISTMAX
    l_txmsg.txfields ('11').defname   := 'ADVAMTHIST';
    l_txmsg.txfields ('11').TYPE      := 'N';
    l_txmsg.txfields ('11').VALUE     := P_ADVAMTHISTMAX;
--47  DEAL
    l_txmsg.txfields ('47').defname   := 'DEAL';
    l_txmsg.txfields ('47').TYPE      := 'C';
    l_txmsg.txfields ('47').VALUE     := '';
--30  DESC
    l_txmsg.txfields ('30').defname   := 'DESC';
    l_txmsg.txfields ('30').TYPE      := 'C';
    --l_txmsg.txfields ('30').VALUE     := UTF8NUMS.c_const_TXDESC_1101_OL || '/ ' || v_fullname || '/ ' || v_custodycd;
    l_txmsg.txfields ('30').VALUE     := P_DESC || ' TK: ' || P_ACCTNO || '/ BL T0: ' || P_ADVT0AMT || '/BL T0 QK: ' || P_ADVAMTHIST ;

    BEGIN
        IF txpks_#1811.fn_autotxprocess (l_txmsg,
                                         p_err_code,
                                         l_err_param
           ) <> systemnums.c_success
        THEN
           plog.debug (pkgctx,
                       'got error 1811: ' || p_err_code
           );
           ROLLBACK;
           p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
           plog.error(pkgctx, 'Error:'  || p_err_message);
           plog.setendsection(pkgctx, 'pr_ReleaseGuaranteeT0');
           RETURN;
        END IF;
    END;
    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_ReleaseGuaranteeT0');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_ReleaseGuaranteeT0');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_ReleaseGuaranteeT0');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_ReleaseGuaranteeT0;

---------------------------------pr_RightoffRegiter------------------------------------------------
PROCEDURE pr_RightoffRegiter
    (p_camastid IN   varchar,
    p_account   IN   varchar,
    p_qtty      IN   number,
    p_desc      IN   varchar2,
    p_err_code  OUT varchar2,
    p_err_message  OUT varchar2,
    p_ipaddress in  varchar2 default '' , --1.5.3.0
    p_via in varchar2 default '',
    p_validationtype in varchar2 default '',
    p_devicetype IN varchar2 default '',
    p_device  IN varchar2 default ''
    )
    IS
        l_exprice number;
        l_iscorebank  varchar(1);
        l_maxqtty NUMBER;
        l_camastid      varchar2(50);
        l_RGAmount  NUMBER;
        l_REQUESTID varchar2(50);
        l_RQLogAutoID   NUMBER;
        l_txnum         varchar(50);
        l_txdate        date;

    BEGIN
        plog.debug(pkgctx, 'pr_RightoffRegiter');
        -- Check host & branch active or inactive
        p_err_code := fn_CheckActiveSystem;
        IF p_err_code <> systemnums.C_SUCCESS THEN
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_RightoffRegiter');
            return;
        END IF;
        -- End: Check host & branch active or inactive

        -- Lay thong tin tieu khoan va dot thuc hien quyen
        SELECT A.exprice, A.pqtty - NVL(RQ.MSGQTTY,0), A.corebank, A.camastid
        INTO  l_exprice, l_maxqtty, l_iscorebank, l_camastid
        FROM
            (select CA.AFACCTNO, CA.camastid,a.exprice,ca.pqtty,af.corebank
                from camast a, caschd ca, afmast af
                where ca.camastid=a.camastid
                    AND af.acctno = ca.afacctno
                    and ca.afacctno=p_account
                    AND ca.camastid||to_char(ca.autoid) = p_camastid
            ) A
            LEFT JOIN
            (
                SELECT msgacct, keyvalue, sum(NVL(MSGQTTY,0)) MSGQTTY FROM borqslog
                WHERE RQSTYP = 'CAR' AND STATUS IN ('W','P','H') AND KEYVALUE = p_camastid
                GROUP BY msgacct, keyvalue
            ) RQ
            ON A.camastid = RQ.keyvalue AND A.afacctno = RQ.msgacct ;

        --plog.debug(pkgctx, 'l_maxqtty:'  || l_maxqtty);
        -- Kiem tra so luong dang ky quyen mua co vuot qua so dang ky toi da hay ko
        IF l_maxqtty < p_qtty THEN
            p_err_code := -300021; -- Vuot qua so CK duoc phep mua
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_RightoffRegiter');
            return;
        END IF;

        l_RGAmount := p_qtty * l_exprice;

        -- GHI NHAN VAO BANG BORQSLOG DE XU LY
        SELECT 'CAR' || replace(replace(replace(to_char(SYSDATE,'RRRR-MM-DD HH24:MI:SS'),'-',''),':',''),' ','') INTO l_REQUESTID FROM dual;
        SELECT SEQ_BORQSLOG.NEXTVAL INTO l_RQLogAutoID FROM dual;
        INSERT INTO BORQSLOG (AUTOID, CREATEDDT, RQSSRC, RQSTYP, REQUESTID, STATUS, TXDATE,
            TXNUM, ERRNUM, ERRMSG,MSGACCT,MSGAMT,DESCRIPTION,KEYVALUE,MSGQTTY)
        SELECT l_RQLogAutoID, SYSDATE, 'ONL' RQSSRC, 'CAR' RQSTYP, l_REQUESTID REQUESTID, decode(l_iscorebank,'Y','W','P') STATUS, getcurrdate TXDATE,
            '' TXNUM, 0 ERRNUM, '' ERRMSG, p_account  MSGACCT, l_RGAmount MSGAMT, p_desc, p_camastid, p_qtty
        FROM DUAL;

        COMMIT;

        -- Neu ko ket noi NH thi thuc hien GD dang ky quyen mua ngay
        IF l_iscorebank = 'N' THEN
            pr_ROR2BO(l_RQLogAutoID, p_err_code, p_err_message);
            IF p_err_code <> systemnums.C_SUCCESS THEN
                plog.error(pkgctx, 'Error:'  || p_err_message);
                plog.setendsection(pkgctx, 'pr_RightoffRegiter');
                return;
            END IF;
        END IF;

        p_err_code:=systemnums.C_SUCCESS;
        -- begin 1.5.3.0
        begin
          select txnum, txdate
          into l_txnum, l_txdate
          from BORQSLOG where AUTOID =l_RQLogAutoID;

          pr_insertiplog( l_txnum,  l_txdate, p_ipaddress, p_via, p_validationtype, p_devicetype, p_device, p_err_code);

         exception
         when others then
           plog.debug (pkgctx,'Update TLLO Failse');
        end;
        --end 1.5.3.0
        plog.setendsection(pkgctx, 'pr_RightoffRegiter');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_RightoffRegiter');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM||'p_camastid @'||p_camastid||  'p_account   @'||p_account||   'p_qtty @'|| p_qtty );
      plog.setendsection (pkgctx, 'pr_RightoffRegiter');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_RightoffRegiter;


PROCEDURE pr_RORSyn2BO
    IS
        v_err_code      NUMBER;
        v_err_message   varchar2(2000);
        v_txnum         varchar2(50);

    BEGIN
        plog.setbeginsection(pkgctx, 'pr_RORSyn2BO');
        v_err_code := 0;

       -- Lay len danh sach cac lenh dang ky quyen mua da thuc hien hold du tien de thuc hien GD 3384
        FOR rec IN
        (
            SELECT RQ.AUTOID, RQ.MSGACCT,RQ.MSGAMT,RQ.DESCRIPTION,RQ.KEYVALUE,RQ.MSGQTTY
            FROM borqslog RQ
            WHERE RQ.STATUS IN ('P','H') AND RQ.RQSTYP = 'CAR'
            ORDER BY RQ.AUTOID
        )
        LOOP
            --1.5.3.0
            pr_RightoffRegiter2BO(rec.KEYVALUE, rec.MSGACCT, rec.MSGQTTY, rec.DESCRIPTION,v_txnum, v_err_code, v_err_message);
            IF v_err_code = systemnums.C_SUCCESS THEN
                -- CAP NHAT TRANG THAI TRONG BORQSLOG
                UPDATE borqslog SET
                    STATUS = 'A', txnum = v_txnum --1.5.3.0: log txnum
                WHERE AUTOID = rec.AUTOID;
                COMMIT;
            ELSE
                plog.error(pkgctx, 'Error: '  || v_err_code || v_err_message);
                plog.setendsection(pkgctx, 'pr_RORSyn2BO');
            END IF;
        END LOOP;
        plog.setendsection(pkgctx, 'pr_RORSyn2BO');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_RORSyn2BO');
      ROLLBACK;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_RORSyn2BO');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_RORSyn2BO;


PROCEDURE pr_RORSynBank2BO
    (
    p_RQLogID   IN   NUMBER
    )
    IS
        v_err_code      NUMBER;
        v_err_message   varchar2(2000);
        v_afacctno      varchar2(10);
        v_amount        NUMBER;
        v_desc          varchar2(2000);
        v_camastid      varchar2(50);
        v_qtty          NUMBER;
        v_txnum         varchar2(50);

    BEGIN
        plog.setbeginsection(pkgctx, 'pr_RORSynBank2BO');
        v_err_code := 0;

        plog.debug(pkgctx, 'BEGIN pr_RORSynBank2BO');
        plog.debug(pkgctx, 'p_RQLogID: ' || p_RQLogID);

        -- Lay len danh sach cac lenh dang ky quyen mua da thuc hien hold du tien de thuc hien GD 3384

        SELECT RQ.MSGACCT,RQ.MSGAMT,RQ.DESCRIPTION,RQ.KEYVALUE,RQ.MSGQTTY
        INTO v_afacctno, v_amount, v_desc, v_camastid, v_qtty
        FROM borqslog RQ
        WHERE RQ.STATUS = 'W' AND RQ.RQSTYP = 'CAR' AND RQ.AUTOID = p_RQLogID;

        plog.debug(pkgctx, v_afacctno || ' | ' || v_amount|| ' | ' || v_desc || ' | ' || v_camastid || ' | ' || v_qtty);
        --1.5.3.0
        pr_RightoffRegiter2BO(v_camastid, v_afacctno, v_qtty, v_desc,v_txnum, v_err_code, v_err_message);
        IF v_err_code = systemnums.C_SUCCESS THEN
            -- CAP NHAT TRANG THAI TRONG BORQSLOG
            UPDATE borqslog SET
                STATUS = 'A', txnum = v_txnum --1.5.3.0: log txnum
            WHERE AUTOID = p_RQLogID;
            COMMIT;
        ELSE
            -- CAP NHAT TRANG THAI TRONG BORQSLOG
            UPDATE borqslog SET
                STATUS = 'R'
            WHERE AUTOID = p_RQLogID;
            COMMIT;
            plog.error(pkgctx, 'Error: '  || v_err_code || v_err_message);
            plog.setendsection(pkgctx, 'pr_RORSynBank2BO');
        END IF;
        plog.setendsection(pkgctx, 'pr_RORSynBank2BO');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_RORSynBank2BO');
      ROLLBACK;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_RORSynBank2BO');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_RORSynBank2BO;

PROCEDURE pr_ROR2BO
    (
    p_RQLogID   IN   NUMBER,
    p_err_code  OUT  NUMBER,
    p_err_message   OUT  varchar2
    )
    IS
        v_afacctno      varchar2(10);
        v_amount        NUMBER;
        v_desc          varchar2(2000);
        v_camastid      varchar2(50);
        v_qtty          NUMBER;
        v_txnum         varchar2(50);

    BEGIN
        plog.setbeginsection(pkgctx, 'pr_ROR2BO');
        p_err_code := 0;

        plog.debug(pkgctx, 'BEGIN pr_ROR2BO');
        plog.debug(pkgctx, 'p_RQLogID: ' || p_RQLogID);

        -- Lay len danh sach cac lenh dang ky quyen mua da thuc hien hold du tien de thuc hien GD 3384

        SELECT RQ.MSGACCT,RQ.MSGAMT,RQ.DESCRIPTION,RQ.KEYVALUE,RQ.MSGQTTY
        INTO v_afacctno, v_amount, v_desc, v_camastid, v_qtty
        FROM borqslog RQ
        WHERE RQ.STATUS = 'P' AND RQ.RQSTYP = 'CAR' AND RQ.AUTOID = p_RQLogID;

        plog.debug(pkgctx, v_afacctno || ' | ' || v_amount|| ' | ' || v_desc || ' | ' || v_camastid || ' | ' || v_qtty);
        --1.5.3.0
        pr_RightoffRegiter2BO(v_camastid, v_afacctno, v_qtty, v_desc,v_txnum, p_err_code, p_err_message);
        IF p_err_code = systemnums.C_SUCCESS THEN
            -- CAP NHAT TRANG THAI TRONG BORQSLOG
            UPDATE borqslog SET
                STATUS = 'A', txnum = v_txnum --1.5.3.0: log txnum
            WHERE AUTOID = p_RQLogID;
            COMMIT;
        ELSE
            -- CAP NHAT TRANG THAI TRONG BORQSLOG
            UPDATE borqslog SET
                STATUS = 'R'
            WHERE AUTOID = p_RQLogID;
            COMMIT;
            plog.error(pkgctx, 'Error: '  || p_err_code || p_err_message);
            plog.setendsection(pkgctx, 'pr_ROR2BO');
        END IF;
        plog.setendsection(pkgctx, 'pr_ROR2BO');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.error (pkgctx,'got error on pr_ROR2BO v_camastid: '||v_camastid||'v_afacctno: '||v_afacctno||'v_qtty: '||v_qtty);
      ROLLBACK;
      plog.error (pkgctx, SQLERRM ||'v_camastid: '||v_camastid||'v_afacctno: '||v_afacctno||'v_qtty: '||v_qtty);
      plog.setendsection (pkgctx, 'pr_ROR2BO');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_ROR2BO;



PROCEDURE pr_RightoffRegiter2BO
    (p_camastid IN   varchar,
    p_account   IN   varchar,
    p_qtty      IN   number,
    p_desc      IN   varchar2,
    p_txnum     OUT  VARCHAR2, --1.5.3.0
    p_err_code  OUT varchar2,
    p_err_message  OUT varchar2
    )
  IS
      l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      l_err_param varchar2(300);
      l_symbol  varchar2(20);
      l_tocodeid   varchar2(20);
      l_exprice number;
      l_optcodeid varchar2(20);
      l_iscorebank  number;
      l_bankacctno varchar2(100);
      l_bankname varchar2(100);
      l_balance number;
      l_caschdautoid NUMBER;
      l_maxqtty NUMBER;
      l_parvalue NUMBER;
      l_cashbalance NUMBER;
      l_sebalance   NUMBER;
      l_exrate varchar2(50);
      l_fullname    varchar2(100);
      l_idcode      varchar2(20);
      l_iddate      varchar2(20);
      l_idplace     varchar2(200);
      l_reportdate  varchar2(20);
      l_custodycd   varchar2(10);
      l_phone       varchar2(50);
      l_camastid    VARCHAR2(100);
      l_acctno_update_costrice varchar2(100);
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_RightoffRegiter2BO');

    -- Check host & branch active or inactive
    p_err_code := fn_CheckActiveSystem;
    IF p_err_code <> systemnums.C_SUCCESS THEN
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_RightoffRegiter2BO');
        return;
    END IF;
    -- End: Check host & branch active or inactive

    SELECT TO_DATE (varvalue, systemnums.c_date_format)
               INTO v_strCURRDATE
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := systemnums.C_ONLINE_USERID;
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := 'DAY';
    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd:='3384';

    --Set txnum
    SELECT systemnums.C_OL_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO l_txmsg.txnum
              FROM DUAL;
    l_txmsg.brid        := substr(p_account,1,4);

    --p_txnum:=l_txmsg.txnum;
    --p_txdate:=l_txmsg.txdate;

    select ca.autoid, b.SYMBOL,a.exprice,decode(a.iswft,'Y',nvl(b2.codeid,'000000'),nvl(a.tocodeid,a.codeid)) codeid,optcodeid,CA.balance + CA.pbalance balance, ca.pqtty,a.parvalue,
        (case when ci.corebank ='Y' then 0 else 1 end) iscorebank,af.bankacctno,af.bankname, ci.balance, ca.trade, cf.fullname, cf.idcode,
        to_char(cf.iddate,'DD/MM/YYYY') iddate, cf.idplace, to_char(a.reportdate,'DD/MM/YYYY') reportdate,
        cf.custodycd, cf.phone , a.exrate, ca.camastid, ca.afacctno||nvl(a.tocodeid,a.codeid) acctno_update_costrice
    into l_caschdautoid,l_symbol,l_exprice , l_tocodeid,l_optcodeid,l_balance,l_maxqtty, l_parvalue,l_iscorebank,
      l_bankacctno,l_bankname,
        l_cashbalance, l_sebalance, l_fullname, l_idcode , l_iddate, l_idplace, l_reportdate, l_custodycd, l_phone, l_exrate, l_camastid, l_acctno_update_costrice
    from camast a, caschd ca, sbsecurities b,cimast ci, cfmast cf, afmast af, sbsecurities b2
    where a.tocodeid = b.codeid and a.camastid||to_char(ca.autoid)=p_camastid and ca.camastid=a.camastid
        AND cf.custid = af.custid AND af.acctno = ca.afacctno
        and ca.afacctno=p_account
        and ci.acctno=ca.afacctno
        and nvl(a.tocodeid,a.codeid) = b2.refcodeid (+);

    --Set cac field giao dich
    --01   AUTOID      C
    l_txmsg.txfields ('01').defname   := 'AUTOID';
    l_txmsg.txfields ('01').TYPE      := 'C';
    l_txmsg.txfields ('01').VALUE     := to_char(nvl(l_caschdautoid,''));
    --02   CAMASTID      C
    l_txmsg.txfields ('02').defname   := 'CAMASTID';
    l_txmsg.txfields ('02').TYPE      := 'C';
    l_txmsg.txfields ('02').VALUE     := l_camastid;
    --03   AFACCTNO      C
    l_txmsg.txfields ('03').defname   := 'AFACCTNO';
    l_txmsg.txfields ('03').TYPE      := 'C';
    l_txmsg.txfields ('03').VALUE     := p_account;
    --04   SYMBOL        C
    l_txmsg.txfields ('04').defname   := 'SYMBOL';
    l_txmsg.txfields ('04').TYPE      := 'C';
    l_txmsg.txfields ('04').VALUE     := l_symbol;
    --05   EXPRICE       N
    l_txmsg.txfields ('05').defname   := 'EXPRICE';
    l_txmsg.txfields ('05').TYPE      := 'N';
    l_txmsg.txfields ('05').VALUE     := l_exprice;
    --06   SEACCTNO      C
    l_txmsg.txfields ('06').defname   := 'SEACCTNO';
    l_txmsg.txfields ('06').TYPE      := 'C';
    l_txmsg.txfields ('06').VALUE     := p_account || l_tocodeid;
    --07   SE BALANCE       N
    l_txmsg.txfields ('07').defname   := 'BALANCE';
    l_txmsg.txfields ('07').TYPE      := 'N';
    l_txmsg.txfields ('07').VALUE     := l_sebalance;
    --08   FULLNAME      C
    l_txmsg.txfields ('08').defname   := 'FULLNAME';
    l_txmsg.txfields ('08').TYPE      := 'C';
    l_txmsg.txfields ('08').VALUE     := l_fullname;
    --09   OPTSEACCTNO   C
    l_txmsg.txfields ('09').defname   := 'OPTSEACCTNO';
    l_txmsg.txfields ('09').TYPE      := 'C';
    l_txmsg.txfields ('09').VALUE     := p_account || l_optcodeid;
    --10   AMT          N
    l_txmsg.txfields ('10').defname   := 'AMT';
    l_txmsg.txfields ('10').TYPE      := 'N';
    l_txmsg.txfields ('10').VALUE     := round(nvl(p_qtty,0) * nvl(l_exprice,0),0);
    --11   CI BALANCE          N
    l_txmsg.txfields ('11').defname   := 'CIBALANCE';
    l_txmsg.txfields ('11').TYPE      := 'N';
    l_txmsg.txfields ('11').VALUE     := l_cashbalance;
    --12   CI BALANCE          N
    l_txmsg.txfields ('12').defname   := 'BALANCE';
    l_txmsg.txfields ('12').TYPE      := 'N';
    l_txmsg.txfields ('12').VALUE     := l_cashbalance;
    --16   TASKCD        C
    l_txmsg.txfields ('16').defname   := 'TASKCD';
    l_txmsg.txfields ('16').TYPE      := 'C';
    l_txmsg.txfields ('16').VALUE     := '';
    --20   MAXQTTY          N
    l_txmsg.txfields ('20').defname   := 'MAXQTTY';
    l_txmsg.txfields ('20').TYPE      := 'N';
    l_txmsg.txfields ('20').VALUE     := l_maxqtty;
    --21   QTTY          N
    l_txmsg.txfields ('21').defname   := 'QTTY';
    l_txmsg.txfields ('21').TYPE      := 'N';
    l_txmsg.txfields ('21').VALUE     := p_qtty;
    --22   PARVALUE          N
    l_txmsg.txfields ('22').defname   := 'PARVALUE';
    l_txmsg.txfields ('22').TYPE      := 'N';
    l_txmsg.txfields ('22').VALUE     := l_parvalue;
    --23   REPORTDATE          N
    l_txmsg.txfields ('23').defname   := 'REPORTDATE';
    l_txmsg.txfields ('23').TYPE      := 'C';
    l_txmsg.txfields ('23').VALUE     := l_reportdate;
    --24   CODEID          C
    l_txmsg.txfields ('24').defname   := 'CODEID';
    l_txmsg.txfields ('24').TYPE      := 'C';
    l_txmsg.txfields ('24').VALUE     := l_tocodeid;
    --25   UPDATE_COSTPRICE          C
    l_txmsg.txfields ('25').defname   := 'ACCTNO_UPDATECOST';
    l_txmsg.txfields ('25').TYPE      := 'C';
    l_txmsg.txfields ('25').VALUE     := l_acctno_update_costrice;
    --30   DESCRIPTION   C
    l_txmsg.txfields ('30').defname   := 'DESCRIPTION';
    l_txmsg.txfields ('30').TYPE      := 'C';
    l_txmsg.txfields ('30').VALUE     := p_desc;
    --40   STATUS        C
    l_txmsg.txfields ('40').defname   := 'STATUS';
    l_txmsg.txfields ('40').TYPE      := 'C';
    l_txmsg.txfields ('40').VALUE     := 'M';
    --60   ISCOREBANK        N
    l_txmsg.txfields ('60').defname   := 'ISCOREBANK';
    l_txmsg.txfields ('60').TYPE      := 'N';
    l_txmsg.txfields ('60').VALUE     := l_iscorebank;
    --61   BANKACCTNO        C
    l_txmsg.txfields ('61').defname   := 'BANKACCTNO';
    l_txmsg.txfields ('61').TYPE      := 'C';
    l_txmsg.txfields ('61').VALUE     := l_bankacctno;
    --62   BANKNAME        C
    l_txmsg.txfields ('62').defname   := 'BANKNAME';
    l_txmsg.txfields ('62').TYPE      := 'C';
    l_txmsg.txfields ('62').VALUE     := l_bankname;
    --70   PHONE    C
    l_txmsg.txfields ('70').defname   := 'PHONE';
    l_txmsg.txfields ('70').TYPE      := 'C';
    l_txmsg.txfields ('70').VALUE     := l_phone;
    --71   SYMBOL_ORG    C
    l_txmsg.txfields ('71').defname   := 'SYMBOL_ORG';
    l_txmsg.txfields ('71').TYPE      := 'C';
    l_txmsg.txfields ('71').VALUE     := l_optcodeid;
    --90   CUSTNAME    C
    l_txmsg.txfields ('90').defname   := 'CUSTNAME';
    l_txmsg.txfields ('90').TYPE      := 'C';
    l_txmsg.txfields ('90').VALUE     := l_fullname;
    --91   ADDRESS     C
    l_txmsg.txfields ('91').defname   := 'ADDRESS';
    l_txmsg.txfields ('91').TYPE      := 'C';
    l_txmsg.txfields ('91').VALUE     := '';
    --92   LICENSE     C
    l_txmsg.txfields ('92').defname   := 'LICENSE';
    l_txmsg.txfields ('92').TYPE      := 'C';
    l_txmsg.txfields ('92').VALUE     := l_idcode;
    --93   IDDATE    C
    l_txmsg.txfields ('93').defname   := 'IDDATE';
    l_txmsg.txfields ('93').TYPE      := 'C';
    l_txmsg.txfields ('93').VALUE     := l_iddate;
    --94   IDPLACE    C
    l_txmsg.txfields ('94').defname   := 'IDPLACE';
    l_txmsg.txfields ('94').TYPE      := 'C';
    l_txmsg.txfields ('94').VALUE     := l_idplace;
    --95   ISSNAME    C
    l_txmsg.txfields ('95').defname   := 'ISSNAME';
    l_txmsg.txfields ('95').TYPE      := 'C';
    l_txmsg.txfields ('95').VALUE     :='';
    --96   CUSTODYCD    C
    l_txmsg.txfields ('96').defname   := 'CUSTODYCD';
    l_txmsg.txfields ('96').TYPE      := 'C';
    l_txmsg.txfields ('96').VALUE     := l_custodycd;

     --80   EXRATE    C
    l_txmsg.txfields ('80').defname   := 'EXRATE';
    l_txmsg.txfields ('80').TYPE      := 'C';
    l_txmsg.txfields ('80').VALUE     := l_EXRATE;


    BEGIN
        IF txpks_#3384.fn_autotxprocess (l_txmsg,
                                         p_err_code,
                                         l_err_param
           ) <> systemnums.c_success
        THEN
           plog.debug (pkgctx,
                       'got error 3384: ' || p_err_code
           );
           ROLLBACK;
           p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
           plog.error(pkgctx, 'Error:'  || p_err_message);
           plog.setendsection(pkgctx, 'pr_RightoffRegiter2BO');
           RETURN;
        END IF;
       --ThanhNV sua them doan check FO, neu giao dich duoi FO khong thanh cong cung rollback.
        PCK_SYN2FO.PRC_CHECK_SYN2FO(v_txnum =>l_txmsg.txnum,
                                     v_errcode => p_err_code,
                                     v_errmsg => p_err_message);


        plog.debug (pkgctx, 'PRC_CHECK_SYN2FO p_err_code '||p_err_code);
        IF p_err_code <> systemnums.c_success THEN
            ROLLBACK;
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error (pkgctx, p_err_message);
            plog.setendsection(pkgctx, 'pr_RightoffRegiter2BO');
            RETURN;
        END IF;

    END;
    p_err_code:=0;
    p_txnum:= l_txmsg.txnum;--1.5.3.0
    plog.setendsection(pkgctx, 'pr_RightoffRegiter2BO');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_RightoffRegiter2BO');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM||'p_camastid: '|| p_camastid ||'l_custodycd: '|| l_custodycd||'p_qtty: '||p_qtty||'l_camastid: '||l_camastid);
      plog.setendsection (pkgctx, 'pr_RightoffRegiter2BO');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_RightoffRegiter2BO;

PROCEDURE pr_gen_buf_od_account (p_acctno varchar2 default null)
  IS
  v_modeFO varchar2(100);
BEGIN
    plog.setBeginsection(pkgctx, 'pr_gen_buf_od_account');
    SELECT  VARVALUE INTO v_modeFO FROM sysvar  WHERE  VARNAME ='FOMODE';
    if p_acctno is null or p_acctno='ALL' then
        PLOG.INFO(pkgctx,'Begin pr_gen_buf_od_account');

        delete from buf_od_account;
        --commit;
        INSERT INTO buf_od_account (PRICETYPE,DESC_EXECTYPE,SYMBOL,ORSTATUS,
               QUOTEPRICE,ORDERQTTY,REMAINQTTY,EXECQTTY,EXECAMT,
               CANCELQTTY,ADJUSTQTTY,AFACCTNO,CUSTODYCD,FEEDBACKMSG,
               EXECTYPE,CODEID,BRATIO,ORDERID,REFORDERID,TXDATE,TXTIME,SDTIME,
               TLNAME,CTCI_ORDER,TRADEPLACE,EDSTATUS,VIA,TIMETYPE,
               MATCHTYPE,CLEARDAY,EFFDATE,EXPDATE,CAREBY,ORSTATUSVALUE,HOSESESSION, USERNAME, ISCANCEL, ISADMEND,
               ROOTORDERID,TIMETYPEVALUE,MATCHTYPEVALUE,FOACCTNO,ISDISPOSAL,QUOTEQTTY ,LIMITPRICE , CONFIRMED,
               TLID, BO_ORDERID, FOREFID, ISADVORD)
          SELECT PRICETYPE, DESC_EXECTYPE, SYMBOL, DESC_STATUS ORSTATUS, --CANCELSTATUS,
                  QUOTEPRICE/1000 QUOTEPRICE, QUANTITY ORDERQTTY, REMAINQTTY, EXECQTTY, EXECAMT, CANCELQTTY, ADJUSTQTTY,
                  AFACCTNO, CUSTODYCD, FEEDBACKMSG, EXECTYPE, CODEID, BRATIO,
                  --CASE WHEN v_modeFO ='ON' AND FOREFID IS NOT NULL THEN FOREFID
                  --ELSE ACCTNO END ORDERID
                  ACCTNO ORDERID , REFORDERID, TXDATE, DTL.TXTIME, SDTIME,
                  upper(tlname) tlname,CTCI_ORDER,tradeplace,edstatus,via,timetype,matchtype,clearday,effdate,expdate,CAREBY,ORSTATUSVALUE,HOSESESSION,
                  USERNAME, ISCANCEL, ISADMEND, ROOTORDERID, TIMETYPEVALUE,MATCHTYPEVALUE,FOACCTNO,ISDISPOSAL,QUOTEQTTY ,LIMITPRICE/1000 , CONFIRMED,
                  TLID, ACCTNO BO_ORDERID,FOREFID, fnc_isAdvOrd(FOREFID)
              FROM
              -- OD
              (SELECT CFMAST.CUSTODYCD, MST.TXDATE, MST.REFORDERID, MST.AFACCTNO, MST.orderid ACCTNO, '' ORGACCTNO, MST.EXECTYPE,MST.REFORDERID REFACCTNO,
                  MST.PRICETYPE, CD2.cdcontent DESC_EXECTYPE, TO_CHAR(sb.SYMBOL) SYMBOL, MST.orderqtty QUANTITY, MST.exprice PRICE,   TO_CHAR(CD0.cdcontent) feedbackmsg,
                  MST.QUOTEPRICE, 'Active' DESC_BOOK, MST.orstatus status, CD1.cdcontent DESC_STATUS, CD4.cdcontent DESC_TIMETYPE,
                  CD5.cdcontent DESC_MATCHTYPE, CD6.cdcontent DESC_NORK, CD7.cdcontent DESC_PRICETYPE, NVL(OOD.TXTIME,'') SDTIME,
                  MST.EXECQTTY, MST.EXECAMT, (CASE WHEN MST.EXECQTTY>0 THEN ROUND(MST.EXECAMT/1000/MST.EXECQTTY,2) ELSE 0 END) AVEXECPRICE, MST.REMAINQTTY, mst.txtime, mst.CANCELQTTY, mst.ADJUSTQTTY,'A' BOOK,CD8.cdcontent VIA,mst.VIA VIACD,
                  (CASE WHEN MST.CANCELQTTY>0 THEN 'Cancelled'  WHEN MST.EDITSTATUS='C' THEN 'Cancelling' ELSE '----' END) CANCELSTATUS,(CASE WHEN MST.ADJUSTQTTY>0 THEN 'Amended'  WHEN MST.EDITSTATUS='A' THEN 'Amending' ELSE '----' END) AMENDSTATUS,
                  SYS.SYSVALUE CURRSECSSION,MST.HOSESESSION ODSECSSION, nvl(f.username,nvl(mk.tlname,'Auto')) maker, MST.CODEID, MST.BRATIO,
                  nvl(mk.tlname,mst.tlid) tlname,to_char(MAP.CTCI_ORDER) CTCI_ORDER,
                  cd10.cdcontent tradeplace,mst.EDITSTATUS edstatus,cd4.cdcontent timetype,cd5.cdcontent matchtype,mst.clearday,mst.txdate effdate,mst.expdate,
                  cf.CAREBY, MST.ORSTATUSVALUE,MST.HOSESESSION, MST.CUSTID USERNAME, MST.ISCANCEL ISCANCEL, MST.ISADMEND ISADMEND, MST.ROOTORDERID ROOTORDERID,
                  MST.TIMETYPE TIMETYPEVALUE, MST.MATCHTYPE MATCHTYPEVALUE,
                  CASE WHEN MST.ORDERID = F.orgacctno THEN F.acctno ELSE MST.ORDERID END FOACCTNO,mst.ISDISPOSAL,mst.quoteqtty , mst.limitprice , mst.confirmed,
                  mst.tlid, nf.foorderid FOREFID
              FROM CFMAST, AFMAST CF, (select * from ood union select * from oodhist) OOD,
                (SELECT MST.*,
                   (CASE WHEN MST.REMAINQTTY <> 0 AND MST.EDITSTATUS='C' THEN 'C'
                        WHEN MST.REMAINQTTY <> 0 AND MST.EDITSTATUS='A' THEN 'A'
                       --phuongntn eidt + add
                       --WHEN MST.EDITSTATUS IS NULL AND MST.CANCELQTTY <> 0 then '5'
                       WHEN MST.EDITSTATUS IS NULL AND MST.CANCELQTTY <> 0 and MST.ORSTATUS <> '6' THEN '5'
                       WHEN MST.EDITSTATUS IS NULL AND MST.CANCELQTTY <> 0 and MST.ORSTATUS = '6' THEN '6'
                       --end phuongntn
                        WHEN MST.REMAINQTTY = 0 AND MST.CANCELQTTY <> 0 AND MST.EDITSTATUS='C' THEN '3'
                        when MST.REMAINQTTY = 0 and MST.ADJUSTQTTY>0 then '10'
                        WHEN MST.REMAINQTTY = 0 AND MST.EXECQTTY>0 AND MST.ORSTATUS = '4' THEN '12' ELSE MST.ORSTATUS END) ORSTATUSVALUE,
                   (CASE WHEN MST.REMAINQTTY > 0 AND (MST.EDITSTATUS IS NULL OR MST.EDITSTATUS IN ('N')) AND MST.ORSTATUS IN ('8','2','4')
                            AND MST.MATCHTYPE = 'N' /*AND MST.ISDISPOSAL = 'N'*/ THEN 'Y' ELSE 'N' END) ISCANCEL,
                   (CASE WHEN MST.REMAINQTTY > 0 AND (MST.EDITSTATUS IS NULL OR MST.EDITSTATUS IN ('N')) AND MST.ORSTATUS IN ('2','4')
                            AND MST.MATCHTYPE = 'N' AND MST.TRADEPLACE IN ('002','005','001') /*AND MST.ISDISPOSAL = 'N'*/
                            AND MST.TIMETYPE <> 'G' AND MST.PRICETYPE NOT IN ('MOK','MAK','ATO','ATC','MP')  THEN 'Y' ELSE 'N' END) ISADMEND,
                    fn_GetRootOrderID(MST.ORDERID) ROOTORDERID
                FROM
                    (SELECT OD1.*,OD2.EDSTATUS EDITSTATUS, SB.TRADEPLACE
                     from odmast OD1,(SELECT * FROM ODMAST WHERE EDSTATUS IN ('C','A')--) OD2, SBSECURITIES SB
                      --PHUONGNTN ADD KO LAY LENH HUY/SUA BI TU CHOI
                     AND ORSTATUS <>'6'
                     --END ADD
                     ) OD2, SBSECURITIES SB
                     WHERE OD1.ORDERID=OD2.REFORDERID(+) AND substr(OD1.EXECTYPE,1,1) <> 'C'
                        AND substr(OD1.EXECTYPE,1,1) <> 'A'
                        AND SB.CODEID = OD1.CODEID
                   ) MST
                ) MST,sbsecurities sb,
                   --TLLOG TL,
                  ALLCODE CD0,ALLCODE CD1, ALLCODE CD2, ALLCODE CD4, ALLCODE CD5, ALLCODE CD6, ALLCODE CD7, ALLCODE CD8, ALLCODE CD10,
                  ORDERSYS SYS,tlprofiles mk, fomast f,ordermap MAP, newfo_ordermap nf
              WHERE MST.ORSTATUS <> '7' AND CF.ACCTNO=MST.AFACCTNO
                  --AND MST.AFACCTNO=V_PARAFILTER
                  AND MST.orderid=OOD.ORGORDERID(+)
                  --AND MST.TXNUM=TL.TXNUM(+) AND MST.TXDATE=TL.TXDATE(+) AND NVL(TL.TXSTATUS,'1')='1'
                  AND CFMAST.CUSTID=CF.CUSTID and sb.codeid = mst.codeid
                  AND CD0.CDNAME = 'ORSTATUS' AND CD0.CDTYPE ='OD' AND CD0.CDVAL=MST.ORSTATUS
                  AND CD1.cdtype ='OD' AND CD1.CDNAME='ORSTATUS'
                  AND CD1.CDVAL= MST.ORSTATUSVALUE--(CASE WHEN MST.REMAINQTTY <> 0 AND MST.EDITSTATUS='C' THEN 'C' WHEN MST.REMAINQTTY <> 0 AND MST.EDITSTATUS='A' THEN 'A' WHEN MST.EDITSTATUS IS NULL AND MST.CANCELQTTY <> 0 THEN '5' WHEN MST.REMAINQTTY = 0 AND MST.CANCELQTTY <> 0 AND MST.EDITSTATUS='C' THEN '3' when MST.REMAINQTTY = 0 and MST.ADJUSTQTTY>0 then '10' ELSE MST.ORSTATUS END)
                  AND SYS.SYSNAME='CONTROLCODE'
                  AND MAP.ORGORDERID(+)=ood.orgorderid
                  AND CD2.cdtype ='OD' AND CD2.CDNAME='BUFEXECTYPE' AND CD2.CDVAL=MST.EXECTYPE||MST.MATCHTYPE
                  AND CD4.cdtype ='OD' AND CD4.CDNAME='TIMETYPE' AND CD4.CDVAL=MST.TIMETYPE
                  AND CD5.cdtype ='OD' AND CD5.CDNAME='MATCHTYPE' AND CD5.CDVAL=MST.MATCHTYPE
                  AND CD6.cdtype ='OD' AND CD6.CDNAME='NORK' AND CD6.CDVAL=MST.NORK
                  AND CD8.cdtype ='OD' AND CD8.CDNAME='VIA' AND CD8.CDVAL=MST.VIA
                  AND CD10.cdtype ='OD' AND CD10.CDNAME='TRADEPLACE' AND CD10.CDVAL=sb.TRADEPLACE
                  --AND EXISTS (SELECT TO_DATE(VARVALUE,'DD/MM/YYYY') FROM SYSVAR WHERE GRNAME ='SYSTEM' AND VARNAME='CURRDATE' AND MST.TXDATE = TO_DATE(VARVALUE,'DD/MM/YYYY'))
                  AND CD7.cdtype ='OD' AND CD7.CDNAME='PRICETYPE' AND CD7.CDVAL=MST.PRICETYPE and mst.tlid =mk.tlid (+)
                  and mst.orderid = f.orgacctno(+) and mst.exectype = f.exectype(+)
                  AND mst.orderid = nf.boorderid(+)
              UNION ALL
              -- OD + FO
              SELECT CFMAST.CUSTODYCD, MST.EFFDATE TXDATE, '' REFORDERID, MST.AFACCTNO, MST.ACCTNO, MST.ORGACCTNO, MST.EXECTYPE,MST.REFACCTNO REFACCTNO, MST.PRICETYPE,
                  CD2.cdcontent DESC_EXECTYPE, MST.SYMBOL, MST.QUANTITY, (MST.PRICE * 1000) PRICE, MST.feedbackmsg,
                  MST.QUOTEPRICE, TO_CHAR(CD3.cdcontent) DESC_BOOK, MST.STATUS, CD9.cdcontent DESC_STATUS, CD4.cdcontent DESC_TIMETYPE,
                  CD5.cdcontent DESC_MATCHTYPE, CD6.cdcontent DESC_NORK, CD7.cdcontent DESC_PRICETYPE, NVL(OOD.TXTIME,'') SDTIME,
                  REFOD.EXECQTTY, REFOD.EXECAMT,(CASE WHEN REFOD.EXECQTTY>0 THEN ROUND(REFOD.EXECAMT/1000/REFOD.EXECQTTY,2) ELSE 0 END) AVEXECPRICE, REFOD.REMAINQTTY, SUBSTR(MST.activatedt,12,9) txtime, REFOD.CANCELQTTY, REFOD.ADJUSTQTTY ,MST.BOOK BOOK,CD8.cdcontent VIA,REFOD.VIA VIACD,
                  (CASE WHEN REFOD.CANCELQTTY>0 THEN 'Cancelled'  WHEN REFOD.EDITSTATUS='C' THEN 'Cancelling' ELSE '----' END) CANCELSTATUS,(CASE WHEN REFOD.ADJUSTQTTY>0 THEN 'Amended' WHEN REFOD.EDITSTATUS='A' THEN 'Amending' ELSE '----' END) AMENDSTATUS,
                  SYS.SYSVALUE CURRSECSSION,REFOD.HOSESESSION ODSECSSION,MST.Username maker, MST.CODEID, MST.BRATIO,
                   nvl(tlpro.tlname,REFOD.TLID) tlname, to_char(MAP.CTCI_ORDER) CTCI_ORDER,
                   cd10.cdcontent tradeplace,nvl(REFOD.EDITSTATUS,'N') edstatus,cd4.cdcontent timetype,cd5.cdcontent matchtype,mst.clearday,mst.effdate,mst.expdate,
                   cf.CAREBY, REFOD.ORSTATUSVALUE ORSTATUSVALUE, '-' hosesession, MST.USERNAME USERNAME, REFOD.ISCANCEL, REFOD.ISADMEND, REFOD.ROOTORDERID,
                   REFOD.TIMETYPE TIMETYPEVALUE, REFOD.MATCHTYPE MATCHTYPEVALUE,
                   CASE WHEN REFOD.ORDERID = MST.orgacctno THEN MST.acctno ELSE REFOD.ORDERID END FOACCTNO,nvl(REFOD.ISDISPOSAL,'N') ISDISPOSAL,mst.quoteqtty , mst.limitprice , mst.confirmed,
                   REFOD.TLID, MST.FOREFID
              FROM CFMAST, AFMAST CF, (select * from ood union select * from oodhist) OOD, FOMAST MST,
                (select OD1.*,OD2.EDSTATUS EDITSTATUS,
                    (CASE WHEN OD1.REMAINQTTY > 0 AND OD2.EDSTATUS='C' THEN 'C'
                          WHEN OD1.REMAINQTTY > 0 AND OD2.EDSTATUS='A' THEN 'A'
                          --phuongntn eidt + add
                          --WHEN OD2.EDSTATUS IS NULL AND OD1.CANCELQTTY > 0 THEN '5'
                          WHEN OD2.EDSTATUS IS NULL AND OD1.CANCELQTTY > 0  and OD1.ORSTATUS <> '6' THEN '5'
                          WHEN OD2.EDSTATUS IS NULL AND OD1.CANCELQTTY > 0  and OD1.ORSTATUS = '6' THEN '6'
                          --end phuongntn
                          WHEN OD1.REMAINQTTY = 0 AND OD1.CANCELQTTY > 0 AND OD2.EDSTATUS='C' THEN '3'
                          when OD1.REMAINQTTY = 0 and OD1.ADJUSTQTTY>0 then '10'
                          WHEN OD1.REMAINQTTY = 0 AND OD1.EXECQTTY>0 AND OD1.ORSTATUS = '4' THEN '12' ELSE OD1.ORSTATUS END) ORSTATUSVALUE,
                    (CASE WHEN OD1.REMAINQTTY > 0 AND (OD2.EDSTATUS IS NULL OR OD2.EDSTATUS IN ('N')) AND OD1.ORSTATUS IN ('8','2','4')
                            AND OD1.MATCHTYPE = 'N' /*AND OD1.ISDISPOSAL = 'N'*/ THEN 'Y' ELSE 'N' END) ISCANCEL,
                   (CASE WHEN OD1.REMAINQTTY > 0 AND (OD2.EDSTATUS IS NULL OR OD2.EDSTATUS IN ('N')) AND OD1.ORSTATUS IN ('2','4')
                            AND OD1.MATCHTYPE = 'N' AND SB.TRADEPLACE IN ('002','005','001') /*AND OD1.ISDISPOSAL = 'N'*/
                            AND OD1.TIMETYPE <> 'G'  AND OD1.PRICETYPE NOT IN ('MOK','MAK','ATO','ATC','MP') THEN 'Y'  ELSE 'N' END) ISADMEND,
                   fn_GetRootOrderID(OD1.ORDERID)  ROOTORDERID
                    from odmast OD1,
                    (SELECT * FROM ODMAST WHERE EDSTATUS IN ('C','A')
                     --PHUONGNTN ADD KO LAY LENH HUY/SUA BI TU CHOI
                     AND ORSTATUS <>'6'
                     --END ADD
                    ) OD2, SBSECURITIES SB
                WHERE OD1.ORDERID=OD2.REFORDERID(+) AND substr(OD1.EXECTYPE,1,1) <> 'C'
                    AND substr(OD1.EXECTYPE,1,1) <> 'A'
                    AND OD1.CODEID = SB.CODEID) REFOD,
                  ALLCODE CD1, ALLCODE CD2, ALLCODE CD3, ALLCODE CD4, ALLCODE CD5, ALLCODE CD6,
                  ALLCODE CD7, ALLCODE CD8, ALLCODE CD9 ,ALLCODE CD10,
                  ORDERSYS SYS,sbsecurities sb,
                  tlprofiles tlpro,ordermap MAP
              WHERE  REFOD.ORSTATUS <> '7' AND MST.DELTD='N' AND CF.ACCTNO=MST.AFACCTNO
                  --AND MST.AFACCTNO=V_PARAFILTER
                  AND MST.ACCTNO=OOD.ORGORDERID(+)
                  AND MST.STATUS = 'A' AND MST.acctno = mst.orgacctno
                  AND MST.CODEID=SB.CODEID
                  AND CD1.cdtype ='FO' AND CD1.CDNAME='STATUS' AND CD1.CDVAL=MST.STATUS
                  AND SYS.SYSNAME='CONTROLCODE'  AND CFMAST.CUSTID=CF.CUSTID
                  AND CD2.cdtype ='OD' AND CD2.CDNAME='BUFEXECTYPE' AND CD2.CDVAL=MST.EXECTYPE||MST.MATCHTYPE
                  AND CD3.cdtype ='FO' AND CD3.CDNAME='BOOK' AND CD3.CDVAL=MST.BOOK
                  AND CD4.cdtype ='FO' AND CD4.CDNAME='TIMETYPE' AND CD4.CDVAL=MST.TIMETYPE
                  AND CD5.cdtype ='FO' AND CD5.CDNAME='MATCHTYPE' AND CD5.CDVAL=MST.MATCHTYPE
                  AND CD6.cdtype ='FO' AND CD6.CDNAME='NORK' AND CD6.CDVAL=MST.NORK
                  AND CD8.cdtype ='OD' AND CD8.CDNAME='VIA' AND CD8.CDVAL=REFOD.VIA
                  AND CD7.cdtype ='FO' AND CD7.CDNAME='PRICETYPE' AND CD7.CDVAL=MST.PRICETYPE
                  AND CD9.cdtype ='OD' AND CD9.CDNAME='ORSTATUS' AND CD9.CDVAL=REFOD.ORSTATUSVALUE
                  AND CD10.cdtype ='OD' AND CD10.CDNAME='TRADEPLACE' AND CD10.CDVAL=sb.TRADEPLACE
                  --AND EXISTS (SELECT TO_DATE(VARVALUE,'DD/MM/YYYY') FROM SYSVAR WHERE GRNAME ='SYSTEM' AND VARNAME='CURRDATE' AND REFOD.TXDATE =  TO_DATE(VARVALUE,'DD/MM/YYYY'))
                  AND MST.ORGACCTNO=REFOD.ORDERID
                   AND REFOD.TLID=tlpro.tlid(+)
                  AND MAP.ORGORDERID(+)=REFOD.orderid
              UNION ALL
              -- FO
              SELECT CFMAST.CUSTODYCD, MST.EFFDATE TXDATE,'' REFORDERID, MST.AFACCTNO, MST.ACCTNO, MST.ORGACCTNO, MST.EXECTYPE,(CASE WHEN MST.STATUS='R' THEN '' ELSE MST.REFACCTNO END) REFACCTNO, MST.PRICETYPE,
                  CD2.cdcontent DESC_EXECTYPE, MST.SYMBOL, MST.QUANTITY-NVL(ROOT.ORDERQTTY,0) QUANTITY,(MST.PRICE * SYINFO.TRADEUNIT) PRICE, MST.feedbackmsg,
                  MST.QUOTEPRICE* SYINFO.TRADEUNIT QUOTEPRICE, TO_CHAR(CD3.cdcontent) DESC_BOOK, MST.STATUS, CD1.cdcontent DESC_STATUS, CD4.cdcontent DESC_TIMETYPE,
                  CD5.cdcontent DESC_MATCHTYPE, CD6.cdcontent DESC_NORK, CD7.cdcontent DESC_PRICETYPE, NVL(OOD.TXTIME,'') SDTIME,
                  MST.EXECQTTY, MST.EXECAMT,(CASE WHEN MST.EXECQTTY>0 THEN ROUND(MST.EXECAMT/1000/MST.EXECQTTY,2) ELSE 0 END) AVEXECPRICE, MST.REMAINQTTY-NVL(ROOT.ORDERQTTY,0) REMAINQTTY, SUBSTR(MST.activatedt,12,9) txtime, mst.CANCELQTTY , mst.AMENDQTTY ADJUSTQTTY,MST.BOOK BOOK,CD8.cdcontent VIA,'T' VIACD,('----') CANCELSTATUS,('----') AMENDSTATUS,
                  SYS.SYSVALUE CURRSECSSION,'N' ODSECSSION,MST.Username maker, MST.CODEID, MST.BRATIO,
                   nvl(tlpro.tlname,mst.tlid) tlname, '' CTCI_ORDER,
                  cd10.cdcontent tradeplace,'N' edstatus,cd4.cdcontent timetype,cd5.cdcontent matchtype,mst.clearday,mst.effdate,mst.expdate,
                  cf.CAREBY, MST.STATUS ORSTATUSVALUE,'-' HOSESESSION, MST.USERNAME USERNAME,
                  CASE WHEN MST.STATUS IN ('P','I','A','W') /*AND MST.ISDISPOSAL = 'N'*/ THEN 'Y' ELSE 'N' END ISCANCEL,
                  CASE WHEN MST.STATUS IN ('P','I','A','W') AND SB.TRADEPLACE IN ('002','005','001') /*AND MST.ISDISPOSAL = 'N'*/
                  AND MST.TIMETYPE <> 'G'  AND MST.PRICETYPE NOT IN ('MOK','MAK','ATO','ATC','MP') THEN 'Y'  ELSE 'N' END ISADMEND,
                  MST.ACCTNO ROOTORDERID, MST.TIMETYPE TIMETYPEVALUE, MST.MATCHTYPE MATCHTYPEVALUE, NVL(MST.ACCTNO,'') FOACCTNO, nvl(mst.ISDISPOSAL,'N') ISDISPOSAL,mst.quoteqtty , mst.limitprice , mst.confirmed,
                  MST.TLID, MST.FOREFID
              FROM CFMAST, AFMAST CF, OOD, FOMAST MST, SECURITIES_INFO SYINFO,
                  ALLCODE CD1, ALLCODE CD2, ALLCODE CD3, ALLCODE CD4, ALLCODE CD5,
                  ALLCODE CD6, ALLCODE CD7, ALLCODE CD8 ,ALLCODE CD10 ,
                  ORDERSYS SYS,sbsecurities sb,
                  (SELECT A.FOACCTNO, SUM (B.ORDERQTTY) ORDERQTTY FROM ROOTORDERMAP A, ODMAST B WHERE A.ORDERID=B.ORDERID AND STATUS='A' GROUP BY A.FOACCTNO) ROOT,
                  tlprofiles tlpro--, ordermap MAP
              WHERE MST.ACCTNO=ROOT.FOACCTNO(+) AND MST.STATUS<>'A' AND substr(MST.EXECTYPE,1,1) <> 'C' AND substr(MST.EXECTYPE,1,1) <> 'A'
              AND MST.DELTD='N' AND CF.ACCTNO=MST.AFACCTNO AND SYINFO.SYMBOL=MST.SYMBOL
                  --AND MST.AFACCTNO=V_PARAFILTER
                  AND MST.codeid= sb.codeid
                  AND MST.ACCTNO=OOD.ORGORDERID(+)
                  AND CD1.cdtype ='FO' AND CD1.CDNAME='STATUS' AND CD1.CDVAL=MST.status
                  AND SYS.SYSNAME='CONTROLCODE'  AND CFMAST.CUSTID=CF.CUSTID
                  AND CD2.cdtype ='OD' AND CD2.CDNAME='BUFEXECTYPE' AND CD2.CDVAL=MST.EXECTYPE||MST.MATCHTYPE
                  AND CD3.cdtype ='FO' AND CD3.CDNAME='BOOK' AND CD3.CDVAL=MST.BOOK
                  AND CD4.cdtype ='FO' AND CD4.CDNAME='TIMETYPE' AND CD4.CDVAL=MST.TIMETYPE
                  AND CD5.cdtype ='FO' AND CD5.CDNAME='MATCHTYPE' AND CD5.CDVAL=MST.MATCHTYPE
                  AND CD6.cdtype ='FO' AND CD6.CDNAME='NORK' AND CD6.CDVAL=MST.NORK
                  AND CD8.cdtype ='OD' AND CD8.CDNAME='VIA' AND CD8.CDVAL=MST.VIA
                  AND CD7.cdtype ='FO' AND CD7.CDNAME='PRICETYPE' AND CD7.CDVAL=MST.PRICETYPE
                  AND CD10.cdtype ='OD' AND CD10.CDNAME='TRADEPLACE' AND CD10.CDVAL=sb.TRADEPLACE
                   AND tlpro.tlid(+)= mst.tlid
                  --AND MAP.ORGORDERID(+)= ood.orgorderid
              ) DTL
          ORDER BY REFORDERID, TXDATE DESC, TXTIME DESC, ACCTNO;
          PLOG.info(pkgctx,'End pr_gen_buf_od_account');
    else
        PLOG.debug(pkgctx,'Begin pr_gen_buf_od_account' || p_acctno);

        delete from buf_od_account where orderid =p_acctno;
        --commit;
        INSERT INTO buf_od_account (PRICETYPE,DESC_EXECTYPE,SYMBOL,ORSTATUS,
               QUOTEPRICE,ORDERQTTY,REMAINQTTY,EXECQTTY,EXECAMT,
               CANCELQTTY,ADJUSTQTTY,AFACCTNO,CUSTODYCD,FEEDBACKMSG,
               EXECTYPE,CODEID,BRATIO,ORDERID,REFORDERID,TXDATE,TXTIME,SDTIME,
               TLNAME,CTCI_ORDER,TRADEPLACE,EDSTATUS,VIA,TIMETYPE,
               MATCHTYPE,CLEARDAY,EFFDATE,EXPDATE,CAREBY,ORSTATUSVALUE,HOSESESSION, USERNAME, ISCANCEL, ISADMEND,
               ROOTORDERID,TIMETYPEVALUE,MATCHTYPEVALUE,FOACCTNO,ISDISPOSAL,QUOTEQTTY ,LIMITPRICE , CONFIRMED,
               TLID,FOREFID)
          SELECT PRICETYPE, DESC_EXECTYPE, SYMBOL, DESC_STATUS ORSTATUS, --CANCELSTATUS,
                  QUOTEPRICE/1000 QUOTEPRICE, QUANTITY ORDERQTTY, REMAINQTTY, EXECQTTY, EXECAMT, CANCELQTTY, ADJUSTQTTY,
                  AFACCTNO, CUSTODYCD, FEEDBACKMSG, EXECTYPE, CODEID, BRATIO, ACCTNO ORDERID, REFORDERID, TXDATE, DTL.TXTIME, SDTIME,
                  upper(tlname) tlname,CTCI_ORDER,tradeplace,edstatus,via,timetype,matchtype,clearday,effdate,expdate,CAREBY,ORSTATUSVALUE,HOSESESSION,
                  USERNAME, ISCANCEL, ISADMEND, ROOTORDERID,TIMETYPEVALUE,MATCHTYPEVALUE,FOACCTNO,ISDISPOSAL,QUOTEQTTY ,LIMITPRICE/1000 , CONFIRMED,
                  TLID,FOREFID
              FROM
              -- OD
              (SELECT CFMAST.CUSTODYCD, MST.TXDATE, MST.REFORDERID, MST.AFACCTNO, MST.orderid ACCTNO, '' ORGACCTNO, MST.EXECTYPE,MST.REFORDERID REFACCTNO,
                  MST.PRICETYPE, CD2.cdcontent DESC_EXECTYPE, TO_CHAR(sb.SYMBOL) SYMBOL, MST.orderqtty QUANTITY, MST.exprice PRICE,   TO_CHAR(CD0.cdcontent) feedbackmsg,
                  MST.QUOTEPRICE, 'Active' DESC_BOOK, MST.orstatus status, CD1.cdcontent DESC_STATUS, CD4.cdcontent DESC_TIMETYPE,
                  CD5.cdcontent DESC_MATCHTYPE, CD6.cdcontent DESC_NORK, CD7.cdcontent DESC_PRICETYPE, NVL(OOD.TXTIME,'') SDTIME,
                  MST.EXECQTTY, MST.EXECAMT, (CASE WHEN MST.EXECQTTY>0 THEN ROUND(MST.EXECAMT/1000/MST.EXECQTTY,2) ELSE 0 END) AVEXECPRICE, MST.REMAINQTTY, mst.txtime, mst.CANCELQTTY, mst.ADJUSTQTTY,'A' BOOK,CD8.cdcontent VIA,mst.VIA VIACD,
                  (CASE WHEN MST.CANCELQTTY>0 THEN 'Cancelled'  WHEN MST.EDITSTATUS='C' THEN 'Cancelling' ELSE '----' END) CANCELSTATUS,(CASE WHEN MST.ADJUSTQTTY>0 THEN 'Amended'  WHEN MST.EDITSTATUS='A' THEN 'Amending' ELSE '----' END) AMENDSTATUS,
                  SYS.SYSVALUE CURRSECSSION,MST.HOSESESSION ODSECSSION, nvl(f.username,nvl(mk.tlname,'Auto')) maker, MST.CODEID, MST.BRATIO,
                  nvl(mk.tlname,mst.tlid) tlname,to_char(MAP.CTCI_ORDER) CTCI_ORDER,
                  cd10.cdcontent tradeplace,mst.EDITSTATUS edstatus,cd4.cdcontent timetype,cd5.cdcontent matchtype,mst.clearday,mst.txdate effdate,mst.expdate,
                  cf.CAREBY, MST.ORSTATUSVALUE,MST.HOSESESSION, MST.CUSTID USERNAME, MST.ISCANCEL ISCANCEL, MST.ISADMEND ISADMEND, MST.ROOTORDERID ROOTORDERID,
                  MST.TIMETYPE TIMETYPEVALUE, MST.MATCHTYPE MATCHTYPEVALUE,
                  CASE WHEN MST.ORDERID = F.orgacctno THEN F.acctno ELSE MST.ORDERID END FOACCTNO,mst.ISDISPOSAL,mst.quoteqtty , mst.limitprice , mst.confirmed,
                  mst.tlid TLID, nf.foorderid FOREFID
              FROM CFMAST, AFMAST CF, (select * from ood union select * from oodhist) OOD,
                (SELECT MST.*,
                   (CASE WHEN MST.REMAINQTTY <> 0 AND MST.EDITSTATUS='C' THEN 'C'
                        WHEN MST.REMAINQTTY <> 0 AND MST.EDITSTATUS='A' THEN 'A'
                         --phuongntn eidt + add
                       --WHEN MST.EDITSTATUS IS NULL AND MST.CANCELQTTY <> 0 then '5'
                       WHEN MST.EDITSTATUS IS NULL AND MST.CANCELQTTY <> 0 and MST.ORSTATUS <> '6' THEN '5'
                       WHEN MST.EDITSTATUS IS NULL AND MST.CANCELQTTY <> 0 and MST.ORSTATUS = '6' THEN '6'
                      --end phuongntn
                        WHEN MST.REMAINQTTY = 0 AND MST.CANCELQTTY <> 0 AND MST.EDITSTATUS='C' THEN '3'
                        when MST.REMAINQTTY = 0 and MST.ADJUSTQTTY>0 then '10'
                        WHEN MST.REMAINQTTY = 0 AND MST.EXECQTTY>0 AND MST.ORSTATUS = '4' THEN '12' ELSE MST.ORSTATUS END) ORSTATUSVALUE,
                   (CASE WHEN MST.REMAINQTTY > 0 AND (MST.EDITSTATUS IS NULL OR MST.EDITSTATUS IN ('N')) AND MST.ORSTATUS IN ('8','2','4')
                            AND MST.MATCHTYPE = 'N' /*AND MST.ISDISPOSAL = 'N'*/ THEN 'Y' ELSE 'N' END) ISCANCEL,
                   (CASE WHEN MST.REMAINQTTY > 0 AND (MST.EDITSTATUS IS NULL OR MST.EDITSTATUS IN ('N')) AND MST.ORSTATUS IN ('2','4')
                            AND MST.MATCHTYPE = 'N' AND MST.TRADEPLACE IN ('002','005','001') /*AND MST.ISDISPOSAL = 'N'*/
                            AND MST.TIMETYPE <> 'G'  AND MST.PRICETYPE NOT IN ('MOK','MAK','ATO','ATC','MP')  THEN 'Y'
                            ELSE 'N' END) ISADMEND,
                    fn_GetRootOrderID(MST.ORDERID) ROOTORDERID
                FROM
                    (SELECT OD1.*,OD2.EDSTATUS EDITSTATUS, SB.TRADEPLACE
                     from odmast OD1,(SELECT * FROM ODMAST WHERE EDSTATUS IN ('C','A')
                     --PHUONGNTN ADD KO LAY LENH HUY/SUA BI TU CHOI
                     AND ORSTATUS <>'6'
                     --END ADD
                     ) OD2, SBSECURITIES SB
                     WHERE OD1.ORDERID=OD2.REFORDERID(+) AND substr(OD1.EXECTYPE,1,1) <> 'C'
                        AND substr(OD1.EXECTYPE,1,1) <> 'A'
                        AND SB.CODEID = OD1.CODEID
                   ) MST
                ) MST,sbsecurities sb,
                   --TLLOG TL,
                  ALLCODE CD0,ALLCODE CD1, ALLCODE CD2, ALLCODE CD4, ALLCODE CD5, ALLCODE CD6, ALLCODE CD7, ALLCODE CD8, ALLCODE CD10,
                  ORDERSYS SYS,tlprofiles mk,fomast f,
                  ordermap MAP , newfo_ordermap nf
              WHERE MST.ORSTATUS <> '7' AND CF.ACCTNO=MST.AFACCTNO
                  --AND MST.AFACCTNO=V_PARAFILTER
                  AND MST.ORDERID = p_acctno
                  AND MST.orderid=OOD.ORGORDERID(+)
                  --AND MST.TXNUM=TL.TXNUM(+) AND MST.TXDATE=TL.TXDATE(+) AND NVL(TL.TXSTATUS,'1')='1'
                  AND CFMAST.CUSTID=CF.CUSTID and sb.codeid = mst.codeid
                  AND CD0.CDNAME = 'ORSTATUS' AND CD0.CDTYPE ='OD' AND CD0.CDVAL=MST.ORSTATUS
                  AND CD1.cdtype ='OD' AND CD1.CDNAME='ORSTATUS'
                  AND CD1.CDVAL= MST.ORSTATUSVALUE--(CASE WHEN MST.REMAINQTTY <> 0 AND MST.EDITSTATUS='C' THEN 'C' WHEN MST.REMAINQTTY <> 0 AND MST.EDITSTATUS='A' THEN 'A' WHEN MST.EDITSTATUS IS NULL AND MST.CANCELQTTY <> 0 THEN '5' WHEN MST.REMAINQTTY = 0 AND MST.CANCELQTTY <> 0 AND MST.EDITSTATUS='C' THEN '3' when MST.REMAINQTTY = 0 and MST.ADJUSTQTTY>0 then '10' ELSE MST.ORSTATUS END)
                  AND SYS.SYSNAME='CONTROLCODE'
                  AND MAP.ORGORDERID(+)=ood.orgorderid
                  AND CD2.cdtype ='OD' AND CD2.CDNAME='BUFEXECTYPE' AND CD2.CDVAL=MST.EXECTYPE||MST.MATCHTYPE
                  AND CD4.cdtype ='OD' AND CD4.CDNAME='TIMETYPE' AND CD4.CDVAL=MST.TIMETYPE
                  AND CD5.cdtype ='OD' AND CD5.CDNAME='MATCHTYPE' AND CD5.CDVAL=MST.MATCHTYPE
                  AND CD6.cdtype ='OD' AND CD6.CDNAME='NORK' AND CD6.CDVAL=MST.NORK
                  AND CD8.cdtype ='OD' AND CD8.CDNAME='VIA' AND CD8.CDVAL=MST.VIA
                  AND CD10.cdtype ='OD' AND CD10.CDNAME='TRADEPLACE' AND CD10.CDVAL=sb.TRADEPLACE
                  --AND EXISTS (SELECT TO_DATE(VARVALUE,'DD/MM/YYYY') FROM SYSVAR WHERE GRNAME ='SYSTEM' AND VARNAME='CURRDATE' AND MST.TXDATE = TO_DATE(VARVALUE,'DD/MM/YYYY'))
                  AND CD7.cdtype ='OD' AND CD7.CDNAME='PRICETYPE' AND CD7.CDVAL=MST.PRICETYPE and mst.tlid =mk.tlid (+)
                  and mst.orderid = f.orgacctno(+) and mst.exectype = f.exectype(+)
                   AND mst.orderid = nf.boorderid(+)
              UNION ALL
              -- OD + FO
              SELECT CFMAST.CUSTODYCD, MST.EFFDATE TXDATE, '' REFORDERID, MST.AFACCTNO, MST.ACCTNO, MST.ORGACCTNO, MST.EXECTYPE,MST.REFACCTNO REFACCTNO, MST.PRICETYPE,
                  CD2.cdcontent DESC_EXECTYPE, MST.SYMBOL, MST.QUANTITY, (MST.PRICE * 1000) PRICE, MST.feedbackmsg,
                  MST.QUOTEPRICE, TO_CHAR(CD3.cdcontent) DESC_BOOK, MST.STATUS, CD9.cdcontent DESC_STATUS, CD4.cdcontent DESC_TIMETYPE,
                  CD5.cdcontent DESC_MATCHTYPE, CD6.cdcontent DESC_NORK, CD7.cdcontent DESC_PRICETYPE, NVL(OOD.TXTIME,'') SDTIME,
                  REFOD.EXECQTTY, REFOD.EXECAMT,(CASE WHEN REFOD.EXECQTTY>0 THEN ROUND(REFOD.EXECAMT/1000/REFOD.EXECQTTY,2) ELSE 0 END) AVEXECPRICE, REFOD.REMAINQTTY, SUBSTR(MST.activatedt,12,9) txtime, REFOD.CANCELQTTY, REFOD.ADJUSTQTTY ,MST.BOOK BOOK,CD8.cdcontent VIA,REFOD.VIA VIACD,
                  (CASE WHEN REFOD.CANCELQTTY>0 THEN 'Cancelled'  WHEN REFOD.EDITSTATUS='C' THEN 'Cancelling' ELSE '----' END) CANCELSTATUS,(CASE WHEN REFOD.ADJUSTQTTY>0 THEN 'Amended' WHEN REFOD.EDITSTATUS='A' THEN 'Amending' ELSE '----' END) AMENDSTATUS,
                  SYS.SYSVALUE CURRSECSSION,REFOD.HOSESESSION ODSECSSION,MST.Username maker, MST.CODEID, MST.BRATIO,
                   nvl(tlpro.tlname,REFOD.TLID) tlname, to_char(MAP.CTCI_ORDER) CTCI_ORDER,
                   cd10.cdcontent tradeplace,nvl(REFOD.EDITSTATUS,'N') edstatus,cd4.cdcontent timetype,cd5.cdcontent matchtype,mst.clearday,mst.effdate,mst.expdate,
                   cf.CAREBY, REFOD.ORSTATUSVALUE ORSTATUSVALUE, '-' hosesession, MST.USERNAME USERNAME, REFOD.ISCANCEL, REFOD.ISADMEND, REFOD.ROOTORDERID,
                   REFOD.TIMETYPE TIMETYPEVALUE, REFOD.MATCHTYPE MATCHTYPEVALUE,
                   CASE WHEN REFOD.ORDERID = MST.orgacctno THEN MST.acctno ELSE REFOD.ORDERID END FOACCTNO, nvl(REFOD.ISDISPOSAL,'N') ISDISPOSAL,mst.quoteqtty , mst.limitprice , mst.confirmed,
                   REFOD.TLID TLID,mst.forefid
              FROM CFMAST, AFMAST CF, (select * from ood union select * from oodhist) OOD, FOMAST MST,
                (select OD1.*,OD2.EDSTATUS EDITSTATUS,
                    (CASE WHEN OD1.REMAINQTTY > 0 AND OD2.EDSTATUS='C' THEN 'C'
                          WHEN OD1.REMAINQTTY > 0 AND OD2.EDSTATUS='A' THEN 'A'
                          --phuongntn eidt + add
                          --WHEN OD2.EDSTATUS IS NULL AND OD1.CANCELQTTY > 0 THEN '5'
                          WHEN OD2.EDSTATUS IS NULL AND OD1.CANCELQTTY > 0  and OD1.ORSTATUS <> '6' THEN '5'
                          WHEN OD2.EDSTATUS IS NULL AND OD1.CANCELQTTY > 0  and OD1.ORSTATUS = '6' THEN '6'
                          --end phuongntn
                          WHEN OD1.REMAINQTTY = 0 AND OD1.CANCELQTTY > 0 AND OD2.EDSTATUS='C' THEN '3'
                          when OD1.REMAINQTTY = 0 and OD1.ADJUSTQTTY>0 then '10'
                          WHEN OD1.REMAINQTTY = 0 AND OD1.EXECQTTY>0 AND OD1.ORSTATUS = '4' THEN '12' ELSE OD1.ORSTATUS END) ORSTATUSVALUE,
                    (CASE WHEN OD1.REMAINQTTY > 0 AND (OD2.EDSTATUS IS NULL OR OD2.EDSTATUS IN ('N')) AND OD1.ORSTATUS IN ('8','2','4')
                            AND OD1.MATCHTYPE = 'N' /*AND OD1.ISDISPOSAL = 'N'*/ THEN 'Y' ELSE 'N' END) ISCANCEL,
                   (CASE WHEN OD1.REMAINQTTY > 0 AND (OD2.EDSTATUS IS NULL OR OD2.EDSTATUS IN ('N')) AND OD1.ORSTATUS IN ('2','4')
                            AND OD1.MATCHTYPE = 'N' AND SB.TRADEPLACE IN ('002','005','001') /*AND OD1.ISDISPOSAL = 'N'*/ AND OD1.TIMETYPE <> 'G' AND   OD1.PRICETYPE NOT IN ('MOK','MAK','ATO','ATC') THEN 'Y'
                            WHEN OD1.PRICETYPE IN ('MOK','MAK','ATO','ATC','MP')   THEN 'N'
                            ELSE 'N' END) ISADMEND,
                   fn_GetRootOrderID(OD1.ORDERID)  ROOTORDERID
                     from odmast OD1,(SELECT * FROM ODMAST WHERE EDSTATUS IN ('C','A')
                     --PHUONGNTN ADD KO LAY LENH HUY/SUA BI TU CHOI
                     AND ORSTATUS <>'6'
                     --END ADD
                     ) OD2, SBSECURITIES SB
                WHERE OD1.ORDERID=OD2.REFORDERID(+) AND substr(OD1.EXECTYPE,1,1) <> 'C'
                    AND substr(OD1.EXECTYPE,1,1) <> 'A'
                    AND OD1.CODEID = SB.CODEID) REFOD,
                  ALLCODE CD1, ALLCODE CD2, ALLCODE CD3, ALLCODE CD4, ALLCODE CD5, ALLCODE CD6,
                  ALLCODE CD7, ALLCODE CD8, ALLCODE CD9 ,ALLCODE CD10,
                  ORDERSYS SYS,sbsecurities sb,
                  tlprofiles tlpro,ordermap MAP
              WHERE  REFOD.ORSTATUS <> '7' AND MST.DELTD='N' AND CF.ACCTNO=MST.AFACCTNO
                    AND MST.ACCTNO = p_acctno
                  --AND MST.AFACCTNO=V_PARAFILTER
                  AND MST.ACCTNO=OOD.ORGORDERID(+)
                  AND MST.STATUS = 'A' AND MST.acctno = mst.orgacctno
                  AND MST.CODEID=SB.CODEID
                  AND CD1.cdtype ='FO' AND CD1.CDNAME='STATUS' AND CD1.CDVAL=MST.STATUS
                  AND SYS.SYSNAME='CONTROLCODE'  AND CFMAST.CUSTID=CF.CUSTID
                  AND CD2.cdtype ='OD' AND CD2.CDNAME='BUFEXECTYPE' AND CD2.CDVAL=MST.EXECTYPE||MST.MATCHTYPE
                  AND CD3.cdtype ='FO' AND CD3.CDNAME='BOOK' AND CD3.CDVAL=MST.BOOK
                  AND CD4.cdtype ='FO' AND CD4.CDNAME='TIMETYPE' AND CD4.CDVAL=MST.TIMETYPE
                  AND CD5.cdtype ='FO' AND CD5.CDNAME='MATCHTYPE' AND CD5.CDVAL=MST.MATCHTYPE
                  AND CD6.cdtype ='FO' AND CD6.CDNAME='NORK' AND CD6.CDVAL=MST.NORK
                  AND CD8.cdtype ='OD' AND CD8.CDNAME='VIA' AND CD8.CDVAL=REFOD.VIA
                  AND CD7.cdtype ='FO' AND CD7.CDNAME='PRICETYPE' AND CD7.CDVAL=MST.PRICETYPE
                  AND CD9.cdtype ='OD' AND CD9.CDNAME='ORSTATUS' AND CD9.CDVAL=REFOD.ORSTATUSVALUE
                  AND CD10.cdtype ='OD' AND CD10.CDNAME='TRADEPLACE' AND CD10.CDVAL=sb.TRADEPLACE
                  --AND EXISTS (SELECT TO_DATE(VARVALUE,'DD/MM/YYYY') FROM SYSVAR WHERE GRNAME ='SYSTEM' AND VARNAME='CURRDATE' AND REFOD.TXDATE =  TO_DATE(VARVALUE,'DD/MM/YYYY'))
                  AND MST.ORGACCTNO=REFOD.ORDERID
                   AND REFOD.TLID=tlpro.tlid(+)
                  AND MAP.ORGORDERID(+)=REFOD.orderid
              UNION ALL
              -- FO
              SELECT CFMAST.CUSTODYCD, MST.EFFDATE TXDATE,'' REFORDERID, MST.AFACCTNO, MST.ACCTNO, MST.ORGACCTNO, MST.EXECTYPE,(CASE WHEN MST.STATUS='R' THEN '' ELSE MST.REFACCTNO END) REFACCTNO, MST.PRICETYPE,
                  CD2.cdcontent DESC_EXECTYPE, MST.SYMBOL, MST.QUANTITY-NVL(ROOT.ORDERQTTY,0) QUANTITY,(MST.PRICE * SYINFO.TRADEUNIT) PRICE, MST.feedbackmsg,
                  MST.QUOTEPRICE* SYINFO.TRADEUNIT QUOTEPRICE, TO_CHAR(CD3.cdcontent) DESC_BOOK, MST.STATUS, CD1.cdcontent DESC_STATUS, CD4.cdcontent DESC_TIMETYPE,
                  CD5.cdcontent DESC_MATCHTYPE, CD6.cdcontent DESC_NORK, CD7.cdcontent DESC_PRICETYPE, NVL(OOD.TXTIME,'') SDTIME,
                  MST.EXECQTTY, MST.EXECAMT,(CASE WHEN MST.EXECQTTY>0 THEN ROUND(MST.EXECAMT/1000/MST.EXECQTTY,2) ELSE 0 END) AVEXECPRICE, MST.REMAINQTTY-NVL(ROOT.ORDERQTTY,0) REMAINQTTY, SUBSTR(MST.activatedt,12,9) txtime, mst.CANCELQTTY , mst.AMENDQTTY ADJUSTQTTY,MST.BOOK BOOK,CD8.cdcontent VIA,'T' VIACD,('----') CANCELSTATUS,('----') AMENDSTATUS,
                  SYS.SYSVALUE CURRSECSSION,'N' ODSECSSION,MST.Username maker, MST.CODEID, MST.BRATIO,
                   nvl(tlpro.tlname,mst.tlid) tlname, '' CTCI_ORDER,
                  cd10.cdcontent tradeplace,'N' edstatus,cd4.cdcontent timetype,cd5.cdcontent matchtype,mst.clearday,mst.effdate,mst.expdate,
                  cf.CAREBY, MST.STATUS ORSTATUSVALUE,'-' HOSESESSION, MST.USERNAME USERNAME,
                  CASE WHEN MST.STATUS IN ('P','I','A','W') /*AND MST.ISDISPOSAL = 'N'*/ THEN 'Y' ELSE 'N' END ISCANCEL,
                  CASE WHEN MST.STATUS IN ('P','I','A','W') AND SB.TRADEPLACE IN ('002','005','001') /*AND MST.ISDISPOSAL = 'N'*/
                  AND MST.TIMETYPE <> 'G' AND   MST.PRICETYPE NOT IN ('MOK','MAK','ATO','ATC','MP') THEN 'Y'   ELSE 'N' END ISADMEND,
                  MST.ACCTNO ROOTORDERID,MST.TIMETYPE TIMETYPEVALUE, MST.MATCHTYPE MATCHTYPEVALUE, NVL(MST.ACCTNO,'') FOACCTNO, nvl(mst.ISDISPOSAL,'N') ISDISPOSAL,mst.quoteqtty , mst.limitprice , mst.confirmed,
                  mst.tlid,mst.forefid
              FROM CFMAST, AFMAST CF, OOD, FOMAST MST, SECURITIES_INFO SYINFO,
                  ALLCODE CD1, ALLCODE CD2, ALLCODE CD3, ALLCODE CD4, ALLCODE CD5,
                  ALLCODE CD6, ALLCODE CD7, ALLCODE CD8 ,ALLCODE CD10 ,
                  ORDERSYS SYS,sbsecurities sb,
                  (SELECT A.FOACCTNO, SUM (B.ORDERQTTY) ORDERQTTY
                  FROM ROOTORDERMAP A, ODMAST B
                  WHERE A.ORDERID=B.ORDERID AND STATUS='A' GROUP BY A.FOACCTNO) ROOT,
                  tlprofiles tlpro--, ordermap MAP
              WHERE MST.ACCTNO=ROOT.FOACCTNO(+) AND MST.STATUS<>'A' AND substr(MST.EXECTYPE,1,1) <> 'C' AND substr(MST.EXECTYPE,1,1) <> 'A'
                    AND MST.DELTD='N' AND CF.ACCTNO=MST.AFACCTNO AND SYINFO.SYMBOL=MST.SYMBOL
                    AND MST.ACCTNO = p_acctno
                  --AND MST.AFACCTNO=V_PARAFILTER
                  AND MST.codeid= sb.codeid
                  AND MST.ACCTNO=OOD.ORGORDERID(+)
                  AND CD1.cdtype ='FO' AND CD1.CDNAME='STATUS' AND CD1.CDVAL=MST.status
                  AND SYS.SYSNAME='CONTROLCODE'  AND CFMAST.CUSTID=CF.CUSTID
                  AND CD2.cdtype ='OD' AND CD2.CDNAME='BUFEXECTYPE' AND CD2.CDVAL=MST.EXECTYPE||MST.MATCHTYPE
                  AND CD3.cdtype ='FO' AND CD3.CDNAME='BOOK' AND CD3.CDVAL=MST.BOOK
                  AND CD4.cdtype ='FO' AND CD4.CDNAME='TIMETYPE' AND CD4.CDVAL=MST.TIMETYPE
                  AND CD5.cdtype ='FO' AND CD5.CDNAME='MATCHTYPE' AND CD5.CDVAL=MST.MATCHTYPE
                  AND CD6.cdtype ='FO' AND CD6.CDNAME='NORK' AND CD6.CDVAL=MST.NORK
                  AND CD8.cdtype ='OD' AND CD8.CDNAME='VIA' AND CD8.CDVAL=MST.VIA
                  AND CD7.cdtype ='FO' AND CD7.CDNAME='PRICETYPE' AND CD7.CDVAL=MST.PRICETYPE
                  AND CD10.cdtype ='OD' AND CD10.CDNAME='TRADEPLACE' AND CD10.CDVAL=sb.TRADEPLACE
                   AND tlpro.tlid(+)= mst.tlid
                  --AND MAP.ORGORDERID(+)= ood.orgorderid
              ) DTL
          ORDER BY REFORDERID, TXDATE DESC, TXTIME DESC, ACCTNO;
          PLOG.debug(pkgctx,'End pr_gen_buf_od_account' || p_acctno);
    end if;
    --commit;

    plog.setendsection(pkgctx, 'pr_gen_buf_od_account');
EXCEPTION WHEN others THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_gen_buf_od_account');
END pr_gen_buf_od_account;


procedure pr_get_rightofflist(p_refcursor in out pkg_report.ref_cursor,p_afacctno in varchar2)
is
begin
    plog.setbeginsection(pkgctx, 'pr_get_rightofflist');
    Open p_refcursor FOR
        SELECT CA.*, CA.PENDINGQTTY - NVL(RQ.MSGQTTY,0) pqtty
        FROM
        (
           select CA.AFACCTNO, sb.symbol,ca.trade,ca.pbalance RETAILBAL,ca.pbalance pbalance,
            CASE WHEN ca.balance - ca.inbalance + ca.outbalance >0 THEN ca.balance - ca.inbalance + ca.outbalance ELSE 0 end orgbalance,
                ca.orgpbalance,ca.balance,
               ca.qtty regqtty, mst.exprice,mst.description,ca.pqtty*mst.exprice amt,sb.parvalue  ,
               to_date(varvalue,'dd/mm/rrrr') currdate,
               mst.camastid||to_char(ca.autoid) camastid, cd.cdcontent sectype, mst.duedate,mst.reportdate, mst.rightoffrate,mst.frdatetransfer,
               mst.todatetransfer,mst.begindate, ca.pbalance + ca.balance allbalance, ca.pqtty PENDINGQTTY
           from caschd ca, sbsecurities sb, allcode cd, camast mst,sysvar sy
           where mst.tocodeid = sb.codeid and ca.camastid = mst.camastid
               and cd.cdname ='SECTYPE' and cd.cdtype ='SA' and cd.cdval=sb.sectype
               AND ca.status IN( 'V','M') AND ca.status <>'Y' AND ca.deltd <> 'Y'
               AND mst.catype='014' --and ca.pbalance > 0 and ca.pqtty > 0
               --AND sb.sectype NOT IN ('004','009') -- Ko lay len cac CK quyen mua cho giao dich
               and sy.grname = 'SYSTEM' AND sy.varname = 'CURRDATE'
               and ca.afacctno = p_afacctno
               order by mst.begindate
        ) CA
        LEFT JOIN
        (
           SELECT msgacct, keyvalue, sum(NVL(MSGQTTY,0)) MSGQTTY FROM borqslog
               WHERE RQSTYP = 'CAR' AND STATUS IN ('W','P','H') AND msgacct = p_afacctno
               GROUP BY msgacct, keyvalue
        ) RQ
        ON CA.camastid = RQ.keyvalue AND CA.afacctno = RQ.msgacct;
    plog.setendsection(pkgctx, 'pr_get_rightofflist');
exception when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'pr_get_rightofflist');
end pr_get_rightofflist;


/*procedure pr_gen_buf_ci_account(p_acctno varchar2 default null)
  IS
  v_acctno varchar2(50);
  v_margintype char(1);
  v_actype varchar2(4);
  v_groupleader varchar2(10);

BEGIN
    plog.setBeginsection(pkgctx, 'pr_gen_buf_ci_account');
    PLOG.INFO(pkgctx,'Begin pr_gen_buf_ci_account');
    if p_acctno is null or p_acctno='ALL' then
        delete from buf_ci_account;
        commit;
        For rec in (
                    SELECT mst.acctno,MR.MRTYPE,af.actype,mst.groupleader
                    --into v_margintype,v_actype,v_groupleader
                    from afmast mst,aftype af, mrtype mr where mst.actype=af.actype and af.mrtype=mr.actype
                    order by mst.acctno
        )
        loop
            V_ACCTNO:=rec.acctno;
            v_margintype:=rec.MRTYPE;
            v_actype:=rec.actype;
            v_groupleader:=rec.groupleader;
            if v_margintype in ('N','L') then
                 --Tai khoan binh thuong khong Margin
                 INSERT INTO buf_ci_account (CUSTODYCD,ACTYPE,AFACCTNO,DESC_STATUS,LASTDATE,
                        BALANCE,INTBALANCE,DFDEBTAMT,CRINTACR,AAMT,BAMT,
                        EMKAMT,FLOATAMT,ODAMT,RECEIVING, NETTING, AVLADVANCE,MBLOCK,APMT,PAIDAMT,
                        ADVANCELINE,ADVLIMIT,MRIRATE,MRMRATE,MRLRATE,DEALPAIDAMT,
                        AVLWITHDRAW,BALDEFOVD,PP,AVLLIMIT,NAVACCOUNT,OUTSTANDING,
                        MARGINRATE,CIDEPOFEEACR,OVDCIDEPOFEE,
                        CASH_RECEIVING_T0,CASH_RECEIVING_T1,CASH_RECEIVING_T2,CASH_RECEIVING_T3,CASH_RECEIVING_TN,
                        CASH_SENDING_T0,CASH_SENDING_T1,CASH_SENDING_T2,CASH_SENDING_T3,CASH_SENDING_TN,CAREBY,
                        MRODAMT,T0ODAMT,DFODAMT,ACCOUNTTYPE,EXECBUYAMT,AUTOADV,AVLADV_T3,AVLADV_T1,AVLADV_T2,
                        CASH_PENDWITHDRAW,CASH_PENDTRANSFER,CASH_PENDING_SEND)
                 SELECT
                    cf.CUSTODYCD, mst.actype, mst.afacctno, cd1.cdcontent desc_status,mst.lastdate,
                        TRUNC (mst.balance)-nvl(al.secureamt,0)-NVL (al.advamt, 0) balance,
                        mst.balance intbalance, mst.DFDEBTAMT,
                        mst.crintacr, nvl(adv.aamt,0) aamt,
                        nvl(al.secureamt,0) + NVL (al.advamt, 0) bamt, mst.emkamt,mst.floatamt,
                        mst.odamt, mst.receiving, mst.netting,nvl(adv.avladvance,0) avlAdvance, mst.mblock,
                        nvl(adv.advanceamount,0) apmt,nvl(adv.paidamt,0) paidamt,
                        af.advanceline,nvl(af.mrcrlimitmax,0) advlimit, af.mrirate,af.mrmrate,af.mrlrate,
                        nvl(pd.dealpaidamt,0) dealpaidamt,
                        greatest(nvl(adv.avladvance,0) + mst.balance - nvl(al.secureamt,0) - mst.odamt - mst.dfdebtamt - mst.dfintdebtamt - NVL (al.advamt, 0)-nvl(pd.dealpaidamt,0)-nvl(mst.depofeeamt,0),0) avlwithdraw ,
                        greatest( (case when autoadv = 'Y' then nvl(adv.avladvance,0) else 0 end) + balance- odamt- mst.dfdebtamt - mst.dfintdebtamt - NVL (advamt, 0)-nvl(secureamt,0) - ramt-nvl(pd.dealpaidamt,0) - nvl(mst.depofeeamt,0),0) baldefovd,
                        greatest(nvl(adv.avladvance,0) + af.advanceline + mst.balance- mst.odamt - mst.dfdebtamt - mst.dfintdebtamt- nvl (al.advamt, 0)-nvl(al.secureamt,0) - mst.ramt - nvl(mst.depofeeamt,0),0) pp,
                        nvl(adv.avladvance,0) + af.mrcrlimitmax-mst.dfodamt + af.advanceline + mst.balance- mst.odamt- mst.dfdebtamt - mst.dfintdebtamt - nvl (al.overamt, 0)-nvl(al.secureamt,0) - mst.ramt-nvl(mst.depofeeamt,0) avllimit,
                        nvl(af.MRCLAMT,0) +  nvl(se.SEASS,0)  NAVACCOUNT,
                        mst.balance+ nvl(adv.avladvance,0)- mst.odamt - mst.dfdebtamt - mst.dfintdebtamt- NVL (al.advamt, 0)-nvl(al.secureamt,0) - mst.ramt-nvl(mst.depofeeamt,0) OUTSTANDING,
                        round((case when mst.balance+nvl(adv.avladvance,0)- mst.odamt- mst.dfdebtamt - mst.dfintdebtamt - NVL (al.advamt, 0)-nvl(al.secureamt,0) - mst.ramt-nvl(mst.depofeeamt,0)>=0 then 100000
                        else (nvl(af.MRCLAMT,0) + nvl(se.SEASS,0) + nvl(adv.avladvance,0))/ abs(mst.balance+nvl(adv.avladvance,0)- mst.odamt- mst.dfdebtamt - mst.dfintdebtamt - NVL (al.advamt, 0)-nvl(al.secureamt,0) - mst.ramt-nvl(mst.depofeeamt,0)) end),4) * 100 MARGINRATE,
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
                        nvl(ln.mrodamt,0) MRODAMT,nvl(ln.t0odamt,0) T0ODAMT,nvl(dfg.dfamt,0) DFODAMT, (case when cf.custatcom ='N' then 'O' when af.corebank ='Y' then 'B' else 'C' end)ACCOUNTTYPE, --Se tinh day gia tri chinh xac vao sau
                        nvl(al.EXECBUYAMT,0) EXECBUYAMT, af.AUTOADV, nvl(advdtl.AVLADV_T3,0) AVLADV_T3, nvl(advdtl.avladv_t1,0) avladv_t1,
                        nvl(advdtl.avladv_t2,0) avladv_t2, nvl(pw.pdwithdraw,0) pdwithdraw, nvl(pdtrf.pdtrfamt,0) pdtrfamt,
                        nvl(al.secureamt,0)+NVL (al.advamt,0)+nvl(CASH_SENDING_T0,0)+nvl(CASH_SENDING_T1,0)+nvl(ST.BUY_FEEACR,0)
                        - nvl(ST.EXECAMTINDAY,0)+nvl(pw.pdwithdraw,0)+nvl(pdtrf.pdtrfamt,0) CASH_PENDING_SEND
                   FROM cimast mst inner join afmast af on af.acctno = mst.afacctno AND mst.acctno = V_ACCTNO
                        inner join sbcurrency ccy on ccy.ccycd = mst.ccycd
                        INNER JOIN cfmast cf ON cf.custid = af.custid
                        inner join (select * from allcode cd1  where cd1.cdtype = 'CI' AND cd1.cdname = 'STATUS') cd1 on mst.status = cd1.cdval
                        left join
                        (select * from v_getbuyorderinfo where afacctno = V_ACCTNO) al
                         on mst.acctno = al.afacctno
                        LEFT JOIN
                        (select * from v_getsecmargininfo where afacctno = V_ACCTNO) SE
                        on se.afacctno = mst.acctno
                        LEFT JOIN
                        (select aamt,depoamt avladvance, advamt advanceamount,afacctno, paidamt from v_getAccountAvlAdvance where afacctno = V_ACCTNO) adv
                        on adv.afacctno=MST.acctno
                        LEFT JOIN
                        (select * from v_getdealpaidbyaccount p where p.afacctno = V_ACCTNO) pd
                        on pd.afacctno=mst.acctno
                        LEFT JOIN
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
                                sum(NVL(CASE WHEN ST.DUETYPE='RS' AND ST.TRFDAY=1 THEN ST.EXECAMTINDAY ELSE 0 END,0)) EXECAMTINDAY
                        FROM
                            VW_BD_PENDING_SETTLEMENT ST WHERE (DUETYPE='RM' OR DUETYPE='SM' OR DUETYPE = 'RS') AND ST.AFACCTNO = V_ACCTNO
                        GROUP BY AFACCTNO) ST
                        on ST.AFACCTNO=MST.acctno
                        left join
                        (select     df.afacctno, sum(
                                ln.PRINNML + ln.PRINOVD + round(ln.INTNMLACR,0) + round(ln.INTOVDACR,0) +
                                round(ln.INTNMLOVD,0)+round(ln.INTDUE,0)+
                                ln.OPRINNML+ln.OPRINOVD+round(ln.OINTNMLACR,0)+round(ln.OINTOVDACR,0)+round(ln.OINTNMLOVD,0) +
                                round(ln.OINTDUE,0)+round(ln.FEE,0)+round(ln.FEEDUE,0)+round(ln.FEEOVD,0) +
                                round(ln.FEEINTNMLACR,0) + round(ln.FEEINTOVDACR,0) +round(ln.FEEINTNMLOVD,0)+round(ln.FEEINTDUE,0)
                                ) dfAMT
                         from dfgroup df, lnmast ln
                        where df.lnacctno = ln.acctno
                        group by afacctno) dfg
                        on dfg.AFACCTNO=MST.acctno
                        left join
                        (
                        select trfacctno afacctno,
                            sum(ln.PRINNML + ln.PRINOVD + ln.INTNMLACR + ln.INTOVDACR +
                            ln.INTNMLOVD+ln.INTDUE) mrodamt,
                            sum(ln.OPRINNML+ln.OPRINOVD+ln.OINTNMLACR+ln.OINTOVDACR+
                            ln.OINTNMLOVD+ln.OINTDUE) t0odamt
                            from lnmast ln
                            where ftype ='AF'
                            and ln.PRINNML + ln.PRINOVD + ln.INTNMLACR + ln.INTOVDACR +
                            ln.INTNMLOVD+ln.INTDUE + ln.OPRINNML+ln.OPRINOVD+ln.OINTNMLACR+ln.OINTOVDACR+
                            ln.OINTNMLOVD+ln.OINTDUE >0
                            group by trfacctno
                        ) ln
                        on ln.AFACCTNO=MST.acctno
                        LEFT JOIN
                        (
                            SELECT sts.afacctno,
                                sum(CASE WHEN fn_get_nextdate(sts.currdate,2) = sts.cleardate THEN sts.avladvamt ELSE 0 END) avladv_t2,
                                sum(CASE WHEN fn_get_nextdate(sts.currdate,1) = sts.cleardate THEN sts.avladvamt ELSE 0 END) avladv_t1,
                                sum(CASE WHEN fn_get_nextdate(sts.currdate,3) = sts.cleardate THEN sts.avladvamt ELSE 0 END) AVLADV_T3
                            FROM v_advanceSchedule sts
                            WHERE afacctno = V_ACCTNO
                            GROUP BY sts.afacctno
                        ) advdtl
                        ON mst.acctno = advdtl.afacctno
                        LEFT JOIN
                        (
                            SELECT tl.msgacct, sum(tl.msgamt) pdwithdraw
                            FROM tllog tl
                            WHERE tl.tltxcd IN ('1100','1121','1110','1144','1199') AND tl.txstatus = '4' AND tl.deltd = 'N'
                                AND tl.msgacct = V_ACCTNO
                            GROUP BY tl.msgacct
                        ) pw
                        ON mst.acctno = pw.msgacct
                        LEFT JOIN
                        (
                            SELECT cir.acctno, sum(amt+feeamt) pdtrfamt
                            FROM ciremittance cir
                            WHERE cir.rmstatus = 'P' AND cir.deltd = 'N'
                                AND cir.acctno = V_ACCTNO
                            GROUP BY cir.acctno
                        ) pdtrf
                        ON mst.acctno = pdtrf.acctno
                        ;

             elsif v_margintype in ('S','T') and (length(v_groupleader)=0 or v_groupleader is null) then
                             --Tai khoan margin khong tham gia group
                INSERT INTO buf_ci_account (CUSTODYCD,ACTYPE,AFACCTNO,DESC_STATUS,LASTDATE,
                        BALANCE,INTBALANCE,DFDEBTAMT,CRINTACR,AAMT,BAMT,
                        EMKAMT,FLOATAMT,ODAMT,RECEIVING, NETTING, AVLADVANCE,MBLOCK,APMT,PAIDAMT,
                        ADVANCELINE,ADVLIMIT,MRIRATE,MRMRATE,MRLRATE,DEALPAIDAMT,
                        AVLWITHDRAW,BALDEFOVD,PP,AVLLIMIT,NAVACCOUNT,OUTSTANDING,
                        MARGINRATE,CIDEPOFEEACR,OVDCIDEPOFEE,
                        CASH_RECEIVING_T0,CASH_RECEIVING_T1,CASH_RECEIVING_T2,CASH_RECEIVING_T3,CASH_RECEIVING_TN,
                        CASH_SENDING_T0,CASH_SENDING_T1,CASH_SENDING_T2,CASH_SENDING_T3,CASH_SENDING_TN,CAREBY,
                        MRODAMT,T0ODAMT,DFODAMT,ACCOUNTTYPE,EXECBUYAMT,AUTOADV,AVLADV_T3,AVLADV_T1,AVLADV_T2,
                        CASH_PENDWITHDRAW,CASH_PENDTRANSFER,CASH_PENDING_SEND)
                SELECT
                    CUSTODYCD,ACTYPE,CI.AFACCTNO,DESC_STATUS,LASTDATE,
                    BALANCE,INTBALANCE,DFDEBTAMT,CRINTACR,AAMT,BAMT,
                    EMKAMT,FLOATAMT,ODAMT,RECEIVING,NETTING,AVLADVANCE,MBLOCK,APMT,PAIDAMT,ADVANCELINE,
                    ADVLIMIT,MRIRATE,MRMRATE,MRLRATE,
                    DEALPAIDAMT,
                     TRUNC(
                         GREATEST(
                             (CASE WHEN MRIRATE>0 THEN greatest(least(NAVACCOUNT*100/MRIRATE + OUTSTANDING,AVLLIMIT-advanceline),0) ELSE NAVACCOUNT + OUTSTANDING END)
                         ,0) - DEALPAIDAMT
                     ,0) AVLWITHDRAW,
                     greatest(case when chksysctrl = 'Y' then
                         least(
                             trunc(mrBALDEFOVD,0)
                         ,
                             TRUNC(
                                 (CASE WHEN MRIRATE>0  THEN LEAST((100* NAVACCOUNT + OUTSTANDING * MRIRATE)/MRIRATE,BALDEFOVD,AVLLIMIT-advanceline) ELSE BALDEFOVD-advanceline END)
                                 -DEALPAIDAMT
                             ,0))
                     else
                         TRUNC(
                             (CASE WHEN MRIRATE>0  THEN LEAST((100* NAVACCOUNT + OUTSTANDING * MRIRATE)/MRIRATE,BALDEFOVD,AVLLIMIT-advanceline) ELSE BALDEFOVD-advanceline END)
                             -DEALPAIDAMT
                         ,0)
                     end,0) BALDEFOVD,
                     PP,AVLLIMIT,NAVACCOUNT,OUTSTANDING,
                     MARGINRATE,cidepofeeacr,
                     depofeeamt OVDCIDEPOFEE,
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
                      CAREBY,
                      nvl(ln.mrodamt,0) MRODAMT,nvl(ln.t0odamt,0) T0ODAMT,nvl(dfg.dfamt,0) DFODAMT,ACCOUNTTYPE,
                      EXECBUYAMT, AUTOADV, AVLADV_T3, avladv_t1,
                      avladv_t2, pdwithdraw, pdtrfamt,
                      BAMT+nvl(CASH_SENDING_T0,0)+nvl(CASH_SENDING_T1,0)+nvl(ST.BUY_FEEACR,0)
                        - nvl(ST.EXECAMTINDAY,0)+pdwithdraw+pdtrfamt CASH_PENDING_SEND
                 FROM (
                 SELECT cf.CUSTODYCD,AF.advanceline,mst.actype, mst.acctno, mst.afacctno, mst.ccycd, mst.lastdate,
                        (mst.ramt - mst.aamt) cipamt, af.tradeline, TRUNC (mst.balance)-nvl(se.secureamt,0) balance,
                        mst.balance intbalance, mst.DFDEBTAMT,
                        mst.cramt, mst.dramt, mst.avrbal, mst.mdebit, mst.mcredit,
                        mst.crintacr, mst.odintacr, mst.adintacr, mst.minbal, nvl(se.aamt,0) aamt,
                        mst.ramt, nvl(se.secureamt,0) bamt, mst.emkamt,mst.floatamt, mst.odlimit, mst.mmarginbal,
                        mst.marginbal, mst.odamt, receiving, netting,nvl(se.avladvance,0) avladvance, mst.mblock, ccy.shortcd,
                        cd1.cdcontent desc_status, nvl(se.advanceamount,0) apmt,nvl(se.paidamt,0) paidamt,
                        nvl(af.mrcrlimitmax,0) advlimit, af.mrirate,af.mrmrate,af.mrlrate,
                        nvl(dealpaidamt,0) dealpaidamt,
                        nvl(se.avladvance,0) + mst.balance - nvl(se.secureamt,0) - mst.odamt - mst.dfdebtamt - mst.dfintdebtamt- mst.dfdebtamt - mst.dfintdebtamt - NVL (se.advamt, 0)-nvl(dealpaidamt,0) -nvl(mst.depofeeamt,0) avlwithdraw ,
                        nvl(se.avladvance,0) + balance - mst.ovamt - mst.dueamt  - mst.dfdebtamt - mst.dfintdebtamt - ramt - nvl(dealpaidamt,0) - mst.depofeeamt
                             - greatest(nvl(se.overamt,0) + nvl(se.secureamt,0) + nvl(OVDAF.MARGINAMT,0) - se.seass,0) baldefovd,
                        trunc(greatest(least(
                                      nvl(nvl(se.avladvance,0) + balance - mst.ovamt - mst.dueamt - ramt - dfdebtamt - dfintdebtamt - nvl(se.dealpaidamt,0)  - mst.depofeeamt,0)
                                             - greatest(nvl(se.overamt,0) + nvl(se.secureamt,0) + nvl(OVDAF.MARGINAMT,0) - se.semrass,0),
                                         case when odamt > 0 then (se.MARGINRATIO - se.MRIRATIO/100) * (se.serealass) + greatest(0,se.outstanding)
                                         else nvl(nvl(se.avladvance,0) + balance - mst.ovamt - mst.dueamt - ramt - dfdebtamt - dfintdebtamt - nvl(se.dealpaidamt,0) - mst.depofeeamt,0)
                                                     - greatest(nvl(se.overamt,0) + nvl(se.secureamt,0) + nvl(OVDAF.MARGINAMT,0) - se.semrass,0)
                                     end,
                                     se.avlmrlimit - af.advanceline
                                    ),0),0) mrbaldefovd,
                        case when chksysctrl = 'Y' then
                             nvl(mst.balance - nvl(secureamt,0) + nvl(se.avladvance,0) + af.advanceline + least(nvl(af.mrcrlimitmax,0),nvl(af.mrcrlimit,0) + nvl(se.semramt,0)) - nvl(mst.odamt,0) - mst.dfdebtamt - mst.dfintdebtamt  - mst.depofeeamt,0)
                        else
                             nvl(mst.balance - nvl(secureamt,0) + nvl(se.avladvance,0) + af.advanceline + least(nvl(af.mrcrlimitmax,0),nvl(af.mrcrlimit,0) + nvl(se.seamt,0)) - nvl(mst.odamt,0) - mst.dfdebtamt - mst.dfintdebtamt  - mst.depofeeamt,0)
                        end pp,
                        nvl(se.avladvance,0) + af.advanceline + nvl(af.mrcrlimitmax,0)-mst.dfodamt + mst.balance- mst.odamt - mst.dfdebtamt - mst.dfintdebtamt - nvl (se.overamt, 0)-nvl(se.secureamt,0) - mst.ramt- mst.depofeeamt avllimit,
                        nvl(af.MRCRLIMIT,0) +  nvl(se.SEASS,0)  NAVACCOUNT,
                        mst.balance+ nvl(se.avladvance,0)- mst.odamt- mst.dfdebtamt - mst.dfintdebtamt - NVL (se.advamt, 0)-nvl(se.secureamt,0) - mst.ramt- mst.depofeeamt OUTSTANDING,
                        round((case when mst.balance + nvl(se.avladvance,0) - mst.odamt- mst.dfdebtamt - mst.dfintdebtamt - NVL (se.advamt, 0)-nvl(se.secureamt,0) - mst.ramt- mst.depofeeamt>=0 then 100000
                        else (nvl(af.MRCRLIMIT,0) + nvl(se.SEASS,0))/ abs(mst.balance+ nvl(se.avladvance,0)- mst.odamt- mst.dfdebtamt - mst.dfintdebtamt - NVL (se.advamt, 0)-nvl(se.secureamt,0) - mst.ramt-mst.depofeeamt) end),4) * 100 MARGINRATE,
                        se.chksysctrl, (se.MARGINRATIO * 100) MARGINRATIO, mst.cidepofeeacr,mst.depofeeamt, af.careby,
                        0 MRODAMT,0 T0ODAMT,0 DFODAMT, (case when cf.custatcom ='N' then 'O' when af.corebank ='Y' then 'B' else 'C' end)ACCOUNTTYPE,
                        nvl(se.EXECBUYAMT,0) EXECBUYAMT, af.AUTOADV, nvl(advdtl.AVLADV_T3,0) AVLADV_T3, nvl(advdtl.avladv_t1,0) avladv_t1,
                        nvl(advdtl.avladv_t2,0) avladv_t2, nvl(pw.pdwithdraw,0) pdwithdraw, nvl(pdtrf.pdtrfamt,0) pdtrfamt
                   FROM cimast mst inner join afmast af on af.acctno = mst.afacctno AND mst.acctno = V_ACCTNO
                        INNER JOIN aftype aft ON aft.actype = af.actype
                        INNER JOIN mrtype mrt ON aft.mrtype = mrt.actype and mrt.mrtype IN ('S','T')
                        inner join sbcurrency ccy on ccy.ccycd = mst.ccycd
                        INNER JOIN cfmast cf ON cf.custid = af.custid
                        inner join (select * from allcode cd1  where cd1.cdtype = 'CI' AND cd1.cdname = 'STATUS') cd1 on mst.status = cd1.cdval
                        left join (select * from v_getsecmarginratio where afacctno = V_ACCTNO) se on se.afacctno = mst.acctno
                        left join (select TRFACCTNO, nvl(sum(ln.PRINOVD + ln.INTOVDACR + ln.INTNMLOVD + ln.OPRINOVD + ln.OPRINNML + ln.OINTNMLOVD + ln.OINTOVDACR+ln.OINTDUE+ln.OINTNMLACR + nvl(lns.nml,0) + nvl(lns.intdue,0)),0) OVDAMT,
                                            nvl(sum(ln.PRINNML + ln.PRINOVD + ln.INTOVDACR + ln.INTNMLOVD + ln.INTNMLACR + ln.INTDUE),0) MARGINAMT
                                         from lnmast ln, (select acctno, sum(nml) nml, sum(intdue) intdue  from lnschd
                                                             where reftype = 'P' and  overduedate = to_date(cspks_system.fn_get_sysvar('SYSTEM','CURRDATE'),'DD/MM/RRRR') group by acctno) lns
                                         where ln.acctno = lns.acctno(+) and ln.ftype = 'AF'
                                         group by ln.trfacctno) OVDAF on OVDAF.TRFACCTNO = mst.acctno
                        LEFT JOIN
                        (
                            SELECT sts.afacctno,
                                sum(CASE WHEN fn_get_nextdate(sts.currdate,2) = sts.cleardate THEN sts.avladvamt ELSE 0 END) avladv_t2,
                                sum(CASE WHEN fn_get_nextdate(sts.currdate,1) = sts.cleardate THEN sts.avladvamt ELSE 0 END) avladv_t1,
                                sum(CASE WHEN fn_get_nextdate(sts.currdate,3) = sts.cleardate THEN sts.avladvamt ELSE 0 END) AVLADV_T3
                            FROM v_advanceSchedule sts
                            WHERE afacctno = V_ACCTNO
                            GROUP BY sts.afacctno
                        ) advdtl
                        ON mst.acctno = advdtl.afacctno
                        LEFT JOIN
                        (
                            SELECT tl.msgacct, sum(tl.msgamt) pdwithdraw
                            FROM tllog tl
                            WHERE tl.tltxcd IN ('1100','1121','1110','1144','1199') AND tl.txstatus = '4' AND tl.deltd = 'N'
                                AND tl.msgacct = V_ACCTNO
                            GROUP BY tl.msgacct
                        ) pw
                        ON mst.acctno = pw.msgacct
                        LEFT JOIN
                        (
                            SELECT cir.acctno, sum(amt+feeamt) pdtrfamt
                            FROM ciremittance cir
                            WHERE cir.rmstatus = 'P' AND cir.deltd = 'N'
                                AND cir.acctno = V_ACCTNO
                            GROUP BY cir.acctno
                        ) pdtrf
                        ON mst.acctno = pdtrf.acctno
                        ) ci
                    LEFT JOIN
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
                                sum(NVL(CASE WHEN ST.DUETYPE='RS' AND ST.TRFDAY=1 THEN ST.EXECAMTINDAY ELSE 0 END,0)) EXECAMTINDAY
                        FROM
                            VW_BD_PENDING_SETTLEMENT ST WHERE (DUETYPE='RM' OR DUETYPE='SM' OR DUETYPE = 'RS') AND ST.AFACCTNO = V_ACCTNO
                        GROUP BY AFACCTNO) ST
                    on ST.AFACCTNO=CI.acctno
                    left join
                     (select     df.afacctno, sum(
                             ln.PRINNML + ln.PRINOVD + round(ln.INTNMLACR,0) + round(ln.INTOVDACR,0) +
                             round(ln.INTNMLOVD,0)+round(ln.INTDUE,0)+
                             ln.OPRINNML+ln.OPRINOVD+round(ln.OINTNMLACR,0)+round(ln.OINTOVDACR,0)+round(ln.OINTNMLOVD,0) +
                             round(ln.OINTDUE,0)+round(ln.FEE,0)+round(ln.FEEDUE,0)+round(ln.FEEOVD,0) +
                             round(ln.FEEINTNMLACR,0) + round(ln.FEEINTOVDACR,0) +round(ln.FEEINTNMLOVD,0)+round(ln.FEEINTDUE,0)
                             ) dfAMT
                      from dfgroup df, lnmast ln
                     where df.lnacctno = ln.acctno
                     group by afacctno) dfg
                     on dfg.AFACCTNO=ci.acctno
                    left join
                        (
                        select trfacctno afacctno,
                            sum(ln.PRINNML + ln.PRINOVD + ln.INTNMLACR + ln.INTOVDACR +
                            ln.INTNMLOVD+ln.INTDUE) mrodamt,
                            sum(ln.OPRINNML+ln.OPRINOVD+ln.OINTNMLACR+ln.OINTOVDACR+
                            ln.OINTNMLOVD+ln.OINTDUE) t0odamt
                            from lnmast ln
                            where ftype ='AF'
                            and ln.PRINNML + ln.PRINOVD + ln.INTNMLACR + ln.INTOVDACR +
                            ln.INTNMLOVD+ln.INTDUE + ln.OPRINNML+ln.OPRINOVD+ln.OINTNMLACR+ln.OINTOVDACR+
                            ln.OINTNMLOVD+ln.OINTDUE >0
                            group by trfacctno
                        ) ln
                        on ln.AFACCTNO=ci.acctno
                        ;
             else
                 --Tai khoan margin join theo group

                   INSERT INTO buf_ci_account (CUSTODYCD,ACTYPE,AFACCTNO,DESC_STATUS,LASTDATE,
                      BALANCE,INTBALANCE,DFDEBTAMT,CRINTACR,AAMT,BAMT,
                      EMKAMT,FLOATAMT,ODAMT,RECEIVING, NETTING, AVLADVANCE,MBLOCK,APMT,PAIDAMT,
                      ADVANCELINE,ADVLIMIT,MRIRATE,MRMRATE,MRLRATE,DEALPAIDAMT,
                      AVLWITHDRAW,BALDEFOVD,PP,AVLLIMIT,NAVACCOUNT,OUTSTANDING,
                      MARGINRATE,CIDEPOFEEACR,OVDCIDEPOFEE,
                      CASH_RECEIVING_T0,CASH_RECEIVING_T1,CASH_RECEIVING_T2,CASH_RECEIVING_T3,CASH_RECEIVING_TN,
                      CASH_SENDING_T0,CASH_SENDING_T1,CASH_SENDING_T2,CASH_SENDING_T3,CASH_SENDING_TN,CAREBY,
                      MRODAMT,T0ODAMT,DFODAMT,ACCOUNTTYPE,EXECBUYAMT,AUTOADV,AVLADV_T3,AVLADV_T1,AVLADV_T2,
                        CASH_PENDWITHDRAW,CASH_PENDTRANSFER,CASH_PENDING_SEND)
                   select cf.CUSTODYCD,ci.actype, MST.AFACCTNO, cd1.cdcontent desc_status,ci.lastdate,
                       MST.BALANCE,MST.INTBALANCE,mst.DFDEBTAMT,MST.CRINTACR,MST.AAMT,MST.BAMT,
                       MST.EMKAMT,MST.FLOATAMT,MST.ODAMT,MST.RECEIVING, MST.NETTING, MST.AVLADVANCE,MST.MBLOCK,MST.APMT,PAIDAMT,AF.ADVANCELINE,
                       MST.ADVLIMIT, af.mrirate,af.mrmrate,af.mrlrate,
                       nvl(pd.dealpaidamt,0) DEALPAIDAMT,
                               TRUNC(GREATEST((CASE WHEN mst.mstmrirate>0 THEN greatest(least(NAVACCOUNT*100/mst.mstmrirate + (OUTSTANDING),AVLLIMIT),0) ELSE NAVACCOUNT + OUTSTANDING END),0),0) AVLWITHDRAW,
                               TRUNC((CASE WHEN mst.mstmrirate>0
                                       THEN GREATEST(LEAST((100* NAVACCOUNT + OUTSTANDING * mst.mstmrirate)/mst.mstmrirate,
                                                   --BALDEFOVD,
                                                   nvl(adv.avladvance,0) +ci.balance- ci.ovamt-ci.dueamt - ci.ramt-af.advanceline,
                                                   AVLLIMIT),0)
                                        ELSE BALDEFOVD END),0) BALDEFOVD,
                       greatest(AF.ADVANCELINE+ MST.PP,0) PP,
                       AF.ADVANCELINE+ MST.AVLLIMIT AVLLIMIT,MST.NAVACCOUNT,
                       AF.ADVANCELINE+ MST.OUTSTANDING OUTSTANDING,
                       round((case when MST.OUTSTANDING>=0 then 100000
                                      else MST.NAVACCOUNT/ abs(MST.OUTSTANDING) end),4) * 100 MARGINRATE,
                       mst.cidepofeeacr,
                       mst.depofeeamt OVDCIDEPOFEE,
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
                      AF.CAREBY,
                      nvl(ln.mrodamt,0) MRODAMT,nvl(ln.t0odamt,0) T0ODAMT,nvl(dfg.dfamt,0) DFODAMT, (case when cf.custatcom ='N' then 'O' when af.corebank ='Y' then 'B' else 'C' end)ACCOUNTTYPE,
                      EXECBUYAMT, af.AUTOADV, AVLADV_T3, avladv_t1,
                      avladv_t2, pdwithdraw, pdtrfamt,
                      MST.BAMT+nvl(CASH_SENDING_T0,0)+nvl(CASH_SENDING_T1,0)+nvl(ST.BUY_FEEACR,0)
                        - nvl(ST.EXECAMTINDAY,0)+pdwithdraw+pdtrfamt CASH_PENDING_SEND
                   from
                        (SELECT V_ACCTNO afacctno,sum((mst.ramt - mst.aamt)) cipamt, sum(af.tradeline) tradeline , sum(TRUNC (mst.balance)-nvl(al.secureamt,0)) balance,
                                       sum(mst.balance) intbalance,sum(mst.DFDEBTAMT)  DFDEBTAMT,
                                       sum(mst.cramt) cramt, sum(mst.dramt) dramt, sum(mst.avrbal) avrbal, sum(mst.mdebit) mdebit, sum(mst.mcredit) mcredit,
                                      sum(mst.crintacr) crintacr, sum(mst.odintacr) odintacr, sum(mst.adintacr) adintacr, sum(mst.minbal) minbal, sum(nvl(adv.aamt,0)) aamt,
                                      sum(mst.ramt) ramt, sum(nvl(al.secureamt,0)) bamt, sum(mst.emkamt) emkamt,sum(mst.floatamt) floatamt, sum(mst.odlimit) odlimit, sum(mst.mmarginbal) mmarginbal,
                                      sum(mst.marginbal) marginbal, sum(mst.odamt) odamt, sum(mst.receiving) receiving, sum(mst.netting) netting,sum(nvl(adv.avladvance,0)) avladvance, sum(mst.mblock) mblock,
                                      sum(nvl(adv.advanceamount,0)) apmt,sum(nvl(adv.paidamt,0)) paidamt,
                                      sum(NVL (af.mrcrlimitmax, 0)) ADVLIMIT,
                                      sum(nvl(adv.avladvance,0) + mst.balance - nvl(al.secureamt,0) - mst.odamt- mst.dfdebtamt - mst.dfintdebtamt - NVL (al.advamt, 0)-mst.depofeeamt) avlwithdraw ,
                                      greatest(SUM(nvl(adv.avladvance,0) + balance- ovamt-dueamt - mst.dfdebtamt - mst.dfintdebtamt- ramt - mst.depofeeamt),0) baldefovd,
                                      least(sum((nvl(af.mrcrlimit,0) + nvl(se.seamt,0)+
                                                   nvl(adv.avladvance,0)))
                                           ,sum(nvl(adv.avladvance,0) + greatest(nvl(af.mrcrlimitmax,0)-mst.dfodamt,0)))
                                      + sum(mst.balance- mst.odamt - mst.dfdebtamt - mst.dfintdebtamt- nvl (al.advamt, 0)-nvl(al.secureamt,0) - mst.ramt-mst.depofeeamt) pp,
                                      sum(nvl(adv.avladvance,0) + nvl(af.mrcrlimitmax,0)-mst.dfodamt + mst.balance- mst.odamt - mst.dfdebtamt - mst.dfintdebtamt- nvl (al.overamt, 0)-nvl(al.secureamt,0) - mst.ramt-mst.depofeeamt) avllimit,
                                      sum(nvl(af.MRCRLIMIT,0) +  nvl(se.SEASS,0))  NAVACCOUNT,
                                      sum(mst.balance+ nvl(adv.avladvance,0)- mst.odamt - mst.dfdebtamt - mst.dfintdebtamt- NVL (al.advamt, 0)-nvl(al.secureamt,0) - mst.ramt- mst.depofeeamt) OUTSTANDING,
                                      sum(case when af.acctno <> v_groupleader then 0 else af.mrirate end) mstmrirate,
                                      sum(mst.cidepofeeacr) cidepofeeacr,
                                      sum(mst.depofeeamt) depofeeamt,
                                      sum(nvl(al.EXECBUYAMT,0)) EXECBUYAMT,
                                      nvl(advdtl.AVLADV_T3,0) AVLADV_T3, nvl(advdtl.avladv_t1,0) avladv_t1,
                                    nvl(advdtl.avladv_t2,0) avladv_t2, nvl(pw.pdwithdraw,0) pdwithdraw, nvl(pdtrf.pdtrfamt,0) pdtrfamt

                        FROM cimast mst
                        inner join afmast af on af.acctno = mst.afacctno AND af.groupleader=v_groupleader
                        left join
                        (select b.* from v_getbuyorderinfo  b, afmast af where b.afacctno =af.acctno and af.groupleader=v_groupleader) al
                         on mst.acctno = al.afacctno
                        LEFT JOIN
                        (select b.* from v_getsecmargininfo b, afmast af where b.afacctno =af.acctno and af.groupleader=v_groupleader) se
                        on se.afacctno=MST.acctno
                        LEFT JOIN
                        (select sum(aamt) aamt,sum(depoamt) avladvance, sum(advamt) advanceamount ,afacctno, sum(paidamt) paidamt from v_getAccountAvlAdvance b, afmast af where b.afacctno =af.acctno and af.groupleader = v_groupleader group by b.afacctno) adv
                        on adv.afacctno=MST.acctno
                        LEFT JOIN
                        (
                            SELECT sts.afacctno,
                                sum(CASE WHEN fn_get_nextdate(sts.currdate,2) = sts.cleardate THEN sts.avladvamt ELSE 0 END) avladv_t2,
                                sum(CASE WHEN fn_get_nextdate(sts.currdate,1) = sts.cleardate THEN sts.avladvamt ELSE 0 END) avladv_t1,
                                sum(CASE WHEN fn_get_nextdate(sts.currdate,3) = sts.cleardate THEN sts.avladvamt ELSE 0 END) AVLADV_T3
                            FROM v_advanceSchedule sts
                            WHERE afacctno = V_ACCTNO
                            GROUP BY sts.afacctno
                        ) advdtl
                        ON mst.acctno = advdtl.afacctno
                        LEFT JOIN
                        (
                            SELECT tl.msgacct, sum(tl.msgamt) pdwithdraw
                            FROM tllog tl
                            WHERE tl.tltxcd IN ('1100','1121','1110','1144','1199') AND tl.txstatus = '4' AND tl.deltd = 'N'
                                AND tl.msgacct = V_ACCTNO
                            GROUP BY tl.msgacct
                        ) pw
                        ON mst.acctno = pw.msgacct
                        LEFT JOIN
                        (
                            SELECT cir.acctno, sum(amt+feeamt) pdtrfamt
                            FROM ciremittance cir
                            WHERE cir.rmstatus = 'P' AND cir.deltd = 'N'
                                AND cir.acctno = V_ACCTNO
                            GROUP BY cir.acctno
                        ) pdtrf
                        ON mst.acctno = pdtrf.acctno
                        ) MST, afmast af, cfmast cf,cimast ci,
                                      sbcurrency ccy ,
                                       allcode cd1,
                     (select * from v_getdealpaidbyaccount p where p.afacctno = V_ACCTNO) pd,
                     (select depoamt avladvance,afacctno from v_getAccountAvlAdvance where afacctno = V_ACCTNO ) adv,
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
                                sum(NVL(CASE WHEN ST.DUETYPE='RS' AND ST.TRFDAY=1 THEN ST.EXECAMTINDAY ELSE 0 END,0)) EXECAMTINDAY
                        FROM
                            VW_BD_PENDING_SETTLEMENT ST WHERE (DUETYPE='RM' OR DUETYPE='SM' OR DUETYPE = 'RS') AND ST.AFACCTNO = V_ACCTNO
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
                                sum(ln.PRINNML + ln.PRINOVD + ln.INTNMLACR + ln.INTOVDACR +
                                ln.INTNMLOVD+ln.INTDUE) mrodamt,
                                sum(ln.OPRINNML+ln.OPRINOVD+ln.OINTNMLACR+ln.OINTOVDACR+
                                ln.OINTNMLOVD+ln.OINTDUE) t0odamt
                            from lnmast ln
                            where ftype ='AF'
                                and ln.PRINNML + ln.PRINOVD + ln.INTNMLACR + ln.INTOVDACR +
                                ln.INTNMLOVD+ln.INTDUE + ln.OPRINNML+ln.OPRINOVD+ln.OINTNMLACR+ln.OINTOVDACR+
                                ln.OINTNMLOVD+ln.OINTDUE >0
                            group by trfacctno
                        ) ln

                   where mst.afacctno =af.acctno and af.custid=cf.custid
                   and mst.afacctno=pd.afacctno(+)
                   and mst.afacctno=ci.afacctno and ccy.ccycd = ci.ccycd
                   and cd1.cdtype = 'CI' AND cd1.cdname = 'STATUS'
                   and ci.status = cd1.cdval
                   and adv.afacctno(+)=MST.afacctno
                   and mst.afacctno=st.afacctno(+)
                   and dfg.AFACCTNO(+)=MST.afacctno
                   and ln.AFACCTNO (+)=MST.afacctno;
             end if;
        end loop;
    else
        delete from buf_ci_account where afacctno = p_acctno;
        SELECT MR.MRTYPE,af.actype,mst.groupleader
                    into v_margintype,v_actype,v_groupleader
                    from afmast mst,aftype af, mrtype mr where mst.actype=af.actype and af.mrtype=mr.actype
                    and mst.acctno = p_acctno;
        V_ACCTNO:=p_acctno;
        if v_margintype in ('N','L') then
             --Tai khoan binh thuong khong Margin
             INSERT INTO buf_ci_account (CUSTODYCD,ACTYPE,AFACCTNO,DESC_STATUS,LASTDATE,
                    BALANCE,INTBALANCE,DFDEBTAMT,CRINTACR,AAMT,BAMT,
                    EMKAMT,FLOATAMT,ODAMT,RECEIVING, NETTING, AVLADVANCE,MBLOCK,APMT,PAIDAMT,
                    ADVANCELINE,ADVLIMIT,MRIRATE,MRMRATE,MRLRATE,DEALPAIDAMT,
                    AVLWITHDRAW,BALDEFOVD,PP,AVLLIMIT,NAVACCOUNT,OUTSTANDING,
                    MARGINRATE,CIDEPOFEEACR,OVDCIDEPOFEE,
                    CASH_RECEIVING_T0,CASH_RECEIVING_T1,CASH_RECEIVING_T2,CASH_RECEIVING_T3,CASH_RECEIVING_TN,
                    CASH_SENDING_T0,CASH_SENDING_T1,CASH_SENDING_T2,CASH_SENDING_T3,CASH_SENDING_TN,CAREBY,
                    MRODAMT,T0ODAMT,DFODAMT,ACCOUNTTYPE,EXECBUYAMT,AUTOADV,AVLADV_T3,AVLADV_T1,AVLADV_T2,
                        CASH_PENDWITHDRAW,CASH_PENDTRANSFER,CASH_PENDING_SEND)
             SELECT
                    cf.CUSTODYCD, mst.actype, mst.afacctno, cd1.cdcontent desc_status,mst.lastdate,
                    TRUNC (mst.balance)-nvl(al.secureamt,0)-NVL (al.advamt, 0) balance,
                    mst.balance intbalance, mst.DFDEBTAMT,
                    mst.crintacr, nvl(adv.aamt,0) aamt,
                    nvl(al.secureamt,0) + NVL (al.advamt, 0) bamt, mst.emkamt,mst.floatamt,
                    mst.odamt, mst.receiving, mst.netting,nvl(adv.avladvance,0) avlAdvance, mst.mblock,
                    nvl(adv.advanceamount,0) apmt,nvl(adv.paidamt,0) paidamt,
                    af.advanceline,nvl(af.mrcrlimitmax,0) advlimit, af.mrirate,af.mrmrate,af.mrlrate,
                    nvl(pd.dealpaidamt,0) dealpaidamt,
                    greatest(nvl(adv.avladvance,0) + mst.balance - nvl(al.secureamt,0) - mst.odamt - mst.dfdebtamt - mst.dfintdebtamt - NVL (al.advamt, 0)-nvl(pd.dealpaidamt,0)-nvl(mst.depofeeamt,0),0) avlwithdraw ,
                    greatest( (case when autoadv = 'Y' then nvl(adv.avladvance,0) else 0 end) + balance- odamt- mst.dfdebtamt - mst.dfintdebtamt - NVL (advamt, 0)-nvl(secureamt,0) - ramt-nvl(pd.dealpaidamt,0) - nvl(mst.depofeeamt,0),0) baldefovd,
                    greatest(nvl(adv.avladvance,0) + af.advanceline + mst.balance- mst.odamt - mst.dfdebtamt - mst.dfintdebtamt- nvl (al.advamt, 0)-nvl(al.secureamt,0) - mst.ramt - nvl(mst.depofeeamt,0),0) pp,
                    nvl(adv.avladvance,0) + af.mrcrlimitmax-mst.dfodamt + af.advanceline + mst.balance- mst.odamt- mst.dfdebtamt - mst.dfintdebtamt - nvl (al.overamt, 0)-nvl(al.secureamt,0) - mst.ramt-nvl(mst.depofeeamt,0) avllimit,
                    nvl(af.MRCLAMT,0) +  nvl(se.SEASS,0)  NAVACCOUNT,
                    mst.balance+ nvl(adv.avladvance,0)- mst.odamt - mst.dfdebtamt - mst.dfintdebtamt- NVL (al.advamt, 0)-nvl(al.secureamt,0) - mst.ramt-nvl(mst.depofeeamt,0) OUTSTANDING,
                    round((case when mst.balance+nvl(adv.avladvance,0)- mst.odamt- mst.dfdebtamt - mst.dfintdebtamt - NVL (al.advamt, 0)-nvl(al.secureamt,0) - mst.ramt-nvl(mst.depofeeamt,0)>=0 then 100000
                    else (nvl(af.MRCLAMT,0) + nvl(se.SEASS,0) + nvl(adv.avladvance,0))/ abs(mst.balance+nvl(adv.avladvance,0)- mst.odamt- mst.dfdebtamt - mst.dfintdebtamt - NVL (al.advamt, 0)-nvl(al.secureamt,0) - mst.ramt-nvl(mst.depofeeamt,0)) end),4) * 100 MARGINRATE,
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
                    nvl(ln.mrodamt,0) MRODAMT,nvl(ln.t0odamt,0) T0ODAMT,nvl(dfg.dfamt,0) DFODAMT, (case when cf.custatcom ='N' then 'O' when af.corebank ='Y' then 'B' else 'C' end)ACCOUNTTYPE,
                    nvl(al.EXECBUYAMT,0) EXECBUYAMT, af.autoadv, nvl(advdtl.AVLADV_T3,0) AVLADV_T3, nvl(advdtl.avladv_t1,0) avladv_t1,
                    nvl(advdtl.avladv_t2,0) avladv_t2, nvl(pw.pdwithdraw,0) pdwithdraw, nvl(pdtrf.pdtrfamt,0) pdtrfamt,
                    nvl(al.secureamt,0)+NVL (al.advamt,0)+nvl(CASH_SENDING_T0,0)+nvl(CASH_SENDING_T1,0)+nvl(ST.BUY_FEEACR,0)
                        - nvl(ST.EXECAMTINDAY,0)+nvl(pw.pdwithdraw,0)+nvl(pdtrf.pdtrfamt,0) CASH_PENDING_SEND
               FROM cimast mst inner join afmast af on af.acctno = mst.afacctno AND mst.acctno = V_ACCTNO
                    inner join sbcurrency ccy on ccy.ccycd = mst.ccycd
                    INNER JOIN cfmast cf ON cf.custid = af.custid
                    inner join (select * from allcode cd1  where cd1.cdtype = 'CI' AND cd1.cdname = 'STATUS') cd1 on mst.status = cd1.cdval
                    left join
                    (select * from v_getbuyorderinfo where afacctno = V_ACCTNO) al
                     on mst.acctno = al.afacctno
                    LEFT JOIN
                    (select * from v_getsecmargininfo where afacctno = V_ACCTNO) SE
                    on se.afacctno = mst.acctno
                    LEFT JOIN
                    (select aamt,depoamt avladvance, advamt advanceamount,afacctno, paidamt from v_getAccountAvlAdvance where afacctno = V_ACCTNO) adv
                    on adv.afacctno=MST.acctno
                    LEFT JOIN
                    (select * from v_getdealpaidbyaccount p where p.afacctno = V_ACCTNO) pd
                    on pd.afacctno=mst.acctno
                    LEFT JOIN
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
                                sum(NVL(CASE WHEN ST.DUETYPE='RS' AND ST.TRFDAY=1 THEN ST.EXECAMTINDAY ELSE 0 END,0)) EXECAMTINDAY
                        FROM
                            VW_BD_PENDING_SETTLEMENT ST WHERE (DUETYPE='RM' OR DUETYPE='SM' OR DUETYPE = 'RS') AND ST.AFACCTNO = V_ACCTNO
                        GROUP BY AFACCTNO) ST
                    on ST.AFACCTNO=MST.acctno
                    left join
                        (select     df.afacctno, sum(
                                ln.PRINNML + ln.PRINOVD + round(ln.INTNMLACR,0) + round(ln.INTOVDACR,0) +
                                round(ln.INTNMLOVD,0)+round(ln.INTDUE,0)+
                                ln.OPRINNML+ln.OPRINOVD+round(ln.OINTNMLACR,0)+round(ln.OINTOVDACR,0)+round(ln.OINTNMLOVD,0) +
                                round(ln.OINTDUE,0)+round(ln.FEE,0)+round(ln.FEEDUE,0)+round(ln.FEEOVD,0) +
                                round(ln.FEEINTNMLACR,0) + round(ln.FEEINTOVDACR,0) +round(ln.FEEINTNMLOVD,0)+round(ln.FEEINTDUE,0)
                                ) dfAMT
                         from dfgroup df, lnmast ln
                        where df.lnacctno = ln.acctno
                        group by afacctno) dfg
                        on dfg.AFACCTNO=MST.acctno
                    left join
                        (
                        select trfacctno afacctno,
                            sum(ln.PRINNML + ln.PRINOVD + ln.INTNMLACR + ln.INTOVDACR +
                            ln.INTNMLOVD+ln.INTDUE) mrodamt,
                            sum(ln.OPRINNML+ln.OPRINOVD+ln.OINTNMLACR+ln.OINTOVDACR+
                            ln.OINTNMLOVD+ln.OINTDUE) t0odamt
                            from lnmast ln
                            where ftype ='AF'
                            and ln.PRINNML + ln.PRINOVD + ln.INTNMLACR + ln.INTOVDACR +
                            ln.INTNMLOVD+ln.INTDUE + ln.OPRINNML+ln.OPRINOVD+ln.OINTNMLACR+ln.OINTOVDACR+
                            ln.OINTNMLOVD+ln.OINTDUE >0
                            group by trfacctno
                        ) ln
                    on ln.AFACCTNO=MST.acctno
                    LEFT JOIN
                     (
                            SELECT sts.afacctno,
                                sum(CASE WHEN fn_get_nextdate(sts.currdate,2) = sts.cleardate THEN sts.avladvamt ELSE 0 END) avladv_t2,
                                sum(CASE WHEN fn_get_nextdate(sts.currdate,1) = sts.cleardate THEN sts.avladvamt ELSE 0 END) avladv_t1,
                                sum(CASE WHEN fn_get_nextdate(sts.currdate,3) = sts.cleardate THEN sts.avladvamt ELSE 0 END) AVLADV_T3
                            FROM v_advanceSchedule sts
                            WHERE afacctno = V_ACCTNO
                            GROUP BY sts.afacctno
                        ) advdtl
                     ON mst.acctno = advdtl.afacctno
                     LEFT JOIN
                     (
                         SELECT tl.msgacct, sum(tl.msgamt) pdwithdraw
                         FROM tllog tl
                         WHERE tl.tltxcd IN ('1100','1121','1110','1144','1199') AND tl.txstatus = '4' AND tl.deltd = 'N'
                             AND tl.msgacct = V_ACCTNO
                         GROUP BY tl.msgacct
                     ) pw
                     ON mst.acctno = pw.msgacct
                     LEFT JOIN
                     (
                         SELECT cir.acctno, sum(amt+feeamt) pdtrfamt
                         FROM ciremittance cir
                         WHERE cir.rmstatus = 'P' AND cir.deltd = 'N'
                             AND cir.acctno = V_ACCTNO
                         GROUP BY cir.acctno
                     ) pdtrf
                     ON mst.acctno = pdtrf.acctno      ;
         elsif v_margintype in ('S','T') and (length(v_groupleader)=0 or v_groupleader is null) then
                         --Tai khoan margin khong tham gia group
            INSERT INTO buf_ci_account (CUSTODYCD,ACTYPE,AFACCTNO,DESC_STATUS,LASTDATE,
                    BALANCE,INTBALANCE,DFDEBTAMT,CRINTACR,AAMT,BAMT,
                    EMKAMT,FLOATAMT,ODAMT,RECEIVING, NETTING, AVLADVANCE,MBLOCK,APMT,PAIDAMT,
                    ADVANCELINE,ADVLIMIT,MRIRATE,MRMRATE,MRLRATE,DEALPAIDAMT,
                    AVLWITHDRAW,BALDEFOVD,PP,AVLLIMIT,NAVACCOUNT,OUTSTANDING,
                    MARGINRATE,CIDEPOFEEACR,OVDCIDEPOFEE,
                    CASH_RECEIVING_T0,CASH_RECEIVING_T1,CASH_RECEIVING_T2,CASH_RECEIVING_T3,CASH_RECEIVING_TN,
                    CASH_SENDING_T0,CASH_SENDING_T1,CASH_SENDING_T2,CASH_SENDING_T3,CASH_SENDING_TN,CAREBY,
                    MRODAMT,T0ODAMT,DFODAMT,ACCOUNTTYPE,EXECBUYAMT,AUTOADV,AVLADV_T3,AVLADV_T1,AVLADV_T2,
                    CASH_PENDWITHDRAW,CASH_PENDTRANSFER,CASH_PENDING_SEND)
            SELECT
                CUSTODYCD,ACTYPE,CI.AFACCTNO,DESC_STATUS,LASTDATE,
                BALANCE,INTBALANCE,DFDEBTAMT,CRINTACR,AAMT,BAMT,
                EMKAMT,FLOATAMT,ODAMT,RECEIVING,NETTING,AVLADVANCE,MBLOCK,APMT,PAIDAMT,ADVANCELINE,
                ADVLIMIT,MRIRATE,MRMRATE,MRLRATE,
                DEALPAIDAMT,
                 TRUNC(
                     GREATEST(
                         (CASE WHEN MRIRATE>0 THEN greatest(least(NAVACCOUNT*100/MRIRATE + OUTSTANDING,AVLLIMIT-advanceline),0) ELSE NAVACCOUNT + OUTSTANDING END)
                     ,0) - DEALPAIDAMT
                 ,0) AVLWITHDRAW,
                 greatest(case when chksysctrl = 'Y' then
                     least(
                         trunc(mrBALDEFOVD,0)
                     ,
                         TRUNC(
                             (CASE WHEN MRIRATE>0  THEN LEAST((100* NAVACCOUNT + OUTSTANDING * MRIRATE)/MRIRATE,BALDEFOVD,AVLLIMIT-advanceline) ELSE BALDEFOVD-advanceline END)
                             -DEALPAIDAMT
                         ,0))
                 else
                     TRUNC(
                         (CASE WHEN MRIRATE>0  THEN LEAST((100* NAVACCOUNT + OUTSTANDING * MRIRATE)/MRIRATE,BALDEFOVD,AVLLIMIT-advanceline) ELSE BALDEFOVD-advanceline END)
                         -DEALPAIDAMT
                     ,0)
                 end,0) BALDEFOVD,
                 PP,AVLLIMIT,NAVACCOUNT,OUTSTANDING,
                 MARGINRATE,cidepofeeacr,
                 depofeeamt OVDCIDEPOFEE,
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
                  CAREBY,
                  nvl(ln.mrodamt,0) MRODAMT,nvl(ln.t0odamt,0) T0ODAMT,nvl(dfg.dfamt,0) DFODAMT,ACCOUNTTYPE,
                  EXECBUYAMT, AUTOADV, AVLADV_T3,  avladv_t1,
                  avladv_t2, pdwithdraw, pdtrfamt,
                  BAMT+nvl(CASH_SENDING_T0,0)+nvl(CASH_SENDING_T1,0)+nvl(ST.BUY_FEEACR,0)
                        - nvl(ST.EXECAMTINDAY,0)+pdwithdraw+pdtrfamt CASH_PENDING_SEND
             FROM (
                SELECT cf.CUSTODYCD,AF.advanceline,mst.actype, mst.acctno, mst.afacctno, mst.ccycd, mst.lastdate,
                    (mst.ramt - mst.aamt) cipamt, af.tradeline, TRUNC (mst.balance)-nvl(se.secureamt,0) balance,
                    mst.balance intbalance, mst.DFDEBTAMT,
                    mst.cramt, mst.dramt, mst.avrbal, mst.mdebit, mst.mcredit,
                    mst.crintacr, mst.odintacr, mst.adintacr, mst.minbal, nvl(se.aamt,0) aamt,
                    mst.ramt, nvl(se.secureamt,0) bamt, mst.emkamt,mst.floatamt, mst.odlimit, mst.mmarginbal,
                    mst.marginbal, mst.odamt, receiving, netting,nvl(se.avladvance,0) avladvance, mst.mblock, ccy.shortcd,
                    cd1.cdcontent desc_status, nvl(se.advanceamount,0) apmt,nvl(se.paidamt,0) paidamt,
                    nvl(af.mrcrlimitmax,0) advlimit, af.mrirate,af.mrmrate,af.mrlrate,
                    nvl(dealpaidamt,0) dealpaidamt,
                    nvl(se.avladvance,0) + mst.balance - nvl(se.secureamt,0) - mst.odamt - mst.dfdebtamt - mst.dfintdebtamt- mst.dfdebtamt - mst.dfintdebtamt - NVL (se.advamt, 0)-nvl(dealpaidamt,0) -nvl(mst.depofeeamt,0) avlwithdraw ,
                    nvl(se.avladvance,0) + balance - mst.ovamt - mst.dueamt  - mst.dfdebtamt - mst.dfintdebtamt - ramt - nvl(dealpaidamt,0) - mst.depofeeamt
                         - greatest(nvl(se.overamt,0) + nvl(se.secureamt,0) + nvl(OVDAF.MARGINAMT,0) - se.seass,0) baldefovd,
                    trunc(greatest(least(
                                  nvl(nvl(se.avladvance,0) + balance - mst.ovamt - mst.dueamt - ramt - dfdebtamt - dfintdebtamt - nvl(se.dealpaidamt,0)  - mst.depofeeamt,0)
                                         - greatest(nvl(se.overamt,0) + nvl(se.secureamt,0) + nvl(OVDAF.MARGINAMT,0) - se.semrass,0),
                                     case when odamt > 0 then (se.MARGINRATIO - se.MRIRATIO/100) * (se.serealass) + greatest(0,se.outstanding)
                                     else nvl(nvl(se.avladvance,0) + balance - mst.ovamt - mst.dueamt - ramt - dfdebtamt - dfintdebtamt - nvl(se.dealpaidamt,0) - mst.depofeeamt,0)
                                                 - greatest(nvl(se.overamt,0) + nvl(se.secureamt,0) + nvl(OVDAF.MARGINAMT,0) - se.semrass,0)
                                 end,
                                 se.avlmrlimit - af.advanceline
                                ),0),0) mrbaldefovd,
                    case when chksysctrl = 'Y' then
                         nvl(mst.balance - nvl(secureamt,0) + nvl(se.avladvance,0) + af.advanceline + least(nvl(af.mrcrlimitmax,0),nvl(af.mrcrlimit,0) + nvl(se.semramt,0)) - nvl(mst.odamt,0) - mst.dfdebtamt - mst.dfintdebtamt  - mst.depofeeamt,0)
                    else
                         nvl(mst.balance - nvl(secureamt,0) + nvl(se.avladvance,0) + af.advanceline + least(nvl(af.mrcrlimitmax,0),nvl(af.mrcrlimit,0) + nvl(se.seamt,0)) - nvl(mst.odamt,0) - mst.dfdebtamt - mst.dfintdebtamt  - mst.depofeeamt,0)
                    end pp,
                    nvl(se.avladvance,0) + af.advanceline + nvl(af.mrcrlimitmax,0)-mst.dfodamt + mst.balance- mst.odamt - mst.dfdebtamt - mst.dfintdebtamt - nvl (se.overamt, 0)-nvl(se.secureamt,0) - mst.ramt- mst.depofeeamt avllimit,
                    nvl(af.MRCRLIMIT,0) +  nvl(se.SEASS,0)  NAVACCOUNT,
                    mst.balance+ nvl(se.avladvance,0)- mst.odamt- mst.dfdebtamt - mst.dfintdebtamt - NVL (se.advamt, 0)-nvl(se.secureamt,0) - mst.ramt- mst.depofeeamt OUTSTANDING,
                    round((case when mst.balance + nvl(se.avladvance,0) - mst.odamt- mst.dfdebtamt - mst.dfintdebtamt - NVL (se.advamt, 0)-nvl(se.secureamt,0) - mst.ramt- mst.depofeeamt>=0 then 100000
                    else (nvl(af.MRCRLIMIT,0) + nvl(se.SEASS,0))/ abs(mst.balance+ nvl(se.avladvance,0)- mst.odamt- mst.dfdebtamt - mst.dfintdebtamt - NVL (se.advamt, 0)-nvl(se.secureamt,0) - mst.ramt-mst.depofeeamt) end),4) * 100 MARGINRATE,
                    se.chksysctrl, (se.MARGINRATIO * 100) MARGINRATIO, mst.cidepofeeacr,mst.depofeeamt, af.careby,
                    0 MRODAMT,0 T0ODAMT,0 DFODAMT, (case when cf.custatcom ='N' then 'O' when af.corebank ='Y' then 'B' else 'C' end)ACCOUNTTYPE,
                    nvl(se.EXECBUYAMT,0) EXECBUYAMT, af.autoadv, nvl(advdtl.AVLADV_T3,0) AVLADV_T3, nvl(advdtl.avladv_t1,0) avladv_t1,
                        nvl(advdtl.avladv_t2,0) avladv_t2, nvl(pw.pdwithdraw,0) pdwithdraw, nvl(pdtrf.pdtrfamt,0) pdtrfamt
               FROM cimast mst inner join afmast af on af.acctno = mst.afacctno AND mst.acctno = V_ACCTNO
                INNER JOIN aftype aft ON aft.actype = af.actype
                INNER JOIN mrtype mrt ON aft.mrtype = mrt.actype and mrt.mrtype IN ('S','T')
                inner join sbcurrency ccy on ccy.ccycd = mst.ccycd
                INNER JOIN cfmast cf ON cf.custid = af.custid
                inner join (select * from allcode cd1  where cd1.cdtype = 'CI' AND cd1.cdname = 'STATUS') cd1 on mst.status = cd1.cdval
                left join (select * from v_getsecmarginratio where afacctno = V_ACCTNO) se on se.afacctno = mst.acctno
                left join (select TRFACCTNO, nvl(sum(ln.PRINOVD + ln.INTOVDACR + ln.INTNMLOVD + ln.OPRINOVD + ln.OPRINNML + ln.OINTNMLOVD + ln.OINTOVDACR+ln.OINTDUE+ln.OINTNMLACR + nvl(lns.nml,0) + nvl(lns.intdue,0)),0) OVDAMT,
                                    nvl(sum(ln.PRINNML + ln.PRINOVD + ln.INTOVDACR + ln.INTNMLOVD + ln.INTNMLACR + ln.INTDUE),0) MARGINAMT
                                 from lnmast ln, (select acctno, sum(nml) nml, sum(intdue) intdue  from lnschd
                                                     where reftype = 'P' and  overduedate = to_date(cspks_system.fn_get_sysvar('SYSTEM','CURRDATE'),'DD/MM/RRRR') group by acctno) lns
                                 where ln.acctno = lns.acctno(+) and ln.ftype = 'AF'
                                 group by ln.trfacctno) OVDAF on OVDAF.TRFACCTNO = mst.acctno
                LEFT JOIN
                (
                       SELECT sts.afacctno,
                           sum(CASE WHEN fn_get_nextdate(sts.currdate,2) = sts.cleardate THEN sts.avladvamt ELSE 0 END) avladv_t2,
                           sum(CASE WHEN fn_get_nextdate(sts.currdate,1) = sts.cleardate THEN sts.avladvamt ELSE 0 END) avladv_t1,
                           sum(CASE WHEN fn_get_nextdate(sts.currdate,3) = sts.cleardate THEN sts.avladvamt ELSE 0 END) AVLADV_T3
                       FROM v_advanceSchedule sts
                       WHERE afacctno = V_ACCTNO
                       GROUP BY sts.afacctno
                   ) advdtl
                ON mst.acctno = advdtl.afacctno
                LEFT JOIN
                (
                    SELECT tl.msgacct, sum(tl.msgamt) pdwithdraw
                    FROM tllog tl
                    WHERE tl.tltxcd IN ('1100','1121','1110','1144','1199') AND tl.txstatus = '4' AND tl.deltd = 'N'
                        AND tl.msgacct = V_ACCTNO
                    GROUP BY tl.msgacct
                ) pw
                ON mst.acctno = pw.msgacct
                LEFT JOIN
                (
                    SELECT cir.acctno, sum(amt+feeamt) pdtrfamt
                    FROM ciremittance cir
                    WHERE cir.rmstatus = 'P' AND cir.deltd = 'N'
                        AND cir.acctno = V_ACCTNO
                    GROUP BY cir.acctno
                ) pdtrf
                ON mst.acctno = pdtrf.acctno
                ) ci
                LEFT JOIN
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
                                sum(NVL(CASE WHEN ST.DUETYPE='RS' AND ST.TRFDAY=1 THEN ST.EXECAMTINDAY ELSE 0 END,0)) EXECAMTINDAY
                        FROM
                            VW_BD_PENDING_SETTLEMENT ST WHERE (DUETYPE='RM' OR DUETYPE='SM' OR DUETYPE = 'RS') AND ST.AFACCTNO = V_ACCTNO
                        GROUP BY AFACCTNO) ST
                on ST.AFACCTNO=CI.acctno
          left join
                  (select     df.afacctno, sum(
                          ln.PRINNML + ln.PRINOVD + round(ln.INTNMLACR,0) + round(ln.INTOVDACR,0) +
                          round(ln.INTNMLOVD,0)+round(ln.INTDUE,0)+
                          ln.OPRINNML+ln.OPRINOVD+round(ln.OINTNMLACR,0)+round(ln.OINTOVDACR,0)+round(ln.OINTNMLOVD,0) +
                          round(ln.OINTDUE,0)+round(ln.FEE,0)+round(ln.FEEDUE,0)+round(ln.FEEOVD,0) +
                          round(ln.FEEINTNMLACR,0) + round(ln.FEEINTOVDACR,0) +round(ln.FEEINTNMLOVD,0)+round(ln.FEEINTDUE,0)
                          ) dfAMT
                   from dfgroup df, lnmast ln
                  where df.lnacctno = ln.acctno
                  group by afacctno) dfg
                  on dfg.AFACCTNO=ci.acctno
          left join
                        (
                        select trfacctno afacctno,
                            sum(ln.PRINNML + ln.PRINOVD + ln.INTNMLACR + ln.INTOVDACR +
                            ln.INTNMLOVD+ln.INTDUE) mrodamt,
                            sum(ln.OPRINNML+ln.OPRINOVD+ln.OINTNMLACR+ln.OINTOVDACR+
                            ln.OINTNMLOVD+ln.OINTDUE) t0odamt
                            from lnmast ln
                            where ftype ='AF'
                            and ln.PRINNML + ln.PRINOVD + ln.INTNMLACR + ln.INTOVDACR +
                            ln.INTNMLOVD+ln.INTDUE + ln.OPRINNML+ln.OPRINOVD+ln.OINTNMLACR+ln.OINTOVDACR+
                            ln.OINTNMLOVD+ln.OINTDUE >0
                            group by trfacctno
                        ) ln
                        on ln.AFACCTNO=ci.acctno

                    ;
         else
             --Tai khoan margin join theo group

               INSERT INTO buf_ci_account (CUSTODYCD,ACTYPE,AFACCTNO,DESC_STATUS,LASTDATE,
                  BALANCE,INTBALANCE,DFDEBTAMT,CRINTACR,AAMT,BAMT,
                  EMKAMT,FLOATAMT,ODAMT,RECEIVING, NETTING, AVLADVANCE,MBLOCK,APMT,PAIDAMT,
                  ADVANCELINE,ADVLIMIT,MRIRATE,MRMRATE,MRLRATE,DEALPAIDAMT,
                  AVLWITHDRAW,BALDEFOVD,PP,AVLLIMIT,NAVACCOUNT,OUTSTANDING,
                  MARGINRATE,CIDEPOFEEACR,OVDCIDEPOFEE,
                  CASH_RECEIVING_T0,CASH_RECEIVING_T1,CASH_RECEIVING_T2,CASH_RECEIVING_T3,CASH_RECEIVING_TN,
                  CASH_SENDING_T0,CASH_SENDING_T1,CASH_SENDING_T2,CASH_SENDING_T3,CASH_SENDING_TN,CAREBY,
                  MRODAMT,T0ODAMT,DFODAMT,ACCOUNTTYPE,EXECBUYAMT,AUTOADV,AVLADV_T3,AVLADV_T1,AVLADV_T2,
                  CASH_PENDWITHDRAW,CASH_PENDTRANSFER,CASH_PENDING_SEND)
               select cf.CUSTODYCD,ci.actype, MST.AFACCTNO, cd1.cdcontent desc_status,ci.lastdate,
                   MST.BALANCE,MST.INTBALANCE,mst.DFDEBTAMT,MST.CRINTACR,MST.AAMT,MST.BAMT,
                   MST.EMKAMT,MST.FLOATAMT,MST.ODAMT,MST.RECEIVING, MST.NETTING, MST.AVLADVANCE,MST.MBLOCK,MST.APMT,PAIDAMT,AF.ADVANCELINE,
                   MST.ADVLIMIT, af.mrirate,af.mrmrate,af.mrlrate,
                   nvl(pd.dealpaidamt,0) DEALPAIDAMT,
                           TRUNC(GREATEST((CASE WHEN mst.mstmrirate>0 THEN greatest(least(NAVACCOUNT*100/mst.mstmrirate + (OUTSTANDING),AVLLIMIT),0) ELSE NAVACCOUNT + OUTSTANDING END),0),0) AVLWITHDRAW,
                           TRUNC((CASE WHEN mst.mstmrirate>0
                                   THEN GREATEST(LEAST((100* NAVACCOUNT + OUTSTANDING * mst.mstmrirate)/mst.mstmrirate,
                                               --BALDEFOVD,
                                               nvl(adv.avladvance,0) +ci.balance- ci.ovamt-ci.dueamt - ci.ramt-af.advanceline,
                                               AVLLIMIT),0)
                                    ELSE BALDEFOVD END),0) BALDEFOVD,
                   greatest(AF.ADVANCELINE+ MST.PP,0) PP,
                   AF.ADVANCELINE+ MST.AVLLIMIT AVLLIMIT,MST.NAVACCOUNT,
                   AF.ADVANCELINE+ MST.OUTSTANDING OUTSTANDING,
                   round((case when MST.OUTSTANDING>=0 then 100000
                                  else MST.NAVACCOUNT/ abs(MST.OUTSTANDING) end),4) * 100 MARGINRATE,
                   mst.cidepofeeacr,
                   mst.depofeeamt OVDCIDEPOFEE,
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
                  AF.CAREBY,
                  nvl(ln.mrodamt,0) MRODAMT,nvl(ln.t0odamt,0) T0ODAMT,nvl(dfg.dfamt,0) DFODAMT, (case when cf.custatcom ='N' then 'O' when af.corebank ='Y' then 'B' else 'C' end)ACCOUNTTYPE,
                  EXECBUYAMT, af.autoadv, AVLADV_T3, avladv_t1,
                  avladv_t2, pdwithdraw, pdtrfamt,
                  MST.BAMT+nvl(CASH_SENDING_T0,0)+nvl(CASH_SENDING_T1,0)+nvl(ST.BUY_FEEACR,0)
                        - nvl(ST.EXECAMTINDAY,0)+pdwithdraw+pdtrfamt CASH_PENDING_SEND
               from
               (SELECT V_ACCTNO afacctno,sum((mst.ramt - mst.aamt)) cipamt, sum(af.tradeline) tradeline , sum(TRUNC (mst.balance)-nvl(al.secureamt,0)) balance,
                             sum(mst.balance) intbalance,sum(mst.DFDEBTAMT)  DFDEBTAMT,
                             sum(mst.cramt) cramt, sum(mst.dramt) dramt, sum(mst.avrbal) avrbal, sum(mst.mdebit) mdebit, sum(mst.mcredit) mcredit,
                            sum(mst.crintacr) crintacr, sum(mst.odintacr) odintacr, sum(mst.adintacr) adintacr, sum(mst.minbal) minbal, sum(nvl(adv.aamt,0)) aamt,
                            sum(mst.ramt) ramt, sum(nvl(al.secureamt,0)) bamt, sum(mst.emkamt) emkamt,sum(mst.floatamt) floatamt, sum(mst.odlimit) odlimit, sum(mst.mmarginbal) mmarginbal,
                            sum(mst.marginbal) marginbal, sum(mst.odamt) odamt, sum(mst.receiving) receiving, sum(mst.netting) netting,sum(nvl(adv.avladvance,0)) avladvance, sum(mst.mblock) mblock,
                            sum(nvl(adv.advanceamount,0)) apmt,sum(nvl(adv.paidamt,0)) paidamt,
                            sum(NVL (af.mrcrlimitmax, 0)) ADVLIMIT,
                            sum(nvl(adv.avladvance,0) + mst.balance - nvl(al.secureamt,0) - mst.odamt- mst.dfdebtamt - mst.dfintdebtamt - NVL (al.advamt, 0)-mst.depofeeamt) avlwithdraw ,
                            greatest(SUM(nvl(adv.avladvance,0) + balance- ovamt-dueamt - mst.dfdebtamt - mst.dfintdebtamt- ramt - mst.depofeeamt),0) baldefovd,
                            least(sum((nvl(af.mrcrlimit,0) + nvl(se.seamt,0)+
                                         nvl(adv.avladvance,0)))
                                 ,sum(nvl(adv.avladvance,0) + greatest(nvl(af.mrcrlimitmax,0)-mst.dfodamt,0)))
                            + sum(mst.balance- mst.odamt - mst.dfdebtamt - mst.dfintdebtamt- nvl (al.advamt, 0)-nvl(al.secureamt,0) - mst.ramt-mst.depofeeamt) pp,
                            sum(nvl(adv.avladvance,0) + nvl(af.mrcrlimitmax,0)-mst.dfodamt + mst.balance- mst.odamt - mst.dfdebtamt - mst.dfintdebtamt- nvl (al.overamt, 0)-nvl(al.secureamt,0) - mst.ramt-mst.depofeeamt) avllimit,
                            sum(nvl(af.MRCRLIMIT,0) +  nvl(se.SEASS,0))  NAVACCOUNT,
                            sum(mst.balance+ nvl(adv.avladvance,0)- mst.odamt - mst.dfdebtamt - mst.dfintdebtamt- NVL (al.advamt, 0)-nvl(al.secureamt,0) - mst.ramt- mst.depofeeamt) OUTSTANDING,
                            sum(case when af.acctno <> v_groupleader then 0 else af.mrirate end) mstmrirate,
                            sum(mst.cidepofeeacr) cidepofeeacr,
                            sum(mst.depofeeamt) depofeeamt,
                            sum(nvl(al.EXECBUYAMT,0)) EXECBUYAMT,
                            SUM(nvl(advdtl.AVLADV_T3,0)) AVLADV_T3, SUM(nvl(advdtl.avladv_t1,0)) avladv_t1,
                            SUM(nvl(advdtl.avladv_t2,0)) avladv_t2, SUM(nvl(pw.pdwithdraw,0)) pdwithdraw, SUM(nvl(pdtrf.pdtrfamt,0)) pdtrfamt
                        FROM cimast mst
                        inner join afmast af on af.acctno = mst.afacctno AND af.groupleader=v_groupleader
                       left join
                       (select b.* from v_getbuyorderinfo  b, afmast af where b.afacctno =af.acctno and af.groupleader=v_groupleader) al
                        on mst.acctno = al.afacctno
                       LEFT JOIN
                       (select b.* from v_getsecmargininfo b, afmast af where b.afacctno =af.acctno and af.groupleader=v_groupleader) se
                       on se.afacctno=MST.acctno
                       LEFT JOIN
                       (select sum(aamt) aamt,sum(depoamt) avladvance, sum(advamt) advanceamount ,afacctno, sum(paidamt) paidamt from v_getAccountAvlAdvance b, afmast af where b.afacctno =af.acctno and af.groupleader = v_groupleader group by b.afacctno) adv
                       on adv.afacctno=MST.acctno
                       LEFT JOIN
                        (
                            SELECT sts.afacctno,
                                sum(CASE WHEN fn_get_nextdate(sts.currdate,2) = sts.cleardate THEN sts.avladvamt ELSE 0 END) avladv_t2,
                                sum(CASE WHEN fn_get_nextdate(sts.currdate,1) = sts.cleardate THEN sts.avladvamt ELSE 0 END) avladv_t1,
                                sum(CASE WHEN fn_get_nextdate(sts.currdate,3) = sts.cleardate THEN sts.avladvamt ELSE 0 END) AVLADV_T3
                            FROM v_advanceSchedule sts
                            WHERE afacctno = V_ACCTNO
                            GROUP BY sts.afacctno
                        ) advdtl
                        ON mst.acctno = advdtl.afacctno
                        LEFT JOIN
                        (
                            SELECT tl.msgacct, sum(tl.msgamt) pdwithdraw
                            FROM tllog tl
                            WHERE tl.tltxcd IN ('1100','1121','1110','1144','1199') AND tl.txstatus = '4' AND tl.deltd = 'N'
                                AND tl.msgacct = V_ACCTNO
                            GROUP BY tl.msgacct
                        ) pw
                        ON mst.acctno = pw.msgacct
                        LEFT JOIN
                        (
                            SELECT cir.acctno, sum(amt+feeamt) pdtrfamt
                            FROM ciremittance cir
                            WHERE cir.rmstatus = 'P' AND cir.deltd = 'N'
                                AND cir.acctno = V_ACCTNO
                            GROUP BY cir.acctno
                        ) pdtrf
                        ON mst.acctno = pdtrf.acctno
               ) MST, afmast af, cfmast cf,cimast ci,
                                  sbcurrency ccy ,
                                   allcode cd1,
                 (select * from v_getdealpaidbyaccount p where p.afacctno = V_ACCTNO) pd,
                 (select depoamt avladvance,afacctno from v_getAccountAvlAdvance where afacctno = V_ACCTNO ) adv,
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
                                sum(NVL(CASE WHEN ST.DUETYPE='RS' AND ST.TRFDAY=1 THEN ST.EXECAMTINDAY ELSE 0 END,0)) EXECAMTINDAY
                        FROM
                            VW_BD_PENDING_SETTLEMENT ST WHERE (DUETYPE='RM' OR DUETYPE='SM' OR DUETYPE = 'RS') AND ST.AFACCTNO = V_ACCTNO
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
                     sum(ln.PRINNML + ln.PRINOVD + ln.INTNMLACR + ln.INTOVDACR +
                     ln.INTNMLOVD+ln.INTDUE) mrodamt,
                     sum(ln.OPRINNML+ln.OPRINOVD+ln.OINTNMLACR+ln.OINTOVDACR+
                     ln.OINTNMLOVD+ln.OINTDUE) t0odamt
                     from lnmast ln
                     where ftype ='AF'
                     and ln.PRINNML + ln.PRINOVD + ln.INTNMLACR + ln.INTOVDACR +
                     ln.INTNMLOVD+ln.INTDUE + ln.OPRINNML+ln.OPRINOVD+ln.OINTNMLACR+ln.OINTOVDACR+
                     ln.OINTNMLOVD+ln.OINTDUE >0
                     group by trfacctno
                 ) ln

               where mst.afacctno =af.acctno and af.custid=cf.custid
               and mst.afacctno=pd.afacctno(+)
               and mst.afacctno=ci.afacctno and ccy.ccycd = ci.ccycd
               and cd1.cdtype = 'CI' AND cd1.cdname = 'STATUS'
               and ci.status = cd1.cdval
               and adv.afacctno(+)=MST.afacctno
               and mst.afacctno=st.afacctno(+)
               and dfg.AFACCTNO(+)=MST.afacctno
               and ln.AFACCTNO(+)=MST.afacctno;
         end if;
    end if;
    commit;
    PLOG.INFO(pkgctx,'End pr_gen_buf_ci_account');
    plog.setendsection(pkgctx, 'pr_gen_buf_ci_account');
EXCEPTION WHEN others THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_gen_buf_ci_account');
END pr_gen_buf_ci_account;

*/

procedure pr_gen_buf_ci_account(p_acctno varchar2 default null)
  IS
  v_acctno varchar2(50);
  v_margintype char(1);
  v_actype varchar2(4);
  v_groupleader varchar2(10);
  v_ci_arr txpks_check.cimastcheck_arrtype;
  v_isfo VARCHAR2(1);
  v_fowithdraw NUMBER;
BEGIN
    plog.setBeginsection(pkgctx, 'pr_gen_buf_ci_account');
    PLOG.INFO(pkgctx,'Begin pr_gen_buf_ci_account');

    if p_acctno is null or p_acctno='ALL' then
        delete from buf_ci_account;
        --commit;
        For rec in (
                    SELECT mst.acctno,MR.MRTYPE,af.actype,mst.groupleader
                    --into v_margintype,v_actype,v_groupleader
                    from afmast mst,aftype af, mrtype mr where mst.actype=af.actype and af.mrtype=mr.actype
                    order by mst.acctno
        )
        loop
            V_ACCTNO:=rec.acctno;
            v_margintype:=rec.MRTYPE;
            v_actype:=rec.actype;
            v_groupleader:=rec.groupleader;
      v_fowithdraw := 0;

            v_ci_arr := txpks_check.fn_CIMASTcheck(V_ACCTNO,'CIMAST','ACCTNO');
            --PLOG.debug(pkgctx,'ppppppp: ' || v_ci_arr(0).pp);
            -- 1.5.9.0|iss:2066
            /*BEGIN
              SELECT NVL(ISFO,'N') INTO v_isfo FROM afmast WHERE acctno = V_ACCTNO AND ISFO = 'Y' AND EXISTS (SELECT varname FROM sysvar WHERE varname = 'FOMODE' AND varvalue = 'ON');
            EXCEPTION WHEN OTHERS THEN
              v_isfo := 'N';
            END;

            IF v_isfo = 'Y' THEN
              BEGIN
                v_fowithdraw := CSPKS_FO_ACCOUNT.fn_get_withdraw@DBL_FO(V_ACCTNO);
              EXCEPTION WHEN OTHERS THEN
                v_fowithdraw := NULL;
              END;
            ELSE
              v_fowithdraw := NULL;
            END IF;*/
            --if v_margintype in ('N','L') then
             --Tai khoan binh thuong khong Margin
             INSERT INTO buf_ci_account (CUSTODYCD,ACTYPE,AFACCTNO,DESC_STATUS,LASTDATE,
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
                   ,fowithdraw
                   ,tax_sell_sending, fee_sell_sending
                   )
             SELECT
                    cf.CUSTODYCD, v_ci_arr(0).actype actype, mst.afacctno, cd1.cdcontent desc_status,v_ci_arr(0).lastdate lastdate,
                    v_ci_arr(0).balance balance,
                    mst.balance intbalance, v_ci_arr(0).dfdebtamt DFDEBTAMT,
                    v_ci_arr(0).crintacr crintacr, v_ci_arr(0).aamt aamt,
                    v_ci_arr(0).bamt bamt, mst.emkamt,mst.floatamt,
                    mst.odamt, mst.receiving, mst.netting, Trunc(v_ci_arr(0).advanceamount) avlAdvance, mst.mblock,
                    trunc(v_ci_arr(0).advanceamount) apmt,v_ci_arr(0).paidamt paidamt,
                    v_ci_arr(0).advanceline,nvl(af.mrcrlimitmax,0) advlimit, af.mrirate,af.mrmrate,af.mrlrate,
                    v_ci_arr(0).dealpaidamt dealpaidamt,
                    v_ci_arr(0).baldefovd avlwithdraw,
                    v_ci_arr(0).baldefovd baldefovd,
                    v_ci_arr(0).pp pp,
                    v_ci_arr(0).avllimit avllimit,
                    v_ci_arr(0).navaccount  NAVACCOUNT,
                    v_ci_arr(0).OUTSTANDING OUTSTANDING,
                    v_ci_arr(0).MARGINRATE,
/*                    round((case when mst.balance+least(NVL(af.mrcrlimit,0),v_ci_arr(0).bamt)+v_ci_arr(0).avladvance- mst.odamt- mst.dfdebtamt - mst.dfintdebtamt
                                    -v_ci_arr(0).bamt - mst.ramt-nvl(mst.depofeeamt,0)>=0 then 100000
                                else (nvl(af.MRCLAMT,0) + v_ci_arr(0).SEMAXTOTALCALLASS
                                    + v_ci_arr(0).avladvance)
                                    / abs(mst.balance+least(NVL(af.mrcrlimit,0),v_ci_arr(0).bamt)+v_ci_arr(0).avladvance- mst.odamt- mst.dfdebtamt - mst.dfintdebtamt
                                           -v_ci_arr(0).bamt - mst.ramt-nvl(mst.depofeeamt,0)) end),4) * 100 MARGINRATE,*/
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
                    v_ci_arr(0).EXECBUYAMT EXECBUYAMT, af.autoadv, nvl(ST.AVLADV_T3,0) AVLADV_T3, nvl(ST.avladv_t1,0) avladv_t1,
                    nvl(ST.avladv_t2,0) avladv_t2, nvl(pw.pdwithdraw,0) pdwithdraw, nvl(pdtrf.pdtrfamt,0) pdtrfamt,
                    v_ci_arr(0).bamt/*+NVL (al.advamt,0)*/+nvl(CASH_SENDING_T0,0)+nvl(CASH_SENDING_T1,0)+nvl(ST.BUY_FEEACR,0)
                        - nvl(ST.EXECAMTINDAY,0)+nvl(pw.pdwithdraw,0)+nvl(pdtrf.pdtrfamt,0) CASH_PENDING_SEND,
                    v_ci_arr(0).PPREF, v_ci_arr(0).BALDEFTRFAMT,
                    nvl(CT2.CASHT2_SENDING_T0,0) CASHT2_SENDING_T0,
                    nvl(CT2.CASHT2_SENDING_T1,0) CASHT2_SENDING_T1,
                    nvl(CT2.CASHT2_SENDING_T2,0) CASHT2_SENDING_T2, nvl(ca.careceiving,0) careceiving,
                     --PhuongHT add ngay 01.03.2016
                    v_ci_arr(0).trfbuyamt_over,v_ci_arr(0).set0amt,v_ci_arr(0).rlsmarginrate_ex,
                    v_ci_arr(0).NYOVDAMT, v_ci_arr(0).marginrate_Ex,
                    v_ci_arr(0).semaxtotalcallass, v_ci_arr(0).secallass,
                    v_ci_arr(0).CLAMT,v_ci_arr(0).navaccountt2_EX,
                    v_ci_arr(0).outstanding_EX,
                    v_ci_arr(0).navaccount_ex, v_ci_arr(0).MARGINRATE5,
                    v_ci_arr(0).outstanding5,v_ci_arr(0).ODAMT_EX,
                    v_ci_arr(0).outstandingT2_EX,
                    v_ci_arr(0).semaxcallass,
                    v_ci_arr(0).secureamt_inday,
                    v_ci_arr(0).trfsecuredamt_inday,
                    v_ci_arr(0).avladvance
                   --end of PhuongHT add ngay 01.03.2016
                   ,v_fowithdraw fowithdraw
                   ,NVL(TAX_SELL_SENDING,0) TAX_SELL_SENDING, NVL(TAX_SELL_SENDING,0) TAX_SELL_SENDING
               FROM cimast mst inner join afmast af on af.acctno = mst.afacctno AND mst.acctno = V_ACCTNO
                    INNER JOIN cfmast cf ON cf.custid = af.custid
                    inner join (select * from allcode cd1  where cd1.cdtype = 'CI' AND cd1.cdname = 'STATUS') cd1 on mst.status = cd1.cdval
                    /*left join
                    (select * from v_getbuyorderinfo where afacctno = V_ACCTNO) al
                     on mst.acctno = al.afacctno*/
                    /*LEFT JOIN
                    (select * from v_getsecmargininfo where afacctno = V_ACCTNO) SE
                    on se.afacctno = mst.acctno*/
                    /*LEFT JOIN
                    (select aamt,depoamt avladvance, advamt advanceamount,afacctno, paidamt from v_getAccountAvlAdvance where afacctno = V_ACCTNO) adv
                    on adv.afacctno=MST.acctno*/
                   /* LEFT JOIN
                    (select * from v_getdealpaidbyaccount p where p.afacctno = V_ACCTNO) pd
                    on pd.afacctno=mst.acctno*/
                    LEFT JOIN
                    (SELECT SUM(amt) careceiving, afacctno  FROM caschd WHERE  status IN ('I','S','H') AND ISEXEC ='Y' AND deltd <> 'Y'   --T2_HoangND
                    GROUP BY afacctno) ca ON mst.acctno = ca.afacctno

                    LEFT JOIN
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
                                SUM(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=1 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT+ST.ST_PAIDAMT+ST.ST_PAIDFEEAMT-ST.FEEACR-ST.TAXSELLAMT-ST.RIGHTAMT ELSE 0 END) avladv_t1,
                                SUM(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=2 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT+ST.ST_PAIDAMT+ST.ST_PAIDFEEAMT-ST.FEEACR-ST.TAXSELLAMT-ST.RIGHTAMT ELSE 0 END) avladv_t2,
                                SUM(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=3 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT+ST.ST_PAIDAMT+ST.ST_PAIDFEEAMT-ST.FEEACR-ST.TAXSELLAMT-ST.RIGHTAMT ELSE 0 END) avladv_t3,
                                SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY < 3 THEN ST.TAXSELLAMT ELSE 0 END,0)) TAX_SELL_SENDING,
                                SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY < 3 THEN ST.FEEACR ELSE 0 END,0)) FEE_SELL_SENDING
                                --SUM(NVL(CASE WHEN ST.DUETYPE='SM' AND ST.ist2 = 'Y' AND st.T2DT = 0 THEN ST.ST_AMT ELSE 0 END,0)) CASHT2_SENDING_T0,
                                --SUM(NVL(CASE WHEN ST.DUETYPE='SM' AND ST.ist2 = 'Y' AND st.T2DT = 1 THEN ST.ST_AMT ELSE 0 END,0)) CASHT2_SENDING_T1,
                                --SUM(NVL(CASE WHEN ST.DUETYPE='SM' AND ST.ist2 = 'Y' AND st.T2DT = 2 THEN ST.ST_AMT ELSE 0 END,0)) CASHT2_SENDING_T2
                        FROM
                            VW_BD_PENDING_SETTLEMENT ST WHERE (DUETYPE='RM' OR DUETYPE='SM' OR DUETYPE = 'RS') AND ST.AFACCTNO = V_ACCTNO
                        GROUP BY AFACCTNO) ST
                    on ST.AFACCTNO=MST.acctno
                    left join
                        (select     df.afacctno, sum(
                                ln.PRINNML + ln.PRINOVD + round(ln.INTNMLACR,0) + round(ln.INTOVDACR,0) +
                                round(ln.INTNMLOVD,0)+round(ln.INTDUE,0)+
                                ln.OPRINNML+ln.OPRINOVD+round(ln.OINTNMLACR,0)+round(ln.OINTOVDACR,0)+round(ln.OINTNMLOVD,0) +
                                round(ln.OINTDUE,0)+round(ln.FEE,0)+round(ln.FEEDUE,0)+round(ln.FEEOVD,0) +
                                round(ln.FEEINTNMLACR,0) + round(ln.FEEINTOVDACR,0) +round(ln.FEEINTNMLOVD,0)+round(ln.FEEINTDUE,0)
                                ) dfAMT
                         from dfgroup df, lnmast ln
                        where df.lnacctno = ln.acctno AND df.afacctno = V_ACCTNO
                        group by afacctno) dfg
                        on dfg.AFACCTNO=MST.acctno
                    left join
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
                                AND ln.trfacctno = V_ACCTNO
                            group by trfacctno
                        ) ln
                    on ln.AFACCTNO=MST.acctno
                    /*LEFT JOIN
                     (
                            SELECT sts.afacctno,
                                sum(CASE WHEN fn_get_nextdate(sts.currdate,2) = sts.cleardate THEN sts.avladvamt ELSE 0 END) avladv_t2,
                                sum(CASE WHEN fn_get_nextdate(sts.currdate,1) = sts.cleardate THEN sts.avladvamt ELSE 0 END) avladv_t1,
                                sum(CASE WHEN fn_get_nextdate(sts.currdate,3) = sts.cleardate THEN sts.avladvamt ELSE 0 END) AVLADV_T3
                            FROM v_advanceSchedule sts
                            WHERE afacctno = V_ACCTNO
                            GROUP BY sts.afacctno
                        ) advdtl
                     ON mst.acctno = advdtl.afacctno*/
                     LEFT JOIN
                     (
                         SELECT tl.msgacct, sum(tl.msgamt) pdwithdraw
                         FROM tllog tl
                         WHERE tl.tltxcd IN ('1100','1121','1110','1144','1199','1107','1108','1110','1131','1132','1133','1136') AND tl.txstatus = '4' AND tl.deltd = 'N'
                             AND tl.msgacct = V_ACCTNO
                         GROUP BY tl.msgacct
                     ) pw
                     ON mst.acctno = pw.msgacct
                     LEFT JOIN
                     (
                         SELECT cir.acctno, sum(amt+feeamt) pdtrfamt
                         FROM ciremittance cir
                         WHERE cir.rmstatus = 'P' AND cir.deltd = 'N'
                             AND cir.acctno = V_ACCTNO
                         GROUP BY cir.acctno
                     ) pdtrf
                     ON mst.acctno = pdtrf.acctno
                     LEFT JOIN
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
                                AND ST.AFACCTNO = V_ACCTNO
                            GROUP BY ST.AFACCTNO, ST.DUETYPE, ST.TXDATE, ST.CLEARCD, ST.CLEARDAY
                        ) ST
                        GROUP BY ST.AFACCTNO
                     ) CT2
                     ON CT2.AFACCTNO = MST.AFACCTNO

                     ;
        end loop;
    else
        delete from buf_ci_account where afacctno = p_acctno;
        SELECT MR.MRTYPE,af.actype,mst.groupleader
                    into v_margintype,v_actype,v_groupleader
                    from afmast mst,aftype af, mrtype mr where mst.actype=af.actype and af.mrtype=mr.actype
                    and mst.acctno = p_acctno;
        V_ACCTNO:=p_acctno;
        --PLOG.debug(pkgctx,'p_acctno: ' || V_ACCTNO);

        v_ci_arr := txpks_check.fn_CIMASTcheck(V_ACCTNO,'CIMAST','ACCTNO');
        --PLOG.debug(pkgctx,'ppppppp: ' || v_ci_arr(0).pp);
        -- 1.5.9.0|iss:2066
            /*BEGIN
              SELECT NVL(ISFO,'N') INTO v_isfo FROM afmast WHERE acctno = V_ACCTNO AND ISFO = 'Y' AND EXISTS (SELECT varname FROM sysvar WHERE varname = 'FOMODE' AND varvalue = 'ON');
            EXCEPTION WHEN OTHERS THEN
              v_isfo := 'N';
            END;

            IF v_isfo = 'Y' THEN
              BEGIN
                v_fowithdraw := CSPKS_FO_ACCOUNT.fn_get_withdraw@DBL_FO(V_ACCTNO);
              EXCEPTION WHEN OTHERS THEN
                v_fowithdraw := NULL;
              END;
            ELSE
              v_fowithdraw := NULL;
            END IF;*/
        --if v_margintype in ('N','L') then
             --Tai khoan binh thuong khong Margin
             INSERT INTO buf_ci_account (CUSTODYCD,ACTYPE,AFACCTNO,DESC_STATUS,LASTDATE,
                    BALANCE,INTBALANCE,DFDEBTAMT,CRINTACR,AAMT,BAMT,
                    EMKAMT,FLOATAMT,ODAMT,RECEIVING, NETTING, AVLADVANCE,MBLOCK,APMT,PAIDAMT,
                    ADVANCELINE,ADVLIMIT,MRIRATE,MRMRATE,MRLRATE,DEALPAIDAMT,
                    AVLWITHDRAW,BALDEFOVD,PP,AVLLIMIT,NAVACCOUNT,OUTSTANDING,
                    MARGINRATE,CIDEPOFEEACR,OVDCIDEPOFEE,
                    CASH_RECEIVING_T0,CASH_RECEIVING_T1,CASH_RECEIVING_T2,CASH_RECEIVING_T3,CASH_RECEIVING_TN,
                    CASH_SENDING_T0,CASH_SENDING_T1,CASH_SENDING_T2,CASH_SENDING_T3,CASH_SENDING_TN,CAREBY,
                    MRODAMT,T0ODAMT,DFODAMT,ACCOUNTTYPE,EXECBUYAMT,AUTOADV,AVLADV_T3,AVLADV_T1,AVLADV_T2,
                        CASH_PENDWITHDRAW,CASH_PENDTRANSFER,CASH_PENDING_SEND,PPREF,BALDEFTRFAMT,
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
                   ,fowithdraw
                   ,tax_sell_sending, fee_sell_sending
                    )
             SELECT
                    cf.CUSTODYCD, v_ci_arr(0).actype actype, mst.afacctno, cd1.cdcontent desc_status,v_ci_arr(0).lastdate lastdate,
                    v_ci_arr(0).balance balance,
                    mst.balance intbalance, v_ci_arr(0).dfdebtamt DFDEBTAMT,
                    v_ci_arr(0).crintacr crintacr, v_ci_arr(0).aamt aamt,
                    v_ci_arr(0).bamt bamt, mst.emkamt,mst.floatamt,
                    mst.odamt, mst.receiving, mst.netting,trunc(v_ci_arr(0).advanceamount) avlAdvance, mst.mblock,
                    trunc(v_ci_arr(0).advanceamount) apmt,v_ci_arr(0).paidamt paidamt,
                    v_ci_arr(0).advanceline,nvl(af.mrcrlimitmax,0) advlimit, af.mrirate,af.mrmrate,af.mrlrate,
                    v_ci_arr(0).dealpaidamt dealpaidamt,
                    v_ci_arr(0).baldefovd avlwithdraw,
                    v_ci_arr(0).baldefovd baldefovd,
                    v_ci_arr(0).pp pp,
                    v_ci_arr(0).avllimit avllimit,
                    v_ci_arr(0).navaccount  NAVACCOUNT,
                    v_ci_arr(0).OUTSTANDING OUTSTANDING,
                    v_ci_arr(0).MARGINRATE,
/*                    round((case when mst.balance+least(NVL(af.mrcrlimit,0),v_ci_arr(0).bamt)+v_ci_arr(0).avladvance- mst.odamt- mst.dfdebtamt - mst.dfintdebtamt
                                    -v_ci_arr(0).bamt - mst.ramt-nvl(mst.depofeeamt,0)>=0 then 100000
                                else (nvl(af.MRCLAMT,0) + v_ci_arr(0).SEASS
                                    + v_ci_arr(0).avladvance)
                                    / abs(mst.balance+least(NVL(af.mrcrlimit,0),v_ci_arr(0).bamt)+v_ci_arr(0).avladvance- mst.odamt- mst.dfdebtamt - mst.dfintdebtamt
                                          -v_ci_arr(0).bamt - mst.ramt-nvl(mst.depofeeamt,0)) end),4) * 100 MARGINRATE,*/
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
                    v_ci_arr(0).EXECBUYAMT EXECBUYAMT, af.autoadv, nvl(ST.AVLADV_T3,0) AVLADV_T3, nvl(ST.avladv_t1,0) avladv_t1,
                    nvl(ST.avladv_t2,0) avladv_t2, nvl(pw.pdwithdraw,0) pdwithdraw, nvl(pdtrf.pdtrfamt,0) pdtrfamt,
                    v_ci_arr(0).bamt/*+NVL (al.advamt,0)*/+nvl(CASH_SENDING_T0,0)+nvl(CASH_SENDING_T1,0)+nvl(ST.BUY_FEEACR,0)
                        - nvl(ST.EXECAMTINDAY,0)+nvl(pw.pdwithdraw,0)+nvl(pdtrf.pdtrfamt,0) CASH_PENDING_SEND,
                    v_ci_arr(0).PPREF, v_ci_arr(0).BALDEFTRFAMT,
                    nvl(ct2.CASHT2_SENDING_T0,0) CASHT2_SENDING_T0,
                    nvl(ct2.CASHT2_SENDING_T1,0) CASHT2_SENDING_T1,
                    nvl(ct2.CASHT2_SENDING_T2,0) CASHT2_SENDING_T2, nvl(ca.careceiving,0) careceiving,
                        --PhuongHT add ngay 01.03.2016
                    v_ci_arr(0).trfbuyamt_over,v_ci_arr(0).set0amt,v_ci_arr(0).rlsmarginrate_ex,
                    v_ci_arr(0).NYOVDAMT, v_ci_arr(0).marginrate_Ex,
                    v_ci_arr(0).semaxtotalcallass, v_ci_arr(0).secallass,
                    v_ci_arr(0).CLAMT,v_ci_arr(0).navaccountt2_EX,
                    v_ci_arr(0).outstanding_EX,
                    v_ci_arr(0).navaccount_ex, v_ci_arr(0).MARGINRATE5,
                    v_ci_arr(0).outstanding5,v_ci_arr(0).ODAMT_EX,
                    v_ci_arr(0).outstandingT2_EX,
                    v_ci_arr(0).semaxcallass,
                    v_ci_arr(0).secureamt_inday,
                    v_ci_arr(0).trfsecuredamt_inday,
                    v_ci_arr(0).avladvance
                   --end of PhuongHT add ngay 01.03.2016
                   ,v_fowithdraw fowithdraw
                   ,NVL(TAX_SELL_SENDING,0) TAX_SELL_SENDING, NVL(TAX_SELL_SENDING,0) TAX_SELL_SENDING
               FROM cimast mst inner join afmast af on af.acctno = mst.afacctno AND mst.acctno = V_ACCTNO
                    INNER JOIN cfmast cf ON cf.custid = af.custid
                    inner join (select * from allcode cd1  where cd1.cdtype = 'CI' AND cd1.cdname = 'STATUS') cd1 on mst.status = cd1.cdval
                    /*left join
                    (select * from v_getbuyorderinfo where afacctno = V_ACCTNO) al
                     on mst.acctno = al.afacctno*/
                    /*LEFT JOIN
                    (select * from v_getsecmargininfo where afacctno = V_ACCTNO) SE
                    on se.afacctno = mst.acctno*/
                    /*LEFT JOIN
                    (select aamt,depoamt avladvance, advamt advanceamount,afacctno, paidamt from v_getAccountAvlAdvance where afacctno = V_ACCTNO) adv
                    on adv.afacctno=MST.acctno*/
                   /* LEFT JOIN
                    (select * from v_getdealpaidbyaccount p where p.afacctno = V_ACCTNO) pd
                    on pd.afacctno=mst.acctno*/
                    LEFT JOIN
                    (SELECT SUM(amt) careceiving, afacctno  FROM caschd WHERE  status IN ('I','S','H') AND ISEXEC ='Y' AND deltd <> 'Y'   --T2_HoangND
                    GROUP BY afacctno) ca ON mst.acctno = ca.afacctno
                    LEFT JOIN
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
                                SUM(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=1 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT+ST.ST_PAIDAMT+ST.ST_PAIDFEEAMT-ST.FEEACR-ST.TAXSELLAMT-ST.RIGHTAMT ELSE 0 END) avladv_t1,
                                SUM(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=2 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT+ST.ST_PAIDAMT+ST.ST_PAIDFEEAMT-ST.FEEACR-ST.TAXSELLAMT-ST.RIGHTAMT ELSE 0 END) avladv_t2,
                                SUM(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=3 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT+ST.ST_PAIDAMT+ST.ST_PAIDFEEAMT-ST.FEEACR-ST.TAXSELLAMT-ST.RIGHTAMT ELSE 0 END) avladv_t3,
                                SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY < 3 THEN ST.TAXSELLAMT ELSE 0 END,0)) TAX_SELL_SENDING,
                                SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY < 3 THEN ST.FEEACR ELSE 0 END,0)) FEE_SELL_SENDING
                                --SUM(NVL(CASE WHEN ST.DUETYPE='SM' AND ST.ist2 = 'Y' AND st.T2DT = 0 THEN ST.ST_AMT ELSE 0 END,0)) CASHT2_SENDING_T0,
                                --SUM(NVL(CASE WHEN ST.DUETYPE='SM' AND ST.ist2 = 'Y' AND st.T2DT = 1 THEN ST.ST_AMT ELSE 0 END,0)) CASHT2_SENDING_T1,
                                --SUM(NVL(CASE WHEN ST.DUETYPE='SM' AND ST.ist2 = 'Y' AND st.T2DT = 2 THEN ST.ST_AMT ELSE 0 END,0)) CASHT2_SENDING_T2
                        FROM
                            VW_BD_PENDING_SETTLEMENT ST WHERE (DUETYPE='RM' OR DUETYPE='SM' OR DUETYPE = 'RS') AND ST.AFACCTNO = V_ACCTNO
                        GROUP BY AFACCTNO) ST
                    on ST.AFACCTNO=MST.acctno
                    left join
                        (select     df.afacctno, sum(
                                ln.PRINNML + ln.PRINOVD + round(ln.INTNMLACR,0) + round(ln.INTOVDACR,0) +
                                round(ln.INTNMLOVD,0)+round(ln.INTDUE,0)+
                                ln.OPRINNML+ln.OPRINOVD+round(ln.OINTNMLACR,0)+round(ln.OINTOVDACR,0)+round(ln.OINTNMLOVD,0) +
                                round(ln.OINTDUE,0)+round(ln.FEE,0)+round(ln.FEEDUE,0)+round(ln.FEEOVD,0) +
                                round(ln.FEEINTNMLACR,0) + round(ln.FEEINTOVDACR,0) +round(ln.FEEINTNMLOVD,0)+round(ln.FEEINTDUE,0)
                                ) dfAMT
                         from dfgroup df, lnmast ln
                        where df.lnacctno = ln.acctno AND df.afacctno = V_ACCTNO
                        group by afacctno) dfg
                        on dfg.AFACCTNO=MST.acctno
                    left join
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
                                AND ln.trfacctno = V_ACCTNO
                            group by trfacctno
                        ) ln
                    on ln.AFACCTNO=MST.acctno
                    /*LEFT JOIN
                     (
                            SELECT sts.afacctno,
                                sum(CASE WHEN fn_get_nextdate(sts.currdate,2) = sts.cleardate THEN sts.avladvamt ELSE 0 END) avladv_t2,
                                sum(CASE WHEN fn_get_nextdate(sts.currdate,1) = sts.cleardate THEN sts.avladvamt ELSE 0 END) avladv_t1,
                                sum(CASE WHEN fn_get_nextdate(sts.currdate,3) = sts.cleardate THEN sts.avladvamt ELSE 0 END) AVLADV_T3
                            FROM v_advanceSchedule sts
                            WHERE afacctno = V_ACCTNO
                            GROUP BY sts.afacctno
                        ) advdtl
                     ON mst.acctno = advdtl.afacctno*/
                     LEFT JOIN
                     (
                         SELECT tl.msgacct, sum(tl.msgamt) pdwithdraw
                         FROM tllog tl
                         WHERE tl.tltxcd IN ('1100','1121','1110','1144','1199','1107','1108','1110','1131','1132','1133','1136') AND tl.txstatus = '4' AND tl.deltd = 'N'
                             AND tl.msgacct = V_ACCTNO
                         GROUP BY tl.msgacct
                     ) pw
                     ON mst.acctno = pw.msgacct
                     LEFT JOIN
                     (
                         SELECT cir.acctno, sum(amt+feeamt) pdtrfamt
                         FROM ciremittance cir
                         WHERE cir.rmstatus = 'P' AND cir.deltd = 'N'
                             AND cir.acctno = V_ACCTNO
                         GROUP BY cir.acctno
                     ) pdtrf
                     ON mst.acctno = pdtrf.acctno
                     LEFT JOIN
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
                                AND ST.AFACCTNO = V_ACCTNO
                            GROUP BY ST.AFACCTNO, ST.DUETYPE, ST.TXDATE, ST.CLEARCD, ST.CLEARDAY
                        ) ST
                        GROUP BY ST.AFACCTNO
                     ) CT2
                     ON CT2.AFACCTNO = MST.AFACCTNO
                     ;

        --end if;
    end if;

    --commit;
    PLOG.INFO(pkgctx,'End pr_gen_buf_ci_account');
    plog.setendsection(pkgctx, 'pr_gen_buf_ci_account');
EXCEPTION WHEN others THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_gen_buf_ci_account');
END pr_gen_buf_ci_account;


procedure pr_gen_buf_se_account(p_acctno varchar2 default null)
  IS

BEGIN
    plog.setbeginsection(pkgctx, 'pr_gen_buf_se_account');
    if p_acctno is null or p_acctno='ALL' then
        PLOG.INFO(pkgctx,'Begin pr_gen_buf_se_account');
        delete from buf_se_account;
        --commit;
        INSERT INTO buf_se_account (CUSTODYCD,ACCTNO,AFACCTNO,ACTYPE,LASTDATE,CODEID,STATUS,COSTPRICE,
                                    TRADE,WTRADE,MORTAGE,NETTING,SECURED,WITHDRAW,BLOCKED,DEPOSIT,
                                    SENDDEPOSIT,PREVQTTY,DTOCLOSE,DCRQTTY,DCRAMT,RECEIVING,SYMBOL,
                                    DESC_STATUS,ABSTANDING,AVLWITHDRAW,TOTAL_QTTY,DEAL_QTTY,
                                    SECURITIES_RECEIVING_T0,
                                    SECURITIES_RECEIVING_T1,
                                    SECURITIES_RECEIVING_T2,
                                    SECURITIES_RECEIVING_T3,
                                    SECURITIES_RECEIVING_TN,
                                    SECURITIES_SENDING_T0,
                                    SECURITIES_SENDING_T1,
                                    SECURITIES_SENDING_T2,
                                    SECURITIES_SENDING_T3,
                                    SECURITIES_SENDING_TN,
                                    CAREBY,REMAINQTTY,RESTRICTQTTY,DFTRADING)
        -- TheNN modified, 12-Jan-2012
        SELECT CF.CUSTODYCD,MST.ACCTNO, MST.AFACCTNO,MST.ACTYPE, MST.LASTDATE, MST.CODEID, MST.STATUS,

                 MST.COSTPRICE,

                 MST.TRADE-NVL(B.SECUREAMT,0) TRADE,

                 MST.WTRADE, MST.MORTAGE-NVL(B.SECUREMTG,0) + MST.STANDING MORTAGE , MST.NETTING,
                 NVL(B.SECUREAMT,0)+NVL(B.SECUREMTG,0) SECURED,
                 MST.WITHDRAW, NVL(MST.BLOCKED,0) + nvl(dtl.dfqtty,0) - NVL(DTL.QTTY,0) BLOCKED, NVL(MST.DEPOSIT,0), NVL(MST.SENDDEPOSIT,0),MST.PREVQTTY,
                 MST.DTOCLOSE,MST.DCRQTTY,MST.DCRAMT,
                 MST.RECEIVING, CCY.SYMBOL, CD1.CDCONTENT DESC_STATUS,
                 ABS(STANDING) ABSTANDING, MST.TRADE-NVL(B.SECUREAMT,0) AVLWITHDRAW,
                 (NVL(MST.TRADE,0)+NVL(MST.MORTAGE,0)+NVL(MST.BLOCKED,0)+NVL(MST.NETTING,0)+NVL(MST.WTRADE,0)) TOTAL_QTTY,
                  NVL(DF.DEALQTTY,0) DEAL_QTTY,
                 NVL(ST.SECURITIES_RECEIVING_T0,0) SECURITIES_RECEIVING_T0,
                  NVL(ST.SECURITIES_RECEIVING_T1,0) SECURITIES_RECEIVING_T1,
                  NVL(ST.SECURITIES_RECEIVING_T2,0) SECURITIES_RECEIVING_T2,
                 NVL(ST.SECURITIES_RECEIVING_T3,0) SECURITIES_RECEIVING_T3,
                 NVL(ST.SECURITIES_RECEIVING_TN,0) SECURITIES_RECEIVING_TN,
                 NVL(ST.SECURITIES_SENDING_T0,0) SECURITIES_SENDING_T0,
                 NVL(ST.SECURITIES_SENDING_T1,0) SECURITIES_SENDING_T1,
                 NVL(ST.SECURITIES_SENDING_T2,0) SECURITIES_SENDING_T2,
                 NVL(ST.SECURITIES_SENDING_T3,0) SECURITIES_SENDING_T3,
                 NVL(ST.SECURITIES_SENDING_TN,0) SECURITIES_SENDING_TN,
                 af.CAREBY,
                 NVL(B.SECUREAMT,0)+NVL(B.SECUREMTG,0) - NVL(ST.REMAINQTTY,0) - DECODE(CF.CUSTATCOM,'Y',0,NVL(B.EXECQTTY,0)) REMAINQTTY,
                 NVL(DTL.QTTY,0) - NVL(DTL.dfqtty,0) RESTRICTQTTY,
                 nvl(dftrading,0) dftrading
              FROM AFMAST AF, SEMAST MST,CFMAST CF, ALLCODE CD1, v_getsellorderinfo B,SBSECURITIES CCY,
                   (
                        SELECT AFACCTNO, CODEID, SYMBOL, SUM(REMAINQTTY) REMAINQTTY,
                            SUM(SECURITIES_RECEIVING_T0) SECURITIES_RECEIVING_T0,
                            SUM(SECURITIES_RECEIVING_T1) SECURITIES_RECEIVING_T1,
                            SUM(SECURITIES_RECEIVING_T2) SECURITIES_RECEIVING_T2,
                            SUM(SECURITIES_RECEIVING_T3) SECURITIES_RECEIVING_T3,
                            SUM(SECURITIES_RECEIVING_TN) SECURITIES_RECEIVING_TN,
                            SUM(SECURITIES_SENDING_T0) SECURITIES_SENDING_T0,
                            SUM(SECURITIES_SENDING_T1) SECURITIES_SENDING_T1,
                            SUM(SECURITIES_SENDING_T2) SECURITIES_SENDING_T2,
                            SUM(SECURITIES_SENDING_T3) SECURITIES_SENDING_T3,
                            SUM(SECURITIES_SENDING_TN) SECURITIES_SENDING_TN
                        FROM
                        (
                        SELECT ST.*,
                            (CASE WHEN ST.DUETYPE='RS' AND ST.TDAY=0 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_RECEIVING_T0,
                           (CASE WHEN ST.DUETYPE='RS' AND ST.TDAY=1 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_RECEIVING_T1,
                           (CASE WHEN ST.DUETYPE='RS' AND ST.TDAY=2 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_RECEIVING_T2,
                           (CASE WHEN ST.DUETYPE='RS' AND ST.TDAY=3 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_RECEIVING_T3,
                           (CASE WHEN ST.DUETYPE='RS' AND ST.TDAY>3 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_RECEIVING_TN,
                           (CASE WHEN ST.DUETYPE='RM' AND ST.TRFDAY=1 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_SENDING_T0,
                           (CASE WHEN ST.DUETYPE='RM' AND ST.TRFDAY=2 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_SENDING_T1,
                           (CASE WHEN ST.DUETYPE='RM' AND ST.TRFDAY=3 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_SENDING_T2,
                           (CASE WHEN ST.DUETYPE='RM' AND ST.TRFDAY=4 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_SENDING_T3,
                           (CASE WHEN ST.DUETYPE='RM' AND ST.TRFDAY >4 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_SENDING_TN,
                           (CASE WHEN ST.DUETYPE='SS' AND ST.NDAY=0 THEN ST.ST_QTTY ELSE 0 END) REMAINQTTY
                        FROM VW_BD_PENDING_SETTLEMENT ST
                        WHERE DUETYPE='RS' OR DUETYPE='SS' OR DUETYPE = 'RM'
                        ) ST
                        GROUP BY ST.AFACCTNO, ST.CODEID, ST.SYMBOL
                   ) ST,
                   (SELECT DF.CODEID, DF.AFACCTNO,  SUM(DF.DFQTTY+DF.RCVQTTY+DF.BLOCKQTTY+DF.CARCVQTTY) DEALQTTY, sum(df.dftrading) dftrading
                        FROM v_getdealinfo DF WHERE DF.STATUS IN ('P','A','N') GROUP BY DF.CODEID, DF.AFACCTNO) DF,
                   (select acctno, sum(case when QTTYTYPE ='002' then qtty else 0 end) qtty,
                                   sum(case when QTTYTYPE ='002' then dfqtty else 0 end) dfqtty
                    from semastdtl
                        where qtty>0
                        and deltd <> 'Y'
                    group by acctno) dtl
              WHERE AF.ACCTNO = MST.AFACCTNO AND AF.CUSTID= CF.CUSTID
               AND MST.ACCTNO=B.SEACCTNO(+)
               AND MST.ACCTNO=dtl.ACCTNO(+)
               --AND MST.ACCTNO = V_ACCTNO
               AND MST.CODEID= CCY.CODEID and CCY.SECTYPE<>'004'
               AND MST.AFACCTNO=ST.AFACCTNO (+) AND MST.CODEID=ST.CODEID (+)
               AND MST.AFACCTNO=DF.AFACCTNO (+) AND MST.CODEID=DF.CODEID (+)
               AND TRIM(CD1.CDTYPE) = 'SE' AND TRIM(CD1.CDNAME)='STATUS'
               AND TRIM(MST.STATUS) = TRIM(CD1.CDVAL);



        --commit;
        PLOG.INFO(pkgctx,'End pr_gen_buf_se_account');
    else
        PLOG.debug(pkgctx,'Begin pr_gen_buf_se_account' || p_acctno);
        delete from buf_se_account where acctno = p_acctno;
        --commit;
        INSERT INTO buf_se_account (CUSTODYCD,ACCTNO,AFACCTNO,ACTYPE,LASTDATE,CODEID,STATUS,COSTPRICE,
                                    TRADE,WTRADE,MORTAGE,NETTING,SECURED,WITHDRAW,BLOCKED,DEPOSIT,
                                    SENDDEPOSIT,PREVQTTY,DTOCLOSE,DCRQTTY,DCRAMT,RECEIVING,SYMBOL,
                                    DESC_STATUS,ABSTANDING,AVLWITHDRAW,TOTAL_QTTY,DEAL_QTTY,
                                    SECURITIES_RECEIVING_T0,SECURITIES_RECEIVING_T1,SECURITIES_RECEIVING_T2,SECURITIES_RECEIVING_T3,SECURITIES_RECEIVING_TN,
                                    SECURITIES_SENDING_T0,SECURITIES_SENDING_T1,SECURITIES_SENDING_T2,SECURITIES_SENDING_T3,SECURITIES_SENDING_TN,CAREBY,REMAINQTTY,RESTRICTQTTY,DFTRADING)
        SELECT CF.CUSTODYCD,MST.ACCTNO, MST.AFACCTNO,MST.ACTYPE, MST.LASTDATE, MST.CODEID, MST.STATUS,
               MST.COSTPRICE, MST.TRADE-NVL(B.SECUREAMT,0) TRADE,
                 MST.WTRADE, MST.MORTAGE-NVL(B.SECUREMTG,0) + MST.STANDING MORTAGE , MST.NETTING,
                 NVL(B.SECUREAMT,0)+NVL(B.SECUREMTG,0) SECURED,
                 MST.WITHDRAW, NVL(MST.BLOCKED,0) + nvl(dtl.dfqtty,0) - NVL(DTL.QTTY,0), NVL(MST.DEPOSIT,0), NVL(MST.SENDDEPOSIT,0),MST.PREVQTTY,
                 MST.DTOCLOSE,MST.DCRQTTY,MST.DCRAMT,
                 MST.RECEIVING, CCY.SYMBOL, CD1.CDCONTENT DESC_STATUS,
                 ABS(STANDING) ABSTANDING, MST.TRADE-NVL(B.SECUREAMT,0) AVLWITHDRAW,
                 (MST.TRADE+nvl(MST.MORTAGE,0)+nvl(MST.BLOCKED,0)+nvl(MST.NETTING,0)+nvl(MST.WTRADE,0)) TOTAL_QTTY,
                  NVL(DF.DEALQTTY,0) DEAL_QTTY,
                 NVL(ST.SECURITIES_RECEIVING_T0,0) SECURITIES_RECEIVING_T0,
                  NVL(ST.SECURITIES_RECEIVING_T1,0) SECURITIES_RECEIVING_T1,
                  NVL(ST.SECURITIES_RECEIVING_T2,0) SECURITIES_RECEIVING_T2,
                 NVL(ST.SECURITIES_RECEIVING_T3,0) SECURITIES_RECEIVING_T3,
                 NVL(ST.SECURITIES_RECEIVING_TN,0) SECURITIES_RECEIVING_TN,
                 NVL(ST.SECURITIES_SENDING_T0,0) SECURITIES_SENDING_T0,
                 NVL(ST.SECURITIES_SENDING_T1,0) SECURITIES_SENDING_T1,
                 NVL(ST.SECURITIES_SENDING_T2,0) SECURITIES_SENDING_T2,
                 NVL(ST.SECURITIES_SENDING_T3,0) SECURITIES_SENDING_T3,
                 NVL(ST.SECURITIES_SENDING_TN,0) SECURITIES_SENDING_TN,
                 af.CAREBY,
                 NVL(B.SECUREAMT,0)+NVL(B.SECUREMTG,0) - NVL(ST.REMAINQTTY,0) - DECODE(CF.CUSTATCOM,'Y',0,NVL(B.EXECQTTY,0)) REMAINQTTY,
                 NVL(DTL.QTTY,0) - NVL(DTL.dfqtty,0) RESTRICTQTTY,
                 nvl(dftrading,0) dftrading
              FROM AFMAST AF, SEMAST MST,CFMAST CF, ALLCODE CD1, v_getsellorderinfo B,SBSECURITIES CCY,
                   (
                        SELECT AFACCTNO, CODEID, SYMBOL, SUM(REMAINQTTY) REMAINQTTY,
                            SUM(SECURITIES_RECEIVING_T0) SECURITIES_RECEIVING_T0,
                            SUM(SECURITIES_RECEIVING_T1) SECURITIES_RECEIVING_T1,
                            SUM(SECURITIES_RECEIVING_T2) SECURITIES_RECEIVING_T2,
                            SUM(SECURITIES_RECEIVING_T3) SECURITIES_RECEIVING_T3,
                            SUM(SECURITIES_RECEIVING_TN) SECURITIES_RECEIVING_TN,
                            SUM(SECURITIES_SENDING_T0) SECURITIES_SENDING_T0,
                            SUM(SECURITIES_SENDING_T1) SECURITIES_SENDING_T1,
                            SUM(SECURITIES_SENDING_T2) SECURITIES_SENDING_T2,
                            SUM(SECURITIES_SENDING_T3) SECURITIES_SENDING_T3,
                            SUM(SECURITIES_SENDING_TN) SECURITIES_SENDING_TN
                        FROM
                        (
                        SELECT ST.*,
                            (CASE WHEN ST.DUETYPE='RS' AND ST.TDAY=0 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_RECEIVING_T0,
                           (CASE WHEN ST.DUETYPE='RS' AND ST.TDAY=1 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_RECEIVING_T1,
                           (CASE WHEN ST.DUETYPE='RS' AND ST.TDAY=2 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_RECEIVING_T2,
                           (CASE WHEN ST.DUETYPE='RS' AND ST.TDAY=3 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_RECEIVING_T3,
                           (CASE WHEN ST.DUETYPE='RS' AND ST.TDAY>3 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_RECEIVING_TN,
                           (CASE WHEN ST.DUETYPE='RM' AND ST.TRFDAY=1 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_SENDING_T0,
                           (CASE WHEN ST.DUETYPE='RM' AND ST.TRFDAY=2 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_SENDING_T1,
                           (CASE WHEN ST.DUETYPE='RM' AND ST.TRFDAY=3 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_SENDING_T2,
                           (CASE WHEN ST.DUETYPE='RM' AND ST.TRFDAY=4 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_SENDING_T3,
                           (CASE WHEN ST.DUETYPE='RM' AND ST.TRFDAY >4 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_SENDING_TN,
                           (CASE WHEN ST.DUETYPE='SS' AND ST.NDAY=0 THEN ST.ST_QTTY ELSE 0 END) REMAINQTTY
                        FROM VW_BD_PENDING_SETTLEMENT ST
                        WHERE DUETYPE='RS' OR DUETYPE='SS' OR DUETYPE = 'RM'
                        ) ST
                        GROUP BY ST.AFACCTNO, ST.CODEID, ST.SYMBOL
                   ) ST,
                   (SELECT DF.CODEID, DF.AFACCTNO,  SUM(DF.DFQTTY+DF.RCVQTTY+DF.BLOCKQTTY+DF.CARCVQTTY) DEALQTTY, sum(df.dftrading) dftrading
                        FROM v_getdealinfo DF WHERE DF.STATUS IN ('P','A','N') GROUP BY DF.CODEID, DF.AFACCTNO) DF,
                   (select acctno, sum(case when QTTYTYPE ='002' then qtty else 0 end) qtty,
                                   sum(case when QTTYTYPE ='002' then dfqtty else 0 end) dfqtty
                    from semastdtl
                        where qtty>0
                        and deltd <> 'Y'
                    group by acctno) dtl
              WHERE AF.ACCTNO = MST.AFACCTNO AND AF.CUSTID= CF.CUSTID
               AND MST.ACCTNO=B.SEACCTNO(+)
               AND MST.ACCTNO=dtl.ACCTNO(+)
               AND MST.ACCTNO = p_acctno
               AND MST.CODEID= CCY.CODEID and CCY.SECTYPE<>'004'
               AND MST.AFACCTNO=ST.AFACCTNO (+) AND MST.CODEID=ST.CODEID (+)
               AND MST.AFACCTNO=DF.AFACCTNO (+) AND MST.CODEID=DF.CODEID (+)
               AND TRIM(CD1.CDTYPE) = 'SE' AND TRIM(CD1.CDNAME)='STATUS'
               AND TRIM(MST.STATUS) = TRIM(CD1.CDVAL);

        /*SELECT CF.CUSTODYCD,MST.ACCTNO, MST.AFACCTNO,MST.ACTYPE, MST.LASTDATE, MST.CODEID, MST.STATUS,
               MST.COSTPRICE, MST.TRADE-NVL(B.SECUREAMT,0) TRADE,
                 MST.WTRADE, MST.MORTAGE-NVL(B.SECUREMTG,0) MORTAGE , MST.NETTING,
                 NVL(B.SECUREAMT,0)+NVL(B.SECUREMTG,0) SECURED,
                 MST.WITHDRAW, MST.BLOCKED, MST.DEPOSIT, MST.SENDDEPOSIT,MST.PREVQTTY,
                 MST.DTOCLOSE,MST.DCRQTTY,MST.DCRAMT,
                 MST.RECEIVING, CCY.SYMBOL, CD1.CDCONTENT DESC_STATUS,
                 ABS(STANDING) ABSTANDING, MST.TRADE-NVL(B.SECUREAMT,0) AVLWITHDRAW,
                 (MST.TRADE+MST.MORTAGE+MST.BLOCKED+MST.NETTING+MST.WTRADE) TOTAL_QTTY,
                  NVL(DF.DEALQTTY,0) DEAL_QTTY,
                 (CASE WHEN ST.DUETYPE='RS' AND ST.TDAY=0 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_RECEIVING_T0,
                 (CASE WHEN ST.DUETYPE='RS' AND ST.TDAY=1 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_RECEIVING_T1,
                 (CASE WHEN ST.DUETYPE='RS' AND ST.TDAY=2 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_RECEIVING_T2,
                 (CASE WHEN ST.DUETYPE='RS' AND ST.TDAY=3 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_RECEIVING_T3,
                 (CASE WHEN ST.DUETYPE='RS' AND ST.TDAY>3 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_RECEIVING_TN,
                 (CASE WHEN ST.DUETYPE='SS' AND ST.NDAY=0 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_SENDING_T0,
                 (CASE WHEN ST.DUETYPE='SS' AND ST.NDAY=-1 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_SENDING_T1,
                 (CASE WHEN ST.DUETYPE='SS' AND ST.NDAY=-2 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_SENDING_T2,
                 (CASE WHEN ST.DUETYPE='SS' AND ST.NDAY=-3 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_SENDING_T3,
                 (CASE WHEN ST.DUETYPE='SS' AND ST.NDAY<-3 THEN ST.ST_QTTY ELSE 0 END) SECURITIES_SENDING_TN,
                 af.CAREBY,
                 NVL(B.SECUREAMT,0)+NVL(B.SECUREMTG,0) - (CASE WHEN ST.DUETYPE='SS' AND ST.NDAY=0 THEN ST.ST_QTTY ELSE 0 END) REMAINQTTY,
                 NVL(DTL.QTTY,0) RESTRICTQTTY
              FROM AFMAST AF, SEMAST MST,CFMAST CF, ALLCODE CD1, v_getsellorderinfo B,SBSECURITIES CCY,
                   (SELECT * FROM VW_BD_PENDING_SETTLEMENT WHERE DUETYPE='RS' OR DUETYPE='SS') ST,
                   (SELECT DF.CODEID, DF.AFACCTNO,  SUM(DF.DFQTTY+DF.RCVQTTY+DF.BLOCKQTTY+DF.CARCVQTTY) DEALQTTY
                        FROM DFMAST DF WHERE DF.STATUS IN ('P','A','N') GROUP BY DF.CODEID, DF.AFACCTNO) DF,
                   (select acctno, sum(qtty) qtty
                    from semastdtl
                        where QTTYTYPE ='002' and qtty>0
                        and deltd <> 'Y'
                    group by acctno) dtl
              WHERE AF.ACCTNO = MST.AFACCTNO AND AF.CUSTID= CF.CUSTID
               AND MST.ACCTNO=B.SEACCTNO(+)
               AND MST.ACCTNO=dtl.ACCTNO(+)
               AND MST.ACCTNO = p_acctno
               AND MST.CODEID= CCY.CODEID and CCY.SECTYPE<>'004'
               AND MST.AFACCTNO=ST.AFACCTNO (+) AND MST.CODEID=ST.CODEID (+)
               AND MST.AFACCTNO=DF.AFACCTNO (+) AND MST.CODEID=DF.CODEID (+)
               AND TRIM(CD1.CDTYPE) = 'SE' AND TRIM(CD1.CDNAME)='STATUS'
               AND TRIM(MST.STATUS) = TRIM(CD1.CDVAL);*/

        --commit;
        PLOG.debug(pkgctx,'End pr_gen_buf_se_account' || p_acctno);
    end if;

    plog.setENDsection(pkgctx, 'pr_gen_buf_se_account');
EXCEPTION WHEN others THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_gen_buf_se_account');
END pr_gen_buf_se_account;


    --Bat dau Ham xu ly dat lenh vao FOMAST--
/*  procedure pr_InternalTransfer()
  begin
    plog.setbeginsection(pkgctx, 'pr_placeorder');


    plog.debug(pkgctx, p_text);
    plog.setendsection(pkgctx, 'pr_placeorder');
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'pr_placeorder');
  end pr_InternalTransfer;*/
  --Ket thuc Ham xu ly dat lenh vao pr_InternalTransfer--

/*
procedure pr_get_ciacount
    (p_refcursor in out pkg_report.ref_cursor,
    p_custodycd in VARCHAR2,
    p_afacctno  IN  varchar2)
IS
    V_CUSTODYCD     varchar2(10);
    V_AFACCTNO      varchar2(10);
begin
    plog.setbeginsection(pkgctx, 'pr_get_ciacount');

    IF p_custodycd = 'ALL' OR p_custodycd is NULL THEN
        V_CUSTODYCD := '%%';
    ELSE
        V_CUSTODYCD := p_custodycd;
    END IF;

    IF p_afacctno = 'ALL' OR p_afacctno IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := p_afacctno;
    END IF;

    Open p_refcursor for
        SELECT CI.*, NVL(CA.AMT, 0) careceiving
            FROM
                (
                    select afacctno,desc_status,pp,balance,advanceline,baldefovd,
                        AVLADV_T3+AVLADV_T1+AVLADV_T2 avladvance,aamt,bamt,odamt,dealpaidamt,
                        CASE WHEN outstanding < 0 THEN abs(outstanding) ELSE 0 END outstanding,
                        --receiving-cash_receiving_t0-cash_receiving_t1-cash_receiving_t2-cash_receiving_tn careceiving,
                        floatamt,receiving,netting,cash_receiving_t0,cash_receiving_t1,cash_receiving_t2,cash_receiving_t3,cash_receiving_tn,cash_sending_t0,
                        cash_sending_t1,cash_sending_t2,cash_sending_t3,cash_sending_tn,CASH_PENDWITHDRAW,CASH_PENDTRANSFER,
                        AVLADV_T3, AVLADV_T1, AVLADV_T2,
                        --bamt+cash_sending_t1+cash_sending_t2+cash_sending_t3+cash_sending_tn+CASH_PENDWITHDRAW+CASH_PENDTRANSFER cash_pending_send
                        --bamt+cash_sending_t0+cash_sending_t1+cash_sending_t3+cash_sending_tn+CASH_PENDWITHDRAW+CASH_PENDTRANSFER cash_pending_send
                        cash_pending_send
                    from buf_ci_account
                    where custodycd like V_CUSTODYCD
                        AND afacctno LIKE V_AFACCTNO
                ) CI
                LEFT JOIN
                (
                    SELECT CA.AFACCTNO, SUM(NVL(CA.AMT,0)) AMT
                    FROM CAMAST CAM, CASCHD CA
                    WHERE CA.CAMASTID = CAM.CAMASTID AND CAM.CATYPE IN ('010','015','016')
                        AND CA.STATUS = 'S'
                        AND CA.AFACCTNO LIKE V_AFACCTNO
                    GROUP BY CA.AFACCTNO
                ) CA
                ON CI.AFACCTNO = CA.AFACCTNO
    order by CI.afacctno;
    plog.setendsection(pkgctx, 'pr_get_ciacount');
exception when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'pr_get_ciacount');
end pr_get_ciacount;
*/

procedure pr_get_ciacount
    (p_refcursor in out pkg_report.ref_cursor,
    p_custodycd in VARCHAR2,
    p_afacctno  IN  varchar2)
IS
    V_CUSTODYCD     varchar2(10);
    V_AFACCTNO      varchar2(10);
    V_CURRDATE      DATE;
    l_isstopadv     varchar2(10);
begin
    plog.setbeginsection(pkgctx, 'pr_get_ciacount');
    l_isstopadv := cspks_system.fn_get_sysvar('MARGIN','ISSTOPADV');
    IF p_custodycd = 'ALL' OR p_custodycd is NULL THEN
        V_CUSTODYCD := '';
    ELSE
        V_CUSTODYCD := p_custodycd;
    END IF;

    IF p_afacctno = 'ALL' OR p_afacctno IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := p_afacctno;
        SELECT CF.CUSTODYCD INTO V_CUSTODYCD
        FROM AFMAST AF, CFMAST CF
        WHERE AF.custid = CF.custid AND AF.ACCTNO = p_afacctno;
    END IF;

    -- GET CURRENT DATE
    SELECT getcurrdate INTO V_CURRDATE FROM DUAL;
    Open p_refcursor for
        SELECT CI.*, NVL(CA.AMT, 0) careceiving, nvl(LN.TOTALLOAN,0) TOTALLOAN,
        -- begin: 1.5.0.2 | iss: 1737
        fopks_api_rpp.fnc_get_NAV(CI.afacctno) nav
        -- end: 1.5.0.2 | iss: 1737
            FROM
                (
                    select afacctno,desc_status,ROUND(pp) PP,ROUND(balance) BALANCE,ROUND(advanceline) advanceline,
                        ROUND(baldefovd) baldefovd, ROUND(LEAST(avlwithdraw, NVL(fowithdraw, avlwithdraw + 1))) avlwithdraw,
                        ROUND(decode(l_isstopadv,'Y',0,AVLADV_T3+AVLADV_T1+AVLADV_T2)) avladvance,ROUND(aamt) AAMT,ROUND(bamt) BAMT,
                        ROUND(odamt+DFODAMT) ODAMT,ROUND(dealpaidamt) dealpaidamt,
                        CASE WHEN outstanding < 0 THEN ROUND(abs(outstanding)) ELSE 0 END outstanding,
                        --receiving-cash_receiving_t0-cash_receiving_t1-cash_receiving_t2-cash_receiving_tn careceiving,
                        ROUND(floatamt) FLOATAMT,ROUND(receiving) receiving,ROUND(netting) netting,
                        ROUND(cash_receiving_t0) cash_receiving_t0,ROUND(cash_receiving_t1) cash_receiving_t1,
                        ROUND(cash_receiving_t2) cash_receiving_t2,ROUND(cash_receiving_t3) cash_receiving_t3,
                        ROUND(cash_receiving_tn) cash_receiving_tn,ROUND(cash_sending_t0) cash_sending_t0,
                        ROUND(cash_sending_t1) cash_sending_t1,ROUND(cash_sending_t2) cash_sending_t2,
                        ROUND(cash_sending_t3) cash_sending_t3,ROUND(cash_sending_tn) cash_sending_tn,
                        ROUND(CASH_PENDWITHDRAW) CASH_PENDWITHDRAW,ROUND(CASH_PENDTRANSFER) CASH_PENDTRANSFER,
                        ROUND(AVLADV_T3) AVLADV_T3, ROUND(AVLADV_T1) AVLADV_T1, ROUND(AVLADV_T2) AVLADV_T2,
                        --bamt+cash_sending_t1+cash_sending_t2+cash_sending_t3+cash_sending_tn+CASH_PENDWITHDRAW+CASH_PENDTRANSFER cash_pending_send
                        --bamt+cash_sending_t0+cash_sending_t1+cash_sending_t3+cash_sending_tn+CASH_PENDWITHDRAW+CASH_PENDTRANSFER cash_pending_send
                        ROUND(cash_pending_send) cash_pending_send,
                        ROUND(casht2_sending_t0+casht2_sending_t1+casht2_sending_t2) casht2sending,
                        ci.marginrate,
                        ADVANCELINE GUA,
                        99999 ADDVND
                    from buf_ci_account ci
                    where ci.custodycd = V_CUSTODYCD
                        AND ci.afacctno LIKE V_AFACCTNO
                        AND EXISTS(SELECT cf.custodycd, af.acctno afacctno
                                    FROM afmast af, otright ot, cfmast cf
                                    WHERE CI.AFACCTNO = AF.ACCTNO AND af.custid = cf.custid
                                        AND ot.authcustid = ot.cfcustid AND af.custid = ot.authcustid
                                        --AND af.status = 'A'
                                        AND ot.deltd = 'N'
                                        AND ot.valdate <= V_CURRDATE AND ot.expdate >= V_CURRDATE
                                        AND CF.custodycd = V_CUSTODYCD
                                        AND AF.acctno LIKE V_AFACCTNO)
                ) CI
                LEFT JOIN
                (
                    SELECT CA.AFACCTNO, SUM(NVL(CA.AMT,0) + nvl(ca.sendamt,0)+ nvl(ca.cutamt,0)) AMT
                    FROM CAMAST CAM, CASCHD CA
                    WHERE CA.CAMASTID = CAM.CAMASTID AND CAM.CATYPE IN ('010','015','016')
                        AND CA.STATUS = 'S'
                        AND CA.AFACCTNO LIKE V_AFACCTNO
                    GROUP BY CA.AFACCTNO
                ) CA
                ON CI.AFACCTNO = CA.AFACCTNO
                LEFT JOIN
                (
                SELECT A.ACCTNO,sum(A.TOTALLOAN) TOTALLOAN from
                (
                SELECT AF.ACCTNO,ROUND(SCHD.INTOVDPRIN + SCHD.FEEINTOVDACR+SCHD.INTNMLACR  + SCHD.INTOVD + SCHD.INTDUE + SCHD.FEEINTNMLACR + SCHD.FEEINTDUE + SCHD.FEEINTNMLOVD+SCHD.NML + SCHD.OVD) TOTALLOAN
                FROM  (SELECT LNSCHD.*
                                     FROM LNSCHD
                                     WHERE REFTYPE IN ('GP', 'P')
                                     AND DUENO = 0) SCHD,LNMAST LN, CFMAST CF, AFMAST AF
                WHERE SCHD.ACCTNO = LN.ACCTNO
                AND LN.TRFACCTNO like V_AFACCTNO
                AND CF.CUSTODYCD like V_CUSTODYCD
                AND AF.CUSTID=CF.CUSTID
                AND LN.TRFACCTNO=AF.ACCTNO) A
                GROUP BY ACCTNO
                ) LN
                 ON LN.ACCTNO=CI.AFACCTNO
    order by CI.afacctno;
    plog.setendsection(pkgctx, 'pr_get_ciacount');
exception when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'pr_get_ciacount');
end pr_get_ciacount;

procedure pr_get_ciacount_short
    (p_refcursor in out pkg_report.ref_cursor,
    p_custodycd in VARCHAR2,
    p_afacctno  IN  varchar2)
IS
    V_CUSTODYCD     varchar2(10);
    V_AFACCTNO      varchar2(10);
    V_CURRDATE      DATE;
    l_isstopadv     varchar2(10);
begin
    plog.setbeginsection(pkgctx, 'pr_get_ciacount_short');
    l_isstopadv := cspks_system.fn_get_sysvar('MARGIN','ISSTOPADV');
    IF p_custodycd = 'ALL' OR p_custodycd is NULL THEN
        V_CUSTODYCD := '';
    ELSE
        V_CUSTODYCD := p_custodycd;
    END IF;

    IF p_afacctno = 'ALL' OR p_afacctno IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := p_afacctno;
        SELECT CF.CUSTODYCD INTO V_CUSTODYCD
        FROM AFMAST AF, CFMAST CF
        WHERE AF.custid = CF.custid AND AF.ACCTNO = p_afacctno;
    END IF;

    -- GET CURRENT DATE
    SELECT getcurrdate INTO V_CURRDATE FROM DUAL;
    Open p_refcursor for
        SELECT  CASH_PENDING_SEND, MARGINRATE, decode(l_isstopadv,'Y',0,AVLADVANCE) AVLADVANCE, BALANCE,ADVANCELINE GUA
        From buf_ci_account ci
      where ci.custodycd = V_CUSTODYCD
          AND ci.afacctno LIKE V_AFACCTNO
          AND EXISTS(SELECT cf.custodycd, af.acctno afacctno
                      FROM afmast af, otright ot, cfmast cf
                      WHERE CI.AFACCTNO = AF.ACCTNO AND af.custid = cf.custid
                          AND ot.authcustid = ot.cfcustid  AND af.custid = ot.authcustid
                          --AND af.status = 'A'
                          AND ot.deltd = 'N'
                          AND ot.valdate <= V_CURRDATE AND ot.expdate >= V_CURRDATE
                          AND CF.custodycd = V_CUSTODYCD
                          AND AF.acctno LIKE V_AFACCTNO);
    plog.setendsection(pkgctx, 'pr_get_ciacount_short');
exception when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'pr_get_ciacount_short');
end pr_get_ciacount_short;

procedure pr_get_seacount
    (p_refcursor in out pkg_report.ref_cursor,
    p_custodycd in VARCHAR2,
    p_afacctno  IN  varchar2)
IS
    V_CUSTODYCD     varchar2(10);
    V_AFACCTNO      varchar2(10);
    V_CURRDATE      DATE;
begin
    plog.setbeginsection(pkgctx, 'pr_get_seacount');
    IF p_custodycd = 'ALL' OR p_custodycd is NULL THEN
        V_CUSTODYCD := '';
    ELSE
        V_CUSTODYCD := p_custodycd;
    END IF;

    IF p_afacctno = 'ALL' OR p_afacctno IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := p_afacctno;
        SELECT CF.CUSTODYCD INTO V_CUSTODYCD
        FROM AFMAST AF, CFMAST CF
        WHERE AF.custid = CF.custid AND AF.ACCTNO = p_afacctno;
    END IF;
    -- GET CURRENT DATE
    SELECT getcurrdate INTO V_CURRDATE FROM DUAL;

    Open p_refcursor for
        select afacctno,
             SE.symbol,
             total_qtty,
             trade,
             netting + SECURED netting,
             deal_qtty,
             abstanding,
             blocked,
             MORTAGE,
             securities_receiving_t0,
             securities_receiving_t1,
             securities_receiving_t2,
             securities_receiving_t3,
             securities_sending_t0,
             securities_sending_t1,
             securities_sending_t2,
             securities_sending_t3,
             RESTRICTQTTY,
             dftrading,
             trade+netting+SECURED+MORTAGE+RESTRICTQTTY+blocked
            /*+securities_sending_t1+securities_sending_t2+securities_sending_t0+securities_sending_t3*/ avlqtty
        from buf_se_account se, sbsecurities sb
        where se.codeid = sb.codeid --AND sb.sectype IN ('001','006','007')
            AND se.custodycd = V_CUSTODYCD
            AND se.afacctno LIKE V_AFACCTNO
            AND total_qtty+deal_qtty+abstanding+securities_receiving_t0+securities_receiving_t1+securities_receiving_t2+receiving
                +securities_receiving_t3+securities_sending_t0+securities_sending_t1+securities_sending_t2+securities_sending_t3+RESTRICTQTTY+dftrading <> 0
            /*AND EXISTS(SELECT cf.custodycd, af.acctno afacctno
                        FROM afmast af, otright ot, cfmast cf
                        WHERE se.AFACCTNO = AF.ACCTNO AND af.custid = cf.custid
                            AND af.acctno = ot.afacctno AND af.custid = ot.authcustid
                            AND af.status = 'A' AND ot.deltd = 'N'
                            AND ot.valdate <= V_CURRDATE AND ot.expdate >= V_CURRDATE
                            AND CF.custodycd = V_CUSTODYCD
                            AND AF.acctno LIKE V_AFACCTNO)*/
        order by afacctno,symbol;
    plog.setendsection(pkgctx, 'pr_get_seacount');
exception when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'pr_get_seacount');
end pr_get_seacount;


procedure pr_get_rpt1002(p_refcursor in out pkg_report.ref_cursor,
                        p_custodycd in varchar2,
                        p_afcctno in varchar2,
                        p_frdate in varchar2,
                        p_todate in varchar2)
is
begin
    plog.setbeginsection(pkgctx, 'pr_get_rpt1002');
    cf1002 (
       p_refcursor,
       'A',
       '',
       p_frdate,
       p_todate,
       p_custodycd,
       p_afcctno,
       '0001'
    );
    plog.setendsection(pkgctx, 'pr_get_rpt1002');
exception when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'pr_get_rpt1002');
end pr_get_rpt1002;

PROCEDURE pr_trg_account_log (p_acctno in VARCHAR2, p_mod varchar2)
IS
BEGIN
    plog.setbeginsection (pkgctx, 'pr_trg_account_log');
    if p_mod = 'SE' THEN
        plog.debug (pkgctx, 'log_se_account: ' || p_acctno);
        insert into log_se_account (autoid,acctno,status, logtime, applytime)
        values (seq_log_se_account.nextval,p_acctno,'P', SYSTIMESTAMP,NULL);
    elsif p_mod = 'CI' THEN
        plog.debug (pkgctx, 'log_ci_account: ' || p_acctno);
        insert into log_ci_account (autoid,acctno,status, logtime, applytime)
        values (seq_log_ci_account.nextval,p_acctno,'P', SYSTIMESTAMP,NULL);
    elsif p_mod = 'OD' THEN
        plog.debug (pkgctx, 'log_of_account: ' || p_acctno);
        insert into log_od_account (autoid,acctno,status, logtime, applytime)
        values (seq_log_od_account.nextval,p_acctno,'P', SYSTIMESTAMP,NULL);
    end if;
    plog.setendsection (pkgctx, 'pr_trg_account_log');
EXCEPTION WHEN OTHERS THEN
    plog.error(SQLERRM);
    plog.debug (pkgctx,'got error on release pr_trg_account_log');
    plog.setbeginsection(pkgctx, 'pr_trg_account_log');
END pr_trg_account_log;


-- Lay danh muc dau tu cua khach hang
-- TheNN, 05-Jan-2012
PROCEDURE pr_get_Portfolio
    (p_refcursor in out pkg_report.ref_cursor,
     CUSTODYCD    IN VARCHAR2,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     SYMBOL         IN  VARCHAR2,
     GETTYPE        IN  VARCHAR2)
    IS

  V_CUSTODYCD   VARCHAR2(10);
  V_AFACCTNO    VARCHAR2(10);
  V_SYMBOL      VARCHAR2(20);
  V_CUSTID      VARCHAR2(10);

BEGIN
    V_CUSTODYCD := CUSTODYCD;
    --V_AFACCTNO := AFACCTNO;


    IF SYMBOL = 'ALL'  OR SYMBOL IS NULL THEN
        V_SYMBOL := '%%';
    ELSE
        V_SYMBOL := SYMBOL;
    END IF;

    IF AFACCTNO = 'ALL'  OR AFACCTNO IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := AFACCTNO;
    END IF;

    -- LAY THONG TIN MA KHACH HANG
    IF CUSTODYCD = 'ALL' OR CUSTODYCD IS NULL THEN
        V_CUSTID := '%%';
    ELSE
        SELECT CUSTID INTO V_CUSTID FROM CFMAST WHERE CUSTODYCD = V_CUSTODYCD;
    END IF;

    -- LAY THONG TIN DANH MUC DAU TU
    IF GETTYPE = '001' THEN -- CP DANG NAM GIU
        OPEN p_refcursor FOR
            SELECT V_CUSTODYCD CUSTODYCD, V_CUSTID CUSTID, AF.ACCTNO AFACCTNO, SE.ACCTNO SEACCTNO, SE.CODEID, SB.SYMBOL,
                NVL(SE.TRADE,0) + NVL(SE.MORTAGE,0) + NVL(SE.BLOCKED,0) /*+ NVL(SE.NETTING,0)*/ SEQTTY, SE.COSTPRICE, SB.BASICPRICE,
                (NVL(SE.TRADE,0) + NVL(SE.MORTAGE,0) + NVL(SE.BLOCKED,0) /*+ NVL(SE.NETTING,0)*/) * SE.COSTPRICE VAL,
                (NVL(SE.TRADE,0) + NVL(SE.MORTAGE,0) + NVL(SE.BLOCKED,0) /*+ NVL(SE.NETTING,0)*/) * SB.BASICPRICE CURVAL,
                (NVL(SE.TRADE,0) + NVL(SE.MORTAGE,0) + NVL(SE.BLOCKED,0) /*+ NVL(SE.NETTING,0)*/) * (SB.BASICPRICE-SE.COSTPRICE) PROFITANDLOSS,
                CASE WHEN SE.COSTPRICE>0 THEN round((SB.BASICPRICE-SE.COSTPRICE)/SE.COSTPRICE * 100,4) ELSE 0 END PCPROFITANDLOSS,
                CASE WHEN datediff('MONTH', SE.OPNDATE,sysdate) <=6 AND sbs.refcodeid IS NULL THEN 'Y' ELSE 'N' END EDITABLE, NVL(CA.QTTY,0) RIGHTQTTY
               , buf.securities_receiving_t0 + buf.securities_receiving_t1 +buf.securities_receiving_t2+buf.securities_receiving_t3 securities_receiving
         FROM SEMAST SE, AFMAST AF, SECURITIES_INFO SB, SBSECURITIES SBS, (select sum(qtty) qtty,codeid,afacctno from caschd where deltd='N' AND status='S' group by codeid,afacctno) CA
            , buf_se_account     buf
            WHERE SE.AFACCTNO = AF.ACCTNO
                AND SE.CODEID = SB.CODEID
                AND SB.CODEID = SBS.CODEID
                and buf.acctno= se.acctno
                and se.codeid = ca.codeid(+)
                and se.acctno=ca.afacctno(+)
                --AND NVL(SE.TRADE,0) + NVL(SE.MORTAGE,0) + NVL(SE.BLOCKED,0) + NVL(SE.NETTING,0) >0
                AND NVL(SE.TRADE,0) + NVL(SE.MORTAGE,0) + NVL(SE.BLOCKED,0) >0 --Khong lay ra neu da ban het CK.
                AND SBS.SECTYPE NOT IN ('004','009') -- Ko lay len cac CK quyen mua cho giao dich
                AND AF.CUSTID LIKE V_CUSTID
                AND AF.ACCTNO LIKE V_AFACCTNO
                AND SB.SYMBOL LIKE V_SYMBOL
            ORDER BY SB.SYMBOL, AF.ACCTNO, SB.SYMBOL;
    ELSIF GETTYPE = '002' THEN -- CP DA BAN
        OPEN p_refcursor FOR
            SELECT STS.SEACCTNO, STS.AFACCTNO, SUM(STS.AMT) AMT, SUM(STS.QTTY) QTTY, STS.CODEID,
                MAX(STS.SYMBOL) SYMBOL, round(SUM(STS.AMT)/SUM(STS.QTTY),4) SELLPRICE,
                ROUND(SUM(STS.COSTPRICE * STS.QTTY)/SUM(STS.QTTY),4) COSTPRICE,
                SUM(STS.AMT) - SUM(STS.COSTPRICE*STS.QTTY) PROFITANDLOSS,
                CASE WHEN SUM(STS.COSTPRICE*STS.QTTY)/SUM(STS.QTTY) > 0
                        THEN ROUND(100*(SUM(STS.AMT) - SUM(STS.COSTPRICE*STS.QTTY))/SUM(STS.COSTPRICE*STS.QTTY),4)
                        ELSE 0 END PCPROFITANDLOSS
            FROM
                (
                    SELECT STS.TXDATE, STS.ACCTNO SEACCTNO, STS.AFACCTNO, STS.AMT AMT, STS.QTTY QTTY, STS.CODEID,
                        SB.SYMBOL SYMBOL, CASE WHEN STS.txdate = getcurrdate THEN SE.costprice ELSE STS.costprice END costprice
                    FROM VW_STSCHD_ALL STS, SBSECURITIES SB, AFMAST AF, SEMAST SE
                    WHERE STS.DUETYPE= 'SS' AND SB.CODEID = STS.CODEID
                        AND AF.ACCTNO = STS.AFACCTNO
                        AND STS.acctno = SE.acctno
                        AND SB.SECTYPE NOT IN ('004','009') -- Ko lay len cac CK quyen mua cho giao dich
                        AND AF.CUSTID LIKE V_CUSTID
                        AND STS.AFACCTNO LIKE V_AFACCTNO
                        AND SB.SYMBOL LIKE V_SYMBOL
                        --AND STS.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
                        --AND STS.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                ) STS
            GROUP BY STS.SEACCTNO, STS.AFACCTNO, STS.CODEID
            ORDER BY MAX(STS.SYMBOL), STS.AFACCTNO, STS.SEACCTNO
            ;
    ELSIF GETTYPE = '003' THEN -- TOAN BO CP
        OPEN p_refcursor FOR
            SELECT STS.*
            FROM
            (
                SELECT STS.AFACCTNO, STS.SEACCTNO, STS.SYMBOL, STS.CODEID, STS.SEQTTY,
                    CASE WHEN STS.SEQTTY = 0 THEN NVL(B_STS.B_COSTPRICE,0) ELSE STS.COSTPRICE END COSTPRICE, STS.BASICPRICE, STS.VAL,
                    STS.CURVAL, STS.PROFITANDLOSS, STS.PCPROFITANDLOSS, NVL(B_STS.AMT,0) BUYAMT, NVL(B_STS.QTTY,0) BUYQTTY,
                    NVL(S_STS.AMT,0) SELLAMT, NVL(S_STS.QTTY,0) SELLQTTY, NVL(S_STS.SELLPRICE,0) SELLPRICE, NVL(S_STS.PROFITANDLOSS,0) RPROFITANDLOSS,
                    NVL(S_STS.PCPROFITANDLOSS,0) RPCPROFITANDLOSS
                FROM
                    (
                        SELECT AF.ACCTNO AFACCTNO, SE.ACCTNO SEACCTNO, SE.CODEID, SB.SYMBOL,
                            NVL(SE.TRADE,0) + NVL(SE.MORTAGE,0) + NVL(SE.BLOCKED,0) /*+ NVL(SE.NETTING,0)*/ SEQTTY, SE.COSTPRICE, SB.BASICPRICE,
                            (NVL(SE.TRADE,0) + NVL(SE.MORTAGE,0) + NVL(SE.BLOCKED,0) /*+ NVL(SE.NETTING,0)*/) * SE.COSTPRICE VAL,
                            (NVL(SE.TRADE,0) + NVL(SE.MORTAGE,0) + NVL(SE.BLOCKED,0) /*+ NVL(SE.NETTING,0)*/) * SB.BASICPRICE CURVAL,
                            (NVL(SE.TRADE,0) + NVL(SE.MORTAGE,0) + NVL(SE.BLOCKED,0) /*+ NVL(SE.NETTING,0)*/) * (SB.BASICPRICE-SE.COSTPRICE) PROFITANDLOSS,
                            CASE WHEN SE.COSTPRICE>0 THEN round((SB.BASICPRICE-SE.COSTPRICE)/(SE.COSTPRICE) * 100,4) ELSE 0 END PCPROFITANDLOSS
                        FROM SEMAST SE, AFMAST AF, SECURITIES_INFO SB, SBSECURITIES SBS
                        WHERE SE.AFACCTNO = AF.ACCTNO
                            AND SE.CODEID = SB.CODEID
                            AND SBS.CODEID = SB.CODEID
                            AND SBS.SECTYPE NOT IN ('004','009') -- Ko lay len cac CK quyen mua cho giao dich
                            AND AF.CUSTID LIKE V_CUSTID
                            AND AF.ACCTNO LIKE V_AFACCTNO
                            AND SB.SYMBOL LIKE V_SYMBOL
                    ) STS,
                    (
                        SELECT STS.ACCTNO SEACCTNO, STS.AFACCTNO, SUM(STS.AMT) AMT, SUM(STS.QTTY) QTTY, STS.CODEID,
                            round(SUM(STS.AMT + (CASE WHEN OD.EXECAMT >0 AND OD.FEEACR =0 AND OD.STSSTATUS = 'N' THEN OD.EXECAMT*ODT.DEFFEERATE/100 ELSE OD.FEEACR END))/SUM(STS.QTTY),4) B_COSTPRICE
                        FROM VW_STSCHD_ALL STS, AFMAST AF, SBSECURITIES SB, vw_odmast_all OD, ODTYPE ODT
                        WHERE STS.DUETYPE= 'RS' AND STS.CODEID = SB.CODEID
                            AND AF.ACCTNO = STS.AFACCTNO
                            AND STS.orgorderid = OD.orderid
                            AND OD.actype = ODT.actype
                            AND AF.CUSTID LIKE V_CUSTID
                            AND STS.AFACCTNO LIKE V_AFACCTNO
                            AND SB.SYMBOL LIKE V_SYMBOL
                            --AND STS.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
                            --AND STS.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                        GROUP BY STS.ACCTNO, STS.AFACCTNO, STS.CODEID
                    ) B_STS,
                    (
                        SELECT STS.SEACCTNO, STS.AFACCTNO, SUM(STS.AMT) AMT, SUM(STS.QTTY) QTTY, STS.CODEID,
                            MAX(STS.SYMBOL) SYMBOL, round(SUM(STS.AMT)/SUM(STS.QTTY),4) SELLPRICE,
                            ROUND(SUM(STS.COSTPRICE * STS.QTTY)/SUM(STS.QTTY),4) COSTPRICE,
                            SUM(STS.AMT) - SUM(STS.COSTPRICE*STS.QTTY) PROFITANDLOSS,
                            CASE WHEN SUM(STS.COSTPRICE*STS.QTTY)/SUM(STS.QTTY) > 0
                                    THEN ROUND(100*(SUM(STS.AMT) - SUM(STS.COSTPRICE*STS.QTTY))/SUM(STS.COSTPRICE*STS.QTTY),4)
                                    ELSE 0 END PCPROFITANDLOSS
                        FROM
                            (
                                SELECT STS.TXDATE, STS.ACCTNO SEACCTNO, STS.AFACCTNO, STS.AMT AMT, STS.QTTY QTTY, STS.CODEID,
                                    SB.SYMBOL SYMBOL, CASE WHEN STS.txdate = getcurrdate THEN SE.costprice ELSE STS.costprice END costprice
                                FROM VW_STSCHD_ALL STS, SBSECURITIES SB, AFMAST AF, SEMAST SE
                                WHERE STS.DUETYPE= 'SS' AND SB.CODEID = STS.CODEID
                                    AND AF.ACCTNO = STS.AFACCTNO
                                    AND STS.acctno = SE.acctno
                                    AND SB.SECTYPE NOT IN ('004','009') -- Ko lay len cac CK quyen mua cho giao dich
                                    AND AF.CUSTID LIKE V_CUSTID
                                    AND STS.AFACCTNO LIKE V_AFACCTNO
                                    AND SB.SYMBOL LIKE V_SYMBOL
                                    --AND STS.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
                                    --AND STS.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                            ) STS
                        GROUP BY STS.SEACCTNO, STS.AFACCTNO, STS.CODEID
                    ) S_STS
                WHERE STS.SEACCTNO = B_STS.SEACCTNO(+)
                    AND STS.SEACCTNO = S_STS.SEACCTNO(+)
            ) STS
            WHERE STS.SEQTTY + STS.BUYQTTY + STS.SELLQTTY>0
            ORDER BY STS.SYMBOL,STS.AFACCTNO, STS.SEACCTNO;
    END IF;

EXCEPTION
  WHEN OTHERS THEN
     plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'pr_get_Portfolio');
END pr_get_Portfolio;

PROCEDURE PR_FO_FOBANNK2OD (p_FOORDERID IN VARCHAR2)
    IS
        L_TXMSG         TX.MSG_RECTYPE;
        V_TLTXCD        VARCHAR2 (4);
        V_ORDERID       VARCHAR2 (50);
        V_TXDATE        DATE;
        V_AFACCTNO      VARCHAR2 (50);
        V_EXECTYPE      VARCHAR2 (50);
        V_PRICETYPE     VARCHAR2 (50);
        V_SYMBOL        VARCHAR2 (50);
        V_BANKACCT      VARCHAR2 (50);
        V_BANKCODE      VARCHAR2 (50);
        V_NOTES         VARCHAR2 (250);
        V_QTTY          NUMBER (20);
        V_PRICE         NUMBER (20, 4);
        V_AVLBAL        NUMBER (20);
        V_HOLDAMT       NUMBER (20);
        V_ACTYPE        VARCHAR2 (50);
        V_CLEARDAY      NUMBER (5);
        V_BRATIO        NUMBER (10, 4);
        V_MINFEEAMT     NUMBER (10);
        V_DEFFEERATE    NUMBER (10, 4);
        V_STRCURRDATE   VARCHAR2 (10);
        V_STRDESC       VARCHAR2 (250);
        V_STREN_DESC    VARCHAR2 (250);
        L_ERR_CODE      VARCHAR2 (50);
        P_ERR_CODE      VARCHAR2 (50);
        L_ERR_PARAM     VARCHAR2 (300);
    BEGIN
        PLOG.SETBEGINSECTION (PKGCTX, 'pr_fo_fobannk2od');

        --Lay thong so lenh can sync
        /*SELECT   ACTYPE,CLEARDAY,BRATIO,MINFEEAMT,DEFFEERATE
          INTO   V_ACTYPE,V_CLEARDAY,V_BRATIO,V_MINFEEAMT,V_DEFFEERATE
          FROM   (  SELECT   A.ACTYPE,A.CLEARDAY,A.BRATIO,A.MINFEEAMT,A.DEFFEERATE,B.ODRNUM
                      FROM   ODTYPE A,AFIDTYPE B,FOMAST F,SBSECURITIES S,AFMAST AF
                     WHERE       A.STATUS = 'Y'
                             AND F.CODEID = S.CODEID
                             AND F.AFACCTNO = AF.ACCTNO
                             AND (A.VIA = F.VIA OR A.VIA = 'A')          --VIA
                             AND A.CLEARCD = F.CLEARCD               --CLEARCD
                             AND (A.EXECTYPE = F.EXECTYPE  --l_build_msg.fld22
                                                         OR A.EXECTYPE = 'AA') --EXECTYPE
                             AND (A.TIMETYPE = F.TIMETYPE OR A.TIMETYPE = 'A') --TIMETYPE
                             AND (A.PRICETYPE = F.PRICETYPE
                                  OR A.PRICETYPE = 'AA')           --PRICETYPE
                             AND (A.MATCHTYPE = F.MATCHTYPE
                                  OR A.MATCHTYPE = 'A')            --MATCHTYPE
                             AND (A.TRADEPLACE = S.TRADEPLACE
                                  OR A.TRADEPLACE = '000')
                             AND (INSTR (
                                      CASE
                                          WHEN S.SECTYPE IN ('001', '002')
                                          THEN
                                              S.SECTYPE || ',' || '111,333'
                                          WHEN S.SECTYPE IN ('003', '006')
                                          THEN
                                              S.SECTYPE || ',' || '222,333,444'
                                          WHEN S.SECTYPE IN ('008')
                                          THEN
                                              S.SECTYPE || ',' || '111,444'
                                          ELSE
                                              S.SECTYPE
                                      END,
                                      A.SECTYPE) > 0
                                  OR A.SECTYPE = '000')
                             AND (A.NORK = F.NORK OR A.NORK = 'A')      --NORK
                             AND (CASE
                                      WHEN A.CODEID IS NULL THEN F.CODEID
                                      ELSE A.CODEID
                                  END) = F.CODEID
                             AND A.ACTYPE = B.ACTYPE
                             AND B.AFTYPE = AF.ACTYPE
                             AND B.OBJNAME = 'OD.ODTYPE'
                             AND F.ACCTNO = p_FOORDERID
                  ORDER BY   B.ODRNUM DESC)
         WHERE   ROWNUM <= 1;*/

        --plog.debug(PKGCTX,'p_FOORDERID: ' || p_FOORDERID);
         --Lay thong so lenh can sync
        SELECT   A.ACTYPE,A.CLEARDAY,A.BRATIO,A.MINFEEAMT,A.DEFFEERATE
        INTO   V_ACTYPE,V_CLEARDAY,V_BRATIO,V_MINFEEAMT,V_DEFFEERATE
        FROM ODTYPE A, FOMAST F
        WHERE A.ACTYPE = F.ACTYPE
            AND F.ACCTNO = p_FOORDERID;

        --plog.debug(PKGCTX,'V_ACTYPE: ' || V_ACTYPE);

        --tinh toan so du can hold
        SELECT   FO.ACCTNO ORDERID,
                 TO_DATE (SUBSTR (FO.ACCTNO, 1, 10), 'DD/MM/RRRR'),
                 AF.BANKACCTNO,
                 AF.BANKNAME,
                 FO.AFACCTNO,
                 FO.QUOTEPRICE * 1000 * FO.QUANTITY * V_BRATIO / 100
                -- - GREATEST(GETAVLPP(AF.ACCTNO)-NVL(HM.HLDAMT,0),0)
                -- Ducnv rao lai de tinh ca phi luu ky
                 - (GETAVLPP(AF.ACCTNO)-NVL(HM.HLDAMT,0))
                 + (CASE
                        WHEN V_MINFEEAMT >
                                 (  FO.QUOTEPRICE
                                  * 1000
                                  * FO.QUANTITY
                                  * V_DEFFEERATE
                                  / 100)
                        THEN
                            V_MINFEEAMT
                        ELSE
                            (  FO.QUOTEPRICE
                             * 1000
                             * FO.QUANTITY
                             * V_DEFFEERATE
                             / 100)
                    END)
               --  + GREATEST(CI.DEPOFEEAMT-CI.HOLDBALANCE,0) -- Ducnv rao lai de tinh ca phi luu ky
                 HOLDAMT,
                 FO.EXECTYPE
                 || '.'
                 || FO.SYMBOL
                 || ': '
                 || TO_CHAR (FO.QUANTITY)
                 || '@'
                 || DECODE (FO.PRICETYPE,
                            'LO', TO_CHAR (FO.QUOTEPRICE),
                            FO.PRICETYPE)
          INTO   V_ORDERID,
                 V_TXDATE,
                 V_BANKACCT,
                 V_BANKCODE,
                 V_AFACCTNO,
                 V_HOLDAMT,
                 V_NOTES
          FROM   FOMAST FO, AFMAST AF, CIMAST CI,
          (
            SELECT NVL(SUM(A.HLDAMT),0) HLDAMT,A.AFACCTNO FROM
            (
                SELECT NVL(SUM(REQ.TXAMT),0) HLDAMT,REQ.AFACCTNO
                FROM crbtxreq REQ
                WHERE REQ.TRFCODE='HOLD' AND REQ.STATUS='P'
                GROUP BY REQ.AFACCTNO
                UNION ALL
                SELECT NVL(SUM(RQ.MSGAMT),0) HLDAMT,RQ.MSGACCT AFACCTNO
                FROM BORQSLOG RQ WHERE RQ.STATUS='H'
                GROUP BY MSGACCT
            ) A GROUP BY A.AFACCTNO
          ) HM
         WHERE   FO.ACCTNO = p_FOORDERID
                 AND FO.AFACCTNO = AF.ACCTNO
                 AND CI.AFACCTNO = AF.ACCTNO
                 AND FO.EXECTYPE IN ('NB')
                 --AND FO.TIMETYPE <> 'G'
                 AND FO.AFACCTNO=HM.AFACCTNO(+)
        UNION ALL --Neu la lenh sua, tinh xem can phai hold them hay ko, hold bao nhieu
        SELECT   FO.ACCTNO ORDERID,
                 TO_DATE (SUBSTR (FO.ACCTNO, 1, 10), 'DD/MM/RRRR'),
                 AF.BANKACCTNO,
                 AF.BANKNAME,
                 FO.AFACCTNO,
                 CASE WHEN fo.price < fo.refprice THEN 0 else
                 GREATEST (
                     FO.QUOTEPRICE * 1000 * FO.QUANTITY * V_BRATIO / 100
                     + (CASE
                            WHEN V_MINFEEAMT >
                                     (  FO.QUOTEPRICE
                                      * 1000
                                      * FO.QUANTITY
                                      * V_DEFFEERATE
                                      / 100)
                            THEN
                                V_MINFEEAMT
                            ELSE
                                (  FO.QUOTEPRICE
                                 * 1000
                                 * FO.QUANTITY
                                 * V_DEFFEERATE
                                 / 100)
                        END)
                     - OD.ORDERQTTY * OD.QUOTEPRICE * OD.BRATIO/100--TL.MSGAMTTL.MSGAMT
                     -- - GREATEST(GETAVLPP(AF.ACCTNO)-NVL(HM.HLDAMT,0),0) ducnv rao de tinh ca phi luu ky
                     - (GETAVLPP(AF.ACCTNO)-NVL(HM.HLDAMT,0)),
                     -- + GREATEST(CI.DEPOFEEAMT-CI.HOLDBALANCE,0), ducnv rao de tinh ca phi luu ky
                     0) end
                     HOLDAMT,
                    FO.EXECTYPE
                 || '.'
                 || FO.SYMBOL
                 || ': '
                 || TO_CHAR (FO.QUANTITY)
                 || '@'
                 || DECODE (FO.PRICETYPE,
                            'LO', TO_CHAR (FO.QUOTEPRICE),
                            FO.PRICETYPE)
          FROM   FOMAST FO,
                 AFMAST AF,
                 CIMAST CI,
                 ODMAST OD,
                 TLLOG TL,
                (
                    SELECT NVL(SUM(A.HLDAMT),0) HLDAMT,A.AFACCTNO FROM
                    (
                        SELECT NVL(SUM(REQ.TXAMT),0) HLDAMT,REQ.AFACCTNO
                        FROM crbtxreq REQ
                        WHERE REQ.TRFCODE='HOLD' AND REQ.STATUS='P'
                        GROUP BY REQ.AFACCTNO
                        UNION ALL
                        SELECT NVL(SUM(RQ.MSGAMT),0) HLDAMT,RQ.MSGACCT AFACCTNO
                        FROM BORQSLOG RQ WHERE RQ.STATUS='H'
                        GROUP BY MSGACCT
                    ) A GROUP BY A.AFACCTNO
                  ) HM
         WHERE       FO.ACCTNO = p_FOORDERID
                 AND FO.AFACCTNO = AF.ACCTNO
                 AND CI.AFACCTNO = AF.ACCTNO
                 AND FO.REFACCTNO = OD.ORDERID
                 AND OD.TXNUM = TL.TXNUM
                 AND OD.DELTD <> 'Y'
                 AND FO.EXECTYPE IN ('AB')
                 --AND FO.TIMETYPE <> 'G'
                 AND FO.AFACCTNO=HM.AFACCTNO(+);

        --in vao bang crbtxreq
        IF V_HOLDAMT > 0
        THEN
            --Lam giao dich 6640
            PLOG.DEBUG (PKGCTX, 'Begin transaction 6640');
            V_TLTXCD := '6640';

            SELECT   TXDESC, EN_TXDESC
              INTO   V_STRDESC, V_STREN_DESC
              FROM   TLTX
             WHERE   TLTXCD = V_TLTXCD;

            SELECT   VARVALUE
              INTO   V_STRCURRDATE
              FROM   SYSVAR
             WHERE   GRNAME = 'SYSTEM' AND VARNAME = 'CURRDATE';

            SELECT   SYSTEMNUMS.C_BATCH_PREFIXED
                     || LPAD (SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO   L_TXMSG.TXNUM
              FROM   DUAL;

            PLOG.DEBUG (PKGCTX, 'Msg 6640 txNum:' || L_TXMSG.TXNUM);

            L_TXMSG.BRID := SUBSTR (V_AFACCTNO, 1, 4);

            L_TXMSG.MSGTYPE := 'T';
            L_TXMSG.LOCAL := 'N';
            L_TXMSG.TLID := SYSTEMNUMS.C_SYSTEM_USERID;

            SELECT   SYS_CONTEXT ('USERENV', 'HOST'),
                     SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
              INTO   L_TXMSG.WSNAME, L_TXMSG.IPADDRESS
              FROM   DUAL;

            L_TXMSG.OFF_LINE := 'N';
            L_TXMSG.DELTD := TXNUMS.C_DELTD_TXNORMAL;
            L_TXMSG.TXSTATUS := TXSTATUSNUMS.C_TXCOMPLETED;
            L_TXMSG.MSGSTS := '0';
            L_TXMSG.OVRSTS := '0';
            L_TXMSG.BATCHNAME := 'BANK';
            L_TXMSG.TXDATE :=
                TO_DATE (V_STRCURRDATE, SYSTEMNUMS.C_DATE_FORMAT);
            L_TXMSG.BUSDATE :=
                TO_DATE (V_STRCURRDATE, SYSTEMNUMS.C_DATE_FORMAT);
            L_TXMSG.TLTXCD := V_TLTXCD;

            SELECT   TXDESC, EN_TXDESC
              INTO   V_STRDESC, V_STREN_DESC
              FROM   TLTX
             WHERE   TLTXCD = V_TLTXCD;

            FOR REC
            IN (SELECT   CF.CUSTODYCD,
                         CF.FULLNAME,
                         CF.ADDRESS,
                         CF.IDCODE LICENSE,
                         AF.CAREBY,
                         AF.BANKACCTNO,
                         AF.BANKNAME || ':' || CRB.BANKNAME BANKNAME,
                         0 BANKAVAIL,
                         CI.HOLDBALANCE BANKHOLDED,
                         GETAVLPP (AF.ACCTNO) AVLRELEASE,
                         CI.HOLDBALANCE HOLDAMT
                  FROM   AFMAST AF,
                         CFMAST CF,
                         CIMAST CI,
                         CRBDEFBANK CRB
                 WHERE       AF.CUSTID = CF.CUSTID
                         AND CI.AFACCTNO = AF.ACCTNO
                         AND AF.BANKNAME = CRB.BANKCODE
                         AND AF.ACCTNO = V_AFACCTNO)
            LOOP
                L_TXMSG.TXFIELDS ('88').DEFNAME := 'CUSTODYCD';
                L_TXMSG.TXFIELDS ('88').TYPE := 'C';
                L_TXMSG.TXFIELDS ('88').VALUE := REC.CUSTODYCD;

                L_TXMSG.TXFIELDS ('03').DEFNAME := 'SECACCOUNT';
                L_TXMSG.TXFIELDS ('03').TYPE := 'C';
                L_TXMSG.TXFIELDS ('03').VALUE := V_AFACCTNO;

                L_TXMSG.TXFIELDS ('90').DEFNAME := 'CUSTNAME';
                L_TXMSG.TXFIELDS ('90').TYPE := 'C';
                L_TXMSG.TXFIELDS ('90').VALUE := REC.FULLNAME;

                L_TXMSG.TXFIELDS ('91').DEFNAME := 'ADDRESS';
                L_TXMSG.TXFIELDS ('91').TYPE := 'C';
                L_TXMSG.TXFIELDS ('91').VALUE := REC.ADDRESS;

                L_TXMSG.TXFIELDS ('92').DEFNAME := 'LICENSE';
                L_TXMSG.TXFIELDS ('92').TYPE := 'C';
                L_TXMSG.TXFIELDS ('92').VALUE := REC.LICENSE;

                L_TXMSG.TXFIELDS ('97').DEFNAME := 'CAREBY';
                L_TXMSG.TXFIELDS ('97').TYPE := 'C';
                L_TXMSG.TXFIELDS ('97').VALUE := REC.CAREBY;

                L_TXMSG.TXFIELDS ('93').DEFNAME := 'BANKACCT';
                L_TXMSG.TXFIELDS ('93').TYPE := 'C';
                L_TXMSG.TXFIELDS ('93').VALUE := REC.BANKACCTNO;

                L_TXMSG.TXFIELDS ('95').DEFNAME := 'BANKNAME';
                L_TXMSG.TXFIELDS ('95').TYPE := 'C';
                L_TXMSG.TXFIELDS ('95').VALUE := REC.BANKNAME;

                L_TXMSG.TXFIELDS ('11').DEFNAME := 'BANKAVAIL';
                L_TXMSG.TXFIELDS ('11').TYPE := 'N';
                L_TXMSG.TXFIELDS ('11').VALUE := REC.BANKAVAIL;

                L_TXMSG.TXFIELDS ('12').DEFNAME := 'BANKHOLDED';
                L_TXMSG.TXFIELDS ('12').TYPE := 'N';
                L_TXMSG.TXFIELDS ('12').VALUE := REC.BANKHOLDED;

                L_TXMSG.TXFIELDS ('13').DEFNAME := 'AVLRELEASE';
                L_TXMSG.TXFIELDS ('13').TYPE := 'N';
                L_TXMSG.TXFIELDS ('13').VALUE := REC.AVLRELEASE;

                L_TXMSG.TXFIELDS ('96').DEFNAME := 'HOLDAMT';
                L_TXMSG.TXFIELDS ('96').TYPE := 'N';
                L_TXMSG.TXFIELDS ('96').VALUE := REC.HOLDAMT;

                L_TXMSG.TXFIELDS ('10').DEFNAME := 'AMOUNT';
                L_TXMSG.TXFIELDS ('10').TYPE := 'N';
                L_TXMSG.TXFIELDS ('10').VALUE := V_HOLDAMT;

                L_TXMSG.TXFIELDS ('30').DEFNAME := 'DESC';
                L_TXMSG.TXFIELDS ('30').TYPE := 'C';
                L_TXMSG.TXFIELDS ('30').VALUE := V_STRDESC;
            END LOOP;



            BEGIN
                IF TXPKS_#6640.FN_BATCHTXPROCESS (L_TXMSG,
                                                  P_ERR_CODE,
                                                  L_ERR_PARAM) <>
                       SYSTEMNUMS.C_SUCCESS
                THEN
                    PLOG.DEBUG (PKGCTX, 'got error 6640: ' || P_ERR_CODE);
                    ROLLBACK;
                    RETURN;
                END IF;
            END;

            --T?o y?c?u HOLD g?i sang Bank. REFCODE=ORDERID
            INSERT INTO CRBTXREQ (REQID,
                                  OBJTYPE,
                                  OBJNAME,
                                  TRFCODE,
                                  REFCODE,
                                  OBJKEY,
                                  TXDATE,
                                  AFFECTDATE,
                                  BANKCODE,
                                  BANKACCT,
                                  AFACCTNO,
                                  TXAMT,
                                  STATUS,
                                  REFTXNUM,
                                  REFTXDATE,
                                  REFVAL,
                                  NOTES)
                SELECT   SEQ_CRBTXREQ.NEXTVAL,
                         'V',
                         'FOMAST',
                         'HOLD',
                         V_ORDERID,
                         V_ORDERID,
                         V_TXDATE,
                         V_TXDATE,
                         V_BANKCODE,
                         V_BANKACCT,
                         V_AFACCTNO,
                         V_HOLDAMT,
                         'P',
                         NULL,
                         NULL,
                         NULL,
                         V_NOTES
                  FROM   DUAL;
        ELSE
            --cap nhat trang thai thanh P
            UPDATE   FOMAST
               SET   STATUS = 'P', DIRECT = 'N'
             WHERE   ACCTNO = V_ORDERID;
        END IF;

        COMMIT;
        PLOG.SETENDSECTION (PKGCTX, 'pr_fo_fobannk2od');
    --okie
    EXCEPTION
        WHEN OTHERS
        THEN
            PLOG.ERROR (PKGCTX, SQLERRM);
            PLOG.SETENDSECTION (PKGCTX, 'pr_fo_fobannk2od');
    END PR_FO_FOBANNK2OD;

-- Lay thong tin lenh giao dich
-- TheNN, 06-Jan-2012
PROCEDURE pr_GetOrder
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD    IN VARCHAR2,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     SYMBOL         IN  VARCHAR2,
     EXECTYPE      IN  VARCHAR2,
     STATUS         IN  VARCHAR2)
    IS

    V_CUSTODYCD   VARCHAR2(10);
    V_AFACCTNO    VARCHAR2(10);
    V_SYMBOL      VARCHAR2(20);
    V_CUSTID      VARCHAR2(10);
    V_STATUS      VARCHAR2(2);
    V_EXECTYPE    VARCHAR2(2);
    v_currdate    date;

BEGIN
    V_CUSTODYCD := CUSTODYCD;
    --V_AFACCTNO := AFACCTNO;
    select to_date(varvalue, 'DD/MM/RRRR') into v_currdate from sysvar where varname = 'CURRDATE';

    IF SYMBOL = 'ALL' OR SYMBOL IS NULL THEN
        V_SYMBOL := '%%';
    ELSE
        V_SYMBOL := SYMBOL;
    END IF;

    IF AFACCTNO = 'ALL' OR AFACCTNO IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := AFACCTNO;
    END IF;

    IF EXECTYPE = 'ALL' OR EXECTYPE IS NULL THEN
        V_EXECTYPE := '%%';
    ELSE
        V_EXECTYPE := EXECTYPE;
    END IF;

    IF STATUS = 'ALL' OR STATUS IS NULL THEN
        V_STATUS := '%%';
    ELSE
        V_STATUS := STATUS;
    END IF;

    -- LAY THONG TIN MA KHACH HANG
    IF CUSTODYCD = 'ALL' OR CUSTODYCD IS NULL THEN
        V_CUSTID := '%%';
    ELSE
        SELECT CUSTID INTO V_CUSTID FROM CFMAST WHERE CUSTODYCD = V_CUSTODYCD;
    END IF;

    -- LAY THONG TIN DANH MUC DAU TU
    OPEN p_REFCURSOR FOR
        SELECT OD.AFACCTNO, OD.ORDERID, OD.TXDATE, SB.SYMBOL, A1.CDCONTENT TRADEPLACE, A2.CDCONTENT VIA,
            OD.EXECTYPE, OD.ORDERQTTY, (CASE WHEN OD.PRICETYPE IN ('ATO','ATC','MP','MTL','MOK','MAK','SBO','OBO') THEN TO_CHAR(OD.PRICETYPE) ELSE TO_CHAR(OD.QUOTEPRICE) END) QUOTEPRICE,
            OD.EXECQTTY, CASE WHEN OD.EXECQTTY>0 THEN ROUND(OD.EXECAMT/OD.EXECQTTY) ELSE 0 END EXECPRICE, OD.EXECAMT,
            A3.CDCONTENT ORSTATUS, A3.CDVAL ORSTATUSCD,
            CASE WHEN OD.EXECAMT >0 AND OD.FEEACR =0 AND OD.STSSTATUS = 'N' THEN round(OD.EXECAMT*ODT.DEFFEERATE/100)
                WHEN OD.EXECAMT >0 AND OD.FEEACR >0 THEN round(OD.FEEACR)
                when od.txdate = v_currdate then round((OD.REMAINQTTY*OD.QUOTEPRICE + OD.EXECAMT)*ODT.DEFFEERATE/100)
                else 0 END FEEACR,
            '' CMSFEE, CASE WHEN OD.EXECAMT >0 AND INSTR(OD.EXECTYPE,'S')>0 AND OD.STSSTATUS = 'N'
                            THEN ROUND(OD.EXECAMT*TO_NUMBER(SYS.VARVALUE)/100) ELSE ROUND(OD.EXECAMT*OD.TAXRATE/100) END SELLTAXAMT,
            round(CASE WHEN OD.EXECAMT >0 AND OD.FEEACR =0 AND OD.STSSTATUS = 'N' THEN ODT.DEFFEERATE
                WHEN OD.EXECAMT >0 AND OD.FEEACR >0 THEN OD.FEEACR/OD.EXECAMT*100 ELSE ODT.DEFFEERATE END,4) FEERATE ,OD.QUOTEQTTY,OD.CONFIRMED
        FROM
            (SELECT MST.*,
                   (CASE WHEN MST.REMAINQTTY <> 0 AND MST.EDITSTATUS='C' THEN 'C'
                        WHEN MST.REMAINQTTY <> 0 AND MST.EDITSTATUS='A' THEN 'A'
                        WHEN MST.EDITSTATUS IS NULL AND MST.CANCELQTTY <> 0 THEN '5'
                        WHEN MST.REMAINQTTY = 0 AND MST.CANCELQTTY <> 0 AND MST.EDITSTATUS='C' THEN '3'
                        when MST.REMAINQTTY = 0 and MST.ADJUSTQTTY>0 AND mst.pricetype = 'MP' then '4'
                        when MST.REMAINQTTY = 0 and MST.ADJUSTQTTY>0 then '10'
                        WHEN MST.REMAINQTTY = 0 AND MST.EXECQTTY>0 AND MST.ORSTATUS = '4' THEN '12'
                        when mst.orstatus = '7' then '12'
                        ELSE MST.ORSTATUS END) ORSTATUSVALUE
                FROM
                    (SELECT OD1.*,OD2.EDSTATUS EDITSTATUS
                     from vw_odmast_all OD1,(SELECT * FROM vw_odmast_all WHERE EDSTATUS IN ('C','A')) OD2
                     WHERE OD1.ORDERID=OD2.REFORDERID(+) AND substr(OD1.EXECTYPE,1,1) <> 'C'
                     AND substr(OD1.EXECTYPE,1,1) <> 'A' AND od1.edstatus NOT IN ('C','A') --AND OD1.ORSTATUS <>'7'
                   ) MST
                ) OD, SBSECURITIES SB, AFMAST AF, ALLCODE A1, ALLCODE A2, ALLCODE A3, SYSVAR SYS, ODTYPE ODT
        WHERE OD.CODEID=SB.CODEID AND AF.ACCTNO = OD.AFACCTNO
            AND OD.ACTYPE = ODT.ACTYPE
            AND A1.CDTYPE = 'SE' AND A1.CDNAME = 'TRADEPLACE' AND A1.CDVAL = SB.TRADEPLACE
            AND A2.CDTYPE = 'SA' AND A2.CDNAME = 'VIA' AND A2.CDVAL = OD.VIA
            AND A3.CDTYPE = 'OD' AND A3.CDNAME = 'ORSTATUS' AND A3.CDVAL = OD.ORSTATUSVALUE
            AND SYS.GRNAME = 'SYSTEM' AND SYS.VARNAME = 'ADVSELLDUTY'
            AND AF.CUSTID LIKE V_CUSTID
            AND AF.ACCTNO LIKE V_AFACCTNO
            AND SB.SYMBOL LIKE V_SYMBOL
            AND OD.ORSTATUSVALUE LIKE V_STATUS
            AND OD.EXECTYPE LIKE V_EXECTYPE
            AND OD.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
            AND OD.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
        ORDER BY OD.TXDATE DESC, SUBSTR(OD.ORDERID,11,6) DESC;

EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GetOrder');
END pr_GetOrder;

-- Lay thong tin lenh dieu kien
-- TheNN, 11-Jan-2012
PROCEDURE pr_GetGTCOrder
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD    IN VARCHAR2,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     SYMBOL         IN  VARCHAR2,
     EXECTYPE      IN  VARCHAR2,
     STATUS         IN  VARCHAR2)
    IS

    V_CUSTODYCD   VARCHAR2(10);
    V_AFACCTNO    VARCHAR2(10);
    V_SYMBOL      VARCHAR2(20);
    V_CUSTID      VARCHAR2(10);
    V_STATUS      VARCHAR2(2);
    V_EXECTYPE    VARCHAR2(2);

BEGIN
    V_CUSTODYCD := CUSTODYCD;
    --V_AFACCTNO := AFACCTNO;

    IF SYMBOL = 'ALL' OR SYMBOL IS NULL THEN
        V_SYMBOL := '%%';
    ELSE
        V_SYMBOL := SYMBOL;
    END IF;

    IF AFACCTNO = 'ALL' OR AFACCTNO IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := AFACCTNO;
    END IF;

    IF EXECTYPE = 'ALL' OR EXECTYPE IS NULL THEN
        V_EXECTYPE := '%%';
    ELSE
        V_EXECTYPE := EXECTYPE;
    END IF;

    IF STATUS = 'ALL' OR STATUS IS NULL THEN
        V_STATUS := '%%';
    ELSE
        V_STATUS := STATUS;
    END IF;

    -- LAY THONG TIN MA KHACH HANG
    IF CUSTODYCD = 'ALL' OR CUSTODYCD IS NULL THEN
        V_CUSTID := '%%';
    ELSE
        SELECT CUSTID INTO V_CUSTID FROM CFMAST WHERE CUSTODYCD = V_CUSTODYCD;
    END IF;

    -- LAY THONG TIN LENH
    OPEN p_REFCURSOR FOR
        SELECT OD.AFACCTNO, OD.ORDERID, OD.TXDATE, SB.SYMBOL, A1.CDCONTENT TRADEPLACE, A2.CDCONTENT VIA,
            OD.EXECTYPE, OD.ORDERQTTY, (CASE WHEN OD.PRICETYPE IN ('ATO','ATC','MP','MTL','MOK','MAK','SBO','OBO') THEN  TO_CHAR(OD.PRICETYPE) ELSE TO_CHAR(OD.QUOTEPRICE) END) QUOTEPRICE,
            OD.EXECQTTY, CASE WHEN OD.EXECQTTY>0 THEN ROUND(OD.EXECAMT/OD.EXECQTTY) ELSE 0 END EXECPRICE, OD.EXECAMT,
            A3.CDCONTENT ORSTATUS, CASE WHEN OD.EXECAMT >0 AND OD.FEEACR =0 AND OD.STSSTATUS = 'N' THEN OD.EXECAMT*ODT.DEFFEERATE/100 ELSE OD.FEEACR END FEEACR,
            '' CMSFEE, CASE WHEN OD.EXECAMT >0 AND INSTR(OD.EXECTYPE,'S')>0 AND OD.STSSTATUS = 'N'
                            THEN ROUND(OD.EXECAMT*TO_NUMBER(SYS.VARVALUE)/100) ELSE ROUND(OD.EXECAMT*OD.TAXRATE/100) END SELLTAXAMT,
            OD.STOPPRICE, OD.LIMITPRICE, OD.EXPRICE, OD.EXPDATE, OD.EXQTTY, OD.REMAINQTTY, OD.CANCELQTTY, OD.ORSTATUSVALUE ,OD.QUOTEQTTY,OD.CONFIRMED
        FROM
            (SELECT MST.*,
                   (CASE WHEN MST.REMAINQTTY <> 0 AND MST.EDITSTATUS='C' THEN 'C'
                        WHEN MST.REMAINQTTY <> 0 AND MST.EDITSTATUS='A' THEN 'A'
                        WHEN MST.EDITSTATUS IS NULL AND MST.CANCELQTTY <> 0 THEN '5'
                        WHEN MST.REMAINQTTY = 0 AND MST.CANCELQTTY <> 0 AND MST.EDITSTATUS='C' THEN '3'
                        when MST.REMAINQTTY = 0 and MST.ADJUSTQTTY>0 then '10'
                        WHEN MST.REMAINQTTY = 0 AND MST.EXECQTTY>0 AND MST.ORSTATUS = '4' THEN '12' ELSE MST.ORSTATUS END) ORSTATUSVALUE
                FROM
                    (SELECT OD1.*,OD2.EDSTATUS EDITSTATUS
                     from vw_odmast_all OD1,(SELECT * FROM vw_odmast_all WHERE EDSTATUS IN ('C','A')) OD2
                     WHERE OD1.ORDERID=OD2.REFORDERID(+) AND substr(OD1.EXECTYPE,1,1) <> 'C'
                     AND substr(OD1.EXECTYPE,1,1) <> 'A' AND OD1.ORSTATUS <>'7' AND OD1.TIMETYPE = 'G'
                   ) MST
            ) OD, SBSECURITIES SB, AFMAST AF, ALLCODE A1, ALLCODE A2, ALLCODE A3, SYSVAR SYS, ODTYPE ODT
        WHERE OD.CODEID=SB.CODEID AND AF.ACCTNO = OD.AFACCTNO
            --AND OD.TIMETYPE = 'G'
            AND OD.ACTYPE = ODT.ACTYPE
            AND A1.CDTYPE = 'SE' AND A1.CDNAME = 'TRADEPLACE' AND A1.CDVAL = SB.TRADEPLACE
            AND A2.CDTYPE = 'SA' AND A2.CDNAME = 'VIA' AND A2.CDVAL = OD.VIA
            AND A3.CDTYPE = 'OD' AND A3.CDNAME = 'ORSTATUS' AND A3.CDVAL = OD.ORSTATUSVALUE
            AND SYS.GRNAME = 'SYSTEM' AND SYS.VARNAME = 'ADVSELLDUTY'
            AND AF.CUSTID LIKE V_CUSTID
            AND AF.ACCTNO LIKE V_AFACCTNO
            AND SB.SYMBOL LIKE V_SYMBOL
            AND OD.ORSTATUS LIKE V_STATUS
            AND OD.EXECTYPE LIKE V_EXECTYPE
            AND OD.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
            AND OD.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
        ORDER BY OD.TXDATE DESC, substr(OD.ORDERID,11,6) DESC;

EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GetGTCOrder');
END pr_GetGTCOrder;

-- Lay thong tin nhat ky giao dich
-- TheNN, 07-Jan-2012
PROCEDURE pr_GetTradeDiary
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD    IN VARCHAR2,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     SYMBOL         IN  VARCHAR2,
     EXECTYPE      IN  VARCHAR2)
    IS

  V_CUSTODYCD   VARCHAR2(10);
  V_AFACCTNO    VARCHAR2(10);
  V_SYMBOL      VARCHAR2(20);
  V_CUSTID      VARCHAR2(10);
  V_EXECTYPE    VARCHAR2(2);
  V_CURRDATE    DATE;

BEGIN
    V_CUSTODYCD := CUSTODYCD;
    --V_AFACCTNO := AFACCTNO;

    IF SYMBOL = 'ALL' OR SYMBOL IS NULL THEN
        V_SYMBOL := '%%';
    ELSE
        V_SYMBOL := SYMBOL;
    END IF;

    IF AFACCTNO = 'ALL' OR AFACCTNO IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := AFACCTNO;
    END IF;

    IF EXECTYPE = 'ALL' OR EXECTYPE IS NULL THEN
        V_EXECTYPE := '%%';
    ELSE
        V_EXECTYPE := EXECTYPE;
    END IF;

    -- LAY THONG TIN MA KHACH HANG
    IF CUSTODYCD = 'ALL' OR CUSTODYCD IS NULL THEN
        V_CUSTID := '%%';
    ELSE
        SELECT CUSTID INTO V_CUSTID FROM CFMAST WHERE CUSTODYCD = V_CUSTODYCD;
    END IF;

    SELECT getcurrdate INTO V_CURRDATE FROM DUAL;

    -- LAY THONG TIN NHAT KY GIAO DICH
    OPEN p_REFCURSOR FOR
        SELECT STS.TXDATE, A1.CDCONTENT EXECTYPE, A1.CDVAL CDCONTENTCD, STS.AFACCTNO, STS.ORDERID, STS.CODEID, STS.SYMBOL,
            STS.EXECAMT, STS.EXECQTTY, STS.EXECPRICE, STS.FEEACR, STS.PROFITANDLOSS, STS.COSTPRICE
        FROM
        (
            SELECT OD.TXDATE, OD.EXECTYPE, OD.AFACCTNO, OD.ORDERID, OD.CODEID, SB.SYMBOL, OD.EXECAMT, OD.EXECQTTY,
                ROUND(OD.EXECAMT/OD.EXECQTTY) EXECPRICE,
                CASE WHEN OD.EXECAMT >0 AND OD.FEEACR =0 AND OD.STSSTATUS = 'N' THEN OD.EXECAMT*ODT.DEFFEERATE/100 ELSE OD.FEEACR END FEEACR,
                0 PROFITANDLOSS, ROUND(OD.EXECAMT/OD.EXECQTTY) COSTPRICE
            FROM VW_ODMAST_ALL OD, SBSECURITIES SB, AFMAST AF, ODTYPE ODT
            WHERE OD.CODEID = SB.CODEID AND AF.ACCTNO = OD.AFACCTNO
                AND OD.ORSTATUS IN ('4','5','7','12') AND OD.EXECQTTY>0 AND INSTR(OD.EXECTYPE,'B') >0
                AND OD.ACTYPE = ODT.ACTYPE
                AND AF.CUSTID LIKE V_CUSTID
                AND AF.ACCTNO LIKE V_AFACCTNO
                AND SB.SYMBOL LIKE V_SYMBOL
                AND OD.EXECTYPE LIKE V_EXECTYPE
                AND OD.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                AND OD.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
            UNION ALL
            SELECT OD.TXDATE, OD.EXECTYPE, OD.AFACCTNO, OD.ORDERID, OD.CODEID, SB.SYMBOL, OD.EXECAMT, OD.EXECQTTY,
                ROUND(OD.EXECAMT/OD.EXECQTTY) EXECPRICE,
                CASE WHEN OD.EXECAMT >0 AND OD.FEEACR =0 AND OD.STSSTATUS = 'N' THEN OD.EXECAMT*ODT.DEFFEERATE/100 ELSE OD.FEEACR END FEEACR,
                (STS.AMT - STS.QTTY * (CASE WHEN STS.TXDATE = V_CURRDATE THEN SE.COSTPRICE ELSE STS.COSTPRICE END)
                -
                --PHI BAN
                case when od.execamt > 0 and od.feeacr=0 then ROUND(sts.amt * odt.deffeerate / 100, 2)
                     else
                            (CASE WHEN (od.execamt * od.feeacr) = 0 THEN 0 ELSE
                                    (CASE WHEN od.TXDATE = getcurrdate THEN round(od.feeacr * sts.amt / od.execamt,2)
                                          ELSE ROUND(sts.amt / od.execamt * od.feeacr, 2)
                                    END)
                            END)
                end
                -
                --THUE
                CASE WHEN AFT.VAT = 'Y'
                        THEN (select to_number(varvalue) from sysvar where varname = 'ADVSELLDUTY' and grname = 'SYSTEM')
                    * STS.AMT /100
                ELSE 0 END
                ) PROFITANDLOSS,
                CASE WHEN STS.TXDATE = V_CURRDATE THEN SE.COSTPRICE ELSE STS.COSTPRICE END COSTPRICE
            FROM VW_STSCHD_ALL STS, SBSECURITIES SB, AFMAST AF, SEMAST SE, VW_ODMAST_ALL OD, ODTYPE ODT, AFTYPE AFT
            WHERE OD.CODEID = SB.CODEID AND AF.ACCTNO = OD.AFACCTNO
                AND OD.ORSTATUS IN ('4','5','7','12') AND OD.EXECQTTY>0 AND INSTR(OD.EXECTYPE,'S') >0
                AND OD.ACTYPE = ODT.ACTYPE AND AF.ACTYPE = AFT.ACTYPE
                and STS.DUETYPE= 'SS'
                AND STS.acctno = SE.acctno
                AND OD.orderid = STS.orgorderid
                AND AF.CUSTID LIKE V_CUSTID
                AND AF.ACCTNO LIKE V_AFACCTNO
                AND SB.SYMBOL LIKE V_SYMBOL
                AND OD.EXECTYPE LIKE V_EXECTYPE
                AND OD.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                AND OD.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
        ) STS, ALLCODE A1
        WHERE A1.CDTYPE = 'OD' AND A1.CDNAME = 'EXECTYPE' AND A1.CDVAL = STS.EXECTYPE
        ORDER BY STS.TXDATE, SUBSTR(STS.ORDERID,11,6) DESC, STS.AFACCTNO, STS.EXECTYPE, STS.SYMBOL;

EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GetTradeDiary');
END pr_GetTradeDiary;

-- Lay thong tin lenh khop
-- TheNN, 07-Jan-2012
PROCEDURE pr_GetMatchOrder
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD    IN VARCHAR2,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     SYMBOL         IN  VARCHAR2,
     EXECTYPE      IN  VARCHAR2)
    IS

  V_CUSTODYCD   VARCHAR2(10);
  V_AFACCTNO    VARCHAR2(10);
  V_SYMBOL      VARCHAR2(20);
  V_CUSTID      VARCHAR2(10);
  V_EXECTYPE    VARCHAR2(2);

BEGIN
    V_CUSTODYCD := CUSTODYCD;

    IF SYMBOL = 'ALL' OR SYMBOL IS NULL THEN
        V_SYMBOL := '%%';
    ELSE
        V_SYMBOL := SYMBOL;
    END IF;

    IF AFACCTNO = 'ALL' OR AFACCTNO IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := AFACCTNO;
    END IF;

    IF EXECTYPE = 'ALL' OR EXECTYPE IS NULL THEN
        V_EXECTYPE := '%%';
    ELSE
        V_EXECTYPE := EXECTYPE;
    END IF;

    -- LAY THONG TIN MA KHACH HANG
    IF CUSTODYCD = 'ALL' OR CUSTODYCD IS NULL THEN
        V_CUSTID := '%%';
    ELSE
        SELECT CUSTID INTO V_CUSTID FROM CFMAST WHERE CUSTODYCD = V_CUSTODYCD;
    END IF;

    -- LAY THONG TIN LENH KHOP
    OPEN p_REFCURSOR FOR
        SELECT OD.TXDATE, A1.CDCONTENT EXECTYPE, OD.AFACCTNO, OD.ORDERID, OD.CODEID, OD.SYMBOL,
            IOD.MATCHQTTY, IOD.MATCHPRICE, IOD.MATCHQTTY*IOD.MATCHPRICE MATCHAMT,
            ROUND(IOD.MATCHQTTY*IOD.MATCHPRICE*OD.FEERATE) FEEAMT,OD.FEERATE,
            CASE WHEN INSTR(OD.EXECTYPE,'S')>0 THEN IOD.MATCHQTTY*IOD.MATCHPRICE*OD.TAXRATE ELSE 0 END SELLTAXAMT,
            CASE WHEN INSTR(OD.EXECTYPE,'B')>0 THEN IOD.MATCHQTTY ELSE 0 END RECVQTTY,
            CASE WHEN INSTR(OD.EXECTYPE,'S')>0 THEN IOD.MATCHQTTY ELSE 0 END TRANFQTTY,
            CASE WHEN INSTR(OD.EXECTYPE,'B')>0 THEN IOD.MATCHQTTY*IOD.MATCHPRICE
             + ROUND(IOD.MATCHQTTY*IOD.MATCHPRICE*OD.FEERATE) ELSE 0 END TRANFAMT,
            CASE WHEN INSTR(OD.EXECTYPE,'B')>0 THEN IOD.MATCHQTTY*IOD.MATCHPRICE
                + ROUND(IOD.MATCHQTTY*IOD.MATCHPRICE*OD.FEERATE)
                WHEN INSTR(OD.EXECTYPE,'S')>0 THEN IOD.MATCHQTTY*IOD.MATCHPRICE
                - ROUND(IOD.MATCHQTTY*IOD.MATCHPRICE*OD.FEERATE) - IOD.MATCHQTTY*IOD.MATCHPRICE*OD.TAXRATE ELSE 0 END RECVAMT
        FROM
        (
            SELECT OD.TXDATE, OD.EXECTYPE, OD.AFACCTNO, OD.ORDERID, OD.CODEID, SB.SYMBOL, OD.EXECAMT, OD.EXECQTTY,
                CASE WHEN OD.EXECAMT >0 AND OD.FEEACR =0 AND OD.STSSTATUS = 'N' THEN ROUND(ODT.DEFFEERATE/100,5) ELSE ROUND(OD.FEEACR/OD.EXECAMT,5) END FEERATE,
                CASE WHEN OD.EXECAMT >0 AND INSTR(OD.EXECTYPE,'S')>0 AND OD.STSSTATUS = 'N'
                            THEN ROUND(TO_NUMBER(SYS.VARVALUE)/100,5) ELSE OD.TAXRATE/100 END TAXRATE
            FROM VW_ODMAST_ALL OD, SBSECURITIES SB, AFMAST AF, SYSVAR SYS, ODTYPE ODT
            WHERE OD.CODEID = SB.CODEID AND AF.ACCTNO = OD.AFACCTNO
                AND OD.ORSTATUS IN ('4','5','7','12') AND OD.EXECQTTY>0
                AND OD.ACTYPE = ODT.ACTYPE
                AND SYS.GRNAME = 'SYSTEM' AND SYS.VARNAME = 'ADVSELLDUTY'
                AND AF.CUSTID LIKE V_CUSTID
                AND AF.ACCTNO LIKE V_AFACCTNO
                AND SB.SYMBOL LIKE V_SYMBOL
                AND OD.EXECTYPE LIKE V_EXECTYPE
                AND OD.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                AND OD.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
        ) OD, VW_IODS IOD, ALLCODE A1
        WHERE OD.ORDERID = IOD.ORGORDERID
            AND A1.CDTYPE = 'OD' AND A1.CDNAME = 'EXECTYPE' AND A1.CDVAL = OD.EXECTYPE
        ORDER BY OD.TXDATE DESC, SUBSTR(OD.ORDERID,11,6) DESC,OD.AFACCTNO, OD.EXECTYPE, OD.SYMBOL;

EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GetMatchOrder');
END pr_GetMatchOrder;


-- Lay thong tin de lam de nghi UTTB
-- TheNN, 11-Jan-2012
PROCEDURE pr_GetInfor4AdvancePayment
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2
    )
    IS

  V_AFACCTNO    VARCHAR2(10);
  V_CURRDATE    DATE;
  V_AUTOADV     VARCHAR(1);
  --T2_HoangND ADD
  l_count           NUMBER;
  v_clearday        NUMBER;
  v_existOrder2     NUMBER;
  v_existOrder1     NUMBER;
  --End T2_HoangND ADD

BEGIN
    V_AFACCTNO := AFACCTNO;

    -- LAY THONG TIN NGAY HIEN TAI
    SELECT GETCURRDATE INTO V_CURRDATE FROM DUAL;
    -- LAY THONG TIN TIEU KHOAN CO TU DONG UT HAY KO
    SELECT AUTOADV INTO V_AUTOADV FROM AFMAST WHERE ACCTNO = V_AFACCTNO;

    select to_number(varvalue) into v_clearday
    from sysvar where varname='CLEARDAY' and grname='OD' and rownum <=1; --T2_HoangfND add

    --T2_HoangND add
    select count(*) into l_count from vw_advanceschedule
    where acctno=V_AFACCTNO and txdate=fn_get_prevdate(V_CURRDATE,2) ;
    if l_count>0 then
      v_existOrder2:=1;
    else
       v_existOrder2:=0;
    end if;

    select count(*) into l_count from vw_advanceschedule
    where acctno=V_AFACCTNO and txdate=fn_get_prevdate(V_CURRDATE,1) ;
    if l_count>0 then
      v_existOrder1:=1;
    else
       v_existOrder1:=0;
    end if;
    --End T2_HoangND add


    -- LAY THONG TIN CHO UTTB
    -- NEU TU DONG UT THI LAY LEN THONG TIN TRONG
    /*IF V_AUTOADV = 'Y' THEN
        OPEN p_REFCURSOR FOR
            SELECT STS.*, STS.DUEDATE - GETCURRDATE DAYS, STS.AMT-STS.AAMT-STS.FAMT MAXAAMT, 0 PDAAMT,
                0 MINFEEAMT, 0 MAXFEEAMT, 0.00 FEERATE, 0 ADVMINAMT, 0 ADVMAXAMT
            FROM
            (
                SELECT STS.TXDATE, STS.AFACCTNO, (STS.AMT-STS.FEEACR-STS.TAXSELLAMT) AMT, (AAMT) AAMT, (FAMT) FAMT,
                    STS.CLEARDAY, STS.CLEARCD, GETDUEDATE(STS.TXDATE, STS.CLEARCD, '001', STS.CLEARDAY) DUEDATE
                FROM
                (
                    SELECT V_CURRDATE TXDATE, V_AFACCTNO AFACCTNO, 0 AMT, 0 AAMT, 0 FAMT, 0 FEEACR, 0 TAXSELLAMT, 3 CLEARDAY, 'B' CLEARCD
                    FROM DUAL
                    UNION ALL
                    SELECT fn_get_prevdate(V_CURRDATE,1) TXDATE, V_AFACCTNO AFACCTNO, 0 AMT, 0 AAMT, 0 FAMT, 0 FEEACR, 0 TAXSELLAMT, 3 CLEARDAY, 'B' CLEARCD
                    FROM DUAL
                    UNION ALL
                    SELECT fn_get_prevdate(V_CURRDATE,2) TXDATE, V_AFACCTNO AFACCTNO, 0 AMT, 0 AAMT, 0 FAMT, 0 FEEACR, 0 TAXSELLAMT, 3 CLEARDAY, 'B' CLEARCD
                    FROM DUAL
                ) STS
            ) STS
            ORDER BY STS.TXDATE, STS.AFACCTNO;
    ELSE*/
        OPEN p_REFCURSOR FOR
            SELECT STS.*, STS.DUEDATE - GETCURRDATE DAYS, STS.AMT-STS.AAMT-STS.FAMT MAXAAMT, 0 PDAAMT,
                AD.ADVMINFEE MINFEEAMT, AD.ADVMAXFEE MAXFEEAMT, AD.ADVRATE FEERATE, AD.ADVMINAMT, AD.ADVMAXAMT, V_AUTOADV AUTOADV
            FROM
            (
                SELECT STS.TXDATE, STS.AFACCTNO, SUM(STS.EXECAMT-STS.FEEACR-STS.TAXSELLAMT-STS.RIGHTTAX) AMT, SUM(AAMT) AAMT, SUM(FAMT) FAMT,
                    STS.CLEARDAY, STS.CLEARCD, /*GETDUEDATE(STS.TXDATE, STS.CLEARCD, '001', STS.CLEARDAY)*/ STS.cleardate DUEDATE,SUM(GREATEST(MAXAVLAMT-ROUND(DEALPAID,0),0)) MAXAVLAMT        --T2_HoangND
                FROM
                (
                    SELECT STS.TXDATE, STS.ACCTNO AFACCTNO,STS.AMT, STS.AAMT, STS.FAMT,STS.EXECAMT, CASE WHEN aft.vat = 'Y' THEN STS.RIGHTTAX ELSE 0 END RIGHTTAX,
                    STS.brkfeeamt FEEACR, CASE WHEN aft.vat = 'Y' THEN STS.incometaxamt ELSE 0 END TAXSELLAMT, STS.CLEARDAY, STS.CLEARCD,STS.MAXAVLAMT,
                    (CASE WHEN STS.TXDATE =TO_DATE(SYS.VARVALUE,'DD/MM/RRRR') THEN fn_getdealgrppaid(STS.ACCTNO) ELSE 0 END)/
                    (1-ADT.ADVRATE/100/360*STS.days) DEALPAID, sts.days ,sts.cleardate cleardate            --T2_HoangND
                    FROM vw_advanceschedule STS,AFMAST AF, AFTYPE AFT ,ADTYPE ADT, SYSVAR SYS
                    WHERE STS.ACCTNO = V_AFACCTNO
                    AND AF.ACCTNO=STS.ACCTNO
                    AND STS.ISVSD='N'
                    AND SYS.GRNAME='SYSTEM'
                    AND SYS.VARNAME ='CURRDATE'
                    AND AF.ACTYPE=AFT.ACTYPE
                    AND AFT.ADTYPE=ADT.ACTYPE
                    AND sts.clearday <> 1           --T2_HoangND

                    /*WHERE STS.
                    FROM STSCHD STS,
                        (
                           SELECT OD.ORDERID,
                                CASE WHEN OD.FEEACR >0 THEN OD.FEEACR ELSE OD.EXECAMT*(OD.BRATIO-100)/100 END FEEACR,
                                CASE WHEN OD.TAXSELLAMT >0 THEN OD.TAXSELLAMT ELSE OD.EXECAMT*TO_NUMBER(SYS.VARVALUE)/100 END TAXSELLAMT
                            FROM ODMAST OD, SYSVAR SYS,
                            (SELECT DISTINCT OD.ORDERID, od.ISVSD FROM ODMAPEXT OD where OD.ISVSD='N'
                            UNION all
                            SELECT DISTINCT od.ORDERID, od.ISVSD FROM ODMAPEXTHIST OD where OD.ISVSD='N') ODMAP
                            WHERE INSTR(OD.EXECTYPE,'S')>0 AND OD.EXECAMT >0 --AND OD.MATCHTYPE <> 'P'
                                AND SYS.GRNAME = 'SYSTEM' AND SYS.VARNAME = 'ADVSELLDUTY'
                                AND ODMAP.ORDERID=OD.ORDERID
                        ) OD
                    WHERE STS.ORGORDERID = OD.ORDERID
                        AND STS.DUETYPE = 'RM' AND STS.STATUS = 'N'
                        AND STS.AFACCTNO = V_AFACCTNO*/

                    --T2_HoangND edit
/*                    UNION ALL
                    SELECT V_CURRDATE TXDATE, V_AFACCTNO AFACCTNO, 0 AMT, 0 AAMT, 0 FAMT, 0 FEEACR,0 EXECAMT,0 RIGHTTAX, 0 TAXSELLAMT, v_clearday CLEARDAY, 'B' CLEARCD,0 MAXAVLAMT,0 DEALPAID
                    FROM DUAL
                    UNION ALL
                    SELECT fn_get_prevdate(V_CURRDATE,1) TXDATE, V_AFACCTNO AFACCTNO, 0 AMT, 0 AAMT, 0 FAMT, 0 FEEACR,0 EXECAMT,0 RIGHTTAX, 0 TAXSELLAMT, v_clearday CLEARDAY, 'B' CLEARCD,0 MAXAVLAMT,0 DEALPAID
                    FROM DUAL
                    UNION ALL
                    SELECT fn_get_prevdate(V_CURRDATE,2) TXDATE, V_AFACCTNO AFACCTNO, 0 AMT, 0 AAMT, 0 FAMT, 0 FEEACR,0 EXECAMT,0 RIGHTTAX, 0 TAXSELLAMT, v_clearday CLEARDAY, 'B' CLEARCD,0 MAXAVLAMT,0 DEALPAID
                    FROM DUAL
                    UNION ALL
                    SELECT V_CURRDATE TXDATE, V_AFACCTNO AFACCTNO, 0 AMT, 0 AAMT, 0 FAMT, 0 FEEACR,0 EXECAMT,0 RIGHTTAX, 0 TAXSELLAMT, 1 CLEARDAY, 'B' CLEARCD,0 MAXAVLAMT,0 DEALPAID
                    FROM DUAL
*/                    UNION ALL
                    SELECT V_CURRDATE TXDATE, V_AFACCTNO AFACCTNO, 0 AMT, 0 AAMT, 0 FAMT, 0 FEEACR,0 EXECAMT,0 RIGHTTAX, 0 TAXSELLAMT, v_clearday CLEARDAY, 'B' CLEARCD,0 MAXAVLAMT,0 DEALPAID,v_clearday days,
                           GETDUEDATE(V_CURRDATE,'B', '001', v_clearday) cleardate
                    FROM DUAL
                    UNION ALL
                    SELECT fn_get_prevdate(V_CURRDATE,1) TXDATE, V_AFACCTNO AFACCTNO, 0 AMT, 0 AAMT, 0 FAMT, 0 FEEACR,0 EXECAMT,0 RIGHTTAX, 0 TAXSELLAMT, v_clearday CLEARDAY, 'B' CLEARCD,0 MAXAVLAMT,0 DEALPAID,
                            GETDUEDATE(fn_get_prevdate(V_CURRDATE,1),'B', '001', v_clearday)-fn_get_prevdate(V_CURRDATE,1)  days,
                            GETDUEDATE(fn_get_prevdate(V_CURRDATE,1),'B', '001', v_clearday) cleardate

                    FROM DUAL
                    where v_existOrder1 <> 1

                    UNION ALL
                    SELECT fn_get_prevdate(V_CURRDATE,2) TXDATE, V_AFACCTNO AFACCTNO, 0 AMT, 0 AAMT, 0 FAMT, 0 FEEACR,0 EXECAMT,0 RIGHTTAX, 0 TAXSELLAMT, v_clearday CLEARDAY, 'B' CLEARCD,0 MAXAVLAMT,0 DEALPAID,
                            GETDUEDATE(fn_get_prevdate(V_CURRDATE,2),'B', '001', v_clearday)-fn_get_prevdate(V_CURRDATE,2) days,
                            GETDUEDATE(fn_get_prevdate(V_CURRDATE,2),'B', '001', v_clearday) cleardate
                    FROM DUAL
                    where v_existOrder2 <> 1
                    UNION ALL
                    SELECT V_CURRDATE TXDATE, V_AFACCTNO AFACCTNO, 0 AMT, 0 AAMT, 0 FAMT, 0 FEEACR,0 EXECAMT,0 RIGHTTAX, 0 TAXSELLAMT, 1 CLEARDAY, 'B' CLEARCD,0 MAXAVLAMT,0 DEALPAID,1 days
                          , GETDUEDATE(V_CURRDATE,'B', '001', 1) cleardate
                    FROM DUAL
                    --End T2_HoangND edit
                ) STS
                GROUP BY STS.TXDATE, STS.AFACCTNO, STS.CLEARDAY, STS.CLEARCD, sts.cleardate
            ) STS,
            (
                SELECT AF.ACCTNO, AF.ACTYPE AFTYPE, AD.ACTYPE ADTYPE, AD.ADVMINFEE, AD.ADVMAXFEE, AD.ADVRATE, AD.ADVMINAMT, AD.ADVMAXAMT
                FROM AFTYPE AFT, AFMAST AF, ADTYPE AD
                WHERE AFT.ACTYPE = AF.ACTYPE AND AFT.ADTYPE = AD.ACTYPE
                    AND AF.ACCTNO = V_AFACCTNO
            ) AD,
            (SELECT * FROM SYSVAR WHERE GRNAME = 'MARGIN' AND VARNAME = 'ISSTOPADV' AND VARVALUE = 'N') SY
            WHERE STS.AFACCTNO = AD.ACCTNO
            ORDER BY STS.TXDATE, STS.CLEARDAY DESC, STS.AFACCTNO;
    --END IF;
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GetInfor4AdvancePayment');
END pr_GetInfor4AdvancePayment;

-- Lay thong tin sao ke tien
-- TheNN, 11-Jan-2012
PROCEDURE pr_GetCashStatement
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN       VARCHAR2,
     T_DATE         IN       VARCHAR2
    )
    IS
    -- Tam thoi lay giong het bao cao CF1002
    v_FromDate date;
    v_ToDate date;
    v_CurrDate date;
    v_AFAcctno varchar2(20);

BEGIN
    v_FromDate:= to_date(F_DATE,'DD/MM/RRRR');
    v_ToDate:= to_date(T_DATE,'DD/MM/RRRR');
    v_AFAcctno:= upper(replace(AFACCTNO,'.',''));

    select getcurrdate into v_CurrDate from dual;

    OPEN p_REFCURSOR FOR
        select tr.autoid, tr.afacctno, tr.busdate,tr.txnum,tr.tltxcd,
            ROUND(nvl(ci_credit_amt,0)) ci_credit_amt, ROUND(nvl(ci_debit_amt,0)) ci_debit_amt,
            case when tr.tltxcd = '1143' and tr.txcd = '0077' then 'So tien den han phai thanh toan'
                 when tr.tltxcd in ('1143','1153') and tr.txcd = '0011' and tr.trdesc is null then 'Phi ung truoc'
                 else to_char(tr.txdesc)
            end txdesc,
            case when tr.tltxcd in ('2641','2642','2643','2660','2678','2670') then
                    (case when trim(description) is not null
                            then nvl(tr.description, ' ')
                        else
                            tr.dealno
                     end
                    )
            end dfaccno,
            ROUND(ci.ci_balance - nvl(ci_move_fromdt.ci_total_move_frdt_amt,0))  ci_begin_bal,
            ROUND(CI_RECEIVING - nvl(ci_RECEIVING_move,0)) ci_receiving_bal,
            ROUND(CI_EMKAMT - nvl(ci_EMKAMT_move,0)) ci_EMKAMT_bal,
            ROUND(CI_DFDEBTAMT - nvl(ci_DFDEBTAMT_move,0)) ci_DFDEBTAMT_bal,
            ROUND(nvl(secu.od_buy_secu,0)) od_buy_secu,
            ROUND(ci.ci_balance - nvl(ci_move_fromdt.ci_total_move_frdt_amt,0) + nvl(tr_period.total_period_amt,0)) ci_end_bal,
            ROUND(ci.ci_balance - nvl(ci_move_fromdt.ci_total_move_frdt_amt,0) + nvl(tr_period.total_period_amt,0)
            - nvl(secu.od_buy_secu,0) - (CI_DFDEBTAMT - nvl(ci_DFDEBTAMT_move,0))) ci_avail_bal
        from
        (
            -- Tong so du CI hien tai group by TK luu ky
            select ci.afacctno, ci.intbalance ci_balance,
                ci.RECEIVING CI_RECEIVING,
                ci.EMKAMT CI_EMKAMT,
                ci.DFDEBTAMT CI_DFDEBTAMT
            from buf_ci_account ci
            where ci.afacctno = v_AFAcctno
        ) ci

        left join
        (
            -- Danh sach giao dich CI: tu From Date den ToDate
            select tci.custid, tci.custodycd, tci.acctno afacctno, tci.tllog_autoid autoid, tci.txtype ,
                tci.busdate, nvl(tci.trdesc,tci.txdesc) txdesc, '' symbol, 0 se_credit_amt, 0 se_debit_amt,
                case when tci.txtype = 'C' then namt else 0 end ci_credit_amt,
                case when tci.txtype = 'D' then namt else 0 end ci_debit_amt,
                tci.txnum, '' tltx_name, tci.tltxcd, tci.txdate, tci.txcd, tci.dfacctno dealno, tci.old_dfacctno description, tci.trdesc,
                /*CASE WHEN tci.tltxcd in ('1140') THEN 0
                    WHEN substr(tci.tltxcd,1,2) = '55' THEN 1 ELSE 2 END txorder*/
                CASE WHEN EXISTS(SELECT app.tltxcd FROM appmap app WHERE app.tltxcd = tci.tltxcd and apptype = 'CI' AND apptxcd IN ('0012','0029'))
                    THEN 0 ELSE 1 END txorder
                , tci.autoid orderid
            from vw_CITRAN_gen tci
            where  tci.busdate between v_FromDate and v_ToDate
               and tci.acctno = v_AFAcctno
               and tci.field = 'BALANCE'
        ) tr on ci.afacctno = tr.afacctno

        left join
        (
            -- Tong phat sinh tang giam CI: tu From Date den ToDate
            select tci.acctno,
                sum(case when tci.txtype = 'D' then -tci.namt else tci.namt end) total_period_amt
            from vw_CITRAN_gen tci
            where  tci.busdate between v_FromDate and v_ToDate
               and tci.acctno = v_AFAcctno
               and tci.field = 'BALANCE'
            GROUP BY tci.acctno
        ) tr_period on ci.afacctno = tr_period.acctno

        left join
        (
            -- Tong phat sinh CI tu From date den ngay hom nay
            select tr.acctno,
                sum(case when tr.txtype = 'D' then -tr.namt else tr.namt end) ci_total_move_frdt_amt
            from vw_CITRAN_gen tr
            where
                tr.busdate >= v_FromDate and tr.busdate <= v_CurrDate
                and tr.acctno = v_AFAcctno
                and tr.field in ('BALANCE')
            group by tr.acctno
        ) ci_move_fromdt on ci.afacctno = ci_move_fromdt.acctno

        left join
        (
            -- Tong phat sinh CI.RECEIVING tu Todate + 1 den ngay hom nay
            select tr.acctno,
                sum(
                    case when field = 'RECEIVING' then
                        case when tr.txtype = 'D' then -tr.namt else tr.namt end
                    else 0
                    end
                    ) ci_RECEIVING_move,
                sum(
                    case when field IN ('EMKAMT') then
                        case when tr.txtype = 'D' then -tr.namt else tr.namt end
                    else 0
                    end
                    ) ci_EMKAMT_move,
                sum(
                    case when field = 'DFDEBTAMT' then
                        case when tr.txtype = 'D' then -tr.namt else tr.namt end
                    else 0
                    end
                    ) ci_DFDEBTAMT_move
            from vw_citran_gen tr
            where
                tr.busdate > v_ToDate and tr.busdate <= v_CurrDate
                and tr.acctno = v_AFAcctno
                and tr.field in ('RECEIVING','EMKAMT','DFDEBTAMT')
            group by tr.acctno
        ) ci_RECEIV on ci.afacctno = ci_RECEIV.acctno

        left join
        (
            select v.afacctno,
                case when v_CurrDate = v_ToDate then secureamt + advamt else 0 end od_buy_secu
            from v_getbuyorderinfo V
            where v.afacctno like v_AFAcctno
        ) secu on ci.afacctno = secu.afacctno

        --order by tr.busdate, tr.txorder, tr.autoid, tr.txtype,tr.txnum;      -- Chu y: Khong thay doi thu tu Order by
        order by tr.busdate, tr.autoid, tr.txnum, tr.txtype, tr.orderid
        ,case when tr.tltxcd = '1143' and tr.txcd = '0077' then 'So tien den han phai thanh toan '
              when tr.tltxcd in ('1143','1153') and tr.txcd = '0011' and tr.trdesc is null then 'Phi ung truoc '
              else to_char(tr.txdesc) end ;
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GetCashStatement');
END pr_GetCashStatement;


-- Lay thong tin sao ke chung khoan
-- TheNN, 11-Jan-2012
PROCEDURE pr_GetSecuritiesStatement
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     SYMBOL         IN  VARCHAR2
    )
    IS
    -- Tam thoi lay giong het bao cao CF1000
    v_FromDate date;
    v_ToDate date;
    v_CurrDate date;
    v_AFAcctno varchar2(20);
    V_SYMBOL    VARCHAR2(20);
    V_BEBAL     NUMBER;
    V_ENDBAL    NUMBER;

BEGIN
    v_FromDate:= to_date(F_DATE,'DD/MM/RRRR');
    v_ToDate:= to_date(T_DATE,'DD/MM/RRRR');
    v_AFAcctno:= upper(replace(AFACCTNO,'.',''));
    V_SYMBOL := UPPER(SYMBOL);
    V_BEBAL := 0;
    V_ENDBAL := 0;
    select getcurrdate into v_CurrDate from dual;

    -- NEU 1 MA CK THI LAY SO DU DAU KY VA SO DU CUOI KY
    IF V_SYMBOL = 'ALL' OR V_SYMBOL IS NULL THEN
        V_SYMBOL := '%%';
    ELSE
        SELECT se.trade - nvl(se_be.se_totalmov_amt,0) be_bal,
            se.trade - nvl(se_be.se_totalmov_amt,0) + nvl(se_period_amt,0) end_bal
        INTO V_BEBAL, V_ENDBAL
        FROM
        (
            SELECT se.afacctno, se.codeid, se.acctno, se.trade + se.mortage + se.blocked + se.secured trade
            FROM semast se, sbsecurities sb
            WHERE se.codeid = sb.codeid
                and se.afacctno = v_AFAcctno
                AND sb.symbol = V_SYMBOL
        ) se
        LEFT JOIN
        (
            select tse.custid, tse.custodycd, tse.afacctno, tse.codeid,to_char(max(tse.symbol)) symbol,
                sum(case when tse.txtype = 'C' then tse.namt else -tse.namt end) se_totalmov_amt
            from vw_setran_gen tse
            where tse.busdate between v_FromDate and v_CurrDate
                and tse.afacctno = v_AFAcctno
                and tse.field in ('TRADE','MORTAGE','BLOCKED')
                and sectype <> '004'
                AND tse.symbol = V_SYMBOL
            group by tse.custid, tse.custodycd, tse.afacctno, tse.codeid
            having sum(case when tse.txtype = 'D' then -tse.namt else tse.namt end) <> 0
        ) se_be
        ON se.afacctno = se_be.afacctno AND se.codeid = se_be.codeid
        LEFT JOIN
        (
            select tse.custid, tse.custodycd, tse.afacctno, tse.codeid,to_char(max(tse.symbol)) symbol,
                sum(case when tse.txtype = 'C' then tse.namt else -tse.namt end) se_period_amt
            from vw_setran_gen tse
            where tse.busdate between v_FromDate and v_ToDate
                and tse.afacctno = v_AFAcctno
                and tse.field in ('TRADE','MORTAGE','BLOCKED')
                and sectype <> '004'
                AND tse.symbol = V_SYMBOL
            group by tse.custid, tse.custodycd, tse.afacctno, tse.codeid
            having sum(case when tse.txtype = 'D' then -tse.namt else tse.namt end) <> 0
        ) se_tr
        ON se.afacctno = se_tr.afacctno AND se.codeid = se_tr.codeid;
    END IF;

    OPEN p_REFCURSOR FOR
        select AF.ACCTNO AFACCTNO,
            tr.autoid, tr.afacctno, tr.busdate, nvl(tr.symbol,' ') tran_symbol,
            nvl(se_credit_amt,0) se_credit_amt, nvl(se_debit_amt,0) se_debit_amt,
            to_char(tr.txdesc) txdesc, V_BEBAL BE_BAL, V_ENDBAL END_BAL
        from (SELECT * from afmast af WHERE af.acctno = v_AFAcctno) af
        left join
        (
            -- Toan bo phat sinh CK tu FromDate den Todate
            select tse.custid, tse.custodycd, tse.afacctno, max(tse.tllog_autoid) autoid, max(tse.txtype) txtype, max(tse.txcd) txcd , max(tse.autoid) orderid,
                tse.busdate, max(nvl(tse.trdesc,tse.txdesc)) txdesc, to_char(max(tse.symbol)) symbol,
                sum(case when tse.txtype = 'C' then tse.namt else 0 end) se_credit_amt,
                sum(case when tse.txtype = 'D' then tse.namt else 0 end) se_debit_amt,
                0 ci_credit_amt, 0 ci_debit_amt,
                max(tse.tltxcd) tltxcd, max(tse.trdesc) trdesc
            from vw_setran_gen tse
            where tse.busdate between v_FromDate and v_ToDate
                and tse.afacctno = v_AFAcctno
                and tse.field in ('TRADE','MORTAGE','BLOCKED')
                and sectype <> '004'
                AND TSE.symbol LIKE V_SYMBOL

            group by tse.custid, tse.custodycd, tse.afacctno, tse.busdate, to_char(tse.symbol), tse.txdate, tse.txnum
            having sum(case when tse.txtype = 'D' then -tse.namt else tse.namt end) <> 0
        ) tr on af.acctno = tr.afacctno

        --order by tr.busdate, tr.autoid, tr.txtype;      -- Chu y: Khong thay doi thu tu Order by
        order by --tr.busdate, tr.autoid,(nvl(se_debit_amt,0)) ,(nvl(se_credit_amt,0))  --tr.txtype
                tr.busdate,tr.autoid, tr.txtype, tr.orderid, -- CHAUNH add
                 case when tr.tltxcd = '1143' and tr.txcd = '0077' then utf8nums.c_const_RPT_CF1000_1143
                 when tr.tltxcd in ('1143','1153') and tr.txcd = '0011' and tr.trdesc is null then utf8nums.c_const_RPT_CF1000_1153
                 else to_char(tr.txdesc)
                end ;

EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GetSecuritiesStatement');
END pr_GetSecuritiesStatement;


-- Lay thong tin giao dich chuyen khoan
-- TheNN, 11-Jan-2012
PROCEDURE pr_GetCashTransfer
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD    IN VARCHAR2,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     STATUS         IN  VARCHAR2)
    IS

    V_CUSTODYCD   VARCHAR2(10);
    V_AFACCTNO    VARCHAR2(10);
    V_CUSTID      VARCHAR2(10);
    V_STATUS      VARCHAR2(2);
    V_NEXTSEQ     NUMBER;
BEGIN
    V_CUSTODYCD := CUSTODYCD;
    --V_AFACCTNO := AFACCTNO;

    IF AFACCTNO = 'ALL' OR AFACCTNO IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := AFACCTNO;
    END IF;

    IF STATUS = 'ALL' OR STATUS IS NULL THEN
        V_STATUS := '%%';
    ELSE
        V_STATUS := STATUS;
    END IF;

    BEGIN
       SELECT max_value INTO V_NEXTSEQ FROM USER_SEQUENCES WHERE SEQUENCE_NAME = 'SEQ_TLLOG';
    EXCEPTION WHEN OTHERS THEN
       V_NEXTSEQ := 0;
    END;

    -- LAY THONG TIN MA KHACH HANG
    IF V_CUSTODYCD = 'ALL' OR V_CUSTODYCD IS NULL THEN
        V_CUSTID := '%%';
    ELSE
        SELECT CUSTID INTO V_CUSTID FROM CFMAST WHERE CUSTODYCD = V_CUSTODYCD;
    END IF;


    -- LAY THONG TIN GD CHUYEN KHOAN
    OPEN p_REFCURSOR FOR
        SELECT *
        FROM
        (
            -- CHUYEN KHOAN RA NGOAI
            SELECT TLG.TXDATE, TLG.BUSDATE, TLG.TXNUM, TLG.MSGACCT AFACCTNO, TLG.TLTXCD, TLG.MSGAMT TRFAMT, A1.CDCONTENT STATUS,
                TL.TXDESC TRFTYPE, DECODE(TLG.TLTXCD, '1120', '',CIR.BENEFBANK) BENEFBANK, CIR.BENEFCUSTNAME RECVFULLNAME
                , CF.CUSTODYCD TRFCUSTODYCD, CIR.BENEFACCT RECVAFACCTNO,
                A2.CDCONTENT TRFPLACE, TLG.TXDESC, CIR.BENEFLICENSE, CIR.CITYBANK, CIR.CITYEF,
                 case when CIR.RMSTATUS in('E','W','M') then 'P' else CIR.RMSTATUS END
                RMSTATUS ,

                CASE  WHEN TLG.TLTXCD IN ('1120','1130','1188') THEN '1'
                     WHEN TLG.TLTXCD IN ('1101','1108','1111','1185') THEN '2'
                     WHEN TLG.TLTXCD IN ('1133') THEN '3' ELSE '1' END TRFTYPEVALUE,
                     CASE WHEN TLG.TLTXCD IN('1120','1130','1188') THEN  CIR.BENEFBANK
                      ELSE ''
                      END RECVCUSTODYCD ,
                TLG.AUTOID, CIR.FEEAMT
            FROM VW_TLLOG_ALL TLG, ALLCODE A1, CFMAST CF, AFMAST AF, CIREMITTANCE CIR, TLTX TL, ALLCODE A2
            WHERE TLG.TXDATE = CIR.TXDATE AND TLG.TXNUM = CIR.TXNUM
                AND CF.CUSTID = AF.CUSTID
                AND TL.TLTXCD = TLG.TLTXCD
                AND A1.CDTYPE = 'CI' AND A1.CDNAME = 'RMSTATUS' AND A1.CDVAL =  case when CIR.RMSTATUS in('E','W','M') then 'P' else CIR.RMSTATUS END
                              AND A2.CDTYPE = 'SA' AND A2.CDNAME = 'VIA' AND A2.CDVAL = DECODE(SUBSTR(TLG.TXNUM,1,2),systemnums.C_OL_PREFIXED,'O','F')
                AND TLG.TLTXCD IN ('1101','1108','1133','1120','1185','1111')--,'1130','1188'
                AND TLG.MSGACCT = AF.ACCTNO
                AND CF.CUSTID LIKE V_CUSTID
                AND AF.ACCTNO LIKE V_AFACCTNO
                AND CIR.RMSTATUS LIKE V_STATUS
                AND TLG.BUSDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                AND TLG.BUSDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')

            union all

            SELECT tl.txdate, tl.BUSDATE, tl.TXNUM, tl.MSGACCT AFACCTNO, tl.TLTXCD, tl.MSGAMT TRFAMT, 'Thanh cong' STATUS,
                TL.TXDESC TRFTYPE, decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname)  BENEFBANK
                , cf.fullname RECVFULLNAME, CF.CUSTODYCD TRFCUSTODYCD, af.acctno RECVAFACCTNO,
                A2.CDCONTENT TRFPLACE, TL.TXDESC, ' ' BENEFLICENSE, ' ' CITYBANK, ' ' CITYEF,
                'C' RMSTATUS , '1' TRFTYPEVALUE, CF.CUSTODYCD RECVCUSTODYCD,
                TL.AUTOID, 0 FEEAMT
            FROM vw_tllog_all TL,afmast af,cfmast cf ,tltx, tlprofiles mk,tlprofiles ck,vw_tllogfld_all tlfld,banknostro bank, allcode a2
            where tl.msgacct=af.acctno and af.custid = cf.custid
                AND A2.CDTYPE = 'SA' AND A2.CDNAME = 'VIA' AND A2.CDVAL = DECODE(SUBSTR(TL.TXNUM,1,2),systemnums.C_OL_PREFIXED,'O','F')
                and tltx.tltxcd = tl.tltxcd
                and  tl.tlid = mk.tlid(+)
                and  tl.OFFID =ck.tlid(+)
                and tlfld.txdate = tl.txdate
                and tlfld.txnum = tl.txnum
                and tlfld.fldcd='02'
                and tlfld.cvalue=bank.shortname(+)
                and tl.tltxcd in ('1132')
                AND CF.CUSTID LIKE V_CUSTID
                AND AF.ACCTNO LIKE V_AFACCTNO
                AND (V_STATUS = 'C' or V_STATUS = '%%')
                AND TL.BUSDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                AND TL.BUSDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
            union
            select tl.txdate, tl.BUSDATE, tl.TXNUM, tl.MSGACCT AFACCTNO, tl.TLTXCD, tl.MSGAMT TRFAMT, 'Thanh cong' STATUS,
                TLtx.txdesc TRFTYPE, decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname)  BENEFBANK
                , cfc.fullname RECVFULLNAME, CF.CUSTODYCD TRFCUSTODYCD, afc.acctno RECVAFACCTNO,
                A2.CDCONTENT TRFPLACE, nvl(ci.trdesc,ci.txdesc) TXDESC, ' ' BENEFLICENSE, ' ' CITYBANK, ' ' CITYEF,
                'C' RMSTATUS , '1' TRFTYPEVALUE, cfc.custodycd RECVCUSTODYCD,
                TL.AUTOID, 0 FEEAMT
            from vw_tllog_all TL ,vw_citran_gen ci,afmast af,cfmast cf, afmast afc,cfmast cfc ,tltx  , tlprofiles mk,tlprofiles ck, allcode a2
            where tl.txnum =ci.txnum and tl.txdate =ci.txdate and ci.acctno= af.acctno and cf.custid =af.custid
                 AND A2.CDTYPE = 'SA' AND A2.CDNAME = 'VIA' AND A2.CDVAL = DECODE(SUBSTR(TL.TXNUM,1,2),systemnums.C_OL_PREFIXED,'O','F')
                and ci.ref =afc.acctno and afc.custid =cfc.custid
                and tltx.tltxcd = tl.tltxcd
                and  tl.tlid = mk.tlid(+)
                and  tl.OFFID =ck.tlid(+)
                and tl.tltxcd in ('1188','1130') and ci.field ='BALANCE'
                and ci.txcd in ('0011','0012') and ci.txtype = 'D'
                AND CF.CUSTID LIKE V_CUSTID
                AND AF.ACCTNO LIKE V_AFACCTNO
                AND (V_STATUS = 'C' or V_STATUS = '%%')
                AND TL.BUSDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                AND TL.BUSDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')


            union
            SELECT
                TL.TXDATE, TL.BUSDATE, TL.TXNUM, TL.MSGACCT AFACCTNO, TL.TLTXCD, TL.MSGAMT TRFAMT, 'Thanh cong' STATUS,
                TLtx.TXDESC TRFTYPE, decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) BENEFBANK,cf.fullname RECVFULLNAME
                , CF.CUSTODYCD TRFCUSTODYCD, af.acctno RECVAFACCTNO,
                A2.CDCONTENT TRFPLACE, nvl(ci.trdesc,ci.txdesc) TXDESC , '' BENEFLICENSE,'' CITYBANK, '' CITYEF,'C' RMSTATUS ,
                '1'  TRFTYPEVALUE,
                '' RECVCUSTODYCD ,
                TL.AUTOID, 0 FEEAMT
            FROM vw_tllog_all TL,afmast af,cfmast cf ,tltx, tlprofiles mk,tlprofiles ck, vw_citran_gen ci, allcode a2
            where /*substr(tl.msgacct,0,10)*/ci.acctno=af.acctno and af.custid = cf.custid
                and A2.CDTYPE = 'SA' AND A2.CDNAME = 'VIA' AND A2.CDVAL = DECODE(SUBSTR(TL.TXNUM,1,2),systemnums.C_OL_PREFIXED,'O','F')
                and tltx.tltxcd = tl.tltxcd
                and  tl.tlid = mk.tlid(+)
                and  tl.OFFID =ck.tlid(+)
                and tl.tltxcd in ('1184') --Chaunh bo 3384,1188
                and ci.txdate = tl.txdate and ci.txnum = tl.txnum and ci.field in ('BAMT','BALANCE','MBLOCK','EMKAMT')
                AND CF.CUSTID LIKE V_CUSTID
                AND AF.ACCTNO LIKE V_AFACCTNO
                AND (V_STATUS = 'C' or V_STATUS = '%%')
                AND TL.BUSDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                AND TL.BUSDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
            /*UNION ALL
            -- CHUYEN KHOAN NOI BO
            SELECT TLG.TXDATE, TLG.BUSDATE, TLG.MSGACCT AFACCTNO, TLG.TLTXCD, TLG.MSGAMT TRFAMT, A1.CDCONTENT STATUS,
                '1' TRFTYPE, '' BENEFBANK, CIR.BENEFCUSTNAME RECVFULLNAME, CIR.BENEFACCT RECVAFACCTNO,
                DECODE(SUBSTR(TLG.TXNUM,1,4),systemnums.C_OL_PREFIXED,'O','F') TRFPLACE
            FROM VW_TLLOG_ALL TLG, ALLCODE A1, AFMAST AF, CIREMITTANCE CIR
            WHERE TLG.TXDATE = CIR.TXDATE AND TLG.TXNUM = CIR.TXNUM
                AND A1.CDTYPE = 'CI' AND A1.CDNAME = 'RMSTATUS' AND A1.CDVAL = CIR.RMSTATUS
                AND TLG.TLTXCD = '1120'
                AND AF.ACCTNO = TLG.MSGACCT
                AND AF.CUSTID LIKE V_CUSTID
                AND TLG.MSGACCT LIKE V_AFACCTNO
                AND CIR.RMSTATUS LIKE V_STATUS
                AND TLG.BUSDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                AND TLG.BUSDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')*/
            UNION ALL -- 1.5.7.6|iss:2024
            SELECT REQ.TXDATE, REQ.TXDATE BUSDATE, '' TXNUM, REQ.AFACCTNO, TL.TXDESC TLTXCD,
                   REQ.AMOUNT TRFAMT, UTF8NUMS.c_const_TLTX_STATUS_1118 STATUS, TL.TXDESC TRFTYPE,
                   REQ.BENEFBANK, REQ.BENEFCUSTNAME, CF.CUSTODYCD, REQ.BENEFACCT, 'MS-Trade' VIA,
                   UTF8NUMS.c_const_TLTX_TXDESC_1118 TXDESC,
                   REQ.BENEFLICENSE, CFO.CITYBANK, CFO.CITYEF, 'P' RMSTATUS, '2' TRFTYPEVALUE,
                   '' RECVCUSTODYCD, V_NEXTSEQ + REQ.AUTOID AUTOID, 0 FEEAMT
            FROM EXTRANFERREQ REQ, CFMAST CF, AFMAST AF, TLTX TL, CFOTHERACC CFO, (
               SELECT to_date(varvalue, 'DD/MM/RRRR') CURRDATE
               FROM sysvar WHERE grname = 'SYSTEM' AND varname = 'CURRDATE'
            ) GR
            WHERE REQ.AFACCTNO = AF.ACCTNO
              AND AF.CUSTID = CF.CUSTID
              AND REQ.STATUS = 'P'
              AND TL.TLTXCD = '1118'
              AND CFO.AFACCTNO = REQ.AFACCTNO
              AND CFO.BANKACC = REQ.BENEFACCT
              AND REQ.TXDATE = GR.CURRDATE
              AND CF.CUSTID LIKE V_CUSTID
              AND AF.ACCTNO LIKE V_AFACCTNO
              AND (V_STATUS <> 'C' OR V_STATUS = '%%')
              AND REQ.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
              AND REQ.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')

            UNION ALL --1.8.2.1: chuyen khoan giua 2 tk lk
             SELECT tc.txdate,tc.txdate BUSDATE, tc.txnum, tc.dacctno AFACCTNO, '1201' TLTXCD, TC.AMT TRFAMT, A1.CDCONTENT STATUS,
                    tltx.txdesc TRFTYPE, '' BENEFBANK, cfc.fullname RECVFULLNAME
                    , cfd.custodycd TRFCUSTODYCD, tc.cacctno RECVAFACCTNO,
                    A2.CDCONTENT TRFPLACE, tc.Des TXDESC, cfc.idcode BENEFLICENSE, '' CITYBANK, '' CITYEF,
                     case when CR.RMSTATUS in('E','W','M') then 'P' else CR.RMSTATUS END RMSTATUS ,'1' TRFTYPEVALUE,
                       cfc.custodycd RECVCUSTODYCD ,
                    0 AUTOID, tc.feeamt FEEAMT
                FROM  ciremittance cr,(SELECT * FROM tcdt2DEPOACC_LOG UNION ALL SELECT * FROM tcdt2DEPOACC_LOG_HIST) tc,
                 cfmast cfd, cfmast cfc,tltx, ALLCODE A1, ALLCODE A2
                WHERE cr.txdate = tc.txdate AND cr.txnum = tc.txnum
                AND tc.dcustodycd = cfd.custodycd
                AND tc.ccustodycd = cfc.custodycd
                AND A1.CDTYPE = 'CI' AND A1.CDNAME = 'RMSTATUS' AND A1.CDVAL =  case when CR.RMSTATUS in('E','W','M') then 'P' else CR.RMSTATUS END
                AND A2.CDTYPE = 'SA' AND A2.CDNAME = 'VIA' AND A2.CDVAL = DECODE(SUBSTR(TC.TXNUM,1,2),systemnums.C_OL_PREFIXED,'O','F')
                AND cr.rmstatus <> 'R'
                AND tltx.tltxcd = '1120'
                AND tc.TXDATE >= TO_DATE(F_DATE,'DD/MM/RRRR')
                AND tc.TXDATE <= TO_DATE(T_DATE,'DD/MM/RRRR')
                AND CFD.CUSTID LIKE V_CUSTID
                AND TC.DACCTNO LIKE V_AFACCTNO
                AND CR.RMSTATUS LIKE V_STATUS
        ) TLG
        ORDER BY TLG.TXDATE DESC, TLG.AUTOID DESC, SUBSTR(TLG.TXNUM,5,6) DESC;

EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GetCashTransfer');
END pr_GetCashTransfer;

PROCEDURE pr_GetTotalInvesment
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2)
    IS

    V_CUSTODYCD   VARCHAR2(10);
    V_AFACCTNO    VARCHAR2(10);
    V_CUSTID      VARCHAR2(10);
    V_STATUS      VARCHAR2(2);
    v_DefIntInDay  number(20,0);
    v_AssetNetTotal number(20,0);
    v_FeeDutyTotal number(20,0);
    v_DefIntInTime   number(20,0);
    l_isstopadv      varchar2(10);
BEGIN
    l_isstopadv := cspks_system.fn_get_sysvar('MARGIN','ISSTOPADV');
    IF AFACCTNO = 'ALL' OR AFACCTNO IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := AFACCTNO;
    END IF;



    OPEN p_REFCURSOR FOR

    SELECT  ci.ACCTNO
    , nvl(ptemp.profitandloss,0) DefIntInDay--lai/lo tam tinh
    , nvl(preal.lai_lo_thuc,0) DefIntInTime --lai/lo thuc
    , nvl(ptemp.profitandloss,0) + nvl(preal.lai_lo_thuc,0) DefIntTotal  --Tong lai/lo
    , round(decode(nvl(tax_ct.namt,0)  + nvl(preal.phi_thue_mua_ban,0),0,0
                ,(nvl(ptemp.profitandloss,0) + nvl(preal.lai_lo_thuc,0)) / (nvl(tax_ct.namt,0) +  nvl(preal.phi_thue_mua_ban,0)) * 100
            ),2) DefIntPer
    , ci.balance - nvl(b.secureamt,0) - nvl(b.advamt,0)-- tien_mat
        + decode(l_isstopadv,'Y',0,nvl(avl.maxavlamt,0)) --tien_ung_truoc
        + nvl(buf.RECEIVING,0) - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 --  buf.CASH_RECEIVING_T2  -- receiving_right
      MoneyTotal    --Tong tien
    , nvl(ptemp.marketamt,0) AssetNetTotal -- GTTT
    , ci.balance - nvl(b.secureamt,0) - nvl(b.advamt,0)-- tien_mat
        + decode(l_isstopadv,'Y',0,nvl(avl.maxavlamt,0)) --tien_ung_truoc
        + nvl(buf.RECEIVING,0) - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 --  buf.CASH_RECEIVING_T2
        + nvl(ptemp.marketamt,0)  AssetTotal --tong tai san
    --, nvl(GREATEST(avl.MAXAVLAMT-ROUND(avl.DEALPAID,0),0),0) - nvl(aaa.advamt,0) phi_ung_du_tinh
    --, round(nvl(buf.avlwithdraw,0),0) avlwithdraw
    , round(/*nvl(tax_ct.namt,0) -- thue ban co tuc
        +*/ nvl(tranfer_amt,0) + nvl(preal.phi_thue_mua_ban,0)) FeeDutyTotal  --tong phi thue
    , nvl(iused.feeamt,0) --Lai ung truoc da su dung
        + nvl(ipast.fee_mov,0) --lai margin + BL da thu
        + nvl(ipre.INTNML,0) --lai margin + BL ht
    IntPayTotal --tong lai phai tra
FROM (
        SELECT  VW.ACCTNO, sum(VW.MAXAVLAMT) MAXAVLAMT,
        sum((CASE WHEN VW.TXDATE =TO_DATE(SYS.VARVALUE,'DD/MM/RRRR') AND ISVSD='N' THEN fn_getdealgrppaid(VW.ACCTNO) ELSE 0 END)/
        (1-ADT.ADVRATE/100/360*VW.days)) DEALPAID
        FROM VW_ADVANCESCHEDULE VW, SYSVAR SYS,AFMAST AF, AFTYPE AFT ,ADTYPE ADT
        WHERE SYS.GRNAME='SYSTEM' AND SYS.VARNAME ='CURRDATE'
        AND VW.ACCTNO = AF.ACCTNo AND AF.ACTYPE=AFT.ACTYPE AND AFT.ADTYPE=ADT.ACTYPE
        and af.acctno like '%'
        group by VW.ACCTNO
     ) avl
     , cimast ci, v_getAccountAvlAdvance aaa , v_getbuyorderinfo b, v_getdealpaidbyaccount pd, buf_ci_account buf,
     (
        SELECT acctno afacctno, sum(namt) tranfer_amt FROM vw_citran_gen WHERE acctno LIKE V_AFACCTNO
        AND txcd = '0028' AND tltxcd = '1101' AND txdate BETWEEN to_date(F_DATE,'DD/MM/RRRR') and to_date(T_DATE,'DD/MM/RRRR')
        GROUP BY acctno
    ) tr,
    (select ci.acctno, sum(case when ci.txdate <> getcurrdate and ci.tltxcd = '0066' then  ci.namt
                                when ci.tltxcd <> '0066' then ci.namt
                                else 0
                         end) namt from vw_citran_gen ci where tltxcd in ('3350','0066','1182') --1182: phi luu ky hang thang
                         and txcd in ('0011','0028') and ci.acctno like V_AFACCTNO and ci.deltd <> 'Y'
        and ci.txdate BETWEEN to_date (F_DATE,'dd/mm/yyyy') and to_date (T_DATE,'dd/mm/yyyy')
        group by ci.acctno) tax_ct, --thue co tuc
    --lai lo tam tinh
    (
     select se.acctno, sum((basicprice - costprice) * (trade /*+ ca_sec*/ + receiving+secured)) profitandloss --lai/lo tam tinh
        ,sum(basicprice * (trade + receiving + secured /*+ ca_sec*/))  MARKETAMT --GTTT
    from (
                SELECT  SDTL.AFACCTNO ACCTNO,
                    SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED TRADE,
                    nvl(sdtl_wft.wft_receiving,0) CA_sec,

                    nvl(od.REMAINQTTY,0) - nvl(B_remainqtty,0) secured,
                    SDTL.receiving + nvl(od.B_execqtty_new,0)/*SDTL.SECURITIES_RECEIVING_T3*/ receiving,
                    CASE WHEN nvl( stif.closeprice,0)>0 THEN stif.closeprice ELSE  SEC.BASICPRICE END BASICPRICE,
                    round((
                        round(nvl(sdtl1.costprice,sdtl.costprice)) -- gia_von_ban_dau ,
                        *(SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED + SDTL.RECEIVING  ) --tong_kl
                        + nvl(od.B_execamt,0) --gia_tri_mua --gia tri khop mua
                        )     /            (SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED
                        + SDTL.RECEIVING + nvl(od.B_EXECQTTY,0) + 0.000001 )
                        ) as COSTPRICE

                FROM  SBSECURITIES SB, SECURITIES_INFO SEC, BUF_SE_ACCOUNT SDTL
                LEFT JOIN
                (SELECT TO_NUMBER( closeprice) closeprice,symbol from stockinfor WHERE tradingdate = to_char(getcurrdate ,'dd/mm/yyyy')) stif
                ON SDTL.symbol = stif.symbol
                left join
                (select seacctno, sum(decode(o.exectype , 'NB', o.remainqtty, 0)) B_remainqtty, sum(o.remainqtty) remainqtty, sum(decode(o.exectype , 'NB',  o.execamt ,0 )) B_execamt
                    , sum(decode(o.exectype , 'NB',  o.execqtty ,0 )) B_execqtty, SUM(CASE WHEN o.stsstatus <> 'C' THEN (decode(o.exectype , 'NB',  o.execqtty ,0 )) ELSE 0 END)  B_execqtty_new
                from odmast o
                where deltd <>'Y' and o.exectype in('NS','NB','MS')
                and o.txdate =(select to_date(VARVALUE,'DD/MM/YYYY') from sysvar where grname='SYSTEM' and varname='CURRDATE')
                and o.afacctno like V_AFACCTNO
                group by seacctno
                ) OD on sdtl.acctno = od.seacctno
                left join
                (select afacctno, refcodeid, trade + receiving - SECURITIES_RECEIVING_T1 - SECURITIES_RECEIVING_T2 wft_receiving
                from buf_se_account sdtl, sbsecurities sb
                where sdtl.codeid = sb.codeid and sb.refcodeid is not null and sdtl.afacctno like V_AFACCTNO
                ) sdtl_wft on sdtl.codeid = sdtl_wft.refcodeid and sdtl.afacctno = sdtl_wft.afacctno
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
                        from odmast o
                        where deltd <>'Y' and o.exectype in('NS','NB','MS')
                        and o.txdate =(select to_date(VARVALUE,'DD/MM/YYYY') from sysvar where grname='SYSTEM' and varname='CURRDATE')
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
                WHERE
                SB.CODEID = SDTL.CODEID --and sb.refcodeid is null
                and sdtl.afacctno like V_AFACCTNO
                AND SDTL.CODEID = SEC.CODEID
                and SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED + SDTL.receiving+SDTL.SECURITIES_RECEIVING_T0+SDTL.SECURITIES_RECEIVING_T1+SDTL.SECURITIES_RECEIVING_T2+SDTL.SECURITIES_RECEIVING_T3 + nvl(od.REMAINQTTY,0) >0
         ) se
    group by se.acctno
    ) ptemp--end lai/lo tam tinh
    ,(
    --lai/lo thuc
    SELECT STS.AFACCTNO
        ,sum( STS.FEEACR) phi_thue_mua_ban --tong phi mua ban + thue ban
        ,sum ( STS.PROFITANDLOSS) lai_lo_thuc --lai lo thuc

    FROM
        (
            SELECT OD.TXDATE, OD.EXECTYPE, OD.AFACCTNO, OD.ORDERID, OD.CODEID, SB.SYMBOL, OD.EXECAMT, OD.EXECQTTY,
                ROUND(OD.EXECAMT/OD.EXECQTTY) EXECPRICE,
                CASE WHEN OD.EXECAMT >0 AND OD.FEEACR =0 AND OD.STSSTATUS = 'N' THEN OD.EXECAMT*ODT.DEFFEERATE/100 ELSE OD.FEEACR END FEEACR,
                0 PROFITANDLOSS, ROUND(OD.EXECAMT/OD.EXECQTTY) COSTPRICE
            FROM VW_ODMAST_ALL OD, SBSECURITIES SB, AFMAST AF, ODTYPE ODT
            WHERE OD.CODEID = SB.CODEID AND AF.ACCTNO = OD.AFACCTNO
                AND OD.ORSTATUS IN ('4','5','7','12') AND OD.EXECQTTY>0 AND INSTR(OD.EXECTYPE,'B') >0
                AND OD.ACTYPE = ODT.ACTYPE
                and od.afacctno like V_AFACCTNO
                AND OD.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                AND OD.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
            UNION ALL
            SELECT OD.TXDATE, OD.EXECTYPE, OD.AFACCTNO, OD.ORDERID, OD.CODEID, SB.SYMBOL, OD.EXECAMT, OD.EXECQTTY,
                ROUND(OD.EXECAMT/OD.EXECQTTY) EXECPRICE,
                CASE WHEN OD.EXECAMT >0 AND OD.FEEACR =0 AND OD.STSSTATUS = 'N' THEN OD.EXECAMT*ODT.DEFFEERATE/100 ELSE OD.FEEACR END
                +
                CASE WHEN AFT.VAT = 'Y' and od.txdate = getcurrdate --chi lay thue hien tai, phan thue ban qua khu lay trong 0066
                        THEN (select to_number(varvalue) from sysvar where varname = 'ADVSELLDUTY' and grname = 'SYSTEM')
                    * STS.AMT /100
                ELSE 0 END
                 FEEACR --phi ban + thue ban
                 ,
                (STS.AMT - round(STS.QTTY * (CASE WHEN STS.TXDATE = getcurrdate THEN SE.COSTPRICE ELSE STS.COSTPRICE END))
                -
                --PHI BAN
                case when od.execamt > 0 and od.feeacr=0 then ROUND(sts.amt * odt.deffeerate / 100, 2)
                     else
                            (CASE WHEN (od.execamt * od.feeacr) = 0 THEN 0 ELSE
                                    (CASE WHEN od.TXDATE = getcurrdate THEN round(od.feeacr * sts.amt / od.execamt,2)
                                          ELSE ROUND(sts.amt / od.execamt * od.feeacr, 2)
                                    END)
                            END)
                end
                -
                --THUE
                CASE WHEN AFT.VAT = 'Y'
                        THEN (select to_number(varvalue) from sysvar where varname = 'ADVSELLDUTY' and grname = 'SYSTEM')
                    * STS.AMT /100
                ELSE 0 END
                ) PROFITANDLOSS,
                CASE WHEN STS.TXDATE = getcurrdate THEN SE.COSTPRICE ELSE STS.COSTPRICE END COSTPRICE
            FROM VW_STSCHD_ALL STS, SBSECURITIES SB, AFMAST AF, SEMAST SE, VW_ODMAST_ALL OD, ODTYPE ODT, AFTYPE AFT
            WHERE OD.CODEID = SB.CODEID AND AF.ACCTNO = OD.AFACCTNO
                AND OD.ORSTATUS IN ('4','5','7','12') AND OD.EXECQTTY>0 AND INSTR(OD.EXECTYPE,'S') >0
                AND OD.ACTYPE = ODT.ACTYPE AND AF.ACTYPE = AFT.ACTYPE
                and STS.DUETYPE= 'SS'
                AND STS.acctno = SE.acctno
                AND OD.orderid = STS.orgorderid
                and af.acctno like V_AFACCTNO
                AND OD.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                AND OD.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
        ) STS, ALLCODE A1
        WHERE A1.CDTYPE = 'OD' AND A1.CDNAME = 'EXECTYPE' AND A1.CDVAL = STS.EXECTYPE
        group by STS.AFACCTNO
    ) preal,
    --Lai ung truoc da su dung
    (select acctno, sum(feeamt) feeamt from ADSCHD where txdate <= to_date(T_DATE,'DD/MM/RRRR') and txdate >=to_date(F_DATE,'DD/MM/RRRR')
        and acctno like V_AFACCTNO group by acctno) Iused
    ,
    --lai da thu qua khu
    (
     select ln.trfacctno, sum(mov.int_move) + sum(mov.fee_move) fee_mov from
        (
        SELECT AUTOID,TXDATE, NML, OVD,PAID,INTPAID INT_MOVE,FEEPAID FEE_MOVE
        FROM (

             select lnslog.autoid,lnslog.txnum,lnslog.txdate,
                 case when ln.ftype ='DF' then lnslog.nml + lnslog.ovd + lnslog.paid
                 else lnslog.nml end nml,
                 0 ovd,0 paid,0 intpaid,0 feepaid,lnslog.deltd
            from   vw_lnmast_all ln,vw_lnschd_all lns, vw_lnschdlog_all lnslog
                   WHERE ln.acctno = lns.acctno  and lns.autoid = lnslog.autoid
                   and lns.reftype in ('P','GP')
                   and (case when ln.ftype ='DF' then
                   0 else lnslog.paid + lnslog.intpaid +lnslog.feepaid end)  = 0
                   AND (case when ln.ftype ='DF' then lnslog.nml + lnslog.paid + lnslog.ovd
                    else lnslog.nml end ) >0
             UNION
             --goc
             SELECT autoid,txnum,txdate,0 nml,0 ovd,paid,0 intpaid,0 feepaid,deltd
             FROM (
                 SELECT * FROM LNSCHDLOG
                 UNION ALL
                 SELECT * FROM LNSCHDLOGHIST )
             WHERE paid  <> 0
                 --AND abs(nml)+ abs(ovd) +abs(paid) + abs(intpaid) + abs(feepaid) > 0
             UNION
             --lai
             SELECT autoid,txnum,txdate,0 nml,0 ovd,0 paid,
                 intpaid, 0 feepaid,deltd
             FROM (
                 SELECT * FROM LNSCHDLOG
                 UNION ALL
                 SELECT * FROM LNSCHDLOGHIST )
             WHERE  intpaid <> 0
                 AND abs(nml)+abs(ovd) +abs(paid) + abs(intpaid) + abs(feepaid) > 0
             --phi
             UNION
             --lai
             SELECT autoid,txnum,txdate,0 nml,0 ovd,0 paid,0 intpaid,feepaid + feeintpaid,deltd
             FROM (
                 SELECT * FROM LNSCHDLOG
                 UNION ALL
                 SELECT * FROM LNSCHDLOGHIST )
             WHERE  feepaid + feeintpaid <> 0
                 AND abs(nml)+abs(ovd) +abs(paid) + abs(intpaid) + abs(feepaid) + abs(feeintpaid) > 0 ) LNSLOG
        WHERE NVL(DELTD,'N') <>'Y'
        ) mov,
        vw_lnschd_all lns, lnmast ln
        where mov.autoid = lns.autoid and lns.acctno = ln.acctno and lns.reftype in ('P','GP')
        and ln.trfacctno like V_AFACCTNO
        and mov.txdate >= to_date(F_DATE,'DD/MM/RRRR') and mov.txdate <=  to_date(T_DATE,'DD/MM/RRRR')
        group by ln.trfacctno
    ) ipast,
    -- lai margin + BL ht
    (
    SELECT   AF.ACCTNO AFACCTNO,
                 sum(SCHD.INTNMLACR  + SCHD.INTOVD + SCHD.INTDUE + SCHD.FEEINTNMLACR + SCHD.FEEINTDUE + SCHD.FEEINTNMLOVD --INTNML
                  + SCHD.INTOVDPRIN + SCHD.FEEINTOVDACR) INTNML
            FROM CFMAST CF, AFMAST AF, LNMAST LN, LNTYPE TY,
                 (SELECT LNSCHD.*,
                          DATEDIFF('D', RLSDATE, GETCURRDATE) DAYS
                     FROM LNSCHD
                    WHERE REFTYPE IN ('GP', 'P')
                      AND DUENO = 0) SCHD, V_GETGRPDEALFORMULAR V_DEAL
           WHERE AF.CUSTID = CF.CUSTID
             AND AF.ACCTNO = LN.TRFACCTNO
             AND LN.ACTYPE = TY.ACTYPE
             AND SCHD.ACCTNO = LN.ACCTNO
             AND LN.ACCTNO = V_DEAL.LNACCTNO(+)
             and af.acctno like V_AFACCTNO
             AND SCHD.NML + SCHD.OVD + SCHD.INTNMLACR + SCHD.INTOVDPRIN + SCHD.INTDUE + SCHD.FEEINTNMLACR + SCHD.FEEINTDUE + SCHD.FEEINTOVDACR + SCHD.INTOVD + SCHD.FEEINTNMLOVD > 0
        group by AF.ACCTNO
    ) ipre
WHERE  ci.acctno like V_AFACCTNO
and ci.acctno = avl.acctno(+)
and ci.acctno = aaa.afacctno(+)
and ci.acctno = buf.afacctno (+)
and ci.acctno = b.afacctno (+)
and ci.acctno = pd.afacctno (+)
and ci.acctno = tax_ct.acctno (+)
and ci.acctno = ptemp.acctno(+)
and ci.acctno = preal.afacctno(+)
and ci.acctno = iused.acctno(+)
and ci.acctno = ipast.trfacctno(+)
and ci.acctno = ipre.AFACCTNO(+)
and ci.acctno = tr.afacctno(+)



    ;

EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GetTotalInvesment');
END pr_GetTotalInvesment;


PROCEDURE pr_MoneyTransDetail
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2,
     P_STATUS       in  varchar2 default 'ALL',
     P_PLACE        in  varchar2 default 'ALL',
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2)
    IS

    V_CUSTODYCD   VARCHAR2(10);
    V_AFACCTNO    VARCHAR2(10);
    V_CUSTID      VARCHAR2(10);
    V_STATUS      VARCHAR2(2);
    v_DefIntInDay  number(20,0);
    v_AssetNetTotal number(20,0);
    v_FeeDutyTotal number(20,0);
    v_DefIntInTime   number(20,0);
    v_place       varchar2(10);

BEGIN

    IF AFACCTNO = 'ALL' OR AFACCTNO IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := AFACCTNO;
    END IF;

    IF P_STATUS = 'ALL' OR P_STATUS IS NULL THEN
        v_status := '%%';
    ELSE
        v_status := P_STATUS;
    END IF;

    IF P_PLACE = 'ALL' OR P_PLACE IS NULL THEN
        v_place := '%%';
    ELSE
        v_place := P_PLACE;
    END IF;




    OPEN p_REFCURSOR FOR

select A.*, '' STATUS --1.5.1.0: tra them STATUS cho HOME
from
(
SELECT cf.fullname ,  tl.tltxcd ,tltx.txdesc
,tl.txnum,tl.busdate ,tl.txdate
,cf.custodycd,af.acctno
, '' custodycdc,'' acctnoc
,tl.msgamt amt
,nvl(bank.fullname,' ') bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname, tl.txdesc trdesc, a2.cdcontent via
FROM (SELECT * FROM vw_tllog_all tl WHERE tl.tltxcd in ('1131','1141') and  TL.busdate >= to_date(F_DATE,'DD/MM/YYYY')
        AND TL.busdate <=to_date(T_DATE,'DD/MM/YYYY')
    ) TL,
    afmast af,cfmast cf ,tltx, banknostro bank, allcode a2,
    (SELECT * FROM vw_tllogfld_all WHERE txdate BETWEEN to_date(F_DATE,'DD/MM/YYYY') AND to_date(T_DATE,'DD/MM/YYYY')
        AND fldcd='02'
    ) tlfld
where tl.msgacct=af.acctno and af.custid = cf.custid
AND A2.CDTYPE = 'SA' AND A2.CDNAME = 'VIA' AND A2.CDVAL = DECODE(SUBSTR(TL.TXNUM,1,2),systemnums.C_OL_PREFIXED,'O','F')
and tltx.tltxcd = tl.tltxcd
and tlfld.txdate = tl.txdate
and tlfld.txnum = tl.txnum
and tlfld.cvalue=bank.shortname(+)
AND AF.acctno LIKE V_AFACCTNO

union all

SELECT cf.fullname, tl.tltxcd   tltxcd ,tltx.txdesc
,tl.txnum,tl.busdate ,tl.txdate
,cf.custodycd,af.acctno
, '' custodycdc,'' acctnoc
,ci.namt amt,
''bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname,nvl(CI.trdesc,ci.txdesc) trdesc, a2.cdcontent via
FROM (SELECT * FROM vw_tllog_all tl WHERE tl.tltxcd in ('1137','1138') and  TL.busdate >= to_date(F_DATE,'DD/MM/YYYY')
        AND TL.busdate <=to_date(T_DATE,'DD/MM/YYYY')
    ) TL, afmast af,cfmast cf ,tltx,
    (SELECT * FROM vw_citran_gen WHERE busdate BETWEEN to_date(F_DATE,'DD/MM/YYYY') AND to_date(T_DATE,'DD/MM/YYYY')
        AND field ='BALANCE'
    ) ci, allcode a2
where ci.acctno=af.acctno and af.custid = cf.custid
AND A2.CDTYPE = 'SA' AND A2.CDNAME = 'VIA' AND A2.CDVAL = DECODE(SUBSTR(TL.TXNUM,1,2),systemnums.C_OL_PREFIXED,'O','F')
and tltx.tltxcd = tl.tltxcd
and tl.txdate = ci.txdate
and tl.txnum = ci.txnum
AND AF.acctno LIKE V_AFACCTNO

union all

SELECT cf.fullname,
        '3342' tltxcd,
        tltx.txdesc ,tl.txnum,tl.busdate ,tl.txdate
        ,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc
        ,sum( case when ci.txtype = 'D' then -ci.namt else ci.namt end) amt
        ,''bankid,af.corebank
        ,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname
        ,max(case when ci.txcd = '0012' then nvl(CI.trdesc,ci.txdesc) else ' ' end)  trdesc, a2.cdcontent via
FROM (SELECT * FROM vw_tllog_all tl WHERE tl.tltxcd in ('3350','3354') and  TL.busdate >= to_date(F_DATE,'DD/MM/YYYY')
        AND TL.busdate <=to_date(T_DATE,'DD/MM/YYYY')
    ) TL,afmast af,cfmast cf ,tltx,
    (SELECT * FROM vw_citran_gen WHERE busdate BETWEEN to_date(F_DATE,'DD/MM/YYYY') AND to_date(T_DATE,'DD/MM/YYYY')
        AND TXCD in('0012','0011')
    ) ci, allcode a2
where tl.msgacct=af.acctno and af.custid = cf.custid
AND A2.CDTYPE = 'SA' AND A2.CDNAME = 'VIA' AND A2.CDVAL = DECODE(SUBSTR(TL.TXNUM,1,2),systemnums.C_OL_PREFIXED,'O','F')
and tltx.tltxcd = tl.tltxcd
AND TL.TXDATE = CI.TXDATE
AND TL.TXNUM = CI.TXNUM
AND AF.acctno LIKE V_AFACCTNO
group by cf.fullname,
        tltx.txdesc ,tl.txnum,tl.busdate ,tl.txdate
        ,cf.custodycd,af.acctno
        ,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname)
        ,a2.cdcontent
union all

SELECT
    cf.fullname, tl.tltxcd   tltxcd ,tltx.txdesc
,tl.txnum,tl.busdate ,tl.txdate
,cf.custodycd,af.acctno
, '' custodycdc,'' acctnoc
,ci.namt amt,
''bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname,nvl(CI.trdesc,ci.txdesc) trdesc, a2.cdcontent via
FROM (SELECT * FROM vw_tllog_all tl WHERE tl.tltxcd in ('1120','1188','1130') and  TL.busdate >= to_date(F_DATE,'DD/MM/YYYY')
        AND TL.busdate <=to_date(T_DATE,'DD/MM/YYYY')
    ) TL,afmast af,cfmast cf ,tltx,
    (SELECT * FROM vw_citran_gen WHERE busdate BETWEEN to_date(F_DATE,'DD/MM/YYYY') AND to_date(T_DATE,'DD/MM/YYYY')
        AND txtype = 'C' AND field ='BALANCE'
    ) ci, allcode a2
where ci.acctno=af.acctno and af.custid = cf.custid
AND A2.CDTYPE = 'SA' AND A2.CDNAME = 'VIA' AND A2.CDVAL = DECODE(SUBSTR(TL.TXNUM,1,2),systemnums.C_OL_PREFIXED,'O','F')
and tltx.tltxcd = tl.tltxcd
and tl.txdate = ci.txdate
and tl.txnum = ci.txnum
AND AF.acctno LIKE V_AFACCTNO
)A
 order by A.txdate, A.txnum

         ;

EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_MoneyTransDetail');
END pr_MoneyTransDetail;

-- Lay thong tin cac giao dich quyen mua
-- TheNN, 12-Jan-2012
PROCEDURE pr_GetRightOffInfor
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD    IN VARCHAR2,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2
     )
    IS

    V_CUSTODYCD   VARCHAR2(10);
    V_AFACCTNO    VARCHAR2(10);
    V_CUSTID      VARCHAR2(10);

BEGIN
    V_CUSTODYCD := CUSTODYCD;
    --V_AFACCTNO := AFACCTNO;

    IF AFACCTNO = 'ALL' OR AFACCTNO IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := AFACCTNO;
    END IF;

    -- LAY THONG TIN MA KHACH HANG
    IF V_CUSTODYCD IS NULL OR V_CUSTODYCD = 'ALL' THEN
        V_CUSTID := '%%';
    ELSE
        SELECT CUSTID INTO V_CUSTID FROM CFMAST WHERE CUSTODYCD = V_CUSTODYCD;
    END IF;


    -- LAY THONG TIN GD QUYEN MUA
    OPEN p_REFCURSOR FOR
        SELECT * FROM
        (
            -- GD DANG KY QUYEN MUA DANG CHO THUC HIEN
            SELECT RQ.TXDATE, RQ.TXDATE BUSDATE, RQ.TXNUM, '3384' TLTXCD, RQ.MSGACCT, RQ.KEYVALUE, SB.SYMBOL, RQ.MSGQTTY EXECQTTY,
                A2.CDCONTENT TXSTATUS, 'Dang ky quyen mua' EXECTYPE, RQ.AUTOID TLLOG_AUTOID
            FROM BORQSLOG RQ, ALLCODE A2, CAMAST CA, SBSECURITIES SB, AFMAST AF
            WHERE RQ.STATUS IN ('P','W','H')
                AND CA.CAMASTID = RQ.KEYVALUE AND CA.TOCODEID = SB.CODEID
                AND RQ.MSGACCT = AF.ACCTNO
                AND A2.CDTYPE = 'SA' AND A2.CDNAME = 'BORQSLOGSTS' AND A2.CDVAL = RQ.STATUS
                AND RQ.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                AND RQ.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
                AND AF.CUSTID LIKE V_CUSTID
                AND RQ.MSGACCT LIKE V_AFACCTNO

            UNION ALL
            -- CAC GD DA THUC HIEN
            SELECT CA.TXDATE, CA.BUSDATE, CA.TXNUM, CA.TLTXCD, CA.AFACCTNO, CA.CAMASTID, SB.SYMBOL, CA.EXECQTTY,
                A1.CDCONTENT TXSTATUS, CA.EXECTYPE, CA.TLLOG_AUTOID
            FROM
            (

                -- GD DANG KY QUYEN MUA
                SELECT CA.TOCODEID,TLG.TXDATE, TLG.BUSDATE, TLG.TXNUM, TLG.TLTXCD, TLG.ACCTNO AFACCTNO, CA.CAMASTID, CA.CODEID, TLG.NAMT/CA.EXPRICE EXECQTTY,
                    '1' TXSTATUS, 'Dang ky quyen mua' EXECTYPE, TLG.TLLOG_AUTOID
                FROM
                    (SELECT * FROM VW_CITRAN_GEN TLG
                        WHERE TLG.TLTXCD = '3384' AND TLG.DELTD = 'N' AND TLG.TXCD = '0028'
                            AND TLG.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                            AND TLG.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
                    ) TLG, CAMAST CA,CASCHD CAS
                WHERE CAS.AUTOID = TLG.ACCTREF
                    AND TLG.CUSTID LIKE V_CUSTID
                    AND TLG.ACCTNO LIKE V_AFACCTNO
                    AND CAS.CAMASTID=CA.CAMASTID
                UNION ALL
                -- GD NHAN CHUYEN NHUONG QUYEN MUA
                SELECT CA.TOCODEID,TLG.TXDATE, TLG.BUSDATE, TLG.TXNUM, TLG.TLTXCD, SUBSTR(TLG.ACCTNO,1,10) AFACCTNO, CA.CAMASTID, CA.CODEID, TLG.NAMT EXECQTTY,
                    '1' TXSTATUS, 'Nhan chuyen nhuong quyen mua' EXECTYPE, TLG.TLLOG_AUTOID
                FROM
                    (SELECT * FROM VW_SETRAN_GEN TLG
                        WHERE TLG.TLTXCD IN ('3385','3382') AND TLG.DELTD = 'N' AND TLG.TXCD = '0045'
                            AND TLG.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                            AND TLG.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
                    ) TLG, CAMAST CA, AFMAST AF
                WHERE CA.CAMASTID = TLG.REF
                    AND AF.ACCTNO = SUBSTR(TLG.ACCTNO,1,10)
                    AND AF.CUSTID LIKE V_CUSTID
                    AND AF.ACCTNO LIKE V_AFACCTNO

                UNION ALL
                -- GD CHUYEN NHUONG QUYEN RA NGOAI
                SELECT CA.TOCODEID,TLG.TXDATE, TLG.BUSDATE, TLG.TXNUM, TLG.TLTXCD, SUBSTR(TLG.ACCTNO,1,10) AFACCTNO, CA.CAMASTID, CA.CODEID, TLG.NAMT EXECQTTY,
                    '1' TXSTATUS, 'Chuyen nhuong quyen mua ra ngoai' EXECTYPE, TLG.TLLOG_AUTOID
                FROM
                    (SELECT * FROM VW_SETRAN_GEN TLG
                        WHERE TLG.TLTXCD IN ('3383','3382') AND TLG.DELTD = 'N' AND TLG.TXCD = '0040'
                            AND TLG.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                            AND TLG.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
                    ) TLG, CAMAST CA, AFMAST AF
                WHERE CA.CAMASTID = TLG.REF
                    AND AF.ACCTNO = SUBSTR(TLG.ACCTNO,1,10)
                    AND AF.CUSTID LIKE V_CUSTID
                    AND AF.ACCTNO LIKE V_AFACCTNO

                UNION ALL
                -- GD HUY DANG KY QUYEN MUA
                SELECT CA.TOCODEID,TLG.TXDATE, TLG.BUSDATE, TLG.TXNUM, TLG.TLTXCD, SUBSTR(TLG.ACCTNO,1,10) AFACCTNO, CA.CAMASTID, CA.CODEID, TLG.NAMT EXECQTTY,
                    '1' TXSTATUS, 'Huy dang ky quyen mua' EXECTYPE, TLG.TLLOG_AUTOID
                FROM
                    (SELECT * FROM VW_SETRAN_GEN TLG
                        WHERE TLG.TLTXCD IN ('3386') AND TLG.DELTD = 'N' AND TLG.TXCD = '0045'
                            AND TLG.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                            AND TLG.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
                    ) TLG, CAMAST CA, AFMAST AF
                WHERE CA.CAMASTID = TLG.REF
                    AND AF.ACCTNO = SUBSTR(TLG.ACCTNO,1,10)
                    AND AF.CUSTID LIKE V_CUSTID
                    AND AF.ACCTNO LIKE V_AFACCTNO
                UNION ALL
                -- GD DK MUA CP PHAT HANH THEM KO CAT CI
                SELECT CA.TOCODEID,TLG.TXDATE, TLG.BUSDATE, TLG.TXNUM, TLG.TLTXCD, SUBSTR(TLG.ACCTNO,1,10) AFACCTNO, CA.CAMASTID, CA.CODEID, TLG.NAMT EXECQTTY,
                    '1' TXSTATUS, 'DK mua CP phat hanh them khong cat CI' EXECTYPE, TLG.TLLOG_AUTOID
                FROM
                    (SELECT * FROM VW_SETRAN_GEN TLG
                        WHERE TLG.TLTXCD IN ('3324') AND TLG.DELTD = 'N' AND TLG.TXCD = '0016'
                            AND TLG.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                            AND TLG.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
                    ) TLG, CAMAST CA, AFMAST AF, caschd cas
                WHERE CAs.autoid = TLG.REF
                    AND ca.camastid = cas.camastid AND af.acctno = cas.afacctno
                    AND AF.ACCTNO = SUBSTR(TLG.ACCTNO,1,10)
                    AND AF.CUSTID LIKE V_CUSTID
                    AND AF.ACCTNO LIKE V_AFACCTNO
                UNION ALL
                -- GD HUY DK MUA CP PHAT HANH THEM KO CAT CI
                SELECT CA.TOCODEID,TLG.TXDATE, TLG.BUSDATE, TLG.TXNUM, TLG.TLTXCD, SUBSTR(TLG.ACCTNO,1,10) AFACCTNO, CA.CAMASTID, CA.CODEID, TLG.NAMT EXECQTTY,
                    '1' TXSTATUS, 'Huy DK mua CP phat hanh them khong cat CI' EXECTYPE, TLG.TLLOG_AUTOID
                FROM
                    (SELECT * FROM VW_SETRAN_GEN TLG
                        WHERE TLG.TLTXCD IN ('3326') AND TLG.DELTD = 'N' AND TLG.TXCD = '0015'
                            AND TLG.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                            AND TLG.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
                    ) TLG, CAMAST CA, AFMAST AF, caschd cas
                WHERE CAs.autoid = TLG.REF
                    AND ca.camastid = cas.camastid AND af.acctno = cas.afacctno
                    AND AF.ACCTNO = SUBSTR(TLG.ACCTNO,1,10)
                    AND AF.CUSTID LIKE V_CUSTID
                    AND AF.ACCTNO LIKE V_AFACCTNO
            ) CA, ALLCODE A1, SBSECURITIES SB
            WHERE CA.TOCODEID = SB.CODEID
                AND A1.CDTYPE = 'SY' AND A1.CDNAME = 'TXSTATUS' AND A1.CDVAL = CA.TXSTATUS
        ) A
        ORDER BY A.BUSDATE DESC, A.TLLOG_AUTOID DESC, SUBSTR(A.TXNUM,5,6) DESC;

EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GetRightOffInfor');
END pr_GetRightOffInfor;


---------------------------------------------------------------
-- Ham thuc hien ung truoc tien ban cho khach hang
-- Dau vao: - p_afacctno: So tieu khoan
--          - p_txdate: Ngay khop lenh
--          - p_duedate: Ngay thanh toan
--          - p_advamt: So tien ung truoc
--          - p_feeamt: So phi ung truoc
--          - p_advdays: So ngay ung truoc
--          - p_maxamt: So tien co the ung truoc toi da
--          - p_desc: Mo ta GD ung truoc
-- Dau ra:  - p_err_code: Ma loi tra ve. =0: thanh cong. <>0: Loi
--          - p_err_message: thong bao loi neu ma loi <>0
-- Created by: TheNN     Date: 18-Jan-2011
---------------------------------------------------------------
PROCEDURE pr_AdvancePayment
    (   p_afacctno varchar,
        p_txdate varchar2,
        p_duedate varchar2,
        p_advamt number,
        p_feeamt NUMBER,
        p_advdays NUMBER,
        p_maxamt    NUMBER,
        p_desc varchar2,
        p_err_code  OUT varchar2,
        p_err_message  OUT varchar2,
        p_ipaddress in  varchar2 default '' , --1.5.3.0
        p_via in varchar2 default '',
        p_validationtype in varchar2 default '',
        p_devicetype IN varchar2 default '',
        p_device  IN varchar2 default ''
    )
    IS
        l_txmsg       tx.msg_rectype;
        v_strCURRDATE varchar2(20);
        l_err_param   varchar2(300);
        l_custodycd   varchar2(20);
        l_ACTYPE      varchar(4);
        l_CUSTNAME    varchar2(100);
        l_ADDRESS     varchar2(200);
        l_LICENSE     varchar2(20);
        l_COREBANK    varchar2(100);
        l_BANKACCT    varchar2(50);
        l_BANKCODE    varchar2(50);
        l_DUEDATE     varchar2(20);
        l_MATCHDATE   varchar2(20);
        l_MAXAMT      NUMBER;
        l_ADTYPE      varchar(4);
        l_AMINBAL     NUMBER;
        l_VAT         NUMBER;
        l_INTRATE     NUMBER;
        l_BNKRATE     NUMBER;
        l_CMPMINBAL   NUMBER;
        l_BNKMINBAL   NUMBER;
        l_ADVAMT      NUMBER;
        l_FEEAMT      NUMBER;
        l_BNKFEEAMT   NUMBER;
        l_VATAMT      NUMBER;
        l_AMT         NUMBER;
        l_ADVMAXFEE     NUMBER;
        l_IDDATE      date;
        l_IDPLACE     varchar2(2000);
        l_ISVSD       varchar(1 );

    BEGIN
        plog.setbeginsection(pkgctx, 'pr_AdvancePayment');

        -- Check host & branch active or inactive
        p_err_code := fn_CheckActiveSystem;
        IF p_err_code <> systemnums.C_SUCCESS THEN
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_AdvancePayment');
            return;
        END IF;
        -- End: Check host & branch active or inactive

        SELECT TO_CHAR(getcurrdate) INTO v_strCURRDATE FROM DUAL;
        l_txmsg.msgtype     :='T';
        l_txmsg.local       :='N';
        l_txmsg.tlid        := systemnums.C_ONLINE_USERID;
        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                 SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
          INTO l_txmsg.wsname, l_txmsg.ipaddress
        FROM DUAL;
        --1.5.3.0
        if (p_ipaddress is not null ) then l_txmsg.ipaddress:= substr(p_ipaddress,1,20); end if;--1.6.1.9; MSBS-2209  substr
        --
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txcompleted;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'DAY';
        l_txmsg.txdate      :=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.busdate     :=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.tltxcd      :='1153';

        --Set txnum
        SELECT systemnums.C_OL_PREFIXED
                         || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                  INTO l_txmsg.txnum
                  FROM DUAL;
        l_txmsg.brid        := substr(p_afacctno,1,4);

        --LAY THONG TIN KHACH HANG
        SELECT AF.ACTYPE AFTYPE, AD.ACTYPE ADTYPE, CF.CUSTODYCD, CF.FULLNAME, CF.IDCODE, CF.ADDRESS, AF.BANKACCTNO, AF.BANKNAME,
            AD.ADVMINAMT, AD.VATRATE, AD.ADVRATE, AD.ADVBANKRATE, AD.ADVMINFEE, AD.ADVMINFEEBANK, ad.advmaxfee, cf.iddate, cf.idplace,
            decode(af.corebank,'Y',1,0) COREBANK
        INTO l_ACTYPE, l_ADTYPE,l_custodycd, l_CUSTNAME, l_LICENSE, l_ADDRESS, l_BANKACCT, l_BANKCODE,
            l_AMINBAL, l_VAT, l_INTRATE, l_BNKRATE, l_CMPMINBAL, l_BNKFEEAMT, l_ADVMAXFEE, l_IDDATE, l_IDPLACE,l_COREBANK
        FROM CFMAST CF, AFMAST AF, AFTYPE AFT, ADTYPE AD
        WHERE CF.CUSTID = AF.CUSTID AND AF.ACTYPE = AFT.ACTYPE AND AFT.ADTYPE = AD.ACTYPE
            AND AF.ACCTNO = p_afacctno;

        --Set cac field giao dich
        l_DUEDATE := p_duedate;--TO_CHAR(p_duedate,'DD/MM/YYYY');
        l_MATCHDATE := p_txdate;--TO_CHAR(p_txdate,'DD/MM/YYYY');

        --03   ACCTNO      C
        l_txmsg.txfields ('03').defname   := 'ACCTNO';
        l_txmsg.txfields ('03').TYPE      := 'C';
        l_txmsg.txfields ('03').VALUE     := to_char(nvl(p_afacctno,''));
        --88   CUSTODYCD      C
        l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
        l_txmsg.txfields ('88').TYPE      := 'C';
        l_txmsg.txfields ('88').VALUE     := l_custodycd;
        --89   ACTYPE      C
        l_txmsg.txfields ('89').defname   := 'ACTYPE';
        l_txmsg.txfields ('89').TYPE      := 'C';
        l_txmsg.txfields ('89').VALUE     := l_ACTYPE;
        --90   CUSTNAME        C
        l_txmsg.txfields ('90').defname   := 'CUSTNAME';
        l_txmsg.txfields ('90').TYPE      := 'C';
        l_txmsg.txfields ('90').VALUE     := l_CUSTNAME;
        --91   ADDRESS      C
        l_txmsg.txfields ('91').defname   := 'ADDRESS';
        l_txmsg.txfields ('91').TYPE      := 'C';
        l_txmsg.txfields ('91').VALUE     := l_ADDRESS;
        --92   LICENSE      C
        l_txmsg.txfields ('92').defname   := 'LICENSE';
        l_txmsg.txfields ('92').TYPE      := 'C';
        l_txmsg.txfields ('92').VALUE     := l_LICENSE;
        --94   COREBANK      C
        l_txmsg.txfields ('94').defname   := 'COREBANK';
        l_txmsg.txfields ('94').TYPE      := 'C';
        l_txmsg.txfields ('94').VALUE     := l_COREBANK;
        --93   BANKACCT      C
        l_txmsg.txfields ('93').defname   := 'BANKACCT';
        l_txmsg.txfields ('93').TYPE      := 'C';
        l_txmsg.txfields ('93').VALUE     := l_BANKACCT;
        --95   BANKCODE   C
        l_txmsg.txfields ('95').defname   := 'BANKCODE';
        l_txmsg.txfields ('95').TYPE      := 'C';
        l_txmsg.txfields ('95').VALUE     := l_COREBANK;
        --96   IDDATE    D
        l_txmsg.txfields ('96').defname   := 'IDDATE';
        l_txmsg.txfields ('96').TYPE      := 'D';
        l_txmsg.txfields ('96').VALUE     := l_IDDATE;
        --97   IDPLACE   C
        l_txmsg.txfields ('97').defname   := 'IDPLACE';
        l_txmsg.txfields ('97').TYPE      := 'C';
        l_txmsg.txfields ('97').VALUE     := l_IDPLACE;
        --08   DUEDATE          C
        l_txmsg.txfields ('08').defname   := 'DUEDATE';
        l_txmsg.txfields ('08').TYPE      := 'C';
        l_txmsg.txfields ('08').VALUE     := l_DUEDATE;
        --42   MATCHDATE         C
        l_txmsg.txfields ('42').defname   := 'MATCHDATE';
        l_txmsg.txfields ('42').TYPE      := 'C';
        l_txmsg.txfields ('42').VALUE     := l_MATCHDATE;
        --13   DAYS       N
        l_txmsg.txfields ('13').defname   := 'DAYS';
        l_txmsg.txfields ('13').TYPE      := 'N';
        l_txmsg.txfields ('13').VALUE     := p_advdays;
        --20   MAXAMT          N
        l_txmsg.txfields ('20').defname   := 'MAXAMT';
        l_txmsg.txfields ('20').TYPE      := 'N';
        l_txmsg.txfields ('20').VALUE     := p_maxamt;
        --06   ADTYPE         C
        l_txmsg.txfields ('06').defname   := 'ADTYPE';
        l_txmsg.txfields ('06').TYPE      := 'C';
        l_txmsg.txfields ('06').VALUE     := l_ADTYPE;
        --21   AMINBAL         N
        l_txmsg.txfields ('21').defname   := 'AMINBAL';
        l_txmsg.txfields ('21').TYPE      := 'N';
        l_txmsg.txfields ('21').VALUE     := l_AMINBAL;
        --22   ADVMAXFEE         N
        l_txmsg.txfields ('22').defname   := 'ADVMAXFEE';
        l_txmsg.txfields ('22').TYPE      := 'N';
        l_txmsg.txfields ('22').VALUE     := l_ADVMAXFEE;
        --19   VAT          N
        l_txmsg.txfields ('19').defname   := 'VAT';
        l_txmsg.txfields ('19').TYPE      := 'N';
        l_txmsg.txfields ('19').VALUE     := l_VAT;
        --12   INTRATE   N
        l_txmsg.txfields ('12').defname   := 'INTRATE';
        l_txmsg.txfields ('12').TYPE      := 'N';
        l_txmsg.txfields ('12').VALUE     := l_INTRATE;
        --15   BNKRATE       N
        l_txmsg.txfields ('15').defname   := 'BNKRATE';
        l_txmsg.txfields ('15').TYPE      := 'N';
        l_txmsg.txfields ('15').VALUE     := l_BNKRATE;
        --16   CMPMINBAL        N
        l_txmsg.txfields ('16').defname   := 'CMPMINBAL';
        l_txmsg.txfields ('16').TYPE      := 'N';
        l_txmsg.txfields ('16').VALUE     := l_CMPMINBAL;
        --17   BNKMINBAL        N
        l_txmsg.txfields ('17').defname   := 'BNKMINBAL';
        l_txmsg.txfields ('17').TYPE      := 'N';
        l_txmsg.txfields ('17').VALUE     := l_BNKMINBAL;
        --09   ADVAMT        N
        l_txmsg.txfields ('09').defname   := 'ADVAMT';
        l_txmsg.txfields ('09').TYPE      := 'N';
        l_txmsg.txfields ('09').VALUE     := p_advamt;
        --11   FEEAMT        N
        l_txmsg.txfields ('11').defname   := 'FEEAMT';
        l_txmsg.txfields ('11').TYPE      := 'N';
        l_txmsg.txfields ('11').VALUE     := p_feeamt;
        --14   BNKFEEAMT        N
        l_txmsg.txfields ('14').defname   := 'BNKFEEAMT';
        l_txmsg.txfields ('14').TYPE      := 'N';
        l_txmsg.txfields ('14').VALUE     := p_advamt*p_advdays*l_BNKRATE/36000;
        --18   VATAMT        N
        l_txmsg.txfields ('18').defname   := 'VATAMT';
        l_txmsg.txfields ('18').TYPE      := 'N';
        l_txmsg.txfields ('18').VALUE     := p_feeamt*l_VAT/100;
        --10   AMT        N
        l_txmsg.txfields ('10').defname   := 'AMT';
        l_txmsg.txfields ('10').TYPE      := 'N';
        l_txmsg.txfields ('10').VALUE     := p_advamt-p_feeamt;
        --41   100        N
        l_txmsg.txfields ('41').defname   := '100';
        l_txmsg.txfields ('41').TYPE      := 'N';
        l_txmsg.txfields ('41').VALUE     := 100;
        --40   36000        N
        l_txmsg.txfields ('40').defname   := '36000';
        l_txmsg.txfields ('40').TYPE      := 'N';
        l_txmsg.txfields ('40').VALUE     := 36000;
        --30   DESC    C
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').VALUE     := p_desc;
        --60 ISVSD C
        l_txmsg.txfields ('60').defname   := 'ISVSD';
        l_txmsg.txfields ('60').TYPE      := 'C';
        l_txmsg.txfields ('60').VALUE     := '0';
        --23    PAIDADVTYPE     C
        l_txmsg.txfields ('23').defname   := 'PAIDADVTYPE';
        l_txmsg.txfields ('23').TYPE      := 'C';
        l_txmsg.txfields ('23').VALUE     := 'N';


    BEGIN
        IF txpks_#1153.fn_autotxprocess (l_txmsg,
                                         p_err_code,
                                         l_err_param
           ) <> systemnums.c_success
        THEN
           plog.debug (pkgctx,
                       'got error 1153: ' || p_err_code
           );
           ROLLBACK;
           p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
           plog.error(pkgctx, 'Error:'  || p_err_message);
           plog.setendsection(pkgctx, 'pr_AdvancePayment');
           RETURN;
        END IF;
    END;
    p_err_code:=0;
    --1.5.3.0
    pr_insertiplog( l_txmsg.txnum,  l_txmsg.txdate, l_txmsg.ipaddress, p_via, p_validationtype, p_devicetype, p_device, p_err_code);
    plog.setendsection(pkgctx, 'pr_AdvancePayment');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_AdvancePayment');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_AdvancePayment');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_AdvancePayment;

---------------------------------------------------------------
-- Ham thuc hien cap nhat gia von online
-- Dau vao: - p_afacctno: So tieu khoan
--          - p_symbol: Ma CK
--          - p_newcostprice: Gia von cap nhat
--          - p_desc: Mo ta GD
-- Dau ra:  - p_err_code: Ma loi tra ve. =0: thanh cong. <>0: Loi
--          - p_err_message: thong bao loi neu ma loi <>0
-- Created by: TheNN     Date: 19-Jan-2011
---------------------------------------------------------------
PROCEDURE pr_AdjustCostprice_Online
    (   p_afacctno varchar,
        p_symbol    VARCHAR2,
        p_newcostprice  number,
        p_desc varchar2,
        p_err_code  OUT varchar2,
        p_err_message  OUT varchar2
    )
    IS
        l_txmsg         tx.msg_rectype;
        v_strCURRDATE   varchar2(20);
        l_err_param     varchar2(300);
        l_CODEID        VARCHAR2(20);
        l_SEACCTNO      VARCHAR2(20);
        l_ADJQTTY       NUMBER;
        l_COSTPRICE     NUMBER;
        l_PREVQTTY      NUMBER;

    BEGIN
        plog.setbeginsection(pkgctx, 'pr_AdjustCostprice_Online');

        -- Check host & branch active or inactive
        p_err_code := fn_CheckActiveSystem;
        IF p_err_code <> systemnums.C_SUCCESS THEN
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_AdjustCostprice_Online');
            return;
        END IF;
        -- End: Check host & branch active or inactive

        SELECT TO_CHAR(getcurrdate)
                   INTO v_strCURRDATE
        FROM DUAL;
        l_txmsg.msgtype     :='T';
        l_txmsg.local       :='N';
        l_txmsg.tlid        := systemnums.C_ONLINE_USERID;
        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                 SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
          INTO l_txmsg.wsname, l_txmsg.ipaddress
        FROM DUAL;
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txcompleted;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'INT';
        l_txmsg.txdate      :=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.busdate     :=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.tltxcd      :='2224';

        --Set txnum
        SELECT systemnums.C_OL_PREFIXED
                         || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                  INTO l_txmsg.txnum
                  FROM DUAL;
        l_txmsg.brid        := substr(p_afacctno,1,4);

        --LAY THONG TIN CHUNG KHOAN
        SELECT CODEID
        INTO l_CODEID
        FROM SBSECURITIES
        WHERE SYMBOL = p_symbol;

        l_SEACCTNO := TRIM(p_afacctno) || TRIM(l_CODEID);

        -- LAY THONG TIN TK CK
        SELECT TRADE+BLOCKED+MORTAGE VOL, COSTPRICE, PREVQTTY
        INTO l_ADJQTTY, l_COSTPRICE, l_PREVQTTY
        FROM SEMAST
        WHERE ACCTNO = l_SEACCTNO;

        -- CHECK TRUOC KHI THUC HIEN GD
        /*IF l_PREVQTTY <=0 THEN
            -- CHI CHO PHEP THAY DOI GIA VON ONLINE NEU SL NGAY HOM TRUOC >0
            p_err_code := ERRNUMS.C_SE_CANNOT_ADJUST_COSTPRICE;
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_AdjustCostprice_Online');
            RETURN;*/
        /*ELSIF l_COSTPRICE <> 0 THEN
            -- CHI CHO PHEP THAY DOI GIA VON ONLINE NEU GIA VON = 0
            p_err_code := ERRNUMS.C_SE_CANNOT_ADJUST_COSTPRICE;
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_AdjustCostprice_Online');
            RETURN;*/
        --ELSE
            --Set cac field giao dich
            --01   CODEID      C
            l_txmsg.txfields ('01').defname   := 'CODEID';
            l_txmsg.txfields ('01').TYPE      := 'C';
            l_txmsg.txfields ('01').VALUE     := l_CODEID;
            --02   AFACCTNO      C
            l_txmsg.txfields ('02').defname   := 'AFACCTNO';
            l_txmsg.txfields ('02').TYPE      := 'C';
            l_txmsg.txfields ('02').VALUE     := p_afacctno;
            --03   SEACCTNO      C
            l_txmsg.txfields ('03').defname   := 'ACCTNO';
            l_txmsg.txfields ('03').TYPE      := 'C';
            l_txmsg.txfields ('03').VALUE     := l_SEACCTNO;
            --10   COSTPRICE        N
            l_txmsg.txfields ('10').defname   := 'COSTPRICE';
            l_txmsg.txfields ('10').TYPE      := 'N';
            l_txmsg.txfields ('10').VALUE     := p_newcostprice;
            --11   ADJQTTY        N
            l_txmsg.txfields ('11').defname   := 'ADJQTTY';
            l_txmsg.txfields ('11').TYPE      := 'N';
            l_txmsg.txfields ('11').VALUE     := l_ADJQTTY;
            --30   DESC    C
            l_txmsg.txfields ('30').defname   := 'DESC';
            l_txmsg.txfields ('30').TYPE      := 'C';
            l_txmsg.txfields ('30').VALUE     := p_desc;

            BEGIN
                IF txpks_#2224.fn_autotxprocess (l_txmsg,
                                                 p_err_code,
                                                 l_err_param
                   ) <> systemnums.c_success
                THEN
                   plog.debug (pkgctx,
                               'got error 2224: ' || p_err_code
                   );
                   ROLLBACK;
                   p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
                   plog.error(pkgctx, 'Error:'  || p_err_message);
                   plog.setendsection(pkgctx, 'pr_AdjustCostprice_Online');
                   RETURN;
                END IF;
            END;
            p_err_code:=0;
            plog.setendsection(pkgctx, 'pr_AdjustCostprice_Online');
        --END IF;
    EXCEPTION
        WHEN OTHERS
        THEN
             plog.debug (pkgctx,'got error on pr_AdjustCostprice_Online');
             ROLLBACK;
             p_err_code := errnums.C_SYSTEM_ERROR;
             plog.error (pkgctx, SQLERRM);
             plog.setendsection (pkgctx, 'pr_AdjustCostprice_Online');
             RAISE errnums.E_SYSTEM_ERROR;
    END pr_AdjustCostprice_Online;

-- LAY THONG TIN UNG TRUOC DA THUC HIEN
PROCEDURE pr_GetAdvancedPayment
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN VARCHAR2,
     T_DATE         IN VARCHAR2,
     STATUS         IN VARCHAR2,
     ADVPLACE       IN VARCHAR2
    )
    IS

  V_AFACCTNO    VARCHAR2(10);
  V_FROMDATE    DATE;
  V_TODATE      DATE;
  V_STATUS      VARCHAR2(10);
  V_ADVPLACE    VARCHAR2(10);

BEGIN
    --V_AFACCTNO := AFACCTNO;
    V_FROMDATE := TO_DATE(F_DATE,'DD/MM/YYYY');
    V_TODATE := TO_DATE(T_DATE,'DD/MM/YYYY');

    IF AFACCTNO = 'ALL' OR AFACCTNO IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := AFACCTNO;
    END IF;

    IF STATUS = 'ALL' OR STATUS IS NULL THEN
        V_STATUS := '%%';
    ELSE
        V_STATUS := STATUS;
    END IF;

    IF ADVPLACE = 'ALL' OR ADVPLACE IS NULL THEN
        V_ADVPLACE := '%%';
    ELSIF ADVPLACE = 'O' THEN
        V_ADVPLACE := '68%';
    ELSIF ADVPLACE = 'F' THEN
        V_ADVPLACE := SUBSTR(AFACCTNO,1,2)||'%';
    END IF;

    -- LAY THONG TIN UT DA THUC HIEN
    OPEN p_REFCURSOR FOR
        SELECT AD.ODDATE, AD.TXDATE, AD.TXDATE EXECDATE, AD.CLEARDT, STS.AMT, AD.AMT+AD.FEEAMT AAMT,
            AD.FEEAMT, AD.AMT RECVAMT, AD.CLEARDT-AD.TXDATE ADVDAYS, A1.CDCONTENT STATUS, A2.CDCONTENT ADVPLACE, CI.TLLOG_AUTOID
        FROM
        (
            SELECT STS.TXDATE, STS.AFACCTNO, SUM(STS.AMT-STS.FEEACR-STS.TAXSELLAMT) AMT, SUM(AAMT) AAMT, SUM(FAMT) FAMT, STS.CLEARDATE
            FROM
            (
                SELECT STS.TXDATE, STS.AFACCTNO, STS.AMT, STS.AAMT, STS.FAMT, OD.FEEACR, OD.TAXSELLAMT, STS.CLEARDAY, STS.CLEARCD, STS.CLEARDATE
                FROM VW_STSCHD_ALL STS,
                    (
                        SELECT OD.ORDERID,
                         CASE WHEN OD.FEEACR >0 THEN OD.FEEACR ELSE OD.EXECAMT*ODT.DEFFEERATE/100 END FEEACR,
                         CASE WHEN OD.TAXSELLAMT >0 THEN OD.TAXSELLAMT ELSE OD.EXECAMT*TO_NUMBER(SYS.VARVALUE)/100 END TAXSELLAMT
                         FROM VW_ODMAST_ALL OD, SYSVAR SYS, ODTYPE ODT
                          WHERE INSTR(OD.EXECTYPE,'S')>0 AND OD.EXECAMT >0
                             AND OD.ACTYPE = ODT.ACTYPE
                             AND SYS.GRNAME = 'SYSTEM' AND SYS.VARNAME = 'ADVSELLDUTY'
                    ) OD
                WHERE STS.ORGORDERID = OD.ORDERID
                    AND STS.DUETYPE = 'RM' AND STS.DELTD = 'N'
                    AND STS.AFACCTNO LIKE V_AFACCTNO
            ) STS
            GROUP BY STS.TXDATE, STS.AFACCTNO, STS.CLEARDAY, STS.CLEARCD, STS.CLEARDATE
        ) STS
        INNER JOIN
            VW_ADSCHD_ALL AD
        ON AD.ACCTNO = STS.AFACCTNO AND AD.ODDATE = STS.TXDATE AND AD.CLEARDT = STS.CLEARDATE
            AND AD.STATUS||AD.DELTD LIKE V_STATUS
            AND AD.TXNUM LIKE V_ADVPLACE
            AND AD.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
            AND AD.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
        INNER JOIN
            ALLCODE A1
        ON A1.CDTYPE = 'AD' AND A1.CDNAME = 'ADSTATUS' AND A1.CDVAL = AD.STATUS||AD.DELTD
        INNER JOIN
            ALLCODE A2
        ON A2.CDTYPE = 'SA' AND A2.CDNAME = 'VIA' AND A2.CDVAL = DECODE(SUBSTR(AD.TXNUM,1,2),systemnums.C_OL_PREFIXED,'O','F')
        INNER JOIN
            VW_CITRAN_GEN CI
        ON AD.TXDATE = CI.TXDATE AND AD.TXNUM = CI.TXNUM AND CI.TXCD = '0012'
        ORDER BY AD.ODDATE DESC, CI.TLLOG_AUTOID DESC, substr(AD.TXNUM,5,6) DESC;

EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GetAdvancedPayment');
END pr_GetAdvancedPayment;


---------------------------------------------------------------
-- Ham thuc hien cap han muc bao lanh tren man hinh MG
-- Dau vao: - p_custodycd: So TK luu ky
--          - p_afacctno: So tieu khoan
--          - p_amount: Han muc cap
--          - p_userid: Ma NSD
--          - p_desc: Mo ta GD
-- Dau ra:  - p_err_code: Ma loi tra ve. =0: thanh cong. <>0: Loi
--          - p_err_message: thong bao loi neu ma loi <>0
-- Created by: TheNN     Date: 29-Jan-2011
---------------------------------------------------------------
PROCEDURE pr_Allocate_Guarantee_BD
    (   p_custodycd VARCHAR,
        p_afacctno varchar,
        p_amount  number,
        p_userid    varchar,
        p_desc varchar2,
        p_err_code  OUT varchar2,
        p_err_message  OUT varchar2
    )
    IS
        l_txmsg         tx.msg_rectype;
        v_strCURRDATE   varchar2(20);
        l_err_param     varchar2(300);

    BEGIN
        plog.setbeginsection(pkgctx, 'pr_Allocate_Guarantee_BD');

        -- Check host & branch active or inactive
        p_err_code := fn_CheckActiveSystem;
        IF p_err_code <> systemnums.C_SUCCESS THEN
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_Allocate_Guarantee_BD');
            return;
        END IF;
        -- End: Check host & branch active or inactive

        SELECT TO_CHAR(getcurrdate)
                   INTO v_strCURRDATE
        FROM DUAL;
        l_txmsg.msgtype     :='T';
        l_txmsg.local       :='N';
        l_txmsg.tlid        := p_userid;
        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                 SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
          INTO l_txmsg.wsname, l_txmsg.ipaddress
        FROM DUAL;
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txcompleted;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'INT';
        l_txmsg.txdate      :=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.busdate     :=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.tltxcd      :='1812';

        --Set txnum
        SELECT systemnums.C_OL_PREFIXED
                         || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                  INTO l_txmsg.txnum
                  FROM DUAL;
        l_txmsg.brid        := substr(p_afacctno,1,4);

        --Set cac field giao dich
        --88   CUSTODYCD      C
        l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
        l_txmsg.txfields ('88').TYPE      := 'C';
        l_txmsg.txfields ('88').VALUE     := p_custodycd;
        --02   USERTYPE      C
        l_txmsg.txfields ('02').defname   := 'USERTYPE';
        l_txmsg.txfields ('02').TYPE      := 'C';
        l_txmsg.txfields ('02').VALUE     := 'Flex'; -- De mac dinh la Flex
        --01   USERID      C
        l_txmsg.txfields ('01').defname   := 'USERID';
        l_txmsg.txfields ('01').TYPE      := 'C';
        l_txmsg.txfields ('01').VALUE     := p_userid;
         --03   ACCTNO      C
        l_txmsg.txfields ('03').defname   := 'ACCTNO';
        l_txmsg.txfields ('03').TYPE      := 'C';
        l_txmsg.txfields ('03').VALUE     := p_afacctno;
        --10   TOAMT        N
        l_txmsg.txfields ('10').defname   := 'TOAMT';
        l_txmsg.txfields ('10').TYPE      := 'N';
        l_txmsg.txfields ('10').VALUE     := p_amount;
        --30   DESC    C
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').VALUE     := p_desc;

        BEGIN
            IF txpks_#1812.fn_autotxprocess (l_txmsg,
                                          p_err_code,
                                          l_err_param
                ) <> systemnums.c_success
            THEN
                plog.debug (pkgctx,
                            'got error 1812: ' || p_err_code
                );
                ROLLBACK;
                p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
                plog.error(pkgctx, 'Error:'  || p_err_message);
                plog.setendsection(pkgctx, 'pr_Allocate_Guarantee_BD');
                RETURN;
            END IF;
        END;
        p_err_code:=0;
        plog.setendsection(pkgctx, 'pr_Allocate_Guarantee_BD');
    EXCEPTION
        WHEN OTHERS
        THEN
             plog.debug (pkgctx,'got error on pr_Allocate_Guarantee_BD');
             ROLLBACK;
             p_err_code := errnums.C_SYSTEM_ERROR;
             plog.error (pkgctx, SQLERRM);
             plog.setendsection (pkgctx, 'pr_Allocate_Guarantee_BD');
             RAISE errnums.E_SYSTEM_ERROR;
    END pr_Allocate_Guarantee_BD;

-- LAY THONG TIN TY LE KY QUY
PROCEDURE pr_GetSecureRatio
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2,
     SYMBOL         IN  VARCHAR2,
     EXECTYPE       IN  VARCHAR2,
     PRICETYPE      IN  VARCHAR2,
     TIMETYPE       IN  VARCHAR2,
     QUOTEPRICE     IN  NUMBER,
     ORDERQTTY      IN  NUMBER,
     VIA            IN  VARCHAR2 DEFAULT 'F'
    )
IS

    V_AFACCTNO        VARCHAR2(10);
    V_SYMBOL          VARCHAR2(50);
    V_EXECTYPE        VARCHAR(10);
    V_PRICETYPE       VARCHAR(10);
    V_TIMETYPE        VARCHAR(10);
    V_AFTYPE          VARCHAR(4);
    V_TRADEPLACE      VARCHAR(3);
    V_SECTYPE         VARCHAR(3);
    V_CODEID          VARCHAR(6);
    V_MARGINTYPE      VARCHAR(1);
    V_AFBRATIO        NUMBER;
    V_TYPEBRATIO      NUMBER;
    V_FEEAMOUNTMIN    NUMBER;
    V_FEESECURERATIOMIN   NUMBER;
    V_FEERATE         NUMBER;
    V_SECURERATIO     NUMBER;
    V_QUOTEPRICE      NUMBER;
    V_ORDERQTTY       NUMBER;
    V_SECUREDRATIOMIN NUMBER;
    V_SECUREDRATIOMAX NUMBER;
    V_VATRATE         NUMBER;
    V_MAXFEERATE      NUMBER;
    V_FEERATIO        NUMBER;
    V_ACTYPE        VARCHAR2(10);
    V_VIA           VARCHAR2(1);
    V_ROLE          NUMBER;

BEGIN
    V_AFACCTNO := AFACCTNO;
    V_SYMBOL := SYMBOL;
    V_EXECTYPE := EXECTYPE;
    V_PRICETYPE := PRICETYPE;
    V_TIMETYPE := TIMETYPE;
    V_QUOTEPRICE := QUOTEPRICE;
    V_ORDERQTTY := ORDERQTTY;
    IF VIA IS NULL THEN
        V_VIA := 'F';
    ELSE
        V_VIA := VIA;
    END IF;

    -- LAY THONG TIN NHA DAU TU
    select COUNT(rolecd)
    INTO V_ROLE
    from cfmast cf, afmast af, issuer_member im, issuers iss, allcode ac
    where cf.custid=af.custid
    and af.acctno=V_AFACCTNO
    and im.custid=cf.custid
    and im.issuerid=iss.issuerid
    and iss.shortname=V_SYMBOL
    and ac.cdname='ROLECD' AND AC.CDTYPE='SA' AND AC.CDVAL=IM.ROLECD;

    -- LAY THONG TIN CHUNG KHOAN
    SELECT SE.TRADEPLACE, SE.SECTYPE, SE.CODEID, SIF.securedratiomin, SIF.securedratiomax
    INTO V_TRADEPLACE, V_SECTYPE, V_CODEID, V_SECUREDRATIOMIN, V_SECUREDRATIOMAX
    FROM SBSECURITIES SE, SECURITIES_INFO SIF
    WHERE SE.CODEID = SIF.CODEID AND SE.SYMBOL = V_SYMBOL;

    -- LAY THONG TIN TIEU KHOAN
    SELECT MST.ACTYPE,MRT.MRTYPE, MST.BRATIO
    INTO V_AFTYPE, V_MARGINTYPE, V_AFBRATIO
    FROM AFMAST MST, AFTYPE AFT, MRTYPE MRT
    WHERE MST.ACCTNO= V_AFACCTNO
    and mst.actype =aft.actype and aft.mrtype = mrt.actype;
    --- Lay ty le thue TNCN
  --  If V_EXECTYPE in ('NS','AS','MS') then
        Begin
            select decode(aft.vat,'Y',to_number(s.varvalue),0) into  V_VATRATE
            from sysvar s, afmast a, aftype aft
            where s.varname like 'ADVSELLDUTY'
            and a.actype=aft.actype
            and a.acctno = V_AFACCTNO;
       exception
            when others then
            V_VATRATE:=0;
        End;
    --Else
     --   V_VATRATE:=0;
   -- End if;

    -- LAY THONG TIN DE TINH TY LE KY QUY
    SELECT ACTYPE,bratio, minfeeamt, deffeerate
    INTO V_ACTYPE, V_TYPEBRATIO,
        V_FEEAMOUNTMIN,
        V_FEERATE

    FROM (SELECT a.actype, a.clearday, a.bratio, a.minfeeamt, a.deffeerate, b.ODRNUM
    FROM odtype a, afidtype b
    WHERE a.status = 'Y'
         AND (a.via = V_VIA OR a.via = 'A') --VIA
         AND a.clearcd = 'B'       --CLEARCD
         AND (a.exectype = V_EXECTYPE           --l_build_msg.fld22
              OR a.exectype = 'AA')                    --EXECTYPE
         AND (a.timetype = V_TIMETYPE
              OR a.timetype = 'A')                     --TIMETYPE
         AND (a.pricetype = V_PRICETYPE
              OR a.pricetype = 'AA')                  --PRICETYPE
         AND (a.matchtype = 'N'
              OR a.matchtype = 'A')                   --MATCHTYPE
         AND (a.tradeplace = V_TRADEPLACE
              OR a.tradeplace = '000')
         AND (instr(case when V_SECTYPE in ('001','002','011') then V_SECTYPE || ',' || '111,333'
                        when V_SECTYPE in ('003','006') then V_SECTYPE || ',' || '222,333,444'
                        when V_SECTYPE in ('008') then V_SECTYPE || ',' || '111,444'
                        else V_SECTYPE end, a.sectype)>0 OR a.sectype = '000')
         AND (a.nork = 'A') --NORK
         AND (CASE WHEN A.CODEID IS NULL THEN V_CODEID ELSE A.CODEID END)= V_CODEID
         AND a.actype = b.actype and b.aftype = V_AFTYPE and b.objname='OD.ODTYPE'
    --order by b.odrnum DESC, A.deffeerate DESC
    --ORDER BY a.deffeerate DESC, B.ACTYPE DESC -- Lay gia tri ky quy lon nhat
    --ORDER BY a.deffeerate, B.ACTYPE DESC -- Lay gia tri ky quy nho nhat
    ORDER BY CASE WHEN (SELECT VARVALUE FROM SYSVAR WHERE GRNAME = 'SYSTEM' AND VARNAME = 'ORDER_ORD') = 'ODRNUM' THEN ODRNUM ELSE DEFFEERATE END ASC -- lay theo ordnum cua afidtype
    ) where rownum<=1;

    -- TINH TY LE KY QUY
    if V_MARGINTYPE='S' or V_MARGINTYPE='T' or V_MARGINTYPE='N' then
        --Tai khoan margin va tai khoan binh thuong ky quy 100%
        V_SECURERATIO:=100;
    elsif V_MARGINTYPE='L' then --Cho tai khoan margin loan
        begin
            select (case when nvl(dfprice,0)>0 then least(nvl(dfrate,0),round(nvl(dfprice,0)/ V_QUOTEPRICE/1000 * 100,4)) else nvl(dfrate,0) end ) dfrate
            into V_SECURERATIO
            from (select * from dfbasket where symbol = V_SYMBOL) bk, aftype aft, dftype dft, afmast af
            where af.actype = aft.actype and aft.dftype = dft.actype and dft.basketid = bk.basketid (+)
            and af.acctno = V_AFACCTNO;
            V_SECURERATIO:=greatest (100-V_SECURERATIO,0);
        exception
            when others then
                V_SECURERATIO:=100;
        end;
    else
        V_SECURERATIO := GREATEST (LEAST (V_TYPEBRATIO + V_AFBRATIO, 100), V_SECUREDRATIOMIN);
        V_SECURERATIO := CASE WHEN V_SECURERATIO > V_SECUREDRATIOMAX
                                THEN V_SECUREDRATIOMIN
                                ELSE V_SECURERATIO END;
    end if;
    IF V_ORDERQTTY>0 AND V_QUOTEPRICE>0 THEN
            V_FEESECURERATIOMIN := V_FEEAMOUNTMIN * 100
                                    / (TO_NUMBER(V_ORDERQTTY)         --quantity
                                    * TO_NUMBER(V_QUOTEPRICE)       --quoteprice
                                    * 1000);      --tradeunit
    END IF;
    IF V_FEESECURERATIOMIN > V_FEERATE
    THEN
        V_SECURERATIO := V_SECURERATIO + V_FEESECURERATIOMIN;
        V_FEERATIO := V_FEESECURERATIOMIN;
    ELSE
        V_SECURERATIO := V_SECURERATIO + V_FEERATE;
        V_FEERATIO := V_FEERATE;
    END IF;

    V_MAXFEERATE := GREATEST(V_FEERATE, V_FEESECURERATIOMIN, V_AFBRATIO);

    OPEN p_REFCURSOR FOR
        SELECT V_AFACCTNO AFACCTNO, V_SECURERATIO SECURERATIO, V_VATRATE VATRATE, V_MAXFEERATE MAXFEERATE, V_FEERATIO FEERATIO, V_ROLE ROLECOUNT
        FROM DUAL;

EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GetSecureRatio');
END pr_GetSecureRatio;

---------------------------------------------------------------
-- Ham thuc hien cap nhat thong tin khach hang tren OnlineTrading
-- Dau vao: - p_custodycd: So TK luu ky
--          - p_custid: Ma khach hang
--          - p_address: Dia chi thay doi
--          - p_phone: Dien thoai thay doi
--          - p_coaddress: Dia chi cong ty thay doi
--          - p_cophone: Dien thoai cong ty thay doi
--          - p_email: Email thay doi
--          - p_desc: Mo ta. Neu ko co thi de trong
-- Dau ra:  - p_err_code: Ma loi tra ve. =0: thanh cong. <>0: Loi
--          - p_err_message: thong bao loi neu ma loi <>0
-- Created by: TheNN     Date: 31-Jan-2012
---------------------------------------------------------------
PROCEDURE pr_OnlineUpdateCustomerInfor
    (   p_custodycd VARCHAR,
        p_custid varchar,
        p_address   VARCHAR2,
        p_phone     VARCHAR2,
        p_coaddress    VARCHAR2,
        p_cophone  VARCHAR2,
        p_email     VARCHAR2,
        p_desc varchar2,
        p_err_code  OUT varchar2,
        p_err_message  OUT varchar2
    )
    IS
        l_txmsg         tx.msg_rectype;
        v_strCURRDATE   varchar2(20);
        l_err_param     varchar2(300);
        v_mobile        varchar(50);
        v_desc          varchar2(200);
        v_count         number; --1.5.8.2

    BEGIN
        plog.setbeginsection(pkgctx, 'pr_OnlineUpdateCustomerInfor');

        -- Check host & branch active or inactive
        p_err_code := fn_CheckActiveSystem;
        IF p_err_code <> systemnums.C_SUCCESS THEN
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_OnlineUpdateCustomerInfor');
            return;
        END IF;
        -- End: Check host & branch active or inactive
        -- 1.5.8.2
        select count(1) into v_count  from cfmast c where nvl(c.email, 'x') = nvl(p_email, 'x') and c.custodycd = p_custodycd;
        IF v_count = 0 THEN
            p_err_code := '-200501';
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_OnlineUpdateCustomerInfor');
            return;
        END IF;
        -- end 1.5.8.2

        SELECT TO_CHAR(getcurrdate)
                   INTO v_strCURRDATE
        FROM DUAL;
        l_txmsg.msgtype     :='T';
        l_txmsg.local       :='N';
        l_txmsg.tlid        := systemnums.C_ONLINE_USERID;
        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                 SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
          INTO l_txmsg.wsname, l_txmsg.ipaddress
        FROM DUAL;
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txcompleted;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'INT';
        l_txmsg.txdate      :=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.busdate     :=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.tltxcd      :='0099';

        --Set txnum
        SELECT systemnums.C_OL_PREFIXED
                         || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                  INTO l_txmsg.txnum
                  FROM DUAL;
        l_txmsg.brid        := substr(p_custid,1,4);

        --Set cac field giao dich
        SELECT MOBILE
        INTO v_mobile
        FROM CFMAST
        WHERE CUSTID = p_custid;
        IF length(p_desc) =0 THEN
            SELECT TXDESC INTO v_desc FROM TLTX WHERE TLTXCD = '0099';
        ELSE
            v_desc := p_desc;
        END IF;

        --03   CUSTID      C
        l_txmsg.txfields ('03').defname   := 'CUSTID';
        l_txmsg.txfields ('03').TYPE      := 'C';
        l_txmsg.txfields ('03').VALUE     := p_custid;
        --04   CUSTODYCD      C
        l_txmsg.txfields ('04').defname   := 'CUSTODYCD';
        l_txmsg.txfields ('04').TYPE      := 'C';
        l_txmsg.txfields ('04').VALUE     := p_custodycd;
        --20   ADDRESS      C
        l_txmsg.txfields ('20').defname   := 'ADDRESS';
        l_txmsg.txfields ('20').TYPE      := 'C';
        l_txmsg.txfields ('20').VALUE     := p_address;
        --21   PHONE      C
        l_txmsg.txfields ('21').defname   := 'PHONE';
        l_txmsg.txfields ('21').TYPE      := 'C';
        l_txmsg.txfields ('21').VALUE     := p_phone;
        --22   MOBILE      C
        l_txmsg.txfields ('22').defname   := 'MOBILE';
        l_txmsg.txfields ('22').TYPE      := 'C';
        l_txmsg.txfields ('22').VALUE     := v_mobile;
        --23   COADDRESS      C
        l_txmsg.txfields ('23').defname   := 'COADDRESS';
        l_txmsg.txfields ('23').TYPE      := 'C';
        l_txmsg.txfields ('23').VALUE     := p_coaddress;
        --24   COPHONE      C
        l_txmsg.txfields ('24').defname   := 'COPHONE';
        l_txmsg.txfields ('24').TYPE      := 'C';
        l_txmsg.txfields ('24').VALUE     := p_cophone;
        --25   EMAIL      C
        l_txmsg.txfields ('25').defname   := 'EMAIL';
        l_txmsg.txfields ('25').TYPE      := 'C';
        l_txmsg.txfields ('25').VALUE     := p_email;
        --30   DESC    C
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').VALUE     := v_desc;

        BEGIN
            IF txpks_#0099.fn_autotxprocess (l_txmsg,
                                          p_err_code,
                                          l_err_param
                ) <> systemnums.c_success
            THEN
                plog.debug (pkgctx,
                            'got error 1812: ' || p_err_code
                );
                ROLLBACK;
                p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
                plog.error(pkgctx, 'Error:'  || p_err_message);
                plog.setendsection(pkgctx, 'pr_OnlineUpdateCustomerInfor');
                RETURN;
            END IF;
        END;
        p_err_code:=0;
        plog.setendsection(pkgctx, 'pr_OnlineUpdateCustomerInfor');
    EXCEPTION
        WHEN OTHERS
        THEN
             plog.debug (pkgctx,'got error on pr_OnlineUpdateCustomerInfor');
             ROLLBACK;
             p_err_code := errnums.C_SYSTEM_ERROR;
             plog.error (pkgctx, SQLERRM);
             plog.setendsection (pkgctx, 'pr_OnlineUpdateCustomerInfor');
             RAISE errnums.E_SYSTEM_ERROR;
    END pr_OnlineUpdateCustomerInfor;


---------------------------------------------------------------
-- Ham thuc hien cap nhat thong tin khach hang tren OnlineTrading
-- Dau vao: - p_afacctno: Ma tieu khoan
--          - p_BENEFCUSTNAME: Ten nguoi thu huong
--          - p_RECEIVLICENSE: CMND nguoi thu huong
--          - p_RECEIVIDDATE: Ngay cap
--          - p_RECEIVIDPLACE: Noi cap
--          - p_BANKNAME: Ten ngan hang chuyen den
--          - p_CITYBANK: Chi nhanh
--          - p_CITYEF: Tinh/ thanh pho
--          - p_AMT: So tien chuyen khoan
--          - p_desc: Mo ta. Neu ko co thi de trong
-- Dau ra:  - p_err_code: Ma loi tra ve. =0: thanh cong. <>0: Loi
--          - p_err_message: thong bao loi neu ma loi <>0
-- Created by: TheNN     Date: 01-Feb-2012
---------------------------------------------------------------
PROCEDURE pr_CashTransferWithIDCode
    (   p_afacctno varchar,
        p_BENEFCUSTNAME   VARCHAR2,
        p_RECEIVLICENSE     VARCHAR2,
        p_RECEIVIDDATE    VARCHAR2,
        p_RECEIVIDPLACE  VARCHAR2,
        p_BANKNAME     VARCHAR2,
        p_CITYBANK     VARCHAR2,
        p_CITYEF     VARCHAR2,
        p_AMT           NUMBER,
        p_desc varchar2,
        p_err_code  OUT varchar2,
        p_err_message  OUT varchar2
    )
    IS
        l_txmsg         tx.msg_rectype;
        v_strCURRDATE   varchar2(20);
        l_err_param     varchar2(300);
        v_CUSTNAME      varchar2(100);
        v_FULLNAME      varchar2(200);
        v_ADDRESS       varchar2(250);
        v_LICENSE       varchar2(50);
        v_IDDATE        varchar2(20);
        v_IDPLACE       varchar2(200);
        v_CASHBAL       NUMBER;
        v_FEEAMT        NUMBER;
        v_VATAMT        NUMBER;
        v_TRFAMT        NUMBER;
        v_CUSTODYCD     VARCHAR2(10);

        p_trfcount      number;

    BEGIN
        plog.setbeginsection(pkgctx, 'pr_CashTransferWithIDCode');

        -- Check host & branch active or inactive
        p_err_code := fn_CheckActiveSystem;
        IF p_err_code <> systemnums.C_SUCCESS THEN
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_CashTransferWithIDCode');
            return;
        END IF;
        -- End: Check host & branch active or inactive

        --Them buoc chan theo quy dinh chong rua tien
        --Doi voi giao dich qua kenh giao dich truc tuyen
        --Kiem tra so tien chuyen khoan toi da
        begin
            if to_number(cspks_system.fn_get_sysvar('SYSTEM','ONLINEMAXTRF1133_AMT')) < p_AMT then
                p_err_code:='-100133';
                p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
                plog.error(pkgctx, 'Error:'  || p_err_message);
                plog.setendsection(pkgctx, 'pr_ExternalTransfer');
                return;
            end if;
        exception when others then
            plog.error(pkgctx, 'Error: Chua khai bao han muc chuyen khoan tien toi da qua kenh Online');
        end;
        --Kiem tra so lan chuyen khoan toi da
        begin
            select count(1) into p_trfcount from tllog where tltxcd ='1133' and tlid =systemnums.C_ONLINE_USERID and deltd <> 'Y' and txstatus ='1' and msgacct=p_afacctno;

            if to_number(cspks_system.fn_get_sysvar('SYSTEM','ONLINEMAXTRF1133_CNT')) <= p_trfcount then
                p_err_code:='-100134';
                p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
                plog.error(pkgctx, 'Error:'  || p_err_message);
                plog.setendsection(pkgctx, 'pr_ExternalTransfer');
                return;
            end if;
        exception when others then
            plog.error(pkgctx, 'Error: Chua khai bao so lan chuyen khoan toi da trong mot ngay qua kenh Online');
        end;


        SELECT TO_CHAR(getcurrdate)
                   INTO v_strCURRDATE
        FROM DUAL;
        l_txmsg.msgtype     :='T';
        l_txmsg.local       :='N';
        l_txmsg.tlid        := systemnums.C_ONLINE_USERID;
        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                 SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
          INTO l_txmsg.wsname, l_txmsg.ipaddress
        FROM DUAL;
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txcompleted;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'INT';
        l_txmsg.txdate      :=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.busdate     :=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.tltxcd      :='1133';

        --Set txnum
        SELECT systemnums.C_OL_PREFIXED
                         || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                  INTO l_txmsg.txnum
                  FROM DUAL;
        l_txmsg.brid        := substr(p_afacctno,1,4);

        -- Lay thong tin de thuc hien GD
        -- Lay thong tin khach hang
        SELECT CF.custodycd, CF.fullname, CF.fullname, CF.address, CF.idcode, TO_CHAR(CF.iddate,'DD/MM/YYYY'), CF.idplace, getbaldefovd(p_afacctno)
        INTO v_CUSTODYCD, v_CUSTNAME, v_FULLNAME, v_ADDRESS, v_LICENSE, v_IDDATE, v_IDPLACE, v_CASHBAL
        FROM CFMAST CF, AFMAST AF
        WHERE CF.CUSTID = AF.CUSTID AND AF.ACCTNO = p_afacctno;

        -- Lay thong tin phi, bieu phi, thue
        -- Tam thoi de phi, thue = 0
        v_FEEAMT := 0;
        v_VATAMT := 0;
        v_TRFAMT := p_AMT + v_FEEAMT + v_VATAMT;

        -- Kiem tra so tien chuyen khoan
        IF v_TRFAMT > v_CASHBAL THEN
            p_err_code := ERRNUMS.c_CI_CIMAST_BALANCE_NOTENOUGHT;
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_CashTransferWithIDCode');
            RETURN;
        END IF;

        --Set cac field giao dich

        --88   CUSTODYCD      C
        l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
        l_txmsg.txfields ('88').TYPE      := 'C';
        l_txmsg.txfields ('88').VALUE     := v_CUSTODYCD;
        --03   ACCTNO      C
        l_txmsg.txfields ('03').defname   := 'ACCTNO';
        l_txmsg.txfields ('03').TYPE      := 'C';
        l_txmsg.txfields ('03').VALUE     := p_afacctno;
        --90   CUSTNAME      C
        --l_txmsg.txfields ('90').defname   := 'CUSTNAME';
        --l_txmsg.txfields ('90').TYPE      := 'C';
        --l_txmsg.txfields ('90').VALUE     := v_CUSTNAME;
        --64   FULLNAME      C
        l_txmsg.txfields ('64').defname   := 'FULLNAME';
        l_txmsg.txfields ('64').TYPE      := 'C';
        l_txmsg.txfields ('64').VALUE     := v_FULLNAME;
        --65   ADDRESS      C
        l_txmsg.txfields ('65').defname   := 'ADDRESS';
        l_txmsg.txfields ('65').TYPE      := 'C';
        l_txmsg.txfields ('65').VALUE     := v_ADDRESS;
        --69   LICENSE      C
        l_txmsg.txfields ('69').defname   := 'LICENSE';
        l_txmsg.txfields ('69').TYPE      := 'C';
        l_txmsg.txfields ('69').VALUE     := v_LICENSE;
        --67   IDDATE      C
        l_txmsg.txfields ('67').defname   := 'IDDATE';
        l_txmsg.txfields ('67').TYPE      := 'C';
        l_txmsg.txfields ('67').VALUE     := v_IDDATE;
        --68   IDPLACE      C
        l_txmsg.txfields ('68').defname   := 'IDPLACE';
        l_txmsg.txfields ('68').TYPE      := 'C';
        l_txmsg.txfields ('68').VALUE     := v_IDPLACE;
        --89   CASTBAL      N
        l_txmsg.txfields ('89').defname   := 'CASTBAL';
        l_txmsg.txfields ('89').TYPE      := 'N';
        l_txmsg.txfields ('89').VALUE     := v_CASHBAL;
        --82   BENEFCUSTNAME      C
        l_txmsg.txfields ('82').defname   := 'BENEFCUSTNAME';
        l_txmsg.txfields ('82').TYPE      := 'C';
        l_txmsg.txfields ('82').VALUE     := p_BENEFCUSTNAME;
        --83   RECEIVLICENSE      C
        l_txmsg.txfields ('83').defname   := 'RECEIVLICENSE';
        l_txmsg.txfields ('83').TYPE      := 'C';
        l_txmsg.txfields ('83').VALUE     := p_RECEIVLICENSE;
        --95   RECEIVIDDATE      C
        l_txmsg.txfields ('95').defname   := 'RECEIVIDDATE';
        l_txmsg.txfields ('95').TYPE      := 'C';
        l_txmsg.txfields ('95').VALUE     := p_RECEIVIDDATE;
        --96   RECEIVIDPLACE      C
        l_txmsg.txfields ('96').defname   := 'RECEIVIDPLACE';
        l_txmsg.txfields ('96').TYPE      := 'C';
        l_txmsg.txfields ('96').VALUE     := p_RECEIVIDPLACE;
        --05   BANKID      C
        l_txmsg.txfields ('05').defname   := 'BANKID';
        l_txmsg.txfields ('05').TYPE      := 'C';
        l_txmsg.txfields ('05').VALUE     := '';
        --80   BANKNAME      C
        --l_txmsg.txfields ('80').defname   := 'BANKNAME';
        --l_txmsg.txfields ('80').TYPE      := 'C';
        --l_txmsg.txfields ('80').VALUE     := p_BANKNAME;
        --81   BENEFBANK      C
        l_txmsg.txfields ('81').defname   := 'BENEFBANK';
        l_txmsg.txfields ('81').TYPE      := 'C';
        l_txmsg.txfields ('81').VALUE     := p_BANKNAME;
        --84   CITYBANK      C
        l_txmsg.txfields ('84').defname   := 'CITYBANK';
        l_txmsg.txfields ('84').TYPE      := 'C';
        l_txmsg.txfields ('84').VALUE     := p_CITYBANK;
        --85   CITYEF      C
        l_txmsg.txfields ('85').defname   := 'CITYEF';
        l_txmsg.txfields ('85').TYPE      := 'C';
        l_txmsg.txfields ('85').VALUE     := p_CITYEF;
        --09   IORO      C
        l_txmsg.txfields ('09').defname   := 'IORO';
        l_txmsg.txfields ('09').TYPE      := 'C';
        l_txmsg.txfields ('09').VALUE     := '0';
        --66   $FEECD      C
        l_txmsg.txfields ('66').defname   := '$FEECD';
        l_txmsg.txfields ('66').TYPE      := 'C';
        l_txmsg.txfields ('66').VALUE     := '';
        --10   AMT      N
        l_txmsg.txfields ('10').defname   := 'AMT';
        l_txmsg.txfields ('10').TYPE      := 'N';
        l_txmsg.txfields ('10').VALUE     := p_AMT;
        --11   FEEAMT      N
        l_txmsg.txfields ('11').defname   := 'FEEAMT';
        l_txmsg.txfields ('11').TYPE      := 'N';
        l_txmsg.txfields ('11').VALUE     := v_FEEAMT;
        --12   VATAMT      N
        l_txmsg.txfields ('12').defname   := 'VATAMT';
        l_txmsg.txfields ('12').TYPE      := 'N';
        l_txmsg.txfields ('12').VALUE     := v_VATAMT;
        --13   TRFAMT      N
        l_txmsg.txfields ('13').defname   := 'TRFAMT';
        l_txmsg.txfields ('13').TYPE      := 'N';
        l_txmsg.txfields ('13').VALUE     := v_TRFAMT;
        --30   DESC    C
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').VALUE     := UTF8NUMS.c_const_TXDESC_1133_OL || '/ ' || v_FULLNAME || '/ ' || v_CUSTODYCD;

        BEGIN
            IF txpks_#1133.fn_autotxprocess (l_txmsg,
                                          p_err_code,
                                          l_err_param
                ) <> systemnums.c_success
            THEN
                plog.debug (pkgctx,
                            'got error 1812: ' || p_err_code
                );
                ROLLBACK;
                p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
                plog.error(pkgctx, 'Error:'  || p_err_message);
                plog.setendsection(pkgctx, 'pr_CashTransferWithIDCode');
                RETURN;
            END IF;
        END;
        p_err_code:=0;
        plog.setendsection(pkgctx, 'pr_CashTransferWithIDCode');
    EXCEPTION
        WHEN OTHERS
        THEN
             plog.debug (pkgctx,'got error on pr_CashTransferWithIDCode');
             ROLLBACK;
             p_err_code := errnums.C_SYSTEM_ERROR;
             plog.error (pkgctx, SQLERRM);
             plog.setendsection (pkgctx, 'pr_CashTransferWithIDCode');
             RAISE errnums.E_SYSTEM_ERROR;
    END pr_CashTransferWithIDCode;

-- LAY THONG TIN LOAI HINH LENH
FUNCTION fn_GetODACTYPE
    (AFACCTNO       IN  VARCHAR2,
     SYMBOL         IN  VARCHAR2,
     CODEID         IN  VARCHAR2,
     TRADEPLACE     IN  VARCHAR2,
     EXECTYPE       IN  VARCHAR2,
     PRICETYPE      IN  VARCHAR2,
     TIMETYPE       IN  VARCHAR2,
     AFTYPE         IN  VARCHAR2,
     SECTYPE        IN  VARCHAR2,
     VIA            IN  VARCHAR2
    ) RETURN VARCHAR2
AS

    V_AFACCTNO        VARCHAR2(10);
    V_SYMBOL          VARCHAR2(50);
    V_EXECTYPE        VARCHAR(10);
    V_PRICETYPE       VARCHAR(10);
    V_TIMETYPE        VARCHAR(10);
    V_AFTYPE          VARCHAR(4);
    V_TRADEPLACE      VARCHAR(3);
    V_ODACTYPE          VARCHAR2(4);
    V_SECTYPE         VARCHAR(3);
    V_CODEID          VARCHAR(6);
    V_VIA             VARCHAR2(1);

BEGIN
    V_AFACCTNO := AFACCTNO;
    V_SYMBOL := SYMBOL;
    V_EXECTYPE := EXECTYPE;
    V_PRICETYPE := PRICETYPE;
    V_TIMETYPE := TIMETYPE;
    V_AFTYPE := AFTYPE;
    V_TRADEPLACE := TRADEPLACE;
    V_SECTYPE := SECTYPE;
    V_CODEID := CODEID;
    V_VIA := VIA;

    -- LAY THONG TIN LOAI HINH LENH
    SELECT actype
    INTO V_ODACTYPE
    FROM (SELECT a.actype, a.clearday, a.bratio, a.minfeeamt, a.deffeerate, b.ODRNUM, A.VATRATE
    FROM odtype a, afidtype b
    WHERE a.status = 'Y'
         AND (a.via = V_VIA OR a.via = 'A') --VIA
         AND a.clearcd = 'B'       --CLEARCD
         AND (a.exectype = V_EXECTYPE           --l_build_msg.fld22
              OR a.exectype = 'AA')                    --EXECTYPE
         AND (a.timetype = V_TIMETYPE
              OR a.timetype = 'A')                     --TIMETYPE
         AND (a.pricetype = V_PRICETYPE
              OR a.pricetype = 'AA')                  --PRICETYPE
         AND (a.matchtype = 'N'
              OR a.matchtype = 'A')                   --MATCHTYPE
         AND (a.tradeplace = V_TRADEPLACE
              OR a.tradeplace = '000')
         AND (instr(case when V_SECTYPE in ('001','002','011') then V_SECTYPE || ',' || '111,333'
                        when V_SECTYPE in ('003','006') then V_SECTYPE || ',' || '222,333,444'
                        when V_SECTYPE in ('008') then V_SECTYPE || ',' || '111,444'
                        else V_SECTYPE end, a.sectype)>0 OR a.sectype = '000')
         AND (a.nork = 'A') --NORK
         AND (CASE WHEN A.CODEID IS NULL THEN V_CODEID ELSE A.CODEID END)= V_CODEID
         AND a.actype = b.actype and b.aftype = V_AFTYPE and b.objname='OD.ODTYPE'
    --order by b.odrnum DESC, A.deffeerate DESC
    --ORDER BY a.deffeerate DESC, B.ACTYPE DESC -- Lay gia tri ky quy lon nhat
    --ORDER BY a.deffeerate, B.ACTYPE DESC -- Lay gia tri ky quy nho nhat
        ORDER BY CASE WHEN (SELECT VARVALUE FROM SYSVAR WHERE GRNAME = 'SYSTEM' AND VARNAME = 'ORDER_ORD') = 'ODRNUM' THEN ODRNUM ELSE DEFFEERATE END ASC -- lay theo ordnum cua afidtype
    ) where rownum<=1;

    RETURN V_ODACTYPE;
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'fn_GetODACTYPE');
    RETURN '0000';
END;

-- Lay thong tin khoan vay DF tong chua thanh toan
-- TheNN, 06-Feb-2012
PROCEDURE pr_GetGroupDFInfor
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2
     )
    IS

    V_AFACCTNO    VARCHAR2(10);
    V_CURRDATE      DATE;

BEGIN
    IF AFACCTNO = 'ALL' OR AFACCTNO IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := AFACCTNO;
    END IF;

    SELECT getcurrdate INTO V_CURRDATE FROM DUAL;

    -- LAY THONG TIN KHOAN VAY DF TONG CHUA THANH TOAN
    OPEN p_REFCURSOR FOR
        select DF.GROUPID,DFT.ISVSD,DF.LNACCTNO,CF.CUSTODYCD,DF.AFACCTNO AFACCTNO,lns.rlsdate, lns.overduedate,
            DF.ORGAMT, LNS.PAID, V.CURAMT, V.CURINT, V.CURFEE, ln.INTPAID + ln.feeintpaid INTPAID, lns.INTNMLACR, lns.INTOVD,
            lns.intnmlacr+lns.intovd+lns.feeintnmlacr+lns.feeintnmlovd tempint,
            lns.intovdprin+lns.feeintnmlovd tempintovd,
            CASE WHEN V.INTMIN+V.FEEMIN < V.CURINT+V.CURFEE
                THEN ROUND(V.CURAMT +
                     (V.CURAMT * LN.RATE1 * GREATEST (least(LN.MINTERM,LN.PRINFRQ) - TO_NUMBER(V_CURRDATE - TO_DATE(LNS.RLSDATE,'DD/MM/RRRR')),0 ) /100/360
                        + V.CURAMT * LN.RATE2 * GREATEST (GREATEST(LN.MINTERM-LN.PRINFRQ,0)-GREATEST(V_CURRDATE - TO_DATE(LNS.DUEDATE,'DD/MM/RRRR'),0 ),0) /100/360)
                    + (V.CURAMT * LN.CFRATE1 * GREATEST (least(LN.MINTERM,LN.PRINFRQ) - TO_NUMBER(V_CURRDATE - TO_DATE(LNS.RLSDATE,'DD/MM/RRRR')),0 ) /100/360
                        + V.CURAMT * LN.CFRATE2 *  GREATEST (GREATEST(LN.MINTERM-LN.PRINFRQ,0)-GREATEST(V_CURRDATE - TO_DATE(LNS.DUEDATE,'DD/MM/RRRR'),0 ),0) /100/360)
                     + V.CURINT + V.CURFEE)
                ELSE ROUND(V.CURAMT + GREATEST((V.INTMIN + V.FEEMIN), (V.CURINT + V.CURFEE))) END SUMAMT,
            DF.DESCRIPTION
        from dfgroup df,dftype dft, lnmast ln, lnschd lns, cfmast cf, afmast af,
            (
            SELECT lnacctno, CURAMT, CURINT, CURFEE, INTPAIDMETHOD, RATE1, RATE2,CFRATE1, CFRATE2, MINTERM, PRINFRQ, RLSDATE, DUEDATE,
                CASE WHEN V_CURRDATE - TO_DATE(RLSDATE,'DD/MM/RRRR') >= MINTERM THEN CURINT ELSE
                     ROUND((CURAMT * (LEAST(Minterm, PRINFRQ)*RATE1 + GREATEST ( 0 , MINTERM - PRINFRQ) * RATE2) ) /100/360) END INTMIN,
                CASE WHEN V_CURRDATE - TO_DATE(RLSDATE,'DD/MM/RRRR') >= MINTERM THEN CURFEE ELSE
                      ROUND((CURAMT *   (LEAST(Minterm, PRINFRQ)* CFRATE1 + GREATEST ( 0 , MINTERM - PRINFRQ) * CFRATE2) ) /100/360)  END FEEMIN
            FROM (
                SELECT acctno lnacctno, CURAMT, CURINT, CURFEE, INTPAIDMETHOD, RATE1, RATE2,CFRATE1, CFRATE2, LEAST(MINTERM, TO_NUMBER( TO_DATE(OVERDUEDATE,'DD/MM/RRRR') - TO_DATE(RLSDATE,'DD/MM/RRRR')) )  MINTERM, PRINFRQ, RLSDATE, DUEDATE
                FROM (
                        SELECT ln.acctno, ROUND(LNS.NML) + ROUND(LNS.OVD) CURAMT,
                                ROUND(LNS.INTNMLACR) + ROUND(LNS.intdue) + ROUND(LNS.intovd) + ROUND(LNS.intovdprin) CURINT,
                                ROUND(LNS.FEEINTNMLACR) + ROUND(LNS.FEEINTOVDACR) + ROUND(LNS.FEEINTDUE) + ROUND(LNS.FEEINTNMLOVD) CURFEE, LN.INTPAIDMETHOD,
                            LNS.RATE1, LNS.RATE2, LNS.CFRATE1, LNS.CFRATE2, LN.MINTERM, TO_DATE(lns.DUEDATE,'DD/MM/RRRR') -  TO_DATE(lns.RLSDATE,'DD/MM/RRRR') PRINFRQ, LN.RLSDATE,LNS.DUEDATE,lns.OVERDUEDATE
                            FROM (SELECT * FROM lnschd UNION SELECT * FROM lnschdhist) LNS, LNMAST LN, LNTYPE LNT
                        WHERE LN.ACCTNO=LNS.ACCTNO
                            AND LN.ACTYPE=LNT.ACTYPE
                            and REFTYPE='P'
                            and LN.TRFACCTNO LIKE V_AFACCTNO
                    )
                )
            )
            /*(SELECT V.GROUPID,V.CURAMT, V.CURINT, V.CURFEE,
                CASE WHEN V_CURRDATE - TO_DATE(RLSDATE,'DD/MM/RRRR') >= MINTERM THEN CURINT ELSE
                 ROUND((CURAMT * (LEAST(Minterm, PRINFRQ)*RATE1 + GREATEST (0, MINTERM - PRINFRQ) * RATE2)) /100/360,4) END INTMIN,
                CASE WHEN V_CURRDATE - TO_DATE(RLSDATE,'DD/MM/RRRR') >= MINTERM THEN CURFEE ELSE
                  ROUND((CURAMT * (LEAST(Minterm, PRINFRQ)* CFRATE1 + GREATEST(0, MINTERM - PRINFRQ) * CFRATE2))/100/360,4) END FEEMIN
            FROM v_getgrpdealformular v
            WHERE V.afacctno LIKE V_AFACCTNO
            )*/ v
        where df.lnacctno= ln.acctno and ln.acctno=lns.acctno and lns.reftype='P'
            and df.afacctno= af.acctno and af.custid= cf.custid
            AND DF.lnacctno=V.lnacctno
            AND LN.TRFACCTNO LIKE V_AFACCTNO
            AND DFT.ACTYPE=DF.ACTYPE
        ORDER BY LN.ACCTNO;
        /*
        select DF.GROUPID,DF.LNACCTNO,CF.CUSTODYCD,DF.AFACCTNO AFACCTNO,lns.rlsdate, lns.overduedate,
            DF.ORGAMT, LNS.PAID, V.CURAMT, V.CURINT, V.CURFEE, ln.INTPAID + ln.feeintpaid INTPAID, lns.INTNMLACR, lns.INTOVD,
            lns.intnmlacr+lns.intovd+lns.feeintnmlacr+lns.feeintnmlovd tempint,
            lns.intovdprin+lns.feeintnmlovd tempintovd,
            CASE WHEN V.INTMIN+V.FEEMIN < V.CURINT+V.CURFEE
                THEN ROUND(V.CURAMT +
                    ROUND (V.CURAMT * LN.RATE1 * GREATEST (least(LN.MINTERM,LN.PRINFRQ) - TO_NUMBER(V_CURRDATE - TO_DATE(LNS.RLSDATE,'DD/MM/RRRR')),0 ) /100/360
                        + V.CURAMT * LN.RATE2 * GREATEST (GREATEST(LN.MINTERM-LN.PRINFRQ,0)-GREATEST(V_CURRDATE - TO_DATE(LNS.DUEDATE,'DD/MM/RRRR'),0 ),0) /100/360,4)
                    + ROUND(V.CURAMT * LN.CFRATE1 * GREATEST (least(LN.MINTERM,LN.PRINFRQ) - TO_NUMBER(V_CURRDATE - TO_DATE(LNS.RLSDATE,'DD/MM/RRRR')),0 ) /100/360
                        + V.CURAMT * LN.CFRATE2 *  GREATEST (GREATEST(LN.MINTERM-LN.PRINFRQ,0)-GREATEST(V_CURRDATE - TO_DATE(LNS.DUEDATE,'DD/MM/RRRR'),0 ),0) /100/360,4)
                     + V.CURINT + V.CURFEE)
                ELSE ROUND(V.CURAMT + GREATEST((V.INTMIN + V.FEEMIN), (V.CURINT + V.CURFEE))) END SUMAMT,
            DF.DESCRIPTION
        from dfgroup df, lnmast ln, lnschd lns, cfmast cf, afmast af, v_getgrpdealformular v
        where df.lnacctno= ln.acctno and ln.acctno=lns.acctno and lns.reftype='P'
            and df.afacctno= af.acctno and af.custid= cf.custid
            AND DF.GROUPID=V.GROUPID
            AND LN.TRFACCTNO LIKE V_AFACCTNO
        ORDER BY LN.ACCTNO;*/

EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GetGroupDFInfor');
END pr_GetGroupDFInfor;


-- Lay thong tin khoan vay DF chi tiet chua thanh toan
-- TheNN, 06-Feb-2012
PROCEDURE pr_GetDetailDFInfor
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2,
     GROUPDFID      IN  VARCHAR2
     )
    IS

    V_AFACCTNO    VARCHAR2(10);
    V_GROUPDFID   VARCHAR2(50);

BEGIN
    IF AFACCTNO = 'ALL' THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := AFACCTNO;
    END IF;

    IF GROUPDFID = 'ALL' THEN
        V_GROUPDFID := '%%';
    ELSE
        V_GROUPDFID := GROUPDFID;
    END IF;

    -- LAY THONG TIN KHOAN VAY DF TONG CHUA THANH TOAN
    OPEN p_REFCURSOR FOR
        SELECT ceil(TADF-DDF*(IRATE/100)) MINAMTRLS, A.*,
            FLOOR(GREATEST(floor(least (VReleaseDF / ( DFREFPRICE * DFRATE/100), QTTY )),0) / LOT) * LOT MAXRELEASE,
            0 QTTYRELEASE, QTTY *(DFREFPRICE * DFRATE/100) AMTRELEASEALL,
            CASE WHEN A.DEALTYPE = 'N' AND A.QTTY >0 THEN 'Y' ELSE 'N' END SELLABLE
        FROM
            (
                select DF.LNACCTNO,DF.GROUPID, DF.AFACCTNO||DF.CODEID SEACCTNO, DF.ACCTNO  DFACCTNO,
                    CASE WHEN DF.DEALTYPE='T' THEN 1 ELSE df.TRADELOT END LOT, V.IRATE, V.TADF, V.DDF,
                    V.TADF - (V.IRATE*(DDF)/100 ) VReleaseDF, DF.DFRATE,
                    CASE WHEN DEALTYPE='T' THEN 1 ELSE SEC.DFREFPRICE END dfrefprice, DF.DEALTYPE, sec.symbol,
                    A1.CDCONTENT DEALTYPE_DESC,
                    CASE WHEN DF.DEALTYPE IN('N') THEN DF.DFQTTY - NVL(V1.SECUREAMT,0)
                         WHEN DF.DEALTYPE='B' THEN DF.BLOCKQTTY
                         WHEN DF.DEALTYPE='R' THEN DF.RCVQTTY
                         WHEN DF.DEALTYPE='T' THEN DF.CACASHQTTY
                         ELSE DF.CARCVQTTY END QTTY
                from v_getdealinfo DF, v_getgrpdealformular v, v_getdealsellorderinfo v1, securities_info sec, ALLCODE A1
                where DF.groupid=v.groupid AND df.codeid=sec.codeid
                    AND DF.DEALTYPE=A1.CDVAL AND A1.CDNAME='DEALTYPE' and DF.ACCTNO=V1.DFACCTNO(+)
                    AND DF.GROUPID LIKE V_GROUPDFID
                    AND DF.AFACCTNO LIKE V_AFACCTNO
            ) A
        ORDER BY A.DFACCTNO;
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GetDetailDFInfor');
END pr_GetDetailDFInfor;

-- Lay thong tin khoan vay DF tong
-- TheNN, 29-Feb-2012
PROCEDURE pr_GetGroupDFInforAll
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     pv_RowCount    IN OUT  NUMBER,
     pv_PageSize    IN  NUMBER,
     pv_PageIndex   IN  NUMBER,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2
     )
    IS

    V_AFACCTNO    VARCHAR2(10);
    v_RowCount    NUMBER;
    v_FromRow     NUMBER;
    v_ToRow       NUMBER;
    V_CURRDATE      date;

BEGIN
    IF AFACCTNO = 'ALL' OR AFACCTNO IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := AFACCTNO;
    END IF;

    SELECT getcurrdate INTO V_CURRDATE FROM dual;

    -- LAY THONG TIN TONG SO DONG DU LIEU LAY RA DE PHAN TRANG
    /*IF pv_RowCount = 0 THEN
        SELECT COUNT(1)
        INTO v_RowCount
        FROM vw_lnmast_all ln
        WHERE LN.TRFACCTNO LIKE V_AFACCTNO
            AND LN.RLSDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
            AND LN.RLSDATE <= TO_DATE(T_DATE,'DD/MM/YYYY');
        pv_RowCount := v_RowCount;
    ELSE
        v_RowCount := pv_RowCount;
    END IF;

    IF pv_PageSize >0 AND pv_PageIndex >0 THEN
        v_FromRow := pv_PageSize*(pv_PageIndex - 1) +1;
        v_ToRow := v_FromRow + pv_PageSize - 1;
    ELSE
        v_FromRow := 1;
        v_ToRow := pv_PageSize;
    END IF;*/

    -- LAY THONG TIN KHOAN VAY DF TONG CHUA THANH TOAN
    OPEN p_REFCURSOR FOR
        /*SELECT A.*
        FROM
            (
            SELECT ROWNUM ROWNUMBER, A.* FROM
                (*/
                SELECT CF.CUSTODYCD, AF.ACCTNO AFACCTNO, LN.ACCTNO LNACCTNO, DF.GROUPID GROUPID, LNS.RLSDATE, LNS.OVERDUEDATE,
                    DF.ORGAMT, LNS.PAID, LNS.NML + LNS.OVD CURAMT,
                    NVL(V.CURINT,0) CURINT, NVL(V.CURFEE,0) CURFEE,ln.INTPAID + ln.feeintpaid INTPAID, LNS.INTNMLACR, LNS.INTOVD,
                    LNS.INTNMLACR+LNS.INTOVD+LNS.FEEINTNMLACR+LNS.FEEINTNMLOVD TEMPINT,
                    LNS.INTOVDPRIN+LNS.FEEINTNMLOVD TEMPINTOVD,
                    CASE WHEN NVL(V.INTMIN,0)+NVL(V.FEEMIN,0) < NVL(V.CURINT,0)+NVL(V.CURFEE,0)
                        THEN ROUND(NVL(V.CURAMT,0) +
                            ROUND (NVL(V.CURAMT,0) * LN.RATE1 * GREATEST (least(LN.MINTERM,LN.PRINFRQ) - TO_NUMBER(V_CURRDATE - TO_DATE(LNS.RLSDATE,'DD/MM/RRRR')),0 ) /100/360
                                + nvl(V.CURAMT,0) * LN.RATE2 * GREATEST (GREATEST(LN.MINTERM-LN.PRINFRQ,0)-GREATEST(V_CURRDATE - TO_DATE(LNS.DUEDATE,'DD/MM/RRRR'),0 ),0) /100/360,4)
                            + ROUND(nvl(V.CURAMT,0) * LN.CFRATE1 * GREATEST (least(LN.MINTERM,LN.PRINFRQ) - TO_NUMBER(V_CURRDATE - TO_DATE(LNS.RLSDATE,'DD/MM/RRRR')),0 ) /100/360
                                + NVL(V.CURAMT,0) * LN.CFRATE2 *  GREATEST (GREATEST(LN.MINTERM-LN.PRINFRQ,0)-GREATEST(V_CURRDATE - TO_DATE(LNS.DUEDATE,'DD/MM/RRRR'),0 ),0) /100/360,4)
                             + NVL(V.CURINT,0) + NVL(V.CURFEE,0))
                        ELSE ROUND(NVL(V.CURAMT,0) + GREATEST((NVL(V.INTMIN,0) + NVL(V.FEEMIN,0)), (NVL(V.CURINT,0) + NVL(V.CURFEE,0)))) END SUMAMT
                FROM DFGROUP DF, VW_LNMAST_ALL LN, VW_LNSCHD_ALL LNS, AFMAST AF , CFMAST CF, LNTYPE LNT, --V_GETGRPDEALFORMULAR V
                    (SELECT V.GROUPID,V.CURAMT, V.CURINT, V.CURFEE,
                        CASE WHEN V_CURRDATE - TO_DATE(RLSDATE,'DD/MM/RRRR') >= MINTERM THEN CURINT ELSE
                         ROUND((CURAMT * (LEAST(Minterm, PRINFRQ)*RATE1 + GREATEST (0, MINTERM - PRINFRQ) * RATE2)) /100/360,4) END INTMIN,
                        CASE WHEN V_CURRDATE - TO_DATE(RLSDATE,'DD/MM/RRRR') >= MINTERM THEN CURFEE ELSE
                          ROUND((CURAMT * (LEAST(Minterm, PRINFRQ)* CFRATE1 + GREATEST(0, MINTERM - PRINFRQ) * CFRATE2))/100/360,4) END FEEMIN
                    FROM v_getgrpdealformular v
                    WHERE V.afacctno LIKE V_AFACCTNO
                    ) v
                WHERE DF.LNACCTNO= LN.ACCTNO AND LN.ACCTNO=LNS.ACCTNO AND LNS.REFTYPE='P'
                    AND DF.AFACCTNO= AF.ACCTNO AND AF.CUSTID= CF.CUSTID
                    AND LNT.ACTYPE = LN.ACTYPE
                    AND DF.GROUPID=V.GROUPID(+)
                    AND LN.TRFACCTNO LIKE V_AFACCTNO
                    AND LN.RLSDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                    AND LN.RLSDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
                ORDER BY LN.RLSDATE DESC, LN.ACCTNO;
                /*) A
            ) A
        WHERE A.ROWNUMBER BETWEEN v_FromRow AND v_ToRow;*/


EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GetGroupDFInforAll');
END pr_GetGroupDFInforAll;

-- Lay thong tin khoan vay DF chi tiet
-- TheNN, 01-Mar-2012
PROCEDURE pr_GetDetailDFInforAll
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     --pv_RowCount    IN OUT  NUMBER,
     --pv_PageSize    IN  NUMBER,
     --pv_PageIndex   IN  NUMBER,
     AFACCTNO       IN  VARCHAR2,
     GROUPDFID      IN  VARCHAR2
     --F_DATE         IN  VARCHAR2,
     --T_DATE         IN  VARCHAR2
     )
    IS

    V_AFACCTNO    VARCHAR2(10);
    V_GROUPDFID   VARCHAR2(50);
    v_RowCount    NUMBER;
    v_FromRow     NUMBER;
    v_ToRow       NUMBER;

BEGIN
    IF AFACCTNO = 'ALL' OR AFACCTNO IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := AFACCTNO;
    END IF;

    IF GROUPDFID = 'ALL' OR GROUPDFID IS NULL THEN
        V_GROUPDFID := '%%';
    ELSE
        V_GROUPDFID := GROUPDFID;
    END IF;

    -- LAY THONG TIN TONG SO DONG DU LIEU LAY RA DE PHAN TRANG
    /*IF pv_RowCount = 0 THEN
        SELECT COUNT(1)
        INTO v_RowCount
        FROM VW_DFMAST_ALL DF
        WHERE DF.GROUPID LIKE V_GROUPDFID
            AND DF.AFACCTNO LIKE V_AFACCTNO
            AND DF.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
            AND DF.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY');
        pv_RowCount := v_RowCount;
    ELSE
        v_RowCount := pv_RowCount;
    END IF;

    IF pv_PageSize >0 AND pv_PageIndex >0 THEN
        v_FromRow := pv_PageSize*(pv_PageIndex - 1) +1;
        v_ToRow := v_FromRow + pv_PageSize - 1;
    ELSE
        v_FromRow := 1;
        v_ToRow := pv_PageSize;
    END IF;*/

    -- LAY THONG TIN KHOAN VAY DF CHI TIET
    OPEN p_REFCURSOR FOR
        /*SELECT A.*
        FROM
            (
            SELECT ROWNUM ROWNUMBER, A.* FROM
                (*/
                SELECT DF.GROUPID GROUPID, DF.ACCTNO DFACCTNO, DF.AFACCTNO, DF.TXDATE, SIF.SYMBOL,
                    CASE WHEN DEALTYPE='T' THEN 1 ELSE SIF.DFREFPRICE END dfrefprice,
                    CASE WHEN DF.DEALTYPE IN('N') THEN DF.DFQTTY - NVL(V1.SECUREAMT,0)
                         WHEN DF.DEALTYPE='B' THEN DF.BLOCKQTTY
                         WHEN DF.DEALTYPE='R' THEN DF.RCVQTTY
                         WHEN DF.DEALTYPE='T' THEN DF.CACASHQTTY
                         ELSE DF.CARCVQTTY END QTTY, A1.CDCONTENT DFSTATUS, A2.CDCONTENT DEALTYPE_DESC, DF.DEALTYPE
                FROM VW_DFMAST_ALL DF, SECURITIES_INFO SIF, v_getdealsellorderinfo v1, ALLCODE A1, ALLCODE A2
                WHERE DF.CODEID = SIF.CODEID
                    AND DF.ACCTNO=V1.DFACCTNO(+)
                    AND A1.CDTYPE = 'DF' AND A1.CDNAME = 'DEALSTATUS' AND A1.CDVAL = DF.STATUS
                    AND A2.CDTYPE = 'DF' AND A2.CDNAME='DEALTYPE' AND A2.CDVAL = DF.DEALTYPE
                    AND DF.GROUPID LIKE V_GROUPDFID
                    AND DF.AFACCTNO LIKE V_AFACCTNO
                    --AND DF.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                    --AND DF.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
                ORDER BY DF.TXDATE DESC, DF.AFACCTNO, DF.GROUPID, DF.ACCTNO;
                /*) A
            ) A
        WHERE A.ROWNUMBER BETWEEN v_FromRow AND v_ToRow;*/

EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GetDetailDFInforAll');
END pr_GetDetailDFInforAll;


---------------------------------------------------------------
-- Ham thuc hien thanh toan no cam co online
-- Dau vao: - p_afacctno: So tieu khoan
--          - p_groupdealid: Ma tieu khoan deal tong
--          - p_paidamt: So tien thanh toan
--          - p_desc: Mo ta GD
-- Dau ra:  - p_err_code: Ma loi tra ve. =0: thanh cong. <>0: Loi
--          - p_err_message: thong bao loi neu ma loi <>0
-- Created by: TheNN     Date: 07-Feb-2012
---------------------------------------------------------------
PROCEDURE pr_PaidDealOnline
    (   p_afacctno varchar,
        p_groupdealid    VARCHAR2,
        p_paidamt  number,
        p_desc varchar2,
        p_err_code  OUT varchar2,
        p_err_message  OUT varchar2
    )
    IS
        l_txmsg         tx.msg_rectype;
        v_strCURRDATE   varchar2(20);
        l_err_param     varchar2(300);
        v_AMTPAID   NUMBER;
        v_INTPAID   NUMBER;
        v_FEEPAID   NUMBER;
        v_INTPENA   NUMBER;
        v_FEEPENA   NUMBER;
        v_RATEX   NUMBER;
        v_RATEY   NUMBER;
        v_INTMIN   NUMBER;
        v_FEEMIN   NUMBER;
        v_CURAMT   NUMBER;
        v_CURINT   NUMBER;
        v_CURFEE   NUMBER;
        v_INTPAIDMETHOD   varchar2(10);
        v_RATE1   NUMBER;
        v_RATE2   NUMBER;
        v_CFRATE1   NUMBER;
        v_CFRATE2   NUMBER;
        v_MINTERM   NUMBER;
        v_PRINFRQ   NUMBER;
        v_RLSDATE   DATE;
        v_DUEDATE   DATE;
        v_tmppaidamt    NUMBER;
        v_STRDATA   VARCHAR2(5000);
        v_QTTYRELEASE   NUMBER;
        v_TempRLSQTTY   NUMBER;
        v_MINAMTRLS     NUMBER;
        v_IsOK      BOOLEAN;
        V_DESC      VARCHAR2(2000);
        V_SUMAMT    NUMBER;
        V_TMPAMT    NUMBER;

    BEGIN
        plog.setbeginsection(pkgctx, 'pr_PaidDealOnline');

        -- Check host & branch active or inactive
        p_err_code := fn_CheckActiveSystem;
        IF p_err_code <> systemnums.C_SUCCESS THEN
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_PaidDealOnline');
            return;
        END IF;
        -- End: Check host & branch active or inactive

        BEGIN
            -- Lay thong tin deal vay tong
            SELECT A.AMTPAID, A.INTPAID, A.FEEPAID, A.INTPENA, A.FEEPENA, A.RATEX, A.RATEY, A.INTMIN, A.FEEMIN,
                A.CURAMT, A.CURINT, A.CURFEE, A.INTPAIDMETHOD, A.RATE1, A.RATE2, A.CFRATE1, A.CFRATE2, A.MINTERM,
                A.PRINFRQ, A.RLSDATE, A.DUEDATE,
                CASE WHEN INTMIN+FEEMIN < CURINT+CURFEE THEN ROUND(CURAMT + INTPENA_CUR + FEEPENA_CUR + CURINT + CURFEE)
                    ELSE ROUND(CURAMT + GREATEST((INTMIN + FEEMIN), (CURINT + CURFEE))) END SUMAMT
            INTO v_AMTPAID, v_INTPAID, v_FEEPAID, v_INTPENA, v_FEEPENA, v_RATEX, v_RATEY, v_INTMIN, v_FEEMIN,
                v_CURAMT, v_CURINT, v_CURFEE, v_INTPAIDMETHOD, v_RATE1, v_RATE2, v_CFRATE1, v_CFRATE2, v_MINTERM,
                v_PRINFRQ, v_RLSDATE, v_DUEDATE,V_SUMAMT
            FROM
            (
                SELECT AMTPAID,INTPAID,FEEPAID, ROUND (AMTPAID * RATE1 * GREATEST (least(MINTERM,PRINFRQ) - TO_NUMBER(TO_DATE((SELECT VARVALUE FROM SYSVAR WHERE VARNAME='CURRDATE'),'DD/MM/RRRR') - TO_DATE(RLSDATE,'DD/MM/RRRR')),0 ) /100/360
                        + AMTPAID * RATE2 * GREATEST (GREATEST(MINTERM-PRINFRQ,0)-GREATEST(TO_DATE((SELECT VARVALUE FROM SYSVAR WHERE VARNAME='CURRDATE'),'DD/MM/RRRR') - TO_DATE(DUEDATE,'DD/MM/RRRR'),0 ),0) /100/360,0) INTPENA,

                       ROUND(AMTPAID * CFRATE1 * GREATEST (least(MINTERM,PRINFRQ) - TO_NUMBER(TO_DATE((SELECT VARVALUE FROM SYSVAR WHERE VARNAME='CURRDATE'),'DD/MM/RRRR') - TO_DATE(RLSDATE,'DD/MM/RRRR')),0 ) /100/360
                        + AMTPAID * CFRATE2 *  GREATEST (GREATEST(MINTERM-PRINFRQ,0)-GREATEST(TO_DATE((SELECT VARVALUE FROM SYSVAR WHERE VARNAME='CURRDATE'),'DD/MM/RRRR') - TO_DATE(DUEDATE,'DD/MM/RRRR'),0 ),0) /100/360,0) FEEPENA,
                       RATEX, RATEY, INTMIN,FEEMIN, CURAMT, CURINT, CURFEE, INTPAIDMETHOD, RATE1, RATE2,CFRATE1, CFRATE2, MINTERM, PRINFRQ, RLSDATE, DUEDATE, INTPENA_CUR, FEEPENA_CUR
                FROM
                (
                    SELECT
                       CASE WHEN INTPAIDMETHOD IN ('I','P') THEN
                          CASE WHEN    GREATEST (INTMIN+FEEMIN, CURINT+CURFEE)=0 THEN p_paidamt ELSE ROUND(p_paidamt * (CURAMT/ GREATEST( CURAMT + GREATEST((INTMIN + FEEMIN), (CURINT + CURFEE)),1))) END  ELSE
                            CASE WHEN  round(p_paidamt,0) =round(CURAMT + GREATEST((INTMIN + FEEMIN), (CURINT + CURFEE)) + INTPENA_CUR + FEEPENA_CUR,0) THEN CURAMT ELSE
                             CASE WHEN p_paidamt < CURAMT THEN p_paidamt ELSE case when round(p_paidamt,0) = round(CURAMT + GREATEST((INTMIN + FEEMIN), (CURINT + CURFEE)),0) then CURAMT ELSE CURAMT END  END END  END AMTPAID,

                          CASE WHEN INTPAIDMETHOD IN ('I','P') THEN
                           CASE WHEN    GREATEST ( INTMIN, CURINT) = 0 THEN 0 ELSE ROUND(p_paidamt * GREATEST(INTMIN, CURINT) / GREATEST( CURAMT + GREATEST((INTMIN + FEEMIN), (CURINT + CURFEE)),1)) END ELSE
                            CASE WHEN  round(p_paidamt,0) =round(CURAMT + GREATEST((INTMIN + FEEMIN), (CURINT + CURFEE)) + INTPENA_CUR + FEEPENA_CUR,0) THEN ROUND(GREATEST ( INTMIN,CURINT ) + INTPENA_CUR,0) ELSE
                                    case when round(p_paidamt,0) = round(CURAMT + GREATEST((INTMIN + FEEMIN), (CURINT + CURFEE)),0) then INTMIN ELSE 0 END  END  END INTPAID,

                           CASE WHEN INTPAIDMETHOD IN ('I','P') THEN
                             CASE WHEN GREATEST ( FEEMIN, CURFEE) = 0 THEN 0 ELSE ROUND(p_paidamt - ROUND(p_paidamt * (CURAMT/ GREATEST( CURAMT + GREATEST((INTMIN + FEEMIN), (CURINT + CURFEE)),1))) - ROUND(p_paidamt * GREATEST(INTMIN, CURINT) / GREATEST( CURAMT + GREATEST((INTMIN + FEEMIN), (CURINT + CURFEE)),1)) ) END ELSE
                                    CASE WHEN  round(p_paidamt,0) =round(CURAMT + GREATEST((INTMIN + FEEMIN), (CURINT + CURFEE)) + INTPENA_CUR + FEEPENA_CUR,0) THEN ROUND(GREATEST ( FEEMIN,CURFEE ) + FEEPENA_CUR,0) ELSE
                                    case when round(p_paidamt,0) = round(CURAMT + GREATEST((INTMIN + FEEMIN), (CURINT + CURFEE)),0) then  FEEMIN ELSE 0 END
                                    END  END FEEPAID,
                        INTPENA_CUR, FEEPENA_CUR,
                        RATEX, RATEY, INTMIN,FEEMIN, CURAMT, CURINT, CURFEE, INTPAIDMETHOD, RATE1, RATE2,CFRATE1, CFRATE2, MINTERM, PRINFRQ, RLSDATE, DUEDATE

                    FROM (

                        SELECT ROUND(CURAMT/ GREATEST( CURAMT + GREATEST((INTMIN + FEEMIN), (CURINT + CURFEE)),1),20) RATEX,  ROUND(GREATEST(INTMIN, CURINT) / GREATEST( CURAMT + GREATEST((INTMIN + FEEMIN), (CURINT + CURFEE)),1),20) RATEY,
                        INTMIN,FEEMIN, CURAMT, CURINT, CURFEE, INTPAIDMETHOD, RATE1, RATE2,CFRATE1, CFRATE2, MINTERM, PRINFRQ, RLSDATE, DUEDATE,

                            ROUND (CURAMT * RATE1 * GREATEST (least(MINTERM,PRINFRQ) - TO_NUMBER(TO_DATE((SELECT VARVALUE FROM SYSVAR WHERE VARNAME='CURRDATE'),'DD/MM/RRRR') - TO_DATE(RLSDATE,'DD/MM/RRRR')),0 ) /100/360
                        + CURAMT * RATE2 * GREATEST (GREATEST(MINTERM-PRINFRQ,0)-GREATEST(TO_DATE((SELECT VARVALUE FROM SYSVAR WHERE VARNAME='CURRDATE'),'DD/MM/RRRR') - TO_DATE(DUEDATE,'DD/MM/RRRR'),0 ),0) /100/360) INTPENA_CUR,

                     ROUND(CURAMT * CFRATE1 * GREATEST (least(MINTERM,PRINFRQ) - TO_NUMBER(TO_DATE((SELECT VARVALUE FROM SYSVAR WHERE VARNAME='CURRDATE'),'DD/MM/RRRR') - TO_DATE(RLSDATE,'DD/MM/RRRR')),0 ) /100/360
                        + CURAMT * CFRATE2 *  GREATEST (GREATEST(MINTERM-PRINFRQ,0)-GREATEST(TO_DATE((SELECT VARVALUE FROM SYSVAR WHERE VARNAME='CURRDATE'),'DD/MM/RRRR') - TO_DATE(DUEDATE,'DD/MM/RRRR'),0 ),0) /100/360) FEEPENA_CUR

                        FROM (
                            SELECT  CURAMT, CURINT, CURFEE, INTPAIDMETHOD, RATE1, RATE2,CFRATE1, CFRATE2, MINTERM, PRINFRQ, RLSDATE, DUEDATE,

                            CASE WHEN TO_DATE((SELECT VARVALUE FROM SYSVAR WHERE VARNAME='CURRDATE'),'DD/MM/RRRR') - TO_DATE(RLSDATE,'DD/MM/RRRR') >= MINTERM THEN CURINT ELSE
                             ROUND((CURAMT *   (LEAST(Minterm, PRINFRQ)*RATE1 + GREATEST ( 0 , MINTERM - PRINFRQ) * RATE2) ) /100/360) END INTMIN,

                            CASE WHEN TO_DATE((SELECT VARVALUE FROM SYSVAR WHERE VARNAME='CURRDATE'),'DD/MM/RRRR') - TO_DATE(RLSDATE,'DD/MM/RRRR') >= MINTERM THEN CURFEE ELSE
                              ROUND((CURAMT *   (LEAST(Minterm, PRINFRQ)* CFRATE1 + GREATEST ( 0 , MINTERM - PRINFRQ) * CFRATE2) ) /100/360)  END FEEMIN

                            FROM (
                                SELECT  CURAMT, CURINT, CURFEE, INTPAIDMETHOD, RATE1, RATE2,CFRATE1, CFRATE2, LEAST(MINTERM, TO_NUMBER( TO_DATE(OVERDUEDATE,'DD/MM/RRRR') - TO_DATE(RLSDATE,'DD/MM/RRRR')) )  MINTERM, PRINFRQ, RLSDATE, DUEDATE
                                FROM (
                                        SELECT ROUND(LNS.NML) + ROUND(LNS.OVD) CURAMT,
                                                ROUND(LNS.INTNMLACR) + ROUND(LNS.intdue) + ROUND(LNS.intovd) + ROUND(LNS.intovdprin) CURINT,
                                                ROUND(LNS.FEEINTNMLACR) + ROUND(LNS.FEEINTOVDACR) + ROUND(LNS.FEEINTDUE) + ROUND(LNS.FEEINTNMLOVD) CURFEE, LN.INTPAIDMETHOD,
                                            LNS.RATE1, LNS.RATE2, LNS.CFRATE1, LNS.CFRATE2, LN.MINTERM, TO_DATE(lns.DUEDATE,'DD/MM/RRRR') -  TO_DATE(lns.RLSDATE,'DD/MM/RRRR') PRINFRQ, LN.RLSDATE,LNS.DUEDATE,lns.OVERDUEDATE
                                            FROM (SELECT * FROM lnschd UNION SELECT * FROM lnschdhist) LNS, LNMAST LN, LNTYPE LNT
                                        WHERE LN.ACCTNO in (select lnacctno from dfgroup where groupid= p_groupdealid) AND LN.ACCTNO=LNS.ACCTNO
                                            AND LN.ACTYPE=LNT.ACTYPE
                                            and REFTYPE='P'
                                    )
                                )
                        )
                    )
                )
            ) A;

            -- So sanh gia tri thanh toan voi gia tri toi da con no
            -- Neu so tien nhap vao lon hon so tien can thanh toan toi da thi bao loi
            IF v_CURAMT + ROUND(GREATEST(v_CURFEE+v_CURINT,v_INTMIN+v_FEEMIN)) < p_paidamt THEN
                p_err_code := -260005; -- vuot qua so tien phai thanh toan cho deal
                p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
                plog.error(pkgctx, 'Error:'  || p_err_message);
                plog.setendsection(pkgctx, 'pr_PaidDealOnline');
                return;
            END IF;

            -- Lay thong tin chi tiet cac deal vay
            if V_SUMAMT = 0 then
                V_TMPAMT := 10000000000000000;
            else
                V_TMPAMT := to_number(p_paidamt);
            end if;

            --SELECT ceil(TADF-DDF*(IRATE/100)) MINAMTRLS
            SELECT floor(LEAST (TADF- (DDF - V_TMPAMT ) *(IRATE/100), V_TMPAMT *
                    (TA0DF / case when (CASE WHEN intpaidmethod = 'L' THEN CURAMT ELSE V_SUMAMT END ) =0
                                then 1 else (CASE WHEN intpaidmethod = 'L' THEN CURAMT ELSE V_SUMAMT END ) end ) )) MINAMTRLS
            INTO v_MINAMTRLS
            FROM v_getgrpdealformular V
            WHERE V.GROUPID = p_groupdealid;

            --v_tmppaidamt := round(p_paidamt + v_MINAMTRLS);
            v_tmppaidamt := round(v_MINAMTRLS);
            v_TempRLSQTTY := 0;
            v_IsOK := TRUE;

            --plog.debug(pkgctx, 'MINAMTRLS: '  || v_MINAMTRLS);
            --plog.debug(pkgctx, 'v_tmppaidamt: '  || v_tmppaidamt);
            FOR rec IN
                (
                    SELECT floor(LEAST (TADF- (DDF - V_TMPAMT ) *(IRATE/100), V_TMPAMT * (TA0DF / case when (CASE WHEN intpaidmethod = 'L' THEN CURAMT ELSE V_SUMAMT END ) =0 then 1 else (CASE WHEN intpaidmethod = 'L' THEN CURAMT ELSE V_SUMAMT END ) end ) )) MINAMTRLS, A.*,
                        FLOOR(GREATEST(floor(least (floor(LEAST (TADF- (DDF - V_TMPAMT ) *(IRATE/100), V_TMPAMT * (TA0DF / case when (CASE WHEN intpaidmethod = 'L' THEN CURAMT ELSE V_SUMAMT END ) =0 then 1 else (CASE WHEN intpaidmethod = 'L' THEN CURAMT ELSE V_SUMAMT END ) end ) )) / ( DFREFPRICE * DFRATE/100), QTTY )),0) / LOT) * LOT MAXRELEASE ,  0 QTTYRELEASE,
                        QTTY * (DFREFPRICE * DFRATE/100) AMTRELEASEALL
                    FROM
                        (
                        select DF.AFACCTNO||DF.CODEID SEACCTNO, DF.ACCTNO,  LN.intpaidmethod,
                        CASE WHEN DF.DEALTYPE='T' THEN 1 ELSE df.TRADELOT END LOT, V.TA0DF , V.CURAMT, V.IRATE, V.TADF, V.DDF, V.TADF - (V.IRATE*(DDF- 0 )/100 ) VReleaseDF, DF.DFRATE,
                         CASE WHEN DEALTYPE='T' THEN 1 ELSE SEC.DFREFPRICE END dfrefprice, DF.DEALTYPE, sec.symbol,A1.CDCONTENT CONTENT,
                         CASE WHEN DF.DEALTYPE IN('N') THEN DF.DFQTTY - NVL(V1.SECUREAMT,0)ELSE  CASE WHEN DF.DEALTYPE='B' THEN DF.BLOCKQTTY
                         ELSE CASE WHEN DF.DEALTYPE='R' THEN DF.RCVQTTY  ELSE CASE WHEN DF.DEALTYPE='T' THEN DF.CACASHQTTY
                         ELSE DF.CARCVQTTY END END END END QTTY, 0 AMTRELEASE
                         from v_getdealinfo DF, v_getgrpdealformular v, v_getdealsellorderinfo v1, securities_info sec , ALLCODE A1 , LNMAST LN
                         where DF.GROUPID= p_groupdealid and DF.groupid=v.groupid AND df.codeid=sec.codeid  AND DF.DEALTYPE=A1.CDVAL AND A1.CDNAME='DEALTYPE'
                         AND V.LNACCTNO = LN.ACCTNO and  DF.ACCTNO=V1.DFACCTNO(+)

                        ) A
                    /*SELECT ceil(TADF-DDF*(IRATE/100)) MINAMTRLS, A.*,
                        FLOOR(GREATEST(floor(least (VReleaseDF / ( DFREFPRICE * DFRATE/100), QTTY )),0) / LOT) * LOT MAXRELEASE,
                        0 QTTYRELEASE, QTTY * (DFREFPRICE * DFRATE/100) AMTRELEASEALL
                    FROM
                        (
                            select DF.AFACCTNO||DF.CODEID SEACCTNO, DF.ACCTNO,
                                CASE WHEN DF.DEALTYPE='T' THEN 1 ELSE df.TRADELOT END LOT, V.IRATE, V.TADF, V.DDF,
                                V.TADF - (V.IRATE*(DDF- p_paidamt)/100 ) VReleaseDF, DF.DFRATE,
                                CASE WHEN DEALTYPE='T' THEN 1 ELSE SEC.DFREFPRICE END dfrefprice, DF.DEALTYPE, sec.symbol,
                                A1.CDCONTENT CONTENT,
                                CASE WHEN DF.DEALTYPE IN('N') THEN DF.DFQTTY - NVL(V1.SECUREAMT,0)
                                    WHEN DF.DEALTYPE='B' THEN DF.BLOCKQTTY
                                    WHEN DF.DEALTYPE='R' THEN DF.RCVQTTY
                                    WHEN DF.DEALTYPE='T' THEN DF.CACASHQTTY
                                    ELSE DF.CARCVQTTY END QTTY, 0 AMTRELEASE
                            from v_getdealinfo DF, v_getgrpdealformular v, v_getdealsellorderinfo v1, securities_info sec, ALLCODE A1
                            where DF.groupid=v.groupid AND df.codeid=sec.codeid
                                AND DF.DEALTYPE=A1.CDVAL AND A1.CDNAME='DEALTYPE' and DF.ACCTNO=V1.DFACCTNO(+)
                                AND DF.GROUPID = p_groupdealid
                                AND DF.AFACCTNO = p_afacctno
                        ) A*/
                )
                LOOP
                    -- Lay thong tin tung deal chi tiet, tinh toan va ghep thanh string
                    v_QTTYRELEASE := 0;
                    v_TempRLSQTTY := 0;
                    --plog.debug(pkgctx, 'v_tmppaidamt: '  || v_tmppaidamt);
                    --plog.debug(pkgctx, 'rec.AMTRELEASEALL: '  || rec.AMTRELEASEALL);
                    IF v_tmppaidamt >= rec.AMTRELEASEALL AND v_IsOK = TRUE THEN
                        v_QTTYRELEASE := round(rec.QTTY);
                        v_tmppaidamt := round(v_tmppaidamt - rec.AMTRELEASEALL);
                        v_IsOK := TRUE;
                        -- Ghep chuoi du lieu
                        v_STRDATA := v_STRDATA || p_groupdealid || '|' || rec.ACCTNO || '|' || rec.AMTRELEASE || '|'
                                    || v_QTTYRELEASE || '|' || v_AMTPAID || '|' || v_INTPAID || '|' || v_FEEPAID || '|'
                                    || v_INTPENA || '|' || v_FEEPENA || '|' || rec.DEALTYPE || '|' || p_paidamt || '@';
                    ELSIF v_IsOK = TRUE THEN
                        IF v_tmppaidamt > 0 THEN
                            v_TempRLSQTTY := v_tmppaidamt/(rec.DFREFPRICE*(rec.DFRATE/100));
                            v_QTTYRELEASE := floor(GREATEST(LEAST(v_TempRLSQTTY,rec.MAXRELEASE),0)/rec.LOT)*rec.LOT;
                            v_tmppaidamt := 0;
                            v_IsOK := FALSE;
                        ELSE
                            v_QTTYRELEASE := 0;
                            v_tmppaidamt := 0;
                            v_IsOK := FALSE;
                        END IF;
                        -- Ghep chuoi du lieu
                        --IF v_QTTYRELEASE >0 then
                            v_STRDATA := v_STRDATA || p_groupdealid || '|' || rec.ACCTNO || '|' || rec.AMTRELEASE || '|'
                                        || v_QTTYRELEASE || '|' || v_AMTPAID || '|' || v_INTPAID || '|' || v_FEEPAID || '|'
                                        || v_INTPENA || '|' || v_FEEPENA || '|' || rec.DEALTYPE || '|' || p_paidamt || '@';
                        --END IF;
                    END IF;
                END LOOP;
        END;

        plog.debug(pkgctx, 'v_STRDATA: '  || v_STRDATA);

        -- Thuc hien GD
        SELECT TO_CHAR(getcurrdate)
                   INTO v_strCURRDATE
        FROM DUAL;
        l_txmsg.msgtype     :='T';
        l_txmsg.local       :='N';
        l_txmsg.tlid        := systemnums.C_ONLINE_USERID;
        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                 SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
          INTO l_txmsg.wsname, l_txmsg.ipaddress
        FROM DUAL;
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txcompleted;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'DAY';
        l_txmsg.txdate      :=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.busdate     :=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.tltxcd      :='2646';

        --Set txnum
        SELECT systemnums.C_OL_PREFIXED
                         || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                  INTO l_txmsg.txnum
                  FROM DUAL;
        l_txmsg.brid        := substr(p_afacctno,1,4);

        IF p_desc IS NULL THEN
            SELECT TL.TXDESC
            INTO V_DESC
            FROM TLTX TL WHERE TLTXCD = '2646';
        ELSE
            V_DESC := p_desc;
        END IF;

        --Set cac field giao dich
        --03   AFACCTNO      C
        l_txmsg.txfields ('03').defname   := 'AFACCTNO';
        l_txmsg.txfields ('03').TYPE      := 'C';
        l_txmsg.txfields ('03').VALUE     := p_afacctno;
        --20   GROUPID      C
        l_txmsg.txfields ('20').defname   := 'GROUPID';
        l_txmsg.txfields ('20').TYPE      := 'C';
        l_txmsg.txfields ('20').VALUE     := p_groupdealid;
        --06   STRDATA      C
        l_txmsg.txfields ('06').defname   := 'STRDATA';
        l_txmsg.txfields ('06').TYPE      := 'C';
        l_txmsg.txfields ('06').VALUE     := v_STRDATA;
        --26   SUMPAID      C
        l_txmsg.txfields ('26').defname   := 'SUMPAID';
        l_txmsg.txfields ('26').TYPE      := 'N';
        l_txmsg.txfields ('26').VALUE     := p_paidamt;
        --34   AMTPAID      C
        l_txmsg.txfields ('34').defname   := 'AMTPAID';
        l_txmsg.txfields ('34').TYPE      := 'N';
        l_txmsg.txfields ('34').VALUE     := v_AMTPAID;
        --35   INTPAID      C
        l_txmsg.txfields ('35').defname   := 'INTPAID';
        l_txmsg.txfields ('35').TYPE      := 'N';
        l_txmsg.txfields ('35').VALUE     := v_INTPAID;
        --36   FEEPAID      C
        l_txmsg.txfields ('36').defname   := 'FEEPAID';
        l_txmsg.txfields ('36').TYPE      := 'N';
        l_txmsg.txfields ('36').VALUE     := v_FEEPAID;
        --30   DESC    C
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').VALUE     := V_DESC;

        BEGIN
            IF txpks_#2646.fn_autotxprocess (l_txmsg,
                                             p_err_code,
                                             l_err_param
               ) <> systemnums.c_success
            THEN
               plog.debug (pkgctx,
                           'got error 2646: ' || p_err_code
               );
               ROLLBACK;
               p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
               plog.error(pkgctx, 'Error:'  || p_err_message);
               plog.setendsection(pkgctx, 'pr_OnlinePaidDeal');
               RETURN;
            END IF;
        END;
        p_err_code:=0;
        plog.setendsection(pkgctx, 'pr_OnlinePaidDeal');

    EXCEPTION
        WHEN OTHERS
        THEN
             plog.debug (pkgctx,'got error on pr_PaidDealOnline');
             ROLLBACK;
             p_err_code := errnums.C_SYSTEM_ERROR;
             plog.error (pkgctx, SQLERRM);
             plog.setendsection (pkgctx, 'pr_PaidDealOnline');
             RAISE errnums.E_SYSTEM_ERROR;
    END pr_PaidDealOnline;



/*
PROCEDURE pr_PaidDealOnline
    (   p_afacctno varchar,
        p_groupdealid    VARCHAR2,
        p_paidamt  number,
        p_desc varchar2,
        p_err_code  OUT varchar2,
        p_err_message  OUT varchar2
    )
    IS
        l_txmsg         tx.msg_rectype;
        v_strCURRDATE   varchar2(20);
        l_err_param     varchar2(300);
        v_AMTPAID   NUMBER;
        v_INTPAID   NUMBER;
        v_FEEPAID   NUMBER;
        v_INTPENA   NUMBER;
        v_FEEPENA   NUMBER;
        v_RATEX   NUMBER;
        v_RATEY   NUMBER;
        v_INTMIN   NUMBER;
        v_FEEMIN   NUMBER;
        v_CURAMT   NUMBER;
        v_CURINT   NUMBER;
        v_CURFEE   NUMBER;
        v_INTPAIDMETHOD   varchar2(10);
        v_RATE1   NUMBER;
        v_RATE2   NUMBER;
        v_CFRATE1   NUMBER;
        v_CFRATE2   NUMBER;
        v_MINTERM   NUMBER;
        v_PRINFRQ   NUMBER;
        v_RLSDATE   DATE;
        v_DUEDATE   DATE;
        v_tmppaidamt    NUMBER;
        v_STRDATA   VARCHAR2(5000);
        v_QTTYRELEASE   NUMBER;
        v_TempRLSQTTY   NUMBER;
        v_MINAMTRLS     NUMBER;
        v_IsOK      BOOLEAN;
        V_DESC      VARCHAR2(2000);

    BEGIN
        plog.setbeginsection(pkgctx, 'pr_PaidDealOnline');

        -- Check host & branch active or inactive
        p_err_code := fn_CheckActiveSystem;
        IF p_err_code <> systemnums.C_SUCCESS THEN
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_PaidDealOnline');
            return;
        END IF;
        -- End: Check host & branch active or inactive

        BEGIN
            -- Lay thong tin deal vay tong
            SELECT ROUND(AMTPAID) AMTPAID, ROUND(INTPAID) INTPAID, ROUND(FEEPAID) FEEPAID,
                    ROUND (AMTPAID * RATE1 * GREATEST (least(MINTERM,PRINFRQ) - TO_NUMBER(TO_DATE((SELECT VARVALUE FROM SYSVAR WHERE VARNAME='CURRDATE'),'DD/MM/RRRR') - TO_DATE(RLSDATE,'DD/MM/RRRR')),0 ) /100/360
                    + AMTPAID * RATE2 * GREATEST (GREATEST(MINTERM-PRINFRQ,0)-GREATEST(TO_DATE((SELECT VARVALUE FROM SYSVAR WHERE VARNAME='CURRDATE'),'DD/MM/RRRR') - TO_DATE(DUEDATE,'DD/MM/RRRR'),0 ),0) /100/360) INTPENA,
                 ROUND(AMTPAID * CFRATE1 * GREATEST (least(MINTERM,PRINFRQ) - TO_NUMBER(TO_DATE((SELECT VARVALUE FROM SYSVAR WHERE VARNAME='CURRDATE'),'DD/MM/RRRR') - TO_DATE(RLSDATE,'DD/MM/RRRR')),0 ) /100/360
                    + AMTPAID * CFRATE2 *  GREATEST (GREATEST(MINTERM-PRINFRQ,0)-GREATEST(TO_DATE((SELECT VARVALUE FROM SYSVAR WHERE VARNAME='CURRDATE'),'DD/MM/RRRR') - TO_DATE(DUEDATE,'DD/MM/RRRR'),0 ),0) /100/360) FEEPENA,
                   RATEX, RATEY, INTMIN,FEEMIN, CURAMT, CURINT, CURFEE, INTPAIDMETHOD, RATE1, RATE2,CFRATE1, CFRATE2, MINTERM, PRINFRQ, RLSDATE, DUEDATE
            INTO v_AMTPAID, v_INTPAID, v_FEEPAID, v_INTPENA, v_FEEPENA, v_RATEX, v_RATEY, v_INTMIN, v_FEEMIN,
                v_CURAMT, v_CURINT, v_CURFEE, v_INTPAIDMETHOD, v_RATE1, v_RATE2, v_CFRATE1, v_CFRATE2, v_MINTERM, v_PRINFRQ, v_RLSDATE, v_DUEDATE
            FROM
                (
                SELECT
                    CASE WHEN INTPAIDMETHOD IN ('I','P') THEN
                      CASE WHEN    GREATEST (INTMIN+FEEMIN, CURINT+CURFEE)=0 THEN p_paidamt ELSE ROUND((p_paidamt * RATEX) /( 1+ RATEX ),4) END  ELSE
                        CASE WHEN  round(p_paidamt,0) = round(CURAMT + GREATEST((INTMIN + FEEMIN), (CURINT + CURFEE)),0) THEN CURAMT ELSE
                         CASE WHEN p_paidamt < CURAMT THEN p_paidamt ELSE 0 END END  END AMTPAID,

                      CASE WHEN INTPAIDMETHOD IN ('I','P') THEN
                       CASE WHEN    GREATEST ( INTMIN, CURINT) = 0 THEN 0 ELSE ROUND(p_paidamt/( ( 1+ RATEX ) * (1+RATEY) ),4) END ELSE
                        CASE WHEN  round(p_paidamt,0) = round(CURAMT + GREATEST((INTMIN + FEEMIN), (CURINT + CURFEE)),0) THEN ROUND(GREATEST ( INTMIN,CURINT ),4) ELSE
                                0 END  END INTPAID,

                       CASE WHEN INTPAIDMETHOD IN ('I','P') THEN
                         CASE WHEN GREATEST ( FEEMIN, CURFEE) = 0 THEN 0 ELSE ROUND((p_paidamt*RATEY)/( ( 1+ RATEX ) * (1+RATEY) ),4) END ELSE
                                CASE WHEN  round(p_paidamt,0) = round(CURAMT + GREATEST((INTMIN + FEEMIN), (CURINT + CURFEE)),0) THEN ROUND(GREATEST ( FEEMIN,CURFEE ),4) ELSE 0 END  END FEEPAID,
                    RATEX, RATEY, INTMIN,FEEMIN, CURAMT, CURINT, CURFEE, INTPAIDMETHOD, RATE1, RATE2,CFRATE1, CFRATE2, MINTERM, PRINFRQ, RLSDATE, DUEDATE

                FROM (

                    SELECT ROUND(CURAMT/ GREATEST( GREATEST((INTMIN + FEEMIN), (CURINT + CURFEE)),1),4) RATEX,  ROUND(GREATEST(FEEMIN, CURFEE) / GREATEST(GREATEST(INTMIN, CURINT),1),4) RATEY,
                    INTMIN,FEEMIN, CURAMT, CURINT, CURFEE, INTPAIDMETHOD, RATE1, RATE2,CFRATE1, CFRATE2, MINTERM, PRINFRQ, RLSDATE, DUEDATE

                    FROM (
                        SELECT  CURAMT, CURINT, CURFEE, INTPAIDMETHOD, RATE1, RATE2,CFRATE1, CFRATE2, MINTERM, PRINFRQ, RLSDATE, DUEDATE,

                        CASE WHEN TO_DATE((SELECT VARVALUE FROM SYSVAR WHERE VARNAME='CURRDATE'),'DD/MM/RRRR') - TO_DATE(RLSDATE,'DD/MM/RRRR') >= MINTERM THEN CURINT ELSE
                         ROUND((CURAMT *   (LEAST(Minterm, PRINFRQ)*RATE1 + GREATEST ( 0 , MINTERM - PRINFRQ) * RATE2) ) /100/360,4) END INTMIN,

                        CASE WHEN TO_DATE((SELECT VARVALUE FROM SYSVAR WHERE VARNAME='CURRDATE'),'DD/MM/RRRR') - TO_DATE(RLSDATE,'DD/MM/RRRR') >= MINTERM THEN CURFEE ELSE
                          ROUND((CURAMT *   (LEAST(Minterm, PRINFRQ)* CFRATE1 + GREATEST ( 0 , MINTERM - PRINFRQ) * CFRATE2) ) /100/360,4)  END FEEMIN

                        FROM (
                            SELECT  CURAMT, CURINT, CURFEE, INTPAIDMETHOD, RATE1, RATE2,CFRATE1, CFRATE2, LEAST(MINTERM, TO_NUMBER( TO_DATE(OVERDUEDATE,'DD/MM/RRRR') - TO_DATE(RLSDATE,'DD/MM/RRRR')) )  MINTERM, PRINFRQ, RLSDATE, DUEDATE
                            FROM (SELECT LNS.NML + LNS.OVD CURAMT, LNS.INTNMLACR+LNS.intdue+LNS.intovd + LNS.intovdprin CURINT,
                                    LNS.FEEINTNMLACR + LNS.FEEINTOVDACR + LNS.FEEINTDUE + LNS.FEEINTNMLOVD CURFEE, LN.INTPAIDMETHOD,
                                    LNS.RATE1, LNS.RATE2, LNS.CFRATE1, LNS.CFRATE2, LN.MINTERM, TO_DATE(lns.DUEDATE,'DD/MM/RRRR') -  TO_DATE(lns.RLSDATE,'DD/MM/RRRR') PRINFRQ, LN.RLSDATE,LNS.DUEDATE,lns.OVERDUEDATE
                                    FROM LNSCHD LNS, LNMAST LN
                                WHERE LN.ACCTNO in (select lnacctno from dfgroup where groupid=p_groupdealid) AND LN.ACCTNO=LNS.ACCTNO and REFTYPE='P'
                                )
                            )
                    )
                )
            );

            -- So sanh gia tri thanh toan voi gia tri toi da con no
            -- Neu so tien nhap vao lon hon so tien can thanh toan toi da thi bao loi
            IF v_CURAMT + ROUND(GREATEST(v_CURFEE+v_CURINT,v_INTMIN+v_FEEMIN)) < p_paidamt THEN
                p_err_code := -260005; -- vuot qua so tien phai thanh toan cho deal
                p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
                plog.error(pkgctx, 'Error:'  || p_err_message);
                plog.setendsection(pkgctx, 'pr_PaidDealOnline');
                return;
            END IF;

            -- Lay thong tin chi tiet cac deal vay
            SELECT ceil(TADF-DDF*(IRATE/100)) MINAMTRLS
            INTO v_MINAMTRLS
            FROM v_getgrpdealformular V
            WHERE V.GROUPID = p_groupdealid;

            v_tmppaidamt := round(p_paidamt + v_MINAMTRLS);
            v_TempRLSQTTY := 0;
            v_IsOK := TRUE;
            plog.debug(pkgctx, 'MINAMTRLS: '  || v_MINAMTRLS);
            plog.debug(pkgctx, 'v_tmppaidamt: '  || v_tmppaidamt);
            FOR rec IN
                (
                    SELECT ceil(TADF-DDF*(IRATE/100)) MINAMTRLS, A.*,
                        FLOOR(GREATEST(floor(least (VReleaseDF / ( DFREFPRICE * DFRATE/100), QTTY )),0) / LOT) * LOT MAXRELEASE,
                        0 QTTYRELEASE, QTTY *(DFREFPRICE * DFRATE/100) AMTRELEASEALL
                    FROM
                        (
                            select DF.LNACCTNO,DF.GROUPID, DF.AFACCTNO||DF.CODEID SEACCTNO, DF.ACCTNO,
                                CASE WHEN DF.DEALTYPE='T' THEN 1 ELSE df.TRADELOT END LOT, V.IRATE, V.TADF, V.DDF,
                                V.TADF - (V.IRATE*(DDF-p_paidamt)/100 ) VReleaseDF, DF.DFRATE,
                                CASE WHEN DEALTYPE='T' THEN 1 ELSE SEC.DFREFPRICE END dfrefprice, DF.DEALTYPE, sec.symbol,
                                A1.CDCONTENT CONTENT,
                                CASE WHEN DF.DEALTYPE IN('N') THEN DF.DFQTTY - NVL(V1.SECUREAMT,0)
                                    ELSE CASE WHEN DF.DEALTYPE='B' THEN DF.BLOCKQTTY
                                            ELSE CASE WHEN DF.DEALTYPE='R' THEN DF.RCVQTTY
                                                ELSE CASE WHEN DF.DEALTYPE='T' THEN DF.CACASHQTTY
                                                    ELSE DF.CARCVQTTY END END END END QTTY, 0 AMTRELEASE
                            from v_getdealinfo DF, v_getgrpdealformular v, v_getdealsellorderinfo v1, securities_info sec, ALLCODE A1
                            where DF.groupid=v.groupid AND df.codeid=sec.codeid
                                AND DF.DEALTYPE=A1.CDVAL AND A1.CDNAME='DEALTYPE' and DF.ACCTNO=V1.DFACCTNO(+)
                                AND DF.GROUPID = p_groupdealid
                                AND DF.AFACCTNO = p_afacctno
                        ) A
                )
                LOOP
                    -- Lay thong tin tung deal chi tiet, tinh toan va ghep thanh string
                    v_QTTYRELEASE := 0;
                    v_TempRLSQTTY := 0;
                    plog.debug(pkgctx, 'v_tmppaidamt: '  || v_tmppaidamt);
                    plog.debug(pkgctx, 'rec.AMTRELEASEALL: '  || rec.AMTRELEASEALL);
                    IF v_tmppaidamt >= rec.AMTRELEASEALL AND v_IsOK = TRUE THEN
                        v_QTTYRELEASE := round(rec.QTTY);
                        v_tmppaidamt := round(v_tmppaidamt - rec.AMTRELEASEALL);
                        v_IsOK := TRUE;
                        -- Ghep chuoi du lieu
                        v_STRDATA := v_STRDATA || p_groupdealid || '|' || rec.ACCTNO || '|' || rec.AMTRELEASE || '|'
                                    || v_QTTYRELEASE || '|' || v_AMTPAID || '|' || v_INTPAID || '|' || v_FEEPAID || '|'
                                    || v_INTPENA || '|' || v_FEEPENA || '|' || rec.DEALTYPE || '|' || p_paidamt || '@';
                    ELSIF v_IsOK = TRUE THEN
                        IF v_tmppaidamt > 0 THEN
                            v_TempRLSQTTY := v_tmppaidamt/(rec.DFREFPRICE*(rec.DFRATE/100));
                            v_QTTYRELEASE := floor(GREATEST(LEAST(v_TempRLSQTTY,rec.MAXRELEASE),0)/rec.LOT)*rec.LOT;
                            v_tmppaidamt := 0;
                            v_IsOK := FALSE;
                        ELSE
                            v_QTTYRELEASE := 0;
                            v_tmppaidamt := 0;
                            v_IsOK := FALSE;
                        END IF;
                        -- Ghep chuoi du lieu
                        --IF v_QTTYRELEASE >0 then
                            v_STRDATA := v_STRDATA || p_groupdealid || '|' || rec.ACCTNO || '|' || rec.AMTRELEASE || '|'
                                        || v_QTTYRELEASE || '|' || v_AMTPAID || '|' || v_INTPAID || '|' || v_FEEPAID || '|'
                                        || v_INTPENA || '|' || v_FEEPENA || '|' || rec.DEALTYPE || '|' || p_paidamt || '@';
                        --END IF;
                    END IF;
                END LOOP;
        END;

        plog.debug(pkgctx, 'v_STRDATA: '  || v_STRDATA);

        -- Thuc hien GD
        SELECT TO_CHAR(getcurrdate)
                   INTO v_strCURRDATE
        FROM DUAL;
        l_txmsg.msgtype     :='T';
        l_txmsg.local       :='N';
        l_txmsg.tlid        := systemnums.C_ONLINE_USERID;
        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                 SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
          INTO l_txmsg.wsname, l_txmsg.ipaddress
        FROM DUAL;
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txcompleted;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'DAY';
        l_txmsg.txdate      :=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.busdate     :=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.tltxcd      :='2646';

        --Set txnum
        SELECT systemnums.C_OL_PREFIXED
                         || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                  INTO l_txmsg.txnum
                  FROM DUAL;
        l_txmsg.brid        := substr(p_afacctno,1,4);

        IF p_desc IS NULL THEN
            SELECT TL.TXDESC
            INTO V_DESC
            FROM TLTX TL WHERE TLTXCD = '2646';
        ELSE
            V_DESC := p_desc;
        END IF;

        --Set cac field giao dich
        --03   AFACCTNO      C
        l_txmsg.txfields ('03').defname   := 'AFACCTNO';
        l_txmsg.txfields ('03').TYPE      := 'C';
        l_txmsg.txfields ('03').VALUE     := p_afacctno;
        --20   GROUPID      C
        l_txmsg.txfields ('20').defname   := 'GROUPID';
        l_txmsg.txfields ('20').TYPE      := 'C';
        l_txmsg.txfields ('20').VALUE     := p_groupdealid;
        --06   STRDATA      C
        l_txmsg.txfields ('06').defname   := 'STRDATA';
        l_txmsg.txfields ('06').TYPE      := 'C';
        l_txmsg.txfields ('06').VALUE     := v_STRDATA;
        --26   SUMPAID      C
        l_txmsg.txfields ('26').defname   := 'SUMPAID';
        l_txmsg.txfields ('26').TYPE      := 'N';
        l_txmsg.txfields ('26').VALUE     := p_paidamt;
        --34   AMTPAID      C
        l_txmsg.txfields ('34').defname   := 'AMTPAID';
        l_txmsg.txfields ('34').TYPE      := 'N';
        l_txmsg.txfields ('34').VALUE     := v_AMTPAID;
        --35   INTPAID      C
        l_txmsg.txfields ('35').defname   := 'INTPAID';
        l_txmsg.txfields ('35').TYPE      := 'N';
        l_txmsg.txfields ('35').VALUE     := v_INTPAID;
        --36   FEEPAID      C
        l_txmsg.txfields ('36').defname   := 'FEEPAID';
        l_txmsg.txfields ('36').TYPE      := 'N';
        l_txmsg.txfields ('36').VALUE     := v_FEEPAID;
        --30   DESC    C
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').VALUE     := V_DESC;

        BEGIN
            IF txpks_#2646.fn_autotxprocess (l_txmsg,
                                             p_err_code,
                                             l_err_param
               ) <> systemnums.c_success
            THEN
               plog.debug (pkgctx,
                           'got error 2646: ' || p_err_code
               );
               ROLLBACK;
               p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
               plog.error(pkgctx, 'Error:'  || p_err_message);
               plog.setendsection(pkgctx, 'pr_OnlinePaidDeal');
               RETURN;
            END IF;
        END;
        p_err_code:=0;
        plog.setendsection(pkgctx, 'pr_OnlinePaidDeal');

    EXCEPTION
        WHEN OTHERS
        THEN
             plog.debug (pkgctx,'got error on pr_PaidDealOnline');
             ROLLBACK;
             p_err_code := errnums.C_SYSTEM_ERROR;
             plog.error (pkgctx, SQLERRM);
             plog.setendsection (pkgctx, 'pr_PaidDealOnline');
             RAISE errnums.E_SYSTEM_ERROR;
    END pr_PaidDealOnline;
*/

-- Check active host & branch
function fn_CheckActiveSystem
    return number
as
    l_status char(1);
    v_HOBRID    VARCHAR(4);
    v_HOSTATUS  VARCHAR(1);
    v_BRSTATUS  VARCHAR(1);
    v_err_code  NUMBER;

BEGIN
    v_err_code := systemnums.C_SUCCESS;
    -- Kiem tra chi nhanh/ hoi so hien tai co active hay ko
    -- Neu bi dong thi ko cho phep dat lenh
    -- LAY MA CHI NHANH HOI SO
    /*SELECT VARVALUE
    INTO v_HOBRID
    FROM SYSVAR
    WHERE GRNAME = 'SYSTEM' AND VARNAME = 'HOBRID';
    -- LAY TRANG THAI CUA CHI NHANH
    SELECT BR.status
    INTO v_BRSTATUS
    FROM BRGRP BR
    WHERE BR.brid = v_HOBRID;
    -- NEU CHI NHANH DONG CUA THI BAO LOI
    IF v_BRSTATUS <> 'A' THEN
        v_err_code:=errnums.C_SA_BDS_OPERATION_ISINACTIVE;
        RETURN v_err_code;
    END IF;*/
    -- LAY TRANG THAI HOI SO
    SELECT VARVALUE
    INTO v_HOSTATUS
    FROM SYSVAR
    WHERE GRNAME = 'SYSTEM' AND VARNAME = 'HOSTATUS';
     -- NEU HOI SO DONG CUA THI BAO LOI
    IF v_HOSTATUS = '0' THEN
        v_err_code:=errnums.C_SA_HOST_OPERATION_ISINACTIVE;
        RETURN v_err_code;
    END IF;
    RETURN v_err_code;
exception
    when others then
        return errnums.C_SYSTEM_ERROR;
end;

-- LAY THONG TIN UNG TRUOC DA THUC HIEN
-- TheNN, 09-Feb-2012
PROCEDURE pr_GetDFTransHistory
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
    CUSTODYCD       IN VARCHAR2,
    AFACCTNO       IN  VARCHAR2,
    F_DATE         IN VARCHAR2,
    T_DATE         IN VARCHAR2,
    GROUPDFID      IN VARCHAR2,
    SYMBOL         IN   VARCHAR2
    )
    IS
    V_CUSTODYCD   VARCHAR2(10);
    V_AFACCTNO    VARCHAR2(10);
    V_FROMDATE    DATE;
    V_TODATE      DATE;
    V_GROUPDFID   VARCHAR2(50);
    V_SYMBOL      VARCHAR2(50);

BEGIN
    V_FROMDATE := TO_DATE(F_DATE,'DD/MM/YYYY');
    V_TODATE := TO_DATE(T_DATE,'DD/MM/YYYY');

    IF CUSTODYCD = 'ALL' OR CUSTODYCD IS NULL THEN
        V_CUSTODYCD := '%%';
    ELSE
        V_CUSTODYCD := CUSTODYCD;
    END IF;

    IF AFACCTNO = 'ALL' OR AFACCTNO IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := AFACCTNO;
    END IF;

    IF GROUPDFID = 'ALL' OR GROUPDFID IS NULL THEN
        V_GROUPDFID := '%%';
    ELSE
        V_GROUPDFID := GROUPDFID;
    END IF;

    IF SYMBOL = 'ALL' OR SYMBOL IS NULL THEN
        V_SYMBOL := '%%';
    ELSE
        V_SYMBOL := SYMBOL;
    END IF;

    -- LAY THONG TIN KHOAN VAY DA THUC HIEN
    OPEN p_REFCURSOR FOR
        SELECT A.* FROM
            (
                -- GIAO DICH TAO DEAL CAM CO (CHI TIET)
                SELECT TLG.TXDATE, TLG.TXNUM, TLG.TLTXCD, CF.CUSTODYCD, DFM.AFACCTNO, SE.SYMBOL, DFM.ACCTNO, DFM.GROUPID, DFM.LNACCTNO,
                    DFM.DFQTTY+DFM.RCVQTTY+DFM.BLOCKQTTY+DFM.CARCVQTTY+DFM.BQTTY+DFM.CACASHQTTY DFQTTY, DFM.RLSAMT+DFM.AMT DFAMT,
                    A1.CDCONTENT DFTYPE, DFM.DESCRIPTION
                FROM VW_TLLOG_ALL TLG, VW_DFMAST_ALL DFM, SBSECURITIES SE, AFMAST AF, CFMAST CF, ALLCODE A1
                WHERE TLG.TXDATE = DFM.TXDATE AND TLG.TXNUM = DFM.TXNUM AND DFM.CODEID = SE.CODEID
                    AND AF.CUSTID = CF.CUSTID AND AF.ACCTNO = DFM.AFACCTNO
                    AND TLG.TLTXCD IN ('2673')
                    AND A1.CDTYPE = 'DF' AND A1.CDNAME = 'DEALTYPE' AND A1.CDVAL = DFM.DEALTYPE
                    AND DFM.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                    AND DFM.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
                    AND CF.CUSTODYCD LIKE V_CUSTODYCD
                    AND DFM.AFACCTNO LIKE V_AFACCTNO
                    AND DFM.GROUPID LIKE V_GROUPDFID
                -- GIAO DICH THANH TOAN DEAL CAM CO (CHI TIET)
                -- CHUA CO LUONG GHI VAO TRAN TRONG BO NEN SE UPDATE SAU
            ) A
        ORDER BY A.TXDATE DESC, SUBSTR(A.TXNUM,5,6) DESC;
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GetDFTransHistory');
END pr_GetDFTransHistory;


---------------------------------------------------------------
-- Ham thuc hien cap han muc bao lanh tren man hinh MG cho TK luu ky noi khac
-- Dau vao: - p_custodycd: So TK luu ky
--          - p_afacctno: So tieu khoan
--          - p_amount: Han muc cap
--          - p_userid: Ma NSD
--          - p_desc: Mo ta GD
-- Dau ra:  - p_err_code: Ma loi tra ve. =0: thanh cong. <>0: Loi
--          - p_err_message: thong bao loi neu ma loi <>0
-- Created by: TheNN     Date: 16-Feb-2012
---------------------------------------------------------------
PROCEDURE pr_AllocateAVDL3rdAccount
    (   p_custodycd VARCHAR,
        p_afacctno varchar,
        p_amount  number,
        p_userid    varchar,
        p_desc varchar2,
        p_err_code  OUT varchar2,
        p_err_message  OUT varchar2
    )
    IS
        l_txmsg         tx.msg_rectype;
        v_strCURRDATE   varchar2(20);
        l_err_param     varchar2(300);

    BEGIN
        plog.setbeginsection(pkgctx, 'pr_AllocateAVDL3rdAccount');

        -- Check host & branch active or inactive
        p_err_code := fn_CheckActiveSystem;
        IF p_err_code <> systemnums.C_SUCCESS THEN
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_AllocateAVDL3rdAccount');
            return;
        END IF;
        -- End: Check host & branch active or inactive

        SELECT TO_CHAR(getcurrdate)
                   INTO v_strCURRDATE
        FROM DUAL;
        l_txmsg.msgtype     :='T';
        l_txmsg.local       :='N';
        l_txmsg.tlid        := p_userid;
        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                 SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
          INTO l_txmsg.wsname, l_txmsg.ipaddress
        FROM DUAL;
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txcompleted;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'DAY';
        l_txmsg.txdate      :=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.busdate     :=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.tltxcd      :='1186';

        --Set txnum
        SELECT systemnums.C_OL_PREFIXED
                         || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                  INTO l_txmsg.txnum
                  FROM DUAL;
        l_txmsg.brid        := substr(p_afacctno,1,4);

        --Set cac field giao dich
        --88   CUSTODYCD      C
        l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
        l_txmsg.txfields ('88').TYPE      := 'C';
        l_txmsg.txfields ('88').VALUE     := p_custodycd;
         --03   ACCTNO      C
        l_txmsg.txfields ('03').defname   := 'ACCTNO';
        l_txmsg.txfields ('03').TYPE      := 'C';
        l_txmsg.txfields ('03').VALUE     := p_afacctno;
         --90   CUSTNAME      C
        l_txmsg.txfields ('90').defname   := 'CUSTNAME';
        l_txmsg.txfields ('90').TYPE      := 'C';
        l_txmsg.txfields ('90').VALUE     := '';
         --95   FULLNAME      C
        l_txmsg.txfields ('95').defname   := 'FULLNAME';
        l_txmsg.txfields ('95').TYPE      := 'C';
        l_txmsg.txfields ('95').VALUE     := '';
         --91   ADDRESS      C
        l_txmsg.txfields ('91').defname   := 'ADDRESS';
        l_txmsg.txfields ('91').TYPE      := 'C';
        l_txmsg.txfields ('91').VALUE     := '';
         --92   LICENSE      C
        l_txmsg.txfields ('92').defname   := 'LICENSE';
        l_txmsg.txfields ('92').TYPE      := 'C';
        l_txmsg.txfields ('92').VALUE     := '';
         --93   IDDATE      C
        l_txmsg.txfields ('93').defname   := 'IDDATE';
        l_txmsg.txfields ('93').TYPE      := 'C';
        l_txmsg.txfields ('93').VALUE     := '';
         --94   IDPLACE      C
        l_txmsg.txfields ('94').defname   := 'IDPLACE';
        l_txmsg.txfields ('94').TYPE      := 'C';
        l_txmsg.txfields ('94').VALUE     := '';
        --10   TOAMT        N
        l_txmsg.txfields ('10').defname   := 'TOAMT';
        l_txmsg.txfields ('10').TYPE      := 'N';
        l_txmsg.txfields ('10').VALUE     := p_amount;
        --09   PP0        N
        l_txmsg.txfields ('09').defname   := 'PP0';
        l_txmsg.txfields ('09').TYPE      := 'N';
        l_txmsg.txfields ('09').VALUE     := 0;
        --11  NEWPP0        N
        l_txmsg.txfields ('11').defname   := 'NEWPP0';
        l_txmsg.txfields ('11').TYPE      := 'N';
        l_txmsg.txfields ('11').VALUE     := 0;
        --30   DESC    C
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').VALUE     := p_desc;

        BEGIN
            IF txpks_#1186.fn_autotxprocess (l_txmsg,
                                          p_err_code,
                                          l_err_param
                ) <> systemnums.c_success
            THEN
                plog.debug (pkgctx,
                            'got error 1186: ' || p_err_code
                );
                ROLLBACK;
                p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
                plog.error(pkgctx, 'Error:'  || p_err_message);
                plog.setendsection(pkgctx, 'pr_AllocateAVDL3rdAccount');
                RETURN;
            END IF;
        END;
        p_err_code:=0;
        plog.setendsection(pkgctx, 'pr_AllocateAVDL3rdAccount');
    EXCEPTION
        WHEN OTHERS
        THEN
             plog.debug (pkgctx,'got error on pr_AllocateAVDL3rdAccount');
             ROLLBACK;
             p_err_code := errnums.C_SYSTEM_ERROR;
             plog.error (pkgctx, SQLERRM);
             plog.setendsection (pkgctx, 'pr_AllocateAVDL3rdAccount');
             RAISE errnums.E_SYSTEM_ERROR;
    END pr_AllocateAVDL3rdAccount;

---------------------------------------------------------------
-- Ham thuc hien cap so du CK tren man hinh MG cho TK luu ky noi khac
-- Dau vao: - p_custodycd: So TK luu ky
--          - p_afacctno: So tieu khoan
--          - p_codeid: Ma quy uoc CK
--          - p_qtty: So CK cap them
--          - p_userid: Ma NSD
--          - p_desc: Mo ta GD
-- Dau ra:  - p_err_code: Ma loi tra ve. =0: thanh cong. <>0: Loi
--          - p_err_message: thong bao loi neu ma loi <>0
-- Created by: TheNN     Date: 16-Feb-2012
---------------------------------------------------------------
PROCEDURE pr_AllocateStock3rdAccount
    (   p_custodycd VARCHAR,
        p_afacctno varchar,
        p_symbol    VARCHAR,
        p_qtty  number,
        p_userid    varchar,
        p_desc varchar2,
        p_err_code  OUT varchar2,
        p_err_message  OUT varchar2
    )
    IS
        l_txmsg         tx.msg_rectype;
        v_strCURRDATE   varchar2(20);
        l_err_param     varchar2(300);
        v_CodeID        varchar2(20);

    BEGIN
        plog.setbeginsection(pkgctx, 'pr_AllocateStock3rdAccount');

        -- Check host & branch active or inactive
        p_err_code := fn_CheckActiveSystem;
        IF p_err_code <> systemnums.C_SUCCESS THEN
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_AllocateStock3rdAccount');
            return;
        END IF;
        -- End: Check host & branch active or inactive

        SELECT TO_CHAR(getcurrdate)
                   INTO v_strCURRDATE
        FROM DUAL;
        l_txmsg.msgtype     :='T';
        l_txmsg.local       :='N';
        l_txmsg.tlid        := p_userid;
        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                 SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
          INTO l_txmsg.wsname, l_txmsg.ipaddress
        FROM DUAL;
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txcompleted;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'DAY';
        l_txmsg.txdate      :=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.busdate     :=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.tltxcd      :='2286';

        --Set txnum
        SELECT systemnums.C_OL_PREFIXED
                         || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                  INTO l_txmsg.txnum
                  FROM DUAL;
        l_txmsg.brid        := substr(p_afacctno,1,4);

        -- Lay thong tin CK
        SELECT CODEID
        INTO v_CodeID
        FROM SBSECURITIES WHERE SYMBOL = p_symbol;

        --Set cac field giao dich
        --88   CUSTODYCD      C
        l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
        l_txmsg.txfields ('88').TYPE      := 'C';
        l_txmsg.txfields ('88').VALUE     := p_custodycd;
         --02   AFACCTNO      C
        l_txmsg.txfields ('02').defname   := 'AFACCTNO';
        l_txmsg.txfields ('02').TYPE      := 'C';
        l_txmsg.txfields ('02').VALUE     := p_afacctno;
         --03   ACCTNO      C
        l_txmsg.txfields ('03').defname   := 'ACCTNO';
        l_txmsg.txfields ('03').TYPE      := 'C';
        l_txmsg.txfields ('03').VALUE     := p_afacctno||v_CodeID;
         --01   CODEID      C
        l_txmsg.txfields ('01').defname   := 'CODEID';
        l_txmsg.txfields ('01').TYPE      := 'C';
        l_txmsg.txfields ('01').VALUE     := v_CodeID;
         --90   CUSTNAME      C
        l_txmsg.txfields ('90').defname   := 'CUSTNAME';
        l_txmsg.txfields ('90').TYPE      := 'C';
        l_txmsg.txfields ('90').VALUE     := '';
         --92   LICENSE      C
        l_txmsg.txfields ('92').defname   := 'LICENSE';
        l_txmsg.txfields ('92').TYPE      := 'C';
        l_txmsg.txfields ('92').VALUE     := '';
         --95   LICENSEDATE      C
        l_txmsg.txfields ('95').defname   := 'LICENSEDATE';
        l_txmsg.txfields ('95').TYPE      := 'C';
        l_txmsg.txfields ('95').VALUE     := '';
         --96   LICENSEPLACE      C
        l_txmsg.txfields ('96').defname   := 'LICENSEPLACE';
        l_txmsg.txfields ('96').TYPE      := 'C';
        l_txmsg.txfields ('96').VALUE     := '';
        --10   QTTY        N
        l_txmsg.txfields ('10').defname   := 'QTTY';
        l_txmsg.txfields ('10').TYPE      := 'N';
        l_txmsg.txfields ('10').VALUE     := p_qtty;
        --09   CURRQTTY        N
        l_txmsg.txfields ('09').defname   := 'CURRQTTY';
        l_txmsg.txfields ('09').TYPE      := 'N';
        l_txmsg.txfields ('09').VALUE     := 0;
        --11  NEWQTTY        N
        l_txmsg.txfields ('11').defname   := 'NEWQTTY';
        l_txmsg.txfields ('11').TYPE      := 'N';
        l_txmsg.txfields ('11').VALUE     := 0;
        --30   DESC    C
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').VALUE     := p_desc;

        BEGIN
            IF txpks_#2286.fn_autotxprocess (l_txmsg,
                                          p_err_code,
                                          l_err_param
                ) <> systemnums.c_success
            THEN
                plog.debug (pkgctx,
                            'got error 2286: ' || p_err_code
                );
                ROLLBACK;
                p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
                plog.error(pkgctx, 'Error:'  || p_err_message);
                plog.setendsection(pkgctx, 'pr_AllocateStock3rdAccount');
                RETURN;
            END IF;
        END;
        p_err_code:=0;
        plog.setendsection(pkgctx, 'pr_AllocateStock3rdAccount');
    EXCEPTION
        WHEN OTHERS
        THEN
             plog.debug (pkgctx,'got error on pr_AllocateStock3rdAccount');
             ROLLBACK;
             p_err_code := errnums.C_SYSTEM_ERROR;
             plog.error (pkgctx, SQLERRM);
             plog.setendsection (pkgctx, 'pr_AllocateStock3rdAccount');
             RAISE errnums.E_SYSTEM_ERROR;
    END pr_AllocateStock3rdAccount;

FUNCTION fn_GetRootOrderID
    (p_OrderID       IN  VARCHAR2
    ) RETURN VARCHAR2
AS
    v_Found     BOOLEAN;
    v_TempOrderid   varchar2(20);
    v_TempRootOrderID varchar2(20);

BEGIN
    v_Found := FALSE;
    v_TempOrderid := p_OrderID;

    WHILE v_Found = FALSE
    LOOP
        SELECT NVL(OD.REFORDERID, '0000')
        INTO v_TempRootOrderID
        FROM ODMAST OD WHERE OD.ORDERID = v_TempOrderid;
        IF v_TempRootOrderID <> '0000' THEN
            v_TempOrderid := v_TempRootOrderID;
            v_Found := FALSE;
        ELSE
            v_Found := TRUE;
        END IF;
    END LOOP;

    RETURN v_TempOrderid;

EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'fn_GetRootOrderID');
    RETURN '0000';
END;


PROCEDURE pr_get_gtcorder_root_hist
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTID    IN VARCHAR2,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     SYMBOL         IN  VARCHAR2,
     EXECTYPE      IN  VARCHAR2,
     STATUS         IN  VARCHAR2)
    IS

    V_AFACCTNO    VARCHAR2(10);
    V_SYMBOL      VARCHAR2(20);
    V_CUSTID      VARCHAR2(10);
    V_STATUS      VARCHAR2(2);
    V_EXECTYPE    VARCHAR2(2);
--Lay thong tin lenh dieu kien goc
--History
--Date          Who         Comment
--20120225      Loctx       add
BEGIN
    --V_CUSTID := CUSTID;
    --V_AFACCTNO := AFACCTNO;

    IF CUSTID = 'ALL' OR CUSTID IS NULL THEN
        V_CUSTID := '%%';
    ELSE
        V_CUSTID := CUSTID;
    END IF;

    IF SYMBOL = 'ALL' OR SYMBOL IS NULL THEN
        V_SYMBOL := '%%';
    ELSE
        V_SYMBOL := SYMBOL;
    END IF;

    IF AFACCTNO = 'ALL' OR AFACCTNO IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := AFACCTNO;
    END IF;

    IF EXECTYPE = 'ALL' OR EXECTYPE IS NULL THEN
        V_EXECTYPE := '%%';
    ELSE
        V_EXECTYPE := EXECTYPE;
    END IF;

    IF STATUS = 'ALL' OR STATUS IS NULL THEN
        V_STATUS := '%%';
    ELSE
        V_STATUS := STATUS;
    END IF;

    -- LAY THONG TIN LENH
    OPEN p_REFCURSOR FOR

        SELECT OD.AFACCTNO, OD.ORDERID, OD.TXDATE TXDATE, OD.EXECTYPE,--, A2.CDCONTENT EXECTYPE,
        OD.ORDERQTTY, OD.EXECQTTY, OD.CANCELQTTY, OD.REMAINQTTY,
        OD.QUOTEPRICE, OD.EXPDATE EXPDATE,
        A1.CDCONTENT ORSTATUS, A1.CDVAL ORSTATUSCD, OD.SYMBOL
        FROM
        (
            SELECT OD.AFACCTNO,
                    (CASE
                        WHEN OD.STATUS = 'A' THEN OD.ORGACCTNO
                        ELSE OD.ACCTNO
                    END
                    )ORDERID,
                    OD.EFFDATE TXDATE, OD.EXECTYPE, SB.SYMBOL,
                    OD.QUANTITY ORDERQTTY, OD.EXECQTTY, OD.CANCELQTTY, OD.REMAINQTTY,
                    OD.QUOTEPRICE * 1000 QUOTEPRICE, OD.EXPDATE,
                    /*(CASE
                        WHEN OD.REMAINQTTY > 0 AND OD.STATUS='A' AND OD.EXECQTTY>0 THEN '4'
                        WHEN OD.REMAINQTTY > 0 AND OD.STATUS='A' AND OD.EXECQTTY = 0 THEN '2'
                        WHEN OD.QUANTITY = OD.EXECQTTY AND OD.STATUS='A' THEN '12'
                        ELSE OD.STATUS
                    END
                    )STATUS*/
                    OD.STATUS
            FROM VW_FOMAST_ALL OD, AFMAST AF, SBSECURITIES SB
            WHERE OD.AFACCTNO = AF.ACCTNO
                AND OD.CODEID = SB.CODEID
                AND OD.TIMETYPE ='G'
                AND SUBSTR(OD.EXECTYPE,1,1) <> 'C'
                AND AF.CUSTID LIKE V_CUSTID
                AND AF.ACCTNO LIKE V_AFACCTNO
                AND SB.SYMBOL LIKE V_SYMBOL
                AND OD.STATUS LIKE V_STATUS
                AND OD.EXECTYPE LIKE V_EXECTYPE
                AND OD.EFFDATE >= TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT)
                AND OD.EFFDATE <= TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT)
        )OD, ALLCODE A1--, ALLCODE A2
        WHERE OD.STATUS = A1.CDVAL
        AND A1.CDTYPE ='FO'
        AND A1.CDNAME = 'STATUS'
        --AND OD.EXECTYPE = A2.CDVAL
        --AND A2.CDTYPE = 'FO'
        --AND A2.CDNAME = 'EXECTYPE'
        ORDER BY OD.AFACCTNO DESC;

EXCEPTION
  WHEN OTHERS THEN
    NULL;
    --plog.error(pkgctx, sqlerrm);
    --plog.setendsection(pkgctx, 'PR_GET_GTCORDER_ROOT_HIST');
END PR_GET_GTCORDER_ROOT_HIST;

-- TRA CUU THONG TIN GIAO DICH THANH TOAN CAM CO
PROCEDURE pr_GetDFPaidHistory
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
    pv_RowCount    IN OUT  NUMBER,
    pv_PageSize    IN  NUMBER,
    pv_PageIndex   IN  NUMBER,
    AFACCTNO       IN  VARCHAR2,
    GROUPDFID      IN VARCHAR2,
    F_DATE         IN VARCHAR2,
    T_DATE         IN VARCHAR2
    )
    IS
    V_AFACCTNO    VARCHAR2(10);
    V_FROMDATE    DATE;
    V_TODATE      DATE;
    V_GROUPDFID   VARCHAR2(50);
    v_RowCount    NUMBER;
    v_FromRow     NUMBER;
    v_ToRow       NUMBER;

BEGIN
    V_FROMDATE := TO_DATE(F_DATE,'DD/MM/YYYY');
    V_TODATE := TO_DATE(T_DATE,'DD/MM/YYYY');

    IF AFACCTNO = 'ALL' OR AFACCTNO IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := AFACCTNO;
    END IF;

    IF GROUPDFID = 'ALL' OR GROUPDFID IS NULL THEN
        V_GROUPDFID := '%%';
    ELSE
        V_GROUPDFID := GROUPDFID;
    END IF;

    -- LAY THONG TIN TONG SO DONG DU LIEU LAY RA DE PHAN TRANG
    /*IF pv_RowCount = 0 THEN
        SELECT COUNT(1)
        INTO v_RowCount
        FROM VW_DFTRAN_ALL DFT
        WHERE DFT.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
            AND DFT.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
            AND DFT.ACCTREF LIKE V_AFACCTNO
            AND DFT.ACCTNO LIKE V_GROUPDFID;
        pv_RowCount := v_RowCount;
    ELSE
        v_RowCount := pv_RowCount;
    END IF;

    IF pv_PageSize >0 AND pv_PageIndex >0 THEN
        v_FromRow := pv_PageSize*(pv_PageIndex - 1) +1;
        v_ToRow := v_FromRow + pv_PageSize - 1;
    ELSE
        v_FromRow := 1;
        v_ToRow := pv_PageSize;
    END IF;*/

    -- LAY THONG TIN KHOAN VAY DA THANH TOAN
    OPEN p_REFCURSOR FOR
        /*SELECT A.*
        FROM
            (
            SELECT ROWNUM ROWNUMBER, A.* FROM
                (*/
                SELECT TLG.TXDATE, TLG.TXNUM, TLG.TLTXCD, CF.CUSTODYCD, DFG.AFACCTNO AFACCTNO, DFG.GROUPID GROUPID, DFG.LNACCTNO LNACCTNO,
                    DFG.ORGAMT RLSAMT, TLG.MSGAMT PAIDAMT, TLG.TXDESC DESCRIPTION, DECODE(SUBSTR(TLG.TXNUM,1,2), '99','MS','PC') METHOD
                FROM (SELECT * FROM VW_TLLOG_ALL WHERE TLTXCD IN ('2646','2648')) TLG,
                    DFGROUP DFG, AFMAST AF, CFMAST CF
                WHERE AF.CUSTID = CF.CUSTID AND AF.ACCTNO = DFG.AFACCTNO
                    AND DFG.GROUPID =  TLG.MSGACCT
                    AND TLG.BUSDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                    AND TLG.BUSDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
                    AND DFG.AFACCTNO LIKE V_AFACCTNO
                    AND DFG.GROUPID LIKE V_GROUPDFID
                ORDER BY TLG.TXDATE DESC, TLG.AUTOID DESC;
                /*
                SELECT TLG.TXDATE, TLG.TXNUM, TLG.TLTXCD, CF.CUSTODYCD, DFG.AFACCTNO AFACCTNO, DFG.GROUPID GROUPID, DFG.LNACCTNO LNACCTNO,
                    DFG.ORGAMT RLSAMT, DFT.NAMT PAIDAMT, TLG.TXDESC DESCRIPTION
                FROM (SELECT * FROM VW_TLLOG_ALL WHERE TLTXCD IN ('2646','2648')) TLG,
                    DFGROUP DFG, VW_DFTRAN_ALL DFT, AFMAST AF, CFMAST CF
                WHERE TLG.TXDATE = DFT.TXDATE AND TLG.TXNUM = DFT.TXNUM
                    AND AF.CUSTID = CF.CUSTID AND AF.ACCTNO = DFG.AFACCTNO
                    AND DFG.GROUPID =  DFT.ACCTNO
                    AND TLG.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                    AND TLG.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
                    AND DFG.AFACCTNO LIKE V_AFACCTNO
                    AND DFG.GROUPID LIKE V_GROUPDFID
                ORDER BY TLG.TXDATE DESC, TLG.AUTOID DESC, SUBSTR(TLG.TXNUM,5,6) DESC*/
                /*) A
            ) A
        WHERE A.ROWNUMBER BETWEEN v_FromRow AND v_ToRow;*/
                -- GIAO DICH THANH TOAN DEAL CAM CO (CHI TIET)
                -- CHUA CO LUONG GHI VAO TRAN TRONG BO NEN SE UPDATE SAU

                /*
                -- GIAO DICH TAO DEAL CAM CO (CHI TIET)
                SELECT TLG.TXDATE, TLG.TXNUM, TLG.TLTXCD, CF.CUSTODYCD, DFM.AFACCTNO, SE.SYMBOL, DFM.ACCTNO, DFM.GROUPID, DFM.LNACCTNO,
                    DFM.DFQTTY+DFM.RCVQTTY+DFM.BLOCKQTTY+DFM.CARCVQTTY+DFM.BQTTY+DFM.CACASHQTTY DFQTTY, DFM.RLSAMT+DFM.AMT DFAMT,
                    A1.CDCONTENT DFTYPE, DFM.DESCRIPTION
                FROM VW_TLLOG_ALL TLG, VW_DFMAST_ALL DFM, SBSECURITIES SE, AFMAST AF, CFMAST CF, ALLCODE A1
                WHERE TLG.TXDATE = DFM.TXDATE AND TLG.TXNUM = DFM.TXNUM AND DFM.CODEID = SE.CODEID
                    AND AF.CUSTID = CF.CUSTID AND AF.ACCTNO = DFM.AFACCTNO
                    AND TLG.TLTXCD IN ('2673')
                    AND A1.CDTYPE = 'DF' AND A1.CDNAME = 'DEALTYPE' AND A1.CDVAL = DFM.DEALTYPE
                    AND DFM.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                    AND DFM.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
                    AND CF.CUSTODYCD LIKE V_CUSTODYCD
                    AND DFM.AFACCTNO LIKE V_AFACCTNO
                    AND DFM.GROUPID LIKE V_GROUPDFID
                -- GIAO DICH THANH TOAN DEAL CAM CO (CHI TIET)
                -- CHUA CO LUONG GHI VAO TRAN TRONG BO NEN SE UPDATE SAU
                */
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GetDFPaidHistory');
END pr_GetDFPaidHistory;

-- LAY CHI TIET SO CK GIAI TOA (GD 2246 ONLY)
-- THENN, 04-MAR-2012
PROCEDURE pr_GetDFPaidDetail
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
    pv_TXDATE       IN  VARCHAR2,
    pv_TXNUM      IN VARCHAR2
    )
    IS

BEGIN

    -- LAY THONG TIN KHOAN VAY DA THANH TOAN
    OPEN p_REFCURSOR FOR
        SELECT DFT.TXDATE, DFT.TXNUM, DFT.TLTXCD, DF.AFACCTNO AFACCTNO, DF.GROUPID GROUPID, DF.LNACCTNO LNACCTNO,
            SB.SYMBOL, DFT.NAMT PAIDQTTY
        FROM DFMAST DF, AFMAST AF, sbsecurities SB,
            (SELECT * FROM vw_dftran_all
            WHERE TLTXCD = '2646'
                AND TXDATE = TO_DATE(pv_TXDATE,'DD/MM/YYYY')
                AND TXNUM = pv_TXNUM
                AND TXCD ='0011'
                ) DFT
        WHERE AF.ACCTNO = DF.AFACCTNO
            AND DF.acctno = DFT.ACCTNO
            AND DF.codeid = SB.codeid
        ORDER BY DFT.TXDATE DESC, DFT.AUTOID DESC;

EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GetDFPaidDetail');
END pr_GetDFPaidDetail;

---------------------------------------------------------------
-- Ham thuc hien cap nhat suc mua cho man hinh moi gioi
-- Dau vao: - p_afacctno: So tieu khoan
-- Dau ra:  - p_err_code: Ma loi tra ve. =0: thanh cong. <>0: Loi
--          - p_err_message: thong bao loi neu ma loi <>0
-- Created by: TheNN     Date: 30-Mar-2012
---------------------------------------------------------------
PROCEDURE pr_RefreshCIAccount
    (   p_afacctno varchar,
        p_err_code  OUT varchar2,
        p_err_message  OUT varchar2
    )
    IS
        v_strAFACCTNO   varchar2(20);

    BEGIN
        plog.setbeginsection(pkgctx, 'pr_RefreshCIAccount');
        p_err_code := 0;
        p_err_message := '';

        IF p_afacctno IS NULL OR p_afacctno = '' THEN
            plog.setendsection(pkgctx, 'pr_RefreshCIAccount');
            RETURN;
        ELSE
            v_strAFACCTNO := p_afacctno;
            pr_gen_buf_ci_account(v_strAFACCTNO);
        END IF;
        p_err_code:=0;
        plog.setendsection(pkgctx, 'pr_RefreshCIAccount');
    EXCEPTION
        WHEN OTHERS
        THEN
             plog.debug (pkgctx,'got error on pr_RefreshCIAccount');
             ROLLBACK;
             p_err_code := errnums.C_SYSTEM_ERROR;
             plog.error (pkgctx, SQLERRM);
             plog.setendsection (pkgctx, 'pr_RefreshCIAccount');
             RAISE errnums.E_SYSTEM_ERROR;
    END pr_RefreshCIAccount;
--Binhpt tra cuu c?su kien quyen kh? h?
--F_DATE tu ngay
--T_DATE den ngay
--PV_CUSTODYCD so luu ky
--PV_AFACCTNO so tieu khoan
--V_STRISCOM Da phan bo hay chua
procedure pr_get_rightinfo
    (p_refcursor in out pkg_report.ref_cursor,
    F_DATE in VARCHAR2,
    T_DATE  IN  varchar2,
    PV_CUSTODYCD  IN  VARCHAR2,
    PV_AFACCTNO  IN  VARCHAR2,
    ISCOM             IN       VARCHAR2)
IS
    V_STRACCTNO    VARCHAR2 (20);
    V_STRCUSTODYCD     VARCHAR2 (20);
    V_STRISCOM   VARCHAR2 (40);
begin
    plog.setbeginsection(pkgctx, 'pr_get_rightinfo');
    IF (ISCOM = 'Y')
   THEN
   V_STRISCOM := 'JC';
   ELSIF  (ISCOM = 'N')
   THEN
   V_STRISCOM := 'MAIPNSDRGHVBEW';
   ELSE
   V_STRISCOM := 'MAIPNSCDRGHJVBEW';
   END IF;

    IF PV_CUSTODYCD = 'ALL' OR PV_CUSTODYCD is NULL THEN
        V_STRCUSTODYCD := '%%';
    ELSE
        V_STRCUSTODYCD := PV_CUSTODYCD;
    END IF;

    IF PV_AFACCTNO = 'ALL' OR PV_AFACCTNO IS NULL THEN
        V_STRACCTNO := '%%';
    ELSE
        V_STRACCTNO := PV_AFACCTNO;
    END IF;
    Open p_refcursor for
          SELECT ca.acctno, ca.custodycd, ca.fullname, ca.mobile, ca.idcode,
        ca.trade SLCKSH,TYLE,CATYPE,  STATUS, Ca.CAMASTID, CA.AMT,SYMBOL,
        TOSYMBOL, TOCODEID, REPORTDATE, SLCKCV, STCV, ACTIONDATE, ca.CODEID, CASTATUS
FROM
(SELECT AF.ACCTNO, CF.CUSTODYCD, CF.FULLNAME, CF.MOBILE, CF.IDCODE, CAS.BALANCE ,
            (DECODE(CAM.CATYPE, '001',DEVIDENTRATE,
                                '010',(case when devidentvalue = 0 and DEVIDENTRATE <> '0' then DEVIDENTRATE || '%' else to_char(devidentvalue) end),
                                '002',DEVIDENTSHARES,
                                '011',DEVIDENTSHARES,
                                '003',RIGHTOFFRATE,
                                '014',RIGHTOFFRATE,
                                '004',SPLITRATE,
                                '012',SPLITRATE,
                                '006',DEVIDENTSHARES,
                                '005',devidentshares,
                                '022',DEVIDENTSHARES,
                                '021',EXRATE,
                                '023',EXRATE,
                                '007',INTERESTRATE,
                                '008',EXRATE,
                                '017',EXRATE,
                                '015',interestrate || '%',
                                '016',interestrate || '%',
                                '020',devidentshares
                                )
                ) TYLE,
            A0.CDCONTENT CATYPE,  A1.CDCONTENT STATUS, CAM.CAMASTID, CAS.AMT
            , SE.SYMBOL, CAM.REPORTDATE,  CAS.QTTY SLCKCV, CAS.AMT STCV, CAM.ACTIONDATE,
            SE.CODEID CODEID, NVL(SB2.SYMBOL,se.symbol) TOSYMBOL, NVL(CAM.TOCODEID,CAM.CODEID) TOCODEID,
            CAM.STATUS CASTATUS, cas.trade, cam.catype typeca
        FROM CASCHD CAS, SBSECURITIES SE, CAMAST CAM, AFMAST AF, CFMAST CF, ALLCODE A0, ALLCODE A1, SBSECURITIES SB2
        WHERE CAS.CODEID = SE.CODEID
        AND NVL(TOCODEID,CAM.codeid) = SB2.CODEID
        AND CAM.CAMASTID = CAS.CAMASTID
        AND CAS.AFACCTNO = AF.ACCTNO
        AND AF.CUSTID = CF.CUSTID
        AND A0.CDTYPE = 'CA' AND A0.CDNAME = 'CATYPE' AND A0.CDVAL = CAM.CATYPE
        AND A1.CDTYPE = 'CA' AND A1.CDNAME = 'CASTATUS' AND A1.CDVAL = CAS.STATUS
        AND CAM.CATYPE NOT IN ('002','019')
        AND CAS.AFACCTNO  LIKE V_STRACCTNO
        and cas.deltd <>'Y'
        and cam.deltd <>'Y'
) CA
WHERE (( CA.CASTATUS NOT IN ('A','N','P'))OR (CA.CASTATUS IN ('S','W','I','C','J','I','H')))
AND INSTR(V_STRISCOM, CA.CASTATUS )> 0
AND CA.REPORTDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
AND CA.REPORTDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
ORDER  BY SUBSTR(CA.CAMASTID,11,6) DESC;
    plog.setendsection(pkgctx, 'pr_get_rightinfo');
exception when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'pr_get_rightinfo');
end pr_get_rightinfo;

-- Lay danh sach chuyen doi trai phieu thanh co phieu
-- TheNN, 16-Jul-2012
PROCEDURE pr_GetBonds2SharesList
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD    IN VARCHAR2,
     AFACCTNO       IN  VARCHAR2
     )
    IS

    V_CUSTODYCD   VARCHAR2(10);
    V_AFACCTNO    VARCHAR2(10);
    V_CUSTID      VARCHAR2(10);

BEGIN
    V_CUSTODYCD := CUSTODYCD;
    --V_AFACCTNO := AFACCTNO;

    IF AFACCTNO = 'ALL' OR AFACCTNO IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := AFACCTNO;
    END IF;

    -- LAY THONG TIN MA KHACH HANG
    IF V_CUSTODYCD IS NULL OR V_CUSTODYCD = 'ALL' THEN
        V_CUSTID := '%%';
    ELSE
        SELECT CUSTID INTO V_CUSTID FROM CFMAST WHERE CUSTODYCD = V_CUSTODYCD;
    END IF;


    -- LAY THONG TIN GD QUYEN MUA
    OPEN p_REFCURSOR FOR
        SELECT CA.CAMASTID,CF.CUSTODYCD,AF.ACCTNO AFACCTNO,SEC1.SYMBOL,SEC2.SYMBOL TOSYMBOL,
            CA.REPORTDATE,SCHD.PQTTY,SCHD.TRADE,(SCHD.PQTTY+SCHD.QTTY) MAXQTTY,
            SCHD.QTTY,CA.BEGINDATE,CA.DUEDATE,SCHD.AUTOID,SEC1.CODEID,SEC2.CODEID TOCODEID,CA.EXRATE
        FROM CAMAST CA, CASCHD SCHD,CFMAST CF, AFMAST AF,SBSECURITIES SEC1, SBSECURITIES SEC2
        WHERE CA.CAMASTID=SCHD.CAMASTID
            AND SCHD.AFACCTNO=AF.ACCTNO AND AF.CUSTID=CF.CUSTID
            AND CA.CODEID=SEC1.CODEID AND CA.TOCODEID=SEC2.CODEID
            AND TO_DATE(CA.BEGINDATE,'DD/MM/YYYY') <= TO_DATE(GETCURRDATE,'DD/MM/YYYY')
            AND TO_DATE(CA.DUEDATE,'DD/MM/YYYY') >= TO_DATE(GETCURRDATE,'DD/MM/YYYY')
            AND CA.CATYPE='023' AND SCHD.STATUS='V'
            AND SCHD.PQTTY>=1
            AND SCHD.DELTD='N'
            AND CF.CUSTID LIKE V_CUSTID
            AND AF.ACCTNO LIKE V_AFACCTNO
        ORDER BY CA.CAMASTID;

EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GetBonds2SharesList');
END pr_GetBonds2SharesList;

-- Ham thuc hien dang ky chuyen doi trai phieu thanh co phieu
-- TheNN, 16-Jul-2012
PROCEDURE pr_Bonds2SharesRegister
    (p_caschdautoid IN   varchar,
    p_afacctno   IN   varchar,
    p_qtty      IN   number,
    p_desc      IN   varchar2,
    p_err_code  OUT varchar2,
    p_err_message  OUT varchar2,
    p_ipaddress in  varchar2 default '' , --1.5.3.0
    p_via in varchar2 default '',
    p_validationtype in varchar2 default '',
    p_devicetype IN varchar2 default '',
    p_device  IN varchar2 default ''
    )
  IS
      l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      l_err_param varchar2(300);
      l_symbol  varchar2(20);
      l_tosymbol    varchar2(20);
      l_codeid   varchar2(20);
      l_tocodeid    varchar2(20);
      l_camastid varchar2(20);
      l_fullname    varchar2(100);
      l_custodycd   varchar2(10);
      l_PQTTY   NUMBER;

  BEGIN
    plog.setbeginsection(pkgctx, 'pr_Bonds2SharesRegister');

    -- Check host & branch active or inactive
    p_err_code := fn_CheckActiveSystem;
    IF p_err_code <> systemnums.C_SUCCESS THEN
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_Bonds2SharesRegister');
        return;
    END IF;
    -- End: Check host & branch active or inactive

    SELECT TO_DATE (varvalue, systemnums.c_date_format)
               INTO v_strCURRDATE
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := systemnums.C_ONLINE_USERID;
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    --1.5.3.0
    if (p_ipaddress is not null ) then l_txmsg.ipaddress:= substr(p_ipaddress,1,20); end if;--1.6.1.9; MSBS-2209  substr
    --
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := 'DAY';
    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd:='3327';

    --Set txnum
    SELECT systemnums.C_OL_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO l_txmsg.txnum
              FROM DUAL;
    l_txmsg.brid        := substr(p_afacctno,1,4);

    --p_txnum:=l_txmsg.txnum;
    --p_txdate:=l_txmsg.txdate;

    SELECT CA.CAMASTID,CF.CUSTODYCD,SEC1.SYMBOL,SEC2.SYMBOL TOSYMBOL,
        SEC1.CODEID,SEC2.CODEID TOCODEID,SCHD.PQTTY
    INTO l_camastid, l_custodycd, l_symbol, l_tosymbol, l_codeid, l_tocodeid, l_PQTTY
    FROM CAMAST CA, CASCHD SCHD,CFMAST CF, AFMAST AF,SBSECURITIES SEC1, SBSECURITIES SEC2
    WHERE CA.CAMASTID=SCHD.CAMASTID
        AND SCHD.AFACCTNO=AF.ACCTNO AND AF.CUSTID=CF.CUSTID
        AND CA.CODEID=SEC1.CODEID AND CA.TOCODEID=SEC2.CODEID
        AND CA.CATYPE='023' AND SCHD.STATUS='V'
        AND SCHD.PQTTY>=1
        AND SCHD.DELTD='N'
        AND schd.autoid = p_caschdautoid;

    -- Kiem tra SL dang ky khong duoc vuot qua SL con co the dang ky
    IF p_qtty > l_PQTTY THEN
        p_err_code := -300021; -- Vuot qua so CK duoc phep mua
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_Bonds2SharesRegister');
        return;
    END IF;


    --Set cac field giao dich
    --01   AUTOID      C
    l_txmsg.txfields ('01').defname   := 'AUTOID';
    l_txmsg.txfields ('01').TYPE      := 'C';
    l_txmsg.txfields ('01').VALUE     := p_caschdautoid;
    --02   CAMASTID      C
    l_txmsg.txfields ('02').defname   := 'CAMASTID';
    l_txmsg.txfields ('02').TYPE      := 'C';
    l_txmsg.txfields ('02').VALUE     := l_camastid;
    --03   AFACCTNO      C
    l_txmsg.txfields ('03').defname   := 'AFACCTNO';
    l_txmsg.txfields ('03').TYPE      := 'C';
    l_txmsg.txfields ('03').VALUE     := p_afacctno;
    --04   SYMBOL        C
    l_txmsg.txfields ('04').defname   := 'SYMBOL';
    l_txmsg.txfields ('04').TYPE      := 'C';
    l_txmsg.txfields ('04').VALUE     := l_symbol;
    --05   TOSYMBOL        C
    l_txmsg.txfields ('05').defname   := 'TOSYMBOL';
    l_txmsg.txfields ('05').TYPE      := 'C';
    l_txmsg.txfields ('05').VALUE     := l_tosymbol;
    --08   FULLNAME      C
    l_txmsg.txfields ('08').defname   := 'FULLNAME';
    l_txmsg.txfields ('08').TYPE      := 'C';
    l_txmsg.txfields ('08').VALUE     := l_fullname;
    --10   QTTY          N
    l_txmsg.txfields ('10').defname   := 'QTTY';
    l_txmsg.txfields ('10').TYPE      := 'N';
    l_txmsg.txfields ('10').VALUE     := p_qtty;
    --21   CODEID        C
    l_txmsg.txfields ('21').defname   := 'CODEID';
    l_txmsg.txfields ('21').TYPE      := 'C';
    l_txmsg.txfields ('21').VALUE     := l_codeid;
    --24   TOCODEID        C
    l_txmsg.txfields ('24').defname   := 'TOCODEID';
    l_txmsg.txfields ('24').TYPE      := 'C';
    l_txmsg.txfields ('24').VALUE     := l_tocodeid;
    --30   DESCRIPTION   C
    l_txmsg.txfields ('30').defname   := 'DESCRIPTION';
    l_txmsg.txfields ('30').TYPE      := 'C';
    l_txmsg.txfields ('30').VALUE     := p_desc;
    --96   CUSTODYCD    C
    l_txmsg.txfields ('96').defname   := 'CUSTODYCD';
    l_txmsg.txfields ('96').TYPE      := 'C';
    l_txmsg.txfields ('96').VALUE     := l_custodycd;

    plog.error(pkgctx, 'AUTOID:'  || p_caschdautoid);
    plog.error(pkgctx, 'CAMASTID:'  || l_camastid);

    BEGIN
        IF txpks_#3327.fn_autotxprocess (l_txmsg,
                                         p_err_code,
                                         l_err_param
           ) <> systemnums.c_success
        THEN
           plog.error (pkgctx,
                       'got error 3327: ' || p_err_code
           );
           ROLLBACK;
           p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
           plog.error(pkgctx, 'Error:3327: '  || p_err_message);
           plog.setendsection(pkgctx, 'pr_Bonds2SharesRegister');
           RETURN;
        END IF;
    END;
    p_err_code:=0;
    --1.5.3.0
    pr_insertiplog( l_txmsg.txnum,  l_txmsg.txdate, l_txmsg.ipaddress, p_via, p_validationtype, p_devicetype, p_device, p_err_code);
    plog.setendsection(pkgctx, 'pr_Bonds2SharesRegister');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.error (pkgctx,'got error on pr_Bonds2SharesRegister');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, 'got error on pr_Bonds2SharesRegister'||SQLERRM);
      plog.setendsection (pkgctx, 'pr_Bonds2SharesRegister');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_Bonds2SharesRegister;

  --Binhpt lay thong tin du no
  --Lay thong tin du no
PROCEDURE pr_LoanHist
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD    IN VARCHAR2,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2
     )
    IS
    V_CUSTODYCD   VARCHAR2(10);
    V_AFACCTNO    VARCHAR2(10);
BEGIN
    IF AFACCTNO = 'ALL' OR AFACCTNO IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := AFACCTNO;
    END IF;
    IF CUSTODYCD IS NULL OR CUSTODYCD = 'ALL' THEN
        V_CUSTODYCD := '%%';
    ELSE
        V_CUSTODYCD:=CUSTODYCD;
    END IF;
    -- LAY THONG TIN DU NO
    OPEN p_REFCURSOR FOR
        SELECT V_DEAL.GROUPID,TY.TYPENAME, CF.CUSTODYCD, AF.ACCTNO AFACCTNO, LN.ACCTNO LNACCTNO,
                 ROUND( SCHD.INTOVDPRIN + SCHD.FEEINTOVDACR+SCHD.INTNMLACR  + SCHD.INTOVD + SCHD.INTDUE + SCHD.FEEINTNMLACR + SCHD.FEEINTDUE + SCHD.FEEINTNMLOVD+SCHD.NML + SCHD.OVD) TOTALLOAN,
                 SCHD.RLSDATE,
                 SCHD.NML + SCHD.OVD PRINCIPAL,
                 SCHD.NML + SCHD.OVD + SCHD.PAID RLSAMT,
                 SCHD.PAID PRINPAID,
                 SCHD.INTPAID + SCHD.FEEINTPAID + SCHD.FEEINTPREPAID INTPAID, 0 DFRATE
                 ,case when ROUND( SCHD.INTOVDPRIN + SCHD.FEEINTOVDACR+SCHD.INTNMLACR  + SCHD.INTOVD + SCHD.INTDUE + SCHD.FEEINTNMLACR + SCHD.FEEINTDUE + SCHD.FEEINTNMLOVD+SCHD.NML + SCHD.OVD) > 0 then   SCHD.DAYS
                       else DATEDIFF('D', schd.rlsdate, schd.PAIDDATE) end DAYS,
                 SCHD.INTNMLACR  + SCHD.INTOVD + SCHD.INTDUE + SCHD.FEEINTNMLACR + SCHD.FEEINTDUE + SCHD.FEEINTNMLOVD INTNML,
                 SCHD.INTOVDPRIN + SCHD.FEEINTOVDACR INTOVD,
                 SCHD.OVERDUEDATE, NVL(V_DEAL.IRATE, 0) IRATE,
                 NVL(V_DEAL.RTTDF, 0) RTTDF, NVL(V_DEAL.ODCALLRTTDF, 0) ODCALLRTTDF, SCHD.REFTYPE
            FROM CFMAST CF, AFMAST AF, LNMAST LN, LNTYPE TY,
                 (SELECT LNSCHD.*,DATEDIFF('D', RLSDATE, GETCURRDATE) DAYS FROM LNSCHD WHERE REFTYPE IN ('GP', 'P') AND DUENO = 0
                    union all
                 select lnschdhist.*, DATEDIFF('D', RLSDATE, GETCURRDATE) DAYS FROM LNSCHDhist WHERE REFTYPE IN ('GP', 'P') AND DUENO = 0
                 ) SCHD, V_GETGRPDEALFORMULAR V_DEAL
           WHERE AF.CUSTID = CF.CUSTID
             AND AF.ACCTNO = LN.TRFACCTNO
             AND LN.ACTYPE = TY.ACTYPE
             AND SCHD.ACCTNO = LN.ACCTNO
             AND LN.ACCTNO = V_DEAL.LNACCTNO(+)
             AND CF.CUSTODYCD like V_CUSTODYCD
             AND AF.ACCTNO like V_AFACCTNO
             --AND SCHD.NML + SCHD.OVD + SCHD.INTNMLACR + SCHD.INTOVDPRIN + SCHD.INTDUE + SCHD.FEEINTNMLACR + SCHD.FEEINTDUE + SCHD.FEEINTOVDACR + SCHD.INTOVD + SCHD.FEEINTNMLOVD > 0
             AND SCHD.RLSDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
             AND SCHD.RLSDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
           ORDER BY LN.ACCTNO;
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_LoanHist');
END pr_LoanHist;

-- Ham thuc hien giao dich gui tiet kiem
-- TheNN, 01-Aug-2012
PROCEDURE pr_CreateTermDeposit
    (p_afacctno IN  varchar,
    p_tdactype  IN  VARCHAR,
    p_amt       IN  number,
    p_auto       IN  VARCHAR,
    p_desc      IN  varchar2,
    p_err_code  OUT varchar2,
    p_err_message  OUT varchar2
    )
  IS
      l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      l_err_param varchar2(300);

      v_CUSTODYCD   varchar2(10);
      v_CUSTNAME    varchar2(100);
      v_ADDRESS     varchar2(500);
      v_LICENSE     varchar2(100);
      v_TDTERM      NUMBER;
      v_TERMCD      varchar2(10);
      v_TDSRC       varchar2(10);
      v_CIACCTNO    varchar2(10);
      v_ISCI        NUMBER;
      v_SCHDTYPE    varchar2(10);
      v_INTRATE     NUMBER;
      v_SPREADTERM  NUMBER;
      v_SPREADRATE  NUMBER;
      v_MINBRTERM  NUMBER;

  BEGIN
    plog.setbeginsection(pkgctx, 'pr_CreateTermDeposit');

    -- Check host & branch active or inactive
    p_err_code := fn_CheckActiveSystem;
    IF p_err_code <> systemnums.C_SUCCESS THEN
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_CreateTermDeposit');
        return;
    END IF;
    -- End: Check host & branch active or inactive

    SELECT TO_DATE (varvalue, systemnums.c_date_format)
               INTO v_strCURRDATE
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := systemnums.C_ONLINE_USERID;
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := 'DAY';
    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd:='1670';

    --Set txnum
    SELECT systemnums.C_OL_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO l_txmsg.txnum
              FROM DUAL;
    l_txmsg.brid        := substr(p_afacctno,1,4);

    -- Lay thong tin cua tieu khoan
    SELECT CF.custodycd, CF.fullname, CF.address, CF.idcode
    INTO v_CUSTODYCD, v_CUSTNAME, v_ADDRESS, v_LICENSE
    FROM CFMAST CF, AFMAST AF
    WHERE CF.custid = AF.custid
        AND AF.acctno = p_afacctno;
    -- Lay thong tin loai hinh tiet kiem
    SELECT TYP.TDTERM, TERMCD, SCHDTYPE, TDSRC,
        TYP.INTRATE, TYP.SPREADTERM, TYP.SPREADRATE, TYP.CIACCTNO,
        (CASE WHEN TYP.TDSRC='O' THEN 1 ELSE 0 END) ISCI, TYP.MINBRTERM
    INTO v_TDTERM, v_TERMCD, v_SCHDTYPE, v_TDSRC, v_INTRATE, v_SPREADTERM, v_SPREADRATE, v_CIACCTNO, v_ISCI, v_MINBRTERM
    FROM TDTYPE TYP
    WHERE TYP.actype = p_tdactype;

    --Set cac field giao dich
    --99   CUSTODYCD      C
    l_txmsg.txfields ('99').defname   := 'CUSTODYCD';
    l_txmsg.txfields ('99').TYPE      := 'C';
    l_txmsg.txfields ('99').VALUE     := v_CUSTODYCD;
    --03   ACCTNO      C
    l_txmsg.txfields ('03').defname   := 'ACCTNO';
    l_txmsg.txfields ('03').TYPE      := 'C';
    l_txmsg.txfields ('03').VALUE     := p_afacctno;
    --90   CUSTNAME      C
    l_txmsg.txfields ('90').defname   := 'CUSTNAME';
    l_txmsg.txfields ('90').TYPE      := 'C';
    l_txmsg.txfields ('90').VALUE     := v_CUSTNAME;
    --91   ADDRESS      C
    l_txmsg.txfields ('91').defname   := 'ADDRESS';
    l_txmsg.txfields ('91').TYPE      := 'C';
    l_txmsg.txfields ('91').VALUE     := v_ADDRESS;
    --92   LICENSE      C
    l_txmsg.txfields ('92').defname   := 'LICENSE';
    l_txmsg.txfields ('92').TYPE      := 'C';
    l_txmsg.txfields ('92').VALUE     := v_LICENSE;
    --81   ACTYPE      C
    l_txmsg.txfields ('81').defname   := 'ACTYPE';
    l_txmsg.txfields ('81').TYPE      := 'C';
    l_txmsg.txfields ('81').VALUE     := p_tdactype;
    --82   TDTERM          N
    l_txmsg.txfields ('82').defname   := 'TDTERM';
    l_txmsg.txfields ('82').TYPE      := 'N';
    l_txmsg.txfields ('82').VALUE     := v_TDTERM;
    --80   TERMCD      C
    l_txmsg.txfields ('80').defname   := 'TERMCD';
    l_txmsg.txfields ('80').TYPE      := 'C';
    l_txmsg.txfields ('80').VALUE     := v_TERMCD;
    --87   TDSRC      C
    l_txmsg.txfields ('87').defname   := 'TDSRC';
    l_txmsg.txfields ('87').TYPE      := 'C';
    l_txmsg.txfields ('87').VALUE     := v_TDSRC;
    --06   CIACCTNO      C
    l_txmsg.txfields ('06').defname   := 'CIACCTNO';
    l_txmsg.txfields ('06').TYPE      := 'C';
    l_txmsg.txfields ('06').VALUE     := v_CIACCTNO;
    --88   ISCI          N
    l_txmsg.txfields ('88').defname   := 'ISCI';
    l_txmsg.txfields ('88').TYPE      := 'N';
    l_txmsg.txfields ('88').VALUE     := v_ISCI;
    --83   SCHDTYPE      C
    l_txmsg.txfields ('83').defname   := 'SCHDTYPE';
    l_txmsg.txfields ('83').TYPE      := 'C';
    l_txmsg.txfields ('83').VALUE     := v_SCHDTYPE;
    --84   INTRATE          N
    l_txmsg.txfields ('84').defname   := 'INTRATE';
    l_txmsg.txfields ('84').TYPE      := 'N';
    l_txmsg.txfields ('84').VALUE     := v_INTRATE;
    --85   SPREADTERM          N
    l_txmsg.txfields ('85').defname   := 'SPREADTERM';
    l_txmsg.txfields ('85').TYPE      := 'N';
    l_txmsg.txfields ('85').VALUE     := v_SPREADTERM;
    --86   SPREADRATE          N
    l_txmsg.txfields ('86').defname   := 'SPREADRATE';
    l_txmsg.txfields ('86').TYPE      := 'N';
    l_txmsg.txfields ('86').VALUE     := v_SPREADRATE;
    --12   MSTTERM          N
    l_txmsg.txfields ('12').defname   := 'MSTTERM';
    l_txmsg.txfields ('12').TYPE      := 'N';
    l_txmsg.txfields ('12').VALUE     := v_TDTERM;
    --11   MSTRATE          N
    l_txmsg.txfields ('11').defname   := 'MSTRATE';
    l_txmsg.txfields ('11').TYPE      := 'N';
    l_txmsg.txfields ('11').VALUE     := v_INTRATE;
    --15   BUYINGPOWER         C
    l_txmsg.txfields ('15').defname   := 'BUYINGPOWER';
    l_txmsg.txfields ('15').TYPE      := 'C';
    l_txmsg.txfields ('15').VALUE     := p_auto;
    --89   MINBRTERM         N
    l_txmsg.txfields ('89').defname   := 'MINBRTERM';
    l_txmsg.txfields ('89').TYPE      := 'N';
    l_txmsg.txfields ('89').VALUE     := v_MINBRTERM;
    --10   AMT          N
    l_txmsg.txfields ('10').defname   := 'AMT';
    l_txmsg.txfields ('10').TYPE      := 'N';
    l_txmsg.txfields ('10').VALUE     := p_amt;
    --30   T_DESC   C
    l_txmsg.txfields ('30').defname   := 'DESC';
    l_txmsg.txfields ('30').TYPE      := 'C';
    l_txmsg.txfields ('30').VALUE     := p_desc;

    --20   BALDEFOVD   N
    l_txmsg.txfields ('20').defname   := 'BALDEFOVD';
    l_txmsg.txfields ('20').TYPE      := 'N';
    l_txmsg.txfields ('20').VALUE     := '0';

    --plog.error(pkgctx, 'p_auto:'  || p_auto);
    --adminplog.error(pkgctx, 'CAMASTID:'  || l_camastid);

    BEGIN
        IF txpks_#1670.fn_autotxprocess (l_txmsg,
                                         p_err_code,
                                         l_err_param
           ) <> systemnums.c_success
        THEN
           plog.error (pkgctx,
                       'got error 1670: ' || p_err_code
           );
           ROLLBACK;
           p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
           plog.error(pkgctx, 'Error: 1670:'  || p_err_message);
           plog.setendsection(pkgctx, 'pr_CreateTermDeposit');
           RETURN;
        END IF;
    END;
    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_CreateTermDeposit');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.error (pkgctx,'got error on pr_CreateTermDeposit');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, 'got error on pr_CreateTermDeposit'||SQLERRM);
      plog.setendsection (pkgctx, 'pr_CreateTermDeposit');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_CreateTermDeposit;

-- Ham thuc hien giao dich rut tiet kiem
-- TheNN, 01-Aug-2012
PROCEDURE pr_TermDepositWithdraw
    (p_afacctno     IN  varchar,
    p_tdacctno      IN  VARCHAR,
    p_withdrawamt   IN  number,
    p_desc          IN  varchar2,
    p_err_code      OUT varchar2,
    p_err_message   OUT varchar2
    )
  IS
      l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      l_err_param varchar2(300);

      v_INTAVLAMT     NUMBER;
      v_BALANCE       NUMBER;
      v_MORTGAGE      NUMBER;
      v_DIRECTAMT     NUMBER;
      v_INTAMT        NUMBER;
      v_ORGAMT        NUMBER;
      v_FRDATE        VARCHAR2(20);

  BEGIN
    plog.setbeginsection(pkgctx, 'pr_TermDepositWithdraw');

    -- Check host & branch active or inactive
    p_err_code := fn_CheckActiveSystem;
    IF p_err_code <> systemnums.C_SUCCESS THEN
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_TermDepositWithdraw');
        return;
    END IF;
    -- End: Check host & branch active or inactive

    SELECT TO_DATE (varvalue, systemnums.c_date_format)
               INTO v_strCURRDATE
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := systemnums.C_ONLINE_USERID;
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := 'DAY';
    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd:='1600';

    --Set txnum
    SELECT systemnums.C_OL_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO l_txmsg.txnum
              FROM DUAL;
    l_txmsg.brid        := substr(p_afacctno,1,4);

    -- Lay thong tin cua hop dong tiet kiem
    SELECT MST.BALANCE, MST.MORTGAGE,
        FN_TDMASTINTRATIO(MST.ACCTNO,to_date(v_strCURRDATE,systemnums.c_date_format),MST.BALANCE) INTAVLAMT,MST.ORGAMT, MST.FRDATE
    INTO v_BALANCE, v_MORTGAGE, v_INTAVLAMT,v_ORGAMT,v_FRDATE
    FROM TDMAST MST
    WHERE mst.acctno = p_tdacctno;
    -- Tinh lai dua tren so tien rut
    SELECT FN_TDMASTINTRATIO(p_tdacctno,to_date(v_strCURRDATE,systemnums.c_date_format),p_withdrawamt)
    INTO v_INTAMT
    FROM dual;

    --Set cac field giao dich
    --03   ACCTNO      C
    l_txmsg.txfields ('03').defname   := 'ACCTNO';
    l_txmsg.txfields ('03').TYPE      := 'C';
    l_txmsg.txfields ('03').VALUE     := p_tdacctno;
    --05   AFACCTNO      C
    l_txmsg.txfields ('05').defname   := 'AFACCTNO';
    l_txmsg.txfields ('05').TYPE      := 'C';
    l_txmsg.txfields ('05').VALUE     := p_afacctno;
    --09   BALANCE          N
    l_txmsg.txfields ('09').defname   := 'BALANCE';
    l_txmsg.txfields ('09').TYPE      := 'N';
    l_txmsg.txfields ('09').VALUE     := v_BALANCE;
    --10   AMT          N
    l_txmsg.txfields ('10').defname   := 'AMT';
    l_txmsg.txfields ('10').TYPE      := 'N';
    l_txmsg.txfields ('10').VALUE     := p_withdrawamt;
    --11   INTAMT          N
    l_txmsg.txfields ('11').defname   := 'INTAMT';
    l_txmsg.txfields ('11').TYPE      := 'N';
    l_txmsg.txfields ('11').VALUE     := v_INTAMT;
    --12   INTAVLAMT          N
    l_txmsg.txfields ('12').defname   := 'INTAVLAMT';
    l_txmsg.txfields ('12').TYPE      := 'N';
    l_txmsg.txfields ('12').VALUE     := v_INTAVLAMT;
    --13   MORTGAGE          N
    l_txmsg.txfields ('13').defname   := 'MORTGAGE';
    l_txmsg.txfields ('13').TYPE      := 'N';
    l_txmsg.txfields ('13').VALUE     := v_MORTGAGE;
    --15   DIRECTAMT          N
    l_txmsg.txfields ('15').defname   := 'DIRECTAMT';
    l_txmsg.txfields ('15').TYPE      := 'N';
    l_txmsg.txfields ('15').VALUE     := v_BALANCE - v_MORTGAGE;
    --16   ORGAMT          N
    l_txmsg.txfields ('16').defname   := 'ORGAMT';
    l_txmsg.txfields ('16').TYPE      := 'N';
    l_txmsg.txfields ('16').VALUE     := v_ORGAMT;
    --17   FRDATE          C
    l_txmsg.txfields ('17').defname   := 'FRDATE';
    l_txmsg.txfields ('17').TYPE      := 'C';
    l_txmsg.txfields ('17').VALUE     := v_FRDATE;
    --30   T_DESC   C
    l_txmsg.txfields ('30').defname   := 'T_DESC';
    l_txmsg.txfields ('30').TYPE      := 'C';
    l_txmsg.txfields ('30').VALUE     := p_desc;

    BEGIN
        IF txpks_#1600.fn_autotxprocess (l_txmsg,
                                         p_err_code,
                                         l_err_param
           ) <> systemnums.c_success
        THEN
           plog.error (pkgctx,
                       'got error 1600: ' || p_err_code
           );
           ROLLBACK;
           p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
           plog.error(pkgctx, 'Error: 1600: '  || p_err_message);
           plog.setendsection(pkgctx, 'pr_TermDepositWithdraw');
           RETURN;
        END IF;
    END;
    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_TermDepositWithdraw');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.error (pkgctx,'got error on pr_TermDepositWithdraw');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, 'got error on pr_TermDepositWithdraw'||SQLERRM);
      plog.setendsection (pkgctx, 'pr_TermDepositWithdraw');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_TermDepositWithdraw;
-- Ham thuc hien giao dich dang ky rut tiet kiem
-- QuangVD, 27-Sep-2012
PROCEDURE pr_TermDepositRegister
    (p_afacctno     IN  varchar,
    p_tdacctno      IN  VARCHAR,
    p_desc          IN  varchar2,
    p_err_code      OUT varchar2,
    p_err_message   OUT varchar2
    )
  IS
      l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      l_err_param varchar2(300);

      v_ACTYPE     varchar2(100);
      v_CUSTNAME     varchar2(100);
      v_FRDATE  VARCHAR2(20);
      v_TODATE  varchar2(20);
      v_BALANCE number;
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_TermDepositRegister');

    -- Check host & branch active or inactive
    p_err_code := fn_CheckActiveSystem;
    IF p_err_code <> systemnums.C_SUCCESS THEN
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_TermDepositRegister');
        return;
    END IF;
    -- End: Check host & branch active or inactive

    SELECT TO_DATE (varvalue, systemnums.c_date_format)
               INTO v_strCURRDATE
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := systemnums.C_ONLINE_USERID;
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := 'DAY';
    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd:='1631';

    --Set txnum
    SELECT systemnums.C_OL_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO l_txmsg.txnum
              FROM DUAL;
    l_txmsg.brid        := substr(p_afacctno,1,4);

    -- Lay thong tin cua hop dong tiet kiem
    SELECT MST.ACTYPE, TO_DATE(FRDATE,'DD/MM/YYYY'), TO_DATE(TODATE,'DD/MM/YYYY'), mst.orgamt
    INTO v_ACTYPE, v_FRDATE, v_TODATE, v_BALANCE
    FROM TDMAST MST
    WHERE mst.acctno = p_tdacctno;

    select cfmast.fullname
    into v_CUSTNAME
    from cfmast, afmast
    where cfmast.custid=afmast.custid and afmast.acctno=p_afacctno;

    --Set cac field giao dich
    --03   ACCTNO      C
    l_txmsg.txfields ('03').defname   := 'ACCTNO';
    l_txmsg.txfields ('03').TYPE      := 'C';
    l_txmsg.txfields ('03').VALUE     := p_tdacctno;
    --04   CUSTODYCD      C
    l_txmsg.txfields ('04').defname   := 'CUSTODYCD';
    l_txmsg.txfields ('04').TYPE      := 'C';
    l_txmsg.txfields ('04').VALUE     := 'ONLINE';
    --05   AFACCTNO      C
    l_txmsg.txfields ('05').defname   := 'AFACCTNO';
    l_txmsg.txfields ('05').TYPE      := 'C';
    l_txmsg.txfields ('05').VALUE     := p_afacctno;
    --06   FRDATE      D
    l_txmsg.txfields ('06').defname   := 'FRDATE';
    l_txmsg.txfields ('06').TYPE      := 'D';
    l_txmsg.txfields ('06').VALUE     := v_FRDATE;
    --07   TODATE      D
    l_txmsg.txfields ('07').defname   := 'TODATE';
    l_txmsg.txfields ('07').TYPE      := 'D';
    l_txmsg.txfields ('07').VALUE     := v_TODATE;
    --08   ACTYPE      C
    l_txmsg.txfields ('08').defname   := 'ACTYPE';
    l_txmsg.txfields ('08').TYPE      := 'C';
    l_txmsg.txfields ('08').VALUE     := v_ACTYPE;
    --09   BUYINGPOWER      C
    l_txmsg.txfields ('09').defname   := 'BUYINGPOWER';
    l_txmsg.txfields ('09').TYPE      := 'C';
    l_txmsg.txfields ('09').VALUE     := 'Y';
    --10   BALANCE      C
    l_txmsg.txfields ('10').defname   := 'BALANCE';
    l_txmsg.txfields ('10').TYPE      := 'N';
    l_txmsg.txfields ('10').VALUE     := v_BALANCE;
    --30   T_DESC   C
    l_txmsg.txfields ('30').defname   := 'T_DESC';
    l_txmsg.txfields ('30').TYPE      := 'C';
    l_txmsg.txfields ('30').VALUE     := p_desc;
    --90   CUSTNAME   C
    l_txmsg.txfields ('90').defname   := 'CUSTNAME';
    l_txmsg.txfields ('90').TYPE      := 'C';
    l_txmsg.txfields ('90').VALUE     := v_CUSTNAME;

    BEGIN
        IF txpks_#1631.fn_autotxprocess (l_txmsg,
                                         p_err_code,
                                         l_err_param
           ) <> systemnums.c_success
        THEN
           plog.error (pkgctx,
                       'got error 1631: ' || p_err_code
           );
           ROLLBACK;
           p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
           plog.error(pkgctx, 'Error: 1631: '  || p_err_message);
           plog.setendsection(pkgctx, 'pr_TermDepositWithdraw');
           RETURN;
        END IF;
    END;
    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_TermDepositWithdraw');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.error (pkgctx,'got error on pr_TermDepositWithdraw');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, 'got error on pr_TermDepositWithdraw'||SQLERRM);
      plog.setendsection (pkgctx, 'pr_TermDepositWithdraw');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_TermDepositRegister;
-- Ham thuc hien dang ky online
-- Binhpt, 08-Aug-2012
PROCEDURE pr_OnlineRegister(
       p_CustomerType IN VARCHAR2,
       p_CustomerName IN VARCHAR2,
       P_Sex in VARCHAR2,
       p_CustomerBirth IN VARCHAR2,
       p_IDType IN VARCHAR2,
       p_IDCode IN VARCHAR2,
       p_Iddate IN VARCHAR2,
       p_Idplace IN VARCHAR2,
       p_Address IN VARCHAR2,
       p_ContactAddress IN VARCHAR2,
       p_Taxcode IN VARCHAR2,
       p_PrivatePhone IN VARCHAR2,
       p_Mobile IN VARCHAR2,
       p_WorkMobile IN VARCHAR2,
       p_Fax IN VARCHAR2,
       p_Email IN VARCHAR2,
       p_Country IN VARCHAR2,
       p_CustomerCity IN VARCHAR2,
       p_Certificate      IN VARCHAR2,
       p_CertificateDate  in VARCHAR2,
       p_CertificatePlace IN VARCHAR2,
       p_Business         IN VARCHAR2,
       p_AgentName        IN VARCHAR2,
       p_AgentPosition    IN VARCHAR2,
       p_AgentCountry     IN VARCHAR2,
       p_AgentSex         IN VARCHAR2,
       p_AgentId          IN VARCHAR2,
       p_AgentPhone       IN VARCHAR2,
       p_AgentEmail       IN VARCHAR2,
       p_OtherAccount1 IN VARCHAR2,
       p_OtherCompany1 IN VARCHAR2,
       p_FixedIncome      IN VARCHAR2,
       p_LongGrowth      IN VARCHAR2,
       p_MidGrowth        IN VARCHAR2,
       p_ShortGrowth      IN VARCHAR2,
       p_LowRisk          IN VARCHAR2,
       p_MidRisk         IN VARCHAR2,
       p_HighRisk         IN VARCHAR2,
       p_ManageCompanyName    IN VARCHAR2,
       p_ShareholderCompanyName IN VARCHAR2,
       p_InvestKnowlegde      IN VARCHAR2,
       p_InvestExperience     IN VARCHAR2,
       p_IsTrustAcctno        IN VARCHAR2,
       p_TrustFullname        IN VARCHAR2,
       p_Relationship         IN VARCHAR2,
       p_DealStockType        IN VARCHAR2,
       p_DealMethod           IN VARCHAR2,
       p_DealResult           IN VARCHAR2,
       p_DealStatement        IN VARCHAR2,
       p_DealTax              IN VARCHAR2,
       p_BeneficiaryName      IN VARCHAR2,
       p_BeneficiaryBirthday  IN VARCHAR2,
       p_BeneficiaryPhone     IN VARCHAR2,
       p_BeneficiaryId        IN VARCHAR2,
       p_BeneficiaryIdDate    IN VARCHAR2,
       p_BeneficiaryIdPlace   IN VARCHAR2,
       p_AuthorizedName       IN VARCHAR2,
       p_AuthorizedPhone      IN VARCHAR2,
       p_AuthorizedId         IN VARCHAR2,
       p_AuthorizedIdDate     IN VARCHAR2,
       p_AuthorizedIdPlace    IN VARCHAR2,
       p_Custodycd            IN VARCHAR2,
       p_TrustPhone           IN VARCHAR2,
       p_AuthorizedBirthday   IN VARCHAR2,
       p_AgentIDDate in VARCHAR2,
       p_AgentIDPlace in varchar2,
       p_brid in varchar2,
       p_err_code  OUT varchar2,
       p_err_message  OUT varchar2
    )
    IS
      v_CUSTOMERBIRTH date;
      v_IDDATE date;
      v_CertificateDate date;
      v_BeneficiaryBirthday date;
      v_BeneficiaryIdDate date;
      v_AuthorizedIdDate  date;
      v_AuthorizedBirthday date;
      v_AgentIDDate date;
      v_count number;
      l_datasource varchar2(100);
      l_sex varchar2(10);
    BEGIN
        plog.error (pkgctx,'pr_OnlineRegister Start...');
        plog.setbeginsection(pkgctx, 'pr_OnlineRegister');

        -- Check host & branch active or inactive
        p_err_code := fn_CheckActiveSystem;
        IF p_err_code <> systemnums.C_SUCCESS THEN
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_OnlineRegister');
            return;
        END IF;
        -- End: Check host & branch active or inactive
        --check truong date time
        If p_Custodycd is not null THEN
         v_count:=0;
         select count(1) into v_count
         from (select custodycd from cfmast where custodycd=p_custodycd
                union
               select custodycd
               from registeronline
               where custodycd=p_custodycd
                     AND  AUTOID not in (select OLAUTOID from CFMAST CF
                                                           where CF.OPENVIA='O'
                                                              AND CF.CUSTODYCD IS NOT NULL
                                                         )
               ) ;

         if v_count >0 then
            p_err_code:='-200019';
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_OnlineRegister');
            return;
         end if;


        End if;
        plog.debug (pkgctx,'pr_OnlineRegister p_CUSTOMERBIRTH '||p_CUSTOMERBIRTH);
        IF p_CUSTOMERBIRTH IS NULL OR p_CUSTOMERBIRTH='' THEN
        v_CUSTOMERBIRTH:=NULL;
        ELSE
        v_CUSTOMERBIRTH:=TO_DATE(p_CUSTOMERBIRTH,'DD/MM/YYYY');
        END IF;

        plog.debug (pkgctx,'pr_OnlineRegister p_IDDATE '||p_IDDATE);
        IF p_IDDATE IS NULL OR p_IDDATE='' THEN
        v_IDDATE:=NULL;
        ELSE
        v_IDDATE:=TO_DATE(p_IDDATE,'DD/MM/YYYY');
        END IF;

        plog.debug (pkgctx,'pr_OnlineRegister p_CertificateDate '||p_CertificateDate);
        IF p_CertificateDate IS NULL OR p_CertificateDate='' THEN
        v_CertificateDate:=NULL;
        ELSE
        v_CertificateDate:=TO_DATE(p_CertificateDate,'DD/MM/YYYY');
        END IF;

         plog.debug (pkgctx,'pr_OnlineRegister p_BeneficiaryBirthday '||p_BeneficiaryBirthday);
        IF p_BeneficiaryBirthday IS NULL OR p_BeneficiaryBirthday='' THEN
            v_BeneficiaryBirthday:=NULL;
        ELSE
             v_BeneficiaryBirthday:=TO_DATE(p_BeneficiaryBirthday,'DD/MM/YYYY');
        END IF;

         plog.debug (pkgctx,'pr_OnlineRegister p_BeneficiaryIdDate '||p_BeneficiaryIdDate);
        IF p_BeneficiaryIdDate IS NULL OR p_BeneficiaryIdDate='' THEN
            v_BeneficiaryIdDate:=NULL;
        ELSE
             v_BeneficiaryIdDate:=TO_DATE(p_BeneficiaryIdDate,'DD/MM/YYYY');
        END IF;

        plog.debug (pkgctx,'pr_OnlineRegister p_AuthorizedIdDate '||p_AuthorizedIdDate);
        IF p_AuthorizedIdDate IS NULL OR p_AuthorizedIdDate='' THEN
            v_AuthorizedIdDate:=NULL;
        ELSE
             v_AuthorizedIdDate:=TO_DATE(p_AuthorizedIdDate,'DD/MM/YYYY');
        END IF;

        IF p_AuthorizedBirthday IS NULL OR p_AuthorizedBirthday='' THEN
            v_AuthorizedBirthday:=NULL;
        ELSE
             v_AuthorizedBirthday:=TO_DATE(p_AuthorizedBirthday,'DD/MM/YYYY');
        END IF;

        IF p_AgentIDDate IS NULL OR p_AgentIDDate='' THEN
            v_AgentIDDate:=NULL;
        ELSE
             v_AgentIDDate:=TO_DATE(p_AgentIDDate,'DD/MM/YYYY');
        END IF;

        Insert into REGISTERONLINE
                (AUTOID,CUSTOMERTYPE,CUSTOMERNAME,SEX,CUSTOMERBIRTH,
                IDTYPE,IDCODE,IDDATE,IDPLACE,Expiredate,
                ADDRESS,ContactAddress,TAXCODE,
                PRIVATEPHONE,MOBILE,WorkMobile,FAX,
                EMAIL,
                COUNTRY,CUSTOMERCITY,
                OTHERACCOUNT1,OTHERCOMPANY1,
                Certificate,CertificateDate,CertificatePlace,
                Business,AgentName,AgentPosition,AgentCountry,AgentSex,
                AgentId,AgentPhone,AgentEmail,
                FixedIncome,LongGrowth,MidGrowth,ShortGrowth,
                LowRisk,MidRisk,HighRisk,
                ManageCompanyName,ShareholderCompanyName,
                InvestKnowlegde,InvestExperience,
                IsTrustAcctno,TrustFullname,
                Relationship,DealStockType,
                DealMethod,DealResult,DealStatement,DealTax,
                BeneficiaryName,BeneficiaryBirthday,BeneficiaryPhone,BeneficiaryId,BeneficiaryIdDate,BeneficiaryIdPlace,
                AuthorizedName,AuthorizedPhone,AuthorizedId,AuthorizedIdDate,AuthorizedIdPlace,
                Custodycd,ISAPPROVE,TrustPhone,AuthorizedBirthday,AgentIDDate,AgentIDPlace,brid)
                values (
                SEQ_REGISTER_AUTOID.nextval,p_CUSTOMERTYPE,p_CUSTOMERNAME,P_Sex,v_CUSTOMERBIRTH,
                p_IDTYPE,p_IDCODE,v_IDDATE,p_IDPLACE,add_MONTHS(v_IDDATE,15*12),
                p_ADDRESS,p_ContactAddress,p_TAXCODE,
                p_PRIVATEPHONE,p_MOBILE,p_WorkMobile,p_FAX,
                p_EMAIL,
                p_COUNTRY,p_CUSTOMERCITY,
                p_OTHERACCOUNT1,p_OTHERCOMPANY1,
                p_Certificate,v_CertificateDate,p_CertificatePlace,
                p_Business,p_AgentName,p_AgentPosition,p_AgentCountry,p_AgentSex,
                p_AgentId,p_AgentPhone,p_AgentEmail,
                p_FixedIncome,p_LongGrowth,p_MidGrowth,p_ShortGrowth,
                p_LowRisk,p_MidRisk,p_HighRisk,
                p_ManageCompanyName,p_ShareholderCompanyName,
                p_InvestKnowlegde,p_InvestExperience,
                p_IsTrustAcctno,p_TrustFullname,
                p_Relationship,p_DealStockType,
                p_DealMethod,p_DealResult,p_DealStatement,p_DealTax,
                p_BeneficiaryName,V_BeneficiaryBirthday,p_BeneficiaryPhone,p_BeneficiaryId,v_BeneficiaryIdDate,p_BeneficiaryIdPlace,
                p_AuthorizedName,p_AuthorizedPhone,p_AuthorizedId,V_AuthorizedIdDate,p_AuthorizedIdPlace,
                p_Custodycd,'P',p_TrustPhone, v_AuthorizedBirthday,v_AgentIDDate,p_AgentIDPlace,p_brid
                );
        commit;
        l_sex:=' ';
        For vc in (Select cdcontent
                   From allcode
                   WHERE CDNAME='SEXEMAIL' AND CDTYPE='CF' and cdval=p_sex)
        Loop
               l_sex:=vc.cdcontent;
        End loop;
        l_datasource:='select '''||p_CUSTOMERNAME||''' fullname,'''||l_sex||''' sex  from dual ';
        if length(p_EMAIL)>0 then
            nmpks_ems.InsertEmailLog(p_EMAIL, '4000', l_datasource, '');
        end if;
        --end insert
        p_err_code:= 0;
    EXCEPTION
        WHEN OTHERS
        THEN
             plog.debug (pkgctx,'got error on pr_OnlineRegister');
             ROLLBACK;
             p_err_code := errnums.C_SYSTEM_ERROR;
             plog.error (pkgctx, SQLERRM);
             plog.setendsection (pkgctx, 'pr_OnlineRegister');
             RAISE errnums.E_SYSTEM_ERROR;
    END pr_OnlineRegister;

--Ham tra cuu tiet kiem
--Binhpt 29/08/2012
PROCEDURE pr_GetTDhist
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2
     )
    IS
    V_AFACCTNO    VARCHAR2(10);
BEGIN
    IF AFACCTNO = 'ALL' OR AFACCTNO IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := AFACCTNO;
    END IF;

    OPEN p_REFCURSOR FOR
       SELECT MST.ACCTNO, MST.AFACCTNO, CF.CUSTODYCD, CF.FULLNAME, TYP.TYPENAME,
        MST.ORGAMT, MST.BALANCE, MST.PRINTPAID, MST.INTNMLACR, MST.INTPAID, MST.TAXRATE, MST.BONUSRATE, MST.INTRATE, MST.TDTERM, MST.OPNDATE, MST.FRDATE, MST.TODATE,TYP.minbrterm,TYP.TERMCD,
        CASE WHEN (CASE TYP.TERMCD WHEN 'D' THEN TYP.minbrterm + MST.FRDATE
                            WHEN 'W' THEN TYP.minbrterm*7 + MST.FRDATE
                            WHEN 'M' THEN ADD_MONTHS(MST.FRDATE,TYP.minbrterm)
            END) <= (SELECT TO_DATE(VARVALUE,'DD/MM/RRRR') FROM SYSVAR WHERE GRNAME = 'SYSTEM' AND VARNAME = 'CURRDATE')  THEN 'Y' ELSE 'N' END ALLOWED ,
        FN_TDMASTINTRATIO(MST.ACCTNO,TO_DATE(SYSVAR.VARVALUE,'DD/MM/YYYY'),MST.BALANCE) INTAVLAMT, MST.BALANCE-MST.MORTGAGE AVLWITHDRAW, MST.MORTGAGE,
        A0.CDCONTENT DESC_TDSRC, A1.CDCONTENT DESC_AUTOPAID, A2.CDCONTENT DESC_BREAKCD, A3.CDCONTENT DESC_SCHDTYPE, A4.CDCONTENT DESC_TERMCD, A5.CDCONTENT DESC_STATUS
        FROM TDMAST MST, AFMAST AF, CFMAST CF, TDTYPE TYP, ALLCODE A0, ALLCODE A1, ALLCODE A2, ALLCODE A3, ALLCODE A4, ALLCODE A5, SYSVAR
        WHERE AF.ACCTNO like V_AFACCTNO AND (MST.BALANCE) > 0
        AND MST.ACTYPE=TYP.ACTYPE AND MST.AFACCTNO=AF.ACCTNO AND AF.CUSTID=CF.CUSTID AND SYSVAR.VARNAME='CURRDATE'
        AND MST.DELTD<>'Y' AND MST.status in ('N','A')
        AND A0.CDTYPE='TD' AND A0.CDNAME='TDSRC' AND MST.TDSRC=A0.CDVAL
        AND A1.CDTYPE='SY' AND A1.CDNAME='YESNO' AND MST.AUTOPAID=A1.CDVAL
        AND A2.CDTYPE='SY' AND A2.CDNAME='YESNO' AND MST.BREAKCD=A2.CDVAL
        AND A4.CDTYPE='TD' AND A4.CDNAME='TERMCD' AND MST.TERMCD=A4.CDVAL
        AND A5.CDTYPE='TD' AND A5.CDNAME='STATUS' AND MST.STATUS=A5.CDVAL
        AND A3.CDTYPE='TD' AND A3.CDNAME='SCHDTYPE' AND MST.SCHDTYPE=A3.CDVAL
        AND MST.OPNDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
        AND MST.OPNDATE<=TO_DATE(T_DATE,'DD/MM/YYYY');
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GetTDhist');
END pr_GetTDhist;
--Ham tra cuu lenh xac nhan
--QuangVD 04/01/2013
PROCEDURE pr_GetConfirmOrderHist
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     EXECTYPE       IN  VARCHAR2
     )
    IS
    V_AFACCTNO    VARCHAR2(10);
    V_EXECTYPE    VARCHAR2(10);
BEGIN
    IF AFACCTNO = 'ALL' OR AFACCTNO IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := AFACCTNO;
    END IF;

    IF EXECTYPE = 'ALL' OR EXECTYPE IS NULL THEN
        V_EXECTYPE := '%%';
    ELSE
        V_EXECTYPE := EXECTYPE;
    END IF;

    OPEN p_REFCURSOR FOR
       SELECT OD.ORDERID,OD.TXDATE,OD.CODEID, A0.CDCONTENT TRADEPLACE, A1.CDCONTENT EXECTYPE,
        OD.PRICETYPE PRICETYPE, A3.CDCONTENT VIA, OD.ORDERQTTY,OD.QUOTEPRICE, OD.REFORDERID,
        se.symbol,a4.CDCONTENT CONFIRMED,od.afacctno, cf.custodycd, cf.fullname,
        cspks_odproc.fn_OD_GetRootOrderID(od.orderid) ROOTORDERID
        FROM CONFIRMODRSTS CFMSTS,
        (select * from ODMAST union all select * from odmasthist) OD, SBSECURITIES SE,
        ALLCODE A0, ALLCODE A1, ALLCODE A2, ALLCODE A3,aLLCODE A4,
        afmast af, cfmast cf
        WHERE CFMSTS.ORDERID(+)=OD.ORDERID
        AND OD.CODEID=SE.CODEID
        AND a0.cdtype = 'OD' AND a0.cdname = 'TRADEPLACE' AND a0.cdval = se.tradeplace
        AND A1.cdtype = 'OD' AND A1.cdname = 'EXECTYPE'
        AND A1.cdval =(case when nvl(od.reforderid,'a') <>'a' and OD.EXECTYPE = 'NB' then 'AB'
        when  nvl(od.reforderid,'a') <>'a' and OD.EXECTYPE in ( 'NS','MS') then 'AS'
          else od.EXECTYPE end)
        AND A2.cdtype = 'OD' AND A2.cdname = 'PRICETYPE' AND A2.cdval = OD.PRICETYPE
        AND A3.cdtype = 'OD' AND A3.cdname = 'VIA' AND A3.cdval = OD.VIA
        AND a4.cdtype = 'SY' AND a4.cdname = 'YESNO' AND a4.cdval = nvl(CFMSTS.CONFIRMED,'N')
        and ( (od.exectype in ('NB','NS','MS') AND od.via in ('F','T','H','E')) or (od.exectype  not in ('NB','NS','MS')))
        and od.exectype not in ('AB','AS') AND od.tlid <> systemnums.C_ONLINE_USERID
        and od.via not in( 'O','M','K')
        and od.txdate >=to_date('01/01/2013','DD/MM/YYYY')
        and od.afacctno=af.acctno and af.custid=cf.custid
        AND OD.AFACCTNO LIKE V_AFACCTNO
        AND OD.EXECTYPE LIKE V_EXECTYPE
        AND OD.txdate >= TO_DATE(F_DATE,'DD/MM/YYYY')
        AND OD.txdate <= TO_DATE(T_DATE,'DD/MM/YYYY')
        and od.orderid not in (select orderid from CONFIRMODRSTS)
        ORDER BY OD.TXDATE DESC, od.orderid;
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GetConfirmOrderHist');
END pr_GetConfirmOrderHist;

PROCEDURE pr_GetConfirmOrderHistByCust
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     EXECTYPE       IN  VARCHAR2
     )
    IS
    V_CUSTODYCD    VARCHAR2(10);
    V_EXECTYPE    VARCHAR2(10);
BEGIN
    V_CUSTODYCD:=CUSTODYCD;

    IF EXECTYPE = 'ALL' OR EXECTYPE IS NULL THEN
        V_EXECTYPE := '%%';
    ELSE
        V_EXECTYPE := EXECTYPE;
    END IF;

    OPEN p_REFCURSOR FOR
       SELECT OD.ORDERID,OD.TXDATE,OD.CODEID, A0.CDCONTENT TRADEPLACE, A1.CDCONTENT EXECTYPE, A1.CDVAL EXECTYPECD,
        OD.PRICETYPE PRICETYPE, A3.CDCONTENT VIA, A3.CDVAL VIACD, OD.ORDERQTTY,OD.QUOTEPRICE, OD.REFORDERID,
        se.symbol,a4.CDCONTENT CONFIRMED,od.afacctno, cf.custodycd, cf.fullname,
        cspks_odproc.fn_OD_GetRootOrderID(od.orderid) ROOTORDERID
        FROM CONFIRMODRSTS CFMSTS,
        (select * from ODMAST union all select * from odmasthist) OD, SBSECURITIES SE,
        ALLCODE A0, ALLCODE A1, ALLCODE A2, ALLCODE A3,aLLCODE A4,
        afmast af, cfmast cf
        WHERE CFMSTS.ORDERID(+)=OD.ORDERID
        AND OD.CODEID=SE.CODEID
        AND a0.cdtype = 'OD' AND a0.cdname = 'TRADEPLACE' AND a0.cdval = se.tradeplace
        AND A1.cdtype = 'OD' AND A1.cdname = 'EXECTYPE'
        AND A1.cdval =(case when nvl(od.reforderid,'a') <>'a' and OD.EXECTYPE = 'NB' then 'AB'
        when  nvl(od.reforderid,'a') <>'a' and OD.EXECTYPE in ( 'NS','MS') then 'AS'
          else od.EXECTYPE end)
        AND A2.cdtype = 'OD' AND A2.cdname = 'PRICETYPE' AND A2.cdval = OD.PRICETYPE
        AND A3.cdtype = 'OD' AND A3.cdname = 'VIA' AND A3.cdval = OD.VIA
        AND a4.cdtype = 'SY' AND a4.cdname = 'YESNO' AND a4.cdval = nvl(CFMSTS.CONFIRMED,'N')
        and ( (od.exectype in ('NB','NS','MS') AND od.via in ('F','T','H')) or (od.exectype  not in ('NB','NS','MS')))
        and od.exectype not in ('AB','AS') AND od.tlid <> systemnums.C_ONLINE_USERID --1.7.2.4
        and od.via not in( 'O','M','K')
        and od.txdate >=to_date('01/01/2013','DD/MM/YYYY')
        and od.afacctno=af.acctno and af.custid=cf.custid
        AND cf.custodycd = V_custodycd
        AND OD.EXECTYPE LIKE V_EXECTYPE
        AND OD.txdate >= TO_DATE(F_DATE,'DD/MM/YYYY')
        AND OD.txdate <= TO_DATE(T_DATE,'DD/MM/YYYY')
        and od.orderid not in (select orderid from CONFIRMODRSTS)
        ORDER BY OD.TXDATE DESC;
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GetConfirmOrderHistByCust');
END pr_GetConfirmOrderHistByCust;

--Binhpt Ham tra cuu tong tai san
PROCEDURE pr_GetNetAsset
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     p_AFACCTNO    IN VARCHAR2
     )
    IS
    l_AFACCTNO    VARCHAR2(10);
    --V_CUSTODYCD   VARCHAR2(10);
    l_MRAMT          number(20,0);
    l_T0AMT          number(20,0);
    l_DFAMT          number(20,0);
    l_BALANCE        number(20,0);
    l_AVLADVANCE     number(20,0);
    l_trfbuyamt_in   number(20,0);
    l_trfbuyamt_over number(20,0);
    l_trfbuyamt_inday number(20,0);
    l_secureamt_inday number(20,0);
    l_DEPOFEEAMT     number(20,0);
    l_isstopadv      varchar2(10);
BEGIN
    l_AFACCTNO:=p_AFACCTNO;
    l_isstopadv := cspks_system.fn_get_sysvar('MARGIN','ISSTOPADV');
    --Lay cac thong tin ve tien
     select nvl(sum(t0amt),0), nvl(sum(marginamt),0) into l_T0AMT,l_MRAMT  from vw_lngroup_all where trfacctno = l_AFACCTNO;

     select nvl(sum(prinnml+prinovd+intnmlacr+intnmlovd+intovdacr+intdue+feeintnmlacr+feeintnmlovd+feeintovdacr+feeintdue),0) into l_DFAMT
     from lnmast where trfacctno = l_AFACCTNO and ftype = 'DF';

     select nvl(sum(trfbuyamt_in),0), nvl(sum(trfbuyamt_over),0)
     into l_trfbuyamt_in, l_trfbuyamt_over
     from v_getbuyorderinfo
     where afacctno = l_AFACCTNO;

     select nvl(sum(trfsecuredamt_inday+trft0amt_inday),0),nvl(sum(secureamt_inday),0)
     into l_trfbuyamt_inday, l_secureamt_inday
     from vw_trfbuyinfo_inday
     where afacctno = l_AFACCTNO;

     select balance,depofeeamt into l_BALANCE,l_DEPOFEEAMT
     from cimast
     where acctno = l_AFACCTNO;

     select nvl(sum(decode(l_isstopadv,'Y',0,depoamt)),0) into l_AVLADVANCE
     from v_getaccountavladvance
     where afacctno = l_AFACCTNO;
    --end Lay cac thong tin ve tien
    OPEN p_REFCURSOR FOR
    select
    sum(REALASS) SeTotal,
    (l_BALANCE + l_AVLADVANCE) CITotal,
    (l_T0AMT+l_MRAMT+l_DFAMT+l_trfbuyamt_in+l_trfbuyamt_over+l_trfbuyamt_inday+l_secureamt_inday+ l_DEPOFEEAMT) odamt
    from vw_mr9004 v
    where v.afacctno = l_AFACCTNO
    and v.trade + v.mortage + v.receiving + v.receivingt2 + v.totalreceiving + v.sellmatchqtty + v.buyqtty + v.totalbuyqtty > 0
    order by v.symbol;
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GetNetAsset');
END pr_GetNetAsset;
--Ham tra cuu chuyen doi trai phieu
--QuangVD 17/10/2012
PROCEDURE pr_GetConvertBondHist
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2
     )
    IS
    V_AFACCTNO    VARCHAR2(10);
BEGIN
    IF AFACCTNO = 'ALL' OR AFACCTNO IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := AFACCTNO;
    END IF;

    OPEN p_REFCURSOR FOR
       /*SELECT CI.busdate TXDATE, cf.custodycd, af.acctno Sub_Account,
            --REPLACE(se.symbol,'_WFT','') symbol ,
            ca.symbol symbol,
            CASE WHEN CI.TLTXCD = '3386' THEN -SE.NAMT ELSE SE.NAMT END Quantity,
            CASE WHEN CI.TLTXCD = '3386' THEN -CI.NAMT ELSE CI.NAMT END Amount,
            NVL(mk.tlname,'-----') maker_name, NVL(ck.tlname,'-----') checker_name,
           'Completed'  Status, decode (af.COREBANK,'Y',AF.bankname, UTF8NUMS.c_const_COMPANY_NAME) bankname,
           ca.tosymbol tosymbol
        FROM (SELECT * FROM   VW_CITRAN_GEN  WHERE TLTXCD IN ('3384','3386'))  CI,
              ( SELECT * FROM   VW_SETRAN_GEN  WHERE TLTXCD IN ('3384','3386') ) SE ,
          cfmast cf, afmast af,tlprofiles mk, tlprofiles ck,
          (SELECT camastid, sb.symbol symbol, tosb.symbol tosymbol
            FROM camast ca, sbsecurities tosb, sbsecurities sb
            WHERE nvl(ca.tocodeid, ca.codeid) = tosb.codeid AND ca.codeid = sb.codeid
          ) ca--add by CHAUNH
        WHERE SE.TXNUM = CI.TXNUM AND SE.TXDATE = CI.TXDATE
        AND se.REF = ca.camastid (+)
        AND SE.DELTD='N' AND CI.DELTD='N' AND SE.field ='RECEIVING' AND CI.field='BALANCE'
        AND ci.busdate >= TO_DATE(F_DATE,'DD/MM/YYYY') AND ci.busdate <= TO_DATE(T_DATE,'DD/MM/YYYY')
        AND CI.ACCTNO = af.acctno and af.custid = cf.custid AND SE.custid = CF.custid --AND CF.custid = AF.custid
        AND CI.TLID = MK.TLID (+) AND CI.offid = CK.TLID(+)
        AND AF.ACCTNO LIKE V_AFACCTNO

        UNION ALL

        SELECT SE.busdate TXDATE, cf.custodycd, af.acctno Sub_Account,
            --REPLACE(se.symbol,'_WFT','') symbol ,
            ca.symbol symbol,
            CASE WHEN SE.TLTXCD = '3326' THEN -SE.NAMT ELSE SE.NAMT END Quantity, 0 Amount,
            NVL(mk.tlname,'-----') maker_name, NVL(ck.tlname,'-----') checker_name,
           'Completed'  Status, decode (af.COREBANK,'Y',AF.bankname, UTF8NUMS.c_const_COMPANY_NAME) bankname,
            ca.tosymbol tosymbol
        FROM ( SELECT * FROM   VW_SETRAN_GEN  WHERE TLTXCD IN ('3324','3326') ) SE ,
          cfmast cf, afmast af,tlprofiles mk, tlprofiles ck,
          (SELECT camastid, sb.symbol symbol, tosb.symbol tosymbol
            FROM camast ca, sbsecurities tosb, sbsecurities sb
            WHERE nvl(ca.tocodeid, ca.codeid) = tosb.codeid AND ca.codeid = sb.codeid
          ) ca--add by CHAUNH
        WHERE SE.DELTD='N' AND SE.field ='RECEIVING'
        AND se.REF = ca.camastid (+)
        AND SE.busdate >= TO_DATE(F_DATE,'DD/MM/YYYY') AND SE.busdate <= TO_DATE(T_DATE,'DD/MM/YYYY')
        AND SE.AFACCTNO = af.acctno and af.custid = cf.custid AND SE.custid = CF.custid --AND CF.custid = AF.custid
        AND SE.TLID = MK.TLID (+) AND SE.offid = CK.TLID(+)
        AND AF.ACCTNO LIKE V_AFACCTNO

        UNION ALL
*/
        SELECT  tran.txdate, cf.custodycd, af.acctno sub_account,
                ca.symbol symbol,
                CASE WHEN tl.tltxcd = '3327' THEN tl.msgamt ELSE -tl.msgamt END Quantity,
                chd.amt amount,  NVL(mk.tlname,'-----') maker_name, NVL(ck.tlname,'-----') checker_name, 'Completed'  Status,
                decode (af.COREBANK,'Y',AF.bankname, UTF8NUMS.c_const_COMPANY_NAME) bankname, ca.tosymbol tosymbol
        FROM
        (SELECT * FROM catran
        UNION all
        SELECT * FROM catrana) tran,
        vw_tllog_all tl, cfmast cf, afmast af,tlprofiles mk, tlprofiles ck,
         (SELECT camastid, sb.symbol symbol, tosb.symbol tosymbol
            FROM camast ca, sbsecurities tosb, sbsecurities sb
            WHERE nvl(ca.tocodeid, ca.codeid) = tosb.codeid AND ca.codeid = sb.codeid) ca, vw_caschd_all chd
        WHERE tl.txdate = tran.txdate AND tl.txnum = tran.txnum
        AND cf.custid = af.custid AND af.acctno = tl.msgacct
        AND TL.TLID = MK.TLID (+) AND tl.offid = ck.TLID(+)
        AND ca.camastid = chd.camastid
        AND chd.autoid = tran.acctno
        AND tl.tltxcd IN ('3327','3328')
        AND tl.busdate >= TO_DATE(F_DATE,'DD/MM/YYYY') AND tl.busdate <= TO_DATE(T_DATE,'DD/MM/YYYY')
        AND AF.ACCTNO LIKE V_AFACCTNO

        ORDER BY TXDATE;
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GetConvertBondHist');
END pr_GetConvertBondHist;
--END pr_GetConvertBondHist

--Ham tra cuu thong tin tra no
--Binhpt
PROCEDURE pr_GetRePaymentHist
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     p_AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2
     )
    IS
   V_STRACCTNO      VARCHAR2 (20);
BEGIN
V_STRACCTNO:=p_AFACCTNO;
    OPEN p_REFCURSOR FOR
    select lntr.autoid, lntr.txdate --ngay tra no
        , ln.acctno
        , ls.rlsdate --ngay giai ngan
        , ls.overduedate, --ngay dao han
        ls.nml + ls.ovd + ls.paid F_GTGN, --tong no goc ban dau
        lntr.prin_move F_GTTL, --so tien tra no goc
        ls.nml + ls.ovd - sum(nvl(lnmov.prin_move,0)) F_DNHT, --no goc con lai
        lntr.int_move F_GTNL--so tien tra no lai
from        (select * from lnmast union select * from lnmasthist) ln
            inner join
            (select * from lnschd union select * from lnschdhist) ls on ln.acctno = ls.acctno and ls.reftype in ('P','GP') and ln.trfacctno LIKE V_STRACCTNO
            inner join
            (
                select autoid, txdate
                    ,sum((case when nml > 0 then 0 else nml end) + ovd) PRIN_MOVE
                        /*sum(intnmlacr +intdue+intovd+intovdprin +
                        feeintnmlacr+ feeintdue+feeintovd+feeintovdprin) PRFEE_MOVE*/
                    ,sum(intpaid) INT_MOVE
                from ( select * from lnschdlog union all select * from lnschdloghist ) lnslog
                where nvl(deltd,'N') <>'Y' --and txdate > TO_DATE('01/09/2014','DD/MM/YYYY')
                and (case when nml > 0 then 0 else nml end) + ovd + intpaid <> 0
                and txdate >= TO_DATE(F_DATE,'DD/MM/YYYY') and txdate <= TO_DATE(T_DATE,'DD/MM/YYYY')
                group by autoid,txdate
            ) LNTR  on ls.autoid = lntr.autoid
            left join
            (
                select autoid, txdate,sum((case when nml > 0 then 0 else nml end) + ovd) PRIN_MOVE
                        /*sum(intnmlacr +intdue+intovd+intovdprin +
                        feeintnmlacr+ feeintdue+feeintovd+feeintovdprin) PRFEE_MOVE*/
                from ( select * from lnschdlog union all select * from lnschdloghist ) lnslog
                where nvl(deltd,'N') <>'Y' --and txdate > TO_DATE('01/09/2014','DD/MM/YYYY')
                and (case when nml > 0 then 0 else nml end) + ovd <> 0
                group by autoid,txdate
            ) LNmov on lntr.autoid = lnmov.autoid and lnmov.txdate > lntr.txdate
group by lntr.autoid, lntr.txdate, ln.acctno, ls.rlsdate, ls.overduedate,
        ls.nml , ls.ovd , ls.paid ,
        lntr.prin_move, lntr.int_move
order by lntr.autoid,lntr.txdate
;
      /* select  v.Groupid, LN.ACCTNO acctno,
        case when ln.ftype ='DF' then 'DF' else
           (case when ls.reftype ='GP' then 'BL' else 'CL' end) end  F_TYPE,
           to_char(ls.rlsdate,'DD/MM/RRRR') rlsdate,TO_CHAR(ls.overduedate,'DD/MM/RRRR') overduedate,
           ls.nml+ls.ovd+ls.paid F_GTGN,
           ls.PAID - nvl(LNTR.PRIN_MOVE,0) F_GTTL,
           ls.nml+ls.ovd  -  nvl(LNTR.PRIN_MOVE,0)  F_DNHT,
           ls.intnmlacr+ls.intdue+ls.intovd+ls.intovdprin +
           ls.feeintnmlacr + ls.feeintovdacr + ls.feeintnmlovd + ls.feeintdue
           - nvl(LNTR.PRFEE_MOVE,0) F_LAI_PHI,
            case when ln.ftype ='DF' then  to_char(ln.rate2) || ' - ' || to_char(ln.cfrate2)  else
           --bao lanh
           (case when ls.reftype ='GP' then to_char(ln.orate2) || ' - ' || to_char(ln.cfrate2) else
           --margin
           to_char(ln.rate2) || ' - ' || to_char(ln.cfrate2) end) end  F_TLLAI
           --ban due chua tat toan ODCALLSELLMR
           --(case when V_IDATE  <> V_CURRDATE then -1 else  NVL(V.ODCALLSELLMRATE,0) end) VNDSELLDF ,
           --(case when V_IDATE  <> V_CURRDATE then -1 else nvl(v.ODCALLDF,0) end) ODCALLDF,
      from  (select * from lnmast union select * from lnmasthist) ln,
            (select * from lnschd union select * from lnschdhist) ls,
            (
                select autoid,sum((case when nml > 0 then 0 else nml end) + ovd) PRIN_MOVE,
                        sum(intnmlacr +intdue+intovd+intovdprin +
                        feeintnmlacr+ feeintdue+feeintovd+feeintovdprin) PRFEE_MOVE
                from ( select * from lnschdlog union all select * from lnschdloghist ) lnslog
                where nvl(deltd,'N') <>'Y' and txdate > TO_DATE(T_DATE,'DD/MM/YYYY')
                group by autoid
            ) LNTR,
      CFMAST CF, afmast af , v_getgrpdealformular v, v_getsecmarginratio sec
where ln.acctno = ls.acctno
and ls.reftype in ('P','GP')
--and ls.rlsdate <=  V_IDATE
AND ls.rlsdate >= TO_DATE(F_DATE,'DD/MM/YYYY')
AND ls.rlsdate <= TO_DATE(T_DATE,'DD/MM/YYYY')
and ln.acctno = v.lnacctno (+)
and ls.autoid = LNTR.autoid(+)
AND CF.CUSTID = AF.CUSTID
AND LN.trfacctno = AF.ACCTNO
AND AF.ACCTNO LIKE V_STRACCTNO
and af.acctno = sec.afacctno;*/

EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GetRePaymentHist');
END pr_GetRePaymentHist;
PROCEDURE pr_regtranferacc(p_check in varchar2,--check hay thuc hien luu luon           --1.5.1.3   OTP,
                        p_type in varchar2,-- 0 : Chuyen khoan noi bo.  1: Chuyen khoan ra NH
                        p_afacctno in varchar2,-- So tieu khoan goc
                        p_ciacctno in varchar2,-- So tieu khoan nhan trong truong hop chuyen khoan noi bo
                        p_ciname in varchar2,  -- Ten tieu khoan nhan trong truong hop chuyen khoan noi bo
                        p_bankacc in varchar2, -- So tk Ngan hang
                        p_bankacname in varchar2, -- Ten chu TK ngan hang
                        p_bankname in varchar2,  -- Ten Ngan Hang
                        p_cityef in varchar2,    -- Ten CHI NHANH
                        p_citybank in varchar2,  -- TEN THANH PHO
                        P_BANKID IN VARCHAR2,    -- BANK_NO.SB_BRANCH_CODE
                        P_bankorgno IN VARCHAR2, -- bank_no.org_bank
                        p_err_code out varchar2,
                        p_err_message out VARCHAR2,
                        p_ipaddress in  varchar2 default '' , --1.5.3.0
                        p_via in varchar2 default '',
                        p_validationtype in varchar2 default '',
                        p_devicetype IN varchar2 default '',
                        p_device  IN varchar2 default ''

                        )
    IS
   v_currdate  date;
   v_count number;
   -- begin 1.5.1.3 | 1806
   l_datasourcesms varchar2(1000);
   v_custodycd varchar2(20);
   v_mobile varchar2(15);
   -- end 1.5.1.3 | 1806

   -- begin ver: 1.5.0.2 | iss: 1693
   v_custid     cfmast.custid%TYPE;
   v_custid1    cfmast.custid%TYPE;
   v_custname   cfmast.fullname%TYPE;
   v_custstatus cfmast.status%TYPE;
   -- end ver: 1.5.0.2 | iss: 1693
   v_autoid    NUMBER;
BEGIN
 Select TO_DATE (varvalue, systemnums.c_date_format) into v_currdate
 From sysvar
 Where varname='CURRDATE';
 plog.setbeginsection(pkgctx, 'pr_regtranferacc');
 p_err_code := systemnums.C_SUCCESS;
    -- Check host & branch active or inactive
    p_err_code := fn_CheckActiveSystem;
    IF p_err_code <> systemnums.C_SUCCESS THEN
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_regtranferacc');
        return;
    END IF;
    -- begin 1.5.1.3 | 1806
    select custodycd, mobile into v_custodycd, v_mobile from afmast a, cfmast c where a.custid = c.custid and a.acctno = p_afacctno;
    -- end 1.5.1.3 | 1806

    -- begin ver: 1.5.0.2 | iss: 1693
    BEGIN
      SELECT custid INTO v_custid FROM afmast WHERE acctno = p_afacctno;
      SELECT fullname, status INTO v_custname, v_custstatus
      FROM cfmast WHERE custid = v_custid;

      IF upper(nmpks_ems.fn_convert_to_vn((v_custname))) <> upper(trim(p_bankacname)) THEN -- Khong trung ten
        p_err_code := -901210;
      ELSIF v_custstatus <> 'A' THEN -- Trang thai khong hop le
        p_err_code := -901215;
      END IF;
    EXCEPTION
       WHEN OTHERS THEN -- Tai khoan khong ton tai
         p_err_code := -90019;
    END;

    IF p_err_code <> systemnums.C_SUCCESS THEN
        p_err_message := cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_regtranferacc');
        RETURN;
    END IF;

    --1.8.2.1|: Chan k cho phep dk TK thu huong chuyen khoan noi bo
   BEGIN
     IF p_type = '0' THEN
       SELECT custid INTO v_custid FROM afmast WHERE acctno = p_afacctno;
       SELECT custid INTO v_custid1 FROM afmast WHERE acctno = p_ciacctno;
       if v_custid <> v_custid1 then
        p_err_code := '-200255';
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.setendsection (pkgctx, 'pr_regtranferacc');
        RETURN ;
        end if;
     END IF;
   EXCEPTION WHEN OTHERS THEN
         p_err_code:='-200255';
         p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
         plog.error(pkgctx, 'Error:'  || p_err_message);
         plog.setendsection(pkgctx, 'pr_regtranferacc');
        return;
    END;
   --end 1.8.2.1

    --check ten TK thu huong trung ten KH
    --v_count:=0;
    --Begin
    --    Select count(1) into v_count
    --    From cfmast
    --    Where upper(nmpks_ems.fn_convert_to_vn(trim(fullname))) = upper(trim(p_bankacname)) and status = 'A'
    --        AND custid IN (SELECT custid FROM afmast WHERE acctno = p_afacctno);
    --EXCEPTION
    --When others then
    --     v_count:=0;
    --End;

    --IF v_count=0 then
    --    p_err_code:=-901210;
    --    p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
    --    plog.error(pkgctx, 'Error:'  || p_err_message);
    --    plog.setendsection(pkgctx, 'pr_regtranferacc');
    --    return;
    --END IF;
    --End check ten TK thu huong trung ten KH
    -- end ver: 1.5.0.2 | iss: 1693

    IF p_type='0' then
        v_count:=0;
        Begin
            Select count(1) into v_count
            From afmast
            Where acctno=p_ciacctno ;
        EXCEPTION
         When others then
         v_count:=0;
        End;

        IF v_count=0 then
            p_err_code:=errnums.C_CF_AFMAST_NOTFOUND;
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_regtranferacc');
            return;
        else
            v_count:=0;
            Begin
                Select count(1) into v_count
                From afmast
                Where acctno=p_ciacctno and status = 'A' AND COREBANK='N';
            EXCEPTION
            When others then
                 v_count:=0;
            End;
            If v_count=0 then
                p_err_code:=errnums.C_CF_AFMAST_INVALIDSTATUS;
                p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
                plog.error(pkgctx, 'Error:'  || p_err_message);
                plog.setendsection(pkgctx, 'pr_regtranferacc');
                return;
            end if;
        end if;
    End if;

        For vc in(select a1.acctno
                 from afmast a1, afmast a2
                 where a1.custid=a2.custid
                       and a2.acctno= p_afacctno)
       Loop
           v_count:=0;
           Select count(1) into v_count
           From cfotheracc
           Where afacctno=vc.acctno
             and ((p_type='0' and ciaccount = p_ciacctno)
                  or
                  (p_type='1'and bankacc = p_bankacc)
                 );
           If   v_count = 0 AND p_check = 'N' THEN          --1.5.1.3   OTP
                        insert into cfotheracc( autoid, afacctno, ciaccount, ciname, custid, bankacc,
                                 bankacname, bankname, type, acnidcode, acniddate,
                                 acnidplace, feecd, cityef, citybank,BANKID,bankorgno,via,username,tlid,createdate)
                          values(seq_cfotheracc.nextval,vc.acctno, p_ciacctno, p_ciname, null, p_bankacc,
                                 p_bankacname, p_bankname, p_type, null, null,
                                 null, null, p_cityef, p_citybank,P_BANKID,P_bankorgno,'O','online',systemnums.C_ONLINE_USERID,v_currdate);

           End if;
      End loop;
        -- begin 1.5.1.3 | 1806
       if(p_type = '1') AND p_check = 'N' then
             begin
               l_datasourcesms := 'select ''KBSV thong bao TK ' || v_custodycd ||
        ' da dang ky thanh cong TK ngan hang thu huong: ' || p_bankacc || ''' detail from dual';
                 nmpks_ems.InsertEmailLog(v_mobile,
               '0333',
               l_datasourcesms,
               v_custodycd);
             end;
        end if;
       -- end 1.5.1.3 | 1806


  plog.setendsection(pkgctx, 'pr_regtranferacc');
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_regtranferacc');
    p_err_code := errnums.C_SYSTEM_ERROR;
END pr_regtranferacc;
procedure pr_EditTranferacc(p_type in varchar2,-- 0 : Chuyen khoan noi bo.  1: Chuyen khoan ra NH
                        p_afacctno in varchar2,-- So tieu khoan goc
                        p_ciacctno in varchar2,-- So tieu khoan nhan trong truong hop chuyen khoan noi bo
                        p_ciname in varchar2,  -- Ten tieu khoan nhan trong truong hop chuyen khoan noi bo
                        p_bankacc in varchar2, -- So tk Ngan hang
                        p_bankacname in varchar2, -- Ten chu TK ngan hang
                        p_ciacctno_old in varchar2,-- So tieu khoan nhan cu trong truong hop chuyen khoan noi bo
                        p_bankacc_old in varchar2, -- So tk Ngan hang cu
                        p_err_code out varchar2,
                        p_err_message out VARCHAR2
                        ) -- Ham sua so tk chuyen khoan
IS
   v_currdate  date;
   v_count number;
BEGIN
 Select TO_DATE (varvalue, systemnums.c_date_format) into v_currdate
 From sysvar
 Where varname='CURRDATE';
 plog.setbeginsection(pkgctx, 'pr_EditTranferacc');
 p_err_code := systemnums.C_SUCCESS;
    -- Check host & branch active or inactive
    p_err_code := fn_CheckActiveSystem;
    IF p_err_code <> systemnums.C_SUCCESS THEN
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_EditTranferacc');
        return;
    END IF;

        For vc in(select a1.acctno
                 from afmast a1, afmast a2
                 where a1.custid=a2.custid
                       and a2.acctno= p_afacctno)
       Loop
           Update cfotheracc
           Set ciaccount = p_ciacctno,
               ciname = p_ciname,
               bankacc = p_bankacc,
               bankacname=p_bankacname
           Where afacctno=vc.acctno
             and ((p_type='0' and ciaccount = p_ciacctno_old)
                  or
                  (p_type='1'and bankacc = p_bankacc_old)
                 );

      End loop;

  plog.setendsection(pkgctx, 'pr_EditTranferacc');
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_EditTranferacc');
    p_err_code := errnums.C_SYSTEM_ERROR;
END pr_EditTranferacc;
procedure pr_RemoveTranferacc(p_type in varchar2,-- 0 : Chuyen khoan noi bo.  1: Chuyen khoan ra NH
                        p_afacctno in varchar2,-- So tieu khoan goc
                        p_ciacctno in varchar2,-- So tieu khoan nhan trong truong hop chuyen khoan noi bo
                        p_bankacc in varchar2, -- So tk Ngan hang
                        p_err_code out varchar2,
                        p_err_message out VARCHAR2
                        )
IS
   v_currdate  date;
   v_count number;
BEGIN
 Select TO_DATE (varvalue, systemnums.c_date_format) into v_currdate
 From sysvar
 Where varname='CURRDATE';
 plog.setbeginsection(pkgctx, 'pr_RemoveTranferacc');
 p_err_code := systemnums.C_SUCCESS;
    -- Check host & branch active or inactive
    p_err_code := fn_CheckActiveSystem;
    IF p_err_code <> systemnums.C_SUCCESS THEN
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_RemoveTranferacc');
        return;
    END IF;

        For vc in(select a1.acctno
                 from afmast a1, afmast a2
                 where a1.custid=a2.custid
                       and a2.acctno= p_afacctno)
       Loop
           delete  cfotheracc
           Where afacctno=vc.acctno
             and ((p_type='0' and ciaccount = p_ciacctno)
                  or
                  (p_type='1'and bankacc = p_bankacc)
                 );

      End loop;

  plog.setendsection(pkgctx, 'pr_RemoveTranferacc');
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_RemoveTranferacc');
    p_err_code := errnums.C_SYSTEM_ERROR;
END pr_RemoveTranferacc;
PROCEDURE pr_resetpassonline(p_username varchar,
                            p_idcode  varchar2,
                            p_mobile number,
                            p_email varchar2,
                            p_err_code  OUT varchar2,
                            p_err_message out varchar2)
  IS
      l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      l_err_param varchar2(300);
      v_username   varchar2(200);
      v_custid    varchar2(200);
      v_tokenid  varchar2(200);
      v_LOGINPWD varchar2(200);
      v_tradingpwd varchar2(200);
      v_authtype varchar2(200);
      v_email varchar2(200);
      v_count number;
      v_custodycd varchar2(20);


  BEGIN
    plog.setbeginsection(pkgctx, 'pr_resetpassonline');
   plog.debug(pkgctx, 'p_functionname:  fn_CheckActiveSystem');
    -- Check host & branch active or inactive
    p_err_code := fn_CheckActiveSystem;
    IF p_err_code <> systemnums.C_SUCCESS THEN
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_resetpassonline');
        return;
    END IF;
    -- End: Check host & branch active or inactive

     -- Lay thong tin khach hang
     plog.debug(pkgctx, 'p_functionname:  pr_resetpassonline');
    v_count:=0;
    SELECT count(1)
    INTO   v_count
    FROM CFMAST CF, userlogin usl
    WHERE CF.USERNAME=USL.username
          and upper(cf.username)=UPPER(p_username)
          and (p_email is null or length(trim(p_email))=0 OR upper(cf.email) = upper(p_email))
          and cf.mobile=p_mobile
          and cf.idcode=p_idcode
          AND cf.USERNAME IS NOT NULL;

  plog.debug(pkgctx, '  pr_resetpassonline v_count :'||v_count);
    If v_count = 0 then
            p_err_code:='-200002';
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_resetpassonline');
            return;
    End if;
     plog.debug(pkgctx, '  pr_resetpassonline 1 :');
    SELECT cf.custid,cf.username,cf.email,
           nvl(usl.tokenid,'{MSBS{SMS{'||NVL(CF.mobile,'SDT')||'}}}') tokenid,
           cf.custodycd
    INTO   v_custid,v_username,v_email,v_tokenid, v_custodycd
    FROM CFMAST CF, userlogin usl
    WHERE upper(CF.username)=upper(p_username)
    AND  cf.username = usl.username (+);
    v_tradingpwd:=cspks_system.fn_passwordgenerator(6);
    v_LOGINPWD:=cspks_system.fn_passwordgenerator(6);
plog.debug(pkgctx, '  pr_resetpassonline 2:');
    SELECT TO_DATE (varvalue, systemnums.c_date_format)
               INTO v_strCURRDATE
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := systemnums.C_ONLINE_USERID;
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := 'DAY';
    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd:='0090';

    --Set txnum
    SELECT systemnums.C_OL_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO l_txmsg.txnum
              FROM DUAL;

     l_txmsg.brid        := substr(v_custid,1,4);

    --Set cac field giao dich
    --03   CUSTID     C
    l_txmsg.txfields ('03').defname   := 'CUSTID';
    l_txmsg.txfields ('03').TYPE      := 'C';
    l_txmsg.txfields ('03').VALUE     := v_custid;
    --05   USERNAME     C
    l_txmsg.txfields ('05').defname   := 'USERNAME';
    l_txmsg.txfields ('05').TYPE      := 'C';
    l_txmsg.txfields ('05').VALUE     := v_username;
    --06   EMAIL     C
    l_txmsg.txfields ('06').defname   := 'EMAIL';
    l_txmsg.txfields ('06').TYPE      := 'C';
    l_txmsg.txfields ('06').VALUE     := v_EMAIL;
    --10   LOGINPWD     C
    l_txmsg.txfields ('10').defname   := 'LOGINPWD';
    l_txmsg.txfields ('10').TYPE      := 'C';
    l_txmsg.txfields ('10').VALUE     := v_LOGINPWD;
    --11  AUTHTYPE
    l_txmsg.txfields ('11').defname   := 'AUTHTYPE';
    l_txmsg.txfields ('11').TYPE      := 'C';
    l_txmsg.txfields ('11').VALUE     := 'N';
    --12  TRADINGPWD
    l_txmsg.txfields ('12').defname   := 'TRADINGPWD';
    l_txmsg.txfields ('12').TYPE      := 'C';
    l_txmsg.txfields ('12').VALUE     := v_TRADINGPWD;
    --13  DAYS
    l_txmsg.txfields ('13').defname   := 'DAYS';
    l_txmsg.txfields ('13').TYPE      := 'N';
    l_txmsg.txfields ('13').VALUE     := 100;
    -- 14  ISMASTER
    l_txmsg.txfields ('14').defname   := 'ISMASTER';
    l_txmsg.txfields ('14').TYPE      := 'C';
    l_txmsg.txfields ('14').VALUE     := 'N';
    -- 15  TOKENID
    l_txmsg.txfields ('15').defname   := 'TOKENID';
    l_txmsg.txfields ('15').TYPE      := 'C';
    l_txmsg.txfields ('15').VALUE     := v_tokenid;
    --30 DESC
    l_txmsg.txfields ('30').defname   := 'DESC';
    l_txmsg.txfields ('30').TYPE      := 'C';
    l_txmsg.txfields ('30').VALUE     := 'Reset online trading passs';
    --88 CUSTODYCD
    l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
    l_txmsg.txfields ('88').TYPE      := 'C';
    l_txmsg.txfields ('88').VALUE     := v_custodycd;

plog.debug(pkgctx, '  pr_resetpassonline 3 :');


    BEGIN
        IF txpks_#0090.fn_autotxprocess (l_txmsg,
                                         p_err_code,
                                         l_err_param
           ) <> systemnums.c_success
        THEN
           plog.debug (pkgctx,
                       'got error 0090: ' || p_err_code
           );
           ROLLBACK;
           p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
           plog.error(pkgctx, 'Error:'  || p_err_message);
           plog.setendsection(pkgctx, 'pr_resetpassonline');
           RETURN;
        END IF;
    END;
    plog.debug(pkgctx, '  pr_resetpassonline 4 :');
    p_err_code:='0';
    plog.setendsection(pkgctx, 'pr_resetpassonline');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_resetpassonline');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_resetpassonline');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_resetpassonline;

procedure pr_get_TradelotRetail(p_refcursor in out pkg_report.ref_cursor,
          p_afacctno in varchar2,
          p_symbol in varchar,
          f_date in varchar2,
          t_date in varchar2,
          pv_status in varchar2)
is
    v_afacctno varchar2(10);
    v_fromDate date;
    v_toDate date;
    v_status varchar2(10);
    v_symbol varchar2(10);
begin
    plog.setbeginsection(pkgctx, 'pr_get_TradelotRetail');
    v_afacctno := p_afacctno;
    v_fromDate := to_date(f_date, 'dd/mm/rrrr');
    v_toDate := to_date(t_date,'dd/mm/rrrr');
    v_status := pv_status;
    v_symbol := UPPER(p_symbol);
    IF v_afacctno = 'ALL'  THEN
        v_afacctno :='%';
    END IF;
    IF v_status = 'ALL' THEN
       v_status := '%';
    END IF;
    IF v_symbol = 'ALL' THEN
       v_symbol :='%';
    END IF;
    Open p_refcursor FOR
        select * from
           (select inf.symbol,r.txdate, s.afacctno, r.qtty, r.price, r.qtty * r.price amt, r.feeamt,
                   case when r.status <> 'C' then 'P' else r.status end status,
                   r.taxamt, (r.qtty*r.price) - r.feeamt - r.taxamt realamt
            from seretail r, semast s, securities_info inf
                where r.acctno = s.acctno and inf.codeid = s.codeid
                      and r.status not in ('N','R'))
          where status like v_status and afacctno like v_afacctno
                and symbol like v_symbol
                and txdate >= v_fromDate and txdate <= v_toDate;

    plog.setendsection(pkgctx, 'pr_get_TradelotRetail');
exception when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'pr_get_TradelotRetail');
end pr_get_TradelotRetail;


--Dang ky ban chung khoan lo le tren online
PROCEDURE pr_Tradelot_Retail(   p_sellafacctno varchar2,
                                p_symbol    VARCHAR2,
                                p_quantity varchar2,
                                p_quoteprice varchar2,
                                p_err_code  OUT varchar2,
                                p_err_message out varchar2)
  IS
      l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      l_err_param varchar2(300);
      v_count number;
      --
      l_symbol varchar2(10);
      l_buyafacctno VARCHAR2(10);
      l_sellafacctno varchar2(10);
      l_quantity number(20,4);
      l_quoteprice number(20,4);
      --
      v_sellCustodycd varchar2(20);
      v_buyCustodycd varchar2(20);
      v_sellFullname varchar2(200);
      v_sellAddress varchar2(200);
      v_sellLicense varchar2(100);
      v_volumeQtty number(20,4); --So du CK lo le tren so luu ky.
      v_tkQtty number(20,4); --So du CK lo le tren tieu khoan.
      v_sellSEACCTNO varchar2(30);
      v_buySEACCTNO varchar2(30);
      v_amount number(20,4);
      v_feetype varchar2(20);
      v_feeamt number(20,4);
      v_parValue number(20,4);
      v_iscorebank number;
      v_tradelot number;
      v_taxRate number(20,4);
      v_taxAmt number(20,4);
      v_codeid varchar2(20);
      v_desc varchar2(200);
      v_basicPrice number(20,4);
      v_floorPrice number(20,4);
      v_iddate varchar2(20);
      v_idplace varchar2(100);
      v_vat varchar2(1);
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_Tradelot_Retail');

    v_buyCustodycd := '091P000001';
    l_symbol := UPPER(p_symbol);
    l_sellafacctno := p_sellafacctno;
    l_quantity := to_number(p_quantity);
    l_quoteprice := to_number(p_quoteprice);
    --Lay dien giai giao dich
    SELECT TLTX.EN_TXDESC INTO v_desc FROM TLTX WHERE TLTXCD = '8878';

    --Lay thong tin tai khoan mua chung khoan lo le:
    SELECT VALUE  INTO l_buyafacctno
        FROM VW_CUSTODYCD_SUBACCOUNT WHERE FILTERCD = v_buyCustodycd and rownum = 1 order by value;

    -- Check host & branch active or inactive
    p_err_code := fn_CheckActiveSystem;
    IF p_err_code <> systemnums.C_SUCCESS THEN
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_Tradelot_Retail');
        return;
    END IF;
    -- End: Check host & branch active or inactive

    --Lay thong tin tai khoan ban chung khoan lo le:
    SELECT C.CUSTODYCD, C.FULLNAME, C.ADDRESS, C.IDCODE,
           CASE WHEN MST.COREBANK = 'Y' THEN 1 ELSE 0 END ISCOREBANK, C.idplace, C.iddate, T.VAT
          INTO v_sellCustodycd, v_sellFullname, v_sellAddress, v_sellLicense, v_iscorebank, v_idplace, v_iddate,v_vat
        FROM AFMAST A, CFMAST C, CIMAST MST, AFTYPE T
          WHERE A.CUSTID = C.CUSTID AND A.ACCTNO = MST.AFACCTNO
                AND A.ACTYPE = T.ACTYPE
                AND A.ACCTNO = l_sellafacctno;
    --Lay thong tin ma chung khoan
    SELECT SEC.codeid, SEC.PARVALUE, SEINFO.BASICPRICE PRICE, SEINFO.TRADELOT,SEINFO.FLOORPRICE
         INTO v_codeid, v_parValue, v_basicPrice, v_tradelot, v_floorPrice
        FROM SBSECURITIES SEC, SECURITIES_INFO SEINFO
            WHERE SEC.CODEID=SEINFO.CODEID and sec.SECTYPE <>'004'
                  AND SEC.SYMBOL =l_symbol;

    v_buySEACCTNO := trim(l_buyafacctno) || trim(v_codeid);
    v_sellSEACCTNO := trim(l_sellafacctno) || trim(v_codeid);
    --Tinh so chung khoan lo le con tren so luu ky
    v_volumeQtty := fn_GetCKLL(v_sellCustodycd, v_codeid);

    --Tinh so chung khoan lo le tren tieu khoan
    v_tkQtty := fn_GetCKLL_AF(l_sellafacctno, v_codeid);

    IF l_quantity > v_volumeQtty --OR l_quantity > v_tkQtty
     THEN
        p_err_code := '-900121';
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_Tradelot_Retail');
        return;
    END IF;

    v_amount := l_quantity * l_quoteprice;
    v_feetype := '00009'; --dang mac dinh ma bieu phi cho giao dich 8878 la 00009
    v_feeamt := fn_cal_fee_amt(v_amount,v_feetype);

    v_taxRate := 0;
    IF v_vat = 'Y' THEN
       SELECT VARVALUE INTO v_taxRate FROM SYSVAR WHERE VARNAME = 'ADVSELLDUTY';
    END IF;
    v_taxAmt := v_amount * v_taxRate/100;

    SELECT TO_DATE (varvalue, systemnums.c_date_format)
               INTO v_strCURRDATE
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := systemnums.C_ONLINE_USERID;
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := 'DAY';
    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd:='8878';

    --Set txnum
    SELECT systemnums.C_OL_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO l_txmsg.txnum
              FROM DUAL;

     l_txmsg.brid        := substr(l_sellafacctno,1,4);

    --Set cac field giao dich
    --01 CODEID
    l_txmsg.txfields ('01').defname   := 'CODEID';
    l_txmsg.txfields ('01').TYPE      := 'C';
    l_txmsg.txfields ('01').VALUE     := v_codeid;
    --88   CUSTODYCD     C
    l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
    l_txmsg.txfields ('88').TYPE      := 'C';
    l_txmsg.txfields ('88').VALUE     := v_sellCustodycd;
    --02   AFACCTNO     C
    l_txmsg.txfields ('02').defname   := 'AFACCTNO';
    l_txmsg.txfields ('02').TYPE      := 'C';
    l_txmsg.txfields ('02').VALUE     := l_sellafacctno;
    --93   VOLUMEQTTY     C
    l_txmsg.txfields ('93').defname   := 'VOLUMEQTTY';
    l_txmsg.txfields ('93').TYPE      := 'N';
    l_txmsg.txfields ('93').VALUE     := v_volumeQtty;
    --94  TKQTTY
    l_txmsg.txfields ('94').defname   := 'TKQTTY';
    l_txmsg.txfields ('94').TYPE      := 'N';
    l_txmsg.txfields ('94').VALUE     := v_tkQtty;
    --90  CUSTNAME
    l_txmsg.txfields ('90').defname   := 'CUSTNAME';
    l_txmsg.txfields ('90').TYPE      := 'C';
    l_txmsg.txfields ('90').VALUE     := v_sellFullname;
    --03  SEACCTNO
    l_txmsg.txfields ('03').defname   := 'SEACCTNO';
    l_txmsg.txfields ('03').TYPE      := 'C';
    l_txmsg.txfields ('03').VALUE     := v_sellSEACCTNO;
    -- 91  ADDRESS
    l_txmsg.txfields ('91').defname   := 'ADDRESS';
    l_txmsg.txfields ('91').TYPE      := 'C';
    l_txmsg.txfields ('91').VALUE     := v_sellAddress;
    -- 89  CUSTODYCD
    l_txmsg.txfields ('89').defname   := 'CUSTODYCD';
    l_txmsg.txfields ('89').TYPE      := 'C';
    l_txmsg.txfields ('89').VALUE     := v_buyCustodycd;
    --08 REFAFACCTNO
    l_txmsg.txfields ('08').defname   := 'REFAFACCTNO';
    l_txmsg.txfields ('08').TYPE      := 'C';
    l_txmsg.txfields ('08').VALUE     := l_buyafacctno;
    --92 LICENSE
    l_txmsg.txfields ('92').defname   := 'LICENSE';
    l_txmsg.txfields ('92').TYPE      := 'C';
    l_txmsg.txfields ('92').VALUE     := v_sellLicense;

    --09 EXSEACCTNO
    l_txmsg.txfields ('09').defname   := 'EXSEACCTNO';
    l_txmsg.txfields ('09').TYPE      := 'C';
    l_txmsg.txfields ('09').VALUE     := v_buySEACCTNO;


    --11 QUOTEPRICE
    l_txmsg.txfields ('11').defname   := 'QUOTEPRICE';
    l_txmsg.txfields ('11').TYPE      := 'N';
    l_txmsg.txfields ('11').VALUE     := l_quoteprice;

    --10 ORDERQTTY
    l_txmsg.txfields ('10').defname   := 'ORDERQTTY';
    l_txmsg.txfields ('10').TYPE      := 'N';
    l_txmsg.txfields ('10').VALUE     := l_quantity;

    --60 AMT
    l_txmsg.txfields ('61').defname   := 'AMT';
    l_txmsg.txfields ('61').TYPE      := 'N';
    l_txmsg.txfields ('61').VALUE     := v_amount;

    --62 FEETYPE
    l_txmsg.txfields ('62').defname   := 'FEETYPE';
    l_txmsg.txfields ('62').TYPE      := 'C';
    l_txmsg.txfields ('62').VALUE     := v_feetype;

    --12 PARVALUE
    l_txmsg.txfields ('12').defname   := 'PARVALUE';
    l_txmsg.txfields ('12').TYPE      := 'C';
    l_txmsg.txfields ('12').VALUE     := v_parValue;

    --60 ISCOREBANK
    l_txmsg.txfields ('60').defname   := 'ISCOREBANK';
    l_txmsg.txfields ('60').TYPE      := 'C';
    l_txmsg.txfields ('60').VALUE     := v_iscorebank;

    --13 TRADELOT
    l_txmsg.txfields ('13').defname   := 'TRADELOT';
    l_txmsg.txfields ('13').TYPE      := 'N';
    l_txmsg.txfields ('13').VALUE     := v_tradelot;

    --22 FEEAMT
    l_txmsg.txfields ('22').defname   := 'FEEAMT';
    l_txmsg.txfields ('22').TYPE      := 'N';
    l_txmsg.txfields ('22').VALUE     := v_feeamt;

    --25 TEMP
    l_txmsg.txfields ('25').defname   := 'TEMP';
    l_txmsg.txfields ('25').TYPE      := 'N';
    l_txmsg.txfields ('25').VALUE     := 100;

    --23 TAXRATE
    l_txmsg.txfields ('23').defname   := 'TAXRATE';
    l_txmsg.txfields ('23').TYPE      := 'N';
    l_txmsg.txfields ('23').VALUE     := v_taxRate;

    --24 TAXAMT
    l_txmsg.txfields ('24').defname   := 'TAXAMT';
    l_txmsg.txfields ('24').TYPE      := 'N';
    l_txmsg.txfields ('24').VALUE     := v_taxAmt;

    --73 IDDATE
    l_txmsg.txfields ('73').defname   := 'IDDATE';
    l_txmsg.txfields ('73').TYPE      := 'C';
    l_txmsg.txfields ('73').VALUE     := v_iddate;


    --74 IDPLACE
    l_txmsg.txfields ('74').defname   := 'IDPLACE';
    l_txmsg.txfields ('74').TYPE      := 'C';
    l_txmsg.txfields ('74').VALUE     := v_idplace;

     --75 SECURITIESNAME
    l_txmsg.txfields ('75').defname   := 'SECURITIESNAME';
    l_txmsg.txfields ('75').TYPE      := 'C';
    l_txmsg.txfields ('75').VALUE     := l_symbol;


    --30 DESC
    l_txmsg.txfields ('30').defname   := 'DESC';
    l_txmsg.txfields ('30').TYPE      := 'C';
    l_txmsg.txfields ('30').VALUE     := v_desc;

    --1.8.2.5: bo sung quyen
    l_txmsg.txfields ('15').defname   := 'PITQTTY';
    l_txmsg.txfields ('15').TYPE      := 'N';
    l_txmsg.txfields ('15').VALUE     := fn_getsepitbo_max(v_sellSEACCTNO,l_quantity,0);

    BEGIN
        IF txpks_#8878.fn_autotxprocess (l_txmsg,
                                         p_err_code,
                                         l_err_param
           ) <> systemnums.c_success
        THEN
           plog.debug (pkgctx,
                       'got error 8878: ' || p_err_code
           );
           ROLLBACK;
           p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
           plog.error(pkgctx, 'Error:'  || p_err_message);
           plog.setendsection(pkgctx, 'pr_Tradelot_Retail');
           RETURN;
        END IF;

        --iss2623: sua them doan check FO, neu giao dich duoi FO khong thanh cong cung rollback.
        PCK_SYN2FO.PRC_CHECK_SYN2FO(v_txnum =>l_txmsg.txnum,
                                     v_errcode => p_err_code,
                                     v_errmsg => p_err_message);


        plog.debug (pkgctx, 'PRC_CHECK_SYN2FO p_err_code '||p_err_code);
        IF p_err_code <> systemnums.c_success THEN
            ROLLBACK;
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error (pkgctx, p_err_message);
            plog.setendsection(pkgctx, 'pr_Depoacc2Transfer');
            RETURN;
        END IF;
    END;
    p_err_code:='0';
    plog.setendsection(pkgctx, 'pr_Tradelot_Retail');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_Tradelot_Retail');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_Tradelot_Retail');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_Tradelot_Retail;

  --Huy dang ky ban chung khoan lo le tren online
PROCEDURE pr_Cancel_Tradelot_Retail(   p_sellafacctno varchar2,
                                p_symbol    VARCHAR2,
                                p_txnum varchar2,
                                p_txdate varchar2,
                                p_err_code  OUT varchar2,
                                p_err_message out varchar2)
  IS
      l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      l_err_param varchar2(300);
      v_count number;
      --
      l_sellafacctno varchar2(10);
      l_symbol varchar2(20);
      v_codeid varchar2(10);
      v_sellseacctno varchar2(30);
      v_buyafacctno varchar2(10);
      v_buyseacctno varchar2(30);
      l_txdate DATE;
      l_txnum varchar2(20);
      v_quoteprice number(20,4);
      v_quantity number(20,4);
      v_parvalue number(20,4);
      v_desc varchar2(200);
      --1.8.2.5:thue quyen
      v_pitqtty NUMBER(20,4);
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_Cancel_Tradelot_Retail');
    l_symbol := UPPER(p_symbol);
    l_sellafacctno := p_sellafacctno;
    l_txdate := TO_DATE(p_txdate,'dd/mm/rrrr');
    l_txnum := p_txnum;
    --Lay dien giai giao dich
    SELECT TLTX.EN_TXDESC INTO v_desc FROM TLTX WHERE TLTXCD = '8817';

    -- Check host & branch active or inactive
    p_err_code := fn_CheckActiveSystem;
    IF p_err_code <> systemnums.C_SUCCESS THEN
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_Cancel_Tradelot_Retail');
        return;
    END IF;
    -- End: Check host & branch active or inactive

    begin 
    SELECT  B.ACCTNO, B.PRICE, B.QTTY, B.DESACCTNO,
            C.CODEID, C.PARVALUE, A2.AFACCTNO AFACCTNO2, NVL(pitqtty,0) pitqtty
          INTO v_sellseacctno, v_quoteprice, v_quantity, v_buyseacctno,
               v_codeid, v_parvalue, v_buyafacctno,v_pitqtty
        FROM SEMAST A, SERETAIL B, SBSECURITIES C ,AFMAST AF , CFMAST CF ,ALLCODE A4,SEMAST A2,
             (SELECT txnum, txdate, sum(qtty) pitqtty FROM sepitallocate GROUP BY txnum, txdate) sep
            WHERE A.ACCTNO = B.ACCTNO AND A.CODEID = C.CODEID
                  AND B.QTTY > 0 AND B.status ='N' AND AF.ACCTNO =A.AFACCTNO
                  AND AF.CUSTID =CF.CUSTID
                  AND A4.CDTYPE = 'SE' AND A4.CDNAME = 'TRADEPLACE'  AND A4.CDVAL = C.TRADEPLACE
                  AND A2.ACCTNO=B.DESACCTNO
                  AND A.AFACCTNO = l_sellafacctno
                  AND C.SYMBOL = l_symbol
                  AND B.TXDATE = l_txdate
                  AND B.TXNUM = l_txnum
                  AND B.txdate = sep.txdate (+)
                  AND B.txnum = sep.txnum (+);
    exception when others then
      p_err_code:='-90021';
      p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
      plog.error(pkgctx, 'Error:'  || p_err_message);
      plog.setendsection(pkgctx, 'pr_Cancel_Tradelot_Retail');
      RETURN;
    end;              



    SELECT TO_DATE (varvalue, systemnums.c_date_format)
               INTO v_strCURRDATE
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := systemnums.C_ONLINE_USERID;
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := 'DAY';
    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd:='8817';

    --Set txnum
    SELECT systemnums.C_OL_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO l_txmsg.txnum
              FROM DUAL;

     l_txmsg.brid        := substr(l_sellafacctno,1,4);

    --Set cac field giao dich
    --01 CODEID
    l_txmsg.txfields ('01').defname   := 'CODEID';
    l_txmsg.txfields ('01').TYPE      := 'C';
    l_txmsg.txfields ('01').VALUE     := v_codeid;
    --02   AFACCTNO     C
    l_txmsg.txfields ('02').defname   := 'AFACCTNO';
    l_txmsg.txfields ('02').TYPE      := 'C';
    l_txmsg.txfields ('02').VALUE     := l_sellafacctno;
    --03   SEACCTNO     C
    l_txmsg.txfields ('03').defname   := 'SEACCTNO';
    l_txmsg.txfields ('03').TYPE      := 'C';
    l_txmsg.txfields ('03').VALUE     := v_sellseacctno;
    --07   AFACCTNO2     C
    l_txmsg.txfields ('07').defname   := 'AFACCTNO2';
    l_txmsg.txfields ('07').TYPE      := 'N';
    l_txmsg.txfields ('07').VALUE     := v_buyafacctno;
    --09  DESACCTNO
    l_txmsg.txfields ('09').defname   := 'DESACCTNO';
    l_txmsg.txfields ('09').TYPE      := 'N';
    l_txmsg.txfields ('09').VALUE     := v_buyseacctno;
    --04  TXDATE
    l_txmsg.txfields ('04').defname   := 'TXDATE';
    l_txmsg.txfields ('04').TYPE      := 'D';
    l_txmsg.txfields ('04').VALUE     := l_txdate;
    --05  TXNUM
    l_txmsg.txfields ('05').defname   := 'TXNUM';
    l_txmsg.txfields ('05').TYPE      := 'C';
    l_txmsg.txfields ('05').VALUE     := l_txnum;
    -- 11  QUOTEPRICE
    l_txmsg.txfields ('11').defname   := 'QUOTEPRICE';
    l_txmsg.txfields ('11').TYPE      := 'N';
    l_txmsg.txfields ('11').VALUE     := v_quoteprice;
    -- 10  ORDERQTTY
    l_txmsg.txfields ('10').defname   := 'ORDERQTTY';
    l_txmsg.txfields ('10').TYPE      := 'N';
    l_txmsg.txfields ('10').VALUE     := v_quantity;
    --12 PARVALUE
    l_txmsg.txfields ('12').defname   := 'PARVALUE';
    l_txmsg.txfields ('12').TYPE      := 'N';
    l_txmsg.txfields ('12').VALUE     := v_parvalue;
    --30 DESC
    l_txmsg.txfields ('30').defname   := 'DESC';
    l_txmsg.txfields ('30').TYPE      := 'C';
    l_txmsg.txfields ('30').VALUE     := v_desc;

    --1.8.2.5: thue quyen
    l_txmsg.txfields ('15').defname   := 'PITQTTY';
    l_txmsg.txfields ('15').TYPE      := 'N';
    l_txmsg.txfields ('15').VALUE     := v_pitqtty;

    BEGIN
        IF txpks_#8817.fn_autotxprocess (l_txmsg,
                                         p_err_code,
                                         l_err_param
           ) <> systemnums.c_success
        THEN
           plog.debug (pkgctx,
                       'got error 8817: ' || p_err_code
           );
           ROLLBACK;
           p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
           plog.error(pkgctx, 'Error:'  || p_err_message);
           plog.setendsection(pkgctx, 'pr_Cancel_Tradelot_Retail');
           RETURN;
        END IF;
    END;
    p_err_code:='0';
    plog.setendsection(pkgctx, 'pr_Cancel_Tradelot_Retail');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_Cancel_Tradelot_Retail');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_Cancel_Tradelot_Retail');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_Cancel_Tradelot_Retail;


  --Huy dang ky ban chung khoan lo le tren online
PROCEDURE pr_Transfer_SE_account(p_trfafacctno varchar2,
                                p_rcvafacctno varchar2,
                                p_symbol    VARCHAR2,
                                p_quantity varchar2,
                                p_blockedqtty varchar2,
                                p_err_code  OUT varchar2,
                                p_err_message out varchar2)
  IS
      l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      l_err_param varchar2(300);
      v_count number;

      l_trfafacctno varchar2(10);
      l_rcvafacctno varchar2(10);
      l_symbol varchar2(20);
      l_qtty number(20,4);
      v_codeid varchar2(10);
      v_trfseacctno varchar2(30);
      v_custname varchar2(100);
      v_address  varchar2(300);
      v_license  varchar2(100);
      v_rcvseacctno varchar2(30);
      v_custname2 varchar2(100);
      v_orgamt number(20,4);
      v_address2 varchar2(300);
      v_license2 varchar2(100);
      v_amt_chk  number(20,4);
      v_amt number(20,4);
      v_qttytype varchar2(10);
      v_depoblock_chk number(20,4);
      v_depoblock number(20,4);
      v_autoid number(20,4);
      v_orgtradewtf number(20,4);
      v_mintradewtf number(20,4);
      v_tradewtf number(20,4);
      v_qtty number(20,4);
      v_parvalue number(20,4);
      v_price  number(20,4);
      v_depolastdt date;
      v_depofeeamt number(20,4);
      v_depofeeacr number(20,4);
      v_trtype varchar2(10);
      v_needqtty number(20);
      v_desc varchar2(200);
      temp varchar2(200);
      v_DB_ACCTNO_UPDATECOST VARCHAR2(30);
      v_CODEID_UPDATECOST VARCHAR2(10);

      v_maxqtty number(20,4);
      v_getavlqtty number(20,4);

  BEGIN
    plog.setbeginsection(pkgctx, 'pr_Transfer_SE_account');

    l_trfafacctno := p_trfafacctno;
    l_rcvafacctno := p_rcvafacctno;
    l_symbol := upper(p_symbol);

    l_qtty := to_number(p_quantity);
    v_depoblock := to_number(p_blockedqtty);

    --Lay dien giai giao dich
    SELECT TLTX.EN_TXDESC INTO v_desc FROM TLTX WHERE TLTXCD = '2242';
    SELECT TO_DATE (varvalue, systemnums.c_date_format)
               INTO v_strCURRDATE
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    -- Check host & branch active or inactive
    p_err_code := fn_CheckActiveSystem;
    IF p_err_code <> systemnums.C_SUCCESS THEN
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_Transfer_SE_account');
        return;
    END IF;

    -- End: Check host & branch active or inactive
/*
    SELECT semast.acctno,
       sym.codeid codeid,
       costprice,
         least(semast.trade, fn_get_semast_avl_withdraw(semast.afacctno, semast.codeid)) trade,
       least(trade -NVL(od.secureamt,0)+NVL(od.sereceiving,0),GETAVLSEWITHDRAW(semast.acctno)) ORGAMT,
       nvl(pit.qtty,0) tradewtf, nvl(pit.qtty,0) ORGTRADEWTF,
       sym.parvalue, '0' autoid,
       cf.idcode,  cf.fullname, cf.ADDRESS,semast.afacctno||nvl(sym.refcodeid,sym.codeid) DB_ACCTNO_UPDATECOST,
       nvl(sym.refcodeid,sym.codeid) CODEID_UPDATECOST
    INTO v_trfseacctno,v_codeid,v_price, v_amt_chk,v_orgamt,v_tradewtf,v_orgtradewtf,v_parvalue,
         v_autoid, v_license, v_custname, v_address,
         v_DB_ACCTNO_UPDATECOST,v_CODEID_UPDATECOST
          FROM sbsecurities sym,
          (SELECT SEACCTNO, SUM(SECUREAMT) SECUREAMT, SUM(SECUREMTG) SECUREMTG, SUM(RECEIVING) SERECEIVING
            FROM (SELECT OD.SEACCTNO,
                    CASE WHEN OD.EXECTYPE IN ('NS', 'SS') AND OD.TXDATE =to_date(SY.VARVALUE,'DD/MM/YYYY') THEN REMAINQTTY + EXECQTTY ELSE 0 END SECUREAMT,
                    CASE WHEN OD.EXECTYPE = 'MS'  AND OD.TXDATE =to_date(SY.VARVALUE,'DD/MM/YYYY') THEN REMAINQTTY + EXECQTTY ELSE 0 END SECUREMTG,
                    CASE WHEN OD.EXECTYPE = 'NB' THEN ST.QTTY ELSE 0 END RECEIVING
                FROM ODMAST OD, STSCHD ST, ODTYPE TYP, SYSVAR SY
                WHERE OD.DELTD <> 'Y'  AND OD.EXECTYPE IN ('NS', 'SS','MS', 'NB')
                    AND OD.ORDERID = ST.ORGORDERID(+) AND ST.DUETYPE(+) = 'RS'
                    And OD.ACTYPE = TYP.ACTYPE
                    AND SY.GRNAME = 'SYSTEM' AND SY.VARNAME = 'CURRDATE'
                    AND ((TYP.TRANDAY <= (SELECT SUM(CASE WHEN CLDR.HOLIDAY = 'Y' THEN 0 ELSE 1 END)
                    FROM SBCLDR CLDR
                    WHERE CLDR.CLDRTYPE = '000' AND CLDR.SBDATE >= ST.TXDATE AND CLDR.SBDATE <= (select to_date(VARVALUE,'DD/MM/YYYY') from sysvar where grname='SYSTEM' and varname='CURRDATE')) AND OD.EXECTYPE = 'NB')
                    OR OD.EXECTYPE IN ('NS','SS','MS')))
            GROUP BY SEACCTNO ) od, (select custodycd, custid custidcfmast, idcode,fullname, iddate, idplace,ADDRESS  from cfmast) cf, (select brid, custid custidafmast, acctno acctnoafmast from afmast) af,
            (select acctno , sum(qtty) qtty from semastdtl where status='N' AND DELTD <>'Y' AND  qttytype ='002' group by acctno)setl,
                  SEMAST,
        (select acctno,sum(qtty-mapqtty) qtty
            from sepitlog where deltd <> 'Y' and qtty-mapqtty>0
            group by acctno) pit
         WHERE sym.codeid = semast.codeid
           AND sym.symbol = l_symbol
           AND semast.afacctno = l_trfafacctno
           AND sym.sectype <> '004'
           AND semast.acctno = setl.acctno(+)
           AND semast.afacctno = af.acctnoafmast
           and af.custidafmast = cf.custidcfmast
           AND nvl(setl.QTTY,0) + (trade -NVL(od.secureamt,0)+NVL(od.sereceiving,0)) > 0
           AND semast.acctno =od.seacctno(+)
           and semast.acctno =pit.acctno(+);*/
 ------------
 --ngoc.vu edit
   select codeid into v_codeid from SBSECURITIES where symbol=l_symbol;

   v_maxqtty := fn_get_semast_avl_withdraw(l_trfafacctno,v_codeid);
   v_getavlqtty:=nvl(GETAVLSEWITHDRAW(l_trfafacctno||v_codeid),0);

     SELECT semast.acctno,
      -- sym.codeid codeid,
       costprice,
       least(semast.trade,v_maxqtty) trade,
       least(trade -NVL(od.secureamt,0)+NVL(od.sereceiving,0),v_getavlqtty) ORGAMT,
       nvl(pit.qtty,0) tradewtf, nvl(pit.qtty,0) ORGTRADEWTF,
       sym.parvalue, '0' autoid,
       cf.idcode,  cf.fullname, cf.ADDRESS,semast.afacctno||nvl(sym.refcodeid,sym.codeid) DB_ACCTNO_UPDATECOST,
       nvl(sym.refcodeid,sym.codeid) CODEID_UPDATECOST
    INTO v_trfseacctno,/*v_codeid,*/v_price, v_amt_chk,v_orgamt,v_tradewtf,v_orgtradewtf,v_parvalue,
         v_autoid, v_license, v_custname, v_address,
         v_DB_ACCTNO_UPDATECOST,v_CODEID_UPDATECOST
          FROM sbsecurities sym,
          (SELECT SEACCTNO, SUM(SECUREAMT) SECUREAMT, SUM(SECUREMTG) SECUREMTG, SUM(RECEIVING) SERECEIVING
            FROM (SELECT OD.SEACCTNO,
                    CASE WHEN OD.EXECTYPE IN ('NS', 'SS') AND OD.TXDATE =to_date(SY.VARVALUE,'DD/MM/YYYY') THEN REMAINQTTY + EXECQTTY ELSE 0 END SECUREAMT,
                    CASE WHEN OD.EXECTYPE = 'MS'  AND OD.TXDATE =to_date(SY.VARVALUE,'DD/MM/YYYY') THEN REMAINQTTY + EXECQTTY ELSE 0 END SECUREMTG,
                    CASE WHEN OD.EXECTYPE = 'NB' THEN ST.QTTY ELSE 0 END RECEIVING
                FROM ODMAST OD, STSCHD ST, ODTYPE TYP, SYSVAR SY
                WHERE OD.DELTD <> 'Y'  AND OD.EXECTYPE IN ('NS', 'SS','MS', 'NB')
                    AND OD.ORDERID = ST.ORGORDERID(+) AND ST.DUETYPE(+) = 'RS'
                    And OD.ACTYPE = TYP.ACTYPE
                    AND SY.GRNAME = 'SYSTEM' AND SY.VARNAME = 'CURRDATE'
                    AND OD.AFACCTNO=l_trfafacctno AND OD.CODEID=v_codeid
                    AND ((TYP.TRANDAY <= (SELECT SUM(CASE WHEN CLDR.HOLIDAY = 'Y' THEN 0 ELSE 1 END)
                    FROM SBCLDR CLDR
                    WHERE CLDR.CLDRTYPE = '000' AND CLDR.SBDATE >= ST.TXDATE AND CLDR.SBDATE <= (select to_date(VARVALUE,'DD/MM/YYYY') from sysvar where grname='SYSTEM' and varname='CURRDATE')) AND OD.EXECTYPE = 'NB')
                    OR OD.EXECTYPE IN ('NS','SS','MS')))
            GROUP BY SEACCTNO ) od,
             (select custodycd, custid custidcfmast, idcode,fullname, iddate, idplace,ADDRESS  from cfmast) cf,

            (select brid, custid custidafmast, acctno acctnoafmast from afmast
             WHERE ACCTNO=l_trfafacctno) af,

            (select acctno , sum(qtty) qtty from semastdtl
             where status='N' AND DELTD <>'Y' AND  qttytype ='002'
                   AND ACCTNO=l_trfafacctno||v_codeid group by acctno)setl,

            (SELECT * FROM SEMAST WHERE AFACCTNO=l_trfafacctno AND CODEID=v_codeid) SEMAST,

            (select acctno,sum(qtty-mapqtty) qtty
                from sepitlog where deltd <> 'Y' and qtty-mapqtty>0
                      AND AFACCTNO=l_trfafacctno AND CODEID=v_codeid
                group by acctno) pit
         WHERE sym.codeid = semast.codeid
           AND sym.symbol = l_symbol
           AND semast.afacctno = l_trfafacctno
           AND sym.sectype <> '004'
           AND semast.acctno = setl.acctno(+)
           AND semast.afacctno = af.acctnoafmast
           and af.custidafmast = cf.custidcfmast
           AND nvl(setl.QTTY,0) + (trade -NVL(od.secureamt,0)+NVL(od.sereceiving,0)) > 0
           AND semast.acctno =od.seacctno(+)
           and semast.acctno =pit.acctno(+);
    ------------------

    SELECT to_date(DEPOLASTDT,'dd/mm/rrrr') INTO v_depolastdt FROM CIMAST WHERE AFACCTNO = l_rcvafacctno;
    v_custname2 := v_custname;
    v_license2 := v_license;
    v_address2 := v_address;
    v_rcvseacctno := l_rcvafacctno || v_codeid;


    v_qttytype := '002';
    v_depoblock_chk := FN_GET_SE_BLOCKQTTY(l_trfafacctno,v_codeid, v_qttytype);
    v_depoblock := LEAST(v_depoblock, v_depoblock_chk);

    v_mintradewtf := GREATEST(0,v_orgtradewtf + l_qtty + v_depoblock - v_amt_chk - v_depoblock_chk);

    v_qtty := l_qtty + v_depoblock;

    v_price := FN_GET_SE_COSTPRICE(l_trfafacctno,v_codeid, v_price);


    v_depofeeacr := TO_NUMBER(FN_CIGETDEPOFEEACR(l_rcvafacctno,v_codeid,v_strCURRDATE,v_strCURRDATE,to_number(v_qtty)));

    v_depofeeamt := TO_NUMBER(FN_CIGETDEPOFEEAMT(l_rcvafacctno,v_codeid,v_strCURRDATE,v_strCURRDATE,to_number(v_qtty)));

    v_needqtty := cspks_seproc.fn_getSEDeposit(v_codeid, l_rcvafacctno);



    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := systemnums.C_ONLINE_USERID;
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := 'DAY';
    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd:='2242';

    --Set txnum
    SELECT systemnums.C_OL_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO l_txmsg.txnum
              FROM DUAL;

     l_txmsg.brid        := substr(l_trfafacctno,1,4);
    --CODEID
    l_txmsg.txfields ('01').defname   := 'CODEID';
    l_txmsg.txfields ('01').TYPE      := 'C';
    l_txmsg.txfields ('01').VALUE     := v_codeid;
    --AFACCTNO
    l_txmsg.txfields ('02').defname   := 'AFACCTNO';
    l_txmsg.txfields ('02').TYPE      := 'C';
    l_txmsg.txfields ('02').VALUE     := l_trfafacctno;
    --ACCTNO
    l_txmsg.txfields ('03').defname   := 'ACCTNO';
    l_txmsg.txfields ('03').TYPE      := 'C';
    l_txmsg.txfields ('03').VALUE     := v_trfseacctno;
    --CUSTNAME
    l_txmsg.txfields ('90').defname   := 'CUSTNAME';
    l_txmsg.txfields ('90').TYPE      := 'C';
    l_txmsg.txfields ('90').VALUE     := v_custname;
    --ADDRESS
    l_txmsg.txfields ('91').defname   := 'ADDRESS';
    l_txmsg.txfields ('91').TYPE      := 'C';
    l_txmsg.txfields ('91').VALUE     := v_address;
    --LICENSE
    l_txmsg.txfields ('92').defname   := 'LICENSE';
    l_txmsg.txfields ('92').TYPE      := 'C';
    l_txmsg.txfields ('92').VALUE     := v_license;
    --AFACCT2
    l_txmsg.txfields ('04').defname   := 'AFACCT2';
    l_txmsg.txfields ('04').TYPE      := 'C';
    l_txmsg.txfields ('04').VALUE     := l_rcvafacctno;
    --ACCT2
    l_txmsg.txfields ('05').defname   := 'ACCT2';
    l_txmsg.txfields ('05').TYPE      := 'C';
    l_txmsg.txfields ('05').VALUE     := v_rcvseacctno;
    --CUSTNAME2
    l_txmsg.txfields ('93').defname   := 'CUSTNAME2';
    l_txmsg.txfields ('93').TYPE      := 'C';
    l_txmsg.txfields ('93').VALUE     := v_custname2;
    --ORGAMT
    l_txmsg.txfields ('19').defname   := 'ORGAMT';
    l_txmsg.txfields ('19').TYPE      := 'N';
    l_txmsg.txfields ('19').VALUE     := v_orgamt;
    --ADDRESS2
    l_txmsg.txfields ('94').defname   := 'ADDRESS2';
    l_txmsg.txfields ('94').TYPE      := 'C';
    l_txmsg.txfields ('94').VALUE     := v_address2;
    --LICENSE2
    l_txmsg.txfields ('95').defname   := 'LICENSE2';
    l_txmsg.txfields ('95').TYPE      := 'C';
    l_txmsg.txfields ('95').VALUE     := v_license2;
    --AMT_CHK
    l_txmsg.txfields ('21').defname   := 'AMT_CHK';
    l_txmsg.txfields ('21').TYPE      := 'N';
    l_txmsg.txfields ('21').VALUE     := v_amt_chk;
    --AMT
    l_txmsg.txfields ('10').defname   := 'AMT';
    l_txmsg.txfields ('10').TYPE      := 'N';
    l_txmsg.txfields ('10').VALUE     := l_qtty;
    --QTTYTYPE
    l_txmsg.txfields ('14').defname   := 'QTTYTYPE';
    l_txmsg.txfields ('14').TYPE      := 'C';
    l_txmsg.txfields ('14').VALUE     := v_qttytype;
    --DEPOBLOCK_CHK
    l_txmsg.txfields ('17').defname   := 'DEPOBLOCK_CHK';
    l_txmsg.txfields ('17').TYPE      := 'N';
    l_txmsg.txfields ('17').VALUE     := v_depoblock_chk;
    --DEPOBLOCK
    l_txmsg.txfields ('06').defname   := 'DEPOBLOCK';
    l_txmsg.txfields ('06').TYPE      := 'N';
    l_txmsg.txfields ('06').VALUE     := v_depoblock;
    --AUTOID
    l_txmsg.txfields ('18').defname   := 'AUTOID';
    l_txmsg.txfields ('18').TYPE      := 'N';
    l_txmsg.txfields ('18').VALUE     := v_autoid;
    --ORGTRADEWTF
    l_txmsg.txfields ('20').defname   := 'ORGTRADEWTF';
    l_txmsg.txfields ('20').TYPE      := 'N';
    l_txmsg.txfields ('20').VALUE     := v_orgtradewtf;
    --TRADEWTF
    l_txmsg.txfields ('22').defname   := 'TRADEWTF';
    l_txmsg.txfields ('22').TYPE      := 'N';
    l_txmsg.txfields ('22').VALUE     := v_mintradewtf;
    --TRADEWTF
    l_txmsg.txfields ('13').defname   := 'TRADEWTF';
    l_txmsg.txfields ('13').TYPE      := 'N';
    l_txmsg.txfields ('13').VALUE     := v_tradewtf;
    --QTTY
    l_txmsg.txfields ('12').defname   := 'QTTY';
    l_txmsg.txfields ('12').TYPE      := 'N';
    l_txmsg.txfields ('12').VALUE     := v_qtty;
    --PARVALUE
    l_txmsg.txfields ('11').defname   := 'PARVALUE';
    l_txmsg.txfields ('11').TYPE      := 'N';
    l_txmsg.txfields ('11').VALUE     := v_parvalue;
    --PRICE
    l_txmsg.txfields ('09').defname   := 'PRICE';
    l_txmsg.txfields ('09').TYPE      := 'N';
    l_txmsg.txfields ('09').VALUE     := v_price/* FN_GET_SE_COSTPRICE(l_trfafacctno,v_codeid,v_price)*/;
    --DEPOLASTDT
    l_txmsg.txfields ('32').defname   := 'DEPOLASTDT';
    l_txmsg.txfields ('32').TYPE      := 'D';
    l_txmsg.txfields ('32').VALUE     := v_depolastdt;
    --DEPOFEEAMT
    l_txmsg.txfields ('15').defname   := 'DEPOFEEAMT';
    l_txmsg.txfields ('15').TYPE      := 'N';
    l_txmsg.txfields ('15').VALUE     := v_depofeeamt;
    --DEPOFEEACR
    l_txmsg.txfields ('16').defname   := 'DEPOFEEACR';
    l_txmsg.txfields ('16').TYPE      := 'B';
    l_txmsg.txfields ('16').VALUE     := v_depofeeacr;
    --TRTYPE
    l_txmsg.txfields ('31').defname   := 'TRTYPE';
    l_txmsg.txfields ('31').TYPE      := 'C';
    l_txmsg.txfields ('31').VALUE     := v_trtype;
    --NEEDQTTY
    l_txmsg.txfields ('96').defname   := 'NEEDQTTY';
    l_txmsg.txfields ('96').TYPE      := 'N';
    l_txmsg.txfields ('96').VALUE     := v_needqtty;
    --DESC
    l_txmsg.txfields ('30').defname   := 'DESC';
    l_txmsg.txfields ('30').TYPE      := 'C';
    l_txmsg.txfields ('30').VALUE     := v_desc;

        --DB_ACCTNO_UPDATECOST
    l_txmsg.txfields ('23').defname   := 'DB_ACCTNO_UPDATECOST';
    l_txmsg.txfields ('23').TYPE      := 'C';
    l_txmsg.txfields ('23').VALUE     := v_DB_ACCTNO_UPDATECOST;
        --CD_ACCTNO_UPDATECOST
    l_txmsg.txfields ('25').defname   := 'CD_ACCTNO_UPDATECOST';
    l_txmsg.txfields ('25').TYPE      := 'C';
    l_txmsg.txfields ('25').VALUE     := l_rcvafacctno||v_CODEID_UPDATECOST;
            --CODEID_UPDATECOST
    l_txmsg.txfields ('24').defname   := 'CODEID_UPDATECOST';
    l_txmsg.txfields ('24').TYPE      := 'C';
    l_txmsg.txfields ('24').VALUE     := v_CODEID_UPDATECOST;

    BEGIN
        IF txpks_#2242.fn_autotxprocess (l_txmsg,
                                         p_err_code,
                                         l_err_param
           ) <> systemnums.c_success
        THEN
           plog.debug (pkgctx,
                       'got error 2242: ' || p_err_code
           );

           -- plog.error(pkgctx, '2242: 1');
           ROLLBACK;
           p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
           plog.error(pkgctx, 'Error:'  || p_err_message);
           plog.setendsection(pkgctx, 'pr_Transfer_SE_account');
           RETURN;
        END IF;
       -- plog.error(pkgctx, '2242: 2');
        --ThanhNV sua them doan check FO, neu giao dich duoi FO khong thanh cong cung rollback.
         PCK_SYN2FO.PRC_CHECK_SYN2FO(v_txnum =>l_txmsg.txnum,
                                     v_errcode => p_err_code,
                                     v_errmsg => p_err_message);


        plog.debug (pkgctx, 'PRC_CHECK_SYN2FO p_err_code '||p_err_code);
      --plog.error(pkgctx, '2242: 3');
  IF p_err_code <> systemnums.c_success THEN
      --plog.error(pkgctx, '2242: 4');
        ROLLBACK;
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error (pkgctx, p_err_message);
            plog.setendsection(pkgctx, 'pr_Transfer_SE_account');
            RETURN;
        END IF;
    --plog.error(pkgctx, '2242: 5');
    END;
    --  plog.error(pkgctx, '2242: 6');
    p_err_code:='0';
    plog.setendsection(pkgctx, 'pr_Transfer_SE_account');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_Transfer_SE_account');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_Transfer_SE_account');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_Transfer_SE_account;

   PROCEDURE pr_regservice(p_afacctno in varchar2,
                        p_sertype in varchar2, --000:GDKQ   001:BROKER
                        p_refid in varchar2 ,   -- ID BROKER
                        p_err_code out varchar2,
                        p_err_message out VARCHAR2
                        )
    IS
   v_currdate  date;
BEGIN
 Select TO_DATE (varvalue, systemnums.c_date_format) into v_currdate
 From sysvar
 Where varname='CURRDATE';
 plog.setbeginsection(pkgctx, 'pr_regtranferacc');
 p_err_code := systemnums.C_SUCCESS;
    -- Check host & branch active or inactive
    p_err_code := fn_CheckActiveSystem;
    IF p_err_code <> systemnums.C_SUCCESS THEN
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_regtranferacc');
        return;
    END IF;

       insert into AFSERVICES(autoid,afactno,sertype,refid,regdate,
                             regtlid,status,changedate,changetlid)
                     values(seq_AFSERVICES.nextval,p_afacctno,p_sertype,p_refid,v_currdate,
                         systemnums.C_ONLINE_USERID,'P',null,null);

  plog.setendsection(pkgctx, 'pr_regservice');
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_regservice');
    p_err_code := errnums.C_SYSTEM_ERROR;
END pr_regservice;
function fn_getExTransferMoneyFee(p_amount number,
                                  p_bankid varchar2
                                ) return number as
  v_feetype varchar2(20);
  v_feeamt  number(20);
  begin
     If P_bankid like '302%' or P_bankid like '202%' or P_bankid like '309%' then
        v_feetype:='00016';
     ELSE
        if to_number(p_amount) < 500000000 then
           v_feetype:='00017';
        else v_feetype:= '20000';
        end if;
     End if;
     v_feeamt:=fn_gettransfermoneyfee(p_amount,v_feetype);
     return v_feeamt;
  exception
    when others then
      return 0;
  end ;

function fn_getInTransferMoneyFee(p_account varchar,
                                  p_toaccount  varchar2,
                                  p_amount number
                                ) return number as
  v_feetype varchar2(20);
  v_feeamt  number(20);

  begin
     v_feetype:='00015';
     For rec in(Select 1
                From afmast a1, afmast a2
                 where a1.acctno=p_account  and a2.acctno= p_toaccount and a1.custid = a2.custid)
     -- Cung so luu ky
     Loop
         v_feetype:='00014';
     End loop;
     v_feeamt:=fn_gettransfermoneyfee(p_amount,v_feetype);
     return v_feeamt;
  exception
    when others then
      return 0;
  end;

  -- Dang ky nhan canh bao
  procedure pr_regalert(p_custid in varchar2,
                        p_regsms in varchar2,
                        p_err_code out varchar2,
                        p_err_message out VARCHAR2
                        )
  IS
   l_txmsg       tx.msg_rectype;
   l_err_param varchar2(300);
   v_currdate  date;
   v_regdate  date;
   v_count number;
   v_afaccount varchar2(100) ;
   v_ciaccount varchar2(100);
   v_avlbal number(20,0);
   v_todate date;
   v_custodycd varchar2(100);
   v_custname varchar2(100);
   v_fullname varchar2(100);
   v_ADDRESS varchar2(100);
   v_LICENSE varchar2(100);
   v_IDDATE varchar2(100);
   v_IDPLACE varchar2(100);
   v_desc   varchar2(100);
   v_SMSAMT number(20,0);
   v_WARAMT number(20,0);
   v_amt    number(20,0);
   v_tmpSMSAMT number(20,0);
   v_tmpWARAMT number(20,0);
   v_DateCount  number(20,0);
   v_regstatus  varchar2(1);



BEGIN
 Select TO_DATE (varvalue, systemnums.c_date_format) into v_currdate
 From sysvar
 Where varname='CURRDATE';
 plog.setbeginsection(pkgctx, 'pr_regalert');

 plog.debug(pkgctx, 'BEGIN of pr_regalert');
 p_err_code := systemnums.C_SUCCESS;
        -- Check host & branch active or inactive
        p_err_code := fn_CheckActiveSystem;
        IF p_err_code <> systemnums.C_SUCCESS THEN
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_regalert');
            return;
        END IF;

        plog.debug(pkgctx, ' p_custid: ' || p_custid);

        select nvl(custodycd,'a') into v_custodycd from cfmast where custid = trim(p_custid);
        if length(v_custodycd) = 1 then
            p_err_code:= '-570015';
             plog.debug(pkgctx, 'v_custodycd: ' || v_custodycd || ' p_custid: ' || p_custid);
            plog.setendsection(pkgctx, 'pr_regalert');
            return;
        end if;

        select count(*) into v_count from cfregalert where registerid = trim(p_custid) ;

        select max(sbdate) into v_todate from sbcldr where to_char(sbdate,'MM/RRRR') = to_char(v_currdate,'MM/RRRR') and cldrtype = '000';

        select count(*) into v_DateCount from sbcldr where to_char(sbdate,'MM/RRRR') = to_char(v_currdate,'MM/RRRR') and cldrtype = '000';


        select afacctno, acctno , avlbal into v_afaccount, v_ciaccount, v_avlbal from
        (
            select afacctno, acctno , getbaldefovd(afacctno) avlbal
           -- into v_afaccount, v_ciaccount, v_avlbal
            from cimast where custid = p_custid AND STATUS in ('A','P')
            order by getbaldefovd(afacctno) desc
        ) where rownum=1;


        SELECT to_number(VARVALUE) INTO v_WARAMT from sysvar where VARNAME = 'WEBWARAMT';
        SELECT to_number(VARVALUE) INTO v_SMSAMT from sysvar where VARNAME = 'WEBSMSAMT';

        v_amt:=0;
        v_tmpWARAMT:= 0;
        v_tmpSMSAMT:= 0;
        if p_regsms <> 'N' then
            v_tmpSMSAMT:=  v_SMSAMT/v_DateCount * GREATEST(v_todate - v_currdate,1);
            v_amt:= v_amt + v_tmpSMSAMT;
        end if;

        plog.debug(pkgctx, 'v_amt: ' || v_amt || ' v_DateCount: ' || v_DateCount || ' (v_todate - v_currdate): ' || (v_todate - v_currdate));


        if (v_count > 0) then
            select nvl(TODATE,v_currdate), status into v_regdate, v_regstatus from cfregalert where registerid = trim(p_custid) ;
            plog.debug(pkgctx, 'v_regdate: ' || v_regdate );

            if (to_char(v_regdate,'MM/RRRR') <> to_char(v_todate,'MM/RRRR')) then

                -- Tinh phi theo so ngay thuc te trong thang
                v_tmpWARAMT:= v_WARAMT / v_DateCount * GREATEST(v_todate - v_currdate,1);
                v_amt:= v_amt + v_tmpWARAMT;
                plog.debug(pkgctx, 'v_amt: ' || v_amt || ' v_tmpWARAMT: ' || v_tmpWARAMT || ' v_tmpSMSAMT: ' || v_tmpSMSAMT);

            end if;

            if v_avlbal >= v_amt then

                 INSERT INTO CFREGALERTHIST (autoid, vendor, regaccttyp, registerid, regdate,
                            opndate, frdate, todate, clsdate, paiddate, status, regsms, afacctno)
                 SELECT autoid, vendor, regaccttyp, registerid, regdate, opndate, frdate, todate, clsdate, paiddate, status,
                       regsms, afacctno FROM cfregalert  where registerid = p_custid;

                delete from cfregalert where registerid = p_custid;
                 --update cfregalert set status = 'A', regsms = decode(p_regsms,'N','N','Y') , CLSDATE=NULL,REGDATE= v_currdate, FRDATE = v_currdate, TODATE= v_todate where registerid = p_custid;
                  insert into cfregalert(autoid, vendor, regaccttyp, registerid, regdate,
                 opndate, frdate, todate, paiddate, status,REGSMS, afacctno)
                 values(seq_cfregalert.nextval,'IOD','C',p_custid,v_currdate,
                 v_currdate,v_currdate,v_todate,v_currdate,'A',p_regsms,v_afaccount);


            end if;
        else
            if v_avlbal >= v_amt then
                 insert into cfregalert(autoid, vendor, regaccttyp, registerid, regdate,
                 opndate, frdate, todate, paiddate, status,REGSMS, afacctno)
                 values(seq_cfregalert.nextval,'IOD','C',p_custid,v_currdate,
                 v_currdate,v_currdate,v_todate,v_currdate,'A',p_regsms,v_afaccount);
            end if;
        end if;

        select CUSTODYCD, FULLNAME CUSTNAME, FULLNAME, ADDRESS, IDCODE LICENSE, IDDATE, IDPLACE
            into  v_custodycd,  v_custname, v_fullname, v_ADDRESS, v_LICENSE, v_IDDATE, v_IDPLACE
        from cfmast where custid = p_custid;

        if v_amt > 0 then
            if (v_avlbal >= v_amt) then

                plog.debug(pkgctx, 'Sinh gd 1113: v_amt: ' || v_amt || ' v_tmpWARAMT: ' || v_tmpWARAMT || ' v_tmpSMSAMT: ' || v_tmpSMSAMT);

                l_txmsg.msgtype:='T';
                l_txmsg.local:='N';
                l_txmsg.tlid        := systemnums.C_ONLINE_USERID;
                SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                         SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
                  INTO l_txmsg.wsname, l_txmsg.ipaddress
                FROM DUAL;
                l_txmsg.off_line    := 'N';
                l_txmsg.deltd       := txnums.c_deltd_txnormal;
                l_txmsg.txstatus    := txstatusnums.c_txcompleted;
                l_txmsg.msgsts      := '0';
                l_txmsg.ovrsts      := '0';
                l_txmsg.batchname   := 'DAY';
                l_txmsg.txdate:=to_date(v_currdate,systemnums.c_date_format);
                l_txmsg.busdate:=to_date(v_currdate,systemnums.c_date_format);
                l_txmsg.tltxcd:='1113';

                SELECT TXDESC INTO v_desc FROM TLTX WHERE TLTXCD = '1113';

                --Set txnum
                SELECT systemnums.C_OL_PREFIXED
                                 || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                          INTO l_txmsg.txnum
                          FROM DUAL;

                 l_txmsg.brid        := substr(v_afaccount,1,4);

                 --88  C   CUSTODYCD
                l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                l_txmsg.txfields ('88').TYPE      := 'C';
                l_txmsg.txfields ('88').VALUE     := v_custodycd;

                --03  C   ACCTNO
                l_txmsg.txfields ('03').defname   := 'ACCTNO';
                l_txmsg.txfields ('03').TYPE      := 'C';
                l_txmsg.txfields ('03').VALUE     := v_afaccount;

                --90  C   CUSTNAME
                l_txmsg.txfields ('90').defname   := 'CUSTNAME';
                l_txmsg.txfields ('90').TYPE      := 'C';
                l_txmsg.txfields ('90').VALUE     := v_custname;

                --95  C   FULLNAME
                l_txmsg.txfields ('95').defname   := 'FULLNAME';
                l_txmsg.txfields ('95').TYPE      := 'C';
                l_txmsg.txfields ('95').VALUE     := v_FULLNAME;

                --91  C   ADDRESS
                l_txmsg.txfields ('91').defname   := 'ADDRESS';
                l_txmsg.txfields ('91').TYPE      := 'C';
                l_txmsg.txfields ('91').VALUE     := v_ADDRESS;

                --92  C   LICENSE
                l_txmsg.txfields ('92').defname   := 'LICENSE';
                l_txmsg.txfields ('92').TYPE      := 'C';
                l_txmsg.txfields ('92').VALUE     := v_LICENSE;

                --98  C   IDDATE
                l_txmsg.txfields ('98').defname   := 'IDDATE';
                l_txmsg.txfields ('98').TYPE      := 'C';
                l_txmsg.txfields ('98').VALUE     := v_IDDATE;

                --99  C   IDPLACE
                l_txmsg.txfields ('99').defname   := 'IDPLACE';
                l_txmsg.txfields ('99').TYPE      := 'C';
                l_txmsg.txfields ('99').VALUE     := v_IDPLACE;

                --66  C   VOUCHERTYPE
                l_txmsg.txfields ('66').defname   := 'VOUCHERTYPE';
                l_txmsg.txfields ('66').TYPE      := 'C';
                l_txmsg.txfields ('66').VALUE     := '';

                --89  N   AVLCASH
                l_txmsg.txfields ('89').defname   := 'AVLCASH';
                l_txmsg.txfields ('89').TYPE      := 'N';
                l_txmsg.txfields ('89').VALUE     := v_avlbal;

                --12  N   SMSAMT
                l_txmsg.txfields ('12').defname   := 'SMSAMT';
                l_txmsg.txfields ('12').TYPE      := 'N';
                l_txmsg.txfields ('12').VALUE     := v_tmpSMSAMT;

                --11  N   WARAMT
                l_txmsg.txfields ('11').defname   := 'WARAMT';
                l_txmsg.txfields ('11').TYPE      := 'N';
                l_txmsg.txfields ('11').VALUE     := v_tmpWARAMT;

                --10  N   AMT
                l_txmsg.txfields ('10').defname   := 'AMT';
                l_txmsg.txfields ('10').TYPE      := 'N';
                l_txmsg.txfields ('10').VALUE     := v_amt;

                --79  C   REFID
                l_txmsg.txfields ('79').defname   := 'REFID';
                l_txmsg.txfields ('79').TYPE      := 'C';
                l_txmsg.txfields ('79').VALUE     := '';

                --30  C   DESC
                l_txmsg.txfields ('30').defname   := 'DESC';
                l_txmsg.txfields ('30').TYPE      := 'C';
                l_txmsg.txfields ('30').VALUE     := v_desc;


                BEGIN
                    IF txpks_#1113.fn_autotxprocess (l_txmsg,
                                                     p_err_code,
                                                     l_err_param
                       ) <> systemnums.c_success
                    THEN
                       plog.debug (pkgctx,
                                   'got error 1113: ' || p_err_code
                       );
                       ROLLBACK;
                       p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
                       plog.error(pkgctx, 'Error:'  || p_err_message);
                       plog.setendsection(pkgctx, 'pr_Transfer_SE_account');
                       RETURN;
                    END IF;
                END;

            else
                --update cfregalert set status = 'C', CLSDATE= v_currdate where registerid = p_custid;
                p_err_code:='-400101';
                return;

            end if;
        end if;

   p_err_code := systemnums.C_SUCCESS;
  plog.setendsection(pkgctx, 'pr_regalert');
return;
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_regalert');
    p_err_code := errnums.C_SYSTEM_ERROR;
END pr_regalert;


   -- Dk/huy nhan canh bao
  procedure pr_updateregalert(p_custid in varchar2,
                        p_stopalert in varchar2,
                        p_regsms in varchar2,
                        p_err_code out varchar2,
                        p_err_message out VARCHAR2
                        )
  IS
   l_txmsg       tx.msg_rectype;
   l_err_param varchar2(300);
   v_currdate  date;
   v_regdate  date;
   v_count number;
   v_afaccount varchar2(100) ;
   v_ciaccount varchar2(100);
   v_avlbal number(20,0);
   v_todate date;
   v_custodycd varchar2(100);
   v_custname varchar2(100);
   v_fullname varchar2(100);
   v_ADDRESS varchar2(100);
   v_LICENSE varchar2(100);
   v_IDDATE varchar2(100);
   v_IDPLACE varchar2(100);
   v_desc   varchar2(100);
   v_SMSAMT number(20,0);
   v_WARAMT number(20,0);
   v_tmpSMSAMT number(20,0);
   v_tmpWARAMT number(20,0);
   v_amt    number(20,0);
   v_DateCount  number(20,0);
   v_regstatus  varchar2(1);



BEGIN
 Select TO_DATE (varvalue, systemnums.c_date_format) into v_currdate
 From sysvar
 Where varname='CURRDATE';
 plog.setbeginsection(pkgctx, 'pr_regalert');

 plog.debug(pkgctx, 'BEGIN of pr_regalert');
 p_err_code := systemnums.C_SUCCESS;
    -- Check host & branch active or inactive
    p_err_code := fn_CheckActiveSystem;
    IF p_err_code <> systemnums.C_SUCCESS THEN
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_regtranferacc');
        return;
    END IF;

    select count(*) into v_count from cfregalert where registerid = trim(p_custid) ;

    select max(sbdate) into v_todate from sbcldr where to_char(sbdate,'MM/RRRR') = to_char(v_currdate,'MM/RRRR') and cldrtype = '000';

    select count(*) into v_DateCount from sbcldr where to_char(sbdate,'MM/RRRR') = to_char(v_currdate,'MM/RRRR') and cldrtype = '000';


    select afacctno, acctno , avlbal into v_afaccount, v_ciaccount, v_avlbal from
    (
        select afacctno, acctno , getbaldefovd(afacctno) avlbal
        --into v_afaccount, v_ciaccount, v_avlbal
        from cimast where custid = p_custid AND STATUS in ('A','P')
        order by getbaldefovd(afacctno) desc
    ) where rownum=1;

     v_tmpSMSAMT:= 0;
     v_tmpWARAMT:= 0;
     v_amt:=0  ;
    plog.debug(pkgctx, 'v_afaccount: ' || v_afaccount || ' v_avlbal: ' || v_avlbal || ' v_count: ' || v_count  );
    if (p_stopalert <> 'Y') then

        if p_regsms <> 'Y' then
             update cfregalert set regsms = 'N' where registerid = p_custid;
        else

            select nvl(TODATE,v_currdate), status into v_regdate, v_regstatus from cfregalert where registerid = trim(p_custid) ;

            --if (to_char(v_regdate,'MM/RRRR') <> to_char(v_todate,'MM/RRRR')) then

                select CUSTODYCD, FULLNAME CUSTNAME, FULLNAME, ADDRESS, IDCODE LICENSE, IDDATE, IDPLACE
                    into  v_custodycd,  v_custname, v_fullname, v_ADDRESS, v_LICENSE, v_IDDATE, v_IDPLACE
                from cfmast where custid = p_custid;

                SELECT to_number(VARVALUE) INTO v_WARAMT from sysvar where VARNAME = 'WEBWARAMT';
                SELECT to_number(VARVALUE) INTO v_SMSAMT from sysvar where VARNAME = 'WEBSMSAMT';

                v_tmpSMSAMT:= v_SMSAMT / v_DateCount * GREATEST(v_todate - v_currdate,1);
                v_amt:= v_amt + v_tmpSMSAMT  ;

                if (to_char(v_regdate,'MM/RRRR') <> to_char(v_todate,'MM/RRRR')) then
                    -- Tinh phi theo so ngay thuc te trong thang
                    v_tmpWARAMT:= v_amt / v_DateCount * GREATEST(v_todate - v_currdate,1);
                    v_amt:= v_amt + v_tmpWARAMT;
                end if;
                plog.debug(pkgctx, 'v_tmpWARAMT: ' || v_tmpWARAMT || ' v_tmpSMSAMT: ' || v_tmpSMSAMT || ' v_regdate ' || v_regdate);
                plog.debug(pkgctx, 'v_amt: ' || v_amt || ' v_DateCount: ' || v_DateCount || ' (v_todate - v_currdate): ' || (v_todate - v_currdate));


                if v_avlbal >= v_amt then

                    plog.debug(pkgctx, 'Sinh gd 1113' );

                    l_txmsg.msgtype:='T';
                    l_txmsg.local:='N';
                    l_txmsg.tlid        := systemnums.C_ONLINE_USERID;
                    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
                      INTO l_txmsg.wsname, l_txmsg.ipaddress
                    FROM DUAL;
                    l_txmsg.off_line    := 'N';
                    l_txmsg.deltd       := txnums.c_deltd_txnormal;
                    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
                    l_txmsg.msgsts      := '0';
                    l_txmsg.ovrsts      := '0';
                    l_txmsg.batchname   := 'DAY';
                    l_txmsg.txdate:=to_date(v_currdate,systemnums.c_date_format);
                    l_txmsg.busdate:=to_date(v_currdate,systemnums.c_date_format);
                    l_txmsg.tltxcd:='1113';

                    SELECT TXDESC INTO v_desc FROM TLTX WHERE TLTXCD = '1113';

                    --Set txnum
                    SELECT systemnums.C_OL_PREFIXED
                                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                              INTO l_txmsg.txnum
                              FROM DUAL;

                     l_txmsg.brid        := substr(v_afaccount,1,4);

                     --88  C   CUSTODYCD
                    l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                    l_txmsg.txfields ('88').TYPE      := 'C';
                    l_txmsg.txfields ('88').VALUE     := v_custodycd;

                    --03  C   ACCTNO
                    l_txmsg.txfields ('03').defname   := 'ACCTNO';
                    l_txmsg.txfields ('03').TYPE      := 'C';
                    l_txmsg.txfields ('03').VALUE     := v_afaccount;

                    --90  C   CUSTNAME
                    l_txmsg.txfields ('90').defname   := 'CUSTNAME';
                    l_txmsg.txfields ('90').TYPE      := 'C';
                    l_txmsg.txfields ('90').VALUE     := v_custname;

                    --95  C   FULLNAME
                    l_txmsg.txfields ('95').defname   := 'FULLNAME';
                    l_txmsg.txfields ('95').TYPE      := 'C';
                    l_txmsg.txfields ('95').VALUE     := v_FULLNAME;

                    --91  C   ADDRESS
                    l_txmsg.txfields ('91').defname   := 'ADDRESS';
                    l_txmsg.txfields ('91').TYPE      := 'C';
                    l_txmsg.txfields ('91').VALUE     := v_ADDRESS;

                    --92  C   LICENSE
                    l_txmsg.txfields ('92').defname   := 'LICENSE';
                    l_txmsg.txfields ('92').TYPE      := 'C';
                    l_txmsg.txfields ('92').VALUE     := v_LICENSE;

                    --98  C   IDDATE
                    l_txmsg.txfields ('98').defname   := 'IDDATE';
                    l_txmsg.txfields ('98').TYPE      := 'C';
                    l_txmsg.txfields ('98').VALUE     := v_IDDATE;

                    --99  C   IDPLACE
                    l_txmsg.txfields ('99').defname   := 'IDPLACE';
                    l_txmsg.txfields ('99').TYPE      := 'C';
                    l_txmsg.txfields ('99').VALUE     := v_IDPLACE;

                    --66  C   VOUCHERTYPE
                    l_txmsg.txfields ('66').defname   := 'VOUCHERTYPE';
                    l_txmsg.txfields ('66').TYPE      := 'C';
                    l_txmsg.txfields ('66').VALUE     := '';

                    --89  N   AVLCASH
                    l_txmsg.txfields ('89').defname   := 'AVLCASH';
                    l_txmsg.txfields ('89').TYPE      := 'N';
                    l_txmsg.txfields ('89').VALUE     := v_avlbal;

                    --12  N   SMSAMT
                    l_txmsg.txfields ('12').defname   := 'SMSAMT';
                    l_txmsg.txfields ('12').TYPE      := 'N';
                    l_txmsg.txfields ('12').VALUE     := v_tmpSMSAMT;

                    --11  N   WARAMT
                    l_txmsg.txfields ('11').defname   := 'WARAMT';
                    l_txmsg.txfields ('11').TYPE      := 'N';
                    l_txmsg.txfields ('11').VALUE     := v_tmpWARAMT;

                    --10  N   AMT
                    l_txmsg.txfields ('10').defname   := 'AMT';
                    l_txmsg.txfields ('10').TYPE      := 'N';
                    l_txmsg.txfields ('10').VALUE     := v_amt;

                    --79  C   REFID
                    l_txmsg.txfields ('79').defname   := 'REFID';
                    l_txmsg.txfields ('79').TYPE      := 'C';
                    l_txmsg.txfields ('79').VALUE     := '';

                    --30  C   DESC
                    l_txmsg.txfields ('30').defname   := 'DESC';
                    l_txmsg.txfields ('30').TYPE      := 'C';
                    l_txmsg.txfields ('30').VALUE     := v_desc;


                    BEGIN
                        IF txpks_#1113.fn_autotxprocess (l_txmsg,
                                                         p_err_code,
                                                         l_err_param
                           ) <> systemnums.c_success
                        THEN
                           plog.debug (pkgctx,
                                       'got error 1113: ' || p_err_code
                           );
                           ROLLBACK;
                           p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
                           plog.error(pkgctx, 'Error:'  || p_err_message);
                           plog.setendsection(pkgctx, 'pr_Transfer_SE_account');
                           RETURN;
                        END IF;
                    END;

/*                    INSERT INTO CFREGALERTHIST (autoid, vendor, regaccttyp, registerid, regdate,
                        opndate, frdate, todate, clsdate, paiddate, status, regsms, afacctno)
                    SELECT seq_cfregalert.nextval, vendor, regaccttyp, registerid, regdate, opndate, frdate, todate, clsdate, paiddate, status,
                           regsms, afacctno FROM cfregalert  where registerid = p_custid;*/

                    update cfregalert set regsms = 'Y' where registerid = p_custid;

                 else
                     p_err_code:='-400101';
                     p_err_message:=cspks_system.fn_get_errmsg('-400101');
                     return;
                 end if;
            /*else
                INSERT INTO CFREGALERTHIST SELECT * FROM cfregalert  where registerid = p_custid;
                update cfregalert set regsms = 'Y' where registerid = p_custid;
            end if;*/

        end if;--- cua if p_regsms <> 'Y' then
    else
        plog.debug(pkgctx, 'Huy DK' );
        update cfregalert set status = 'C', CLSDATE= v_currdate where registerid = p_custid;
    end if;
   p_err_code := systemnums.C_SUCCESS;
  plog.setendsection(pkgctx, 'pr_updateregalert');
return  ;
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_updateregalert');
    p_err_code := errnums.C_SYSTEM_ERROR;
END pr_updateregalert;





procedure pr_regalertfile(p_custid in varchar2,
                          p_fullname in varchar2,
                          p_altype in varchar2,
                          p_symbol in varchar2,
                          p_smsnotify in varchar2,
                          p_emailnotify in varchar2,
                          P_autoid out number,
                          p_err_code out varchar2,
                          p_err_message out VARCHAR2
                        )
 IS
   v_currdate  date;
   v_count number;
   v_regprofileid NUMBER;
BEGIN
 Select TO_DATE (varvalue, systemnums.c_date_format) into v_currdate
 From sysvar
 Where varname='CURRDATE';
 plog.setbeginsection(pkgctx, 'pr_regalertfile');
 p_err_code := systemnums.C_SUCCESS;
    -- Check host & branch active or inactive
    p_err_code := fn_CheckActiveSystem;
    IF p_err_code <> systemnums.C_SUCCESS THEN
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_regtranferacc');
        return;
    END IF;
    Select seq_cfalterfile.nextval into p_autoid from dual;
    For vc in   (Select autoid
                 From cfregalert c
                 Where  c.registerid=p_custid and status='A')
    Loop
         v_regprofileid:=vc.autoid;
    End Loop;
    insert into cfaltertfile(autoid, regprofileid, fullname, altype, symbol, smsnotify, emailnotify)
    values (p_autoid,v_regprofileid,p_fullname, p_altype, p_symbol, p_smsnotify, p_emailnotify);

  plog.setendsection(pkgctx, 'pr_regalertfile');
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_regalertfile');
    p_err_code := errnums.C_SYSTEM_ERROR;
END pr_regalertfile;
procedure pr_regalertdtl(p_regfileid in varchar2,
                          p_alterid in varchar2,
                          p_alvalue in VARCHAR2,
                          p_err_code out varchar2,
                          p_err_message out VARCHAR2
                        )
 IS
   v_currdate  date;

BEGIN
 Select TO_DATE (varvalue, systemnums.c_date_format) into v_currdate
 From sysvar
 Where varname='CURRDATE';
 plog.setbeginsection(pkgctx, 'pr_regalertdtl');
 p_err_code := systemnums.C_SUCCESS;
    -- Check host & branch active or inactive
    p_err_code := fn_CheckActiveSystem;
    IF p_err_code <> systemnums.C_SUCCESS THEN
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_regtranferacc');
        return;
    END IF;

    insert into cfalertdtl(autoid,regfileid,alertid,alvalue)
    values (seq_cfalertdtl.nextval,p_regfileid,p_alterid, p_alvalue);

  plog.setendsection(pkgctx, 'pr_regalertdtl');
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_regalertdtl');
    p_err_code := errnums.C_SYSTEM_ERROR;
END pr_regalertdtl;
-- Lay danh sach templates
PROCEDURE pr_GetAFTemplates
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     p_AFACCTNO    IN VARCHAR2
     )
    IS

BEGIN
      OPEN p_REFCURSOR FOR
    SELECT t.code,t.subject,t.type, decode(a.template_code,null,'N','Y') register
       FROM templates t , (select * from aftemplates where AFACCTNO=p_AFACCTNO )a
       Where t.code=a.template_code(+)
       AND T.REQUIRE_REGISTER ='Y'
       AND T.CODE NOT IN ('0208','0334','0808','324A','324B','0555'/*, '0323'*/)--1.8.1.6 bo chan dang ky sms
       Order by t.type, t.code;
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GetAFTemplates');
END pr_GetAFTemplates;
-- Ham dang ky nhan/ bo email/sms
PROCEDURE pr_EditAFTemplates
    (   p_AFACCTNO    IN VARCHAR2,
        p_template_code in varchar2,
        p_type in varchar2, -- ADD or REMOVE
        p_err_code out varchar2,
        p_err_message out VARCHAR2
     )
    IS
  v_count number;
BEGIN
    plog.setbeginsection(pkgctx, 'pr_EditAFTemplates');
    p_err_code := systemnums.C_SUCCESS;
    -- Check host & branch active or inactive
    p_err_code := fn_CheckActiveSystem;
    IF p_err_code <> systemnums.C_SUCCESS THEN
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_EditAFTemplates');
        return;
    END IF;
  --1.8.2.0: MSBS-2385
    if p_type ='REMOVE' and  p_template_code in ('0223','0323')then
    select count(*) into v_count
    from aftemplates where afacctno=p_AFACCTNO and template_code <> p_template_code and template_code in ('0223','0323');
    if(v_count = 0) then
     p_err_code := '-200502';
     p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
         plog.setendsection(pkgctx, 'pr_EditAFTemplates');
         return;
    end if;
    end if;
  --1.8.2.0: end
    If p_type ='ADD' then
      insert into aftemplates(autoid,afacctno,template_code)
      values (seq_aftemplates.nextval,p_AFACCTNO,p_template_code);
    Elsif p_type ='REMOVE' then
      delete aftemplates where afacctno=p_AFACCTNO and template_code =p_template_code;
    End if;
    plog.setendsection(pkgctx, 'pr_EditAFTemplates');
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_EditAFTemplates');
END pr_EditAFTemplates;
PROCEDURE pr_updatepassonline(p_username varchar,
                              P_pwtype   varchar2,
                              P_password   varchar2,
                              p_err_code  OUT varchar2,
                              p_err_message out varchar2)
 IS
      v_mobile varchar2(20);
      l_datasourcesms varchar2(1000);
      l_check NUMBER;
      l_countpin NUMBER;
      l_countpass NUMBER;

  BEGIN
    plog.setbeginsection(pkgctx, 'pr_updatepassonline');

    -- Check host & branch active or inactive
    p_err_code := fn_CheckActiveSystem;
    IF p_err_code <> systemnums.C_SUCCESS THEN
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_updatepassonline');
        return;
    END IF;
    v_mobile:='';
     For vc in (select mobile
                         from cfmast where username=p_username )
     Loop
                         v_mobile:=vc.mobile;
     End loop;

    IF P_pwtype = 'LOGINPWD' THEN
        IF fn_checkPass(P_password) <> 0 THEN
            p_err_code := -901211;
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_updatepassonline');
            return;
        END IF;
    ELSIF P_PWTYPE= 'TRADINGPWD' THEN
        IF fn_checkPass(P_password) <> 0 THEN
            p_err_code := -901212;
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_updatepassonline');
            return;
        END IF;
    END IF;

    IF P_pwtype = 'LOGINPWD' THEN
        --check pass cu moi giong nhau
        SELECT count(*) INTO l_countpass FROM userlogin u WHERE username = p_username AND u.loginpwd = genencryptpassword(P_password);
        IF l_countpass > 0 THEN
            p_err_code := -901213;
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_updatepasspinonline');
            return;
        END IF;
    ELSIF P_PWTYPE= 'TRADINGPWD' THEN
        --check pain cu moi giong nhau
        SELECT count(*) INTO l_countpin FROM userlogin u WHERE username = p_username AND u.tradingpwd = genencryptpassword(P_password);
        IF l_countpin > 0 THEN
            p_err_code := -901214;
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_updatepasspinonline');
            return;
        END IF;
    END IF;

    IF P_pwtype = 'LOGINPWD' THEN
        Update userlogin
        Set LOGINPWD= genencryptpassword(P_password),
        isreset='N',
        lastchanged = sysdate
        where username = p_username;
        If length(v_mobile)>1 then
                --l_datasourcesms:='select ''MSBS thong bao: Mat khau dang nhap cua so tai khoan '||p_username||' la: '||P_password||''' detail from dual';
                l_datasourcesms:='select ''Quy khach hang da doi thanh cong mat khau dang nhap vao luc '||TO_CHAR(SYSDATE,'HH24:MI')||' ngay '||to_char(sysdate,'dd/mm/yyyy')||''' detail from dual';
                nmpks_ems.InsertEmailLog(v_mobile, '0335', l_datasourcesms, '');
        End if;
    ELSIF P_PWTYPE= 'TRADINGPWD' THEN
        Update userlogin
        Set TRADINGPWD= genencryptpassword(P_password),
        isreset='N',
        lastchanged = sysdate
        where username = p_username;
        If length(v_mobile)>1 then
                --l_datasourcesms:='select ''MSBS thong bao: PIN cua so tai khoan '||p_username||' la: '||P_password||''' detail from dual';
                l_datasourcesms:='select ''Quy khach hang da doi thanh cong mat khau xac thuc/PIN vao luc '||TO_CHAR(SYSDATE,'HH24:MI')||' ngay '||to_char(sysdate,'dd/mm/yyyy')||''' detail from dual';
                nmpks_ems.InsertEmailLog(v_mobile, '0335', l_datasourcesms, '');
        End if;
    END IF;

    --cap nhat lai ngay het han khi co thay doi pass, pin online
    UPDATE userlogin SET expdate = getcurrdate + (SELECT to_number(varvalue) FROM sysvar WHERE varname = 'EXPDATEPASSONLINE') WHERE username = p_username;
    COMMIT;

    --End cap nhat lai ngay het han khi co thay doi pass, pin online
    p_err_code:='0';
    plog.setendsection(pkgctx, 'pr_updatepassonline');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_updatepassonline');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_updatepassonline');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_updatepassonline;

  function fn_getCustodycd return varchar2 as
   v_custodycd varchar2(10);
  begin
    -- TO DO
    SELECT   '091C'||lpad( TO_CHAR(MAX (odr) + 1),6,'0') INTO  v_custodycd
    FROM   (SELECT   ROWNUM odr, invacct
              FROM   (  SELECT   custodycd invacct
                          FROM   (SELECT CUSTODYCD FROM cfmast
                                  UNION
                                  SELECT CUSTODYCD
                                    FROM registeronline
                                    WHERE  AUTOID not in (select OLAUTOID from CFMAST CF
                                                           where CF.OPENVIA='O'
                                                              AND CF.CUSTODYCD IS NOT NULL
                                                         )
                                  )
                         WHERE   SUBSTR (custodycd, 1, 4) = '091C'
                                 AND TRIM(TO_CHAR(TRANSLATE (
                                                      SUBSTR (custodycd, 5, 6),
                                                      '0123456789',
                                                      ' '))) IS NULL
                      ORDER BY   custodycd) dat
             WHERE   TO_NUMBER (SUBSTR (invacct, 5, 6)) = ROWNUM) invtab
    GROUP BY   SUBSTR (invacct, 1, 4);
    return v_custodycd;
  exception
    when others then
      return errnums.C_SYSTEM_ERROR;
  end;
  PROCEDURE pr_GetOnlineregister
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     p_CUSTODYCD    IN VARCHAR2,
     p_idcode       in varchar2
      ) IS

    BEGIN
        OPEN p_REFCURSOR FOR
        SELECT AUTOID,CUSTOMERTYPE,CUSTOMERNAME,SEX,CUSTOMERBIRTH,
                IDTYPE,IDCODE,IDDATE,IDPLACE,
                ADDRESS,ContactAddress,TAXCODE,
                PRIVATEPHONE,MOBILE,WorkMobile,FAX,
                EMAIL,
                COUNTRY,CUSTOMERCITY,
                OTHERACCOUNT1,OTHERCOMPANY1,
                Certificate,CertificateDate,CertificatePlace,
                Business,AgentName,AgentPosition,AgentCountry,AgentSex,
                AgentId,AgentPhone,AgentEmail,
                FixedIncome,LongGrowth,MidGrowth,ShortGrowth,
                LowRisk,MidRisk,HighRisk,
                ManageCompanyName,ShareholderCompanyName,
                InvestKnowlegde,InvestExperience,
                IsTrustAcctno,TrustFullname,
                Relationship,DealStockType,
                DealMethod,DealResult,DealStatement,DealTax,
                BeneficiaryName,BeneficiaryBirthday,BeneficiaryPhone,BeneficiaryId,BeneficiaryIdDate,BeneficiaryIdPlace,
                AuthorizedName,AuthorizedPhone,AuthorizedId,AuthorizedIdDate,AuthorizedIdPlace,
                Custodycd,ISAPPROVE,TrustPhone,AuthorizedBirthday,AgentIDDate,AgentIDPlace,brid
         From registeronline
         where ((p_custodycd is not null and length(p_CUSTODYCD) >0 and custodycd = upper(p_CUSTODYCD))
              or (p_idcode  is not null and length(p_idcode) >0 and idcode = p_idcode))
              AND  AUTOID not in (select OLAUTOID from CFMAST CF
                                                           where CF.OPENVIA='O'
                                                              AND CF.CUSTODYCD IS NOT NULL
                                                         );
    EXCEPTION
      WHEN OTHERS THEN
        plog.error(pkgctx, sqlerrm);
        plog.setendsection(pkgctx, 'pr_GetAFTemplates');
    END pr_GetOnlineregister;
    Procedure pr_EmailAlert(p_custid in varchar2,
                          p_alerttype in varchar2,
                          p_symbols in varchar2,
                          p_message in varchar2,
                          p_alertdt in varchar2,
                          p_err_code out varchar2,
                          p_err_message out VARCHAR2
                        ) is
           l_sex varchar2(20);
           l_datasource varchar2(2000);
   Begin

        For vc in(Select cf.sex,cf.fullname,cf.email , a.cdcontent
                  from cfmast cf, allcode a
                  where cf.custid=p_custid
                      and a.CDNAME='SEXEMAIL' AND a.CDTYPE='CF' and a.cdval=cf.sex)
        Loop
            l_datasource:='select '''||vc.fullname||''' fullname,'''||vc.cdcontent||''' sex, '''||p_alerttype||''' alerttype,'''
                                     ||p_symbols||''' symbols,'''||p_message||''' message,'''||p_alertdt||''' alertdt  from dual ';
            if length(vc.EMAIL)>0 then
                nmpks_ems.InsertEmailLog(vc.EMAIL, '4001', l_datasource, '');
            end if;
        End loop;
         p_err_code:='0';
    plog.setendsection(pkgctx, 'pr_EmailAlert');
   EXCEPTION
      WHEN OTHERS THEN
        plog.error(pkgctx, sqlerrm);
        plog.setendsection(pkgctx, 'pr_EmailAlert');
   End;
   PROCEDURE pr_GetMR1810(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                          p_TLID    IN VARCHAR2
     )
       IS
    l_isstopadv           varchar2(10);
    BEGIN
      l_isstopadv := cspks_system.fn_get_sysvar('MARGIN','ISSTOPADV');
      OPEN p_REFCURSOR FOR
        SELECT A.*, nvl(T0af.AFT0USED,0) AFT0USED,NVL(T0.CUSTT0USED,0) CUSTT0USED
      ,least (A.T0CAL - A.ADVANCELINE ,A.T0LOANLIMIT - nvl(t0.CUSTT0USED,0)) T0REAL
    ,    A.T0LOANLIMIT - NVL(T0.CUSTT0USED,0)  CUSTT0REMAIN
    ,nvl(urlt.t0,0) - nvl(uflt.t0acclimit,0) urt0limitremain
    , a.t0cal - a.advanceline T0Remain    , 0 T0OVRQ
    , NVL(urlt.T0,0) - NVL(UFLT.t0acclimit,0) RLIMIT
            FROM
            (    SELECT CF.CUSTID, CF.CUSTODYCD, AF.ACCTNO,CF.FULLNAME,cf.t0loanrate, AF.ADVANCELINE, CF.MRLOANLIMIT, CF.T0LOANLIMIT,af.CAREBY, af.actype, CF.CONTRACTCHK
                ,  nvl((ci.balance - NVL(v_getbuy.secureamt,0)) + NVL(ADV.avladvance,0) + v_getsec.senavamt - (NVL(ln.marginamt,0) + NVL(ln.t0amt,0)),0)
                    navamt, nvl(v_getsec.SELIQAMT,0) SELIQAMT,
                    ROUND(least (nvl((ci.balance - NVL(v_getbuy.secureamt,0)) + NVL(ADV.avladvance,0) + v_getsec.senavamt - (NVL(ln.marginamt,0) + NVL(ln.t0amt,0)),0) * cf.t0loanrate /100, nvl(v_getsec.SELIQAMT,0) )) T0CAL
                    ,  GREATEST(0, NVL(NVL(ln.t0amt,0) - NVL(ci.balance +  NVL(v_getbuy.secureamt,0) + NVL(ADV.avladvance,0),0),0)) T0DEB
                    , buf.MARGINRATE
                FROM CFMAST CF, CIMAST CI, AFMAST AF,
                    (
                        select sum(aamt) aamt,sum(decode(l_isstopadv, 'Y',0,depoamt)) avladvance,sum(paidamt) paidamt, sum(advamt) advanceamount,afacctno
                        from v_getAccountAvlAdvance group by afacctno
                    ) adv
                    ,
                    (
                        select trfacctno, trunc(sum(prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd),0) marginamt,
                                 trunc(sum(oprinnml+oprinovd+ointnmlacr+ointdue+ointovdacr+ointnmlovd),0) t0amt,
                                 trunc(sum(prinovd+intovdacr+intnmlovd+feeintovdacr+feeintnmlovd + nvl(ls.dueamt,0) + intdue + feeintdue),0) marginovdamt,
                                 trunc(sum(oprinovd+ointovdacr+ointnmlovd),0) t0ovdamt
                        from lnmast ln, lntype lnt,
                                (select acctno, sum(nml) dueamt
                                        from lnschd, (select * from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM') sy
                                        where reftype = 'P' and overduedate = to_date(varvalue,'DD/MM/RRRR')
                                        group by acctno) ls
                        where ftype = 'AF'
                                and ln.actype = lnt.actype
                                and ln.acctno = ls.acctno(+)
                        group by ln.trfacctno
                    )  ln
                    ,    v_getbuyorderinfo v_getbuy ,
                    v_getsecmargininfo_ALL v_getsec
                    ,    buf_ci_account buf
                WHERE AF.ACCTNO = CI.ACCTNO
                    AND AF.CUSTID = CF.CUSTID (+)
                    AND AF.ACCTNO = ADV.AFACCTNO (+)
                    and af.acctno = v_getbuy.afacctno (+)
                    and af.acctno = v_getsec.afacctno (+)
                   and af.acctno = ln.trfacctno (+)
                   and af.acctno = buf.afacctno(+)
                   and cf.contractchk = 'Y'
                    --and tlp.tlid = '<$TELLERID>'
                --    and tlp.tlid = urlt.tliduser(+) -- and tlp.tlid = '<$TELLERID>'
            ) A
            ,(SELECT CUSTID, SUM(ADVANCELINE) TOTALADVLINE FROM AFMAST GROUP BY CUSTID) v_t0
            , (select sum(acclimit) CUSTT0USED, af.CUSTID from useraflimit us, afmast af where af.acctno = us.acctno and us.typereceive = 'T0' group by custid) T0
            , (select sum(acclimit) AFT0USED, acctno from useraflimit us where us.typereceive = 'T0' group by acctno) T0af
            , (select tliduser,allocatelimmit,usedlimmit,acctlimit,t0,t0max from userlimit where TLIDUSER = p_TLID) urlt
            ,(select tliduser,sum(decode(typereceive,'T0',acclimit, 0)) t0acclimit,sum(decode(typereceive,'MR',acclimit, 0)) mracclimit  from useraflimit where typeallocate = 'Flex' and TLIDUSER = p_TLID group by tliduser
            ) uflt
            , tlprofiles tlp
            , TLGROUPS GRP
            WHERE A.CUSTID = v_t0.custid (+)
            AND A.custid = t0.custid (+)
            and a.acctno = T0af.acctno(+)
            and a.t0loanrate >=0
            and tlp.tlid = uflt.tliduser(+) and tlp.tlid = urlt.tliduser(+) and tlp.tlid = p_TLID
            AND a.CAREBY = GRP.GRPID AND GRP.GRPTYPE = '2'
            AND a.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = p_TLID);
    EXCEPTION
      WHEN OTHERS THEN
        plog.error(pkgctx, sqlerrm);
        plog.setendsection(pkgctx, 'pr_GetMR1810');
    END pr_GetMR1810;

PROCEDURE pr_GetNetAssetDetail
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     p_AFACCTNO    IN VARCHAR2
     )
    IS
  v_balance varchar2(100);
  v_securebal varchar2(100);
  v_debt varchar2 (100);
  v_mrtype VARCHAR2(10);
  v_chksysctrl VARCHAR2(1);
BEGIN
   Begin
        Select cdcontent into v_balance
        From allcode
        where cdtype='AF' AND CDNAME='ASSETDETAIL' and cdval='001';
        Select cdcontent into v_securebal
        From allcode
        where cdtype='AF' AND CDNAME='ASSETDETAIL' and cdval='002';
        Select cdcontent into v_debt
        From allcode
        where cdtype='AF' AND CDNAME='ASSETDETAIL' and cdval='003';

        select mrt.mrtype, nvl(lnt.chksysctrl,'N')
        into v_mrtype, v_chksysctrl
        from afmast af, aftype aft, lntype lnt, mrtype mrt
        where af.actype  = aft.actype
              and aft.lntype = lnt.actype(+)
              and aft.mrtype = mrt.actype
              and af.acctno = p_AFACCTNO;
   EXCEPTION
      WHEN OTHERS THEN
        v_balance:='Tien';
        v_securebal:='Tien ky quy';
        v_debt:='No';
   End;

   IF v_mrtype = 'N' THEN
   OPEN p_REFCURSOR FOR
   SELECT  ITEM, ITEM SYMBOL, MST.ACCTNO AFACCTNO, CUSTODYCD, trunc(trade) trade, 0 topup, 0 margin, trunc(receiving) receiving ,
        trunc(secured) secured, trunc(basicprice) basicprice,trunc(COSTPRICE) costprice,  retail,
        trunc (PROFITANDLOSS) PL,  PCPL, trunc(COSTPRICEAMT) COSTPRICEAMT,
        trunc(MARKETAMT) marketamt,
        receiving_right,receiving_t0,receiving_t1,receiving_t2,receiving_t3,
        trunc(trade) +  trunc(secured) + receiving_right + receiving_t0 + receiving_t1 + receiving_t2 + receiving_t3 SUM_QTTY,
        stt,
        case when stt = 3 then 'Y' else 'N' end ISBUY,
        case when stt = 3 then 'Y' else 'N' end ISSELL
          FROM (
              Select v_balance Item,buf.afacctno acctno, CUSTODYCD,
                      buf.balance + buf.bamt trade,
                     (nvl(buf.RECEIVING,0) - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 -
                        buf.CASH_RECEIVING_T2) + nvl(buf.avladv_t1,0) +nvl(buf.avladv_t2,0)+nvl(buf.avladv_t3,0) RECEIVING,
                     0 secured,
                     0 basicprice,
                     0 costprice,
                     nvl(r.retail,0) retail,
                     0 PROFITANDLOSS,
                     0 PCPL,
                     0 COSTPRICEAMT,
                     buf.balance +  buf.bamt + nvl(careceiving,0)--(nvl(buf.RECEIVING,0)  - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 - buf.CASH_RECEIVING_T2 )         --T2_HoangND
                     + nvl(buf.avladv_t1,0) +nvl(buf.avladv_t2,0)+nvl(buf.avladv_t3,0) MARKETAMT,
                     --nvl(buf.RECEIVING,0) - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 -  buf.CASH_RECEIVING_T2 - nvl(r.retail,0)   receiving_right,
                     nvl(buf.careceiving,0) receiving_right,       --T2_HoangND edit
                     0 receiving_t0,
                     nvl(buf.avladv_t1,0) receiving_t1,
                     nvl(buf.avladv_t2,0) receiving_t2,
                     nvl(buf.avladv_t3,0) receiving_t3,
                     0 stt
              From buf_ci_account buf,
              (select sum(price*qtty) retail, substr(acctno,1,10) seacctno from seretail where status not in ('C','R') group by substr(acctno,1,10)) r--,
              --(SELECT SUM(amt) careceiving, afacctno  FROM caschd WHERE  status IN ('I','S','H') AND ISEXEC ='Y' AND deltd <> 'Y'   --T2_HoangND
                --GROUP BY afacctno) ca
              where  buf.AFACCTNO = p_AFACCTNO
              AND BUF.AFACCTNO = r.seacctno(+)
              --AND BUF.AFACCTNO = ca.afacctno(+)
              union all
               Select v_securebal Item,buf.afacctno acctno, CUSTODYCD,
                     buf.bamt trade,
                     0 RECEIVING,
                     0 secured,
                     0 basicprice,
                     0 costprice,
                     0 retail,
                     0 PROFITANDLOSS,
                     0 PCPL,
                     0 COSTPRICEAMT,
                     -buf.bamt  MARKETAMT,
                     0 receiving_right,
                     0 receiving_t0,
                     0 receiving_t1,
                     0 receiving_t2,
                     0 receiving_t3,
                     1 stt
              From buf_ci_account buf
              where   buf.AFACCTNO = p_AFACCTNO
              union all
               SELECT v_debt Item, AF.ACCTNO, buf.CUSTODYCD,
                     (nvl(LS.DEBT,0)  + buf.OVDCIDEPOFEE) trade,
                     0 receiving,
                     0 secured,
                     0 basicprice,
                     0 costprice,
                     0 retail,
                     0 PROFITANDLOSS,
                     0 PCPL,
                     0 COSTPRICEAMT,
                     -(nvl(LS.DEBT,0)  + buf.OVDCIDEPOFEE) MARKETAMT,
                     0 receiving_right,
                     0 receiving_t0,
                     0 receiving_t1,
                     0 receiving_t2,
                     0 receiving_t3,
                     2 stt
                FROM  AFMAST AF, (SELECT LN.TRFACCTNO,SUM(prinnml + prinovd + intnmlacr+intovdacr+intnmlovd+intdue +
                        oprinnml + oprinovd + ointnmlacr + ointnmlovd + ointovdacr+
                        ointdue+fee+feedue+feeovd+feeintnmlacr+feeintovdacr+feeintnmlovd+feeintdue) DEBT
                        FROM  LNMAST LN
                        GROUP BY LN.TRFACCTNO) LS,
                        buf_ci_account buf
              WHERE  AF.ACCTNO = ls.TRFACCTNO(+)
                and af.acctno=buf.afacctno
               AND AF.ACCTNO =p_AFACCTNO
              union
              select item, acctno, custodycd, trade, receiving, secured, basicprice,
                    costprice,
                    retail,
                    (basicprice - costprice) * (   trunc(trade) +  trunc(secured) + receiving_right + receiving_t0 + receiving_t1 + receiving_t2 + receiving_t3) PROFITANDLOSS,     --T2_HoangND edit
                    DECODE(round(COSTPRICE),0,0, ROUND((BASICPRICE- round(COSTPRICE))*100/(round(COSTPRICE)+0.00001),2)) PCPL,
                    costprice * ( trunc(trade) +  trunc(secured) + receiving_right + receiving_t0 + receiving_t1 + receiving_t2 + receiving_t3) COSTPRICEAMT,
                    basicprice * (trade + receiving + secured /*+ ca_sec*/)  MARKETAMT, RECEIVING_RIGHT, receiving_t0, receiving_t1, receiving_t2, receiving_t3, stt

            from
            (
               SELECT TO_CHAR(SB.SYMBOL) ITEM, SDTL.AFACCTNO ACCTNO, sdtl.CUSTODYCD,
                    SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED TRADE,
                    nvl(sdtl_wft.wft_receiving,0) CA_sec,
                    SDTL.receiving + nvl(od.B_execqtty_new,0)/*SDTL.SECURITIES_RECEIVING_T3*/  receiving,       --T2_HoangND
                    nvl(od.REMAINQTTY,0) secured,
                   CASE WHEN nvl( stif.closeprice,0)>0 THEN stif.closeprice ELSE  SEC.BASICPRICE END  BASICPRICE,
                    round((
                        round(nvl(sdtl1.costprice,sdtl.costprice)) -- gia_von_ban_dau ,
                        *(SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED + SDTL.RECEIVING  + nvl(sdtl_wft.wft_receiving,0) + sdtl.secured ) --tong_kl
                        + nvl(od.B_execamt,0) --gia_tri_mua --gia tri khop mua
                        )           /      (SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED + nvl(sdtl_wft.wft_receiving,0) + sdtl.secured
                        + SDTL.RECEIVING + nvl(od.B_EXECQTTY,0) + 0.000001 )
                        ) as COSTPRICE,
                    fn_getckll_af(sdtl.afacctno, sb.codeid) retail,
                    nvl(od.B_execqtty_new,0) + SDTL.RECEIVING - SDTL.SECURITIES_RECEIVING_T0 - SDTL.SECURITIES_RECEIVING_T1 -SDTL.SECURITIES_RECEIVING_T2 /*+ nvl(sdtl_wft.wft_receiving,0)*/ RECEIVING_RIGHT,      --T2_HoangND
                    SDTL.SECURITIES_RECEIVING_T0 receiving_t0,
                    SDTL.SECURITIES_RECEIVING_T1 receiving_t1,
                    SDTL.SECURITIES_RECEIVING_T2 receiving_t2,
                    SDTL.SECURITIES_RECEIVING_T3 receiving_t3,
                    3 stt

                FROM  SBSECURITIES SB, SECURITIES_INFO SEC, BUF_SE_ACCOUNT SDTL
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
                        from odmast o
                        where deltd <>'Y' and o.exectype in('NS','NB','MS')
                        and o.txdate =(select to_date(VARVALUE,'DD/MM/YYYY') from sysvar where grname='SYSTEM' and varname='CURRDATE')
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
                (SELECT TO_NUMBER( closeprice) closeprice,symbol from stockinfor WHERE tradingdate = to_char(getcurrdate ,'dd/mm/yyyy')) stif
                ON SDTL.symbol = stif.symbol
                left join
                (select seacctno, sum(o.remainqtty) remainqtty, sum(decode(o.exectype , 'NB',  o.execamt ,0 )) B_execamt
                    , sum(decode(o.exectype , 'NB',  o.execqtty ,0 )) B_execqtty, SUM(CASE WHEN o.stsstatus <> 'C' THEN (decode(o.exectype , 'NB',  o.execqtty ,0 )) ELSE 0 END)  B_execqtty_new
                from odmast o
                where deltd <>'Y' and o.exectype in('NS','NB','MS')
                and o.txdate =(select to_date(VARVALUE,'DD/MM/YYYY') from sysvar where grname='SYSTEM' and varname='CURRDATE')
                group by seacctno
                ) OD on sdtl.acctno = od.seacctno
                left join
                (select afacctno, refcodeid, trade + receiving - SECURITIES_RECEIVING_T1 - SECURITIES_RECEIVING_T2 wft_receiving
                from buf_se_account sdtl, sbsecurities sb
                where sdtl.codeid = sb.codeid and sb.refcodeid is not null
                ) sdtl_wft on sdtl.codeid = sdtl_wft.refcodeid and sdtl.afacctno = sdtl_wft.afacctno
                WHERE SDTL.AFACCTNO =p_AFACCTNO AND
                SB.CODEID = SDTL.CODEID --and sb.refcodeid is null
                AND SDTL.CODEID = SEC.CODEID
                and SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED + SDTL.receiving+SDTL.SECURITIES_RECEIVING_T0+SDTL.SECURITIES_RECEIVING_T1+SDTL.SECURITIES_RECEIVING_T2+SDTL.SECURITIES_RECEIVING_T3 + nvl(od.REMAINQTTY,0) >0
            )
              ) MST order by stt;
     ELSE
     IF v_chksysctrl <> 'Y' THEN
     OPEN p_REFCURSOR FOR
     SELECT ITEM, ITEM SYMBOL, MST.ACCTNO AFACCTNO, CUSTODYCD, trunc(trade) trade, topup, margin,trunc(receiving) receiving ,
        trunc(secured) secured, trunc(basicprice) basicprice,trunc(COSTPRICE) costprice,  retail,
        trunc (PROFITANDLOSS) PL,  PCPL, trunc(COSTPRICEAMT) COSTPRICEAMT,
        trunc(MARKETAMT) marketamt,
        receiving_right,receiving_t0,receiving_t1,receiving_t2,receiving_t3,
        trunc(trade) +  trunc(secured) + receiving_right + receiving_t0 + receiving_t1 + receiving_t2 + receiving_t3 SUM_QTTY,
        stt,
        case when stt = 3 then 'Y' else 'N' end ISBUY,
        case when stt = 3 then 'Y' else 'N' end ISSELL
          FROM (
              Select 'Tien' Item,buf.afacctno acctno, CUSTODYCD,
                     buf.balance + buf.bamt trade,0 topup, 0 margin,
                     (nvl(buf.RECEIVING,0) - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 -
                        buf.CASH_RECEIVING_T2) + + nvl(buf.avladv_t1,0) +nvl(buf.avladv_t2,0)+nvl(buf.avladv_t3,0) RECEIVING,
                     0 secured,
                     0 basicprice,
                     0 costprice,
                     nvl(r.retail,0) retail,
                     0 PROFITANDLOSS,
                     0 PCPL,
                     0 COSTPRICEAMT,
                     buf.balance +  buf.bamt + nvl(careceiving,0)--(nvl(buf.RECEIVING,0)  - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 - buf.CASH_RECEIVING_T2 )         --T2_HoangND
                     + nvl(buf.avladv_t1,0) +nvl(buf.avladv_t2,0)+nvl(buf.avladv_t3,0) MARKETAMT,
                     --nvl(buf.RECEIVING,0) - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 -  buf.CASH_RECEIVING_T2 - nvl(r.retail,0)   receiving_right,
                     nvl(buf.careceiving,0) receiving_right,       --T2_HoangND edit
                     0 receiving_t0,
                     nvl(buf.avladv_t1,0) receiving_t1,
                     nvl(buf.avladv_t2,0) receiving_t2,
                     nvl(buf.avladv_t3,0) receiving_t3,
                     0 stt
              From buf_ci_account buf,
              (select sum(price*qtty) retail, substr(acctno,1,10) seacctno from seretail where status not in ('C','R') group by substr(acctno,1,10)) r--,
              --(SELECT SUM(amt) careceiving, afacctno  FROM caschd WHERE  status IN ('I','S','H') AND ISEXEC ='Y' AND deltd <> 'Y'   --T2_HoangND
              --GROUP BY afacctno) ca
              where  buf.AFACCTNO = p_AFACCTNO
              AND BUF.AFACCTNO = r.seacctno(+)
              --AND BUF.AFACCTNO = ca.afacctno(+)
              union all
               Select 'Tien ky quy' Item,buf.afacctno acctno, CUSTODYCD,
                      buf.bamt trade, 0 topup, 0 margin,
                     0 RECEIVING,
                     0 secured,
                     0 basicprice,
                     0 costprice,
                     0 retail,
                     0 PROFITANDLOSS,
                     0 PCPL,
                     0 COSTPRICEAMT,
                     -buf.bamt  MARKETAMT,
                     0 receiving_right,
                     0 receiving_t0,
                     0 receiving_t1,
                     0 receiving_t2,
                     0 receiving_t3,
                     1 stt
              From buf_ci_account buf
              where   buf.AFACCTNO = p_AFACCTNO
              union all
               SELECT 'No' Item, AF.ACCTNO, buf.CUSTODYCD,
                     (nvl(LS.DEBT,0)  + buf.OVDCIDEPOFEE) trade, 0 topup, 0 margin,
                     0 receiving,
                     0 secured,
                     0 basicprice,
                     0 costprice,
                     0 retail,
                     0 PROFITANDLOSS,
                     0 PCPL,
                     0 COSTPRICEAMT,
                     -(nvl(LS.DEBT,0)  + buf.OVDCIDEPOFEE) MARKETAMT,
                     0 receiving_right,
                     0 receiving_t0,
                     0 receiving_t1,
                     0 receiving_t2,
                     0 receiving_t3,
                     2 stt
                FROM  AFMAST AF, (SELECT LN.TRFACCTNO,SUM(prinnml + prinovd + intnmlacr+intovdacr+intnmlovd+intdue +
                        oprinnml + oprinovd + ointnmlacr + ointnmlovd + ointovdacr+
                        ointdue+fee+feedue+feeovd+feeintnmlacr+feeintovdacr+feeintnmlovd+feeintdue) DEBT
                        FROM  LNMAST LN
                        GROUP BY LN.TRFACCTNO) LS,
                        buf_ci_account buf
              WHERE  AF.ACCTNO = ls.TRFACCTNO(+)
                and af.acctno=buf.afacctno
               AND AF.ACCTNO =p_AFACCTNO
            union
            select a.item, a.acctno, a.custodycd, a.trade,nvl(rsk.mrratioloan,0) TOPUP,  nvl(afmr.MRRATIOLOAN,0) MARGIN, a.receiving, a.secured, a.basicprice,
          a.costprice,
          a.retail,
          (a.basicprice - a.costprice) * (trunc(a.trade) +  trunc(a.secured) + a.receiving_right + receiving_t0 + a.receiving_t1 + a.receiving_t2 + a.receiving_t3) PROFITANDLOSS,      --T2_HoangND edit
          DECODE(round(a.COSTPRICE),0,0, ROUND((a.BASICPRICE- round(a.COSTPRICE))*100/(round(a.COSTPRICE)+0.00001),2)) PCPL,
          a.costprice * (trunc(a.trade) +  trunc(a.secured) + a.receiving_right + receiving_t0 + a.receiving_t1 + a.receiving_t2 + a.receiving_t3) COSTPRICEAMT,
          a.basicprice * (a.trade + a.receiving + a.secured /*+ a.ca_sec*/)  MARKETAMT, a.RECEIVING_RIGHT, receiving_t0, a.receiving_t1, a.receiving_t2, a.receiving_t3, a.stt
      from
      (
        SELECT sb.codeid, TO_CHAR(SB.SYMBOL) ITEM, af.actype, SDTL.AFACCTNO ACCTNO, sdtl.CUSTODYCD,
          SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED TRADE,
          nvl(sdtl_wft.wft_receiving,0) CA_sec,
          SDTL.receiving + nvl(od.B_execqtty_new,0)/*SDTL.SECURITIES_RECEIVING_T3*/  receiving,       --T2_HoangND
          nvl(od.REMAINQTTY,0) secured,
          CASE WHEN nvl( stif.closeprice,0)>0 THEN stif.closeprice ELSE  SEC.BASICPRICE END BASICPRICE,
          round((
            round(nvl(sdtl1.costprice,sdtl.costprice)) -- gia_von_ban_dau ,
            *(SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED + SDTL.RECEIVING  + nvl(sdtl_wft.wft_receiving,0) - nvl(wft_3380,0) + sdtl.secured ) --tong_kl
            + nvl(od.B_execamt,0) --gia_tri_mua --gia tri khop mua
            )            /   (SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED + nvl(sdtl_wft.wft_receiving,0) - nvl(wft_3380,0) + sdtl.secured
            + SDTL.RECEIVING + nvl(od.B_EXECQTTY,0) + 0.000001 )
            ) as COSTPRICE,
          fn_getckll_af(sdtl.afacctno, sb.codeid) retail,
          nvl(od.B_execqtty_new,0) + SDTL.RECEIVING - SDTL.SECURITIES_RECEIVING_T0 - SDTL.SECURITIES_RECEIVING_T1 -SDTL.SECURITIES_RECEIVING_T2 /*+ nvl(sdtl_wft.wft_receiving,0)*/ RECEIVING_RIGHT,        --T2_HoangND
          SDTL.SECURITIES_RECEIVING_T0 receiving_t0,
          SDTL.SECURITIES_RECEIVING_T1 receiving_t1,
          SDTL.SECURITIES_RECEIVING_T2 receiving_t2,
          SDTL.SECURITIES_RECEIVING_T3 receiving_t3,
          3 stt

        FROM  SBSECURITIES SB, SECURITIES_INFO SEC, BUF_SE_ACCOUNT SDTL
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
                from odmast o
                where deltd <>'Y' and o.exectype in('NS','NB','MS')
                and o.txdate =(select to_date(VARVALUE,'DD/MM/YYYY') from sysvar where grname='SYSTEM' and varname='CURRDATE')
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
                (SELECT TO_NUMBER( closeprice) closeprice,symbol from stockinfor WHERE tradingdate = to_char(getcurrdate ,'dd/mm/yyyy')) stif
                ON SDTL.symbol = stif.symbol
        left join
        (select seacctno, sum(o.remainqtty) remainqtty, sum(decode(o.exectype , 'NB',  o.execamt ,0 )) B_execamt
          , sum(decode(o.exectype , 'NB',  o.execqtty ,0 )) B_execqtty, SUM(CASE WHEN o.stsstatus <> 'C' THEN (decode(o.exectype , 'NB',  o.execqtty ,0 )) ELSE 0 END)  B_execqtty_new
        from odmast o
        where deltd <>'Y' and o.exectype in('NS','NB','MS')
        and o.txdate =(select to_date(VARVALUE,'DD/MM/YYYY') from sysvar where grname='SYSTEM' and varname='CURRDATE')
        group by seacctno
        ) OD on sdtl.acctno = od.seacctno
        left join
        (select afacctno, refcodeid, trade + receiving  wft_receiving , nvl(se.namt,0) wft_3380
        from  semast sdtl, sbsecurities sb, (select acctno , namt from setran where tltxcd = '3380' and txcd = '0052' and deltd <> 'Y') se
        where sdtl.codeid = sb.codeid and sb.refcodeid is not null and sdtl.acctno = se.acctno(+)
        ) sdtl_wft on sdtl.codeid = sdtl_wft.refcodeid and sdtl.afacctno = sdtl_wft.afacctno
    LEFT JOIN afmast af ON af.acctno = SDTL.AFACCTNO
        WHERE SDTL.AFACCTNO =p_AFACCTNO AND
        SB.CODEID = SDTL.CODEID --and sb.refcodeid is null
        AND SDTL.CODEID = SEC.CODEID
        and SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED + SDTL.receiving+SDTL.SECURITIES_RECEIVING_T0+SDTL.SECURITIES_RECEIVING_T1+SDTL.SECURITIES_RECEIVING_T2+SDTL.SECURITIES_RECEIVING_T3 + nvl(od.REMAINQTTY,0) >0
      ) a, afserisk rsk, afmrserisk afmr
      where a.actype = rsk.actype(+)
             AND a.acctno = p_AFACCTNO
            and a.codeid = rsk.codeid(+)
            AND a.codeid = afmr.codeid(+)
            AND a.actype = afmr.actype(+)
        ) MST order by stt;
      ELSE
        OPEN p_REFCURSOR FOR
     SELECT ITEM, ITEM SYMBOL, MST.ACCTNO AFACCTNO, CUSTODYCD, trunc(trade) trade, topup, margin,trunc(receiving) receiving ,
        trunc(secured) secured, trunc(basicprice) basicprice,trunc(COSTPRICE) costprice,  retail,
        trunc (PROFITANDLOSS) PL,  PCPL, trunc(COSTPRICEAMT) COSTPRICEAMT,
        trunc(MARKETAMT) marketamt,
        receiving_right,receiving_t0,receiving_t1,receiving_t2,receiving_t3,
        trunc(trade) +  trunc(secured) + receiving_right + receiving_t0 + receiving_t1 + receiving_t2 + receiving_t3 SUM_QTTY,
        stt,
        case when stt = 3 then 'Y' else 'N' end ISBUY,
        case when stt = 3 then 'Y' else 'N' end ISSELL
          FROM (
              Select 'Tien' Item,buf.afacctno acctno, CUSTODYCD,
                     buf.balance + buf.bamt trade,0 topup, 0 margin,
                     (nvl(buf.RECEIVING,0) - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 -
                        buf.CASH_RECEIVING_T2) + + nvl(buf.avladv_t1,0) +nvl(buf.avladv_t2,0)+nvl(buf.avladv_t3,0) RECEIVING,
                     0 secured,
                     0 basicprice,
                     0 costprice,
                     nvl(r.retail,0) retail,
                     0 PROFITANDLOSS,
                     0 PCPL,
                     0 COSTPRICEAMT,
                     buf.balance +  buf.bamt + nvl(careceiving,0)--(nvl(buf.RECEIVING,0)  - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 - buf.CASH_RECEIVING_T2 )         --T2_HoangND
                     + nvl(buf.avladv_t1,0) +nvl(buf.avladv_t2,0)+nvl(buf.avladv_t3,0) MARKETAMT,
                     --nvl(buf.RECEIVING,0) - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 -  buf.CASH_RECEIVING_T2 - nvl(r.retail,0)   receiving_right,
                     nvl(buf.careceiving,0) receiving_right,       --T2_HoangND edit
                     0 receiving_t0,
                     nvl(buf.avladv_t1,0) receiving_t1,
                     nvl(buf.avladv_t2,0) receiving_t2,
                     nvl(buf.avladv_t3,0) receiving_t3,
                     0 stt
              From buf_ci_account buf,
              (select sum(price*qtty) retail, substr(acctno,1,10) seacctno from seretail where status not in ('C','R') group by substr(acctno,1,10)) r--,
              --(SELECT SUM(amt) careceiving, afacctno  FROM caschd WHERE  status IN ('I','S','H') AND ISEXEC ='Y' AND deltd <> 'Y'   --T2_HoangND
              --GROUP BY afacctno) ca
              where  buf.AFACCTNO = p_AFACCTNO
              AND BUF.AFACCTNO = r.seacctno(+)
              --AND BUF.AFACCTNO = ca.afacctno(+)
              union all
               Select 'Tien ky quy' Item,buf.afacctno acctno, CUSTODYCD,
                      buf.bamt trade, 0 topup, 0 margin,
                     0 RECEIVING,
                     0 secured,
                     0 basicprice,
                     0 costprice,
                     0 retail,
                     0 PROFITANDLOSS,
                     0 PCPL,
                     0 COSTPRICEAMT,
                     -buf.bamt  MARKETAMT,
                     0 receiving_right,
                     0 receiving_t0,
                     0 receiving_t1,
                     0 receiving_t2,
                     0 receiving_t3,
                     1 stt
              From buf_ci_account buf
              where   buf.AFACCTNO = p_AFACCTNO
              union all
               SELECT 'No' Item, AF.ACCTNO, buf.CUSTODYCD,
                     (nvl(LS.DEBT,0)  + buf.OVDCIDEPOFEE) trade, 0 topup, 0 margin,
                     0 receiving,
                     0 secured,
                     0 basicprice,
                     0 costprice,
                     0 retail,
                     0 PROFITANDLOSS,
                     0 PCPL,
                     0 COSTPRICEAMT,
                     -(nvl(LS.DEBT,0)  + buf.OVDCIDEPOFEE) MARKETAMT,
                     0 receiving_right,
                     0 receiving_t0,
                     0 receiving_t1,
                     0 receiving_t2,
                     0 receiving_t3,
                     2 stt
                FROM  AFMAST AF, (SELECT LN.TRFACCTNO,SUM(prinnml + prinovd + intnmlacr+intovdacr+intnmlovd+intdue +
                        oprinnml + oprinovd + ointnmlacr + ointnmlovd + ointovdacr+
                        ointdue+fee+feedue+feeovd+feeintnmlacr+feeintovdacr+feeintnmlovd+feeintdue) DEBT
                        FROM  LNMAST LN
                        GROUP BY LN.TRFACCTNO) LS,
                        buf_ci_account buf
              WHERE  AF.ACCTNO = ls.TRFACCTNO(+)
                and af.acctno=buf.afacctno
               AND AF.ACCTNO =p_AFACCTNO
            union
            select a.item, a.acctno, a.custodycd, a.trade,0 TOPUP,  nvl(afmr.MRRATIOLOAN,0) MARGIN, a.receiving, a.secured, a.basicprice,
          a.costprice,
          a.retail,
          (a.basicprice - a.costprice) * (trunc(a.trade) +  trunc(a.secured) + a.receiving_right + receiving_t0 + a.receiving_t1 + a.receiving_t2 + a.receiving_t3) PROFITANDLOSS,      --T2_HoangND edit
          DECODE(round(a.COSTPRICE),0,0, ROUND((a.BASICPRICE- round(a.COSTPRICE))*100/(round(a.COSTPRICE)+0.00001),2)) PCPL,
          a.costprice * (trunc(a.trade) +  trunc(a.secured) + a.receiving_right + receiving_t0 + a.receiving_t1 + a.receiving_t2 + a.receiving_t3) COSTPRICEAMT,
          a.basicprice * (a.trade + a.receiving + a.secured /*+ a.ca_sec*/)  MARKETAMT, a.RECEIVING_RIGHT, a.receiving_t0, a.receiving_t1, a.receiving_t2, a.receiving_t3, a.stt
      from
      (
        SELECT sb.codeid, TO_CHAR(SB.SYMBOL) ITEM, af.actype, SDTL.AFACCTNO ACCTNO, sdtl.CUSTODYCD,
          SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED TRADE,
          nvl(sdtl_wft.wft_receiving,0) CA_sec,
          SDTL.receiving + nvl(od.B_execqtty_new,0)/*SDTL.SECURITIES_RECEIVING_T3*/  receiving,       --T2_HoangND
          nvl(od.REMAINQTTY,0) secured,
          CASE WHEN nvl( stif.closeprice,0)>0 THEN stif.closeprice ELSE  SEC.BASICPRICE END BASICPRICE,
          round((
            round(nvl(sdtl1.costprice,sdtl.costprice)) -- gia_von_ban_dau ,
            *(SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED + SDTL.RECEIVING  + nvl(sdtl_wft.wft_receiving,0) - nvl(wft_3380,0) + sdtl.secured ) --tong_kl
            + nvl(od.B_execamt,0) --gia_tri_mua --gia tri khop mua
            )            /   (SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED + nvl(sdtl_wft.wft_receiving,0) - nvl(wft_3380,0) + sdtl.secured
            + SDTL.RECEIVING + nvl(od.B_EXECQTTY,0) + 0.000001 )
            ) as COSTPRICE,
          fn_getckll_af(sdtl.afacctno, sb.codeid) retail,
          nvl(od.B_execqtty_new,0) + SDTL.RECEIVING - SDTL.SECURITIES_RECEIVING_T0 - SDTL.SECURITIES_RECEIVING_T1 -SDTL.SECURITIES_RECEIVING_T2 /*+ nvl(sdtl_wft.wft_receiving,0)*/ RECEIVING_RIGHT,        --T2_HoangND
          SDTL.SECURITIES_RECEIVING_T0 receiving_t0,
          SDTL.SECURITIES_RECEIVING_T1 receiving_t1,
          SDTL.SECURITIES_RECEIVING_T2 receiving_t2,
          SDTL.SECURITIES_RECEIVING_T3 receiving_t3,
          3 stt

        FROM  SBSECURITIES SB, SECURITIES_INFO SEC, BUF_SE_ACCOUNT SDTL
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
                from odmast o
                where deltd <>'Y' and o.exectype in('NS','NB','MS')
                and o.txdate =(select to_date(VARVALUE,'DD/MM/YYYY') from sysvar where grname='SYSTEM' and varname='CURRDATE')
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
                (SELECT TO_NUMBER( closeprice) closeprice,symbol from stockinfor WHERE tradingdate = to_char(getcurrdate ,'dd/mm/yyyy')) stif
                ON SDTL.symbol = stif.symbol
        left join
        (select seacctno, sum(o.remainqtty) remainqtty, sum(decode(o.exectype , 'NB',  o.execamt ,0 )) B_execamt
          , sum(decode(o.exectype , 'NB',  o.execqtty ,0 )) B_execqtty, SUM(CASE WHEN o.stsstatus <> 'C' THEN (decode(o.exectype , 'NB',  o.execqtty ,0 )) ELSE 0 END)  B_execqtty_new
        from odmast o
        where deltd <>'Y' and o.exectype in('NS','NB','MS')
        and o.txdate =(select to_date(VARVALUE,'DD/MM/YYYY') from sysvar where grname='SYSTEM' and varname='CURRDATE')
        group by seacctno
        ) OD on sdtl.acctno = od.seacctno
        left join
        (select afacctno, refcodeid, trade + receiving  wft_receiving , nvl(se.namt,0) wft_3380
        from  semast sdtl, sbsecurities sb, (select acctno , namt from setran where tltxcd = '3380' and txcd = '0052' and deltd <> 'Y') se
        where sdtl.codeid = sb.codeid and sb.refcodeid is not null and sdtl.acctno = se.acctno(+)
        ) sdtl_wft on sdtl.codeid = sdtl_wft.refcodeid and sdtl.afacctno = sdtl_wft.afacctno
    LEFT JOIN afmast af ON af.acctno = SDTL.AFACCTNO
        WHERE SDTL.AFACCTNO =p_AFACCTNO AND
        SB.CODEID = SDTL.CODEID --and sb.refcodeid is null
        AND SDTL.CODEID = SEC.CODEID
        and SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED + SDTL.receiving+SDTL.SECURITIES_RECEIVING_T0+SDTL.SECURITIES_RECEIVING_T1+SDTL.SECURITIES_RECEIVING_T2+SDTL.SECURITIES_RECEIVING_T3 + nvl(od.REMAINQTTY,0) >0
      ) a, afmrserisk afmr
      WHERE a.acctno = p_AFACCTNO
            AND a.codeid = afmr.codeid(+)
            AND a.actype = afmr.actype(+)
        ) MST order by stt;
        END IF;
   END IF;
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GetNetAssetDetail');
END pr_GetNetAssetDetail;

PROCEDURE pr_GetNetAssetDetail_byCus
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     p_CUSTODYCD in varchar2,
     p_AFACCTNO    IN VARCHAR2
     )
    IS
  v_balance varchar2(100);
 v_securebal varchar2(100);
  v_debt varchar2 (100);
  v_custodycd varchar2(10);
    v_afacctno varchar2(10);
BEGIN
    if p_CUSTODYCD is null or p_CUSTODYCD = '' or length(p_CUSTODYCD)=0 then
        v_custodycd:= '%';
    else v_custodycd:= p_CUSTODYCD;
    end if;

    if p_AFACCTNO is null or p_AFACCTNO = '' or length(p_AFACCTNO)=0 then
        v_afacctno:= '%';
    else v_afacctno:= p_AFACCTNO;
    end if;

   OPEN p_REFCURSOR FOR
   SELECT ITEM, MST.ACCTNO AFACCTNO, trunc(trade) trade,trunc(receiving) receiving ,
        trunc(secured) secured, trunc(basicprice) basicprice,trunc(COSTPRICE) costprice, trunc(MARKETAMT) marketamt,
        receiving_right,receiving_t0,receiving_t1,receiving_t2,receiving_t3
          FROM (
              SELECT TO_CHAR(SB.SYMBOL) ITEM, SDTL.AFACCTNO ACCTNO,
                    SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED TRADE,
                    SDTL.receiving + nvl(od.B_execqtty_new,0)/*SDTL.SECURITIES_RECEIVING_T3*/  receiving,       --T2_HoangND
                    nvl(od.REMAINQTTY,0) secured,
                    CASE WHEN nvl( stif.closeprice,0)>0 THEN stif.closeprice ELSE  SEC.BASICPRICE END  BASICPRICE,
                     sdtl.COSTPRICE,
                     GREATEST( nvl(stif.closeprice,0), SEC.BASICPRICE)  *
                    (SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED + SDTL.receiving +nvl(od.B_execqtty_new,0)/*SDTL.SECURITIES_RECEIVING_T3*/+ nvl(od.REMAINQTTY,0)) MARKETAMT,      --T2_HoangND
                    nvl(od.B_execqtty_new,0) + SDTL.RECEIVING - SDTL.SECURITIES_RECEIVING_T0 - SDTL.SECURITIES_RECEIVING_T1 - SDTL.SECURITIES_RECEIVING_T2 RECEIVING_RIGHT,         --T2_HoangND
                    SDTL.SECURITIES_RECEIVING_T0 receiving_t0,
                    SDTL.SECURITIES_RECEIVING_T1 receiving_t1,
                    SDTL.SECURITIES_RECEIVING_T2 receiving_t2,
                    SDTL.SECURITIES_RECEIVING_T3 receiving_t3,
                   3 stt
                FROM BUF_SE_ACCOUNT SDTL, SBSECURITIES SB,
                    SECURITIES_INFO SEC,
                    (select seacctno, sum(o.remainqtty) remainqtty, sum(decode(o.exectype , 'NB',  o.execamt ,0 )) B_execamt
                        , sum(decode(o.exectype , 'NB',  o.execqtty ,0 )) B_execqtty, SUM(CASE WHEN o.stsstatus <> 'C' THEN (decode(o.exectype , 'NB',  o.execqtty ,0 )) ELSE 0 END)  B_execqtty_new
                    from odmast o
                     where deltd <>'Y' and o.exectype in('NS','NB','MS')
                      and o.txdate =(select to_date(VARVALUE,'DD/MM/YYYY') from sysvar where grname='SYSTEM' and varname='CURRDATE')
                    group by seacctno) OD,
                (SELECT TO_NUMBER( closeprice) closeprice,symbol from stockinfor WHERE tradingdate = to_char(getcurrdate ,'dd/mm/yyyy')) stif

              WHERE SDTL.custodycd like v_custodycd
                and SDTL.AFACCTNO like v_afacctno
                AND SB.CODEID = SDTL.CODEID
                AND SDTL.CODEID = SEC.CODEID
                and sdtl.acctno = od.seacctno(+)
                AND SDTL.symbol = stif.symbol(+)
                and SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED + SDTL.receiving+SDTL.SECURITIES_RECEIVING_T0+SDTL.SECURITIES_RECEIVING_T1+SDTL.SECURITIES_RECEIVING_T2+SDTL.SECURITIES_RECEIVING_T3 + nvl(od.REMAINQTTY,0) >0
              ) MST order by stt;
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GetNetAssetDetail_byCus');
END pr_GetNetAssetDetail_byCus;

PROCEDURE pr_Getmrratioloan
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     p_afacctno in varchar2,
     p_symbol    IN VARCHAR2
     )
    IS
    v_RMA number(5,2);
    v_RTOPUP number(5,2);

BEGIN
    v_RMA:=0;
    v_RTOPUP:=0;


    For vc in(
              select acctno, af.actype ,s.symbol,afs.mrratioloan
              from afmast af, afserisk afs , securities_info s, afidtype afd
              where af.actype=afs.actype
              and afs.codeid=s.codeid
              and af.acctno=p_afacctno
              and s.symbol=p_symbol
              and af.actype=afd.AFTYPE
              AND AFD.objname='LN.LNTYPE'
              AND AFD.ODRNUM=0 )
    Loop
        v_RTOPUP:=vc.mrratioloan;
    End loop;

    For vc in(select acctno, af.actype ,s.symbol,afs.mrratioloan
              from afmast af, afmrserisk afs , securities_info s
              where af.actype=afs.actype
              and afs.codeid=s.codeid
              and af.acctno=p_afacctno
              and s.symbol=p_symbol)
    Loop
       v_RMA:=vc.mrratioloan;
    End loop;

   OPEN p_REFCURSOR FOR
   SELECT p_afacctno acctno,
          p_symbol symbol,
          v_rma RMA,
          v_RTOPUP RTOPUP
   From Dual  ;
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_Getmrratioloan');
END pr_Getmrratioloan;
PROCEDURE pr_getEXT0AMT
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     p_afacctno in varchar2
     )
    IS
    v_EXT0AMT number(20,2);

BEGIN
    v_EXT0AMT:=0;

    For vc in(select afacctno, EXT0AMT
             from vw_mr9000_msbs
             where afacctno=p_afacctno
              )
    Loop
       v_EXT0AMT:=vc.EXT0AMT;
    End loop;

   OPEN p_REFCURSOR FOR
   SELECT p_afacctno acctno,
          v_EXT0AMT EXT0AMT
   From Dual  ;
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_EXT0AMT');
END pr_getEXT0AMT;
-- Lay so tien bo sung de dua tai khoan ve ty le an toan


PROCEDURE pr_GetCustomIntroduceList
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     p_custid    IN VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2
    )
    IS
BEGIN
    OPEN p_REFCURSOR FOR
    SELECT CFI.ID, CFI.FULLNAME, CFI.SEX, CFI.MOBILE, CFI.INTRODATE, CFI.STATUS, CFI.DESCRIPTION,
        CASE WHEN CFI.STATUS = 'A' AND NVL(AF.STATUS, '-') = 'A' THEN CF.CUSTODYCD ElSE '' END CUSTODYCDNEW
    FROM CFINTRO CFI, CFMAST CF, (SELECT CUSTID, MAX(STATUS) STATUS FROM AFMAST WHERE LENGTH(PSTATUS) > 1 GROUP BY CUSTID) AF
    WHERE CFI.CUSTIDINTRO = p_custid AND CFI.STATUS <> 'D'
        AND CFI.idcodeintro = CF.IDCODE(+)
        AND CF.CUSTID = AF.CUSTID(+)
        AND CFI.INTRODATE BETWEEN TO_DATE (F_DATE, systemnums.c_date_format) AND TO_DATE (T_DATE, systemnums.c_date_format)
    ORDER BY CFI.INTRODATE DESC;
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GetCustomIntroduceList');
END pr_GetCustomIntroduceList;


PROCEDURE pr_CustomIntroduceDoing
    (   p_type varchar2,
        p_id    VARCHAR2,
        p_fullname  varchar2,
        p_sex  varchar2,
        p_mobile  varchar2,
        p_introDate  varchar2,
        p_desc varchar2,
        p_custidintro varchar2,
        p_err_code  OUT varchar2,
        p_err_message  OUT varchar2
    )
    IS
    v_count number(20,0);
    v_status varchar2(3);
BEGIN

    plog.setBeginSection(pkgctx, 'pr_CustomIntroduceDoing');

    p_err_code  := systemnums.C_SUCCESS;
    p_err_message := 'SUCCESS';

    if p_type = 'I' then
        Select Count(*) into v_count from cfmast where mobile = p_mobile or phone = p_mobile And status <> 'C';
        if v_count > 0 then
            p_err_code := '-260165';
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_CustomIntroduceDoing');
            return;
        end if;

        if TO_DATE (p_introDate, systemnums.c_date_format) <> getcurrdate then
            p_err_code := '-900011';
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_CustomIntroduceDoing');
            return;
        end if;


        Insert into CFINTRO (ID, FULLNAME, SEX, MOBILE, INTRODATE, STATUS, DESCRIPTION, IDCODEINTRO, CUSTODYCDNEW, CUSTIDINTRO)
        Values (sys_guid(), p_fullname, p_sex, p_mobile, TO_DATE (p_introDate, systemnums.c_date_format), 'P', p_desc, null, null, p_custidintro);
    ELSIF p_type = 'D' then
        Select Status into v_status from CFINTRO where id = p_id;

        if v_status <> 'P' THEN
            p_err_code := '-260166';
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_CustomIntroduceDoing');
            return;
        end if;

        Update CFINTRO Set Status = 'D' Where id = p_id And Status = 'P';
    ELSIF p_type = 'E' then
        Select Status into v_status from CFINTRO where id = p_id;

        if v_status <> 'P' THEN
            p_err_code := '-260166';
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_CustomIntroduceDoing');
            return;
        end if;

        Update CFINTRO Set Fullname = p_fullname, sex = p_sex, mobile = p_mobile, description = p_desc
            --introDate = TO_DATE (p_introDate, systemnums.c_date_format)
        Where id = p_id And Status = 'P';
    end if;

EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_CustomIntroduceDoing');
END pr_CustomIntroduceDoing;

procedure pr_get_ADDVND
    (p_refcursor in out pkg_report.ref_cursor,
    p_custodycd in VARCHAR2,
    p_afacctno  IN  varchar2)
IS
    V_CUSTODYCD     varchar2(10);
    V_AFACCTNO      varchar2(10);
    V_CURRDATE      DATE;
begin
    plog.setbeginsection(pkgctx, 'pr_get_ADDVND');

    IF p_custodycd = 'ALL' OR p_custodycd is NULL THEN
        V_CUSTODYCD := '';
    ELSE
        V_CUSTODYCD := p_custodycd;
    END IF;

    IF p_afacctno = 'ALL' OR p_afacctno IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := p_afacctno;
        SELECT CF.CUSTODYCD INTO V_CUSTODYCD
        FROM AFMAST AF, CFMAST CF
        WHERE AF.custid = CF.custid AND AF.ACCTNO = p_afacctno;
    END IF;

    -- GET CURRENT DATE
    SELECT getcurrdate INTO V_CURRDATE FROM DUAL;
    Open p_refcursor for
          select custodycd,acctno,ADDVND
        from vw_mr0003
         where acctno = V_AFACCTNO;
    plog.setendsection(pkgctx, 'pr_get_ADDVND');
exception when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'pr_get_ADDVND');
end pr_get_ADDVND;

---pr_list_loan_t0---
PROCEDURE pr_list_loan_t0 (
    PV_REFCURSOR        IN OUT  PKG_REPORT.REF_CURSOR,
    PV_AFACCTNO         IN      VARCHAR2,
    PV_TLID             IN      VARCHAR2

) IS

    V_AFACCTNO       VARCHAR2(20);
    V_TLID           VARCHAR2(4);

BEGIN

    IF (PV_AFACCTNO <> 'ALL') THEN
        V_AFACCTNO :=  PV_AFACCTNO;
    ELSE
        V_AFACCTNO := '%%';
    END IF;

    V_TLID := PV_TLID;

OPEN PV_REFCURSOR FOR

SELECT cf.custodycd, af.acctno afacctno, cf.fullname, nvl(seass.realass,0) realass, nvl(NYOVDAMT,0) t0amt,
    nvl(NYOVDAMT,0) + nvl(marginamt,0) od_amt, af.advanceline t0_in_day, nvl(secureamt_inday,0) totalbuyqtty,
    ci.balance + nvl(adv.avladvance,0) balance,
    round((CASE WHEN ci.balance +LEAST(nvl(af.MRCRLIMIT,0),nvl(al.secureamt,0)+trfbuyamt)+ nvl(adv.avladvance,0) - trfbuyamt - ci.odamt - nvl(al.secureamt,0) - ci.ramt>=0 then 100000
            ELSE nvl(se.SEMAXTOTALCALLASS,0)
                --least(/*nvl(af.MRCRLIMIT,0) +*/ nvl(se.SEMAXTOTALCALLASS,0), af.mrcrlimitmax - dfodamt)
            / abs(ci.balance +LEAST(nvl(af.MRCRLIMIT,0),nvl(al.secureamt,0)+trfbuyamt)+ nvl(adv.avladvance,0) - trfbuyamt - ci.odamt - nvl(al.secureamt,0) - ci.ramt)
            END),4
        ) * 100 MARGINRATE,
    round((CASE WHEN ci.balance +LEAST(nvl(af.MRCRLIMIT,0), nvl(al.secureamt,0)+ trfbuyamt)+ nvl(adv.avladvance,0) - trfbuyamt - ci.odamt + NVL(ln.NYOVDAMT1,0) - nvl(al.secureamt,0) - ci.ramt>=0 then 100000
            ELSE least(/*nvl(af.MRCRLIMIT,0) +*/ nvl(se.SEMAXTOTALCALLASS,0), af.mrcrlimitmax - dfodamt)
            / abs(ci.balance +LEAST(nvl(af.MRCRLIMIT,0), nvl(al.secureamt,0)+ trfbuyamt) +nvl(adv.avladvance,0) - trfbuyamt - ci.odamt + NVL(ln.NYOVDAMT1,0) - nvl(al.secureamt,0) - ci.ramt)
            END),4
        ) * 100 MARGINRAT2
FROM cimast ci, afmast af, aftype aft, lntype lnt ,mrtype mr, cfmast cf,
    (SELECT * FROM v_getbuyorderinfo WHERE afacctno LIKE V_AFACCTNO) al,
    (SELECT * FROM v_getsecmargininfo WHERE afacctno LIKE V_AFACCTNO) se,
    (SELECT * FROM vw_trfbuyinfo_inday WHERE afacctno LIKE V_AFACCTNO) trfi,
    (SELECT sum(realass) realass, afacctno FROM vw_mr9004 WHERE afacctno LIKE V_AFACCTNO GROUP BY afacctno) seass,
    (
        SELECT trfacctno,
            sum(CASE WHEN lns.reftype = 'GP' THEN
                    (lns.nml + lns.ovd + lns.intdue + lns.intovd + lns.feedue + lns.feeovd + lns.intovdprin + lns.intnmlacr
                    + lns.feeintnmlacr + lns.feeintovdacr + lns.feeintnmlovd + lns.feeintdue + lns.nmlfeeint + lns.ovdfeeint + lns.feeintnml + lns.feeintovd )
                ELSE 0
            END )  NYOVDAMT,
            sum(CASE WHEN lns.reftype = 'GP' THEN
                    case when lns.mintermdate >= getcurrdate  then (lns.nml + lns.ovd + lns.intdue + lns.intovd + lns.feedue + lns.feeovd + lns.intovdprin + lns.intnmlacr
                    + lns.feeintnmlacr + lns.feeintovdacr + lns.feeintnmlovd + lns.feeintdue + lns.nmlfeeint + lns.ovdfeeint + lns.feeintnml + lns.feeintovd ) else 0 end
                ELSE 0
            END )  NYOVDAMT1,
            sum(CASE WHEN ln.ftype = 'AF' THEN
                    CASE WHEN lns.reftype = 'P' THEN decode(lnt.chksysctrl, 'N',0, (lns.nml + lns.ovd + lns.intdue + lns.intovd + lns.feedue + lns.feeovd + lns.intovdprin + lns.intnmlacr
                                                    + lns.feeintnmlacr + lns.feeintovdacr + lns.feeintnmlovd + lns.feeintdue + lns.nmlfeeint + lns.ovdfeeint + lns.feeintnml + lns.feeintovd ))
                    ELSE 0 END
                ELSE 0
                END ) marginamt
        FROM lnschd lns, lnmast ln ,lntype lnt
        WHERE lns.acctno = ln.acctno AND trfacctno LIKE V_AFACCTNO
            AND ln.actype = lnt.actype
        GROUP BY trfacctno
    ) LN,
    (
        SELECT sum(aamt) aamt,sum(depoamt) avladvance,sum(paidamt) paidamt, sum(advamt) advanceamount,afacctno
        FROM v_getAccountAvlAdvance
        WHERE afacctno LIKE V_AFACCTNO
        GROUP BY afacctno
    ) adv
WHERE ci.acctno = af.acctno and af.actype = aft.actype and aft.lntype = lnt.actype(+)
    AND ci.acctno = al.afacctno(+) AND se.afacctno(+) = ci.acctno
    AND adv.afacctno(+)=ci.acctno AND ci.acctno = seass.afacctno(+)
    AND ln.trfacctno(+) = ci.acctno AND cf.custid = af.custid
    AND ci.acctno = trfi.afacctno(+) AND nvl(NYOVDAMT,0) + (nvl(af.advanceline,0)) > 1
    AND aft.mrtype =mr.actype AND af.acctno LIKE V_AFACCTNO
    AND AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = V_TLID)


/*SELECT cf.custodycd, af.acctno afacctno, cf.fullname, sum(nvl(v.realass,0)) realass, max(nvl(od_amt.od_amt,0)) od_amt, max(nvl(od_amt.t0amt,0)) t0amt,
    max(nvl(af.advanceline,0)) t0_in_day, max(nvl(buy_t0.totalbuyamt,0)) totalbuyqtty, max(nvl(ci.balance,0)) balance,
    nvl(se1.marginrate,0) marginrate, nvl(se2.marginrate,0) marginrat2
FROM vw_mr9004 v, cfmast cf, afmast af,
    (
        SELECT trfacctno, nvl(sum(t0amt),0) t0amt, nvl(sum(t0amt),0) + nvl(sum(marginamt),0) od_amt
        FROM vw_lngroup_all
        WHERE trfacctno LIKE V_AFACCTNO
        GROUP BY trfacctno
    ) od_amt,
    (
        select afacctno,nvl(sum(secureamt_inday),0) totalbuyamt
        from vw_trfbuyinfo_inday
        where afacctno like V_AFACCTNO
        GROUP BY afacctno
    ) buy_t0,
    (
        SELECT ci.acctno, max(ci.balance) + sum(nvl(avl.depoamt,0)) balance
        FROM cimast ci, v_getaccountavladvance avl
        WHERE ci.acctno = avl.afacctno(+) AND acctno LIKE V_AFACCTNO
        GROUP BY ci.acctno
    ) ci,
    (
        SELECT * FROM v_getsecmarginratio WHERE afacctno LIKE V_AFACCTNO
    ) se1,
    (
        SELECT * FROM v_getsecmarginratio_all WHERE afacctno LIKE V_AFACCTNO
    ) se2

WHERE af.acctno LIKE V_AFACCTNO AND cf.custid = af.custid
    AND v.afacctno(+) = af.acctno AND v.afacctno = od_amt.trfacctno(+)
    AND v.afacctno = ci.acctno(+) and af.acctno = buy_t0.afacctno(+)
    AND v.afacctno = se1.afacctno(+) AND v.afacctno = se2.afacctno(+)
    AND AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = V_TLID)
    AND nvl(od_amt.t0amt,0) + (nvl(af.advanceline,0)) > 1
GROUP BY cf.custodycd, af.acctno, cf.fullname, se1.marginrate, se2.marginrate
ORDER BY af.acctno*/

;

 EXCEPTION
   WHEN OTHERS
   THEN
        RETURN;
END;
---End_pr_list_loan_t0---

---pr_Allocate_T0_Information---
PROCEDURE pr_Allocate_T0_Information (
    PV_REFCURSOR        IN OUT  PKG_REPORT.REF_CURSOR,
    PV_AFACCTNO         IN      VARCHAR2,
    PV_AMT              IN      VARCHAR2,
    PV_USERID           IN      VARCHAR2

) IS
    V_CUSTODYCD         VARCHAR2(20);
    V_FULLNAME          VARCHAR2(200);
    V_CONTRACTCHK       VARCHAR2(200);
    V_USERTYPE          VARCHAR2(200);
    V_AFACCTNO          VARCHAR2(20);
    V_AMT               NUMBER;
    V_ADVANCELINE       NUMBER;
    V_ACCUSED           NUMBER;
    V_CUSTAVLLIMIT      NUMBER;
    V_ACCLIMIT          NUMBER;
    V_MARGINRATE        NUMBER;
    V_MARGINRATE2       NUMBER;
    V_MARGINRATE_T0     NUMBER;
    V_PERIOD            NUMBER;
    V_PP                NUMBER;
    V_SETOTAL           NUMBER;
    V_T0CAL             NUMBER;
    V_T0CAL2            NUMBER;
    V_T0DEB             NUMBER;
    V_TLFULLNAME        VARCHAR2(200);
    V_TOTALLOAN         NUMBER;
    V_RLIMIT            NUMBER;
    -------------------------------
    V_TOAMT             NUMBER;
    V_T0OVRQ            NUMBER;
    V_T0AMTPENDING      NUMBER;
    V_TLID              VARCHAR2(200);
    V_USERID            VARCHAR2(10);
    V_TLIDNAME          VARCHAR2(200);
    V_TXDESC            VARCHAR2(200);
    V_DESC              VARCHAR2(200);
    V_TLGROUP           VARCHAR2(200);
    v_T0OveqRate        NUMBER;
    V_NAVNO             NUMBER;
    v_x                 NUMBER;
    v_symbolflag        NUMBER;


BEGIN

    V_AFACCTNO :=  PV_AFACCTNO;     --03
    V_AMT := TO_NUMBER(PV_AMT);     --22
    V_USERID := PV_USERID;          --01

    SELECT cf.custodycd, cf.fullname, a1.cdcontent
    INTO    V_CUSTODYCD,        --88
            V_FULLNAME,         --90
            V_CONTRACTCHK       --86
    FROM afmast af, cfmast cf, allcode a1
    WHERE cf.custid = af.custid AND af.acctno = V_AFACCTNO
        AND cf.contractchk = a1.cdval AND CDTYPE = 'SY' AND CDNAME = 'YESNO';

    BEGIN
        SELECT usertype INTO V_USERTYPE          --02
        FROM userlimit WHERE tliduser = V_USERID;
     EXCEPTION
       WHEN OTHERS THEN
        V_USERTYPE := '';
    END;

    BEGIN
        SELECT  ADVANCELINE,
                AFT0USED,
                CUSTT0REMAIN,
                CUSTT0USED,
                MARGINRATE,
                MARGINRATE_T0,
                PERIOD,
                PP,
                SETOTAL,
                T0CAL,
                T0CAL2,
                T0DEB,
                --T0OVRQ,
                --T0REAL,
                TLFULLNAME,
                TOTALLOAN,
                URT0LIMITREMAIN

        INTO    V_ADVANCELINE,      --41
                V_ACCUSED,          --13
                V_CUSTAVLLIMIT,     --16
                V_ACCLIMIT,         --11
                V_MARGINRATE,       --17
                V_MARGINRATE_T0,    --89
                V_PERIOD,           --21
                V_PP,               --20
                V_SETOTAL,          --18
                V_T0CAL,            --40
                V_T0CAL2,
                V_T0DEB,            --43
                --V_T0OVRQ,           --42
                --V_TOAMT,            --10
                V_TLFULLNAME,       --91
                V_TOTALLOAN,        --19
                V_RLIMIT            --12
        FROM
        (
            SELECT A.*, nvl(T0af.AFT0USED,0) AFT0USED, NVL(T0.CUSTT0USED,0) CUSTT0USED,
                least (A.T0CAL - A.ADVANCELINE ,A.T0LOANLIMIT - nvl(t0.CUSTT0USED,0)) T0REAL,
                A.T0LOANLIMIT - NVL(T0.CUSTT0USED,0) CUSTT0REMAIN,
                GREATEST(nvl(urlt.t0,0) - nvl(uflt.t0acclimit,0),0) urt0limitremain,
                a.t0cal - a.advanceline T0Remain, 0 T0OVRQ , tlp.tlid, tlp.tlfullname
            FROM
            (
                SELECT CF.CUSTID, CF.CUSTODYCD, AF.ACCTNO,CF.FULLNAME,cf.t0loanrate, AF.ADVANCELINE, CF.MRLOANLIMIT, CF.T0LOANLIMIT,af.CAREBY, af.actype,
                    CF.CONTRACTCHK ,nvl((ci.balance - NVL(v_getbuy.secureamt,0)) + NVL(ADV.avladvance,0) + v_getsec.senavamt - (NVL(ln.marginamt,0) + NVL(ln.t0amt,0)),0) navamt,
                    nvl(v_getsec.SELIQAMT,0) SELIQAMT, NVL(ln.marginamt,0) + NVL(ln.t0amt,0) totalloan  , nvl(setotal,0) + (ci.balance -
                    NVL(v_getbuy.secureamt,0)) + NVL(ADV.avladvance,0) setotal ,ROUND(least (nvl((ci.balance - NVL(v_getbuy.secureamt,0)) + NVL(ADV.avladvance,0) +
                    v_getsec.senavamt - (NVL(ln.marginamt,0) + NVL(ln.t0amt,0)),0) * cf.t0loanrate /100,
                    nvl(v_getsec.SELIQAMT,0) )) T0CAL,ROUND(least (nvl((ci.balance - NVL(v_getbuy.secureamt,0)) + NVL(ADV.avladvance,0) +
                    v_getsec.senavamt - (NVL(ln.marginamt,0) + NVL(ln.t0amt,0)),0) * cf.t0loanrate /100,
                    nvl(v_getsec.SELIQAMT2,0) )) T0CAL2, GREATEST(0, NVL(NVL(ln.t0amt,0) - NVL(ci.balance +  NVL(v_getbuy.secureamt,0) + NVL(ADV.avladvance,0),0),0))
                    T0DEB, NVL(buf.MARGINRATE,0) MARGINRATE, nvl(se.MARGINRATE_T0,0) MARGINRATE_T0,  se.PP , lnt.minterm  period
                FROM CFMAST CF, CIMAST CI, AFMAST AF, AFTYPE AFT, LNTYPE LNT,
                (
                    select sum(aamt) aamt,sum(depoamt) avladvance,sum(paidamt) paidamt, sum(advamt) advanceamount,afacctno
                    from v_getAccountAvlAdvance group by afacctno
                ) adv,
                (
                    select trfacctno, trunc(sum(prinnml+prinovd+intnmlacr+intdue+intovdacr +intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd),0) marginamt,
                        trunc(sum(oprinnml+oprinovd+ointnmlacr+ointdue+ointovdacr+ointnmlovd),0) t0amt,
                        trunc(sum(prinovd+intovdacr+intnmlovd+feeintovdacr+feeintnmlovd + nvl(ls.dueamt,0) + intdue + feeintdue),0) marginovdamt,
                        trunc(sum(oprinovd+ointovdacr+ointnmlovd),0) t0ovdamt
                    from lnmast ln, lntype lnt,
                    (
                        select acctno, sum(nml) dueamt
                        from lnschd, (select * from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM') sy
                        where reftype = 'P' and overduedate = to_date(varvalue,'DD/MM/RRRR') group by acctno
                    ) ls
                    where ftype = 'AF' and ln.actype = lnt.actype
                        and ln.acctno = ls.acctno(+)
                    group by ln.trfacctno
                ) ln, v_getbuyorderinfo v_getbuy, v_getsecmargininfo_ALL v_getsec, V_GETSECMARGINRATIO se, buf_ci_account buf
                WHERE AF.ACCTNO = CI.ACCTNO  AND AF.CUSTID = CF.CUSTID (+)
                    AND AF.ACCTNO = ADV.AFACCTNO (+)
                    AND buf.afacctno=se.afacctno AND af.acctno = V_AFACCTNO
                    and af.acctno = v_getbuy.afacctno (+)   and af.acctno = v_getsec.afacctno (+)
                    and af.acctno = ln.trfacctno (+)
                    and af.acctno = buf.afacctno(+)
                    and cf.contractchk = 'Y'
                    and af.actype = aft.actype
                    and aft.t0lntype= lnt.actype
            ) A,
            (SELECT CUSTID, SUM(ADVANCELINE) TOTALADVLINE FROM AFMAST GROUP BY CUSTID) v_t0,
            (
                select sum(acclimit) CUSTT0USED, af.CUSTID
                from useraflimit us, afmast af
                where af.acctno = us.acctno AND af.custid = (SELECT custid FROM afmast WHERE acctno = V_AFACCTNO)
                    AND us.typereceive = 'T0'
                group by custid
            ) T0,
            (
                select sum(acclimit) AFT0USED, acctno
                FROM useraflimit us
                where us.typereceive = 'T0' AND acctno = V_AFACCTNO
                group BY acctno
            ) T0af,
            (select tliduser,allocatelimmit,usedlimmit,acctlimit,t0,t0max from userlimit where tliduser = V_USERID) urlt,
            (
                select tliduser,sum(decode(typereceive,'T0',acclimit, 0)) t0acclimit,sum(decode(typereceive,'MR',acclimit, 0)) mracclimit
                from useraflimit where typeallocate = 'Flex' and tliduser = V_USERID
                group by tliduser
            ) uflt, tlprofiles tlp, TLGROUPS GRP
            WHERE A.CUSTID = v_t0.custid (+)
                AND A.custid = t0.custid (+)
                and a.acctno = T0af.acctno(+)
                and a.t0loanrate >=0
                and tlp.tlid = uflt.tliduser(+)
                and tlp.tlid = urlt.tliduser(+)
                and tlp.tlid = V_USERID
                AND a.CAREBY = GRP.GRPID
                AND GRP.GRPTYPE = '2'
                AND a.CAREBY IN (SELECT TLGRP.GRPID
                                    FROM TLGRPUSERS TLGRP
                                    WHERE TLID = V_USERID)
        ) MR
        WHERE mr.acctno = V_AFACCTNO
    ;
     EXCEPTION
       WHEN OTHERS THEN
                V_ADVANCELINE       := 0;
                V_ACCUSED           := 0;
                V_CUSTAVLLIMIT      := 0;
                V_ACCLIMIT          := 0;
                V_MARGINRATE        := 0;
                V_MARGINRATE_T0     := 0;
                V_PERIOD            := 0;
                V_PP                := 0;
                V_SETOTAL           := 0;
                V_T0CAL             := 0;
                V_T0CAL2            := 0;
                V_T0DEB             := 0;
                --V_T0OVRQ            := 0;
                --V_TOAMT             := 0;
                V_TLFULLNAME        := NULL;
                V_TOTALLOAN         := 0;
                V_RLIMIT            := 0;
    END;
    --10        fn_TOAMT_1810(03##22##20##41)
    SELECT fn_TOAMT_1810(V_AFACCTNO,V_AMT,V_PP,V_ADVANCELINE) INTO V_TOAMT FROM dual;
    --42        41+10-40
    V_T0OVRQ := V_ADVANCELINE + V_TOAMT - V_T0CAL;
    --23        fn_T0AMTPENDING_1810(03##12##40##41##16##22##20##43)
    SELECT fn_T0AMTPENDING_1810(V_AFACCTNO,V_RLIMIT,V_T0CAL,V_ADVANCELINE,V_CUSTAVLLIMIT,V_AMT,V_PP,V_T0DEB) INTO V_T0AMTPENDING FROM dual;
    --26        FN_GET_USERTOLIMIT(01##23##21)
    SELECT FN_GET_USERTOLIMIT(V_USERID,V_T0AMTPENDING,V_PERIOD) INTO V_TLID FROM dual;
    --92        fn_getName_TLID(26)
    SELECT fn_getName_TLID(V_TLID) INTO V_TLIDNAME FROM dual;
    --30        FN_GEN_DESC_1816(30##03##22)
    SELECT txdesc INTO V_TXDESC FROM tltx WHERE tltxcd = '1810';
    SELECT FN_GEN_DESC_1816(V_TXDESC,V_AFACCTNO,V_AMT) INTO V_DESC FROM dual;
    --93        FN_GET_TLGR(01)
    SELECT FN_GET_TLGR(V_USERID) INTO V_TLGROUP FROM dual;

    SELECT varvalue INTO v_T0OveqRate FROM sysvar WHERE varname ='T0OVRQRATIO' AND grname ='MARGIN';
    SELECT v.marginrate INTO v_marginrate2
    FROM v_getsecmarginratio v, afmast af
    WHERE v.afacctno = V_AFACCTNO AND v.afacctno=af.acctno;


    SELECT FN_GET_NAV_NO(V_CUSTODYCD,V_AFACCTNO) INTO V_NAVNO FROM dual;
    SELECT TO_NUMBER(varvalue) INTO v_x FROM sysvar WHERE varname = 'NAV/NO';

    IF V_NAVNO >= v_x THEN
        v_symbolflag := 0;
    ELSE
        v_symbolflag := 1;
    END IF;

OPEN PV_REFCURSOR FOR

SELECT V_CUSTODYCD CUSTODYCD,
    V_FULLNAME FULLNAME,
    V_CONTRACTCHK CONTRACTCHK,
    V_USERTYPE USERTYPE,
    V_USERID USERID,
    V_AFACCTNO ACCTNO,
    V_T0CAL2 T0CAL,
    V_T0CAL2 T0CAL2,
    V_ADVANCELINE ADVANCELINE,
    V_MARGINRATE MARGINRATE,
    V_MARGINRATE_T0 MARGINRATE_T0,
    V_SETOTAL SETOTAL,
    V_TOTALLOAN TOTALLOAN,
    V_PP PP,
    V_T0DEB T0DEB,
    V_PERIOD PERIOD,
    V_AMT T0AMTUSED,
    V_T0AMTPENDING T0AMTPENDING,
    V_TOAMT TOAMT,
    '' SYMBOLAMT,
    '' SOURCE,
    V_TLID TLID,
    V_TLIDNAME TLIDNAME,
    V_RLIMIT RLIMIT,
    V_ACCLIMIT ACCLIMIT,
    V_CUSTAVLLIMIT CUSTAVLLIMIT,
    V_ACCUSED ACCUSED,
    V_T0OVRQ T0OVRQ,
    V_DESC V_DESC,
    V_TLFULLNAME TLFULLNAME,
    V_TLGROUP TLGROUP,
    CASE WHEN to_number(v_T0OveqRate) >= to_number(V_MARGINRATE2) THEN 'Y' ELSE 'N' END WARN_MESSAGE,
    V_NAVNO NAVNO,
    v_symbolflag symbolflag
FROM dual

;

 EXCEPTION
   WHEN OTHERS
   THEN
        RETURN;
END;
---End_pr_Allocate_T0_Information---

 PROCEDURE pr_GetAccount(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                          CUSTODYCD   IN VARCHAR2,
                          AFACCTNO    IN VARCHAR2,
                          F_DATEBRID  IN VARCHAR2,
                          T_DATEBRID  IN VARCHAR2,
                          F_DATE      IN VARCHAR2,
                          T_DATE      IN VARCHAR2,
                          LN_RATE     IN VARCHAR2,
                          LN_YN       IN VARCHAR2,
                          TLID        IN VARCHAR2) IS

    V_CUSTODYCD VARCHAR2(10);
    V_AFACCTNO  VARCHAR2(50);
    V_CUSTID    VARCHAR2(10);
    V_TLID      VARCHAR2(10);
    V_LN_RATE   VARCHAR2(10);
    v_dc number ;

  BEGIN
    -- V_CUSTODYCD := CUSTODYCD;
    --V_AFACCTNO := AFACCTNO;
    V_TLID := TLID;

    IF AFACCTNO = 'ALL' OR AFACCTNO IS NULL THEN
      V_AFACCTNO := '%%';
    ELSE
      V_AFACCTNO := AFACCTNO;
    END IF;
    IF  LN_RATE = 'ALL' THEN
      V_LN_RATE := 'ALL';
    ELSE
      v_dc := to_number(LN_RATE);
      V_LN_RATE := LN_RATE;
    END IF;

    -- LAY THONG TIN MA KHACH HANG
    IF CUSTODYCD = 'ALL' OR CUSTODYCD IS NULL THEN
      V_CUSTODYCD := '%%';
    ELSE
      V_CUSTODYCD := CUSTODYCD;
    END IF;

    -- LAY THONG TIN LENH

    -- Neu la lai
    if LN_YN = 'Y' and V_LN_RATE != 'ALL' then
        -- neu la lo
         OPEN p_REFCURSOR FOR
         select cf.custodycd,
       af.acctno,
       cf.fullname,
       cf.mobile,
       (select max(cf.fullname) refullname
          from reaflnk re, sysvar sys, cfmast cf, RETYPE
         where to_date(varvalue, 'DD/MM/RRRR') between re.frdate and
               re.todate
           and substr(re.reacctno, 0, 10) = cf.custid
           and varname = 'CURRDATE'
           and grname = 'SYSTEM'
           and re.status <> 'C'
           and re.deltd <> 'Y'
           AND substr(re.reacctno, 11) = RETYPE.ACTYPE
           AND rerole IN ('RM', 'BM')
           and re.afacctno = af.acctno) tlfullname,
       cf.dateofbirth,
       max(nvl(ln.PROFITANDLOSS,0)) PROFITANDLOSS,
       max(nvl(ln.LS,0)) LS,
       max(nvl(odt.tongmua,0)) tongmua,
       max(nvl(odt.tongban,0)) tongban,
       max(nvl(cit.noptien,0)) noptien,
       max(nvl(cit.ruttien,0)) ruttien

  from (
 select sum(TONGMUA) TONGMUA, sum(TONGBAN) TONGBAN, ciacctno
  from
  (select (CASE
                 WHEN OD.EXECTYPE in ('NB') THEN
                  sum(OD.EXECAMT + OD.FEEAMT)
                 ELSE
                  0
               END) TONGMUA,
               (case
                 WHEN OD.EXECTYPE IN ('NS', 'MS') THEN
                  sum(OD.EXECAMT + OD.FEEAMT + OD.TAXSELLAMT)
                 ELSE
                  0
               END) TONGBAN,
               OD.CIACCTNO

          FROM VW_ODMAST_ALL OD, afmast a, cfmast c
         WHERE OD.ORSTATUS IN ('4', '5', '7', '12')
           AND OD.EXECQTTY > 0
           and od.TXDATE >= to_date(F_DATE, 'dd/MM/yyyy')
           and od.TXDATE <= to_date(T_DATE, 'dd/MM/yyyy')
           and od.AFACCTNO = a.acctno
           and a.custid = c.custid
           and c.custodycd like V_CUSTODYCD
         Group by OD.CIACCTNO, OD.EXECTYPE
         order by OD.CIACCTNO) group by ciacctno) odt,
        ( select sum(NOPTIEN) NOPTIEN, sum(RUTTIEN) RUTTIEN, acctno from

           (select (CASE
                 WHEN ci.txtype in ('C') and
                      ci.tltxcd in ('1131',
                                    '1141',
                                    '1137',
                                    '1138',
                                    '3350', -- 3342 = (3350.3354)
                                    '3354',
                                    '1120',
                                    '1188',
                                    '1130') THEN
                  sum(CI.namt)
                 ELSE
                  0
               END) NOPTIEN,
               (case
                 WHEN ci.txtype in ('D') and
                      ci.tltxcd in ('1132',
                                    '1188',
                                    '1184',
                                    '1130',
                                    '1101',
                                    '1133',
                                    '1111',
                                    '1185',
                                    '1120') then
                  sum(CI.namt)
                 ELSE
                  0
               END) RUTTIEN

              ,
               ci.acctno

          FROM vw_citran_gen ci
         WHERE ci.field = 'BALANCE'
           and ci.TXDATE >= to_date(F_DATE, 'dd/MM/rrrr')
           and ci.TXDATE <= to_date(T_DATE, 'dd/MM/rrrr')
           and ci.tltxcd in ('1132',   '1188','1184',   '1130',   '1101', '1133','1111','1185',  '1120','1131',
                                    '1141',
                                    '1137',
                                    '1138',
                                    '3350', -- 3342 = (3350.3354)
                                    '3354',
                                    '1120',
                                    '1188',
                                    '1130')
           and ci.custodycd like  V_CUSTODYCD
         group by ci.txtype, ci.acctno, ci.tltxcd
         --order by ci.acctno
         )

         group by acctno) cit,
      ( select acctno, sum(PROFITANDLOSS) PROFITANDLOSS,CASE WHEN sum(ls)>0 THEN  round(sum(PROFITANDLOSS) *100/sum(ls),2) ELSE 0 END  ls from
       (select ACCTNO,
               SUM((basicprice - costprice) *
                   (trunc(trade) + trunc(secured) + receiving_right +
                   receiving_t1 + receiving_t2 + receiving_t3)) PROFITANDLOSS,

               SUM(  costprice *
                       (trunc(trade) + trunc(secured) + receiving_right +
                       receiving_t1 + receiving_t2 + receiving_t3)  ) LS


                   /*sum((BASICPRICE- COSTPRICE)*100/(COSTPRICE+0.00001)) LS*/
          from (SELECT SDTL.AFACCTNO ACCTNO,
                       sdtl.CUSTODYCD,
                       SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY +
                       SDTL.ABSTANDING + SDTL.BLOCKED TRADE,
                       nvl(od.REMAINQTTY, 0) secured,
                       CASE
                         WHEN nvl(stif.closeprice, 0) > 0 THEN
                          stif.closeprice
                         ELSE
                          SEC.BASICPRICE
                       END BASICPRICE,
                       round((round(sdtl.COSTPRICE) -- gia_von_ban_dau ,
                             * (SDTL.TRADE + SDTL.DFTRADING +
                             SDTL.RESTRICTQTTY + SDTL.ABSTANDING +
                             SDTL.BLOCKED + SDTL.RECEIVING +
                             nvl(sdtl_wft.wft_receiving, 0) +
                             sdtl.secured) --tong_kl
                             + nvl(od.B_execamt, 0) --gia_tri_mua --gia tri khop mua
                             ) /
                             (SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY +
                             SDTL.ABSTANDING + SDTL.BLOCKED +
                             nvl(sdtl_wft.wft_receiving, 0) + sdtl.secured +
                             SDTL.RECEIVING + nvl(od.B_EXECQTTY, 0) +
                             0.000001)) as COSTPRICE,
                       SDTL.RECEIVING - SDTL.SECURITIES_RECEIVING_T1 -
                       SDTL.SECURITIES_RECEIVING_T2 +
                       nvl(sdtl_wft.wft_receiving, 0) RECEIVING_RIGHT,
                       SDTL.SECURITIES_RECEIVING_T1 receiving_t1,
                       SDTL.SECURITIES_RECEIVING_T2 receiving_t2,
                       SDTL.SECURITIES_RECEIVING_T3 receiving_t3

                  FROM SBSECURITIES    SB,
                       SECURITIES_INFO SEC,
                       BUF_SE_ACCOUNT  SDTL
                  LEFT JOIN (SELECT TO_NUMBER(closeprice) closeprice, symbol
                              from stockinfor
                             WHERE tradingdate =
                                   to_char(getcurrdate, 'dd/mm/yyyy')) stif
                    ON SDTL.symbol = stif.symbol
                  left join (select seacctno,
                                   sum(o.remainqtty) remainqtty,
                                   sum(decode(o.exectype, 'NB', o.execamt, 0)) B_execamt,
                                   sum(decode(o.exectype, 'NB', o.execqtty, 0)) B_execqtty
                              from odmast o
                             where deltd <> 'Y'
                               and o.exectype in ('NS', 'NB', 'MS')
                               and o.txdate =
                                   (select to_date(VARVALUE, 'DD/MM/YYYY')
                                      from sysvar
                                     where grname = 'SYSTEM'
                                       and varname = 'CURRDATE')
                             group by seacctno) OD
                    on sdtl.acctno = od.seacctno
                  left join (select afacctno,
                                   refcodeid,
                                   trade + receiving -
                                   SECURITIES_RECEIVING_T1 -
                                   SECURITIES_RECEIVING_T2 wft_receiving
                              from buf_se_account sdtl, sbsecurities sb
                             where sdtl.codeid = sb.codeid
                               and sb.refcodeid is not null) sdtl_wft
                    on sdtl.codeid = sdtl_wft.refcodeid
                   and sdtl.afacctno = sdtl_wft.afacctno
                 WHERE SB.CODEID = SDTL.CODEID
                   and sb.refcodeid is null
                   AND SDTL.CODEID = SEC.CODEID
                   and SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY +
                       SDTL.ABSTANDING + SDTL.BLOCKED + SDTL.receiving +
                       SDTL.SECURITIES_RECEIVING_T3 + nvl(od.REMAINQTTY, 0) +
                       nvl(sdtl_wft.wft_receiving, 0) > 0
                   and SDTL.CUSTODYCD like  V_CUSTODYCD)
         where 1 = 1
         group by ACCTNO, (BASICPRICE- COSTPRICE)*100/(COSTPRICE+0.00001)) group by acctno)  ln,
       afmast af,
       cfmast cf
 where af.custid = cf.custid
   and cf.custodycd like  V_CUSTODYCD
   and odt.CIACCTNO(+) = af.acctno
   and cit.acctno(+) = af.acctno
   and ln.ACCTNO(+) = af.acctno
   and cf.dateofbirth >= to_date( F_DATEBRID  , 'dd/MM/rrrr')
   and cf.dateofbirth <= to_date( T_DATEBRID  , 'dd/MM/rrrr')
   and LS >= v_dc
   AND AF.CAREBY IN
       (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = V_TLID)
   and (nvl(odt.tongmua, 0) != 0 or nvl(odt.tongban, 0) != 0 or
       nvl(cit.noptien, 0) != 0 or nvl(cit.ruttien, 0) != 0)

 group by cf.custodycd,
          af.acctno,
          cf.fullname,
          cf.mobile,
          -- refullname,
          cf.dateofbirth,
         ln.PROFITANDLOSS ,
          ln.ls ;

    else
      if (LN_YN = 'N' and V_LN_RATE != 'ALL') then
        -- neu la lo
         OPEN p_REFCURSOR FOR
         select cf.custodycd,
       af.acctno,
       cf.fullname,
       cf.mobile,
       (select max(cf.fullname) refullname
          from reaflnk re, sysvar sys, cfmast cf, RETYPE
         where to_date(varvalue, 'DD/MM/RRRR') between re.frdate and
               re.todate
           and substr(re.reacctno, 0, 10) = cf.custid
           and varname = 'CURRDATE'
           and grname = 'SYSTEM'
           and re.status <> 'C'
           and re.deltd <> 'Y'
           AND substr(re.reacctno, 11) = RETYPE.ACTYPE
           AND rerole IN ('RM', 'BM')
           and re.afacctno = af.acctno) tlfullname,
       cf.dateofbirth,
       max(nvl(ln.PROFITANDLOSS,0)) PROFITANDLOSS,
       max(nvl(ln.LS,0)) LS,
       max(nvl(odt.tongmua,0)) tongmua,
       max(nvl(odt.tongban,0)) tongban,
       max(nvl(cit.noptien,0)) noptien,
       max(nvl(cit.ruttien,0)) ruttien

  from (
 select sum(TONGMUA) TONGMUA, sum(TONGBAN) TONGBAN, ciacctno
  from
  (select (CASE
                 WHEN OD.EXECTYPE in ('NB') THEN
                  sum(OD.EXECAMT + OD.FEEAMT)
                 ELSE
                  0
               END) TONGMUA,
               (case
                 WHEN OD.EXECTYPE IN ('NS', 'MS') THEN
                  sum(OD.EXECAMT + OD.FEEAMT + OD.TAXSELLAMT)
                 ELSE
                  0
               END) TONGBAN,
               OD.CIACCTNO

          FROM VW_ODMAST_ALL OD, afmast a, cfmast c
         WHERE OD.ORSTATUS IN ('4', '5', '7', '12')
           AND OD.EXECQTTY > 0
           and od.TXDATE >= to_date(F_DATE, 'dd/MM/yyyy')
           and od.TXDATE <= to_date(T_DATE, 'dd/MM/yyyy')
           and od.AFACCTNO = a.acctno
           and a.custid = c.custid
           and c.custodycd like V_CUSTODYCD
         Group by OD.CIACCTNO, OD.EXECTYPE
         order by OD.CIACCTNO) group by ciacctno) odt,
        ( select sum(NOPTIEN) NOPTIEN, sum(RUTTIEN) RUTTIEN, acctno from

           (select (CASE
                 WHEN ci.txtype in ('C') and
                      ci.tltxcd in ('1131',
                                    '1141',
                                    '1137',
                                    '1138',
                                    '3350', -- 3342 = (3350.3354)
                                    '3354',
                                    '1120',
                                    '1188',
                                    '1130') THEN
                  sum(CI.namt)
                 ELSE
                  0
               END) NOPTIEN,
               (case
                 WHEN ci.txtype in ('D') and
                      ci.tltxcd in ('1132',
                                    '1188',
                                    '1184',
                                    '1130',
                                    '1101',
                                    '1133',
                                    '1111',
                                    '1185',
                                    '1120') then
                  sum(CI.namt)
                 ELSE
                  0
               END) RUTTIEN

              ,
               ci.acctno

          FROM vw_citran_gen ci
         WHERE ci.field = 'BALANCE'
           and ci.TXDATE >= to_date(F_DATE, 'dd/MM/rrrr')
           and ci.TXDATE <= to_date(T_DATE, 'dd/MM/rrrr')
           and ci.tltxcd in ('1132',   '1188','1184',   '1130',   '1101', '1133','1111','1185',  '1120','1131',
                                    '1141',
                                    '1137',
                                    '1138',
                                    '3350', -- 3342 = (3350.3354)
                                    '3354',
                                    '1120',
                                    '1188',
                                    '1130')
           and ci.custodycd like  V_CUSTODYCD
         group by ci.txtype, ci.acctno, ci.tltxcd
         --order by ci.acctno
         )

         group by acctno) cit,
      ( select acctno, sum(PROFITANDLOSS) PROFITANDLOSS,CASE WHEN sum(ls)>0 THEN  round(sum(PROFITANDLOSS) *100/sum(ls),2) ELSE 0 END  ls from
       (select ACCTNO,
               SUM((basicprice - costprice) *
                   (trunc(trade) + trunc(secured) + receiving_right +
                   receiving_t1 + receiving_t2 + receiving_t3)) PROFITANDLOSS,

               SUM(  costprice *
                       (trunc(trade) + trunc(secured) + receiving_right +
                       receiving_t1 + receiving_t2 + receiving_t3)  ) LS


                   /*sum((BASICPRICE- COSTPRICE)*100/(COSTPRICE+0.00001)) LS*/
          from (SELECT SDTL.AFACCTNO ACCTNO,
                       sdtl.CUSTODYCD,
                       SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY +
                       SDTL.ABSTANDING + SDTL.BLOCKED TRADE,
                       nvl(od.REMAINQTTY, 0) secured,
                       CASE
                         WHEN nvl(stif.closeprice, 0) > 0 THEN
                          stif.closeprice
                         ELSE
                          SEC.BASICPRICE
                       END BASICPRICE,
                       round((round(sdtl.COSTPRICE) -- gia_von_ban_dau ,
                             * (SDTL.TRADE + SDTL.DFTRADING +
                             SDTL.RESTRICTQTTY + SDTL.ABSTANDING +
                             SDTL.BLOCKED + SDTL.RECEIVING +
                             nvl(sdtl_wft.wft_receiving, 0) +
                             sdtl.secured) --tong_kl
                             + nvl(od.B_execamt, 0) --gia_tri_mua --gia tri khop mua
                             ) /
                             (SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY +
                             SDTL.ABSTANDING + SDTL.BLOCKED +
                             nvl(sdtl_wft.wft_receiving, 0) + sdtl.secured +
                             SDTL.RECEIVING + nvl(od.B_EXECQTTY, 0) +
                             0.000001)) as COSTPRICE,
                       SDTL.RECEIVING - SDTL.SECURITIES_RECEIVING_T1 -
                       SDTL.SECURITIES_RECEIVING_T2 +
                       nvl(sdtl_wft.wft_receiving, 0) RECEIVING_RIGHT,
                       SDTL.SECURITIES_RECEIVING_T1 receiving_t1,
                       SDTL.SECURITIES_RECEIVING_T2 receiving_t2,
                       SDTL.SECURITIES_RECEIVING_T3 receiving_t3

                  FROM SBSECURITIES    SB,
                       SECURITIES_INFO SEC,
                       BUF_SE_ACCOUNT  SDTL
                  LEFT JOIN (SELECT TO_NUMBER(closeprice) closeprice, symbol
                              from stockinfor
                             WHERE tradingdate =
                                   to_char(getcurrdate, 'dd/mm/yyyy')) stif
                    ON SDTL.symbol = stif.symbol
                  left join (select seacctno,
                                   sum(o.remainqtty) remainqtty,
                                   sum(decode(o.exectype, 'NB', o.execamt, 0)) B_execamt,
                                   sum(decode(o.exectype, 'NB', o.execqtty, 0)) B_execqtty
                              from odmast o
                             where deltd <> 'Y'
                               and o.exectype in ('NS', 'NB', 'MS')
                               and o.txdate =
                                   (select to_date(VARVALUE, 'DD/MM/YYYY')
                                      from sysvar
                                     where grname = 'SYSTEM'
                                       and varname = 'CURRDATE')
                             group by seacctno) OD
                    on sdtl.acctno = od.seacctno
                  left join (select afacctno,
                                   refcodeid,
                                   trade + receiving -
                                   SECURITIES_RECEIVING_T1 -
                                   SECURITIES_RECEIVING_T2 wft_receiving
                              from buf_se_account sdtl, sbsecurities sb
                             where sdtl.codeid = sb.codeid
                               and sb.refcodeid is not null) sdtl_wft
                    on sdtl.codeid = sdtl_wft.refcodeid
                   and sdtl.afacctno = sdtl_wft.afacctno
                 WHERE SB.CODEID = SDTL.CODEID
                   and sb.refcodeid is null
                   AND SDTL.CODEID = SEC.CODEID
                   and SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY +
                       SDTL.ABSTANDING + SDTL.BLOCKED + SDTL.receiving +
                       SDTL.SECURITIES_RECEIVING_T3 + nvl(od.REMAINQTTY, 0) +
                       nvl(sdtl_wft.wft_receiving, 0) > 0
                   and SDTL.CUSTODYCD like  V_CUSTODYCD)
         where 1 = 1
         group by ACCTNO, (BASICPRICE- COSTPRICE)*100/(COSTPRICE+0.00001)) group by acctno)  ln,
       afmast af,
       cfmast cf
 where af.custid = cf.custid
   and cf.custodycd like  V_CUSTODYCD
   and odt.CIACCTNO(+) = af.acctno
   and cit.acctno(+) = af.acctno
   and ln.ACCTNO(+) = af.acctno
   and cf.dateofbirth >= to_date( F_DATEBRID  , 'dd/MM/rrrr')
   and cf.dateofbirth <= to_date( T_DATEBRID  , 'dd/MM/rrrr')
   and abs(LS) >= v_dc
   and LS <0
   AND AF.CAREBY IN
       (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = V_TLID)
   and (nvl(odt.tongmua, 0) != 0 or nvl(odt.tongban, 0) != 0 or
       nvl(cit.noptien, 0) != 0 or nvl(cit.ruttien, 0) != 0)

 group by cf.custodycd,
          af.acctno,
          cf.fullname,
          cf.mobile,
          -- refullname,
          cf.dateofbirth,
         ln.PROFITANDLOSS ,
          ln.ls ;
      else
        if ((LN_YN = 'Y' or LN_YN = 'N') and V_LN_RATE = 'ALL') then
          -- neu khong check lai lo
          OPEN p_REFCURSOR FOR
         select cf.custodycd,
       af.acctno,
       cf.fullname,
       cf.mobile,
       (select max(cf.fullname) refullname
          from reaflnk re, sysvar sys, cfmast cf, RETYPE
         where to_date(varvalue, 'DD/MM/RRRR') between re.frdate and
               re.todate
           and substr(re.reacctno, 0, 10) = cf.custid
           and varname = 'CURRDATE'
           and grname = 'SYSTEM'
           and re.status <> 'C'
           and re.deltd <> 'Y'
           AND substr(re.reacctno, 11) = RETYPE.ACTYPE
           AND rerole IN ('RM', 'BM')
           and re.afacctno = af.acctno) tlfullname,
       cf.dateofbirth,
       max(nvl(ln.PROFITANDLOSS,0)) PROFITANDLOSS,
       max(nvl(ln.LS,0)) LS,
       max(nvl(odt.tongmua,0)) tongmua,
       max(nvl(odt.tongban,0)) tongban,
       max(nvl(cit.noptien,0)) noptien,
       max(nvl(cit.ruttien,0)) ruttien

  from (
 select sum(TONGMUA) TONGMUA, sum(TONGBAN) TONGBAN, ciacctno
  from
  (select (CASE
                 WHEN OD.EXECTYPE in ('NB') THEN
                  sum(OD.EXECAMT + OD.FEEAMT)
                 ELSE
                  0
               END) TONGMUA,
               (case
                 WHEN OD.EXECTYPE IN ('NS', 'MS') THEN
                  sum(OD.EXECAMT + OD.FEEAMT + OD.TAXSELLAMT)
                 ELSE
                  0
               END) TONGBAN,
               OD.CIACCTNO

          FROM VW_ODMAST_ALL OD, afmast a, cfmast c
         WHERE OD.ORSTATUS IN ('4', '5', '7', '12')
           AND OD.EXECQTTY > 0
           and od.TXDATE >= to_date(F_DATE, 'dd/MM/yyyy')
           and od.TXDATE <= to_date(T_DATE, 'dd/MM/yyyy')
           and od.AFACCTNO = a.acctno
           and a.custid = c.custid
           and c.custodycd like V_CUSTODYCD
         Group by OD.CIACCTNO, OD.EXECTYPE
         order by OD.CIACCTNO) group by ciacctno) odt,
        ( select sum(NOPTIEN) NOPTIEN, sum(RUTTIEN) RUTTIEN, acctno from

           (select (CASE
                 WHEN ci.txtype in ('C') and
                      ci.tltxcd in ('1131',
                                    '1141',
                                    '1137',
                                    '1138',
                                    '3350', -- 3342 = (3350.3354)
                                    '3354',
                                    '1120',
                                    '1188',
                                    '1130') THEN
                  sum(CI.namt)
                 ELSE
                  0
               END) NOPTIEN,
               (case
                 WHEN ci.txtype in ('D') and
                      ci.tltxcd in ('1132',
                                    '1188',
                                    '1184',
                                    '1130',
                                    '1101',
                                    '1133',
                                    '1111',
                                    '1185',
                                    '1120') then
                  sum(CI.namt)
                 ELSE
                  0
               END) RUTTIEN

              ,
               ci.acctno

          FROM vw_citran_gen ci
         WHERE ci.field = 'BALANCE'
           and ci.TXDATE >= to_date(F_DATE, 'dd/MM/rrrr')
           and ci.TXDATE <= to_date(T_DATE, 'dd/MM/rrrr')
           and ci.tltxcd in ('1132',   '1188','1184',   '1130',   '1101', '1133','1111','1185',  '1120','1131',
                                    '1141',
                                    '1137',
                                    '1138',
                                    '3350', -- 3342 = (3350.3354)
                                    '3354',
                                    '1120',
                                    '1188',
                                    '1130')
           and ci.custodycd like  V_CUSTODYCD
         group by ci.txtype, ci.acctno, ci.tltxcd
         --order by ci.acctno
         )

         group by acctno) cit,
      ( select acctno, sum(PROFITANDLOSS) PROFITANDLOSS, CASE WHEN sum(ls)>0 THEN  round(sum(PROFITANDLOSS) *100/sum(ls),0) ELSE 0 END  ls from
       (select ACCTNO,
               SUM((basicprice - costprice) *
                   (trunc(trade) + trunc(secured) + receiving_right +
                   receiving_t1 + receiving_t2 + receiving_t3)) PROFITANDLOSS,

               SUM(  costprice *
                       (trunc(trade) + trunc(secured) + receiving_right +
                       receiving_t1 + receiving_t2 + receiving_t3)  ) LS


                   /*sum((BASICPRICE- COSTPRICE)*100/(COSTPRICE+0.00001)) LS*/
          from (SELECT SDTL.AFACCTNO ACCTNO,
                       sdtl.CUSTODYCD,
                       SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY +
                       SDTL.ABSTANDING + SDTL.BLOCKED TRADE,
                       nvl(od.REMAINQTTY, 0) secured,
                       CASE
                         WHEN nvl(stif.closeprice, 0) > 0 THEN
                          stif.closeprice
                         ELSE
                          SEC.BASICPRICE
                       END BASICPRICE,
                       round((round(sdtl.COSTPRICE) -- gia_von_ban_dau ,
                             * (SDTL.TRADE + SDTL.DFTRADING +
                             SDTL.RESTRICTQTTY + SDTL.ABSTANDING +
                             SDTL.BLOCKED + SDTL.RECEIVING +
                             nvl(sdtl_wft.wft_receiving, 0) +
                             sdtl.secured) --tong_kl
                             + nvl(od.B_execamt, 0) --gia_tri_mua --gia tri khop mua
                             ) /
                             (SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY +
                             SDTL.ABSTANDING + SDTL.BLOCKED +
                             nvl(sdtl_wft.wft_receiving, 0) + sdtl.secured +
                             SDTL.RECEIVING + nvl(od.B_EXECQTTY, 0) +
                             0.000001)) as COSTPRICE,
                       SDTL.RECEIVING - SDTL.SECURITIES_RECEIVING_T1 -
                       SDTL.SECURITIES_RECEIVING_T2 +
                       nvl(sdtl_wft.wft_receiving, 0) RECEIVING_RIGHT,
                       SDTL.SECURITIES_RECEIVING_T1 receiving_t1,
                       SDTL.SECURITIES_RECEIVING_T2 receiving_t2,
                       SDTL.SECURITIES_RECEIVING_T3 receiving_t3

                  FROM SBSECURITIES    SB,
                       SECURITIES_INFO SEC,
                       BUF_SE_ACCOUNT  SDTL
                  LEFT JOIN (SELECT TO_NUMBER(closeprice) closeprice, symbol
                              from stockinfor
                             WHERE tradingdate =
                                   to_char(getcurrdate, 'dd/mm/yyyy')) stif
                    ON SDTL.symbol = stif.symbol
                  left join (select seacctno,
                                   sum(o.remainqtty) remainqtty,
                                   sum(decode(o.exectype, 'NB', o.execamt, 0)) B_execamt,
                                   sum(decode(o.exectype, 'NB', o.execqtty, 0)) B_execqtty
                              from odmast o
                             where deltd <> 'Y'
                               and o.exectype in ('NS', 'NB', 'MS')
                               and o.txdate =
                                   (select to_date(VARVALUE, 'DD/MM/YYYY')
                                      from sysvar
                                     where grname = 'SYSTEM'
                                       and varname = 'CURRDATE')
                             group by seacctno) OD
                    on sdtl.acctno = od.seacctno
                  left join (select afacctno,
                                   refcodeid,
                                   trade + receiving -
                                   SECURITIES_RECEIVING_T1 -
                                   SECURITIES_RECEIVING_T2 wft_receiving
                              from buf_se_account sdtl, sbsecurities sb
                             where sdtl.codeid = sb.codeid
                               and sb.refcodeid is not null) sdtl_wft
                    on sdtl.codeid = sdtl_wft.refcodeid
                   and sdtl.afacctno = sdtl_wft.afacctno
                 WHERE SB.CODEID = SDTL.CODEID
                   and sb.refcodeid is null
                   AND SDTL.CODEID = SEC.CODEID
                   and SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY +
                       SDTL.ABSTANDING + SDTL.BLOCKED + SDTL.receiving +
                       SDTL.SECURITIES_RECEIVING_T3 + nvl(od.REMAINQTTY, 0) +
                       nvl(sdtl_wft.wft_receiving, 0) > 0
                   and SDTL.CUSTODYCD like  V_CUSTODYCD)
         where 1 = 1
         group by ACCTNO, (BASICPRICE- COSTPRICE)*100/(COSTPRICE+0.00001)) group by acctno)  ln,
       afmast af,
       cfmast cf
 where af.custid = cf.custid
   and cf.custodycd like  V_CUSTODYCD
   and odt.CIACCTNO(+) = af.acctno
   and cit.acctno(+) = af.acctno
   and ln.ACCTNO(+) = af.acctno
   and cf.dateofbirth >= to_date( F_DATEBRID  , 'dd/MM/rrrr')
   and cf.dateofbirth <= to_date( T_DATEBRID  , 'dd/MM/rrrr')
   AND AF.CAREBY IN
       (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = V_TLID)
   and (nvl(odt.tongmua, 0) != 0 or nvl(odt.tongban, 0) != 0 or
       nvl(cit.noptien, 0) != 0 or nvl(cit.ruttien, 0) != 0)
 group by cf.custodycd,
          af.acctno,
          cf.fullname,
          cf.mobile,
          -- refullname,
          cf.dateofbirth,
         ln.PROFITANDLOSS ,
          ln.ls;
/* odt.tongmua ,
 odt.tongban,
 cit.noptien ,
cit.ruttien */
-- order by af.acctno, cf.fullname)
        end if;
      end if;
    end if;
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'pr_GetGTCOrder');
  END pr_GetAccount;

 PROCEDURE pr_GetCustomRightoffList
(
    P_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
    P_CUSTODYCD     IN      VARCHAR2,
    P_FULLNAME      IN      VARCHAR2,
    P_CATYPE        IN      VARCHAR2,
    P_SYMBOL        IN      VARCHAR2,
    PV_TLID         IN      VARCHAR2
)
IS
    V_CUSTODYCD     VARCHAR2(10);
    V_FULLNAME      VARCHAR2(100);
    V_CATYPE        VARCHAR2(10);
    V_SYMBOL        VARCHAR2(10);
    V_TLID          VARCHAR2(10);

BEGIN

    V_TLID := PV_TLID;

    IF P_CUSTODYCD = 'ALL' THEN
        V_CUSTODYCD := '%';
    ELSE
        V_CUSTODYCD := P_CUSTODYCD;
    END IF;
    --------
    IF P_FULLNAME = 'ALL' THEN
        V_FULLNAME := '%';
    ELSE
        V_FULLNAME := '%'||UPPER(P_FULLNAME)||'%';
    END IF;
    --------
    IF P_CATYPE = 'ALL' THEN
        V_CATYPE := '%';
    ELSE
        V_CATYPE := P_CATYPE;
    END IF;
    --------
    IF P_SYMBOL = 'ALL' THEN
        V_SYMBOL := '%';
    ELSE
        V_SYMBOL := P_SYMBOL;
    END IF;
    --------

OPEN P_REFCURSOR FOR

SELECT cf.custodycd, af.acctno, cf.fullname, a1.cdcontent catype, ca.camastid, sb.symbol, ca.description,
    ca.reportdate, CASE WHEN ca.catype IN ('014') THEN (cs.pqtty)
                        WHEN ca.catype IN ('023') THEN cs.pqtty ELSE cs.qtty END qtty,
    cs.amt, CASE WHEN ca.catype IN ('023','014') THEN cs.qtty ELSE 0 END balance, CASE WHEN ca.catype = '014' THEN ca.exprice ELSE 0 END exprice
FROM camast ca, cfmast cf, afmast af, (SELECT * FROM caschd UNION ALL SELECT * FROM caschdhist) cs, sbsecurities sb, allcode a1
WHERE cf.custid = af.custid AND af.acctno = cs.afacctno
    AND ca.camastid = cs.camastid AND ca.status IN ('S', 'W', 'I', 'M', 'J', 'I', 'H', 'V')
    AND ca.catype = a1.cdval AND a1.cdname = 'CATYPE'
    AND ca.catype NOT IN ('019','002') AND nvl(ca.tocodeid,ca.codeid) = sb.codeid
    AND ca.catype LIKE V_CATYPE
    AND sb.symbol LIKE V_SYMBOL
    AND cf.custodycd LIKE V_CUSTODYCD
    AND upper(cf.fullname) LIKE V_FULLNAME
    AND af.careby IN (SELECT tlgrp.grpid FROM tlgrpusers tlgrp WHERE tlid = V_TLID)
    AND cs.qtty + cs.amt + cs.pqtty > 0
ORDER BY cf.custodycd, af.acctno, ca.reportdate

;
EXCEPTION
  WHEN OTHERS THEN
    RETURN;
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GetCustomRightoffList');
END pr_GetCustomRightoffList;

PROCEDURE pr_updatepasspinonline(p_username IN varchar,
                              P_password   IN varchar2,
                              P_pin       IN   varchar2,
                              p_err_code  OUT varchar2,
                              p_err_message out varchar2,
                              p_via  IN varchar2 default 'A')
 IS
      v_mobile varchar2(20);
      l_datasourcesms varchar2(1000);
      l_check NUMBER;
      l_countpin NUMBER;
      l_countpass NUMBER;
      l_authtype     NUMBER;
      l_via       varchar2(2);

  BEGIN
    plog.setbeginsection(pkgctx, 'pr_updatepasspinonline');
    l_via := p_via;

    -- Check host & branch active or inactive
    p_err_code := fn_CheckActiveSystem;
    IF p_err_code <> systemnums.C_SUCCESS THEN
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_updatepasspinonline');
        return;
    END IF;

    --1.5.3.0: check loai hinh xac thuc ---> co can check PIN khong
    select to_number(max(o.authtype))into l_authtype
    from otright o, cfmast c
    where o.cfcustid = o.authcustid and o.cfcustid = c.custid
          and o.deltd = 'N' and o.via in ('A','p_via')
          and getcurrdate between o.valdate and o.expdate
          and c.username = p_username;


    v_mobile:='';
     For vc in (select mobile
                         from cfmast where username=p_username )
     Loop
                         v_mobile:=vc.mobile;
     End loop;

    IF fn_checkPass(P_password) <> 0 THEN
        p_err_code := -901211;
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_updatepasspinonline');
        return;
    END IF;
    --1.5.3.0
    IF (l_authtype = 0 and fn_checkPass(P_pin) <> 0 )THEN
        p_err_code := -901212;
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_updatepasspinonline');
        return;
    END IF;

    --check pass cu moi giong nhau
    SELECT count(*) INTO l_countpass FROM userlogin u WHERE username = p_username AND u.loginpwd = genencryptpassword(P_password);
    IF l_countpass > 0 THEN
        p_err_code := -901213;
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_updatepasspinonline');
        return;
    END IF;
    --check pain cu moi giong nhau
    --1.5.3.0
    if(l_authtype = 0) then
    SELECT count(*) INTO l_countpin FROM userlogin u WHERE username = p_username AND u.tradingpwd = genencryptpassword(P_pin);
      IF l_countpin > 0 THEN
          p_err_code := -901214;
          p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
          plog.error(pkgctx, 'Error:'  || p_err_message);
          plog.setendsection(pkgctx, 'pr_updatepasspinonline');
          return;
      END IF;
    end if;

    Update userlogin
    Set LOGINPWD= genencryptpassword(P_password),
    isreset='N',
    lastchanged = sysdate
    where username = p_username;
    If length(v_mobile)>1 then
            --l_datasourcesms:='select ''MSBS thong bao: Mat khau dang nhap cua so tai khoan '||p_username||' la: '||P_password||''' detail from dual';
            l_datasourcesms:='select ''Quy khach hang da doi thanh cong mat khau dang nhap vao luc '||TO_CHAR(SYSDATE,'HH24:MI')||' ngay '||to_char(sysdate,'dd/mm/yyyy')||''' detail from dual';
            nmpks_ems.InsertEmailLog(v_mobile, '0335', l_datasourcesms, '');
    End if;
    --1.5.3.0
    if(l_authtype = 0) then
        Update userlogin
        Set TRADINGPWD= genencryptpassword(P_pin),
        isreset='N',
        lastchanged = sysdate
        where username = p_username;
        If length(v_mobile)>1 then
                --l_datasourcesms:='select ''MSBS thong bao: PIN cua so tai khoan '||p_username||' la: '||P_password||''' detail from dual';
                l_datasourcesms:='select ''Quy khach hang da doi thanh cong mat khau xac thuc/PIN vao luc '||TO_CHAR(SYSDATE,'HH24:MI')||' ngay '||to_char(sysdate,'dd/mm/yyyy')||''' detail from dual';
                nmpks_ems.InsertEmailLog(v_mobile, '0335', l_datasourcesms, '');
        End if;
    end if;

    --cap nhat lai ngay het han khi co thay doi pass, pin online
    UPDATE userlogin SET expdate = getcurrdate + (SELECT to_number(varvalue) FROM sysvar WHERE varname = 'EXPDATEPASSONLINE') WHERE username = p_username;
    COMMIT;

    --End cap nhat lai ngay het han khi co thay doi pass, pin online
    p_err_code:='0';
    plog.setendsection(pkgctx, 'pr_updatepasspinonline');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_updatepasspinonline');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_updatepasspinonline');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_updatepasspinonline;

--1.5.3.0
PROCEDURE GET_MODULE_PERMISSION(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR, pv_strCUSTID IN VARCHAR2, pv_strVIA IN VARCHAR2 DEFAULT 'A') is
v_count number;
v_via   varchar2(10);
BEGIN
    plog.setbeginsection(pkgctx, 'GET_MODULE_PERMISSION');
    if(pv_strVIA <> 'A')  then
    OPEN p_REFCURSOR FOR
      SELECT  o.via, D.AUTOID,D.AUTHCUSTID,D.OTMNCODE,D.DELTD,
              D.OTRIGHT,AF.ACCTNO AFACCTNO,o.serialnumsig,
              (case when substr(D.OTRIGHT, 5, 3) = 'YNN' THEN '0'
               when substr(D.OTRIGHT, 5, 3) = 'NYN' THEN '1'
               when substr(D.OTRIGHT, 5, 3) ='NNY' THEN '4'
              else '' end ) AUTHTYPE

       FROM ( select authcustid, cfcustid ,max(via) via , max(serialnumsig) serialnumsig
              from otright
              where deltd <> 'Y' AND getcurrdate <= EXPDATE AND via IN ('A', pv_strVIA)
               group by authcustid, cfcustid) O, OTRIGHTDTL D, afmast af
        WHERE O.AUTHCUSTID = D.AUTHCUSTID AND O.cfcustid = D.cfcustid
              AND D.DELTD = 'N'
              AND O.AUTHCUSTID = pv_strCUSTID
              AND O.cfcustid=af.custid
              AND o.via = d.via  ;
    else
      OPEN p_REFCURSOR FOR
      SELECT  o.via,D.AUTOID,D.AUTHCUSTID,D.OTMNCODE,D.DELTD,
              D.OTRIGHT,AF.ACCTNO AFACCTNO,O.AUTHTYPE,o.serialnumsig
          FROM OTRIGHT O, OTRIGHTDTL D, afmast af
          WHERE O.AUTHCUSTID = D.AUTHCUSTID
      AND O.cfcustid = D.cfcustid
      AND o.via= d.via
          AND D.DELTD = 'N' AND O.DELTD = 'N'
          AND O.AUTHCUSTID = pv_strCUSTID
      AND o.cfcustid=af.custid
          AND o.via = 'A'
          AND o.deltd = 'N'
          AND getcurrdate <= O.EXPDATE;
    end if;
    plog.setendsection(pkgctx, 'GET_MODULE_PERMISSION');
EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'GET_MODULE_PERMISSION');
END GET_MODULE_PERMISSION;
PROCEDURE pr_GETCONTRACTLIST(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                             pv_strCUSTID IN VARCHAR2,
                             pv_strVIA IN VARCHAR2 DEFAULT 'A')
  IS

BEGIN
   OPEN p_REFCURSOR FOR
     SELECT 1 OWNER,AF.ACCTNO,AF.Fax1,AF.Email,CF.CUSTODYCD,AF.CUSTID,CF.FULLNAME,'YYYYYYYYYY' LINKAUTH,AF.BANKACCTNO,
              AF.BANKNAME,CI.COREBANK,AF.STATUS,'' TYPENAME, AFT.TYPENAME AFTYPE,
              'N'  EXPIRED, AF.TRADEONLINE, R.SERIALNUMSIG SERIAL, R.VIA, R.authtype
                FROM (select authcustid, cfcustid,max(via) via , max(serialnumsig) serialnumsig, max(authtype) authtype
                      from otright
                      where deltd <> 'Y'
                      and VALDATE <= getcurrdate  AND getcurrdate <= EXPDATE
                      and authcustid = cfcustid
                       AND via IN ('A', pv_strVIA)
                      group by authcustid, cfcustid) R, AFMAST AF,CFMAST CF,CIMAST CI, AFTYPE AFT
                WHERE AF.CUSTID=CF.CUSTID
                AND AF.ACCTNO=CI.AFACCTNO
                AND AF.ACTYPE=AFT.ACTYPE
                AND R.CFCUSTID = CF.CUSTID
                AND r.authcustid= pv_strCUSTID
        UNION ALL
         SELECT 0 OWNER,AF.ACCTNO,AF.Fax1,AF.Email,CF.CUSTODYCD,CF.CUSTID,CF.FULLNAME,'NNNNNNNNNN' LINKAUTH,AF.BANKACCTNO,
                AF.BANKNAME,CI.COREBANK,AF.STATUS, '' TYPENAME, AFT.TYPENAME AFTYPE,
               'N'  EXPIRED, AF.TRADEONLINE, R.SERIALNUMSIG SERIAL, R.VIA, R.authtype
                FROM (select authcustid, cfcustid,max(via) via , max(serialnumsig) serialnumsig, max(authtype) authtype
                      from otright
                      where deltd <> 'Y'
            and VALDATE <= getcurrdate AND getcurrdate <= EXPDATE
            AND via IN ('A', pv_strVIA) and  authcustid <> cfcustid
                      group by authcustid, cfcustid) R, AFMAST AF, CFMAST CF, CIMAST CI, AFTYPE AFT
                WHERE AF.CUSTID=CF.CUSTID
                AND AF.ACCTNO=CI.AFACCTNO
                AND AF.ACTYPE=AFT.ACTYPE
               AND R.CFCUSTID = CF.CUSTID
               AND R.authcustid = pv_strCUSTID
          ORDER BY OWNER DESC;

EXCEPTION
  WHEN OTHERS THEN
    NULL;
END;

--1.5.8.9
PROCEDURE pr_GET_ACCOUNT_INFO_T0
    (p_REFCURSOR    IN OUT PKG_REPORT.REF_CURSOR,
     PV_CUSTODYCD   IN VARCHAR2,
     p_AFACCTNO       IN  VARCHAR2,
     p_TLID         IN VARCHAR2
    )
IS
    l_margintype char(1);
    l_deal      VARCHAR2(2);
    l_advanceline number(20,4);
    l_advanceline1 number(20,4);
    l_t0loanrate   NUMBER;
    l_custid VARCHAR2(10);
    v_pp NUMBER(20,4);

    l_acctno VARCHAR2(10);
BEGIN
    IF p_AFACCTNO = 'ALL' OR p_AFACCTNO IS NULL THEN
      l_acctno := '%%';
    ELSE
      l_acctno := p_AFACCTNO;
    END IF;

BEGIN
    SELECT mr.mrtype, mst.deal, cf.t0loanrate, mst.advanceline, cf.custid
        INTO l_margintype, l_deal, l_t0loanrate, l_advanceline, l_custid
        FROM afmast mst, aftype af, mrtype mr, cfmast cf
       WHERE mst.actype = af.actype
         AND af.mrtype = mr.actype
         AND mst.custid = cf.custid
         AND mst.acctno = p_AFACCTNO;
EXCEPTION
  WHEN OTHERS THEN
    l_margintype := 'T';
    l_deal := 'Y';
    l_t0loanrate := 0;
    l_advanceline := 0;
    l_custid := '';
END;

    IF l_deal = 'N' THEN
        SELECT sum(ROUND(least(nvl((ci.balance-NVL(b.secureamt,0)) + NVL(ADV.avladvance,0) + v_getsec.senavamt -
                              NVL(ci.ovamt,0),0) * l_t0loanrate /100
                         ,nvl(v_getsec.SELIQAMT2,0)))),
              sum(round(
                  nvl(adv.avladvance,0) + nvl(balance,0) - nvl(odamt,0) - nvl(dfdebtamt,0) - nvl(dfintdebtamt,0) - nvl (advamt, 0)- nvl(secureamt,0) +
                  CASE WHEN l_deal = 'N' THEN greatest(ROUND(least(nvl((ci.balance-NVL(b.secureamt,0)) + NVL(ADV.avladvance,0) + v_getsec.senavamt -
                      NVL(ci.ovamt,0),0) * l_t0loanrate /100,nvl(v_getsec.SELIQAMT2,0))),0) ELSE af.advanceline END
                  - nvl(trft0amt,0) - nvl(trft0addamt,0) -nvl(trfsecuredamt,0) - nvl(ramt,0) - ci.depofeeamt + least(af.mrcrlimitmax +af.mrcrlimit- ci.dfodamt,af.mrcrlimit)
              ,0)) PP
        INTO l_advanceline1,v_pp
        from cimast ci inner join afmast af on ci.acctno=af.acctno
        left join
        (select * from v_getbuyorderinfo/* where afacctno = p_AFACCTNO*/) b
        on  ci.acctno = b.afacctno
        LEFT JOIN
        (select sum(depoamt) avladvance, sum(paidamt) paidamt, sum(advamt) advanceamount,afacctno, sum(aamt) aamt from v_getAccountAvlAdvance /*where afacctno = p_AFACCTNO */group by afacctno) adv
        on adv.afacctno=ci.acctno
        LEFT JOIN
        (SELECT * FROM v_getsecmargininfo_ALL) v_getsec
        ON ci.acctno = v_getsec.afacctno
        WHERE ci.custid = l_custid AND ci.acctno LIKE l_acctno;

        l_advanceline := greatest(least(l_advanceline,l_advanceline1),0);

    END IF;

    OPEN p_REFCURSOR FOR
        SELECT CI.CUSTODYCD, NVL(SUM(CASE WHEN l_margintype = 'N' THEN v_pp ELSE CI.PP END),0)PP,
        SUM(CI.BALANCE) BALANCE, SUM(CI.AAMT) AAMT,NVL(SUM(CI.ODAMT + CI.DFODAMT),0) OUTSTANDING,
        l_advanceline AVLADVANCE,
        MAX(CI.AUTOADV) AUTOADV, SUM(CI.ADVANCELINE) ADVANCELINE,
        MAX(CI.ACCOUNTTYPE) ACCOUNTTYPE, NVL(SUM(EXECBUYAMT),0) TOTALORDERAMOUNT
        FROM BUF_CI_ACCOUNT CI
        WHERE CI.CUSTODYCD = pv_CUSTODYCD
        AND CI.AFACCTNO LIKE p_AFACCTNO
        AND CI.CAREBY IN (SELECT GRPID FROM TLGRPUSERS WHERE TLID LIKE p_TLID)
        GROUP BY CI.CUSTODYCD;

EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GET_ACCOUNT_INFO_T0');
END pr_GET_ACCOUNT_INFO_T0;


PROCEDURE pr_inquiry_draft_odgroup
    (p_REFCURSOR    IN OUT PKG_REPORT.REF_CURSOR,
     PV_USERID      IN VARCHAR2
    )
IS
 v_count            number;
 v_userid           varchar2(50);
BEGIN
  plog.setbeginsection(pkgctx, 'pr_inquiry_draft_odgroup');
   v_userid := trim(PV_USERID);

  select count(*) into v_count
  from draft_order_group
  where userid = upper(trim(v_userid))
  and id = 0;

  if v_count = 0 then
    insert into draft_order_group (id, group_name, userid, note)
    select 0 id, 'DEFAULT' group_name, v_userid userid, 'Nhom mac dinh' note
    from dual
    where not exists (select * from draft_order_group where id = 0 and userid = upper(trim(v_userid)));
    commit;
  end if;

  OPEN p_REFCURSOR FOR
  select gr.*, case when gr.id = 0 then 'N' else 'Y' end isamend, case when gr.id = 0 then 'N' else 'Y' end isdelete ,
  to_char(gr.id)||'-'||gr.group_name detail
  from draft_order_group gr
  where gr.userid like v_userid and gr.deltd = 'N'
  order by gr.id;

  plog.setendsection(pkgctx, 'pr_inquiry_draft_odgroup');

EXCEPTION
  WHEN OTHERS THEN
    OPEN p_REFCURSOR FOR
    select '-1' errcode, 'Undefined Error!' errmsg
    from dual;
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_inquiry_draft_odgroup');
END pr_inquiry_draft_odgroup;

PROCEDURE pr_add_draft_odgroup
    (PV_USERID      IN VARCHAR2,
     PV_GROUPNAME   IN VARCHAR2,
     PV_NOTE        IN VARCHAR2,
     p_errcode      OUT VARCHAR2,
     p_err_message  OUT VARCHAR2
    )
IS
 v_count            number;
 v_userid           varchar2(50);
BEGIN
  plog.setbeginsection(pkgctx, 'pr_add_draft_odgroup');
  p_errcode := '0';
  p_err_message := '';
  if upper(trim(PV_GROUPNAME)) = 'DEFAULT' then
    p_errcode := '-700005';
    p_err_message:=cspks_system.fn_get_errmsg(p_errcode);
    plog.setendsection(pkgctx, 'pr_add_draft_odgroup');
    return;
  else
    v_count := SEQ_DRAFT_ORDER_GROUP.NEXTVAL;
    insert into draft_order_group(id, group_name, userid, note)
    select v_count id, trim(PV_GROUPNAME) group_name, trim(PV_USERID) userid, substr(PV_NOTE,1,500)
    from dual
    where not exists (select * from draft_order_group where id = v_count and userid = upper(trim(PV_USERID)));
  end if;
  plog.setendsection(pkgctx, 'pr_add_draft_odgroup');
EXCEPTION
  WHEN OTHERS THEN
    p_errcode := '-1';
    p_err_message := 'Undefined Error!';
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_add_draft_odgroup');
END pr_add_draft_odgroup;

PROCEDURE pr_edit_draft_odgroup
    (PV_ID          IN VARCHAR2,
     PV_USERID      IN VARCHAR2,
     PV_GROUPNAME   IN VARCHAR2,
     PV_NOTE        IN VARCHAR2,
     p_errcode      OUT VARCHAR2,
     p_err_message  OUT VARCHAR2
    )
IS
 v_count            number;
 v_userid           varchar2(50);
BEGIN
  plog.setbeginsection(pkgctx, 'pr_edit_draft_odgroup');
  p_errcode := '0';
  p_err_message := '';

  if upper(trim(PV_GROUPNAME)) = 'DEFAULT' then
    p_errcode := '-700005';
    p_err_message:=cspks_system.fn_get_errmsg(p_errcode);
    plog.setendsection(pkgctx, 'pr_edit_draft_odgroup');
    return;
  else
    update draft_order_group set group_name = trim(PV_GROUPNAME), note = substr(PV_NOTE,1,500)
    where userid = trim(PV_USERID) and id = to_number(trim(PV_ID));
  end if;
  plog.setendsection(pkgctx, 'pr_edit_draft_odgroup');
EXCEPTION
  WHEN OTHERS THEN
    p_errcode := '-1';
    p_err_message := 'Undefined Error!';
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_edit_draft_odgroup');
END pr_edit_draft_odgroup;

PROCEDURE pr_delete_draft_odgroup
    (PV_ID          IN VARCHAR2,
     PV_USERID      IN VARCHAR2,
     p_errcode      OUT VARCHAR2,
     p_err_message  OUT VARCHAR2
    )
IS
 v_count            number;
 v_userid           varchar2(50);
BEGIN
  plog.setbeginsection(pkgctx, 'pr_delete_draft_odgroup');
  p_errcode := '0';
  p_err_message := '';

  select count(*) into v_count
  from draft_order od
  where od.order_group = to_number(trim(PV_ID)) and od.userid = trim(PV_USERID) and status not in ('H');
  if v_count > 0 then
    p_errcode := '-700007';
    p_err_message:=cspks_system.fn_get_errmsg(p_errcode);
    plog.setendsection(pkgctx, 'pr_delete_draft_odgroup');
    return;
  else
    update draft_order_group
    set deltd = 'Y'
    where userid = upper(trim(PV_USERID)) and id = to_number(trim(PV_ID));
  end if;

  plog.setendsection(pkgctx, 'pr_delete_draft_odgroup');
EXCEPTION
  WHEN OTHERS THEN
    p_errcode := '-1';
    p_err_message := 'Undefined Error!';
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_delete_draft_odgroup');
END pr_delete_draft_odgroup;

PROCEDURE pr_inquiry_draft_order
    (p_REFCURSOR    IN OUT PKG_REPORT.REF_CURSOR,
     PV_USERID      IN VARCHAR2,
     PV_GROUPID     IN VARCHAR2
    )
IS
 v_count            number;
 v_userid           varchar2(50);
BEGIN
  plog.setbeginsection(pkgctx, 'pr_inquiry_draft_order');

    v_userid := trim(PV_USERID);

  OPEN p_REFCURSOR FOR
  select od.*,
  case when od.status = 'C' then 'Lenh dat thanh cong'
  when od.status = 'E' then od.errmsg
  when od.price < sb.floorprice or od.price >sb.ceilingprice then 'Gia nam ngoai khoang tran san!' else '' end msg,
  case when od.status = 'C' then od.lastordertime else '' end lastordertime
  from draft_order od, securities_info sb
  where od.symbol = sb.symbol
  and od.userid = v_userid
  and (case when trim(PV_GROUPID) is null or trim(PV_GROUPID) = '' then 1 else
  (case when to_number(trim(PV_GROUPID)) = od.order_group then 1 else 0 end) end) > 0
  and od.status in ('P','C','E')
  order by od.autoid;

  plog.setendsection(pkgctx, 'pr_inquiry_draft_order');
EXCEPTION
  WHEN OTHERS THEN
    OPEN p_REFCURSOR FOR
    select '-1' errcode, 'Undefined Error!' errmsg
    from dual;
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_inquiry_draft_order');
END pr_inquiry_draft_order;

PROCEDURE pr_add_draft_order
    (PV_USERID      IN VARCHAR2,
     PV_GROUPID     IN VARCHAR2,
     PV_CUSTODYCD   IN VARCHAR2,
     PV_ACCTNO      IN VARCHAR2,
     PV_EXECTYPE    IN VARCHAR2,
     PV_SYMBOL      IN VARCHAR2,
     PV_PRICE       IN VARCHAR2,
     PV_QTTY        IN VARCHAR2,
     PV_PRICETYPE   IN VARCHAR2,
     p_errcode      OUT VARCHAR2,
     p_err_message  OUT VARCHAR2
    )
IS
 v_count            number;
 v_userid           varchar2(50);
 v_max_order        number;
BEGIN
  plog.setbeginsection(pkgctx, 'pr_add_draft_order');
  p_errcode := '0';
  p_err_message := '';
  select count(*) into v_count
  from draft_order_group
  where userid = trim(PV_USERID) and id = to_number(trim(PV_GROUPID));
  if v_count > 0 then
    select to_number(varvalue) into v_max_order
    from sysvar where varname = 'MAX_DRAFT_ORDERS' and grname = 'SYSTEM';
    select count(*) into v_count
    from draft_order
    where userid = trim(PV_USERID) and order_group = upper(trim(PV_GROUPID)) and status not in ('H','C');
    if v_count + 1 > v_max_order then
      p_errcode := '-700004';
      p_err_message:=cspks_system.fn_get_errmsg(p_errcode);
      plog.setendsection(pkgctx, 'pr_add_draft_order');
      return;
    else
      v_count := SEQ_DRAFT_ORDER.NEXTVAL;
      insert into draft_order(autoid, order_group, userid, acctno, custodycd, txdate, exectype, symbol, qtty, pricetype, price, amt)
      values(v_count, to_number(trim(PV_GROUPID)), trim(PV_USERID), trim(PV_ACCTNO), upper(trim(PV_CUSTODYCD)), getcurrdate,
      upper(trim(PV_EXECTYPE)), upper(trim(PV_SYMBOL)), to_number(trim(PV_QTTY)), upper(trim(PV_PRICETYPE)),
      to_number(trim(PV_PRICE)), to_number(trim(PV_PRICE)) * to_number(trim(PV_QTTY)));

    end if;
  else
    p_errcode := '-700006';
    p_err_message:=cspks_system.fn_get_errmsg(p_errcode);
    plog.setendsection(pkgctx, 'pr_add_draft_order');
    return;
  end if;

  plog.setendsection(pkgctx, 'pr_add_draft_order');
EXCEPTION
  WHEN OTHERS THEN
    p_errcode := '-1';
    p_err_message := 'Undefined Error!';
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_add_draft_order');
END pr_add_draft_order;

PROCEDURE pr_edit_draft_order
    (PV_AUTOID      IN VARCHAR2,
     PV_USERID      IN VARCHAR2,
     PV_GROUPID     IN VARCHAR2,
     PV_CUSTODYCD   IN VARCHAR2,
     PV_ACCTNO      IN VARCHAR2,
     PV_EXECTYPE    IN VARCHAR2,
     PV_SYMBOL      IN VARCHAR2,
     PV_PRICE       IN VARCHAR2,
     PV_QTTY        IN VARCHAR2,
     PV_PRICETYPE   IN VARCHAR2,
     p_errcode      OUT VARCHAR2,
     p_err_message  OUT VARCHAR2
    )
IS
 v_count            number;
BEGIN
  plog.setbeginsection(pkgctx, 'pr_edit_draft_order');
  p_errcode := '0';
  p_err_message := '';
  select count(*) into v_count
  from draft_order_group
  where userid = trim(PV_USERID) and id = to_number(trim(PV_GROUPID));


  if v_count > 0 then
    insert into draft_order_log (autoid, order_group_old, order_group,
                                 userid_old, userid,
                                 acctno_old, acctno,
                                 custodycd_old, custodycd,
                                 exectype_old, exectype,
                                 symbol_old, symbol,
                                 qtty_old, qtty,
                                 pricetype_old, pricetype,
                                 price_old, price,
                                 amt_old, amt)
    select autoid, order_group, trim(PV_GROUPID),
           userid, trim(PV_USERID),
           acctno, trim(PV_ACCTNO),
           custodycd, trim(PV_CUSTODYCD),
           exectype, trim(PV_EXECTYPE),
           symbol, trim(PV_SYMBOL),
           qtty, trim(PV_QTTY),
           pricetype, trim(PV_PRICETYPE),
           price, trim(PV_PRICE),
           amt, trim(PV_QTTY) * trim(PV_PRICE)
    from draft_order
    where autoid = to_number(trim(PV_AUTOID));

    update draft_order
    set userid = trim(PV_USERID), ORDER_GROUP = to_number(trim(PV_GROUPID)),ACCTNO = trim(PV_ACCTNO),
    CUSTODYCD = upper(trim(PV_CUSTODYCD)), EXECTYPE = upper(trim(PV_EXECTYPE)), SYMBOL = upper(trim(PV_SYMBOL)),
    QTTY = to_number(trim(PV_QTTY)), PRICETYPE = upper(trim(PV_PRICETYPE)), PRICE = to_number(trim(PV_PRICE)),
    AMT = to_number(trim(PV_QTTY)) * to_number(trim(PV_PRICE)) where autoid = to_number(trim(PV_AUTOID));
  else
    p_errcode := '-700006';
    p_err_message:=cspks_system.fn_get_errmsg(p_errcode);
    plog.setendsection(pkgctx, 'pr_edit_draft_order');
    return;
  end if;

  plog.setendsection(pkgctx, 'pr_edit_draft_order');
EXCEPTION
  WHEN OTHERS THEN
    p_errcode := '-1';
    p_err_message := 'Undefined Error!';
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_edit_draft_order');
END pr_edit_draft_order;

PROCEDURE pr_delete_draft_order
    (PV_AUTOID      IN VARCHAR2,
     p_errcode      OUT VARCHAR2,
     p_err_message  OUT VARCHAR2
    )
IS
 v_count            number;
BEGIN
  plog.setbeginsection(pkgctx, 'pr_delete_draft_order');
  p_errcode := '0';
  p_err_message := '';
  update draft_order
  set status = 'H'
  where autoid = to_number(trim(PV_AUTOID));

  plog.setendsection(pkgctx, 'pr_delete_draft_order');
EXCEPTION
  WHEN OTHERS THEN
    p_errcode := '-1';
    p_err_message := 'Undefined Error!';
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_delete_draft_order');
END pr_delete_draft_order;

PROCEDURE pr_copy_draft_order
    (PV_AUTOID      IN VARCHAR2,
     PV_GROUPID     IN VARCHAR2,
     PV_USERID      IN VARCHAR2,
     PV_ISSAVE      IN VARCHAR2,
     p_errcode      OUT VARCHAR2,
     p_err_message  OUT VARCHAR2
    )
IS
 v_count            number;
 v_max_order        number;
 v_temp             number;
BEGIN
  plog.setbeginsection(pkgctx, 'pr_copy_draft_order');
  p_errcode := '0';
  p_err_message := '';
  --lay sl lenh can copy
  select count(*) into v_count
  from draft_order od
  where instr(trim(PV_AUTOID),'|'||to_char(od.autoid)||'|') > 0;

  --lay sl lenh da co trong nhom dich
  select count(*) into v_temp
  from draft_order
  where order_group = to_number(trim(PV_GROUPID))
  and userid = trim(PV_USERID) and status not in ('H');

  --lay sl lenh toi da
  select to_number(varvalue) into v_max_order
  from sysvar where varname  = 'MAX_DRAFT_ORDERS' and grname = 'SYSTEM';


  if upper(trim(PV_ISSAVE)) = 'Y' then
    if v_count + v_temp > v_max_order then
      p_errcode := '-700004';
      p_err_message:=cspks_system.fn_get_errmsg(p_errcode);
      plog.setendsection(pkgctx, 'pr_copy_draft_order');
      return;
    else
      for rec in
      (select od.* from draft_order od
      where instr(trim(PV_AUTOID),'|'||to_char(od.autoid)||'|') > 0
      )
      loop
        insert into draft_order(autoid, order_group,userid,acctno,custodycd,txdate,exectype,symbol,qtty,pricetype,price,amt)
        values(seq_draft_order.nextval, to_number(trim(PV_GROUPID)), rec.userid, rec.acctno, rec.custodycd, getcurrdate, rec.exectype, rec.symbol,
        rec.qtty, rec.pricetype, rec.price, rec.amt);
      end loop;
    end if;
  else
    if v_count > v_max_order then
      p_errcode := '-700004';
      p_err_message:=cspks_system.fn_get_errmsg(p_errcode);
      plog.setendsection(pkgctx, 'pr_copy_draft_order');
      return;
    else
      update draft_order set status = 'H' where order_group = to_number(trim(PV_GROUPID))
      and userid = trim(PV_USERID) and status not in ('H');
        for rec in
        (select od.* from draft_order od
        where instr(trim(PV_AUTOID),'|'||to_char(od.autoid)||'|') > 0
        )
        loop
          insert into draft_order(autoid, order_group,userid,acctno,custodycd,txdate,exectype,symbol,qtty,pricetype,price,amt)
          values(seq_draft_order.nextval, to_number(trim(PV_GROUPID)), rec.userid, rec.acctno, rec.custodycd, getcurrdate, rec.exectype, rec.symbol,
          rec.qtty, rec.pricetype, rec.price, rec.amt);
        end loop;
    end if;
  end if;

  plog.setendsection(pkgctx, 'pr_copy_draft_order');
EXCEPTION
  WHEN OTHERS THEN
    p_errcode := '-1';
    p_err_message := 'Undefined Error!';
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_copy_draft_order');
END pr_copy_draft_order;



PROCEDURE pr_update_draft_order
    (pv_isdraft      IN VARCHAR2,
     pv_draftid      IN VARCHAR2,
     pv_issaved      IN VARCHAR2,
     pv_errcode      IN VARCHAR2,
     pv_errmsg       IN VARCHAR2
    )
IS
BEGIN
  plog.setbeginsection(pkgctx, 'pr_update_draft_order');
  if upper(trim(pv_isdraft)) = 'Y' then
    if upper(trim(pv_issaved)) = 'Y' then
      update draft_order set status = 'E', errcode = trim(pv_errcode), errmsg = trim(pv_errmsg)
      where autoid = to_number(trim(pv_draftid));
    else
      update draft_order set status = 'H', errcode = trim(pv_errcode), errmsg = trim(pv_errmsg)
      where autoid = to_number(trim(pv_draftid));
    end if;
  end if;

  plog.setendsection(pkgctx, 'pr_update_draft_order');
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_update_draft_order');
END pr_update_draft_order;

--1.8.2.1: chuyen tien giua 2 tk luu ky
PROCEDURE pr_Depoacc2Transfer(p_dcustodycd VARCHAR2,
                              p_dacctno  varchar2,
                              p_ccustodycd varchar2,
                              p_cacctno varchar2,
                              p_amount NUMBER,
                              p_err_code  OUT varchar2,
                              p_err_message out varchar2,
                              p_ipaddress in  varchar2 default '' ,
                              p_via in varchar2 default '',
                              p_validationtype in varchar2 default '',
                              p_devicetype IN varchar2 default '',
                              p_device  IN varchar2 default '',
                              p_desc VARCHAR2 default '')
  IS
      l_txmsg tx.msg_rectype;
      l_err_param varchar2(300);
      v_strCURRDATE varchar2(20);

      v_fullname cfmast.fullname%TYPE;
      v_custname2 cfmast.fullname%TYPE;
      v_license cfmast.idcode%TYPE;
      v_license2 cfmast.idcode%TYPE;
      v_iddate cfmast.iddate%TYPE;
      v_iddate2 cfmast.iddate%TYPE;
      v_balance cimast.balance%TYPE;
      v_avladvance cimast.avrbal%TYPE;
      v_castbal cimast.balance%TYPE;
      v_feetype feemaster.feecd%TYPE;
      v_count NUMBER(2);
      v_des tllog.txdesc%TYPE;
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_Depoacc2Transfer');

    -- Check host & branch active or inactive
    p_err_code := fn_CheckActiveSystem;
    IF p_err_code <> systemnums.C_SUCCESS THEN
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_Depoacc2Transfer');
        return;
    END IF;
    -- End: Check host & branch active or inactive

    IF p_amount <= 0 THEN
        p_err_code := '-200226';
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_Depoacc2Transfer');
        RETURN;
    END IF;

    -- tai khoan chuyen
    BEGIN
      SELECT CF.FULLNAME, CF.IDCODE, CF.IDDATE
        INTO V_FULLNAME, V_LICENSE, V_IDDATE
        FROM CFMAST CF
       WHERE CF.CUSTODYCD = UPPER(P_DCUSTODYCD)
         AND CF.STATUS <> 'C';

      SELECT BALANCE INTO V_BALANCE FROM CIMAST WHERE ACCTNO = P_DACCTNO;
    EXCEPTION
      WHEN OTHERS THEN
        p_err_code := '-200222';
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_Depoacc2Transfer');
        return;
    END;

    BEGIN
      SELECT BALANCE INTO V_BALANCE FROM CFMAST CF, CIMAST CI
      WHERE CF.CUSTID = CI.CUSTID
        AND CI.ACCTNO = P_DACCTNO
        AND CF.CUSTODYCD = UPPER(P_DCUSTODYCD);
    EXCEPTION
      WHEN OTHERS THEN
        p_err_code := '-200224';
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_Depoacc2Transfer');
        return;
    END;

    -- tai khoan nhan
    BEGIN
      SELECT CF.FULLNAME, CF.IDCODE, CF.IDDATE
        INTO V_CUSTNAME2, V_LICENSE2, V_IDDATE2
        FROM CFMAST CF
       WHERE CF.CUSTODYCD = UPPER(P_CCUSTODYCD)
         AND CF.STATUS <> 'C';
    EXCEPTION
      WHEN OTHERS THEN
        p_err_code := '-200223';
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_Depoacc2Transfer');
        return;
    END;

    BEGIN
      SELECT BALANCE INTO V_BALANCE FROM CFMAST CF, CIMAST CI
      WHERE CF.CUSTID = CI.CUSTID
        AND CI.ACCTNO = P_CACCTNO
        AND CF.CUSTODYCD = UPPER(P_CCUSTODYCD);
    EXCEPTION
      WHEN OTHERS THEN
        p_err_code := '-200225';
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_Depoacc2Transfer');
        return;
    END;

    -- check dang ky chuyen khoan noi bo voi tk chuyen va tk nhan
    SELECT COUNT(1) INTO v_count FROM cfotheracc WHERE TYPE='0' AND afacctno=P_DACCTNO  AND ciaccount=P_CACCTNO;

     IF v_count = 0 THEN
        p_err_code := '-400127'; -- Pre-defined in DEFERROR table
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_Depoacc2Transfer');
     END IF;
    --
    SELECT TO_DATE (varvalue, systemnums.c_date_format)
               INTO v_strCURRDATE
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := systemnums.C_ONLINE_USERID;
    l_txmsg.offid       := systemnums.C_ONLINE_USERID;

    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;

    if (p_ipaddress is not null ) then l_txmsg.ipaddress:= substr(p_ipaddress,1,20); end IF;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := 'DAY';
    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd:='1201';
    v_des:= FN_GEN_DESC_1201(P_CCUSTODYCD,V_CUSTNAME2,p_cacctno)||' - '|| p_desc;--1.7.5.5: chuyen thanh tai khoan nhan, iss2617: them tieu khoan
    l_txmsg.txdesc := v_des;
    --Set txnum
    SELECT systemnums.C_OL_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO l_txmsg.txnum
              FROM DUAL;
              l_txmsg.brid        := substr(p_dacctno,1,4);


              --88  DCUSTODYCD       C
              L_TXMSG.TXFIELDS('88').DEFNAME := 'DCUSTODYCD';
              L_TXMSG.TXFIELDS('88').TYPE := 'C';
              L_TXMSG.TXFIELDS('88').VALUE := p_dcustodycd;

              --03  DACCTNO          C
              L_TXMSG.TXFIELDS('03').DEFNAME := 'DACCTNO';
              L_TXMSG.TXFIELDS('03').TYPE := 'C';
              L_TXMSG.TXFIELDS('03').VALUE := p_dacctno;

              --31  FULLNAME        C
              L_TXMSG.TXFIELDS('31').DEFNAME := 'FULLNAME';
              L_TXMSG.TXFIELDS('31').TYPE := 'C';
              L_TXMSG.TXFIELDS('31').VALUE := V_FULLNAME;

              --92  LICENSE         C
              L_TXMSG.TXFIELDS('92').DEFNAME := 'LICENSE';
              L_TXMSG.TXFIELDS('92').TYPE := 'C';
              L_TXMSG.TXFIELDS('92').VALUE := V_LICENSE;

              --96  IDDATE          C
              L_TXMSG.TXFIELDS('96').DEFNAME := 'IDDATE';
              L_TXMSG.TXFIELDS('96').TYPE := 'D';
              L_TXMSG.TXFIELDS('96').VALUE := V_IDDATE;

              --89  CCUSTODYCD       C
              L_TXMSG.TXFIELDS('89').DEFNAME := 'CCUSTODYCD';
              L_TXMSG.TXFIELDS('89').TYPE := 'C';
              L_TXMSG.TXFIELDS('89').VALUE := p_ccustodycd;

              --05  CACCTNO          C
              L_TXMSG.TXFIELDS('05').DEFNAME := 'CACCTNO';
              L_TXMSG.TXFIELDS('05').TYPE := 'C';
              L_TXMSG.TXFIELDS('05').VALUE := p_cacctno;

              --93  FULLNAME        C
              L_TXMSG.TXFIELDS('93').DEFNAME := 'CUSTNAME2';
              L_TXMSG.TXFIELDS('93').TYPE := 'C';
              L_TXMSG.TXFIELDS('93').VALUE := V_CUSTNAME2;

              --95  LICENSE2         C
              L_TXMSG.TXFIELDS('95').DEFNAME := 'LICENSE2';
              L_TXMSG.TXFIELDS('95').TYPE := 'C';
              L_TXMSG.TXFIELDS('95').VALUE := V_LICENSE2;

              --98  IDDATE2          C
              L_TXMSG.TXFIELDS('98').DEFNAME := 'IDDATE2';
              L_TXMSG.TXFIELDS('98').TYPE := 'D';
              L_TXMSG.TXFIELDS('98').VALUE := V_IDDATE2;

              --10  AMT             N
              L_TXMSG.TXFIELDS('10').DEFNAME := 'AMT';
              L_TXMSG.TXFIELDS('10').TYPE := 'N';
              L_TXMSG.TXFIELDS('10').VALUE := p_amount;

              --30  DESC            C
              L_TXMSG.TXFIELDS('30').DEFNAME := 'DESC';
              L_TXMSG.TXFIELDS('30').TYPE := 'C';
              L_TXMSG.TXFIELDS('30').VALUE := v_des;

              -- Ducnv them bieu phi
              v_feetype:='00015';

              l_txmsg.txfields ('25').defname   := 'FEETYPE';
              l_txmsg.txfields ('25').TYPE      := 'C';
              l_txmsg.txfields ('25').VALUE     := v_feetype;

              l_txmsg.txfields ('15').defname   := 'FEEAMT';
              l_txmsg.txfields ('15').TYPE      := 'N';
              l_txmsg.txfields ('15').VALUE     := fn_gettransfermoneyfee(p_amount,v_feetype);

              l_txmsg.txfields ('16').defname   := 'TOTALAMT';
              l_txmsg.txfields ('16').TYPE      := 'N';
              l_txmsg.txfields ('16').VALUE     := p_amount + fn_gettransfermoneyfee(p_amount,v_feetype);

               --85  balance        C
              L_TXMSG.TXFIELDS('85').DEFNAME := 'BALANCE';
              L_TXMSG.TXFIELDS('85').TYPE := 'N';
              L_TXMSG.TXFIELDS('85').VALUE := V_BALANCE;

              --86  AVLADVANCE         C
              L_TXMSG.TXFIELDS('86').DEFNAME := 'AVLADVANCE';
              L_TXMSG.TXFIELDS('86').TYPE := 'N';
              L_TXMSG.TXFIELDS('86').VALUE := getavladvance(p_dacctno);

              --87  IDDATE2          C
              L_TXMSG.TXFIELDS('87').DEFNAME := 'CASTBAL';
              L_TXMSG.TXFIELDS('87').TYPE := 'D';
              L_TXMSG.TXFIELDS('87').VALUE := getbaldefovd(p_dacctno);


    BEGIN
        IF txpks_#1201.fn_autotxprocess (l_txmsg,
                                         p_err_code,
                                         l_err_param
           ) <> systemnums.c_success
        THEN
           plog.debug (pkgctx,
                       'got error 1201: ' || p_err_code
           );
           ROLLBACK;
           p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
           plog.error(pkgctx, 'Error:'  || p_err_message);
           plog.setendsection(pkgctx, 'pr_Depoacc2Transfer');
           RETURN;
        END IF;

        --ThanhNV sua them doan check FO, neu giao dich duoi FO khong thanh cong cung rollback.
        PCK_SYN2FO.PRC_CHECK_SYN2FO(v_txnum =>l_txmsg.txnum,
                                     v_errcode => p_err_code,
                                     v_errmsg => p_err_message);


        plog.debug (pkgctx, 'PRC_CHECK_SYN2FO p_err_code '||p_err_code);
        IF p_err_code <> systemnums.c_success THEN
            ROLLBACK;
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error (pkgctx, p_err_message);
            plog.setendsection(pkgctx, 'pr_Depoacc2Transfer');
            RETURN;
        END IF;

    END;
    p_err_code:='0';
    pr_insertiplog( l_txmsg.txnum,  l_txmsg.txdate, l_txmsg.ipaddress, p_via, p_validationtype, p_devicetype, p_device, p_err_code);
    plog.setendsection(pkgctx, 'pr_Depoacc2Transfer');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_Depoacc2Transfer');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_Depoacc2Transfer');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_Depoacc2Transfer;

PROCEDURE pr_GetTransferAccountlist (pv_refCursor IN OUT pkg_report.ref_cursor,
                                    p_accountId  IN VARCHAR2,
                                    transferType IN VARCHAR2)
  IS
  l_type   VARCHAR2(10);
  BEGIN
    plog.setBeginSection (pkgctx, 'pr_GetTransferAccountlist');
    l_type :=  CASE WHEN transferType = 'internal' THEN '0'
                    WHEN transferType = 'depoacc2transfer' THEN '3' END;
    OPEN pv_refCursor
    FOR
      SELECT reg_acctno              benefitAccount,
             reg_beneficary_name     benefitName,
             acnidcode               benefitLisenceCode,
             REGCUSTODYCD            benefitCustodycd,
             CUSTODYCDTYPE           benefitCustodycd_type
      FROM VW_STRADE_MT_ACCOUNTS
      where afacctno = p_accountId
      AND type = l_type
      AND REGCUSTODYCD IS NOT NULL
      ;
    plog.setEndSection (pkgctx, 'pr_GetTransferAccountlist');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_GetTransferAccountlist');
  END;
-- end

begin
  -- Initialization
  for i in (select * from tlogdebug)
  loop
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  end loop;

  pkgctx := plog.init('fopks_api',
                      plevel     => nvl(logrow.loglevel, 30),
                      plogtable  => (nvl(logrow.log4table, 'N') = 'Y'),
                      palert     => (nvl(logrow.log4alert, 'N') = 'Y'),
                      ptrace     => (nvl(logrow.log4trace, 'N') = 'Y'));

end fopks_api;
/