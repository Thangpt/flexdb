CREATE TABLE reaflnk_20180718 as select * from reaflnk where todate = '17/Jul/1950' and status = 'A';
UPDATE reaflnk SET todate = to_date('17/07/2050','DD/MM/RRRR') WHERE todate = '17/Jul/1950' and status = 'A';
COMMIT;
