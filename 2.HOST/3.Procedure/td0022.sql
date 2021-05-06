CREATE OR REPLACE PROCEDURE td0022 (pv_refcursor  IN OUT pkg_report.ref_cursor,
/* Formatted on 26/10/2010 4:13:48 PM (QP5 v5.126) */
                  opt            IN     VARCHAR2,
                  brid           IN     VARCHAR2,
                  f_date         IN     VARCHAR2,
                  t_date         IN     VARCHAR2,
                  maker          IN     VARCHAR2
                  )
IS

    -- --------- ------ -------------------------------------------
    cur             pkg_report.ref_cursor;
    v_stroption     VARCHAR2 (5);
    v_strbrid       VARCHAR2 (4);
    l_maker         VARCHAR2(4);
    V_name          VARCHAR2(200);
    V_STRTLTXCD     VARCHAR2(100);
    v_1100          number;
    V_1600          number;
    V_1670          number;

BEGIN
    v_stroption := opt;

    IF (v_stroption <> 'A') AND (brid <> 'ALL')
    THEN
        v_strbrid := brid;
    ELSE
        v_strbrid := '%%';
    END IF;

    IF (maker <> 'ALL') THEN
      l_maker := maker;
   ELSE
      l_maker := '%%';
   END IF;



  BEGIN
  select tlname into V_name from tlprofiles where tlid like l_maker;
  Exception when others then
  V_name:='ALL';
  End;


    select  COUNT (txnum) into V_1600
    from (SELECT * FROM tllog UNION ALL SELECT * FROM tllogall)tl, tlprofiles tlp1 where tltxcd = '1600'
    and tl.TXDATE >= TO_DATE(F_DATE, 'DD/MM/YYYY')
    and tl.TXDATE <= TO_DATE(T_DATE, 'DD/MM/YYYY')
    and tl.tlid = tlp1.tlid
    and tlp1.tlid like l_maker
    ;

        select  COUNT (txnum) into V_1670
    from (SELECT * FROM tllog UNION ALL SELECT * FROM tllogall)tl, tlprofiles tlp1 where tltxcd = '1670'
    and tl.TXDATE >= TO_DATE(F_DATE, 'DD/MM/YYYY')
    and tl.TXDATE <= TO_DATE(T_DATE, 'DD/MM/YYYY')
    and tl.tlid = tlp1.tlid
    and tlp1.tlid like l_maker
    ;

    OPEN pv_refcursor
    FOR

           SELECT tl.txdate, tl.txnum orderid,  tl.TXDESC, tl.msgacct afacctno , tl.msgamt,  tl.tltxcd, tlp1.tlname, nvl(tl.offid,tl.chkid) offid ,
            tlp2.tlname offid_name, V_1600 V_1600, V_1670 V_1670, V_name l_maker1, tl.tlid
             FROM
                (
                            SELECT substr(msgacct,1,10) msgacct, SUM (msgamt) msgamt,tl.tlid, tl.txdate, tl.tltxcd, tl.TXDESC, tl.txnum,  tl.offid , tl.chkid
                            FROM
                                  (SELECT * FROM tllog UNION ALL SELECT * FROM tllogall) tl
                                    WHERE tl.deltd = 'N'
                                    and tl.TXDATE >= TO_DATE(F_DATE, 'DD/MM/YYYY')
                                   and tl.TXDATE <= TO_DATE(T_DATE, 'DD/MM/YYYY')
                                    AND tl.tltxcd IN ('1600','1670')
                                   GROUP BY tl.msgacct, tlid,tl.txdate, tl.tltxcd, tl.TXDESC,tl.txnum, tl.offid ,tl.chkid
                  ) TL , tlprofiles tlp1,tlprofiles tlp2
                  WHERE tl.tlid = tlp1.tlid
                  and tlp1.tlid like l_maker
                  and tlp2.tlid = nvl(tl.offid,tl.chkid)
                  order by tl.txdate, tl.tltxcd, tl.msgamt

  ;
    EXCEPTION
        WHEN OTHERS
        THEN
            RETURN;
END;
/

