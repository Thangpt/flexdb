CREATE OR REPLACE PROCEDURE gl1000_bk (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   MNEMONIC       IN       VARCHAR2
)
IS
--
-- PURPOSE: Bao cao Rut nop tien mat
--
-- MODIFICATION HISTORY
-- PERSON               DATE                COMMENTS
-- ---------------      -----------         ---------------------
-- TUNH                 22/05/2010          Tao moi
-- Huynh.nd             22/09/2010          Chinh sua dong 86-91
-- Huynh.nd        22/10/2010      Chinh sua loi khi chay dieu kien ALL change ID 94
-- ---------   ------  -------------------------------------------
  V_STROPTION            VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
  V_STRBRID              VARCHAR2 (4);
  v_FromDate date;
  v_ToDate date;
  v_mnemonic varchar2(100);
  v_GLAcctno varchar2(30);
  v_GLName varchar2(300);
  v_EndBal number(28,4);
  v_tramt_from_curr number(28,4);


BEGIN

    V_STROPTION := OPT;

    IF V_STROPTION = 'A' THEN
        V_STRBRID := '%';
    ELSif V_STROPTION = 'B' THEN
        V_STRBRID := substr(BRID,1,2) || '__';
    else
        V_STRBRID := BRID;
    END IF;

    v_FromDate := to_date(F_DATE,'DD/MM/RRRR');
    v_ToDate := to_date(T_DATE,'DD/MM/RRRR');
    v_mnemonic := TRIM(upper(MNEMONIC));

IF v_mnemonic <> 'ALL' THEN

    -- Get GL Account
    select acctno, acname, balance into v_GLAcctno, v_GLName, v_EndBal
    from glmast
    where mnemonic = v_mnemonic;
    -- v_GLAcctno := '0001000000999999000001';

    -- Lay tong phat sinh tu ngay From Date den ngay hien tai
    select
        sum (case when dorc = 'D' then -amt else amt end )
        into v_tramt_from_curr
    from vw_gltran_all tr
    where tr.bkdate >= v_FromDate
        and tr.acctno = v_GLAcctno;

-- Main report
OPEN PV_REFCURSOR FOR

select mst.GLAcctno, mst.GLName, mst.EndBal, mst.tramt_from_curr,
    -(nvl(v_EndBal,0) - nvl(v_tramt_from_curr,0)) BeginBal,
    tr.acctno, tr.txdate, tr.busdate, tr.txnum, tr.tltxcd, tr.txdesc, maker_name, checker_name,
    nvl(debit_amt,0) debit_amt, nvl(credit_amt,0) credit_amt,
    tr.custodycd, tr.afacctno, fullname, tr.autoid
From
--khong lay GL
(
    select v_GLAcctno GLAcctno, v_GLName GLName, v_EndBal EndBal, v_tramt_from_curr tramt_from_curr
    from dual
) mst,

(
-- Lay phat sinh tu FromDate den ToDate doi voi giao dich phan he CI
select gl.acctno, gl.txdate, ci.busdate, gl.txnum, gl.tltxcd, ci.txdesc, mk.tlname maker_name, ch.tlname checker_name,
    case when gl.dorc = 'D' then gl.amt else 0 end debit_amt,
    case when gl.dorc = 'C' then gl.amt else 0 end credit_amt,
    cf.custodycd, af.acctno afacctno, to_char(cf.fullname) fullname, ci.autoid
from vw_gltran_all gl,  afmast af, cfmast cf,
    (
        select DISTINCT  busdate, txdate, txnum,  tlid, autoid, a.txdesc, a.tltxcd, offid, acctno
        from vw_tllog_citran_all a, tltx tx
        where a.tltxcd = tx.tltxcd and tx.txtype in  ('D','W')
            and busdate between v_FromDate and v_ToDate
           -- huynh.nh them --
            and not exists (select b.autoid from vw_tllog_citran_all b
                      where b.txstatus <> '1' and b.tltxcd = '1100'
                      and b.busdate between v_FromDate and v_ToDate and a.AUTOID=b.AUTOID)
/*            and autoid not in ( select distinct a.autoid from vw_tllog_citran_all a
                    where a.txstatus <> '1' and a.tltxcd = '1100'
                    and a.busdate between v_FromDate and v_ToDate
                     )*/
           -- huynh.nd them - End ---
    ) ci,
    tlprofiles mk, tlprofiles ch
where gl.txdate = ci.txdate and gl.txnum = ci.txnum
    and ci.acctno = af.acctno
    and af.custid = cf.custid
    and ci.tlid = mk.tlid
    and ci.offid = ch.tlid(+)
    and gl.acctno = v_GLAcctno
    and ci.busdate between v_FromDate and v_ToDate

union all
-- Lay phat sinh tu FromDate den ToDate doi voi giao dich phan he GL
select gl.acctno, gl.txdate, ci.busdate, gl.txnum, gl.tltxcd, ci.txdesc, mk.tlname maker_name, ch.tlname checker_name,
    case when gl.dorc = 'D' then gl.amt else 0 end debit_amt,
    case when gl.dorc = 'C' then gl.amt else 0 end credit_amt,
    ' ' custodycd, ' ' afacctno, ' ' fullname, ci.autoid
from vw_gltran_all gl, vw_tllog_all ci,
    tlprofiles mk, tlprofiles ch
where gl.txdate = ci.txdate and gl.txnum = ci.txnum
    and ci.tlid = mk.tlid and ci.offid = ch.tlid
    and gl.acctno = v_GLAcctno
    and ci.tltxcd in ('9906','9907')
    and ci.busdate between v_FromDate and v_ToDate
) tr
where mst.glacctno = tr.acctno (+)
order by tr.busdate, tr.autoid;

else
OPEN PV_REFCURSOR FOR
  select mst.GLAcctno, mst.GLName, mst.EndBal, mst.tramt_from_curr,
      -(nvl(EndBal,0) - nvl(tramt_from_curr,0)) BeginBal,
      tr.acctno, tr.txdate, tr.busdate, tr.txnum, tr.tltxcd, tr.txdesc, maker_name, checker_name,
      nvl(debit_amt,0) debit_amt, nvl(credit_amt,0) credit_amt,
      tr.custodycd, tr.afacctno, fullname, tr.autoid
  From
  (
      select gl.acctno GLAcctno , gl.acname GLName, trci.acctno ciacctno,  gl.balance EndBal, sum (case when dorc = 'D' then -amt else amt end ) tramt_from_curr
      from glmast gl , vw_gltran_all tr , citran_gen trci
      where tr.acctno = gl.acctno and gl.GLBANK = '09999'
            and tr.txnum = trci.TXNUM and tr.txdate = trci.TXDATE
            and tr.bkdate >= v_FromDate
      group by gl.acctno, gl.acname, gl.balance, trci.acctno
  ) mst,
  (
  -- Lay phat sinh tu FromDate den ToDate doi voi giao dich phan he CI
  select gl.acctno, gl.txdate, ci.busdate, gl.txnum, gl.tltxcd, ci.txdesc, mk.tlname maker_name, ch.tlname checker_name,
      case when gl.dorc = 'D' then gl.amt else 0 end debit_amt,
      case when gl.dorc = 'C' then gl.amt else 0 end credit_amt,
      cf.custodycd, af.acctno afacctno, to_char(cf.fullname) fullname, ci.autoid
  from vw_gltran_all gl,  afmast af, cfmast cf, glmast glm,
      (
          select DISTINCT  busdate, txdate, txnum,  tlid, autoid, a.txdesc, a.tltxcd, offid, acctno
          from vw_tllog_citran_all a, tltx tx
          where a.tltxcd = tx.tltxcd and tx.txtype in  ('D','W')
              and busdate between v_FromDate and v_ToDate
             -- huynh.nh them --
              and not exists (select b.autoid from vw_tllog_citran_all b
                      where b.txstatus <> '1' and b.tltxcd = '1100'
                      and b.busdate between v_FromDate and v_ToDate and a.AUTOID=b.AUTOID)
             -- huynh.nd them - End ---
      ) ci,
      tlprofiles mk, tlprofiles ch
  where gl.txdate = ci.txdate and gl.txnum = ci.txnum
      and ci.acctno = af.acctno
      and af.custid = cf.custid
      and ci.tlid = mk.tlid
      and ci.offid = ch.tlid(+)
      and glm.acctno = gl.acctno (+)
      and glm.glbank = '09999'
      and ci.busdate between v_FromDate and v_ToDate

  union all
  -- Lay phat sinh tu FromDate den ToDate doi voi giao dich phan he GL
  select gl.acctno, gl.txdate, ci.busdate, gl.txnum, gl.tltxcd, ci.txdesc, mk.tlname maker_name, ch.tlname checker_name,
      case when gl.dorc = 'D' then gl.amt else 0 end debit_amt,
      case when gl.dorc = 'C' then gl.amt else 0 end credit_amt,
      ' ' custodycd, ' ' afacctno, ' ' fullname, ci.autoid
  from vw_gltran_all gl, vw_tllog_all ci, glmast glm,
      tlprofiles mk, tlprofiles ch
  where gl.txdate = ci.txdate and gl.txnum = ci.txnum
      and ci.tlid = mk.tlid and ci.offid = ch.tlid
      and glm.acctno = gl.acctno(+)
      and glm.glbank = '09999'
      and ci.tltxcd in ('9906','9907')
      --and ci.busdate between v_FromDate and v_ToDate
  ) tr
  where mst.glacctno = tr.acctno(+)
        and mst.ciacctno = tr.afacctno(+)
        and tr.busdate between v_FromDate and v_ToDate
  order by tr.busdate, tr.autoid;
end if;

EXCEPTION
   WHEN OTHERS THEN
      RETURN;
END;
/

