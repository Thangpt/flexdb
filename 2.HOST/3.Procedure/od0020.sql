CREATE OR REPLACE PROCEDURE od0020 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD      IN       VARCHAR2,
   PV_EXEAMTMIN       IN      VARCHAR2,
   PV_EXEAMTMAX       IN       VARCHAR2,
   PV_FEEAMTMIN      IN        VARCHAR2,
   PV_FEEAMTMAX    IN        VARCHAR2,
   PV_TRADEPLACE      IN      varchar2,
   SECTYPE                 IN       VARCHAR2,--1.7.2.1 MSBS-2280
   BONDTYPE                 IN       VARCHAR2--1.7.2.1 MSBS-2280

 )
IS
--
-- created by Chaunh at 06/03/2013
-- ---------   ------  -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (40);        -- USED WHEN V_NUMOPTION > 0
   V_INBRID           VARCHAR2 (4);

   V_STRCUSTOCYCD           VARCHAR2 (20);
   V_CURRDATE               DATE;
   V_TRADEPLACE             varchar2(4);
   V_SECTYPE   	 VARCHAR2 (5);
   V_BONDTYPE    VARCHAR2 (5);

BEGIN
   V_STROPTION := upper(OPT);
   V_INBRID := BRID;

   IF (V_STROPTION = 'A') THEN
      V_STRBRID := '%';
   ELSE if (V_STROPTION = 'B') then
            select brgrp.mapid into V_STRBRID from brgrp where brgrp.brid = V_INBRID;
        else
            V_STRBRID := V_INBRID;
        end if;
   END IF;

   SELECT TO_DATE(SY.VARVALUE, SYSTEMNUMS.C_DATE_FORMAT) INTO V_CURRDATE
   FROM SYSVAR SY WHERE SY.VARNAME = 'CURRDATE' AND SY.GRNAME = 'SYSTEM';

   IF (PV_CUSTODYCD <> 'ALL')
   THEN
      V_STRCUSTOCYCD := PV_CUSTODYCD;
   ELSE
      V_STRCUSTOCYCD := '%%';
   END IF;

    if PV_TRADEPLACE  <> 'ALL'
    then
        V_TRADEPLACE := PV_TRADEPLACE;
    else
        V_TRADEPLACE := '%';
    end if;
     --1.7.2.1: MSBS-2280 Thêm tiêu chí đầu vào để xuất riêng GTGD và phí cho TPCP
   IF (SECTYPE <> 'ALL')
   THEN
      V_SECTYPE := SECTYPE;
   ELSE
      V_SECTYPE := '%%';
   END IF;
   --
   IF (BONDTYPE <> 'ALL')
   THEN
      V_BONDTYPE := BONDTYPE;
   ELSE
      V_BONDTYPE := '%%';
   END IF;

OPEN PV_REFCURSOR
  FOR
SELECT a.fullname,a.acctno, a.custodycd, a.S_qtty, a.S_amt, a.B_qtty, a.B_amt, a.fee, a.refullname FROM
(
SELECT cf.fullname, cf.custodycd, af.acctno, nvl(re.refullname,' ') refullname, nvl(re.recustid,' ') recustid,
       sum(CASE WHEN iod.bors = 'S' THEN iod.matchqtty ELSE 0 END) S_qtty,
       sum(CASE WHEN iod.bors = 'S' THEN iod.matchqtty*iod.matchprice ELSE 0 END) S_amt,
       sum(CASE WHEN iod.bors = 'B' THEN iod.matchqtty ELSE 0 END) B_qtty,
       sum(CASE WHEN iod.bors = 'B' THEN iod.matchqtty*iod.matchprice ELSE 0 END) B_amt,
       sum(CASE WHEN od.execamt > 0 AND od.feeacr = 0 THEN ROUND(IOd.matchqtty * iod.matchprice * odtype.deffeerate / 100, 2)
            ELSE (CASE WHEN (od.execamt * od.feeacr) = 0 THEN 0
                       ELSE round(od.feeacr * iod.matchqtty * iod.matchprice / od.execamt,2)
                   END)
            END ) fee
FROM vw_iod_all iod,
     vw_odmast_all od, afmast af, cfmast cf,aftype, odtype, sbsecurities sb, sbsecurities sb2,
     -- begin ver: 1.5.0.2 | iss: 1749
     --(select cf.fullname refullname, cf.custid recustid, re.afacctno from reaflnk re, cfmast cf where cf.custid = substr(re.reacctno,1,1))re
     (  select cf.fullname refullname, cf.custid recustid, re.afacctno, re.frdate, nvl(re.clstxdate-1,re.todate) todate
        from reaflnk re, cfmast cf, retype rt
        where cf.custid = substr(re.reacctno,1,10)
            AND substr(re.reacctno,11,4) = rt.actype AND rt.rerole IN ('BM','RM')
    ) re
     -- end ver: 1.5.0.2 | iss: 1749
WHERE od.orderid = iod.orgorderid
AND iod.deltd <> 'Y' AND od.deltd <> 'Y'
AND od.afacctno = af.acctno
AND af.custid = cf.custid
AND af.actype = aftype.actype
AND odtype.actype = od.actype
AND od.codeid = sb.codeid
and nvl(sb.refcodeid, sb.codeid) = sb2.codeid
and od.afacctno = re.afacctno(+)
AND od.txdate >= re.frdate(+)
AND od.txdate <= re.todate(+)      --ver: 1.5.0.2 | iss: 1749
AND iod.txdate >= TO_DATE(F_DATE,'DD/MM/YYYY')
AND iod.txdate <= TO_DATE(T_DATE,'DD/MM/YYYY')
and sb2.tradeplace like V_TRADEPLACE
and sb.sectype like V_SECTYPE--1.7.2.1
and sb.bondtype like V_BONDTYPE
AND   (SUBSTR(af.acctno,1,4) like  V_STRBRID or instr(V_STRBRID,SUBSTR(af.acctno,1,4)) <> 0)
GROUP BY cf.fullname, cf.custodycd, acctno,  nvl(re.refullname,' '),  nvl(re.recustid,' ')
HAVING sum(iod.matchprice*iod.matchqtty) > 0
ORDER BY cf.fullname, cf.custodycd
) a
where S_amt + B_amt <= PV_EXEAMTMAX
and S_amt + B_amt >= PV_EXEAMTMIN
and fee <= PV_FEEAMTMAX and fee >= PV_FEEAMTMIN
and recustid like V_STRCUSTOCYCD
order by a.custodycd

;



EXCEPTION
   WHEN OTHERS
   THEN

      RETURN;
End;
/
