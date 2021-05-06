CREATE OR REPLACE FORCE VIEW V_SE2248 AS
(
SELECT   SUBSTR(SEMAST.ACCTNO,1,4) || '.' || SUBSTR(SEMAST.ACCTNO,5,6) || '.' || SUBSTR(SEMAST.ACCTNO,11,6) ACCTNO, SYM.SYMBOL,
SUBSTR(SEMAST.AFACCTNO,1,4) || '.' || SUBSTR(SEMAST.AFACCTNO,5,6) AFACCTNO,
SEMAST.DTOCLOSE DTOCLOSE,SEMAST.CODEID,SYM.PARVALUE, SEMAST.LASTDATE SELASTDATE, AF.LASTDATE AFLASTDATE, NVL(SEMAST.LASTDATE,AF.LASTDATE) LASTDATE,
CF.CUSTODYCD, CF.FULLNAME, CF.IDCODE, TYP.TYPENAME, A1.CDCONTENT TRADEPLACE,
nvl(SENDPBALANCE,0) SENDPBALANCE ,nvl(SENDAMT,0) SENDAMT ,nvl(SENDAQTTY,0) SENDAQTTY,
nvl(RIGHTQTTY,0) RIGHTQTTY ,nvl(QTTY,0) QTTY
FROM
(SELECT ACCTNO,ACTYPE,CODEID,AFACCTNO,OPNDATE,CLSDATE,LASTDATE,STATUS,PSTATUS,IRTIED,IRCD,COSTPRICE,TRADE,MORTAGE,MARGIN,
             NETTING,STANDING,WITHDRAW,DEPOSIT,LOAN,BLOCKED,RECEIVING,TRANSFER,PREVQTTY,DCRQTTY,DCRAMT,DEPOFEEACR,REPO,
             PENDING,TBALDEPO,CUSTID,COSTDT,SECURED,ICCFCD,ICCFTIED,TBALDT,SENDDEPOSIT,SENDPENDING,DDROUTQTTY,DDROUTAMT,DTOCLOSE,
             SDTOCLOSE,QTTY_TRANSFER,LAST_CHANGE,TOTALBUYAMT,TOTALSELLAMT,TOTALSELLQTTY,ACCUMULATEPNL,DEALINTPAID,WTRADE,GRPORDAMT
      FROM SEMAST
      UNION ALL -- union them nhung tk co CA cho ve ma ko co SEMAST
      SELECT   distinct(schd.afacctno||schd.codeid) acctno,NULL,schd.CODEID, schd.AFACCTNO,NULL,NULL,NULL,'N',NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      af.custid,NULL,0,NULL,NULL,NULL,0,0,0,0,0,0,0,NULL,0,0,0,NULL,NULL,NULL,NULL
      FROM (SELECT afacctno,codeid FROM caschd WHERE deltd='N'
            UNION ALL
            SELECT afacctno,tocodeid codeid FROM caschd, camast WHERE caschd.camastid=camast.camastid
                                                         AND caschd.deltd='N' AND catype IN ('017','020','023')) schd,
            afmast af
      WHERE (afacctno,codeid) NOT IN (SELECT afacctno,codeid FROM semast)
      AND af.acctno=schd.afacctno
)SEMAST,
 SBSECURITIES SYM, AFMAST AF, AFTYPE TYP, CFMAST CF, ALLCODE A1,
(SELECT * FROM (SELECT  schd.codeid, schd.afacctno,(schd.afacctno||schd.codeid) seacctno,
 SUM(schd.SENDPBALANCE) SENDPBALANCE ,
 sum(schd.SENDAMT) SENDAMT ,
 sum(SENDAQTTY) SENDAQTTY,
 SUM(CASE WHEN (ca.catype IN ('005','006','022')) THEN schd.SENDQTTY ELSE 0 END) RIGHTQTTY,
 SUM(CASE WHEN (ca.catype NOT IN ('005','006','022'))THEN schd.SENDQTTY ELSE 0 END) QTTY
 FROM (
          SELECT schd.status,camast.catype,camast.duedate,camast.status castatus,schd.afacctno,camast.codeid,
           camast.tocodeid, schd.camastid,schd.balance,schd.qtty,schd.aqtty,schd.amt,schd.aamt,schd.pbalance,schd.pqtty ,
           schd.isci,schd.isexec ,SENDPBALANCE,SENDAMT,SENDAQTTY,
           (CASE WHEN (catype IN ('017','020','023')) THEN 0 ELSE SENDQTTY END )SENDQTTY
           FROM caschd schd ,camast WHERE schd.camastid=camast.camastid AND schd.deltd='N' AND camast.deltd='N'
           UNION ALL
           SELECT  schd.status,camast.catype,camast.duedate,camast.status castatus,schd.afacctno, camast.tocodeid codeid,
           '',schd.camastid,0,schd.qtty,0,0,0,0,0,
            schd.isci,schd.isexec  ,0,0,0,  SENDQTTY
           FROM caschd schd, camast
           WHERE schd.camastid=camast.camastid AND camast.catype IN ('017','020','023')AND schd.deltd='N' AND camast.deltd='N'

      ) schd, camast ca
 WHERE schd.camastid=ca.camastid

 GROUP BY (schd.afacctno,schd.codeid)

) WHERE SENDPBALANCE+SENDAMT+SENDAQTTY+RIGHTQTTY+QTTY>0
) schd
WHERE A1.CDTYPE = 'SA' AND A1.CDNAME = 'TRADEPLACE' AND A1.CDVAL = SYM.TRADEPLACE
AND CF.CUSTID =AF.CUSTID AND SYM.CODEID = SEMAST.CODEID AND SEMAST.AFACCTNO= AF.ACCTNO
AND TYP.ACTYPE=AF.ACTYPE AND SEMAST.STATUS ='N' AND (NVL(SEMAST.DTOCLOSE,0) > 0 OR (SENDPBALANCE+SENDAMT+SENDAQTTY+RIGHTQTTY+QTTY>0))
AND semast.acctno=schd.seacctno(+)
)
;

