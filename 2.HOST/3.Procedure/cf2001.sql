CREATE OR REPLACE PROCEDURE cf2001 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTID        in      varchar2,
   PV_CUSTODYCD     IN       VARCHAR2,
   PV_AFACCTNO      IN       VARCHAR2,
   PV_CNTCHANGED      IN       VARCHAR2
 )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE       COMMENTS
-- Chaunh      05/03/2012  created
-- ---------   ------     -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (4);        -- USED WHEN V_NUMOPTION > 0
   V_INBRID     VARCHAR2 (5);
   v_CustodyCD      varchar2(10);
   v_AfAcctno       varchar2(10);
   v_custid         varchar2(10);
   v_cntchanged     varchar2(20);
   BEGIN

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
    if PV_CUSTID = 'ALL' or PV_CUSTID is null then
        v_custid := '%';
    else
        v_custid := PV_CUSTID;
    end if;

    if PV_CUSTODYCD = 'ALL' or PV_CUSTODYCD is null then
        v_CustodyCD := '%';
    else
        v_CustodyCD := PV_CUSTODYCD;
    end if;

    if PV_AFACCTNO = 'ALL' or PV_AFACCTNO is null then
        v_AFAcctno := '%';
    else
        v_AFAcctno := PV_AFACCTNO;
    end if;

    if PV_CNTCHANGED = 'ALL' then
        v_cntchanged := '%';
    else
        v_cntchanged := PV_CNTCHANGED;
    end if;




OPEN PV_REFCURSOR
  FOR
select * from
(select af.custid, af.acctno afacctno,af.custodycd,a.* from
    (
    select nvl(t1.tlfullname, t1.tlname) maker, m.maker_dt, m.maker_time,
    nvl(t2.tlfullname, t2.tlname) approver, m.approve_dt,
    case when m.from_value is null then 'New'
         else m.action_flag end thuc_hien ,   m.from_Value, m.to_value,
    case when m.record_key is not null then substr(m.record_key,instr(m.record_key,'0'), 10)
         else m.record_key end stk,
     case when m.record_key is not null then substr(m.record_key,1,6)
         else m.record_key end acctno,
    m.action_flag,
    LOWER(replace((select min(caption) cap from fldmaster
                 where   objname like '%'||nvl(m.child_table_name,m.table_name)||'%' and fldname like m.column_name
                 ),':',' '
             ))  noi_dung,
    case when m.column_name in ('PHONE','MOBILE','FULLNAME','IDCODE','IDDATE','IDPLACE','EMAIL','ADDRESS','AFTYPE') then m.column_name
        else 'OTHERS' end cntchanged,
    ' ' tltxcd
    from maintain_log m, tlprofiles t1, tlprofiles t2
    where m.maker_id = t1.tlid(+) and m.approve_id = t2.tlid(+)
    and m.maker_dt <= to_date(T_DATE,'DD/MM/RRRR') and m.maker_dt >= to_date(F_DATE,'DD/MM/RRRR')
    union all
    select nvl(t1.tlfullname, t1.tlname) maker, t.txdate maker_dt,t.txtime maker_time,nvl(t2.tlfullname, t2.tlname) approver,t.brdate approve_dt,
        'EDIT' thuc_hien,' ' from_value,' ' to_value,t.msgacct stk,'CUSTID' acctno,'EDIT' action_flag,
        case when t.tltxcd = '0090' then 'mat khau online'
             when t.tltxcd = '0089' then 'mat khau dien thoai' end  noi_dung,
        case when t.tltxcd = '0090' then 'PASSWORDINT'
             when t.tltxcd = '0089' then 'PASSWORDTEL' end cntchanged,
        t.tltxcd
    from vw_tllog_all t, tlprofiles t1, tlprofiles t2
    where t.tltxcd in ('0090','0089') and t.tlid = t1.tlid(+) and t.offid = t2.tlid(+)
    and t.txdate <= to_date(T_DATE,'DD/MM/RRRR') and t.txdate >= to_date(F_DATE,'DD/MM/RRRR')
    ) a
    left join (select af.*, cf.custodycd from  afmast af, cfmast cf where cf.custid = af.custid) af
    on a.stk = (case when a.acctno = 'CUSTID' then af.custid
                    when a.acctno = 'ACCTNO' then af.acctno end)
)
where nvl(custodycd,' ') like v_CustodyCD
and nvl(custid, ' ') like v_custid
and nvl(afacctno, ' ') like v_afacctno
and cntchanged like v_cntchanged
AND (substr(nvl(custid,' '),1,4) LIKE V_STRBRID OR instr(V_STRBRID,substr(nvl(custid,' '),1,4))<> 0)
;

EXCEPTION
   WHEN OTHERS
   THEN

      RETURN;
End;
/

