CREATE OR REPLACE PROCEDURE se0030 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2,
   PV_BRANCH      in       varchar2,
    I_BRID         IN       VARCHAR2,
   CAREBY         IN       VARCHAR2

       )
IS


   V_STRAFACCTNO  VARCHAR2 (15);
   V_CUSTODYCD VARCHAR2 (15);
   V_TYPE  VARCHAR2(10);
   V_BRANCH   varchar2(100);
   V_FULLNAME varchar2(100);
   V_I_CUSTODYCD varchar2(10);
   V_I_BRID VARCHAR2(10);
   V_CAREBY VARCHAR2(10);

BEGIN
-- GET REPORT'S PARAMETERS


   IF  (PV_CUSTODYCD <> 'ALL')
   THEN
         V_CUSTODYCD := PV_CUSTODYCD;
   ELSE
        V_CUSTODYCD := '%';
   END IF;

/*
   IF  (LOWER(PV_TYPE) = 'tat toan')

   THEN
         V_TYPE := '2247' ;
   ELSE
         V_TYPE := '8815' ;
   END IF;
*/

   IF  (PV_AFACCTNO <> 'ALL')
   THEN
         V_STRAFACCTNO := PV_AFACCTNO;
   ELSE
      V_STRAFACCTNO := '%';
   END IF;

   select cdcontent into V_BRANCH from allcode where cdname = 'BRANCH' and cdval = PV_BRANCH;

   if (PV_CUSTODYCD <> 'ALL') or (PV_AFACCTNO <> 'ALL')
   then
      begin
          select DISTINCT fullname, custodycd into V_FULLNAME, V_I_CUSTODYCD from cfmast c, afmast a
          where c.custid = a.custid and a.acctno like V_STRAFACCTNO and c.custodycd like V_CUSTODYCD;
      exception when others then
          V_FULLNAME :='';
          V_I_CUSTODYCD := '';
      end;
   else
      V_FULLNAME:= ' ';
      V_I_CUSTODYCD:= 'ALL';
   end if;
  
IF  (I_BRID <> 'ALL')
   THEN
         V_I_BRID := I_BRID;
   ELSE
      V_I_BRID := '%';
   END IF;
   IF  (CAREBY <> 'ALL')
   THEN
         V_CAREBY := CAREBY;
   ELSE
      V_CAREBY := '%';
   END IF;

-- GET REPORT'S DATA
 OPEN PV_REFCURSOR
 FOR
SELECT
    (case when sb.tradeplace='002' then '01'--'1. HNX'
          when sb.tradeplace='001' then '02'--'2. HOSE'
          when sb.tradeplace='005' then '03'--'3. UPCOM' else '' end) san,
     END) orderid,-- '' danh_muc,
         --nvl(cf.fullname,'') fullname,
         --nvl(cf.idcode ,'')idcode,
         --nvl( cf.iddate ,'')iddate,
         --nvl(cf.custodycd,'') cfcustodycd,
         nvl(sb.symbol,'') codeid,
         --nvl(sb.parvalue ,'') Menh_gia,
         SUM(nvl(tl.msgamt,'')) sl_lole/*,
         PV_AFACCTNO  AFACCTNO,
         (case when substr(cf.custodycd,4,1)='F' then '01213.091' else '01212.091' end )  SO_TK_CO
         , V_BRANCH sento
         , PV_CUSTODYCD custodycd*/
  FROM   (
            SELECT a.txdate, a.txnum, substr(a.acctno,1,10) acctno, substr(a.acctno,11,6) codeid, a.acctno msgacct, a.qtty msgamt, a.price
            FROM seretail a
            WHERE a.log_8815_8816 = '8815'
                AND a.txdate_8815_8816 BETWEEN to_date(F_DATE,'DD/MM/RRRR') AND to_date(T_DATE,'DD/MM/RRRR')
           ) tl,
         afmast af,
         cfmast cf,
         sbsecurities sb,
         securities_info Se
 WHERE       tl.acctno = af.acctno
         AND af.custid = cf.custid
         and se.codeid = sb.codeid
         AND tl.codeid = sb.codeid
         AND sb.tradeplace IN ('001', '002', '005')
         AND Cf.CUSTODYCD LIKE V_CUSTODYCD
         AND tl.acctno LIKE V_STRAFACCTNO
         AND AF.BRID LIKE V_I_BRID
        AND AF.CAREBY LIKE V_CAREBY
GROUP BY    (case when sb.tradeplace='002' then '01'--'1. HNX'
          when sb.tradeplace='001' then '02'--'2. HOSE'
          when sb.tradeplace='005' then '03'--'3. UPCOM' else '' end) san,
          END) ,
         --nvl(cf.fullname,'') ,
         --nvl(cf.idcode ,''),
         --nvl( cf.iddate ,''),
         --nvl(cf.custodycd,''),
         nvl(sb.symbol,'')/*,
         nvl(sb.parvalue ,''),
         (case when substr(cf.custodycd,4,1)='F' then '01213.091' else '01212.091' end )*/
--ORDER BY nvl(sb.symbol,'')
         ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/
