-- Start of DDL Script for View HOST.VW_LOG_SA0015
-- Generated 8-May-2020 10:13:40 from HOST@FLEXREPORT

CREATE OR REPLACE VIEW vw_log_sa0015 (
   custodycd,
   afacctno,
   txdate,
   nav_1,
   nav,
   odexecamt,
   mramt )
AS
select lo.custodycd,lo.afacctno, lo.txdate,nvl(lo_1.navamt_ed,0) nav_1_ck,nvl(lo.navamt_ed,0) nav_ck, nvl(lo.ODEXECAMT,0)ODEXECAMT ,nvl(lo.MRAMT,0) mramt
from LOG_SA0015 lo left join LOG_SA0015 lo_1
on  lo.AFACCTNO =lo_1.AFACCTNO and lo_1.txdate = FN_GET_NEXTDATE(lo.txdate,-1)
/


-- End of DDL Script for View HOST.VW_LOG_SA0015

