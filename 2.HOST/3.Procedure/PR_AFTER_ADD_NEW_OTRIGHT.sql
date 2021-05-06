CREATE OR REPLACE PROCEDURE PR_AFTER_ADD_NEW_OTRIGHT(p_cfcustid in varchar2, p_authcustid in varchar2, p_via in varchar2)
is
 v_count number (20) :=0;
 v_valdate date;
 v_expdate date;
 l_todate date;
 l_fromdate date;
 l_authentype varchar2(2);
 l_serial varchar2(300);
 l_otright_last varchar2(10);
begin
  -- DKDV chinh chu: them moi mot kenh giao dich
  -- them kenh giao dich tuong ung voi cac tai khoan UQ cho chinh no
  if(p_cfcustid = p_authcustid and p_via <>'A') then
        -- lay thong tin khai bao cua kenh moi
        select o.authtype, o.serialnumsig, o.valdate, o.expdate
         into l_authentype,l_serial, l_fromdate,l_todate
        from otright o
        where  o.cfcustid = o.authcustid and  o.authcustid = p_authcustid and  o.deltd = 'N' and via = p_via;
        if(l_authentype = '1') then l_otright_last :='NYN';
        elsif (l_authentype = '4') then l_otright_last :='NNY';
        else l_otright_last :='YNN';
        end if;
      -- lay thong tin nhung tai khoan da UQ cho tai khoan nay
      -- chu y tinh lai ngay su dung: dam bao nam trong khoang thoi gian da khai bao (lay ben tren)
      -- MAX(valdate) MIN(EXPDATE)
     for rec in(select * from otright o
                where o.cfcustid <> o.authcustid and  o.authcustid = p_authcustid and  o.deltd = 'N' and via ='A') LOOP

             if (rec.valdate > l_fromdate) then v_valdate := rec.valdate;
             else v_valdate := l_fromdate;
             end if;

             if (rec.expdate < l_todate) then v_expdate := rec.expdate ;
             else v_expdate := l_todate;
             end if;

             insert into otright(autoid, cfcustid, authcustid, authtype, valdate, expdate, deltd, lastdate, lastchange, serialnumsig, via)
             values(SEQ_OTRIGHT.NEXTVAL,rec.cfcustid,rec.authcustid,l_authentype,v_valdate,v_expdate,'N', null, getcurrdate, l_serial, p_via );

      END LOOP;
        for rec in(select * from otrightdtl o
                where o.cfcustid <> o.authcustid and  o.authcustid = p_authcustid and  o.deltd = 'N' and via ='A') LOOP

             insert into otrightdtl(autoid, cfcustid, authcustid, otmncode, otright, deltd, via)
             values(SEQ_OTRIGHTDTL.NEXTVAL,rec.cfcustid,rec.authcustid,rec.otmncode,substr(rec.otright,1,4)||l_otright_last,'N', p_via );

      END LOOP;
   end if;
   -- xy ly case UQ mà tai khoan duoc UQ co khai bao nhieu kenh giao dich
     if(p_cfcustid <> p_authcustid and p_via ='A')then
     -- lay thong tin thoi hạn uy quyen
        select  o.valdate, o.expdate
        into  l_fromdate,l_todate
        from otright o
        where  o.cfcustid = p_cfcustid and  o.authcustid = p_authcustid and  o.deltd = 'N' and via = 'A';
     -- tim tat ca cac kenh ma nguoi duoc uy quyen da khai bao
     -- chu y tinh lai ngay su dung: dam bao nam trong khoang thoi gian da khai bao (lay ben tren)
     -- MAX(valdate) MIN(EXPDATE)
        for rec in(select * from otright o
                where o.cfcustid = o.authcustid and  o.authcustid = p_authcustid and  o.deltd = 'N' and via <>'A') LOOP

             if (rec.valdate > l_fromdate) then v_valdate := rec.valdate;
             else v_valdate := l_fromdate;
             end if;

             if (rec.expdate < l_todate) then v_expdate := rec.expdate;
             else v_expdate := l_todate;
             end if;

             insert into otright(autoid, cfcustid, authcustid, authtype, valdate, expdate, deltd, lastdate, lastchange, serialnumsig, via)
             values(SEQ_OTRIGHT.NEXTVAL,p_cfcustid,rec.authcustid,rec.authtype,v_valdate,v_expdate,'N', null, getcurrdate, rec.serialnumsig, rec.via );

      END LOOP;
      -- thong tin detail
        for rec in(select o.via, o.authtype from otright o
                where o.cfcustid = o.authcustid and  o.authcustid = p_authcustid and  o.deltd = 'N' and via <>'A') LOOP
                if(l_authentype = '1') then l_otright_last :='NYN';
                else l_otright_last :='NNY';
                end if;
             for rec1 in(select * from otrightdtl o  where o.cfcustid = p_cfcustid
                         and  o.authcustid = p_authcustid and  o.deltd = 'N' and via ='A') loop
                   insert into otrightdtl(autoid, cfcustid, authcustid, otmncode, otright, deltd, via)
                   values(SEQ_OTRIGHTDTL.NEXTVAL,rec1.cfcustid,rec1.authcustid,rec1.otmncode,substr(rec1.otright,1,4)||l_otright_last,'N', rec.via );

             END LOOP;
      END LOOP;
     end if;

end;
/
