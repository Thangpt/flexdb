-- Start of DDL Script for Package Body HOSTMSTRADE.TXPKS_#8877EX
-- Generated 16/01/2019 6:10:13 PM from HOSTMSTRADE@FLEX_111

CREATE OR REPLACE 
PACKAGE txpks_#8877ex
/**----------------------------------------------------------------------------------------------------
 ** Module: COMMODITY SYSTEM
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      21/10/2009     Created
 **
 ** (c) 2008 by Financial Software Solutions. JSC.
 ** ----------------------------------------------------------------------------------------------------*/
IS
FUNCTION fn_txPreAppCheck(p_txmsg in out tx.msg_rectype,p_err_code in out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppCheck(p_txmsg in out tx.msg_rectype,p_err_code in out varchar2)
RETURN NUMBER;
FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code in out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code in out varchar2)
RETURN NUMBER;
END;
/


CREATE OR REPLACE 
PACKAGE BODY txpks_#8877ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;
FUNCTION fn_txPreAppCheck(p_txmsg in out tx.msg_rectype,p_err_code in out varchar2)
RETURN NUMBER
IS
    l_strTRADEPLACE varchar2(30);
    v_MaxSameOrd NUMBER;
    l_count      NUMBER;
    l_strAFACCTNO varchar2(30);
    l_strEXPDATE varchar2(30);
    l_strEXECTYPE varchar2(30);
    l_strMATCHTYPE varchar2(30);
    l_strPRICETYPE varchar2(30);
    l_dblQUOTEPRICE number(30,9);
    l_dblORDERQTTY number(30,4);
    l_strCODEID    varchar2(30);
    l_sectype VARCHAR2(10);
    l_strSYMBOL VARCHAR2(20);

BEGIN
   plog.setbeginsection (pkgctx, 'fn_txPreAppCheck');
   plog.debug(pkgctx,'BEGIN OF fn_txPreAppCheck');
   /***************************************************************************************************
    * PUT YOUR SPECIFIC RULE HERE, FOR EXAMPLE:
    * IF NOT <<YOUR BIZ CONDITION>> THEN
    *    p_err_code := '<<ERRNUM>>'; -- Pre-defined in DEFERROR table
    *    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    *    RETURN errnums.C_BIZ_RULE_INVALID;
    * END IF;
    ***************************************************************************************************/


    if p_txmsg.deltd <> 'Y' then

        SELECT SB.SECTYPE,sei.symbol, sb.tradeplace INTO l_sectype,l_strSYMBOL, l_strTRADEPLACE     --1.5.6.0
        FROM SBSECURITIES SB, securities_info sei
        WHERE SB.CODEID = p_txmsg.txfields('01').VALUE
        AND sb.codeid = sei.codeid;

       --begin 1.5.6.0 - chan lenh PLO, MTL,MAK, MOK voi TPDN
      if l_strTRADEPLACE in ('002','005') and l_sectype='012' and trim(p_txmsg.txfields('27').value) in ('MTL','MAK','MOK','PLO') then
          p_err_code := '-700110';
          plog.setendsection (pkgctx, 'fn_txPreAppCheck');
          RETURN errnums.C_BIZ_RULE_INVALID;
        end if;
      --end 1.5.6.0

       --check ma chung quyen dao han
       if fn_check_cwsecurities(l_strSYMBOL) <> 0 then
                p_err_code:='-100128';
                RETURN errnums.C_BIZ_RULE_INVALID;
       end if;

        if not cspks_odproc.fn_checkTradingAllow(p_txmsg.txfields('03').value, p_txmsg.txfields('01').value, 'S', p_err_code) then
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            Return errnums.C_BIZ_RULE_INVALID;
        end if;
       --ThanhNV 1/8/2016 Kiem tra chong trung lenh HNX.
       l_strCODEID := p_txmsg.txfields('01').value;
       plog.debug(pkgctx,'l_lngErrCode: l_strCODEID' || l_strCODEID);
       BEGIN
            SELECT TRADEPLACE INTO l_strTRADEPLACE FROM SBSECURITIES WHERE CODEID= l_strCODEID;
       EXCEPTION
       WHEN no_data_found THEN
            plog.debug(pkgctx,'l_lngErrCode: ' || errnums.C_OD_SECURITIES_INFO_UNDEFINED);
            p_err_code := errnums.C_OD_SECURITIES_INFO_UNDEFINED;
            RETURN  p_err_code;
       END;
       IF l_strTRADEPLACE = errnums.gc_TRADEPLACE_HNCSTC OR  l_strTRADEPLACE = errnums.gc_TRADEPLACE_UPCOM  THEN
           --Lay tham so max order trung nhau trong ordersys.
            Begin
                SELECT sysvalue INTO v_MaxSameOrd FROM ordersys_ha WHERE sysname ='MAXSAMEORD';
            Exception When OTHERS Then
                v_MaxSameOrd:=20;
            End;
            --Lay tong so lenh trung nhau:



            l_strAFACCTNO := p_txmsg.txfields('03').value;
            l_strEXECTYPE := p_txmsg.txfields('22').value;
            l_strMATCHTYPE := p_txmsg.txfields('24').value;
            l_strPRICETYPE := p_txmsg.txfields('27').value;
            l_dblQUOTEPRICE := p_txmsg.txfields('11').value;
            l_dblORDERQTTY := p_txmsg.txfields('12').value;


           plog.debug(pkgctx,'l_lngErrCode: l_strAFACCTNO ' || l_strAFACCTNO ||
                                           ' l_strCODEID ' || l_strCODEID ||
                                           ' l_strEXECTYPE ' || l_strEXECTYPE ||
                                           ' l_strMATCHTYPE ' || l_strMATCHTYPE ||
                                           ' l_strPRICETYPE ' || l_strPRICETYPE ||
                                           ' l_dblQUOTEPRICE ' || l_dblQUOTEPRICE ||
                                           ' l_dblORDERQTTY ' || l_dblORDERQTTY);


            SELECT COUNT(*) into l_count FROM ODMAST WHERE CODEID= l_strCODEID
            AND AFACCTNO IN (SELECT ACCTNO FROM AFMAST WHERE CUSTID=(SELECT CUSTID FROM AFMAST WHERE ACCTNO= l_strAFACCTNO ))
                                                       AND PRICETYPE = l_strPRICETYPE
                                                       AND EXECTYPE=   l_strEXECTYPE
                                                       AND DELTD = 'N'
                                                       AND (PRICETYPE IN ('MTL','MAK','MOK','ATC')
                                                                OR (
                                                                PRICETYPE NOT IN ('MTL','MAK','MOK','ATC') AND QUOTEPRICE = l_dblQUOTEPRICE * 1000
                                                                )
                                                            )
                                                       AND MATCHTYPE =  l_strMATCHTYPE
                                                       AND ORDERQTTY  = l_dblORDERQTTY
                                                       AND REFORDERID IS NULL
                                                       AND TXDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT);
             plog.debug(pkgctx,'l_count '||l_count || ' v_MaxSameOrd '|| v_MaxSameOrd );
            IF  l_count > v_MaxSameOrd -1 THEN
                plog.debug(pkgctx,'l_strAFACCTNO '||l_strAFACCTNO || ' Ma CK '|| l_strCODEID ||' Vuot qua so lenh trung nhau');
                p_err_code := -95046;
                RETURN  p_err_code;
            END IF;

       END IF;
       --ThanhNV End.

    end if;

    plog.debug (pkgctx, '<<END OF fn_txPreAppCheck');
    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'fn_txPreAppCheck');
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txPreAppCheck;

FUNCTION fn_txAftAppCheck(p_txmsg in out tx.msg_rectype,p_err_code in out varchar2)
RETURN NUMBER
IS
    l_lngErrCode number(20,0);
    l_err_param varchar2(1000);
    l_count number(20,0);
    l_strCUSTID varchar2(30);
    l_strCODEID varchar2(30);
    l_strACTYPE varchar2(30);
    l_strAFACCTNO varchar2(30);
    l_strCIACCTNO varchar2(30);
    l_strAFSTATUS varchar2(30);
    l_strSEACCTNO varchar2(30);
    l_strCUSTODYCD varchar2(30);
    l_strTIMETYPE varchar2(30);
    l_strVOUCHER varchar2(30);
    l_strCONSULTANT varchar2(30);
    l_strORDERID varchar2(30);
    l_strBORS varchar2(30);
    l_strContrafirm varchar2(30);
    l_strContrafirm2 varchar2(30);
    l_strContraCus varchar2(30);
    l_strPutType varchar2(30);
    l_strEXPDATE varchar2(30);
    l_strEXECTYPE varchar2(30);
    l_strNORK varchar2(30);
    l_strMATCHTYPE varchar2(30);
    l_strVIA varchar2(30);
    l_strCLEARCD varchar2(30);
    l_strPRICETYPE varchar2(30);
    l_strDESC varchar2(300);
    l_strTRADEPLACE varchar2(30);
    l_strSYMBOL varchar2(30);
    l_strMarginType varchar2(30);
    l_strBUYIFOVERDUE varchar2(30);
    l_strAFTYPE varchar2(30);
    l_dblCLEARDAY number(30,4);
    l_dblQUOTEPRICE number(30,9);
    l_dblORDERQTTY number(30,4);
    l_dblBRATIO number(30,4);
    l_dblLIMITPRICE number(30,4);
    l_dblAFADVANCELIMIT number(30,4);
    l_dblODBALANCE  number(30,4);
    l_dblODTYPETRADELIMIT number(30,4);
    l_dblAFTRADELIMIT number(30,4);
    l_dblALLOWBRATIO number(30,4);
    l_dblDEFFEERATE number(30,4);
    l_dblMarginRate  number(30,4);
    l_dblSecuredRatioMin number(30,4);
    l_dblSecuredRatioMax number(30,4);
    l_dblTyp_Bratio number(30,4);
    l_dblAF_Bratio number(30,4);
    ml_dblSecureRatio number(30,4);
    l_dblRoom number(30,4);
    l_dblTraderID  number(30,4);
    l_blnReversal boolean;
    l_strHalt char(1);
    l_strCompanyFirm varchar2(50);
    l_dblTradeLot number(30,4);
    l_dblTradeUnit number(30,4);
    l_dblFloorPrice number(30,4);
    l_dblCeilingPrice number(30,4);
    l_dblTickSize number(30,4);
    l_dblFromPrice number(30,4);
    l_dblMarginMaxQuantity  number(30,4);
    l_dblBfAccoutMarginRate number(30,4);
    l_dblAfAccoutMarginRate number(30,4);
    l_dblLongPosision number(30,4);
    l_dblBuyMinAmount number(30,4);
    l_dblSellMinAmount number(30,4);
    l_dblCheckMinAmount number(30,4);
    l_strPreventMinOrder varchar2(30);
    l_strTRADEBUYSELL  varchar2(30);
    l_strGRPORDID  varchar2(20);
    l_dblGRPCount number(20,0);
    l_strOVRRQD varchar2(100);
    l_strSETYPE varchar2(10);
    l_DFTRADING number(20,0);
    l_TRADING number(20,0);
    l_strGRPORDER varchar2(1);
    l_dfmastcheck_arr txpks_check.dfmastcheck_arrtype;
    Pl_REFCURSOR   PKG_REPORT.REF_CURSOR;

    l_trade apprules.field%TYPE;
    l_dfmortage apprules.field%TYPE;
    l_semastcheck_arr txpks_check.semastcheck_arrtype;

    v_strORDERTRADEBUYSELL  Varchar2(10);
    l_strControlCode Varchar2(10);
    v_strTemp  Varchar2(100);
    v_strSysCheckBuySell Varchar2(100);

    l_tradingsessionid Varchar2(20);

BEGIN
   plog.setbeginsection (pkgctx, 'fn_txAftAppCheck');
   plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppCheck>>');
   /***************************************************************************************************
    * PUT YOUR SPECIFIC RULE HERE, FOR EXAMPLE:
    * IF NOT <<YOUR BIZ CONDITION>> THEN
    *    p_err_code := '<<ERRNUM>>'; -- Pre-defined in DEFERROR table
    *    plog.setendsection (pkgctx, 'fn_txAftAppCheck');
    *    RETURN errnums.C_BIZ_RULE_INVALID;
    * END IF;
    ***************************************************************************************************/
    ---------------------------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------------------------
    l_lngErrCode:= errnums.C_ERRCODE_FO_INVALID_STATUS;
    p_err_code:=0;
    if p_txmsg.deltd='Y' then
        l_blnReversal:=true;
    else
        l_blnReversal:=false;
    end if;
    if l_blnReversal then
        --Xoa giao dich thi check
        SELECT count(1) into l_count FROM ODMAST WHERE TXNUM=p_txmsg.txnum AND TXDATE=TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT) AND ORSTATUS IN ('1','2','8');
        if l_count<=0 then
            plog.debug(pkgctx,'l_lngErrCode: ' || errnums.C_OD_ODMAST_CANNOT_DELETE);
            p_err_code :=errnums.C_OD_ODMAST_CANNOT_DELETE;
            plog.setendsection (pkgctx, 'fn_txAftAppCheck');
            return l_lngErrCode;
        end if;
    else
        --Make giao dich thi check
        l_strCODEID := p_txmsg.txfields('01').value;
        l_strACTYPE := p_txmsg.txfields('02').value;
        l_strAFACCTNO := p_txmsg.txfields('03').value;
        l_strTIMETYPE := p_txmsg.txfields('20').value;
        l_strEXPDATE := p_txmsg.txfields('21').value;
        l_strEXECTYPE := p_txmsg.txfields('22').value;
        l_strNORK := p_txmsg.txfields('23').value;
        l_strMATCHTYPE := p_txmsg.txfields('24').value;
        l_strVIA := p_txmsg.txfields('25').value;
        l_strCLEARCD := p_txmsg.txfields('26').value;
        l_strPRICETYPE := p_txmsg.txfields('27').value;
        l_dblCLEARDAY := p_txmsg.txfields('10').value;
        l_dblQUOTEPRICE := p_txmsg.txfields('11').value;
        l_dblORDERQTTY := p_txmsg.txfields('12').value;
        l_dblBRATIO := p_txmsg.txfields('13').value;
        l_dblLIMITPRICE := p_txmsg.txfields('14').value;
        l_strVOUCHER := p_txmsg.txfields('28').value;
        l_strCONSULTANT := p_txmsg.txfields('29').value;
        l_strORDERID := p_txmsg.txfields('04').value;
        l_strDESC := p_txmsg.txfields('30').value;
        l_strContrafirm := p_txmsg.txfields('31').value;
        l_strContraCus := replace(p_txmsg.txfields('71').value,'.','');
        l_strPutType := replace(p_txmsg.txfields('72').value,'.','');
        l_strContrafirm2 := replace(p_txmsg.txfields('73').value,'.','');

        plog.debug(pkgctx,'fn_txAftAppCheck: ' || p_txmsg.txfields('55').value);
        l_dblGRPCount:=0;
        --HaiLT them de lay truong GRPORDER
        l_strGRPORDER := p_txmsg.txfields('55').value;
        --HaiLT them de lay Group order ID trong truong hop them vao truong VOUCHER
        l_strGRPORDID := p_txmsg.txfields('28').value;
        select count(*) into l_dblGRPCount from ODMAPEXT WHERE ORDERID = l_strGRPORDID;

     l_SEMASTcheck_arr := txpks_check.fn_SEMASTcheck(p_txmsg.txfields('06').value,'SEMAST','ACCTNO');

     l_TRADE := l_SEMASTcheck_arr(0).TRADE;
     l_dfmortage := l_SEMASTcheck_arr(0).DFMORTAGE;

     plog.debug( pkgctx, nvl(l_strGRPORDER,'N') || 'GRPORDER COUNT ' || l_strGRPORDID || '  ' ||l_dblGRPCount );
     -- HaiLT - Neu lenh thoa thuan nhom' or khi sinh lenh con cho thoa thuan nhom thi khong phai kiem tra chung khoan

     if  (nvl(l_strGRPORDER,'N') <> 'Y') and l_dblGRPCount = 0 then
         IF NOT (greatest(to_number(l_TRADE),0) >= to_number(p_txmsg.txfields('96').value*(p_txmsg.txfields('12').value-p_txmsg.txfields('60').value*p_txmsg.txfields('12').value))) THEN
            p_err_code := '-900017';
            plog.setendsection (pkgctx, 'fn_txAftAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
         END IF;
            IF NOT (to_number(l_TRADE)+to_number(l_dfmortage) >= to_number(p_txmsg.txfields('96').value*p_txmsg.txfields('12').value)) THEN
            p_err_code := '-900017';
            plog.setendsection (pkgctx, 'fn_txAftAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
         END IF;
     END IF;
      plog.debug(pkgctx,'kiem tra tiep buoc sau');

--Them check mua ban theo TT 203

        SELECT HALT,TRADEPLACE,SYMBOL into l_strHalt,l_strTRADEPLACE,l_strSYMBOL FROM SBSECURITIES WHERE CODEID= l_strCODEID;
    -- Bat dau kiem tra lenh doi ung

        IF NOT fnc_pass_tradebuysell(l_strAFACCTNO,p_txmsg.txdate,l_strCODEID,l_strEXECTYPE,l_strPRICETYPE,l_strMATCHTYPE,l_strTRADEPLACE,l_strSYMBOL) THEN
        -- Khong cho phep dat lenh cho khi dang co lenh doi ung chua khop
            p_err_code :=errnums.C_OD_ORTHER_ORDER_WAITING;
            plog.setendsection (pkgctx, 'fn_txAftAppCheck');
            Return l_lngErrCode;
        END IF;

    -- Ket thuc chan lenh doi ung

        if p_txmsg.txfields('20').value='G' then
            --Lenh GTC khong phai check
            plog.debug(pkgctx,'Lenh GTC: ');
            plog.setendsection (pkgctx, 'fn_txAftAppCheck');
            Return systemnums.C_SUCCESS;
        end if;

        if l_strEXECTYPE='MS' then
            plog.debug(pkgctx,'Field 95:' || p_txmsg.txfields('95').value);
            plog.debug(pkgctx,'Field 60:' || p_txmsg.txfields('60').value);
            plog.debug(pkgctx,'Field 12:' || p_txmsg.txfields('12').value);
            plog.debug(pkgctx,'Field 96:' || p_txmsg.txfields('96').value);
            begin
                select DFTRADING into l_DFTRADING from v_getDealInfo where acctno = p_txmsg.txfields('95').value;
                select sum(v.dftrading) + max(a.trade - nvl(b.secureamt,0) + nvl(b.sereceiving,0)) trading
                    into l_TRADING
                from v_getDealInfo v, semast a,v_getsellorderinfo b
                where v.afacctno || v.codeid = a.acctno
                and a.ACCTNO = b.seacctno(+)
                and a.AFACCTNO  = p_txmsg.txfields('03').value
                and a.CODEID  = p_txmsg.txfields('01').value;
            exception when others then
                l_DFTRADING:=0;
            end;
            IF NOT (least(l_DFTRADING,l_TRADING) >= p_txmsg.txfields('96').value*p_txmsg.txfields('12').value) AND l_dblGRPCount=0 THEN
                p_err_code := '-269003';
                plog.setendsection (pkgctx, 'fn_txAftAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            END IF;
        end if;

        l_dblALLOWBRATIO:=1;
        plog.debug(pkgctx,'8877HAILT_ACTYPE: ' || l_strACTYPE);
        SELECT count(1) into l_count  FROM ODTYPE WHERE STATUS='Y' AND ACTYPE=l_strACTYPE;
        if l_count<=0 then
            plog.debug(pkgctx,'l_lngErrCode: ' || errnums.C_OD_ODTYPE_NOTFOUND);
            p_err_code :=errnums.C_OD_ODTYPE_NOTFOUND;
            plog.setendsection (pkgctx, 'fn_txAftAppCheck');
            return l_lngErrCode;
        else
            SELECT TRADELIMIT,BRATIO/100,DEFFEERATE/100 into l_dblODTYPETRADELIMIT,l_dblALLOWBRATIO,l_dblDEFFEERATE  FROM ODTYPE WHERE STATUS='Y' AND ACTYPE=l_strACTYPE;
        end if;
        SELECT count(1) into l_count  FROM AFMAST af,AFTYPE aft, MRTYPE mrt WHERE ACCTNO=l_strAFACCTNO  AND af.ACTYPE=aft.ACTYPE and aft.MRTYPE=mrt.ACTYPE;
        if l_count<=0 then
            plog.debug(pkgctx,'l_lngErrCode: ' || errnums.C_CF_AFMAST_NOTFOUND);
            p_err_code :=errnums.C_CF_AFMAST_NOTFOUND;
            plog.setendsection (pkgctx, 'fn_txAftAppCheck');
            return l_lngErrCode;
        else
            l_strCIACCTNO := l_strAFACCTNO;
            l_strSEACCTNO := l_strAFACCTNO || l_strCODEID;
            SELECT af.CUSTID,af.STATUS,af.TRADELINE,af.ADVANCELINE,af.BRATIO,af.MRIRATE,mrt.MRTYPE,MRT.BUYIFOVERDUE,af.ACTYPE AFTYPE
                into l_strCUSTID,l_strAFSTATUS,l_dblAFTRADELIMIT,l_dblAFADVANCELIMIT,l_dblALLOWBRATIO,l_dblMarginRate,l_strMarginType,l_strBUYIFOVERDUE,l_strAFTYPE
            FROM AFMAST af,AFTYPE aft, MRTYPE mrt
            WHERE ACCTNO= l_strAFACCTNO  AND af.ACTYPE=aft.ACTYPE and aft.MRTYPE=mrt.ACTYPE;
        end if;
        --Kiem tra tai khoan Margin neu bi qua han va l_strBUYIFOVERDUE="N" thi khong cho dat lenh mua
        If (l_strEXECTYPE = 'NB' Or l_strEXECTYPE = 'BC') And l_strBUYIFOVERDUE = 'N' Then
            SELECT count(1) into l_count FROM CIMAST CI WHERE OVAMT >0 AND CI.ACCTNO= l_strCIACCTNO;
            if l_count<=0 then
                plog.debug(pkgctx,'l_lngErrCode: ' || errnums.C_MR_ACCTNO_OVERDUE);
                p_err_code :=errnums.C_MR_ACCTNO_OVERDUE;
                plog.setendsection (pkgctx, 'fn_txAftAppCheck');
                return l_lngErrCode;
            end if;
        End If;
        --Kiem tra tai khoan CI co ton tai hay khong
        SELECT count(1) into l_count FROM CIMAST WHERE ACCTNO=l_strCIACCTNO;
        if l_count<=0 then
            plog.debug(pkgctx,'l_lngErrCode: ' || errnums.C_CI_CIMAST_NOTFOUND);
            p_err_code :=errnums.C_CI_CIMAST_NOTFOUND;
            plog.setendsection (pkgctx, 'fn_txAftAppCheck');
            return l_lngErrCode;
        else
            SELECT (BALANCE-ODAMT) into l_dblODBALANCE FROM CIMAST WHERE ACCTNO=l_strCIACCTNO;
        end if;

        --kIEM TRA TAI KHOAN se co ton tai hay khong
        SELECT count(1) into l_count FROM SEMAST WHERE ACCTNO=l_strSEACCTNO;
        if l_count<=0 then
          --Neu khong co thi tu dong mo tai khoan
          SELECT TYP.SETYPE into l_strSETYPE FROM AFMAST AF, AFTYPE TYP WHERE AF.ACTYPE=TYP.ACTYPE AND AF.ACCTNO= l_strAFACCTNO;
          INSERT INTO SEMAST (ACTYPE,CUSTID,ACCTNO,CODEID,AFACCTNO,
                            OPNDATE,LASTDATE,STATUS,IRTIED,IRCD,
                            COSTPRICE,TRADE,MORTAGE,MARGIN,NETTING,
                            STANDING,WITHDRAW,DEPOSIT,LOAN)
                      VALUES (l_strSETYPE, l_strCUSTID, l_strSEACCTNO , l_strCODEID , l_strAFACCTNO ,
                      p_txmsg.txdate,p_txmsg.txdate,'A','Y','001',
                      0,0,0,0,0,0,0,0,0);
        end if;

        --Kiem tra ma khach hang co ton tai hay khong
        SELECT count(1) into l_count FROM CFMAST WHERE CUSTID=l_strCUSTID;
        if l_count<=0 then
            plog.debug(pkgctx,'l_lngErrCode: ' || errnums.C_CF_CUSTOMER_NOTFOUND);
            p_err_code :=errnums.C_CF_CUSTOMER_NOTFOUND;
            plog.setendsection (pkgctx, 'fn_txAftAppCheck');
            return l_lngErrCode;
        else
            SELECT CUSTODYCD into l_strCUSTODYCD FROM CFMAST WHERE CUSTID=l_strCUSTID;
        end if;
        --SELECT HALT,TRADEPLACE,SYMBOL into l_strHalt,l_strTRADEPLACE,l_strSYMBOL FROM SBSECURITIES WHERE CODEID= l_strCODEID;

        -- quyet.kieu check voi ma chung khoan moi len san hoac ck dac biet thi ko duoc giao d?ch thoa thuan
        if l_strMATCHTYPE ='P' and (l_strTRADEPLACE=errnums.gc_TRADEPLACE_HNCSTC or l_strTRADEPLACE=errnums.gc_TRADEPLACE_UPCOM)  then

                    For vc in(select securitytradingstatus
                              from hasecurity_req
                              where symbol =l_strSYMBOL)
                      Loop
                            l_tradingsessionid:= vc.securitytradingstatus;
                      End loop;

                      if l_tradingsessionid in ('1','27') then
                       p_err_code := errnums.C_OD_CODEID_HALT;
                        return l_lngErrCode;
                      end if ;

        end if ;
        ---end quyet.kieu


        If (l_strHalt = 'Y' AND l_strMATCHTYPE <>'P') Then
            p_err_code :=errnums.C_OD_CODEID_HALT;
            plog.setendsection (pkgctx, 'fn_txAftAppCheck');
            return l_lngErrCode;
        end if;
        If (l_strTRADEPLACE = errnums.gc_TRADEPLACE_HCMCSTC Or l_strTRADEPLACE = errnums.gc_TRADEPLACE_HNCSTC) And Length(Trim(l_strCUSTODYCD)) = 0 Then
            p_err_code :=errnums.C_OD_LISTED_NEEDCUSTODYCD;
            plog.setendsection (pkgctx, 'fn_txAftAppCheck');
            Return l_lngErrCode;
        End If;
        If l_strTRADEPLACE = errnums.gc_TRADEPLACE_HCMCSTC And (l_strEXECTYPE = 'NB' Or l_strEXECTYPE = 'NS') Then
            --Tham so ham Check TraderID
            SELECT FNC_CHECK_TRADERID( l_strMATCHTYPE ,substr(l_strEXECTYPE ,2,1), l_strVIA ) TRD into l_dblTraderID FROM DUAL;
            If l_dblTraderID = 0 Then
                p_err_code :=errnums.C_OD_TRADERID_NOT_INVALID;
                plog.setendsection (pkgctx, 'fn_txAftAppCheck');
                Return l_lngErrCode;
            End If;
        End If;
        --Check contra sell order when place buy order (2PT)
        If (l_strTRADEPLACE = errnums.gc_TRADEPLACE_UPCOM) And (l_strMATCHTYPE = 'P') And (l_strPutType = 'N') Then
            select varvalue into l_strCompanyFirm from sysvar where grname ='SYSTEM' and varname='COMPANYCD';
            --Neu la lenh Upcom thoa thuan cung cong ty phai kiem tra
            If l_strEXECTYPE = 'NB' Then
                If (l_strContrafirm2 = l_strCompanyFirm Or l_strContrafirm2 = '') Then
                    l_strContrafirm2 := l_strCompanyFirm;
                    If l_strContraCus <> '' Then
                        SELECT COUNT(ROWNUM) into l_count FROM ODMAST OD,OOD OUTOD
                        WHERE OD.orderid = OUTOD.orgorderid AND OD.orstatus IN ('1','2','8')
                        AND OUTOD.oodstatus IN ('N','S') AND OD.orderid =  l_strContraCus  AND OD.EXECTYPE='NS'
                        AND OD.matchtype='P' AND OD.CODEID=l_strCODEID  AND OD.QUOTEPRICE=(l_dblQUOTEPRICE) * 1000
                        AND OD.ORDERQTTY= l_dblORDERQTTY  AND OD.PUTTYPE='N' AND OD.CODEID IN (SELECT CODEID FROM SBSECURITIES WHERE TRADEPLACE= l_strTRADEPLACE );

                        If l_count<=0 Then
                            p_err_code :=errnums.C_OD_CONTRA_ORDER_NOT_FOUND;
                            plog.setendsection (pkgctx, 'fn_txAftAppCheck');
                            Return l_lngErrCode;
                        End If;
                    Else
                        p_err_code :=errnums.C_OD_CONTRA_ORDER_NOT_FOUND;
                        plog.setendsection (pkgctx, 'fn_txAftAppCheck');
                        Return l_lngErrCode;
                    End If;
                End If;
            End If;
        End If;
        SELECT count(1) into l_count FROM SECURITIES_INFO INF, SECURITIES_RISK RSK WHERE INF.CODEID= l_strCODEID  AND INF.CODEID=RSK.CODEID(+);
        if l_count<=0 then
            p_err_code :=errnums.C_OD_SECURITIES_INFO_UNDEFINED;
            plog.setendsection (pkgctx, 'fn_txAftAppCheck');
            Return l_lngErrCode;
        else
            SELECT TRADELOT,TRADEUNIT,NVL(RSK.MRMAXQTTY,0) MRMAXQTTY,nvl(BMINAMT,0) BMINAMT,nvl(SMINAMT,0) SMINAMT,FLOORPRICE,CEILINGPRICE,CURRENT_ROOM,TRADEBUYSELL
            into l_dblTradeLot,l_dblTradeUnit,l_dblMarginMaxQuantity,l_dblBuyMinAmount,l_dblSellMinAmount,l_dblFloorPrice,l_dblCeilingPrice,l_dblRoom,l_strTRADEBUYSELL
            FROM SECURITIES_INFO INF, SECURITIES_RISK RSK WHERE INF.CODEID= l_strCODEID  AND INF.CODEID=RSK.CODEID(+);

            --Kiem tra voi lenh mua sau khi dat tong khoi luong long chung khoan margin khong duoc vuot qua MRMAXQTTY
            If (l_strEXECTYPE = 'NB' Or l_strEXECTYPE = 'BC') And l_strMarginType <> 'N' And l_dblMarginMaxQuantity > 0 Then
                GETMARGINQUANTITYBYSYMBOL(pl_refcursor,l_strSYMBOL);
                loop
                    FETCH pl_refcursor
                         INTO l_dblLongPosision;
                    EXIT WHEN pl_refcursor%NOTFOUND;
                end loop;
                If l_dblMarginMaxQuantity < l_dblLongPosision + l_dblORDERQTTY Then
                    p_err_code :=errnums.C_MR_OVER_SYS_LONG_POSSITION;
                    plog.setendsection (pkgctx, 'fn_txAftAppCheck');
                    Return l_lngErrCode;
                End If;
            End If;
            --'Kiem tra chan min,max amount
            select varvalue into l_strPreventMinOrder from sysvar where grname ='SYSTEM' and varname ='PREVENTORDERMIN';
            If l_strPreventMinOrder = 'Y' Then
                If (l_strEXECTYPE = 'NB' Or l_strEXECTYPE = 'BC') Then
                    l_dblCheckMinAmount := l_dblBuyMinAmount;
                Else
                    l_dblCheckMinAmount := l_dblSellMinAmount;
                End If;
                If l_dblQUOTEPRICE * l_dblORDERQTTY * l_dblTradeUnit < l_dblCheckMinAmount Then
                    p_err_code :=errnums.C_OD_ORDER_UNDER_MIN_AMOUNT;
                    plog.setendsection (pkgctx, 'fn_txAftAppCheck');
                    Return l_lngErrCode;
                End If;
            End If;
            If l_dblTradeUnit > 0 Then
                l_dblQUOTEPRICE := Round(l_dblQUOTEPRICE * l_dblTradeUnit, 6);
            End If;
            --Kiem tra lenh mua nha dau tu nuoc ngoai co con ROOM
            If l_strEXECTYPE = 'NB' And (substr(l_strCUSTODYCD, 4, 1) = 'F' Or substr(l_strCUSTODYCD, 4, 1) = 'E') Then
                --If l_dblORDERQTTY > l_dblRoom Then
                --    p_err_code :=errnums.C_OD_ROOM_NOT_ENOUGH;
                --    Return l_lngErrCode;
                --End If;
                null;
            End If;
            --Kiem tra khoi luong co chia het cho trdelot hay khong

              If l_dblTradeLot > 0 And l_strMATCHTYPE <> 'P' Then
               if    l_strTRADEPLACE ='001' or (l_strTRADEPLACE in ('002','005') and l_dblORDERQTTY>l_dblTradeLot) then
                   If l_dblORDERQTTY Mod l_dblTradeLot <> 0 Then
                        p_err_code :=errnums.C_OD_QTTY_TRADELOT_INCORRECT;
                        plog.setendsection (pkgctx, 'fn_txAftAppCheck');
                    Return l_lngErrCode;
                    End If;
               end if ;
            End If;
            --Kiem tra voi lenh LO thi gia phai nam trong khoang tran san
            plog.debug(pkgctx,'l_strPRICETYPE: ' || l_strPRICETYPE || ' l_dblFloorPrice: ' || l_dblFloorPrice || ' l_dblCeilingPrice: ' || l_dblCeilingPrice );
            --If l_strPRICETYPE = 'LO' Then--HNX_update|iss 1785
                If l_dblQUOTEPRICE < l_dblFloorPrice Or l_dblQUOTEPRICE > l_dblCeilingPrice Then
                    p_err_code :=errnums.C_OD_LO_PRICE_ISNOT_FLOOR_CEIL;
                    plog.setendsection (pkgctx, 'fn_txAftAppCheck');
                    Return l_lngErrCode;
                End If;
           -- End If;
            --Voi lenh LO, stop limit thi kiem tra tick size cua gia
            If l_strPRICETYPE = 'LO' Or l_strPRICETYPE = 'SL' Then
                SELECT count(1) into l_count FROM SECURITIES_TICKSIZE WHERE CODEID=l_strCODEID  AND STATUS='Y'
                       AND TOPRICE>= l_dblQUOTEPRICE AND FROMPRICE<=l_dblQUOTEPRICE;

               -- plog.error (pkgctx, 'l_Count:' || l_count);
               -- plog.error (pkgctx, 'l_dblQUOTEPRICE:' || l_dblQUOTEPRICE);
               -- plog.error (pkgctx, 'l_strCODEID:' || l_strCODEID);
                if l_count<=0 then
                    --Chua dinh nghia TICKSIZE
                    p_err_code :=errnums.C_OD_TICKSIZE_UNDEFINED;
                    plog.setendsection (pkgctx, 'fn_txAftAppCheck');
                    Return l_lngErrCode;
                else
                    SELECT FROMPRICE, TICKSIZE into l_dblFromPrice,l_dblTickSize
                    FROM SECURITIES_TICKSIZE WHERE CODEID=l_strCODEID  AND STATUS='Y'
                       AND TOPRICE>= l_dblQUOTEPRICE AND FROMPRICE<=l_dblQUOTEPRICE;
                    If (l_dblQUOTEPRICE - l_dblFromPrice) Mod l_dblTickSize <> 0 And l_strMATCHTYPE <> 'P' Then
                        p_err_code :=errnums.C_OD_TICKSIZE_INCOMPLIANT;
                        plog.setendsection (pkgctx, 'fn_txAftAppCheck');
                        Return l_lngErrCode;
                    End If;
                end if;
            End If;
        /*    --Kiem tra chung khoan khong duoc vua mua vua ban trong ngay
            --OLD
            If l_strTRADEBUYSELL = 'N' Then
                If l_strEXECTYPE = 'NB' Or l_strEXECTYPE = 'BC' Then
                    SELECT COUNT(*)  into l_count FROM ODMAST WHERE CODEID= l_strCODEID  AND AFACCTNO IN (SELECT ACCTNO FROM AFMAST WHERE CUSTID=(SELECT CUSTID FROM AFMAST WHERE ACCTNO= l_strAFACCTNO ))
                    AND (EXECTYPE='NS' OR EXECTYPE='SS' OR EXECTYPE='MS') AND DELTD = 'N' AND EXPDATE >= TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT) AND REMAINQTTY+EXECQTTY>0;
                Else
                    SELECT COUNT(*) into l_count FROM ODMAST WHERE CODEID= l_strCODEID  AND AFACCTNO IN (SELECT ACCTNO FROM AFMAST WHERE CUSTID=(SELECT CUSTID FROM AFMAST WHERE ACCTNO= l_strAFACCTNO ))
                    AND (EXECTYPE='NB' OR EXECTYPE='BC') AND DELTD = 'N' AND EXPDATE >= TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT)  AND REMAINQTTY+EXECQTTY>0;
                End If;
                If l_count > 0 Then
                    --Bao loi khong duoc mua ban mot chung khoan trong cuang 1 ngay
                    p_err_code :=errnums.C_OD_BUYSELL_SAME_SECURITIES;
                    Return l_lngErrCode;
                End If;
            End If;
            */


    --Kiem tra chung khoan khong duoc vua mua vua ban trong ngay
   -- quyet.kieu Ghep them phan mua ban cung ngay theo thong tu 74


--Rao lai cho TT203
/*
 Select VARVALUE Into v_strORDERTRADEBUYSELL from sysvar where GRNAME ='SYSTEM' and VARNAME ='ORDERTRADEBUYSELL' ;

          If v_strORDERTRADEBUYSELL = 'N'  Then
               -- quyet.kieu : khong duoc phep dat lenh cho ( check tat ca cac loai lenh )
               -- kiem tra tat ca cac loai lenh( LO, ATO , ATC ) neu co lenh nguoc chieu chua khop thi khong cho dat lenh

                If l_strEXECTYPE = 'NB' Or l_strEXECTYPE = 'BC' Then
                    SELECT COUNT(*)  into l_count FROM ODMAST WHERE CODEID= l_strCODEID  AND AFACCTNO IN (SELECT ACCTNO FROM AFMAST WHERE CUSTID=(SELECT CUSTID FROM AFMAST WHERE ACCTNO= l_strAFACCTNO ))
                    AND (EXECTYPE='NS' OR EXECTYPE='SS' OR EXECTYPE='MS') AND DELTD = 'N' AND EXPDATE >= TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT) AND REMAINQTTY >0;
                Else
                    SELECT COUNT(*) into l_count FROM ODMAST WHERE CODEID= l_strCODEID  AND AFACCTNO IN (SELECT ACCTNO FROM AFMAST WHERE CUSTID=(SELECT CUSTID FROM AFMAST WHERE ACCTNO= l_strAFACCTNO ))
                    AND (EXECTYPE='NB' OR EXECTYPE='BC') AND DELTD = 'N' AND EXPDATE >= TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT)  AND REMAINQTTY >0;
                End If;

                If l_count > 0 Then
                   -- Khong cho phep dat lenh cho khi dang co lenh doi ung chua khop
                    p_err_code :=errnums.C_OD_ORTHER_ORDER_WAITING;
                    plog.setendsection (pkgctx, 'fn_txAftAppCheck');
                    Return l_lngErrCode;
                End If;

         End if ;

            If l_strTRADEBUYSELL = 'N' Then
                If l_strEXECTYPE = 'NB' Or l_strEXECTYPE = 'BC' Then
                    SELECT COUNT(*)  into l_count FROM ODMAST WHERE CODEID= l_strCODEID  AND AFACCTNO IN (SELECT ACCTNO FROM AFMAST WHERE CUSTID=(SELECT CUSTID FROM AFMAST WHERE ACCTNO= l_strAFACCTNO ))
                    AND (EXECTYPE='NS' OR EXECTYPE='SS' OR EXECTYPE='MS') AND DELTD = 'N' AND EXPDATE >= TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT) AND REMAINQTTY+EXECQTTY>0;
                Else
                    SELECT COUNT(*) into l_count FROM ODMAST WHERE CODEID= l_strCODEID  AND AFACCTNO IN (SELECT ACCTNO FROM AFMAST WHERE CUSTID=(SELECT CUSTID FROM AFMAST WHERE ACCTNO= l_strAFACCTNO ))
                    AND (EXECTYPE='NB' OR EXECTYPE='BC') AND DELTD = 'N' AND EXPDATE >= TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT)  AND REMAINQTTY+EXECQTTY>0;
                End If;
                If l_count > 0 Then
                    --Bao loi khong duoc mua ban mot chung khoan trong cuang 1 ngay
                    p_err_code :=errnums.C_OD_BUYSELL_SAME_SECURITIES;
                    plog.setendsection (pkgctx, 'fn_txAftAppCheck');
                    Return l_lngErrCode;
                End If;

            Elsif l_strTRADEBUYSELL = 'Y' And l_strTRADEPLACE = errnums.gc_TRADEPLACE_HCMCSTC Then

                 Begin
                   Select VARVALUE into v_strSysCheckBuySell from sysvar where GRNAME ='SYSTEM' and VARNAME ='TRADEBUYSELL';
                 Exception When OTHERS Then
                   v_strSysCheckBuySell:='N';
                 End;

                 If v_strSysCheckBuySell ='N' Then

                                      --Lay thong tin phien
                                      Select sysvalue into l_strControlCode  from ordersys where sysname ='CONTROLCODE';

                                      --Neu dat LO thi check d?? ATC doi ung o phien 2 va LO, ATC doi ung o phien 3.
                                      --Neu dat ATO thi check LO, ATO d?i ?ng.
                                      --?t ATC th?heck ch?n ATC, LO d?i ?ng
                                      If l_strPRICETYPE IN ('LO') And l_strMATCHTYPE <> 'P'   Then

                                            If l_strControlCode ='O' Then
                                                v_strTemp:='ATC';
                                            Elsif l_strControlCode ='A' Then
                                                v_strTemp:='LO,ATC';
                                            End if;

                                      ELSIF l_strPRICETYPE IN ('LO') And l_strMATCHTYPE = 'P'   Then --Lenh thoa thuan thi chan tat ca lenh doi ung.

                                            v_strTemp:='LO,ATO,ATC';

                                      Elsif l_strPRICETYPE IN ('ATO') Then
                                            v_strTemp:='LO,ATO';
                                      Elsif l_strPRICETYPE IN ('ATC') Then
                                            v_strTemp:='LO,ATC';
                                      End if;

                                    If l_strEXECTYPE = 'NB' Or l_strEXECTYPE = 'BC' Then

                                         SELECT COUNT(*)  into l_count FROM ODMAST WHERE CODEID= l_strCODEID
                                         AND AFACCTNO IN (SELECT ACCTNO FROM AFMAST WHERE CUSTID=(SELECT CUSTID FROM AFMAST WHERE ACCTNO= l_strAFACCTNO ))
                                         AND INSTR(v_strTemp,PRICETYPE)>0
                                         AND (EXECTYPE='NS' OR EXECTYPE='SS' OR EXECTYPE='MS') AND DELTD = 'N'
                                         AND EXPDATE >= TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT) AND REMAINQTTY>0;
                                     Else
                                         SELECT COUNT(*) into l_count FROM ODMAST WHERE CODEID= l_strCODEID
                                         AND AFACCTNO IN (SELECT ACCTNO FROM AFMAST WHERE CUSTID=(SELECT CUSTID FROM AFMAST WHERE ACCTNO= l_strAFACCTNO ))
                                         AND INSTR(v_strTemp,PRICETYPE)>0
                                         AND (EXECTYPE='NB' OR EXECTYPE='BC') AND DELTD = 'N'
                                         AND EXPDATE >= TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT)  AND REMAINQTTY >0;
                                     End If;
                                     plog.debug(pkgctx,'v_strTemp: ' || v_strTemp);
                                     If l_count > 0 Then
                                         --Bao loi khong duoc mua ban mot chung khoan trong cuang 1 ngay
                                         p_err_code :=errnums.C_OD_BUYSELL_SAME_SECURITIES;
                                         plog.setendsection (pkgctx, 'fn_txAftAppCheck');
                                         Return l_lngErrCode;
                                     End If;
            End if; --Sysbuysell
        Elsif l_strTRADEBUYSELL = 'Y' And l_strTRADEPLACE = errnums.gc_TRADEPLACE_HNCSTC Then
        --Neu san HNX thi chi check thoan thuan
          Begin
             Select VARVALUE into v_strSysCheckBuySell from sysvar where GRNAME ='SYSTEM' and VARNAME ='TRADEBUYSELL';
           Exception When OTHERS Then
             v_strSysCheckBuySell:='N';
           End;

           If v_strSysCheckBuySell ='N' And l_strMATCHTYPE = 'P'   Then
               v_strTemp:='LO,ATO,ATC';
           End if;
           If l_strEXECTYPE = 'NB' Or l_strEXECTYPE = 'BC' Then

                 SELECT COUNT(*)  into l_count FROM ODMAST WHERE CODEID= l_strCODEID
                     AND AFACCTNO IN (SELECT ACCTNO FROM AFMAST WHERE CUSTID=(SELECT CUSTID FROM AFMAST WHERE ACCTNO= l_strAFACCTNO ))
                     AND INSTR(v_strTemp,PRICETYPE)>0
                     AND (EXECTYPE='NS' OR EXECTYPE='SS' OR EXECTYPE='MS') AND DELTD = 'N'
                     AND EXPDATE >= TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT) AND REMAINQTTY>0;
                 Else
                     SELECT COUNT(*) into l_count FROM ODMAST WHERE CODEID= l_strCODEID
                     AND AFACCTNO IN (SELECT ACCTNO FROM AFMAST WHERE CUSTID=(SELECT CUSTID FROM AFMAST WHERE ACCTNO= l_strAFACCTNO ))
                     AND INSTR(v_strTemp,PRICETYPE)>0
                     AND (EXECTYPE='NB' OR EXECTYPE='BC') AND DELTD = 'N'
                     AND EXPDATE >= TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT)  AND REMAINQTTY >0;
                 End If;
                 plog.debug(pkgctx,'v_strTemp: ' || v_strTemp);
                 If l_count > 0 Then
                     --Bao loi khong duoc mua ban mot chung khoan trong cuang 1 ngay
                     p_err_code :=errnums.C_OD_BUYSELL_SAME_SECURITIES;
                     plog.setendsection (pkgctx, 'fn_txAftAppCheck');
                     Return l_lngErrCode;
                 End If;
        End if;
 -- End kiem tra chung khoan khong duoc vua mua vua ban trong ngay
*/

    end if;
        -- HaiLT bo check han muc TRADELINE
       /* plog.debug(pkgctx,'l_strOVRRQD1: ' || l_strOVRRQD);
        --Kiem tra vuot han muc yeu cau checker duyet
        If l_dblQUOTEPRICE * l_dblORDERQTTY > l_dblODTYPETRADELIMIT Then
            l_strOVRRQD := l_strOVRRQD || errnums.OVRRQS_ORDERTRADELIMIT;
            p_txmsg.ovrrqd := l_strOVRRQD;
        End If;*/

        plog.debug(pkgctx,'l_strOVRRQD2: ' || l_strOVRRQD);
        If l_dblBRATIO < l_dblALLOWBRATIO Then
            l_strOVRRQD := l_strOVRRQD || errnums.OVRRQS_ORDERSECURERATIO;
            p_txmsg.ovrrqd := l_strOVRRQD;
        End If;
        plog.debug(pkgctx,'l_strOVRRQD3: ' || l_strOVRRQD);
       /*
         --Neu vuot qua han muc giao dich cua HD
        SELECT SUM(QUOTEPRICE*ORDERQTTY) AMT into l_count FROM ODMAST WHERE AFACCTNO=l_strAFACCTNO;
        If l_dblQUOTEPRICE * l_dblORDERQTTY + l_count > l_dblAFTRADELIMIT Then
            l_strOVRRQD := l_strOVRRQD || errnums.OVRRQS_AFTRADELIMIT;
            p_txmsg.ovrrqd := l_strOVRRQD;
        End If;
       */
        --Kiem tra neu gia tri ung truoc vuot qua han muc ung truoc trong hop dong thi yeu cau checker duyet
        If (l_strEXECTYPE = 'NB' Or l_strEXECTYPE = 'BC') And l_strMarginType = 'N' Then
            SELECT SUM(QUOTEPRICE*REMAINQTTY*(1+TYP.DEFFEERATE/100)+EXECAMT) ODAMT into l_count
            FROM ODMAST OD, ODTYPE TYP
            WHERE OD.ACTYPE=TYP.ACTYPE
            AND  OD.AFACCTNO= l_strAFACCTNO
            AND OD.TXDATE= TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT)
            AND DELTD <>'Y' AND OD.EXECTYPE IN ('NB','BC') ;
            if l_dblQUOTEPRICE * l_dblORDERQTTY + l_count > l_dblAFADVANCELIMIT + l_dblODBALANCE Then
                p_err_code :=errnums.C_OD_ADVANCELINE_OVER_LIMIT;
                plog.setendsection (pkgctx, 'fn_txAftAppCheck');
                Return l_lngErrCode;
            End If;
        End If;
        plog.debug(pkgctx,'l_strOVRRQD4: ' || l_strOVRRQD);
        If length(Trim(Replace(l_strOVRRQD, errnums.OVRRQS_CHECKER_CONTROL, ''))) > 0 And (length(p_txmsg.chkid) = 0 or p_txmsg.chkid is null) Then
            p_err_code :=errnums.C_CHECKER1_REQUIRED;
        Else
            If InStr(l_strOVRRQD, errnums.OVRRQS_CHECKER_CONTROL) > 0 And (Length(p_txmsg.offid)  = 0 or p_txmsg.offid is null) Then
                p_err_code :=errnums.C_CHECKER2_REQUIRED;
            End If;
        End If;
    end if;
    if p_err_code =errnums.C_CHECKER1_REQUIRED or p_err_code =errnums.C_CHECKER2_REQUIRED then
    FOR I IN (
       SELECT ERRDESC,EN_ERRDESC FROM deferror
       WHERE ERRNUM= p_err_code
    ) LOOP
       l_err_param := i.errdesc;
    END LOOP;
    p_txmsg.txException('ERRSOURCE').value := '';
    p_txmsg.txException('ERRSOURCE').TYPE := 'System.String';
    p_txmsg.txException('ERRCODE').value := p_err_code;
    p_txmsg.txException('ERRCODE').TYPE := 'System.Int64';
    p_txmsg.txException('ERRMSG').value := l_err_param;
    p_txmsg.txException('ERRMSG').TYPE := 'System.String';

    end if;
    ---------------------------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------------------------
   plog.debug (pkgctx, '<<END OF fn_txAftAppCheck>>');
   plog.setendsection (pkgctx, 'fn_txAftAppCheck');
   RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'fn_txAftAppCheck');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAftAppCheck;
FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code in out varchar2)
RETURN NUMBER
IS
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txPreAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txPreAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC PROCESS HERE. . DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    plog.debug (pkgctx, '<<END OF fn_txPreAppUpdate');
    plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
       plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txPreAppUpdate;

FUNCTION fn_txAftAppUpdate(p_txmsg in  tx.msg_rectype,p_err_code in out varchar2)
RETURN NUMBER
IS
    l_lngErrCode number(20,0);
    l_count number(20,0);
    l_strCUSTID varchar2(30);
    l_strCODEID varchar2(30);
    l_strACTYPE varchar2(30);
    l_strAFACCTNO varchar2(30);
    l_strCIACCTNO varchar2(30);
    l_strAFSTATUS varchar2(30);
    l_strSEACCTNO varchar2(30);
    l_strCUSTODYCD varchar2(30);
    l_strTIMETYPE varchar2(30);
    l_strVOUCHER varchar2(30);
    l_strCONSULTANT varchar2(30);
    l_strORDERID varchar2(30);
    l_strBORS varchar2(30);
    l_strContrafirm varchar2(30);
    l_strContrafirm2 varchar2(30);
    l_strContraCus varchar2(30);
    l_strPutType varchar2(30);
    l_strEXPDATE varchar2(30);
    l_strEXECTYPE varchar2(30);
    l_strNORK varchar2(30);
    l_strMATCHTYPE varchar2(30);
    l_strVIA varchar2(30);
    l_strCLEARCD varchar2(30);
    l_strPRICETYPE varchar2(30);
    l_strDESC varchar2(300);
    l_strTRADEPLACE varchar2(30);
    l_strSYMBOL varchar2(30);
    l_strMarginType varchar2(30);
    l_strBUYIFOVERDUE varchar2(30);
    l_strAFTYPE varchar2(30);
    l_dblCLEARDAY number(30,4);
    l_dblQUOTEPRICE number(30,9);
    l_dblORDERQTTY number(30,4);
    l_dblBRATIO number(30,4);
    l_dblLIMITPRICE number(30,4);
    l_dblAFADVANCELIMIT number(30,4);
    l_dblODBALANCE  number(30,4);
    l_dblODTYPETRADELIMIT number(30,4);
    l_dblAFTRADELIMIT number(30,4);
    l_dblALLOWBRATIO number(30,4);
    l_dblDEFFEERATE number(30,4);
    l_dblMarginRate  number(30,4);
    l_dblSecuredRatioMin number(30,4);
    l_dblSecuredRatioMax number(30,4);
    l_dblTyp_Bratio number(30,4);
    l_dblAF_Bratio number(30,4);
    ml_dblSecureRatio number(30,4);
    l_dblRoom number(30,4);
    l_dblTraderID  number(30,4);
    l_blnReversal boolean;
    l_strHalt char(1);
    l_strCompanyFirm varchar2(50);
    l_dblTradeLot number(30,4);
    l_dblTradeUnit number(30,4);
    l_dblFloorPrice number(30,4);
    l_dblCeilingPrice number(30,4);
    l_dblTickSize number(30,4);
    l_dblFromPrice number(30,4);
    l_dblMarginMaxQuantity  number(30,4);
    l_dblBfAccoutMarginRate number(30,4);
    l_dblAfAccoutMarginRate number(30,4);
    l_dblLongPosision number(30,4);
    l_dblBuyMinAmount number(30,4);
    l_dblSellMinAmount number(30,4);
    l_dblCheckMinAmount number(30,4);
    l_strPreventMinOrder varchar2(30);
    l_strTRADEBUYSELL  varchar2(30);
    l_strOVRRQD varchar2(100);
    l_strFEEDBACKMSG varchar2(1000);
    l_strBRID varchar2(30);
    l_strTXDATE varchar2(30);
    l_strTXNUM varchar2(30);
    l_strTXTIME varchar2(30);
    l_strTXDESC varchar2(300);
    l_strCHKID varchar2(30);
    l_strOFFID varchar2(30);
    l_strDELTD varchar2(30);
    l_strEFFDATE varchar2(30);
    l_strMember varchar2(200);
    l_strFOACCTNO varchar2(200);
    l_strTraderid varchar2(30);
    l_strClientID varchar2(30);
    l_strOutPriceAllow varchar2(30);
    l_strDFACCTNO varchar2(20);
    l_strGRPORDER varchar2(1);
    l_strODMAPTYPE varchar2(1);
    l_strGRPORDID  varchar2(20);
    l_dblGRPCount number(20,0);
    --</ TruongLD Add
    l_strTLID varchar2(30);
    --/>
    l_strSSAFACCTNO varchar2(10);
    l_strODMORDERID varchar2(20);
    l_strODMREFID varchar2(20);
    l_dblODMQTTY number(20,0);
    l_dblORDERNUM number(20,0);

     --<QuyetKD add update HNX
     l_dblQuoteQtty number(30,4);
     l_strPtDeal varchar2(15);
    --/>
    Pl_REFCURSOR   PKG_REPORT.REF_CURSOR;
    l_batchname    varchar2(20);
    l_IsFO_Order   varchar2(20);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    ---------------------------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------------------------

    --</ TruongLD Add
    l_strTLID := p_txmsg.tlid;
    --/>

    l_strBRID :=p_txmsg.BRID;
    l_strTXDATE :=p_txmsg.TXDATE;
    l_strTXNUM :=p_txmsg.TXNUM;
    l_strTXTIME :=p_txmsg.TXTIME;
    l_strTXDESC :=p_txmsg.TXDESC;
    l_strOVRRQD :=p_txmsg.OVRRQd;
    l_strCHKID:= p_txmsg.CHKID;
    l_strOFFID:= p_txmsg.OFFID;
    l_strDELTD :=p_txmsg.DELTD;

    l_batchname:=p_txmsg.batchname;
    IF NVL(l_batchname,'') ='ISFO' THEN
       l_IsFO_Order:='Y';
    ELSE
       l_IsFO_Order:='N';
    END IF;


    l_lngErrCode:= errnums.C_ERRCODE_FO_INVALID_STATUS;
    p_err_code:=0;
    if p_txmsg.deltd='Y' then
        l_blnReversal:=true;
    else
        l_blnReversal:=false;
    end if;
    l_strCODEID := p_txmsg.txfields('01').value;
    l_strACTYPE := p_txmsg.txfields('02').value;
    l_strAFACCTNO := p_txmsg.txfields('03').value;
    l_strTIMETYPE := p_txmsg.txfields('20').value;
    l_strEFFDATE:= p_txmsg.txfields('19').value;
    l_strEXPDATE := p_txmsg.txfields('21').value;
    l_strEXECTYPE := p_txmsg.txfields('22').value;
    l_strNORK := p_txmsg.txfields('23').value;
    l_strMATCHTYPE := p_txmsg.txfields('24').value;
    l_strVIA := p_txmsg.txfields('25').value;
    l_strCLEARCD := p_txmsg.txfields('26').value;
    l_strPRICETYPE := p_txmsg.txfields('27').value;
    l_dblCLEARDAY := p_txmsg.txfields('10').value;
    l_dblQUOTEPRICE := p_txmsg.txfields('11').value;
    l_dblORDERQTTY := p_txmsg.txfields('12').value;
    l_dblBRATIO := p_txmsg.txfields('13').value;
    l_dblLIMITPRICE := p_txmsg.txfields('14').value;
    l_strVOUCHER := p_txmsg.txfields('28').value;
    l_strCONSULTANT := p_txmsg.txfields('29').value;
    l_strORDERID := p_txmsg.txfields('04').value;
    l_strDESC := p_txmsg.txfields('30').value;
    l_strMember:= p_txmsg.txfields('50').value;
    l_strContrafirm := p_txmsg.txfields('31').value;
    l_strTraderid := p_txmsg.txfields('32').value;
    l_strClientID := p_txmsg.txfields('33').value;
    l_strOutPriceAllow := p_txmsg.txfields('34').value;
    l_strContraCus := replace(p_txmsg.txfields('71').value,'.','');
    l_strPutType := replace(p_txmsg.txfields('72').value,'.','');
    l_strContrafirm2 := replace(p_txmsg.txfields('73').value,'.','');
    l_strDFACCTNO:=p_txmsg.txfields('95').value;

    plog.debug (pkgctx,'8877ex GRPORDER: ' || p_txmsg.txfields('55').value);
    --HaiLT them cho truong GRPORDER
    l_strGRPORDER:=p_txmsg.txfields('55').value;
    l_dblQuoteQtty:= p_txmsg.txfields('80').value;

    If l_strMATCHTYPE ='P' then
        l_strPtDeal:= p_txmsg.txfields('81').value;
        else
        l_strPtDeal:=null;
    end if;
    select count(*) into l_dblGRPCount from odmapext where orderid =p_txmsg.txfields('28').value;


    begin
        l_strSSAFACCTNO:=p_txmsg.txfields('94').value;
    exception when others then
        l_strSSAFACCTNO:='';
    end;

    --HNX_update|MSBS-1774
    --Lay gia lenh PLO
    IF l_strPRICETYPE IN ('PLO') THEN
        l_strSYMBOL:='';
        SELECT SYMBOL into l_strSYMBOL FROM SBSECURITIES
        WHERE CODEID =l_strCODEID ;
        l_dblLIMITPRICE := FNC_GET_PRICE_PLO(l_strSYMBOL, l_strEXECTYPE);
        l_dblQUOTEPRICE := FNC_GET_PRICE_PLO(l_strSYMBOL, l_strEXECTYPE);
    END IF;
    --End HNX_update|MSBS-1774

    If l_strTIMETYPE = 'G' And substr(l_strORDERID,1, 2) <> errnums.C_FO_PREFIXED Then
        --Neu la lenh Good till cancel, ma la lenh dat
        If l_blnReversal Then
            SELECT count(1) into l_count FROM FOMAST WHERE ACCTNO =l_strORDERID  AND STATUS <> 'P';
            If l_count > 0 Then
                --Khong the xoa lenh nay
                p_err_code :=errnums.C_ERRCODE_FO_INVALID_STATUS;
                plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                Return l_lngErrCode;
            End If;
            --Xoa giao dich
            DELETE FROM FOMAST WHERE ACCTNO =l_strORDERID ;
        Else
            --Day lenh vao FOMAST
            --Lay ra ma chung khoan
            l_strSYMBOL:='';
            SELECT SYMBOL into l_strSYMBOL FROM SBSECURITIES WHERE CODEID =l_strCODEID ;
            l_strFEEDBACKMSG := l_strDESC;
            INSERT INTO FOMAST (ACCTNO, ORGACCTNO, ACTYPE, AFACCTNO, STATUS, EXECTYPE, PRICETYPE, TIMETYPE,
                MATCHTYPE, NORK, CLEARCD, CODEID, SYMBOL,
                CONFIRMEDVIA, BOOK, FEEDBACKMSG, ACTIVATEDT, CREATEDDT, CLEARDAY, QUANTITY, PRICE, QUOTEPRICE,
                TRIGGERPRICE, EXECQTTY, EXECAMT, REMAINQTTY,EFFDATE,EXPDATE,BRATIO,VIA,OUTPRICEALLOW,TXNUM,TXDATE,DFACCTNO,QUOTEQTTY,LIMITPRICE)
                VALUES ( l_strORDERID , l_strORDERID, l_strACTYPE, l_strAFACCTNO,'P',
                 l_strEXECTYPE, l_strPRICETYPE, l_strTIMETYPE, l_strMATCHTYPE,
                 l_strNORK, l_strCLEARCD, l_strCODEID, l_strSYMBOL,
                'N','A', l_strFEEDBACKMSG,TO_CHAR(SYSDATE,'DD/MM/RRRR HH:MM:SS'),TO_CHAR(SYSDATE,'DD/MM/RRRR HH:MM:SS'),
                 l_dblCLEARDAY , l_dblORDERQTTY , l_dblLIMITPRICE , l_dblQUOTEPRICE , 0 , 0 , 0 ,
                 l_dblORDERQTTY ,TO_DATE( l_strEFFDATE ,  systemnums.C_DATE_FORMAT ),TO_DATE( l_strEXPDATE , systemnums.C_DATE_FORMAT),
                 l_dblBRATIO , l_strVIA , l_strOutPriceAllow , p_txmsg.txnum ,
                 TO_DATE( p_txmsg.txdate,  systemnums.C_DATE_FORMAT ),l_strDFACCTNO,l_dblQuoteQTTY,l_dblLIMITPRICE);
        End If;
        plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
        Return systemnums.C_SUCCESS;
    End If;
    --Lenh today hoac Intemediate or cancel
    --Hoac lenh GTC tu dong day vao he thong
    if l_blnReversal then
        SELECT count(1) into l_count FROM ODMAST WHERE REFORDERID =l_strORDERID ;
        If l_count > 0 Then
            --khogn the xoa lenh nay
            p_err_code :=errnums.C_OD_ODMAST_CANNOT_DELETE;
            plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
            Return l_lngErrCode;
        End If;
        --Kiem tra lenh co dc xoa hay khong
        SELECT count(1) into l_count FROM ODMAST WHERE TXNUM=p_txmsg.txnum  AND TXDATE=TO_DATE( p_txmsg.txdate , systemnums.C_DATE_FORMAT) AND ORSTATUS IN ('1','2','8');
        If l_count <= 0 Then
            --Khong dc xoa lenh nay
            p_err_code :=errnums.C_OD_ODMAST_CANNOT_DELETE;
            plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
            Return l_lngErrCode;
        End If;
        --Xoa giao dich
        UPDATE ODMAST SET DELTD='Y' WHERE TXNUM=p_txmsg.txnum  AND TXDATE=TO_DATE( p_txmsg.txdate , systemnums.C_DATE_FORMAT);
        UPDATE OOD SET DELTD='Y' WHERE TXNUM=p_txmsg.txnum  AND TXDATE=TO_DATE( p_txmsg.txdate , systemnums.C_DATE_FORMAT);


        --HaiLT them neu xoa lenh nhom thi phai xoa lenh con neu co
        if  p_txmsg.tltxcd='8877' and l_dblGRPCount>0 then
            UPDATE ODMAST SET DELTD='Y', EXECAMT=0, EXECQTTY=0, REMAINQTTY=0, CANCELQTTY= ORDERQTTY, ORSTATUS=2 WHERE ORDERID=p_txmsg.txfields('28').value;
            UPDATE OOD SET DELTD='Y' WHERE ORGORDERID=p_txmsg.txfields('28').value;
            UPDATE IOD SET DELTD='Y' WHERE ORGORDERID=p_txmsg.txfields('28').value;
            UPDATE STSCHD SET DELTD='Y' WHERE ORGORDERID=p_txmsg.txfields('28').value;
/*
            for rec in (SELECT * FROM ODMAPEXT WHERE ORDERID=p_txmsg.txfields('28').value and deltd<>'Y' )
            LOOP
                if rec.type IN ('S','O')  then
                    UPDATE SEMAST SET TRADE=TRADE+rec.QTTY, GRPORDAMT=GRPORDAMT-rec.qtty where  acctno= rec.refid;
                END IF;
                if rec.type IN ('D','M') THEN
                    UPDATE DFMAST SET DFQTTY=DFQTTY+rec.QTTY, GRPORDAMT=GRPORDAMT-rec.qtty where  acctno= rec.refid;
                    UPDATE SEMAST SET MORTAGE = MORTAGE + rec.QTTY  where  acctno in (SELECT AFACCTNO || CODEID FROM DFMAST WHERE ACCTNO = rec.refid);
                end if;

            END LOOP;
*/
            UPDATE ODMAPEXT SET DELTD='Y' WHERE ORDERID=p_txmsg.txfields('28').value;

        end if;



    else
        --HaiLT them cho lenh ban' con cua lenh nhom'
        if  p_txmsg.tltxcd='8877' and l_dblGRPCount>0 then
            UPDATE ODMAST SET DELTD='Y', EXECAMT=0, EXECQTTY=0, REMAINQTTY=0, CANCELQTTY= ORDERQTTY, ORSTATUS=2 WHERE ORDERID=p_txmsg.txfields('28').value;
            UPDATE OOD SET DELTD='Y' WHERE ORGORDERID=p_txmsg.txfields('28').value;
            UPDATE IOD SET DELTD='Y' WHERE ORGORDERID=p_txmsg.txfields('28').value;
            UPDATE STSCHD SET DELTD='Y' WHERE ORGORDERID=p_txmsg.txfields('28').value;
            --UPDATE ODMAPEXT SET DELTD='Y' WHERE ORDERID=p_txmsg.txfields('28').value;

            plog.debug (pkgctx,'8877HAILT_GROUP ORDERID: ' || l_strVOUCHER || ' REFID: ' || p_txmsg.txfields('94').value || ' ' || 'l_dblORDERQTTY: ' || l_dblORDERQTTY );

            SELECT ORDERID, QTTY, ORDERNUM, TYPE into l_strODMORDERID, l_dblODMQTTY, l_dblORDERNUM, l_strODMAPTYPE FROM ODMAPEXT WHERE ORDERID= l_strVOUCHER AND REFID = p_txmsg.txfields('94').value
                    AND QTTY = l_dblORDERQTTY AND DELTD <>'Y' AND STATUS <> 'Y' ;
            -- S: Chung khoan giao dich
            -- D: Chung khoan cam co
            -- O: Chung khoan giao dich CHUA KHOP
            -- M: Chung khoan cam co CHUA KHOP

            plog.debug (pkgctx,'SAU KHI 8877HAILT_GROUP EXECTYPE: l_strEXECTYPE ' || l_strEXECTYPE || ' EXECTYPE SO: ' || p_txmsg.txfields('22').value );

            IF l_strODMAPTYPE = 'M' THEN

                plog.debug (pkgctx,'SAU KHI HAILT_GROUP TYPE = M : ');

                UPDATE DFMAST SET DFQTTY=DFQTTY+l_dblORDERQTTY, GRPORDAMT=GRPORDAMT-l_dblORDERQTTY
                        WHERE ACCTNO = to_char(p_txmsg.txfields('94').value);

                UPDATE SEMAST SET MORTAGE = MORTAGE +l_dblORDERQTTY WHERE ACCTNO IN (SELECT AFACCTNO||CODEID FROM DFMAST WHERE ACCTNO = to_char(p_txmsg.txfields('94').value));

                plog.debug (pkgctx,'UPDATE = M : ' || l_strVOUCHER || ' REFID: ' || p_txmsg.txfields('95').value || ' ' || 'l_dblORDERQTTY: ' || l_dblORDERQTTY );

                UPDATE ODMAPEXT SET STATUS='Y',DELTD='Y' WHERE ORDERID= l_strVOUCHER AND REFID = p_txmsg.txfields('95').value AND QTTY = l_dblORDERQTTY AND DELTD <>'Y' AND STATUS <> 'Y';

            elsif l_strODMAPTYPE = 'D' THEN

                plog.debug (pkgctx,'SAU KHI HAILT_GROUP TYPE = D : ');

                 UPDATE DFMAST SET DFQTTY=DFQTTY+l_dblORDERQTTY, GRPORDAMT=GRPORDAMT-l_dblORDERQTTY WHERE ACCTNO = to_char(p_txmsg.txfields('94').value);

                 UPDATE SEMAST SET MORTAGE = MORTAGE +l_dblORDERQTTY WHERE ACCTNO IN (SELECT AFACCTNO||CODEID FROM DFMAST WHERE ACCTNO = to_char(p_txmsg.txfields('94').value));

                 plog.debug (pkgctx,'UPDATE = D : ' || l_strVOUCHER || ' REFID: ' || p_txmsg.txfields('95').value || ' ' || 'l_dblORDERQTTY: ' || l_dblORDERQTTY );

                 UPDATE ODMAPEXT SET STATUS='Y',DELTD='Y' WHERE ORDERID= l_strVOUCHER AND REFID = p_txmsg.txfields('94').value AND QTTY = l_dblORDERQTTY AND DELTD <>'Y' AND STATUS <> 'Y';

            elsif l_strODMAPTYPE = 'O' THEN

                plog.debug (pkgctx,'SAU KHI HAILT_GROUP TYPE = O : ');

                 UPDATE SEMAST SET TRADE=TRADE+l_dblORDERQTTY, GRPORDAMT=GRPORDAMT-l_dblORDERQTTY
                        WHERE ACCTNO IN (SELECT SEACCTNO FROM ODMAST WHERE ORDERID= to_char(p_txmsg.txfields('94').value));

                 plog.debug (pkgctx,'UPDATE = O : ' || l_strVOUCHER || ' REFID: ' || p_txmsg.txfields('95').value || ' ' || 'l_dblORDERQTTY: ' || l_dblORDERQTTY );

                 UPDATE ODMAPEXT SET STATUS='Y',DELTD='Y' WHERE ORDERID= l_strVOUCHER AND REFID = p_txmsg.txfields('94').value AND QTTY = l_dblORDERQTTY AND DELTD <>'Y' AND STATUS <> 'Y';


            elsif l_strODMAPTYPE = 'S' THEN

                plog.debug (pkgctx,'SAU KHI HAILT_GROUP TYPE = S : ');
                UPDATE SEMAST SET TRADE=TRADE+l_dblORDERQTTY, GRPORDAMT=GRPORDAMT-l_dblORDERQTTY WHERE ACCTNO = to_char(p_txmsg.txfields('94').value);
                plog.debug (pkgctx,'UPDATE = S : ' || l_strVOUCHER || ' REFID: ' || p_txmsg.txfields('94').value || ' ' || 'l_dblORDERQTTY: ' || l_dblORDERQTTY );
                UPDATE ODMAPEXT SET STATUS='Y',DELTD='Y' WHERE ORDERID= l_strVOUCHER AND REFID = p_txmsg.txfields('94').value AND QTTY = l_dblORDERQTTY AND DELTD <>'Y' AND STATUS <> 'Y';

            END IF;





        end if;


        --Make giao dich
        l_dblALLOWBRATIO := 1;
        SELECT TRADELIMIT,BRATIO into l_dblODTYPETRADELIMIT,l_dblTyp_Bratio  FROM ODTYPE WHERE STATUS='Y' AND ACTYPE=l_strACTYPE ;
        l_dblALLOWBRATIO:=l_dblTyp_Bratio/100;
        SELECT CIACCTNO,CUSTID,STATUS,TRADELINE,ADVANCELINE,BRATIO
        into l_strCIACCTNO,l_strCUSTID,l_strAFSTATUS,l_dblAFTRADELIMIT,l_dblAFADVANCELIMIT,l_dblAF_Bratio
        FROM AFMAST WHERE ACCTNO=l_strAFACCTNO;
        l_strSEACCTNO := l_strAFACCTNO || l_strCODEID;
        l_dblALLOWBRATIO:=l_dblAF_Bratio/100;
        SELECT CUSTODYCD into l_strCUSTODYCD FROM CFMAST WHERE CUSTID= l_strCUSTID;
        SELECT TRADELOT,TRADEUNIT,FLOORPRICE,CEILINGPRICE,SECURERATIOMAX,SECURERATIOTMIN,CURRENT_ROOM,SYMBOL
        into l_dblTradeLot,l_dblTradeUnit,l_dblFloorPrice,l_dblCeilingPrice,l_dblSecuredRatioMax,l_dblSecuredRatioMin,l_dblRoom,l_strSYMBOL
        FROM SECURITIES_INFO WHERE CODEID=l_strCODEID;
        If l_dblTradeUnit > 0 Then
            l_dblQUOTEPRICE := Round(l_dblQUOTEPRICE * l_dblTradeUnit, 6);
            l_dblLIMITPRICE := Round(l_dblLIMITPRICE * l_dblTradeUnit, 6);
        End If;
        If Length(l_strMember) > 0 Then
            l_strCUSTID := l_strMember;
        End If;
        SELECT TO_CHAR(SYSDATE,'HH24:MI:SS') into l_strTXTIME FROM DUAL;
        if l_strTIMETYPE <> 'G' then
            l_strMember:='';
        ELSE --lENH gtc
            BEGIN
                SELECT FOACCTNO INTO l_strMember FROM rootordermap WHERE ORDERID=l_strORDERID;
            EXCEPTION WHEN OTHERS THEN
                l_strMember:= l_strMember;
            END;
        end if;
        -- GET FOACCTNO
        BEGIN
            SELECT FOACCTNO INTO l_strFOACCTNO FROM rootordermap WHERE ORDERID=l_strORDERID;
        EXCEPTION WHEN OTHERS THEN
                l_strFOACCTNO:= '';
        END;

                        INSERT INTO ODMAST (ORDERID,CUSTID,ACTYPE,CODEID,AFACCTNO,SEACCTNO,CIACCTNO,
                                         TXNUM,TXDATE,TXTIME,EXPDATE,BRATIO,TIMETYPE,
                                         EXECTYPE,NORK,MATCHTYPE,VIA,CLEARDAY,CLEARCD,ORSTATUS,PORSTATUS,PRICETYPE,
                                         QUOTEPRICE,STOPPRICE,LIMITPRICE,ORDERQTTY,REMAINQTTY,EXPRICE,EXQTTY,
                                         EXECQTTY,STANDQTTY,CANCELQTTY,ADJUSTQTTY,REJECTQTTY,REJECTCD,VOUCHER,
                                         CONSULTANT,CONTRAFIRM, TRADERID,CLIENTID,FOACCTNO,PUTTYPE,CONTRAORDERID,CONTRAFRM,DFACCTNO, TLID,SSAFACCTNO,GRPORDER,ISDISPOSAL,QUOTEQTTY,PTDEAL,IsFO_Order)
                         VALUES ( l_strORDERID , l_strCUSTID , l_strACTYPE , l_strCODEID , l_strAFACCTNO , l_strSEACCTNO , l_strCIACCTNO
                                         , p_txmsg.txnum ,TO_DATE( p_txmsg.txdate ,  systemnums.C_DATE_FORMAT ), l_strTXTIME
                                         ,TO_DATE( l_strEXPDATE ,  systemnums.C_DATE_FORMAT ), l_dblBRATIO , l_strTIMETYPE
                                         , l_strEXECTYPE , l_strNORK , l_strMATCHTYPE , l_strVIA
                                         , l_dblCLEARDAY , l_strCLEARCD ,case when l_dblGRPCount > 0 then '2' else '8' end,'8', l_strPRICETYPE
                                         , l_dblQUOTEPRICE ,0, l_dblLIMITPRICE , l_dblORDERQTTY , l_dblORDERQTTY , l_dblQUOTEPRICE , l_dblORDERQTTY ,0,0,0,0,0,'001', l_strVOUCHER
                                         , l_strCONSULTANT , l_strContrafirm , l_strTraderid , l_strClientID , l_strFOACCTNO , l_strPutType , l_strContraCus , l_strContrafirm2 ,l_strDFACCTNO
                                         , l_strTLID,l_strSSAFACCTNO,l_strGRPORDER, p_txmsg.txfields('74').value,l_dblQuoteQtty,l_strPtDeal,l_IsFO_Order);
        INSERT INTO OOD (ORGORDERID,CODEID,SYMBOL,CUSTODYCD,
                        BORS,NORP,AORN,PRICE,QTTY,SECUREDRATIO,OODSTATUS,TXDATE,TXNUM,DELTD,BRID)
        VALUES ( l_strORDERID , l_strCODEID , l_strSYMBOL , l_strCUSTODYCD ,'S', l_strMATCHTYPE
                        , l_strNORK , l_dblQUOTEPRICE , l_dblORDERQTTY , l_dblBRATIO ,
                        case when l_dblGRPCount > 0 then 'S' else 'N' end,TO_DATE( p_txmsg.txdate ,  systemnums.C_DATE_FORMAT ), p_txmsg.txnum ,'N', l_strBRID );


        /*
        if p_txmsg.tltxcd='8870' then
        INSERT INTO ODMAST (ORDERID,CUSTID,ACTYPE,CODEID,AFACCTNO,SEACCTNO,CIACCTNO,
                                         TXNUM,TXDATE,TXTIME,EXPDATE,BRATIO,TIMETYPE,
                                         EXECTYPE,NORK,MATCHTYPE,VIA,CLEARDAY,CLEARCD,ORSTATUS,PORSTATUS,PRICETYPE,
                                         QUOTEPRICE,STOPPRICE,LIMITPRICE,ORDERQTTY,REMAINQTTY,
                                         EXECQTTY,STANDQTTY,CANCELQTTY,ADJUSTQTTY,REJECTQTTY,REJECTCD,VOUCHER,CONSULTANT,CONTRAFIRM, TRADERID,CLIENTID,PUTTYPE,CONTRAORDERID,CONTRAFRM, TLID)
                         VALUES ( l_strORDERID , l_strCUSTID , l_strACTYPE , l_strCODEID , l_strAFACCTNO , l_strSEACCTNO , l_strCIACCTNO
                                         , p_txmsg.txnum ,TO_DATE( p_txmsg.txdate ,  systemnums.C_DATE_FORMAT ), l_strTXTIME
                                         ,TO_DATE( l_strEXPDATE ,  systemnums.C_DATE_FORMAT ), l_dblBRATIO , l_strTIMETYPE
                                         , l_strEXECTYPE , l_strNORK , l_strMATCHTYPE , l_strVIA
                                         , l_dblCLEARDAY , l_strCLEARCD ,'1','1', l_strPRICETYPE
                                         , l_dblQUOTEPRICE ,0, l_dblLIMITPRICE , l_dblORDERQTTY ,0,0,0,0,0,0,'001', l_strVOUCHER , l_strCONSULTANT , l_strContrafirm , l_strTraderid , l_strClientID , l_strPutType , l_strContraCus , l_strContrafirm2, l_strTLID );
        elsif p_txmsg.tltxcd='8874' then
        --Ghi nhan vao so lenh
                        INSERT INTO ODMAST (ORDERID,CUSTID,ACTYPE,CODEID,AFACCTNO,SEACCTNO,CIACCTNO,
                                         TXNUM,TXDATE,TXTIME,EXPDATE,BRATIO,TIMETYPE,
                                         EXECTYPE,NORK,MATCHTYPE,VIA,CLEARDAY,CLEARCD,ORSTATUS,PORSTATUS,PRICETYPE,
                                         QUOTEPRICE,STOPPRICE,LIMITPRICE,ORDERQTTY,REMAINQTTY,EXPRICE,EXQTTY,SECUREDAMT,
                                         EXECQTTY,STANDQTTY,CANCELQTTY,ADJUSTQTTY,REJECTQTTY,REJECTCD,VOUCHER,CONSULTANT,FOACCTNO,PUTTYPE,CONTRAORDERID,CONTRAFRM, TLID,SSAFACCTNO)
                         VALUES ( l_strORDERID , l_strCUSTID , l_strACTYPE , l_strCODEID , l_strAFACCTNO , l_strSEACCTNO , l_strCIACCTNO
                                         , p_txmsg.txnum ,TO_DATE( p_txmsg.txdate ,  systemnums.C_DATE_FORMAT ), l_strTXTIME
                                         ,TO_DATE( l_strEXPDATE ,  systemnums.C_DATE_FORMAT ), l_dblBRATIO , l_strTIMETYPE
                                         , l_strEXECTYPE , l_strNORK , l_strMATCHTYPE , l_strVIA
                                         , l_dblCLEARDAY , l_strCLEARCD ,'8','9', l_strPRICETYPE
                                         , l_dblQUOTEPRICE ,0, l_dblLIMITPRICE , l_dblORDERQTTY , l_dblORDERQTTY , l_dblQUOTEPRICE , l_dblORDERQTTY ,0,0,0,0,0,0,'001', l_strVOUCHER , l_strCONSULTANT , l_strFOACCTNO , l_strPutType , l_strContraCus , l_strContrafirm2, l_strTLID,l_strSSAFACCTNO );
                        --Ghi nhan vao OOD
                        INSERT INTO OOD (ORGORDERID,CODEID,SYMBOL,CUSTODYCD,
                                         BORS,NORP,AORN,PRICE,QTTY,SECUREDRATIO,OODSTATUS,TXDATE,TXNUM,DELTD,BRID)
                         VALUES ( l_strORDERID , l_strCODEID , l_strSYMBOL , l_strCUSTODYCD ,'B', l_strMATCHTYPE
                                         , l_strNORK , l_dblQUOTEPRICE , l_dblORDERQTTY , l_dblBRATIO ,'N',TO_DATE( p_txmsg.txdate ,  systemnums.C_DATE_FORMAT ), p_txmsg.txnum ,'N', l_strBRID );

        elsif p_txmsg.tltxcd='8875' then
                        INSERT INTO ODMAST (ORDERID,CUSTID,ACTYPE,CODEID,AFACCTNO,SEACCTNO,CIACCTNO,
                                         TXNUM,TXDATE,TXTIME,EXPDATE,BRATIO,TIMETYPE,
                                         EXECTYPE,NORK,MATCHTYPE,VIA,CLEARDAY,CLEARCD,ORSTATUS,PORSTATUS,PRICETYPE,
                                         QUOTEPRICE,STOPPRICE,LIMITPRICE,ORDERQTTY,REMAINQTTY,EXPRICE,EXQTTY,
                                         EXECQTTY,STANDQTTY,CANCELQTTY,ADJUSTQTTY,REJECTQTTY,REJECTCD,VOUCHER,CONSULTANT,FOACCTNO,PUTTYPE,CONTRAORDERID,CONTRAFRM,DFACCTNO, TLID,SSAFACCTNO,ISDISPOSAL)
                         VALUES ( l_strORDERID , l_strCUSTID , l_strACTYPE , l_strCODEID , l_strAFACCTNO , l_strSEACCTNO , l_strCIACCTNO
                                         , p_txmsg.txnum ,TO_DATE( p_txmsg.txdate ,  systemnums.C_DATE_FORMAT ), l_strTXTIME
                                         ,TO_DATE( l_strEXPDATE ,  systemnums.C_DATE_FORMAT ), l_dblBRATIO , l_strTIMETYPE
                                         , l_strEXECTYPE , l_strNORK , l_strMATCHTYPE , l_strVIA
                                         , l_dblCLEARDAY , l_strCLEARCD ,'8','9', l_strPRICETYPE
                                         , l_dblQUOTEPRICE ,0, l_dblLIMITPRICE , l_dblORDERQTTY , l_dblORDERQTTY , l_dblQUOTEPRICE , l_dblORDERQTTY ,0,0,0,0,0,'001', l_strVOUCHER , l_strCONSULTANT , l_strFOACCTNO , l_strPutType , l_strContraCus , l_strContrafirm2,l_strDFACCTNO, l_strTLID ,l_strSSAFACCTNO, p_txmsg.txfields('74').value);

                        INSERT INTO OOD (ORGORDERID,CODEID,SYMBOL,CUSTODYCD,
                                       BORS,NORP,AORN,PRICE,QTTY,SECUREDRATIO,OODSTATUS,TXDATE,TXNUM,DELTD,BRID)
                        VALUES ( l_strORDERID , l_strCODEID , l_strSYMBOL , l_strCUSTODYCD ,'S', l_strMATCHTYPE
                                       , l_strNORK , l_dblQUOTEPRICE , l_dblORDERQTTY , l_dblBRATIO ,'N',TO_DATE( p_txmsg.txdate ,  systemnums.C_DATE_FORMAT ), p_txmsg.txnum ,'N', l_strBRID );
        elsif p_txmsg.tltxcd='8876' then
                        INSERT INTO ODMAST (ORDERID,CUSTID,ACTYPE,CODEID,AFACCTNO,SEACCTNO,CIACCTNO,
                                         TXNUM,TXDATE,TXTIME,EXPDATE,BRATIO,TIMETYPE,
                                         EXECTYPE,NORK,MATCHTYPE,VIA,CLEARDAY,CLEARCD,ORSTATUS,PORSTATUS,PRICETYPE,
                                         QUOTEPRICE,STOPPRICE,LIMITPRICE,ORDERQTTY,REMAINQTTY,EXPRICE,EXQTTY,SECUREDAMT,
                                         EXECQTTY,STANDQTTY,CANCELQTTY,ADJUSTQTTY,REJECTQTTY,REJECTCD,VOUCHER,CONSULTANT,CONTRAFIRM, TRADERID,CLIENTID,FOACCTNO,PUTTYPE,CONTRAORDERID,CONTRAFRM, TLID,SSAFACCTNO)
                         VALUES ( l_strORDERID , l_strCUSTID , l_strACTYPE , l_strCODEID , l_strAFACCTNO , l_strSEACCTNO , l_strCIACCTNO
                                         , p_txmsg.txnum ,TO_DATE( p_txmsg.txdate ,  systemnums.C_DATE_FORMAT ), l_strTXTIME
                                         ,TO_DATE( l_strEXPDATE ,  systemnums.C_DATE_FORMAT ), l_dblBRATIO , l_strTIMETYPE
                                         , l_strEXECTYPE , l_strNORK , l_strMATCHTYPE , l_strVIA
                                         , l_dblCLEARDAY , l_strCLEARCD ,'8','8', l_strPRICETYPE
                                         , l_dblQUOTEPRICE ,0, l_dblLIMITPRICE , l_dblORDERQTTY , l_dblORDERQTTY , l_dblQUOTEPRICE , l_dblORDERQTTY ,0,0,0,0,0,0,'001', l_strVOUCHER , l_strCONSULTANT , l_strContrafirm , l_strTraderid , l_strClientID , l_strFOACCTNO , l_strPutType , l_strContraCus , l_strContrafirm2, l_strTLID,l_strSSAFACCTNO );
                         INSERT INTO OOD (ORGORDERID,CODEID,SYMBOL,CUSTODYCD,
                                        BORS,NORP,AORN,PRICE,QTTY,SECUREDRATIO,OODSTATUS,TXDATE,TXNUM,DELTD,BRID)
                        VALUES ( l_strORDERID , l_strCODEID , l_strSYMBOL , l_strCUSTODYCD ,'B', l_strMATCHTYPE
                                        , l_strNORK , l_dblQUOTEPRICE , l_dblORDERQTTY , l_dblBRATIO ,'N',TO_DATE( p_txmsg.txdate ,  systemnums.C_DATE_FORMAT ), p_txmsg.txnum ,'N', l_strBRID );

        elsif p_txmsg.tltxcd='8877' then
                        INSERT INTO ODMAST (ORDERID,CUSTID,ACTYPE,CODEID,AFACCTNO,SEACCTNO,CIACCTNO,
                                         TXNUM,TXDATE,TXTIME,EXPDATE,BRATIO,TIMETYPE,
                                         EXECTYPE,NORK,MATCHTYPE,VIA,CLEARDAY,CLEARCD,ORSTATUS,PORSTATUS,PRICETYPE,
                                         QUOTEPRICE,STOPPRICE,LIMITPRICE,ORDERQTTY,REMAINQTTY,EXPRICE,EXQTTY,
                                         EXECQTTY,STANDQTTY,CANCELQTTY,ADJUSTQTTY,REJECTQTTY,REJECTCD,VOUCHER,CONSULTANT,CONTRAFIRM, TRADERID,CLIENTID,FOACCTNO,PUTTYPE,CONTRAORDERID,CONTRAFRM,DFACCTNO, TLID,SSAFACCTNO,GRPORDER,ISDISPOSAL)
                         VALUES ( l_strORDERID , l_strCUSTID , l_strACTYPE , l_strCODEID , l_strAFACCTNO , l_strSEACCTNO , l_strCIACCTNO
                                         , p_txmsg.txnum ,TO_DATE( p_txmsg.txdate ,  systemnums.C_DATE_FORMAT ), l_strTXTIME
                                         ,TO_DATE( l_strEXPDATE ,  systemnums.C_DATE_FORMAT ), l_dblBRATIO , l_strTIMETYPE
                                         , l_strEXECTYPE , l_strNORK , l_strMATCHTYPE , l_strVIA
                                         , l_dblCLEARDAY , l_strCLEARCD ,case when l_dblGRPCount > 0 then '2' else '8' end,'8', l_strPRICETYPE
                                         , l_dblQUOTEPRICE ,0, l_dblLIMITPRICE , l_dblORDERQTTY , l_dblORDERQTTY , l_dblQUOTEPRICE , l_dblORDERQTTY ,0,0,0,0,0,'001', l_strVOUCHER , l_strCONSULTANT , l_strContrafirm , l_strTraderid , l_strClientID , l_strFOACCTNO , l_strPutType , l_strContraCus , l_strContrafirm2 ,l_strDFACCTNO, l_strTLID,l_strSSAFACCTNO,l_strGRPORDER, p_txmsg.txfields('74').value);
                        INSERT INTO OOD (ORGORDERID,CODEID,SYMBOL,CUSTODYCD,
                                        BORS,NORP,AORN,PRICE,QTTY,SECUREDRATIO,OODSTATUS,TXDATE,TXNUM,DELTD,BRID)
                        VALUES ( l_strORDERID , l_strCODEID , l_strSYMBOL , l_strCUSTODYCD ,'S', l_strMATCHTYPE
                                        , l_strNORK , l_dblQUOTEPRICE , l_dblORDERQTTY , l_dblBRATIO ,
                                        case when l_dblGRPCount > 0 then 'S' else 'N' end,TO_DATE( p_txmsg.txdate ,  systemnums.C_DATE_FORMAT ), p_txmsg.txnum ,'N', l_strBRID );

        end if;
        */
    end if;

    plog.debug (pkgctx, '<<END OF fn_txAftAppUpdate');
    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
       plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
       plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAftAppUpdate;

BEGIN
      FOR i IN (SELECT *
                FROM tlogdebug)
      LOOP
         logrow.loglevel    := i.loglevel;
         logrow.log4table   := i.log4table;
         logrow.log4alert   := i.log4alert;
         logrow.log4trace   := i.log4trace;
      END LOOP;
      pkgctx    :=
         plog.init ('TXPKS_#8877EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#8877EX;
/


-- End of DDL Script for Package Body HOSTMSTRADE.TXPKS_#8877EX
