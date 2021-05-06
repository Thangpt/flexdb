BEGIN
for rec in 
  (select offtime,txdate,txnum, tltxcd from tllogall 
  where tltxcd in ('1131','1141','1198','1120') and deltd <> 'Y'
    and txdate between to_date('01/01/2019','DD/MM/RRRR') and getcurrdate)
  LOOP
      update citran_gen ci
      set ci.offtime=rec.offtime
      where ci.txnum=rec.txnum and ci.txdate=rec.txdate and ci.tltxcd=rec.tltxcd;
    END LOOP;
 
COMMIT;
END;
