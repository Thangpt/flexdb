CREATE OR REPLACE PROCEDURE CF9902 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_Date         In       Varchar2,
   CUSTODYCD       IN       VARCHAR2,

   CURRENT_INDEX         NUMBER  DEFAULT NULL,
   OFFSET_NUMBER         NUMBER  DEFAULT NULL,
   ONL                   VARCHAR2  DEFAULT NULL
   )
IS
-- MODIFICATION HISTORY
--danh sach TK OT quan ly
-- ---------   ------  -------------------------------------------
   V_STROPTION      VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_Strbrid        Varchar2 (4);            -- USED WHEN V_NUMOPTION > 0
   V_Custodycd       Varchar2 (20);

-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%';
   END IF;

    -- GET REPORT'S PARAMETERS
     IF (CUSTODYCD <> 'ALL')
       THEN
          V_CUSTODYCD := CUSTODYCD;
       ELSE
          V_Custodycd := '%';
       End If;

OPEN PV_REFCURSOR FOR

        Select Cf.Custodycd,Cf.Fullname,cf.idcode,Cf.Dateofbirth,Decode(Cf.Sex,001,'Nam','002','N?') Gioitinh,Nvl(Cf.Mobile,Cf.Phone) Dienthoai,
               Cf.Email,Cf.Address,Au.Fullname Nguoiuq,Au.Licenseno Cmnd_Uq,Au.Linkauth,Decode(Af.Tradeonline,'Y','Co','Khong') Gdtt,Decode(Af.Tradephone,'Y','Co','Khong') Gddt,
               Ot.Bankacc,Dl.Branch Careby_Daily,Cf.Refname,Cf1.Fullname Careby_Ctv,Af.Opndate,Tl.Tlname Careby_Nhanvien,tl1.tlname UserKichHoat,nl.maker_dt,
               ( Case When Substr(Au.Linkauth,1,1) ='Y' Then   (Select Cdcontent From  Allcode Al Where Al.Cdname ='LINKAUTH'And Cdval= '1' ) End) ||
               ( Case When Substr(Au.Linkauth,2,1) ='Y' Then   (Select Cdcontent From  Allcode Al Where Al.Cdname ='LINKAUTH'And Cdval= '2' ) End) ||
               ( Case When Substr(Au.Linkauth,3,1) ='Y' Then   (Select Cdcontent From  Allcode Al Where Al.Cdname ='LINKAUTH'And Cdval= '3' ) End) ||
               ( Case When Substr(Au.Linkauth,4,1) ='Y' Then   (Select Cdcontent From  Allcode Al Where Al.Cdname ='LINKAUTH'And Cdval= '4' ) End) ||
               ( Case When Substr(Au.Linkauth,5,1) ='Y' Then   (Select Cdcontent From  Allcode Al Where Al.Cdname ='LINKAUTH'And Cdval= '5' ) End) ||
               ( CASE WHEN SUBSTR(au.LINKAUTH,6,1) ='Y' THEN   (SELECT CDCONTENT FROM  ALLCODE AL WHERE AL.cdname ='LINKAUTH'AND CDVAL= '6' ) END) ||
               ( Case When Substr(Au.Linkauth,7,1) ='Y' Then   (Select Cdcontent From  Allcode Al Where Al.Cdname ='LINKAUTH'And Cdval= '7' ) End) ||
               ( Case When Substr(Au.Linkauth,8,1) ='Y' Then   (Select Cdcontent From  Allcode Al Where Al.Cdname ='LINKAUTH'And Cdval= '8' ) End) ||
               ( Case When Substr(Au.Linkauth,9,1) ='Y' Then   (Select Cdcontent From  Allcode Al Where Al.Cdname ='LINKAUTH'And Cdval= '9' ) End) ||
               ( Case When Substr(au.Linkauth,10,1) ='Y'Then   (Select Cdcontent From  Allcode Al Where Al.Cdname ='LINKAUTH'And Cdval= '10' ) End) aulink
        From Cfmast Cf,Afmast Af,Cfauth Au,Cfotheracc Ot,Sbs_Cfmast_Mapping_Branch Dl,afmast af1,cfmast cf1,tlprofiles tl,
              ( select distinct cf.custodycd,mt.maker_id,mt.maker_dt
                from maintain_log mt,cfmast cf,afmast af
                where cf.custid = af.custid
                    And Substr(Mt.Record_Key, 11, 10) = Af.Acctno
                    and mt.column_name ='OPNDATE'
                    and mt.action_flag = 'ADD'
                    And Mt.Mod_Num =0
               ) nl,tlprofiles tl1
        Where cf.custodycd = dl.custodycd (+)
              and Cf.Custid = Af.Custid
              And Af.Acctno = Au.Acctno(+)
              And Cf.Careby = 0026
              And Af.Acctno = Ot.Afacctno(+)
              And Cf.Refname = Af1.Acctno(+)
              And Af1.Custid = Cf1.Custid(+)
              And Cf.Tlid = Tl.Tlid(+)
              And Cf.Custodycd = Nl.Custodycd(+)
              And Tl1.Tlid(+) = Nl.Maker_Id
              And Af.Opndate <= To_Date (T_Date ,'DD/MM/YYYY') And Af.Opndate >= To_Date (F_Date ,'DD/MM/YYYY')
              and Cf.Custodycd like V_CUSTODYCD;
EXCEPTION
   WHEN OTHERS
   THEN
      Return;
End;
/

