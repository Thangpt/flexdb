CREATE OR REPLACE PROCEDURE "SE0050" (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   PV_BRID        IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2
)
IS

-- RP NAME : BAO CAO BANG KE CHUNG KHOAN CHUYEN KHOAN MOT PHAN
-- PERSON --------------DATE---------------------COMMENTS
-- VUNGUYENVAN 30/07/2015
-- ---------   ------  -------------------------------------------
   V_STRAFACCTNO  VARCHAR2 (15);
   V_CUSTODYCD VARCHAR2 (15);
   V_TYPE  VARCHAR2(10);
   V_FROMDATE DATE;
   V_TODATE DATE;
   V_CURRDATE date;
   v_flag number(2,0);
   V_INBRID        VARCHAR2(4);
   V_STRBRID      VARCHAR2 (50);
   V_STROPTION    VARCHAR2(5);

BEGIN
-- GET REPORT'S PARAMETERS
   V_STROPTION := upper(OPT);
   V_INBRID := PV_BRID;
    if(V_STROPTION = 'A') then
        V_STRBRID := '%%';
    else
        if(V_STROPTION = 'B') then
            select br.brid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := V_INBRID;
        end if;
    end if;


    V_CUSTODYCD := upper( PV_CUSTODYCD);
    select to_date(varvalue,'DD/MM/RRRR') into V_CURRDATE
     from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM';


   IF  (PV_AFACCTNO <> 'ALL')
   THEN
         V_STRAFACCTNO := PV_AFACCTNO;
   ELSE
         V_STRAFACCTNO := '%';
   END IF;

     V_FROMDATE := TO_DATE(F_DATE, 'DD/MM/RRRR');
     V_TODATE := TO_DATE(T_DATE, 'DD/MM/RRRR');

-- GET REPORT'S DATA
 OPEN PV_REFCURSOR
 FOR
SELECT FULLNAME, CUSTODYCD, ACCTNO,SYMBOL, IDCODE, IDDATE,IDPLACE, ADDRESS,MOBILE,max(RECUSTODYCD) RE_CUSTODYCD,max(RECUSTNAME) RE_CUSTNAME,outward,
       SUM(TRADE) TRADE, SUM(BLOCKED) BLOCKED,parvalue,LOAI_CK,SAN,DEPOSITNAME
FROM(
       SELECT distinct CF.CUSTODYCD, CF.FULLNAME , AF.ACCTNO , SB2.SYMBOL SYMBOL,CF.IDCODE, CF.IDDATE,CF.IDPLACE,CF.ADDRESS,
               NVL(CF.MOBILE,'') MOBILE,OU.RECUSTODYCD, (OU.RECUSTNAME) RECUSTNAME, OU.outward,
                strade  TRADE,
                sblocked  BLOCKED, SB.parvalue,
               CASE WHEN SB.REFCODEID IS NULL THEN  'TD' ELSE 'WAIT'END LOAI_CK,
                ( CASE when sb2.markettype='006' and sb2.sectype in ('003','006','222','333','444')
                  then 'D. TRÁI PHIÊU CHUYÊN BI?T'
                    else
                      ( case
                            when sb2.tradeplace='002' then 'A. HNX'
                            when sb2.tradeplace='001' then 'B. HOSE'
                            when sb2.tradeplace='005' then 'C. UPCOM'
                            when sb2.tradeplace='004' then 'F. TRÁI PHI?U NGO?I T?'
                            when sb2.tradeplace='008' then 'E. TÍN PHI?U'
                            when sb2.tradeplace='009' then 'G. ÐCCNY'
                            else ''END)end ) SAN,
                    MEM.FULLNAME DEPOSITNAME

        FROM SESENDOUT OU,  cfmast CF, AFMAST AF, sbsecurities SB, sbsecurities SB2, deposit_member MEM,
             VW_TLLOGFLD_ALL FLD
        WHERE OU.DELTD <> 'Y'
              AND CF.CUSTID = AF.CUSTID
              AND SUBSTR(OU.ACCTNO,1,10) = AF.ACCTNO
              AND OU.CODEID = SB.CODEID
              AND OU.TXDATE=FLD.TXDATE
              AND OU.TXNUM=FLD.TXNUM
              and OU.TXDATE <= V_TODATE AND  OU.TXDATE >= V_FROMDATE
              AND OU.DELTD<>'Y'
              AND NVL(SB.refcodeid,SB.codeid) = SB2.CODEID
              AND OU.outward = MEM.depositid (+)
              --AND OU.ID2255 IS NULL
              AND CF.CUSTODYCD = V_CUSTODYCD
              AND AF.ACCTNO LIKE V_STRAFACCTNO
              AND  STRADE + SBLOCKED > 0

)
GROUP BY FULLNAME, CUSTODYCD, ACCTNO,SYMBOL, IDCODE, IDDATE,IDPLACE, ADDRESS,MOBILE,outward,
       parvalue,LOAI_CK,SAN,DEPOSITNAME
ORDER BY SYMBOL
 ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

