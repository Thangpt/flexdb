CREATE OR REPLACE PROCEDURE cf0009 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   BRGID          IN       VARCHAR2,
   BRANCH         IN       VARCHAR2
 )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE       COMMENTS
-- Diennt      15/12/2011 Create
-- TheNN       15-Mar-2012  Modified    Sua lay len dung du lieu khi truyen vao ALL chi nhanh
-- ---------   ------     -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (4);    -- USED WHEN V_NUMOPTION > 0
   v_bgrid varchar2(10);
   V_branch  varchar2(100);
   V_BRANCHNAME VARCHAR2(2000);
-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE

BEGIN
-- INSERT INTO TEMP_BUG(TEXT) VALUES('CF0001');COMMIT;
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;
   IF (BRGID <> 'ALL')
   THEN
       v_bgrid:= BRGID;
   ELSE
      v_bgrid := '%%';
   END IF;
   -- V_branch:=BRANCH;
    -- LAY TEN CHI NHANH
    IF BRGID <> 'ALL' THEN
        SELECT BRNAME INTO V_BRANCHNAME FROM BRGRP WHERE BRID = BRGID;
    ELSE
        V_BRANCHNAME := '';
    END IF;
    select CDVAL into V_branch from allcode where cdname = 'BRANCH' and cdval = BRANCH;
OPEN PV_REFCURSOR
  FOR

    SELECT --DAU KY
        V_branch BRAN, BRGID BRANCHID, V_BRANCHNAME BRANCHNAME,
       ( --------dong trong ky D_TOCHUC_TN
             SELECT count( msgacct) FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0059' AND txdate <= to_date(T_DATE,'dd/mm/rrrr') AND txdate >= to_date(F_DATE,'dd/mm/rrrr') AND deltd <> 'Y'
                AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'B'
                AND cf.custatcom = 'Y'
                AND SUBSTR(cf.custid,1,4) like v_bgrid
                and SUBSTR(cf.custodycd,4,1) in ('C','P')
        ) D_TOCHUC_TN,
        ( --------dong trong ky D_CANHAN_TN
            SELECT count( msgacct) FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0059' AND txdate <= to_date(T_DATE,'dd/mm/rrrr') AND txdate >= to_date(F_DATE,'dd/mm/rrrr')
                AND deltd <> 'Y'
                AND cf.custid = vw_tllog_all.msgacct and cf.custtype = 'I'
                AND cf.custatcom = 'Y'
                AND SUBSTR(cf.custid,1,4) like v_bgrid
                and SUBSTR(cf.custodycd,4,1) in ('C','P')
        ) D_CANHAN_TN,
        (--------dong trong ky D_TOCHUC_NN
             SELECT count( msgacct) FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0059' AND txdate <= to_date(T_DATE,'dd/mm/rrrr') AND txdate >= to_date(F_DATE,'dd/mm/rrrr') AND deltd <> 'Y'
                AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'B'
                AND cf.custatcom = 'Y'
                AND SUBSTR(cf.custid,1,4) like v_bgrid
                and SUBSTR(cf.custodycd,4,1) in 'F'

        ) D_TOCHUC_NN,
        (--------dong trong ky D_CANHAN_NN
            SELECT count( msgacct) FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0059' AND txdate <= to_date(T_DATE,'dd/mm/rrrr') AND txdate >= to_date(F_DATE,'dd/mm/rrrr') AND deltd <> 'Y'
                AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'I'
                AND cf.custatcom = 'Y'
                AND SUBSTR(cf.custid,1,4) like v_bgrid
                and SUBSTR(cf.custodycd,4,1) in 'F'
        ) D_CANHAN_NN,

       --MO TRONG THaNG
       (    SELECT count(custid) FROM
            (SELECT custid FROM cfmast  WHERE opndate >= to_date(F_DATE,'dd/mm/rrrr') AND opndate <= to_date(T_DATE,'dd/mm/rrrr')
                    AND custtype = 'B'
                    and SUBSTR(custodycd,4,1)in ('C','P')
                    AND custatcom = 'Y'
                    and SUBSTR(custid,1,4)like v_bgrid
            union all
            /*(SELECT count(*) amt FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0059' AND busdate <= to_date(T_DATE,'dd/mm/rrrr') AND busdate >= to_date(F_DATE,'dd/mm/rrrr') AND deltd <> 'Y'
                AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'B'
                AND SUBSTR(cf.custid,1,4) like v_bgrid
                and SUBSTR(cf.custodycd,4,1) in ('C','P')
            ) b,*/
            SELECT vw_tllog_all.msgacct FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0067' AND busdate <= to_date(T_DATE,'dd/mm/rrrr') AND busdate >= to_date(F_DATE,'dd/mm/rrrr') AND deltd <> 'Y'
                AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'B'
                AND cf.custatcom = 'Y'
                AND SUBSTR(cf.custid,1,4) like v_bgrid
                and SUBSTR(cf.custodycd,4,1) in ('C','P')
            )
       ) GIUA_TOCHUC_TN,
       (SELECT count(custid) FROM
            (SELECT custid FROM cfmast  WHERE opndate >= to_date(F_DATE,'dd/mm/rrrr') AND opndate <= to_date(T_DATE,'dd/mm/rrrr')
                    AND custtype = 'I'
                    and SUBSTR(custodycd,4,1)in ('C','P')
                    AND custatcom = 'Y'
                    and SUBSTR(custid,1,4)like v_bgrid
            UNION all
            /*(SELECT count(*) amt FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0059' AND busdate <= to_date(T_DATE,'dd/mm/rrrr') AND busdate >= to_date(F_DATE,'dd/mm/rrrr') AND deltd <> 'Y'
                AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'I'
                AND SUBSTR(cf.custid,1,4) like v_bgrid
                and SUBSTR(cf.custodycd,4,1) in ('C','P')
            ) b,*/
            SELECT vw_tllog_all.msgacct custid FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0067' AND busdate <= to_date(T_DATE,'dd/mm/rrrr') AND busdate >= to_date(F_DATE,'dd/mm/rrrr') AND deltd <> 'Y'
                AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'I'
                AND cf.custatcom = 'Y'
                AND SUBSTR(cf.custid,1,4) like v_bgrid
                and SUBSTR(cf.custodycd,4,1) in ('C','P')
            )
      ) GIUA_CANHAN_TN,
       (SELECT count(custid) FROM
            (SELECT custid FROM cfmast WHERE opndate >= to_date(F_DATE,'dd/mm/rrrr') AND opndate <= to_date(T_DATE,'dd/mm/rrrr')
                    AND custtype = 'B'
                    and SUBSTR(custodycd,4,1)in 'F'
                    AND custatcom = 'Y'
                    and SUBSTR(custid,1,4)like v_bgrid

            UNION all
            /*(SELECT count(*) amt FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0059' AND busdate <= to_date(T_DATE,'dd/mm/rrrr') AND busdate >= to_date(F_DATE,'dd/mm/rrrr') AND deltd <> 'Y'
                AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'B'
                AND SUBSTR(cf.custid,1,4) like v_bgrid
                and SUBSTR(cf.custodycd,4,1) in 'F'
            ) b,*/
            SELECT vw_tllog_all.msgacct custid FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0067' AND busdate <= to_date(T_DATE,'dd/mm/rrrr') AND busdate >= to_date(F_DATE,'dd/mm/rrrr') AND deltd <> 'Y'
                AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'B'
                AND cf.custatcom = 'Y'
                AND SUBSTR(cf.custid,1,4) like v_bgrid
                and SUBSTR(cf.custodycd,4,1) in 'F'
           )
        ) GIUA_TOCHUC_NN,
       (SELECT count(custid) FROM
            (SELECT custid FROM cfmast WHERE opndate >= to_date(F_DATE,'dd/mm/rrrr') AND opndate <= to_date(T_DATE,'dd/mm/rrrr')
                    AND custtype = 'I'
                    and SUBSTR(custodycd,4,1)in 'F'
                    AND custatcom = 'Y'
                    and SUBSTR(custid,1,4)like v_bgrid
            UNION all
            /*(SELECT count(*) amt FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0059' AND busdate <= to_date(T_DATE,'dd/mm/rrrr') AND busdate >= to_date(F_DATE,'dd/mm/rrrr') AND deltd <> 'Y'
                AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'I'
                AND SUBSTR(cf.custid,1,4) like v_bgrid
                and SUBSTR(cf.custodycd,4,1) in 'F'
            ) b,*/
            SELECT vw_tllog_all.msgacct custid FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0067' AND busdate <= to_date(T_DATE,'dd/mm/rrrr') AND busdate >= to_date(F_DATE,'dd/mm/rrrr') AND deltd <> 'Y'
                AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'I'
                AND cf.custatcom = 'Y'
                AND SUBSTR(cf.custid,1,4) like v_bgrid
                and SUBSTR(cf.custodycd,4,1) in 'F'
            )

       ) GIUA_CANHAN_NN,

       --CUOI KY
        (SELECT a.amt - b.amt + c.amt FROM
            (SELECT count(*) amt FROM cfmast WHERE opndate <= to_date(T_DATE,'dd/mm/rrrr')
                    AND custtype = 'B'
                    and SUBSTR(custodycd,4,1)in ('C','P')
                    AND custatcom = 'Y'
                    and SUBSTR(custid,1,4)like v_bgrid
            ) a,
            (SELECT count(*) amt FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0059' AND busdate <= to_date(T_DATE,'dd/mm/rrrr')  AND deltd <> 'Y'
                AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'B'
                AND cf.custatcom = 'Y'
                AND SUBSTR(cf.custid,1,4) like v_bgrid
                and SUBSTR(cf.custodycd,4,1) in ('C','P')
            ) b,
            (SELECT count(*) amt FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0067' AND busdate <= to_date(T_DATE,'dd/mm/rrrr') AND deltd <> 'Y'
                AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'B'
                AND cf.custatcom = 'Y'
                AND SUBSTR(cf.custid,1,4) like v_bgrid
                and SUBSTR(cf.custodycd,4,1) in ('C','P')
            )c
        ) CK_TOCHUC_TN,
       (SELECT a.amt - b.amt + c.amt FROM
            (SELECT count(*) amt FROM cfmast WHERE  opndate <= to_date(T_DATE,'dd/mm/rrrr')
                    AND custtype = 'I'
                    and SUBSTR(custodycd,4,1)in ('C','P')
                    AND custatcom = 'Y'
                    and SUBSTR(custid,1,4)like v_bgrid
            ) a,
            (SELECT count(*) amt FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0059' AND busdate <= to_date(T_DATE,'dd/mm/rrrr') AND deltd <> 'Y'
                AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'I'
                AND cf.custatcom = 'Y'
                AND SUBSTR(cf.custid,1,4) like v_bgrid
                and SUBSTR(cf.custodycd,4,1) in ('C','P')
            ) b,
            (SELECT count(*) amt FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0067' AND busdate <= to_date(T_DATE,'dd/mm/rrrr')  AND deltd <> 'Y'
                AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'I'
                AND cf.custatcom = 'Y'
                AND SUBSTR(cf.custid,1,4) like v_bgrid
                and SUBSTR(cf.custodycd,4,1) in ('C','P')
            )c
       ) CK_CANHAN_TN,
       (SELECT a.amt - b.amt + c.amt FROM
            (SELECT count(*) amt FROM cfmast WHERE  opndate <= to_date(T_DATE,'dd/mm/rrrr')
                    AND custtype = 'B'
                    and SUBSTR(custodycd,4,1)in 'F'
                    AND custatcom = 'Y'
                    and SUBSTR(custid,1,4)like v_bgrid
            ) a,
            (SELECT count(*) amt FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0059' AND busdate <= to_date(T_DATE,'dd/mm/rrrr')  AND deltd <> 'Y'
                AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'B'
                AND cf.custatcom = 'Y'
                AND SUBSTR(cf.custid,1,4) like v_bgrid
                and SUBSTR(cf.custodycd,4,1) in 'F'
            ) b,
            (SELECT count(*) amt FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0067' AND busdate <= to_date(T_DATE,'dd/mm/rrrr')  AND deltd <> 'Y'
                AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'B'
                AND cf.custatcom = 'Y'
                AND SUBSTR(cf.custid,1,4) like v_bgrid
                and SUBSTR(cf.custodycd,4,1) in 'F'
            )c
       ) CK_TOCHUC_NN,
       (SELECT a.amt - b.amt + c.amt FROM
            (SELECT count(*) amt FROM cfmast WHERE  opndate <= to_date(T_DATE,'dd/mm/rrrr')
                    AND custtype = 'I'
                    and SUBSTR(custodycd,4,1)in 'F'
                    AND custatcom = 'Y'
                    and SUBSTR(custid,1,4)like v_bgrid
            ) a,
            (SELECT count(*) amt FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0059' AND busdate <= to_date(T_DATE,'dd/mm/rrrr')  AND deltd <> 'Y'
                AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'I'
                AND cf.custatcom = 'Y'
                AND SUBSTR(cf.custid,1,4) like v_bgrid
                and SUBSTR(cf.custodycd,4,1) in 'F'
            ) b,
            (SELECT count(*) amt FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0067' AND busdate <= to_date(T_DATE,'dd/mm/rrrr')  AND deltd <> 'Y'
                AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'I'
                AND cf.custatcom = 'Y'
                AND SUBSTR(cf.custid,1,4) like v_bgrid
                and SUBSTR(cf.custodycd,4,1) in 'F'
            )c
       ) CK_CANHAN_NN,
       -- Dau ky
       (SELECT a.amt - b.amt + c.amt FROM
            (SELECT count(*) amt FROM cfmast WHERE opndate < to_date(F_DATE,'dd/mm/rrrr')
                    AND custtype = 'B'
                    and SUBSTR(custodycd,4,1)in ('C','P')
                    AND custatcom = 'Y'
                    and SUBSTR(custid,1,4)like v_bgrid
            ) a,
            (SELECT count(*) amt FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0059' AND busdate < to_date(F_DATE,'dd/mm/rrrr')  AND deltd <> 'Y'
                AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'B'
                AND cf.custatcom = 'Y'
                AND SUBSTR(cf.custid,1,4) like v_bgrid
                and SUBSTR(cf.custodycd,4,1) in ('C','P')
            ) b,
            (SELECT count(*) amt FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0067' AND busdate < to_date(F_DATE,'dd/mm/rrrr') AND deltd <> 'Y'
                AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'B'
                AND cf.custatcom = 'Y'
                AND SUBSTR(cf.custid,1,4) like v_bgrid
                and SUBSTR(cf.custodycd,4,1) in ('C','P')
            )c
        ) DK_TOCHUC_TN,
       (SELECT a.amt - b.amt + c.amt FROM
            (SELECT count(*) amt FROM cfmast WHERE  opndate < to_date(F_DATE,'dd/mm/rrrr')
                    AND custtype = 'I'
                    and SUBSTR(custodycd,4,1)in ('C','P')
                    AND custatcom = 'Y'
                    and SUBSTR(custid,1,4)like v_bgrid
            ) a,
            (SELECT count(*) amt FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0059' AND busdate < to_date(F_DATE,'dd/mm/rrrr') AND deltd <> 'Y'
                AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'I'
                AND cf.custatcom = 'Y'
                AND SUBSTR(cf.custid,1,4) like v_bgrid
                and SUBSTR(cf.custodycd,4,1) in ('C','P')
            ) b,
            (SELECT count(*) amt FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0067' AND busdate < to_date(F_DATE,'dd/mm/rrrr')  AND deltd <> 'Y'
                AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'I'
                AND cf.custatcom = 'Y'
                AND SUBSTR(cf.custid,1,4) like v_bgrid
                and SUBSTR(cf.custodycd,4,1) in ('C','P')
            )c
       ) DK_CANHAN_TN,
       (SELECT a.amt - b.amt + c.amt FROM
            (SELECT count(*) amt FROM cfmast WHERE  opndate < to_date(F_DATE,'dd/mm/rrrr')
                    AND custtype = 'B'
                    and SUBSTR(custodycd,4,1)in 'F'
                    AND custatcom = 'Y'
                    and SUBSTR(custid,1,4)like v_bgrid
            ) a,
            (SELECT count(*) amt FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0059' AND busdate < to_date(F_DATE,'dd/mm/rrrr')  AND deltd <> 'Y'
                AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'B'
                AND cf.custatcom = 'Y'
                AND SUBSTR(cf.custid,1,4) like v_bgrid
                and SUBSTR(cf.custodycd,4,1) in 'F'
            ) b,
            (SELECT count(*) amt FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0067' AND busdate < to_date(F_DATE,'dd/mm/rrrr')  AND deltd <> 'Y'
                AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'B'
                AND cf.custatcom = 'Y'
                AND SUBSTR(cf.custid,1,4) like v_bgrid
                and SUBSTR(cf.custodycd,4,1) in 'F'
            )c
       ) DK_TOCHUC_NN,
       (SELECT a.amt - b.amt + c.amt FROM
            (SELECT count(*) amt FROM cfmast WHERE  opndate < to_date(F_DATE,'dd/mm/rrrr')
                    AND custtype = 'I'
                    and SUBSTR(custodycd,4,1)in 'F'
                    AND custatcom = 'Y'
                    and SUBSTR(custid,1,4)like v_bgrid
            ) a,
            (SELECT count(*) amt FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0059' AND busdate < to_date(F_DATE,'dd/mm/rrrr')  AND deltd <> 'Y'
                AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'I'
                AND cf.custatcom = 'Y'
                AND SUBSTR(cf.custid,1,4) like v_bgrid
                and SUBSTR(cf.custodycd,4,1) in 'F'
            ) b,
            (SELECT count(*) amt FROM vw_tllog_all, cfmast cf
                WHERE tltxcd = '0067' AND busdate < to_date(F_DATE,'dd/mm/rrrr')  AND deltd <> 'Y'
                AND cf.custid = vw_tllog_all.msgacct AND cf.custtype = 'I'
                AND cf.custatcom = 'Y'
                AND SUBSTR(cf.custid,1,4) like v_bgrid
                and SUBSTR(cf.custodycd,4,1) in 'F'
            )c
       ) DK_CANHAN_NN
    FROM DUAL ;

EXCEPTION
   WHEN OTHERS
   THEN
    dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
End;
/

