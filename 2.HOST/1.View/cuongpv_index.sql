create or replace force view cuongpv_index as
Select 'UPCOM' as marketcode,to_char(trading_date) as tradingdate,to_char(systime) as indextime, to_char(total_value) as totalvalue
From INFOUPCOM.sts_market_info@toinfo
UNION ALL
Select 'HNX' as marketcode,to_char(trading_date) as tradingdate,to_char(systime) as indextime, to_char(total_value) as totalvalue
From INFOSHOW.sts_market_info@toinfo where total_value<>0
UNION ALL
Select distinct(to_char( marketcode)),to_char(tradingdate), to_char(indextime), to_char(totalvalue)
From MSTRADE.CUONGPV_INDEX@dbonline where marketcode = 'HOSE'
--From WEBPERSISTENT.CUONGPV_INDEX@dbuat where marketcode = 'HOSE'
;

