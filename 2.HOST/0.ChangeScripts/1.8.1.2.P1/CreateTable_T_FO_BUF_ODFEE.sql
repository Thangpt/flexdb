create table T_FO_BUF_ODFEE
(
  acctno     VARCHAR2(20) not null,
  rate_brk_s NUMBER,
  rate_brk_b NUMBER,
  lastchange TIMESTAMP(6) WITH TIME ZONE
);
