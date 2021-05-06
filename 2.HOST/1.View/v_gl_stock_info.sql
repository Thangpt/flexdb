create or replace force view v_gl_stock_info as
select SB.symbol,ISS.fullname COMPANY_NAME ,SB.sectype sectypeCD, NVL(SB.parvalue,0) parvalue,SB.tradeplace, AL.CDCONTENT TRADEPLACE_NAME
from sbsecurities sb,securities_info se , allcode al,issuers ISS
where sb.codeid =se.codeid 
and sb.tradeplace = al.cdval
and al.cdname='TRADEPLACE'
AND AL.cdtype ='SE'
AND SB.ISSUERID =ISS.issuerid
ORDER BY SYMBOL;

