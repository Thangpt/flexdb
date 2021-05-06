CREATE OR REPLACE FORCE VIEW V_SE2247 AS
(SELECT SUBSTR(SEMAST.ACCTNO,1,4) || '.' || SUBSTR(SEMAST.ACCTNO,5,6) || '.' || SUBSTR(SEMAST.ACCTNO,11,6) ACCTNO, SYM.SYMBOL, SUBSTR(SEMAST.AFACCTNO,1,4) || '.' || SUBSTR(SEMAST.AFACCTNO,5,6) AFACCTNO,
SEMAST.TRADE TRADE, SEMAST.BLOCKED BLOCKED,SEMAST.CODEID, SYM.PARVALUE, SEMAST.LASTDATE SELASTDATE, AF.LASTDATE AFLASTDATE, NVL(SEMAST.LASTDATE,AF.LASTDATE) LASTDATE,
CF.CUSTODYCD,
CF.FULLNAME, CF.IDCODE, TYP.TYPENAME, A1.CDCONTENT TRADEPLACE, ft.minval, ft.maxval,
SENDSETOCLOSE.REFCUSTODYCD,SENDSETOCLOSE.REFINWARD,
nvl(SCHD.RIGHTQTTY,0) RIGHTQTTY,nvl(SCHD.RIGHTOFFQTTY,0) RIGHTOFFQTTY,nvl(SCHD.CAQTTYRECEIV,0)CAQTTYRECEIV,
NVL((CASE WHEN SCHD.ISDBSEALL=1 THEN SEMAST.TRADE ELSE SCHD.CAQTTYDB END),0) CAQTTYDB,
nvl(schd.CAAMTRECEIV,0) CAAMTRECEIV

FROM (SELECT ACCTNO,ACTYPE,CODEID,AFACCTNO,OPNDATE,CLSDATE,LASTDATE,STATUS,PSTATUS,IRTIED,IRCD,COSTPRICE,TRADE,MORTAGE,MARGIN,
             NETTING,STANDING,WITHDRAW,DEPOSIT,LOAN,BLOCKED,RECEIVING,TRANSFER,PREVQTTY,DCRQTTY,DCRAMT,DEPOFEEACR,REPO,
             PENDING,TBALDEPO,CUSTID,COSTDT,SECURED,ICCFCD,ICCFTIED,TBALDT,SENDDEPOSIT,SENDPENDING,DDROUTQTTY,DDROUTAMT,DTOCLOSE,
             SDTOCLOSE,QTTY_TRANSFER,LAST_CHANGE,TOTALBUYAMT,TOTALSELLAMT,TOTALSELLQTTY,ACCUMULATEPNL,DEALINTPAID,WTRADE,GRPORDAMT
      FROM SEMAST
      UNION ALL -- union them nhung tk co CA cho ve ma ko co SEMAST
      SELECT   distinct(schd.afacctno||schd.codeid) acctno,NULL,schd.CODEID, schd.AFACCTNO,NULL,NULL,NULL,'A',NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      af.custid,NULL,0,NULL,NULL,NULL,0,0,0,0,0,0,0,NULL,0,0,0,NULL,NULL,NULL,NULL
      FROM (SELECT afacctno,codeid FROM caschd WHERE deltd='N'
            UNION ALL
            SELECT afacctno,tocodeid codeid FROM caschd, camast WHERE caschd.camastid=camast.camastid
                                                         AND caschd.deltd='N' AND catype IN ('017','020','023')) schd,
            afmast af
      WHERE (afacctno,codeid) NOT IN (SELECT afacctno,codeid FROM semast)
      AND af.acctno=schd.afacctno) SEMAST,
SBSECURITIES SYM,
(SELECT * FROM afmast
          WHERE custid NOT IN (SELECT distinct(custid) custid FROM afmast WHERE status NOT IN ('N','C'))) AF,
AFTYPE TYP, CFMAST CF,CIMAST CI, ALLCODE A1, FEEMASTER FT, FEEMAP FM,
(
SELECT CUSTID FROM

(
SELECT CUSTID from
(SELECT  CUSTID , AFACCTNO  FROM SEMAST ,sbsecurities sym
              where  semast.codeid=sym.codeid
              and sym.sectype <> '004'
              GROUP BY  CUSTID , AFACCTNO HAVING SUM (trade + blocked + mortage + margin +
              abs(netting) + withdraw + deposit + receiving +
              senddeposit)<> 0 )A
GROUP BY CUSTID
HAVING COUNT(AFACCTNO)=1
  UNION ALL
  (
  SELECT distinct(custid)
   FROM
          (SELECT afacctno FROM
                   (SELECT afacctno,codeid FROM caschd WHERE deltd='N'
                    UNION ALL
                    SELECT afacctno,tocodeid codeid FROM caschd, camast
                    WHERE caschd.camastid=camast.camastid
                    AND caschd.deltd='N' AND catype IN ('017','020','023'))
         WHERE (afacctno) NOT IN (SELECT afacctno FROM semast)) se, afmast af
   WHERE se.afacctno=af.acctno

  ))
) se2,
(SELECT * FROM SENDSETOCLOSE where deltd='N') SENDSETOCLOSE,
(SELECT max(codeid)codeid,max(afacctno) afacctno,max(ISDBSEALL) ISDBSEALL,max(schd.seacctno)seacctno,
SUM(RIGHTOFFQTTY) RIGHTOFFQTTY,SUM(CAQTTYRECEIV) CAQTTYRECEIV,
SUM(CAQTTYDB) CAQTTYDB,SUM(CAAMTRECEIV) CAAMTRECEIV,SUM(RIGHTQTTY) RIGHTQTTY,
SUM(CASE WHEN ISWFT='N' THEN CAQTTYRECEIV ELSE 0 END ) CARECEIVING
FROM
(SELECT
    schd.codeid, schd.afacctno,(schd.afacctno||schd.codeid) seacctno,
   (CASE WHEN (schd.catype='014' AND schd.castatus NOT IN ('A','P','N','C') AND schd.duedate >=GETCURRDATE )
      THEN schd.pbalance ELSE 0 END) RIGHTOFFQTTY,
   (CASE WHEN (schd.catype='014' AND schd.status IN ('M','S','I','G','O','W') AND isse='N' ) THEN schd.qtty
       WHEN (schd.catype IN ('017','020','023') AND schd.status IN ('G','S','I','O','W') AND isse='N' AND istocodeid='Y' ) THEN schd.qtty
       WHEN (schd.catype IN ('011','021') AND schd.status  IN ('G','S','I','O','W') AND isse='N' ) THEN schd.qtty
       ELSE 0 END) CAQTTYRECEIV,
   (CASE WHEN (schd.catype IN ('017','020','023','027') AND schd.status  IN ('G','S','I','O','W') AND isse='N') THEN schd.aqtty
         ELSE 0 END) CAQTTYDB,
  ( CASE  WHEN (schd.catype IN ('016') AND schd.status  IN ('G','S','I','O','W')) AND isse='N' THEN 1 ELSE 0 END) ISDBSEALL,
  (CASE WHEN  (schd.status  IN ('H','S','I','O','W')AND isci='N' AND schd.isexec='Y') THEN schd.amt ELSE 0 END) CAAMTRECEIV,
  (CASE WHEN (schd.catype IN ('005','006','022') AND schd.status IN ('H','G','S','I','J','O','W') AND isse='N') THEN schd.rqtty ELSE 0 END) RIGHTQTTY,
  iswft

    FROM
          (SELECT schd.rqtty,schd.status,camast.catype,camast.duedate,camast.status castatus,schd.afacctno,camast.codeid,
           camast.tocodeid, schd.camastid,schd.balance,schd.qtty,schd.aqtty,schd.amt,schd.aamt,schd.pbalance,schd.pqtty ,
           schd.isci,schd.isexec ,'N' istocodeid,NVL(ISWFT,'Y') ISWFT,schd.isse
           FROM caschd schd ,camast WHERE schd.camastid=camast.camastid AND schd.deltd='N' AND camast.deltd='N' AND camast.status <> 'C'
           UNION ALL
           SELECT schd.rqtty, schd.status,camast.catype,camast.duedate,camast.status castatus,schd.afacctno, camast.tocodeid codeid,
           '',schd.camastid,0,schd.qtty,0,0,0,0,0,
            schd.isci,schd.isexec ,'Y' istocodeid, NVL(ISWFT,'Y') ISWFT,schd.isse
           FROM caschd schd, camast
           WHERE schd.camastid=camast.camastid AND camast.catype IN ('017','020','023') AND schd.deltd='N' AND camast.deltd='N' AND camast.status <> 'C'
           ) SCHD
         ) schd GROUP BY (codeid, afacctno) ) schd
WHERE A1.CDTYPE = 'SA' AND A1.CDNAME = 'TRADEPLACE' AND A1.CDVAL = SYM.TRADEPLACE
AND CF.CUSTID =AF.CUSTID AND SYM.CODEID = SEMAST.CODEID AND SEMAST.AFACCTNO= AF.ACCTNO and sym.sectype <> '004'
AND TYP.ACTYPE=AF.ACTYPE AND AF.status ='N'
and ft.feecd = fm.feecd and ft.status = 'Y' and fm.tltxcd = '2247'
and AF.ACCTNO = CI.AFACCTNO
AND semast.custid=se2.custid(+)
and (abs(semast.netting)+semast.deposit+semast.senddeposit+semast.receiving- nvl(schd.CARECEIVING,0)  )=0
and (semast.trade + semast.mortage +semast.blocked+ semast.withdraw+
nvl(SCHD.RIGHTQTTY,0) +nvl(SCHD.CAQTTYRECEIV,0)+nvl(SCHD.RIGHTOFFQTTY,0)+
NVL((CASE WHEN SCHD.ISDBSEALL=1 THEN SEMAST.TRADE ELSE SCHD.CAQTTYDB END),0)+
nvl(schd.CAAMTRECEIV,0)) >0
and af.CUSTID=sendsetoclose.CUSTID(+)
AND semast.acctno=schd.seacctno(+) )
;

