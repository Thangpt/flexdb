CREATE OR REPLACE PROCEDURE re0088_1 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   CUSTID         IN       VARCHAR2,
   REROLE         IN       VARCHAR2,
   PV_TLID        IN       VARCHAR2,
   RDCUSTID       in       varchar2 default 'ALL',
   RDREROLE         IN       varchar2 default 'ALL'
 )
IS
--bao cao gia tri giao dich
--created by Chaunh at 11/01/2012
    V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID          VARCHAR2 (40);    -- USED WHEN V_NUMOPTION > 0
    V_INBRID     VARCHAR2 (5);

    VF_DATE DATE;
    VT_DATE DATE;
    V_CUSTID varchar2(10);
    V_REROLE varchar2(4);
    V_REERNAME varchar2(50);
    V_RDCUSTID varchar2(10);
    V_RDREROLE varchar2(4);
    v_strtlid varchar2(1000);
    l_format VARCHAR2(10);
    l_segment VARCHAR2(20);
    l_length NUMBER;
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
   IF (REROLE <> 'ALL')
   THEN
    V_REROLE := REROLE;
   ELSE
    V_REROLE := '%';
   END IF;
   -----------------------
   V_CUSTID := CUSTID;
   IF (CUSTID <> 'ALL')
   THEN
    BEGIN
        V_CUSTID := CUSTID;
        SELECT cf.fullname INTO V_REERNAME FROM cfmast cf WHERE cf.custid like V_CUSTID;
    END ;
   ELSE
    V_CUSTID := '%';
    V_REERNAME := 'ALL';
   END IF;

    if (RDCUSTID <> 'ALL') then
        V_RDCUSTID := RDCUSTID;
   else
        V_RDCUSTID := '%';
   end if;

   if (RDREROLE <> 'ALL') then
        V_RDREROLE := RDREROLE;
   else
        V_RDREROLE := '%';
   end if;
   ------------------------------
   --chaunh: format ma moi gioi thanh dang xxxxxx, Phuc vu cho viec so sanh chuoi instr
/*   v_strtlid := '';
   l_format := '000000';
   l_length := length(l_format);
   for ul in (select * from reuserlnk u where tlid = PV_TLID
   )
   loop
        l_segment := l_format || to_char(ul.refrecflnkid);
        select  v_strtlid || ',' || SUBSTR(l_segment, length(l_segment)-l_length+1,l_length) into v_strtlid from dual;
   end loop;
*/
   VF_DATE := to_date(F_DATE,'DD/MM/RRRR');
   VT_DATE := to_date(T_DATE,'DD/MM/RRRR');
OPEN PV_REFCURSOR FOR
select
    so_tk_kh, so_tk_mg, rerole, custid_mg, retype, r.actype, rdtype, rdcustid,
    c1.fullname ten_kh, c1.custodycd cust_kh, c2.fullname ten_mg, CASE WHEN V_REROLE = '%' THEN '%' ELSE a.cdcontent END pa_role
    , ten_nhom, ten_truong_nhom
    , ten_mg_lq
    , sum(nvl(execamt,0)) execamt, sum(nvl(feeacr,0)) feeacr
    , sum(nvl(execamt,0) * DECODE(rf.CALTYPE,'0001',Rf.RERFRATE,0)/100) phi_giam_tru_ds
    , sum(nvl(feeacr,0) * DECODE(rf.CALTYPE,'0002',rf.RERFRATE,0)/100) phi_giam_tru_dt
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

    /*, c3.fullname ten_mg_lq*/
from
(
SELECT   substr(rd.reacctno,11,4) rdtype, substr(rd.reacctno,1,10) rdcustid , rd.icrate
        , rd.ruletype, rd.rerole rdrerole, od.*, ext.fullname ten_mg_lq, ext.custid extcustid, ext.rerole extrole
    FROM
        (
/*        select kh.afacctno so_tk_kh, mg.custid, kh.reacctno so_tk_MG, retype.rerole,  mg.custid custid_mg,
                retype.typename retype, od.execamt, od.feeacr, sb.sectype, retype.actype, ispaydsf, od.txdate, od.afacctno
        from
            (SELECT afacctno, txdate, execamt EXECAMT, feeacr, codeid FROM vw_odmast_all
            WHERE deltd <> 'Y' and execamt <> 0 AND txdate between to_date(F_DATE,'DD/MM/RRRR') and to_date(T_DATE,'DD/MM/RRRR')
            --SELECT afacctno, txdate, execamt EXECAMT, feeacr, codeid FROM odmast WHERE deltd <> 'Y' and execamt <> 0
            --    UNION ALL SELECT afacctno, txdate, execamt EXECAMT, feeacr, codeid FROM odmasthist WHERE deltd <> 'Y' and execamt <> 0
            ) OD, sbsecurities sb
            ,reaflnk kh,recflnk mg,recfdef,retype--, reuserlnk reu
        where od.codeid = sb.codeid and OD.afacctno = kh.afacctno
        --and od.txdate between to_date(F_DATE,'DD/MM/RRRR') and to_date(T_DATE,'DD/MM/RRRR')
        and od.txdate between kh.frdate and nvl(kh.clstxdate - 1, kh.todate)
        and od.txdate between recfdef.effdate and nvl(recfdef.closedate - 1, recfdef.expdate)
        and kh.reacctno = mg.custid || recfdef.reactype
        and recfdef.refrecflnkid= mg.autoid
        AND substr(kh.reacctno, 11,4) = retype.actype
        --and instr(v_strtlid,SUBSTR(l_format || to_char(kh.refrecflnkid), length(l_format || to_char(kh.refrecflnkid))-l_length+1,l_length)) <> 0
        AND kh.refrecflnkid IN (SELECT u.refrecflnkid FROM reuserlnk u WHERE tlid = PV_TLID)
        /*and reu.refrecflnkid = kh.refrecflnkid
        and reu.tlid = PV_TLID*
        AND retype.rerole LIKE V_REROLE
        and mg.custid = V_CUSTID
        --AND (mg.brid LIKE V_STRBRID OR instr(V_STRBRID,mg.brid)<> 0)
*/
            select kh.afacctno so_tk_kh, mg.custid, kh.reacctno so_tk_MG, mg.rerole, mg.custid custid_mg, mg.fullname ten_mg,
                mg.typename retype, od.execamt, od.feeacr, OD.sectype, mg.actype, ispaydsf, od.txdate, od.afacctno,
                cf1.fullname ten_kh, cf1.custodycd cust_kh
            FROM reaflnk kh, /*recflnk mg, recfdef, retype, cfmast cfmg,*/ cfmast cf1, afmast af1,
            (
                SELECT mg.brid, mg.custid, mg.custid||rcd.reactype reacctno, rcd.effdate, nvl(rcd.closedate-1,rcd.expdate) expdate,
                    ret.rerole, ret.actype, ret.typename, cf.fullname, rcd.ispaydsf
                FROM recflnk mg, recfdef rcd, retype ret, cfmast cf
                WHERE mg.autoid = rcd.refrecflnkid AND rcd.reactype = ret.actype AND mg.custid = cf.custid
                    AND mg.custid = V_CUSTID
                    AND mg.autoid IN (SELECT u.refrecflnkid FROM reuserlnk u WHERE tlid = PV_TLID)
            ) mg,
            (
                SELECT afacctno,SUM( execamt) EXECAMT, SUM(feeacr) feeacr,OD.TXDATE , sb.sectype FROM VW_odmast_ALL OD , sbsecurities sb
                WHERE deltd <> 'Y' and execamt <> 0
                    AND od.txdate BETWEEN VF_DATE AND VT_DATE
                    AND OD.CODEID = SB.CODEID
                GROUP BY afacctno,sectype,TXDATE
            ) OD
            WHERE kh.afacctno = od.afacctno AND kh.reacctno = mg.reacctno
                AND kh.afacctno = af1.acctno AND af1.custid = cf1.custid
                AND od.txdate BETWEEN mg.effdate AND mg.expdate
                AND od.txdate BETWEEN kh.frdate AND nvl(kh.clstxdate - 1, kh.todate)
                AND mg.rerole LIKE V_REROLE

        ) OD
        left join
        (select r.*, icc.icrate, icc.ruletype, e.rerole, rd.opendate rdtypeopendate, nvl(rd.closedate - 1, rd.expdate) rdtypeclosedate
            from reaflnk r, retype e , iccftypedef icc, recflnk rl, recfdef rd
            where substr(r.reacctno,11,4) = e.actype and e.rerole = 'RD' and e.actype = icc.actype and icc.modcode = 'RE'
            and r.reacctno = rl.custid||rd.reactype and rl.autoid = rd.refrecflnkid
        ) rd
        on od.afacctno = rd.afacctno and od.txdate between rd.frdate and nvl(rd.clstxdate -1 , rd.todate)
                                     and od.txdate between rd.rdtypeopendate and rd.rdtypeclosedate
        left join
        (
            select r.reacctno, r.afacctno, r.frdate, r.clstxdate, r.todate, cf.fullname, rt.rerole, cf.custid
                from reaflnk r, cfmast cf, retype rt
                where substr(r.reacctno,1,10) = cf.custid and substr(r.reacctno,11,4) = rt.actype
        ) ext
        on od.afacctno = ext.afacctno and od.txdate between ext.frdate and nvl(ext.clstxdate -1 , ext.todate)
            and od.rerole <> ext.rerole
) r
,rerfee rf  --moi loai CK co ty le khac nhau
, --truong nhom
(SELECT cfmast.fullname ten_truong_nhom, tn.fullname ten_nhom, nhom.reacctno FROM regrplnk nhom, regrp tn, cfmast
    WHERE tn.autoid = nhom.refrecflnkid AND nhom.status = 'A'
    AND tn.custid = cfmast.custid) b
,cfmast c1, afmast af1, cfmast c2, allcode a/*, cfmast c3*/
where  r.actype = rf.refobjid (+) and r.sectype = rf.symtype (+)
and r.so_tk_mg = b.reacctno (+)
and r.so_tk_kh = af1.acctno and af1.custid = c1.custid and r.custid_mg = c2.custid
and a.cdtype = 'RE' and a.cdname = 'REROLE' and a.cdval = r.rerole
and nvl(extcustid,'0000000000') like V_RDCUSTID
and nvl(extrole,'XX') like V_RDREROLE
group by
    so_tk_kh, so_tk_mg, rerole, custid_mg, retype, r.actype, rdtype, rdcustid,
    c1.fullname , c2.fullname , CASE WHEN V_REROLE = '%' THEN '%' ELSE a.cdcontent END, ten_nhom, ten_truong_nhom,ispaydsf,
    ruletype,Rf.CALTYPE,rf.RERFRATE, icrate,  c1.custodycd, ten_mg_lq/*, c3.fullname*/
order by retype,so_tk_kh

;

EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
End;
/

