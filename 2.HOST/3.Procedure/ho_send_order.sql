-- Start of DDL Script for View HOSTMSTRADE.HO_SEND_ORDER
-- Generated 11/04/2017 10:16:20 AM from HOSTMSTRADE@FLEX_111

CREATE OR REPLACE VIEW ho_send_order (
   bors,
   firm,
   actype,
   typename,
   class,
   offtime,
   txtime,
   orderid,
   exectype,
   codeid,
   symbol,
   quoteprice,
   tradelot,
   stopprice,
   limitprice,
   orderqtty,
   oodprice,
   oodqtty,
   tlid,
   brid,
   txdate,
   txnum,
   fullname,
   custodycd,
   issuers,
   custid,
   oodstatus,
   afacctno,
   ciacctno,
   seacctno,
   tradeunit,
   bratio,
   oldbratio,
   reforderid,
   securedratiomin,
   securedratiomax,
   matchtype,
   nork,
   pricetype,
   clearday,
   txdesc,
   tltxcd,
   orstatus,
   via )
AS
SELECT   "BORS","FIRM","ACTYPE","TYPENAME","CLASS","OFFTIME","TXTIME","ORDERID","EXECTYPE","CODEID","SYMBOL", (CASE WHEN pricetype='ATO' THEN 'ATO' WHEN pricetype='ATC' THEN 'ATC' WHEN pricetype='MP' THEN 'MP'  ELSE TO_CHAR(quoteprice) END ) "QUOTEPRICE","TRADELOT","STOPPRICE","LIMITPRICE","ORDERQTTY","OODPRICE","OODQTTY","TLID","BRID","TXDATE","TXNUM","FULLNAME","CUSTODYCD","ISSUERS","CUSTID","OODSTATUS","AFACCTNO","CIACCTNO","SEACCTNO","TRADEUNIT","BRATIO","OLDBRATIO","REFORDERID","SECUREDRATIOMIN","SECUREDRATIOMAX","MATCHTYPE","NORK","PRICETYPE","CLEARDAY","TXDESC","TLTXCD","ORSTATUS","VIA"
       FROM (SELECT a.bors, s.sysvalue firm, c.actype, d.typename, j.CLASS,
                    tllog.offtime, tllog.txtime, orgorderid orderid,
                    c.exectype, a.codeid, a.symbol,
                    c.quoteprice / l.tradeunit quoteprice, l.tradelot,
                    c.stopprice, c.limitprice, c.orderqtty, a.price oodprice,
                    a.qtty oodqtty, tllog.tlid, tllog.brid, a.txdate, a.txnum,
                    j.fullname, j.custodycd, k.fullname issuers, j.custid,
                    a.oodstatus, c.afacctno, c.ciacctno, c.seacctno,
                    l.tradeunit, c.bratio, c.bratio oldbratio, c.reforderid,
                    l.securedratiomin, l.securedratiomax, c.matchtype, c.nork,
                    c.pricetype, c.clearday, tllog.txdesc, tllog.tltxcd,
                    c.orstatus, c.via,C.LAST_CHANGE
               FROM ood a,
                    sbsecurities b,
                    odmast c,
                    odtype d,
                    afmast i,
                    cfmast j,
                    issuers k,
                    securities_info l,
                    tllog,
                    ordersys s,
                    ordersys tt,
                    ordersys mp
              WHERE (    a.codeid = b.codeid
                     AND a.orgorderid = c.orderid
                     AND c.actype = d.actype
                    )
                AND NVL(c.ISFO_ORDER,'N') <>'Y'
                AND a.txdate = tllog.txdate
                AND a.txnum = tllog.txnum
                AND (   tllog.txstatus = '1'
                     OR (    tllog.tltxcd IN ('8882', '8883')
                         AND tllog.txstatus = '1'
                        )
                    )
                AND b.codeid = l.codeid
                AND c.orstatus NOT IN ('3', '0', '6')
                AND c.afacctno = i.acctno
                AND i.custid = j.custid
                AND c.quoteprice <= l.ceilingprice
                AND c.quoteprice >= l.floorprice
                AND b.issuerid = k.issuerid
                AND b.tradeplace = '001'
                AND s.sysname = 'FIRM'
                AND oodstatus IN ('N')
                AND c.deltd <> 'Y'
                AND c.orstatus <> '7'
                AND c.matchtype = 'N'
                AND tt.sysname ='CONTROLCODE'
                and mp.sysname ='TIMESTAMPO'
                AND c.EXECTYPE <> 'CB' AND c.EXECTYPE <> 'CS'
                AND b.SECTYPE <>'006'
                AND b.symbol in (select trim(code) from ho_sec_info
                                 where NVL(SUSPENSION,'1') <>'S'
                                And NVL(delist,'1') <>'D'
                                and trim(stock_type)in ('1','3','4')
                                And NVL(halt_resume_flag,'1') not in ('H','A')
                                )
                AND (
                       (tt.sysvalue ='P' and c.pricetype in ('LO','ATO'))
                     or
                       (tt.sysvalue ='O' and c.pricetype in ('LO'))
                     or
                       (tt.sysvalue ='O' and c.pricetype in ('MP')
                       AND to_char(sysdate,'hh24miss') >=to_char(mp.sysvalue)
                       AND to_char(sysdate,'hh24miss') <=(case when to_char(sysdate,'hh24miss') >'120000' then '143000' else '113000' end)
                        )
                     or
                       (tt.sysvalue ='A' and c.pricetype in ('ATC','LO')
                       )
                    OR (   tt.sysvalue not in( 'P','O','A') and c.pricetype in ('ATO','LO')
                         AND (pck_hogw.fn_caculate_hose_time  > (SELECT SYSVALUE FROM ORDERSYS WHERE SYSNAME='QUEUETIMEFR') )
                         AND (pck_hogw.fn_caculate_hose_time  < (SELECT SYSVALUE FROM ORDERSYS WHERE SYSNAME='QUEUETIMETO') )
                        )
                      )
                    )
    ORDER BY  LAST_CHANGE
/


-- End of DDL Script for View HOSTMSTRADE.HO_SEND_ORDER

