CREATE OR REPLACE PROCEDURE re0092 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   GROUPID         IN       VARCHAR2
 )
IS
--bao cao gia tri giao dich truc tiep - nhom
--created by Chaunh at 18/01/2012
--14/03/2012 repair
    V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
    V_INBRID     VARCHAR2 (5);
    VF_DATE DATE;
    VT_DATE DATE;
    V_GROUPID varchar2(10);
    v_ten_nhom varchar2(50);
    v_autoid varchar2(50);
    v_truong_nhom varchar2(50);
    v_T_ds_dinh_muc_nhom number(20,2);
    v_doanh_so_nhom number(20,2);
    v_T_ds_vuot_dm number(20,2);
    v_hh_nhom number(20,2);

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
   ELSE V_GROUPID := '%';
   END IF;

   ------------------------
   VF_DATE := to_date(F_DATE,'DD/MM/RRRR');
   VT_DATE := to_date(T_DATE,'DD/MM/RRRR');



   select ten_nhom, autoid,truong_nhom, nvl(minirevamt,0), nvl(indirectacr,0), nvl(disdirectacr,0), nvl(commision,0)
        INTO v_ten_nhom,
            v_autoid,
            v_truong_nhom,
            v_T_ds_dinh_muc_nhom,
            v_doanh_so_nhom,
            v_T_ds_vuot_dm,
            v_hh_nhom
   from
 (SELECT regrp.custid,regrp.fullname ten_nhom, regrp.autoid, cfmast.fullname truong_nhom
        FROM regrp, cfmast
        WHERE  cfmast.custid = regrp.custid
            AND regrp.autoid LIKE V_GROUPID) gr
 left join
       (select custid, /*sum(minirevamt) minirevamt,*/sum(indirectacr) indirectacr,sum(disdirectacr) disdirectacr,sum(commision) commision
            from recommision
            where retype = 'I' AND commdate <= VT_DATE  AND commdate >= VF_DATE and refrecflnkid = V_GROUPID
            group by custid) comm
 on gr.custid = comm.custid
 left join
       (select minirevamt, custid from recommision where commdate =  (select max(commdate) from recommision where retype = 'I' AND commdate <= VT_DATE  AND commdate >= VF_DATE and refrecflnkid = V_GROUPID)
            and retype = 'I' AND commdate <= VT_DATE  AND commdate >= VF_DATE and refrecflnkid = V_GROUPID) revamt
 on revamt.custid = comm.custid
       ;


OPEN PV_REFCURSOR FOR
SELECT main.*, sokh.so_kh, V_GROUPID ma_nhom,
        v_ten_nhom ten_nhom, v_autoid autoid, v_truong_nhom truong_nhom,
        v_T_ds_dinh_muc_nhom T_ds_dinh_muc_nhom, v_doanh_so_nhom doanh_so_nhom,v_T_ds_vuot_dm T_ds_vuot_dm, v_hh_nhom hh_nhom
        FROM
    (select commdate, ten_mg, fullname, /*sum(dinh_muc_khoan)*/ dinh_muc_khoan, ty_le_dc, grpfullname, grpautoid,
        sum(gt_kh_moi) gt_kh_moi, sum(gt_kh_cu) gt_kh_cu, sum(doanh_so) doanh_so,
        sum(gtgd_vuotdm_kh_moi) gtgd_vuotdm_kh_moi, sum(gtgd_vuotdm_kh_cu) gtgd_vuotdm_kh_cu, sum(ds_vuot_dm) ds_vuot_dm, sum(ds_dinh_muc) ds_dinh_muc,
        sum(hh) hh, luong_dinh_muc, sum(luong_theo_tt_ht) luong_theo_tt_ht, sum(tong_luong) tong_luong, sum(doanh_thu_thuan) doanh_thu_thuan
    from (
        SELECT comm.commdate, comm.custid ten_mg, cfmast.fullname, regrp.fullname grpfullname, regrp.autoid grpautoid,
            (comm.mindrevamt) dinh_muc_khoan, comm.revrate ty_le_dc,
            sum(CASE WHEN retype.afstatus = 'N' THEN (comm.directacr + comm.indirectacr) else 0 END) gt_kh_moi,
            sum(CASE WHEN  retype.afstatus = 'O' THEN (comm.directacr + comm.indirectacr) else 0 END) gt_kh_cu,
            sum(round((comm.directacr + comm.indirectacr)*comm.commdays/comm.bmdays)) doanh_so, --doanh so * ngay trong thang / ngay thuc hien
            sum(CASE WHEN retype.afstatus = 'N' THEN comm.disdirectacr else 0 END) gtgd_vuotdm_kh_moi,
            sum(CASE WHEN retype.afstatus = 'O' THEN comm.disdirectacr else 0 END) gtgd_vuotdm_kh_cu,
            sum(comm.disdirectacr)   ds_vuot_dm, sum(disrevacr) ds_dinh_muc,
            sum(comm.commision) hh, comm.minincome luong_dinh_muc,
            sum(comm.revenue) doanh_thu_thuan,
            -- round(sum(comm.minincome * LEAST(1,GREATEST(comm.minratesal/100,(comm.directacr)/(comm.disrevacr+0.00001))))) luong_theo_tt_ht,
            round((case WHEN  comm.minratesal>0 then round(comm.minincome * LEAST(1,GREATEST(comm.minratesal/100,sum(comm.directacr)/(comm.mindrevamtreal+0.00001))) * comm.bmdays /comm.commdays)
                        WHEN  comm.minratesal=0 AND sum(comm.directacr)>=comm.mindrevamtreal then round(comm.minincome* comm.bmdays /comm.commdays)
                        WHEN  comm.minratesal=0 AND sum(comm.directacr) < comm.mindrevamtreal then 0 end)) luong_theo_tt_ht,
            round((case WHEN  comm.minratesal>0 then round(comm.minincome * LEAST(1,GREATEST(comm.minratesal/100,sum(comm.directacr)/(comm.mindrevamtreal+0.00001))) * comm.bmdays /comm.commdays)
                        WHEN  comm.minratesal=0 AND sum(comm.directacr)>=comm.mindrevamtreal then round(comm.minincome* comm.bmdays /comm.commdays)
                        WHEN  comm.minratesal=0 AND sum(comm.directacr) < comm.mindrevamtreal then 0 end) + comm.commision) tong_luong
         --round(sum(comm.minincome * LEAST(1,GREATEST(comm.minratesal/100,(comm.directacr)/(comm.disrevacr+0.00001))) + comm.commision)) tong_luong -- + comm.commision) tong_luong--, isdrev
        FROM recommision comm, retype, cfmast, regrp, regrplnk, recflnk
        WHERE retype.actype = comm.reactype AND comm.custid = cfmast.custid
        AND comm.commdate <= VT_DATE AND comm.commdate >= VF_DATE
        AND regrplnk.frdate <= VT_DATE AND nvl(regrplnk.clstxdate - 1, regrplnk.todate) >= VF_DATE
        AND comm.retype = 'D' and retype.rerole in ('BM')
        AND regrp.autoid = regrplnk.refrecflnkid
        AND regrplnk.reacctno = comm.acctno
        --AND regrp.autoid LIKE V_GROUPID
        AND SP_FORMAT_REGRP_MAPCODE(regrp.autoid) LIKE (CASE WHEN V_GROUPID = '%' THEN '%' ELSE SP_FORMAT_REGRP_MAPCODE(V_GROUPID)||'%' END)
        AND regrp.custid = recflnk.custid
        --AND (substr(regrp.custid,1,4) LIKE V_STRBRID OR instr(V_STRBRID,substr(regrp.custid,1,4))<> 0)
        AND (recflnk.brid LIKE V_STRBRID OR instr(V_STRBRID,recflnk.brid)<> 0)
        GROUP BY comm.commdate, comm.custid, cfmast.fullname, comm.retype, comm.mindrevamt,
        comm.minincome, comm.minratesal, comm.saltype, comm.mindrevamtreal, comm.bmdays,
        comm.commdays, comm.commision, comm.revrate, regrp.fullname, regrp.autoid
        )
    group by commdate, ten_mg, fullname,luong_dinh_muc, dinh_muc_khoan, ty_le_dc, grpfullname, grpautoid
    ) main
LEFT JOIN
(SELECT regrplnk.custid, count(*) so_kh FROM  reaflnk, regrp, regrplnk
    WHERE
     regrp.autoid = regrplnk.refrecflnkid
     AND reaflnk.reacctno = regrplnk.reacctno
    AND regrplnk.frdate <= VT_DATE AND nvl(regrplnk.clstxdate - 1, regrplnk.todate) >= VF_DATE
    AND reaflnk.frdate <= VT_DATE AND nvl(reaflnk.clstxdate - 1, reaflnk.todate) >= VF_DATE
    --AND regrp.autoid LIKE V_GROUPID
    AND SP_FORMAT_REGRP_MAPCODE(regrp.autoid) LIKE (CASE WHEN V_GROUPID = '%' THEN '%' ELSE SP_FORMAT_REGRP_MAPCODE(V_GROUPID)||'%' END)
    --AND (substr(regrp.custid,1,4) LIKE V_STRBRID OR instr(V_STRBRID,substr(regrp.custid,1,4))<> 0)
    GROUP BY regrplnk.custid ) sokh
ON sokh.custid = main.ten_mg

ORDER BY SP_FORMAT_REGRP_MAPCODE(main.grpautoid)


;
EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
End;
/

