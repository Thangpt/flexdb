CREATE OR REPLACE PROCEDURE ci0013 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2

 )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- BAO CAO TIEN LAI CUA NGUOI DAU TU
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- HUYNQ
-- ---------   ------  -------------------------------------------
   V_STROPTION     VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID       VARCHAR2 (4);                   -- USED WHEN V_NUMOPTION > 0


BEGIN
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A')AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   -- GET REPORT'S PARAMETERS


   -- END OF GETTING REPORT'S PARAMETERS

 OPEN PV_REFCURSOR
       FOR
   -- GET REPORT'S DATA
 SELECT tl.Txnum , RM.BENEFBANK,RM.BENEFACCT, rm.acctno, tl.txdate, tl.txdesc,rm.amt ,tlf.cvalue BENEFCUSTNAME,cf.fullname,cf.custodycd
FROM  CIREMITTANCE RM , cfmast cf, afmast af,
      (SELECT * FROM tllog WHERE deltd <> 'Y' AND tltxcd = '1101'
                           AND txdate  >= to_date(F_DATE ,'dd/MM/RRRR')
                           AND txdate  <= to_date(T_DATE,'dd/MM/RRRR')
              UNION ALL
       SELECT * FROM tllogall WHERE deltd <> 'Y' AND tltxcd = '1101'
                           AND txdate  >= to_date(F_DATE,'dd/MM/RRRR')
                           AND txdate  <= to_date(T_DATE,'dd/MM/RRRR')
      ) tl,
      ( select * from tllogfld WHERE fldcd='82'
                 and txdate >= to_date(F_DATE,'dd/MM/RRRR')
                 AND txdate <= to_date(T_DATE,'dd/MM/RRRR')
         UNION ALL
         select * from tllogfldall WHERE fldcd='82'
                 and txdate >= to_date(F_DATE,'dd/MM/RRRR')
                 AND txdate <= to_date(T_DATE,'dd/MM/RRRR')
      ) tlf
WHERE rm.rmstatus ='C'
    AND substr(RM.acctno,1,4)= '0001'
   -- and  substr(af.acctno,1,4) LIKE  V_STRBRID
    AND af.acctno = rm.acctno
    AND tl.txnum = rm.txnum
    AND tl.txdate = rm.txdate
    AND tl.txnum = tlf.txnum
    AND tl.txdate = tlf.txdate
    AND cf.custid = af.custid

ORDER BY tl.Txnum;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

