-- Start of DDL Script for Package Body HOSTMSTRADE.NEWFO_API
-- Generated 11/04/2017 11:14:54 AM from HOSTMSTRADE@FLEX_111

CREATE OR REPLACE 
PACKAGE newfo_api
  IS

   PROCEDURE pr_OrderInsert(
    p_orderId VARCHAR2,
      p_acctno  VARCHAR2,
      p_symbol  VARCHAR2,
      p_actype  VARCHAR2,
      p_txnum   VARCHAR2,
      p_txdate  DATE,
      p_txtime  VARCHAR2,
      p_exectype VARCHAR2,
      p_matchtype VARCHAR,
      p_via     VARCHAR,
      p_clearday NUMBER,
      p_status  VARCHAR2,
      p_pricetype varchar2,
      p_quoteprice number,
      p_orderqtty number,
      p_userid varchar2,
      p_err_code  OUT varchar2,
      p_err_message  OUT VARCHAR2,
      P_CONTRAFIRM varchar2,
      P_TRADERID varchar2,
      P_CLIENTID VARCHAR2,
      P_ISDISPOSAL VARCHAR2 default Null
   );

    PROCEDURE pr_CancelOrder(
        p_OrderIdCancel varchar2,
        p_OrderId varchar2,
        p_acctno varchar2,
        p_CancelQTTY NUMBER,
        p_via varchar2,
        p_userid varchar2,
        p_txdate Date,
        p_err_code  OUT varchar2,
        p_err_message  OUT varchar2
        );
    PROCEDURE pr_CancelOrderPT(
        p_FOOrderIdCancel varchar2,
        p_err_code  OUT varchar2,
        p_err_message  OUT varchar2
        );
    PROCEDURE pr_EditOrder
   (
        p_OrderIdEdit varchar2,
        p_OrderId varchar2,
        p_acctno varchar2,
        p_EditQTTY NUMBER,
        p_EditPrice NUMBER,
        p_via varchar2,
        p_userid varchar2,
        p_txdate Date,
        p_err_code  OUT varchar2,
        p_err_message  OUT varchar2
    );

    PROCEDURE pr_fo2odsyn (p_orderid varchar2, p_fo_orderid varchar2, p_bo_orderid varchar2, p_err_code  OUT varchar2, p_timetype varchar2 default 'T' );

    FUNCTION fn_txAppUpdate8876(p_txmsg in tx.msg_rectype,p_err_code in out varchar2)
    RETURN NUMBER;

    FUNCTION fn_txAppAutoUpdate8877(p_txmsg in tx.msg_rectype,p_err_code in out varchar2)
    RETURN  NUMBER;

    FUNCTION fn_txAppUpdate8884(p_txmsg in tx.msg_rectype, p_bo_orderid varchar2,p_err_code in out varchar2)
    RETURN NUMBER;

    FUNCTION fn_txAppUpdate8885(p_txmsg in tx.msg_rectype,p_err_code in out varchar2)
    RETURN NUMBER;

    FUNCTION fn_txAppUpdate8882(p_txmsg in tx.msg_rectype,p_err_code in out varchar2)
    RETURN NUMBER;

    FUNCTION fn_txAppAutoUpdate8882(p_txmsg in tx.msg_rectype,p_err_code in out varchar2)
    RETURN  NUMBER;

    FUNCTION fn_txAppUpdate8883(p_txmsg in tx.msg_rectype,p_err_code in out varchar2)
    RETURN NUMBER;

    FUNCTION fn_txAftAppUpdate8884EX(p_txmsg in tx.msg_rectype, p_bo_orderid varchar2,p_err_code in out varchar2)
    RETURN NUMBER;

    FUNCTION fn_txAppUpdate8887(p_txmsg in tx.msg_rectype,p_err_code in out varchar2)
    RETURN NUMBER;

    FUNCTION fn_txAppAutoUpdate8887EX(p_txmsg in tx.msg_rectype,p_err_code in out varchar2)
    RETURN  NUMBER;

    FUNCTION fn_GenFOMsg(p_txmsg in out tx.msg_rectype,p_err_code in out varchar2,p_err_param out varchar2)
    RETURN  NUMBER;
    PROCEDURE matching_normal_order
    (
        order_number       IN   VARCHAR2,
        deal_volume        IN   NUMBER,
        deal_price         IN   NUMBER,
        confirm_number     IN   VARCHAR2,
        p_pitqtty          IN   NUMBER,
        p_err_code  OUT varchar2,
        p_err_message  OUT varchar2
    );

   PROCEDURE confirm_cancel_normal_order (
       pv_orderid   IN   VARCHAR2,
       pv_qtty      IN   NUMBER,
       p_err_code  OUT varchar2,
       p_err_message  OUT varchar2
    );

   PROCEDURE CONFIRM_REPLACE_NORMAL_ORDER (
       pv_ordernumber   IN   VARCHAR2,
       pv_qtty       IN   NUMBER,
       pv_price      IN   NUMBER,
       pv_LeavesQty IN   NUMBER,
       p_err_code  OUT varchar2,
       p_err_message  OUT varchar2
    );

    PROCEDURE confirm_send_order (
        pv_orderid   IN   VARCHAR2,
        p_err_code  OUT varchar2,
        p_err_message  OUT varchar2
    );
   PROCEDURE pr_txlog8876(p_txmsg in tx.msg_rectype,p_err_code out varchar2);
   PROCEDURE pr_txlog8877(p_txmsg in tx.msg_rectype,p_err_code out varchar2);
   PROCEDURE pr_txlog8882(p_txmsg in tx.msg_rectype,p_err_code out varchar2);
   PROCEDURE pr_txlog8883(p_txmsg in tx.msg_rectype,p_err_code out varchar2);
   PROCEDURE pr_txlog8884(p_txmsg in tx.msg_rectype,p_err_code out varchar2);
   PROCEDURE pr_txlog8885(p_txmsg in tx.msg_rectype,p_err_code out varchar2);
   PROCEDURE pr_HoldBank
    ( pv_reqnumber VARCHAR2,
      pv_account  VARCHAR2,
      pv_amt  number,
      p_ERR_CODE  IN OUT VARCHAR2,
      p_ERR_MESSAGE  IN OUT VARCHAR2
    );
  PROCEDURE confirm_release_order (
   pv_orderid   IN   VARCHAR2,
   pv_qtty      IN   NUMBER,
   p_err_code  OUT varchar2,
   p_err_message  OUT varchar2
  );
  PROCEDURE confirm_send_order_2LO (
   pv_orderid   IN   VARCHAR2,
   pv_qtty      IN   NUMBER,
   pv_price     IN   NUMBER,
   p_err_code  OUT varchar2,
   p_err_message  OUT varchar2
);
PROCEDURE prc_Process_exec;

PROCEDURE pr_Sync_ROOM_TO_FO (
   p_err_code  OUT varchar2,
   p_acctno  IN varchar2
);
PROCEDURE Pr_RejectOD_exec (
   pv_orderid   IN   VARCHAR2,
   pv_msgtype   IN   VARCHAR2,
   p_err_code   OUT varchar2,
   p_err_message  OUT varchar2
);

PROCEDURE Pr_Reject_order (
   pv_orderid   IN   VARCHAR2,
   pv_msgtype   IN   VARCHAR2,
   p_err_code  OUT varchar2,
   p_err_message  OUT varchar2
);
PROCEDURE confirm_send_order_PT (
   pv_orderid   IN   VARCHAR2,
   pv_crossid      IN   VARCHAR2,
   p_err_code  OUT varchar2,
   p_err_message  OUT varchar2
);
PROCEDURE confirm_send_orderPT_exec (
   pv_orderid   IN   VARCHAR2,
   pv_crossid   IN   VARCHAR2,
   p_err_code   OUT varchar2,
   p_err_message  OUT varchar2
);
PROCEDURE pr_CancelOrder_Exec(
        p_OrderIdCancel varchar2,
        p_OrderId varchar2,
        p_acctno varchar2,
        p_CancelQTTY NUMBER,
        p_via varchar2,
        p_userid varchar2,
        p_txdate Date,
        p_err_code  OUT varchar2,
        p_err_message  OUT varchar2
        );
PROCEDURE pr_EditOrder_Exec
   (
        p_OrderIdEdit varchar2,
        p_OrderId varchar2,
        p_acctno varchar2,
        p_EditQTTY NUMBER,
        p_EditPrice NUMBER,
        p_via varchar2,
        p_userid varchar2,
        p_txdate Date,
        p_err_code  OUT varchar2,
        p_err_message  OUT varchar2
    );
PROCEDURE pr_OrderInsert_Exec
    ( p_orderId VARCHAR2,
      p_acctno  VARCHAR2,
      p_symbol  VARCHAR2,
      p_actype  VARCHAR2,
      p_txnum   VARCHAR2,
      p_txdate  DATE,
      p_txtime  VARCHAR2,
      p_exectype VARCHAR2,
      p_matchtype VARCHAR,
      p_via     VARCHAR,
      p_clearday NUMBER,
      p_status  VARCHAR2,
      p_pricetype varchar2,
      p_quoteprice number,
      p_orderqtty number,
      p_userid varchar2,
      p_err_code  OUT varchar2,
      p_err_message  OUT VARCHAR2,
      P_CONTRAFIRM varchar2,
      P_TRADERID varchar2,
      P_CLIENTID VARCHAR2,
      P_ISDISPOSAL VARCHAR2 default NULL
     );
PROCEDURE prc_Process_exec_ex;
END; -- Package spec
/


CREATE OR REPLACE 
PACKAGE BODY newfo_api
IS
  pkgctx plog.log_ctx;

    logrow tlogdebug%ROWTYPE;

   PROCEDURE pr_OrderInsert
    ( p_orderId VARCHAR2,
      p_acctno  VARCHAR2,
      p_symbol  VARCHAR2,
      p_actype  VARCHAR2,
      p_txnum   VARCHAR2,
      p_txdate  DATE,
      p_txtime  VARCHAR2,
      p_exectype VARCHAR2,
      p_matchtype VARCHAR,
      p_via     VARCHAR,
      p_clearday NUMBER,
      p_status  VARCHAR2,
      p_pricetype varchar2,
      p_quoteprice number,
      p_orderqtty number,
      p_userid varchar2,
      p_err_code  OUT varchar2,
      p_err_message  OUT VARCHAR2,
      P_CONTRAFIRM varchar2,
      P_TRADERID varchar2,
      P_CLIENTID VARCHAR2,
      P_ISDISPOSAL VARCHAR2 default NULL
     )
   IS
      v_strBUSDATE varchar2(20);
      v_strTIMETYPE VARCHAR2(1);
      v_strNORK VARCHAR2(1);
      v_strCLEARCD VARCHAR2(1);
      v_codeid varchar2(20);
      v_userid varchar2(20);
      v_strUSERNAME  varchar2(200);
      v_strORDERID varchar2(50);
      v_strTLID varchar2(300):='0000';
      v_strlog varchar2(4000);
      v_clearday number(20);
   BEGIN
      plog.setbeginsection (pkgctx, 'pr_OrderInsert');
      v_strlog:=' newfo_api.pr_OrderInsert(p_orderId =>'''||p_orderId
                                        ||''',p_acctno =>'''||p_acctno
                                        ||''',p_symbol =>'''||p_symbol
                                        ||''', p_actype =>'''||p_actype
                                        ||''', p_txnum =>'''||p_txnum
                                        ||''', p_txdate =>'''||p_txdate
                                        ||''', p_txtime =>'''||p_txtime
                                        ||''', p_exectype =>'''||p_exectype
                                        ||''', p_matchtype =>'''||p_matchtype
                                        ||''', p_via =>'''||p_via
                                        ||''', p_clearday =>'''||p_clearday
                                        ||''', p_status =>'''||p_status
                                        ||''', p_pricetype =>'''||p_pricetype
                                        ||''', p_quoteprice =>'''||p_quoteprice
                                        ||''', p_orderqtty =>'''||p_orderqtty
                                        ||''', p_userid =>'''||p_userid
                                        ||''', p_err_code =>p_err_code
                                          , p_err_message =>p_err_message
                                          , P_CONTRAFIRM =>'''||P_CONTRAFIRM
                                        ||''', P_TRADERID =>'''||P_TRADERID
                                        ||''', P_CLIENTID =>'''||P_CLIENTID
                                        ||''', P_ISDISPOSAL =>'''||P_ISDISPOSAL ||''');';


      INSERT INTO t_fo_logcallws(id , tltxcd , acctno, strmsg , logtime)
                                       VALUES(seq_fo_logcallws.NEXTVAL, 'pr_OrderInsert', p_acctno, v_strlog, SYSTIMESTAMP);
      COMMIT;
      IF p_clearday NOT IN ('1','0') THEN
        v_clearday:= 2;
      ELSE
        v_clearday:= p_clearday;
      END IF;
      INSERT INTO t_fo_reiceiveorder (id,
                                msgtype,
                                orderid,
                                orderidedit,
                                orderidcancel,
                                acctno,
                                symbol,
                                actype,
                                txnum,
                                txdate,
                                txtime,
                                exectype,
                                matchtype,
                                via,
                                clearday,
                                status,
                                pricetype,
                                quoteprice,
                                orderqtty,
                                cancelqtty,
                                editqtty,
                                editprice,
                                userid,
                                contrafirm,
                                traderid,
                                clientid,
                                isdisposal,
                                Receivetime,
                                Process)
            VALUES (SEQ_FO_EXEC.NEXTVAL,
                'NEWOD',
                p_orderid,
                '',
                '',
                p_acctno,
                p_symbol,
                p_actype,
                p_txnum,
                p_txdate,
                p_txtime,
                p_exectype,
                p_matchtype,
                p_via,
                v_clearday,
                p_status,
                p_pricetype,
                p_quoteprice,
                p_orderqtty,
                '' ,
                '' ,
                '',
                p_userid,
                p_contrafirm,
                p_traderid,
                p_clientid,
                p_isdisposal,
                systimestamp,
                'N');
     COMMIT;
     p_err_code := 0;
     plog.setendsection (pkgctx, 'pr_OrderInsert');
   EXCEPTION
      when others then
        rollback;
        p_err_code := -100800; --File du lieu dau vao khong hop le

        p_err_message:= 'System error. Invalid file format';
        plog.ERROR(pkgctx,'Loi '||sqlerrm);
        plog.setendsection (pkgctx, 'pr_OrderInsert');
      RETURN;
   END pr_OrderInsert;

   PROCEDURE pr_OrderInsert_Exec
    ( p_orderId VARCHAR2,
      p_acctno  VARCHAR2,
      p_symbol  VARCHAR2,
      p_actype  VARCHAR2,
      p_txnum   VARCHAR2,
      p_txdate  DATE,
      p_txtime  VARCHAR2,
      p_exectype VARCHAR2,
      p_matchtype VARCHAR,
      p_via     VARCHAR,
      p_clearday NUMBER,
      p_status  VARCHAR2,
      p_pricetype varchar2,
      p_quoteprice number,
      p_orderqtty number,
      p_userid varchar2,
      p_err_code  OUT varchar2,
      p_err_message  OUT VARCHAR2,
      P_CONTRAFIRM varchar2,
      P_TRADERID varchar2,
      P_CLIENTID VARCHAR2,
      P_ISDISPOSAL VARCHAR2 default NULL
     )
   IS
      v_strBUSDATE varchar2(20);
      v_strTIMETYPE VARCHAR2(1);
      v_strNORK VARCHAR2(1);
      v_strCLEARCD VARCHAR2(1);
      v_codeid varchar2(20);
      v_userid varchar2(20);
      v_strUSERNAME  varchar2(200);
      v_strORDERID varchar2(50);
      v_strTLID varchar2(300):='0000';
      v_strlog varchar2(4000);
   BEGIN
      plog.setbeginsection (pkgctx, 'pr_OrderInsert_Exec');
      v_strlog:=' newfo_api.pr_OrderInsert_Exec(p_orderId =>'''||p_orderId
                                        ||''',p_acctno =>'''||p_acctno
                                        ||''',p_symbol =>'''||p_symbol
                                        ||''', p_actype =>'''||p_actype
                                        ||''', p_txnum =>'''||p_txnum
                                        ||''', p_txdate =>'''||p_txdate
                                        ||''', p_txtime =>'''||p_txtime
                                        ||''', p_exectype =>'''||p_exectype
                                        ||''', p_matchtype =>'''||p_matchtype
                                        ||''', p_via =>'''||p_via
                                        ||''', p_clearday =>'''||p_clearday
                                        ||''', p_status =>'''||p_status
                                        ||''', p_pricetype =>'''||p_pricetype
                                        ||''', p_quoteprice =>'''||p_quoteprice
                                        ||''', p_orderqtty =>'''||p_orderqtty
                                        ||''', p_userid =>'''||p_userid
                                        ||''', p_err_code =>p_err_code
                                          , p_err_message =>p_err_message
                                          , P_CONTRAFIRM =>'''||P_CONTRAFIRM
                                        ||''', P_TRADERID =>'''||P_TRADERID
                                        ||''', P_CLIENTID =>'''||P_CLIENTID
                                        ||''', P_ISDISPOSAL =>'''||P_ISDISPOSAL ||''');';


      INSERT INTO t_fo_logcallws(id , tltxcd , acctno, strmsg , logtime)
                                       VALUES(seq_fo_logcallws.NEXTVAL, 'pr_OrderInsert_Exec', p_acctno, v_strlog, SYSTIMESTAMP);
      COMMIT;
       -- RETURN;
      p_err_code :='0';

      Select CodeId INTO v_codeid From sbsecurities where symbol = p_symbol;

      v_strTIMETYPE := 'T';
      v_strNORK := 'N';
      v_strCLEARCD := 'B';
      --plog.debug (pkgctx, ' pr_OrderInsert p_acctno '||p_acctno);



      v_strBUSDATE:=cspks_system.fn_get_sysvar('SYSTEM','CURRDATE');



      --plog.debug (pkgctx, ' pr_OrderInsert v_strORDERID '||v_strORDERID);
      select v_strBUSDATE || lpad(seq_fomast.nextval,10,'0') into v_strORDERID from dual;

      v_strTLID:='';
      --plog.debug (pkgctx, ' pr_OrderInsert v_strTLID '||v_strTLID);
     IF length(p_userid) > 4 THEN
       v_strUSERNAME:=p_userid;
       v_strTLID := systemnums.C_ONLINE_USERID;
     ELSE
       v_strTLID:=p_userid;
     END IF;
     /*
     IF p_via IN ('O') THEN
        v_strTLID := systemnums.C_ONLINE_USERID;
     ELSE
        v_strTLID:=p_userid;
     END IF;*/



     --plog.debug (pkgctx, ' pr_OrderInsert Begin FOMAST ');
     INSERT INTO FOMAST (ACCTNO, ORGACCTNO, ACTYPE, AFACCTNO, STATUS, EXECTYPE, PRICETYPE, TIMETYPE, MATCHTYPE, NORK, CLEARCD, CODEID, SYMBOL,
            CONFIRMEDVIA, BOOK, FEEDBACKMSG, ACTIVATEDT, CREATEDDT, CLEARDAY, QUANTITY, PRICE, QUOTEPRICE, EXECQTTY, EXECAMT, REMAINQTTY,
            VIA, DIRECT, SPLOPT, SPLVAL, EFFDATE, EXPDATE, USERNAME, DFACCTNO,SSAFACCTNO, TLID,QUOTEQTTY,
            LIMITPRICE, forefid,CONTRAFIRM,TRADERID,  CLIENTID, ISDISPOSAL)
      VALUES (v_strORDERID,p_orderId,'1000',p_acctno,p_status, p_exectype,p_pricetype,
            v_strTIMETYPE,p_matchtype, v_strNORK,v_strCLEARCD,v_codeid,p_symbol,
            'N', 'A','',TO_CHAR(p_txdate,'DD/MM/RRRR ') || p_txtime,TO_CHAR(p_txdate,'DD/MM/RRRR ') || p_txtime,
            p_clearday ,p_orderqtty ,p_quoteprice ,p_quoteprice ,0 ,0 ,p_orderqtty ,
            p_via,'Y','N',0 , TO_DATE(p_txdate,'DD/MM/RRRR'),TO_DATE(p_txdate,'DD/MM/RRRR'),
            v_strUSERNAME,'','', v_strTLID, 0, 0, p_orderId,P_CONTRAFIRM,P_TRADERID,P_CLIENTID,P_ISDISPOSAL);
     COMMIT;

     plog.ERROR(pkgctx,'pr_OrderInsert_Exec: Err_Code: '||p_err_code);

     --plog.debug (pkgctx, ' pr_OrderInsert Begin FOMAST p_orderId'||p_orderId);
       --TXPKS_AUTO.pr_fo2odsyn(v_strORDERID,p_err_code,v_strTIMETYPE);
     --p_err_code := 0;
     pr_fo2odsyn(v_strORDERID, p_orderId, '',p_err_code,v_strTIMETYPE);

     plog.ERROR(pkgctx,'pr_OrderInsert_Exec: Err_Code: '||p_err_code);

     IF p_err_code ='0' THEN
         p_err_message:= 'Sucessfull!';
     ELSE
         p_err_message:= cspks_system.fn_get_errmsg(p_err_code);
     END IF;
     plog.setendsection (pkgctx, 'pr_OrderInsert_Exec');
   EXCEPTION
      when others then
        rollback;
        p_err_code := -100800; --File du lieu dau vao khong hop le

        p_err_message:= 'System error. Invalid file format';
        plog.ERROR(pkgctx,'Loi '||sqlerrm);
        plog.setendsection (pkgctx, 'pr_OrderInsert_Exec');
      RETURN;
   END;

   PROCEDURE pr_CancelOrderPT(
        p_FOOrderIdCancel varchar2,
        p_err_code  OUT varchar2,
        p_err_message  OUT varchar2
        )
   IS
        v_strOrderIdBO varchar2(20);
        v_strEXECTYPE varchar2(2);
        v_strlog   varchar2(4000);
    BEGIN
        v_strlog:= ' pr_CancelOrderPT p_FOOrderIdCancel '||p_FOOrderIdCancel;

        INSERT INTO t_fo_logcallws(id , tltxcd , strmsg , logtime)
                                           VALUES(seq_fo_logcallws.NEXTVAL, 'pr_CancelOrderPT', v_strlog, SYSTIMESTAMP);
        COMMIT;

        SELECT BOORDERID INTO V_STRORDERIDBO FROM NEWFO_ORDERMAP WHERE FOORDERID = P_FOORDERIDCANCEL AND TXDATE = getcurrdate;

        SELECT EXECTYPE INTO V_STREXECTYPE FROM ODMAST WHERE ORDERID = V_STRORDERIDBO;

        IF V_STREXECTYPE = 'NB' THEN

            INSERT INTO CANCELORDERPTACK (SORR,TIMESTAMP, MESSAGETYPE, FIRM, CONTRAFIRM, TRADEID,
                        SIDE, SECURITYSYMBOL, CONFIRMNUMBER, STATUS, ISCONFIRM,ORDERNUMBER, TLID, TXTIME, TRADING_DATE)
                        SELECT 'R',TO_CHAR(SYSDATE,'HH24MISS'),'U1',SYS1.SYSVALUE FIRM, OD.CONTRAFIRM,SYS2.SYSVALUE,
                        NULL,IOD.SYMBOL,IOD.CONFIRM_NO,'N','N',OD.ORDERID, OD.TLID,TO_CHAR(SYSDATE,'HH24MISS'),IOD.TXDATE
                        FROM IOD,ODMAST OD,ORDERSYS SYS1,ORDERSYS SYS2 WHERE SYS1.SYSNAME='FIRM'
                        AND SYS2.SYSNAME='BROKERID' AND IOD.ORGORDERID=OD.ORDERID AND OD.ORDERID=v_strOrderIdBO;
            COMMIT;
        END IF;

        p_err_code := systemnums.C_SUCCESS;
        p_err_message:= 'Sucessfull!';

    EXCEPTION
      WHEN OTHERS THEN
        ROLLBACK;
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        plog.setendsection (pkgctx, 'pr_CancelOrderPT');
        p_err_code := -100800; --File du lieu dau vao khong hop le
        p_err_message:= SQLERRM;
   END pr_CancelOrderPT;

   PROCEDURE pr_CancelOrder(
        p_OrderIdCancel varchar2,
        p_OrderId varchar2,
        p_acctno varchar2,
        p_CancelQTTY NUMBER,
        p_via varchar2,
        p_userid varchar2,
        p_txdate Date,
        p_err_code  OUT varchar2,
        p_err_message  OUT varchar2
        )
   IS
        v_strODACTYPE  varchar2(4);
        v_strFEEDBACKMSG varchar2(500);
        v_strTIMETYPE varchar2(10);
        v_Odreltid varchar2(10);
        v_OdBlOrderid varchar2(30);
        v_strTLID varchar2(4);
        v_strUSERNAME varchar2(200);
        v_strBUSDATE varchar2(20);
        v_strORDERID varchar2(50);
        v_boOrderId varchar2(50);
        v_txdate varchar2(20);
        v_fomaststatus varchar2(20);
        v_Orderid  varchar2(50);
        v_strlog   varchar2(4000);
        v_MATCHTYPE varchar2(40);
        v_EXECQTTY number(20);
   BEGIN

      plog.setbeginsection (pkgctx, 'pr_CancelOrder');


      v_strlog:= ' pr_CancelOrder p_OrderIdCancel '||p_OrderIdCancel
                                        ||'p_OrderId '||p_OrderId
                                        ||'p_acctno '||p_acctno
                                        ||'p_CancelQTTY '||p_CancelQTTY
                                        ||'p_via '||p_via
                                        ||'p_userid '||p_userid
                                        ||'p_txdate '||p_txdate;

      INSERT INTO t_fo_logcallws(id , tltxcd , acctno, strmsg , logtime)
                                       VALUES(seq_fo_logcallws.NEXTVAL, 'pr_CancelOrder', p_acctno, v_strlog, SYSTIMESTAMP);
      COMMIT;

       INSERT INTO t_fo_reiceiveorder (id,
                                msgtype,
                                orderid,
                                orderidedit,
                                orderidcancel,
                                acctno,
                                symbol,
                                actype,
                                txnum,
                                txdate,
                                txtime,
                                exectype,
                                matchtype,
                                via,
                                clearday,
                                status,
                                pricetype,
                                quoteprice,
                                orderqtty,
                                cancelqtty,
                                editqtty,
                                editprice,
                                userid,
                                contrafirm,
                                traderid,
                                clientid,
                                isdisposal,
                                Receivetime,
                                Process)
VALUES (SEQ_FO_EXEC.NEXTVAL,
        'CANCELOD',
        p_orderid,
        '' ,
        p_OrderIdCancel,
        p_acctno,
        '',
        '',
        '',
        p_txdate,
        '',
        '',
        '',
        p_via,
        '',
        '',
        '',
        '',
        '',
        p_CancelQTTY,
        '',
        '',
        p_userid,
        '',
        '',
        '',
        '',
        SYSTIMESTAMP,
        'N');


        p_err_code := 0;
        plog.setendsection (pkgctx, 'pr_CancelOrder');
        EXCEPTION
      WHEN OTHERS THEN
        ROLLBACK;
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        plog.setendsection (pkgctx, 'pr_CancelOrder');
        p_err_code := -100800; --File du lieu dau vao khong hop le
        p_err_message:= 'System error. Invalid file format';
   END pr_CancelOrder;


 PROCEDURE pr_CancelOrder_Exec(
        p_OrderIdCancel varchar2,
        p_OrderId varchar2,
        p_acctno varchar2,
        p_CancelQTTY NUMBER,
        p_via varchar2,
        p_userid varchar2,
        p_txdate Date,
        p_err_code  OUT varchar2,
        p_err_message  OUT varchar2
        )
   IS
        v_strODACTYPE  varchar2(4);
        v_strFEEDBACKMSG varchar2(500);
        v_strTIMETYPE varchar2(10);
        v_Odreltid varchar2(10);
        v_OdBlOrderid varchar2(30);
        v_strTLID varchar2(4);
        v_strUSERNAME varchar2(200);
        v_strBUSDATE varchar2(20);
        v_strORDERID varchar2(50);
        v_boOrderId varchar2(50);
        v_txdate varchar2(20);
        v_fomaststatus varchar2(20);
        v_Orderid  varchar2(50);
        v_strlog   varchar2(4000);
        v_MATCHTYPE varchar2(40);
        v_EXECQTTY number(20);
        v_OrderQTTY number(20);
        v_OODSTATUS varchar2(40);
   BEGIN

      plog.setbeginsection (pkgctx, 'pr_CancelOrder_Exec');


      v_strlog:= ' pr_CancelOrder_Exec p_OrderIdCancel '||p_OrderIdCancel
                                        ||'p_OrderId '||p_OrderId
                                        ||'p_acctno '||p_acctno
                                        ||'p_CancelQTTY '||p_CancelQTTY
                                        ||'p_via '||p_via
                                        ||'p_userid '||p_userid
                                        ||'p_txdate '||p_txdate;

      INSERT INTO t_fo_logcallws(id , tltxcd , acctno, strmsg , logtime)
                                       VALUES(seq_fo_logcallws.NEXTVAL, 'pr_CancelOrder_Exec', p_acctno, v_strlog, SYSTIMESTAMP);
      COMMIT;

        v_strFEEDBACKMSG := 'MSG_REJECT_CANCEL_ORDER';
        SELECT varvalue
            INTO v_txdate
            FROM sysvar
           WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

        SELECT boorderid INTO  v_boOrderId FROM  newfo_ordermap WHERE foorderid = p_OrderIdCancel AND txdate = TO_DATE(v_txdate, systemnums.C_DATE_FORMAT);

        SELECT od.timetype, a.custid, od.MATCHTYPE,  od.EXECQTTY , od.orderqtty
        INTO v_strTIMETYPE,v_strUSERNAME, v_MATCHTYPE, v_EXECQTTY, v_OrderQTTY
        FROM odmast od, afmast a where od.afacctno = a.acctno and od.orderid=v_boOrderId;

        plog.INFO(pkgctx, 'BEFORE: Yeu cau huy lenh thoa thuan pr_CancelOrder p_OrderIdCancel'|| p_OrderIdCancel);
        IF v_MATCHTYPE ='P' THEN
          plog.INFO(pkgctx, 'Yeu cau huy lenh thoa thuan pr_CancelOrder p_OrderIdCancel'|| p_OrderIdCancel);
          RETURN;
        END IF;

/*        IF p_via = 'O' THEN
            v_strTLID := systemnums.C_ONLINE_USERID;
        ELSE
            v_strTLID := p_userid;
        END IF;*/

        IF length(p_userid) > 4 THEN
          v_strUSERNAME:=p_userid;
          v_strTLID := systemnums.C_ONLINE_USERID;
        ELSE
          v_strTLID:=p_userid;
        END IF;

        SELECT  nvl(retlid,'') retlid, nvl(blorderid, '') blorderid into v_Odreltid, v_OdBlOrderid
            from ((select sb.codeid, sb.tradeplace, sb.sectype,od.blorderid,od.retlid,od.exectype
                from odmast od, sbsecurities sb
                where od.codeid = sb.codeid and OD.orderid = v_boOrderId)
                union all
                (select sb.codeid, sb.tradeplace, sb.sectype,od.blorderid,od.retlid,od.exectype
                from fomast od, sbsecurities sb
                where od.codeid = sb.codeid and OD.acctno = v_boOrderId));

        --SELECT CUSTID INTO v_strUSERNAME FROM AFMAST WHERE ACCTNO = p_acctno;

        v_strBUSDATE:=cspks_system.fn_get_sysvar('SYSTEM','CURRDATE');
        select v_strBUSDATE || lpad(seq_fomast.nextval,10,'0') into v_strORDERID from dual;

        -- Lay thong tin timetype
        SELECT od.timetype INTO v_strTIMETYPE FROM odmast od where od.orderid=v_boOrderId;
        --Lay trang thai lenh fomast
        BEGIN
          SELECT status INTO v_fomaststatus FROM fomast WHERE acctno = v_boOrderId;
        EXCEPTION WHEN OTHERS THEN
          v_fomaststatus :='A';
        END;
        IF p_OrderId = p_OrderIdCancel AND v_fomaststatus = 'P' THEN --Lenh vao FOMAST o trang thai Pending.
            v_strFEEDBACKMSG := 'Order is cancelled when processing';
            UPDATE FOMAST SET STATUS='R',FEEDBACKMSG=v_strFEEDBACKMSG  WHERE BOOK='A' AND ACCTNO=v_boOrderId AND STATUS='P';
            p_err_code := systemnums.C_SUCCESS;
        ELSE
          IF p_OrderId = p_OrderIdCancel AND v_fomaststatus = 'A' THEN --Da day vao fomast, va tien trinh day lenh sinh lenh huy
            /*
            UPDATE odmast
                SET cancelqtty = orderqtty,
                remainqtty = 0,
                ORSTATUS ='3'
           WHERE orderid = v_boOrderId;
           p_err_code := systemnums.C_SUCCESS;*/
            v_Orderid :='C'||p_OrderId; --Do khi yeu cau huy lenh cho gui, FO ko sinh so hieu lenh moi.
           ELSE

            v_Orderid := p_OrderId;
           END IF;

          IF  v_OrderQTTY > p_CancelQTTY THEN  --Khoi luong lenh yeu cau huy < lenh goc -> lenh da khop 1 phan.
           BEGIN
              SELECT OODSTATUS INTO v_OODSTATUS FROM OOD WHERE   ORGORDERID = v_boOrderId;
                  IF  v_OODSTATUS ='N' THEN
                      UPDATE OOD
                      SET OODSTATUS = 'S', TXTIME = TO_CHAR(SYSDATE,'HH24:MI:SS')
                      WHERE ORGORDERID = v_boOrderId AND OODSTATUS <> 'S';
                      INSERT INTO ODQUEUE SELECT * FROM OOD WHERE ORGORDERID =  v_boOrderId;
                  END IF;
              EXCEPTION WHEN OTHERS THEN
                 plog.debug (pkgctx, ' pr_CancelOrder_Exec,Invalid status mv_strorgorderid'||v_boOrderId );
              END;
           END IF;

           INSERT INTO FOMAST (ACCTNO, ORGACCTNO, ACTYPE, AFACCTNO, STATUS, EXECTYPE, PRICETYPE, TIMETYPE, MATCHTYPE, NORK, CLEARCD, CODEID, SYMBOL,
          CONFIRMEDVIA, DIRECT, BOOK, FEEDBACKMSG, ACTIVATEDT, CREATEDDT, CLEARDAY, QUANTITY, PRICE, QUOTEPRICE, TRIGGERPRICE, EXECQTTY, EXECAMT, REMAINQTTY,
          REFACCTNO, REFQUANTITY, REFPRICE, REFQUOTEPRICE,VIA,EFFDATE,EXPDATE,USERNAME, TLID,QUOTEQTTY, LIMITPRICE,BLORDERID,RETLID, forefid)
          SELECT v_strORDERID, v_boOrderId, od.ACTYPE, od.AFACCTNO, 'P',
                 (CASE WHEN od.EXECTYPE='NB' OR od.EXECTYPE='CB' OR od.EXECTYPE='AB' THEN 'CB' ELSE 'CS' END) CANCEL_EXECTYPE,
                 od.PRICETYPE, od.TIMETYPE, od.MATCHTYPE, od.NORK, od.CLEARCD, od.CODEID, sb.SYMBOL,
                 'O' CONFIRMEDVIA,'Y' ,'A' BOOK, v_strFEEDBACKMSG ,
                 TO_CHAR(SYSDATE,'DD/MM/RRRR HH24:MI:SS'), TO_CHAR(SYSDATE,'DD/MM/RRRR HH24:MI:SS'),
                 od.CLEARDAY,od.exqtty QUANTITY,(od.exprice/1000) PRICE, (od.QUOTEPRICE/1000) QUOTEPRICE, 0 TRIGGERPRICE, od.EXECQTTY, od.EXECAMT,
                 od.REMAINQTTY, od.orderid REFACCTNO, 0 REFQUANTITY, 0 REFPRICE, (od.QUOTEPRICE/1000) REFQUOTEPRICE,
                 p_via VIA,p_txdate EFFDATE, p_txdate EXPDATE,
                 v_strUSERNAME USERNAME, v_strTLID, 0 , 0,v_OdBlOrderid,v_Odreltid,p_OrderId
                 FROM ODMAST od, sbsecurities sb
                 WHERE orstatus IN ('1','2','4','8') AND orderid=v_boOrderId and sb.codeid = od.codeid
                    and orderid not in (select REFACCTNO
                                            from fomast
                                            WHERE EXECTYPE IN ('CB','CS') AND STATUS <>'R');

            p_err_code := systemnums.C_SUCCESS;
            p_err_message:= 'Sucessfull!';

            pr_fo2odsyn(v_strORDERID, v_OrderId, '', p_err_code,v_strTIMETYPE);
            --TXPKS_AUTO.pr_fo2odsyn(v_boOrderId,p_err_code,v_strTIMETYPE);

            If nvl(p_err_code,'0') <> '0' Then
                UPDATE FOMAST SET DELTD='Y' WHERE ACCTNO=p_OrderId;
                p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
                plog.error(pkgctx, 'Error:'  || p_err_message);
                plog.setendsection(pkgctx, 'pr_cancelorder');
            End if;

        END IF;
         plog.setendsection (pkgctx, 'pr_CancelOrder_Exec');
        EXCEPTION
      WHEN OTHERS THEN
        ROLLBACK;
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        plog.setendsection (pkgctx, 'pr_CancelOrder_Exec');
        p_err_code := -100800; --File du lieu dau vao khong hop le
        p_err_message:= 'System error. Invalid file format';
   END;

   PROCEDURE pr_EditOrder
   (
        p_OrderIdEdit varchar2,
        p_OrderId varchar2,
        p_acctno varchar2,
        p_EditQTTY NUMBER,
        p_EditPrice NUMBER,
        p_via varchar2,
        p_userid varchar2,
        p_txdate Date,
        p_err_code  OUT varchar2,
        p_err_message  OUT varchar2
    )
    IS
        v_Odreltid varchar2(10);
        v_OdBlOrderid varchar2(30);
        v_count number(20,0);
        v_strFOStatus char(1);
        v_strFEEDBACKMSG VARCHAR2(500);
        v_blnOK boolean;
        v_strSTATUS char(1);
        v_strTIMETYPE varchar2(10);
        v_dblLIMITPRICE  number(20,4);
        v_strTLID varchar2(4);
        v_strUSERNAME varchar2(200);
        v_strBUSDATE varchar2(20);
        v_strORDERID varchar2(50);
        v_boOrderId varchar2(50);
        v_txdate varchar2(20);
        l_HoldDirect char(1);
        l_editprice NUMBER(20,2);
        v_strlog varchar2(4000);
    BEGIN

      plog.setbeginsection (pkgctx, 'pr_EditOrder');


      v_strlog := ' pr_EditOrder p_OrderIdEdit =>'||p_OrderIdEdit
                                        ||',p_OrderId =>'||p_OrderId
                                        ||',p_acctno =>'||p_acctno
                                        ||',p_EditQTTY =>'||p_EditQTTY
                                        ||',p_EditPrice =>'||p_EditPrice
                                        ||',p_via =>'||p_via
                                        ||',p_userid =>'||p_userid
                                        ||',p_txdate =>'||p_txdate||''''
                                  ;
      INSERT INTO t_fo_logcallws(id , tltxcd , acctno, strmsg , logtime)
                                       VALUES(seq_fo_logcallws.NEXTVAL, 'pr_EditOrder', p_acctno, v_strlog, SYSTIMESTAMP);
      COMMIT;

      INSERT INTO t_fo_reiceiveorder (id,
                                msgtype,
                                orderid,
                                orderidedit,
                                orderidcancel,
                                acctno,
                                symbol,
                                actype,
                                txnum,
                                txdate,
                                txtime,
                                exectype,
                                matchtype,
                                via,
                                clearday,
                                status,
                                pricetype,
                                quoteprice,
                                orderqtty,
                                cancelqtty,
                                editqtty,
                                editprice,
                                userid,
                                contrafirm,
                                traderid,
                                clientid,
                                isdisposal,
                                Receivetime,
                                Process)
    VALUES (SEQ_FO_EXEC.NEXTVAL,
            'EDITOD',
            p_orderid,
            p_OrderIdEdit,
            '' ,
            p_acctno,
            '',
            '',
            '',
            p_txdate,
            '',
            '',
            '',
            p_via,
            '',
            '',
            '',
            '',
            '',
            '' ,
            p_editqtty,
            p_EditPrice,
            p_userid,
            '',
            '',
            '',
            '',
            SYSTIMESTAMP,
            'N');

         p_err_code := 0;
        plog.setendsection (pkgctx, 'pr_EditOrder');
        EXCEPTION
      WHEN OTHERS THEN
        ROLLBACK;
        p_err_code := -100800; --File du lieu dau vao khong hop le
        p_err_message:= 'System error. Invalid file format';
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        plog.setendsection (pkgctx, 'pr_EditOrder');
    END pr_EditOrder;

  PROCEDURE pr_EditOrder_Exec
   (
        p_OrderIdEdit varchar2,
        p_OrderId varchar2,
        p_acctno varchar2,
        p_EditQTTY NUMBER,
        p_EditPrice NUMBER,
        p_via varchar2,
        p_userid varchar2,
        p_txdate Date,
        p_err_code  OUT varchar2,
        p_err_message  OUT varchar2
    )
    IS
        v_Odreltid varchar2(10);
        v_OdBlOrderid varchar2(30);
        v_count number(20,0);
        v_strFOStatus char(1);
        v_strFEEDBACKMSG VARCHAR2(500);
        v_blnOK boolean;
        v_strSTATUS char(1);
        v_strTIMETYPE varchar2(10);
        v_dblLIMITPRICE  number(20,4);
        v_strTLID varchar2(4);
        v_strUSERNAME varchar2(200);
        v_strBUSDATE varchar2(20);
        v_strORDERID varchar2(50);
        v_boOrderId varchar2(50);
        v_txdate varchar2(20);
        l_HoldDirect char(1);
        l_editprice NUMBER(20,2);
        v_strlog varchar2(4000);
    BEGIN

      plog.setbeginsection (pkgctx, 'pr_EditOrder_Exec');


      v_strlog := ' pr_EditOrder_Exec p_OrderIdEdit =>'||p_OrderIdEdit
                                        ||',p_OrderId =>'||p_OrderId
                                        ||',p_acctno =>'||p_acctno
                                        ||',p_EditQTTY =>'||p_EditQTTY
                                        ||',p_EditPrice =>'||p_EditPrice
                                        ||',p_via =>'||p_via
                                        ||',p_userid =>'||p_userid
                                        ||',p_txdate =>'||p_txdate||''''
                                  ;
      INSERT INTO t_fo_logcallws(id , tltxcd , acctno, strmsg , logtime)
                                       VALUES(seq_fo_logcallws.NEXTVAL, 'pr_EditOrder', p_acctno, v_strlog, SYSTIMESTAMP);
      COMMIT;

      p_err_code := '0';

        l_editprice := p_EditPrice;
        BEGIN
            l_HoldDirect:=cspks_system.fn_get_sysvar('BROKERDESK','DIRECT_HOLD_TO_BANK');
        EXCEPTION WHEN OTHERS THEN
            l_HoldDirect:= 'N';
        END;
        v_dblLIMITPRICE:=0;

        SELECT varvalue
        INTO v_txdate
        FROM sysvar
       WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

        SELECT boorderid
        INTO v_boOrderId
        FROM newfo_ordermap
       WHERE foorderid = p_OrderIdEdit And txdate = TO_DATE(v_txdate, systemnums.c_date_format);
        plog.debug(pkgctx, 'p_OrderIdEdit: '  || p_OrderIdEdit);

        begin
        select retlid,blorderid into v_Odreltid, v_OdBlOrderid
            from ((select sb.codeid, sb.tradeplace, sb.sectype,
                    nvl(od.blorderid,'') blorderid,nvl(od.retlid, '') retlid,od.exectype
                from odmast od, sbsecurities sb
                where od.codeid = sb.codeid and OD.orderid = v_boOrderId)
                union all
                (select sb.codeid, sb.tradeplace, sb.sectype,
                    nvl(od.blorderid,'') blorderid,nvl(od.retlid, '') retlid,od.exectype
                from fomast od, sbsecurities sb
                where od.codeid = sb.codeid and OD.acctno = v_boOrderId));
        EXCEPTION WHEN OTHERS THEN
           v_Odreltid := NULL;
           v_OdBlOrderid:= NULL;
        END;
        plog.debug(pkgctx, 'v_boOrderId: '  || v_boOrderId);
/*          select (case when AF.corebank='Y' AND OD.exectype IN ('NB')
          then 'W' else 'P' end) status, od.timetype, af.custid
          into v_strSTATUS, v_strTIMETYPE,v_strUSERNAME
          from afmast AF, ODMAST OD
          WHERE OD.AFACCTNO = AF.ACCTNO AND OD.ORDERID = v_boOrderId;

          if l_HoldDirect='Y' then
            v_strSTATUS:='P';
          end if;*/

          v_strSTATUS:='P';
          --plog.debug(pkgctx, 'v_strSTATUS: '  || v_strSTATUS);

/*          IF p_via = 'O' THEN
            v_strTLID := systemnums.C_ONLINE_USERID;
          ELSE
            v_strTLID := p_userid;
          END IF;*/

          IF length(p_userid) > 4 THEN
            v_strUSERNAME:=p_userid;
            v_strTLID := systemnums.C_ONLINE_USERID;
          ELSE
            v_strTLID:=p_userid;
          END IF;

          --SELECT CUSTID INTO v_strUSERNAME FROM AFMAST WHERE ACCTNO = p_acctno;

          v_strBUSDATE:=cspks_system.fn_get_sysvar('SYSTEM','CURRDATE');
          select v_strBUSDATE || lpad(seq_fomast.nextval,10,'0') into v_strORDERID from dual;

          IF p_OrderIdEdit = p_OrderId THEN  --Lenh chua dc day vao san thi sua truc tiep lenh do luon
            UPDATE FOMAST SET refquantity = quantity, refprice = price, refquoteprice = price, quantity = p_EditQTTY,
                price = l_editprice, quoteprice = l_editprice, remainqtty = p_EditQTTY
                WHERE orgacctno = v_boOrderId;

            UPDATE ODMAST SET exprice = l_editprice, exqtty = p_EditQTTY, remainqtty = p_EditQTTY,
                orderqtty = p_EditQTTY, quoteprice = l_editprice
                WHERE orderid = v_boOrderId;

            p_err_code := systemnums.C_SUCCESS;
          ELSE
            INSERT INTO FOMAST (ACCTNO, ORGACCTNO, ACTYPE, AFACCTNO, STATUS, EXECTYPE, PRICETYPE, TIMETYPE, MATCHTYPE, NORK, CLEARCD, CODEID, SYMBOL,
              CONFIRMEDVIA,DIRECT, BOOK, FEEDBACKMSG, ACTIVATEDT, CREATEDDT, CLEARDAY, QUANTITY, PRICE, QUOTEPRICE, TRIGGERPRICE, EXECQTTY, EXECAMT, REMAINQTTY,
              REFACCTNO, REFQUANTITY, REFPRICE, REFQUOTEPRICE,VIA,EFFDATE,EXPDATE,USERNAME, TLID, Quoteqtty,limitprice,BLORDERID,RETLID,NOTE, forefid)
          SELECT v_strORDERID, v_boOrderId ,od.ACTYPE, od.AFACCTNO AFACCTNO, v_strSTATUS,
              (CASE WHEN od.EXECTYPE='NB' OR od.EXECTYPE='CB' OR EXECTYPE='AB' THEN 'AB' ELSE 'AS' END) CANCEL_EXECTYPE,
              od.PRICETYPE, od.TIMETYPE, od.MATCHTYPE, od.NORK, od.CLEARCD, od.CODEID, sb.SYMBOL,
              'O' CONFIRMEDVIA, 'Y','A' BOOK, v_strFEEDBACKMSG  FEEDBACKMSG,TO_CHAR(SYSDATE,'DD/MM/RRRR HH24:MI:SS') ACTIVATEDT,TO_CHAR(SYSDATE,'DD/MM/RRRR HH24:MI:SS') CREATEDDT, od.CLEARDAY,
               p_EditQTTY , l_editprice , l_editprice ,0 TRIGGERPRICE, 0 EXECQTTY, 0 EXECAMT,p_EditQTTY  REMAINQTTY,
              od.orderid REFACCTNO, ORDERQTTY REFQUANTITY, round(QUOTEPRICE/SIF.TRADEUNIT,2) REFPRICE, round(QUOTEPRICE/SIF.TRADEUNIT,2) REFQUOTEPRICE,
              p_via  VIA ,p_txdate EFFDATE,p_txdate EXPDATE,
              v_strUSERNAME USERNAME, v_strTLID TLID,  0,v_dblLIMITPRICE,v_OdBlOrderid,v_Odreltid,'',p_OrderId
           FROM ODMAST od, sbsecurities sb, securities_info SIF
           WHERE orstatus IN ('1','2','4','8') AND orderid=v_boOrderId and sb.codeid = od.codeid AND SIF.CODEID = OD.CODEID
              and orderid not in (select REFACCTNO from fomast WHERE EXECTYPE IN ('CB','CS','AB','AS') AND STATUS <>'R' AND REFACCTNO IS NOT NULL);

           plog.debug(pkgctx, 'v_strSTATUS: '  || v_strSTATUS);

           p_err_code := 0;
           p_err_message:= 'Sucessfull!';
           pr_fo2odsyn(v_strORDERID, p_OrderId, v_boOrderId, p_err_code,v_strTIMETYPE);
           plog.debug(pkgctx, 'p_err_code: '  || p_err_code);
           If nvl(p_err_code,'0') <> '0' Then
               --Cap nhat trang thai tu choi
               UPDATE FOMAST SET DELTD='Y' WHERE ORGACCTNO=v_boOrderId;
               p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
               plog.error(pkgctx, 'Error:'  || p_err_message);
               plog.setendsection (pkgctx, 'pr_EditOrder_Exec');
               Return;
           End If;
          END IF;


        plog.setendsection (pkgctx, 'pr_EditOrder_Exec');
        EXCEPTION
      WHEN OTHERS THEN
        ROLLBACK;
        p_err_code := -100800; --File du lieu dau vao khong hop le
        p_err_message:= 'System error. Invalid file format';
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        plog.setendsection (pkgctx, 'pr_EditOrder_Exec');
    END;

PROCEDURE pr_fo2odsyn (p_orderid varchar2, p_fo_orderid varchar2, p_bo_orderid varchar2, p_err_code  OUT varchar2, p_timetype varchar2 default 'T' )
   IS
      l_txmsg               tx.msg_rectype;
      l_orders_cache_size   NUMBER (10) := 10000;
      l_commit_freq         NUMBER (10) := 10;
      l_count               NUMBER (10) := 0;
      l_order_count         NUMBER (10) := 0;
      l_err_param           deferror.errdesc%TYPE;

      l_mktstatus           ordersys.sysvalue%TYPE;
      l_atcstarttime        sysvar.varvalue%TYPE;

      l_typebratio          odtype.bratio%TYPE;
      l_afbratio            afmast.bratio%TYPE;
      l_securedratio        odtype.bratio%TYPE;
      l_actype              odtype.actype%TYPE;
      l_remainqtty          odmast.orderqtty%TYPE;
      l_fullname            cfmast.fullname%TYPE;
      l_ordervia            odtype.via%type;

      l_feeamountmin        NUMBER;
      l_feerate             NUMBER;
      l_feesecureratiomin   NUMBER;
      l_hosebreakingsize    NUMBER;
      l_hasebreakingsize    NUMBER;
      l_breakingsize        NUMBER;
      l_strMarginType       mrtype.mrtype%TYPE;
      l_dblMarginRatioRate  afserisk.MRRATIOLOAN%TYPE;
      l_dblSecMarginPrice   afserisk.MRPRICELOAN%TYPE;
      --</ Margin 74
      l_dblIsMarginAllow   afserisk.ISMARGINALLOW%TYPE;
      l_dblChkSysCtrl       lntype.chksysctrl%TYPE;
      --/>
      l_dblIsPPUsed         mrtype.ISPPUSED%TYPE;
      l_strEXECTYPE         odmast.exectype%TYPE;
      l_hnxTRADINGID        varchar2(30);
      l_ismortage           VARCHAR2(10);-- PhuongHT add
      l_CUSTATCOM           cfmast.custatcom%TYPE; -- Them vao de sua lenh Bloomberg
      v_count number;
      l_RATE_BRK_S   number;
      l_RATE_BRK_B   number;
      l_Rate_fee     number;
   BEGIN
      plog.setbeginsection (pkgctx, 'pr_fo2odsyn');
      --plog.debug (pkgctx, 'BEGIN OF pr_fo2odsyn');
      --plog.debug (pkgctx, 'p_orderid: '||p_orderid);
      --plog.debug (pkgctx, 'newfo.p_timetype: '||p_timetype);
      /***************************************************************************************************
       ** PUT YOUR CODE HERE, FOLLOW THE BELOW TEMPLATE:
       ** IF NECCESSARY, USING BULK COLLECTION IN THE CASE YOU MUST POPULATE LARGE DATA
      ****************************************************************************************************/
      l_atcstarttime      :=
         cspks_system.fn_get_sysvar ('SYSTEM', 'ATCSTARTTIME');
      --l_hosebreakingsize   :=
         --cspks_system.fn_get_sysvar ('SYSTEM', 'HOSEBREAKSIZE');
      l_hosebreakingsize   :=least(cspks_system.fn_get_sysvar ('SYSTEM', 'HOSEBREAKSIZE'),
                                    cspks_system.fn_get_sysvar ('BROKERDESK', 'HOSE_MAX_QUANTITY')
                                  );
      l_hasebreakingsize:=cspks_system.fn_get_sysvar ('BROKERDESK', 'HNX_MAX_QUANTITY');

      -- 1. Set common values
      l_txmsg.brid        := systemnums.c_ho_brid;
      l_txmsg.tlid        := systemnums.c_system_userid;
      l_txmsg.off_line    := 'N';
      l_txmsg.deltd       := txnums.c_deltd_txnormal;
      l_txmsg.txstatus    := txstatusnums.c_txcompleted;
      l_txmsg.msgsts      := '0';
      l_txmsg.ovrsts      := '0';
      l_txmsg.batchname   := 'ISFO';

      p_err_code:='0';

      SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
      FROM DUAL;
      plog.debug (pkgctx,
                                          'p_fo_orderid : '||  p_fo_orderid ||' p_orderid: '||p_orderid ||' p_timetype" '||p_timetype );
      -- 2. Set specific value for each transaction
      for l_build_msg in
      (
         SELECT  a.codeid fld01,
                 a.symbol fld07,
                 DECODE (a.exectype, 'MS', '1', '0') fld60, --ismortage   fld60, -- FOR 8885
                 a.actype fld02,
                 a.afacctno || a.codeid fld06,                --seacctno    fld06,
                 a.afacctno fld03,
                 a.timetype fld20,
                 --'T' fld20,
                 a.effdate fld19,
                 --a.expdate fld21, -- Lenh GTC day vao ODMAST lay expdate = currdate
                 getcurrdate fld21,
                 a.exectype fld22,
                 a.outpriceallow fld34,
                 a.nork fld23,
                 a.matchtype fld24,
                 a.via fld25,
                 a.clearday fld10,
                 a.clearcd fld26,
                 'O' fld72,                                       --puttype fld72,
                 (CASE WHEN a.exectype IN ('AB','AS') AND a.pricetype='MTL' THEN 'LO' ELSE a.pricetype END ) fld27,
                 -- PhuongHT edit for sua lenh MTL
                 case when timetype ='G' then a.remainqtty else a.quantity end fld12,                      --a.ORDERQTTY       fld12,
                 a.quoteprice fld11,
                 0 fld18,                               --a.ADVSCRAMT       fld18,
                 0 fld17,                               --a.ORGQUOTEPRICE   fld17,
                 0 fld16,                               --a.ORGORDERQTTY    fld16,
                 a.bratio fld13,
                 a.limitprice fld14,                               --a.LIMITPRICE      fld14,
                 0 fld40,                                                -- FEEAMT
                 a.reforderid fld08,
                 b.parvalue fld15,
                 a.dfacctno fld95,
                 100 fld99,                             --a.HUNDRED         fld99,
                 c.tradeunit fld98,
                 1 fld96,                                                   -- GTC
                 '' fld97,                                                  --mode
                 '' fld73,                                            --contrafirm
                 '' fld71,                                             --contracus
                 a.acctno,                              -- only for test mktstatus
                 '' fld30,                              --a.DESC            fld30,
                 a.refacctno,
                 a.orgacctno,
                 a.refprice,
                 a.refquantity,
                 c.ceilingprice,
                 c.floorprice,
                 c.marginprice,
                 c.marginrefprice,
                 b.tradeplace,
                 b.sectype,
                 c.tradelot,
                 c.securedratiomin,
                 c.securedratiomax,
                 a.SPLOPT,
                 a.SPLVAL,
                 a.ISDISPOSAL,
                 a.username username,
                 a.SSAFACCTNO fld94,
                 '' fld35,
                 a.tlid tlid,
                 a.quoteqtty fld80,
                 a.CONTRAFIRM fld31,
                 a.TRADERID fld32,
                 a.CLIENTID fld33
          FROM fomast a, sbsecurities b, securities_info c
          WHERE     a.book = 'A'
                --AND a.timetype = p_timetype
                AND a.status = 'P'
                --nd a.direct= DECODE(p_timetype,'G',A.DIRECT,'Y')
                AND a.codeid = b.codeid
                AND a.codeid = c.codeid
                and a.acctno = p_orderid
      )
      LOOP
            BEGIN
              plog.debug (pkgctx,
                                          'p_fo_orderid2 : '||  p_fo_orderid ||' p_orderid: '||p_orderid );

                --PHuongHT truyen lai tham so cho lenh ban cam co
                l_ismortage :=l_build_msg.fld60;
                IF l_build_msg.fld22 ='AS' THEN
                  -- lay theo lenh goc
                  BEGIN
                    SELECT  DECODE (a.exectype, 'MS', '1', '0')
                    INTO l_ismortage
                    FROM odmast a  WHERE orderid =l_build_msg.refacctno;
                  EXCEPTION WHEN OTHERS THEN
                  l_ismortage:= 0;
                  END;

                END IF;
                -- Ducnv check trang thai thi truong HNX
                              -- Check Market status
               SELECT sysvalue
               INTO l_mktstatus
               FROM ordersys
               WHERE sysname = 'CONTROLCODE';

                l_txmsg.tlid := l_build_msg.tlid;

               l_txmsg.txfields ('22').VALUE     := l_build_msg.fld22; --set vale for Execution TYPE
               l_strEXECTYPE:=l_build_msg.fld22;

               IF LENGTH (l_build_msg.refacctno) > 0
               THEN                                             --lENH HUY SUA
                  FOR i IN (SELECT exectype
                            FROM fomast
                            WHERE orgacctno = l_build_msg.refacctno)
                  LOOP
                     l_strEXECTYPE:=i.exectype;
                  END LOOP;
               END IF;
               plog.debug (pkgctx,
                                          'l_build_msg.refacctno : '||  l_build_msg.refacctno );

               IF l_build_msg.fld27 <> 'LO'
               THEN                                               -- Pricetype
                  IF l_strEXECTYPE='NB'--l_build_msg (indx).fld22 = 'NB'
                  THEN                                             -- exectype
                     l_build_msg.fld11   :=
                        l_build_msg.ceilingprice
                        / l_build_msg.fld98;                --tradeunit
                  ELSE
                     l_build_msg.fld11   :=
                        l_build_msg.floorprice
                        / l_build_msg.fld98;
                  END IF;
               END IF;

               FOR i IN (SELECT MST.BRATIO, CF.CUSTODYCD,CF.FULLNAME,MST.ACTYPE,MRT.MRTYPE,MRT.ISPPUSED,
                        NVL(RSK.MRRATIOLOAN,0) MRRATIOLOAN, NVL(MRPRICELOAN,0) MRPRICELOAN,
                        nvl(ISMARGINALLOW,'N') ISMARGINALLOW, nvl(lnt.chksysctrl,'N') chksysctrl, cf.custatcom
                        FROM AFMAST MST, CFMAST CF ,AFTYPE AFT, MRTYPE MRT, LNTYPE LNT,
                        (SELECT * FROM AFSERISK WHERE CODEID=l_build_msg.fld01 ) RSK
                        WHERE MST.ACCTNO=l_build_msg.fld03
                        AND MST.CUSTID=CF.CUSTID
                        and mst.actype =aft.actype and aft.mrtype = mrt.actype and aft.lntype = lnt.actype(+)
                        AND AFT.ACTYPE =RSK.ACTYPE(+))
               LOOP
                  l_txmsg.txfields ('09').VALUE   := i.custodycd;
                  l_actype                        := i.actype;
                  l_afbratio                      := i.bratio;
                  --l_txmsg.txfields ('50').VALUE   := 'FO';
                  l_fullname                      := i.fullname;
                  l_strMarginType                 := i.MRTYPE;
                  l_dblMarginRatioRate            := i.MRRATIOLOAN;
                  l_dblSecMarginPrice             := i.MRPRICELOAN;
                  --</ Margin 74
                  l_dblIsMarginAllow              := i.ISMARGINALLOW;
                  l_dblChkSysCtrl                 := i.CHKSYSCTRL;
                  --/>
                  l_dblIsPPUsed                   := i.ISPPUSED;
                  -- Them vao de sua cho lenh Bloomberg
                  -- TheNN, 16-Jul-2013
                  l_CUSTATCOM                       := i.custatcom;
                  -- Ket thuc: Them vao de sua cho lenh Bloomberg
                  If l_dblMarginRatioRate >= 100 Or l_dblMarginRatioRate < 0 or (l_dblIsMarginAllow = 'N' and l_dblChkSysCtrl = 'Y')
                  Then
                        l_dblMarginRatioRate := 0;
                  END IF;
                  if l_dblChkSysCtrl = 'Y' then
                      if l_build_msg.marginrefprice > l_dblSecMarginPrice
                      then
                            l_dblSecMarginPrice := l_dblSecMarginPrice;
                      else
                            l_dblSecMarginPrice := l_build_msg.marginrefprice;
                      end if;
                  else
                      if l_build_msg.marginprice > l_dblSecMarginPrice
                      then
                            l_dblSecMarginPrice := l_dblSecMarginPrice;
                      else
                            l_dblSecMarginPrice := l_build_msg.marginprice;
                      end if;
                  end if;
               END LOOP;

               BEGIN
                    -- Neu lenh sua thi lay lai ti le ky quy va thong tin loai hinh nhu lenh goc
                    -- TheNN, 15-Feb-2012
                    IF substr(l_build_msg.fld22,1,1) = 'A' THEN
                        SELECT OD.ACTYPE, OD.CLEARDAY, OD.BRATIO
                        INTO l_txmsg.txfields ('02').VALUE, l_txmsg.txfields ('10').VALUE, l_securedratio
                        FROM ODMAST OD
                        WHERE ORDERID = p_bo_orderid;
                    ELSE
                        -- LAY THONG TIN VA TINH TY LE KY QUY NHU BINH THUONG
                        -- Trong loai hinh OD ko quy dinh kenh GD qua BrokerDesk nen se gan cung kenh voi tai san (Floor)
                        BEGIN
                              -- TheNN, 14-Feb-2012
                              l_ordervia := l_build_msg.fld25;
                              if l_ordervia = 'B' then
                                  l_ordervia := 'F';
                              end if;
                              -- End: TheNN, 14-Feb-2012

                         --Do phi FO lay theo tai khoan:
                         /*
                         SELECT MAX(RATE_BRK_S) RATE_BRK_S,
                                MAX(RATE_BRK_B) RATE_BRK_B
                         INTO  l_RATE_BRK_S, l_RATE_BRK_B
                           FROM
                              (
                                  Select a.actype, a.aftype,
                                      CASE WHEN b.sectype IN ('000','001','002','111','333') THEN b.deffeerate ELSE 0 END RATE_BRK_S,
                                      CASE WHEN b.sectype IN ('000','003','006','222','444') THEN b.deffeerate ELSE 0 END RATE_BRK_B
                                      from afidtype a, odtype b
                                      where b.actype = a.actype and  a.objname = 'OD.ODTYPE'
                              )
                         WHERE  aftype =  l_actype
                         GROUP BY aftype;

                         IF l_build_msg.sectype IN ('000','001','002','111','333') THEN
                           l_Rate_fee := l_RATE_BRK_S;
                         ELSE
                           l_Rate_fee := l_RATE_BRK_B;
                         END IF;
                         */

                         SELECT actype, clearday, bratio, minfeeamt, deffeerate
                              --to_char(sysdate,systemnums.C_TIME_FORMAT) TXTIME
                              INTO l_txmsg.txfields ('02').VALUE,                 --ACTYPE
                                   l_txmsg.txfields ('10').VALUE,               --CLEARDAY
                                   l_typebratio,                          --BRATIO (fld13)
                                   l_feeamountmin,
                                   l_feerate
                              FROM (SELECT a.actype, a.clearday, a.bratio, a.minfeeamt, a.deffeerate,   b.ODRNUM
                              FROM odtype a, afidtype b
                              WHERE     a.status = 'Y'
                                    AND (a.via = l_build_msg.fld25 OR a.via = 'A') --VIA
                                    AND a.clearcd = l_build_msg.fld26       --CLEARCD
                                    AND (a.exectype = l_strEXECTYPE           --l_build_msg.fld22
                                         OR a.exectype = 'AA')                    --EXECTYPE
                                    AND (a.timetype = l_build_msg.fld20
                                         OR a.timetype = 'A')                     --TIMETYPE
                                    AND (a.pricetype = l_build_msg.fld27
                                         OR a.pricetype = 'AA')                  --PRICETYPE
                                    AND (a.matchtype = l_build_msg.fld24
                                         OR a.matchtype = 'A')                   --MATCHTYPE
                                    AND (a.tradeplace = l_build_msg.tradeplace
                                         OR a.tradeplace = '000')
            --                        AND (sectype = l_build_msg.sectype
            --                             OR sectype = '000')

                                    AND (instr(case when l_build_msg.sectype in ('001','002','011') then l_build_msg.sectype || ',' || '111,333'
                                                   when l_build_msg.sectype in ('003','006') then l_build_msg.sectype || ',' || '222,333,444'
                                                   when l_build_msg.sectype in ('008') then l_build_msg.sectype || ',' || '111,444'
                                                   else l_build_msg.sectype end, a.sectype)>0 OR a.sectype = '000')
                                    AND (a.nork = l_build_msg.fld23 OR a.nork = 'A') --NORK
                                    AND (CASE WHEN A.CODEID IS NULL THEN l_build_msg.fld01 ELSE A.CODEID END)=l_build_msg.fld01
                                    AND a.actype = b.actype and b.aftype=l_actype and b.objname='OD.ODTYPE'
                                    --order by b.odrnum DESC, A.deffeerate DESC
                                    --order BY A.deffeerate DESC, B.ACTYPE DESC
                                    ORDER BY CASE WHEN (SELECT VARVALUE FROM SYSVAR WHERE GRNAME = 'SYSTEM' AND VARNAME = 'ORDER_ORD') = 'ODRNUM' THEN ODRNUM ELSE DEFFEERATE END ASC -- lay theo ordnum cua afidtype
                                    ) where rownum<=1;
                           EXCEPTION

                              WHEN NO_DATA_FOUND
                              THEN
                              RAISE errnums.e_od_odtype_notfound;
                           END;

                           if l_strMarginType='S' or l_strMarginType='T' or l_strMarginType='N' then
                               --Tai khoan margin va tai khoan binh thuong ky quy 100%
                                l_securedratio:=100;
                           elsif l_strMarginType='L' then --Cho tai khoan margin loan
                                begin
                                    select (case when nvl(dfprice,0)>0 then least(nvl(dfrate,0),round(nvl(dfprice,0)/ l_build_msg.fld11/l_build_msg.fld98 * 100,4)) else nvl(dfrate,0) end ) dfrate
                                    into l_securedratio
                                    from (select * from dfbasket where symbol=l_build_msg.fld07) bk,
                                    aftype aft, dftype dft,afmast af
                                    where af.actype = aft.actype and aft.dftype = dft.actype and dft.basketid = bk.basketid (+)
                                    and af.acctno = l_build_msg.fld03;
                                    l_securedratio:=greatest (100-l_securedratio,0);
                                exception
                                when others then
                                     l_securedratio:=100;
                                end;
                           else
                                l_securedratio                    :=
                                GREATEST (LEAST (l_typebratio + l_afbratio, 100),
                                        l_build_msg.securedratiomin
                                );
                                l_securedratio                    :=
                                  CASE
                                     WHEN l_securedratio > l_build_msg.securedratiomax
                                     THEN
                                        l_build_msg.securedratiomax
                                     ELSE
                                        l_securedratio
                                  END;
                           end if;

                           --FeeSecureRatioMin = mv_dblFeeAmountMin * 100 / (CDbl(v_strQUANTITY) * CDbl(v_strQUOTEPRICE) * CDbl(v_strTRADEUNIT))
                           l_feesecureratiomin               :=
                              l_feeamountmin * 100
                              / (  TO_NUMBER (l_build_msg.fld12)         --quantity
                                 * TO_NUMBER (l_build_msg.fld11)       --quoteprice
                                 * TO_NUMBER (l_build_msg.fld98));      --tradeunit

                           IF l_feesecureratiomin > l_feerate
                           THEN
                              l_securedratio   := l_securedratio + l_feesecureratiomin;
                           ELSE
                              l_securedratio   := l_securedratio + l_feerate;
                           END IF;
                    END IF;
                END;
                -- End: TheNN modified, 15-Feb-2012

               l_txmsg.txfields ('13').VALUE     := l_securedratio;

               IF (  TO_NUMBER (l_build_msg.fld12)
                   * TO_NUMBER (l_build_msg.fld11)
                   * l_securedratio
                   / 100
                   -   TO_NUMBER (l_build_msg.refprice)
                     * TO_NUMBER (l_build_msg.refquantity)
                     * l_securedratio
                     / 100 > 0)
               THEN
                  l_txmsg.txfields ('18').VALUE   :=
                       TO_NUMBER (l_build_msg.fld12)
                     * TO_NUMBER (l_build_msg.fld11)
                     * l_securedratio
                     / 100
                     -   TO_NUMBER (l_build_msg.refprice)
                       * TO_NUMBER (l_build_msg.refquantity)
                       * l_securedratio
                       / 100;
               ELSE
                  l_txmsg.txfields ('18').VALUE   := '0'; --AdvanceSecuredAmount
               END IF;

               --2.2 Set txtime
               l_txmsg.txtime                    :=
                  TO_CHAR (SYSDATE, systemnums.c_time_format);

               l_txmsg.chktime                   := l_txmsg.txtime;
               l_txmsg.offtime                   := l_txmsg.txtime;

               --2.3 Set txdate
               SELECT TO_DATE (varvalue, systemnums.c_date_format)
               INTO l_txmsg.txdate
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

               l_txmsg.brdate                    := l_txmsg.txdate;
               l_txmsg.busdate                   := l_txmsg.txdate;

               --2.4 Set fld value
               l_txmsg.txfields ('01').defname   := 'CODEID';
               l_txmsg.txfields ('01').TYPE      := 'C';
               l_txmsg.txfields ('01').VALUE     := l_build_msg.fld01; --set vale for CODEID

               l_txmsg.txfields ('07').defname   := 'SYMBOL';
               l_txmsg.txfields ('07').TYPE      := 'C';
               l_txmsg.txfields ('07').VALUE     := l_build_msg.fld07; --set vale for Symbol



               l_txmsg.txfields ('60').defname   := 'ISMORTAGE';
               l_txmsg.txfields ('60').TYPE      := 'N';
               l_txmsg.txfields ('60').VALUE     := l_ismortage; --set vale for Is mortage sell
               l_txmsg.txfields ('02').defname   := 'ACTYPE';
               l_txmsg.txfields ('02').TYPE      := 'C';
               -- l_txmsg.txfields ('02').VALUE     := l_build_msg.fld02; --set vale for Product code
               -- this is set above
               l_txmsg.txfields ('03').defname   := 'AFACCTNO';
               l_txmsg.txfields ('03').TYPE      := 'C';
               l_txmsg.txfields ('03').VALUE     := l_build_msg.fld03; --set vale for Contract number
               l_txmsg.txfields ('06').defname   := 'SEACCTNO';
               l_txmsg.txfields ('06').TYPE      := 'C';
               l_txmsg.txfields ('06').VALUE     := l_build_msg.fld06; --set vale for SE account number

               l_txmsg.txfields ('50').defname   := 'CUSTNAME';
               l_txmsg.txfields ('50').TYPE      := 'C';
               l_txmsg.txfields ('50').VALUE     := l_build_msg.username; --set vale for Customer name
               /*if p_timetype <> 'G' then
                   l_txmsg.txfields ('50').VALUE     := l_build_msg.username; --set vale for Customer name
               else
                   l_txmsg.txfields ('50').VALUE     := l_build_msg.acctno; --set vale for Customer name
               end if;*/
               -- this was set above already
               l_txmsg.txfields ('20').defname   := 'TIMETYPE';
               l_txmsg.txfields ('20').TYPE      := 'C';
               l_txmsg.txfields ('20').VALUE     := l_build_msg.fld20; --set vale for Duration
               l_txmsg.txfields ('21').defname   := 'EXPDATE';
               l_txmsg.txfields ('21').TYPE      := 'D';
               l_txmsg.txfields ('21').VALUE     := l_build_msg.fld21; --set vale for Expired date
               l_txmsg.txfields ('19').defname   := 'EFFDATE';
               l_txmsg.txfields ('19').TYPE      := 'D';
               l_txmsg.txfields ('19').VALUE     := l_build_msg.fld19; --set vale for Expired date
               l_txmsg.txfields ('22').defname   := 'EXECTYPE';
               l_txmsg.txfields ('22').TYPE      := 'C';
               l_txmsg.txfields ('22').VALUE     := l_build_msg.fld22; --set vale for Execution type
               l_txmsg.txfields ('23').defname   := 'NORK';
               l_txmsg.txfields ('23').TYPE      := 'C';
               l_txmsg.txfields ('23').VALUE     := l_build_msg.fld23; --set vale for All or none?
               l_txmsg.txfields ('34').defname   := 'OUTPRICEALLOW';
               l_txmsg.txfields ('34').TYPE      := 'C';
               l_txmsg.txfields ('34').VALUE     := l_build_msg.fld34; --set vale for Accept out amplitute price
               l_txmsg.txfields ('24').defname   := 'MATCHTYPE';
               l_txmsg.txfields ('24').TYPE      := 'C';
               l_txmsg.txfields ('24').VALUE     := l_build_msg.fld24; --set vale for Matching type
               l_txmsg.txfields ('25').defname   := 'VIA';
               l_txmsg.txfields ('25').TYPE      := 'C';
               l_txmsg.txfields ('25').VALUE     := l_build_msg.fld25; --set vale for Via
               l_txmsg.txfields ('10').defname   := 'CLEARDAY';
               l_txmsg.txfields ('10').TYPE      := 'N';
               l_txmsg.txfields ('10').VALUE     := l_build_msg.fld10; --set vale for Clearing day
               l_txmsg.txfields ('26').defname   := 'CLEARCD';
               l_txmsg.txfields ('26').TYPE      := 'C';
               l_txmsg.txfields ('26').VALUE     := l_build_msg.fld26; --set vale for Calendar
               l_txmsg.txfields ('72').defname   := 'PUTTYPE';
               l_txmsg.txfields ('72').TYPE      := 'C';
               l_txmsg.txfields ('72').VALUE     := l_build_msg.fld72; --set vale for Puthought type
               l_txmsg.txfields ('27').defname   := 'PRICETYPE';
               l_txmsg.txfields ('27').TYPE      := 'C';
               l_txmsg.txfields ('27').VALUE     := l_build_msg.fld27; --set vale for Price type

               l_txmsg.txfields ('11').defname   := 'QUOTEPRICE';
               l_txmsg.txfields ('11').TYPE      := 'N';
               l_txmsg.txfields ('11').VALUE     := l_build_msg.fld11; --set vale for Limit price

               l_txmsg.txfields ('80').defname   := 'QUOTEQTTY';
               l_txmsg.txfields ('80').TYPE      := 'N';
               l_txmsg.txfields ('80').VALUE     := 0; --set vale for Limit price

               l_txmsg.txfields ('81').defname   := 'ORGQUOTEQTTY';
               l_txmsg.txfields ('81').TYPE      := 'N';
               l_txmsg.txfields ('81').VALUE     := 0; --set vale for Limit price

               l_txmsg.txfields ('82').defname   := 'ORGLIMITPRICE';
               l_txmsg.txfields ('82').TYPE      := 'N';
               l_txmsg.txfields ('82').VALUE     := 0; --set vale for Limit price

               l_txmsg.txfields ('90').defname   := 'TRADESTATUS';
               l_txmsg.txfields ('90').TYPE      := 'N';
               l_txmsg.txfields ('90').VALUE     := 0;
               IF l_build_msg.fld22 IN ('NS', 'MS', 'SS') THEN --gc_OD_PLACENORMALSELLORDER_ADVANCED
                   --HaiLT them cho GRPORDER
                   l_txmsg.txfields ('55').defname   := 'GRPORDER';
                   l_txmsg.txfields ('55').TYPE      := 'C';
                   l_txmsg.txfields ('55').VALUE     := 'N';
               END IF;

               IF l_build_msg.fld27 <> 'LO'
               THEN                                               -- Pricetype
                  IF l_strEXECTYPE='NB' --l_build_msg.fld22 = 'NB'
                  THEN                                             -- exectype
                     l_txmsg.txfields ('11').VALUE   :=
                        l_build_msg.ceilingprice
                        / l_build_msg.fld98;                --tradeunit
                  ELSE
                     l_txmsg.txfields ('11').VALUE   :=
                        l_build_msg.floorprice
                        / l_build_msg.fld98;
                  END IF;
               END IF;

               l_txmsg.txfields ('12').defname   := 'ORDERQTTY';
               l_txmsg.txfields ('12').TYPE      := 'N';
               l_txmsg.txfields ('12').VALUE     := l_build_msg.fld12; --set vale for Quantity
               l_txmsg.txfields ('13').defname   := 'BRATIO';
               l_txmsg.txfields ('13').TYPE      := 'N';
               --l_txmsg.txfields ('13').VALUE     := l_build_msg.fld13; --set vale for Block ration
               l_txmsg.txfields ('80').defname   := 'QUOTEQTTY';
               l_txmsg.txfields ('80').TYPE      := 'N';
               l_txmsg.txfields ('80').VALUE   := l_build_msg.fld80;
               l_txmsg.txfields ('14').defname   := 'LIMITPRICE';
               l_txmsg.txfields ('14').TYPE      := 'N';
               l_txmsg.txfields ('14').VALUE     := l_build_msg.fld14; --set vale for Stop price
               l_txmsg.txfields ('40').defname   := 'FEEAMT';
               l_txmsg.txfields ('40').TYPE      := 'N';
               --l_txmsg.txfields ('40').VALUE     := l_build_msg.fld40; --set vale for Fee amount
               l_txmsg.txfields ('28').defname   := 'VOUCHER';
               l_txmsg.txfields ('28').TYPE      := 'C';
               l_txmsg.txfields ('28').VALUE     := ''; --l_build_msg.fld28; --set vale for Voucher status
               l_txmsg.txfields ('29').defname   := 'CONSULTANT';
               l_txmsg.txfields ('29').TYPE      := 'C';
               l_txmsg.txfields ('29').VALUE     := ''; --l_build_msg.fld29; --set vale for Consultant status
               l_txmsg.txfields ('04').defname   := 'ORDERID';
               l_txmsg.txfields ('04').TYPE      := 'C';
               --l_txmsg.txfields ('04').VALUE     := l_build_msg.fld04; --set vale for Order ID
               --this is set below
               l_txmsg.txfields ('15').defname   := 'PARVALUE';
               l_txmsg.txfields ('15').TYPE      := 'N';
               l_txmsg.txfields ('15').VALUE     := l_build_msg.fld15; --set vale for Parvalue

               l_txmsg.txfields ('30').defname   := 'DESC';
               l_txmsg.txfields ('30').TYPE      := 'C';
               l_txmsg.txfields ('30').VALUE     := l_build_msg.fld30; --set vale for Description

               l_txmsg.txfields ('31').defname   := 'CONTRAFIRM';
               l_txmsg.txfields ('31').TYPE      := 'C';
               l_txmsg.txfields ('31').VALUE     := l_build_msg.fld31; --set vale for Description

               l_txmsg.txfields ('32').defname   := 'TRADERID';
               l_txmsg.txfields ('32').TYPE      := 'C';
               l_txmsg.txfields ('32').VALUE     := l_build_msg.fld32; --set vale for Description

               l_txmsg.txfields ('33').defname   := 'CLIENTID';
               l_txmsg.txfields ('33').TYPE      := 'C';
               l_txmsg.txfields ('33').VALUE     := l_build_msg.fld33; --set vale for Description

               l_txmsg.txfields ('95').defname   := 'DFACCTNO';
               l_txmsg.txfields ('95').TYPE      := 'C';
               l_txmsg.txfields ('95').VALUE     := l_build_msg.fld95; --set vale for deal id

               l_txmsg.txfields ('94').defname   := 'SSAFACCTNO';
               l_txmsg.txfields ('94').TYPE      := 'C';
               l_txmsg.txfields ('94').VALUE     := l_build_msg.fld94; --set vale for short sale account

               l_txmsg.txfields ('90').defname   := 'TRADESTATUS';
               l_txmsg.txfields ('90').TYPE      := 'N';
               l_txmsg.txfields ('90').VALUE     := 0;

               l_txmsg.txfields ('90').defname   := 'TRADESTATUS';
               l_txmsg.txfields ('90').TYPE      := 'N';
               l_txmsg.txfields ('90').VALUE     := 0;
               l_txmsg.txfields ('99').defname   := 'HUNDRED';
               l_txmsg.txfields ('99').TYPE      := 'N';
               If l_strMarginType = 'N' Then
                    l_txmsg.txfields ('99').VALUE     := l_build_msg.fld99;
               Else
                    If l_dblIsPPUsed = 1 Then
                        l_txmsg.txfields ('99').VALUE     := to_char(100 / (1 - l_dblMarginRatioRate / 100 * l_dblSecMarginPrice / l_build_msg.fld11 / l_build_msg.fld98));
                    Else
                        l_txmsg.txfields ('99').VALUE     := l_build_msg.fld99;
                    End If;
               End If;

               l_txmsg.txfields ('98').defname   := 'TRADEUNIT';
               l_txmsg.txfields ('98').TYPE      := 'N';
               l_txmsg.txfields ('98').VALUE     := l_build_msg.fld98; --set vale for Trade unit

               l_txmsg.txfields ('96').defname   := 'TRADEUNIT';
               l_txmsg.txfields ('96').TYPE      := 'N';
               l_txmsg.txfields ('96').VALUE     := 1; --l_build_msg.fld96; --set vale for GTC

               l_txmsg.txfields ('97').defname   := 'MODE';
               l_txmsg.txfields ('97').TYPE      := 'C';
               l_txmsg.txfields ('97').VALUE     := l_build_msg.fld97; --set vale for MODE DAT LENH
               l_txmsg.txfields ('33').defname   := 'CLIENTID';
               l_txmsg.txfields ('33').TYPE      := 'C';
               l_txmsg.txfields ('33').VALUE     := l_build_msg.fld33; --set vale for ClientID
               l_txmsg.txfields ('73').defname   := 'CONTRAFIRM';
               l_txmsg.txfields ('73').TYPE      := 'C';
               l_txmsg.txfields ('73').VALUE     := l_build_msg.fld73; --set vale for Contrafirm
               l_txmsg.txfields ('32').defname   := 'TRADERID';
               l_txmsg.txfields ('32').TYPE      := 'C';
               l_txmsg.txfields ('32').VALUE     := l_build_msg.fld32; --set vale for TraderID
               l_txmsg.txfields ('71').defname   := 'CONTRACUS';
               l_txmsg.txfields ('71').TYPE      := 'C';
               l_txmsg.txfields ('71').VALUE     := ''; --l_build_msg.fld71; --set vale for Contra custody
               l_txmsg.txfields ('74').defname   := 'ISDISPOSAL';
               l_txmsg.txfields ('74').TYPE      := 'C';
               l_txmsg.txfields ('74').VALUE     := l_build_msg.ISDISPOSAL;
               l_txmsg.txfields ('31').defname   := 'CONTRAFIRM';
               l_txmsg.txfields ('31').TYPE      := 'C';
               l_txmsg.txfields ('31').VALUE     := l_build_msg.fld31; --set vale for Contrafirm

               l_txmsg.txfields ('90').defname   := 'TRADESTATUS';
               l_txmsg.txfields ('90').TYPE      := 'N';
               l_txmsg.txfields ('90').VALUE     := 0;
               IF l_build_msg.fld22 = 'AB' or l_build_msg.fld22 = 'AS'     then
                   l_txmsg.txfields ('16').defname   := 'ORGORDERQTTY';
                   l_txmsg.txfields ('16').TYPE      := 'N';
                   l_txmsg.txfields ('16').VALUE     := 0;
                   l_txmsg.txfields ('17').defname   := 'ORGQUOTEPRICE';
                   l_txmsg.txfields ('17').TYPE      := 'N';
                   l_txmsg.txfields ('17').VALUE     := 0;
               end if;

               l_remainqtty                      :=
                  l_txmsg.txfields ('12').VALUE;

               l_txmsg.txfields ('08').VALUE     :=
                  l_build_msg.orgacctno;

               l_order_count                     := 0;         --RESET COUNTER

               --plog.debug (pkgctx, 'l_remainqtty: ' || l_remainqtty);
              /* if l_build_msg.SPLOPT='Q' then --Tach theo so lenh
                        l_breakingsize:= l_build_msg.SPLVAL;
               elsif l_build_msg.SPLOPT='O' then
                        l_breakingsize:= round(l_remainqtty/to_number(l_build_msg.SPLVAL) +
                                                case when l_build_msg.tradeplace='001' then 5-0.01
                                                     when l_build_msg.tradeplace='002' then 50-0.01
                                                     else 0.5-0.01 end,
                                                case when l_build_msg.tradeplace='001' then -1
                                                     when l_build_msg.tradeplace='002' then -2
                                                     else 0 end);
               else
                        l_breakingsize:= l_remainqtty;
               end if;
               IF l_build_msg.tradeplace = '001' then
                    --Neu san HSX thi xe toi da theo l_hosebreakingsize
                    if l_breakingsize > l_hosebreakingsize then
                        l_breakingsize:=l_hosebreakingsize;
                    else
                        l_breakingsize:=l_breakingsize;
                    end if;
               ELSIF l_build_msg.tradeplace in( '002','005') then
                    --Neu san HNX thi xe toi da theo l_hasebreakingsize
                    if l_breakingsize > l_hasebreakingsize then
                        l_breakingsize:=l_hasebreakingsize;
                    else
                        l_breakingsize:=l_breakingsize;
                    end if;
               end if;*/


               l_breakingsize:=100000000; --FO khong chia lenh o day.
               WHILE l_remainqtty > 0                               --quantity
               LOOP
                  SAVEPOINT sp#2;
                  l_order_count   := l_order_count + 1;

                  l_txmsg.txfields ('12').VALUE   :=
                        CASE
                           WHEN l_remainqtty > l_breakingsize
                           THEN
                              l_breakingsize
                           ELSE
                              l_remainqtty
                        END;
                  -- SET FEE AMOUNT
                  l_txmsg.txfields ('40').VALUE     :=
                    greatest(l_feerate/100 * TO_NUMBER (l_txmsg.txfields('12').VALUE)         --quantity
                     * TO_NUMBER (l_build_msg.fld11)       --quoteprice
                     * TO_NUMBER (l_build_msg.fld98),l_feeamountmin);

                  --2.1 Set txnum
                  SELECT systemnums.c_fo_prefixed
                         || LPAD (seq_fotxnum.NEXTVAL, 8, '0')
                  INTO l_txmsg.txnum
                  FROM DUAL;

                  SELECT    systemnums.c_fo_prefixed
                         || '00'
                         || TO_CHAR(TO_DATE (VARVALUE, 'DD\MM\RR'),'DDMMRR')
                         || LPAD (seq_odmast.NEXTVAL, 6, '0')
                  INTO l_txmsg.txfields ('04').VALUE
                  FROM SYSVAR WHERE VARNAME ='CURRDATE' AND GRNAME='SYSTEM';



                  SELECT REGEXP_REPLACE (l_txmsg.txfields ('04').VALUE,
                                         '(^[[:digit:]]{4})([[:digit:]]{2})([[:digit:]]{10}$)',
                                         '\1.\2.\3.'
                         )
                         || l_fullname
                         || '.'
                         || l_txmsg.txfields ('24').VALUE          --MATCHTYPE
                         || l_txmsg.txfields ('22').VALUE       ---ORGEXECTYPE
                         || '.'
                         || l_txmsg.txfields ('07').VALUE             --SYMBOL
                         || '.'
                         || l_txmsg.txfields ('12').VALUE
                         || '.'
                         || l_txmsg.txfields ('11').VALUE         --QUOTEPRICE
                  INTO l_txmsg.txfields ('30').VALUE
                  FROM DUAL;





                  INSERT INTO rootordermap
                 (
                     foacctno,
                     orderid,
                     status,
                     MESSAGE,
                     id
                 )
                  VALUES (
                            l_build_msg.acctno,
                            l_txmsg.txfields ('04').VALUE,
                            'A',
                            '[' || systemnums.c_success || '] OK,',
                            l_order_count
                         );

                  plog.error (pkgctx,
                                          'p_err_code: '
                                       || p_err_code
                           );

                  plog.debug (pkgctx,
                                          ' l_txmsg.txfields (22).VALUE : '||  l_txmsg.txfields ('22').VALUE );

                  -- Get tltxcd from EXECTYPE
                  IF l_txmsg.txfields ('22').VALUE = 'NB'               --8876
                  THEN
                     BEGIN
                        l_txmsg.tltxcd   := '8876'; -- gc_OD_PLACENORMALBUYORDER_ADVANCED
                        -- 2: Process
                        IF newfo_api.fn_txAppUpdate8876(l_txmsg ,p_err_code) <> systemnums.c_success
                        THEN
                           plog.debug (pkgctx,
                                       'got error 8876: ' || p_err_code
                           );
                           --ONLY ROLLBACK FOR THIS MESSAGE
                           ROLLBACK TO SAVEPOINT sp#2;


                           --EXIT; -- UNCOMMENT THIS IF YOU WANT TO EXIT LOOP WHEN GOT AN ERROR
                           RAISE errnums.e_biz_rule_invalid;
                        ELSE
                            p_err_code := '0';
                        END IF;

                     END;                                               --8876
                  ELSIF l_build_msg.fld22 IN ('NS', 'MS', 'SS')  --8877
                  THEN
                     BEGIN
                        l_txmsg.tltxcd   := '8877'; --gc_OD_PLACENORMALSELLORDER_ADVANCED

                        -- 2: Process
                        /*IF fn_txAppAutoUpdate8877 (l_txmsg,p_err_code) <> systemnums.c_success*/
                        IF newfo_api.fn_txAppAutoUpdate8877 (l_txmsg,p_err_code) <> systemnums.c_success
                        THEN
                           plog.error (pkgctx,
                                          '8877: '
                                       || p_err_code
                                       || ':'
                                       || l_err_param
                           );
                           --ONLY ROLLBACK FOR THIS MESSAGE
                           ROLLBACK TO SAVEPOINT sp#2;
                           --EXIT; -- UNCOMMENT THIS IF YOU WANT TO EXIT LOOP WHEN GOT AN ERROR
                           RAISE errnums.e_biz_rule_invalid;
                        ELSE
                            p_err_code := '0';
                        END IF;

                        plog.debug (pkgctx,
                                          'aft 8877: '
                           );
                     END;                                              -- 8887
                  ELSIF l_build_msg.fld22 = 'AB'                 --8884
                  THEN
                     BEGIN
                        plog.error (pkgctx,
                                          'newfo_api.pr_fo2odsyn l_txmsg.txfields (22).VALUE: '
                                       || l_txmsg.txfields ('22').VALUE
                           );
                        l_txmsg.tltxcd   := '8884';  --gc_OD_AMENDMENTBUYORDER

                        -- 2: Process
                        plog.debug (pkgctx,
                                          ' l_txmsg.tltxcd : '||  l_txmsg.tltxcd );
                        --IF fn_txAppUpdate8884 (l_txmsg, p_bo_orderid, p_err_code) <> systemnums.c_success
                        IF newfo_api.fn_txAppUpdate8884 (l_txmsg,p_bo_orderid,p_err_code) <> systemnums.c_success
                        THEN
                           plog.error (pkgctx,
                                       'got error 8884: ' || p_err_code
                           );
                           --ONLY ROLLBACK FOR THIS MESSAGE
                           ROLLBACK TO SAVEPOINT sp#2;

                           --EXIT; -- UNCOMMENT THIS IF YOU WANT TO EXIT LOOP WHEN GOT AN ERROR
                           RAISE errnums.e_biz_rule_invalid;
                       ELSE
                            p_err_code := '0';

                            plog.error (pkgctx,
                                       'got error 8884: ' || p_err_code
                           );
                        END IF;
                     END;                                               --8884
                  ELSIF l_build_msg.fld22 = 'AS'                 --8885
                  THEN
                     BEGIN
                        l_txmsg.tltxcd   := '8885'; --gc_OD_AMENDMENTSELLORDER

                        -- 2: Process
                        --IF fn_txAppUpdate8885 (l_txmsg,p_err_code) <> systemnums.c_success
                        IF newfo_api.fn_txAppUpdate8885 (l_txmsg,p_err_code) <> systemnums.c_success
                        THEN
                           plog.debug (pkgctx,
                                       'got error 8885: ' || p_err_code
                           );
                           --ONLY ROLLBACK FOR THIS MESSAGE
                           ROLLBACK TO SAVEPOINT sp#2;
                           --EXIT; -- UNCOMMENT THIS IF YOU WANT TO EXIT LOOP WHEN GOT AN ERROR
                           RAISE errnums.e_biz_rule_invalid;
                       ELSE
                            p_err_code := '0';
                        END IF;
                     END;                                               --8885
                  ELSIF l_build_msg.fld22 = 'CB'                 --8882
                  THEN
                     BEGIN
                        l_txmsg.tltxcd   := '8882';     --gc_OD_CANCELBUYORDER

                        -- 2: Process
                        IF newfo_api.fn_txAppUpdate8882 (l_txmsg,p_err_code) <> systemnums.c_success
                        --IF newfo_api.fn_txAppUpdate8876 (l_txmsg,p_err_code) <> systemnums.c_success
                        THEN
                           plog.error (pkgctx,
                                       'got error 8882: ' || p_err_code
                           );
                           --ONLY ROLLBACK FOR THIS MESSAGE
                           ROLLBACK TO SAVEPOINT sp#2;
                           --EXIT; -- UNCOMMENT THIS IF YOU WANT TO EXIT LOOP WHEN GOT AN ERROR
                           RAISE errnums.e_biz_rule_invalid;
                        ELSE
                            p_err_code := '0';
                        END IF;
                     END;                                               --8882
                  ELSIF l_build_msg.fld22 = 'CS'                 --8883
                  THEN
                     BEGIN
                        l_txmsg.tltxcd   := '8883';    --gc_OD_CANCELSELLORDER

                        plog.error (pkgctx,
                                       'got error 8883: ' || p_err_code
                           );

                        -- 2: Process
                        IF fn_txAppUpdate8883(l_txmsg,p_err_code) <> systemnums.c_success
                        --IF newfo_api.fn_txAppUpdate8876 (l_txmsg,p_err_code) <> systemnums.c_success
                        THEN
                           plog.error (pkgctx,
                                       'got error 8883: ' || p_err_code
                           );
                           --ONLY ROLLBACK FOR THIS MESSAGE
                           ROLLBACK TO SAVEPOINT sp#2;
                           --EXIT; -- UNCOMMENT THIS IF YOU WANT TO EXIT LOOP WHEN GOT AN ERROR
                           RAISE errnums.e_biz_rule_invalid;
                        ELSE
                            p_err_code := '0';
                        END IF;

                         plog.error (pkgctx,
                                       'after got error 8883: ' || p_err_code
                           );

                     END;
                  END IF;
                  plog.error (pkgctx, 'update fomast'|| p_fo_orderid );
                  -- Thucnt: Insert v?bang map orderId
                  SELECT  Count(*) INTO  v_count FROM  newfo_ordermap
                   WHERE  foorderid = p_fo_orderid And txdate = l_txmsg.txdate;
                    plog.error (pkgctx, 'update fomast v_count'|| v_count );
                    plog.error (pkgctx, v_count || ';' || p_fo_orderid || ';' || l_txmsg.txfields ('04').VALUE);
                  IF  v_count = 0
                  THEN
                    plog.error (pkgctx, 'update fomast newfo_ordermap before ins p_fo_orderid'|| p_fo_orderid ||' 04 '||l_txmsg.txfields ('04').VALUE);

                    INSERT  INTO  newfo_ordermap(foorderid, boorderid,txdate) values (p_fo_orderid, l_txmsg.txfields ('04').VALUE, l_txmsg.txdate);
                    plog.error (pkgctx, 'update fomast newfo_ordermap aft ins p_fo_orderid'|| p_fo_orderid );
                  ELSE
                    p_err_code:=errnums.C_OD_ERROR_ORDER_MATCHED;
                    plog.error (pkgctx,
                                       'fo_orderid Matched: ' || p_err_code
                           );
                           ROLLBACK TO SAVEPOINT sp#2;
                     RAISE errnums.e_biz_rule_invalid;
                  END  IF;
                  -- Ket thuc them vao bang map Orderid


                  UPDATE fomast
                  SET orgacctno    = l_txmsg.txfields ('04').VALUE,
                      status       = 'A',
                      feedbackmsg   =
                         'Order is active and sucessfull processed: '
                         || l_txmsg.txfields ('04').VALUE
                  WHERE acctno = l_build_msg.acctno;

                  l_remainqtty    :=
                     l_remainqtty - TO_NUMBER (l_txmsg.txfields ('12').VALUE);
                  plog.debug (pkgctx,
                                 'l_remainqtty('
                              || l_order_count
                              || '):'
                              || l_remainqtty
                  );

                  -- COMMIT IN CASE OF ORDER BREAKING
                  IF l_count >= l_commit_freq
                  THEN
                     l_count   := 0;          -- reset the commit freq counter
                     COMMIT;
                  END IF;
               END LOOP;

               IF l_count >= l_commit_freq
               THEN
                  l_count   := 0;             -- reset the commit freq counter
                  COMMIT;
               END IF;
            EXCEPTION
               WHEN errnums.e_od_odtype_notfound
               THEN
                  plog.error (pkgctx,
                                 'row: '||p_err_code
                              || dbms_utility.format_error_backtrace
                  );
                  p_err_code:=errnums.c_od_odtype_notfound;
                  UPDATE fomast
                  SET status    = 'R',
                             feedbackmsg   =
                                '[' || errnums.c_od_odtype_notfound || '] '
                                || cspks_system.fn_get_errmsg(errnums.c_od_odtype_notfound)
                  WHERE acctno = l_build_msg.acctno;
               WHEN errnums.e_invalid_session
               THEN
                  -- Log error and continue to process the next order
                  plog.error (pkgctx,
                                 'INVALID SESSION(pricetype,mktstatus):'
                              || l_build_msg.fld27
                              || ','
                              || l_mktstatus
                  );
                  p_err_code:=errnums.c_invalid_session;
                  UPDATE fomast
                  SET status    = 'R',
                      feedbackmsg   =
                         '[' || errnums.c_invalid_session || '] '
                         || cspks_system.fn_get_errmsg(errnums.c_invalid_session)
                  WHERE acctno = l_build_msg.acctno;
               --LogOrderMessage(v_ds.Tables(0).Rows(i)("ACCTNO"))

            END;
      END LOOP;
      COMMIT;                                -- Commit the last trunk (if any)
      /***************************************************************************************************
      ** END;
      ***************************************************************************************************/
      --plog.debug (pkgctx, '<<END OF pr_fo2odsyn');
      plog.setendsection (pkgctx, 'pr_fo2odsyn');
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         plog.debug (pkgctx,
                                          'err aft : '||sqlerrm
                           );
         plog.error (pkgctx, dbms_utility.format_error_backtrace);

         plog.setendsection (pkgctx, 'pr_fo2odsyn');
   END pr_fo2odsyn;

FUNCTION fn_txAppUpdate8876(p_txmsg in tx.msg_rectype,p_err_code in out varchar2)
RETURN NUMBER
IS
BEGIN
   plog.setbeginsection (pkgctx, 'fn_txAppUpdate8876');

   IF txpks_#8876EX.fn_txAftAppUpdate(p_txmsg,p_err_code) <> systemnums.C_SUCCESS THEN
       plog.setendsection (pkgctx, 'fn_txAppUpdate8876');
       RETURN errnums.C_BIZ_RULE_INVALID;
   END IF;
   --plog.debug (pkgctx, 'Begin of updating pool and room');
   IF txpks_prchk.fn_txAutoUpdate(p_txmsg, p_err_code) <> systemnums.C_SUCCESS THEN
       plog.setendsection (pkgctx, 'fn_txAppUpdate8876');
        Return errnums.C_BIZ_RULE_INVALID;
   END IF;
   pr_txlog8876(p_txmsg,p_err_code);
   --plog.debug (pkgctx, 'End of updating pool and room');
   plog.setendsection (pkgctx, 'fn_txAppUpdate8876');
   RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'fn_txAppUpdate8876');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAppUpdate8876;

FUNCTION fn_txAppAutoUpdate8877(p_txmsg in tx.msg_rectype,p_err_code in out varchar2)
RETURN  NUMBER
IS
l_txdesc VARCHAR2(1000);
BEGIN
   plog.setbeginsection (pkgctx, 'fn_txAppAutoUpdate8877');
      plog.debug (pkgctx, '8877');
    IF txpks_#8877EX.fn_txAftAppUpdate(p_txmsg,p_err_code) <> systemnums.C_SUCCESS THEN
             --plog.debug (pkgctx, 'err 8877');
       plog.setendsection (pkgctx, 'fn_txAppAutoUpdate8877');
       RETURN errnums.C_BIZ_RULE_INVALID;
   END IF;

   IF txpks_prchk.fn_txAutoUpdate(p_txmsg, p_err_code) <> systemnums.C_SUCCESS THEN
       plog.setendsection (pkgctx, 'fn_txAutoUpdate');
        Return errnums.C_BIZ_RULE_INVALID;
   END IF;

   pr_txlog8877(p_txmsg,p_err_code);
   --plog.debug (pkgctx, 'success 8877');
   plog.setendsection (pkgctx, 'fn_txAppAutoUpdate8877');
   RETURN systemnums.C_SUCCESS;
EXCEPTION
  WHEN others THEN
       p_err_code := errnums.C_SYSTEM_ERROR;
          --plog.debug (pkgctx, 'excep 8877');
      -- plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
       plog.setendsection (pkgctx, 'fn_txAppAutoUpdate8877');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAppAutoUpdate8877;

FUNCTION fn_txAppUpdate8884(p_txmsg in tx.msg_rectype, p_bo_orderid varchar2,p_err_code in out varchar2)
RETURN NUMBER
IS
BEGIN
   plog.setbeginsection (pkgctx, 'fn_txAppUpdate');
-- Run Pre Update
  /* IF txpks_#8884EX.fn_txPreAppUpdate(p_txmsg,p_err_code) <> systemnums.C_SUCCESS THEN
       RETURN errnums.C_BIZ_RULE_INVALID;
   END IF;*/
-- Run After Update
plog.error (pkgctx, 'newfo_api.fn_txAppUpdate8884: p_bo_orderid' || p_bo_orderid);

   IF newfo_api.fn_txAftAppUpdate8884EX(p_txmsg, p_bo_orderid,p_err_code) <> systemnums.C_SUCCESS THEN
        plog.error (pkgctx, 'newfo_api.fn_txAppUpdate8884 ' || p_err_code);
       RETURN errnums.C_BIZ_RULE_INVALID;
   END IF;
   --plog.debug (pkgctx, 'Begin of updating pool and room');
   IF txpks_prchk.fn_txAutoUpdate(p_txmsg, p_err_code) <> systemnums.C_SUCCESS THEN
       plog.setendsection (pkgctx, 'fn_txAppUpdate');
        Return errnums.C_BIZ_RULE_INVALID;
   END IF;
   --plog.debug (pkgctx, 'End of updating pool and room');
   pr_txlog8884(p_txmsg,p_err_code);
   plog.setendsection (pkgctx, 'fn_txAppUpdate');
   RETURN systemnums.C_SUCCESS;

EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'fn_txAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAppUpdate8884;

FUNCTION fn_txAppUpdate8885(p_txmsg in tx.msg_rectype,p_err_code in out varchar2)
RETURN NUMBER
IS
BEGIN
   plog.setbeginsection (pkgctx, 'fn_txAppUpdate');
-- Run Pre Update
   IF txpks_#8885EX.fn_txPreAppUpdate(p_txmsg,p_err_code) <> systemnums.C_SUCCESS THEN
       RETURN errnums.C_BIZ_RULE_INVALID;
   END IF;

-- Run After Update
   IF txpks_#8885EX.fn_txAftAppUpdate(p_txmsg,p_err_code) <> systemnums.C_SUCCESS THEN
       RETURN errnums.C_BIZ_RULE_INVALID;
   END IF;
   --plog.debug (pkgctx, 'Begin of updating pool and room');
   IF txpks_prchk.fn_txAutoUpdate(p_txmsg, p_err_code) <> systemnums.C_SUCCESS THEN
       plog.setendsection (pkgctx, 'fn_txAppUpdate');
        Return errnums.C_BIZ_RULE_INVALID;
   END IF;
   --plog.debug (pkgctx, 'End of updating pool and room');
   pr_txlog8885(p_txmsg,p_err_code);
   plog.setendsection (pkgctx, 'fn_txAppUpdate');
   RETURN systemnums.C_SUCCESS;

EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'fn_txAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAppUpdate8885;

FUNCTION fn_txAppUpdate8882(p_txmsg in tx.msg_rectype,p_err_code in out varchar2)
RETURN NUMBER
IS
BEGIN
   plog.setbeginsection (pkgctx, 'fn_txAppUpdate');
-- Run Pre Update
   IF txpks_#8882EX.fn_txPreAppUpdate(p_txmsg,p_err_code) <> systemnums.C_SUCCESS THEN
       RETURN errnums.C_BIZ_RULE_INVALID;
   END IF;
-- Run Auto Update
   IF fn_txAppAutoUpdate8882(p_txmsg,p_err_code) <> systemnums.C_SUCCESS THEN
       RETURN errnums.C_BIZ_RULE_INVALID;
   END IF;
-- Run After Update
   IF txpks_#8882EX.fn_txAftAppUpdate(p_txmsg,p_err_code) <> systemnums.C_SUCCESS THEN
       RETURN errnums.C_BIZ_RULE_INVALID;
   END IF;
   --plog.debug (pkgctx, 'Begin of updating pool and room');
   IF txpks_prchk.fn_txAutoUpdate(p_txmsg, p_err_code) <> systemnums.C_SUCCESS THEN
       plog.setendsection (pkgctx, 'fn_txAppUpdate');
        Return errnums.C_BIZ_RULE_INVALID;
   END IF;
     pr_txlog8882(p_txmsg,p_err_code);
   --plog.debug (pkgctx, 'End of updating pool and room');
   RETURN systemnums.C_SUCCESS;
   plog.setendsection (pkgctx, 'fn_txAppUpdate');
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'fn_txAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAppUpdate8882;

FUNCTION fn_txAppAutoUpdate8882(p_txmsg in tx.msg_rectype,p_err_code in out varchar2)
RETURN  NUMBER
IS
l_txdesc VARCHAR2(1000);
BEGIN

   IF p_txmsg.deltd = 'Y' THEN -- Reversal transaction
UPDATE TLLOG
 SET DELTD = 'Y'
      WHERE TXNUM = p_txmsg.txnum AND TXDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT);

      UPDATE CIMAST
      SET
           LASTDATE=TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT), LAST_CHANGE = SYSTIMESTAMP
        WHERE ACCTNO=p_txmsg.txfields('03').value;

   END IF;
   RETURN systemnums.C_SUCCESS ;
EXCEPTION
  WHEN others THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
       plog.setendsection (pkgctx, 'fn_txAppAutoUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAppAutoUpdate8882;

FUNCTION fn_txAppUpdate8883(p_txmsg in tx.msg_rectype,p_err_code in out varchar2)
RETURN NUMBER
IS
BEGIN
   plog.setbeginsection (pkgctx, 'fn_txAppUpdate');
-- Run Pre Update
   IF txpks_#8883EX.fn_txPreAppUpdate(p_txmsg,p_err_code) <> systemnums.C_SUCCESS THEN
       RETURN errnums.C_BIZ_RULE_INVALID;
   END IF;

-- Run After Update
   IF txpks_#8883EX.fn_txAftAppUpdate(p_txmsg,p_err_code) <> systemnums.C_SUCCESS THEN
       RETURN errnums.C_BIZ_RULE_INVALID;
   END IF;
   --plog.debug (pkgctx, 'Begin of updating pool and room');
   IF txpks_prchk.fn_txAutoUpdate(p_txmsg, p_err_code) <> systemnums.C_SUCCESS THEN
       plog.setendsection (pkgctx, 'fn_txAppUpdate');
        Return errnums.C_BIZ_RULE_INVALID;
   END IF;
   pr_txlog8883(p_txmsg,p_err_code);
   --plog.debug (pkgctx, 'End of updating pool and room');
   plog.setendsection (pkgctx, 'fn_txAppUpdate');
   RETURN systemnums.C_SUCCESS;

EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'fn_txAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAppUpdate8883;

FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code in out varchar2)
RETURN NUMBER
IS
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txPreAppUpdate');
    --plog.debug (pkgctx, '<<BEGIN OF fn_txPreAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC PROCESS HERE. . DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    --plog.debug (pkgctx, '<<END OF fn_txPreAppUpdate');
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

FUNCTION fn_txAftAppUpdate8884EX(p_txmsg in tx.msg_rectype, p_bo_orderid varchar2,p_err_code in out varchar2)
RETURN NUMBER
IS
    v_lngErrCode number(20,0);
    v_count number(20,0);
    v_blnReversal boolean;
    v_strCODEID  odmast.codeid%type;
    v_strACTYPE  odmast.ACTYPE%type;
    v_strAFACCTNO odmast.AFACCTNO%type;
    v_strTIMETYPE odmast.TIMETYPE%type;
    v_strEFFDATE varchar2(30);
    v_strEXPDATE varchar2(30);
    v_strEXECTYPE odmast.EXECTYPE%type;
    v_strOLDEXECTYPE odmast.EXECTYPE%type;
    v_strNORK odmast.NORK%type;
    v_strMATCHTYPE odmast.MATCHTYPE%type;
    v_strVIA odmast.VIA%type;
    v_strCLEARCD odmast.CLEARCD%type;
    v_strPRICETYPE odmast.PRICETYPE%type;
    v_dblCLEARDAY odmast.CLEARDAY%type;
    v_dblQUOTEPRICE odmast.QUOTEPRICE%type;
    v_dblORDERQTTY odmast.ORDERQTTY%type;
    v_dblBRATIO odmast.BRATIO%type;
    v_dblLIMITPRICE odmast.LIMITPRICE%type;
    v_dblAdvanceAmount number(20,4);
    v_strVOUCHER odmast.VOUCHER%type;
    v_strCONSULTANT odmast.CONSULTANT%type;
    v_strORDERID odmast.ORDERID%type;
    v_strSymbol sbsecurities.symbol%type;
    v_strCancelOrderID odmast.ORDERID%type;
    v_strCUSTODYCD cfmast.custodycd%type;
    v_strDESC varchar2(300);
    v_dblIsMortage number(20);
    v_strOutPriceAllow char(1);
    v_strTLTXCD tltx.tltxcd%type;
    v_strFEEDBACKMSG varchar2(1000);
    v_dblTradeUnit number(20,4);
    v_strBORS char(1);
    v_strOODStatus char(1);
    v_strEDSTATUS char(1);
    v_strWASEDSTATUS char(1);
    v_strCUROODSTATUS char(1);
    v_dblCorrecionNumber number(10);
    v_strSEACCTNO odmast.seacctno%type;
    v_strCIACCTNO odmast.ciacctno%type;
    v_strSecuredAmt number(20,0);
    v_strCUSTID varchar2(200);
    l_strFOACCTNO VARCHAR2(200);
    v_strTLID VARCHAR2(30);
    v_dblQuoteqtty Odmast.quoteqtty%type;
    v_strNewPRICETYPE VARCHAR2(30);
    v_strNewOrderID  VARCHAR2(30);
    v_strCOREBANK char(1);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    --plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    ----------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------
    v_lngErrCode:=errnums.C_BIZ_RULE_INVALID;

    --</ TruongLD Add
    v_strTLID := p_txmsg.tlid;
    --/>

    if p_txmsg.deltd='Y' then
        v_blnReversal:=true;
    else
        v_blnReversal:=false;
    end if;
    --plog.debug (pkgctx, 'v_blnReversal:' || case when v_blnReversal= true then 'TRUE' else 'FALSE' end);
    v_strTLTXCD:=p_txmsg.tltxcd;
    v_strCODEID := p_txmsg.txfields('01').value;
    v_strACTYPE := p_txmsg.txfields('02').value;
    v_strAFACCTNO := p_txmsg.txfields('03').value;
    v_strTIMETYPE := p_txmsg.txfields('20').value;
    if v_strTLTXCD='8884' or v_strTLTXCD='8885' then
        v_strEFFDATE := p_txmsg.txfields('19').value;
    else
        v_strEFFDATE :='';-- p_txmsg.txfields('19').value;
    end if;

    v_strEXPDATE := p_txmsg.txfields('21').value;
    v_strEXECTYPE := p_txmsg.txfields('22').value;
    v_strNORK := p_txmsg.txfields('23').value;
    v_strMATCHTYPE := p_txmsg.txfields('24').value;
    v_strVIA := p_txmsg.txfields('25').value;
    v_strCLEARCD := p_txmsg.txfields('26').value;
    v_strPRICETYPE := p_txmsg.txfields('27').value;
    v_dblCLEARDAY := p_txmsg.txfields('10').value;
    v_dblQUOTEPRICE := p_txmsg.txfields('11').value;
    v_dblORDERQTTY := p_txmsg.txfields('12').value;
    v_dblBRATIO := p_txmsg.txfields('13').value;
    v_dblLIMITPRICE := p_txmsg.txfields('14').value;
    if v_strTLTXCD='8884' then
        v_dblAdvanceAmount := p_txmsg.txfields('18').value;
    else
        v_dblAdvanceAmount :='';-- p_txmsg.txfields('18').value;
    end if;
    -- neu lenh goc la MTL thi lenh moi sua la LO
    IF v_strPRICETYPE ='MTL' THEN
      v_strNewPRICETYPE:='LO';
    ELSE
      v_strNewPRICETYPE:=v_strPRICETYPE;
    END IF;
    v_strVOUCHER := p_txmsg.txfields('28').value;
    v_strCONSULTANT := p_txmsg.txfields('29').value;
    v_strORDERID := p_txmsg.txfields('04').value;
    v_strSymbol := p_txmsg.txfields('07').value;
    v_strCancelOrderID := p_txmsg.txfields('08').value;
    v_strCUSTODYCD := p_txmsg.txfields('09').value;
    v_strDESC := p_txmsg.txfields('30').value;
    --v_dblIsMortage := p_txmsg.txfields('60').value;
    v_strOutPriceAllow := p_txmsg.txfields('34').value;
    v_strCUSTID := p_txmsg.txfields('50').value;
    -- GET FOACCTNO
  begin
       v_dblQuoteqtty :=  p_txmsg.txfields('80').value;
     exception
     when no_data_found then
       v_dblQuoteqtty := 0;
     end;
    BEGIN
        SELECT FOACCTNO INTO l_strFOACCTNO FROM rootordermap WHERE ORDERID=V_strORDERID;

    EXCEPTION WHEN OTHERS THEN
            l_strFOACCTNO:= '';
    END;

    If v_strTIMETYPE = 'G' Then
        If Not v_blnREVERSAL Then
            --plog.debug (pkgctx, 'v_strTIMETYPE,v_strTLTXCD:' || v_strTIMETYPE || ',' || v_strTLTXCD);
            --Giao dich
            If v_strTLTXCD = '8882' Or v_strTLTXCD = '8883' Or v_strTLTXCD = '8884' Or v_strTLTXCD = '8885' Then
                begin
                    /*select A,EXECTYPE,EFFDATE into v_count,v_strOLDEXECTYPE,v_strEFFDATE from
                    (SELECT 1 A,EXECTYPE,to_char(EFFDATE,'DD/MM/RRRR') EFFDATE FROM FOMAST WHERE ACCTNO=p_bo_orderid  AND DELTD<>'Y' AND STATUS<> 'A'
                     UNION SELECT 0 A,EXECTYPE,'' EFFDATE FROM ODMAST WHERE ORDERID= v_strCancelOrderID) ;*/

                    select A,EXECTYPE,EFFDATE into v_count,v_strOLDEXECTYPE,v_strEFFDATE from
                    (SELECT 1 A,EXECTYPE,to_char(EFFDATE,'DD/MM/RRRR') EFFDATE FROM FOMAST WHERE REFACCTNO=p_bo_orderid  AND DELTD<>'Y' AND STATUS<> 'A'
                     UNION SELECT 0 A,EXECTYPE,'' EFFDATE FROM ODMAST WHERE ORDERID= v_strCancelOrderID) ;

                     if v_count=1 then
                        --Lenh GTO trong FOMAST chua duoc day vao he thong
                        --plog.debug (pkgctx, 'Order in FOMAST only');
                        If v_strTLTXCD = '8882' Or v_strTLTXCD = '8883' Then
                            --Lenh huy
                            UPDATE FOMAST SET DELTD='Y',REFACCTNO=v_strORDERID WHERE ACCTNO=v_strCancelOrderID;
                            Return systemnums.C_SUCCESS;
                        else
                            --LENH SUA
                            UPDATE FOMAST SET DELTD='Y',REFACCTNO=v_strORDERID WHERE ACCTNO=v_strCancelOrderID;

                            v_strFEEDBACKMSG:= v_strDESC;


                            INSERT INTO FOMAST (ACCTNO, ORGACCTNO, ACTYPE, AFACCTNO, STATUS, EXECTYPE,
                            PRICETYPE, TIMETYPE, MATCHTYPE, NORK, CLEARCD, CODEID, SYMBOL,
                                CONFIRMEDVIA, BOOK, FEEDBACKMSG, ACTIVATEDT,
                                CREATEDDT, CLEARDAY, QUANTITY, PRICE, QUOTEPRICE,
                                TRIGGERPRICE, EXECQTTY, EXECAMT, REMAINQTTY,TXDATE,TXNUM,EFFDATE,EXPDATE,
                                BRATIO,VIA,OUTPRICEALLOW,Quoteqtty,limitprice )
                                VALUES (
                                     v_strORDERID , v_strORDERID , v_strACTYPE , v_strAFACCTNO ,'P',
                                     v_strOLDEXECTYPE, v_strNewPRICETYPE , v_strTIMETYPE , v_strMATCHTYPE ,
                                     v_strNORK , v_strCLEARCD , v_strCODEID , v_strSymbol ,
                                     'N','A', v_strFEEDBACKMSG ,TO_CHAR(SYSDATE,'DD/MM/RRRR HH:MM:SS'),TO_CHAR(SYSDATE,'DD/MM/RRRR HH:MM:SS'),
                                     v_dblCLEARDAY , v_dblORDERQTTY , v_dblLIMITPRICE , v_dblQUOTEPRICE , 0 , 0 , 0 ,
                                     v_dblORDERQTTY ,p_txmsg.txdate, p_txmsg.txnum ,
                                     TO_DATE( v_strEFFDATE ,  'DD/MM/RRRR' ),TO_DATE( v_strEXPDATE ,  'DD/MM/RRRR' ),
                                     v_dblBRATIO , v_strVIA , v_strOutPriceAllow, v_dblquoteqtty, v_dblLIMITPRICE
                                 );
                            Return systemnums.C_SUCCESS;
                        end if;
                     else --=0
                        --plog.debug (pkgctx, 'Order in FOMAST and already send to ODMAST');
                        --Lenh GTO cua ODMAST
                        --Khong xu ly gi, xu ly nhu lenh binh thuong o phan sau
                        null;
                     end if;
                exception
                when no_data_found then
                    --Lenh da khop
                    p_err_code := errnums.C_OD_ORDER_SENDING;
                    Return v_lngErrCode;
                end;
            end if;
        else --Xoa Giao dich
            If v_strTLTXCD = '8882' Or v_strTLTXCD = '8883' Or v_strTLTXCD = '8884' Or v_strTLTXCD = '8885' Then
                begin
                    select A into v_count from
                    (SELECT 1 A FROM FOMAST WHERE ACCTNO= v_strCancelOrderID  AND DELTD='Y' AND STATUS<>'A'
                    UNION SELECT 0 A FROM ODMAST WHERE ORDERID=v_strCancelOrderID);



                    if v_count=1 then
                        --plog.debug (pkgctx, 'Order in FOMAST only');
                        --Lenh GTC trong FOMAST chua duoc day vao he thong
                        If v_strTLTXCD = '8882' Or v_strTLTXCD = '8883' Then
                            --Lenh huy
                            UPDATE FOMAST SET DELTD='N',REFACCTNO='' WHERE ACCTNO= v_strCancelOrderID;
                        else


                            --KIEM TRA XEM LENH SUA MOI DA SEND DI CHUA
                            SELECT count(1)  into v_count FROM FOMAST WHERE ACCTNO= v_strORDERID  AND DELTD <> 'Y' AND STATUS='P';

                            if v_count>0 then
                                --LENH SUA
                                UPDATE FOMAST SET DELTD='N',REFACCTNO='' WHERE ACCTNO=v_strCancelOrderID;
                                DELETE FROM FOMAST WHERE ACCTNO=v_strORDERID;
                            else
                                --Lenh GTC tu FOMAST da duoc day vao ODMAST
                                p_err_code := errnums.C_OD_ORDER_SENDING;
                                Return v_lngErrCode;
                            end if;

                        end if;
                    Else --=0
                        --plog.debug (pkgctx, 'Order in FOMAST and already send to ODMAST');
                        null;
                        --Lenh GTO cua ODMAST
                        --Khong xu ly gi, xu ly nhu lenh binh thuong o phan sau
                    End If;
                exception
                when no_data_found then
                    --Lenh da khop
                    p_err_code := errnums.C_OD_ORDER_SENDING;
                    Return v_lngErrCode;
                end;
            end if;

        end if;
    end if;
    --LENH KHAC GTC
    --HOAC LENH GTC DA DAY VAO HE THONG


    If Not v_blnREVERSAL Then


        --Xac dinh gia
        SELECT TRADEUNIT into v_dblTradeUnit FROM SECURITIES_INFO WHERE CODEID=v_strCODEID;
        v_dblQUOTEPRICE := v_dblQUOTEPRICE * v_dblTradeUnit;
        v_dblLIMITPRICE := v_dblLIMITPRICE * v_dblTradeUnit;
        --Tao lenh huy
        --Neu la lenh mua thi BORS = 'D', ban BORS = 'E'
        v_strBORS := 'D';
        v_strOODStatus := 'S';
        v_strEDSTATUS := 'N';
        v_strWASEDSTATUS := 'N';
        v_strOODStatus := 'N';
        if v_strTLTXCD='8882' then
            v_strBORS := 'D';
            v_strEDSTATUS := 'C';
            v_strWASEDSTATUS := 'W';
        elsif v_strTLTXCD='8884' then
            v_strBORS := 'D';
            v_strEDSTATUS := 'A';
            v_strWASEDSTATUS := 'S';
        elsif v_strTLTXCD='8883' then
            v_strBORS := 'E';
            v_strEDSTATUS := 'C';
            v_strWASEDSTATUS := 'W';
        elsif v_strTLTXCD='8885' then
            v_strBORS := 'E';
            v_strEDSTATUS := 'A';
            v_strWASEDSTATUS := 'S';
        end if;
        v_strSEACCTNO := v_strAFACCTNO || v_strCODEID;
        v_strCIACCTNO := v_strAFACCTNO;
        v_strSecuredAmt := v_dblQUOTEPRICE * v_dblORDERQTTY * v_dblBRATIO / 100;
        --plog.debug (pkgctx, 'Insert into ODMAST & OOD');

        --Ghi nhan vao so lenh ODMAST voi trang thai la send
        INSERT INTO ODMAST (ORDERID,CUSTID,ACTYPE,CODEID,AFACCTNO,SEACCTNO,CIACCTNO,
                        TXNUM,TXDATE,TXTIME,EXPDATE,BRATIO,TIMETYPE,
                        EXECTYPE,NORK,MATCHTYPE,VIA,CLEARDAY,CLEARCD,ORSTATUS,PORSTATUS,PRICETYPE,
                        QUOTEPRICE,STOPPRICE,LIMITPRICE,ORDERQTTY,REMAINQTTY,EXPRICE,EXQTTY,SECUREDAMT,
                        EXECQTTY,STANDQTTY,CANCELQTTY,ADJUSTQTTY,REJECTQTTY,REJECTCD,VOUCHER,CONSULTANT,REFORDERID,EDSTATUS, TLID,FOACCTNO ,Quoteqtty )
        VALUES ( v_strORDERID , v_strCUSTID , v_strACTYPE , v_strCODEID , v_strAFACCTNO , v_strSEACCTNO , v_strCIACCTNO
                        , p_txmsg.txnum ,TO_DATE( p_txmsg.txdate ,  'DD/MM/RRRR' ), to_char(sysdate,'HH24:MI:SS')
                        ,TO_DATE( v_strEXPDATE ,  'DD/MM/RRRR' ), v_dblBRATIO , v_strTIMETYPE
                        , v_strEXECTYPE , v_strNORK , v_strMATCHTYPE , v_strVIA
                        , v_dblCLEARDAY , v_strCLEARCD ,'7','7', v_strNewPRICETYPE
                        , v_dblQUOTEPRICE ,0, v_dblLIMITPRICE , v_dblORDERQTTY
                        , v_dblORDERQTTY , v_dblQUOTEPRICE , v_dblORDERQTTY
                        ,0,0,0,0,0,0,'001', v_strVOUCHER , v_strCONSULTANT ,
                        v_strCancelOrderID , v_strEDSTATUS, v_strTLID,l_strFOACCTNO,v_dblQuoteqtty );
        --Neu la lenh sua chua Send thi sinh them lenh moi vao trong he thong voi trang thai la send
        --Ghi nhan vao so lenh day di
        INSERT INTO OOD (ORGORDERID,CODEID,SYMBOL,CUSTODYCD,
                        BORS,NORP,AORN,PRICE,QTTY,SECUREDRATIO,
                        OODSTATUS,TXDATE,TXNUM,DELTD,BRID,reforderid,LIMITPRICE,QUOTEQTTY)
        VALUES          ( v_strORDERID , v_strCODEID , v_strSymbol , replace(v_strCUSTODYCD,'.', '') , v_strBORS , v_strMATCHTYPE
                        , v_strNORK , v_dblQUOTEPRICE , v_dblORDERQTTY , v_dblBRATIO , v_strOODStatus ,
                        TO_DATE( p_txmsg.txdate ,  'DD/MM/RRRR' ), p_txmsg.txnum ,'N', p_txmsg.brid , v_strCancelOrderID,v_dblLIMITPRICE,v_dblQuoteqtty );

        --Ghi nhan vao ODCHANING de ngan khong cho lenh HUY/SUA khac nhap vao
        begin
            plog.error (pkgctx, 'Insert into ODCHANGING');
            INSERT INTO ODCHANGING (ORGORDERID, ORDERID) VALUES ( v_strCancelOrderID , v_strORDERID);
        exception
        when others then
            --plog.debug (pkgctx, 'ODCHANGING invalid keys');
            p_err_code := errnums.C_OOD_STATUS_INVALID;
            Return v_lngErrCode;
        end;
        If v_strCUROODSTATUS = 'N' Then
            --'Tao ban ghi trong ODQUEUE de ngan khong cho day len san: E-Huy, Sua ban, D-Huy,Sua mua
            --plog.debug (pkgctx, 'Status=N so prevent from Cancel, amend');
            Update OOD SET OODSTATUS =  v_strBORS
                        WHERE ORGORDERID= v_strCancelOrderID
                        AND OODSTATUS = 'N';
            /*If v_strTLTXCD = '8882' Or v_strTLTXCD = '8883' Then
                --Lenh huy se complete luon: TRANG THAI OOD CUA LENH HUY se la (E-Huy ban, D-Huy mua) luon
                UPDATE OOD SET OODSTATUS =  v_strBORS
                            WHERE ORGORDERID= v_strORDERID;
            end if;*/
            --Lenh huy se complete luon: TRANG THAI OOD CUA LENH HUY se la (E-Sua - Huy ban, D-Sua - Huy mua) luon
            --Lenh sua se huy lenh cu, sinh ra lenh moi theo yeu cau sua luon : TRANG THAI OOD CUA LENH HUY se la (E-Sua - Huy ban, D-Sua - Huy mua) luon
            UPDATE OOD SET OODSTATUS =  v_strBORS WHERE ORGORDERID= v_strORDERID;
            If v_strTLTXCD= '8882' Then
                --Cancelstatus ='X' lenh Huy chua gui vao san
                UPDATE ODMAST SET REMAINQTTY=0, CANCELQTTY=ORDERQTTY, EDSTATUS= v_strWASEDSTATUS, CANCELSTATUS='X'  WHERE ORDERID= v_strCancelOrderID;
                If v_strTIMETYPE = 'G' Then
                    --4.Neu lenh GTC thi huy luon lenh yeu cau
                    UPDATE FOMAST SET DELTD='Y',REFACCTNO=v_strORDERID  WHERE ORGACCTNO=v_strCancelOrderID;
                End If;

            elsIf v_strTLTXCD= '8883' Then
                --Cancelstatus ='X' lenh Huy chua gui vao san
                UPDATE ODMAST SET REMAINQTTY=0, CANCELQTTY=ORDERQTTY, EDSTATUS=v_strWASEDSTATUS, CANCELSTATUS='X' WHERE ORDERID=v_strCancelOrderID;
                If v_strTIMETYPE = 'G' Then
                    --4.Neu lenh GTC thi huy luon lenh yeu cau
                    UPDATE FOMAST SET DELTD='Y',REFACCTNO=v_strORDERID  WHERE ORGACCTNO= v_strCancelOrderID;
                End If;
            elsIf v_strTLTXCD= '8884' or v_strTLTXCD= '8885' Then --Trang thai lenh la het hieu luc
                UPDATE ODMAST SET ORSTATUS='5', REMAINQTTY=0, adjustqtty=ORDERQTTY, EDSTATUS= v_strWASEDSTATUS  WHERE ORDERID= v_strCancelOrderID;
                --Tao lenh moi theo nhu yeu cau sua
                --Sinh so hieu lenh moi
                SELECT   substr(v_strCancelOrderID,1,4)
                         || TO_CHAR(TO_DATE (VARVALUE, 'DD\MM\RR'),'DDMMRR')
                         || LPAD (seq_odmast.NEXTVAL, 6, '0')
                  INTO v_strNewOrderID
                  FROM SYSVAR WHERE VARNAME ='CURRDATE' AND GRNAME='SYSTEM';
                            --Ghi nhan vao so lenh ODMAST voi trang thai la send
                INSERT INTO ODMAST (ORDERID,CUSTID,ACTYPE,CODEID,AFACCTNO,SEACCTNO,CIACCTNO,
                              TXNUM,TXDATE,TXTIME,EXPDATE,BRATIO,TIMETYPE,
                              EXECTYPE,NORK,MATCHTYPE,VIA,CLEARDAY,CLEARCD,ORSTATUS,PORSTATUS,PRICETYPE,
                              QUOTEPRICE,STOPPRICE,LIMITPRICE,ORDERQTTY,REMAINQTTY,EXPRICE,EXQTTY,SECUREDAMT,
                              EXECQTTY,STANDQTTY,CANCELQTTY,ADJUSTQTTY,REJECTQTTY,REJECTCD,VOUCHER,CONSULTANT,REFORDERID, TLID,FOACCTNO ,Quoteqtty )
                select  v_strNewOrderID , CUSTID,ACTYPE,CODEID,AFACCTNO,SEACCTNO,CIACCTNO
                              , txnum, txdate, to_char(sysdate,'HH24:MI:SS')
                              ,TO_DATE( v_strEXPDATE ,  'DD/MM/RRRR' ), v_dblBRATIO , v_strTIMETYPE
                              ,EXECTYPE,NORK,MATCHTYPE,VIA,CLEARDAY,CLEARCD,'8','8', v_strPRICETYPE
                              , v_dblQUOTEPRICE ,0, v_dblLIMITPRICE , v_dblORDERQTTY
                              , v_dblORDERQTTY , v_dblQUOTEPRICE , v_dblORDERQTTY
                              ,0,0,0,0,0,0,'001', VOUCHER,CONSULTANT ,
                              v_strCancelOrderID , v_strTLID,l_strFOACCTNO,v_dblQuoteqtty from odmast where orderid = v_strCancelOrderID;
                --Neu la lenh sua chua Send thi sinh them lenh moi vao trong he thong voi trang thai la send
                --Ghi nhan vao so lenh day di
                INSERT INTO OOD (ORGORDERID,CODEID,SYMBOL,CUSTODYCD,
                              BORS,NORP,AORN,PRICE,QTTY,SECUREDRATIO,
                              OODSTATUS,TXDATE,TXNUM,DELTD,BRID)
                select  v_strNewOrderID , CODEID,SYMBOL,CUSTODYCD,
                              BORS,NORP,AORN, v_dblQUOTEPRICE , v_dblORDERQTTY , SECUREDRATIO, 'N' ,
                              txdate, txnum ,'N', p_txmsg.brid from ood where orgorderid =v_strCancelOrderID;


                 --TungNT added - truong hop corebank sua lenh giam ky quy
                --SELECT COREBANK INTO v_strCOREBANK FROM CIMAST WHERE AFACCTNO=v_strAFACCTNO;
                --ThanhNV tam thoi rao lai 2015.04.15
                /*
                select (case when af.corebank = 'Y' then af.corebank else af.alternateacct end) into v_strCOREBANK from afmast af where ACCTNO=v_strAFACCTNO;
                IF v_strCOREBANK='Y' THEN
                    BEGIN
                        plog.debug(pkgctx,'Begin call pr_RM_UnholdAccount');
                        cspks_rmproc.pr_RM_UnholdAccount(v_strAFACCTNO,p_err_code);
                        plog.debug(pkgctx,'End call pr_RM_UnholdAccount, Return error code : ' || p_err_code);
                    END;
                END IF;
                */
                --End
            end if;
        end if;
    Else
        --Xoa lenh day di
        --plog.debug (pkgctx, 'Delete correcttion request!');
        UPDATE OOD SET DELTD='Y' WHERE TXNUM=p_txmsg.txnum AND TXDATE=to_date(p_txmsg.txdate,'DD/MM/RRRR');
        --Xoa  ODCHANGING
        DELETE FROM ODCHANGING WHERE ORGORDERID=v_strCancelOrderID;
        --Neu truoc day da Block lenh goc khong cho day thi phai Unblock
        UPDATE OOD SET OODSTATUS = 'N'
                    WHERE ORGORDERID= v_strCancelOrderID
                    AND (OODSTATUS = 'E' OR OODSTATUS = 'D');
        --Xoa trong ODQUEUE, ODQUEUE.OODSTATUS=v_strBORS
        DELETE FROM ODQUEUE
                    WHERE ORGORDERID= v_strCancelOrderID
                    AND (OODSTATUS = 'E' OR OODSTATUS = 'D');
        If v_strTIMETYPE = 'G' Then
            --4.Neu lenh GTC thi huy luon lenh yeu cau
            UPDATE FOMAST SET DELTD='N',REFACCTNO='' WHERE ORGACCTNO=v_strCancelOrderID;
        End If;
    end if;
    ----------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------

    --plog.debug (pkgctx, '<<END OF fn_txAftAppUpdate');
    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
       plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAftAppUpdate8884EX;

FUNCTION fn_txAppUpdate8887(p_txmsg in tx.msg_rectype,p_err_code in out varchar2)
RETURN NUMBER
IS
BEGIN
   plog.setbeginsection (pkgctx, 'fn_txAppUpdate');

-- Run Auto Update
   /*IF fn_txAppAutoUpdate8887EX(p_txmsg,p_err_code) <> systemnums.C_SUCCESS THEN
       RETURN errnums.C_BIZ_RULE_INVALID;
   END IF;*/
-- Run After Update
   IF txpks_#8877EX.fn_txAftAppUpdate(p_txmsg,p_err_code) <> systemnums.C_SUCCESS THEN
       RETURN errnums.C_BIZ_RULE_INVALID;
   END IF;
   --plog.debug (pkgctx, 'Begin of updating pool and room');
   IF txpks_prchk.fn_txAutoUpdate(p_txmsg, p_err_code) <> systemnums.C_SUCCESS THEN
       plog.setendsection (pkgctx, 'fn_txAppUpdate');
        Return errnums.C_BIZ_RULE_INVALID;
   END IF;
   --plog.debug (pkgctx, 'End of updating pool and room');
   plog.setendsection (pkgctx, 'fn_txAppUpdate');
   RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'fn_txAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAppUpdate8887;

FUNCTION fn_txAppAutoUpdate8887EX(p_txmsg in tx.msg_rectype,p_err_code in out varchar2)
RETURN  NUMBER
IS
l_txdesc VARCHAR2(1000);
BEGIN

   IF p_txmsg.deltd = 'Y' THEN -- Reversal transaction
UPDATE TLLOG
 SET DELTD = 'Y'
      WHERE TXNUM = p_txmsg.txnum AND TXDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT);
   END IF;
   plog.setendsection (pkgctx, 'fn_txAppAutoUpdate');
   RETURN systemnums.C_SUCCESS ;
EXCEPTION
  WHEN others THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'fn_txAppAutoUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAppAutoUpdate8887EX;

PROCEDURE matching_normal_order (
   order_number       IN   VARCHAR2,
   deal_volume        IN   NUMBER,
   deal_price         IN   NUMBER,
   confirm_number     IN   VARCHAR2,
   p_pitqtty          IN   NUMBER,
   p_err_code  OUT varchar2,
   p_err_message  OUT varchar2
)
IS
   v_strlog varchar2(4000);
BEGIN

  v_strlog:= ' newfo_api.matching_normal_order(order_number =>'''||order_number
                                    ||''', deal_volume =>'''||deal_volume
                                    ||''', deal_price =>'''||deal_price
                                    ||''', confirm_number =>'''||confirm_number
                                    ||''', p_err_code =>p_err_code
                                        , p_err_message =>p_err_message'');'
                              ;

  INSERT INTO t_fo_logcallws(id , tltxcd , acctno, strmsg , logtime)
                                       VALUES(seq_fo_logcallws.NEXTVAL, 'matching_normal_order', order_number, v_strlog, SYSTIMESTAMP);
  COMMIT;

  --rETURN;
  INSERT INTO t_fo_exec (
                           exectype,
                           origclordid,
                           lastqty,
                           lastpx,
                           execid,
                           receivetime,
                           id,
                           process,
                           pitqtty
                           )
        VALUES (
            'MATCH',
            order_number,
            deal_volume,
            deal_price,
            confirm_number,
            systimestamp,
            SEQ_FO_EXEC.NEXTVAL,
            'N',
            p_pitqtty
            );


   COMMIT;
   p_err_code := 0;
   p_err_message:= 'Sucessfull!';

 END;


PROCEDURE matching_normal_order_exec (
   order_number       IN   VARCHAR2,
   deal_volume        IN   NUMBER,
   deal_price         IN   NUMBER,
   confirm_number     IN   VARCHAR2,
   p_pitqtty          IN   NUMBER,
   p_err_code         OUT  varchar2,
   p_err_message      OUT  varchar2
)
IS
   v_tltxcd             VARCHAR2 (30);
   v_txnum              VARCHAR2 (30);
   v_txdate             VARCHAR2 (30);
   v_tlid               VARCHAR2 (30);
   v_brid               VARCHAR2 (30);
   v_ipaddress          VARCHAR2 (30);
   v_wsname             VARCHAR2 (30);
   v_txtime             VARCHAR2 (30);
   mv_strorgorderid     VARCHAR2 (30);
   mv_strcodeid         VARCHAR2 (30);
   mv_strsymbol         VARCHAR2 (30);
   mv_strcustodycd      VARCHAR2 (30);
   mv_strbors           VARCHAR2 (30);
   mv_strnorp           VARCHAR2 (30);
   mv_straorn           VARCHAR2 (30);
   mv_strafacctno       VARCHAR2 (30);
   mv_strciacctno       VARCHAR2 (30);
   mv_strseacctno       VARCHAR2 (30);
   mv_reforderid        VARCHAR2 (30);
   mv_refcustcd         VARCHAR2 (30);
   mv_strclearcd        VARCHAR2 (30);
   mv_strexprice        NUMBER (10);
   mv_strexqtty         NUMBER (10);
   mv_strprice          NUMBER (10);
   mv_strqtty           NUMBER (10);
   mv_strremainqtty     NUMBER (10);
   mv_strclearday       NUMBER (10);
   mv_strsecuredratio   NUMBER (10,2);
   mv_strconfirm_no     VARCHAR2 (30);
   mv_strmatch_date     VARCHAR2 (30);
   mv_desc              VARCHAR2 (30);
   v_strduetype         VARCHAR (2);
   v_matched            NUMBER (10,2);
   v_ex                 EXCEPTION;
   v_err                VARCHAR2 (100);
   v_temp               NUMBER(10);
   v_refconfirmno       VARCHAR2 (30);
   v_order_number       VARCHAR2(30);
   mv_mtrfday           NUMBER(10);
   l_trfbuyext          number(10);
   mv_strtradeplace     VARCHAR2(3);
   v_ticksize           NUMBER(20,4);
   l_dblExecQtty        number(20,0);
   v_strcorebank        char(1);
   v_strlog             Varchar2(4000);

   mv_dbltrfbuyext      number(20,0);
   mv_dbltrfbuyrate     number(20,4);
   mv_strtrfstatus      VARCHAR2(1);
   mv_dblceilingprice   number;
   mv_dblfloorprice     number;
   mv_strpricetype      VARCHAR2(10);
   mv_strexecqtty       NUMBER (10);
   v_OODSTATUS          VARCHAR2(10);


   Cursor c_Odmast(v_OrgOrderID Varchar2) Is
   SELECT FOACCTNO,REMAINQTTY,EXECQTTY,EXECAMT,CANCELQTTY,ADJUSTQTTY
   FROM ODMAST WHERE TIMETYPE ='G' AND ORDERID=v_OrgOrderID;
   vc_Odmast c_Odmast%Rowtype;

   --1.8.2.5: thue quyen
   v_caqtty   NUMBER;
   v_custid   VARCHAR2(10);
   v_parvalue NUMBER;
BEGIN
   --0 lay cac tham so
   v_brid := '0000';
   v_tlid := '0000';
   v_ipaddress := 'HOST';
   v_wsname := 'HOST';
   v_tltxcd := '8804';
   plog.setbeginsection (pkgctx, 'matching_normal_order_exec');

   mv_dbltrfbuyext:=0;
   mv_dbltrfbuyrate:=0;
   mv_strtrfstatus:='Y';

v_strlog:= ' newfo_api.matching_normal_order_exec(order_number =>'''||order_number
                                    ||''', deal_volume =>'''||deal_volume
                                    ||''', deal_price =>'''||deal_price
                                    ||''', confirm_number =>'''||confirm_number
                                    ||''', p_err_code =>p_err_code
                                        , p_err_message =>p_err_message'');'
                              ;

  INSERT INTO t_fo_logcallws(id , tltxcd , acctno, strmsg , logtime)
                                       VALUES(seq_fo_logcallws.NEXTVAL, 'matching_normal_order_exec', order_number, v_strlog, SYSTIMESTAMP);
  COMMIT;

   SELECT    '8080'
          || SUBSTR ('000000' || seq_batchtxnum.NEXTVAL,
                     LENGTH ('000000' || seq_batchtxnum.NEXTVAL) - 5,
                     6
                    )
     INTO v_txnum
     FROM DUAL;

   SELECT TO_CHAR (SYSDATE, 'HH24:MI:SS')
     INTO v_txtime
     FROM DUAL;

   BEGIN
      SELECT varvalue
        INTO v_txdate
        FROM sysvar
       WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

   p_err_code := 0;
   p_err_message:= 'Sucessfull!';

   EXCEPTION
      WHEN OTHERS
      THEN
         v_err := SUBSTR ('sysvar ' || SQLERRM, 1, 100);
         RAISE v_ex;
   END;
   v_order_number :=order_number;
   BEGIN

      SELECT boorderid
        INTO mv_strorgorderid
        FROM newfo_ordermap
       WHERE foorderid = v_order_number And txdate = TO_DATE(v_txdate, systemnums.c_date_format);
   EXCEPTION
      WHEN OTHERS
      THEN
         v_err :=
            SUBSTR (   'select mv_strorgorderid order_number= '
                    || order_number
                    || SQLERRM,
                    1,
                    100
                   );
         plog.debug(pkgctx,v_err );
         RAISE v_ex;
   END;
  --Kiem tra doi da thuc hien khop voi confirm number hay chua, neu da khop exit

    BEGIN
      SELECT COUNT(*)
        INTO V_TEMP
        FROM IOD
       WHERE ORGORDERID = MV_STRORGORDERID
       AND   CONFIRM_NO = TRIM(CONFIRM_NUMBER)
       AND IOD.deltd <>'Y';

       IF V_TEMP > 0 THEN
         RETURN;
       END IF;
    EXCEPTION
      WHEN OTHERS
      THEN
         v_err :=
            SUBSTR (   'Kiem tra confirm_number   '
                    || confirm_number
                    || SQLERRM,
                    1,
                    100
                   );
                  plog.debug(pkgctx,v_err );
         RAISE v_ex;
    END;



    --TungNT modified - for T2 late send money
      BEGIN
      SELECT od.remainqtty,od.execqtty, sb.codeid, sb.symbol, ood.custodycd,
             ood.bors, ood.norp, ood.aorn, od.afacctno,
             od.ciacctno, od.seacctno, '', '',
             od.clearcd, ood.price, ood.qtty, deal_price,
             deal_volume, od.clearday, od.bratio,
             confirm_number, v_txdate, '', typ.mtrfday,
             ss.tradeplace,af.trfbuyext, af.trfbuyrate,
             od.pricetype, sb.ceilingprice,sb.floorprice, af.custid
        INTO mv_strremainqtty,mv_strexecqtty, mv_strcodeid, mv_strsymbol, mv_strcustodycd,
             mv_strbors, mv_strnorp, mv_straorn, mv_strafacctno,
             mv_strciacctno, mv_strseacctno, mv_reforderid, mv_refcustcd,
             mv_strclearcd, mv_strexprice, mv_strexqtty, mv_strprice,
             mv_strqtty, mv_strclearday, mv_strsecuredratio,
             mv_strconfirm_no, mv_strmatch_date, mv_desc,mv_mtrfday,
             mv_strtradeplace,mv_dbltrfbuyext, mv_dbltrfbuyrate,
             mv_strpricetype, mv_dblceilingprice,mv_dblfloorprice, v_custid --1.8.2.5: thue quyen
        FROM odmast od, ood, securities_info sb,odtype typ,afmast af,sbsecurities ss
       WHERE od.orderid = ood.orgorderid and od.actype = typ.actype
         AND od.afacctno=af.acctno and od.codeid=ss.codeid
         AND od.codeid = sb.codeid
         AND od.exectype IN ('NB','NS','MS')
         AND orderid = mv_strorgorderid;
   EXCEPTION
      WHEN OTHERS
      THEN
         v_err :=
            SUBSTR (   'odmast ,securities_info mv_strorgorderid= '
                    || mv_strorgorderid
                    || SQLERRM,
                    1,
                    100
                   );
                  plog.debug(pkgctx,v_err );
         RAISE v_ex;
   END;

   IF mv_dbltrfbuyext>0 THEN
        mv_strtrfstatus:='N';
   END IF;
    --End

  IF mv_strnorp = 'P' THEN
    mv_strconfirm_no := 'PT' || mv_strconfirm_no;
  END IF;


   IF ( mv_strbors ='B' and mv_strexprice < deal_price) or
     ( mv_strbors ='S' and mv_strexprice > deal_price) Then
     Return;
   End if;


   --Day vao stctradebook, stctradeallocation de khong bi khop lai:
   v_refconfirmno :='VN'||mv_strbors||mv_strconfirm_no;

   INSERT INTO stctradeallocation
            (txdate, txnum, refconfirmnumber, orderid, bors, volume,
             price, deltd
            )
     VALUES (to_date(v_txdate,'dd/mm/yyyy'), v_txnum, v_refconfirmno, mv_strorgorderid, mv_strbors, mv_strqtty,
             mv_strprice, 'N'
            );


   mv_desc := 'Matching order';

   IF mv_strremainqtty >= mv_strqtty
   THEN
      --thuc hien khop voi ket qua tra ve

      --1 them vao trong tllog
      INSERT INTO tllog
                  (autoid, txnum,
                   txdate, txtime, brid,
                   tlid, offid, ovrrqs, chid, chkid, tltxcd, ibt, brid2,
                   tlid2, ccyusage, txstatus, msgacct, msgamt, chktime,
                   offtime, off_line, deltd, brdate,
                   busdate, msgsts, ovrsts, ipaddress,
                   wsname, batchname, txdesc
                  )
           VALUES (seq_tllog.NEXTVAL, v_txnum,
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), v_txtime, v_brid,
                   v_tlid, '', 'N', '', '', v_tltxcd, 'Y', '',
                   '', '', '1', mv_strorgorderid, mv_strqtty, '',
                   '', 'N', 'N', TO_DATE (v_txdate, 'DD/MM/YYYY'),
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), '', '', v_ipaddress,
                   v_wsname, 'DAY', mv_desc
                  );

      --tHEM VAO TRONG TLLOGFLD
      INSERT INTO tllogfld
                  (autoid, txnum,
                   txdate, fldcd, nvalue,
                   cvalue, txdesc
                  )
           VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), '03', 0,
                   mv_strorgorderid, NULL
                  );

      INSERT INTO tllogfld
                  (autoid, txnum,
                   txdate, fldcd, nvalue, cvalue,
                   txdesc
                  )
           VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), '80', 0, mv_strcodeid,
                   NULL
                  );

      INSERT INTO tllogfld
                  (autoid, txnum,
                   txdate, fldcd, nvalue, cvalue,
                   txdesc
                  )
           VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), '81', 0, mv_strsymbol,
                   NULL
                  );

      INSERT INTO tllogfld
                  (autoid, txnum,
                   txdate, fldcd, nvalue,
                   cvalue, txdesc
                  )
           VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), '82', 0,
                   mv_strcustodycd, NULL
                  );

      INSERT INTO tllogfld
                  (autoid, txnum,
                   txdate, fldcd, nvalue, cvalue,
                   txdesc
                  )
           VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), '04', 0, mv_strafacctno,
                   NULL
                  );

      INSERT INTO tllogfld
                  (autoid, txnum,
                   txdate, fldcd, nvalue, cvalue,
                   txdesc
                  )
           VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), '11', mv_strqtty, NULL,
                   NULL
                  );

      INSERT INTO tllogfld
                  (autoid, txnum,
                   txdate, fldcd, nvalue, cvalue,
                   txdesc
                  )
           VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), '10', mv_strprice, NULL,
                   NULL
                  );

      INSERT INTO tllogfld
                  (autoid, txnum,
                   txdate, fldcd, nvalue, cvalue, txdesc
                  )
           VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), '30', 0, mv_desc, NULL
                  );
      INSERT INTO tllogfld
                  (autoid, txnum,
                   txdate, fldcd, nvalue, cvalue, txdesc
                  )
           VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), '05', 0, mv_strafacctno, NULL
                  );

      IF mv_strbors = 'B' THEN
          INSERT INTO tllogfld
                  (autoid, txnum,
                   txdate, fldcd, nvalue, cvalue, txdesc
                  )
           VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), '86', mv_strprice*mv_strqtty, NULL, NULL
                  );

          INSERT INTO tllogfld
                  (autoid, txnum,
                   txdate, fldcd, nvalue, cvalue, txdesc
                  )
           VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), '87', mv_strqtty, NULL, NULL
                  );
      ELSE
          INSERT INTO tllogfld
                  (autoid, txnum,
                   txdate, fldcd, nvalue, cvalue, txdesc
                  )
           VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), '86', 0, NULL, NULL
                  );

          INSERT INTO tllogfld
                  (autoid, txnum,
                   txdate, fldcd, nvalue, cvalue, txdesc
                  )
           VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), '87', 0, NULL, NULL
                  );
      END IF;

        INSERT INTO iodqueue (TXDATE,BORS,CONFIRM_NO,SYMBOL)
        VALUES(TO_DATE (v_txdate, 'DD/MM/YYYY'),mv_strbors,mv_strconfirm_no,mv_strsymbol);
      --3 THEM VAO TRONG IOD
      INSERT INTO iod
                  (orgorderid, codeid, symbol,
                   custodycd, bors, norp,
                   txdate, txnum, aorn,
                   price, qtty, exorderid, refcustcd,
                   matchprice, matchqtty, confirm_no,txtime
                  )
           VALUES (mv_strorgorderid, mv_strcodeid, mv_strsymbol,
                   mv_strcustodycd, mv_strbors, mv_strnorp,
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), v_txnum, mv_straorn,
                   mv_strexprice, mv_strexqtty, mv_reforderid, mv_refcustcd,
                   mv_strprice, mv_strqtty,mv_strconfirm_no, to_char(sysdate,'hh24:mi:ss')
                  );

    ---- GHI NHAT VAO BANG TINH GIA VON CUA TUNG LAN KHOP.
    --ThanhNV tam thoi rao lai
    --SECMAST_GENERATE(v_txnum, v_txdate, v_txdate, mv_strafacctno, mv_strcodeid, 'T', (CASE WHEN mv_strbors = 'B' THEN 'I' ELSE 'O' END), null, mv_strorgorderid, mv_strqtty, mv_strprice, 'Y');




      --4 CAP NHAT STSCHD
      SELECT COUNT (*)
        INTO v_matched
        FROM stschd
       WHERE orgorderid = mv_strorgorderid AND deltd <> 'Y';
   BEGIN
      IF mv_strbors = 'B'
      THEN                                                          --Lenh mua
         --Tao lich thanh toan chung khoan
         v_strduetype := 'RS';

         IF v_matched > 0
         THEN
            UPDATE stschd
               SET qtty = qtty + mv_strqtty,
                   amt = amt + mv_strprice * mv_strqtty
             WHERE orgorderid = mv_strorgorderid AND duetype = v_strduetype;
         ELSE
            INSERT INTO stschd
                        (autoid, orgorderid, codeid,
                         duetype, afacctno, acctno,
                         reforderid, txnum,
                         txdate, clearday,
                         clearcd, amt, aamt,
                         qtty, aqtty, famt, status, deltd, costprice,
                         CLEARDATE
                        )
                 VALUES (seq_stschd.NEXTVAL, mv_strorgorderid, mv_strcodeid,
                         v_strduetype, mv_strafacctno, mv_strseacctno,
                         mv_reforderid, v_txnum,
                         TO_DATE (v_txdate, 'DD/MM/YYYY'), mv_strclearday,
                         mv_strclearcd, mv_strprice * mv_strqtty, 0,
                         mv_strqtty, 0, 0, 'N', 'N', 0,
                         getduedate(TO_DATE (v_txdate, 'DD/MM/YYYY'),mv_strclearcd,'000',mv_strclearday)
                        );
         END IF;

         --Tao lich thanh toan tien
        select case when mrt.mrtype <> 'N'
        --ThanhNV tam rao lai 2015.04.15
        --and aft.istrfbuy <> 'N'
        then aft.trfbuyext
            else 0 end into l_trfbuyext
        from afmast af, aftype aft, mrtype mrt
        where af.actype = aft.actype and aft.mrtype = mrt.actype and af.acctno = mv_strafacctno;

         v_strduetype := 'SM';

         IF v_matched > 0
         THEN
            UPDATE stschd
               SET qtty = qtty + mv_strqtty,
                   amt = amt + mv_strprice * mv_strqtty
             WHERE orgorderid = mv_strorgorderid AND duetype = v_strduetype;
         ELSE
            --TungNT modified , for late T2 send money
          /*
          INSERT INTO stschd
                        (autoid, orgorderid, codeid,
                         duetype, afacctno, acctno,
                         reforderid, txnum,
                         txdate, clearday,
                         clearcd, amt, aamt,
                         qtty, aqtty, famt, status, deltd, costprice, cleardate
                        )
                 VALUES (seq_stschd.NEXTVAL, mv_strorgorderid, mv_strcodeid,
                         v_strduetype, mv_strafacctno, mv_strafacctno,
                         mv_reforderid, v_txnum,
                         TO_DATE (v_txdate, 'DD/MM/YYYY'), least(mv_mtrfday,l_trfbuyext),
                         mv_strclearcd, mv_strprice * mv_strqtty, 0,
                         mv_strqtty, 0, 0, 'N', 'N', 0,
                         getduedate(TO_DATE (v_txdate, 'DD/MM/YYYY'),mv_strclearcd,'000',
                         least(mv_mtrfday,l_trfbuyext))
                        );
             */
            --TungNT modified , for late T2 send money
            INSERT INTO stschd
                        (autoid, orgorderid, codeid,
                         duetype, afacctno, acctno,
                         reforderid, txnum,
                         txdate, clearday,
                         clearcd, amt, aamt,
                         qtty, aqtty, famt, status, deltd,
                         costprice, cleardate,
                         trfbuydt,trfbuysts, trfbuyrate, trfbuyext
                        )
                 VALUES (seq_stschd.NEXTVAL, mv_strorgorderid, mv_strcodeid,
                         v_strduetype, mv_strafacctno, mv_strafacctno,
                         mv_reforderid, v_txnum,
                         TO_DATE (v_txdate, 'DD/MM/YYYY'), 0,
                         mv_strclearcd, mv_strprice * mv_strqtty, 0,
                         mv_strqtty, 0, 0, 'N', 'N',
                         0, getduedate(TO_DATE (v_txdate, 'DD/MM/YYYY'),
                         mv_strclearcd,'000',greatest(mv_mtrfday,mv_dbltrfbuyext)),
                         least(getduedate(TO_DATE (v_txdate, 'DD/MM/YYYY'),mv_strclearcd,'000',mv_dbltrfbuyext),
                         getduedate(TO_DATE (v_txdate, 'DD/MM/YYYY'),mv_strclearcd,'000',mv_strclearday)),
                         mv_strtrfstatus, mv_dbltrfbuyrate, mv_dbltrfbuyext
                        );
            --Emd
         END IF;

      ELSE                                                          --Lenh ban
         --Tao lich thanh toan chung khoan
         v_strduetype := 'SS';

         IF v_matched > 0
         THEN
            UPDATE stschd
               SET qtty = qtty + mv_strqtty,
                   amt = amt + mv_strprice * mv_strqtty
             WHERE orgorderid = mv_strorgorderid AND duetype = v_strduetype;
         ELSE
            INSERT INTO stschd
                        (autoid, orgorderid, codeid,
                         duetype, afacctno, acctno,
                         reforderid, txnum,
                         txdate, clearday,
                         clearcd, amt, aamt,
                         qtty, aqtty, famt, status, deltd, costprice, cleardate
                        )
                 VALUES (seq_stschd.NEXTVAL, mv_strorgorderid, mv_strcodeid,
                         v_strduetype, mv_strafacctno, mv_strseacctno,
                         mv_reforderid, v_txnum,
                         TO_DATE (v_txdate, 'DD/MM/YYYY'), 0,
                         mv_strclearcd, mv_strprice * mv_strqtty, 0,
                         mv_strqtty, 0, 0, 'N', 'N', 0, getduedate(TO_DATE (v_txdate, 'DD/MM/YYYY'),mv_strclearcd,'000',0)
                        );
         END IF;

         --Tao lich thanh toan tien
         v_strduetype := 'RM';

         IF v_matched > 0
         THEN
            UPDATE stschd
               SET qtty = qtty + mv_strqtty,
                   amt = amt + mv_strprice * mv_strqtty
             WHERE orgorderid = mv_strorgorderid AND duetype = v_strduetype;
         ELSE
            INSERT INTO stschd
                        (autoid, orgorderid, codeid,
                         duetype, afacctno, acctno,
                         reforderid, txnum,
                         txdate, clearday,
                         clearcd, amt, aamt,
                         qtty, aqtty, famt, status, deltd, costprice, cleardate
                        )
                 VALUES (seq_stschd.NEXTVAL, mv_strorgorderid, mv_strcodeid,
                         v_strduetype, mv_strafacctno, mv_strafacctno,
                         mv_reforderid, v_txnum,
                         TO_DATE (v_txdate, 'DD/MM/YYYY'), mv_strclearday,
                         mv_strclearcd, mv_strprice * mv_strqtty, 0,
                         mv_strqtty, 0, 0, 'N', 'N', 0, getduedate(TO_DATE (v_txdate, 'DD/MM/YYYY'),mv_strclearcd,'000',mv_strclearday)
                        );
         END IF;
      END IF;
  EXCEPTION
      WHEN OTHERS
      THEN
         v_err :=
            SUBSTR (   'Loi insert vao stschd '
                    || mv_strorgorderid || ' DueType '||v_strduetype
                    || SQLERRM,
                    1,
                    100
                   );
         RAISE v_ex;
   END;

      --CAP NHAT TRAN VA MAST
            --BUY
      --Neu trang thai lenh goc l? N thi cap nhat Sent + Odqueue;
      BEGIN
          SELECT OODSTATUS INTO v_OODSTATUS FROM OOD WHERE   ORGORDERID = mv_strorgorderid;
          IF  v_OODSTATUS ='N' THEN
              UPDATE OOD
              SET OODSTATUS = 'S', TXTIME = TO_CHAR(SYSDATE,'HH24:MI:SS')
              WHERE ORGORDERID = mv_strorgorderid AND OODSTATUS <> 'S';
              INSERT INTO ODQUEUE SELECT * FROM OOD WHERE ORGORDERID =  mv_strorgorderid;
          END IF;
      EXCEPTION WHEN OTHERS THEN
         plog.debug (pkgctx, ' matching_normal_order_exec Invalid status mv_strorgorderid'||mv_strorgorderid );
      END;

       UPDATE odmast
         SET orstatus = '4',
             PORSTATUS = PORSTATUS||'4',
             execqtty = execqtty + mv_strqtty ,
             remainqtty = remainqtty - mv_strqtty,
             execamt = execamt + mv_strqtty * mv_strprice,
             matchamt = matchamt + mv_strqtty * mv_strprice
       WHERE orderid = mv_strorgorderid;
       UPDATE odmast
         SET HOSESESSION = (SELECT SYSVALUE  FROM ORDERSYS WHERE SYSNAME = 'CONTROLCODE')
       WHERE orderid = mv_strorgorderid And HOSESESSION ='N';

      --Neu khop het va co lenh huy cua lenh da khop thi cap nhat thanh refuse
      IF mv_strremainqtty = mv_strqtty THEN
          UPDATE odmast
             SET ORSTATUS = '0'
           WHERE REFORDERID = mv_strorgorderid;

          Update ood set oodstatus ='N' where oodstatus ='B' and REFORDERID = mv_strorgorderid
           and orgorderid in (select orderid from odmast where orstatus ='0');
        Else
        -- hoac lenh sua ve khoi luong <= khoi luong khop cung refuse
          UPDATE odmast
             SET ORSTATUS = '0'
           WHERE exectype in ('AS','AB') And orderqtty <= l_dblExecQtty + mv_strqtty
           And REFORDERID = mv_strorgorderid;

           Update ood set oodstatus ='N' where oodstatus ='B' and REFORDERID = mv_strorgorderid
           and orgorderid in (select orderid from odmast where orstatus ='0');
        END IF;

      --Cap nhat tinh gia von

      IF mv_strbors = 'B' THEN
          UPDATE semast SET dcramt = dcramt + mv_strqtty*mv_strprice, dcrqtty = dcrqtty+mv_strqtty WHERE acctno = mv_strseacctno;
      END IF;

      INSERT INTO odtran
                  (txnum, txdate,
                   acctno, txcd, namt, camt, acctref, deltd,
                   REF, autoid
                  )
           VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),
                   mv_strorgorderid, '0013', mv_strqtty, NULL, NULL, 'N',
                   NULL, seq_odtran.NEXTVAL
                  );

      INSERT INTO odtran
                  (txnum, txdate,
                   acctno, txcd, namt, camt, acctref, deltd,
                   REF, autoid
                  )
           VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),
                   mv_strorgorderid, '0011', mv_strqtty, NULL, NULL, 'N',
                   NULL, seq_odtran.NEXTVAL
                  );

      INSERT INTO odtran
                  (txnum, txdate,
                   acctno, txcd, namt, camt,
                   acctref, deltd, REF, autoid
                  )
           VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),
                   mv_strorgorderid, '0028', mv_strqtty * mv_strprice, NULL,
                   NULL, 'N', NULL, seq_odtran.NEXTVAL
                  );

      INSERT INTO odtran
                  (txnum, txdate,
                   acctno, txcd, namt, camt,
                   acctref, deltd, REF, autoid
                  )
           VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),
                   mv_strorgorderid, '0034', mv_strqtty * mv_strprice, NULL,
                   NULL, 'N', NULL, seq_odtran.NEXTVAL
                  );



      --TungNT added , giai toa khi sua lenh
        --ThanhNV tao rao lai 2015.04.15
        /*
        if mv_strbors ='B' and mv_strexprice > mv_strprice then
          --select corebank into v_strcorebank from afmast where acctno =v_afaccount;
          select (case when af.corebank = 'Y' then af.corebank else af.alternateacct end)  into v_strcorebank
          from afmast af where acctno =mv_strafacctno;
          if v_strcorebank ='Y' then

             BEGIN
               cspks_rmproc.pr_RM_Unholdaccount(mv_strafacctno, v_err);
             EXCEPTION WHEN OTHERS THEN
                null;
             END;
          end if;

        end if;
        --End
        */

                  -- if instr('/NS/MS/SS/', :newval.exectype) > 0 then
        if mv_strbors = 'S' then
            -- quyet.kieu : Them cho LINHLNB 21/02/2012
            -- Begin Danh sau tai san LINHLNB
            INSERT INTO odchanging_trigger_log (AFACCTNO,CODEID,AMT,TXNUM,TXDATE,ERRCODE,LAST_CHANGE,ORDERID,ACTIONFLAG,QTTY)
            VALUES( mv_strafacctno,mv_strcodeid ,mv_strprice * mv_strqtty ,v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),NULL,systimestamp,mv_strorgorderid,'M',mv_strqtty);
            -- End Danh dau tai san LINHLNB
        end if;

        --1.8.2.5: thue quyen
   IF mv_strbors = 'S' AND p_pitqtty > 0 THEN
     v_caqtty := p_pitqtty;
     SELECT PARVALUE INTO v_parvalue from sbsecurities where codeid=mv_strcodeid;

     IF mv_strprice < v_parvalue THEN
        v_parvalue := mv_strprice;
     END IF;

        FOR rec IN (
            SELECT * FROM (SELECT se.*, decode(af.acctno,mv_strafacctno,0,1) lord
                                     FROM sepitlog se, afmast af
                                    WHERE se.afacctno = af.acctno
                                      AND af.custid = v_custid
                                      AND se.codeid = mv_strcodeid
                                      AND se.qtty - se.mapqtty >0
                                      AND se.deltd <> 'Y'
                                      )
                                    ORDER BY lord, txdate, pitrate  DESC
        )
        LOOP
             IF v_caqtty < rec.QTTY-rec.MAPQTTY then

                UPDATE STSCHD SET RIGHTQTTY= RIGHTQTTY + v_caqtty,
                    ARIGHT = ARIGHT + v_caqtty * rec.CARATE * v_parvalue * rec.PITRATE/100
                    WHERE DUETYPE='RM' AND ORGORDERID=mv_strorgorderid
                    /*AND AFACCTNO=rec.afacctno*/ AND CODEID=rec.codeid
                    AND DELTD <> 'Y' AND STATUS='N';

                UPDATE SEPITLOG SET MAPQTTY= MAPQTTY + v_caqtty
                    WHERE AUTOID = rec.autoid;

                INSERT INTO SEPITALLOCATE (CAMASTID,AFACCTNO,CODEID,PITRATE,QTTY,PRICE,ARIGHT,ORGORDERID,TXNUM,TXDATE,CARATE,SEPITLOG_ID) VALUES(
                        rec.CAMASTID, rec.AFACCTNO, rec.CODEID, rec.PITRATE,v_caqtty, v_parvalue, v_caqtty * rec.CARATE * v_parvalue * rec.PITRATE/100,
                        mv_strorgorderid, v_txnum,TO_DATE (v_txdate, 'DD/MM/YYYY'),rec.CARATE,rec.AUTOID);

                v_caqtty:=0;

            ELSE
                UPDATE STSCHD SET RIGHTQTTY = RIGHTQTTY + rec.qtty - rec.mapqtty,
                    ARIGHT = ARIGHT + (rec.qtty - rec.mapqtty) * rec.CARATE * v_parvalue * rec.PITRATE/100
                    WHERE DUETYPE='RM' AND ORGORDERID=mv_strorgorderid /*AND AFACCTNO=rec.afacctno*/ AND CODEID=rec.codeid AND
                    DELTD <> 'Y' AND STATUS='N';

                UPDATE SEPITLOG SET MAPQTTY = MAPQTTY + rec.qtty - rec.mapqtty, STATUS='C'
                WHERE AUTOID = rec.autoid;

                INSERT INTO SEPITALLOCATE (CAMASTID,AFACCTNO,CODEID,PITRATE,QTTY,PRICE,ARIGHT,ORGORDERID,TXNUM,TXDATE,CARATE,SEPITLOG_ID) VALUES(
                        rec.CAMASTID, rec.AFACCTNO, rec.CODEID, rec.PITRATE,rec.qtty - rec.mapqtty, v_parvalue, (rec.qtty - rec.mapqtty) * rec.CARATE * v_parvalue * rec.PITRATE/100,
                        mv_strorgorderid, v_txnum,TO_DATE (v_txdate, 'DD/MM/YYYY'),rec.CARATE,rec.AUTOID);

                v_caqtty:=v_caqtty - (rec.qtty - rec.mapqtty);
            END IF;
            EXIT WHEN v_caqtty<=0;
        END LOOP;
     END IF;
   -- end
   END IF;


   --Cap nhat cho GTC
   OPEN C_ODMAST(MV_STRORGORDERID);
   FETCH C_ODMAST INTO VC_ODMAST;
    IF C_ODMAST%FOUND THEN
         UPDATE FOMAST SET REMAINQTTY= REMAINQTTY - MV_STRQTTY
                            ,EXECQTTY= EXECQTTY + MV_STRQTTY
                            ,EXECAMT=  EXECAMT + MV_STRPRICE * MV_STRQTTY
          --WHERE ORGACCTNO= MV_STRORGORDERID;
          WHERE ACCTNO= VC_ODMAST.FOACCTNO;
    END IF;
   CLOSE C_ODMAST;

   COMMIT;
   p_err_code := 0;
   p_err_message:= 'Sucessfull!';

   plog.setendsection (pkgctx, 'matching_normal_order_exec');


EXCEPTION
   WHEN v_ex
   THEN
   ROLLBACK;
      plog.debug (pkgctx, ' matching_normal_order_exec v_ex'||v_err );
      plog.setendsection (pkgctx, 'matching_normal_order_exec');
      p_err_code := -100800;
      COMMIT;
  when others then
      v_err:=substr(sqlerrm,1,200);
      ROLLBACK;
      plog.debug (pkgctx, ' matching_normal_order_exec'||v_err );
      plog.setendsection (pkgctx, 'matching_normal_order_exec');
      p_err_code := -100800; --File du lieu dau vao khong hop le
      p_err_message:= 'System error. Invalid file format';
 END;

PROCEDURE confirm_cancel_normal_order (
   pv_orderid   IN   VARCHAR2,
   pv_qtty      IN   NUMBER,
   p_err_code  OUT varchar2,
   p_err_message  OUT varchar2
)
IS
  v_strlog varchar2(4000);
BEGIN

   plog.setbeginsection (pkgctx, 'confirm_cancel_normal_order');
   v_strlog := ' confirm_cancel_normal_order pv_orderid '||pv_orderid
                                                     ||'pv_qtty '||pv_qtty
                                  ;
   INSERT INTO t_fo_logcallws(id , tltxcd , acctno, strmsg , logtime)
                                       VALUES(seq_fo_logcallws.NEXTVAL, 'confirm_cancel_normal_order', pv_orderid, v_strlog, SYSTIMESTAMP);
   COMMIT;

   INSERT INTO t_fo_exec (
                           exectype,
                           origclordid,
                           lastqty,
                           receivetime,
                           id,
                           process
                           )
        VALUES (
            'CFCANCEL',   --Confirm cancel
            pv_orderid,
            pv_qtty,
            systimestamp,
            SEQ_FO_EXEC.NEXTVAL,
            'N'
            );


   COMMIT;
   p_err_code := 0;
   p_err_message:= 'Sucessfull!';
   plog.setendsection (pkgctx, 'confirm_cancel_normal_order');

END;


PROCEDURE confirm_cancel_exec (
   pv_orderid   IN   VARCHAR2,
   pv_qtty      IN   NUMBER,
   p_err_code  OUT varchar2,
   p_err_message  OUT varchar2
)
IS
   v_edstatus         VARCHAR2 (30);
   v_tltxcd           VARCHAR2 (30);
   v_txnum            VARCHAR2 (30);
   v_txdate           VARCHAR2 (30);
   v_tlid             VARCHAR2 (30);
   v_brid             VARCHAR2 (30);
   v_ipaddress        VARCHAR2 (30);
   v_wsname           VARCHAR2 (30);
   v_symbol           VARCHAR2 (30);
   v_afaccount        VARCHAR2 (30);
   v_seacctno         VARCHAR2 (30);
   v_price            NUMBER (10,2);
   v_quantity         NUMBER (10,2);
   v_bratio           NUMBER (10,2);
   v_oldbratio        NUMBER (10,2);
   v_cancelqtty       NUMBER (10,2);
   v_amendmentqtty    NUMBER (10,2);
   v_amendmentprice   NUMBER (10,2);
   v_matchedqtty      NUMBER (10,2);
   v_advancedamount   NUMBER (10,2);
   v_execqtty         NUMBER (10,2);
   v_trExectype       VARCHAR2 (30);
   v_reforderid       VARCHAR2 (30);
   v_tradeunit        NUMBER (10,2);
   v_desc             VARCHAR2 (300);
   v_bors             VARCHAR2 (30);
   v_txtime           VARCHAR2 (30);
   v_Count_lenhhuy    Number(2);
   v_OrderQtty_Cur    Number(10);
   v_RemainQtty_Cur   Number(10);
   v_ExecQtty_Cur     Number(10);
   v_CancelQtty_Cur   Number(10);
   v_Matchtype        VARCHAR2(10);
   v_Orstatus_Cur     VARCHAR2(10);
   v_err              VARCHAR2(300);
   v_strCodeid        VARCHAR2(10);

   v_order_number   varchar2(30);

   v_strcorebank      char(1);
   v_stralternateacct char(1);
   v_ex                 EXCEPTION;
   v_strlog varchar2(4000);
   v_orderid_tmp varchar2(100);
   v_reforderid_tmp varchar2(100);
   v_exectype_tmp varchar2(100);
   Cursor c_Odmast(v_OrgOrderID Varchar2) Is
   SELECT FOACCTNO,REMAINQTTY,EXECQTTY,EXECAMT,CANCELQTTY,ADJUSTQTTY
   FROM ODMAST WHERE TIMETYPE ='G' AND ORDERID=v_OrgOrderID;
   vc_Odmast c_Odmast%Rowtype;


BEGIN

   plog.setbeginsection (pkgctx, 'confirm_cancel_normal_order_exec');
   plog.debug (pkgctx, 'CFCANCEL BEGIN pv_orderid '||pv_orderid);
   v_strlog := ' confirm_cancel_normal_order_exec pv_orderid '||pv_orderid
                                                     ||'pv_qtty '||pv_qtty
                                  ;
   --0 lay cac tham so
   v_brid := '0000';
   v_tlid := '0000';
   v_ipaddress := 'HOST';
   v_wsname := 'HOST';
   v_cancelqtty := pv_qtty;
   --Kiem tra thoa man dieu kien huy
   BEGIN

    SELECT varvalue
        INTO v_txdate
        FROM sysvar
       WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

/*    SELECT NVL(reforderid,orderid)
        INTO v_order_number
        FROM odmast WHERE orderid IN (SELECT boorderid FROM newfo_ordermap
       WHERE foorderid = NVL(order_number,pv_orderid)
        AND txdate = TO_DATE (v_txdate, systemnums.c_date_format));*/
    SELECT orderid, reforderid, exectype
        INTO v_orderid_tmp, v_reforderid_tmp, v_exectype_tmp
        FROM odmast WHERE orderid IN (SELECT boorderid FROM newfo_ordermap
       WHERE (foorderid = pv_orderid OR NVL(order_number,'000') = pv_orderid)
        AND txdate = TO_DATE (v_txdate, systemnums.c_date_format));

   IF  v_exectype_tmp IN ('NS','NB')  THEN  --Neu huy luon lenh goc (khong co yeu cau huy)
     v_order_number := v_orderid_tmp;
   ELSE
     v_order_number:= v_reforderid_tmp;   --Gan bang lenh goc, co yeu cau huy
   END IF;

   plog.debug (pkgctx, ' confirm_cancel_normal_order pv_orderid '||pv_orderid
                                                     ||'v_order_number '||v_order_number
                                  );

    SELECT ORDERQTTY,REMAINQTTY,EXECQTTY,CANCELQTTY,ORSTATUS,Exectype, MATCHTYPE
    INTO V_ORDERQTTY_CUR,V_REMAINQTTY_CUR,V_EXECQTTY_CUR,V_CANCELQTTY_CUR,V_ORSTATUS_CUR,v_trExectype,v_Matchtype
    FROM ODMAST WHERE ORDERID =v_order_number;
   EXCEPTION WHEN OTHERS THEN
    p_err_code := -100800; --File du lieu dau vao khong hop le
    v_err := SUBSTR ('WHERE ORDERID = ' || SQLERRM ||'  '||v_order_number, 1, 100);
    p_err_message:= v_err;
    raise v_ex;
   END;

   plog.debug (pkgctx, ' confirm_cancel_normal_order_exec 1 pv_orderid '||pv_orderid
                                                     ||'v_order_number '||v_order_number
                                                     ||'V_REMAINQTTY_CUR '||V_REMAINQTTY_CUR
                                                     ||'V_CANCELQTTY '||V_CANCELQTTY
                                                     ||'V_EXECQTTY_CUR '||V_EXECQTTY_CUR
                                                     ||'V_ORDERQTTY_CUR '||V_ORDERQTTY_CUR
                                  );

   --Neu lenh thoa thuan da khop thi giai toa:
   IF v_Matchtype ='P' THEN
      For i in (Select orgorderid ,codeid,bors,matchprice,matchqtty,txnum,txdate ,custodycd
                            From iod
                            Where NorP ='P'
                            And orgorderid  = v_order_number)
          Loop

             Update odmast set deltd ='Y', CANCELQTTY =ORDERQTTY,
                                REMAINQTTY=0,EXECQTTY =0 ,MATCHAMT =0,Execamt =0
              Where MATCHTYPE ='P'
              And Orderid = i.orgorderid;

             Update ood set  deltd ='Y' where orgorderid = i.orgorderid;
             Update stschd set deltd = 'Y'
             where  orgorderid = i.orgorderid;

              For vc in (select orderid
                         from odmast where grporder='Y' and  orderid= i.orgorderid)
              Loop
                cspks_seproc.pr_executeod9996(i.orgorderid,p_err_code,p_err_message);
              End loop;


              if i.bors = 'B' then
                -- quyet.kieu : Them cho LINHLNB 21/02/2012
                -- Begin Danh sau tai san LINHLNB

                Select  afacctno into v_afaccount  from ODMAST   Where MATCHTYPE ='P' And Orderid = i.orgorderid;

                INSERT INTO odchanging_trigger_log (AFACCTNO,CODEID,AMT,TXNUM,TXDATE,ERRCODE,LAST_CHANGE,ORDERID,ACTIONFLAG, QTTY)
                VALUES( v_afaccount,i.codeid ,i.matchprice * i.matchqtty,i.txnum, i.txdate,NULL,systimestamp,i.orgorderid,'C', i.matchqtty);
                -- End Danh dau tai san LINHLNB
              end if ;


          End Loop;
          --plog.debug (pkgctx, 'Cancel Order thoa thuan');

            --Xu ly IOD
          Update iod set Deltd ='Y' where NorP ='P'
                         And orgorderid  =v_order_number;
          --plog.debug (pkgctx, 'Cancel Order thoa thuan Update odmast  successful');

   END IF;


   IF V_REMAINQTTY_CUR - V_CANCELQTTY < 0 OR V_EXECQTTY_CUR >= V_ORDERQTTY_CUR
                 OR V_CANCELQTTY = 0
   THEN
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
    plog.setendsection (pkgctx, 'confirm_cancel_normal_order');
    Return;
   END IF;

   plog.debug (pkgctx, 'CFCANCEL after check KL pv_orderid '||pv_orderid);


   --Lenh huy thong thuong: Co lenh huy 1C
   SELECT count(*) INTO v_Count_lenhhuy FROM odmast WHERE reforderid =v_order_number AND exectype IN ('CB','CS') AND  orstatus <> '6';
   IF v_Count_lenhhuy >0 Then
        SELECT DISTINCT (CASE
                      WHEN exectype = 'CB'
                         THEN '8890'
                      ELSE '8891'
                   END), sb.symbol,
                  od.afacctno, od.seacctno, od.quoteprice, od.orderqtty, od.bratio,
                  0, od.quoteprice, 0, od.orderqtty - pv_qtty,
                  od.reforderid, sb.tradeunit, od.edstatus,od.codeid
             INTO v_tltxcd, v_symbol,
                  v_afaccount, v_seacctno, v_price, v_quantity, v_bratio,
                  v_amendmentqtty, v_amendmentprice, v_matchedqtty, v_execqtty,
                  v_reforderid, v_tradeunit, v_edstatus , v_strCodeid
             FROM odmast od, securities_info sb
            WHERE od.codeid = sb.codeid
            AND  od.orstatus <> '6'
            AND reforderid = v_order_number;
   ELSE
    --Giai toa ATO
            SELECT (CASE
                      WHEN EXECTYPE LIKE '%B'
                         THEN '8808'
                      ELSE '8807'
                   END), sb.symbol,
                  od.afacctno, od.seacctno, od.quoteprice, od.orderqtty, od.bratio,
                  0, od.quoteprice, 0, od.orderqtty - pv_qtty,
                  od.reforderid, sb.tradeunit, od.edstatus
             INTO v_tltxcd, v_symbol,
                  v_afaccount, v_seacctno, v_price, v_quantity, v_bratio,
                  v_amendmentqtty, v_amendmentprice, v_matchedqtty, v_execqtty,
                  v_reforderid, v_tradeunit, v_edstatus
             FROM odmast od, securities_info sb
            WHERE od.codeid = sb.codeid AND orderid = v_order_number;
    END IF;

   plog.debug (pkgctx, 'CFCANCEL after check Distince pv_orderid '||pv_orderid);
   v_advancedamount := 0;


   SELECT bratio
     INTO v_oldbratio
     FROM odmast
    WHERE orderid = v_order_number;

      --NEU CHAU BI HUY THI KHI NHAN DUOC MESSAGE TRA VE SE THUC HIEN HUY LENH


      SELECT    '8080'
             || SUBSTR ('000000' || seq_batchtxnum.NEXTVAL,
                        LENGTH ('000000' || seq_batchtxnum.NEXTVAL) - 5,
                        6
                       )
        INTO v_txnum
        FROM DUAL;

      SELECT TO_CHAR (SYSDATE, 'HH24:MI:SS')
        INTO v_txtime
        FROM DUAL;

      --1 them vao trong tllog
      INSERT INTO tllog
                  (autoid, txnum,
                   txdate, txtime, brid,
                   tlid, offid, ovrrqs, chid, chkid, tltxcd, ibt, brid2,
                   tlid2, ccyusage, txstatus, msgacct, msgamt, chktime,
                   offtime, off_line, deltd, brdate,
                   busdate, msgsts, ovrsts, ipaddress,
                   wsname, batchname, txdesc
                  )
           VALUES (seq_tllog.NEXTVAL, v_txnum,
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), v_txtime, v_brid,
                   v_tlid, '', 'N', '', '', v_tltxcd, 'Y', '',
                   '', '', '1', v_order_number, v_quantity, '',
                   '', 'N', 'N', TO_DATE (v_txdate, 'DD/MM/YYYY'),
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), '', '', v_ipaddress,
                   v_wsname, 'DAY', v_desc
                  );
      --them vao tllogfld
      INSERT INTO tllogfld(AUTOID,TXNUM,TXDATE,FLDCD,NVALUE,CVALUE,TXDESC)
      VALUES (seq_tllogfld.NEXTVAL,v_txnum,TO_DATE (v_txdate, 'DD/MM/YYYY'),'07',0,v_symbol,NULL);
      INSERT INTO tllogfld(AUTOID,TXNUM,TXDATE,FLDCD,NVALUE,CVALUE,TXDESC)
      VALUES (seq_tllogfld.NEXTVAL,v_txnum,TO_DATE (v_txdate, 'DD/MM/YYYY'),'03',0,v_afaccount,NULL);
      INSERT INTO tllogfld(AUTOID,TXNUM,TXDATE,FLDCD,NVALUE,CVALUE,TXDESC)
      VALUES (seq_tllogfld.NEXTVAL,v_txnum,TO_DATE (v_txdate, 'DD/MM/YYYY'),'04',0,v_order_number,NULL);
      INSERT INTO tllogfld(AUTOID,TXNUM,TXDATE,FLDCD,NVALUE,CVALUE,TXDESC)
      VALUES (seq_tllogfld.NEXTVAL,v_txnum,TO_DATE (v_txdate, 'DD/MM/YYYY'),'06',0,v_seacctno,NULL);
      INSERT INTO tllogfld(AUTOID,TXNUM,TXDATE,FLDCD,NVALUE,CVALUE,TXDESC)
      VALUES (seq_tllogfld.NEXTVAL,v_txnum,TO_DATE (v_txdate, 'DD/MM/YYYY'),'08',0,v_order_number,NULL);
      INSERT INTO tllogfld(AUTOID,TXNUM,TXDATE,FLDCD,NVALUE,CVALUE,TXDESC)
      VALUES (seq_tllogfld.NEXTVAL,v_txnum,TO_DATE (v_txdate, 'DD/MM/YYYY'),'14',v_cancelqtty,NULL,NULL);
      INSERT INTO tllogfld(AUTOID,TXNUM,TXDATE,FLDCD,NVALUE,CVALUE,TXDESC)
      VALUES (seq_tllogfld.NEXTVAL,v_txnum,TO_DATE (v_txdate, 'DD/MM/YYYY'),'11',v_price,NULL,NULL);
      INSERT INTO tllogfld(AUTOID,TXNUM,TXDATE,FLDCD,NVALUE,CVALUE,TXDESC)
      VALUES (seq_tllogfld.NEXTVAL,v_txnum,TO_DATE (v_txdate, 'DD/MM/YYYY'),'12',v_quantity,NULL,NULL);

      --2 THEM VAO TRONG TLLOGFLD
      If v_Count_lenhhuy >0 then
          v_edstatus := 'W';
          UPDATE odmast
             SET edstatus = v_edstatus, cancelstatus ='C' --Huy do san tra ve
          WHERE orderid = v_order_number;

          UPDATE OOD SET OODSTATUS = 'S' , TXTIME = TO_CHAR(SYSDATE,'HH24:MI:SS')
          WHERE ORGORDERID IN (SELECT ORDERID FROM ODMAST  WHERE REFORDERID = v_order_number)
          and OODSTATUS <> 'S';

      Else
        Update ODMAST set ORSTATUS ='5' , cancelstatus ='C' --Huy do san tra ve
        where Orderqtty =Remainqtty And ORDERID =v_order_number;

      End if;

      plog.debug (pkgctx, 'CFCANCEL after ghi log pv_orderid '||pv_orderid);
      plog.debug (pkgctx, ' confirm_cancel_normal_order_exec pv_orderid '||pv_orderid
                                                     ||'v_cancelqtty '||v_cancelqtty
                                  );

      --3 CAP NHAT TRAN VA MAST
      IF v_tltxcd = '8890' OR v_tltxcd = '8808'
      THEN
         --BUY
         UPDATE odmast
            SET cancelqtty = cancelqtty + v_cancelqtty,
                remainqtty = remainqtty - v_cancelqtty
          WHERE orderid = v_order_number;

        if v_tltxcd = '8890' OR v_tltxcd='8808' then
                -- quyet.kieu : Them cho LINHLNB 21/02/2012
                -- Begin Danh sau tai san LINHLNB


                INSERT INTO odchanging_trigger_log (AFACCTNO,CODEID,AMT,TXNUM,TXDATE,ERRCODE,LAST_CHANGE,ORDERID,ACTIONFLAG,QTTY)
                VALUES( v_afaccount,v_strCodeid ,v_cancelqtty * v_price ,v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),NULL,systimestamp,v_order_number,'C',v_cancelqtty);
                -- End Danh dau tai san LINHLNB
          end if ;



         INSERT INTO odtran
                     (txnum, txdate,
                      acctno, txcd, namt, camt, acctref, deltd,
                      REF, autoid
                     )
              VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),
                      v_order_number, '0014', v_cancelqtty, NULL, NULL, 'N',
                      NULL, seq_odtran.NEXTVAL
                     );

         INSERT INTO odtran
                     (txnum, txdate,
                      acctno, txcd, namt, camt, acctref, deltd,
                      REF, autoid
                     )
              VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),
                      v_order_number, '0011', v_cancelqtty, NULL, NULL, 'N',
                      NULL, seq_odtran.NEXTVAL
                     );

      ELSE                                                   --v_tltxcd='8891' , '8807'
         --SELL
         UPDATE odmast
            SET cancelqtty = cancelqtty + v_cancelqtty,
                remainqtty = remainqtty - v_cancelqtty
          WHERE orderid = v_order_number;

         INSERT INTO odtran
                     (txnum, txdate,
                      acctno, txcd, namt, camt, acctref, deltd,
                      REF, autoid
                     )
              VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),
                      v_order_number, '0014', v_cancelqtty, NULL, NULL, 'N',
                      NULL, seq_odtran.NEXTVAL
                     );

         INSERT INTO odtran
                     (txnum, txdate,
                      acctno, txcd, namt, camt, acctref, deltd,
                      REF, autoid
                     )
              VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),
                      v_order_number, '0011', v_cancelqtty, NULL, NULL, 'N',
                      NULL, seq_odtran.NEXTVAL
                     );
      END IF;

 --Cap nhat cho GTC
   OPEN C_ODMAST(v_order_number);
   FETCH C_ODMAST INTO VC_ODMAST;
    IF C_ODMAST%FOUND THEN
         UPDATE FOMAST SET   REMAINQTTY= REMAINQTTY - v_cancelqtty
                            ,cancelqtty= cancelqtty + v_cancelqtty
          --WHERE ORGACCTNO= v_order_number;
          WHERE ACCTNO= VC_ODMAST.FOACCTNO;
    END IF;
   CLOSE C_ODMAST;


   COMMIT;
   p_err_code := 0;
   plog.debug (pkgctx, 'CFCANCEL END pv_orderid '||pv_orderid);
   p_err_message:= 'Sucessfull!';
   plog.setendsection (pkgctx, 'confirm_cancel_normal_order_exec');
EXCEPTION
   WHEN v_ex
   THEN
   ROLLBACK;

    plog.debug (pkgctx, ' confirm_cancel_normal_order_exec v_ex '||pv_orderid
                                                     ||'pv_qtty '||pv_qtty
                                                     ||' v_err '||v_err
                                  );
    plog.setendsection (pkgctx, 'confirm_cancel_normal_order_exec');
   when others then
      v_err:=substr(sqlerrm,1,200);
      ROLLBACK;
      plog.debug (pkgctx, ' confirm_cancel_normal_order_exec v_ex '||pv_orderid
                                                     ||'pv_qtty '||pv_qtty
                                                     ||' v_err '||v_err
                                  );
     plog.setendsection (pkgctx, 'confirm_cancel_normal_order_exec');
     p_err_code := -100800; --File du lieu dau vao khong hop le
     p_err_message:= 'System error. Invalid file format';
END;

PROCEDURE CONFIRM_REPLACE_NORMAL_ORDER (
   pv_ordernumber   IN   VARCHAR2,
   pv_qtty       IN   NUMBER,
   pv_price      IN   NUMBER,
   pv_LeavesQty IN   NUMBER,
   p_err_code  OUT varchar2,
   p_err_message  OUT varchar2
)
IS

   v_strlog           varchar2(4000);


BEGIN


   plog.setendsection (pkgctx, 'CONFIRM_REPLACE_NORMAL_ORDER');
   v_strlog := ' CONFIRM_REPLACE_NORMAL_ORDER pv_ordernumber '||pv_ordernumber
                                                     ||'pv_qtty '||pv_qtty
                                                     ||' pv_price '||pv_price
                                                     ||' pv_LeavesQty '||pv_LeavesQty
                                  ;

   INSERT INTO t_fo_logcallws(id , tltxcd , acctno, strmsg , logtime)
                                       VALUES(seq_fo_logcallws.NEXTVAL, 'CONFIRM_REPLACE_NORMAL_ORDER', pv_ordernumber, v_strlog, SYSTIMESTAMP);
   COMMIT;

   INSERT INTO t_fo_exec (
                           exectype,
                           origclordid,
                           lastqty,
                           lastpx,
                           leavesqty,
                           receivetime,
                           id,
                           process
                           )
        VALUES (
            'CFREPLACE',
            pv_ordernumber,
            pv_qtty,
            pv_price,
            pv_LeavesQty,
            systimestamp,
            SEQ_FO_EXEC.NEXTVAL,
            'N'
            );

   COMMIT;

   p_err_code := 0;
   p_err_message:= 'Sucessfull!';
   plog.setendsection (pkgctx, 'CONFIRM_REPLACE_NORMAL_ORDER');

END;


PROCEDURE CONFIRM_REPLACE_EXEC (
   pv_ordernumber   IN   VARCHAR2,
   pv_qtty       IN   NUMBER,
   pv_price      IN   NUMBER,
   pv_LeavesQty IN   NUMBER,
   p_err_code  OUT varchar2,
   p_err_message  OUT varchar2
)
IS
   v_edstatus         VARCHAR2 (30);
   v_tltxcd           VARCHAR2 (30);
   v_txnum            VARCHAR2 (30);
   v_txdate           VARCHAR2 (30);
   v_tlid             VARCHAR2 (30);
   v_brid             VARCHAR2 (30);
   v_ipaddress        VARCHAR2 (30);
   v_wsname           VARCHAR2 (30);
   v_symbol           VARCHAR2 (30);
   v_afaccount        VARCHAR2 (30);
   v_seacctno         VARCHAR2 (30);
   v_price            NUMBER (10,2);
   v_quantity         NUMBER (10,2);
   v_bratio           NUMBER (10,2);
   v_oldbratio        NUMBER (10,2);
   v_cancelqtty       NUMBER (10,2);
   v_amendmentqtty    NUMBER (10,2);
   v_amendmentprice   NUMBER (10,2);
   v_matchedqtty      NUMBER (10,2);
   v_advancedamount   NUMBER (10,2);
   v_execqtty         NUMBER (10,2);
   v_trExectype       VARCHAR2 (30);
   v_reforderid       VARCHAR2 (30);
   v_tradeunit        NUMBER (10,2);
   v_desc             VARCHAR2 (300);
   v_bors             VARCHAR2 (30);
   v_txtime           VARCHAR2 (30);
   v_Count_lenhhuy    Number(2);
   v_OrderQtty_Cur    Number(10);
   v_RemainQtty_Cur   Number(10);
   v_ExecQtty_Cur     Number(10);
   v_ReplaceQtty_Cur   Number(10);
   v_Orstatus_Cur     VARCHAR2(10);
   v_CustID           VARCHAR2 (30);
   v_Actype           VARCHAR2 (30);
   v_CodeID           VARCHAR2 (30);
   v_TimeType         VARCHAR2 (30);
   v_ExecType         VARCHAR2 (30);
   v_NorK             VARCHAR2 (30);
   v_ClearDay         VARCHAR2 (30);
   v_MATCHTYPE        VARCHAR2 (30);
   v_Via              VARCHAR2 (30);
   v_CLEARCD          VARCHAR2 (30);
   v_PRICETYPE        VARCHAR2 (30);
   v_CUSTODYCD        VARCHAR2 (30);
   v_LIMITPRICE       Number(10,2);
   v_VOUCHER          VARCHAR2 (30);
   v_CONSULTANT       VARCHAR2 (30);
   v_OrderID          VARCHAR2 (30);
   v_replaceqtty      Number(10,2);
   PV_ORDERID          VARCHAR2 (30);
   v_err              VARCHAR2(300);
   v_strcorebank        char(1);
   v_ex                 EXCEPTION;
   v_DFACCTNO         varchar(20); --TheNN added
   v_ISDISPOSAL       varchar(20); --GianhVG added
   l_err_code         VARCHAR2(100);

   v_retlid           varchar2(10);
   v_blorderid        varchar2(50);
   v_isblorder        varchar2(2);
   v_strlog           varchar2(4000);
   Cursor c_Odmast(v_OrgOrderID Varchar2) Is
   SELECT REMAINQTTY,EXECQTTY,EXECAMT,CANCELQTTY,ADJUSTQTTY
   FROM ODMAST WHERE TIMETYPE ='G' AND ORDERID=v_OrgOrderID;
   vc_Odmast c_Odmast%Rowtype;

BEGIN


   plog.setendsection (pkgctx, 'CONFIRM_REPLACE_EXEC');
   v_strlog := ' CONFIRM_REPLACE_EXEC pv_ordernumber '||pv_ordernumber
                                                     ||'pv_qtty '||pv_qtty
                                                     ||' pv_price '||pv_price
                                                     ||' pv_LeavesQty '||pv_LeavesQty
                                  ;


   --0 lay cac tham so
   v_brid := '0000';
   v_tlid := '0000';
   v_ipaddress := 'HOST';
   v_wsname := 'HOST';
   v_replaceqtty := pv_qtty;

   Begin

   SELECT varvalue
        INTO v_txdate
        FROM sysvar
       WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

     --Select boorderid into PV_ORDERID from newfo_ordermap where foorderid =pv_ordernumber AND txdate = TO_DATE (v_txdate, systemnums.c_date_format);

     SELECT Reforderid, tlid  INTO PV_ORDERID, v_tlid FROM odmast WHERE exectype IN ('AS','AB')
     and orderid IN (SELECT BOORDERID from newfo_ordermap
     WHERE FOORDERID =pv_ordernumber AND txdate = TO_DATE (v_txdate, systemnums.c_date_format));



    SELECT ORDERQTTY,REMAINQTTY,EXECQTTY,CANCELQTTY,ORSTATUS,Exectype,  blorderid,isblorder,via
    INTO V_ORDERQTTY_CUR,V_REMAINQTTY_CUR,V_EXECQTTY_CUR,V_REPLACEQTTY_CUR,V_ORSTATUS_CUR,v_Exectype,  v_blorderid,v_isblorder,v_Via
    FROM ODMAST WHERE ORDERID =PV_ORDERID;

    plog.debug (pkgctx, ' CONFIRM_REPLACE_NORMAL_ORDER v_tlid '||v_tlid
                                  );


   EXCEPTION
      WHEN OTHERS
      THEN
        p_err_code := -100800; --File du lieu dau vao khong hop le
        p_err_message:= 'System error. Invalid file format';
         v_err := SUBSTR ('ODMAST WHERE ORDERID =PV_ORDERID: ' || PV_ORDERID || ' : ' || SQLERRM, 1, 100);

         RAISE v_ex;
   END;
-- TheNN, 23-Dec-2013
    -- Neu lenh Bloomberg thi lay so hieu lenh moi trong bl_odmast
    begin
        IF v_blorderid IS NOT NULL THEN
            SELECT od.blorderid
            INTO v_blorderid
            FROM odmast od
            WHERE od.reforderid = PV_ORDERID AND edstatus = 'A';
        END IF;
    EXCEPTION
      WHEN OTHERS
      THEN
         p_err_code := -100800; --File du lieu dau vao khong hop le
         p_err_message:= 'System error. Invalid file format';
         v_err := SUBSTR ('WHERE od.reforderid = PV_ORDERID AND edstatus = ''A'' ' || SQLERRM, 1, 100);
         RAISE v_ex;
    END;

  Begin
   SELECT (CASE
                      WHEN exectype = 'AB'
                         THEN '8890'
                      ELSE '8891'
                   END), sb.symbol,
                  od.afacctno, od.seacctno, od.quoteprice, od.orderqtty, od.bratio,
                  0, od.quoteprice, 0, od.orderqtty - pv_qtty,
                  od.reforderid, sb.tradeunit, od.edstatus,custid,actype,timetype,
                  NorK,MATCHTYPE,Via,CLEARDAY,CLEARCD,PRICETYPE,CUSTODYCD,
                  OD.LIMITPRICE,VOUCHER,CONSULTANT, od.codeid
             INTO v_tltxcd, v_symbol,
                  v_afaccount, v_seacctno, v_price, v_quantity, v_bratio,
                  v_amendmentqtty, v_amendmentprice, v_matchedqtty, v_execqtty,
                  v_reforderid, v_tradeunit, v_edstatus,v_custid,v_actype,v_timetype,
                  v_NorK,v_MATCHTYPE,v_Via,v_CLEARDAY,v_CLEARCD,v_PRICETYPE,v_CUSTODYCD,
                  v_LIMITPRICE,v_VOUCHER,v_CONSULTANT,v_codeid
             FROM odmast od, ood ,  securities_info sb
            WHERE od.codeid = sb.codeid AND od.orderid = ood.orgorderid AND  od.orstatus <> '6' AND od.reforderid = pv_orderid;
            --WHERE od.codeid = sb.codeid AND od.orderid = ood.orgorderid AND od.reforderid = pv_orderid;

  Exception when others then
         p_err_code := -100800; --File du lieu dau vao khong hop le
         p_err_message:= 'System error. Invalid file format';
         v_err := SUBSTR ('Confirm Replace cancel: Khong tim thay reforderid = pv_orderid'||pv_orderid ||' '|| SQLERRM, 1, 100);
         RAISE v_ex;
  End;

   v_advancedamount := 0;


   SELECT bratio, DFACCTNO, ISDISPOSAL
     INTO v_oldbratio, v_DFACCTNO,v_ISDISPOSAL
     FROM odmast
    WHERE orderid = pv_orderid;

     Select '0001'||to_char(to_date(v_txdate,'dd/mm/yyyy'),'ddmmyy')||lpad(SEQ_ODMAST.NEXTVAL,6,'0')
     into v_OrderID from dual;

      SELECT    '8080'
             || SUBSTR ('000000' || seq_batchtxnum.NEXTVAL,
                        LENGTH ('000000' || seq_batchtxnum.NEXTVAL) - 5,
                        6
                       )
        INTO v_txnum
        FROM DUAL;

      SELECT TO_CHAR (SYSDATE, 'HH24:MI:SS')
        INTO v_txtime
        FROM DUAL;

      --1 them vao trong tllog
      INSERT INTO tllog
                  (autoid, txnum,
                   txdate, txtime, brid,
                   tlid, offid, ovrrqs, chid, chkid, tltxcd, ibt, brid2,
                   tlid2, ccyusage, txstatus, msgacct, msgamt, chktime,
                   offtime, off_line, deltd, brdate,
                   busdate, msgsts, ovrsts, ipaddress,
                   wsname, batchname, txdesc
                  )
           VALUES (seq_tllog.NEXTVAL, v_txnum,
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), v_txtime, v_brid,
                   v_tlid, '', 'N', '', '', v_tltxcd, 'Y', '',
                   '', '', '1', pv_orderid, v_quantity, '',
                   '', 'N', 'N', TO_DATE (v_txdate, 'DD/MM/YYYY'),
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), '', '', v_ipaddress,
                   v_wsname, 'DAY', v_desc
                  );
      --them vao tllogfld
      INSERT INTO tllogfld(AUTOID,TXNUM,TXDATE,FLDCD,NVALUE,CVALUE,TXDESC)
      VALUES (seq_tllogfld.NEXTVAL,v_txnum,TO_DATE (v_txdate, 'DD/MM/YYYY'),'07',0,v_symbol,NULL);
      INSERT INTO tllogfld(AUTOID,TXNUM,TXDATE,FLDCD,NVALUE,CVALUE,TXDESC)
      VALUES (seq_tllogfld.NEXTVAL,v_txnum,TO_DATE (v_txdate, 'DD/MM/YYYY'),'03',0,v_afaccount,NULL);
      INSERT INTO tllogfld(AUTOID,TXNUM,TXDATE,FLDCD,NVALUE,CVALUE,TXDESC)
      VALUES (seq_tllogfld.NEXTVAL,v_txnum,TO_DATE (v_txdate, 'DD/MM/YYYY'),'04',0,pv_orderid,NULL);
      INSERT INTO tllogfld(AUTOID,TXNUM,TXDATE,FLDCD,NVALUE,CVALUE,TXDESC)
      VALUES (seq_tllogfld.NEXTVAL,v_txnum,TO_DATE (v_txdate, 'DD/MM/YYYY'),'06',0,v_seacctno,NULL);
      INSERT INTO tllogfld(AUTOID,TXNUM,TXDATE,FLDCD,NVALUE,CVALUE,TXDESC)
      VALUES (seq_tllogfld.NEXTVAL,v_txnum,TO_DATE (v_txdate, 'DD/MM/YYYY'),'08',0,pv_orderid,NULL);
      INSERT INTO tllogfld(AUTOID,TXNUM,TXDATE,FLDCD,NVALUE,CVALUE,TXDESC)
      VALUES (seq_tllogfld.NEXTVAL,v_txnum,TO_DATE (v_txdate, 'DD/MM/YYYY'),'14',v_cancelqtty,NULL,NULL);
      INSERT INTO tllogfld(AUTOID,TXNUM,TXDATE,FLDCD,NVALUE,CVALUE,TXDESC)
      VALUES (seq_tllogfld.NEXTVAL,v_txnum,TO_DATE (v_txdate, 'DD/MM/YYYY'),'11',v_price,NULL,NULL);
      INSERT INTO tllogfld(AUTOID,TXNUM,TXDATE,FLDCD,NVALUE,CVALUE,TXDESC)
      VALUES (seq_tllogfld.NEXTVAL,v_txnum,TO_DATE (v_txdate, 'DD/MM/YYYY'),'12',v_quantity,NULL,NULL);
      --2 THEM VAO TRONG TLLOGFLD

      v_edstatus := 'S';
      UPDATE odmast
         SET edstatus = v_edstatus
      WHERE orderid = pv_orderid;
      update odmast set edstatus = v_edstatus
      where reforderid = pv_orderid and exectype = 'AB';
      --Cap nhat lenh sua thanh da Send.
      UPDATE OOD SET OODSTATUS = 'S' , TXTIME = TO_CHAR(SYSDATE,'HH24:MI:SS')
      WHERE ORGORDERID IN (SELECT ORDERID FROM ODMAST  WHERE REFORDERID = pv_orderid)
      and OODSTATUS <> 'S';
      UPDATE ODMAST SET ORSTATUS = '2' WHERE ORDERID IN (SELECT ORDERID FROM ODMAST  WHERE REFORDERID = pv_orderid)
                                       AND ORSTATUS = '8';


      --3 CAP NHAT TRAN VA MAST
      IF v_tltxcd = '8890'
      THEN

         --BUY
         v_BORS :='B';

         --2013.05.21 HNX sua lai day gia tri pv_LeavesQty < 0 neu sua giam khoi luong

        UPDATE odmast
        SET adjustqtty = v_replaceqtty - pv_LeavesQty ,
            remainqtty = v_OrderQtty_Cur + pv_LeavesQty - v_replaceqtty - v_ExecQtty_Cur
        WHERE orderid = pv_orderid;

         INSERT INTO odtran
                     (txnum, txdate,
                      acctno, txcd, namt, camt, acctref, deltd,
                      REF, autoid
                     )
              VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),
                      pv_orderid, '0014', v_cancelqtty, NULL, NULL, 'N',
                      NULL, seq_odtran.NEXTVAL
                     );

         INSERT INTO odtran
                     (txnum, txdate,
                      acctno, txcd, namt, camt, acctref, deltd,
                      REF, autoid
                     )
              VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),
                      pv_orderid, '0011', v_cancelqtty, NULL, NULL, 'N',
                      NULL, seq_odtran.NEXTVAL
                     );

      ELSE                                                   --v_tltxcd='8891'
         --SELL
         v_BORS :='S';
          /*If v_OrderQtty_Cur >=v_quantity Then --Sua giam khoi luong
                 UPDATE odmast
                     SET adjustqtty = v_replaceqtty + pv_LeavesQty ,
                            remainqtty = v_OrderQtty_Cur -  pv_LeavesQty - v_replaceqtty - v_ExecQtty_Cur
                  WHERE orderid = pv_orderid;
          Else
                     UPDATE odmast
                        SET adjustqtty = v_replaceqtty - pv_LeavesQty ,
                            remainqtty = v_OrderQtty_Cur + pv_LeavesQty - v_replaceqtty - v_ExecQtty_Cur
                      WHERE orderid = pv_orderid;
                 End if;*/
         UPDATE odmast
            SET adjustqtty = v_replaceqtty - pv_LeavesQty ,
                remainqtty = v_OrderQtty_Cur + pv_LeavesQty - v_replaceqtty - v_ExecQtty_Cur
          WHERE orderid = pv_orderid;

         INSERT INTO odtran
                     (txnum, txdate,
                      acctno, txcd, namt, camt, acctref, deltd,
                      REF, autoid
                     )
              VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),
                      pv_orderid, '0014', v_cancelqtty, NULL, NULL, 'N',
                      NULL, seq_odtran.NEXTVAL
                     );

         INSERT INTO odtran
                     (txnum, txdate,
                      acctno, txcd, namt, camt, acctref, deltd,
                      REF, autoid
                     )
              VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),
                      pv_orderid, '0011', v_cancelqtty, NULL, NULL, 'N',
                      NULL, seq_odtran.NEXTVAL
                     );
      END IF;


   --4 Sinh lenh moi.

     INSERT INTO ODMAST (ORDERID,CUSTID,ACTYPE,CODEID,AFACCTNO
                 ,SEACCTNO,CIACCTNO,
                 TXNUM,TXDATE,TXTIME,EXPDATE,BRATIO,TIMETYPE,
                 EXECTYPE,NORK,MATCHTYPE,VIA,CLEARDAY,CLEARCD,ORSTATUS,PORSTATUS,PRICETYPE,
                 QUOTEPRICE,STOPPRICE,LIMITPRICE,ORDERQTTY,REMAINQTTY,EXPRICE,EXQTTY,SECUREDAMT,
                 EXECQTTY,STANDQTTY,CANCELQTTY,ADJUSTQTTY,REJECTQTTY,REJECTCD,VOUCHER,CONSULTANT,REFORDERID,CORRECTIONNUMBER,TLID,DFACCTNO,
                 ISDISPOSAL,
                 retlid,blorderid,isblorder, isfo_order)
          VALUES ( v_ORDERID , v_CUSTID , v_ACTYPE , v_CODEID , v_afaccount
                  ,v_SEACCTNO ,v_afaccount
                  , v_TXNUM ,TO_DATE (v_txdate, 'DD/MM/YYYY'), v_TXTIME
                  ,TO_DATE (v_txdate, 'DD/MM/YYYY'),v_BRATIO ,v_TIMETYPE
                  ,v_EXECTYPE ,v_NORK ,v_MATCHTYPE ,v_VIA ,v_CLEARDAY , v_CLEARCD ,'2','2',v_PRICETYPE
                  ,v_amendmentprice ,0,v_LIMITPRICE ,v_ReplaceQTTY,v_ReplaceQTTY ,v_amendmentprice ,v_ReplaceQTTY,0
                  ,0,0,0,0,0,'001', v_VOUCHER , v_CONSULTANT , pv_orderid , 1, v_tlid, v_DFACCTNO,
                  v_ISDISPOSAL,v_retlid,v_blorderid,v_isblorder, 'Y');

       --Ghi nhan vao so lenh day di
       INSERT INTO OOD (ORGORDERID,CODEID,SYMBOL,CUSTODYCD,
            BORS,NORP,AORN,PRICE,QTTY,SECUREDRATIO,OODSTATUS,
            TXDATE,TXTIME,TXNUM,DELTD,BRID,REFORDERID)
            VALUES ( v_ORDERID , v_CODEID , v_Symbol ,Replace(v_CUSTODYCD,'.',''),
            v_BORS ,v_MATCHTYPE ,v_NORK ,v_amendmentprice ,v_ReplaceQTTY ,v_BRATIO ,'S' ,
            TO_DATE (v_txdate, 'DD/MM/YYYY'),  v_TXTIME , v_TXNUM ,'N',v_BRID , pv_orderid );

        --Tao ban ghi trong ODQUEUE,ODQUEUELOG xac nhan lenh da day len san
        INSERT INTO ODQUEUE SELECT * FROM OOD WHERE ORGORDERID =  v_ORDERID;
        INSERT INTO ODQUEUELOG SELECT * FROM OOD WHERE ORGORDERID = v_ORDERID;
        --Cap nhat lai ODRERMAP_HA theo so hieu lenh moi cua lenh sua.
        Update Ordermap_ha set rejectcode =  orgorderid where orgorderid =pv_orderid;
        Update Ordermap_ha set orgorderid =  v_ORDERID where orgorderid =pv_orderid;
        --Cap nhat lai so hieu lenh map voi FO.
        UPDATE newfo_ordermap SET BOORDERID =  v_ORDERID , PBOORDERID =  BOORDERID
        where foorderid =pv_ordernumber AND txdate = TO_DATE (v_txdate, systemnums.c_date_format);

        Begin
            IF v_tltxcd = '8890' THEN
                if fn_markedafpralloc(v_afaccount,
                            null,
                            'A',
                            'T',
                            null,
                            'N',
                            'Y',
                            TO_DATE (v_txdate, 'DD/MM/YYYY'),
                            v_txnum,
                            v_err) <>systemnums.C_SUCCESS
                Then
                            NULL;
               End if;
            END IF;
         EXCEPTION when OTHERS then
          null;
         End;
 --Cap nhat cho GTC
   OPEN C_ODMAST(pv_orderid);
   FETCH C_ODMAST INTO VC_ODMAST;
    IF C_ODMAST%FOUND THEN
        --LENH YEU CAU GTO SE BI HUY, DO LENH CON TREN SAN DA THAY DOI
        UPDATE FOMAST SET DELTD='Y' WHERE ORGACCTNO= pv_orderid;

        INSERT INTO FOMAST (ACCTNO, ORGACCTNO, ACTYPE, AFACCTNO, STATUS, EXECTYPE, PRICETYPE,
                    TIMETYPE, MATCHTYPE, NORK, CLEARCD, CODEID, SYMBOL, CONFIRMEDVIA,
                    BOOK, FEEDBACKMSG, ACTIVATEDT, CREATEDDT,
                    CLEARDAY, QUANTITY, PRICE, QUOTEPRICE,
                    TRIGGERPRICE, EXECQTTY, EXECAMT, REMAINQTTY,TXDATE,TXNUM,
                    EFFDATE,EXPDATE,BRATIO,VIA,OUTPRICEALLOW,TLID)
             SELECT v_ORDERID,v_ORDERID,v_ACTYPE,v_afaccount,'A',EXECTYPE,v_PRICETYPE,
                    v_TIMETYPE,v_MATCHTYPE,v_NORK,CLEARCD,v_CODEID,v_Symbol,'N'
                    ,'A','',TO_CHAR(SYSDATE,'DD/MM/RRRR HH:MM:SS'),TO_CHAR(SYSDATE,'DD/MM/RRRR HH:MM:SS'),
                    v_CLEARDAY ,v_ReplaceQTTY, v_amendmentprice/ v_tradeunit ,v_amendmentprice / v_tradeunit ,
                     0 , 0 , 0 ,v_ReplaceQTTY ,TO_DATE(v_txdate, 'dd/mm/rrrr'),v_TXNUM,
                    EFFDATE,EXPDATE,v_BRATIO,v_VIA,OUTPRICEALLOW,TLID
                    FROM FOMAST WHERE ORGACCTNO= pv_orderid;

    END IF;
   CLOSE C_ODMAST;

   COMMIT;

   p_err_code := 0;
   p_err_message:= 'Sucessfull!';
   plog.setendsection (pkgctx, 'CONFIRM_REPLACE_EXEC');

EXCEPTION
   WHEN v_ex
   THEN
   ROLLBACK;

   plog.debug (pkgctx, ' CONFIRM_REPLACE_EXEC pv_ordernumber v_ex'||v_err
                                  );
   plog.setendsection (pkgctx, 'CONFIRM_REPLACE_EXEC');
   p_err_code := 1;

 WHEN
  OTHERS
   THEN

   ROLLBACK;
    plog.debug (pkgctx, ' CONFIRM_REPLACE_EXEC pv_ordernumber '||v_err
                                  );
    plog.setendsection (pkgctx, 'CONFIRM_REPLACE_EXEC');
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
END;

PROCEDURE confirm_send_order_2LO (
   pv_orderid   IN   VARCHAR2,
   pv_qtty      IN   NUMBER,
   pv_price     IN   NUMBER,
   p_err_code  OUT varchar2,
   p_err_message  OUT varchar2
)
IS
   v_ex        EXCEPTION;
   v_txdate    Varchar2(30);
   v_order_number  Varchar2(50);
   v_strlog       Varchar2(4000);

BEGIN
      plog.setbeginsection (pkgctx, 'confirm_send_order_2LO');
      v_strlog:=' confirm_send_order_2LO 1 pv_orderid '||pv_orderid
                                                  ||'pv_qtty  '||pv_qtty
                                                  ||'pv_price  '||pv_price ;
   INSERT INTO t_fo_logcallws(id , tltxcd , acctno, strmsg , logtime)
                                       VALUES(seq_fo_logcallws.NEXTVAL, 'confirm_send_order_2LO', pv_orderid, v_strlog, SYSTIMESTAMP);
   COMMIT;

   INSERT INTO t_fo_exec (
                           exectype,
                           orderid,
                           lastqty,
                           lastpx,
                           receivetime,
                           id,
                           process
                           )
        VALUES (
            'CFOD2LO',  --Confirm Order 2 LO
            pv_orderid,
            pv_qtty,
            pv_price,
            systimestamp,
            SEQ_FO_EXEC.NEXTVAL,
            'N'
            );
    COMMIT;
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
    plog.setendsection (pkgctx, 'confirm_send_order_2LO');

END confirm_send_order_2LO;

PROCEDURE confirm_send_order_2LO_exec (
   pv_orderid   IN   VARCHAR2,
   pv_qtty      IN   NUMBER,
   pv_price     IN   NUMBER,
   p_err_code  OUT varchar2,
   p_err_message  OUT varchar2
)
IS
   v_ex        EXCEPTION;
   v_txdate    Varchar2(30);
   v_order_number  Varchar2(50);
   v_strlog       Varchar2(4000);

BEGIN
      plog.setbeginsection (pkgctx, 'confirm_send_order_2LO');
      v_strlog:=' confirm_send_order_2LO 1 pv_orderid '||pv_orderid
                                                  ||'pv_qtty  '||pv_qtty
                                                  ||'pv_price  '||pv_price ;
     p_err_code := 0;
     p_err_message:= 'Sucessfull!';

      BEGIN
       SELECT varvalue
         INTO v_txdate
         FROM sysvar
       WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

       SELECT boorderid
            INTO v_order_number
            FROM newfo_ordermap
           WHERE foorderid = PV_ORDERID
            AND txdate = TO_DATE (v_txdate, systemnums.c_date_format);


      EXCEPTION WHEN OTHERS THEN
          plog.debug(pkgctx,'confirm_send_order_2LO: Khong tim thay lenh goc  '||pv_orderid);
      END;

      --Cap nhat lai gia cua lenh goc = gia cua lenh LO do San gui ve
      UPDATE ODMAST SET Quoteprice = pv_price, exprice =pv_price
      WHERE ORDERID = v_order_number;


    COMMIT;
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
    plog.setendsection (pkgctx, 'confirm_send_order_2LO');

   EXCEPTION
       WHEN v_ex
       THEN
       --plog.debug (pkgctx, ' confirm_send_order_2LO v_ex sqlerrm '||sqlerrm);
       p_err_code := -100879;
       p_err_message:= 'Loi khong tim thay lenh goc!';
       plog.setendsection (pkgctx, 'confirm_send_order_2LO');
   WHEN
    OTHERS
     THEN

      ROLLBACK;

      --plog.debug (pkgctx, ' confirm_send_order_2LO sqlerrm '||sqlerrm
      --                            );
      plog.setendsection (pkgctx, 'confirm_send_order_2LO');

      p_err_code := -100800; --File du lieu dau vao khong hop le
      p_err_message:= 'System error. Invalid file format';

END confirm_send_order_2LO_exec;

PROCEDURE confirm_send_order (
   pv_orderid   IN   VARCHAR2,
   p_err_code  OUT varchar2,
   p_err_message  OUT varchar2
)
IS
    v_txdate    Varchar2(30);
    v_ex        EXCEPTION;
    v_order_number varchar2(50);
    v_err       VARCHAR2(300);
    v_strlog    VARCHAR2(4000);
    v_firm      Varchar2(30);
    v_side      Varchar2(30);
BEGIN
    plog.setbeginsection (pkgctx, 'confirm_send_order');
    v_strlog := ' confirm_send_order 1 pv_orderid '||pv_orderid
                                  ;
    INSERT INTO t_fo_logcallws(id , tltxcd , acctno, strmsg , logtime)
                                       VALUES(seq_fo_logcallws.NEXTVAL, 'confirm_send_order', pv_orderid, v_strlog, SYSTIMESTAMP);
    COMMIT;


    INSERT INTO t_fo_exec (
                           exectype,
                           orderid,
                           receivetime,
                           id,
                           process
                           )
        VALUES (
            'CFOD',  --Confirm Order
            pv_orderid,
            systimestamp,
            SEQ_FO_EXEC.NEXTVAL,
            'N'
            );

    COMMIT;
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
    plog.setendsection (pkgctx, 'confirm_send_order');
END confirm_send_order;



PROCEDURE confirm_send_order_exec (
   pv_orderid   IN   VARCHAR2,
   p_err_code   OUT varchar2,
   p_err_message  OUT varchar2
)
IS
    v_txdate    Varchar2(30);
    v_ex        EXCEPTION;
    v_order_number varchar2(50);
    v_err       VARCHAR2(300);
    v_strlog    VARCHAR2(4000);
    v_firm      Varchar2(30);
    v_side      Varchar2(30);
    v_count     Varchar2(30);
BEGIN
    plog.setbeginsection (pkgctx, 'confirm_send_order_exec');
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';

    SELECT varvalue
        INTO v_txdate
        FROM sysvar
       WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
   begin
    SELECT boorderid
            INTO v_order_number
            FROM newfo_ordermap
           WHERE foorderid = PV_ORDERID
            AND txdate = TO_DATE (v_txdate, systemnums.c_date_format);
    EXCEPTION WHEN OTHERS THEN
    --plog.debug (pkgctx, ' confirm_send_order2 pv_orderid '||pv_orderid
    --                              );
    RAISE v_ex;
    END;
    SELECT count(*)INTO  v_Count FROM ood  WHERE orgorderid = v_order_number AND oodstatus <> 'N';
    IF v_Count >=1 THEN
      p_err_code := 0;
      p_err_message:= 'Sucessfull!';
      RETURN;
    END IF;

    UPDATE odmast SET orstatus = '2' WHERE orderid = v_order_number And txdate = TO_DATE (v_txdate, systemnums.c_date_format);
    UPDATE ood SET oodstatus = 'S', TXTIME = TO_CHAR(SYSDATE,'HH24:MI:SS') where orgorderid = v_order_number And txdate = TO_DATE (v_txdate, systemnums.c_date_format);
    INSERT INTO ODQUEUE SELECT * FROM ood WHERE orgorderid = v_order_number;

    --Kiem tra: neu la lenh thoa thuan ban, thi insert vao ORDERPTACK
    BEGIN
      Begin
        Select SYSVALUE Into v_Firm from ordersys_ha where SYSNAME ='FIRM';
      Exception When others THEN

        v_Firm:='0';
      End;


     FOR j IN (SELECT f.*, c.custodycd  FROM fomast f, afmast a, cfmast c
                      WHERE a.custid = c.custid AND f.AFACCTNO= a.acctno AND  f.forefid = PV_ORDERID)
     LOOP

        IF   j.MATCHTYPE ='P' AND j.EXECTYPE ='NS' THEN

           INSERT INTO orderptack
                (TIMESTAMP, messagetype, firm, buyertradeid,
                 side, sellercontrafirm, sellertradeid, securitysymbol, volume,
                 price, board, confirmnumber, offset, status, issend,
                 ordernumber, brid, tlid,
                 txtime, ipaddress, trading_date,
                 sclientid
                )
         VALUES (TO_CHAR (SYSDATE, 'HH24MISS'), 's', j.CONTRAFIRM, j.TRADERID,
                 'S', v_Firm, '', j.symbol, j.CLIENTID,
                 j.PRICE*1000, '', pv_orderid, '', 'N', 'N',
                 '' , '', ''
                 , TO_CHAR (SYSDATE, 'hh24miss'), '', TRUNC (SYSDATE),
                 j.custodycd
                );
       END IF;
     END LOOP;

    EXCEPTION WHEN OTHERS THEN
    plog.debug (pkgctx, ' Loi insert lenh thoa thuan ban'||pv_orderid
                                  );
    END;

    COMMIT;
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
    plog.setendsection (pkgctx, 'confirm_send_order_exec');
    EXCEPTION
       WHEN v_ex
       THEN
       --plog.debug (pkgctx, ' confirm_send_order v_ex sqlerrm '||sqlerrm);
       p_err_code := -100879;
       p_err_message:= 'Loi khong tim thay lenh goc!';
       plog.setendsection (pkgctx, 'confirm_send_order_exec');
   WHEN
    OTHERS
     THEN

      ROLLBACK;

      plog.debug (pkgctx, ' confirm_send_order sqlerrm '||sqlerrm
                                  );
      plog.setendsection (pkgctx, 'confirm_send_order_exec');

      p_err_code := -100800; --File du lieu dau vao khong hop le
      p_err_message:= 'System error. Invalid file format';
END confirm_send_order_exec;

FUNCTION fn_GenFOMsg(p_txmsg in out tx.msg_rectype,p_err_code in out varchar2,p_err_param out varchar2)
RETURN NUMBER
IS
   l_return_code VARCHAR2(30) := systemnums.C_SUCCESS;
   v_strFOMSG varchar2(4000);
   v_strTXDATE varchar2(20);
   v_strTXNUM varchar2(40);
BEGIN

   for rec in
   (
       Select txcode, acctno, amount, extra, qtty, codeid, doc, symbol from fotxmap where tltxcd = p_txmsg.tltxcd
   )
   loop
        Select msgformat into v_strFOMSG from fotxformat where txcode = rec.txcode And Status = 'Y';

        if trim(rec.acctno) is not null then
            v_strFOMSG := replace(v_strFOMSG, '<$ACCTNO>',p_txmsg.txfields (rec.acctno).VALUE);
        else
            v_strFOMSG := replace(v_strFOMSG, '<$ACCTNO>','');
        end if;

        if trim(rec.txcode) is not null then
            v_strFOMSG := replace(v_strFOMSG, '<$TXCODE>',p_txmsg.txfields (rec.txcode).VALUE);
        else
            v_strFOMSG := replace(v_strFOMSG, '<$TXCODE>','');
        end if;

        if trim(rec.amount) is not null then
            v_strFOMSG := replace(v_strFOMSG, '<$AMOUNT>',p_txmsg.txfields (rec.amount).VALUE);
        else
            v_strFOMSG := replace(v_strFOMSG, '<$AMOUNT>','0');
        end if;

        if trim(rec.extra) is not null then
            v_strFOMSG := replace(v_strFOMSG, '<$FEE>',p_txmsg.txfields (rec.extra).VALUE);
        else
            v_strFOMSG := replace(v_strFOMSG, '<$FEE>','0');
        end if;

        if trim(rec.qtty) is not null then
            v_strFOMSG := replace(v_strFOMSG, '<$QTTY>',p_txmsg.txfields (rec.qtty).VALUE);
        else
            v_strFOMSG := replace(v_strFOMSG, '<$QTTY>','0');
        end if;

        if trim(rec.codeid) is not null then
            v_strFOMSG := replace(v_strFOMSG, '<$CODEID>',p_txmsg.txfields (rec.codeid).VALUE);
        else
            v_strFOMSG := replace(v_strFOMSG, '<$CODEID>','');
        end if;

        if trim(rec.txcode) is not null then
            v_strFOMSG := replace(v_strFOMSG, '<$MSGTYPE>',p_txmsg.txfields (rec.txcode).VALUE);
        else
            v_strFOMSG := replace(v_strFOMSG, '<$MSGTYPE>','');
        end if;

        if trim(rec.symbol) is not null then
            v_strFOMSG := replace(v_strFOMSG, '<$SYMBOL>',p_txmsg.txfields (rec.symbol).VALUE);
        else
            v_strFOMSG := replace(v_strFOMSG, '<$SYMBOL>','');
        end if;

        if trim(rec.doc) is not null then
            v_strFOMSG := replace(v_strFOMSG, '<$COD>',rec.doc);
        else
            v_strFOMSG := replace(v_strFOMSG, '<$COD>','');
        end if;

        Select getcurrdate into v_strTXDATE from dual;
        Select systemnums.C_BATCH_PREFIXED
                                 || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0') into v_strTXNUM From dual;

        INSERT INTO fotxreq (reqid, txdate, txnum, txmsg, status)
        (SELECT seq_fotxreq.NEXTVAL, v_strTXDATE, v_strTXNUM,v_strFOMSG,'N' From dual);

   end loop;


    RETURN l_return_code;
EXCEPTION
   WHEN errnums.E_BIZ_RULE_INVALID
   THEN
      FOR I IN (
           SELECT ERRDESC,EN_ERRDESC FROM deferror
           WHERE ERRNUM= p_err_code
      ) LOOP
           p_err_param := i.errdesc;
      END LOOP;
      plog.setendsection (pkgctx, 'fn_GenFOMsg');
      RETURN errnums.C_BIZ_RULE_INVALID;
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_param := 'SYSTEM_ERROR';
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'fn_GenFOMsg');
      RETURN errnums.C_SYSTEM_ERROR;
END fn_GenFOMsg;

PROCEDURE pr_txlog8876(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
IS
BEGIN
plog.setbeginsection (pkgctx, 'pr_txlog8876');
   --plog.debug(pkgctx, 'abt to insert into tllog, txnum: ' || p_txmsg.txnum);
   INSERT INTO tllog(autoid, txnum, txdate, txtime, brid, tlid,offid, ovrrqs, chid, chkid, tltxcd, ibt, brid2, tlid2, ccyusage,off_line, deltd, brdate, busdate, txdesc, ipaddress,wsname, txstatus, msgsts, ovrsts, batchname, msgamt,msgacct, chktime, offtime, reftxnum)
       VALUES(
       seq_tllog.NEXTVAL,
       p_txmsg.txnum,
       TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
       p_txmsg.txtime,
       p_txmsg.brid,
       p_txmsg.tlid,
       p_txmsg.offid,
       p_txmsg.ovrrqd,
       p_txmsg.chid,
       p_txmsg.chkid,
       p_txmsg.tltxcd,
       p_txmsg.ibt,
       p_txmsg.brid2,
       p_txmsg.tlid2,
       p_txmsg.ccyusage,
       p_txmsg.off_line,
       p_txmsg.deltd,
       TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
       TO_DATE(p_txmsg.busdate, systemnums.C_DATE_FORMAT),
       NVL(p_txmsg.txfields('30').value,p_txmsg.txdesc),
       p_txmsg.ipaddress,
       p_txmsg.wsname,
       p_txmsg.txstatus,
       p_txmsg.msgsts,
       p_txmsg.ovrsts,
       p_txmsg.batchname,
       p_txmsg.txfields('12').value*p_txmsg.txfields('11').value*p_txmsg.txfields('98').value ,
       p_txmsg.txfields('03').value ,
       TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT), --decode(p_txmsg.chkid,NULL,TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT,p_txmsg.chkid)),
       TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT), --decode(p_txmsg.offtime,NULL,TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT,p_txmsg.offtime)),
       p_txmsg.reftxnum);
       plog.setendsection (pkgctx, 'pr_txlog8876');
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
       plog.setendsection (pkgctx, 'pr_txlog8876');
      RAISE errnums.E_SYSTEM_ERROR;
END pr_txlog8876;


PROCEDURE pr_txlog8877(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
IS
BEGIN
plog.setbeginsection (pkgctx, 'pr_txlog8877');
   --plog.debug(pkgctx, 'abt to insert into tllog, txnum: ' || p_txmsg.txnum);
   INSERT INTO tllog(autoid, txnum, txdate, txtime, brid, tlid,offid, ovrrqs, chid, chkid, tltxcd, ibt, brid2, tlid2, ccyusage,off_line, deltd, brdate, busdate, txdesc, ipaddress,wsname, txstatus, msgsts, ovrsts, batchname, msgamt,msgacct, chktime, offtime)
       VALUES(
       seq_tllog.NEXTVAL,
       p_txmsg.txnum,
       TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
       p_txmsg.txtime,
       p_txmsg.brid,
       p_txmsg.tlid,
       p_txmsg.offid,
       p_txmsg.ovrrqd,
       p_txmsg.chid,
       p_txmsg.chkid,
       p_txmsg.tltxcd,
       p_txmsg.ibt,
       p_txmsg.brid2,
       p_txmsg.tlid2,
       p_txmsg.ccyusage,
       p_txmsg.off_line,
       p_txmsg.deltd,
       TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
       TO_DATE(p_txmsg.busdate, systemnums.C_DATE_FORMAT),
       NVL(p_txmsg.txfields('30').value,p_txmsg.txdesc),
       p_txmsg.ipaddress,
       p_txmsg.wsname,
       p_txmsg.txstatus,
       p_txmsg.msgsts,
       p_txmsg.ovrsts,
       p_txmsg.batchname,
       p_txmsg.txfields('12').value ,
       p_txmsg.txfields('03').value ,
       TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT), --decode(p_txmsg.chkid,NULL,TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT,p_txmsg.chkid)),
       TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT) --decode(p_txmsg.offtime,NULL,TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT,p_txmsg.offtime))
       );



   plog.setendsection (pkgctx, 'pr_txlog8877');
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
       plog.setendsection (pkgctx, 'pr_txlog8877');
      RAISE errnums.E_SYSTEM_ERROR;
END pr_txlog8877;



PROCEDURE pr_txlog8882(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
IS
BEGIN
plog.setbeginsection (pkgctx, 'pr_txlog8882');
   --plog.debug(pkgctx, 'abt to insert into tllog, txnum: ' || p_txmsg.txnum);
   INSERT INTO tllog(autoid, txnum, txdate, txtime, brid, tlid,offid, ovrrqs, chid, chkid, tltxcd, ibt, brid2, tlid2, ccyusage,off_line, deltd, brdate, busdate, txdesc, ipaddress,wsname, txstatus, msgsts, ovrsts, batchname, msgamt,msgacct, chktime, offtime)
       VALUES(
       seq_tllog.NEXTVAL,
       p_txmsg.txnum,
       TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
       p_txmsg.txtime,
       p_txmsg.brid,
       p_txmsg.tlid,
       p_txmsg.offid,
       p_txmsg.ovrrqd,
       p_txmsg.chid,
       p_txmsg.chkid,
       p_txmsg.tltxcd,
       p_txmsg.ibt,
       p_txmsg.brid2,
       p_txmsg.tlid2,
       p_txmsg.ccyusage,
       p_txmsg.off_line,
       p_txmsg.deltd,
       TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
       TO_DATE(p_txmsg.busdate, systemnums.C_DATE_FORMAT),
       NVL(p_txmsg.txfields('30').value,p_txmsg.txdesc),
       p_txmsg.ipaddress,
       p_txmsg.wsname,
       p_txmsg.txstatus,
       p_txmsg.msgsts,
       p_txmsg.ovrsts,
       p_txmsg.batchname,
       p_txmsg.txfields('11').value*p_txmsg.txfields('12').value*p_txmsg.txfields('13').value*p_txmsg.txfields('98').value/p_txmsg.txfields('99').value ,
       p_txmsg.txfields('03').value ,
       TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT), --decode(p_txmsg.chkid,NULL,TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT,p_txmsg.chkid)),
       TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT) --decode(p_txmsg.offtime,NULL,TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT,p_txmsg.offtime))
       );
   plog.setendsection (pkgctx, 'pr_txlog8882');
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
       plog.setendsection (pkgctx, 'pr_txlog8882');
      RAISE errnums.E_SYSTEM_ERROR;
END pr_txlog8882;--


PROCEDURE pr_txlog8883(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
IS
BEGIN
plog.setbeginsection (pkgctx, 'pr_txlog8883');
   --plog.debug(pkgctx, 'abt to insert into tllog, txnum: ' || p_txmsg.txnum);
   INSERT INTO tllog(autoid, txnum, txdate, txtime, brid, tlid,offid, ovrrqs, chid, chkid, tltxcd, ibt, brid2, tlid2, ccyusage,off_line, deltd, brdate, busdate, txdesc, ipaddress,wsname, txstatus, msgsts, ovrsts, batchname, msgamt,msgacct, chktime, offtime)
       VALUES(
       seq_tllog.NEXTVAL,
       p_txmsg.txnum,
       TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
       p_txmsg.txtime,
       p_txmsg.brid,
       p_txmsg.tlid,
       p_txmsg.offid,
       p_txmsg.ovrrqd,
       p_txmsg.chid,
       p_txmsg.chkid,
       p_txmsg.tltxcd,
       p_txmsg.ibt,
       p_txmsg.brid2,
       p_txmsg.tlid2,
       p_txmsg.ccyusage,
       p_txmsg.off_line,
       p_txmsg.deltd,
       TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
       TO_DATE(p_txmsg.busdate, systemnums.C_DATE_FORMAT),
       NVL(p_txmsg.txfields('30').value,p_txmsg.txdesc),
       p_txmsg.ipaddress,
       p_txmsg.wsname,
       p_txmsg.txstatus,
       p_txmsg.msgsts,
       p_txmsg.ovrsts,
       p_txmsg.batchname,
       p_txmsg.txfields('12').value ,
       p_txmsg.txfields('03').value ,
       TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT), --decode(p_txmsg.chkid,NULL,TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT,p_txmsg.chkid)),
       TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT) --decode(p_txmsg.offtime,NULL,TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT,p_txmsg.offtime))
       );

   plog.setendsection (pkgctx, 'pr_txlog8883');
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
       plog.setendsection (pkgctx, 'pr_txlog8883');
      RAISE errnums.E_SYSTEM_ERROR;
END pr_txlog8883;--


PROCEDURE pr_txlog8884(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
IS
BEGIN
plog.setbeginsection (pkgctx, 'pr_txlog8884');
   --plog.debug(pkgctx, 'abt to insert into tllog, txnum: ' || p_txmsg.txnum);
   INSERT INTO tllog(autoid, txnum, txdate, txtime, brid, tlid,offid, ovrrqs, chid, chkid, tltxcd, ibt, brid2, tlid2, ccyusage,off_line, deltd, brdate, busdate, txdesc, ipaddress,wsname, txstatus, msgsts, ovrsts, batchname, msgamt,msgacct, chktime, offtime)
       VALUES(
       seq_tllog.NEXTVAL,
       p_txmsg.txnum,
       TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
       p_txmsg.txtime,
       p_txmsg.brid,
       p_txmsg.tlid,
       p_txmsg.offid,
       p_txmsg.ovrrqd,
       p_txmsg.chid,
       p_txmsg.chkid,
       p_txmsg.tltxcd,
       p_txmsg.ibt,
       p_txmsg.brid2,
       p_txmsg.tlid2,
       p_txmsg.ccyusage,
       p_txmsg.off_line,
       p_txmsg.deltd,
       TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
       TO_DATE(p_txmsg.busdate, systemnums.C_DATE_FORMAT),
       NVL(p_txmsg.txfields('30').value,p_txmsg.txdesc),
       p_txmsg.ipaddress,
       p_txmsg.wsname,
       p_txmsg.txstatus,
       p_txmsg.msgsts,
       p_txmsg.ovrsts,
       p_txmsg.batchname,
       p_txmsg.txfields('11').value*p_txmsg.txfields('12').value*p_txmsg.txfields('13').value*p_txmsg.txfields('98').value/p_txmsg.txfields('99').value ,
       p_txmsg.txfields('03').value ,
       TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT), --decode(p_txmsg.chkid,NULL,TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT,p_txmsg.chkid)),
       TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT) --decode(p_txmsg.offtime,NULL,TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT,p_txmsg.offtime))
       );


   plog.setendsection (pkgctx, 'pr_txlog8884');
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
       plog.setendsection (pkgctx, 'pr_txlog8884');
      RAISE errnums.E_SYSTEM_ERROR;
END pr_txlog8884;--



PROCEDURE pr_txlog8885(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
IS
BEGIN
plog.setbeginsection (pkgctx, 'pr_txlog8885');
   --plog.debug(pkgctx, 'abt to insert into tllog, txnum: ' || p_txmsg.txnum);
   INSERT INTO tllog(autoid, txnum, txdate, txtime, brid, tlid,offid, ovrrqs, chid, chkid, tltxcd, ibt, brid2, tlid2, ccyusage,off_line, deltd, brdate, busdate, txdesc, ipaddress,wsname, txstatus, msgsts, ovrsts, batchname, msgamt,msgacct, chktime, offtime)
       VALUES(
       seq_tllog.NEXTVAL,
       p_txmsg.txnum,
       TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
       p_txmsg.txtime,
       p_txmsg.brid,
       p_txmsg.tlid,
       p_txmsg.offid,
       p_txmsg.ovrrqd,
       p_txmsg.chid,
       p_txmsg.chkid,
       p_txmsg.tltxcd,
       p_txmsg.ibt,
       p_txmsg.brid2,
       p_txmsg.tlid2,
       p_txmsg.ccyusage,
       p_txmsg.off_line,
       p_txmsg.deltd,
       TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
       TO_DATE(p_txmsg.busdate, systemnums.C_DATE_FORMAT),
       NVL(p_txmsg.txfields('30').value,p_txmsg.txdesc),
       p_txmsg.ipaddress,
       p_txmsg.wsname,
       p_txmsg.txstatus,
       p_txmsg.msgsts,
       p_txmsg.ovrsts,
       p_txmsg.batchname,
       p_txmsg.txfields('12').value ,
       p_txmsg.txfields('03').value ,
       TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT), --decode(p_txmsg.chkid,NULL,TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT,p_txmsg.chkid)),
       TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT) --decode(p_txmsg.offtime,NULL,TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT,p_txmsg.offtime))
       );


   plog.setendsection (pkgctx, 'pr_txlog8885');
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
       plog.setendsection (pkgctx, 'pr_txlog8885');
      RAISE errnums.E_SYSTEM_ERROR;
END pr_txlog8885;--



PROCEDURE pr_HoldBank
    ( pv_reqnumber VARCHAR2,
      pv_account  VARCHAR2,
      pv_amt  number,
      p_ERR_CODE  IN OUT VARCHAR2,
      p_ERR_MESSAGE  IN OUT VARCHAR2
    )
IS
  V_BANKACCT      VARCHAR2 (50);
  V_BANKCODE      VARCHAR2 (50);
  V_REFCODE       VARCHAR2 (50);
  l_return_code VARCHAR2(30) := systemnums.C_SUCCESS;
  v_strlog        VARCHAR2 (4000);
  v_requestid    number(20);
BEGIN

  plog.setbeginsection (pkgctx, 'pr_HoldBank');
  v_strlog :='pr_HoldBank pv_reqnumber =>'''||pv_reqnumber
                                            ||''', pv_account =>'''||pv_account
                                            ||''', pv_amt =>'''||pv_amt
                                            ||''', p_ERR_CODE =>'''||p_ERR_CODE
                                            ||''', p_ERR_MESSAGE =>'''||p_ERR_MESSAGE

                                      ;
      INSERT INTO t_fo_logcallws(id , tltxcd , acctno, strmsg , logtime)
                                       VALUES(seq_fo_logcallws.NEXTVAL, 'pr_HoldBank', pv_account, v_strlog, SYSTIMESTAMP);
      COMMIT;

      Begin

        SELECT TO_CHAR(getcurrdate, 'DD/MM/YYYY') || pv_reqnumber INTO V_REFCODE FROM DUAL;
        SELECT BANKACCTNO, BANKNAME INTO V_BANKACCT, V_BANKCODE from afmast WHERE ACCTNO = pv_account;
      exception
      when NO_DATA_FOUND then
        raise errnums.E_BIZ_RULE_INVALID;
      end;

    if NVL(V_BANKACCT, 'ZZZ') = 'ZZZ' then
        p_ERR_CODE := '-100078';
        SELECT errdesc into p_ERR_MESSAGE From deferror where errnum = p_ERR_CODE;
    else
        --T?o y?c?u HOLD g?i sang Bank. REFCODE=V_REFCODE

         SELECT SEQ_CRBTXREQ.NEXTVAL INTO  v_requestid FROM dual;

         INSERT INTO newfo_CRBTXREQMAP(foreq, reqid) VALUES (pv_reqnumber,v_requestid);

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
                SELECT   --TO_NUMBER(pv_reqnumber),
                         v_requestid,
                         'V',
                         'NEWFO',
                         'HOLD',
                         V_REFCODE,
                         V_REFCODE,
                         GETCURRDATE,
                         GETCURRDATE,
                         V_BANKCODE,
                         V_BANKACCT,
                         pv_account,
                         pv_amt,
                         'P',
                         NULL,
                         NULL,
                         NULL,
                         NULL
                  FROM   DUAL;



      p_ERR_CODE:= l_return_code;
      p_ERR_MESSAGE:='OK';
    end if;

  plog.setendsection (pkgctx, 'pr_HoldBank');
EXCEPTION
        WHEN OTHERS
        THEN
            p_err_code := errnums.C_SYSTEM_ERROR;
            plog.error (pkgctx, SQLERRM);
            plog.setendsection (pkgctx, 'pr_HoldBank');
            RAISE errnums.E_SYSTEM_ERROR;
END;


PROCEDURE confirm_release_order (
   pv_orderid   IN   VARCHAR2,
   pv_qtty      IN   NUMBER,
   p_err_code  OUT varchar2,
   p_err_message  OUT varchar2
) IS
BEGIN
  confirm_cancel_normal_order(pv_orderid,pv_qtty,p_err_code,p_err_message);
END;

PROCEDURE prc_Process_exec
IS
 p_err_code varchar2(1000);
 p_err_message varchar2(1000);
 v_forefid_contra varchar2(100);
 v_matchtype      varchar2(100);
 v_exectype       varchar2(100);
 v_confirm_no     varchar2(100);
BEGIN
   IF  NOT fopks_api.fn_is_ho_active  THEN
    RETURN;
   END IF;
   plog.setbeginsection (pkgctx, 'prc_Process_exec');
   FOR m IN (

               SELECT id FROM
                 (
               SELECT id, ROWNUM rn FROM (
                  SELECT id FROM T_FO_REICEIVEORDER WHERE process ='N'
                    UNION ALL
                  SELECT id FROM T_FO_EXEC WHERE process ='N'
                  )
                  ORDER BY id
                  )
                  WHERE RN <100
           )
    LOOP
       FOR j IN (SELECT * FROM t_fo_reiceiveorder WHERE id =m.ID)
       LOOP
        BEGIN
         plog.debug (pkgctx, 'prc_Process_exec ID '||m.ID ||' msgtype '||j.msgtype);
         IF j.msgtype ='NEWOD' THEN
           pr_OrderInsert_Exec
                ( j.orderId,
                  j.acctno,
                  j.symbol,
                  j.actype,
                  j.txnum ,
                  j.txdate,
                  j.txtime,
                  j.exectype,
                  j.matchtype,
                  j.via     ,
                  j.clearday,
                  j.status  ,
                  j.pricetype,
                  j.quoteprice,
                  j.orderqtty,
                  j.userid,
                  p_err_code,
                  p_err_message,
                  j.CONTRAFIRM ,
                  j.TRADERID ,
                  j.CLIENTID ,
                  j.ISDISPOSAL
                 );
         ELSIF j.msgtype ='EDITOD' THEN
         pr_EditOrder_Exec
          (
            j.OrderIdEdit,
            j.OrderId,
            j.acctno ,
            j.EditQTTY ,
            j.EditPrice ,
            j.via ,
            j.userid ,
            j.txdate ,
            p_err_code,
            p_err_message
          );
         ELSIF j.msgtype ='CANCELOD' THEN
            pr_CancelOrder_Exec(
            j.OrderIdCancel,
            j.OrderId ,
            j.acctno ,
            j.CancelQTTY ,
            j.via ,
            j.userid ,
            j.txdate ,
            p_err_code,
            p_err_message
            );
         END IF;
         IF p_err_code = '0' THEN
           UPDATE  t_fo_reiceiveorder  SET process  ='Y' WHERE id  =j.id;
         ELSE
           UPDATE  t_fo_reiceiveorder  SET process  ='E', errmsg = p_err_code||':'||p_err_message  WHERE id  =j.id;
         END IF;

         EXCEPTION WHEN OTHERS THEN
            UPDATE  t_fo_reiceiveorder  SET process  ='E', errmsg = p_err_code||':'||p_err_message WHERE id  =j.id;
         END;
         COMMIT;
       END LOOP;

  /* UPDATE t_fo_exec t SET process ='N'
   WHERE  t.process  IN ('E','Y')
   AND   t.exectype ='MATCH' AND NOT EXISTS (SELECT * FROM iod i WHERE i.confirm_no = t.execid );
   COMMIT;

   UPDATE t_fo_exec SET process ='N'    WHERE exectype ='CFOD' AND process ='E'
         AND  orderid IN (SELECT foorderid
            FROM newfo_ordermap WHERE boorderid IN (SELECT orgorderid  FROM ood WHERE oodstatus ='N' ) );
   COMMIT;*/

       FOR i IN (SELECT * FROM T_FO_EXEC WHERE process ='N' AND  ID = m.id)
        LOOP
        plog.debug (pkgctx, 'prc_Process_exec ID '||m.ID ||' msgtype '||i.EXECTYPE);
        BEGIN
          IF i.EXECTYPE = 'CFCANCEL' THEN  --Confirm cancel
              confirm_cancel_exec (
                               pv_orderid   => i.origclordid,
                               pv_qtty      => i.LASTQTY,
                               p_err_code   => p_err_code,
                               p_err_message  => p_err_message
                            );

              --Neu lenh thoa thuan cung cong ty, thi giai toa lenh doi ung.
              begin
                select matchtype, exectype into v_matchtype, v_exectype
                from fomast
                where forefid = i.origclordid;
               exception when others then
                  v_matchtype :='N';
                  v_exectype  :='N';
               end;

              if v_matchtype  ='P' then
                Begin
                    select i.confirm_no into v_confirm_no from fomast f,  odmast o, iod i
                    where  f.orgacctno = o.orderid and o.orderid = i.orgorderid
                    and   f.forefid =i.origclordid;
                exception when others then
                    v_confirm_no:= null;
                end;
                if v_confirm_no is not null then
                    begin
                       select f.forefid into v_forefid_contra from fomast f,  odmast o, iod i
                        where  f.orgacctno = o.orderid and o.orderid = i.orgorderid and   f.forefid <> i.origclordid
                        and i.confirm_no =v_confirm_no;
                    exception when others then
                       v_forefid_contra:=null;
                    end;
                    If v_forefid_contra is not null then
                     --Goi giai toa lenh doi ung:
                       confirm_cancel_exec (
                                       pv_orderid   => v_forefid_contra,
                                       pv_qtty      => i.LASTQTY,
                                       p_err_code   => p_err_code,
                                       p_err_message  => p_err_message
                                    );
                    end if;
                end if;
              end if;

          ELSIF  i.EXECTYPE = 'CFREPLACE' THEN  --Confirm Replace

            CONFIRM_REPLACE_EXEC(
                    pv_ordernumber  => i.origclordid,
                    pv_qtty         => i.lastqty,
                    pv_price        => i.lastpx,
                    pv_LeavesQty    => i.leavesqty,
                    p_err_code      => p_err_code,
                    p_err_message   => p_err_message);
          ELSIF  i.EXECTYPE = 'CFOD2LO' THEN  --Confirm lenh MP, MTL thanh LO.

            confirm_send_order_2LO_exec(
                    pv_orderid       => i.orderid,
                    pv_qtty         => i.lastqty,
                    pv_price        => i.lastpx,
                    p_err_code      => p_err_code,
                    p_err_message   => p_err_message);


          ELSIF  i.EXECTYPE = 'CFOD' THEN  --Confirm Send Order

            confirm_send_order_exec(
                    pv_orderid  => i.orderid,
                    p_err_code      => p_err_code,
                    p_err_message   => p_err_message);

         ELSIF  i.EXECTYPE = 'MATCH' THEN  --Matching order

            matching_normal_order_exec(
                    order_number  => i.origclordid,
                    deal_volume         => i.lastqty,
                    deal_price        => i.lastpx,
                    confirm_number    => i.execid,
                    p_pitqtty         => i.pitqtty, --1.8.2.5: thue quyen
                    p_err_code      => p_err_code,
                    p_err_message   => p_err_message);
         ELSIF  i.EXECTYPE = 'REJECTOD' THEN  --Reject lenh msg 3 va 2G
           Pr_RejectOD_exec (
                  pv_orderid    => i.origclordid,
                  pv_msgtype    => i.ORDREJREASON,
                  p_err_code     => p_err_code,
                  p_err_message  => p_err_message
                );
          ELSIF  i.EXECTYPE = 'CFODPT' THEN  --Reject lenh msg 3 va 2G
            confirm_send_orderPT_exec (
                  pv_orderid  =>i.orderid,
                  pv_crossid  =>i.clordid,
                  p_err_code     => p_err_code,
                  p_err_message  => p_err_message);

         END IF;
          IF p_err_code = 0 THEN
            UPDATE  T_FO_EXEC  SET process  ='Y' WHERE id  =i.id;
          ELSE
            UPDATE  T_FO_EXEC  SET process  ='E', errmsg = p_err_code||':'||p_err_message WHERE id  =i.id;
          END IF;

        EXCEPTION WHEN OTHERS THEN
           UPDATE  T_FO_EXEC  SET process  ='E' , errmsg = p_err_code||':'||p_err_message WHERE id  =i.id;
        END;
        COMMIT;
    END LOOP;
  END LOOP;
   plog.setendsection (pkgctx, 'prc_Process_exec');
END;



PROCEDURE prc_Process_exec_ex
IS
 p_err_code varchar2(1000);
 p_err_message varchar2(1000);
 v_forefid_contra varchar2(100);
 v_matchtype      varchar2(100);
 v_exectype       varchar2(100);
 v_confirm_no     varchar2(100);
BEGIN
   IF  NOT fopks_api.fn_is_ho_active  THEN
    RETURN;
   END IF;

   FOR m IN (

               SELECT id FROM
                 (
               SELECT id, ROWNUM rn FROM (
                  SELECT id FROM T_FO_REICEIVEORDER T WHERE NOT EXISTS (SELECT 1 FROM newfo_ordermap n WHERE t.orderid  = n.foorderid) AND process ='Y'
                    UNION ALL
                  SELECT id FROM T_FO_EXEC WHERE (process ='E'
                                               OR exectype ='MATCH'
                                               AND NOT EXISTS (SELECT iod.confirm_no FROM iod , newfo_ordermap n
                                                               WHERE iod.confirm_no =  T_FO_EXEC.execid
                                                               AND   iod.orgorderid = n.boorderid
                                                               AND  T_FO_EXEC.origclordid = n.foorderid
                                                               )
                                               )
                  )
                  --ORDER BY id
                  )
                  WHERE RN <300
           )
    LOOP
       FOR j IN (SELECT * FROM t_fo_reiceiveorder WHERE id =m.ID)
       LOOP
        BEGIN
         IF j.msgtype ='NEWOD' THEN
           pr_OrderInsert_Exec
                ( j.orderId,
                  j.acctno,
                  j.symbol,
                  j.actype,
                  j.txnum ,
                  j.txdate,
                  j.txtime,
                  j.exectype,
                  j.matchtype,
                  j.via     ,
                  j.clearday,
                  j.status  ,
                  j.pricetype,
                  j.quoteprice,
                  j.orderqtty,
                  j.userid,
                  p_err_code,
                  p_err_message,
                  j.CONTRAFIRM ,
                  j.TRADERID ,
                  j.CLIENTID ,
                  j.ISDISPOSAL
                 );
         ELSIF j.msgtype ='EDITOD' THEN
         pr_EditOrder_Exec
          (
            j.OrderIdEdit,
            j.OrderId,
            j.acctno ,
            j.EditQTTY ,
            j.EditPrice ,
            j.via ,
            j.userid ,
            j.txdate ,
            p_err_code,
            p_err_message
          );
         ELSIF j.msgtype ='CANCELOD' THEN
            pr_CancelOrder_Exec(
            j.OrderIdCancel,
            j.OrderId ,
            j.acctno ,
            j.CancelQTTY ,
            j.via ,
            j.userid ,
            j.txdate ,
            p_err_code,
            p_err_message
            );
         END IF;
         IF p_err_code = '0' THEN
           UPDATE  t_fo_reiceiveorder  SET process  ='Y' WHERE id  =j.id;
         ELSE
           UPDATE  t_fo_reiceiveorder  SET process  ='E', errmsg = p_err_code||':'||p_err_message  WHERE id  =j.id;
         END IF;

         EXCEPTION WHEN OTHERS THEN
            UPDATE  t_fo_reiceiveorder  SET process  ='E', errmsg = p_err_code||':'||p_err_message WHERE id  =j.id;
         END;
         COMMIT;
       END LOOP;

  /* UPDATE t_fo_exec t SET process ='N'
   WHERE  t.process  IN ('E','Y')
   AND   t.exectype ='MATCH' AND NOT EXISTS (SELECT * FROM iod i WHERE i.confirm_no = t.execid );
   COMMIT;

   UPDATE t_fo_exec SET process ='N'    WHERE exectype ='CFOD' AND process ='E'
         AND  orderid IN (SELECT foorderid
            FROM newfo_ordermap WHERE boorderid IN (SELECT orgorderid  FROM ood WHERE oodstatus ='N' ) );
   COMMIT;*/

       FOR i IN (SELECT * FROM T_FO_EXEC WHERE ID = m.id)
        LOOP
        BEGIN
          IF i.EXECTYPE = 'CFCANCEL' THEN  --Confirm cancel
              confirm_cancel_exec (
                               pv_orderid   => i.origclordid,
                               pv_qtty      => i.LASTQTY,
                               p_err_code   => p_err_code,
                               p_err_message  => p_err_message
                            );

              --Neu lenh thoa thuan cung cong ty, thi giai toa lenh doi ung.
              begin
                select matchtype, exectype into v_matchtype, v_exectype
                from fomast
                where forefid = i.origclordid;
               exception when others then
                  v_matchtype :='N';
                  v_exectype  :='N';
               end;

              if v_matchtype  ='P' then
                Begin
                    select i.confirm_no into v_confirm_no from fomast f,  odmast o, iod i
                    where  f.orgacctno = o.orderid and o.orderid = i.orgorderid
                    and   f.forefid =i.origclordid;
                exception when others then
                    v_confirm_no:= null;
                end;
                if v_confirm_no is not null then
                    begin
                       select f.forefid into v_forefid_contra from fomast f,  odmast o, iod i
                        where  f.orgacctno = o.orderid and o.orderid = i.orgorderid and   f.forefid <> i.origclordid
                        and i.confirm_no =v_confirm_no;
                    exception when others then
                       v_forefid_contra:=null;
                    end;
                    If v_forefid_contra is not null then
                     --Goi giai toa lenh doi ung:
                       confirm_cancel_exec (
                                       pv_orderid   => v_forefid_contra,
                                       pv_qtty      => i.LASTQTY,
                                       p_err_code   => p_err_code,
                                       p_err_message  => p_err_message
                                    );
                    end if;
                end if;
              end if;

          ELSIF  i.EXECTYPE = 'CFREPLACE' THEN  --Confirm Replace

            CONFIRM_REPLACE_EXEC(
                    pv_ordernumber  => i.origclordid,
                    pv_qtty         => i.lastqty,
                    pv_price        => i.lastpx,
                    pv_LeavesQty    => i.leavesqty,
                    p_err_code      => p_err_code,
                    p_err_message   => p_err_message);
          ELSIF  i.EXECTYPE = 'CFOD2LO' THEN  --Confirm lenh MP, MTL thanh LO.

            confirm_send_order_2LO_exec(
                    pv_orderid       => i.orderid,
                    pv_qtty         => i.lastqty,
                    pv_price        => i.lastpx,
                    p_err_code      => p_err_code,
                    p_err_message   => p_err_message);


          ELSIF  i.EXECTYPE = 'CFOD' THEN  --Confirm Send Order

            confirm_send_order_exec(
                    pv_orderid  => i.orderid,
                    p_err_code      => p_err_code,
                    p_err_message   => p_err_message);

         ELSIF  i.EXECTYPE = 'MATCH' THEN  --Matching order

            matching_normal_order_exec(
                    order_number  => i.origclordid,
                    deal_volume         => i.lastqty,
                    deal_price        => i.lastpx,
                    confirm_number    => i.execid,
                    p_pitqtty         => i.pitqtty, --1.8.2.5: thue quyen
                    p_err_code      => p_err_code,
                    p_err_message   => p_err_message);
         ELSIF  i.EXECTYPE = 'REJECTOD' THEN  --Reject lenh msg 3 va 2G
           Pr_RejectOD_exec (
                  pv_orderid    => i.origclordid,
                  pv_msgtype    => i.ORDREJREASON,
                  p_err_code     => p_err_code,
                  p_err_message  => p_err_message
                );
          ELSIF  i.EXECTYPE = 'CFODPT' THEN  --Reject lenh msg 3 va 2G
            confirm_send_orderPT_exec (
                  pv_orderid  =>i.clordid,
                  pv_crossid  =>i.orderid,
                  p_err_code     => p_err_code,
                  p_err_message  => p_err_message);

         END IF;
          IF p_err_code = 0 THEN
            UPDATE  T_FO_EXEC  SET process  ='Y' WHERE id  =i.id;
          ELSE
            UPDATE  T_FO_EXEC  SET process  ='E', errmsg = p_err_code||':'||p_err_message WHERE id  =i.id;
          END IF;

        EXCEPTION WHEN OTHERS THEN
           UPDATE  T_FO_EXEC  SET process  ='E' , errmsg = p_err_code||':'||p_err_message WHERE id  =i.id;
        END;
        COMMIT;
    END LOOP;
  END LOOP;
END;



 PROCEDURE pr_Sync_ROOM_TO_FO (p_err_code  OUT varchar2, p_acctno  IN varchar2)
    AS

      temp1   INTEGER;
      temp2 VARCHAR2(25);
      CURSOR c_portfolios is SELECT MARKED,MARKEDCOM,ACCTNO,SYMBOL FROM t_fo_portfolios;
      CURSOR c_portfolios_2 is SELECT MARKED,MARKEDCOM,SYMBOL FROM t_fo_portfolios WHERE ACCTNO = p_acctno;
    BEGIN
     p_err_code :=0;
     --RETURN;
     DELETE FROM POOLROOM@dbl_fo;
     DELETE FROM OWNPOOLROOM@dbl_fo;
     DELETE FROM ALLOCATION@dbl_fo;
     IF p_acctno = 'ALL' THEN
        -- xu li bang portfolios
        UPDATE PORTFOLIOS@dbl_fo SET MARKED= 0,MARKEDCOM = 0;
        UPDATE PORTFOLIOSEX@dbl_fo SET MARKED= 0,MARKEDCOM = 0;
        FOR n IN c_portfolios LOOP
          UPDATE PORTFOLIOS@dbl_fo SET MARKED = n.MARKED,MARKEDCOM = n.MARKEDCOM WHERE ACCTNO = n.ACCTNO AND SYMBOL = n.SYMBOL;
        END LOOP;
     ELSE
      FOR n IN c_portfolios_2 LOOP
        UPDATE PORTFOLIOS@dbl_fo SET MARKED= n.MARKED,MARKEDCOM = n.MARKEDCOM WHERE ACCTNO = p_acctno AND SYMBOL = n.SYMBOL;
        UPDATE PORTFOLIOSEX@dbl_fo SET MARKED= 0,MARKEDCOM = 0 WHERE ACCTNO = p_acctno AND SYMBOL = n.SYMBOL;
      END LOOP;
     END IF;

    -- xu li bang poolroom
      INSERT INTO POOLROOM@dbl_fo(AUTOID, POLICYCD, POLICYTYPE, REFSYMBOL, GRANTED, INUSED)
      SELECT SEQ_POOLROOM.NEXTVAL@dbl_fo,POLICYCD,POLICYTYPE,REFSYMBOL,GRANTED,INUSED FROM t_fo_poolroom;

      --xu li bang ownpoolroom
      INSERT INTO OWNPOOLROOM@dbl_fo(PRID, ACCTNO, POLICYTYPE, REFSYMBOL, INUSED)
      SELECT PRID, ACCTNO, POLICYTYPE, REFSYMBOL, INUSED FROM t_fo_ownpoolroom;

      EXCEPTION
          WHEN OTHERS THEN
            p_err_code := '-1';
    END pr_Sync_ROOM_TO_FO;


PROCEDURE Pr_Reject_order (
   pv_orderid   IN   VARCHAR2,
   pv_msgtype   IN   VARCHAR2,
   p_err_code  OUT varchar2,
   p_err_message  OUT varchar2
)
IS
  v_strlog varchar2(4000);
BEGIN

   plog.setbeginsection (pkgctx, 'Pr_Reject_order');
   v_strlog := ' Pr_Reject_order pv_orderid '||pv_orderid
                                                     ||'pv_msgtype '||pv_msgtype  ;
   INSERT INTO t_fo_logcallws(id , tltxcd , acctno, strmsg , logtime)
                                       VALUES(seq_fo_logcallws.NEXTVAL, 'Pr_Reject_order', pv_orderid, v_strlog, SYSTIMESTAMP);
   COMMIT;

   INSERT INTO t_fo_exec (
                           exectype,
                           origclordid,
                           ORDREJREASON,
                           receivetime,
                           id,
                           process
                           )
        VALUES (
            'REJECTOD',   --Reject msgg
            pv_orderid,
            pv_msgtype,
            systimestamp,
            SEQ_FO_EXEC.NEXTVAL,
            'N'
            );


   COMMIT;
   p_err_code := 0;
   p_err_message:= 'Sucessfull!';
   plog.setendsection (pkgctx, 'Pr_Reject_order');

END;

PROCEDURE Pr_RejectOD_exec (
   pv_orderid   IN   VARCHAR2,
   pv_msgtype   IN   VARCHAR2,
   p_err_code   OUT varchar2,
   p_err_message  OUT varchar2
)
IS
    v_txdate    Varchar2(30);
    v_ex        EXCEPTION;
    v_order_number varchar2(50);
    v_err       VARCHAR2(300);
    v_strlog    VARCHAR2(4000);
    v_firm      Varchar2(30);
    v_side      Varchar2(30);

    v_check1Firm int;
    v_orderqtty number;
    v_codeid varchar2(10);
    v_contrafirm varchar2(10);
    v_custodycd varchar2(10);
    v_RefOrderID  varchar2(20);
    V_ORGORDERID varchar2(20);
    v_qtty number;
    v_ptdeal varchar2(20);
BEGIN
    plog.setbeginsection (pkgctx, 'Pr_RejectOD_exec');
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
    BEGIN
        SELECT boorderid INTO V_ORGORDERID  FROM newfo_ordermap  WHERE  foorderid =TRIM(pv_orderid);
    EXCEPTION WHEN OTHERS THEN
        plog.debug (pkgctx, 'Pr_RejectOD_exec  pv_orderid'||pv_orderid);
        RAISE v_ex;
    END;

    If pv_msgtype='D' or pv_msgtype='s' then --lenh moi thuong + thoa thuan
        UPDATE OOD
        SET
          OODSTATUS = 'S',
          TXTIME    = TO_CHAR(SYSDATE, 'HH24:MI:SS')
        WHERE ORGORDERID = V_ORGORDERID and OODSTATUS <> 'S';

        Select REMAINQTTY into  v_qtty from odmast  Where Orderid = V_ORGORDERID;

        plog.debug (pkgctx, 'CONFIRM_CANCEL_exec  V_ORGORDERID'||V_ORGORDERID ||' v_qtty '||v_qtty);
        --Giao toa tien /ck
        CONFIRM_CANCEL_exec(pv_orderid, v_qtty,p_err_code,p_err_message);

        Update odmast
        set
          ORSTATUS   = '6',
          FEEDBACKMSG= ''
        Where Orderid = V_ORGORDERID;

        --Xu ly cho lenh mua doi dung
        select count(1)
               into v_check1Firm
        from odmast
        where Orderid = V_ORGORDERID
          and matchtype='P'
          and contrafirm=(select sysvalue from ordersys_ha where sysname='FIRM');

        If pv_msgtype='s' and v_check1Firm>0 then --thao thuan cung cong ty
            --Tim thong tin lenh mua doi ung
            select  orderqtty, odmast.codeid, contrafirm, ood.custodycd, ptdeal
                into v_orderqtty,
                     v_codeid,
                     v_contrafirm,
                     v_custodycd,
                     v_ptdeal
            from odmast, ood
            where Orderid = V_ORGORDERID and odmast.orderid=ood.orgorderid;

            select max(orderid)  into v_RefOrderID
            from odmast
            where codeid = v_codeid
                  and orderqtty = v_orderqtty
                  and clientid = v_custodycd
                  and contrafirm = (select sysvalue from ordersys where sysname='FIRM')
                  and matchtype = 'P'
                  and ptdeal =v_ptdeal
                  and txdate =getcurrdate
                  AND orstatus='8';

             CONFIRM_CANCEL_exec(v_RefOrderID,v_orderqtty ,p_err_code,p_err_message);

             UPDATE OOD  SET
                  OODSTATUS = 'S',
                  TXTIME    = TO_CHAR(SYSDATE, 'HH24:MI:SS')
             WHERE ORGORDERID = v_RefOrderID and OODSTATUS <> 'S';

             Update odmast set
                  ORSTATUS   = '6',
                  FEEDBACKMSG= ''
            Where Orderid = v_RefOrderID;
        end if;

    End if;
    If pv_msgtype='F' then --Tu choi lenh huy thuong

        UPDATE OOD  SET
                 OODSTATUS = 'S',
                 TXTIME    = TO_CHAR(SYSDATE, 'HH24:MI:SS')
        WHERE ORGORDERID = V_ORGORDERID   and OODSTATUS <> 'S' ;

        Update odmast  Set
                 ORSTATUS   = '6',
                 FEEDBACKMSG= ''
        Where Orderid = V_ORGORDERID ;

        --Xu ly cho phep dat lai lenh huy
        DELETE odchanging WHERE orderid =V_ORGORDERID;
        update  fomast set status= 'R',feedbackmsg=''
        WHERE orgacctno=V_ORGORDERID;
    End if;
    If pv_msgtype='G' then --tu choi sua thuong
        UPDATE OOD SET
            OODSTATUS = 'S',
            TXTIME    = TO_CHAR(SYSDATE, 'HH24:MI:SS')
        WHERE ORGORDERID = V_ORGORDERID and OODSTATUS <> 'S';

        Update odmast Set
            ORSTATUS   = '6',
            FEEDBACKMSG= ''
        Where Orderid = V_ORGORDERID;

        --Xu ly cho phep dat lai lenh sua
        DELETE odchanging WHERE orderid =V_ORGORDERID;
        update  fomast set status='R',feedbackmsg=''
        WHERE orgacctno=V_ORGORDERID;
    End if;
    If pv_msgtype='u' then --tu choi huy thoa thuan
        UPDATE CANCELORDERPTACK
        SET status='S' , isconfirm='Y'
        WHERE ordernumber= V_ORGORDERID AND SORR='S' AND MESSAGETYPE='3C'   ;

    End if;

    IF substr(pv_msgtype,1,2) ='1I' then
             UPDATE OOD SET
                   OODSTATUS = 'S',
                   TXTIME = TO_CHAR(SYSDATE,'HH24:MI:SS')
             WHERE ORGORDERID = V_ORGORDERID and OODSTATUS <> 'S';

             Select remainqtty into v_qtty
             From odmast Where Orderid = V_ORGORDERID;

             CONFIRM_CANCEL_exec(pv_orderid, v_qtty,p_err_code,p_err_message);

             Update odmast SET
                   ORSTATUS = '6',
                   FEEDBACKMSG= ''
             Where  Orderid = V_ORGORDERID;
       elsif substr(pv_msgtype,1,2) ='1F' then --Thoa thuan cung cong ty (can huy lenh mua tuong ung)
            --Tim thong tin lenh mua doi ung
            select orderqtty, odmast.codeid, contrafirm, ood.custodycd, ptdeal
            into
                   v_orderqtty,
                   v_codeid,
                   v_contrafirm,
                   v_custodycd,
                   v_ptdeal
            from odmast, ood
            where Orderid = V_ORGORDERID   and odmast.orderid=ood.orgorderid;

            select max(orderid)  into v_RefOrderID
            from odmast
            where codeid = v_codeid
                  and orderqtty = v_orderqtty
                  and clientid = v_custodycd
                  and contrafirm = (select sysvalue from ordersys where sysname='FIRM')
                  and matchtype = 'P'
                  and ptdeal =v_ptdeal
                  AND txdate =getcurrdate
                  AND orstatus ='8' ;--tranh huy lenh da khop

            CONFIRM_CANCEL_exec(v_RefOrderID,v_orderqtty,p_err_code,p_err_message);
            CONFIRM_CANCEL_exec(V_ORGORDERID, v_orderqtty,p_err_code,p_err_message);


            UPDATE OOD SET
                   OODSTATUS = 'S',
                   TXTIME    = TO_CHAR(SYSDATE, 'HH24:MI:SS')
            WHERE ORGORDERID in ( v_RefOrderID,V_ORGORDERID) and OODSTATUS <> 'S';

            Update odmast   SET
                   ORSTATUS   = '6',
                   FEEDBACKMSG= ''
            Where Orderid  in (v_RefOrderID,V_ORGORDERID);
       elsif substr(pv_msgtype,1,2)='1G' then --Thoa thuan khac cong ty
            --Tim thong tin lenh ban goc
            select orderqtty   INTO  v_orderqtty
            from odmast
            where Orderid = V_ORGORDERID and matchtype = 'P' ;

            CONFIRM_CANCEL_exec(V_ORGORDERID, v_orderqtty,p_err_code,p_err_message);

            UPDATE OOD SET
                   OODSTATUS = 'S',
                   TXTIME    = TO_CHAR(SYSDATE, 'HH24:MI:SS')
            WHERE ORGORDERID = V_ORGORDERID  and OODSTATUS <> 'S';

            Update odmast   set
                   ORSTATUS   = '6',
                   FEEDBACKMSG= ''
            Where Orderid  in (V_ORGORDERID);
     ELSIF substr(pv_msgtype,1,2) ='1C' THEN
            --Tim orderid lenh yeu cau huy : v_RefOrderID
            --Cap nhat trang thai lenh yeu cau huy /suu
            Select orderid  Into v_RefOrderID
            From odmast
            Where reforderid  = V_ORGORDERID
                and exectype in ('CS','CB')
                and ORSTATUS <>'6' ; --huy ban/mua

            UPDATE  ood  SET oodstatus='S', TXTIME = TO_CHAR(SYSDATE,'HH24:MI:SS')
            WHERE  oodstatus='B'
                  and BORS not in('B','S')
                  and reforderid=V_ORGORDERID;

            Update odmast  set
                   ORSTATUS   = '6',
                   FEEDBACKMSG= ''
            Where Orderid = v_RefOrderID;

             --Xu ly cho phep dat lai lenh huy
            DELETE odchanging WHERE orderid =v_RefOrderID;
            update  fomast set status='R', feedbackmsg=''
            WHERE orgacctno=v_RefOrderID;
    elsIf substr(pv_msgtype,1,2)='3C'  then --Tu choi huy lenh

            --Tim orderid lenh yeu cau huy : v_RefOrderID
            --Cap nhat trang thai lenh yeu cau huy /sua
            UPDATE CANCELORDERPTACK   SET
                   status='S' ,
                   isconfirm='Y'
            WHERE ordernumber= V_ORGORDERID
                  AND SORR='S' AND MESSAGETYPE='3C'
                  AND STATUS='S';
    end if;




    COMMIT;
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
    plog.setendsection (pkgctx, 'Pr_RejectOD_exec');
    EXCEPTION
       WHEN v_ex
       THEN
       --plog.debug (pkgctx, ' confirm_send_order v_ex sqlerrm '||sqlerrm);
       p_err_code := -100879;
       p_err_message:= 'Loi khong tim thay lenh goc!';
       plog.setendsection (pkgctx, 'Pr_RejectOD_exec');
   WHEN
    OTHERS
     THEN

      ROLLBACK;

      plog.debug (pkgctx, ' Pr_RejectOD_exec sqlerrm '||sqlerrm
                                  );
      plog.setendsection (pkgctx, 'Pr_RejectOD_exec');

      p_err_code := -100800; --File du lieu dau vao khong hop le
      p_err_message:= 'System error. Invalid file format';
END Pr_RejectOD_exec;

PROCEDURE confirm_send_order_PT (
   pv_orderid   IN   VARCHAR2,
   pv_crossid      IN   VARCHAR2,
   p_err_code  OUT varchar2,
   p_err_message  OUT varchar2
)
IS
   v_ex        EXCEPTION;
   v_txdate    Varchar2(30);
   v_order_number  Varchar2(50);
   v_strlog       Varchar2(4000);

BEGIN
      plog.setbeginsection (pkgctx, 'confirm_send_order_PT');
      v_strlog:=' confirm_send_order_PT 1 pv_orderid '||pv_orderid
                                                  ||'pv_crossid  '||pv_crossid ;
   INSERT INTO t_fo_logcallws(id , tltxcd , acctno, strmsg , logtime)
                                       VALUES(seq_fo_logcallws.NEXTVAL, 'confirm_send_order_PT', pv_orderid, v_strlog, SYSTIMESTAMP);
   COMMIT;

   INSERT INTO t_fo_exec (
                           exectype,
                           clordid,
                           orderid,
                           receivetime,
                           id,
                           process
                           )
        VALUES (
            'CFODPT',
            pv_crossid,
            pv_orderid,
            systimestamp,
            SEQ_FO_EXEC.NEXTVAL,
            'N'
            );
    COMMIT;
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
    plog.setendsection (pkgctx, 'confirm_send_order_PT');

END confirm_send_order_PT;

PROCEDURE confirm_send_orderPT_exec (
   pv_orderid   IN   VARCHAR2,
   pv_crossid   IN   VARCHAR2,
   p_err_code   OUT varchar2,
   p_err_message  OUT varchar2
)
IS
    v_txdate    Varchar2(30);
    v_ex        EXCEPTION;
    v_order_number varchar2(50);
    v_err       VARCHAR2(300);
    v_strlog    VARCHAR2(4000);
    v_firm      Varchar2(30);
    v_side      Varchar2(30);
BEGIN
    plog.setbeginsection (pkgctx, 'confirm_send_orderPT_exec');
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';

    UPDATE newfo_ordermap SET order_number =pv_crossid WHERE    foorderid = pv_orderid;
    UPDATE ood SET oodstatus ='S', TXTIME = TO_CHAR(SYSDATE,'HH24:MI:SS') WHERE orgorderid IN (SELECT boorderid FROM newfo_ordermap WHERE foorderid = pv_orderid);
    UPDATE odmast SET orstatus ='2' WHERE orderid IN (SELECT boorderid FROM newfo_ordermap WHERE foorderid = pv_orderid);
    COMMIT;
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
    plog.setendsection (pkgctx, 'confirm_send_orderPT_exec');
    EXCEPTION
      WHEN
    OTHERS
      THEN

      ROLLBACK;

      plog.debug (pkgctx, ' confirm_send_orderPT_exec sqlerrm '||sqlerrm
                                  );
      plog.setendsection (pkgctx, 'confirm_send_orderPT_exec');

      p_err_code := -100800; --File du lieu dau vao khong hop le
      p_err_message:= 'System error. Invalid file format';
END confirm_send_orderPT_exec;
BEGIN
 FOR i IN (SELECT * FROM tlogdebug) LOOP
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  END LOOP;

  pkgctx := plog.init('txpks_msg',
                      plevel => NVL(logrow.loglevel,30),
                      plogtable => (NVL(logrow.log4table,'Y') = 'Y'),
                      palert => (logrow.log4alert = 'Y'),
                      ptrace => (logrow.log4trace = 'Y'));

END;


-- End of DDL Script for Package Body HOSTUAT.NEWFO_API
/


-- End of DDL Script for Package Body HOSTMSTRADE.NEWFO_API

