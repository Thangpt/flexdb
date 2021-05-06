alter TABLE newbankgw_log ADD createdt TIMESTAMP(6) default systimestamp;

alter TABLE newbankgw_log ADD bankDate DATE;
