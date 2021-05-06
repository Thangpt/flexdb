CREATE OR REPLACE PACKAGE fopks_api_rpp IS

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



procedure pr_get_ciacount
    (p_refcursor in out pkg_report.ref_cursor,
    p_custodycd in VARCHAR2,
    p_afacctno  IN  varchar2,
    PAGE_RPP IN NUMBER,
    ROWS_RPP IN NUMBER);

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
                            p_citybank varchar2,
                            p_cityef   varchar2,
                            p_err_code  OUT varchar2,
                            p_err_message out varchar2,
                            p_ipaddress in  varchar2 default '' , --1.5.3.0
                            p_via in varchar2 default '',
                            p_validationtype in varchar2 default '',
                            p_devicetype IN varchar2 default '',
                            p_device  IN varchar2 default '');

procedure pr_get_rightofflist(
    p_refcursor in out pkg_report.ref_cursor,
    p_afacctno in varchar2,
    PAGE_RPP IN NUMBER,
    ROWS_RPP IN NUMBER
    );

PROCEDURE pr_GetOrder
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD    IN VARCHAR2,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     SYMBOL         IN  VARCHAR2,
     EXECTYPE      IN  VARCHAR2,
     STATUS         IN  VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER); -- Lay thong tin lenh giao dich

PROCEDURE pr_MoneyTransDetail
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2,
     P_STATUS       in  varchar2 default 'ALL',
     P_PLACE        in  varchar2 default 'ALL',
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER);

PROCEDURE pr_GetCashStatement
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN       VARCHAR2,
     T_DATE         IN       VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
    ); -- Sao ke tien
PROCEDURE pr_GetSecuritiesStatement
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN       VARCHAR2,
     T_DATE         IN       VARCHAR2,
     SYMBOL         IN  VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
    ); -- Sao ke chung khoan
PROCEDURE pr_GetCashTransfer
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD    IN VARCHAR2,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     STATUS         IN  VARCHAR2,
     VIA         IN  VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
     );    -- Lay thong tin chuyen khoan tien
PROCEDURE pr_GetRightOffInfor
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD    IN VARCHAR2,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
     ); -- LAY THONG TIN GD QUYEN MUA

PROCEDURE pr_GetAdvancedPayment
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN VARCHAR2,
     T_DATE         IN VARCHAR2,
     STATUS         IN VARCHAR2,
     VIA       IN VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
    ); -- LAY THONG TIN HOP DONG UNG TRUOC DA THUC HIEN

function fn_CheckActiveSystem
    return NUMBER; -- Check host & branch active or inactive

procedure pr_get_rightinfo
    (p_refcursor in out pkg_report.ref_cursor,
    PV_CUSTODYCD  IN  VARCHAR2,
    PV_AFACCTNO   IN  VARCHAR2,
    ISCOM         IN  VARCHAR2,
    F_DATE        IN VARCHAR2,
    T_DATE        IN  VARCHAR2,
    PAGE_RPP IN NUMBER,
    ROWS_RPP IN NUMBER
    );--Ham tra cuu su kien quyen
PROCEDURE pr_GetBonds2SharesList
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD    IN VARCHAR2,
     AFACCTNO       IN  VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
     ); -- HAM LAY DANH SACH THQ CHUYEN TRAI PHIEU --> CO PHIEU

PROCEDURE pr_LoanHist
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD    IN VARCHAR2,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
     );--HAM TRA CUU DU NO

  PROCEDURE pr_GetTDhist
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
     );--Ham tra cuu tiet kiem

PROCEDURE pr_GetConvertBondHist
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
     );--Ham tra cuu chuyen doi trai phieu thanh co phieu
PROCEDURE pr_GetRePaymentHist
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     p_AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
     );--Ham tra cuu thong tin tra no

PROCEDURE pr_GetConfirmOrderHistByCust
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD      IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     EXECTYPE       IN  VARCHAR2,
     PAGE_RPP       IN NUMBER,
     ROWS_RPP       IN NUMBER
     );--Ham tra cuu lenh xac nhan
PROCEDURE pr_ConfirmOrder(
      p_Orderid varchar2,
      p_userId VARCHAR2,
      p_custid VARCHAR2,
      p_Ipadrress VARCHAR2,
      p_via varchar2 default 'O',
      F_DATE         IN  VARCHAR2,
      T_DATE         IN  VARCHAR2,
      EXECTYPE       IN  VARCHAR2,
      p_err_code out varchar2
);--ham submit xac nhan lenh son.pham chuyen tu cspks_odproc.pr_ConfirmOrder
--lay thong tin lenh khop
PROCEDURE pr_get_infomation_order
    (P_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD     IN VARCHAR2,
     ROOTORDERID        IN VARCHAR2
     );

--check lenh ton tai
PROCEDURE pr_get_check_orderlist
    (P_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD     IN VARCHAR2,
     AFACCTNO        IN VARCHAR2,
     ORDERID        IN VARCHAR2,
     EXECTYPE         IN VARCHAR2,
     SYMBOL             IN VARCHAR2,
     STATUS          IN VARCHAR2
     );
PROCEDURE pr_GetAFTemplates
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     p_AFACCTNO    IN VARCHAR2
     );

PROCEDURE pr_GetNetAssetDetail_byCus
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     p_CUSTODYCD in varchar2,
     p_AFACCTNO    IN VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
     );
PROCEDURE pr_GetTotalAssetInfo
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     p_CUSTODYCD in varchar2,
     p_AFACCTNO    IN VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
     );
PROCEDURE pr_get_normalorderlist
    (P_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD     IN VARCHAR2,
    /* PLACECUSTID  IN VARCHAR2,
     TXDATE         IN VARCHAR2,*/
     AFACCTNO        IN VARCHAR2,
     EXECTYPE         IN VARCHAR2,
     SYMBOL             IN VARCHAR2,
     STATUS          IN VARCHAR2,
     ODTIMESTAMP     IN VARCHAR2,
     PAGE_RPP          IN NUMBER,
     ROWS_RPP        IN NUMBER
     );

PROCEDURE pr_get_seinfolist
    (P_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD     IN VARCHAR2,
     AFACCTNO        IN VARCHAR2,
     PAGE_RPP          IN NUMBER,
     ROWS_RPP         IN NUMBER
     );
--check tai khoan master cho user careby
PROCEDURE pr_check_master
    (P_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     M_CUSTODYCD     IN VARCHAR2,
     CUSTODYCD       IN VARCHAR2
     );


procedure pr_get_AfInfoToOrder
    (p_refcursor in out pkg_report.ref_cursor,
    p_afacctno  IN  VARCHAR2,
    p_symbol IN VARCHAR2,
    p_price IN VARCHAR2);

PROCEDURE pr_GETCFOTHERACC
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     ACCTNO       IN  VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
     );
PROCEDURE pr_GETCFOTHERBANKLIST
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     ACCTNO       IN  VARCHAR2,
     MNEMONIC     in varchar2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
     );
procedure pr_regtranferacc(p_check in varchar2,--check hay thuc hien luu luon       --1.5.1.3   OTP
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
                        p_mnemonic   IN VARCHAR2,
                        p_err_code out varchar2,
                        p_err_message out VARCHAR2,
                        p_ipaddress in  varchar2 default '' , --1.5.3.0
                        p_via in varchar2 default '',
                        p_validationtype in varchar2 default '',
                        p_devicetype IN varchar2 default '',
                        p_device  IN varchar2 default ''
                        );-- Ham dang ky so tk chuyen khoan
procedure pr_get_stocktransferlist(
    p_refcursor in out pkg_report.ref_cursor,
    p_afacctno in varchar2,
    PAGE_RPP IN NUMBER,
    ROWS_RPP IN NUMBER
    );
PROCEDURE pr_get_selloddorderlist
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     ACCTNO       IN  VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
     );
PROCEDURE pr_get_canceloddorderlist
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     ACCTNO       IN  VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
     );
PROCEDURE pr_GETMSBTRANSFERLIST
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     ACCTNO       IN  VARCHAR2,
     MNEMONIC     in varchar2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
     );
procedure pr_EditTranferacc(p_type in varchar2,-- 0 : Chuyen khoan noi bo.  1: Chuyen khoan ra NH
                        p_afacctno in varchar2,-- So tieu khoan goc
                        p_ciacctno in varchar2,-- So tieu khoan nhan trong truong hop chuyen khoan noi bo
                        p_ciname in varchar2,  -- Ten tieu khoan nhan trong truong hop chuyen khoan noi bo
                        p_bankacc in varchar2, -- So tk Ngan hang
                        p_bankacname in varchar2, -- Ten chu TK ngan hang
                        p_ciacctno_old in varchar2,-- So tieu khoan nhan cu trong truong hop chuyen khoan noi bo
                        p_bankacc_old in varchar2, -- So tk Ngan hang cu
                        p_mnemonic   IN VARCHAR2,  --ten goi nho tren online
                        p_err_code out varchar2,
                        p_err_message out VARCHAR2
                        ); -- Ham sua so tk chuyen khoan -- Ham sua so tk chuyen khoan
PROCEDURE pr_GETDESTTRFACCTLIST
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     ACCTNO       IN  VARCHAR2,
     MNEMONIC     in varchar2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
     );
PROCEDURE pr_GetAFTemplates
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     p_AFACCTNO    IN VARCHAR2,
     P_TYPE     IN VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
     );
FUNCTION fnc_get_NAV(
 p_afacctno IN      VARCHAR2
) RETURN NUMBER;

PROCEDURE pr_GetTradeDiary
(
    P_REFCURSOR     IN OUT PKG_REPORT.REF_CURSOR,
    CUSTODYCD       IN  VARCHAR2,
    AFACCTNO        IN  VARCHAR2,
    F_DATE          IN  VARCHAR2,
    T_DATE          IN  VARCHAR2,
    SYMBOL          IN  VARCHAR2,
    --EXECTYPE      IN  VARCHAR2
    PAGE_RPP        IN  NUMBER,
    ROWS_RPP        IN  NUMBER

);
PROCEDURE pr_GetTotalInvesment
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,

     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2);

PROCEDURE pr_ResetPin(p_custodycd VARCHAR2,
                      p_newpin       VARCHAR2,
                      p_err_code  OUT varchar2,
                      p_err_message out varchar2);

procedure pr_get_AfInfoToOrder_PB
    (p_refcursor in out pkg_report.ref_cursor,
    p_afacctno  IN  VARCHAR2,
    p_symbol IN VARCHAR2,
    p_price IN VARCHAR2);

PROCEDURE pr_get_seinfolist_PB
    (P_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD     IN VARCHAR2,
     AFACCTNO        IN VARCHAR2,
     PAGE_RPP          IN NUMBER,
     ROWS_RPP         IN NUMBER
     );
PROCEDURE pr_GetTotalInvesment_PB
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2);

procedure pr_get_branch(
    p_refcursor in out pkg_report.ref_cursor,
    p_areaid    IN varchar2
    );
PROCEDURE pr_OnlineRegister(
       p_CustomerName IN VARCHAR2,
       p_CustomerBirth IN VARCHAR2,
       p_IDCode IN VARCHAR2,
       p_Iddate IN VARCHAR2,
       p_Idplace IN VARCHAR2,
       p_ContactAddress IN VARCHAR2,
       p_Mobile IN VARCHAR2,
       p_Email IN VARCHAR2,
       p_CustomerCity IN VARCHAR2,
       p_Custodycd   IN VARCHAR2,
       p_brid        IN VARCHAR2,
       p_sex         IN VARCHAR2,
       p_err_code  OUT varchar2,
       p_err_message  OUT varchar2,
       p_expdate      IN varchar2 default '', -- Ngay het han mat khau
       p_Bankaccount  in varchar2 default '', -- so tai khoan ngan hang
       p_Bankname     in varchar2 default '', -- ten ngan hang
       p_ReRegister  in varchar2 default 'N', -- dang ky moi gioi khong
       p_ReRelationship  in varchar2 default '', -- quan he vs moi gioi
       p_ReFullName      in varchar2 default '', -- ten moi gioi
       p_ReTlid          in varchar2 default '',-- ma moi gioi
       p_othCustodycd    in varchar2 default '',
       p_othCompany      in varchar2 default '', -- thành viên luu ký
       p_RegisterServices in   varchar2 default 'NNNNN', -- Dich vu giao dich CK: NNNNN:1.GD qua IE,2.Call,3.UT tien ban,4.KyQuy,5.DK Phai Sinh
       p_RegisterNotiTran in   varchar2 default 'NNN', --Phuong thuc thong bao:NNN: 1.Email, 2. SMS, 3.Truc Tuyen
       p_AuthenTypeOnline in   varchar2 default 'NN',  -- Loai xac thuc kenh online:NN: 1.OTP OBLINE. 2. Chu ky so
       p_AuthenTypeMobile in   varchar2 default 'N' ,   -- loai xac thuc kenh mobile: N - 1 OTP
       p_AreaOpenAccount  in   varchar2 default '', -- noi mo tk
       p_BranchOpenAccount in   varchar2 default '', -- chi nhanh
       p_BankBrid      in   varchar2 default ''
    );--Ham dang ky online
END fopks_api_rpp;
/
CREATE OR REPLACE PACKAGE BODY fopks_api_rpp is

  -- Private variable declarations
  pkgctx plog.log_ctx;
  logrow tlogdebug%rowtype;


---------------------------------pr_ExternalTransfer------------------------------------------------
--06/2016 Toannds them p_citybank, p_cityef
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
                            p_citybank varchar2,
                            p_cityef   varchar2,
                            p_err_code  OUT varchar2,
                            p_err_message out VARCHAR2,
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
      v_citybank    varchar2(2000);
      v_CITYEF      varchar2(2000);
      v_custodycd   varchar2(200);
      v_fullname    varchar2(1000);
      p_trfcount number; --So lan chuyen khoan trong ngay
      v_feetype varchar2(10);
      l_custid varchar2(10);
      l_count number;
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
      v_trfCurCashAmt         NUMBER(20);
      v_trfCurAdvAmt          NUMBER(20);
      v_trfCashAmt            NUMBER(20);
      v_trfAdvAmt             NUMBER(20);

      v_iTrfCurAmt            NUMBER(20);
      v_trfCurAmtExt          NUMBER(20);
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
        if to_number(cspks_system.fn_get_sysvar('SYSTEM','ONLINEMAXTRF1101_AMT')) < p_amount THEN
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
    SELECT CF.CUSTID, CF.idcode, TO_CHAR(CF.iddate,'DD/MM/YYYY'), CF.idplace, cf.custodycd, cf.fullname
    INTO l_custid, v_idcode, v_iddate, v_idplace, v_custodycd, v_fullname
    FROM CFMAST CF, AFMAST AF
    WHERE CF.CUSTID = AF.CUSTID AND AF.ACCTNO = p_account;

    --Kiem tra so lan chuyen khoan toi da
    select count(1), NVL(sum(tl.msgamt),0) , NVL(SUM(decode(
           upper(translate(fld.cvalue, utf8nums.c_findtext, utf8nums.c_repltext)),
           upper(translate(v_fullname, utf8nums.c_findtext, utf8nums.c_repltext)),
           0, tl.msgamt)),0)
    into p_trfcount, v_trfCurAmt, v_trfCurAmtExt
    from tllog tl, tllogfld fld
    where tl.tltxcd ='1101' and tl.tlid =systemnums.C_ONLINE_USERID--1.5.6.3 MSBS-1906
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
    where status='P' and txdate=v_currdate
    and afacctno in (select acctno from afmast where custid = l_custid);

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

    --check da dk thu huong chua
    select count(*) into l_count from cfotheracc where afacctno = p_account and bankacc = p_benefacct;
    if l_count = 0 then
        p_err_code:='-670072';
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_ExternalTransfer');
        return;
    end if;
    --End check da dk thu huong chua

    -- Kiem tra so tien chuyen khoan toi da 1 ngay
    IF upper(translate(p_benefcustname, utf8nums.c_findtext, utf8nums.c_repltext))
          <> upper(translate(v_fullname, utf8nums.c_findtext, utf8nums.c_repltext)) THEN
       IF v_blnCheckCustomerLimit THEN
          IF v_trfMaxTotalAmount_1 < v_trfCurAmtExt + v_trfAmountext_temp + p_amount THEN    --  han muc tam khac chinh chu con lai < so tien chuyen khac chinh chu
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
          VALIDATIONTYPE, DEVICETYPE, DEVICE, STATUS, CASHAMT, ADVAMT, CURCASHAMT, CURADVAMT, CURCASHAMTEXT)
          VALUES(v_trfAutoID, v_currdate, p_account, p_bankid, p_benefbank, p_benefacct,
          p_benefcustname, p_beneflicense, p_amount, p_feeamt, p_vatamt, p_desc, substr(p_ipaddress,1,20), p_via,
          p_validationtype, p_devicetype, p_device, 'P', v_trfCashAmt, v_trfAdvAmt, v_trfCurCashAmt, v_trfCurAdvAmt, v_trfCurAmtExt);
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
    if (p_ipaddress is not null ) then l_txmsg.ipaddress:= substr(p_ipaddress,1,20); end if; --1.6.1.9: MSBS-2209 substr
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
	-- lay thong tin chi nhanh/ thanh pho theo dk thu huong. tranh case loi truyen sai thong tin
    SELECT CF.citybank, CF.cityef
    INTO v_citybank, v_CITYEF
    FROM cfotheracc CF
    WHERE CF.afacctno = p_account AND CF.bankacc = p_benefacct;
    --v_citybank:=p_citybank;
   -- v_CITYEF:= p_cityef;

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
    --    if to_number(p_amount) < 500000000 then
    --      v_feetype:='00017';
    --    else v_feetype:= '20000';
    --    end if;
    --End if;


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
           plog.setendsection(pkgctx, 'pr_placeorder');
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
       plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_ExternalTransfer');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_ExternalTransfer;


--06/2016 Toannds them ham Lay danh sach templates
PROCEDURE pr_GetAFTemplates
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     p_AFACCTNO    IN VARCHAR2,
     P_TYPE     IN VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
     )
    IS

BEGIN
      OPEN p_REFCURSOR FOR
      select * from
        (
            select a.*, rownum r from
            (
               SELECT t.code,t.subject,t.type, decode(a.template_code,null,'N','Y') register
               FROM templates t , (select * from aftemplates where AFACCTNO=p_AFACCTNO )a
               Where t.code=a.template_code(+)
               AND T.REQUIRE_REGISTER ='Y'
               and T.TYPE=p_type
               AND T.CODE NOT IN ('0208','0334','0808','324A','324B','0555'/*, '0323'*/)--1.8.1.6 bo chan gui sms
               Order by t.type, t.code
            ) a
            where rownum <= ROWS_RPP * PAGE_RPP
        )
        where r > ROWS_RPP * (PAGE_RPP - 1);
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'pr_GetAFTemplates');
END pr_GetAFTemplates;

--06/2016 Toannds them ham lay ds chuyen khoan ck
procedure pr_get_stocktransferlist(
    p_refcursor in out pkg_report.ref_cursor,
    p_afacctno in varchar2,
    PAGE_RPP IN NUMBER,
    ROWS_RPP IN NUMBER
    )
is
begin
    plog.setbeginsection(pkgctx, 'pr_get_stocktransferlist');
    Open p_refcursor FOR

    --ngoc.vu edit 08/08/2016,turning 0001000061
      select * from
        (
            select a.*, rownum r from
            (
                  select * from
                    (SELECT sym.symbol, semast.afacctno,
                           least(semast.trade,(case when semast.trade >0
                                                      then fn_get_semast_avl_withdraw(semast.afacctno, semast.codeid)
                                                        else 0 end )) trade,
                           nvl(setl.qtty,0) blocked
                      FROM sbsecurities sym, semast,
                          (
                           select acctno , sum(qtty) qtty from semastdtl
                           where status='N' AND DELTD <>'Y'
                                 AND  qttytype ='002'
                                 and substr(acctno,1,10)=p_afacctno
                           group by acctno
                           ) setl

                      WHERE sym.codeid = semast.codeid
                            AND semast.acctno = setl.acctno(+)
                            AND sym.sectype <> '004')
                  where trade + blocked > 0 and afacctno = p_afacctno
                  order by symbol
            ) a
            where rownum <= ROWS_RPP * PAGE_RPP
        )
        where r > ROWS_RPP * (PAGE_RPP - 1);

      /*  select * from
        (
            select a.*, rownum r from
            (
                  select * from
                    (SELECT sym.symbol, semast.afacctno,
                         least(semast.trade,fn_get_semast_avl_withdraw(semast.afacctno, semast.codeid)) trade, nvl(setl.qtty,0) blocked
                      FROM sbsecurities sym, semast,
                           (select acctno , sum(qtty) qtty from semastdtl where status='N' AND DELTD <>'Y' AND  qttytype ='002' group by acctno) setl
                      WHERE sym.codeid = semast.codeid
                            AND semast.acctno = setl.acctno(+)
                            AND sym.sectype <> '004')
                  where trade + blocked > 0 and afacctno = p_afacctno
                  order by symbol
            ) a
            where rownum <= ROWS_RPP * PAGE_RPP
        )
        where r > ROWS_RPP * (PAGE_RPP - 1);*/
    plog.setendsection(pkgctx, 'pr_get_stocktransferlist');
exception when others then
      plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'pr_get_stocktransferlist');
end pr_get_stocktransferlist;

--ham dang ky tai khoan thu huong
PROCEDURE pr_regtranferacc(p_check in varchar2,--check hay thuc hien luu luon           --1.5.1.3   OTP
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
                        p_mnemonic   IN VARCHAR2,  --ten goi nho tren online
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
   v_mnemonic varchar2(200);
   -- begin 1.5.1.3 | 1806
   l_datasourcesms varchar2(1000);
   v_custodycd varchar2(20);
   v_mobile varchar2(15);
   -- end 1.5.1.3 | 1806
   v_autoid    NUMBER;

   -- begin ver: 1.5.0.2 | iss: 1693
   v_custid     cfmast.custid%TYPE;
   v_custname   cfmast.fullname%TYPE;
   v_custstatus cfmast.status%TYPE;
   -- end ver: 1.5.0.2 | iss: 1693

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
    -- begin ver: 1.5.0.2 | iss: 1693
    BEGIN
      SELECT custid INTO v_custid FROM afmast WHERE acctno = p_afacctno;
      SELECT fullname, status INTO v_custname, v_custstatus

      FROM cfmast WHERE custid = v_custid;

      -- begin 1.5.1.3 | 1806
          select custodycd, mobile into v_custodycd, v_mobile from afmast a, cfmast c where a.custid = c.custid and a.acctno = p_afacctno;
      -- end 1.5.1.3 | 1806

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
    --check ten TK thu huong phai trung ten KH
    --v_count:=0;
    --Begin
    --    Select count(1) into v_count
    --    From cfmast
    --    Where upper(nmpks_ems.fn_convert_to_vn(trim(fullname))) = upper(trim(p_bankacname)) and
    --          status = 'A' AND
    --          custid IN (SELECT custid FROM afmast WHERE acctno = p_afacctno);
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
    --End check ten TK thu huong phai trung ten KH
    -- end ver: 1.5.0.2 | iss: 1693

    v_mnemonic:=nvl(p_mnemonic,'xxx');

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

    IF p_type='1' then
      v_count:=0;

       Begin
            Select count(1) into v_count
            From cfotheracc
            Where afacctno=p_afacctno and nvl(mnemonic,'xxx')=p_mnemonic ;
        EXCEPTION
         When others then
         v_count:=0;
        End;
         IF v_count>0 then
            p_err_code:='-901209'; --check trung ten goi nho
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_regtranferacc');
            return;
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
           If   v_count = 0  AND p_check = 'N' THEN     --1.5.1.3   OTP
                SELECT seq_cfotheracc.nextval INTO v_autoid FROM dual;
                        insert into cfotheracc( autoid, afacctno, ciaccount, ciname, custid, bankacc,
                                 bankacname, bankname, type, acnidcode, acniddate,
                                 acnidplace, feecd, cityef, citybank,BANKID,bankorgno,via,username,tlid,createdate,mnemonic)
                          values(v_autoid,vc.acctno, p_ciacctno, p_ciname, null, p_bankacc,
                                 p_bankacname, p_bankname, p_type, null, null,
                                 null, null, p_cityef, p_citybank,P_BANKID,P_bankorgno,'O','online',systemnums.C_ONLINE_USERID,v_currdate, p_mnemonic);
                               --1.5.3.0
                        pr_insertiplog( v_autoid,  getcurrdate, p_ipaddress, p_via, p_validationtype, p_devicetype, p_device, p_err_code);

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

--06/2016 Toannds them phan trang ham lay ds DKQM
procedure pr_get_rightofflist(
    p_refcursor in out pkg_report.ref_cursor,
    p_afacctno in varchar2,
    PAGE_RPP IN NUMBER,
    ROWS_RPP IN NUMBER
    )
is
begin
    plog.setbeginsection(pkgctx, 'pr_get_rightofflist');
    Open p_refcursor FOR

       select * from
        (
         select a.SYMBOL, a.TRADE, a.ORGPBALANCE, a.RETAILBAL, a.PQTTY, a.REGQTTY, a.EXPRICE, a.CAMASTID, a.SECTYPE, a.DUEDATE,
                a.RIGHTOFFRATE, a.FRDATETRANSFER, a.TODATETRANSFER, a.BEGINDATE, a.REPORTDATE ,a.en_sectype,
                (CASE WHEN A.currdate < A.BEGINDATE THEN 'N'
                      ELSE (CASE WHEN A.PQTTY >0 THEN 'Y' ELSE 'N' END) END) ISREGIS,
                (CASE WHEN A.currdate < A.BEGINDATE THEN '0'
                      ELSE (CASE WHEN A.PQTTY >0 THEN '1' ELSE '2' END) END) STATUS,a.EXPRICE*a.PQTTY TOTALMONEY, rownum r
          FROM
            (
                SELECT CA.*, CA.PENDINGQTTY - NVL(RQ.MSGQTTY,0) pqtty
                FROM
                (
                   select CA.AFACCTNO, sb.symbol,ca.trade,ca.pbalance RETAILBAL,ca.pbalance pbalance,
                    CASE WHEN ca.balance - ca.inbalance + ca.outbalance >0 THEN ca.balance - ca.inbalance + ca.outbalance ELSE 0 end orgbalance,
                        ca.orgpbalance,ca.balance,
                       ca.qtty regqtty, mst.exprice,mst.description,ca.pqtty*mst.exprice amt,sb.parvalue  ,
                       to_date(varvalue,'dd/mm/rrrr') currdate,
                       mst.camastid||to_char(ca.autoid) camastid, cd.cdcontent sectype,cd.en_cdcontent en_sectype, mst.duedate,mst.reportdate, mst.rightoffrate,mst.frdatetransfer,
                       mst.todatetransfer,mst.begindate, ca.pbalance + ca.balance allbalance, ca.pqtty PENDINGQTTY
                   from caschd ca, sbsecurities sb, allcode cd, camast mst,sysvar sy
                   where mst.tocodeid = sb.codeid and ca.camastid = mst.camastid
                       and cd.cdname ='SECTYPE' and cd.cdtype ='SA' and cd.cdval=sb.sectype
                       AND ca.status IN( 'V','M') AND ca.status <>'Y' AND ca.deltd <> 'Y'
                       AND mst.catype='014' --and ca.pbalance > 0 and ca.pqtty > 0
                       --AND sb.sectype NOT IN ('004','009') -- Ko lay len cac CK quyen mua cho giao dich
                       and sy.grname = 'SYSTEM' AND sy.varname = 'CURRDATE'
                       and ca.afacctno = p_afacctno
                       and to_date(sy.VARVALUE,'dd/mm/rrrr') <=mst.DUEDATE
                       order by mst.begindate
                ) CA
                LEFT JOIN
                (
                   SELECT msgacct, keyvalue, sum(NVL(MSGQTTY,0)) MSGQTTY FROM borqslog
                       WHERE RQSTYP = 'CAR' AND STATUS IN ('W','P','H') AND msgacct = p_afacctno
                       GROUP BY msgacct, keyvalue
                ) RQ
                ON CA.camastid = RQ.keyvalue AND CA.afacctno = RQ.msgacct
            ) a
            where rownum <= ROWS_RPP * PAGE_RPP
        )
        where r > ROWS_RPP * (PAGE_RPP - 1);

    plog.setendsection(pkgctx, 'pr_get_rightofflist');
exception when others then
       plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'pr_get_rightofflist');
end pr_get_rightofflist;

procedure pr_get_ciacount
    (p_refcursor in out pkg_report.ref_cursor,
    p_custodycd in VARCHAR2,
    p_afacctno  IN  varchar2,
    PAGE_RPP IN NUMBER,
    ROWS_RPP IN NUMBER)
IS
    V_CUSTODYCD     varchar2(10);
    V_AFACCTNO      varchar2(10);
    V_CURRDATE      DATE;
begin
    plog.setbeginsection(pkgctx, 'pr_get_ciacount');

    IF p_custodycd = 'ALL' OR p_custodycd is NULL THEN
        V_CUSTODYCD := '%';
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

    if  PAGE_RPP = 1 then
    Open p_refcursor FOR
    SELECT '' afacctno, '' desc_status,sum(PP) PP,sum(balance) BALANCE,sum(advanceline) advanceline,
                        sum(baldefovd) baldefovd, sum(avlwithdraw) avlwithdraw,
                        sum(avladvance) avladvance,sum(aamt) AAMT,sum(bamt) BAMT,
                        sum(odamt) ODAMT,sum(dealpaidamt) dealpaidamt,
                        sum(outstanding) outstanding,
                        --receiving-cash_receiving_t0-cash_receiving_t1-cash_receiving_t2-cash_receiving_tn careceiving,
                        sum(floatamt) FLOATAMT,sum(receiving) receiving,sum(netting) netting,
                        sum(cash_receiving_t0) cash_receiving_t0,sum(cash_receiving_t1) cash_receiving_t1,
                        sum(cash_receiving_t2) cash_receiving_t2,sum(cash_receiving_t3) cash_receiving_t3,
                        sum(cash_receiving_tn) cash_receiving_tn,sum(cash_sending_t0) cash_sending_t0,
                        sum(cash_sending_t1) cash_sending_t1,sum(cash_sending_t2) cash_sending_t2,
                        sum(cash_sending_t3) cash_sending_t3,sum(cash_sending_tn) cash_sending_tn,
                        sum(CASH_PENDWITHDRAW) CASH_PENDWITHDRAW,sum(CASH_PENDTRANSFER) CASH_PENDTRANSFER,
                        sum(AVLADV_T3) AVLADV_T3, sum(AVLADV_T1) AVLADV_T1, sum(AVLADV_T2) AVLADV_T2,
                        --bamt+cash_sending_t1+cash_sending_t2+cash_sending_t3+cash_sending_tn+CASH_PENDWITHDRAW+CASH_PENDTRANSFER cash_pending_send
                        --bamt+cash_sending_t0+cash_sending_t1+cash_sending_t3+cash_sending_tn+CASH_PENDWITHDRAW+CASH_PENDTRANSFER cash_pending_send
                        sum(cash_pending_send) cash_pending_send,
                        sum(casht2sending) casht2sending,
                        sum(marginrate) marginrate,
                        sum(marginrate_ex) marginrate_ex,
                        sum(GUA) GUA, sum(OVDCIDEPOFEE) OVDCIDEPOFEE,
                        sum(careceiving) careceiving, sum(TOTALLOAN) TOTALLOAN, sum(ADDVND) ADDVND, 0 r

      FROM (
      SELECT CI.*, NVL(CA.AMT, 0) careceiving,ci.OVDCIDEPOFEE+ nvl(LN.TOTALLOAN,0) TOTALLOAN, nvl(mr.ADDVND,0) ADDVND
            FROM
                (
                    select afacctno,desc_status,ROUND(pp) PP,ROUND(balance) BALANCE,ROUND(advanceline) advanceline,
                        ROUND(baldefovd) baldefovd, /*ROUND(avlwithdraw)*/ ROUND(least(avlwithdraw,fn_getfowithdraw(ci.AFACCTNO))) avlwithdraw,
                        ROUND(AVLADV_T3+AVLADV_T1+AVLADV_T2) avladvance,ROUND(aamt) AAMT,ROUND(bamt) BAMT,
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
                        ci.marginrate_ex,
                        ADVANCELINE GUA, ci.OVDCIDEPOFEE
                    from buf_ci_account ci
                    where ci.custodycd like V_CUSTODYCD
                        AND ci.afacctno LIKE V_AFACCTNO
                        AND EXISTS(SELECT cf.custodycd, af.acctno afacctno
                                    FROM afmast af, otright ot, cfmast cf
                                    WHERE CI.AFACCTNO = AF.ACCTNO AND af.custid = cf.custid
                                        AND ot.authcustid = ot.cfcustid AND af.custid = ot.authcustid
                                        --AND af.status = 'A'
                                        AND ot.deltd = 'N'
                                        AND ot.valdate <= V_CURRDATE AND ot.expdate >= V_CURRDATE
                                        AND CF.custodycd like V_CUSTODYCD
                                        AND AF.acctno LIKE V_AFACCTNO)
                ) CI
                left join
                ( select ADDVND,acctno from vw_mr0003 where acctno like V_AFACCTNO and custodycd like V_CUSTODYCD) mr
                ON ci.afacctno=mr.acctno
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
                SELECT A.ACCTNO,round(sum(A.TOTALLOAN)) TOTALLOAN from
                (
                SELECT AF.ACCTNO,/*ROUND*/(SCHD.INTOVDPRIN + SCHD.FEEINTOVDACR+LN.INTNMLPBL+ --THEM DU TINH LAI BAO LANH MSBS-1264
                SCHD.INTNMLACR  + SCHD.INTOVD + SCHD.INTDUE + SCHD.FEEINTNMLACR + SCHD.FEEINTDUE + SCHD.FEEINTNMLOVD+SCHD.NML + SCHD.OVD) TOTALLOAN
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
    order by CI.afacctno)

    UNION ALL

    select * from (select a.*, rownum r from (
    SELECT * FROM
    (
        SELECT CI.*, NVL(CA.AMT, 0) careceiving,ci.OVDCIDEPOFEE + nvl(LN.TOTALLOAN,0) TOTALLOAN, nvl(mr.ADDVND,0) ADDVND
            FROM
                (
                    select afacctno,desc_status,ROUND(pp) PP,ROUND(balance) BALANCE,ROUND(advanceline) advanceline,
                        ROUND(baldefovd) baldefovd, /*ROUND(avlwithdraw)*/ ROUND(least(avlwithdraw,fn_getfowithdraw(ci.AFACCTNO))) avlwithdraw,
                        ROUND(AVLADV_T3+AVLADV_T1+AVLADV_T2) avladvance,ROUND(aamt) AAMT,ROUND(bamt) BAMT,
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
                        ci.marginrate_ex,
                        ADVANCELINE GUA,ci.OVDCIDEPOFEE
                    from buf_ci_account ci
                    where ci.custodycd like V_CUSTODYCD
                        AND ci.afacctno LIKE V_AFACCTNO
                        AND EXISTS(SELECT cf.custodycd, af.acctno afacctno
                                    FROM afmast af, otright ot, cfmast cf
                                    WHERE CI.AFACCTNO = AF.ACCTNO AND af.custid = cf.custid
                                        AND ot.authcustid = ot.cfcustid AND af.custid = ot.authcustid
                                        --AND af.status = 'A'
                                        AND ot.deltd = 'N'
                                        AND ot.valdate <= V_CURRDATE AND ot.expdate >= V_CURRDATE
                                        AND CF.custodycd like V_CUSTODYCD
                                        AND AF.acctno LIKE V_AFACCTNO)
                ) CI
                 left join
                ( select ADDVND,acctno from vw_mr0003 where acctno like V_AFACCTNO and custodycd like V_CUSTODYCD) mr
                ON ci.afacctno=mr.acctno
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
                SELECT A.ACCTNO,round(sum(A.TOTALLOAN)) TOTALLOAN from
                (
                SELECT AF.ACCTNO,/*ROUND*/(SCHD.INTOVDPRIN +LN.INTNMLPBL+ --THEM DU TINH LAI BAO LANH MSBS-1264
                 SCHD.FEEINTOVDACR+SCHD.INTNMLACR  + SCHD.INTOVD + SCHD.INTDUE + SCHD.FEEINTNMLACR + SCHD.FEEINTDUE + SCHD.FEEINTNMLOVD+SCHD.NML + SCHD.OVD) TOTALLOAN
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
         order by ci.afacctno)
    ) a where rownum <= ROWS_RPP * PAGE_RPP) where r > ROWS_RPP * (PAGE_RPP - 1);

    else
      if  PAGE_RPP = 0 then
       Open p_refcursor FOR
       select * from (select a.*, rownum r from (
       SELECT * FROM
       (
        SELECT CI.*, NVL(CA.AMT, 0) careceiving,ci.OVDCIDEPOFEE+ nvl(LN.TOTALLOAN,0) TOTALLOAN, nvl(mr.ADDVND,0) ADDVND
            FROM
                (
                    select afacctno,desc_status,ROUND(pp) PP,ROUND(balance) BALANCE,ROUND(advanceline) advanceline,
                        ROUND(baldefovd) baldefovd, /*ROUND(avlwithdraw)*/ ROUND(least(avlwithdraw,fn_getfowithdraw(ci.AFACCTNO))) avlwithdraw,
                        ROUND(AVLADV_T3+AVLADV_T1+AVLADV_T2) avladvance,ROUND(aamt) AAMT,ROUND(bamt) BAMT,
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
                        ci.marginrate_ex,
                        ADVANCELINE GUA,ci.OVDCIDEPOFEE
                    from buf_ci_account ci
                    where ci.custodycd like V_CUSTODYCD
                        AND ci.afacctno LIKE V_AFACCTNO
                        AND EXISTS(SELECT cf.custodycd, af.acctno afacctno
                                    FROM afmast af, otright ot, cfmast cf
                                    WHERE CI.AFACCTNO = AF.ACCTNO AND af.custid = cf.custid
                                        AND ot.authcustid = ot.cfcustid AND af.custid = ot.authcustid
                                        --AND af.status = 'A'
                                        AND ot.deltd = 'N'
                                        AND ot.valdate <= V_CURRDATE AND ot.expdate >= V_CURRDATE
                                        AND CF.custodycd like V_CUSTODYCD
                                        AND AF.acctno LIKE V_AFACCTNO)
                ) CI
                 left join
                ( select ADDVND,acctno from vw_mr0003 where acctno like V_AFACCTNO and custodycd like V_CUSTODYCD) mr
                ON ci.afacctno=mr.acctno
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
                SELECT A.ACCTNO,round(sum(A.TOTALLOAN)) TOTALLOAN from
                (
                SELECT AF.ACCTNO,/*ROUND*/(SCHD.INTOVDPRIN +LN.INTNMLPBL+ --THEM DU TINH LAI BAO LANH MSBS-1264
                 SCHD.FEEINTOVDACR+SCHD.INTNMLACR  + SCHD.INTOVD + SCHD.INTDUE + SCHD.FEEINTNMLACR + SCHD.FEEINTDUE + SCHD.FEEINTNMLOVD+SCHD.NML + SCHD.OVD) TOTALLOAN
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
         order by ci.afacctno)
        ) a );
    else
        Open p_refcursor FOR
        select * from (select a.*, rownum r from (
        SELECT * FROM
        (
        SELECT CI.*, NVL(CA.AMT, 0) careceiving,ci.OVDCIDEPOFEE+ nvl(LN.TOTALLOAN,0) TOTALLOAN, nvl(mr.ADDVND,0) ADDVND
            FROM
                (
                    select afacctno,desc_status,ROUND(pp) PP,ROUND(balance) BALANCE,ROUND(advanceline) advanceline,
                        ROUND(baldefovd) baldefovd, /*ROUND(avlwithdraw)*/ ROUND(least(avlwithdraw,fn_getfowithdraw(ci.AFACCTNO))) avlwithdraw,
                        ROUND(AVLADV_T3+AVLADV_T1+AVLADV_T2) avladvance,ROUND(aamt) AAMT,ROUND(bamt) BAMT,
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
                        ci.marginrate_ex,
                        ADVANCELINE GUA,ci.OVDCIDEPOFEE
                    from buf_ci_account ci
                    where ci.custodycd like V_CUSTODYCD
                        AND ci.afacctno LIKE V_AFACCTNO
                        AND EXISTS(SELECT cf.custodycd, af.acctno afacctno
                                    FROM afmast af, otright ot, cfmast cf
                                    WHERE CI.AFACCTNO = AF.ACCTNO AND af.custid = cf.custid
                                        AND ot.authcustid = ot.cfcustid AND af.custid = ot.authcustid
                                        --AND af.status = 'A'
                                        AND ot.deltd = 'N'
                                        AND ot.valdate <= V_CURRDATE AND ot.expdate >= V_CURRDATE
                                        AND CF.custodycd like V_CUSTODYCD
                                        AND AF.acctno LIKE V_AFACCTNO)
                ) CI
                 left join
                ( select ADDVND,acctno from vw_mr0003 where acctno like V_AFACCTNO and custodycd like V_CUSTODYCD) mr
                ON ci.afacctno=mr.acctno
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
                SELECT A.ACCTNO,round(sum(A.TOTALLOAN)) TOTALLOAN from
                (
                SELECT AF.ACCTNO,/*ROUND*/(SCHD.INTOVDPRIN +LN.INTNMLPBL+ --THEM DU TINH LAI BAO LANH MSBS-1264
                 SCHD.FEEINTOVDACR+SCHD.INTNMLACR  + SCHD.INTOVD + SCHD.INTDUE + SCHD.FEEINTNMLACR + SCHD.FEEINTDUE + SCHD.FEEINTNMLOVD+SCHD.NML + SCHD.OVD) TOTALLOAN
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
         order by ci.afacctno)
       ) a where rownum <= ROWS_RPP * PAGE_RPP) where r > ROWS_RPP * (PAGE_RPP - 1);
       end if;
    end if;

    plog.setendsection(pkgctx, 'pr_get_ciacount');

exception when others then
      plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'pr_get_ciacount');
end pr_get_ciacount;

procedure pr_get_AfInfoToOrder
    (p_refcursor in out pkg_report.ref_cursor,
    p_afacctno  IN  VARCHAR2,
    p_symbol IN VARCHAR2,
    p_price IN VARCHAR2)
IS
    V_CUSTODYCD     varchar2(10);
    V_AFACCTNO      varchar2(10);
    V_CURRDATE      DATE;

    v_ppse  number;
    v_ppsemin number;
    v_trademax number;
    v_trademin number;
    V_CEILINGPRICE number;

    v_RMA number(5,2);
    v_marginrate number(20,4);

    v_receiving number;
    v_sellqtty number;
    V_PRICE NUMBER;
begin
    plog.setbeginsection(pkgctx, 'pr_get_AfInfoToOrder');

    IF p_afacctno = 'ALL' OR p_afacctno IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := p_afacctno;
        SELECT CF.CUSTODYCD INTO V_CUSTODYCD
        FROM AFMAST AF, CFMAST CF
        WHERE AF.custid = CF.custid AND AF.ACCTNO = p_afacctno;
    END IF;


    -- GET CURRENT DATE
    select to_date(VARVALUE,'DD/MM/rrrr') into v_currdate from sysvar where grname='SYSTEM' and varname='CURRDATE';

    v_RMA:=0;

    BEGIN

        SELECT SEC.MRRATIOLOAN INTO v_RMA
        FROM AFMAST AF, AFTYPE AFT, LNTYPE LN, LNSEBASKET LNS, SECBASKET SEC
        WHERE AF.ACTYPE=AFT.ACTYPE
              AND AFT.LNTYPE=LN.ACTYPE
              AND LN.ACTYPE=LNS.ACTYPE
              AND LNS.BASKETID=SEC.BASKETID
              AND SEC.SYMBOL LIKE p_symbol
              AND AF.ACCTNO LIKE V_AFACCTNO;

    Exception when others then
         v_RMA:=0;
    END;

     Begin
          select SE.CEILINGPRICE INTO V_CEILINGPRICE from SECURITIES_INFO se
          where se.SYMBOL LIKE p_symbol;
    Exception when others then
         V_CEILINGPRICE:=0;
     End;

     V_PRICE:=NVL(p_price,0);
    v_ppse:= greatest(fn_getppse_RPP(p_afacctno,p_symbol, V_PRICE,'O','1'),0);
    if V_PRICE>0 then
      v_ppsemin:= greatest(fn_getppse_RPP(p_afacctno,p_symbol, V_PRICE,'O','1'),0);
    else
    v_ppsemin:= greatest(fn_getppse_RPP(p_afacctno,p_symbol, V_CEILINGPRICE,'O','1'),0);
    end if;
    v_trademax:=greatest(fn_getppse_RPP(p_afacctno,p_symbol, V_PRICE,'O','0'),0);
    v_trademin:=greatest(fn_getppse_RPP(p_afacctno,p_symbol, V_CEILINGPRICE,'O','0'),0);

    Begin
          SELECT   nvl(max(MARGINRATE),0) into v_marginrate
          From buf_ci_account ci where ci.custodycd = V_CUSTODYCD AND ci.afacctno LIKE V_AFACCTNO;
    Exception when others then
         v_marginrate:=0;
     End;


    Begin
           select nvl(sum(securities_receiving_t0+securities_receiving_t1+securities_receiving_t2),0) receiving,
                 nvl( sum(trade),0) sell_qtty into v_receiving, v_sellqtty
          from buf_se_account se, sbsecurities sb
          where se.codeid = sb.codeid
                  AND se.custodycd = V_CUSTODYCD
                  AND se.afacctno LIKE V_AFACCTNO
                  AND  total_qtty+deal_qtty+abstanding+securities_receiving_t0+securities_receiving_t1+securities_receiving_t2
                      +securities_receiving_t3+securities_sending_t0+securities_sending_t1+securities_sending_t2+securities_sending_t3+RESTRICTQTTY+dftrading <> 0
                  and sb.symbol like p_symbol;
    Exception when others then
           v_receiving:=0;
           v_sellqtty:=0;
       End;

   Open p_refcursor for
    select
          v_ppse SM_MAX,--suc mua
          v_ppsemin SM_MIN,  --Suc mua tinh theo gia tran
          v_RMA TLV,-- Ti le vay
          v_marginrate RTT,-- Rtt
          v_trademax KLDM_MAX,-- khoi luong dc mua MAX
          v_trademin KLDM_MIN,-- khoi luong dc mua MIN
          v_sellqtty KLDB,-- khoi luong dc ban
          v_receiving CV -- Cho ve
    from dual;

    plog.setendsection(pkgctx, 'pr_get_AfInfoToOrder');
exception when others then
       plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'pr_get_AfInfoToOrder');
end pr_get_AfInfoToOrder;

procedure pr_get_AfInfoToOrder_PB
    (p_refcursor in out pkg_report.ref_cursor,
    p_afacctno  IN  VARCHAR2,
    p_symbol IN VARCHAR2,
    p_price IN VARCHAR2)
IS
    V_CUSTODYCD     varchar2(10);
    V_AFACCTNO      varchar2(10);
    V_CURRDATE      DATE;

    v_ppse  number;
    v_ppsemin number;
    v_trademax number;
    v_trademin number;
    V_CEILINGPRICE number;

    v_RMA number(5,2);
    v_marginrate number(20,4);

    v_receiving number;
    v_sellqtty number;
    V_PRICE NUMBER;
begin
    plog.setbeginsection(pkgctx, 'pr_get_AfInfoToOrder_PB');

    IF p_afacctno = 'ALL' OR p_afacctno IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := p_afacctno;
        SELECT CF.CUSTODYCD INTO V_CUSTODYCD
        FROM AFMAST AF, CFMAST CF
        WHERE AF.custid = CF.custid AND AF.ACCTNO = p_afacctno;
    END IF;


    -- GET CURRENT DATE
    select to_date(VARVALUE,'DD/MM/rrrr') into v_currdate from sysvar where grname='SYSTEM' and varname='CURRDATE';

    Begin
          select SE.CEILINGPRICE INTO V_CEILINGPRICE from SECURITIES_INFO se
          where se.SYMBOL LIKE p_symbol;
    Exception when others then
         V_CEILINGPRICE:=0;
    End;

     V_PRICE:=NVL(p_price,0);
    v_ppse:= greatest(fn_getppse_RPP(p_afacctno,p_symbol, V_PRICE,'O','1'),0);
    if V_PRICE>0 then
      v_ppsemin:= greatest(fn_getppse_RPP(p_afacctno,p_symbol, V_PRICE,'O','1'),0);
    else
    v_ppsemin:= greatest(fn_getppse_RPP(p_afacctno,p_symbol, V_CEILINGPRICE,'O','1'),0);
    end if;

   Open p_refcursor for
    select
          v_ppse SM_MAX,--suc mua
          v_ppsemin SM_MIN  --Suc mua tinh theo gia tran
    from dual;

    plog.setendsection(pkgctx, 'pr_get_AfInfoToOrder_PB');
exception when others then
       plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'pr_get_AfInfoToOrder_PB');
end pr_get_AfInfoToOrder_PB;

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
     STATUS         IN  VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER)
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
    if PAGE_RPP = 0 then
    OPEN p_REFCURSOR FOR

     select * from (select a.*, rownum r from (
        SELECT OD.AFACCTNO, OD.ORDERID, OD.TXDATE, SB.SYMBOL, --A1.CDCONTENT TRADEPLACE,
         A2.CDCONTENT VIA, A2.EN_CDCONTENT EN_VIA, A4.CDCONTENT EXECTYPE, A4.EN_CDCONTENT EN_EXECTYPE,
         OD.ORDERQTTY, (CASE WHEN OD.PRICETYPE IN ('ATO','ATC','MP','MTL','MOK','MAK','SBO','OBO') THEN TO_CHAR(OD.PRICETYPE) ELSE TO_CHAR(OD.QUOTEPRICE) END) QUOTEPRICE,
         OD.EXECQTTY, CASE WHEN OD.EXECQTTY>0 THEN ROUND(OD.EXECAMT/OD.EXECQTTY) ELSE 0 END EXECPRICE, OD.EXECAMT,
         A3.CDCONTENT ORSTATUS, A3.EN_CDCONTENT EN_ORSTATUS, --A3.CDVAL ORSTATUSCD,
         CASE WHEN OD.EXECAMT >0 AND OD.FEEACR =0 AND OD.STSSTATUS = 'N' THEN round(OD.EXECAMT*ODT.DEFFEERATE/100)
                WHEN OD.EXECAMT >0 AND OD.FEEACR >0 THEN round(OD.FEEACR)
                when od.txdate = v_currdate then round((OD.REMAINQTTY*OD.QUOTEPRICE + OD.EXECAMT)*ODT.DEFFEERATE/100)
                else 0 END FEEACR, --'' CMSFEE,
                CASE WHEN OD.EXECAMT >0 AND INSTR(OD.EXECTYPE,'S')>0 AND OD.STSSTATUS = 'N'
                            THEN CASE WHEN AFT.VAT = 'Y' THEN ROUND(OD.EXECAMT*TO_NUMBER(SYS.VARVALUE)/100) ELSE 0 END ELSE ROUND(OD.EXECAMT*OD.TAXRATE/100) END SELLTAXAMT/*, --1.5.8.0 MSBS-1955
            round(CASE WHEN OD.EXECAMT >0 AND OD.FEEACR =0 AND OD.STSSTATUS = 'N' THEN ODT.DEFFEERATE
                WHEN OD.EXECAMT >0 AND OD.FEEACR >0 THEN OD.FEEACR/OD.EXECAMT*100 ELSE ODT.DEFFEERATE END,4) FEERATE ,
                OD.QUOTEQTTY,OD.CONFIRMED*/
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
                ) OD, SBSECURITIES SB, AFMAST AF, ALLCODE A1, ALLCODE A2, ALLCODE A3, ALLCODE A4, SYSVAR SYS , ODTYPE ODT, AFTYPE AFT --1.5.8.0 MSBS-1955
        WHERE OD.CODEID=SB.CODEID AND AF.ACCTNO = OD.AFACCTNO
            AND OD.ACTYPE = ODT.ACTYPE  AND AF.ACTYPE = AFT.ACTYPE  --1.5.8.0 MSBS-1955
            AND A1.CDTYPE = 'SE' AND A1.CDNAME = 'TRADEPLACE' AND A1.CDVAL = SB.TRADEPLACE
            AND A2.CDTYPE = 'SA' AND A2.CDNAME = 'VIA' AND A2.CDVAL = OD.VIA
            AND A3.CDTYPE = 'OD' AND A3.CDNAME = 'ORSTATUS' AND A3.CDVAL = OD.ORSTATUSVALUE
            AND A4.CDTYPE = 'OD' AND A4.CDNAME = 'EXECTYPE' AND A4.CDVAL = OD.EXECTYPE
            AND SYS.GRNAME = 'SYSTEM' AND SYS.VARNAME = 'ADVSELLDUTY'
            AND AF.CUSTID LIKE V_CUSTID
            AND AF.ACCTNO LIKE V_AFACCTNO
            AND SB.SYMBOL LIKE V_SYMBOL
            AND OD.ORSTATUSVALUE LIKE V_STATUS
            AND OD.EXECTYPE LIKE V_EXECTYPE
            AND OD.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
            AND OD.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
        ORDER BY OD.TXDATE DESC, SUBSTR(OD.ORDERID,11,6) DESC
        ) a);
    else
    OPEN p_REFCURSOR FOR

    select '' AFACCTNO, '' ORDERID, null TXDATE, '' SYMBOL, '' VIA, '' EN_VIA, '' EXECTYPE, '' EN_EXECTYPE, 0 ORDERQTTY,
        '0' QUOTEPRICE, sum(EXECQTTY) EXECQTTY, 0 EXECPRICE, sum(EXECAMT) EXECAMT, '' ORSTATUS, '' EN_ORSTATUS, sum(FEEACR) FEEACR, sum(SELLTAXAMT) SELLTAXAMT,  0 r from (
    --select * from (select a.*, rownum r from (
        SELECT OD.AFACCTNO, OD.ORDERID, OD.TXDATE, SB.SYMBOL, --A1.CDCONTENT TRADEPLACE,
         A2.CDCONTENT VIA, A2.EN_CDCONTENT EN_VIA, A4.CDCONTENT EXECTYPE, A4.EN_CDCONTENT EN_EXECTYPE,
         OD.ORDERQTTY, (CASE WHEN OD.PRICETYPE IN ('ATO','ATC','MP','MTL','MOK','MAK','SBO','OBO') THEN TO_CHAR(OD.PRICETYPE) ELSE TO_CHAR(OD.QUOTEPRICE) END) QUOTEPRICE,
         OD.EXECQTTY, CASE WHEN OD.EXECQTTY>0 THEN ROUND(OD.EXECAMT/OD.EXECQTTY) ELSE 0 END EXECPRICE, OD.EXECAMT,
         A3.CDCONTENT ORSTATUS, A3.EN_CDCONTENT EN_ORSTATUS, --A3.CDVAL ORSTATUSCD,
         CASE WHEN OD.EXECAMT >0 AND OD.FEEACR =0 AND OD.STSSTATUS = 'N' THEN round(OD.EXECAMT*ODT.DEFFEERATE/100)
                WHEN OD.EXECAMT >0 AND OD.FEEACR >0 THEN round(OD.FEEACR)
                when od.txdate = v_currdate then round((OD.REMAINQTTY*OD.QUOTEPRICE + OD.EXECAMT)*ODT.DEFFEERATE/100)
                else 0 END FEEACR, --'' CMSFEE,
                CASE WHEN OD.EXECAMT >0 AND INSTR(OD.EXECTYPE,'S')>0 AND OD.STSSTATUS = 'N'
                            THEN CASE WHEN AFT.VAT = 'Y' THEN ROUND(OD.EXECAMT*TO_NUMBER(SYS.VARVALUE)/100) ELSE 0 END ELSE ROUND(OD.EXECAMT*OD.TAXRATE/100) END SELLTAXAMT/*, --1.5.8.0 MSBS-1955
            round(CASE WHEN OD.EXECAMT >0 AND OD.FEEACR =0 AND OD.STSSTATUS = 'N' THEN ODT.DEFFEERATE
                WHEN OD.EXECAMT >0 AND OD.FEEACR >0 THEN OD.FEEACR/OD.EXECAMT*100 ELSE ODT.DEFFEERATE END,4) FEERATE ,
                OD.QUOTEQTTY,OD.CONFIRMED*/
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
                ) OD, SBSECURITIES SB, AFMAST AF, ALLCODE A1, ALLCODE A2, ALLCODE A3, ALLCODE A4, SYSVAR SYS , ODTYPE ODT, AFTYPE AFT --1.5.8.0 MSBS-1955
        WHERE OD.CODEID=SB.CODEID AND AF.ACCTNO = OD.AFACCTNO
            AND OD.ACTYPE = ODT.ACTYPE AND AF.ACTYPE = AFT.ACTYPE  --1.5.8.0 MSBS-1955
            AND A1.CDTYPE = 'SE' AND A1.CDNAME = 'TRADEPLACE' AND A1.CDVAL = SB.TRADEPLACE
            AND A2.CDTYPE = 'SA' AND A2.CDNAME = 'VIA' AND A2.CDVAL = OD.VIA
            AND A3.CDTYPE = 'OD' AND A3.CDNAME = 'ORSTATUS' AND A3.CDVAL = OD.ORSTATUSVALUE
            AND A4.CDTYPE = 'OD' AND A4.CDNAME = 'EXECTYPE' AND A4.CDVAL = OD.EXECTYPE
            AND SYS.GRNAME = 'SYSTEM' AND SYS.VARNAME = 'ADVSELLDUTY'
            AND AF.CUSTID LIKE V_CUSTID
            AND AF.ACCTNO LIKE V_AFACCTNO
            AND SB.SYMBOL LIKE V_SYMBOL
            AND OD.ORSTATUSVALUE LIKE V_STATUS
            AND OD.EXECTYPE LIKE V_EXECTYPE
            AND OD.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
            AND OD.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
        ORDER BY OD.TXDATE DESC, SUBSTR(OD.ORDERID,11,6) DESC
        ) a
UNION ALL

     select * from (select a.*, rownum r from (
        SELECT OD.AFACCTNO, OD.ORDERID, OD.TXDATE, SB.SYMBOL, --A1.CDCONTENT TRADEPLACE,
         A2.CDCONTENT VIA, A2.EN_CDCONTENT EN_VIA, A4.CDCONTENT EXECTYPE, A4.EN_CDCONTENT EN_EXECTYPE,
         OD.ORDERQTTY, (CASE WHEN OD.PRICETYPE IN ('ATO','ATC','MP','MTL','MOK','MAK','SBO','OBO') THEN TO_CHAR(OD.PRICETYPE) ELSE TO_CHAR(OD.QUOTEPRICE) END) QUOTEPRICE,
         OD.EXECQTTY, CASE WHEN OD.EXECQTTY>0 THEN ROUND(OD.EXECAMT/OD.EXECQTTY) ELSE 0 END EXECPRICE, OD.EXECAMT,
         A3.CDCONTENT ORSTATUS, A3.EN_CDCONTENT EN_ORSTATUS, --A3.CDVAL ORSTATUSCD,
         CASE WHEN OD.EXECAMT >0 AND OD.FEEACR =0 AND OD.STSSTATUS = 'N' THEN round(OD.EXECAMT*ODT.DEFFEERATE/100)
                WHEN OD.EXECAMT >0 AND OD.FEEACR >0 THEN round(OD.FEEACR)
                when od.txdate = v_currdate then round((OD.REMAINQTTY*OD.QUOTEPRICE + OD.EXECAMT)*ODT.DEFFEERATE/100)
                else 0 END FEEACR, --'' CMSFEE,
                CASE WHEN OD.EXECAMT >0 AND INSTR(OD.EXECTYPE,'S')>0 AND OD.STSSTATUS = 'N'
                            THEN CASE WHEN AFT.VAT = 'Y' THEN ROUND(OD.EXECAMT*TO_NUMBER(SYS.VARVALUE)/100) ELSE 0 END ELSE ROUND(OD.EXECAMT*OD.TAXRATE/100) END SELLTAXAMT/*, --1.5.8.0 MSBS-1955
            round(CASE WHEN OD.EXECAMT >0 AND OD.FEEACR =0 AND OD.STSSTATUS = 'N' THEN ODT.DEFFEERATE
                WHEN OD.EXECAMT >0 AND OD.FEEACR >0 THEN OD.FEEACR/OD.EXECAMT*100 ELSE ODT.DEFFEERATE END,4) FEERATE ,
                OD.QUOTEQTTY,OD.CONFIRMED*/
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
                ) OD, SBSECURITIES SB, AFMAST AF, ALLCODE A1, ALLCODE A2, ALLCODE A3, ALLCODE A4, SYSVAR SYS , ODTYPE ODT, AFTYPE AFT --1.5.8.0 MSBS-1955
        WHERE OD.CODEID=SB.CODEID AND AF.ACCTNO = OD.AFACCTNO
            AND OD.ACTYPE = ODT.ACTYPE AND AF.ACTYPE = AFT.ACTYPE  --1.5.8.0 MSBS-1955
            AND A1.CDTYPE = 'SE' AND A1.CDNAME = 'TRADEPLACE' AND A1.CDVAL = SB.TRADEPLACE
            AND A2.CDTYPE = 'SA' AND A2.CDNAME = 'VIA' AND A2.CDVAL = OD.VIA
            AND A3.CDTYPE = 'OD' AND A3.CDNAME = 'ORSTATUS' AND A3.CDVAL = OD.ORSTATUSVALUE
            AND A4.CDTYPE = 'OD' AND A4.CDNAME = 'EXECTYPE' AND A4.CDVAL = OD.EXECTYPE
            AND SYS.GRNAME = 'SYSTEM' AND SYS.VARNAME = 'ADVSELLDUTY'
            AND AF.CUSTID LIKE V_CUSTID
            AND AF.ACCTNO LIKE V_AFACCTNO
            AND SB.SYMBOL LIKE V_SYMBOL
            AND OD.ORSTATUSVALUE LIKE V_STATUS
            AND OD.EXECTYPE LIKE V_EXECTYPE
            AND OD.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
            AND OD.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
        ORDER BY OD.TXDATE DESC, SUBSTR(OD.ORDERID,11,6) DESC
        ) a where rownum <= ROWS_RPP * PAGE_RPP) where r > ROWS_RPP * (PAGE_RPP - 1);
end if;

EXCEPTION
  WHEN OTHERS THEN
     plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'pr_GetOrder');
END pr_GetOrder;


-- Lay thong tin sao ke tien
-- TheNN, 11-Jan-2012
PROCEDURE pr_GetCashStatement
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN       VARCHAR2,
     T_DATE         IN       VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
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

if PAGE_RPP = 0 then
    OPEN p_REFCURSOR FOR
      select * from (select a.*, rownum r from (
        select  tr.afacctno, tr.busdate,tr.txnum,tr.tltxcd,
            ROUND(nvl(ci_credit_amt,0)) ci_credit_amt, ROUND(nvl(ci_debit_amt,0)) ci_debit_amt,
            case when tr.tltxcd = '1143' and tr.txcd = '0077' then 'So tien den han phai thanh toan'
                 when tr.tltxcd in ('1143','1153') and tr.txcd = '0011' and tr.trdesc is null then 'Phi ung truoc'
                 else to_char(tr.txdesc)
            end txdesc,
            ROUND(ci.ci_balance - nvl(ci_move_fromdt.ci_total_move_frdt_amt,0))  ci_begin_bal
        from
        (
            -- Tong so du CI hien tai group by TK luu ky
            select ci.afacctno, ci.intbalance ci_balance
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
            -- Tong phat sinh CI tu From date den ngay hom nay
            select tr.acctno,
                sum(case when tr.txtype = 'D' then -tr.namt else tr.namt end) ci_total_move_frdt_amt
            from vw_CITRAN_gen tr
            where
               tr.busdate >= v_FromDate and tr.busdate <= v_CurrDate
                and tr.acctno =v_AFAcctno
                and tr.field in ('BALANCE')
            group by tr.acctno
        ) ci_move_fromdt on ci.afacctno = ci_move_fromdt.acctno

        --order by tr.busdate, tr.txorder, tr.autoid, tr.txtype,tr.txnum;      -- Chu y: Khong thay doi thu tu Order by
        order by tr.busdate, tr.autoid, tr.txnum, tr.txtype, tr.orderid
        ,case when tr.tltxcd = '1143' and tr.txcd = '0077' then 'So tien den han phai thanh toan '
              when tr.tltxcd in ('1143','1153') and tr.txcd = '0011' and tr.trdesc is null then 'Phi ung truoc '
              else to_char(tr.txdesc) end
              ) a);

else
OPEN p_REFCURSOR FOR
      select * from (select a.*, rownum r from (
        select  tr.afacctno, tr.busdate,tr.txnum,tr.tltxcd,
            ROUND(nvl(ci_credit_amt,0)) ci_credit_amt, ROUND(nvl(ci_debit_amt,0)) ci_debit_amt,
            case when tr.tltxcd = '1143' and tr.txcd = '0077' then 'So tien den han phai thanh toan'
                 when tr.tltxcd in ('1143','1153') and tr.txcd = '0011' and tr.trdesc is null then 'Phi ung truoc'
                 else to_char(tr.txdesc)
            end txdesc,
            ROUND(ci.ci_balance - nvl(ci_move_fromdt.ci_total_move_frdt_amt,0))  ci_begin_bal
        from
        (
            -- Tong so du CI hien tai group by TK luu ky
            select ci.afacctno, ci.intbalance ci_balance
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
            -- Tong phat sinh CI tu From date den ngay hom nay
            select tr.acctno,
                sum(case when tr.txtype = 'D' then -tr.namt else tr.namt end) ci_total_move_frdt_amt
            from vw_CITRAN_gen tr
            where
               tr.busdate >= v_FromDate and tr.busdate <= v_CurrDate
                and tr.acctno =v_AFAcctno
                and tr.field in ('BALANCE')
            group by tr.acctno
        ) ci_move_fromdt on ci.afacctno = ci_move_fromdt.acctno

        --order by tr.busdate, tr.txorder, tr.autoid, tr.txtype,tr.txnum;      -- Chu y: Khong thay doi thu tu Order by
        order by tr.busdate, tr.autoid, tr.txnum, tr.txtype, tr.orderid
        ,case when tr.tltxcd = '1143' and tr.txcd = '0077' then 'So tien den han phai thanh toan '
              when tr.tltxcd in ('1143','1153') and tr.txcd = '0011' and tr.trdesc is null then 'Phi ung truoc '
              else to_char(tr.txdesc) end
              ) a where rownum <= ROWS_RPP * PAGE_RPP
              ) where r > ROWS_RPP * (PAGE_RPP - 1);

end if;
EXCEPTION
  WHEN OTHERS THEN
     plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'pr_GetCashStatement');
END pr_GetCashStatement;


-- Lay thong tin sao ke chung khoan
-- TheNN, 11-Jan-2012
PROCEDURE pr_GetSecuritiesStatement
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     SYMBOL         IN  VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
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

    IF SYMBOL = 'ALL' OR SYMBOL IS NULL THEN
        V_SYMBOL := '%%';
    ELSE
       V_SYMBOL := UPPER(SYMBOL);
    end if;

if PAGE_RPP = 0 then
OPEN p_REFCURSOR FOR
     select * from ( select a.* , rownum r
     from (
        select AF.ACCTNO AFACCTNO,
            tr.busdate, nvl(tr.symbol,' ') tran_symbol,
            nvl(se_credit_amt,0) se_credit_amt, nvl(se_debit_amt,0) se_debit_amt,
            to_char(tr.txdesc) txdesc, tr.type_transact
        from (SELECT * from afmast af WHERE af.acctno = v_AFAcctno) af
        left join
        (
            -- Toan bo phat sinh CK tu FromDate den Todate
            select tse.custid, tse.custodycd, tse.afacctno, max(tse.tllog_autoid) autoid, max(tse.txtype) txtype, max(tse.txcd) txcd , max(tse.autoid) orderid,
                tse.busdate, max(nvl(tse.trdesc,tse.txdesc)) txdesc, to_char(max(tse.symbol)) symbol,
                sum(case when tse.txtype = 'C' then tse.namt else 0 end) se_credit_amt,
                sum(case when tse.txtype = 'D' then tse.namt else 0 end) se_debit_amt,
                0 ci_credit_amt, 0 ci_debit_amt,
                max(tse.tltxcd) tltxcd, max(tse.trdesc) trdesc, max(tl.TXDESC) type_transact
            from vw_setran_gen tse, tltx tl
            where tse.busdate between v_FromDate and v_ToDate
                and tse.afacctno = v_AFAcctno
                and tse.field in ('TRADE','MORTAGE','BLOCKED')
                and sectype <> '004'
                 and tse.tltxcd=tl.tltxcd --ngoc.vu them truong loai giao dich
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
                end
                ) a);
else
    OPEN p_REFCURSOR FOR
     select * from ( select a.* , rownum r
     from (
        select AF.ACCTNO AFACCTNO,
            tr.busdate, nvl(tr.symbol,' ') tran_symbol,
            nvl(se_credit_amt,0) se_credit_amt, nvl(se_debit_amt,0) se_debit_amt,
            to_char(tr.txdesc) txdesc,  tr.type_transact
        from (SELECT * from afmast af WHERE af.acctno = v_AFAcctno) af
        left join
        (
            -- Toan bo phat sinh CK tu FromDate den Todate
            select tse.custid, tse.custodycd, tse.afacctno, max(tse.tllog_autoid) autoid, max(tse.txtype) txtype, max(tse.txcd) txcd , max(tse.autoid) orderid,
                tse.busdate, max(nvl(tse.trdesc,tse.txdesc)) txdesc, to_char(max(tse.symbol)) symbol,
                sum(case when tse.txtype = 'C' then tse.namt else 0 end) se_credit_amt,
                sum(case when tse.txtype = 'D' then tse.namt else 0 end) se_debit_amt,
                0 ci_credit_amt, 0 ci_debit_amt,
                max(tse.tltxcd) tltxcd, max(tse.trdesc) trdesc, max(tl.TXDESC) type_transact
            from vw_setran_gen tse,tltx tl
            where tse.busdate between v_FromDate and v_ToDate
                and tse.afacctno = v_AFAcctno
                and tse.field in ('TRADE','MORTAGE','BLOCKED')
                and sectype <> '004'
                 and tse.tltxcd=tl.tltxcd --ngoc.vu them truong loai giao dich
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
                end
                ) a where rownum <= ROWS_RPP * PAGE_RPP) where r > ROWS_RPP * (PAGE_RPP - 1);
end if;

EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
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
     STATUS         IN  VARCHAR2,
     VIA         IN  VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER)
    IS

    V_CUSTODYCD   VARCHAR2(10);
    V_AFACCTNO    VARCHAR2(10);
    V_CUSTID      VARCHAR2(10);
    V_STATUS      VARCHAR2(2);
    V_VIA      VARCHAR2(2);

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

    IF VIA = 'ALL' OR VIA IS NULL THEN
        V_VIA := '%%';
    ELSE
        V_VIA := VIA;
    END IF;

    -- LAY THONG TIN MA KHACH HANG
    IF V_CUSTODYCD = 'ALL' OR V_CUSTODYCD IS NULL THEN
        V_CUSTID := '%%';
    ELSE
        SELECT CUSTID INTO V_CUSTID FROM CFMAST WHERE CUSTODYCD = V_CUSTODYCD;
    END IF;


    -- LAY THONG TIN GD CHUYEN KHOAN
  if PAGE_RPP = 0 then
    OPEN p_REFCURSOR FOR
     select * from (select a.*, rownum r from (
        SELECT *
        FROM
        (
            -- CHUYEN KHOAN RA NGOAI
            SELECT TLG.TXDATE,TLG.TXNUM, TLG.NAMT TRFAMT, A1.CDCONTENT STATUS,
                   A1.EN_CDCONTENT EN_STATUS, DECODE(TLG.TLTXCD, '1120', '',CIR.BENEFBANK) BENEFBANK,
                   case when TLG.TLTXCD IN ('1201') THEN 'KBSV'  ELSE CIR.BENEFCUSTNAME end RECVFULLNAME,
                    CIR.BENEFACCT RECVAFACCTNO,
                   A2.CDCONTENT VIA, A2.EN_CDCONTENT EN_VIA, TLG.TXDESC, 
                   CIR.BENEFLICENSE, CIR.CITYBANK, CIR.CITYEF,
                 case when CIR.RMSTATUS in('E','W','M') then 'P' else CIR.RMSTATUS END RMSTATUS ,
                    CASE  WHEN TLG.TLTXCD IN ('1120') THEN '1'
                     WHEN TLG.TLTXCD IN ('1101','1108','1111','1185') THEN '2'
                     WHEN TLG.TLTXCD IN ('1133') THEN '3' ELSE '1' END TRFTYPEVALUE

            FROM (SELECT * FROM VW_CITRAN_GEN TLG
                  WHERE  TLG.BUSDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                         AND TLG.BUSDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
                         AND TLG.TLTXCD IN ('1101','1108','1133','1120','1185','1111', '1201')--,'1130','1188'
                         AND TLG.TXCD='0011'
                         AND TLG.ACCTNO LIKE V_AFACCTNO
                 )TLG,
                 ALLCODE A1, CFMAST CF, AFMAST AF, CIREMITTANCE CIR, TLTX TL, ALLCODE A2
            WHERE TLG.TXDATE = CIR.TXDATE AND TLG.TXNUM = CIR.TXNUM
                AND CF.CUSTID = AF.CUSTID
                AND TL.TLTXCD = TLG.TLTXCD
                AND A1.CDTYPE = 'CI' AND A1.CDNAME = 'RMSTATUS' AND A1.CDVAL =  case when CIR.RMSTATUS in('E','W','M') then 'P' else CIR.RMSTATUS END
                AND A2.CDTYPE = 'SY' AND A2.CDNAME = 'REPORTVIA'
                AND A2.CDVAL = DECODE(SUBSTR(TLG.TXNUM,1,2),systemnums.C_OL_PREFIXED,'O','F') AND A2.CDVAL LIKE V_VIA
                AND TLG.ACCTNO = AF.ACCTNO
               -- AND CF.CUSTID LIKE V_CUSTID  --MSBS-1263
                AND AF.ACCTNO LIKE V_AFACCTNO
                AND CIR.RMSTATUS LIKE V_STATUS


            union all

            SELECT ci.txdate,CI.TXNUM, ci.namt TRFAMT, A1.CDCONTENT STATUS, A1.EN_CDCONTENT EN_STATUS,
                 decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname)  BENEFBANK
                , cf.fullname RECVFULLNAME, af.acctno RECVAFACCTNO,
                A2.CDCONTENT VIA, A2.EN_CDCONTENT EN_VIA, ci.TXDESC, '' BENEFLICENSE, '' CITYBANK, '' CITYEF,
                'C' RMSTATUS , '1' TRFTYPEVALUE
            FROM VW_CITRAN_GEN ci,afmast af, ALLCODE A1, cfmast cf ,tltx,
                  allcode a2
            where ci.acctno=af.acctno and af.custid = cf.custid
                and ci.field='BALANCE'
                AND A1.CDTYPE = 'CI' AND A1.CDNAME = 'RMSTATUS' AND A1.CDVAL = 'C'
                AND A2.CDTYPE = 'SY' AND A2.CDNAME = 'REPORTVIA'
                AND A2.CDVAL = DECODE(SUBSTR(ci.TXNUM,1,2),systemnums.C_OL_PREFIXED,'O','F')  AND A2.CDVAL LIKE V_VIA
                and ci.tltxcd in ('1132','1184')
                and ci.tltxcd=tltx.tltxcd
                --AND CF.CUSTID LIKE V_CUSTID --MSBS-1263
                AND AF.ACCTNO LIKE V_AFACCTNO
                AND (V_STATUS = 'C' or V_STATUS = '%%')
                AND ci.BUSDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                AND ci.BUSDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')


            union all

            select ci.txdate,CI.TXNUM, ci.namt TRFAMT, A1.CDCONTENT STATUS,  A1.EN_CDCONTENT EN_STATUS,
                 decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname)  BENEFBANK
                , cfc.fullname RECVFULLNAME,  afc.acctno RECVAFACCTNO,
                A2.CDCONTENT VIA, A2.EN_CDCONTENT EN_VIA, nvl(ci.trdesc,ci.txdesc) TXDESC, '' BENEFLICENSE, '' CITYBANK, '' CITYEF,
                'C' RMSTATUS , '1' TRFTYPEVALUE
            from vw_citran_gen ci,afmast af, ALLCODE A1, cfmast cf, afmast afc,cfmast cfc ,tltx  ,
              allcode a2
            where  ci.acctno= af.acctno and cf.custid =af.custid
                AND A1.CDTYPE = 'CI' AND A1.CDNAME = 'RMSTATUS' AND A1.CDVAL = 'C'
                AND A2.CDTYPE = 'SY' AND A2.CDNAME = 'REPORTVIA'
                AND A2.CDVAL = DECODE(SUBSTR(ci.TXNUM,1,2),systemnums.C_OL_PREFIXED,'O','F')  AND A2.CDVAL LIKE V_VIA
                and ci.ref =afc.acctno and afc.custid =cfc.custid
                and tltx.tltxcd = ci.tltxcd
                and ci.tltxcd in ('1188','1130') and ci.field ='BALANCE'
                and ci.txcd in ('0011','0012') and ci.txtype = 'D'
                --AND CF.CUSTID LIKE V_CUSTID --MSBS-1263
                AND AF.ACCTNO LIKE V_AFACCTNO
                AND (V_STATUS = 'C' or V_STATUS = '%%')
                AND ci.BUSDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                AND ci.BUSDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
            UNION ALL -- 1.5.7.6|iss:2024
            SELECT REQ.TXDATE, '' TXNUM, REQ.AMOUNT TRFAMT, 'Chờ duyệt' STATUS, 'Chờ duyệt' EN_STATUS,
                   REQ.BENEFBANK, REQ.BENEFCUSTNAME, REQ.BENEFACCT, 'Online' VIA, 'Online' EN_VIA, TL.TXDESC,
                   REQ.BENEFLICENSE, CFO.CITYBANK, CFO.CITYEF, 'P' RMSTATUS, '2' TRFTYPEVALUE
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
              AND AF.ACCTNO LIKE V_AFACCTNO
              AND (V_VIA = 'O' or V_VIA = '%%')
              AND (V_STATUS <> 'C' or V_STATUS = '%%')
              AND REQ.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
              AND REQ.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
       ) TLG
        ORDER BY TLG.TXDATE DESC,  TLG.TXNUM DESC
        ) a);
else
        OPEN p_REFCURSOR FOR
         select * from (select a.*, rownum r from (
        SELECT *
        FROM
        (
            -- CHUYEN KHOAN RA NGOAI
            SELECT TLG.TXDATE,TLG.TXNUM, TLG.NAMT TRFAMT, A1.CDCONTENT STATUS,
                   A1.EN_CDCONTENT EN_STATUS, DECODE(TLG.TLTXCD, '1120', '',CIR.BENEFBANK) BENEFBANK,
                   case when TLG.TLTXCD IN ('1201') THEN 'KBSV'  ELSE CIR.BENEFCUSTNAME end RECVFULLNAME,
				   CIR.BENEFACCT RECVAFACCTNO,
                   A2.CDCONTENT VIA, A2.EN_CDCONTENT EN_VIA, TLG.TXDESC, CIR.BENEFLICENSE, CIR.CITYBANK, CIR.CITYEF,
                 case when CIR.RMSTATUS in('E','W','M') then 'P' else CIR.RMSTATUS END RMSTATUS ,
                    CASE  WHEN TLG.TLTXCD IN ('1120') THEN '1'
                     WHEN TLG.TLTXCD IN ('1101','1108','1111','1185') THEN '2'
                     WHEN TLG.TLTXCD IN ('1133') THEN '3' ELSE '1' END TRFTYPEVALUE

            FROM (SELECT * FROM VW_CITRAN_GEN TLG
                  WHERE  TLG.BUSDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                         AND TLG.BUSDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
                         AND TLG.TLTXCD IN ('1101','1108','1133','1120','1185','1111', '1201')--,'1130','1188'
                         AND TLG.TXCD='0011'
                         AND TLG.ACCTNO LIKE V_AFACCTNO
                 )TLG,
                 ALLCODE A1, CFMAST CF, AFMAST AF, CIREMITTANCE CIR, TLTX TL, ALLCODE A2
            WHERE TLG.TXDATE = CIR.TXDATE AND TLG.TXNUM = CIR.TXNUM
                AND CF.CUSTID = AF.CUSTID
                AND TL.TLTXCD = TLG.TLTXCD
                AND A1.CDTYPE = 'CI' AND A1.CDNAME = 'RMSTATUS' AND A1.CDVAL =  case when CIR.RMSTATUS in('E','W','M') then 'P' else CIR.RMSTATUS END
                AND A2.CDTYPE = 'SY' AND A2.CDNAME = 'REPORTVIA'
                AND A2.CDVAL = DECODE(SUBSTR(TLG.TXNUM,1,2),systemnums.C_OL_PREFIXED,'O','F') AND A2.CDVAL LIKE V_VIA
                AND TLG.ACCTNO = AF.ACCTNO
               -- AND CF.CUSTID LIKE V_CUSTID --MSBS-1263
                AND AF.ACCTNO LIKE V_AFACCTNO
                AND CIR.RMSTATUS LIKE V_STATUS


            union all

            SELECT ci.txdate,CI.TXNUM, ci.namt TRFAMT, A1.CDCONTENT STATUS, A1.EN_CDCONTENT EN_STATUS,
                 decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname)  BENEFBANK
                , cf.fullname RECVFULLNAME, af.acctno RECVAFACCTNO,
                A2.CDCONTENT VIA, A2.EN_CDCONTENT EN_VIA, ci.TXDESC, '' BENEFLICENSE, '' CITYBANK, '' CITYEF,
                'C' RMSTATUS , '1' TRFTYPEVALUE
            FROM VW_CITRAN_GEN ci,afmast af, ALLCODE A1, cfmast cf ,tltx,
                  allcode a2
            where ci.acctno=af.acctno and af.custid = cf.custid
                and ci.field='BALANCE'
                AND A1.CDTYPE = 'CI' AND A1.CDNAME = 'RMSTATUS' AND A1.CDVAL = 'C'
                AND A2.CDTYPE = 'SY' AND A2.CDNAME = 'REPORTVIA'
                AND A2.CDVAL = DECODE(SUBSTR(ci.TXNUM,1,2),systemnums.C_OL_PREFIXED,'O','F')  AND A2.CDVAL LIKE V_VIA
                and ci.tltxcd in ('1132','1184')
                and ci.tltxcd=tltx.tltxcd
                --AND CF.CUSTID LIKE V_CUSTID --MSBS-1263
                AND AF.ACCTNO LIKE V_AFACCTNO
                AND (V_STATUS = 'C' or V_STATUS = '%%')
                AND ci.BUSDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                AND ci.BUSDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')


            union all

            select ci.txdate,CI.TXNUM, ci.namt TRFAMT, A1.CDCONTENT STATUS,  A1.EN_CDCONTENT EN_STATUS,
                 decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname)  BENEFBANK
                , cfc.fullname RECVFULLNAME,  afc.acctno RECVAFACCTNO,
                A2.CDCONTENT VIA, A2.EN_CDCONTENT EN_VIA, nvl(ci.trdesc,ci.txdesc) TXDESC, '' BENEFLICENSE, '' CITYBANK, '' CITYEF,
                'C' RMSTATUS , '1' TRFTYPEVALUE
            from vw_citran_gen ci,afmast af, ALLCODE A1, cfmast cf, afmast afc,cfmast cfc ,tltx  ,
              allcode a2
            where  ci.acctno= af.acctno and cf.custid =af.custid
                AND A1.CDTYPE = 'CI' AND A1.CDNAME = 'RMSTATUS' AND A1.CDVAL = 'C'
                AND A2.CDTYPE = 'SY' AND A2.CDNAME = 'REPORTVIA'
                AND A2.CDVAL = DECODE(SUBSTR(ci.TXNUM,1,2),systemnums.C_OL_PREFIXED,'O','F')  AND A2.CDVAL LIKE V_VIA
                and ci.ref =afc.acctno and afc.custid =cfc.custid
                and tltx.tltxcd = ci.tltxcd
                and ci.tltxcd in ('1188','1130') and ci.field ='BALANCE'
                and ci.txcd in ('0011','0012') and ci.txtype = 'D'
                --AND CF.CUSTID LIKE V_CUSTID --MSBS-1263
                AND AF.ACCTNO LIKE V_AFACCTNO
                AND (V_STATUS = 'C' or V_STATUS = '%%')
                AND ci.BUSDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                AND ci.BUSDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
            UNION ALL -- 1.5.7.6|iss:2024
            SELECT REQ.TXDATE, '' TXNUM, REQ.AMOUNT TRFAMT,
                   UTF8NUMS.c_const_TLTX_STATUS_1118 STATUS, UTF8NUMS.c_const_TLTX_STATUS_1118 EN_STATUS,
                   REQ.BENEFBANK, REQ.BENEFCUSTNAME, REQ.BENEFACCT, 'Online' VIA, 'Online' EN_VIA,
                   UTF8NUMS.c_const_TLTX_TXDESC_1118 TXDESC,
                   REQ.BENEFLICENSE, CFO.CITYBANK, CFO.CITYEF, 'P' RMSTATUS, '2' TRFTYPEVALUE
            FROM EXTRANFERREQ REQ, CFMAST CF, AFMAST AF, CFOTHERACC CFO, (
               SELECT to_date(varvalue, 'DD/MM/RRRR') CURRDATE
               FROM sysvar WHERE grname = 'SYSTEM' AND varname = 'CURRDATE'
            ) GR
            WHERE REQ.AFACCTNO = AF.ACCTNO
              AND AF.CUSTID = CF.CUSTID
              AND REQ.STATUS = 'P'
              AND CFO.AFACCTNO = REQ.AFACCTNO
              AND CFO.BANKACC = REQ.BENEFACCT
              AND REQ.TXDATE = GR.CURRDATE
              AND AF.ACCTNO LIKE V_AFACCTNO
              AND (V_VIA = 'O' or V_VIA = '%%')
              AND (V_STATUS <> 'C' or V_STATUS = '%%')
              AND REQ.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
              AND REQ.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
       ) TLG
        ORDER BY TLG.TXDATE DESC,  TLG.TXNUM DESC
        ) a where rownum <= ROWS_RPP * PAGE_RPP
        ) where r > ROWS_RPP * (PAGE_RPP - 1);

end if;

EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'pr_GetCashTransfer');
END pr_GetCashTransfer;


PROCEDURE pr_MoneyTransDetail
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2,
     P_STATUS       in  varchar2 default 'ALL',
     P_PLACE        in  varchar2 default 'ALL',
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER)
    IS

    V_AFACCTNO    VARCHAR2(10);

    V_STATUS      VARCHAR2(2);




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
--ngoc.vu turning 12/08/2016

if PAGE_RPP = 0 then
    OPEN p_REFCURSOR FOR
       select * from (select a.*, rownum r from (
      select * from
      (
      SELECT TL.TXDESC,sum( case when ci.txtype = 'D' then -ci.namt else ci.namt end) amt
              ,max(case when ci.txcd = '0012' then nvl(CI.trdesc,ci.txdesc) else ' ' end)  trdesc,
              CI.TXDATE,CI.BUSDATE,  a2.cdcontent   via,
             a2.en_cdcontent   en_via, CI.TXNUM
      FROM VW_CITRAN_GEN CI, TLTX TL, ALLCODE A2
      where CI.TLTXCD IN ('3350','3354') AND CI.TXCD in('0012','0011')
      AND CI.TLTXCD=TL.TLTXCD
      AND CI.BUSDATE BETWEEN to_date(F_DATE,'DD/MM/YYYY') AND to_date(T_DATE,'DD/MM/YYYY')
      AND A2.CDTYPE = 'SY' AND A2.CDNAME = 'REPORTVIA' AND A2.CDVAL = DECODE(SUBSTR(CI.TXNUM,1,2),systemnums.C_OL_PREFIXED,'O','F')
      and A2.CDVAL like v_place
      and 'C' like V_STATUS -- chi lay cac giao dich thanh cong issiu 896
      AND CI.ACCTNO LIKE V_AFACCTNO
      group by TL.TXDESC,CI.TXDATE,CI.BUSDATE, a2.cdcontent,CI.TXNUM,a2.en_cdcontent
      union all

      SELECT TL.TXDESC, CI.NAMT AMT,nvl(CI.trdesc,ci.txdesc) trdesc, CI.TXDATE,CI.BUSDATE,
              a2.cdcontent   via,
             a2.en_cdcontent    en_via, CI.TXNUM
      FROM VW_CITRAN_GEN CI, TLTX TL, ALLCODE A2
      where CI.TLTXCD IN ('1120','1188','1130','1137','1138','1131','1141')
      AND TL.TLTXCD=CI.TLTXCD
      AND CI.TXTYPE='C' AND CI.FIELD='BALANCE'
      AND CI.BUSDATE BETWEEN to_date(F_DATE,'DD/MM/YYYY') AND to_date(T_DATE,'DD/MM/YYYY')
      AND A2.CDTYPE = 'SY' AND A2.CDNAME = 'REPORTVIA' AND A2.CDVAL = DECODE(SUBSTR(CI.TXNUM,1,2),systemnums.C_OL_PREFIXED,'O','F')
      and A2.CDVAL like v_place
      and 'C' like V_STATUS -- chi lay cac giao dich thanh cong issiu 896
      AND CI.DELTD<>'Y'
      AND CI.ACCTNO LIKE V_AFACCTNO
      ) order by txdate desc , txnum desc

      ) a);

  else
  OPEN p_REFCURSOR FOR

       select * from (select a.*, rownum r from (
      select * from
      (
      SELECT TL.TXDESC,sum( case when ci.txtype = 'D' then -ci.namt else ci.namt end) amt
              ,max(case when ci.txcd = '0012' then nvl(CI.trdesc,ci.txdesc) else ' ' end)  trdesc,
              CI.TXDATE,CI.BUSDATE,  a2.cdcontent   via,
              a2.en_cdcontent    en_via, CI.TXNUM
      FROM VW_CITRAN_GEN CI, TLTX TL, ALLCODE A2
      where CI.TLTXCD IN ('3350','3354') AND CI.TXCD in('0012','0011')
      AND CI.TLTXCD=TL.TLTXCD
      AND CI.BUSDATE BETWEEN to_date(F_DATE,'DD/MM/YYYY') AND to_date(T_DATE,'DD/MM/YYYY')
      AND A2.CDTYPE = 'SY' AND A2.CDNAME = 'REPORTVIA' AND A2.CDVAL = DECODE(SUBSTR(CI.TXNUM,1,2),systemnums.C_OL_PREFIXED,'O','F')
      and A2.CDVAL like v_place
      and 'C' like V_STATUS -- chi lay cac giao dich thanh cong issiu 896
      AND CI.ACCTNO LIKE V_AFACCTNO
      group by TL.TXDESC,CI.TXDATE,CI.BUSDATE, a2.cdcontent,CI.TXNUM,a2.en_cdcontent
      union all

      SELECT TL.TXDESC, CI.NAMT AMT,nvl(CI.trdesc,ci.txdesc) trdesc, CI.TXDATE,CI.BUSDATE,
              a2.cdcontent   via,
              a2.en_cdcontent    en_via, CI.TXNUM
      FROM VW_CITRAN_GEN CI, TLTX TL, ALLCODE A2
      where CI.TLTXCD IN ('1120','1188','1130','1137','1138','1131','1141')
      AND TL.TLTXCD=CI.TLTXCD
      AND CI.TXTYPE='C' AND CI.FIELD='BALANCE'
      AND CI.BUSDATE BETWEEN to_date(F_DATE,'DD/MM/YYYY') AND to_date(T_DATE,'DD/MM/YYYY')
      AND A2.CDTYPE = 'SY' AND A2.CDNAME = 'REPORTVIA' AND A2.CDVAL = DECODE(SUBSTR(CI.TXNUM,1,2),systemnums.C_OL_PREFIXED,'O','F')
      and A2.CDVAL like v_place
      and 'C' like V_STATUS -- chi lay cac giao dich thanh cong issiu 896
      AND CI.DELTD<>'Y'
      AND CI.ACCTNO LIKE V_AFACCTNO
      ) order by txdate desc , txnum desc

      ) a where rownum <= ROWS_RPP * PAGE_RPP
      ) where r > ROWS_RPP * (PAGE_RPP - 1);

end if;

--end edit
/*
if PAGE_RPP = 0 then
    OPEN p_REFCURSOR FOR
       select * from (select a.*, rownum r from (
      select * from
      (
      SELECT cf.fullname ,  tl.tltxcd ,tltx.txdesc
      ,tl.txnum,tl.busdate ,tl.txdate
      ,cf.custodycd,af.acctno
      , '' custodycdc,'' acctnoc
      ,tl.msgamt amt
      ,nvl(bank.fullname,' ') bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname, tl.txdesc trdesc, a2.cdcontent via, a2.en_cdcontent en_via
      FROM (SELECT * FROM vw_tllog_all tl WHERE tl.tltxcd in ('1131','1141') and  TL.busdate >= to_date(F_DATE,'DD/MM/YYYY')
              AND TL.busdate <=to_date(T_DATE,'DD/MM/YYYY')
          ) TL,
          afmast af,cfmast cf ,tltx, banknostro bank, allcode a2,
          (SELECT * FROM vw_tllogfld_all WHERE txdate BETWEEN to_date(F_DATE,'DD/MM/YYYY') AND to_date(T_DATE,'DD/MM/YYYY')
              AND fldcd='02'
          ) tlfld
      where tl.msgacct=af.acctno and af.custid = cf.custid
      AND A2.CDTYPE = 'SA' AND A2.CDNAME = 'VIA' AND A2.CDVAL = DECODE(SUBSTR(TL.TXNUM,1,2),systemnums.C_OL_PREFIXED,'O','F')
      and A2.CDVAL like v_place
      and 'C' like V_STATUS -- chi lay cac giao dich thanh cong issiu 896
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
      ''bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname,nvl(CI.trdesc,ci.txdesc) trdesc, a2.cdcontent via, a2.en_cdcontent en_via
      FROM (SELECT * FROM vw_tllog_all tl WHERE tl.tltxcd in ('1137','1138') and  TL.busdate >= to_date(F_DATE,'DD/MM/YYYY')
              AND TL.busdate <=to_date(T_DATE,'DD/MM/YYYY')
          ) TL, afmast af,cfmast cf ,tltx,
          (SELECT * FROM vw_citran_gen WHERE busdate BETWEEN to_date(F_DATE,'DD/MM/YYYY') AND to_date(T_DATE,'DD/MM/YYYY')
              AND field ='BALANCE'
          ) ci, allcode a2
      where ci.acctno=af.acctno and af.custid = cf.custid
      AND A2.CDTYPE = 'SA' AND A2.CDNAME = 'VIA' AND A2.CDVAL = DECODE(SUBSTR(TL.TXNUM,1,2),systemnums.C_OL_PREFIXED,'O','F')
      and A2.CDVAL like v_place
      and 'C' like V_STATUS -- chi lay cac giao dich thanh cong issiu 896
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
              ,max(case when ci.txcd = '0012' then nvl(CI.trdesc,ci.txdesc) else ' ' end)  trdesc, a2.cdcontent via, a2.en_cdcontent en_via
      FROM (SELECT * FROM vw_tllog_all tl WHERE tl.tltxcd in ('3350','3354') and  TL.busdate >= to_date(F_DATE,'DD/MM/YYYY')
              AND TL.busdate <=to_date(T_DATE,'DD/MM/YYYY')
          ) TL,afmast af,cfmast cf ,tltx,
          (SELECT * FROM vw_citran_gen WHERE busdate BETWEEN to_date(F_DATE,'DD/MM/YYYY') AND to_date(T_DATE,'DD/MM/YYYY')
              AND TXCD in('0012','0011')
          ) ci, allcode a2
      where tl.msgacct=af.acctno and af.custid = cf.custid
      AND A2.CDTYPE = 'SA' AND A2.CDNAME = 'VIA' AND A2.CDVAL = DECODE(SUBSTR(TL.TXNUM,1,2),systemnums.C_OL_PREFIXED,'O','F')
      and A2.CDVAL like v_place
      and 'C' like V_STATUS -- chi lay cac giao dich thanh cong issiu 896
      and tltx.tltxcd = tl.tltxcd
      AND TL.TXDATE = CI.TXDATE
      AND TL.TXNUM = CI.TXNUM
      AND AF.acctno LIKE V_AFACCTNO
      group by cf.fullname,
              tltx.txdesc ,tl.txnum,tl.busdate ,tl.txdate
              ,cf.custodycd,af.acctno
              ,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname)
              ,a2.cdcontent, a2.en_cdcontent
      union all

      SELECT
          cf.fullname, tl.tltxcd   tltxcd ,tltx.txdesc
      ,tl.txnum,tl.busdate ,tl.txdate
      ,cf.custodycd,af.acctno
      , '' custodycdc,'' acctnoc
      ,ci.namt amt,
      ''bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname,nvl(CI.trdesc,ci.txdesc) trdesc, a2.cdcontent via, a2.en_cdcontent en_via
      FROM (SELECT * FROM vw_tllog_all tl WHERE tl.tltxcd in ('1120','1188','1130') and  TL.busdate >= to_date(F_DATE,'DD/MM/YYYY')
              AND TL.busdate <=to_date(T_DATE,'DD/MM/YYYY')
          ) TL,afmast af,cfmast cf ,tltx,
          (SELECT * FROM vw_citran_gen WHERE busdate BETWEEN to_date(F_DATE,'DD/MM/YYYY') AND to_date(T_DATE,'DD/MM/YYYY')
              AND txtype = 'C' AND field ='BALANCE'
          ) ci, allcode a2
      where ci.acctno=af.acctno and af.custid = cf.custid
      AND A2.CDTYPE = 'SA' AND A2.CDNAME = 'VIA' AND A2.CDVAL = DECODE(SUBSTR(TL.TXNUM,1,2),systemnums.C_OL_PREFIXED,'O','F')
      and A2.CDVAL like v_place
      and 'C' like V_STATUS -- chi lay cac giao dich thanh cong issiu 896
      and tltx.tltxcd = tl.tltxcd
      and tl.txdate = ci.txdate
      and tl.txnum = ci.txnum
      AND AF.acctno LIKE V_AFACCTNO
      ) order by txdate, txnum

      ) a);
  else
  OPEN p_REFCURSOR FOR

       select * from (select a.*, rownum r from (
      select * from
      (
      SELECT cf.fullname ,  tl.tltxcd ,tltx.txdesc
      ,tl.txnum,tl.busdate ,tl.txdate
      ,cf.custodycd,af.acctno
      , '' custodycdc,'' acctnoc
      ,tl.msgamt amt
      ,nvl(bank.fullname,' ') bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname, tl.txdesc trdesc, a2.cdcontent via, a2.en_cdcontent en_via
      FROM (SELECT * FROM vw_tllog_all tl WHERE tl.tltxcd in ('1131','1141') and  TL.busdate >= to_date(F_DATE,'DD/MM/YYYY')
              AND TL.busdate <=to_date(T_DATE,'DD/MM/YYYY')
          ) TL,
          afmast af,cfmast cf ,tltx, banknostro bank, allcode a2,
          (SELECT * FROM vw_tllogfld_all WHERE txdate BETWEEN to_date(F_DATE,'DD/MM/YYYY') AND to_date(T_DATE,'DD/MM/YYYY')
              AND fldcd='02'
          ) tlfld
      where tl.msgacct=af.acctno and af.custid = cf.custid
      AND A2.CDTYPE = 'SA' AND A2.CDNAME = 'VIA' AND A2.CDVAL = DECODE(SUBSTR(TL.TXNUM,1,2),systemnums.C_OL_PREFIXED,'O','F')
      and A2.CDVAL like v_place
      and 'C' like V_STATUS -- chi lay cac giao dich thanh cong issiu 896
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
      ''bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname,nvl(CI.trdesc,ci.txdesc) trdesc, a2.cdcontent via, a2.en_cdcontent en_via
      FROM (SELECT * FROM vw_tllog_all tl WHERE tl.tltxcd in ('1137','1138') and  TL.busdate >= to_date(F_DATE,'DD/MM/YYYY')
              AND TL.busdate <=to_date(T_DATE,'DD/MM/YYYY')
          ) TL, afmast af,cfmast cf ,tltx,
          (SELECT * FROM vw_citran_gen WHERE busdate BETWEEN to_date(F_DATE,'DD/MM/YYYY') AND to_date(T_DATE,'DD/MM/YYYY')
              AND field ='BALANCE'
          ) ci, allcode a2
      where ci.acctno=af.acctno and af.custid = cf.custid
      AND A2.CDTYPE = 'SA' AND A2.CDNAME = 'VIA' AND A2.CDVAL = DECODE(SUBSTR(TL.TXNUM,1,2),systemnums.C_OL_PREFIXED,'O','F')
      and A2.CDVAL like v_place
      and 'C' like V_STATUS -- chi lay cac giao dich thanh cong issiu 896
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
              ,max(case when ci.txcd = '0012' then nvl(CI.trdesc,ci.txdesc) else ' ' end)  trdesc, a2.cdcontent via, a2.en_cdcontent en_via
      FROM (SELECT * FROM vw_tllog_all tl WHERE tl.tltxcd in ('3350','3354') and  TL.busdate >= to_date(F_DATE,'DD/MM/YYYY')
              AND TL.busdate <=to_date(T_DATE,'DD/MM/YYYY')
          ) TL,afmast af,cfmast cf ,tltx,
          (SELECT * FROM vw_citran_gen WHERE busdate BETWEEN to_date(F_DATE,'DD/MM/YYYY') AND to_date(T_DATE,'DD/MM/YYYY')
              AND TXCD in('0012','0011')
          ) ci, allcode a2
      where tl.msgacct=af.acctno and af.custid = cf.custid
      AND A2.CDTYPE = 'SA' AND A2.CDNAME = 'VIA' AND A2.CDVAL = DECODE(SUBSTR(TL.TXNUM,1,2),systemnums.C_OL_PREFIXED,'O','F')
      and A2.CDVAL like v_place
      and 'C' like V_STATUS -- chi lay cac giao dich thanh cong issiu 896
      and tltx.tltxcd = tl.tltxcd
      AND TL.TXDATE = CI.TXDATE
      AND TL.TXNUM = CI.TXNUM
      AND AF.acctno LIKE V_AFACCTNO
      group by cf.fullname,
              tltx.txdesc ,tl.txnum,tl.busdate ,tl.txdate
              ,cf.custodycd,af.acctno
              ,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname)
              ,a2.cdcontent, a2.en_cdcontent
      union all

      SELECT
          cf.fullname, tl.tltxcd   tltxcd ,tltx.txdesc
      ,tl.txnum,tl.busdate ,tl.txdate
      ,cf.custodycd,af.acctno
      , '' custodycdc,'' acctnoc
      ,ci.namt amt,
      ''bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname,nvl(CI.trdesc,ci.txdesc) trdesc, a2.cdcontent via, a2.en_cdcontent en_via
      FROM (SELECT * FROM vw_tllog_all tl WHERE tl.tltxcd in ('1120','1188','1130') and  TL.busdate >= to_date(F_DATE,'DD/MM/YYYY')
              AND TL.busdate <=to_date(T_DATE,'DD/MM/YYYY')
          ) TL,afmast af,cfmast cf ,tltx,
          (SELECT * FROM vw_citran_gen WHERE busdate BETWEEN to_date(F_DATE,'DD/MM/YYYY') AND to_date(T_DATE,'DD/MM/YYYY')
              AND txtype = 'C' AND field ='BALANCE'
          ) ci, allcode a2
      where ci.acctno=af.acctno and af.custid = cf.custid
      AND A2.CDTYPE = 'SA' AND A2.CDNAME = 'VIA' AND A2.CDVAL = DECODE(SUBSTR(TL.TXNUM,1,2),systemnums.C_OL_PREFIXED,'O','F')
      and A2.CDVAL like v_place
      and 'C' like V_STATUS -- chi lay cac giao dich thanh cong issiu 896
      and tltx.tltxcd = tl.tltxcd
      and tl.txdate = ci.txdate
      and tl.txnum = ci.txnum
      AND AF.acctno LIKE V_AFACCTNO
      ) order by txdate, txnum

      ) a where rownum <= ROWS_RPP * PAGE_RPP) where r > ROWS_RPP * (PAGE_RPP - 1);
end if;*/
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'pr_MoneyTransDetail');
END pr_MoneyTransDetail;

-- Lay thong tin cac giao dich quyen mua
-- TheNN, 12-Jan-2012
PROCEDURE pr_GetRightOffInfor
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD    IN VARCHAR2,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
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
    --ngoc.vu edit 12/08/2016 issiu 912
     if PAGE_RPP = 0 then
        OPEN p_REFCURSOR FOR
        select * from (select B.*, rownum r from (
        SELECT * FROM
        (
            -- CAC GD DA THUC HIEN
            SELECT CA.TXDATE, CA.BUSDATE, CA.TXNUM, SB.SYMBOL, CA.EXECQTTY,
                 A1.CDCONTENT STATUS, A1.EN_CDCONTENT EN_STATUS, CA.EXECTYPE, CA.EN_EXECTYPE
            FROM
            (
              SELECT CA.TOCODEID,TLG.TXDATE, TLG.BUSDATE, TLG.TXNUM,
                  CA.CODEID, TLG.NAMT EXECQTTY,  '1' TXSTATUS,
                 case when  TLG.TLTXCD = '3394'
                            then  'Dang ky quyen mua tren Online'
                      when TLG.TLTXCD = '3386'
                            then 'Huy dang ky quyen mua'
                      when  TLG.TLTXCD = '3324'
                            then 'DK mua CP phat hanh them khong cat CI'
                      when TLG.TLTXCD = '3326'
                            then 'Huy DK mua CP phat hanh them khong cat CI'
                      when TLG.TLTXCD ='3384'
                            then 'Dang ky quyen mua'
                      else '' end    EXECTYPE,
                  case when  TLG.TLTXCD = '3394'
                            then  'Right Register on Online'
                      when TLG.TLTXCD = '3386'
                            then 'Cancel right to buy'
                      when  TLG.TLTXCD = '3324'
                            then 'Right purchase additional not cut ci'
                      when TLG.TLTXCD = '3326'
                            then ' Cancel Right purchase additional not cut ci'
                      when TLG.TLTXCD ='3384'
                            then 'Right Register'
                      else '' end   EN_EXECTYPE
                FROM
                    (SELECT * FROM VW_SETRAN_GEN TLG
                        WHERE  TLG.TLTXCD IN ('3384','3394','3324','3326','3386')
                            AND TLG.field='RECEIVING'
                            AND TLG.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                            AND TLG.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
                            AND TLG.AFACCTNO LIKE V_AFACCTNO
                            AND TLG.custid  LIKE V_CUSTID
                    ) TLG,  CASCHD CHD, CAMAST CA
                WHERE CHD.AUTOID = TLG.REF
                      AND CA.CAMASTID=CHD.CAMASTID


            ) CA, ALLCODE A1, SBSECURITIES SB
            WHERE CA.TOCODEID = SB.CODEID
                AND A1.CDTYPE = 'SY' AND A1.CDNAME = 'TXSTATUS' AND A1.CDVAL = CA.TXSTATUS
        ) A
        ORDER BY A.BUSDATE DESC,  A.TXNUM DESC
        ) B);
    else
        OPEN p_REFCURSOR FOR

           select * from (select B.*, rownum r from (
        SELECT * FROM
        (
            -- CAC GD DA THUC HIEN
            SELECT CA.TXDATE, CA.BUSDATE, CA.TXNUM, SB.SYMBOL, CA.EXECQTTY,
                 A1.CDCONTENT STATUS, A1.EN_CDCONTENT EN_STATUS, CA.EXECTYPE, CA.EN_EXECTYPE
            FROM
            (
              SELECT CA.TOCODEID,TLG.TXDATE, TLG.BUSDATE, TLG.TXNUM,
                  CA.CODEID, TLG.NAMT EXECQTTY,  '1' TXSTATUS,
                 case when  TLG.TLTXCD = '3394'
                            then  'Dang ky quyen mua qua Tele'
                      when TLG.TLTXCD = '3386'
                            then 'Huy dang ky quyen mua'
                      when  TLG.TLTXCD = '3324'
                            then 'DK mua CP phat hanh them khong cat CI'
                      when TLG.TLTXCD = '3326'
                            then 'Huy DK mua CP phat hanh them khong cat CI'
                      when TLG.TLTXCD ='3384'
                            then 'Dang ky quyen mua'
                      else '' end    EXECTYPE,
                  case when  TLG.TLTXCD = '3394'
                            then  'Right Register on Tele'
                      when TLG.TLTXCD = '3386'
                            then 'Cancel right to buy'
                      when  TLG.TLTXCD = '3324'
                            then 'Right purchase additional not cut ci'
                      when TLG.TLTXCD = '3326'
                            then ' Cancel Right purchase additional not cut ci'
                      when TLG.TLTXCD ='3384'
                            then 'Right Register'
                      else '' end   EN_EXECTYPE
                FROM
                    (SELECT * FROM VW_SETRAN_GEN TLG
                        WHERE  TLG.TLTXCD IN ('3384','3394','3324','3326','3386')
                            AND TLG.field='RECEIVING'
                            AND TLG.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                            AND TLG.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
                            AND TLG.AFACCTNO LIKE V_AFACCTNO
                            AND TLG.custid  LIKE V_CUSTID
                    ) TLG,  CASCHD CHD, CAMAST CA
                WHERE CHD.AUTOID = TLG.REF
                      AND CA.CAMASTID=CHD.CAMASTID


            ) CA, ALLCODE A1, SBSECURITIES SB
            WHERE CA.TOCODEID = SB.CODEID
                AND A1.CDTYPE = 'SY' AND A1.CDNAME = 'TXSTATUS' AND A1.CDVAL = CA.TXSTATUS
        ) A
        ORDER BY A.BUSDATE DESC,  A.TXNUM DESC
        ) B where rownum <= ROWS_RPP * PAGE_RPP
        )where r > ROWS_RPP * (PAGE_RPP - 1);

    end if;

EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'pr_GetRightOffInfor');
END pr_GetRightOffInfor;


-- LAY THONG TIN UNG TRUOC DA THUC HIEN
PROCEDURE pr_GetAdvancedPayment
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN VARCHAR2,
     T_DATE         IN VARCHAR2,
     STATUS         IN VARCHAR2,
--     ADVPLACE  IN VARCHAR2,
     VIA       IN VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
    )
    IS

  V_AFACCTNO    VARCHAR2(10);

  V_STATUS      VARCHAR2(10);
  V_ADVPLACE    VARCHAR2(10);
 -- V_VIA    VARCHAR2(10);

BEGIN
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

   /* IF VIA = 'ALL' OR VIA IS NULL THEN
        V_VIA := '%%';
    ELSE
        V_VIA := VIA;
    END IF;*/
    IF VIA = 'ALL' OR VIA IS NULL THEN
        V_ADVPLACE := '%%';
    ELSIF VIA = 'O' THEN
        V_ADVPLACE := '68%';
    ELSIF VIA = 'F' THEN
        V_ADVPLACE := SUBSTR(AFACCTNO,1,2)||'%';
    END IF;

    -- LAY THONG TIN UT DA THUC HIEN
      if PAGE_RPP = 0 then
    OPEN p_REFCURSOR FOR
       select * from (select a.*, rownum r from (
        SELECT AD.ODDATE, AD.TXDATE, AD.TXDATE EXECDATE, AD.CLEARDT, STS.AMT, AD.AMT+AD.FEEAMT AAMT,
            AD.FEEAMT, AD.AMT RECVAMT, AD.CLEARDT-AD.TXDATE ADVDAYS, A1.CDCONTENT STATUS, A1.EN_CDCONTENT EN_STATUS,
            A2.CDCONTENT VIA, A2.EN_CDCONTENT EN_VIA
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
                             AND OD.TXDATE  <= TO_DATE(T_DATE,'DD/MM/YYYY')
                             AND SYS.GRNAME = 'SYSTEM' AND SYS.VARNAME = 'ADVSELLDUTY'
                    ) OD
                WHERE STS.ORGORDERID = OD.ORDERID
                    AND STS.DUETYPE = 'RM' AND STS.DELTD = 'N'
                    AND STS.AFACCTNO LIKE V_AFACCTNO
            ) STS
            GROUP BY STS.TXDATE, STS.AFACCTNO, STS.CLEARDAY, STS.CLEARCD, STS.CLEARDATE
        ) STS, VW_ADSCHD_ALL AD, ALLCODE A1,  ALLCODE A2
        where AD.ACCTNO = STS.AFACCTNO AND AD.ODDATE = STS.TXDATE AND AD.CLEARDT = STS.CLEARDATE
            AND AD.STATUS||AD.DELTD LIKE V_STATUS
            AND AD.TXNUM LIKE V_ADVPLACE
            AND AD.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
            AND AD.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
            and A1.CDTYPE = 'AD' AND A1.CDNAME = 'ADSTATUS' AND A1.CDVAL = AD.STATUS||AD.DELTD
            and A2.CDTYPE = 'SY' AND A2.CDNAME = 'REPORTVIA' AND A2.CDVAL  = DECODE(SUBSTR(AD.TXNUM,1,2),'68','O','F')
            ORDER BY AD.TXDATE DESC, AD.ODDATE DESC, AAMT DESC
    ) a);
else
OPEN p_REFCURSOR FOR
    select * from (select a.*, rownum r from (
        SELECT AD.ODDATE, AD.TXDATE, AD.TXDATE EXECDATE, AD.CLEARDT, STS.AMT, AD.AMT+AD.FEEAMT AAMT,
            AD.FEEAMT, AD.AMT RECVAMT, AD.CLEARDT-AD.TXDATE ADVDAYS, A1.CDCONTENT STATUS, A1.EN_CDCONTENT EN_STATUS,
            A2.CDCONTENT VIA, A2.EN_CDCONTENT EN_VIA
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
                             AND OD.TXDATE  <= TO_DATE(T_DATE,'DD/MM/YYYY')
                             AND SYS.GRNAME = 'SYSTEM' AND SYS.VARNAME = 'ADVSELLDUTY'
                    ) OD
                WHERE STS.ORGORDERID = OD.ORDERID
                    AND STS.DUETYPE = 'RM' AND STS.DELTD = 'N'
                    AND STS.AFACCTNO LIKE V_AFACCTNO
            ) STS
            GROUP BY STS.TXDATE, STS.AFACCTNO, STS.CLEARDAY, STS.CLEARCD, STS.CLEARDATE
        ) STS, VW_ADSCHD_ALL AD, ALLCODE A1,  ALLCODE A2
        where AD.ACCTNO = STS.AFACCTNO AND AD.ODDATE = STS.TXDATE AND AD.CLEARDT = STS.CLEARDATE
            AND AD.STATUS||AD.DELTD LIKE V_STATUS
            AND AD.TXNUM LIKE V_ADVPLACE
            AND AD.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
            AND AD.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
            and A1.CDTYPE = 'AD' AND A1.CDNAME = 'ADSTATUS' AND A1.CDVAL = AD.STATUS||AD.DELTD
            and A2.CDTYPE = 'SY' AND A2.CDNAME = 'REPORTVIA' AND A2.CDVAL  = DECODE(SUBSTR(AD.TXNUM,1,2),'68','O','F')
            ORDER BY AD.TXDATE DESC, AD.ODDATE DESC, AAMT DESC
    ) a where rownum <= ROWS_RPP * PAGE_RPP
    )where r > ROWS_RPP * (PAGE_RPP - 1);

end if;
  /*  if PAGE_RPP = 0 then
    OPEN p_REFCURSOR FOR
     select * from (select a.*, rownum r from (
        SELECT AD.ODDATE, AD.TXDATE, AD.TXDATE EXECDATE, AD.CLEARDT, STS.AMT, AD.AMT+AD.FEEAMT AAMT,
            AD.FEEAMT, AD.AMT RECVAMT, AD.CLEARDT-AD.TXDATE ADVDAYS, A1.CDCONTENT STATUS, A1.EN_CDCONTENT EN_STATUS,
            A2.CDCONTENT VIA, A2.EN_CDCONTENT EN_VIA, CI.TLLOG_AUTOID
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
        ON A2.CDTYPE = 'SA' AND A2.CDNAME = 'VIA' AND A2.CDVAL \*like V_VIA *\ = DECODE(SUBSTR(AD.TXNUM,1,2),systemnums.C_OL_PREFIXED,'O','F')
        INNER JOIN
            VW_CITRAN_GEN CI
        ON AD.TXDATE = CI.TXDATE AND AD.TXNUM = CI.TXNUM AND CI.TXCD = '0012'
        ORDER BY AD.ODDATE DESC, CI.TLLOG_AUTOID DESC, substr(AD.TXNUM,5,6) DESC
        ) a);
else
OPEN p_REFCURSOR FOR
     select * from (select a.*, rownum r from (
        SELECT AD.ODDATE, AD.TXDATE, AD.TXDATE EXECDATE, AD.CLEARDT, STS.AMT, AD.AMT+AD.FEEAMT AAMT,
            AD.FEEAMT, AD.AMT RECVAMT, AD.CLEARDT-AD.TXDATE ADVDAYS, A1.CDCONTENT STATUS, A1.EN_CDCONTENT EN_STATUS,
            A2.CDCONTENT VIA, A2.EN_CDCONTENT EN_VIA, CI.TLLOG_AUTOID
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
        ON A2.CDTYPE = 'SA' AND A2.CDNAME = 'VIA' AND A2.CDVAL \*like V_VIA *\ = DECODE(SUBSTR(AD.TXNUM,1,2),systemnums.C_OL_PREFIXED,'O','F')
        INNER JOIN
            VW_CITRAN_GEN CI
        ON AD.TXDATE = CI.TXDATE AND AD.TXNUM = CI.TXNUM AND CI.TXCD = '0012'
        ORDER BY AD.ODDATE DESC, CI.TLLOG_AUTOID DESC, substr(AD.TXNUM,5,6) DESC
        ) a where rownum <= ROWS_RPP * PAGE_RPP) where r > ROWS_RPP * (PAGE_RPP - 1);
end if;*/
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'pr_GetAdvancedPayment');
END pr_GetAdvancedPayment;



-- Check active host & branch
function fn_CheckActiveSystem
    return number
as
    l_status char(1);

    v_HOSTATUS  VARCHAR(1);

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

procedure pr_get_rightinfo
    (p_refcursor in out pkg_report.ref_cursor,
    PV_CUSTODYCD  IN  VARCHAR2,
    PV_AFACCTNO   IN  VARCHAR2,
    ISCOM         IN  VARCHAR2,
    F_DATE        IN VARCHAR2,
    T_DATE        IN  VARCHAR2,
    PAGE_RPP IN NUMBER,
    ROWS_RPP IN NUMBER
    )
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
if PAGE_RPP = 0 then
    Open p_refcursor for
    select * from (select a.*, rownum r from (
          SELECT ca.acctno, ca.custodycd, ca.fullname, ca.mobile, ca.idcode,
        ca.trade SLCKSH, TYLE, CATYPE, EN_CATYPE, STATUS, EN_STATUS, Ca.CAMASTID, CA.AMT,SYMBOL,
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
            A0.CDCONTENT CATYPE, A0.EN_CDCONTENT EN_CATYPE,  A1.CDCONTENT STATUS, A1.EN_CDCONTENT EN_STATUS, CAM.CAMASTID, CAS.AMT
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
    ORDER  BY SUBSTR(CA.CAMASTID,11,6) DESC
    ) a);
else
    Open p_refcursor for
    select * from (select a.*, rownum r from (
          SELECT ca.acctno, ca.custodycd, ca.fullname, ca.mobile, ca.idcode,
        ca.trade SLCKSH, TYLE, CATYPE, EN_CATYPE, STATUS, EN_STATUS, Ca.CAMASTID, CA.AMT,SYMBOL,
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
            A0.CDCONTENT CATYPE, A0.EN_CDCONTENT EN_CATYPE,  A1.CDCONTENT STATUS, A1.EN_CDCONTENT EN_STATUS, CAM.CAMASTID, CAS.AMT
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
    ORDER  BY SUBSTR(CA.CAMASTID,11,6) DESC
    ) a where rownum <= ROWS_RPP * PAGE_RPP) where r > ROWS_RPP * (PAGE_RPP - 1);
end if;
    plog.setendsection(pkgctx, 'pr_get_rightinfo');

exception when others then
       plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'pr_get_rightinfo');
end pr_get_rightinfo;

-- Lay danh sach chuyen doi trai phieu thanh co phieu
-- TheNN, 16-Jul-2012
PROCEDURE pr_GetBonds2SharesList
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD    IN VARCHAR2,
     AFACCTNO       IN  VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
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
        select * from (select a.*, rownum r from (
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
                --AND CF.CUSTID LIKE V_CUSTID  -- MSBS-1267
                AND AF.ACCTNO LIKE V_AFACCTNO
            ORDER BY CA.CAMASTID
        ) a where rownum <= ROWS_RPP * PAGE_RPP) where r > ROWS_RPP * (PAGE_RPP - 1);

EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'pr_GetBonds2SharesList');
END pr_GetBonds2SharesList;

  --Binhpt lay thong tin du no
  --Lay thong tin du no
PROCEDURE pr_LoanHist
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD    IN VARCHAR2,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
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
IF PAGE_RPP = 1 THEN
    OPEN p_REFCURSOR FOR
    select /*'' GROUPID,*/ '' TYPENAME, '' CUSTODYCD, '' AFACCTNO, '' LNACCTNO,
                 sum(TOTALLOAN) TOTALLOAN,
                 GETCURRDATE RLSDATE,
                 sum(PRINCIPAL) PRINCIPAL,
                 Sum(RLSAMT) RLSAMT,
                 Sum(PRINPAID) PRINPAID,
                 sum(INTPAID) INTPAID, 0 DFRATE
                 ,0 DAYS,
                 sum(INTNML) INTNML,
                 sum(INTOVD) INTOVD,
                 GETCURRDATE OVERDUEDATE,/* 0 IRATE,
                 0 RTTDF, 0 ODCALLRTTDF,*/ '' REFTYPE, 0 r
    from (SELECT/* V_DEAL.GROUPID,*/TY.TYPENAME, CF.CUSTODYCD, AF.ACCTNO AFACCTNO, LN.ACCTNO LNACCTNO,
                 ROUND( SCHD.INTOVDPRIN + SCHD.FEEINTOVDACR+SCHD.INTNMLACR  + SCHD.INTOVD + SCHD.INTDUE + SCHD.FEEINTNMLACR + SCHD.FEEINTDUE + SCHD.FEEINTNMLOVD+SCHD.NML + SCHD.OVD) TOTALLOAN,
                 SCHD.RLSDATE,
                 SCHD.NML + SCHD.OVD PRINCIPAL,
                 SCHD.NML + SCHD.OVD + SCHD.PAID RLSAMT,
                 SCHD.PAID PRINPAID,
                 SCHD.INTPAID + SCHD.FEEINTPAID + SCHD.FEEINTPREPAID INTPAID, 0 DFRATE
                 ,case when ROUND( SCHD.INTOVDPRIN + SCHD.FEEINTOVDACR+SCHD.INTNMLACR  + SCHD.INTOVD + SCHD.INTDUE + SCHD.FEEINTNMLACR + SCHD.FEEINTDUE + SCHD.FEEINTNMLOVD+SCHD.NML + SCHD.OVD) > 0 then   SCHD.DAYS
                       else DATEDIFF('D', schd.rlsdate, schd.PAIDDATE) end DAYS,
                 round(SCHD.INTNMLACR  + SCHD.INTOVD + SCHD.INTDUE + SCHD.FEEINTNMLACR + SCHD.FEEINTDUE + SCHD.FEEINTNMLOVD) INTNML,
                 round(SCHD.INTOVDPRIN + SCHD.FEEINTOVDACR) INTOVD,
                 SCHD.OVERDUEDATE,/* NVL(V_DEAL.IRATE, 0) IRATE,
                 NVL(V_DEAL.RTTDF, 0) RTTDF, NVL(V_DEAL.ODCALLRTTDF, 0) ODCALLRTTDF,*/ SCHD.REFTYPE
            FROM CFMAST CF, AFMAST AF, LNMAST LN, LNTYPE TY,
                 (SELECT LNSCHD.*,DATEDIFF('D', RLSDATE, GETCURRDATE) DAYS FROM LNSCHD WHERE REFTYPE IN ('GP', 'P') AND DUENO = 0
                    union all
                 select lnschdhist.*, DATEDIFF('D', RLSDATE, GETCURRDATE) DAYS FROM LNSCHDhist WHERE REFTYPE IN ('GP', 'P') AND DUENO = 0
                 ) SCHD--, V_GETGRPDEALFORMULAR V_DEAL
           WHERE AF.CUSTID = CF.CUSTID
             AND AF.ACCTNO = LN.TRFACCTNO
             AND LN.ACTYPE = TY.ACTYPE
             AND SCHD.ACCTNO = LN.ACCTNO
            -- AND LN.ACCTNO = V_DEAL.LNACCTNO(+)
             --AND CF.CUSTODYCD like V_CUSTODYCD  --MSBS-1262
             AND AF.ACCTNO like V_AFACCTNO
             --AND SCHD.NML + SCHD.OVD + SCHD.INTNMLACR + SCHD.INTOVDPRIN + SCHD.INTDUE + SCHD.FEEINTNMLACR + SCHD.FEEINTDUE + SCHD.FEEINTOVDACR + SCHD.INTOVD + SCHD.FEEINTNMLOVD > 0
             AND SCHD.RLSDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
             AND SCHD.RLSDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
           ORDER BY SCHD.RLSDATE DESC, LN.ACCTNO )
           union all
    select * from (select a.*, rownum r from (
        SELECT /*V_DEAL.GROUPID,*/TY.TYPENAME, CF.CUSTODYCD, AF.ACCTNO AFACCTNO, LN.ACCTNO LNACCTNO,
                 ROUND( SCHD.INTOVDPRIN + SCHD.FEEINTOVDACR+SCHD.INTNMLACR  + SCHD.INTOVD + SCHD.INTDUE + SCHD.FEEINTNMLACR + SCHD.FEEINTDUE + SCHD.FEEINTNMLOVD+SCHD.NML + SCHD.OVD) TOTALLOAN,
                 SCHD.RLSDATE,
                 SCHD.NML + SCHD.OVD PRINCIPAL,
                 SCHD.NML + SCHD.OVD + SCHD.PAID RLSAMT,
                 SCHD.PAID PRINPAID,
                 SCHD.INTPAID + SCHD.FEEINTPAID + SCHD.FEEINTPREPAID INTPAID, 0 DFRATE
                 ,case when ROUND( SCHD.INTOVDPRIN + SCHD.FEEINTOVDACR+SCHD.INTNMLACR  + SCHD.INTOVD + SCHD.INTDUE + SCHD.FEEINTNMLACR + SCHD.FEEINTDUE + SCHD.FEEINTNMLOVD+SCHD.NML + SCHD.OVD) > 0 then   SCHD.DAYS
                       else DATEDIFF('D', schd.rlsdate, schd.PAIDDATE) end DAYS,
                 ROUND(SCHD.INTNMLACR  + SCHD.INTOVD + SCHD.INTDUE + SCHD.FEEINTNMLACR + SCHD.FEEINTDUE + SCHD.FEEINTNMLOVD) INTNML,
                 ROUND(SCHD.INTOVDPRIN + SCHD.FEEINTOVDACR) INTOVD,
                 SCHD.OVERDUEDATE, /*NVL(V_DEAL.IRATE, 0) IRATE,
                 NVL(V_DEAL.RTTDF, 0) RTTDF, NVL(V_DEAL.ODCALLRTTDF, 0) ODCALLRTTDF,*/ SCHD.REFTYPE
            FROM CFMAST CF, AFMAST AF, LNMAST LN, LNTYPE TY,
                 (SELECT LNSCHD.*,DATEDIFF('D', RLSDATE, GETCURRDATE) DAYS FROM LNSCHD WHERE REFTYPE IN ('GP', 'P') AND DUENO = 0
                    union all
                 select lnschdhist.*, DATEDIFF('D', RLSDATE, GETCURRDATE) DAYS FROM LNSCHDhist WHERE REFTYPE IN ('GP', 'P') AND DUENO = 0
                 ) SCHD--, V_GETGRPDEALFORMULAR V_DEAL
           WHERE AF.CUSTID = CF.CUSTID
             AND AF.ACCTNO = LN.TRFACCTNO
             AND LN.ACTYPE = TY.ACTYPE
             AND SCHD.ACCTNO = LN.ACCTNO
            -- AND LN.ACCTNO = V_DEAL.LNACCTNO(+)
             --AND CF.CUSTODYCD like V_CUSTODYCD  --MSBS-1262
             AND AF.ACCTNO like V_AFACCTNO
             --AND SCHD.NML + SCHD.OVD + SCHD.INTNMLACR + SCHD.INTOVDPRIN + SCHD.INTDUE + SCHD.FEEINTNMLACR + SCHD.FEEINTDUE + SCHD.FEEINTOVDACR + SCHD.INTOVD + SCHD.FEEINTNMLOVD > 0
             AND SCHD.RLSDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
             AND SCHD.RLSDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
           ORDER BY SCHD.RLSDATE DESC, LN.ACCTNO
           ) a where rownum <= ROWS_RPP * PAGE_RPP) where r > ROWS_RPP * (PAGE_RPP - 1);

ELSE
    if PAGE_RPP = 0 then
    OPEN p_REFCURSOR FOR
            select * from (select a.*, rownum r from (
        SELECT /*V_DEAL.GROUPID,*/TY.TYPENAME, CF.CUSTODYCD, AF.ACCTNO AFACCTNO, LN.ACCTNO LNACCTNO,
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
                 SCHD.OVERDUEDATE,/* NVL(V_DEAL.IRATE, 0) IRATE,
                 NVL(V_DEAL.RTTDF, 0) RTTDF, NVL(V_DEAL.ODCALLRTTDF, 0) ODCALLRTTDF,*/ SCHD.REFTYPE
            FROM CFMAST CF, AFMAST AF, LNMAST LN, LNTYPE TY,
                 (SELECT LNSCHD.*,DATEDIFF('D', RLSDATE, GETCURRDATE) DAYS FROM LNSCHD WHERE REFTYPE IN ('GP', 'P') AND DUENO = 0
                    union all
                 select lnschdhist.*, DATEDIFF('D', RLSDATE, GETCURRDATE) DAYS FROM LNSCHDhist WHERE REFTYPE IN ('GP', 'P') AND DUENO = 0
                 ) SCHD--, V_GETGRPDEALFORMULAR V_DEAL
           WHERE AF.CUSTID = CF.CUSTID
             AND AF.ACCTNO = LN.TRFACCTNO
             AND LN.ACTYPE = TY.ACTYPE
             AND SCHD.ACCTNO = LN.ACCTNO
             --AND LN.ACCTNO = V_DEAL.LNACCTNO(+)
             --AND CF.CUSTODYCD like V_CUSTODYCD  --MSBS-1262
             AND AF.ACCTNO like V_AFACCTNO
             --AND SCHD.NML + SCHD.OVD + SCHD.INTNMLACR + SCHD.INTOVDPRIN + SCHD.INTDUE + SCHD.FEEINTNMLACR + SCHD.FEEINTDUE + SCHD.FEEINTOVDACR + SCHD.INTOVD + SCHD.FEEINTNMLOVD > 0
             AND SCHD.RLSDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
             AND SCHD.RLSDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
           ORDER BY SCHD.RLSDATE DESC, LN.ACCTNO
           ) a);

    else
       OPEN p_REFCURSOR FOR
            select * from (select a.*, rownum r from (
        SELECT /*V_DEAL.GROUPID,*/TY.TYPENAME, CF.CUSTODYCD, AF.ACCTNO AFACCTNO, LN.ACCTNO LNACCTNO,
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
                 SCHD.OVERDUEDATE,/* NVL(V_DEAL.IRATE, 0) IRATE,
                 NVL(V_DEAL.RTTDF, 0) RTTDF, NVL(V_DEAL.ODCALLRTTDF, 0) ODCALLRTTDF,*/ SCHD.REFTYPE
            FROM CFMAST CF, AFMAST AF, LNMAST LN, LNTYPE TY,
                 (SELECT LNSCHD.*,DATEDIFF('D', RLSDATE, GETCURRDATE) DAYS FROM LNSCHD WHERE REFTYPE IN ('GP', 'P') AND DUENO = 0
                    union all
                 select lnschdhist.*, DATEDIFF('D', RLSDATE, GETCURRDATE) DAYS FROM LNSCHDhist WHERE REFTYPE IN ('GP', 'P') AND DUENO = 0
                 ) SCHD--, V_GETGRPDEALFORMULAR V_DEAL
           WHERE AF.CUSTID = CF.CUSTID
             AND AF.ACCTNO = LN.TRFACCTNO
             AND LN.ACTYPE = TY.ACTYPE
             AND SCHD.ACCTNO = LN.ACCTNO
            -- AND LN.ACCTNO = V_DEAL.LNACCTNO(+)
             --AND CF.CUSTODYCD like V_CUSTODYCD  --MSBS-1262
             AND AF.ACCTNO like V_AFACCTNO
             --AND SCHD.NML + SCHD.OVD + SCHD.INTNMLACR + SCHD.INTOVDPRIN + SCHD.INTDUE + SCHD.FEEINTNMLACR + SCHD.FEEINTDUE + SCHD.FEEINTOVDACR + SCHD.INTOVD + SCHD.FEEINTNMLOVD > 0
             AND SCHD.RLSDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
             AND SCHD.RLSDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
           ORDER BY SCHD.RLSDATE DESC, LN.ACCTNO
           ) a where rownum <= ROWS_RPP * PAGE_RPP) where r > ROWS_RPP * (PAGE_RPP - 1);
    end if;
END IF;
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'pr_LoanHist');
END pr_LoanHist;


--Ham tra cuu tiet kiem
--Binhpt 29/08/2012
PROCEDURE pr_GetTDhist
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
     )
    IS
    V_AFACCTNO    VARCHAR2(10);
BEGIN
    IF AFACCTNO = 'ALL' OR AFACCTNO IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := AFACCTNO;
    END IF;
if PAGE_RPP = 0 then
    OPEN p_REFCURSOR FOR
    select * from (select a.*, rownum r from (
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
        AND MST.OPNDATE<=TO_DATE(T_DATE,'DD/MM/YYYY')
        ) a);
else
    OPEN p_REFCURSOR FOR
    select * from (select a.*, rownum r from (
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
        AND MST.OPNDATE<=TO_DATE(T_DATE,'DD/MM/YYYY')
        ) a where rownum <= ROWS_RPP * PAGE_RPP) where r > ROWS_RPP * (PAGE_RPP - 1);
end if;
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'pr_GetTDhist');
END pr_GetTDhist;


PROCEDURE pr_GetConfirmOrderHistByCust
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     EXECTYPE       IN  VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
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
    select * from (select a.*, rownum r from (

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
        and ( (od.exectype in ('NB','NS','MS') AND od.via in ('F','T','H','E')) or (od.exectype  not in ('NB','NS','MS')))
        and od.exectype not in ('AB','AS') AND od.tlid <> systemnums.C_ONLINE_USERID
        and od.via not in( 'O','M','K')
        and od.txdate >=to_date('01/01/2013','DD/MM/YYYY')
        and od.afacctno=af.acctno and af.custid=cf.custid
        AND cf.custodycd = V_custodycd
        --AND A1.CDVAL LIKE V_EXECTYPE
        --AND OD.txdate >= TO_DATE(F_DATE,'DD/MM/YYYY')
        --AND OD.txdate <= TO_DATE(T_DATE,'DD/MM/YYYY')
        and od.orderid not in (select orderid from CONFIRMODRSTS)
        ORDER BY OD.TXDATE DESC, OD.ORDERID

         ) a where rownum <= ROWS_RPP * PAGE_RPP) where r > ROWS_RPP * (PAGE_RPP - 1);
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'pr_GetConfirmOrderHistByCust');
END pr_GetConfirmOrderHistByCust;

PROCEDURE pr_ConfirmOrder(
p_Orderid varchar2,
p_userId VARCHAR2,
p_custid VARCHAR2,
p_Ipadrress VARCHAR2,
p_via varchar2 default 'O',
F_DATE         IN  VARCHAR2,
T_DATE         IN  VARCHAR2,
EXECTYPE       IN  VARCHAR2,
p_err_code out varchar2
)--ham submit xac nhan lenh son.pham chuyen tu cspks_odproc.pr_ConfirmOrder
  IS
  l_reforderid VARCHAR2(20);
  l_count      NUMBER;
  l_confirmed  char(1);
  l_suborderid VARCHAR2(20);

  V_Orderid    VARCHAR2(20);
  V_EXECTYPE   VARCHAR2(20);
  BEGIN
    plog.setendsection(pkgctx, 'fn_ConfirmOrder');
    p_err_code:='0';

    IF EXECTYPE = 'ALL' OR EXECTYPE IS NULL THEN
        V_EXECTYPE := '%%';
    ELSE
        V_EXECTYPE := EXECTYPE;
    END IF;

    IF p_Orderid = 'ALL' OR p_Orderid IS NULL THEN
        V_Orderid := 'ALL';
    ELSE
        V_Orderid := p_Orderid;
    END IF;

    IF V_Orderid<>'ALL' THEN
            -- check xem lenh da dc xac nhan chua
            SELECT COUNT(*) INTO l_count FROM confirmodrsts
            WHERE orderid=p_Orderid;
            IF l_count=1 THEN
                SELECT nvl(confirmed,'N' ) INTO l_confirmed
                FROM confirmodrsts
                WHERE orderid=p_Orderid;

                IF l_confirmed = 'Y' THEN
                    p_err_code:= '-700085';
                    plog.setendsection(pkgctx, 'fn_checkTradingAllow');
                    RETURN;
                END IF;
            END IF;

            -- insert dong xac nhan cho lenh
            insert into confirmodrsts (ORDERID, CONFIRMED, USERID, custid, CFMTIME, IPADRRESS,via)
            values (p_Orderid, 'Y', p_userId, p_custid,systimestamp, p_Ipadrress,p_via );

            SELECT nvl(reforderid,'a') INTO l_reforderid FROM
            (SELECT * FROM odmast UNION ALL SELECT * FROM odmasthist)
            where orderid=p_Orderid;
            -- xac nhan cho lenh con
            SELECT COUNT(*) INTO l_count
            FROM
               (SELECT * FROM odmast UNION ALL SELECT * FROM odmasthist) OD
            WHERE reforderid=l_reforderid AND orderid <> p_Orderid;
            IF (l_count = 1) THEN
                SELECT orderid INTO l_suborderid
                  FROM
                 (SELECT * FROM odmast UNION ALL SELECT * FROM odmasthist) OD
                WHERE reforderid=l_reforderid AND orderid <> p_Orderid;
                -- check xem lenh con da duoc confirm chua
                SELECT COUNT(*)
                INTO l_count
                FROM confirmodrsts
                WHERE confirmed='Y' AND orderid= l_suborderid;
                -- insert dong xac nhan cho lenh con
                IF ( l_count = 0)  THEN
                    insert into confirmodrsts (ORDERID, CONFIRMED, USERID, custid, CFMTIME, IPADRRESS,via)
                    values (l_suborderid, 'Y', p_userId, p_custid,systimestamp, p_Ipadrress,p_via );
                END IF;
            END IF;

    ELSE
      FOR REC IN
        (SELECT OD.ORDERID

        FROM CONFIRMODRSTS CFMSTS,
             (select * from ODMAST union all select * from odmasthist) OD, SBSECURITIES SE,
              afmast af, cfmast cf
        WHERE CFMSTS.ORDERID(+)=OD.ORDERID
              AND OD.CODEID=SE.CODEID
              and ( (od.exectype in ('NB','NS','MS') AND od.via in ('F','T','H','E')) or (od.exectype  not in ('NB','NS','MS')))
              and od.exectype not in ('AB','AS') AND od.tlid <> systemnums.C_ONLINE_USERID --1.7.2.4
              and od.via not in( 'O','M','K')
              and od.txdate >=to_date('01/01/2013','DD/MM/YYYY')
              and od.afacctno=af.acctno and af.custid=cf.custid
              --AND OD.EXECTYPE LIKE V_EXECTYPE
              AND cf.CUSTID = P_CUSTID
              --AND OD.txdate >= TO_DATE(F_DATE,'DD/MM/YYYY')
              --AND OD.txdate <= TO_DATE(T_DATE,'DD/MM/YYYY')
              and od.orderid not in (select orderid from CONFIRMODRSTS)
        )
        LOOP

            -- check xem lenh da dc xac nhan chua
            SELECT COUNT(*) INTO l_count FROM confirmodrsts
            WHERE orderid=REC.ORDERID;
            IF l_count=1 THEN
                SELECT nvl(confirmed,'N' ) INTO l_confirmed
                FROM confirmodrsts
                WHERE orderid=REC.ORDERID;

                IF l_confirmed = 'Y' THEN
                    p_err_code:= '-700085';
                    plog.setendsection(pkgctx, 'fn_checkTradingAllow');
                    RETURN;
                END IF;
            END IF;

            -- insert dong xac nhan cho lenh
            insert into confirmodrsts (ORDERID, CONFIRMED, USERID, custid, CFMTIME, IPADRRESS,via)
            values (REC.ORDERID, 'Y', p_userId, p_custid,systimestamp, p_Ipadrress,p_via );

            SELECT nvl(reforderid,'a') INTO l_reforderid FROM
            (SELECT * FROM odmast UNION ALL SELECT * FROM odmasthist)
            where orderid=REC.ORDERID;

            -- xac nhan cho lenh con
            SELECT COUNT(*) INTO l_count
            FROM
               (SELECT * FROM odmast UNION ALL SELECT * FROM odmasthist) OD
            WHERE reforderid=l_reforderid AND orderid <> REC.ORDERID;

            IF (l_count = 1) THEN
                SELECT orderid INTO l_suborderid
                  FROM
                 (SELECT * FROM odmast UNION ALL SELECT * FROM odmasthist) OD
                WHERE reforderid=l_reforderid AND orderid <> REC.ORDERID;
                -- check xem lenh con da duoc confirm chua
                SELECT COUNT(*)
                INTO l_count
                FROM confirmodrsts
                WHERE confirmed='Y' AND orderid= l_suborderid;
                -- insert dong xac nhan cho lenh con
                IF ( l_count = 0)  THEN
                    insert into confirmodrsts (ORDERID, CONFIRMED, USERID, custid, CFMTIME, IPADRRESS,via)
                    values (l_suborderid, 'Y', p_userId, p_custid,systimestamp, p_Ipadrress,p_via );
                END IF;
            END IF;

       END LOOP;
    END IF;
    plog.setendsection(pkgctx, 'fn_ConfirmOrder');

  EXCEPTION
  WHEN OTHERS
   THEN
       plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'fn_ConfirmOrder');
      p_err_code:='1';
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_ConfirmOrder;

  --06/2016 toannds: ham lay danh sach tk thu huong chuyen msb
PROCEDURE pr_GETMSBTRANSFERLIST
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     ACCTNO       IN  VARCHAR2,
     MNEMONIC     in varchar2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
     )
    IS
    V_ACCTNO    VARCHAR2(10);
    V_MNEMONIC    VARCHAR2(200);
BEGIN
    V_ACCTNO:=ACCTNO;

      if MNEMONIC is null or MNEMONIC = '' or length(MNEMONIC)=0 or MNEMONIC='ALL' then
        V_MNEMONIC:= '%';
    else V_MNEMONIC:= MNEMONIC;
    end if;

    OPEN p_REFCURSOR FOR
    select *
          from (select a.*, rownum r
                   from (
       SELECT * FROM VW_STRADE_MT_ACCOUNTS
      WHERE AFACCTNO=V_ACCTNO
      AND TYPE=1 AND SUBSTR(BANKID,1,3)='302'
      and nvl(MNEMONIC,'xxx') like V_MNEMONIC
         ) a
                  where rownum <= ROWS_RPP * PAGE_RPP)
         where r > ROWS_RPP * (PAGE_RPP - 1);
EXCEPTION
  WHEN OTHERS THEN
     plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'pr_GETMSBTRANSFERLIST');
END pr_GETMSBTRANSFERLIST;

--06/2016 toannds: ham lay danh sach tk thu huong chuyen lien ngan hang
PROCEDURE pr_GETDESTTRFACCTLIST
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     ACCTNO       IN  VARCHAR2,
     MNEMONIC     in varchar2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
     )
    IS
    V_ACCTNO    VARCHAR2(10);
    V_MNEMONIC    VARCHAR2(200);
BEGIN
    V_ACCTNO:=ACCTNO;

    if MNEMONIC is null or MNEMONIC = '' or length(MNEMONIC)=0 or MNEMONIC='ALL' then
        V_MNEMONIC:= '%';
    else V_MNEMONIC:= MNEMONIC;
    end if;


    OPEN p_REFCURSOR FOR
    select *
          from (select a.*, rownum r
                   from (
       SELECT * FROM VW_STRADE_MT_ACCOUNTS
      WHERE AFACCTNO=V_ACCTNO
      and nvl(MNEMONIC,'xxx') like V_MNEMONIC
      AND TYPE=1
         ) a
                  where rownum <= ROWS_RPP * PAGE_RPP)
         where r > ROWS_RPP * (PAGE_RPP - 1);
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'pr_GETDESTTRFACCTLIST');
END pr_GETDESTTRFACCTLIST;

--05/2016 toannds: ham lay danh sach tk thu huong khac noi bo
PROCEDURE pr_GETCFOTHERBANKLIST
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     ACCTNO       IN  VARCHAR2,
     MNEMONIC     in varchar2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
     )
    IS
    V_ACCTNO    VARCHAR2(10);
    V_MNEMONIC    VARCHAR2(200);
BEGIN
    V_ACCTNO:=ACCTNO;

    if MNEMONIC is null or MNEMONIC = '' or length(MNEMONIC)=0 or MNEMONIC='ALL' then
        V_MNEMONIC:= '%';
    else V_MNEMONIC:= MNEMONIC;
    end if;

    OPEN p_REFCURSOR FOR
    select *
          from (select a.*, rownum r
                   from (
       SELECT * FROM VW_STRADE_MT_ACCOUNTS
      WHERE AFACCTNO=V_ACCTNO
            and nvl(MNEMONIC,'xxx') like V_MNEMONIC
      AND TYPE=1
         ) a
                  where rownum <= ROWS_RPP * PAGE_RPP)
         where r > ROWS_RPP * (PAGE_RPP - 1);
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'pr_GETCFOTHERBANKLIST');
END pr_GETCFOTHERBANKLIST;
--11/08/2016 ham sua tk dang ky thu huong
procedure pr_EditTranferacc(p_type in varchar2,-- 0 : Chuyen khoan noi bo.  1: Chuyen khoan ra NH
                        p_afacctno in varchar2,-- So tieu khoan goc
                        p_ciacctno in varchar2,-- So tieu khoan nhan trong truong hop chuyen khoan noi bo
                        p_ciname in varchar2,  -- Ten tieu khoan nhan trong truong hop chuyen khoan noi bo
                        p_bankacc in varchar2, -- So tk Ngan hang
                        p_bankacname in varchar2, -- Ten chu TK ngan hang
                        p_ciacctno_old in varchar2,-- So tieu khoan nhan cu trong truong hop chuyen khoan noi bo
                        p_bankacc_old in varchar2, -- So tk Ngan hang cu
                        p_mnemonic   IN VARCHAR2,  --ten goi nho tren online
                        p_err_code out varchar2,
                        p_err_message out VARCHAR2
                        ) -- Ham sua so tk chuyen khoan
IS
   v_currdate  date;
   v_count number;
   v_mnemonic varchar2(200);
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

    --chan ko cho sua TK thu huong
    p_err_code:='-670025';
    p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
    plog.error(pkgctx, 'Error:'  || p_err_message);
    plog.setendsection(pkgctx, 'pr_EditTranferacc');
    return;


    --ngoc.vu check sua ten goi nho. chi check vs cac ds khac tk dang sua
     v_mnemonic:=nvl(p_mnemonic,'xxx');
     IF p_type='1' then
      v_count:=0;
       Begin
            Select count(1) into v_count
            From cfotheracc
            Where afacctno=p_afacctno and nvl(mnemonic,'xxx')=p_mnemonic
            and bankacc <> p_bankacc_old;
        EXCEPTION
         When others then
         v_count:=0;
        End;
         IF v_count>0 then
            p_err_code:='-901209'; --check trung ten goi nho
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_regtranferacc');
            return;
          end if;
      end if;

        For vc in(select a1.acctno
                 from afmast a1, afmast a2
                 where a1.custid=a2.custid
                       and a2.acctno= p_afacctno)
       Loop
           Update cfotheracc
           Set ciaccount = p_ciacctno,
               ciname = p_ciname,
               bankacc = p_bankacc,
               bankacname=p_bankacname,
               mnemonic=p_mnemonic
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

--06/2016 Toannds ham lay ds huy dang ky lo le
PROCEDURE pr_get_canceloddorderlist
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     ACCTNO       IN  VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
     )
    IS
    V_ACCTNO    VARCHAR2(10);
BEGIN
    V_ACCTNO:=ACCTNO;


    if  PAGE_RPP = 1 then
        OPEN p_REFCURSOR FOR
              select '' TXNUM, getcurrdate TXDATE, '' SYMBOL,sum(QTTY) QTTY, sum(PRICE) PRICE, sum(AMT) AMT,
                    sum(FEEAMT) FEEAMT, sum(TAXAMT) TAXAMT, sum(REALAMT) REALAMT, 0 r
              from (select a.*
                       from (
                   SELECT TXNUM, TXDATE, SYMBOL, QTTY, PRICE, QTTY * PRICE AMT, FEEAMT, round(TAXAMT) TAXAMT, round((QTTY * PRICE) - FEEAMT - TAXAMT) REALAMT FROM
                (SELECT  FN_GET_LOCATION(AF.BRID) LOCATION, CF.CUSTODYCD,
                        C.CODEID, C.SYMBOL,
                        C.PARVALUE, A.AFACCTNO, B.* ,
                        CF.IDCODE ,A4.CDCONTENT TRADEPLACE,
                        A2.AFACCTNO AFACCTNO2
                FROM SEMAST A, SERETAIL B, SBSECURITIES C ,AFMAST AF , CFMAST CF ,ALLCODE A4,SEMAST A2
                WHERE A.ACCTNO = B.ACCTNO AND A.CODEID = C.CODEID
                      AND B.QTTY > 0 AND B.status ='N' AND AF.ACCTNO =A.AFACCTNO
                      AND AF.CUSTID =CF.CUSTID
                AND A4.CDTYPE = 'SE' AND A4.CDNAME = 'TRADEPLACE'  AND A4.CDVAL = C.TRADEPLACE
                and A2.ACCTNO=B.DESACCTNO AND AF.ACCTNO=V_ACCTNO)
             ) a)
            UNION ALL
            select *
              from (select a.*, rownum r
                       from (
                   SELECT TXNUM, TXDATE, SYMBOL, QTTY, PRICE, QTTY * PRICE AMT, FEEAMT, round(TAXAMT) TAXAMT, round((QTTY * PRICE) - FEEAMT - TAXAMT) REALAMT FROM
                (SELECT  FN_GET_LOCATION(AF.BRID) LOCATION, CF.CUSTODYCD,
                        C.CODEID, C.SYMBOL,
                        C.PARVALUE, A.AFACCTNO, B.* ,
                        CF.IDCODE ,A4.CDCONTENT TRADEPLACE,
                        A2.AFACCTNO AFACCTNO2
                FROM SEMAST A, SERETAIL B, SBSECURITIES C ,AFMAST AF , CFMAST CF ,ALLCODE A4,SEMAST A2
                WHERE A.ACCTNO = B.ACCTNO AND A.CODEID = C.CODEID
                      AND B.QTTY > 0 AND B.status ='N' AND AF.ACCTNO =A.AFACCTNO
                      AND AF.CUSTID =CF.CUSTID
                AND A4.CDTYPE = 'SE' AND A4.CDNAME = 'TRADEPLACE'  AND A4.CDVAL = C.TRADEPLACE
                and A2.ACCTNO=B.DESACCTNO AND AF.ACCTNO=V_ACCTNO)
             ) a
                      where rownum <= ROWS_RPP * PAGE_RPP)
             where r > ROWS_RPP * (PAGE_RPP - 1);
    else
        OPEN p_REFCURSOR FOR
            select *
              from (select a.*, rownum r
                       from (
                   SELECT TXNUM, TXDATE, SYMBOL, QTTY, PRICE, QTTY * PRICE AMT, FEEAMT, round(TAXAMT) TAXAMT, round((QTTY * PRICE) - FEEAMT - TAXAMT) REALAMT FROM
                (SELECT  FN_GET_LOCATION(AF.BRID) LOCATION, CF.CUSTODYCD,
                        C.CODEID, C.SYMBOL,
                        C.PARVALUE, A.AFACCTNO, B.* ,
                        CF.IDCODE ,A4.CDCONTENT TRADEPLACE,
                        A2.AFACCTNO AFACCTNO2
                FROM SEMAST A, SERETAIL B, SBSECURITIES C ,AFMAST AF , CFMAST CF ,ALLCODE A4,SEMAST A2
                WHERE A.ACCTNO = B.ACCTNO AND A.CODEID = C.CODEID
                      AND B.QTTY > 0 AND B.status ='N' AND AF.ACCTNO =A.AFACCTNO
                      AND AF.CUSTID =CF.CUSTID
                AND A4.CDTYPE = 'SE' AND A4.CDNAME = 'TRADEPLACE'  AND A4.CDVAL = C.TRADEPLACE
                and A2.ACCTNO=B.DESACCTNO AND AF.ACCTNO=V_ACCTNO)
             ) a
                      where rownum <= ROWS_RPP * PAGE_RPP)
             where r > ROWS_RPP * (PAGE_RPP - 1);
    end if;
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'pr_get_canceloddorderlist');
END pr_get_canceloddorderlist;

--06/2016 Toannds ham lay ds dang ky lo le
PROCEDURE pr_get_selloddorderlist
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     ACCTNO       IN  VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
     )
    IS
    V_ACCTNO    VARCHAR2(10);
BEGIN
    V_ACCTNO:=ACCTNO;


    if  PAGE_RPP = 1 then
        OPEN p_REFCURSOR FOR
        select '' SYMBOL, sum(QUANTITY) QUANTITY, sum(QUOTEPRICE) QUOTEPRICE, sum(AMOUNT) AMOUNT, sum(FEEAMT) FEEAMT,
                sum(TAXAMT) TAXAMT,sum(RCVAMT) RCVAMT, 0 r
              from (select a.*
                       from (
               SELECT SYMBOL, QUANTITY, QUOTEPRICE, AMOUNT, FEEAMT, TAXAMT, AMOUNT - FEEAMT - TAXAMT RCVAMT FROM
                  (SELECT SYMBOL, QUANTITY, QUOTEPRICE, QUANTITY * QUOTEPRICE AMOUNT,
                         FN_CAL_FEE_AMT(QUANTITY * QUOTEPRICE,FEETYPE) FEEAMT, ROUND(QUANTITY * QUOTEPRICE * (TAXRATE/100)) TAXAMT
                    FROM
                        (SELECT c.custodycd, s.codeid, inf.symbol, inf.floorprice quoteprice,
                              least(nvl(s.trade,0) - nvl(vw.secureamt,0), fn_GetCKLL(c.custodycd, s.codeid)) quantity,'00009' feetype,
                              CASE WHEN T.VAT ='Y' THEN (select VARVALUE from sysvar where varname = 'ADVSELLDUTY') ELSE '0' END taxrate
                            FROM SEMAST S, AFMAST A, CFMAST C,AFTYPE T, SECURITIES_INFO INF, sbsecurities sec, v_getsellorderinfo vw
                                WHERE S.AFACCTNO = A.ACCTNO AND A.CUSTID = C.CUSTID
                                      AND INF.CODEID = S.CODEID
                                      AND INF.CODEID = SEC.CODEID
                                      AND SEC.sectype <> '004'
                                      AND SEC.tradeplace in ('001','002','005')
                                      AND s.acctno = vw.seacctno(+)
                                      AND A.ACTYPE = T.ACTYPE AND A.ACCTNO = V_ACCTNO)
                   ) WHERE QUANTITY > 0
             ) a)
        UNION ALL
        select *
              from (select a.*, rownum r
                       from (
               SELECT SYMBOL, QUANTITY, QUOTEPRICE, AMOUNT, FEEAMT, TAXAMT, AMOUNT - FEEAMT - TAXAMT RCVAMT FROM
                  (SELECT SYMBOL, QUANTITY, QUOTEPRICE, QUANTITY * QUOTEPRICE AMOUNT,
                         FN_CAL_FEE_AMT(QUANTITY * QUOTEPRICE,FEETYPE) FEEAMT, ROUND(QUANTITY * QUOTEPRICE * (TAXRATE/100)) TAXAMT
                    FROM
                        (SELECT c.custodycd, s.codeid, inf.symbol, inf.floorprice quoteprice,
                              least(nvl(s.trade,0) - nvl(vw.secureamt,0), fn_GetCKLL(c.custodycd, s.codeid)) quantity,'00009' feetype,
                              CASE WHEN T.VAT ='Y' THEN (select VARVALUE from sysvar where varname = 'ADVSELLDUTY') ELSE '0' END taxrate
                            FROM SEMAST S, AFMAST A, CFMAST C,AFTYPE T, SECURITIES_INFO INF, sbsecurities sec, v_getsellorderinfo vw
                                WHERE S.AFACCTNO = A.ACCTNO AND A.CUSTID = C.CUSTID
                                      AND INF.CODEID = S.CODEID
                                      AND INF.CODEID = SEC.CODEID
                                      AND SEC.sectype <> '004'
                                      AND SEC.tradeplace in ('001','002','005')
                                      AND s.acctno = vw.seacctno(+)
                                      AND A.ACTYPE = T.ACTYPE AND A.ACCTNO = V_ACCTNO)
                   ) WHERE QUANTITY > 0
                   order by symbol
             ) a
                      where rownum <= ROWS_RPP * PAGE_RPP)
             where r > ROWS_RPP * (PAGE_RPP - 1);

    else
        OPEN p_REFCURSOR FOR
              select *
              from (select a.*, rownum r
                       from (
               SELECT SYMBOL, QUANTITY, QUOTEPRICE, AMOUNT, FEEAMT, TAXAMT, AMOUNT - FEEAMT - TAXAMT RCVAMT FROM
                  (SELECT SYMBOL, QUANTITY, QUOTEPRICE, QUANTITY * QUOTEPRICE AMOUNT,
                         FN_CAL_FEE_AMT(QUANTITY * QUOTEPRICE,FEETYPE) FEEAMT, ROUND(QUANTITY * QUOTEPRICE * (TAXRATE/100)) TAXAMT
                    FROM
                        (SELECT c.custodycd, s.codeid, inf.symbol, inf.floorprice quoteprice,
                              least(nvl(s.trade,0) - nvl(vw.secureamt,0), fn_GetCKLL(c.custodycd, s.codeid)) quantity,'00009' feetype,
                              CASE WHEN T.VAT ='Y' THEN (select VARVALUE from sysvar where varname = 'ADVSELLDUTY') ELSE '0' END taxrate
                            FROM SEMAST S, AFMAST A, CFMAST C,AFTYPE T, SECURITIES_INFO INF, sbsecurities sec, v_getsellorderinfo vw
                                WHERE S.AFACCTNO = A.ACCTNO AND A.CUSTID = C.CUSTID
                                      AND INF.CODEID = S.CODEID
                                      AND INF.CODEID = SEC.CODEID
                                      AND SEC.sectype <> '004'
                                      AND SEC.tradeplace in ('001','002','005')
                                      AND s.acctno = vw.seacctno(+)
                                      AND A.ACTYPE = T.ACTYPE AND A.ACCTNO = V_ACCTNO)
                   ) WHERE QUANTITY > 0
                   order by symbol
             ) a
                      where rownum <= ROWS_RPP * PAGE_RPP)
             where r > ROWS_RPP * (PAGE_RPP - 1);
    end if;
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'pr_get_selloddorderlist');
END pr_get_selloddorderlist;

--05/2016 Toannds: ham lay ds tai khoan thu huong noi bo
PROCEDURE pr_GETCFOTHERACC
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     ACCTNO       IN  VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
     )
    IS
    V_ACCTNO    VARCHAR2(10);
BEGIN
    V_ACCTNO:=ACCTNO;



    OPEN p_REFCURSOR FOR
    select *
          from (select a.*, rownum r
                   from (
       select ciname,ciaccount,cf.custodycd
      from cfotheracc, cfmast cf, afmast af
      where af.custid = cf.custid
      and cfotheracc.ciaccount=af.acctno
      and cfotheracc.afacctno=V_ACCTNO
         ) a
                  where rownum <= ROWS_RPP * PAGE_RPP)
         where r > ROWS_RPP * (PAGE_RPP - 1);
EXCEPTION
  WHEN OTHERS THEN
     plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'pr_GETCFOTHERACC');
END pr_GETCFOTHERACC;


PROCEDURE pr_GetConvertBondHist
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
     )
    IS
    V_AFACCTNO    VARCHAR2(10);
BEGIN
    IF AFACCTNO = 'ALL' OR AFACCTNO IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := AFACCTNO;
    END IF;

if PAGE_RPP = 0 then
    OPEN p_REFCURSOR FOR
     select * from (select a.*, rownum r from (
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
                chd.amt amount,  NVL(mk.tlname,'-----') maker_name, NVL(ck.tlname,'-----') checker_name,
                   /*'Hoan thanh'*/ A1.CDCONTENT  STATUS, 'Completed'  EN_STATUS,
                decode (af.COREBANK,'Y',AF.bankname, UTF8NUMS.c_const_COMPANY_NAME) bankname, ca.tosymbol tosymbol
        FROM
        (SELECT * FROM catran
        UNION all
        SELECT * FROM catrana) tran,ALLCODE A1,
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
        AND TL.DELTD<>'Y'
        AND A1.CDTYPE='SY' AND A1.CDNAME='TXSTATUS' AND A1.CDVAL='1'
        AND tl.busdate >= TO_DATE(F_DATE,'DD/MM/YYYY') AND tl.busdate <= TO_DATE(T_DATE,'DD/MM/YYYY')
        AND AF.ACCTNO LIKE V_AFACCTNO

        ORDER BY tran.TXDATE,tran.txnum,ca.symbol
        ) a);
else
    OPEN p_REFCURSOR FOR
     select * from (select a.*, rownum r from (
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
                chd.amt amount,  NVL(mk.tlname,'-----') maker_name, NVL(ck.tlname,'-----') checker_name,
                  /*'Hoan thanh'*/ A1.CDCONTENT  STATUS, 'Completed'  EN_STATUS,
                decode (af.COREBANK,'Y',AF.bankname, UTF8NUMS.c_const_COMPANY_NAME) bankname, ca.tosymbol tosymbol
        FROM
        (SELECT * FROM catran
        UNION all
        SELECT * FROM catrana) tran, ALLCODE A1,
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
         AND TL.DELTD<>'Y'
        AND A1.CDTYPE='SY' AND A1.CDNAME='TXSTATUS' AND A1.CDVAL='1'
        AND tl.busdate >= TO_DATE(F_DATE,'DD/MM/YYYY') AND tl.busdate <= TO_DATE(T_DATE,'DD/MM/YYYY')
        AND AF.ACCTNO LIKE V_AFACCTNO

        ORDER BY tran.TXDATE,tran.txnum,ca.symbol
        ) a where rownum <= ROWS_RPP * PAGE_RPP) where r > ROWS_RPP * (PAGE_RPP - 1);
end if;
EXCEPTION
  WHEN OTHERS THEN
     plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'pr_GetConvertBondHist');
END pr_GetConvertBondHist;
--END pr_GetConvertBondHist

--Ham tra cuu thong tin tra no
--Binhpt
PROCEDURE pr_GetRePaymentHist
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     p_AFACCTNO       IN  VARCHAR2,
     F_DATE         IN  VARCHAR2,
     T_DATE         IN  VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
     )
    IS
   V_STRACCTNO      VARCHAR2 (20);
BEGIN
V_STRACCTNO:=p_AFACCTNO;
IF PAGE_RPP = 1 THEN
    OPEN p_REFCURSOR FOR
    SELECT 0 autoid, CURRENT_DATE txdate --ngay tra no
        , '' acctno
        , CURRENT_DATE rlsdate --ngay giai ngan
        , CURRENT_DATE overduedate, --ngay dao han
         SUM(F_GTGN) F_GTGN, --tong no goc ban dau
        SUM(F_GTTL) F_GTTL, --so tien tra no goc
        SUM(F_DNHT) F_DNHT, --no goc con lai
        SUM(F_GTNL) F_GTNL--so tien tra no lai
        , 0 R
    FROM (
    select lntr.autoid, lntr.txdate --ngay tra no
        , ln.acctno
        , ls.rlsdate --ngay giai ngan
        , ls.overduedate, --ngay dao han
        ls.nml + ls.ovd + ls.paid F_GTGN, --tong no goc ban dau
        ABS(lntr.prin_move) F_GTTL, --so tien tra no goc
        ls.nml + ls.ovd - sum(nvl(lnmov.prin_move,0)) F_DNHT, --no goc con lai
        lntr.int_move F_GTNL--so tien tra no lai
    from    (select * from VW_LNMAST_ALL where trfacctno LIKE V_STRACCTNO ) ln
            inner join
            (select * from VW_LNSCHD_ALL where reftype in ('P','GP')  ) ls on ln.acctno = ls.acctno
            inner join
            (
                select autoid, txdate
                    ,sum((case when nml > 0 then 0 else nml end) + ovd) PRIN_MOVE
                        /*sum(intnmlacr +intdue+intovd+intovdprin +
                        feeintnmlacr+ feeintdue+feeintovd+feeintovdprin) PRFEE_MOVE*/
                    ,sum(intpaid) INT_MOVE
                from VW_LNSCHDLOG_ALL lnslog
                where (case when nml > 0 then 0 else nml end) + ovd + intpaid <> 0
                and txdate >= TO_DATE(F_DATE,'DD/MM/YYYY') and txdate <= TO_DATE(T_DATE,'DD/MM/YYYY')
                group by autoid,txdate
            ) LNTR  on ls.autoid = lntr.autoid
            left join
            (
                select log.autoid, log.txdate,sum((case when log.nml > 0 then 0 else log.nml end) + log.ovd) PRIN_MOVE
                from VW_LNSCHDLOG_ALL log, VW_LNMAST_ALL LN, VW_LNSCHD_ALL LM
                where (case when log.nml > 0 then 0 else log.nml end) + log.ovd <> 0
                AND LOG.AUTOID=LM.AUTOID AND LN.ACCTNO=LM.ACCTNO AND LN.TRFACCTNO  LIKE V_STRACCTNO
                group by log.autoid,log.txdate

            ) LNmov on lntr.autoid = lnmov.autoid and lnmov.txdate > lntr.txdate
    group by lntr.autoid, lntr.txdate, ln.acctno, ls.rlsdate, ls.overduedate,
        ls.nml , ls.ovd , ls.paid ,
        lntr.prin_move, lntr.int_move
    order by lntr.txdate desc, lntr.autoid
    )
    UNION ALL
     select * from (select a.*, rownum r from (
    select lntr.autoid, lntr.txdate --ngay tra no
        , ln.acctno
        , ls.rlsdate --ngay giai ngan
        , ls.overduedate, --ngay dao han
        ls.nml + ls.ovd + ls.paid F_GTGN, --tong no goc ban dau
        ABS(lntr.prin_move) F_GTTL, --so tien tra no goc
        ls.nml + ls.ovd - sum(nvl(lnmov.prin_move,0)) F_DNHT, --no goc con lai
        lntr.int_move F_GTNL--so tien tra no lai
    from    (select * from VW_LNMAST_ALL where trfacctno LIKE V_STRACCTNO ) ln
            inner join
            (select * from VW_LNSCHD_ALL where reftype in ('P','GP')  ) ls on ln.acctno = ls.acctno
            inner join
            (
                select autoid, txdate
                    ,sum((case when nml > 0 then 0 else nml end) + ovd) PRIN_MOVE
                        /*sum(intnmlacr +intdue+intovd+intovdprin +
                        feeintnmlacr+ feeintdue+feeintovd+feeintovdprin) PRFEE_MOVE*/
                    ,sum(intpaid) INT_MOVE
                from VW_LNSCHDLOG_ALL lnslog
                where (case when nml > 0 then 0 else nml end) + ovd + intpaid <> 0
                and txdate >= TO_DATE(F_DATE,'DD/MM/YYYY') and txdate <= TO_DATE(T_DATE,'DD/MM/YYYY')
                group by autoid,txdate
            ) LNTR  on ls.autoid = lntr.autoid
            left join
            (
                select log.autoid, log.txdate,sum((case when log.nml > 0 then 0 else log.nml end) + log.ovd) PRIN_MOVE
                from VW_LNSCHDLOG_ALL log, VW_LNMAST_ALL LN, VW_LNSCHD_ALL LM
                where (case when log.nml > 0 then 0 else log.nml end) + log.ovd <> 0
                AND LOG.AUTOID=LM.AUTOID AND LN.ACCTNO=LM.ACCTNO AND LN.TRFACCTNO  LIKE V_STRACCTNO
                group by log.autoid,log.txdate

            ) LNmov on lntr.autoid = lnmov.autoid and lnmov.txdate > lntr.txdate
     group by lntr.autoid, lntr.txdate, ln.acctno, ls.rlsdate, ls.overduedate,
        ls.nml , ls.ovd , ls.paid ,
        lntr.prin_move, lntr.int_move
     order by lntr.txdate desc, lntr.autoid
     ) a where rownum <= ROWS_RPP * PAGE_RPP) where r > ROWS_RPP * (PAGE_RPP - 1);

ELSE
    if PAGE_RPP = 0 then
    OPEN p_REFCURSOR FOR
     select * from (select a.*, rownum r from (
    select lntr.autoid, lntr.txdate --ngay tra no
        , ln.acctno
        , ls.rlsdate --ngay giai ngan
        , ls.overduedate, --ngay dao han
        ls.nml + ls.ovd + ls.paid F_GTGN, --tong no goc ban dau
        ABS(lntr.prin_move) F_GTTL, --so tien tra no goc
        ls.nml + ls.ovd - sum(nvl(lnmov.prin_move,0)) F_DNHT, --no goc con lai
        lntr.int_move F_GTNL--so tien tra no lai
    from    (select * from VW_LNMAST_ALL where trfacctno LIKE V_STRACCTNO ) ln
            inner join
            (select * from VW_LNSCHD_ALL where reftype in ('P','GP')  ) ls on ln.acctno = ls.acctno
            inner join
            (
                select autoid, txdate
                    ,sum((case when nml > 0 then 0 else nml end) + ovd) PRIN_MOVE
                        /*sum(intnmlacr +intdue+intovd+intovdprin +
                        feeintnmlacr+ feeintdue+feeintovd+feeintovdprin) PRFEE_MOVE*/
                    ,sum(intpaid) INT_MOVE
                from VW_LNSCHDLOG_ALL lnslog
                where (case when nml > 0 then 0 else nml end) + ovd + intpaid <> 0
                and txdate >= TO_DATE(F_DATE,'DD/MM/YYYY') and txdate <= TO_DATE(T_DATE,'DD/MM/YYYY')
                group by autoid,txdate
            ) LNTR  on ls.autoid = lntr.autoid
            left join
            (
                select log.autoid, log.txdate,sum((case when log.nml > 0 then 0 else log.nml end) + log.ovd) PRIN_MOVE
                from VW_LNSCHDLOG_ALL log, VW_LNMAST_ALL LN, VW_LNSCHD_ALL LM
                where (case when log.nml > 0 then 0 else log.nml end) + log.ovd <> 0
                AND LOG.AUTOID=LM.AUTOID AND LN.ACCTNO=LM.ACCTNO AND LN.TRFACCTNO  LIKE V_STRACCTNO
                group by log.autoid,log.txdate

            ) LNmov on lntr.autoid = lnmov.autoid and lnmov.txdate > lntr.txdate
       group by lntr.autoid, lntr.txdate, ln.acctno, ls.rlsdate, ls.overduedate,
        ls.nml , ls.ovd , ls.paid ,
        lntr.prin_move, lntr.int_move
       order by lntr.txdate desc, lntr.autoid
      ) a);

      else
      OPEN p_REFCURSOR FOR
      select * from (select a.*, rownum r from (
      select lntr.autoid, lntr.txdate --ngay tra no
        , ln.acctno
        , ls.rlsdate --ngay giai ngan
        , ls.overduedate, --ngay dao han
        ls.nml + ls.ovd + ls.paid F_GTGN, --tong no goc ban dau
        ABS(lntr.prin_move) F_GTTL, --so tien tra no goc
        ls.nml + ls.ovd - sum(nvl(lnmov.prin_move,0)) F_DNHT, --no goc con lai
        lntr.int_move F_GTNL--so tien tra no lai
       from     (select * from VW_LNMAST_ALL where trfacctno LIKE V_STRACCTNO ) ln
            inner join
            (select * from VW_LNSCHD_ALL where reftype in ('P','GP')  ) ls on ln.acctno = ls.acctno
            inner join
            (
                select autoid, txdate
                    ,sum((case when nml > 0 then 0 else nml end) + ovd) PRIN_MOVE
                        /*sum(intnmlacr +intdue+intovd+intovdprin +
                        feeintnmlacr+ feeintdue+feeintovd+feeintovdprin) PRFEE_MOVE*/
                    ,sum(intpaid) INT_MOVE
                from VW_LNSCHDLOG_ALL lnslog
                where (case when nml > 0 then 0 else nml end) + ovd + intpaid <> 0
                and txdate >= TO_DATE(F_DATE,'DD/MM/YYYY') and txdate <= TO_DATE(T_DATE,'DD/MM/YYYY')
                group by autoid,txdate
            ) LNTR  on ls.autoid = lntr.autoid
            left join
            (
                 select log.autoid, log.txdate,sum((case when log.nml > 0 then 0 else log.nml end) + log.ovd) PRIN_MOVE
                from VW_LNSCHDLOG_ALL log, VW_LNMAST_ALL LN, VW_LNSCHD_ALL LM
                where (case when log.nml > 0 then 0 else log.nml end) + log.ovd <> 0
                AND LOG.AUTOID=LM.AUTOID AND LN.ACCTNO=LM.ACCTNO AND LN.TRFACCTNO  LIKE V_STRACCTNO
                group by log.autoid,log.txdate

            ) LNmov on lntr.autoid = lnmov.autoid and lnmov.txdate > lntr.txdate
      group by lntr.autoid, lntr.txdate, ln.acctno, ls.rlsdate, ls.overduedate,
        ls.nml , ls.ovd , ls.paid ,
        lntr.prin_move, lntr.int_move
      order by lntr.txdate desc, lntr.autoid
      ) a where rownum <= ROWS_RPP * PAGE_RPP) where r > ROWS_RPP * (PAGE_RPP - 1);
      end if;
END IF;

EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'pr_GetRePaymentHist');
END pr_GetRePaymentHist;


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
       AND T.CODE NOT IN ('0208','0334','0808','324A','324B','0555'/*, '0323'*/)--1.8.1.6 bo chan gui sms
       Order by t.type, t.code;
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'pr_GetAFTemplates');
END pr_GetAFTemplates;


--tong tai san
PROCEDURE pr_GetNetAssetDetail_byCus
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     p_CUSTODYCD in varchar2,
     p_AFACCTNO    IN VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
     )
    IS

    v_custodycd varchar2(10);
    v_afacctno varchar2(10);
BEGIN
    if p_CUSTODYCD is null or p_CUSTODYCD = '' or length(p_CUSTODYCD)=0 then
        v_custodycd:= '%';
    else v_custodycd:= p_CUSTODYCD;
    end if;

    if p_AFACCTNO is null or p_AFACCTNO = 'ALL' or length(p_AFACCTNO)=0 then
        v_afacctno:= '%';
    else --v_afacctno:= p_AFACCTNO;
        V_AFACCTNO := p_afacctno;
        SELECT CF.CUSTODYCD INTO V_CUSTODYCD
        FROM AFMAST AF, CFMAST CF
        WHERE AF.custid = CF.custid AND AF.ACCTNO = p_afacctno;
    end if;
if PAGE_RPP = 0 then
OPEN p_REFCURSOR FOR

   select * from (select a.*, rownum r from (
   SELECT ITEM, MST.ACCTNO AFACCTNO, trunc(TOTAL) TOTAL, trunc(trade) trade,trunc(receiving) receiving ,
        trunc(secured) secured, trunc(basicprice) basicprice,trunc(COSTPRICE) costprice, trunc(MARKETAMT) marketamt,
        receiving_right,receiving_t0,receiving_t1,receiving_t2,receiving_t3
          FROM (
              SELECT TO_CHAR(SB.SYMBOL) ITEM, SDTL.AFACCTNO ACCTNO,
                    SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED
                    + nvl(od.B_execqtty_new,0) + SDTL.RECEIVING + SDTL.SECURITIES_RECEIVING_T3 + nvl(od.REMAINQTTY,0) TOTAL,
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
              ) MST order by ITEM
              ) a );
else
   OPEN p_REFCURSOR FOR

   select '' ITEM, '' AFACCTNO, 0 TOTAL, 0 trade,0 receiving ,
        0 secured, 0 basicprice,0 costprice, sum(trunc(MARKETAMT)) marketamt,
        0 receiving_right,0 receiving_t0,0 receiving_t1,0 receiving_t2,0 receiving_t3, 0 r from (
   SELECT ITEM, MST.ACCTNO AFACCTNO, trunc(TOTAL) TOTAL, trunc(trade) trade,trunc(receiving) receiving ,
        trunc(secured) secured, trunc(basicprice) basicprice,trunc(COSTPRICE) costprice, trunc(MARKETAMT) marketamt,
        receiving_right,receiving_t0,receiving_t1,receiving_t2,receiving_t3
          FROM (
              SELECT TO_CHAR(SB.SYMBOL) ITEM, SDTL.AFACCTNO ACCTNO,
                    SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED
                    + nvl(od.B_execqtty_new,0) + SDTL.RECEIVING + SDTL.SECURITIES_RECEIVING_T3 + nvl(od.REMAINQTTY,0) TOTAL,
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
              ) MST order by ITEM
              ) a
UNION ALL
   select * from (select a.*, rownum r from (
   SELECT ITEM, MST.ACCTNO AFACCTNO, trunc(TOTAL) TOTAL, trunc(trade) trade,trunc(receiving) receiving ,
        trunc(secured) secured, trunc(basicprice) basicprice,trunc(COSTPRICE) costprice, trunc(MARKETAMT) marketamt,
        receiving_right,receiving_t0,receiving_t1,receiving_t2,receiving_t3
          FROM (
              SELECT TO_CHAR(SB.SYMBOL) ITEM, SDTL.AFACCTNO ACCTNO,
                    SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED
                    + nvl(od.B_execqtty_new,0) + SDTL.RECEIVING + SDTL.SECURITIES_RECEIVING_T3 + nvl(od.REMAINQTTY,0) TOTAL,
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
              ) MST order by ITEM
              ) a where rownum <= ROWS_RPP * PAGE_RPP) where r > ROWS_RPP * (PAGE_RPP - 1);
end if;
EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'pr_GetNetAssetDetail_byCus');
END pr_GetNetAssetDetail_byCus;

--thong tin tong quat ve tieu khoan
PROCEDURE pr_GetTotalAssetInfo
    (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     p_CUSTODYCD in varchar2,
     p_AFACCTNO    IN VARCHAR2,
     PAGE_RPP IN NUMBER,
     ROWS_RPP IN NUMBER
     )
    IS

    v_custodycd varchar2(10);
    v_afacctno varchar2(10);
    v_currdate date;

    v_baldefovd  number;
    v_odamt number;
    V_SEASS number;
    v_fomode varchar2(100);
    v_Secure_Amt number(20);
BEGIN

    v_afacctno:= p_AFACCTNO;

    SELECT to_date(VARVALUE,'DD/MM/rrrr')
    INTO v_currdate
    FROM  sysvar
    WHERE  grname='SYSTEM' AND varname='CURRDATE';

/*INSERT INTO log_err
                        (id,date_log, POSITION, text
                        )
                 VALUES ( seq_log_err.NEXTVAL,SYSDATE, 'pr_GetTotalAssetInfo','p_AFACCTNO:' || p_AFACCTNO ||' PAGE_RPP:'||PAGE_RPP
                        );
                        COMMIT;*/
 /*
FOR m IN (SELECT * FROM VW_PORTFOLIO_RPP_FO  WHERE acctno  = p_AFACCTNO)
LOOP
INSERT INTO log_err
                        (id,date_log, POSITION, text
                        )
                 VALUES ( seq_log_err.NEXTVAL,SYSDATE, 'pr_GetTotalAssetInfo','p_AFACCTNO:' || p_AFACCTNO ||' m.item :'||m.item ||' m.trade :'||m.trade ||' m.total :'||m.total
                        );

END LOOP;

FOR m IN (SELECT * FROM buf_se_account  WHERE afacctno  = p_AFACCTNO)
LOOP
INSERT INTO log_err
                        (id,date_log, POSITION, text
                        )
                 VALUES ( seq_log_err.NEXTVAL,SYSDATE, 'pr_GetTotalAssetInfo','p_AFACCTNO:' || p_AFACCTNO ||' m.symbol :'||m.symbol ||' m.trade :'||m.trade
                        );

END LOOP;
COMMIT;
*/

    SELECT varvalue INTO v_fomode FROM sysvar WHERE varname ='FOMODE' AND grname ='SYSTEM';
    IF v_fomode = 'ON' THEN

/*        SELECT round(sum(marketamt)) INTO V_SEASS
            FROM  VW_PORTFOLIO_RPP_FO
            WHERE acctno = v_afacctno;*/

        /*
        SELECT round( ci.balance - nvl(b.secureamt,0) - nvl(b.advamt,0)  + nvl(adv.avladvance,0)
                      - ci.OVAMT - ci.DUEAMT ) MoneyTotal,    --Tong tien
                     round(ci.depofeeamt+ci.ODAMT) ODAMT      --tong no + tien du tinh lai bao lanh
          INTO v_baldefovd, v_odamt
          FROM  cimast ci, v_getbuyorderinfo b, cfmast cf,
                    (   select sum(aamt) aamt,sum(depoamt) avladvance,sum(paidamt) paidamt, sum(advamt) advanceamount,afacctno
                        from v_getAccountAvlAdvance group by afacctno
                    ) adv
         WHERE ci.ACCTNO=adv.afacctno(+)
           AND ci.CUSTID=cf.custid
           AND ci.ACCTNO = b.afacctno (+)
           AND ci.acctno LIKE  v_afacctno ;
        */
        v_Secure_Amt:=  CSPKS_FO_COMMON.fn_get_buy_amt@DBL_FO(V_AFACCTNO);
        BEGIN
            SELECT ROUND(
                          NVL(FO_ACCT.BOD_BALANCE,0) - v_Secure_Amt  +  NVL(FO_ACCT.CALC_ADVBAL,0) + NVL(FO_ACCT.bod_adv,0) - NVL(BOD_DEBT_M,0)
                         ) MoneyTotal,
                   ROUND(NVL(BOD_DEBT,0) + NVL(BOD_PAYABLE,0)) DEBT
            INTO  v_baldefovd, v_odamt
            FROM ACCOUNTS@DBL_FO FO_ACCT WHERE  ACCTNO = v_afacctno;
        EXCEPTION WHEN OTHERS THEN
          v_baldefovd:=0;
          v_odamt    :=0;
        END;

            OPEN p_REFCURSOR FOR
            SELECT to_char(fnc_get_NAV(V_AFACCTNO),'999,999,999,999,999') SYMBOL, 0 QTTY,-- TONG TAI SAN
                   V_ODAMT PNL, -- NO
                   V_BALDEFOVD PC, --TIEN
                   0 marketamt,
                   0 R
            FROM DUAL

            UNION ALL
/*
            SELECT *
            FROM
            ( SELECT A.*, ROWNUM R
             FROM
             (*/
                    SELECT ITEM SYMBOL, TRUNC(TOTAL) QTTY, TRUNC(PROFITANDLOSS)  PNL, PCPL PC, marketamt, 1 R
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
                                                        AND BUF.AFACCTNO = V_AFACCTNO
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
                                    AND SDTL.CODEID = SEC.CODEID AND SDTL.AFACCTNO = V_AFACCTNO
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
                                AND a.acctno = V_AFACCTNO
                                GROUP BY a.ACCTNO, a.CUSTODYCD, P_FO.SYMBOL,P_FO.TRADE

                            )
                             ORDER BY CUSTODYCD,ACCTNO,ITEM
                             ))
                    WHERE ACCTNO = V_AFACCTNO
/*              ) A
               WHERE ROWNUM <= ROWS_RPP * PAGE_RPP
            )
            WHERE R > ROWS_RPP * (PAGE_RPP - 1)*/
            ;


    ELSE  --FOMODE OFF

        SELECT round(sum(marketamt)) INTO V_SEASS
        FROM  VW_PORTFOLIO_RPP
        where acctno like v_afacctno;





          SELECT round( ci.balance - nvl(b.secureamt,0) - nvl(b.advamt,0)  + nvl(adv.avladvance,0)
                  - ci.OVAMT - ci.DUEAMT ) MoneyTotal,    --Tong tien
                 round(ci.depofeeamt+ci.ODAMT ) ODAMT   --tong no + tien du tinh lai bao lanh
            into v_baldefovd, v_odamt

          FROM   cimast ci, v_getbuyorderinfo b, cfmast cf,
                (   select sum(aamt) aamt,sum(depoamt) avladvance,sum(paidamt) paidamt, sum(advamt) advanceamount,afacctno
                    from v_getAccountAvlAdvance group by afacctno
                ) adv
          WHERE  ci.ACCTNO=adv.afacctno(+)
          and ci.CUSTID=cf.custid

          and ci.ACCTNO = b.afacctno (+)
          and ci.acctno like  v_afacctno

          ;

        if (PAGE_RPP = 1) then
        OPEN p_REFCURSOR FOR



        select '' SYMBOL, V_SEASS QTTY,-- Tong tai san
               v_odamt PNL, -- No
               v_baldefovd PC, --Tien
               0 R
        from dual

        union all

        select *
        from
        ( select a.*, rownum r
         from
         (
                select item symbol, trunc(total) QTTY, trunc(PROFITANDLOSS)  PNL, PCPL PC
                from VW_PORTFOLIO_RPP
                where acctno = v_afacctno
          ) a
           where rownum <= ROWS_RPP * PAGE_RPP
        )
        where r > ROWS_RPP * (PAGE_RPP - 1)
        ;


        else
        OPEN p_REFCURSOR FOR

             select *
             from
             ( select a.*, rownum r
               from
               (
                    select item symbol, trunc(total) QTTY, trunc(PROFITANDLOSS)  PNL, PCPL PC
                    from VW_PORTFOLIO_RPP
                    where acctno = v_afacctno
                ) a
                 where rownum <= ROWS_RPP * PAGE_RPP
              )
              where r > ROWS_RPP * (PAGE_RPP - 1)
              ;

        end if;
     END IF; -- FOMODE OFF.

EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'pr_GetTotalAssetInfo');

END pr_GetTotalAssetInfo;

--danh sach lenh thong thuong
PROCEDURE pr_get_normalorderlist
    (P_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD     IN VARCHAR2,
 /*    PLACECUSTID  IN VARCHAR2,
     TXDATE         IN VARCHAR2,*/
     AFACCTNO        IN VARCHAR2,
     EXECTYPE         IN VARCHAR2,
     SYMBOL             IN VARCHAR2,
     STATUS          IN VARCHAR2,
     ODTIMESTAMP     IN VARCHAR2,
     PAGE_RPP          IN NUMBER,
     ROWS_RPP        IN NUMBER
     )

    IS

    v_custodycd varchar2(10);
    v_afacctno varchar2(10);
   -- v_placecustid  varchar2(20);
  --  p_txdate   date;
    v_exectype  varchar2(20);
    v_symbol  varchar2(20);
    v_status  varchar2(20);

    v_currdate date;
    v_ODTIMESTAMP varchar2(1000);

BEGIN
  --sua theo ket noi Fo truyen custodycd la custid
    if CUSTODYCD is null or CUSTODYCD = '' or length(CUSTODYCD)=0 then
        v_custodycd:= '%';
    else v_custodycd:= CUSTODYCD;
    end if;

    if AFACCTNO is null or AFACCTNO = '' or length(AFACCTNO)=0 or AFACCTNO='ALL' then
        v_afacctno:= '%';
    else v_afacctno:= AFACCTNO;
    end if;

    if ODTIMESTAMP='0' OR ODTIMESTAMP is null or ODTIMESTAMP = '' or length(ODTIMESTAMP)=0 or ODTIMESTAMP='ALL' then
        v_ODTIMESTAMP:= 'ALL';
    else v_ODTIMESTAMP:= ODTIMESTAMP;
    end if;
  /*  if PLACECUSTID is null or PLACECUSTID = '' or length(PLACECUSTID)=0 then
        v_placecustid:= '%';
    else v_placecustid:= PLACECUSTID;
    end if;*/

   if EXECTYPE is null or EXECTYPE = '' or length(EXECTYPE)=0 or EXECTYPE='ALL' then
        v_exectype:= '%';
    else v_exectype:= EXECTYPE;
    end if;

    if SYMBOL is null or SYMBOL = '' or length(SYMBOL)=0 then
        v_symbol:= '%';
    else v_symbol:= '%'||SYMBOL||'%';
    end if;

    if STATUS is null or STATUS = '' or length(STATUS)=0 or STATUS='ALL' then
        v_status:= '%';
    else v_status:= STATUS;
    end if;


    select to_date(VARVALUE,'DD/MM/rrrr') into v_currdate from sysvar where grname='SYSTEM' and varname='CURRDATE';

    IF   v_ODTIMESTAMP= 'ALL' THEN

       OPEN p_REFCURSOR
       FOR

          select * from (
              select a.*, rownum r from (
                    SELECT SUBSTR(ORDERID, LENGTH(ORDERID)-5,6) SUB_ORDERID ,  C.CUSTODYCD, C.AFACCTNO, C.EXECTYPE EXECTYPECD, cd4.CDCONTENT EXECTYPE,cd4.EN_CDCONTENT EN_EXECTYPE,
                          C.SYMBOL, C.ORDERQTTY, C.QUOTEPRICE * 1000 QUOTEPRICE,
                          C.EXECQTTY, DECODE(C.EXECQTTY,0, 0, ROUND(C.EXECAMT/C.EXECQTTY,4)) EXECPRICE,
                          C.REMAINQTTY,C.CANCELQTTY,C.ORSTATUSVALUE ORSTATUSCD, C.ORSTATUS, CD1.EN_CDCONTENT EN_ORSTATUS,
                          C.PRICETYPE,  C.VIA, CD3.EN_CDCONTENT EN_VIA,
                          C.TXTIME, CASE WHEN C.USERNAME=CF.CUSTID THEN 'Y' ELSE 'N' END ISCUSTODYCD,
                          C.TIMETYPE,CD2.EN_CDCONTENT EN_TIMETYPE, C.ORDERID,C.FEEDBACKMSG,
                          DECODE(C.ISDISPOSAL,'Y','N', C.ISCANCEL) ISCANCEL,
                          DECODE(C.ISDISPOSAL,'Y','N', C.ISADMEND) ISADMEND,
                          C.ISDISPOSAL,nvl(OD.TIMESTAMPS,'') ODTIMESTAMP

                    FROM BUF_OD_ACCOUNT C, CFMAST CF, ALLCODE CD1, ALLCODE CD2, ALLCODE CD3, allcode cd4,
                        (  SELECT to_char( max(C.ODTIMESTAMP)) TIMESTAMPS
                          FROM BUF_OD_ACCOUNT C, CFMAST CF, ALLCODE CD1, ALLCODE CD2, ALLCODE CD3, allcode cd4
                          WHERE --(c.CUSTODYCD=v_custodycd )
                                (cf.CUSTID=v_custodycd or c.USERNAME=v_custodycd)
                                AND C.TXDATE=v_currdate
                                AND C.AFACCTNO LIKE v_afacctno
                                AND C.EXECTYPE LIKE v_exectype
                                AND C.SYMBOL LIKE v_symbol
                                AND C.ORSTATUSVALUE LIKE v_status
                               -- and (case when v_ODTIMESTAMP= 'ALL' THEN SYSTIMESTAMP ELSE C.ODTIMESTAMP END) > ODTIMESTAMP
                                AND ((C.TIMETYPEVALUE='T' /*AND C.ORSTATUSVALUE <> '10'*/) -- Lenh binh thuong, bao gom ca lenh goc va lenh sua
                                OR (C.TIMETYPEVALUE='G' AND C.ORSTATUSVALUE NOT IN ('5', 'P', '6', 'W', 'R')) --Het hieu luc, tu choi, R:lenh dieu kien chua active, bi huy
                                )
                                AND C.CUSTODYCD=CF.CUSTODYCD
                                AND CD1.cdtype ='OD' AND CD1.CDNAME='ORSTATUS' AND CD1.CDVAL= C.ORSTATUSVALUE
                                AND CD2.cdtype ='OD' AND CD2.CDNAME='TIMETYPE' AND CD2.CDVAL=C.TIMETYPEVALUE
                                AND CD3.CDTYPE='OD' AND CD3.CDNAME='VIA' AND C.VIA=CD3.CDCONTENT
                                AND CD4.CDTYPE='OD' AND CD4.CDNAME='EXECTYPE' AND C.EXECTYPE=CD4.cdval) OD
                    WHERE --(c.CUSTODYCD=v_custodycd )
                          (cf.CUSTID=v_custodycd or c.USERNAME=v_custodycd)
                          AND C.TXDATE=v_currdate
                          AND C.AFACCTNO LIKE v_afacctno
                          AND C.EXECTYPE LIKE v_exectype
                          AND C.SYMBOL LIKE v_symbol
                          AND C.ORSTATUSVALUE LIKE v_status
                          AND ((C.TIMETYPEVALUE='T' /*AND C.ORSTATUSVALUE <> '10'*/) -- Lenh binh thuong, bao gom ca lenh goc va lenh sua
                          OR (C.TIMETYPEVALUE='G' AND C.ORSTATUSVALUE NOT IN ('5', 'P', '6', 'W', 'R')) --Het hieu luc, tu choi, R:lenh dieu kien chua active, bi huy
                          )
                          AND C.CUSTODYCD=CF.CUSTODYCD
                          AND CD1.cdtype ='OD' AND CD1.CDNAME='ORSTATUS' AND CD1.CDVAL= C.ORSTATUSVALUE
                          AND CD2.cdtype ='OD' AND CD2.CDNAME='TIMETYPE' AND CD2.CDVAL=C.TIMETYPEVALUE
                          AND CD3.CDTYPE='OD' AND CD3.CDNAME='VIA' AND C.VIA=CD3.CDCONTENT
                          AND CD4.CDTYPE='OD' AND CD4.CDNAME='EXECTYPE' AND C.EXECTYPE=CD4.cdval
                    ORDER BY C.TXDATE DESC, C.TXTIME DESC, C.ORDERID desc, C.CUSTODYCD, C.AFACCTNO,C.SYMBOL
               ) a where rownum <= ROWS_RPP * PAGE_RPP
               )
                where  r > ROWS_RPP * (PAGE_RPP - 1);

    ELSE

       OPEN p_REFCURSOR
       FOR

          select * from (
              select a.*, rownum r from (
                    SELECT SUBSTR(ORDERID, LENGTH(ORDERID)-5,6) SUB_ORDERID ,  C.CUSTODYCD, C.AFACCTNO, C.EXECTYPE EXECTYPECD, cd4.CDCONTENT EXECTYPE,cd4.EN_CDCONTENT EN_EXECTYPE,
                          C.SYMBOL, C.ORDERQTTY, C.QUOTEPRICE * 1000 QUOTEPRICE,
                          C.EXECQTTY, DECODE(C.EXECQTTY,0, 0, ROUND(C.EXECAMT/C.EXECQTTY,4)) EXECPRICE,
                          C.REMAINQTTY,C.CANCELQTTY,C.ORSTATUSVALUE ORSTATUSCD, C.ORSTATUS, CD1.EN_CDCONTENT EN_ORSTATUS,
                          C.PRICETYPE,  C.VIA, CD3.EN_CDCONTENT EN_VIA,
                          C.TXTIME, CASE WHEN C.USERNAME=CF.CUSTID THEN 'Y' ELSE 'N' END ISCUSTODYCD,
                          C.TIMETYPE,CD2.EN_CDCONTENT EN_TIMETYPE, C.ORDERID,C.FEEDBACKMSG,
                          DECODE(C.ISDISPOSAL,'Y','N', C.ISCANCEL) ISCANCEL,
                          DECODE(C.ISDISPOSAL,'Y','N', C.ISADMEND) ISADMEND,
                          C.ISDISPOSAL,nvl(OD.TIMESTAMPS,'') ODTIMESTAMP

                    FROM BUF_OD_ACCOUNT C, CFMAST CF, ALLCODE CD1, ALLCODE CD2, ALLCODE CD3, allcode cd4,
                     (  SELECT to_char( max(C.ODTIMESTAMP)) TIMESTAMPS
                          FROM BUF_OD_ACCOUNT C, CFMAST CF, ALLCODE CD1, ALLCODE CD2, ALLCODE CD3, allcode cd4
                          WHERE --(c.CUSTODYCD=v_custodycd )
                                (cf.CUSTID=v_custodycd or c.USERNAME=v_custodycd)
                                AND C.TXDATE=v_currdate
                                AND C.AFACCTNO LIKE v_afacctno
                                AND C.EXECTYPE LIKE v_exectype
                                AND C.SYMBOL LIKE v_symbol
                                AND C.ORSTATUSVALUE LIKE v_status
                               -- and (case when v_ODTIMESTAMP= 'ALL' THEN SYSTIMESTAMP ELSE C.ODTIMESTAMP END) > ODTIMESTAMP
                                AND ((C.TIMETYPEVALUE='T' /*AND C.ORSTATUSVALUE <> '10'*/) -- Lenh binh thuong, bao gom ca lenh goc va lenh sua
                                OR (C.TIMETYPEVALUE='G' AND C.ORSTATUSVALUE NOT IN ('5', 'P', '6', 'W', 'R')) --Het hieu luc, tu choi, R:lenh dieu kien chua active, bi huy
                                )
                                AND C.CUSTODYCD=CF.CUSTODYCD
                                AND CD1.cdtype ='OD' AND CD1.CDNAME='ORSTATUS' AND CD1.CDVAL= C.ORSTATUSVALUE
                                AND CD2.cdtype ='OD' AND CD2.CDNAME='TIMETYPE' AND CD2.CDVAL=C.TIMETYPEVALUE
                                AND CD3.CDTYPE='OD' AND CD3.CDNAME='VIA' AND C.VIA=CD3.CDCONTENT
                                AND CD4.CDTYPE='OD' AND CD4.CDNAME='EXECTYPE' AND C.EXECTYPE=CD4.cdval) OD
                    WHERE --(c.CUSTODYCD=v_custodycd )
                          (cf.CUSTID=v_custodycd or c.USERNAME=v_custodycd)
                          AND C.TXDATE=v_currdate
                          AND C.AFACCTNO LIKE v_afacctno
                          AND C.EXECTYPE LIKE v_exectype
                          AND C.SYMBOL LIKE v_symbol
                          AND C.ORSTATUSVALUE LIKE v_status
                          AND C.ODTIMESTAMP> v_ODTIMESTAMP
                          AND ((C.TIMETYPEVALUE='T'/* AND C.ORSTATUSVALUE <> '10'*/) -- Lenh binh thuong, bao gom ca lenh goc va lenh sua
                          OR (C.TIMETYPEVALUE='G' AND C.ORSTATUSVALUE NOT IN ('5', 'P', '6', 'W', 'R')) --Het hieu luc, tu choi, R:lenh dieu kien chua active, bi huy
                          )
                          AND C.CUSTODYCD=CF.CUSTODYCD
                          AND CD1.cdtype ='OD' AND CD1.CDNAME='ORSTATUS' AND CD1.CDVAL= C.ORSTATUSVALUE
                          AND CD2.cdtype ='OD' AND CD2.CDNAME='TIMETYPE' AND CD2.CDVAL=C.TIMETYPEVALUE
                          AND CD3.CDTYPE='OD' AND CD3.CDNAME='VIA' AND C.VIA=CD3.CDCONTENT
                          AND CD4.CDTYPE='OD' AND CD4.CDNAME='EXECTYPE' AND C.EXECTYPE=CD4.cdval
                   ORDER BY C.TXDATE DESC, C.TXTIME DESC, C.ORDERID desc, C.CUSTODYCD, C.AFACCTNO,C.SYMBOL
               ) a where rownum <= ROWS_RPP * PAGE_RPP
               )
                where  r > ROWS_RPP * (PAGE_RPP - 1);
    END IF;

EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'pr_get_normalorderlist');

END pr_get_normalorderlist;
--check ton tai lenh
PROCEDURE pr_get_check_orderlist
    (P_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD     IN VARCHAR2,
     AFACCTNO        IN VARCHAR2,
     ORDERID        IN VARCHAR2,
     EXECTYPE         IN VARCHAR2,
     SYMBOL             IN VARCHAR2,
     STATUS          IN VARCHAR2
     )

    IS

    v_custodycd varchar2(10);
    v_afacctno varchar2(10);
   -- v_placecustid  varchar2(20);
  --  p_txdate   date;
    v_exectype  varchar2(20);
    v_symbol  varchar2(20);
    v_status  varchar2(20);

    v_currdate date;
    v_orderid varchar2(100);
    v_count number;
BEGIN
    if CUSTODYCD is null or CUSTODYCD = '' or length(CUSTODYCD)=0 then
        v_custodycd:= '%';
    else v_custodycd:= CUSTODYCD;
    end if;

    if AFACCTNO is null or AFACCTNO = '' or length(AFACCTNO)=0 or AFACCTNO='ALL' then
        v_afacctno:= '%';
    else v_afacctno:= AFACCTNO;
    end if;

  if ORDERID is null or ORDERID = '' or length(ORDERID)=0 then
        v_orderid:= '%';
    else v_orderid:= ORDERID;
    end if;

  if EXECTYPE is null or EXECTYPE = '' or length(EXECTYPE)=0 or EXECTYPE='ALL' then
        v_exectype:= '%';
    else v_exectype:= EXECTYPE;
    end if;

    if SYMBOL is null or SYMBOL = '' or length(SYMBOL)=0 then
        v_symbol:= '%';
    else v_symbol:= '%'||SYMBOL||'%';
    end if;

    if STATUS is null or STATUS = '' or length(STATUS)=0 or STATUS='ALL' then
        v_status:= '%';
    else v_status:= STATUS;
    end if;


    select to_date(VARVALUE,'DD/MM/rrrr') into v_currdate from sysvar where grname='SYSTEM' and varname='CURRDATE';

    select count(*) into v_count from (
            SELECT  C.CUSTODYCD, C.AFACCTNO, C.EXECTYPE EXECTYPECD, cd4.CDCONTENT EXECTYPE,cd4.EN_CDCONTENT EN_EXECTYPE,
                  C.SYMBOL, C.ORDERQTTY, C.QUOTEPRICE * 1000 QUOTEPRICE,
                  C.EXECQTTY, DECODE(C.EXECQTTY,0, 0, ROUND(C.EXECAMT/C.EXECQTTY,4)) EXECPRICE,
                  C.REMAINQTTY,C.CANCELQTTY,C.ORSTATUSVALUE ORSTATUSCD, C.ORSTATUS, CD1.EN_CDCONTENT EN_ORSTATUS,
                  C.PRICETYPE,  C.VIA, CD3.EN_CDCONTENT EN_VIA,
                  C.TXTIME, CASE WHEN C.USERNAME=CF.CUSTID THEN 'Y' ELSE 'N' END ISCUSTODYCD,
                  C.TIMETYPE,CD2.EN_CDCONTENT EN_TIMETYPE, C.ORDERID,C.FEEDBACKMSG,
                  DECODE(C.ISDISPOSAL,'Y','N', C.ISCANCEL) ISCANCEL,
                  DECODE(C.ISDISPOSAL,'Y','N', C.ISADMEND) ISADMEND,
                  C.ISDISPOSAL

            FROM BUF_OD_ACCOUNT C, CFMAST CF, ALLCODE CD1, ALLCODE CD2, ALLCODE CD3, allcode cd4
            WHERE /*(c.CUSTODYCD=v_custodycd )--khong check theo so luu ky, theo TH sua lenh uy quyen
                  AND */C.TXDATE=v_currdate
                  AND C.AFACCTNO LIKE v_afacctno
                  AND C.EXECTYPE LIKE v_exectype
                  AND C.SYMBOL LIKE v_symbol
                  AND C.ORSTATUSVALUE LIKE v_status
                  AND ((C.TIMETYPEVALUE='T' AND C.ORSTATUSVALUE <> '10') -- Lenh binh thuong, bao gom ca lenh goc va lenh sua
                  OR (C.TIMETYPEVALUE='G' AND C.ORSTATUSVALUE NOT IN ('5', 'P', '6', 'W', 'R')) --Het hieu luc, tu choi, R:lenh dieu kien chua active, bi huy
                  )
                  AND C.CUSTODYCD=CF.CUSTODYCD
                  and (c.ORDERID = v_orderid or c.forefid = v_orderid)
                  AND CD1.cdtype ='OD' AND CD1.CDNAME='ORSTATUS' AND CD1.CDVAL= C.ORSTATUSVALUE
                  AND CD2.cdtype ='OD' AND CD2.CDNAME='TIMETYPE' AND CD2.CDVAL=C.TIMETYPEVALUE
                  AND CD3.CDTYPE='OD' AND CD3.CDNAME='VIA' AND C.VIA=CD3.CDCONTENT
                  AND CD4.CDTYPE='OD' AND CD4.CDNAME='EXECTYPE' AND C.EXECTYPE=CD4.cdval
            ORDER BY C.CUSTODYCD, C.AFACCTNO,C.SYMBOL,C.TXTIME
       );

   OPEN p_REFCURSOR FOR

        select case when v_count<=0 then 'N' else 'Y' end IS_CHECK
        from dual;


EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'pr_get_check_orderlist');

END pr_get_check_orderlist;


PROCEDURE pr_get_infomation_order
    (P_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD     IN VARCHAR2,
     ROOTORDERID        IN VARCHAR2
     )
    IS

    v_custodycd varchar2(10);
    v_ROOTORDERID  varchar2(100);

BEGIN
    if CUSTODYCD is null or CUSTODYCD = '' or length(CUSTODYCD)=0 then
        v_custodycd:= '%';
    else v_custodycd:= CUSTODYCD;
    end if;
    v_ROOTORDERID:=nvl(ROOTORDERID,'');


   OPEN p_REFCURSOR FOR

       /*  SELECT  OD.ROOTORDERID, OD.ORDERID,od.SYMBOL,\* 'N' ISDETAIL,*\ OD.TXDATE, OD.TXTIME,\* OD.ORSTATUS,*\
                       \* OD.QUOTEPRICE * 1000 QUOTEPRICE, OD.ORDERQTTY, OD.REMAINQTTY,*\ OD.EXECQTTY MATCHQTTY, 0 MATCHPRICE\*, OD.CANCELQTTY, OD.ADJUSTQTTY*\
              FROM BUF_OD_ACCOUNT OD
          WHERE OD.CUSTODYCD= v_custodycd
              --AND OD.TIMETYPEVALUE='T'  -- gop ca lenh dieu kien
                  AND OD.ROOTORDERID = v_ROOTORDERID
          UNION ALL*/
          --exec detail
              SELECT OD.ROOTORDERID, OD.ORDERID || A.TXNUM ORDERID,od.SYMBOL, /*'Y' ISDETAIL, */A.TXDATE, A.TXTIME, /*'' ORSTATUS, */
                   /* 0 QUOTEPRICE, 0 ORDERQTTY, 0 REMAINQTTY,*/ MATCHQTTY, MATCHPRICE/*, 0 CANCELQTTY, 0 ADJUSTQTTY*/
              FROM IOD A, BUF_OD_ACCOUNT OD
              WHERE OD.CUSTODYCD=v_custodycd
            --AND OD.TIMETYPEVALUE = 'T'  -- gop ca lenh dieu kien
                AND A.ORGORDERID = OD.ORDERID
                --AND OD.ROOTORDERID = v_ROOTORDERID
                AND OD.ORDERID = v_ROOTORDERID
           ORDER BY TXTIME;



EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'pr_get_infomation_order');

END pr_get_infomation_order;


--check tk master gan vs user careby khach hang
PROCEDURE pr_check_master
    (P_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     M_CUSTODYCD     IN VARCHAR2,
     CUSTODYCD       IN VARCHAR2
     )

    IS
    v_custodycd varchar2(20);
    v_m_afacctno varchar2(20);

    v_ismaster varchar2(10);

    v_count number;
    v_check number;
BEGIN
    v_count:=0;
    v_check:=0;

    if CUSTODYCD is null or CUSTODYCD = '' or length(CUSTODYCD)=0 then
        v_custodycd:= '%';
    else v_custodycd:= UPPER(CUSTODYCD);
    end if;

    if M_CUSTODYCD is null or M_CUSTODYCD = '' or length(M_CUSTODYCD)=0 then
        v_m_afacctno:= '%';
    else v_m_afacctno:= UPPER(M_CUSTODYCD);
    end if;

    begin
            SELECT USL.ISMASTER INTO   v_ismaster
            FROM CFMAST CF, USERLOGIN USL
            WHERE CF.USERNAME=USL.USERNAME
                  AND CF.USERNAME IS NOT NULL
                  AND CF.CUSTODYCD like v_m_afacctno;
    EXCEPTION WHEN OTHERS THEN
           v_ismaster:='N';
    End;

    IF v_ismaster='Y' THEN

          select COUNT(1) into v_count from usermaster where CUSTODYCD like v_m_afacctno;

          select count(1) into v_check from afmast af, cfmast cf
          where af.custid=cf.custid and cf.custodycd like v_custodycd
          and exists (select gu.grpid from tlgrpusers gu where af.careby=gu.grpid
                      and gu.grpid in (select tl.grpid from tlgrpusers tl, usermaster u
                                       where tl.TLID=u.TLIDUSER and u.CUSTODYCD like v_m_afacctno
                                       )
                      );

    END IF;

   OPEN p_REFCURSOR FOR

        select case when  v_m_afacctno = v_custodycd THEN 'Y'
                    when v_ismaster = 'N' and v_m_afacctno<>v_custodycd THEN 'N'
                    when v_ismaster = 'N' and v_m_afacctno=v_custodycd THEN 'Y'
                    when v_ismaster = 'Y' and v_count <=0  THEN 'Y'
                    when v_ismaster = 'Y' and v_count >0 AND v_check <=0 and v_m_afacctno<>v_custodycd  THEN 'N'
                    when v_ismaster = 'Y' and v_count >0 AND v_check > 0  THEN 'Y'
                    ELSE 'N' END IS_CHECK
        from dual;


EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'pr_check_master');

END pr_check_master;

PROCEDURE pr_get_seinfolist_PB
    (P_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD     IN VARCHAR2,
     AFACCTNO        IN VARCHAR2,
     PAGE_RPP          IN NUMBER,
     ROWS_RPP         IN NUMBER
     )
    IS

    v_custodycd varchar2(10);
    v_afacctno varchar2(10);

    v_balance varchar2(100);
    v_securebal varchar2(100);
    v_debt varchar2 (100);

    v_balance_en varchar2(100);
    v_securebal_en varchar2(100);
    v_debt_en varchar2 (100);



    v_currdate date;
    v_fomode varchar2(100);
    v_Secure_Amt number(20);
    v_NAV        number(20);
    v_Secure_Amt_Match number(20);

BEGIN


    v_afacctno:= AFACCTNO;

    select to_date(VARVALUE,'DD/MM/rrrr') into v_currdate from sysvar where grname='SYSTEM' and varname='CURRDATE';

/*INSERT INTO log_err
                        (id,date_log, POSITION, text
                        )
                 VALUES ( seq_log_err.NEXTVAL,SYSDATE, 'pr_get_seinfolist_PB','AFACCTNO:' || AFACCTNO ||' PAGE_RPP:'||PAGE_RPP
                        );
                        COMMIT;*/

   Begin
        Select cdcontent, en_cdcontent into v_balance,v_balance_en
        From allcode
        where cdtype='AF' AND CDNAME='ASSETDETAIL' and cdval='001';
        Select cdcontent, en_cdcontent into v_securebal,v_securebal_en
        From allcode
        where cdtype='AF' AND CDNAME='ASSETDETAIL' and cdval='002';
        Select cdcontent, en_cdcontent into v_debt,v_debt_en
        From allcode
        where cdtype='AF' AND CDNAME='ASSETDETAIL' and cdval='003';

     EXCEPTION
      WHEN OTHERS THEN
        v_balance:='Tien';
        v_securebal:='Tien ky quy';
        v_debt:='No';
        v_balance_en:='Cash';
        v_securebal_en:='Secure Money';
        v_debt_en:='Debt';
   End;

SELECT varvalue INTO v_fomode FROM sysvar WHERE varname ='FOMODE' AND grname ='SYSTEM';

 IF v_fomode = 'ON' THEN
    v_Secure_Amt:=  CSPKS_FO_COMMON.fn_get_buy_amt@DBL_FO(V_AFACCTNO);
    v_Secure_Amt_Match:=  cspks_fo_account.fn_get_buy_amt_match@DBL_FO(V_AFACCTNO);
    --v_NAV       :=  fnc_get_NAV(V_AFACCTNO);
    IF  PAGE_RPP = 1 THEN

       OPEN p_REFCURSOR FOR

      SELECT * FROM (
         --Bat dau tu dong thu 2: Lay thong tin chi tiet
         SELECT  * FROM (
             SELECT a.*, rownum r FROM(
               SELECT IS_TRADE,
                      EN_ITEM,
                      ITEM,
                      ITEM SYMBOL,
                      MST.ACCTNO AFACCTNO,
                      CUSTODYCD,
                      TRUNC(TRADE) TRADE,
                      TRUNC(TOTAL) TOTAL,
                      TRUNC(WFT_QTTY) WFT_QTTY,
                      TRUNC(RECEIVING) RECEIVING ,
                      TRUNC(SECURED) SECURED,
                      TRUNC(BASICPRICE) BASICPRICE,
                      TRUNC(COSTPRICE) COSTPRICE,
                      TRUNC(RETAIL) RETAIL,
                      TRUNC(PROFITANDLOSS) PL,
                      PCPL,
                      TRUNC(COSTPRICEAMT) COSTPRICEAMT,
                      TRUNC(MARKETAMT) MARKETAMT,
                      TRUNC(RECEIVING_RIGHT) RECEIVING_RIGHT,
                      TRUNC(RECEIVING_T0) RECEIVING_T0,
                      TRUNC(RECEIVING_T1) RECEIVING_T1,
                      TRUNC(RECEIVING_T2) RECEIVING_T2,
                      TRUNC(RECEIVING_T3) RECEIVING_T3,
                      TRUNC(TRADE) +  TRUNC(S_REMAINQTTY) + TRUNC(RECEIVING_RIGHT) + TRUNC(RECEIVING_T0) +
                      TRUNC(RECEIVING_T1) + TRUNC(RECEIVING_T2) + TRUNC(RECEIVING_T3) SUM_QTTY,
                      STT,
                      CASE WHEN STT = 3 THEN 'Y' ELSE 'N' END ISBUY,
                      CASE WHEN STT = 3 THEN 'Y' ELSE 'N' END ISSELL
                      FROM (
                          SELECT IS_TRADE,EN_ITEM,ITEM,ACCTNO,CUSTODYCD, TRADE,RECEIVING, SECURED,BASICPRICE, COSTPRICE,
                                 RETAIL, S_REMAINQTTY,PROFITANDLOSS,PCPL,COSTPRICEAMT,TOTAL,WFT_QTTY,MARKETAMT, RECEIVING_RIGHT,
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
                                                        AND BUF.AFACCTNO = V_AFACCTNO
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
                                    AND SDTL.CODEID = SEC.CODEID AND SDTL.AFACCTNO = V_AFACCTNO
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
                                AND a.acctno = V_AFACCTNO
                                GROUP BY a.ACCTNO, a.CUSTODYCD, P_FO.SYMBOL,P_FO.TRADE

                            )
                             ORDER BY CUSTODYCD,ACCTNO,ITEM
                             ))
                          WHERE ACCTNO = V_AFACCTNO

                  ) MST WHERE trunc(trade) +  trunc(S_REMAINQTTY) + trunc(receiving_right) + trunc(receiving_t0) + trunc(receiving_t1) + trunc(receiving_t2) + trunc(receiving_t3) > 0
                  ORDER BY STT,CUSTODYCD,ACCTNO,ITEM
          ) A WHERE ROWNUM <= ROWS_RPP * PAGE_RPP
          ) WHERE  R > ROWS_RPP * (PAGE_RPP - 1));

      ELSE  --PageNo =1

       OPEN p_REFCURSOR FOR

       SELECT * FROM (
       SELECT A.*, ROWNUM R FROM (

       SELECT IS_TRADE,
                      EN_ITEM,
                      ITEM,
                      ITEM SYMBOL,
                      MST.ACCTNO AFACCTNO,
                      CUSTODYCD,
                      TRUNC(TRADE) TRADE,
                      TRUNC(TOTAL) TOTAL,
                      TRUNC(WFT_QTTY) WFT_QTTY,
                      TRUNC(RECEIVING) RECEIVING ,
                      TRUNC(SECURED) SECURED,
                      TRUNC(BASICPRICE) BASICPRICE,
                      TRUNC(COSTPRICE) COSTPRICE,
                      TRUNC(RETAIL) RETAIL,
                      TRUNC(PROFITANDLOSS) PL,
                      PCPL,
                      TRUNC(COSTPRICEAMT) COSTPRICEAMT,
                      TRUNC(MARKETAMT) MARKETAMT,
                      TRUNC(RECEIVING_RIGHT) RECEIVING_RIGHT,
                      TRUNC(RECEIVING_T0) RECEIVING_T0,
                      TRUNC(RECEIVING_T1) RECEIVING_T1,
                      TRUNC(RECEIVING_T2) RECEIVING_T2,
                      TRUNC(RECEIVING_T3) RECEIVING_T3,
                      TRUNC(TRADE) +  TRUNC(S_REMAINQTTY) + TRUNC(RECEIVING_RIGHT) + TRUNC(RECEIVING_T0) +
                      TRUNC(RECEIVING_T1) + TRUNC(RECEIVING_T2) + TRUNC(RECEIVING_T3) SUM_QTTY,
                      STT,
                      CASE WHEN STT = 3 THEN 'Y' ELSE 'N' END ISBUY,
                      CASE WHEN STT = 3 THEN 'Y' ELSE 'N' END ISSELL
                      FROM (
                          SELECT IS_TRADE,EN_ITEM,ITEM,ACCTNO,CUSTODYCD, TRADE,RECEIVING, SECURED,BASICPRICE, COSTPRICE,
                                 RETAIL, S_REMAINQTTY,PROFITANDLOSS,PCPL,COSTPRICEAMT,TOTAL,WFT_QTTY,MARKETAMT, RECEIVING_RIGHT,
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
                                                        AND BUF.AFACCTNO = V_AFACCTNO
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
                                    AND SDTL.CODEID = SEC.CODEID AND SDTL.AFACCTNO = V_AFACCTNO
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
                                AND a.acctno = V_AFACCTNO
                                GROUP BY a.ACCTNO, a.CUSTODYCD, P_FO.SYMBOL,P_FO.TRADE

                            )
                             ORDER BY CUSTODYCD,ACCTNO,ITEM
                             ))

                          WHERE ACCTNO = V_AFACCTNO

                  ) MST WHERE trunc(trade) +  trunc(S_REMAINQTTY) + trunc(receiving_right) + trunc(receiving_t0) + trunc(receiving_t1) + trunc(receiving_t2) + trunc(receiving_t3) > 0
                  ORDER BY STT,CUSTODYCD,ACCTNO,ITEM
          ) A WHERE ROWNUM <= ROWS_RPP * PAGE_RPP
          ) WHERE  R > ROWS_RPP * (PAGE_RPP - 1);
       END IF;


 ELSE  --FOMODE OFF


     if  PAGE_RPP = 1 then

       OPEN p_REFCURSOR FOR

       select * from ( select a.*, 0 r from (

       SELECT '' IS_TRADE, '' EN_ITEM, '' ITEM,'' SYMBOL, '' AFACCTNO,'' CUSTODYCD,0 trade, 0 total, 0 wft_qtty, 0 receiving ,
           0 secured, 0 basicprice,0 costprice,0  retail,
            ROUND(sum(PROFITANDLOSS)) PL,0 PCPL, ROUND(sum(COSTPRICEAMT)) COSTPRICEAMT,
          ROUND(sum(MARKETAMT)) marketamt,
            0 receiving_right,0 receiving_t0, 0 receiving_t1,0 receiving_t2,0 receiving_t3,
           0 SUM_QTTY,
           0 stt,
            '' ISBUY,
            ''  ISSELL
              FROM (        Select 'display_none' IS_TRADE, v_balance_en en_item, v_balance Item,buf.afacctno acctno, CUSTODYCD,
                         round( buf.balance + buf.bamt) trade,
                        round( (nvl(buf.RECEIVING,0) - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 -
                            buf.CASH_RECEIVING_T2) + nvl(buf.avladv_t1,0) +nvl(buf.avladv_t2,0)+nvl(buf.avladv_t3,0)) RECEIVING,
                         0 secured,
                         0 basicprice,
                         0 costprice,
                        round( nvl(r.retail,0)) retail, 0 S_REMAINQTTY,
                         0 PROFITANDLOSS,
                         0 PCPL,
                         0 COSTPRICEAMT,
                         round(buf.balance +  buf.bamt + nvl(careceiving,0)--(nvl(buf.RECEIVING,0)  - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 - buf.CASH_RECEIVING_T2 )         --T2_HoangND
                         + nvl(buf.avladv_t1,0) +nvl(buf.avladv_t2,0)+nvl(buf.avladv_t3,0)) total,
                         0 wft_qtty, round(buf.balance +  buf.bamt + nvl(careceiving,0)--(nvl(buf.RECEIVING,0)  - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 - buf.CASH_RECEIVING_T2 )         --T2_HoangND
                         + nvl(buf.avladv_t1,0) +nvl(buf.avladv_t2,0)+nvl(buf.avladv_t3,0)) MARKETAMT,
                         --nvl(buf.RECEIVING,0) - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 -  buf.CASH_RECEIVING_T2 - nvl(r.retail,0)   receiving_right,
                         round(nvl(buf.careceiving,0)) receiving_right,       --T2_HoangND edit
                         0 receiving_t0,
                         nvl(buf.avladv_t1,0) receiving_t1,
                         nvl(buf.avladv_t2,0) receiving_t2,
                         nvl(buf.avladv_t3,0) receiving_t3,
                         0 stt
                  From buf_ci_account buf,
                  (select sum(price*qtty) retail, substr(acctno,1,10) seacctno from seretail where status not in ('C','R') group by substr(acctno,1,10)) r--,
                  --(SELECT SUM(amt) careceiving, afacctno  FROM caschd WHERE  status IN ('I','S','H') AND ISEXEC ='Y' AND deltd <> 'Y'   --T2_HoangND
                    --GROUP BY afacctno) ca
                  where  buf.AFACCTNO like v_afacctno
                  --AND BUF.CUSTODYCD like v_custodycd
                  AND BUF.AFACCTNO = r.seacctno(+)
                  --AND BUF.AFACCTNO = ca.afacctno(+)
                  union all
                   Select 'display_none' IS_TRADE, v_securebal_en en_item, v_securebal Item,buf.afacctno acctno, CUSTODYCD,
                         round(buf.bamt) trade,
                         0 RECEIVING,
                         0 secured,
                         0 basicprice,
                         0 costprice,
                         0 retail, 0 S_REMAINQTTY,
                         0 PROFITANDLOSS,
                         0 PCPL,
                         0 COSTPRICEAMT,
                         round(buf.bamt) total, 0 wft_qtty, -round(buf.bamt)  MARKETAMT,
                         0 receiving_right,
                         0 receiving_t0,
                         0 receiving_t1,
                         0 receiving_t2,
                         0 receiving_t3,
                         1 stt
                  From buf_ci_account buf
                  where   buf.AFACCTNO like v_afacctno
                  -- AND BUF.CUSTODYCD like v_custodycd
                  union all
                   SELECT 'display_none' IS_TRADE, v_debt_en en_item ,v_debt Item, AF.ACCTNO, buf.CUSTODYCD,
                         round(nvl(LS.DEBT,0)  + buf.OVDCIDEPOFEE) trade,
                         0 receiving,
                         0 secured,
                         0 basicprice,
                         0 costprice,
                         0 retail,0 S_REMAINQTTY,
                         0 PROFITANDLOSS,
                         0 PCPL,
                         0 COSTPRICEAMT,
                         round(nvl(LS.DEBT,0)  + buf.OVDCIDEPOFEE) total,0 wft_qtty,
                         -round(nvl(LS.DEBT,0)  + buf.OVDCIDEPOFEE) MARKETAMT,
                         0 receiving_right,
                         0 receiving_t0,
                         0 receiving_t1,
                         0 receiving_t2,
                         0 receiving_t3,
                         2 stt
                    FROM  AFMAST AF, (SELECT LN.TRFACCTNO,SUM(prinnml + prinovd + intnmlacr+intovdacr+intnmlovd+intdue +
                            oprinnml + oprinovd + ointnmlacr + ointnmlovd + ointovdacr+INTNMLPBL + -- them lai du tinh bao lanh MSBS-1264
                            ointdue+fee+feedue+feeovd+feeintnmlacr+feeintovdacr+feeintnmlovd+feeintdue) DEBT
                            FROM  LNMAST LN
                            GROUP BY LN.TRFACCTNO) LS,
                            buf_ci_account buf
                  WHERE  AF.ACCTNO = ls.TRFACCTNO(+)
                --  AND BUF.CUSTODYCD like v_custodycd
                  and af.acctno=buf.afacctno
                  AND AF.ACCTNO like v_afacctno

                  union

                  select IS_TRADE,en_item,Item,ACCTNO,CUSTODYCD, trade,receiving, secured,basicprice, costprice,
                         retail, S_REMAINQTTY,PROFITANDLOSS,PCPL,COSTPRICEAMT,total,wft_qtty,MARKETAMT, receiving_right,
                         receiving_t0,receiving_t1, receiving_t2, receiving_t3, stt
                  from VW_PORTFOLIO_RPP
                  where acctno like v_afacctno

                  ) MST order by stt,custodycd,acctno,item
          ) a
          )


       UNION ALL

       select * from (
       select a.*, rownum r from (

       SELECT IS_TRADE, EN_ITEM, ITEM, ITEM SYMBOL, MST.ACCTNO AFACCTNO, CUSTODYCD, trunc(trade) trade,  trunc(total) total,  trunc(wft_qtty) wft_qtty, trunc(receiving) receiving ,
            trunc(secured) secured, trunc(basicprice) basicprice,trunc(COSTPRICE) costprice,  trunc(retail) retail,
            trunc (PROFITANDLOSS) PL,  PCPL, trunc(COSTPRICEAMT) COSTPRICEAMT,
            trunc(MARKETAMT) marketamt,
            trunc(receiving_right) receiving_right,trunc(receiving_t0) receiving_t0, trunc(receiving_t1) receiving_t1, trunc(receiving_t2) receiving_t2, trunc(receiving_t3) receiving_t3,
            trunc(trade) +  trunc(S_REMAINQTTY) + trunc(receiving_right) + trunc(receiving_t0) + trunc(receiving_t1) + trunc(receiving_t2) + trunc(receiving_t3) SUM_QTTY,
            stt,
            case when stt = 3 then 'Y' else 'N' end ISBUY,
            case when stt = 3 then 'Y' else 'N' end ISSELL
              FROM (
                  Select 'display_none' IS_TRADE, v_balance_en en_item, v_balance Item,buf.afacctno acctno, CUSTODYCD,
                         round( buf.balance + buf.bamt) trade,
                        round( (nvl(buf.RECEIVING,0) - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 -
                            buf.CASH_RECEIVING_T2) + nvl(buf.avladv_t1,0) +nvl(buf.avladv_t2,0)+nvl(buf.avladv_t3,0)) RECEIVING,
                         0 secured,
                         0 basicprice,
                         0 costprice,
                        round( nvl(r.retail,0)) retail, 0 S_REMAINQTTY,
                         0 PROFITANDLOSS,
                         0 PCPL,
                         0 COSTPRICEAMT,
                         round(buf.balance +  buf.bamt + nvl(careceiving,0)--(nvl(buf.RECEIVING,0)  - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 - buf.CASH_RECEIVING_T2 )         --T2_HoangND
                         + nvl(buf.avladv_t1,0) +nvl(buf.avladv_t2,0)+nvl(buf.avladv_t3,0)) total,
                         0 wft_qtty, round(buf.balance +  buf.bamt + nvl(careceiving,0)--(nvl(buf.RECEIVING,0)  - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 - buf.CASH_RECEIVING_T2 )         --T2_HoangND
                         + nvl(buf.avladv_t1,0) +nvl(buf.avladv_t2,0)+nvl(buf.avladv_t3,0)) MARKETAMT,
                         --nvl(buf.RECEIVING,0) - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 -  buf.CASH_RECEIVING_T2 - nvl(r.retail,0)   receiving_right,
                         round(nvl(buf.careceiving,0)) receiving_right,       --T2_HoangND edit
                         0 receiving_t0,
                         nvl(buf.avladv_t1,0) receiving_t1,
                         nvl(buf.avladv_t2,0) receiving_t2,
                         nvl(buf.avladv_t3,0) receiving_t3,
                         0 stt
                  From buf_ci_account buf,
                  (select sum(price*qtty) retail, substr(acctno,1,10) seacctno from seretail where status not in ('C','R') group by substr(acctno,1,10)) r--,
                  --(SELECT SUM(amt) careceiving, afacctno  FROM caschd WHERE  status IN ('I','S','H') AND ISEXEC ='Y' AND deltd <> 'Y'   --T2_HoangND
                    --GROUP BY afacctno) ca
                  where  buf.AFACCTNO like v_afacctno
                 -- AND BUF.CUSTODYCD like v_custodycd
                  AND BUF.AFACCTNO = r.seacctno(+)
                  --AND BUF.AFACCTNO = ca.afacctno(+)
                  union all
                   Select 'display_none' IS_TRADE, v_securebal_en en_item, v_securebal Item,buf.afacctno acctno, CUSTODYCD,
                         round(buf.bamt) trade,
                         0 RECEIVING,
                         0 secured,
                         0 basicprice,
                         0 costprice,
                         0 retail, 0 S_REMAINQTTY,
                         0 PROFITANDLOSS,
                         0 PCPL,
                         0 COSTPRICEAMT,
                         round(buf.bamt) total, 0 wft_qtty, -round(buf.bamt)  MARKETAMT,
                         0 receiving_right,
                         0 receiving_t0,
                         0 receiving_t1,
                         0 receiving_t2,
                         0 receiving_t3,
                         1 stt
                  From buf_ci_account buf
                  where   buf.AFACCTNO like v_afacctno
                  -- AND BUF.CUSTODYCD like v_custodycd
                  union all
                   SELECT 'display_none' IS_TRADE, v_debt_en en_item ,v_debt Item, AF.ACCTNO, buf.CUSTODYCD,
                         round(nvl(LS.DEBT,0)  + buf.OVDCIDEPOFEE) trade,
                         0 receiving,
                         0 secured,
                         0 basicprice,
                         0 costprice,
                         0 retail,0 S_REMAINQTTY,
                         0 PROFITANDLOSS,
                         0 PCPL,
                         0 COSTPRICEAMT,
                         round(nvl(LS.DEBT,0)  + buf.OVDCIDEPOFEE) total,0 wft_qtty,
                         -round(nvl(LS.DEBT,0)  + buf.OVDCIDEPOFEE) MARKETAMT,
                         0 receiving_right,
                         0 receiving_t0,
                         0 receiving_t1,
                         0 receiving_t2,
                         0 receiving_t3,
                         2 stt
                    FROM  AFMAST AF, (SELECT LN.TRFACCTNO,SUM(prinnml + prinovd + intnmlacr+intovdacr+intnmlovd+intdue +
                            oprinnml + oprinovd + ointnmlacr + ointnmlovd + ointovdacr+INTNMLPBL + -- them lai du tinh bao lanh MSBS-1264
                            ointdue+fee+feedue+feeovd+feeintnmlacr+feeintovdacr+feeintnmlovd+feeintdue) DEBT
                            FROM  LNMAST LN
                            GROUP BY LN.TRFACCTNO) LS,
                            buf_ci_account buf
                  WHERE  AF.ACCTNO = ls.TRFACCTNO(+)
                 -- AND BUF.CUSTODYCD like v_custodycd
                  and af.acctno=buf.afacctno
                  AND AF.ACCTNO like v_afacctno

                  union

                  select IS_TRADE,en_item,Item,ACCTNO,CUSTODYCD, trade,receiving, secured,basicprice, costprice,
                         retail, S_REMAINQTTY,PROFITANDLOSS,PCPL,COSTPRICEAMT,total,wft_qtty,MARKETAMT, receiving_right,
                         receiving_t0,receiving_t1, receiving_t2, receiving_t3, stt
                  from VW_PORTFOLIO_RPP
                  where acctno like v_afacctno

                  ) MST WHERE trunc(trade) +  trunc(S_REMAINQTTY) + trunc(receiving_right) + trunc(receiving_t0) + trunc(receiving_t1) + trunc(receiving_t2) + trunc(receiving_t3) > 0
                  order by stt,custodycd,acctno,item
          ) a where rownum <= ROWS_RPP * PAGE_RPP
          ) where  r > ROWS_RPP * (PAGE_RPP - 1);
      else

       OPEN p_REFCURSOR FOR

       select * from (
       select a.*, rownum r from (

       SELECT IS_TRADE, en_item, ITEM, ITEM SYMBOL, MST.ACCTNO AFACCTNO, CUSTODYCD, trunc(trade) trade,  trunc(total) total,  trunc(wft_qtty) wft_qtty, trunc(receiving) receiving ,
            trunc(secured) secured, trunc(basicprice) basicprice,trunc(COSTPRICE) costprice,  trunc(retail) retail,
            trunc (PROFITANDLOSS) PL,  PCPL, trunc(COSTPRICEAMT) COSTPRICEAMT,
            trunc(MARKETAMT) marketamt,
            trunc(receiving_right) receiving_right,trunc(receiving_t0) receiving_t0,trunc(receiving_t1) receiving_t1,
            trunc(receiving_t2) receiving_t2,trunc(receiving_t3) receiving_t3,
            trunc(trade) +  trunc(S_REMAINQTTY) + trunc(receiving_right) + trunc(receiving_t0) + trunc(receiving_t1) + trunc(receiving_t2) + trunc(receiving_t3) SUM_QTTY,
            stt,
            case when stt = 3 then 'Y' else 'N' end ISBUY,
            case when stt = 3 then 'Y' else 'N' end ISSELL
              FROM (
                  Select 'display_none' IS_TRADE, v_balance_en en_item, v_balance Item,buf.afacctno acctno, CUSTODYCD,
                         round( buf.balance + buf.bamt) trade,
                        round( (nvl(buf.RECEIVING,0) - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 -
                            buf.CASH_RECEIVING_T2) + nvl(buf.avladv_t1,0) +nvl(buf.avladv_t2,0)+nvl(buf.avladv_t3,0)) RECEIVING,
                         0 secured,
                         0 basicprice,
                         0 costprice,
                        round( nvl(r.retail,0)) retail, 0 S_REMAINQTTY,
                         0 PROFITANDLOSS,
                         0 PCPL,
                         0 COSTPRICEAMT,
                         round(buf.balance +  buf.bamt + nvl(careceiving,0)--(nvl(buf.RECEIVING,0)  - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 - buf.CASH_RECEIVING_T2 )         --T2_HoangND
                         + nvl(buf.avladv_t1,0) +nvl(buf.avladv_t2,0)+nvl(buf.avladv_t3,0)) total
                         , 0 wft_qtty,  round(buf.balance +  buf.bamt + nvl(careceiving,0)--(nvl(buf.RECEIVING,0)  - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 - buf.CASH_RECEIVING_T2 )         --T2_HoangND
                         + nvl(buf.avladv_t1,0) +nvl(buf.avladv_t2,0)+nvl(buf.avladv_t3,0)) MARKETAMT,
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
                  where  buf.AFACCTNO like v_afacctno
                 -- AND BUF.CUSTODYCD like v_custodycd
                  AND BUF.AFACCTNO = r.seacctno(+)
                  --AND BUF.AFACCTNO = ca.afacctno(+)
                  union all
                   Select 'display_none' IS_TRADE, v_securebal_en en_item, v_securebal Item,buf.afacctno acctno, CUSTODYCD,
                        round(buf.bamt) trade,
                         0 RECEIVING,
                         0 secured,
                         0 basicprice,
                         0 costprice,
                         0 retail, 0 S_REMAINQTTY,
                         0 PROFITANDLOSS,
                         0 PCPL,
                         0 COSTPRICEAMT,
                         round(buf.bamt) total, 0 wft_qtty, -round(buf.bamt)  MARKETAMT,
                         0 receiving_right,
                         0 receiving_t0,
                         0 receiving_t1,
                         0 receiving_t2,
                         0 receiving_t3,
                         1 stt
                  From buf_ci_account buf
                  where   buf.AFACCTNO like v_afacctno
                 --  AND BUF.CUSTODYCD like v_custodycd
                  union all
                   SELECT 'display_none' IS_TRADE, v_debt_en en_item, v_debt Item, AF.ACCTNO, buf.CUSTODYCD,
                         round(nvl(LS.DEBT,0)  + buf.OVDCIDEPOFEE) trade,
                         0 receiving,
                         0 secured,
                         0 basicprice,
                         0 costprice,
                         0 retail, 0S_REMAINQTTY,
                         0 PROFITANDLOSS,
                         0 PCPL,
                         0 COSTPRICEAMT,
                         round(nvl(LS.DEBT,0)  + buf.OVDCIDEPOFEE) total,0 wft_qtty,-round(nvl(LS.DEBT,0)  + buf.OVDCIDEPOFEE) MARKETAMT,
                         0 receiving_right,
                         0 receiving_t0,
                         0 receiving_t1,
                         0 receiving_t2,
                         0 receiving_t3,
                         2 stt
                    FROM  AFMAST AF, (SELECT LN.TRFACCTNO,SUM(prinnml + prinovd + intnmlacr+intovdacr+intnmlovd+intdue +
                            oprinnml + oprinovd + ointnmlacr + ointnmlovd + ointovdacr+INTNMLPBL + -- them lai du tinh bao lanh MSBS-1264
                            ointdue+fee+feedue+feeovd+feeintnmlacr+feeintovdacr+feeintnmlovd+feeintdue) DEBT
                            FROM  LNMAST LN
                            GROUP BY LN.TRFACCTNO) LS,
                            buf_ci_account buf
                  WHERE  AF.ACCTNO = ls.TRFACCTNO(+)
                --  AND BUF.CUSTODYCD like v_custodycd
                  and af.acctno=buf.afacctno
                  AND AF.ACCTNO like v_afacctno

                  union

                  select IS_TRADE,en_item,Item,ACCTNO,CUSTODYCD, trade,receiving, secured,basicprice, costprice,
                         retail, S_REMAINQTTY,PROFITANDLOSS,PCPL,COSTPRICEAMT,total,wft_qtty,MARKETAMT, receiving_right,
                         receiving_t0,receiving_t1, receiving_t2, receiving_t3, stt
                  from VW_PORTFOLIO_RPP
                  where acctno like v_afacctno

                  ) MST order by stt,custodycd,acctno,item
          ) a where rownum <= ROWS_RPP * PAGE_RPP
          ) where  r > ROWS_RPP * (PAGE_RPP - 1);
       end if;
 END IF; --End FOMODE


EXCEPTION
  WHEN OTHERS THEN
     plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'pr_get_seinfolist_PB');

END pr_get_seinfolist_PB;

--danh muc dau tu
PROCEDURE pr_get_seinfolist
    (P_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
     CUSTODYCD     IN VARCHAR2,
     AFACCTNO        IN VARCHAR2,
     PAGE_RPP          IN NUMBER,
     ROWS_RPP         IN NUMBER
     )
    IS

    v_custodycd varchar2(10);
    v_afacctno varchar2(10);

    v_balance varchar2(100);
    v_securebal varchar2(100);
    v_debt varchar2 (100);

    v_balance_en varchar2(100);
    v_securebal_en varchar2(100);
    v_debt_en varchar2 (100);



    v_currdate date;
    v_fomode varchar2(100);
    v_Secure_Amt number(20);
    v_NAV        number(20);
    v_Secure_Amt_Match number(20);

BEGIN


    v_afacctno:= AFACCTNO;

    select to_date(VARVALUE,'DD/MM/rrrr') into v_currdate from sysvar where grname='SYSTEM' and varname='CURRDATE';

/*INSERT INTO log_err
                        (id,date_log, POSITION, text
                        )
                 VALUES ( seq_log_err.NEXTVAL,SYSDATE, 'pr_get_seinfolist','AFACCTNO:' || AFACCTNO ||' PAGE_RPP:'||PAGE_RPP
                        );
                        COMMIT;*/

   Begin
        Select cdcontent, en_cdcontent into v_balance,v_balance_en
        From allcode
        where cdtype='AF' AND CDNAME='ASSETDETAIL' and cdval='001';
        Select cdcontent, en_cdcontent into v_securebal,v_securebal_en
        From allcode
        where cdtype='AF' AND CDNAME='ASSETDETAIL' and cdval='002';
        Select cdcontent, en_cdcontent into v_debt,v_debt_en
        From allcode
        where cdtype='AF' AND CDNAME='ASSETDETAIL' and cdval='003';

     EXCEPTION
      WHEN OTHERS THEN
        v_balance:='Tien';
        v_securebal:='Tien ky quy';
        v_debt:='No';
        v_balance_en:='Cash';
        v_securebal_en:='Secure Money';
        v_debt_en:='Debt';
   End;

SELECT varvalue INTO v_fomode FROM sysvar WHERE varname ='FOMODE' AND grname ='SYSTEM';

 IF v_fomode = 'ON' THEN
    v_Secure_Amt:=  CSPKS_FO_COMMON.fn_get_buy_amt@DBL_FO(V_AFACCTNO);
    v_Secure_Amt_Match:=  cspks_fo_account.fn_get_buy_amt_match@DBL_FO(V_AFACCTNO);
    --v_NAV       :=  fnc_get_NAV(V_AFACCTNO);
    IF  PAGE_RPP = 1 THEN

       OPEN p_REFCURSOR FOR

      SELECT * FROM (



       SELECT a.*, 0 r FROM (
       --Dong dau tien Danh muc dau tu: Lay thong tin tong
       SELECT '' IS_TRADE,
              '' EN_ITEM,
              '' ITEM,
              '' SYMBOL,
              '' AFACCTNO,
              '' CUSTODYCD,
              0 TRADE,
              0 TOTAL,
              0 WFT_QTTY,
              0 RECEIVING ,
              0 SECURED,
              0 BASICPRICE,
              0 COSTPRICE,
              0 RETAIL,
              ROUND(SUM(PROFITANDLOSS)) PL,
              0 PCPL,
              ROUND(SUM(COSTPRICEAMT)) COSTPRICEAMT,
              ROUND(SUM(MARKETAMT)) MARKETAMT,
              0 RECEIVING_RIGHT,
              0 RECEIVING_T0,
              0 RECEIVING_T1,
              0 RECEIVING_T2,
              0 RECEIVING_T3,
              0 SUM_QTTY,
              0 STT,
              '' ISBUY,
              ''  ISSELL
              FROM (
                         --Thong tin tien mat.
                          SELECT 'display_none' IS_TRADE,
                                 V_BALANCE_EN EN_ITEM,
                                 V_BALANCE ITEM,
                                 BUF.AFACCTNO ACCTNO,
                                 BUF.CUSTODYCD,
                                 --ROUND( BUF.BALANCE + BUF.BAMT) TRADE,
                                 NVL(FO_ACCT.BOD_BALANCE,0) TRADE,
                                 --ROUND((NVL(BUF.RECEIVING,0) - BUF.CASH_RECEIVING_T0 - BUF.CASH_RECEIVING_T1 - BUF.CASH_RECEIVING_T2) +
                                 --NVL(BUF.AVLADV_T1,0) +NVL(BUF.AVLADV_T2,0)+NVL(BUF.AVLADV_T3,0)) RECEIVING,
                                 NVL(FO.ADV_T2,0) +  NVL(BUF.AVLADV_T1,0) + NVL(BUF.AVLADV_T3,0) + NVL(buf.careceiving,0)  RECEIVING,
                                 0 SECURED,
                                 0 BASICPRICE,
                                 0 COSTPRICE,
                                 ROUND( NVL(R.RETAIL,0)) RETAIL,
                                 0 S_REMAINQTTY,
                                 0 PROFITANDLOSS,
                                 0 PCPL,
                                 0 COSTPRICEAMT,
                                 --ROUND(BUF.BALANCE +  BUF.BAMT + NVL(CARECEIVING,0)
                                 --+ NVL(BUF.AVLADV_T1,0) +NVL(BUF.AVLADV_T2,0)+ NVL(BUF.AVLADV_T3,0)) TOTAL,
                                 NVL(FO_ACCT.BOD_BALANCE,0) +   NVL(FO.ADV_T2,0) +  NVL(BUF.AVLADV_T1,0) + NVL(BUF.AVLADV_T3,0) + NVL(buf.careceiving,0) TOTAL,

                                 0 WFT_QTTY,
                                 --ROUND(BUF.BALANCE +  BUF.BAMT   + NVL(CARECEIVING,0)
                                 --+ NVL(BUF.AVLADV_T1,0) +NVL(BUF.AVLADV_T2,0)+ NVL(BUF.AVLADV_T3,0)) MARKETAMT,
                                 ROUND(NVL(FO_ACCT.BOD_BALANCE,0) + NVL(CARECEIVING,0) +  NVL(BUF.AVLADV_T1,0) + NVL(BUF.AVLADV_T3,0) +  NVL(FO.ADV_T2,0)) MARKETAMT,
                                 ROUND(NVL(BUF.CARECEIVING,0)) RECEIVING_RIGHT,
                                 0 RECEIVING_T0,
                                 NVL(BUF.AVLADV_T1,0) RECEIVING_T1,
                                 --NVL(BUF.AVLADV_T2,0) RECEIVING_T2,
                                 NVL(FO.ADV_T2,0) RECEIVING_T2,
                                 NVL(BUF.AVLADV_T3,0) RECEIVING_T3,
                                 0 STT
                            FROM BUF_CI_ACCOUNT BUF, ACCOUNTS@DBL_FO FO_ACCT,
                                                (
                                                 SELECT SUM(PRICE * QTTY) RETAIL, SUBSTR(ACCTNO,1,10) SEACCTNO
                                                   FROM SERETAIL
                                                  WHERE STATUS NOT IN ('C','R') GROUP BY SUBSTR(ACCTNO,1,10)
                                                 ) R,
                                                 (
                                                 SELECT SUM(t.qtty * t.price * (1-(o.rate_tax/100) - (o.rate_brk/100)))  ADV_T2, o.acctno acctno
                                                 FROM orders@dbl_fo o, trades@dbl_fo  t
                                                 WHERE o.orderid = t.orderid
                                                   AND o.acctno =V_AFACCTNO
                                                   AND o.subside IN ('NS','AS','SE','CS')
                                                   GROUP BY o.acctno
                                                ) FO
                            WHERE  BUF.AFACCTNO = V_AFACCTNO
                              AND BUF.AFACCTNO = R.SEACCTNO(+)
                              AND BUF.AFACCTNO =  FO_ACCT.ACCTNO(+)
                              AND BUF.AFACCTNO =  FO.ACCTNO(+)

                          UNION ALL
                           --Ky quy
                           SELECT 'display_none' IS_TRADE, V_SECUREBAL_EN EN_ITEM, V_SECUREBAL ITEM,BUF.AFACCTNO ACCTNO, CUSTODYCD,
                                 ROUND(v_Secure_Amt) TRADE,
                                 0 RECEIVING,
                                 0 SECURED,
                                 0 BASICPRICE,
                                 0 COSTPRICE,
                                 0 RETAIL,
                                 0 S_REMAINQTTY,
                                 0 PROFITANDLOSS,
                                 0 PCPL,
                                 0 COSTPRICEAMT,
                                 --ROUND(BUF.BAMT ) TOTAL,
                                 ROUND(v_Secure_Amt ) TOTAL,
                                 0 WFT_QTTY,
                                 -- -ROUND(BUF.BAMT)  MARKETAMT,
                                 -ROUND(v_Secure_Amt )  MARKETAMT,
                                 0 RECEIVING_RIGHT,
                                 0 RECEIVING_T0,
                                 0 RECEIVING_T1,
                                 0 RECEIVING_T2,
                                 0 RECEIVING_T3,
                                 1 STT
                          FROM BUF_CI_ACCOUNT BUF
                          WHERE   BUF.AFACCTNO = V_AFACCTNO

                          UNION ALL
                           --Debt
                           SELECT 'display_none' IS_TRADE, V_DEBT_EN EN_ITEM ,V_DEBT ITEM, AF.ACCTNO, BUF.CUSTODYCD,
                                 ROUND(NVL(LS.DEBT,0)  + BUF.OVDCIDEPOFEE) TRADE,
                                 0 RECEIVING,
                                 0 SECURED,
                                 0 BASICPRICE,
                                 0 COSTPRICE,
                                 0 RETAIL,0 S_REMAINQTTY,
                                 0 PROFITANDLOSS,
                                 0 PCPL,
                                 0 COSTPRICEAMT,
                                 ROUND(NVL(LS.DEBT,0)  + BUF.OVDCIDEPOFEE) TOTAL,
                                 0 WFT_QTTY,
                                 -ROUND(NVL(LS.DEBT,0)  + BUF.OVDCIDEPOFEE) MARKETAMT,
                                 0 RECEIVING_RIGHT,
                                 0 RECEIVING_T0,
                                 0 RECEIVING_T1,
                                 0 RECEIVING_T2,
                                 0 RECEIVING_T3,
                                 2 STT
                            FROM  AFMAST AF, (SELECT LN.TRFACCTNO,SUM(PRINNML + PRINOVD + INTNMLACR+INTOVDACR+INTNMLOVD+INTDUE +
                                    OPRINNML + OPRINOVD + OINTNMLACR + OINTNMLOVD + OINTOVDACR+INTNMLPBL + -- THEM LAI DU TINH BAO LANH MSBS-1264
                                    OINTDUE+FEE+FEEDUE+FEEOVD+FEEINTNMLACR+FEEINTOVDACR+FEEINTNMLOVD+FEEINTDUE) DEBT
                                    FROM  LNMAST LN
                                    GROUP BY LN.TRFACCTNO) LS,
                                    BUF_CI_ACCOUNT BUF
                          WHERE  AF.ACCTNO = LS.TRFACCTNO(+)
                          AND AF.ACCTNO = BUF.AFACCTNO
                          AND AF.ACCTNO = V_AFACCTNO

                          UNION ALL

                          SELECT IS_TRADE,EN_ITEM,ITEM,ACCTNO,CUSTODYCD, TRADE,RECEIVING, SECURED,BASICPRICE, COSTPRICE,
                                 RETAIL, S_REMAINQTTY,PROFITANDLOSS,PCPL,COSTPRICEAMT,TOTAL,WFT_QTTY,MARKETAMT, RECEIVING_RIGHT,
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
                                                        AND BUF.AFACCTNO = V_AFACCTNO
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
                                    AND SDTL.CODEID = SEC.CODEID AND SDTL.AFACCTNO = V_AFACCTNO
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
                                AND a.acctno = V_AFACCTNO
                                GROUP BY a.ACCTNO, a.CUSTODYCD, P_FO.SYMBOL,P_FO.TRADE

                            )
                             ORDER BY CUSTODYCD,ACCTNO,ITEM
                             ))

                          WHERE ACCTNO = V_AFACCTNO

                  ) MST --ORDER BY STT,CUSTODYCD,ACCTNO,ITEM
          ) A

       UNION ALL
         --Bat dau tu dong thu 2: Lay thong tin chi tiet
         SELECT  * FROM (
             SELECT a.*, rownum r FROM(
               SELECT IS_TRADE,
                      EN_ITEM,
                      ITEM,
                      ITEM SYMBOL,
                      MST.ACCTNO AFACCTNO,
                      CUSTODYCD,
                      TRUNC(TRADE) TRADE,
                      TRUNC(TOTAL) TOTAL,
                      TRUNC(WFT_QTTY) WFT_QTTY,
                      TRUNC(RECEIVING) RECEIVING ,
                      TRUNC(SECURED) SECURED,
                      TRUNC(BASICPRICE) BASICPRICE,
                      TRUNC(COSTPRICE) COSTPRICE,
                      TRUNC(RETAIL) RETAIL,
                      TRUNC(PROFITANDLOSS) PL,
                      PCPL,
                      TRUNC(COSTPRICEAMT) COSTPRICEAMT,
                      TRUNC(MARKETAMT) MARKETAMT,
                      TRUNC(RECEIVING_RIGHT) RECEIVING_RIGHT,
                      TRUNC(RECEIVING_T0) RECEIVING_T0,
                      TRUNC(RECEIVING_T1) RECEIVING_T1,
                      TRUNC(RECEIVING_T2) RECEIVING_T2,
                      TRUNC(RECEIVING_T3) RECEIVING_T3,
                      TRUNC(TRADE) +  TRUNC(S_REMAINQTTY) + TRUNC(RECEIVING_RIGHT) + TRUNC(RECEIVING_T0) +
                      TRUNC(RECEIVING_T1) + TRUNC(RECEIVING_T2) + TRUNC(RECEIVING_T3) SUM_QTTY,
                      STT,
                      CASE WHEN STT = 3 THEN 'Y' ELSE 'N' END ISBUY,
                      CASE WHEN STT = 3 THEN 'Y' ELSE 'N' END ISSELL
                      FROM (
                          --Thong tin tien mat.
                          SELECT 'display_none' IS_TRADE,
                                 V_BALANCE_EN EN_ITEM,
                                 V_BALANCE ITEM,
                                 BUF.AFACCTNO ACCTNO,
                                 BUF.CUSTODYCD,
                                 --ROUND( BUF.BALANCE + BUF.BAMT) TRADE,
                                 NVL(FO_ACCT.BOD_BALANCE,0) TRADE,
                                 --ROUND((NVL(BUF.RECEIVING,0) - BUF.CASH_RECEIVING_T0 - BUF.CASH_RECEIVING_T1 - BUF.CASH_RECEIVING_T2) +
                                 --NVL(BUF.AVLADV_T1,0) +NVL(BUF.AVLADV_T2,0)+NVL(BUF.AVLADV_T3,0)) RECEIVING,
                                 NVL(FO.ADV_T2,0) +  NVL(BUF.AVLADV_T1,0) + NVL(BUF.AVLADV_T3,0) + NVL(buf.careceiving,0)  RECEIVING,
                                 0 SECURED,
                                 0 BASICPRICE,
                                 0 COSTPRICE,
                                 ROUND( NVL(R.RETAIL,0)) RETAIL,
                                 0 S_REMAINQTTY,
                                 0 PROFITANDLOSS,
                                 0 PCPL,
                                 0 COSTPRICEAMT,
                                 --ROUND(BUF.BALANCE +  BUF.BAMT + NVL(CARECEIVING,0)
                                 --+ NVL(BUF.AVLADV_T1,0) +NVL(BUF.AVLADV_T2,0)+ NVL(BUF.AVLADV_T3,0)) TOTAL,
                                 NVL(FO_ACCT.BOD_BALANCE,0) +   NVL(FO.ADV_T2,0) +  NVL(BUF.AVLADV_T1,0) + NVL(BUF.AVLADV_T3,0) + NVL(buf.careceiving,0) TOTAL,

                                 0 WFT_QTTY,
                                 --ROUND(BUF.BALANCE +  BUF.BAMT   + NVL(CARECEIVING,0)
                                 --+ NVL(BUF.AVLADV_T1,0) +NVL(BUF.AVLADV_T2,0)+ NVL(BUF.AVLADV_T3,0)) MARKETAMT,
                                 ROUND(NVL(FO_ACCT.BOD_BALANCE,0) + NVL(CARECEIVING,0) +  NVL(BUF.AVLADV_T1,0) + NVL(BUF.AVLADV_T3,0) +  NVL(FO.ADV_T2,0)) MARKETAMT,
                                 ROUND(NVL(BUF.CARECEIVING,0)) RECEIVING_RIGHT,
                                 0 RECEIVING_T0,
                                 NVL(BUF.AVLADV_T1,0) RECEIVING_T1,
                                 --NVL(BUF.AVLADV_T2,0) RECEIVING_T2,
                                 NVL(FO.ADV_T2,0) RECEIVING_T2,
                                 NVL(BUF.AVLADV_T3,0) RECEIVING_T3,
                                 0 STT
                            FROM BUF_CI_ACCOUNT BUF, ACCOUNTS@DBL_FO FO_ACCT,
                                                (
                                                 SELECT SUM(PRICE * QTTY) RETAIL, SUBSTR(ACCTNO,1,10) SEACCTNO
                                                   FROM SERETAIL
                                                  WHERE STATUS NOT IN ('C','R') GROUP BY SUBSTR(ACCTNO,1,10)
                                                 ) R,
                                                 (
                                                 SELECT SUM(t.qtty * t.price * (1-(o.rate_tax/100) - (o.rate_brk/100)))  ADV_T2, o.acctno acctno
                                                 FROM orders@dbl_fo o, trades@dbl_fo  t
                                                 WHERE o.orderid = t.orderid
                                                   AND o.acctno =V_AFACCTNO
                                                   AND o.subside IN ('NS','AS','SE','CS')
                                                   GROUP BY o.acctno
                                                ) FO
                            WHERE  BUF.AFACCTNO = V_AFACCTNO
                              AND BUF.AFACCTNO = R.SEACCTNO(+)
                              AND BUF.AFACCTNO =  FO_ACCT.ACCTNO(+)
                              AND BUF.AFACCTNO =  FO.ACCTNO(+)

                          UNION ALL
                           --Ky quy
                           SELECT 'display_none' IS_TRADE, V_SECUREBAL_EN EN_ITEM, V_SECUREBAL ITEM,BUF.AFACCTNO ACCTNO, CUSTODYCD,
                                 ROUND(v_Secure_Amt) TRADE,
                                 0 RECEIVING,
                                 0 SECURED,
                                 0 BASICPRICE,
                                 0 COSTPRICE,
                                 0 RETAIL,
                                 0 S_REMAINQTTY,
                                 0 PROFITANDLOSS,
                                 0 PCPL,
                                 0 COSTPRICEAMT,
                                 --ROUND(BUF.BAMT ) TOTAL,
                                 ROUND(v_Secure_Amt ) TOTAL,
                                 0 WFT_QTTY,
                                 -- -ROUND(BUF.BAMT)  MARKETAMT,
                                 -ROUND(v_Secure_Amt )  MARKETAMT,
                                 0 RECEIVING_RIGHT,
                                 0 RECEIVING_T0,
                                 0 RECEIVING_T1,
                                 0 RECEIVING_T2,
                                 0 RECEIVING_T3,
                                 1 STT
                          FROM BUF_CI_ACCOUNT BUF
                          WHERE   BUF.AFACCTNO = V_AFACCTNO

                          UNION ALL
                           --Debt
                           SELECT 'display_none' IS_TRADE, V_DEBT_EN EN_ITEM ,V_DEBT ITEM, AF.ACCTNO, BUF.CUSTODYCD,
                                 ROUND(NVL(LS.DEBT,0)  + BUF.OVDCIDEPOFEE) TRADE,
                                 0 RECEIVING,
                                 0 SECURED,
                                 0 BASICPRICE,
                                 0 COSTPRICE,
                                 0 RETAIL,0 S_REMAINQTTY,
                                 0 PROFITANDLOSS,
                                 0 PCPL,
                                 0 COSTPRICEAMT,
                                 ROUND(NVL(LS.DEBT,0)  + BUF.OVDCIDEPOFEE) TOTAL,
                                 0 WFT_QTTY,
                                 -ROUND(NVL(LS.DEBT,0)  + BUF.OVDCIDEPOFEE) MARKETAMT,
                                 0 RECEIVING_RIGHT,
                                 0 RECEIVING_T0,
                                 0 RECEIVING_T1,
                                 0 RECEIVING_T2,
                                 0 RECEIVING_T3,
                                 2 STT
                            FROM  AFMAST AF, (SELECT LN.TRFACCTNO,SUM(PRINNML + PRINOVD + INTNMLACR+INTOVDACR+INTNMLOVD+INTDUE +
                                    OPRINNML + OPRINOVD + OINTNMLACR + OINTNMLOVD + OINTOVDACR+INTNMLPBL + -- THEM LAI DU TINH BAO LANH MSBS-1264
                                    OINTDUE+FEE+FEEDUE+FEEOVD+FEEINTNMLACR+FEEINTOVDACR+FEEINTNMLOVD+FEEINTDUE) DEBT
                                    FROM  LNMAST LN
                                    GROUP BY LN.TRFACCTNO) LS,
                                    BUF_CI_ACCOUNT BUF
                          WHERE  AF.ACCTNO = LS.TRFACCTNO(+)
                          AND AF.ACCTNO = BUF.AFACCTNO
                          AND AF.ACCTNO = V_AFACCTNO

                          UNION ALL

                          SELECT IS_TRADE,EN_ITEM,ITEM,ACCTNO,CUSTODYCD, TRADE,RECEIVING, SECURED,BASICPRICE, COSTPRICE,
                                 RETAIL, S_REMAINQTTY,PROFITANDLOSS,PCPL,COSTPRICEAMT,TOTAL,WFT_QTTY,MARKETAMT, RECEIVING_RIGHT,
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
                                                        AND BUF.AFACCTNO = V_AFACCTNO
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
                                    AND SDTL.CODEID = SEC.CODEID AND SDTL.AFACCTNO = V_AFACCTNO
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
                                AND a.acctno = V_AFACCTNO
                                GROUP BY a.ACCTNO, a.CUSTODYCD, P_FO.SYMBOL,P_FO.TRADE

                            )
                             ORDER BY CUSTODYCD,ACCTNO,ITEM
                             ))

                          WHERE ACCTNO = V_AFACCTNO

                  ) MST ORDER BY STT,CUSTODYCD,ACCTNO,ITEM
          ) A WHERE ROWNUM <= ROWS_RPP * PAGE_RPP
          ) WHERE  R > ROWS_RPP * (PAGE_RPP - 1));

      ELSE  --PageNo =1

       OPEN p_REFCURSOR FOR

       SELECT * FROM (
       SELECT A.*, ROWNUM R FROM (

       SELECT IS_TRADE,
                      EN_ITEM,
                      ITEM,
                      ITEM SYMBOL,
                      MST.ACCTNO AFACCTNO,
                      CUSTODYCD,
                      TRUNC(TRADE) TRADE,
                      TRUNC(TOTAL) TOTAL,
                      TRUNC(WFT_QTTY) WFT_QTTY,
                      TRUNC(RECEIVING) RECEIVING ,
                      TRUNC(SECURED) SECURED,
                      TRUNC(BASICPRICE) BASICPRICE,
                      TRUNC(COSTPRICE) COSTPRICE,
                      TRUNC(RETAIL) RETAIL,
                      TRUNC(PROFITANDLOSS) PL,
                      PCPL,
                      TRUNC(COSTPRICEAMT) COSTPRICEAMT,
                      TRUNC(MARKETAMT) MARKETAMT,
                      TRUNC(RECEIVING_RIGHT) RECEIVING_RIGHT,
                      TRUNC(RECEIVING_T0) RECEIVING_T0,
                      TRUNC(RECEIVING_T1) RECEIVING_T1,
                      TRUNC(RECEIVING_T2) RECEIVING_T2,
                      TRUNC(RECEIVING_T3) RECEIVING_T3,
                      TRUNC(TRADE) +  TRUNC(S_REMAINQTTY) + TRUNC(RECEIVING_RIGHT) + TRUNC(RECEIVING_T0) +
                      TRUNC(RECEIVING_T1) + TRUNC(RECEIVING_T2) + TRUNC(RECEIVING_T3) SUM_QTTY,
                      STT,
                      CASE WHEN STT = 3 THEN 'Y' ELSE 'N' END ISBUY,
                      CASE WHEN STT = 3 THEN 'Y' ELSE 'N' END ISSELL
                      FROM (
                          --Thong tin tien mat.
                          SELECT 'display_none' IS_TRADE,
                                 V_BALANCE_EN EN_ITEM,
                                 V_BALANCE ITEM,
                                 BUF.AFACCTNO ACCTNO,
                                 BUF.CUSTODYCD,
                                 --ROUND( BUF.BALANCE + BUF.BAMT) TRADE,
                                 NVL(FO_ACCT.BOD_BALANCE,0) TRADE,
                                 --ROUND((NVL(BUF.RECEIVING,0) - BUF.CASH_RECEIVING_T0 - BUF.CASH_RECEIVING_T1 - BUF.CASH_RECEIVING_T2) +
                                 --NVL(BUF.AVLADV_T1,0) +NVL(BUF.AVLADV_T2,0)+NVL(BUF.AVLADV_T3,0)) RECEIVING,
                                 NVL(FO.ADV_T2,0) +  NVL(BUF.AVLADV_T1,0) + NVL(BUF.AVLADV_T3,0) + NVL(buf.careceiving,0)  RECEIVING,
                                 0 SECURED,
                                 0 BASICPRICE,
                                 0 COSTPRICE,
                                 ROUND( NVL(R.RETAIL,0)) RETAIL,
                                 0 S_REMAINQTTY,
                                 0 PROFITANDLOSS,
                                 0 PCPL,
                                 0 COSTPRICEAMT,
                                 --ROUND(BUF.BALANCE +  BUF.BAMT + NVL(CARECEIVING,0)
                                 --+ NVL(BUF.AVLADV_T1,0) +NVL(BUF.AVLADV_T2,0)+ NVL(BUF.AVLADV_T3,0)) TOTAL,
                                 NVL(FO_ACCT.BOD_BALANCE,0) +   NVL(FO.ADV_T2,0) +  NVL(BUF.AVLADV_T1,0) + NVL(BUF.AVLADV_T3,0) + NVL(buf.careceiving,0) TOTAL,

                                 0 WFT_QTTY,
                                 --ROUND(BUF.BALANCE +  BUF.BAMT   + NVL(CARECEIVING,0)
                                 --+ NVL(BUF.AVLADV_T1,0) +NVL(BUF.AVLADV_T2,0)+ NVL(BUF.AVLADV_T3,0)) MARKETAMT,
                                 ROUND(NVL(FO_ACCT.BOD_BALANCE,0) + NVL(CARECEIVING,0) + NVL(BUF.AVLADV_T1,0) + NVL(BUF.AVLADV_T3,0) +  NVL(FO.ADV_T2,0)) MARKETAMT,
                                 ROUND(NVL(BUF.CARECEIVING,0)) RECEIVING_RIGHT,
                                 0 RECEIVING_T0,
                                 NVL(BUF.AVLADV_T1,0) RECEIVING_T1,
                                 --NVL(BUF.AVLADV_T2,0) RECEIVING_T2,
                                 NVL(FO.ADV_T2,0) RECEIVING_T2,
                                 NVL(BUF.AVLADV_T3,0) RECEIVING_T3,
                                 0 STT
                            FROM BUF_CI_ACCOUNT BUF, ACCOUNTS@DBL_FO FO_ACCT,
                                                (
                                                 SELECT SUM(PRICE * QTTY) RETAIL, SUBSTR(ACCTNO,1,10) SEACCTNO
                                                   FROM SERETAIL
                                                  WHERE STATUS NOT IN ('C','R') GROUP BY SUBSTR(ACCTNO,1,10)
                                                 ) R,
                                                 (
                                                 SELECT SUM(t.qtty * t.price * (1-(o.rate_tax/100) - (o.rate_brk/100)))  ADV_T2, o.acctno acctno
                                                 FROM orders@dbl_fo o, trades@dbl_fo  t
                                                 WHERE o.orderid = t.orderid
                                                   AND o.acctno =V_AFACCTNO
                                                   AND o.subside IN ('NS','AS','SE','CS')
                                                   GROUP BY o.acctno
                                                ) FO
                            WHERE  BUF.AFACCTNO = V_AFACCTNO
                              AND BUF.AFACCTNO = R.SEACCTNO(+)
                              AND BUF.AFACCTNO =  FO_ACCT.ACCTNO(+)
                              AND BUF.AFACCTNO =  FO.ACCTNO(+)
                          UNION ALL
                           --Ky quy
                           SELECT 'display_none' IS_TRADE, V_SECUREBAL_EN EN_ITEM, V_SECUREBAL ITEM,BUF.AFACCTNO ACCTNO, CUSTODYCD,
                                 ROUND(v_Secure_Amt) TRADE,
                                 0 RECEIVING,
                                 0 SECURED,
                                 0 BASICPRICE,
                                 0 COSTPRICE,
                                 0 RETAIL,
                                 0 S_REMAINQTTY,
                                 0 PROFITANDLOSS,
                                 0 PCPL,
                                 0 COSTPRICEAMT,
                                 --ROUND(BUF.BAMT ) TOTAL,
                                 ROUND(v_Secure_Amt ) TOTAL,
                                 0 WFT_QTTY,
                                 -- -ROUND(BUF.BAMT)  MARKETAMT,
                                 -ROUND(v_Secure_Amt )  MARKETAMT,
                                 0 RECEIVING_RIGHT,
                                 0 RECEIVING_T0,
                                 0 RECEIVING_T1,
                                 0 RECEIVING_T2,
                                 0 RECEIVING_T3,
                                 1 STT
                          FROM BUF_CI_ACCOUNT BUF
                          WHERE   BUF.AFACCTNO = V_AFACCTNO

                          UNION ALL
                           --Debt
                           SELECT 'display_none' IS_TRADE, V_DEBT_EN EN_ITEM ,V_DEBT ITEM, AF.ACCTNO, BUF.CUSTODYCD,
                                 ROUND(NVL(LS.DEBT,0)  + BUF.OVDCIDEPOFEE) TRADE,
                                 0 RECEIVING,
                                 0 SECURED,
                                 0 BASICPRICE,
                                 0 COSTPRICE,
                                 0 RETAIL,0 S_REMAINQTTY,
                                 0 PROFITANDLOSS,
                                 0 PCPL,
                                 0 COSTPRICEAMT,
                                 ROUND(NVL(LS.DEBT,0)  + BUF.OVDCIDEPOFEE) TOTAL,
                                 0 WFT_QTTY,
                                 -ROUND(NVL(LS.DEBT,0)  + BUF.OVDCIDEPOFEE) MARKETAMT,
                                 0 RECEIVING_RIGHT,
                                 0 RECEIVING_T0,
                                 0 RECEIVING_T1,
                                 0 RECEIVING_T2,
                                 0 RECEIVING_T3,
                                 2 STT
                            FROM  AFMAST AF, (SELECT LN.TRFACCTNO,SUM(PRINNML + PRINOVD + INTNMLACR+INTOVDACR+INTNMLOVD+INTDUE +
                                    OPRINNML + OPRINOVD + OINTNMLACR + OINTNMLOVD + OINTOVDACR+INTNMLPBL + -- THEM LAI DU TINH BAO LANH MSBS-1264
                                    OINTDUE+FEE+FEEDUE+FEEOVD+FEEINTNMLACR+FEEINTOVDACR+FEEINTNMLOVD+FEEINTDUE) DEBT
                                    FROM  LNMAST LN
                                    GROUP BY LN.TRFACCTNO) LS,
                                    BUF_CI_ACCOUNT BUF
                          WHERE  AF.ACCTNO = LS.TRFACCTNO(+)
                          AND AF.ACCTNO = BUF.AFACCTNO
                          AND AF.ACCTNO = V_AFACCTNO

                          UNION ALL

                          SELECT IS_TRADE,EN_ITEM,ITEM,ACCTNO,CUSTODYCD, TRADE,RECEIVING, SECURED,BASICPRICE, COSTPRICE,
                                 RETAIL, S_REMAINQTTY,PROFITANDLOSS,PCPL,COSTPRICEAMT,TOTAL,WFT_QTTY,MARKETAMT, RECEIVING_RIGHT,
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
                                                        AND BUF.AFACCTNO = V_AFACCTNO
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
                                    AND SDTL.CODEID = SEC.CODEID AND SDTL.AFACCTNO = V_AFACCTNO
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
                                AND a.acctno = V_AFACCTNO
                                GROUP BY a.ACCTNO, a.CUSTODYCD, P_FO.SYMBOL,P_FO.TRADE

                            )
                             ORDER BY CUSTODYCD,ACCTNO,ITEM
                             ))

                          WHERE ACCTNO = V_AFACCTNO

                  ) MST ORDER BY STT,CUSTODYCD,ACCTNO,ITEM
          ) A WHERE ROWNUM <= ROWS_RPP * PAGE_RPP
          ) WHERE  R > ROWS_RPP * (PAGE_RPP - 1);
       END IF;


 ELSE  --FOMODE OFF


     if  PAGE_RPP = 1 then

       OPEN p_REFCURSOR FOR

       select * from ( select a.*, 0 r from (

       SELECT '' IS_TRADE, '' EN_ITEM, '' ITEM,'' SYMBOL, '' AFACCTNO,'' CUSTODYCD,0 trade, 0 total, 0 wft_qtty, 0 receiving ,
           0 secured, 0 basicprice,0 costprice,0  retail,
            ROUND(sum(PROFITANDLOSS)) PL,0 PCPL, ROUND(sum(COSTPRICEAMT)) COSTPRICEAMT,
          ROUND(sum(MARKETAMT)) marketamt,
            0 receiving_right,0 receiving_t0, 0 receiving_t1,0 receiving_t2,0 receiving_t3,
           0 SUM_QTTY,
           0 stt,
            '' ISBUY,
            ''  ISSELL
              FROM (        Select 'display_none' IS_TRADE, v_balance_en en_item, v_balance Item,buf.afacctno acctno, CUSTODYCD,
                         round( buf.balance + buf.bamt) trade,
                        round( (nvl(buf.RECEIVING,0) - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 -
                            buf.CASH_RECEIVING_T2) + nvl(buf.avladv_t1,0) +nvl(buf.avladv_t2,0)+nvl(buf.avladv_t3,0)) RECEIVING,
                         0 secured,
                         0 basicprice,
                         0 costprice,
                        round( nvl(r.retail,0)) retail, 0 S_REMAINQTTY,
                         0 PROFITANDLOSS,
                         0 PCPL,
                         0 COSTPRICEAMT,
                         round(buf.balance +  buf.bamt + nvl(careceiving,0)--(nvl(buf.RECEIVING,0)  - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 - buf.CASH_RECEIVING_T2 )         --T2_HoangND
                         + nvl(buf.avladv_t1,0) +nvl(buf.avladv_t2,0)+nvl(buf.avladv_t3,0)) total,
                         0 wft_qtty, round(buf.balance +  buf.bamt + nvl(careceiving,0)--(nvl(buf.RECEIVING,0)  - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 - buf.CASH_RECEIVING_T2 )         --T2_HoangND
                         + nvl(buf.avladv_t1,0) +nvl(buf.avladv_t2,0)+nvl(buf.avladv_t3,0)) MARKETAMT,
                         --nvl(buf.RECEIVING,0) - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 -  buf.CASH_RECEIVING_T2 - nvl(r.retail,0)   receiving_right,
                         round(nvl(buf.careceiving,0)) receiving_right,       --T2_HoangND edit
                         0 receiving_t0,
                         nvl(buf.avladv_t1,0) receiving_t1,
                         nvl(buf.avladv_t2,0) receiving_t2,
                         nvl(buf.avladv_t3,0) receiving_t3,
                         0 stt
                  From buf_ci_account buf,
                  (select sum(price*qtty) retail, substr(acctno,1,10) seacctno from seretail where status not in ('C','R') group by substr(acctno,1,10)) r--,
                  --(SELECT SUM(amt) careceiving, afacctno  FROM caschd WHERE  status IN ('I','S','H') AND ISEXEC ='Y' AND deltd <> 'Y'   --T2_HoangND
                    --GROUP BY afacctno) ca
                  where  buf.AFACCTNO like v_afacctno
                  --AND BUF.CUSTODYCD like v_custodycd
                  AND BUF.AFACCTNO = r.seacctno(+)
                  --AND BUF.AFACCTNO = ca.afacctno(+)
                  union all
                   Select 'display_none' IS_TRADE, v_securebal_en en_item, v_securebal Item,buf.afacctno acctno, CUSTODYCD,
                         round(buf.bamt) trade,
                         0 RECEIVING,
                         0 secured,
                         0 basicprice,
                         0 costprice,
                         0 retail, 0 S_REMAINQTTY,
                         0 PROFITANDLOSS,
                         0 PCPL,
                         0 COSTPRICEAMT,
                         round(buf.bamt) total, 0 wft_qtty, -round(buf.bamt)  MARKETAMT,
                         0 receiving_right,
                         0 receiving_t0,
                         0 receiving_t1,
                         0 receiving_t2,
                         0 receiving_t3,
                         1 stt
                  From buf_ci_account buf
                  where   buf.AFACCTNO like v_afacctno
                  -- AND BUF.CUSTODYCD like v_custodycd
                  union all
                   SELECT 'display_none' IS_TRADE, v_debt_en en_item ,v_debt Item, AF.ACCTNO, buf.CUSTODYCD,
                         round(nvl(LS.DEBT,0)  + buf.OVDCIDEPOFEE) trade,
                         0 receiving,
                         0 secured,
                         0 basicprice,
                         0 costprice,
                         0 retail,0 S_REMAINQTTY,
                         0 PROFITANDLOSS,
                         0 PCPL,
                         0 COSTPRICEAMT,
                         round(nvl(LS.DEBT,0)  + buf.OVDCIDEPOFEE) total,0 wft_qtty,
                         -round(nvl(LS.DEBT,0)  + buf.OVDCIDEPOFEE) MARKETAMT,
                         0 receiving_right,
                         0 receiving_t0,
                         0 receiving_t1,
                         0 receiving_t2,
                         0 receiving_t3,
                         2 stt
                    FROM  AFMAST AF, (SELECT LN.TRFACCTNO,SUM(prinnml + prinovd + intnmlacr+intovdacr+intnmlovd+intdue +
                            oprinnml + oprinovd + ointnmlacr + ointnmlovd + ointovdacr+INTNMLPBL + -- them lai du tinh bao lanh MSBS-1264
                            ointdue+fee+feedue+feeovd+feeintnmlacr+feeintovdacr+feeintnmlovd+feeintdue) DEBT
                            FROM  LNMAST LN
                            GROUP BY LN.TRFACCTNO) LS,
                            buf_ci_account buf
                  WHERE  AF.ACCTNO = ls.TRFACCTNO(+)
                --  AND BUF.CUSTODYCD like v_custodycd
                  and af.acctno=buf.afacctno
                  AND AF.ACCTNO like v_afacctno

                  union

                  select IS_TRADE,en_item,Item,ACCTNO,CUSTODYCD, trade,receiving, secured,basicprice, costprice,
                         retail, S_REMAINQTTY,PROFITANDLOSS,PCPL,COSTPRICEAMT,total,wft_qtty,MARKETAMT, receiving_right,
                         receiving_t0,receiving_t1, receiving_t2, receiving_t3, stt
                  from VW_PORTFOLIO_RPP
                  where acctno like v_afacctno

                  ) MST order by stt,custodycd,acctno,item
          ) a
          )


       UNION ALL

       select * from (
       select a.*, rownum r from (

       SELECT IS_TRADE, EN_ITEM, ITEM, ITEM SYMBOL, MST.ACCTNO AFACCTNO, CUSTODYCD, trunc(trade) trade,  trunc(total) total,  trunc(wft_qtty) wft_qtty, trunc(receiving) receiving ,
            trunc(secured) secured, trunc(basicprice) basicprice,trunc(COSTPRICE) costprice,  trunc(retail) retail,
            trunc (PROFITANDLOSS) PL,  PCPL, trunc(COSTPRICEAMT) COSTPRICEAMT,
            trunc(MARKETAMT) marketamt,
            trunc(receiving_right) receiving_right,trunc(receiving_t0) receiving_t0, trunc(receiving_t1) receiving_t1, trunc(receiving_t2) receiving_t2, trunc(receiving_t3) receiving_t3,
            trunc(trade) +  trunc(S_REMAINQTTY) + trunc(receiving_right) + trunc(receiving_t0) + trunc(receiving_t1) + trunc(receiving_t2) + trunc(receiving_t3) SUM_QTTY,
            stt,
            case when stt = 3 then 'Y' else 'N' end ISBUY,
            case when stt = 3 then 'Y' else 'N' end ISSELL
              FROM (
                  Select 'display_none' IS_TRADE, v_balance_en en_item, v_balance Item,buf.afacctno acctno, CUSTODYCD,
                         round( buf.balance + buf.bamt) trade,
                        round( (nvl(buf.RECEIVING,0) - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 -
                            buf.CASH_RECEIVING_T2) + nvl(buf.avladv_t1,0) +nvl(buf.avladv_t2,0)+nvl(buf.avladv_t3,0)) RECEIVING,
                         0 secured,
                         0 basicprice,
                         0 costprice,
                        round( nvl(r.retail,0)) retail, 0 S_REMAINQTTY,
                         0 PROFITANDLOSS,
                         0 PCPL,
                         0 COSTPRICEAMT,
                         round(buf.balance +  buf.bamt + nvl(careceiving,0)--(nvl(buf.RECEIVING,0)  - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 - buf.CASH_RECEIVING_T2 )         --T2_HoangND
                         + nvl(buf.avladv_t1,0) +nvl(buf.avladv_t2,0)+nvl(buf.avladv_t3,0)) total,
                         0 wft_qtty, round(buf.balance +  buf.bamt + nvl(careceiving,0)--(nvl(buf.RECEIVING,0)  - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 - buf.CASH_RECEIVING_T2 )         --T2_HoangND
                         + nvl(buf.avladv_t1,0) +nvl(buf.avladv_t2,0)+nvl(buf.avladv_t3,0)) MARKETAMT,
                         --nvl(buf.RECEIVING,0) - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 -  buf.CASH_RECEIVING_T2 - nvl(r.retail,0)   receiving_right,
                         round(nvl(buf.careceiving,0)) receiving_right,       --T2_HoangND edit
                         0 receiving_t0,
                         nvl(buf.avladv_t1,0) receiving_t1,
                         nvl(buf.avladv_t2,0) receiving_t2,
                         nvl(buf.avladv_t3,0) receiving_t3,
                         0 stt
                  From buf_ci_account buf,
                  (select sum(price*qtty) retail, substr(acctno,1,10) seacctno from seretail where status not in ('C','R') group by substr(acctno,1,10)) r--,
                  --(SELECT SUM(amt) careceiving, afacctno  FROM caschd WHERE  status IN ('I','S','H') AND ISEXEC ='Y' AND deltd <> 'Y'   --T2_HoangND
                    --GROUP BY afacctno) ca
                  where  buf.AFACCTNO like v_afacctno
                 -- AND BUF.CUSTODYCD like v_custodycd
                  AND BUF.AFACCTNO = r.seacctno(+)
                  --AND BUF.AFACCTNO = ca.afacctno(+)
                  union all
                   Select 'display_none' IS_TRADE, v_securebal_en en_item, v_securebal Item,buf.afacctno acctno, CUSTODYCD,
                         round(buf.bamt) trade,
                         0 RECEIVING,
                         0 secured,
                         0 basicprice,
                         0 costprice,
                         0 retail, 0 S_REMAINQTTY,
                         0 PROFITANDLOSS,
                         0 PCPL,
                         0 COSTPRICEAMT,
                         round(buf.bamt) total, 0 wft_qtty, -round(buf.bamt)  MARKETAMT,
                         0 receiving_right,
                         0 receiving_t0,
                         0 receiving_t1,
                         0 receiving_t2,
                         0 receiving_t3,
                         1 stt
                  From buf_ci_account buf
                  where   buf.AFACCTNO like v_afacctno
                  -- AND BUF.CUSTODYCD like v_custodycd
                  union all
                   SELECT 'display_none' IS_TRADE, v_debt_en en_item ,v_debt Item, AF.ACCTNO, buf.CUSTODYCD,
                         round(nvl(LS.DEBT,0)  + buf.OVDCIDEPOFEE) trade,
                         0 receiving,
                         0 secured,
                         0 basicprice,
                         0 costprice,
                         0 retail,0 S_REMAINQTTY,
                         0 PROFITANDLOSS,
                         0 PCPL,
                         0 COSTPRICEAMT,
                         round(nvl(LS.DEBT,0)  + buf.OVDCIDEPOFEE) total,0 wft_qtty,
                         -round(nvl(LS.DEBT,0)  + buf.OVDCIDEPOFEE) MARKETAMT,
                         0 receiving_right,
                         0 receiving_t0,
                         0 receiving_t1,
                         0 receiving_t2,
                         0 receiving_t3,
                         2 stt
                    FROM  AFMAST AF, (SELECT LN.TRFACCTNO,SUM(prinnml + prinovd + intnmlacr+intovdacr+intnmlovd+intdue +
                            oprinnml + oprinovd + ointnmlacr + ointnmlovd + ointovdacr+INTNMLPBL + -- them lai du tinh bao lanh MSBS-1264
                            ointdue+fee+feedue+feeovd+feeintnmlacr+feeintovdacr+feeintnmlovd+feeintdue) DEBT
                            FROM  LNMAST LN
                            GROUP BY LN.TRFACCTNO) LS,
                            buf_ci_account buf
                  WHERE  AF.ACCTNO = ls.TRFACCTNO(+)
                 -- AND BUF.CUSTODYCD like v_custodycd
                  and af.acctno=buf.afacctno
                  AND AF.ACCTNO like v_afacctno

                  union

                  select IS_TRADE,en_item,Item,ACCTNO,CUSTODYCD, trade,receiving, secured,basicprice, costprice,
                         retail, S_REMAINQTTY,PROFITANDLOSS,PCPL,COSTPRICEAMT,total,wft_qtty,MARKETAMT, receiving_right,
                         receiving_t0,receiving_t1, receiving_t2, receiving_t3, stt
                  from VW_PORTFOLIO_RPP
                  where acctno like v_afacctno

                  ) MST order by stt,custodycd,acctno,item
          ) a where rownum <= ROWS_RPP * PAGE_RPP
          ) where  r > ROWS_RPP * (PAGE_RPP - 1);
      else

       OPEN p_REFCURSOR FOR

       select * from (
       select a.*, rownum r from (

       SELECT IS_TRADE, en_item, ITEM, ITEM SYMBOL, MST.ACCTNO AFACCTNO, CUSTODYCD, trunc(trade) trade,  trunc(total) total,  trunc(wft_qtty) wft_qtty, trunc(receiving) receiving ,
            trunc(secured) secured, trunc(basicprice) basicprice,trunc(COSTPRICE) costprice,  trunc(retail) retail,
            trunc (PROFITANDLOSS) PL,  PCPL, trunc(COSTPRICEAMT) COSTPRICEAMT,
            trunc(MARKETAMT) marketamt,
            trunc(receiving_right) receiving_right,trunc(receiving_t0) receiving_t0,trunc(receiving_t1) receiving_t1,
            trunc(receiving_t2) receiving_t2,trunc(receiving_t3) receiving_t3,
            trunc(trade) +  trunc(S_REMAINQTTY) + trunc(receiving_right) + trunc(receiving_t0) + trunc(receiving_t1) + trunc(receiving_t2) + trunc(receiving_t3) SUM_QTTY,
            stt,
            case when stt = 3 then 'Y' else 'N' end ISBUY,
            case when stt = 3 then 'Y' else 'N' end ISSELL
              FROM (
                  Select 'display_none' IS_TRADE, v_balance_en en_item, v_balance Item,buf.afacctno acctno, CUSTODYCD,
                         round( buf.balance + buf.bamt) trade,
                        round( (nvl(buf.RECEIVING,0) - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 -
                            buf.CASH_RECEIVING_T2) + nvl(buf.avladv_t1,0) +nvl(buf.avladv_t2,0)+nvl(buf.avladv_t3,0)) RECEIVING,
                         0 secured,
                         0 basicprice,
                         0 costprice,
                        round( nvl(r.retail,0)) retail, 0 S_REMAINQTTY,
                         0 PROFITANDLOSS,
                         0 PCPL,
                         0 COSTPRICEAMT,
                         round(buf.balance +  buf.bamt + nvl(careceiving,0)--(nvl(buf.RECEIVING,0)  - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 - buf.CASH_RECEIVING_T2 )         --T2_HoangND
                         + nvl(buf.avladv_t1,0) +nvl(buf.avladv_t2,0)+nvl(buf.avladv_t3,0)) total
                         , 0 wft_qtty,  round(buf.balance +  buf.bamt + nvl(careceiving,0)--(nvl(buf.RECEIVING,0)  - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 - buf.CASH_RECEIVING_T2 )         --T2_HoangND
                         + nvl(buf.avladv_t1,0) +nvl(buf.avladv_t2,0)+nvl(buf.avladv_t3,0)) MARKETAMT,
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
                  where  buf.AFACCTNO like v_afacctno
                 -- AND BUF.CUSTODYCD like v_custodycd
                  AND BUF.AFACCTNO = r.seacctno(+)
                  --AND BUF.AFACCTNO = ca.afacctno(+)
                  union all
                   Select 'display_none' IS_TRADE, v_securebal_en en_item, v_securebal Item,buf.afacctno acctno, CUSTODYCD,
                        round(buf.bamt) trade,
                         0 RECEIVING,
                         0 secured,
                         0 basicprice,
                         0 costprice,
                         0 retail, 0 S_REMAINQTTY,
                         0 PROFITANDLOSS,
                         0 PCPL,
                         0 COSTPRICEAMT,
                         round(buf.bamt) total, 0 wft_qtty, -round(buf.bamt)  MARKETAMT,
                         0 receiving_right,
                         0 receiving_t0,
                         0 receiving_t1,
                         0 receiving_t2,
                         0 receiving_t3,
                         1 stt
                  From buf_ci_account buf
                  where   buf.AFACCTNO like v_afacctno
                 --  AND BUF.CUSTODYCD like v_custodycd
                  union all
                   SELECT 'display_none' IS_TRADE, v_debt_en en_item, v_debt Item, AF.ACCTNO, buf.CUSTODYCD,
                         round(nvl(LS.DEBT,0)  + buf.OVDCIDEPOFEE) trade,
                         0 receiving,
                         0 secured,
                         0 basicprice,
                         0 costprice,
                         0 retail, 0S_REMAINQTTY,
                         0 PROFITANDLOSS,
                         0 PCPL,
                         0 COSTPRICEAMT,
                         round(nvl(LS.DEBT,0)  + buf.OVDCIDEPOFEE) total,0 wft_qtty,-round(nvl(LS.DEBT,0)  + buf.OVDCIDEPOFEE) MARKETAMT,
                         0 receiving_right,
                         0 receiving_t0,
                         0 receiving_t1,
                         0 receiving_t2,
                         0 receiving_t3,
                         2 stt
                    FROM  AFMAST AF, (SELECT LN.TRFACCTNO,SUM(prinnml + prinovd + intnmlacr+intovdacr+intnmlovd+intdue +
                            oprinnml + oprinovd + ointnmlacr + ointnmlovd + ointovdacr+INTNMLPBL + -- them lai du tinh bao lanh MSBS-1264
                            ointdue+fee+feedue+feeovd+feeintnmlacr+feeintovdacr+feeintnmlovd+feeintdue) DEBT
                            FROM  LNMAST LN
                            GROUP BY LN.TRFACCTNO) LS,
                            buf_ci_account buf
                  WHERE  AF.ACCTNO = ls.TRFACCTNO(+)
                --  AND BUF.CUSTODYCD like v_custodycd
                  and af.acctno=buf.afacctno
                  AND AF.ACCTNO like v_afacctno

                  union

                  select IS_TRADE,en_item,Item,ACCTNO,CUSTODYCD, trade,receiving, secured,basicprice, costprice,
                         retail, S_REMAINQTTY,PROFITANDLOSS,PCPL,COSTPRICEAMT,total,wft_qtty,MARKETAMT, receiving_right,
                         receiving_t0,receiving_t1, receiving_t2, receiving_t3, stt
                  from VW_PORTFOLIO_RPP
                  where acctno like v_afacctno

                  ) MST order by stt,custodycd,acctno,item
          ) a where rownum <= ROWS_RPP * PAGE_RPP
          ) where  r > ROWS_RPP * (PAGE_RPP - 1);
       end if;
 END IF; --End FOMODE


EXCEPTION
  WHEN OTHERS THEN
     plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'pr_get_seinfolist');

END pr_get_seinfolist;


FUNCTION fnc_get_NAV(
 p_afacctno IN      VARCHAR2
) RETURN NUMBER



IS
  V_SEASS       number(20);
  v_Secure_Amt  number(20);
  v_MoneyTotal       number(20);
BEGIN

  BEGIN
  --Lay tong tai san chung khoan.
     SELECT NVL(round(sum(marketamt)),0) INTO V_SEASS
        FROM  (SELECT
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
                                          AND buf.afacctno = p_afacctno

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
                        AND SDTL.CODEID = SEC.CODEID AND SDTL.afacctno = p_afacctno
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
                    AND a.acctno = p_afacctno
                    GROUP BY a.ACCTNO, a.CUSTODYCD, P_FO.SYMBOL,P_FO.TRADE
                )
                 ORDER BY CUSTODYCD,ACCTNO,ITEM
                 ))
        WHERE acctno = p_afacctno;
  EXCEPTION WHEN OTHERS THEN
      V_SEASS:=0;

  END;
  --Ky quy:
   v_Secure_Amt:=  cspks_fo_account.fn_get_buy_amt_match@DBL_FO(p_afacctno);


   --Tinh tien trong
   BEGIN
        SELECT ROUND(
                      NVL(FO_ACCT.BOD_BALANCE,0) - v_Secure_Amt  +  NVL(FO_ACCT.CALC_ADVBAL,0) +
                      NVL(FO_ACCT.bod_adv,0) - ROUND(NVL(BOD_DEBT,0) + NVL(BOD_PAYABLE,0))
                     ) MoneyTotal
        INTO  v_MoneyTotal
        FROM ACCOUNTS@DBL_FO FO_ACCT WHERE  ACCTNO = p_afacctno;
   EXCEPTION WHEN OTHERS THEN
      v_MoneyTotal:=0;
   END;

   v_MoneyTotal:=v_MoneyTotal +   V_SEASS;

   RETURN v_MoneyTotal;

EXCEPTION WHEN OTHERS THEN
   RETURN 0;
END;

PROCEDURE pr_GetTradeDiary
(
    P_REFCURSOR     IN OUT PKG_REPORT.REF_CURSOR,
    CUSTODYCD       IN  VARCHAR2,
    AFACCTNO        IN  VARCHAR2,
    F_DATE          IN  VARCHAR2,
    T_DATE          IN  VARCHAR2,
    SYMBOL          IN  VARCHAR2,
    --EXECTYPE      IN  VARCHAR2
    PAGE_RPP        IN  NUMBER,
    ROWS_RPP        IN  NUMBER

)
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

     --plog.error(pkgctx, 'CUSTODYCD: ' || CUSTODYCD || ' AFACCTNO: ' || AFACCTNO || ' SYMBOL ' || SYMBOL || ' EXECTYPE: ' || EXECTYPE);

    IF SYMBOL = 'ALL' OR SYMBOL IS NULL THEN
        V_SYMBOL := '%%';
    ELSE
        V_SYMBOL := SYMBOL||'%';
    END IF;

    IF AFACCTNO = 'ALL' OR AFACCTNO IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := AFACCTNO;
    END IF;
/*
    IF EXECTYPE = 'ALL' OR EXECTYPE IS NULL THEN
        V_EXECTYPE := '%%';
    ELSE
        V_EXECTYPE := EXECTYPE;
    END IF;
*/
    -- LAY THONG TIN MA KHACH HANG
    IF CUSTODYCD = 'ALL' OR CUSTODYCD IS NULL THEN
        V_CUSTID := '%%';
    ELSE
        SELECT CUSTID INTO V_CUSTID FROM CFMAST WHERE CUSTODYCD = V_CUSTODYCD;
    END IF;

    SELECT getcurrdate INTO V_CURRDATE FROM DUAL;

    -- LAY THONG TIN NHAT KY GIAO DICH

IF PAGE_RPP = 0 THEN
    OPEN p_REFCURSOR FOR

        SELECT
            SYMBOL,                     --ma CK
            TXDATE,                     --ngay giao dich
            EXECTYPE,                   --loai giao dich
            EXECTYPE_EN,                --loai giao dich tieng anh
            DCRQTTY,                    --khoi luong tang
            DCRAMT,                     --gia tri tang
            DDROUTQTTY,                 --khoi luong giam
            DDROUTAMT,                  --gia tri giam
            COSTPRICE,                  --gia von binh quan
            SELLAMT,                    --gia tri ban,
            FEEACR,                     --phi
            PROFITANDLOSS               --lai lo


        FROM
        (
            SELECT STS.TXDATE, A1.CDCONTENT EXECTYPE, A1.EN_CDCONTENT EXECTYPE_EN, STS.AFACCTNO, STS.ORDERID, STS.CODEID, STS.SYMBOL,
                CASE WHEN INSTR(sts.EXECTYPE,'B') >0 THEN sts.EXECQTTY ELSE 0 END DCRQTTY,
                CASE WHEN INSTR(sts.EXECTYPE,'B') >0 THEN sts.EXECAMT + STS.FEEACR ELSE 0 END DCRAMT,
                CASE WHEN INSTR(sts.EXECTYPE,'S') >0 THEN sts.EXECQTTY ELSE 0 END DDROUTQTTY,
                CASE WHEN INSTR(sts.EXECTYPE,'S') >0 THEN round(STS.COSTPRICE * sts.EXECQTTY) ELSE 0 END DDROUTAMT,
                CASE WHEN INSTR(sts.EXECTYPE,'S') >0 THEN sts.EXECAMT - STS.FEEACR ELSE 0 END SELLAMT,
                STS.EXECPRICE, STS.FEEACR,
                CASE WHEN INSTR(sts.EXECTYPE,'S') >0 THEN sts.EXECAMT - STS.FEEACR - round(STS.COSTPRICE * sts.EXECQTTY) ELSE 0 END PROFITANDLOSS,
                ROUND(STS.COSTPRICE) COSTPRICE,
                CASE WHEN INSTR(sts.EXECTYPE,'B') >0 THEN 1 ELSE 2 END ODR
            FROM
            (
                SELECT OD.TXDATE, OD.EXECTYPE, OD.AFACCTNO, OD.ORDERID, OD.CODEID, SB.SYMBOL, OD.EXECAMT, OD.EXECQTTY,
                    ROUND(OD.EXECAMT/OD.EXECQTTY,2) EXECPRICE,
                    CASE WHEN OD.EXECAMT >0 AND OD.FEEACR =0 AND OD.STSSTATUS = 'N' THEN OD.EXECAMT*ODT.DEFFEERATE/100 ELSE OD.FEEACR END FEEACR,
                    0 PROFITANDLOSS, NVL(SC.costprice,0) COSTPRICE
                FROM VW_ODMAST_ALL OD, SBSECURITIES SB, AFMAST AF, ODTYPE ODT, SECOSTPRICE SC
                WHERE OD.CODEID = SB.CODEID AND AF.ACCTNO = OD.AFACCTNO
                    AND OD.ORSTATUS IN ('4','5','7','12') AND OD.EXECQTTY>0 AND INSTR(OD.EXECTYPE,'B') >0
                    AND OD.ACTYPE = ODT.ACTYPE
                    AND OD.seacctno = SC.acctno AND OD.txdate = SC.txdate
                    AND od.txdate < V_CURRDATE
                    AND AF.CUSTID LIKE V_CUSTID
                    AND AF.ACCTNO LIKE V_AFACCTNO
                    AND SB.SYMBOL LIKE V_SYMBOL
                    --AND OD.EXECTYPE LIKE V_EXECTYPE
                    AND OD.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                    AND OD.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
                UNION ALL
                SELECT OD.TXDATE, OD.EXECTYPE, OD.AFACCTNO, OD.ORDERID, OD.CODEID, SB.SYMBOL, OD.EXECAMT, OD.EXECQTTY,
                    ROUND(OD.EXECAMT/OD.EXECQTTY,2) EXECPRICE,
                    CASE WHEN OD.EXECAMT >0 AND OD.FEEACR =0 AND OD.STSSTATUS = 'N' THEN OD.EXECAMT*ODT.DEFFEERATE/100 ELSE OD.FEEACR END
                    + CASE WHEN OD.EXECAMT >0 AND OD.STSSTATUS = 'N' THEN OD.EXECAMT*to_number(sys.varvalue)/100 ELSE OD.taxsellamt END FEEACR,
                    (STS.AMT - STS.QTTY * (CASE WHEN STS.TXDATE = V_CURRDATE THEN SE.COSTPRICE ELSE STS.COSTPRICE END)) PROFITANDLOSS,
                    CASE WHEN STS.TXDATE = V_CURRDATE THEN SE.COSTPRICE ELSE STS.COSTPRICE END COSTPRICE
                FROM VW_STSCHD_ALL STS, SBSECURITIES SB, AFMAST AF, SEMAST SE, VW_ODMAST_ALL OD, ODTYPE ODT, SYSVAR SYS
                WHERE OD.CODEID = SB.CODEID AND AF.ACCTNO = OD.AFACCTNO
                    AND OD.ORSTATUS IN ('4','5','7','12') AND OD.EXECQTTY>0 AND INSTR(OD.EXECTYPE,'S') >0
                    AND OD.ACTYPE = ODT.ACTYPE
                    and STS.DUETYPE= 'SS'
                    AND STS.acctno = SE.acctno
                    AND OD.orderid = STS.orgorderid
                    AND SYS.grname = 'SYSTEM' AND SYS.varname = 'ADVSELLDUTY'
                    AND od.txdate < V_CURRDATE
                    AND AF.CUSTID LIKE V_CUSTID
                    AND AF.ACCTNO LIKE V_AFACCTNO
                    AND SB.SYMBOL LIKE V_SYMBOL
                    --AND OD.EXECTYPE LIKE V_EXECTYPE
                    AND OD.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                    AND OD.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
            ) STS, ALLCODE A1
            WHERE A1.CDTYPE = 'OD' AND A1.CDNAME = 'EXECTYPE' AND A1.CDVAL = STS.EXECTYPE
            UNION ALL
            -- Cac GD lam thay doi gia von
            SELECT SE.TXDATE, A2.cdcontent EXECTYPE, A2.EN_CDCONTENT EXECTYPE_EN, SE.AFACCTNO, SE.ORDERID, Sb.CODEID, Sb.SYMBOL, SE.DCRQTTY, SE.DCRAMT,
                SE.DDROUTQTTY, SE.DDROUTAMT, SE.SELLAMT, SE.EXECPRICE, SE.FEEACR, SE.PROFITANDLOSS, --SE.COSTPRICE,
                round(nvl(sc.costprice,0)) COSTPRICE,
                CASE WHEN SE.DCRQTTY > 0 THEN 1 ELSE 2 END ODR
            FROM
            (
            SELECT SE.busdate TXDATE, SE.TLTXCD EXECTYPE, SE.AFACCTNO, TO_CHAR(MAX(SE.autoid)) ORDERID, SE.CODEID, max(sb.codeid) codeid2,
                se.symbol,
                SUM(CASE WHEN SE.field IN ('DCRQTTY') THEN SE.namt ELSE 0 END) DCRQTTY,
                SUM(CASE WHEN SE.field IN ('DCRAMT') THEN SE.namt ELSE 0 END) DCRAMT,
                SUM(CASE WHEN SE.field IN ('DDROUTQTTY') THEN SE.namt ELSE 0 END) DDROUTQTTY,
                0 DDROUTAMT,
                0 FEEACR,
                0 PROFITANDLOSS,
                0 COSTPRICE, 0 SELLAMT, 0 EXECPRICE
            FROM setran_gen SE, (SELECT nvl(sb.refcodeid,sb.codeid) codeid, sb.symbol FROM  sbsecurities sb) sb
            WHERE SE.tltxcd IN ('2201','2242','2266','2245','2246','3380',/*'8879','8848','8849',*/'2222','3384','3386','3324','3326','3314' )
                AND SE.field IN ('DCRQTTY','DDROUTQTTY','DCRAMT','DDROUTAMT')
                AND se.symbol = sb.symbol
                AND SE.CUSTID LIKE V_CUSTID
                AND SE.AFACCTNO LIKE V_AFACCTNO
                AND SE.SYMBOL LIKE V_SYMBOL
                --AND SE.tltxcd LIKE V_EXECTYPE
                AND SE.busdate >= TO_DATE(F_DATE,'DD/MM/YYYY')
                AND SE.busdate <= TO_DATE(T_DATE,'DD/MM/YYYY')
            GROUP BY SE.busdate, SE.TLTXCD, SE.AFACCTNO,SE.CODEID, SE.SYMBOL
            UNION ALL
            SELECT se.TXDATE, SE.EXECTYPE, SE.AFACCTNO, se.ORDERID, SE.CODEID, se.codeid2,
                se.symbol,
                se.DCRQTTY,se.DCRAMT,se.DDROUTQTTY, round(sr.COSTPRICE * se.DDROUTQTTY) DDROUTAMT,
                sr.feeamt+sr.taxamt FEEACR,
                CASE WHEN se.DDROUTQTTY > 0 THEN round(se.DDROUTAMT - sr.feeamt-sr.taxamt - sr.costprice * sr.qtty) ELSE 0 end PROFITANDLOSS,
                round(sr.COSTPRICE) COSTPRICE,
                CASE WHEN se.DDROUTQTTY > 0 THEN se.DDROUTAMT - sr.feeamt-sr.taxamt ELSE 0 END SELLAMT,
                CASE WHEN se.DDROUTQTTY > 0 THEN round(se.DDROUTAMT/se.DDROUTQTTY,2) ELSE 0 END EXECPRICE
            FROM
            (
                SELECT SE.busdate TXDATE, SE.TLTXCD EXECTYPE, SE.AFACCTNO, TO_CHAR(MAX(SE.autoid)) ORDERID, SE.CODEID, max(sb.codeid) codeid2,
                    se.symbol,
                    SUM(CASE WHEN SE.field IN ('DCRQTTY') THEN SE.namt ELSE 0 END) DCRQTTY,
                    SUM(CASE WHEN SE.field IN ('DCRAMT') THEN SE.namt ELSE 0 END) DCRAMT,
                    SUM(CASE WHEN SE.field IN ('DDROUTQTTY') THEN SE.namt ELSE 0 END) DDROUTQTTY,
                    SUM(CASE WHEN SE.field IN ('DDROUTAMT') THEN SE.namt ELSE 0 END) DDROUTAMT,
                    0 FEEACR,
                    0 PROFITANDLOSS,
                    0 COSTPRICE,
                    max(se.acctref) acctref
                FROM setran_gen SE, (SELECT nvl(sb.refcodeid,sb.codeid) codeid, sb.symbol FROM  sbsecurities sb) sb
                WHERE SE.tltxcd ='8879'
                    AND SE.field IN ('DCRQTTY','DDROUTQTTY','DCRAMT','DDROUTAMT')
                    AND se.symbol = sb.symbol
                    AND SE.CUSTID LIKE V_CUSTID
                    AND SE.AFACCTNO LIKE V_AFACCTNO
                    AND SE.SYMBOL LIKE V_SYMBOL
                    --AND SE.tltxcd LIKE V_EXECTYPE
                    AND SE.busdate >= TO_DATE(F_DATE,'DD/MM/YYYY')
                    AND SE.busdate <= TO_DATE(T_DATE,'DD/MM/YYYY')
                GROUP BY SE.busdate, SE.TLTXCD, SE.AFACCTNO,SE.CODEID, SE.SYMBOL
                ) se, seretail sr
                WHERE sr.TXDATE = to_date(substr(se.acctref,1,10),'dd/mm/yyyy') AND sr.txnum = substr(se.acctref,11)
            ) SE, allcode a2, sbsecurities sb, secostprice sc
            WHERE A2.CDTYPE = 'OL' AND A2.CDNAME = 'CPEXECTYPE' AND A2.CDVAL = SE.EXECTYPE
                AND se.codeid2 = sb.codeid
                AND sc.acctno = se.afacctno||se.codeid2
                AND sc.txdate = (SELECT max(txdate) FROM secostprice sc2 WHERE sc2.acctno = sc.acctno AND sc2.txdate <= se.txdate)
        ) STS
        ORDER BY STS.TXDATE, STS.ODR, STS.AFACCTNO, STS.EXECTYPE, STS.SYMBOL
;

ELSE

    OPEN p_REFCURSOR FOR
        SELECT
            '' SYMBOL,                     --ma CK
            NULL TXDATE,                     --ngay giao dich
            '' EXECTYPE,                   --loai giao dich
            '' EXECTYPE_EN,                --loai giao dich tieng anh
            sum(DCRQTTY) DCRQTTY,                    --khoi luong tang
            0 DCRAMT,                     --gia tri tang
            sum(DDROUTQTTY) DDROUTQTTY,                 --khoi luong giam
            0 DDROUTAMT,                  --gia tri giam
            0 COSTPRICE,                  --gia von binh quan
            0 SELLAMT,                    --gia tri ban,
            sum(FEEACR) FEEACR,                     --phi
            sum(PROFITANDLOSS) PROFITANDLOSS,              --lai lo
            0 r

        FROM
        (
            SELECT STS.TXDATE, A1.CDCONTENT EXECTYPE, A1.EN_CDCONTENT EXECTYPE_EN, STS.AFACCTNO, STS.ORDERID, STS.CODEID, STS.SYMBOL,
                CASE WHEN INSTR(sts.EXECTYPE,'B') >0 THEN sts.EXECQTTY ELSE 0 END DCRQTTY,
                CASE WHEN INSTR(sts.EXECTYPE,'B') >0 THEN sts.EXECAMT + STS.FEEACR ELSE 0 END DCRAMT,
                CASE WHEN INSTR(sts.EXECTYPE,'S') >0 THEN sts.EXECQTTY ELSE 0 END DDROUTQTTY,
                CASE WHEN INSTR(sts.EXECTYPE,'S') >0 THEN round(STS.COSTPRICE * sts.EXECQTTY) ELSE 0 END DDROUTAMT,
                CASE WHEN INSTR(sts.EXECTYPE,'S') >0 THEN sts.EXECAMT - STS.FEEACR ELSE 0 END SELLAMT,
                STS.EXECPRICE, STS.FEEACR,
                CASE WHEN INSTR(sts.EXECTYPE,'S') >0 THEN sts.EXECAMT - STS.FEEACR - round(STS.COSTPRICE * sts.EXECQTTY) ELSE 0 END PROFITANDLOSS,
                STS.COSTPRICE,
                CASE WHEN INSTR(sts.EXECTYPE,'B') >0 THEN 1 ELSE 2 END ODR
            FROM
            (
                SELECT OD.TXDATE, OD.EXECTYPE, OD.AFACCTNO, OD.ORDERID, OD.CODEID, SB.SYMBOL, OD.EXECAMT, OD.EXECQTTY,
                    ROUND(OD.EXECAMT/OD.EXECQTTY,2) EXECPRICE,
                    CASE WHEN OD.EXECAMT >0 AND OD.FEEACR =0 AND OD.STSSTATUS = 'N' THEN OD.EXECAMT*ODT.DEFFEERATE/100 ELSE OD.FEEACR END FEEACR,
                    0 PROFITANDLOSS, NVL(SC.costprice,0) COSTPRICE
                FROM VW_ODMAST_ALL OD, SBSECURITIES SB, AFMAST AF, ODTYPE ODT, SECOSTPRICE SC
                WHERE OD.CODEID = SB.CODEID AND AF.ACCTNO = OD.AFACCTNO
                    AND OD.ORSTATUS IN ('4','5','7','12') AND OD.EXECQTTY>0 AND INSTR(OD.EXECTYPE,'B') >0
                    AND OD.ACTYPE = ODT.ACTYPE
                    AND OD.seacctno = SC.acctno AND OD.txdate = SC.txdate
                    AND od.txdate < V_CURRDATE
                    AND AF.CUSTID LIKE V_CUSTID
                    AND AF.ACCTNO LIKE V_AFACCTNO
                    AND SB.SYMBOL LIKE V_SYMBOL
                    --AND OD.EXECTYPE LIKE V_EXECTYPE
                    AND OD.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                    AND OD.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
                UNION ALL
                SELECT OD.TXDATE, OD.EXECTYPE, OD.AFACCTNO, OD.ORDERID, OD.CODEID, SB.SYMBOL, OD.EXECAMT, OD.EXECQTTY,
                    ROUND(OD.EXECAMT/OD.EXECQTTY,2) EXECPRICE,
                    CASE WHEN OD.EXECAMT >0 AND OD.FEEACR =0 AND OD.STSSTATUS = 'N' THEN OD.EXECAMT*ODT.DEFFEERATE/100 ELSE OD.FEEACR END
                    + CASE WHEN OD.EXECAMT >0 AND OD.STSSTATUS = 'N' THEN OD.EXECAMT*to_number(sys.varvalue)/100 ELSE OD.taxsellamt END FEEACR,
                    (STS.AMT - STS.QTTY * (CASE WHEN STS.TXDATE = V_CURRDATE THEN SE.COSTPRICE ELSE STS.COSTPRICE END)) PROFITANDLOSS,
                    CASE WHEN STS.TXDATE = V_CURRDATE THEN SE.COSTPRICE ELSE STS.COSTPRICE END COSTPRICE
                FROM VW_STSCHD_ALL STS, SBSECURITIES SB, AFMAST AF, SEMAST SE, VW_ODMAST_ALL OD, ODTYPE ODT, SYSVAR SYS
                WHERE OD.CODEID = SB.CODEID AND AF.ACCTNO = OD.AFACCTNO
                    AND OD.ORSTATUS IN ('4','5','7','12') AND OD.EXECQTTY>0 AND INSTR(OD.EXECTYPE,'S') >0
                    AND OD.ACTYPE = ODT.ACTYPE
                    and STS.DUETYPE= 'SS'
                    AND STS.acctno = SE.acctno
                    AND OD.orderid = STS.orgorderid
                    AND SYS.grname = 'SYSTEM' AND SYS.varname = 'ADVSELLDUTY'
                    AND od.txdate < V_CURRDATE
                    AND AF.CUSTID LIKE V_CUSTID
                    AND AF.ACCTNO LIKE V_AFACCTNO
                    AND SB.SYMBOL LIKE V_SYMBOL
                    --AND OD.EXECTYPE LIKE V_EXECTYPE
                    AND OD.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                    AND OD.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
            ) STS, ALLCODE A1
            WHERE A1.CDTYPE = 'OD' AND A1.CDNAME = 'EXECTYPE' AND A1.CDVAL = STS.EXECTYPE
            UNION ALL
            -- Cac GD lam thay doi gia von
            SELECT SE.TXDATE, A2.cdcontent EXECTYPE, A2.EN_CDCONTENT EXECTYPE_EN, SE.AFACCTNO, SE.ORDERID, Sb.CODEID, Sb.SYMBOL, SE.DCRQTTY, SE.DCRAMT,
                SE.DDROUTQTTY, SE.DDROUTAMT, SE.SELLAMT, SE.EXECPRICE, SE.FEEACR, SE.PROFITANDLOSS, --SE.COSTPRICE,
                nvl(sc.costprice,0) COSTPRICE,
                CASE WHEN SE.DCRQTTY > 0 THEN 1 ELSE 2 END ODR
            FROM
            (
            SELECT SE.busdate TXDATE, SE.TLTXCD EXECTYPE, SE.AFACCTNO, TO_CHAR(MAX(SE.autoid)) ORDERID, SE.CODEID, max(sb.codeid) codeid2,
                se.symbol,
                SUM(CASE WHEN SE.field IN ('DCRQTTY') THEN SE.namt ELSE 0 END) DCRQTTY,
                SUM(CASE WHEN SE.field IN ('DCRAMT') THEN SE.namt ELSE 0 END) DCRAMT,
                SUM(CASE WHEN SE.field IN ('DDROUTQTTY') THEN SE.namt ELSE 0 END) DDROUTQTTY,
                0 DDROUTAMT,
                0 FEEACR,
                0 PROFITANDLOSS,
                0 COSTPRICE, 0 SELLAMT, 0 EXECPRICE
            FROM setran_gen SE, (SELECT nvl(sb.refcodeid,sb.codeid) codeid, sb.symbol FROM  sbsecurities sb) sb
            WHERE SE.tltxcd IN ('2201','2242','2266','2245','2246','3380',/*'8879','8848','8849',*/'2222','3384','3386','3324','3326','3314' )
                AND SE.field IN ('DCRQTTY','DDROUTQTTY','DCRAMT','DDROUTAMT')
                AND se.symbol = sb.symbol
                AND SE.CUSTID LIKE V_CUSTID
                AND SE.AFACCTNO LIKE V_AFACCTNO
                AND SE.SYMBOL LIKE V_SYMBOL
                --AND SE.tltxcd LIKE V_EXECTYPE
                AND SE.busdate >= TO_DATE(F_DATE,'DD/MM/YYYY')
                AND SE.busdate <= TO_DATE(T_DATE,'DD/MM/YYYY')
            GROUP BY SE.busdate, SE.TLTXCD, SE.AFACCTNO,SE.CODEID, SE.SYMBOL
            UNION ALL
            SELECT se.TXDATE, SE.EXECTYPE, SE.AFACCTNO, se.ORDERID, SE.CODEID, se.codeid2,
                se.symbol,
                se.DCRQTTY,se.DCRAMT,se.DDROUTQTTY, round(sr.COSTPRICE * se.DDROUTQTTY) DDROUTAMT,
                sr.feeamt+sr.taxamt FEEACR,
                CASE WHEN se.DDROUTQTTY > 0 THEN round(se.DDROUTAMT - sr.feeamt-sr.taxamt - sr.costprice * sr.qtty) ELSE 0 end PROFITANDLOSS,
                sr.COSTPRICE,
                CASE WHEN se.DDROUTQTTY > 0 THEN se.DDROUTAMT - sr.feeamt-sr.taxamt ELSE 0 END SELLAMT,
                CASE WHEN se.DDROUTQTTY > 0 THEN round(se.DDROUTAMT/se.DDROUTQTTY,2) ELSE 0 END EXECPRICE
            FROM
            (
                SELECT SE.busdate TXDATE, SE.TLTXCD EXECTYPE, SE.AFACCTNO, TO_CHAR(MAX(SE.autoid)) ORDERID, SE.CODEID, max(sb.codeid) codeid2,
                    se.symbol,
                    SUM(CASE WHEN SE.field IN ('DCRQTTY') THEN SE.namt ELSE 0 END) DCRQTTY,
                    SUM(CASE WHEN SE.field IN ('DCRAMT') THEN SE.namt ELSE 0 END) DCRAMT,
                    SUM(CASE WHEN SE.field IN ('DDROUTQTTY') THEN SE.namt ELSE 0 END) DDROUTQTTY,
                    SUM(CASE WHEN SE.field IN ('DDROUTAMT') THEN SE.namt ELSE 0 END) DDROUTAMT,
                    0 FEEACR,
                    0 PROFITANDLOSS,
                    0 COSTPRICE,
                    max(se.acctref) acctref
                FROM setran_gen SE, (SELECT nvl(sb.refcodeid,sb.codeid) codeid, sb.symbol FROM  sbsecurities sb) sb
                WHERE SE.tltxcd ='8879'
                    AND SE.field IN ('DCRQTTY','DDROUTQTTY','DCRAMT','DDROUTAMT')
                    AND se.symbol = sb.symbol
                    AND SE.CUSTID LIKE V_CUSTID
                    AND SE.AFACCTNO LIKE V_AFACCTNO
                    AND SE.SYMBOL LIKE V_SYMBOL
                    --AND SE.tltxcd LIKE V_EXECTYPE
                    AND SE.busdate >= TO_DATE(F_DATE,'DD/MM/YYYY')
                    AND SE.busdate <= TO_DATE(T_DATE,'DD/MM/YYYY')
                GROUP BY SE.busdate, SE.TLTXCD, SE.AFACCTNO,SE.CODEID, SE.SYMBOL
                ) se, seretail sr
                WHERE sr.TXDATE = to_date(substr(se.acctref,1,10),'dd/mm/yyyy') AND sr.txnum = substr(se.acctref,11)
            ) SE, allcode a2, sbsecurities sb, secostprice sc
            WHERE A2.CDTYPE = 'OL' AND A2.CDNAME = 'CPEXECTYPE' AND A2.CDVAL = SE.EXECTYPE
                AND se.codeid2 = sb.codeid
                AND sc.acctno = se.afacctno||se.codeid2
                AND sc.txdate = (SELECT max(txdate) FROM secostprice sc2 WHERE sc2.acctno = sc.acctno AND sc2.txdate <= se.txdate)
        ) STS
        --ORDER BY STS.TXDATE, STS.ODR, STS.AFACCTNO, STS.EXECTYPE, STS.SYMBOL

UNION ALL
select *
from
(
    select a.*, rownum r
    from
    (
        SELECT
            SYMBOL,                     --ma CK
            TXDATE,                     --ngay giao dich
            EXECTYPE,                   --loai giao dich
            EXECTYPE_EN,                --loai giao dich tieng anh
            DCRQTTY,                    --khoi luong tang
            DCRAMT,                     --gia tri tang
            DDROUTQTTY,                 --khoi luong giam
            DDROUTAMT,                  --gia tri giam
            COSTPRICE,                  --gia von binh quan
            SELLAMT,                    --gia tri ban,
            FEEACR,                     --phi
            PROFITANDLOSS

        FROM
        (
            SELECT STS.TXDATE, A1.CDCONTENT EXECTYPE, A1.EN_CDCONTENT EXECTYPE_EN, STS.AFACCTNO, STS.ORDERID, STS.CODEID, STS.SYMBOL,
                CASE WHEN INSTR(sts.EXECTYPE,'B') >0 THEN sts.EXECQTTY ELSE 0 END DCRQTTY,
                CASE WHEN INSTR(sts.EXECTYPE,'B') >0 THEN sts.EXECAMT + STS.FEEACR ELSE 0 END DCRAMT,
                CASE WHEN INSTR(sts.EXECTYPE,'S') >0 THEN sts.EXECQTTY ELSE 0 END DDROUTQTTY,
                CASE WHEN INSTR(sts.EXECTYPE,'S') >0 THEN round(STS.COSTPRICE * sts.EXECQTTY) ELSE 0 END DDROUTAMT,
                CASE WHEN INSTR(sts.EXECTYPE,'S') >0 THEN sts.EXECAMT - STS.FEEACR ELSE 0 END SELLAMT,
                STS.EXECPRICE, STS.FEEACR,
                CASE WHEN INSTR(sts.EXECTYPE,'S') >0 THEN sts.EXECAMT - STS.FEEACR - round(STS.COSTPRICE * sts.EXECQTTY) ELSE 0 END PROFITANDLOSS,
                ROUND(STS.COSTPRICE) COSTPRICE,
                CASE WHEN INSTR(sts.EXECTYPE,'B') >0 THEN 1 ELSE 2 END ODR
            FROM
            (
                SELECT OD.TXDATE, OD.EXECTYPE, OD.AFACCTNO, OD.ORDERID, OD.CODEID, SB.SYMBOL, OD.EXECAMT, OD.EXECQTTY,
                    ROUND(OD.EXECAMT/OD.EXECQTTY,2) EXECPRICE,
                    CASE WHEN OD.EXECAMT >0 AND OD.FEEACR =0 AND OD.STSSTATUS = 'N' THEN OD.EXECAMT*ODT.DEFFEERATE/100 ELSE OD.FEEACR END FEEACR,
                    0 PROFITANDLOSS, NVL(SC.costprice,0) COSTPRICE
                FROM VW_ODMAST_ALL OD, SBSECURITIES SB, AFMAST AF, ODTYPE ODT, SECOSTPRICE SC
                WHERE OD.CODEID = SB.CODEID AND AF.ACCTNO = OD.AFACCTNO
                    AND OD.ORSTATUS IN ('4','5','7','12') AND OD.EXECQTTY>0 AND INSTR(OD.EXECTYPE,'B') >0
                    AND OD.ACTYPE = ODT.ACTYPE
                    AND OD.seacctno = SC.acctno AND OD.txdate = SC.txdate
                    AND od.txdate < V_CURRDATE
                    AND AF.CUSTID LIKE V_CUSTID
                    AND AF.ACCTNO LIKE V_AFACCTNO
                    AND SB.SYMBOL LIKE V_SYMBOL
                    --AND OD.EXECTYPE LIKE V_EXECTYPE
                    AND OD.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                    AND OD.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
                UNION ALL
                SELECT OD.TXDATE, OD.EXECTYPE, OD.AFACCTNO, OD.ORDERID, OD.CODEID, SB.SYMBOL, OD.EXECAMT, OD.EXECQTTY,
                    ROUND(OD.EXECAMT/OD.EXECQTTY,2) EXECPRICE,
                    CASE WHEN OD.EXECAMT >0 AND OD.FEEACR =0 AND OD.STSSTATUS = 'N' THEN OD.EXECAMT*ODT.DEFFEERATE/100 ELSE OD.FEEACR END
                    + CASE WHEN OD.EXECAMT >0 AND OD.STSSTATUS = 'N' THEN OD.EXECAMT*to_number(sys.varvalue)/100 ELSE OD.taxsellamt END FEEACR,
                    (STS.AMT - STS.QTTY * (CASE WHEN STS.TXDATE = V_CURRDATE THEN SE.COSTPRICE ELSE STS.COSTPRICE END)) PROFITANDLOSS,
                    CASE WHEN STS.TXDATE = V_CURRDATE THEN SE.COSTPRICE ELSE STS.COSTPRICE END COSTPRICE
                FROM VW_STSCHD_ALL STS, SBSECURITIES SB, AFMAST AF, SEMAST SE, VW_ODMAST_ALL OD, ODTYPE ODT, SYSVAR SYS
                WHERE OD.CODEID = SB.CODEID AND AF.ACCTNO = OD.AFACCTNO
                    AND OD.ORSTATUS IN ('4','5','7','12') AND OD.EXECQTTY>0 AND INSTR(OD.EXECTYPE,'S') >0
                    AND OD.ACTYPE = ODT.ACTYPE
                    and STS.DUETYPE= 'SS'
                    AND STS.acctno = SE.acctno
                    AND OD.orderid = STS.orgorderid
                    AND SYS.grname = 'SYSTEM' AND SYS.varname = 'ADVSELLDUTY'
                    AND od.txdate < V_CURRDATE
                    AND AF.CUSTID LIKE V_CUSTID
                    AND AF.ACCTNO LIKE V_AFACCTNO
                    AND SB.SYMBOL LIKE V_SYMBOL
                    --AND OD.EXECTYPE LIKE V_EXECTYPE
                    AND OD.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY')
                    AND OD.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')
            ) STS, ALLCODE A1
            WHERE A1.CDTYPE = 'OD' AND A1.CDNAME = 'EXECTYPE' AND A1.CDVAL = STS.EXECTYPE
            UNION ALL
            -- Cac GD lam thay doi gia von
            SELECT SE.TXDATE, A2.cdcontent EXECTYPE, A2.EN_CDCONTENT EXECTYPE_EN, SE.AFACCTNO, SE.ORDERID, Sb.CODEID, Sb.SYMBOL, SE.DCRQTTY, SE.DCRAMT,
                SE.DDROUTQTTY, SE.DDROUTAMT, SE.SELLAMT, SE.EXECPRICE, SE.FEEACR, SE.PROFITANDLOSS, --SE.COSTPRICE,
                round(nvl(sc.costprice,0)) COSTPRICE,
                CASE WHEN SE.DCRQTTY > 0 THEN 1 ELSE 2 END ODR
            FROM
            (
            SELECT SE.busdate TXDATE, SE.TLTXCD EXECTYPE, SE.AFACCTNO, TO_CHAR(MAX(SE.autoid)) ORDERID, SE.CODEID, max(sb.codeid) codeid2,
                se.symbol,
                SUM(CASE WHEN SE.field IN ('DCRQTTY') THEN SE.namt ELSE 0 END) DCRQTTY,
                SUM(CASE WHEN SE.field IN ('DCRAMT') THEN SE.namt ELSE 0 END) DCRAMT,
                SUM(CASE WHEN SE.field IN ('DDROUTQTTY') THEN SE.namt ELSE 0 END) DDROUTQTTY,
                0 DDROUTAMT,
                0 FEEACR,
                0 PROFITANDLOSS,
                0 COSTPRICE, 0 SELLAMT, 0 EXECPRICE
            FROM setran_gen SE, (SELECT nvl(sb.refcodeid,sb.codeid) codeid, sb.symbol FROM  sbsecurities sb) sb
            WHERE SE.tltxcd IN ('2201','2242','2266','2245','2246','3380',/*'8879','8848','8849',*/'2222','3384','3386','3324','3326','3314' )
                AND SE.field IN ('DCRQTTY','DDROUTQTTY','DCRAMT','DDROUTAMT')
                AND se.symbol = sb.symbol
                AND SE.CUSTID LIKE V_CUSTID
                AND SE.AFACCTNO LIKE V_AFACCTNO
                AND SE.SYMBOL LIKE V_SYMBOL
                --AND SE.tltxcd LIKE V_EXECTYPE
                AND SE.busdate >= TO_DATE(F_DATE,'DD/MM/YYYY')
                AND SE.busdate <= TO_DATE(T_DATE,'DD/MM/YYYY')
            GROUP BY SE.busdate, SE.TLTXCD, SE.AFACCTNO,SE.CODEID, SE.SYMBOL
            UNION ALL
            SELECT se.TXDATE, SE.EXECTYPE, SE.AFACCTNO, se.ORDERID, SE.CODEID, se.codeid2,
                se.symbol,
                se.DCRQTTY,se.DCRAMT,se.DDROUTQTTY, round(sr.COSTPRICE * se.DDROUTQTTY) DDROUTAMT,
                sr.feeamt+sr.taxamt FEEACR,
                CASE WHEN se.DDROUTQTTY > 0 THEN round(se.DDROUTAMT - sr.feeamt-sr.taxamt - sr.costprice * sr.qtty) ELSE 0 end PROFITANDLOSS,
                round(sr.COSTPRICE) COSTPRICE,
                CASE WHEN se.DDROUTQTTY > 0 THEN se.DDROUTAMT - sr.feeamt-sr.taxamt ELSE 0 END SELLAMT,
                CASE WHEN se.DDROUTQTTY > 0 THEN round(se.DDROUTAMT/se.DDROUTQTTY,2) ELSE 0 END EXECPRICE
            FROM
            (
                SELECT SE.busdate TXDATE, SE.TLTXCD EXECTYPE, SE.AFACCTNO, TO_CHAR(MAX(SE.autoid)) ORDERID, SE.CODEID, max(sb.codeid) codeid2,
                    se.symbol,
                    SUM(CASE WHEN SE.field IN ('DCRQTTY') THEN SE.namt ELSE 0 END) DCRQTTY,
                    SUM(CASE WHEN SE.field IN ('DCRAMT') THEN SE.namt ELSE 0 END) DCRAMT,
                    SUM(CASE WHEN SE.field IN ('DDROUTQTTY') THEN SE.namt ELSE 0 END) DDROUTQTTY,
                    SUM(CASE WHEN SE.field IN ('DDROUTAMT') THEN SE.namt ELSE 0 END) DDROUTAMT,
                    0 FEEACR,
                    0 PROFITANDLOSS,
                    0 COSTPRICE,
                    max(se.acctref) acctref
                FROM setran_gen SE, (SELECT nvl(sb.refcodeid,sb.codeid) codeid, sb.symbol FROM  sbsecurities sb) sb
                WHERE SE.tltxcd ='8879'
                    AND SE.field IN ('DCRQTTY','DDROUTQTTY','DCRAMT','DDROUTAMT')
                    AND se.symbol = sb.symbol
                    AND SE.CUSTID LIKE V_CUSTID
                    AND SE.AFACCTNO LIKE V_AFACCTNO
                    AND SE.SYMBOL LIKE V_SYMBOL
                    --AND SE.tltxcd LIKE V_EXECTYPE
                    AND SE.busdate >= TO_DATE(F_DATE,'DD/MM/YYYY')
                    AND SE.busdate <= TO_DATE(T_DATE,'DD/MM/YYYY')
                GROUP BY SE.busdate, SE.TLTXCD, SE.AFACCTNO,SE.CODEID, SE.SYMBOL
                ) se, seretail sr
                WHERE sr.TXDATE = to_date(substr(se.acctref,1,10),'dd/mm/yyyy') AND sr.txnum = substr(se.acctref,11)
            ) SE, allcode a2, sbsecurities sb, secostprice sc
            WHERE A2.CDTYPE = 'OL' AND A2.CDNAME = 'CPEXECTYPE' AND A2.CDVAL = SE.EXECTYPE
                AND se.codeid2 = sb.codeid
                AND sc.acctno = se.afacctno||se.codeid2
                AND sc.txdate = (SELECT max(txdate) FROM secostprice sc2 WHERE sc2.acctno = sc.acctno AND sc2.txdate <= se.txdate)
        ) STS
        ORDER BY STS.TXDATE, STS.ODR, STS.AFACCTNO, STS.EXECTYPE, STS.SYMBOL

    ) a
    where rownum <= ROWS_RPP * PAGE_RPP
)
 where r > ROWS_RPP * (PAGE_RPP - 1);
END IF;


EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GetTradeDiary');
END pr_GetTradeDiary;



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

BEGIN

    IF AFACCTNO = 'ALL' OR AFACCTNO IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := AFACCTNO;
    END IF;

    OPEN p_REFCURSOR FOR

    SELECT  ci.ACCTNO
        , ci.balance - nvl(b.secureamt,0) - nvl(b.advamt,0)-- tien_mat
            + nvl(avl.maxavlamt,0) --tien_ung_truoc
            + nvl(buf.RECEIVING,0) - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 --  buf.CASH_RECEIVING_T2  -- receiving_right
          MoneyTotal    --Tong tien
        , round(decode(nvl(tax_ct.namt,0)  + nvl(preal.phi_thue_mua_ban,0),0,0
                    ,(nvl(ptemp.profitandloss,0) + nvl(preal.lai_lo_thuc,0)) / (nvl(tax_ct.namt,0) +  nvl(preal.phi_thue_mua_ban,0)) * 100
                ),2) DefIntPer
        , nvl(ptemp.marketamt,0) AssetNetTotal -- GTTT
        , ci.balance - nvl(b.secureamt,0) - nvl(b.advamt,0)-- tien_mat
            + nvl(avl.maxavlamt,0) --tien_ung_truoc
            + nvl(buf.RECEIVING,0) - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 --  buf.CASH_RECEIVING_T2
            + nvl(ptemp.marketamt,0)  AssetTotal --tong tai san
        , nvl(ln.lnamt,0) lnamt
        , nvl(fnc_get_NAV(ci.acctno),0) NAV
        , round(nvl(tax_ct.namt,0) -- thue ban co tuc
            + nvl(tranfer_amt,0) + nvl(preal.phi_thue_mua_ban,0),0) FeeDutyTotal  --tong phi thue
        , nvl(depofee.depofeeamt,0) depofeeamt
        , round(nvl(intamt_cr,0)) intamt_cr    --lai tien gui
        , nvl(ptemp.profitandloss,0) DefIntInDay--lai/lo tam tinh
        , nvl(preal.lai_lo_thuc,0) DefIntInTime --lai/lo thuc
        , nvl(ptemp.profitandloss,0) + nvl(preal.lai_lo_thuc,0) DefIntTotal  --Tong lai/lo
        , round(nvl(iused.feeamt,0) --Lai ung truoc da su dung
            + nvl(ipast.fee_mov,0) --lai margin + BL da thu
            + nvl(ipre.INTNML,0),0) --lai margin + BL ht
        IntPayTotal --tong lai phai tra
    FROM cimast ci, v_getAccountAvlAdvance aaa , v_getbuyorderinfo b, v_getdealpaidbyaccount pd, buf_ci_account buf,
    (
        SELECT trfacctno, round(sum(t0amt+marginamt),0) lnamt FROM vw_lngroup_all GROUP BY trfacctno
    ) ln,
    (
        SELECT substr(acctno,1,10) afacctno, round(sum(amt)) depofeeamt FROM sedepobal WHERE substr(acctno,1,10) LIKE V_AFACCTNO
        AND txdate BETWEEN to_date(F_DATE,'DD/MM/RRRR') and to_date(T_DATE,'DD/MM/RRRR')
        GROUP BY substr(acctno,1,10)
    ) depofee,
    (
        SELECT acctno afacctno, sum(intamt) intamt_cr FROM ciinttran WHERE acctno LIKE V_AFACCTNO
        AND todate BETWEEN to_date(F_DATE,'DD/MM/RRRR') and to_date(T_DATE,'DD/MM/RRRR')
        GROUP BY acctno
    ) cr,
    (
        SELECT acctno afacctno, sum(namt) tranfer_amt FROM vw_citran_gen WHERE acctno LIKE V_AFACCTNO
        AND txcd = '0028' AND tltxcd = '1101' AND txdate BETWEEN to_date(F_DATE,'DD/MM/RRRR') and to_date(T_DATE,'DD/MM/RRRR')
        GROUP BY acctno
    ) tr,
    (
        SELECT  VW.ACCTNO, sum(VW.MAXAVLAMT) MAXAVLAMT,
            sum((CASE WHEN VW.TXDATE =TO_DATE(SYS.VARVALUE,'DD/MM/RRRR') AND ISVSD='N' THEN fn_getdealgrppaid(VW.ACCTNO) ELSE 0 END)/
            (1-ADT.ADVRATE/100/360*VW.days)) DEALPAID
        FROM VW_ADVANCESCHEDULE VW, SYSVAR SYS,AFMAST AF, AFTYPE AFT ,ADTYPE ADT
        WHERE SYS.GRNAME='SYSTEM' AND SYS.VARNAME ='CURRDATE'
            AND VW.ACCTNO = AF.ACCTNO AND AF.ACTYPE=AFT.ACTYPE AND AFT.ADTYPE=ADT.ACTYPE
            and af.acctno like '%'
        group by VW.ACCTNO
     ) avl,
     --thue co tuc
    (   select ci.acctno, sum(case when ci.txdate <> getcurrdate and ci.tltxcd = '0066' then  ci.namt
                                when ci.tltxcd <> '0066' then ci.namt
                                else 0
                         end) namt from vw_citran_gen ci where tltxcd in ('3350','0066'/*,'1182'*/) --1182: phi luu ky hang thang
                         and txcd in ('0011','0028') and ci.acctno like V_AFACCTNO and ci.deltd <> 'Y'
        and ci.txdate BETWEEN to_date (F_DATE,'dd/mm/yyyy') and to_date (T_DATE,'dd/mm/yyyy')
        group by ci.acctno
    ) tax_ct,
    --lai lo tam tinh
    (
        select se.acctno, sum((basicprice - costprice) * (trade /*+ ca_sec*/ + receiving+secured)) profitandloss --lai/lo tam tinh
            ,sum(basicprice * (trade + receiving + secured /*+ ca_sec*/))  MARKETAMT --GTTT
        from
            (
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
                    (
                        SELECT TO_NUMBER( closeprice) closeprice,symbol from stockinfor WHERE tradingdate = to_char(getcurrdate ,'dd/mm/yyyy')
                    ) stif ON SDTL.symbol = stif.symbol
                left join
                    (
                        select seacctno, sum(decode(o.exectype , 'NB', o.remainqtty, 0)) B_remainqtty, sum(o.remainqtty) remainqtty, sum(decode(o.exectype , 'NB',  o.execamt ,0 )) B_execamt
                            , sum(decode(o.exectype , 'NB',  o.execqtty ,0 )) B_execqtty, SUM(CASE WHEN o.stsstatus <> 'C' THEN (decode(o.exectype , 'NB',  o.execqtty ,0 )) ELSE 0 END)  B_execqtty_new
                        from odmast o
                        where deltd <>'Y' and o.exectype in('NS','NB','MS')
                            and o.txdate =(select to_date(VARVALUE,'DD/MM/YYYY') from sysvar where grname='SYSTEM' and varname='CURRDATE')
                            and o.afacctno like V_AFACCTNO
                        group by seacctno
                    ) OD on sdtl.acctno = od.seacctno
                left join
                    (
                        select afacctno, refcodeid, trade + receiving - SECURITIES_RECEIVING_T1 - SECURITIES_RECEIVING_T2 wft_receiving
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
    ) ptemp,--end lai/lo tam tinh
    --lai/lo thuc
    (
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
                END

                -
                --THUE
                CASE WHEN AFT.VAT = 'Y'
                        THEN CASE WHEN OD.EXECAMT >0 AND OD.STSSTATUS = 'N' THEN (select to_number(varvalue) from sysvar where varname = 'ADVSELLDUTY' and grname = 'SYSTEM')
                    * STS.AMT /100 ELSE OD.taxsellamt END
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
        and acctno like V_AFACCTNO group by acctno
    ) Iused,
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
    and ci.acctno = ln.trfacctno(+)
    and ci.acctno = depofee.afacctno(+)
    and ci.acctno = cr.afacctno(+)
    and ci.acctno = tr.afacctno(+)


    ;

EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GetTotalInvesment');
END pr_GetTotalInvesment;

PROCEDURE pr_GetTotalInvesment_PB
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
    v_roomid VARCHAR2(30);
    v_debt  NUMBER;
    v_ordamt    NUMBER;
    v_balance   NUMBER;
    v_td        NUMBER;
    v_bod_adv   NUMBER;
    v_cal_adv   NUMBER;
    v_ta_noroom NUMBER;
    v_total_debt    NUMBER(30,2);
    v_mrrate    NUMBER(20,2);
    v_MoneyTotal    NUMBER;

BEGIN

    IF AFACCTNO = 'ALL' OR AFACCTNO IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := AFACCTNO;
    END IF;

    v_ordamt := CSPKS_FO_COMMON.fn_get_buy_amt@DBL_FO(V_AFACCTNO);

    -- Get account information
    SELECT  BOD_BALANCE, BOD_TD, BOD_DEBT, BOD_ADV, ROOMID, CALC_ADVBAL,
        NVL(FO_ACCT.BOD_BALANCE,0) - v_ordamt +  NVL(FO_ACCT.CALC_ADVBAL,0) + NVL(FO_ACCT.bod_adv,0) - NVL(BOD_DEBT_M,0)
    INTO v_balance, v_td, v_debt, v_bod_adv, v_roomid, v_cal_adv, v_MoneyTotal
    FROM ACCOUNTS@DBL_FO FO_ACCT
    WHERE ACCTNO = V_AFACCTNO;

    --lay p_mrrate

    v_ta_noroom := CSPKS_FO_COMMON.fn_get_ta_real_ub@DBL_FO(V_AFACCTNO,'N','Y',v_roomid);

    v_total_debt :=v_debt + v_ordamt - v_balance - v_bod_adv - v_cal_adv;

    IF v_total_debt <=0 THEN --Tai khoan khong co no.
        v_mrrate:=10000;
    ELSE
        v_mrrate := (v_td + v_ta_noroom) / (v_total_debt) * 100;
    END IF;

    v_mrrate := trunc(v_mrrate,2);

    OPEN p_REFCURSOR FOR

    SELECT  ci.ACCTNO
        , ci.balance - nvl(b.secureamt,0) - nvl(b.advamt,0)-- tien_mat
            + nvl(avl.maxavlamt,0) --tien_ung_truoc
            + nvl(buf.RECEIVING,0) - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 --  buf.CASH_RECEIVING_T2  -- receiving_right
          MoneyTotal1    --Tong tien
        , v_MoneyTotal MoneyTotal
        --, nvl(buf.RECEIVING,0) - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1   receiving_right --tien co tuc cho ve
        , nvl(buf.CARECEIVING,0) receiving_right
        , ROUND(least(buf.avlwithdraw,fn_getfowithdraw(ci.acctno))) avlwithdraw     --tien co the rut
        --, round(decode(nvl(tax_ct.namt,0)  + nvl(preal.phi_thue_mua_ban,0),0,0
        --            ,(nvl(ptemp.profitandloss,0) + nvl(preal.lai_lo_thuc,0)) / (nvl(tax_ct.namt,0) +  nvl(preal.phi_thue_mua_ban,0)) * 100
        --        ),2) DefIntPer
        , nvl(ptemp.marketamt,0) AssetNetTotal -- GTTT
        , ci.balance - nvl(b.secureamt,0) - nvl(b.advamt,0)-- tien_mat
            + nvl(avl.maxavlamt,0) --tien_ung_truoc
            + nvl(buf.RECEIVING,0) - buf.CASH_RECEIVING_T0 - buf.CASH_RECEIVING_T1 --  buf.CASH_RECEIVING_T2
            + nvl(ptemp.marketamt,0)  AssetTotal --tong tai san
        , nvl(ln.lnamt,0) lnamt
        , nvl(fnc_get_NAV(ci.acctno),0) NAV
        , buf.MARGINRATE rtt1
        , v_mrrate rtt
        --, round(nvl(tax_ct.namt,0) -- thue ban co tuc
        --    + nvl(tranfer_amt,0) + nvl(preal.phi_thue_mua_ban,0),0) FeeDutyTotal  --tong phi thue
        --, nvl(depofee.depofeeamt,0) depofeeamt
        --, round(nvl(intamt_cr,0)) intamt_cr    --lai tien gui
        --, nvl(ptemp.profitandloss,0) DefIntInDay--lai/lo tam tinh
        --, nvl(preal.lai_lo_thuc,0) DefIntInTime --lai/lo thuc
        --, nvl(ptemp.profitandloss,0) + nvl(preal.lai_lo_thuc,0) DefIntTotal  --Tong lai/lo
        --, round(nvl(iused.feeamt,0) --Lai ung truoc da su dung
        --    + nvl(ipast.fee_mov,0) --lai margin + BL da thu
        --    + nvl(ipre.INTNML,0),0) --lai margin + BL ht
        --IntPayTotal --tong lai phai tra
    FROM cimast ci, v_getAccountAvlAdvance aaa , v_getbuyorderinfo b, v_getdealpaidbyaccount pd, buf_ci_account buf,
    (
        SELECT trfacctno, round(sum(t0amt+marginamt),0) lnamt FROM vw_lngroup_all GROUP BY trfacctno
    ) ln,
    (
        SELECT  VW.ACCTNO, sum(VW.MAXAVLAMT) MAXAVLAMT,
            sum((CASE WHEN VW.TXDATE =TO_DATE(SYS.VARVALUE,'DD/MM/RRRR') AND ISVSD='N' THEN fn_getdealgrppaid(VW.ACCTNO) ELSE 0 END)/
            (1-ADT.ADVRATE/100/360*VW.days)) DEALPAID
        FROM VW_ADVANCESCHEDULE VW, SYSVAR SYS,AFMAST AF, AFTYPE AFT ,ADTYPE ADT
        WHERE SYS.GRNAME='SYSTEM' AND SYS.VARNAME ='CURRDATE'
            AND VW.ACCTNO = AF.ACCTNO AND AF.ACTYPE=AFT.ACTYPE AND AFT.ADTYPE=ADT.ACTYPE
            and af.acctno like '%'
        group by VW.ACCTNO
     ) avl,

    --lai lo tam tinh
    (
        select se.acctno, sum((basicprice - costprice) * (trade /*+ ca_sec*/ + receiving+secured)) profitandloss --lai/lo tam tinh
            ,sum(basicprice * (trade + receiving + secured /*+ ca_sec*/))  MARKETAMT --GTTT
        from
            (
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
                    (
                        SELECT TO_NUMBER( closeprice) closeprice,symbol from stockinfor WHERE tradingdate = to_char(getcurrdate ,'dd/mm/yyyy')
                    ) stif ON SDTL.symbol = stif.symbol
                left join
                    (
                        select seacctno, sum(decode(o.exectype , 'NB', o.remainqtty, 0)) B_remainqtty, sum(o.remainqtty) remainqtty, sum(decode(o.exectype , 'NB',  o.execamt ,0 )) B_execamt
                            , sum(decode(o.exectype , 'NB',  o.execqtty ,0 )) B_execqtty, SUM(CASE WHEN o.stsstatus <> 'C' THEN (decode(o.exectype , 'NB',  o.execqtty ,0 )) ELSE 0 END)  B_execqtty_new
                        from odmast o
                        where deltd <>'Y' and o.exectype in('NS','NB','MS')
                            and o.txdate =(select to_date(VARVALUE,'DD/MM/YYYY') from sysvar where grname='SYSTEM' and varname='CURRDATE')
                            and o.afacctno like V_AFACCTNO
                        group by seacctno
                    ) OD on sdtl.acctno = od.seacctno
                left join
                    (
                        select afacctno, refcodeid, trade + receiving - SECURITIES_RECEIVING_T1 - SECURITIES_RECEIVING_T2 wft_receiving
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
    ) ptemp     --end lai/lo tam tinh

WHERE  ci.acctno like V_AFACCTNO
    and ci.acctno = avl.acctno(+)
    and ci.acctno = aaa.afacctno(+)
    and ci.acctno = buf.afacctno (+)
    and ci.acctno = b.afacctno (+)
    and ci.acctno = pd.afacctno (+)
    and ci.acctno = ptemp.acctno(+)
    and ci.acctno = ln.trfacctno(+)

    ;

EXCEPTION
  WHEN OTHERS THEN
    plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_GetTotalInvesment_PB');
END pr_GetTotalInvesment_PB;


PROCEDURE pr_ResetPin(p_custodycd VARCHAR2,
                      p_newpin       VARCHAR2,
                      p_err_code  OUT varchar2,
                      p_err_message out varchar2)
  IS
      l_txmsg               tx.msg_rectype;
      l_custid varchar2(10);
      v_strCURRDATE   DATE;
      l_pin           VARCHAR2(50);
      l_err_param varchar2(300);
      l_fullname VARCHAR2(500);
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_ResetPin');

    -- Check host & branch active or inactive
    p_err_code := fn_CheckActiveSystem;
    IF p_err_code <> systemnums.C_SUCCESS THEN
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.error(pkgctx, 'Error:'  || p_err_message);
        plog.setendsection(pkgctx, 'pr_ResetPin');
        return;
    END IF;
    -- End: Check host & branch active or inactive

       -- Lay thong tin khach hang
    SELECT cf.custid,cf.pin, cf.fullname
    INTO l_custid, l_pin, l_fullname
    FROM CFMAST CF
    WHERE CF.Custodycd = p_custodycd;


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
    l_txmsg.tltxcd:='0047';

    --Set txnum
    SELECT systemnums.C_OL_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO l_txmsg.txnum
              FROM DUAL;
    l_txmsg.brid        := substr(l_custid,1,4);

--CUSTODYCD
l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
l_txmsg.txfields ('88').TYPE   := 'C';
l_txmsg.txfields ('88').VALUE   := p_custodycd;
--CUSTID
l_txmsg.txfields ('04').defname   := 'CUSTID';
l_txmsg.txfields ('04').TYPE   := 'C';
l_txmsg.txfields ('04').VALUE   := l_custid;
--DESC
l_txmsg.txfields ('30').defname   := 'DESC';
l_txmsg.txfields ('30').TYPE   := 'C';
l_txmsg.txfields ('30').VALUE   := 'Thay doi mat khau giao dich qua dien thoai';
--RPIN
l_txmsg.txfields ('59').defname   := 'RPIN';
l_txmsg.txfields ('59').TYPE   := 'C';
l_txmsg.txfields ('59').VALUE   := l_pin;
--PIN
l_txmsg.txfields ('60').defname   := 'PIN';
l_txmsg.txfields ('60').TYPE   := 'P';
l_txmsg.txfields ('60').VALUE   := p_newpin;
--CONFIRMPIN
l_txmsg.txfields ('61').defname   := 'CONFIRMPIN';
l_txmsg.txfields ('61').TYPE   := 'P';
l_txmsg.txfields ('61').VALUE   := p_newpin;
--FULLNAME
l_txmsg.txfields ('90').defname   := 'FULLNAME';
l_txmsg.txfields ('90').TYPE   := 'C';
l_txmsg.txfields ('90').VALUE   := l_fullname;

    BEGIN
        IF txpks_#0047.fn_autotxprocess (l_txmsg,
                                         p_err_code,
                                         l_err_param
           ) <> systemnums.c_success
        THEN
           plog.debug (pkgctx,
                       'got error 0047: ' || p_err_code
           );
           ROLLBACK;
           p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
           plog.error(pkgctx, 'Error:'  || p_err_message);
           plog.setendsection(pkgctx, 'pr_ResetPin');
           RETURN;
        END IF;
    END;
    p_err_code:='0';
    plog.setendsection(pkgctx, 'pr_ResetPin');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_ResetPin');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_ResetPin');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_ResetPin;

--1.8.1.9: lay lên chi nhanh
procedure pr_get_branch(
    p_refcursor in out pkg_report.ref_cursor,
    p_areaid    IN varchar2
    )
is
begin
    plog.setbeginsection(pkgctx, 'pr_get_branch');
    Open p_refcursor FOR

/*       select *
          from (select a.*, rownum r
                   from (*/
                      select br.brid, br.brname
                       from branch b, BRGRP br
                       where b.branchid=br.brid
                       and br.status='A'
                       and b.areaid=p_areaid
/*                       ) a
                  where rownum <= ROWS_RPP * PAGE_RPP)
         where r > ROWS_RPP * (PAGE_RPP - 1)*/
         ;
    plog.setendsection(pkgctx, 'pr_get_branch');
exception when others then
       plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'pr_get_branch');
end pr_get_branch;

PROCEDURE pr_OnlineRegister(
       p_CustomerName     IN   VARCHAR2,
       p_CustomerBirth    IN   VARCHAR2,
       p_IDCode           IN   VARCHAR2,
       p_Iddate           IN   VARCHAR2,
       p_Idplace          IN   VARCHAR2,
       p_ContactAddress   IN   VARCHAR2,
       p_Mobile           IN   VARCHAR2,
       p_Email            IN   VARCHAR2,
       p_CustomerCity     IN   VARCHAR2,
       p_Custodycd        IN   VARCHAR2,
       p_brid             IN   VARCHAR2,
       p_sex              IN   VARCHAR2,
       p_err_code         OUT  varchar2,
       p_err_message      OUT  varchar2,
       p_expdate          IN   varchar2 default '', -- Ngay het han mat khau
       p_Bankaccount      in   varchar2 default '', -- so tai khoan ngan hang
       p_Bankname         in   varchar2 default '', -- ten ngan hang
       p_ReRegister       in   varchar2 default 'N', -- dang ky moi gioi khong
       p_ReRelationship   in   varchar2 default '', -- quan he vs moi gioi. KHONG DUNG
       p_ReFullName       in   varchar2 default '', -- ten moi gioi
       p_ReTlid           in   varchar2 default '',-- ma moi gioi
       p_othCustodycd     in   varchar2 default '', -- MA LUU KY CTCK khac KHONG DUNG
       p_othCompany       in   varchar2 default '', -- CTCK KHAC KHONG DUNG
       p_RegisterServices in   varchar2 default 'NNNNN', -- Dich vu giao dich CK: NNNNN:1.GD qua IE,2.Call,3.UT tien ban,4.KyQuy,5.DK Phai Sinh
       p_RegisterNotiTran in   varchar2 default 'NNN', --Phuong thuc thong bao:NNN: 1.Email, 2. SMS, 3.Truc Tuyen
       p_AuthenTypeOnline in   varchar2 default 'NN',  -- Loai xac thuc kenh online:NN: 1.OTP OBLINE. 2. Chu ky so
       p_AuthenTypeMobile in   varchar2 default 'N' ,   -- loai xac thuc kenh mobile: N - 1 OTP
       p_AreaOpenAccount  in   varchar2 default '', -- noi mo tk
       p_BranchOpenAccount in   varchar2 default '', -- chi nhanh
       p_BankBrid      in   varchar2 default ''
    )
    IS
      v_countcust         number;
      v_countidcode       number;
      l_datasource        varchar2(1000);
      v_CustomerType      varchar2(2);
      v_IDType            varchar2(3);
      v_Country           varchar2(10);
      v_txdate            varchar2(10);
      v_IDDATE            DATE;
      v_CustomerBirth     DATE;
      v_EXPDATE           DATE;
      v_email             VARCHAR2(400);
      v_emailOPS             VARCHAR2(400);
      v_emailRCS             VARCHAR2(400);
      v_brid              VARCHAR(3);
      --1.8.1.9:
      v_autoid            NUMBER(10);
      -- dich vu dang ky
      v_placeorderphone   varchar2(1);
      v_placeorderonline  varchar2(1);
      v_cashinadvanceauto varchar2(1);
      --thong bao dat lenh
      v_matchorderreportsms     varchar2(1);
      v_matchorderreportemail   varchar2(1);
      v_statementonline         varchar2(1);
      v_year                    number;
      v_count                   number;

    BEGIN
        plog.error (pkgctx,'pr_OnlineRegister Start...');
        plog.setbeginsection(pkgctx, 'pr_OnlineRegister');

        v_CustomerType := 'I';
        v_IDType := '001';
        v_Country := '234';

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
         v_countcust:=0;
         select count(1) into v_countcust
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

         if v_countcust >0 then
            p_err_code:='-200019';
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_OnlineRegister');
            return;
         end IF;
        End if;

        If p_IDCode is not null THEN
         v_countidcode:=0;
         select count(1) into v_countidcode
         from (select idcode from cfmast where idcode=p_IDCode
                union
               select idcode
               from registeronline
               where idcode=p_IDCode
               ) ;

         if v_countidcode >0 then
            p_err_code:='-200020';
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_OnlineRegister');
            return;
         end if;
       End IF;
        -- 1.8.1.9:begin CHECK
         if( p_expdate is not null) then
          v_EXPDATE := to_date(p_expdate,'DD-MM-RRRR');
          if( v_EXPDATE < to_date(p_IDDATE,'DD-MM-RRRR')) then
            p_err_code:='-201224'; -- tb tt khong hop ly
            p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.error(pkgctx, 'Error:'  || p_err_message);
            plog.setendsection(pkgctx, 'pr_OnlineRegister');
            return;
          end if;
         end if;

         if(p_Bankaccount is not null) then
           if  NOT owa_pattern.match(p_Bankaccount, '^\w{1,}[0-9,a-z,A-Z]$') then
              p_err_code:='-201224'; -- tb tt khong hop ly
              p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
              plog.error(pkgctx, 'Error:'  || p_err_message);
              plog.setendsection(pkgctx, 'pr_OnlineRegister');
            return;
           end if;
         end if;
         -- bo truong thong tin
         /*if(p_othCustodycd is not null) then
           if  NOT owa_pattern.match(p_othCustodycd, '^\w{1,}[0-9,a-z,A-Z]$') then
              p_err_code:='-201224'; -- tb tt khong hop ly
              p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
              plog.error(pkgctx, 'Error:'  || p_err_message);
              plog.setendsection(pkgctx, 'pr_OnlineRegister');
            return;
           end if;
         end if;*/
         --check ngay cap giay to
         select trunc(months_between(to_date(p_Iddate,'DD-MM-RRRR'), to_date(p_CustomerBirth,'DD-MM-RRRR')) /12) into v_year from dual;
         if v_year < 14 then
              p_err_code:='-200112'; -- tb ngay cap giay to khong hop le
              p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
              plog.error(pkgctx, 'Error:'  || p_err_message);
              plog.setendsection(pkgctx, 'pr_OnlineRegister');
            return;
         end if;

         --check tuoi mo tai khoan
         select trunc(months_between(to_date(getcurrdate,'DD-MM-RRRR'), to_date(p_CustomerBirth,'DD-MM-RRRR')) /12) into v_year from dual;
         if v_year < 18 then
              p_err_code:='-200113'; -- tb khach hang chua du tuoi mo tai khoan
              p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
              plog.error(pkgctx, 'Error:'  || p_err_message);
              plog.setendsection(pkgctx, 'pr_OnlineRegister');
            return;
         end if;
         -- check so dien thoai
         if(p_Mobile is not null) then
           select count(*) into v_count from smsmap s where s.prmobile = substr(p_Mobile,1,3);
           if( v_count = 0 or length(trim(p_Mobile)) <> 10) then
              p_err_code:='-200114'; -- tb khach hang chua du tuoi mo tai khoan
              p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
              plog.error(pkgctx, 'Error:'  || p_err_message);
              plog.setendsection(pkgctx, 'pr_OnlineRegister');
              return;
           end if;
         end if;
         -- 1.8.1.9: end check

        SELECT varvalue INTO v_txdate
        FROM sysvar
        WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
        v_IDDATE := to_date(p_IDDATE,'DD-MM-RRRR');
        v_CustomerBirth := to_date(p_CustomerBirth,'DD-MM-RRRR');
        if( p_expdate is  null) then
          v_EXPDATE := add_MONTHS(v_IDDATE,15*12);
        end if;

        SELECT varvalue INTO v_brid FROM sysvar WHERE varname = 'ONLINEACCOPENNUMBER_HN';
        --1.8.1.9: begin EMAIL 4005
        begin
         --1.8.1.9.P2: chinh lai luong mail
         v_email:= '';
         v_emailRCS:= '';
           if(p_ReRegister ='N') then
              SELECT varvalue INTO v_emailRCS FROM sysvar WHERE varname = 'EMAIL_HCM' ;
           else
            if( p_AreaOpenAccount is not null and p_BranchOpenAccount is not null ) then
               select nvl(EMAIL, '') into v_email from BRANCH
               where AREAID = trim(p_AreaOpenAccount) and BRANCHID = trim(p_BranchOpenAccount);
            else
                 --SELECT varvalue INTO v_emailOPS  FROM sysvar WHERE varname = 'EMAIL_HN';
                 SELECT varvalue INTO v_emailRCS FROM sysvar WHERE varname = 'EMAIL_HCM' ;
            end if;
           end if;
          EXCEPTION  WHEN OTHERS THEN
              v_email := '';
              --SELECT varvalue INTO v_emailOPS  FROM sysvar WHERE varname = 'EMAIL_HN';
              SELECT varvalue INTO v_emailRCS FROM sysvar WHERE varname = 'EMAIL_HCM' ;
          END;
        
         --1.8.1.9 END EMAIL 4005

        v_autoid := SEQ_REGISTER_AUTOID.nextval;
        insert into registeronline
               (AUTOID, CUSTOMERTYPE, CUSTOMERNAME, CUSTOMERBIRTH,
               IDTYPE, IDCODE, IDDATE, IDPLACE, EXPIREDATE,
               ADDRESS, TAXCODE, PRIVATEPHONE, MOBILE, FAX,
               EMAIL, OFFICE, POSITION, COUNTRY, CUSTOMERCITY,
               TKTGTT, TRADINGOTHER, OTHERACCOUNT1, OTHERCOMPANY1,
               OTHERACCOUNT2, OTHERCOMPANY2, OTHERACCOUNT3,
               OTHERCOMPANY3, OTHERACCOUNT4, OTHERCOMPANY4,
               OTHERACCOUNT5, OTHERCOMPANY5, OTHERACCOUNT6,
               OTHERCOMPANY6, OTHERACCOUNT7, OTHERCOMPANY7,
               PLACEORDERPHONE, MATCHEDORDERREPORTSMS, PLACEORDERONLINE,
               MATCHEDORDERREPORTEMAIL, CASHINADVANCEONLINE, STATEMENTONLINE,
               CASHINADVANCEAUTO, ORDERTABLEREPORTEMAIL, CASHTRANSFERONLINE,
               NEWSBVSCEMAIL, ADDITIONALSHARESONLINE, SEARCHONLINE,
               BANKACCOUNTNAME1, BANKIDCODE1, BANKIDDATE1,
               BANKIDPLACE1, BANKACCOUNTNUMBER1, BANKNAME1,
               BRANCH1, BANKCITY1, BANKACCOUNTNAME2, BANKIDCODE2,
               BANKIDDATE2, BANKIDPLACE2, BANKACCOUNTNUMBER2, BANKNAME2,
               BRANCH2, BANKCITY2, BANKACCOUNTNAME3, BANKIDCODE3, BANKIDDATE3,
               BANKIDPLACE3, BANKACCOUNTNUMBER3, BANKNAME3, BRANCH3, BANKCITY3,
               SMSORCARD, SMSPHONENUMBER, ISAPPROVE, SEX, CONTACTADDRESS, WORKMOBILE,
               CERTIFICATE, CERTIFICATEDATE, CERTIFICATEPLACE, BUSINESS, AGENTNAME,
               AGENTPOSITION, AGENTCOUNTRY, AGENTSEX, AGENTID, AGENTPHONE, AGENTEMAIL,
               FIXEDINCOME, LONGGROWTH, MIDGROWTH, SHORTGROWTH, LOWRISK, MIDRISK,
               HIGHRISK, MANAGECOMPANYNAME, SHAREHOLDERCOMPANYNAME, INVESTKNOWLEGDE,
               INVESTEXPERIENCE, ISTRUSTACCTNO, TRUSTFULLNAME, RELATIONSHIP,
               DEALSTOCKTYPE, DEALMETHOD, DEALRESULT, DEALSTATEMENT, DEALTAX,
               BENEFICIARYNAME, BENEFICIARYBIRTHDAY, BENEFICIARYPHONE, BENEFICIARYID,
                BENEFICIARYIDDATE, BENEFICIARYIDPLACE, AUTHORIZEDNAME, AUTHORIZEDPHONE,
                AUTHORIZEDID, AUTHORIZEDIDDATE, AUTHORIZEDIDPLACE, CUSTODYCD, TRUSTPHONE,
                AUTHORIZEDBIRTHDAY, AGENTIDDATE, AGENTIDPLACE, BRID,
                REREGISTER, RERELATIONSHIP, REFULLNAME, RETLID ,  REGISTERSERVICES,
                REGISTERNOTITRAN,AUTHENTYPEONLINE, AUTHENTYPEMOBILE,AREAOPENACCOUNT,BRANCHOPENACCOUNT )
        values (
                v_autoid,v_CUSTOMERTYPE,p_CUSTOMERNAME,v_CustomerBirth,
                v_IDTYPE,p_IDCODE,v_IDDATE,p_IDPLACE,v_EXPDATE,
                p_ContactAddress,NULL,NULL,p_MOBILE,NULL,
                p_EMAIL,NULL,NULL,v_COUNTRY,p_CUSTOMERCITY,
                NULL,NULL,p_othCustodycd,p_othCompany,
                NULL,NULL,NULL,
                NULL,NULL,NULL,
                NULL,NULL,NULL,
                NULL,NULL,NULL,
                substr(p_RegisterServices,2,1),substr(p_RegisterNotiTran,2,1),substr(p_RegisterServices,1,1),
                substr(p_RegisterNotiTran,1,1),NULL,substr(p_RegisterNotiTran,3,1),
                substr(p_RegisterServices,3,1),NULL,NULL,
                NULL,NULL,NULL,
                NULL,NULL,NULL,
                NULL,p_Bankaccount,p_Bankname,
                p_BankBrid,NULL,NULL,NULL,
                NULL,NULL,NULL,NULL,
                NULL,NULL,NULL,NULL,NULL,
                NULL,NULL,NULL,NULL,NULL,
                NULL,NULL,NULL,p_sex,p_ContactAddress,NULL,
                NULL,NULL,NULL,NULL,NULL,
                NULL,NULL,NULL,NULL,NULL,NULL,
                NULL,NULL,NULL,NULL,NULL,NULL,
                NULL,NULL,NULL,NULL,
                NULL,NULL,NULL,NULL,
                NULL,NULL,NULL,NULL,NULL,
                NULL,NULL,NULL,NULL,
                NULL,NULL,NULL,NULL,
                NULL,NULL, NULL,p_Custodycd,NULL,
                NULL,NULL,NULL,p_brid,
                p_ReRegister,p_ReRelationship,p_ReFullName ,p_ReTlid,p_RegisterServices,
                p_RegisterNotiTran,p_AuthenTypeOnline,p_AuthenTypeMobile,nvl(p_AreaOpenAccount,''), nvl(p_BranchOpenAccount,'')
                );


        insert into registeronlinelog
               (AUTOID, CUSTOMERTYPE, CUSTOMERNAME, CUSTOMERBIRTH, IDTYPE,
               IDCODE, IDDATE, IDPLACE, EXPIREDATE, MOBILE, EMAIL, COUNTRY,
               CUSTOMERCITY, SEX, CONTACTADDRESS, CUSTODYCD, BRID, TXDATE, DELETEDATE)
        values (seq_registeronlinelog.nextval, v_CUSTOMERTYPE, p_CUSTOMERNAME, v_CustomerBirth, v_IDTYPE,
               p_IDCODE, v_IDDATE, p_IDPLACE, add_MONTHS(v_IDDATE,15*12), p_MOBILE, p_EMAIL, v_COUNTRY,
               p_CUSTOMERCITY, null, p_ContactAddress, p_Custodycd, p_brid, to_date(v_txdate,'dd/mm/rrrr'), null);

         COMMIT;

        l_datasource := 'select '''||p_CUSTOMERNAME||''' fullname,
        '''||p_IDCODE||''' idcode, '''||p_IDDATE||''' iddate,
        '''||p_sex||''' sex,
        '''||p_IDPLACE||''' idplace, '''||p_EMAIL||''' email, '''||p_MOBILE||''' mobile,  '''||to_char(v_CustomerBirth,'DD/MM/RRRR')||''' birthdate ,
        '''||v_autoid||''' pv_autoid from dual ;';

        if length(p_EMAIL)>0 then
            nmpks_ems.InsertEmailLog(p_EMAIL, '4000', l_datasource, p_custodycd);
        end if;
        if length(v_email)>0 then
          nmpks_ems.InsertEmailLog(v_email, '4005', l_datasource, p_custodycd);
        end if;
        if length(v_emailOPS)>0 then
          nmpks_ems.InsertEmailLog(v_emailOPS, '4005', l_datasource, p_custodycd);
        end if;
        if length(v_emailRCS)>0 then
         nmpks_ems.InsertEmailLog(v_emailRCS, '4005', l_datasource, p_custodycd);
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

begin
  -- Initialization
  for i in (select * from tlogdebug)
  loop
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  end loop;

  pkgctx := plog.init('fopks_api_rpp',
                      plevel     => nvl(logrow.loglevel, 30),
                      plogtable  => (nvl(logrow.log4table, 'N') = 'Y'),
                      palert     => (nvl(logrow.log4alert, 'N') = 'Y'),
                      ptrace     => (nvl(logrow.log4trace, 'N') = 'Y'));

end fopks_api_rpp;
/
