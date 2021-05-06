-- Create table
create table CFNAV
(
   refid          VARCHAR2(16),
   custid         VARCHAR2(20),
   frdate         DATE,
   todate         DATE,
   avlnav         NUMBER(20,4),
   navcompare     NUMBER(20,4)
);
-- Create/Recreate indexes 
create index IDX_CFNAV_AUTOID on CFNAV(REFID);
create index IDX_CFNAV_CUSTID on CFNAV(CUSTID);
