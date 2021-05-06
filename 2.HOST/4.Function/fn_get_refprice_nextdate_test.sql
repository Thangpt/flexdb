CREATE OR REPLACE FUNCTION fn_get_refprice_nextdate_test ( pv_codeid IN VARCHAR2,pv_dbl_oldrefprice IN NUMBER)
RETURN NUMBER
  IS
    l_dbl_new_refprice NUMBER(20);
    l_dtNextDate DATE;
    l_strExrate VARCHAR2(50);
    l_strRIGHTOFFRATE VARCHAR2(50);
    l_left_rightoffrate varchar2(50);
    l_right_rightoffrate varchar2(50);
    l_left_exrate varchar2(50);
    l_right_exrate varchar2(50);
    l_camastid VARCHAR2(50);
    l_dblEXPRICE  NUMBER(20,4);
    l_dblI1 NUMBER(20,4);
    l_dblPr1 NUMBER(20,4);
    l_dblI2 NUMBER(20,4);
    l_dblPr2 NUMBER(20,4);
    l_dblI3 NUMBER(20,4);
    l_dblPr3 NUMBER(20,4);
    l_dblTTH_CP NUMBER(20,4);
    l_dblDiv_CP NUMBER(20,4);
    l_strTYPERATE VARCHAR2(1);
    l_dblDevidentValue NUMBER(20,4);
    l_dblParvalue NUMBER(20,4);
    l_dblTTH      NUMBER(20,4);
BEGIN
    SELECT to_date(varvalue,'DD/MM/RRRR')
    INTO l_dtNextDate
    FROM sysvar WHERE varname='NEXTDATE';

    -- xet xem co phieu co su kien quyen mua
        BEGIN
            SELECT  exrate,rightoffrate,EXPRICE
            INTO  l_strExrate, l_strRIGHTOFFRATE,l_dblPr1
            FROM camast
            WHERE reportdate = l_dtNextDate
            AND codeid=pv_codeid
            AND catype='014' AND deltd='N';
        EXCEPTION WHEN OTHERS THEN
            l_strExrate:='0/1';
            l_strRIGHTOFFRATE:='0/1';
            l_dblPr1:=0;
        END;

         l_left_rightoffrate := substr(l_strRIGHTOFFRATE,0,instr(l_strRIGHTOFFRATE,'/') - 1);
         l_right_rightoffrate := substr(l_strRIGHTOFFRATE,instr(l_strRIGHTOFFRATE,'/') + 1,length(l_strRIGHTOFFRATE));
         l_left_exrate := substr(l_strExrate,0,instr(l_strExrate,'/') - 1);
         l_right_exrate := substr(l_strExrate,instr(l_strExrate,'/') + 1,length(l_strExrate));
         l_dblI1:=(to_number(l_left_exrate)*l_left_rightoffrate)/(to_number(l_right_exrate)*to_number(l_right_rightoffrate));

    -- co phieu thuong
        BEGIN
            SELECT  exrate,exprice
            INTO  l_strExrate,l_dblPr2
            FROM camast
            WHERE reportdate = l_dtNextDate
            AND codeid=pv_codeid
            AND catype='021' AND deltd='N';
        EXCEPTION WHEN OTHERS THEN
            l_strExrate:='1/0';
            l_dblPr2:=0;
        END;
         l_left_exrate := substr(l_strExrate,0,instr(l_strExrate,'/') - 1);
         l_right_exrate := substr(l_strExrate,instr(l_strExrate,'/') + 1,length(l_strExrate));
         l_dblI2:=to_number(l_right_exrate)/to_number(l_left_exrate);
         l_dblTTH_CP:=ROUND(l_dblI2*l_dblPr2);

    -- chia co tuc bang co phieu
        BEGIN
            SELECT  DEVIDENTSHARES,exprice
            INTO  l_strExrate,l_dblPr3
            FROM camast
            WHERE reportdate = l_dtNextDate
            AND codeid=pv_codeid
            AND catype='011' AND deltd='N';
        EXCEPTION WHEN OTHERS THEN
            l_strExrate:='1/0';
            l_dblPr3:=0;
        END;
         l_left_exrate := substr(l_strExrate,0,instr(l_strExrate,'/') - 1);
         l_right_exrate := substr(l_strExrate,instr(l_strExrate,'/') + 1,length(l_strExrate));
         l_dblI3:=to_number(l_right_exrate)/to_number(l_left_exrate);
         l_dblDiv_CP:=ROUND(l_dblI3*l_dblPr3);

    -- chia co tuc bang tien
        BEGIN
            SELECT  devidentrate,devidentvalue,typerate,parvalue
            INTO  l_strExrate,l_dblDevidentValue,l_strTYPERATE,l_dblparvalue
            FROM camast
            WHERE reportdate = l_dtNextDate
            AND codeid=pv_codeid
            AND catype='010' AND deltd='N';
        EXCEPTION WHEN OTHERS THEN
            l_strExrate:='0';
            l_dblDevidentValue:=0;
            l_strTYPERATE:='R';
            l_dblparvalue:=10000;
        END;
        IF(l_strTYPERATE='R') THEN
            l_dblTTH:=to_number(l_strExrate)*l_dblparvalue/100;
        ELSE
            l_dblTTH:=l_dblDevidentValue;
        END IF;
        -- tinh lai gia tham chieu
        l_dbl_new_refprice:=(pv_dbl_oldrefprice+l_dblI1*l_dblPr1+l_dblI2*l_dblPr2+l_dblI3*l_dblPr3-l_dblTTH_CP-l_dblDiv_CP-l_dblTTH)/
                             (1+l_dblI1+l_dblI2+l_dblI3);

RETURN l_dbl_new_refprice;
EXCEPTION WHEN others THEN
    plog.error(dbms_utility.format_error_backtrace);
    return 0;
END;
/

