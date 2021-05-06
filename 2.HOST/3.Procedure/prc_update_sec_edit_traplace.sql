-- Start of DDL Script for Procedure HOSTMSTRADE.PRC_UPDATE_SEC_EDIT_TRAPLACE
-- Generated 16/01/2019 5:32:07 PM from HOSTMSTRADE@FLEX_111

CREATE OR REPLACE 
PROCEDURE prc_update_sec_edit_traplace (
           pl_CODEID IN VARCHAR2,
           pl_SYMBOL IN VARCHAR2,
           pv_TRADEPLACE IN VARCHAR2,
           pv_SECTYPE   IN VARCHAR2,
           pv_PARVALUE  IN NUMBER,
           pv_INTRATE   IN NUMBER,
           pv_STATUS    IN VARCHAR2,
           pv_CAREBY    IN VARCHAR2,
           pv_EXPDATE   IN VARCHAR2,
           pv_DEPOSITORY   IN VARCHAR2,
           pv_CHKRATE      IN NUMBER,
           pv_INTPERIOD    IN NUMBER,
           pv_ISSUEDATE    IN VARCHAR2,
           pv_ISSUERID     IN VARCHAR2,
           pv_FOREIGNRATE  IN NUMBER

       )
IS
          l_CODEID           VARCHAR2(10);
          l_SYMBOL           VARCHAR2(80);
          l_TRADEPLACE       VARCHAR2(3);
          l_old_tradeplace   VARCHAR2(3);
          l_strCurrdate         DATE;
          V_TRADENAME           VARCHAR2(10);
          v_count               NUMBER;
          v_tradelot_hsx        NUMBER;
          v_tradelot_hnx        NUMBER;
BEGIN

          l_CODEID           := pl_CODEID;
          l_SYMBOL           := pl_SYMBOL;

          l_TRADEPLACE       := pv_TRADEPLACE;
          SELECT to_date(varvalue,'DD/MM/RRRR') INTO l_strCurrdate
          FROM sysvar WHERE varname='CURRDATE' ;

         /* TRADEPLACE  000 T?t c?
          TRADEPLACE    002 HNX
          TRADEPLACE    003 OTC
          TRADEPLACE    005 UPCOM
          TRADEPLACE    006 WFT
          TRADEPLACE    001 HOSE*/

/*        IF pv_TRADEPLACE NOT IN ('003') THEN
            DELETE FROM securities_ticksize WHERE codeid=l_CODEID;
        END IF;*/


          SELECT A.CDCONTENT
          INTO V_TRADENAME
          FROM ALLCODE A
          WHERE        A.CDTYPE = 'SE'
          AND          CDNAME   = 'TRADEPLACE'
          AND          CDVAL    = pv_TRADEPLACE;
          
          --Lay thong tin lo default
          BEGIN
            SELECT to_number(varvalue) INTO v_tradelot_hsx FROM sysvar WHERE varname = 'HSX_DEFAULT_TRADELOT';
            SELECT to_number(varvalue) INTO v_tradelot_hnx FROM sysvar WHERE varname = 'HNX_DEFAULT_TRADELOT';
          EXCEPTION WHEN OTHERS THEN
            v_tradelot_hsx := 100;
            v_tradelot_hnx := 100;
          END;
          -- log thong tin chuyen san
          SELECT tradeplace INTO l_old_tradeplace
          FROM sbsecurities WHERE codeid=l_CODEID;
          if(l_old_tradeplace <> l_TRADEPLACE) THEN
             INSERT INTO SETRADEPLACE (AUTOID,TXDATE,CODEID,CTYPE,FRTRADEPLACE,TOTRADEPLACE)
             VALUES (SEQ_SETRADEPLACE.NEXTVAL,TO_DATE (l_strCurrdate, 'DD/MM/RRRR'),l_CODEID,'MA',l_old_tradeplace,l_TRADEPLACE);

          END IF;

           IF (V_TRADENAME = 'HOSE') THEN
            --DELETE FROM securities_ticksize WHERE codeid=l_CODEID;
             if(pv_SECTYPE IN ('001','008','011')) THEN-- CP thuong, chung chi quy
             ---- INSERT SECURITIES_TICKSIZE (BUOC GIA)
/*
                 INSERT INTO SECURITIES_TICKSIZE (AUTOID, CODEID, SYMBOL, TICKSIZE, FROMPRICE, TOPRICE, STATUS)
                 VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL, l_CODEID, l_SYMBOL, 100, 0, 49900, 'Y');

                 INSERT INTO SECURITIES_TICKSIZE (AUTOID, CODEID, SYMBOL, TICKSIZE, FROMPRICE, TOPRICE, STATUS)
                 VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL, l_CODEID, l_SYMBOL, 500, 50000, 99500, 'Y');

                 INSERT INTO SECURITIES_TICKSIZE (AUTOID, CODEID, SYMBOL, TICKSIZE, FROMPRICE, TOPRICE, STATUS)
                 VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL, l_CODEID, l_SYMBOL, 1000, 100000, 100000000, 'Y');
*/
                IF l_old_tradeplace = '003' THEN
                  ---- INSERT SECURITIES_INFO (TT CHI TIET MA CK)
                   DELETE SECURITIES_INFO WHERE CODEID = l_CODEID;
                 INSERT INTO SECURITIES_INFO (
                        AUTOID, CODEID, SYMBOL, TXDATE, LISTINGQTTY, TRADEUNIT, LISTINGSTATUS, ADJUSTQTTY, LISTTINGDATE, REFERENCESTATUS,
                        ADJUSTRATE, REFERENCERATE, REFERENCEDATE, STATUS, BASICPRICE, OPENPRICE, PREVCLOSEPRICE, CURRPRICE, CLOSEPRICE,
                        AVGPRICE, CEILINGPRICE, FLOORPRICE, MTMPRICE, MTMPRICECD, INTERNALBIDPRICE, INTERNALASKPRICE, PE, EPS, DIVYEILD,
                        DAYRANGE, YEARRANGE, TRADELOT, TRADEBUYSELL, TELELIMITMIN, TELELIMITMAX, ONLINELIMITMIN, ONLINELIMITMAX,
                        REPOLIMITMIN, REPOLIMITMAX, ADVANCEDLIMITMIN, ADVANCEDLIMITMAX, MARGINLIMITMIN, MARGINLIMITMAX, SECURERATIOTMIN,
                        SECURERATIOMAX, DEPOFEEUNIT, DEPOFEELOT, MORTAGERATIOMIN, MORTAGERATIOMAX, SECUREDRATIOMIN, SECUREDRATIOMAX,
                        CURRENT_ROOM, BMINAMT, SMINAMT, MARGINPRICE)
                 VALUES (
                        SEQ_SECURITIES_INFO.NEXTVAL, l_CODEID, l_SYMBOL, TO_DATE (l_strCurrdate, systemnums.c_date_format),
                        1, 1000, 'N', 1, TO_DATE (l_strCurrdate, systemnums.c_date_format), '001', 1, 1,
                        TO_DATE (l_strCurrdate, systemnums.c_date_format), '001', 0, 0, 0, 0, 0, 0, 1, 1, 0, '001',
                        0, 0, 1, 1, 1, 1, 1, v_tradelot_hsx, 'Y', 0, 1000000000, 0,
                        1000000000, 0, 1000000000, 0, 1000000000, 0, 1000000000, 0, 0, 1, 1, 0, 1000000000, 1, 102, 0, 0, 0, 0);
                END IF;

                 UPDATE securities_info SET tradelot=v_tradelot_hsx WHERE  codeid=l_CODEID;

             ELSIF  (pv_SECTYPE IN ('003','006')) THEN -- trai phieu, trai phieu chuyen doi
/*
                 INSERT INTO SECURITIES_TICKSIZE (AUTOID, CODEID, SYMBOL, TICKSIZE, FROMPRICE, TOPRICE, STATUS)
                 VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL, l_CODEID, l_SYMBOL, 1, 0, 100000000, 'Y');
*/
                 IF l_old_tradeplace = '003' THEN
                    ---- INSERT SECURITIES_INFO (TT CHI TIET MA CK)
                   DELETE SECURITIES_INFO WHERE CODEID = l_CODEID;
                 INSERT INTO SECURITIES_INFO (
                        AUTOID, CODEID, SYMBOL, TXDATE, LISTINGQTTY, TRADEUNIT, LISTINGSTATUS, ADJUSTQTTY, LISTTINGDATE, REFERENCESTATUS,
                        ADJUSTRATE, REFERENCERATE, REFERENCEDATE, STATUS, BASICPRICE, OPENPRICE, PREVCLOSEPRICE, CURRPRICE, CLOSEPRICE,
                        AVGPRICE, CEILINGPRICE, FLOORPRICE, MTMPRICE, MTMPRICECD, INTERNALBIDPRICE, INTERNALASKPRICE, PE, EPS, DIVYEILD,
                        DAYRANGE, YEARRANGE, TRADELOT, TRADEBUYSELL, TELELIMITMIN, TELELIMITMAX, ONLINELIMITMIN, ONLINELIMITMAX,
                        REPOLIMITMIN, REPOLIMITMAX, ADVANCEDLIMITMIN, ADVANCEDLIMITMAX, MARGINLIMITMIN, MARGINLIMITMAX, SECURERATIOTMIN,
                        SECURERATIOMAX, DEPOFEEUNIT, DEPOFEELOT, MORTAGERATIOMIN, MORTAGERATIOMAX, SECUREDRATIOMIN, SECUREDRATIOMAX,
                        CURRENT_ROOM, BMINAMT, SMINAMT, MARGINPRICE)
                 VALUES (
                        SEQ_SECURITIES_INFO.NEXTVAL, l_CODEID, l_SYMBOL, TO_DATE (l_strCurrdate, systemnums.c_date_format),
                        1, 1000, 'N', 1, TO_DATE (l_strCurrdate, systemnums.c_date_format), '001', 1, 1,
                        TO_DATE (l_strCurrdate, systemnums.c_date_format), '001', 0, 0, 0, 0, 0, 0, 1, 1, 0, '001',
                        0, 0, 1, 1, 1, 1, 1, 1, 'Y', 0, 1000000000, 0,
                        1000000000, 0, 1000000000, 0, 1000000000, 0, 1000000000, 0, 0, 1, 1, 0, 1000000000, 1, 102, 0, 0, 0, 0);
                END IF;
                 UPDATE securities_info SET tradelot=1 WHERE  codeid=l_CODEID;

             ELSE

                IF l_old_tradeplace = '003' THEN
                    ---- INSERT SECURITIES_INFO (TT CHI TIET MA CK)
                   DELETE SECURITIES_INFO WHERE CODEID = l_CODEID;
                 INSERT INTO SECURITIES_INFO (
                        AUTOID, CODEID, SYMBOL, TXDATE, LISTINGQTTY, TRADEUNIT, LISTINGSTATUS, ADJUSTQTTY, LISTTINGDATE, REFERENCESTATUS,
                        ADJUSTRATE, REFERENCERATE, REFERENCEDATE, STATUS, BASICPRICE, OPENPRICE, PREVCLOSEPRICE, CURRPRICE, CLOSEPRICE,
                        AVGPRICE, CEILINGPRICE, FLOORPRICE, MTMPRICE, MTMPRICECD, INTERNALBIDPRICE, INTERNALASKPRICE, PE, EPS, DIVYEILD,
                        DAYRANGE, YEARRANGE, TRADELOT, TRADEBUYSELL, TELELIMITMIN, TELELIMITMAX, ONLINELIMITMIN, ONLINELIMITMAX,
                        REPOLIMITMIN, REPOLIMITMAX, ADVANCEDLIMITMIN, ADVANCEDLIMITMAX, MARGINLIMITMIN, MARGINLIMITMAX, SECURERATIOTMIN,
                        SECURERATIOMAX, DEPOFEEUNIT, DEPOFEELOT, MORTAGERATIOMIN, MORTAGERATIOMAX, SECUREDRATIOMIN, SECUREDRATIOMAX,
                        CURRENT_ROOM, BMINAMT, SMINAMT, MARGINPRICE)
                 VALUES (
                        SEQ_SECURITIES_INFO.NEXTVAL, l_CODEID, l_SYMBOL, TO_DATE (l_strCurrdate, systemnums.c_date_format),
                        1, 1000, 'N', 1, TO_DATE (l_strCurrdate, systemnums.c_date_format), '001', 1, 1,
                        TO_DATE (l_strCurrdate, systemnums.c_date_format), '001', 0, 0, 0, 0, 0, 0, 1, 1, 0, '001',
                        0, 0, 1, 1, 1, 1, 1, 0, 'Y', 0, 1000000000, 0,
                        1000000000, 0, 1000000000, 0, 1000000000, 0, 1000000000, 0, 0, 1, 1, 0, 1000000000, 1, 102, 0, 0, 0, 0);
                END IF;
                UPDATE securities_info SET tradelot=0 WHERE  codeid=l_CODEID;
             END IF;

           ELSIF (V_TRADENAME IN ( 'HNX','UPCOM') )THEN
               if(pv_SECTYPE IN ('001','008','011','012')) THEN-- CP thuong, chung chi quy  --1.5.6.0
                  ---- INSERT SECURITIES_TICKSIZE (BUOC GIA)
                    /*INSERT INTO SECURITIES_TICKSIZE (AUTOID, CODEID, SYMBOL, TICKSIZE, FROMPRICE, TOPRICE, STATUS)
                    VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL, l_CODEID, l_SYMBOL, 100, 0, 10000000, 'Y');*/

                IF l_old_tradeplace = '003' THEN
                   ---- INSERT SECURITIES_INFO (TT CHI TIET MA CK)
                   DELETE SECURITIES_INFO WHERE CODEID = l_CODEID;
                   INSERT INTO SECURITIES_INFO (
                          AUTOID, CODEID, SYMBOL, TXDATE, LISTINGQTTY, TRADEUNIT, LISTINGSTATUS, ADJUSTQTTY,
                          LISTTINGDATE, REFERENCESTATUS, ADJUSTRATE, REFERENCERATE, REFERENCEDATE, STATUS, BASICPRICE,
                          OPENPRICE, PREVCLOSEPRICE, CURRPRICE, CLOSEPRICE, AVGPRICE, CEILINGPRICE, FLOORPRICE, MTMPRICE,
                          MTMPRICECD, INTERNALBIDPRICE, INTERNALASKPRICE, PE, EPS, DIVYEILD, DAYRANGE, YEARRANGE, TRADELOT,
                          TRADEBUYSELL, TELELIMITMIN, TELELIMITMAX, ONLINELIMITMIN, ONLINELIMITMAX, REPOLIMITMIN,
                          REPOLIMITMAX, ADVANCEDLIMITMIN, ADVANCEDLIMITMAX, MARGINLIMITMIN, MARGINLIMITMAX,
                          SECURERATIOTMIN, SECURERATIOMAX, DEPOFEEUNIT, DEPOFEELOT, MORTAGERATIOMIN, MORTAGERATIOMAX,
                          SECUREDRATIOMIN, SECUREDRATIOMAX, CURRENT_ROOM, BMINAMT, SMINAMT, MARGINPRICE)
                   VALUES (
                          SEQ_SECURITIES_INFO.NEXTVAL, l_CODEID, l_SYMBOL, TO_DATE (l_strCurrdate, systemnums.c_date_format),
                          1, 1000, 'N', 1, TO_DATE (l_strCurrdate, systemnums.c_date_format), '001', 1, 1,
                          TO_DATE (l_strCurrdate, systemnums.c_date_format), '001', 0, 0, 0, 0, 0, 0, 1, 1, 0, '002', 0,
                          0, 1, 1, 1, 1, 1, v_tradelot_hnx, 'Y', 0, 1000000000, 0, 1000000000, 0, 1000000000, 0, 1000000000, 0,
                          1000000000, 0, 0, 1, 1, 0, 1000000000, 1, 102, 0, 0, 0, 0);
                END IF;

                  UPDATE securities_info SET tradelot=100 WHERE  codeid=l_CODEID;
               ELSIF (pv_SECTYPE IN ('003','006')) THEN -- trai phieu, trai phieu chuyen doi
                   ---- INSERT SECURITIES_TICKSIZE (BUOC GIA)
                    /*
                       INSERT INTO SECURITIES_TICKSIZE (AUTOID, CODEID, SYMBOL, TICKSIZE, FROMPRICE, TOPRICE, STATUS)
                       VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL, l_CODEID, l_SYMBOL, 1, 0, 10000000, 'Y');
                   */

                 IF l_old_tradeplace = '003' THEN
                  ---- INSERT SECURITIES_INFO (TT CHI TIET MA CK)
                   DELETE SECURITIES_INFO WHERE CODEID = l_CODEID;
                   INSERT INTO SECURITIES_INFO (
                          AUTOID, CODEID, SYMBOL, TXDATE, LISTINGQTTY, TRADEUNIT, LISTINGSTATUS, ADJUSTQTTY,
                          LISTTINGDATE, REFERENCESTATUS, ADJUSTRATE, REFERENCERATE, REFERENCEDATE, STATUS, BASICPRICE,
                          OPENPRICE, PREVCLOSEPRICE, CURRPRICE, CLOSEPRICE, AVGPRICE, CEILINGPRICE, FLOORPRICE, MTMPRICE,
                          MTMPRICECD, INTERNALBIDPRICE, INTERNALASKPRICE, PE, EPS, DIVYEILD, DAYRANGE, YEARRANGE, TRADELOT,
                          TRADEBUYSELL, TELELIMITMIN, TELELIMITMAX, ONLINELIMITMIN, ONLINELIMITMAX, REPOLIMITMIN,
                          REPOLIMITMAX, ADVANCEDLIMITMIN, ADVANCEDLIMITMAX, MARGINLIMITMIN, MARGINLIMITMAX,
                          SECURERATIOTMIN, SECURERATIOMAX, DEPOFEEUNIT, DEPOFEELOT, MORTAGERATIOMIN, MORTAGERATIOMAX,
                          SECUREDRATIOMIN, SECUREDRATIOMAX, CURRENT_ROOM, BMINAMT, SMINAMT, MARGINPRICE)
                   VALUES (
                          SEQ_SECURITIES_INFO.NEXTVAL, l_CODEID, l_SYMBOL, TO_DATE (l_strCurrdate, systemnums.c_date_format),
                          1, 1000, 'N', 1, TO_DATE (l_strCurrdate, systemnums.c_date_format), '001', 1, 1,
                          TO_DATE (l_strCurrdate, systemnums.c_date_format), '001', 0, 0, 0, 0, 0, 0, 1, 1, 0, '002', 0,
                          0, 1, 1, 1, 1, 1, 1, 'Y', 0, 1000000000, 0, 1000000000, 0, 1000000000, 0, 1000000000, 0,
                          1000000000, 0, 0, 1, 1, 0, 1000000000, 1, 102, 0, 0, 0, 0);
                END IF;

                   UPDATE securities_info SET tradelot=1 WHERE  codeid=l_CODEID;
               ELSE
                IF l_old_tradeplace = '003' THEN
                         ---- INSERT SECURITIES_INFO (TT CHI TIET MA CK)
                   DELETE SECURITIES_INFO WHERE CODEID = l_CODEID;
                   INSERT INTO SECURITIES_INFO (
                          AUTOID, CODEID, SYMBOL, TXDATE, LISTINGQTTY, TRADEUNIT, LISTINGSTATUS, ADJUSTQTTY,
                          LISTTINGDATE, REFERENCESTATUS, ADJUSTRATE, REFERENCERATE, REFERENCEDATE, STATUS, BASICPRICE,
                          OPENPRICE, PREVCLOSEPRICE, CURRPRICE, CLOSEPRICE, AVGPRICE, CEILINGPRICE, FLOORPRICE, MTMPRICE,
                          MTMPRICECD, INTERNALBIDPRICE, INTERNALASKPRICE, PE, EPS, DIVYEILD, DAYRANGE, YEARRANGE, TRADELOT,
                          TRADEBUYSELL, TELELIMITMIN, TELELIMITMAX, ONLINELIMITMIN, ONLINELIMITMAX, REPOLIMITMIN,
                          REPOLIMITMAX, ADVANCEDLIMITMIN, ADVANCEDLIMITMAX, MARGINLIMITMIN, MARGINLIMITMAX,
                          SECURERATIOTMIN, SECURERATIOMAX, DEPOFEEUNIT, DEPOFEELOT, MORTAGERATIOMIN, MORTAGERATIOMAX,
                          SECUREDRATIOMIN, SECUREDRATIOMAX, CURRENT_ROOM, BMINAMT, SMINAMT, MARGINPRICE)
                   VALUES (
                          SEQ_SECURITIES_INFO.NEXTVAL, l_CODEID, l_SYMBOL, TO_DATE (l_strCurrdate, systemnums.c_date_format),
                          1, 1000, 'N', 1, TO_DATE (l_strCurrdate, systemnums.c_date_format), '001', 1, 1,
                          TO_DATE (l_strCurrdate, systemnums.c_date_format), '001', 0, 0, 0, 0, 0, 0, 1, 1, 0, '002', 0,
                          0, 1, 1, 1, 1, 1, 0, 'Y', 0, 1000000000, 0, 1000000000, 0, 1000000000, 0, 1000000000, 0,
                          1000000000, 0, 0, 1, 1, 0, 1000000000, 1, 102, 0, 0, 0, 0);
                END IF;
                   UPDATE securities_info SET tradelot=0 WHERE  codeid=l_CODEID;

               END IF;
            ELSIF V_TRADENAME IN ('OTC') THEN
                IF pv_TRADEPLACE = '003' AND l_old_tradeplace <> '003'THEN
                    DELETE SECURITIES_INFO WHERE CODEID = l_CODEID;
                    DELETE FROM securities_ticksize WHERE codeid=l_CODEID;
                END IF;
            ELSE
                UPDATE securities_info SET tradelot=0 WHERE  codeid=l_CODEID;
           END IF;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/



-- End of DDL Script for Procedure HOSTMSTRADE.PRC_UPDATE_SEC_EDIT_TRAPLACE
