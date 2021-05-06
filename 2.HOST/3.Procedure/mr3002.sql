CREATE OR REPLACE PROCEDURE mr3002 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   INMONTH        IN       VARCHAR2,
   E_EXCHANGE             IN       VARCHAR2
  )
IS

--
-- BAO CAO DANH MUC CHUNG KHOAN THUC HIEN GIAO DICH KI QUY
-- MODIFICATION HISTORY
-- PERSON       DATE                COMMENTS
-- ---------   ------  -------------------------------------------
-- QUOCTA      27-10-2011           CREATED
--

   CUR                      PKG_REPORT.REF_CURSOR;
   V_STROPTION              VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID                VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0
   p_premonth               number;
   p_preyear                number;
   v_previousmonth               DATE;
   v_thismonth                 DATE;
   v_CurrDate               DATE;
   v_EXCHANGE               VARCHAR2(100);
   V_tradeplace             varchar(3);
   V_BASKET_ID              VARCHAR2(100);
   V_INMONTH   VARCHAR2(2);
   V_INYEAR    VARCHAR2(4);
BEGIN

   V_STROPTION              := OPT;

  IF V_STROPTION = 'A' THEN
      V_STRBRID    := '%';
  ELSIF V_STROPTION = 'B' THEN
      V_STRBRID    := substr(BRID,1,2) || '__' ;
  else
      V_STRBRID    :=BRID;
  END IF;

  if TO_NUMBER(SUBSTR(INMONTH,1,2)) = 1 then
        p_premonth := 12;
        p_preyear := TO_NUMBER(SUBSTR(INMONTH,3,4)) - 1;
  else
        p_premonth := TO_NUMBER(SUBSTR(INMONTH,1,2)) - 1;
        p_preyear := TO_NUMBER(SUBSTR(INMONTH,3,4));
  end if ;

    IF TO_NUMBER(SUBSTR(INMONTH,1,2)) <= 12 THEN
        v_thismonth := last_day (TO_DATE('01/' || SUBSTR(INMONTH,1,2) || '/' || SUBSTR(INMONTH,3,4),'DD/MM/YYYY'));
        v_previousmonth := last_day (TO_DATE('01/' || p_premonth || '/' || p_preyear,'DD/MM/YYYY'));
    else
        v_thismonth := last_day (TO_DATE('31/12/9999','DD/MM/YYYY'));
        v_previousmonth := last_day (TO_DATE('31/11/9999','DD/MM/YYYY'));
    END IF;
    V_INMONTH := SUBSTR(INMONTH,1,2);
    V_INYEAR :=  SUBSTR(INMONTH,3,4);

   v_EXCHANGE:= E_EXCHANGE;

  if instr(v_EXCHANGE,'Minh') <> 0
  then V_tradeplace := '001';
  else V_tradeplace := '002';
  end if;



  SELECT TO_DATE(VARVALUE, SYSTEMNUMS.C_DATE_FORMAT)
  INTO   v_CurrDate
  FROM   SYSVAR
  WHERE  grname = 'SYSTEM' AND varname = 'CURRDATE';

OPEN PV_REFCURSOR
FOR
select nvl(T5,'N') T5,nvl(T4,'N') T4, V_INMONTH v_month, V_INYEAR v_year, v_exchange from
(select * from
(select distinct symbol as T5 from
(
select basketid, symbol , mrratiorate, mrratioloan, mrpricerate, mrpriceloan from secbasket where to_date(substr(importdt,1,10),'DD/MM/RRRR') <= v_thismonth and basketid = 'MS' and mrratioloan > 0 and mrratiorate > 0
union
select basketid, symbol , mrratiorate, mrratioloan, mrpricerate, mrpriceloan from secbaskethist where to_date(substr(backupdt,1,10),'DD/MM/RRRR') >= v_thismonth and to_date(substr(importdt,1,10),'DD/MM/RRRR') <= v_thismonth and basketid = 'MS' and mrratioloan > 0 and mrratiorate > 0
) ba
)a
full join
(select distinct symbol as T4 from
(
select basketid, symbol , mrratiorate, mrratioloan, mrpricerate, mrpriceloan from secbasket where to_date(substr(importdt,1,10),'DD/MM/RRRR') <= v_previousmonth and basketid = 'MS' and mrratioloan > 0 and mrratiorate > 0
union
select basketid, symbol , mrratiorate, mrratioloan, mrpricerate, mrpriceloan from secbaskethist where to_date(substr(backupdt,1,10),'DD/MM/RRRR') >= v_previousmonth and to_date(substr(importdt,1,10),'DD/MM/RRRR') <= v_previousmonth and basketid = 'MS' and mrratioloan > 0 and mrratiorate > 0
) ba

)b
on a.T5 = b.T4
) main
, sbsecurities sb
where nvl(main.T5,main.T4) = sb.symbol
and sb.tradeplace like V_tradeplace
order by main.T4

      /*SELECT v_EXCHANGE, MST.CODEID, MST.SYMBOL,
             (CASE WHEN MST.SB_FR  = 'Y' THEN MST.SYMBOL ELSE NULL END) SB_FR,
             (CASE WHEN MST.SB_DEL = 'Y' THEN MST.SYMBOL ELSE NULL END) SB_DEL,
             (CASE WHEN MST.SB_ADD = 'Y' THEN MST.SYMBOL ELSE NULL END) SB_ADD,
             (CASE WHEN MST.SB_TO  = 'Y' THEN MST.SYMBOL ELSE NULL END) SB_TO
      FROM
            (SELECT CODEID, SYMBOL, ISMARGINALLOWMIN SB_FR, ISMARGINALLOWMAX SB_TO,
                  (CASE WHEN ISMARGINALLOWMIN = ISMARGINALLOWMAX THEN 'N'
                        WHEN ISMARGINALLOWMIN = 'Y' AND ISMARGINALLOWMAX = 'N' THEN 'Y'
                   ELSE 'N' END) SB_DEL,
                  (CASE WHEN ISMARGINALLOWMIN = ISMARGINALLOWMAX THEN 'N'
                        WHEN ISMARGINALLOWMIN = 'N' AND ISMARGINALLOWMAX = 'Y' THEN 'Y'
                   ELSE 'N' END) SB_ADD
            FROM
                  (SELECT CODEID, SYMBOL, MAX(BACKUPDTMIN) BACKUPDTMIN, MAX(BACKUPDTMAX) BACKUPDTMAX,
                          MAX(ISMARGINALLOWMIN) ISMARGINALLOWMIN, MAX(ISMARGINALLOWMAX) ISMARGINALLOWMAX
                  FROM
                        (SELECT SE1.CODEID, SE1.SYMBOL, SE1.BACKUPDTMIN, SE1.BACKUPDTMAX, SE2.ISMARGINALLOW ISMARGINALLOWMIN, SE3.ISMARGINALLOW ISMARGINALLOWMAX
                        FROM
                            (SELECT SE.CODEID, SE.SYMBOL, MIN(SE.BACKUPDT) BACKUPDTMIN, MAX(SE.BACKUPDT) BACKUPDTMAX
                                FROM
                                    (SELECT SE.CODEID, SB.SYMBOL, SE.ISMARGINALLOW,
                                           (CASE WHEN SE.BACKUPDT = 'CRRDATE' THEN v_CurrDate
                                                 ELSE TO_DATE(SUBSTR(UPPER(SE.BACKUPDT), 1, 10), SYSTEMNUMS.C_DATE_FORMAT) END) BACKUPDT
                                    FROM
                                        (SELECT SE.CODEID, SE.ISMARGINALLOW, 'CRRDATE' BACKUPDT FROM SECURITIES_RISK SE
                                         UNION ALL
                                         SELECT SE.CODEID, SE.ISMARGINALLOW, BACKUPDT FROM SECURITIES_RISKHIST SE) SE,
                                         SBSECURITIES SB
                                    WHERE SE.CODEID = SB.CODEID --and SB.tradeplace like V_tradeplace
                                    ) SE
                             WHERE SE.BACKUPDT BETWEEN v_FromDate AND v_ToDate
                             GROUP BY SE.CODEID, SE.SYMBOL) SE1
                        LEFT JOIN
                             (SELECT *
                             FROM
                                  (SELECT SE.CODEID, SB.SYMBOL, SE.ISMARGINALLOW,
                                             (CASE WHEN SE.BACKUPDT = 'CRRDATE' THEN v_CurrDate
                                                   ELSE TO_DATE(SUBSTR(UPPER(SE.BACKUPDT), 1, 10), SYSTEMNUMS.C_DATE_FORMAT) END) BACKUPDT
                                      FROM
                                          (SELECT SE.CODEID, SE.ISMARGINALLOW, 'CRRDATE' BACKUPDT FROM SECURITIES_RISK SE
                                           UNION ALL
                                           SELECT SE.CODEID, SE.ISMARGINALLOW, BACKUPDT FROM SECURITIES_RISKHIST SE) SE,
                                           SBSECURITIES SB
                                      WHERE SE.CODEID = SB.CODEID --and SB.tradeplace like V_tradeplace
                                      ) SE2
                              WHERE SE2.BACKUPDT BETWEEN v_FromDate AND v_ToDate) SE2
                        ON  SE1.CODEID = SE2.CODEID AND SE1.BACKUPDTMIN = SE2.BACKUPDT
                        LEFT JOIN
                             (SELECT *
                             FROM
                                  (SELECT SE.CODEID, SB.SYMBOL, SE.ISMARGINALLOW,
                                             (CASE WHEN SE.BACKUPDT = 'CRRDATE' THEN v_CurrDate
                                                   ELSE TO_DATE(SUBSTR(UPPER(SE.BACKUPDT), 1, 10), SYSTEMNUMS.C_DATE_FORMAT) END) BACKUPDT
                                      FROM
                                          (SELECT SE.CODEID, SE.ISMARGINALLOW, 'CRRDATE' BACKUPDT FROM SECURITIES_RISK SE
                                           UNION ALL
                                           SELECT SE.CODEID, SE.ISMARGINALLOW, BACKUPDT FROM SECURITIES_RISKHIST SE) SE,
                                           SBSECURITIES SB
                                      WHERE SE.CODEID = SB.CODEID-- and SB.tradeplace like V_tradeplace
                                      ) SE3
                             WHERE SE3.BACKUPDT BETWEEN v_FromDate AND v_ToDate) SE3
                        ON  SE1.CODEID = SE3.CODEID AND SE1.BACKUPDTMAX = SE3.BACKUPDT)
                  GROUP BY CODEID, SYMBOL)
                  ) MST, sbsecurities sb
      WHERE (MST.SB_FR = 'Y' OR MST.SB_DEL = 'Y' OR MST.SB_ADD = 'Y' OR MST.SB_TO  = 'Y')
      and MST.codeid = sb.codeid and sb.tradeplace like V_tradeplace
      --AND   MST.SYMBOL = SEC.SYMBOL
      ORDER BY MST.SYMBOL*/

;


EXCEPTION
  WHEN OTHERS
   THEN
      RETURN;
END;
/

