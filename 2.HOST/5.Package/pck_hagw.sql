-- Start of DDL Script for Package Body HOSTMSTRADE.PCK_HAGW
-- Generated 25/04/2019 4:27:11 PM from HOSTMSTRADE@FLEX_111

CREATE OR REPLACE 
PACKAGE pck_hagw
  IS

  PROCEDURE matching_normal_order (
   firm               IN   VARCHAR2,
   order_number       IN   VARCHAR2,
   order_entry_date   IN   VARCHAR2,
   side_alph          IN   VARCHAR2,
   filler             IN   VARCHAR2,
   deal_volume        IN   NUMBER,
   deal_price         IN   NUMBER,
   confirm_number     IN   VARCHAR2
);
  PROCEDURE confirm_cancel_normal_order (
   pv_orderid   IN   VARCHAR2,
   pv_qtty      IN   NUMBER
);
PROCEDURE CONFIRM_REPLACE_NORMAL_ORDER (
   pv_ordernumber   IN   VARCHAR2,
   pv_qtty       IN   NUMBER,
   pv_price      IN   NUMBER,
   pv_LeavesQty IN   NUMBER
);
  Procedure Prc_Update_Security;
  FUNCTION fnc_check_sec_ha
          ( v_Symbol IN varchar2)
         RETURN  number;
  Procedure Prc_ProcessMsg;
  Procedure Prc_ProcessMsg_ex;
  Procedure PRC_PROCESS;
  FUNCTION fn_xml2obj_8(p_xmlmsg    VARCHAR2) RETURN tx.msg_8;
  Procedure PRC_PROCESS8(V_MSGXML VARCHAR2, v_ID Varchar2);
  Procedure PRC_D(PV_REF IN OUT PKG_REPORT.REF_CURSOR);
  Procedure PRC_s(PV_REF IN OUT PKG_REPORT.REF_CURSOR);
  Procedure PRC_G(PV_REF IN OUT PKG_REPORT.REF_CURSOR);
  Procedure PRC_F(PV_REF IN OUT PKG_REPORT.REF_CURSOR);
  Procedure PRC_7(PV_REF IN OUT PKG_REPORT.REF_CURSOR);
  Procedure PRC_e(PV_REF IN OUT PKG_REPORT.REF_CURSOR);
  Procedure PRC_g_TT(PV_REF IN OUT PKG_REPORT.REF_CURSOR);
  Procedure PRC_GETORDER(PV_REF IN OUT PKG_REPORT.REF_CURSOR, v_MsgType VARCHAR2);
  FUNCTION fn_xml2obj_s(p_xmlmsg    VARCHAR2) RETURN tx.msg_s;
  FUNCTION fn_xml2obj_u(p_xmlmsg    VARCHAR2) RETURN tx.msg_u;
  FUNCTION fn_xml2obj_3(p_xmlmsg    VARCHAR2) RETURN tx.msg_3;
  FUNCTION fn_xml2obj_7(p_xmlmsg    VARCHAR2) RETURN tx.msg_7;
  FUNCTION fn_xml2obj_f(p_xmlmsg    VARCHAR2) RETURN tx.msg_f;
  FUNCTION fn_xml2obj_h(p_xmlmsg    VARCHAR2) RETURN tx.msg_h;
  FUNCTION fn_xml2obj_BF(p_xmlmsg    VARCHAR2) RETURN tx.msg_BF;    --MSBS-1853     HNX_update_GL
  FUNCTION fn_xml2obj_A(p_xmlmsg    VARCHAR2) RETURN tx.msg_A;    --MSBS-1853     HNX_update_GL
  Procedure PRC_PROCESS3(V_MSGXML VARCHAR2, v_ID Varchar2);
  Procedure PRC_PROCESS7(V_MSGXML VARCHAR2, v_ID Varchar2);
  Procedure PRC_PROCESSf(V_MSGXML VARCHAR2, v_ID Varchar2);
  Procedure PRC_PROCESSs(V_MSGXML VARCHAR2, v_ID Varchar2);
  Procedure PRC_PROCESSh(V_MSGXML VARCHAR2, v_ID Varchar2);
  Procedure PRC_PROCESSu(V_MSGXML VARCHAR2, v_ID Varchar2);
  Procedure PRC_PROCESSA(V_MSGXML VARCHAR2, v_ID Varchar2);     --MSBS-1853     HNX_update_GL
  Procedure PRC_u(PV_REF IN OUT PKG_REPORT.REF_CURSOR);
  PROCEDURE PRC_BE(PV_REF IN OUT PKG_REPORT.REF_CURSOR);        --MSBS-1853     HNX_update_GL
  Procedure PRC_PROCESSBF(V_MSGXML VARCHAR2, v_ID Varchar2);    --MSBS-1853     HNX_update_GL

END; -- Package spec
/


CREATE OR REPLACE PACKAGE BODY pck_hagw
IS
  pkgctx plog.log_ctx;
  logrow tlogdebug%ROWTYPE;
  v_CheckProcess Boolean;
  --LAY MESSAGE DAY LEN GW.
  Procedure PRC_GETORDER(PV_REF IN OUT PKG_REPORT.REF_CURSOR, v_MsgType VARCHAR2) is
  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_GETORDER');
      IF v_MsgType ='D' THEN
        PRC_D(PV_REF);
      ELSIF v_MsgType ='G' THEN
        PRC_G(PV_REF);
      ELSIF v_MsgType ='F' THEN
        PRC_F(PV_REF);
      ELSIF v_MsgType ='e' THEN
        PRC_e(PV_REF);
      ELSIF v_MsgType ='7' THEN
        PRC_7(PV_REF);
      ELSIF v_MsgType ='g' THEN
        PRC_g_TT(PV_REF);
      ELSIF v_MsgType ='s' THEN
        PRC_s(PV_REF);
      ELSIF v_MsgType ='u' THEN
        PRC_u(PV_REF);
      ELSIF v_MsgType ='BE' THEN --MSBS-1853  HNX_update_GL
        PRC_BE(PV_REF);
      ELSE --MSBS-1853  HNX_update_GL
        Open PV_REF For
        Select  v_MsgType MSGTYPE, 'Hello' TEXT
        From  dual
        Where 1>2;
    END IF;
      plog.setendsection (pkgctx, 'PRC_GETORDER');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_GETORDER');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_GETORDER;

 --Day message lenh thong thuong D len Gw
 Procedure PRC_D(PV_REF IN OUT PKG_REPORT.REF_CURSOR) is

    v_err VARCHAR2(200);
    v_Temp VARCHAR2(30);
    v_Check BOOLEAN;
    v_strSysCheckBuySell VARCHAR2(30);
    v_Order_Number varchar2(10);
    v_Count_Order Number;
    v_count_ood  Number;


    CURSOR C_D IS
        SELECT  ORDERID ORDERID, 'New Single Order' Text,CUSTODYCD Account,
        CASE
        WHEN  SUBSTR(CUSTODYCD,4,1) = 'A' OR SUBSTR(CUSTODYCD,4,1) ='B' THEN '3'
        WHEN  SUBSTR(CUSTODYCD,4,1) ='E' OR SUBSTR(CUSTODYCD,4,1) ='F' THEN '4'
        WHEN  SUBSTR(CUSTODYCD,4,1) ='P' THEN '1'
        ELSE  '2' END AccountType,
        QUOTEPRICE Price,ORDERQTTY OrderQty,SYMBOL Symbol,
        decode(BORS,'B','1','S','2') Side,
        CASE
        WHEN  PriceType ='LO' THEN '2'
        WHEN  PriceType ='SO<' THEN '3'
        WHEN  PriceType ='SO>' THEN '4'
        WHEN  PriceType ='ATC' THEN '5'
        WHEN  PriceType ='ATO' THEN '6'
        WHEN  PriceType ='IO' THEN 'I'
        WHEN  PriceType ='MOK' THEN 'K'
        WHEN  PriceType ='MAK' THEN 'A'
        WHEN  PriceType ='SBO' THEN 'S'
        WHEN  PriceType ='OBO' THEN 'O'
        WHEN  PriceType ='MTL' THEN 'T'
        WHEN  PriceType ='OBO' THEN 'O'
        WHEN  PriceType ='PLO' THEN 'C'
        WHEN  PriceType ='PT' THEN 'P'
        END OrdType,
        CODEID,BORS,
        QUOTEQTTY OrderQty2,
        LimitPrice StopPx
        FROM
        send_order_to_ha
        --WHERE
        --ROWNUM BETWEEN 0 AND (SELECT SYSVALUE FROM ORDERSYS_HA WHERE SYSNAME='HASENDSIZE')

             ;

    Cursor c_Check_Doiung(v_BorS Varchar2, v_Custodycd Varchar2,v_Codeid Varchar2,v_strTRADEBUYSELLPT varchar2) is
                           SELECT ORGORDERID FROM ood o , odmast od
                           WHERE o.orgorderid = od.orderid and o.custodycd =v_Custodycd and o.codeid=v_Codeid
                                 And o.bors <> v_BorS
                                 And od.remainqtty >0
                                 And od.deltd<>'Y'
                                 AND od.EXECTYPE in ('NB','NS','MS')
                                 And o.oodstatus in ('B','S')
                                 AND NVL(od.hosesession,'N') IN ('CLOSE','CLOSE_BL')
                                 and (v_strTRADEBUYSELLPT='N'
                                    or (v_strTRADEBUYSELLPT='Y' and od.matchtype <>'P'));

    Cursor C_Send_Size is SELECT SYSVALUE FROM ORDERSYS_HA WHERE SYSNAME='HASENDSIZE';
    v_Send_Size  Number;
    l_controlcode varchar2(20);
    l_strTRADEBUYSELLPT  VARCHAR2(10); -- Y Thi cho phep dat lenh thoa thuan doi ung

  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_D');

    Begin
            Select VARVALUE into v_strSysCheckBuySell from sysvar where GRNAME ='SYSTEM' and VARNAME ='TRADEBUYSELL';
        Exception When OTHERS Then
            v_strSysCheckBuySell:='N';
    End;

    Begin
          Select VARVALUE Into l_strTRADEBUYSELLPT
          From sysvar
          Where GRNAME ='SYSTEM' and VARNAME ='TRADEBUYSELLPT' ;
    EXCEPTION when OTHERS Then
            l_strTRADEBUYSELLPT:='N';
    End;

    --THEM
    Open C_Send_Size;
    Fetch C_Send_Size Into v_Send_Size;
    If C_Send_Size%notfound Then
     v_Send_Size:=100;
    End if;
    Close C_Send_Size;
    -- THEM
    v_Count_Order:=0;

      FOR I IN C_D
      LOOP
      --Kiem tra neu co lenh doi ung Block, Sent chua khop het thi khong day len GW.
         v_Check:=False;
            l_controlcode:=fn_get_controlcode(i.SYMBOL);
            If v_strSysCheckBuySell ='N' and  l_controlcode  in ('CLOSE','CLOSE_BL')  Then
                Open c_Check_Doiung(I.BORS, I.Account,I.CODEID,l_strTRADEBUYSELLPT);
                 Fetch c_Check_Doiung into v_Temp;
                   If c_Check_Doiung%found then
                    v_Check:=True;
                   End if;
                 Close c_Check_Doiung;
            End if;
    IF Not v_Check THEN
        v_count_ood:=0;
             SELECT count(*) into v_count_ood FROM OOD WHERE ORGORDERID=I.orderid;
             IF v_count_ood >0 Then
         SELECT seq_ordermap.NEXTVAL Into v_Order_Number From dual;

         INSERT INTO ha_d
                (Msgtype,text, ACCOUNT, accounttype, symbol, orderqty, side,
                 clordid, ordtype, price, orderid, date_time, status,OrderQty2,StopPx
                )
         VALUES ('D',I.text, I.ACCOUNT, I.accounttype, I.symbol, I.orderqty, I.side,
                 v_Order_Number, I.ordtype, I.price, I.orderid, Sysdate, 'N',I.OrderQty2,I.StopPx
                );
      --XU LY LENH THUONG D
        --1.1DAY VAO ORDERMAP.
        INSERT INTO ORDERMAP_HA(ctci_order,orgorderid) VALUES (v_Order_Number,I.orderid);
        --1.2 CAP NHAT OOD.
        UPDATE OOD SET OODSTATUS='B' WHERE ORGORDERID=I.orderid;
        UPDATE ODMAST SET hosesession= l_controlcode WHERE ORDERID=I.orderid;
        --1.3 DAY LENH VAO ODQUEUE
        INSERT INTO ODQUEUE SELECT * FROM OOD WHERE ORGORDERID = I.orderid;

        v_Count_Order:=v_Count_Order+1;

        End if;
      End If;
      Exit WHEN v_Count_Order >= v_Send_Size;
   END LOOP;
   --LAY DU LIEU RA GW.
   OPEN PV_REF FOR
   SELECT
        MsgType,
        TEXT TEXT,
        ACCOUNT ACCOUNT,
        ACCOUNTTYPE ACCOUNTTYPE,
        SYMBOL SYMBOL,
        ORDERQTY ORDERQTY,
        SIDE SIDE,
        CLORDID CLORDID,
        ORDTYPE ORDTYPE,
        PRICE PRICE,
        OrderQty2,
        Stoppx
   FROM ha_D WHERE STATUS ='N';
   --Cap nhat trang thai bang tam ra GW.
   UPDATE HA_D SET STATUS ='Y',DATE_TIME = SYSDATE WHERE STATUS ='N';

   plog.setendsection (pkgctx, 'PRC_D');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_D');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_D;



  --Day message lenh sua G len Gw
  Procedure PRC_G(PV_REF IN OUT PKG_REPORT.REF_CURSOR) is

    v_err VARCHAR2(200);

    CURSOR C_G IS
        SELECT  seq_ordermap.NEXTVAL ClOrdID, ORDER_NUMBER OrigClOrdID,ORDERID,
        'Order Replace Request' Text, QUOTEPRICE Price, ORDERQTTY,
        CashOrderQty, OrderQty2, StopPx,Symbol
        FROM
        (SELECT ODM.CTCI_ORDER, C.ACTYPE, D.TYPENAME, A.ORGORDERID ORDERID, C.EXECTYPE,
        A.CODEID, A.SYMBOL , E.QUOTEPRICE QUOTEPRICE,L.TRADELOT, C.STOPPRICE, C.LIMITPRICE,
        C.ORDERQTTY - C.EXECQTTY ORDERQTTY,A.PRICE OODPRICE, A.QTTY OODQTTY, TLLOG.TLID,TLLOG.BRID,
        A.TXDATE, A.TXNUM, J.FULLNAME, J.CUSTODYCD, K.FULLNAME ISSUERS, J.CUSTID, A.OODSTATUS,
        C.AFACCTNO, C.CIACCTNO, C.SEACCTNO, L.TRADEUNIT, E.BRATIO ,C.BRATIO OLDBRATIO, E.REFORDERID,
        L.SECUREDRATIOMIN, L.SECUREDRATIOMAX, C.MATCHTYPE, C.NORK, E.PRICETYPE, C.CLEARDAY,
        TLLOG.TXDESC, TLLOG.TLTXCD,C.ORSTATUS, C.EXECQTTY, ODM.order_number,
        E.orderqtty - C.EXECQTTY  CashOrderQty, E.QUOTEQTTY OrderQty2, E.Limitprice StopPx
        FROM OOD A, SBSECURITIES B, ODMAST C,ODMAST E, ODTYPE D, AFMAST I, CFMAST J, ISSUERS K,
             SECURITIES_INFO L, TLLOG,ORDERMAP_HA ODM
        WHERE (A.CODEID = B.CODEID AND A.ORGORDERID = E.ORDERID AND E.REFORDERID=C.ORDERID AND C.ACTYPE = D.ACTYPE)
          AND E.REFORDERID=ODM.ORGORDERID
          AND NVL(C.ISFO_ORDER,'N') <>'Y'
          AND A.TXDATE = TLLOG.TXDATE AND A.TXNUM = TLLOG.TXNUM
          AND (TLLOG.TXSTATUS = '1' OR (TLLOG.TLTXCD IN ('8884','8885') AND TLLOG.TXSTATUS = '1' ) )
          AND B.CODEID = L.CODEID
          AND C.ORSTATUS NOT IN ('3','0','6','8') AND C.MATCHTYPE ='N' AND C.REMAINQTTY >0
          AND E.ORSTATUS NOT IN ('0')
          AND C.AFACCTNO = I.ACCTNO AND I.CUSTID = J.CUSTID
          AND B.ISSUERID = K.ISSUERID
          AND ODM.order_number is not null
          AND OODSTATUS IN ('N')
          AND C.DELTD <> 'Y'  AND TLLOG.TLTXCD IN ('8884','8885')
          AND
          (
            (
                   B.TRADEPLACE='002'
                  AND (SELECT SYSVALUE FROM ORDERSYS_HA WHERE SYSNAME='CONTROLCODE') ='1'
                  AND (SELECT SYSVALUE FROM ORDERSYS_HA WHERE SYSNAME='TRADINGID') in ('CONT')
             ) Or
             (
                   B.TRADEPLACE='005'
                  AND (SELECT SYSVALUE FROM ORDERSYS_UPCOM WHERE SYSNAME='CONTROLCODE') ='1'
                  AND (SELECT SYSVALUE FROM ORDERSYS_UPCOM WHERE SYSNAME='TRADINGID') in ('CONTUP')
             )
          )
          AND C.pricetype in ('LO','MTL')
          ORDER BY J.CLASS DESC , SUBSTR(A.ORGORDERID,5,12)
          )
         WHERE ROWNUM BETWEEN 0 AND (SELECT SYSVALUE FROM ORDERSYS_HA WHERE SYSNAME='HASENDSIZE')
         and INSTR((select inperiod from msgmast_ha where msgtype ='G'),
         (SELECT SYSVALUE FROM ORDERSYS_HA WHERE SYSNAME='CONTROLCODE')) >0;

  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_G');
      FOR I IN C_G
      LOOP
        INSERT INTO ha_g
            (Msgtype, text, clordid, origclordid, price, orderid, date_time,
             status,CashOrderQty, OrderQty2, StopPx,Symbol, orderqty
            )
     VALUES ('G',I.text, I.clordid, I.origclordid, I.price, I.orderid, sysdate,
             'N',i.CashOrderQty, I.OrderQty2, I.StopPx,I.Symbol, i.ORDERQTTY
            );
      --XU LY LENH SUA G
        --1.1DAY VAO ORDERMAP.
        INSERT INTO ORDERMAP_HA(ctci_order,orgorderid) VALUES (I.clordid,I.orderid);
        --1.2 CAP NHAT OOD.
        UPDATE OOD SET OODSTATUS='B' WHERE ORGORDERID=I.orderid;
        --1.3 DAY LENH VAO ODQUEUE
        INSERT INTO ODQUEUE SELECT * FROM OOD WHERE ORGORDERID = I.orderid;
      END LOOP;
   --LAY DU LIEU RA GW.
   OPEN PV_REF FOR
   SELECT
        Msgtype,
        TEXT TEXT,
        CLORDID CLORDID,
        ORIGCLORDID ORIGCLORDID,
        PRICE PRICE,
        --decode(Orderqty,CashOrderQty,'',CashOrderQty)
         CashOrderQty,
        --decode(Orderqty,CashOrderQty,'',Orderqty)
        Orderqty,
        '' OrderQty2,
        '' StopPx,
        Symbol
   FROM ha_G WHERE STATUS ='N';
   --Cap nhat trang thai bang tam ra GW.
   UPDATE ha_G SET STATUS ='Y',DATE_TIME = SYSDATE WHERE STATUS ='N';
   plog.setendsection (pkgctx, 'PRC_G');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_G');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_G;




  --Day message lenh huy F len Gw
  Procedure PRC_F(PV_REF IN OUT PKG_REPORT.REF_CURSOR) is

    v_err VARCHAR2(200);

    CURSOR C_F IS
       SELECT  seq_ordermap.NEXTVAL ClOrdID, ORDER_NUMBER OrigClOrdID,ORDERID,
        'Order Cancel Request' Text, Symbol
        FROM (SELECT ODM.CTCI_ORDER,S.VARVALUE FIRM, C.ACTYPE, D.TYPENAME, A.ORGORDERID ORDERID, C.EXECTYPE, A.CODEID, A.SYMBOL , C.QUOTEPRICE/L.TRADEUNIT QUOTEPRICE,L.TRADELOT, C.STOPPRICE, C.LIMITPRICE, C.ORDERQTTY,A.PRICE OODPRICE, A.QTTY OODQTTY, TLLOG.TLID,TLLOG.BRID,
        A.TXDATE, A.TXNUM, J.FULLNAME, J.CUSTODYCD, K.FULLNAME ISSUERS, J.CUSTID, A.OODSTATUS, C.AFACCTNO, C.CIACCTNO, C.SEACCTNO, L.TRADEUNIT, E.BRATIO ,C.BRATIO OLDBRATIO, E.REFORDERID,
        L.SECUREDRATIOMIN, L.SECUREDRATIOMAX, C.MATCHTYPE, C.NORK, E.PRICETYPE, C.CLEARDAY, TLLOG.TXDESC, TLLOG.TLTXCD,C.ORSTATUS, C.EXECQTTY,ODM.ORDER_NUMBER
        FROM OOD A, SBSECURITIES B, ODMAST C,ODMAST E, ODTYPE D, AFMAST I, CFMAST J, ISSUERS K, SECURITIES_INFO L, TLLOG, SYSVAR S,ORDERMAP_HA ODM
        WHERE (A.CODEID = B.CODEID AND A.ORGORDERID = E.ORDERID AND E.REFORDERID=C.ORDERID AND C.ACTYPE = D.ACTYPE)
          AND NVL(C.ISFO_ORDER,'N') <>'Y'
          AND E.REFORDERID=ODM.ORGORDERID
          AND A.TXDATE = TLLOG.TXDATE AND A.TXNUM = TLLOG.TXNUM AND (TLLOG.TXSTATUS = '1' OR (TLLOG.TLTXCD IN ('8882','8883') AND TLLOG.TXSTATUS = '1' ) )
          AND B.CODEID = L.CODEID
          AND C.ORSTATUS NOT IN ('3','0','6','8') AND C.MATCHTYPE ='N' AND C.REMAINQTTY >0
          AND E.ORSTATUS NOT IN ('0')
          AND C.AFACCTNO = I.ACCTNO AND I.CUSTID = J.CUSTID
          AND B.ISSUERID = K.ISSUERID
          AND ODM.order_number is not null
          AND OODSTATUS IN ('N') AND C.DELTD <> 'Y'  AND TLLOG.TLTXCD IN ('8882','8883')
          AND  S.GRNAME='SYSTEM'
          AND S.VARNAME='FIRM'
          AND
          (
            (
                     B.TRADEPLACE='002'
                  AND (SELECT SYSVALUE FROM ORDERSYS_HA WHERE SYSNAME='CONTROLCODE') ='1'
                  AND (SELECT SYSVALUE FROM ORDERSYS_HA WHERE SYSNAME='TRADINGID') in ('CONT')
             ) or
             (
                    B.TRADEPLACE='005'
                  AND (SELECT SYSVALUE FROM ORDERSYS_UPCOM WHERE SYSNAME='CONTROLCODE') ='1'
                  AND (SELECT SYSVALUE FROM ORDERSYS_UPCOM WHERE SYSNAME='TRADINGID') in ('CONTUP')
             )
          )
          AND C.pricetype in ('LO','MTL','ATC')
          ORDER BY J.CLASS DESC , SUBSTR(A.ORGORDERID,5,12)
          )
         WHERE ROWNUM BETWEEN 0 AND (SELECT SYSVALUE FROM ORDERSYS_HA WHERE SYSNAME='HASENDSIZE')
         and INSTR((select inperiod from msgmast_ha where msgtype ='F'),
         (SELECT SYSVALUE FROM ORDERSYS_HA WHERE SYSNAME='CONTROLCODE')) >0;

  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_F');
      FOR I IN C_F
      LOOP
         INSERT INTO ha_f
                (Msgtype,text, clordid, origclordid, orderid, date_time, status,symbol
                )
         VALUES ('F',I.text, I.clordid, I.origclordid, I.orderid, Sysdate, 'N',I.symbol
                );
      --XU LY LENH HUY F
        --1.1DAY VAO ORDERMAP.
        INSERT INTO ORDERMAP_HA(ctci_order,orgorderid) VALUES (I.clordid,I.orderid);
        --1.2 CAP NHAT OOD.
        UPDATE OOD SET OODSTATUS='B' WHERE ORGORDERID=I.orderid;
        --1.3 DAY LENH VAO ODQUEUE
        INSERT INTO ODQUEUE SELECT * FROM OOD WHERE ORGORDERID = I.orderid;
      END LOOP;
   --LAY DU LIEU RA GW.
   OPEN PV_REF FOR
   SELECT
        Msgtype,
        TEXT TEXT,
        CLORDID CLORDID,
        ORIGCLORDID ORIGCLORDID,
        Symbol
    FROM ha_F WHERE STATUS ='N';
   --Cap nhat trang thai bang tam ra GW.
   UPDATE ha_F SET STATUS ='Y',DATE_TIME = SYSDATE WHERE STATUS ='N';
   plog.setendsection (pkgctx, 'PRC_F');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_F');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_F;

  --Day message lenh thoa thuan len Gw
  Procedure PRC_s(PV_REF IN OUT PKG_REPORT.REF_CURSOR) is

    v_err VARCHAR2(200);
    v_Temp VARCHAR2(30);
    v_Check BOOLEAN;
    v_strSysCheckBuySell VARCHAR2(30);
    v_DblODQUEUE number;
    v_dblCTCI_order VARCHAR2(30);

    CURSOR C_s IS
        SELECT  Decode(CrossID,'0',to_char( seq_ordermap.NEXTVAL),CrossID) CrossID,ORDERID,
        CrossType CrossType, '2' NoSides,'2' SellSide,
        FIRM SellPartyID,SCLIENTID SellAccount, ORDERQTTY SellOrderQty,
        CASE WHEN  SCUSTODIAN = 'A' OR SCUSTODIAN ='B' THEN '3'
        WHEN  SCUSTODIAN ='E' OR SCUSTODIAN ='F' THEN '4'
        WHEN  SCUSTODIAN ='P' THEN '1'
        ELSE  '2' END SellAccountType, '1' BuySide,
        CONTRAFIRM BuyPartyID,BCLIENTID BuyAccount,ORDERQTTY BuyOrderQty,
        CASE WHEN  BCUSTODIAN = 'A' OR BCUSTODIAN ='B' THEN '3'
        WHEN  BCUSTODIAN ='E' OR BCUSTODIAN ='F' THEN '4'
        WHEN  BCUSTODIAN ='P' THEN '1'
        ELSE  '2' END BuyAccountType, SYMBOL Symbol, QUOTEPRICE Price,codeid
        FROM
        (select NVL(advidref,'0') CrossID,Decode(NVL(advidref,'0'),'0','1','8') CrossType,ORDERID,FIRM,SCLIENTID,ORDERQTTY,SCUSTODIAN,CONTRAFIRM,BCLIENTID,BCUSTODIAN,to_char(Symbol) SYMBOL,QUOTEPRICE,codeid from send_2firm_pt_order_to_ha
         UNION ALL
         select NVL(advidref,'0') CrossID,Decode(NVL(advidref,'0'),'0','1','8') CrossType, ORDERID,FIRM,SCLIENTID,ORDERQTTY,SCUSTODIAN,FIRM,BCLIENTID,BCUSTODIAN,to_char(Symbol) SYMBOL,QUOTEPRICE,codeid from send_putthrough_order_to_HA
         Union All
        SELECT confirmnumber CrossID,Decode(A.STATUS,'A','5','C','6') CrossType,ORDERID, SELLERCONTRAFIRM FIRM ,
        SCLIENTID, C.QTTY ORDERQTTY,Substr(SCLIENTID,4,1) SCUSTODIAN, FIRM CONTRAFIRM,C.CUSTODYCD BCLIENTID
        ,Substr(C.CUSTODYCD,4,1) BCUSTODIAN, securitysymbol SYMBOL,QUOTEPRICE,b.codeid
        FROM ORDERPTACK A, ODMAST B,OOD C, SBSECURITIES S WHERE A.STATUS IN ('A')--('A','C') Voi Status = C Boc Ben Duoi
        AND A.CONFIRMNUMBER=B.CONFIRM_NO AND B.ORDERID=C.ORGORDERID
        AND B.DELTD <>'Y' AND A.ISSEND <>'Y' AND C.symbol =s.symbol and s.tradeplace in  ('002','005')
        AND NVL(B.ISFO_ORDER,'N') <>'Y'

        UNION ALL --MSBS-2481 Tu Choi Lenh Thoa thuan 2F
        SELECT confirmnumber CrossID, Decode(A.STATUS,'A','5','C','6') CrossType, confirmnumber ORDERID, SELLERCONTRAFIRM FIRM ,
            SCLIENTID, to_number(volume) ORDERQTTY, Substr(SCLIENTID,4,1) SCUSTODIAN, FIRM CONTRAFIRM,'' BCLIENTID,
            '' BCUSTODIAN ,securitysymbol SYMBOL, to_number(price) QUOTEPRICE, s.codeid
        FROM
            ORDERPTACK A,
            SBSECURITIES S
        WHERE A.STATUS IN ('C') and a.side = 'B' --tu choi lenh mua cua khach hang
        AND A.ISSEND <>'Y'
        AND a.securitysymbol = s.symbol
        and s.tradeplace IN ('002','005')
        )
        WHERE ROWNUM BETWEEN 0 AND (SELECT SYSVALUE FROM ORDERSYS_HA WHERE SYSNAME='HASENDSIZE')
        --AND PCK_HAGW.fnc_check_sec_ha(SYMBOL)  <> '0'
        --HNX_update|iss 1774
        /*and  SYMBOL In (
                  Select a.SYMBOL from  hasecurity_req a,sbsecurities sb,
                        (
                        Select '002'||sysvalue sysvalue from ordersys_ha where sysname ='TRADINGID'
                        union all
                        Select '005'||sysvalue sysvalue from ordersys_upcom  where sysname ='TRADINGID'
                        )b
                        where a.symbol=sb.symbol
                        and   sb.tradeplace||a.TradingSessionID = b.sysvalue
                        and a.SECURITYTRADINGSTATUS in ('17','24','25','26','1','27','28')
                        )*/
        and  SYMBOL In (
                  Select hr.SYMBOL from  hasecurity_req HR,sbsecurities sb ,ha_brd hb
                       /*(
                        Select '002'||sysvalue sysvalue from ordersys_ha where sysname ='TRADINGID'
                        union all
                        Select '005'||sysvalue sysvalue from ordersys_upcom  where sysname ='TRADINGID'
                        )b*/
                        where hr.symbol=sb.symbol
                        AND hb.BRD_CODE = hr.tradingsessionsubid
                        --and   sb.tradeplace||a.TradingSessionID = b.sysvalue --HNX_update|iss 1774
                        AND( (HR.SECURITYTRADINGSTATUS in ('17','24','25','26','28')
                                      AND hb.TRADSESSTATUS ='1')
                              OR    --ma = 1, 27 theo co bang va co ma
                              (HR.SECURITYTRADINGSTATUS in ('1','27')
                                     AND hb.TRADSESSTATUS ='1'
                                      AND hr.TRADSESSTATUS ='1'
                                      AND hb.TRADINGSESSIONID= hr.TradingSessionID )
                             )
                         )
        --End HNX_update|iss 1774

        and INSTR((select inperiod from msgmast_ha where msgtype ='s'),
         (SELECT SYSVALUE FROM ORDERSYS_HA WHERE SYSNAME='CONTROLCODE')) >0;

        Cursor c_Check_Doiung(v_BorS Varchar2, v_Custodycd Varchar2,v_Codeid Varchar2) is
                       SELECT ORGORDERID FROM ood o , odmast od
                       WHERE o.orgorderid = od.orderid and o.custodycd =v_Custodycd and o.codeid=v_Codeid
                             And o.bors <> v_BorS
                             And od.remainqtty >0
                             AND od.EXECTYPE in ('NB','NS','MS')
                             And o.oodstatus in ('B','S');

    l_strTRADEBUYSELLPT  VARCHAR2(10); -- Y Thi cho phep dat lenh thoa thuan doi ung
    l_controlcode varchar2(20);

  BEGIN

      plog.setbeginsection (pkgctx, 'PRC_s');

    Begin
        Select VARVALUE into v_strSysCheckBuySell
        From sysvar
        Where GRNAME ='SYSTEM' and VARNAME ='TRADEBUYSELL';
        Exception When OTHERS Then
            v_strSysCheckBuySell:='N';
    End;
    Begin
        Select VARVALUE Into l_strTRADEBUYSELLPT
        From sysvar
        Where GRNAME ='SYSTEM' and VARNAME ='TRADEBUYSELLPT' ;
        EXCEPTION when OTHERS Then
           l_strTRADEBUYSELLPT:='N';
    End;


      FOR I IN C_s
      LOOP

      --Kiem tra neu co lenh doi ung Block, Sent chua khop het thi khong day len GW.
         --Sysvar ko cho BuySell thi check doi ung.
         v_Check:=False;
        l_controlcode :=fn_get_controlcode(i.SYMBOL) ;

        If v_strSysCheckBuySell ='N' and l_controlcode in ('CLOSE','CLOSE_BL') and l_strTRADEBUYSELLPT='N' Then
                 Open c_Check_Doiung('S', I.SellAccount,I.CODEID);
                 Fetch c_Check_Doiung into v_Temp;
                   If c_Check_Doiung%found then
                    v_Check:=True;
                   End if;
                 Close c_Check_Doiung;
                 If Not v_Check Then
                     Open c_Check_Doiung('B', I.BuyAccount,I.CODEID);
                     Fetch c_Check_Doiung into v_Temp;
                       If c_Check_Doiung%found then
                        v_Check:=True;
                       End if;
                     Close c_Check_Doiung;
                 End if;
         End if;

         IF Not v_Check  THEN

                  --- Check Xem trong ODQUEUE da co lenh nay chua,neu co thi ko xu ly nua
                  v_DblODQUEUE :=1 ;
                  Begin
                    Select count(orgorderid) into v_DblODQUEUE  from ODQUEUE  where  orgorderid  =  I.orderid ;
                  Exception When OTHERS Then
                    v_DblODQUEUE :=1 ;
                  End;

                  IF v_DblODQUEUE = 0 THEN

                  INSERT INTO ha_s
                            (msgtype,crossid, sellaccount, sellaccounttype, symbol,
                             sellorderqty, sellpartyid, price, crosstype, nosides,
                             sellside, buyside, buypartyid, buyaccount, buyorderqty,
                             buyaccounttype, orderid, date_time, status
                            )
                     VALUES ('s',I.crossid, I.sellaccount, I.sellaccounttype, I.symbol,
                             I.sellorderqty, I.sellpartyid, I.price, I.crosstype, I.nosides,
                             I.sellside, I.buyside, I.buypartyid, NVL(I.buyaccount,I.buypartyid||'C000001'), I.buyorderqty,
                             I.buyaccounttype, I.orderid, sysdate, 'N'
                            );

              --XU LY LENH THOA THUAN
                --1.1DAY VAO ORDERMAP.
                INSERT INTO ORDERMAP_HA(ctci_order,orgorderid, order_number) VALUES (I.crossid,I.orderid,I.crossid);
                --1.2 CAP NHAT OOD.
                UPDATE OOD SET OODSTATUS='B' WHERE ORGORDERID=I.orderid;
                UPDATE ODMAST SET hosesession= l_controlcode WHERE ORDERID=I.orderid;
                --1.3 DAY LENH VAO ODQUEUE
                INSERT INTO ODQUEUE SELECT * FROM OOD WHERE ORGORDERID = I.orderid;

                        --1.4 Cap nhat trang thai la da confirm
                        UPDATE ORDERPTACK SET ISSEND='Y' WHERE  trim(CONFIRMNUMBER)=trim(I.crossid);

                  END IF ;

         END IF;

      END LOOP;
   --LAY DU LIEU RA GW.
  /* OPEN PV_REF FOR
   */

       OPEN PV_REF FOR
   SELECT
        '0' CrossPrioritization,
        '1' SettlType,
        crossid SellClOrdID,
        NVL(v_dblCTCI_order,crossid) BuyClOrdID,
        --'1' SellNoPartyIDs,
        '1|448|sellpartyid'  SellNoPartyIDs,
        SellPartyID sellpartyid_0PartyID,
        --'1' BuyNoPartyIDs,
        '1|448|buypartyid'  BuyNoPartyIDs,
        BuyPartyID buypartyid_0PartyID,
        CrossID CrossID,
        SellAccount SellAccount,
        SellAccountType SellAccountType,
        Symbol Symbol,
        SellOrderQty SellOrderQty,
        Price Price,
        CrossType CrossType,
        --NoSides NoSides,
        SellSide SellSide,
        BuySide BuySide,
        BuyAccount BuyAccount,
        BuyOrderQty BuyOrderQty,
        BuyAccountType BuyAccountType,
        Msgtype
   FROM Ha_s WHERE STATUS ='N';

   --Cap nhat trang thai bang tam ra GW.
   UPDATE HA_s SET STATUS ='Y',DATE_TIME = SYSDATE WHERE STATUS ='N';
   plog.setendsection (pkgctx, 'PRC_s');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_s');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_s;



  --Day message huy lenh thoa thuan len Gw
  Procedure PRC_u(PV_REF IN OUT PKG_REPORT.REF_CURSOR) is

    v_err VARCHAR2(200);

    CURSOR C_u IS
        SELECT seq_ordermap.NEXTVAL CrossID,CrossType,OrigCrossID,SECURITYSYMBOL,SIDE FROM
            (
            SELECT '1' CrossType, CONFIRMNUMBER OrigCrossID,SECURITYSYMBOL SECURITYSYMBOL,SIDE SIDE
            FROM CANCELORDERPTACK c, Sbsecurities sb
            WHERE SORR='S'
            AND c.MESSAGETYPE='3C' AND c.STATUS='N' AND c.ISCONFIRM='N'
            and c.securitysymbol =sb.symbol and sb.tradeplace in ('002','005')
            Union all
            SELECT '7' CrossType, order_number OrigCrossID,to_char(symbol) SECURITYSYMBOL,bors SIDE
            FROM ordermap_ha o, ood
            where o.orgorderid =ood.orgorderid and ood.oodstatus ='S'
            and NORP ='P' and order_number is not null
            and o.rejectcode  ='N'
            Union all
            SELECT CrossType, OrigCrossID OrigCrossID,SECURITYSYMBOL SECURITYSYMBOL, SIDE
            From orderptack_delt where issend <> 'Y'
            Union all
            SELECT Decode(c.status,'A','5','6') CrossType, CONFIRMNUMBER OrigCrossID,SECURITYSYMBOL SECURITYSYMBOL,SIDE SIDE
            FROM CANCELORDERPTACK c, Sbsecurities sb
            WHERE SORR='R'
            AND c.MESSAGETYPE='u' AND c.status IN ('A','C') AND c.ISCONFIRM ='N'
            and c.securitysymbol =sb.symbol and sb.tradeplace in ('002','005')
            );

  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_u');
      FOR I IN C_u
      LOOP
          INSERT INTO ha_u
            (msgtype,crossid, crosstype, origcrossid, date_time, status,SYMBOL
            )
     VALUES ('u',i.crossid, i.crosstype, i.origcrossid, sysdate, 'N',I.SECURITYSYMBOL
            );

      --XU LY LENH THOA THUAN
        UPDATE CANCELORDERPTACK SET ISCONFIRM='S' WHERE MESSAGETYPE='3C' AND SORR='S' AND CONFIRMNUMBER=i.OrigCrossID;
        UPDATE CANCELORDERPTACK SET ISCONFIRM='S' WHERE MESSAGETYPE='u' AND SORR='R' AND CONFIRMNUMBER=i.OrigCrossID;
        Update ordermap_ha set REJECTCODE ='Y' where order_number=i.OrigCrossID;

        --Temp_ xoa lenh thoa thuan tu xa chua thuc hien
        Update orderptack_delt set ISSEND ='Y' where ORIGCROSSID =i.OrigCrossID;


      END LOOP;
   --LAY DU LIEU RA GW.
   OPEN PV_REF FOR
   SELECT
        Msgtype,
        CrossID CrossID,
        CrossType CrossType,
        OrigCrossID OrigCrossID,
        SYMBOL SYMBOL
   FROM Ha_u WHERE STATUS ='N';
   --Cap nhat trang thai bang tam ra GW.
   UPDATE Ha_u SET STATUS ='Y',DATE_TIME = SYSDATE WHERE STATUS ='N';
   plog.setendsection (pkgctx, 'PRC_u');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_u');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_u;


  --Day message lenh quang cao len Gw
  Procedure PRC_7(PV_REF IN OUT PKG_REPORT.REF_CURSOR) is

    v_err VARCHAR2(200);

    CURSOR C_7 IS
        Select AdvId,AdvRefId,
        AdvSide, Text,Quantity, AdvTransType,
        SYMBOL,DeliverToCompID,PRICE
        from (
        Select AutoID AdvId,ADVID AdvRefId,
        ADVSIDE AdvSide, Text Text,QUANTITY Quantity, 'C' AdvTransType,
        SYMBOL SYMBOL,DeliverToCompID DeliverToCompID,to_number(PRICE) PRICE
        From haput_ad_delt where issend <> 'Y'
        Union all
        SELECT A.AutoID AdvId, NVL(O.orDer_NUMBer,'') AdvRefId,
        A.SIDE AdvSide,
        A.CONTACT Text,A.VOLUME Quantity,
        Decode(A.STATUS,'A','N','C','C') AdvTransType,
        A.SECURITYSYMBOL Symbol,
        NVL(A.TOCOMPID,'0') DeliverToCompID,
        A.PRICE * se.TRADEUNIT Price
        from ORDERPTADV A,sbsecurities s,securities_info se,ORDERPTADV B, orDerMAP_HA O
        where a.securitysymbol =se.SYMBOL
        and s.codeid =se.codeid
        And s.tradeplace IN ('002','005')
        And A.DELETED <> 'Y' AND A.ISSEND='N' AND A.ISACTIVE='Y'
        And A.refid =B.autoid(+)
        AND O.ctci_order(+)  = TO_CHar(B.autoid)
        )
        Where PCK_HAGW.fnc_check_sec_ha(SYMBOL)  <> '0'
        and INSTR((select inperiod from msgmast_ha where msgtype ='7'),
         (SELECT SYSVALUE FROM ORDERSYS_HA WHERE SYSNAME='CONTROLCODE')) >0;

  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_7');
      FOR I IN C_7
      LOOP
        INSERT INTO ha_7
            (msgtype,text, advid, advside, quantity, advtranstype, symbol,
             delivertocompid, price, advrefid, date_time, status
            )
     VALUES ('7',I.text, I.advid, I.advside, I.quantity, I.advtranstype, I.symbol,
             I.delivertocompid, I.price, I.advrefid, Sysdate, 'N'
            );
      --XU LY LENH SUA 7
        --1.1
        UPDATE ORDERPTADV SET ISSEND='Y' WHERE AUTOID =I.advid;
        --1.2
        INSERT INTO ORDERMAP_HA(ctci_order,orgorderid) VALUES (I.advid,I.advid);

        --1.3Temp_ Them phan nay de xoa lenh thoa thuan tu xa
        UPDATE HAPUT_AD_DELT SET issend='Y' WHERE AUTOID =I.advid;

      END LOOP;
   --LAY DU LIEU RA GW.
   OPEN PV_REF FOR
   SELECT
        MSGTYPE MSGTYPE,
        TEXT TEXT,
        ADVID ADVID,
        ADVSIDE ADVSIDE,
        QUANTITY QUANTITY,
        ADVTRANSTYPE ADVTRANSTYPE,
        SYMBOL SYMBOL,
        DELIVERTOCOMPID DELIVERTOCOMPID,
        PRICE PRICE,
        ADVREFID ADVREFID
   FROM ha_7 WHERE STATUS ='N';
   --Cap nhat trang thai bang tam ra GW.
   UPDATE ha_7 SET STATUS ='Y',DATE_TIME = SYSDATE WHERE STATUS ='N';
   plog.setendsection (pkgctx, 'PRC_7');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_7');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_7;

--Day message lenh Request CP len Gw
  Procedure PRC_e(PV_REF IN OUT PKG_REPORT.REF_CURSOR) is

    v_err VARCHAR2(200);

  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_7');
   --LAY DU LIEU RA GW.
   OPEN PV_REF FOR
        Select 'e' msgtype,ID SecurityStatusReqID ,
               REQTYPE SubscriptionRequestType ,
               Decode(SYMBOL,'ALL',' ',SYMBOL) Symbol
        From HAStatusReq
        Where MarketOrSecuritity ='S' And status ='N';

   --Cap nhat trang thai .
   UPDATE HAStatusReq SET Status = 'S' WHERE STATUS ='N' And MarketOrSecuritity ='S';
   plog.setendsection (pkgctx, 'PRC_e');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_e');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_e;


  --Day message lenh Request Thi truong len Gw
  Procedure PRC_g_TT(PV_REF IN OUT PKG_REPORT.REF_CURSOR) is

    v_err VARCHAR2(200);

  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_g_TT');
   --LAY DU LIEU RA GW.
   OPEN PV_REF FOR
        Select 'g' msgtype,ID TradSesReqID ,REQTYPE SubscriptionRequestType
        From HAStatusReq
        Where MarketOrSecuritity ='M' and status ='N';

   --Cap nhat trang thai .
   UPDATE HAStatusReq SET Status = 'S' WHERE STATUS ='N' And MarketOrSecuritity ='M';
   plog.setendsection (pkgctx, 'PRC_g_TT');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_g_TT');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_g_TT;

PROCEDURE matching_normal_order (
   firm               IN   VARCHAR2,
   order_number       IN   VARCHAR2,
   order_entry_date   IN   VARCHAR2,
   side_alph          IN   VARCHAR2,
   filler             IN   VARCHAR2,
   deal_volume        IN   NUMBER,
   deal_price         IN   NUMBER,
   confirm_number     IN   VARCHAR2
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
   mv_mtrfday                NUMBER(10);

   mv_strtradeplace      VARCHAR2(3);
   mv_dbltrfbuyext      number(20,0);
   mv_dbltrfbuyrate      number(20,4);
   mv_strtrfstatus      VARCHAR2(1);
   mv_dblceilingprice  number;
   mv_dblfloorprice  number;
   mv_strpricetype      VARCHAR2(10);
   mv_strexecqtty       NUMBER (10);

   Cursor c_Odmast(v_OrgOrderID Varchar2) Is
   SELECT FOACCTNO,REMAINQTTY,EXECQTTY,EXECAMT,CANCELQTTY,ADJUSTQTTY
   FROM ODMAST WHERE TIMETYPE ='G' AND ORDERID=v_OrgOrderID;
   vc_Odmast c_Odmast%Rowtype;


BEGIN
   --0 lay cac tham so
   v_brid := '0000';
   v_tlid := '0000';
   v_ipaddress := 'HOST';
   v_wsname := 'HOST';
   v_tltxcd := '8804';

   mv_strtradeplace:='002';
   mv_dbltrfbuyext:=0;
   mv_dbltrfbuyrate:=0;
   mv_strtrfstatus:='Y';

 INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, '1. Input order_number '||order_number , ''
                  );
 COMMIT;

         INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, '1. Input order_number '||order_number ||' '|| deal_volume||' '|| deal_price||' '|| confirm_number, ''
                  );
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
   EXCEPTION
      WHEN OTHERS
      THEN
         v_err := SUBSTR ('sysvar ' || SQLERRM, 1, 100);
         RAISE v_ex;
   END;
   v_order_number :=order_number;
   BEGIN
      SELECT orgorderid
        INTO mv_strorgorderid
        FROM ordermap_ha
       WHERE order_number = v_order_number;
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
         RAISE v_ex;
    END;

  INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, '2. Matching order '||order_number ||' '|| deal_volume||' '|| deal_price||' '|| confirm_number, ''
                  );



    --TungNT modified - for T2 late send money
   BEGIN
      SELECT od.remainqtty,od.execqtty, sb.codeid, sb.symbol, ood.custodycd,
             ood.bors, ood.norp, ood.aorn, od.afacctno,
             od.ciacctno, od.seacctno, '', '',
             od.clearcd, ood.price, ood.qtty, deal_price,
             deal_volume, od.clearday, od.bratio,
             confirm_number, v_txdate, '', typ.mtrfday,
             ss.tradeplace,af.trfbuyext, af.trfbuyrate,
             od.pricetype, sb.ceilingprice,sb.floorprice
        INTO mv_strremainqtty,mv_strexecqtty, mv_strcodeid, mv_strsymbol, mv_strcustodycd,
             mv_strbors, mv_strnorp, mv_straorn, mv_strafacctno,
             mv_strciacctno, mv_strseacctno, mv_reforderid, mv_refcustcd,
             mv_strclearcd, mv_strexprice, mv_strexqtty, mv_strprice,
             mv_strqtty, mv_strclearday, mv_strsecuredratio,
             mv_strconfirm_no, mv_strmatch_date, mv_desc,mv_mtrfday,
             mv_strtradeplace,mv_dbltrfbuyext, mv_dbltrfbuyrate,
             mv_strpricetype, mv_dblceilingprice,mv_dblfloorprice
        FROM odmast od, ood, securities_info sb,odtype typ,afmast af,sbsecurities ss
       WHERE od.orderid = ood.orgorderid and od.actype = typ.actype
         AND od.afacctno=af.acctno and od.codeid=ss.codeid
         AND od.codeid = sb.codeid
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
         RAISE v_ex;
   END;

   IF mv_dbltrfbuyext>0 THEN
        mv_strtrfstatus:='N';
   END IF;
    --End

   IF ( mv_strbors ='B' and mv_strexprice < deal_price) or
     ( mv_strbors ='S' and mv_strexprice > deal_price) Then
     Return;
   End if;


   --Day vao stctradebook, stctradeallocation de khong bi khop lai:
   v_refconfirmno :='VN'||mv_strbors||mv_strconfirm_no;

   /*
   INSERT INTO stctradebook
            (txdate, confirmnumber, refconfirmnumber, ordernumber, bors,
             volume, price
            )
     VALUES (to_date(v_txdate,'dd/mm/yyyy'), mv_strconfirm_no, v_refconfirmno, order_number, mv_strbors,
             mv_strqtty, mv_strprice
            );
   */

   INSERT INTO stctradeallocation
            (txdate, txnum, refconfirmnumber, orderid, bors, volume,
             price, deltd
            )
     VALUES (to_date(v_txdate,'dd/mm/yyyy'), v_txnum, v_refconfirmno, mv_strorgorderid, mv_strbors, mv_strqtty,
             mv_strprice, 'N'
            );


   mv_desc := 'Matching order';

    INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, '3. Matching order '||order_number ||' '|| deal_volume||' '|| deal_price||' '|| confirm_number, ''
                  );




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

 INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, '4. Matching order '||order_number ||' '|| deal_volume||' '|| deal_price||' '|| confirm_number, ''
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

      --2 THEM VAO TRONG orderdeal
/*      INSERT INTO orderdeal
                  (firm, order_number, orderid, order_entry_date,
                   side_alph, filler, volume, price,
                   confirm_number, MATCHED
                  )
           VALUES (firm, order_number, mv_strorgorderid, order_entry_date,
                   side_alph, filler, deal_volume, deal_price,
                   confirm_number, 'Y'
                  );*/

      --3 THEM VAO TRONG IOD

       INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, '5. Matching order '||order_number ||' '|| deal_volume||' '|| deal_price||' '|| confirm_number, ''
                  );



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
                   mv_strprice, mv_strqtty, mv_strconfirm_no,to_char(sysdate,'hh24:mi:ss')
                  );


 INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, '6. Matching order '||order_number ||' '|| deal_volume||' '|| deal_price||' '|| confirm_number, ''
                  );



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
                         mv_strqtty, 0, 0, 'N', 'N', 0, getduedate(TO_DATE (v_txdate, 'DD/MM/YYYY'),mv_strclearcd,'000',mv_strclearday)
                        );
         END IF;

         --Tao lich thanh toan tien
         v_strduetype := 'SM';

         IF v_matched > 0
         THEN
            UPDATE stschd
               SET qtty = qtty + mv_strqtty,
                   amt = amt + mv_strprice * mv_strqtty
             WHERE orgorderid = mv_strorgorderid AND duetype = v_strduetype;
         ELSE
            --TungNT modified , for late T2 send money
            INSERT INTO stschd
                        (autoid, orgorderid, codeid,
                         duetype, afacctno, acctno,
                         reforderid, txnum,
                         txdate, clearday,
                         clearcd, amt, aamt,
                         qtty, aqtty, famt, status, deltd, costprice, cleardate,trfbuydt,trfbuysts, trfbuyrate, trfbuyext
                        )
                 VALUES (seq_stschd.NEXTVAL, mv_strorgorderid, mv_strcodeid,
                         v_strduetype, mv_strafacctno, mv_strafacctno,
                         mv_reforderid, v_txnum,
                         TO_DATE (v_txdate, 'DD/MM/YYYY'), 0,
                         mv_strclearcd, mv_strprice * mv_strqtty, 0,
                         mv_strqtty, 0, 0, 'N', 'N', 0, getduedate(TO_DATE (v_txdate, 'DD/MM/YYYY'),mv_strclearcd,'000',greatest(mv_mtrfday,mv_dbltrfbuyext)),
                         least(getduedate(TO_DATE (v_txdate, 'DD/MM/YYYY'),mv_strclearcd,'000',mv_dbltrfbuyext),getduedate(TO_DATE (v_txdate, 'DD/MM/YYYY'),mv_strclearcd,'000',mv_strclearday)),mv_strtrfstatus, mv_dbltrfbuyrate, mv_dbltrfbuyext
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
      UPDATE OOD
      SET OODSTATUS = 'S', TXTIME = TO_CHAR(SYSDATE,'HH24:MI:SS')
      WHERE ORGORDERID = mv_strorgorderid AND OODSTATUS <> 'S';

      /*UPDATE ODMAST
      SET ORSTATUS = '2'
      WHERE ORDERID = mv_strorgorderid AND ORSTATUS = '8';

      UPDATE odmast
         SET orstatus = '4'
       WHERE orderid = mv_strorgorderid;

      UPDATE odmast
         SET PORSTATUS = PORSTATUS||'4'
       WHERE orderid = mv_strorgorderid;

      UPDATE odmast
         SET execqtty = execqtty + mv_strqtty
       WHERE orderid = mv_strorgorderid;

      UPDATE odmast
         SET remainqtty = remainqtty - mv_strqtty
       WHERE orderid = mv_strorgorderid;

      UPDATE odmast
         SET execamt = execamt + mv_strqtty * mv_strprice
       WHERE orderid = mv_strorgorderid;

      UPDATE odmast
         SET matchamt = matchamt + mv_strqtty * mv_strprice
       WHERE orderid = mv_strorgorderid;*/
       -- Ducnv rao viet lai thanh 1 cau update
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
           WHERE exectype in ('AS','AB') And orderqtty <= mv_strexecqtty + mv_strqtty
           And REFORDERID = mv_strorgorderid;

           Update ood set oodstatus ='N' where oodstatus ='B' and REFORDERID = mv_strorgorderid
           and orgorderid in (select orderid from odmast where orstatus ='0');

        END IF;

      --Cap nhat tinh gia von

    /*  IF mv_strbors = 'B' THEN
          UPDATE semast SET dcramt = dcramt + mv_strqtty*mv_strprice, dcrqtty = dcrqtty+mv_strqtty WHERE acctno = mv_strseacctno;
      END IF;*/

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
/*
      IF mv_strbors = 'B' THEN
          INSERT INTO setran
                  (txnum, txdate,
                   acctno, txcd, namt, camt,
                   REF, deltd, autoid
                  )
           VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),
                   mv_strseacctno, '0051', mv_strqtty * mv_strprice, NULL,
                   NULL, 'N', seq_setran.NEXTVAL
                  );

          INSERT INTO setran
                  (txnum, txdate,
                   acctno, txcd, namt, camt,
                   REF, deltd, autoid
                  )
           VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),
                   mv_strseacctno, '0052', mv_strqtty, NULL,
                   NULL, 'N', seq_setran.NEXTVAL
                  );
      END IF;
*/
    -- if instr('/NS/MS/SS/', :newval.exectype) > 0 then
    if mv_strbors = 'S' then
        -- quyet.kieu : Them cho LINHLNB 21/02/2012
        -- Begin Danh sau tai san LINHLNB
        INSERT INTO odchanging_trigger_log (AFACCTNO,CODEID,AMT,TXNUM,TXDATE,ERRCODE,LAST_CHANGE,ORDERID,ACTIONFLAG,QTTY)
        VALUES( mv_strafacctno,mv_strcodeid ,mv_strprice * mv_strqtty ,v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),NULL,systimestamp,mv_strorgorderid,'M',mv_strqtty);
        -- End Danh dau tai san LINHLNB
    end if;

   INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, '7. Matching order '||order_number ||' '|| deal_volume||' '|| deal_price||' '|| confirm_number, ''
                  );


 ELSE
  INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, '8-3-2 Lenh Khop khong hop le, KL Khop lon hon Remain '||order_number ||' '|| deal_volume||' '|| deal_price||' '|| confirm_number, ''
                  );
/*   ELSE
      --ket qua tra ve khong hop le
              --2 THEM VAO TRONG orderdeal
      INSERT INTO orderdeal
                  (firm, order_number, orderid, order_entry_date,
                   side_alph, filler, volume, price,
                   confirm_number, MATCHED
                  )
           VALUES (firm, order_number, mv_strorgorderid, order_entry_date,
                   side_alph, filler, deal_volume, deal_price,
                   confirm_number, 'N'
                  );*/


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
EXCEPTION
   WHEN v_ex
   THEN
   ROLLBACK;
      INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, ' MATCHING_NORMAL_ORDER ', v_err
                  );

      COMMIT;
  when others then
      v_err:=substr(sqlerrm,1,200);
      ROLLBACK;
      INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, ' MATCHING_NORMAL_ORDER ', v_err
                  );

      COMMIT;

 END;


 --Thu tuc huy lenh

 PROCEDURE confirm_cancel_normal_order (
   pv_orderid   IN   VARCHAR2,
   pv_qtty      IN   NUMBER
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
   v_Orstatus_Cur     VARCHAR2(10);
   v_err              VARCHAR2(300);
   v_strCodeid        VARCHAR2(10);
   v_ex                 EXCEPTION;

   Cursor c_Odmast(v_OrgOrderID Varchar2) Is
   SELECT FOACCTNO,REMAINQTTY,EXECQTTY,EXECAMT,CANCELQTTY,ADJUSTQTTY
   FROM ODMAST WHERE TIMETYPE ='G' AND ORDERID=v_OrgOrderID;
   vc_Odmast c_Odmast%Rowtype;


BEGIN
   --0 lay cac tham so
   v_brid := '0000';
   v_tlid := '0000';
   v_ipaddress := 'HOST';
   v_wsname := 'HOST';
   v_cancelqtty := pv_qtty;
   --Kiem tra thoa man dieu kien huy
   BEGIN



    SELECT ORDERQTTY,REMAINQTTY,EXECQTTY,CANCELQTTY,ORSTATUS,Exectype
    INTO V_ORDERQTTY_CUR,V_REMAINQTTY_CUR,V_EXECQTTY_CUR,V_CANCELQTTY_CUR,V_ORSTATUS_CUR,v_trExectype
    FROM ODMAST WHERE ORDERID =PV_ORDERID;
   EXCEPTION WHEN OTHERS THEN
    v_err := SUBSTR ('WHERE ORDERID = ' || SQLERRM ||'  '||PV_ORDERID, 1, 100);
    raise v_ex;
   END;
   IF V_REMAINQTTY_CUR - V_CANCELQTTY < 0 OR V_EXECQTTY_CUR >= V_ORDERQTTY_CUR
                 OR V_CANCELQTTY = 0
   THEN
    Return;
   END IF;



            INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, ' confirm_cancel_normal_order ', 'here 1'
                  );





   --Lenh huy thong thuong: Co lenh huy 1C
   SELECT count(*) INTO v_Count_lenhhuy
   FROM odmast
   WHERE reforderid =pv_orderid
   AND exectype IN ('CB','CS') AND ORSTATUS<>'6';
   IF v_Count_lenhhuy >0 Then
        SELECT (CASE
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
            WHERE od.codeid = sb.codeid AND reforderid = pv_orderid
            AND OD.ORSTATUS<>'6' ; --DUCNV0704
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
            WHERE od.codeid = sb.codeid AND orderid = pv_orderid
            AND OD.ORSTATUS<>'6' ; --DUCNV0704
    END IF;


   v_advancedamount := 0;


   SELECT bratio
     INTO v_oldbratio
     FROM odmast
    WHERE orderid = pv_orderid;

      --NEU CHAU BI HUY THI KHI NHAN DUOC MESSAGE TRA VE SE THUC HIEN HUY LENH
      SELECT varvalue
        INTO v_txdate
        FROM sysvar
       WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

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

      --TungNT added , giai toa khi huy lenh
      BEGIN
        cspks_odproc.pr_RM_UnholdCancelOD(pv_orderid, v_cancelqtty, v_err);
      EXCEPTION WHEN OTHERS THEN
        plog.error(pkgctx,'Error when gen unhold for cancel order : ' || pv_orderid || ' qtty : ' || v_cancelqtty);
        plog.error(pkgctx, SQLERRM);
      END;
      --End

      --2 THEM VAO TRONG TLLOGFLD
      If v_Count_lenhhuy >0 then
          v_edstatus := 'W';
          UPDATE odmast
             SET edstatus = v_edstatus
          WHERE orderid = pv_orderid;

          UPDATE OOD SET OODSTATUS = 'S'
          WHERE ORGORDERID IN (SELECT ORDERID FROM ODMAST  WHERE REFORDERID = pv_orderid AND ORSTATUS<>'6')
          and OODSTATUS <> 'S';

      Else
        --OOD: Cap nhat E
        --ODMAST:
        --Update OOD set OODSTATUS ='E' where ORGORDERID =pv_orderid;
        Update ODMAST set ORSTATUS ='5' where Orderqtty =Remainqtty And ORDERID =pv_orderid;

      End if;
      --3 CAP NHAT TRAN VA MAST
      IF v_tltxcd = '8890' OR v_tltxcd = '8808'
      THEN
         --BUY
         UPDATE odmast
            SET cancelqtty = cancelqtty + v_cancelqtty,
                remainqtty = remainqtty - v_cancelqtty
          WHERE orderid = pv_orderid;

        if v_tltxcd IN ('8890','8808') then
                -- quyet.kieu : Them cho LINHLNB 21/02/2012
                -- Begin Danh sau tai san LINHLNB


                INSERT INTO odchanging_trigger_log (AFACCTNO,CODEID,AMT,TXNUM,TXDATE,ERRCODE,LAST_CHANGE,ORDERID,ACTIONFLAG,QTTY)
                VALUES( v_afaccount,v_strCodeid ,v_cancelqtty * v_price ,v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),NULL,systimestamp,pv_orderid,'C',v_cancelqtty);
                -- End Danh dau tai san LINHLNB
          end if ;


/*
         UPDATE odmast
            SET
            rlssecured = rlssecured +
            v_cancelqtty * v_price * v_oldbratio / 100
          WHERE orderid = pv_orderid;


         UPDATE cimast
            SET balance = balance + v_cancelqtty * v_price * v_oldbratio / 100,
                bamt = bamt - v_cancelqtty * v_price * v_oldbratio / 100
          WHERE acctno = v_afaccount;
*/
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

/*
         INSERT INTO odtran
                     (txnum, txdate,
                      acctno, txcd,
                      namt, camt, acctref,
                      deltd, REF, autoid
                     )
              VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),
                      pv_orderid, '0030',
                      v_cancelqtty * v_price * v_oldbratio / 100, NULL, NULL,
                      'N', NULL, seq_odtran.NEXTVAL
                     );


         INSERT INTO citran
                     (txnum, txdate, acctno,
                      txcd, namt,
                      camt, REF, deltd, acctref, autoid
                     )
              VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'), v_afaccount,
                      '0012', v_cancelqtty * v_price * v_oldbratio / 100,
                      NULL, pv_orderid, 'N', NULL, seq_citran.NEXTVAL
                     );

         INSERT INTO citran
                     (txnum, txdate, acctno,
                      txcd, namt,
                      camt, REF, deltd, acctref, autoid
                     )
              VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'), v_afaccount,
                      '0017', v_cancelqtty * v_price * v_oldbratio / 100,
                      NULL, pv_orderid, 'N', NULL, seq_citran.NEXTVAL
                     );
*/
      ELSE                                                   --v_tltxcd='8891' , '8807'
         --SELL
         UPDATE odmast
            SET cancelqtty = cancelqtty + v_cancelqtty,
                remainqtty = remainqtty - v_cancelqtty
          WHERE orderid = pv_orderid;

/* Khong cap nhat Ky quy, Trade
         If v_trExectype ='MS' Then
             UPDATE semast
                SET MORTAGE = MORTAGE + v_cancelqtty
                ,secured = secured - v_cancelqtty
              WHERE acctno = v_seacctno;

         Else
             UPDATE semast
                SET trade = trade + v_cancelqtty,
                    secured = secured - v_cancelqtty
              WHERE acctno = v_seacctno;
         End if;
*/
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
/*
         INSERT INTO setran
                     (txnum, txdate, acctno,
                      txcd, namt, camt, REF, deltd,
                      autoid
                     )
              VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'), v_seacctno,
                      '0012', v_cancelqtty, NULL, pv_orderid, 'N',
                      seq_setran.NEXTVAL
                     );

         INSERT INTO setran
                     (txnum, txdate, acctno,
                      txcd, namt, camt, REF, deltd,
                      autoid
                     )
              VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'), v_seacctno,
                      '0018', v_cancelqtty, NULL, pv_orderid, 'N',
                      seq_setran.NEXTVAL
                     );
*/
      END IF;

 --Cap nhat cho GTC
   OPEN C_ODMAST(pv_orderid);
   FETCH C_ODMAST INTO VC_ODMAST;
    IF C_ODMAST%FOUND AND v_Count_lenhhuy>0 THEN
         UPDATE FOMAST SET   REMAINQTTY= REMAINQTTY - v_cancelqtty
                            ,cancelqtty= cancelqtty + v_cancelqtty
          --WHERE ORGACCTNO= pv_orderid;
          WHERE ACCTNO= VC_ODMAST.FOACCTNO;
    END IF;
   CLOSE C_ODMAST;


   COMMIT;
EXCEPTION
   WHEN v_ex
   THEN
   ROLLBACK;
      INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, ' confirm_cancel_normal_order ', v_err
                  );

      COMMIT;
   when others then
      v_err:=substr(sqlerrm,1,200);
      ROLLBACK;
      INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, ' confirm_cancel_normal_order ', v_err
                  );

      COMMIT;

END;



PROCEDURE CONFIRM_REPLACE_NORMAL_ORDER (
   pv_ordernumber   IN   VARCHAR2,
   pv_qtty       IN   NUMBER,
   pv_price      IN   NUMBER,
   pv_LeavesQty IN   NUMBER
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
   v_ex                 EXCEPTION;
   v_DFACCTNO         varchar(20); --TheNN added
   v_ISDISPOSAL       varchar(20); --GianhVG added

   Cursor c_Odmast(v_OrgOrderID Varchar2) Is
   SELECT REMAINQTTY,EXECQTTY,EXECAMT,CANCELQTTY,ADJUSTQTTY
   FROM ODMAST WHERE TIMETYPE ='G' AND ORDERID=v_OrgOrderID;
   vc_Odmast c_Odmast%Rowtype;

BEGIN
   --0 lay cac tham so
   v_brid := '0000';
   v_tlid := '0000';
   v_ipaddress := 'HOST';
   v_wsname := 'HOST';
   v_replaceqtty := pv_qtty;


    INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, ' 123 Input pv_ordernumber HERE '||pv_ordernumber ||' '|| pv_qtty||' '|| pv_price,''
                  );



   --Kiem tra thoa man dieu kien sua
     BEGIN
     INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, ' 111 Input pv_ordernumber HERE '||pv_ordernumber ||' '|| pv_qtty||' '|| pv_price,''
                  );



        Select Orgorderid into PV_ORDERID from Ordermap_Ha where Order_number =pv_ordernumber;
      INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, ' 222 Input pv_ordernumber HERE '||pv_ordernumber ||' '|| pv_qtty||' '|| pv_price,''
                  );



     EXCEPTION
      WHEN OTHERS
      THEN
         v_err := SUBSTR ('ABC Order_number ' || SQLERRM, 1, 100);
         RAISE v_ex;
     End;

   Begin
    SELECT ORDERQTTY,REMAINQTTY,EXECQTTY,CANCELQTTY,ORSTATUS,Exectype, TLID
    INTO V_ORDERQTTY_CUR,V_REMAINQTTY_CUR,V_EXECQTTY_CUR,V_REPLACEQTTY_CUR,V_ORSTATUS_CUR,v_Exectype, v_tlid
    FROM ODMAST WHERE ORDERID =PV_ORDERID;

   EXCEPTION
      WHEN OTHERS
      THEN
         v_err := SUBSTR ('ODMAST WHERE ORDERID =PV_ORDERID ' || SQLERRM, 1, 100);
         RAISE v_ex;
   END;


/*   IF V_REMAINQTTY_CUR - v_replaceqtty < 0 OR V_EXECQTTY_CUR >= V_ORDERQTTY_CUR
                 OR v_replaceqtty = 0
   THEN
    RETURN;
   END IF;
   --Khoi luong lenh goc - da khop - sua thanh cong - sua thuc te < 0 thi ko thuc hien gi.
   IF V_ORDERQTTY_CUR - V_EXECQTTY_CUR - v_replaceqtty - pv_LeavesQty  < 0
   THEN
    RETURN;
   END IF;
*/
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
                  od.LIMITPRICE,VOUCHER,CONSULTANT, od.codeid
             INTO v_tltxcd, v_symbol,
                  v_afaccount, v_seacctno, v_price, v_quantity, v_bratio,
                  v_amendmentqtty, v_amendmentprice, v_matchedqtty, v_execqtty,
                  v_reforderid, v_tradeunit, v_edstatus,v_custid,v_actype,v_timetype,
                  v_NorK,v_MATCHTYPE,v_Via,v_CLEARDAY,v_CLEARCD,v_PRICETYPE,v_CUSTODYCD,
                  v_LIMITPRICE,v_VOUCHER,v_CONSULTANT,v_codeid
             FROM odmast od, ood ,  securities_info sb
            WHERE od.codeid = sb.codeid AND od.orderid = ood.orgorderid AND od.reforderid = pv_orderid
            AND OD.ORSTATUS<>'6' ; --DUCNV0704

  Exception when others then
         v_err := SUBSTR ('Confirm Replace cancel: Khong tim thay reforderid = pv_orderid'||pv_orderid ||' '|| SQLERRM, 1, 100);
         RAISE v_ex;
  End;

   v_advancedamount := 0;


   SELECT bratio, DFACCTNO, ISDISPOSAL
     INTO v_oldbratio, v_DFACCTNO,v_ISDISPOSAL
     FROM odmast
    WHERE orderid = pv_orderid;


      SELECT varvalue
        INTO v_txdate
        FROM sysvar
       WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

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
      --Cap nhat lenh sua thanh da Send.
      UPDATE OOD SET OODSTATUS = 'S'
      WHERE ORGORDERID IN (SELECT ORDERID FROM ODMAST  WHERE REFORDERID = pv_orderid and ORSTATUS<>'6')
      and OODSTATUS <> 'S';
      UPDATE ODMAST SET ORSTATUS = '2' WHERE ORDERID IN
      (SELECT ORDERID FROM ODMAST  WHERE REFORDERID = pv_orderid and ORSTATUS<>'6')
                                       AND ORSTATUS = '8';


      --3 CAP NHAT TRAN VA MAST
      IF v_tltxcd = '8890'
      THEN

         --BUY
        v_BORS :='B';
 /*         If v_OrderQtty_Cur >=v_quantity Then --Sua giam khoi luong
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
         -- DUCNV Danh dau laij tai san
         /*
         Begin
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
         EXCEPTION when OTHERS then
          null;
         End ;*/


      ELSE                                                   --v_tltxcd='8891'
         --SELL
        v_BORS :='S';
/*         If v_OrderQtty_Cur >=v_quantity Then --Sua giam khoi luong
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

   IF v_PRICETYPE = 'MTL' then
   v_PRICETYPE := 'LO';
   end if;

   INSERT INTO ODMAST (ORDERID,CUSTID,ACTYPE,CODEID,AFACCTNO
                 ,SEACCTNO,CIACCTNO,
                 TXNUM,TXDATE,TXTIME,EXPDATE,BRATIO,TIMETYPE,
                 EXECTYPE,NORK,MATCHTYPE,VIA,CLEARDAY,CLEARCD,ORSTATUS,PORSTATUS,PRICETYPE,
                 QUOTEPRICE,STOPPRICE,LIMITPRICE,ORDERQTTY,REMAINQTTY,EXPRICE,EXQTTY,SECUREDAMT,
                 EXECQTTY,STANDQTTY,CANCELQTTY,ADJUSTQTTY,REJECTQTTY,REJECTCD,VOUCHER,CONSULTANT,REFORDERID,CORRECTIONNUMBER,TLID,DFACCTNO,ISDISPOSAL)
          VALUES ( v_ORDERID , v_CUSTID , v_ACTYPE , v_CODEID , v_afaccount
                  ,v_SEACCTNO ,v_afaccount
                  , v_TXNUM ,TO_DATE (v_txdate, 'DD/MM/YYYY'), v_TXTIME
                  ,TO_DATE (v_txdate, 'DD/MM/YYYY'),v_BRATIO ,v_TIMETYPE
                  ,v_EXECTYPE ,v_NORK ,v_MATCHTYPE ,v_VIA ,v_CLEARDAY , v_CLEARCD ,'2','2',v_PRICETYPE
                  ,v_amendmentprice ,0,v_LIMITPRICE ,v_ReplaceQTTY,v_ReplaceQTTY ,v_amendmentprice ,v_ReplaceQTTY,0
                  ,0,0,0,0,0,'001', v_VOUCHER , v_CONSULTANT , pv_orderid , 1, v_tlid, v_DFACCTNO,v_ISDISPOSAL);

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

        -- DUC NV danh dau tai san
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


EXCEPTION
   WHEN v_ex
   THEN
   ROLLBACK;
   INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, ' ABC confirm_replace_normal_order ', v_err
                  );

      COMMIT;
   when others then
   ROLLBACK;
   INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, ' confirm_replace_normal_order ', 'others exception'
                  );

      COMMIT;

END;
    Procedure Prc_Update_Security
    is
      Cursor c_Stock Is
      Select SYMBOL,HIGHPX CEILING_PRICE, LOWPX FLOOR_PRICE, LASTPX BASIC_PRICE, BUYVOLUME current_room,
             CASE When (SECURITYTRADINGSTATUS in ('17','24','25','26','1','27','28')
                  ) Then 'N'
                  Else 'Y'
                  End HALT_SUSP from  hasecurity_req;
    Begin
         For vc_stock in c_Stock
         Loop
            UPDATE SECURITIES_INFO
            SET
                CEILINGPRICE= vc_stock.CEILING_PRICE,
                FLOORPRICE= vc_stock.FLOOR_PRICE,
                current_room=vc_stock.current_room,
                BASICPRICE=VC_STOCK.BASIC_PRICE,
                DFREFPRICE = vc_stock.FLOOR_PRICE
            WHERE SYMBOL= TRIM(vc_stock.SYMBOL)
                  and( CEILINGPRICE<> vc_stock.CEILING_PRICE
                     or   FLOORPRICE<> vc_stock.FLOOR_PRICE
                     or  current_room<>vc_stock.current_room
                     OR BASICPRICE<> VC_STOCK.BASIC_PRICE)
                     ;
          UPDATE SBSECURITIES SET HALT =  vc_stock.HALT_SUSP WHERE SYMBOL=TRIM(vc_stock.SYMBOL);
          Commit;
         End Loop;
    End;

  Procedure Prc_ProcessMsg
    is
    v_OrderID varchar2(20);
    v_Orgorderid varchar2(20);
    v_err  varchar2(500);
    v_strContraOrderId varchar2(30);
    v_strContraBorS varchar2(30);
    v_CICI_ORDER varchar2(30);
    v_Check number(1);
    v_afaccount varchar2(30);

    v_exp  Exception;
    p_err_param varchar2(30);
    p_err_code varchar2(30);
   Cursor c_Exec_8 is Select *  from Exec_8 where Process  ='N'
          AND ROWNUM BETWEEN 0 AND (SELECT SYSVALUE FROM ORDERSYS_HA WHERE SYSNAME='HARECEIVESIZE')
          Order by MsgSeqNum;
         -- Order by Decode(EXECTYPE,'0',1,'5',2,'4',3) ,decode(ORDSTATUS,'0',1,'A',2,'D',2,'3',3);
    --Thu tu uu tien xu ly lenh: Lenh vao queue, vao core, lenh sua thanh cong, lenh huy thanh cong, lenh khop.

   v_Exec_8  c_Exec_8%rowtype;


    --HNX_update_GL
    Cursor c_Ordermap_ha_ctci(v_CTCI_NUMBER varchar2) Is
          SELECT * FROM ORDERMAP_HA WHERE NVL(ctci_order,'0') = v_CTCI_NUMBER;

   Cursor c_Ordermap_ha(v_ORDER_NUMBER varchar2) Is
          SELECT * FROM ORDERMAP_HA WHERE NVL(ORDER_NUMBER,'0') = v_ORDER_NUMBER;
   v_Ordermap_ha c_Ordermap_ha%Rowtype;

   /*Cursor c_Onefirm(v_OrgOrderid varchar2)  is
   SELECT OD.ORDERID,od.CONTRAFIRM,OD.TRADERID,OD.CLIENTID,OOD.CUSTODYCD,OOD.BORS, OOD.QTTY QTTY, OOD.PRICE PRICE
            FROM ORDERMAP_HA MAP,ODMAST OD,OOD
            WHERE OOD.ORGORDERID=OD.ORDERID AND MAP.ORGORDERID=OD.orderid
            AND ORDERID= v_OrgOrderid;*/

    Cursor c_Onefirm(v_OrgOrderid varchar2)  is
    SELECT OD.ORDERID,od.CONTRAFIRM,OD.TRADERID,OD.CLIENTID,o1.CUSTODYCD,o1.BORS, o1.QTTY QTTY, o1.PRICE PRICE,
            o2.orgorderid ContraOrderId , o2.bors ContraBorS
            FROM ORDERMAP_HA MAP,ODMAST OD,OOD o1, ood o2, odmast om2
            WHERE o1.ORGORDERID=OD.ORDERID AND MAP.ORGORDERID=OD.orderid
            AND od.ORDERID=v_OrgOrderid
            and od.clientid = O2.custodycd
            and o1.bors <> o2.bors
            and o1.qtty = o2.qtty
            and o1.price = o2.price
            and o2.norp='P'
            --and o2.oodstatus<>'S'
            and o2.deltd <>'Y'
            and o2.orgorderid=om2.orderid
            and om2.exectype in ('NB','NS')
            and om2.remainqtty = o2.qtty
            and od.ptdeal = om2.ptdeal
            ;

   Cursor c_Twofirm(v_OrgOrderid varchar2)  is
   SELECT OD.ORDERID,od.CONTRAFIRM,OD.TRADERID,OD.CLIENTID,OOD.CUSTODYCD,OOD.BORS, OOD.QTTY QTTY, OOD.PRICE PRICE
            FROM ORDERMAP_HA MAP,ODMAST OD,OOD
            WHERE OOD.ORGORDERID=OD.ORDERID AND MAP.ORGORDERID=OD.orderid
            AND ORDERID= v_OrgOrderid;
   v_Onefirm c_Onefirm%Rowtype;
   v_Twofirm c_Twofirm%Rowtype;

   Begin

   /*
   If to_char(sysdate,'hh24miss') < '082500' or to_char(sysdate,'hh24miss') >  '112500' Then
        Return;
   End if;
   */

    For i in c_Exec_8
    Loop
       BEGIN
       v_err:='Process c_Exec_8 = CLORDID '||i.ORDERID|| ' EXECTYPE '||i.EXECTYPE ||' ORDSTATUS '||i.ORDSTATUS;

        -- Quyet.kieu 31.05.2013 Neu la lenh tu xa thi xu ly message ngay tai day
        -- Dua vao clordid do msg cua HNX tra ve de xac dinh co phai la lenh tu xa hay ko
        if INSTR(i.clordid,'HNX@091.01TX') > 0 then
            Update  Exec_8 set Process ='Y', VIA='TX'  where id =i.ID;
            Commit;
            if i.ExecType = '3' And i.OrdStatus = '2' AND i.Side = '8' Then
              -- Neu la lenh thoa thuan thi insert vao orderptdeal_delt
              -- De huy lenh qua kenh tu xa
              INSERT INTO orderptdeal_delt(OrigCrossID,SECURITYSYMBOL, SIDE,Crosstype)
                          Values( i.OrigClOrdID ,i.Symbol ,'S','1');
              commit;
            end if ;
            v_err :='Lenh qua kenh tu xa';
            Raise v_Exp;
        ELSIF length(i.clordid)    =19 THEN
            Update  Exec_8 set Process ='Y', VIA='FO'  where id =i.ID;
            Commit;
             v_err :='Lenh kenh FO';
            Raise v_Exp;
        end if ;


       If i.ExecType = '0' And i.OrdStatus = '0' Then
       --Lenh vao Queue:
           UPDATE Ordermap_Ha SET ORDER_NUMBER = i.OrderID
           Where Ctci_Order = Trim(i.ClOrdID);
       /*
        ----2013.05.31 quyet.kieu : Message nay da duoc xu ly tren PRC_PROCESS8
        Elsif i.ExecType = '0' And i.OrdStatus = 'A' Then

          --Lenh da vao Core
           v_err:='8-0-A Process c_Exec_8 = 0 A i.OrderID '||i.OrderID;
           PRC_PROCESS8
             --+ Kiem tra lenh vao Queue chua
             Open c_Ordermap_ha(i.OrderID);
             Fetch c_Ordermap_ha into v_Ordermap_ha;

             If c_Ordermap_ha%found then --Lenh da vao queue
                --v_err:=v_err || 'here';
                UPDATE OOD SET OODSTATUS = 'S', TXTIME = TO_CHAR(SYSDATE,'HH24:MI:SS')
                WHERE ORGORDERID =v_Ordermap_ha.Orgorderid;

                UPDATE ODMAST SET ORSTATUS = '2', PORSTATUS =PORSTATUS||2
                WHERE ORDERID = v_Ordermap_ha.Orgorderid AND ORSTATUS = '8';
             Else
                CLOSE C_ORDERMAP_HA;
                V_ERR :='CHUA TIM THAY LENH VAO QUEUE:'||I.ORDERID;
                RAISE V_EXP;
             End if;
             Close c_Ordermap_ha;
        */

       Elsif i.ExecType = '3' And i.OrdStatus = '2' Then
       --Lenh khop
         --1.1 Lenh khop thoa thuan
         If i.Side = '8' Then
     If trim(i.clordid) is not null Then

            INSERT INTO log_err
                              (id,date_log, POSITION, text
                              )
                       VALUES ( seq_log_err.NEXTVAL,SYSDATE, '8-3-2 Khop lenh thoa thuan ',
                       'i.OrigClOrdID ='||i.OrigClOrdID ||' i.SecondaryClOrdID = '||i.SecondaryClOrdID
                       ||' i.ClOrdID ='||i.ClOrdID ||' V_ID '||I.id
                              );

            COMMIT;

            plog.debug(pkgctx,'prc_processmsg 1');
            Begin
                Select ORGORDERID Into v_OrderID  from ORDERMAP_HA
                WHERE ORDER_NUMBER=trim(i.ClOrdID);
            plog.debug(pkgctx,'prc_processmsg 2');
            Exception when others then
             INSERT INTO orderptdeal_delt(OrigCrossID,SECURITYSYMBOL, SIDE,Crosstype)
                     Values( i.OrigClOrdID ,i.Symbol ,'S','1');
             Update  Exec_8 set Process ='Y' where id =i.ID;
             commit;
              v_err:='Lenh tu xa '||v_OrderID;
              plog.debug(pkgctx,'prc_processmsg 3');
              Raise v_exp;
            End;

            --Cap nhat thanh trang thai A tren Orderptack.
            Update Orderptack set STATUS ='A' where  CONFIRMNUMBER = i.OrderID;

            --Kiem tra xem day la lenh one-firm or two-firm put-through order
            Open c_Onefirm(v_OrderID);
            Fetch c_Onefirm into v_Onefirm;
            Close c_Onefirm;


            --Cap nhat trang thai lenh da sent thanh cong
            UPDATE OOD SET OODSTATUS = 'S', TXTIME = TO_CHAR(SYSDATE,'HH24:MI:SS')
            WHERE ORGORDERID =v_Ordermap_ha.Orgorderid;

            UPDATE ODMAST SET ORSTATUS = '2', PORSTATUS =PORSTATUS||2
            WHERE ORDERID = v_Ordermap_ha.Orgorderid AND ORSTATUS = '8';
            plog.debug(pkgctx,'prc_processmsg 4');

            -- Khop lenh cung cong ty
            If  Trim(v_Onefirm.CLIENTID) is not null And Trim(v_Onefirm.CUSTODYCD) is not null
                      --  And Substr(v_Onefirm.CLIENTID,1, 3) =Substr(v_Onefirm.CUSTODYCD,1,3)
                        Then
                  --Khop ban
                  plog.debug(pkgctx,'prc_processmsg 5');
                  matching_normal_order('', i.clordid, '', v_Onefirm.BorS, '', v_Onefirm.QTTY, v_Onefirm.PRICE, i.OrderID);
                 plog.debug(pkgctx,'prc_processmsg 6');
                 /*Begin
                    Select orgorderid, bors into v_strContraOrderId , v_strContraBorS
                     From ood
                     Where ood.custodycd= v_Onefirm.CLIENTID
                     and ood.bors <> v_Onefirm.BorS and ood.QTTY=v_Onefirm.QTTY
                     And ood.PRICE =v_Onefirm.PRICE
                     and ood.norp='P' and ood.oodstatus<>'S';
                   Exception when others then
                    v_err :='Process Exec 8 Khong tim thay lenh doi ung v_Onefirm.CLIENTID'||
                      v_Onefirm.CLIENTID||' v_Onefirm.BorS = '||
                      v_Onefirm.BorS ||' v_Onefirm.QTTY ='||v_Onefirm.QTTY ||' v_Onefirm.PRICE = '||v_Onefirm.PRICE;
                       plog.debug(pkgctx,'prc_processmsg 7');
                      Raise v_exp;
                   End; */
                   --Khop voi lenh doi ung
                 v_strContraOrderId :=v_Onefirm.ContraOrderId;
                 v_strContraBorS:=v_Onefirm.ContraBorS;
                 Select SEQ_ORDERMAP.NEXTVAL Into v_CICI_ORDER from dual;
                 --Dua vao Ordermap_HA de khop lenh tuong tu nhu lenh binh thuong:
                 INSERT INTO ORDERMAP_HA(ctci_order,orgorderid,order_number)
                 VALUES (v_CICI_ORDER ,v_strContraOrderId,v_CICI_ORDER);
                  plog.debug(pkgctx,'prc_processmsg 8');
                  Matching_normal_order('',v_CICI_ORDER, '', v_strContraBORS, '', v_Onefirm.QTTY, v_Onefirm.PRICE, i.OrderID);
                  plog.debug(pkgctx,'prc_processmsg 9');
            Else
                 --Khop khac cong ty
                  plog.debug(pkgctx,'prc_processmsg 10');
                   Open c_Twofirm(v_OrderID);
                   Fetch c_Twofirm into v_twofirm;
                   Close c_Twofirm;
                  Matching_normal_order('', i.OrigClOrdID, '', v_twofirm.BorS, '', v_twofirm.QTTY, v_twofirm.PRICE, i.OrderID);
                  plog.debug(pkgctx,'prc_processmsg 11');
            End if;

       Else  -- Lenh mua khac cong ty
                --Cap nhat thanh trang thai A tren Orderptack.
                Update Orderptack set STATUS ='A' where  CONFIRMNUMBER = i.OrderID;
                Matching_normal_order('', i.OrigClOrdID, '', 'B', '', i.LASTQTY, i.LASTPX, i.OrderID);
       End If;
       ---------

     Else

          plog.debug(pkgctx,'prc_processmsg 12');
         --1.2 Lenh khop thuong
            --1.2.1 Lenh ban da co trong  Queue
             INSERT INTO log_err
                              (id,date_log, POSITION, text
                              )
                       VALUES ( seq_log_err.NEXTVAL,SYSDATE, '1. 8-3-2 Lenh khop thuong Process Exec_8 0 ',
                       'i.OrigClOrdID ='||i.OrigClOrdID ||' i.SecondaryClOrdID = '||i.SecondaryClOrdID
                       ||' i.OrderID ='||i.OrderID ||' V_ID '||I.id
                              );

             COMMIT;

             v_Check:=0;
             Open c_Ordermap_ha(i.OrigClOrdID);
             Fetch c_Ordermap_ha into v_Ordermap_ha;
             If c_Ordermap_ha%Found then
               v_Check:=1;
               UPDATE OOD SET OODSTATUS = 'S',
                               TXTIME = TO_CHAR(SYSDATE,'HH24:MI:SS')
                               WHERE
                               OODSTATUS <> 'S'
                               AND ORGORDERID = v_Ordermap_ha.Orgorderid;


               Matching_normal_order('', i.OrigClOrdID, '', 'S', '', i.LASTQTY, i.LASTPX, i.OrderID);
             End if;

             Close c_Ordermap_ha;

             --1.2.2 Lenh mua da co trong  Queue
             Open c_Ordermap_ha(i.SecondaryClOrdID);
             Fetch c_Ordermap_ha into v_Ordermap_ha;
             If c_Ordermap_ha%Found then
                v_Check:=1;
                UPDATE OOD SET OODSTATUS = 'S',
                               TXTIME = TO_CHAR(SYSDATE,'HH24:MI:SS')
                               WHERE
                               OODSTATUS <> 'S'
                               AND ORGORDERID = v_Ordermap_ha.Orgorderid;

                Matching_normal_order('', i.SecondaryClOrdID, '', 'B', '',  i.LASTQTY, i.LASTPX, i.OrderID);
             End if;
            Close c_Ordermap_ha;



            if v_Check =0 then
              -- Neu ko tim thay lenh goc thi chuyen ve trang thai Reprocess de xu ly ben Prc_ProcessMsg_ex ,
              -- De nham giam tan suat xu ly
              -- 'Update  Exec_8 set ReProcess =ReProcess + 1, Process ='Y' where id =i.ID;
              --'Commit;
              v_err :='2. 8-3-2 Prc_ProcessMsg khong tim thay lenh goc => Chuyen qua xu ly Prc_ProcessMsg_ex : i.OrigClOrdID='||i.OrigClOrdID ||'  i.SecondaryClOrdID ='||i.SecondaryClOrdID;
              Update  Exec_8 set Process ='Y' where id =i.ID;
              Commit;
              Raise v_Exp;
            End if;

         End if;

      Elsif i.ExecType = '4' And i.OrdStatus = 'D' Then
            --Lenh huy dong y
            --Lenh huy da vao he thong: Khong xu ly gi, chi xu ly khi huy thanh cong
             Update ood set OODSTATUS ='S'
             where Reforderid in(select orgorderid from ordermap_ha
                                 where order_number =i.OrigClOrdID);

      Elsif i.ExecType = '4' And i.OrdStatus ='0' Then
      --Lenh sua vao Queue
        Null;
      Elsif i.ExecType = '4' And i.OrdStatus ='3' Then --Huy lenh thuong thanh cong

            If i.Side <> '8' Then

                    Open c_Ordermap_ha(i.OrigClOrdID);
                    Fetch c_Ordermap_ha into v_Ordermap_ha;
                    If c_Ordermap_ha%Found then
                       CONFIRM_CANCEL_NORMAL_ORDER(v_Ordermap_ha.Orgorderid,i.LeavesQty);
                   Else
                        Close c_Ordermap_ha;
                        v_err :='Khong tim thay lenh goc cua lenh huy:'||i.OrigClOrdID;
                        Raise v_exp;

                    End if;
                    Close c_Ordermap_ha;



             Else --Huy lenh thoa thuan: chi ghi nhan, ko xu ly gi
                INSERT INTO Haptcancelled(securitysymbol, confirmnumber,status, volume, price)
                                  VALUES (i.Symbol ,i.OrderID  , 'H',i.LeavesQty,i.Price);
                --Lay so hieu lenh goc:
                Begin
                   Select Orgorderid into v_Orgorderid from Ordermap_ha where Order_number =trim(i.Orderid);
                   --Update lenh ve trang thai Delete

                   Update odmast set deltd ='Y', CANCELQTTY =ORDERQTTY,REMAINQTTY=0,EXECQTTY =0 ,MATCHAMT =0,Execamt =0 where orderid = v_Orgorderid;
                   Update ood set  deltd ='Y' where orgorderid = v_Orgorderid;
                   Update iod set deltd ='Y' where Orgorderid = v_Orgorderid;
                   Update stschd set deltd='Y' where Orgorderid = v_Orgorderid;
                   For vc in (select orderid
                               From odmast where grporder='Y' and  orderid= V_ORGORDERID)
                   loop
                       cspks_seproc.pr_executeod9996(V_ORGORDERID,p_err_code,p_err_param);
                   End loop;

                   --Tim trong IOD so hieu lenh khop la i.Orderid de xoa lenh khop doi ung cung cong ty,
                   Begin

                       Select orgorderid into v_Orgorderid
                       from IOD
                       where  Deltd <>'Y' and bors='B' and norp='P' and
                        confirm_no in(select confirm_no from iod where Orgorderid =v_Orgorderid);

                       Update odmast set deltd ='Y', CANCELQTTY =ORDERQTTY,REMAINQTTY=0 ,EXECQTTY =0,MATCHAMT =0,Execamt =0
                       where orderid = v_Orgorderid;
                       Update ood set  deltd ='Y' where orgorderid = v_Orgorderid;
                       Update iod set deltd ='Y' where Orgorderid = v_Orgorderid;
                       Update stschd set deltd='Y' where Orgorderid = v_Orgorderid;

                       For vc in (select orderid
                               From odmast where grporder='Y' and  orderid= V_ORGORDERID)
                       loop
                          cspks_seproc.pr_executeod9996(v_Orgorderid,p_err_code,p_err_param);
                       End loop;

                        -- quyet.kieu : Them cho LINHLNB 21/02/2012  -------------------------------------------
                        For j in (Select orgorderid ,codeid,bors,matchprice,matchqtty,txnum,txdate ,custodycd
                                  From iod
                                  Where NorP ='P'
                                   And confirm_no =trim(i.Orderid))
                        Loop
                            if j.bors = 'B' then
                               -- quyet.kieu : Them cho LINHLNB 21/02/2012
                               -- Begin Danh sau tai san LINHLNB
                                Select  afacctno into v_afaccount  from ODMAST   Where MATCHTYPE ='P' And Orderid = j.orgorderid;
                                INSERT INTO odchanging_trigger_log (AFACCTNO,CODEID,AMT,TXNUM,TXDATE,ERRCODE,LAST_CHANGE,ORDERID,ACTIONFLAG,QTTY)
                               VALUES( v_afaccount,j.codeid ,j.matchprice * j.matchqtty,j.txnum, j.txdate,NULL,systimestamp,j.orgorderid,'C',j.matchqtty);
                              -- End Danh dau tai san LINHLNB
                              end if ;
                         End Loop;
                         -- End Them cho LINHLNB 21/02/2012  ------------------------------------------------------
                    Exception when others then
                     Null;
                    End;
                Exception when others then
                   Null;
                End;
             End if;

       ElsIf i.ExecType = '5' And i.OrdStatus = 'D' Then
            --Lenh sua da vao he thong: Khong xu ly gi, chi xu ly khi sua thanh cong
            Null;
       ElsIf i.ExecType = '5' And i.OrdStatus = '0' Then
             --Lenh sua da vao Queue khong lam gi
            Null;
       ElsIf i.ExecType = '5' And i.OrdStatus = '3' Then --Lenh sua thanh cong
         v_err :='Lenh sua:'||i.OrigClOrdID;
                    Open c_Ordermap_ha(i.OrigClOrdID);
                    Fetch c_Ordermap_ha into v_Ordermap_ha;
                    If c_Ordermap_ha%Found then

                       CONFIRM_REPLACE_NORMAL_ORDER(i.OrigClOrdID,i.LastQty,i.LastPx, i.LeavesQty);

                    Else
                        Close c_Ordermap_ha;
                        v_err :='Khong tim thay lenh goc cua lenh sua:'||i.OrigClOrdID;
                        Raise v_exp;

                    End if;
                    Close c_Ordermap_ha;


       Elsif i.ExecType = '8' And i.OrdStatus ='8' Then --HNX gui msg giai toa lenh

            Open c_Ordermap_ha(i.OrderID);
            Fetch c_Ordermap_ha into v_Ordermap_ha;
            If c_Ordermap_ha%Found then
               CONFIRM_CANCEL_NORMAL_ORDER(v_Ordermap_ha.Orgorderid,i.UnderlyingLastQty);
            Else
               --begin HNX_update_GL | sua 8-8-8 dat lenh bi tu choi
               Open c_Ordermap_ha_ctci(i.clordid);
               Fetch c_Ordermap_ha_ctci into v_Ordermap_ha;
               If c_Ordermap_ha_ctci%Found THEN
                  CONFIRM_CANCEL_NORMAL_ORDER(v_Ordermap_ha.Orgorderid,i.UnderlyingLastQty);
                  UPDATE odmast od SET od.feedbackmsg=i.OrdRejReason WHERE orderid =v_Ordermap_ha.Orgorderid;
               ELSE
                  Close c_Ordermap_ha;
                  Close c_Ordermap_ha_ctci;
                  v_err :='8-8-8 Khong tim thay lenh goc cua lenh huy:'||i.OrderID;
                  v_CheckProcess := false;
                  Raise v_exp;
               END IF;
               Close c_Ordermap_ha_ctci;
               --end HNX_update_GL
            End if;
            Close c_Ordermap_ha;

       End if;


       Update  Exec_8 set Process ='Y' where id =i.ID;
       Commit;





       EXCEPTION WHEN v_exp then
            Rollback;

            INSERT INTO log_err
                      (id,date_log, POSITION, text
                      )
               VALUES ( seq_log_err.NEXTVAL,SYSDATE, ' Process Exec_8 v_exp', v_err
                      );
            Commit;

        END;

    End Loop;


EXCEPTION
   WHEN  Others

   THEN
   v_err :=v_err||'  ' ||sqlerrm;
      INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, ' Process Exec_8 ', v_err
                  );

      COMMIT;
   End;

  Procedure Prc_ProcessMsg_ex
    is
    v_OrderID varchar2(20);
    v_err  varchar2(150);
    v_strContraOrderId varchar2(30);
    v_strContraBorS varchar2(30);
    v_CICI_ORDER varchar2(30);
    v_Check number(1);
     v_IsProcess Varchar2(20);
    v_exp  Exception;

   Cursor c_Exec_8_1 is Select *  from Exec_8
        where Process  ='Y'and  EXECTYPE ='3' and ORDSTATUS ='2'
        --and Reprocess > 0
        and ORIGCLORDID in
        (select order_number from ordermap_ha)
        And not exists (select 1 from iod where bors ='S' and Exec_8.ORDERID=iod.confirm_no);

   v_Exec_8  c_Exec_8_1%rowtype;

    Cursor c_Exec_8_2 is  Select *  from Exec_8

        where Process  ='Y'and  EXECTYPE ='3' and ORDSTATUS ='2'
       -- and Reprocess > 0
        and SECONDARYCLORDID in
        (select order_number from ordermap_ha)
        And not exists (select 1 from iod where bors ='B' and Exec_8.ORDERID=iod.confirm_no);


   Cursor c_Ordermap_ha(v_ORDER_NUMBER varchar2) Is
          SELECT * FROM ORDERMAP_HA WHERE NVL(ORDER_NUMBER,'0') = v_ORDER_NUMBER;
   v_Ordermap_ha c_Ordermap_ha%Rowtype;


   Begin

   v_IsProcess:='N';
   Begin
      Select SYSVALUE Into v_IsProcess From Ordersys_ha
      Where SYSNAME ='ISPROCESS';
   Exception When others then
        v_IsProcess:='N';
   End;
   If v_IsProcess = 'N' then
        return;
   Else
       For i in (select * from exec_8
        where clordid is not null
        and EXECTYPE ='0'
        and ORDSTATUS ='A'
        and process ='Y'
        and CLORDID in (select ctci_order from ordermap_ha where order_number is null)
        )
        Loop
          Update ordermap_ha set order_number =i.ORDERID where CTCI_ORDER =i.clordid;
          commit;
        End loop;


        For i in c_Exec_8_1
        Loop
        --1.2 Lenh khop thuong
          --1.2.1 Lenh ban da co trong  Queue

             INSERT INTO log_err
                              (id,date_log, POSITION, text
                              )
                       VALUES ( seq_log_err.NEXTVAL,SYSDATE, 'Lenh khop thuong Process Exec_8 ',
                       'i.OrigClOrdID ='||i.OrigClOrdID
                       ||' i.OrderID ='||i.OrderID ||' V_ID '||I.id
                              );

             COMMIT;

             Open c_Ordermap_ha(i.OrigClOrdID);
             Fetch c_Ordermap_ha into v_Ordermap_ha;
             If c_Ordermap_ha%Found then
               v_Check:=1;
               UPDATE OOD SET OODSTATUS = 'S',
                               TXTIME = TO_CHAR(SYSDATE,'HH24:MI:SS')
                               WHERE
                               OODSTATUS <> 'S'
                               AND ORGORDERID = v_Ordermap_ha.Orgorderid;
               Matching_normal_order('', i.OrigClOrdID, '', 'S', '', i.LASTQTY, i.LASTPX, i.OrderID);


             End if;
             Close c_Ordermap_ha;

        End loop;

        For i in c_Exec_8_2
        Loop
        --1.2 Lenh khop thuong
          --1.2.1 Lenh ban da co trong  Queue

             INSERT INTO log_err
                              (id,date_log, POSITION, text
                              )
                       VALUES ( seq_log_err.NEXTVAL,SYSDATE, 'Lenh khop thuong Process_e_2 Exec_8 ',
                       ' i.SecondaryClOrdID = '||i.SecondaryClOrdID
                       ||' i.OrderID ='||i.OrderID ||' V_ID '||I.id
                              );

             COMMIT;

                 --1.2.2 Lenh mua da co trong  Queue

                 Open c_Ordermap_ha(i.SecondaryClOrdID);
                 Fetch c_Ordermap_ha into v_Ordermap_ha;
                 If c_Ordermap_ha%Found then
                    v_Check:=1;
                    UPDATE OOD SET OODSTATUS = 'S',
                                   TXTIME = TO_CHAR(SYSDATE,'HH24:MI:SS')
                                   WHERE
                                   OODSTATUS <> 'S'
                                   AND ORGORDERID = v_Ordermap_ha.Orgorderid;
                    Matching_normal_order('', i.SecondaryClOrdID, '', 'B', '',  i.LASTQTY, i.LASTPX, i.OrderID);


                 End if;

                Close c_Ordermap_ha;

            End loop;
        End if;
 EXCEPTION
   WHEN  Others

   THEN
   v_err :=v_err||'  ' ||sqlerrm;
      INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, ' Process Exec_8_e ', v_err
                  );

      COMMIT;
   End;

   FUNCTION fnc_check_sec_ha
          ( v_Symbol IN varchar2)
         RETURN  number IS

        Cursor c_SecInfo(vc_Symbol varchar2) is
            Select 1 from hasecurity_req where
            symbol =vc_Symbol;
          v_Number Number(10);
          v_Result varchar2(10);
    BEGIN
          Open c_SecInfo(v_Symbol);
          Fetch c_SecInfo into v_Number;
          If c_SecInfo%notfound  Then
              v_Result :='0';
          Else
             v_Result :='1';
          End if;
          Close c_SecInfo;
          RETURN v_Result;
    END;


    --XU LY MESSAGE NHAN VE
  Procedure PRC_PROCESS is
    CURSOR C_MSG_RECEIVE IS
     Select * from
 (
  -- quyet.kieu 03.06.2013 Chi xu ly nhung message h can thiet
  SELECT MSGTYPE,ID, REPLACE(MSGXML,'&',' ') MSGXML, PROCESS FROM MSGRECEIVETEMP_HA WHERE PROCESS ='N' --and MSGTYPE <>'h'
 -- union all
  -- Chi xu ly nhung message h chuyen phien
 -- SELECT MSGTYPE,ID, REPLACE(MSGXML,'&',' ') MSGXML, PROCESS FROM MSGRECEIVETEMP_HA WHERE PROCESS ='N' and MSGTYPE ='h'
 -- and ( msgxml like '%<key>TradSesReqID</key><value>LIS_BRD_01</value>%' OR msgxml like '%<key>TradSesReqID</key><value>UPC_BRD_01</value>%' )
  )
  WHERE  ROWNUM BETWEEN 0 AND (SELECT SYSVALUE FROM ORDERSYS_HA WHERE SYSNAME='HARECEIVESIZE');


    V_MSG_RECEIVE C_MSG_RECEIVE%ROWTYPE;
  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_PROCESS');
      OPEN C_MSG_RECEIVE;
      LOOP
          FETCH C_MSG_RECEIVE INTO V_MSG_RECEIVE;
          EXIT WHEN C_MSG_RECEIVE%NOTFOUND;
          plog.debug(pkgctx,'Process message ID = '||V_MSG_RECEIVE.ID);
          BEGIN
            v_CheckProcess := TRUE;
            IF V_MSG_RECEIVE.MSGTYPE ='8' THEN
              PRC_PROCESS8(V_MSG_RECEIVE.MSGXML,V_MSG_RECEIVE.ID);
            --phuongntn add xu reject
            ELSIF V_MSG_RECEIVE.MSGTYPE ='3' THEN
              PRC_PROCESS3(V_MSG_RECEIVE.MSGXML,V_MSG_RECEIVE.ID);
            --  end add
            ELSIF V_MSG_RECEIVE.MSGTYPE ='7' THEN
              PRC_PROCESS7(V_MSG_RECEIVE.MSGXML,V_MSG_RECEIVE.ID);
            ELSIF V_MSG_RECEIVE.MSGTYPE ='f' THEN
              PRC_PROCESSf(V_MSG_RECEIVE.MSGXML,V_MSG_RECEIVE.ID);
            ELSIF V_MSG_RECEIVE.MSGTYPE ='h' THEN
              PRC_PROCESSh(V_MSG_RECEIVE.MSGXML,V_MSG_RECEIVE.ID);
            ELSIF V_MSG_RECEIVE.MSGTYPE ='s' THEN
              PRC_PROCESSs(V_MSG_RECEIVE.MSGXML,V_MSG_RECEIVE.ID);
            ELSIF V_MSG_RECEIVE.MSGTYPE ='u' THEN
              PRC_PROCESSu(V_MSG_RECEIVE.MSGXML,V_MSG_RECEIVE.ID);
            ELSIF V_MSG_RECEIVE.MSGTYPE ='BF' THEN  --MSBS-1853  HNX_update_GL
              PRC_PROCESSBF(V_MSG_RECEIVE.MSGXML,V_MSG_RECEIVE.ID);
            ELSIF V_MSG_RECEIVE.MSGTYPE ='A' THEN   --MSBS-1853  HNX_update_GL
                PRC_PROCESSA(V_MSG_RECEIVE.MSGXML,V_MSG_RECEIVE.ID);
            END IF;
             IF v_CheckProcess THEN
                UPDATE MSGRECEIVETEMP_HA
                SET PROCESS ='Y'
                WHERE ID =V_MSG_RECEIVE.ID;
            ELSE
                UPDATE MSGRECEIVETEMP_HA
                SET PROCESS ='E'
                WHERE ID =V_MSG_RECEIVE.ID;
                plog.error(pkgctx,'HAGW.PRC_PROCESS '||'Cant not process MSG ID = '||V_MSG_RECEIVE.ID||' V_MSG_RECEIVE.MSGTYPE = '||V_MSG_RECEIVE.MSGTYPE);
            END IF;
            COMMIT;
         -- UPDATE MSGRECEIVETEMP_HA SET PROCESS ='Y' WHERE ID =V_MSG_RECEIVE.ID;
         -- COMMIT;
          EXCEPTION WHEN OTHERS THEN
            plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
            Rollback;
            UPDATE MSGRECEIVETEMP_HA SET PROCESS ='R' WHERE ID =V_MSG_RECEIVE.ID;
            plog.error(pkgctx,'HAGW.PRC_PROCESS'||'exeption in process MSG ID = '||V_MSG_RECEIVE.ID||' V_MSG_RECEIVE.MSGTYPE = '||V_MSG_RECEIVE.MSGTYPE);
            Commit;
        END;
      END LOOP;
      CLOSE C_MSG_RECEIVE;

      plog.setendsection (pkgctx, 'PRC_PROCESS');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_PROCESS');
    ROLLBACK;
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_PROCESS;


  FUNCTION fn_xml2obj_8(p_xmlmsg    VARCHAR2) RETURN tx.msg_8 IS
    l_parser   xmlparser.parser;
    l_doc      xmldom.domdocument;
    l_nodeList xmldom.domnodelist;
    l_node     xmldom.domnode;
    n     xmldom.domnode;

    l_fldname fldmaster.fldname%TYPE;
    l_txmsg   tx.msg_8;
    v_Key Varchar2(100);
    v_Value Varchar2(100);


  BEGIN
    plog.setbeginsection (pkgctx, 'fn_xml2obj_8');

    plog.debug(pkgctx,'msg length: ' || length(p_xmlmsg));
    l_parser := xmlparser.newparser();
    plog.debug(pkgctx,'1');
    xmlparser.parseclob(l_parser, p_xmlmsg);
    plog.debug(pkgctx,'2');
    l_doc := xmlparser.getdocument(l_parser);
    plog.debug(pkgctx,'3');
    xmlparser.freeparser(l_parser);

    plog.debug(pkgctx,'Prepare to parse Message Fields');

    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                           '/ArrayOfHoSEMessageEntry/hoSEMessageEntry');

    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
      plog.debug(pkgctx,'parse fields: ' || i);
      l_node := xmldom.item(l_nodeList, i);
      dbms_xslprocessor.valueOf(l_node,'key',v_Key);
      dbms_xslprocessor.valueOf(l_node,'value',v_Value);
      If v_Key ='ClOrdID'  Then
        l_txmsg.ClOrdID := v_Value;
      Elsif v_Key ='TransactTime' Then
        l_txmsg.TransactTime := v_Value;
      Elsif v_Key ='ExecType' Then
        l_txmsg.ExecType := v_Value;
      Elsif v_Key ='OrderQty' Then
        l_txmsg.OrderQty := v_Value;
      Elsif v_Key ='OrderID' Then
        l_txmsg.OrderID := v_Value;
      Elsif v_Key ='Side' Then
        l_txmsg.Side := v_Value;
      Elsif v_Key ='Symbol' Then
        l_txmsg.Symbol := v_Value;
      Elsif v_Key ='Price' Then
        l_txmsg.Price := v_Value;
      Elsif v_Key ='Account' Then
        l_txmsg.Account := v_Value;
      Elsif v_Key ='OrdStatus' Then
        l_txmsg.OrdStatus := v_Value;
      Elsif v_Key ='OrigClOrdID' Then
        l_txmsg.OrigClOrdID := v_Value;
      Elsif v_Key ='SecondaryClOrdID' Then
        l_txmsg.SecondaryClOrdID := v_Value;
      Elsif v_Key ='LastQty' Then
        l_txmsg.LastQty := v_Value;
      Elsif v_Key ='LastPx' Then
        l_txmsg.LastPx := v_Value;
      Elsif v_Key ='ExecID' Then
        l_txmsg.ExecID := v_Value;
      Elsif v_Key ='LeavesQty' Then
        l_txmsg.LeavesQty := v_Value;
      Elsif v_Key ='OrdType' Then
        l_txmsg.OrdType := v_Value;
      Elsif v_Key ='UnderlyingLastQty' Then
        l_txmsg.UnderlyingLastQty := v_Value;
      Elsif v_Key ='OrdRejReason' Then
        l_txmsg.OrdRejReason := v_Value;
      Elsif v_Key ='MsgSeqNum' Then
        l_txmsg.MsgSeqNum := v_Value;
      End if;
    END LOOP;

    plog.debug(pkgctx,'msg 8 l_txmsg.ORDERID: '||l_txmsg.ORDERID
             ||' l_txmsg.ExecType ='|| l_txmsg.ExecType
             ||' l_txmsg.OrdStatus ='|| l_txmsg.OrdStatus);
    plog.debug(pkgctx,'Free resources associated');

    -- Free any resources associated with the document now it
    -- is no longer needed.
    DBMS_XMLDOM.freedocument(l_doc);
    -- Only used if variant is CLOB
    -- dbms_lob.freetemporary(p_xmlmsg);

    plog.setendsection(pkgctx, 'fn_xml2obj_8');
    RETURN l_txmsg;
  EXCEPTION
    WHEN OTHERS THEN
      --dbms_lob.freetemporary(p_xmlmsg);
      DBMS_XMLPARSER.freeparser(l_parser);
      DBMS_XMLDOM.freedocument(l_doc);
      plog.error(pkgctx, SQLERRM);
      plog.setendsection(pkgctx, 'fn_xml2obj_8');
      RAISE errnums.E_SYSTEM_ERROR;
  END fn_xml2obj_8;


  FUNCTION fn_xml2obj_s(p_xmlmsg    VARCHAR2) RETURN tx.msg_s IS
    l_parser   xmlparser.parser;
    l_doc      xmldom.domdocument;
    l_nodeList xmldom.domnodelist;
    l_node     xmldom.domnode;
    n     xmldom.domnode;

    l_fldname fldmaster.fldname%TYPE;
    l_txmsg   tx.msg_s;
    v_Key Varchar2(100);
    v_Value Varchar2(100);


  BEGIN
    plog.setbeginsection (pkgctx, 'fn_xml2obj_s');

    plog.debug(pkgctx,'msg length: ' || length(p_xmlmsg));
    l_parser := xmlparser.newparser();
    plog.debug(pkgctx,'1');
    xmlparser.parseclob(l_parser, p_xmlmsg);
    plog.debug(pkgctx,'2');
    l_doc := xmlparser.getdocument(l_parser);
    plog.debug(pkgctx,'3');
    xmlparser.freeparser(l_parser);

    plog.debug(pkgctx,'Prepare to parse Message Fields');

    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                           '/ArrayOfHoSEMessageEntry/hoSEMessageEntry');

    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
      plog.debug(pkgctx,'parse fields: ' || i);
      l_node := xmldom.item(l_nodeList, i);
      dbms_xslprocessor.valueOf(l_node,'key',v_Key);
      dbms_xslprocessor.valueOf(l_node,'value',v_Value);
      If v_Key ='CrossID'  Then
        l_txmsg.CrossID := v_Value;
      Elsif v_Key ='CrossType' Then
        l_txmsg.CrossType := v_Value;
      Elsif v_Key ='NoSides' Then
        l_txmsg.NoSides := v_Value;
      Elsif v_Key ='SellSide' Then
        l_txmsg.SellSide := v_Value;
      Elsif v_Key ='BuySide' Then
        l_txmsg.BuySide := v_Value;
      Elsif v_Key ='Symbol' Then
        l_txmsg.Symbol := v_Value;
      Elsif v_Key ='BuyPartyID' Then
        l_txmsg.BuyPartyID := v_Value;
      Elsif v_Key ='SellPartyID' Then
        l_txmsg.SellPartyID := v_Value;
      Elsif v_Key ='Price' Then
        l_txmsg.Price := v_Value;
      Elsif v_Key ='SellOrderQty' Then
        l_txmsg.SellOrderQty := v_Value;
      Elsif v_Key ='BuyOrderQty' Then
        l_txmsg.BuyOrderQty := v_Value;
      Elsif v_Key ='SellAccount' Then
        l_txmsg.SellAccount := v_Value;
      Elsif v_Key ='BuyAccount' Then
        l_txmsg.BuyAccount := v_Value;
      Elsif v_Key ='SellAccountType' Then
        l_txmsg.SellAccountType := v_Value;
      Elsif v_Key ='BuyAccountType' Then
        l_txmsg.BuyAccountType := v_Value;
      Elsif v_Key ='SellClOrdID' Then
        l_txmsg.SellClOrdID := v_Value;
      Elsif v_Key ='BuyClOrdID' Then
        l_txmsg.BuyClOrdID := v_Value;
      End if;
    END LOOP;

    plog.debug(pkgctx,'msg s l_txmsg.CrossID: '||l_txmsg.CrossID
             ||' l_txmsg.CrossType ='|| l_txmsg.CrossType
             ||' l_txmsg.Price ='|| l_txmsg.Price
             ||' l_txmsg.SellOrderQty ='|| l_txmsg.SellOrderQty
             ||' l_txmsg.BuyPartyID ='|| l_txmsg.BuyPartyID
             ||' l_txmsg.SellPartyID ='|| l_txmsg.SellPartyID
             ||' l_txmsg.SellClOrdID ='|| l_txmsg.SellClOrdID
             ||' l_txmsg.BuyClOrdID ='|| l_txmsg.BuyClOrdID
             );
    plog.debug(pkgctx,'Free resources associated');

    -- Free any resources associated with the document now it
    -- is no longer needed.
    DBMS_XMLDOM.freedocument(l_doc);
    -- Only used if variant is CLOB
    -- dbms_lob.freetemporary(p_xmlmsg);

    plog.setendsection(pkgctx, 'fn_xml2obj_s');
    RETURN l_txmsg;
  EXCEPTION
    WHEN OTHERS THEN
      --dbms_lob.freetemporary(p_xmlmsg);
      DBMS_XMLPARSER.freeparser(l_parser);
      DBMS_XMLDOM.freedocument(l_doc);
      plog.error(pkgctx, SQLERRM);
      plog.setendsection(pkgctx, 'fn_xml2obj_s');
      RAISE errnums.E_SYSTEM_ERROR;
  END fn_xml2obj_s;




  FUNCTION fn_xml2obj_u(p_xmlmsg    VARCHAR2) RETURN tx.msg_u IS
    l_parser   xmlparser.parser;
    l_doc      xmldom.domdocument;
    l_nodeList xmldom.domnodelist;
    l_node     xmldom.domnode;
    n     xmldom.domnode;

    l_fldname fldmaster.fldname%TYPE;
    l_txmsg   tx.msg_u;
    v_Key Varchar2(100);
    v_Value Varchar2(100);


  BEGIN
    plog.setbeginsection (pkgctx, 'fn_xml2obj_u');

    plog.debug(pkgctx,'msg length: ' || length(p_xmlmsg));
    l_parser := xmlparser.newparser();
    plog.debug(pkgctx,'1');
    xmlparser.parseclob(l_parser, p_xmlmsg);
    plog.debug(pkgctx,'2');
    l_doc := xmlparser.getdocument(l_parser);
    plog.debug(pkgctx,'3');
    xmlparser.freeparser(l_parser);

    plog.debug(pkgctx,'Prepare to parse Message Fields');

    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                           '/ArrayOfHoSEMessageEntry/hoSEMessageEntry');

    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
      plog.debug(pkgctx,'parse fields: ' || i);
      l_node := xmldom.item(l_nodeList, i);
      dbms_xslprocessor.valueOf(l_node,'key',v_Key);
      dbms_xslprocessor.valueOf(l_node,'value',v_Value);
      If v_Key ='CrossID'  Then
        l_txmsg.CrossID := v_Value;
      Elsif v_Key ='OrigCrossID' Then
        l_txmsg.OrigCrossID := v_Value;
      Elsif v_Key ='CrossType' Then
        l_txmsg.CrossType := v_Value;
      Elsif v_Key ='SenderCompID' Then
        l_txmsg.SenderCompID := v_Value;
      Elsif v_Key ='TargetCompID' Then
        l_txmsg.TargetCompID := v_Value;
      Elsif v_Key ='TargetSubID' Then
        l_txmsg.TargetSubID := v_Value;
      End if;
    END LOOP;

    plog.debug(pkgctx,'msg s l_txmsg.CrossID: '||l_txmsg.CrossID
             ||' l_txmsg.CrossType ='|| l_txmsg.CrossType
             ||' l_txmsg.SenderCompID ='|| l_txmsg.SenderCompID
             ||' l_txmsg.TargetCompID ='|| l_txmsg.TargetCompID
             ||' l_txmsg.TargetSubID ='|| l_txmsg.TargetSubID);
    plog.debug(pkgctx,'Free resources associated');

    -- Free any resources associated with the document now it
    -- is no longer needed.
    DBMS_XMLDOM.freedocument(l_doc);
    -- Only used if variant is CLOB
    -- dbms_lob.freetemporary(p_xmlmsg);

    plog.setendsection(pkgctx, 'fn_xml2obj_u');
    RETURN l_txmsg;
  EXCEPTION
    WHEN OTHERS THEN
      --dbms_lob.freetemporary(p_xmlmsg);
      DBMS_XMLPARSER.freeparser(l_parser);
      DBMS_XMLDOM.freedocument(l_doc);
      plog.error(pkgctx, SQLERRM);
      plog.setendsection(pkgctx, 'fn_xml2obj_u');
      RAISE errnums.E_SYSTEM_ERROR;
  END fn_xml2obj_u;
--phuongntn add xml msg reject
FUNCTION fn_xml2obj_3(p_xmlmsg    VARCHAR2) RETURN tx.msg_3 IS
l_parser   xmlparser.parser;
l_doc      xmldom.domdocument;
l_nodeList xmldom.domnodelist;
l_node     xmldom.domnode;
n     xmldom.domnode;

l_fldname fldmaster.fldname%TYPE;
l_txmsg   tx.msg_3;
v_Key Varchar2(100);
v_Value Varchar2(100);


BEGIN
plog.setbeginsection (pkgctx, 'fn_xml2obj_3');

plog.debug(pkgctx,'msg length: ' || length(p_xmlmsg));
l_parser := xmlparser.newparser();
plog.debug(pkgctx,'1');
xmlparser.parseclob(l_parser, p_xmlmsg);
plog.debug(pkgctx,'2');
l_doc := xmlparser.getdocument(l_parser);
plog.debug(pkgctx,'3');
xmlparser.freeparser(l_parser);

plog.debug(pkgctx,'Prepare to parse Message Fields');

l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                               '/ArrayOfHoSEMessageEntry/hoSEMessageEntry');

FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
plog.debug(pkgctx,'parse fields: ' || i);
l_node := xmldom.item(l_nodeList, i);
dbms_xslprocessor.valueOf(l_node,'key',v_Key);
dbms_xslprocessor.valueOf(l_node,'value',v_Value);
If v_Key ='SessionRejectReason'  Then
l_txmsg.SessionRejectReason := trim(v_Value);
Elsif v_Key ='RefMsgType' Then
l_txmsg.RefMsgType := trim(v_Value);
Elsif v_Key ='Text' Then
l_txmsg.Text := trim(v_Value);
Elsif v_Key ='ClOrdID' Then
l_txmsg.ClOrdID  := trim(v_Value);
Elsif v_Key ='RefSeqNum' Then
l_txmsg.RefSeqNum  := trim(v_Value);
Elsif v_Key ='UserRequestID' THEN   --MSBS-1853  HNX_update_GL
l_txmsg.UserRequestID  := trim(v_Value);
End if;
END LOOP;

plog.debug(pkgctx,'msg s l_txmsg.SessionRejectReason: '||l_txmsg.SessionRejectReason
 ||' l_txmsg.RefMsgType ='|| l_txmsg.RefMsgType
 ||' l_txmsg.Text ='|| l_txmsg.Text
 ||' l_txmsg.RefSeqNum ='|| l_txmsg.RefSeqNum);
plog.debug(pkgctx,'Free resources associated');

-- Free any resources associated with the document now it
-- is no longer needed.
DBMS_XMLDOM.freedocument(l_doc);
-- Only used if variant is CLOB
-- dbms_lob.freetemporary(p_xmlmsg);

plog.setendsection(pkgctx, 'fn_xml2obj_3');
RETURN l_txmsg;
EXCEPTION
WHEN OTHERS THEN
--dbms_lob.freetemporary(p_xmlmsg);
DBMS_XMLPARSER.freeparser(l_parser);
DBMS_XMLDOM.freedocument(l_doc);
plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
plog.setendsection(pkgctx, 'fn_xml2obj_3');
RAISE errnums.E_SYSTEM_ERROR;
END fn_xml2obj_3;

  FUNCTION fn_xml2obj_7(p_xmlmsg    VARCHAR2) RETURN tx.msg_7 IS
    l_parser   xmlparser.parser;
    l_doc      xmldom.domdocument;
    l_nodeList xmldom.domnodelist;
    l_node     xmldom.domnode;
    n     xmldom.domnode;

    l_fldname fldmaster.fldname%TYPE;
    l_txmsg   tx.msg_7;
    v_Key Varchar2(100);
    v_Value Varchar2(100);


  BEGIN
    plog.setbeginsection (pkgctx, 'fn_xml2obj_7');

    plog.debug(pkgctx,'msg length: ' || length(p_xmlmsg));
    l_parser := xmlparser.newparser();
    plog.debug(pkgctx,'1');
    xmlparser.parseclob(l_parser, p_xmlmsg);
    plog.debug(pkgctx,'2');
    l_doc := xmlparser.getdocument(l_parser);
    plog.debug(pkgctx,'3');
    xmlparser.freeparser(l_parser);

    plog.debug(pkgctx,'Prepare to parse Message Fields');

    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                           '/ArrayOfHoSEMessageEntry/hoSEMessageEntry');

    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
      plog.debug(pkgctx,'parse fields: ' || i);
      l_node := xmldom.item(l_nodeList, i);
      dbms_xslprocessor.valueOf(l_node,'key',v_Key);
      dbms_xslprocessor.valueOf(l_node,'value',v_Value);
      If v_Key ='AdvSide'  Then
        l_txmsg.AdvSide := v_Value;
      Elsif v_Key ='Text' Then
        l_txmsg.Text := v_Value;
      Elsif v_Key ='Quantity' Then
        l_txmsg.Quantity := v_Value;
      Elsif v_Key ='AdvTransType' Then
        l_txmsg.AdvTransType := v_Value;
      Elsif v_Key ='Symbol' Then
        l_txmsg.Symbol := v_Value;
      Elsif v_Key ='DeliverToCompID' Then
        l_txmsg.DeliverToCompID := v_Value;
      Elsif v_Key ='Price' Then
        l_txmsg.Price := v_Value;
      Elsif v_Key ='AdvId' Then
        l_txmsg.AdvId := v_Value;
      Elsif v_Key ='SenderSubID' Then
        l_txmsg.SenderSubID := v_Value;
      Elsif v_Key ='AdvRefID' Then
        l_txmsg.AdvRefID := v_Value;
      End if;
    END LOOP;

    plog.debug(pkgctx,'msg s l_txmsg.AdvId: '||l_txmsg.AdvId
             ||' l_txmsg.AdvSide ='|| l_txmsg.AdvSide
             ||' l_txmsg.Quantity ='|| l_txmsg.Quantity
             ||' l_txmsg.Symbol ='|| l_txmsg.Symbol
             ||' l_txmsg.Price ='|| l_txmsg.Price);
    plog.debug(pkgctx,'Free resources associated');

    -- Free any resources associated with the document now it
    -- is no longer needed.
    DBMS_XMLDOM.freedocument(l_doc);
    -- Only used if variant is CLOB
    -- dbms_lob.freetemporary(p_xmlmsg);

    plog.setendsection(pkgctx, 'fn_xml2obj_7');
    RETURN l_txmsg;
  EXCEPTION
    WHEN OTHERS THEN
      --dbms_lob.freetemporary(p_xmlmsg);
      DBMS_XMLPARSER.freeparser(l_parser);
      DBMS_XMLDOM.freedocument(l_doc);
      plog.error(pkgctx, SQLERRM);
      plog.setendsection(pkgctx, 'fn_xml2obj_7');
      RAISE errnums.E_SYSTEM_ERROR;
  END fn_xml2obj_7;

  --Nhan Message f
  FUNCTION fn_xml2obj_f(p_xmlmsg    VARCHAR2) RETURN tx.msg_f IS
    l_parser   xmlparser.parser;
    l_doc      xmldom.domdocument;
    l_nodeList xmldom.domnodelist;
    l_node     xmldom.domnode;
    n     xmldom.domnode;

    l_fldname fldmaster.fldname%TYPE;
    l_txmsg   tx.msg_f;
    v_Key Varchar2(100);
    v_Value Varchar2(100);


  BEGIN
    plog.setbeginsection (pkgctx, 'fn_xml2obj_f');

    plog.debug(pkgctx,'msg length: ' || length(p_xmlmsg));
    l_parser := xmlparser.newparser();
    plog.debug(pkgctx,'1');
    xmlparser.parseclob(l_parser, p_xmlmsg);
    plog.debug(pkgctx,'2');
    l_doc := xmlparser.getdocument(l_parser);
    plog.debug(pkgctx,'3');
    xmlparser.freeparser(l_parser);

    plog.debug(pkgctx,'Prepare to parse Message Fields');

    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                           '/ArrayOfHoSEMessageEntry/hoSEMessageEntry');

    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
      plog.debug(pkgctx,'parse fields: ' || i);
      l_node := xmldom.item(l_nodeList, i);
      dbms_xslprocessor.valueOf(l_node,'key',v_Key);
      dbms_xslprocessor.valueOf(l_node,'value',v_Value);
      If v_Key ='Text'  Then
        l_txmsg.Text := v_Value;
      Elsif v_Key ='SecurityStatusReqID' Then
        l_txmsg.SecurityStatusReqID := v_Value;
      Elsif v_Key ='Symbol' Then
        l_txmsg.Symbol := v_Value;
      Elsif v_Key ='SecurityType' Then
        l_txmsg.SecurityType := v_Value;
      Elsif v_Key ='IssueDate' Then
        l_txmsg.IssueDate := v_Value;
      Elsif v_Key ='Issuer' Then
        l_txmsg.Issuer := v_Value;
      Elsif v_Key ='SecurityDesc' Then
        l_txmsg.SecurityDesc := v_Value;
      Elsif v_Key ='HighPx' Then
        l_txmsg.HighPx := v_Value;
      Elsif v_Key ='LowPx' Then
        l_txmsg.LowPx := v_Value;
      Elsif v_Key ='LastPx' Then
        l_txmsg.LastPx := v_Value;
      Elsif v_Key ='SecurityTradingStatus' Then
        l_txmsg.SecurityTradingStatus := v_Value;
      Elsif v_Key ='BuyVolume' Then
        l_txmsg.BuyVolume := v_Value;
      Elsif v_Key ='TradingSessionSubID' Then
        l_txmsg.TradingSessionSubID := v_Value;
      End if;
    END LOOP;


    plog.debug(pkgctx,'msg s l_txmsg.SecurityStatusReqID: '||l_txmsg.SecurityStatusReqID
             ||' l_txmsg.Symbol ='|| l_txmsg.Symbol
             ||' l_txmsg.SecurityType ='|| l_txmsg.SecurityType
             ||' l_txmsg.HighPx ='|| l_txmsg.HighPx
             ||' l_txmsg.LowPx ='|| l_txmsg.LowPx);
    plog.debug(pkgctx,'Free resources associated');

    -- Free any resources associated with the document now it
    -- is no longer needed.
    DBMS_XMLDOM.freedocument(l_doc);
    -- Only used if variant is CLOB
    -- dbms_lob.freetemporary(p_xmlmsg);

    plog.setendsection(pkgctx, 'fn_xml2obj_f');
    RETURN l_txmsg;
  EXCEPTION
    WHEN OTHERS THEN
      --dbms_lob.freetemporary(p_xmlmsg);
      DBMS_XMLPARSER.freeparser(l_parser);
      DBMS_XMLDOM.freedocument(l_doc);
      plog.error(pkgctx, SQLERRM);
      plog.setendsection(pkgctx, 'fn_xml2obj_f');
      RAISE errnums.E_SYSTEM_ERROR;
  END fn_xml2obj_f;


  --Nhan Message h
  FUNCTION fn_xml2obj_h(p_xmlmsg    VARCHAR2) RETURN tx.msg_h IS
    l_parser   xmlparser.parser;
    l_doc      xmldom.domdocument;
    l_nodeList xmldom.domnodelist;
    l_node     xmldom.domnode;
    n     xmldom.domnode;

    l_fldname fldmaster.fldname%TYPE;
    l_txmsg   tx.msg_h;
    v_Key Varchar2(100);
    v_Value Varchar2(100);


  BEGIN
    plog.setbeginsection (pkgctx, 'fn_xml2obj_h');

    plog.debug(pkgctx,'msg length: ' || length(p_xmlmsg));
    l_parser := xmlparser.newparser();
    plog.debug(pkgctx,'1');
    xmlparser.parseclob(l_parser, p_xmlmsg);
    plog.debug(pkgctx,'2');
    l_doc := xmlparser.getdocument(l_parser);
    plog.debug(pkgctx,'3');
    xmlparser.freeparser(l_parser);

    plog.debug(pkgctx,'Prepare to parse Message Fields');

    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                           '/ArrayOfHoSEMessageEntry/hoSEMessageEntry');

    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
      plog.debug(pkgctx,'parse fields: ' || i);
      l_node := xmldom.item(l_nodeList, i);
      dbms_xslprocessor.valueOf(l_node,'key',v_Key);
      dbms_xslprocessor.valueOf(l_node,'value',v_Value);
      If v_Key ='TradingSessionID'  Then
        l_txmsg.TradingSessionID := v_Value;
      Elsif v_Key ='TradSesStartTime' Then
        l_txmsg.TradSesStartTime := v_Value;
      Elsif v_Key ='TradSesStatus' Then
        l_txmsg.TradSesStatus := v_Value;
      Elsif v_Key ='TradSesReqID' Then
        l_txmsg.TradSesReqID := v_Value;
      End if;
    END LOOP;


    plog.debug(pkgctx,'msg s l_txmsg.TradingSessionID: '||l_txmsg.TradingSessionID
             ||' l_txmsg.TradSesStartTime ='|| l_txmsg.TradSesStartTime
             ||' l_txmsg.TradSesStatus ='|| l_txmsg.TradSesStatus);
    plog.debug(pkgctx,'Free resources associated');

    -- Free any resources associated with the document now it
    -- is no longer needed.
    DBMS_XMLDOM.freedocument(l_doc);
    -- Only used if variant is CLOB
    -- dbms_lob.freetemporary(p_xmlmsg);

    plog.setendsection(pkgctx, 'fn_xml2obj_h');
    RETURN l_txmsg;
  EXCEPTION
    WHEN OTHERS THEN
      --dbms_lob.freetemporary(p_xmlmsg);
      DBMS_XMLPARSER.freeparser(l_parser);
      DBMS_XMLDOM.freedocument(l_doc);
      plog.error(pkgctx, SQLERRM);
      plog.setendsection(pkgctx, 'fn_xml2obj_h');
      RAISE errnums.E_SYSTEM_ERROR;
  END fn_xml2obj_h;


  --Xu ly Message 8
  Procedure PRC_PROCESS8(V_MSGXML VARCHAR2, v_ID Varchar2) is
    V_TX8   tx.msg_8;
    V_ORGORDERID VARCHAR2(20);
    v_Process     VARCHAR2(1);
  BEGIN
    plog.setbeginsection (pkgctx, 'PRC_PROCESS8');

    V_TX8:=fn_xml2obj_8(V_MSGXML);

    --Neu msg vao Core thi cap nhat trang thai Sent luon.
    If V_TX8.ExecType = '0' And V_TX8.OrdStatus = 'A' Then

          BEGIN
              SELECT ORGORDERID INTO V_ORGORDERID
              FROM Ordermap_Ha WHERE ctci_order= TRIM(V_TX8.ClOrdID);

              UPDATE Ordermap_Ha SET ORDER_NUMBER = V_TX8.OrderID
              Where  Ctci_Order = Trim(V_TX8.ClOrdID);

          EXCEPTION WHEN OTHERS THEN
              v_CheckProcess := FALSE;
              plog.debug(pkgctx,'8-0-A PRC_PROCESS8 '||' Khong tim so hieu lenh goc V_TX8.ClOrdID: '||V_TX8.ClOrdID);
          END;

          UPDATE OOD SET OODSTATUS = 'S', TXTIME = TO_CHAR(SYSDATE,'HH24:MI:SS')
          WHERE ORGORDERID = V_ORGORDERID;

          UPDATE ODMAST SET ORSTATUS = '2',
          HOSESESSION = (SELECT SYSVALUE  FROM ORDERSYS_HA WHERE SYSNAME = 'TRADINGID')
          WHERE ORDERID = V_ORGORDERID AND ORSTATUS = '8';
          v_Process:='Y';
     Elsif V_TX8.ExecType = '0' And V_TX8.OrdStatus = 'M' Then --Lenh MTL khong khop het.

         BEGIN
              SELECT ORGORDERID INTO V_ORGORDERID
              FROM Ordermap_Ha WHERE TRIM(ctci_order)= TRIM(V_TX8.ClOrdID);

          EXCEPTION WHEN OTHERS THEN
              v_CheckProcess := FALSE;
              plog.debug(pkgctx,'PRC_PROCESS8'||' Map lenh MTL khong tim so hieu lenh goc V_TX8.ClOrdID: '||V_TX8.ClOrdID);
          END;

          --Cap nhat lai gia cua lenh goc = gia cua lenh LO do San gui ve
          UPDATE ODMAST SET Quoteprice = V_TX8.PRICE, exprice =V_TX8.PRICE
          WHERE ORDERID = V_ORGORDERID;
          v_Process:='Y';
    Else
          v_Process:='N';
    End if;

      --XU LY MESSAGE 8.
    INSERT INTO Exec_8(clordid, transacttime, exectype, orderqty, orderid, side,
                       symbol, price, ACCOUNT, ordstatus, origclordid,
                       secondaryclordid, lastqty, lastpx, execid, leavesqty,receivetime,id,process,
                       OrdType, UnderlyingLastQty,OrdRejReason,MsgSeqNum)
         VALUES ( V_TX8.ClOrdID , V_TX8.TransactTime , V_TX8.ExecType , V_TX8.OrderQty , V_TX8.OrderID , V_TX8.Side,
                  V_TX8.Symbol , V_TX8.Price , V_TX8.Account , V_TX8.OrdStatus ,V_TX8.OrigClOrdID ,
                  V_TX8.SecondaryClOrdID, V_TX8.LastQty , V_TX8.LastPx , V_TX8.ExecID ,V_TX8.LeavesQty ,sysdate,v_ID,v_Process,
                  V_TX8.OrdType, V_TX8.UnderlyingLastQty,V_TX8.OrdRejReason, V_TX8.MsgSeqNum);

    plog.setendsection (pkgctx, 'PRC_PROCESS8');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    v_CheckProcess := FALSE;
    plog.setendsection (pkgctx, 'PRC_PROCESS8');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_PROCESS8;
Procedure PRC_PROCESS3(V_MSGXML VARCHAR2, v_ID Varchar2) is
    V_TX3   tx.msg_3;
    V_ORGORDERID VARCHAR2(20);
    v_msgReject  varchar2(200);
    v_check1Firm int;
    v_orderqtty number;
    v_codeid varchar2(10);
    v_contrafirm varchar2(10);
    v_custodycd varchar2(10);
    v_RefOrderID  varchar2(20);
    v_qtty number;
    v_ptdeal varchar2(20);
BEGIN
    plog.setbeginsection (pkgctx, 'PRC_PROCESS3');
    V_TX3:=fn_xml2obj_3(V_MSGXML);
    v_msgReject:=v_tx3.SessionRejectReason||'-'|| v_tx3.Text;
    Insert into ctci_reject --Ghi log b? t? ch?i
        (firm,
         order_number,
         reject_reason_code,
         original_message_text,
         order_entry_date,
         msgtype)
    VALUES
        ('',
         v_tx3.RefSeqNum,
         v_tx3.SessionRejectReason,
         '',
         to_char(getcurrdate,'DD/MM/RRRR'),
         v_tx3.RefMsgType);
    --XU LY MESSAGE 3.
    --neu ma loi -70013 khong xu ly gi
    IF trim(v_tx3.SessionRejectReason)='-70013' THEN
      RETURN;
    END IF;
    Begin
      SELECT ORGORDERID --Lay thong tin so hieu lenh trong Flex
             INTO V_ORGORDERID
      FROM ORDERMAP_HA
      WHERE ctci_order = TRIM(V_TX3.ClOrdID);

      EXCEPTION WHEN OTHERS THEN
           v_CheckProcess := FALSE;
           plog.error(pkgctx, 'PRC_PROCESS3 ' || 'Khong tim so hieu lenh goc ORDER_NUMBER: ' || V_TX3.ClOrdID||'V_TX3.RefMsgType'||V_TX3.RefMsgType);
           RAISE errnums.E_SYSTEM_ERROR;
    END;

    If V_TX3.RefMsgType='D' or V_TX3.RefMsgType='s'then --lenh moi thuong + thoa thuan
        UPDATE OOD
        SET
          OODSTATUS = 'S',
          TXTIME    = TO_CHAR(SYSDATE, 'HH24:MI:SS')
        WHERE ORGORDERID = V_ORGORDERID and OODSTATUS <> 'S';

        Select REMAINQTTY into  v_qtty from odmast  Where Orderid = V_ORGORDERID;

        --Giao toa tien /ck
        CONFIRM_CANCEL_NORMAL_ORDER(V_ORGORDERID, v_qtty);
        Update odmast
        set
          ORSTATUS   = '6',
          FEEDBACKMSG= v_msgReject
        Where Orderid = V_ORGORDERID;

        --Xu ly cho lenh mua doi dung
        select count(1)
               into v_check1Firm
        from odmast
        where Orderid = V_ORGORDERID
          and matchtype='P'
          --and contrafirm=(select sysvalue from ordersys_ha where sysname='FIRM');
          AND clientid IN (SELECT custodycd FROM cfmast WHERE status = 'A');

        If V_TX3.RefMsgType='s' and v_check1Firm>0 then --thao thuan cung cong ty
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
                  --and contrafirm = (select sysvalue from ordersys where sysname='FIRM')
                  AND clientid IN (SELECT custodycd FROM cfmast WHERE status = 'A')
                  and matchtype = 'P'
                  and ptdeal =v_ptdeal
                  and txdate =getcurrdate
                  AND orstatus='8';

             CONFIRM_CANCEL_NORMAL_ORDER(v_RefOrderID,v_orderqtty );

             UPDATE OOD  SET
                  OODSTATUS = 'S',
                  TXTIME    = TO_CHAR(SYSDATE, 'HH24:MI:SS')
             WHERE ORGORDERID = v_RefOrderID and OODSTATUS <> 'S';

             Update odmast set
                  ORSTATUS   = '6',
                  FEEDBACKMSG= v_msgReject
            Where Orderid = v_RefOrderID;
        end if;

    End if;
    If V_TX3.RefMsgType='F' then --Tu choi lenh huy thuong

        UPDATE OOD  SET
                 OODSTATUS = 'S',
                 TXTIME    = TO_CHAR(SYSDATE, 'HH24:MI:SS')
        WHERE ORGORDERID = V_ORGORDERID   and OODSTATUS <> 'S' ;

        Update odmast  Set
                 ORSTATUS   = '6',
                 FEEDBACKMSG= v_msgReject
        Where Orderid = V_ORGORDERID ;

        --Xu ly cho phep dat lai lenh huy
        DELETE odchanging WHERE orderid =V_ORGORDERID;
        update  fomast set status= 'R',feedbackmsg=v_msgReject
        WHERE orgacctno=V_ORGORDERID;
    End if;
    If V_TX3.RefMsgType='G' then --tu choi sua thuong
        UPDATE OOD SET
            OODSTATUS = 'S',
            TXTIME    = TO_CHAR(SYSDATE, 'HH24:MI:SS')
        WHERE ORGORDERID = V_ORGORDERID and OODSTATUS <> 'S';

        Update odmast Set
            ORSTATUS   = '6',
            FEEDBACKMSG= v_msgReject
        Where Orderid = V_ORGORDERID;

        --Xu ly cho phep dat lai lenh sua
        DELETE odchanging WHERE orderid =V_ORGORDERID;
        update  fomast set status='R',feedbackmsg=v_msgReject
        WHERE orgacctno=V_ORGORDERID;
    End if;
    If V_TX3.RefMsgType='u' then --tu choi huy thoa thuan
        UPDATE CANCELORDERPTACK
        SET status='S' , isconfirm='Y'
        WHERE ordernumber= V_ORGORDERID AND SORR='S' AND MESSAGETYPE='3C'   ;

    End if;
    --MSBS-1853  HNX_update_GL
    If V_TX3.RefMsgType='BE' then --tu choi yeu cau doi mat khau
        UPDATE GWinfor gw SET
            gw.status ='S',
            gw.asetstatus=7,
            gw.userstatustext=v_msgReject
         WHERE UserRequestID=V_TX3.UserRequestID;
    END if;

    plog.setendsection (pkgctx, 'PRC_PROCESS3');
EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
    v_CheckProcess := FALSE;
    plog.setendsection (pkgctx, 'PRC_PROCESS3');
   -- v_CheckProcess := FALSE;
    rollback;
END PRC_PROCESS3;


  --Xu ly Message 7
  Procedure PRC_PROCESS7(V_MSGXML VARCHAR2, v_ID Varchar2) is
    V_TX7   tx.msg_7;
    V_ORGORDERID VARCHAR2(20);
  BEGIN
    plog.setbeginsection (pkgctx, 'PRC_PROCESS7');
    V_TX7:=fn_xml2obj_7(V_MSGXML);


      --XU LY MESSAGE 7.
    If V_TX7.AdvTransType = 'N' Then
       --Lenh dat HNX forward



        INSERT INTO haput_ad
                    (advside, text, quantity, advtranstype,
                     symbol, delivertocompid, price, advid,
                     sendersubid
                    )
             VALUES (v_tx7.advside, v_tx7.text, v_tx7.quantity, v_tx7.advtranstype,
                     v_tx7.symbol, v_tx7.delivertocompid, v_tx7.price, v_tx7.advid,
                     v_tx7.sendersubid
                    );

      --   Update ordermap_ha set order_number = v_tx7.advid where  ctci_order = v_tx7.AdvRefID ;

     Else --If v_CTCI_7.AdvTransType = "C" Then
      -- Lenh huy quang cao duoc HNX forward

        UPDATE haput_ad
           SET advtranstype = v_tx7.advtranstype
         WHERE advid = v_tx7.advid;
     End If;

    plog.setendsection (pkgctx, 'PRC_PROCESS7');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    v_CheckProcess := FALSE;
    plog.setendsection (pkgctx, 'PRC_PROCESS7');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_PROCESS7;



  --Xu ly Message s
  Procedure PRC_PROCESSs(V_MSGXML VARCHAR2, v_ID Varchar2) is
    V_TXs   tx.msg_s;
    V_ORGORDERID VARCHAR2(20);
    v_Firm  VARCHAR2(20);
    v_Side  VARCHAR2(20);
    v_count number(4);

  BEGIN
    plog.setbeginsection (pkgctx, 'PRC_PROCESSs');

    V_TXs:=fn_xml2obj_s(V_MSGXML);

    --XU LY MESSAGE s.
    Begin
        Select SYSVALUE Into v_Firm from ordersys_ha where SYSNAME ='FIRM';
    Exception When others THEN
      v_CheckProcess := FALSE;
        plog.debug(pkgctx, 'Chua khai bao ma cty trong Ordersys_Ha');
        v_Firm:='0';
    End;

    If v_Firm = V_TXs.BuyPartyID Then
        v_Side := 'B';
    Else
        v_Side := 'S';
    End If;

    --Neu lenh confirm ban thi cap nhat vao ordermap_ha de khi khop map.
    If v_Firm <> V_TXs.BuyPartyID and v_Firm = V_TXs.SellPartyID Then
       Begin
       -- Select SYSVALUE Into v_Firm from ordersys_ha where SYSNAME ='FIRM';
       Select orgorderid into V_ORGORDERID  from ordermap_ha
       where ctci_order = V_TXs.SellClOrdID;

       Exception When others THEN
          v_CheckProcess := FALSE;
            plog.debug(pkgctx, 'Chua khai bao ma cty trong Ordersys_Ha');
            v_Firm:='0';
            V_ORGORDERID:=0   ;
       End;



       UPDATE OOD SET OODSTATUS = 'S', TXTIME = TO_CHAR(SYSDATE,'HH24:MI:SS')
       WHERE ORGORDERID = V_ORGORDERID;

       UPDATE ODMAST SET ORSTATUS = '2',
       HOSESESSION = (SELECT SYSVALUE  FROM ORDERSYS_HA WHERE SYSNAME = 'TRADINGID')
       WHERE ORDERID = V_ORGORDERID AND ORSTATUS = '8';

       Update ordermap_ha set
       --ctci_order = V_TXs.CrossID,
       order_number= V_TXs.CrossID, rejectcode = ctci_order
       where ctci_order = V_TXs.SellClOrdID;
     End if;

    --Nhan message chao ban thoa thuan
    --Neu la ben ban  va lenh khong xuat phat tu Flex (xuat phat tu FO) thi ko insert.
    IF v_Firm = V_TXs.SellPartyID THEN
       Select count(*) INTO v_count   from ordermap_ha
       WHERE  ctci_order = V_TXs.SellClOrdID;
       IF  v_count =0 THEN
           plog.setendsection (pkgctx, 'PRC_PROCESSs');
           RETURN;
       END IF;
    END IF;

    INSERT INTO orderptack
            (TIMESTAMP, messagetype, firm, buyertradeid,
             side, sellercontrafirm, sellertradeid, securitysymbol, volume,
             price, board, confirmnumber, offset, status, issend,
             ordernumber, brid, tlid,
             txtime, ipaddress, trading_date,
             sclientid
            )
     VALUES (TO_CHAR (SYSDATE, 'HH24MISS'), 's', v_txs.buypartyid, '',
             v_side, v_txs.sellpartyid, '', v_txs.symbol, v_txs.sellorderqty,
             v_txs.price, '', v_txs.crossid, '', 'N', 'N',
             '' , '', ''
             , TO_CHAR (SYSDATE, 'hh24miss'), '', TRUNC (SYSDATE),
             v_txs.sellaccount
            );


    plog.setendsection (pkgctx, 'PRC_PROCESSs');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    v_CheckProcess := FALSE;
    plog.setendsection (pkgctx, 'PRC_PROCESSs');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_PROCESSs;



--Xu ly Message f
  Procedure PRC_PROCESSf(V_MSGXML VARCHAR2, v_ID Varchar2) is
    V_TXf   tx.msg_f;
    V_ORGORDERID VARCHAR2(20);
    v_Count Number(10);
    v_CODEID VARCHAR2(20);
    v_strErrCode VARCHAR2(20);
    v_strErrM VARCHAR2(200);
    -- begin 1.5.1.3 | 1808
    v_ISSUERID varchar2(40);
    v_SECTYPE varchar2(5);
    l_tradeplace_old Varchar2(20);
    l_codeid_old    Varchar2(20);

    -- end 1.5.1.3 | 1808
    v_cellingprice number;  --1.5.6.0
    v_floorprice number;    --1.5.6.0
  BEGIN

    plog.setbeginsection (pkgctx, 'PRC_PROCESSf');

    V_TXf:=fn_xml2obj_f(V_MSGXML);

    --XU LY MESSAGE f.

    Select count(*) Into v_Count
    From HASecurity_Req
    Where Symbol = V_TXf.Symbol;

    If v_Count >0 Then

        UPDATE hasecurity_req
           SET
               securitystatusreqid = v_txf.securitystatusreqid,
               highpx = v_txf.highpx,
               lowpx = v_txf.lowpx,
               securitytradingstatus = v_txf.securitytradingstatus,
               buyvolume = v_txf.buyvolume,
               securitytype = v_txf.securitytype,
               TradingSessionSubID = v_txf.TradingSessionSubID,
               lastpx = v_txf.lastpx,
               text =
                     ' Update securities_info set  ceilingprice = '
                  || v_txf.highpx
                  || ' , floorprice = '
                  || v_txf.lowpx
                  || ' , DFREFPRICE = '
                  || v_txf.lowpx
                  || ' Where symbol = '''
                  || v_txf.symbol
                  || ''';'
         WHERE symbol = v_txf.symbol;


    Else

        INSERT INTO hasecurity_req
                    (securitystatusreqid, symbol, highpx,
                     lowpx, securitytradingstatus, buyvolume,
                     securitytype, lastpx,TradingSessionSubID,
                     text
                    )
             VALUES (v_txf.securitystatusreqid, v_txf.symbol, v_txf.highpx,
                     v_txf.lowpx, v_txf.securitytradingstatus, v_txf.buyvolume,
                     v_txf.securitytype, v_txf.lastpx,v_txf.TradingSessionSubID,
                        'Update securities_info set  ceilingprice = '
                     || v_txf.highpx
                     || ' , floorprice = '
                     || v_txf.lowpx
                     || ' , DFREFPRICE = '
                     || v_txf.lowpx
                     || ' where symbol = '''
                     || v_txf.symbol
                     || ''';'
                    );

    End if;

    -- begin 1.5.1.3 | 1808
    BEGIN
        SELECT tradeplace,codeid  INTO l_tradeplace_old, l_codeid_old FROM sbsecurities WHERE symbol = v_txf.symbol;
    EXCEPTION
        WHEN OTHERS THEN
        l_tradeplace_old:='';
        l_codeid_old:='';
    END ;

    if v_txf.TradingSessionSubID ='LIS_BRD_01'  then
          cspks_odproc.Pr_Update_SecInfo(v_txf.symbol, v_txf.highpx,v_txf.lowpx,v_txf.lowpx,'002',v_txf.securitytype,v_strErrCode);
    Elsif  v_txf.TradingSessionSubID ='UPC_BRD_01' THEN
         cspks_odproc.Pr_Update_SecInfo(v_txf.symbol, v_txf.highpx,v_txf.lowpx,v_txf.lowpx,'005',v_txf.securitytype,v_strErrCode);
    Elsif  v_txf.TradingSessionSubID ='LIS_BRD_ETF' THEN
        cspks_odproc.Pr_Update_SecInfo(v_txf.symbol, v_txf.highpx,v_txf.lowpx,v_txf.lowpx,'002',v_txf.securitytype,v_strErrCode);
    -- 1.5.6.0: GD TPDN
    Elsif  v_txf.TradingSessionSubID ='LIS_BRD_BOND' THEN
        cspks_odproc.Pr_Update_SecInfo(v_txf.symbol, v_txf.highpx,v_txf.lowpx,v_txf.lowpx,'002',v_txf.securitytype,v_strErrCode);
    end if ;
    -- end 1.5.1.3 | 1808

     --Kiem tra ticksize ma ETF: 1  khac ETF 100
     v_CODEID:='';
     select codeid into v_CODEID from securities_info where SYMBOL =v_txf.symbol;
     DELETE FROM securities_ticksize WHERE  symbol =v_txf.symbol;
     IF   instr('EF', v_txf.securitytype)>0 or instr('CORP', v_txf.securitytype)>0  THEN --la ma ETF hoac TPDN (1.5.6.0)
         INSERT INTO securities_ticksize (AUTOID,CODEID,SYMBOL,TICKSIZE,FROMPRICE,TOPRICE,STATUS)
           VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL,v_CODEID,v_txf.symbol,1,0,1000000000,'Y');
     ELSE --Neu chuyen loai chinh sua lai buoc gia
            INSERT INTO securities_ticksize (AUTOID,CODEID,SYMBOL,TICKSIZE,FROMPRICE,TOPRICE,STATUS)
           VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL,v_CODEID,v_txf.symbol,100,0,1000000000,'Y');
       END IF;
     --- end xy ly ticksize

    if v_txf.SECURITYTRADINGSTATUS in ('17','24','25','26','1','27','28') then
      UPDATE SBSECURITIES SET HALT =  'N' WHERE SYMBOL=v_txf.symbol;
    else
     UPDATE SBSECURITIES SET HALT =  'Y' WHERE SYMBOL=v_txf.symbol;
    end if;

    commit;

   Begin
      pr_updatepricefromgw(v_txf.symbol, nvl(v_txf.LASTPX,0),v_txf.LOWPX ,v_txf.HIGHPX,'DN',v_strErrCode,v_strErrM);
      Commit ;
   Exception when others THEN
     v_CheckProcess := FALSE;
     null;
    End;

    -- 1.5.8.0 them lai up gia tran san tham chieu
              v_cellingprice :=  v_txf.HIGHPX;
              v_floorprice  := v_txf.LOWPX;
              if (v_txf.securitytype = 'CORP') then
                if (v_txf.LOWPX = 0) then
                  v_floorprice := 1000;
                 end if;
                 if (v_txf.HIGHPX = 0) then
                   v_cellingprice := 10000000;
                 end if;
              end if;
     Begin
        v_CODEID:='';
        select codeid into v_CODEID from securities_info where SYMBOL =v_txf.symbol;
        update securities_info set
                    FLOORPRICE= v_floorprice,
                    CEILINGPRICE= v_cellingprice,
                    CURRENT_ROOM=v_txf.BUYVOLUME,
                    BASICPRICE=nvl(v_txf.LASTPX,0)
           where  ( CODEID=v_CODEID
                --   Or CODEID in (SELECT CODEID FROM SBSECURITIES WHERE REFCODEID=v_CODEID)
                    ) ;
            Commit ;
      Exception when others then
         v_CheckProcess := FALSE;
         null;
      End;
      -- cap nhat tradelot
      update securities_info set tradelot = 100 where symbol = v_txf.symbol;
      commit;
    -- begin 1.5.1.3 | 1808
    IF l_tradeplace_old <> (CASE WHEN v_txf.TradingSessionSubID ='UPC_BRD_01' THEN '005' ELSE '002' END) THEN
        --dong bo len FO
        BEGIN
            pr_t_fo_instruments;
        END;

        --Insert vao t_fo_event de GEN Msg sang FO
        INSERT INTO t_fo_event (AUTOID, TXNUM, TXDATE, ACCTNO, TLTXCD,LOGTIME,PROCESSTIME,PROCESS,ERRCODE,ERRMSG,NVALUE,CVALUE)
        SELECT seq_fo_event.NEXTVAL, 'AUTO-00000', getcurrdate, v_txf.symbol,'2285',systimestamp,systimestamp,'N','0',NULL, NULL, NULL
        FROM DUAL WHERE EXISTS (SELECT TLTXCD FROM FOTXMAP WHERE TLTXCD = '2285');
    END IF;
    -- end 1.5.1.3 | 1808

   plog.setendsection (pkgctx, 'PRC_PROCESSf');
  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    v_CheckProcess := FALSE;
    plog.setendsection (pkgctx, 'PRC_PROCESSf');
    RAISE errnums.E_SYSTEM_ERROR;

  END PRC_PROCESSf;



  --Xu ly Message h
  Procedure PRC_PROCESSh(V_MSGXML VARCHAR2, v_ID Varchar2) is
    V_TXh   tx.msg_h;
    V_ORGORDERID VARCHAR2(20);
    v_TradingSessionID Varchar2(100):='';

  BEGIN
    plog.setbeginsection (pkgctx, 'PRC_PROCESSh');

    V_TXh:=fn_xml2obj_h(V_MSGXML);
        If V_TXh.TradingSessionID in ('BON_CON_NML', 'LIS_CON_NML', 'LIS_CON_NEW', 'LIS_CON_LTD', 'LIS_CON_SPC') THEN   --1.5.6.0
      v_TradingSessionID :='CONT';
    Elsif   V_TXh.TradingSessionID in ('BON_AUC_C_NML', 'LIS_AUC_C_NML',  'LIS_AUC_C_NEW', 'LIS_AUC_C_LTD',  'LIS_AUC_C_SPC'   ) THEN   --1.5.6.0
      v_TradingSessionID :='CLOSE';
    Elsif   V_TXh.TradingSessionID in ('LIS_AUC_C_NML_LOC' ,  'LIS_AUC_C_NEW_LOC', 'LIS_AUC_C_LTD_LOC',  'LIS_AUC_C_SPC_LOC'   ) Then
      v_TradingSessionID :='CLOSE_BL';
   Elsif   V_TXh.TradingSessionID in ('BON_PTH_P_NML', 'LIS_PTH_P_NML','LIS_PLO_NEW') THEN   --HNX_update|MSBS-1774 --1.5.6.0
      v_TradingSessionID :='PCLOSE';
   ElsIf V_TXh.TradingSessionID in ('UPC_CON_NML', 'UPC_CON_NEW', 'UPC_CON_LTD', 'UPC_CON_SPC') Then
      v_TradingSessionID :='CONTUP';
    Elsif   V_TXh.TradingSessionID in ('UPC_AUC_C_NML',  'UPC_AUC_C_NEW', 'UPC_AUC_C_LTD',  'UPC_AUC_C_SPC'   ) Then
      v_TradingSessionID :='CLOSE';
    Elsif   V_TXh.TradingSessionID in ('UPC_AUC_C_NML_LOC' ,  'UPC_AUC_C_NEW_LOC', 'UPC_AUC_C_LTD_LOC',  'UPC_AUC_C_SPC_LOC'   ) Then
      v_TradingSessionID :='CLOSE_BL';
   Elsif   V_TXh.TradingSessionID in ('UPC_PTH_P_NML') Then
      v_TradingSessionID :='PCLOSE';
    Else
       v_TradingSessionID :='NONE';
   End if;
    If V_TXh.TradSesReqID ='LIS_BRD_01' Then
      --XU LY MESSAGE h.
    UPDATE ORDERSYS_HA SET SYSVALUE=V_TXh.TradSesStatus WHERE SYSNAME='CONTROLCODE';
    UPDATE ORDERSYS_HA SET SYSVALUE=v_TradingSessionID WHERE SYSNAME='TRADINGID';
    UPDATE ORDERSYS_HA SET SYSVALUE= V_TXh.TradSesStartTime WHERE SYSNAME='TIMESTAMP';
    Elsif V_TXh.TradSesReqID ='UPC_BRD_01' then
        UPDATE ORDERSYS_UPCOM SET SYSVALUE=V_TXh.TradSesStatus WHERE SYSNAME='CONTROLCODE';
        UPDATE ORDERSYS_UPCOM SET SYSVALUE=v_TradingSessionID WHERE SYSNAME='TRADINGID';
        UPDATE ORDERSYS_UPCOM SET SYSVALUE= V_TXh.TradSesStartTime WHERE SYSNAME='TIMESTAMP';

    End if;
UPDATE HA_BRD set tradsesstatus=V_TXh.TradSesStatus, tradingsessionid =  v_TradingSessionID
    WHERE BRD_CODE = V_TXh.TradSesReqID;
    UPDATE HASECURITY_REQ SET
        TradingSessionID=v_TradingSessionID,
        TradSesStatus =V_TXh.TradSesStatus
    WHERE symbol=V_TXh.tradsesreqid;
    plog.setendsection (pkgctx, 'PRC_PROCESSh');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    v_CheckProcess := FALSE;
    plog.setendsection (pkgctx, 'PRC_PROCESSh');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_PROCESSh;

--Nhan Message B
  FUNCTION fn_xml2obj_B(p_xmlmsg    VARCHAR2) RETURN tx.msg_B IS
    l_parser   xmlparser.parser;
    l_doc      xmldom.domdocument;
    l_nodeList xmldom.domnodelist;
    l_node     xmldom.domnode;
    n     xmldom.domnode;

    l_fldname fldmaster.fldname%TYPE;
    l_txmsg   tx.msg_B;
    v_Key Varchar2(100);
    v_Value Varchar2(4000); --Edit 20151008


  BEGIN
    plog.setbeginsection (pkgctx, 'fn_xml2obj_B');

    plog.debug(pkgctx,'msg length: ' || length(p_xmlmsg));
    l_parser := xmlparser.newparser();
    plog.debug(pkgctx,'1');
    xmlparser.parseclob(l_parser, p_xmlmsg);
    plog.debug(pkgctx,'2');
    l_doc := xmlparser.getdocument(l_parser);
    plog.debug(pkgctx,'3');
    xmlparser.freeparser(l_parser);

    plog.debug(pkgctx,'Prepare to parse Message Fields');

    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                           '/ArrayOfHoSEMessageEntry/hoSEMessageEntry');

    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
      plog.debug(pkgctx,'parse fields: ' || i);
      l_node := xmldom.item(l_nodeList, i);
      dbms_xslprocessor.valueOf(l_node,'key',v_Key);
      dbms_xslprocessor.valueOf(l_node,'value',v_Value);
      If v_Key ='Text'  Then
        l_txmsg.Text := v_Value;
      Elsif v_Key ='SendingTime' Then
        l_txmsg.SendingTime := v_Value;
      Elsif v_Key ='Urgency' Then
        l_txmsg.Urgency := v_Value;
      Elsif v_Key ='LinesOfText' Then --edit 20151007
        l_txmsg.LinesOfText := v_Value; --edit 20151007
      Elsif v_Key ='Headline' Then --edit 20151007
        l_txmsg.HeadLine := v_Value;
      End if;
    END LOOP;


    plog.debug(pkgctx,'msg s l_txmsg.Text: '||l_txmsg.Text
             ||' l_txmsg.SendingTime ='|| l_txmsg.SendingTime
             ||' l_txmsg.Urgency ='|| l_txmsg.Urgency
             ||' l_txmsg.LinesOfText ='|| l_txmsg.LinesOfText --edit 20151007
             ||' l_txmsg.HeadLine ='|| l_txmsg.HeadLine);
    plog.debug(pkgctx,'Free resources associated');

    -- Free any resources associated with the document now it
    -- is no longer needed.
    DBMS_XMLDOM.freedocument(l_doc);
    -- Only used if variant is CLOB
    -- dbms_lob.freetemporary(p_xmlmsg);

    plog.setendsection(pkgctx, 'fn_xml2obj_B');
    RETURN l_txmsg;
  EXCEPTION
    WHEN OTHERS THEN
      --dbms_lob.freetemporary(p_xmlmsg);
      DBMS_XMLPARSER.freeparser(l_parser);
      DBMS_XMLDOM.freedocument(l_doc);
      plog.error(pkgctx, SQLERRM);
      plog.setendsection(pkgctx, 'fn_xml2obj_B');
      RAISE errnums.E_SYSTEM_ERROR;
  END fn_xml2obj_B;

  Procedure PRC_PROCESSB(V_MSGXML VARCHAR2, v_ID Varchar2) is
    V_TXB   tx.msg_B;

  BEGIN
    plog.setbeginsection (pkgctx, 'PRC_PROCESSB');

    V_TXB:=fn_xml2obj_B(V_MSGXML);


    --XU LY MESSAGE B.
    INSERT INTO ha_B (sendingtime, urgency, headline, LinesOfText, text,Status,MsgType,ptype)
              values (V_TXB.sendingtime, V_TXB.urgency, V_TXB.headline, V_TXB.LinesOfText, V_TXB.text,'S','B','I'); --edit 20151007
   plog.setendsection (pkgctx, 'PRC_PROCESSB');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_PROCESSB');
    RAISE errnums.E_SYSTEM_ERROR;

  END PRC_PROCESSB;


  --Xu ly Message u
  Procedure PRC_PROCESSu(V_MSGXML VARCHAR2, v_ID Varchar2) is
    V_TXu   tx.msg_u;
    V_ORGORDERID VARCHAR2(20);
    v_Symbol  VARCHAR2(20);
    v_BorS  VARCHAR2(20);
    v_Firm  VARCHAR2(20);
    v_Contrafirm VARCHAR2(20);
  BEGIN
    plog.setbeginsection (pkgctx, 'PRC_PROCESSu');

    V_TXu:=fn_xml2obj_u(V_MSGXML);

      --XU LY MESSAGE u.
    If V_TXu.CrossType = '7' Then
         Update ORDERPTACK
         Set STATUS ='C'
         Where CONFIRMNUMBER =V_TXu.OrigCrossID;
    Else
        Begin

        SELECT symbol, orderid, od.bors bors Into v_Symbol, V_ORGORDERID, v_BorS
          FROM odmast o, ood od, ordermap_ha op
         WHERE o.orderid = od.orgorderid
           AND o.orderid = op.orgorderid
           AND op.order_number = v_txu.origcrossid;

        Exception when others then
            v_Symbol:=Null;
            V_ORGORDERID :=Null;
            v_BorS :=Null;
        End;

        If v_BorS = 'S' Then
            v_Firm := v_Contrafirm;
            v_Contrafirm := '';
        Else
            Begin
               Select SELLERCONTRAFIRM FIRM Into v_Contrafirm
               From orderptack Where CONFIRMNUMBER = V_TXu.OrigCrossID;
               v_Firm := '';
            Exception when others THEN
              v_CheckProcess := FALSE;
                plog.debug(pkgctx,'PRC_PROCESSu Khong tim thay so hieu lenh: '||V_TXu.OrigCrossID);
            End;
        End If;
        --Day du lieu vao bang cancel:

        if nvl(V_ORGORDERID,'ZZZ') <> 'ZZZ' then
            INSERT INTO cancelorderptack
                    (sorr, firm, contrafirm, tradeid,
                     TIMESTAMP, messagetype, securitysymbol, confirmnumber,
                     ordernumber, status, isconfirm, trading_date
                    )
             VALUES ('R', v_firm, v_contrafirm, v_bors,
                     TO_CHAR (SYSDATE, 'HH24MISS'), 'u', v_symbol, v_txu.origcrossid,
                     v_orgorderid, 'N', 'N', TRUNC (SYSDATE)
                    );
        end if;

    End if;

    plog.setendsection (pkgctx, 'PRC_PROCESSu');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    v_CheckProcess := FALSE;
    plog.setendsection (pkgctx, 'PRC_PROCESSu');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_PROCESSu;

--Begin HNX_update_GL|doi mat khau GW
Procedure PRC_BE(PV_REF IN OUT PKG_REPORT.REF_CURSOR) is
        CURSOR C_BE IS
        SELECT  * FROM GWINFOR WHERE status ='N' AND txdate =getcurrdate;
  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_BE');
      FOR I IN C_BE
      LOOP
        INSERT INTO ha_be
            (UserRequestID, UserRequestType, Username,  Password, NewPassword,
             msgtype,  sendnum
            )
         VALUES (i.userrequestid ,'3', I.Username, I.Password, I.NewPassword,
             'BE', 1
            );

        --1.2 CAP NHAT trang thai da gui
        UPDATE GWINFOR SET status='B' WHERE UserRequestID=i.userrequestid;
     END LOOP;
   --LAY DU LIEU RA GW.
   OPEN PV_REF FOR
   SELECT
        Msgtype,
        UserRequestID,
        UserRequestType,
        Username,
        Password,
        NewPassword,
        sendnum BOORDERID
   FROM ha_BE WHERE STATUS ='N';
   --Cap nhat trang thai bang tam ra GW.
   UPDATE ha_BE SET STATUS ='Y',DATE_TIME = SYSDATE WHERE STATUS ='N';
   plog.setendsection (pkgctx, 'PRC_BE');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx,SQLERRM || '--' || dbms_utility.format_error_backtrace);
    plog.setendsection (pkgctx, 'PRC_BE');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_BE;
 --end HNX_update_GL|doi mat khau GW

--HNX_update_GL
FUNCTION fn_xml2obj_BF(p_xmlmsg    VARCHAR2) RETURN tx.msg_BF IS
l_parser   xmlparser.parser;
l_doc      xmldom.domdocument;
l_nodeList xmldom.domnodelist;
l_node     xmldom.domnode;
n     xmldom.domnode;

l_fldname fldmaster.fldname%TYPE;
l_txmsg   tx.msg_BF;
v_Key Varchar2(100);
v_Value Varchar2(100);


BEGIN
plog.setbeginsection (pkgctx, 'fn_xml2obj_BF');

plog.debug(pkgctx,'msg length: ' || length(p_xmlmsg));
l_parser := xmlparser.newparser();
plog.debug(pkgctx,'1');
xmlparser.parseclob(l_parser, p_xmlmsg);
plog.debug(pkgctx,'2');
l_doc := xmlparser.getdocument(l_parser);
plog.debug(pkgctx,'3');
xmlparser.freeparser(l_parser);

plog.debug(pkgctx,'Prepare to parse Message Fields');

l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                               '/ArrayOfHoSEMessageEntry/hoSEMessageEntry');

FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
plog.debug(pkgctx,'parse fields: ' || i);
l_node := xmldom.item(l_nodeList, i);
dbms_xslprocessor.valueOf(l_node,'key',v_Key);
dbms_xslprocessor.valueOf(l_node,'value',v_Value);
If v_Key ='Username'  Then
l_txmsg.Username := trim(v_Value);
Elsif v_Key ='UserRequestID' Then
l_txmsg.UserRequestID := trim(v_Value);
Elsif v_Key ='UserStatus' Then
l_txmsg.UserStatus := trim(v_Value);
Elsif v_Key ='UserStatusText' Then
l_txmsg.UserStatusText  := trim(v_Value);
End if;
END LOOP;

-- Free any resources associated with the document now it
-- is no longer needed.
DBMS_XMLDOM.freedocument(l_doc);
-- Only used if variant is CLOB
-- dbms_lob.freetemporary(p_xmlmsg);

plog.setendsection(pkgctx, 'fn_xml2obj_BF');
RETURN l_txmsg;
EXCEPTION
WHEN OTHERS THEN
--dbms_lob.freetemporary(p_xmlmsg);
DBMS_XMLPARSER.freeparser(l_parser);
DBMS_XMLDOM.freedocument(l_doc);
plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
plog.setendsection(pkgctx, 'fn_xml2obj_BF');
RAISE errnums.E_SYSTEM_ERROR;
END fn_xml2obj_BF;

FUNCTION fn_xml2obj_A(p_xmlmsg    VARCHAR2) RETURN tx.msg_A IS
    l_parser   xmlparser.parser;
    l_doc      xmldom.domdocument;
    l_nodeList xmldom.domnodelist;
    l_node     xmldom.domnode;
    n     xmldom.domnode;

    l_fldname fldmaster.fldname%TYPE;
    l_txmsg   tx.msg_A;
    v_Key Varchar2(100);
    v_Value Varchar2(100);


    BEGIN
    plog.setbeginsection (pkgctx, 'fn_xml2obj_A');

    plog.debug(pkgctx,'msg length: ' || length(p_xmlmsg));
    l_parser := xmlparser.newparser();
    plog.debug(pkgctx,'1');
    xmlparser.parseclob(l_parser, p_xmlmsg);
    plog.debug(pkgctx,'2');
    l_doc := xmlparser.getdocument(l_parser);
    plog.debug(pkgctx,'3');
    xmlparser.freeparser(l_parser);

    plog.debug(pkgctx,'Prepare to parse Message Fields');

    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                   '/ArrayOfHoSEMessageEntry/hoSEMessageEntry');

    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
    plog.debug(pkgctx,'parse fields: ' || i);
    l_node := xmldom.item(l_nodeList, i);
    dbms_xslprocessor.valueOf(l_node,'key',v_Key);
    dbms_xslprocessor.valueOf(l_node,'value',v_Value);
    If v_Key ='Text'  Then
        l_txmsg.Text := trim(v_Value);
    End if;
    END LOOP;

    -- Free any resources associated with the document now it
    -- is no longer needed.
    DBMS_XMLDOM.freedocument(l_doc);
    -- Only used if variant is CLOB
    -- dbms_lob.freetemporary(p_xmlmsg);

    plog.setendsection(pkgctx, 'fn_xml2obj_A');
    RETURN l_txmsg;
EXCEPTION
    WHEN OTHERS THEN
    --dbms_lob.freetemporary(p_xmlmsg);
    DBMS_XMLPARSER.freeparser(l_parser);
    DBMS_XMLDOM.freedocument(l_doc);
    plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'fn_xml2obj_A');
    RAISE errnums.E_SYSTEM_ERROR;
END fn_xml2obj_A;

Procedure PRC_PROCESSA(V_MSGXML VARCHAR2, v_ID Varchar2) is
    v_txA   tx.msg_A;
    v_strSMS    Varchar2(100);
  BEGIN
    plog.setbeginsection (pkgctx, 'PRC_PROCESSA');

    v_txA := fn_xml2obj_A(V_MSGXML);

    IF instr(upper(v_txA.Text), upper('password expires')) > 0  THEN
        Begin
            Select sysvalue into v_strSMS from ordersys_ha where sysname='NOTIFYSMS';
             -- Sinh yeu cau gui SMS
            INSERT INTO emaillog (AUTOID,EMAIL,TEMPLATEID,DATASOURCE,STATUS,CREATETIME)
            VALUES(seq_emaillog.nextval, v_strSMS,'0555' ,'select ''HAGW-'||v_txA.Text||''' detail from dual'  , 'A', sysdate);

        EXCEPTION WHEN OTHERS THEN
            plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
            plog.setendsection (pkgctx, 'PRC_PROCESSA');
        End;
    END IF;
    plog.setendsection (pkgctx, 'PRC_PROCESSA');

  EXCEPTION WHEN OTHERS THEN
     plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
    v_CheckProcess := FALSE;
    plog.setendsection (pkgctx, 'PRC_PROCESSA');
    ROLLBACK;
  END PRC_PROCESSA;

--HNX_update: Xu ly Message BF
  Procedure PRC_PROCESSBF(V_MSGXML VARCHAR2, v_ID Varchar2) is
    V_TXBF   tx.msg_BF;
    v_newpassword VARCHAR2(100);

  BEGIN
    plog.setbeginsection (pkgctx, 'PRC_PROCESSBF');

    V_TXBF:=fn_xml2obj_BF(V_MSGXML);

    UPDATE GWinfor gw SET
           gw.status ='S',
           gw.asetstatus=V_TXBF.UserStatus,
           gw.userstatustext=V_TXBF.UserStatusText
    WHERE UserRequestID=V_TXBF.UserRequestID;
    IF V_TXBF.UserStatus ='5' THEN
      SELECT gw.newpassword INTO v_newpassword FROM GWinfor gw  WHERE gw.UserRequestID=V_TXBF.UserRequestID;
      UPDATE ordersys_ha SET
             sysvalue =v_newpassword
             WHERE  sysname ='GWPASSWORD';
    END IF;
    plog.setendsection (pkgctx, 'PRC_PROCESSBF');

  EXCEPTION WHEN OTHERS THEN
     plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
    v_CheckProcess := FALSE;
    plog.setendsection (pkgctx, 'PRC_PROCESSBF');
    ROLLBACK;
  END PRC_PROCESSBF;

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
/


-- End of DDL Script for Package Body HOSTMSTRADE.PCK_HAGW
