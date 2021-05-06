CREATE OR REPLACE PROCEDURE sa0006 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   AUTHID         IN       VARCHAR2
   )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- THENN   12-Oct-12  CREATED
-- ---------   ------  -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (4);              -- USED WHEN V_NUMOPTION > 0
   V_STRAUTHID         VARCHAR2 (6);
   V_STRGRPID              VARCHAR2 (6);
   V_STRGRPNAME            VARCHAR2 (500);
   V_STRACTIVE             VARCHAR2 (6);
   V_STRDESCRIPTION        VARCHAR2 (500);
   V_STRCOU                VARCHAR2 (6);
   V_STRGRPTYPE            VARCHAR2 (50);


BEGIN

   V_STROPTION := OPT;


   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   -- GET REPORT'S PARAMETERS

      V_STRAUTHID:= AUTHID;

   -- END OF GETTING REPORT'S PARAMETERS
    SELECT TLGR.GRPID, TLGR.GRPNAME, TLGR.ACTIVE, TLGR.DESCRIPTION, COU.COU, AL.CDCONTENT
    INTO V_STRGRPID,V_STRGRPNAME,V_STRACTIVE,V_STRDESCRIPTION ,V_STRCOU,V_STRGRPTYPE
    FROM TLGROUPS TLGR,(SELECT COUNT(ROWNUM) COU FROM TLGRPUSERS WHERE  GRPID LIKE V_STRAUTHID )COU,ALLCODE AL
    WHERE AL.CDNAME='GRPTYPE' AND  AL.CDTYPE='SA' AND  AL.CDVAL =TLGR.GRPTYPE
        AND TLGR.GRPID = V_STRAUTHID;

    OPEN PV_REFCURSOR
    FOR
        SELECT V_STRGRPID GRPID,V_STRGRPNAME GRPNAME,V_STRACTIVE ACTIVE,V_STRDESCRIPTION DESCRIPTION,
            V_STRCOU COUNT,V_STRGRPTYPE TYPEGROUP,DT.*
        FROM
            (
                -- QUYEN CHUC NANG
                SELECT max(me.modcode) modcode, au.cmdcode cmdcode, max(me.lev) lev,
                    max(CASE WHEN instr(me.objname,'GENERALVIEW') > 0 THEN 'G' else me.menutype end) menutype,
                    MAX(au.cmdcode || ': ' || TO_CHAR(ME.CMDNAME))TXNAME,
                    MAX(DECODE(AU.CMDALLOW,'Y','X','')) C1,
                    MAX(DECODE(CASE WHEN ME.MENUTYPE IN ('A','P') OR SUBSTR(ME.AUTHCODE,2,1) = 'N' THEN '-' ELSE SUBSTR(AU.STRAUTH,1,1) END,'Y','X','-','-','')) C2,
                    MAX(DECODE(CASE WHEN ME.MENUTYPE IN ('A','P') OR SUBSTR(ME.AUTHCODE,1,1) = 'N' THEN '-' ELSE SUBSTR(AU.STRAUTH,2,1) END,'Y','X','-','-','')) C3,
                    MAX(DECODE(CASE WHEN ME.MENUTYPE IN ('A','P') OR SUBSTR(ME.AUTHCODE,3,1) = 'N' THEN '-' ELSE SUBSTR(AU.STRAUTH,3,1) END,'Y','X','-','-','')) C4,
                    MAX(DECODE(CASE WHEN ME.MENUTYPE IN ('A','P') OR SUBSTR(ME.AUTHCODE,4,1) = 'N' THEN '-' ELSE SUBSTR(AU.STRAUTH,4,1) END,'Y','X','-','-','')) C5,
                    MAX(DECODE(CASE WHEN ME.MENUTYPE IN ('A','P') OR SUBSTR(ME.AUTHCODE,11,1) = 'N' THEN '-' ELSE SUBSTR(AU.STRAUTH,5,1) END,'Y','X','-','-','')) C6,
                    'M' C7, 1 odrnum, max(SUBSTR(me.CMDID, 1,4)) cmdid,
                    max(CASE WHEN me.menutype = 'T' THEN '2' WHEN me.menutype = 'R' THEN '3'
                            WHEN me.menutype = 'A' AND instr(me.objname,'GENERALVIEW') > 0  THEN '4' ELSE '1' END) CMDTYPE
                FROM CMDMENU ME, CMDAUTH AU
                WHERE ME.CMDID = AU.CMDCODE AND to_number(me.lev) >=0
                    AND AU.CMDTYPE ='M' --AND ME.MENUTYPE not in ('T','R')
                    AND AU.AUTHTYPE ='G'
                    AND AU.AUTHID = V_STRAUTHID
                    AND (AU.STRAUTH<>'NNNN' OR AU.CMDALLOW<>'N')
                    and ME.LEV >= 0
                GROUP BY AU.CMDCODE
                UNION ALL
                -- QUYEN GIAO DICH
                SELECT max(am.modcode) modcode, max(me.cmdid) cmdcode, 4 lev, 'T' menutype,
                    TO_CHAR(TA.TLTXCD)||'-'||TO_CHAR(TX.TXDESC) TXNAME,
                    MAX(CASE WHEN substr(tlg.grpright,2,1) = 'Y' THEN DECODE(TA.TLTYPE,'T',to_char(TA.TLLIMIT/1000000),'0') ELSE '' END) C1,
                    MAX(CASE WHEN substr(tlg.grpright,3,1) = 'Y' AND tx.txtype = 'W' THEN DECODE(TA.TLTYPE,'C',to_char(TA.TLLIMIT/1000000),'0') ELSE '' END) C2,
                    MAX(CASE WHEN substr(tlg.grpright,5,1) = 'Y' THEN DECODE(TA.TLTYPE,'A',to_char(TA.TLLIMIT/1000000),'0') ELSE '' END) C3,
                    MAX(CASE WHEN substr(tlg.grpright,4,1) = 'Y' THEN DECODE(TA.TLTYPE,'R',to_char(TA.TLLIMIT/1000000),'0') ELSE '' END) C4,
                    '' C5, '' C6, 'T' C7, 2 odrnum, max(SUBSTR(me.CMDID, 1,4)) cmdid, '2' cmdtype
                FROM TLAUTH TA ,TLTX TX, appmodules am, tlgroups tlg,
                    (SELECT me.cmdid, me.modcode FROM cmdmenu me WHERE me.menutype = 'T' AND to_number(me.lev) >= 0) me
                WHERE  TA.TLTXCD =TX.TLTXCD
                    AND am.txcode = substr(tx.tltxcd,1,2) AND tx.visible = 'Y'
                    AND am.modcode = me.modcode
                    AND ta.AUTHID = tlg.grpid
                    AND NOT EXISTS (
                        SELECT SR.searchcode, SR.tltxcd
                        FROM SEARCH SR, RPTMASTER RPT, TLTX TL
                        WHERE SR.searchcode = RPT.rptid AND RPT.visible = 'Y' AND SR.tltxcd IS NOT NULL AND SR.TLTXCD = TL.TLTXCD AND TL.DIRECT = 'N'
                            AND NOT EXISTS(SELECT TLTXCD FROM CMDMENU CM WHERE CM.tltxcd IS NOT NULL AND INSTR(CM.tltxcd, TL.tltxcd) > 0)
                            AND tx.tltxcd = SR.tltxcd)
                    AND (tx.DIRECT = 'Y' OR EXISTS(SELECT TLTXCD FROM CMDMENU CM WHERE CM.tltxcd IS NOT NULL AND INSTR(CM.tltxcd, tx.tltxcd) > 0))
                    AND TA.AUTHID = V_STRAUTHID
                    AND TA.AUTHTYPE='G'
                GROUP BY TA.TLTXCD,TX.TXDESC
                UNION ALL
                -- QUYEN BAO CAO
                SELECT max(am.modcode) modcode, max(me.cmdid) cmdcode, 4 lev, 'R' menutype,
                    TO_CHAR(RPT.RPTID)||'-'||TO_CHAR(RPT.DESCRIPTION) TXNAME,
                    MAX(DECODE(SUBSTR(AU.STRAUTH,2,1),'Y','X','')) C1,
                    MAX(DECODE(AU.CMDALLOW,'Y','X','')) C2,
                    MAX(DECODE(SUBSTR(AU.STRAUTH,1,1),'Y','X','')) C3,
                    --MAX(SUBSTR(AU.STRAUTH,3,1)) C4,
                    max(a1.cdcontent) c4,
                    '' C5,'' C6, 'R' c7, 2 odrnum, max(SUBSTR(me.CMDID, 1,4)) cmdid, '3' cmdtype
                FROM RPTMASTER RPT ,CMDAUTH AU, ALLCODE A1,appmodules am,
                    (SELECT me.cmdid, me.modcode, me.cmdname FROM cmdmenu me WHERE me.menutype = 'R' AND to_number(me.lev) >= 0) me
                WHERE RPT.RPTID  = AU.CMDCODE
                    AND am.modcode = rpt.modcode
                    AND am.modcode = me.modcode
                    AND AU.AUTHID LIKE V_STRAUTHID
                    AND RPT.CMDTYPE ='R'
                    AND (AU.STRAUTH<>'NN' OR AU.CMDALLOW<>'N')
                    AND AU.AUTHTYPE='G'
                    AND RPT.VISIBLE = 'Y'
                    AND A1.CDTYPE = 'SY' AND A1.CDNAME = 'AREA' AND A1.CDVAL = SUBSTR(AU.STRAUTH,3,1)
                GROUP BY RPT.RPTID,RPT.DESCRIPTION
                UNION ALL
                -- QUYEN TRA CUU TONG HOP
                -- QUYEN TRA CUU TONG HOP
                SELECT a.modcode, a.cmdcode, a.lev, a.menutype, A.TXNAME,
                    CASE WHEN a.tltxcd IS NOT NULL AND a.tltxcd <> 'EXEC' THEN NVL(B.C1,'0') ELSE NVL(B.C1,'X') END C1, NVL(B.C2,'') C2,
                    NVL(B.C3,'') C3, NVL(B.C4,'') C4, '' C5, '' C6, 'S' C7, 2 odrnum, a.cmdid, '4' cmdtype
                FROM
                    (   -- DANH SACH TRA CUU TONG HOP
                        SELECT max(am.modcode) modcode, max(me.cmdid) cmdcode, 4 lev, 'G' menutype,
                            max(nvl(sr.tltxcd,'')) tltxcd, MAX(RPT.RPTID ||'-'|| CASE WHEN SR.TLTXCD IS NULL THEN 'VIEW' ELSE SR.TLTXCD END ||': '|| RPT.DESCRIPTION) TXNAME,
                            max(SUBSTR(me.CMDID, 1,4)) cmdid
                        FROM RPTMASTER RPT ,CMDAUTH AU, search sr, appmodules am,
                            (SELECT me.cmdid, me.modcode, me.cmdname FROM cmdmenu me WHERE me.menutype = 'A' AND instr(me.objname,'GENERALVIEW') > 0 AND to_number(me.lev) >= 0) me
                        WHERE RPT.RPTID = AU.CMDCODE AND SR.SEARCHCODE = RPT.RPTID
                            AND am.modcode = rpt.modcode
                            AND am.modcode = me.modcode
                            AND RPT.CMDTYPE in ('V','D','L') AND rpt.visible = 'Y'
                            AND au.cmdtype = 'G'
                            AND AU.AUTHID = V_STRAUTHID
                            AND AU.AUTHTYPE='G'
                        GROUP BY AU.CMDCODE
                   ) A
                    LEFT JOIN
                    (   -- QUYEN GIAO DICH TUONG UNG
                        SELECT TA.TLTXCD CMDCODE, MAX(TO_CHAR(TA.TLTXCD)||': ' ||TO_CHAR(TX.TXDESC)) TXNAME,
                            MAX(CASE WHEN substr(tlg.grpright,2,1) = 'Y' THEN DECODE(TA.TLTYPE,'T',to_char(TA.TLLIMIT/1000000),'0') ELSE '' END) C1,
                            MAX(CASE WHEN substr(tlg.grpright,3,1) = 'Y' AND tx.txtype = 'W' THEN DECODE(TA.TLTYPE,'C',to_char(TA.TLLIMIT/1000000),'0') ELSE '' END) C2,
                            MAX(CASE WHEN substr(tlg.grpright,5,1) = 'Y' THEN DECODE(TA.TLTYPE,'A',to_char(TA.TLLIMIT/1000000),'0') ELSE '' END) C3,
                            MAX(CASE WHEN substr(tlg.grpright,4,1) = 'Y' THEN DECODE(TA.TLTYPE,'R',to_char(TA.TLLIMIT/1000000),'0') ELSE '' END) C4,
                            '' C5,'' C6, 'T' C7, 'U' ATYPE
                        FROM TLAUTH TA ,TLTX TX, tlgroups tlg
                        WHERE  TA.TLTXCD =TX.TLTXCD AND tx.visible = 'Y'
                            AND TA.AUTHID = V_STRAUTHID
                            AND TA.AUTHTYPE='G'
                            AND ta.AUTHID = tlg.grpid
                            AND EXISTS (
                                         SELECT SR.searchcode, SR.tltxcd
                                         FROM SEARCH SR, RPTMASTER RPT, TLTX TL
                                         WHERE SR.searchcode = RPT.rptid AND RPT.visible = 'Y' AND SR.tltxcd IS NOT NULL
                                            AND SR.TLTXCD = TL.TLTXCD /*AND TL.DIRECT = 'N'*/ AND TX.tltxcd = SR.tltxcd
                                        )
                        GROUP BY TA.TLTXCD

                    ) B
                    ON A.TLTXCD = B.CMDCODE
            ) DT
        order by dt.cmdid, dt.cmdtype, dt.cmdcode, dt.odrnum, dt.txname
    ;

    EXCEPTION
    WHEN OTHERS THEN
        RETURN;
    END;                                                              -- PROCEDURE
/

