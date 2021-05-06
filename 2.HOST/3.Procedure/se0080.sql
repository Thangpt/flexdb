CREATE OR REPLACE PROCEDURE se0080(
   PV_REFCURSOR     IN OUT   PKG_REPORT.REF_CURSOR,
   OPT              IN       VARCHAR2,
   BRID             IN       VARCHAR2,
   F_DATE           IN       VARCHAR2,
   T_DATE           IN       VARCHAR2
        )
   IS
-- created by CHAUNH at 22-03-2012
-- ---------   ------  -------------------------------------------

    V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0
    V_FROMDATE      date;
    V_TODATE        date;
    V_CURDATE       date;

   -- Declare program variables as shown above
BEGIN
    -- GET REPORT'S PARAMETERS
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   select varvalue into V_CURDATE from sysvar where varname = 'CURRDATE';
   V_FROMDATE := to_date(F_DATE, 'DD/MM/RRRR');
   V_TODATE := to_date(T_DATE,'DD/MM/RRRR');

  OPEN PV_REFCURSOR
    FOR
    --END_STANDING_BAL+EXECQTTY+END_BLOCKED_BAL+SL_CK_CHO_RUT+CK_CHO_GD+END_TRADE_BAL
select a.*, V_FROMDATE ky_truoc, V_TODATE ky_nay from (
        select '01' orderid, 'A. Trái phiếu' danh_muc, ' ' symbol, '000' tradeplace, 0 SL, 0 SL2 from dual
        UNION ALL
        select '02' orderid,'Trái phiếu chính phủ' danh_muc, ' ' symbol, '000' tradeplace, 0 SL, 0 SL2 from dual
        UNION ALL
        select '03' orderid,'Trái phiếu chính quyền địa phương' danh_muc, ' ' symbol, '000' tradeplace, 0 SL, 0 SL2 from dual
        UNION ALL
        select '04' orderid,'Trái phiếu doanh nghiệp' danh_muc, ' ' symbol, '000' tradeplace, 0 SL, 0 SL2 from dual
        UNION ALL
        select '05' orderid,'B. Cổ phiếu' danh_muc, ' ' symbol, '000' tradeplace, 0 SL, 0 SL2 from dual
        UNION ALL
        select '06' orderid,'Cổ phiếu niêm yết' danh_muc, ' ' symbol, '000' tradeplace, 0 SL, 0 SL2 from dual
        UNION ALL
        select '07' orderid,'Cổ phiếu đại chúng' danh_muc, ' ' symbol, '000' tradeplace, 0 SL, 0 SL2 from dual
        UNION ALL
        select '08' orderid,'Vốn góp cổ phần, đơn vị quỹ thành viên' danh_muc, ' ' symbol, '000' tradeplace, 0 SL, 0 SL2 from dual
        UNION ALL
        select '09' orderid,'C. Chứng chỉ quỹ' danh_muc, ' ' symbol, '000' tradeplace, 0 SL, 0 SL2 from dual
        UNION ALL
        select '10' orderid,'D. Các loại chứng khoán khác' danh_muc, ' ' symbol, '000' tradeplace, 0 SL, 0 SL2 from dual
        UNION ALL
        select '11' orderid,'E. Tiền mặt, chứng chỉ tiền gửi' danh_muc, ' ' symbol, '000' tradeplace, 0 SL, 0 SL2 from dual
        union all
        select case when sb.sectype in ('003','006') then
                    (case when  iss.businesstype = '002' THEN '02' --'Trai phieu chinh phu'
                          when  iss.businesstype = '003' then '03'--'Trai phieu dia phuong'
                          else '04'--'Trai phieu doanh nghiep'
                          end)
            when sb.sectype in  ('007','008') then '09'--'Chung chi quy'
            when sb.sectype in ('001','002','011') then '06'--'Co phieu niem yet'
            else '00'--'Loai khac'
            end orderid ,

        case when sb.sectype in ('003','006') then
                    (case when  iss.businesstype = '002' then 'Trai phieu chinh phu'
                          when  iss.businesstype = '003' then 'Trai phieu dia phuong'
                          else 'Trai phieu doanh nghiep' end)
            when sb.sectype in  ('007','008') then 'Chung chi quy'
            when sb.sectype in ('001','002','011') then 'Co phieu'
            else 'Loai khac' end danh_muc, sb.symbol, sb.tradeplace,
       sum(case when sebal.refcodeid is null then
        ( abs(nvl(sebal.STANDING,0)- nvl(se_field_move.se_STANDING_move_amt,0)) --END_STANDING_BAL+
        + nvl(khop_qtty.execqtty,0)--EXECQTTY
        + nvl(se_block.curr_block_qtty,0) - nvl(se_field_move.se_BLOCKED_move_HCCN,0)--END_BLOCKED_BAL
        + 0 --SL_CK_CHO_RUT
        + 0 --CK_CHO_GD
        + trade - nvl(se_field_move.se_trade_move_amt,0) +
            mortage - nvl(se_field_move.se_MORTAGE_move_amt,0) +
            (BLOCKED-nvl(se_block.curr_block_qtty,0))
            - nvl(se_field_move.se_BLOCKED_move_amt,0) +
            nvl(sebal.STANDING,0)- nvl(se_field_move.se_STANDING_move_amt,0) + --Tru them cua Block
            WITHDRAW - nvl(se_field_move.se_WITHDRAW_move_amt,0) +
            DTOCLOSE - nvl(se_field_move.se_DTOCLOSE_move_amt,0) +
            secured - NVL(se_field_move.se_SECURED_move_amt,0)--END_TRADE_BAL
        )
    else
        (
        nvl(trade,0) - nvl(se_field_move.se_trade_move_amt,0) -
        nvl(order_today.trade_sell_qtty,0) - nvl(order_today.mtg_sell_qtty,0) +
        nvl(mortage,0) - nvl(se_field_move.se_mortage_move_amt,0) -
        (nvl(STANDING,0) - nvl(se_field_move.se_STANDING_move_amt,0)) +
        nvl(netting,0) - nvl(se_field_move.se_netting_move_amt,0) +
        nvl(WITHDRAW,0) - nvl(se_field_move.se_WITHDRAW_move_amt,0) +
        nvl(DTOCLOSE,0) - nvl(se_field_move.se_DTOCLOSE_move_amt,0) +
        NVL(sebal.blocked,0) - nvl(se_field_move.se_BLOCKED_move_wft,0)
        )
    end ) SL,
    sum(case when sebal.refcodeid is null then
        (
         abs(nvl(sebal.STANDING,0)- nvl(se_field_move2.se_STANDING_move_amt,0)) --END_STANDING_BAL+
        + nvl(khop_qtty2.execqtty,0)--EXECQTTY
        + nvl(se_block.curr_block_qtty,0) - nvl(se_field_move2.se_BLOCKED_move_HCCN,0)--END_BLOCKED_BAL
        + 0 --SL_CK_CHO_RUT
        + 0 --CK_CHO_GD
        + trade - nvl(se_field_move2.se_trade_move_amt,0) +
            mortage - nvl(se_field_move2.se_MORTAGE_move_amt,0) +
            (BLOCKED-nvl(se_block.curr_block_qtty,0))
            - nvl(se_field_move2.se_BLOCKED_move_amt,0) +
            nvl(sebal.STANDING,0)- nvl(se_field_move2.se_STANDING_move_amt,0) + --Tru them cua Block
            WITHDRAW - nvl(se_field_move2.se_WITHDRAW_move_amt,0) +
            DTOCLOSE - nvl(se_field_move2.se_DTOCLOSE_move_amt,0) +
            secured - NVL(se_field_move2.se_SECURED_move_amt,0)--END_TRADE_BAL
        )
    else
        (
        nvl(trade,0) - nvl(se_field_move2.se_trade_move_amt,0) -
        nvl(order_today2.trade_sell_qtty,0) - nvl(order_today2.mtg_sell_qtty,0) +
        nvl(mortage,0) - nvl(se_field_move2.se_mortage_move_amt,0) -
        (nvl(STANDING,0) - nvl(se_field_move2.se_STANDING_move_amt,0)) +
        nvl(netting,0) - nvl(se_field_move2.se_netting_move_amt,0) +
        nvl(WITHDRAW,0) - nvl(se_field_move2.se_WITHDRAW_move_amt,0) +
        nvl(DTOCLOSE,0) - nvl(se_field_move2.se_DTOCLOSE_move_amt,0) +
        NVL(sebal.blocked,0) - nvl(se_field_move2.se_BLOCKED_move_wft,0)
        )
    end ) SL2
from  sbsecurities sb, issuers iss,
(
    -- Tong so du CK hien tai group by tieu khoan, Symbol
    select se.acctno, sb.codeid, sb.refcodeid,
        sum(trade + blocked + mortage + netting + receiving) se_balance,
        sum(trade) trade, sum(blocked) blocked, sum(mortage) mortage, sum(netting) netting,
        sum(STANDING) STANDING, sum(RECEIVING) RECEIVING, sum(WITHDRAW) WITHDRAW,
        sum(DTOCLOSE) DTOCLOSE, SUM(secured) secured
    from semast se, cfmast cf, afmast af, sbsecurities sb
    where cf.custid = af.custid and af.acctno = se.afacctno
        and cf.custatcom = 'Y'
        and SUBSTR(cf.custodycd,4,1) = 'F'
        and se.codeid = sb.codeid
        and sb.sectype <> '004'

    group by  se.acctno , sb.codeid, sb.refcodeid
    --order by sb.tradeplace, nvl(sb.refcodeid,sb.codeid)
) sebal
left join
( -- Tong phat sinh field cac loai so du CK tu Txdate den ngay hom nay
  select tr.acctno,
        sum(case when field = 'TRADE' then case when tr.txtype = 'D' then -tr.namt else tr.namt end else 0 end ) se_trade_move_amt,            -- Phat sinh CK giao dich
        sum(case when field = 'MORTAGE' then case when tr.txtype = 'D' then -tr.namt else tr.namt end else 0 end) se_MORTAGE_move_amt ,         -- Phat sinh CK Phong toa gom ca STANDING
        sum(case when field = 'BLOCKED' and nvl(tr.REF,' ') <> '002' then
                                            (case when tr.txtype = 'D' then -tr.namt else tr.namt end) else 0 end) se_BLOCKED_move_amt   ,      -- Phat sinh CK tam giu
        sum(case when field = 'BLOCKED' and nvl(tr.REF,' ') = '002' then
                                            (case when tr.txtype = 'D' then -tr.namt else tr.namt end) else 0 end) se_BLOCKED_move_HCCN   ,      -- Phat sinh CK tam giu
        sum(case when field = 'BLOCKED' THEN (case when tr.txtype = 'D' then -tr.namt else tr.namt end) else 0 end) se_BLOCKED_move_wft   ,      -- Phat sinh CK tam giu
        sum(case when field = 'NETTING' then (case when tr.txtype = 'D' then -tr.namt else tr.namt end) else 0 end) se_NETTING_move_amt ,         -- Phat sinh CK cho giao
        sum(case when field = 'STANDING' then (case when tr.txtype = 'D' then -tr.namt else tr.namt end) else 0 end) se_STANDING_move_amt,         -- Phat sinh CK cam co len TT Luu ky
        sum(case when field = 'WITHDRAW' then (case when tr.txtype = 'D' then -tr.namt else tr.namt end) else 0 end) se_WITHDRAW_move_amt,         -- Phat sinh CK cho nhan ve
        sum(case when field = 'DTOCLOSE' then (case when tr.txtype = 'D' then -tr.namt else tr.namt end) else 0 end) se_DTOCLOSE_move_amt,
        SUM(case when field = 'SECURED' THEN (case when tr.txtype = 'D' then -tr.namt else tr.namt end) else 0 end) se_SECURED_move_amt
    from vw_setran_gen tr
    where tr.busdate > V_FROMDATE and tr.busdate <= V_CURDATE
        and tr.sectype <> '004'
        and tr.field in ('TRADE','MORTAGE','BLOCKED','NETTING','STANDING','RECEIVING','WITHDRAW','DTOCLOSE','SECURED')
    group by tr.acctno
    ) se_field_move on sebal.acctno = se_field_move.acctno
left join
( -- so luong chung khoan ban cho giao
    select seacctno, sum(execqtty) execqtty
    from
    (
    select codeid, afacctno, seacctno, execqtty, txdate from odmast
    where execqtty > 0
        and exectype in ('MS','NS') and odmast.deltd <> 'Y'
        and txdate <= V_FROMDATE
    union all
    select od.codeid, od.afacctno, od.seacctno, od.execqtty, od.txdate from odmasthist od, stschdhist sts
    where execqtty > 0
        and od.txdate <= V_FROMDATE and od.deltd <> 'Y'
        and exectype in ('MS','NS')
        and od.orderid = sts.orgorderid and duetype = 'RM'
        and sts.deltd <> 'Y'
        and sts.cleardate > V_FROMDATE
        --and getduedate(txdate, clearcd, sb.tradeplace, clearday) > V_FROMDATE*/
    )
    group by seacctno
) khop_qtty on sebal.acctno = khop_qtty.seacctno
left join   -- So du chung khoan han che chuyen nhuong
    (
    select se.acctno,
        sum(case when a.qttytype = '002' then a.qtty else 0 end) curr_block_qtty
    from semastdtl a, semast se, sbsecurities sb
    where a.acctno = se.acctno
        and se.codeid = sb.codeid and a.deltd <>  'Y'
        and a.qttytype = '002'
        and sb.sectype <>'004'
        and a.status = 'N'
        and a.deltd <> 'Y'
        AND sb.tradeplace <> '005'
    group by se.acctno
    ) se_block on sebal.acctno = se_block.acctno
-----------------------
left join
    (   -- Phat sinh ban chung khoan ngay hom nay
    SELECT SEACCTNO, SUM(case when V_FROMDATE = V_CURDATE then SECUREAMT else 0 end) trade_sell_qtty,
        SUM(case when V_FROMDATE = V_CURDATE then SECUREMTG else 0 end) mtg_sell_qtty,
        SUM(case when V_FROMDATE = V_CURDATE then RECEIVING else 0 end) SERECEIVING,
        SUM(case when V_FROMDATE = V_CURDATE then EXECQTTY else 0 end) khop_qtty
     FROM (
        SELECT OD.SEACCTNO,
               CASE WHEN OD.EXECTYPE IN ('NS', 'SS') THEN to_number(nvl(varvalue,0))* REMAINQTTY + EXECQTTY ELSE 0 END SECUREAMT,
               CASE WHEN OD.EXECTYPE = 'MS'  THEN to_number(nvl(varvalue,0)) * REMAINQTTY + EXECQTTY ELSE 0 END SECUREMTG,
               0 RECEIVING, CASE WHEN OD.EXECTYPE IN ('NS', 'SS') THEN OD.EXECQTTY ELSE 0 END EXECQTTY
           FROM ODMAST OD, ODTYPE TYP, SYSVAR SY
           WHERE OD.EXECTYPE IN ('NS', 'SS','MS')
               and sy.grname='SYSTEM' and sy.varname='HOSTATUS'
               And OD.ACTYPE = TYP.ACTYPE
               AND OD.TXDATE = V_CURDATE
               AND NVL(OD.GRPORDER,'N') <> 'Y'
        )
    GROUP BY SEACCTNO
    ) order_today on sebal.acctno = order_today.seacctno

-----------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
--------SL ky nay
LEFT JOIN
( -- Tong phat sinh field cac loai so du CK tu Txdate den ngay hom nay
  select tr.acctno,
        sum(case when field = 'TRADE' then case when tr.txtype = 'D' then -tr.namt else tr.namt end else 0 end ) se_trade_move_amt,            -- Phat sinh CK giao dich
        sum(case when field = 'MORTAGE' then case when tr.txtype = 'D' then -tr.namt else tr.namt end else 0 end) se_MORTAGE_move_amt ,         -- Phat sinh CK Phong toa gom ca STANDING
        sum(case when field = 'BLOCKED' and nvl(tr.REF,' ') <> '002' then
                                            (case when tr.txtype = 'D' then -tr.namt else tr.namt end) else 0 end) se_BLOCKED_move_amt   ,      -- Phat sinh CK tam giu
        sum(case when field = 'BLOCKED' and nvl(tr.REF,' ') = '002' then
                                            (case when tr.txtype = 'D' then -tr.namt else tr.namt end) else 0 end) se_BLOCKED_move_HCCN   ,      -- Phat sinh CK tam giu
        sum(case when field = 'BLOCKED' THEN (case when tr.txtype = 'D' then -tr.namt else tr.namt end) else 0 end) se_BLOCKED_move_wft   ,      -- Phat sinh CK tam giu
        sum(case when field = 'NETTING' then (case when tr.txtype = 'D' then -tr.namt else tr.namt end) else 0 end) se_NETTING_move_amt ,         -- Phat sinh CK cho giao
        sum(case when field = 'STANDING' then (case when tr.txtype = 'D' then -tr.namt else tr.namt end) else 0 end) se_STANDING_move_amt,         -- Phat sinh CK cam co len TT Luu ky
        sum(case when field = 'WITHDRAW' then (case when tr.txtype = 'D' then -tr.namt else tr.namt end) else 0 end) se_WITHDRAW_move_amt,         -- Phat sinh CK cho nhan ve
        sum(case when field = 'DTOCLOSE' then (case when tr.txtype = 'D' then -tr.namt else tr.namt end) else 0 end) se_DTOCLOSE_move_amt,
        SUM(case when field = 'SECURED' THEN (case when tr.txtype = 'D' then -tr.namt else tr.namt end) else 0 end) se_SECURED_move_amt
    from vw_setran_gen tr
    where tr.busdate > V_TODATE and tr.busdate <= V_CURDATE
        and tr.sectype <> '004'
        and tr.field in ('TRADE','MORTAGE','BLOCKED','NETTING','STANDING','RECEIVING','WITHDRAW','DTOCLOSE','SECURED')
    group by tr.acctno
    ) se_field_move2 on sebal.acctno = se_field_move2.acctno
left join
( -- so luong chung khoan ban cho giao
    select seacctno, sum(execqtty) execqtty
    from
    (
    select codeid, afacctno, seacctno, execqtty, txdate from odmast
    where execqtty > 0
        and exectype in ('MS','NS') and odmast.deltd <> 'Y'
        and txdate <= V_TODATE
    union all
    select od.codeid, od.afacctno, od.seacctno, od.execqtty, od.txdate from odmasthist od, stschdhist sts
    where execqtty > 0
        and od.txdate <= V_TODATE and od.deltd <> 'Y'
        and exectype in ('MS','NS')
        and od.orderid = sts.orgorderid and duetype = 'RM'
        and sts.deltd <> 'Y'
        and sts.cleardate > V_TODATE
    )
    group by seacctno
) khop_qtty2 on sebal.acctno = khop_qtty2.seacctno

left join
    (   -- Phat sinh ban chung khoan ngay hom nay
    SELECT SEACCTNO, SUM(case when V_TODATE = V_CURDATE then SECUREAMT else 0 end) trade_sell_qtty,
        SUM(case when V_TODATE = V_CURDATE then SECUREMTG else 0 end) mtg_sell_qtty,
        SUM(case when V_TODATE = V_CURDATE then RECEIVING else 0 end) SERECEIVING,
        SUM(case when V_TODATE = V_CURDATE then EXECQTTY else 0 end) khop_qtty
     FROM (
        SELECT OD.SEACCTNO,
               CASE WHEN OD.EXECTYPE IN ('NS', 'SS') THEN to_number(nvl(varvalue,0))* REMAINQTTY + EXECQTTY ELSE 0 END SECUREAMT,
               CASE WHEN OD.EXECTYPE = 'MS'  THEN to_number(nvl(varvalue,0)) * REMAINQTTY + EXECQTTY ELSE 0 END SECUREMTG,
               0 RECEIVING, CASE WHEN OD.EXECTYPE IN ('NS', 'SS') THEN OD.EXECQTTY ELSE 0 END EXECQTTY
           FROM ODMAST OD, ODTYPE TYP, SYSVAR SY
           WHERE OD.EXECTYPE IN ('NS', 'SS','MS')
               and sy.grname='SYSTEM' and sy.varname='HOSTATUS'
               And OD.ACTYPE = TYP.ACTYPE
               AND OD.TXDATE = V_CURDATE
               AND NVL(OD.GRPORDER,'N') <> 'Y'
        )
    GROUP BY SEACCTNO
    ) order_today2 on sebal.acctno = order_today2.seacctno
--------------------------------------------------------------------------------------
where sb.codeid = nvl( sebal.refcodeid,sebal.codeid)
    and sb.issuerid = iss.issuerid
    and V_CURDATE >= V_FROMDATE
    and V_CURDATE >= V_TODATE
group by sb.symbol, sb.sectype,  iss.businesstype, sb.tradeplace


---------------------------------tinh tien mat
union all
select '11' orderid, 'Tien mat' danh_muc, 'Tien' symbol, '000' tradeplace,  ROUND(SUM(CI_CURR.BALANCE - NVL(CI_TR.TR_BALANCE, 0) - NVL(SECU.OD_BUY_SECU, 0))) SL,
        ROUND(SUM(CI_CURR.BALANCE - NVL(CI_TR2.TR_BALANCE, 0) - NVL(SECU2.OD_BUY_SECU, 0))) SL2
FROM CIMAST CI_CURR, AFMAST AF, CFMAST CF,
    (   --- LAY CAC PHAT SINH BALANCE, EMKAMT, TRFAMT, FLOATAMT LON HON NGAY GIAO DICH THEO NGAY BKDATE(CHI CO TRONG VW_CITRAN_ALL)
        SELECT TR.ACCTNO,
               ROUND(SUM(CASE WHEN TX.FIELD = 'BALANCE' THEN (CASE WHEN TX.TXTYPE = 'D' THEN -TR.NAMT ELSE TR.NAMT END)
                        ELSE 0 END)) TR_BALANCE

        FROM  VW_CITRAN_ALL TR, APPTX TX
        WHERE TR.TXCD      =    TX.TXCD
        AND   TX.APPTYPE   =    'CI' and TR.DELTD <> 'Y'
        AND   TX.TXTYPE    IN   ('C','D')
        AND   TX.FIELD     IN   ('BALANCE')
        AND   NVL(TR.BKDATE, TR.TXDATE) > TO_DATE(V_FROMDATE,'DD/MM/RRRR')
        GROUP BY TR.ACCTNO
    ) CI_TR,
    (   --- LAY GIA TRI KI QUY LENH MUA (CHI LAY DUOC NEU NGAY GD LA NGAY HIEN TAI)
        SELECT   V.afacctno,
                 (CASE WHEN V_CURDATE = V_FROMDATE THEN SUM(V.secureamt + V.advamt)
                  ELSE 0 END) OD_BUY_SECU
        FROM     v_getbuyorderinfo V
        GROUP BY V.afacctno
    ) SECU,
    ----------------------------------------------------------------
    (   --- LAY CAC PHAT SINH BALANCE, EMKAMT, TRFAMT, FLOATAMT LON HON NGAY GIAO DICH THEO NGAY BKDATE(CHI CO TRONG VW_CITRAN_ALL)
        SELECT TR.ACCTNO,
               ROUND(SUM(CASE WHEN TX.FIELD = 'BALANCE' THEN (CASE WHEN TX.TXTYPE = 'D' THEN -TR.NAMT ELSE TR.NAMT END)
                        ELSE 0 END)) TR_BALANCE

        FROM  VW_CITRAN_ALL TR, APPTX TX
        WHERE TR.TXCD      =    TX.TXCD
        AND   TX.APPTYPE   =    'CI' and TR.DELTD <> 'Y'
        AND   TX.TXTYPE    IN   ('C','D')
        AND   TX.FIELD     IN   ('BALANCE')
        AND   NVL(TR.BKDATE, TR.TXDATE) > TO_DATE(V_TODATE,'DD/MM/RRRR')
        GROUP BY TR.ACCTNO
    ) CI_TR2,
    (   --- LAY GIA TRI KI QUY LENH MUA (CHI LAY DUOC NEU NGAY GD LA NGAY HIEN TAI)
        SELECT   V.afacctno,
                 (CASE WHEN V_CURDATE = V_TODATE THEN SUM(V.secureamt + V.advamt)
                  ELSE 0 END) OD_BUY_SECU
        FROM     v_getbuyorderinfo V
        GROUP BY V.afacctno
    ) SECU2
    ----------------------------------------------------------------
WHERE    AF.ACCTNO               =     CI_CURR.AFACCTNO
AND      AF.CUSTID               =     CF.CUSTID
AND      CI_CURR.ACCTNO          =     CI_TR.ACCTNO  (+)
AND      CI_CURR.ACCTNO          =     SECU.AFACCTNO (+)
AND      CI_CURR.ACCTNO          =     CI_TR2.ACCTNO  (+)
AND      CI_CURR.ACCTNO          =     SECU2.AFACCTNO (+)
AND      CI_CURR.COREBANK        =     'N'
and      V_CURDATE >= V_FROMDATE
and      V_CURDATE >= V_TODATE
AND    substr( CF.custodycd, 4,1) =  'F'
) a
order by tradeplace, symbol

;

EXCEPTION
    WHEN OTHERS
   THEN
      RETURN;
END; -- Procedure

 
/
