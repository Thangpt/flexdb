CREATE OR REPLACE FUNCTION fn_checkmarginrate(p_acctno VARCHAR2 )
  RETURN number
  IS
  v_marginrate2 number;
  v_T0OveqRate NUMBER;
  BEGIN
  SELECT  MARGINRATE  INTO   v_marginrate2
            FROM V_GETSECMARGINRATIO
            WHERE afacctno =p_acctno;
        SELECT varvalue INTO v_T0OveqRate FROM sysvar WHERE varname ='T0OVRQRATIO' AND grname ='MARGIN';
        IF v_marginrate2 <= v_T0OveqRate THEN
          RETURN -100140;
          END IF;
          RETURN 0;
  EXCEPTION
  WHEN OTHERS
   THEN
      return -1;
END fn_checkmarginrate;
/

