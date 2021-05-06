-- Create table
create table T_FO_TMP_INSTRUMENTS
(
  symbol        VARCHAR2(80),
  price_nav     NUMBER(20),
  qtty_avrtrade NUMBER(20),
  lastchange    TIMESTAMP(6) WITH TIME ZONE
);
create table T_FO_TMP_INSTRUMENTS_HIST
(
  symbol        VARCHAR2(80),
  price_nav     NUMBER(20),
  qtty_avrtrade NUMBER(20),
  lastchange    TIMESTAMP(6) WITH TIME ZONE
);
create table T_FO_BUF_INSTRUMENTS
(
  symbol        VARCHAR2(80),
  price_nav     NUMBER(20),
  qtty_avrtrade NUMBER(20),
  lastchange    TIMESTAMP(6) WITH TIME ZONE
);
create table T_FO_INDAY_INSTRUMENTS
(
  symbol        VARCHAR2(80),
  price_nav     NUMBER(20),
  qtty_avrtrade NUMBER(20),
  actiontype    VARCHAR2(1),
  status        VARCHAR2(1),
  lastchange    TIMESTAMP(6) WITH TIME ZONE
);
create table T_FO_INDAY_INSTRUMENTS_HIST
(
  symbol        VARCHAR2(80),
  price_nav     NUMBER(20),
  qtty_avrtrade NUMBER(20),
  actiontype    VARCHAR2(1),
  status        VARCHAR2(1),
  lastchange    TIMESTAMP(6) WITH TIME ZONE
);
