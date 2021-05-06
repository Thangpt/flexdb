BEGIN
  FOR REC IN (select distinct o.authcustid, o.cfcustid, min(o.valdate) valdate, max(EXPDATE) EXPDATE
              from OTRIGHT_BACKUP o where deltd = 'N' 
              group by o.authcustid, o.cfcustid
              order by o.authcustid, o.cfcustid) LOOP
              
           UPDATE OTRIGHT SET DELTD = 'Y' WHERE AUTHCUSTID = REC.AUTHCUSTID AND CFCUSTID = REC.CFCUSTID AND VIA ='A' AND AUTHTYPE <> '4' ;
           INSERT INTO OTRIGHT(AUTOID, CFCUSTID, AUTHCUSTID, AUTHTYPE, VALDATE, EXPDATE, DELTD, LASTDATE, LASTCHANGE, SERIALNUMSIG, VIA)
           VALUES (SEQ_OTRIGHT.NEXTVAL, REC.CFCUSTID, REC.AUTHCUSTID, '0', REC.VALDATE, REC.EXPDATE,'N',NULL,getcurrdate, NULL, 'A');
  END LOOP;
  COMMIT;
END;
