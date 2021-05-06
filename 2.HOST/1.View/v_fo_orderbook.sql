create or replace force view v_fo_orderbook as
select o.orderid,o.orderid reforderid,o.txdate,o.afacctno, i.symbol df_se_code, o.exectype, decode(o.pricetype,'LO',o.quoteprice, o.pricetype)  quoteprice, o.orderqtty, c.fullname, o.feeacr, sb.tradeplace df_se_floor_code,
c.custodycd, o.via, o.txtime, i.matchqtty, i.matchprice, matchqtty * matchprice execamt, i.confirm_no
from
   odmast o,
   iod i,
   cfmast c,
   sbsecurities sb
where o.orderid =i.orgorderid(+)
and i.custodycd =c.custodycd
and o.codeid =sb.codeid;

