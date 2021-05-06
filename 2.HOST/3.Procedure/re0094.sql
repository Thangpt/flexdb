CREATE OR REPLACE PROCEDURE re0094 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   GROUPID         IN       VARCHAR2
 )
IS
--bao cao danh sach moi gioi
--created by Chaunh at 16/01/2012
    V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
    V_INBRID     VARCHAR2 (5);
    VF_DATE DATE;
    VT_DATE DATE;
    V_GROUPID varchar2(10);

    V_GROUPCUSTID varchar2(20);

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

   IF GROUPID <> 'ALL' THEN
      V_GROUPID := GROUPID;
   ELSE
      V_GROUPID := '%';
   END IF;
   ------------------------
   VF_DATE := to_date(F_DATE,'DD/MM/RRRR');
   VT_DATE := to_date(T_DATE,'DD/MM/RRRR');



OPEN PV_REFCURSOR FOR
SELECT ten_moi_gioi, ma_moi_gioi, vi_tri, nhom, ma_nhom
    , ngay_vao_nhom
    , ngay_ra_nhom, cap
FROM
    (
    SELECT regrplnk.refrecflnkid ma_nhom, regrplnk.custid , reacctno ma_moi_gioi
        , cd.effdate ngay_vao_nhom --chuyen thanh ngay hieu luc moi gioi
        , nvl(cd.closedate - 1,cd.expdate) ngay_ra_nhom --chuyen thanh ngay het hieu luc moi gioi
        , to_char(allcode.cdcontent)||' - '||to_char(a2.cdcontent) vi_tri
        FROM regrplnk, retype, allcode, allcode a2, recfdef cd, recflnk cl
        WHERE retype.actype = substr(regrplnk.reacctno,11,4)
        and cl.autoid = cd.refrecflnkid and cl.custid || cd.reactype = regrplnk.reacctno
        AND a2.cdtype = 'RE' AND a2.cdname = 'AFSTATUS' AND a2.cdval = retype.afstatus
        AND allcode.cdtype= 'RE' AND allcode.cdname = 'REROLE' AND allcode.cdval = retype.rerole
        AND nvl(clstxdate - 1,todate) >= VF_DATE AND frdate <= VT_DATE
        and nvl(cd.closedate -1 , cd.expdate) >= VF_DATE and cd.effdate <= VT_DATE
    UNION --truong nhom
    SELECt autoid ma_nhom, custid, custid||actype ma_moi_gioi, nvl(effdate,'30-Dec-1899') ngay_vao_nhom
        , nvl(expdate,'30-Dec-1899') ngay_ra_nhom, 'Truong phong' vi_tri  FROM regrp
        WHERE regrp.effdate <= VT_DATE AND regrp.expdate >= VF_DATE
    ) broker
    LEFT JOIN
    (SELECT autoid, fullname nhom, SP_FORMAT_REGRP_MAPCODE(autoid) cap FROM regrp) grp
    ON broker.ma_nhom = grp.autoid
    LEFT JOIN
    (SELECT custid, fullname ten_moi_gioi FROM cfmast) cf
    ON broker.custid = cf.custid
WHERE cap LIKE (CASE WHEN V_GROUPID = '%' THEN '%' ELSE SP_FORMAT_REGRP_MAPCODE(V_GROUPID)||'%' END)
ORDER BY cap, vi_tri DESC
;
EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
End;
/

