CREATE OR REPLACE PROCEDURE sa0003 (
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
                SELECT MAX(au.cmdcode || ': ' || TO_CHAR(ME.CMDNAME))TXNAME,
                    MAX(DECODE(AU.CMDALLOW,'Y','X','')) C1,
                    MAX(DECODE(CASE WHEN ME.MENUTYPE IN ('A','P') THEN '' ELSE SUBSTR(AU.STRAUTH,1,1) END,'Y','X','')) C2,
                    MAX(DECODE(CASE WHEN ME.MENUTYPE IN ('A','P') THEN '' ELSE SUBSTR(AU.STRAUTH,2,1) END,'Y','X','')) C3,
                    MAX(DECODE(CASE WHEN ME.MENUTYPE IN ('A','P') THEN '' ELSE SUBSTR(AU.STRAUTH,3,1) END,'Y','X','')) C4,
                    MAX(DECODE(CASE WHEN ME.MENUTYPE IN ('A','P') THEN '' ELSE SUBSTR(AU.STRAUTH,4,1) END,'Y','X','')) C5,
                    MAX(DECODE(CASE WHEN ME.MENUTYPE IN ('A','P') THEN '' ELSE SUBSTR(AU.STRAUTH,5,1) END,'Y','X','')) C6, 'M' C7
                FROM CMDMENU ME, CMDAUTH AU
                WHERE ME.CMDID = AU.CMDCODE
                    AND AU.CMDTYPE ='M' AND ME.MENUTYPE not in ('T','R')
                    AND AU.AUTHTYPE ='G'
                    AND AU.AUTHID = V_STRAUTHID
                    AND (AU.STRAUTH<>'NNNN' OR AU.CMDALLOW<>'N')
                    and ME.LEV >= 0
                GROUP BY AU.CMDCODE
                UNION ALL
                -- QUYEN GIAO DICH
                SELECT TO_CHAR(TA.TLTXCD)||'-'||TO_CHAR(TX.TXDESC) TXNAME,
                    MAX(DECODE(TA.TLTYPE,'T',to_char(TA.TLLIMIT/1000000),'')) C1,
                    MAX(DECODE(TA.TLTYPE,'C',to_char(TA.TLLIMIT/1000000),'')) C2,
                    MAX(DECODE(TA.TLTYPE,'A',to_char(TA.TLLIMIT/1000000),'')) C3,
                    MAX(DECODE(TA.TLTYPE,'R',to_char(TA.TLLIMIT/1000000),'')) C4,'' C5,
                    '' C6, 'T' C7
                FROM TLAUTH TA ,TLTX TX
                WHERE  TA.TLTXCD =TX.TLTXCD
                    AND TA.AUTHID = V_STRAUTHID
                    AND TA.AUTHTYPE='G'
                GROUP BY TA.TLTXCD,TX.TXDESC
                UNION ALL
                -- QUYEN BAO CAO
                SELECT TO_CHAR(RPT.RPTID)||'-'||TO_CHAR(RPT.DESCRIPTION) TXNAME,
                    MAX(DECODE(SUBSTR(AU.STRAUTH,2,1),'Y','X','')) C1,
                    MAX(DECODE(AU.CMDALLOW,'Y','X','')) C2,
                    MAX(DECODE(SUBSTR(AU.STRAUTH,1,1),'Y','X','')) C3,
                    --MAX(SUBSTR(AU.STRAUTH,3,1)) C4,
                    max(a1.cdcontent) c4,
                    '' C5,'' C6, 'R' c7
                FROM RPTMASTER RPT ,CMDAUTH AU, ALLCODE A1
                WHERE RPT.RPTID  = AU.CMDCODE
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
                SELECT A.TXNAME, NVL(B.C1,'') C1, NVL(B.C2,'') C2, NVL(B.C3,'') C3,
                    NVL(B.C4,'') C4, '' C5, '' C6, 'S' C7
                FROM
                    (   -- DANH SACH TRA CUU TONG HOP
                        SELECT AU.CMDCODE, max(nvl(sr.tltxcd,'')) tltxcd, MAX(RPT.RPTID ||'-'|| CASE WHEN SR.TLTXCD IS NULL THEN 'VIEW' ELSE SR.TLTXCD END ||': '|| RPT.DESCRIPTION) TXNAME
                        FROM RPTMASTER RPT ,CMDAUTH AU, search sr
                        WHERE RPT.RPTID = AU.CMDCODE AND SR.SEARCHCODE = RPT.RPTID
                            AND RPT.CMDTYPE in ('V','D','L') AND rpt.visible = 'Y'
                            AND au.cmdtype = 'G'
                            AND AU.AUTHID = V_STRAUTHID
                            AND AU.AUTHTYPE='G'
                        GROUP BY AU.CMDCODE
                   ) A
                    LEFT JOIN
                    (   -- QUYEN GIAO DICH TUONG UNG
                        SELECT TA.TLTXCD CMDCODE, MAX(TO_CHAR(TA.TLTXCD)||': ' ||TO_CHAR(TX.TXDESC)) TXNAME,
                            MAX(DECODE(TA.TLTYPE,'T',to_char(round(TA.TLLIMIT/1000000,2)),'')) C1,
                            MAX(DECODE(TA.TLTYPE,'C',to_char(round(TA.TLLIMIT/1000000,2)),'')) C2,
                            MAX(DECODE(TA.TLTYPE,'A',to_char(round(TA.TLLIMIT/1000000,2)),'')) C3,
                            MAX(DECODE(TA.TLTYPE,'R',to_char(round(TA.TLLIMIT/1000000,2)),'')) C4,
                            '' C5,'' C6, 'T' C7, 'U' ATYPE
                        FROM TLAUTH TA ,TLTX TX
                        WHERE  TA.TLTXCD =TX.TLTXCD
                            AND TA.AUTHID = V_STRAUTHID
                            AND TA.AUTHTYPE='G'
                            AND EXISTS (
                                         SELECT SR.searchcode, SR.tltxcd
                                         FROM SEARCH SR, RPTMASTER RPT, TLTX TL
                                         WHERE SR.searchcode = RPT.rptid AND RPT.visible = 'Y' AND SR.tltxcd IS NOT NULL
                                            AND SR.TLTXCD = TL.TLTXCD AND TL.DIRECT = 'N' AND TX.tltxcd = SR.tltxcd
                                        )
                        GROUP BY TA.TLTXCD

                    ) B
                    ON A.TLTXCD = B.CMDCODE
                UNION ALL
                -- QUYEN LOAI HINH TIEU KHOAN
                SELECT MAX(TO_CHAR(GA.AFTYPE)||': '||TO_CHAR(AFT.TYPENAME)) TXNAME,
                    '' C1, '' C2, '' C3, '' C4 ,'' C5,'' C6, 'W' C7
                FROM TLGRPAFTYPE GA, TLGROUPS TLG, AFTYPE AFT
                WHERE TLG.GRPID = GA.GRPID AND GA.AFTYPE = AFT.ACTYPE
                    AND TLG.ACTIVE = 'Y'
                    AND tlg.grpid = V_STRAUTHID
                GROUP BY GA.AFTYPE
            ) DT
        order by DT.C7, DT.TXNAME
    ;

    EXCEPTION
    WHEN OTHERS THEN
        RETURN;
    END;                                                              -- PROCEDURE
/

