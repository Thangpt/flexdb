CREATE OR REPLACE FORCE VIEW V_FO_AD AS
SELECT atd.quoteid, SUM(CASE WHEN subside IN ('NB','NS')  THEN   NVL(o.cancel_qtty,0) ELSE 0 END  ) cancel_qtty,
                                     SUM(CASE WHEN subside IN ('NB','NS')  THEN   NVL(o.exec_qtty,0) ELSE 0 END  )  exec_qtty,
                                     SUM(CASE WHEN subside IN ('NB','NS')  THEN   NVL(o.quote_qtty,0) ELSE 0 END  )  quote_qtty,
                                     max(o.time_created) activetime
                 FROM
                   active_orders@dbl_fo atd,
                   orders@dbl_fo o
                 WHERE atd.orderid = o.orderid
                 AND (atd.ordertype <> 'OTO' OR (atd.ordertype = 'OTO' AND o.subside ='NS') )
                 AND NVL(atd.parentno,'1') ='1'
                 AND  NOT EXISTS (SELECT 1 FROM cpo@dbl_fo cp
                                  WHERE cp.quoteid = atd.quoteid AND atd.orderid  = cp.reforderid)
                 GROUP BY atd.quoteid;

