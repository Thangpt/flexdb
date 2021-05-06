CREATE OR REPLACE PROCEDURE ln0009 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2,
   TLID IN VARCHAR2
  )
IS
--

-- BAO CAO Sao ke tien cua tai khoan khach hang
-- MODIFICATION HISTORY
-- PERSON       DATE                COMMENTS
-- ---------   ------  -------------------------------------------
-- DUNGNH     07-SEP-2010           CREATED


   CUR            PKG_REPORT.REF_CURSOR;
   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (4);                   -- USED WHEN V_NUMOPTION > 0
   v_FromDate date;
   v_ToDate date;
   v_CurrDate date;
   v_CustodyCD varchar2(20);
   v_AFAcctno varchar2(20);
   v_TLID varchar2(4);
   BEGIN_AMT number(20);

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

v_FromDate  := to_date(F_DATE,'DD/MM/RRRR');
v_ToDate    := to_date(T_DATE,'DD/MM/RRRR');
v_CustodyCD := upper(replace(pv_custodycd,'.',''));
v_AFAcctno  := upper(replace(PV_AFACCTNO,'.',''));

SELECT ROUND(MST.PRINPAID - NVL(TO_MST_B.AMT,0) + NVL(TO_MST_A.PRINPAID,0)) INTO BEGIN_AMT
FROM (--SO DU HIEN TAI CUA KHACH HANG VAY BAO LANH
        SELECT MST.TRFACCTNO,
            SUM(SCHD.NML + SCHD.OVD) PRINPAID
        FROM (SELECT * FROM LNSCHD UNION ALL SELECT * FROM LNSCHDHIST) SCHD, VW_LNMAST_ALL MST
        WHERE MST.ACCTNO = SCHD.ACCTNO
            AND SCHD.REFTYPE IN ('P','GP')
            AND MST.FTYPE = 'AF'
            AND MST.TRFACCTNO = v_AFAcctno
            GROUP BY MST.TRFACCTNO
    ) MST,
    (--GIAO DICH HOAN TRA PHAT VAY BAO LANH
        select * from(
        SELECT LN.TRFACCTNO,
            SUM(CASE WHEN APP.FIELD IN ('PRINPAID','OPRINPAID') THEN LNTR.NAMT ELSE 0 END) PRINPAID
        FROM VW_LNTRAN_ALL LNTR, APPTX APP, VW_LNMAST_ALL LN
        WHERE LNTR.TXCD = APP.TXCD
            AND LNTR.ACCTNO = LN.ACCTNO
            AND LN.FTYPE = 'AF'
            AND APP.FIELD IN ('PRINPAID','OPRINPAID')
            AND APP.APPTYPE LIKE 'LN'
            AND LNTR.NAMT <> 0
            AND LN.TRFACCTNO = v_AFAcctno
            AND LNTR.TXDATE >= v_FromDate
        GROUP BY LN.TRFACCTNO
        )
    ) TO_MST_A ,
    (--GIAO DICH PHAT VAY BAO LANH.
       select * from (
        SELECT LN.TRFACCTNO, SUM(LNTR.NAMT) AMT
        FROM VW_LNTRAN_ALL LNTR, APPTX APP, VW_LNMAST_ALL LN
        WHERE LNTR.TXCD = APP.TXCD
            AND LN.FTYPE = 'AF'
            AND APP.APPTYPE = 'LN'
            AND APP.FIELD IN ('RLSAMT','ORLSAMT')
            AND APP.TXTYPE = 'C'
            AND LNTR.ACCTNO = LN.ACCTNO
            AND LNTR.NAMT <> 0
            AND LN.TRFACCTNO = v_AFAcctno
            AND LNTR.TXDATE >= v_FromDate
        GROUP BY LN.TRFACCTNO
        )
    ) TO_MST_B
WHERE MST.TRFACCTNO = TO_MST_A.TRFACCTNO(+)
    AND MST.TRFACCTNO = TO_MST_B.TRFACCTNO(+);

OPEN PV_REFCURSOR FOR
select cf.custodycd, cf.fullname, cf.address, BEGIN_AMT NAMT_BEGIN,
    nvl(tl.txdesc,null) txdesc, nvl(tl.tltxcd,null) tltxcd,
    nvl(FROM_TO_TR.TXDATE,null) TXDATE, nvl(FROM_TO_TR.TXNUM,null) TXNUM,
    nvl(FROM_TO_TR.AMT_C,0) AMT_C, nvl(FROM_TO_TR.AMT_D,0) AMT_D
from afmast af, cfmast cf,
(--GIAO DICH HOAN TRA PHAT VAY BAO LANH TU NGAY FROM_DATE DEN TO_DATE
        select TRFACCTNO, TXDATE, TXNUM, sum(AMT_C) AMT_C, sum(AMT_D) AMT_D
        from
        (
        SELECT LN.TRFACCTNO, LNTR.TXDATE, LNTR.TXNUM, (0) AMT_C,
            (CASE WHEN APP.FIELD IN ('PRINPAID','OPRINPAID') THEN LNTR.NAMT ELSE 0 END) AMT_D
        FROM VW_LNTRAN_ALL LNTR, APPTX APP, VW_LNMAST_ALL LN
        WHERE LNTR.TXCD = APP.TXCD
            AND LNTR.ACCTNO = LN.ACCTNO
            AND LN.FTYPE = 'AF'
            AND APP.FIELD IN ('PRINPAID','OPRINPAID')
            AND APP.APPTYPE LIKE 'LN'
            AND LN.TRFACCTNO = v_AFAcctno
            and LNTR.TXDATE BETWEEN v_FromDate and v_ToDate
            and LNTR.NAMT <> 0
        UNION ALL
    --GIAO DICH PHAT VAY BAO LANH TU NGAY FROM_DATE DEN TO_DATE
        SELECT LN.TRFACCTNO, LNTR.TXDATE, LNTR.TXNUM, (LNTR.NAMT) AMT_C, (0) AMT_D
        FROM VW_LNTRAN_ALL LNTR, APPTX APP, VW_LNMAST_ALL LN
        WHERE LNTR.TXCD = APP.TXCD
            AND LN.FTYPE = 'AF'
            AND APP.APPTYPE = 'LN'
            AND APP.FIELD IN ('RLSAMT','ORLSAMT')
            AND APP.TXTYPE = 'C'
            AND LNTR.ACCTNO = LN.ACCTNO
            AND LN.TRFACCTNO = v_AFAcctno
            and LNTR.TXDATE BETWEEN v_FromDate and v_ToDate
            and LNTR.NAMT <> 0
        )
        GROUP BY TRFACCTNO, TXDATE, TXNUM
    ) FROM_TO_TR,
    vw_tllog_all tl
where af.custid = cf.custid
    and FROM_TO_TR.txdate = tl.txdate
    and FROM_TO_TR.txnum = tl.txnum
    and af.acctno = FROM_TO_TR.TRFACCTNO(+)
    and af.acctno = v_AFAcctno
order by TXDATE, TXNUM
;


EXCEPTION
  WHEN OTHERS
   THEN
      RETURN;
END;
/

