--Sinh quyen moi khai bao trong OTRIGHTDTL
Declare
       v_count number;
	   v_otright varchar2(200);
       --l_OTMNCODE VARCHAR2(40);
BEGIN
  FOR rec IN(  SELECT * FROM OTRIGHT o WHERE o.deltd = 'N' and o.authtype <>'4' )LOOP
    if(rec.AUTHTYPE  = 1) then v_otright := 'YYYYNYN';
	else v_otright := 'YYYYYNN';
	end if;
    FOR rec1 IN( SELECT * FROM allcode WHERE cdname = 'OTFUNC' AND CDTYPE = 'SA' and cduser = 'Y' ) LOOP
      select count(1) into v_count
      from otrightdtl o 
      where  o.authcustid = rec.authcustid and o.cfcustid = rec.cfcustid and  o.via = rec.via and o.OTMNCODE =  rec1.CDVAL;
      IF v_count = 0 THEN
         insert into otrightdtl (autoid, cfcustid, authcustid, otmncode, otright, deltd, via)
        values (seq_otrightdtl.nextval, rec.cfcustid, rec.authcustid, rec1.cdval, v_otright, 'N', rec.via );
       
      END IF;
    END LOOP;
  END LOOP;
   COMMIT;
END;
/
update OTRIGHTDTl set OTRIGHT = substr(OTRIGHT,0,4)||'NYN' where OTMNCODE not in ('CASHTRANS','BENEFICIARYREGISTER');
commit;
