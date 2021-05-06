CREATE OR REPLACE FORCE VIEW VW_STRADE_SUBACCOUNT_OD AS
SELECT "AFACCTNO",
    "CUSTID",
    "CUSTODYCD",
    "ORDERID",
    "REFORDERID",
    "TRADEPLACE",
    "SYMBOL",
    "TYPENAME",
    "TXNUM",
    "TXDATE",
    "EXPDATE",
    "BRATIO",
    "ORSTATUS",
    "EDSTATUS",
    "VIA",
    "MAKETIME",
    "SENDTIME",
    "TIMETYPE",
    "EXECTYPE",
    "NORK",
    "MATCHTYPE",
    "CLEARDAY",
    "CLEARCD",
    "PRICETYPE",
    "QUOTEPRICE",
    "STOPPRICE",
    "LIMITPRICE",
    "ORDERQTTY",
    "REMAINQTTY",
    "EXECQTTY",
    "EXECAMT",
    "STANDQTTY",
    "CANCELQTTY",
    "ADJUSTQTTY",
    "REJECTQTTY",
    "REJECTCD",
    "EXPRICE",
    "EXQTTY",
    "EXAMT",
    "DELTD",
    "LAST_CHANGE",
    "FEEDBACKMSG",
    "BOOK",
    "CANCELSTATUS",
    "AMENDSTATUS",
    "CURRSECSSION",
    "ODSECSSION",
    "MAKER",
    "CODEID",
    "REFFOORDERID"
  FROM
    (SELECT MST.AFACCTNO,
      CFMAST.CUSTID,
      CFMAST.CUSTODYCD,
      MST.ORDERID,
      MST.REFORDERID,
      TO_CHAR (CD1.CDCONTENT) TRADEPLACE,
      TO_CHAR (sb.SYMBOL) SYMBOL,
      OT.TYPENAME,
      TO_CHAR (MST.TXNUM) TXNUM,
      MST.TXDATE,
      MST.EXPDATE,
      MST.BRATIO,
      (
      CASE
        WHEN MST.REMAINQTTY <> 0
        AND MST.EDITSTATUS   = 'C'
        THEN 'C'
        WHEN MST.REMAINQTTY <> 0
        AND MST.EDITSTATUS   = 'A'
        THEN 'A'
        WHEN MST.EDITSTATUS IS NULL
        AND MST.CANCELQTTY  <> 0
        THEN '5'
        WHEN MST.REMAINQTTY = 0
        AND MST.CANCELQTTY <> 0
        AND MST.EDITSTATUS  ='C'
        THEN '3'
        WHEN MST.REMAINQTTY = 0
        AND MST.ADJUSTQTTY  >0
        THEN '10'
        ELSE MST.ORSTATUS
      END) ORSTATUS,
      MST.EDSTATUS,
      mst.VIA,
      mst.txtime MAKETIME,
      MST.SENDTIME,
      MST.TIMETYPE,
      MST.EXECTYPE,
      MST.NORK,
      MST.MATCHTYPE,
      MST.CLEARDAY,
      MST.CLEARCD,
      MST.PRICETYPE,
      MST.QUOTEPRICE,
      MST.STOPPRICE,
      MST.LIMITPRICE,
      MST.ORDERQTTY,
      MST.REMAINQTTY,
      MST.EXECQTTY,
      MST.EXECAMT,
      MST.STANDQTTY,
      MST.CANCELQTTY,
      MST.ADJUSTQTTY,
      MST.REJECTQTTY,
      MST.REJECTCD,
      MST.EXPRICE,
      MST.EXQTTY,
      MST.EXAMT,
      MST.DELTD,
      MST.LAST_CHANGE,
      TO_CHAR (CD0.cdcontent) feedbackmsg,
      'A' BOOK,
      (
      CASE
        WHEN MST.CANCELQTTY > 0
        THEN 'Cancelled'
        WHEN MST.EDITSTATUS = 'C'
        THEN 'Cancelling'
        ELSE '----'
      END) CANCELSTATUS,
      (
      CASE
        WHEN MST.ADJUSTQTTY > 0
        THEN 'Amended'
        WHEN MST.EDITSTATUS = 'A'
        THEN 'Amending'
        ELSE '----'
      END) AMENDSTATUS,
      SYS.SYSVALUE CURRSECSSION,
      MST.HOSESESSION ODSECSSION,
      NVL (f.username, NVL (mk.tlname, 'Auto')) maker,
      MST.CODEID,
      NVL (f.acctno, MST.ORDERID) REFFOORDERID
    FROM CFMAST,
      AFMAST CF,
      (SELECT OD1.*,
        OD2.EDSTATUS EDITSTATUS,
        OOD.TXTIME SENDTIME
      FROM odmast OD1,
        (SELECT * FROM ODMAST WHERE EDSTATUS IN ('C', 'A')
        ) OD2,
        OOD
      WHERE OD1.orderid = OOD.ORGORDERID
      AND OD1.ORDERID   = OD2.REFORDERID(+)
      ) MST,
      TLLOG TL,
      sbsecurities sb,
      ALLCODE CD0,
      ALLCODE CD1,
      ORDERSYS SYS,
      tlprofiles mk,
      fomast f,
      ODTYPE OT
    WHERE MST.ORSTATUS <> '7'
    AND CF.ACCTNO       = MST.AFACCTNO
    AND MST.TXNUM       = TL.TXNUM
    AND MST.TXDATE      = TL.TXDATE
    AND TL.TXSTATUS     = '1'
    AND CFMAST.CUSTID   = CF.CUSTID
    AND sb.codeid       = mst.codeid
    AND CD0.CDNAME      = 'ORSTATUS'
    AND CD0.CDTYPE      = 'OD'
    AND CD0.CDVAL       = MST.ORSTATUS
    AND CD1.CDTYPE      = 'OD'
    AND CD1.CDNAME      = 'TRADEPLACE'
    AND CD1.CDVAL       = sb.TRADEPLACE
    AND SYS.SYSNAME     = 'CONTROLCODE'
    AND MST.TXDATE      =
      (SELECT TO_DATE (VARVALUE, 'DD/MM/YYYY')
      FROM SYSVAR
      WHERE GRNAME = 'SYSTEM'
      AND VARNAME  = 'CURRDATE'
      )
    AND tl.tlid      = mk.tlid(+)
    AND mst.orderid  = f.orgacctno(+)
    AND mst.exectype = f.exectype(+)
    AND MST.ACTYPE   = OT.ACTYPE
    UNION ALL
    SELECT MST.AFACCTNO,
      CFMAST.CUSTID,
      CFMAST.CUSTODYCD,
      MST.ACCTNO ORDERID,
      '' REFORDERID,
      TO_CHAR (CD1.CDCONTENT) TRADEPLACE,
      MST.SYMBOL,
      OT.TYPENAME,
      TO_CHAR (REFOD.TXNUM) TXNUM,
      REFOD.TXDATE,
      REFOD.EXPDATE,
      MST.BRATIO,
      (
      CASE
        WHEN REFOD.REMAINQTTY <> 0
        AND REFOD.EDITSTATUS   = 'C'
        THEN 'C'
        WHEN REFOD.REMAINQTTY <> 0
        AND REFOD.EDITSTATUS   = 'A'
        THEN 'A'
        WHEN REFOD.EDITSTATUS IS NULL
        AND REFOD.CANCELQTTY  <> 0
        THEN '5'
        WHEN REFOD.REMAINQTTY = 0
        AND REFOD.CANCELQTTY <> 0
        AND REFOD.EDITSTATUS  ='C'
        THEN '3'
        WHEN REFOD.REMAINQTTY = 0
        AND REFOD.ADJUSTQTTY  >0
        THEN '10'
        ELSE REFOD.ORSTATUS
      END) ORSTATUS,
      REFOD.EDSTATUS,
      REFOD.VIA,
      SUBSTR (MST.activatedt, 12, 9) MAKETIME,
      REFOD.SENDTIME,
      REFOD.TIMETYPE,
      REFOD.EXECTYPE,
      REFOD.NORK,
      REFOD.MATCHTYPE,
      REFOD.CLEARDAY,
      REFOD.CLEARCD,
      REFOD.PRICETYPE,
      REFOD.QUOTEPRICE,
      REFOD.STOPPRICE,
      REFOD.LIMITPRICE,
      REFOD.ORDERQTTY,
      REFOD.REMAINQTTY,
      REFOD.EXECQTTY,
      REFOD.EXECAMT,
      REFOD.STANDQTTY,
      REFOD.CANCELQTTY,
      REFOD.ADJUSTQTTY,
      REFOD.REJECTQTTY,
      REFOD.REJECTCD,
      REFOD.EXPRICE,
      REFOD.EXQTTY,
      REFOD.EXAMT,
      REFOD.DELTD,
      REFOD.LAST_CHANGE,
      MST.feedbackmsg,
      MST.BOOK BOOK,
      (
      CASE
        WHEN REFOD.CANCELQTTY > 0
        THEN 'Cancelled'
        WHEN REFOD.EDITSTATUS = 'C'
        THEN 'Cancelling'
        ELSE '----'
      END) CANCELSTATUS,
      (
      CASE
        WHEN REFOD.ADJUSTQTTY > 0
        THEN 'Amended'
        WHEN REFOD.EDITSTATUS = 'A'
        THEN 'Amending'
        ELSE '----'
      END) AMENDSTATUS,
      SYS.SYSVALUE CURRSECSSION,
      REFOD.HOSESESSION ODSECSSION,
      MST.Username maker,
      MST.CODEID,
      MST.acctno REFFOORDERID
    FROM CFMAST,
      AFMAST CF,
      ALLCODE CD1,
      FOMAST MST,
      (SELECT OD1.*,
        OD2.EDSTATUS EDITSTATUS,
        OOD.TXTIME SENDTIME
      FROM odmast OD1,
        (SELECT * FROM ODMAST WHERE EDSTATUS IN ('C', 'A')
        ) OD2,
        OOD
      WHERE OD1.ORDERID = OOD.ORGORDERID
      AND OD1.ORDERID   = OD2.REFORDERID(+)
      ) REFOD,
      ORDERSYS SYS,
      sbsecurities sb,
      ODTYPE OT
    WHERE REFOD.ORSTATUS <> '7'
    AND MST.DELTD         = 'N'
    AND CF.ACCTNO         = MST.AFACCTNO
    AND MST.STATUS        = 'A'
    AND MST.acctno        = mst.orgacctno
    AND SYS.SYSNAME       = 'CONTROLCODE'
    AND CFMAST.CUSTID     = CF.CUSTID
    AND REFOD.TXDATE      =
      (SELECT TO_DATE (VARVALUE, 'DD/MM/YYYY')
      FROM SYSVAR
      WHERE GRNAME = 'SYSTEM'
      And Varname  = 'CURRDATE'
      )
    AND MST.ORGACCTNO = REFOD.ORDERID
    AND refod.codeid  = sb.codeid
    AND CD1.CDTYPE    = 'OD'
    AND CD1.CDNAME    = 'TRADEPLACE'
    AND CD1.CDVAL     = sb.TRADEPLACE
    AND MST.ACTYPE    = OT.ACTYPE
    UNION ALL
    SELECT MST.AFACCTNO,
      CFMAST.CUSTID,
      CFMAST.CUSTODYCD,
      MST.ACCTNO ORDERID,
      '' REFORDERID,
      TO_CHAR (CD1.CDCONTENT) TRADEPLACE,
      MST.SYMBOL,
      OT.TYPENAME,
      '' TXNUM,
      TO_DATE (SUBSTR (MST.ACTIVATEDT, 0, 10), 'DD/MM/YYYY') TXDATE,
      TO_DATE (SUBSTR (MST.ACTIVATEDT, 0, 10), 'DD/MM/YYYY') EXPDATE,
      MST.BRATIO,
      MST.STATUS ORSTATUS,
      '' EDSTATUS,
      MST.VIA,
      SUBSTR (MST.activatedt, 12, 9) MAKETIME,
      '' SENDTIME,
      MST.TIMETYPE,
      MST.EXECTYPE,
      MST.NORK,
      MST.MATCHTYPE,
      MST.CLEARDAY,
      MST.CLEARCD,
      MST.PRICETYPE,
      MST.QUOTEPRICE * SYINFO.TRADEUNIT QUOTEPRICE,
      0 STOPPRICE,
      0 LIMITPRICE,
      MST.quantity,
      MST.REMAINQTTY - NVL (ROOT.ORDERQTTY, 0) REMAINQTTY,
      MST.EXECQTTY,
      MST.EXECAMT,
      0 STANDQTTY,
      MST.CANCELQTTY,
      MST.amendqtty ADJUSTQTTY,
      MST.cancelqtty REJECTQTTY,
      '' REJECTCD,
      0 EXPRICE,
      0 EXQTTY,
      0 EXAMT,
      MST.DELTD,
      MST.LAST_CHANGE,
      MST.feedbackmsg,
      MST.BOOK BOOK,
      ('----') CANCELSTATUS,
      ('----') AMENDSTATUS,
      SYS.SYSVALUE CURRSECSSION,
      'N' ODSECSSION,
      MST.Username maker,
      MST.CODEID,
      MST.acctno REFFOORDERID
    FROM CFMAST,
      AFMAST CF,
      FOMAST MST,
      SECURITIES_INFO SYINFO,
      sbsecurities sb,
      ORDERSYS SYS,
      ALLCODE CD1,
      ODTYPE OT,
      (SELECT A.FOACCTNO,
        SUM (B.ORDERQTTY) ORDERQTTY
      FROM ROOTORDERMAP A,
        ODMAST B
      WHERE A.ORDERID = B.ORDERID
      AND STATUS      = 'A'
      GROUP BY A.FOACCTNO
      ) ROOT
    WHERE MST.ACCTNO  = ROOT.FOACCTNO(+)
    AND MST.STATUS   <> 'A'
    AND MST.DELTD     = 'N'
    AND CF.ACCTNO     = MST.AFACCTNO
    AND SYINFO.SYMBOL = MST.SYMBOL
    AND SYS.SYSNAME   = 'CONTROLCODE'
    AND CFMAST.CUSTID = CF.CUSTID
    AND CD1.CDTYPE    = 'OD'
    AND CD1.CDNAME    = 'TRADEPLACE'
    AND CD1.CDVAL     = sb.TRADEPLACE
    AND syinfo.codeid = sb.codeid
    AND MST.ACTYPE    = OT.ACTYPE(+)
    ) DTL
  ORDER BY REFORDERID,
    TXDATE DESC,
    Maketime Desc,
    ORDERID
;

