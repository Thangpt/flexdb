CREATE OR REPLACE PROCEDURE CI1022
   (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   AFACCTNO       IN       VARCHAR2,
   PV_TLTXCD      IN       VARCHAR2,
   PV_TLID        IN       VARCHAR2
   )
   IS
   v_CUSTODYCD VARCHAR2(500);
   v_AFACCTNO  VARCHAR2(20);
   v_TLTXCD    VARCHAR2(10);
   v_tlid      VARCHAR2(10);

   V_STROPTION   VARCHAR2(10);
   V_STRBRID     VARCHAR2(40);
   V_INBRID      VARCHAR2(4);

BEGIN

    V_STROPTION := upper(OPT);
    V_INBRID := BRID;

    IF (V_STROPTION = 'A')
    THEN
        V_STRBRID := '%';
    ELSE if (V_STROPTION = 'B') then
            select brgrp.mapid into V_STRBRID from brgrp where brgrp.brid = V_INBRID;
        else
            V_STRBRID := V_INBRID;
        end if;
    END IF;

    IF PV_CUSTODYCD='ALL' THEN
       V_CUSTODYCD:='%%';
    ELSE
       V_CUSTODYCD:=PV_CUSTODYCD;
    END IF;

    IF AFACCTNO='ALL' THEN
       v_AFACCTNO:='%%';
    ELSE
       v_AFACCTNO:=AFACCTNO;
    END IF;

    IF PV_TLTXCD='ALL' THEN
       v_TLTXCD:='%%';
    ELSE
       v_TLTXCD:=PV_TLTXCD;
    END IF;
    
    IF PV_TLID='ALL' THEN
       v_tlid:='%%';
    ELSE
       v_tlid:=PV_TLID;
    END IF;

     ---GET REPORT DATA:

      OPEN PV_REFCURSOR
      FOR
      SELECT * FROM (
        SELECT CF.CUSTODYCD, AF.ACCTNO, tl.BUSDATE,tl.TLTXCD,tltx.txdesc, tl.msgamt NAMT,
                 '' BENEFACCT, '' BENEFCUSTNAME,'' BENEFBANK,
                 tlp1.tlname, tlp2.tlname offname
                FROM vw_tllog_all tl ,afmast af,CFMAST CF, tltx,
                     tlprofiles tlp1, tlprofiles tlp2, tlgrpusers tlg
                 WHERE tl.TLTXCD IN ('1132','1141')
                       AND af.custid = cf.custid AND tl.MSGACCT=af.acctno
                       AND tl.TLTXCD = tltx.tltxcd
                       AND tl.TLID = tlp1.tlid AND decode(tl.TLID,'6868',tl.TLID,tl.OFFID) = tlp2.tlid(+)
                       --AND (tl.brid like V_STRBRID or INSTR(V_STRBRID,tl.brid) <> 0)
                       AND tl.BUSDATE <= TO_DATE(T_DATE,'DD/MM/RRRR') AND tl.BUSDATE >= TO_DATE(F_DATE,'DD/MM/RRRR')
                       AND tl.MSGACCT LIKE v_AFACCTNO AND CF.CUSTODYCD LIKE V_CUSTODYCD
                       AND tl.TLTXCD LIKE v_TLTXCD
                       AND tlg.grpid = cf.careby AND tlg.tlid LIKE v_tlid

             UNION ALL

          SELECT CF.CUSTODYCD, AF.ACCTNO, tl.BUSDATE,tl.TLTXCD,tltx.txdesc,tl.msgamt NAMT,
                 cir.benefacct BENEFACCT, cir.benefcustname BENEFCUSTNAME,
                 CASE WHEN tl.TLTXCD = '1120' THEN '' ELSE cir.benefbank END BENEFBANK,
                 tlp1.tlname, tlp2.tlname offname
                FROM vw_tllog_all tl ,ciremittance cir,afmast af,CFMAST CF,tltx,
                     tlprofiles tlp1, tlprofiles tlp2, tlgrpusers tlg
                 WHERE tl.TLTXCD IN ('1120','1101')
                       AND tl.TXNUM=cir.TXNUM AND tl.MSGACCT=cir.acctno
                       AND af.custid = cf.custid AND tl.MSGACCT=af.acctno
                       AND tl.TLTXCD = tltx.tltxcd
                       AND tl.TLID = tlp1.tlid AND decode(tl.TLID,'6868',tl.TLID,tl.OFFID) = tlp2.tlid(+)
                       --AND (tl.brid like V_STRBRID or INSTR(V_STRBRID,tl.brid) <> 0)
                       AND tl.BUSDATE <= TO_DATE(T_DATE,'DD/MM/RRRR') AND tl.BUSDATE >= TO_DATE(F_DATE,'DD/MM/RRRR')
                       AND tl.MSGACCT LIKE v_AFACCTNO AND CF.CUSTODYCD LIKE V_CUSTODYCD
                       AND tl.TLTXCD LIKE v_TLTXCD
                       AND tlg.grpid = cf.careby AND tlg.tlid LIKE v_tlid
      ) A
      order by  A.busdate,A.CUSTODYCD
    ;


EXCEPTION
    WHEN OTHERS THEN
        RETURN ;
END; -- Procedure
/
