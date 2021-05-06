

CREATE INDEX newbankgw_log_idx_tranid 
ON newbankgw_log(TRANSACTIONID);
CREATE INDEX newbankgw_log_idx_batchid 
ON newbankgw_log(BATCHID);
CREATE INDEX newbankgw_log_idx_msgid 
ON newbankgw_log(MESSAGEID);
CREATE INDEX comparelist_idx_filename 
ON comparelist(FILENAME);
