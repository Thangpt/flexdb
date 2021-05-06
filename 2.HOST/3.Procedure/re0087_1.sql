CREATE OR REPLACE PROCEDURE re0087_1
 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   INMONTH        IN       VARCHAR2,
   V_GROUPID      IN       VARCHAR2,
   PV_TLID        IN       VARCHAR2
 )
IS
--bao cao danh sach moi gioi
--created by Chaunh at 16/01/2012
    V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID          VARCHAR2 (40);    -- USED WHEN V_NUMOPTION > 0
    V_INBRID     VARCHAR2 (5);
    VF_DATE DATE;
    VT_DATE DATE;
    --V_GROUPID varchar2(10);
    V_CUSTID VARCHAR2(10);
    v_strtlid varchar2(1000);
    l_format VARCHAR2(10);
    l_segment VARCHAR2(20);
    l_length NUMBER;
    V_INMONTH VARCHAR2(10);

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
   ------------------------
   VF_DATE := TO_DATE('01/' || SUBSTR(INMONTH,1,2) || '/' || SUBSTR(INMONTH,3,4),'DD/MM/YYYY');
   VT_DATE := LAST_DAY(TO_DATE('01/' || SUBSTR(INMONTH,1,2) || '/' || SUBSTR(INMONTH,3,4),'DD/MM/YYYY'));
   V_INMONTH := SUBSTR(INMONTH,1,2) || '/' || SUBSTR(INMONTH,3,4);

OPEN PV_REFCURSOR FOR

        SELECT max(cf.fullname) ten_moi_gioi, tran.acctno ma_moi_gioi, br.vi_tri vi_tri,
            max(grp.grname) ten_nhom, br.ma_nhom ma_nhom, ten_truong_nhom, a.cdcontent || ' _ ' || ret.typename chuc_vu,
            br.grpcode cap, V_INMONTH rerole,
            sum(tran.intbal) doanh_so,
            sum(tran.intamt) phi_thuc_thu,
            sum( tran.rfmatchamt + tran.rffeeacr + tran.lmn + tran.disposal) phi_giam_tru,
            nvl(rd.commision,0) phi_DSF,
            CASE WHEN rerole = 'BM' THEN 01
                    WHEN rerole = 'RM' THEN 02
                    WHEN rerole = 'AE' THEN 03
                    WHEN rerole = 'RD' THEN 04
                    ELSE 05
            END orderid
        FROM
            (
                SELECT * FROM reinttrana
                WHERE todate >= VF_DATE AND todate <= VT_DATE --AND acctno = '00019216323001'
                    AND inttype = 'DBR'
                union ALL
                SELECT * FROM reinttran
                WHERE todate >= VF_DATE AND todate <= VT_DATE --AND acctno = '00019216323001'
                    AND inttype = 'DBR'
            ) tran,
            (
                SELECT re.autoid ma_nhom, re.fullname grname, re.custid||re.actype acctno, cf.fullname ten_truong_nhom, rcf.autoid,
                    re.custid custid, re.actype, re.effdate frdate, re.expdate todate, 'Truong phong' vi_tri--, SP_FORMAT_REGRP_MAPCODE(autoid) grpcode
                FROM regrp re, cfmast cf, recflnk rcf WHERE re.custid = cf.custid AND re.custid = rcf.custid
                UNION all
                SELECT re.autoid ma_nhom, re.fullname grname, re.custid||re.actype acctno, cf.fullname ten_truong_nhom, rcf.autoid,
                    re.custid custid, re.actype, re.effdate frdate, re.expdate todate, 'Truong phong' vi_tri--, SP_FORMAT_REGRP_MAPCODE(autoid) grpcode
                FROM regrphist re, cfmast cf, recflnk rcf WHERE re.custid = cf.custid AND re.custid = rcf.custid
            ) grp,
            (
                SELECT rgl.refrecflnkid ma_nhom, rg.fullname grname, rgl.reacctno acctno, rgl.custid custid, substr(reacctno,11,4) actype, rgl.frdate,
                    nvl(rgl.clstxdate - 1,rgl.todate) todate, 'Nhan vien' vi_tri, SP_FORMAT_REGRP_MAPCODE(rgl.refrecflnkid) grpcode
                FROM regrplnk rgl, regrp rg
                WHERE rgl.refrecflnkid = rg.autoid
            ) br,
            retype ret, allcode a, recflnk rcf, cfmast cf,
            (
                SELECT reacctno, sum(commision) commision FROM rerevdg rd WHERE rd.commdate >= VF_DATE AND commdate <= VT_DATE
                GROUP BY reacctno
            ) rd
        where  br.acctno = tran.acctno
            AND rcf.custid = cf.custid AND br.acctno = rd.reacctno(+)
            AND br.ma_nhom = grp.ma_nhom
            AND br.frdate <= tran.todate AND br.todate >= tran.todate
            AND grp.frdate <= tran.todate AND grp.todate >= tran.todate
            AND br.custid = rcf.custid AND grp.autoid IN (SELECT u.refrecflnkid FROM reuserlnk u WHERE tlid = PV_TLID)
            AND ret.actype = br.actype
            AND a.cdtype= 'RE' AND a.cdname = 'REROLE' AND a.cdval = ret.rerole
            AND (rcf.brid LIKE V_STRBRID OR instr(V_STRBRID,rcf.brid)<> 0)
            AND br.ma_nhom LIKE V_GROUPID
            AND tran.intbal <> 0
        GROUP BY tran.acctno, br.vi_tri,ret.rerole,ret.actype,br.ma_nhom, a.cdcontent, br.grpcode, rd.commision, ten_truong_nhom,
            ret.typename
        ORDER BY br.grpcode, br.vi_tri,
            CASE WHEN rerole = 'BM' THEN 01
                    WHEN rerole = 'RM' THEN 02
                    WHEN rerole = 'AE' THEN 03
                    WHEN rerole = 'RD' THEN 04
                    ELSE 05
            END,ret.actype



/*
select vi_tri, ma_nhom, ten_truong_nhom, chuc_vu, cap, ten_moi_gioi, mg, rerole, vai_tro, orderid,
    sum(phi_thuc_thu) phi_thuc_thu, sum(phi_giam_tru) phi_giam_tru, sum(phi_DSF) phi_DSF,
    sum(doanh_so) doanh_so
from
(
select
'Nhan vien' vi_tri, ma_nhom, ten_nhom, ten_truong_nhom, a.cdcontent || ' _ ' || typename chuc_vu
    ,SP_FORMAT_REGRP_MAPCODE(ma_nhom) cap ,c2.fullname ten_moi_gioi
    , custid_mg || r.actype mg, rerole,  a.cdcontent vai_tro
    --so_tk_kh, so_tk_mg,  custid_mg, retype, r.actype, rdtype, rdcustid,
    --c1.fullname ten_kh, c1.custodycd cust_kh, c2.fullname ten_moi_gioi, retype ||'-' || a.cdcontent pa_role
    ,CASE WHEN rerole = 'BM' THEN 01
                    WHEN rerole = 'RM' THEN 02
                    WHEN rerole = 'AE' THEN 03
                    WHEN rerole = 'RD' THEN 04
                    ELSE 05
                    END orderid
    , sum(nvl(execamt,0)) doanh_so, sum(nvl(feeacr,0)) phi_thuc_thu
    , sum(nvl(execamt,0) * DECODE(rf.CALTYPE,'0001',Rf.RERFRATE,0)/100) --phi_giam_tru_ds
        + sum(nvl(feeacr,0) * DECODE(rf.CALTYPE,'0002',rf.RERFRATE,0)/100)-- phi_giam_tru_dt
        phi_giam_tru
    , nvl(case when rerole <> 'RD' and ispaydsf = 'Y' then
               (case when   ruletype = 'T'--decode(ruletype,'T',0,( sum(feeacr) -    sum(execamt) * DECODE(Rf.CALTYPE,'0001',rf.RERFRATE,0)/100) * icrate / 100) = 0
                            --neu loai tinh phi la bac thang
                            then   ( sum(nvl(feeacr,0)) -  sum(nvl(execamt,0) * DECODE(rf.CALTYPE,'0001',Rf.RERFRATE,0)/100)) * fn_idelta_rd(rdcustid, VF_DATE, VT_DATE) / 100

                        else --truong hop loai tinh hoa hong la co dinh
                             --phi DSF = (phi giao dich - phi giam tru) * ty le phi /100 = hoa hong dsf
                             decode(ruletype,'T',0,( sum(nvl(feeacr,0)) -    sum(nvl(execamt,0)) * DECODE(Rf.CALTYPE,'0001',rf.RERFRATE,0)/100) * icrate / 100)
                   end
                   )
          else 0
          end,0)  phi_DSF
    /*, c3.fullname ten_mg_lq*
from
(

SELECT  kh.afacctno so_tk_kh, mg.custid, kh.reacctno so_tk_MG, retype.rerole,  mg.custid custid_mg,
        retype.typename retype, od.execamt, od.feeacr, od.sectype, retype.typename,
        retype.actype,  substr(rd.reacctno,11,4) rdtype, substr(rd.reacctno,1,10) rdcustid , rd.icrate, rd.ruletype, rd.rerole rdrerole, ispaydsf,
        g.*
    FROM reaflnk kh,recflnk mg,recfdef,retype,-- rerfee,
        (select to_char(g.refrecflnkid) ma_nhom, g.reacctno, r.fullname ten_nhom, c.fullname ten_truong_nhom, g.clstxdate, g.todate, g.frdate
                from regrplnk g, regrp r, cfmast c, /*reuserlnk u,*recflnk d
                where g.refrecflnkid = r.autoid and c.custid = r.custid and d.custid = r.custid
                and g.refrecflnkid = V_GROUPID
                --and instr(v_strtlid,to_char(d.autoid)) <> 0
                and instr(v_strtlid,SUBSTR(l_format || to_char(d.autoid), length(l_format || to_char(d.autoid))-l_length+1,l_length)) <> 0
                --= u.refrecflnkid  and u.tlid = PV_TLID
        ) g,
        (select OD.* , sb.sectype from
            (SELECT afacctno, txdate, execamt EXECAMT, feeacr, codeid FROM odmast WHERE deltd <> 'Y' and execamt <> 0
            UNION ALL SELECT afacctno, txdate, execamt EXECAMT, feeacr, codeid FROM odmasthist WHERE deltd <> 'Y' and execamt <> 0) OD, sbsecurities sb
        where od.codeid = sb.codeid) OD
        left join
        (select r.*, icc.icrate, icc.ruletype, e.rerole, rd.opendate rdtypeopendate, nvl(rd.closedate - 1, rd.expdate) rdtypeclosedate
            from reaflnk r, retype e , iccftypedef icc, recflnk rl, recfdef rd
            where substr(r.reacctno,11,4) = e.actype and e.rerole = 'RD' and e.actype = icc.actype and icc.modcode = 'RE'
            and r.reacctno = rl.custid||rd.reactype and rl.autoid = rd.refrecflnkid
        ) rd
        on od.afacctno = rd.afacctno and od.txdate between rd.frdate and nvl(rd.clstxdate -1 , rd.todate)
                                     and od.txdate between rd.rdtypeopendate and rd.rdtypeclosedate

    WHERE OD.afacctno = kh.afacctno
        and od.txdate between VF_DATE AND VT_DATE
        and od.txdate between kh.frdate and nvl(kh.clstxdate - 1, kh.todate)
        and od.txdate between recfdef.effdate and nvl(recfdef.closedate - 1, recfdef.expdate)
        and kh.reacctno = mg.custid || recfdef.reactype
        and recfdef.refrecflnkid= mg.autoid
        AND substr(kh.reacctno, 11,4) = retype.actype
        and g.reacctno = kh.reacctno
        and od.txdate between g.frdate and  nvl(g.clstxdate -1, g.todate)
        --and g.ma_nhom like V_GROUPID
       /* AND retype.rerole LIKE V_REROLE
        and mg.custid like V_CUSTID*
        --AND (mg.brid LIKE V_STRBRID OR instr(V_STRBRID,mg.brid)<> 0)
) r
,rerfee rf  --moi loai CK co ty le khac nhau
,cfmast c1, afmast af1, cfmast c2, allcode a/*, cfmast c3*
where  r.actype = rf.refobjid (+) and r.sectype = rf.symtype (+)
and r.so_tk_kh = af1.acctno and af1.custid = c1.custid and r.custid_mg = c2.custid
and a.cdtype = 'RE' and a.cdname = 'REROLE' and a.cdval = r.rerole
group by
    ma_nhom, ten_nhom, ten_truong_nhom, a.cdcontent , typename
    , custid_mg , r.actype , rerole ,  SP_FORMAT_REGRP_MAPCODE(ma_nhom)
   ,ispaydsf, c2.fullname,
    ruletype,Rf.CALTYPE,rf.RERFRATE, icrate, rdcustid
    ,CASE WHEN rerole = 'BM' THEN 01
                    WHEN rerole = 'RM' THEN 02
                    WHEN rerole = 'AE' THEN 03
                    WHEN rerole = 'RD' THEN 04
                    ELSE 05
                    END
) a
Group by vi_tri, ma_nhom, ten_truong_nhom, chuc_vu, cap, ten_moi_gioi, mg, rerole, vai_tro, orderid


*/
;
EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
End;
/

