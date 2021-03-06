CREATE OR REPLACE PROCEDURE od0017EX (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD      IN       VARCHAR2,
   PV_ACCTNO        IN      VARCHAR2,
   PV_COREBANK       IN       VARCHAR2,
   PV_BANKCODE      IN        VARCHAR2,
   PV_GRCAREBY    IN        VARCHAR2,
   PV_CUSTTYPE      IN      varchar2,
   PV_RECUSTID      in      varchar2,
   PV_REGRPID      IN        VARCHAR2

 )
IS
--Bao cao tong hop phi giao dich toan cong ty
-- created by Chaunh at 10:07AM 21/06/2012
-- ---------   ------  -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (40);        -- USED WHEN V_NUMOPTION > 0
   V_INBRID           VARCHAR2 (4);

   V_STRCUSTOCYCD           VARCHAR2 (20);
   V_STRACCTNO              VARCHAR2(20);
   V_STRCOREBANK             VARCHAR2 (6);
   V_STRBANKCODE            VARCHAR2 (20);
   V_CURRDATE               DATE;
   V_CAREBY         varchar(20);
   V_CUSTTYPE       varchar(5);

   V_RECUSTID       varchar(10);
   V_REGRPID        varchar(10);
   v_vat            NUMBER;

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

   select to_number(varvalue) INTO v_vat from sysvar where varname = 'ADVSELLDUTY' and grname = 'SYSTEM';

   IF (PV_CUSTODYCD <> 'ALL')
   THEN
      V_STRCUSTOCYCD := PV_CUSTODYCD;
   ELSE
      V_STRCUSTOCYCD := '%';
   END IF;

   IF (PV_ACCTNO <> 'ALL')
   THEN
      V_STRACCTNO := PV_ACCTNO;
   ELSE
      V_STRACCTNO := '%';
   END IF;

   IF (PV_COREBANK <> 'ALL')
   THEN
      V_STRCOREBANK := PV_COREBANK;
   ELSE
      V_STRCOREBANK := '%';
   END IF;

   IF (PV_BANKCODE <> 'ALL')
   THEN
      V_STRBANKCODE := PV_BANKCODE;
   ELSE
      V_STRBANKCODE := '%';
   END IF;

    IF (PV_GRCAREBY <> 'ALL')
    THEN
     V_CAREBY := PV_GRCAREBY;
    ELSE
      V_CAREBY:='%';
    END IF;

   IF (PV_CUSTTYPE <> 'ALL')
   THEN
      V_CUSTTYPE := PV_CUSTTYPE;
   ELSE
      V_CUSTTYPE := '%';
   END IF;

   if PV_RECUSTID <> 'ALL'
   THEN
      V_RECUSTID := PV_RECUSTID;
   ELSE
      V_RECUSTID := '%';
   END IF;

    if PV_REGRPID <> 'ALL'
   THEN
      V_REGRPID := PV_REGRPID;
   ELSE
      V_REGRPID := '%';
   END IF;

OPEN PV_REFCURSOR
  FOR
SELECT a.fullname, a.custodycd, a.acctno, a.S_qtty, a.S_amt, a.B_qtty, a.B_amt, a.fee, a.taxsellamt vat
    , nvl(re.fullname,' ') ten_nhom, nvl(re.mrkname,' ') mrkname
    , nvl(dsf.dsfname,' ') dsfname
FROM
(
SELECT cf.fullname, cf.custodycd, af.acctno,
       sum(CASE WHEN od.exectype IN ('NS','MS','SS') THEN od.exqtty ELSE 0 END) S_qtty,
       sum(CASE WHEN od.exectype IN ('NS','MS','SS') THEN od.execamt ELSE 0 END) S_amt,
       sum(CASE WHEN od.exectype IN ('NB') THEN od.exqtty ELSE 0 END) B_qtty,
       sum(CASE WHEN od.exectype IN ('NB') THEN od.execamt ELSE 0 END) B_amt,
       sum(CASE WHEN od.execamt > 0 AND od.feeacr = 0 AND od.txdate = V_CURRDATE AND decode(nvl(bs.bchsts,'N'),'Y','Y','N') = 'N' THEN ROUND(od.execamt * odtype.deffeerate / 100, 2)
            ELSE od.feeacr END) fee,
       sum(CASE WHEN OD.EXECTYPE IN('NS','SS','MS') AND aftype.VAT = 'Y' AND (SELECT count(*) FROM sbbatchsts WHERE bchdate = od.txdate AND bchmdl = 'SABFB' AND bchsts = 'Y') = 0
                THEN v_vat * od.execamt /100 + NVL(st.ARIGHT, 0)
            ELSE od.taxsellamt + NVL(st.ARIGHT, 0) END ) taxsellamt
FROM vw_odmast_all od, vw_stschd_all st, afmast af, cfmast cf,aftype, odtype, sbsecurities sb, (SELECT * FROM sbbatchsts bs WHERE bs.bchmdl = 'ODFEECAL') bs
WHERE od.deltd <> 'Y' AND OD.TXDATE = bs.bchdate(+)
AND OD.ORDERID = ST.ORGORDERID AND ST.DUETYPE IN ('RM', 'RS') AND ST.DELTD = 'N'
AND od.afacctno = af.acctno
AND af.custid = cf.custid
AND af.actype = aftype.actype
AND odtype.actype = od.actype
AND od.codeid = sb.codeid
AND od.txdate >= TO_DATE(F_DATE,'DD/MM/YYYY')
AND od.txdate <= TO_DATE(T_DATE,'DD/MM/YYYY')
AND CF.CUSTODYCD LIKE V_STRCUSTOCYCD
AND AF.ACCTNO LIKE V_STRACCTNO
AND AF.COREBANK LIKE V_STRCOREBANK
AND AF.BANKNAME LIKE V_STRBANKCODE
AND cf.custtype LIKE V_CUSTTYPE
AND af.careby LIKE V_CAREBY
AND   (SUBSTR(af.acctno,1,4) like  V_STRBRID or instr(V_STRBRID,SUBSTR(af.acctno,1,4)) <> 0)
GROUP BY cf.fullname, cf.custodycd, af.acctno
HAVING sum(od.execamt) > 0
ORDER BY cf.fullname, cf.custodycd
) a
left join
(  select g.autoid, g.fullname,g.custid g_custid, r.afacctno, r.reacctno, substr(r.reacctno,1,10) recustid, cf.fullname mrkname
    from reaflnk r, retype rt, regrplnk gl, regrp g, recfdef cd, recflnk cl, cfmast cf
    where  substr(r.reacctno,11,4) = rt.actype and rt.rerole in ('BM','RM')
    and gl.reacctno = r.reacctno and g.autoid = gl.refrecflnkid  and cf.custid = cl.custid
    and cd.refrecflnkid = cl.autoid and r.reacctno = cl.custid || cd.reactype
    and TO_DATE(T_DATE,'DD/MM/YYYY') between r.frdate and nvl(r.clstxdate -1, r.todate)
    and TO_DATE(T_DATE,'DD/MM/YYYY') between cd.effdate and nvl(cd.closedate -1, cd.expdate)
    and TO_DATE(T_DATE,'DD/MM/YYYY') between gl.frdate and nvl(gl.clstxdate -1 , gl.todate)
    and TO_DATE(T_DATE,'DD/MM/YYYY') between g.effdate and g.expdate
) re
on a.acctno = re.afacctno
left join
(  select r.afacctno, r.reacctno, substr(r.reacctno,1,10) dsfcustid, cf.fullname dsfname
    from reaflnk r, retype rt, recfdef cd, recflnk cl, cfmast cf
    where  substr(r.reacctno,11,4) = rt.actype and rt.rerole in ('RD')
    and cf.custid = cl.custid
    and cd.refrecflnkid = cl.autoid and r.reacctno = cl.custid || cd.reactype
    and TO_DATE(T_DATE,'DD/MM/YYYY') between r.frdate and nvl(r.clstxdate -1, r.todate)
    and TO_DATE(T_DATE,'DD/MM/YYYY') between cd.effdate and nvl(cd.closedate -1, cd.expdate)

) dsf
on a.acctno = dsf.afacctno
WHERE (case when V_REGRPID = '%' then '%' else to_char(re.autoid) end)  like V_REGRPID
and (case when V_RECUSTID = '%' then '%' else re.recustid end) like V_RECUSTID
ORDER BY a.custodycd
;



EXCEPTION
   WHEN OTHERS
   THEN

      RETURN;
End;
/

