CREATE OR REPLACE PROCEDURE GETCONDITIONFONTORDER
   (
     PV_REFCURSOR   IN OUT PKG_REPORT.REF_CURSOR,
     pv_FunType    IN varchar2
    )
   IS
    v_txDate date;
    v_FunType varchar2(40);
BEGIN -- Proc
    v_FunType := upper(pv_FunType);
    select to_date(varvalue,'dd/MM/yyyy') into v_txDate from sysvar where upper(varname) = 'CURRDATE';

    if v_FunType = 'GTC-HO' then
        OPEN PV_REFCURSOR FOR
        SELECT * FROM (SELECT MST.ACCTNO,MSt.ACTYPE,MSt.AFACCTNO,MSt.STATUS,MSt.EXECTYPE,MSt.PRICETYPE,MSt.TIMETYPE,
					MSt.MATCHTYPE,MSt.NORK,MSt.CLEARCD,MSt.CLEARDAY,MSt.CODEID,MSt.SYMBOL,MSt.QUANTITY,
					0 PRICE,MSt.QUOTEPRICE,MSt.TRIGGERPRICE,MSt.EXECQTTY,MSt.EXECAMT,MSt.REMAINQTTY,
					MSt.CANCELQTTY,MSt.AMENDQTTY,MSt.CONFIRMEDVIA,MSt.BOOK,MSt.ORGACCTNO,MSt.REFACCTNO,
					MSt.REFQUANTITY,MSt.REFPRICE,MSt.REFQUOTEPRICE,MSt.FEEDBACKMSG,MSt.ACTIVATEDT,
					MSt.CREATEDDT,MSt.REFORDERID,MSt.REFUSERNAME,MSt.TXDATE,MSt.TXNUM,MSt.EFFDATE,
					MSt.EXPDATE,MSt.BRATIO,MSt.VIA,MSt.DELTD,MSt.OUTPRICEALLOW,MSt.USERNAME,
					SEC.TRADEPLACE, SEC.SECTYPE, SEC.PARVALUE, INF.TRADELOT,
				    INF.TRADEUNIT, INF.SECUREDRATIOMIN, INF.SECUREDRATIOMAX,INF.CEILINGPRICE,INF.FLOORPRICE,INF.MARGINPRICE
          FROM FOMAST MST, SBSECURITIES SEC, SECURITIES_INFO INF, ordersys o
         WHERE MST.DELTD<>'Y' AND MST.BOOK = 'A' AND  MST.REMAINQTTY>0
           AND MST.EXECTYPE IN ('NB','BC') AND PRICETYPE<>'SL'
           AND MST.TIMETYPE = 'G'
           AND MST.STATUS = 'P'
           AND MST.CODEID = SEC.CODEID
           AND SEC.TRADEPLACE='001'
           AND MST.CODEID = INF.CODEID
           AND MST.EFFDATE <= v_txDate
           AND SYSNAME ='CONTROLCODE'
           AND (
                 (o.SYSVALUE='O' AND PRICETYPE ='LO') or o.SYSVALUE <>'O'
                )
           AND CHECKGTCBUYORDER(mst.afacctno,MST.REMAINQTTY,
                            (CASE WHEN PRICETYPE='LO' THEN MST.QUOTEPRICE
                                  ELSE INF.CEILINGPRICE/INF.TRADEUNIT
                             END),
                            MST.BRATIO,SEC.SYMBOL
                )>=0
        UNION
        SELECT MST.ACCTNO,MSt.ACTYPE,MSt.AFACCTNO,MSt.STATUS,MSt.EXECTYPE,PRICETYPE,MSt.TIMETYPE,
					MSt.MATCHTYPE,MSt.NORK,MSt.CLEARCD,MSt.CLEARDAY,MSt.CODEID,MSt.SYMBOL,MSt.QUANTITY,
					0 PRICE,MSt.QUOTEPRICE,MSt.TRIGGERPRICE,MSt.EXECQTTY,MSt.EXECAMT,MSt.REMAINQTTY,
					MSt.CANCELQTTY,MSt.AMENDQTTY,MSt.CONFIRMEDVIA,MSt.BOOK,MSt.ORGACCTNO,MSt.REFACCTNO,
					MSt.REFQUANTITY,MSt.REFPRICE,MSt.REFQUOTEPRICE,MSt.FEEDBACKMSG,MSt.ACTIVATEDT,
					MSt.CREATEDDT,MSt.REFORDERID,MSt.REFUSERNAME,MSt.TXDATE,MSt.TXNUM,MSt.EFFDATE,
					MSt.EXPDATE,MSt.BRATIO,MSt.VIA,MSt.DELTD,MSt.OUTPRICEALLOW,MSt.USERNAME,
					SEC.TRADEPLACE, SEC.SECTYPE, SEC.PARVALUE, INF.TRADELOT,
               INF.TRADEUNIT, INF.SECUREDRATIOMIN, INF.SECUREDRATIOMAX,INF.CEILINGPRICE,INF.FLOORPRICE,INF.MARGINPRICE
                 FROM FOMAST MST, SBSECURITIES SEC, SECURITIES_INFO INF,SEMAST SE,v_getsellorderinfo V, ordersys o
         WHERE MST.DELTD<>'Y' AND MST.BOOK = 'A' AND  MST.REMAINQTTY>0
           AND SE.ACCTNO=V.seacctno(+)
           AND MST.EXECTYPE IN ('MS','SS','NS')  AND PRICETYPE<>'SL'
           AND MST.TIMETYPE = 'G'
           AND MST.STATUS = 'P'
           AND MST.CODEID = SEC.CODEID
           AND SEC.TRADEPLACE='001'
           AND MST.CODEID = INF.CODEID
           AND MST.EFFDATE <= v_txDate
           AND SYSNAME ='CONTROLCODE'
            AND (
                 (o.SYSVALUE='O' AND PRICETYPE ='LO') or o.SYSVALUE <>'O'
                )
           AND SE.ACCTNO =MST.AFACCTNO || MST.CODEID
           AND (CASE WHEN MST.EXECTYPE='MS' THEN SE.MORTAGE-nvl(v.securemtg,0)
           ELSE SE.TRADE-nvl(V.secureamt,0) END)  >= MST.REMAINQTTY)
           ORDER BY TO_DATE(SUBSTR(ACCTNO,5,6),'DDMMYY'), SUBSTR(ACCTNO,11,6);

    elsif v_FunType = 'GTC-HA' then
        OPEN PV_REFCURSOR FOR
        SELECT * FROM (SELECT MST.ACCTNO,MSt.ACTYPE,MSt.AFACCTNO,MSt.STATUS,MSt.EXECTYPE,PRICETYPE,MSt.TIMETYPE,
					MSt.MATCHTYPE,MSt.NORK,MSt.CLEARCD,MSt.CLEARDAY,MSt.CODEID,MSt.SYMBOL,MSt.QUANTITY,
					0 PRICE,MSt.QUOTEPRICE,MSt.TRIGGERPRICE,MSt.EXECQTTY,MSt.EXECAMT,MSt.REMAINQTTY,
					MSt.CANCELQTTY,MSt.AMENDQTTY,MSt.CONFIRMEDVIA,MSt.BOOK,MSt.ORGACCTNO,MSt.REFACCTNO,
					MSt.REFQUANTITY,MSt.REFPRICE,MSt.REFQUOTEPRICE,MSt.FEEDBACKMSG,MSt.ACTIVATEDT,
					MSt.CREATEDDT,MSt.REFORDERID,MSt.REFUSERNAME,MSt.TXDATE,MSt.TXNUM,MSt.EFFDATE,
					MSt.EXPDATE,MSt.BRATIO,MSt.VIA,MSt.DELTD,MSt.OUTPRICEALLOW,MSt.USERNAME,
					 SEC.TRADEPLACE, SEC.SECTYPE, SEC.PARVALUE, INF.TRADELOT,
               INF.TRADEUNIT, INF.SECUREDRATIOMIN, INF.SECUREDRATIOMAX,INF.CEILINGPRICE,INF.FLOORPRICE,INF.MARGINPRICE
          FROM FOMAST MST, SBSECURITIES SEC, SECURITIES_INFO INF
         WHERE MST.DELTD<>'Y' AND MST.BOOK = 'A' AND  MST.REMAINQTTY>0
           AND MST.EXECTYPE IN ('NB','BC')  AND PRICETYPE<>'SL'
           AND MST.TIMETYPE = 'G'
           AND MST.STATUS = 'P'
           AND MST.CODEID = SEC.CODEID
           AND SEC.TRADEPLACE='002'
           AND MST.CODEID = INF.CODEID
           AND MST.EFFDATE <= v_txDate
           AND CHECKGTCBUYORDER(mst.afacctno,MST.REMAINQTTY,
                            (CASE WHEN PRICETYPE='LO' THEN MST.QUOTEPRICE
                                 ELSE INF.CEILINGPRICE/INF.TRADEUNIT
                             END),
                            MST.BRATIO,SEC.SYMBOL
                )>=0

        UNION
        SELECT MST.ACCTNO,MSt.ACTYPE,MSt.AFACCTNO,MSt.STATUS,MSt.EXECTYPE,PRICETYPE,MSt.TIMETYPE,
					MSt.MATCHTYPE,MSt.NORK,MSt.CLEARCD,MSt.CLEARDAY,MSt.CODEID,MSt.SYMBOL,MSt.QUANTITY,
					0 PRICE,MSt.QUOTEPRICE,MSt.TRIGGERPRICE,MSt.EXECQTTY,MSt.EXECAMT,MSt.REMAINQTTY,
					MSt.CANCELQTTY,MSt.AMENDQTTY,MSt.CONFIRMEDVIA,MSt.BOOK,MSt.ORGACCTNO,MSt.REFACCTNO,
					MSt.REFQUANTITY,MSt.REFPRICE,MSt.REFQUOTEPRICE,MSt.FEEDBACKMSG,MSt.ACTIVATEDT,
					MSt.CREATEDDT,MSt.REFORDERID,MSt.REFUSERNAME,MSt.TXDATE,MSt.TXNUM,MSt.EFFDATE,
					MSt.EXPDATE,MSt.BRATIO,MSt.VIA,MSt.DELTD,MSt.OUTPRICEALLOW,MSt.USERNAME,
					 SEC.TRADEPLACE, SEC.SECTYPE, SEC.PARVALUE, INF.TRADELOT,
               INF.TRADEUNIT, INF.SECUREDRATIOMIN, INF.SECUREDRATIOMAX,INF.CEILINGPRICE,INF.FLOORPRICE,INF.MARGINPRICE
                 FROM FOMAST MST, SBSECURITIES SEC, SECURITIES_INFO INF,SEMAST SE ,v_getsellorderinfo V
         WHERE MST.DELTD<>'Y' AND MST.BOOK = 'A' AND  MST.REMAINQTTY>0
           AND SE.ACCTNO=V.seacctno(+)
           AND MST.EXECTYPE IN ('MS','SS','NS')  AND PRICETYPE<>'SL'
           AND MST.TIMETYPE = 'G'
           AND MST.STATUS = 'P'
           AND MST.CODEID = SEC.CODEID
           AND SEC.TRADEPLACE='002'
           AND MST.CODEID = INF.CODEID
           AND MST.EFFDATE <= v_txDate
           AND SE.ACCTNO =MST.AFACCTNO || MST.CODEID
           AND (CASE WHEN MST.EXECTYPE='MS' THEN SE.MORTAGE-nvl(v.securemtg,0) ELSE SE.TRADE-nvl(V.secureamt,0) END)  >= MST.REMAINQTTY) ORDER BY TO_DATE(SUBSTR(ACCTNO,5,6),'DDMMYY'), SUBSTR(ACCTNO,11,6);

    elsif v_FunType = 'SL-HO' then
        OPEN PV_REFCURSOR FOR
        SELECT * FROM (SELECT MST.ACCTNO,MSt.ACTYPE,MSt.AFACCTNO,MSt.STATUS,MSt.EXECTYPE,PRICETYPE,MSt.TIMETYPE,
					MSt.MATCHTYPE,MSt.NORK,MSt.CLEARCD,MSt.CLEARDAY,MSt.CODEID,MSt.SYMBOL,MSt.QUANTITY,
					PRICE/1000,MSt.QUOTEPRICE,MSt.TRIGGERPRICE,MSt.EXECQTTY,MSt.EXECAMT,MSt.REMAINQTTY,
					MSt.CANCELQTTY,MSt.AMENDQTTY,MSt.CONFIRMEDVIA,MSt.BOOK,MSt.ORGACCTNO,MSt.REFACCTNO,
					MSt.REFQUANTITY,MSt.REFPRICE,MSt.REFQUOTEPRICE,MSt.FEEDBACKMSG,MSt.ACTIVATEDT,
					MSt.CREATEDDT,MSt.REFORDERID,MSt.REFUSERNAME,MSt.TXDATE,MSt.TXNUM,MSt.EFFDATE,
					MSt.EXPDATE,MSt.BRATIO,MSt.VIA,MSt.DELTD,MSt.OUTPRICEALLOW,MSt.USERNAME,
					 SEC.TRADEPLACE, SEC.SECTYPE, SEC.PARVALUE, INF.TRADELOT,
               INF.TRADEUNIT, INF.SECUREDRATIOMIN, INF.SECUREDRATIOMAX,INF.CEILINGPRICE,INF.FLOORPRICE,INF.MARGINPRICE
          FROM FOMAST MST, SBSECURITIES SEC, SECURITIES_INFO INF,CURR_SEC_INFO CURRINF
         WHERE MST.DELTD<>'Y' AND MST.BOOK = 'A' AND  MST.REMAINQTTY>0
           AND MST.EXECTYPE IN ('NB','BC') AND PRICETYPE='SL'
           AND MST.TIMETYPE = 'G'
           AND MST.STATUS = 'P'
           AND MST.CODEID = SEC.CODEID
           AND SEC.TRADEPLACE='001'
           AND MST.CODEID = INF.CODEID
           AND INF.SYMBOL = TRIM(CURRINF.CODE)
           AND MATCH_PRICE>0
           AND MATCH_PRICE*10<=PRICE * INF.TRADEUNIT
           AND MST.EFFDATE <= v_txDate
           AND CHECKGTCBUYORDER(mst.afacctno,MST.REMAINQTTY,
                            (CASE WHEN MST.QUOTEPRICE>INF.CEILINGPRICE/INF.TRADEUNIT THEN INF.CEILINGPRICE/INF.TRADEUNIT
                                 WHEN MST.QUOTEPRICE<INF.FLOORPRICE/INF.TRADEUNIT THEN INF.FLOORPRICE/INF.TRADEUNIT
                                 else MST.QUOTEPRICE
                             END),
                            MST.BRATIO,SEC.SYMBOL
                )>=0
        UNION
        SELECT MST.ACCTNO,MSt.ACTYPE,MSt.AFACCTNO,MSt.STATUS,MSt.EXECTYPE,PRICETYPE,MSt.TIMETYPE,
					MSt.MATCHTYPE,MSt.NORK,MSt.CLEARCD,MSt.CLEARDAY,MSt.CODEID,MSt.SYMBOL,MSt.QUANTITY,
					PRICE/1000,MSt.QUOTEPRICE,MSt.TRIGGERPRICE,MSt.EXECQTTY,MSt.EXECAMT,MSt.REMAINQTTY,
					MSt.CANCELQTTY,MSt.AMENDQTTY,MSt.CONFIRMEDVIA,MSt.BOOK,MSt.ORGACCTNO,MSt.REFACCTNO,
					MSt.REFQUANTITY,MSt.REFPRICE,MSt.REFQUOTEPRICE,MSt.FEEDBACKMSG,MSt.ACTIVATEDT,
					MSt.CREATEDDT,MSt.REFORDERID,MSt.REFUSERNAME,MSt.TXDATE,MSt.TXNUM,MSt.EFFDATE,
					MSt.EXPDATE,MSt.BRATIO,MSt.VIA,MSt.DELTD,MSt.OUTPRICEALLOW,MSt.USERNAME,
					 SEC.TRADEPLACE, SEC.SECTYPE, SEC.PARVALUE, INF.TRADELOT,
               INF.TRADEUNIT, INF.SECUREDRATIOMIN, INF.SECUREDRATIOMAX,INF.CEILINGPRICE,INF.FLOORPRICE,INF.MARGINPRICE
                 FROM FOMAST MST, SBSECURITIES SEC, SECURITIES_INFO INF,SEMAST SE,CURR_SEC_INFO CURRINF,v_getsellorderinfo V
         WHERE MST.DELTD<>'Y' AND MST.BOOK = 'A' AND  MST.REMAINQTTY>0
           AND SE.ACCTNO=V.seacctno(+)
           AND MST.EXECTYPE IN ('MS','SS','NS')  AND PRICETYPE='SL'
           AND MST.TIMETYPE = 'G'
           AND MST.STATUS = 'P'
           AND MST.CODEID = SEC.CODEID
           AND SEC.TRADEPLACE='001'
          AND (MST.outpriceallow='Y' or (MST.outpriceallow='N' and mst.quoteprice*INF.TRADEUNIT>=INF.FLOORPRICE and mst.quoteprice*INF.TRADEUNIT<=INF.CEILINGPRICE ))
           AND MST.CODEID = INF.CODEID
           AND INF.SYMBOL = TRIM(CURRINF.CODE)
           AND MATCH_PRICE>0
           AND MATCH_PRICE*10>=PRICE * INF.TRADEUNIT
           AND MST.EFFDATE <= v_txDate
           AND SE.ACCTNO =MST.AFACCTNO || MST.CODEID
           AND (CASE WHEN MST.EXECTYPE='MS' THEN SE.MORTAGE-nvl(v.securemtg,0) ELSE SE.TRADE-nvl(V.secureamt,0) END)  >= MST.REMAINQTTY) ORDER BY TO_DATE(SUBSTR(ACCTNO,5,6),'DDMMYY'), SUBSTR(ACCTNO,11,6) ;

    elsif v_FunType = 'SL-HA' then
        OPEN PV_REFCURSOR FOR
        SELECT * FROM (SELECT MST.ACCTNO,MSt.ACTYPE,MSt.AFACCTNO,MSt.STATUS,MSt.EXECTYPE,PRICETYPE,MSt.TIMETYPE,
					MSt.MATCHTYPE,MSt.NORK,MSt.CLEARCD,MSt.CLEARDAY,MSt.CODEID,MSt.SYMBOL,MSt.QUANTITY,
					PRICE/1000,MSt.QUOTEPRICE,MSt.TRIGGERPRICE,MSt.EXECQTTY,MSt.EXECAMT,MSt.REMAINQTTY,
					MSt.CANCELQTTY,MSt.AMENDQTTY,MSt.CONFIRMEDVIA,MSt.BOOK,MSt.ORGACCTNO,MSt.REFACCTNO,
					MSt.REFQUANTITY,MSt.REFPRICE,MSt.REFQUOTEPRICE,MSt.FEEDBACKMSG,MSt.ACTIVATEDT,
					MSt.CREATEDDT,MSt.REFORDERID,MSt.REFUSERNAME,MSt.TXDATE,MSt.TXNUM,MSt.EFFDATE,
					MSt.EXPDATE,MSt.BRATIO,MSt.VIA,MSt.DELTD,MSt.OUTPRICEALLOW,MSt.USERNAME,
					 SEC.TRADEPLACE, SEC.SECTYPE, SEC.PARVALUE, INF.TRADELOT,
               INF.TRADEUNIT, INF.SECUREDRATIOMIN, INF.SECUREDRATIOMAX,INF.CEILINGPRICE,INF.FLOORPRICE,INF.MARGINPRICE
          FROM FOMAST MST, SBSECURITIES SEC, SECURITIES_INFO INF,CURR_SEC_INFO CURRINF
         WHERE MST.DELTD<>'Y' AND MST.BOOK = 'A' AND  MST.REMAINQTTY>0
           AND MST.EXECTYPE IN ('NB','BC') AND PRICETYPE='SL'
           AND MST.TIMETYPE = 'G'
           AND MST.STATUS = 'P'
           AND MST.CODEID = SEC.CODEID
           AND SEC.TRADEPLACE='002'
           AND MST.CODEID = INF.CODEID
           AND INF.SYMBOL = TRIM(CURRINF.CODE)
           AND MATCH_PRICE>0
           AND MATCH_PRICE<=PRICE * INF.TRADEUNIT
           AND MST.EFFDATE <= v_txDate
           AND CHECKGTCBUYORDER(mst.afacctno,MST.REMAINQTTY,
                            (CASE WHEN MST.QUOTEPRICE>INF.CEILINGPRICE/INF.TRADEUNIT THEN INF.CEILINGPRICE/INF.TRADEUNIT
                                 WHEN MST.QUOTEPRICE<INF.FLOORPRICE/INF.TRADEUNIT THEN INF.FLOORPRICE/INF.TRADEUNIT
                                 else MST.QUOTEPRICE END),
                            MST.BRATIO,SEC.SYMBOL
                )>=0

        UNION
        SELECT MST.ACCTNO,MSt.ACTYPE,MSt.AFACCTNO,MSt.STATUS,MSt.EXECTYPE,PRICETYPE,MSt.TIMETYPE,
					MSt.MATCHTYPE,MSt.NORK,MSt.CLEARCD,MSt.CLEARDAY,MSt.CODEID,MSt.SYMBOL,MSt.QUANTITY,
					PRICE/1000,MSt.QUOTEPRICE,MSt.TRIGGERPRICE,MSt.EXECQTTY,MSt.EXECAMT,MSt.REMAINQTTY,
					MSt.CANCELQTTY,MSt.AMENDQTTY,MSt.CONFIRMEDVIA,MSt.BOOK,MSt.ORGACCTNO,MSt.REFACCTNO,
					MSt.REFQUANTITY,MSt.REFPRICE,MSt.REFQUOTEPRICE,MSt.FEEDBACKMSG,MSt.ACTIVATEDT,
					MSt.CREATEDDT,MSt.REFORDERID,MSt.REFUSERNAME,MSt.TXDATE,MSt.TXNUM,MSt.EFFDATE,
					MSt.EXPDATE,MSt.BRATIO,MSt.VIA,MSt.DELTD,MSt.OUTPRICEALLOW,MSt.USERNAME,
					 SEC.TRADEPLACE, SEC.SECTYPE, SEC.PARVALUE, INF.TRADELOT,
               INF.TRADEUNIT, INF.SECUREDRATIOMIN, INF.SECUREDRATIOMAX,INF.CEILINGPRICE,INF.FLOORPRICE,INF.MARGINPRICE
                 FROM FOMAST MST, SBSECURITIES SEC, SECURITIES_INFO INF,SEMAST SE,CURR_SEC_INFO CURRINF  ,v_getsellorderinfo V
         WHERE MST.DELTD<>'Y' AND MST.BOOK = 'A' AND  MST.REMAINQTTY>0
           AND SE.ACCTNO=V.seacctno(+)
           AND MST.EXECTYPE IN ('MS','SS','NS')  AND PRICETYPE='SL'
           AND MST.TIMETYPE = 'G'
           AND MST.STATUS = 'P'
           AND MST.CODEID = SEC.CODEID
           AND SEC.TRADEPLACE='002'
          AND (MST.outpriceallow='Y' or (MST.outpriceallow='N' and mst.quoteprice*INF.TRADEUNIT>=INF.FLOORPRICE and mst.quoteprice*INF.TRADEUNIT<=INF.CEILINGPRICE ))
           AND MST.CODEID = INF.CODEID
           AND INF.SYMBOL = TRIM(CURRINF.CODE)
           AND MATCH_PRICE>0
           AND MATCH_PRICE>=PRICE * INF.TRADEUNIT
           AND MST.EFFDATE <=v_txDate
           AND SE.ACCTNO =MST.AFACCTNO || MST.CODEID
           AND (CASE WHEN MST.EXECTYPE='MS' THEN SE.MORTAGE-nvl(v.securemtg,0) ELSE SE.TRADE-nvl(V.secureamt,0) END)  >= MST.REMAINQTTY) ORDER BY TO_DATE(SUBSTR(ACCTNO,5,6),'DDMMYY'), SUBSTR(ACCTNO,11,6);
    end if;
EXCEPTION
    WHEN others THEN
        return;
END;
/
