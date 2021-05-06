-- Add/modify columns
alter table T_FO_ACCOUNT add rate_t0loan NUMBER(20) default 0;
alter table T_FO_ACCOUNT add bod_deal VARCHAR2(1) default 'Y';
alter table T_FO_ACCOUNT_HIST add rate_t0loan NUMBER(20);
alter table T_FO_ACCOUNT_HIST add bod_deal VARCHAR2(1);

-- Add/modify columns 
alter table T_FO_INSTRUMENTS add price_nav NUMBER(20);
alter table T_FO_INSTRUMENTS add qtty_avrtrade NUMBER(20);
alter table T_FO_INSTRUMENTS_HIST add price_nav NUMBER(20);
alter table T_FO_INSTRUMENTS_HIST add qtty_avrtrade NUMBER(20);
