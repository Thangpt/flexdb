--
--
/
create or replace procedure pr_logdraftorder      (p_draftid varchar2 ,
                                                   p_orderid VARCHAR2,
                                                   p_issaved VARCHAR2,
                                                   p_errcode VARCHAR2)
is
v_currdate varchar2 (20);
BEGIN
  if trim(p_draftid) is not null and  length(p_draftid) > 0 then
    if trim(p_errcode) <> '0' then
      if upper(trim(p_issaved)) = 'Y' then
        update draft_order set status = 'E', errcode = trim(p_errcode), errmsg = cspks_system.fn_get_errmsg(trim(p_errcode))
        where autoid = to_number(trim(p_draftid));
      else
        update draft_order set status = 'H', errcode = trim(p_errcode), errmsg = cspks_system.fn_get_errmsg(trim(p_errcode))
        where autoid = to_number(trim(p_draftid));
      end if;
    else
	   SELECT VARVALUE ||' '|| to_char (sysdate, 'hh:mi:ss') into v_currdate
	   FROM SYSVAR WHERE GRNAME = 'SYSTEM' AND VARNAME ='CURRDATE';
      --1.8.2.4: chuyen log thong tin lenh sinh sang bang draft_ordermap
      update draft_order set status = 'C', fo_orderid = trim(p_orderid), lastordertime = v_currdate, ACTCOUNT = ACTCOUNT + 1 
      where autoid = to_number(trim(p_draftid));

      insert into draft_order_active(autoid, draft_id,txdate,foorderid,activetime)
      values (SEQ_DRAFT_ORDER_ACTIVE.nextval,to_number(trim(p_draftid)),getcurrdate, trim(p_orderid), sysdate );
      
    end if;
  end if;
EXCEPTION
  WHEN OTHERS THEN
    RETURN;
END pr_logdraftorder;

/
