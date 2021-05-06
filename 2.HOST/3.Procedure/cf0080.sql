CREATE OR REPLACE PROCEDURE cf0080 (
   PV_REFCURSOR     IN OUT   PKG_REPORT.REF_CURSOR,
   OPT              IN       VARCHAR2,
   BRID             IN       VARCHAR2,
   PV_CUSTODYCD     IN       VARCHAR2,
   CI0088KEY        IN       VARCHAR2
       )
IS

    V_BRID              VARCHAR2(4);
    V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID     VARCHAR2 (5);
    V_IDATE DATE;
    V_CUSTODYCD varchar2(10);
    v_COUNT  number;

BEGIN

   V_STROPTION := upper(OPT);
   V_INBRID := BRID;
   v_COUNT :=0;

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

/*
   SELECT nvl(max(txdate),to_date('11/11/2222','DD/MM/RRRR')) INTO V_IDATE
   FROM vw_tllog_all lg, afmast af, cfmast cf
   WHERE af.custid = cf.custid AND lg.msgacct = af.acctno AND lg.tltxcd = '0088'
   AND cf.custodycd = V_CUSTODYCD;

OPEN PV_REFCURSOR FOR

SELECT  BRID,BRNAME, V_IDATE TXDATE ,main.fullname, main.idcode, main.iddate, main.idplace, main.address, main.phone, main.mobile,
        main.custodycd, main.wft_symbol symbol, tradeplace,
       sum(CASE WHEN instr(symbol,'_WFT') = 0 THEN trade + receiving ELSE 0 END) trade,
       sum(CASE WHEN instr(symbol,'_WFT') = 0 THEN blocked ELSE 0 END) blocked,
       sum(CASE WHEN instr(symbol,'_WFT') <> 0 THEN trade ELSE 0 END) trade_WFT,
       sum(CASE WHEN instr(symbol,'_WFT') <> 0 THEN blocked ELSE 0 END) blocked_WFT
FROM (

    SELECT BR.BRID, BRNAME,cf.fullname, DECODE(SUBSTR(CF.CUSTODYCD,4,1),'F',CF.TRADINGCODE,CF.IDCODE) idcode,
                 DECODE(SUBSTR(CF.CUSTODYCD,4,1),'F',CF.TRADINGCODEDT,CF.IDDATE) iddate,
               cf.idplace, cf.address, CF.phone, cf.mobile,cf.custodycd,
    nvl(sb.symbol,'') symbol, nvl(sb_wft.symbol,'') wft_symbol,
           nvl(sb_wft.sectype,'') sectype, nvl(sb_wft.issuerid,'') issuerid ,
           --nvl(sb_wft.tradeplace,'') tradeplace,
           nvl(se.trade,0) - sum(CASE WHEN tran.field = 'TRADE' AND tran.txcd = 'D' THEN - nvl(tran.namt,0)
                            WHEN tran.field = 'TRADE' AND tran.txcd = 'C' THEN nvl(tran.namt,0)
                            ELSE 0 END) trade,
           nvl(se.blocked,0) - sum(CASE WHEN tran.field = 'BLOCKED' AND tran.txcd = 'D' THEN - nvl(tran.namt,0)
                                WHEN tran.field = 'BLOCKED' AND tran.txcd = 'C' THEN nvl(tran.namt,0)
                                ELSE 0 END) blocked,
           SE.receiving,
         CASE WHEN sb.markettype = '001' AND sb.sectype IN ('003','006','222','333','444') THEN 'TT Tr?phi?u chuy?bi?t'
            WHEN  nvl(sb_wft.tradeplace,'') = '001' THEN 'HOSE'
            WHEN  nvl(sb_wft.tradeplace,'') = '002' THEN 'HNX'
            WHEN  nvl(sb_wft.tradeplace,'') = '005' THEN 'UPCOM'  END tradeplace

    FROM ( SELECT cf.custodycd
   FROM vw_tllog_all lg, afmast af, cfmast cf
   WHERE af.custid = cf.custid AND lg.msgacct = af.acctno
   AND lg.tltxcd = '0088'
    group by cf.custodycd) tl,BRGRP BR,
    cfmast cf, afmast af,semast se,
    (SELECT * FROM vw_setran_gen WHERE txdate > V_IDATE and field in ('TRADE','BLOCKED')) tran, sbsecurities sb,
         sbsecurities sb_wft
    WHERE
    tl.custodycd = cf.custodycd
    and cf.custodycd = V_CUSTODYCD
    AND af.custid = cf.custid
    and sb.sectype not in ('111','222','333','444','004')
    AND BR.BRID = SUBSTR(CF.CUSTID,1,4)
    AND af.acctno =  se.afacctno (+)
    and se.acctno = tran.acctno (+)
    AND se.codeid = sb.codeid (+)
    AND nvl(sb.refcodeid, sb.codeid) = sb_wft.codeid (+)
    --AND (substr(cf.custid,1,4) LIKE '%%' OR instr('%%',substr(cf.custid,1,4))<> 0)
    GROUP BY BR.BRID,BRNAME,sb.markettype,sb.sectype,cf.fullname, cf.idcode, cf.iddate, cf.idplace, cf.address, cf.phone, cf.mobile,
    cf.custodycd, se.trade, se.blocked,SE.receiving, sb.symbol, sb_wft.symbol,
    sb_wft.sectype, sb_wft.issuerid,sb_wft.tradeplace,cf.TRADINGCODEDT,CF.TRADINGCODE--, tran.field


) main
GROUP BY BRID,BRNAME,main.fullname, main.idcode, main.iddate, main.idplace, main.address,
main.phone, main.mobile,main.custodycd, main.wft_symbol, main.tradeplace;
*/

OPEN PV_REFCURSOR FOR
SELECT l.*, nvl(dm.fullname,' ') receiver_name FROM CF0080_LOG l, deposit_member dm
WHERE l.CUSTODYCD like  V_CUSTODYCD AND TO_CHAR(l.TXDATE,'DD/MM/RRRR')||l.TXNUM = CI0088KEY
and l.INWARD = dm.depositid (+)
ORDER BY l.SYMBOL;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

