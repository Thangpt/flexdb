CREATE OR REPLACE PROCEDURE CF1004 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2
  )
IS
--

-- DANH SACH  GIAO DICH KHOANH NO
-- MODIFICATION HISTORY
-- PERSON       DATE                COMMENTS
-- ---------   ------  -------------------------------------------
-- TRUONGLD    13-06-2010           CREATED
--
   CUR            PKG_REPORT.REF_CURSOR;
   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (4);                   -- USED WHEN V_NUMOPTION > 0
   v_FromDate date;
   v_ToDate date;
   v_CurrDate date;
   v_CustodyCD varchar2(20);
BEGIN

V_STROPTION := OPT;
IF V_STROPTION = 'A' then
    V_STRBRID := '%';
ELSIF V_STROPTION = 'B' then
    V_STRBRID := substr(BRID,1,2) || '__' ;
else
    V_STRBRID:=BRID;
END IF;

v_FromDate:= to_date(F_DATE,'DD/MM/RRRR');
v_ToDate:= to_date(T_DATE,'DD/MM/RRRR');
v_CustodyCD:= upper(replace(pv_custodycd,'.',''));

if v_CustodyCD = 'ALL' or v_CustodyCD is null then
    v_CustodyCD := '%';
else
    v_CustodyCD := pv_custodycd;
end if;
OPEN PV_REFCURSOR FOR

  select txdate, txnum, custodycd, fullname, dfacctno, debtamt, txdesc, tltxcd, autoid
  from
  (
      select tr.txdate, tr.txnum, cf.custodycd, cf.fullname, df.acctno dfacctno, tr.namt debtamt, tr.txdesc, tr.tltxcd, tr.autoid
      from vw_tllog_citran_all tr, cfmast cf, afmast af, apptx tx, vw_dfmast_all df
      where tr.acctno = af.acctno and cf.custid = af.custid
          and tr.txcd = tx.txcd and tx.field = 'DFDEBTAMT' and tx.txtype = 'C'
          and cf.custodycd like v_CustodyCD
          and tr.ref = df.lnacctno
          and tr.busdate between v_FromDate and v_ToDate
          and tr.tltxcd ='2643'
          and tr.namt <> 0
      union
      select tr.txdate, tr.txnum, cf.custodycd, cf.fullname, od.dfacctno, tr.namt debtamt, tr.txdesc, tr.tltxcd, tr.autoid
      from vw_tllog_citran_all tr, cfmast cf, afmast af, apptx tx, vw_odmast_all od
      where tr.acctno = af.acctno and cf.custid = af.custid
          and tr.txcd = tx.txcd and tx.field = 'DFDEBTAMT' and tx.txtype = 'C'
          and cf.custodycd like v_CustodyCD
          and tr.ref = od.orderid
          and tr.busdate between v_FromDate and v_ToDate
          and tr.tltxcd='1143'
          and tr.namt <> 0
      union
      select tr.txdate, tr.txnum, cf.custodycd, cf.fullname, ' ' dfacctno, tr.namt debtamt, tr.txdesc, tr.tltxcd, tr.autoid
      from vw_tllog_citran_all tr, cfmast cf, afmast af, apptx tx
      where tr.acctno = af.acctno and cf.custid = af.custid
          and tr.txcd = tx.txcd and tx.field = 'DFDEBTAMT' and tx.txtype = 'C'
          and cf.custodycd like v_CustodyCD
          and tr.busdate between v_FromDate and v_ToDate
          and tr.tltxcd not in ( '1143','2643')
          and tr.namt <> 0
  ) a
  order by autoid;

EXCEPTION
  WHEN OTHERS
   THEN
      RETURN;
END;  -- PROCEDURE
/

