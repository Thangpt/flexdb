create table fix_message_response (
  id       number, 
  msgType  varchar2(10), 
  target   varchar2(10),
  messase  varchar2(2000)
);
create sequence seq_fix_message_response
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 2;