-- Add/modify columns 
alter table TBLSE2240 add caqtty011 number(20,0) default 0;
alter table TBLSE2240 add taxrate011 number(10,2) default 5;
alter table TBLSE2240 add caqtty021 number(20,0) default 0;
alter table TBLSE2240 add taxrate021 number(10,2) default 5;
-- Add comments to the columns 
comment on column TBLSE2240.caqtty011
  is 'So luong nhan co tuc bang chung khoan';
comment on column TBLSE2240.taxrate011
  is 'Ty le thue co tuc bang chung khoan';
comment on column TBLSE2240.caqtty021
  is 'So luong nhan co phieu thuong';
comment on column TBLSE2240.taxrate021
  is 'Ty le thue co phieu thuong';
  
  
-- Add/modify columns 
alter table TBLSE2240HIST add caqtty011 number(20,0);
alter table TBLSE2240HIST add taxrate011 number(10,2);
alter table TBLSE2240HIST add caqtty021 number(20,0);
alter table TBLSE2240HIST add taxrate021 number(10,2);
