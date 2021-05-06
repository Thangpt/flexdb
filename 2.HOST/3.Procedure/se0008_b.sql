CREATE OR REPLACE PROCEDURE se0008_B (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
/*   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,*/
   I_DATE         IN       VARCHAR2,
   I_BRID         IN       VARCHAR2,
   PV_TRADEPLACE  IN       VARCHAR2,
   PV_SYMBOL      IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2
  )
IS
--


--
   CUR            PKG_REPORT.REF_CURSOR;
   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (4);                   -- USED WHEN V_NUMOPTION > 0
   v_strIBRID     VARCHAR2 (4);
   vn_BRID        varchar2(50);
   vn_TRADEPLACE varchar2(50);
   v_strTRADEPLACE VARCHAR2 (4);
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

IF  (PV_SYMBOL <> 'ALL')
THEN
      v_Symbol := upper(PV_SYMBOL);
ELSE
   v_Symbol := '%%';
END IF;

IF  (PV_CUSTODYCD <> 'ALL')
THEN
      v_CustodyCD := upper(PV_CUSTODYCD);
ELSE
   v_CustodyCD := '%%';
END IF;

IF  (PV_AFACCTNO <> 'ALL')
THEN
      v_AFAcctno := upper(PV_AFACCTNO);
ELSE
   v_AFAcctno := '%%';
END IF;

IF  (upper(I_BRID) <> 'ALL')
THEN
      v_strIBRID := upper(I_BRID);
      SELECT brname INTO vn_BRID FROM brgrp WHERE brgrp.brid LIKE I_BRID;
ELSE
   v_strIBRID := '%%';
   vn_BRID := 'ALL';
END IF;

IF  (upper(PV_TRADEPLACE) <> 'ALL')
THEN
      v_strTRADEPLACE := upper(PV_TRADEPLACE);
      SELECT cdcontent INTO vn_TRADEPLACE FROM allcode WHERE cdtype = 'SE' AND cdname = 'TRADEPLACE' AND cdval like PV_TRADEPLACE ;
ELSE
   v_strTRADEPLACE := '%%';
   vn_TRADEPLACE := 'ALL';
END IF;

v_OnDate:= to_date(I_DATE,'DD/MM/RRRR');
--v_CustodyCD:= upper(replace(pv_custodycd,'.',''));
--v_AFAcctno:= upper(replace(PV_AFACCTNO,'.',''));
--v_Symbol := upper(PV_SYMBOL);

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
    v_Symbol := '%'||v_Symbol||'%';
end if;

-- Main report
OPEN PV_REFCURSOR FOR
SELECT v_OnDate txdate,custid, fullname, idcode, iddate, idplace, address, mobile, custodycd, afacctno, symbol,
        sum(se_balance) se_balance, sum(trade) trade, sum(end_trade_bal) end_trade_bal, sum(blocked) blocked, sum(end_blocked_bal) end_blocked_bal,
        sum(mortage) mortage, sum(end_mortage_bal) end_mortage_bal, sum(netting) netting, sum(end_netting_bal) end_netting_bal, sum(standing) standing,
       sum(end_STANDING_bal) end_STANDING_bal,sum(receiving) receiving,sum(end_RECEIVING_bal) end_RECEIVING_bal,sum(CA_RECEIVING) CA_RECEIVING,
       sum(WITHDRAW) WITHDRAW,sum(end_WITHDRAW_bal) end_WITHDRAW_bal, sum(ck_cho_gd) ck_cho_gd,
       vn_BRID chi_nhanh,vn_TRADEPLACE san_gd ,v_CustodyCD v_custody,v_AFAcctno v_afacc,v_Symbol v_lsymbol, I_DATE ngay_tc
FROM
(select cf.custid, cf.fullname, cf.idcode, cf.iddate, cf.idplace, cf.address, cf.mobile, cf.custodycd,
    sebal.afacctno, CASE WHEN instr(sebal.symbol,'_WFT') <> 0 THEN substr(sebal.symbol,1, instr(sebal.symbol,'_WFT')-1) ELSE sebal.symbol END symbol,
    CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0 ELSE nvl(se_balance,0) END se_balance,
    CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0 ELSE nvl(trade,0) END trade,
    CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0 ELSE nvl(trade,0) - nvl(se_trade_move_amt,0) - nvl(trade_sell_qtty,0) END  end_trade_bal,
    CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0 ELSE nvl(blocked,0) END blocked,
    --- nvl(blocked,0) blocked, nvl(blocked,0) - nvl(se_blocked_move_amt,0) as  end_blocked_bal,
    CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0 ELSE nvl(se_block.curr_block_qtty,0) - nvl(se_block_move.cr_block_amt,0) + nvl(se_block_move.dr_block_amt,0) END end_blocked_bal, -- han che CN
    CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0 ELSE nvl(mortage,0) END mortage,
    CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0 ELSE (
        nvl(mortage,0) + nvl(STANDING,0)
        - nvl(mtg_sell_qtty,0)
        - nvl(se_mortage_move_amt,0)
        - nvl(se_STANDING_move_amt,0)
        + (
            nvl(blocked,0) - nvl(se_blocked_move_amt,0)
            - (nvl(se_block.curr_block_qtty,0) - nvl(se_block_move.cr_block_amt,0) + nvl(se_block_move.dr_block_amt,0) )
          )     -- ck bi phong toa khac
     )    END  end_mortage_bal,
    CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0 ELSE nvl(netting,0) END netting,
    CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0 ELSE nvl(netting,0) - nvl(se_netting_move_amt,0) + nvl(trade_sell_qtty,0) + nvl(mtg_sell_qtty,0) END  end_netting_bal,
    CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0 ELSE nvl(STANDING,0) END  standing,
    CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0 ELSE -(  nvl(STANDING,0) - nvl(se_STANDING_move_amt,0) ) END  end_STANDING_bal, -- Do standing luon <=0
    CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0 ELSE nvl(RECEIVING,0) END receiving,
    --CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0 ELSE nvl(RECEIVING,0) - nvl(se_RECEIVING_move_amt,0) +  nvl(CA_RECEIVING,0) + nvl(order_buy_today.receiving_qtty,0 ) END  end_RECEIVING_bal,
    nvl(RECEIVING,0) - nvl(se_RECEIVING_move_amt,0) +  nvl(CA_RECEIVING,0) + nvl(order_buy_today.receiving_qtty,0 ) end_RECEIVING_bal,
    CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0 ELSE nvl(CA_RECEIVING,0) END CA_RECEIVING,
    CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0 ELSE nvl(WITHDRAW,0) END  WITHDRAW,
    CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0 ELSE nvl(WITHDRAW,0) - nvl(se_WITHDRAW_move_amt,0) END  end_WITHDRAW_bal,
    CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN (
    nvl(trade,0) - nvl(se_trade_move_amt,0) - nvl(trade_sell_qtty,0) +
    (
        nvl(mortage,0) + nvl(STANDING,0)
        - nvl(mtg_sell_qtty,0)
        - nvl(se_mortage_move_amt,0)
        - nvl(se_STANDING_move_amt,0)
        + (
            nvl(blocked,0) - nvl(se_blocked_move_amt,0)
            --GianhVG bo comment nay di - ( --nvl(se_block.curr_block_qtty,0)
            - ( nvl(se_block.curr_block_qtty,0)
            - nvl(se_block_move.cr_block_amt,0) + nvl(se_block_move.dr_block_amt,0) )
          )     -- ck bi phong toa khac
     ) +
     nvl(se_block.curr_block_qtty,0) - nvl(se_block_move.cr_block_amt,0) + nvl(se_block_move.dr_block_amt,0) +
     nvl(netting,0) - nvl(se_netting_move_amt,0) + nvl(trade_sell_qtty,0) + nvl(mtg_sell_qtty,0)
     -(  nvl(STANDING,0) - nvl(se_STANDING_move_amt,0) ) +
     --nvl(RECEIVING,0) - nvl(se_RECEIVING_move_amt,0) +  nvl(CA_RECEIVING,0) + nvl(order_buy_today.receiving_qtty,0 ) +
      nvl(WITHDRAW,0) - nvl(se_WITHDRAW_move_amt,0)
    ) ELSE 0 END ck_cho_gd
from cfmast cf,afmast af,
--left join
(
    -- Tong so du CK hien tai group by tieu khoan, Symbol
    select cf.custid, af.acctno afacctno, symbol, se.acctno,
        sum(trade + blocked + mortage + netting + receiving) se_balance,
        sum(trade) trade, sum(blocked) blocked, sum(mortage) mortage, sum(netting) netting,
        sum(STANDING) STANDING, sum(RECEIVING) RECEIVING, sum(WITHDRAW) WITHDRAW
    from cfmast cf, afmast af, semast se, --sbsecurities sb
        (select sb.*, nvl(wtf.tradeplace,sb.tradeplace) wtf_tradeplace
        from sbsecurities sb,sbsecurities wtf
            where sb.refcodeid = wtf.codeid(+)) sb
    where cf.custid = af.custid and af.acctno = se.afacctno
        and se.codeid = sb.codeid and cf.custodycd like v_CustodyCD
        and sb.symbol like v_Symbol
        --and sb.tradeplace like v_strTRADEPLACE
        and sb.wtf_tradeplace like v_strTRADEPLACE
        and af.brid like v_strIBRID
        and af.acctno like v_AFAcctno
        and sb.sectype <>'004'
    group by  cf.custid, af.acctno, symbol,se.acctno
) sebal --on af.acctno = sebal.afacctno -------cf.custid=sebal.custid ---dien sua 2-10-2010

left join
(   -- Phat sinh ban chung khoan ngay hom nay
    select se.acctno,
        case when v_CurrDate = v_OnDate then SUM(SECUREAMT) else 0 end trade_sell_qtty,
        case when v_CurrDate = v_OnDate then SUM(SECUREMTG) else 0 end mtg_sell_qtty
    from cfmast cf, afmast af, semast se, v_getsellorderinfo v, sbsecurities sb
    where cf.custid = af.custid and af.acctno = se.afacctno
        and se.acctno = v.seacctno
        and se.codeid = sb.codeid
        and sb.sectype <>'004'
        and cf.custodycd like v_CustodyCD
        and af.acctno like v_AFAcctno
    group by se.acctno
) order_today on sebal.acctno = order_today.acctno

left join
(   -- Phat sinh mua chung khoan ngay hom nay
    select se.acctno,
        case when v_CurrDate = v_OnDate then SUM(qtty) else 0 end receiving_qtty
    from cfmast cf, afmast af, semast se, sbsecurities sb, stschd  st
    where cf.custid = af.custid and af.acctno = se.afacctno
        and se.codeid = sb.codeid
         and sb.sectype <>'004'
        and se.acctno = st.acctno and st.duetype = 'RS' and st.status = 'N'
        and af.brid like v_strIBRID
        and cf.custodycd like v_CustodyCD
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
        ( case when field = 'RECEIVING' and txcd in('3351','3350') then
                (case when tr.txtype = 'D' then -tr.namt else tr.namt end)
            else 0
            end
        ) CA_RECEIVING,
        sum
        ( case when field = 'WITHDRAW' then
                (case when tr.txtype = 'D' then -tr.namt else tr.namt end)
            else 0
            end
        ) se_WITHDRAW_move_amt         -- Phat sinh CK cho nhan ve

    from vw_setran_gen tr
    where tr.busdate > v_OnDate and tr.busdate <= v_CurrDate
        AND tr.symbol LIKE v_Symbol
        and tr.custodycd like v_CustodyCD
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
        AND sb.symbol LIKE v_Symbol
        and cf.custodycd like v_CustodyCD
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
        AND tr.symbol LIKE v_Symbol
        and tr.afacctno like v_AFAcctno
        and tr.custodycd like v_CustodyCD
        and tr.tltxcd in ('2202','2203') and tr.ref = '002' and tr.namt <> 0
        and tr.busdate > v_OnDate and tr.busdate <= v_CurrDate
    group by tr.acctno
) se_block_move on sebal.acctno = se_block_move.acctno

where cf.custodycd like v_CustodyCD
     -----------select gu.grpid from tlgrpusers gu where gu.grpid=cf.careby and gu.tlid = tlid---- dien sua 2-10-2010
    --and exists (select gu.grpid from tlgrpusers gu where af.careby=gu.grpid   and gu.tlid = v_TLID)   -- check careby
    AND v_OnDate <= v_CurrDate
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

and af.acctno = sebal.afacctno
and af.custid = cf.custid
and cf.custatcom='Y'
order by sebal.symbol, sebal.afacctno)
GROUP BY v_OnDate,custid, fullname, idcode, iddate, idplace, address, mobile, custodycd, afacctno, symbol,vn_BRID,vn_TRADEPLACE,v_CustodyCD,v_AFAcctno,v_Symbol, I_DATE
having
         sum(end_trade_bal)+
          sum(end_blocked_bal)+

       sum(end_mortage_bal)+
       sum(end_netting_bal)+
       sum(end_STANDING_bal) +
       sum(end_RECEIVING_bal) +

      sum(end_WITHDRAW_bal)+ sum(ck_cho_gd)  >0;


EXCEPTION
  WHEN OTHERS
   THEN
   dbms_output.put_line('12233');
      RETURN;
END;
/

