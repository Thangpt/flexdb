CREATE OR REPLACE PROCEDURE cf1108 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2,
   T_DATE                 IN       VARCHAR2,
   PV_CUSTODYCD           IN       VARCHAR2,
   --PV_AFACCTNO            IN       VARCHAR2,
   TLID                   IN       VARCHAR2
  )
IS
--

-- BAO CAO SAO KE TIEN CUA TAI KHOAN KHACH HANG
-- MODIFICATION HISTORY
-- PERSON       DATE                COMMENTS
-- ---------   ------  -------------------------------------------
-- TUNH        13-05-2010           CREATED
-- TUNH        31-08-2010           Lay dien giai chi tiet o cac table xxTRAN
-- HUNG.LB     03-11-2010           6.3.1
-- QUOCTA      12-01-2012           BVS - LAY THEO NGAY BACKDATE CUA GD

   CUR            PKG_REPORT.REF_CURSOR;
   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (4);                   -- USED WHEN V_NUMOPTION > 0
   v_FromDate     date;
   v_ToDate       date;
   v_CurrDate     date;
   v_CustodyCD    varchar2(20);
   --v_AFAcctno     varchar2(20);
   v_TLID         varchar2(4);

   V_TRADELOG CHAR(2);
   V_AUTOID NUMBER;
   v_tmtracham NUMBER;

BEGIN

   v_TLID := TLID;

   V_STROPTION := OPT;

   IF V_STROPTION = 'A' then
      V_STRBRID := '%';
   ELSIF V_STROPTION = 'B' then
      V_STRBRID := substr(BRID,1,2) || '__' ;
   else
    V_STRBRID:=BRID;
   END IF;

   v_FromDate  :=     TO_DATE(F_DATE,'DD/MM/RRRR');
   v_ToDate    :=     TO_DATE(T_DATE, 'DD/MM/RRRR');

   v_CustodyCD :=     upper(replace(pv_custodycd,'.',''));

   select TO_DATE(VARVALUE, 'DD/MM/RRRR') into v_CurrDate from SYSVAR where grname='SYSTEM' and varname='CURRDATE';

OPEN PV_REFCURSOR FOR
select main.*, b.tmtracham from
(
select /*v_tmtracham tmtracham,*/ cibal.custid, cibal.custodycd, cibal.class,cibal.fullname,
    cibal.idcode, cibal.iddate, cibal.idplace, cibal.mobile, cibal.address, tr.afacctno S_AFACCTNO,
    tr.autoid, tr.afacctno, tr.bkdate busdate, nvl(tr.symbol,' ') tran_symbol,
    nvl(se_credit_amt,0) se_credit_amt, nvl(se_debit_amt,0) se_debit_amt,
    nvl(ci_credit_amt,0) ci_credit_amt, nvl(ci_debit_amt,0) ci_debit_amt,
    ci_balance, ci_balance - nvl(ci_total_move_frdt_amt,0)  ci_begin_bal,
    CI_RECEIVING, CI_RECEIVING - nvl(ci_RECEIVING_move,0) ci_receiving_bal,
    CI_EMKAMT, CI_EMKAMT - nvl(ci_EMKAMT_move,0) ci_EMKAMT_bal,
    CI_DFDEBTAMT - nvl(ci_DFDEBTAMT_move,0) ci_DFDEBTAMT_bal,
    nvl(secu.od_buy_secu,0) od_buy_secu,
    tr.txnum,
    case when tr.tltxcd = '1143' and tr.txcd = '0077' then 'S? ti?n d?n h?n ph?i thanh toán '
         when tr.tltxcd in ('1143','1153') and tr.txcd = '0011' and tr.trdesc is null then 'Phí ?ng tru?c '
         else to_char(decode(substr(tr.txnum,1,2),'68', tr.txdesc || ' (Online)',tr.txdesc))
    end txdesc,
    tr.tltxcd/*,
    (case when u.tokenid is null then '-' else
    SUBSTR(u.tokenid,
                              instr(u.tokenid, '{', 1, 3) + 1,
                              instr(u.tokenid, '}', 1, 1) -
                              instr(u.tokenid, '{', 1, 3) - 1)end) tokenid*/

from
(
    -- Tong so du CI hien tai group by TK luu ky
    select cf.custid, cf.custodycd, af.acctno,a.cdcontent class, cf.fullname, cf.idcode, cf.iddate, cf.idplace, cf.mobile, cf.address,
        sum(case when af.corebank = 'Y' then 0 else balance + emkamt end) ci_balance, --them emkamt GianhVG
        sum(case when af.corebank = 'Y' then 0 else RECEIVING end) CI_RECEIVING,
        sum(case when af.corebank = 'Y' then 0 else EMKAMT end) CI_EMKAMT,
        sum(case when af.corebank = 'Y' then 0 else DFDEBTAMT end) CI_DFDEBTAMT
    from cfmast cf, afmast af, cimast ci, allcode a
    where cf.custid = af.custid and af.acctno = ci.afacctno
        and cf.custodycd = v_custodycd
        AND A.CDNAME = 'CLASS' AND A.CDTYPE = 'CF' AND A.CDVAL = CF.CLASS
        and af.corebank <> 'Y'
        and exists (select gu.grpid from tlgrpusers gu where af.careby = gu.grpid and gu.tlid = V_TLID)   -- check careby cf.careby = gu.grpid
    group by  cf.custid, cf.custodycd, af.acctno,a.cdcontent , cf.fullname, cf.idcode, cf.iddate, cf.idplace, cf.mobile, cf.address
)cibal
left join
(
    -- Danh sach giao dich CI: tu From Date den ToDate
    select tci.autoid orderid, tci.custid, tci.custodycd, tci.acctno afacctno, tci.tllog_autoid autoid, tci.txtype,
        tci.busdate,
        --nvl(tci.trdesc,tci.txdesc) txdesc,
        CASE WHEN TLTXCD = '3350' THEN tci.txdesc ELSE nvl(tci.trdesc,tci.txdesc) END txdesc,
        '' symbol, 0 se_credit_amt, 0 se_debit_amt,
        case when tci.txtype = 'C' then namt else 0 end ci_credit_amt,
        case when tci.txtype = 'D' then namt else 0 end ci_debit_amt,
        tci.txnum, '' tltx_name, tci.tltxcd, tci.txdate, tci.txcd,  tci.trdesc, tci.bkdate
    from   (
            select ci.autoid, ci.custodycd, ci.custid,
            ci.txnum, ci.txdate, ci.acctno, ci.txcd, ci.namt,
            ci.camt, ci.ref, nvl(ci.deltd, 'N') deltd, ci.acctref,
            ci.tltxcd, ci.busdate, ci.txdesc, ci.txtime, ci.brid, ci.tlid, ci.offid, ci.chid,
            ci.txtype, ci.field, ci.tllog_autoid, ci.trdesc, ci.busdate bkdate
            from   vw_citran_gen ci
            where   ci.txtype      in   ('D','C')
            and CI.TLTXCD NOT IN ('8855','8865','8856','8866','0066','1144','1145','8889')  -- them 2 giao dich '1144','1145' phong toa, GianhVG
            and ci.field = 'BALANCE' and ci.custodycd = v_custodycd
            UNION ALL
            SELECT 0 AUTOID, CF.custodycd, cf.custid, TL.txnum, TL.txdate, TL.MSGacct acctno,'D' txcd,0 namt,
            '' camt, '' ref, nvl(TL.deltd, 'N') deltd, TL.MSGacct acctref,
            tl.tltxcd, tl.busdate, tl.txdesc, tl.txtime, tl.brid, tl.tlid, tl.offid, tl.chid,
            'D' txtype, 'BALANCE' field,
             tl.autoid+1 tllog_autoid,
            '' trdesc, TL.txdate bkdate
            FROM VW_TLLOG_ALL TL, cfmast cf, afmast af
            where   cf.custid       =    af.custid
            and     TL.MSGacct       =    af.acctno
            and af.corebank <> 'Y'
            --and     ci.ref          =    df.lnacctno (+)
            and     tl.deltd        <>  'Y'
             AND TL.TLTXCD='3324'
            ) tci
    where tci.bkdate between v_fromdate and v_todate


       union all
       -------Tach giao dich mua ban
       select  max(tci.autoid) orderid, tci.custid, tci.custodycd, tci.acctno afacctno, max(tci.tllog_autoid) autoid, tci.txtype,
        tci.busdate, case when TCI.TLTXCD = '8865' then 'Tr? ti?n mua CK ngày ' || to_char(max(tci.oddate),'dd/mm/rrrr')--TO_CHAR(tci.busdate)
                        when TCI.TLTXCD = '8889' then 'Tr? ti?n mua CK ngày ' || to_char(max(tci.oddate),'dd/mm/rrrr')--TO_CHAR(tci.busdate)
                        when TCI.TLTXCD = '8856' then 'Tr? phí CK ngày ' || to_char(max(tci.oddate),'dd/mm/rrrr')--TO_CHAR(tci.busdate)
                        when TCI.TLTXCD = '8866' then 'Nh?n ti?n bán CK ngày ' || to_char(max(tci.oddate),'dd/mm/rrrr')--TO_CHAR(tci.busdate)
                        else  'Tr? phí mua CK ngày ' || to_char(max(tci.oddate),'dd/mm/rrrr')--TO_CHAR(tci.busdate)
                        end TXDESC,
         '' symbol, 0 se_credit_amt, 0 se_debit_amt,
        SUM(case when tci.txtype = 'C' then namt else 0 end) ci_credit_amt,
        SUM(case when tci.txtype = 'D' then namt else 0 end) ci_debit_amt,
        '' txnum, '' tltx_name, tci.tltxcd,  tci.txdate, tci.txcd,  '' trdesc, tci.bkdate
    from   (select ci.autoid, ci.custodycd, ci.custid,
            ci.txnum, ci.txdate, ci.acctno, ci.txcd, ci.namt,
            ci.camt, ci.ref, ci.deltd deltd, ci.acctref,
            ci.tltxcd, ci.busdate, ci.txdesc, ci.txtime, ci.brid, ci.tlid, ci.offid, ci.chid,
            ci.txtype, ci.field, ci.tllog_autoid, ci.trdesc, ci.busdate bkdate, od.txdate oddate
            from    vw_citran_gen ci, vw_odmast_all od
            where   ci.txtype      in   ('D','C')
            and     ci.deltd        <>  'Y'
            and     ci.ref= od.orderid
            and     ci.namt         <>  0
            ) tci
    where  tci.bkdate between v_fromdate and v_todate
       and tci.custodycd = v_custodycd
       and tci.field = 'BALANCE'
       AND TCI.TLTXCD IN ('8855','8865','8856','8866','8889')
    GROUP BY tci.custid, tci.custodycd, tci.acctno ,  tci.txtype, tci.busdate, tci.tltxcd, tci.txcd,tci.txdate,tci.bkdate, tci.oddate

      union all
       -----Thue TNCN:
     SELECT max(tci.autoid) orderid,  tci.custid, tci.custodycd, tci.acctno afacctno, max(tci.tllog_autoid) autoid, tci.txtype,
        tci.busdate, tci.description TXDESC,
         '' symbol, 0 se_credit_amt, 0 se_debit_amt,
        SUM(case when tci.txtype = 'C' then namt else 0 end) ci_credit_amt,
        SUM(case when tci.txtype = 'D' then namt else 0 end) ci_debit_amt,
        '' txnum, '' tltx_name, tci.tltxcd, tci.txdate, tci.txcd, '' trdesc, tci.bkdate
    from   (
           select ci.autoid, ci.custodycd, ci.custid,
            ci.txnum, ci.txdate, ci.acctno, ci.txcd, ci.namt,
            ci.camt, ci.ref, ci.deltd, ci.acctref,
            ci.tltxcd, ci.busdate, ci.txdesc, ci.txtime, ci.brid, ci.tlid, ci.offid, ci.chid,
            ci.txtype, ci.field, ci.tllog_autoid, ci.trdesc, ci.busdate bkdate,
            CASE WHEN ci.txcd = '0011' THEN ci.txdesc
                 WHEN ci.txcd = '0028' THEN ci.trdesc || ' ngày ' || substr(ci.txdesc, length(ci.txdesc) -10, 10)
                 END description
            from    vw_citran_gen ci
            where   ci.txtype      in   ('D','C')
            and     ci.deltd        <>  'Y'
            and     ci.namt         <>  0 and CI.TLTXCD IN ('0066') and ci.field = 'BALANCE'
            ) tci
    where  tci.bkdate between v_fromdate and v_todate
       and tci.custodycd = v_custodycd
    GROUP BY tci.custid, tci.custodycd, tci.acctno ,  tci.txtype, tci.busdate, tci.tltxcd, tci.txcd,tci.txdate,tci.bkdate, tci.description
) tr on cibal.custid = tr.custid and cibal.acctno = tr.afacctno

left join
(
    -- Tong phat sinh CI tu From date den ngay hom nay
    select tr.custid, tr.acctno,
        sum(case when tr.txtype = 'D' then -tr.namt else tr.namt end) ci_total_move_frdt_amt
    from   (select ci.autoid, ci.custodycd, ci.custid,
            ci.txnum, ci.txdate, ci.acctno, ci.txcd, ci.namt,
            ci.camt, ci.ref, ci.deltd, ci.acctref,
            ci.tltxcd, ci.busdate, ci.txdesc, ci.txtime, ci.brid, ci.tlid, ci.offid, ci.chid,
            ci.txtype, ci.field, ci.tllog_autoid, ci.trdesc, ci.busdate bkdate
            from   vw_citran_gen ci
            where   ci.txtype      in   ('D','C')
            and     ci.deltd        <>  'Y'
            and     ci.namt         <>  0
            ) tr
    where
        tr.bkdate >= v_fromdate and tr.bkdate <= v_CurrDate
        and tr.custodycd = v_custodycd
        and tr.field in ('BALANCE')
        AND tr.tltxcd NOT IN ('1144','1145') -- bo giao dich phong toa , GianhVG
    group by tr.custid, tr.acctno
) ci_move_fromdt on cibal.custid = ci_move_fromdt.custid and cibal.acctno = ci_move_fromdt.acctno

left join
(
    -- Tong phat sinh CI.RECEIVING tu Todate + 1 den ngay hom nay
    select tr.custid, tr.acctno,
        sum(
            case when field = 'RECEIVING' then
                case when tr.txtype = 'D' then -tr.namt else tr.namt end
            else 0
            end
            ) ci_RECEIVING_move,

        sum(
            case when field IN ('EMKAMT') then
                case when tr.txtype = 'D' then -tr.namt else tr.namt end
            else 0
            end
            ) ci_EMKAMT_move,

        sum(
            case when field = 'DFDEBTAMT' then
                case when tr.txtype = 'D' then -tr.namt else tr.namt end
            else 0
            end
            ) ci_DFDEBTAMT_move
    from      vw_citran_gen tr
    where   tr.txtype      in   ('D','C')
    and     tr.deltd        <>  'Y'
    and     tr.namt         <>  0
    and     tr.busdate > v_todate and tr.busdate <= v_CurrDate
    and tr.custodycd = v_custodycd
    and tr.field in ('RECEIVING','EMKAMT','DFDEBTAMT')
    group by tr.custid, tr.acctno
) ci_RECEIV on cibal.custid = ci_RECEIV.custid and cibal.acctno = ci_RECEIV.acctno

left join
(
    select cf.custid, cf.custodycd, af.acctno,
        case when v_CurrDate = v_todate then SUM(secureamt + advamt) else 0 end od_buy_secu
    from v_getbuyorderinfo V, afmast af, cfmast cf
    where v.afacctno = af.acctno and af.custid = cf.custid
        and cf.custodycd = v_custodycd and af.acctno = v_custodycd
    group by cf.custid, cf.custodycd, af.acctno
) secu on cibal.custid = secu.custid and cibal.acctno = secu.acctno

order by tr.bkdate, tr.autoid, tr.txnum, tr.txtype, tr.orderid,
         case when tr.tltxcd = '1143' and tr.txcd = '0077' then 'So tien den han phai thanh toan '
              when tr.tltxcd in ('1143','1153') and tr.txcd = '0011' and tr.trdesc is null then 'Phi ung truoc '
              else to_char(tr.txdesc)
    end
) main
left join
 (SELECT nvl(sum(amt),0) tmtracham,afacctno afacctnoN1
FROM (
        SELECT od.afacctno,
               SUM (
               CASE WHEN chd.trfbuydt < v_todate THEN 0
                    WHEN chd.trfbuydt = v_todate THEN
                         (CASE WHEN chd.trfbuydt = v_CurrDate AND chd.trfexeamt = 0 THEN od.execamt +  od.feeacr --chua chay batch giua ngay
                               WHEN chd.trfbuydt = v_CurrDate AND chd.trfexeamt <> 0 THEN  0 --chay batch thanh toan giua ngay
                               WHEN v_todate < v_CurrDate THEN 0
                               WHEN v_todate > v_CurrDate THEN od.execamt +  od.feeacr END)

                    WHEN chd.trfbuydt > v_todate THEN od.execamt +  od.feeacr
                    ELSE 0
                END
                   ) amt
        FROM
        (SELECT * FROM stschd WHERE duetype = 'SM' AND deltd <> 'Y'
            UNION ALL SELECT * FROM stschdhist WHERE duetype = 'SM' AND deltd <> 'Y'
        ) chd,
        (SELECT * FROM odmast union ALL SELECT * FROM odmasthist) od
        WHERE chd.orgorderid = od.orderid --AND od.afacctno = v_AFAcctno
        AND chd.txdate <= v_todate --dk can
        AND chd.txdate <> chd.trfbuydt --dk tra cham
        and CASE WHEN od.txdate = v_CurrDate AND chd.status = 'C' THEN 1        --lenh moi khop cung ngay, chay batch roi
                 WHEN od.txdate = v_CurrDate AND chd.status = 'N' THEN 0         --lenh moi khop chua chay batch
                 WHEN od.txdate <> v_CurrDate THEN 1
                 else 0 END = 1 --dk tra cham
        GROUP BY od.afacctno
       )
       group by afacctno
) b
on main.afacctno = b.afacctnoN1

;      -- Chu y: Khong thay doi thu tu Order by


EXCEPTION
  WHEN OTHERS
   THEN
      Return;
End;
/

