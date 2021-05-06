-- Add/modify columns 
alter table T_FO_STOCK_LOT_UPDATE add pitqtty NUMBER(20);
alter table T_FO_STOCK_LOT_UPDATE add taxrate NUMBER(20,2);

-- Add/modify columns 
alter table T_FO_STOCK_LOT_UPDATE_HIST add pitqtty NUMBER(20);
alter table T_FO_STOCK_LOT_UPDATE_HIST add taxrate NUMBER(20,2);

