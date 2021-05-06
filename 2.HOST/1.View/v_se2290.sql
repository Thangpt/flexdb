CREATE OR REPLACE VIEW V_SE2290 AS
(
SELECT cf.custodycd, SE.AFACCTNO, SE.ACCTNO, SEIN.SYMBOL, AC.CDCONTENT STATUS, SE.TRADE,
least(nvl(dtl.qtty,0),SE.DTOCLOSE) DTBLOCKED, SE.DTOCLOSE,
nvl(schd.SENDPBALANCE,0) SENDPBALANCE ,nvl(schd.SENDAMT,0) SENDAMT ,nvl(schd.SENDAQTTY,0) SENDAQTTY,
nvl(schd.RIGHTQTTY,0) RIGHTQTTY ,nvl(schd.QTTY,0) QTTY, NVL(pit.pitqtty,0) pitqtty
FROM (SELECT ACCTNO,ACTYPE,CODEID,AFACCTNO,OPNDATE,CLSDATE,LASTDATE,STATUS,PSTATUS,IRTIED,IRCD,COSTPRICE,TRADE,MORTAGE,MARGIN,
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
) SE, SECURITIES_INFO SEIN, ALLCODE AC, AFMAST AF, CFMAST CF,
    (
    select acctno, sum(qtty) qtty from semastdtl where status ='F' and qtty>0
    group by acctno
    ) dtl,
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
           FROM caschd schd ,camast WHERE schd.camastid=camast.camastid AND schd.deltd='N' AND camast.deltd='N' AND camast.status <> 'C'
           UNION ALL
           SELECT  schd.status,camast.catype,camast.duedate,camast.status castatus,schd.afacctno, camast.tocodeid codeid,
           '',schd.camastid,0,schd.qtty,0,0,0,0,0,
            schd.isci,schd.isexec  ,0,0,0,  SENDQTTY
           FROM caschd schd, camast
           WHERE schd.camastid=camast.camastid AND camast.catype IN ('017','020','023')AND schd.deltd='N' AND camast.deltd='N' AND camast.status <> 'C'

      ) schd, camast ca
 WHERE schd.camastid=ca.camastid

 GROUP BY (schd.afacctno,schd.codeid)

) WHERE SENDPBALANCE+SENDAMT+SENDAQTTY+RIGHTQTTY+QTTY>0
) schd,
(select acctno, sum(caqtty) pitqtty 
   from se2247_log
  where qtty > 0 and deltd <>'Y'
  group by acctno ) pit
WHERE SE.CODEID = SEIN.CODEID
      AND SE.STATUS = 'N'
      AND SE.STATUS = AC.CDVAL
      AND AC.CDTYPE = 'SE'
      and af.acctno = se.afacctno
      AND AF.Custid = cf.custid
      AND AC.CDNAME = 'STATUS'
      and se.acctno = dtl.acctno(+)
      AND (NVL(se.DTOCLOSE,0) > 0 OR (schd.SENDPBALANCE+schd.SENDAMT+schd.SENDAQTTY+schd.RIGHTQTTY+schd.QTTY>0))
      AND se.acctno=schd.seacctno(+)
      AND se.acctno = pit.acctno (+)
)
;

