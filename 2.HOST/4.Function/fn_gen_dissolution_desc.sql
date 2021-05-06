CREATE OR REPLACE Function FN_GEN_DISSOLUTION_DESC(pv_catype in varchar2,pv_codeid in varchar2, pv_reportdate in varchar2,
                                          pv_typerate in varchar2, pv_payrate in varchar2, pv_cashpersec in varchar2)
RETURN VARCHAR2
IS
v_catype varchar2(20);
v_codeid varchar2(20);
v_reportdate varchar2(20);
v_typerate varchar(10);
v_payrate number(20,4);
v_cashpersec varchar2(20);
v_desc varchar2(500);
v_caname varchar2(300);
v_symbol varchar2(20);
BEGIN
    v_catype := pv_catype;
    v_codeid := pv_codeid;
    v_reportdate := pv_reportdate;
    v_typerate := pv_typerate;
    v_payrate := to_number(pv_payrate);
    v_cashpersec := pv_cashpersec;
    Begin
      select cdcontent into v_caname from allcode where cdtype ='CA' and cdname ='CATYPE' and cdval = v_catype;
      exception when others then
        v_caname := v_catype;
      end;
    Begin
      select symbol into v_symbol from securities_info where codeid = v_codeid;
      exception when others then
        v_symbol := v_codeid;
        end;
    IF v_typerate = 'R' THEN
        v_desc := v_caname || ', '|| v_symbol || ', ngày ch?t: ' || v_reportdate || ',t? l?: '|| v_payrate || '%';
    ELSE
        v_desc := v_caname || ', '|| v_symbol || ', ngày ch?t: ' || v_reportdate ||  ',giá tr?: '|| v_cashpersec;
    END IF;
    return v_desc;
EXCEPTION WHEN OTHERS THEN
    return '';
END;
/

