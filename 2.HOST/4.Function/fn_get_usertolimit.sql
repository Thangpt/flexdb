CREATE OR REPLACE FUNCTION FN_GET_USERTOLIMIT (p_userid varchar2, p_T0AMTPENDING NUMBER,p_period number) return STRING
is
v_result varchar2(500);
v_count NUMBER;
v_brid VARCHAR2(4);
v_tlgr VARCHAR2(500);
 pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

BEGIN
 -----------------------------------------
 -- Neu can phe duyet
 -- Tim DS ng co the phe duyet.
 --     Nguoi phe duyet la cap TGD, CT HDQT  cho qua luon
 --     Nguoi phe duyet la GDCN hoac thap hon thi MG va ng phe duyet phai cung chi nhanh
 --     Khac 2 truong hop tren thi MG va nguoi phe duyet phai cung nhom quan ly moi gioi.
 -----------------------------------------
 --1.7.3.3 GD khu vuc tltitle : 006 khong can check nhom. Chi check chi nhanh
  IF p_T0AMTPENDING>0 THEN  --Neu can phe duyet
  SELECT FN_GET_TLGR(p_userid) INTO v_tlgr FROM dual; --Nhom quan ly MG
  SELECT brid INTO v_brid FROM tlprofiles WHERE tlid =p_userid; --Chi nhanh MG
     SELECT nvl(COUNT(*) ,0) INTO v_count
      FROM usert0limit us, (    SELECT nvl(SUM(T0AMTPENDING),0) usedAMT, tlid  FROM OLNDETAIl WHERE  STATUS IN ('A','E')       AND duedate =getcurrdate GROUP BY tlid) onl
      ,TLPROFILES TLP,
      (SELECT regrp.fullname, re.reftlid FROM REGRPLNK tlgr, recflnk re, REGRP
                       WHERE   re.custid = tlgr.custid
                 AND REGRP.AUTOID =TLGR.REFRECFLNKID
                 and tlgr.STATUS='A'
                 AND re.effdate<=getcurrdate AND re.expdate>=getcurrdate
                 AND TLGR.FRDATE<=GETCURRDATE AND TLGR.TODATE>=GETCURRDATE
                 group by regrp.fullname, re.reftlid) tlgr
      WHERE  us.status ='A'
      AND us.tlid = tlgr.reftlid(+)
      AND us.tlid=onl.tlid(+)
      AND us.period =p_period
      AND us.t0limit-p_T0AMTPENDING >= 0
      AND us.t0limitall-nvl(onl.usedAMT,0)-p_T0AMTPENDING>=0
      AND tlp.tlid=us.tlid
      AND (CASE WHEN tlp.tltitle IN ('003','004') THEN v_brid ELSE tlp.brid end )=v_brid
      AND (CASE WHEN tlp.tltitle IN ('003','004','002','006')  THEN v_tlgr ELSE tlgr.fullname END ) =v_tlgr 
	  

      ORDER BY us.t0limit;
      IF v_count>0 THEN

          --Han muc con lai cua cac cap co the phe duyet
          SELECT tlid INTO v_result
          FROM (
          SELECT nvl(us.tlid,'') tlid
          FROM usert0limit us, (    SELECT nvl(SUM(T0AMTPENDING),0) usedAMT, tlid  FROM OLNDETAIl WHERE  STATUS IN ('A','E')      AND duedate =getcurrdate GROUP BY tlid) onl
           ,tlprofiles tlp,
           (SELECT regrp.fullname , re.reftlid FROM REGRPLNK tlgr, recflnk re, REGRP
                       WHERE   RE.CUSTID = TLGR.CUSTID
                        and tlgr.STATUS='A'
                 AND regrp.autoid =tlgr.refrecflnkid
                 AND re.effdate<=getcurrdate AND re.expdate>=getcurrdate
                 AND TLGR.FRDATE<=GETCURRDATE AND TLGR.TODATE>=GETCURRDATE
                 group by  regrp.fullname,re.reftlid) tlgr
            WHERE  us.status ='A'
            AND us.tlid = tlgr.reftlid(+)
            AND us.tlid=onl.tlid(+)
            AND us.period =p_period
            AND us.t0limit-p_T0AMTPENDING >= 0
            AND us.t0limitall-nvl(onl.usedAMT,0)-p_T0AMTPENDING>=0
            AND tlp.tlid=us.tlid
            AND (CASE WHEN tlp.tltitle IN ('003','004') THEN v_brid ELSE tlp.brid end )=v_brid
            AND (CASE WHEN tlp.tltitle IN ('003','004','002', '006')  THEN v_tlgr ELSE tlgr.fullname END ) =v_tlgr
            ORDER BY us.t0limit)
            WHERE ROWNUM=1;

      ELSE v_result:='Không có c?p phê duy?t phù h?p';
      END IF;

    return v_result;

    ELSE
      RETURN '';
      END IF;
exception when others then
    RETURN 'Loi He Thong!';
end;
/

