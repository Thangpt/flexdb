
create table stockinfor_hist as select * from stockinfor where  tradingdate='07/10/2019';
/
truncate table stockinfor;
commit;
/
INSERT INTO tblbackup 
VALUES('STOCKINFOR','STOCKINFOR_HIST','N');
commit;


