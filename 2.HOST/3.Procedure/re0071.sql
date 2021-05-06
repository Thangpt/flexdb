CREATE OR REPLACE PROCEDURE re0071 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
    F_DATE          in      varchar2,
    T_DATE           in      varchar2,
    P_CUSTID        in      varchar2,
    P_CUSTODYCD     in      varchar2,
    P_FREEORAMOUNT     in      varchar2,
    F_AMOUNT         in      varchar2,
    T_AMOUNT         in      varchar2,
    O_DATE           in      varchar2,
    C_DATE           in      varchar2,
    P_SORB             in      varchar2,
    P_TRADEPLACE       in      varchar2
 )
IS

    V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID          VARCHAR2 (40);    -- USED WHEN V_NUMOPTION > 0
    V_INBRID     VARCHAR2 (5);
    V_CUSTID varchar2(10);
    V_CUSTODYCD varchar2(10);

    V_GROUPID varchar2(10);
    V_SORB  varchar2(10);
    V_TRADEPLACE    varchar(10);
BEGIN

   V_STROPTION := upper(OPT);
   V_INBRID := BRID;

   if(V_STROPTION = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := BRID;
        end if;
    end if;

    IF P_TRADEPLACE <> 'ALL' THEN
        V_TRADEPLACE := P_TRADEPLACE;
    ELSE V_TRADEPLACE := '%';
    END IF;

   ------------------------
   IF (P_SORB <> 'ALL')
   THEN
    V_SORB := P_SORB;
   ELSE
    V_SORB := '%';
   END IF;
   -----------------------

   IF (P_CUSTID <> 'ALL')
   THEN
        V_CUSTID := P_CUSTID;
   else
        V_CUSTID := '%';
   end if
   ;

    IF (P_CUSTODYCD <> 'ALL')
   THEN
        V_CUSTODYCD := P_CUSTODYCD;
   else
        V_CUSTODYCD := '%';
   end if
   ;
   ------------------------------

OPEN PV_REFCURSOR FOR
select kc.custodycd cus_kh, ka.acctno tai_khoan, kc.fullname ten_NDT, mc.fullname ten_NVQL, re_mg.brid ma_chi_nhanh,
    case when od.exectype in ('NB','AB','BC') then 'Mua'
         when od.exectype in ('NS','SS','MS','AS') then 'Ban' end mua_ban,
    od.execqtty so_luong,od.execamt gia_tri, od.feeacr phi, kc.email, nvl(kc.mobile, kc.phone) SDT , od.orderid
from
    (SELECT orderid, afacctno, codeid, txdate,execqtty,  execamt EXECAMT, feeacr, exectype FROM odmast WHERE deltd <> 'Y'
        UNION ALL
    SELECT orderid,afacctno, codeid, txdate,execqtty, execamt EXECAMT, feeacr, exectype FROM odmasthist WHERE deltd <> 'Y') OD,
    reaflnk re_kh, cfmast kc, afmast ka, cfmast mc, recflnk re_mg, retype re, sbsecurities sb
where kc.custid = ka.custid and ka.acctno = re_kh.afacctno
and mc.custid = substr(re_kh.reacctno,1,10)
and od.exectype in ('NB','AB','BC','NS','SS','MS','AS')
and od.afacctno = re_kh.afacctno
and od.txdate <= to_date(T_DATE,'DD/MM/RRRR') and od.txdate >=  to_date(F_DATE,'DD/MM/RRRR')
and od.txdate <= nvl(re_kh.clstxdate -1, re_kh.todate) and od.txdate >= re_kh.frdate
and substr(re_kh.reacctno,1,10) = re_mg.custid
and re.actype = substr(re_kh.reacctno,11,4)
and re.rerole in ('BM','RM')
and od.codeid = sb.codeid
and od.execamt <> 0
and mc.custid like V_CUSTID
and kc.custodycd like V_CUSTODYCD
and ka.opndate >= to_date(O_DATE,'DD/MM/RRRR')
and ka.opndate <= to_date(C_DATE,'DD/MM/RRRR')
and case when od.exectype in ('NB','AB','BC') then 'B'
         when od.exectype in ('NS','SS','MS','AS') then 'S' end like V_SORB
and sb.tradeplace like V_TRADEPLACE
and case when P_FREEORAMOUNT = 0 then od.execamt
         when P_FREEORAMOUNT = 1 then od.feeacr end >= F_AMOUNT
and case when P_FREEORAMOUNT = 0 then od.execamt
         when P_FREEORAMOUNT = 1 then od.feeacr end <= T_AMOUNT
AND (substr(kc.custid,1,4) LIKE V_STRBRID OR instr(V_STRBRID,substr(kc.custid,1,4))<> 0)
order by od.txdate,kc.custodycd, ka.acctno

;

EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
End;
/

