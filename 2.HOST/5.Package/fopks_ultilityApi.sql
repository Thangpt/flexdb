create or replace package fopks_ultilityApi is

  /** ----------------------------------------------------------------------------------------------------
  ** Module: FO - OpenAPI 3
  ** Description: OpenAPI 3 API for utility router
  ** and is copyrighted by FSS.
  **
  **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
  **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
  **    graphic, optic recording or otherwise, translated in any language or computer language,
  **    without the prior written permission of Financial Software Solutions. JSC.
  **
  **  MODIFICATION HISTORY
  **    Person            Date           Comments
  **  duyanh.hoang     06/09/2019         Created
  ** (c) 2018 by Financial Software Solutions. JSC.
  ----------------------------------------------------------------------------------------------------*/

  /*
   tran/accounts/{accountId}/advanced - Payment in advanced transaction
  */
  PROCEDURE pr_advanced (p_accountId        VARCHAR2,
                         p_txdate           VARCHAR2,
                         p_paidDate         VARCHAR2,
                         p_advanceAmt       NUMBER,
                         p_feeAmt           NUMBER,
                         p_days             NUMBER,
                         p_advancedMaxAmt   NUMBER,
                         p_desc             VARCHAR2,
                         p_ipAddress        VARCHAR2,
						 p_via           VARCHAR2,
						 p_validationtype   VARCHAR2,
                         p_devicetype       VARCHAR2,
                         p_device           VARCHAR2,
						 p_err_code     OUT VARCHAR2,
                         p_err_message  OUT VARCHAR2);
  /*
   /tran/accounts/{accountId}/checkCashTransfer
  */
  PROCEDURE pr_checkCashTransfer (p_accountId varchar,
                                p_type        varchar2,
                                p_amount      number,
                                p_receiveAccount varchar2,
                                --p_feetype   varchar2,
                                p_receiveAmout  OUT  number,
                                p_feeAmount  OUT  number,
                                p_vatAmout  OUT  number,
                                p_err_code  OUT varchar2,
                                p_err_message out VARCHAR2);
  /*
   /tran/accounts/{accountId}/rightOffRegiter - Right register transaction
  */
  PROCEDURE pr_rightOffRegiter (p_accountId       VARCHAR2,
                               p_camastId         VARCHAR2,
                               p_qtty             NUMBER,
                               p_desc             VARCHAR2,
                               p_ipAddress        VARCHAR2,
							   p_via           VARCHAR2,
							   p_validationtype   VARCHAR2,
							   p_devicetype       VARCHAR2,
							   p_device           VARCHAR2,
							   p_err_code     OUT VARCHAR2,
                               p_err_message  OUT VARCHAR2);
  /*
   /tran/accounts/{accountId}/internalTransfer - Internal cash transfer transaction
  */
  PROCEDURE pr_InternalTransfer (p_accountId        varchar,
                              p_receiveAccount         VARCHAR2,
                              p_amout               NUMBER,
                              p_transDescrtiption   VARCHAR2,
                              p_ipAddress           VARCHAR2,
							  p_via           VARCHAR2,
							  p_validationtype   VARCHAR2,
							  p_devicetype       VARCHAR2,
							  p_device           VARCHAR2,
                              p_err_code            OUT varchar2,
                              p_err_message         out VARCHAR2);
  /*
   /tran/accounts/{accountId}/externalTransfer - External cash transfer transaction
  */
  PROCEDURE pr_ExternalTransfer (p_accountId        varchar,
                              p_benefitBank         varchar2,
                              p_benefitAccount      varchar2,
                              p_benefitName         varchar2,
                              p_benefitLisenseCode  varchar2,
                              p_amout               number,
                              p_feeAmount           number,
                              p_vatAmount           number,
                              --p_feeType             VARCHAR2,
                              p_transDescrtiption   VARCHAR2,
                              p_ipAddress           VARCHAR2,
							  p_via           VARCHAR2,
							  p_validationtype   VARCHAR2,
							  p_devicetype       VARCHAR2,
							  p_device           VARCHAR2,
                              p_err_code            OUT varchar2,
                              p_err_message         out VARCHAR2);
  /*
   /tran/accounts/{accountId}/tranferStock - Internal securities transfer
  */
  PROCEDURE pr_transferStock (p_accountId       VARCHAR2,
                             p_receiveAccount   VARCHAR2,
                             p_symbol           VARCHAR2,
                             p_qtty             NUMBER,
                             p_desc             VARCHAR2,
                             p_ipAddress        VARCHAR2,
                             p_err_code     OUT VARCHAR2,
                             p_err_message  OUT VARCHAR2);
  /*
  /trans/accounts/{accountId}/regitstSellOddLot - Regist Sell Odd Lot
  */
  PROCEDURE pr_registSellOddLot(p_accountId varchar,
                              p_symbol   varchar2,
                              p_quantity VARCHAR2,
                              p_price   varchar2,
                              p_err_code  OUT varchar2,
                              p_err_message out varchar2);
  /*
  /trans/accounts/{accountId}/cancelSellOddLot
  */
  PROCEDURE pr_cancelSellOddLot (p_accountId       VARCHAR2,
                                p_symbol           VARCHAR2,
                                p_txnum            VARCHAR2,
                                p_txdate           VARCHAR2,
                                p_err_code         OUT VARCHAR2,
                                p_err_message      OUT VARCHAR2);
  /*
  /trans/accounts/{accountId}/bonds2SharesRegister - Regist Sell Odd Lot
  */
  PROCEDURE pr_Bonds2SharesRegister (p_accountId   IN   VARCHAR2,
                                  p_caSchdId   IN   VARCHAR2,
                                  p_qtty      IN   number,
                                  p_desc      IN   varchar2,
                                  p_ipaddress in  varchar2 default '',
								  p_via           VARCHAR2,
								  p_validationtype   VARCHAR2,
								  p_devicetype       VARCHAR2,
								  p_device           VARCHAR2,
                                  p_err_code  OUT varchar2,
                                  p_err_message  OUT VARCHAR2);
  /*
  /trans/accounts/{accountId}/confirmOrder - confirmOrder
  */
  PROCEDURE pr_confirmOrder (p_accountId     VARCHAR2,
                            p_custid  VARCHAR2,
                            p_orderId VARCHAR2,
                            p_Ipadrress VARCHAR2,
							p_via           VARCHAR2,
                            p_err_code  OUT varchar2,
                            p_err_message  OUT VARCHAR2);
    /*
  /trans/accounts/{accountId}/registTransferAcct - DK Nguoi Thu Huong
  */
  PROCEDURE pr_registTransferAcct (p_accountId     VARCHAR2,
                                  --p_type           VARCHAR2, -- bank, msb
                                  p_bankAcName     VARCHAR2,
                                  p_bankAcc        VARCHAR2,
                                  p_bankName       VARCHAR2,
                                  p_bankId         VARCHAR2,
                                  p_bankOrgNo      VARCHAR2,
                                  p_branch         VARCHAR2,
                                  p_city           VARCHAR2,
                                  p_hintName       VARCHAR2,
                                  p_ipAddress      VARCHAR2,
								  p_via           VARCHAR2,
								  p_validationtype   VARCHAR2,
								  p_devicetype       VARCHAR2,
								  p_device           VARCHAR2,
                                  p_err_code  OUT varchar2,
                                  p_err_message  OUT VARCHAR2);
  /*
  /trans/accounts/{accountId}/removeTransferAcct - DK Nguoi Thu Huong
  */
  PROCEDURE pr_RemoveTransferAcct (p_accountId       VARCHAR2,
                              --p_type             VARCHAR2,
                              p_bankAcc          VARCHAR2,
                              p_err_code         OUT VARCHAR2,
                              p_err_message      OUT VARCHAR2);
  /*
  /trans/accounts/{accountId}/editTemplate
  */
  PROCEDURE pr_editTemplate (p_accountId       VARCHAR2,
                            p_code             VARCHAR2,
                            p_type             VARCHAR2, -- remove, add
                            p_err_code         OUT VARCHAR2,
                            p_err_message      OUT VARCHAR2);
  /*
  /trans/accounts/{accountId}/editCustInfo
  */
  PROCEDURE pr_editCustInfo (p_custId           VARCHAR2,
                            p_address          VARCHAR2,
                            p_err_code         OUT VARCHAR2,
                            p_err_message      OUT VARCHAR2);
  /*
  /tran/accounts/{accountId}/changeTelePin
  */
  PROCEDURE pr_changeTelePin (p_custId         VARCHAR2,
                            p_newpin           VARCHAR2,
                            p_err_code         OUT VARCHAR2,
                            p_err_message      OUT VARCHAR2);
  /*
   /userdata/changePass - Change login password - Change PIN
  */
  PROCEDURE pr_updatepassonline(p_username varchar,
                              p_pwType   varchar2,
                              p_oldPassWord VARCHAR2,
                              P_password   varchar2,
                              p_err_code  OUT varchar2,
                              p_err_message out varchar2);

   --1.8.2.1: chuyen tien giua 2 tk luu ky
   PROCEDURE pr_Depoacc2Transfer(p_custid VARCHAR2,
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

end fopks_ultilityApi;
/
create or replace package body fopks_ultilityApi is

  -- Private type declarations
  pkgctx plog.log_ctx;
  logrow tlogdebug%rowtype;

  /*
   tran/accounts/{accountId}/advanced - Payment in advanced transaction
  */
  PROCEDURE pr_advanced (p_accountId        VARCHAR2,
                         p_txdate           VARCHAR2,
                         p_paidDate         VARCHAR2,
                         p_advanceAmt       NUMBER,
                         p_feeAmt           NUMBER,
                         p_days             NUMBER,
                         p_advancedMaxAmt   NUMBER,
                         p_desc             VARCHAR2,
                         p_ipAddress        VARCHAR2,
						 p_via           VARCHAR2,
						 p_validationtype   VARCHAR2,
                         p_devicetype       VARCHAR2,
                         p_device           VARCHAR2,
						 p_err_code     OUT VARCHAR2,
                         p_err_message  OUT VARCHAR2)
  IS
  BEGIN
    plog.setBeginSection (pkgctx, 'pr_advanced');
    p_err_code := 0;
    p_err_message := '';

    fopks_api.pr_AdvancePayment(p_afacctno       => p_accountId,
                                p_txdate         => p_txdate,
                                p_duedate        => p_paidDate,
                                p_advamt         => p_advanceAmt,
                                p_feeamt         => p_feeAmt,
                                p_advdays        => p_days,
                                p_maxamt         => p_advancedMaxAmt,
                                p_desc           => p_desc,
                                p_err_code       => p_err_code,
                                p_err_message    => p_err_message,
                                p_ipaddress      => p_ipAddress,
                                p_via            => p_via,
                                p_validationtype => p_validationtype,
                                p_devicetype     => p_devicetype,
                                p_device         => p_device);
    plog.setEndSection (pkgctx, 'pr_advanced');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_message := 'SYSTEM ERROR';
      plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_advanced');
  END;

  /*
   /tran/accounts/{accountId}/checkCashTransfer
  */
  PROCEDURE pr_checkCashTransfer (p_accountId varchar,
                                p_type        varchar2,
                                p_amount      number,
                                p_receiveAccount varchar2,
                                --p_feetype   varchar2,
                                p_receiveAmout  OUT  number,
                                p_feeAmount  OUT  number,
                                p_vatAmout  OUT  number,
                                p_err_code  OUT varchar2,
                                p_err_message out VARCHAR2)
  IS
  l_type   VARCHAR2(10);
  --l_feecd  VARCHAR2(10) := '';
  --l_feeType VARCHAR2(10);
  l_bankId  VARCHAR2(1000);
  BEGIN
    plog.setBeginSection (pkgctx, 'fn_checkCashTransfer');
    p_err_code := 0;
    p_err_message := '';
    --1.8.2.1: them moi loai chuyen khoan, check vơi type 004, bieu phi 0015

    l_type := CASE WHEN nvl(p_type, 'internal') = 'internal' THEN '001'
                   WHEN lower(p_type) ='depoacc2transfer' then '004'  ELSE '002' END;
    --l_feeType := CASE WHEN nvl(p_feetype, 'inFee') = 'inFee' THEN '0' ELSE '1' END;
    p_feeAmount := 0;
    p_vatAmout := 0;
    p_receiveAmout := 0;
    IF l_type = '002' THEN
      BEGIN
        SELECT bankId INTO l_bankId
        FROM VW_STRADE_MT_ACCOUNTS
        WHERE afacctno = p_accountId
        AND REG_ACCTNO = p_receiveAccount;
		l_type := CASE WHEN nvl(l_bankId, '') like '302%' THEN '003' ELSE '002' END;	--check nếu chuyển tiền sang MSB thì l_type = 003;	--check nếu chuyển tiền sang MSB thì l_type = 003;
		plog.debug (pkgctx,l_type || ' ' || l_bankId);
      EXCEPTION
        WHEN OTHERS THEN
          l_bankId := '';
      END;
    END IF;
    fopks_api.pr_CheckCashTransfer (p_account     => p_accountId,
                                    p_type        => l_type,
                                    p_amount      => p_amount,
                                    p_RemainAmt   => 0,
                                    p_bankid      => l_bankId, --2021.01.0.02: them dau vao bankid
                                    p_err_code    => p_err_code,
                                    p_err_message => p_err_message);
    IF p_err_code = systemnums.C_SUCCESS THEN
      IF nvl(p_type, 'internal') in ( 'internal', 'depoacc2transfer')  THEN
        p_feeAmount := fopks_api.fn_getInTransferMoneyFee(p_account   => p_accountId,
                                                          p_toaccount => p_receiveAccount,
                                                          p_amount    => p_amount);
      ELSE
        p_feeAmount := fopks_api.fn_getExTransferMoneyFee(p_amount => p_amount, p_bankid => l_bankId);
      END IF;
    END IF;
    plog.setEndSection (pkgctx, 'fn_checkCashTransfer');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_message := 'SYSTEM ERROR';
      plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'fn_checkCashTransfer');
  END;

  /*
   /tran/accounts/{accountId}/rightOffRegiter - Right register transaction
  */
  PROCEDURE pr_rightOffRegiter (p_accountId       VARCHAR2,
                               p_camastId         VARCHAR2,
                               p_qtty             NUMBER,
                               p_desc             VARCHAR2,
                               p_ipAddress        VARCHAR2,
							   p_via           VARCHAR2,
							   p_validationtype   VARCHAR2,
							   p_devicetype       VARCHAR2,
							   p_device           VARCHAR2,
                               p_err_code     OUT VARCHAR2,
                               p_err_message  OUT VARCHAR2)
  IS
  BEGIN
    plog.setBeginSection (pkgctx, 'pr_advanced');
    p_err_code := 0;
    p_err_message := '';

    fopks_api.pr_RightoffRegiter (p_camastid       => p_camastId,
                                  p_account        => p_accountId,
                                  p_qtty           =>p_qtty ,
                                  p_desc           => p_desc,
                                  p_err_code       => p_err_code,
                                  p_err_message    => p_err_message,
                                  p_ipaddress      => p_ipAddress,
                                  p_via            => p_via,
                                  p_validationtype => p_validationtype,
								  p_devicetype     => p_devicetype,
								  p_device         => p_device);
    plog.setEndSection (pkgctx, 'pr_advanced');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_message := 'SYSTEM ERROR';
      plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_advanced');
  END;

  /*
   /tran/accounts/{accountId}/internalTransfer - Internal cash transfer transaction
  */
  PROCEDURE pr_InternalTransfer (p_accountId        varchar,
                              p_receiveAccount         VARCHAR2,
                              p_amout               NUMBER,
                              p_transDescrtiption   VARCHAR2,
                              p_ipAddress           VARCHAR2,
							  p_via           VARCHAR2,
							  p_validationtype   VARCHAR2,
							  p_devicetype       VARCHAR2,
							  p_device           VARCHAR2,
                              p_err_code            OUT varchar2,
                              p_err_message         out VARCHAR2)
  IS
  BEGIN
    plog.setBeginSection (pkgctx, 'pr_InternalTransfer');
    p_err_code := 0;
    p_err_message := '';

    fopks_api.pr_InternalTransfer(p_account        => p_accountId,
                                p_toaccount      => p_receiveAccount,
                                p_amount         => p_amout,
                                p_desc           => p_transDescrtiption,
                                p_err_code       => p_err_code,
                                p_err_message    => p_err_message,
                                p_ipaddress      => p_ipAddress,
                                p_via            => p_via,
                                p_validationtype => p_validationtype,
                                p_devicetype     => p_devicetype,
                                p_device         => p_device);
    plog.setEndSection (pkgctx, 'pr_InternalTransfer');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_message := 'SYSTEM ERROR';
      plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_InternalTransfer');
  END;

  /*
   /tran/accounts/{accountId}/externalTransfer - External cash transfer transaction
  */
  PROCEDURE pr_ExternalTransfer (p_accountId        varchar,
                              p_benefitBank         varchar2,
                              p_benefitAccount      varchar2,
                              p_benefitName         varchar2,
                              p_benefitLisenseCode  varchar2,
                              p_amout               number,
                              p_feeAmount           number,
                              p_vatAmount           number,
                              --p_feeType             VARCHAR2,
                              p_transDescrtiption   VARCHAR2,
                              p_ipAddress           VARCHAR2,
							  p_via           VARCHAR2,
							  p_validationtype   VARCHAR2,
							  p_devicetype       VARCHAR2,
							  p_device           VARCHAR2,
                              p_err_code            OUT varchar2,
                              p_err_message         out VARCHAR2)
  IS
  --l_feeType VARCHAR2(10);
  l_bankid    cfotheracc.bankid%TYPE;
  BEGIN
    plog.setBeginSection (pkgctx, 'pr_ExternalTransfer');
    p_err_code := 0;
    p_err_message := '';
    --l_feeType := CASE WHEN nvl(p_feeType, 'inFee') = 'inFee' THEN '0' ELSE '1' END;
    SELECT bankid INTO l_bankid FROM cfotheracc
    WHERE afacctno = p_accountId AND bankacc = p_benefitAccount;

    fopks_api.pr_ExternalTransfer (p_account        => p_accountId,
                                   p_bankid         => l_bankid,
                                   p_benefbank      => p_benefitBank,
                                   p_benefacct      => p_benefitAccount,
                                   p_benefcustname  => p_benefitName,
                                   p_beneflicense   => p_benefitLisenseCode,
                                   p_amount         => p_amout,
                                   p_feeamt         => 0,
                                   p_vatamt         => p_vatAmount,
                                   p_desc           => p_transDescrtiption,
                                   p_err_code       => p_err_code,
                                   p_err_message    => p_err_message,
                                   p_ipaddress      => p_ipAddress,
                                   p_via            => p_via,
                                   p_validationtype => p_validationtype,
								   p_devicetype     => p_devicetype,
								   p_device         => p_device);

    plog.setEndSection (pkgctx, 'pr_ExternalTransfer');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_message := 'SYSTEM ERROR';
      plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_ExternalTransfer');
  END;

  /*
   /tran/accounts/{accountId}/tranferStock - External cash transfer transaction
  */
  PROCEDURE pr_transferStock (p_accountId       VARCHAR2,
                             p_receiveAccount   VARCHAR2,
                             p_symbol           VARCHAR2,
                             p_qtty             NUMBER,
                             p_desc             VARCHAR2,
                             p_ipAddress        VARCHAR2,
                             p_err_code     OUT VARCHAR2,
                             p_err_message  OUT VARCHAR2)
  IS
  BEGIN
    plog.setBeginSection (pkgctx, 'pr_transferStock');
    p_err_code := 0;
    p_err_message := '';

    fopks_api.pr_Transfer_SE_account (p_trfafacctno => p_accountId,
                                      p_rcvafacctno => p_receiveAccount,
                                      p_symbol      => p_symbol,
                                      p_quantity    => p_qtty,
                                      p_blockedqtty => 0,
                                      p_err_code    => p_err_code,
                                      p_err_message => p_err_message);

    plog.setEndSection (pkgctx, 'pr_transferStock');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_message := 'SYSTEM ERROR';
      plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_transferStock');
  END;

  /*
  /tran/accounts/{accountId}/sellOddLotRegister - Regist Sell Odd Lot
  */
  PROCEDURE pr_registSellOddLot(p_accountId varchar,
                              p_symbol   varchar2,
                              p_quantity VARCHAR2,
                              p_price   varchar2,
                              p_err_code  OUT varchar2,
                              p_err_message out varchar2)
  IS
  BEGIN
    plog.setBeginSection (pkgctx, 'pr_registSellOddLot');
    p_err_code   := '0';
    p_err_message := '';
    fopks_api.pr_Tradelot_Retail (p_sellafacctno => p_accountId,
                                  p_symbol       => p_symbol,
                                  p_quantity     => p_quantity,
                                  p_quoteprice   => p_price,
                                  p_err_code     => p_err_code,
                                  p_err_message  => p_err_message);
    plog.setEndSection(pkgctx, 'pr_registSellOddLot');
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_registSellOddLot');
  END;

  /*
  /tran/accounts/{accountId}/cancelSellOddLot
  */
  PROCEDURE pr_cancelSellOddLot (p_accountId       VARCHAR2,
                                p_symbol           VARCHAR2,
                                p_txnum            VARCHAR2,
                                p_txdate           VARCHAR2,
                                p_err_code         OUT VARCHAR2,
                                p_err_message      OUT VARCHAR2)
  IS
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_RemoveTransfer');
    p_err_code := '0';
    p_err_message := '';

    fopks_api.pr_Cancel_Tradelot_Retail (p_sellafacctno => p_accountId,
                                       p_symbol       => p_symbol,
                                       p_txnum        => p_txnum,
                                       p_txdate       => p_txdate,
                                       p_err_code     => p_err_code,
                                       p_err_message  => p_err_message);
    plog.setendsection (pkgctx, 'pr_RemoveTransfer');
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_RemoveTransfer');
  END;

  /*
  /tran/accounts/{accountId}/bonds2SharesRegister - Regist Sell Odd Lot
  */
  PROCEDURE pr_Bonds2SharesRegister (p_accountId   IN   VARCHAR2,
                                  p_caSchdId   IN   VARCHAR2,
                                  p_qtty      IN   number,
                                  p_desc      IN   varchar2,
                                  p_ipaddress in  varchar2 default '',
								  p_via           VARCHAR2,
								  p_validationtype   VARCHAR2,
								  p_devicetype       VARCHAR2,
								  p_device           VARCHAR2,
                                  p_err_code  OUT varchar2,
                                  p_err_message  OUT VARCHAR2)
  IS
  BEGIN
    plog.setBeginSection (pkgctx, 'pr_Bonds2SharesRegister');
    p_err_code := '0';
    p_err_message := '';
    fopks_api.pr_Bonds2SharesRegister(p_caschdautoid   => p_caSchdId,
                                      p_afacctno       => p_accountId,
                                      p_qtty           => p_qtty,
                                      p_desc           => p_desc,
                                      p_err_code       => p_err_code,
                                      p_err_message    => p_err_message,
                                      p_ipaddress      => p_ipaddress,
                                      p_via            => p_via,
                                      p_validationtype => p_validationtype,
									  p_devicetype     => p_devicetype,
									  p_device         => p_device);
    plog.setEndSection (pkgctx, 'pr_Bonds2SharesRegister');
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_Bonds2SharesRegister');
  END;

  /*
  /tran/accounts/{accountId}/confirmOrder - confirmOrder
  */
  PROCEDURE pr_confirmOrder (p_accountId     VARCHAR2,
                            p_custid  VARCHAR2,
                            p_orderId VARCHAR2,
                            p_Ipadrress VARCHAR2,
							p_via           VARCHAR2,
                            p_err_code  OUT varchar2,
                            p_err_message  OUT VARCHAR2)
  IS
  BEGIN
    plog.setBeginSection (pkgctx, 'pr_confirmOrder');
    p_err_code := '0';
    p_err_message := '';
    fopks_api_rpp.pr_ConfirmOrder(p_Orderid   => p_orderId,
                                  p_userId    => '',
                                  p_custid    => p_custid,
                                  p_Ipadrress => p_Ipadrress,
                                  p_via       => p_via,
                                  F_DATE      => NULL,
                                  T_DATE      => NULL,
                                  EXECTYPE    => NULL,
                                  p_err_code  => p_err_code);
    plog.setEndSection (pkgctx, 'pr_confirmOrder');
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_confirmOrder');
  END;

  /*
  /tran/accounts/{accountId}/registTransferAcct - DK Nguoi Thu Huong
  */
  PROCEDURE pr_registTransferAcct (p_accountId     VARCHAR2,
                                  --p_type           VARCHAR2, -- bank, msb
                                  p_bankAcName     VARCHAR2,
                                  p_bankAcc        VARCHAR2,
                                  p_bankName       VARCHAR2,
                                  p_bankId         VARCHAR2,
                                  p_bankOrgNo      VARCHAR2,
                                  p_branch         VARCHAR2,
                                  p_city           VARCHAR2,
                                  p_hintName       VARCHAR2,
                                  p_ipAddress      VARCHAR2,
								  p_via           VARCHAR2,
								  p_validationtype   VARCHAR2,
								  p_devicetype       VARCHAR2,
								  p_device           VARCHAR2,
                                  p_err_code  OUT varchar2,
                                  p_err_message  OUT VARCHAR2)
  IS
  l_type    VARCHAR2(10);
  BEGIN
    plog.setBeginSection (pkgctx, 'pr_registTransferAcct');
    p_err_code := '0';
    p_err_message := '';

    fopks_api_rpp.pr_regtranferacc(p_check          => 'N',
                                   p_type           => '1',
                                   p_afacctno       => p_accountId,
                                   p_ciacctno       => '',
                                   p_ciname         => '',
                                   p_bankacc        => UPPER(p_bankAcc),
                                   p_bankacname     => UPPER(p_bankAcName),
                                   p_bankname       => UPPER(p_bankName),
                                   p_cityef         => p_city,
                                   p_citybank       => p_branch,
                                   p_bankid         => p_bankId,
                                   P_bankorgno      => p_bankorgno,
                                   p_mnemonic       => p_hintName,
                                   p_err_code       => p_err_code,
                                   p_err_message    => p_err_message,
                                   p_ipaddress      => p_ipAddress,
                                   p_via            => p_via,
                                   p_validationtype => p_validationtype,
								   p_devicetype     => p_devicetype,
								   p_device         => p_device);
    plog.setEndSection (pkgctx, 'pr_registTransferAcct');
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_registTransferAcct');
  END;

  /*
  /tran/accounts/{accountId}/removeTransferAcct - DK Nguoi Thu Huong
  */
  PROCEDURE pr_RemoveTransferAcct (p_accountId       VARCHAR2,
                              --p_type             VARCHAR2,
                              p_bankAcc          VARCHAR2,
                              p_err_code         OUT VARCHAR2,
                              p_err_message      OUT VARCHAR2)
  IS
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_RemoveTransfer');
    p_err_code := '0';
    p_err_message := '';

    fopks_api.pr_RemoveTranferacc (p_type        => '1',
                                   p_afacctno    => p_accountId,
                                   p_ciacctno    => '',
                                   p_bankacc     => UPPER(p_bankAcc),
                                   p_err_code    => p_err_code,
                                   p_err_message => p_err_message);
    plog.setendsection (pkgctx, 'pr_RemoveTransfer');
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_RemoveTransfer');
  END;

  /*
  /userdata/accounts/{accountId}/editTemplate
  */
  PROCEDURE pr_editTemplate (p_accountId       VARCHAR2,
                            p_code             VARCHAR2,
                            p_type             VARCHAR2, -- remove, add
                            p_err_code         OUT VARCHAR2,
                            p_err_message      OUT VARCHAR2)
  IS
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_RemoveTransfer');
    p_err_code := '0';
    p_err_message := '';

    fopks_api.pr_EditAFTemplates (p_AFACCTNO      => p_accountId,
                                p_template_code => p_code,
                                p_type          => upper(p_type),
                                p_err_code      => p_err_code,
                                p_err_message   => p_err_message);
    plog.setendsection (pkgctx, 'pr_RemoveTransfer');
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_RemoveTransfer');
  END;

  /*
  /userdata/editCustInfo
  */
  PROCEDURE pr_editCustInfo (p_custId           VARCHAR2,
                            p_address          VARCHAR2,
                            p_err_code         OUT VARCHAR2,
                            p_err_message      OUT VARCHAR2)
  IS
  l_cfAddress    cfmast.address%TYPE;
  l_cfPhone      cfmast.phone%TYPE;
  l_email        cfmast.email%TYPE;
  l_custodycd    cfmast.custodycd%TYPE;
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_RemoveTransfer');
    p_err_code := '0';
    p_err_message := '';

    BEGIN
      SELECT address, phone, email, custodycd
      INTO l_cfAddress, l_cfPhone, l_email, l_custodycd
      FROM cfmast
      WHERE custid = p_custId;
    EXCEPTION
      WHEN OTHERS THEN
        p_err_code := '-200002';
        p_err_message := cspks_system.fn_get_errmsg(p_err_code);
        plog.setendsection (pkgctx, 'pr_changeTelePin');
        RETURN;
    END;


    fopks_api.pr_OnlineUpdateCustomerInfor (p_custodycd   => l_custodycd,
                                            p_custid      => p_custId,
                                            p_address     => l_cfAddress,
                                            p_phone       => l_cfPhone,
                                            p_coaddress   => p_address,
                                            p_cophone     => l_cfPhone,
                                            p_email       => l_email,
                                            p_desc        => 'Open Api',
                                            p_err_code    => p_err_code,
                                            p_err_message => p_err_message);
    plog.setendsection (pkgctx, 'pr_RemoveTransfer');
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_RemoveTransfer');
  END;

  /*
  /tran/accounts/{accountId}/changeTelePin
  */
  PROCEDURE pr_changeTelePin (p_custId         VARCHAR2,
                            p_newpin           VARCHAR2,
                            p_err_code         OUT VARCHAR2,
                            p_err_message      OUT VARCHAR2)
  IS
  l_custodycd     cfmast.custodycd%TYPE;
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_changeTelePin');
    p_err_code := '0';
    p_err_message := '';
    BEGIN
      SELECT custodycd INTO l_custodycd FROM cfmast WHERE custid = p_custId;
    EXCEPTION
      WHEN OTHERS THEN
        p_err_code := '-200002';
        p_err_message := cspks_system.fn_get_errmsg(p_err_code);
        plog.setendsection (pkgctx, 'pr_changeTelePin');
        RETURN;
    END;
    --1.7.4.8/MSBS-2445
    IF NOT(LENGTH(p_newpin)>= 6 and LENGTH(TRIM(TRANSLATE(p_newpin, '0123456789', ' '))) IS NULL) THEN
        p_err_code := '-200520';
        p_err_message := cspks_system.fn_get_errmsg(p_err_code);
        plog.setendsection (pkgctx, 'pr_changeTelePin');
        RETURN;
    END IF;

    fopks_api_rpp.pr_ResetPin (p_custodycd   => l_custodycd,
                              p_newpin      => p_newpin,
                              p_err_code    => p_err_code,
                              p_err_message => p_err_message) ;
    plog.setendsection (pkgctx, 'pr_changeTelePin');
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_changeTelePin');
  END;

  PROCEDURE pr_updatepassonline(p_username varchar,
                              p_pwType   varchar2,
                              p_oldPassWord VARCHAR2,
                              P_password   varchar2,
                              p_err_code  OUT varchar2,
                              p_err_message out varchar2)
  IS
    v_mobile varchar2(20);
    l_datasourcesms varchar2(1000);
    l_count    NUMBER;
    l_role     VARCHAR2(10);
    l_userName VARCHAR2(100) := upper(p_username);
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_updatepassonline');
    p_err_code := 0;
    p_err_message := '';

    -- Check host & branch active or inactive
    p_err_code := fopks_api.fn_CheckActiveSystem;
    IF p_err_code <> systemnums.C_SUCCESS THEN
      p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
      plog.error(pkgctx, 'Error:'  || p_err_message);
      plog.setendsection(pkgctx, 'pr_updatepassonline');
      return;
    END IF;
    BEGIN
      SELECT role INTO l_role FROM (
        SELECT 'C' role FROM userlogin WHERE username = l_userName AND status = 'A'
        UNION ALL
        SELECT 'B' role FROM tlprofiles WHERE tlname = l_userName
      );
    EXCEPTION
      WHEN OTHERS THEN
        p_err_code := -107;
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
        plog.setendsection(pkgctx, 'pr_updatepassonline');
    END;

    IF l_role = 'C' THEN
      v_mobile:='';
      For vc in (select mobile from cfmast where username = l_userName )
      Loop
        v_mobile:=vc.mobile;
      End loop;

      IF p_pwtype = 'LOGINPWD' THEN
        SELECT COUNT(1) INTO l_count
        FROM userLogin u
        WHERE userName = l_userName AND u.status = 'A'
        AND u.loginpwd = genencryptpassword(p_oldPassWord);
        IF NOT l_count > 0 THEN
          p_err_code := -107;
          p_err_message := cspks_system.fn_get_errmsg(p_err_code);
          plog.setendsection(pkgctx, 'pr_updatepassonline');
          RETURN;
        END IF;

        Update userlogin
        Set LOGINPWD= genencryptpassword(P_password),
            ISRESET='N',
            expdate = getcurrdate + (SELECT to_number(varvalue) FROM sysvar WHERE varname = 'EXPDATEPASSONLINE'),
        lastchanged = sysdate
        where username = l_userName AND status = 'A';
        IF length(v_mobile)>1 then
          l_datasourcesms:='select ''Quy khach hang da doi thanh cong mat khau dang nhap vao luc '||TO_CHAR(SYSDATE,'HH24:MI')||' ngay '||to_char(sysdate,'dd/mm/yyyy')||''' detail from dual';
          nmpks_ems.InsertEmailLog(v_mobile, '0335', l_datasourcesms, '');
        END if;
      ELSIF P_PWTYPE= 'TRADINGPWD' THEN
        SELECT COUNT(1) INTO l_count
        FROM userLogin u
        WHERE userName = l_userName AND u.status = 'A'
        AND u.TRADINGPWD = genencryptpassword(p_oldPassWord);
        IF NOT l_count > 0 THEN
          p_err_code := -107;
          p_err_message := cspks_system.fn_get_errmsg(p_err_code);
          plog.setendsection(pkgctx, 'pr_updatepassonline');
          RETURN;
        END IF;

        Update userlogin
        Set TRADINGPWD= genencryptpassword(P_password),
            ISRESET='N',
            expdate = getcurrdate + (SELECT to_number(varvalue) FROM sysvar WHERE varname = 'EXPDATEPASSONLINE'),
            lastchanged = sysdate
        where username = l_userName;
        If length(v_mobile)>1 then
          l_datasourcesms:='select ''Quy khach hang da doi thanh cong mat khau xac thuc/PIN vao luc '||TO_CHAR(SYSDATE,'HH24:MI')||' ngay '||to_char(sysdate,'dd/mm/yyyy')||''' detail from dual';
          nmpks_ems.InsertEmailLog(v_mobile, '0335', l_datasourcesms, '');
        End if;
      END IF;
    ELSE
      SELECT COUNT(1) INTO l_count
      FROM tlprofiles u
      WHERE tlname = l_userName
      AND u.pin = genencryptpassword(p_oldPassWord);
      IF NOT l_count > 0 THEN
        p_err_code := -107;
        p_err_message := cspks_system.fn_get_errmsg(p_err_code);
        plog.setendsection(pkgctx, 'pr_updatepassonline');
        RETURN;
      END IF;
      UPDATE tlprofiles tl SET tl.pin = genencryptpassword(P_password)
      WHERE tl.tlname = l_userName;
    END IF;

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

--1.8.1.2: chuyen tien giua 2 tai khoan luu ky
PROCEDURE pr_Depoacc2Transfer(p_custid VARCHAR2,
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
  p_dcustodycd varchar2(20);
  BEGIN
    plog.setBeginSection (pkgctx, 'pr_Depoacc2Transfer');
    p_err_code := 0;
    p_err_message := '';
     select custodycd into p_dcustodycd from cfmast where custid = p_custid;

    fopks_api.pr_Depoacc2Transfer(p_dcustodycd        => p_dcustodycd,
                                  p_dacctno           => p_dacctno,
                                  p_ccustodycd        => p_ccustodycd,
                                  p_cacctno           => p_cacctno,
                                  p_amount            => p_amount,
                                  p_err_code          => p_err_code,
                                  p_err_message       => p_err_message,
                                  p_ipaddress         => p_ipAddress,
                                  p_via               => p_via,
                                  p_validationtype    => p_validationtype,
                                  p_devicetype        => p_devicetype,
                                  p_device            => p_device,
                                  p_desc              => p_desc);
    plog.setEndSection (pkgctx, 'pr_Depoacc2Transfer');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_message := 'SYSTEM ERROR';
      plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_Depoacc2Transfer');
  END;
-- end
begin
  -- Initialization
  for i in (select * from tlogdebug) loop
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  end loop;
  pkgctx := plog.init ('fopks_ultilityApi',
                      plevel => nvl(logrow.loglevel, 30),
                      plogtable => (nvl(logrow.log4table, 'N') = 'Y'),
                      palert => (nvl(logrow.log4alert, 'N') = 'Y'),
                      ptrace => (nvl(logrow.log4trace, 'N') = 'Y'));
end fopks_ultilityApi;
/
