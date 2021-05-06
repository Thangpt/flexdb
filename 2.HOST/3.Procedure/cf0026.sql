CREATE OR REPLACE PROCEDURE cf0026 (
   pv_refcursor   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   AFACCTNO       IN       VARCHAR2
  )
IS
--
-- PURPOSE: Bao cao sao ke tien vay
-- Bao cao sao ke tien vay
-- MODIFICATION HISTORY
-- hien.vu     DATE 13/05/2011    COMMENTS
-- ---------   ------  -------------------------------------------

   CUR             PKG_REPORT.REF_CURSOR;
   V_STROPTION    VARCHAR2 (5);                  -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (4);                   -- USED WHEN V_NUMOPTION > 0
   V_STRAFACCTNO  VARCHAR2 (20);
   V_NUMSDDK      NUMBER (20, 2);
   V_NUMCTT       NUMBER (20, 2);
   V_NUMKQ        NUMBER (20, 2);
   V_NUMPT        NUMBER (20, 2);
   V_NUMMBLOCK        NUMBER (20, 2);
   V_STRFULLNAME  VARCHAR2 (100);
   V_STRADDRESS    VARCHAR2 (500);
   V_STRLG        VARCHAR2(20);
   V_DATE         DATE;
   V_D_CUR        DATE;


   ---- cac bien
   v_CV_date_max DATE; -- Ngay convert hop dong
   V_du_no_hien_tai  NUMBER(20,2);
   v_Gia_tri_ngay_CV NUMBER(20,2);
   v_PS_Truoc_CV NUMBER(20,2);
   V_DU_NO_DK   NUMBER(20,2); -- V_DU_NO_DK := v_Gia_tri_ngay_CV + v_PS_Truoc_CV

   V_DU_NO_TANG NUMBER(20,2);
   V_DU_NO_GIAM NUMBER(20,2);
   v_Fullname  VARCHAR2 (200);
   V_lai_phai_tra_hien_tai NUMBER(20,2);
   V_DU_LAI_DK NUMBER(20,2);  -- V_DU_LAI_DK = V_lai_phai_tra_hien_tai - V_PS_LAI + V_Tra_lai;
   V_PS_LAI NUMBER(20,2);
   V_Tra_lai NUMBER(20,2);

BEGIN

   V_STROPTION := OPT;
   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   IF (AFACCTNO <> 'ALL')
   THEN
      V_STRAFACCTNO :=  AFACCTNO;
   ELSE
      V_STRAFACCTNO := '%%';
   END IF;

     Begin
    Select fullname into v_Fullname from  cfmast where custid in (Select custid from afmast where acctno =AFACCTNO);
  Exception when others then
    v_Fullname:='';
  End;
begin
--Lay thong tin loai hinh hop dong
 SELECT ( CASE WHEN  SUBSTR(CF.custodycd,4,1) IS NULL OR SUBSTR(CF.custodycd,4,1)in('P','C') THEN 'C' ELSE 'F' end)
INTO  V_STRLG FROM CFMAST CF ,AFMAST AF
WHERE CF.custid = AF.custid
AND AF.acctno  LIKE V_STRAFACCTNO ;
Exception when others then
  NULL;
End;
--========================================== TINH DU NO DAU KY=========================================

For i in  (
Select OPNDATE txdate_max
from
LNMAST lnm
where  lnm.trfacctno =v_strafacctno
and lnm.opndate not in (
Select  min(TXdate) From  lntrana l1
where l1.acctno in ( Select ACCTNO from LNMAST lnm  where  lnm.trfacctno =v_strafacctno))
)
Loop
 v_CV_date_max :=i.txdate_max ;
End loop;


--2-------Tinh du no hien tai-------------------
Begin
  SELECT NVL ((l.prinnml + l.prinovd + l.oprinnml + l.oprinovd), 0)
  INTO V_du_no_hien_tai
  FROM lnmast l
  WHERE l.trfacctno = v_strafacctno ;
Exception when others then
  NULL;
End;
--3---------Tinh gia tri nhan no tai ngay convert sang hop dong margin----------------

Begin
If v_CV_date_max is not null  and to_date(F_DATE,'DD/MM/RRRR') <  to_date(v_CV_date_max,'DD/MM/RRRR') Then  -- Neu ton tai ngay Convert

Select  (nvl(L1.NML,0) + nvl(L1.PAID,0) + nvl(L1.OVD,0)) INTO v_Gia_tri_ngay_CV From
(
Select * from lnschd  where RLSDATE= v_CV_date_max
Union all
Select * from LNSchdhist where  RLSDATE= v_CV_date_max
) L1 , LNMAST LNM
 Where
L1.ACCTNO = LNM.ACCTNO
and TRFACCTNO = v_strafacctno;
V_DU_NO_DK := 0 ;

ELSE -- Neu ko co ngay convert hoac ngay con vert nho hon F date

Select ( nvl(D.DU_NO_HIEN_TAI,0) - nvl(B.Giai_ngan,0) + nvl(B.Tra_no ,0)) DU_NO_DK INTO V_DU_NO_DK
from
(
Select L.TRFACCTNO AFACCTNO , (L.prinnml + L.prinovd + L.oprinnml + L.oprinovd) DU_NO_HIEN_TAI from LNMAST L
where  L.TRFACCTNO=V_STRAFACCTNO
)D,
(
 Select  sum(Giai_ngan) Giai_ngan , Sum(Tra_no) Tra_no , Sum (Tra_lai) Tra_lai from
 (
 Select TL.TXDATE TXDATE , LM.TRFACCTNO AFACCTNO ,'Giai ngan MR ' Dien_giai, LNT.NAMT Giai_ngan, 0 Tra_no , 0 Tra_lai from
 (
 Select * from TLLOG     where tltxcd='5566' and DELTD<>'Y'
 union
 Select * from TLLOGALL  where tltxcd='5566' and DELTD<>'Y'
 )TL,
 ( Select * from LNTRANA where DELTD<>'Y'
   union
   Select * from LNTRAN  where DELTD<>'Y'
 )
  LNT, APPTX APP,
 (Select * from lnmast
  union all
  Select * from lnmasthist  ) LM
 where TL.TXNUM = LNT.TXNUM
 and TL.TXDATE = LNT.TXDATE
 and APP.APPTYPE = 'LN'
 and LNT.TXCD = APP.TXCD
 and LNT.TXCD='0012'
 AND LNT.ACCTNO=LM.ACCTNO

UNION ALL -- GIAI NGAN T0

Select TL.TXDATE TXDATE , LM.TRFACCTNO AFACCTNO ,'Giai ngan T0 ' Dien_giai, LNT.NAMT Giai_ngan, 0 Tra_no , 0 Tra_lai from
(
 Select * from TLLOG     where tltxcd='5566' and DELTD<>'Y'
 union
 Select * from TLLOGALL  where tltxcd='5566' and DELTD<>'Y'
 )TL,
 ( Select * from LNTRAN   where DELTD<>'Y'
   union
   Select * from LNTRANA  where DELTD<>'Y'
 )
  LNT, APPTX APP,
  (Select * from lnmast
  union all
  Select * from lnmasthist  ) LM
 where TL.TXNUM = LNT.TXNUM
 and TL.TXDATE = LNT.TXDATE
 and APP.APPTYPE = 'LN'
 and LNT.TXCD = APP.TXCD
 and LNT.TXCD='0053'
 AND LNT.ACCTNO=LM.ACCTNO
UNION ALL -- TRA NO MR

 Select TL.TXDATE TXDATE , LM.TRFACCTNO AFACCTNO ,'Tra no MR' Dien_giai, 0 Giai_ngan, LNT.NAMT  Tra_no , 0 Tra_lai from
 (
 Select * from TLLOG     where tltxcd in ('5540','5567') and DELTD<>'Y'
 union
 Select * from TLLOGALL  where tltxcd in ('5540','5567') and DELTD<>'Y'
 )TL,
 ( Select * from LNTRAN   where DELTD<>'Y'
   union
   Select * from LNTRANA  where DELTD<>'Y'
 ) LNT, APPTX APP,
 (Select * from lnmast
  union all
  Select * from lnmasthist  ) LM
 where TL.TXNUM = LNT.TXNUM
 and TL.TXDATE = LNT.TXDATE
 and APP.APPTYPE = 'LN'
 and LNT.TXCD = APP.TXCD
 and LNT.TXCD='0014'
 AND LNT.ACCTNO=LM.ACCTNO

UNION ALL -- TRa No T0

 Select TL.TXDATE TXDATE , LM.TRFACCTNO AFACCTNO ,'Tra no T0' Dien_giai, 0 Giai_ngan, LNT.NAMT  Tra_no , 0 Tra_lai from
 (
 Select * from TLLOG     where tltxcd in ('5540','5567') and DELTD<>'Y'
 union
 Select * from TLLOGALL  where tltxcd in ('5540','5567') and DELTD<>'Y'
 )TL,
 ( Select * from LNTRAN   where DELTD<>'Y'
   union
   Select * from LNTRANA  where DELTD<>'Y'
 ) LNT, APPTX APP,
   (Select * from lnmast
  union all
  Select * from lnmasthist  ) LM
 where TL.TXNUM = LNT.TXNUM
 and TL.TXDATE = LNT.TXDATE
 and APP.APPTYPE = 'LN'
 and LNT.TXCD = APP.TXCD
 and LNT.TXCD='0065'
 AND LNT.ACCTNO=LM.ACCTNO
 )a
 where AFACCTNO=V_STRAFACCTNO
 and a.TXDATE >= TO_DATE(F_DATE,'DD/MM/RRRR') -- FROM_DATE
)B;

v_Gia_tri_ngay_CV:=0;

end if;

Exception when others then
  NULL;
End;
--Tinh phat sinh lai
  Begin
  Select SUM(nvl(AMT,0)) INTO V_PS_LAI
FROM
(     SELECT SUM(LI.INTAMT) AMT, MST.TRFACCTNO ACCTNO
      FROM LNINTTRAN LI, LNMAST MST
        WHERE LI.ACCTNO = MST.ACCTNO
       and MST.TRFACCTNO  = V_STRAFACCTNO
        AND (LI.frdate >= TO_DATE (F_DATE  ,'DD/MM/YYYY')
            OR (LI.frdate < TO_DATE(F_DATE,'DD/MM/YYYY') AND LI.todate > TO_DATE(F_DATE,'DD/MM/YYYY')))
        --AND LI.TODATE <= TO_DATE (T_DATE,'DD/MM/YYYY')
        GROUP BY MST.TRFACCTNO
 ) GROUP by ACCTNO ;
  Exception when others then
  V_PS_LAI:=0;
  End;


Begin
-- TINH LAI DAU KY
Select ( nvl(D.LAI_PHAI_TRA_HIEN_TAI,0) - nvl(V_PS_LAI,0) + nvl(B.Tra_lai,0) ) DU_LAI_DK INTO V_DU_LAI_DK  from
(
Select L.TRFACCTNO AFACCTNO ,
(L.intnmlacr + L.intnmlovd  + L.intovdacr + L.intdue + L.ointnmlacr + L.ointnmlovd  + L.ointovdacr + L.ointdue ) LAI_PHAI_TRA_HIEN_TAI from LNMAST L
where  L.TRFACCTNO=V_STRAFACCTNO
)D,
(
 Select  sum(Giai_ngan) PS_LAI , Sum (Tra_lai) Tra_lai from
(
 Select TL.TXDATE TXDATE , LM.TRFACCTNO AFACCTNO ,'Tra Lai MR' Dien_giai, 0 Giai_ngan,  0 Tra_no , LNT.NAMT Tra_lai from
(
 Select * from TLLOG     where tltxcd in ('5540','5567') and DELTD<>'Y'
 union
 Select * from TLLOGALL  where tltxcd in ('5540','5567') and DELTD<>'Y'
)TL,
 ( Select * from LNTRAN   where DELTD<>'Y'
   union
   Select * from LNTRANA  where DELTD<>'Y'
 ) LNT, APPTX APP,
   (Select * from lnmast
  union all
  Select * from lnmasthist  ) LM
 where TL.TXNUM = LNT.TXNUM
 and TL.TXDATE = LNT.TXDATE
 and APP.APPTYPE = 'LN'
 and LNT.TXCD = APP.TXCD
 and LNT.TXCD='0024'
 AND LNT.ACCTNO=LM.ACCTNO

UNION ALL -- TRA LAI T0

  Select TL.TXDATE TXDATE , LM.ACCTNO AFACCTNO ,'Tra Lai T0' Dien_giai, 0 Giai_ngan,  0 Tra_no , LNT.NAMT Tra_lai from
 (
 Select * from TLLOG     where tltxcd in ('5540','5567') and DELTD<>'Y'
 union
 Select * from TLLOGALL  where tltxcd in ('5540','5567') and DELTD<>'Y'
 )TL,
 ( Select * from LNTRAN   where DELTD<>'Y'
   union
   Select * from LNTRANA  where DELTD<>'Y'
 ) LNT, APPTX APP,
   (Select * from lnmast
  union all
  Select * from lnmasthist  ) LM
 where TL.TXNUM = LNT.TXNUM
 and TL.TXDATE = LNT.TXDATE
 and APP.APPTYPE = 'LN'
 and LNT.TXCD = APP.TXCD
 and LNT.TXCD='0075'
 AND LNT.ACCTNO=LM.ACCTNO
 )a
 where AFACCTNO=V_STRAFACCTNO
 and a.TXDATE >= TO_DATE(F_DATE,'DD/MM/RRRR')
)B;

Exception when others then
  NULL;
End;

  Begin
  Select SUM(nvl(AMT,0)) INTO V_PS_LAI
FROM
(     SELECT SUM(LI.INTAMT) AMT, MST.TRFACCTNO ACCTNO
      FROM LNINTTRAN LI, LNMAST MST
        WHERE LI.ACCTNO = MST.ACCTNO
       and MST.TRFACCTNO  = V_STRAFACCTNO
        AND ((LI.frdate >= TO_DATE (F_DATE  ,'DD/MM/YYYY'))
            OR (LI.frdate < TO_DATE(F_DATE,'DD/MM/YYYY')
                AND LI.todate > TO_DATE(F_DATE,'DD/MM/YYYY')))
        AND LI.TODATE <= TO_DATE (T_DATE,'DD/MM/YYYY')
        GROUP BY MST.TRFACCTNO
 ) GROUP by ACCTNO ;
  Exception when others then
  V_PS_LAI:=0;
  End;

--==========================GET DATA REPORT=============================

If v_CV_date_max is not null  and   to_date(F_DATE,'DD/MM/RRRR') <  to_date(v_CV_date_max,'DD/MM/RRRR')
Then

OPEN PV_REFCURSOR FOR
 Select * FRom
 (
 (
 Select stt, TXDATE TXDATE ,TXNUM,AFACCTNO ,Giao_dich, to_char(Dien_giai) Dien_giai ,Giai_ngan,Tra_no,  Tra_lai, NVL(V_DU_NO_DK,0)  DU_NO_DK,V_DU_LAI_DK SO_DU_LAI_DK ,V_PS_LAI LAI_PS,
 v_Fullname Fullname,v_CV_date_max v_CV_date_max ,v_Gia_tri_ngay_CV v_Gia_tri_ngay_CV
 from
(
Select 1 stt,TL.TXDATE TXDATE,TL.TXNUM , LM.TRFACCTNO AFACCTNO ,'Giai ngan MR ' Giao_dich ,TL.TXDESC || ' : MR ' Dien_giai, LNT.NAMT Giai_ngan, 0 Tra_no , 0 Tra_lai from
 (
 Select * from TLLOG     where tltxcd='5566' and DELTD<>'Y'
 union
 Select * from TLLOGALL  where tltxcd='5566' and DELTD<>'Y'
 )TL,
 ( Select * from LNTRANA where DELTD<>'Y'
   union
   Select * from LNTRAN  where DELTD<>'Y'
 )
  LNT, APPTX APP,
 (Select * from lnmast
  union all
  Select * from lnmasthist  ) LM
 where TL.TXNUM = LNT.TXNUM
 and TL.TXDATE = LNT.TXDATE
 and APP.APPTYPE = 'LN'
 and LNT.TXCD = APP.TXCD
 and LNT.TXCD='0012'
 and LNT.ACCTNO=LM.ACCTNO
union all
Select 2 stt,TL.TXDATE TXDATE,TL.TXNUM , LM.TRFACCTNO AFACCTNO ,'Giai ngan T0 ' Giao_dich ,TL.TXDESC || ' : T0 ' Dien_giai, LNT.NAMT Giai_ngan, 0 Tra_no , 0 Tra_lai from
(
 Select * from TLLOG     where tltxcd='5566' and DELTD<>'Y'
 union
 Select * from TLLOGALL  where tltxcd='5566' and DELTD<>'Y'
 )TL,
 ( Select * from LNTRAN   where DELTD<>'Y'
   union
   Select * from LNTRANA  where DELTD<>'Y'
 )
  LNT, APPTX APP,
    (Select * from lnmast
  union all
  Select * from lnmasthist  ) LM
 where TL.TXNUM = LNT.TXNUM
 and TL.TXDATE = LNT.TXDATE
 and APP.APPTYPE = 'LN'
 and LNT.TXCD = APP.TXCD
 and LNT.TXCD='0053'
 AND LNT.ACCTNO=LM.ACCTNO
union all
 Select 6 stt, TL.TXDATE TXDATE,TL.TXNUM , LM.TRFACCTNO AFACCTNO ,'Tra no MR' Giao_dich ,TL.TXDESC || ' : MR ' Dien_giai, 0 Giai_ngan, LNT.NAMT  Tra_no , 0 Tra_lai from
 (
 Select * from TLLOG     where tltxcd in ('5540','5567') and DELTD<>'Y'
 union
 Select * from TLLOGALL  where tltxcd in ('5540','5567') and DELTD<>'Y'
 )TL,
 ( Select * from LNTRAN   where DELTD<>'Y'
   union
   Select * from LNTRANA  where DELTD<>'Y'
 ) LNT, APPTX APP,
   (Select * from lnmast
  union all
  Select * from lnmasthist  ) LM
 where TL.TXNUM = LNT.TXNUM
 and TL.TXDATE = LNT.TXDATE
 and APP.APPTYPE = 'LN'
 and LNT.TXCD = APP.TXCD
 and LNT.TXCD='0014'
 AND LNT.ACCTNO=LM.ACCTNO

 union all

 Select 5 stt,TL.TXDATE TXDATE,TL.TXNUM , LM.TRFACCTNO AFACCTNO ,'Tra no T0'  Giao_dich ,TL.TXDESC || ' : T0 ' Dien_giai, 0 Giai_ngan, LNT.NAMT  Tra_no , 0 Tra_lai from
 (
 Select * from TLLOG     where tltxcd in ('5540','5567') and DELTD<>'Y'
 union
 Select * from TLLOGALL  where tltxcd in ('5540','5567') and DELTD<>'Y'
 )TL,
 ( Select * from LNTRAN   where DELTD<>'Y'
   union
   Select * from LNTRANA  where DELTD<>'Y'
 ) LNT, APPTX APP,
   (Select * from lnmast
  union all
  Select * from lnmasthist  ) LM
 where TL.TXNUM = LNT.TXNUM
 and TL.TXDATE = LNT.TXDATE
 and APP.APPTYPE = 'LN'
 and LNT.TXCD = APP.TXCD
 and LNT.TXCD='0065'
 AND LNT.ACCTNO=LM.ACCTNO
union all
  Select 4 stt,TL.TXDATE TXDATE,TL.TXNUM , LM.TRFACCTNO AFACCTNO ,'Tra lai MR'  Giao_dich ,TL.TXDESC || ' : MR ' Dien_giai, 0 Giai_ngan,  0 Tra_no , LNT.NAMT Tra_lai from
 (
 Select * from TLLOG     where tltxcd in ('5540','5567') and DELTD<>'Y'
 union
 Select * from TLLOGALL  where tltxcd in ('5540','5567') and DELTD<>'Y'
 )TL,
 ( Select * from LNTRAN   where DELTD<>'Y'
   union
   Select * from LNTRANA  where DELTD<>'Y'
 ) LNT, APPTX APP,
   (Select * from lnmast
  union all
  Select * from lnmasthist  ) LM
 where TL.TXNUM = LNT.TXNUM
 and TL.TXDATE = LNT.TXDATE
 and APP.APPTYPE = 'LN'
 and LNT.TXCD = APP.TXCD
 and LNT.TXCD='0024'
 AND LNT.ACCTNO=LM.ACCTNO


union all

  Select 3 stt,TL.TXDATE TXDATE ,TL.TXNUM , LM.TRFACCTNO AFACCTNO ,'Tra lai T0'  Giao_dich ,TL.TXDESC || ' : T0 ' Dien_giai, 0 Giai_ngan,  0 Tra_no , LNT.NAMT Tra_lai from
 (
 Select * from TLLOG     where tltxcd in ('5540','5567') and DELTD<>'Y'
 union
 Select * from TLLOGALL  where tltxcd in ('5540','5567') and DELTD<>'Y'
 )TL,
 ( Select * from LNTRAN   where DELTD<>'Y'
   union
   Select * from LNTRANA  where DELTD<>'Y'
 ) LNT, APPTX APP,
   (Select * from lnmast
  union all
  Select * from lnmasthist  ) LM
 where TL.TXNUM = LNT.TXNUM
 and TL.TXDATE = LNT.TXDATE
 and APP.APPTYPE = 'LN'
 and LNT.TXCD = APP.TXCD
 and LNT.TXCD='0075'
 AND LNT.ACCTNO=LM.ACCTNO

 )
 WHERE AFACCTNO=V_STRAFACCTNO
 and TXDATE  >= TO_DATE(F_DATE,'DD/MM/RRRR')
 and TXDATE  <= TO_DATE(T_DATE,'DD/MM/RRRR')
 --order by TXDATE ,TXNUM , stt
  )

UNION ALL
  (
 Select 0 stt, v_CV_date_max TXDATE , '0' TXNUM, AFACCTNO AFACCTNO , 'Giai ngan' Giao_dich, to_char('Gi?i ng?tru?c Margin') Dien_giai ,
 v_Gia_tri_ngay_CV Giai_ngan, 0 Tra_no,
  0 Tra_lai, NVL(V_DU_NO_DK,0)  DU_NO_DK,NVL(V_DU_LAI_DK,0) SO_DU_LAI_DK ,V_PS_LAI LAI_PS, v_Fullname Fullname
,v_CV_date_max v_CV_date_max ,v_Gia_tri_ngay_CV v_Gia_tri_ngay_CV  from Dual
  )
)
order by TXDATE ,TXNUM , stt ;

ELSE   ---- NEU NGAY CONVERT LA NUL HOAC LA NGAY FDATE NHO HON NGAY CONVERT

OPEN PV_REFCURSOR FOR

Select TXDATE TXDATE ,AFACCTNO ,Giao_dich,Dien_giai ,Giai_ngan,Tra_no,  Tra_lai, NVL(V_DU_NO_DK,0)  DU_NO_DK,V_DU_LAI_DK SO_DU_LAI_DK ,V_PS_LAI LAI_PS, v_Fullname Fullname
,F_DATE v_CV_date_max ,v_Gia_tri_ngay_CV v_Gia_tri_ngay_CV, V_STRLG LH
from
(
Select 1 stt,TL.TXDATE TXDATE,TL.TXNUM , LM.TRFACCTNO AFACCTNO ,'Giai ngan MR ' Giao_dich ,TL.TXDESC || ' : MR ' Dien_giai, LNT.NAMT Giai_ngan, 0 Tra_no , 0 Tra_lai from
 (
 Select * from TLLOG     where tltxcd='5566' and DELTD<>'Y'
 union
 Select * from TLLOGALL  where tltxcd='5566' and DELTD<>'Y'
 )TL,
 ( Select * from LNTRANA where DELTD<>'Y'
   union
   Select * from LNTRAN  where DELTD<>'Y'
 )
  LNT, APPTX APP,
    (Select * from lnmast
  union all
  Select * from lnmasthist  ) LM
 where TL.TXNUM = LNT.TXNUM
 and TL.TXDATE = LNT.TXDATE
 and APP.APPTYPE = 'LN'
 and LNT.TXCD = APP.TXCD
 and LNT.TXCD='0012'
 AND LNT.ACCTNO=LM.ACCTNO
union all
Select 2 stt,TL.TXDATE TXDATE,TL.TXNUM , LM.TRFACCTNO AFACCTNO ,'Giai ngan T0 ' Giao_dich ,TL.TXDESC || ' : T0 ' Dien_giai, LNT.NAMT Giai_ngan, 0 Tra_no , 0 Tra_lai from
(
 Select * from TLLOG     where tltxcd='5566' and DELTD<>'Y'
 union
 Select * from TLLOGALL  where tltxcd='5566' and DELTD<>'Y'
 )TL,
 ( Select * from LNTRAN   where DELTD<>'Y'
   union
   Select * from LNTRANA  where DELTD<>'Y'
 )
  LNT, APPTX APP,
    (Select * from lnmast
  union all
  Select * from lnmasthist  ) LM
 where TL.TXNUM = LNT.TXNUM
 and TL.TXDATE = LNT.TXDATE
 and APP.APPTYPE = 'LN'
 and LNT.TXCD = APP.TXCD
 and LNT.TXCD='0053'
 AND LNT.ACCTNO=LM.ACCTNO
union all
 Select 6 stt, TL.TXDATE TXDATE,TL.TXNUM , LM.TRFACCTNO AFACCTNO ,'Tra no MR' Giao_dich ,TL.TXDESC || ' : MR ' Dien_giai, 0 Giai_ngan, LNT.NAMT  Tra_no , 0 Tra_lai from
 (
 Select * from TLLOG     where tltxcd in ('5540','5567') and DELTD<>'Y'
 union
 Select * from TLLOGALL  where tltxcd in ('5540','5567') and DELTD<>'Y'
 )TL,
 ( Select * from LNTRAN   where DELTD<>'Y'
   union
   Select * from LNTRANA  where DELTD<>'Y'
 ) LNT, APPTX APP,
   (Select * from lnmast
  union all
  Select * from lnmasthist  ) LM
 where TL.TXNUM = LNT.TXNUM
 and TL.TXDATE = LNT.TXDATE
 and APP.APPTYPE = 'LN'
 and LNT.TXCD = APP.TXCD
 and LNT.TXCD='0014'
 AND LNT.ACCTNO=LM.ACCTNO

 union all

 Select 5 stt,TL.TXDATE TXDATE,TL.TXNUM , LM.TRFACCTNO AFACCTNO ,'Tra no T0'  Giao_dich ,TL.TXDESC || ' : T0 ' Dien_giai, 0 Giai_ngan, LNT.NAMT  Tra_no , 0 Tra_lai from
 (
 Select * from TLLOG     where tltxcd in ('5540','5567') and DELTD<>'Y'
 union
 Select * from TLLOGALL  where tltxcd in ('5540','5567') and DELTD<>'Y'
 )TL,
 ( Select * from LNTRAN   where DELTD<>'Y'
   union
   Select * from LNTRANA  where DELTD<>'Y'
 ) LNT, APPTX APP,
   (Select * from lnmast
  union all
  Select * from lnmasthist  ) LM
 where TL.TXNUM = LNT.TXNUM
 and TL.TXDATE = LNT.TXDATE
 and APP.APPTYPE = 'LN'
 and LNT.TXCD = APP.TXCD
 and LNT.TXCD='0065'
 AND LNT.ACCTNO=LM.ACCTNO

union all
  Select 4 stt,TL.TXDATE TXDATE,TL.TXNUM , LM.TRFACCTNO AFACCTNO ,'Tra lai  MR'  Giao_dich ,TL.TXDESC || ' : MR ' Dien_giai, 0 Giai_ngan,  0 Tra_no , LNT.NAMT Tra_lai from
 (
 Select * from TLLOG     where tltxcd in ('5540','5567') and DELTD<>'Y'
 union
 Select * from TLLOGALL  where tltxcd in ('5540','5567') and DELTD<>'Y'
 )TL,
 ( Select * from LNTRAN   where DELTD<>'Y'
   union
   Select * from LNTRANA  where DELTD<>'Y'
 ) LNT, APPTX APP,
   (Select * from lnmast
  union all
  Select * from lnmasthist  ) LM
 where TL.TXNUM = LNT.TXNUM
 and TL.TXDATE = LNT.TXDATE
 and APP.APPTYPE = 'LN'
 and LNT.TXCD = APP.TXCD
 and LNT.TXCD='0024'
 AND LNT.ACCTNO=LM.ACCTNO


union all

  Select 3 stt,TL.TXDATE TXDATE ,TL.TXNUM , LM.TRFACCTNO AFACCTNO ,'Tra lai T0'  Giao_dich ,TL.TXDESC || ' : T0 ' Dien_giai, 0 Giai_ngan,  0 Tra_no , LNT.NAMT Tra_lai from
 (
 Select * from TLLOG     where tltxcd in ('5540','5567') and DELTD<>'Y'
 union
 Select * from TLLOGALL  where tltxcd in ('5540','5567') and DELTD<>'Y'
 )TL,
 ( Select * from LNTRAN   where DELTD<>'Y'
   union
   Select * from LNTRANA  where DELTD<>'Y'
 ) LNT, APPTX APP,
   (Select * from lnmast
  union all
  Select * from lnmasthist  ) LM
 where TL.TXNUM = LNT.TXNUM
 and TL.TXDATE = LNT.TXDATE
 and APP.APPTYPE = 'LN'
 and LNT.TXCD = APP.TXCD
 and LNT.TXCD='0075'
 AND LNT.ACCTNO=LM.ACCTNO

 )
 WHERE AFACCTNO=V_STRAFACCTNO
 and TXDATE  >= TO_DATE(F_DATE,'DD/MM/RRRR')
 and TXDATE  <= TO_DATE(T_DATE,'DD/MM/RRRR')
 order by TXDATE ,TXNUM , stt; -- desc;
 end if  ;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

