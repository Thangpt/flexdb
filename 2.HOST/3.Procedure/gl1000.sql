CREATE OR REPLACE PROCEDURE gl1000 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   MNEMONIC       IN       VARCHAR2,
   CASHORBANK     IN       VARCHAR2
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
  v_FromDate             Date;
  v_ToDate               Date;
  v_mnemonic             Varchar2(100);
  v_CASHORBANK           Varchar2(10);
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
    v_mnemonic  := TRIM(upper(MNEMONIC));
    v_CASHORBANK := TRIM(upper(CASHORBANK));


if v_CASHORBANK = 'B' then

    Open PV_REFCURSOR FOR
    select  '' GLAcctno, '' GLName, 0 EndBal, 0 tramt_from_curr,
        0 BeginBal,
        af.acctno, ci.txdate, ci.busdate, ci.txnum, ci.tltxcd, ci.txdesc,mk.tlname maker_name, ch.tlname checker_name,
        case
         when ci.tltxcd in('1132') then ci.msgamt else 0
        end debit_amt,
        case
       when ci.tltxcd in('1131') then ci.msgamt else 0
        end credit_amt,
        cf.custodycd, af.acctno afacctno, cf.fullname, ci.autoid
    from vw_tllog_all ci,  tlprofiles mk, tlprofiles ch, cfmast cf, afmast af
     where ci.tltxcd in('1132','1131')
       and ci.tlid = mk.tlid
       and ci.offid = ch.tlid(+)
       and cf.custid=af.custid
       and af.acctno=ci.msgacct
       and ci. busdate >=v_FromDate
       and ci.busdate <=v_ToDate
       order by ci.txdate,ci.autoid;

elsif v_CASHORBANK = 'C' then

    Open PV_REFCURSOR FOR
    select  '' GLAcctno, '' GLName, 0 EndBal, 0 tramt_from_curr,
        0 BeginBal,
        af.acctno, ci.txdate, ci.busdate, ci.txnum, ci.tltxcd, ci.txdesc,mk.tlname maker_name, ch.tlname checker_name,
        case
         when ci.tltxcd in('1100','1107') then ci.msgamt else 0
        end debit_amt,
        case
       when ci.tltxcd in('1140') then ci.msgamt else 0
        end credit_amt,
        cf.custodycd, af.acctno afacctno, cf.fullname, ci.autoid
    from vw_tllog_all ci,  tlprofiles mk, tlprofiles ch, cfmast cf, afmast af
     where ci.tltxcd in('1140','1100','1107')
       and ci.tlid = mk.tlid
       and ci.offid = ch.tlid(+)
       and cf.custid=af.custid
       and af.acctno=ci.msgacct
       and ci. busdate >=v_FromDate
       and ci.busdate <=v_ToDate
       order by ci.txdate,ci.autoid;

ELSE

    Open PV_REFCURSOR FOR
    select  '' GLAcctno, '' GLName, 0 EndBal, 0 tramt_from_curr,
        0 BeginBal,
        af.acctno, ci.txdate, ci.busdate, ci.txnum, ci.tltxcd, ci.txdesc,mk.tlname maker_name, ch.tlname checker_name,
        case
         when ci.tltxcd in('1100','1107','1132') then ci.msgamt else 0
        end debit_amt,
        case
       when ci.tltxcd in('1140','1131') then ci.msgamt else 0
        end credit_amt,
        cf.custodycd, af.acctno afacctno, cf.fullname, ci.autoid
    from vw_tllog_all ci,  tlprofiles mk, tlprofiles ch, cfmast cf, afmast af
     where ci.tltxcd in('1140','1100','1107','1131','1132')
       and ci.tlid = mk.tlid
       and ci.offid = ch.tlid(+)
       and cf.custid=af.custid
       and af.acctno=ci.msgacct
       and ci. busdate >=v_FromDate
       and ci.busdate <=v_ToDate
       order by ci.txdate,ci.autoid;

End If;


EXCEPTION
   WHEN OTHERS THEN
      RETURN;
END;
/

