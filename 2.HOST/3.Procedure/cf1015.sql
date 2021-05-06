CREATE OR REPLACE PROCEDURE cf1015 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   CUSTODYCD         IN       VARCHAR2
 )
IS
--GIay de nghi tat toan tai khoan
--created by Chaunh at 19/04/2012

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

   V_CUSTODYCD := upper(CUSTODYCD);

   ------------------------
   SELECT nvl(max(txdate),to_date('11/11/2222','DD/MM/RRRR')) INTO V_IDATE
   FROM vw_tllog_all lg, afmast af, cfmast cf
   WHERE af.custid = cf.custid AND lg.msgacct = af.acctno AND lg.tltxcd = '0088'
   AND cf.custodycd = V_CUSTODYCD;

OPEN PV_REFCURSOR FOR

SELECT  main.fullname, main.idcode, main.iddate, main.idplace, main.address, main.phone, main.mobile,
        main.custodycd, main.wft_symbol symbol,
       CASE WHEN main.tradeplace = '001' THEN 'HOSE'
            WHEN main.tradeplace = '002' THEN 'HNX'
            WHEN main.tradeplace = '005' THEN 'UPCOM'  END tradeplace,
       sum(CASE WHEN instr(symbol,'_WFT') = 0 THEN trade ELSE 0 END) trade,
       sum(CASE WHEN instr(symbol,'_WFT') = 0 THEN blocked ELSE 0 END) blocked,
       sum(CASE WHEN instr(symbol,'_WFT') <> 0 THEN trade ELSE 0 END) trade_WFT,
       sum(CASE WHEN instr(symbol,'_WFT') <> 0 THEN blocked ELSE 0 END) blocked_WFT
FROM (

    SELECT cf.fullname, DECODE(SUBSTR(CF.CUSTODYCD,4,1),'F',CF.TRADINGCODE,CF.IDCODE) idcode,
                 DECODE(SUBSTR(CF.CUSTODYCD,4,1),'F',CF.TRADINGCODEDT,CF.IDDATE) iddate,
               cf.idplace, cf.address, cf.phone, cf.mobile,cf.custodycd,
    nvl(sb.symbol,'') symbol, nvl(sb_wft.symbol,'') wft_symbol,
           nvl(sb_wft.sectype,'') sectype, nvl(sb_wft.issuerid,'') issuerid, nvl(sb_wft.tradeplace,'') tradeplace,
           nvl(se.trade,0) - sum(CASE WHEN tran.field = 'TRADE' AND tran.txcd = 'D' THEN - nvl(tran.namt,0)
                            WHEN tran.field = 'TRADE' AND tran.txcd = 'C' THEN nvl(tran.namt,0)
                            ELSE 0 END) trade,
           nvl(se.blocked,0) - sum(CASE WHEN tran.field = 'BLOCKED' AND tran.txcd = 'D' THEN - nvl(tran.namt,0)
                                WHEN tran.field = 'BLOCKED' AND tran.txcd = 'C' THEN nvl(tran.namt,0)
                                ELSE 0 END) blocked
    FROM ( SELECT cf.custodycd
   FROM vw_tllog_all lg, afmast af, cfmast cf
   WHERE af.custid = cf.custid AND lg.msgacct = af.acctno
   AND lg.tltxcd = '0088'
    group by cf.custodycd) tl,
    cfmast cf, afmast af,semast se,
    (SELECT * FROM vw_setran_gen WHERE txdate > V_IDATE and field in ('TRADE','BLOCKED')) tran, sbsecurities sb,
         sbsecurities sb_wft,  vw_tllog_all log
    WHERE
    tl.custodycd = cf.custodycd
    and cf.custodycd = V_CUSTODYCD
    AND af.custid = cf.custid
    AND af.acctno =  se.afacctno (+)
    and se.acctno = tran.acctno (+)
    AND se.codeid = sb.codeid (+)
    AND nvl(sb.refcodeid, sb.codeid) = sb_wft.codeid (+)
    --AND (substr(cf.custid,1,4) LIKE '%%' OR instr('%%',substr(cf.custid,1,4))<> 0)
    GROUP BY cf.fullname, cf.idcode, cf.iddate, cf.idplace, cf.address, cf.phone, cf.mobile,
    cf.custodycd, se.trade, se.blocked, sb.symbol, sb_wft.symbol,
    sb_wft.sectype, sb_wft.issuerid,sb_wft.tradeplace,cf.TRADINGCODEDT,CF.TRADINGCODE--, tran.field
) main
GROUP BY main.fullname, main.idcode, main.iddate, main.idplace, main.address,
main.phone, main.mobile,main.custodycd, main.wft_symbol, main.tradeplace
;



EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
End;
/

