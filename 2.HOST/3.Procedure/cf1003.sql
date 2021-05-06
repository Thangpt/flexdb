CREATE OR REPLACE PROCEDURE cf1003 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   F_CUSTODYCD    IN       VARCHAR2
  )

IS
--

-- Danh sach dang ky mo TK GD co thong tin nha dau tu
-- MODIFICATION HISTORY
-- PERSON       DATE                COMMENTS
-- ---------   ------  -------------------------------------------
-- TUNH        13-05-2010           CREATED
--

    V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID     VARCHAR2 (5);                 -- USED WHEN V_NUMOPTION > 0
   V_STRCUSTODYCD VARCHAR2(10);
   v_TxDate date;


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

V_STRCUSTODYCD:=F_CUSTODYCD;
IF V_STRCUSTODYCD = 'ALL' THEN
    V_STRCUSTODYCD:='%';
END IF;

v_TxDate:= to_date(F_DATE,'DD/MM/RRRR');


-- Main report
OPEN PV_REFCURSOR FOR

select
    CF.OPNDATE,
    cf.custid, cf.custodycd, cf.fullname,
    case when substr(cf.custodycd,4,1) = 'C' then to_char(idcode) else tradingcode end idcode,
    case when substr(cf.custodycd,4,1) = 'C' then iddate else tradingcodedt end iddate,
    idplace, cf.country,
    case when A1.cdval = '001' then 1
         when A1.cdval = '002' then 2
         when A1.cdval = '005' then 3
         else                       4
    end idtype,
    case when cf.custtype = 'I' and substr(cf.custodycd,4,1) = 'C' then 3
         when cf.custtype = 'I' and substr(cf.custodycd,4,1) = 'F' then 4
         when cf.custtype = 'B' and substr(cf.custodycd,4,1) = 'C' then 5
         when cf.custtype = 'B' and substr(cf.custodycd,4,1) = 'F' then 6
    end holder_type,
    cf.address, cf.mobile, cf.email
    ,a2.cdcontent country_name
    ,max(case when m.mrtype = 'T' then 'Y' else ' ' end) mrtype
    , case when cf.custtype = 'I' and substr(cf.custodycd,4,1) <> 'F' then 'CNTN'
         when cf.custtype = 'I' and substr(cf.custodycd,4,1) = 'F' then 'CNNN'
         when cf.custtype = 'B' and substr(cf.custodycd,4,1) <> 'F' then 'TCTN'
         when cf.custtype = 'B' and substr(cf.custodycd,4,1) = 'F' then 'TCNN'
    end LH_CD
    , a1.cdcontent loai_DKSH

from cfmast cf, allcode A1, allcode a2, afmast af, aftype t, mrtype m
where cf.idtype = A1.cdval and A1.cdtype = 'CF' and A1.cdname = 'IDTYPE'
    and custodycd is not null
    AND CUSTODYCD LIKE V_STRCUSTODYCD
    and a2.cdtype = 'CF' and a2.cdname = 'COUNTRY' and cf.country = a2.cdval
    --and af.opndate = v_TxDate
    and cf.status='A'
    and af.custid = cf.custid and af.actype = t.actype
    and t.mrtype = m.actype
    and  (Substr(cf.custid,1,4) LIKE V_STRBRID OR instr(V_STRBRID,Substr(cf.custid,1,4))<> 0)
    and CF.OPNDATE BETWEEN TO_DATE(F_DATE ,'DD/MM/YYYY') AND TO_DATE(T_DATE ,'DD/MM/YYYY')
group by
    CF.OPNDATE,
    cf.custid, cf.custodycd, cf.fullname,
    case when substr(cf.custodycd,4,1) = 'C' then to_char(idcode) else tradingcode end ,
    case when substr(cf.custodycd,4,1) = 'C' then iddate else tradingcodedt end ,
    idplace, cf.country,
    case when A1.cdval = '001' then 1
         when A1.cdval = '002' then 2
         when A1.cdval = '005' then 3
         else                       4
    end ,
    case when cf.custtype = 'I' and substr(cf.custodycd,4,1) = 'C' then 3
         when cf.custtype = 'I' and substr(cf.custodycd,4,1) = 'F' then 4
         when cf.custtype = 'B' and substr(cf.custodycd,4,1) = 'C' then 5
         when cf.custtype = 'B' and substr(cf.custodycd,4,1) = 'F' then 6
    end ,
    cf.address, cf.mobile, cf.email
    ,a2.cdcontent
    , case when cf.custtype = 'I' and substr(cf.custodycd,4,1) <> 'F' then 'CNTN'
         when cf.custtype = 'I' and substr(cf.custodycd,4,1) = 'F' then 'CNNN'
         when cf.custtype = 'B' and substr(cf.custodycd,4,1) <> 'F' then 'TCTN'
         when cf.custtype = 'B' and substr(cf.custodycd,4,1) = 'F' then 'TCNN'
    end
    , a1.cdcontent

union all

select
    CF.OPNDATE,
    cf.custid, cf.custodycd, cf.fullname,
    case when substr(cf.custodycd,4,1) = 'C' then to_char(idcode) else tradingcode end idcode,
    case when substr(cf.custodycd,4,1) = 'C' then iddate else tradingcodedt end iddate,
    idplace, cf.country,
    case when A1.cdval = '001' then 1
         when A1.cdval = '002' then 2
         when A1.cdval = '005' then 3
         else                       4
    end idtype,
    case when cf.custtype = 'I' and substr(cf.custodycd,4,1) = 'C' then 3
         when cf.custtype = 'I' and substr(cf.custodycd,4,1) = 'F' then 4
         when cf.custtype = 'B' and substr(cf.custodycd,4,1) = 'C' then 5
         when cf.custtype = 'B' and substr(cf.custodycd,4,1) = 'F' then 6
    end holder_type,
    cf.address, cf.mobile, cf.email
    , a2.cdcontent country_name
    , max(case when m.mrtype = 'T' then 'Y' else ' ' end) mrtype
    , case when cf.custtype = 'I' and substr(cf.custodycd,4,1) <> 'F' then 'CNTN'
         when cf.custtype = 'I' and substr(cf.custodycd,4,1) = 'F' then 'CNNN'
         when cf.custtype = 'B' and substr(cf.custodycd,4,1) <> 'F' then 'TCTN'
         when cf.custtype = 'B' and substr(cf.custodycd,4,1) = 'F' then 'TCNN'
    end LH_CD
    , a1.cdcontent loai_DKSH

from cfmast cf,allcode A1, afmast af, allcode a2,  aftype t, mrtype m ,
(   select msgacct acctno from tllogall where tltxcd = '0067' and txdate BETWEEN TO_DATE(F_DATE ,'DD/MM/YYYY') AND TO_DATE(T_DATE ,'DD/MM/YYYY')
        union all
    select msgacct acctno  from tllog where tltxcd = '0067' and txdate BETWEEN TO_DATE(F_DATE ,'DD/MM/YYYY') AND TO_DATE(T_DATE ,'DD/MM/YYYY')
) tl

where cf.idtype = A1.cdval and A1.cdtype = 'CF' and A1.cdname = 'IDTYPE'
    and cf.custid=af.custid and af.acctno = tl.acctno
    and custodycd is not null
    and a2.cdtype = 'CF' and a2.cdname = 'COUNTRY' and cf.country = a2.cdval
    and af.actype = t.actype
    and t.mrtype = m.actype
    AND CUSTODYCD LIKE V_STRCUSTODYCD
    and  (Substr(cf.custid,1,4) LIKE V_STRBRID OR instr(V_STRBRID,Substr(cf.custid,1,4))<> 0)
    --and af.opndate = v_TxDate
    and cf.status='A'
group by
    CF.OPNDATE,
    cf.custid, cf.custodycd, cf.fullname,
    case when substr(cf.custodycd,4,1) = 'C' then to_char(idcode) else tradingcode end ,
    case when substr(cf.custodycd,4,1) = 'C' then iddate else tradingcodedt end ,
    idplace, cf.country,
    case when A1.cdval = '001' then 1
         when A1.cdval = '002' then 2
         when A1.cdval = '005' then 3
         else                       4
    end ,
    case when cf.custtype = 'I' and substr(cf.custodycd,4,1) = 'C' then 3
         when cf.custtype = 'I' and substr(cf.custodycd,4,1) = 'F' then 4
         when cf.custtype = 'B' and substr(cf.custodycd,4,1) = 'C' then 5
         when cf.custtype = 'B' and substr(cf.custodycd,4,1) = 'F' then 6
    end ,
    cf.address, cf.mobile, cf.email
    , a2.cdcontent
    , case when cf.custtype = 'I' and substr(cf.custodycd,4,1) <> 'F' then 'CNTN'
         when cf.custtype = 'I' and substr(cf.custodycd,4,1) = 'F' then 'CNNN'
         when cf.custtype = 'B' and substr(cf.custodycd,4,1) <> 'F' then 'TCTN'
         when cf.custtype = 'B' and substr(cf.custodycd,4,1) = 'F' then 'TCNN'
    end
    , a1.cdcontent
order by custodycd
;



EXCEPTION
  WHEN OTHERS
   THEN
      RETURN;
END;
/

