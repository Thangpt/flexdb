CREATE OR REPLACE PROCEDURE pr_insertiplog (v_txnum  varchar2,
                                           v_txdate Date,
                                           v_ipaddress  VARCHAR2,
                                           v_via  varchar2,
                                           v_otauthtype  varchar2,
                                           v_devicetype  VARCHAR2,
                                           v_device      VARCHAR2,
                                           v_errcode     VARCHAR2)
IS
BEGIN
    --Them vao bang IPLOG.
    IF (v_txnum IS NOT NULL OR v_txdate IS NOT NULL OR v_ipaddress IS NOT NULL or v_via IS NOT NULL or
       v_otauthtype IS NOT NULL OR v_devicetype IS NOT NULL OR v_device IS NOT NULL or
       v_errcode IS NOT NULL) THEN
          insert into iplog (AUTOID, TXNUM, TXDATE, IPADDRESS, VIA, OTAUTHTYPE, DEVICETYPE, DEVICE, ERRORCODE, SYSDATES)
          values (seq_iplog.nextval , v_txnum, v_txdate, substr(v_ipaddress,1,200), v_via, v_otauthtype, v_devicetype, v_device, v_errcode,SYSDATE);
    END IF;
end;
/
