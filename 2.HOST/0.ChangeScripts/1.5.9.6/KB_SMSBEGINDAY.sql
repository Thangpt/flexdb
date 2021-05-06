CREATE TABLE smsbeginday_temp AS SELECT s.* FROM smsbeginday s, (SELECT * FROM sysvar WHERE varname='PREVDATE') sysv
 WHERE s.txdate=to_date(sysv.varvalue,'DD/MM/RRRR');


ALTER TABLE smsbeginday RENAME TO smsbeginday_hist; 
DROP INDEX SMBD_ACCTNO_IDX;
DROP INDEX SMBD_AFACCTNO_IDX;
DECLARE 
v_prevadate VARCHAR2(20);
BEGIN

SELECT varvalue INTO v_prevadate  FROM sysvar WHERE varname='PREVDATE';

DELETE  FROM smsbeginday_hist s
WHERE s.txdate=to_date(v_prevadate,'DD/MM/RRRR');
COMMIT;
END;

DROP INDEX SMBD_TXDATE_I1;
-- Create table
create table SMSBEGINDAY
(
  autoid    NUMBER(20),
  afacctno  VARCHAR2(10),
  custodycd VARCHAR2(10),
  txdate    DATE,
  balance   NUMBER(20),
  acctno    VARCHAR2(20),
  symbol    VARCHAR2(20),
  codeid    VARCHAR2(10),
  trade     NUMBER(20)
);
INSERT INTO SMSBEGINDAY SELECT * FROM smsbeginday_temp;
create index SMBD_ACCTNO_IDX on SMSBEGINDAY (ACCTNO);
create index SMBD_AFACCTNO_IDX on SMSBEGINDAY (AFACCTNO);
create index SMBD_TXDATE_I1 on SMSBEGINDAY (TXDATE);
DROP TABLE smsbeginday_temp;

