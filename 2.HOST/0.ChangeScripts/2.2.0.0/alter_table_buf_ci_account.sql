-- Add/modify columns 
alter table BUF_CI_ACCOUNT add tax_sell_sending number default 0;
alter table BUF_CI_ACCOUNT add fee_sell_sending number default 0;
