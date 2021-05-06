CREATE OR REPLACE FUNCTION FN_GET_TLGR (p_userid VARCHAR2) return STRING
is
v_result varchar2(500);
BEGIN
      SELECT max( regrp.fullname) INTO v_result FROM REGRPLNK tlgr, recflnk re, REGRP
         WHERE   re.custid = tlgr.custid
                 AND RE.REFTLID =P_USERID
                 AND TLGR.STATUS='A'
                 AND regrp.autoid =tlgr.refrecflnkid
                 AND re.effdate<=getcurrdate AND re.expdate>=getcurrdate
                 AND tlgr.frdate<=getcurrdate AND tlgr.todate>=getcurrdate;
      return v_result;
exception when others then
    return 'Loi He Thong!';
end;
/

