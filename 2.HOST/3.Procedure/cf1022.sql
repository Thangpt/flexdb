CREATE OR REPLACE PROCEDURE cf1022 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   P_CUSTODYCD      IN       VARCHAR2,
   P_ISHAVERE       in      varchar2

)
IS

  V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID     VARCHAR2 (5);             -- USED WHEN V_NUMOPTION > 0
   V_CUSTODYCD        varchar2 (10);
-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
-- insert into temp_bug(text) values('CF0001');commit;
    V_STROPTION := upper(OPT);
   V_INBRID := BRID;

   if(V_STROPTION = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := BRID;
        end if;
    end if;


   IF (P_CUSTODYCD <> 'ALL')
   THEN
      V_CUSTODYCD:= P_CUSTODYCD;
   ELSE
      V_CUSTODYCD := '%%';
   END IF;
if P_ISHAVERE = 'Y' then
    OPEN PV_REFCURSOR
    FOR
    select   V_INBRID chi_nhanh, A.*,  nvl(rc.fullname,' ') re_name, nvl(rc.mobile,' ') re_mobile, nvl(rc.phone, ' ') re_phone, nvl(rc.email,' ') re_email
    from
    (
        select  c.fullname cus_name, c.custodycd cus_custo, nvl(c.mobile, c.phone) cus_phone, c.address cus_address, min(a.opndate) opndate
                , max(r.recustid) recustid
        from
             cfmast c, afmast a
            ,
            (select substr(r.reacctno,1,10) recustid, r.afacctno from reaflnk r, retype e where r.frdate <= to_date(T_DATE, 'DD/MM/RRRR')
                                and nvl(r.clstxdate - 1,r.todate) >= to_date(F_DATE,'DD/MM/RRRR') and substr(r.reacctno,11,4) = e.actype and e.rerole in ('BM','RM')
            )r
        where c.custid = a.custid and  a.acctno =  r.afacctno (+)
        --and a.opndate <= to_date(T_DATE, 'DD/MM/RRRR') and a.opndate >= to_date(F_DATE,'DD/MM/RRRR')
        and c.custodycd like   V_CUSTODYCD
        and  (Substr(c.custid,1,4) LIKE V_STRBRID OR instr(V_STRBRID,Substr(c.custid,1,4))<> 0)
        group by  c.fullname , c.custodycd , nvl(c.mobile, c.phone) , c.address
        having min(a.opndate) <= to_date(T_DATE, 'DD/MM/RRRR') and min(a.opndate) >= to_date(F_DATE,'DD/MM/RRRR')
    ) A
    , cfmast RC
    where a.recustid = RC.custid (+)

    /*select V_INBRID chi_nhanh, c.fullname cus_name, c.custodycd cus_custo, nvl(c.mobile, c.phone) cus_phone, c.address cus_address,
           nvl(rc.fullname,' ') re_name, nvl(rc.mobile,' ') re_mobile, nvl(rc.phone, ' ') re_phone, nvl(rc.email,' ') re_email
    from cfmast c, afmast a,
        (select * from reaflnk r, retype e where r.frdate <= to_date(T_DATE, 'DD/MM/RRRR')
                            and nvl(r.clstxdate - 1,r.todate) >= to_date(F_DATE,'DD/MM/RRRR') and substr(r.reacctno,11,4) = e.actype and e.rerole in ('BM','RM')
        )r, cfmast rc
    where c.custid = a.custid and  a.acctno =  r.afacctno (+)
    and a.opndate <= to_date(T_DATE, 'DD/MM/RRRR') and a.opndate >= to_date(F_DATE,'DD/MM/RRRR')
    and substr(r.reacctno,1,10) = rc.custid (+)
    and c.custodycd like V_CUSTODYCD*/
;
ELSE
    OPEN PV_REFCURSOR
    FOR
    select V_INBRID chi_nhanh, c.fullname cus_name, c.custodycd cus_custo, nvl(c.mobile, c.phone) cus_phone, c.address cus_address,
           ' ' re_name,' ' re_mobile,  ' ' re_phone, ' ' re_email
    from cfmast c, afmast a
    where c.custid = a.custid
    and  (Substr(c.custid,1,4) LIKE V_STRBRID OR instr(V_STRBRID,Substr(c.custid,1,4))<> 0)
    --and a.opndate <= to_date(T_DATE, 'DD/MM/RRRR') and a.opndate >= to_date(F_DATE,'DD/MM/RRRR')
    and c.custodycd like V_CUSTODYCD
    group by c.fullname , c.custodycd , nvl(c.mobile, c.phone) , c.address
    having min(a.opndate) <= to_date(T_DATE, 'DD/MM/RRRR') and min(a.opndate) >= to_date(F_DATE,'DD/MM/RRRR')
;
end if;



 EXCEPTION
   WHEN OTHERS
   THEN
    --insert into temp_bug(text) values('CF0001');commit;
      RETURN;
END;                                                              -- PROCEDURE
/

