-- Start of DDL Script for Procedure HOSTMSTRADE.SE0028
-- Generated 11/04/2017 2:35:23 PM from HOSTMSTRADE@FLEX_111

CREATE OR REPLACE 
PROCEDURE se0028 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_SYMBOL         IN       VARCHAR2
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
SELECT T.*, BRID branchID FROM
(
SELECT
         nvl(A2.cdcontent ,'') san,
         nvl(cf.fullname,'') fullname,
         nvl(cf.custodycd,'') custodycd,
         nvl(cf.idcode ,'')idcode,
         nvl(cf.iddate ,'')iddate,
          (Case when A1.cdval='001' then '1'
              when A1.cdval='005' then '3'
           else '4' end
         ) IDTYPE,
         nvl(sb.symbol,'') codeid,
         nvl(iss.fullname,'') CK_Name,
         Sum(nvl(tl.msgamt,'')) So_luong,
         nvl(sb.PARVALUE,'') Menh_gia,
         tl.type type, tl.securitiestype sectype,
         nvl(PV_SYMBOL,'') PV_SYMBOL
  FROM   (
            SELECT   txdate ,afacctno acctno ,nvl(sb.refcodeid,sb.codeid)codeid ,withdraw  msgamt ,
                    (case when sb.refcodeid is null then '1' else '7' end  ) TYPE,
                    (CASE WHEN sb.sectype IN ('001','002','011') THEN 'Co phieu'
                          WHEN sb.sectype IN ('003','006') THEN 'Trai phieu'
                          WHEN sb.sectype IN ('007','008') THEN 'Chung chi'
                          ELSE ' ' END) securitiestype
            From
            sewithdrawdtl , sbsecurities sb where sewithdrawdtl.codeid=sb.codeid and txdatetxnum in
                (
                 Select msgacct from  tLlog
                  WHERE tltxcd = '2292'
                     AND txdate >= TO_DATE (f_date, 'DD/MM/YYYY')
                     AND txdate <= TO_DATE (t_date, 'DD/MM/YYYY')
                 Union all
                 Select msgacct from  tLlogALl
                  WHERE       tltxcd = '2292'
                      AND txdate >= TO_DATE (f_date, 'DD/MM/YYYY')
                      AND txdate <= TO_DATE (t_date, 'DD/MM/YYYY')
                )
        ) tl, afmast af, cfmast cf, sbsecurities sb, issuers iss, ALLCODE A1, ALLCODE A2
 WHERE       tl.acctno = af.acctno
         AND af.custid = cf.custid
         AND tl.codeid = sb.codeid
         AND sb.tradeplace IN ('001', '002', '005')
         AND A1.CDTYPE = 'CF' AND A1.CDNAME = 'IDTYPE'
         AND A1.CDVAL = CF.IDTYPE
         AND iss.issuerid = sb.issuerid
         AND A2.CDTYPE = 'SE' AND A2.CDNAME = 'TRADEPLACE'
         AND A2.CDVAL = sb.tradeplace
         AND sb.tradeplace = A2.cdval
         and (af.brid like V_STRBRID or INSTR(V_STRBRID,af.brid) <> 0)
         AND Cf.CUSTODYCD LIKE V_CUSTODYCD
         AND sb.symbol    LIKE V_SYMBOL
        -- AND sb.tradeplace = PV_TRADEPLACE
        Group BY A2.cdcontent,cf.fullname,cf.custodycd,cf.idcode ,cf.iddate ,A1.cdval,sb.symbol,iss.fullname,sb.PARVALUE,
            tl.TYPE, tl.securitiestype
) T
 ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/



-- End of DDL Script for Procedure HOSTMSTRADE.SE0028

