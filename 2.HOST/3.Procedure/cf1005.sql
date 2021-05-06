CREATE OR REPLACE PROCEDURE cf1005 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   PV_CUSTODYCD       IN       VARCHAR2,
   PV_AFACCTNO       IN       VARCHAR2,
   TLID             IN VARCHAR2
  )
IS
--

-- BAO CAO So du chung khoan
-- MODIFICATION HISTORY
-- PERSON       DATE                COMMENTS
-- ---------   ------  -------------------------------------------
-- DIENNT        13-09-2011           CREATED
--
   CUR            PKG_REPORT.REF_CURSOR;
   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (4);                   -- USED WHEN V_NUMOPTION > 0

   v_TxDate date;
   v_CustodyCD varchar2(20);
   v_AFAcctno varchar2(20);
   v_CurrDate date;
   v_CareBy varchar2(100);
   v_GroupID varchar2(100);
   v_TLID varchar2(4);

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

v_TLID := trim(tlid);
v_TxDate:= to_date(F_DATE,'DD/MM/RRRR');
v_CustodyCD:= upper(replace(pv_custodycd,'.',''));
v_AFAcctno:= upper(replace(PV_AFACCTNO,'.',''));

-- select careby into v_CareBy from cfmast where custodycd = v_CustodyCD;
-- select max(gu.grpid) into v_GroupID from tlgrpusers gu where gu.tlid = TLID and grpid = v_CareBy ;

if v_AFAcctno = 'ALL' or v_AFAcctno is null then
    v_AFAcctno := '%';
else
    v_AFAcctno := v_AFAcctno;
end if;

-- Main report
OPEN PV_REFCURSOR FOR
select cf.custid, cf.fullname, cf.idcode, cf.iddate, cf.idplace, cf.address, cf.mobile, cf.custodycd,
    sebal.afacctno, sebal.symbol,
    nvl(se_balance,0) se_balance,
    nvl(trade,0) trade, nvl(trade,0) - nvl(se_trade_move_amt,0) - nvl(trade_sell_qtty,0) as  end_trade_bal,
    nvl(blocked,0),
    --- nvl(blocked,0) blocked, nvl(blocked,0) - nvl(se_blocked_move_amt,0) as  end_blocked_bal,
    nvl(se_block.curr_block_qtty,0) - nvl(se_block_move.cr_block_amt,0) + nvl(se_block_move.dr_block_amt,0) as end_blocked_bal, -- han che CN
    nvl(mortage,0) mortage,
    (
        nvl(mortage,0) + nvl(STANDING,0)
        - nvl(mtg_sell_qtty,0)
        - nvl(se_mortage_move_amt,0)
        - nvl(se_STANDING_move_amt,0)
        + (
            nvl(blocked,0) - nvl(se_blocked_move_amt,0)
            - (nvl(se_block.curr_block_qtty,0) - nvl(se_block_move.cr_block_amt,0) + nvl(se_block_move.dr_block_amt,0) )
          )     -- ck bi phong toa khac
     )    as  end_mortage_bal,
    nvl(netting,0) netting, nvl(netting,0) - nvl(se_netting_move_amt,0) + nvl(trade_sell_qtty,0) + nvl(mtg_sell_qtty,0) as  end_netting_bal,
    nvl(STANDING,0) standing, -(  nvl(STANDING,0) - nvl(se_STANDING_move_amt,0) ) as  end_STANDING_bal, -- Do standing luon <=0
    nvl(RECEIVING,0) receiving, nvl(RECEIVING,0) - nvl(se_RECEIVING_move_amt,0) + nvl(order_buy_today.receiving_qtty,0) as  end_RECEIVING_bal,
    nvl(WITHDRAW,0) WITHDRAW, nvl(WITHDRAW,0) - nvl(se_WITHDRAW_move_amt,0) as  end_WITHDRAW_bal,
    LOAN, MARGIN, secured, wtrade, DEPOSIT, PENDING
from cfmast cf,afmast af ----dien them table afmast ---2-10-2010
left join
(
    -- Tong so du CK hien tai group by tieu khoan, Symbol
    select cf.custid, af.acctno afacctno, symbol, se.acctno,
        sum(trade + blocked + mortage + netting + receiving) se_balance,
        sum(trade) trade, sum(blocked) blocked, sum(mortage) mortage, sum(netting) netting,
        sum(STANDING) STANDING, sum(RECEIVING) RECEIVING, sum(WITHDRAW) WITHDRAW,
        sum(se.LOAN) LOAN,sum(se.MARGIN) MARGIN, sum(se.secured) secured, sum(se.wtrade) wtrade,
        sum(se.DEPOSIT) DEPOSIT,sum(se.PENDING) PENDING
    from cfmast cf, afmast af, semast se, sbsecurities sb
    where cf.custid = af.custid and af.acctno = se.afacctno
        and se.codeid = sb.codeid and cf.custodycd = v_CustodyCD
        and af.acctno like v_AFAcctno
        and sb.sectype <>'004'
    group by  cf.custid, af.acctno, symbol,se.acctno
) sebal on af.acctno = sebal.afacctno -------cf.custid=sebal.custid ---dien sua 2-10-2010

left join
(   -- Phat sinh ban chung khoan ngay hom nay
    select se.acctno,
        case when v_CurrDate = v_TxDate then SUM(SECUREAMT) else 0 end trade_sell_qtty,
        case when v_CurrDate = v_TxDate then SUM(SECUREMTG) else 0 end mtg_sell_qtty
    from cfmast cf, afmast af, semast se, v_getsellorderinfo v, sbsecurities sb
    where cf.custid = af.custid and af.acctno = se.afacctno
        and se.acctno = v.seacctno
        and se.codeid = sb.codeid
        and sb.sectype <>'004'
        and cf.custodycd = v_CustodyCD
        and af.acctno like v_AFAcctno
    group by se.acctno
) order_today on sebal.acctno = order_today.acctno

left join
(   -- Phat sinh mua chung khoan ngay hom nay
    select se.acctno,
        case when v_CurrDate = v_TxDate then SUM(qtty) else 0 end receiving_qtty
    from cfmast cf, afmast af, semast se, sbsecurities sb, stschd  st
    where cf.custid = af.custid and af.acctno = se.afacctno
        and se.codeid = sb.codeid
         and sb.sectype <>'004'
        and se.acctno = st.acctno and st.duetype = 'RS' and st.status = 'N'
        and cf.custodycd = v_CustodyCD
        and af.acctno like v_AFAcctno
        and st.txdate = v_CurrDate
    group by se.acctno
) order_buy_today on sebal.acctno = order_buy_today.acctno

left join
(
    -- Tong phat sinh field cac loai so du CK tu Txdate den ngay hom nay
    select tr.acctno,
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
    where tr.busdate > v_TxDate and tr.busdate <= v_CurrDate
        and tr.custodycd = v_CustodyCD
        and tr.afacctno like v_AFAcctno
        and tr.sectype <>'004'
        and tr.field in ('TRADE','MORTAGE','BLOCKED','NETTING','STANDING','RECEIVING','WITHDRAW')
    group by tr.acctno
) se_field_move on sebal.acctno = se_field_move.acctno

left join   -- So du chung khoan chuyen nhuong co dieu kien
(
    select se.acctno,
        sum(a.qtty) curr_block_qtty
    from semastdtl a, semast se, afmast af, sbsecurities sb, cfmast cf
    where a.acctno = se.acctno and se.afacctno = af.acctno
        and cf.custid = af.custid
        and se.codeid = sb.codeid
        and a.qttytype = '002'
        and sb.sectype <>'004'
        and cf.custodycd = v_CustodyCD
        and se.afacctno like v_AFAcctno
    group by se.acctno
) se_block on sebal.acctno = se_block.acctno

left join   -- Phat sinh giao dich phong toa/giai toa CK chuyen nhuong co dieu kien
(
    select tr.acctno,
        sum(case when tr.tltxcd = '2202' then namt else 0 end) cr_block_amt,
        sum(case when tr.tltxcd = '2203' then namt else 0 end) dr_block_amt
    from vw_setran_gen tr
    where tr.field = 'BLOCKED'
        and tr.afacctno like v_AFAcctno
        and tr.custodycd = v_CustodyCD
        and tr.tltxcd in ('2202','2203') and tr.ref = '002' and tr.namt <> 0
        and tr.busdate > v_TxDate and tr.busdate <= v_CurrDate
    group by tr.acctno
) se_block_move on sebal.acctno = se_block_move.acctno

where cf.custodycd = v_CustodyCD
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

order by sebal.symbol, sebal.afacctno;

EXCEPTION
  WHEN OTHERS
   THEN
      RETURN;
END;
/

