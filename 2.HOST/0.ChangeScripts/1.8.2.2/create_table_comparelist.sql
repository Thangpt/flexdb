--create table
create table comparelist
(
id                          number,
transactiontype             varchar2(5),
RecordType                  varchar2(10),
RefNum                      varchar2(50),
BankId                      varchar2(20),
TransferType                varchar2(5),
DebitAccount                varchar2(20),
BenAccount                  varchar2(20),
BenName                     varchar2(100),
BenBankName                 varchar2(100),
BenBankCode                 varchar2(20),
Amount                      varchar2(20),
BankTime                    varchar2(14),
Checksum                    varchar2(200),
ResultEnd                   varchar2(5),
RevertTime                  varchar2(14),
CustomerStatus              varchar2(5),
VPBStatus                   varchar2(5),
ResultCollate               varchar2(5),
TranFee                     varchar2(20),
Status                      varchar2(5) default 'P',
txdate                      date,
Create_time                 timestamp default sysdate,
fileName                    varchar2(100),
verify                      varchar2(5),
CONSTRAINT comparelist_key PRIMARY KEY (id)
);
-- Create sequence 
create sequence seq_comparelist
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 100;

