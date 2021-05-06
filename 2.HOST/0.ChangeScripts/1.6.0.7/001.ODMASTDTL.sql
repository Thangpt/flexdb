BEGIN
     FOR rec IN (SELECT * FROM vw_odmast_all WHERE (EXECTYPE IN ('CS', 'AS') AND REFORDERID IN (SELECT ORDERID FROM ODMAST WHERE ISDISPOSAL = 'Y'))
                                            OR ISDISPOSAL = 'Y'
                 )
     LOOP
     UPDATE ODMASTDTL SET ISDISPOSAL = 'Y' WHERE ORDERID = rec.ORDERID;
     END LOOP;
	 commit;
END;

