CREATE OR REPLACE PROCEDURE se0076 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2

 )
IS
--Tong hop phi chuyen khoan - chuyen khoan tat toan tk
--created by Chaunh at 07/05/2012

    V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID     VARCHAR2 (5);
    VF_DATE DATE;
    VT_DATE DATE;

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

   ------------------------
   VF_DATE := to_date(F_DATE,'DD/MM/RRRR');
   VT_DATE := to_date(T_DATE,'DD/MM/RRRR');



OPEN PV_REFCURSOR FOR

SELECT cf.fullname, cf.custodycd,
        CASE WHEN cf.custtype = 'I' AND substr(cf.custodycd,4,1) = 'F' THEN 'Ca nhan nuoc ngoai'
             WHEN cf.custtype = 'B' AND substr(cf.custodycd,4,1) = 'F' THEN 'To chuc nuoc ngoai'
             WHEN cf.custtype = 'I' AND substr(cf.custodycd,4,1) = 'C' THEN 'Ca nhan trong nuoc'
             WHEN cf.custtype = 'B' AND substr(cf.custodycd,4,1) = 'C' THEN 'To chuc trong nuoc'
             WHEN substr(cf.custodycd,4,1) = 'P' THEN 'Tu doanh'
        END loai_hinh,
        sum(least(feemaster.feeamt*msgamt,feemaster.maxval)) phi
FROM vw_tllog_all tl, cfmast cf , afmast af, feemap, feemaster
WHERE tl.tltxcd = '2248' AND tl.deltd <> 'Y'
AND substr(tl.msgacct,1,10) = af.acctno
AND cf.custatcom = 'Y'
AND af.custid = cf.custid
AND '2247' = feemap.tltxcd
and feemap.feecd = feemaster.feecd
AND (substr(cf.custid,1,4) LIKE V_STRBRID OR instr(V_STRBRID,substr(cf.custid,1,4))<> 0)
AND tl.busdate <= VT_DATE AND tl.busdate >= VF_DATE
GROUP BY cf.fullname, cf.custodycd,
        CASE WHEN cf.custtype = 'I' AND substr(cf.custodycd,4,1) = 'F' THEN 'Ca nhan nuoc ngoai'
             WHEN cf.custtype = 'B' AND substr(cf.custodycd,4,1) = 'F' THEN 'To chuc nuoc ngoai'
             WHEN cf.custtype = 'I' AND substr(cf.custodycd,4,1) = 'C' THEN 'Ca nhan trong nuoc'
             WHEN cf.custtype = 'B' AND substr(cf.custodycd,4,1) = 'C' THEN 'To chuc trong nuoc'
             WHEN substr(cf.custodycd,4,1) = 'P' THEN 'Tu doanh'
        END
;
EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
End;
/

