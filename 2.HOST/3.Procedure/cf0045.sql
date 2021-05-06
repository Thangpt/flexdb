CREATE OR REPLACE PROCEDURE cf0045 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   PV_CUSTODYCD       IN       VARCHAR2,
   PV_SYMBOL       IN       VARCHAR2
  )
IS
--

-- BAO CAO So du chung khoan
-- MODIFICATION HISTORY
-- PERSON       DATE                COMMENTS
-- ---------   ------  -------------------------------------------
-- TUNH        13-05-2010           CREATED
--
   CUR            PKG_REPORT.REF_CURSOR;
   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (4);                   -- USED WHEN V_NUMOPTION > 0

   v_TxDate date;
   v_CustodyCD varchar2(20);
   v_SYMBOL varchar2(20);
   v_CurrDate date;
   v_Bank varchar2(100);
   v_TCPH varchar2(100);
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

SELECT FullName into v_Bank FROM issuers WHERE shortname ='ACB';

SELECT varvalue into v_TCPH FROM sysvar WHERE varname ='COMPANYNAME';

v_TxDate:= to_date(F_DATE,'DD/MM/RRRR');
v_CustodyCD:= upper(replace(pv_custodycd,'.',''));

-- select careby into v_CareBy from cfmast where custodycd = v_CustodyCD;
-- select max(gu.grpid) into v_GroupID from tlgrpusers gu where gu.tlid = TLID and grpid = v_CareBy ;

if PV_SYMBOL = 'ALL' or PV_SYMBOL is null then
    v_SYMBOL := '%';
else
    v_SYMBOL := PV_SYMBOL;
end if;

-- Main report
OPEN PV_REFCURSOR FOR
select v_TCPH TCPH, v_Bank vBank, cf.custid, cf.fullname,
    case when substr(cf.custodycd,4,1) = 'C' then to_char(cf.idcode) else cf.tradingcode end idcode,
    case when substr(cf.custodycd,4,1) = 'C' then cf.iddate else cf.tradingcodedt end iddate,
    cf.idplace, cf.address, cf.mobile, cf.custodycd,
    sebal.afacctno, sebal.symbol,
    nvl(se_balance,0) se_balance,
    nvl(trade,0) trade,
    nvl(blocked,0),
    --- nvl(blocked,0) blocked, nvl(blocked,0) - nvl(se_blocked_move_amt,0) as  end_blocked_bal,
    nvl(se_block.curr_block_qtty,0) - nvl(se_block_move.cr_block_amt,0) + nvl(se_block_move.dr_block_amt,0) as end_blocked_bal -- han che CN

from cfmast cf,afmast af ----dien them table afmast ---2-10-2010
left join
(
    -- Tong so du CK hien tai group by tieu khoan, Symbol
    select cf.custid, af.acctno afacctno, symbol, se.acctno,
        sum(trade + blocked + mortage + netting + receiving) se_balance,
        sum(trade) trade, sum(blocked) blocked, sum(mortage) mortage, sum(netting) netting,
        sum(STANDING) STANDING, sum(RECEIVING) RECEIVING, sum(WITHDRAW) WITHDRAW
    from cfmast cf, afmast af, semast se, sbsecurities sb
    where cf.custid = af.custid and af.acctno = se.afacctno
        and se.codeid = sb.codeid and cf.custodycd = v_CustodyCD
        --and af.acctno like '0001000110'
        and sb.sectype <>'004'
        and symbol like v_SYMBOL
    group by  cf.custid, af.acctno, symbol,se.acctno
) sebal on af.acctno = sebal.afacctno
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
        --and se.afacctno like '0001000110'
    group by se.acctno
) se_block on sebal.acctno = se_block.acctno

left join   -- Phat sinh giao dich phong toa/giai toa CK chuyen nhuong co dieu kien
(
    select tr.acctno,
        sum(case when tr.tltxcd = '2202' then namt else 0 end) cr_block_amt,
        sum(case when tr.tltxcd = '2203' then namt else 0 end) dr_block_amt
    from vw_setran_gen tr
    where tr.field = 'BLOCKED'
        --and tr.afacctno like '0001000110'
        and tr.custodycd = v_CustodyCD
        and tr.tltxcd in ('2202','2203') and tr.ref = '002' and tr.namt <> 0
        --and tr.busdate > v_TxDate and tr.busdate <= v_CurrDate
    group by tr.acctno
) se_block_move on sebal.acctno = se_block_move.acctno

where cf.custodycd = v_CustodyCD
     -----------select gu.grpid from tlgrpusers gu where gu.grpid=cf.careby and gu.tlid = tlid---- dien sua 2-10-2010
    --and exists (select gu.grpid from tlgrpusers gu where af.careby=gu.grpid   and gu.tlid = v_TLID)   -- check careby

    and se_balance >0
order by sebal.symbol, sebal.afacctno;

EXCEPTION
  WHEN OTHERS
   THEN
      RETURN;
END;
/

