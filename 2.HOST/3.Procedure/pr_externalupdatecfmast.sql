CREATE OR REPLACE PROCEDURE pr_externalupdatecfmast(pv_err_code in out varchar2, pv_custid in varchar2)
is
begin
    --Cap nhat thong tin tu khach hang sang tieu khoan.
    for rec in (select * from cfmast where custid = pv_custid)
    loop
        update afmast set
            EMAIL=rec.EMAIL,
            FAX=rec.FAX,
            FAX1=rec.MOBILE, --sms mobile
            PHONE1=rec.PHONE,
            TRADEPHONE=rec.MOBILE,
            ADDRESS=rec.ADDRESS,
            CAREBY = rec.CAREBY
        where custid = rec.custid;
        update cfotheracc set
            acnidcode=rec.idcode,
            acniddate=rec.iddate,
            acnidplace=rec.idplace,
            bankacname=rec.fullname
        where custid = rec.custid;
        update userlogin set
            tokenid = '{MSBS{SMS{'|| rec.mobile || '}}}'
        where username = rec.username;
    end loop;
end;
/

