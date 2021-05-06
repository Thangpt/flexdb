CREATE OR REPLACE PROCEDURE "CFEIM1" (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   FROMDATE                   IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2

----   p_SIGNTYPE               IN       VARCHAR2
   )
IS
     V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
     V_STRBRID          VARCHAR2 (4);
     V_DATE             DATE;
     V_CUSTODYCD       VARCHAR2(10);
    -- V_ACCTNO         VARCHAR2(10);
     currdate       date;  -- ngày hiện tại
   count1     number;  -- số lượng các giao dịch có status =C và ngày hiện tại trong khoảng fdate và tdate
   edate      date; -- Ngày có hiệu lực cuối cùng trước khi update

BEGIN

     V_STROPTION := OPT;
   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

    V_DATE              :=    TO_DATE(FROMDATE, 'DD/MM/YYYY');

IF (PV_CUSTODYCD <> 'ALL')
   THEN
      V_CUSTODYCD := PV_CUSTODYCD;
   ELSE
      V_CUSTODYCD := '%%';
   END IF;
      --lấy ngày hiện tại
      select TO_DATE(varvalue,'DD/MM/RRRR')  into currdate
      from sysvar where varname ='CURRDATE';
  /*  -- Lấy số count1
    select count(*) into count1
      from TBLINTCHANGEHIST
      where custodycd =V_CUSTODYCD
    --  and lntype ='0002'
      and STATUS ='C'
      and  currdate between fdate and tdate;*/
 /*
IF (AF_ACCTNO <> 'ALL')
   THEN
      V_ACCTNO := AF_ACCTNO;
   ELSE
      V_ACCTNO := '%%';
   END IF;*/
OPEN PV_REFCURSOR
FOR
-- L?y danh sách khách hàng

select V_DATE NGAY_BC, tbl.*,A.RATE,imp.rate1A, imp.rate2A, imp.rate3A,RRTYPE,LNPURPOSE,imp.fdate,imp.tdate,sex,count1
from
(
select distinct tbl.lntype,tbl.afacctno,tbl.custodycd,ln.rate2,tbl.rate2A,edate,COUNT1,case when NVL(count1,0)= 0 then ln.rate2 else tbl.rate2A end rate
 from lntype ln, TBLINTCHANGEHIST tbl,
(
 select custodycd, afacctno, lntype,AUTOID, edate --  into edate
      from
      (
select custodycd, afacctno, lntype,MAX(TO_DATE(TO_CHAR(txdate, 'DD/MM/RRRR') || txtime, 'DD/MM/RRRRHH24:MI:SS') )edate ,MAX(AUTOID) AUTOID
 from TBLINTCHANGEHIST
where custodycd like V_CUSTODYCD

and STATUS ='C'
group by custodycd, afacctno, lntype)
)tbl1 left join
(
       select afacctno,count(*) count1 --into count1
      from TBLINTCHANGEHIST
      where custodycd like V_CUSTODYCD
      and STATUS ='C'
      and  currdate between fdate and tdate
      group by afacctno
) t on tbl1.afacctno = t.afacctno
where ln.actype =tbl.lntype
and ln.actype =tbl1.lntype 
and tbl.afacctno = tbl1.afacctno 
--and tbl.txdate =tbl1.mindate and nvl(txtime,'00:00:00') = tbl1.mintime 
--and tbl.txdate  =edate
and tbl.txdate  =to_date(TO_CHAR(edate, 'DD/MM/RRRR'),'DD/MM/RRRR')
AND TBL.AUTOID =TBL1.AUTOID

) a,
(select acc.fullname,acc.sex,ACC.CUSTODYCD,ACC.acctno, AF.*  from
(SELECT actype,CUSTODYCD,AF.acctno, cf.fullname,cf.sex FROM AFMAST AF, CFMAST CF WHERE AF.STATUS ='A' AND CF.STATUS ='A' AND CF.CUSTID =AF.CUSTID) acc left join  -- ACC: BANG DS KH GOM CA AFTYPE
(SELECT AFI.AFTYPE ACTYPE,AF.TYPENAME afname ,''ADTYPE,AFI.ACTYPE LNTYPE,  ''  T0LNTYPE,ln.typename lnname, ln.rate1, ln.rate2,ln.rate3,LN.RRTYPE,LN.LNPURPOSE
FROM AFIDTYPE AFI, AFTYPE AF,lntype ln WHERE AFI.AFTYPE =AF.ACTYPE AND OBJNAME ='LN.LNTYPE' and ln.actype =AFI.ACTYPE
UNION ALL
SELECT af.ACTYPE, af.TYPENAME ,af.ADTYPE,af.LNTYPE,af.T0LNTYPE, ln.typename lnname, ln.rate1, ln.rate2,ln.rate3,RRTYPE,LN.LNPURPOSE FROM AFTYPE af left join lntype ln
on ln.actype =af.lntype) af on acc.actype = af.actype ) tbl -- BANG AF: GOM AFTYPE, LNTYPE TEN CUA CAC LOAI HINH VA CAC TI LE CUA LNTYPE
left join

(SELECT TXDATE, CUSTODYCD, AFACCTNO,RATE1A, RATE2A, RATE3A, FDATE, TDATE,lntype FROM TBLINTCHANGEHIST

  WHERE CUSTODYCD||TO_DATE(TO_CHAR(txdate, 'DD/MM/RRRR') || txtime, 'DD/MM/RRRRHH24:MI:SS') IN(
SELECT DISTINCT CUSTODYCD||MAX(TO_DATE(TO_CHAR(txdate, 'DD/MM/RRRR') || txtime, 'DD/MM/RRRRHH24:MI:SS') ) FROM TBLINTCHANGEHIST
  WHERE STATUS <>'C'
GROUP BY CUSTODYCD
)
AND STATUS <>'C'
) imp on tbl.acctno =imp.afacctno and tbl.lntype =imp.lntype  -- IMP: BANG DANH SACH CAC TIEU KHOAN DUOC IMPORT TUONG UNG VOI TI LE VA NGAY HIEU LUC

where tbl.custodycd LIKE V_CUSTODYCD
and a.lntype =tbl.lntype
and a.custodycd =tbl.custodycd
and a.afacctno =tbl.acctno
and fdate is not null
ORDER BY tbl.CUSTODYCD;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/
