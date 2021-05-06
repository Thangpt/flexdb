CREATE OR REPLACE PROCEDURE PR_GETMRDETAIL (
        PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
        PV_CUSTODYCD IN VARCHAR2,
        PV_AFACCTNO IN VARCHAR2
        )
IS
        v_strCustodycd VARCHAR2(10);
        v_strafacctno VARCHAR2(10);
BEGIN
        v_strCustodycd := PV_CUSTODYCD;
        IF PV_AFACCTNO <> 'ALL' THEN
          v_strafacctno:= PV_AFACCTNO;
        ELSE
          v_strafacctno:= '%';
         END IF;
         OPEN PV_REFCURSOR FOR
select cf.custodycd, af.acctno,cf.fullname ,cf.mrloanlimit, cf.t0loanlimit, af.autoadv,
    af.mrcrlimitmax, round(ci.dfodamt) dfodamt,
    round(af.mrcrlimitmax - ci.dfodamt - nvl(mramt,0)) mrcrlimitremain,
    nvl(T0af.AFT0USED,0) AFT0USED,
    round(af.advanceline - nvl(b.trft0amt,0)) advanceline,
    round(cf.mrloanlimit)-ROUND(nvl(MR.CUSTMRUSED,0)) avlmrloanlimit,round(cf.t0loanlimit)-ROUND(nvl(T0.CUSTT0USED,0)) avlt0loanlimit,
    round(nvl(dfamt,0)) dfamt, round(nvl(dfprinamt,0)) dfprinamt, round(nvl(dfintamt,0)) dfintamt,
    round(nvl(mramt,0)) mramt, round(nvl(mrprinamt,0)) mrprinamt, round(nvl(mrintamt,0)) mrintamt,
    round(nvl(ln.t0amt,0)) t0amt, round(nvl(ln.t0pramt,0)) t0pramt,round(nvl(ln.t0intamt,0))  t0intamt,
   nvl(T1_TIEN_DANG_VE,0) T1_TIEN_DANG_VE,  nvl(T2_TIEN_DANG_VE,0) T2_TIEN_DANG_VE, nvl(T3_TIEN_DANG_VE,0) T3_TIEN_DANG_VE,
   nvl(T1_GT_CON_LAI,0) T1_GT_CON_LAI ,nvl(T2_GT_CON_LAI,0) T2_GT_CON_LAI,nvl(T3_GT_CON_LAI,0) T3_GT_CON_LAI,
   nvl(T1_TIEN_DA_UNG,0) T1_TIEN_DA_UNG,nvl(T2_TIEN_DA_UNG,0) T2_TIEN_DA_UNG,nvl(T3_TIEN_DA_UNG,0) T3_TIEN_DA_UNG,
   nvl(T_TIEN_DANG_VE,0) T_TIEN_DANG_VE, nvl(T_GT_CON_LAI,0) T_GT_CON_LAI, nvl(T_TIEN_DA_UNG,0)  T_TIEN_DA_UNG
from afmast af, cfmast cf, cimast ci, aftype aft, mrtype mrt,
v_getbuyorderinfo b,
(select sum(acclimit) CUSTT0USED, af.CUSTID from useraflimit us, afmast af where af.acctno = us.acctno and us.typereceive = 'T0' group by custid) T0,
(select sum(acclimit) AFT0USED, acctno from useraflimit us where us.typereceive = 'T0' group by acctno) T0af,
(select sum(mrcrlimitmax) CUSTMRUSED, CUSTID from afmast group by custid) MR,
(select trfacctno,
        sum(decode(ftype,'DF',1,0)*(prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd)) dfamt,
        sum(decode(ftype,'DF',1,0)*(prinnml+prinovd)) dfprinamt,
        sum(decode(ftype,'DF',1,0)*(intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd)) dfintamt,
        sum(decode(ftype,'AF',1,0)*(prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd)) mramt,
        sum(decode(ftype,'AF',1,0)*(prinnml+prinovd)) mrprinamt,
        sum(decode(ftype,'AF',1,0)*(intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd)) mrintamt,
        sum(decode(ftype,'AF',1,0)*(oprinnml+oprinovd+ointnmlacr+ointdue+ointovdacr+ointnmlovd)) t0amt,
        sum(decode(ftype,'AF',1,0)*(oprinnml+oprinovd)) t0pramt,
        sum(decode(ftype,'AF',1,0)*(ointnmlacr+ointdue+ointovdacr+ointnmlovd)) t0intamt
    from lnmast
    group by trfacctno) ln,
(
SELECT  UTacctno, nvl(T1_TIEN_DANG_VE,0) T1_TIEN_DANG_VE,  nvl(T2_TIEN_DANG_VE,0) T2_TIEN_DANG_VE, nvl(T3_TIEN_DANG_VE,0) T3_TIEN_DANG_VE,
               nvl(T1_TIEN_DANG_VE,0) +  nvl(T2_TIEN_DANG_VE,0)+ nvl(T3_TIEN_DANG_VE,0) AS T_TIEN_DANG_VE,
               nvl(T1_GT_CON_LAI,0) T1_GT_CON_LAI ,nvl(T2_GT_CON_LAI,0) T2_GT_CON_LAI,nvl(T3_GT_CON_LAI,0) T3_GT_CON_LAI,
               nvl(T1_GT_CON_LAI,0) + nvl(T2_GT_CON_LAI,0)  + nvl(T3_GT_CON_LAI,0) AS T_GT_CON_LAI,
               nvl(T1_TIEN_DA_UNG,0) T1_TIEN_DA_UNG,nvl(T2_TIEN_DA_UNG,0) T2_TIEN_DA_UNG,nvl(T3_TIEN_DA_UNG,0) T3_TIEN_DA_UNG,
                nvl(T1_TIEN_DA_UNG,0) + nvl(T2_TIEN_DA_UNG,0) + nvl(T3_TIEN_DA_UNG,0) AS T_TIEN_DA_UNG
FROM
(SELECT 'T'||ROWNUM AS ngay_TT,acctno UTacctno,execamt, aamt, maxavlamt, custodycd
FROM vw_advanceschedule a  WHERE custodycd = v_strCustodycd AND acctno LIKE v_strafacctno)
PIVOT ( max(execamt) AS tien_dang_ve,
              max(aamt) AS tien_da_ung,
              max(maxavlamt) AS gt_con_lai
               FOR ngay_TT IN
      ('T1' AS T1, 'T2' AS T2, 'T3' AS T3
      )
)
) UTTB
where af.custid=cf.custid
and af.acctno = ci.acctno
and af.actype =aft.actype
and aft.mrtype =mrt.actype
and af.acctno = T0af.acctno(+)
and cf.custid = T0.custid(+)
and cf.custid = MR.custid(+)
and af.acctno = b.afacctno(+)
and af.acctno = ln.trfacctno(+)
AND af.acctno = UTTB.UTacctno(+)
AND cf.custodycd = v_strCustodycd
AND af.acctno LIKE v_strAfacctno
;
   EXCEPTION
    WHEN others THEN
        return;
END;
/

