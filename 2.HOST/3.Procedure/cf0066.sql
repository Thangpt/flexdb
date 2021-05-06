CREATE OR REPLACE PROCEDURE cf0066 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   F_OPNDATE      IN       VARCHAR2,
   T_OPNDATE      IN       VARCHAR2,
   GROUPID        IN       VARCHAR2
 )
IS

-- ---------   ------     -------------------------------------------
    V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID          VARCHAR2 (4);        -- USED WHEN V_NUMOPTION > 0
    V_INBRID     VARCHAR2 (5);
    V_GROUPID varchar2(10);
    V_DATE      DATE;
BEGIN

   V_STROPTION := upper(OPT);
   V_INBRID := BRID;

   if(V_STROPTION = 'A') OR V_INBRID IS NULL  then
        V_STRBRID := '%';
    else
        V_STRBRID := BRID;

    end if;

    IF GROUPID <> 'ALL' THEN
        V_GROUPID := GROUPID;
    ELSE V_GROUPID := '%';
    END IF;


 ---------------------------
OPEN PV_REFCURSOR
  FOR
SELECT F_DATE F_DATE, T_DATE T_DATE, cf.custodycd,MAX(af.acctno) acctno, cf.fullname,
cf.opndate,cf.email, cf.mobile, max( RE.DSF) DSF,max(re.RD)RD ,sum(NVL(IOD.AMT,0)) AMT,AL.CDCONTENT CLASS, min(OD.MIN_DATE) MIN_DATE,sum(NVL(se.GT_CP_sohuu,0)+NVL(ci.SO_DU_TIEN,0)-NVL(ci.no,0)) nav
 FROM (SELECT   cf.custodycd,cf.custid , cf.fullname, cf.opndate,cf.email, cf.mobile,cf.class, min(af.opndate) txdate FROM  cfmast cf, afmast af
       WHERE cf.custid = af.custid
       GROUP BY  cf.custodycd, cf.fullname, cf.opndate,cf.email, cf.mobile,cf.class ,cf.custid   )cf,

 allcode al ,
 (SELECT
    MAX(CASE WHEN retype.rerole ='RD' THEN  cfre.fullname ELSE '' END) DSF ,
    MAX(CASE WHEN retype.rerole ='BM' THEN  cfre.fullname ELSE '' END) RD ,
    af.custid--, REA.refrecflnkid
    FROM reaflnk rea ,cfmast cfre, retype , afmast af,regrplnk regrl
    WHERE  rea.status ='A'
    AND substr(rea.reacctno,1,10)=cfre.custid
    AND retype.actype = substr(rea.reacctno,11)
    AND retype.rerole IN ('BM','RD')
    AND( CASE WHEN rerole='BM' THEN   NVL( regrl.refrecflnkid,'999999') else to_number(V_GROUPID) end ) LIKE  V_GROUPID
   AND  rea.reacctno = regrl.reacctno(+)
    AND REA.AFACCTNO = AF.ACCTNO
    GROUP BY af.custid
    having  MAX(CASE WHEN retype.rerole ='BM' THEN  cfre.fullname ELSE '' END) is not null) RE ,

    (
        SELECT SUM( execamt ) AMT, AFACCTNO FROM vw_odmast_all
        WHERE   TXDATE  between TO_DATE (F_DATE, 'DD/MM/YYYY') and TO_DATE (T_DATE, 'DD/MM/YYYY') AND DELTD <>'Y'
        GROUP BY AFACCTNO

    )IOD

    ,(SELECT MIN ( TXDATE) MIN_DATE, AFACCTNO
      FROM VW_ODMAST_ALL WHERE txdate between TO_DATE (F_OPNDATE, 'DD/MM/YYYY') and TO_DATE (T_OPNDATE, 'DD/MM/YYYY') AND execamt>0 GROUP BY AFACCTNO ) OD
      , AFMAST AF,
--      ,(SELECT navaccount + outstanding nav,afacctno FROM v_getsecmarginratio_all)CI
    (
    select v.afacctno, v.custodycd
        , sum(case when sb.sectype in ('001', '002', '008', '111') then v.realass else 0 end) GT_CP_sohuu
        --, sum(REALASS) GT_CP_sohuu--sum(ts_t2) GT_CP_sohuu
    from vw_mr9004 v, sbsecurities sb where v.codeid = sb.codeid group by afacctno, custodycd
    ) se,
     (
     select cf.custodycd, cf.custid, cf.fullname , cf.email, nvl(cf.mobile, cf.phone), ci.afacctno,
            sum(nvl(ci.balance,0))  TIEN_MAT, -- tong tien
            sum(nvl(ci.depofeeamt,0)) PHI_LK, --no phi luu ky
             sum(nvl(vlad.depoamt,0)) UTTB,
             sum(nvl(ln.t0amt,0)) NO_BL, -- No bao lanh
             sum(nvl(marginamt,0)) NO_CL, -- no CL
             sum(nvl(ci.balance,0)) +  sum(nvl(vlad.depoamt,0)) + sum(nvl(vlad.aamt,0))/* + sum(nvl(adv.amt,0))*/ SO_DU_TIEN,
              sum(nvl(ci.depofeeamt,0)) + sum(nvl(ln.t0amt,0)) +   sum(nvl(marginamt,0)) + sum(nvl(adv.amt,0))  NO
    from cimast ci, v_getaccountavladvance vlad , vw_lngroup_all ln, cfmast cf, afmast af
        , ( --du no UTTB
             SELECT  ACCTNO
                , SUM(NVL(ADS.AMT, 0) + NVL(ADS.FEEAMT, 0)- (case when getcurrdate >= ads.cleardt then ads.paidamt else 0 end)) AMT
            FROM   VW_ADSCHD_ALL ADS
            WHERE     (ADS.AMT > 0   OR   ADS.PAIDDATE = getcurrdate ) --V_CRRDATE
                AND    ADS.txdate     <=   getcurrdate
            GROUP  BY  ACCTNO
            ) adv
    where ci.afacctno = vlad.afacctno (+)
    and ci.afacctno = ln.trfacctno (+)
    and ci.afacctno = adv.acctno (+)
    and af.custid = cf.custid  and ci.afacctno = af.acctno
    /*and nvl(cf.opndate,'01/01/1999') BETWEEN to_date(O_DATE,'DD/MM/RRRR') and to_date(C_DATE,'DD/MM/RRRR')
    AND (substr(cf.custid,1,4) LIKE V_STRBRID  OR instr(V_STRBRID,substr(cf.custid,1,4))<> 0)*/
    group by  cf.custodycd, cf.custid, cf.fullname , cf.email, nvl(cf.mobile, cf.phone), ci.afacctno
     )ci
    WHERE CF.CUSTID =  RE.CUSTID
    AND AF.ACCTNO = IOD.AFACCTNO(+)
    AND  AF.ACCTNO=OD.AFACCTNO(+)
    AND AF.ACCTNO = CI.afACCTNO(+)
    AND AF.ACCTNO = se.afACCTNO(+)
    AND AF.CUSTID=RE.CUSTID
    AND cf.txdate between TO_DATE (F_OPNDATE, 'DD/MM/YYYY') and TO_DATE (T_OPNDATE, 'DD/MM/YYYY')
    AND cf.class = al.cdval
    AND al.cdname ='CLASS'
    AND al.cdtype = 'CF'
   and substr(re.custid,1,4) like V_STRBRID
   GROUP BY  cf.custodycd, cf.fullname, cf.opndate,cf.email, cf.mobile,AL.CDCONTENT
   having sum(NVL(se.GT_CP_sohuu,0)+NVL(ci.SO_DU_TIEN,0)-NVL(ci.no,0))+sum(NVL(IOD.AMT,0)) >0
;


EXCEPTION
   WHEN OTHERS
   THEN

      RETURN;
End;
/

