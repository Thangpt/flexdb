CREATE OR REPLACE PROCEDURE cf9903 (
   Pv_Refcursor   In Out   Pkg_Report.Ref_Cursor,
   Opt            In       Varchar2,
   Brid           In       Varchar2,
   Custodycd      In       Varchar2,
   Careby         IN       VARCHAR2
)
IS
--
--danh sach khach hang dang ky chuyen tien truc tuyen
-- ---------   ------  -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_Strbrid          Varchar2 (4);              -- USED WHEN V_NUMOPTION > 0

   V_CUSTODYCD       VARCHAR2 (20);
   V_STRCAREBY       VARCHAR2 (20);

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
       Else
          V_CUSTODYCD := '%';
       End If;

   IF (CAREBY  <> 'ALL')
   THEN
      V_STRCAREBY := CAREBY;
   ELSE
      V_STRCAREBY := '%';
   END IF;

   -- END OF GETTING REPORT'S PARAMETERS


 Open Pv_Refcursor FOR

    Select Cf.Custodycd,Cf.Fullname,cf.idcode,au.fullname NguoiUQ,au.licenseno CMND_UQ,Ot.Bankacname Nguoithuhuong,Ot.Bankacc,Ot.Bankname--,ot.acnidcode,ot.acniddate,ot.acnidplace
    From Cfmast Cf,Afmast Af,cfotheracc ot,cfauth au
    Where Cf.Custid = Af.Custid
          And Af.Acctno(+) = Ot.Afacctno
          And Ot.Bankacc Is Not Null
          And Af.Acctno = Au.Acctno(+)
          And Cf.Custodycd Like V_CUSTODYCD
          And Nvl(Cf.Careby,'-') Like V_STRCAREBY;

 EXCEPTION
   WHEN OTHERS
   THEN
      Return;
END;
-- PROCEDURE
/

