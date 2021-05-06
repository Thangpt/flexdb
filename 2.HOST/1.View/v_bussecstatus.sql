create or replace force view v_bussecstatus as
(select custid,afacctno acctno,symbol, trade,COSTPRICE,MORTAGE,STANDING,WITHDRAW,BLOCKED,RECEIVING,BASICPRICE ,CURRPRICE
from semast se,securities_info sb where se.codeid=sb.codeid and trade+secured+mortage+blocked+receiving+netting+withdraw>0);

