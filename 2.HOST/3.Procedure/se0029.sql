CREATE OR REPLACE PROCEDURE se0029 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_SYMBOL      IN       VARCHAR2
       )
IS

-- RP NAME : Danh sach nguoi so huu de nghi luu ky chung khoan
-- PERSON : QUYET.KIEU
-- DATE : 13/02/2011
-- COMMENTS : CREATE NEW
-- ---------   ------  -------------------------------------------

   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (40);        -- USED WHEN V_NUMOPTION > 0
   V_INBRID           VARCHAR2 (4);

   V_SYMBOL  VARCHAR2 (15);
   V_CUSTODYCD VARCHAR2 (15);
BEGIN
-- GET REPORT'S PARAMETERS
   V_STROPTION := upper(OPT);
   V_INBRID := BRID;
   IF (V_STROPTION = 'A') AND (V_INBRID  = '0001')
   THEN
        V_STRBRID := '%';
   ELSE if V_STROPTION = 'B' then
        select brgrp.mapid into V_STRBRID from brgrp where brgrp.brid = V_INBRID;
        else
        V_STRBRID := V_INBRID;
        end if;
   END IF;


   IF  (PV_CUSTODYCD <> 'ALL')
   THEN
         V_CUSTODYCD := PV_CUSTODYCD;
   ELSE
        V_CUSTODYCD := '%';
   END IF;


   IF  (PV_SYMBOL <> 'ALL')
   THEN
         V_SYMBOL := PV_SYMBOL;
   ELSE
      V_SYMBOL := '%';
   END IF;

-- GET REPORT'S DATA
 OPEN PV_REFCURSOR
 FOR
 Select TB.* ,BRID branchID from
    (
    SELECT
         nvl(A2.cdcontent ,'') san,
         nvl(  cf.fullname,'') fullname,
         nvl(cf.custodycd,'') custodycd,
         nvl(cf.idcode ,'')idcode,
         nvl( cf.iddate ,'')iddate,
        (Case when A1.cdval='001' then '1'
              when A1.cdval='005' then '3'
           else '4' end )IDTYPE ,
         nvl(sb.symbol,'') codeid,
         nvl(iss.fullname,'') CK_Name,
         Sum(nvl(tl.msgamt,'')) So_luong,
         tl.type ,
         nvl(sb.PARVALUE,'') Menh_gia,
         nvl(PV_SYMBOL,'') PV_SYMBOL

    FROM (
       select tr.txdate, tr.afacctno acctno,
            tr.codeid codeid, tr.namt msgamt,
            (case when sb.refcodeid is null then '1' else '7' end  ) type
       from vw_setran_gen tr, sbsecurities sb
       where tr.tltxcd = '2293'
            AND tr.txcd = '0045'
            and tr.codeid = sb.codeid
            AND tr.txdate >= TO_DATE (f_date, 'DD/MM/YYYY')
            AND tr.txdate <= TO_DATE (t_date, 'DD/MM/YYYY')

    ) tl, afmast af,
         cfmast cf,
         sbsecurities sb,
         issuers iss,
         ALLCODE A1,
         ALLCODE A2
 WHERE tl.acctno = af.acctno
         AND af.custid = cf.custid
         AND tl.codeid = sb.codeid
         AND sb.tradeplace IN ('001', '002', '005')
         -----------------
         AND A1.CDTYPE = 'CF' AND A1.CDNAME = 'IDTYPE'
         AND A1.CDVAL = CF.IDTYPE
         AND iss.issuerid = sb.issuerid
         AND A2.CDTYPE = 'SE' AND A2.CDNAME = 'TRADEPLACE'
         AND A2.CDVAL = sb.tradeplace
         AND sb.tradeplace = A2.cdval
         AND Cf.CUSTODYCD LIKE V_CUSTODYCD
         and (af.brid like V_STRBRID or INSTR(V_STRBRID,af.brid) <> 0)
         AND sb.symbol    LIKE V_SYMBOL
         --AND sb.tradeplace = PV_TRADEPLACE
        group by A2.cdcontent ,cf.fullname,cf.custodycd, cf.idcode,cf.iddate,A1.cdval,sb.symbol,iss.fullname,
                sb.PARVALUE,tl.type, PV_SYMBOL
 ) TB
      ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

