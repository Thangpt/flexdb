CREATE OR REPLACE FORCE VIEW V_FO_CUSTOMER AS
SELECT   custid, custodycd, fullname,
         DECODE(substr(custodycd,4,1),'F','F','P','P','D' ) dof
  FROM   cfmast
 WHERE   custodycd IS NOT NULL AND status IN ('P','A');

