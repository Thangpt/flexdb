create table REGISTERLOG
(
  txdate      DATE,
  txnum       VARCHAR2(20),
  afacctno    VARCHAR2(20),
  custodycd   VARCHAR2(20),
  produccode  VARCHAR2(20),
  description VARCHAR2(2000),
  actiotion   VARCHAR2(10),
  maker       VARCHAR2(10),
  checker     VARCHAR2(10)
)
