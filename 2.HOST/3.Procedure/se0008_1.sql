CREATE OR REPLACE PROCEDURE se0008_1 (
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
   PV_AFACCTNO    IN       VARCHAR2,
   PV_SECTYPE     in       varchar2,
   PV_TLID        in       varchar2
  )
IS
--


--
   CUR            PKG_REPORT.REF_CURSOR;
   V_STROPT       VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (100);                   -- USED WHEN V_NUMOPTION > 0
   V_INBRID       VARCHAR2 (5);
   v_strIBRID     VARCHAR2 (4);
   vn_BRID        varchar2(50);
   vn_TRADEPLACE varchar2(50);
   v_strTRADEPLACE VARCHAR2 (4);
   v_OnDate date;
   v_CurrDate date;
   v_CustodyCD varchar2(20);
   v_AFAcctno varchar2(20);
   v_Symbol varchar2(20);
   v_sectype varchar2(20);
   v_tlid varchar2(20);

BEGIN

/*IF V_STROPTION = 'A' THEN
    V_STRBRID := '%';
ELSIF V_STROPTION = 'B' then
    V_STRBRID := BRID;
else
    V_STRBRID := BRID;
END IF;*/
    V_STROPT := upper(OPT);
    V_INBRID := BRID;
    if(V_STROPT = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPT = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := BRID;
        end if;
    end if;

IF  (PV_SYMBOL <> 'ALL')
THEN
      v_Symbol := upper(REPLACE (PV_SYMBOL,' ','_'));
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

if PV_SECTYPE <> 'ALL'
then
    v_sectype := PV_SECTYPE;
else
    v_sectype := '%%';
end if;

IF  (upper(I_BRID) <> 'ALL')
THEN
      v_strIBRID := upper(I_BRID);
      SELECT brname INTO vn_BRID FROM brgrp WHERE brgrp.brid LIKE I_BRID;
ELSE
   v_strIBRID := '%%';
   vn_BRID := 'ALL';
END IF;

IF  (upper(PV_TRADEPLACE) <> 'ALL' AND PV_TRADEPLACE <> '%%')
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

if PV_TLID = 'ALL' or PV_TLID is null then
    v_tlid := '%';
else
    v_tlid := PV_TLID;
end if;

-- Main report
OPEN PV_REFCURSOR FOR
select v_OnDate txdate , sebal.custid, sebal.fullname, sebal.idcode, sebal.iddate,
    sebal.idplace, sebal.address, sebal.mobile, sebal.custodycd, sebal.afacctno, sebal.symbol_g symbol,

    sum(se_balance) se_balance, sum(trade) trade,
    sum(case when instr(sebal.symbol,'_WFT') <> 0 then 0
        else trade - nvl(se_trade_move_amt,0) +
            secured - NVL(se_SECURED_move_amt,0) -
            nvl(trade_sell_qtty,0)
        end ) end_trade_bal,

    ------ SL CK HCCN
    sum(blocked) blocked,
    sum(CASE WHEN instr(sebal.symbol,'_WFT') <> 0 then 0 else
        nvl(se_block.curr_block_qtty,0) - nvl(se_BLOCKED_move_HCCN,0) end) end_blocked_bal,

    ------ SL CK phong toa
    sum(nvl(se_block.curr_block_pt,0)) mortage,
    sum(CASE WHEN instr(sebal.symbol,'_WFT') <> 0 then 0 else
        nvl(se_block.curr_block_pt,0) - nvl(se_BLOCKED_move_pt,0) end) end_mortage_bal,

    -------- cam co DF
    sum(CASE WHEN instr(sebal.symbol,'_WFT') <> 0 then 0 else
        (mortage - nvl(mtg_sell_qtty,0) - nvl(se_MORTAGE_move_amt,0) + nvl(sebal.STANDING,0)- nvl(se_STANDING_move_amt,0)) end) camco_df,

    -------- cam co VSD
    sum(nvl(sebal.STANDING,0)) standing,
    sum(CASE WHEN instr(sebal.symbol,'_WFT') <> 0 THEN 0 ELSE abs(nvl(sebal.STANDING,0)-
        nvl(se_STANDING_move_amt,0)) END) end_STANDING_bal,

    ------ ban cho giao
    sum(case when instr(sebal.symbol,'_WFT') <> 0 then 0
        else /*nvl(netting,0) - nvl(se_NETTING_move_amt,0) --CHAUNH add at 13/04/3013
            + */
            /*nvl(khop_qtty.execqtty,0) - NVL(SR_QTTY.se_RETAIL_move_amt,0)*/
            nvl(netting,0) - nvl(se_NETTING_move_amt,0)
            /*(nvl(khop_qtty.execqtty,0) + (nvl(NETTING,0) - nvl(order_sell_today.netting_st,0) - nvl(SR_QTTY.se_RETAIL_move_amt,0)))*/
        end) khop_qtty,

/*    ----- SL CK cho ve
    sum(nvl(receiving,0)) receiving, sum(nvl(CA_RECEIVING,0)) CA_RECEIVING,
   sum(nvl(RECEIVING,0) - nvl(se_RECEIVING_move_amt,0) +  nvl(CA_RECEIVING,0) +
        nvl(order_buy_today.receiving_qtty,0) ) end_RECEIVING_bal,
*/
    ----- SL CK cho ve
/*    sum(nvl(receiving,0)) receiving, --sum(nvl(CA_RECEIVING,0)) CA_RECEIVING,
    sum(nvl(RECEIVING,0) - nvl(se_RECEIVING_move_amt,0)-
        nvl(order_buy_today.receiving_st,0)) CA_RECEIVING,
    sum(nvl(order_buy_today.receiving_qtty,0) + nvl(order_buy_today.receiving_st,0)) end_RECEIVING_bal,
*/
    sum(nvl(receiving,0)) receiving, --sum(nvl(CA_RECEIVING,0)) CA_RECEIVING,
    sum(nvl(RECEIVING,0) - nvl(order_buy_today.receiving_st,0) - nvl(se_RETAIL_move_receiving_amt,0) - nvl(CA_RECEIVING,0)) CA_RECEIVING,
    sum(nvl(order_buy_today.receiving_qtty,0) + nvl(receiving,0) - nvl(se_RECEIVING_move_amt,0)
        - (nvl(RECEIVING,0) - nvl(order_buy_today.receiving_st,0) - nvl(se_RETAIL_move_receiving_amt,0) - nvl(CA_RECEIVING,0))) end_RECEIVING_bal,

    --- ban cho khop
    sum(nvl(netting,0)) netting,
    sum(case when instr(sebal.symbol,'_WFT') <> 0 then 0
        else (nvl(trade_sell_qtty,0) + nvl(mtg_sell_qtty,0) - nvl(khop_qtty,0)) end ) end_netting_bal,

    --- SL CK cho chuyen ra ngoai
    sum(nvl(WITHDRAW,0)) WITHDRAW,
    sum((CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0 ELSE nvl(WITHDRAW,0)  -
        nvl(se_WITHDRAW_move_amt,0)  +
        (nvl(sebal.blocked,0) - nvl(se_block.curr_block_pt,0) - nvl(se_block.curr_block_qtty,0) -
            nvl(se_BLOCKED_move_amt,0))
        END) + nvl(DTOCLOSE,0) - nvl(se_DTOCLOSE_move_amt,0))  end_WITHDRAW_bal,

    --- CK cho giao dich HCCN
 /*   sum(CASE WHEN instr(sebal.symbol,'_WFT') = 0 THEN 0 ELSE sebal.blocked -
           nvl(se_BLOCKED_move_wft,0) END) hccn_chogiao,
           */
    --NAMNT--
     sum(CASE WHEN instr(sebal.symbol,'_WFT') = 0 THEN 0 ELSE NVL(se_block.curr_block_qtty ,0)-
           nvl(se_BLOCKED_move_HCCN,0) END) hccn_chogiao,
---END NAMNT--
    --- tong CK cho giao dich
    sum(CASE WHEN instr(sebal.symbol,'_WFT') <> 0 THEN (
        nvl(trade,0) - nvl(se_trade_move_amt,0) - nvl(order_today.trade_sell_qtty,0) - nvl(order_today.mtg_sell_qtty,0) +
        nvl(mortage,0) - nvl(se_mortage_move_amt,0) -
        (nvl(STANDING,0) - nvl(se_STANDING_move_amt,0)) +
        nvl(netting,0) - nvl(se_netting_move_amt,0) +
        nvl(WITHDRAW,0) - nvl(se_WITHDRAW_move_amt,0) +
        NVL(sebal.blocked,0) - nvl(se_BLOCKED_move_wft,0)
        ) ELSE 0 END) ck_cho_gd,

       vn_BRID chi_nhanh,vn_TRADEPLACE san_gd ,v_CustodyCD v_custody,v_AFAcctno v_afacc,v_Symbol v_lsymbol, I_DATE ngay_tc
from
( -- Tong so du CK hien tai group by tieu khoan, Symbol
    select cf.custid, af.acctno afacctno, symbol, se.acctno, symbol_g, cf.fullname,
            cf.idcode, cf.iddate, cf.idplace, cf.address, cf.mobile, cf.custodycd, sectype,
        max(case when SUBSTR(cf.custodycd,4,1) = 'C' then 'MGTN'
            when SUBSTR(cf.custodycd,4,1) = 'F' then 'MGNN'
            when SUBSTR(cf.custodycd,4,1) = 'P' then 'TD'
            else '' end ) loai_TK,
        sum(trade + blocked + mortage + netting + receiving) se_balance,
        sum(trade) trade, sum(blocked) blocked, sum(mortage) mortage, sum(netting) netting,
        sum(STANDING) STANDING, sum(RECEIVING) RECEIVING, sum(WITHDRAW) WITHDRAW, sum(DTOCLOSE) DTOCLOSE,
        max(parvalue) parvalue, SUM(secured) secured
    from cfmast cf, afmast af, semast se, --sbsecurities sb
        (select sb.*, nvl(wtf.tradeplace,sb.tradeplace) wtf_tradeplace, fn_symbol_tradeplace( nvl(wtf.codeid,sb.codeid), i_date  ) tradeplacenew ,nvl(wtf.symbol,sb.symbol) symbol_g
        from sbsecurities sb,sbsecurities wtf
            where sb.refcodeid = wtf.codeid(+)) sb
    where cf.custid = af.custid and af.acctno = se.afacctno
        and cf.custatcom = 'Y'
        and se.codeid = sb.codeid
        and cf.custodycd like v_CustodyCD
        and af.acctno like v_AFAcctno
        and sb.symbol like v_Symbol
        and sb.tradeplacenew like v_strTRADEPLACE
---        and SUBSTR(cf.custodycd,4,1) like V_STRaftype
        and sb.sectype <> '004'
        AND cf.brid LIKE v_strIBRID
        --AND (af.brid LIKE V_STRBRID or instr(V_STRBRID,af.brid) <> 0 )
        and exists (select gu.grpid from tlgrpusers gu where af.careby = gu.grpid and gu.tlid = v_tlid )
    group by cf.custid, af.acctno , symbol, se.acctno, symbol_g, cf.fullname,
            cf.idcode, cf.iddate, cf.idplace, cf.address, cf.mobile, cf.custodycd, sectype
) sebal
left join
(    -- Tong phat sinh field cac loai so du CK tu Txdate den ngay hom nay
    select tr.acctno,
        sum
        (
            case when field = 'TRADE' then case when tr.txtype = 'D' then -tr.namt else tr.namt end else 0 end
        ) se_trade_move_amt,            -- Phat sinh CK giao dich
        sum
        (
            case when field = 'MORTAGE' then case when tr.txtype = 'D' then -tr.namt else tr.namt end else 0 end
        ) se_MORTAGE_move_amt ,         -- Phat sinh CK Phong toa gom ca STANDING
        sum
        (
            case when field = 'BLOCKED' and nvl(tr.ref,' ') <> '002' and nvl(tr.ref,' ') <> '007' ---- and tr.tltxcd not in ('2263','3356')
                then
                (case when tr.txtype = 'D' then -tr.namt else tr.namt end)
            else 0 end
         ) se_BLOCKED_move_amt,      -- Phat sinh CK tam giu
        sum
        (
            case when field = 'BLOCKED' and tr.ref = '002'
                then
                (case when tr.txtype = 'D' then -tr.namt else tr.namt end)
            else 0 end
         ) se_BLOCKED_move_HCCN,      -- Phat sinh CK tam giu

        sum
        (
            case when field = 'BLOCKED' and tr.ref = '007'
                then
                (case when tr.txtype = 'D' then -tr.namt else tr.namt end)
            else 0 end
         ) se_BLOCKED_move_pt,      -- Phat sinh CK tam giu

         sum
        (
            case when field = 'BLOCKED'
            then (case when tr.txtype = 'C' then tr.namt else -tr.namt end) else 0 end
        ) se_BLOCKED_move_wft,

        sum
        ( case when field = 'NETTING' then
                (case when tr.txtype = 'D' then -tr.namt else tr.namt end)
            else 0
            end
        ) se_NETTING_move_amt ,         -- Phat sinh CK cho giao
        sum
        ( case when field = 'STANDING' then
                (case when tr.txtype = 'D' then -tr.namt else tr.namt end)
            else 0 end
        ) se_STANDING_move_amt,         -- Phat sinh CK cam co len TT Luu ky
        sum
        ( case when field = 'RECEIVING' then
                (case when tr.txtype = 'D' then -tr.namt else tr.namt end)
            else 0
            end
        ) se_RECEIVING_move_amt,         -- Phat sinh CK cho nhan ve
        sum
        ( case when field = 'RECEIVING' and tltxcd in ('3351','3350','3394','3384','3324','3326','3380','2244','3329','3330','3386','2254') then
                (case when tr.txtype = 'D' then -tr.namt else tr.namt end)
            else 0
            end
        ) CA_RECEIVING,
        sum
        ( case when field = 'WITHDRAW' then
                (case when tr.txtype = 'D' then -tr.namt else tr.namt end)
            else 0
            end
        ) se_WITHDRAW_move_amt,         -- Phat sinh CK cho nhan ve
        sum
        ( case when field = 'DTOCLOSE' then
                (case when tr.txtype = 'D' then -tr.namt else tr.namt end)
            else 0
            end
        ) se_DTOCLOSE_move_amt,
        sum
        ( case when field = 'SECURED' then
                (case when tr.txtype = 'D' then -tr.namt else tr.namt end)
            else 0
            end
        ) se_SECURED_move_amt
    from vw_setran_gen tr
    where tr.sectype <> '004'
        AND TR.deltd <> 'Y'
        and tr.busdate > v_OnDate and tr.busdate <= v_CurrDate
        and tr.field in ('TRADE','MORTAGE','BLOCKED','NETTING','STANDING','RECEIVING','WITHDRAW','DTOCLOSE','SECURED')
--                        ('TRADE','MORTAGE','BLOCKED','NETTING','WITHDRAW','SECURED','DTOCLOSE','WTRADE')
    group by tr.acctno
) se_field_move on sebal.acctno = se_field_move.acctno
left join
(--- so luong chung khoan ban cho giao
    select seacctno, sum(execqtty) execqtty
    from
    (
    select codeid, afacctno, seacctno, execqtty, txdate from odmast
    where execqtty > 0
        and exectype in ('MS','NS')
        and txdate <= v_OnDate
        and deltd <> 'Y'
    union all
    select odhist.codeid, odhist.afacctno, seacctno, execqtty, odhist.txdate from odmasthist odhist, stschdhist  sthist
    where execqtty > 0
        and odhist.txdate <= v_OnDate
        and exectype in ('MS','NS')
        AND sthist.orgorderid = odhist.orderid
        AND sthist.duetype = 'RM'
        AND sthist.cleardate > v_OnDate
/*    union all
     --so luong chung khoan ban lo le cho giao
     select codeid, afacctno, acctno seacctno, case when txtype = 'D' then -namt else namt end execqtty, txdate from vw_setran_gen
     where txdate <= v_OnDate and tltxcd in ('8878','8879','8817') and field = 'NETTING' --07/01/2013 chaunh them 8817
*/
    )
    group by seacctno
) khop_qtty on sebal.acctno = khop_qtty.seacctno
left join   -- So du chung khoan han che chuyen nhuong
(
    select se.acctno,
       sum(case when a.qttytype = '002' then a.qtty else 0 end) curr_block_qtty,
       sum(case when a.qttytype = '007' then a.qtty else 0 end) curr_block_pt
    from semastdtl a, semast se, sbsecurities sb
    where a.acctno = se.acctno
        and se.codeid = sb.codeid
        and a.qttytype in ('002','007')
        and sb.sectype <> '004'
        and a.status = 'N'
        and a.deltd <> 'Y'
--        and sb.tradeplace <> '005'
    group by se.acctno
) se_block on sebal.acctno = se_block.acctno
left join
(   -- Phat sinh ban chung khoan ngay hom nay
    SELECT SEACCTNO, SUM(case when v_OnDate = v_CurrDate then SECUREAMT else 0 end) trade_sell_qtty,
        SUM(case when v_OnDate = v_CurrDate then SECUREMTG else 0 end) mtg_sell_qtty,
        SUM(case when v_OnDate = v_CurrDate then RECEIVING else 0 end) SERECEIVING,
        SUM(case when v_OnDate = v_CurrDate then EXECQTTY else 0 end) khop_qtty
     FROM (
            SELECT OD.SEACCTNO,
                CASE WHEN OD.EXECTYPE IN ('NS', 'SS') THEN to_number(nvl(varvalue,0))* REMAINQTTY + EXECQTTY ELSE 0 END SECUREAMT,
                CASE WHEN OD.EXECTYPE = 'MS'  THEN to_number(nvl(varvalue,0)) * REMAINQTTY + EXECQTTY ELSE 0 END SECUREMTG,
                0 RECEIVING, CASE WHEN OD.EXECTYPE IN ('NS', 'SS') THEN OD.EXECQTTY ELSE 0 END EXECQTTY
            FROM ODMAST OD, ODTYPE TYP, SYSVAR SY
            WHERE OD.EXECTYPE IN ('NS', 'SS','MS')
                and sy.grname='SYSTEM' and sy.varname='HOSTATUS'
                And OD.ACTYPE = TYP.ACTYPE
                AND OD.TXDATE = v_OnDate
                AND NVL(OD.GRPORDER,'N') <> 'Y'
                and od.deltd <> 'Y'
        )
    GROUP BY SEACCTNO
) order_today on sebal.acctno = order_today.SEACCTNO
left join
(   -- Phat sinh mua chung khoan ngay hom nay
    select se.acctno,
        --case when v_CurrDate = v_OnDate then SUM(qtty) else 0 end receiving_qtty
        sum(case when v_CurrDate = v_OnDate AND v_CurrDate = st.txdate AND st.status = 'N' then (qtty) else 0 END) receiving_qtty,
        sum(case when v_CurrDate >= st.txdate AND st.status <> 'N' then (qtty) else 0 END) receiving_st
    from cfmast cf, afmast af, semast se, sbsecurities sb, stschd  st
    where cf.custid = af.custid and af.acctno = se.afacctno
        and se.codeid = sb.codeid
         and sb.sectype <>'004'
        and se.afacctno = st.acctno and st.duetype = 'SM'
        and se.codeid = st.codeid
        and st.deltd <> 'Y'
    group by se.acctno
) order_buy_today on sebal.acctno = order_buy_today.acctno
left join
(   -- Phat sinh ban chung khoan ngay hom nay
    select se.acctno,
        --case when v_CurrDate = v_OnDate then SUM(qtty) else 0 end receiving_qtty
        sum(case when v_CurrDate = v_OnDate AND v_CurrDate = st.txdate AND st.status = 'N' then (qtty) else 0 END) netting_qtty,
        sum(case when v_CurrDate >= st.txdate AND st.status <> 'N' then (qtty) else 0 END) netting_st
    from cfmast cf, afmast af, semast se, sbsecurities sb, stschd  st
    where cf.custid = af.custid and af.acctno = se.afacctno
        and se.codeid = sb.codeid
         and sb.sectype <>'004'
        and se.afacctno = st.acctno and st.duetype = 'RM'
        and se.codeid = st.codeid
        and st.deltd <> 'Y'
    group by se.acctno
) order_sell_today on sebal.acctno = order_sell_today.acctno
LEFT JOIN
(   -- SO LUONG CK LO LE CHO BAN'
    SELECT TR.acctno,
        SUM(case when TR.field = 'NETTING' then CASE WHEN tr.txtype = 'D' THEN -tr.namt else tr.namt END ELSE 0 END) se_RETAIL_move_amt,
        SUM(case when TR.field = 'RECEIVING' then CASE WHEN tr.txtype = 'D' THEN -tr.namt else tr.namt END ELSE 0 END) se_RETAIL_move_receiving_amt
    FROM vw_setran_gen TR
    WHERE TR.TLTXCD IN ('8878','8879')
        AND TR.busdate > v_OnDate
    GROUP BY TR.ACCTNO
) SR_QTTY ON SEBAL.ACCTNO = SR_QTTY.ACCTNO
where CASE WHEN v_sectype = '%%' THEN 1
         WHEN v_sectype <>  '%%' AND instr(v_sectype, sebal.sectype ) <> 0 THEN 1
         ELSE 0 END = 1
group by sebal.custid, sebal.fullname, sebal.idcode, sebal.iddate,
    sebal.idplace, sebal.address, sebal.mobile, sebal.custodycd, sebal.afacctno, sebal.symbol_g
having sum(case when instr(sebal.symbol,'_WFT') <> 0 then 0
        else trade - nvl(se_trade_move_amt,0) +
            secured - NVL(se_SECURED_move_amt,0) -
            nvl(trade_sell_qtty,0)
        end ) <> 0 or
    sum(CASE WHEN instr(sebal.symbol,'_WFT') <> 0 then 0 else
        nvl(se_block.curr_block_qtty,0) - nvl(se_BLOCKED_move_HCCN,0) end) <> 0 or
    sum(CASE WHEN instr(sebal.symbol,'_WFT') <> 0 then 0 else
        nvl(se_block.curr_block_pt,0) - nvl(se_BLOCKED_move_pt,0) end) <> 0 or
    sum(CASE WHEN instr(sebal.symbol,'_WFT') <> 0 then 0 else
        (mortage - nvl(mtg_sell_qtty,0) - nvl(se_MORTAGE_move_amt,0) + nvl(sebal.STANDING,0)-
            nvl(se_STANDING_move_amt,0)) end) <> 0 or
    sum(CASE WHEN instr(sebal.symbol,'_WFT') <> 0 THEN 0 ELSE abs(nvl(sebal.STANDING,0)-
        nvl(se_STANDING_move_amt,0)) END) <> 0 or
    --CHAUNH---
    --sum(case when instr(sebal.symbol,'_WFT') <> 0 then 0
    --    else nvl(khop_qtty.execqtty,0) end) <> 0 or
    sum(case when instr(sebal.symbol,'_WFT') <> 0 then 0
        else nvl(netting,0) - nvl(se_NETTING_move_amt,0)
            /*+  nvl(khop_qtty.execqtty,0) - NVL(SR_QTTY.se_RETAIL_move_amt,0)*/ end) <> 0 or
    --END CHAUNH---
    sum(nvl(RECEIVING,0) - nvl(order_buy_today.receiving_st,0) - nvl(se_RETAIL_move_receiving_amt,0) - nvl(CA_RECEIVING,0)) <> 0 OR
    sum(nvl(order_buy_today.receiving_qtty,0) + nvl(receiving,0) - nvl(se_RECEIVING_move_amt,0) - (nvl(RECEIVING,0) - nvl(order_buy_today.receiving_st,0) - nvl(CA_RECEIVING,0))) <> 0 or
    sum(case when instr(sebal.symbol,'_WFT') <> 0 then 0
        else (nvl(trade_sell_qtty,0) + nvl(mtg_sell_qtty,0) - nvl(khop_qtty,0)) end ) <> 0 or
    sum(CASE WHEN instr(sebal.symbol,'_WFT')<> 0 THEN 0 ELSE nvl(WITHDRAW,0) + nvl(DTOCLOSE,0) -
        nvl(se_WITHDRAW_move_amt,0) - nvl(se_DTOCLOSE_move_amt,0) +
        (nvl(sebal.blocked,0) - nvl(se_block.curr_block_pt,0) - nvl(se_block.curr_block_qtty,0) -
            nvl(se_BLOCKED_move_amt,0))
        END)  <> 0 or
    sum(CASE WHEN instr(sebal.symbol,'_WFT') = 0 THEN 0 ELSE sebal.blocked -
           nvl(se_BLOCKED_move_wft,0) END) <> 0 or
    sum(CASE WHEN instr(sebal.symbol,'_WFT') <> 0 THEN (
        nvl(trade,0) - nvl(se_trade_move_amt,0) - nvl(order_today.trade_sell_qtty,0) - nvl(order_today.mtg_sell_qtty,0) +
        nvl(mortage,0) - nvl(se_mortage_move_amt,0) -
        (nvl(STANDING,0) - nvl(se_STANDING_move_amt,0)) +
        nvl(netting,0) - nvl(se_netting_move_amt,0) +
        nvl(WITHDRAW,0) - nvl(se_WITHDRAW_move_amt,0) +
        NVL(sebal.blocked,0) - nvl(se_BLOCKED_move_wft,0)
        ) ELSE 0 END) <> 0
    ;

EXCEPTION
  WHEN OTHERS
   THEN
   dbms_output.put_line('12233');
      RETURN;
END;
/
