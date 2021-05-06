CREATE OR REPLACE PROCEDURE od0051(
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2

   )
IS
-- MODIFICATION HISTORY
-- KET QUA KHOP LENH CUA KHACH HANG
-- PERSON   DATE  COMMENTS
-- HUYNQ  08-SEP-09  CREATED
-- HUNGLB 01-Oct-10  UPDATED
-- HUONG.TTD 02-DEC-10 UPDATED
-- ---------   ------  -------------------------------------------
   V_STROPTION      VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID         VARCHAR2 (4);
   v_I_DATE          DATE;
   v_I_DATE1          DATE;
   v_I_DATE2          DATE;
   v_I_DATE3          DATE;
BEGIN
   V_STROPTION := upper(OPT);
   V_INBRID := BRID;

   IF (V_STROPTION = 'A') THEN
      V_STRBRID := '%';
   ELSE if (V_STROPTION = 'B') THEN
            select brgrp.mapid into V_STRBRID from brgrp where brgrp.brid = V_INBRID;
        else
            V_STRBRID := V_INBRID;
        end if;
   END IF;



 v_I_DATE  := to_date(I_DATE,'DD/MM/YYYY');
  v_I_DATE1  := get_t_date(v_I_DATE,1);
  v_I_DATE2  := get_t_date(v_I_DATE,2);
   v_I_DATE3  := get_t_date(v_I_DATE,3);
    -- GET REPORT'S PARAMETERS
   --
-- Get Current Date
OPEN PV_REFCURSOR
       FOR

       SELECT clearday ,tradeplace ,TYPEKH ,SUM(T0) , SUM(T1),SUM(T2),SUM(T3), SUM( bamt0) bamt0 , SUM(samt0) samt0,
        SUM( bamt1) bamt1, SUM(samt1) samt1 ,SUM( bamt2) bamt2, SUM(samt2) samt2 ,SUM( bamt3) bamt3, SUM(samt3) samt3,trc.cdcontent,
        v_I_DATE date0 ,v_I_DATE1 date1,v_I_DATE2 date2,v_I_DATE3 date3
 FROM
(
    select SUBSTR(custodycd,4,1) TYPEKH ,tradeplace ,clearday , SUM(T0)T0 ,SUM(T1)T1 ,SUM(T2) T2 ,SUM(T3) T3
    , SUM( bamt0) bamt0, SUM(samt0) samt0,
    SUM( bamt1) bamt1, SUM(samt1) samt1,SUM( bamt2) bamt2, SUM(samt2)samt2,SUM( bamt3)bamt3, SUM(samt3)samt3

    from
    (
    select cf.custodycd,sb.tradeplace ,amt t0,0 t1 , 0 t2 , 0 t3,
    --(CASE WHEN sts.duetype = 'SM'THEN amt/1000 ELSE 0 END ) bamt0,
    (CASE WHEN sts.duetype = 'RS'THEN amt/1000 ELSE 0 END ) bamt0,
    (CASE WHEN sts.duetype = 'RM'THEN amt/1000 ELSE 0 END ) samt0,
    0 bamt1, 0 samt1, 0 bamt2, 0 samt2, 0 bamt3, 0 samt3
    ,sts.clearday,--od.clearday,
    sts.txdate txdate
    from (select * from stschd union all select * from stschdhist where txdate = v_I_DATE  and duetype in  ('RM', 'RS')/* Huong.ttd added where clause */
    ) sts,--vw_odmast_all od,
    sbsecurities sb,afmast af , cfmast cf
    where sts.codeid= sb.codeid and sts.afacctno =af.acctno and  af.custid= cf.custid
    and sts.txdate = v_I_DATE and custatcom = 'Y'
    and (af.brid like V_STRBRID or INSTR(V_STRBRID,af.brid) <> 0)
    --and sts.duetype in  ('RM', 'SM')
    and sts.duetype in  ('RM', 'RS')
    and SUBSTR(custodycd,4,1) in ('P','F','C')
    and sts.clearday IN (1,3)
    --and od.ORDERID = sts.orgorderid

 union ALL

    select cf.custodycd,sb.tradeplace ,amt t0,0 t1 , 0 t2 , 0 t3 ,
    0 bamt1, 0 samt1,
    (CASE WHEN sts.duetype = 'RS'THEN amt/1000 ELSE 0 END ) bamt1,
    (CASE WHEN sts.duetype = 'RM'THEN amt/1000 ELSE 0 END ) samt1,
    0 bamt2, 0 samt2, 0 bamt3, 0 samt3
    ,sts.clearday, v_I_DATE1  txdate
    from (select * from stschd union all select * from stschdhist where txdate = v_I_DATE1--get_t_date(v_I_DATE,1)
    and duetype in  ('RM', 'RS')/* Huong.ttd added where clause */ ) sts,
    --vw_odmast_all od,
    sbsecurities sb,afmast af , cfmast cf
    where sts.codeid= sb.codeid and sts.afacctno =af.acctno and  af.custid= cf.custid
     and sts.txdate = v_I_DATE1--get_t_date(v_I_DATE,1)
     and custatcom = 'Y'
     and (af.brid like V_STRBRID or INSTR(V_STRBRID,af.brid) <> 0)
     and SUBSTR(custodycd,4,1) in ('P','F','C')
    and sts.duetype in  ('RM', 'RS')
    and sts.clearday IN (1,3)
    --and od.ORDERID = sts.orgorderid

union all
    select cf.custodycd,sb.tradeplace ,0 t0,0 t1 , amt t2 , 0 t3 ,
    0 bamt0, 0 samt0,0 bamt1, 0 samt1,
    (CASE WHEN sts.duetype = 'RS'THEN amt/1000 ELSE 0 END ) bamt2,
    (CASE WHEN sts.duetype = 'RM'THEN amt/1000 ELSE 0 END ) samt2,
    0 bamt3, 0 samt3
    ,sts.clearday, v_I_DATE2 txdate
    from (select * from stschd union all select * from stschdhist where txdate = v_I_DATE2--get_t_date(v_I_DATE,2)
    and duetype in  ('RM', 'RS')/* Huong.ttd added where clause */ ) sts,
    --vw_odmast_all od,
    sbsecurities sb,afmast af , cfmast cf
    where sts.codeid= sb.codeid and sts.afacctno =af.acctno and  af.custid= cf.custid
     and sts.txdate  = v_I_DATE2--get_t_date(v_I_DATE,2)
     and custatcom = 'Y'
     and (af.brid like V_STRBRID or INSTR(V_STRBRID,af.brid) <> 0)
    and sts.duetype in  ('RM', 'RS')
     and SUBSTR(custodycd,4,1) in ('P','F','C')
      and sts.clearday IN (1,3)
      --and od.ORDERID = sts.orgorderid
union all
    select cf.custodycd,sb.tradeplace ,0 t0,0 t1 , 0 t2 , amt t3  ,
    0 bamt0, 0 samt0,0 bamt1, 0 samt1,0 bamt2, 0 samt2,
    (CASE WHEN sts.duetype = 'RS'THEN amt/1000 ELSE 0 END ) bamt3,
    (CASE WHEN sts.duetype = 'RM'THEN amt/1000 ELSE 0 END ) samt3,
    sts.clearday,  v_I_DATE3 txdate
    from (select * from stschd union all select * from stschdhist where txdate = v_I_DATE3--get_t_date(v_I_DATE,3)
    and duetype in  ('RM', 'RS') /* Huong.ttd added where clause */ ) sts,
    --vw_odmast_all od,
    sbsecurities sb,afmast af , cfmast cf
    where sts.codeid= sb.codeid and sts.afacctno =af.acctno and  af.custid= cf.custid
    and sts.txdate = v_I_DATE3--get_t_date(v_I_DATE,3)
    and custatcom = 'Y'
    and (af.brid like V_STRBRID or INSTR(V_STRBRID,af.brid) <> 0)
    and sts.duetype in  ('RM', 'RS')
    and SUBSTR(custodycd,4,1) in ('P','F','C')
    and sts.clearday IN (1,3)
    --and od.ORDERID = sts.orgorderid
)
GROUP  BY clearday, custodycd,tradeplace ) od, allcode trc
where trc.cdname ='TRADEPLACE' and trc.cdtype='OD' and trc.cdval= od.tradeplace

GROUP BY clearday,tradeplace,trc.cdcontent ,TYPEKH

ORDER BY clearday DESC ,tradeplace,trc.cdcontent ,TYPEKH;


EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

