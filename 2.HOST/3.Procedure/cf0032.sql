CREATE OR REPLACE PROCEDURE cf0032 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2
 )
IS
--
-- PURPOSE: DSKH HUY, THAY DOI NOI DUNG UY QUYEN
-- MODIFICATION HISTORY
-- PERSON       DATE        COMMENTS
-- THENN        03-MAR-2012 CREATED
-- CHAUNH       19-MAR-2013 RECREATED
-- ---------    ------      -------------------------------------------

   V_STROPTION         VARCHAR2  (5);
   V_STRBRID           VARCHAR2  (40);
   v_brid              VARCHAR2(4);
   V_CUSTODYCD      VARCHAR2(10);
   V_AFACCTNO       VARCHAR2(10);
   V_AUTH1      VARCHAR2(2000);
   V_AUTH2      VARCHAR2(2000);
   V_AUTH3      VARCHAR2(2000);
   V_AUTH4      VARCHAR2(2000);
   V_AUTH5      VARCHAR2(2000);
   V_AUTH6      VARCHAR2(2000);
   V_AUTH7      VARCHAR2(2000);
   V_AUTH8      VARCHAR2(2000);
   V_AUTH9      VARCHAR2(2000);
   V_AUTH10      VARCHAR2(2000);
   V_AUTH11      VARCHAR2(2000);

BEGIN
    -- GET REPORT'S PARAMETERS
   V_STROPTION := OPT;
      v_brid := brid;


   IF  V_STROPTION = 'A' and v_brid = '0001' then
    V_STRBRID := '%';
    elsif V_STROPTION = 'B' then
        select br.mapid into V_STRBRID from brgrp br where br.brid = v_brid;
    else V_STROPTION := v_brid;

END IF;

   IF PV_CUSTODYCD IS NULL OR PV_CUSTODYCD = 'ALL' THEN
      V_CUSTODYCD := '%%';
   ELSE
      V_CUSTODYCD := PV_CUSTODYCD;
   END IF;

   IF PV_AFACCTNO IS NULL OR PV_AFACCTNO = 'ALL' THEN
      V_AFACCTNO := '%%';
   ELSE
      V_AFACCTNO := PV_AFACCTNO;
   END IF;

   -- GET INFORMATION OF AUTH'STRING
    SELECT MAX(AUTH1) AUTH1,MAX(AUTH2) AUTH2,MAX(AUTH3) AUTH3,MAX(AUTH4) AUTH4,MAX(AUTH5) AUTH5,
        MAX(AUTH6) AUTH6,MAX(AUTH7) AUTH7,MAX(AUTH8) AUTH8,MAX(AUTH9) AUTH9,MAX(AUTH10) AUTH10,MAX(AUTH11) AUTH11
    INTO V_AUTH1,V_AUTH2,V_AUTH3,V_AUTH4,V_AUTH5,V_AUTH6,V_AUTH7,V_AUTH8,V_AUTH9,V_AUTH10,V_AUTH11
    FROM
    (
        SELECT DECODE(A.CDVAL,'1',CDCONTENT,'') AUTH1,
            DECODE(A.CDVAL,'2',CDCONTENT,'') AUTH2,
            DECODE(A.CDVAL,'3',CDCONTENT,'') AUTH3,
            DECODE(A.CDVAL,'4',CDCONTENT,'') AUTH4,
            DECODE(A.CDVAL,'5',CDCONTENT,'') AUTH5,
            DECODE(A.CDVAL,'6',CDCONTENT,'') AUTH6,
            DECODE(A.CDVAL,'7',CDCONTENT,'') AUTH7,
            DECODE(A.CDVAL,'8',CDCONTENT,'') AUTH8,
            DECODE(A.CDVAL,'9',CDCONTENT,'') AUTH9,
            DECODE(A.CDVAL,'10',CDCONTENT,'') AUTH10,
            DECODE(A.CDVAL,'11',CDCONTENT,'') AUTH11
        FROM allcode A
        WHERE CDTYPE = 'CF' AND CDNAME = 'LINKAUTH'
    );

    OPEN PV_REFCURSOR
    FOR
   -- this code created at 19/03/2013
select a.* ,
    RTRIM(CASE WHEN LENGTH(from_LINKAUTH) >0 THEN
                DECODE(SUBSTR(from_LINKAUTH,1,1),'Y',b.AUTH1 || ', ','')
                || DECODE(SUBSTR(from_LINKAUTH,2,1),'Y',b.AUTH2 || ', ','')
                || DECODE(SUBSTR(from_LINKAUTH,3,1),'Y',b.AUTH3 || ', ','')
                || DECODE(SUBSTR(from_LINKAUTH,4,1),'Y',b.AUTH4 || ', ','')
                || DECODE(SUBSTR(from_LINKAUTH,5,1),'Y',b.AUTH5 || ', ','')
                || DECODE(SUBSTR(from_LINKAUTH,6,1),'Y',b.AUTH6 || ', ','')
                || DECODE(SUBSTR(from_LINKAUTH,8,1),'Y',b.AUTH8 || ', ','')
                || DECODE(SUBSTR(from_LINKAUTH,9,1),'Y',b.AUTH9 || ', ','')
                || DECODE(SUBSTR(from_LINKAUTH,10,1),'Y',b.AUTH10 || ', ','')
                || DECODE(SUBSTR(from_LINKAUTH,11,1),'Y',b.AUTH11|| ', ','')
                || DECODE(SUBSTR(from_LINKAUTH,12,1),'Y',b.AUTH12,'')
             ELSE '' END,', ') from_LINKAUTHDTL,
        RTRIM(CASE WHEN LENGTH(to_LINKAUTH) >0 THEN
                DECODE(SUBSTR(to_LINKAUTH,1,1),'Y',b.AUTH1 || ', ','')
                || DECODE(SUBSTR(to_LINKAUTH,2,1),'Y',b.AUTH2 || ', ','')
                || DECODE(SUBSTR(to_LINKAUTH,3,1),'Y',b.AUTH3 || ', ','')
                || DECODE(SUBSTR(to_LINKAUTH,4,1),'Y',b.AUTH4 || ', ','')
                || DECODE(SUBSTR(to_LINKAUTH,5,1),'Y',b.AUTH5 || ', ','')
                || DECODE(SUBSTR(to_LINKAUTH,6,1),'Y',b.AUTH6 || ', ','')
                || DECODE(SUBSTR(to_LINKAUTH,8,1),'Y',b.AUTH8 || ', ','')
                || DECODE(SUBSTR(to_LINKAUTH,9,1),'Y',b.AUTH9 || ', ','')
                || DECODE(SUBSTR(to_LINKAUTH,10,1),'Y',b.AUTH10 || ', ','')
                || DECODE(SUBSTR(to_LINKAUTH,11,1),'Y',b.AUTH11|| ', ','')
                || DECODE(SUBSTR(to_LINKAUTH,12,1),'Y',b.AUTH12,'')
             ELSE '' END,', ') to_LINKAUTHDTL
from
(select UQ_CUSTID, KH_CUSTID, maker_dt, approve_dt, kh_name, uq_name, kh_custo, kh_acctno, valdate, expdate, idcode,
    max(case when column_name = 'IDDATE' then from_value else ' ' end ) from_IDDATE,
     max(case when column_name = 'IDPLACE' then from_value else ' ' end ) from_IDPLACE,
     max(case when column_name = 'IDCODE' then from_value else ' ' end ) from_IDCODE,
     max(case when column_name = 'ADDRESS' then from_value else ' ' end ) from_ADDRESS,
     max(case when column_name = 'LINKAUTH' then from_value else ' ' end ) from_LINKAUTH,
     max(case when column_name = 'VALDATE' then from_value else ' ' end ) from_VALDATE,
     max(case when column_name = 'EXPDATE' then from_value else ' ' end ) from_EXPDATE,
     max(case when column_name = 'IDDATE' then to_value else ' ' end ) to_IDDATE,
     max(case when column_name = 'IDPLACE' then to_value else ' ' end ) to_IDPLACE,
     max(case when column_name = 'IDCODE' then to_value else ' ' end ) to_IDCODE,
     max(case when column_name = 'ADDRESS' then to_value else ' ' end ) to_ADDRESS,
     max(case when column_name = 'LINKAUTH' then to_value else ' ' end ) to_LINKAUTH,
     max(case when column_name = 'VALDATE' then to_value else ' ' end ) to_VALDATE,
     max(case when column_name = 'EXPDATE' then to_value else ' ' end ) to_EXPDATE
 from
    (-- thong tin nguoi uy quyen bi thay doi
    select kh_name, uq_name, kh_custo, kh_acctno, idcode,
            substr(l.record_key, 11,10) UQ_custid,a.kh_custid kh_custid,
            l.maker_dt, l.approve_dt, l.column_name, l.from_value, l.to_value, l.child_table_name, l.table_name,
            a.valdate, a.expdate
    from maintain_log l,
        (
        select a.valdate, a.expdate, c1.custid kh_custid, a1.acctno kh_acctno, c2.custid uq_custid, c1.fullname kh_name, c2.fullname uq_name, c1.custodycd kh_custo, c1.idcode
        from cfauth a, cfmast c1, cfmast c2, afmast a1
        where a.acctno = a1.acctno and a1.custid = c1.custid
        and a.custid = c2.custid --and a.acctno = '0001000002'
        and c1.custodycd like V_CUSTODYCD
        and a1.acctno like V_AFACCTNO
        group by  a.valdate, a.expdate, c2.custid,  c1.custid, c1.fullname , c2.fullname , c1.custodycd, c1.idcode, a1.acctno
        ) a
    where  l.action_flag= 'EDIT' and l.column_name in ('IDCODE','IDPLACE','IDDATE','ADDRESS')
    and l.table_name = 'CFMAST' and a.uq_custid = substr(l.record_key, 11,10)
    and maker_dt <= to_date(T_DATE,'DD/MM/RRRR')
    and maker_dt >= to_date(F_DATE,'DD/MM/RRRR')
    union all
    -- thong tin quyen cua nguoi uy quyen bi thay doi
    select  c.fullname kh_name, cfau.fullname uq_name, c.custodycd kh_custo, a.acctno kh_acctno, c.idcode,
            auth.custid UQ_custid,c.custid kh_custid,
            l.maker_dt, l.approve_dt, l.column_name, l.from_value, l.to_value, l.child_table_name, l.table_name ,
            auth.valdate, auth.expdate
    from maintain_log l, cfmast c, afmast a, cfauth auth, cfmast cfau
    where action_flag = 'EDIT' and table_name = 'AFMAST' and child_table_name = 'CFAUTH' and column_name in ('LINKAUTH','VALDATE','EXPDATE')
    and a.custid = c.custid and substr(l.record_key, 11,10)= a.acctno
    and substr(l.child_record_key, 10,4) = auth.autoid
    and auth.custid = cfau.custid
    and c.custodycd like V_CUSTODYCD and a.acctno like V_AFACCTNO
    and maker_dt <= to_date(T_DATE,'DD/MM/RRRR')
    and maker_dt >= to_date(F_DATE,'DD/MM/RRRR')
    ) main
 group by UQ_CUSTID, KH_CUSTID, maker_dt, approve_dt, approve_dt, kh_name, uq_name, kh_custo, kh_acctno, valdate, expdate, idcode
) a,
(
 SELECT MAX(AUTH1) AUTH1,MAX(AUTH2) AUTH2,MAX(AUTH3) AUTH3,MAX(AUTH4) AUTH4,MAX(AUTH5) AUTH5,
        MAX(AUTH6) AUTH6,MAX(AUTH7) AUTH7,MAX(AUTH8) AUTH8,MAX(AUTH9) AUTH9,MAX(AUTH10) AUTH10,MAX(AUTH11) AUTH11,MAX(AUTH12) AUTH12
 FROM
    (
        SELECT DECODE(A.CDVAL,'1',CDCONTENT,'') AUTH1,
            DECODE(A.CDVAL,'2',CDCONTENT,'') AUTH2,
            DECODE(A.CDVAL,'3',CDCONTENT,'') AUTH3,
            DECODE(A.CDVAL,'4',CDCONTENT,'') AUTH4,
            DECODE(A.CDVAL,'5',CDCONTENT,'') AUTH5,
            DECODE(A.CDVAL,'6',CDCONTENT,'') AUTH6,
            DECODE(A.CDVAL,'7',CDCONTENT,'') AUTH7,
            DECODE(A.CDVAL,'8',CDCONTENT,'') AUTH8,
            DECODE(A.CDVAL,'9',CDCONTENT,'') AUTH9,
            DECODE(A.CDVAL,'10',CDCONTENT,'') AUTH10,
            DECODE(A.CDVAL,'11',CDCONTENT,'') AUTH11,
            DECODE(A.CDVAL,'12',CDCONTENT,'') AUTH12
        FROM allcode A
        WHERE CDTYPE = 'CF' AND CDNAME = 'LINKAUTH'
    )
 ) b



 -------------------*****---------------------------------------------------------
    --code below belong THENN
    /*SELECT A.*, DECODE(A.ACTION_FLAG,'EDIT', TO_CHAR(A.CHANGEDATE,'DD/MM/YYYY'), '') EDITDATE,
        RTRIM(CASE WHEN LENGTH(OLDLINKAUTH) >0 THEN
                DECODE(SUBSTR(OLDLINKAUTH,1,1),'Y',V_AUTH1 || ', ','')
                || DECODE(SUBSTR(OLDLINKAUTH,2,1),'Y',V_AUTH2 || ', ','')
                || DECODE(SUBSTR(OLDLINKAUTH,3,1),'Y',V_AUTH3 || ', ','')
                || DECODE(SUBSTR(OLDLINKAUTH,4,1),'Y',V_AUTH4 || ', ','')
                || DECODE(SUBSTR(OLDLINKAUTH,5,1),'Y',V_AUTH5 || ', ','')
                || DECODE(SUBSTR(OLDLINKAUTH,6,1),'Y',V_AUTH6 || ', ','')
                || DECODE(SUBSTR(OLDLINKAUTH,8,1),'Y',V_AUTH8 || ', ','')
                || DECODE(SUBSTR(OLDLINKAUTH,9,1),'Y',V_AUTH9 || ', ','')
                || DECODE(SUBSTR(OLDLINKAUTH,10,1),'Y',V_AUTH10 || ', ','')
                || DECODE(SUBSTR(OLDLINKAUTH,11,1),'Y',V_AUTH11,'')
             ELSE '' END,', ') OLDLINKAUTHDTL,
        RTRIM(CASE WHEN LENGTH(NEWLINKAUTH) >0 THEN
                DECODE(SUBSTR(NEWLINKAUTH,1,1),'Y',V_AUTH1 || ', ','')
                || DECODE(SUBSTR(NEWLINKAUTH,2,1),'Y',V_AUTH2 || ', ','')
                || DECODE(SUBSTR(NEWLINKAUTH,3,1),'Y',V_AUTH3 || ', ','')
                || DECODE(SUBSTR(NEWLINKAUTH,4,1),'Y',V_AUTH4 || ', ','')
                || DECODE(SUBSTR(NEWLINKAUTH,5,1),'Y',V_AUTH5 || ', ','')
                || DECODE(SUBSTR(NEWLINKAUTH,6,1),'Y',V_AUTH6 || ', ','')
                || DECODE(SUBSTR(NEWLINKAUTH,8,1),'Y',V_AUTH8 || ', ','')
                || DECODE(SUBSTR(NEWLINKAUTH,9,1),'Y',V_AUTH9 || ', ','')
                || DECODE(SUBSTR(NEWLINKAUTH,10,1),'Y',V_AUTH10 || ', ','')
                || DECODE(SUBSTR(NEWLINKAUTH,11,1),'Y',V_AUTH11,'')
             ELSE '' END,', ') NEWLINKAUTHDTL
    FROM
    (
        SELECT AF.CUSTODYCD, AF.AFACCTNO, AF.FULLNAME, AF.IDCODE, AF.IDTYPE, AF.CUSTTYPE, AF.CUSTID, AF.AUTHFULLNAME,
            CASE WHEN CE.OLDLICENSE IS NULL THEN AF.AUTHIDCODE ELSE NVL(CE.OLDLICENSE,'') END AUTHIDCODE,
            AF.AUTHIDTYPE, AF.AUTHCUSTTYPE, AF.AUTHIDDATE,
            AF.AUTOID, AF.ADDNEWDATE, AF.CHANGEDATE, AF.ACTION_FLAG, NVL(AD.DELDATE,'') DELDATE, NVL(AE.OLDLINKAUTH,'') OLDLINKAUTH, NVL(AE.NEWLINKAUTH,'') NEWLINKAUTH,
            NVL(CE.OLDLICENSE,'') OLDLICENSE, NVL(CE.NEWLICENSE,'') NEWLICENSE, DECODE(AF.ACTION_FLAG,'EDIT',0,1) ODRNUM
        FROM
        (
            SELECT CF.CUSTODYCD, AF.ACCTNO AFACCTNO, CF.FULLNAME, CF.IDCODE, CF.IDTYPE, CF.CUSTTYPE, CFA.CUSTID, CF2.FULLNAME AUTHFULLNAME,
                    CF2.IDCODE AUTHIDCODE, CF2.IDTYPE AUTHIDTYPE, CF2.CUSTTYPE AUTHCUSTTYPE, TO_CHAR(CF2.IDDATE,'DD/MM/YYYY') AUTHIDDATE, CFA.AUTOID,
                    TO_CHAR(CFA.VALDATE,'DD/MM/YYYY') ADDNEWDATE, IC.CHANGEDATE, IC.ACTION_FLAG
                FROM CFMAST CF, AFMAST AF, CFAUTH CFA, CFMAST CF2,
                (
                    SELECT AFACCTNO, AUTHAUTOID, CHANGEDATE, ACTION_FLAG
                    FROM
                    (
                        SELECT SUBSTR(MTL.RECORD_KEY,11,10) AFACCTNO, TO_NUMBER(REPLACE(SUBSTR(MTL.CHILD_RECORD_KEY,9),'''','')) AUTHAUTOID,
                                MTL.MAKER_DT CHANGEDATE, MTL.ACTION_FLAG
                            FROM MAINTAIN_LOG MTL
                            WHERE MTL.TABLE_NAME = 'AFMAST' AND MTL.CHILD_TABLE_NAME = 'CFAUTH'
                                AND MTL.ACTION_FLAG in ('DELETE','EDIT')
                                AND MTL.MAKER_DT >= TO_DATE(F_DATE,'DD/MM/YYYY')
                                AND MTL.MAKER_DT <= TO_DATE(T_DATE,'DD/MM/YYYY')
                        UNION ALL
                        SELECT CFA.ACCTNO AFACCTNO, CFA.AUTOID AUTHAUTOID, MTL.MAKER_DT CHANGEDATE, MTL.ACTION_FLAG
                            FROM CFAUTH CFA, MAINTAIN_LOG MTL
                            WHERE MTL.TABLE_NAME = 'CFMAST'
                                AND MTL.ACTION_FLAG = 'EDIT'
                                AND MTL.COLUMN_NAME = 'IDCODE'
                                AND CFA.CUSTID = SUBSTR(MTL.RECORD_KEY,11,10)
                                AND MTL.MAKER_DT >= TO_DATE(F_DATE,'DD/MM/YYYY')
                                AND MTL.MAKER_DT <= TO_DATE(T_DATE,'DD/MM/YYYY')
                    ) MTL
                    GROUP BY MTL.AFACCTNO, MTL.AUTHAUTOID, MTL.CHANGEDATE, MTL.ACTION_FLAG
                ) IC
                WHERE CF.CUSTID = AF.CUSTID
                    AND AF.ACCTNO = CFA.ACCTNO
                    AND CFA.CUSTID = CF2.CUSTID
                    AND AF.ACCTNO = IC.AFACCTNO
                    AND IC.AUTHAUTOID = CFA.AUTOID
                    AND CF.CUSTODYCD LIKE V_CUSTODYCD
                    AND (af.brid like V_STRBRID or instr(V_STRBRID,af.brid) <> 0 )
                    AND AF.ACCTNO LIKE V_AFACCTNO
        ) AF
        LEFT JOIN
        (
            SELECT SUBSTR(MTL.RECORD_KEY,11,10) AFACCTNO, TO_NUMBER(REPLACE(SUBSTR(MTL.CHILD_RECORD_KEY,9),'''','')) AUTHAUTOID,
                    TO_CHAR(MTL.MAKER_DT,'DD/MM/YYYY') DELDATE, 4 ODRNUM, MTL.MAKER_DT CHANGEDATE, MTL.ACTION_FLAG
                FROM MAINTAIN_LOG MTL
                WHERE MTL.TABLE_NAME = 'AFMAST' AND MTL.CHILD_TABLE_NAME = 'CFAUTH'
                    AND MTL.ACTION_FLAG = 'DELETE'
                    AND MTL.MAKER_DT >= TO_DATE(F_DATE,'DD/MM/YYYY')
                    AND MTL.MAKER_DT <= TO_DATE(T_DATE,'DD/MM/YYYY')
        ) AD
        ON AF.AFACCTNO = AD.AFACCTNO AND AF.AUTOID = AD.AUTHAUTOID AND AF.CHANGEDATE = AD.CHANGEDATE AND AF.ACTION_FLAG = AD.ACTION_FLAG
        LEFT JOIN
        (
            SELECT SUBSTR(MTL.RECORD_KEY,11,10) AFACCTNO, TO_NUMBER(SUBSTR(MTL.CHILD_RECORD_KEY,9)) AUTHAUTOID,
                    TO_CHAR(MTL.MAKER_DT,'DD/MM/YYYY') EDITDATE,
                    MTL.OLDLINKAUTH, MTL.NEWLINKAUTH, 2 ODRNUM, MTL.MAKER_DT CHANGEDATE, MTL.ACTION_FLAG
                FROM
                    (SELECT MTL.MAKER_DT, MTM.RECORD_KEY, MTL.CHILD_RECORD_KEY, 'EDIT' ACTION_FLAG,
                        MAX(CASE WHEN MTL.MOD_NUM = MTM.MINNUM THEN MTL.FROM_VALUE ELSE '' END) OLDLINKAUTH,
                        MAX(CASE WHEN MTL.MOD_NUM = MTM.MAXNUM THEN MTL.TO_VALUE ELSE '' END) NEWLINKAUTH, MAX(MTL.MOD_NUM) MOD_NUM
                    FROM MAINTAIN_LOG MTL,
                        (SELECT MTL.RECORD_KEY, MTL.CHILD_RECORD_KEY, MTL.MAKER_DT,
                            MAX(MTL.MOD_NUM) MAXNUM,  MIN(MTL.MOD_NUM) MINNUM
                        FROM maintain_log MTL
                        WHERE MTL.TABLE_NAME = 'AFMAST' AND MTL.CHILD_TABLE_NAME = 'CFAUTH'
                            AND MTL.ACTION_FLAG = 'EDIT'
                            AND MTL.COLUMN_NAME = 'LINKAUTH'
                        GROUP BY MTL.RECORD_KEY, MTL.CHILD_RECORD_KEY, MTL.MAKER_DT
                        ) MTM
                    WHERE MTL.TABLE_NAME = 'AFMAST' AND MTL.CHILD_TABLE_NAME = 'CFAUTH'
                        AND MTL.ACTION_FLAG = 'EDIT'
                        AND MTL.COLUMN_NAME = 'LINKAUTH'
                        AND MTL.record_key = MTM.RECORD_KEY AND MTL.CHILD_RECORD_KEY = MTM.CHILD_RECORD_KEY AND MTL.MAKER_DT = MTM.MAKER_DT
                        AND MTL.MAKER_DT >= TO_DATE(F_DATE,'DD/MM/YYYY')
                        AND MTL.MAKER_DT <= TO_DATE(T_DATE,'DD/MM/YYYY')
                    GROUP BY MTL.maker_dt, MTM.RECORD_KEY, MTL.CHILD_RECORD_KEY
                    ) MTL
        ) AE
        ON AF.AFACCTNO = AE.AFACCTNO AND AF.AUTOID = AE.AUTHAUTOID AND AF.CHANGEDATE = AE.CHANGEDATE AND AF.ACTION_FLAG = AE.ACTION_FLAG
        LEFT JOIN
        (
            SELECT CFA.ACCTNO AFACCTNO, CFA.AUTOID AUTHAUTOID,
                    MTL.OLDLICENSE, MTL.NEWLICENSE, MTL.MAKER_DT CHANGEDATE, MTL.ACTION_FLAG
                FROM CFAUTH CFA,
                    (SELECT MTL.MAKER_DT, MTM.RECORD_KEY, 'EDIT' ACTION_FLAG,
                        MAX(CASE WHEN MTL.MOD_NUM = MTM.MINNUM THEN MTL.FROM_VALUE ELSE '' END) OLDLICENSE,
                        MAX(CASE WHEN MTL.MOD_NUM = MTM.MAXNUM THEN MTL.TO_VALUE ELSE '' END) NEWLICENSE, MAX(MTL.MOD_NUM) MOD_NUM
                    FROM MAINTAIN_LOG MTL,
                        (SELECT MTL.RECORD_KEY, MTL.CHILD_RECORD_KEY, MTL.MAKER_DT,
                            MAX(MTL.MOD_NUM) MAXNUM,  MIN(MTL.MOD_NUM) MINNUM
                        FROM maintain_log MTL
                        WHERE MTL.TABLE_NAME = 'CFMAST'
                            AND MTL.ACTION_FLAG = 'EDIT'
                            AND MTL.COLUMN_NAME = 'IDCODE'
                        GROUP BY MTL.RECORD_KEY, MTL.CHILD_RECORD_KEY, MTL.MAKER_DT
                        ) MTM
                    WHERE MTL.TABLE_NAME = 'CFMAST'
                        AND MTL.ACTION_FLAG = 'EDIT'
                        AND MTL.COLUMN_NAME = 'IDCODE'
                        AND MTL.record_key = MTM.RECORD_KEY AND MTL.MAKER_DT = MTM.MAKER_DT
                        AND MTL.MAKER_DT >= TO_DATE(F_DATE,'DD/MM/YYYY')
                        AND MTL.MAKER_DT <= TO_DATE(T_DATE,'DD/MM/YYYY')
                    GROUP BY MTL.maker_dt, MTM.RECORD_KEY
                    ) MTL
                WHERE CFA.CUSTID = SUBSTR(MTL.RECORD_KEY,11,10)
        ) CE
        ON AF.AFACCTNO = CE.AFACCTNO AND AF.AUTOID = CE.AUTHAUTOID AND AF.CHANGEDATE = CE.CHANGEDATE AND AF.ACTION_FLAG = CE.ACTION_FLAG

    ) A
    ORDER BY A.CUSTODYCD, A.AFACCTNO, A.AUTOID, A.CHANGEDATE, A.ODRNUM */--, A.MOD_NUM
    ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;


-- End of DDL Script for Procedure HOST.CF0031
/

