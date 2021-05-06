-- Start of DDL Script for View HOSTMSTRADE.V_MO_AM_TIEN_CK
-- Generated 11/04/2017 1:45:24 PM from HOSTMSTRADE@FLEX_111

CREATE OR REPLACE VIEW v_mo_am_tien_ck (
   today,
   custodycd,
   symbol,
   market,
   han_che_cn,
   giao_dich,
   san_pham,
   phong_toa,
   cho_rut,
   cho_giao,
   cam_co,
   cho_ve,
   solieu_vsd )
AS
select to_date(sysdate), sebal.custodycd,
    sebal.symbol, a.cdcontent MARKET,    
    nvl(se_block.curr_block_qtty,0) - nvl(se_block_move.cr_block_amt,0) + nvl(se_block_move.dr_block_amt,0) as Han_Che_CN,  -- Han che chuyen nhuong
    nvl(trade,0) - nvl(se_trade_move_amt,0) - nvl(trade_sell_qtty,0)as Giao_Dich,
    nvl(mortage,0) + nvl(STANDING,0) - nvl(mtg_sell_qtty,0)- nvl(se_mortage_move_amt,0) - nvl(se_STANDING_move_amt,0) as San_Pham,
    nvl(blocked,0) - nvl(se_blocked_move_amt,0) - (nvl(se_block.curr_block_qtty,0) - nvl(se_block_move.cr_block_amt,0) + nvl(se_block_move.dr_block_amt,0) ) as Phong_toa,
    nvl(WITHDRAW,0) - nvl(se_WITHDRAW_move_amt,0) as Cho_Rut,
    nvl(netting,0) - nvl(se_netting_move_amt,0) + nvl(trade_sell_qtty,0) + nvl(mtg_sell_qtty,0) as  Cho_Giao,   -- Cho TT
    -(  nvl(STANDING,0) - nvl(se_STANDING_move_amt,0) ) as  Cam_Co, -- Do standing luon <=0
    nvl(RECEIVING,0) - nvl(se_RECEIVING_move_amt,0) + nvl(order_buy_today.receiving_qtty,0) as  Cho_Ve,
    (nvl(trade,0) - nvl(se_trade_move_amt,0) - nvl(trade_sell_qtty,0) )     -- Flex Giao dich
    +
    (
        nvl(mortage,0) + nvl(STANDING,0) - nvl(mtg_sell_qtty,0) - nvl(se_mortage_move_amt,0) - nvl(se_STANDING_move_amt,0)
        + (
            nvl(blocked,0) - nvl(se_blocked_move_amt,0) - (nvl(se_block.curr_block_qtty,0) - nvl(se_block_move.cr_block_amt,0) + nvl(se_block_move.dr_block_amt,0) )
          )    --- phong toa khac
    ) -- Phong_Toa
    + nvl(WITHDRAW,0) - nvl(se_WITHDRAW_move_amt,0)     -- Cho rut
    as solieu_VSD -- So luong giao dich tuong ung voi VSD
from
(
    -- Tong so du CK hien tai group by tieu khoan, Symbol
    select cf.custodycd, sb.symbol, se.acctno seacctno,
        sum(trade + blocked + mortage + netting + receiving) se_balance,
        sum(trade) trade, sum(blocked) blocked, sum(mortage) mortage, sum(netting) netting,
        sum(STANDING) STANDING, sum(RECEIVING) RECEIVING, sum(WITHDRAW) WITHDRAW
    from semast se, sbsecurities sb, cfmast cf,
    (   -- DS TK vay
        select cf.custodycd, af.acctno 
        from vw_lnmast_all ln, afmast af, cfmast cf
        where ftype = 'AF' 
            and ln.orlsamt - ln.oprinpaid <> 0
            and af.custid = cf.custid 
            and ln.trfacctno = af.acctno
    ) ln 
    where cf.custid = se.custid and ln.custodycd = cf.custodycd
        and se.codeid = sb.codeid
        and sb.sectype <> '004'
    group by  cf.custodycd,  sb.symbol, se.acctno
) sebal 

inner join sbsecurities sb on sebal.symbol = sb.symbol 
inner join  allcode a on sb.tradeplace = a.cdval and a.cdname = 'TRADEPLACE' and a.cdtype = 'SE'
left join
(   -- Phat sinh ban chung khoan ngay hom nay
    select se.afacctno, symbol, se.acctno seacctno,
        SUM(SECUREAMT) trade_sell_qtty,
        SUM(SECUREMTG) mtg_sell_qtty
    from semast se, v_getsellorderinfo v, sbsecurities sb
    where
        se.acctno = v.seacctno
        and se.codeid = sb.codeid        
        and sb.sectype <> '004'        
    group by se.afacctno, symbol, se.acctno
) order_today on sebal.seacctno = order_today.seacctno

left join
(   -- Phat sinh mua chung khoan ngay hom nay
    select se.afacctno, symbol, se.acctno seacctno,
        SUM(qtty) receiving_qtty
    from semast se, sbsecurities sb, stschd  st
    where 
        se.codeid = sb.codeid
        and se.acctno = st.acctno and st.duetype = 'RS' and st.status = 'N'
        and sb.sectype <> '004'        
        and st.txdate = (select to_date(varvalue,'DD/MM/RRRR') from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM') 
    group by se.afacctno, symbol, se.acctno
) order_buy_today on sebal.seacctno = order_buy_today.seacctno

left join
(
    -- Tong phat sinh field cac loai so du CK tu Ondate den ngay hom nay
    select se.afacctno, symbol, se.acctno seacctno,
        sum
        (case when field = 'TRADE' then
                case when apptx.txtype = 'D' then -tr.namt else tr.namt end
            else 0
            end
        ) se_trade_move_amt,            -- Phat sinh CK giao dich
        sum
        (case when field = 'MORTAGE' then
                case when apptx.txtype = 'D' then -tr.namt else tr.namt end
             else 0
             end
        ) se_MORTAGE_move_amt ,         -- Phat sinh CK Phong toa gom ca STANDING
        sum
        (case when field = 'BLOCKED' then
                (case when apptx.txtype = 'D' then -tr.namt else tr.namt end)
            else 0
            end
         ) se_BLOCKED_move_amt   ,      -- Phat sinh CK tam giu
        sum
        ( case when field = 'NETTING' then
                (case when apptx.txtype = 'D' then -tr.namt else tr.namt end)
            else 0
            end
        ) se_NETTING_move_amt ,         -- Phat sinh CK cho giao
        sum
        ( case when field = 'STANDING' then
                (case when apptx.txtype = 'D' then -tr.namt else tr.namt end)
            else 0
            end
        ) se_STANDING_move_amt,         -- Phat sinh CK cam co len TT Luu ky
        sum
        ( case when field = 'RECEIVING' then
                (case when apptx.txtype = 'D' then -tr.namt else tr.namt end)
            else 0
            end
        ) se_RECEIVING_move_amt,         -- Phat sinh CK cho nhan ve
        sum
        ( case when field = 'WITHDRAW' then
                (case when apptx.txtype = 'D' then -tr.namt else tr.namt end)
            else 0
            end
        ) se_WITHDRAW_move_amt         -- Phat sinh CK cho nhan ve
    from semast se, vw_tllog_setran_all tr, apptx, sbsecurities sb
    where se.acctno = tr.acctno 
        and tr.txcd = apptx.txcd and sb.codeid = se.codeid
        and tr.busdate > (select to_date(varvalue,'DD/MM/RRRR') from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM')
        and se.afacctno like '%'
        and sb.symbol like '%'
        and sb.sectype <> '004'        
        and apptx.field in ('TRADE','MORTAGE','BLOCKED','NETTING','STANDING','RECEIVING','WITHDRAW')
        and apptx.apptype = 'SE' and apptx.txtype in ('D','C')
    group by se.afacctno, sb.symbol, se.acctno
) se_field_move on sebal.seacctno = se_field_move.seacctno

left join   -- So du chung khoan chuyen nhuong co dieu kien
(
    select se.afacctno, sb.symbol, se.acctno seacctno, 
        sum(a.qtty) curr_block_qtty
    from semastdtl a, semast se, sbsecurities sb
    where a.acctno = se.acctno 
        and se.codeid = sb.codeid
        and qttytype = '002'
        and sb.sectype <> '004'        
    group by se.afacctno, sb.symbol, se.acctno
) se_block on sebal.seacctno = se_block.seacctno

left join   -- Phat sinh giao dich phong toa/giai toa CK chuyen nhuong co dieu kien
(
    select se.afacctno, sb.symbol, se.acctno seacctno,
        sum(case when fld.tltxcd = '2202' then fld.nvalue else 0 end) cr_block_amt,
        sum(case when fld.tltxcd = '2203' then fld.nvalue else 0 end) dr_block_amt
    from vw_tllog_setran_all tr,
    semast se, sbsecurities sb, apptx,
    (
        select tl.txnum, tl.txdate, tl.busdate, tl.tltxcd, to_number(nvalue) nvalue
        from vw_tllogfld_all fld,
        (
            select n.txnum, n.txdate, n.busdate, n.tltxcd
            from vw_tllogfld_all m, vw_tllog_all n
            where m.txdate = n.txdate and m.txnum = n.txnum
                and fldcd = '12' and n.tltxcd in ('2202','2203') and cvalue='002'
                and n.busdate > (select to_date(varvalue,'DD/MM/RRRR') from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM')
        ) tl
        where fld.txdate = tl.txdate and fld.txnum = tl.txnum
            and fld.fldcd = '10'
    ) fld
    where tr.txdate = fld.txdate and tr.txnum = fld.txnum
        and tr.acctno = se.acctno
        and se.codeid = sb.codeid        
        and tr.txcd = apptx.txcd and apptx.field = 'BLOCKED' and apptx.apptype = 'SE'
        and sb.sectype <> '004'        
    group by se.afacctno, sb.symbol, se.acctno
) se_block_move on sebal.seacctno = se_block_move.seacctno

where 
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

order by sebal.custodycd, symbol
/


-- End of DDL Script for View HOSTMSTRADE.V_MO_AM_TIEN_CK

