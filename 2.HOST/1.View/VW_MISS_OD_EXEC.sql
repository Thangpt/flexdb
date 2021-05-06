CREATE OR REPLACE VIEW VW_MISS_OD_EXEC  AS
select  'HNX' Tradeplace, newfo.foorderid, newfo.boorderid, fo.CUSTODYCD, odm.afacctno, fo.symbol, odm.exectype, 
       odm.quoteprice, odm.orderqtty, odm.execqtty, odm.remainqtty, e8.LASTQTY, e8.LASTPX , e8.EXECID CONFIRM_NUMBER
from 
    (Select * From Exec_8 --1351
     Where EXECTYPE ='3' and ORDSTATUS ='2' and side <> '8'
           and ( not exists (select 1 from iod where   (Exec_8.ORDERID)=  (iod.confirm_no)))
     union all
     Select * From Exec_8 --1351
     Where EXECTYPE ='3' and ORDSTATUS ='2' and side = '8'
          and ( not exists (select 1 from iod where   'PT' ||(Exec_8.ORDERID)=  (iod.confirm_no)))
    ) E8,newfo_ordermap newfo,  odmast odm, orders@dbl_fo fo
Where   fo.CONFIRMID =  case when e8.side ='1' then e8.SecondaryClOrdID else e8.ORIGCLORDID end  
        and fo.orderid =  newfo.foorderid and newfo.boorderid = odm.orderid 
union all
SELECT 'HSX' Tradeplace, newfo.foorderid, newfo.boorderid, cf.custodycd, odm.afacctno, sb.symbol, odm.exectype, 
       odm.quoteprice, odm.orderqtty, odm.execqtty, odm.remainqtty , a.Khoi_luong  LASTQTY, a.Gia  LASTPX, a.CONFIRM_NUMBER
FROM ( 
Select    msgtype,
          REGEXP_SUBSTR(SUBSTR(REPLACE(msgxml,' ',''),instr(REPLACE(msgxml,' ',''), '<key>volume</key><value>')+24,12),'\d+') Khoi_luong , 
          nvl(
              REGEXP_SUBSTR(SUBSTR(REPLACE(msgxml,' ',''),instr(REPLACE(msgxml,' ',''), '<key>price</key><value>')+23,15),'\d+\.\d+'),
              REGEXP_SUBSTR(SUBSTR(REPLACE(msgxml,' ',''),instr(REPLACE(msgxml,' ',''), '<key>price</key><value>')+23,15),'\d+') 
              ) Gia ,       
          to_char(msg_Date,'DD/MM/RRRR-HH24:MI:SS')msg_Date,
          REGEXP_SUBSTR(SUBSTR(REPLACE(msgxml,' ',''),instr(REPLACE(msgxml,' ',''), 'order_number</key><value>')+25,8),'\d+') order_number ,
          REGEXP_SUBSTR(SUBSTR(REPLACE(msgxml,' ',''),instr(REPLACE(msgxml,' ',''), 'confirm_number</key><value>')+25,8),'\d+') confirm_number, 
          h.process
          from msgreceivetemp h 
          where msggroup ='CTCI' and  msgtype ='2E' 
          union all 
          Select msgtype,
          REGEXP_SUBSTR(SUBSTR(REPLACE(msgxml,' ',''),instr(REPLACE(msgxml,' ',''), '<key>volume</key><value>')+24,12),'\d+') Khoi_luong , 
          nvl(
              REGEXP_SUBSTR(SUBSTR(REPLACE(msgxml,' ',''),instr(REPLACE(msgxml,' ',''), '<key>price</key><value>')+23,15),'\d+\.\d+'),
              REGEXP_SUBSTR(SUBSTR(REPLACE(msgxml,' ',''),instr(REPLACE(msgxml,' ',''), '<key>price</key><value>')+23,15),'\d+') 
              ) Gia ,       
          to_char(msg_Date,'DD/MM/RRRR-HH24:MI:SS')msg_Date,
          REGEXP_SUBSTR(SUBSTR(REPLACE(msgxml,' ',''),instr(REPLACE(msgxml,' ',''), 'order_number_buy</key><value>')+29,8),'\d+') order_number ,
          REGEXP_SUBSTR(SUBSTR(REPLACE(msgxml,' ',''),instr(REPLACE(msgxml,' ',''), 'confirm_number</key><value>')+25,8),'\d+') confirm_number, 
          h.process
          from msgreceivetemp h 
          where msggroup ='CTCI' and  msgtype ='2I' 
           
           
) a , orders@dbl_fo fo , odmast odm , newfo_ordermap newfo, cfmast cf, afmast af, sbsecurities sb
Where  not exists (select 1 from iod where   trim(a.CONFIRM_NUMBER) =  trim (iod.confirm_no))
and a.ORDER_NUMBER = fo.ROOTORDERID and  fo.orderid = newfo.foorderid  and newfo.boorderid = odm.orderid
and cf.custid = af.custid and af.acctno = odm.afacctno and odm.codeid = sb.codeid;


