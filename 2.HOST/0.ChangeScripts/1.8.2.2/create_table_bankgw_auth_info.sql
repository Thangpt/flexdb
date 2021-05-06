DROP TABLE BANKGW_AUTH_INFO;
-- Create table
create table BANKGW_AUTH_INFO
(
  bankcode     VARCHAR2(50),
  authtype     VARCHAR2(20),
  comusername  VARCHAR2(100),
  comuserpass  VARCHAR2(100),
  bankusername VARCHAR2(100),
  bankuserpass VARCHAR2(100),
  comcode	     VARCHAR2(50),
  comchannel   VARCHAR2(50),
  bank_no         VARCHAR2(20),
  bankmode        VARCHAR2(5),
  schedulerstatus VARCHAR2(5)
);

DELETE BANKGW_AUTH_INFO WHERE 0 = 0;
insert into bankgw_auth_info (BANKCODE, AUTHTYPE, COMUSERNAME, COMUSERPASS, BANKUSERNAME, BANKUSERPASS, COMCODE, COMCHANNEL, BANK_NO, BANKMODE, SCHEDULERSTATUS)
values ('VPBANK', 'Basic ', 'VPBANK', 'KBSV@VP', 'KBSV', 'KBSV', 'CHIHO_H2H-KBS', 'CHIHO_H2H-KBS', '309', '1', 'N');
COMMIT;
