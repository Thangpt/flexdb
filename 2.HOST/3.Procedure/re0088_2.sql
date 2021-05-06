CREATE OR REPLACE PROCEDURE re0088_2 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   INMONTH        IN       VARCHAR2,
   CUSTID         IN       VARCHAR2,
   REROLE         IN       VARCHAR2,
   PV_TLID        IN       VARCHAR2,
   RDCUSTID       in       varchar2 default 'ALL',
   RDREROLE       IN       varchar2 default 'ALL'
 )
IS
--bao cao gia tri giao dich
--created by Chaunh at 11/01/2012
    V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID          VARCHAR2 (40);      -- USED WHEN V_NUMOPTION > 0
    V_INBRID     VARCHAR2 (5);
    V_INDATE DATE;
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
   V_INDATE := LAST_DAY(TO_DATE('01/' || SUBSTR(INMONTH,1,2) || '/' || SUBSTR(INMONTH,3,4),'DD/MM/YYYY'));
   v_strtlid := '';
   l_format := '000000';
   l_length := length(l_format);
   for ul in (select * from reuserlnk u where tlid = PV_TLID
   )
   loop
        l_segment := l_format || to_char(ul.refrecflnkid);
        select  v_strtlid || ',' || SUBSTR(l_segment, length(l_segment)-l_length+1,l_length) into v_strtlid from dual;
   end loop;

OPEN PV_REFCURSOR FOR
    SELECT a.*, INMONTH INMONTH FROM tbl_re0088_1_log a
    WHERE rerole LIKE V_REROLE
        AND instr(v_strtlid,SUBSTR(l_format || to_char(refrecflnkid), length(l_format || to_char(refrecflnkid))-l_length+1,l_length)) <> 0
        AND LAST_DAY(txdate) = V_INDATE
        AND extcustid LIKE V_RDCUSTID
        AND extrole LIKE V_RDREROLE

;

EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
END;
/

