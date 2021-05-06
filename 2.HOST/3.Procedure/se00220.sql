CREATE OR REPLACE PROCEDURE se00220 (
   PV_REFCURSOR     IN OUT   PKG_REPORT.REF_CURSOR,
   OPT              IN       VARCHAR2,
   BRID             IN       VARCHAR2,
   PV_CUSTODYCD     IN       VARCHAR2,
   PV_RECUSTODYCD   in       varchar2,
   PV_RENAME        IN       varchar2,
   PV_RECOMPANY     IN       varchar2
       )
IS

    V_BRID              VARCHAR2(4);
    V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
    V_INBRID     VARCHAR2 (5);
    V_IDATE DATE;
    V_CUSTODYCD varchar2(10);
    V_RECOMPANY varchar2(100);


BEGIN

   V_STROPTION := upper(OPT);
   V_INBRID := BRID;

   if(V_STROPTION = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := BRID;
        end if;
    end if;

   V_CUSTODYCD := upper(PV_CUSTODYCD);
   if PV_RECOMPANY Is null then
        V_RECOMPANY := ' ';
   ELSE
        BEGIN
            select nvl(fullname,' ') into v_recompany from DEPOSIT_MEMBER where depositid = PV_RECOMPANY;
        EXCEPTION
            WHEN OTHERS THEN V_RECOMPANY := ' ';
        END;
   END IF;


    select to_date(varvalue,'DD/MM/RRRR') into V_IDATE from sysvar where varname = 'CURRDATE';

OPEN PV_REFCURSOR FOR
SELECT --V_CUSTODYCD, P_TXMSG.TXFIELDS('03').VALUE,  TO_DATE(P_TXMSG.TXDATE, 'DD/MM/RRRR'),   P_TXMSG.TXNUM, P_TXMSG.TLTXCD,
             nvl(PV_RECUSTODYCD,'') reccustodycd, nvl(PV_RENAME,'') recName, V_RECOMPANY reccompany,
             MAIN.CUSTODYCD,
             BRID,   BRNAME,MAIN.FULLNAME,  MAIN.IDCODE,MAIN.IDDATE,  MAIN.IDPLACE, MAIN.ADDRESS,
             MAIN.PHONE, MAIN.MOBILE, MAIN.WFT_SYMBOL SYMBOL, TRADEPLACE,
             SUM(CASE  WHEN INSTR(SYMBOL, '_WFT') = 0 THEN NVL(TRADE, 0) + NVL(B.BUYQTTY, 0) - NVL(B.SELLQTTY, 0) ELSE 0 END) TRADE,
             SUM(CASE WHEN INSTR(SYMBOL, '_WFT') = 0 THEN BLOCKED ELSE 0 END) BLOCKED,
             SUM(CASE WHEN INSTR(SYMBOL, '_WFT') <> 0 THEN NVL(TRADE, 0) + NVL(B.BUYQTTY, 0) - NVL(B.SELLQTTY, 0) ELSE 0 END) TRADE_WFT,
             SUM(CASE WHEN INSTR(SYMBOL, '_WFT') <> 0 THEN BLOCKED ELSE 0 END) BLOCKED_WFT
             --P_TXMSG.TXFIELDS('48').VALUE INWARD,
             --P_TXMSG.TXFIELDS('47').VALUE RCVCUSTODYCD
        FROM
        (SELECT BR.BRID, BRNAME, CF.FULLNAME, DECODE(SUBSTR(CF.CUSTODYCD, 4, 1), 'F', CF.TRADINGCODE, CF.IDCODE) IDCODE,
                       DECODE(SUBSTR(CF.CUSTODYCD, 4, 1), 'F', CF.TRADINGCODEDT, CF.IDDATE) IDDATE, CF.IDPLACE,
                       CF.ADDRESS,CF.PHONE,CF.MOBILE,CF.CUSTODYCD,NVL(SB.SYMBOL, '') SYMBOL,NVL(SB_WFT.SYMBOL, '') WFT_SYMBOL,
                       NVL(SB_WFT.SECTYPE, '') SECTYPE,NVL(SB_WFT.ISSUERID, '') ISSUERID,
                       --nvl(sb_wft.tradeplace,'') tradeplace,
                       NVL(SE.TRADE, 0) - SUM(CASE WHEN TRAN.FIELD = 'TRADE' AND TRAN.TXCD = 'D' THEN -NVL(TRAN.NAMT, 0)
                                                WHEN TRAN.FIELD = 'TRADE' AND TRAN.TXCD = 'C' THEN NVL(TRAN.NAMT, 0) ELSE 0 END) TRADE,
                       NVL(SE.BLOCKED, 0) - SUM(CASE WHEN TRAN.FIELD = 'BLOCKED' AND TRAN.TXCD = 'D' THEN -NVL(TRAN.NAMT, 0)
                                                  WHEN TRAN.FIELD = 'BLOCKED' AND TRAN.TXCD = 'C' THEN NVL(TRAN.NAMT, 0) ELSE 0 END) BLOCKED,
                       SE.RECEIVING, CASE WHEN SB.MARKETTYPE = '001' AND SB.SECTYPE IN ('003', '006', '222', '333', '444') THEN UTF8NUMS.C_CONST_DF_MARKETNAME --'Trai phieu chuyen biet'
                                        WHEN NVL(SB_WFT.TRADEPLACE, '') = '001' THEN 'HOSE'
                                        WHEN NVL(SB_WFT.TRADEPLACE, '') = '002' THEN 'HNX'
                                        WHEN NVL(SB_WFT.TRADEPLACE, '') = '005' THEN 'UPCOM' END TRADEPLACE

                 FROM  BRGRP BR, CFMAST CF, AFMAST AF, SEMAST SE,
                       (SELECT * FROM VW_SETRAN_GEN WHERE TXDATE >= TO_DATE(V_IDATE, 'DD/MM/RRRR') AND FIELD IN ('TRADE', 'BLOCKED')) TRAN,
                       SBSECURITIES SB, SBSECURITIES SB_WFT
                WHERE
                CF.CUSTODYCD = V_CUSTODYCD
             AND AF.CUSTID = CF.CUSTID
             AND SB.SECTYPE NOT IN ('111', '222', '333', '444', '004')
             AND BR.BRID = SUBSTR(CF.CUSTID, 1, 4)
             AND AF.ACCTNO = SE.AFACCTNO(+)
             AND SE.ACCTNO = TRAN.ACCTNO(+)
             AND SE.CODEID = SB.CODEID(+)
             AND NVL(SB.REFCODEID, SB.CODEID) = SB_WFT.CODEID(+)
               --AND (substr(cf.custid,1,4) LIKE '%%' OR instr('%%',substr(cf.custid,1,4))<> 0)
             GROUP BY BR.BRID, BRNAME,SB.MARKETTYPE, SB.SECTYPE,CF.FULLNAME,CF.IDCODE, CF.IDDATE,CF.IDPLACE,CF.ADDRESS, CF.PHONE,
                          CF.MOBILE,CF.CUSTODYCD,SE.TRADE,SE.BLOCKED,SE.RECEIVING,SB.SYMBOL,SB_WFT.SYMBOL,SB_WFT.SECTYPE,
                          SB_WFT.ISSUERID, SB_WFT.TRADEPLACE, CF.TRADINGCODEDT,CF.TRADINGCODE --, tran.field
               ) MAIN
        LEFT JOIN (SELECT CUSTODYCD, CODEID, SYMBOL SYMBOLL,
                          SUM(CASE WHEN BORS = 'S' THEN QTTY ELSE 0 END) SELLQTTY,
                          SUM(CASE WHEN BORS = 'B' THEN QTTY ELSE 0 END) BUYQTTY
                  FROM IOD WHERE DELTD <> 'Y' AND CUSTODYCD = V_CUSTODYCD
                    GROUP BY CUSTODYCD, CODEID, SYMBOL) B
          ON MAIN.CUSTODYCD = B.CUSTODYCD  AND MAIN.SYMBOL = B.SYMBOLL
       GROUP BY BRID,BRNAME, MAIN.FULLNAME,  MAIN.IDCODE,MAIN.IDDATE,MAIN.IDPLACE, MAIN.ADDRESS,
                MAIN.PHONE, MAIN.MOBILE, MAIN.CUSTODYCD, MAIN.WFT_SYMBOL, MAIN.TRADEPLACE;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

