CREATE TABLE bl_traderef
    (id                             NUMBER,
    blacctno                       VARCHAR2(50 BYTE),
    afacctno                       VARCHAR2(20 BYTE),
    traderid                       VARCHAR2(20 BYTE),
    regdate                        DATE,
    clsdate                        DATE,
    status                         VARCHAR2(1 BYTE) DEFAULT 'A',
    fullnametrader                 VARCHAR2(100 BYTE))

/
CREATE SEQUENCE seq_bl_traderef
  INCREMENT BY 1
  START WITH 1
  MINVALUE 1
  MAXVALUE 9999999999999999999999999999
  NOCYCLE
  NOORDER
  CACHE 20
/
