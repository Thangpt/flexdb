CREATE OR REPLACE PACKAGE pck_upcom
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
   pv_price      IN   NUMBER
);
  Procedure Prc_Update_Security;
  FUNCTION fnc_check_sec_upcom
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
  -- Procedure PRC_7(PV_REF IN OUT PKG_REPORT.REF_CURSOR);
  Procedure PRC_e(PV_REF IN OUT PKG_REPORT.REF_CURSOR);
  Procedure PRC_g_TT(PV_REF IN OUT PKG_REPORT.REF_CURSOR);
  Procedure PRC_GETORDER(PV_REF IN OUT PKG_REPORT.REF_CURSOR, v_MsgType VARCHAR2);
  FUNCTION fn_xml2obj_s(p_xmlmsg    VARCHAR2) RETURN tx.msg_s;
  FUNCTION fn_xml2obj_u(p_xmlmsg    VARCHAR2) RETURN tx.msg_u;
  FUNCTION fn_xml2obj_7(p_xmlmsg    VARCHAR2) RETURN tx.msg_7;
  FUNCTION fn_xml2obj_f(p_xmlmsg    VARCHAR2) RETURN tx.msg_f;
  FUNCTION fn_xml2obj_h(p_xmlmsg    VARCHAR2) RETURN tx.msg_h;
  --Procedure PRC_PROCESS7(V_MSGXML VARCHAR2, v_ID Varchar2);
  Procedure PRC_PROCESSf(V_MSGXML VARCHAR2, v_ID Varchar2);
  Procedure PRC_PROCESSs(V_MSGXML VARCHAR2, v_ID Varchar2);
  Procedure PRC_PROCESSh(V_MSGXML VARCHAR2, v_ID Varchar2);
  Procedure PRC_PROCESSu(V_MSGXML VARCHAR2, v_ID Varchar2);
  Procedure PRC_PROCESSt(V_MSGXML VARCHAR2, v_ID Varchar2);
  Procedure PRC_u(PV_REF IN OUT PKG_REPORT.REF_CURSOR);
  Procedure PRC_t(PV_REF IN OUT PKG_REPORT.REF_CURSOR);
  Procedure PRC_admendpt(v_orderid varchar2,v_qtty number,v_price number);
END;
/

CREATE OR REPLACE PACKAGE BODY pck_upcom
IS
  pkgctx plog.log_ctx;
  logrow tlogdebug%ROWTYPE;

  --LAY MESSAGE DAY LEN GW.
  Procedure PRC_GETORDER(PV_REF IN OUT PKG_REPORT.REF_CURSOR, v_MsgType VARCHAR2) is
  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_GETORDER');
      IF v_MsgType ='D' THEN
        --Day message lenh thong thuong D len Gw
        PRC_D(PV_REF);
      ELSIF v_MsgType ='G' THEN
        --Day message lenh sua G len Gw
        PRC_G(PV_REF);
      ELSIF v_MsgType ='F' THEN
        --Day message lenh huy F len Gw
        PRC_F(PV_REF);
      ELSIF v_MsgType ='e' THEN
        --Day message lenh Request CP len Gw
        PRC_e(PV_REF);
      ELSIF v_MsgType ='g' THEN
        --Day message lenh Request Thi truong len Gw
        PRC_g_TT(PV_REF);
      ELSIF v_MsgType ='s' THEN
        --Day message lenh thoa thuan len Gw
        PRC_s(PV_REF);
      ELSIF v_MsgType ='u' THEN
        --Day message huy lenh thoa thuan len Gw
        PRC_u(PV_REF);
      -- Xay dung GW theo huong tuong tu HNX nen ko can message nay
     ELSIF v_MsgType ='t' THEN
        --Day message sua lenh thoa thuan len Gw
        PRC_t(PV_REF);
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

    CURSOR C_D IS
        SELECT ORDERID ORDERID, 'New Single Order' Text,CUSTODYCD Account,
        CASE
        WHEN  SUBSTR(CUSTODYCD,4,1) = 'A' OR SUBSTR(CUSTODYCD,4,1) ='B' THEN '3'
        WHEN  SUBSTR(CUSTODYCD,4,1) ='E' OR SUBSTR(CUSTODYCD,4,1) ='F' THEN '4'
        WHEN  SUBSTR(CUSTODYCD,4,1) ='P' THEN '1'
        ELSE  '2' END AccountType,
        QUOTEPRICE Price,ORDERQTTY OrderQty,SYMBOL Symbol,
        decode(BORS,'B','1','S','2') Side, '2' OrdType, CODEID,BORS FROM
        send_order_to_upcom
        WHERE ROWNUM BETWEEN 0 AND (SELECT SYSVALUE FROM ORDERSYS_upcom WHERE SYSNAME='UPCOMSENDSIZE');

    Cursor c_Check_Doiung(v_BorS Varchar2, v_Custodycd Varchar2,v_Codeid Varchar2) is
                           SELECT ORGORDERID FROM ood o , odmast od
                           WHERE o.orgorderid = od.orderid and o.custodycd =v_Custodycd and o.codeid=v_Codeid
                                 And o.bors <> v_BorS
                                 And od.remainqtty >0
                                 AND od.EXECTYPE in ('NB','NS','MS')
                                 And o.oodstatus in ('B','S');

  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_D');
      FOR I IN C_D
      LOOP
      --Kiem tra neu co lenh doi ung Block, Sent chua khop het thi khong day len GW.
         v_Check:=False;
         Begin
           Select VARVALUE into v_strSysCheckBuySell from sysvar where GRNAME ='SYSTEM' and VARNAME ='TRADEBUYSELL';
         Exception When OTHERS Then
           v_strSysCheckBuySell:='N';
         End;
         If v_strSysCheckBuySell ='N' Then

             Open c_Check_Doiung(I.BORS, I.Account,I.CODEID);
             Fetch c_Check_Doiung into v_Temp;
               If c_Check_Doiung%found then
                v_Check:=True;
               End if;
             Close c_Check_Doiung;
          End if;
    IF Not v_Check THEN


        SELECT seq_ordermap.NEXTVAL Into v_Order_Number From dual;
         INSERT INTO upcom_d
                (text, ACCOUNT, accounttype, symbol, orderqty, side,
                 clordid, ordtype, price, orderid, date_time, status
                )
         VALUES (I.text, I.ACCOUNT, I.accounttype, I.symbol, I.orderqty, I.side,
                 v_Order_Number, I.ordtype, I.price, I.orderid, Sysdate, 'N'
                );
      --XU LY LENH THUONG D
        --1.1DAY VAO ORDERMAP.
        INSERT INTO ORDERMAP_UPCOM(ctci_order,orgorderid) VALUES (v_Order_Number,I.orderid);
        --1.2 CAP NHAT OOD.
        UPDATE OOD SET OODSTATUS='B' WHERE ORGORDERID=I.orderid;
        --1.3 DAY LENH VAO ODQUEUE
        INSERT INTO ODQUEUE SELECT * FROM OOD WHERE ORGORDERID = I.orderid;
      End If;
   END LOOP;
   --LAY DU LIEU RA GW.
   OPEN PV_REF FOR
   SELECT
        TEXT TEXT,
        ACCOUNT ACCOUNT,
        ACCOUNTTYPE ACCOUNTTYPE,
        SYMBOL SYMBOL,
        ORDERQTY ORDERQTY,
        SIDE SIDE,
        CLORDID CLORDID,
        ORDTYPE ORDTYPE,
        PRICE PRICE
   FROM UPCOM_D WHERE STATUS ='N';
   --Cap nhat trang thai bang tam ra GW.
   UPDATE upcom_D SET STATUS ='Y',DATE_TIME = SYSDATE WHERE STATUS ='N';

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
        'Order Replace Request' Text, QUOTEPRICE Price
        FROM (SELECT ODM.CTCI_ORDER, C.ACTYPE, D.TYPENAME, A.ORGORDERID ORDERID, C.EXECTYPE, A.CODEID, A.SYMBOL , E.QUOTEPRICE QUOTEPRICE,L.TRADELOT, C.STOPPRICE, C.LIMITPRICE, C.ORDERQTTY,A.PRICE OODPRICE, A.QTTY OODQTTY, TLLOG.TLID,TLLOG.BRID,
        A.TXDATE, A.TXNUM, J.FULLNAME, J.CUSTODYCD, K.FULLNAME ISSUERS, J.CUSTID, A.OODSTATUS, C.AFACCTNO, C.CIACCTNO, C.SEACCTNO, L.TRADEUNIT, E.BRATIO ,C.BRATIO OLDBRATIO, E.REFORDERID,
        L.SECUREDRATIOMIN, L.SECUREDRATIOMAX, C.MATCHTYPE, C.NORK, E.PRICETYPE, C.CLEARDAY, TLLOG.TXDESC, TLLOG.TLTXCD,C.ORSTATUS, C.EXECQTTY, ODM.order_number
        FROM OOD A, SBSECURITIES B, ODMAST C,ODMAST E, ODTYPE D, AFMAST I, CFMAST J, ISSUERS K,
             SECURITIES_INFO L, TLLOG,ORDERMAP_UPCOM ODM
        WHERE (A.CODEID = B.CODEID AND A.ORGORDERID = E.ORDERID AND E.REFORDERID=C.ORDERID AND C.ACTYPE = D.ACTYPE)
          AND E.REFORDERID=ODM.ORGORDERID
          AND A.TXDATE = TLLOG.TXDATE AND A.TXNUM = TLLOG.TXNUM
          AND (TLLOG.TXSTATUS = '1' OR (TLLOG.TLTXCD IN ('8884','8885') AND TLLOG.TXSTATUS = '1' ) )
          AND B.CODEID = L.CODEID
          AND C.ORSTATUS NOT IN ('3','0','6','8') AND C.MATCHTYPE ='N' AND C.REMAINQTTY >0
          AND C.AFACCTNO = I.ACCTNO AND I.CUSTID = J.CUSTID
          AND B.ISSUERID = K.ISSUERID
          AND B.TRADEPLACE='005'
          AND ODM.order_number is not null
          AND OODSTATUS IN ('N') AND C.DELTD <> 'Y'  AND TLLOG.TLTXCD IN ('8884','8885')
          ORDER BY J.CLASS DESC , SUBSTR(A.ORGORDERID,5,12)
          )
         WHERE ROWNUM BETWEEN 0 AND (SELECT SYSVALUE FROM ORDERSYS_UPCOM WHERE SYSNAME='UPCOMSENDSIZE');

  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_G');
      FOR I IN C_G
      LOOP
        INSERT INTO upcom_g
            (text, clordid, origclordid, price, orderid, date_time,
             status
            )
        VALUES (I.text, I.clordid, I.origclordid, I.price, I.orderid, sysdate,
             'N'
            );
        --XU LY LENH SUA G
        --1.1DAY VAO ORDERMAP.
        INSERT INTO ORDERMAP_UPCOM(ctci_order,orgorderid) VALUES (I.clordid,I.orderid);
        --1.2 CAP NHAT OOD.
        UPDATE OOD SET OODSTATUS='B' WHERE ORGORDERID=I.orderid;
        --1.3 DAY LENH VAO ODQUEUE
        INSERT INTO ODQUEUE SELECT * FROM OOD WHERE ORGORDERID = I.orderid;
      END LOOP;
   --LAY DU LIEU RA GW.
   OPEN PV_REF FOR
   SELECT
        TEXT TEXT,
        CLORDID CLORDID,
        ORIGCLORDID ORIGCLORDID,
        PRICE PRICE
   FROM UPCOM_G WHERE STATUS ='N';
   --Cap nhat trang thai bang tam ra GW.
   UPDATE UPCOM_G SET STATUS ='Y',DATE_TIME = SYSDATE WHERE STATUS ='N';
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
        'Order Cancel Request' Text
        FROM (SELECT ODM.CTCI_ORDER,S.VARVALUE FIRM, C.ACTYPE, D.TYPENAME, A.ORGORDERID ORDERID, C.EXECTYPE, A.CODEID, A.SYMBOL , C.QUOTEPRICE/L.TRADEUNIT QUOTEPRICE,L.TRADELOT, C.STOPPRICE, C.LIMITPRICE, C.ORDERQTTY,A.PRICE OODPRICE, A.QTTY OODQTTY, TLLOG.TLID,TLLOG.BRID,
        A.TXDATE, A.TXNUM, J.FULLNAME, J.CUSTODYCD, K.FULLNAME ISSUERS, J.CUSTID, A.OODSTATUS, C.AFACCTNO, C.CIACCTNO, C.SEACCTNO, L.TRADEUNIT, E.BRATIO ,C.BRATIO OLDBRATIO, E.REFORDERID,
        L.SECUREDRATIOMIN, L.SECUREDRATIOMAX, C.MATCHTYPE, C.NORK, E.PRICETYPE, C.CLEARDAY, TLLOG.TXDESC, TLLOG.TLTXCD,C.ORSTATUS, C.EXECQTTY,ODM.ORDER_NUMBER
        FROM OOD A, SBSECURITIES B, ODMAST C,ODMAST E, ODTYPE D, AFMAST I, CFMAST J, ISSUERS K, SECURITIES_INFO L, TLLOG, SYSVAR S,ORDERMAP_UPCOM ODM
        WHERE (A.CODEID = B.CODEID AND A.ORGORDERID = E.ORDERID AND E.REFORDERID=C.ORDERID AND C.ACTYPE = D.ACTYPE)
          AND E.REFORDERID=ODM.ORGORDERID
          AND A.TXDATE = TLLOG.TXDATE AND A.TXNUM = TLLOG.TXNUM AND (TLLOG.TXSTATUS = '1' OR (TLLOG.TLTXCD IN ('8882','8883') AND TLLOG.TXSTATUS = '1' ) )
          AND B.CODEID = L.CODEID
          AND C.ORSTATUS NOT IN ('3','0','6','8') AND C.MATCHTYPE ='N' AND C.REMAINQTTY >0
          AND C.AFACCTNO = I.ACCTNO AND I.CUSTID = J.CUSTID
          AND B.ISSUERID = K.ISSUERID
          AND B.TRADEPLACE='005'
          AND ODM.order_number is not null
          AND OODSTATUS IN ('N') AND C.DELTD <> 'Y'  AND TLLOG.TLTXCD IN ('8882','8883')
          AND S.GRNAME='SYSTEM' AND S.VARNAME='FIRM'
          ORDER BY J.CLASS DESC , SUBSTR(A.ORGORDERID,5,12)
          )
         WHERE ROWNUM BETWEEN 0 AND (SELECT SYSVALUE FROM ORDERSYS_upcom WHERE SYSNAME='UPCOMSENDSIZE');

  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_F');
      FOR I IN C_F
      LOOP
         INSERT INTO upcom_f
                (text, clordid, origclordid, orderid, date_time, status
                )
         VALUES (I.text, I.clordid, I.origclordid, I.orderid, Sysdate, 'N'
                );
      --XU LY LENH HUY F
        --1.1DAY VAO ORDERMAP.
        INSERT INTO ORDERMAP_upcom(ctci_order,orgorderid) VALUES (I.clordid,I.orderid);
        --1.2 CAP NHAT OOD.
        UPDATE OOD SET OODSTATUS='B' WHERE ORGORDERID=I.orderid;
        --1.3 DAY LENH VAO ODQUEUE
        INSERT INTO ODQUEUE SELECT * FROM OOD WHERE ORGORDERID = I.orderid;
      END LOOP;
   --LAY DU LIEU RA GW.
   OPEN PV_REF FOR
   SELECT
        TEXT TEXT,
        CLORDID CLORDID,
        ORIGCLORDID ORIGCLORDID
    FROM upcom_F WHERE STATUS ='N';
   --Cap nhat trang thai bang tam ra GW.
   UPDATE UPCOM_F SET STATUS ='Y',DATE_TIME = SYSDATE WHERE STATUS ='N';
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
        (select NVL(advidref,'0') CrossID,Decode(NVL(advidref,'0'),'0','1','8') CrossType,ORDERID,FIRM,SCLIENTID,ORDERQTTY,SCUSTODIAN,CONTRAFIRM,BCLIENTID,BCUSTODIAN,to_char(Symbol) SYMBOL,QUOTEPRICE,codeid from send_2firm_pt_order_to_upcom
         UNION ALL
         select NVL(advidref,'0') CrossID,Decode(NVL(advidref,'0'),'0','1','8') CrossType, ORDERID,FIRM,SCLIENTID,ORDERQTTY,SCUSTODIAN,FIRM,BCLIENTID,BCUSTODIAN,to_char(Symbol) SYMBOL,QUOTEPRICE,codeid from send_putthrough_order_to_upcom
         Union All
         -- dong y mua
        SELECT confirmnumber CrossID,Decode(A.STATUS,'A','5','C','6') CrossType,ORDERID, SELLERCONTRAFIRM FIRM ,
        SCLIENTID, C.QTTY ORDERQTTY,Substr(SCLIENTID,4,1) SCUSTODIAN, FIRM CONTRAFIRM,C.CUSTODYCD BCLIENTID
        ,Substr(C.CUSTODYCD,4,1) BCUSTODIAN, securitysymbol SYMBOL,QUOTEPRICE,b.codeid
        FROM ORDERPTACK A, ODMAST B,OOD C, SBSECURITIES S WHERE A.STATUS IN ('A')
        AND A.CONFIRMNUMBER=B.CONFIRM_NO AND B.ORDERID=C.ORGORDERID
        AND B.DELTD <>'Y' AND A.ISSEND <>'Y' AND C.symbol =s.symbol and s.tradeplace ='005'
        and a.messagetype='s'
        union all  -- tu choi mua
         SELECT confirmnumber CrossID,Decode(A.STATUS,'A','5','C','6') CrossType,'000' ORDERID, SELLERCONTRAFIRM FIRM ,
        SCLIENTID,0 ORDERQTTY,Substr(SCLIENTID,4,1) SCUSTODIAN, FIRM CONTRAFIRM,'000' BCLIENTID
        ,'000' BCUSTODIAN, securitysymbol SYMBOL,0 QUOTEPRICE,s.codeid
        FROM ORDERPTACK A,  SBSECURITIES S WHERE A.STATUS IN ('C')
         AND A.ISSEND <>'Y'  and s.tradeplace ='005'
         and s.symbol=  a.securitysymbol
                 and a.messagetype='s'
        )
        WHERE ROWNUM BETWEEN 0 AND (SELECT SYSVALUE FROM ORDERSYS_UPCOM WHERE SYSNAME='UPCOMSENDSIZE')
        AND fnc_check_sec_upcom(SYMBOL)  <> '0';

        Cursor c_Check_Doiung(v_BorS Varchar2, v_Custodycd Varchar2,v_Codeid Varchar2) is
                       SELECT ORGORDERID FROM ood o , odmast od
                       WHERE o.orgorderid = od.orderid and o.custodycd =v_Custodycd and o.codeid=v_Codeid
                             And o.bors <> v_BorS
                             And od.remainqtty >0
                             AND od.EXECTYPE in ('NB','NS','MS')
                             And o.oodstatus in ('B','S');


  BEGIN

      plog.setbeginsection (pkgctx, 'PRC_s');
      FOR I IN C_s
      LOOP


      --Kiem tra neu co lenh doi ung Block, Sent chua khop het thi khong day len GW.
         --Sysvar ko cho BuySell thi check doi ung.
         v_Check:=False;

         Begin
           Select VARVALUE into v_strSysCheckBuySell from sysvar where GRNAME ='SYSTEM' and VARNAME ='TRADEBUYSELL';
         Exception When OTHERS Then
           v_strSysCheckBuySell:='N';
         End;
         If v_strSysCheckBuySell ='N' Then

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

         IF Not v_Check THEN


                  INSERT INTO upcom_s
                            (crossid, sellaccount, sellaccounttype, symbol,
                             sellorderqty, sellpartyid, price, crosstype, nosides,
                             sellside, buyside, buypartyid, buyaccount, buyorderqty,
                             buyaccounttype, orderid, date_time, status
                            )
                     VALUES (I.crossid, I.sellaccount, I.sellaccounttype, I.symbol,
                             I.sellorderqty, I.sellpartyid, I.price, I.crosstype, I.nosides,
                             I.sellside, I.buyside, I.buypartyid, I.buyaccount, I.buyorderqty,
                             I.buyaccounttype, I.orderid, sysdate, 'N'
                            );

              --XU LY LENH THOA THUAN
                --1.1DAY VAO ORDERMAP.
                INSERT INTO ORDERMAP_UPCOM(ctci_order,orgorderid) VALUES (I.crossid,I.orderid);
                --1.2 CAP NHAT OOD.
                UPDATE OOD SET OODSTATUS='B' WHERE ORGORDERID=I.orderid;
                --1.3 DAY LENH VAO ODQUEUE
                INSERT INTO ODQUEUE SELECT * FROM OOD WHERE ORGORDERID = I.orderid;

                --1.4 Cap nhat trang thai la da confirm
                UPDATE ORDERPTACK SET ISSEND='Y' WHERE  trim(CONFIRMNUMBER)=trim(I.crossid);

         END IF;
      END LOOP;
   --LAY DU LIEU RA GW.
   OPEN PV_REF FOR
   SELECT
        CrossID CrossID,
        SellAccount SellAccount,
        SellAccountType SellAccountType,
        Symbol Symbol,
        SellOrderQty SellOrderQty,
        SellPartyID SellPartyID,
        Price Price,
        CrossType CrossType,
        NoSides NoSides,
        SellSide SellSide,
        BuySide BuySide,
        BuyPartyID BuyPartyID,
        BuyAccount BuyAccount,
        BuyOrderQty BuyOrderQty,
        BuyAccountType BuyAccountType
   FROM UPCOM_s WHERE STATUS ='N';
   --Cap nhat trang thai bang tam ra GW.
   UPDATE UPCOM_s SET STATUS ='Y',DATE_TIME = SYSDATE WHERE STATUS ='N';
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
            and c.securitysymbol =sb.symbol and sb.tradeplace ='005'
            Union all
            SELECT '7' CrossType, order_number OrigCrossID,to_char(symbol) SECURITYSYMBOL,bors SIDE
            FROM ordermap_upcom o, ood
            where o.orgorderid =ood.orgorderid and ood.oodstatus ='B'
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
            and c.securitysymbol =sb.symbol and sb.tradeplace ='005'
            );

  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_u');
      FOR I IN C_u
      LOOP
          INSERT INTO upcom_u
            (crossid, crosstype, origcrossid, date_time, status
            )
     VALUES (i.crossid, i.crosstype, i.origcrossid, sysdate, 'N'
            );

      --XU LY LENH THOA THUAN
        UPDATE CANCELORDERPTACK SET ISCONFIRM='S' WHERE MESSAGETYPE='3C' AND SORR='S' AND CONFIRMNUMBER=i.OrigCrossID;
        UPDATE CANCELORDERPTACK SET ISCONFIRM='S' WHERE MESSAGETYPE='u' AND SORR='R' AND CONFIRMNUMBER=i.OrigCrossID;
        Update ordermap_upcom set REJECTCODE ='Y' where order_number=i.OrigCrossID;

        --Temp_ xoa lenh thoa thuan tu xa chua thuc hien
        Update orderptack_delt set ISSEND ='Y' where ORIGCROSSID =i.OrigCrossID;


      END LOOP;
   --LAY DU LIEU RA GW.
   OPEN PV_REF FOR
   SELECT
        CrossID CrossID,
        CrossType CrossType,
        OrigCrossID OrigCrossID
   FROM upcom_u WHERE STATUS ='N';
   --Cap nhat trang thai bang tam ra GW.
   UPDATE upcom_u SET STATUS ='Y',DATE_TIME = SYSDATE WHERE STATUS ='N';
   plog.setendsection (pkgctx, 'PRC_u');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_u');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_u;

  --Day message sua lenh thoa thuan len Gw
  Procedure PRC_t(PV_REF IN OUT PKG_REPORT.REF_CURSOR) is

    v_err VARCHAR2(200);
    v_Temp VARCHAR2(30);
    v_Check BOOLEAN;
    v_strSysCheckBuySell VARCHAR2(30);

    CURSOR C_t IS
        ---------------------------------------------------------------------
        --- Note : Cau select ra cac lenh sua cai day len GW chua chuan.
        --- Khi nao code xong phan huy lenh --> Phai sua lai cau select nay.
        ---------------------------------------------------------------------
        SELECT  Decode(CrossID,'0',to_char( seq_ordermap.NEXTVAL),CrossID) CrossID,  OrigCrossid, ORDERID,
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
        (
       -- TRUONG HOP LA BEN MUA
         SELECT confirmnumber CrossID,Decode(A.STATUS,'A','5','C','6') CrossType,ORDERID, SELLERCONTRAFIRM FIRM ,
        SCLIENTID, C.QTTY ORDERQTTY,Substr(SCLIENTID,4,1) SCUSTODIAN, FIRM CONTRAFIRM,C.CUSTODYCD BCLIENTID
        ,Substr(C.CUSTODYCD,4,1) BCUSTODIAN, securitysymbol SYMBOL,QUOTEPRICE,b.codeid, a.confirmnumber OrigCrossID
        FROM orderptadmend A, ODMAST B,OOD C, SBSECURITIES S WHERE A.STATUS IN ('A','C')
        AND A.OrigCrossID=B.CONFIRM_NO AND B.ORDERID=C.ORGORDERID
        AND B.DELTD <>'Y'
         AND A.ISSEND <>'Y'
        AND C.symbol =s.symbol and s.tradeplace ='005'
        and a.messagetype='t'
        AND  A.side='B'
        --tRUONG HOP LA BEN BAN
        UNION all
         SELECT confirmnumber CrossID,'1' CrossType,a.ordernumber ORDERID, SELLERCONTRAFIRM FIRM ,
        SCLIENTID,to_number(a.volume) ORDERQTTY,Substr(SCLIENTID,4,1) SCUSTODIAN, FIRM CONTRAFIRM,od.clientid  BCLIENTID
        ,'C' BCUSTODIAN, securitysymbol SYMBOL,TO_NUMBER(A.PRICE) QUOTEPRICE,s.codeid,a.OrigCrossID
        FROM orderptadmend A,  SBSECURITIES S , odmast od
        WHERE A.STATUS IN ('A')
         AND A.ISSEND <>'Y'  and s.tradeplace ='005'
         and s.symbol=  a.securitysymbol
         and messagetype='t'
         AND A.SIdE='S'
         and  od.orderid=a.ordernumber
         and od.deltd<>'Y' and od.txdate=a.trading_date
        )
        WHERE ROWNUM BETWEEN 0 AND (SELECT SYSVALUE FROM ORDERSYS_UPCOM WHERE SYSNAME='UPCOMSENDSIZE')
        AND fnc_check_sec_upcom(SYMBOL)  <> '0';


  BEGIN

      plog.setbeginsection (pkgctx, 'PRC_t');
      FOR I IN C_t
      LOOP

                  INSERT INTO upcom_t
                            (crossid, OrigCrossid, sellaccount, sellaccounttype, symbol,
                             sellorderqty, sellpartyid, price, crosstype, nosides,
                             sellside, buyside, buypartyid, buyaccount, buyorderqty,
                             buyaccounttype, orderid, date_time, status
                            )
                     VALUES (I.crossid, I.OrigCrossid, I.sellaccount, I.sellaccounttype, I.symbol,
                             I.sellorderqty, I.sellpartyid, I.price, I.crosstype, I.nosides,
                             I.sellside, I.buyside, I.buypartyid, I.buyaccount, I.buyorderqty,
                             I.buyaccounttype, I.orderid, sysdate, 'N'
                            );

              --XU LY LENH THOA THUAN
                --1.1DAY VAO ORDERMAP.
              /*  INSERT INTO ORDERMAP_UPCOM(ctci_order,orgorderid) VALUES (I.crossid,I.orderid);
                --1.2 CAP NHAT OOD.
                UPDATE OOD SET OODSTATUS='B' WHERE ORGORDERID=I.orderid;
                --1.3 DAY LENH VAO ODQUEUE
                INSERT INTO ODQUEUE SELECT * FROM OOD WHERE ORGORDERID = I.orderid;*/

                --1.4 Cap nhat trang thai la da confirm
                UPDATE ORDERPTAdmend SET ISSEND='Y' WHERE  trim(CONFIRMNUMBER)=trim(I.crossid);


      END LOOP;
   --LAY DU LIEU RA GW.
   OPEN PV_REF FOR
   SELECT
        CrossID CrossID,
        OrigCrossID OrigCrossID,
        SellAccount SellAccount,
        SellAccountType SellAccountType,
        Symbol Symbol,
        SellOrderQty SellOrderQty,
        SellPartyID SellPartyID,
        Price Price,
        CrossType CrossType,
        NoSides NoSides,
        SellSide SellSide,
        BuySide BuySide,
        BuyPartyID BuyPartyID,
        BuyAccount BuyAccount,
        BuyOrderQty BuyOrderQty,
        BuyAccountType BuyAccountType
   FROM UPCOM_t WHERE STATUS ='N';
   --Cap nhat trang thai bang tam ra GW.
   UPDATE UPCOM_t SET STATUS ='Y',DATE_TIME = SYSDATE WHERE STATUS ='N';
   plog.setendsection (pkgctx, 'PRC_t');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_t');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_t;



  /*
  -- Upcom khong co lenh quang cao --> Khong dung ham nay
  -- Day message lenh quang cao len Gw
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
        from ORDERPTADV A,sbsecurities s,securities_info se,ORDERPTADV B, orDerMAP_upcom O
        where Trim(a.securitysymbol) =trim(se.SYMBOL)
        and s.codeid =se.codeid
        And s.tradeplace ='002'
        And A.DELETED <> 'Y' AND A.ISSEND='N' AND A.ISACTIVE='Y'
        And A.refid =B.autoid(+)
        AND O.ctci_order(+)  = TO_CHar(B.autoid)
        )
        Where PCK_UpCom.fnc_check_sec_upcom(SYMBOL)  <> '0';

  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_7');
      FOR I IN C_7
      LOOP
        INSERT INTO upcom_7
            (text, advid, advside, quantity, advtranstype, symbol,
             delivertocompid, price, advrefid, date_time, status
            )
     VALUES (I.text, I.advid, I.advside, I.quantity, I.advtranstype, I.symbol,
             I.delivertocompid, I.price, I.advrefid, Sysdate, 'N'
            );
      --XU LY LENH SUA 7
        --1.1
        UPDATE ORDERPTADV SET ISSEND='Y' WHERE AUTOID =I.advid;
        --1.2
        INSERT INTO ORDERMAP_upcom(ctci_order,orgorderid) VALUES (I.advid,I.advid);

        --1.3Temp_ Them phan nay de xoa lenh thoa thuan tu xa
        UPDATE HAPUT_AD_DELT SET issend='Y' WHERE AUTOID =I.advid;

      END LOOP;
   --LAY DU LIEU RA GW.
   OPEN PV_REF FOR
   SELECT
        TEXT TEXT,
        ADVID ADVID,
        ADVSIDE ADVSIDE,
        QUANTITY QUANTITY,
        ADVTRANSTYPE ADVTRANSTYPE,
        SYMBOL SYMBOL,
        DELIVERTOCOMPID DELIVERTOCOMPID,
        PRICE PRICE,
        ADVREFID ADVREFID
   FROM upcom_7 WHERE STATUS ='N';
   --Cap nhat trang thai bang tam ra GW.
   UPDATE upcom_7 SET STATUS ='Y',DATE_TIME = SYSDATE WHERE STATUS ='N';
   plog.setendsection (pkgctx, 'PRC_7');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_7');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_7;

  */

  --Day message lenh Request CP len Gw
  Procedure PRC_e(PV_REF IN OUT PKG_REPORT.REF_CURSOR) is

    v_err VARCHAR2(200);

  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_e');
   --LAY DU LIEU RA GW.
   OPEN PV_REF FOR
        Select ID SecurityStatusReqID ,
               REQTYPE SubscriptionRequestType ,
               Decode(SYMBOL,'ALL',' ',SYMBOL) Symbol
        From UpComstatusReq
        Where MarketOrSecuritity ='S' And status ='N';

   --Cap nhat trang thai .
   UPDATE UpComstatusReq SET Status = 'S' WHERE STATUS ='N' And MarketOrSecuritity ='S';
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
        Select ID TradSesReqID ,REQTYPE SubscriptionRequestType
        From UpcomStatusReq
        Where MarketOrSecuritity ='M' and status ='N';

   --Cap nhat trang thai .
   UPDATE UpcomStatusReq SET Status = 'S' WHERE STATUS ='N' And MarketOrSecuritity ='M';
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
   mv_mtrfday          NUMBER(10);
   mv_strtradeplace      VARCHAR2(3);
   mv_dbltrfbuyext      number(20,0);
   mv_strtrfstatus      VARCHAR2(1);
   mv_dbltrfbuyrate      number(20,4);

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
   v_tltxcd := '8804';

   mv_strtradeplace:='005';
   mv_dbltrfbuyext:=0;
   mv_dbltrfbuyrate:=0;

         INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, ' Input order_number '||order_number ||' '|| deal_volume||' '|| deal_price||' '|| confirm_number, ''
                  );

      COMMIT;


   SELECT    '8000'
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
        FROM ordermap_upcom
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



   --TungNT modified - for T2 late send money
   BEGIN
      SELECT od.remainqtty, sb.codeid, sb.symbol, ood.custodycd,
             ood.bors, ood.norp, ood.aorn, od.afacctno,
             od.ciacctno, od.seacctno, '', '',
             od.clearcd, ood.price, ood.qtty, deal_price,
             deal_volume, od.clearday, od.bratio,
             confirm_number, v_txdate, '', typ.mtrfday,
             ss.tradeplace,af.trfbuyext, af.trfbuyrate
        INTO mv_strremainqtty, mv_strcodeid, mv_strsymbol, mv_strcustodycd,
             mv_strbors, mv_strnorp, mv_straorn, mv_strafacctno,
             mv_strciacctno, mv_strseacctno, mv_reforderid, mv_refcustcd,
             mv_strclearcd, mv_strexprice, mv_strexqtty, mv_strprice,
             mv_strqtty, mv_strclearday, mv_strsecuredratio,
             mv_strconfirm_no, mv_strmatch_date, mv_desc,mv_mtrfday,
             mv_strtradeplace,mv_dbltrfbuyext, mv_dbltrfbuyrate
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
   INSERT INTO stctradebook
            (txdate, confirmnumber, refconfirmnumber, ordernumber, bors,
             volume, price
            )
     VALUES (to_date(v_txdate,'dd/mm/yyyy'), mv_strconfirm_no, v_refconfirmno, order_number, mv_strbors,
             mv_strqtty, mv_strprice
            );

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
                         qtty, aqtty, famt, status, deltd, costprice, cleardate
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

      UPDATE ODMAST
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
       WHERE orderid = mv_strorgorderid;

       UPDATE odmast
         SET HOSESESSION = (SELECT SYSVALUE  FROM ORDERSYS WHERE SYSNAME = 'CONTROLCODE')
       WHERE orderid = mv_strorgorderid And HOSESESSION ='N';


      --Neu khop het va co lenh huy cua lenh da khop thi cap nhat thanh refuse
      IF mv_strremainqtty = mv_strqtty THEN
          UPDATE odmast
             SET ORSTATUS = '0'
           WHERE REFORDERID = mv_strorgorderid;
        END IF;

      --Cap nhat tinh gia von

     /* IF mv_strbors = 'B' THEN
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
   END IF;
   --Cap nhat cho GTC
   OPEN C_ODMAST(MV_STRORGORDERID);
   FETCH C_ODMAST INTO VC_ODMAST;
    IF C_ODMAST%FOUND THEN
         UPDATE FOMAST SET REMAINQTTY= REMAINQTTY - MV_STRQTTY
                            ,EXECQTTY= EXECQTTY + MV_STRQTTY
                            ,EXECAMT=  EXECAMT + MV_STRPRICE * MV_STRQTTY
          WHERE ORGACCTNO= MV_STRORGORDERID;
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
   v_ex                 EXCEPTION;

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

      COMMIT;



   --Lenh huy thong thuong: Co lenh huy 1C
   SELECT count(*) INTO v_Count_lenhhuy FROM odmast WHERE reforderid =pv_orderid AND exectype IN ('CB','CS');
   IF v_Count_lenhhuy >0 Then
        SELECT (CASE
                      WHEN exectype = 'CB'
                         THEN '8890'
                      ELSE '8891'
                   END), sb.symbol,
                  od.afacctno, od.seacctno, od.quoteprice, od.orderqtty, od.bratio,
                  0, od.quoteprice, 0, od.orderqtty - pv_qtty,
                  od.reforderid, sb.tradeunit, od.edstatus
             INTO v_tltxcd, v_symbol,
                  v_afaccount, v_seacctno, v_price, v_quantity, v_bratio,
                  v_amendmentqtty, v_amendmentprice, v_matchedqtty, v_execqtty,
                  v_reforderid, v_tradeunit, v_edstatus
             FROM odmast od, securities_info sb
            WHERE od.codeid = sb.codeid AND reforderid = pv_orderid;
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
            WHERE od.codeid = sb.codeid AND orderid = pv_orderid;
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

      SELECT    '8000'
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
      If v_Count_lenhhuy >0 then
          v_edstatus := 'W';
          UPDATE odmast
             SET edstatus = v_edstatus
          WHERE orderid = pv_orderid;

          UPDATE OOD SET OODSTATUS = 'S'
          WHERE ORGORDERID IN (SELECT ORDERID FROM ODMAST  WHERE REFORDERID = pv_orderid)
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
      ELSE                                                   --v_tltxcd='8891' , '8807'
         --SELL
         UPDATE odmast
            SET cancelqtty = cancelqtty + v_cancelqtty,
                remainqtty = remainqtty - v_cancelqtty
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

 --Cap nhat cho GTC
   OPEN C_ODMAST(pv_orderid);
   FETCH C_ODMAST INTO VC_ODMAST;
    IF C_ODMAST%FOUND THEN
         UPDATE FOMAST SET   REMAINQTTY= REMAINQTTY - v_cancelqtty
                            ,cancelqtty= cancelqtty + v_cancelqtty
          WHERE ORGACCTNO= pv_orderid;
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
   pv_price      IN   NUMBER
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

      COMMIT;

   --Kiem tra thoa man dieu kien sua
     BEGIN
     INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, ' 111 Input pv_ordernumber HERE '||pv_ordernumber ||' '|| pv_qtty||' '|| pv_price,''
                  );

      COMMIT;

        Select Orgorderid into PV_ORDERID from Ordermap_upcom where Order_number =pv_ordernumber;
INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, ' 222 Input pv_ordernumber HERE '||pv_ordernumber ||' '|| pv_qtty||' '|| pv_price,''
                  );

      COMMIT;

     EXCEPTION
      WHEN OTHERS
      THEN
         v_err := SUBSTR ('ABC Order_number ' || SQLERRM, 1, 100);
         RAISE v_ex;
     End;

   Begin
    SELECT ORDERQTTY,REMAINQTTY,EXECQTTY,CANCELQTTY,ORSTATUS,Exectype
    INTO V_ORDERQTTY_CUR,V_REMAINQTTY_CUR,V_EXECQTTY_CUR,V_REPLACEQTTY_CUR,V_ORSTATUS_CUR,v_Exectype
    FROM ODMAST WHERE ORDERID =PV_ORDERID;

   EXCEPTION
      WHEN OTHERS
      THEN
         v_err := SUBSTR ('ODMAST WHERE ORDERID =PV_ORDERID ' || SQLERRM, 1, 100);
         RAISE v_ex;
   END;


   IF V_REMAINQTTY_CUR - v_replaceqtty < 0 OR V_EXECQTTY_CUR >= V_ORDERQTTY_CUR
                 OR v_replaceqtty = 0
   THEN
    RETURN;
   END IF;

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
                  LIMITPRICE,VOUCHER,CONSULTANT, od.codeid
             INTO v_tltxcd, v_symbol,
                  v_afaccount, v_seacctno, v_price, v_quantity, v_bratio,
                  v_amendmentqtty, v_amendmentprice, v_matchedqtty, v_execqtty,
                  v_reforderid, v_tradeunit, v_edstatus,v_custid,v_actype,v_timetype,
                  v_NorK,v_MATCHTYPE,v_Via,v_CLEARDAY,v_CLEARCD,v_PRICETYPE,v_CUSTODYCD,
                  v_LIMITPRICE,v_VOUCHER,v_CONSULTANT,v_codeid
             FROM odmast od, ood ,  securities_info sb
            WHERE od.codeid = sb.codeid AND od.orderid = ood.orgorderid AND od.reforderid = pv_orderid;

  Exception when others then
         v_err := SUBSTR ('Confirm Replace cancel: Khong tim thay reforderid = pv_orderid'||pv_orderid ||' '|| SQLERRM, 1, 100);
         RAISE v_ex;
  End;

   v_advancedamount := 0;


   SELECT bratio
     INTO v_oldbratio
     FROM odmast
    WHERE orderid = pv_orderid;


      SELECT varvalue
        INTO v_txdate
        FROM sysvar
       WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

     Select '0001'||to_char(to_date(v_txdate,'dd/mm/yyyy'),'ddmmyy')||lpad(SEQ_ODMAST.NEXTVAL,6,'0')
     into v_OrderID from dual;

      SELECT    '8000'
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
      WHERE ORGORDERID IN (SELECT ORDERID FROM ODMAST  WHERE REFORDERID = pv_orderid)
      and OODSTATUS <> 'S';
      UPDATE ODMAST SET ORSTATUS = '2' WHERE ORDERID IN (SELECT ORDERID FROM ODMAST  WHERE REFORDERID = pv_orderid)
                                       AND ORSTATUS = '8';


      --3 CAP NHAT TRAN VA MAST
      IF v_tltxcd = '8890'
      THEN

         --BUY
        v_BORS :='B';
         UPDATE odmast
            SET adjustqtty = adjustqtty + v_replaceqtty,
                remainqtty = remainqtty - v_replaceqtty
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
         UPDATE odmast
            SET adjustqtty = adjustqtty + v_replaceqtty,
                remainqtty = remainqtty - v_replaceqtty
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
                 EXECQTTY,STANDQTTY,CANCELQTTY,ADJUSTQTTY,REJECTQTTY,REJECTCD,VOUCHER,CONSULTANT,REFORDERID,CORRECTIONNUMBER)
          VALUES ( v_ORDERID , v_CUSTID , v_ACTYPE , v_CODEID , v_afaccount
                  ,v_SEACCTNO ,v_afaccount
                  , v_TXNUM ,TO_DATE (v_txdate, 'DD/MM/YYYY'), v_TXTIME
                  ,TO_DATE (v_txdate, 'DD/MM/YYYY'),v_BRATIO ,v_TIMETYPE
                  ,v_EXECTYPE ,v_NORK ,v_MATCHTYPE ,v_VIA ,v_CLEARDAY , v_CLEARCD ,'2','2',v_PRICETYPE
                  ,v_amendmentprice ,0,v_LIMITPRICE ,v_ReplaceQTTY,v_ReplaceQTTY ,v_amendmentprice ,v_ReplaceQTTY,0
                  ,0,0,0,0,0,'001', v_VOUCHER , v_CONSULTANT , pv_orderid , 1 );

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
        --Cap nhat lai ODRERMAP_upcom theo so hieu lenh moi cua lenh sua.
        Update Ordermap_upcom set rejectcode =  orgorderid where orgorderid =pv_orderid;
        Update Ordermap_upcom set orgorderid =  v_ORDERID where orgorderid =pv_orderid;

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
                    EFFDATE,EXPDATE,BRATIO,VIA,OUTPRICEALLOW)
             SELECT v_ORDERID,v_ORDERID,v_ACTYPE,v_afaccount,'A',EXECTYPE,v_PRICETYPE,
                    v_TIMETYPE,v_MATCHTYPE,v_NORK,CLEARCD,v_CODEID,v_Symbol,'N'
                    ,'A','',TO_CHAR(SYSDATE,'DD/MM/RRRR HH:MM:SS'),TO_CHAR(SYSDATE,'DD/MM/RRRR HH:MM:SS'),
                    v_CLEARDAY ,v_ReplaceQTTY, v_amendmentprice/ v_tradeunit ,v_amendmentprice / v_tradeunit ,
                     0 , 0 , 0 ,v_ReplaceQTTY ,TO_DATE(v_txdate, 'dd/mm/rrrr'),v_TXNUM,
                    EFFDATE,EXPDATE,v_BRATIO,v_VIA,OUTPRICEALLOW
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
      Select SYMBOL,HIGHPX CEILING_PRICE, LOWPX FLOOR_PRICE, lastpx BASIC_PRICE, BUYVOLUME current_room,
             CASE When (SECURITYTRADINGSTATUS in ('17','24','25','26')
                  ) Then 'N'
                  Else 'Y'
                  End HALT_SUSP from  UpComSecurity_req;
    Begin
         For vc_stock in c_Stock
         Loop
            -- trong truong hop cap nhat gia tren file khac voi gia gateway comment cap nhat 2 gia CEILING va FLOOR lai
            UPDATE SECURITIES_INFO
            SET
                CEILINGPRICE= vc_stock.CEILING_PRICE,
                FLOORPRICE= vc_stock.FLOOR_PRICE,
                BASICPRICE= vc_stock.BASIC_PRICE,
                current_room=vc_stock.current_room
            WHERE TRIM(SYMBOL)= TRIM(vc_stock.SYMBOL)
                  and( CEILINGPRICE<> vc_stock.CEILING_PRICE
                     or   FLOORPRICE<> vc_stock.FLOOR_PRICE
                     or   BASICPRICE<> vc_stock.BASIC_PRICE
                     or  current_room<>vc_stock.current_room)
                     ;
          UPDATE SBSECURITIES SET HALT =  vc_stock.HALT_SUSP WHERE TRIM(SYMBOL)=TRIM(vc_stock.SYMBOL);
          Commit;
         End Loop;
    End;

  Procedure Prc_ProcessMsg
    is
    v_OrderID varchar2(20);
    v_Orgorderid varchar2(20);
    v_err  varchar2(150);
    v_strContraOrderId varchar2(30);
    v_strContraBorS varchar2(30);
    v_CICI_ORDER varchar2(30);
    v_Check number(1);

    v_exp  Exception;
   Cursor c_Exec_Upcom_8 is Select *  from Exec_Upcom_8 where Process  ='N'
          AND ROWNUM BETWEEN 0 AND (SELECT SYSVALUE FROM ORDERSYS_upcom WHERE SYSNAME='UPCOMRECEIVESIZE')
          Order by Decode(EXECTYPE,'0',1,'5',2,'4',3) ,decode(ORDSTATUS,'0',1,'A',2,'D',2,'3',3);
    --Thu tu uu tien xu ly lenh: Lenh vao queue, vao core, lenh sua thanh cong, lenh huy thanh cong, lenh khop.

   v_Exec_Upcom_8  c_Exec_Upcom_8%rowtype;

   Cursor c_Ordermap_upcom(v_ORDER_NUMBER varchar2) Is
          SELECT * FROM ORDERMAP_UPCOM WHERE NVL(ORDER_NUMBER,'0') = v_ORDER_NUMBER;
   v_Ordermap_Upcom c_Ordermap_Upcom%Rowtype;

   Cursor c_Onefirm(v_OrgOrderid varchar2)  is
   SELECT OD.ORDERID,od.CONTRAFIRM,OD.TRADERID,OD.CLIENTID,OOD.CUSTODYCD,OOD.BORS, OOD.QTTY QTTY, OOD.PRICE PRICE
            FROM ORDERMAP_UPCOM MAP,ODMAST OD,OOD
            WHERE OOD.ORGORDERID=OD.ORDERID AND MAP.ORGORDERID=OD.orderid
            AND ORDERID= v_OrgOrderid;

   v_Onefirm c_Onefirm%Rowtype;

   Begin

  -- If to_char(sysdate,'hh24miss') < '082500' or to_char(sysdate,'hh24miss') >  '112500' Then
   --     Return;
   --End if;

    For i in c_Exec_Upcom_8
    Loop
       BEGIN
       v_err:='Process c_Exec_Upcom_8 = CLORDID '||i.ORDERID|| ' EXECTYPE '||i.EXECTYPE ||' ORDSTATUS '||i.ORDSTATUS;

       If i.ExecType = '0' And i.OrdStatus = '0' Then
       --Lenh vao Queue:
           UPDATE Ordermap_upcom SET ORDER_NUMBER = i.OrderID
           Where Trim(Ctci_Order) = Trim(i.ClOrdID);
       Elsif i.ExecType = '0' And i.OrdStatus = 'A' Then
        v_err:='Process c_Exec_Upcom_8 = 0 A i.OrderID '||i.OrderID;
       --Lenh da vao Core
             --+ Kiem tra lenh vao Queue chua
             Open c_Ordermap_upcom(i.OrderID);
             Fetch c_Ordermap_upcom into v_Ordermap_upcom;

             If c_Ordermap_upcom%found then --Lenh da vao queue
                --v_err:=v_err || 'here';
                UPDATE OOD SET OODSTATUS = 'S', TXTIME = TO_CHAR(SYSDATE,'HH24:MI:SS')
                WHERE ORGORDERID =v_Ordermap_upcom.Orgorderid;

                UPDATE ODMAST SET ORSTATUS = '2', PORSTATUS =PORSTATUS||2
                WHERE ORDERID = v_Ordermap_upcom.Orgorderid AND ORSTATUS = '8';

             Else
                        Close c_Ordermap_upcom;
                        v_err :='Chua tim thay lenh vao QUEUE:'||i.OrderID;
                        Raise v_exp;
             End if;
             Close c_Ordermap_upcom;


       Elsif i.ExecType = '3' And i.OrdStatus = '2' Then
       --Lenh khop
         --1.1 Lenh khop thoa thuan
         If i.Side = '8' Then
            Begin
                Select ORGORDERID Into v_OrderID  from ORDERMAP_upcom
                WHERE ORDER_NUMBER=trim(i.OrderID);
            Exception when others then
            v_err:='Khong tim thay ORDERMAP_upcom v_OrderID ='||v_OrderID;
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
            WHERE ORGORDERID =v_Ordermap_upcom.Orgorderid;

            UPDATE ODMAST SET ORSTATUS = '2', PORSTATUS =PORSTATUS||2
            WHERE ORDERID = v_Ordermap_upcom.Orgorderid AND ORSTATUS = '8';

            -- Khop lenh cung cong ty
            If  Trim(v_Onefirm.CLIENTID) is not null And Trim(v_Onefirm.CUSTODYCD) is not null
                        And Substr(v_Onefirm.CLIENTID,1, 3) =Substr(v_Onefirm.CUSTODYCD,1,3) Then
                  --Khop ban
                  matching_normal_order('', i.OrigClOrdID, '', v_Onefirm.BorS, '', v_Onefirm.QTTY, v_Onefirm.PRICE, i.OrderID);
                  --Khop voi lenh doi ung
                  --Dung cac tieu chi Custodycode, Quantity, Price, Buy/Sell de map tim lenh doi ung roi khop

                 Begin
                   Select orgorderid, bors into v_strContraOrderId , v_strContraBorS
                   From ood
                   Where ood.custodycd= v_Onefirm.CLIENTID
                   and ood.bors <> v_Onefirm.BorS and ood.QTTY=v_Onefirm.QTTY
                   And ood.PRICE =v_Onefirm.PRICE;

                Exception when others then
                  v_err :='Process Exec 8 Khong tim thay lenh doi ung v_Onefirm.CLIENTID'||
                    v_Onefirm.CLIENTID||' v_Onefirm.BorS = '||
                    v_Onefirm.BorS ||' v_Onefirm.QTTY ='||v_Onefirm.QTTY ||' v_Onefirm.PRICE = '||v_Onefirm.PRICE;
                  Raise v_exp;
                 End;

                 Select SEQ_ORDERMAP.NEXTVAL Into v_CICI_ORDER from dual;
                 --Dua vao Ordermap_upcom de khop lenh tuong tu nhu lenh binh thuong:

                 INSERT INTO ORDERMAP_upcom(ctci_order,orgorderid,order_number)
                 VALUES (v_CICI_ORDER ,v_strContraOrderId,v_CICI_ORDER);

                 Matching_normal_order('',v_CICI_ORDER, '', v_strContraBORS, '', v_Onefirm.QTTY, v_Onefirm.PRICE, i.OrderID);

            Else
                 --Khop khac cong ty
                 Matching_normal_order('', i.OrigClOrdID, '', v_Onefirm.BorS, '', v_Onefirm.QTTY, v_Onefirm.PRICE, i.OrderID);

            End if;


         Else
         --1.2 Lenh khop thuong
            --1.2.1 Lenh ban da co trong  Queue

             INSERT INTO log_err
                              (id,date_log, POSITION, text
                              )
                       VALUES ( seq_log_err.NEXTVAL,SYSDATE, 'Lenh khop thuong Process Exec_Upcom_8 ',
                       'i.OrigClOrdID ='||i.OrigClOrdID ||' i.SecondaryClOrdID = '||i.SecondaryClOrdID
                       ||' i.OrderID ='||i.OrderID ||' V_ID '||I.id
                              );

             COMMIT;

             v_Check:=0;
             Open c_Ordermap_upcom(i.OrigClOrdID);
             Fetch c_Ordermap_upcom into v_Ordermap_upcom;
             If c_Ordermap_upcom%Found then
               v_Check:=1;
               UPDATE OOD SET OODSTATUS = 'S',
                               TXTIME = TO_CHAR(SYSDATE,'HH24:MI:SS')
                               WHERE
                               OODSTATUS <> 'S'
                               AND ORGORDERID = v_Ordermap_upcom.Orgorderid;
               Matching_normal_order('', i.OrigClOrdID, '', 'S', '', i.LASTQTY, i.LASTPX, i.OrderID);


             End if;
             Close c_Ordermap_upcom;

             --1.2.2 Lenh mua da co trong  Queue

             Open c_Ordermap_upcom(i.SecondaryClOrdID);
             Fetch c_Ordermap_upcom into v_Ordermap_upcom;
             If c_Ordermap_upcom%Found then
                v_Check:=1;
                UPDATE OOD SET OODSTATUS = 'S',
                               TXTIME = TO_CHAR(SYSDATE,'HH24:MI:SS')
                               WHERE
                               OODSTATUS <> 'S'
                               AND ORGORDERID = v_Ordermap_upcom.Orgorderid;
                Matching_normal_order('', i.SecondaryClOrdID, '', 'B', '',  i.LASTQTY, i.LASTPX, i.OrderID);


             End if;
            Close c_Ordermap_upcom;

            if v_Check =0 then
               v_err :='Process Exec 8 Khop lenh, khong tim thay lenh goc: i.OrigClOrdID='||i.OrigClOrdID ||'  i.SecondaryClOrdID ='||i.SecondaryClOrdID;
            Raise v_Exp;

           End if;

         End if;

      Elsif i.ExecType = '4' And i.OrdStatus = 'D' Then
            --Lenh sua dong y
            --Lenh huy da vao he thong: Khong xu ly gi, chi xu ly khi huy thanh cong

             Update ood set OODSTATUS ='S'
             where Reforderid in(select orgorderid from ordermap_upcom
                                 where order_number =i.OrigClOrdID);

      Elsif i.ExecType = '4' And i.OrdStatus ='0' Then
      --Lenh sua vao Queue
        Null;
      Elsif i.ExecType = '4' And i.OrdStatus ='3' Then --Huy lenh thuong thanh cong

            If i.Side <> '8' Then

                    Open c_Ordermap_upcom(i.OrigClOrdID);
                    Fetch c_Ordermap_upcom into v_Ordermap_upcom;
                    If c_Ordermap_upcom%Found then
                       CONFIRM_CANCEL_NORMAL_ORDER(v_Ordermap_upcom.Orgorderid,i.LeavesQty);
                   Else
                        Close c_Ordermap_upcom;
                        v_err :='Khong tim thay lenh goc cua lenh huy:'||i.OrigClOrdID;
                        Raise v_exp;

                    End if;
                    Close c_Ordermap_upcom;



             Else --Huy lenh thoa thuan: chi ghi nhan, ko xu ly gi
                INSERT INTO UpComptcancelled(securitysymbol, confirmnumber,status, volume, price)
                                  VALUES (i.Symbol ,i.OrderID  , 'H',i.LeavesQty,i.Price);
                --Lay so hieu lenh goc:
                Begin
                   Select Orgorderid into v_Orgorderid from Ordermap_upcom where trim(Order_number) =trim(i.Orderid);
                   --Update lenh ve trang thai Delete

                   Update odmast set deltd ='Y', CANCELQTTY =ORDERQTTY,REMAINQTTY=0,EXECQTTY =0 ,MATCHAMT =0,Execamt =0 where orderid = v_Orgorderid;
                   Update ood set  deltd ='Y' where orgorderid = v_Orgorderid;
                   Update iod set deltd ='Y' where Orgorderid = v_Orgorderid;

                   --Tim trong IOD so hieu lenh khop la i.Orderid de xoa lenh khop doi ung cung cong ty
                   Begin
                       Select orgorderid into v_Orgorderid from IOD where trim(confirm_no) =trim(i.Orderid) and Deltd <>'Y';
                       Update odmast set deltd ='Y', CANCELQTTY =ORDERQTTY,REMAINQTTY=0 ,EXECQTTY =0,MATCHAMT =0,Execamt =0
                       where orderid = v_Orgorderid;
                       Update ood set  deltd ='Y' where orgorderid = v_Orgorderid;
                       Update iod set deltd ='Y' where Orgorderid = v_Orgorderid;
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
                    Open c_Ordermap_upcom(i.OrigClOrdID);
                    Fetch c_Ordermap_upcom into v_Ordermap_upcom;
                    If c_Ordermap_upcom%Found then

                       CONFIRM_REPLACE_NORMAL_ORDER(i.OrigClOrdID,i.LastQty,i.LastPx);

                    Else
                        Close c_Ordermap_upcom;
                        v_err :='Khong tim thay lenh goc cua lenh sua:'||i.OrigClOrdID;
                        Raise v_exp;

                    End if;
                    Close c_Ordermap_upcom;

       End if;


       Update  Exec_Upcom_8 set Process ='Y' where id =i.ID;
       Commit;





       EXCEPTION WHEN v_exp then
            Rollback;

            INSERT INTO log_err
                      (id,date_log, POSITION, text
                      )
               VALUES ( seq_log_err.NEXTVAL,SYSDATE, ' Process Exec_Upcom_8 v_exp', v_err
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
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, ' Process Exec_Upcom_8 ', v_err
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

    v_exp  Exception;
   Cursor c_Exec_Upcom_8_1 is Select *  from Exec_Upcom_8
        where Process  ='Y'and  EXECTYPE ='3' and ORDSTATUS ='2'
        and ORIGCLORDID in
        (select order_number from ordermap_upcom)
        And not exists (select 1 from iod where bors ='S' and Exec_Upcom_8.ORDERID=iod.confirm_no);

   v_Exec_Upcom_8  c_Exec_Upcom_8_1%rowtype;

    Cursor c_Exec_Upcom_8_2 is  Select *  from Exec_Upcom_8
        where Process  ='Y'and  EXECTYPE ='3' and ORDSTATUS ='2'
        and SECONDARYCLORDID in
        (select order_number from ordermap_upcom)
        And not exists (select 1 from iod where bors ='B' and Exec_Upcom_8.ORDERID=iod.confirm_no);


   Cursor c_Ordermap_upcom(v_ORDER_NUMBER varchar2) Is
          SELECT * FROM ORDERMAP_upcom WHERE NVL(ORDER_NUMBER,'0') = v_ORDER_NUMBER;
   v_Ordermap_upcom c_Ordermap_upcom%Rowtype;


   Begin

 --  If to_char(sysdate,'hh24miss') < '082500' or to_char(sysdate,'hh24miss') >  '112500' Then
   --     Return;
  -- End if;

   For i in (select * from Exec_Upcom_8
    where clordid is not null
    and EXECTYPE ='0'
    and ORDSTATUS ='0'
    and process ='Y'
    and CLORDID in (select ctci_order from ordermap_upcom where order_number is null)
    )
    Loop
      Update ordermap_upcom set order_number =i.ORDERID where CTCI_ORDER =i.clordid;
      commit;
    End loop;


    For i in c_Exec_Upcom_8_1
    Loop
    --1.2 Lenh khop thuong
      --1.2.1 Lenh ban da co trong  Queue

         INSERT INTO log_err
                          (id,date_log, POSITION, text
                          )
                   VALUES ( seq_log_err.NEXTVAL,SYSDATE, 'Lenh khop thuong Process Exec_Upcom_8 ',
                   'i.OrigClOrdID ='||i.OrigClOrdID
                   ||' i.OrderID ='||i.OrderID ||' V_ID '||I.id
                          );

         COMMIT;

         Open c_Ordermap_upcom(i.OrigClOrdID);
         Fetch c_Ordermap_upcom into v_Ordermap_upcom;
         If c_Ordermap_upcom%Found then
           v_Check:=1;
           UPDATE OOD SET OODSTATUS = 'S',
                           TXTIME = TO_CHAR(SYSDATE,'HH24:MI:SS')
                           WHERE
                           OODSTATUS <> 'S'
                           AND ORGORDERID = v_Ordermap_upcom.Orgorderid;
           Matching_normal_order('', i.OrigClOrdID, '', 'S', '', i.LASTQTY, i.LASTPX, i.OrderID);


         End if;
         Close c_Ordermap_upcom;

    End loop;

    For i in c_Exec_Upcom_8_2
    Loop
    --1.2 Lenh khop thuong
      --1.2.1 Lenh ban da co trong  Queue

         INSERT INTO log_err
                          (id,date_log, POSITION, text
                          )
                   VALUES ( seq_log_err.NEXTVAL,SYSDATE, 'Lenh khop thuong Process_e_2 Exec_Upcom_8 ',
                   ' i.SecondaryClOrdID = '||i.SecondaryClOrdID
                   ||' i.OrderID ='||i.OrderID ||' V_ID '||I.id
                          );

         COMMIT;

             --1.2.2 Lenh mua da co trong  Queue

             Open c_Ordermap_upcom(i.SecondaryClOrdID);
             Fetch c_Ordermap_upcom into v_Ordermap_upcom;
             If c_Ordermap_upcom%Found then
                v_Check:=1;
                UPDATE OOD SET OODSTATUS = 'S',
                               TXTIME = TO_CHAR(SYSDATE,'HH24:MI:SS')
                               WHERE
                               OODSTATUS <> 'S'
                               AND ORGORDERID = v_Ordermap_upcom.Orgorderid;
                Matching_normal_order('', i.SecondaryClOrdID, '', 'B', '',  i.LASTQTY, i.LASTPX, i.OrderID);


             End if;

            Close c_Ordermap_upcom;

        End loop;

 EXCEPTION
   WHEN  Others

   THEN
   v_err :=v_err||'  ' ||sqlerrm;
      INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, ' Process Exec_Upcom_8_e ', v_err
                  );

      COMMIT;
   End;

   FUNCTION fnc_check_sec_upcom
          ( v_Symbol IN varchar2)
         RETURN  number IS

        Cursor c_SecInfo(vc_Symbol varchar2) is
            Select 1 from UpcomSecurity_Req where
            Trim(symbol) =Trim(vc_Symbol);
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
    SELECT MSGTYPE,ID, REPLACE(MSGXML,'&',' ') MSGXML, PROCESS FROM MSGRECEIVETEMP_UPCOM WHERE PROCESS ='N'
    AND ROWNUM BETWEEN 0 AND (SELECT SYSVALUE FROM ORDERSYS_UPCOM WHERE SYSNAME='UPCOMRECEIVESIZE');
    V_MSG_RECEIVE C_MSG_RECEIVE%ROWTYPE;
  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_PROCESS');
      OPEN C_MSG_RECEIVE;
      LOOP
          FETCH C_MSG_RECEIVE INTO V_MSG_RECEIVE;
          EXIT WHEN C_MSG_RECEIVE%NOTFOUND;
          plog.debug(pkgctx,'Process message ID = '||V_MSG_RECEIVE.ID);
          IF V_MSG_RECEIVE.MSGTYPE ='8' THEN
            PRC_PROCESS8(V_MSG_RECEIVE.MSGXML,V_MSG_RECEIVE.ID);
          /*
          ELSIF V_MSG_RECEIVE.MSGTYPE ='7' THEN
            PRC_PROCESS7(V_MSG_RECEIVE.MSGXML,V_MSG_RECEIVE.ID);
          */
          ELSIF V_MSG_RECEIVE.MSGTYPE ='f' THEN
            PRC_PROCESSf(V_MSG_RECEIVE.MSGXML,V_MSG_RECEIVE.ID);
          ELSIF V_MSG_RECEIVE.MSGTYPE ='h' THEN
            PRC_PROCESSh(V_MSG_RECEIVE.MSGXML,V_MSG_RECEIVE.ID);
          ELSIF V_MSG_RECEIVE.MSGTYPE ='s' THEN
            PRC_PROCESSs(V_MSG_RECEIVE.MSGXML,V_MSG_RECEIVE.ID);
          ELSIF V_MSG_RECEIVE.MSGTYPE ='u' THEN
            PRC_PROCESSu(V_MSG_RECEIVE.MSGXML,V_MSG_RECEIVE.ID);
          ELSIF V_MSG_RECEIVE.MSGTYPE ='t' THEN
            -- Nhan 1 lenh sua thoa thuan vao he thong
            PRC_PROCESSt(V_MSG_RECEIVE.MSGXML,V_MSG_RECEIVE.ID);
          END IF;
          UPDATE MSGRECEIVETEMP_upcom SET PROCESS ='Y' WHERE ID =V_MSG_RECEIVE.ID;
          COMMIT;
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
      End if;
    END LOOP;

    plog.debug(pkgctx,'msg s l_txmsg.CrossID: '||l_txmsg.CrossID
             ||' l_txmsg.CrossType ='|| l_txmsg.CrossType
             ||' l_txmsg.Price ='|| l_txmsg.Price
             ||' l_txmsg.SellOrderQty ='|| l_txmsg.SellOrderQty
             ||' l_txmsg.BuyPartyID ='|| l_txmsg.BuyPartyID
             ||' l_txmsg.SellPartyID ='|| l_txmsg.SellPartyID);
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



  FUNCTION fn_xml2obj_t(p_xmlmsg    VARCHAR2) RETURN tx.msg_t IS
    l_parser   xmlparser.parser;
    l_doc      xmldom.domdocument;
    l_nodeList xmldom.domnodelist;
    l_node     xmldom.domnode;
    n     xmldom.domnode;

    l_fldname fldmaster.fldname%TYPE;
    l_txmsg   tx.msg_t;
    v_Key Varchar2(100);
    v_Value Varchar2(100);


  BEGIN
    plog.setbeginsection (pkgctx, 'fn_xml2obj_t');

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
      End if;
    END LOOP;

    plog.debug(pkgctx,'msg s l_txmsg.CrossID: '||l_txmsg.CrossID
             ||' l_txmsg.CrossType ='|| l_txmsg.CrossType
             ||' l_txmsg.Price ='|| l_txmsg.Price
             ||' l_txmsg.SellOrderQty ='|| l_txmsg.SellOrderQty
             ||' l_txmsg.BuyPartyID ='|| l_txmsg.BuyPartyID
             ||' l_txmsg.SellPartyID ='|| l_txmsg.SellPartyID);
    plog.debug(pkgctx,'Free resources associated');

    -- Free any resources associated with the document now it
    -- is no longer needed.
    DBMS_XMLDOM.freedocument(l_doc);
    -- Only used if variant is CLOB
    -- dbms_lob.freetemporary(p_xmlmsg);

    plog.setendsection(pkgctx, 'fn_xml2obj_t');
    RETURN l_txmsg;
  EXCEPTION
    WHEN OTHERS THEN
      --dbms_lob.freetemporary(p_xmlmsg);
      DBMS_XMLPARSER.freeparser(l_parser);
      DBMS_XMLDOM.freedocument(l_doc);
      plog.error(pkgctx, SQLERRM);
      plog.setendsection(pkgctx, 'fn_xml2obj_t');
      RAISE errnums.E_SYSTEM_ERROR;
  END fn_xml2obj_t;




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

    --Neu msg vao Queue thi map luon voi lenh goc, de ko phai xu ly bang tien trinh sau.
    If V_TX8.ExecType = '0' And V_TX8.OrdStatus = '0' Then
        --Lenh vao Queue:
        UPDATE Ordermap_Upcom SET ORDER_NUMBER = V_TX8.OrderID
        Where Trim(Ctci_Order) = Trim(V_TX8.ClOrdID);
        v_Process:='Y';

    Else
        v_Process:='N';
    End if;

      --XU LY MESSAGE 8.
    INSERT INTO EXEC_UPCOM_8(clordid, transacttime, exectype, orderqty, orderid, side,
                       symbol, price, ACCOUNT, ordstatus, origclordid,
                       secondaryclordid, lastqty, lastpx, execid, leavesqty,receivetime,id,process)
         VALUES ( V_TX8.ClOrdID , V_TX8.TransactTime , V_TX8.ExecType , V_TX8.OrderQty , V_TX8.OrderID , V_TX8.Side,
                  V_TX8.Symbol , V_TX8.Price , V_TX8.Account , V_TX8.OrdStatus ,V_TX8.OrigClOrdID ,
                  V_TX8.SecondaryClOrdID, V_TX8.LastQty , V_TX8.LastPx , V_TX8.ExecID ,V_TX8.LeavesQty ,sysdate,v_ID,v_Process);

    plog.setendsection (pkgctx, 'PRC_PROCESS8');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_PROCESS8');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_PROCESS8;


  /*
  -- Upcom khong co lenh quang cao --> Khong su dung ham nay
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

     Else --If v_CTCI_7.AdvTransType = "C" Then
      -- Lenh huy quang cao duoc HNX forward

        UPDATE haput_ad
           SET advtranstype = v_tx7.advtranstype
         WHERE advid = v_tx7.advid;
     End If;

    plog.setendsection (pkgctx, 'PRC_PROCESS7');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_PROCESS7');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_PROCESS7;

*/

  --Xu ly Message s
  Procedure PRC_PROCESSs(V_MSGXML VARCHAR2, v_ID Varchar2) is
    V_TXs   tx.msg_s;
    V_ORGORDERID VARCHAR2(20);
    v_Firm  VARCHAR2(20);
    v_Side  VARCHAR2(20);
  BEGIN
    plog.setbeginsection (pkgctx, 'PRC_PROCESSs');

    V_TXs:=fn_xml2obj_s(V_MSGXML);

    --XU LY MESSAGE s.
    Begin
        Select SYSVALUE Into v_Firm from ordersys_upcom where SYSNAME ='FIRM';
    Exception When others then
        plog.debug(pkgctx, 'Chua khai bao ma cty trong Ordersys_upcom');
        v_Firm:='0';
    End;

    If v_Firm = V_TXs.BuyPartyID Then
        v_Side := 'B';
    Else
        v_Side := 'S';
    End If;

    --Nhan message chao ban thoa thuan

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
    plog.setendsection (pkgctx, 'PRC_PROCESSs');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_PROCESSs;


  --Xu ly Message t -- Nhan 1 lenh sua thoa thuan vao he thong
  Procedure PRC_PROCESSt(V_MSGXML VARCHAR2, v_ID Varchar2) is
    V_TXt   tx.msg_t;
    V_ORGORDERID VARCHAR2(20);
    v_Firm  VARCHAR2(20);
    v_Side  VARCHAR2(20);
  BEGIN
    plog.setbeginsection (pkgctx, 'PRC_PROCESSt');

    V_TXt:=fn_xml2obj_t(V_MSGXML);

    --XU LY MESSAGE t.
    Begin
        Select SYSVALUE Into v_Firm from ordersys_upcom where SYSNAME ='FIRM';
    Exception When others then
        plog.debug(pkgctx, 'Chua khai bao ma cty trong Ordersys_upcom');
        v_Firm:='0';
    End;

    If v_Firm = V_TXt.BuyPartyID Then
        v_Side := 'B';
    Else
        v_Side := 'S';
    End If;

    --Nhan message sua  thoa thuan

    INSERT INTO orderptadmend
            (TIMESTAMP, messagetype, firm, buyertradeid,
             side, sellercontrafirm, sellertradeid, securitysymbol, volume,
             price, board, confirmnumber, offset, status, issend,
             ordernumber, brid, tlid,
             txtime, ipaddress, trading_date,
             sclientid,ORIGCROSSID
            )
     VALUES (TO_CHAR (SYSDATE, 'HH24MISS'), 't', v_txt.buypartyid, '',
             v_side, v_txt.sellpartyid, '', v_txt.symbol, v_txt.sellorderqty,
             v_txt.price, '', v_txt.crossid, '', 'N', 'N',
             '' , '', ''
             , TO_CHAR (SYSDATE, 'hh24miss'), '', TRUNC (SYSDATE),
             v_txt.sellaccount,
             v_txt.OrigCrossID
            );


    plog.setendsection (pkgctx, 'PRC_PROCESSt');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_PROCESSt');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_PROCESSt;



--Xu ly Message f
  Procedure PRC_PROCESSf(V_MSGXML VARCHAR2, v_ID Varchar2) is
    V_TXf   tx.msg_f;
    V_ORGORDERID VARCHAR2(20);
    v_Count Number(10);
  BEGIN
    plog.setbeginsection (pkgctx, 'PRC_PROCESSf');

    V_TXf:=fn_xml2obj_f(V_MSGXML);

    --XU LY MESSAGE f.

    Select count(*) Into v_Count
    From UpcomSecurity_Req
    Where Symbol = V_TXf.Symbol;

    If v_Count >0 Then

        UPDATE UpcomSecurity_Req
           SET securitystatusreqid = v_txf.securitystatusreqid,
               highpx = v_txf.highpx,
               lowpx = v_txf.lowpx,
               securitytradingstatus = v_txf.securitytradingstatus,
               buyvolume = v_txf.buyvolume,
               securitytype = v_txf.securitytype,
               lastpx = v_txf.lastpx,
               text =
                     ' Update securities_info set  ceilingprice = '
                  || v_txf.highpx
                  || ' , floorprice = '
                  || v_txf.lowpx
                  || ' Where symbol = '''
                  || v_txf.symbol
                  || ''';'
         WHERE symbol = v_txf.symbol;

    Else

        INSERT INTO UpcomSecurity_Req
                    (securitystatusreqid, symbol, highpx,
                     lowpx, securitytradingstatus, buyvolume,
                     securitytype, lastpx,
                     text
                    )
             VALUES (v_txf.securitystatusreqid, v_txf.symbol, v_txf.highpx,
                     v_txf.lowpx, v_txf.securitytradingstatus, v_txf.buyvolume,
                     v_txf.securitytype, v_txf.lastpx,
                        'Update securities_info set  ceilingprice = '
                     || v_txf.highpx
                     || ' , floorprice = '
                     || v_txf.lowpx
                     || ' where symbol = '''
                     || v_txf.symbol
                     || ''';'
                    );

    End if;

    update securities_info
    set CEILINGPRICE= v_txf.HIGHPX,
                FLOORPRICE= v_txf.LOWPX,
                MARGINPRICE = v_txf.LOWPX,
                current_room=v_txf.BUYVOLUME,
                BASICPRICE=v_txf.LASTPX
    where symbol=v_txf.symbol;

    if v_txf.SECURITYTRADINGSTATUS in ('17','24','25','26') then
      UPDATE SBSECURITIES SET HALT =  'N' WHERE SYMBOL=v_txf.symbol;
    else
     UPDATE SBSECURITIES SET HALT =  'Y' WHERE SYMBOL=v_txf.symbol;
    end if;
    plog.setendsection (pkgctx, 'PRC_PROCESSf');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_PROCESSf');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_PROCESSf;



  --Xu ly Message h
  Procedure PRC_PROCESSh(V_MSGXML VARCHAR2, v_ID Varchar2) is
    V_TXh   tx.msg_h;
    V_ORGORDERID VARCHAR2(20);
  BEGIN
    plog.setbeginsection (pkgctx, 'PRC_PROCESSh');

    V_TXh:=fn_xml2obj_h(V_MSGXML);

      --XU LY MESSAGE h.
    UPDATE ORDERSYS_UPCOM SET SYSVALUE=V_TXh.TradSesStatus WHERE SYSNAME='CONTROLCODE';
    UPDATE ORDERSYS_UPCOM SET SYSVALUE= V_TXh.TradSesStartTime WHERE SYSNAME='TIMESTAMP';


    plog.setendsection (pkgctx, 'PRC_PROCESSh');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_PROCESSh');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_PROCESSh;

--- Thu tuc sua lenh thoa thuan
Procedure PRC_admendpt(v_orderid varchar2,v_qtty number,v_price number) is
  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_admendpt');
     INSERT INTO orderptadmend (timestamp, messagetype, firm, buyertradeid, side,
       sellercontrafirm, sellertradeid, securitysymbol, volume,
       price, board, confirmnumber, offset, status, issend,
       ordernumber, brid, tlid, txtime, ipaddress,
       trading_date, sclientid, origcrossid)
 SELECT TO_CHAR(SYSDATE,'HH24MISS'),'t',OD.CONTRAFIRM,od.traderid,IOD.BORS,
 SYS1.SYSVALUE FIRM, SYS2.SYSVALUE,IOD.SYMBOL,v_qtty volume,
 v_price price,'',IOD.CONFIRM_NO,'','A','N',
 OD.ORDERID,'','',TO_CHAR(SYSDATE,'HH24MISS'),'',
 IOD.TXDATE,IOD.CUSTODYCD,IOD.CONFIRM_NO
FROM IOD,ODMAST OD,ORDERSYS SYS1,ORDERSYS SYS2 WHERE SYS1.SYSNAME='FIRM'
 AND SYS2.SYSNAME='BROKERID' AND IOD.ORGORDERID=OD.ORDERID AND OD.ORDERID=v_orderid;
 commit;

      plog.setendsection (pkgctx, 'PRC_admendpt');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_admendpt');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_admendpt;
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
          FROM odmast o, ood od, ordermap_upcom op
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
            Exception when others then
                plog.debug(pkgctx,'PRC_PROCESSu Khong tim thay so hieu lenh: '||V_TXu.OrigCrossID);
            End;
        End If;
        --Day du lieu vao bang cancel:

        INSERT INTO cancelorderptack
                    (sorr, firm, contrafirm, tradeid,
                     TIMESTAMP, messagetype, securitysymbol, confirmnumber,
                     ordernumber, status, isconfirm, trading_date
                    )
             VALUES ('R', v_firm, v_contrafirm, v_bors,
                     TO_CHAR (SYSDATE, 'HH24MISS'), 'u', v_symbol, v_txu.origcrossid,
                     v_orgorderid, 'N', 'N', TRUNC (SYSDATE)
                    );

    End if;

    plog.setendsection (pkgctx, 'PRC_PROCESSu');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_PROCESSu');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_PROCESSu;

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

