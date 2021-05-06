CREATE OR REPLACE PROCEDURE od0021(
  PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   CUSTODYCD      in       varchar2,
   TYPEDATE      IN       VARCHAR2,
   TRADEPLACE     IN       VARCHAR2
  )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- NAMNT   21-NOV-06  CREATED
-- ---------   ------  -------------------------------------------
  V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
  V_STRBRID          VARCHAR2 (4);
  V_STRAFACCTNO      VARCHAR  (20);
  V_STRTRADEPLACE    VARCHAR2 (4);
   v_I_DATE          Date ;
   v_err varchar2(200);
   v_custodycd  varchar(20);
   vstr_typedate     VARCHAR2(10);

BEGIN
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   -- GET REPORT'S PARAMETERS

  /* IF  (AFACCTNO <> 'ALL')
   THEN
      V_STRAFACCTNO := AFACCTNO;
   ELSE
      V_STRAFACCTNO := '%%';
   END IF;*/

    IF  (custodycd <> 'ALL')
   THEN
       v_custodycd :=  custodycd ;
   ELSE
       v_custodycd := '%%';
   END IF;

   dbms_output.put_line('');

   IF  (TRADEPLACE <> 'ALL')
   THEN
      V_STRTRADEPLACE := TRADEPLACE;
   ELSE
      V_STRTRADEPLACE := '%%';
   END IF;

vstr_typedate := TYPEDATE;

IF  TYPEDATE ='001'   THEN
   OPEN PV_REFCURSOR
       FOR
   /* Formatted on 2009/07/23 14:42 (Formatter Plus v4.8.6) */


   /* Formatted on 2009/07/23 14:42 (Formatter Plus v4.8.6) */
SELECT   vstr_typedate typedate, settdate, custodycd, fullname, tradate,
         SUM (d_bamt) d_bamt, SUM (d_samt) d_samt, SUM (bd_bamt) bd_bamt,
         SUM (bd_samt) bd_samt, SUM (bf_bamt) bf_bamt, SUM (bf_samt) bf_samt,
         tradeplace
    FROM (SELECT   --getduedate (chd.txdate, 'B', '001', 3) settdate,
                   chd.cleardate settdate,         --T2_HoangfND edit
                   chd.txdate tradate, cf.custodycd, cf.fullname, chd.tradeplace,
                   SUM (DECODE (chd.duetype, 'SM', chd.amt / 1000, 0)) d_bamt,
                   SUM (DECODE (chd.duetype, 'RM', chd.amt / 1000, 0)) d_samt,
                   0 bd_bamt, 0 bd_samt, 0 bf_bamt, 0 bf_samt
              FROM (select * from  vw_stschd_tradeplace_all where tradeplace  like V_STRTRADEPLACE ) chd,
                   afmast af,
                   cfmast cf
             WHERE chd.deltd <> 'Y'
               AND SUBSTR (chd.acctno, 1, 10) = af.acctno
               AND af.custid = cf.custid
               AND SUBSTR (cf.custodycd, 4, 1) = 'P'
               AND chd.duetype IN ('SM', 'RM')
               AND chd.txdate = TO_DATE (i_date, 'DD/MM/YYYY')
              -- AND chd.acctno LIKE v_strafacctno
                AND cf.custodycd LIKE  v_custodycd
          GROUP BY --getduedate (chd.txdate, 'B', '001', 3),
                   chd.cleardate,         --T2_HoangfND edit
                   cf.custodycd,
                   cf.fullname,
                   chd.txdate,
                   chd.tradeplace
          UNION ALL
          SELECT   --getduedate (chd.txdate, 'B', '001', 3) settdate,
                   chd.cleardate settdate,         --T2_HoangfND edit
                   chd.txdate tradate, cf.custodycd, cf.fullname, chd.tradeplace,
                   0 d_bamt, 0 d_samt,
                   SUM (DECODE (chd.duetype,
                                'SM', chd.amt / 1000,
                                0
                               )) bd_bamt,
                   SUM (DECODE (chd.duetype,
                                'RM', chd.amt / 1000,
                                0
                               )) bd_samt, 0 bf_bamt, 0 bf_samt
              FROM (select * from  vw_stschd_tradeplace_all where tradeplace  like V_STRTRADEPLACE ) chd,
                   afmast af,
                   cfmast cf
             WHERE chd.deltd <> 'Y'
               AND SUBSTR (chd.acctno, 1, 10) = af.acctno
               AND af.custid = cf.custid
               AND SUBSTR (cf.custodycd, 4, 1) = 'C'
               AND chd.duetype IN ('SM', 'RM')
               AND chd.txdate = TO_DATE (i_date, 'DD/MM/YYYY')
              -- AND chd.acctno LIKE v_strafacctno
                AND cf.custodycd LIKE  v_custodycd
          GROUP BY --getduedate (chd.txdate, 'B', '001', 3),
                   chd.cleardate,         --T2_HoangfND edit
                   cf.custodycd,
                   cf.fullname,
                   chd.txdate,
                   chd.tradeplace
          UNION ALL
          SELECT   --getduedate (chd.txdate, 'B', '001', 3) settdate,
                   chd.cleardate settdate,         --T2_HoangfND edit
                   chd.txdate tradate, cf.custodycd, cf.fullname, chd.tradeplace,
                   0 d_bamt, 0 d_samt, 0 bd_bamt, 0 bd_samt,
                   SUM (DECODE (chd.duetype,
                                'SM', chd.amt / 1000,
                                0
                               )) bf_bamt,
                   SUM (DECODE (chd.duetype,
                                'RM', chd.amt / 1000,
                                0
                               )) bf_samt
              FROM (select * from  vw_stschd_tradeplace_all where tradeplace  like V_STRTRADEPLACE ) chd,
                   afmast af,
                   cfmast cf,
                   (SELECT *
                      FROM sbsecurities
                     WHERE tradeplace LIKE v_strtradeplace) sb
             WHERE chd.deltd <> 'Y'
               AND SUBSTR (chd.acctno, 1, 10) = af.acctno
               AND af.custid = cf.custid
               AND chd.duetype IN ('SM', 'RM')
               AND SUBSTR (cf.custodycd, 4, 1) = 'F'
               AND chd.txdate = TO_DATE (i_date, 'DD/MM/YYYY')
              -- AND chd.acctno LIKE v_strafacctno
                AND cf.custodycd LIKE  v_custodycd
          GROUP BY --getduedate (chd.txdate, 'B', '001', 3),
                   chd.cleardate,         --T2_HoangfND edit
                   cf.custodycd,
                   cf.fullname,
                   chd.txdate,
                   chd.tradeplace)
GROUP BY settdate, custodycd, fullname, tradate, tradeplace

    ;

ELSE
OPEN PV_REFCURSOR
       FOR


SELECT   vstr_typedate typedate, settdate, custodycd, fullname, tradate,
         SUM (d_bamt) d_bamt, SUM (d_samt) d_samt, SUM (bd_bamt) bd_bamt,
         SUM (bd_samt) bd_samt, SUM (bf_bamt) bf_bamt, SUM (bf_samt) bf_samt,
         tradeplace
    FROM (SELECT   i_date settdate, chd.txdate tradate, cf.custodycd,
                   cf.fullname, chd.tradeplace,
                   SUM (DECODE (chd.duetype, 'SM', chd.amt / 1000, 0)) d_bamt,
                   SUM (DECODE (chd.duetype, 'RM', chd.amt / 1000, 0)) d_samt,
                   0 bd_bamt, 0 bd_samt, 0 bf_bamt, 0 bf_samt
              FROM (select * from  vw_stschd_tradeplace_all where tradeplace  like V_STRTRADEPLACE ) chd, stschdhist chd1,
                   afmast af,
                   cfmast cf
             WHERE chd.deltd <> 'Y'
               AND SUBSTR (chd.acctno, 1, 10) = af.acctno
               AND af.custid = cf.custid
               AND SUBSTR (cf.custodycd, 4, 1) = 'P'
               AND chd.txdate > TO_DATE (i_date, 'DD/MM/YYYY') - 20
               AND ((chd.duetype = 'SM' AND CHD1.duetype='RS')OR (chd.duetype = 'RM' AND chd1.duetype='SS'))
               AND chd1.txdate > TO_DATE (i_date, 'DD/MM/YYYY') - 20
               AND CHD.ORGORDERID =chd1.ORGORDERID
               --AND GETDUEDATE(to_date(CHD.TXDATE,'dd/mm/yyyy'),'B',SB.TRADEPLACE,CHD.clearday) =TO_DATE(I_DATE ,'DD/MM/YYYY')
               AND (
                      ( --txdate lay txdate cua lenh mua: RS (SM)
                        chd.txdate = (SELECT sbdate
                                  FROM (SELECT ROWNUM DAY, sbdate
                                          FROM (SELECT   *
                                                    FROM sbcldr
                                                   WHERE cldrtype = '001'
                                                     AND sbdate <
                                                            TO_DATE
                                                                 (i_date,
                                                                  'DD/MM/YYYY'
                                                                 )
                                                     AND holiday = 'N'
                                                ORDER BY sbdate DESC) cldr) rl
                                 WHERE (DAY = CHD1.CLEARDAY AND CHD.DUETYPE ='SM')
                                      OR (DAY = CHD.CLEARDAY AND CHD.DUETYPE ='RM')
                         )
                       )
                   )
              -- AND chd.acctno LIKE v_strafacctno
                AND cf.custodycd LIKE  v_custodycd
          GROUP BY i_date, cf.custodycd, cf.fullname, chd.txdate, chd.tradeplace
          UNION ALL
          SELECT   i_date settdate, chd.txdate tradate, cf.custodycd,
                   cf.fullname, chd.tradeplace, 0 d_bamt, 0 d_samt,
                   SUM (DECODE (chd.duetype,
                                'SM', chd.amt / 1000,
                                0
                               )) bd_bamt,
                   SUM (DECODE (chd.duetype,
                                'RM', chd.amt / 1000,
                                0
                               )) bd_samt, 0 bf_bamt, 0 bf_samt
              FROM  (select * from  vw_stschd_tradeplace_all where tradeplace  like V_STRTRADEPLACE ) chd,stschdhist chd1,
                   afmast af,
                   cfmast cf
             WHERE chd.deltd <> 'Y'
               AND SUBSTR (chd.acctno, 1, 10) = af.acctno
               AND af.custid = cf.custid
                AND SUBSTR (cf.custodycd, 4, 1) = 'C'
               AND chd.txdate > TO_DATE (i_date, 'DD/MM/YYYY') - 20
               AND ((chd.duetype = 'SM' AND CHD1.duetype='RS')OR (chd.duetype = 'RM' AND chd1.duetype='SS'))
               AND chd1.txdate > TO_DATE (i_date, 'DD/MM/YYYY') - 20
               AND CHD.ORGORDERID =chd1.ORGORDERID
               --AND GETDUEDATE(to_date(CHD.TXDATE,'dd/mm/yyyy'),'B',SB.TRADEPLACE,CHD.clearday) =TO_DATE(I_DATE ,'DD/MM/YYYY')
               AND (
                      ( --txdate lay txdate cua lenh mua: RS (SM)
                        chd.txdate = (SELECT sbdate
                                  FROM (SELECT ROWNUM DAY, sbdate
                                          FROM (SELECT   *
                                                    FROM sbcldr
                                                   WHERE cldrtype = '001'
                                                     AND sbdate <
                                                            TO_DATE
                                                                 (i_date,
                                                                  'DD/MM/YYYY'
                                                                 )
                                                     AND holiday = 'N'
                                                ORDER BY sbdate DESC) cldr) rl
                                 WHERE (DAY = CHD1.CLEARDAY AND CHD.DUETYPE ='SM')
                                      OR (DAY = CHD.CLEARDAY AND CHD.DUETYPE ='RM')
                         )
                       )
                   )
               --AND chd.acctno LIKE v_strafacctno
                 AND cf.custodycd LIKE  v_custodycd
          GROUP BY i_date, cf.custodycd, cf.fullname, chd.txdate, chd.tradeplace
          UNION ALL
          SELECT   i_date settdate, chd.txdate tradate, cf.custodycd,
                   cf.fullname, chd.tradeplace, 0 d_bamt, 0 d_samt, 0 bd_bamt,
                   0 bd_samt,
                   SUM (DECODE (chd.duetype,
                                'SM', chd.amt / 1000,
                                0
                               )) bf_bamt,
                   SUM (DECODE (chd.duetype,
                                'RM', chd.amt / 1000,
                                0
                               )) bf_samt
              FROM (select * from  vw_stschd_tradeplace_all where tradeplace  like V_STRTRADEPLACE) chd,stschdhist chd1,
                   afmast af,
                   cfmast cf
             WHERE chd.deltd <> 'Y'
               AND SUBSTR (chd.acctno, 1, 10) = af.acctno
               AND af.custid = cf.custid
               AND SUBSTR (cf.custodycd, 4, 1) = 'F'
               AND chd.txdate > TO_DATE (i_date, 'DD/MM/YYYY') - 20
               AND ((chd.duetype = 'SM' AND CHD1.duetype='RS')OR (chd.duetype = 'RM' AND chd1.duetype='SS'))
               AND chd1.txdate > TO_DATE (i_date, 'DD/MM/YYYY') - 20
               AND CHD.ORGORDERID =chd1.ORGORDERID
               --AND GETDUEDATE(to_date(CHD.TXDATE,'dd/mm/yyyy'),'B',SB.TRADEPLACE,CHD.clearday) =TO_DATE(I_DATE ,'DD/MM/YYYY')
               AND (
                      ( --txdate lay txdate cua lenh mua: RS (SM)
                        chd.txdate = (SELECT sbdate
                                  FROM (SELECT ROWNUM DAY, sbdate
                                          FROM (SELECT   *
                                                    FROM sbcldr
                                                   WHERE cldrtype = '001'
                                                     AND sbdate <
                                                            TO_DATE
                                                                 (i_date,
                                                                  'DD/MM/YYYY'
                                                                 )
                                                     AND holiday = 'N'
                                                ORDER BY sbdate DESC) cldr) rl
                                 WHERE (DAY = CHD1.CLEARDAY AND CHD.DUETYPE ='SM')
                                      OR (DAY = CHD.CLEARDAY AND CHD.DUETYPE ='RM')
                         )
                       )
                   )
             --  AND chd.acctno LIKE v_strafacctno
               AND cf.custodycd LIKE  v_custodycd

          GROUP BY i_date, cf.custodycd, cf.fullname, chd.txdate, chd.tradeplace)
GROUP BY settdate, custodycd, fullname, tradate, tradeplace

;

END IF;

EXCEPTION
   WHEN OTHERS
   THEN
   v_err:=substr(sqlerrm,1,199);
          /*   INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, ' OD0021 ', v_err
                  );

       COMMIT;*/
END;                                                              -- PROCEDURE
/

