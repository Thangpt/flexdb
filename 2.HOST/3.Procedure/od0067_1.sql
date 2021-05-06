-- Start of DDL Script for Procedure HOSTMSTRADE.OD0067_1
-- Generated 11/04/2017 3:18:22 PM from HOSTMSTRADE@FLEX_111

CREATE OR REPLACE 
PROCEDURE od0067_1(
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   TRADEPLACE     IN       VARCHAR2,
   PV_SECTYPE     IN       VARCHAR2,
   CASHPLACE      IN       VARCHAR2,
   PV_BRGID       IN       VARCHAR2
  )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- NAMNT   21-NOV-06  CREATED
-- TruongLD 05/10/2011  Modify
-- GianhVG 03/03/2011
-- ---------   ------  -------------------------------------------
  V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
  V_PVSTRBRID        VARCHAR2 (40);
  V_PVBRID           VARCHAR2 (4);

  V_STRBRID          VARCHAR2 (4);

  V_BRID             VARCHAR2 (4);

  V_STRAFACCTNO      VARCHAR  (20);
  V_STRTRADEPLACE    VARCHAR2 (4);
  V_STRCASHPLACE     VARCHAR2 (100);
  v_I_DATE           Date ;
  v_err              varchar2(200);
  TYPEDATE           VARCHAR2(10);
  vstr_typedate      VARCHAR2(10);
  v_CashPlaceName    VARCHAR2(1000);
  V_SECTYPE          VARCHAR2(100);
  v_clearday  NUMBER;             --T2_HoangfND add

BEGIN
   V_STROPTION := upper(OPT);
   V_PVBRID := BRID;

   IF V_STROPTION = 'A' THEN     -- TOAN HE THONG
      V_PVSTRBRID := '%';
   ELSE if V_STROPTION = 'B' THEN
            select brgrp.mapid into V_PVSTRBRID from brgrp where brgrp.brid = V_PVBRID;
        else
            V_PVSTRBRID := V_PVBRID;
        end if;
   END IF;

   /*
   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%';
   END IF;
   */
   /*
   IF V_STROPTION = 'A' THEN     -- TOAN HE THONG
      V_STRBRID := '%';
   ELSE
      V_STRBRID := BRID;
   END IF;
   */

   -- GET REPORT'S PARAMETERS


   IF  (TRADEPLACE <> 'ALL')
   THEN
      V_STRTRADEPLACE := TRADEPLACE;
   ELSE
      V_STRTRADEPLACE := '%';
   END IF;


   IF  (CASHPLACE <> 'ALL')
   THEN
      V_STRCASHPLACE := CASHPLACE;
   ELSE
      V_STRCASHPLACE := '%';
   END IF;


   IF  (PV_SECTYPE <> 'ALL')
   THEN
      V_SECTYPE := PV_SECTYPE;
   ELSE
      V_SECTYPE := '%';
   END IF;


   If  CASHPLACE = 'ALL' Then
       v_CashPlaceName := ' T?t c? ';
   ELSIF CASHPLACE = '000' Then
       v_CashPlaceName := ' C?ty ch?ng kho?';
   Else
       Begin
        Select CDCONTENT Into v_CashPlaceName from Allcode Where cdval = CASHPLACE And cdname ='BANKNAME' and cdtype ='CF';
       EXCEPTION
        WHEN OTHERS THEN v_CashPlaceName := '';
       End;
   End If;

   TYPEDATE      := '001';

   vstr_typedate := TYPEDATE;

    v_I_DATE := getduedate(TO_DATE (i_date, 'DD/MM/YYYY'),'B', '000', 3);


   IF(PV_BRGID <> 'ALL') THEN
     V_BRID := PV_BRGID;
   ELSE
     V_BRID := '%';
   END IF;

   SELECT to_number(fn_getsysclearday(TO_DATE (i_date, 'DD/MM/YYYY'))) INTO v_clearday FROM dual;  --T2_HoangfND add
   v_I_DATE := getduedate(TO_DATE (i_date, 'DD/MM/YYYY'),'B', '000', v_clearday);

if(TRADEPLACE = '999') then
OPEN PV_REFCURSOR
       FOR
SELECT   vstr_typedate typedate, v_I_DATE settdate, to_char(tradate,'DD/MM/RRRR') tradate,
             SUM (d_bamt) d_bamt, SUM (d_samt) d_samt, SUM (bd_bamt) bd_bamt,
             SUM (bd_samt) bd_samt, SUM (bf_bamt) bf_bamt, SUM (bf_samt) bf_samt,
             (case
              when tradeplace='002' then 'HNX'
              when tradeplace='001' then 'HOSE'
              when tradeplace='005' then 'UPCOM' else '' end)tradeplace, symbol,
              i_date i_date, v_CashPlaceName CASHPLACE

        FROM (
              SELECT    chd.cleardate settdate,
                       chd.txdate tradate, cf.custodycd, cf.fullname, CHD.TRADEPLACE, sb.symbol,
                   SUM (case when SUBSTR (cf.custodycd, 4, 1) = 'P' then  DECODE (chd.duetype, 'RS', chd.amt , 0) else 0 end) d_bamt,
                   SUM (case when SUBSTR (cf.custodycd, 4, 1) = 'P' then  DECODE (chd.duetype, 'RM', chd.amt , 0) else 0 end) d_samt,
                   SUM (case when SUBSTR (cf.custodycd, 4, 1) = 'C' then  DECODE (chd.duetype, 'RS', chd.amt , 0) else 0 end) bd_bamt,
                   SUM (case when SUBSTR (cf.custodycd, 4, 1) = 'C' then  DECODE (chd.duetype, 'RM', chd.amt , 0) else 0 end) bd_samt,
                   SUM (case when SUBSTR (cf.custodycd, 4, 1) = 'F' then  DECODE (chd.duetype, 'RS', chd.amt , 0) else 0 end) bf_bamt,
                   SUM (case when SUBSTR (cf.custodycd, 4, 1) = 'F' then  DECODE (chd.duetype, 'RM', chd.amt , 0) else 0 end) bf_samt
                  FROM (SELECT * FROM vw_stschd_tradeplace_all WHERE tradeplace IN ('001','002')    ) chd,
                       (select * from afmast where (case when CASHPLACE = 'ALL' then 'ALL'
                                                        when CASHPLACE = '000' or CASHPLACE = '---' then corebank
                                                        else corebank || bankname end)
                                                   = (case when CASHPLACE = 'ALL' then 'ALL'
                                                        when CASHPLACE = '000'  or CASHPLACE = '---' then 'N'
                                                        else 'Y' || V_STRCASHPLACE  end )
                                and brid like V_BRID
                                --- and SUBSTR(acctno,1,4) like V_STRBRID----
                                and (brid like V_PVSTRBRID or  instr(V_PVSTRBRID,brid) <> 0 )
                        ) af,
                       cfmast cf,
                       (SELECT *
                          FROM sbsecurities
                         WHERE SECTYPE LIKE V_SECTYPE AND SECTYPE IN ('001','006','008','011')) sb
                 WHERE chd.deltd <> 'Y'
                   --AND SUBSTR (chd.acctno, 1, 10) = af.acctno
                   AND chd.afacctno= af.acctno
                   AND af.custid = cf.custid
                   AND chd.duetype IN ('RS', 'RM')
                   --and chd.clearday = 3
                   and chd.clearday = v_clearday    --T2_HoangND edit
                   AND chd.txdate = TO_DATE (i_date, 'DD/MM/YYYY')
                  -- AND chd.acctno LIKE v_strafacctno
                   AND cf.custodycd LIKE '%'
                   AND sb.codeid = chd.codeid
                   and cf.custatcom = 'Y'
              GROUP BY  chd.cleardate,
                       cf.custodycd,
                       cf.fullname,
                       chd.txdate,
                       CHD.TRADEPLACE,
                       sb.symbol
                       )
    GROUP BY settdate,  tradate, tradeplace, symbol;
ELSE
    OPEN PV_REFCURSOR
       FOR
SELECT   vstr_typedate typedate, v_I_DATE settdate, to_char(tradate,'DD/MM/RRRR') tradate,
             SUM (d_bamt) d_bamt, SUM (d_samt) d_samt, SUM (bd_bamt) bd_bamt,
             SUM (bd_samt) bd_samt, SUM (bf_bamt) bf_bamt, SUM (bf_samt) bf_samt,
             (case
              when tradeplace='002' then 'HNX'
              when tradeplace='001' then 'HOSE'
              when tradeplace='005' then 'UPCOM' else '' end)tradeplace, symbol,
              i_date i_date, v_CashPlaceName CASHPLACE

        FROM (
              SELECT   chd.cleardate settdate,
                       chd.txdate tradate, cf.custodycd, cf.fullname, CHD.TRADEPLACE, sb.symbol,
                   SUM (case when SUBSTR (cf.custodycd, 4, 1) = 'P' then  DECODE (chd.duetype, 'RS', chd.amt , 0) else 0 end) d_bamt,
                   SUM (case when SUBSTR (cf.custodycd, 4, 1) = 'P' then  DECODE (chd.duetype, 'RM', chd.amt , 0) else 0 end) d_samt,
                   SUM (case when SUBSTR (cf.custodycd, 4, 1) = 'C' then  DECODE (chd.duetype, 'RS', chd.amt , 0) else 0 end) bd_bamt,
                   SUM (case when SUBSTR (cf.custodycd, 4, 1) = 'C' then  DECODE (chd.duetype, 'RM', chd.amt , 0) else 0 end) bd_samt,
                   SUM (case when SUBSTR (cf.custodycd, 4, 1) = 'F' then  DECODE (chd.duetype, 'RS', chd.amt , 0) else 0 end) bf_bamt,
                   SUM (case when SUBSTR (cf.custodycd, 4, 1) = 'F' then  DECODE (chd.duetype, 'RM', chd.amt , 0) else 0 end) bf_samt
                  FROM (SELECT * FROM  vw_stschd_TRADEPLACE_all WHERE TRADEPLACE like V_STRTRADEPLACE and  tradeplace IN ('001','002','005') ) chd,
                       (select * from afmast where (case when CASHPLACE = 'ALL' then 'ALL'
                                                        when CASHPLACE = '000' or CASHPLACE = '---' then corebank
                                                        else corebank || bankname end)
                                                   = (case when CASHPLACE = 'ALL' then 'ALL'
                                                        when CASHPLACE = '000'  or CASHPLACE = '---' then 'N'
                                                        else 'Y' || V_STRCASHPLACE  end )
                                and brid like V_BRID
                                --- and SUBSTR(acctno,1,4) like V_STRBRID
                                and (brid like V_PVSTRBRID or  instr(V_PVSTRBRID,brid) <> 0 )
                        ) af,
                       cfmast cf,
                       (SELECT *
                          FROM sbsecurities
                         WHERE  SECTYPE LIKE V_SECTYPE AND SECTYPE IN ('001','006','008','011')) sb
                 WHERE chd.deltd <> 'Y'
                   --AND SUBSTR (chd.acctno, 1, 10) = af.acctno
                   AND chd.afacctno= af.acctno
                   AND af.custid = cf.custid
                   AND chd.duetype IN ('RS', 'RM')
                   --and chd.clearday = 3
                   and chd.clearday = v_clearday    --T2_HoangND edit
                   AND chd.txdate = TO_DATE (i_date, 'DD/MM/YYYY')
                  -- AND chd.acctno LIKE v_strafacctno
                   AND cf.custodycd LIKE '%'
                   AND sb.codeid = chd.codeid
                   and cf.custatcom = 'Y'
              GROUP BY chd.cleardate,
                       cf.custodycd,
                       cf.fullname,
                       chd.txdate,
                       CHD.TRADEPLACE,
                       sb.symbol
                       )
    GROUP BY settdate,  tradate, tradeplace, symbol;
end if;

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
END;
/



-- End of DDL Script for Procedure HOSTMSTRADE.OD0067_1

