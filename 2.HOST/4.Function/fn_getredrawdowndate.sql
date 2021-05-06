CREATE OR REPLACE FUNCTION fn_getREDRAWDOWNDATE(pv_autoid IN number)
RETURN number IS
v_OPNDATE date;
v_intNum number(20,0);
i number(20,0);
intAutoID number(20,0);
intID number(20,0);

BEGIN

intID:=pv_autoid;
i:=0;
while i<=1000
loop
    i:=i+1;
    SELECT nvl(REFOPNAUTOID,0) into intAutoID FROM vw_lnschd_all WHERE AUTOID = intID;
   -- plog.error('intAutoID: ' || intAutoID || ' i: ' || i);
    if intAutoID=0 or i=1000 then
        exit ;
    end if ;

    intid:=intAutoID;

end loop;


/*select count(*) INTO v_intNum
    from lnschd LNS, LNMAST LN, SBCLDR
    where lns.autoid=intid and lns.acctno = ln.acctno
    and CLDRTYPE = '000' AND HOLIDAY <> 'Y' and sbdate between to_date(LN.OPNDATE,'DD/MM/RRRR') AND getcurrdate ;

*/
select getcurrdate - to_date(RLSDATE,'DD/MM/RRRR') INTO v_intNum
    from vw_lnschd_all
    where autoid=intid ;


--v_intNum:= intid;

RETURN v_intNum;
EXCEPTION WHEN OTHERS THEN
    RETURN 0;

END;
/

