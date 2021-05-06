--DROP TABLE bl_register;
CREATE TABLE bl_register
    (id                             VARCHAR2(20 BYTE),
    blacctno                       VARCHAR2(50 BYTE),
    afacctno                       VARCHAR2(20 BYTE),
    regdate                        DATE,
    clsdate                        DATE,
    status                         VARCHAR2(1 BYTE) DEFAULT 'A',
    pstatus                        VARCHAR2(4000 BYTE))

/
CREATE SEQUENCE seq_bl_register
  INCREMENT BY 1
  START WITH 1
  MINVALUE 1
  MAXVALUE 9999999999999999999999999999
  NOCYCLE
  NOORDER
  CACHE 20
/
