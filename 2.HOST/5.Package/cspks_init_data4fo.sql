CREATE OR REPLACE PACKAGE cspks_init_data4fo AS

  /* TODO enter package declarations (types, exceptions, methods etc) here */
  PROCEDURE PRC_INIT_BASKETS (p_err_code IN OUT VARCHAR);

  PROCEDURE PRC_INIT_ACCOUNTS (p_err_code IN OUT VARCHAR);

  PROCEDURE PRC_INIT_PORTFOLIOS (p_err_code IN OUT VARCHAR);

  PROCEDURE PRC_INIT_POOLROOM (p_err_code IN OUT VARCHAR);

  PROCEDURE PRC_INIT_FOUSERS (p_err_code IN OUT VARCHAR);

  PROCEDURE PRC_INIT_PROFILES (p_err_code IN OUT VARCHAR);

  PROCEDURE PRC_INIT_CUSTOMERS (p_err_code IN OUT VARCHAR);

  PROCEDURE PRC_INIT_PRODUCTS (p_err_code IN OUT VARCHAR);

  PROCEDURE PRC_INIT_INSTRUMENTS (p_err_code IN OUT VARCHAR);

  PROCEDURE PRC_INIT_SYSCONFIG (p_err_code IN OUT VARCHAR);

  PROCEDURE PRC_WORKINGCALENDAR (p_err_code IN OUT VARCHAR);

  PROCEDURE PRC_INIT_OWNPOOLROOM (p_err_code IN OUT VARCHAR);

  PROCEDURE PRC_INIT_DEFRULES (p_err_code IN OUT VARCHAR);

  PROCEDURE PRC_MAIN (p_err_code IN OUT VARCHAR);


--  PROCEDURE PRC_INIT_DEFRULES (p_err_code IN OUT VARCHAR);
--
--  PROCEDURE PRC_INIT_TICKSIZE (p_err_code IN OUT VARCHAR);
  PROCEDURE prc_backup_advorder;
END cspks_init_data4fo;
/
CREATE OR REPLACE PACKAGE BODY cspks_init_data4fo
IS
  pkgctx plog.log_ctx;
  logrow tlogdebug%ROWTYPE;

  PROCEDURE PRC_INIT_BASKETS (p_err_code IN OUT VARCHAR)
  IS
      CURSOR c_baskets is SELECT * FROM t_fo_basket;
      v_count NUMBER;
  BEGIN
      p_err_code := '0';

       INSERT INTO BASKETS@DBL_FO(BASKETID,SYMBOL,RATE_BUY ,RATE_MARGIN ,PRICE_MARGIN,PRICE_ASSET ,RATE_ASSET)
       SELECT  BASKETID,SYMBOL,RATE_BUY ,RATE_MARGIN ,PRICE_MARGIN,PRICE_ASSET ,RATE_ASSET
       FROM   t_fo_basket;

--      COMMIT;
--      EXCEPTION
--        WHEN OTHERS THEN
--          p_err_code := '-1';
  END PRC_INIT_BASKETS;

  PROCEDURE PRC_INIT_ACCOUNTS (p_err_code IN OUT VARCHAR)
  IS
      CURSOR c_accounts is SELECT * FROM t_fo_account;
      v_count NUMBER;

  BEGIN
      p_err_code := '0';


      INSERT INTO ACCOUNTS@DBL_FO(ACCTNO, ACTYPE, CUSTODYCD, POLICYCD, GRNAME, ACCLASS, FORMULACD, BASKETID, STATUS, RATE_BRK_S, RATE_BRK_B,
      RATE_TAX, RATE_ADV, RATIO_INIT, RATIO_MAIN, RATIO_EXEC, TRFBUYEXT, TRFBUYAMT, BANKLINK, BANKACCTNO, BANKCODE, BOD_SEAMT,
      BOD_SEASS, BOD_ADV, BOD_DEBT, BOD_DEBT_M, BOD_TD, BOD_BALANCE, BOD_INTBAL, BOD_INTACR, BOD_PAYABLE, BOD_CRLIMIT, BOD_T0VALUE,
      BOD_RCASHT0, BOD_RCASHT1, BOD_RCASHT2, BOD_RCASHT3, BOD_RCASHTN, BOD_SCASHT0, BOD_SCASHT1, BOD_SCASHT2, BOD_SCASHT3, BOD_SCASHTN,
      CALC_RATIO, CALC_ADVBAL, CALC_PP0, CALC_ASSET, CALC_ODRAMT, CALC_TRFBUY, LASTCHANGE,POOLID,ROOMID,BOD_DEBT_T0,BOD_D_MARGIN,RATE_UB,
      BASKETID_UB, BOD_D_MARGIN_UB, RATE_T0LOAN, BOD_DEAL)
      SELECT ACCTNO, ACTYPE, CUSTODYCD, POLICYCD, GRNAME, ACCLASS, FORMULACD, BASKETID, STATUS, RATE_BRK_S, RATE_BRK_B,
      RATE_TAX, RATE_ADV, RATIO_INIT, RATIO_MAIN, RATIO_EXEC, TRFBUYEXT, TRFBUYAMT, BANKLINK, BANKACCTNO, BANKCODE, BOD_SEAMT,
      BOD_SEASS, BOD_ADV, BOD_DEBT, BOD_DEBT_M, BOD_TD, BOD_BALANCE, BOD_INTBAL, BOD_INTACR, BOD_PAYABLE, BOD_CRLIMIT, BOD_T0VALUE,
      BOD_RCASHT0, BOD_RCASHT1, BOD_RCASHT2, BOD_RCASHT3, BOD_RCASHTN, BOD_SCASHT0, BOD_SCASHT1, BOD_SCASHT2, BOD_SCASHT3, BOD_SCASHTN,
      CALC_RATIO, CALC_ADVBAL, CALC_PP0, CALC_ASSET, CALC_ODRAMT, CALC_TRFBUY, SYSDATE ,POOLID,ROOMID,BOD_DEBT_T0,BOD_D_MARGIN,RATE_UB,
      BASKETID_UB, BOD_D_MARGIN_UB, RATE_T0LOAN, BOD_DEAL
      FROM t_fo_account;



      --COMMIT;

--      EXCEPTION
--      WHEN OTHERS THEN
--        p_err_code := '-1';
    END PRC_INIT_ACCOUNTS;

  PROCEDURE PRC_INIT_PORTFOLIOS (p_err_code IN OUT VARCHAR)
  IS
      CURSOR c_portfolios is SELECT * FROM  t_fo_portfolios;
      v_count NUMBER;
  BEGIN
      p_err_code := '0';


      INSERT INTO PORTFOLIOS@DBL_FO(ACCTNO,SYMBOL,TRADE,MORTGAGE,RECEIVING,BUYINGQTTY,SELLINGQTTY,SELLINGQTTYMORT,ASSETQTTY,AVGPRICE,
      MARKED,MARKEDCOM,BOD_RT0,BOD_RT1,BOD_RT2,BOD_RT3,BOD_RTN,BOD_ST0,BOD_ST1,BOD_ST2,BOD_ST3,BOD_STN,LASTCHANGE,PITQTTY,TAXRATE) --1.8.2.5:them thue quyen dong bo len FO
      SELECT ACCTNO,SYMBOL,TRADE,MORTAGE,RECEIVING,BUYINGQTTY,SELLINGQTTY,SELLINGQTTYMORT,ASSETQTTY,AVGPRICE,
             MARKED,MARKEDCOM,RT0,RT1,RT2,RT3,RTN,ST0,ST1,ST2,ST3,STN,CURRENT_TIMESTAMP,PITQTTY,TAXRATE
      FROM   t_fo_portfolios;


      --COMMIT;

--      EXCEPTION
--        WHEN OTHERS THEN
--          p_err_code := '-1';
  END PRC_INIT_PORTFOLIOS;

  PROCEDURE PRC_INIT_POOLROOM (p_err_code IN OUT VARCHAR)
  IS
      CURSOR c_poolroom is SELECT * FROM t_fo_poolroom;
      v_count NUMBER;
      p_autoid NUMBER;
  BEGIN
      p_err_code := '0';

      INSERT INTO POOLROOM@DBL_FO(AUTOID, POLICYCD, POLICYTYPE, REFSYMBOL, GRANTED, INUSED)
      SELECT SEQ_POOLROOM.NEXTVAL@DBL_FO AUTOID, POLICYCD, POLICYTYPE, REFSYMBOL, GRANTED, INUSED
      FROM t_fo_poolroom;

--      COMMIT;
--      EXCEPTION
--        WHEN OTHERS THEN
--          p_err_code := '-1';
  END PRC_INIT_POOLROOM;

  PROCEDURE PRC_INIT_FOUSERS (p_err_code IN OUT VARCHAR)
  IS
      CURSOR c_fousers is SELECT * FROM t_fo_fousers;
  BEGIN
      p_err_code := '0';


    INSERT INTO FOUSERS@DBL_FO(AUTOID, TLID, USERNAME, AUTHTYPE, PWDLOGIN, PWDTRADE,USERTYPE)
    SELECT SEQ_FOUSERS.NEXTVAL@DBL_FO,TLID,USERNAME,AUTHTYPE,PWDLOGIN,PWDTRADE,TYPE
    FROM t_fo_fousers;


--      COMMIT;
--      EXCEPTION
--          WHEN OTHERS THEN
--            p_err_code := '-1';
  END PRC_INIT_FOUSERS;

  PROCEDURE PRC_INIT_PROFILES (p_err_code IN OUT VARCHAR)
  IS
      CURSOR c_profiles is SELECT * FROM t_fo_profiles;
  BEGIN

        p_err_code := '0';


      INSERT INTO PROFILES@DBL_FO(AUTOID, USERID, ACCTNO, ROLETYPE, AUTHSTR)
      SELECT SEQ_PROFILES.NEXTVAL@DBL_FO,USERID, ACCTNO,ROLETYPE,AUTHSTR FROM t_fo_profiles;

--        COMMIT;
--        EXCEPTION
--          WHEN OTHERS THEN
--            p_err_code := '-1';
  END PRC_INIT_PROFILES;

  PROCEDURE PRC_INIT_CUSTOMERS (p_err_code IN OUT VARCHAR)
  IS
      CURSOR c_customers is SELECT * FROM t_fo_customer;
      v_count NUMBER;
  BEGIN

      p_err_code := '0';


          INSERT INTO CUSTOMERS@DBL_FO(CUSTID, CUSTODYCD, FULLNAME,DOF)
          SELECT   CUSTID, CUSTODYCD, FULLNAME, DOF FROM t_fo_customer;

 --     COMMIT;

--      EXCEPTION
--        WHEN OTHERS THEN
--          p_err_code := '-1';
  END PRC_INIT_CUSTOMERS;

  PROCEDURE PRC_INIT_PRODUCTS (p_err_code IN OUT VARCHAR)
  IS
      CURSOR c_products is SELECT * FROM t_fo_products;
      v_count NUMBER;
  BEGIN

      p_err_code := '0';

      INSERT INTO PRODUCTS@DBL_FO(ACTYPE, ACNAME)
      SELECT ACTYPE, ACNAME from t_fo_products;


 --     COMMIT;

--      EXCEPTION
--        WHEN OTHERS THEN
--          p_err_code := '-1';
  END PRC_INIT_PRODUCTS;

  PROCEDURE PRC_INIT_INSTRUMENTS (p_err_code IN OUT VARCHAR)
  IS
      --CURSOR c_instruments is SELECT * FROM t_fo_instruments;
      v_count NUMBER;
  BEGIN

      p_err_code := '0';

      --FOR n IN c_instruments LOOP
      --  SELECT COUNT(1) INTO v_count FROM INSTRUMENTS@DBL_FO WHERE SYMBOL = n.SYMBOL;
      --  IF(v_count = 0) THEN
          INSERT INTO INSTRUMENTS@DBL_FO(SYMBOL,FULLNAME,CFICODE,EXCHANGE,BOARD,PRICE_CE,PRICE_FL,PRICE_RF,QTTYSUM,FQTTY,HALT,SYMBOLNUM,PRICE_NAV,QTTY_AVRTRADE,PARVALUE) --1.8.2.5: them menh gia
          SELECT SYMBOL, FULLNAME, CFICODE, EXCHANGE, BOARD, PRICE_CE, PRICE_FL, PRICE_RF, QTTYSUM, FQTTY, HALT, SYMBOLNUM, PRICE_NAV, QTTY_AVRTRADE,PARVALUE  from t_fo_instruments;
      --        COMMIT;
      --  ELSE
      --    p_err_code := '-1';
      --  END IF;
      --END LOOP;

 --     COMMIT;

--      EXCEPTION
--        WHEN OTHERS THEN
--          p_err_code := '-1';
  END PRC_INIT_INSTRUMENTS;

  PROCEDURE PRC_WORKINGCALENDAR (p_err_code IN OUT VARCHAR)
  IS
      CURSOR c_calendar is SELECT * FROM t_fo_workingcalendar;
      v_count NUMBER;
  BEGIN

      p_err_code := '0';
/*
      FOR n IN c_calendar LOOP
        SELECT COUNT(1) INTO v_count FROM WORKINGCALENDAR@DBL_FO WHERE TODAYDATE = n.TODAYDATE;
        IF(v_count = 0) THEN*/
          INSERT INTO WORKINGCALENDAR@DBL_FO(TODAYDATE,T1DATE,T2DATE,T3DATE)
          SELECT  TODAYDATE,  T1DATE, T2DATE, T3DATE from t_fo_workingcalendar ;
/*        ELSE
          p_err_code := '-1';
        END IF;
      END LOOP;*/

--      COMMIT;

  END PRC_WORKINGCALENDAR;


  PROCEDURE PRC_INIT_SYSCONFIG (p_err_code IN OUT VARCHAR)

  IS
       CURSOR c_sysconfig is SELECT * FROM t_fo_sysconfig;
       v_count NUMBER;
  BEGIN
      p_err_code := '0';

--      SELECT CFGVALUE INTO p_cfgvalue FROM t_fo_sysconfig;
--      UPDATE SYSCONFIG SET  CFGVALUE = p_cfgvalue WHERE  CFGKEY = 'TRADE_DATE';
      /*FOR n IN c_sysconfig LOOP
        SELECT COUNT(1) INTO v_count FROM SYSCONFIG@DBL_FO WHERE CFGKEY = n.CFGKEY;
        IF v_count = 0 THEN*/
          INSERT INTO SYSCONFIG@DBL_FO(CFGKEY,CFGVALUE,DESCRIPTIONS)
          SELECT CFGKEY,  CFGVALUE, DESCRIPTIONS FROM t_fo_sysconfig ;
/*        ELSE
          p_err_code := '-1';
        END IF;
      END LOOP;*/

      SELECT COUNT(1) INTO v_count FROM SYSCONFIG@DBL_FO WHERE CFGKEY = 'ISRESET';
      IF v_count = 0 THEN
          INSERT INTO SYSCONFIG@DBL_FO(CFGKEY,CFGVALUE) VALUES ('ISRESET','Y') ;
      END IF;
--      COMMIT;
--      EXCEPTION
--        WHEN OTHERS THEN
--          p_err_code := '-1';

      UPDATE MARKETINFO@DBL_FO SET SESSIONEX = 'BOPN' WHERE EXCHANGE = 'HSX';
      UPDATE MARKETINFO@DBL_FO SET SESSIONEX = 'BCNT' WHERE EXCHANGE IN ('HNX','UPCOM');

  END PRC_INIT_SYSCONFIG;

  PROCEDURE PRC_INIT_OWNPOOLROOM (p_err_code IN OUT VARCHAR)
  IS
      CURSOR c_ownpoolroom is SELECT * FROM t_fo_ownpoolroom;
      v_count NUMBER;

  BEGIN

      p_err_code := '0';
/*      FOR n IN c_ownpoolroom LOOP
        SELECT COUNT(1) INTO v_count FROM OWNPOOLROOM@DBL_FO WHERE PRID = n.PRID AND ACCTNO = n.ACCTNO AND REFSYMBOL = n.REFSYMBOL;
        IF(v_count = 0) THEN*/
          INSERT INTO OWNPOOLROOM@DBL_FO(PRID, ACCTNO, POLICYTYPE, REFSYMBOL, INUSED)
            SELECT  PRID, ACCTNO,  POLICYTYPE, REFSYMBOL, INUSED FROM t_fo_ownpoolroom ;
/*        ELSE
          p_err_code := '-1';
        END IF;
      END LOOP;*/

--      COMMIT;
--        EXCEPTION
--          WHEN OTHERS THEN
--            p_err_code := '-1';
  END PRC_INIT_OWNPOOLROOM;

  PROCEDURE PRC_INIT_DEFRULES (p_err_code IN OUT VARCHAR)
  IS
      v_count NUMBER;
      CURSOR c_defrules IS SELECT * FROM t_fo_defrules;
  BEGIN
      p_err_code := '0';

      FOR n IN c_defrules LOOP
         INSERT INTO DEFRULES@DBL_FO(AUTOID, REFTYPE, REFCODE, RULENAME, REFCVAL, REFNVAL)
            VALUES (SEQ_DEFRULES.NEXTVAL@DBL_FO,n.REFTYPE, n.REFCODE, n.RULENAME, n.REFCVAL, n.REFNVAL);
      END LOOP;

--      COMMIT;
--      EXCEPTION
--        WHEN OTHERS THEN
--          p_err_code := '-1';
  END PRC_INIT_DEFRULES;


  PROCEDURE PRC_MAIN (p_err_code IN OUT VARCHAR)
  IS
  BEGIN
    plog.setbeginsection(pkgctx, 'PRC_MAIN');
    p_err_code := '0';
    --Reset sequence

    Reset_sequence ('SEQ_FO_EXEC', 1);
    /*--Backup du lieu bang transaction
    CSPKS_END_OF_DATE.PRC_BACKUP_ALLOCATION@DBL_FO(p_err_code);
    plog.error(pkgctx, 'PRC_MAIN CSPKS_END_OF_DATE.PRC_BACKUP_ALLOCATION');
    COMMIT;
    CSPKS_END_OF_DATE.PRC_BACKUP_ORDERS@DBL_FO(p_err_code);
    plog.error(pkgctx, 'PRC_MAIN CSPKS_END_OF_DATE.PRC_BACKUP_ORDERS');
    COMMIT;
    CSPKS_END_OF_DATE.PRC_BACKUP_QUOTES@DBL_FO(p_err_code);
    plog.error(pkgctx, 'PRC_MAIN CSPKS_END_OF_DATE.PRC_BACKUP_QUOTES');
    COMMIT;
    CSPKS_END_OF_DATE.PRC_BACKUP_TRADES@DBL_FO(p_err_code);
    plog.error(pkgctx, 'PRC_MAIN CSPKS_END_OF_DATE.PRC_BACKUP_TRADES');
    COMMIT;
    CSPKS_END_OF_DATE.PRC_BACKUP_TRANSACTIONS@DBL_FO(p_err_code);
    plog.error(pkgctx, 'PRC_MAIN CSPKS_END_OF_DATE.PRC_BACKUP_TRANSACTIONS');
    COMMIT;*/
    plog.info(pkgctx, 'BACKUP Advanced Order');
    prc_backup_advorder;


    plog.info(pkgctx, 'BACKUP ORDERS');
    INSERT INTO ORDERS_B@DBL_FO(ORDERID,TXDATE,NORB,SESSIONEX,QUOTEID,CONFIRMID,USERID,CUSTODYCD,ACCTNO,ORIGINORDERID,
      SYMBOL,REFORDERID,SIDE,SUBSIDE,STATUS,SUBSTATUS,TIME_CREATED,TIME_SEND,TYPECD,SUBTYPECD,
      RATE_ADV,RATE_BRK,RATE_TAX,RATE_BUY,PRICE_MARGIN,PRICE_ASSET,QUOTE_PRICE,QUOTE_QTTY,EXEC_AMT,EXEC_QTTY,
      REMAIN_QTTY,CANCEL_QTTY,ADMEND_QTTY,MARKED,MORT_QTTY,ROOTORDERID,DEALID,FLAGORDER,PRIORITY,LASTCHANGE)
    SELECT ORDERID,TXDATE,NORB,SESSIONEX,QUOTEID,CONFIRMID,USERID,CUSTODYCD,ACCTNO,ORIGINORDERID,
      SYMBOL,REFORDERID,SIDE,SUBSIDE,STATUS,SUBSTATUS,TIME_CREATED,TIME_SEND,TYPECD,SUBTYPECD,
      RATE_ADV,RATE_BRK,RATE_TAX,RATE_BUY,PRICE_MARGIN,PRICE_ASSET,QUOTE_PRICE,QUOTE_QTTY,EXEC_AMT,EXEC_QTTY,
      REMAIN_QTTY,CANCEL_QTTY,ADMEND_QTTY,MARKED,MORT_QTTY,ROOTORDERID,DEALID,FLAGORDER,PRIORITY,LASTCHANGE
    FROM ORDERS@DBL_FO;

    DELETE FROM ORDERS@DBL_FO;

    plog.info(pkgctx, 'BACKUP QUOTE');

    INSERT INTO QUOTES_B@DBL_FO(QUOTEID,REQUESTID,CREATEDDT,EXPIREDDT,USERID,CLASSCD,SUBCLASS,VIA,STATUS,SUBSTATUS,
      TIME_QUOTE,TIME_SEND,TYPECD,SUBTYPECD,SIDE,REFQUOTEID,SYMBOL,QTTY,QTTY_BASED,QTTY_DELTA,
      QTTY_CANCEL,QTTY_ADMEND,DISTRIBUTECD,ACCTNO,PRICE,PRICE_RF,PRICE_CE,PRICE_FL,PRICE_DELTA,EXEC_QTTY,
      EXEC_AMT,LASTCHANGE)
    SELECT QUOTEID,REQUESTID,CREATEDDT,EXPIREDDT,USERID,CLASSCD,SUBCLASS,VIA,STATUS,SUBSTATUS,
      TIME_QUOTE,TIME_SEND,TYPECD,SUBTYPECD,SIDE,REFQUOTEID,SYMBOL,QTTY,QTTY_BASED,QTTY_DELTA,
      QTTY_CANCEL,QTTY_ADMEND,DISTRIBUTECD,ACCTNO,PRICE,PRICE_RF,PRICE_CE,PRICE_FL,PRICE_DELTA,EXEC_QTTY,
      EXEC_AMT,LASTCHANGE
    FROM QUOTES@DBL_FO where quoteid not in
    (   SELECT quoteid FROM CPO@dbl_fo
        UNION ALL
        SELECT quoteid FROM ICO@dbl_fo
        UNION ALL
        SELECT quoteid FROM MCO@dbl_fo
        UNION ALL
        SELECT quoteid FROM OCO@dbl_fo
        UNION ALL
        SELECT quoteid FROM OTO@dbl_fo
        UNION ALL
        SELECT quoteid FROM PCO@dbl_fo
        UNION ALL
        SELECT quoteid FROM SEO@dbl_fo
        UNION ALL
        SELECT quoteid FROM SO@dbl_fo
        UNION ALL
        SELECT quoteid FROM STO@dbl_fo
        UNION ALL
        SELECT quoteid FROM TSO@dbl_fo
     )
     ;
    DELETE FROM QUOTES@DBL_FO  where quoteid not in
     (   SELECT quoteid FROM CPO@dbl_fo
        UNION ALL
        SELECT quoteid FROM ICO@dbl_fo
        UNION ALL
        SELECT quoteid FROM MCO@dbl_fo
        UNION ALL
        SELECT quoteid FROM OCO@dbl_fo
        UNION ALL
        SELECT quoteid FROM OTO@dbl_fo
        UNION ALL
        SELECT quoteid FROM PCO@dbl_fo
        UNION ALL
        SELECT quoteid FROM SEO@dbl_fo
        UNION ALL
        SELECT quoteid FROM SO@dbl_fo
        UNION ALL
        SELECT quoteid FROM STO@dbl_fo
        UNION ALL
        SELECT quoteid FROM TSO@dbl_fo
     );
    plog.info(pkgctx, 'BACKUP TRADE');

    INSERT INTO TRADES_B@DBL_FO(TRADEID,ORDERID,PRICE,QTTY,TIME_EXEC,STATUS,LASTCHANGE,EXECID)
    SELECT TRADEID,ORDERID,PRICE,QTTY,TIME_EXEC,STATUS,LASTCHANGE,EXECID
    FROM TRADES@DBL_FO;
    DELETE FROM TRADES@DBL_FO;
    plog.info(pkgctx, 'BACKUP TRANSACTIONS');

    INSERT INTO TRANSACTIONS_B@DBL_FO(AUTOID,TXID,REFID,ACTION,CONTENT,TIME_CREATED,TIME_EXECUTED,STATUS,LASTCHANGE)
    SELECT AUTOID,TXID,REFID,ACTION,CONTENT,TIME_CREATED,TIME_EXECUTED,STATUS,LASTCHANGE
    FROM TRANSACTIONS@DBL_FO;
    DELETE FROM TRANSACTIONS@DBL_FO;

    plog.info(pkgctx, 'BACKUP ALLOCATION');
    INSERT INTO ALLOCATION_B@DBL_FO(AUTOID,ORDERID,SIDE,SYMBOL,ACCTNO,PRICE,QTTY,DOC,POLICYCD,POOLID,
              POOLVAL,ROOMID,ROOMVAL,STATUS,LASTCHANGE)
    SELECT AUTOID,ORDERID,SIDE,SYMBOL,ACCTNO,PRICE,QTTY,DOC,POLICYCD,POOLID,
              POOLVAL,ROOMID,ROOMVAL,STATUS,LASTCHANGE
    FROM ALLOCATION@DBL_FO;
    DELETE FROM ALLOCATION@DBL_FO;

    plog.info(pkgctx, 'BACKUP trading_exception');
    INSERT INTO trading_exception_b@DBL_FO(msgid,
                               msgseqnum,
                               ordstatus,
                               clordid,
                               origclordid,
                               secondaryclordid,
                               orderid,
                               transacttime,
                               lastqty,
                               lastpx,
                               execid,
                               side,
                               symbol,
                               contra_clordid,
                               create_time)
                         SELECT msgid,
                               msgseqnum,
                               ordstatus,
                               clordid,
                               origclordid,
                               secondaryclordid,
                               orderid,
                               transacttime,
                               lastqty,
                               lastpx,
                               execid,
                               side,
                               symbol,
                               contra_clordid,
                               create_time FROM trading_exception@DBL_FO;
      DELETE FROM trading_exception@DBL_FO;
      plog.info(pkgctx, 'BACKUP trading_exception');
      COMMIT;

      INSERT INTO trading_exception_log_b@DBL_FO (msgid,
                                   msgseqnum,
                                   ordstatus,
                                   clordid,
                                   origclordid,
                                   secondaryclordid,
                                   orderid,
                                   transacttime,
                                   lastqty,
                                   lastpx,
                                   execid,
                                   side,
                                   symbol,
                                   contra_clordid,
                                   create_time,
                                   err_code,
                                   status)
                            SELECT msgid,
                                   msgseqnum,
                                   ordstatus,
                                   clordid,
                                   origclordid,
                                   secondaryclordid,
                                   orderid,
                                   transacttime,
                                   lastqty,
                                   lastpx,
                                   execid,
                                   side,
                                   symbol,
                                   contra_clordid,
                                   create_time,
                                   err_code,
                                   status FROM trading_exception_log@DBL_FO;
      DELETE FROM trading_exception_log@DBL_FO;
      COMMIT;
      plog.info(pkgctx, 'BACKUP trading_exception_log');
      INSERT INTO gw_msg_logs_b@DBL_FO (autoid,
                         gw_date,
                         exchange,
                         xmlcontent)
      SELECT autoid,
                         gw_date,
                         exchange,
                         xmlcontent FROM gw_msg_logs@DBL_FO;
      plog.info(pkgctx, 'BACKUP gw_msg_logs');
      DELETE  gw_msg_logs@DBL_FO;
      COMMIT;

      INSERT INTO hft_msg_logs_b@DBL_FO (orderid,
                          exchange,
                          xmlcontent,
                          hft_date)
                  SELECT  orderid,
                          exchange,
                          xmlcontent,
                          hft_date
                  FROM   hft_msg_logs@DBL_FO;
      DELETE  hft_msg_logs@DBL_FO;
      COMMIT;
      plog.info(pkgctx, 'BACKUP hft_msg_logs');

      INSERT INTO crossinfo_b@DBL_FO (quoteid,
                                 crosstype,
                                 firm,
                                 traderid,
                                 acctno,
                                 custodycd,
                                 orderid,
                                 text)
        SELECT quoteid,
                crosstype,
                firm,
                traderid,
                acctno,
                custodycd,
                orderid,
                text FROM crossinfo@DBL_FO;
       DELETE FROM crossinfo@DBL_FO;
       COMMIT;
       plog.info(pkgctx, 'BACKUP crossinfo');
       INSERT INTO advorders_b@DBL_FO (orderid,
                                 reforderid,
                                 refquoteid,
                                 txdate,
                                 status,
                                 symbol,
                                 side,
                                 qtty,
                                 price,
                                 memberid,
                                 text,
                                 lastchange)
        SELECT  orderid,
                reforderid,
                refquoteid,
                txdate,
                status,
                symbol,
                side,
                qtty,
                price,
                memberid,
                text,
                lastchange FROM advorders@DBL_FO;
      DELETE FROM advorders@DBL_FO;
      COMMIT;
      plog.info(pkgctx, 'BACKUP advorders');
      INSERT INTO bankaccorders_b@DBL_FO (quoteid,
                             acctno,
                             amount,
                             status,
                             lastchange)
      SELECT quoteid,
            acctno,
            amount,
            status,
            lastchange FROM bankaccorders@DBL_FO;
      DELETE FROM bankaccorders@DBL_FO;

      COMMIT;
       plog.info(pkgctx, 'BACKUP bankaccorders');

      INSERT INTO msgerrors_b@DBL_FO (cfgkey,
                         cfgvalue,
                         status,
                         descriptions)
      SELECT cfgkey,
            cfgvalue,
            status,
            descriptions FROM msgerrors@DBL_FO;
      DELETE FROM   msgerrors@DBL_FO;
      COMMIT;

  plog.info(pkgctx, 'BACKUP msgerrors');
      INSERT INTO excerror_b@DBL_FO (autoid,
                        msgtype,
                        status,
                        rejcode,
                        content,
                        lastchange)
     SELECT autoid,
            msgtype,
            status,
            rejcode,
            content,
            lastchange FROM excerror@DBL_FO;
      DELETE FROM excerror@DBL_FO;
      COMMIT;

plog.info(pkgctx, 'BACKUP excerror');
      --delete table to init data
      DELETE FROM BASKETS@DBL_FO;
      DELETE FROM ACCOUNTS@DBL_FO;
      DELETE FROM PORTFOLIOS@DBL_FO;
      DELETE FROM PORTFOLIOSEX@DBL_FO;
      DELETE FROM POOLROOM@DBL_FO;
      DELETE FROM FOUSERS@DBL_FO;
      DELETE FROM PROFILES@DBL_FO;
      DELETE FROM CUSTOMERS@DBL_FO;
      DELETE FROM PRODUCTS@DBL_FO;
      DELETE FROM INSTRUMENTS@DBL_FO;
      DELETE FROM WORKINGCALENDAR@DBL_FO;
      DELETE FROM SYSCONFIG@DBL_FO;
      DELETE FROM OWNPOOLROOM@DBL_FO;
      DELETE FROM DEFRULES@DBL_FO;
      DELETE FROM EXCERROR@DBL_FO;
    COMMIT;
    PRC_INIT_BASKETS(p_err_code);
    plog.error(pkgctx, 'PRC_MAIN CSPKS_END_OF_DATE.PRC_INIT_BASKETS');
    COMMIT;

    PRC_INIT_ACCOUNTS(p_err_code);
    plog.error(pkgctx, 'PRC_MAIN CSPKS_END_OF_DATE.PRC_INIT_ACCOUNTS');
    COMMIT;
    PRC_INIT_PORTFOLIOS(p_err_code);
    plog.error(pkgctx, 'PRC_MAIN CSPKS_END_OF_DATE.PRC_INIT_PORTFOLIOS');
    COMMIT;
    PRC_INIT_POOLROOM(p_err_code);
    plog.error(pkgctx, 'PRC_MAIN CSPKS_END_OF_DATE.PRC_INIT_POOLROOM');
    COMMIT;
    PRC_INIT_FOUSERS(p_err_code);
    plog.error(pkgctx, 'PRC_MAIN CSPKS_END_OF_DATE.PRC_INIT_FOUSERS');
    COMMIT;
    PRC_INIT_PROFILES(p_err_code);
    plog.error(pkgctx, 'PRC_MAIN CSPKS_END_OF_DATE.PRC_INIT_PROFILES');
    COMMIT;
    PRC_INIT_CUSTOMERS(p_err_code);
    plog.error(pkgctx, 'PRC_MAIN CSPKS_END_OF_DATE.PRC_INIT_CUSTOMERS');
    COMMIT;
    PRC_INIT_PRODUCTS(p_err_code);
    plog.error(pkgctx, 'PRC_MAIN CSPKS_END_OF_DATE.PRC_INIT_PRODUCTS');
    COMMIT;
    PRC_INIT_INSTRUMENTS(p_err_code);
    plog.error(pkgctx, 'PRC_MAIN CSPKS_END_OF_DATE.PRC_INIT_INSTRUMENTS');
    COMMIT;
    PRC_WORKINGCALENDAR(p_err_code);
    plog.error(pkgctx, 'PRC_MAIN CSPKS_END_OF_DATE.PRC_WORKINGCALENDAR');
    COMMIT;
    PRC_INIT_SYSCONFIG(p_err_code);
    plog.error(pkgctx, 'PRC_MAIN CSPKS_END_OF_DATE.PRC_INIT_SYSCONFIG');
    COMMIT;
    PRC_INIT_OWNPOOLROOM(p_err_code);
    plog.error(pkgctx, 'PRC_MAIN CSPKS_END_OF_DATE.PRC_INIT_OWNPOOLROOM');
    COMMIT;
    PRC_INIT_DEFRULES(p_err_code);
    plog.error(pkgctx, 'PRC_MAIN CSPKS_END_OF_DATE.PRC_INIT_DEFRULES');
    COMMIT;

    plog.setendsection (pkgctx, 'PRC_MAIN');

    EXCEPTION when others then
        p_err_code := errnums.C_SYSTEM_ERROR;
        plog.error (pkgctx, 'Error when then data for buffer.');
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        plog.setendsection (pkgctx, 'PRC_MAIN');
        RAISE errnums.E_SYSTEM_ERROR;

  END PRC_MAIN;


    PROCEDURE prc_backup_advorder
    IS
    v_currdate DATE;
    v_t1date DATE;
    BEGIN
    SELECT todaydate,t1date  INTO v_currdate,v_t1date  FROM workingcalendar@dbl_fo;
    --Backup lenh CPO:
    --INSERT INTO cpo_b@dbl_fo SELECT * FROM cpo@dbl_fo;

    INSERT INTO cpo_b@dbl_fo(quoteid,
                     acctno,
                     reforderid,
                     symbol,
                     qtty,
                     side,
                     price,
                     broker,
                     status,
                     errorcode,
                     subquoteid,
                     orderid,
                     lastchange,
                     exec_qtty)
    SELECT  dtl.quoteid,
            dtl.acctno,
            dtl.reforderid,
            dtl.symbol,
            dtl.qtty,
            dtl.side,
            dtl.price,
            dtl.broker,
            CASE WHEN dtl.status ='P' THEN 'E'                               --Chua kich hoat -> Het hieu luc
                 WHEN dtl.status ='F' AND NVL(ad.exec_qtty,0) =0  THEN 'E'   --Da kich hoat -> Het hieu luc
                 WHEN NVL(ad.exec_qtty,0) = NVL(ad.quote_qtty,0) AND NVL(ad.quote_qtty,0) >0 THEN  dtl.status  --Hoan tat -> Hoan tat.
                 WHEN NVL(ad.exec_qtty,0) > 0 AND dtl.STATUS  NOT IN ('E','C')  THEN 'E'
                 ELSE dtl.status
            END status,
            dtl.errorcode,
            dtl.subquoteid,
            dtl.orderid,
            dtl.lastchange,
            dtl.exec_qtty
    FROM   cpo@dbl_fo dtl,
           v_fo_ad ad
           WHERE dtl.quoteid = ad.quoteid(+)
       ;


    DELETE FROM cpo@dbl_fo;
    COMMIT;



    -- ICO
    INSERT INTO ico_b@dbl_fo(quoteid,
                     acctno,
                     symbol,
                     qtty,
                     side,
                     price,
                     broker,
                     status,
                     errorcode,
                     subquoteid,
                     orderid,
                     lastchange,
                     exec_qtty)
    SELECT  dtl.quoteid,
            dtl.acctno,
            dtl.symbol,
            dtl.qtty,
            dtl.side,
            dtl.price,
            dtl.broker,
            CASE WHEN dtl.status ='P' THEN 'E'                               --Chua kich hoat -> Het hieu luc
                 WHEN dtl.status ='F' AND NVL(ad.exec_qtty,0) =0  THEN 'E'   --Da kich hoat -> Het hieu luc
                 WHEN NVL(ad.exec_qtty,0) = NVL(ad.quote_qtty,0) AND NVL(ad.quote_qtty,0) >0 THEN  dtl.status  --Hoan tat -> Hoan tat.
                 WHEN NVL(ad.exec_qtty,0) > 0 AND dtl.STATUS  NOT IN ('E','C')  THEN 'E'
                 ELSE dtl.status
            END status,
            dtl.errorcode,
            dtl.subquoteid,
            dtl.orderid,
            dtl.lastchange,
            dtl.exec_qtty
     FROM   ico@dbl_fo dtl,
           v_fo_ad ad
           WHERE dtl.quoteid = ad.quoteid(+)
       ;

    DELETE FROM ICO@dbl_fo;
    COMMIT;
    --MCO

    --INSERT INTO MCO_b@dbl_fo SELECT * FROM MCO@dbl_fo WHERE status NOT IN ('P','N') OR   todate <= v_currdate;


    INSERT INTO mco_b@dbl_fo (quoteid,
                     acctno,
                     symbol,
                     qtty,
                     price,
                     side,
                     broker,
                     status,
                     condition1,
                     operation1,
                     value1,
                     status1,
                     condition2,
                     operation2,
                     value2,
                     status2,
                     condition3,
                     operation3,
                     value3,
                     status3,
                     condition4,
                     operation4,
                     value4,
                     status4,
                     fromdate,
                     todate,
                     lastchange,
                     exec_qtty)
    SELECT  dtl.quoteid,
            dtl.acctno,
            dtl.symbol,
            dtl.qtty,
            dtl.price,
            dtl.side,
            dtl.broker,
            CASE WHEN dtl.status ='P' THEN 'E'                               --Chua kich hoat -> Het hieu luc
                         WHEN dtl.status ='F' AND NVL(ad.exec_qtty,0) =0  THEN 'E'   --Da kich hoat -> Het hieu luc
                         WHEN NVL(ad.exec_qtty,0) = NVL(ad.quote_qtty,0) AND NVL(ad.quote_qtty,0) >0 THEN  dtl.status  --Hoan tat -> Hoan tat.
                         WHEN NVL(ad.exec_qtty,0) > 0 AND dtl.STATUS  NOT IN ('E','C')  THEN 'E'
                         ELSE dtl.status
                     END status,
            dtl.condition1,
            dtl.operation1,
            dtl.value1,
            dtl.status1,
            dtl.condition2,
            dtl.operation2,
            dtl.value2,
            dtl.status2,
            dtl.condition3,
            dtl.operation3,
            dtl.value3,
            dtl.status3,
            dtl.condition4,
            dtl.operation4,
            dtl.value4,
            dtl.status4,
            dtl.fromdate,
            dtl.todate,
            dtl.lastchange,
            dtl.exec_qtty
            FROM mco@dbl_fo dtl,
                 v_fo_ad ad
            WHERE dtl.quoteid = ad.quoteid(+)
            AND   (dtl.status NOT IN ('P','N') OR  dtl.todate < v_t1date);


    DELETE FROM MCO@dbl_fo WHERE status NOT IN ('P','N') OR   todate < v_t1date;
    --Chuyen trang thai ve P lenh bat dau co hieu luc:
    UPDATE  MCO@dbl_fo SET status ='P' WHERE status ='N' AND  fromdate <= v_t1date;

    -- OCO
    --INSERT INTO OCO_b@dbl_fo SELECT * FROM OCO@dbl_fo;

    INSERT INTO OCO_b@dbl_fo(quoteid,
                 acctno,
                 symbol1,
                 qtty1,
                 price1,
                 side1,
                 symbol2,
                 qtty2,
                 price2,
                 side2,
                 broker,
                 status,
                 fromdate,
                 todate,
                 errorcode,
                 subquoteid,
                 orderid,
                 lastchange,
                 exec_qtty)
   SELECT  dtl.quoteid,
           dtl.acctno,
           dtl.symbol1,
           dtl.qtty1,
           dtl.price1,
           dtl.side1,
           dtl.symbol2,
           dtl.qtty2,
           dtl.price2,
           dtl.side2,
           dtl.broker,
           CASE WHEN dtl.status ='P' THEN 'E'                               --Chua kich hoat -> Het hieu luc
                         WHEN dtl.status ='F' AND NVL(ad.exec_qtty,0) =0  THEN 'E'   --Da kich hoat -> Het hieu luc
                         WHEN NVL(ad.exec_qtty,0) = NVL(ad.quote_qtty,0) AND NVL(ad.quote_qtty,0) >0 THEN  dtl.status  --Hoan tat -> Hoan tat.
                         WHEN NVL(ad.exec_qtty,0) > 0 AND dtl.STATUS  NOT IN ('E','C')  THEN 'E'
                         ELSE dtl.status
           END status,
           dtl.fromdate,
           dtl.todate,
           dtl.errorcode,
           dtl.subquoteid,
           dtl.orderid,
           dtl.lastchange,
           dtl.exec_qtty
        FROM OCO@dbl_fo dtl,
           v_fo_ad ad
        WHERE dtl.quoteid = ad.quoteid(+)
        ;

    DELETE FROM OCO@dbl_fo;
    COMMIT;

    -- OTO
    --INSERT INTO OTO_b@dbl_fo SELECT * FROM OTO@dbl_fo;

    INSERT INTO OTO_b@dbl_fo (quoteid,
                 acctno,
                 symbol,
                 qtty,
                 qtty2,
                 side,
                 buyorderid,
                 pricetype,
                 price,
                 orderprice,
                 broker,
                 status,
                 lastchange,
                 exec_qtty)
     SELECT     dtl.quoteid,
                dtl.acctno,
                dtl.symbol,
                dtl.qtty,
                dtl.qtty2,
                dtl.side,
                dtl.buyorderid,
                dtl.pricetype,
                dtl.price,
                dtl.orderprice,
                dtl.broker,
                CASE WHEN dtl.status ='P' THEN 'E'                               --Chua kich hoat -> Het hieu luc
                         WHEN dtl.status IN ('A','F')  AND NVL(ad.exec_qtty,0) =0  THEN 'E'   --Da kich hoat -> Het hieu luc
                         WHEN NVL(ad.exec_qtty,0) = NVL(ad.quote_qtty,0) AND NVL(ad.quote_qtty,0) >0 THEN  dtl.status  --Hoan tat -> Hoan tat.
                         WHEN NVL(ad.exec_qtty,0) > 0 AND dtl.STATUS  NOT IN ('E','C')  THEN 'E'
                         ELSE dtl.status
                END status,
                dtl.lastchange,
                dtl.exec_qtty
    FROM  OTO@dbl_fo dtl,
           v_fo_ad ad
    WHERE dtl.quoteid = ad.quoteid(+);

    DELETE FROM OTO@dbl_fo;
    COMMIT;

    --PCO


     --Cap nhat tong khoi luong khop chi tiet len lenh cha:

       UPDATE  PCO@dbl_fo p SET exec_qtty  =
             (
              SELECT ad.exec_qtty FROM PCO@dbl_fo dtl, quotes@dbl_fo q,
              (
                SELECT SUM(CASE WHEN subside IN ('NB','NS')  THEN   NVL(o.exec_qtty,0) ELSE 0 END  )  exec_qtty, atd.quoteid

                             FROM (SELECT * FROM active_orders@dbl_fo UNION SELECT * FROM active_orders_b@dbl_fo) atd,
                             (SELECT * FROM orders@dbl_fo UNION SELECT * FROM orders_b@dbl_fo)o
                             WHERE atd.orderid = o.orderid
                             GROUP BY atd.quoteid
                             ) ad
                WHERE q.quoteid  =dtl.quoteid
                 AND q.quoteid = ad.quoteid(+)
                 AND q.quoteid  = p.quoteid
             ) ;

       COMMIT;

     --Backup  PCO

      --INSERT INTO PCO_b@dbl_fo  SELECT * FROM PCO@dbl_fo dtl

      INSERT INTO PCO_b@dbl_fo(quoteid,
                 acctno,
                 symbol,
                 qtty,
                 side,
                 broker,
                 status,
                 fromdate,
                 todate,
                 active_price,
                 lastchange,
                 exec_qtty)
    SELECT dtl.quoteid,
           dtl.acctno,
           dtl.symbol,
           dtl.qtty,
           dtl.side,
           dtl.broker,
           CASE WHEN dtl.status ='P' THEN 'E'                               --Chua kich hoat -> Het hieu luc
                         WHEN dtl.status ='F' AND NVL(ad.exec_qtty,0) =0  THEN 'E'   --Da kich hoat -> Het hieu luc
                         WHEN NVL(ad.exec_qtty,0) = NVL(ad.quote_qtty,0) AND NVL(ad.quote_qtty,0) >0 THEN  dtl.status  --Hoan tat -> Hoan tat.
                         WHEN NVL(ad.exec_qtty,0) > 0 AND dtl.STATUS  NOT IN ('E','C')  THEN 'E'
                         ELSE 'E'
           END status,
           dtl.fromdate,
           dtl.todate,
           dtl.active_price,
           dtl.lastchange,
           dtl.exec_qtty
    FROM PCO@dbl_fo dtl,
           v_fo_ad ad
    WHERE dtl.quoteid = ad.quoteid(+)
      AND dtl.quoteid IN
            (
              SELECT dtl.quoteid FROM PCO@dbl_fo dtl, quotes@dbl_fo q,
               (SELECT atd.quoteid, SUM(CASE WHEN subside IN ('NB','NS')  THEN   NVL(o.cancel_qtty,0) ELSE 0 END  ) cancel_qtty,
                                                 SUM(CASE WHEN subside IN ('NB','NS')  THEN   NVL(o.exec_qtty,0) ELSE 0 END  )  exec_qtty,
                                                 SUM(CASE WHEN subside IN ('NB','NS')  THEN   NVL(o.quote_qtty,0) ELSE 0 END  )  quote_qtty,
                                                 max(o.time_created) activetime
                             FROM active_orders@dbl_fo atd, orders@dbl_fo o
                             WHERE atd.orderid = o.orderid
                             GROUP BY atd.quoteid
                             ) ad
             WHERE q.quoteid  =dtl.quoteid
               AND q.quoteid = ad.quoteid(+)
               AND (
                     (NVL(ad.exec_qtty,0) = NVL(ad.quote_qtty,0) AND NVL(ad.quote_qtty,0) >0  ) --Khop het
                      OR
                     (NVL(ad.cancel_qtty,0) = NVL(ad.quote_qtty,0) AND NVL(ad.quote_qtty,0) >0 AND dtl.STATUS ='F'
                       AND NOT EXISTS (SELECT 1 FROM orders@dbl_fo ord, active_orders@dbl_fo ao
                                       WHERE ord.orderid  = ao.orderid AND ord.substatus <> 'DD'
                                       AND ao.quoteid  = q.quoteid
                                      )
                      ) --Huy het
                     OR dtl.STATUS ='E'
                     OR dtl.todate < v_t1date
                   )
             );
       --Xoa PCO.
       DELETE FROM PCO@dbl_fo  WHERE  quoteid IN
           (
             SELECT dtl.quoteid FROM PCO@dbl_fo dtl, quotes@dbl_fo q,
              (SELECT atd.quoteid, SUM(CASE WHEN subside IN ('NB','NS')  THEN   NVL(o.cancel_qtty,0) ELSE 0 END  ) cancel_qtty,
                                                 SUM(CASE WHEN subside IN ('NB','NS')  THEN   NVL(o.exec_qtty,0) ELSE 0 END  )  exec_qtty,
                                                 SUM(CASE WHEN subside IN ('NB','NS')  THEN   NVL(o.quote_qtty,0) ELSE 0 END  )  quote_qtty,
                                                 max(o.time_created) activetime
                             FROM active_orders@dbl_fo atd, orders@dbl_fo o
                             WHERE atd.orderid = o.orderid
                             GROUP BY atd.quoteid
                             ) ad
             WHERE q.quoteid  =dtl.quoteid
               AND q.quoteid = ad.quoteid(+)
               AND (
                     (NVL(ad.exec_qtty,0) = NVL(ad.quote_qtty,0) AND NVL(ad.quote_qtty,0) >0  ) --Khop het
                      OR
                     (NVL(ad.cancel_qtty,0) = NVL(ad.quote_qtty,0) AND NVL(ad.quote_qtty,0) >0 AND dtl.STATUS ='F'
                      AND NOT EXISTS (SELECT 1 FROM orders@dbl_fo ord, active_orders@dbl_fo ao
                                       WHERE ord.orderid  = ao.orderid AND ord.substatus <> 'DD'
                                       AND ao.quoteid  = q.quoteid
                                      )
                       ) --Huy het
                      --Khop het, huy het
                     OR dtl.STATUS ='E'
                     OR dtl.todate < v_t1date
                   )

        )     ;
       --Cap nhat trang thai cac lenh con lai ve P:
       UPDATE  PCO@dbl_fo SET status ='P' WHERE  fromdate <= v_t1date;
       COMMIT;


       --SEO
      --Backup  SEO

      --INSERT INTO SEO_b@dbl_fo
      --SELECT * FROM SEO@dbl_fo WHERE  status IN ('E','F') OR todate <= v_currdate;

      INSERT INTO SEO_b@dbl_fo(quoteid,
                 acctno,
                 symbol,
                 qtty,
                 side,
                 pricetype,
                 orderprice,
                 price_delta,
                 broker,
                 status,
                 fromdate,
                 todate,
                 errorcode,
                 subquoteid,
                 orderid,
                 lastchange,
                 exec_qtty)
        SELECT dtl.quoteid,
               dtl.acctno,
               dtl.symbol,
               dtl.qtty,
               dtl.side,
               dtl.pricetype,
               dtl.orderprice,
               dtl.price_delta,
               dtl.broker,
               CASE WHEN dtl.status ='P' THEN 'E'                               --Chua kich hoat -> Het hieu luc
                         WHEN dtl.status ='F' AND NVL(ad.exec_qtty,0) =0  THEN 'E'   --Da kich hoat -> Het hieu luc
                         WHEN NVL(ad.exec_qtty,0) = NVL(ad.quote_qtty,0) AND NVL(ad.quote_qtty,0) >0 THEN  dtl.status  --Hoan tat -> Hoan tat.
                         WHEN NVL(ad.exec_qtty,0) > 0 AND dtl.STATUS  NOT IN ('E','C')  THEN 'E'
                         ELSE dtl.status
               END status,
               dtl.fromdate,
               dtl.todate,
               dtl.errorcode,
               dtl.subquoteid,
               dtl.orderid,
               dtl.lastchange,
               dtl.exec_qtty
      FROM  SEO@dbl_fo dtl,
            v_fo_ad ad
     WHERE dtl.quoteid = ad.quoteid(+)
      AND
       (dtl.status IN ('E','F') OR dtl.todate < v_t1date);

      /*
        WHERE  quoteid IN
            (
              SELECT dtl.quoteid FROM SEO@dbl_fo dtl, quotes@dbl_fo q,
               (SELECT atd.quoteid, SUM(CASE WHEN subside IN ('NB','NS')  THEN   NVL(o.cancel_qtty,0) ELSE 0 END  ) cancel_qtty,
                                                 SUM(CASE WHEN subside IN ('NB','NS')  THEN   NVL(o.exec_qtty,0) ELSE 0 END  )  exec_qtty,
                                                 SUM(CASE WHEN subside IN ('NB','NS')  THEN   NVL(o.quote_qtty,0) ELSE 0 END  )  quote_qtty,
                                                 max(o.time_created) activetime
                             FROM active_orders@dbl_fo atd, orders@dbl_fo o
                             WHERE atd.orderid = o.orderid
                             GROUP BY atd.quoteid
                             ) ad
             WHERE q.quoteid  =dtl.quoteid
               AND q.quoteid = ad.quoteid
               AND (
                     (NVL(ad.exec_qtty,0) = NVL(ad.quote_qtty,0) AND NVL(ad.quote_qtty,0) >0  ) --Khop het
                     OR dtl.STATUS ='E'
                     OR dtl.todate <= v_currdate
                   )
             );
             */
       --Xoa SEO.
       DELETE FROM SEO@dbl_fo  WHERE  status IN ('E','F') OR todate < v_t1date;
       /*
       WHERE  quoteid IN
           (
             SELECT dtl.quoteid FROM SEO@dbl_fo dtl, quotes@dbl_fo q,
              (SELECT atd.quoteid, SUM(CASE WHEN subside IN ('NB','NS')  THEN   NVL(o.cancel_qtty,0) ELSE 0 END  ) cancel_qtty,
                                                 SUM(CASE WHEN subside IN ('NB','NS')  THEN   NVL(o.exec_qtty,0) ELSE 0 END  )  exec_qtty,
                                                 SUM(CASE WHEN subside IN ('NB','NS')  THEN   NVL(o.quote_qtty,0) ELSE 0 END  )  quote_qtty,
                                                 max(o.time_created) activetime
                             FROM active_orders@dbl_fo atd, orders@dbl_fo o
                             WHERE atd.orderid = o.orderid
                             GROUP BY atd.quoteid
                             ) ad
             WHERE q.quoteid  =dtl.quoteid
               AND q.quoteid = ad.quoteid
               AND (
                     (
                       NVL(ad.exec_qtty,0) = NVL(ad.quote_qtty,0) AND NVL(ad.quote_qtty,0) >0
                      ) --Khop het
                     OR dtl.STATUS ='E'
                     OR dtl.todate <= v_currdate
                   )

        )     ;
        */
       --Cap nhat trang thai cac lenh con lai ve P:
       UPDATE  SEO@dbl_fo SET status ='P' WHERE  fromdate <= v_t1date;
       COMMIT;


       -- SO
       --INSERT INTO SO_b@dbl_fo SELECT * FROM SO@dbl_fo;

       INSERT INTO SO_b@dbl_fo(quoteid,
                acctno,
                symbol,
                qtty,
                price,
                price_delta,
                side,
                devide_type,
                qtty_size,
                qtty_delta,
                time_period,
                time_delta,
                broker,
                status,
                errorcode,
                subquoteid,
                orderid,
                lastchange,
                exec_qtty)
        SELECT  dtl.quoteid,
                dtl.acctno,
                dtl.symbol,
                dtl.qtty,
                dtl.price,
                dtl.price_delta,
                dtl.side,
                dtl.devide_type,
                dtl.qtty_size,
                dtl.qtty_delta,
                dtl.time_period,
                dtl.time_delta,
                dtl.broker,
                CASE WHEN dtl.status ='P' THEN 'E'                               --Chua kich hoat -> Het hieu luc
                         WHEN dtl.status ='F' AND NVL(ad.exec_qtty,0) =0  THEN 'E'   --Da kich hoat -> Het hieu luc
                         WHEN NVL(ad.exec_qtty,0) = NVL(ad.quote_qtty,0) AND NVL(ad.quote_qtty,0) >0 THEN  dtl.status  --Hoan tat -> Hoan tat.
                         WHEN NVL(ad.exec_qtty,0) > 0 AND dtl.STATUS  NOT IN ('E','C')  THEN 'E'
                         ELSE dtl.status
                END status,
                dtl.errorcode,
                dtl.subquoteid,
                dtl.orderid,
                dtl.lastchange,
                dtl.exec_qtty
        FROM   SO@dbl_fo dtl,
               v_fo_ad ad
       WHERE dtl.quoteid = ad.quoteid(+);

       DELETE FROM SO@dbl_fo;
       COMMIT;



      --STO
      --Backup  STO

      --INSERT INTO STO_b@dbl_fo      SELECT * FROM STO@dbl_fo
    INSERT INTO STO_b@dbl_fo (quoteid,
                 acctno,
                 symbol,
                 qtty,
                 side,
                 orderprice,
                 quoteprice,
                 broker,
                 status,
                 fromdate,
                 todate,
                 errorcode,
                 subquoteid,
                 orderid,
                 lastchange,
                 exec_qtty)
     SELECT dtl.quoteid,
            dtl.acctno,
            dtl.symbol,
            dtl.qtty,
            dtl.side,
            dtl.orderprice,
            dtl.quoteprice,
            dtl.broker,
            CASE WHEN dtl.status ='P' THEN 'E'                               --Chua kich hoat -> Het hieu luc
                         WHEN dtl.status ='F' AND NVL(ad.exec_qtty,0) =0  THEN 'E'   --Da kich hoat -> Het hieu luc
                         WHEN NVL(ad.exec_qtty,0) = NVL(ad.quote_qtty,0) AND NVL(ad.quote_qtty,0) >0 THEN  dtl.status  --Hoan tat -> Hoan tat.
                         WHEN NVL(ad.exec_qtty,0) > 0 AND dtl.STATUS  NOT IN ('E','C')  THEN 'E'
                         ELSE dtl.status
            END status,
            dtl.fromdate,
            dtl.todate,
            dtl.errorcode,
            dtl.subquoteid,
            dtl.orderid,
            dtl.lastchange,
            dtl.exec_qtty
      FROM  STO@dbl_fo dtl,
               v_fo_ad ad
      WHERE dtl.quoteid = ad.quoteid(+)
      AND (dtl.status IN ('E','F') OR dtl.todate < v_t1date);
      /*
          WHERE  quoteid IN
            (
              SELECT dtl.quoteid FROM STO@dbl_fo dtl, quotes@dbl_fo q,
               (SELECT atd.quoteid, SUM(CASE WHEN subside IN ('NB','NS')  THEN   NVL(o.cancel_qtty,0) ELSE 0 END  ) cancel_qtty,
                                                 SUM(CASE WHEN subside IN ('NB','NS')  THEN   NVL(o.exec_qtty,0) ELSE 0 END  )  exec_qtty,
                                                 SUM(CASE WHEN subside IN ('NB','NS')  THEN   NVL(o.quote_qtty,0) ELSE 0 END  )  quote_qtty,
                                                 max(o.time_created) activetime
                             FROM active_orders@dbl_fo atd, orders@dbl_fo o
                             WHERE atd.orderid = o.orderid
                             GROUP BY atd.quoteid
                             ) ad
             WHERE q.quoteid  =dtl.quoteid
               AND q.quoteid = ad.quoteid
               AND (
                     (NVL(ad.exec_qtty,0) = NVL(ad.quote_qtty,0) AND NVL(ad.quote_qtty,0) >0  ) --Khop het
                     OR dtl.STATUS ='E'
                     OR dtl.todate <= v_currdate
                   )
             );
            */
       --Xoa STO.
       DELETE FROM STO@dbl_fo  WHERE  status IN ('E','F') OR todate < v_t1date;
       /*
       quoteid IN
           (
             SELECT dtl.quoteid FROM STO@dbl_fo dtl, quotes@dbl_fo q,
              (SELECT atd.quoteid, SUM(CASE WHEN subside IN ('NB','NS')  THEN   NVL(o.cancel_qtty,0) ELSE 0 END  ) cancel_qtty,
                                                 SUM(CASE WHEN subside IN ('NB','NS')  THEN   NVL(o.exec_qtty,0) ELSE 0 END  )  exec_qtty,
                                                 SUM(CASE WHEN subside IN ('NB','NS')  THEN   NVL(o.quote_qtty,0) ELSE 0 END  )  quote_qtty,
                                                 max(o.time_created) activetime
                             FROM active_orders@dbl_fo atd, orders@dbl_fo o
                             WHERE atd.orderid = o.orderid
                             GROUP BY atd.quoteid
                             ) ad
             WHERE q.quoteid  =dtl.quoteid
               AND q.quoteid = ad.quoteid
               AND (
                     (
                       NVL(ad.exec_qtty,0) = NVL(ad.quote_qtty,0) AND NVL(ad.quote_qtty,0) >0
                      ) --Khop het
                     OR dtl.STATUS ='E'
                     OR dtl.todate <= v_currdate
                   )

        )
        ;*/
       --Cap nhat trang thai cac lenh con lai ve P:
       UPDATE  STO@dbl_fo SET status ='P' WHERE  fromdate <= v_t1date;
       COMMIT;

      --TSO
      --Backup  TSO

      --INSERT INTO TSO_b@dbl_fo SELECT * FROM TSO@dbl_fo  WHERE

      INSERT INTO  TSO_b@dbl_fo(quoteid,
                 acctno,
                 symbol,
                 ordertype,
                 deltatype,
                 deltavalue,
                 minmaxprice,
                 pricestep,
                 broker,
                 status,
                 activeprice,
                 fx1price,
                 fromdate,
                 todate,
                 lastchange,
                 exec_qtty,
                 qtty)
        SELECT  dtl.quoteid,
               dtl.acctno,
               dtl.symbol,
               dtl.ordertype,
               dtl.deltatype,
               dtl.deltavalue,
               dtl.minmaxprice,
               dtl.pricestep,
               dtl.broker,
               CASE WHEN dtl.status ='P' THEN 'E'                               --Chua kich hoat -> Het hieu luc
                         WHEN dtl.status ='F' AND NVL(ad.exec_qtty,0) =0  THEN 'E'   --Da kich hoat -> Het hieu luc
                         WHEN NVL(ad.exec_qtty,0) = NVL(ad.quote_qtty,0) AND NVL(ad.quote_qtty,0) >0 THEN  dtl.status  --Hoan tat -> Hoan tat.
                         WHEN NVL(ad.exec_qtty,0) > 0 AND dtl.STATUS  NOT IN ('E','C')  THEN 'E'
                         ELSE dtl.status
               END status,
               dtl.activeprice,
               dtl.fx1price,
               dtl.fromdate,
               dtl.todate,
               dtl.lastchange,
               dtl.exec_qtty,
               dtl.qtty
      FROM TSO@dbl_fo dtl,
               v_fo_ad ad
      WHERE dtl.quoteid = ad.quoteid(+)
      AND (dtl.status IN ('E','F') OR dtl.todate < v_t1date);

       --Xoa TSO.
       DELETE FROM TSO@dbl_fo  WHERE status IN ('E','F') OR todate < v_t1date;
       --Cap nhat trang thai cac lenh con lai ve P:
       UPDATE  TSO@dbl_fo SET status ='P' WHERE  fromdate <= v_t1date;
       COMMIT;

       --Backup Acitve_orders
       INSERT INTO  Active_orders_b@dbl_fo SELECT * FROM Active_orders@dbl_fo;
       DELETE  FROM Active_orders@dbl_fo;
       COMMIT;


    END;
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
END ;
/
