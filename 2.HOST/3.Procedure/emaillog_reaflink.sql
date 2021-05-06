CREATE OR REPLACE PROCEDURE "EMAILLOG_REAFLINK"
   (pr_TXNUM IN VARCHAR2,
    pr_TXDATE IN DATE
   )
   IS
  l_datasource   varchar2(1000);
  l_custody_code cfmast.custodycd%type;
  l_fullname_care     cfmast.fullname%type;
  l_mobile_care     cfmast.mobile%type;
  l_email_care     cfmast.email%type;
  l_fullname     cfmast.fullname%type;
  l_email     cfmast.email%type;
  l_mobile    cfmast.mobile%type;
  l_address    cfmast.address%type;
  l_typename    aftype.typename%type;
  L_count number;
  L_count_re number;  --kiem tra da gan moi gioi cho tieu khoan chua
  l_custodycd cfmast.custodycd%type;
  l_sex varchar2(10);
  L_afacctno afmast.acctno%TYPE;
  L_custid cfmast.custid%TYPE;
  L_reacctno reaflnk.reacctno%TYPE;
  L_rerole varchar2(10);
   pkgctx     plog.log_ctx;
BEGIN

--THONG TIN TRONG AFLINK
BEGIN
select  af.acctno,af.custid, RE.reacctno into  L_afacctno,L_custid,L_reacctno  from  reaflnk re,afmast af WHERE re.afacctno= af.acctno and  txnum = pr_TXNUM AND txdate = pr_TXDATE ;
 exception
  when others then
  L_afacctno:='';
  L_custid:='';
end ;
--plog.error(pkgctx, 'quyet.kieu 1  L_afacctno' || L_afacctno);

BEGIN
select  count (1),MAX(RETYPE.REROLE) into  L_count_re,L_rerole  from  reaflnk , retype  WHERE retype.actype = substr(reaflnk.reacctno,11) AND   afacctno = L_afacctno AND RETYPE.rerole IN ('RM','BM','RD') ;
exception
when others then
L_count_re:=0;
end ;

--plog.error(pkgctx, 'quyet.kieu 2  L_count_re' || L_count_re);

BEGIN
select  count (*) into  L_count  from  reaflnk, retype WHERE retype.actype = substr(reaflnk.reacctno,11) AND RETYPE.rerole IN ('RM','BM','RD')  AND  afacctno
in ( select  acctno from afmast where custid =L_custid and  acctno <> L_afacctno);
 exception
  when others then
  L_count:=0;
END ;

IF L_COUNT_RE =1 THEN

--plog.error(pkgctx, 'quyet.kieu 3  L_count_re' || L_count_re);

--thong tin khach hang
  SELECT   cf.fullname , af.email,cf.custodycd , decode( CF.sex,'001','Ông/Sir','002','Bà/Madam','') sex,af.fax1, cf.address,aftype.typename		--Thuy edit 30082019
  into l_fullname,l_email, l_custodycd,l_sex  ,l_mobile,l_address, l_typename
  FROM  afmast af, cfmast cf, aftype  where af.custid = cf.custid and af.acctno =L_afacctno and af.actype=aftype.actype;



--thong tin moi gioi
 SELECT   cf.fullname,cf.mobile, cf.email into l_fullname_care, l_mobile_care,l_email_care
 FROM   cfmast cf where  cf.CUSTID =substr(L_reacctno,1,10);

l_datasource :=  ' select '''|| l_fullname_care || ''' fullname_care, '''|| l_mobile_care || ''' mobile_care, '''||l_email_care  || ''' email_care, '''||l_fullname || ''' fullname, '''|| l_custodycd || ''' custodycd, '''|| l_sex || ''' sex, '''|| l_mobile || ''' mobile, '''|| l_address || ''' address, '''|| l_typename || ''' typename, '''|| L_afacctno || ''' afacctno '||' from dual' ;

--plog.error(pkgctx, 'quyet.kieu 4  L_count' || L_count);

     if L_count > 0 then


    -- MAU TIEU KHOAN
        nmpks_ems.InsertEmailLog(l_email,
                             '0220',
                             l_datasource,
                             L_afacctno);

        else

            if substr(L_reacctno,1,10)='0001922234' or l_rerole='RD' THEN

     -- MAU KHONG BROKER
               nmpks_ems.InsertEmailLog(l_email,
                                 '0216',
                                     l_datasource,
                                     L_afacctno);
             ELSE
     -- MAU C0 BROKER
                nmpks_ems.InsertEmailLog(l_email,
                                     '0217',
                                         l_datasource,
                                        L_afacctno);
            END IF;
            if(substr(l_custodycd, 1, 4) = '091C') then
            begin
               If substr(L_afacctno,1,4) in ('0001','0002','0006','0008','0009') then
                 l_datasource:='select ''Huong dan Nop tien. Nguoi nhan: CTY CP CHUNG KHOAN KB VIET NAM. So TK 031.0101.0345.345.Tai NH Maritime Bank, CN Dong Da, Ha Noi. ND: KBSV 091Cxxx ten KH'' detail from dual';
                 nmpks_ems.InsertEmailLog(l_mobile,
                                          '4002',
                                          l_datasource,
                                          L_afacctno);
                 l_datasource:='select ''Hoac: Nguoi nhan: CTY CP CHUNG KHOAN KB VIET NAM. So TK: 1221.0000.709095. Tai NH: BIDV, CN Ha Thanh. Noi dung: 091Cxxx ten KH nop tien'' detail from dual';
                 nmpks_ems.InsertEmailLog(l_mobile,
                                          '4002',
                                          l_datasource,
                                          L_afacctno);

                 l_datasource:='select ''Hoac: Nguoi nhan: CT CP CHUNG KHOAN KB VIET NAM. So TK: 030.1000.328.888. Tai NH Vietcombank, CN Hoan Kiem, Ha Noi. Noi dung: 091Cxxx ten KH nop tien'' detail from dual';
                 nmpks_ems.InsertEmailLog(l_mobile,
                                          '4002',
                                          l_datasource,
                                          L_afacctno);

              else
                l_datasource:='select ''Huong dan Nop tien. Nguoi nhan: CHI NHANH TP HO CHI MINH - CTY CP CK KB VIET NAM. So TK:04001010168678. Tai NH: Maritime Bank, CN TPHCM. ND:KBSV 091Cxxx ten KH'' detail from dual';
                 nmpks_ems.InsertEmailLog(l_mobile,
                                          '4002',
                                          l_datasource,
                                          L_afacctno);
                l_datasource:='select ''Hoac: Nguoi nhan: CTY CP CHUNG KHOAN KB VIET NAM. So TK: 1221.0000.709095. Tai NH: BIDV, CN Ha Thanh. Noi dung: 091Cxxx ten KH nop tien'' detail from dual';
                 nmpks_ems.InsertEmailLog(l_mobile,
                                          '4002',
                                          l_datasource,
                                          L_afacctno);

                l_datasource:='select ''Hoac: Nguoi nhan: CN TPHCM - Cong ty Co phan chung khoan KB Viet Nam. So TK: 007.1000.870.455. Tai NH Vietcombank, CN TP HCM. ND:091Cxxx ten KH'' detail from dual';
                 nmpks_ems.InsertEmailLog(l_mobile,
                                          '4002',
                                          l_datasource,
                                          L_afacctno);
             end if;
            end;
            end if;
        end if;

 end if;

EXCEPTION
    WHEN others THEN
        return;
END; -- Procedure
/
