CREATE OR REPLACE PROCEDURE sa0002 (
    PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
    OPT            IN       VARCHAR2,
    BRID           IN       VARCHAR2,
    AAUTHID        IN       VARCHAR2,
    AUTHTYPE       IN        VARCHAR2
   )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- THENN   12-OCT-12  CREATED
-- ---------   ------  -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (4);              -- USED WHEN V_NUMOPTION > 0
   V_STRAUTHID         VARCHAR2 (6);
   V_STRTLID                 VARCHAR2 (6);
   V_STRTLNAME               VARCHAR2 (30);
   V_STRTLFULLNAME           VARCHAR2 (50);
   V_STRTLLEV                VARCHAR2 (6);
   V_STRTLGROUP              VARCHAR2 (36);
   V_AUTHTYPE            VARCHAR2(1);
BEGIN

   V_STROPTION := OPT;


   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   -- GET REPORT'S PARAMETERS

    V_STRAUTHID:= AAUTHID;
    V_AUTHTYPE := AUTHTYPE;

   -- END OF GETTING REPORT'S PARAMETERS

    SELECT nvl(tl.tlid,''), nvl(tl.tlname,''), nvl(tl.tlfullname,''), nvl(tl.tllev,''), nvl(a.cdcontent,'')
    INTO V_STRTLID,V_STRTLNAME,V_STRTLFULLNAME,V_STRTLLEV,V_STRTLGROUP
    FROM tlprofiles tl, allcode a
    WHERE tl.tlid = V_STRAUTHID
        AND a.cdtype = 'SA' AND a.cdname = 'TLGROUP' AND a.cdval = tl.tlgroup;

    OPEN PV_REFCURSOR
    FOR
        SELECT V_STRTLID TLID,V_STRTLNAME TLNAME,V_STRTLFULLNAME FULLNAME,V_STRTLLEV LEV ,V_STRTLGROUP TLGROUP, DT.*
        FROM
            (
                -- QUYEN CHUC NANG
                SELECT a.cmdcode, a.txname,
                    DECODE(CASE WHEN a.uc1 IS NOT NULL THEN a.uc1 ELSE a.gc1 END,'Y','X','') c1,
                    DECODE(CASE WHEN a.uc2 IS NOT NULL THEN a.uc2 ELSE a.gc2 END,'Y','X','') c2,
                    DECODE(CASE WHEN a.uc3 IS NOT NULL THEN a.uc3 ELSE a.gc3 END,'Y','X','') c3,
                    DECODE(CASE WHEN a.uc4 IS NOT NULL THEN a.uc4 ELSE a.gc4 END,'Y','X','') c4,
                    DECODE(CASE WHEN a.uc5 IS NOT NULL THEN a.uc5 ELSE a.gc5 END,'Y','X','') c5,
                    DECODE(CASE WHEN a.uc6 IS NOT NULL THEN a.uc6 ELSE a.gc6 END,'Y','X','') C6,
                    A.C7 c7
                FROM
                    (
                        SELECT gr.cmdcode, max(gr.txname) txname,
                            max(CASE WHEN gr.atype = 'U' THEN gr.c1 ELSE '' END) UC1,
                            max(CASE WHEN gr.atype = 'U' THEN gr.c2 ELSE '' END) UC2,
                            max(CASE WHEN gr.atype = 'U' THEN gr.c3 ELSE '' END) UC3,
                            max(CASE WHEN gr.atype = 'U' THEN gr.c4 ELSE '' END) UC4,
                            max(CASE WHEN gr.atype = 'U' THEN gr.c5 ELSE '' END) UC5,
                            max(CASE WHEN gr.atype = 'U' THEN gr.c6 ELSE '' END) UC6,
                            max(CASE WHEN gr.atype = 'G' THEN gr.c1 ELSE '' END) GC1,
                            max(CASE WHEN gr.atype = 'G' THEN gr.c2 ELSE '' END) GC2,
                            max(CASE WHEN gr.atype = 'G' THEN gr.c3 ELSE '' END) GC3,
                            max(CASE WHEN gr.atype = 'G' THEN gr.c4 ELSE '' END) GC4,
                            max(CASE WHEN gr.atype = 'G' THEN gr.c5 ELSE '' END) GC5,
                            max(CASE WHEN gr.atype = 'G' THEN gr.c6 ELSE '' END) GC6, max(C7) C7
                        FROM
                            (
                                SELECT au.cmdcode, MAX(au.cmdcode || ': ' || TO_CHAR(ME.CMDNAME))TXNAME, MAX(AU.CMDALLOW) C1,
                                    MAX(CASE WHEN ME.MENUTYPE IN ('A','P') THEN '' ELSE SUBSTR(AU.STRAUTH,1,1) END) C2,
                                    MAX(CASE WHEN ME.MENUTYPE IN ('A','P') THEN '' ELSE SUBSTR(AU.STRAUTH,2,1) END) C3,
                                    MAX(CASE WHEN ME.MENUTYPE IN ('A','P') THEN '' ELSE SUBSTR(AU.STRAUTH,3,1) END) C4,
                                    MAX(CASE WHEN ME.MENUTYPE IN ('A','P') THEN '' ELSE SUBSTR(AU.STRAUTH,4,1) END) C5,
                                    MAX(CASE WHEN ME.MENUTYPE IN ('A','P') THEN '' ELSE SUBSTR(AU.STRAUTH,5,1) END) C6, 'M' C7, 'U' ATYPE
                                FROM CMDMENU ME,CMDAUTH AU
                                WHERE ME.CMDID = AU.CMDCODE
                                    AND AU.CMDTYPE ='M' AND ME.MENUTYPE IN ('M','O','A','P')
                                    AND AU.AUTHTYPE ='U'
                                    AND AU.AUTHID = V_STRAUTHID
                                    AND (AU.STRAUTH<>'NNNN' OR AU.CMDALLOW<>'N')
                                GROUP BY AU.CMDCODE
                                UNION ALL
                                -- quyen group
                                SELECT au.cmdcode, MAX(au.cmdcode || ': ' || TO_CHAR(ME.CMDNAME))TXNAME,  MAX(AU.CMDALLOW) C1,
                                    MAX(CASE WHEN ME.MENUTYPE IN ('A','P') THEN '' ELSE SUBSTR(AU.STRAUTH,1,1) END) C2,
                                    MAX(CASE WHEN ME.MENUTYPE IN ('A','P') THEN '' ELSE SUBSTR(AU.STRAUTH,2,1) END) C3,
                                    MAX(CASE WHEN ME.MENUTYPE IN ('A','P') THEN '' ELSE SUBSTR(AU.STRAUTH,3,1) END) C4,
                                    MAX(CASE WHEN ME.MENUTYPE IN ('A','P') THEN '' ELSE SUBSTR(AU.STRAUTH,4,1) END) C5,
                                    MAX(CASE WHEN ME.MENUTYPE IN ('A','P') THEN '' ELSE SUBSTR(AU.STRAUTH,5,1) END) C6, 'M' C7, 'G' ATYPE
                                FROM cmdmenu ME ,CMDAUTH AU
                                WHERE ME.CMDID = AU.CMDCODE
                                    AND AU.CMDTYPE ='M' AND ME.MENUTYPE IN ('M','O','A','P')
                                    AND AU.AUTHTYPE ='G'
                                    AND V_AUTHTYPE = 'G'
                                    AND EXISTS (SELECT tlg.grpid
                                                FROM tlgrpusers tlg, tlgroups tlr, tlprofiles tlp, brgrpparam br
                                                WHERE tlr.grpid = tlg.grpid AND tlp.tlid = tlg.tlid
                                                    AND br.brid = tlp.brid AND br.paratype = 'TLGROUPS' AND br.paravalue = tlr.grpid
                                                    AND br.deltd = 'N' AND tlr.active = 'Y'
                                                    AND tlg.grpid = au.AUTHID AND tlg.tlid = V_STRAUTHID
                                                )
                                GROUP BY au.cmdcode
                            ) gr
                        GROUP BY gr.cmdcode
                    ) a
                -- QUYEN BAO CAO
                UNION ALL
                SELECT a.cmdcode, a.txname,
                    DECODE(CASE WHEN a.uc1 IS NOT NULL THEN a.uc1 ELSE a.gc1 END,'Y','X','') c1,
                    DECODE(CASE WHEN a.uc2 IS NOT NULL THEN a.uc2 ELSE a.gc2 END,'Y','X','') c2,
                    DECODE(CASE WHEN a.uc3 IS NOT NULL THEN a.uc3 ELSE a.gc3 END,'Y','X','') c3,
                    --CASE WHEN a.uc4 IS NOT NULL THEN a.uc4 ELSE a.gc4 END c4,
                    A1.CDCONTENT C4,
                    DECODE(CASE WHEN a.uc5 IS NOT NULL THEN a.uc5 ELSE a.gc5 END,'Y','X','') c5,
                    A.C6, A.C7
                FROM
                    (
                        SELECT gr.cmdcode, max(gr.txname) txname,
                            max(CASE WHEN gr.atype = 'U' THEN gr.c1 ELSE '' END) UC1,
                            max(CASE WHEN gr.atype = 'U' THEN gr.c2 ELSE '' END) UC2,
                            max(CASE WHEN gr.atype = 'U' THEN gr.c3 ELSE '' END) UC3,
                            MIN(CASE WHEN gr.atype = 'U' THEN gr.c4 ELSE '' END) UC4,
                            max(CASE WHEN gr.atype = 'U' THEN gr.c5 ELSE '' END) UC5,
                            max(CASE WHEN gr.atype = 'G' THEN gr.c1 ELSE '' END) GC1,
                            max(CASE WHEN gr.atype = 'G' THEN gr.c2 ELSE '' END) GC2,
                            max(CASE WHEN gr.atype = 'G' THEN gr.c3 ELSE '' END) GC3,
                            MIN(CASE WHEN gr.atype = 'G' THEN gr.c4 ELSE '' END) GC4,
                            max(CASE WHEN gr.atype = 'G' THEN gr.c5 ELSE '' END) GC5,
                            max(C6) C6, MAX(C7) C7
                        FROM
                            (
                                SELECT AU.CMDCODE, MAX(TO_CHAR(RPT.RPTID)||': '||TO_CHAR(RPT.DESCRIPTION)) TXNAME,
                                    MAX(AU.CMDALLOW) C1, MAX(SUBSTR(AU.STRAUTH,1,1)) C2, MAX(SUBSTR(AU.STRAUTH,2,1)) C3,
                                    MIN(SUBSTR(AU.STRAUTH,3,1)) C4 ,'' C5,'' C6, 'R' C7, 'U' ATYPE
                                FROM RPTMASTER RPT ,CMDAUTH AU
                                WHERE RPT.RPTID = AU.CMDCODE
                                    AND AU.AUTHID = V_STRAUTHID
                                    AND RPT.CMDTYPE = 'R'
                                    AND (AU.STRAUTH<>'NN' OR AU.CMDALLOW<>'N')
                                    AND AU.AUTHTYPE='U'
                                GROUP BY AU.CMDCODE
                                UNION ALL
                                -- QUYEN GROUP
                                SELECT AU.CMDCODE, MAX(TO_CHAR(RPT.RPTID)||': '||TO_CHAR(RPT.DESCRIPTION)) TXNAME,
                                    MAX(AU.CMDALLOW) C1, MAX(SUBSTR(AU.STRAUTH,1,1)) C2, MAX(SUBSTR(AU.STRAUTH,2,1)) C3,
                                    MIN(SUBSTR(AU.STRAUTH,3,1)) C4 ,'' C5,'' C6, 'R' C7, 'G' ATYPE
                                FROM RPTMASTER RPT ,CMDAUTH AU
                                WHERE RPT.RPTID = AU.CMDCODE
                                    AND RPT.CMDTYPE = 'R'
                                    AND (AU.STRAUTH<>'NN' OR AU.CMDALLOW<>'N')
                                    AND AU.AUTHTYPE='G'
                                    AND V_AUTHTYPE = 'G'
                                    AND EXISTS (SELECT tlg.grpid
                                                FROM tlgrpusers tlg, tlgroups tlr, tlprofiles tlp, brgrpparam br
                                                WHERE tlr.grpid = tlg.grpid AND tlp.tlid = tlg.tlid
                                                    AND br.brid = tlp.brid AND br.paratype = 'TLGROUPS' AND br.paravalue = tlr.grpid
                                                    AND br.deltd = 'N' AND tlr.active = 'Y'
                                                    AND tlg.grpid = au.AUTHID AND tlg.tlid = V_STRAUTHID
                                                )
                                GROUP BY AU.CMDCODE
                            ) GR
                        GROUP BY GR.CMDCODE
                    ) A, ALLCODE A1
                    WHERE A1.CDTYPE = 'SY' AND A1.CDNAME = 'AREA' AND A1.CDVAL = CASE WHEN a.uc4 IS NOT NULL THEN a.uc4 ELSE a.gc4 END
                -- QUYEN GIAO DICH
                UNION ALL
                SELECT a.cmdcode, a.txname,
                    CASE WHEN a.uc1 IS NOT NULL THEN a.uc1 ELSE a.gc1 END c1,
                    CASE WHEN a.uc2 IS NOT NULL THEN a.uc2 ELSE a.gc2 END c2,
                    CASE WHEN a.uc3 IS NOT NULL THEN a.uc3 ELSE a.gc3 END c3,
                    CASE WHEN a.uc4 IS NOT NULL THEN a.uc4 ELSE a.gc4 END c4,
                    CASE WHEN a.uc5 IS NOT NULL THEN a.uc5 ELSE a.gc5 END c5,
                    A.C6, A.C7
                FROM
                    (
                        SELECT gr.cmdcode, max(gr.txname) txname,
                            max(CASE WHEN gr.atype = 'U' THEN gr.c1 ELSE '' END) UC1,
                            max(CASE WHEN gr.atype = 'U' THEN gr.c2 ELSE '' END) UC2,
                            max(CASE WHEN gr.atype = 'U' THEN gr.c3 ELSE '' END) UC3,
                            MAX(CASE WHEN gr.atype = 'U' THEN gr.c4 ELSE '' END) UC4,
                            max(CASE WHEN gr.atype = 'U' THEN gr.c5 ELSE '' END) UC5,
                            max(CASE WHEN gr.atype = 'G' THEN gr.c1 ELSE '' END) GC1,
                            max(CASE WHEN gr.atype = 'G' THEN gr.c2 ELSE '' END) GC2,
                            max(CASE WHEN gr.atype = 'G' THEN gr.c3 ELSE '' END) GC3,
                            MAX(CASE WHEN gr.atype = 'G' THEN gr.c4 ELSE '' END) GC4,
                            max(CASE WHEN gr.atype = 'G' THEN gr.c5 ELSE '' END) GC5,
                            max(C6) C6, MAX(C7) C7
                        FROM
                            (
                                SELECT TA.TLTXCD CMDCODE, TO_CHAR(TA.TLTXCD)||': ' ||TO_CHAR(TX.TXDESC) TXNAME,
                                    MAX(DECODE(TA.TLTYPE,'T',to_char(round(TA.TLLIMIT/1000000,2)),'')) C1,
                                    MAX(DECODE(TA.TLTYPE,'C',to_char(round(TA.TLLIMIT/1000000,2)),'')) C2,
                                    MAX(DECODE(TA.TLTYPE,'A',to_char(round(TA.TLLIMIT/1000000,2)),'')) C3,
                                    MAX(DECODE(TA.TLTYPE,'R',to_char(round(TA.TLLIMIT/1000000,2)),'')) C4,
                                    '' C5,'' C6, 'T' C7, 'U' ATYPE
                                FROM TLAUTH TA ,TLTX TX
                                WHERE  TA.TLTXCD =TX.TLTXCD
                                    AND TA.AUTHID = V_STRAUTHID
                                    AND TA.AUTHTYPE='U'
                                    AND NOT EXISTS (
                                                 SELECT SR.searchcode, SR.tltxcd
                                                 FROM SEARCH SR, RPTMASTER RPT, TLTX TL
                                                 WHERE SR.searchcode = RPT.rptid AND RPT.visible = 'Y' AND SR.tltxcd IS NOT NULL
                                                    AND SR.TLTXCD = TL.TLTXCD AND TL.DIRECT = 'N' AND TX.tltxcd = SR.tltxcd)
                                GROUP BY TA.TLTXCD,TX.TXDESC
                                UNION ALL
                                -- QUYEN GROUP
                                SELECT TA.TLTXCD CMDCODE, TO_CHAR(TA.TLTXCD)||': ' ||TO_CHAR(TX.TXDESC) TXNAME,
                                    MAX(DECODE(TA.TLTYPE,'T',to_char(TA.TLLIMIT/1000000),'')) C1,
                                    MAX(DECODE(TA.TLTYPE,'C',to_char(TA.TLLIMIT/1000000),'')) C2,
                                    MAX(DECODE(TA.TLTYPE,'A',to_char(TA.TLLIMIT/1000000),'')) C3,
                                    MAX(DECODE(TA.TLTYPE,'R',to_char(TA.TLLIMIT/1000000),''))C4,
                                    ''C5,'' C6, 'T' C7, 'G' ATYPE
                                FROM TLAUTH TA ,TLTX TX
                                WHERE  TA.TLTXCD =TX.TLTXCD
                                    AND TA.AUTHTYPE='G'
                                    AND V_AUTHTYPE = 'G'
                                    AND EXISTS (SELECT tlg.grpid
                                                FROM tlgrpusers tlg, tlgroups tlr, tlprofiles tlp, brgrpparam br
                                                WHERE tlr.grpid = tlg.grpid AND tlp.tlid = tlg.tlid
                                                    AND br.brid = tlp.brid AND br.paratype = 'TLGROUPS' AND br.paravalue = tlr.grpid
                                                    AND br.deltd = 'N' AND tlr.active = 'Y'
                                                    AND tlg.grpid = TA.AUTHID AND tlg.tlid = V_STRAUTHID
                                                )
                                    AND NOT EXISTS (
                                                 SELECT SR.searchcode, SR.tltxcd
                                                 FROM SEARCH SR, RPTMASTER RPT, TLTX TL
                                                 WHERE SR.searchcode = RPT.rptid AND RPT.visible = 'Y' AND SR.tltxcd IS NOT NULL
                                                    AND SR.TLTXCD = TL.TLTXCD AND TL.DIRECT = 'N' AND TX.tltxcd = SR.tltxcd)
                                GROUP BY TA.TLTXCD,TX.TXDESC
                            ) GR
                        GROUP BY GR.CMDCODE
                    ) A
                union ALL
                -- QUYEN TRA CUU TONG HOP
                SELECT A.CMDCODE, A.TXNAME, NVL(B.C1,'') C1, NVL(B.C2,'') C2, NVL(B.C3,'') C3,
                    NVL(B.C4,'') C4, '' C5, '' C6, 'S' C7
                FROM
                    (   -- DANH SACH TRA CUU TONG HOP
                        SELECT GR.CMDCODE, MAX(GR.TLTXCD) TLTXCD, MAX(GR.TXNAME) TXNAME
                        FROM
                            (
                                SELECT AU.CMDCODE, max(nvl(sr.tltxcd,'')) tltxcd, MAX(RPT.RPTID ||'-'|| CASE WHEN SR.TLTXCD IS NULL THEN 'VIEW' ELSE SR.TLTXCD END ||': '|| RPT.DESCRIPTION) TXNAME
                                FROM RPTMASTER RPT ,CMDAUTH AU, search sr
                                WHERE RPT.RPTID = AU.CMDCODE AND SR.SEARCHCODE = RPT.RPTID
                                    AND RPT.CMDTYPE in ('V','D','L') AND rpt.visible = 'Y'
                                    AND au.cmdtype = 'G'
                                    AND AU.AUTHID = V_STRAUTHID
                                    AND AU.AUTHTYPE='U'
                                GROUP BY AU.CMDCODE
                                UNION ALL
                                -- QUYEN GROUP
                                SELECT AU.CMDCODE, max(nvl(sr.tltxcd,'')) tltxcd, MAX(RPT.RPTID ||'-'|| CASE WHEN SR.TLTXCD IS NULL THEN 'VIEW' ELSE SR.TLTXCD END ||': '|| RPT.DESCRIPTION) TXNAME
                                FROM RPTMASTER RPT ,CMDAUTH AU, search sr
                                WHERE RPT.RPTID = AU.CMDCODE AND SR.SEARCHCODE = RPT.RPTID
                                    AND RPT.CMDTYPE in ('V','D','L') AND rpt.visible = 'Y'
                                    AND au.cmdtype = 'G'
                                    --AND (AU.STRAUTH<>'NN' OR AU.CMDALLOW<>'N')
                                    AND AU.AUTHTYPE='G'
                                    AND V_AUTHTYPE = 'G'
                                    AND EXISTS (SELECT tlg.grpid
                                                FROM tlgrpusers tlg, tlgroups tlr, tlprofiles tlp, brgrpparam br
                                                WHERE tlr.grpid = tlg.grpid AND tlp.tlid = tlg.tlid
                                                    AND br.brid = tlp.brid AND br.paratype = 'TLGROUPS' AND br.paravalue = tlr.grpid
                                                    AND br.deltd = 'N' AND tlr.active = 'Y'
                                                    AND tlg.grpid = au.AUTHID AND tlg.tlid = V_STRAUTHID
                                                )
                                GROUP BY AU.CMDCODE
                            ) GR
                        GROUP BY GR.CMDCODE
                    ) A
                    LEFT JOIN
                    (   -- QUYEN GIAO DICH TUONG UNG
                        SELECT a.cmdcode, a.txname,
                            CASE WHEN a.uc1 IS NOT NULL THEN a.uc1 ELSE a.gc1 END c1,
                            CASE WHEN a.uc2 IS NOT NULL THEN a.uc2 ELSE a.gc2 END c2,
                            CASE WHEN a.uc3 IS NOT NULL THEN a.uc3 ELSE a.gc3 END c3,
                            CASE WHEN a.uc4 IS NOT NULL THEN a.uc4 ELSE a.gc4 END c4,
                            CASE WHEN a.uc5 IS NOT NULL THEN a.uc5 ELSE a.gc5 END c5,
                            A.C6, A.C7
                        FROM
                            (
                                SELECT gr.cmdcode, max(gr.txname) txname,
                                    max(CASE WHEN gr.atype = 'U' THEN gr.c1 ELSE '' END) UC1,
                                    max(CASE WHEN gr.atype = 'U' THEN gr.c2 ELSE '' END) UC2,
                                    max(CASE WHEN gr.atype = 'U' THEN gr.c3 ELSE '' END) UC3,
                                    MAX(CASE WHEN gr.atype = 'U' THEN gr.c4 ELSE '' END) UC4,
                                    max(CASE WHEN gr.atype = 'U' THEN gr.c5 ELSE '' END) UC5,
                                    max(CASE WHEN gr.atype = 'G' THEN gr.c1 ELSE '' END) GC1,
                                    max(CASE WHEN gr.atype = 'G' THEN gr.c2 ELSE '' END) GC2,
                                    max(CASE WHEN gr.atype = 'G' THEN gr.c3 ELSE '' END) GC3,
                                    MAX(CASE WHEN gr.atype = 'G' THEN gr.c4 ELSE '' END) GC4,
                                    max(CASE WHEN gr.atype = 'G' THEN gr.c5 ELSE '' END) GC5,
                                    max(C6) C6, MAX(C7) C7
                                FROM
                                    (
                                        SELECT TA.TLTXCD CMDCODE, TO_CHAR(TA.TLTXCD)||': ' ||TO_CHAR(TX.TXDESC) TXNAME,
                                            MAX(DECODE(TA.TLTYPE,'T',to_char(round(TA.TLLIMIT/1000000,2)),'')) C1,
                                            MAX(DECODE(TA.TLTYPE,'C',to_char(round(TA.TLLIMIT/1000000,2)),'')) C2,
                                            MAX(DECODE(TA.TLTYPE,'A',to_char(round(TA.TLLIMIT/1000000,2)),'')) C3,
                                            MAX(DECODE(TA.TLTYPE,'R',to_char(round(TA.TLLIMIT/1000000,2)),'')) C4,
                                            '' C5,'' C6, 'T' C7, 'U' ATYPE
                                        FROM TLAUTH TA ,TLTX TX
                                        WHERE  TA.TLTXCD =TX.TLTXCD
                                            AND TA.AUTHID = V_STRAUTHID
                                            AND TA.AUTHTYPE='U'
                                            AND EXISTS (
                                                         SELECT SR.searchcode, SR.tltxcd
                                                         FROM SEARCH SR, RPTMASTER RPT, TLTX TL
                                                         WHERE SR.searchcode = RPT.rptid AND RPT.visible = 'Y' AND SR.tltxcd IS NOT NULL
                                                            AND SR.TLTXCD = TL.TLTXCD AND TL.DIRECT = 'N' AND TX.tltxcd = SR.tltxcd)
                                        GROUP BY TA.TLTXCD,TX.TXDESC
                                        UNION ALL
                                        -- QUYEN GROUP
                                        SELECT TA.TLTXCD CMDCODE, TO_CHAR(TA.TLTXCD)||': ' ||TO_CHAR(TX.TXDESC) TXNAME,
                                            MAX(DECODE(TA.TLTYPE,'T',to_char(TA.TLLIMIT/1000000),'')) C1,
                                            MAX(DECODE(TA.TLTYPE,'C',to_char(TA.TLLIMIT/1000000),'')) C2,
                                            MAX(DECODE(TA.TLTYPE,'A',to_char(TA.TLLIMIT/1000000),'')) C3,
                                            MAX(DECODE(TA.TLTYPE,'R',to_char(TA.TLLIMIT/1000000),''))C4,
                                            ''C5,'' C6, 'T' C7, 'G' ATYPE
                                        FROM TLAUTH TA ,TLTX TX
                                        WHERE  TA.TLTXCD =TX.TLTXCD
                                            AND TA.AUTHTYPE='G'
                                            AND V_AUTHTYPE = 'G'
                                            AND EXISTS (SELECT tlg.grpid
                                                        FROM tlgrpusers tlg, tlgroups tlr, tlprofiles tlp, brgrpparam br
                                                        WHERE tlr.grpid = tlg.grpid AND tlp.tlid = tlg.tlid
                                                            AND br.brid = tlp.brid AND br.paratype = 'TLGROUPS' AND br.paravalue = tlr.grpid
                                                            AND br.deltd = 'N' AND tlr.active = 'Y'
                                                            AND tlg.grpid = TA.AUTHID AND tlg.tlid = V_STRAUTHID
                                                        )
                                            AND EXISTS (
                                                         SELECT SR.searchcode, SR.tltxcd
                                                         FROM SEARCH SR, RPTMASTER RPT, TLTX TL
                                                         WHERE SR.searchcode = RPT.rptid AND RPT.visible = 'Y' AND SR.tltxcd IS NOT NULL
                                                            AND SR.TLTXCD = TL.TLTXCD AND TL.DIRECT = 'N' AND TX.tltxcd = SR.tltxcd)
                                        GROUP BY TA.TLTXCD,TX.TXDESC
                                    ) GR
                                GROUP BY GR.CMDCODE
                            ) A
                    ) B
                    ON A.TLTXCD = B.CMDCODE
                UNION ALL
                -- QUYEN AFTYPE
                SELECT GA.AFTYPE CMDCODE, MAX(TO_CHAR(GA.AFTYPE)||': '||TO_CHAR(AFT.TYPENAME)) TXNAME,
                    '' C1, '' C2, '' C3, '' C4 ,'' C5,'' C6, 'W' C7
                FROM TLGRPAFTYPE GA, TLGROUPS TLG, AFTYPE AFT
                WHERE TLG.GRPID = GA.GRPID AND GA.AFTYPE = AFT.ACTYPE
                    AND TLG.ACTIVE = 'Y'
                    AND V_AUTHTYPE = 'G'
                    AND EXISTS (SELECT tlg.grpid
                                FROM tlgrpusers tlg, tlgroups tlr, tlprofiles tlp, brgrpparam br
                                WHERE tlr.grpid = tlg.grpid AND tlp.tlid = tlg.tlid
                                    AND br.brid = tlp.brid AND br.paratype = 'TLGROUPS' AND br.paravalue = tlr.grpid
                                    AND br.deltd = 'N' AND tlr.active = 'Y'
                                    AND tlg.grpid = GA.GRPID AND tlg.tlid = V_STRAUTHID
                                )
                GROUP BY GA.AFTYPE
            ) DT
        ORDER BY DT.C7, DT.CMDCODE, DT.TXNAME
    ;

    EXCEPTION
    WHEN OTHERS THEN
        RETURN;
    END;                                                              -- PROCEDURE
/

