CREATE OR REPLACE PROCEDURE re0089_1 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   SEARCHDATE         IN       VARCHAR2,
   --CUSTODYCD         IN       VARCHAR2,
   REROLE         IN       VARCHAR2,
   V_TLID         IN VARCHAR2,
   P_DSF            in varchar2
 )
IS
--bao cao Danh sach tai khoan do moi gioi quan ly
--created by Chaunh at 10/01/2012
    V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID     VARCHAR2 (5);

    V_SEARCHDATE date;
    --V_CUSTODYCD varchar2(10);
    V_REROLE varchar2(4);
    V_REERNAME varchar2(50);
    v_dsf varchar2(14);
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

    if P_DSF = 'ALL' or P_DSF is null then
        v_dsf := '%';
    else
        v_dsf := P_DSF;
    end if;

   ------------------------
   IF (REROLE <> 'ALL')
   THEN
    V_REROLE := REROLE;
   ELSE
    V_REROLE := '%';
   END IF;
   -----------------------
   --V_CUSTODYCD := CUSTODYCD;
   --V_REERNAME := 'ALL';

    BEGIN
        SELECT cf.fullname INTO V_REERNAME FROM cfmast cf, reuserlnk ru, recflnk rc
               WHERE ru.refrecflnkid = rc.autoid AND cf.custid = rc.custid AND ru.tlid = V_TLID;
    EXCEPTION
    WHEN OTHERS THEN
      V_REERNAME := ' ';
    END ;

   ------------------------------
   V_SEARCHDATE := to_date(SEARCHDATE, 'dd/MM/RRRR');


OPEN PV_REFCURSOR FOR
select * from (
SELECT txdate, txnum, so_tk_kh , custid, so_tk_MG, frdate, todate, ten_kh, cust_kh, custid_mg, retype||' _ '||vai_tro as retype,
nvl(ten_truong_nhom,' ') ten_truong_nhom, afstatus, rerole, V_SEARCHDATE searchdate, pa_role, V_REERNAME ten_mg, ten_nhom,
nvl(dsf.dsfname, ' ') dsfname, nvl(dsf.reacctno, ' ') dsfacctno

FROM
    (SELECT kh.frdate txdate, kh.txnum, kh.afacctno so_tk_kh, mg.custid, kh.reacctno so_tk_MG, --cf1.valdate frdate,
    NVL(CF1.opndate,cf1.activedate) frdate,
     kh.todate,
        cf1.fullname ten_kh, cf2.fullname ten_mg, RETYPE.afstatus, mg.autoid, retype.rerole, allcode.cdcontent vai_tro,
        cf1.custodycd cust_kh, cf2.custid custid_mg, retype.actype retype, (CASE WHEN V_REROLE = '%' THEN '%' ELSE to_char(allcode.cdcontent) END) pa_role
    FROM reaflnk kh,recflnk mg,
        afmast af,cfmast cf1, cfmast cf2, retype, allcode, reuserlnk reu
    WHERE kh.refrecflnkid = mg.autoid
        AND allcode.cdtype = 'RE' AND allcode.cdname = 'REROLE' AND allcode.cdval = retype.rerole
        AND kh.deltd <> 'Y'
        AND cf1.custid = af.custid AND af.acctno = kh.afacctno
        AND cf2.custid = mg.custid
        AND V_SEARCHDATE <= to_date(nvl(kh.clstxdate - 1,kh.todate), 'dd/MM/RRRR')
        AND V_SEARCHDATE >= to_date(kh.frdate, 'dd/MM/RRRR')
        AND substr(kh.reacctno, 11,4) = retype.actype
        AND reu.refrecflnkid = mg.autoid AND reu.tlid = V_TLID
        AND (mg.brid LIKE V_STRBRID OR instr(V_STRBRID,mg.brid)<> 0)
        ) a
    LEFT JOIN --truong nhom
    (SELECT cfmast.fullname ten_truong_nhom, tn.fullname ten_nhom, nhom.reacctno FROM regrplnk nhom, regrp tn, cfmast
    WHERE tn.autoid = nhom.refrecflnkid AND V_SEARCHDATE between nhom.frdate and nvl(nhom.clstxdate - 1, nhom.todate)
        AND tn.custid = cfmast.custid
        --AND (substr(cfmast.custid,1,4) LIKE V_STRBRID OR instr(V_STRBRID,substr(cfmast.custid,1,4))<> 0)
        ) b
    ON a.so_tk_mg = b.reacctno
    left join -- dsf
    (
        select re.afacctno, cf.fullname || ' - ' || rt.typename dsfname, re.reacctno from reaflnk re, retype rt, cfmast cf
        where substr(re.reacctno, 1,10) = cf.custid and substr(re.reacctno, 11,4)  = rt.actype and rt.rerole = 'RD' and v_searchdate BETWEEN re.frdate and nvl(re.clstxdate -1, re.todate)
    ) dsf
    on dsf.afacctno = a.so_tk_kh
WHERE  rerole LIKE V_REROLE
and V_SEARCHDATE <= to_date(todate, 'dd/MM/RRRR')
AND V_SEARCHDATE >= to_date(frdate, 'dd/MM/RRRR')
ORDER BY txdate
)
where dsfacctno like v_dsf
    ;
EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
End;
/

