CREATE OR REPLACE FORCE VIEW V_CA_INFO AS
(
    SELECT max(codeid)codeid,max(afacctno) afacctno,max(ISDBSEALL) ISDBSEALL,max(schd.seacctno)seacctno,
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
                     ) schd GROUP BY (codeid, afacctno)

);

