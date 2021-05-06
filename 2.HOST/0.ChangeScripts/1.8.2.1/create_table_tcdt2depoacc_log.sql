-- Create table
create table TCDT2DEPOACC_LOG
(
  txdate     DATE,
  txnum      VARCHAR2(10),
  dcustodycd VARCHAR2(10),
  dacctno    VARCHAR2(10),
  ccustodycd VARCHAR2(10),
  cacctno    VARCHAR2(10),
  amt        NUMBER default 0,
  feeamt     NUMBER default 0,
  rmstatus   VARCHAR2(1) default 'A',
  deltd      VARCHAR2(1) default 'N',
  tlid       VARCHAR2(4),
  offid      VARCHAR2(4),
  brid       VARCHAR2(4),
  des        VARCHAR2(300)
);

-- Create table
create table TCDT2DEPOACC_LOG_HIST
(
  txdate     DATE,
  txnum      VARCHAR2(10),
  dcustodycd VARCHAR2(10),
  dacctno    VARCHAR2(10),
  ccustodycd VARCHAR2(10),
  cacctno    VARCHAR2(10),
  amt        NUMBER default 0,
  feeamt     NUMBER default 0,
  rmstatus   VARCHAR2(1) default 'A',
  deltd      VARCHAR2(1) default 'N',
  tlid       VARCHAR2(4),
  offid      VARCHAR2(4),
  brid       VARCHAR2(4),
  des        VARCHAR2(300)
);


-- Create/Recreate indexes 
create INDEX tcdt2depo_dcustodycd_idx on TCDT2DEPOACC_LOG (dcustodycd);
create INDEX tcdt2depo_ccustodycd_idx on TCDT2DEPOACC_LOG (ccustodycd);
create INDEX tcdt2depo_txdate_txnum_idx on TCDT2DEPOACC_LOG (txdate, txnum);


-- Create/Recreate indexes 
create INDEX tcdt2depohist_dcustodycd_idx on TCDT2DEPOACC_LOG_HIST (dcustodycd);
create INDEX tcdt2depohist_ccustodycd_idx on TCDT2DEPOACC_LOG_HIST (ccustodycd);
create INDEX tcdt2depohist_txdate_txnum_idx on TCDT2DEPOACC_LOG_HIST (txdate, txnum);
