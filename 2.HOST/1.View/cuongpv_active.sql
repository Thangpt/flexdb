CREATE OR REPLACE FORCE VIEW CUONGPV_ACTIVE AS
select count(distinct CUSTODYCD) as TK_ACTIVE from IOD
UNION
SELECT count (CUSTID) as Tong_SL_TAI_KHOAN FROM cfmast where status<>'C';

