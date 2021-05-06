CREATE OR REPLACE PACKAGE fopks_api_thenntest IS

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
  PROCEDURE pr_InternalTransfer(p_account varchar,
                            p_toaccount  varchar2,
                            p_amount number,
                            p_desc varchar2,
                            p_err_code  OUT varchar2,
                            p_err_message out varchar2);
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
                            p_err_message out varchar2);
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
                        p_err_code out varchar2,
                        p_err_message out VARCHAR2
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

PROCEDURE pr_RightoffRegiter
    (p_camastid IN   varchar,
    p_account   IN   varchar,
    p_qtty      IN   number,
    p_desc      IN   varchar2,
    p_err_code  OUT varchar2,
    p_err_message  OUT varchar2
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
     p_txdate date,
     p_duedate DATE,
     p_advamt number,
     p_feeamt NUMBER,
     p_advdays NUMBER,
     p_maxamt    NUMBER,
     p_desc varchar2,
     p_err_code  OUT varchar2,
     p_err_message  OUT VARCHAR2
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
     SECTYPE        IN  VARCHAR2
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
     pv_RowCount    IN OUT  NUMBER,
     pv_PageSize    IN  NUMBER,
     pv_PageIndex   IN  NUMBER,
     AFACCTNO       IN  VARCHAR2,
     GROUPDFID      IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2
     ); -- LAY THONG TIN KHOAN VAY DF CHI TIET
END fopks_api_THENNTEST;
/

