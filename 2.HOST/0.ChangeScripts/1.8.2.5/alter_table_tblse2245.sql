-- Add/modify columns 
alter table TBLSE2245 add caqtty011 number(20,0) default 0;
alter table TBLSE2245 add taxrate011 number(10,2) default 5;
alter table TBLSE2245 add caqtty021 number(20,0) default 0;
alter table TBLSE2245 add taxrate021 number(10,2) default 5;
-- Add comments to the columns 
comment on column TBLSE2245.caqtty011
  is 'So luong nhan co tuc bang chung khoan';
comment on column TBLSE2245.taxrate011
  is 'Ty le thue co tuc bang chung khoan';
comment on column TBLSE2245.caqtty021
  is 'So luong nhan co phieu thuong';
comment on column TBLSE2245.taxrate021
  is 'Ty le thue co phieu thuong';
  
  
-- Add/modify columns 
alter table TBLSE2245HIST add caqtty011 number(20,0) default 0;
alter table TBLSE2245HIST add taxrate011 number(10,2) default 5;
alter table TBLSE2245HIST add caqtty021 number(20,0) default 0;
alter table TBLSE2245HIST add taxrate021 number(10,2) default 5;

