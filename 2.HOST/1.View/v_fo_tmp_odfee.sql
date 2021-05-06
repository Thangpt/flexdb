-- Start of DDL Script for View HOSTMSTRADE.V_FO_TMP_ODFEE
-- Generated 11/04/2017 3:42:59 PM from HOSTMSTRADE@FLEX_111

CREATE OR REPLACE VIEW v_fo_tmp_odfee (
   acctno,
   rate_brk_s,
   rate_brk_b )
AS
SELECT a.acctno,  RATE_BRK_S, RATE_BRK_B FROM
(
SELECT aftype,
                MAX(RATE_BRK_S) RATE_BRK_S,
                MAX(RATE_BRK_B) RATE_BRK_B
           FROM
              (
                  SELECT  a.actype, a.aftype,
                      CASE WHEN b.sectype IN ('000','001','002','011','111','333')
                           THEN b.deffeerate ELSE 0 END RATE_BRK_S,
                      CASE WHEN b.sectype IN ('000','003','006','222','444')
                           THEN b.deffeerate ELSE 0 END RATE_BRK_B
                      FROM  afidtype a, odtype b
                      WHERE  b.actype = a.actype
                      AND   a.objname = 'OD.ODTYPE'
              )
          GROUP BY aftype
) v, afmast a , cfmast cf WHERE v.aftype = a.actype
AND a.custid = cf.custid AND a.status IN  ('A','P') AND cf.custodycd IS NOT NULL
/


-- End of DDL Script for View HOSTMSTRADE.V_FO_TMP_ODFEE

