

CREATE TABLE t_fo_buf_basket
    (basketid                       VARCHAR2(50),
    symbol                         VARCHAR2(20) NOT NULL,
    price_margin                   NUMBER,
    price_asset                    NUMBER,
    rate_buy                       NUMBER,
    rate_margin                    NUMBER(20,4),
    rate_asset                     NUMBER(20,4),
    txdate                         DATE,
    afmaxamt                       NUMBER(20,4),
    lastchange                     TIMESTAMP (6) WITH TIME ZONE);
