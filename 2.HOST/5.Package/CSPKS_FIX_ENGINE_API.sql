create or replace package CSPKS_FIX_ENGINE_API is

  -- Author  : HOANGDUYANH
  -- Created : 12/02/2018 11:02:54
  -- Purpose : api for check order from fix server

  --Type
  TYPE str_array IS TABLE OF VARCHAR2(500) INDEX BY BINARY_INTEGER;
  FUNCTION Split(p_in_string VARCHAR2, p_delim VARCHAR2) RETURN str_array;
  FUNCTION pr_check_tradelot (p_quantity    IN NUMBER,
                              p_tradePlace   IN VARCHAR2) RETURN NUMBER;
  -- Public function and procedure declarations
---------------------------------process check bloomberg order------------------------
  PROCEDURE sp_process_new_order (pv_err_code   OUT VARCHAR2,
                                  pv_err_msg    OUT VARCHAR2,
                                  p_autoid      IN  NUMBER);

  PROCEDURE sp_process_cancel_order (pv_err_code   OUT VARCHAR2,
                                     pv_err_msg    OUT VARCHAR2,
                                     p_autoid      IN  NUMBER);

	PROCEDURE sp_process_amend_order (pv_err_code   OUT VARCHAR2,
                                    pv_err_msg    OUT VARCHAR2,
                                    p_autoid      IN  NUMBER);
--------------------------------process bloomberg order when confirm, reject----------
/*
 * p_action: CF: confirm, RJ: reject
 */
  PROCEDURE sp_update_new_order (p_autoid       VARCHAR2,
                                 p_action       VARCHAR2,
                                 p_text         VARCHAR2 DEFAULT '',
            	                   p_hftOrderId   VARCHAR2 DEFAULT '');
  PROCEDURE sp_update_cancel_order (p_blOrderID       VARCHAR2,
                                   	p_blRefOrderID    VARCHAR2,
                                    p_action          VARCHAR2,
                                    p_text            VARCHAR2 DEFAULT '',
                                    p_hftOrderId      VARCHAR2 DEFAULT '');
  PROCEDURE sp_update_amend_order (p_blOrderID       VARCHAR2,
                                   p_blRefOrderID    VARCHAR2,
                                   p_action          VARCHAR2,
                                   p_text            VARCHAR2 DEFAULT '',
                                   p_hftOrderId      VARCHAR2 DEFAULT '');
--------------------------------process bloomberg event from hft---------------------
  PROCEDURE sp_new_order_response (pv_err_code OUT VARCHAR2,
                                   p_action        VARCHAR2,
                                   p_hftOrderId    VARCHAR2,
                                   p_text          VARCHAR2 DEFAULT '');
  PROCEDURE sp_cancel_order_response (pv_err_code OUT VARCHAR2,
                                      p_action        VARCHAR2,
                                      p_hftOrderId    VARCHAR2,
                                      p_cancelQtty    NUMBER,
                                      p_text          VARCHAR2 DEFAULT '');
  PROCEDURE sp_amend_order_response (pv_err_code OUT VARCHAR2,
                                     p_action      VARCHAR2,
                                     p_hftOrderId  VARCHAR2,
                                     p_amendQtty   NUMBER,
                                     p_text        VARCHAR2 DEFAULT '');
  PROCEDURE sp_confirm_MK_2_LO (pv_err_code   OUT VARCHAR2,
                                p_hftOrderId      VARCHAR2,
            	                  p_price           VARCHAR2);
  PROCEDURE sp_matching_order (pv_err_code    OUT VARCHAR2,
                               p_hftOrderId       VARCHAR2,
                               p_qtty             NUMBER,
                               p_price            NUMBER);
  PROCEDURE sp_order_done4day (pv_err_code    OUT VARCHAR2,
                               p_hftOrderId       VARCHAR2);
--------------------------------process request from ws---------------------
  PROCEDURE sp_confirm_order (pv_err_code    OUT VARCHAR2,
                              pv_err_msg     OUT VARCHAR2,
                              p_blOrderId        VARCHAR2,
                              p_priceChkType     VARCHAR2,
                              p_tlid             VARCHAR2);
  PROCEDURE sp_reject_order (pv_err_code    OUT VARCHAR2,
                             pv_err_msg     OUT VARCHAR2,
                             p_blOrderId        VARCHAR2,
                             p_tlid             VARCHAR2);
  PROCEDURE sp_add_broker_note (pv_err_code    OUT VARCHAR2,
                                pv_err_msg     OUT VARCHAR2,
                                p_blOrderId        VARCHAR2,
                                p_brokerNote       VARCHAR2,
                                p_tlid             VARCHAR2);
  PROCEDURE sp_place_order (pv_err_code    OUT VARCHAR2,
                           pv_err_msg     OUT VARCHAR2,
                           pv_autoid      OUT VARCHAR2,
                           p_blOrderId        VARCHAR2,
                           p_qtty             NUMBER,
                           p_price            VARCHAR2,
                           p_priceType        VARCHAR2,
                           p_tlid             VARCHAR2);
  PROCEDURE sp_replace_map_order (pv_err_code    OUT VARCHAR2,
                             pv_err_msg     OUT VARCHAR2,
                             pv_autoid      OUT VARCHAR2,
                             p_blOrderId        VARCHAR2,
                             p_orderMapId       VARCHAR2,
                             p_qtty             NUMBER,
                             p_price            VARCHAR2,
                             p_tlid             VARCHAR2);
  PROCEDURE sp_cancel_all_map_order (pv_err_code    OUT VARCHAR2,
                             pv_err_msg     OUT VARCHAR2,
                             pv_autoid      OUT VARCHAR2,
                             p_blOrderId        VARCHAR2,
                             p_tlid             VARCHAR2);
  PROCEDURE sp_cancel_map_order (pv_err_code    OUT VARCHAR2,
                             pv_err_msg     OUT VARCHAR2,
                             pv_autoid      OUT VARCHAR2,
                             p_blOrderId        VARCHAR2,
                             p_orderMapId       VARCHAR2,
                             p_tlid             VARCHAR2);
  PROCEDURE sp_cancel_from_fix (pv_err_code  OUT VARCHAR2,
                             pv_err_msg      OUT VARCHAR2,
                             pv_autoid       OUT VARCHAR2,
                             p_blOrderId         VARCHAR2,
                             p_tlid              VARCHAR2);
  PROCEDURE sp_make_order (pv_err_code    OUT VARCHAR2,
                           pv_err_msg     OUT VARCHAR2,
                           p_Afacctno         VARCHAR2,
                           p_symbol           VARCHAR2,
                           p_qtty             NUMBER,
                           p_price            NUMBER,
                           p_priceType        VARCHAR2,
                           p_side             VARCHAR2,
                           p_tlid             VARCHAR2);
  PROCEDURE sp_replace_broker_order (pv_err_code    OUT VARCHAR2,
                             pv_err_msg     OUT VARCHAR2,
                             pv_autoid      OUT VARCHAR2,
                             p_blOrderId        VARCHAR2,
                             p_qtty             NUMBER,
                             p_price            VARCHAR2,
                             p_tlid             VARCHAR2);
  PROCEDURE sp_done4day (pv_err_code    OUT VARCHAR2,
                         pv_err_msg     OUT VARCHAR2,
                         p_blOrderId        VARCHAR2,
                         p_tlid             VARCHAR2);
  PROCEDURE sp_save_execute_plan (pv_err_code    OUT VARCHAR2,
                                 pv_err_msg      OUT VARCHAR2,
                                 p_blOrderId     IN VARCHAR2,
                                 p_txtPlan       IN VARCHAR2,
                                 p_info          IN VARCHAR2,
                                 p_tlid          IN VARCHAR2);
  PROCEDURE sp_update_map_order (p_mapId        VARCHAR2,
                                 p_blOrderId     VARCHAR2,
                                 p_hftOrderId    VARCHAR2,
                                 p_err_code      VARCHAR2,
                                 p_err_msg       VARCHAR2);
  PROCEDURE sp_update_map_replace_order (p_amend_mapid   VARCHAR2,
                                         p_blOrderId     VARCHAR2,
                                         p_hftOrderId    VARCHAR2,
                                         p_err_code      VARCHAR2,
                                         p_err_msg       VARCHAR2);
  PROCEDURE sp_update_map_cancel_order (p_cancel_mapId VARCHAR2,
                                       p_blOrderId     VARCHAR2,
                                       p_hftOrderId    VARCHAR2,
                                       p_err_code      VARCHAR2,
                                       p_err_msg       VARCHAR2);
  PROCEDURE pr_checkAmendOrder (p_type     OUT VARCHAR2,
                               p_message   OUT VARCHAR2,
                               p_blOrderId     VARCHAR2);
---------------------------------API GET FOR F2------------------------------------------------------
  PROCEDURE pr_GetBlOrder_ByUser (pv_refCursor   OUT pkg_report.ref_cursor,
                                 p_tlid         VARCHAR2,
                                 p_lastChange   VARCHAR2);
  PROCEDURE pr_GetBlMapOrder (pv_refCursor   OUT pkg_report.ref_cursor,
                             p_blOrderId    VARCHAR2);
---------------------------------AUTO ORDER----------------------------------------------------------
  PROCEDURE pr_get_execute_auto_order (pv_order_list OUT Sys_Refcursor);
  PROCEDURE pr_update_execute_auto_order (p_autoid  IN  VARCHAR2,
                                         p_err_code IN VARCHAR2,
                                         p_err_msg  IN VARCHAR2);
  PROCEDURE pr_GetDBPlan (pv_refCursor OUT  pkg_report.ref_cursor,
                         p_blOrderId   VARCHAR2);
end CSPKS_FIX_ENGINE_API;
/
create or replace package body CSPKS_FIX_ENGINE_API is

  pkgctx plog.log_ctx;
  logrow tlogdebug%rowtype;

---------------------------------Utility Function-------------------------------------------------
  FUNCTION Split (p_in_string VARCHAR2, p_delim VARCHAR2) RETURN str_array
  IS
    i       number :=0;
    pos     number :=0;
    lv_str  varchar2(32000) := p_in_string;
    strings str_array;
  BEGIN
    -- determine first chuck of string
    pos := instr(lv_str, p_delim, 1, 1);
    -- while there are chunks left, loop
    WHILE ( pos != 0) LOOP
      -- increment counter
      i := i + 1;
      -- create array element for chuck of string
      strings(i) := substr(lv_str,1,pos-1);
      -- remove chunk from string
      lv_str := substr(lv_str,pos+1,length(lv_str));
      -- determine next chunk
      pos := instr(lv_str,p_delim,1,1);
      -- no last chunk, add to array
      IF pos = 0 THEN
        strings(i+1) := lv_str;
      END IF;
    END LOOP;
    -- return array
    RETURN strings;
  END Split;

  FUNCTION fn_get_blOrderId RETURN VARCHAR2
  IS
  v_currDate       DATE;
  v_seq_bl_odmast  NUMBER;
  v_blOrderId      bl_odmast.blorderid%TYPE;
  BEGIN
    v_currDate := getcurrdate();
    SELECT seq_bl_odmast.nextval INTO v_seq_bl_odmast FROM dual;
    v_blOrderId := TO_CHAR(v_currDate, 'RRRRMMDD')
                || lpad(nvl(substr(v_seq_bl_odmast, -10), v_seq_bl_odmast), 10, '0');
    RETURN v_blOrderId;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN '';
  END;
  FUNCTION fn_get_mapOrderId (p_blOrderId VARCHAR2) RETURN VARCHAR2
  IS
  v_id    VARCHAR2(100);
  v_mapId VARCHAR2(100);
  BEGIN
    v_id := '000000' || seq_bl_mapOrder.Nextval;
    v_mapId:= p_blOrderId || LPAD(SUBSTR(v_id, 6 - LENGTH(v_id), 6), 6, '0');

    RETURN v_mapId;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN seq_bl_mapOrder.Nextval;
  END;
  FUNCTION fn_get_blOrderId_by_hftOrderId (p_hftOrderId      VARCHAR2,
                                           pv_blOrderId      OUT VARCHAR2,
                                           pv_blOrderMapId   OUT VARCHAR2) RETURN NUMBER
  IS
  BEGIN
    SELECT bl.blorderid, mo.mapid
    INTO pv_blOrderId, pv_blOrderMapId
    FROM bl_odmast bl, bl_maporder mo
    WHERE bl.blorderid = mo.blorderid (+)
    AND (bl.hftorderid = p_hftOrderId OR mo.hftorderid = p_hftOrderId);
    RETURN 0;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN -1;
  END;
  FUNCTION fn_get_en_errmg (p_err_code    VARCHAR2) RETURN VARCHAR2
  IS
  l_result    deferror.en_errdesc%TYPE;
  BEGIN
    SELECT en_errdesc INTO l_result
    FROM deferror
    WHERE errnum = p_err_code;
    RETURN l_result;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN '';
  END;
  PROCEDURE pr_cancel_mapOrder_from_fix (p_blOrderId     IN VARCHAR2,
                                         p_exectype      IN VARCHAR2)
  IS
  l_cancel_mapId    bl_maporder.mapid%TYPE;
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_cancel_mapOrder_from_fix');
    FOR rec IN (
      SELECT * FROM bl_maporder
      WHERE blOrderId = p_blOrderId
      AND status NOT IN ('C', 'D', 'M', 'R', 'A')
      AND remainQtty > 0 AND exectype IN ('NB','NS')
    ) LOOP
      l_cancel_mapId := fn_get_mapOrderId (p_blOrderId);
      INSERT INTO bl_maporder (mapid,
                            blorderid,
                            qtty,
                            price,
                            pricetype,
                            exectype,
                            exqtty,
                            exexectype,
                            remainqtty,
                            cancelqtty,
                            refmapid,
                            hftreforderid,
                            tlid,
                            status)
      VALUES (l_cancel_mapId,
           p_blOrderId,
           rec.qtty,
           rec.price,
           rec.priceType,
           p_exectype,
           rec.qtty,
           p_exectype,
           rec.remainqtty,
           rec.cancelqtty,
           rec.mapid,
           rec.hftOrderId,
           '6868',
           'P');
      UPDATE bl_maporder SET status = 'C',
                             pstatus = pstatus || status,
                             last_change = systimestamp
      WHERE mapid = rec.mapid;
    END LOOP;
    plog.setEndSection(pkgctx, 'pr_cancel_mapOrder_from_fix');
  EXCEPTION
    WHEN OTHERS THEN
      RAISE;
      plog.setEndSection(pkgctx, 'pr_cancel_mapOrder_from_fix');
  END;
  FUNCTION pr_check_tradelot (p_quantity    IN NUMBER,
                              p_tradePlace   IN VARCHAR2) RETURN NUMBER
  IS
  BEGIN
    IF p_tradePlace = '001' THEN
      IF MOD(p_quantity, 100) > 0 THEN
        RETURN 1;
      END IF;
    ELSIF p_tradePlace IN ('002', '005') THEN
      IF p_quantity >= 100 AND MOD(p_quantity, 100) > 0 THEN
        RETURN 1;
      END IF;
    END if;
    RETURN 0;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN -1;
  END;
  FUNCTION pr_check_maxQtty (p_quantity    IN NUMBER,
                             p_tradePlace   IN VARCHAR2) RETURN NUMBER
  IS
  l_maxQtty   NUMBER := 0;
  BEGIN
    IF p_tradePlace = '001' THEN
      l_maxQtty := cspks_system.fn_get_sysvar ('BROKERDESK', 'HOSE_MAX_QUANTITY');
    ELSIF p_tradePlace IN ('002', '005') THEN
      l_maxQtty := cspks_system.fn_get_sysvar ('BROKERDESK', 'HNX_MAX_QUANTITY');
    END if;
    IF p_quantity <= l_maxQtty THEN
        RETURN 0;
    END IF;
    RETURN 1;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN -1;
  END;

-------------------------------------------------------------------------------
-------------------------------Process Fix Message-----------------------------
  PROCEDURE sp_process_new_order (pv_err_code   OUT VARCHAR2,
                                  pv_err_msg    OUT VARCHAR2,
                                  p_autoid      IN  NUMBER)
  IS
  v_exp          EXCEPTION;
  v_clordid      FIX_MESSAGE_TEMP.Clordid%TYPE;
  v_account      fix_message_temp.account%TYPE;
  v_side         fix_message_temp.side%TYPE;
  v_symbol       fix_message_temp.symbol%TYPE;
  v_qtty         fix_message_temp.orderqty%TYPE;
  v_price        fix_message_temp.price%TYPE;
  v_OrdType      fix_message_temp.ordtype%TYPE;
  v_TimeInForc   fix_message_temp.timeinforc%TYPE;
  v_HandlInst    fix_message_temp.HandlInst%TYPE;
  v_traderId     fix_message_temp.SenderSubID%TYPE;
  v_securityExchange    fix_message_temp.SecurityExchange%TYPE;
  v_text                fix_message_temp.text%TYPE;
  l_targetStrategy     fix_message_temp.TargetStrategy%TYPE;

  v_count        NUMBER;
  v_refSide      VARCHAR2(10);
  v_refAccount   VARCHAR2(10);
  v_refPriceType VARCHAR2(10);
  v_tradeplace   VARCHAR2(10);
  v_tradelot     NUMBER;
  v_floorprice   NUMBER;
  v_ceilingprice NUMBER;
  v_halt         VARCHAR2(10);
  v_ticksize     NUMBER;

  --v_strMarketStatus   VARCHAR2(10);
  --l_hnxTRADINGID      VARCHAR2(10);
  --v_securitytradingSTS  VARCHAR2(10);
  v_maxTradingVol  NUMBER;

  v_blOrderId   bl_odmast.blorderid%TYPE;
  v_currDate    DATE;
  v_strCurrDate VARCHAR2(10);

  BEGIN
    plog.setBeginSection(pkgctx, 'sp_check_new_order');
    pv_err_code := '0';
    pv_err_msg := '';
    BEGIN
      SELECT clordid, account, side, symbol, orderqty, price, ordtype, timeinforc, HandlInst, SenderSubID, SecurityExchange,
             Text, NVL(TargetStrategy, 0)
      INTO v_clordid, v_account, v_side, v_symbol, v_qtty, v_price, v_OrdType, v_TimeInForc, v_HandlInst, v_traderId, v_securityExchange,
           v_text, l_targetStrategy
      FROM fix_message_temp
      WHERE autoid = p_autoid
      AND status = 'P';
    EXCEPTION
      WHEN OTHERS THEN
        v_clordid := '';
    END;

    IF NOT v_securityExchange = 'VN' THEN
      pv_err_msg  := 'Order security is not security of Vietnam Exchange!';
      RAISE v_exp;
    END IF;

    SELECT COUNT(1) INTO v_count
    FROM fix_message_temp
    WHERE clordid = v_clordid;

    IF length(v_clordid) = 0 OR v_count <> 1 THEN
      pv_err_msg  := 'Duplicate Clordid';
      RAISE v_exp;
    END IF;

    IF v_HandlInst <> '1' -- accept HandlInst = 1 only
      AND v_HandlInst <> '3' THEN -- accept manual order
      pv_err_msg  := 'Invalid HandInst';
      RAISE v_exp;
    END IF;

    Select Count(1) into v_Count
    from bl_register
    where TRIM(blacctno) = TRIM(v_account) AND status = 'A';
    If v_Count =0  Then
      pv_err_msg  := 'Unknown Account No';
      RAISE v_exp;
    End if;

    -- Kiem tra loai lenh dc dat
    Select Count(1) into v_Count
    from bl_register bl
    where blacctno = v_account AND status = 'A';
    If v_Count =0  Then
      pv_err_msg  := 'Account is not allowed to order with this Handle Instruction!';
      RAISE v_exp;
    End if;

    -- Kiem tra TraderID
    Select Count(1) into v_Count
    from bl_traderef
    where blacctno = v_account AND traderid = v_traderId AND status = 'A';
    IF NOT v_Count = 1  Then
      pv_err_msg  := 'Unknown Account No';
      RAISE v_exp;
    End if;

    SELECT bl.afacctno INTO v_refAccount
    FROM bl_register bl
    WHERE bl.blacctno = v_account AND status = 'A';

    SELECT COUNT(1) INTO v_count FROM afmast WHERE acctno = v_refAccount;
    IF v_count = 0 THEN
      pv_err_msg  := 'Unknown Account No';
      RAISE v_exp;
    END IF;

    IF v_side = 1 THEN v_refSide := 'NB';
    ELSIF v_side = 2 THEN v_refSide := 'NS';
    ELSE
      pv_err_msg  := 'Invalid Side';
      RAISE v_exp;
    END IF;
    IF v_OrdType NOT IN ('1', '2', '5', '7') THEN
      pv_err_msg  := 'Unsupported Order Type';
      RAISE v_exp;
    END IF;
    IF v_TimeInForc NOT IN ('0', '1', '2', '3', '4', '7') THEN
      pv_err_msg  := 'Invalid TimeInForce';
      RAISE v_exp;
    END IF;
    IF l_targetStrategy NOT IN ('0', '1', '2', '3') THEN
      pv_err_msg  := 'Unsupported TargetStrategy';
      RAISE v_exp;
    END IF;
    BEGIN
      Select s.tradeplace, i.tradelot, i.floorprice, i.ceilingprice, s.halt
      into v_tradeplace, v_tradelot, v_floorprice, v_ceilingprice, v_halt
      from securities_info i, sbsecurities s
      where i.symbol = v_Symbol
      and i.codeid = s.codeid;
    EXCEPTION
      WHEN OTHERS THEN
        pv_err_msg  := 'Unknown Symbol';
        RAISE v_exp;
    END;
    -- Kiem tra khoi luong phai dung lo GD
    IF v_tradeplace = '001' OR v_HandlInst = '1' THEN
      If pr_check_tradelot(v_qtty, v_tradeplace) != 0 Then
        pv_err_msg  := 'Invalid Trade lot';
        RAISE v_exp;
      End If;
    END IF;
    -- Kiem tra CK phai khong o trang thai tam ngung GD
    If v_halt = 'Y' Then
      pv_err_msg  := 'Securities is suspended for trading';
      RAISE v_exp;
    End If;

    SELECT to_number(varvalue) INTO v_maxTradingVol
    FROM sysvar
    WHERE varname = DECODE(v_tradeplace, '001', 'HOSE_MAX_QUANTITY', 'HNX_MAX_QUANTITY')
    AND grname = 'BROKERDESK';
    IF v_qtty > v_maxTradingVol AND v_HandlInst = '1' THEN
      pv_err_msg  := 'Over order qtty maximum ' || v_maxTradingVol;
      RAISE v_exp;
    END IF;

    v_refPriceType := case when v_OrdType ='2' AND v_TimeInForc = '0' then 'LO'
                           when v_OrdType ='5' AND v_TimeInForc = '0' then 'ATC'
                           --when v_OrdType ='2' AND v_TimeInForc = '1' then 'LO' --not support
                           when v_OrdType ='1' AND v_TimeInForc = '0' then 'MP'
                           when v_OrdType ='1' AND v_TimeInForc = '2' then 'ATO'
                           when v_OrdType ='1' AND v_TimeInForc = '4' then 'MOK'
                           when v_OrdType ='1' AND v_TimeInForc = '3' then 'MAK'
                           when v_OrdType ='7' AND v_TimeInForc = '0' then 'MTL'
                           when v_OrdType ='5' AND v_TimeInForc = '7' then 'ATC'
                           else 'ERR' end;
    IF v_refPriceType = 'ERR' THEN
      pv_err_msg  := 'Invalid OrderType or TimeInForce';
      RAISE v_exp;
    END IF;
    IF v_refPriceType = 'LO' THEN
      -- Kiem tra gia tran san
      IF v_price < v_floorprice OR v_price > v_ceilingprice THEN
        pv_err_msg  := 'Order price is not between floor price and ceiling price.';
        RAISE v_exp;
      END IF;
      SELECT count(1) into v_Count
      FROM SECURITIES_TICKSIZE
      WHERE symbol = v_Symbol AND STATUS = 'Y'
        AND TOPRICE >= v_price AND FROMPRICE <= v_price;
      if v_Count <= 0 then
        --Chua dinh nghia TICKSIZE
        pv_err_msg  := 'Ticksize undefined';
        RAISE v_exp;
      else
        SELECT mod(v_price, ticksize)
        INTO v_ticksize
        FROM SECURITIES_TICKSIZE
        WHERE symbol = v_Symbol AND STATUS = 'Y'
        AND TOPRICE >= v_price AND FROMPRICE <= v_price;
        If v_ticksize <> 0  Then
          pv_err_msg  := 'Ticksize incompliant';
          RAISE v_exp;
        End If;
      end if;
    ELSE
      IF v_refSide = 'NB' THEN
        v_price := v_ceilingprice;
      ELSE
        v_price := v_floorprice;
      END IF;
    END IF;

    -- Check lenh phu hop voi san GD
    IF v_refPricetype in ('MOK','MAK','MTL') AND v_tradeplace = '001' THEN
      pv_err_msg  := v_refPricetype || ' order is not supported in this exchange';
      RAISE v_exp;
    ELSIF v_refPricetype in ('MP','ATO') AND v_tradeplace in ('002','005') THEN
      pv_err_msg  := v_refPricetype || ' order is not supported in this exchange';
      RAISE v_exp;
    END IF;

/*    -- Kiem tra lenh phai phu hop voi phien dat lenh
    If v_refPriceType = 'ATO' AND v_tradeplace = '001' THEN
      select sysvalue into v_strMarketStatus  from ordersys where sysname='CONTROLCODE';
      If v_strMarketStatus not in ('P','J') Then
        pv_err_msg  := v_refPricetype || ' order is not allowed in this session of stock exchange';
        RAISE v_exp;
      End If;
   End If;*/

/*    If v_refPriceType = 'MP' AND v_tradeplace = '001' THEN
      select sysvalue into v_strMarketStatus  from ordersys where sysname='CONTROLCODE';
      If v_strMarketStatus NOT IN ('I','O','P') Then
        pv_err_msg  := v_refPriceType || ' order is not allowed in this session of stock exchange';
        RAISE v_exp;
      End If;
    End If;*/

/*    SELECT sysvalue
    INTO l_hnxTRADINGID
    FROM ordersys_ha
    WHERE sysname = 'TRADINGID';

    IF v_refPriceType IN ('MTL','MOK','MAK') AND l_hnxTRADINGID IN ('CLOSE','CLOSE_BL') AND v_tradeplace in ('002','005') THEN
      pv_err_msg  := v_refPriceType || ' order is not allowed in this session of stock exchange';
      RAISE v_exp;
    END IF;*/

/* --  Lenh LO upcom duoc giao dich phien thoa thuan
    IF l_hnxTRADINGID = 'PCLOSE' AND v_tradeplace in ('002') THEN
      pv_err_msg  := v_refPriceType || ' order is not allowed in this session of stock exchange';
      RAISE v_exp;
    END IF;*/

/*    if v_tradeplace in ('002','005') then
      begin
        select nvl(securitytradingstatus,'17')
        into v_securitytradingSTS
        from hasecurity_req
        where symbol=v_Symbol;
      exception when others then
        v_securitytradingSTS:='17';
      end;
      if v_securitytradingSTS in ('1','27') and v_qtty < 100  then
        pv_err_msg  := v_refPriceType || ' order is not allowed in this session of stock exchange';
        RAISE v_exp;
      end if ;
    end if;*/

    UPDATE fix_message_temp SET refAccount = v_refAccount,
                                refSide = v_refside,
                                refPriceType = v_refPriceType,
                                status = 'A'
    WHERE autoid = p_autoid;

    v_blOrderId := fn_get_blOrderId;
    v_currDate := getcurrdate;
    v_strCurrDate := to_char(v_currdate, 'dd/mm/rrrr');
    INSERT INTO bl_odmast(autoid, blorderid, blacctno, afacctno, custodycd, traderid, forefid, status, blodtype,
                          exectype, pricetype, timetype, codeid, symbol, quantity, price, execqtty, execamt,
                          remainqtty, cancelqtty, amendqtty, ptbookqtty, sentqtty, refblorderid, feedbackmsg,
                          activatedt, createddt, txdate, txnum, effdate, expdate, via, deltd, username, direct,
                          last_change, tlid, ptsentqtty, isreasd, orgquantity, orgprice, rootorderid, blinstruction,
                          fixside, fixtimeinforc, fixsendercompid, fixcompid, beginstring, fixordtype, targetstrategy)
    SELECT Seq_Bl_Odmast.Nextval, v_blOrderId, fix.account, af.acctno, cf.custodycd, fix.sendersubid, fix.clordid, 'P', fix.handlinst,
           fix.refside, fix.refpricetype, 'T', sb.codeid, sb.symbol, fix.orderqty, v_price, 0, 0,
           fix.orderqty, 0, 0, 0, DECODE(fix.handlinst, '1', fix.orderqty, 0), '', 'Receive new order',
           v_strCurrDate, v_strCurrDate, v_currDate, '', v_currDate, v_currDate, 'L', 'N', 'BLP', 'Y',
           systimestamp, '6868', 0, 'N', fix.orderqty, fix.price, v_blOrderId, v_text,
           fix.side, fix.timeinforc, fix.sendercompid, fix.targetcompid, fix.beginstring, v_OrdType, l_targetStrategy
    FROM fix_message_temp fix, afmast af, cfmast cf, sbsecurities sb
    WHERE fix.refaccount = af.acctno
    AND af.custid = cf.custid
    AND fix.symbol = sb.symbol
    AND fix.autoid = p_autoid;

  EXCEPTION
    WHEN v_exp THEN
      pv_err_code := '1';
      UPDATE fix_message_temp SET errmsg = pv_err_msg,
                                  errcode = pv_err_code,
                                  status = 'E'
      WHERE autoid = p_autoid;
      plog.setEndSection(pkgctx, 'sp_check_new_order');
    WHEN OTHERS THEN
      pv_err_code := '-1';
      pv_err_msg  := 'System error';
      UPDATE fix_message_temp SET errmsg = pv_err_msg,
                                  errcode = pv_err_code,
                                  status = 'E'
      WHERE autoid = p_autoid;
      plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection(pkgctx, 'sp_check_new_order');
  END;

  PROCEDURE sp_process_cancel_order (pv_err_code   OUT VARCHAR2,
                                    pv_err_msg    OUT VARCHAR2,
                                    p_autoid      IN  NUMBER)
  IS
  v_count             NUMBER;
  v_exp               EXCEPTION;
  v_origClordId       fix_message_temp.origclordid%TYPE;
  v_clordId           fix_message_temp.clordid%TYPE;
  v_qtty              fix_message_temp.orderqty%TYPE;
  v_price             fix_message_temp.price%TYPE;
  v_senderComId       fix_message_temp.sendercompid%TYPE;
  v_targetComId       fix_message_temp.targetcompid%TYPE;
  v_beginString       fix_message_temp.beginstring%TYPE;
  v_text                fix_message_temp.text%TYPE;

  v_blorderid         bl_odmast.blorderid%TYPE;
  v_blodtype          bl_odmast.blodtype%TYPE;
  v_blstatus          bl_odmast.status%TYPE;
  v_blautoid          bl_odmast.autoid%TYPE;
  v_traderid          bl_odmast.traderid%TYPE;
  v_tradeplace        VARCHAR2(10);
  v_pricetype         bl_odmast.pricetype%TYPE;
  v_EDStatus          bl_odmast.edstatus%TYPE;
  v_blAcctno          bl_odmast.blacctno%TYPE;
  v_afAcctno          bl_odmast.afacctno%TYPE;
  v_custodycd         bl_odmast.custodycd%TYPE;

  l_remainQtty        bl_odmast.remainqtty%TYPE;

  v_strMarketStatus   VARCHAR2(10);
  v_HOSession         VARCHAR2(10);
  l_hnxTRADINGID      VARCHAR2(20);

  v_cancel_blorderid  bl_odmast.blorderid%TYPE;
  v_currDate          DATE;
  v_strCurrDate       VARCHAR2(10);

  l_cancel_mapIds     VARCHAR2(1000);
  l_cancel_execType   bl_odmast.exectype%TYPE := '';
  l_execType          bl_odmast.exectype%TYPE;
  l_priceChkType      bl_odmast.pricechktype%TYPE;
  BEGIN
    plog.setBeginSection(pkgctx, 'sp_process_cancel_order');
    pv_err_code := '0';
    pv_err_msg := '';
    v_currDate := getcurrdate;
    v_strCurrDate := to_date(v_currDate, 'dd/mm/rrrr');

    If fopks_api.fn_is_ho_active = false then
      pv_err_msg := 'Exchange Closed';
      RAISE v_exp;
    End if;

    SELECT origClOrdid, clOrdId, orderqty, price, sendersubid, sendercompid, targetcompid, beginString, text
    INTO v_origClordId, v_clordId, v_qtty, v_price, v_traderId, v_senderComId, v_targetComId, v_beginString, v_text
    FROM fix_message_temp f
    WHERE f.autoid = p_autoid;

    SELECT COUNT(1) INTO v_count
    FROM fix_message_temp
    WHERE clordid = v_clordId AND autoid != p_autoid;
    IF v_count > 0 THEN
      pv_err_msg := 'Duplicate Clordid';
      RAISE v_exp;
    END IF;

    SELECT COUNT(1) INTO v_count
    FROM bl_odmast
    WHERE forefid = v_origClordId;
    IF v_count = 0 THEN
      pv_err_msg := 'Unknow order';
      RAISE v_exp;
    END IF;

    BEGIN
      SELECT bl.blorderid, bl.blodtype, bl.status, bl.autoid, bl.traderid,
             sb.tradeplace, bl.custodycd, bl.pricetype, bl.edstatus, bl.blacctno, bl.afacctno,
             bl.remainqtty, bl.exectype, bl.pricechktype
      INTO v_blorderid, v_blodtype, v_blstatus, v_blautoid, v_traderid,
           v_tradeplace, v_custodycd, v_pricetype, v_EDStatus, v_blAcctno, v_afAcctno,
           l_remainQtty, l_execType, l_priceChkType
      FROM bl_odmast bl, sbsecurities sb
      WHERE bl.codeid = sb.codeid and bl.forefid = v_origClordId AND bl.status NOT IN ('N') AND bl.exectype IN ('NB','NS');
      l_cancel_execType := 'C' || substr(l_execType, 2);
    Exception
      When Others THEN
        pv_err_msg := 'Can not cancel this order';
        RAISE v_exp;
    END;

    -- Kiem tra TraderID
    Select Count(1) into v_Count
    from bl_traderef
    where blacctno = v_blAcctno AND traderid = v_traderId AND status = 'A' AND afacctno = v_afAcctno;
    If v_Count =0  Then
      pv_err_msg  := 'Unknown Account No';
      RAISE v_exp;
    End if;

    IF v_EDStatus IN ('A','C') THEN
      pv_err_msg  := 'This Order is in cancel or amendment progress!';
      RAISE v_exp;
    END IF;

    IF v_blstatus IN ('C','R') THEN
      pv_err_msg  := 'This Order was cancelled!';
      RAISE v_exp;
    END IF;

    IF NOT l_remainQtty > 0 THEN
      pv_err_msg  := 'Can not cancel this order!';
      RAISE v_exp;
    END IF;

    /*If v_tradeplace = '001' THEN
      select sysvalue into v_strMarketStatus  from ordersys where sysname='CONTROLCODE';
      If v_strMarketStatus = 'A' THEN
        IF v_pricetype = 'ATC' THEN
          pv_err_msg  := v_pricetype || ' order is not allowed to cancel in this session of stock exchange';
          RAISE v_exp;
        ELSIF v_pricetype = 'LO' THEN
            -- Lay thong tin phien day lenh
            SELECT min(hosesession)
            INTO v_HOSession
            FROM odmast od
            WHERE od.remainqtty > 0 AND od.orstatus IN ('8','4','2') AND od.blorderid = v_blorderid;
            IF v_HOSession = 'A' THEN
              pv_err_msg  := 'This order is not allowed to cancel in this session of stock exchange';
              RAISE v_exp;
            END IF;
        End If;
      END IF;
      If v_strMarketStatus = 'P' THEN
        pv_err_msg  := v_pricetype || ' order is not allowed to cancel in this session of stock exchange';
        RAISE v_exp;
      End If;
    End If;*/

    /*IF v_tradeplace = '002' THEN
      SELECT sysvalue
      INTO l_hnxTRADINGID
      FROM ordersys_ha
      WHERE sysname = 'TRADINGID';

      IF l_hnxTRADINGID IN ('CLOSE_BL')THEN
        pv_err_msg  := v_pricetype || ' order is not allowed to cancel in this session of stock exchange';
        RAISE v_exp;
      END IF;
    END IF;*/

    /*INSERT INTO bl_odmastdtl (autoid, rootorderid, blorderid, adorderid, forefid, status, exectype,
                             via, codeid, symbol, curquantity, curprice, orgquantity, orgprice, newquantity, newprice,
                             execqtty, execamt, remainqtty, cancelqtty, amendqtty, feedbackmsg, deltd, direct)
    SELECT seq_bl_odmastdtl.nextval, v_blorderid, v_blorderid, v_blorderid, v_clordId, 'N', CASE WHEN bl.exectype = 'NB' THEN 'CB' ELSE 'CS' END,
           'L', bl.codeid, bl.symbol, bl.quantity, bl.pricetype, bl.orgquantity, bl.orgprice, bl.quantity, bl.price,
           bl.execqtty, bl.execamt, bl.remainqtty, bl.cancelqtty, bl.amendqtty, 'Receive cancel request', 'N', bl.direct
    FROM bl_odmast bl
    WHERE bl.blorderid = v_blorderid;*/

    IF v_blodtype != '1' THEN
      -- xu ly them cho Lenh Manual
      IF v_tradeplace = '001' THEN
         SELECT sysvalue INTO v_strMarketStatus FROM ordersys WHERE sysname='CONTROLCODE';
         If v_strMarketStatus  IN ('A','P') THEN
           pv_err_msg :=  'Market is in the opening/closing auction.';
           RAISE v_exp;
         END IF;
      END IF;
      IF v_tradeplace ='002' THEN
        SELECT nvl( sysvalue,'CLOSEALL')
        INTO l_hnxTRADINGID
        FROM ordersys_ha
        WHERE sysname = 'TRADINGID';
        IF  l_hnxTRADINGID IN ('CLOSE','CLOSE_BL')THEN
            pv_err_msg := 'Market is in the opening/closing auction.';
            Raise v_exp;
        END IF;
        IF l_hnxTRADINGID IN ('CLOSEALL') THEN
            pv_err_msg := 'Market close!';
            Raise v_exp;
        END IF;
      END IF;
      BEGIN
        INSERT INTO bl_odmast_processing (blorderid, eventname) VALUES (v_blorderid, 'sp_process_cancel_order');
      EXCEPTION
        WHEN OTHERS THEN
          pv_err_msg := 'Order currently in transaction!';
          RAISE v_exp;
      END;
      pr_cancel_mapOrder_from_fix(v_blorderid, l_cancel_execType);
      UPDATE bl_odmast SET cancelQtty = cancelQtty + (quantity - sentQtty),
                           remainQtty = remainQtty - (quantity - sentQtty),
                           feedBackMsg = CASE WHEN quantity = cancelQtty + execQtty THEN 'Cancel order success' ELSE feedBackMsg END
      WHERE blOrderId = v_blorderid;
      IF l_priceChkType = '4' THEN--Huy Kich Ban Da Tao
        UPDATE bl_autoorderplan SET status = 'C' WHERE blorderid = v_blorderid;
      END IF;

    END IF;

    v_cancel_blorderid := fn_get_blOrderId;
    INSERT INTO bl_odmast(autoid, blorderid, blacctno, afacctno, custodycd, traderid, forefid, status,
                         blodtype, exectype, pricetype, timetype, codeid, symbol, quantity, price,
                         execqtty, execamt, remainqtty, cancelqtty, amendqtty, refblorderid, feedbackmsg,
                         activatedt, createddt, txdate, effdate, expdate, via, deltd, username, direct,
                         tlid, refforefid, orgquantity, orgprice, rootorderid, edexectype, blinstruction,
                         fixside, fixordtype, fixtimeinforc, fixsendercompid, fixcompid, beginstring,
                         hftreforderid, origexecqtty, origexecamt, pricechktype, targetstrategy)
    SELECT Seq_Bl_Odmast.Nextval, v_cancel_blorderid, bl.blacctno, bl.afacctno, bl.custodycd, v_traderId, v_clordId, 'N',
           bl.blodtype, bl.exectype, 'LO', bl.timetype, bl.codeid, bl.symbol, bl.quantity, bl.price,
           bl.execqtty, bl.execamt, bl.remainqtty, bl.cancelqtty, bl.amendqtty, bl.blorderid, 'Receive cancel request',
           v_strCurrDate, v_strCurrDate, v_currDate, v_currDate, v_currDate, 'L', 'N', 'BLP', 'Y',
           '6868', bl.forefid, bl.orgquantity, bl.orgprice, bl.rootorderid, 'D', v_text,
           bl.fixside, bl.fixordtype, bl.fixtimeinforc, v_senderComId, v_targetComId, v_beginString,
           bl.hftorderid, bl.execqtty, bl.execamt, bl.pricechktype, bl.targetstrategy
    FROM bl_odmast bl
    WHERE bl.forefid = v_origClordId;

    UPDATE bl_odmast SET edstatus = 'C',
                         last_change = systimestamp
    WHERE blorderid = v_blorderid;

    UPDATE fix_message_temp SET status = 'A' WHERE autoid = p_autoid;

    DELETE bl_odmast_processing WHERE blOrderId = v_blorderid;
    plog.setEndSection(pkgctx, 'sp_process_cancel_order');
  EXCEPTION
    WHEN v_exp THEN
      pv_err_code := '1';
      DELETE bl_odmast_processing WHERE blOrderId = v_blorderid;
      UPDATE fix_message_temp SET errmsg = pv_err_msg,
                                  errcode = pv_err_code,
                                  status = 'E'
      WHERE autoid = p_autoid;
      plog.setEndSection(pkgctx, 'sp_process_cancel_order');
    WHEN OTHERS THEN
      pv_err_code := '-1';
      pv_err_msg := 'System Error';
      ROLLBACK;
      DELETE bl_odmast_processing WHERE blOrderId = v_blorderid;
      UPDATE fix_message_temp SET errmsg = pv_err_msg,
                                  errcode = pv_err_code,
                                  status = 'E'
      WHERE autoid = p_autoid;
      plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection(pkgctx, 'sp_process_cancel_order');
  END;

  PROCEDURE sp_process_amend_order (pv_err_code   OUT VARCHAR2,
                                    pv_err_msg    OUT VARCHAR2,
                                    p_autoid      IN  NUMBER)
  IS
  v_count             NUMBER;
  v_exp               EXCEPTION;
  v_origClordId       fix_message_temp.origclordid%TYPE;
  v_clordId           fix_message_temp.clordid%TYPE;
  v_qtty              fix_message_temp.orderqty%TYPE;
  v_price             fix_message_temp.price%TYPE;
  v_senderComId       fix_message_temp.sendercompid%TYPE;
  v_targetComId       fix_message_temp.targetcompid%TYPE;
  v_beginString       fix_message_temp.beginstring%TYPE;
  v_text              fix_message_temp.text%TYPE;

  v_blorderid         bl_odmast.blorderid%TYPE;
  v_traderid          bl_odmast.traderid%TYPE;
  v_tradeplace        VARCHAR2(10);
  v_pricetype         bl_odmast.pricetype%TYPE;
  v_EDStatus          bl_odmast.edstatus%TYPE;

  v_amend_blorderid  bl_odmast.blorderid%TYPE;
  v_currDate          DATE;
  v_strCurrDate       VARCHAR2(10);

  v_quantity          bl_odmast.quantity%TYPE;
  v_exectype          bl_odmast.exectype%TYPE;
  v_timetype          bl_odmast.timetype%TYPE;



--  v_OrderStatus       odmast.orstatus%TYPE;
  v_FromPrice         NUMBER;
  v_ToPrice           NUMBER;
  l_dblTickSize       NUMBER;
--  v_ODExecqtty        NUMBER;
  v_BLExecqtty        NUMBER;
  v_bLRefExecQtty     NUMBER;
  v_AmendQtty         NUMBER;
  v_refBlOrderId      bl_odmast.refblorderid%TYPE;
  v_CodeID            bl_odmast.codeid%TYPE;
  v_maxTradingVol     NUMBER;

  l_blOdType          bl_odmast.blodtype%TYPE;
  v_strMarketStatus   ordersys.sysvalue%TYPE;
  l_hnxTRADINGID      ordersys_ha.sysvalue%TYPE;
  l_org_price         bl_odmast.price%TYPE;
  l_delta_qtty        bl_odmast.quantity%TYPE;
  l_sentQtty          bl_odmast.sentqtty%TYPE;
  l_cancelQtty        bl_odmast.cancelqtty%TYPE;
  l_remain_map        bl_odmast.quantity%TYPE;
  l_cancel_execType   bl_odmast.exectype%TYPE;
  l_priceChkType      bl_odmast.pricechktype%TYPE;
  BEGIN
    plog.setBeginSection(pkgctx, 'sp_process_amend_order');
    pv_err_code := '0';
    pv_err_msg := '';
    v_currDate := getcurrdate;
    v_strCurrDate := to_date(v_currDate, 'dd/mm/rrrr');

    If fopks_api.fn_is_ho_active = false then
      pv_err_msg := 'Exchange Closed';
      RAISE v_exp;
    End if;

    SELECT origClOrdid, clOrdId, orderqty, price, sendersubid, sendercompid, targetcompid, beginString, text
    INTO v_origClordId, v_clordId, v_qtty, v_price, v_traderId, v_senderComId, v_targetComId, v_beginString,  v_text
    FROM fix_message_temp f
    WHERE f.autoid = p_autoid;


    SELECT COUNT(1) INTO v_count
    FROM fix_message_temp
    WHERE clordid = v_clordId AND autoid != p_autoid;
    IF v_count > 0 THEN
      pv_err_msg := 'Duplicate Clordid';
      RAISE v_exp;
    END IF;

    SELECT COUNT(1) INTO v_count
    FROM bl_odmast
    WHERE forefid = v_origClordId;
    IF v_count = 0 THEN
      pv_err_msg := 'Unknow order';
      RAISE v_exp;
    END IF;

    --Check co lenh tren san.
    Begin
      /*Select f.orderid ,m.quantity, m.exectype , m.codeid, cf.custodycd, m.traderid, sb.tradeplace, m.pricetype,
             m.timetype, m.blorderid, f.edstatus
      into v_OrderID,v_quantity, v_exectype , v_CodeID, v_custodycd, v_traderid, v_tradeplace, v_pricetype,
           v_timetype, v_blorderid, v_EDStatus
      from odmast f, bl_odmast m, cfmast cf, afmast af, sbsecurities sb
      Where f.blorderid = m.blorderid
      AND cf.custid = af.custid AND af.acctno = m.afacctno
      AND m.codeid = sb.codeid
      And m.forefid = v_origClordId
      and m.exectype in ('NB','NS') and m.status not in ('C','R')
      AND f.orstatus IN ('2','4') AND f.exectype IN ('NB','NS') AND f.remainqtty >0;

      If v_exectype in ('AS','AB') Then --Neu yeu cau sua cua lenh da sua thi tim lenh goc.
        Select orderid  Into v_OrderID
        from odmast where reforderid in (select reforderid from odmast
                                          where exectype in ('AS','AB')
                                          and orderid =v_OrderID
                                          ) and exectype not in ('AS','AB');
      End if;*/
      SELECT bl.quantity, bl.exectype, bl.codeid, sb.tradeplace, bl.pricetype, bl.edstatus, blorderid, REFBLORDERID,
             blOdType, price, bl.sentqtty, bl.cancelqtty, bl.pricechktype
      INTO v_quantity, v_exectype, v_CodeID, v_tradeplace, v_pricetype, v_EDStatus, v_blorderid, v_refBlOrderId,
           l_blOdType, l_org_price, l_sentQtty, l_cancelQtty, l_priceChkType
      FROM bl_odmast bl, sbsecurities sb
      WHERE bl.codeid = sb.codeid
      AND bl.forefid = v_origClordId
      AND bl.blodtype IN ('3', '1') AND bl.status NOT IN ('R');
      l_cancel_execType := 'C' || substr(v_exectype, 2);
    Exception
      When Others THEN
        pv_err_msg := 'Cannot amend this orders!';
        RAISE v_exp;
    End;

    -- Lenh dang huy/sua thi ko cho phep sua nua
    IF v_EDStatus = 'A' OR v_EDStatus = 'C' THEN
      pv_err_msg := 'Can not amend this order!';
      RAISE v_exp;
    END IF;
    /*BEGIN
      SELECT count(1)
      INTO v_Count
      FROM bl_odmast od
      WHERE od.blOrderId = v_blorderid AND od.edstatus IN ('A','C');
    Exception
      When Others THEN
        pv_err_msg := 'Can not amend this order!';
        RAISE v_exp;
    END;

    IF v_Count > 0 THEN
      pv_err_msg := 'Can not amend this order!';
      RAISE v_exp;
    END IF;*/

    -- Khong cho sua lenh HO
    IF v_tradeplace = '001' AND l_blOdType = '1' THEN
      pv_err_msg := 'Security of HOSE stock exchange does not allow amendment!';
      RAISE v_exp;
    End if;

    -- Khong cho sua lenh GTC
    If  v_timetype = 'G' THEN
      pv_err_msg := 'GTC order does not allow amendment!';
      RAISE v_exp;
    End if;

    -- Khong cho sua lenh gia ATC, MOK, MAK, MTL
    IF v_pricetype IN ('ATO','ATC','MOK') AND l_blOdType = '1' THEN
      pv_err_msg := v_pricetype || ' order does not allow amendment!';
      RAISE v_exp;
    END IF;

    if v_pricetype in ('MAK','MTL') AND l_blOdType = '1' THEN
      pv_err_msg := v_pricetype || ' order does not allow amendment!';
      RAISE v_exp;
    end if;

    -- Khong cho phep sua loai gia dat lenh
    if v_pricetype not in ('MAK','MTL') AND l_blOdType = '1' then
      IF v_pricetype <> 'LO' THEN
        pv_err_msg := 'Time in force does not allow amendment';
        RAISE v_exp;
      END IF;
    end if;

    SELECT to_number(varvalue) INTO v_maxTradingVol
    FROM sysvar
    WHERE varname = DECODE(v_tradeplace, '001', 'HOSE_MAX_QUANTITY', 'HNX_MAX_QUANTITY')
    AND grname = 'BROKERDESK';
    IF v_qtty > v_maxTradingVol AND l_blOdType = '1' THEN
      pv_err_msg  := 'Over order qtty maximum ' || v_maxTradingVol;
      RAISE v_exp;
    END IF;

    /*SELECT sysvalue
    INTO l_hnxTRADINGID
    FROM ordersys_ha
    WHERE sysname = 'TRADINGID';*/
    -- lay ra gia tri max HNX cua 1 lenh
/*    select to_number(varvalue)
    into L_MaxHNXQtty
    from sysvar
    where varname = 'HNX_MAX_QUANTITY';*/

    -- Chan huy sua cuoi phien
    /*IF  l_hnxTRADINGID IN ('CLOSE_BL') AND v_tradeplace in ('002','005') THEN
      pv_err_msg := v_pricetype || ' order is not allowed to amend in this session of stock exchange!';
      RAISE v_exp;
    END IF;*/

    --chan khong sua lenh HNX lon hon max KL HNX
/*    IF v_qtty > L_MaxHNXQtty AND v_tradeplace in ( '002','005') THEN
      pv_err_msg := 'Amendment quantity is larger than max quantity of this exchange!';
      RAISE v_exp;
    END IF;*/

    -- Kiem tra lenh phai gui len san roi moi cho sua
    /*BEGIN
      SELECT orstatus
      INTO v_OrderStatus
      FROM odmast
      WHERE orderid = v_OrderID;
    Exception
      When Others THEN
        pv_err_msg := 'Unknown Order';
        RAISE v_exp;
    END;
    IF v_OrderStatus IN ('8') THEN
      pv_err_msg := 'Order is not sent to exchange. Please cancel this order and order another!';
      RAISE v_exp;
    END IF;*/

    --Kiem tra gia sua phai trong khoang tran san.
    Begin
      Select floorprice, ceilingprice Into v_FromPrice, v_ToPrice
      from securities_info where codeid = v_CodeID;
      -- Lenh Manual Ko Sua PriceType --> lay Gia Voi Lenh Market
      IF l_blOdType != '1' AND v_pricetype != 'LO' THEN
        v_price := CASE WHEN v_exectype = 'NB' THEN v_ToPrice ELSE v_FromPrice END;
      END IF;

      If v_price > v_ToPrice or v_price < v_FromPrice THEN
        pv_err_msg := 'Invalid Price';
        RAISE v_exp;
      End if;
    Exception
      When Others Then
        pv_err_msg := 'Invalid Price';
        RAISE v_exp;
    End;

    --Kiem tra gia sua phai thoa man ticksize.

    SELECT count(1) into v_count
    FROM SECURITIES_TICKSIZE
    WHERE CODEID = v_CodeID  AND STATUS='Y'
    AND TOPRICE >= v_price AND FROMPRICE <= v_price;
    if v_count<=0 then
       --Chua dinh nghia TICKSIZE
      pv_err_msg := 'Ticksize undefined.';
      RAISE v_exp;
    else
      SELECT FROMPRICE, TICKSIZE into v_FromPrice,l_dblTickSize
      FROM SECURITIES_TICKSIZE
      WHERE CODEID=v_CodeID  AND STATUS='Y'
      AND TOPRICE >= v_price AND FROMPRICE<=v_price;
      If (v_price - v_FromPrice) Mod l_dblTickSize <> 0  THEN
        pv_err_msg := 'Ticksize incompliant.';
        RAISE v_exp;
      End If;
    end if;

    begin
      select bl.execqtty
      into v_BLExecqtty
      from bl_odmast bl
      where bl.blorderid = v_blorderid;
    exception
      when others then
        v_BLExecqtty := 0;
    end;
    BEGIN
      SELECT execqtty INTO v_bLRefExecQtty
      FROM bl_odmast
      WHERE blorderid = v_blorderid;
    EXCEPTION
      WHEN OTHERS THEN
        v_bLRefExecQtty := 0;
    END;
    v_AmendQtty := v_qtty - v_bLRefExecQtty;
    if v_AmendQtty <= 0 then
       --Vuot qua SL co the sua
      pv_err_msg := 'Amend volume request is smaller than filled volume';
      RAISE v_exp;
    end if;

    -- Kiem tra khoi luong phai dung lo GD
    IF v_tradeplace = '001' OR l_blOdType = '1' THEN
      If pr_check_tradelot(v_qtty, v_tradeplace) != 0 Then
        pv_err_msg  := 'Invalid Trade lot';
        RAISE v_exp;
      End If;
    END IF;
    IF v_qtty < v_quantity AND l_blOdType != '1' THEN
      -- Sua Giam KL
      IF v_tradeplace = '001' THEN
         SELECT sysvalue INTO v_strMarketStatus FROM ordersys WHERE sysname='CONTROLCODE';
         If v_strMarketStatus  IN ('A','P') THEN
           pv_err_msg :=  'Market is in the opening/closing auction.';
           RAISE v_exp;
         END IF;
      END IF;
      IF v_tradeplace ='002' THEN
        SELECT nvl( sysvalue,'CLOSEALL')
        INTO l_hnxTRADINGID
        FROM ordersys_ha
        WHERE sysname = 'TRADINGID';
        IF  l_hnxTRADINGID IN ('CLOSE','CLOSE_BL')THEN
            pv_err_msg := 'Market is in the opening/closing auction.';
            Raise v_exp;
        END IF;
        IF l_hnxTRADINGID IN ('CLOSEALL') THEN
            pv_err_msg := 'Market close!';
            Raise v_exp;
        END IF;
      END IF;
    END IF;

    IF l_blOdType != '1' THEN
      -- Xu Cho Sua Lenh Manual
      BEGIN
        INSERT INTO bl_odmast_processing(blorderid, eventname) VALUES (v_blorderid, 'sp_process_amend_order');
      EXCEPTION
        WHEN OTHERS THEN
          pv_err_msg := 'Order currently in transaction!';
          RAISE v_exp;
      END;
      IF l_priceChkType = '4' THEN
        pv_err_msg := 'Can not Amend Auto Order!';
        RAISE v_exp;
      END IF;

      IF v_price = l_org_price AND v_qtty = v_quantity THEN
        pv_err_msg := 'The request is not supported!';
        RAISE v_exp;
      END IF;
      IF (v_exectype = 'NB' AND l_org_price > v_price) -- Sua Giam Gia Lenh Mua
          OR (v_exectype = 'NS' AND l_org_price < v_price) THEN -- Sua Tang Gia Lenh Ban
        pv_err_msg := 'The request is not supported!';
        RAISE v_exp;
      END IF;
      IF v_qtty < v_quantity THEN -- Sua Giam KL --> Check Phien
        select sysvalue into v_strMarketStatus  from ordersys where sysname='CONTROLCODE';
        SELECT nvl( sysvalue,'CLOSEALL') INTO l_hnxTRADINGID FROM ordersys_ha WHERE sysname = 'TRADINGID';
        If v_strMarketStatus IN ('A','P') and v_tradeplace = '001' THEN
          pv_err_msg := 'Market is in the opening/closing auction.';
          Raise v_exp;
        End IF;
        IF l_hnxTRADINGID IN ('CLOSE','CLOSE_BL') and v_tradeplace = '002' THEN
          pv_err_msg := 'Market is in the opening/closing auction.';
          Raise v_exp;
        END IF;
        IF l_hnxTRADINGID IN ('CLOSEALL') and v_tradeplace = '002' THEN
          pv_err_msg := 'Market close!';
          Raise v_exp;
        END IF;
      END IF;
      -- Xu Ly Them Cho Cac Truong Hop Dac Biet
      --IF NOT v_qtty > v_quantity THEN
        -- Neu Sua Tang KL Thi Ko Check DK Chia Lenh
      l_remain_map := v_quantity - l_sentQtty - l_cancelQtty;
      IF l_remain_map = 0 THEN
        pv_err_msg := 'To late. Balance queued in the market';
        RAISE v_exp;
      END IF;
      --END IF;

      -- Tao Yeu Cau Sua Tren bl_odmast
      v_amend_blorderid := fn_get_blOrderId;
      INSERT INTO bl_odmast (autoid, blorderid, blacctno, afacctno, custodycd, traderid, forefid, status,
                             blodtype, exectype, pricetype, timetype, codeid, symbol, quantity, price, execqtty,
                             execamt, remainqtty, cancelqtty, amendqtty, refblorderid, feedbackmsg, activatedt, createddt,
                             txdate, effdate, expdate, via, deltd, username, direct, tlid, refforefid, orgquantity, orgprice,
                             edstatus, edexectype, rootorderid, blinstruction,
                             fixside, fixordtype, fixtimeinforc, fixsendercompid, fixcompid, beginstring,
                             hftreforderid, origexecqtty, Origexecamt, pricechktype, app_status, targetstrategy)
      SELECT seq_bl_odmast.nextval, v_amend_blorderid, bl.blacctno, bl.afacctno, bl.custodycd, v_traderid, v_clordId, 'N',
             bl.blodtype, bl.exectype, bl.pricetype, bl.timetype, bl.codeid, bl.symbol, v_qtty, v_price, bl.execqtty,
             bl.execamt, bl.remainqtty, bl.cancelqtty, v_AmendQtty, bl.blorderid, 'Receive Amend Order', v_strCurrDate, v_strCurrDate,
             v_currDate, v_currDate, v_currDate, 'L', 'N', 'BLP', 'Y', '6868', bl.forefid, bl.orgquantity, bl.orgprice,
             'A', 'A', bl.rootorderid, NVL(v_text, bl.blinstruction),
             bl.fixside, bl.fixordtype, bl.fixtimeinforc, bl.fixsendercompid, bl.fixcompid, bl.beginstring,
             bl.hftorderid, bl.execqtty, bl.execamt, bl.pricechktype, bl.app_status, bl.targetstrategy
      FROM bl_odmast bl
      WHERE bl.blorderid = v_blorderid;
      UPDATE bl_odmast SET edstatus = 'A',
                           last_change = systimestamp,
                           amendQtty = v_qtty
      WHERE blorderid = v_blorderid;


      IF v_qtty >= v_quantity /*OR v_quantity - v_qtty <= l_remain_map*/ THEN
        -- 1. Sua Tang KL --> Success luon
        UPDATE bl_odmast set EDSTATUS = 'N',
                             price = v_price,
                             quantity = v_qtty,
                             REMAINQTTY = REMAINQTTY + v_qtty - v_quantity - l_cancelQtty,
                             orgforefid = forefid,
                             forefid = v_clordId,
                             LAST_CHANGE = SYSTIMESTAMP,
                             amendQtty = 0,
                             feedbackmsg = 'Order Replaced'
        WHERE blorderid = v_blorderid;
        UPDATE bl_odmast set EDSTATUS ='S',
                             status = 'F',
                             pstatus = pstatus || status,
                             orgforefid = forefid,
                             forefid='',
                             LAST_CHANGE = SYSTIMESTAMP,
                             feedbackmsg = 'Replace Order success'
        WHERE REFblorderid = v_blorderid and edstatus ='A' AND status <> 'R';
      ELSE
        --2. Sua Giam KL --> Huy Toan Bo Lenh Con
        pr_cancel_mapOrder_from_fix(v_blorderid, l_cancel_execType);
      END IF;
      DELETE bl_odmast_processing WHERE blOrderId = v_blorderid;
    ELSE------------------------------------------------------------------------------
      -- Lenh Direct Giu Nguyen Logic cu
      v_amend_blorderid := fn_get_blOrderId;
      INSERT INTO bl_odmast (autoid, blorderid, blacctno, afacctno, custodycd, traderid, forefid, status,
                             blodtype, exectype, pricetype, timetype, codeid, symbol, quantity, price, execqtty,
                             execamt, remainqtty, cancelqtty, amendqtty, refblorderid, feedbackmsg, activatedt, createddt,
                             txdate, effdate, expdate, via, deltd, username, direct, tlid, refforefid, orgquantity, orgprice,
                             edexectype, rootorderid, blinstruction, sentQtty,
                             fixside, fixordtype, fixtimeinforc, fixsendercompid, fixcompid, beginstring,
                             hftreforderid, origexecqtty, Origexecamt, targetstrategy)
      SELECT seq_bl_odmast.nextval, v_amend_blorderid, bl.blacctno, bl.afacctno, bl.custodycd, v_traderid, v_clordId, 'N',
             bl.blodtype, bl.exectype, bl.pricetype, bl.timetype, bl.codeid, bl.symbol, v_qtty, v_price, bl.execqtty,
             bl.execamt, bl.remainqtty, 0, v_AmendQtty, bl.blorderid, 'Receive Amend Order', v_strCurrDate, v_strCurrDate,
             v_currDate, v_currDate, v_currDate, 'L', 'N', 'BLP', 'Y', '6868', bl.forefid, bl.orgquantity, bl.orgprice,
             'A', bl.rootorderid, v_text, v_qtty,
             bl.fixside, bl.fixordtype, bl.fixtimeinforc, bl.fixsendercompid, bl.fixcompid, bl.beginstring,
             bl.hftorderid, bl.execqtty, bl.execamt, bl.targetstrategy
      FROM bl_odmast bl
      WHERE bl.blorderid = v_blorderid;

      UPDATE bl_odmast SET edstatus = 'A',
                           last_change = systimestamp
      WHERE blorderid = v_blorderid;
    END IF;

    UPDATE fix_message_temp SET status = 'A' WHERE autoid = p_autoid;
    plog.setEndSection(pkgctx, 'sp_process_cancel_order');
  EXCEPTION
    WHEN v_exp THEN
      pv_err_code := '1';
      DELETE bl_odmast_processing WHERE blOrderId = v_blorderid;
      UPDATE fix_message_temp SET status = 'E',
                                  errmsg = pv_err_msg,
                                  errcode = pv_err_code
      WHERE autoid = p_autoid;
      plog.setEndSection(pkgctx, 'sp_process_cancel_order');
    WHEN OTHERS THEN
      pv_err_code := '-1';
      pv_err_msg := 'System Error';
      DELETE bl_odmast_processing WHERE blOrderId = v_blorderid;
      UPDATE fix_message_temp SET status = 'E',
                                  errmsg = pv_err_msg,
                                  errcode = pv_err_code
      WHERE autoid = p_autoid;
      plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection(pkgctx, 'sp_process_cancel_order');
  END;


------------------------Process Response From HFT-----------------------------------------------
  PROCEDURE sp_update_new_order (p_autoid       VARCHAR2,
                                 p_action       VARCHAR2, -- CF: confirm, RJ: reject
                                 p_text         VARCHAR2 DEFAULT '',
                                 p_hftOrderId   VARCHAR2 DEFAULT '')
  IS
  BEGIN
    plog.setBeginSection(pkgctx, 'sp_update_new_order');
    IF p_action = 'CF' THEN
      UPDATE bl_odmast SET status = 'F',
                           pstatus = pstatus || status,
                           hftorderid = p_hftOrderId,
                           feedbackmsg = 'Receive new order',
                           last_change= systimestamp
      WHERE autoid = p_autoid;
    ELSE
      UPDATE bl_odmast SET status = 'R',
                           pstatus = pstatus || status,
                           remainqtty = 0,
                           cancelQtty = quantity,
                           feedbackmsg = NVL(p_text, 'Order reject'),
                           last_change= systimestamp
      WHERE autoid = p_autoid;
    END IF;
    plog.setEndSection(pkgctx, 'sp_update_new_order');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection(pkgctx, 'sp_update_new_order');
  END;

  PROCEDURE sp_update_cancel_order (p_blOrderID       VARCHAR2,
                                    p_blRefOrderID    VARCHAR2,
                                    p_action          VARCHAR2, -- CF: confirm, RJ: reject
                                    p_text            VARCHAR2 DEFAULT '',
                                    p_hftOrderId      VARCHAR2 DEFAULT '')
  IS
  l_blOrderid      bl_odmast.blorderid%TYPE;
  l_blMapId        bl_maporder.mapid%TYPE;
  BEGIN
    plog.setBeginSection(pkgctx, 'sp_update_cancel_order');

    IF p_action = 'CF' THEN
      UPDATE bl_odmast SET status = 'F',
                           pstatus = pstatus || status,
                           hftorderid = p_hftOrderId,
                           last_change= systimestamp
      WHERE blorderid = p_blOrderID;
    ELSIF p_action = 'RJ' THEN
      -- reject lenh huy
      UPDATE bl_odmast SET status = 'R',
                           pstatus = pstatus || status,
                           feedbackmsg = NVL(p_text, 'Order Cancel Reject'),
                           last_change= systimestamp
      WHERE blorderid = p_blOrderID;
      -- update lenh goc ve normal
      UPDATE bl_odmast SET edstatus = 'N',
                           feedbackmsg = p_text,
                           last_change= systimestamp
      WHERE blorderid = p_blRefOrderID;
    ELSIF p_action = 'CF2' THEN -- confirm cancel order success
      UPDATE bl_odmast SET remainqtty = 0,
                           edstatus = 'W',
                           pstatus = pstatus || status,
                           status = 'C', -- M = Modified
                           last_change = SYSTIMESTAMP,
                           cancelQtty = quantity,
                           FEEDBACKMSG = 'Order canceled'
        WHERE blorderid = p_blRefOrderID;
        -- Cap nhat lenh y/c sua thanh lenh moi
        UPDATE bl_odmast SET
            pstatus = pstatus || status,
            status = 'F',
            edstatus = 'N', -- Lenh binh thuong
            execqtty = 0,
            execamt = 0,
            sentqtty = quantity,
            last_change = SYSTIMESTAMP,
            FEEDBACKMSG = 'Cancel Order success'--NVL(p_text, 'Cancel Order success')
        WHERE blorderid = p_blOrderID;
    END IF;
    plog.setEndSection(pkgctx, 'sp_update_cancel_order');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection(pkgctx, 'sp_update_cancel_order');
  END;

  PROCEDURE sp_update_amend_order (p_blOrderID       VARCHAR2,
                                   p_blRefOrderID    VARCHAR2,
                                   p_action          VARCHAR2,
                                   p_text            VARCHAR2 DEFAULT '',
                                   p_hftOrderId      VARCHAR2 DEFAULT '')
  IS
  BEGIN
    plog.setBeginSection(pkgctx, 'sp_update_amend_order');
    IF p_action = 'CF' THEN
      UPDATE bl_odmast SET status = 'F',
                           pstatus = pstatus || status,
                           hftorderid = p_hftOrderId,
                           feedbackmsg = 'Receive Replace order request',
                           last_change= systimestamp
      WHERE blorderid = p_blOrderID;

    ELSIF p_action = 'RJ' THEN
      -- reject lenh sua
      UPDATE bl_odmast SET status = 'R',
                           pstatus = pstatus || status,
                           feedbackmsg = p_text,
                           last_change= systimestamp
      WHERE blorderid = p_blOrderID;

      -- update lenh goc ve normal
      UPDATE bl_odmast SET edstatus = 'N',
                           feedbackmsg = p_text,
                           last_change= systimestamp
      WHERE blorderid = p_blRefOrderID;

    ELSIF p_action = 'CF2' THEN -- confirm replace order success
      UPDATE bl_odmast SET remainqtty = 0,
                           edstatus = 'S',
                           pstatus = pstatus || status,
                           status = 'M', -- M = Modified
                           last_change = SYSTIMESTAMP,
                           FEEDBACKMSG = 'Replace Order success'
        WHERE blorderid = p_blRefOrderID;
        -- Cap nhat lenh y/c sua thanh lenh moi
        UPDATE bl_odmast SET
            pstatus = pstatus || status,
            status = 'F',
            edstatus = 'N', -- Lenh binh thuong
            execqtty = 0,
            execamt = 0,
            sentqtty = quantity,
            last_change = SYSTIMESTAMP,
            FEEDBACKMSG = NVL(p_text, 'Replace Order success')
        WHERE hftorderid = p_hftOrderId;
    END IF;
    plog.setEndSection(pkgctx, 'sp_update_amend_order');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, 'sp_update_amend_order');
      plog.setEndSection(pkgctx, 'sp_update_amend_order');
  END;
-----------------------------Process HFT Event-----------------------------------------------------
  PROCEDURE sp_new_order_response (pv_err_code OUT VARCHAR2,
                                   p_action        VARCHAR2,
                                   p_hftOrderId    VARCHAR2,
                                   p_text          VARCHAR2 DEFAULT '')
  IS
  --v_count   NUMBER;
  l_blOrderId    bl_odmast.blorderid%TYPE;
  l_blOrderMapId bl_maporder.mapid%TYPE;
  l_qtty         bl_maporder.qtty%TYPE;
  BEGIN
    plog.setBeginSection(pkgctx, 'sp_new_order_response');
    pv_err_code := '0';
    /*SELECT COUNT(1) INTO v_count
    FROM bl_odmast bl
    WHERE bl.hftorderid = p_hftOrderId;
    IF v_count = 1 THEN
      pv_err_code := '0';
    ELSE
      pv_err_code := '1';
      plog.setEndSection(pkgctx, 'sp_new_order_response');
      RETURN;
    END IF;*/
    IF fn_get_blOrderId_by_hftOrderId(p_hftOrderId, l_blOrderId, l_blOrderMapId) <> 0 THEN
      pv_err_code := '1'; -- Khong Tim Thay SHL
      plog.setEndSection(pkgctx, 'sp_new_order_response');
      RETURN;
    END IF;
    IF p_action = 'RJ' THEN
      IF l_blOrderMapId IS NOT NULL THEN -- Lenh Con Duoc Dat Tu Lenh Manual
        SELECT b.qtty INTO l_qtty
        FROM bl_maporder b
        WHERE b.mapid = l_blOrderMapId;
        -- Update Lenh Map
        UPDATE bl_maporder SET status = 'R',
                               pstatus = pstatus || status,
                               errmsg = NVL(p_text, 'Order reject by Exchange'),
                               cancelQtty = qtty
        WHERE mapid = l_blOrderMapId;
        -- Update Giam KL Da Dat Lenh Goc
        UPDATE bl_odmast b SET sentqtty = sentqtty - l_qtty,
                               last_change= systimestamp
        WHERE b.blorderid = l_blOrderId;
        pv_err_code := '3'; -- Khong xu ly sinh report cho BLP
      ELSE -- Lenh Direct
        UPDATE bl_odmast
        SET cancelqtty = remainqtty,
            remainqtty = 0,
            pstatus = pstatus || status,
            status = 'R',
            FEEDBACKMSG = NVL(p_text, 'Order reject by Exchange'),
            LAST_CHANGE = SYSTIMESTAMP
        WHERE hftorderid = p_hftOrderId;
      END IF;

    END IF;
    plog.setEndSection(pkgctx, 'sp_new_order_response');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      pv_err_code := '1';
      plog.setEndSection(pkgctx, 'sp_new_order_response');
  END;

  PROCEDURE sp_cancel_order_response (pv_err_code OUT VARCHAR2,
                                      p_action      VARCHAR2,
                                      p_hftOrderId  VARCHAR2,
                                      p_cancelQtty  NUMBER,
                                      p_text        VARCHAR2 DEFAULT '')
  IS
  v_edExectype       bl_odmast.edexectype%TYPE;
  v_refBlOrderId     bl_odmast.refblorderid%TYPE;
  v_blStatus         bl_odmast.status%TYPE;
  v_blOrderId        bl_odmast.blorderid%TYPE;
  v_execQtty         bl_odmast.execqtty%TYPE;
  v_execAmt          bl_odmast.execamt%TYPE;

  l_blOrderMapId     bl_maporder.mapid%TYPE;
  l_refBlOrderMapId  bl_maporder.refmapid%TYPE;
  l_cancelBlOrderMapId  bl_maporder.mapid%TYPE;
  l_edStatus            bl_odmast.edstatus%TYPE;
  l_remain_qtty         bl_odmast.remainqtty%TYPE;
  l_cancelQtty          bl_odmast.cancelqtty%TYPE;

  l_countPendingCancel  NUMBER;
  l_count               NUMBER;
  l_amendQtty           bl_odmast.quantity%TYPE;
  l_amendPrice          bl_odmast.price%TYPE;
  l_amendClOrdId        bl_odmast.forefid%TYPE;
  l_amendBlOrderId      bl_odmast.blorderid%TYPE;
  l_orgQtty             bl_odmast.quantity%TYPE;
  l_odcancelQtty        bl_odmast.cancelqtty%TYPE;
  l_execQtty            bl_odmast.execqtty%TYPE;
  l_execAmt             bl_odmast.execamt%TYPE;
  BEGIN
    plog.setBeginSection(pkgctx, 'sp_cancel_order_response');
    pv_err_code := '0';
    IF fn_get_blOrderId_by_hftOrderId(p_hftOrderId, v_blOrderId, l_blOrderMapId) <> 0 THEN
      pv_err_code := '1'; -- Khong Tim Thay SHL
      plog.error(pkgctx, 'Order Not Found ' || p_hftOrderId);
      plog.setEndSection(pkgctx, 'sp_cancel_order_response');
      RETURN;
    END IF;
    IF l_blOrderMapId IS NOT NULL THEN -- Confirm Cancel For MapOrder
      SELECT refMapId INTO l_refBlOrderMapId  FROM bl_maporder  WHERE mapId = l_blOrderMapId;
      IF l_refBlOrderMapId IS NULL THEN  -- order cancel in HSX return origOrderid
        SELECT refMapId INTO l_refBlOrderMapId
        FROM bl_maporder
        WHERE refMapId = l_blOrderMapId
        AND status <> 'R';
      END IF;
      SELECT edstatus, status INTO l_edStatus, v_blStatus
      FROM bl_odmast
      WHERE blOrderId = v_blOrderId;
      SELECT COUNT(1) INTO l_count FROM bl_odmast WHERE refBlorderId = v_blOrderId AND status <> 'R';

      IF p_action = 'RJ' THEN
        UPDATE bl_maporder SET status = 'R',
                               pstatus = pstatus || status,
                               last_change = systimestamp
        WHERE mapId = l_refBlOrderMapId AND status = 'F';
        UPDATE bl_maporder SET status = 'F',
                               pstatus = pstatus || status,
                               last_change = systimestamp
        WHERE mapid = l_blOrderMapId AND status = 'C';
        UPDATE bl_odmast SET last_change = systimestamp,
                             status = CASE WHEN edstatus <> 'N' THEN 'F' ELSE status END ,
                             edstatus = 'N',
                             pstatus = pstatus || CASE WHEN edstatus <> 'N' THEN status ELSE '' END
        WHERE blOrderid = v_blOrderId;
      ELSE
        IF NVL(p_cancelQtty, 0) <= 0 THEN
          SELECT remainQtty INTO l_cancelQtty
          FROM bl_maporder
          WHERE mapId = l_refBlOrderMapId;
        ELSE
          l_cancelQtty := p_cancelQtty;
        END IF;
        UPDATE bl_maporder SET status = 'D',
                               pstatus = pstatus || status,
                               cancelQtty = cancelQtty + l_cancelQtty,
                               remainQtty = remainQtty - l_cancelQtty,
                               last_change = systimestamp
        WHERE mapid = l_refBlOrderMapId AND status = 'C'; -- Lenh GOC
        UPDATE bl_maporder SET status = 'D',
                               pstatus = pstatus || status,
                               cancelqtty = cancelqtty + l_cancelQtty,
                               remainqtty = remainqtty - l_cancelQtty,
                               last_change = systimestamp
        WHERE refmapid = l_blOrderMapId AND status <> 'R'; -- Lenh SUA

        IF l_edStatus = 'C' THEN
          UPDATE bl_odmast SET cancelqtty = cancelqtty + l_cancelQtty,
                               remainqtty = remainqtty - l_cancelQtty,
                               sentQtty = sentQtty - l_cancelQtty,
                               status = CASE WHEN quantity = cancelQtty + l_cancelQtty + execQtty THEN 'C' ELSE status END,
                               feedbackmsg = CASE WHEN quantity = cancelQtty + l_cancelQtty + execQtty AND l_count > 0 THEN 'Order Canceled' ELSE feedbackmsg END,
                               last_change = systimestamp
          WHERE blorderid = v_blOrderId;
          SELECT remainQtty INTO l_remain_qtty FROM bl_odmast WHERE blOrderId = v_blOrderId;
          IF l_remain_qtty = 0 THEN
            pv_err_code := '0';
            plog.setEndSection(pkgctx, 'sp_cancel_order_response');
            RETURN;
          END IF;
        ELSE
          UPDATE bl_odmast b SET b.sentqtty = b.sentqtty - l_cancelQtty
          WHERE b.blorderid = v_blOrderId;
        END IF;
      END IF;

      SELECT COUNT(1) INTO l_countPendingCancel
      FROM bl_maporder
      WHERE blOrderId = v_blOrderId AND status = 'F'
      AND execType IN ('CB', 'CS') AND mapId <> l_blOrderMapId;

      IF l_edStatus = 'A' AND l_countPendingCancel = 0 THEN
        -- Trang Thai Pending Replace --> KT Dieu Kien Sua Lenh
        SELECT quantity, price, foRefId, blOrderId INTO l_amendQtty, l_amendPrice, l_amendClOrdId, l_amendBlOrderId FROM bl_odmast
        WHERE refBlorderId = v_blOrderId AND status <> 'R' AND edstatus = 'A';
        SELECT quantity, execQtty, cancelQtty, execAmt INTO l_orgQtty, l_execQtty, l_odcancelQtty, l_execAmt
        FROM bl_odmast
        WHERE blOrderId = v_blOrderId;
        IF l_execQtty >= l_amendQtty THEN
          -- To late for replace
          UPDATE bl_odmast set EDSTATUS = 'N'
          WHERE blorderid = v_blorderid;
          UPDATE bl_odmast set status ='R',
                               edstatus = 'R',
                               pstatus = pstatus || status,
                               feedbackmsg = 'Too late to Cancel/Replace'
          WHERE REFblorderid = v_blorderid and EDSTATUS ='A' AND status <> 'R';
        ELSE
          -- Replace Success
          UPDATE bl_odmast set EDSTATUS = 'N',
                               price = l_amendPrice,
                               quantity = l_amendQtty,
                               remainQtty = remainQtty + l_amendQtty - l_orgQtty - l_cancelQtty,
                               orgforefid = forefid,
                               forefid = l_amendClOrdId,
                               feedbackmsg = 'Order Replaced',
                               LAST_CHANGE = SYSTIMESTAMP
          WHERE blorderid = v_blorderid;
          UPDATE bl_odmast SET
              edstatus = 'S',
              status = 'F',
              pstatus = pstatus || status,
              orgforefid = forefid,
              forefid='',
              last_change = SYSTIMESTAMP,
              FEEDBACKMSG = NVL(p_text, 'Replace Order success')
          WHERE refBlorderId = v_blOrderId AND status <> 'R';
        END IF;
        pv_err_code := 'REPLACE_' || v_blOrderId; -- AddHoc Router Message
        RETURN;
      END IF;

      pv_err_code := '3';
    ELSE

      BEGIN
        SELECT edexectype, refblorderid, status, execqtty, execamt, blOrderId
        INTO v_edExectype, v_refBlOrderId, v_blStatus, v_execQtty, v_execAmt, v_blOrderId
        FROM bl_odmast
        WHERE hftOrderId = p_hftOrderId;
        --AND edexectype = 'D';
        pv_err_code := '0';
        IF v_refBlOrderId IS NULL THEN -- order cancel in HSX return origOrderid
          SELECT edexectype, refblorderid, status, execqtty, execamt
          INTO v_edExectype, v_refBlOrderId, v_blStatus, v_execQtty, v_execAmt
          FROM bl_odmast
          WHERE refblorderid = v_blOrderId
          AND status <> 'R';
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          pv_err_code := '1';
          plog.error(pkgctx, 'hftOrderId=' || p_hftOrderId || ' not found');
          plog.setEndSection(pkgctx,'sp_cancel_order_response');
      END;

      IF p_action = 'RJ' THEN
        UPDATE bl_odmast
        SET edstatus = 'N',
            LAST_CHANGE = SYSTIMESTAMP,
            FEEDBACKMSG = NVL(p_text, 'Cancel order reject')
        WHERE blorderid = v_refblorderid;
        -- Cap nhat lenh y/c huy
        UPDATE bl_odmast
        SET pstatus = pstatus || status,
            status = 'R',
            FEEDBACKMSG = NVL(p_text, 'Cancel order reject'),
            LAST_CHANGE = SYSTIMESTAMP
        WHERE hftOrderId = p_hftOrderId;
      ELSIF p_action = 'CF' THEN
        IF v_edExectype IS NULL OR v_edExectype != 'D' THEN
          UPDATE bl_odmast bl SET cancelqtty = cancelqtty + p_cancelQtty,
                                  remainqtty = 0,
                                  pstatus= pstatus || status,
                                  status= 'E',
                                  last_change= systimestamp,
                                  FEEDBACKMSG = 'Order canceled'
          where hftOrderId = p_hftOrderId;
          pv_err_code := '2';
          RETURN;
        ELSE
          UPDATE bl_odmast bl SET cancelqtty = cancelqtty + p_cancelQtty,
                                  remainqtty = remainqtty - p_cancelQtty,
                                  pstatus= case when quantity - (cancelqtty + p_cancelqtty + execqtty) = 0 then pstatus|| status else pstatus end,
                                  status= case when quantity - (cancelqtty + p_cancelqtty + execqtty) = 0 then 'C' -- Cancel
                                               else status end,
                                  edstatus = case when quantity - (cancelqtty + p_cancelqtty + execqtty) = 0 then 'W' else 'N' end,
                                  last_change= systimestamp,
                                  FEEDBACKMSG = 'Order canceled'
          where blorderid = v_refBlOrderId;
          UPDATE bl_odmast bl SET status = 'C',
                                  FEEDBACKMSG = 'Order canceled'
          WHERE hftOrderId = p_hftOrderId;
        END IF;
      END IF;
    END IF;
    plog.setEndSection(pkgctx, 'sp_cancel_order_response');
  EXCEPTION
    WHEN OTHERS THEN
      pv_err_code := '-1';
      plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection(pkgctx, 'sp_cancel_order_response');
  END;

  PROCEDURE sp_amend_order_response (pv_err_code    OUT VARCHAR2,
                                     p_action           VARCHAR2,
                                     p_hftOrderId       VARCHAR2,
                                     p_amendQtty        NUMBER,
                                     p_text             VARCHAR2 DEFAULT '')
  IS
  v_edExectype    bl_odmast.edexectype%TYPE;
  v_refBlOrderId  bl_odmast.blorderid%TYPE;
  v_blStatus      bl_odmast.status%TYPE;
  v_execQtty      bl_odmast.execqtty%TYPE;
  v_execAmt       bl_odmast.execamt%TYPE;

  v_blOrderId     bl_odmast.Blorderid%TYPE;
  l_blOrderMapId  bl_maporder.mapid%TYPE;
  l_org_mapId     bl_maporder.mapid%TYPE;
  l_countPendingConfirm  NUMBER;
  l_org_qtty             bl_maporder.qtty%TYPE;-- KL Lenh Goc
  l_qtty                 bl_maporder.qtty%TYPE; -- KL Lenh Sua
  l_execType             bl_maporder.exectype%TYPE;
  l_execQtty             bl_maporder.execqtty%TYPE;
  BEGIN
    plog.setBeginSection(pkgctx, 'sp_amend_order_response');
    pv_err_code := '0';
    IF fn_get_blOrderId_by_hftOrderId(p_hftOrderId, v_blOrderId, l_blOrderMapId) <> 0 THEN
      pv_err_code := '1'; -- Khong Tim Thay SHL
      plog.error(pkgctx, 'Order Not Found ' || p_hftOrderId);
      plog.setEndSection(pkgctx, 'sp_cancel_order_response');
      RETURN;
    END IF;


    IF l_blOrderMapId IS NOT NULL THEN -- Lenh Manual
      SELECT refMapid, qtty INTO l_org_mapId, l_qtty FROM bl_maporder WHERE mapid = l_blOrderMapId;
      SELECT qtty, execType INTO l_org_qtty, l_execType FROM bl_maporder WHERE Mapid = l_org_mapId;

      IF p_action = 'RJ' THEN
        UPDATE bl_maporder SET status = 'R',
                               pstatus = pstatus || status,
                               last_change = systimestamp
        WHERE mapId = l_blOrderMapId AND status = 'F';
        UPDATE bl_mapOrder SET status = 'F',
                               pstatus = pstatus || status,
                               last_change = systimestamp
        WHERE mapId = l_org_mapId;
        UPDATE bl_odmast SET last_Change = systimestamp,
                             sentQtty = sentQtty - greatest(0, l_qtty - l_org_qtty)
        WHERE blOrderId = v_blOrderId;
      ELSE
        UPDATE bl_maporder SET status = 'M',
                               pstatus = pstatus || status,
                               last_change = systimestamp,
                               remainQtty = 0
        WHERE mapId = l_org_mapId;
        UPDATE Bl_Maporder SET status = 'F',
                               pstatus = pstatus || status,
                               last_change = systimestamp,
                               qtty = p_amendQtty,
                               execQtty = 0, execAmt = 0,
                               remainQtty = p_amendQtty,
                               execType = l_execType
        WHERE mapId = l_blOrderMapId;
        UPDATE bl_odmast SET sentQtty = sentQtty  - greatest(0, l_org_qtty - l_qtty),
                             last_change = systimestamp
        WHERE blOrderId = v_blOrderId;
      END IF;
    ELSE
      -- Lenh Direct
      BEGIN
        SELECT edexectype, refblorderid, status, execqtty, execamt
        INTO v_edExectype, v_refBlOrderId, v_blStatus, v_execQtty, v_execAmt
        FROM bl_odmast bl
        WHERE hftOrderId = p_hftOrderId
        AND bl.edexectype = 'A';
        pv_err_code := '0';
      EXCEPTION
        WHEN OTHERS THEN
          pv_err_code := '1';
          plog.setEndSection(pkgctx, 'sp_amend_order_response');
          RETURN;
      END;
      IF p_action = 'RJ' THEN
          UPDATE bl_odmast SET pstatus = pstatus || status,
                               status = 'R',
                               FEEDBACKMSG = 'Replace Order Reject',
                               LAST_CHANGE = SYSTIMESTAMP
          WHERE hftorderid = p_hftOrderId;
          -- Cap nhat lenh goc
          UPDATE bl_odmast
          SET edstatus = 'N',
              LAST_CHANGE = SYSTIMESTAMP,
              FEEDBACKMSG = NVL(p_text, 'Replace Order Reject')
          WHERE blorderid = v_refBlOrderId;
      ELSIF p_action = 'CF' THEN
          UPDATE bl_odmast SET remainqtty = 0,
                               edstatus = 'S',
                               pstatus = pstatus || status,
                               status = 'M', -- M = Modified
                               last_change = SYSTIMESTAMP,
                               FEEDBACKMSG = 'Replace Order success'
          WHERE blorderid = v_refBlOrderId;
          -- Cap nhat lenh y/c sua thanh lenh moi
          UPDATE bl_odmast SET
              pstatus = pstatus || status,
              status = v_blStatus,
              edstatus = 'N', -- Lenh binh thuong
              execqtty = v_execQtty,
              execamt = v_execAmt,
              sentqtty = quantity,
              last_change = SYSTIMESTAMP,
              FEEDBACKMSG = NVL(p_text, 'Replace Order success')
          WHERE hftorderid = p_hftOrderId;

      END IF;
    END IF;
    plog.setEndSection(pkgctx, 'sp_amend_order_response');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      pv_err_code := '1';
      plog.setEndSection(pkgctx, 'sp_amend_order_response');
  END;

  PROCEDURE sp_confirm_MK_2_LO (pv_err_code   OUT VARCHAR2,
                                p_hftOrderId      VARCHAR2,
                                p_price           VARCHAR2)
  IS
  --v_count   NUMBER;
  l_blOrderId    bl_odmast.blorderid%TYPE;
  l_orderMapId   bl_maporder.mapid%TYPE;
  BEGIN
    plog.setBeginSection(pkgctx, 'sp_confirm_MK_2_LO');
    /*SELECT COUNT(1) INTO v_count
    FROM bl_odmast
    WHERE hftOrderId = p_hftOrderId;
    IF v_count = 0 THEN
      pv_err_code := '1';
      plog.setEndSection(pkgctx, 'sp_confirm_MK_2_LO');
      RETURN;
    ELSE
      pv_err_code := '0';
    END IF;*/
    pv_err_code := '0';
    IF fn_get_blOrderId_by_hftOrderId(p_hftOrderId, l_blOrderId, l_orderMapId) <> 0 THEN
      pv_err_code := '1';
      plog.setEndSection(pkgctx, 'sp_confirm_MK_2_LO');
      RETURN;
    END IF;
    IF l_orderMapId IS NULL THEN
      UPDATE bl_odmast SET price = p_price,
                           pricetype = 'LO',
                           fixordtype = '2',
                           fixtimeinforc = '0',
                           last_change= systimestamp,
                           FEEDBACKMSG = 'Confirm market price to limit price'
      WHERE hftOrderId = p_hftOrderId;

    ELSE
      UPDATE bl_maporder SET price = p_price,
                             priceType = 'LO',
                             last_change = systimestamp
      WHERE mapId = l_orderMapId;
      UPDATE bl_odmast SET last_change = systimestamp WHERE blOrderId = l_blOrderId;
      pv_err_code := '3';

    END IF;


    plog.setEndSection(pkgctx, 'sp_confirm_MK_2_LO');
  EXCEPTION
    WHEN OTHERS THEN
      pv_err_code := '-1';
      plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection(pkgctx, 'sp_confirm_MK_2_LO');
  END;

  PROCEDURE sp_matching_order (pv_err_code    OUT VARCHAR2,
                               p_hftOrderId       VARCHAR2,
                               p_qtty             NUMBER,
                               p_price            NUMBER)
  IS
  --v_count   NUMBER;
  l_blOrderId    bl_odmast.blorderid%TYPE;
  l_mapOrderId   bl_maporder.mapid%TYPE;
  BEGIN
    plog.setBeginSection (pkgctx, 'sp_matching_order');
    pv_err_code := '0';

    /*BEGIN
      SELECT COUNT(1) INTO v_count
      FROM bl_odmast
      WHERE hftOrderId = p_hftOrderId;
    EXCEPTION
      WHEN OTHERS THEN
        pv_err_code := '1';
        plog.setEndSection (pkgctx, 'sp_matching_order');
        RETURN;
    END;
    IF v_count = 0 THEN
      pv_err_code := '1';
      plog.setEndSection (pkgctx, 'sp_matching_order');
      RETURN;
    ELSE
      pv_err_code := '0';
    END IF;*/
    IF fn_get_blOrderId_by_hftOrderId (p_hftOrderId, l_blOrderId, l_mapOrderId) <> 0 THEN
      pv_err_code := '1'; -- Order Not Found
      plog.setEndSection (pkgctx, 'sp_matching_order');
      RETURN;
    END IF;
    IF l_mapOrderId IS NOT NULL THEN
      UPDATE bl_maporder SET execqtty = execqtty + p_qtty,
                             remainQtty = remainQtty - p_qtty,
                             execamt = execamt + p_qtty * p_price
      WHERE mapId = l_mapOrderId;
    END IF;

    UPDATE bl_odmast SET execqtty = execqtty + p_qtty,
                         remainqtty = remainqtty - p_qtty,
                         execamt = execamt + p_qtty * p_price,
                         feedbackmsg = 'Matching order',
                         status = case when quantity - (cancelqtty + execqtty + p_qtty) = 0
                                            and cancelqtty > 0 then 'C'
                                       else status end,
                         pstatus = case when quantity - (cancelqtty + execqtty + p_qtty) = 0
                                              and cancelqtty > 0 then pstatus || status
                                        else pstatus end,
                         edstatus = case when quantity - (cancelqtty + execqtty + p_qtty) = 0
                                              and cancelqtty > 0 then 'W'
                                         else edstatus end,
                         last_change= systimestamp
    WHERE blOrderid = l_blOrderId;

    plog.setEndSection (pkgctx, 'sp_matching_order');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error (pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      pv_err_code := '-1';
      plog.setEndSection (pkgctx, 'sp_matching_order');
  END;

  PROCEDURE sp_order_done4day (pv_err_code    OUT VARCHAR2,
                               p_hftOrderId       VARCHAR2)
  IS
  v_count   NUMBER;
  l_blOrderId    bl_odmast.blorderid%TYPE;
  l_blOrderMapId bl_maporder.mapid%TYPE;
  l_qtty         bl_maporder.qtty%TYPE;
  BEGIN
    plog.setBeginSection (pkgctx, 'sp_order_done4day');
    pv_err_code := '0';
    /*SELECT  COUNT(1) INTO v_count
    FROM bl_odmast
    WHERE hftOrderId = p_hftOrderId;

    IF v_count = 0 THEN
      pv_err_code := '1';
      plog.setEndSection (pkgctx, 'sp_order_done4day');
      RETURN;
    ELSE
      pv_err_code := '0';
    END IF;*/

    IF fn_get_blOrderId_by_hftOrderId(p_hftOrderId, l_blOrderId, l_blOrderMapId) <> 0 THEN
      pv_err_code := '1'; -- Order Not Found
      plog.setEndSection (pkgctx, 'sp_order_done4day');
      RETURN;
    END IF;
    IF l_blOrderMapId IS NOT NULL THEN
      SELECT remainqtty INTO l_qtty FROM bl_maporder WHERE mapId = l_blOrderMapId;

      UPDATE bl_maporder SET remainqtty = 0 WHERE mapid = l_blOrderMapId;
      UPDATE bl_odmast SET sentqtty = sentqtty - l_qtty WHERE blOrderId = l_blOrderId;
      pv_err_code := '3'; -- Khong Gui Done4Day cho BLP
    ELSE
      UPDATE bl_odmast SET status = 'E',
                           cancelqtty = 0,
                           remainqtty = 0,
                           pstatus = pstatus || status,
                           last_change = SYSTIMESTAMP,
                           feedbackmsg = 'Done for day'
      WHERE hftOrderId = p_hftOrderId;
    END IF;


    plog.setEndSection (pkgctx, 'sp_order_done4day');
  EXCEPTION
    WHEN OTHERS THEN
      plog.setEndSection (pkgctx, 'sp_order_done4day');
  END;

--------------------------------process request from ws---------------------------------------
  PROCEDURE sp_confirm_order (pv_err_code    OUT VARCHAR2,
                              pv_err_msg     OUT VARCHAR2,
                              p_blOrderId        VARCHAR2,
                              p_priceChkType     VARCHAR2,
                              p_tlid             VARCHAR2)
  IS
  l_count   NUMBER;
  l_exp     EXCEPTION;
  BEGIN
    plog.setBeginSection(pkgctx, 'sp_confirm_order');
    pv_err_code := systemnums.C_SUCCESS;
    pv_err_msg := '';
    SELECT COUNT(1) INTO l_count
    FROM bl_odmast b
    WHERE blOrderId = p_blOrderId
    AND b.blodtype IN ('5','3') AND b.app_status = 'P';
    IF NOT l_count = 1 THEN
      pv_err_code := '-700125';
      RAISE l_exp;
    END IF;

    IF NOT p_priceChkType IN ('1','2','3', '4') THEN
      pv_err_code := '-700120';
      RAISE l_exp;
    END IF;

    UPDATE bl_odmast SET app_status = 'A',
                         edstatus = 'N',
                         feedBackMsg = 'Order is sent to Flex',
                         pricechktype = p_priceChkType,
                         last_change = systimestamp
    WHERE blOrderId = p_blOrderId;

    plog.setEndSection(pkgctx, 'sp_confirm_order');
  EXCEPTION
    WHEN l_exp THEN
      pv_err_msg := cspks_system.fn_get_errmsg(pv_err_code);
      plog.setEndSection(pkgctx, 'sp_confirm_order');
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      pv_err_code := '-1';
      pv_err_msg := 'System Error';
      plog.setEndSection (pkgctx, 'sp_confirm_order');
  END;

  PROCEDURE sp_reject_order (pv_err_code    OUT VARCHAR2,
                             pv_err_msg     OUT VARCHAR2,
                             p_blOrderId        VARCHAR2,
                             p_tlid             VARCHAR2)
  IS
  l_count   NUMBER;
  l_exp     EXCEPTION;
  BEGIN
    plog.setBeginSection(pkgctx, 'sp_reject_order');
    pv_err_code := systemnums.C_SUCCESS;
    pv_err_msg := '';

    SELECT COUNT(1) INTO l_count
    FROM bl_odmast b
    WHERE blOrderId = p_blOrderId
    AND b.blodtype IN ('5','3') AND b.app_status = 'P';
    IF NOT l_count = 1 THEN
      pv_err_code := '-700120';
      RAISE l_exp;
    END IF;

    UPDATE bl_odmast SET app_status = 'R',
                         status = 'R',
                         pstatus = pstatus || status,
                         feedBackMsg = 'Cancel by KBSV',
                         cancelQtty = remainQtty,
                         remainQtty = 0,
                         last_change = systimestamp
    WHERE blOrderId = p_blOrderId;

    plog.setEndSection(pkgctx, 'sp_reject_order');
  EXCEPTION
    WHEN l_exp THEN
      pv_err_msg := cspks_system.fn_get_errmsg(pv_err_code);
      plog.setEndSection(pkgctx, 'sp_reject_order');
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      pv_err_code := '-1';
      pv_err_msg := 'System Error';
      plog.setEndSection (pkgctx, 'sp_reject_order');
  END;

  PROCEDURE sp_add_broker_note (pv_err_code    OUT VARCHAR2,
                                pv_err_msg     OUT VARCHAR2,
                                p_blOrderId        VARCHAR2,
                                p_brokerNote       VARCHAR2,
                                p_tlid             VARCHAR2)
  IS
  l_count   NUMBER;
  l_exp     EXCEPTION;
  BEGIN
    plog.setBeginSection(pkgctx, 'sp_add_broker_note');
    pv_err_code := systemnums.C_SUCCESS;
    pv_err_msg := '';
    SELECT COUNT(1) INTO l_count
    FROM bl_odmast b
    WHERE blOrderId = p_blOrderId;
    IF NOT l_count = 1 THEN
      pv_err_code := '-700125';
      RAISE l_exp;
    END IF;

    UPDATE bl_odmast SET remngcomment = p_brokerNote,
                         last_change = systimestamp
    WHERE blOrderId = p_blOrderId;

    plog.setEndSection(pkgctx, 'sp_add_broker_note');
  EXCEPTION
    WHEN l_exp THEN
      pv_err_msg := cspks_system.fn_get_errmsg(pv_err_code);
      plog.setEndSection(pkgctx, 'sp_add_broker_note');
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      pv_err_code := '-1';
      pv_err_msg := 'System Error';
      plog.setEndSection (pkgctx, 'sp_add_broker_note');
  END;

  PROCEDURE sp_place_order (pv_err_code    OUT VARCHAR2,
                           pv_err_msg     OUT VARCHAR2,
                           pv_autoid      OUT VARCHAR2,
                           p_blOrderId        VARCHAR2,
                           p_qtty             NUMBER,
                           p_price            VARCHAR2,
                           p_priceType        VARCHAR2,
                           p_tlid             VARCHAR2)
  IS
  l_count         NUMBER;
  l_exp           EXCEPTION;
  l_quantity      bl_odmast.quantity%TYPE;
  l_sentQtty      bl_odmast.sentqtty%TYPE;
  l_execQtty      bl_odmast.execqtty%TYPE;
  l_execAmt       bl_odmast.execamt%TYPE;
  l_orderPrice    bl_odmast.price%TYPE;
  l_priceChkType  bl_odmast.pricechktype%TYPE;
  l_symbol        bl_odmast.symbol%TYPE;
  l_execType      bl_odmast.exectype%TYPE;
  l_priceCheck    NUMBER(23,4);
  l_waitingQtty   bl_odmast.quantity%TYPE;
  l_pendingQtty   bl_odmast.quantity%TYPE;
  l_ceilPrice     securities_info.ceilingprice%TYPE;
  l_floorPrice    securities_info.floorprice%TYPE;
  l_cancelQtty    bl_odmast.cancelqtty%TYPE;
  l_tradePlace    sbsecurities.tradeplace%TYPE;
  BEGIN
    plog.setBeginSection(pkgctx, 'sp_place_order');
    pv_err_code := systemnums.C_SUCCESS;
    pv_err_msg := '';
    -- Ghi Processing tranh double check
    BEGIN
      INSERT INTO bl_odmast_processing(blorderid, eventname)
      VALUES (p_blOrderId, 'sp_place_order');
    EXCEPTION
      WHEN OTHERS THEN
        pv_err_code := '-700121';
        RAISE l_exp;
    END;

    -- Lay Thong tin Lenh
    BEGIN
      SELECT bl.quantity, bl.price, bl.sentqtty, bl.execamt, bl.pricechktype, bl.symbol, bl.exectype, bl.execqtty, bl.cancelqtty,
             sb.tradeplace
      INTO l_quantity, l_orderPrice, l_sentQtty, l_execAmt, l_priceChkType, l_symbol, l_execType, l_execQtty, l_cancelQtty,
           l_tradePlace
      FROM bl_odmast bl, sbsecurities sb
      WHERE bl.blorderid = p_blOrderId
      AND bl.blodtype IN ('5', '3')
      AND bl.remainqtty > 0 AND bl.app_status = 'A'
      AND bl.codeid = sb.codeid;

      SELECT sec.ceilingprice, sec.floorprice
      INTO l_ceilPrice, l_floorPrice
      FROM securities_info sec
      WHERE sec.symbol = l_symbol;
    EXCEPTION
      WHEN OTHERS THEN
        pv_err_code := '-700122';
        RAISE l_exp;
    END;
    IF l_quantity = 0 THEN
      pv_err_code := '-95018';
      RAISE l_exp;
    END IF;
    IF NOT p_qtty > 0 THEN
      pv_err_code := '-95018';
      RAISE l_exp;
    END IF;

    -- Kiem tra khoi luong phai dung lo GD
    If pr_check_tradelot(p_qtty, l_tradePlace) != 0 Then
      pv_err_code  := '-95009';
      RAISE l_exp;
    End If;
    If pr_check_maxQtty(p_qtty, l_tradePlace) != 0 Then
      pv_err_code  := '-95018';
      RAISE l_exp;
    End If;

    l_waitingQtty := l_quantity - l_sentQtty - l_cancelQtty;
    IF l_waitingQtty < p_qtty THEN
      pv_err_code := '-700123';
      RAISE l_exp;
    END IF;
    IF p_price > l_ceilPrice OR p_price < l_floorPrice THEN
      pv_err_code := -700012;
      RAISE l_exp;
    END IF;

    IF l_priceChkType = '1' THEN -- Gia cua lenh con khong vuot lenh chi thi
      l_priceCheck := l_orderPrice;
    ELSIF l_priceChkType = '2' THEN
      l_priceCheck := ROUND((l_quantity * l_orderPrice - l_execAmt) / (l_quantity - l_execQtty), 4);
    ELSIF l_priceChkType = '3' THEN
      l_priceCheck := p_price; -- Khong check gia
    END IF;

    IF     (l_execType = 'NB' AND p_price > l_priceCheck)
        OR (l_execType = 'NS' AND p_price < l_priceCheck) THEN
      pv_err_code := '-700124';
      RAISE l_exp;
    END IF;

    pv_autoid := fn_get_mapOrderId(p_blOrderId);
    INSERT INTO bl_maporder (mapid,
                             blorderid,
                             qtty,
                             price,
                             remainqtty,
                             pricetype,
                             exectype,
                             exqtty,
                             exexectype,
                             execqtty,
                             execamt,
                             tlid,
                             status)
    VALUES (pv_autoid,
            p_blOrderId,
            p_qtty,
            p_price,
            p_qtty,
            p_priceType,
            l_execType,
            p_qtty,
            l_execType,
            0,
            0,
            p_tlid,
            'P');
    UPDATE bl_odmast SET sentqtty = sentqtty + p_qtty,
                         status = decode (status, 'P', 'F', status),
                         pstatus = pstatus || decode (status, 'P', status, ''),
                         last_change = SYSTIMESTAMP
    WHERE blOrderId = p_blOrderId;

    DELETE bl_odmast_processing WHERE blorderid = p_blOrderId;
    plog.setEndSection(pkgctx, 'sp_place_order');
  EXCEPTION
    WHEN l_exp THEN
      DELETE bl_odmast_processing WHERE blorderid = p_blOrderId;
      pv_err_msg := cspks_system.fn_get_errmsg(pv_err_code);
      plog.setEndSection (pkgctx, 'sp_place_order');
    WHEN OTHERS THEN
      DELETE bl_odmast_processing WHERE blorderid = p_blOrderId;
      plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      pv_err_code := '-1';
      pv_err_msg := 'System Error';
      plog.setEndSection (pkgctx, 'sp_place_order');
  END;

  PROCEDURE sp_replace_map_order (pv_err_code    OUT VARCHAR2,
                             pv_err_msg     OUT VARCHAR2,
                             pv_autoid      OUT VARCHAR2,
                             p_blOrderId        VARCHAR2,
                             p_orderMapId       VARCHAR2,
                             p_qtty             NUMBER,
                             p_price            VARCHAR2,
                             p_tlid             VARCHAR2)
  IS
  l_exp     EXCEPTION;
  l_remainQtty    bl_maporder.remainqtty%TYPE;
  l_org_qtty      bl_maporder.qtty%TYPE;
  l_status        bl_maporder.status%TYPE;
  l_execType      bl_maporder.exectype%TYPE;
  l_execQtty      bl_maporder.execqtty%TYPE;
  l_symbol        sbsecurities.symbol%TYPE;
  l_tradePlace    sbsecurities.tradeplace%TYPE;
  l_amend_mapid   bl_maporder.mapid%TYPE;
  l_sentQtty      bl_odmast.sentqtty%TYPE;
  l_priceChkType  bl_odmast.pricechktype%TYPE;
  l_orderPrice    bl_odmast.price%TYPE;
  l_orderQtty     bl_odmast.quantity%TYPE;
  l_orderExecAmt  bl_odmast.execamt%TYPE;
  l_orderExecQtty bl_odmast.execqtty%TYPE;
  l_priceCheck    bl_odmast.price%TYPE;
  l_waitingQtty   bl_odmast.quantity%TYPE;
  l_cancelQtty    bl_odmast.cancelqtty%TYPE;
  BEGIN
    plog.setBeginSection(pkgctx, 'sp_replace_order');
    pv_err_code := systemnums.C_SUCCESS;
    pv_err_msg := '';
    -- Ghi Processing tranh double check
    BEGIN
      INSERT INTO bl_odmast_processing(blorderid, eventname)
      VALUES (p_blOrderId, 'sp_replace_map_order');
      INSERT INTO bl_odmast_processing(blorderid, eventname)
      VALUES (p_orderMapId, 'sp_replace_map_order');
    EXCEPTION
      WHEN OTHERS THEN
        pv_err_code := '-700121';
        RAISE l_exp;
    END;

    BEGIN
      SELECT blm.remainqtty, blm.status, blm.execType, blm.execQtty, blo.symbol, blm.qtty, blo.pricechktype,
             blo.price, blo.quantity, blo.execamt, blo.sentqtty, blo.cancelqtty, blo.execqtty
      INTO l_remainQtty, l_status, l_execType, l_execQtty, l_symbol, l_org_qtty, l_priceChkType,
           l_orderPrice, l_orderQtty, l_orderExecAmt, l_sentQtty, l_cancelQtty, l_orderExecQtty
      FROM bl_maporder blm, bl_odmast blo
      WHERE blm.blorderid = p_blOrderId AND blm.mapid = p_orderMapId
      AND blm.blorderid = blo.blorderid;

      SELECT tradeplace INTO l_tradePlace
      FROM sbsecurities
      WHERE symbol = l_symbol;
    EXCEPTION
      when OTHERS THEN
        pv_err_code := '-700125';
        RAISE l_exp;
    END;
    l_waitingQtty := l_orderQtty - l_sentQtty - l_cancelQtty;
    IF l_waitingQtty < p_qtty - l_org_qtty THEN
      pv_err_code := '-700123';
      RAISE l_exp;
    END IF;
    IF NOT (l_remainQtty > 0 AND l_status IN ('P','F')) THEN
      pv_err_code := '-95023';
      RAISE l_exp;
    END IF;
    IF l_execQtty >= p_qtty THEN
      pv_err_code := '-701111';
      RAISE l_exp;
    END IF;
    IF l_tradePlace = '001' THEN
      pv_err_code := '-700052';
      RAISE l_exp;
    END IF;
    IF NOT p_qtty > 0 THEN
      pv_err_code := '-95018';
      RAISE l_exp;
    END IF;
    -- Kiem tra khoi luong phai dung lo GD
    If pr_check_tradelot(p_qtty, l_tradePlace) != 0 Then
      pv_err_code  := '-95009';
      RAISE l_exp;
    End If;
    If pr_check_maxQtty(p_qtty, l_tradePlace) != 0 Then
      pv_err_code  := '-95018';
      RAISE l_exp;
    End If;

    IF (p_qtty >= 100 AND l_org_qtty < 100) OR (p_qtty < 100 AND l_org_qtty >= 100) THEN
      pv_err_code  := '-95039';
      RAISE l_exp;
    END IF;

    -- Check Gia Dat Lenh
    IF l_priceChkType = '1' THEN -- Gia cua lenh con khong vuot lenh chi thi
      l_priceCheck := l_orderPrice;
    ELSIF l_priceChkType = '2' THEN -- Gia TB khong vuot gia chi thi
      l_priceCheck := ROUND((l_orderQtty * l_orderPrice - l_orderExecAmt) / (l_orderQtty - l_orderExecQtty), 4);
    ELSIF l_priceChkType = '3' THEN
      l_priceCheck := p_price; -- Khong check gia
    END IF;
    IF     (l_execType = 'NB' AND p_price > l_priceCheck)
        OR (l_execType = 'NS' AND p_price < l_priceCheck) THEN
      pv_err_code := '-700124';
      RAISE l_exp;
    END IF;

    l_amend_mapid := fn_get_mapOrderId(p_blOrderId);
    l_execType := 'A' || substr(l_execType, 2, 1);
    INSERT INTO bl_maporder (mapid,
                             blorderid,
                             qtty,
                             price,
                             pricetype,
                             exectype,
                             exqtty,
                             exexectype,
                             execqtty,
                             execamt,
                             remainqtty,
                             cancelqtty,
                             txtime,
                             refmapid,
                             hftreforderid,
                             tlid,
                             status,
                             last_change)
    SELECT l_amend_mapid,
            p_blOrderId,
            p_qtty,
            p_price,
            'LO',
            l_execType,
            p_qtty,
            l_execType,
            0,
            0,
            p_qtty,
            0,
            TO_CHAR(SYSDATE, 'hh24:mi:ss'),
            b.mapid,
            b.hftorderid,
            p_tlid,
            'P',
            systimestamp
    FROM bl_maporder b
    WHERE blOrderId = p_blOrderId AND mapId = p_orderMapId;
    UPDATE bl_maporder SET status = 'A',
                           pstatus = pstatus || status
    WHERE blOrderId = p_blOrderId AND mapId = p_orderMapId;

    UPDATE bl_odmast SET last_change = systimestamp,
                         sentqtty = sentqtty + greatest(0, p_qtty - l_org_qtty)
    WHERE blOrderId = p_blOrderId;

    DELETE bl_odmast_processing WHERE blorderid IN (p_orderMapId, p_blOrderId);
    pv_autoid := l_amend_mapid;
    plog.setEndSection(pkgctx, 'sp_replace_order');
  EXCEPTION
    WHEN l_exp THEN
      DELETE bl_odmast_processing WHERE blorderid IN (p_orderMapId, p_blOrderId);
      pv_err_msg := fn_get_en_errmg(pv_err_code);
      plog.setEndSection (pkgctx, 'sp_replace_order');
    WHEN OTHERS THEN
      DELETE bl_odmast_processing WHERE blorderid IN (p_orderMapId, p_blOrderId);
      plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      pv_err_code := '-1';
      pv_err_msg := 'System Error';
      plog.setEndSection (pkgctx, 'sp_replace_order');
  END;

  PROCEDURE sp_cancel_all_map_order (pv_err_code    OUT VARCHAR2,
                             pv_err_msg     OUT VARCHAR2,
                             pv_autoid      OUT VARCHAR2,
                             p_blOrderId        VARCHAR2,
                             p_tlid             VARCHAR2)
  IS
  l_exp     EXCEPTION;
  l_cancel_mapId  bl_maporder.mapid%TYPE;
  l_execType  bl_maporder.exectype%TYPE;
  l_tradePlace   sbsecurities.tradeplace%TYPE;
  l_sessionId    VARCHAR2(1000);
  BEGIN
    plog.setBeginSection(pkgctx, 'sp_cancel_all_map_order');
    pv_err_code := systemnums.C_SUCCESS;
    pv_err_msg := '';
    pv_autoid := '';
    -- Ghi Processing tranh double check
    BEGIN
      INSERT INTO bl_odmast_processing(blorderid, eventname)
      VALUES (p_blOrderId, 'sp_cancel_all_map_order');
    EXCEPTION
      WHEN OTHERS THEN
        pv_err_code := '-700121';
        RAISE l_exp;
    END;
    BEGIN
      SELECT execType, tradeplace INTO l_execType, l_tradePlace
      FROM bl_odmast bl, sbsecurities sb
      WHERE blOrderId = p_blOrderId
      AND sentQtty - execQtty - cancelQtty > 0
      AND blOdType IN ('3','5')
      AND bl.codeid = sb.codeid;
      l_execType := 'C' || substr(l_execType, 2, 1);
    EXCEPTION
      WHEN OTHERS THEN
        pv_err_code := '-700125';
        RAISE l_exp;
    END;

    BEGIN
      SELECT execType, sb.tradeplace INTO l_execType, l_tradePlace
      FROM bl_odmast bl, sbsecurities sb
      WHERE blOrderId = p_blOrderId
      AND remainqtty > 0
      AND blOdType IN ('3','5')
      AND execType IN ('NB', 'NS')
      AND bl.codeid = sb.codeid;
      l_execType := 'C' || substr(l_execType, 2, 1);

    EXCEPTION
      WHEN OTHERS THEN
        pv_err_code := '-700125';
        RAISE l_exp;
    END;

    IF l_tradePlace = '001' THEN
       SELECT sysvalue INTO l_sessionId FROM ordersys WHERE sysname='CONTROLCODE';
       If l_sessionId  IN ('A','P') THEN
         pv_err_code := '-95015';
         RAISE l_exp;
       END IF;
    END IF;
    IF l_tradePlace ='002' THEN
      SELECT nvl( sysvalue,'CLOSEALL')
      INTO l_sessionId
      FROM ordersys_ha
      WHERE sysname = 'TRADINGID';
      IF  l_sessionId IN ('CLOSE','CLOSE_BL')THEN
        pv_err_code := '-95015';
        RAISE l_exp;
      END IF;
      IF l_sessionId IN ('CLOSEALL') THEN
        pv_err_code := '-95043';
        Raise l_exp;
      END IF;
    END IF;

    FOR rec IN (
      SELECT *
      FROM bl_maporder
      WHERE blOrderId = p_blOrderId
      AND remainqtty > 0 AND status NOT IN ('C', 'D', 'M', 'R', 'A')
      AND exectype IN ('NB','NS')
    ) LOOP
      l_cancel_mapId := fn_get_mapOrderId(p_blOrderId);
      INSERT INTO bl_maporder (mapid,
                            blorderid,
                            qtty,
                            price,
                            pricetype,
                            exectype,
                            exqtty,
                            exexectype,
                            remainqtty,
                            cancelqtty,
                            refmapid,
                            hftreforderid,
                            tlid,
                            status)
      VALUES (l_cancel_mapId,
           p_blOrderId,
           rec.qtty,
           rec.price,
           rec.priceType,
           l_execType,
           rec.qtty,
           l_execType,
           rec.remainqtty,
           rec.cancelqtty,
           rec.mapid,
           rec.hftOrderId,
           p_tlid,
           'P');
      IF pv_autoid IS NULL THEN
        pv_autoid := l_cancel_mapId;
      ELSE
        pv_autoid := pv_autoid || ';' || l_cancel_mapId;
      END IF;
      UPDATE bl_maporder SET status = 'C',
                             pstatus = pstatus || status,
                             last_change = systimestamp
      WHERE mapid = rec.mapid;
    END LOOP;
    DELETE bl_odmast_processing WHERE blorderid IN (p_blOrderId);

    plog.setEndSection(pkgctx, 'sp_cancel_all_map_order');
  EXCEPTION
    WHEN l_exp THEN
      DELETE bl_odmast_processing WHERE blorderid IN (p_blOrderId);
      pv_err_msg := fn_get_en_errmg(pv_err_code);
      plog.setEndSection (pkgctx, 'sp_cancel_all_map_order');
    WHEN OTHERS THEN
      DELETE bl_odmast_processing WHERE blorderid IN (p_blOrderId);
      plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      pv_err_code := '-1';
      pv_err_msg := 'System Error';
      plog.setEndSection (pkgctx, 'sp_cancel_all_map_order');
  END;

  PROCEDURE sp_cancel_map_order (pv_err_code    OUT VARCHAR2,
                             pv_err_msg     OUT VARCHAR2,
                             pv_autoid      OUT VARCHAR2,
                             p_blOrderId        VARCHAR2,
                             p_orderMapId       VARCHAR2,
                             p_tlid             VARCHAR2)
  IS
  l_exp          EXCEPTION;
  l_status       bl_maporder.status%TYPE;
  l_remain_qtty  bl_maporder.remainqtty%TYPE;
  l_execType     bl_maporder.exectype%TYPE;
  l_cancel_mapId bl_maporder.mapid%TYPE;
  l_tradePlace   sbsecurities.tradeplace%TYPE;
  l_sessionId    VARCHAR2(1000);
  BEGIN
    plog.setBeginSection(pkgctx, 'sp_cancel_map_order');
    pv_err_code := systemnums.C_SUCCESS;
    pv_err_msg := '';
    -- Ghi Processing tranh double check
    BEGIN
      INSERT INTO bl_odmast_processing(blorderid, eventname)
      VALUES (p_blOrderId, 'sp_cancel_map_order');
      INSERT INTO bl_odmast_processing(blorderid, eventname)
      VALUES (p_orderMapId, 'sp_cancel_map_orderMapId');
    EXCEPTION
      WHEN OTHERS THEN
        pv_err_code := '-700121';
        RAISE l_exp;
    END;
    BEGIN
      SELECT remainqtty, status, execType
      INTO l_remain_qtty, l_status, l_execType
      FROM bl_maporder
      WHERE blorderid = p_blOrderId AND mapid = p_orderMapId;
    EXCEPTION
      WHEN OTHERS THEN
        pv_err_code := '-700125';
        RAISE l_exp;
    END;
    IF NOT (l_remain_qtty > 0 AND l_status IN ('P','F')) THEN
      pv_err_code := '-95023';
      RAISE l_exp;
    END IF;

    BEGIN
      SELECT execType, sb.tradeplace INTO l_execType, l_tradePlace
      FROM bl_odmast bl, sbsecurities sb
      WHERE blOrderId = p_blOrderId
      AND remainqtty > 0
      AND blOdType IN ('3','5')
      AND execType IN ('NB', 'NS')
      AND bl.codeid = sb.codeid;
      l_execType := 'C' || substr(l_execType, 2, 1);

    EXCEPTION
      WHEN OTHERS THEN
        pv_err_code := '-700125';
        RAISE l_exp;
    END;

    IF l_tradePlace = '001' THEN
       SELECT sysvalue INTO l_sessionId FROM ordersys WHERE sysname='CONTROLCODE';
       If l_sessionId  IN ('A','P') THEN
         pv_err_code := '-95015';
         RAISE l_exp;
       END IF;
    END IF;
    IF l_tradePlace ='002' THEN
      SELECT nvl( sysvalue,'CLOSEALL')
      INTO l_sessionId
      FROM ordersys_ha
      WHERE sysname = 'TRADINGID';
      IF  l_sessionId IN ('CLOSE','CLOSE_BL')THEN
        pv_err_code := '-95015';
        RAISE l_exp;
      END IF;
      IF l_sessionId IN ('CLOSEALL') THEN
        pv_err_code := '-95043';
        Raise l_exp;
      END IF;
    END IF;

    l_execType := 'C' || substr(l_execType, 2, 1);
    l_cancel_mapId := fn_get_mapOrderId(p_blOrderId);
    UPDATE bl_maporder SET status = 'C',
                           pstatus = pstatus || status,
                           last_change = systimestamp
    WHERE mapid = p_orderMapId AND blorderid = p_blOrderId;
    INSERT INTO  bl_maporder (mapid,
                              blorderid,
                              qtty,
                              price,
                              pricetype,
                              exectype,
                              exqtty,
                              exexectype,
                              remainqtty,
                              cancelqtty,
                              refmapid,
                              hftreforderid,
                              tlid,
                              status)
    SELECT l_cancel_mapId,
           p_blOrderId,
           qtty,
           price,
           priceType,
           l_execType,
           qtty,
           l_execType,
           remainqtty,
           cancelqtty,
           mapid,
           hftOrderId,
           p_tlid,
           'P'
    FROM bl_maporder
    WHERE mapId = p_orderMapId
    AND blOrderId = p_blOrderId;
    pv_autoid := l_cancel_mapId;

    DELETE bl_odmast_processing WHERE blorderid IN (p_orderMapId, p_blOrderId);
    plog.setEndSection(pkgctx, 'sp_cancel_map_order');
  EXCEPTION
    WHEN l_exp THEN
      DELETE bl_odmast_processing WHERE blorderid IN (p_orderMapId, p_blOrderId);
      pv_err_msg := cspks_system.fn_get_errmsg(pv_err_code);
      plog.setEndSection (pkgctx, 'sp_cancel_map_order');
    WHEN OTHERS THEN
      DELETE bl_odmast_processing WHERE blorderid IN (p_orderMapId, p_blOrderId);
      plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      pv_err_code := '-1';
      pv_err_msg := 'System Error';
      plog.setEndSection (pkgctx, 'sp_cancel_map_order');
  END;
  PROCEDURE sp_cancel_from_fix (pv_err_code  OUT VARCHAR2,
                             pv_err_msg      OUT VARCHAR2,
                             pv_autoid       OUT VARCHAR2,
                             p_blOrderId         VARCHAR2,
                             p_tlid              VARCHAR2)
  IS
  l_exp          EXCEPTION;
  l_status       bl_maporder.status%TYPE;
  l_remain_qtty  bl_maporder.remainqtty%TYPE;
  l_execType     bl_maporder.exectype%TYPE;
  l_cancel_mapId bl_maporder.mapid%TYPE;
  l_tradePlace   sbsecurities.tradeplace%TYPE;
  l_sessionId    VARCHAR2(1000);
  l_priceChkType bl_odmast.pricechktype%TYPE;
  BEGIN
    plog.setBeginSection(pkgctx, 'sp_cancel_from_fix');
    pv_err_code := systemnums.C_SUCCESS;
    pv_err_msg := '';
    pv_autoid := '';
    -- Ghi Processing tranh double check
    BEGIN
      INSERT INTO bl_odmast_processing(blorderid, eventname)
      VALUES (p_blOrderId, 'sp_cancel_from_fix');
    EXCEPTION
      WHEN OTHERS THEN
        pv_err_code := '-700121';
        RAISE l_exp;
    END;
    BEGIN
      SELECT execType, sb.tradeplace, bl.pricechktype INTO l_execType, l_tradePlace, l_priceChkType
      FROM bl_odmast bl, sbsecurities sb
      WHERE blOrderId = p_blOrderId
      AND remainqtty > 0
      AND blOdType IN ('3','5')
      AND execType IN ('NB', 'NS')
      AND bl.codeid = sb.codeid;
      l_execType := 'C' || substr(l_execType, 2, 1);

    EXCEPTION
      WHEN OTHERS THEN
        pv_err_code := '-700125';
        RAISE l_exp;
    END;

    IF l_tradePlace = '001' THEN
       SELECT sysvalue INTO l_sessionId FROM ordersys WHERE sysname='CONTROLCODE';
       If l_sessionId  IN ('A','P') THEN
         pv_err_code := '-95015';
         RAISE l_exp;
       END IF;
    END IF;
    IF l_tradePlace ='002' THEN
      SELECT nvl( sysvalue,'CLOSEALL')
      INTO l_sessionId
      FROM ordersys_ha
      WHERE sysname = 'TRADINGID';
      IF  l_sessionId IN ('CLOSE','CLOSE_BL')THEN
        pv_err_code := '-95015';
        RAISE l_exp;
      END IF;
      IF l_sessionId IN ('CLOSEALL') THEN
        pv_err_code := '-95043';
        Raise l_exp;
      END IF;
    END IF;

    FOR rec IN (
      SELECT *
      FROM bl_maporder
      WHERE blOrderId = p_blOrderId
      AND remainqtty > 0 AND exectype IN ('NB','NS')
    ) LOOP
      l_cancel_mapId := fn_get_mapOrderId(p_blOrderId);
      INSERT INTO bl_maporder (mapid,
                            blorderid,
                            qtty,
                            price,
                            pricetype,
                            exectype,
                            exqtty,
                            exexectype,
                            remainqtty,
                            cancelqtty,
                            refmapid,
                            hftreforderid,
                            tlid,
                            status)
      VALUES (l_cancel_mapId,
           p_blOrderId,
           rec.qtty,
           rec.price,
           rec.priceType,
           l_execType,
           rec.qtty,
           l_execType,
           rec.remainqtty,
           rec.cancelqtty,
           rec.mapid,
           rec.hftOrderId,
           p_tlid,
           'P');
      IF pv_autoid IS NULL THEN
        pv_autoid := l_cancel_mapId;
      ELSE
        pv_autoid := pv_autoid || ';' || l_cancel_mapId;
      END IF;
      IF l_priceChkType = '4' THEN
        UPDATE bl_autoorderplan SET status = 'R' WHERE blorderid = p_blOrderId;
      END IF;
      UPDATE bl_maporder SET status = 'C',
                             pstatus = pstatus || status,
                             last_change = systimestamp
      WHERE mapid = rec.mapid;
    END LOOP;
    UPDATE bl_odmast SET remainqtty = remainqtty - (quantity - cancelQtty - sentqtty),
                         cancelqtty = cancelqtty + (quantity - cancelQtty - sentqtty),
                         status = case when quantity - (cancelqtty + (quantity - cancelQtty - sentqtty) + execqtty) = 0 then 'C' -- Cancel
                                               else status end,
                         edstatus = 'C',
                         last_change = systimestamp,
                         feedbackmsg = 'Cancel from KBSV',
                         ctlid = p_tlid
    WHERE blorderid = p_blOrderId;
    DELETE bl_odmast_processing WHERE blorderid IN (p_blOrderId);

    plog.setEndSection(pkgctx, 'sp_cancel_from_fix');
  EXCEPTION
    WHEN l_exp THEN
      DELETE bl_odmast_processing WHERE blorderid IN (p_blOrderId);
      pv_err_msg := fn_get_en_errmg(pv_err_code);
      plog.setEndSection (pkgctx, 'sp_cancel_from_fix');
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      pv_err_code := '-1';
      pv_err_msg := 'System Error';
      plog.setEndSection (pkgctx, 'sp_cancel_from_fix');
  END;

  PROCEDURE sp_make_order (pv_err_code    OUT VARCHAR2,
                           pv_err_msg     OUT VARCHAR2,
                           p_Afacctno         VARCHAR2,
                           p_symbol           VARCHAR2,
                           p_qtty             NUMBER,
                           p_price            NUMBER,
                           p_priceType        VARCHAR2,
                           p_side             VARCHAR2,
                           p_tlid             VARCHAR2)
  IS
  l_exp          EXCEPTION;
  l_count        NUMBER;
  l_handInst     bl_odmast.blodtype%TYPE := '5';
  v_tradeplace   sbsecurities.tradeplace%TYPE;
  v_tradelot     securities_info.tradelot%TYPE;
  v_floorprice   securities_info.floorprice%TYPE;
  v_ceilingprice securities_info.ceilingprice%TYPE;
  v_halt         sbsecurities.halt%TYPE;
  v_codeid       sbsecurities.codeid%TYPE;
  l_price        securities_info.basicprice%TYPE;
  v_ticksize     SECURITIES_TICKSIZE.Ticksize%TYPE;
  l_blOrderId    bl_odmast.blorderid%TYPE;
  l_currDate     DATE;
  l_strCurrDate  VARCHAR2(100);

  l_custodycd    cfmast.custodycd%TYPE;
  l_cfstatus     cfmast.status%TYPE;
  l_afstatus     afmast.status%TYPE;

  BEGIN
    plog.setBeginSection(pkgctx, 'sp_make_order');
    pv_err_code := systemnums.C_SUCCESS;
    pv_err_msg := '';

    BEGIN
      SELECT custodycd, cf.status, af.status
      INTO l_custodycd, l_cfstatus, l_afstatus
      FROM cfmast cf, afmast af
      WHERE cf.custid = af.custid
      AND af.acctno = p_Afacctno;
    EXCEPTION
      WHEN OTHERS THEN
        pv_err_code := '-200002';
        RAISE l_exp;
    END;
    IF (l_cfstatus = 'C' OR l_afstatus = 'C') THEN
      pv_err_code := '-200069';
      RAISE l_exp;
    END IF;

    BEGIN
      Select s.tradeplace, i.tradelot, i.floorprice, i.ceilingprice, s.halt, i.codeid
      into v_tradeplace, v_tradelot, v_floorprice, v_ceilingprice, v_halt, v_codeid
      from securities_info i, sbsecurities s
      where i.symbol = p_symbol
      and i.codeid = s.codeid;
    EXCEPTION
      WHEN OTHERS THEN
        pv_err_code  := '-100058';
        RAISE l_exp;
    END;
    If v_halt = 'Y' Then
      pv_err_code  := '-300025';
      RAISE l_exp;
    End If;

    -- Kiem tra khoi luong phai dung lo GD
    IF v_tradeplace = '001' THEN
      If pr_check_tradelot(p_qtty, v_tradeplace) != 0 Then
        pv_err_code  := '-95009';
        RAISE l_exp;
      End If;
    END IF;

    IF p_priceType = 'LO' THEN
      -- Kiem tra gia tran san
      IF p_price < v_floorprice OR p_price > v_ceilingprice THEN
        pv_err_code  := '-95010';
        RAISE l_exp;
      END IF;
      SELECT count(1) into l_count
      FROM SECURITIES_TICKSIZE
      WHERE symbol = p_symbol AND STATUS = 'Y'
        AND TOPRICE >= p_price AND FROMPRICE <= p_price;
      if l_count <= 0 then
        --Chua dinh nghia TICKSIZE
        pv_err_code  := '-95008';
        RAISE l_exp;
      else
        SELECT mod(p_price, ticksize)
        INTO v_ticksize
        FROM SECURITIES_TICKSIZE
        WHERE symbol = p_symbol AND STATUS = 'Y'
        AND TOPRICE >= p_price AND FROMPRICE <= p_price;
        If v_ticksize <> 0  Then
          pv_err_code  := '-95008';
          RAISE l_exp;
        End If;
      end if;
      l_price := p_price;
    ELSE
      IF p_side = 'NB' THEN
        l_price := v_ceilingprice;
      ELSE
        l_price := v_floorprice;
      END IF;
    END IF;

    IF p_priceType in ('MOK','MAK','MTL') AND v_tradeplace = '001' THEN
      pv_err_code  := '-95011';
      RAISE l_exp;
    ELSIF p_priceType in ('MP','ATO') AND v_tradeplace in ('002','005') THEN
      pv_err_code  := '-95011';
      RAISE l_exp;
    END IF;

    l_blOrderId := fn_get_blOrderId;
    l_currDate := getcurrdate;
    l_strCurrDate := TO_CHAR(l_currDate, 'dd/mm/rrrr');
    INSERT INTO bl_odmast(autoid, blorderid, blacctno, afacctno, custodycd,
                          status, blodtype, exectype, pricetype, timetype, codeid, symbol, quantity,
                          price, execqtty, execamt, remainqtty, cancelqtty, amendqtty, ptbookqtty,
                          sentqtty, feedbackmsg, activatedt,createddt, txdate, txnum,
                          effdate, expdate, via, deltd, username, direct, last_change, tlid,
                          ptsentqtty, isreasd, orgquantity, orgprice,
                          app_status, origexecqtty, origexecamt)
    VALUES (seq_bl_odmast.nextval, l_blOrderId, p_Afacctno, p_Afacctno, l_custodycd,
            'P', l_handInst, p_side, p_priceType, 'T', v_codeid, p_symbol, p_qtty,
            l_price, 0, 0, p_qtty, 0, 0, 0,
            0, 'Receive new order', l_strCurrDate, l_strCurrDate, l_currDate, '',
            l_currDate, l_currDate, 'L', 'N', p_tlid, 'Y', systimestamp, p_tlid,
            0, 'N', p_qtty, l_price,
            'P', 0, 0);

    plog.setEndSection(pkgctx, 'sp_make_order');
  EXCEPTION
    WHEN l_exp THEN
      pv_err_msg := fn_get_en_errmg(pv_err_code);
      plog.setEndSection (pkgctx, 'sp_make_order');
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      pv_err_code := '-1';
      pv_err_msg := 'System Error';
      plog.setEndSection (pkgctx, 'sp_make_order');
  END;

  PROCEDURE sp_replace_broker_order (pv_err_code    OUT VARCHAR2,
                             pv_err_msg     OUT VARCHAR2,
                             pv_autoid      OUT VARCHAR2,
                             p_blOrderId        VARCHAR2,
                             p_qtty             NUMBER,
                             p_price            VARCHAR2,
                             p_tlid             VARCHAR2)
  IS
  l_exp           EXCEPTION;
  l_count         NUMBER;
  l_remainQtty    bl_odmast.remainqtty%TYPE;
  l_status        bl_odmast.status%TYPE;
  l_execType      bl_odmast.exectype%TYPE;
  l_execQtty      bl_odmast.execqtty%TYPE;
  l_symbol        bl_odmast.symbol%TYPE;
  l_org_price     bl_odmast.price%TYPE;
  l_org_quantity  bl_odmast.quantity%TYPE;
  l_execAmt       bl_odmast.execamt%TYPE;
  l_sentQtty      bl_odmast.sentqtty%TYPE;
  l_cancelQtty    bl_odmast.cancelqtty%TYPE;
  l_tradePlace    sbsecurities.tradeplace%TYPE;
  l_edStatus      bl_odmast.edstatus%TYPE;
  l_codeid        bl_odmast.codeid%TYPE;
  l_fromPrice     securities_ticksize.fromprice%TYPE;
  l_tickSize      securities_ticksize.ticksize%TYPE;
  l_marketStatus  ordersys.sysvalue%TYPE;
  l_remain_map    bl_odmast.remainqtty%TYPE;
  l_amend_blOrderId      bl_odmast.blorderid%TYPE;
  l_strCurrDate   VARCHAR2(100);
  l_currDate      DATE;
  l_cancel_execType      bl_odmast.exectype%TYPE;

  BEGIN
    plog.setBeginSection (pkgctx, 'sp_replace_broker_order');
    pv_err_code := systemnums.C_SUCCESS;
    pv_err_msg := '';
    pv_autoid := '';
    BEGIN
      INSERT INTO bl_odmast_processing(blorderid, eventname)
      VALUES (p_blOrderId, 'sp_replace_broker_order');
    EXCEPTION
      WHEN OTHERS THEN
        pv_err_code := '-700121';
        RAISE l_exp;
    END;
    SELECT varvalue INTO l_strCurrDate FROM sysvar WHERE varname = 'CURRDATE' AND grname = 'SYSTEM';
    l_currDate := TO_DATE(l_strCurrDate, systemnums.C_DATE_FORMAT);
    BEGIN
      SELECT bl.remainqtty, bl.status, bl.execType, bl.execQtty, bl.symbol, bl.edstatus, bl.codeid,
             bl.price, bl.quantity, bl.execamt, bl.sentqtty, bl.cancelqtty
      INTO l_remainQtty, l_status, l_execType, l_execQtty, l_symbol, l_edStatus, l_codeid,
           l_org_price, l_org_quantity, l_execAmt, l_sentQtty, l_cancelQtty
      FROM bl_odmast bl
      WHERE bl.blorderid = p_blOrderId
      AND bl.blodtype = '5' AND bl.status <> 'R';

      SELECT tradeplace INTO l_tradePlace
      FROM sbsecurities
      WHERE symbol = l_symbol;
    EXCEPTION
      when OTHERS THEN
        pv_err_code := '-700125';
        RAISE l_exp;
    END;
    IF l_edStatus = 'A' OR l_edStatus = 'C' THEN
      pv_err_code := '-95023';
      RAISE l_exp;
    END IF;

    --Kiem tra gia sua phai thoa man ticksize.
    SELECT count(1) into l_count
    FROM SECURITIES_TICKSIZE
    WHERE CODEID = l_codeid  AND STATUS='Y'
    AND TOPRICE >= p_price AND FROMPRICE <= p_price;
    if l_count<=0 then
       --Chua dinh nghia TICKSIZE
      pv_err_code := '-100062';
      RAISE l_exp;
    else
      SELECT FROMPRICE, TICKSIZE into l_fromPrice, l_tickSize
      FROM SECURITIES_TICKSIZE
      WHERE CODEID = l_CodeID  AND STATUS = 'Y'
      AND TOPRICE >= p_price AND FROMPRICE <= p_price;
      If (p_price - l_fromPrice) Mod l_tickSize <> 0  THEN
        pv_err_code := '-100062';
        RAISE l_exp;
      End If;
    end if;

    IF l_execQtty >= p_qtty THEN
      pv_err_code := '-701111';
      RAISE l_exp;
    END IF;

    -- Kiem tra khoi luong phai dung lo GD
    IF l_tradePlace = '001' THEN
      If pr_check_tradelot(p_qtty, l_tradePlace) != 0 Then
        pv_err_code  := '-95009';
        RAISE l_exp;
      End If;
    END IF;

    IF p_qtty < l_org_quantity THEN
      -- Sua Giam KL
      IF l_tradeplace = '001' THEN
         SELECT sysvalue INTO l_marketStatus FROM ordersys WHERE sysname='CONTROLCODE';
         If l_marketStatus  IN ('A','P') THEN
           pv_err_code :=  '-95015';
           RAISE l_exp;
         END IF;
      END IF;
      IF l_tradeplace ='002' THEN
        SELECT nvl( sysvalue,'CLOSEALL') INTO l_marketStatus FROM ordersys_ha WHERE sysname = 'TRADINGID';
        IF  l_marketStatus IN ('CLOSE','CLOSE_BL')THEN
            pv_err_code :=  '-95015';
            Raise l_exp;
        END IF;
        IF l_marketStatus IN ('CLOSEALL') THEN
            pv_err_code :=  '-95015';
            Raise l_exp;
        END IF;
      END IF;
    END IF;

    IF p_price = l_org_price AND p_qtty = l_org_quantity THEN
      pv_err_code := '-95003';
      RAISE l_exp;
    END IF;
    IF (l_execType = 'NB' AND l_org_price > p_price) -- Sua Giam Gia Lenh Mua
        OR (l_execType = 'NS' AND l_org_price < p_price) THEN -- Sua Tang Gia Lenh Ban
      pv_err_code := '-700124';
      RAISE l_exp;
    END IF;

    l_remain_map := l_org_quantity - l_sentQtty - l_cancelQtty;
    IF l_remain_map <= 0 THEN
      pv_err_code := '-700123';
      RAISE l_exp;
    END IF;

    l_amend_blOrderId := fn_get_blOrderId;
    l_cancel_execType := 'C' || substr(l_execType, 2);
    INSERT INTO bl_odmast (autoid, blorderid, blacctno, afacctno, custodycd, traderid, forefid, status,
                           blodtype, exectype, pricetype, timetype, codeid, symbol, quantity, price, execqtty,
                           execamt, remainqtty, cancelqtty, amendqtty, refblorderid, feedbackmsg, activatedt, createddt,
                           txdate, effdate, expdate, via, deltd, username, direct, tlid, refforefid, orgquantity, orgprice,
                           edstatus, edexectype, rootorderid,
                           fixside, fixordtype, fixtimeinforc, fixsendercompid, fixcompid, beginstring,
                           hftreforderid, origexecqtty, Origexecamt, pricechktype, app_status, targetstrategy)
    SELECT seq_bl_odmast.nextval, l_amend_blOrderId, bl.blacctno, bl.afacctno, bl.custodycd, bl.traderid, '', 'N',
           bl.blodtype, bl.exectype, bl.pricetype, bl.timetype, bl.codeid, bl.symbol, p_qtty, p_price, bl.execqtty,
           bl.execamt, bl.remainqtty, bl.cancelqtty, p_qtty, bl.blorderid, 'Amend Broker Order', l_strCurrDate, l_strCurrDate,
           l_currDate, l_currDate, l_currDate, 'L', 'N', 'BLP', 'Y', p_tlid, bl.forefid, bl.orgquantity, bl.orgprice,
           'A', 'A', bl.rootorderid,
           bl.fixside, bl.fixordtype, bl.fixtimeinforc, bl.fixsendercompid, bl.fixcompid, bl.beginstring,
           bl.hftorderid, bl.execqtty, bl.execamt, bl.pricechktype, bl.app_status, bl.targetstrategy
    FROM bl_odmast bl
    WHERE bl.blorderid = p_blOrderId;
    UPDATE bl_odmast SET edstatus = 'A',
                         amendQtty = p_qtty,
                         last_change = systimestamp
    WHERE blorderid = p_blOrderId;
    IF p_qtty >= l_org_quantity /*OR v_quantity - v_qtty <= l_remain_map*/ THEN
      -- 1. Sua Tang KL --> Success luon
      UPDATE bl_odmast set EDSTATUS = 'N',
                           price = p_price,
                           quantity = p_qtty,
                           REMAINQTTY = REMAINQTTY + p_qtty - l_org_quantity - l_cancelQtty,
                           LAST_CHANGE = SYSTIMESTAMP,
                           feedbackmsg = 'Order Replaced'
      WHERE blorderid = p_blOrderId;
      UPDATE bl_odmast set EDSTATUS ='S',
                           status = 'F',
                           pstatus = pstatus || status,
                           LAST_CHANGE = SYSTIMESTAMP,
                           feedbackmsg = 'Replace Order success'
      WHERE REFblorderid = p_blorderid and edstatus ='A' AND status <> 'R';
    ELSE
      --2. Sua Giam KL --> Huy Toan Bo Lenh Con
      pr_cancel_mapOrder_from_fix(p_blorderid, l_cancel_execType);
    END IF;

    DELETE bl_odmast_processing WHERE blorderid IN (p_blOrderId);
    plog.setEndSection (pkgctx, 'sp_replace_broker_order');
  EXCEPTION
    WHEN l_exp THEN
      DELETE bl_odmast_processing WHERE blorderid IN (p_blOrderId);
      pv_err_msg := fn_get_en_errmg(pv_err_code);
      plog.setEndSection (pkgctx, 'sp_replace_broker_order');
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      DELETE bl_odmast_processing WHERE blorderid IN (p_blOrderId);
      pv_err_code := '-1';
      pv_err_msg := 'System Error';
      plog.setEndSection (pkgctx, 'sp_replace_broker_order');
  END;

  PROCEDURE sp_done4day (pv_err_code    OUT VARCHAR2,
                         pv_err_msg     OUT VARCHAR2,
                         p_blOrderId        VARCHAR2,
                         p_tlid             VARCHAR2)
  IS
  l_exp           EXCEPTION;
  l_count         NUMBER;
  l_symbol        sbsecurities.symbol%TYPE;
  l_tradePlace    sbsecurities.tradeplace%TYPE;
  l_controlCode   ordersys.sysvalue%TYPE;
  BEGIN
    plog.setBeginSection(pkgctx, 'sp_done4day');
    pv_err_code := systemnums.C_SUCCESS;
    pv_err_msg := '';

    -- Ghi Processing tranh double check
    BEGIN
      INSERT INTO bl_odmast_processing(blorderid, eventname)
      VALUES (p_blOrderId, 'sp_done4day');
    EXCEPTION
      WHEN OTHERS THEN
        pv_err_code := '-700121';
        RAISE l_exp;
    END;
    BEGIN
      SELECT bl.symbol, sb.tradeplace INTO l_symbol, l_tradePlace
      FROM bl_odmast bl, sbsecurities sb
      WHERE bl.symbol = sb.symbol AND blOrderId = p_blOrderId
      AND bl.status NOT IN ('C', 'E', 'R', 'M')
      AND blOdType IN ('3','5');

    EXCEPTION
      WHEN OTHERS THEN
        pv_err_code := '-700125';
        RAISE l_exp;
    END;

    if to_char(sysdate, 'hh24:mi') <= '15:05' then
        pv_err_code := '-700126';
        RAISE l_exp;
    end if;
    IF instr(l_tradePlace,'001') > 0 OR instr(l_tradePlace,'ALL') > 0  THEN
      select trim(sysvalue) into l_controlCode from ordersys where sysname ='CONTROLCODE';
      if l_controlCode in ('P','O','A','I') THEN -- Trong phien GD cua HOSE
          pv_err_code := '-700127';
          RAISE l_exp;
      END if;
    END IF;

    IF instr(l_tradePlace, '002')>0 OR instr(l_tradePlace, '005')>0 OR instr(l_tradePlace, 'ALL')>0 THEN
      SELECT TRIM(sysvalue) INTO l_controlCode FROM ordersys_ha WHERE sysname ='CONTROLCODE';
      IF l_controlCode in ('1') THEN -- Trong phien GD cua HNX
          pv_err_code := '-700128';
          RAISE l_exp;
      END IF;
    END IF;

    UPDATE bl_maporder SET cancelqtty = cancelQtty + remainQtty,
                           remainQtty = 0,
                           last_change = systimestamp,
                           status = 'E',
                           pstatus = pstatus || status
    WHERE blOrderId = p_blOrderId
    AND remainQtty > 0 AND exectype IN ('NB', 'NS');

    UPDATE bl_odmast SET cancelQtty = cancelQtty + remainQtty,
                         remainQtty = 0,
                         status = 'E',
                         pstatus = pstatus || status,
                         feedbackmsg = 'Done for day',
                         last_change = systimestamp,
                         sentQtty = execQtty
    WHERE blOrderid = p_blOrderId
    AND status NOT IN ('C', 'E', 'R', 'M');

    DELETE bl_odmast_processing WHERE blorderid IN (p_blOrderId);


    plog.setEndSection(pkgctx, 'sp_done4day');
  EXCEPTION
    WHEN l_exp THEN
      DELETE bl_odmast_processing WHERE blorderid IN (p_blOrderId);
      pv_err_msg := fn_get_en_errmg(pv_err_code);
      plog.setEndSection (pkgctx, 'sp_done4day');
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      pv_err_code := '-1';
      pv_err_msg := 'System Error';
      plog.setEndSection (pkgctx, 'sp_done4day');
  END;

  PROCEDURE sp_save_execute_plan (pv_err_code    OUT VARCHAR2,
                                 pv_err_msg      OUT VARCHAR2,
                                 p_blOrderId     IN VARCHAR2,
                                 p_txtPlan       IN VARCHAR2, -- COL_NAME1;COL_NAME2;COL_NAME3|ROW_COL_VALUE1;ROW_COL_VALUE2;ROW_COL_VALUE3
                                 p_info          IN VARCHAR2,
                                 p_tlid          IN VARCHAR2)
  IS
  l_exp   EXCEPTION;
  l_arr_col_name    str_array;
  l_arr_values      str_array;
  l_arr_value       str_array;
  l_insert_sql      VARCHAR2(32000) := 'BEGIN null; ';
  l_field_name      VARCHAR2(1000);
  l_field_value     VARCHAR2(32000);
  l_value           VARCHAR2(1000);
  l_count           NUMBER(1);
  l_currDate        DATE;
  BEGIN
    plog.setBeginSection (pkgctx, 'sp_save_execute_plan');
    pv_err_code := systemnums.C_SUCCESS;
    pv_err_msg := '';
    -- Ghi Processing tranh double check
    BEGIN
      INSERT INTO bl_odmast_processing(blorderid, eventname)
      VALUES (p_blOrderId, 'sp_save_execute_plan');
    EXCEPTION
      WHEN OTHERS THEN
        pv_err_code := '-700121';
        RAISE l_exp;
    END;

    l_currDate := getcurrdate;
    SELECT COUNT(1) INTO l_count
    FROM bl_odmast b
    WHERE blOrderId = p_blOrderId
    AND l_currDate BETWEEN b.effdate AND b.expdate
    AND b.pricechktype = '4'
    AND nvl(b.hasplan, 'N') = 'N';
    IF NOT l_count = 1 THEN
      pv_err_code := '-700130';-- Ton Tai Plan Dat lenh
      UPDATE bl_odmast SET last_change = systimestamp WHERE blOrderId = p_blOrderId; --  Cap Nhat Last Change De Reload Tren F2
      RAISE l_exp;
    END IF;


    SELECT COUNT(1) INTO l_count
    FROM bl_autoOrderPlan
    WHERE blOrderId = p_blOrderId;

    IF l_count > 0 THEN
      pv_err_code := '-700130';
      UPDATE bl_odmast SET last_change = systimestamp WHERE blOrderId = p_blOrderId;--  Cap Nhat Last Change De Reload Tren F2
      RAISE l_exp;
    END IF;

    l_arr_values := Split (p_txtPlan, '|');
    l_arr_col_name := Split(l_arr_values(1), ';');

    l_field_name := '(autoid, blOrderId, planInfo, tlid';
    For col In l_arr_col_name.First .. l_arr_col_name.Last LOOP
      l_field_name := l_field_name || ', ' || l_arr_col_name(col);
    END LOOP;
    l_field_name := l_field_name || ')';

    FOR val IN 2 .. l_arr_values.last LOOP
      l_arr_value := Split(l_arr_values(val), ';');
      l_field_value := '(SEQ_bl_autoOrderPlan.nextval, ''' || p_blOrderId || ''', ''' || p_info || ''', ''' || p_tlid || '''';
      For col In l_arr_col_name.First .. l_arr_col_name.Last LOOP

        IF upper(l_arr_col_name(col)) = 'TIME_INTERVAL' THEN
          l_value := 'TO_DATE(''' || l_arr_value(col) || ''', ''DD/MM/RRRR HH24:MI:SS'')';
        ELSE
          l_value := l_arr_value(col);
        END IF;
        l_field_value := l_field_value || ', ' || l_value;

      END LOOP;
      l_field_value := l_field_value ||');';
      l_insert_sql := l_insert_sql || 'INSERT INTO bl_autoOrderPlan ' || l_field_name || ' VALUES ' || l_field_value ;
      --dbms_output.put_line('INSERT INTO bl_autoOrderPlan ' || l_field_name || ' VALUES ' || l_field_value );
      l_field_value := NULL;
    END LOOP;
    l_insert_sql := l_insert_sql || ' END;';
    BEGIN
      EXECUTE IMMEDIATE l_insert_sql;
    END;
    UPDATE bl_odmast SET hasPlan = 'Y' WHERE blOrderId = p_blOrderId;
    DELETE bl_odmast_processing WHERE blorderid IN (p_blOrderId);

    plog.setEndSection (pkgctx, 'sp_save_execute_plan');
  EXCEPTION
    WHEN l_exp THEN
      DELETE bl_odmast_processing WHERE blorderid IN (p_blOrderId);
      ROLLBACK;
      pv_err_msg := fn_get_en_errmg(pv_err_code);
      plog.setEndSection (pkgctx, 'sp_save_execute_plan');
    WHEN OTHERS THEN
      DELETE bl_odmast_processing WHERE blorderid IN (p_blOrderId);
      ROLLBACK;
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'sp_save_execute_plan');
      pv_err_code := errnums.C_SYSTEM_ERROR;
      pv_err_msg := 'SYSTEM ERROR';
  END;
  PROCEDURE pr_get_execute_auto_order (pv_order_list OUT Sys_Refcursor)
  IS
  l_hnx_session     VARCHAR2(100);
  l_hose_session    VARCHAR2(100);
  l_upcom_session    VARCHAR2(100);
  l_hnx_tradingId   VARCHAR2(100);
  l_hnx_controlCode    VARCHAR2(100);
  l_upcom_tradingId    VARCHAR2(100);
  l_upcom_controlCode  VARCHAR2(100);
  l_hose_controlCode   VARCHAR2(100);
  l_sysdate            DATE := SYSDATE;

  c_14h30              VARCHAR2(10) := '143000';
  c_14h55              VARCHAR2(10) := '145500';
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_get_execute_auto_order');
    SELECT sysvalue INTO l_hose_controlCode
    FROM ordersys
    WHERE sysname = 'CONTROLCODE';
    SELECT MAX(DECODE(sysname, 'TRADINGID', sysvalue, '')),
           MAX(DECODE(sysname, 'CONTROLCODE', sysvalue, ''))
    INTO l_hnx_tradingId, l_hnx_controlCode
    FROM ordersys_ha
    WHERE sysname IN ('TRADINGID', 'CONTROLCODE');
    SELECT MAX(DECODE(sysname, 'TRADINGID', sysvalue, '')),
           MAX(DECODE(sysname, 'CONTROLCODE', sysvalue, ''))
    INTO l_upcom_tradingId, l_upcom_controlCode
    FROM ordersys_upcom
    WHERE sysname IN ('TRADINGID', 'CONTROLCODE');

    l_hose_session := CASE l_hose_controlCode WHEN 'P' THEN 'ATO'
                                              WHEN 'O' THEN 'LO'
                                              WHEN 'A' THEN 'ATC'
                                              ELSE 'CLOSE'
                      END;
    l_hnx_session := CASE WHEN l_hnx_controlCode != '1' THEN 'CLOSE'
                          ELSE CASE l_hnx_tradingId WHEN 'CONT' THEN 'LO'
                                                    WHEN 'CLOSE' THEN 'ATC'
                                                    WHEN 'CLOSE_BL' THEN 'ATC'
                                                    ELSE 'CLOSE'
                               END
                     END;
    l_upcom_session := CASE WHEN l_upcom_controlCode != '1' THEN 'CLOSE'
                            ELSE CASE l_upcom_tradingId WHEN 'CONTUP' THEN 'LO'
                                                          ELSE 'CLOSE'
                                 END
                       END;

    OPEN pv_order_list
    FOR
      SELECT autoid,
             blOrderId,
             time_interval,
             quantity,
             CASE WHEN tradeplace = '001' AND quantity < 10 THEN 'LO'
                  WHEN tradeplace IN ('002', '005') AND quantity < 100 THEN 'LO'
                  ELSE PRICETYPE END PRICETYPE,
             PRICE
      FROM (
        SELECT au.autoid,
               au.blorderid,
               TO_CHAR(au.time_interval, 'dd-mm-rrrr hh24:mi:ss') time_interval,
               CASE WHEN au.volume > 0 THEN au.volume ELSE au.prediction_volume END quantity,
               CASE WHEN sb.tradeplace = '001' THEN decode(l_hose_session, 'ATO', 'ATO',
                                                                           'ATC', 'ATC',
                                                                           'LO','MP')
                    WHEN sb.tradeplace = '002' THEN decode(l_hnx_session, 'LO', 'MTL',
                                                                          'ATC', 'ATC')
               ELSE 'LO' END PRICETYPE,
               DECODE(od.exectype, 'NB', sec.ceilingprice, sec.floorprice) PRICE,
               sb.tradeplace
        FROM bl_odmast od, bl_autoOrderPlan au, sbsecurities sb, securities_info sec
        WHERE od.blorderid = au.blorderid
        AND od.pricechktype = '4' AND NVL(od.hasplan, 'N') = 'Y'
        AND od.codeid = sb.codeid AND od.codeid = sec.codeid
        AND au.status = 'P'
        AND (au.time_interval <= l_sysdate
             OR ((CASE WHEN sb.tradeplace = '001' AND l_hose_session = 'ATC' THEN 1
                       WHEN sb.tradeplace = '002' AND l_hnx_session = 'ATC' THEN 1
                       WHEN sb.tradeplace = '005' AND TO_CHAR(l_sysdate, 'hh24miss') >= c_14h55 THEN 1
                       ELSE 0 END) = 1
                  AND TO_CHAR(l_sysdate, 'hh24miss') >= c_14h30)
                  AND trunc(time_interval) = trunc(l_sysdate))
        AND (CASE WHEN sb.tradeplace = '001' AND l_hose_session != 'CLOSE' THEN 1
                  WHEN sb.tradeplace = '002' AND l_hnx_session != 'CLOSE' THEN 1
                  WHEN sb.tradeplace = '005' AND l_upcom_session != 'CLOSE' THEN 1
                  ELSE 0 END) = 1
      )
    ;
    plog.setEndSection(pkgctx, 'pr_get_execute_auto_order');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_get_execute_auto_order');
  END;
  PROCEDURE pr_update_execute_auto_order (p_autoid  IN  VARCHAR2,
                                         p_err_code IN VARCHAR2,
                                         p_err_msg  IN VARCHAR2)
  IS
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_update_execute_auto_order');
    UPDATE bl_autoOrderPlan SET status = DECODE (p_err_code, '0', 'A', 'R'),
                                err_code = p_err_code,
                                err_msg = p_err_msg,
                                active_time = systimestamp
    WHERE autoid = p_autoid
    AND status = 'P';
    plog.setEndSection(pkgctx, 'pr_update_execute_auto_order');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_update_execute_auto_order');
  END;

  PROCEDURE sp_update_map_order (p_mapId        VARCHAR2,
                                 p_blOrderId     VARCHAR2,
                                 p_hftOrderId    VARCHAR2,
                                 p_err_code      VARCHAR2, --hft error code
                                 p_err_msg       VARCHAR2)
  IS
  l_qtty    NUMBER;
  BEGIN
    plog.setBeginSection(pkgctx, 'sp_update_map_order');
    IF p_err_code = '0' THEN
      UPDATE bl_maporder SET hftorderid = p_hftOrderId,
                             status = 'F',
                             PSTATUS = PSTATUS || status,
                             last_change = systimestamp
      WHERE mapid = p_mapId AND blorderid = p_blOrderId;
      UPDATE bl_odmast SET last_change = systimestamp WHERE blOrderId = p_blOrderId;
    ELSE
      SELECT qtty INTO l_qtty FROM bl_maporder WHERE mapid = p_mapid;
      UPDATE bl_maporder SET status = 'R',
                             pstatus = pstatus || status,
                             ERRMSG = nvl(p_err_msg, p_err_code),
                             remainqtty = 0,
                             cancelqtty = l_qtty,
                             last_change = systimestamp
      WHERE mapid = p_mapId AND blorderid = p_blOrderId;
      UPDATE bl_odmast SET sentQtty = sentQtty - l_qtty,
                           last_change = systimestamp
      WHERE blOrderId = p_blOrderId;
    END IF;

    plog.setEndSection(pkgctx, 'sp_update_map_order');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'sp_update_map_order');
  END;

  PROCEDURE sp_update_map_replace_order (p_amend_mapid   VARCHAR2,
                                         p_blOrderId     VARCHAR2,
                                         p_hftOrderId    VARCHAR2,
                                         p_err_code      VARCHAR2,
                                         p_err_msg       VARCHAR2)
  IS
  l_org_mapid    bl_maporder.mapid%TYPE;
  l_org_hftOrderid bl_maporder.hftorderid%TYPE;
  l_remainQtty     bl_maporder.remainqtty%TYPE;

  l_remain_mapQtty     bl_odmast.cancelqtty%TYPE;
  l_ttMapCancelQtty    bl_odmast.cancelqtty%TYPE;
  l_count              NUMBER;
  l_amendQtty          NUMBER;
  l_orgQtty            NUMBER;
  BEGIN
    plog.setBeginSection(pkgctx, 'sp_update_map_replace_order');

    SELECT refmapid, hftRefOrderid, qtty INTO l_org_mapid, l_org_hftOrderid, l_amendQtty
    FROM bl_maporder
    WHERE mapid = p_amend_mapid;
    SELECT qtty INTO l_orgQtty FROM bl_maporder WHERE mapid = l_org_mapid;
    IF p_err_code = '0' THEN
      UPDATE bl_maporder SET hftorderid = p_hftOrderId,
                             status = 'F',
                             pstatus = pstatus || status,
                             last_change = systimestamp
      WHERE mapid = p_amend_mapid AND blorderid = p_blOrderId;
      UPDATE bl_odmast SET last_change = systimestamp WHERE blorderid = p_blOrderId;
    ELSE
      UPDATE bl_maporder SET status = 'R',
                             pstatus = pstatus || status,
                             last_change = systimestamp,
                             ERRMSG = nvl(p_err_msg, p_err_code)
      WHERE mapid = p_amend_mapid AND blorderid = p_blOrderId ;
      UPDATE bl_maporder SET status = 'F',
                             pstatus = pstatus || status,
                             last_change = systimestamp
      WHERE mapid = l_org_mapid AND blorderid = p_blOrderId;
      UPDATE bl_odmast SET last_change = systimestamp,
                           sentQtty = sentQtty - greatest(l_amendQtty - l_orgQtty, 0)
      WHERE blOrderId = p_blOrderId;
    END IF;
    plog.setEndSection(pkgctx, 'sp_update_map_replace_order');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'sp_update_map_replace_order');
  END;

  PROCEDURE sp_update_map_cancel_order (p_cancel_mapId VARCHAR2, -- mapId Of CancelOrder
                                       p_blOrderId     VARCHAR2, -- blOrderId Of OrigOrder
                                       p_hftOrderId    VARCHAR2, -- hftOrderId Return From HFT
                                       p_err_code      VARCHAR2, -- = 0 mean success orther error
                                       p_err_msg       VARCHAR2)
  IS
  l_org_mapid    bl_maporder.mapid%TYPE;
  l_org_hftOrderid bl_maporder.hftorderid%TYPE;
  l_remainQtty     bl_maporder.remainqtty%TYPE;

  l_remain_mapQtty     bl_odmast.cancelqtty%TYPE;
  l_ttMapCancelQtty    bl_odmast.cancelqtty%TYPE;
  l_count              NUMBER;
  BEGIN
    plog.setBeginSection(pkgctx, 'sp_update_map_cancel_order');
    SELECT refmapid, hftRefOrderid INTO l_org_mapid, l_org_hftOrderid
    FROM bl_maporder
    WHERE mapid = p_cancel_mapId;
    IF p_err_code = '0' THEN
      IF l_org_hftOrderid = p_hftOrderId THEN -- Cancel Success
        SELECT remainQtty INTO l_remainQtty
        FROM bl_maporder
        WHERE mapid = l_org_mapid;

        UPDATE bl_maporder SET hftorderid = p_hftOrderId,
                               status = 'D',
                               pstatus = pstatus || status,
                               last_change = systimestamp
        WHERE mapid = p_cancel_mapId AND blorderid = p_blOrderId;
        UPDATE bl_maporder SET remainqtty = 0,
                               cancelQtty = cancelQtty + remainQtty,
                               last_change = systimestamp,
                               pstatus = pstatus || status,
                               status = 'D'
        WHERE mapId = l_org_mapid;
        UPDATE bl_odmast SET last_change = systimestamp,
                             sentqtty = sentqtty - l_remainQtty,
                             cancelQtty = cancelQtty + CASE WHEN edstatus = 'C' THEN l_remainQtty ELSE 0 END,
                             remainQtty = remainQtty - CASE WHEN edstatus = 'C' THEN l_remainQtty ELSE 0 END,
                             status = CASE WHEN edstatus = 'C' AND quantity = cancelQtty + l_remainQtty + execqtty THEN 'C' ELSE status END,
                             pstatus = CASE WHEN edstatus = 'C' AND quantity = cancelQtty + l_remainQtty + execqtty THEN status ELSE '' END
        WHERE blOrderid = p_blOrderId;
      ELSE

        UPDATE bl_maporder SET hftorderid = p_hftOrderId,
                               status = 'F',
                               pstatus = pstatus || status,
                               last_change = systimestamp
        WHERE mapid = p_cancel_mapId AND blorderid = p_blOrderId;
        UPDATE bl_odmast SET last_change = systimestamp WHERE blorderid = p_blOrderId;
      END IF;

    ELSE
      UPDATE bl_maporder SET status = 'R',
                             pstatus = pstatus || status,
                             last_change = systimestamp,
                             ERRMSG = nvl(p_err_msg, p_err_code)
      WHERE mapid = p_cancel_mapId AND blorderid = p_blOrderId ;
      UPDATE bl_maporder SET status = 'F',
                             pstatus = pstatus || status,
                             last_change = systimestamp
      WHERE mapid = l_org_mapid AND blorderid = p_blOrderId AND status = 'C';
      SELECT COUNT(1) INTO l_count
      FROM bl_maporder
      WHERE execType IN ('CB','CS') AND status = 'P' AND blOrderId = p_blOrderId;
      IF l_count = 0 THEN
        UPDATE bl_odmast SET edstatus = CASE WHEN quantity = execQtty + cancelQtty THEN edstatus ELSE 'N' END
        WHERE blOrderId = p_blOrderId;
      END IF;
    END IF;

    plog.setEndSection(pkgctx, 'sp_update_map_cancel_order');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'sp_update_map_cancel_order');
  END;

  PROCEDURE pr_checkAmendOrder (p_type     OUT VARCHAR2,
                               p_message   OUT VARCHAR2,
                               p_blOrderId     VARCHAR2)
  IS
  l_remainQtty     bl_odmast.remainqtty%TYPE;
  l_execQtty       bl_odmast.execqtty%TYPE;
  l_cancelQtty     bl_odmast.cancelqtty%TYPE;
  l_amendQtty      bl_odmast.amendqtty%TYPE;
  l_quantity       bl_odmast.quantity%TYPE;
  l_newFoRefId     bl_odmast.forefid%TYPE;
  l_newPrice       bl_odmast.price%TYPE;
  l_newQuantity    bl_odmast.quantity%TYPE;
  l_edExecType     bl_odmast.edexectype%TYPE;
  l_countPending   NUMBER;
  l_sentQtty       bl_odmast.sentqtty%TYPE;
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_checkAmendOrder');
    p_type := 'PENDING';
    p_message := '';
    SELECT  NVL( MAX( Edexectype) ,'-'), max(price), max(forefid), MAX(quantity)
    INTO l_edExecType ,l_newPrice,l_newFoRefId, l_newQuantity
    FROM  bl_odmast
    WHERE refblorderid=p_blOrderid AND  edstatus = 'A' AND status <> 'R';

    SELECT remainQtty, execQtty, cancelQtty, amendQtty, quantity, sentQtty
    INTO l_remainQtty, l_execQtty, l_cancelQtty, l_amendQtty, l_quantity, l_sentQtty
    FROM bl_odmast bl
    WHERE bl.blorderid = p_blOrderId ;

    SELECT COUNT(1) INTO l_countPending
    FROM bl_maporder
    WHERE blOrderId = p_blOrderId AND exectype IN ('CB', 'CS') AND status IN ('P','F');

    IF l_quantity - l_cancelQtty - l_execQtty - l_remainQtty = 0 AND l_edExecType IN ('A') AND l_countPending = 0 THEN
      IF l_execQtty >= l_newQuantity OR l_sentQtty > l_amendQtty THEN
        -- KL Sua < KL Khop OR KL da chia > KL sua
        UPDATE bl_odmast SET
            edstatus = 'N', remainqtty = quantity - l_execQtty, CancelQtty=0,
            pstatus = pstatus|| status,
            status = 'F',
            last_change = SYSTIMESTAMP,
            amendQtty = 0
        WHERE blorderid = p_blOrderid;

        UPDATE bl_odmast SET
            status = 'R',
            edstatus = 'R',
            last_change = SYSTIMESTAMP,
            feedbackmsg = 'To late to Cancel/Replace'
        WHERE refblorderid = p_blOrderid AND  edstatus = 'A' AND status <> 'R' ;
        p_type := 'REJECT';
      ELSE
        -- Replace Success
        UPDATE bl_odmast set EDSTATUS = 'N',
                             price = l_newPrice,
                             quantity = l_newQuantity,
                             remainQtty = l_newQuantity - l_execQtty,
                             cancelQtty = 0,
                             orgforefid = forefid,
                             forefid = l_newFoRefId,
                             feedbackmsg = 'Order Replaced',
                             LAST_CHANGE = SYSTIMESTAMP
        WHERE blorderid = p_blOrderId;
        UPDATE bl_odmast SET
            edstatus = 'S',
            status = 'F',
            pstatus = pstatus || status,
            orgforefid = forefid,
            forefid='',
            last_change = SYSTIMESTAMP,
            FEEDBACKMSG = 'Replace Order success'
        WHERE refBlorderId = p_blOrderId AND status <> 'R';
        p_type := 'SUCCESS';
      END IF;
    END IF;

    plog.setEndSection(pkgctx, 'pr_checkAmendOrder');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setEndSection(pkgctx, 'pr_checkAmendOrder');
  END;


  PROCEDURE pr_GetBlOrder_ByUser (pv_refCursor   OUT pkg_report.ref_cursor,
                                 p_tlid         VARCHAR2,
                                 p_lastChange   VARCHAR2)
  IS
  l_currDate    DATE;
  BEGIN
    plog.setBeginSection(pkgctx, 'prGetBlOrder_ByUser');
    l_currDate := getcurrdate;
    OPEN pv_refCursor
    FOR
      SELECT CASE WHEN od.status = 'R' OR od.blodtype = '1' THEN 'N'
                  WHEN od.app_status = 'P' AND od.cancelqtty = 0  AND od.blodtype <> '1' THEN 'Y'
                  ELSE 'N'
             END ISCONFIRM,
             CASE WHEN od.status = 'R' OR od.blodtype = '1' THEN 'N'
                  WHEN od.app_status = 'P' AND od.cancelqtty = 0 AND od.blodtype <> '1' THEN 'Y'
             ELSE 'N' END ISREJECT,
             CASE WHEN od.remainqtty > 0 AND od.blodtype IN ('3','5') THEN 'Y' ELSE 'N' END ISCANCELFROMFIX,
             CASE WHEN od.remainqtty > 0 AND od.blodtype IN ('5') AND od.quantity - od.sentqtty - od.cancelqtty > 0 AND od.edstatus = 'N' AND od.app_status <> 'R' AND nvl(od.pricechktype, '1') <> '4' THEN 'Y' ELSE 'N' END ISAMENDBROKERORDER,
             CASE WHEN od.quantity - od.sentqtty - od.cancelqtty > 0 AND od.blodtype <> '1' AND od.app_status = 'A' AND nvl(od.pricechktype, '1') <> '4' THEN 'Y' ELSE 'N' END ISPLACEORDER,
             CASE WHEN od.sentqtty - od.execqtty - od.cancelqtty > 0 AND od.blodtype <> '1' AND od.app_status = 'A' AND nvl(od.pricechktype, '1') <> '4' THEN 'Y' ELSE 'N' END ISCANCELMAPORDER,
             CASE WHEN od.remainqtty > 0 AND od.status NOT IN ('C', 'E', 'R', 'M') THEN 'Y' ELSE 'N' END ISDONE4DAY,
             CASE WHEN od.quantity - od.execqtty - od.cancelqtty > 0 AND od.blodtype != '1' AND NVL(od.targetstrategy, '0') != '2' THEN 'Y' ELSE 'N' END ISCALLVWAP,
             CASE WHEN od.quantity - od.execqtty - od.cancelqtty > 0 AND od.blodtype != '1' AND NVL(od.targetstrategy, '0') = '2' THEN 'Y' ELSE 'N' END ISCALLTWAP,
             CASE WHEN NVL(od.hasplan, 'N') = 'N' THEN 'API' ELSE 'DB' END GETPLANFROM,
             CASE WHEN NVL(od.hasplan, 'N') = 'N' AND NVL(od.pricechktype, '1') = '4' THEN 'Y' ELSE 'N' END ISSUBMITPLAN,

             BLODTYPE, CASE WHEN od.blodtype IN ('1','5') THEN a3.cdcontent ELSE NVL(a7.cdcontent, a3.cdcontent) END BLODTYPE_DESC,
             od.PRICECHKTYPE,
             OD.EXECTYPE, A1.CDCONTENT EXECTYPE_DESC,
             a4.cdcontent    VIA,
             od.custodycd,
             OD.AFACCTNO,
             OD.BLACCTNO,
             od.blinstruction,
             od.remngcomment,
             od.pricetype,
             nvl(A5.CDCONTENT,'LMT') ORDTYPE,
             nvl( A6.CDCONTENT,'DAY') TIMEINFORCE,
             a2.cdcontent             STATUS,
             OD.SYMBOL,
             od.QUANTITY,
             od.price,
             DECODE(od.blodtype, '1', 0, od.quantity - od.cancelqtty - od.sentqtty)  REMAINMAPQTTY,
             od.sentqtty       MAPQTTY,
             od.execqtty,
             od.sentqtty - od.execqtty   PENDINGEXECQTTY,
             od.cancelqtty,
             --ROUND(((od.quantity - od.execqtty) * od.price + od.execamt)/od.quantity, 2) AVGPRICE, -- GIA TB DU KIEN
             CASE WHEN od.quantity - od.execqtty = 0 THEN ROUND(od.execamt / od.execqtty, 2)
                  ELSE ROUND((od.quantity * od.price - od.execamt) / (od.quantity - od.execqtty), 2) END AVGPRICE,
             CASE WHEN OD.EXECQTTY = 0 THEN 0 ELSE ROUND(OD.EXECAMT/OD.EXECQTTY) END      EXECPRICE,
             --0   intervalVwap,
             --0   allDayVwap,
             ROUND(od.execqtty / od.quantity * 100,  2)    EXECPERORDER,
             ROUND((CASE WHEN NVL(st.totaltrading, 0) = 0 THEN 0
                         ELSE od.execqtty / st.totaltrading * 100 END), 2)  EXECPERMARKET,
             od.Execamt,
             od.traderid,
             tlp.tlname CancelTlName,
             OD.Blorderid,
             od.forefid,
             TO_CHAR(OD.LAST_CHANGE,'RRRR/MM/DD hh24:mi:ss.ff9') ODTIMESTAMP,
             TO_CHAR(od.ordertime, 'hh24:mi:ss') ORDERTIME,
             CASE WHEN NVL(od.tlid,'6868') = '6868' THEN cf.fullname ELSE tlOrder.Tlname END OrderName
      FROM BL_ODMAST OD, ALLCODE A1, SECURITIES_INFO SEC, ALLCODE A2, ALLCODE A3, tlprofiles tlp, tlprofiles tlOrder,
          BL_REGISTER REG, ALLCODE A4, ALLCODE A5, ALLCODE A6, ALLCODE A7, bl_traderef blt, cfmast cf,
          (SELECT * FROM stockinfor st WHERE tradingdate = TO_CHAR(l_currDate, 'dd/mm/rrrr')) st
      WHERE OD.EXECTYPE = A1.CDVAL AND A1.CDNAME = 'EXECTYPE' AND A1.CDTYPE = 'OD'
      AND (CASE WHEN edstatus = 'A' THEN 'PA' -- DANG SUA
               WHEN edstatus = 'C' AND od.cancelqtty + od.execqtty < od.quantity THEN 'PC' -- DANG HUY
               WHEN edstatus = 'S' AND od.status = 'M' THEN 'SA' -- DA SUA
               WHEN edstatus IN ('C','W') AND (od.status = 'C' OR od.quantity = od.execqtty + od.cancelqtty) THEN 'CC' -- DA HUY
               WHEN od.STATUS = 'E' THEN 'EE' -- HET HIEU LUC
               WHEN od.app_status = 'P' AND od.blodtype <> '1' THEN 'PCF' -- CHO XAC NHAN
               WHEN od.app_status = 'A' and od.sentqtty = 0 AND od.blodtype <> '1' THEN 'PD' -- CHO XU LY
               WHEN (od.status = 'R' and od.blodtype='1') OR (od.app_status = 'R' AND od.blodtype <> '1') THEN 'RJ' -- TU CHOI
               WHEN od.edstatus = 'N' AND od.sentqtty > 0 AND od.blodtype <> '1' AND od.execqtty = 0 THEN 'ST' -- LENH MANUAL DA GUI
               WHEN od.edstatus = 'N' AND od.blodtype = '1'  AND od.execqtty = 0 THEN 'ST' -- LENH DIRECT DA GUI
               WHEN od.edstatus = 'N' AND od.execqtty < od.quantity AND od.execqtty > 0 THEN 'PF' -- KHOP 1 PHAN
               WHEN od.execqtty = od.quantity THEN 'AF' -- KHOP HET
            END) = A2.CDVAL AND A2.CDNAME = 'BLSTATUS' AND A2.CDTYPE = 'OD'
      AND OD.BLODTYPE = A3.CDVAL AND A3.CDNAME = 'BLODTYPE' AND A3.CDTYPE = 'OD'
      AND DECODE(od.blodtype, '5', 'F', 'L') = A4.CDVAL AND A4.CDNAME = 'VIA' AND A4.CDTYPE = 'OD'
      AND OD.fixORDTYPE = A5.CDVAL(+) AND A5.CDNAME(+) = 'ORDTYPE' AND A5.CDTYPE(+) = 'OD'
      AND OD.fixtimeinforc = A6.CDVAL(+) AND A6.CDNAME(+) = 'TIMEINFORCE' AND A6.CDTYPE(+) = 'OD'
      AND SEC.CODEID = OD.CODEID
      AND OD.AFACCTNO = REG.AFACCTNO (+) AND reg.status(+) = 'A'
      and OD.afacctno = blt.afacctno(+) and OD.traderid = blt.traderid(+) AND blt.status (+) = 'A'
      AND OD.Targetstrategy = A7.CDVAL(+) AND A7.CDNAME(+) = 'TARGETSTRATEGY' AND A7.CDTYPE(+) = 'OD'
      and od.ctlid = tlp.tlid (+) AND od.tlid = tlOrder.Tlid(+)
      AND not (NVL(od.edstatus,'A') = 'A' and od.status = 'N')
      AND od.custodycd = cf.custodycd AND exists (select gu.grpid from tlgrpusers gu
                                                  WHERE cf.careby = gu.grpid
                                                  and gu.tlid = p_tlid)
      AND OD.EFFDATE <= l_currDate AND OD.EXPDATE >= l_currDate
      AND (od.last_change > TO_TIMESTAMP(p_lastChange, 'RRRR/MM/DD hh24:mi:ss.ff9') OR p_lastChange IS NULL)
      AND od.exectype IN ('NB', 'NS') AND NVL(od.edexectype, 'N') = 'N'
      AND st.symbol(+) = od.symbol
      order by OD.AUTOID
    ;
    plog.setEndSection(pkgctx, 'prGetBlOrder_ByUser');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'prGetBlOrder_ByUser');
  END;
  PROCEDURE pr_GetBlMapOrder (pv_refCursor   OUT pkg_report.ref_cursor,
                             p_blOrderId              VARCHAR2)
  IS
  BEGIN
    plog.setBeginSection (pkgctx, 'prGetBlOrder_ByUser');
    OPEN pv_refCursor
    FOR
      SELECT bl.exectype, a1.cdcontent EXECTYPE_DESC,
             mo.pricetype, --bl.pricetype,
             mo.qtty,
             mo.remainqtty,
             mo.price,
             mo.execqtty,
             a2.cdcontent status,
             mo.execamt,
             CASE WHEN mo.execqtty = 0 THEN 0 ELSE round(mo.execamt / mo.execqtty, 2) END execPrice,
             mo.mapid ORDERID,
             bl.blorderid,
             mo.txtime,
             CASE WHEN mo.remainqtty = 0 THEN 'N' ELSE 'Y' END ISCANCEL,
             CASE WHEN mo.remainqtty = 0 OR sb.tradeplace = '001' OR bl.pricechktype = '4' THEN 'N' ELSE 'Y' END ISAMEND,
             bl.custodycd,
             bl.afacctno,
             bl.symbol
      FROM bl_odmast bl, bl_maporder mo, allcode a1, allcode a2, sbsecurities sb
      WHERE bl.blorderid = mo.blorderid
      AND a1.cdname = 'EXECTYPE' AND a1.cdtype = 'OD' AND a1.cdval = bl.exectype
      AND a2.cdname = 'BLMAPSTATUS' AND a2.cdtype = 'OD' AND a2.cdval = mo.status
      AND bl.blorderid = p_blOrderId
      AND mo.exectype IN ('NB','NS')
      AND bl.symbol = sb.symbol
      ORDER BY mo.mapid
    ;
    plog.setEndSection (pkgctx, 'prGetBlOrder_ByUser');
  EXCEPTION
    when OTHERS THEN
      plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'prGetBlOrder_ByUser');
  END;

  PROCEDURE pr_GetDBPlan (pv_refCursor OUT  pkg_report.ref_cursor,
                         p_blOrderId   VARCHAR2)
  IS
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_GetDBPlan');
    plog.error(pkgctx, ' CSPKS_FIX_ENGINE_API.pr_GetDBPlan BEGIN ');
    OPEN pv_refCursor
    FOR
      SELECT pl.planinfo,
             pl.time_interval,
             pl.prediction_volume,
             pl.lowest_volume,
             pl.highest_volume,
             pl.volume
      FROM bl_odmast bl, bl_autoOrderPlan pl
      WHERE bl.blorderid = pl.blorderid
      AND bl.blorderid = p_blOrderId
    ;
    plog.setEndSection(pkgctx, 'pr_GetDBPlan');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || ' AT ' || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_GetDBPlan');
  END;

  BEGIN
  SELECT *
  INTO logrow
  FROM tlogdebug
  WHERE ROWNUM <= 1;
   pkgctx    :=
     plog.init ('CSPKS_FIX_ENGINE_API',
                plevel => logrow.loglevel,
                plogtable => (logrow.log4table = 'Y'),
                palert => (logrow.log4alert = 'Y'),
                ptrace => (logrow.log4trace = 'Y')
     );
end CSPKS_FIX_ENGINE_API;
/
