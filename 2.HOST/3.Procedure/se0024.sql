CREATE OR REPLACE PROCEDURE se0024(
   PV_REFCURSOR     IN OUT   PKG_REPORT.REF_CURSOR,
   OPT              IN       VARCHAR2,
   BRID             IN       VARCHAR2,
   TYPEDATE         IN       VARCHAR2,
   F_DATE           IN       VARCHAR2,
   T_DATE           IN       VARCHAR2,
   CUSTODYCD        IN       VARCHAR2,
   AFACCTNO         IN       VARCHAR2,
   TLTXCD           IN       VARCHAR2,
   SYMBOL           IN       VARCHAR2,
   AFTYPE           IN       VARCHAR2,
   BAL_TYPE           IN       VARCHAR2
        )
   IS
--
-- To modify this template, edit file PROC.TXT in TEMPLATE
-- directory of SQL Navigator
-- BAO CAO DANH SACH GIAO DICH LUU KY
-- Purpose: Briefly explain the functionality of the procedure
-- DANH SACH GIAO DICH LUU KY
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- DUNGNH   14-SEP-09  MODIFIED
-- ---------   ------  -------------------------------------------

    V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0
    V_STRTLTXCD         VARCHAR (900);
    V_STRTLTXCD_1      VARCHAR (900);
    V_STRTLTXCD_2      VARCHAR (900);
    V_STRTLTXCD_3      VARCHAR (900);
    V_STRSYMBOL         VARCHAR (20);
    V_STRTYPEDATE       VARCHAR(5);
    V_STRCUSTODYCD          VARCHAR(20);
    V_STRAFACCTNO          VARCHAR(20);
    V_AFTYPE                VARCHAR(20);
    V_CMD           VARCHAR (2000);
    V_CMD_1           VARCHAR (2000);
    V_CMD_2           VARCHAR (2000);
    V_CMD_3           VARCHAR (2000);
    V_WHERE           VARCHAR (2000);
    V_WHERE_1           VARCHAR (2000);
    V_WHERE_2           VARCHAR (2000);
    V_WHERE_3           VARCHAR (2000);
   -- Declare program variables as shown above
BEGIN
    -- GET REPORT'S PARAMETERS
   V_STROPTION := upper(OPT);
    V_STRBRID := BRID;
    if(V_STROPTION = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPTION = 'B') then
            --select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
            V_STRBRID := substr(BRID,1,2) || '__' ;
        else
            V_STRBRID := BRID;
        end if;
    end if;

   IF(TYPEDATE <> 'ALL') THEN
        V_STRTYPEDATE := TYPEDATE;
   ELSE
        V_STRTYPEDATE := '003';
   END IF;

   V_CMD := 'SELECT TLG.busdate, TLG.custodycd, SUBSTR(TLG.acctno, 1, 10) acctno, TLG.symbol, TLG.txdesc,
            DECODE(TLG.field, ''STANDING'', DECODE(TLG.txtype, ''D'', TLG.NAMT, 0), DECODE(TLG.txtype, ''C'', TLG.NAMT, 0)) PS_TANG,
            DECODE(TLG.field, ''STANDING'', DECODE(TLG.txtype, ''C'', TLG.NAMT, 0), DECODE(TLG.txtype, ''D'', TLG.NAMT, 0)) PS_GIAM,
            (CASE WHEN TLG.tltxcd = ''2248'' AND TLG.ref = ''002'' AND TLG.field = ''BLOCKED'' THEN ''HCCN''
                WHEN TLG.tltxcd = ''2248'' AND TLG.ref <> ''002'' AND TLG.field = ''BLOCKED'' THEN ''TDCN''
                WHEN TLG.tltxcd = ''2266'' AND TLG.ref = ''002'' AND TLG.field = ''WITHDRAW'' THEN ''HCCN''
                WHEN TLG.field = ''BLOCKED'' THEN ''HCCN''
                ELSE ''TDCN''
             END) field,
            TLG.tltxcd, SB.parvalue
        FROM vw_setran_gen TLG
        LEFT OUTER JOIN sbsecurities SB ON Sb.codeid = TLG.codeid';
   V_CMD_1 := 'SELECT TLG.busdate, TLG.custodycd, SUBSTR(TLG.acctno, 1, 10) acctno, TLG.symbol, TLG.txdesc,
            DECODE(TLG.field, ''STANDING'', DECODE(TLG.txtype, ''D'', TLG.NAMT, 0), DECODE(TLG.txtype, ''C'', TLG.NAMT, 0)) PS_TANG,
            DECODE(TLG.field, ''STANDING'', DECODE(TLG.txtype, ''C'', TLG.NAMT, 0), DECODE(TLG.txtype, ''D'', TLG.NAMT, 0)) PS_GIAM,
            (CASE WHEN TLG.field = ''BLOCKED'' THEN ''HCCN''
                ELSE ''TDCN''
             END) field,
            TLG.tltxcd, SB.parvalue
        FROM vw_setran_gen TLG
        LEFT OUTER JOIN sbsecurities SB ON Sb.codeid = TLG.codeid';
   V_CMD_2 := 'SELECT TLG.busdate, TLG.custodycd, SUBSTR(TLG.acctno, 1, 10) acctno, TLG.symbol, TLG.txdesc,
            DECODE(TLG.field, ''STANDING'', DECODE(TLG.txtype, ''D'', TLG.NAMT, 0), DECODE(TLG.txtype, ''C'', TLG.NAMT, 0)) PS_TANG,
            DECODE(TLG.field, ''STANDING'', DECODE(TLG.txtype, ''C'', TLG.NAMT, 0), DECODE(TLG.txtype, ''D'', TLG.NAMT, 0)) PS_GIAM,
            (CASE WHEN TLG.field = ''STANDING'' THEN ''CC''
                ELSE ''TDCN''
             END) field,
            TLG.tltxcd, SB.parvalue
        FROM vw_setran_gen TLG
        LEFT OUTER JOIN sbsecurities SB ON Sb.codeid = TLG.codeid';
   V_CMD_3 := 'SELECT TLG.busdate, TLG.custodycd, SUBSTR(TLG.acctno, 1, 10) acctno, TLG.symbol, TLG.txdesc,
            DECODE(TLG.field, ''STANDING'', DECODE(TLG.txtype, ''D'', TLG.NAMT, 0), DECODE(TLG.txtype, ''C'', TLG.NAMT, 0)) PS_TANG,
            DECODE(TLG.field, ''STANDING'', DECODE(TLG.txtype, ''C'', TLG.NAMT, 0), DECODE(TLG.txtype, ''D'', TLG.NAMT, 0)) PS_GIAM,
            (CASE WHEN TLG.field = ''BLOCKED'' THEN ''CC''
                ELSE ''TDCN''
             END) field,
            TLG.tltxcd, SB.parvalue
        FROM vw_setran_gen TLG
        LEFT OUTER JOIN sbsecurities SB ON Sb.codeid = TLG.codeid';
   V_WHERE := ' where case when TLG.txnum like ''68%'' and TLG.tltxcd = ''2242'' then 0 else 1 end = 1
            AND TLG.busdate >= TO_DATE (''' || F_DATE || '''  ,''DD/MM/YYYY'')
            AND TLG.busdate <= TO_DATE (''' || T_DATE  || ''',''DD/MM/YYYY'')
            AND substr(TLG.acctno,1, 4) LIKE ''' || V_STRBRID || '''';

   IF(CUSTODYCD <> 'ALL') THEN
        V_WHERE := V_WHERE || ' AND TLG.CUSTODYCD = ''' || CUSTODYCD || '''' ;
   END IF;

   IF(AFACCTNO <> 'ALL') THEN
        V_WHERE := V_WHERE || ' AND TLG.AFACCTNO = ''' || AFACCTNO || '''' ;
   END IF;

   IF  (SYMBOL <> 'ALL') THEN
      V_WHERE := V_WHERE || ' AND TLG.SYMBOL = ''' || replace (trim(SYMBOL),' ','_') || '''' ;
   END IF;

   IF(AFTYPE <> 'ALL') THEN
        V_AFTYPE  := AFTYPE;
   ELSE
        V_AFTYPE  := 'C F P';
   END IF;

   V_WHERE := V_WHERE || ' AND INSTR(''' || V_AFTYPE || '''' || ', substr(TLG.custodycd, 4, 1)) > 0' ;
   V_WHERE_1 := V_WHERE;
   V_WHERE_2 := V_WHERE;
   V_WHERE_3 := V_WHERE;

   V_WHERE := V_WHERE || ' AND TLG.FIELD IN(''TRADE'',''MORTAGE'',''BLOCKED'',''NETTING'',''STANDING'',''WITHDRAW'',''DTOCLOSE'',''RECEIVING'')' ;
   V_WHERE_1 := V_WHERE;
   V_WHERE_2 := V_WHERE_2 || ' AND TLG.FIELD IN(''BLOCKED'',''STANDING'')' ;
   V_WHERE_3 := V_WHERE_3 || ' AND TLG.FIELD IN(''BLOCKED'',''TRADE'')' ;

   IF BAL_TYPE = 'ALL' THEN
       IF (TLTXCD <> 'ALL') THEN
            if instr('2246 2245 2266 3351 2248 8879 2201 2242 2263 3329 3356 3340', tltxcd) > 0 then -- bo 8868,8866 them 2242, 2263, 3329, 3356, 3340
               V_WHERE := V_WHERE || ' AND TLG.TLTXCD = ''' || TLTXCD || '''' ;
               OPEN PV_REFCURSOR FOR 'SELECT B.* FROM ( ' || V_CMD || V_WHERE || ') B ORDER BY busdate';
            elsif instr('2202 2203',tltxcd ) >0 then
               V_WHERE_1 := V_WHERE_1 || ' AND TLG.TLTXCD = ''' || TLTXCD || '''' ;
               V_WHERE_1 := V_WHERE_1 || ' AND TLG.REF in (''002'',''007'')';
               OPEN PV_REFCURSOR FOR 'SELECT B.* FROM ( ' || V_CMD_1 || V_WHERE_1 || ') B ORDER BY busdate';
            elsif instr('2251',tltxcd ) >0 then
               V_WHERE_2 := V_WHERE_2 || ' AND TLG.TLTXCD = ''' || TLTXCD || '''' ;
               OPEN PV_REFCURSOR FOR 'SELECT B.* FROM ( ' || V_CMD_2 || V_WHERE_2 || ') B ORDER BY busdate';
            elsif instr('2253',tltxcd ) >0 then
               V_WHERE_3 := V_WHERE_3 || ' AND TLG.TLTXCD = ''' || TLTXCD || '''' ;
               OPEN PV_REFCURSOR FOR 'SELECT B.* FROM ( ' || V_CMD_3 || V_WHERE_3 || ') B ORDER BY busdate';
            end if;
       ELSE
            V_STRTLTXCD := '2246 2245 2266 3351 2248 8879 2201 2242 2263 3329 3356 3340'; -- bo 8868,8866 them 2242, 2263, 3329 3356, 3340
            V_STRTLTXCD_1:= '2202 2203';
            V_STRTLTXCD_2:= '2251';
            V_STRTLTXCD_3:= '2253';

           V_WHERE := V_WHERE || ' AND INSTR(''' || V_STRTLTXCD || '''' || ', TLG.TLTXCD) > 0' ;
           V_WHERE_1 := V_WHERE_1 || ' AND INSTR(''' || V_STRTLTXCD_1 || '''' || ', TLG.TLTXCD) > 0' || ' AND TLG.REF in (''002'',''007'')';
           V_WHERE_2 := V_WHERE_2 || ' AND INSTR(''' || V_STRTLTXCD_2 || '''' || ', TLG.TLTXCD) > 0' ;
           V_WHERE_3 := V_WHERE_3 || ' AND INSTR(''' || V_STRTLTXCD_3 || '''' || ', TLG.TLTXCD) > 0' ;

           OPEN PV_REFCURSOR FOR 'SELECT B.* FROM ( ' || V_CMD || V_WHERE
                || ' UNION ALL ' || V_CMD_1 || V_WHERE_1
                || ' UNION ALL ' || V_CMD_2 || V_WHERE_2
                || ' UNION ALL ' || V_CMD_3 || V_WHERE_3 || ') B ORDER BY busdate';
       END IF;
   ELSE
       IF (TLTXCD <> 'ALL')
       THEN
            if instr('2246 2245 2266 3351 2248 8879 2201 2242 2263 3329 3356 3340', tltxcd) > 0 then -- bo 8868,8866 them 2242, 2263, 3329 3356 3340
               V_WHERE := V_WHERE || ' AND TLG.TLTXCD = ''' || TLTXCD || '''' ;
               OPEN PV_REFCURSOR FOR 'SELECT C.* FROM (SELECT B.* FROM ( ' || V_CMD || V_WHERE || ') B ) C
                    WHERE field = ''' || BAL_TYPE || ''' ORDER BY busdate';
            elsif instr('2202 2203',tltxcd ) >0 then
               V_WHERE_1 := V_WHERE_1 || ' AND TLG.TLTXCD = ''' || TLTXCD || '''' ;
               V_WHERE_1 := V_WHERE_1 || ' AND TLG.REF in (''002'',''007'')';
               OPEN PV_REFCURSOR FOR 'SELECT C.* FROM (SELECT B.* FROM ( ' || V_CMD_1 || V_WHERE_1 || ') B ) C
                    WHERE field = ''' || BAL_TYPE || ''' ORDER BY busdate';
            elsif instr('2251',tltxcd ) >0 then
               V_WHERE_2 := V_WHERE_2 || ' AND TLG.TLTXCD = ''' || TLTXCD || '''' ;
               OPEN PV_REFCURSOR FOR 'SELECT C.* FROM (SELECT B.* FROM ( ' || V_CMD_2 || V_WHERE_2 || ') B ) C
                    WHERE field = ''' || BAL_TYPE || ''' ORDER BY busdate';
            elsif instr('2253',tltxcd ) >0 then
               V_WHERE_3 := V_WHERE_3 || ' AND TLG.TLTXCD = ''' || TLTXCD || '''' ;
               OPEN PV_REFCURSOR FOR 'SELECT C.* FROM (SELECT B.* FROM ( ' || V_CMD_3 || V_WHERE_3 || ') B ) C
                    WHERE field = ''' || BAL_TYPE || ''' ORDER BY busdate';
            end if;
       ELSE
            V_STRTLTXCD := '2246 2245 2266 3351 2248 8879 2201 2242 2263 3329 3356 3340'; -- bo 8868,8866 them 2242, 2263, 3329 3356 3340
            V_STRTLTXCD_1:= '2202 2203';
            V_STRTLTXCD_2:= '2251';
            V_STRTLTXCD_3:= '2253';

           V_WHERE := V_WHERE || ' AND INSTR(''' || V_STRTLTXCD || '''' || ', TLG.TLTXCD) > 0' ;
           V_WHERE_1 := V_WHERE_1 || ' AND INSTR(''' || V_STRTLTXCD_1 || '''' || ', TLG.TLTXCD) > 0' || ' AND TLG.REF in (''002'',''007'')';
           V_WHERE_2 := V_WHERE_2 || ' AND INSTR(''' || V_STRTLTXCD_2 || '''' || ', TLG.TLTXCD) > 0' ;
           V_WHERE_3 := V_WHERE_3 || ' AND INSTR(''' || V_STRTLTXCD_3 || '''' || ', TLG.TLTXCD) > 0' ;

           OPEN PV_REFCURSOR FOR 'SELECT C.* FROM (SELECT B.* FROM ( ' || V_CMD || V_WHERE
                || ' UNION ALL ' || V_CMD_1 || V_WHERE_1
                || ' UNION ALL ' || V_CMD_2 || V_WHERE_2
                || ' UNION ALL ' || V_CMD_3 || V_WHERE_3 || ') B ) C
                    WHERE field = ''' || BAL_TYPE || ''' ORDER BY busdate';
       END IF;
   END IF;
EXCEPTION
    WHEN OTHERS
   THEN
      RETURN;
END; -- Procedure
/

