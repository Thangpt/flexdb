CREATE OR REPLACE PROCEDURE se0008_org (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   PV_SYMBOL      IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2
  )
IS
--

-- BAO CAO Tong hop so du chung khoan
-- MODIFICATION HISTORY
-- PERSON       DATE                COMMENTS
-- ---------   ------  -------------------------------------------
-- TUNH        18-05-2010           CREATED
--
   CUR            PKG_REPORT.REF_CURSOR;
   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (4);                   -- USED WHEN V_NUMOPTION > 0

   v_OnDate date;
   v_CurrDate date;
   v_CustodyCD varchar2(20);
   v_AFAcctno varchar2(20);
   v_Symbol varchar2(20);

BEGIN

V_STROPTION := upper(OPT);
IF V_STROPTION = 'A' THEN
    V_STRBRID := '%';
ELSIF V_STROPTION = 'B' then
    V_STRBRID:= substr(BRID,1,2) || '__';
else
    V_STRBRID := BRID;
END IF;

v_OnDate:= to_date(I_DATE,'DD/MM/RRRR');
v_CustodyCD:= upper(replace(pv_custodycd,'.',''));
v_AFAcctno:= upper(replace(PV_AFACCTNO,'.',''));
v_Symbol := upper(PV_SYMBOL);

-- Get Current date
select to_date(varvalue,'DD/MM/RRRR') into v_CurrDate from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM';

if v_CustodyCD = 'ALL' or v_CustodyCD is null then
    -- v_CustodyCD := '%';
    v_CustodyCD := '';  -- Khong cho phep tao all so TK luu ky
else
    v_CustodyCD := v_CustodyCD;
end if;

if v_AFAcctno = 'ALL' or v_AFAcctno is null then
    v_AFAcctno := '%';
else
    v_AFAcctno := v_AFAcctno;
end if;

if v_Symbol = 'ALL' or v_Symbol is null then
    v_Symbol := '%';
else
    v_Symbol := v_Symbol;
end if;

-- Main report
OPEN PV_REFCURSOR FOR
select v_ondate Ondate,  cf.custid, cf.fullname, cf.custodycd,
    sebal.afacctno, sebal.symbol,
    nvl(trade,0) - nvl(se_trade_move_amt,0) - nvl(trade_sell_qtty,0) as  end_trade_bal,
    nvl(se_block.curr_block_qtty,0) - nvl(se_block_move.cr_block_amt,0) + nvl(se_block_move.dr_block_amt,0) as end_blocked_bal,  -- Han che chuyen nhuong
    (
        nvl(mortage,0) + nvl(STANDING,0)
        - nvl(mtg_sell_qtty,0)
        - nvl(se_mortage_move_amt,0)
        - nvl(se_STANDING_move_amt,0)
        + (
            nvl(blocked,0) - nvl(se_blocked_move_amt,0)
            - (nvl(se_block.curr_block_qtty,0) - nvl(se_block_move.cr_block_amt,0) + nvl(se_block_move.dr_block_amt,0) )
          )    --- phong toa khac
    ) end_mortage_bal ,
    nvl(netting,0) - nvl(se_netting_move_amt,0) + nvl(trade_sell_qtty,0) + nvl(mtg_sell_qtty,0) as  end_netting_bal,
    -(  nvl(STANDING,0) - nvl(se_STANDING_move_amt,0) ) as  end_STANDING_bal, -- Do standing luon <=0
    nvl(RECEIVING,0) - nvl(se_RECEIVING_move_amt,0) + nvl(order_buy_today.receiving_qtty,0) as  end_RECEIVING_bal,
    nvl(WITHDRAW,0) - nvl(se_WITHDRAW_move_amt,0) as  end_WITHDRAW_bal
from cfmast cf
inner join
(
    -- Tong so du CK hien tai group by tieu khoan, Symbol
    select cf.custid, se.afacctno, sb.symbol, se.acctno seacctno,
        sum(trade + blocked + mortage + netting + receiving) se_balance,
        sum(trade) trade, sum(blocked) blocked, sum(mortage) mortage, sum(netting) netting,
        sum(STANDING) STANDING, sum(RECEIVING) RECEIVING, sum(WITHDRAW) WITHDRAW
    from cfmast cf, afmast af, semast se, sbsecurities sb
    where cf.custid = af.custid and af.acctno = se.afacctno
        and se.codeid = sb.codeid
        and cf.custodycd like v_CustodyCD
        and sb.sectype <>'004'
        and af.acctno like v_AFAcctno
        and sb.symbol like v_Symbol
    group by  cf.custid, se.afacctno, sb.symbol, se.acctno
) sebal on cf.custid = sebal.custid

left join
(   -- Phat sinh ban chung khoan ngay hom nay
    select se.afacctno, symbol, se.acctno seacctno,
        case when v_OnDate = v_CurrDate then SUM(SECUREAMT) else 0 end trade_sell_qtty,
        case when v_OnDate = v_CurrDate then SUM(SECUREMTG) else 0 end mtg_sell_qtty
    from semast se, v_getsellorderinfo v, sbsecurities sb
    where
        se.acctno = v.seacctno
        and se.codeid = sb.codeid
        and se.afacctno like v_AFAcctno
    group by se.afacctno, symbol, se.acctno
) order_today on sebal.seacctno = order_today.seacctno

left join
(   -- Phat sinh mua chung khoan ngay hom nay
    select se.afacctno, symbol, se.acctno seacctno,
        case when v_OnDate = v_CurrDate then SUM(qtty) else 0 end receiving_qtty
    from cfmast cf, afmast af, semast se, sbsecurities sb, stschd  st
    where cf.custid = af.custid and af.acctno = se.afacctno
        and se.codeid = sb.codeid
        and se.acctno = st.acctno and st.duetype = 'RS' and st.status = 'N'
        and cf.custodycd like v_CustodyCD
        and af.acctno like v_AFAcctno
        and st.txdate = v_CurrDate
    group by se.afacctno, symbol, se.acctno
) order_buy_today on sebal.seacctno = order_buy_today.seacctno

left join
(
    -- Tong phat sinh field cac loai so du CK tu Ondate den ngay hom nay
    select tr.afacctno, tr.symbol, tr.acctno seacctno,
        sum
        (case when field = 'TRADE' then
                case when tr.txtype = 'D' then -tr.namt else tr.namt end
            else 0
            end
        ) se_trade_move_amt,            -- Phat sinh CK giao dich
        sum
        (case when field = 'MORTAGE' then
                case when tr.txtype = 'D' then -tr.namt else tr.namt end
             else 0
             end
        ) se_MORTAGE_move_amt ,         -- Phat sinh CK Phong toa gom ca STANDING
        sum
        (case when field = 'BLOCKED' then
                (case when tr.txtype = 'D' then -tr.namt else tr.namt end)
            else 0
            end
         ) se_BLOCKED_move_amt   ,      -- Phat sinh CK tam giu
        sum
        ( case when field = 'NETTING' then
                (case when tr.txtype = 'D' then -tr.namt else tr.namt end)
            else 0
            end
        ) se_NETTING_move_amt ,         -- Phat sinh CK cho giao
        sum
        ( case when field = 'STANDING' then
                (case when tr.txtype = 'D' then -tr.namt else tr.namt end)
            else 0
            end
        ) se_STANDING_move_amt,         -- Phat sinh CK cam co len TT Luu ky
        sum
        ( case when field = 'RECEIVING' then
                (case when tr.txtype = 'D' then -tr.namt else tr.namt end)
            else 0
            end
        ) se_RECEIVING_move_amt,         -- Phat sinh CK cho nhan ve
        sum
        ( case when field = 'WITHDRAW' then
                (case when tr.txtype = 'D' then -tr.namt else tr.namt end)
            else 0
            end
        ) se_WITHDRAW_move_amt         -- Phat sinh CK cho nhan ve
    from vw_setran_gen tr
    where
        tr.busdate > v_OnDate  and tr.busdate <= v_CurrDate
        and tr.afacctno like v_AFAcctno
        and tr.symbol like v_Symbol
        and tr.field in ('TRADE','MORTAGE','BLOCKED','NETTING','STANDING','RECEIVING','WITHDRAW')
    group by tr.afacctno, tr.symbol, tr.acctno
) se_field_move on sebal.seacctno = se_field_move.seacctno

left join   -- So du chung khoan chuyen nhuong co dieu kien
(
    select se.afacctno, sb.symbol, se.acctno seacctno,
        sum(a.qtty) curr_block_qtty
    from semastdtl a, semast se, afmast af, sbsecurities sb
    where a.acctno = se.acctno and se.afacctno = af.acctno
        and se.codeid = sb.codeid
        and qttytype = '002'
        and se.afacctno like v_AFAcctno
        and sb.symbol like v_Symbol
    group by se.afacctno, sb.symbol, se.acctno
) se_block on sebal.seacctno = se_block.seacctno

left join   -- Phat sinh giao dich phong toa/giai toa CK chuyen nhuong co dieu kien
(
    select tr.afacctno, tr.symbol, tr.acctno seacctno,
        sum(case when tr.tltxcd = '2202' then namt else 0 end) cr_block_amt,
        sum(case when tr.tltxcd = '2203' then namt else 0 end) dr_block_amt
    from vw_setran_gen tr
    where tr.field = 'BLOCKED'
        and tr.afacctno like v_AFAcctno
        and tr.symbol like v_Symbol
        and tr.busdate > v_OnDate and tr.busdate <= v_CurrDate
        and tr.tltxcd in ('2202','2203') and tr.ref = '002' and tr.namt <> 0
    group by tr.afacctno, tr.symbol, tr.acctno
) se_block_move on sebal.seacctno = se_block_move.seacctno

where cf.custodycd like v_CustodyCD
    and
    (
    abs(nvl(trade,0) - nvl(se_trade_move_amt,0) )
    + abs(nvl(blocked,0) - nvl(se_blocked_move_amt,0) )
    + abs(nvl(mortage,0) - nvl(se_mortage_move_amt,0) )
    + abs( nvl(netting,0) - nvl(se_netting_move_amt,0))
    + abs(-(  nvl(STANDING,0) - nvl(se_STANDING_move_amt,0) ))
    + abs(nvl(RECEIVING,0) - nvl(se_RECEIVING_move_amt,0) )
    + abs(nvl(WITHDRAW,0) - nvl(se_WITHDRAW_move_amt,0) )
    + abs(se_balance)
    ) > 0

order by symbol;

EXCEPTION
  WHEN OTHERS
   THEN
      RETURN;
END;
/

