--
--
/
DELETE PRCHK WHERE TLTXCD = '2673';
INSERT INTO PRCHK (TLTXCD,CHKTYPE,TYPE,TYPEID,BRIDTYPE,PRTYPE,ACCFLDCD,TYPEFLDCD,DORC,AMTEXP,ODRNUM,UDPTYPE,DELTD,LNACCFLDCD,LNTYPEFLDCD)
VALUES ('2673','I','AFTYPE','03','0','R','05',null,'D','12++13++22++23','0','I','N',null,null);
COMMIT;
/
