create or replace procedure pr_insertlogplaceorder(p_requestid varchar2 ,
                                                   p_orderid       VARCHAR2,
                                                   p_via         VARCHAR2 ,
                                                   p_ipaddress   VARCHAR2,
                                                   p_validationtype  VARCHAR2,
                                                   p_devicetype  VARCHAR2,
                                                   p_device      VARCHAR2)
is
BEGIN
  IF (p_requestid IS NOT NULL ) THEN
     insert into logplaceorder (autoid, requestid ,orderid,via,ipaddress,validationtype ,devicetype,device)
    values (SEQ_LOGPLACEORDER.NEXTVAL,p_requestid ,p_orderid,p_via,substr(p_ipaddress,1,200),p_validationtype ,p_devicetype,p_device );
    END IF;
end pr_insertlogplaceorder;
/
