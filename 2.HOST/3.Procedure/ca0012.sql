CREATE OR REPLACE PROCEDURE ca0012 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   CACODE         IN       VARCHAR2,
   PLSENT         in       varchar2  -- MA SU KIEM
   )
IS
--
-- PURPOSE: DANH SACH TONG HOP CHUYEN NHUONG QUYEN MUA CK
--creted by CHaunh at 29/02/2012
-- ---------   ------  -------------------------------------------

    CUR             PKG_REPORT.REF_CURSOR;
    V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);
    V_FRDATE       DATE;
    V_TODATE       DATE;
    V_STRCACODE   VARCHAR2 (20);
    v_secname  varchar2(100);
    v_secid varchar2(10);
    v_endate varchar2(10);
    v_tvlk varchar2(5);

BEGIN
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   V_FRDATE    := TO_DATE(F_DATE,'DD/MM/RRRR');
   V_TODATE    := TO_DATE(T_DATE,'DD/MM/RRRR');
   V_STRCACODE := CACODE;
/*   select issuers.fullname, sb.codeid, camast.todatetransfer,'005' into v_secname, v_secid, v_endate, v_tvlk
   from camast, sbsecurities sb, ISSUERS
   where camast.codeid = sb.codeid and issuers.issuerid = sb.issuerid and camast.catype = '014'
   and camast.camastid = V_STRCACODE ;*/



   -- GET REPORT'S PARAMETERS

OPEN PV_REFCURSOR
   FOR
select se.*,main.*, '091' v_tvlk, PLSENT sendto from
(select tran.custodycd, camastid,
        sum(case when tltxcd = '3392'  and txtype = 'D' then -namt
                when tltxcd not in  ('3392','3353') and txtype = 'C' then namt else 0 end) SLQM_nhan,
        sum(case when tltxcd in ('3392','3353') and txtype = 'C' then - namt
                when tltxcd not in ('3392','3353') and txtype = 'D' then namt else 0 end) SLQM_chuyen
 from vw_setran_gen tran, caschd
 where tran.txtype in ('D','C')
 and tran.tltxcd not in ('3384','3394')
 and caschd.deltd <> 'Y'  AND to_char(caschd.autoid) = tran.ref
 and tran.txdate <= V_TODATE and tran.txdate >= V_FRDATE
 and caschd.camastid  = V_STRCACODE
 --and tran.custodycd = '091C000002'
 group by tran.custodycd, camastid

 )se,
 (select c.custodycd so_TaiKLK, c.fullname ho_ten,
        f_iss.fullname v_secname, f_sb.symbol v_secid,
        t_iss.fullname toissname, t_sb.symbol tosymbol,
        case when substr(c.custodycd,4,1) = 'P' then 'Tu doanh' else 'Moi gioi' end loai_hinh,
        case when substr(c.custodycd,4,1) = 'C' then 'Trong nuoc'
             when substr(c.custodycd,4,1) = 'F' then 'Nuoc ngoai' end trong_ngoai_nuoc,
        case when c.custtype = 'I'  then 'Ca nhan'
             else 'To chuc' end loai_kh,
        camast.reportdate v_endate,
        case when c.country = '234' then c.idcode else c.tradingcode end idcode,
        c.address,al.cdcontent quoc_tich,
        sum(ca.trade) SLQM_pb
        --sum(ca.pbalance + ca.balance - ca.inbalance + ca.outbalance) SLQM_pb
 from caschd ca, afmast a, cfmast c, camast, issuers f_iss, issuers t_iss, sbsecurities f_sb, sbsecurities t_sb , allcode al
 where a.custid = c.custid and ca.afacctno = a.acctno and ca.deltd <> 'Y'
 and camast.camastid = ca.camastid and camast.codeid = f_sb.codeid and f_sb.issuerid = f_iss.issuerid
 and nvl(camast.tocodeid,camast.codeid) = t_sb.codeid and t_sb.issuerid = t_iss.issuerid
 and al.cdname = 'COUNTRY' and al.cdval = c.country
 and camast.camastid like V_STRCACODE
 group by c.custodycd, c.fullname ,
        f_iss.fullname , f_sb.symbol ,
        t_iss.fullname , t_sb.symbol ,
        case when substr(c.custodycd,4,1) = 'P' then 'Tu doanh' else 'Moi gioi' end ,
        case when substr(c.custodycd,4,1) = 'C' then 'Trong nuoc'
             when substr(c.custodycd,4,1) = 'F' then 'Nuoc ngoai' end ,
        case when c.custtype = 'I'  then 'Ca nhan'
             else 'To chuc' end ,
        camast.reportdate ,
        case when c.country = '234' then c.idcode else c.tradingcode end ,
        c.address,al.cdcontent
 ) main
 where se.custodycd = main.so_TaiKLK
 and se.SLQM_nhan + se.SLQM_chuyen <> 0

/*select  case when substr(main.tk_doiung,4,1) = 'P' then 'Tu doanh' else 'Moi gioi' end loai_hinh,
        case when substr(main.tk_doiung,4,1) = 'C' then 'Trong nuoc'
             when substr(main.tk_doiung,4,1) = 'F' then 'Nuoc ngoai' end trong_ngoai_nuoc,
        case when cfmast.custtype = 'I'  then 'Ca nhan'
             else 'To chuc' end loai_kh,
        issuers.fullname v_secname, sb.symbol v_secid,
        iss.fullname toissname, sb2.symbol tosymbol,
        camast.reportdate v_endate,'005' v_tvlk, PLSENT sendto,
         main.*  from
(select  se.txnum, se.txdate, (case when se.tltxcd = '3382' then fld.tk_doiung
                                      else cf.custodycd end) tk_doiung,

        cf.fullname ho_ten,
        case when cf.country = '234' then cf.idcode else cf.tradingcode end idcode, --neu la nguoi nuoc ngoai thi lay trading code
        cf.address,cf.quoc_gia quoc_tich,
        cf.custodycd so_TaiKLK, ca.slq_ht - se.so_du SLQM_pb,
        case when se.txtype = 'D' then se.namt else 0 end SLQM_chuyen,
        case when se.txtype = 'C' then se.namt else 0 end SLQM_nhan,
        case when se.txtype = 'D' then 'Ban' else 'Mua' end ghi_chu,
        cf.custodycd
from
    (select  se.txnum, se.txdate, se.acctno,se.namt, ca.camastid, se.tltxcd, se.txtype,
            sum(case when sen.txtype ='C'  then sen.namt
                    when sen.txtype ='D' then -sen.namt
                     end ) so_du
        from vw_setran_gen se,
            (
            select tran.acctno,tran.namt, camastid, tran.txtype, tran.txdate, tran.txnum , tran.tltxcd
            from vw_setran_gen tran, caschd
            where  tran.tltxcd in ('3382','3383')
            and tran.txtype in ('D','C')
            and caschd.deltd <> 'Y' and camastid = V_STRCACODE AND caschd.autoid = tran.ref
            ) sen, caschd ca
        where se.acctno =  sen.acctno(+) AND ca.camastid = sen.camastid  and se.deltd <> 'Y'
        AND se.txtype in ('C','D')
        and se.tltxcd in ('3382','3383')
        and sen.txdate >= se.txdate
        and sen.txnum >= (case when sen.txdate = se.txdate then se.txnum
                            when sen.txdate <  se.txdate then '9999999999'
                            else '0'end )
        and se.txdate <= V_TODATE and se.txdate >= V_FRDATE
        and ca.camastid  = V_STRCACODE AND ca.autoid = se.REF AND ca.deltd <> 'Y'
    group by se.txdate, se.txnum, se.acctno,se.namt,ca.camastid,se.tltxcd,se.txtype
    order by se.txdate, se.txnum , se.acctno)  se
    left join
    (select  caschd.camastid,sum(caschd.balance + caschd.pbalance) slq_ht, caschd.afacctno
        from caschd where caschd.deltd = 'N'
        GROUP BY caschd.camastid, caschd.afacctno) ca
    on se.camastid = ca.camastid and substr(se.acctno,1,10) = ca.afacctno
    left join
    (select cfmast.*, afmast.acctno, allcode.cdcontent quoc_gia from cfmast, afmast, allcode where cfmast.custid = afmast.custid and allcode.cdname = 'COUNTRY' and allcode.cdval = cfmast.country and allcode.cdtype = 'CF') cf
    on cf.acctno = substr(se.acctno,1,10)
    left join
    (select fld.txnum, fld.txdate, max(nvl(cvalue,nvalue)) tk_doiung
        from (select * from tllogfldall union all select * from tllogfld) fld  where  fld.fldcd = '36' group by fld.txnum, fld.txdate) fld
    on fld.txdate = se.txdate and fld.txnum = se.txnum
--giao dich 3383
union all
select fld.txnum, fld.txdate,
    max(case when fldcd = '36' then  nvl(cvalue,nvalue)  end) tk_doiung,
    max(case when fldcd = '95' then  nvl(cvalue,nvalue)  end) ho_ten,
    max(case when fldcd = '97' then  nvl(cvalue,nvalue)  end) CMND,
    max(case when fldcd = '96' then  nvl(cvalue,nvalue)  end) dia_chi,
    max(case when fldcd = '81' then  nvl(cvalue,nvalue)  end) quoc_tich,
    max(case when fldcd = '07' then  nvl(cvalue,nvalue)  end) so_TaiKLK,
    0 SLQM_pb,
    0 SLQM_chuyen,
    max(case when fldcd = '21' then  nvalue  end) SLQM_nhan,
    'Mua' ghi_chu,
    max(case when fldcd = '36' then  nvl(cvalue,nvalue)  end) custodycd
from (select * from tllogfldall union all select * from tllogfld) fld, vw_setran_all tran
where  fld.txdate = tran.txdate and fld.txnum = tran.txnum and tran.tltxcd ='3383'
and fld.txdate <= V_TODATE and fld.txdate >= V_FRDATE
and tran.ref =  V_STRCACODE
group by fld.txdate, fld.txnum*/
--giao dich 3385
/*union all
select fld.txnum, fld.txdate,
    max(case when fldcd = '88' then  nvl(cvalue,nvalue)  end) tk_doiung,
    max(case when fldcd = '95' then  nvl(cvalue,nvalue)  end) ho_ten,
    max(case when fldcd = '97' then  nvl(cvalue,nvalue)  end) CMND,
    max(case when fldcd = '96' then  nvl(cvalue,nvalue)  end) dia_chi,
    max(case when fldcd = '81' then  nvl(cvalue,nvalue)  end) quoc_tich,
    max(case when fldcd = '09' then  nvl(cvalue,nvalue)  end) so_TaiKLK,
    0 SLQM_pb,
    max(case when fldcd = '21' then  nvalue  end) SLQM_chuyen,
    0 SLQM_nhan,
    'Mua' ghi_chu
from tllogfldall fld, vw_setran_all tran
where  fld.txdate = tran.txdate and fld.txnum = tran.txnum and tran.tltxcd ='3385'
and fld.txdate <= V_TODATE and fld.txdate >= V_FRDATE
and tran.ref =  V_STRCACODE
group by fld.txdate, fld.txnum
*//*) main, cfmast, camast, sbsecurities sb, ISSUERS, sbsecurities sb2, issuers iss
where main.tk_doiung = cfmast.custodycd
    and camast.codeid = sb.codeid
    and issuers.issuerid = sb.issuerid and camast.catype = '014'
    AND nvl(camast.tocodeid,camast.codeid) = sb2.codeid AND iss.issuerid = sb2.issuerid
    and camast.camastid = V_STRCACODE
order by main.txdate, main.txnum, SLQM_nhan , SLQM_chuyen*/
;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

