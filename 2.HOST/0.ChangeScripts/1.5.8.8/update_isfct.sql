create table afmast_temp_isfct as select * from afmast;
UPDATE AFMAST SET ISFCT = 'Y' WHERE CUSTID IN (SELECT CUSTID FROM CFMAST WHERE CUSTTYPE='I');
UPDATE AFMAST SET ISFCT = 'N' WHERE CUSTID IN (SELECT CUSTID FROM CFMAST WHERE CUSTTYPE='B');
COMMIT;
