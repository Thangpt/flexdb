create or replace function FN_GET_EMAILMG(str_afacctno in varchar2,
                                          str_type     in varchar2)
  return varchar2 is
  l_str_email varchar2(1000);
  l_str_name  varchar2(100);
  l_str       varchar2(200);
  l_emailpcc  varchar2(1000);
  l_emailcn   varchar2(1000);
  l_emailnv   varchar2(1000);
  l_cusid     varchar2(10);
  l_tlid      varchar2(10);
begin
  l_str := ' ';
  --- lay ten va email moi gioi
  if (str_type = 'NAME' or str_type = 'EMAIL' or str_type = 'EMAILPCC' or
     str_type = 'EMAILCN' or str_type = 'EMAILNV') then
    select tp.email emailibr,
           tp.tlfullname,
           substr(reff.reacctno, 0, 10),
           tp.tlid
      into l_str_email, l_str_name, l_cusid, l_tlid
      from recflnk rec,
           tlprofiles tp,
           (select re.afacctno, max(cf.fullname) refullname, re.reacctno
              from reaflnk re, sysvar sys, cfmast cf, RETYPE
             where to_date(varvalue, 'DD/MM/RRRR') between re.frdate and
                   re.todate
               and substr(re.reacctno, 0, 10) = cf.custid
               and varname = 'CURRDATE'
               and grname = 'SYSTEM'
               and re.status <> 'C'
               and re.deltd <> 'Y'
               AND substr(re.reacctno, 11) = RETYPE.ACTYPE
               AND rerole IN ('RM', 'BM')
               and afacctno = str_afacctno
             GROUP BY AFACCTNO, reacctno) reff
     where substr(reff.reacctno, 0, 10) = rec.custid
       and rec.reftlid = tp.tlid
       and reff.afacctno = str_afacctno;
  end if;
  if (str_type = 'EMAILPCC') then
    -- lay cusid cua giam doc PCC cua user moi gioi
    SELECT regrp.custid
      into l_cusid
      FROM REGRPLNK tlgr, recflnk re, REGRP
     WHERE re.custid = tlgr.custid
       AND RE.REFTLID = l_tlid
       AND TLGR.STATUS = 'A'
       AND regrp.autoid = tlgr.refrecflnkid
       AND re.effdate <= getcurrdate
       AND re.expdate >= getcurrdate
       AND tlgr.frdate <= getcurrdate
       AND tlgr.todate >= getcurrdate
     Group by regrp.custid;
    --  lay email cua giam doc pcc
    select max(u.email)
      into l_emailpcc
      from recflnk k, tlprofiles u
     where k.custid = l_cusid
       and k.reftlid = u.tlid;
  end if;
  -- lay  email giam doc chi nhanh, email nghiep vu
  if (str_type = 'EMAILCN' or str_type = 'EMAILNV') then
    --- lay pcc quang ly moi gioi de kiem  tra
    begin
      /* SELECT regrp.custid
        into l_cusid
        FROM REGRPLNK tlgr, recflnk re, REGRP
       WHERE re.custid = tlgr.custid
         AND RE.REFTLID = l_tlid
         AND TLGR.STATUS = 'A'
         AND regrp.autoid = tlgr.refrecflnkid
         AND re.effdate <= getcurrdate
         AND re.expdate >= getcurrdate
         AND tlgr.frdate <= getcurrdate
         AND tlgr.todate >= getcurrdate
       Group by regrp.custid;
      --- lay giam doc chi nhanh theo giam doc pcc
      select u.email, u.ccemail
        into l_emailcn, l_emailnv
        from afmast af, usert0limit u
       where af.brid = u.brid
         and u.tltitle = '002'
         and u.period = 0
         and af.custid = l_cusid
         Group by u.email, u.ccemail;*/
      select u.email, u.ccemail
        into l_emailcn, l_emailnv
        from (SELECT regrp.custid, re1.reftlid, tl.brid, tl.email
                FROM REGRPLNK   tlgr,
                     recflnk    re,
                     REGRP,
                     recflnk    re1,
                     tlprofiles tl
               WHERE re.custid = tlgr.custid
                 and regrp.custid = re1.custid
                 and re1.reftlid = tl.tlid
                 AND RE.REFTLID = l_tlid
                 AND TLGR.STATUS = 'A'
                 AND regrp.autoid = tlgr.refrecflnkid
                 AND re.effdate <= getcurrdate
                 AND re.expdate >= getcurrdate
                 AND tlgr.frdate <= getcurrdate
                 AND tlgr.todate >= getcurrdate
               Group by regrp.custid, re1.reftlid, tl.brid, tl.email) y,
             usert0limit u
       where u.brid = y.brid
         and u.tltitle = '002'
         and u.period = 0;
    EXCEPTION
      WHEN OTHERS THEN
        -- truong hop moi gioi chua duoc gan vao pcc nao thi lay email giam doc chi nhanh theo MG
        select u.email, u.ccemail
          into l_emailcn, l_emailnv
          from tlprofiles tl, usert0limit u
         where tl.brid = u.brid
           and u.tltitle = '002'
           and u.period = 0
           and tl.tlid = l_tlid;
    end;

  end if;

  if str_type = 'EMAIL' then
    l_str := l_str_email;
  elsif str_type = 'NAME' then
    l_str := l_str_name;
  elsif str_type = 'EMAILCN' then
    l_str := l_emailcn;
  elsif str_type = 'EMAILPCC' then
    l_str := l_emailpcc;
  elsif str_type = 'EMAILNV' then
    l_str := l_emailnv;
  end if;
  return l_str;
EXCEPTION
  WHEN OTHERS THEN
    RETURN '';
end FN_GET_EMAILMG;
/

