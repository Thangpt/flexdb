CREATE OR REPLACE PROCEDURE od0014 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   TLID           IN       VARCHAR2,
   careby           IN       VARCHAR2
   )
IS
-- MODIFICATION HISTORY
-- KET QUA KHOP LENH CUA KHACH HANG
-- PERSON      DATE    COMMENTS
-- NAMNT   15-JUN-08  CREATED
-- DUNGNH  08-SEP-09  MODIFIED
-- ---------   ------  -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID          VARCHAR2 (40);    -- USED WHEN V_NUMOPTION > 0
    V_INBRID     VARCHAR2 (5);           -- USED WHEN V_NUMOPTION > 0
   V_TLID           VARCHAR2 (5);
   v_strcareby       VARCHAR2 (10);



-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
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
   v_strcareby := careby;


    -- GET REPORT'S PARAMETERS
   --
    IF (nvl(TLID,'ALL') <> 'ALL')
   THEN
      V_TLID := TLID;
   ELSE
      V_TLID := '%';
   END IF;
   --


   -- GET REPORT'S DATA

IF(v_strcareby = '0001') THEN
 OPEN PV_REFCURSOR
       FOR
         select Sum(od.feeacr) fee,sum(od.execamt) amt ,cf.custodycd, cf.fullname
         from  vw_odmast_all od ,cfmast cf , afmast af, sbsecurities sb, tlgrpusers tl
         where od.afacctno = af.acctno and af.custid = cf.custid and od.codeid = sb.codeid
              and od.deltd <>'Y' and od.execamt <> 0
              and od.txdate >=to_date(F_DATE,'dd/mm/yyyy') and od.txdate <=to_date(T_DATE,'dd/mm/yyyy')
               AND (substr(af.acctno,1,4) LIKE V_STRBRID OR instr(V_STRBRID,substr(af.acctno,1,4))<> 0)
              and tl.grpid = af.careby
              and tl.TLID like V_TLID
        group by cf.custodycd, cf.fullname;
ELSE
OPEN PV_REFCURSOR
       FOR
         select Sum(od.feeacr) fee,sum(od.execamt) amt ,cf.custodycd, cf.fullname
         from  vw_odmast_all od ,cfmast cf , afmast af, sbsecurities sb, tlgrpusers tl
         where od.afacctno = af.acctno and af.custid = cf.custid and od.codeid = sb.codeid
              and od.deltd <>'Y' and od.execamt <> 0
              and od.txdate >=to_date(F_DATE,'dd/mm/yyyy') and od.txdate <=to_date(T_DATE,'dd/mm/yyyy')
              and tl.grpid = af.careby
               AND (substr(af.acctno,1,4) LIKE V_STRBRID OR instr(V_STRBRID,substr(af.acctno,1,4))<> 0)
              and tl.TLID like v_strcareby
        group by cf.custodycd, cf.fullname;
END IF;


EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

