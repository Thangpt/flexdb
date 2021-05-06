CREATE OR REPLACE PROCEDURE GL1004 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   PV_CUSTODYCD       IN       VARCHAR2,
   PV_AFACCTNO       IN       VARCHAR2,
   PV_EXECTYPE       IN       VARCHAR2
  )
IS
--

-- BAO CAO KHOP LENH (THEO DEAL)
-- MODIFICATION HISTORY
-- PERSON       DATE                COMMENTS
-- ---------   ------  -------------------------------------------
-- TRUONGLD        13-05-2010           CREATED
--
   CUR            PKG_REPORT.REF_CURSOR;
   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (4);                   -- USED WHEN V_NUMOPTION > 0

   v_TxDate date;
   v_CustodyCD varchar2(20);
   v_AFAcctno varchar2(20);
   V_EXECTYPE varchar2(20);
   v_CurrDate date;
   v_PrevDate date;
   v_CareBy varchar2(100);
   v_GroupID varchar2(100);

BEGIN

V_STROPTION := OPT;
IF V_STROPTION = 'A' then
    V_STRBRID := '%';
ELSIF V_STROPTION = 'B' then
    V_STRBRID := substr(BRID,1,2) || '__' ;
else
    V_STRBRID:=BRID;
END IF;



select to_date(varvalue,'DD/MM/RRRR') into v_CurrDate from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM';

select to_date(varvalue,'DD/MM/RRRR') into v_PrevDate from sysvar where varname = 'PREVDATE' and grname = 'SYSTEM';

v_TxDate:= to_date(F_DATE,'DD/MM/RRRR');
v_CustodyCD:= upper(replace(pv_custodycd,'.',''));
v_AFAcctno:= upper(replace(PV_AFACCTNO,'.',''));

-- select careby into v_CareBy from cfmast where custodycd = v_CustodyCD;
-- select max(gu.grpid) into v_GroupID from tlgrpusers gu where gu.tlid = TLID and grpid = v_CareBy ;

if PV_EXECTYPE = 'ALL' or PV_EXECTYPE is null then
    V_EXECTYPE := '%';
else
    V_EXECTYPE := PV_EXECTYPE;
end if;

if v_CustodyCD = 'ALL' or v_CustodyCD is null then
    v_CustodyCD := '%';
else
    v_CustodyCD := v_CustodyCD;
end if;

if v_AFAcctno = 'ALL' or v_AFAcctno is null then
    v_AFAcctno := '%';
else
    v_AFAcctno := v_AFAcctno;
end if;

-- Main report
OPEN PV_REFCURSOR FOR
SELECT nvl(PV_CUSTODYCD, 'ALL') PV_CUSTODYCD, nvl(PV_AFACCTNO, 'ALL') PV_AFACCTNO, nvl(PV_EXECTYPE, 'ALL') PV_EXECTYPE,   cfm.custid, cfm.fullname, cfm.custodycd, sebal.afacctno, sebal.symbol, od.BRID, od.BRNAME, od.TLID, od.TLNAME,
    nvl(trade,0) trade, nvl(trade,0) - nvl(se_trade_move_amt,0) - nvl(trade_sell_qtty,0) as  end_trade_bal,
    nvl(od.TXDATE, '') txdate, nvl(od.EXECTYPE, '') EXECTYPE, nvl(od.ISETS, '') ISETS,
    nvl(od.dfacctno, '') dfacctno, nvl(od.SQTTY, 0) SQTTY, nvl(od.samt,0) samt,
    nvl(od.bqtty,0) bqtty, nvl(od.bamt, 0) bamt
from (
        select cfm.custid, cfm.fullname, cfm.idcode, cfm.iddate, cfm.idplace, cfm.address, cfm.mobile, cfm.custodycd, afm.acctno
        from afmast afm, cfmast cfm
        where afm.custid=cfm.custid
              and cfm.custodycd like v_CustodyCD
              and afm.acctno like v_AFAcctno
     ) cfm
inner join
(
     -- LAY THONG TIN KHOP LENH
     SELECT OD.AFACCTNO, od.TXDATE, sb.symbol, od.EXECTYPE, od.dfacctno, tl.BRID, tl.BRNAME, tl.TLID, tl.TLNAME, od.VIA,
       (CASE WHEN od.ORDERID LIKE '89%' THEN 'Y' ELSE 'N' END) ISETS,
       SUM(CASE WHEN OD.EXECTYPE IN ('NS', 'MS', 'SS') THEN OD.EXECQTTY ELSE 0 END) SQTTY,
       SUM(CASE WHEN OD.EXECTYPE IN ('NS', 'MS', 'SS') THEN OD.EXECAMT ELSE 0 END) SAMT,
       SUM(CASE WHEN OD.EXECTYPE IN ('NB', 'MB', 'SB') THEN OD.EXECQTTY ELSE 0 END) BQTTY,
       SUM(CASE WHEN OD.EXECTYPE IN ('NB', 'MB', 'SB') THEN OD.EXECAMT ELSE 0 END) BAMT
    FROM vw_odmast_all od, sbsecurities  sb, vw_order_by_broker_all tl
    WHERE od.CODEID = sb.codeid
          and od.ORDERID=tl.ORDERID
          AND od.txdate = v_TxDate
          and od.EXECQTTY > 0
          and od.AFACCTNO like v_AFAcctno
          AND od.EXECTYPE LIKE V_EXECTYPE
          and od.DELTD <> 'Y'
    GROUP BY OD.AFACCTNO, od.TXDATE, sb.symbol, od.EXECTYPE, od.dfacctno, tl.BRID, tl.BRNAME, tl.TLID, tl.TLNAME, od.VIA,
             CASE WHEN od.ORDERID LIKE '89%' THEN 'Y' ELSE 'N' END
)OD ON OD.AFACCTNO = cfm.ACCTNO

left join
(
    -- Tong so du CK hien tai group by tieu khoan, Symbol
    select cf.custid, af.acctno afacctno, symbol, se.acctno, sum(trade) trade
    from cfmast cf, afmast af, semast se, sbsecurities sb
    where cf.custid = af.custid and af.acctno = se.afacctno
        and se.codeid = sb.codeid
        and cf.custodycd like v_CustodyCD
        and af.acctno like v_AFAcctno
        and sb.sectype <>'004'
    group by  cf.custid, af.acctno, symbol, se.acctno
) sebal on cfm.custid = sebal.custid

left join
(   -- Phat sinh ban chung khoan ngay hom nay
    select se.acctno,
        case when v_CurrDate = v_TxDate then SUM(SECUREAMT) else 0 end trade_sell_qtty
    from cfmast cf, afmast af, semast se, v_getsellorderinfo v, sbsecurities sb
    where cf.custid = af.custid and af.acctno = se.afacctno
        and se.acctno = v.seacctno
        and se.codeid = sb.codeid
        and sb.sectype <>'004'
        and cf.custodycd  like v_CustodyCD
        and af.acctno like v_AFAcctno
    group by se.acctno
) order_today on sebal.acctno = order_today.acctno

left join
(
    -- Tong phat sinh field cac loai so du CK tu Txdate den ngay PrevDate
    select tr.acctno,
        sum
        (case when field = 'TRADE' then
                case when tr.txtype = 'D' then -tr.namt else tr.namt end
            else 0
            end
        ) se_trade_move_amt            -- Phat sinh CK giao dich
    from vw_setran_gen tr
    where tr.busdate > v_TxDate and tr.busdate <= v_CurrDate
        and tr.custodycd like v_CustodyCD
        and tr.afacctno like v_AFAcctno
        and tr.sectype <>'004'
        and tr.field in ('TRADE')
    group by tr.acctno
) se_field_move on sebal.acctno = se_field_move.acctno
where od.symbol = sebal.symbol
ORDER BY  cfm.custodycd, sebal.symbol

;

EXCEPTION
  WHEN OTHERS
   THEN
      RETURN;
END;
/

