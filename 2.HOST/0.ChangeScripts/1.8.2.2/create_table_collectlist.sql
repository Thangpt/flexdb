--create table
create table collectlist
(
id                          number,
trantype                    varchar2(5),
ordernum                    varchar2(15),
transactionid               varchar2(50),
refnum                      varchar2(50),
amount                      varchar2(50), 
bankTime                    varchar2(50),
txdate                      date,
custodycd                   varchar2(50),
customerName                varchar2(50),
accountno                   varchar2(50),
cif                         varchar2(50),
via                         varchar2(50),
vpbankAccount               varchar2(500),
kbsStatus                   varchar2(100),
vpbankAfterStatus           varchar2(100),
status                      varchar2(5) default 'P',
filename                    varchar2(100),
create_time                 timestamp(6) default systimestamp,  
CONSTRAINT collectlist_key PRIMARY KEY (id)
);
-- Create sequence 
create sequence seq_collectlist
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 100;
