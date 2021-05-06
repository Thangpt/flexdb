CREATE OR REPLACE PROCEDURE CF9901 (
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
--danh sach TK dang ky giao dich truc tuyen
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

        select cf.custodycd,cf.fullname,cf.idcode,cf.email,dl.branch DL,af.opndate,tl.tlname UserKichHoat,nl.maker_dt NgayKichHoat
        From Cfmast Cf,Afmast Af,Sbs_Cfmast_Mapping_Branch Dl,Tlprofiles Tl,
              ( select distinct cf.custodycd,mt.maker_id,mt.maker_dt
                from maintain_log mt,cfmast cf,afmast af
                where cf.custid = af.custid
                    And Substr(Mt.Record_Key, 11, 10) = Af.Acctno
                    and mt.column_name ='TRADEONLINE'
                    and mt.action_flag = 'ADD'
                    and mt.mod_num =0
               ) nl
        where cf.custid = af.custid
              and cf.custodycd = dl.custodycd(+)
              and cf.custodycd = nl.custodycd(+)
              And Tl.Tlid(+) = Nl.Maker_Id
              And Af.Tradeonline ='Y' And Af.Status <> 'C'
              And Nl.Maker_Dt <= To_Date (T_Date ,'DD/MM/YYYY') And Nl.Maker_Dt >= To_Date (F_Date ,'DD/MM/YYYY')
              and cf.custodycd like V_CUSTODYCD
        order by nl.maker_dt asc;

EXCEPTION
   WHEN OTHERS
   THEN
      Return;
END;
/

