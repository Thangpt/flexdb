CREATE OR REPLACE PACKAGE cspks_filemaster
IS
    /*----------------------------------------------------------------------------------------------------
     ** Module   : COMMODITY SYSTEM
     ** and is copyrighted by FSS.
     **
     **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
     **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
     **    graphic, optic recording or otherwise, translated in any language or computer language,
     **    without the prior written permission of Financial Software Solutions. JSC.
     **
     **  MODIFICATION HISTORY
     **  Person      Date           Comments
     **  TienPQ      09-JUNE-2009    Created
     ** (c) 2008 by Financial Software Solutions. JSC.
     ----------------------------------------------------------------------------------------------------*/


  PROCEDURE CAL_DF_BASKET (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE FILLTER_DF_BASKET (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE CAL_MARGIN_LIMIT (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE CAL_SEC_BASKET (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE CAL_SEC_BASKET_EDIT (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE FILLTER_SEC_BASKET (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE FILLTER_SEC_BASKET_EDIT (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE CAL_SECURITIES_RISK (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE FILLTER_SECURITIES_RISK (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE CAL_COP_ACTION (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE MAK_BLACKLISTSECURITIES (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  Procedure INSERT_SYMBOLBLACKLIST (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE pr_CashDepositUpload(p_tlid IN VARCHAR2, p_err_code out varchar2,p_err_param out varchar2);
  PROCEDURE pr_CFSEUpload(p_tlid IN VARCHAR2, p_err_code out varchar2,p_err_param out varchar2);
  PROCEDURE pr_Guarantee(p_tlid IN VARCHAR2, p_err_code out varchar2,p_err_param out varchar2);
  PROCEDURE pr_TRFSTOCK(p_tlid IN VARCHAR2, p_err_code out varchar2,p_err_param out varchar2);
  PROCEDURE CAL_OTHERCIACCTNO_ACTION (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE CAL_OTHERSEACCTNO_ACTION (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE FILLTER_OTHERCIACCTNO_ACTION (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE FILLTER_OTHERSEACCTNO_ACTION (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_PRSYSTEM_APPROVE (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_PRSYSTEM_UPLOAD (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE pr_T0Limit_Import(p_tlid IN VARCHAR2, p_err_code out varchar2,p_err_param out varchar2);
  PROCEDURE pr_T0AFLimit_Import(p_tlid IN VARCHAR2, p_err_code out varchar2,p_err_param out varchar2);
  PROCEDURE PR_ROOM_MARGIN_APPROVE (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_ROOM_SYSTEM_APPROVE (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE T0_AVRTRADEQTTY_MAKE (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE T0_AVRTRADEQTTY_APPROVE (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE T0_NAVPRICE_MAKE (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE T0_NAVPRICE_APPROVE (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_PRICE_MARGIN_APPROVE (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_SYMBOL_SELL_ORDER (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_PRICE_CL_APPROVE (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_FILE_TBLCFAF (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_FILE_TBLSE2240 (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_FILE_TBLSE2245 (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_FILE_TBLCI1141 (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_FILE_TBLCI1137(p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_FILE_TBLCI1138(p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_FILE_TBLCI1101 (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_FILE_TBLCI1187 (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_FILE_TBLSE2287 (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_FILE_TBLSE2203 (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_FILE_CADTLIMP (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE CAL_INSERT_CUSTOMERLIST (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_APR_FILE_TBLRE0380(P_TLID        IN VARCHAR2,
                            P_ERR_CODE    OUT VARCHAR2,
                            P_ERR_MESSAGE OUT VARCHAR2);
  PROCEDURE PR_FILE_TBLRE0380(P_TLID        IN VARCHAR2,
                            P_ERR_CODE    OUT VARCHAR2,
                            P_ERR_MESSAGE OUT VARCHAR2);
  PROCEDURE PR_FILE_TBLCFCHGBRID(p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
--1.5.7.0
  PROCEDURE PR_REGPRODUCT(p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_FILTERREGPRODUCT(p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_DELPRODUCT(p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  PROCEDURE PR_FILTERDELPRODUCT(p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2);
  -- 1.5.7.6|iss:1970
  PROCEDURE PR_FILTERCFTRFLIMIT (
     p_tlid          in varchar2,
     p_err_code      out varchar2,
     p_err_message   out varchar2
  );
  PROCEDURE PR_CFTRFLIMIT (
     p_tlid          in varchar2,
     p_err_code      out varchar2,
     p_err_message   out varchar2
  );
  --1.7.1.1|iss:2222
  PROCEDURE PR_INT_CHANGE (p_tlid in varchar2, p_err_code out varchar2, p_err_message out varchar2);
  PROCEDURE PR_CFLN_PREFERENTIAL (p_tlid in varchar2, p_err_code out varchar2, p_err_message out varchar2);
 PROCEDURE PR_CFLN_PREFERENTIAL_APPROVE (p_tlid in varchar2, p_err_code out varchar2, p_err_message out varchar2);
 PROCEDURE PR_FILE_CFCOMPARE2FILE(p_tlid in varchar2, p_err_code out varchar2, p_err_message out varchar2);

END;
/
CREATE OR REPLACE PACKAGE BODY cspks_filemaster
IS
   -- declare log context
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

PROCEDURE CAL_SEC_BASKET (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
v_count NUMBER;
v_basketid varchar2(100);
v_symbol varchar2(100);
BEGIN
    -- Kiem tra neu trung khoa secbaskettemp; Tra ve loi
    BEGIN
    SELECT basketid,symbol, count(1) INTO v_basketid,v_symbol,v_count FROM secbaskettemp
    HAVING count(1) <> 1
    GROUP BY  basketid,symbol;
        -- co 1 truong hop bi trung khoa
        p_err_code := -100407;
        p_err_message:= 'Dupplicate key of secbaskettemp!';
        RETURN;
    EXCEPTION
    WHEN no_data_found THEN
        NULL; -- OK khong bi trung khoa
    WHEN OTHERS THEN
        p_err_code := -100407;
        p_err_message:= 'Dupplicate key of secbaskettemp!';
        RETURN;
    END;

    -- Kiem tra bracketID da duoc khai bao hay chua?
    SELECT count(1)
        INTO v_count
    FROM secbaskettemp
    WHERE NOT EXISTS (SELECT basketid FROM basket WHERE basket.basketid = secbaskettemp.basketid);
    IF v_count > 0 THEN
        p_err_code := -100406;
        p_err_message:= 'Chua khai bao backetid!';
        RETURN;
    END IF;
    --sua ma CK trong ro
    FOR rec IN
    (
        SELECT s.basketid, s.symbol,
            t.mrratiorate mrratiorate, t.mrratioloan mrratioloan,
            t.mrpricerate mrpricerate, t.mrpriceloan mrpriceloan,
            s.mrratiorate mrratiorate_old, s.mrratioloan mrratioloan_old,
            s.mrpricerate mrpricerate_old, s.mrpriceloan mrpriceloan_old, t.tellerid
        FROM
        secbasket s, secbaskettemp t
        WHERE s.basketid = t.basketid AND s.symbol = t.symbol
    )
    LOOP
        INSERT INTO secbasket_log (TXDATE,TXTIME,BASKETID,SYMBOL,MRRATIORATE,MRRATIOLOAN,MRPRICERATE,MRPRICELOAN,
                                    MRRATIORATE_OLD,MRRATIOLOAN_OLD,MRPRICERATE_OLD,MRPRICELOAN_OLD,MAKERID,CHECKERID,ACTION)
        VALUES(getcurrdate,to_char(SYSDATE,'hh24:mi:ss'),rec.basketid,rec.symbol,rec.mrratiorate,rec.mrratioloan,rec.mrpricerate,rec.mrpriceloan,
                rec.mrratiorate_old,rec.mrratioloan_old,rec.mrpricerate_old,rec.mrpriceloan_old,rec.tellerid,p_tlid,'I002-EDIT');

    END LOOP;
    --xoa ma CK trong ro
    FOR rec1 IN
    (
        SELECT s.basketid, s.symbol, 0 mrratiorate, 0 mrratioloan, 0 mrpricerate, 0 mrpriceloan,
            s.mrratiorate mrratiorate_old, s.mrratioloan mrratioloan_old,
            s.mrpricerate mrpricerate_old, s.mrpriceloan mrpriceloan_old, (SELECT max(t.tellerid) FROM secbaskettemp t) tellerid
        FROM secbasket s
        WHERE s.symbol NOT IN (SELECT t.symbol FROM secbaskettemp t WHERE t.basketid = s.basketid)
        AND s.basketid IN (SELECT t.basketid FROM secbaskettemp t)
    )
    LOOP
        INSERT INTO secbasket_log (TXDATE,TXTIME,BASKETID,SYMBOL,MRRATIORATE,MRRATIOLOAN,MRPRICERATE,MRPRICELOAN,
                                    MRRATIORATE_OLD,MRRATIOLOAN_OLD,MRPRICERATE_OLD,MRPRICELOAN_OLD,MAKERID,CHECKERID,ACTION)
        VALUES(getcurrdate,to_char(SYSDATE,'hh24:mi:ss'),rec1.basketid,rec1.symbol,rec1.mrratiorate,rec1.mrratioloan,rec1.mrpricerate,rec1.mrpriceloan,
                rec1.mrratiorate_old,rec1.mrratioloan_old,rec1.mrpricerate_old,rec1.mrpriceloan_old,rec1.tellerid,p_tlid,'I002-DELETE');

    END LOOP;
    --them ma CK trong ro
    FOR rec2 IN
    (
        SELECT s.*,
            0 mrratiorate_old, 0 mrratioloan_old,
            0 mrpricerate_old, 0 mrpriceloan_old
        FROM secbaskettemp s
        WHERE s.symbol NOT IN (SELECT t.symbol FROM secbasket t WHERE t.basketid = s.basketid)
    )
    LOOP
        INSERT INTO secbasket_log (TXDATE,TXTIME,BASKETID,SYMBOL,MRRATIORATE,MRRATIOLOAN,MRPRICERATE,MRPRICELOAN,
                                    MRRATIORATE_OLD,MRRATIOLOAN_OLD,MRPRICERATE_OLD,MRPRICELOAN_OLD,MAKERID,CHECKERID,ACTION)
        VALUES(getcurrdate,to_char(SYSDATE,'hh24:mi:ss'),rec2.basketid,rec2.symbol,rec2.mrratiorate,rec2.mrratioloan,rec2.mrpricerate,rec2.mrpriceloan,
                rec2.mrratiorate_old,rec2.mrratioloan_old,rec2.mrpricerate_old,rec2.mrpriceloan_old,rec2.tellerid,p_tlid,'I002-ADD');

    END LOOP;

    --backup old secbasket
    insert into secbaskethist
    (autoid,basketid, symbol, mrratiorate, mrratioloan,
       mrpricerate, mrpriceloan, description, backupdt,importdt,expdate)
    select autoid,basketid, symbol, mrratiorate, mrratioloan,
       mrpricerate, mrpriceloan, description, to_char(sysdate,'DD/MM/YYYY:HH:MI:SS') backupdt,importdt,expdate
    from secbasket where basketid  in (select basketid from secbaskettemp);
    delete from secbasket where basketid in (select basketid from secbaskettemp);
    insert into secbasket
    (autoid,basketid, symbol, mrratiorate, mrratioloan,
       mrpricerate, mrpriceloan, description, importdt, expdate)
    select seq_secbasket.nextval,basketid, symbol, mrratiorate, mrratioloan,
       mrpricerate, mrpriceloan, description, to_char(sysdate,'DD/MM/YYYY:HH:MI:SS') importdt, to_date(expdate,'dd/mm/rrrr') expdate
    from secbaskettemp where status <> 'N';

    update secbaskettemp set approved='Y', aprid=p_tlid;
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';


exception
when others then
    rollback;
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END CAL_SEC_BASKET;

PROCEDURE CAL_SEC_BASKET_EDIT (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
v_count NUMBER;
v_basketid varchar2(100);
v_symbol varchar2(100);
BEGIN
    -- Kiem tra neu trung khoa secbaskettemp; Tra ve loi
    BEGIN
    SELECT basketid,symbol, count(1) INTO v_basketid,v_symbol,v_count FROM secbasketedit
    HAVING count(1) <> 1
    GROUP BY  basketid,symbol;
        -- co 1 truong hop bi trung khoa
        p_err_code := -100407;
        p_err_message:= 'Dupplicate key of secbasketedit!';
        RETURN;
    EXCEPTION
    WHEN no_data_found THEN
        NULL; -- OK khong bi trung khoa
    WHEN OTHERS THEN
        p_err_code := -100407;
        p_err_message:= 'Dupplicate key of secbasketedit!';
        RETURN;
    END;

    -- Kiem tra bracketID da duoc khai bao hay chua?
    SELECT count(1)
        INTO v_count
    FROM secbasketedit
    WHERE NOT EXISTS (SELECT basketid FROM basket WHERE basket.basketid = secbasketedit.basketid);
    IF v_count > 0 THEN
        p_err_code := -100406;
        p_err_message:= 'Chua khai bao backetid!';
        RETURN;
    END IF;
    --sua ma CK trong ro
    FOR rec IN
    (
        SELECT s.basketid, s.symbol,
            t.mrratiorate mrratiorate, t.mrratioloan mrratioloan,
            t.mrpricerate mrpricerate, t.mrpriceloan mrpriceloan,
            s.mrratiorate mrratiorate_old, s.mrratioloan mrratioloan_old,
            s.mrpricerate mrpricerate_old, s.mrpriceloan mrpriceloan_old, t.tellerid
        FROM
        secbasket s, secbasketedit t
        WHERE s.basketid = t.basketid AND s.symbol = t.symbol
    )
    LOOP
        INSERT INTO secbasket_log (TXDATE,TXTIME,BASKETID,SYMBOL,MRRATIORATE,MRRATIOLOAN,MRPRICERATE,MRPRICELOAN,
                                    MRRATIORATE_OLD,MRRATIOLOAN_OLD,MRPRICERATE_OLD,MRPRICELOAN_OLD,MAKERID,CHECKERID,ACTION)
        VALUES(getcurrdate,to_char(SYSDATE,'hh24:mi:ss'),rec.basketid,rec.symbol,rec.mrratiorate,rec.mrratioloan,rec.mrpricerate,rec.mrpriceloan,
                rec.mrratiorate_old,rec.mrratioloan_old,rec.mrpricerate_old,rec.mrpriceloan_old,rec.tellerid,p_tlid,'I009-EDIT');

    END LOOP;

    --them ma CK trong ro
    FOR rec2 IN
    (
        SELECT s.*,
            0 mrratiorate_old, 0 mrratioloan_old,
            0 mrpricerate_old, 0 mrpriceloan_old
        FROM secbasketedit s
        WHERE s.symbol NOT IN (SELECT t.symbol FROM secbasket t WHERE t.basketid = s.basketid)
    )
    LOOP
        INSERT INTO secbasket_log (TXDATE,TXTIME,BASKETID,SYMBOL,MRRATIORATE,MRRATIOLOAN,MRPRICERATE,MRPRICELOAN,
                                    MRRATIORATE_OLD,MRRATIOLOAN_OLD,MRPRICERATE_OLD,MRPRICELOAN_OLD,MAKERID,CHECKERID,ACTION)
        VALUES(getcurrdate,to_char(SYSDATE,'hh24:mi:ss'),rec2.basketid,rec2.symbol,rec2.mrratiorate,rec2.mrratioloan,rec2.mrpricerate,rec2.mrpriceloan,
                rec2.mrratiorate_old,rec2.mrratioloan_old,rec2.mrpricerate_old,rec2.mrpriceloan_old,rec2.tellerid,p_tlid,'I009-ADD');

    END LOOP;

    --backup old secbasket
    insert into secbaskethist
    (autoid,basketid, symbol, mrratiorate, mrratioloan,
       mrpricerate, mrpriceloan, description, backupdt,importdt,expdate)
    select autoid,basketid, symbol, mrratiorate, mrratioloan,
       mrpricerate, mrpriceloan, description, to_char(sysdate,'DD/MM/YYYY:HH:MI:SS') backupdt,importdt,expdate
    from secbasket where basketid||symbol  in (select basketid||symbol from secbasketedit);
    delete from secbasket where basketid||symbol in (select basketid||symbol from secbasketedit);
    insert into secbasket
    (autoid,basketid, symbol, mrratiorate, mrratioloan,
       mrpricerate, mrpriceloan, description, importdt, expdate)
    select seq_secbasket.nextval,basketid, symbol, mrratiorate, mrratioloan,
       mrpricerate, mrpriceloan, description, to_char(sysdate,'DD/MM/YYYY:HH:MI:SS') importdt, to_date(expdate,'dd/mm/rrrr') expdate
    from secbasketedit where status <> 'N';

    update secbasketedit set approved='Y', aprid=p_tlid;
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';


exception
when others then
    rollback;
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END CAL_SEC_BASKET_EDIT;

PROCEDURE  PR_FILE_CADTLIMP(p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
  IS
  CAMASTID VARCHAR(30);

  l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      v_strPREVDATE varchar2(20);
      v_strNEXTDATE varchar2(20);
      v_strDesc varchar2(1000);
      v_strEN_Desc varchar2(1000);
      v_blnVietnamese BOOLEAN;
      l_err_param varchar2(300);
      l_MaxRow NUMBER(20,0);
      N NUMBER ;
V_DUEDATE        DATE;
V_BEGINDATE       DATE;
V_CAMASTID        varchar2(300);
V_SYMBOL          varchar2(300);
V_CATYPE         varchar2(300);
V_REPORTDATE       DATE;
V_ACTIONDATE      DATE;
V_CATYPEVAL       varchar2(300);
V_RATE           varchar2(300);
V_RIGHTOFFRATE    varchar2(300);
V_FRDATETRANSFER   DATE;
V_TODATETRANSFER   DATE;
V_ROPRICE          NUMBER;
V_TVPRICE        NUMBER;
V_STATUS          varchar2(300);
V_DESC            varchar2(300);


  BEGIN

BEGIN
FOR REC in ( SELECT  camast.camastid ,camast.codeid,cf.custodycd,af.acctno afacctno,CF.CUSTID
 FROM cadtlimp ca, afmast af, cfmast cf , camast
where ca.custodycd = cf.custodycd and af.custid = cf.custid
and camast.camastid = ca.camastid AND af.status <>'C'
 )
loop
update cadtlimp set acctno = rec.afacctno||rec.codeid , afacctno = rec.afacctno, codeid = rec.codeid,custid= rec.custid
where custodycd = rec.custodycd and camastid = rec.camastid ;
end loop;
END ;
commit;
--

 SELECT CAMAST.CAMASTID  ,SYM.SYMBOL ,
 A1.CDCONTENT  ,REPORTDATE , DUEDATE ,ACTIONDATE ,BEGINDATE  ,  RIGHTOFFRATE ,
DESCRIPTION , A2.CDCONTENT  ,
nvl( (case when CAMAST.CATYPE='014' then CAMAST.EXPRICE end),0) ROPRICE ,
nvl( (case when CAMAST.CATYPE='011' then CAMAST.EXPRICE end),0) TVPRICE ,
(CASE WHEN EXRATE IS NOT NULL THEN EXRATE ELSE (CASE WHEN RIGHTOFFRATE IS NOT NULL
       THEN RIGHTOFFRATE ELSE (CASE WHEN DEVIDENTRATE IS NOT NULL THEN DEVIDENTRATE  ELSE
       (CASE WHEN SPLITRATE IS NOT NULL THEN SPLITRATE ELSE (CASE WHEN INTERESTRATE IS NOT NULL
       THEN INTERESTRATE ELSE
       (CASE WHEN DEVIDENTSHARES IS NOT NULL THEN DEVIDENTSHARES ELSE '0' END)END)END)END) END)END) RATE ,
       CAMAST.CATYPE,FRDATETRANSFER
  INTO V_CAMASTID, V_SYMBOL, V_CATYPE, V_REPORTDATE, V_DUEDATE , V_ACTIONDATE , V_BEGINDATE , V_RIGHTOFFRATE , V_DESC
       , V_STATUS , V_ROPRICE, V_TVPRICE , V_RATE  , V_CATYPE , V_FRDATETRANSFER
 FROM  CAMAST, SBSECURITIES SYM, ALLCODE A1, ALLCODE A2, ALLCODE A3,
      (select sum(case when schd.isci= 'Y' then schd.amt else 0 end) amt,
         sum( case when schd.isse ='Y' then schd.qtty else 0 end) qtty,
         sum(mst.pitrate *
                       ( CASE WHEN
                              (CASE WHEN schd.pitratemethod='##' THEN mst.pitratemethod ELSE schd.pitratemethod END) ='SC'
                         THEN 1 ELSE 0 END)
                        *(case when schd.isci= 'Y' then (case when  mst.catype='016' then schd.intamt else schd.amt end)
                               else 0 end) /100
            )taxamt,
       sum(mst.pitrate
                         * ( CASE WHEN
                              (CASE WHEN schd.pitratemethod='##' THEN mst.pitratemethod ELSE schd.pitratemethod END) ='SC'
                         THEN 0 ELSE 1 END)
             *(case when schd.isci= 'Y' then (case when  mst.catype='016' then schd.intamt else schd.amt end)
                               else 0 end) /100
            )realtaxamt,
         schd.camastid
          from caschd schd,camast mst
          where schd.deltd='N'
          and mst.deltd='N'
          AND mst.camastid=schd.camastid
          group by schd.camastid) SCHD
 WHERE CAMAST.CODEID=SYM.CODEID AND A1.CDTYPE = 'CA'
 AND A1.CDNAME = 'CATYPE' AND A1.CDVAL=CATYPE
 and A3.CDTYPE='CA' AND A3.CDNAME='PITRATEMETHOD' AND CAMAST.PITRATEMETHOD =A3.CDVAL
 AND A2.CDTYPE = 'CA' AND A2.CDNAME = 'CASTATUS'
 AND CAMAST.STATUS=A2.CDVAL AND CAMAST.DELTD ='N'
 and camast.camastid=schd.camastid(+)
 AND CAMAST.camastid  IN(SELECT MAX(CAMASTID) FROM cadtlimp );

 -----

    SELECT TXDESC,EN_TXDESC into v_strDesc, v_strEN_Desc FROM  TLTX WHERE TLTXCD='3325';
     SELECT TO_DATE (varvalue, systemnums.c_date_format)
               INTO v_strCURRDATE
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := systemnums.c_system_userid;
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := 'DAY';
    l_txmsg.txdate:=v_strCURRDATE;
    l_txmsg.BUSDATE:=v_strCURRDATE;
    l_txmsg.tltxcd:='3325';


        --Set txnum
        SELECT systemnums.C_BATCH_PREFIXED
                         || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                  INTO l_txmsg.txnum
                  FROM DUAL;
        l_txmsg.brid        := '0001';
        --Xac dinh xem nha day tu trong nuoc hay nuoc ngoai



       --Set cac field giao dich
        --01   N   DUEDATE
        l_txmsg.txfields ('01').defname   := 'DUEDATE';
        l_txmsg.txfields ('01').TYPE      := 'D';
        l_txmsg.txfields ('01').VALUE     := V_DUEDATE ;
             --02   N   BEGINDATE
        l_txmsg.txfields ('02').defname   := 'BEGINDATE';
        l_txmsg.txfields ('02').TYPE      := 'D';
        l_txmsg.txfields ('02').VALUE     := V_BEGINDATE ;
            --03   N   CAMASTID
        l_txmsg.txfields ('03').defname   := 'CAMASTID';
        l_txmsg.txfields ('03').TYPE      := 'C';
        l_txmsg.txfields ('03').VALUE     := V_CAMASTID ;
            --04   N   SYMBOL
        l_txmsg.txfields ('04').defname   := 'SYMBOL';
        l_txmsg.txfields ('04').TYPE      := 'C';
        l_txmsg.txfields ('04').VALUE     := V_SYMBOL ;
            --05   N   CATYPE
        l_txmsg.txfields ('05').defname   := 'CATYPE';
        l_txmsg.txfields ('05').TYPE      := 'C';
        l_txmsg.txfields ('05').VALUE     := V_CATYPE ;
          --06   N   REPORTDATE
        l_txmsg.txfields ('06').defname   := 'REPORTDATE';
        l_txmsg.txfields ('06').TYPE      := 'D';
        l_txmsg.txfields ('06').VALUE     := V_REPORTDATE ;
            --07   N   ACTIONDATE
        l_txmsg.txfields ('07').defname   := 'ACTIONDATE';
        l_txmsg.txfields ('07').TYPE      := 'D';
        l_txmsg.txfields ('07').VALUE     := V_ACTIONDATE ;
            --09   C   CATYPEVAL
        l_txmsg.txfields ('09').defname   := 'CATYPEVAL';
        l_txmsg.txfields ('09').TYPE      := 'C';
        l_txmsg.txfields ('09').VALUE     := V_CATYPEVAL ;
            --10   N   RATE
        l_txmsg.txfields ('10').defname   := 'RATE';
        l_txmsg.txfields ('10').TYPE      := 'N';
        l_txmsg.txfields ('10').VALUE     := V_RATE ;
           --11   N   RIGHTOFFRATE
        l_txmsg.txfields ('11').defname   := 'RIGHTOFFRATE';
        l_txmsg.txfields ('11').TYPE      := 'N';
        l_txmsg.txfields ('11').VALUE     := V_RIGHTOFFRATE ;
                    --12   N   FRDATETRANSFER
        l_txmsg.txfields ('12').defname   := 'FRDATETRANSFER';
        l_txmsg.txfields ('12').TYPE      := 'D';
        l_txmsg.txfields ('12').VALUE     := V_FRDATETRANSFER ;
                    --13   N   TODATETRANSFER
        l_txmsg.txfields ('13').defname   := 'TODATETRANSFER';
        l_txmsg.txfields ('13').TYPE      := 'D';
        l_txmsg.txfields ('13').VALUE     := V_TODATETRANSFER ;
             --14   N   ROPRICE
        l_txmsg.txfields ('14').defname   := 'ROPRICE';
        l_txmsg.txfields ('14').TYPE      := 'N';
        l_txmsg.txfields ('14').VALUE     := V_ROPRICE ;
             --15   N   TVPRICE
        l_txmsg.txfields ('15').defname   := 'TVPRICE';
        l_txmsg.txfields ('15').TYPE      := 'N';
        l_txmsg.txfields ('15').VALUE     := V_TVPRICE ;
                 --20   N   STATUS
        l_txmsg.txfields ('20').defname   := 'STATUS';
        l_txmsg.txfields ('20').TYPE      := 'C';
        l_txmsg.txfields ('20').VALUE     := V_STATUS ;
                 --30   N   DESC
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').VALUE     := V_DESC ;

       BEGIN
          IF txpks_#3325.fn_batchtxprocess (l_txmsg,
                                             p_err_code,
                                             l_err_param
               ) <> systemnums.c_success
            THEN

               ROLLBACK;
               RETURN;
            END IF;
        END;


    p_err_code:=0;

  EXCEPTION
  WHEN OTHERS
   THEN

      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error('Row:'||dbms_utility.format_error_backtrace);
      plog.error(SQLERRM);


      RAISE errnums.E_SYSTEM_ERROR;
  END PR_FILE_CADTLIMP;

PROCEDURE FILLTER_SEC_BASKET (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
v_count NUMBER;
v_basketid varchar2(100);
v_symbol varchar2(100);
v_IRATIO varchar2(50);
BEGIN
    -- Kiem tra neu trung khoa secbaskettemp; Tra ve loi
    BEGIN
    SELECT basketid,symbol, count(1) INTO v_basketid,v_symbol,v_count FROM secbaskettemp
    HAVING count(1) <> 1
    GROUP BY  basketid,symbol;
        -- co 1 truong hop bi trung khoa
        p_err_code := -100407;
        p_err_message:= 'Dupplicate key of secbaskettemp!';
        DELETE FROM SECBASKETTEMP;
        RETURN;
    EXCEPTION
    WHEN no_data_found THEN
        NULL; -- OK khong bi trung khoa
    WHEN OTHERS THEN
        p_err_code := -100407;
        p_err_message:= 'Dupplicate key of secbaskettemp!';
        DELETE FROM SECBASKETTEMP;
        RETURN;
    END;

    -- Kiem tra bracketID da duoc khai bao hay chua?
    SELECT count(1)
        INTO v_count
    FROM secbaskettemp
    WHERE NOT EXISTS (SELECT basketid FROM basket WHERE basket.basketid = secbaskettemp.basketid);
    IF v_count > 0 THEN
        p_err_code := -100406;
        p_err_message:= 'Chua khai bao backetid!';
        DELETE FROM SECBASKETTEMP;
        RETURN;
    END IF;

    SELECT count(1)
        INTO v_count
    FROM secbaskettemp
    WHERE mrratiorate * mrpricerate < mrratioloan * mrpriceloan;
    IF v_count > 0 THEN
        p_err_code := -100435;
        p_err_message:= 'Ti le * Gia vay tinh tai san phai lon hon hoac bang Ti le * Gia vay tinh suc mua!';
        DELETE FROM SECBASKETTEMP;
        RETURN;
    END IF;
     -- Kiem tra ti le vay tren ro nhap vao khong duoc vuot qua ti le toi da cua UBCK
    /*begin
    SELECT count(*)
        INTO v_count
    FROM secbaskettemp;
    end;
    IF v_count > 0 THEN
        SELECT VARVALUE INTO v_IRATIO FROM SYSVAR WHERE GRNAME = 'MARGIN' AND VARNAME = 'IRATIO';
        FOR i IN (SELECT * FROM SECBASKETTEMP)
        LOOP
            IF 100 - i.mrratioloan < v_IRATIO THEN
                p_err_code := -100410;
                p_err_message:= 'Ty le ky quy Margin khong duoc thap hon ty le ky quy cua UBCK!';
                DELETE FROM SECBASKETTEMP;
                RETURN;
            END IF;
        END LOOP;
    END IF;*/
    --Cap nhat thong tin ve nguoi import
    UPDATE secbaskettemp SET TellerID=p_tlid;
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
exception
when others then
    rollback;
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END FILLTER_SEC_BASKET;

PROCEDURE FILLTER_SEC_BASKET_EDIT (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
v_count NUMBER;
v_basketid varchar2(100);
v_symbol varchar2(100);
v_IRATIO varchar2(50);
BEGIN
    -- Kiem tra neu trung khoa secbaskettemp; Tra ve loi
    BEGIN
    SELECT basketid,symbol, count(1) INTO v_basketid,v_symbol,v_count FROM secbasketedit
    HAVING count(1) <> 1
    GROUP BY  basketid,symbol;
        -- co 1 truong hop bi trung khoa
        p_err_code := -100407;
        p_err_message:= 'Dupplicate key of secbaskettemp!';
        DELETE FROM secbasketedit;
        RETURN;
    EXCEPTION
    WHEN no_data_found THEN
        NULL; -- OK khong bi trung khoa
    WHEN OTHERS THEN
        p_err_code := -100407;
        p_err_message:= 'Dupplicate key of secbaskettemp!';
        DELETE FROM secbasketedit;
        RETURN;
    END;

    -- Kiem tra bracketID da duoc khai bao hay chua?
    SELECT count(1)
        INTO v_count
    FROM secbasketedit
    WHERE NOT EXISTS (SELECT basketid FROM basket WHERE basket.basketid = secbasketedit.basketid);
    IF v_count > 0 THEN
        p_err_code := -100406;
        p_err_message:= 'Chua khai bao backetid!';
        DELETE FROM secbasketedit;
        RETURN;
    END IF;

    SELECT count(1)
        INTO v_count
    FROM secbaskettemp
    WHERE mrratiorate * mrpricerate < mrratioloan * mrpriceloan;
    IF v_count > 0 THEN
        p_err_code := -100435;
        p_err_message:= 'Ti le * Gia vay tinh tai san phai lon hon hoac bang Ti le * Gia vay tinh suc mua!';
        DELETE FROM secbasketedit;
        RETURN;
    END IF;

    --Cap nhat thong tin ve nguoi import
    UPDATE secbasketedit SET TellerID=p_tlid;

    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
exception
when others then
    rollback;
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END FILLTER_SEC_BASKET_EDIT;

PROCEDURE CAL_MARGIN_LIMIT (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
BEGIN
RETURN;
END CAL_MARGIN_LIMIT;

PROCEDURE CAL_COP_ACTION (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
v_camastid varchar2(30);
v_codeid varchar2(30);
v_symbol varchar2(30);
v_CATYPE VARCHAR2(30) ;
v_RIGHTOFRATE  VARCHAR2(30) ;
v_LEFTOFRATE  VARCHAR2(30) ;
v_OPTCODEID VARCHAR2(30) ;

BEGIN
select  symbol ,TYPE  into v_symbol , v_CATYPE  from  caschd_temp GROUP BY SYMBOL , TYPE  ;

select codeid into v_codeid  from  sbsecurities where symbol =v_symbol;



CASE

--CO TUC BANG TIEN

WHEN v_CATYPE ='010' THEN
v_camastid := '0001'||v_codeid||'000999'  ;
UPDATE CASCHD_TEMP SET CODEID =v_codeid;

FOR REC IN ( select DISTINCT camastid, CODEID , symbol,rate ,to_date(reportdate,'dd/mm/yyyy') reportdate
, to_date(actiondate,'dd/mm/yyyy') actiondate from CASCHD_TEMP)
loop
insert into CAMAST (AUTOID, CODEID, CATYPE, REPORTDATE, DUEDATE, ACTIONDATE, EXPRICE, PRICE, EXRATE, RIGHTOFFRATE, DEVIDENTRATE, DEVIDENTSHARES, SPLITRATE, INTERESTRATE, INTERESTPERIOD, STATUS, CAMASTID, DESCRIPTION, EXCODEID, PSTATUS, RATE, DELTD, TRFLIMIT, PARVALUE, ROUNDTYPE, OPTSYMBOL, OPTCODEID, TRADEDATE, LASTDATE, RETAILSHARE, RETAILDATE, FRDATERETAIL, TODATERETAIL, FRTRADEPLACE, TOTRADEPLACE, TRANSFERTIMES, FRDATETRANSFER, TODATETRANSFER, TASKCD, TOCODEID, LAST_CHANGE)
values (seq_camast.NEXTVAL, rec.codeid, '010', rec.reportdate , to_date('31-05-2010', 'dd-mm-yyyy'), rec.actiondate, 0, 0, '', '', rec.rate, '', '', '', 0, 'A',v_camastid, 'Chia co tuc bang tien,'|| rec.symbol||', ngay chot:'|| rec.reportdate||',  tyle:'||rec.rate||'%', rec.codeid, 'PN', 0, 'N', 'Y', 10000, '0', rec.symbol, '', to_date('31-05-2010', 'dd-mm-yyyy'), null, 'N', to_date('31-05-2010', 'dd-mm-yyyy'), to_date('31-05-2010', 'dd-mm-yyyy'), to_date('31-05-2010', 'dd-mm-yyyy'), '001', '001', '1', to_date('31-05-2010', 'dd-mm-yyyy'), to_date('31-05-2010', 'dd-mm-yyyy'), '', rec.codeid, '01-JUN-10 05.27.45.437000 PM');
end loop;

FOR REC IN
(
select ca.* ,  af.acctno acctno
from CASCHD_TEMP ca , cfmast cf , afmast af
where ca.afacctno = cf.custodycd and  cf.custid = af.custid
 )
loop

insert into caschd (AUTOID, CAMASTID, BALANCE, QTTY, AMT, AQTTY, AAMT, STATUS, AFACCTNO, CODEID, EXCODEID, DELTD, PSTATUS, REFCAMASTID, RETAILSHARE, DEPOSIT, REQTTY, REAQTTY, RETAILBAL, PBALANCE, PQTTY, PAAMT, COREBANK, ISCISE, DFQTTY, ISCI, ISSE, ISRO, TQTTY)
values (seq_caschd.nextval, v_camastid, rec.balance, 0, rec.amt, 0, 0, 'A', rec.acctno, rec.codeid, rec.codeid, 'N', '', 0, '', '', 0, 0, 0, 0, 0, 0, 'N', '', 0, 'N', 'N', 'N', 0.00);
end loop;

-- CO TUC BANG CO PHIEU

WHEN v_CATYPE ='011' THEN
v_camastid := '0001'||v_codeid||'000788'  ;
UPDATE CASCHD_TEMP SET CODEID =v_codeid;

FOR REC IN ( select DISTINCT camastid, CODEID , symbol,rate ,to_date(reportdate,'dd/mm/yyyy') reportdate
, to_date(actiondate,'dd/mm/yyyy') actiondate from CASCHD_TEMP)
loop
insert into CAMAST (AUTOID, CODEID, CATYPE, REPORTDATE, DUEDATE, ACTIONDATE, EXPRICE, PRICE, EXRATE, RIGHTOFFRATE, DEVIDENTRATE, DEVIDENTSHARES, SPLITRATE, INTERESTRATE, INTERESTPERIOD, STATUS, CAMASTID, DESCRIPTION, EXCODEID, PSTATUS, RATE, DELTD, TRFLIMIT, PARVALUE, ROUNDTYPE, OPTSYMBOL, OPTCODEID, TRADEDATE, LASTDATE, RETAILSHARE, RETAILDATE, FRDATERETAIL, TODATERETAIL, FRTRADEPLACE, TOTRADEPLACE, TRANSFERTIMES, FRDATETRANSFER, TODATETRANSFER, TASKCD, TOCODEID, LAST_CHANGE)
values (seq_camast.NEXTVAL, rec.codeid, '011', rec.reportdate , to_date('31-05-2010', 'dd-mm-yyyy'), rec.actiondate, 0, 0, '', '','' , rec.rate, '', '', 0, 'A', v_camastid, 'Chia co tuc bang co phieu,'|| rec.symbol||', ngay chot:'|| rec.reportdate||',  ti le'||rec.rate||'%', rec.codeid, 'PN', 0, 'N', 'Y', 10000, '0', rec.symbol, '', to_date('31-05-2010', 'dd-mm-yyyy'), null, 'N', to_date('31-05-2010', 'dd-mm-yyyy'), to_date('31-05-2010', 'dd-mm-yyyy'), to_date('31-05-2010', 'dd-mm-yyyy'), '001', '001', '1', to_date('31-05-2010', 'dd-mm-yyyy'), to_date('31-05-2010', 'dd-mm-yyyy'), '', rec.codeid, '01-JUN-10 05.27.45.437000 PM');
end loop;

begin
for rec in
(
select ca.* ,  af.acctno acctno
from CASCHD_TEMP ca , cfmast cf , afmast af
where ca.afacctno = cf.custodycd and  cf.custid = af.custid

 )
loop

insert into caschd (AUTOID, CAMASTID, BALANCE, QTTY, AMT, AQTTY, AAMT, STATUS, AFACCTNO, CODEID, EXCODEID, DELTD, PSTATUS, REFCAMASTID, RETAILSHARE, DEPOSIT, REQTTY, REAQTTY, RETAILBAL, PBALANCE, PQTTY, PAAMT, COREBANK, ISCISE, DFQTTY, ISCI, ISSE, ISRO, TQTTY)
values (seq_caschd.nextval, v_camastid, rec.balance,rec.qtty, rec.amt, 0, 0, 'A', rec.acctno, rec.codeid, rec.codeid, 'N', '', 0, '', '', 0, 0, 0, 0, 0, 0, 'N', '', 0, 'N', 'N', 'N', 0.00);

end loop;
end ;

--CO PHIEU THUONG

WHEN v_CATYPE ='021' THEN

v_camastid := '0001'||v_codeid||'000666'  ;
UPDATE CASCHD_TEMP SET CODEID =v_codeid;

BEGIN
FOR REC IN ( select DISTINCT camastid, CODEID , symbol,rate ,to_date(reportdate,'dd/mm/yyyy') reportdate
, to_date(actiondate,'dd/mm/yyyy') actiondate from CASCHD_TEMP)
loop
insert into CAMAST (AUTOID, CODEID, CATYPE, REPORTDATE, DUEDATE, ACTIONDATE, EXPRICE, PRICE, EXRATE, RIGHTOFFRATE, DEVIDENTRATE, DEVIDENTSHARES, SPLITRATE, INTERESTRATE, INTERESTPERIOD, STATUS, CAMASTID, DESCRIPTION, EXCODEID, PSTATUS, RATE, DELTD, TRFLIMIT, PARVALUE, ROUNDTYPE, OPTSYMBOL, OPTCODEID, TRADEDATE, LASTDATE, RETAILSHARE, RETAILDATE, FRDATERETAIL, TODATERETAIL, FRTRADEPLACE, TOTRADEPLACE, TRANSFERTIMES, FRDATETRANSFER, TODATETRANSFER, TASKCD, TOCODEID, LAST_CHANGE)
values (seq_camast.NEXTVAL, rec.codeid, '021', rec.reportdate , to_date('31-05-2010', 'dd-mm-yyyy'), rec.actiondate, 0, 0, '', '','' , rec.rate, '', '', 0, 'A', v_camastid, 'Co phieu thuong,'|| rec.symbol||', ngay chot:'|| rec.reportdate||',  ti le'||rec.rate||'%', rec.codeid, 'PN', 0, 'N', 'Y', 10000, '0', rec.symbol, '', to_date('31-05-2010', 'dd-mm-yyyy'), null, 'N', to_date('31-05-2010', 'dd-mm-yyyy'), to_date('31-05-2010', 'dd-mm-yyyy'), to_date('31-05-2010', 'dd-mm-yyyy'), '001', '001', '1', to_date('31-05-2010', 'dd-mm-yyyy'), to_date('31-05-2010', 'dd-mm-yyyy'), '', rec.codeid, '01-JUN-10 05.27.45.437000 PM');
end loop;
end;


begin
for rec in
(
select ca.* ,  af.acctno acctno
from CASCHD_TEMP ca , cfmast cf , afmast af
where ca.afacctno = cf.custodycd and  cf.custid = af.custid

 )
loop
insert into caschd (AUTOID, CAMASTID, BALANCE, QTTY, AMT, AQTTY, AAMT, STATUS, AFACCTNO, CODEID, EXCODEID, DELTD, PSTATUS, REFCAMASTID, RETAILSHARE, DEPOSIT, REQTTY, REAQTTY, RETAILBAL, PBALANCE, PQTTY, PAAMT, COREBANK, ISCISE, DFQTTY, ISCI, ISSE, ISRO, TQTTY)
values (seq_caschd.nextval, v_camastid, rec.balance,rec.qtty,rec.amt , 0, 0, 'A', rec.acctno, rec.codeid, rec.codeid, 'N', '', 0, '', '', 0, 0, 0, 0, 0, 0, 'N', '', 0, 'N', 'N', 'N', 0.00);
end loop;
end ;


-- QUYEN MUA

 WHEN v_CATYPE ='014' THEN
 update CASCHD_TEMP set status ='Y';

 v_camastid := '0001'||v_codeid||'000777'  ;
UPDATE CASCHD_TEMP SET CODEID =v_codeid;
v_OPTCODEID:='99'||substr(v_codeid,3);
UPDATE CASCHD_TEMP SET optCODEID = '99'||substr(v_codeid,3);
---CAMAST
UPDATE CASCHD_TEMP SET OPTCODEID =v_OPTCODEID;
SELECT   SUBSTR( RATE,INSTR(RATE,'/')+1 ) , SUBSTR( RATE,1 ,INSTR(RATE,'/')-1 )  INTO v_RIGHTOFRATE,v_LEFTOFRATE  FROM CASCHD_TEMP GROUP BY RATE;

BEGIN

FOR REC IN ( SELECT DISTINCT CAMASTID,to_date(reportdate,'dd/mm/yyyy') reportdate
, to_date(actiondate,'dd/mm/yyyy') actiondate,SYMBOL,RATE,CODEID,OPTCODEID,EXPRICE FROM CASCHD_TEMP  )
LOOP
INSERT INTO camast
(AUTOID,CODEID,CATYPE,REPORTDATE,DUEDATE,ACTIONDATE,EXPRICE,PRICE,EXRATE,RIGHTOFFRATE,DEVIDENTRATE,DEVIDENTSHARES,SPLITRATE,INTERESTRATE,INTERESTPERIOD,STATUS,CAMASTID,DESCRIPTION,EXCODEID,PSTATUS,RATE,DELTD,TRFLIMIT,PARVALUE,ROUNDTYPE,OPTSYMBOL,OPTCODEID,TRADEDATE,LASTDATE,RETAILSHARE,RETAILDATE,FRDATERETAIL,TODATERETAIL,FRTRADEPLACE,TOTRADEPLACE,TRANSFERTIMES,FRDATETRANSFER,TODATETRANSFER,TASKCD,TOCODEID,LAST_CHANGE)
VALUES
(seq_camast.NEXTVAL,rec.codeid,'014',rec.REPORTDATE,rec.ACTIONDATE,rec.ACTIONDATE,rec.EXPRICE,0,NULL,rec.rate,NULL,NULL,NULL,NULL,0,'M',v_camastid,'Quyen mua co phieu '|| rec.symbol||'DKCC '|| rec.actiondate||'Ty le '|| rec.rate|| ' gia '||rec.EXPRICE,rec.codeid,rec.symbol,0,'N','Y',10000,'0',v_symbol||'_q',rec.OPTCODEID,to_date('10/06/2010','DD/MM/RRRR'),to_date('10/06/2010','DD/MM/RRRR'),'N',to_date('10/06/2010','DD/MM/RRRR'),to_date('10/06/2010','DD/MM/RRRR'),to_date('10/06/2010','DD/MM/RRRR'),'002','001','1',to_date('10/06/2010','DD/MM/RRRR'),to_date('10/06/2010','DD/MM/RRRR'),NULL,rec.codeid,null);

END LOOP;
END;


begin
for rec in
(
select ca.*,af.acctno
from  caschd_temp ca, afmast af , cfmast cf
where ca.afacctno = cf.custodycd
and cf.custid = af.custid
and rightoffqtty =0
)
loop
INSERT INTO caschd
(AUTOID,CAMASTID,BALANCE,QTTY,AMT,AQTTY,AAMT,STATUS,AFACCTNO,CODEID,EXCODEID,DELTD,PSTATUS,REFCAMASTID,RETAILSHARE,DEPOSIT,REQTTY,REAQTTY,RETAILBAL,PBALANCE,PQTTY,PAAMT,COREBANK,ISCISE,DFQTTY,ISCI,ISSE,ISRO,TQTTY)
VALUES
(seq_caschd.nextval,v_camastid,0,0,0,0,0,'A',rec.acctno,rec.codeid,rec.optcodeid,'N',NULL,0,NULL,NULL,0,0,0,rec.balance,rec.qtty,rec.qtty*rec.EXPRICE,'N',NULL,0,'N','N','N',0);

end loop;
end;


begin
for rec in
(
select ca.*,af.acctno
from  caschd_temp ca, afmast af , cfmast cf
where ca.afacctno = cf.custodycd
and cf.custid = af.custid
and rightoffqtty >0)
loop

INSERT INTO caschd
(AUTOID,CAMASTID,BALANCE,QTTY,AMT,AQTTY,AAMT,STATUS,AFACCTNO,CODEID,EXCODEID,DELTD,PSTATUS,REFCAMASTID,RETAILSHARE,DEPOSIT,REQTTY,REAQTTY,RETAILBAL,PBALANCE,PQTTY,PAAMT,COREBANK,ISCISE,DFQTTY,ISCI,ISSE,ISRO,TQTTY)
VALUES
(seq_caschd.nextval,v_camastid,round(rec.rightoffqtty* to_number(v_LEFTOFRATE)/to_number(v_RIGHTOFRATE)),rec.rightoffqtty,0,0,rec.aamt,'M',rec.acctno,rec.codeid,rec.optcodeid,'N',NULL,0,NULL,NULL,0,0,rec.qtty+rec.rightoffqtty,rec.balance-round(rec.rightoffqtty* to_number(v_LEFTOFRATE)/to_number(v_RIGHTOFRATE)),rec.qtty-rec.rightoffqtty,(rec.qtty-rec.rightoffqtty)*rec.exprice,'N',NULL,0,'N','N','N',REC.rightoffqtty);


end loop;
end;

/*
INSERT INTO sbsecurities
(CODEID,ISSUERID,SYMBOL,SECTYPE,INVESTMENTTYPE,RISKTYPE,PARVALUE,FOREIGNRATE,STATUS,TRADEPLACE,DEPOSITORY,SECUREDRATIO,MORTAGERATIO,REPORATIO,ISSUEDATE,EXPDATE,INTPERIOD,INTRATE,HALT,SBTYPE,CAREBY,CHKRATE)
VALUES
('99'||substr(v_codeid,3),'0000'||'99'||substr(v_codeid,3),v_symbol||'_q','004','002','001',10000,49,'Y','001','001',0,0,0,NULL,NULL,0,0,'N','001','0001',0);

insert into semast
select '0001',AFACCTNO||EXCODEID,EXCODEID,afacctno,to_date('21/05/2010','DD/MM/RRRR'),NULL,to_date('21/05/2010','DD/MM/RRRR'),'A',NULL,'Y','001',0,4,0,0,0,0,0,0,0,0,0,0,0,4,4,0,0,0,0,'0001005344',to_date('21/05/2010','DD/MM/RRRR'),0,NULL,'Y',to_date('21/05/2010','DD/MM/RRRR'),0,0,0,0,0,NULL,0,null,0,0,0,0
from caschd where camastid =v_camastid;
*/

END CASE;

exception
when others then
    rollback;
    p_err_code := errnums.C_SYSTEM_ERROR;
    p_err_message:= 'System error. Invalid file format';

RETURN;
END;


PROCEDURE CAL_SECURITIES_RISK (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
BEGIN
    --backup old secbasket
    insert into SECURITIES_RISKHIST
    (CODEID,MRMAXQTTY,MRRATIORATE,MRRATIOLOAN,MRPRICERATE,MRPRICELOAN,backupdt, ISMARGINALLOW)
    select CODEID,MRMAXQTTY,MRRATIORATE,MRRATIOLOAN,MRPRICERATE,MRPRICELOAN, to_char(sysdate,'DD/MM/YYYY:HH:MI:SS') backupdt, ISMARGINALLOW
    from SECURITIES_RISK;
    delete from SECURITIES_RISK;
    insert into SECURITIES_RISK
    (CODEID,MRMAXQTTY,MRRATIORATE,MRRATIOLOAN,MRPRICERATE,MRPRICELOAN, ISMARGINALLOW)
    select B.CODEID,MRMAXQTTY,0,0,MRPRICERATE,MRPRICELOAN, ISMARGINALLOW
    from SECURITIES_RISKTEMP A, SBSECURITIES B WHERE trim(A.SYMBOL)=B.SYMBOL and a.status <>'N';

    update SECURITIES_RISKTEMP set approved='Y', aprid=p_tlid;
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
exception
when others then
    rollback;
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END;


PROCEDURE FILLTER_SECURITIES_RISK (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
BEGIN
    --Cap nhat thong tin ve nguoi import
    UPDATE securities_risktemp SET TellerID=p_tlid;
    update securities_risktemp set status ='N' where trim(symbol) not in (select symbol from sbsecurities);
    for rec in
    (
        select symbol from securities_risktemp where status<>'N'  group by symbol having count(1)>1
    )
    loop
        update securities_risktemp set status ='N' where symbol=rec.symbol;
    end loop;
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
exception
when others then
    rollback;
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END;

PROCEDURE CAL_DF_BASKET (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
v_count NUMBER;
BEGIN

    -- Kiem tra bracketID da duoc khai bao hay chua?
    SELECT count(1)
        INTO v_count
    FROM dfbaskettemp
    WHERE NOT EXISTS (SELECT basketid FROM basket WHERE basket.basketid = dfbaskettemp.basketid);
    IF v_count > 0 THEN
        p_err_code := -100406;
        p_err_message:= 'Chua khai bao backetid!';
        RETURN;
    END IF;
    --Xoa di cac dong du lieu khong hop le
     --Sua lai dfrate phai >0
     SELECT count(1)
        INTO v_count
    FROM dfbaskettemp where nvl(refprice,-1) <0 or  nvl(dfprice,-1) <0 or  nvl(triggerprice,-1) <0 or
    nvl(dfrate,-1)<=0  or nvl(irate,-1) <0 or  nvl(mrate,-1)<0 or nvl(lrate,-1)<0;
    IF v_count > 0 THEN
        p_err_code := -100800;
        p_err_message:= 'File du lieu khong hop le!';
        RETURN;
    END IF;

    /* delete from dfbaskettemp where
    nvl(refprice,-1) <0 or  nvl(dfprice,-1) <0 or  nvl(triggerprice,-1) <0 or
    nvl(dfrate,-1)<=0  or nvl(irate,-1) <0 or  nvl(mrate,-1)<0 or nvl(lrate,-1)<0;*/

     --backup old secbasket
    insert into dfbaskethist
    (autoid,basketid, symbol, refprice, dfprice, triggerprice,
       dfrate, irate, mrate, lrate,calltype, importdt,backupdt,DEALTYPE)
    select autoid,basketid, symbol, refprice, dfprice, triggerprice,
       dfrate, irate, mrate, lrate,calltype, importdt,to_char(sysdate,'DD/MM/YYYY:HH:MI:SS') backupdt,DEALTYPE
    from dfbasket where basketid  in (select basketid from dfbaskettemp);

    delete from dfbasket where basketid in (select basketid from dfbaskettemp);

    insert into dfbasket
    (autoid,basketid, symbol, refprice, dfprice, triggerprice,
       dfrate, irate, mrate, lrate,calltype, importdt,DEALTYPE)
    select SEQ_DFBASKET.NEXTVAL,temp.* from
    (select  basketid, symbol, round(avg(refprice),0), round(avg(dfprice),0), round(avg(triggerprice),0),
           round(avg(dfrate),2), round(avg(irate),2), round(avg(mrate),2), round(avg(lrate),2),max(calltype), to_char(sysdate,'DD/MM/YYYY:HH:MI:SS') importdt,DEALTYPE
        from dfbaskettemp where status <>'N'
    group by basketid, symbol,DEALTYPE) temp;


    update dfbaskettemp set approved='Y', aprid=p_tlid;
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
exception
when others then
    rollback;
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END CAL_DF_BASKET;


PROCEDURE FILLTER_DF_BASKET (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
v_count NUMBER;
BEGIN

    -- Kiem tra brasketID da duoc khai bao hay chua?
    SELECT count(1)
        INTO v_count
    FROM dfbaskettemp
    WHERE NOT EXISTS (SELECT basketid FROM basket WHERE basket.basketid = dfbaskettemp.basketid);
    IF v_count > 0 THEN
        p_err_code := -100406;
        p_err_message:= 'Chua khai bao basketid!';
        delete from dfbaskettemp;
        RETURN;
    END IF;

    --Danh dau cac dong du lieu khong hop le
    --Sua lai dfrate phai >0
    update dfbaskettemp set status='N',errmsg = 'Ty le khong hop le!' where
    nvl(refprice,-1) <0 or  nvl(dfprice,-1) <0 or  nvl(triggerprice,-1) <0 or
    nvl(dfrate,-1)<=0  or nvl(irate,-1) <0 or  nvl(mrate,-1)<0 or nvl(lrate,-1)<0;

    update dfbaskettemp set errmsg = 'Ty le khong hop le! dfrate phai > 0' where nvl(dfrate,-1)<=0 ;
     --Sua lai dfrate phai >0
    SELECT count(1)
        INTO v_count
    FROM dfbaskettemp where nvl(refprice,-1) <0 or  nvl(dfprice,-1) <0 or  nvl(triggerprice,-1) <0 or
    nvl(dfrate,-1)<=0  or nvl(irate,-1) <0 or  nvl(mrate,-1)<0 or nvl(lrate,-1)<0;
    IF v_count > 0 THEN
        p_err_code := -100800;
        p_err_message:= 'File du lieu khong hop le!';
        RETURN;
    END IF;


    --Cap nhat thong tin ve nguoi import
    UPDATE dfbaskettemp SET TellerID=p_tlid;
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
exception
when others then
    rollback;
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END FILLTER_DF_BASKET;


PROCEDURE pr_CashDepositUpload(p_tlid IN VARCHAR2, p_err_code out varchar2,p_err_param out varchar2)
 IS
   -- Enter the procedure variables here. As shown below
 v_busdate DATE;
 v_count NUMBER;
 l_txmsg               tx.msg_rectype;
 l_err_code varchar2(30);
 l_fileid varchar2(100);

BEGIN
      plog.setbeginsection(pkgctx, 'pr_CashDepositUpload');
    l_err_code:= systemnums.C_SUCCESS;
    p_err_code:= systemnums.C_SUCCESS;

    -- get CURRDATE
    SELECT to_date(varvalue,systemnums.c_date_format) INTO v_busdate
    FROM sysvar
    WHERE varname = 'CURRDATE' AND grname = 'SYSTEM';

    -- Lay ra FILE ID
    SELECT max(fileid) INTO l_fileid
    FROM tblcashdeposit
    WHERE autoid IS NULL;

    UPDATE tblcashdeposit
    SET autoid = seq_tblcashdeposit.NEXTVAL, txdate = v_busdate, tltxcd = '1195'
    WHERE fileid = l_fileid;

     -- Huy bo refnum trung lap:
     FOR rec_duplicate IN
     (
        SELECT busdate, bankid, refnum FROM (
            SELECT * FROM tblcashdeposit WHERE deltd <> 'Y'
            UNION ALL
            SELECT th.* FROM tblcashdeposithist th
            --, sysvar s
            WHERE busdate = v_busdate AND deltd <> 'Y'
            --AND s.grname = 'SYSTEM' AND s.varname = 'CURRDATE'
            --AND th.txdate = to_date (s.varvalue,systemnums.c_date_format)
            )
        GROUP BY busdate, bankid, refnum
        HAVING count(1) > 1
     )
     loop
         UPDATE tblcashdeposit
         SET deltd = 'Y',ERRORDESC = '[refnum] HAS BEEN DUPLICATED'
         WHERE busdate = v_busdate AND bankid = rec_duplicate.bankid AND refnum = rec_duplicate.refnum AND status <> 'C'
         and fileid = l_fileid;
     END loop;

     -- kiem tra cac truong mandatory va CHECK gia tri so tien.
     UPDATE tblcashdeposit
     SET deltd = 'Y', errordesc = 'data missing: ' || CASE WHEN bankid IS NULL OR bankid = '' THEN ' [bankid] IS NULL '
                                                         WHEN description IS NULL OR description = '' THEN ' [description] IS NULL '
                                                         WHEN fileid IS NULL OR fileid = '' THEN ' [fileid] IS NULL '
                                                         WHEN busdate IS NULL THEN ' [busdate] IS NULL '
                                                         WHEN amt <= 0 THEN ' [amt] < 0 '
                                                         WHEN busdate <> v_busdate THEN ' [busdate] IS NOT SYSTEM DATE'
                                                         ELSE 'UNKNOWN!' END
     WHERE (bankid IS NULL OR bankid = ''
     OR description IS NULL OR description = ''
     OR fileid IS NULL OR fileid = ''
     OR busdate IS NULL
     OR amt <= 0
     OR busdate <> v_busdate)
     AND fileid = l_fileid;

     -- Kiem tra DELETE het cac dong ko co trong glmast
     UPDATE tblcashdeposit a
     SET deltd = 'Y', errordesc = '[glmast] DOES NOT EXISTS IN SYSTEM'
     WHERE NOT EXISTS (SELECT 1 FROM glmast g,banknostro b WHERE g.acctno = trim(b.glaccount) AND g.actype = 'B' AND a.bankid = b.shortname)
     AND fileid = l_fileid;

     -- xu ly tuan tu
     FOR rec  IN
     (
         SELECT *  FROM tblcashdeposit WHERE fileid = l_fileid AND DELTD<>'Y'
     )
     LOOP

         SELECT count(1) INTO v_count FROM afmast af, cfmast cf
             WHERE cf.custid = af.custid AND cf.custodycd = rec.custodycd and af.status='A' and af.corebank='N';

         IF v_count = 0 then
             UPDATE tblcashdeposit SET deltd = 'Y', errordesc = 'data missing: afacctno not found!'
                    WHERE autoid = rec.autoid;
         ELSE
            UPDATE tblcashdeposit t1
             SET acctno = (  SELECT nvl(  af.acctno,null)
                             FROM afmast af, cfmast cf
                             WHERE cf.custid = af.custid
                             AND cf.custodycd = rec.custodycd
                             AND af.status = 'A'
                             and ROWNUM = 1)
             WHERE autoid = rec.autoid;
         END IF;
/*
         IF rec.acctno IS NULL then
             UPDATE tblcashdeposit  t1
             SET acctno = (  SELECT nvl(  af.acctno,null)
                             FROM afmast af, cfmast cf , tblcashdeposit t2
                             WHERE cf.custid = af.custid
                             AND cf.custodycd = t2.custodycd
                             AND t1.refnum = t2.refnum
                             AND af.status = 'A'
                             and ROWNUM = 1)
             WHERE autoid = rec.autoid
             and acctno is null or acctno = '';
         END IF;
*/




     END LOOP;

    -- Check trung FileID va Refnum

    select count(1) into v_count from (
    select distinct fileid from tblcashdeposit);
    if v_count>1 then
        UPDATE tblcashdeposit SET deltd = 'Y', errordesc = 'fileid: MUST BE UNIQUE';
    end if;

    COMMIT;
     --RETURN systemnums.C_SUCCESS;

     --RUN CHECK.
    FOR rec IN
    (
        SELECT t.*,b.glaccount glmast from tblcashdeposit t, banknostro b
        WHERE t.bankid = b.shortname AND t.deltd <> 'Y' AND t.status <> 'C' AND t.fileid = l_fileid
    )
    LOOP
        -- 1. Set common values
        l_txmsg.brid        := systemnums.c_ho_brid;
        l_txmsg.tlid        := systemnums.c_system_userid;
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txcompleted;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'AUTO';
        l_txmsg.busdate     := rec.busdate;
        l_txmsg.txdate      := rec.txdate;

        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
        SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
        INTO l_txmsg.wsname, l_txmsg.ipaddress
        FROM DUAL;
        l_txmsg.txfields ('02').VALUE := rec.bankid;
        l_txmsg.txfields ('03').VALUE := rec.acctno;
        l_txmsg.txfields ('06').VALUE := rec.glmast;
        l_txmsg.txfields ('10').VALUE := rec.amt;
        l_txmsg.txfields ('30').VALUE := rec.description;
        l_txmsg.txfields ('31').VALUE := rec.refnum;
        l_txmsg.txfields ('82').VALUE := rec.custodycd;
        l_txmsg.txfields ('99').VALUE := rec.autoid;
        BEGIN
             IF txpks_#1195.fn_txAppCheck(P_TXMSG=>l_txmsg, P_ERR_CODE=>l_err_code) <> systemnums.C_SUCCESS THEN
                 UPDATE tblcashdeposit
                 SET status = 'E',errordesc = l_err_code
                 WHERE autoid = rec.autoid;
                 p_err_code:= errnums.C_SYSTEM_ERROR;
             ELSE
                 UPDATE tblcashdeposit
                 SET status = 'A',errordesc = null
                 WHERE autoid = rec.autoid;
             END IF;
        EXCEPTION
        WHEN OTHERS THEN
            UPDATE tblcashdeposit
            SET status = 'E',errordesc = 'Error in process!'
            WHERE autoid = rec.autoid;
            p_err_code := errnums.C_SYSTEM_ERROR;
        END;


    END LOOP;

EXCEPTION
   WHEN OTHERS THEN
   plog.error(SQLERRM);
       ROLLBACK;
        plog.setbeginsection(pkgctx, 'pr_CashDepositUpload');
         p_err_code := errnums.C_SYSTEM_ERROR;
         p_err_param := 'SYSTEM_ERROR';
       --RETURN errnums.C_SYSTEM_ERROR;
END pr_CashDepositUpload;

----------------------BEGIN CHAUNH
PROCEDURE MAK_BLACKLISTSECURITIES (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
l_count NUMBER;
v_prinused number;
v_currdate date;
BEGIN

    -- Kiem tra trung SYMBOL.
    begin
        select count(1)
            into l_count
        from BLACKLISTSYMBOLTEMP
        having count(1) > 1
        group by trim(symbol);
    exception when others then
        l_count := 0;
    end;

    if l_count > 0 then
        -- Raise Error Duplicate SYMBOL.
        p_err_code:= '-100436';
        p_err_message:= 'Raise Error Duplicate SYMBOL!';
        delete BLACKLISTSYMBOLTEMP;
        return;
    end if;

    select to_date(varvalue,'DD/MM/RRRR') into v_currdate from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM';

    -- Kiem tra xem co ma chung khoan nao khong ton tai tren he thong khong?
    update BLACKLISTSYMBOLTEMP
    set status = 'E', errmsg = 'Symbol is not exists on system!'
    where not exists (select 1 from securities_info where trim(securities_info.symbol) = trim(BLACKLISTSYMBOLTEMP.symbol));
    --UPDATE DU LIEU
    UPDATE blacklistsymboltemp SET MKTLID = P_TLID, TXDATE = V_CURRDATE WHERE STATUS <> 'E';

    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
exception
when others then
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END MAK_BLACKLISTSECURITIES;



PROCEDURE INSERT_SYMBOLBLACKLIST (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
l_count NUMBER;
v_prinused number;
v_currdate date;
BEGIN

    select to_date(varvalue,'DD/MM/RRRR') into v_currdate from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM';
    --back up du lieu
    begin
        begin
            select count(*) into l_count from BLACKLISTSYMBOL;
        EXCEPTION when others then
            l_count:= 0;
        end;
        if l_count > 0 then
            --xoa du lieu trung lap trong qua khu
            delete from blacklistsymbolhist where expdate = effdate;
            for rec in (
                        select symbol, effdate, expdate from blacklistsymbol
                        )
            loop
                update blacklistsymbolhist set expdate = v_currdate where symbol = rec.symbol and effdate = rec.effdate; --update du lieu trung lap
            end loop;
            insert into BLACKLISTSYMBOLHIST (SYMBOL     ,
                                            MKTLID      ,
                                            MKDATE      ,
                                            APRTLID     ,
                                            APRDATE     ,
                                            APPROVED    ,
                                            EFFDATE     ,
                                            EXPDATE     ,
                                            STATUS      )
            select SYMBOL, MKTLID, MKDATE, APRTLID, APRDATE, APPROVED,EFFDATE, v_currdate,STATUS  from BLACKLISTSYMBOL
                where (symbol,effdate) not in (select symbol, effdate from blacklistsymbolhist); --chi insert du lieu khong trung lap
            --xoa du lieu hien tai
            delete from BLACKLISTSYMBOL;
        end if;
    end;
    --insert du lieu moi
    for rec in (
        select IMP.*  from BLACKLISTSYMBOLTEMP imp, securities_info se
        where upper(trim(imp.symbol))= trim(se.symbol)
    )
    loop
        insert into BLACKLISTSYMBOL (       SYMBOL     ,
                                            MKTLID      ,
                                            MKDATE      ,
                                            APRTLID     ,
                                            APRDATE     ,
                                            APPROVED    ,
                                            EFFDATE     ,
                                            STATUS
                                    )
        values (rec.symbol, REC.MKTLID, REC.TXDATE, P_TLID, v_currdate,'Y', v_currdate, 'A');
        UPDATE blacklistsymboltemp SET APRTLID = p_tlid,APRDATE = v_currdate ,APPROVED ='Y',STATUS ='A'   WHERE SYMBOL = REC.SYMBOL;
    end loop;

    --Them de xoa cac TK uu tien khi khong co ma CK backlist
    INSERT INTO afblacklistsymbollog
    SELECT a.*, SYSTIMESTAMP, 'DEL_IMP'
    FROM afblacklistsymbol a
    WHERE a.refsymbol NOT IN (SELECT b.symbol FROM blacklistsymbol b)
    ORDER BY a.refsymbol, a.afacctno;

    DELETE FROM afblacklistsymbol
    WHERE refsymbol NOT IN (SELECT b.symbol FROM blacklistsymbol b);
    --End Them de xoa cac TK uu tien khi khong co ma CK backlist

    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
exception
when others then
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END INSERT_SYMBOLBLACKLIST;

--------------END CHAUNH

PROCEDURE pr_CFSEUpload (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_param  OUT varchar2)
IS
  -- Enter the procedure variables here. As shown below
 v_busdate DATE;
 v_count NUMBER;
 l_txmsg               tx.msg_rectype;
 l_err_code varchar2(30);
 l_err_param varchar2(30);
 l_custodycd varchar(10);
 l_tmpcustodycd varchar(10);
 l_custid varchar(10);
 l_afacctno varchar(10);
 l_aftype varchar(3);
 l_citype varchar(4);
BEGIN
      plog.setbeginsection(pkgctx, 'pr_CFSEUpload');

    l_err_code:= systemnums.C_SUCCESS;
    l_err_param:= 'SYSTEM_SUCCESS';
    p_err_code:= systemnums.C_SUCCESS;

    plog.debug(pkgctx, 'BAT DAU CHAY STORE ');

    -- get CURRDATE
    SELECT to_date(varvalue,systemnums.c_date_format) INTO v_busdate
    FROM sysvar
    WHERE varname = 'CURRDATE' AND grname = 'SYSTEM';

    plog.debug(pkgctx, 'BAT DAU UPDATE TBLCFSE ');

    UPDATE tblcfse
    SET autoid = seq_tblcfse.NEXTVAL;

/*
     -- Huy bo refnum trung lap:
     FOR rec_duplicate IN
     (
        SELECT IDCODE FROM (
            SELECT * FROM tblcfse WHERE deltd <> 'Y'
            UNION ALL
            SELECT * FROM tblcfsehist WHERE deltd <> 'Y'
            )
        GROUP BY IDCODE
        HAVING count(1) > 1
     )
     loop
         UPDATE tblcfse
         SET deltd = 'Y',ERRORDESC = '[refnum] HAS BEEN DUPLICATED'
         WHERE IDCODE = rec_duplicate.IDCODE;
     END loop;
*/
       plog.debug(pkgctx, 'BAT DAU UPDATE THONG BAO LOI ');

     -- kiem tra cac truong mandatory va CHECK gia tri so chung khoan.
     UPDATE tblcfse
     SET deltd = 'Y', errordesc = 'data missing: ' ||
        CASE
            WHEN fullname IS NULL OR fullname = '' THEN ' [FULLNAME] IS NULL '
            WHEN idcode IS NULL OR idcode = '' THEN ' [IDCODE] IS NULL '
            WHEN fileid IS NULL OR fileid = '' THEN ' [FILEID] IS NULL '
            WHEN iddate IS NULL OR iddate = '' THEN ' [IDDATE] IS NULL '
            WHEN IDPLACE IS NULL OR IDPLACE = '' THEN ' [IDPLACE] IS NULL '
            WHEN IDTYPE IS NULL OR IDTYPE = '' THEN ' [IDTYPE] IS NULL '
            WHEN COUNTRY IS NULL OR COUNTRY = '' THEN ' [COUNTRY] IS NULL '
            WHEN ADDRESS IS NULL OR ADDRESS = '' THEN ' [ADDRESS] IS NULL '
            WHEN IDTYPE = '005' AND (TAXCODE IS NULL OR TAXCODE = '') THEN ' [TAXCODE] IS NULL '
            WHEN AFTYPE IS NULL OR AFTYPE = '' THEN ' [AFTYPE] IS NULL '
            WHEN BRANCH IS NULL OR AFTYPE = '' THEN ' [BRANCH] IS NULL '
            WHEN CAREBY IS NULL OR CAREBY = '' THEN ' [CAREBY] IS NULL '
            WHEN SEX IS NULL OR SEX = '' THEN ' [SEX] IS NULL '
            WHEN (EXTRACT(YEAR FROM v_busdate)- EXTRACT(YEAR FROM to_date(BIRTHDAY,'DD/MM/RRRR')) < 18) AND (IDTYPE <>'005') THEN '[BIRTHDAY] IS INVALID'
            WHEN QTTY < 0 THEN ' [amt] < 0 '
            WHEN BLOCKQTTY < 0 THEN ' [amt] < 0 '
            WHEN idtype NOT IN (SELECT CDVAL FROM ALLCODE WHERE CDNAME='IDTYPE') THEN ' [IDTYPE] DOESN''T EXIST '
            WHEN SEX NOT IN (SELECT CDVAL FROM ALLCODE WHERE CDNAME='SEX') THEN ' [SEX] DOESN''T EXIST '
            WHEN COUNTRY NOT IN (SELECT CDVAL FROM ALLCODE WHERE CDNAME='COUNTRY') THEN ' [COUNTRY] DOESN''T EXIST '
            WHEN BANKNAME IS NULL OR BANKNAME <>'' OR BANKNAME NOT IN (SELECT CDVAL FROM ALLCODE WHERE CDNAME='BANKNAME') THEN ' [BANKNAME] IS INVALID '
            --WHEN QTTYTYPE IS NULL OR QTTYTYPE <>'' OR QTTYType NOT IN (SELECT CDVAL FROM ALLCODE WHERE CDNAME='QTTYTYPE') THEN ' [QTTYTYPE] IS INVALID '
            WHEN COUNTRY = '234' AND IDTYPE = '002' THEN ' IDTYPE IS INVALID '
            --WHEN idcode in (SELECT IDCODE FROM CFMAST WHERE CUSTID NOT IN (SELECT CUSTID FROM AFMAST WHERE STATUS NOT IN ('C','N'))) THEN ' CLOSE SUB ACCOUNT FIRST! '
            WHEN TRIM(SYMBOL) NOT IN (SELECT TRIM(SYMBOL) FROM SBSECURITIES) THEN ' [SYMBOL] IS INVALID'
            WHEN TRIM(CAREBY) NOT IN (SELECT GRPID FROM TLGRPUSERS) THEN ' [CAREBY] IS INVALID'
            WHEN TRIM(FILEID) IN (SELECT FILEID FROM TBLCFSEHIST) THEN ' [FILEID] IS INVALID'
            WHEN TRIM(AFTYPE) NOT IN (SELECT TRIM(ACTYPE) FROM AFTYPE) THEN ' [AFTYPE] IS INVALID '
            WHEN TRIM(AFTYPE) NOT IN (SELECT TRIM(ACTYPE) FROM AFTYPE WHERE STATUS='Y') THEN ' [AFTYPE] IS INVALID '
            WHEN TRIM(AFTYPE) NOT IN (SELECT TRIM(ACTYPE) FROM AFTYPE WHERE APPRV_STS='A') THEN ' [AFTYPE] IS INVALID '
            WHEN TRIM(BRANCH) NOT IN (SELECT TRIM(BRID) FROM BRGRP WHERE STATUS='A') THEN ' [BRANCH] IS INVALID '
            WHEN OPNDATE IS NULL OR OPNDATE = '' THEN ' [OPNDATE] IS NULL '
            WHEN TRIM(OPNDATE) NOT IN (SELECT TRIM(SBDATE) FROM SBCLDR WHERE HOLIDAY='N' AND CLDRTYPE='000') THEN ' [OPNDATE] IS A HOLIDAY '
            WHEN TO_DATE(TRIM(OPNDATE),'DD/MM/RRRR') > TO_DATE(v_busdate,'DD/MM/RRRR') THEN ' [OPNDATE] IS IN FUTURE '
            ELSE 'UNKNOWN!'
        END
     WHERE
     idtype IS NULL OR idtype = ''
     OR fullname IS NULL OR fullname = ''
     OR idCODE IS NULL OR idCODE = ''
     OR fileid IS NULL OR fileid = ''
     OR iddate IS NULL OR iddate = ''
     OR IDPLACE IS NULL OR IDPLACE = ''
     OR SEX IS NULL OR SEX = ''
     or COUNTRY IS NULL OR COUNTRY = ''
     or ADDRESS IS NULL OR IDTYPE = ''
     OR (IDTYPE = '005' AND (TAXCODE IS NULL OR TAXCODE = ''))
     or AFTYPE IS NULL OR AFTYPE = ''
     or BRANCH IS NULL OR AFTYPE = ''
     or CAREBY IS NULL OR CAREBY = ''
     OR ((EXTRACT( YEAR FROM v_busdate)- EXTRACT( YEAR FROM to_date(BIRTHDAY,'DD/MM/RRRR')) < 18) AND IDTYPE <>'005')
     OR idtype NOT IN (SELECT CDVAL FROM ALLCODE WHERE CDNAME='IDTYPE')
     OR COUNTRY NOT IN (SELECT CDVAL FROM ALLCODE WHERE CDNAME='COUNTRY')
     OR (BANKNAME  IS NULL OR BANKNAME <>'' OR BANKNAME NOT IN (SELECT CDVAL FROM ALLCODE WHERE CDNAME='BANKNAME'))
     or SEX NOT IN (SELECT CDVAL FROM ALLCODE WHERE CDNAME='SEX')
     --OR (QTTYTYPE IS NULL OR QTTYTYPE <>'' OR QTTYType NOT IN (SELECT CDVAL FROM ALLCODE WHERE CDNAME='QTTYTYPE') )
     OR (COUNTRY = '234') AND (IDTYPE = '002')
     --OR idcode in (SELECT IDCODE FROM CFMAST WHERE CUSTID NOT IN (SELECT CUSTID FROM AFMAST WHERE STATUS NOT IN ('C','N')))
     OR TRIM(SYMBOL) NOT IN (SELECT TRIM(SYMBOL) FROM SBSECURITIES)
     OR TRIM(CAREBY) NOT IN (SELECT GRPID FROM TLGRPUSERS)
     OR TRIM(FILEID) IN (SELECT FILEID FROM TBLCFSEHIST)
     OR TRIM(AFTYPE) NOT IN (SELECT TRIM(ACTYPE) FROM AFTYPE)
     OR TRIM(AFTYPE) NOT IN (SELECT TRIM(ACTYPE) FROM AFTYPE WHERE STATUS='Y')
     OR TRIM(AFTYPE) NOT IN (SELECT TRIM(ACTYPE) FROM AFTYPE WHERE APPRV_STS='A')
     OR TRIM(BRANCH) NOT IN (SELECT TRIM(BRID) FROM BRGRP WHERE STATUS='A')
     OR OPNDATE IS NULL OR OPNDATE = ''
     OR TRIM(OPNDATE) NOT IN (SELECT TRIM(SBDATE) FROM SBCLDR WHERE HOLIDAY='N' AND CLDRTYPE='000')
     OR TO_DATE(TRIM(OPNDATE),'DD/MM/RRRR') > TO_DATE(v_busdate,'DD/MM/RRRR')
     or QTTY < 0 or BLOCKQTTY < 0
     ;

     select count(1) into v_count from TBLCFSE where DELTD='Y';

     IF V_COUNT>0 THEN
        p_err_code := -100800; --File du lieu dau vao khong hop le
        p_err_param := 'SYSTEM_ERROR';
        RETURN;
     END IF;

     -- xu ly tuan tu
     FOR rec  IN
     (
         SELECT * FROM TBLCFSE WHERE STATUS='P' AND DELTD<>'Y'
     )
     LOOP


         ---- Kiem tra IDCODE xem co trung khong, neu trung chi lam luu ky chu ko sinh trong CFMAST nua
         select count(1) into v_count from cfmast where IDCODE=trim(rec.IDCODE) and status='A';


 --- SINH SO CUSTODYCD
          SELECT decode (rec.country,'234',SUBSTR(INVACCT,1,4) || TRIM(TO_CHAR(MAX(ODR)+1,'000000')),'') into l_custodycd FROM
                      (
                      SELECT ROWNUM ODR, INVACCT
                      FROM (SELECT CUSTODYCD INVACCT FROM CFMAST
                      WHERE SUBSTR(CUSTODYCD,1,4)= (SELECT VARVALUE FROM SYSVAR WHERE VARNAME='COMPANYCD'AND GRNAME='SYSTEM') || 'C' AND TRIM(TO_CHAR(TRANSLATE(SUBSTR(CUSTODYCD,5,6),'0123456789',' '))) IS NULL
                      ORDER BY CUSTODYCD) DAT
                      WHERE TO_NUMBER(SUBSTR(INVACCT,5,6))=ROWNUM
                      ) INVTAB
                      GROUP BY SUBSTR(INVACCT,1,4);

            plog.debug(pkgctx, 'Sinh SO LUUKY, CUSTID ' || l_custodycd );

         if v_count=0 then

            ---- SINH SO CUSTID
            SELECT SUBSTR(INVACCT,1,4) || TRIM(TO_CHAR(MAX(ODR)+1,'000000'))  into l_custid FROM
                    (SELECT ROWNUM ODR, INVACCT
                    FROM (SELECT CUSTID INVACCT FROM CFMAST WHERE SUBSTR(CUSTID,1,4)= trim(rec.branch) ORDER BY CUSTID) DAT
                    WHERE TO_NUMBER(SUBSTR(INVACCT,5,6))=ROWNUM) INVTAB
                    GROUP BY SUBSTR(INVACCT,1,4);


            plog.debug(pkgctx, 'Sinh tai khoan CFMAST');

            --- MO TAI KHOAN
            INSERT INTO CFMAST (CUSTID, CUSTODYCD, FULLNAME, IDCODE, IDDATE, IDPLACE, IDTYPE, COUNTRY, ADDRESS, MOBILE, EMAIL, DESCRIPTION, TAXCODE, OPNDATE,
            CAREBY, BRID, STATUS, PROVINCE, CLASS, GRINVESTOR, INVESTRANGE, POSITION, TIMETOJOIN, STAFF, SEX, SECTOR, FOCUSTYPE ,BUSINESSTYPE,
            INVESTTYPE, EXPERIENCETYPE, INCOMERANGE, ASSETRANGE, LANGUAGE, BANKCODE, MARRIED, ISBANKING, DATEOFBIRTH,CUSTTYPE)
                    VALUES (l_custid, decode(rec.country,'234',l_custodycd,''), rec.fullname, rec.idcode, rec.iddate, rec.idplace, rec.idtype, rec.country, rec.address,
                    rec.mobile, rec.email, rec.description, rec.taxcode, rec.opndate, rec.careby,rec.branch,'A','--','001','001','001','001','001','005',rec.sex
                    ,'001','001','001','001','001','001','001','001','001','001','N',TO_DATE(rec.birthday,'DD/MM/RRRR'),'I');


            -- INSERT VAO MAINTAIN_LOG CFMAST
            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''',p_tlid,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'CUSTID','',l_custid ,'ADD',NULL,NULL);

           INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'CUSTODYCD','',l_custodycd ,'ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'FULLNAME','',rec.fullname ,'ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'IDCODE','',rec.idcode ,'ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'IDDATE','',rec.iddate ,'ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'IDPLACE','',rec.idplace ,'ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'IDTYPE','',rec.idtype ,'ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'COUNTRY','',rec.country,'ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'ADDRESS','',rec.ADDRESS ,'ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'MOBILE','',rec.MOBILE ,'ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'EMAIL','',rec.EMAIL ,'ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'DESCRIPTION','',rec.DESCRIPTION || '''','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'TAXCODE','',rec.TAXCODE ,'ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'CAREBY','',rec.CAREBY ,'ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'PROVINCE','','--','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'CLASS','','001','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'GRINVESTOR','','001','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'INVESTRANGE','','001','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'POSITION','','001','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'TIMETOJOIN','','001','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'TIMETOJOIN','','005','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'SEX','',rec.SEX ,'ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'SECTOR','','001','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'SECTOR','','001','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'FOCUSTYPE','','001','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'BUSINESSTYPE','','001','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'INVESTTYPE','','001','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'EXPERIENCETYPE','','001','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'INCOMERANGE','','001','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'ASSETRANGE','','001','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'LANGUAGE','','001','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'BANKCODE','','001','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'MARRIED','','001','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'ISBANKING','','N','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'DATEOFBIRTH','',to_date(rec.birthday,'DD/MM/RRRR'),'ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'CUSTTYPE','','I','ADD',NULL,NULL);

            --Update da sinh CFMAST
            UPDATE TBLCFSE SET GENCFMAST='Y' WHERE IDCODE=REC.IDCODE;

         end if;     --- Sinh CFMAST

            plog.debug(pkgctx, 'SINH CFMAST, MAINTAINT_LOG XONG ');

         -- Neu la khach nuoc ngoai thi chi sinh thong tin khach hang (doi xin CUSTODYCD), khong luu ky
         -- Trong truong hop co so luu ky roi thi lam tiep
         if rec.country <> '234' then
             select custodycd into l_tmpcustodycd from cfmast where idcode=trim(rec.idcode) and status='A';
             plog.debug (pkgctx, 'Kiem tra doi voi kh nuoc ngoai: ' || nvl(l_tmpcustodycd,'a'));
             exit when trim(nvl(l_tmpcustodycd,'a'))='a';
         end if;

         ---- Kiem tra truong hop da co CFMAST nhung chua co AFMAST thi moi sinh
         select count(1) into v_count from afmast where custid in (select custid from cfmast where idcode=trim(rec.IDCODE) and status='A') AND STATUS='A';

         if v_count =0 then

             SELECT AFTYPE INTO l_aftype FROM AFTYPE WHERE ACTYPE= rec.aftype;
             select custid INTO l_custid from cfmast where idcode=trim(rec.IDCODE);

             FOR recMRTYPE  IN
              (
                 SELECT * FROM MRTYPE WHERE ACTYPE IN(SELECT MRTYPE FROM AFTYPE WHERE ACTYPE= rec.aftype  )
              )
              LOOP

                ---- SINH SO AFMAST
                SELECT SUBSTR(INVACCT,1,4) || TRIM(TO_CHAR(MAX(ODR)+1,'000000')) into l_afacctno FROM
                  (SELECT ROWNUM ODR, INVACCT
                  FROM (SELECT ACCTNO INVACCT FROM AFMAST WHERE SUBSTR(ACCTNO,1,4)= trim(rec.branch) ORDER BY ACCTNO) DAT
                  WHERE TO_NUMBER(SUBSTR(INVACCT,5,6))=ROWNUM) INVTAB
                  GROUP BY SUBSTR(INVACCT,1,4);

                 --- SINH TAI KHOAN AFMAST
                 INSERT INTO AFMAST (ACTYPE,CUSTID,ACCTNO,CIACCTNO,AFTYPE,TRADEFLOOR,TRADETELEPHONE,TRADEONLINE,LANGUAGE,TRADEPHONE,
                 BANKACCTNO,BANKNAME,EMAIL,ADDRESS,STATUS,MARGINLINE,TRADELINE,
                 ADVANCELINE,REPOLINE,DEPOSITLINE,DESCRIPTION,ICCFTIED,TELELIMIT,ONLINELIMIT,CFTELELIMIT,CFONLINELIMIT,
                 TRADERATE,DEPORATE,MISCRATE,STMCYCLE,ISOTC,CONSULTANT,PISOTC,OPNDATE,FEEBASE,VIA,
                 MRIRATE,MRMRATE,MRLRATE,MRDUEDAY,MREXTDAY,MRCLAMT,MRCRLIMIT,MRCRLIMITMAX,T0AMT,ETS,BRID,CAREBY,AUTOADV,TLID,ALLOWDEBIT,TERMOFUSE)
                 VALUES(rec.aftype,l_custid,l_afacctno,l_afacctno,l_aftype,'Y','Y','Y','001',rec.mobile, rec.bankacctno ,rec.bankname, rec.email,
                 rec.address,'A',0,0,0,0,0,rec.description,'Y',0,0,0,0,0,0,0,'M','N','N','N',TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'F',
                 recMRTYPE.MRIRATE,recMRTYPE.MRMRATE,recMRTYPE.MRLRATE,recMRTYPE.DUEDAY,recMRTYPE.EXTDAY,0,recMRTYPE.MRCRLIMIT,
                 recMRTYPE.MRLMMAX,0,'N',rec.branch, rec.careby,'N', p_tlid,'Y','001');

                    plog.debug(pkgctx, 'Sinh tai khoan AFMAST' || l_afacctno );

                 -- INSERT VAO MAINTAIN_LOG AFMAST
                 INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,
                 FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
                 VALUES('AFMAST','ACCTNO = ''' || l_afacctno || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
                  p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'ACTYPE','',rec.aftype,'ADD',NULL,NULL);

                 INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,
                 FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
                 VALUES('AFMAST','ACCTNO = ''' || l_afacctno || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
                  p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'CUSTID','',l_custid,'ADD',NULL,NULL);

                 INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,
                 FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
                 VALUES('AFMAST','ACCTNO = ''' || l_afacctno || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
                  p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'ACCTNO','',l_afacctno,'ADD',NULL,NULL);

                 INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,
                 FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
                 VALUES('AFMAST','ACCTNO = ''' || l_afacctno || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
                  p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'CIACCTNO','',l_afacctno,'ADD',NULL,NULL);

                 INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,
                 FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
                 VALUES('AFMAST','ACCTNO = ''' || l_afacctno || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
                  p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'AFTYPE','',l_aftype,'ADD',NULL,NULL);

                 INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,
                 FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
                 VALUES('AFMAST','ACCTNO = ''' || l_afacctno || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
                  p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'TRADEFLOOR','','Y','ADD',NULL,NULL);

                 INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,
                 FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
                 VALUES('AFMAST','ACCTNO = ''' || l_afacctno || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
                  p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'TRADETELEPHONE','','Y','ADD',NULL,NULL);

                 INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,
                 FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
                 VALUES('AFMAST','ACCTNO = ''' || l_afacctno || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
                  p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'TRADEONLINE','','Y','ADD',NULL,NULL);

                 INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,
                 FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
                 VALUES('AFMAST','ACCTNO = ''' || l_afacctno || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
                  p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'LANGUAGE','','001','ADD',NULL,NULL);

                 INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,
                 FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
                 VALUES('AFMAST','ACCTNO = ''' || l_afacctno || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
                  p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'TRADEPHONE','',rec.mobile,'ADD',NULL,NULL);

                 INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,
                 FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
                 VALUES('AFMAST','ACCTNO = ''' || l_afacctno || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
                  p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'BANKACCTNO','',rec.bankacctno,'ADD',NULL,NULL);

                 INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,
                 FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
                 VALUES('AFMAST','ACCTNO = ''' || l_afacctno || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
                  p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'BANKNAME','', rec.bankname,'ADD',NULL,NULL);

                 INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,
                 FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
                 VALUES('AFMAST','ACCTNO = ''' || l_afacctno || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
                  p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'EMAIL','',Rec.email,'ADD',NULL,NULL);

                 INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,
                 FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
                 VALUES('AFMAST','ACCTNO = ''' || l_afacctno || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
                  p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'ADDRESS','',rec.address,'ADD',NULL,NULL);

                 INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,
                 FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
                 VALUES('AFMAST','ACCTNO = ''' || l_afacctno || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
                  p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'CAREBY','',rec.careby,'ADD',NULL,NULL);

                ----Update CUSTODYCD cho khach hang
                UPDATE CFMAST SET CUSTODYCD=l_custodycd WHERE IDCODE=rec.idcode and status='A';

                --- lay CITYPE de sinh tai khoan CI
               SELECT CITYPE into l_citype FROM AFTYPE WHERE ACTYPE = rec.aftype ;

                plog.debug(pkgctx,'Insert vao CIMAST: ' || l_afacctno);

                --- Sinh tai khoan CI
                INSERT INTO CIMAST (ACTYPE,ACCTNO,CCYCD,AFACCTNO,CUSTID,OPNDATE,CLSDATE,LASTDATE,DORMDATE,STATUS,PSTATUS,BALANCE,CRAMT,DRAMT,CRINTACR,CRINTDT,ODINTACR,ODINTDT,AVRBAL,MDEBIT,MCREDIT,AAMT,RAMT,BAMT,EMKAMT,MMARGINBAL,MARGINBAL,ICCFCD,ICCFTIED,ODLIMIT,ADINTACR,ADINTDT,FACRTRADE,FACRDEPOSITORY,FACRMISC,MINBAL,ODAMT,NAMT,FLOATAMT,HOLDBALANCE,PENDINGHOLD,PENDINGUNHOLD,COREBANK,RECEIVING,NETTING,MBLOCK,OVAMT,DUEAMT,T0ODAMT,MBALANCE,MCRINTDT,TRFAMT,LAST_CHANGE,DFODAMT,DFDEBTAMT,DFINTDEBTAMT,CIDEPOFEEACR)
                VALUES(l_citype,l_afacctno,'00',l_afacctno,l_custid,TO_DATE(v_busdate,'DD/MM/RRRR'),NULL,TO_DATE(v_busdate,'DD/MM/RRRR'),NULL,'A',NULL,0,0,0,0,TO_DATE(v_busdate,'DD/MM/RRRR'),0,TO_DATE(v_busdate,'DD/MM/RRRR'),0,0,0,0,0,0,0,0,0,NULL,'Y',0,0,NULL,0,0,0,0,0,0,0,0,0,0,'N',0,0,0,0,0,0,0,TO_DATE(v_busdate,'DD/MM/RRRR'),0,TO_DATE(v_busdate,'DD/MM/RRRR'),0,0,0,0);

                --Update da sinh AFMAST
                UPDATE TBLCFSE SET GENAFMAST='Y' WHERE IDCODE=REC.IDCODE;

             END LOOP;
         end if; ---- Kiem tra truong hop da co CFMAST nhung chua co AFMAST thi moi sinh

         ---- Sinh giao dich luu ky
        select custid INTO l_custid from cfmast where idcode=trim(rec.IDCODE) and status='A';

        FOR rec2240 IN
        (
        SELECT CF.CUSTODYCD CUSTODYCD_CF , AF.ACCTNO, SB.CODEID, A.*  FROM
               CFMAST CF, (
                        SELECT * FROM (
                        SELECT AF.* FROM AFMAST AF, AFTYPE AFT, MRTYPE MR WHERE CUSTID= l_custid AND AF.ACTYPE=AFT.ACTYPE AND
                         AFT.MRTYPE=MR.ACTYPE AND MR.MRTYPE='N'  AND AF.STATUS='A'
                        union

                        SELECT AF.* FROM AFMAST AF, AFTYPE AFT, MRTYPE MR WHERE CUSTID= l_custid AND AF.ACTYPE=AFT.ACTYPE AND
                         AFT.MRTYPE=MR.ACTYPE AND MR.MRTYPE='T'  AND AF.STATUS='A'
                        union

                        SELECT AF.* FROM AFMAST AF, AFTYPE AFT, MRTYPE MR WHERE CUSTID= l_custid AND AF.ACTYPE=AFT.ACTYPE AND
                         AFT.MRTYPE=MR.ACTYPE AND MR.MRTYPE='L'  AND AF.STATUS='A' ) B
                        WHERE ROWNUM=1
                           ) AF,
               TBLCFSE A LEFT JOIN  SBSECURITIES SB ON A.SYMBOL=SB.SYMBOL WHERE
                        A.STATUS='P' AND A.DELTD<>'Y' AND  A.IDCODE=CF.IDCODE AND CF.CUSTID=AF.CUSTID

        )
        LOOP
        plog.debug(pkgctx, 'Sinh gd luu ky'|| rec2240.ACCTNO);
             -- 1. Set common values
             l_txmsg.brid        := substr(rec2240.ACCTNO,1,4);
             l_txmsg.tlid        := systemnums.c_system_userid;
             l_txmsg.off_line    := 'N';
             l_txmsg.deltd       := txnums.c_deltd_txnormal;
             l_txmsg.txstatus    := txstatusnums.c_txcompleted;
             l_txmsg.msgsts      := '0';
             l_txmsg.ovrsts      := '0';
             l_txmsg.batchname   := 'AUTO';
             l_txmsg.busdate     := v_busdate;
             l_txmsg.txdate      := v_busdate;
             l_txmsg.tltxcd      := '2240';

            SELECT systemnums.C_BATCH_PREFIXED || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                      INTO l_txmsg.txnum
                      FROM DUAL;

             SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
             INTO l_txmsg.wsname, l_txmsg.ipaddress
             FROM DUAL;

             l_txmsg.txfields ('01').VALUE := rec2240.CODEID;
             l_txmsg.txfields ('88').VALUE := rec2240.CUSTODYCD_CF;
             l_txmsg.txfields ('02').VALUE := rec2240.ACCTNO;
             l_txmsg.txfields ('06').VALUE := rec2240.QTTY;
             l_txmsg.txfields ('07').VALUE := rec2240.BLOCKQTTY;
             IF rec2240.BLOCKQTTY >0 THEN
                l_txmsg.txfields ('08').VALUE := '002';
             ELSE
                l_txmsg.txfields ('08').VALUE := '';
             END IF;

             l_txmsg.txfields ('13').VALUE := rec2240.DATETRADE;
             l_txmsg.txfields ('03').VALUE := rec2240.ACCTNO||rec2240.CODEID;
             l_txmsg.txfields ('04').VALUE := '';
             l_txmsg.txfields ('05').VALUE := '';
             l_txmsg.txfields ('09').VALUE := 0;
             l_txmsg.txfields ('10').VALUE := to_number(rec2240.QTTY) + to_number(rec2240.BLOCKQTTY);
             l_txmsg.txfields ('11').VALUE := 0;
             l_txmsg.txfields ('12').VALUE := '';
             l_txmsg.txfields ('14').VALUE := 0;
             l_txmsg.txfields ('30').VALUE := '';
             l_txmsg.txfields ('66').VALUE := 'Gui luu ky chung khoan';
             l_txmsg.txfields ('82').VALUE := '';
             l_txmsg.txfields ('83').VALUE := '';
             l_txmsg.txfields ('84').VALUE := '';
             l_txmsg.txfields ('89').VALUE := '';
             l_txmsg.txfields ('90').VALUE := '';
             l_txmsg.txfields ('92').VALUE := rec.idcode;
             l_txmsg.txfields ('93').VALUE := '';
             l_txmsg.txfields ('95').VALUE := rec.iddate;
             l_txmsg.txfields ('96').VALUE := rec.idplace;
             -- thue quyen
             l_txmsg.txfields ('16').VALUE := 0;
             l_txmsg.txfields ('17').VALUE := 0;
             l_txmsg.txfields ('18').VALUE := 0;
             l_txmsg.txfields ('19').VALUE := 0;
             --

            plog.debug (pkgctx, 'insert 2240 qtty ' || rec2240.QTTY);

             BEGIN
                --FUNCTION fn_txProcess(p_xmlmsg in out varchar2,p_err_code in out varchar2,p_err_param out varchar2)
                  IF txpks_#2240.fn_AutoTxProcess(P_TXMSG=>l_txmsg, p_err_code=>l_err_code,p_err_param=>l_err_param) <> systemnums.C_SUCCESS THEN
                          plog.debug(pkgctx, 'update tblcfse'|| rec2240.ACCTNO);
                      UPDATE TBLCFSE
                      SET status = 'E', custid = l_custid, custodycd = rec2240.CUSTODYCD_CF, afacctno = rec2240.ACCTNO, errordesc = l_err_code
                      WHERE IDCODE = rec2240.IDCODE;
                      p_err_code:= errnums.C_SYSTEM_ERROR;
                  ELSE
                          plog.debug(pkgctx, 'update tblcfse'|| rec2240.ACCTNO);
                      UPDATE TBLCFSE
                      SET status = 'A', custid = l_custid, custodycd = rec2240.CUSTODYCD_CF, afacctno = rec2240.ACCTNO, errordesc = null
                      WHERE IDCODE = rec2240.IDCODE;
                      UPDATE TBLCFSE SET GENSEMAST='Y' WHERE IDCODE=rec2240.IDCODE;
                  END IF;
             EXCEPTION
             WHEN OTHERS THEN
                 UPDATE TBLCFSE
                 SET status = 'E',errordesc = 'Error in process!'
                 WHERE IDCODE = rec2240.IDCODE;
                 p_err_code := errnums.C_SYSTEM_ERROR;
             END;
        END LOOP;

        UPDATE TBLCFSE SET STATUS='A', DELTD='Y' WHERE IDCODE=REC.IDCODE;

    END LOOP;
    plog.debug(pkgctx, 'insert tblcfsehist');
    INSERT INTO TBLCFSEHIST SELECT * FROM TBLCFSE;

    COMMIT;

EXCEPTION
   WHEN OTHERS THEN
   plog.error(SQLERRM);
       ROLLBACK;
          plog.setendsection(pkgctx, 'pr_CFSEUpload');
         p_err_code := errnums.C_SYSTEM_ERROR;
         p_err_param := 'SYSTEM_ERROR';
       --RETURN errnums.C_SYSTEM_ERROR;
END pr_CFSEUpload;


PROCEDURE pr_Guarantee(p_tlid IN VARCHAR2, p_err_code out varchar2,p_err_param out varchar2)
 IS
   -- Enter the procedure variables here. As shown below
 v_busdate DATE;
 v_count NUMBER;
 v_T0 NUMBER;
 v_USERTYPE varchar2(20);
 l_txmsg tx.msg_rectype;
 l_err_param varchar2(30);
 l_err_code varchar2(30);
 l_fileid varchar2(100);
 v_active varchar2(1);

BEGIN
    plog.setbeginsection(pkgctx, 'pr_Guarantee');
    plog.debug(pkgctx, 'Bat dau vao pr_Guarantee');

    l_err_param:= 'SYSTEM_SUCCESS';
    l_err_code:= systemnums.C_SUCCESS;
    p_err_code:= systemnums.C_SUCCESS;

    -- get CURRDATE
    SELECT to_date(varvalue,systemnums.c_date_format) INTO v_busdate
    FROM sysvar
    WHERE varname = 'CURRDATE' AND grname = 'SYSTEM';


    -- Lay ra FILE ID
    SELECT max(fileid) INTO l_fileid
    FROM tblguar
    WHERE autoid IS NULL;

    plog.debug(pkgctx, 'Lay ra file id ' || l_fileid);

    UPDATE tblguar
    SET autoid = seq_tblguar.NEXTVAL;

        -- KIEM TRA CAC TRUONG MANDATORY VA CHECK GIA TRI SO TIEN.
     UPDATE TBLGUAR
     SET DELTD = 'Y', ERRORDESC = 'Data missing: ' || CASE WHEN TLID IS NULL OR TLID = '' THEN ' [TLID] IS NULL '
                                                         WHEN DESCRIPTION IS NULL OR DESCRIPTION = '' THEN ' [DESCRIPTION] IS NULL '
                                                         WHEN FILEID IS NULL OR FILEID = '' THEN ' [FILEID] IS NULL '
                                                         WHEN FILEID IN (SELECT FILEID FROM TBLGUARHIST) THEN ' [FILEID] IS INVALID '
                                                         WHEN TLID NOT IN (SELECT TLID FROM TLPROFILES) THEN ' [TLID] IS INVALID '
                                                         WHEN T0 <= 0 THEN ' [T0] < 0 '
                                                         WHEN T0MAX <= 0 THEN ' [T0MAX] < 0 '
                                                         ELSE 'UNKNOWN!' END
     WHERE (
     DESCRIPTION IS NULL OR DESCRIPTION = ''
     OR FILEID IS NULL OR FILEID = ''
     OR FILEID IN (SELECT FILEID FROM TBLGUARHIST)
     OR TLID NOT IN (SELECT TLID FROM TLPROFILES)
     OR T0 <= 0
     OR T0MAX <= 0
          )
     AND FILEID = L_FILEID;


     select count(1) into v_count from tblguar where DELTD='Y';

     IF V_COUNT>0 THEN
        p_err_code := -100800; --File du lieu dau vao khong hop le
        p_err_param := 'SYSTEM_ERROR';
        RETURN;
     END IF;


    plog.debug(pkgctx, 'Bat dau vong FOR');
     -- xu ly tuan tu
     FOR rec  IN
     (
         SELECT t.autoid,t.fileid,t.tlid,t.username tlusername, t.T0 T0_NEW, T.T0MAX T0MAX_NEW, t.deltd, t.errordesc, t.description, v.*  FROM tblguar t, v_userlimit v
                    WHERE t.fileid = L_FILEID AND nvl(t.DELTD,'N')<>'Y' and v.tliduser=t.tlid
         --select * from tblguar where fileid = l_fileid
     )
     LOOP

        SELECT ACTIVE into v_active  FROM TLPROFILES WHERE TLID = rec.tlid;
          if v_active <> 'Y' then
                UPDATE tblguar SET ERRORDESC = 'Data missing: [ACTIVE] is invalid' where FILEID = L_FILEID AND TLID=rec.tlid;
                exit;
          end if;

        if rec.usertype<>'BO' then

            SELECT NVL(SUM(T0),0) into v_count FROM USERLIMIT,TLPROFILES TL WHERE TLIDUSER(+) = TLID AND TL.idcode in
                (SELECT cf.idcode  idcode FROM CFMAST CF WHERE cf.username = rec.tlid);

            if v_count > 0 then
                UPDATE tblguar SET ERRORDESC = 'Invalid: ERR_CF_USER_BO_ALREADY_ALLOCATE_LIMIT' where FILEID = L_FILEID AND TLID=rec.tlid;
                exit;
            end if;

            SELECT NVL(SUM(ALLOCATELIMMIT),0) into v_count FROM USERLIMIT,TLPROFILES TL WHERE TLIDUSER(+) = TLID AND TL.idcode in
                (SELECT cf.idcode  idcode FROM CFMAST CF WHERE cf.username = rec.tlid);

            if v_count > 0 then
                UPDATE tblguar SET ERRORDESC = 'Invalid: ERR_CF_USER_BO_ALREADY_ALLOCATE_LIMIT' where FILEID = L_FILEID AND TLID=rec.tlid;
                exit;
            end if;

        end if;
/*
        plog.debug(pkgctx, 'Sinh gd 0015');
         -- 1. Set common values
         l_txmsg.brid        := substr(rec.brid,1,4);
         l_txmsg.tlid        := systemnums.c_system_userid;
         l_txmsg.off_line    := 'N';
         l_txmsg.deltd       := txnums.c_deltd_txnormal;
         l_txmsg.txstatus    := txstatusnums.c_txcompleted;
         l_txmsg.msgsts      := '0';
         l_txmsg.ovrsts      := '0';
         l_txmsg.batchname   := 'AUTO';
         l_txmsg.busdate     := v_busdate;
         l_txmsg.txdate      := v_busdate;
         l_txmsg.tltxcd      := '0015';

        SELECT systemnums.C_BATCH_PREFIXED || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                  INTO l_txmsg.txnum
                  FROM DUAL;

         SELECT SYS_CONTEXT ('USERENV', 'HOST'),
         SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
         INTO l_txmsg.wsname, l_txmsg.ipaddress
         FROM DUAL;

         l_txmsg.txfields ('03').VALUE := rec.tlid;
         l_txmsg.txfields ('04').VALUE := rec.username;
         l_txmsg.txfields ('16').VALUE := rec.T0_NEW;
         l_txmsg.txfields ('17').VALUE := rec.T0;
         l_txmsg.txfields ('18').VALUE := rec.T0MAX_NEW;
         l_txmsg.txfields ('25').VALUE := rec.usertype;
         l_txmsg.txfields ('30').VALUE := rec.description;

        BEGIN
            --FUNCTION fn_txProcess(p_xmlmsg in out varchar2,p_err_code in out varchar2,p_err_param out varchar2)
              IF txpks_#0015.fn_AutoTxProcess(P_TXMSG=>l_txmsg, p_err_code=>l_err_code,p_err_param=>l_err_param) <> systemnums.C_SUCCESS THEN
                plog.debug(pkgctx, 'update tblcfse fail');
                  UPDATE TBLGUAR SET STATUS='E',  errordesc = l_err_code WHERE fileid = L_FILEID AND DELTD<>'Y' and tlid=rec.tlid;
                  p_err_code:= errnums.C_SYSTEM_ERROR;
              ELSE
                     plog.debug(pkgctx, 'update tblcfse success');
                     UPDATE TBLGUAR SET STATUS='A',  errordesc = '' WHERE fileid = L_FILEID AND DELTD<>'Y' and tlid=rec.tlid;
              END IF;
         EXCEPTION
         WHEN OTHERS THEN
             UPDATE TBLGUAR SET STATUS='E',  errordesc = 'Error in process!' WHERE fileid = L_FILEID AND DELTD<>'Y' and tlid=rec.tlid;
             p_err_code := errnums.C_SYSTEM_ERROR;
         END;
*/

     END LOOP;


    COMMIT;
     --RETURN systemnums.C_SUCCESS;


EXCEPTION
   WHEN OTHERS THEN
   plog.error(SQLERRM);
       ROLLBACK;
        plog.setbeginsection(pkgctx, 'pr_Guarantee');
         p_err_code := errnums.C_SYSTEM_ERROR;
         p_err_param := 'SYSTEM_ERROR';
       --RETURN errnums.C_SYSTEM_ERROR;
END pr_Guarantee;

PROCEDURE pr_T0Limit_Import(p_tlid IN VARCHAR2, p_err_code out varchar2,p_err_param out varchar2)
is
l_advanceline number(20,0);
begin
    p_err_param:= 'SYSTEM_SUCCESS';
    p_err_code:= systemnums.C_SUCCESS;

    update t0limit_import
    set autoid= seq_t0limit_import.nextval;

    -- Cap nhat gia tri T0limit hien tai vao ban t0limit_import
    update t0limit_import
    set (status, errmsg) = (select case when status <> 'A' then  'E' else 'P' end,case when status <> 'A' then  'CF Status is not valid!' else null end  from cfmast where t0limit_import.custodycd = cfmast.custodycd)
    where exists (select 1 from cfmast where t0limit_import.custodycd = cfmast.custodycd);
    -- Tong han muc bao lanh da cap cho tieu khoan.

    for rec in
    (
        select * from t0limit_import where status = 'P'
    )
    loop
        update t0limit_import
        set status ='E' , errmsg = 'Contract was not found!'
        where not exists (select 1 from cfmast where cfmast.custodycd = t0limit_import.custodycd and contractchk ='Y');

        select sum(advanceline) into l_advanceline from afmast where custid = rec.custodycd;
        if l_advanceline > rec.t0limit then
            update t0limit_import
            set status ='E' , errmsg = 'Over total AF limited!'
            where autoid = rec.autoid;
        end if;
    end loop;
    update t0limit_import
    set status = 'A'
    where status = 'P';

exception when others then
   plog.error(SQLERRM);
       ROLLBACK;
        plog.setbeginsection(pkgctx, 'pr_Guarantee');
         p_err_code := errnums.C_SYSTEM_ERROR;
         p_err_param := 'SYSTEM_ERROR';
end pr_T0Limit_Import;


PROCEDURE pr_T0AFLimit_Import(p_tlid IN VARCHAR2, p_err_code out varchar2,p_err_param out varchar2)
is
l_advanceline number(20,0);
l_t0loanlimit number(20,0);
l_isstopadv       varchar2(10);
begin
    p_err_param:= 'SYSTEM_SUCCESS';
    p_err_code:= systemnums.C_SUCCESS;
    l_isstopadv := cspks_system.fn_get_sysvar('MARGIN','ISSTOPADV');
    update t0aflimit_import
    set autoid= seq_t0aflimit_import.nextval;

    -- Cap nhat gia tri T0limit hien tai vao ban t0limit_import
    update t0aflimit_import
    set (status, errmsg) = (select case when status <> 'A' then  'E' else 'P' end,case when status <> 'A' then  'CF Status is not valid!' else null end  from afmast where t0aflimit_import.AFACCTNO = afmast.acctno)
    where exists (select 1 from afmast where t0aflimit_import.afacctno = afmast.acctno);
    -- Tong han muc bao lanh da cap cho tieu khoan.

    update t0aflimit_import
    set status = 'E', errmsg = 'Han muc cap phai lon hon 0!'
    where t0limit = 0;
    for rec in
    (
        select * from t0aflimit_import where status = 'P'
    )
    loop
        update t0aflimit_import
        set status ='E' , errmsg = 'Contract was not found!'
        where not exists (select 1 from afmast where afmast.acctno = t0aflimit_import.afacctno);


        select max(t0loanlimit), sum(advanceline) into l_t0loanlimit, l_advanceline from afmast af, cfmast cf where af.custid = cf.custid
        and cf.custid in (select custid from afmast where acctno = rec.afacctno)
        group by cf.custid;

        if l_t0loanlimit < l_advanceline + rec.t0limit then
            update t0aflimit_import
            set status ='E' , errmsg = 'Over total AF limited!'
            where autoid = rec.autoid;
        end if;
    end loop;
    --check trang thai cac mon, neu khong thoa man dieu kien lam 1810 se dat trang thai E
    for chk in
    (

        SELECT A.*, NVL(T0AF.AFT0USED,0) AFT0USED,NVL(T0.CUSTT0USED,0) CUSTT0USED,LEAST (A.T0CAL - A.ADVANCELINE ,A.T0LOANLIMIT - NVL(T0.CUSTT0USED,0)) T0REAL
            ,A.T0LOANLIMIT - NVL(T0.CUSTT0USED,0) CUSTT0REMAIN
            ,NVL(URLT.T0,0) - NVL(UFLT.T0ACCLIMIT,0) URT0LIMITREMAIN
            ,A.T0CAL - A.ADVANCELINE T0REMAIN, 0 T0OVRQ, IMP.T0LIMIT T0AMT
        FROM (SELECT CF.CUSTID, CF.CUSTODYCD, AF.ACCTNO,CF.FULLNAME,CF.T0LOANRATE, AF.ADVANCELINE, CF.MRLOANLIMIT, CF.T0LOANLIMIT,AF.CAREBY, AF.ACTYPE, CF.CONTRACTCHK
            ,NVL((CI.BALANCE - NVL(V_GETBUY.SECUREAMT,0)) + decode(l_isstopadv,'Y',0,NVL(adv.avladvance,0)) + V_GETSEC.SENAVAMT - (NVL(LN.MARGINAMT,0) + NVL(LN.T0AMT,0)),0) NAVAMT
            ,NVL(V_GETSEC.SELIQAMT,0) SELIQAMT, NVL(LN.MARGINAMT,0) + NVL(LN.T0AMT,0) TOTALLOAN
            , SETOTAL + (CI.BALANCE - NVL(V_GETBUY.SECUREAMT,0)) + decode(l_isstopadv,'Y',0,NVL(adv.avladvance,0)) SETOTAL
            ,ROUND(LEAST (NVL((CI.BALANCE - NVL(V_GETBUY.SECUREAMT,0)) + decode(l_isstopadv,'Y',0,NVL(adv.avladvance,0)) + V_GETSEC.SENAVAMT - (NVL(LN.MARGINAMT,0) + NVL(LN.T0AMT,0)),0) * CF.T0LOANRATE /100, NVL(V_GETSEC.SELIQAMT,0) )) T0CAL
            ,GREATEST(0, NVL(NVL(LN.T0AMT,0) - NVL(CI.BALANCE +  NVL(V_GETBUY.SECUREAMT,0) + decode(l_isstopadv,'Y',0,NVL(adv.avladvance,0)),0),0)) T0DEB
            ,BUF.MARGINRATE
            FROM CFMAST CF, CIMAST CI, AFMAST AF,
                (SELECT SUM(AAMT) AAMT,SUM(DEPOAMT) AVLADVANCE,SUM(PAIDAMT) PAIDAMT, SUM(ADVAMT) ADVANCEAMOUNT,AFACCTNO FROM V_GETACCOUNTAVLADVANCE GROUP BY AFACCTNO) ADV
                ,( SELECT TRFACCTNO, TRUNC(SUM(PRINNML+PRINOVD+INTNMLACR+INTDUE+INTOVDACR+INTNMLOVD+FEEINTNMLACR+FEEINTDUE+FEEINTOVDACR+FEEINTNMLOVD),0) MARGINAMT,
                             TRUNC(SUM(OPRINNML+OPRINOVD+OINTNMLACR+OINTDUE+OINTOVDACR+OINTNMLOVD),0) T0AMT,
                             TRUNC(SUM(PRINOVD+INTOVDACR+INTNMLOVD+FEEINTOVDACR+FEEINTNMLOVD + NVL(LS.DUEAMT,0) + INTDUE + FEEINTDUE),0) MARGINOVDAMT,
                             TRUNC(SUM(OPRINOVD+OINTOVDACR+OINTNMLOVD),0) T0OVDAMT
                    FROM LNMAST LN, LNTYPE LNT,
                            (SELECT ACCTNO, SUM(NML) DUEAMT FROM LNSCHD, (SELECT * FROM SYSVAR WHERE VARNAME = 'CURRDATE' AND GRNAME = 'SYSTEM') SY
                             WHERE REFTYPE = 'P' AND OVERDUEDATE = TO_DATE(VARVALUE,'DD/MM/RRRR') GROUP BY ACCTNO) LS
                    WHERE FTYPE = 'AF' AND LN.ACTYPE = LNT.ACTYPE AND LN.ACCTNO = LS.ACCTNO(+)
                    GROUP BY LN.TRFACCTNO
                ) LN
                , V_GETBUYORDERINFO V_GETBUY
                , V_GETSECMARGININFO_ALL V_GETSEC
                , BUF_CI_ACCOUNT BUF
            WHERE AF.ACCTNO = CI.ACCTNO
                AND AF.CUSTID = CF.CUSTID (+)
                AND AF.ACCTNO = ADV.AFACCTNO (+)
                AND AF.ACCTNO = V_GETBUY.AFACCTNO (+)
                AND AF.ACCTNO = V_GETSEC.AFACCTNO (+)
                AND AF.ACCTNO = LN.TRFACCTNO (+)
                AND AF.ACCTNO = BUF.AFACCTNO(+)
                --AND CF.CONTRACTCHK = 'Y'
            ) A
        ,(SELECT CUSTID, SUM(ADVANCELINE) TOTALADVLINE FROM AFMAST GROUP BY CUSTID) V_T0
        , (SELECT SUM(ACCLIMIT) CUSTT0USED, AF.CUSTID FROM USERAFLIMIT US, AFMAST AF WHERE AF.ACCTNO = US.ACCTNO AND US.TYPERECEIVE = 'T0' GROUP BY CUSTID) T0
        , (SELECT SUM(ACCLIMIT) AFT0USED, ACCTNO FROM USERAFLIMIT US WHERE US.TYPERECEIVE = 'T0' GROUP BY ACCTNO) T0AF
        , (SELECT TLIDUSER,ALLOCATELIMMIT,USEDLIMMIT,ACCTLIMIT,T0,T0MAX FROM USERLIMIT WHERE TLIDUSER = p_tlid) URLT
        ,(SELECT TLIDUSER,SUM(DECODE(TYPERECEIVE,'T0',ACCLIMIT, 0)) T0ACCLIMIT,SUM(DECODE(TYPERECEIVE,'MR',ACCLIMIT, 0)) MRACCLIMIT  FROM USERAFLIMIT WHERE TYPEALLOCATE = 'Flex' AND TLIDUSER = p_tlid GROUP BY TLIDUSER
        ) UFLT
        , T0AFLIMIT_IMPORT IMP
        WHERE A.CUSTID = V_T0.CUSTID (+)
        AND A.CUSTID = T0.CUSTID (+)
        AND A.ACCTNO = T0AF.ACCTNO(+)
        AND A.T0LOANRATE >=0 AND A.ACCTNO = IMP.AFACCTNO AND IMP.STATUS = 'P'
    )
    loop
        if chk.CUSTT0REMAIN < chk.t0amt then
            update t0aflimit_import set status = 'E', errmsg = 'Vuot qua han muc cap con lai cua KH!' where afacctno = chk.acctno;
        elsif chk.URT0LIMITREMAIN < chk.t0amt then
            update t0aflimit_import set status = 'E', errmsg = 'Vuot qua han muc cap con lai cua User!' where afacctno = chk.acctno;
        elsif chk.CONTRACTCHK <> 'Y' then
            update t0aflimit_import set status = 'E', errmsg = 'Chua ky hop dong bao lanh' where afacctno = chk.acctno;
        end if;
    end loop;
    --end check
    update t0aflimit_import
    set status = 'A'
    where status = 'P';

exception when others then
   plog.error(SQLERRM);
       ROLLBACK;
        plog.setbeginsection(pkgctx, 'pr_Guarantee');
         p_err_code := errnums.C_SYSTEM_ERROR;
         p_err_param := 'SYSTEM_ERROR';
end pr_T0AFLimit_Import;



PROCEDURE pr_trfstock(p_tlid IN VARCHAR2, p_err_code out varchar2,p_err_param out varchar2)
 IS
   -- Enter the procedure variables here. As shown below
 v_busdate DATE;
 v_count NUMBER;
 v_codeid varchar2(6);
 l_txmsg tx.msg_rectype;
 l_err_param varchar2(30);
 l_err_code varchar2(30);
 l_fileid varchar2(100);


BEGIN
    plog.setbeginsection(pkgctx, 'pr_trfstock');
    plog.debug(pkgctx, 'Bat dau vao pr_trfstock');

    l_err_param:= 'SYSTEM_SUCCESS';
    l_err_code:= systemnums.C_SUCCESS;
    p_err_code:= systemnums.C_SUCCESS;

    -- get CURRDATE
    SELECT to_date(varvalue,systemnums.c_date_format) INTO v_busdate
    FROM sysvar
    WHERE varname = 'CURRDATE' AND grname = 'SYSTEM';


    -- Lay ra FILE ID
    SELECT max(fileid) INTO l_fileid
    FROM TBLTRFSTOCK
    WHERE autoid IS NULL;

    plog.debug(pkgctx, 'Lay ra file id ' || l_fileid);

    UPDATE TBLTRFSTOCK
    SET autoid = seq_TBLTRFSTOCK.NEXTVAL;

        -- KIEM TRA CAC TRUONG MANDATORY VA CHECK GIA TRI SO TIEN.
     UPDATE TBLTRFSTOCK
     SET DELTD = 'Y', ERRORDESC = 'Data missing: ' || CASE WHEN DESCRIPTION IS NULL OR DESCRIPTION = '' THEN ' [DESCRIPTION] IS NULL '
                                                         WHEN AFACCTNO IS NULL OR AFACCTNO = '' THEN ' [AFACCTNO] IS NULL '
                                                         WHEN AFACCTNO2 IS NULL OR AFACCTNO2 = '' THEN ' [AFACCTNO2] IS NULL '
                                                         WHEN AFACCTNO NOT IN (SELECT ACCTNO FROM AFMAST WHERE STATUS IN ('A','N')) THEN ' [AFACCTNO] IS INVALID '
                                                         WHEN AFACCTNO2 NOT IN (SELECT ACCTNO FROM AFMAST WHERE STATUS IN ('A','N')) THEN ' [AFACCTNO2] IS INVALID '
                                                         WHEN SYMBOL NOT IN (SELECT SYMBOL FROM SECURITIES_INFO) THEN '[SYMBOL] IS INVALID'
                                                         WHEN FILEID IS NULL OR FILEID = '' THEN ' [FILEID] IS NULL '
                                                         WHEN FILEID IN (SELECT FILEID FROM TBLTRFSTOCKHIST) THEN ' [FILEID] IS INVALID '
                                                         WHEN QTTY <= 0 THEN ' [QTTY] MUST BE > 0 '
                                                         ELSE 'UNKNOWN!' END
     WHERE (
     DESCRIPTION IS NULL OR DESCRIPTION = ''
     OR FILEID IS NULL OR FILEID = ''
     OR FILEID IN (SELECT FILEID FROM TBLTRFSTOCKHIST)
     OR AFACCTNO IS NULL OR AFACCTNO = ''
     OR SYMBOL NOT IN (SELECT SYMBOL FROM SECURITIES_INFO)
     OR AFACCTNO2 IS NULL OR AFACCTNO2 = ''
     OR AFACCTNO NOT IN (SELECT ACCTNO FROM AFMAST WHERE STATUS IN ('A','N'))
     OR AFACCTNO2 NOT IN (SELECT ACCTNO FROM AFMAST WHERE STATUS IN ('A','N'))
     OR QTTY <= 0
          )
     AND FILEID = L_FILEID;


     select count(1) into v_count from TBLTRFSTOCK where DELTD='Y';

     IF V_COUNT>0 THEN
        p_err_code := -100800; --File du lieu dau vao khong hop le
        p_err_param := 'SYSTEM_ERROR';
        RETURN;
     END IF;


    plog.debug(pkgctx, 'Bat dau vong FOR');
     -- xu ly tuan tu
     FOR rec  IN
     (
         SELECT * FROM TBLTRFSTOCK WHERE DELTD<>'Y' AND FILEID=l_fileid
     )
     LOOP

        plog.debug(pkgctx, 'Sinh gd 2242');
         -- 1. Set common values
         l_txmsg.brid        := substr(rec.afacctno,1,4);
         l_txmsg.tlid        := systemnums.c_system_userid;
         l_txmsg.off_line    := 'N';
         l_txmsg.deltd       := txnums.c_deltd_txnormal;
         l_txmsg.txstatus    := txstatusnums.c_txcompleted;
         l_txmsg.msgsts      := '0';
         l_txmsg.ovrsts      := '0';
         l_txmsg.batchname   := 'AUTO';
         l_txmsg.busdate     := v_busdate;
         l_txmsg.txdate      := v_busdate;
         l_txmsg.tltxcd      := '2242';

        SELECT systemnums.C_BATCH_PREFIXED || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                  INTO l_txmsg.txnum
                  FROM DUAL;

         SELECT SYS_CONTEXT ('USERENV', 'HOST'),
         SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
         INTO l_txmsg.wsname, l_txmsg.ipaddress
         FROM DUAL;


        select codeid into v_codeid from sbsecurities where symbol=rec.symbol;

         l_txmsg.txfields ('01').VALUE := v_codeid;
         l_txmsg.txfields ('02').VALUE := rec.afacctno;
         l_txmsg.txfields ('03').VALUE := rec.afacctno||v_codeid;
         l_txmsg.txfields ('04').VALUE := rec.afacctno2;
         l_txmsg.txfields ('05').VALUE := rec.afacctno2||v_codeid;
         l_txmsg.txfields ('06').VALUE := 0;
         l_txmsg.txfields ('09').VALUE := 0;
         l_txmsg.txfields ('10').VALUE := rec.qtty;
         l_txmsg.txfields ('11').VALUE := 10000;
         l_txmsg.txfields ('12').VALUE := rec.qtty;
         l_txmsg.txfields ('13').VALUE := 0;
         l_txmsg.txfields ('14').VALUE := '001';
         l_txmsg.txfields ('15').VALUE := 0;
         l_txmsg.txfields ('17').VALUE := 0;
         l_txmsg.txfields ('18').VALUE := 0;
         l_txmsg.txfields ('19').VALUE := 0;
         l_txmsg.txfields ('20').VALUE := 0;
         l_txmsg.txfields ('31').VALUE := '';

         l_txmsg.txfields ('30').VALUE := rec.description;

        BEGIN
        /*
            --FUNCTION fn_txProcess(p_xmlmsg in out varchar2,p_err_code in out varchar2,p_err_param out varchar2)
              IF txpks_#0015.fn_AutoTxProcess(P_TXMSG=>l_txmsg, p_err_code=>l_err_code,p_err_param=>l_err_param) <> systemnums.C_SUCCESS THEN
                plog.debug(pkgctx, 'update tblcfse fail');
                  UPDATE TBLGUAR SET STATUS='E',  errordesc = l_err_code WHERE fileid = L_FILEID AND DELTD<>'Y' and tlid=rec.tlid;
                  p_err_code:= errnums.C_SYSTEM_ERROR;
              ELSE
                     plog.debug(pkgctx, 'update tblcfse success');
                     UPDATE TBLGUAR SET STATUS='A',  errordesc = '' WHERE fileid = L_FILEID AND DELTD<>'Y' and tlid=rec.tlid;
              END IF;
         EXCEPTION
         WHEN OTHERS THEN
             UPDATE TBLGUAR SET STATUS='E',  errordesc = 'Error in process!' WHERE fileid = L_FILEID AND DELTD<>'Y' and tlid=rec.tlid;
             p_err_code := errnums.C_SYSTEM_ERROR;
         */
         select codeid into v_codeid from sbsecurities where symbol=rec.symbol;
         END;


     END LOOP;


    COMMIT;
     --RETURN systemnums.C_SUCCESS;


EXCEPTION
   WHEN OTHERS THEN
   plog.error(SQLERRM);
       ROLLBACK;
        plog.setbeginsection(pkgctx, 'pr_trfstock');
         p_err_code := errnums.C_SYSTEM_ERROR;
         p_err_param := 'SYSTEM_ERROR';
       --RETURN errnums.C_SYSTEM_ERROR;
END pr_trfstock;





PROCEDURE CAL_OTHERCIACCTNO_ACTION (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
v_count NUMBER;
v_COMPANYCD varchar2(100);
v_symbol varchar2(100);
BEGIN
    v_COMPANYCD:=cspks_system.fn_get_sysvar ('SYSTEM', 'COMPANYCD');
    select count(1) into v_count from OTHERCIACCTNO_TEMP where substr(custodycd,1,3) =v_COMPANYCD;
    if v_count>0 then
        p_err_code := -100804;
        p_err_message:= 'Cac tai khoan phai luu ky noi khac!';
        delete from OTHERCIACCTNO_TEMP;
    end if;
    select count(1) into v_count from OTHERCIACCTNO_TEMP where custodycd not in (select custodycd from cfmast where status ='A');
    if v_count>0 then
        p_err_code := -100805;
        p_err_message:= 'Cac tai khoan import phai active trong he thong!';
        delete from OTHERCIACCTNO_TEMP;
    end if;
    for rec in
    (
        select ci.acctno, t.amount
        from OTHERCIACCTNO_TEMP t, cfmast cf, cimast ci
        where t.custodycd= cf.custodycd and cf.custid = ci.custid
    )
    loop
        update afmast set advanceline = rec.amount where acctno = rec.acctno;
        --1.5.7.3 MSBS-1936 dong bo FO
        INSERT INTO t_fo_event (AUTOID, TXNUM, TXDATE, ACCTNO, TLTXCD,LOGTIME,PROCESSTIME,PROCESS,ERRCODE,ERRMSG,NVALUE,CVALUE)
        SELECT seq_fo_event.NEXTVAL, NULL, NULL, rec.acctno,'OPNACCT',systimestamp,systimestamp,'N','0',NULL, NULL, NULL
            FROM DUAL;
        COMMIT;
        --1.5.7.3 MSBS-1936
    end loop;

    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
exception
when others then
    rollback;
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END CAL_OTHERCIACCTNO_ACTION;

PROCEDURE CAL_OTHERSEACCTNO_ACTION (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
v_count NUMBER;
v_COMPANYCD varchar2(100);
v_symbol varchar2(100);
v_currdate date;
v_strMsg    VARCHAR2(4000);

BEGIN
    v_COMPANYCD:=cspks_system.fn_get_sysvar ('SYSTEM', 'COMPANYCD');
    v_currdate:= to_date (cspks_system.fn_get_sysvar ('SYSTEM', 'CURRDATE'), 'dd/mm/yyyy');
    select count(1) into v_count from OTHERSEACCTNO_TEMP where substr(custodycd,1,3) =v_COMPANYCD;
    if v_count>0 then
        p_err_code := -100804;
        p_err_message:= 'Cac tai khoan phai luu ky noi khac!';
        delete from OTHERSEACCTNO_TEMP;
    end if;
    select count(1) into v_count from OTHERSEACCTNO_TEMP where custodycd not in (select custodycd from cfmast where status ='A');
    if v_count>0 then
        p_err_code := -100805;
        p_err_message:= 'Cac tai khoan import phai active trong he thong!';
        delete from OTHERSEACCTNO_TEMP;
    end if;
    select count(1) into v_count from OTHERSEACCTNO_TEMP where symbol not in (select symbol from sbsecurities);
    if v_count>0 then
        p_err_code := -100806;
        p_err_message:= 'Ma chung khoan phai ton tai trong he thong!';
        delete from OTHERSEACCTNO_TEMP;
    end if;

    for rec in
    (
        select af.acctno, sb.codeid, t.quantity , typ.setype , cf.custid
        from OTHERSEACCTNO_TEMP t, cfmast cf, afmast af,sbsecurities sb , aftype typ
        where t.custodycd= cf.custodycd and cf.custid = af.custid
            and sb.symbol = t.symbol and af.actype = typ.actype
    )
    loop
        --Kiem tra neu khong co tai khoan chung khoan thi tu dong mo
        select count(1) into v_count from semast where afacctno= rec.acctno and codeid = rec.codeid;

        if v_count <=0 then
            --Mo tai khoan chung khoan
            INSERT INTO semast
                     (actype, custid, acctno,
                      codeid,
                      afacctno, opndate, lastdate,
                      costdt, tbaldt, status, irtied, ircd, costprice, trade,
                      mortage, margin, netting, standing, withdraw, deposit,
                      loan
                     )
              VALUES (rec.setype, rec.custid, rec.acctno || rec.codeid,
                      rec.codeid,
                      rec.acctno, v_currdate, v_currdate,
                      v_currdate, v_currdate, 'A', 'Y', '000', 0, 0,
                      0, 0, 0, 0, 0, 0,
                      0
                     );
        end if;
        update semast set trade = rec.quantity where afacctno = rec.acctno and codeid = rec.codeid;
        --1.5.7.3 MSBS-1936 dong bo FO
        SELECT symbol INTO v_symbol FROM sbsecurities WHERE codeid = rec.codeid;
        v_strMsg := '{"msgtype": "tx5100", "txnum" : "'||seq_fo_logcallws.NEXTVAL||'", "txdate" : "'||to_char(v_currdate,'dd/mm/rrrr')||'", "action" : "A", "tlxtcd" : "2287","detail":[{"msgtype" : "tx5005", "acctno" : "'||rec.acctno||'", "symbol" : "'||v_symbol||'", "qtty" : '||rec.quantity||', "doc" : "U" }]}';
        INSERT INTO t_fo_logcallws(id , tltxcd , acctno, strmsg , logtime)
                           VALUES(seq_fo_logcallws.NEXTVAL, '2287IMP', rec.acctno, v_strMsg, SYSTIMESTAMP);
        COMMIT;
        --Call ws
        IF v_strMsg IS NOT NULL then
            PCK_SYN2FO.PRC_CALLWEBSERVICE(pv_StrMessage => v_strMsg,
                                          v_errcode     => p_err_code,
                                          v_errmsg      => p_err_message,
                                          v_type        => 'BO');
        plog.error(pkgctx, 'CAL_OTHERSEACCTNO_ACTION:'  || rec.acctno || ' Error: '||p_err_code);
        END IF;
        --1.5.7.3 MSBS-1936 dong bo FO
    end loop;

    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
exception
when others then
    rollback;
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END CAL_OTHERSEACCTNO_ACTION;


PROCEDURE FILLTER_OTHERCIACCTNO_ACTION (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
v_count NUMBER;
v_COMPANYCD varchar2(100);
v_symbol varchar2(100);
BEGIN
    v_COMPANYCD:=cspks_system.fn_get_sysvar ('SYSTEM', 'COMPANYCD');
    select count(1) into v_count from OTHERCIACCTNO_TEMP where substr(custodycd,1,3) =v_COMPANYCD;
    if v_count>0 then
        p_err_code := -100804;
        p_err_message:= 'Cac tai khoan phai luu ky noi khac!';
        delete from OTHERCIACCTNO_TEMP;
        return;
    end if;
    select count(1) into v_count from OTHERCIACCTNO_TEMP where custodycd not in (select custodycd from cfmast where status ='A');
    if v_count>0 then
        p_err_code := -100805;
        p_err_message:= 'Cac tai khoan import phai active trong he thong!';
        delete from OTHERCIACCTNO_TEMP;
        return;
    end if;
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
exception
when others then
    rollback;
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END FILLTER_OTHERCIACCTNO_ACTION;

PROCEDURE FILLTER_OTHERSEACCTNO_ACTION (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
v_count NUMBER;
v_COMPANYCD varchar2(100);
v_symbol varchar2(100);
v_currdate date;
BEGIN
    v_COMPANYCD:=cspks_system.fn_get_sysvar ('SYSTEM', 'COMPANYCD');
    v_currdate:= to_date (cspks_system.fn_get_sysvar ('SYSTEM', 'CURRDATE'), 'dd/mm/yyyy');
    select count(1) into v_count from OTHERSEACCTNO_TEMP where substr(custodycd,1,3) =v_COMPANYCD;
    if v_count>0 then
        p_err_code := -100804;
        p_err_message:= 'Cac tai khoan phai luu ky noi khac!';
        delete from OTHERSEACCTNO_TEMP;
        return;
    end if;
    select count(1) into v_count from OTHERSEACCTNO_TEMP where custodycd not in (select custodycd from cfmast where status ='A');
    if v_count>0 then
        p_err_code := -100805;
        p_err_message:= 'Cac tai khoan import phai active trong he thong!';
        delete from OTHERSEACCTNO_TEMP;
        return;
    end if;
    select count(1) into v_count from OTHERSEACCTNO_TEMP where symbol not in (select symbol from sbsecurities);
    if v_count>0 then
        p_err_code := -100806;
        p_err_message:= 'Ma chung khoan phai ton tai trong he thong!';
        delete from OTHERSEACCTNO_TEMP;
        return;
    end if;
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
exception
when others then
    rollback;
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END FILLTER_OTHERSEACCTNO_ACTION;



PROCEDURE PR_PRSYSTEM_UPLOAD (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
v_count NUMBER;
BEGIN
    update prmaster_temp
    set  codeid = (select codeid from sbsecurities where trim(sbsecurities.symbol) = trim(prmaster_temp.symbol)), status = 'P'
    where exists (select 1 from sbsecurities where trim(sbsecurities.symbol) = trim(prmaster_temp.symbol));

    update prmaster_temp
    set  status = 'E',errmsg = 'Stock symbol can not found!'
    where not exists (select 1 from sbsecurities where trim(sbsecurities.symbol) = trim(prmaster_temp.symbol));

    update prmaster_temp
    set  status = 'E',errmsg = 'PrCode and Codeid system is not match!'
    where not exists (select 1 from prmaster where prmaster.prcode = prmaster_temp.prcode and prmaster.codeid = prmaster_temp.codeid);

    update prmaster_temp
    set  status = 'E',errmsg = 'PrCode has invalid format!'
    where length(trim(prcode)) <> 4;

    update prmaster_temp
    set  status = 'E',errmsg = 'PoolRoom type is invalid!'
    where prtyp <> 'R';

    update prmaster_temp
    set status = 'E', errmsg = 'PrCode is duplicated!'
    where exists (select 1 from prmaster_temp having count(1) > 1 group by prcode);

    update prmaster_temp
    set status = 'E', errmsg = 'Symbol is duplicated!'
    where exists (select 1 from prmaster_temp having count(1) > 1 group by symbol);

    update prmaster_temp
    set tlid = p_tlid;

    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
exception
when others then
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_PRSYSTEM_UPLOAD;

PROCEDURE PR_PRSYSTEM_APPROVE (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
l_count NUMBER;
BEGIN

    for rec in
    (
        select * from prmaster_temp where status = 'P'
    )
    loop
        select count(1) into l_count from prmaster where codeid = rec.codeid;
        if l_count <= 0 then
            insert into prmaster (PRCODE,PRNAME,PRTYP,CODEID,PRLIMIT,PRINUSED,EXPIREDDT,PRSTATUS)
            values( trim(rec.prcode), trim(rec.prname), trim(rec.prtyp), trim(rec.codeid), to_number(rec.prlimit), 0, null, trim(rec.PRSTATUS));
        else
            update prmaster
            set prlimit = to_number(rec.prlimit)
            where codeid = trim(rec.codeid);
        end if;

        update prmaster_temp
        set status  = 'A'
        where prcode = rec.prcode
        and codeid = rec.codeid;
    end loop;

    update prmaster_temp
    set ofid = p_tlid;

    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
exception
when others then
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_PRSYSTEM_APPROVE;



PROCEDURE PR_ROOM_SYSTEM_APPROVE (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
l_count NUMBER;
v_prinused number;
BEGIN

    -- Kiem tra trung SYMBOL.
    begin
        select count(1)
            into l_count
        from securities_info_import
        having count(1) > 1
        group by trim(symbol);
    exception when others then
        null;
    end;
    if l_count > 0 then
        -- Raise Error Duplicate SYMBOL.
        p_err_code:= '-100436';
        p_err_message:= 'Raise Error Duplicate SYMBOL!';
        delete securities_info_import;
        return;
    end if;

    -- Kiem tra xem co ma chung khoan nao khong ton tai tren het thong khong?
    update securities_info_import
    set status = 'E', errmsg = 'Symbol is not exists on system!'
    where not exists (select 1 from securities_info where trim(securities_info.symbol) = trim(securities_info_import.symbol));

    -- Cap nhat. Day la nguon he thong --> Cac ma khong co trong excel -> reset ve 0
    update securities_info
    set syroomlimit_set = 0
    where  0=0;

    /*Update securities_info
    set syroomlimit = (select roomlimit from securities_info_import where trim(securities_info.symbol) = trim(securities_info_import.symbol))
    where exists (select 1 from securities_info_import where trim(securities_info.symbol) = trim(securities_info_import.symbol));*/

    for rec in (
        select se.symbol, se.codeid, imp.roomlimit from securities_info_import imp, securities_info se
        where upper(trim(imp.symbol))= trim(se.symbol)
    )
    loop
        begin
            select nvl(afpr.prinused,0) + sb.syroomused into v_prinused
                from securities_info sb,
                       (select codeid, sum(prinused) prinused from vw_afpralloc_all where restype = 'S' group by codeid) afpr
                where sb.codeid = afpr.codeid(+)
                and sb.codeid = rec.codeid;
        exception when others then
            v_prinused:=0;
        end;
         update securities_info
        set syroomlimit = greatest(rec.roomlimit,v_prinused),
            syroomlimit_set = rec.roomlimit
        where codeid = rec.codeid;
    end loop;

    update securities_info_import
    set tlid = p_tlid, status = 'A';

    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
exception
when others then
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= dbms_utility.format_error_backtrace || 'System error. Invalid file format';
RETURN;
END PR_ROOM_SYSTEM_APPROVE;


PROCEDURE PR_ROOM_MARGIN_APPROVE (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
l_count NUMBER;
v_prinused number;
BEGIN

    -- Kiem tra trung SYMBOL.
    begin
        select count(1)
            into l_count
        from securities_info_import
        having count(1) > 1
        group by trim(symbol);
    exception when others then
        null;
    end;
    if l_count > 0 then
        -- Raise Error Duplicate SYMBOL.
        p_err_code:= '-100436';
        p_err_message:= 'Raise Error Duplicate SYMBOL!';
        delete securities_info_import;
        return;
    end if;

    -- Kiem tra xem co ma chung khoan nao khong ton tai tren het thong khong?
    update securities_info_import
    set status = 'E', errmsg = 'Symbol is not exists on system!'
    where not exists (select 1 from securities_info where trim(securities_info.symbol) = trim(securities_info_import.symbol));

    -- Cap nhat. Day la nguon margin --> Cac ma khong co trong excel -> giu nguyen
    /*Update securities_info
    set roomlimitmax = (select roomlimit from securities_info_import where trim(securities_info.symbol) = trim(securities_info_import.symbol))
    where exists (select 1 from securities_info_import where trim(securities_info.symbol) = trim(securities_info_import.symbol));*/

    for rec in (
        select se.symbol, se.codeid, imp.roomlimit from securities_info_import imp, securities_info se
        where upper(trim(imp.symbol))= trim(se.symbol)
    )
    loop
        begin
            select nvl(sum(prinused),0) into v_prinused from vw_afpralloc_all
            where restype = 'M'
            and codeid = rec.codeid;
        exception when others then
            v_prinused:=0;
        end;
        update securities_info
        set roomlimitmax = GREATEST(rec.roomlimit,v_prinused),
            roomlimitmax_set = rec.roomlimit
        where codeid = rec.codeid;
    end loop;

    update securities_info_import
    set tlid = p_tlid, status = 'A';

    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
exception
when others then
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_ROOM_MARGIN_APPROVE;

PROCEDURE T0_AVRTRADEQTTY_MAKE (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
l_count NUMBER;
v_prinused number;
BEGIN

    -- Kiem tra trung SYMBOL.
    begin
        select count(1)
            into l_count
        from securities_info_import
        having count(1) > 1
        group by trim(symbol);
    exception when others then
        null;
    end;
    if l_count > 0 then
        -- Raise Error Duplicate SYMBOL.
        p_err_code:= '-100436';
        p_err_message:= 'Raise Error Duplicate SYMBOL!';
        delete securities_info_import;
        return;
    end if;

    -- Kiem tra xem co ma chung khoan nao khong ton tai tren het thong khong?
    update securities_info_import
    set status = 'E', errmsg = 'Symbol is not exists on system!'
    where not exists (select 1 from securities_info where trim(securities_info.symbol) = trim(securities_info_import.symbol));


    update securities_info_import
    set tlid = p_tlid, status = 'P' where status <> 'E';

    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
exception
when others then
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END T0_AVRTRADEQTTY_MAKE;

PROCEDURE T0_AVRTRADEQTTY_APPROVE (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
l_count NUMBER;
v_prinused number;
BEGIN

    -- Kiem tra trung SYMBOL.
    /*begin
        select count(1)
            into l_count
        from securities_info_import
        having count(1) > 1
        group by trim(symbol);
    exception when others then
        null;
    end;*/
   /* if l_count > 0 then
        -- Raise Error Duplicate SYMBOL.
        p_err_code:= '-100436';
        p_err_message:= 'Raise Error Duplicate SYMBOL!';
        delete securities_info_import;
        return;
    end if;*/

    -- Kiem tra xem co ma chung khoan nao khong ton tai tren het thong khong?
    /*update securities_info_import
    set status = 'E', errmsg = 'Symbol is not exists on system!'
    where not exists (select 1 from securities_info where trim(securities_info.symbol) = trim(securities_info_import.symbol));*/

    --cap nhat AVRTRADEQTT ve 0
    -- 1.5.8.9|iss:2056 khong cap nhat ma trong file imp
    update securities_info set AVRTRADEQTT  = 0
    WHERE TRIM(symbol) NOT IN (SELECT TRIM(symbol) FROM securities_info_import WHERE status = 'P');

    for rec in (
        select se.symbol, se.codeid, imp.AVRTRADEQTT QTTY from securities_info_import imp, securities_info se
        where upper(trim(imp.symbol))= trim(se.symbol) and imp.status = 'P'
    )
    LOOP
        --chi update ma co trong file imp
        update securities_info
        set AVRTRADEQTT  = REC.QTTY
        where codeid = rec.codeid;
    end loop;

    update securities_info_import
    set /*tlid = p_tlid,*/ status = 'A' where status = 'P';

    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
exception
when others then
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END T0_AVRTRADEQTTY_APPROVE;

PROCEDURE T0_NAVPRICE_MAKE (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
l_count NUMBER;
v_prinused number;
BEGIN

    -- Kiem tra trung SYMBOL.
    begin
        select count(1)
            into l_count
        from securities_info_import
        having count(1) > 1
        group by trim(symbol);
    exception when others then
        null;
    end;
    if l_count > 0 then
        -- Raise Error Duplicate SYMBOL.
        p_err_code:= '-100436';
        p_err_message:= 'Raise Error Duplicate SYMBOL!';
        delete securities_info_import;
        return;
    end if;

    -- Kiem tra xem co ma chung khoan nao khong ton tai tren het thong khong?
    update securities_info_import
    set status = 'E', errmsg = 'Symbol is not exists on system!'
    where not exists (select 1 from securities_info where trim(securities_info.symbol) = trim(securities_info_import.symbol));

    /*for rec in (
        select se.symbol, se.codeid, imp.NAVPRICE  from securities_info_import imp, securities_info se
        where upper(trim(imp.symbol))= trim(se.symbol)
    )
    loop
        update securities_info
        set NAVPRICE  = REC.NAVPRICE
        where codeid = rec.codeid;
    end loop;*/

    update securities_info_import
    set tlid = p_tlid, status = 'P' where status <> 'E';

    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
exception
when others then
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END T0_NAVPRICE_MAKE;

PROCEDURE T0_NAVPRICE_APPROVE (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
l_count NUMBER;
v_prinused number;
BEGIN

    -- Kiem tra trung SYMBOL.
    /*begin
        select count(1)
            into l_count
        from securities_info_import
        having count(1) > 1
        group by trim(symbol);
    exception when others then
        null;
    end;*/
    /*if l_count > 0 then
        -- Raise Error Duplicate SYMBOL.
        p_err_code:= '-100436';
        p_err_message:= 'Raise Error Duplicate SYMBOL!';
        delete securities_info_import;
        return;
    end if;*/

    -- Kiem tra xem co ma chung khoan nao khong ton tai tren het thong khong?
   /* update securities_info_import
    set status = 'E', errmsg = 'Symbol is not exists on system!'
    where not exists (select 1 from securities_info where trim(securities_info.symbol) = trim(securities_info_import.symbol));*/
    --Reset thong tin cuar cac ma trong bang truoc khi cap nhat theo file
    -- 1.5.8.9|iss:2056 khong cap nhat ma trong file imp
    UPDATE securities_info SET NAVPRICE  = 0
    WHERE TRIM(symbol) NOT IN (SELECT TRIM(symbol) FROM securities_info_import WHERE status = 'P');

    for rec in (
        select se.symbol, se.codeid, imp.NAVPRICE  from securities_info_import imp, securities_info se
        where upper(trim(imp.symbol))= trim(se.symbol) and imp.status = 'P'
    )
    loop
        update securities_info
        set NAVPRICE  = REC.NAVPRICE
        where codeid = rec.codeid;
    end loop;

    update securities_info_import
    set /*tlid = p_tlid,*/ status = 'A' where status = 'P';

    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
exception
when others then
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END T0_NAVPRICE_APPROVE;



PROCEDURE PR_SYMBOL_SELL_ORDER (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
l_count NUMBER;
v_prinused number;
BEGIN

    -- Kiem tra trung SYMBOL.
    begin
        select count(1)
            into l_count
        from securities_info_import
        having count(1) > 1
        group by trim(symbol);
    exception when others then
        null;
    end;
    if NVL(l_count,0) > 0 then
        -- Raise Error Duplicate SYMBOL.
        p_err_code:= '-100436';
        p_err_message:= 'Raise Error Duplicate SYMBOL!';
        delete securities_info_import;
        return;
    end if;

    -- Kiem tra xem co ma chung khoan nao khong ton tai tren het thong khong?
    update securities_info_import
    set status = 'E', errmsg = 'Symbol is not exists on system!'
    where not exists (select 1 from securities_info where trim(securities_info.symbol) = trim(securities_info_import.symbol));



    for rec in (
        select imp.symbol, imp.SELLORDER from securities_info_import imp
    )
    loop
        -- Kiem tra trung SELLORDER.
        begin
            select count(1)
                into l_count
            from securities_info_import WHERE SELLORDER = REC.SELLORDER;
        exception when others then
            null;
        end;

        if NVL(l_count,0) > 1 OR NVL(REC.SELLORDER,0) = 0 then
            p_err_code:= '-100407';
            p_err_message:= 'Invalid sell order';
            UPDATE securities_info_import SET errmsg = 'Sai thu tu ban '|| REC.SYMBOL  where SYMBOL = rec.SYMBOL;
            return;
        end if;

    end loop;




    -- Cap nhap thu tu ba'n xu ly ve null

    update securities_info set sellorder = null;

    for rec in (
        select se.symbol, imp.SELLORDER from securities_info_import imp, securities_info se
        where upper(trim(imp.symbol))= trim(se.symbol)
    )
    loop
        -- Kiem tra trung SELLORDER.
        begin
            select count(1)
                into l_count
            from securities_info WHERE SELLORDER = REC.SELLORDER;
        exception when others then
            null;
        end;

        if NVL(l_count,0) > 0 OR NVL(REC.SELLORDER,0) = 0 then
            p_err_code:= '-100407';
            p_err_message:= 'Invalid sell order';
            UPDATE securities_info_import SET errmsg = 'Sai thu tu ban'|| REC.SYMBOL  where SYMBOL = rec.SYMBOL;
            return;
        end if;

        update securities_info set SELLORDER= rec.SELLORDER where SYMBOL = rec.SYMBOL;

    end loop;

    update securities_info_import
    set tlid = p_tlid, status = 'A' where status <> 'E';

    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
exception
when others then
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= dbms_utility.format_error_backtrace || 'System error. Invalid file format';
RETURN;
END PR_SYMBOL_SELL_ORDER;



PROCEDURE PR_PRICE_CL_APPROVE (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
l_count NUMBER;
BEGIN

    -- Kiem tra trung SYMBOL.
    begin
        select count(1)
            into l_count
        from securities_info_import
        having count(1) > 1
        group by trim(symbol);
    exception when others then
        null;
    end;
    if l_count > 0 then
        -- Raise Error Duplicate SYMBOL.
        p_err_code:= '-100436';
        p_err_message:= 'Raise Error Duplicate SYMBOL!';
        delete securities_info_import;
        return;
    end if;

    -- Kiem tra xem co ma chung khoan nao khong ton tai tren het thong khong?
    update securities_info_import
    set status = 'E', errmsg = 'Symbol is not exists on system!'
    where not exists (select 1 from securities_info where trim(securities_info.symbol) = trim(securities_info_import.symbol));

    Update securities_info
    set (marginprice,margincallprice) = (select marginprice,margincallprice from securities_info_import where trim(securities_info.symbol) = trim(securities_info_import.symbol))
    where exists (select 1 from securities_info_import where trim(securities_info.symbol) = trim(securities_info_import.symbol));

    update securities_info_import
    set tlid = p_tlid, status = 'A';

    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
exception
when others then
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= dbms_utility.format_error_backtrace || 'System error. Invalid file format';
RETURN;
END PR_PRICE_CL_APPROVE;


PROCEDURE PR_PRICE_MARGIN_APPROVE (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
l_count NUMBER;
BEGIN

    -- Kiem tra trung SYMBOL.
    begin
        select count(1)
            into l_count
        from securities_info_import
        having count(1) > 1
        group by trim(symbol);
    exception when others then
        null;
    end;
    if l_count > 0 then
        -- Raise Error Duplicate SYMBOL.
        p_err_code:= '-100436';
        p_err_message:= 'Raise Error Duplicate SYMBOL!';
        delete securities_info_import;
        return;
    end if;

    -- Kiem tra xem co ma chung khoan nao khong ton tai tren het thong khong?
    update securities_info_import
    set status = 'E', errmsg = 'Symbol is not exists on system!'
    where not exists (select 1 from securities_info where trim(securities_info.symbol) = trim(securities_info_import.symbol));

    -- Cap nhat. Day la nguon margin --> Cac ma khong co trong excel -> giu nguyen
    Update securities_info
    set (marginrefprice,marginrefcallprice) = (select marginprice,margincallprice from securities_info_import where trim(securities_info.symbol) = trim(securities_info_import.symbol))
    where exists (select 1 from securities_info_import where trim(securities_info.symbol) = trim(securities_info_import.symbol));

    update securities_info_import
    set tlid = p_tlid, status = 'A';

    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
exception
when others then
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_PRICE_MARGIN_APPROVE;



/*===IMPORT DU LIEU TU FILE=====
1.TBLCFAF: MO THONG TIN KHACH HANG
2.TBLSE2240: LUU KY CHUNG KHOAN 2240
3.TBLSE2245: NHAN CHUYEN KHOAN CHUNG KHOAN
4.TBLCI1141: NHAN CHUYEN KHOAN TIEN
5.TBLCI1101: CHUYEN TIEN RA NGAN HANG
6.TBLCI1187: CAP NHAT TIEN CHO TK THUOC THANH VIEN LK KHAC
7.TBLSE2287: CAP NHAT CK CHO TK THUOC THANH VIEN LK KHAC
8.TBLSE2203: GIAI TOA CHUNG KHOAN 2203
==============================*/


--1.
PROCEDURE PR_FILE_TBLCFAF(p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
  -- Enter the procedure variables here. As shown below
 v_busdate DATE;
 v_count NUMBER;
 l_err_code varchar2(30);
 l_err_param varchar2(30);
 p_err_param varchar2(30);
 l_custodycd varchar(10);
 l_tmpcustodycd varchar(10);
 l_custid varchar(10);
 l_afacctno varchar(10);
 l_aftype varchar(3);
 l_citype varchar(4);
 l_corebank varchar(1);
 l_autoadv varchar(1);
BEGIN

    l_err_code:= systemnums.C_SUCCESS;
    l_err_param:= 'SYSTEM_SUCCESS';
    p_err_param:='SYSTEM_SUCCESS';
    p_err_code:= systemnums.C_SUCCESS;

    -- get CURRDATE
    SELECT to_date(varvalue,systemnums.c_date_format) INTO v_busdate
    FROM sysvar
    WHERE varname = 'CURRDATE' AND grname = 'SYSTEM';

    plog.debug(pkgctx, 'BAT DAU UPDATE TBLCFAF ');

    UPDATE tblcfaf
    SET autoid = seq_tblcfaf.NEXTVAL;

    plog.debug(pkgctx, 'BAT DAU UPDATE THONG BAO LOI ');

     -- kiem tra cac truong mandatory va CHECK gia tri so chung khoan.
     UPDATE tblcfaf
     SET deltd = 'Y', errmsg = 'data missing: ' ||
        CASE
            WHEN fullname IS NULL OR fullname = '' THEN ' [FULLNAME] IS NULL '
            WHEN idcode IS NULL OR idcode = '' THEN ' [IDCODE] IS NULL '
            WHEN fileid IS NULL OR fileid = '' THEN ' [FILEID] IS NULL '
            WHEN iddate IS NULL OR iddate = '' THEN ' [IDDATE] IS NULL '
            WHEN IDPLACE IS NULL OR IDPLACE = '' THEN ' [IDPLACE] IS NULL '
            WHEN IDTYPE IS NULL OR IDTYPE = '' THEN ' [IDTYPE] IS NULL '
            WHEN COUNTRY IS NULL OR COUNTRY = '' THEN ' [COUNTRY] IS NULL '
            WHEN ADDRESS IS NULL OR ADDRESS = '' THEN ' [ADDRESS] IS NULL '
            WHEN IDTYPE = '005' AND (TAXCODE IS NULL OR TAXCODE = '') THEN ' [TAXCODE] IS NULL '
            WHEN AFTYPE IS NULL OR AFTYPE = '' THEN ' [AFTYPE] IS NULL '
            WHEN BRANCH IS NULL OR AFTYPE = '' THEN ' [BRANCH] IS NULL '
            WHEN CAREBY IS NULL OR CAREBY = '' THEN ' [CAREBY] IS NULL '
            WHEN SEX IS NULL OR SEX = '' THEN ' [SEX] IS NULL '
            --WHEN (EXTRACT(YEAR FROM v_busdate)- EXTRACT(YEAR FROM to_date(BIRTHDAY,'DD/MM/RRRR')) < 18) AND (IDTYPE <>'005') THEN '[BIRTHDAY] IS INVALID'
            WHEN idtype NOT IN (SELECT CDVAL FROM ALLCODE WHERE CDNAME='IDTYPE') THEN ' [IDTYPE] DOESN''T EXIST '
            WHEN SEX NOT IN (SELECT CDVAL FROM ALLCODE WHERE CDNAME='SEX') THEN ' [SEX] DOESN''T EXIST '
            WHEN COUNTRY NOT IN (SELECT CDVAL FROM ALLCODE WHERE CDNAME='COUNTRY') THEN ' [COUNTRY] DOESN''T EXIST '
            --WHEN BANKNAME IS NULL OR BANKNAME <>'' OR BANKNAME NOT IN (SELECT CDVAL FROM ALLCODE WHERE CDNAME='BANKNAME') THEN ' [BANKNAME] IS INVALID '
            --WHEN QTTYTYPE IS NULL OR QTTYTYPE <>'' OR QTTYType NOT IN (SELECT CDVAL FROM ALLCODE WHERE CDNAME='QTTYTYPE') THEN ' [QTTYTYPE] IS INVALID '
            WHEN COUNTRY = '234' AND IDTYPE = '002' THEN ' IDTYPE IS INVALID '
            --WHEN idcode in (SELECT IDCODE FROM CFMAST WHERE CUSTID NOT IN (SELECT CUSTID FROM AFMAST WHERE STATUS NOT IN ('C','N'))) THEN ' CLOSE SUB ACCOUNT FIRST! '
            WHEN TRIM(CAREBY) NOT IN (SELECT GRPID FROM TLGRPUSERS) THEN ' [CAREBY] IS INVALID'
            --WHEN TRIM(FILEID) IN (SELECT FILEID FROM tblcfafHIST) THEN ' [FILEID] IS INVALID'
            WHEN TRIM(AFTYPE) NOT IN (SELECT TRIM(ACTYPE) FROM AFTYPE) THEN ' [AFTYPE] IS INVALID '
            WHEN TRIM(AFTYPE) NOT IN (SELECT TRIM(ACTYPE) FROM AFTYPE WHERE STATUS='Y') THEN ' [AFTYPE] IS INVALID '
            WHEN TRIM(AFTYPE) NOT IN (SELECT TRIM(ACTYPE) FROM AFTYPE WHERE APPRV_STS='A') THEN ' [AFTYPE] IS INVALID '
            WHEN TRIM(BRANCH) NOT IN (SELECT TRIM(BRID) FROM BRGRP WHERE STATUS='A') THEN ' [BRANCH] IS INVALID '
            --WHEN OPNDATE IS NULL OR OPNDATE = '' THEN ' [OPNDATE] IS NULL '
            --WHEN TRIM(OPNDATE) NOT IN (SELECT TRIM(SBDATE) FROM SBCLDR WHERE HOLIDAY='N' AND CLDRTYPE='000') THEN ' [OPNDATE] IS A HOLIDAY '
            --WHEN TO_DATE(TRIM(OPNDATE),'DD/MM/RRRR') > TO_DATE(v_busdate,'DD/MM/RRRR') THEN ' [OPNDATE] IS IN FUTURE '
            ELSE 'UNKNOWN!'
        END
     WHERE
     idtype IS NULL OR idtype = ''
     OR fullname IS NULL OR fullname = ''
     OR idCODE IS NULL OR idCODE = ''
     OR fileid IS NULL OR fileid = ''
     OR iddate IS NULL OR iddate = ''
     OR IDPLACE IS NULL OR IDPLACE = ''
     OR SEX IS NULL OR SEX = ''
     or COUNTRY IS NULL OR COUNTRY = ''
     or ADDRESS IS NULL OR IDTYPE = ''
     OR (IDTYPE = '005' AND (TAXCODE IS NULL OR TAXCODE = ''))
     or AFTYPE IS NULL OR AFTYPE = ''
     or BRANCH IS NULL OR AFTYPE = ''
     or CAREBY IS NULL OR CAREBY = ''
     --OR ((EXTRACT( YEAR FROM v_busdate)- EXTRACT( YEAR FROM to_date(BIRTHDAY,'DD/MM/RRRR')) < 18) AND IDTYPE <>'005')
     OR idtype NOT IN (SELECT CDVAL FROM ALLCODE WHERE CDNAME='IDTYPE')
     OR COUNTRY NOT IN (SELECT CDVAL FROM ALLCODE WHERE CDNAME='COUNTRY')
     --OR (BANKNAME  IS NULL OR BANKNAME <>'' OR BANKNAME NOT IN (SELECT CDVAL FROM ALLCODE WHERE CDNAME='BANKNAME'))
     or SEX NOT IN (SELECT CDVAL FROM ALLCODE WHERE CDNAME='SEX')
     OR (COUNTRY = '234') AND (IDTYPE = '002')
     --OR idcode in (SELECT IDCODE FROM CFMAST WHERE CUSTID NOT IN (SELECT CUSTID FROM AFMAST WHERE STATUS NOT IN ('C','N')))
     OR TRIM(CAREBY) NOT IN (SELECT GRPID FROM TLGRPUSERS)
     --OR TRIM(FILEID) IN (SELECT FILEID FROM tblcfafHIST)
     OR TRIM(AFTYPE) NOT IN (SELECT TRIM(ACTYPE) FROM AFTYPE)
     OR TRIM(AFTYPE) NOT IN (SELECT TRIM(ACTYPE) FROM AFTYPE WHERE STATUS='Y')
     OR TRIM(AFTYPE) NOT IN (SELECT TRIM(ACTYPE) FROM AFTYPE WHERE APPRV_STS='A')
     OR TRIM(BRANCH) NOT IN (SELECT TRIM(BRID) FROM BRGRP WHERE STATUS='A')
     --OR OPNDATE IS NULL OR OPNDATE = ''
     --OR TRIM(OPNDATE) NOT IN (SELECT TRIM(SBDATE) FROM SBCLDR WHERE HOLIDAY='N' AND CLDRTYPE='000')
     --OR TO_DATE(TRIM(OPNDATE),'DD/MM/RRRR') > TO_DATE(v_busdate,'DD/MM/RRRR')
     ;

    /*
     select count(1) into v_count from tblcfaf where DELTD='Y';

     IF V_COUNT>0 THEN
        p_err_code := -100800; --File du lieu dau vao khong hop le
        p_err_message := 'SYSTEM_ERROR';
        RETURN;
     END IF;
     */
     -- xu ly tuan tu
     FOR rec  IN
     (
         SELECT * FROM tblcfaf WHERE STATUS='P' AND DELTD<>'Y'
     )
     LOOP

        ---- Kiem tra IDCODE xem co trung khong, neu trung chi lam luu ky chu ko sinh trong CFMAST nua
         select count(1) into v_count from cfmast where IDCODE=trim(rec.IDCODE) and status='A';

         if v_count=0 then
                 --- SINH SO CUSTODYCD
             SELECT decode (rec.country,'234',SUBSTR(INVACCT,1,4) || TRIM(TO_CHAR(MAX(ODR)+1,'000000')),'') into l_custodycd FROM
                      (
                      SELECT ROWNUM ODR, INVACCT
                      FROM (SELECT CUSTODYCD INVACCT FROM CFMAST
                      WHERE SUBSTR(CUSTODYCD,1,4)= (SELECT VARVALUE FROM SYSVAR WHERE VARNAME='COMPANYCD'AND GRNAME='SYSTEM') || 'C' AND TRIM(TO_CHAR(TRANSLATE(SUBSTR(CUSTODYCD,5,6),'0123456789',' '))) IS NULL
                      ORDER BY CUSTODYCD) DAT
                      WHERE TO_NUMBER(SUBSTR(INVACCT,5,6))=ROWNUM
                      ) INVTAB
                      GROUP BY SUBSTR(INVACCT,1,4);

            plog.debug(pkgctx, 'Sinh SO LUUKY, CUSTID ' || l_custodycd );
            ---- SINH SO CUSTID
            SELECT SUBSTR(INVACCT,1,4) || TRIM(TO_CHAR(MAX(ODR)+1,'000000'))  into l_custid FROM
                    (SELECT ROWNUM ODR, INVACCT
                    FROM (SELECT CUSTID INVACCT FROM CFMAST WHERE SUBSTR(CUSTID,1,4)= trim(rec.branch) ORDER BY CUSTID) DAT
                    WHERE TO_NUMBER(SUBSTR(INVACCT,5,6))=ROWNUM) INVTAB
                    GROUP BY SUBSTR(INVACCT,1,4);
            plog.debug(pkgctx, 'Sinh tai khoan CFMAST');

            --- MO TAI KHOAN
            INSERT INTO CFMAST (CUSTID, CUSTODYCD, FULLNAME, IDCODE, IDDATE, IDPLACE,IDEXPIRED, IDTYPE, COUNTRY, ADDRESS, MOBILE, EMAIL, DESCRIPTION, TAXCODE, OPNDATE,
            CAREBY, BRID, STATUS, PROVINCE, CLASS, GRINVESTOR, INVESTRANGE, POSITION, TIMETOJOIN, STAFF, SEX, SECTOR, FOCUSTYPE ,BUSINESSTYPE,
            INVESTTYPE, EXPERIENCETYPE, INCOMERANGE, ASSETRANGE, LANGUAGE, BANKCODE, MARRIED, ISBANKING, DATEOFBIRTH,CUSTTYPE,CUSTATCOM)
                    VALUES (l_custid, decode(rec.country,'234',l_custodycd,''), rec.fullname, rec.idcode, rec.iddate, rec.idplace, to_date(EXTRACT (YEAR from  rec.iddate) + 20,'YYYY') , rec.idtype, rec.country, rec.address,
                    rec.mobile, rec.email, rec.description, rec.taxcode, rec.opndate, rec.careby,rec.branch,'A','HN','001','001','001','001','001','005',rec.sex
                    ,'001','001','001','001','001','001','001','001','001','001','N',TO_DATE(rec.birthday,'DD/MM/RRRR'),'I','Y');
            -- INSERT VAO MAINTAIN_LOG CFMAST
            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''',p_tlid,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'CUSTID','',l_custid ,'ADD',NULL,NULL);

           INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'CUSTODYCD','',l_custodycd ,'ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'FULLNAME','',rec.fullname ,'ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'IDCODE','',rec.idcode ,'ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'IDDATE','',rec.iddate ,'ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'IDPLACE','',rec.idplace ,'ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'IDTYPE','',rec.idtype ,'ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'COUNTRY','',rec.country,'ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'ADDRESS','',rec.ADDRESS ,'ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'MOBILE','',rec.MOBILE ,'ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'EMAIL','',rec.EMAIL ,'ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'DESCRIPTION','',rec.DESCRIPTION || '''','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'TAXCODE','',rec.TAXCODE ,'ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'CAREBY','',rec.CAREBY ,'ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'PROVINCE','','--','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'CLASS','','001','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'GRINVESTOR','','001','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'INVESTRANGE','','001','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'POSITION','','001','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'TIMETOJOIN','','001','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'TIMETOJOIN','','005','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'SEX','',rec.SEX ,'ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'SECTOR','','001','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'SECTOR','','001','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'FOCUSTYPE','','001','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'BUSINESSTYPE','','001','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'INVESTTYPE','','001','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'EXPERIENCETYPE','','001','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'INCOMERANGE','','001','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'ASSETRANGE','','001','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'LANGUAGE','','001','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'BANKCODE','','001','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'MARRIED','','001','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'ISBANKING','','N','ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'DATEOFBIRTH','',to_date(rec.birthday,'DD/MM/RRRR'),'ADD',NULL,NULL);

            INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
            VALUES('CFMAST','CUSTID = ''' || l_custid || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
             p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'CUSTTYPE','','I','ADD',NULL,NULL);

            --Update da sinh CFMAST
            --UPDATE tblcfaf SET GENCFMAST='Y' WHERE IDCODE=REC.IDCODE;
         else

         UPDATE tblcfaf set errmsg = errmsg ||'Trung so CMND', deltd ='Y' where autoid = rec.autoid;

         end if;     --- Sinh CFMAST

            plog.debug(pkgctx, 'SINH CFMAST, MAINTAINT_LOG XONG ');

         -- Neu la khach nuoc ngoai thi chi sinh thong tin khach hang (doi xin CUSTODYCD), khong luu ky
         -- Trong truong hop co so luu ky roi thi lam tiep
         if rec.country <> '234' then
             select custodycd into l_tmpcustodycd from cfmast where idcode=trim(rec.idcode) and status='A';
             plog.debug (pkgctx, 'Kiem tra doi voi kh nuoc ngoai: ' || nvl(l_tmpcustodycd,'a'));
             exit when trim(nvl(l_tmpcustodycd,'a'))='a';
         end if;

         ---- Kiem tra truong hop da co CFMAST nhung chua co AFMAST thi moi sinh
         select count(1) into v_count from afmast where custid in (select custid from cfmast where idcode=trim(rec.IDCODE) and status='A') AND STATUS='A';

         if v_count =0 then

             l_corebank:='N';
             l_autoadv:='N';

             SELECT AFTYPE INTO l_aftype FROM AFTYPE WHERE ACTYPE= rec.aftype;
             SELECT corebank into  l_corebank FROM AFTYPE WHERE ACTYPE= rec.aftype;
             SELECT autoadv into  l_autoadv FROM AFTYPE WHERE ACTYPE= rec.aftype;

             select custid INTO l_custid from cfmast where idcode=trim(rec.IDCODE);

             FOR recMRTYPE  IN
              (
                 SELECT * FROM MRTYPE WHERE ACTYPE IN(SELECT MRTYPE FROM AFTYPE WHERE ACTYPE= rec.aftype  )
               )
              LOOP

                ---- SINH SO AFMAST
                  SELECT SUBSTR(INVACCT,1,4) || TRIM(TO_CHAR(MAX(ODR)+1,'000000')) into l_afacctno FROM
                  (SELECT ROWNUM ODR, INVACCT
                  FROM (SELECT ACCTNO INVACCT FROM AFMAST WHERE SUBSTR(ACCTNO,1,4)= trim(rec.branch) ORDER BY ACCTNO) DAT
                  WHERE TO_NUMBER(SUBSTR(INVACCT,5,6))=ROWNUM) INVTAB
                  GROUP BY SUBSTR(INVACCT,1,4);

                 --- SINH TAI KHOAN AFMAST
                 INSERT INTO AFMAST (ACTYPE,CUSTID,ACCTNO,CIACCTNO,AFTYPE,TRADEFLOOR,TRADETELEPHONE,TRADEONLINE,LANGUAGE,TRADEPHONE,
                 BANKACCTNO,BANKNAME,EMAIL,ADDRESS,STATUS,MARGINLINE,TRADELINE,
                 ADVANCELINE,REPOLINE,DEPOSITLINE,DESCRIPTION,ICCFTIED,TELELIMIT,ONLINELIMIT,CFTELELIMIT,CFONLINELIMIT,
                 TRADERATE,DEPORATE,MISCRATE,STMCYCLE,ISOTC,CONSULTANT,PISOTC,OPNDATE,FEEBASE,VIA,
                 MRIRATE,MRMRATE,MRLRATE,MRDUEDAY,MREXTDAY,MRCLAMT,MRCRLIMIT,MRCRLIMITMAX,T0AMT,ETS,BRID,CAREBY,corebank,AUTOADV,TLID,ALLOWDEBIT,TERMOFUSE)
                 VALUES(rec.aftype,l_custid,l_afacctno,l_afacctno,l_aftype,'Y','Y','Y','001',rec.mobile, rec.bankacctno ,'---', rec.email,
                 rec.address,'A',0,0,0,0,0,rec.description,'Y',0,0,0,0,0,0,0,'M','N','N','N',TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'F',
                 recMRTYPE.MRIRATE,recMRTYPE.MRMRATE,recMRTYPE.MRLRATE,recMRTYPE.DUEDAY,recMRTYPE.EXTDAY,0,recMRTYPE.MRCRLIMIT,
                 recMRTYPE.MRLMMAX,0,'N',rec.branch, rec.careby,l_corebank,l_AUTOADV, p_tlid,'Y','001');

                 plog.debug(pkgctx, 'Sinh tai khoan AFMAST' || l_afacctno );

                 -- INSERT VAO MAINTAIN_LOG AFMAST
                 INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,
                 FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
                 VALUES('AFMAST','ACCTNO = ''' || l_afacctno || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
                  p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'ACTYPE','',rec.aftype,'ADD',NULL,NULL);

                 INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,
                 FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
                 VALUES('AFMAST','ACCTNO = ''' || l_afacctno || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
                  p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'CUSTID','',l_custid,'ADD',NULL,NULL);

                 INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,
                 FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
                 VALUES('AFMAST','ACCTNO = ''' || l_afacctno || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
                  p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'ACCTNO','',l_afacctno,'ADD',NULL,NULL);

                 INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,
                 FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
                 VALUES('AFMAST','ACCTNO = ''' || l_afacctno || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
                  p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'CIACCTNO','',l_afacctno,'ADD',NULL,NULL);

                 INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,
                 FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
                 VALUES('AFMAST','ACCTNO = ''' || l_afacctno || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
                  p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'AFTYPE','',l_aftype,'ADD',NULL,NULL);

                 INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,
                 FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
                 VALUES('AFMAST','ACCTNO = ''' || l_afacctno || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
                  p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'TRADEFLOOR','','Y','ADD',NULL,NULL);

                 INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,
                 FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
                 VALUES('AFMAST','ACCTNO = ''' || l_afacctno || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
                  p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'TRADETELEPHONE','','Y','ADD',NULL,NULL);

                 INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,
                 FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
                 VALUES('AFMAST','ACCTNO = ''' || l_afacctno || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
                  p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'TRADEONLINE','','Y','ADD',NULL,NULL);

                 INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,
                 FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
                 VALUES('AFMAST','ACCTNO = ''' || l_afacctno || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
                  p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'LANGUAGE','','001','ADD',NULL,NULL);

                 INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,
                 FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
                 VALUES('AFMAST','ACCTNO = ''' || l_afacctno || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
                  p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'TRADEPHONE','',rec.mobile,'ADD',NULL,NULL);

                 INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,
                 FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
                 VALUES('AFMAST','ACCTNO = ''' || l_afacctno || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
                  p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'BANKACCTNO','',rec.bankacctno,'ADD',NULL,NULL);

                 INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,
                 FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
                 VALUES('AFMAST','ACCTNO = ''' || l_afacctno || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
                  p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'BANKNAME','', rec.bankname,'ADD',NULL,NULL);

                 INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,
                 FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
                 VALUES('AFMAST','ACCTNO = ''' || l_afacctno || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
                  p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'EMAIL','',Rec.email,'ADD',NULL,NULL);

                 INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,
                 FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
                 VALUES('AFMAST','ACCTNO = ''' || l_afacctno || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
                  p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'ADDRESS','',rec.address,'ADD',NULL,NULL);

                 INSERT INTO MAINTAIN_LOG (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,
                 FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY)
                 VALUES('AFMAST','ACCTNO = ''' || l_afacctno || '''', p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),'Y',
                  p_tlid ,TO_DATE( v_busdate ,'DD/MM/RRRR'),0,'CAREBY','',rec.careby,'ADD',NULL,NULL);

                ----Update CUSTODYCD cho khach hang
                UPDATE CFMAST SET CUSTODYCD=l_custodycd WHERE IDCODE=rec.idcode and status='A';

                --- lay CITYPE de sinh tai khoan CI
               SELECT CITYPE into l_citype FROM AFTYPE WHERE ACTYPE = rec.aftype ;

                plog.debug(pkgctx,'Insert vao CIMAST: ' || l_afacctno);

                --- Sinh tai khoan CI
                INSERT INTO CIMAST (ACTYPE,ACCTNO,CCYCD,AFACCTNO,CUSTID,OPNDATE,CLSDATE,LASTDATE,DORMDATE,STATUS,PSTATUS,BALANCE,CRAMT,DRAMT,CRINTACR,CRINTDT,ODINTACR,ODINTDT,AVRBAL,MDEBIT,MCREDIT,AAMT,RAMT,BAMT,EMKAMT,MMARGINBAL,MARGINBAL,ICCFCD,ICCFTIED,ODLIMIT,ADINTACR,ADINTDT,FACRTRADE,FACRDEPOSITORY,FACRMISC,MINBAL,ODAMT,NAMT,FLOATAMT,HOLDBALANCE,PENDINGHOLD,PENDINGUNHOLD,COREBANK,RECEIVING,NETTING,MBLOCK,OVAMT,DUEAMT,T0ODAMT,MBALANCE,MCRINTDT,TRFAMT,LAST_CHANGE,DFODAMT,DFDEBTAMT,DFINTDEBTAMT,CIDEPOFEEACR)
                VALUES(l_citype,l_afacctno,'00',l_afacctno,l_custid,TO_DATE(v_busdate,'DD/MM/RRRR'),NULL,TO_DATE(v_busdate,'DD/MM/RRRR'),NULL,'A',NULL,0,0,0,0,TO_DATE(v_busdate,'DD/MM/RRRR'),0,TO_DATE(v_busdate,'DD/MM/RRRR'),0,0,0,0,0,0,0,0,0,NULL,'Y',0,0,NULL,0,0,0,0,0,0,0,0,0,0,l_corebank,0,0,0,0,0,0,0,TO_DATE(v_busdate,'DD/MM/RRRR'),0,TO_DATE(v_busdate,'DD/MM/RRRR'),0,0,0,0);

                --Update da sinh AFMAST
               -- UPDATE tblcfaf SET GENAFMAST='Y' WHERE IDCODE=REC.IDCODE;

             END LOOP;
         end if; ---- Kiem tra truong hop da co CFMAST nhung chua co AFMAST thi moi sinh


        --UPDATE tblcfaf SET STATUS='A', DELTD='Y' WHERE IDCODE=REC.IDCODE;
        UPDATE tblcfaf SET STATUS='A' WHERE AUTOID = REC.AUTOID;
        INSERT INTO tblcfafHIST SELECT * FROM tblcfaf where STATUS='A' and deltd ='N' and autoid =  REC.AUTOID ;

    END LOOP;
    plog.debug(pkgctx, 'insert tblcfafhist');

    COMMIT;

EXCEPTION
   WHEN OTHERS THEN
   plog.error(SQLERRM);
       ROLLBACK;
         plog.setendsection(pkgctx, 'PR_FILE_TBLCFAF');
         p_err_code := errnums.C_SYSTEM_ERROR;
         p_err_message := 'SYSTEM_ERROR';
       --RETURN errnums.C_SYSTEM_ERROR;

END PR_FILE_TBLCFAF;




--2.
PROCEDURE PR_FILE_TBLSE2240(p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
v_count NUMBER;
v_codeid varchar2(10);
v_acctno varchar2(20);
v_qtty NUMBER;
BEGIN
v_codeid:= '';
v_count:=0;
--Cap nhat autoid
UPDATE tblse2240 SET autoid = seq_tblse2240.NEXTVAL;
-- CHECK MA CK
    FOR REC IN
    (SELECT * FROM TBLSE2240 )
    LOOP
    IF rec.symbol IS NOT NULL THEN
        select count(codeid) into v_count from sbsecurities WHERE symbol = rec.symbol;
        IF v_count = 0 THEN
          UPDATE TBLSE2240 SET deltd='Y' , errmsg =errmsg||'Error: Symbol not found!' WHERE autoid = rec.autoid;
          --RETURN;
        else
            SELECT codeid INTO v_codeid  FROM sbsecurities WHERE symbol = rec.symbol;

            IF length(v_codeid) > 0 THEN
        --Cap nhat codeid
                UPDATE TBLSE2240 SET codeid= v_codeid, acctno = afacctno || v_codeid  WHERE autoid = rec.autoid;
            ELSE
                UPDATE TBLSE2240 SET deltd='Y' , errmsg = errmsg || 'Error: Symbol invalid!' WHERE autoid = rec.autoid;
          --RETURN;
            END IF;

        END IF;
    ELSE
          UPDATE TBLSE2240 SET deltd='Y' , errmsg = errmsg || 'Error: Symbol invalid!' WHERE autoid = rec.autoid;
          --RETURN;
    END IF;
--Check so luu ky
IF rec.custodycd IS NOT NULL THEN
     SELECT count(custodycd) INTO v_count FROM cfmast WHERE custodycd = rec.custodycd;
     IF v_count = 0 THEN
          p_err_code := -100800; --File du lieu dau vao khong hop le
          p_err_message:= 'System error. Invalid file format';
          UPDATE TBLSE2240 SET deltd='Y' , errmsg =errmsg ||'Error: Custody code invalid!' WHERE autoid = rec.autoid;
          --RETURN;
     END IF;
     --Check so tieu
     SELECT count(acctno) INTO v_count FROM afmast WHERE acctno = rec.afacctno;
     IF v_count = 0 THEN
          p_err_code := -100800; --File du lieu dau vao khong hop le
          p_err_message:= 'System error. Invalid file format';
          UPDATE TBLSE2240 SET deltd='Y' , errmsg =errmsg ||'Error: afacctno invalid!' WHERE autoid = rec.autoid;
          --RETURN;
     END IF;
     --Check  tieu khoan co phai thuoc so Luu ky
     SELECT count(acctno) INTO v_count FROM afmast af, cfmast cf WHERE  af.custid = cf.custid
     AND cf.custodycd = rec.custodycd AND af.acctno = rec.afacctno;
     IF v_count = 0 THEN
          p_err_code := -100800; --File du lieu dau vao khong hop le
          p_err_message:= 'System error. Invalid file format';
          UPDATE TBLSE2240 SET deltd='Y' , errmsg =errmsg ||'Error: afacctno invalid!' WHERE autoid = rec.autoid;
          --RETURN;
     END IF;
  IF rec.depotrade * rec.depoblock <> 0 THEN
      /* p_err_code := -100800; --File du lieu dau vao khong hop le
          p_err_message:= 'System error. Invalid file format';*/
          UPDATE TBLSE2240 SET deltd='Y' , errmsg =errmsg ||'Error: Chi dc LK 1 loai CK TCCN hoac HCCN!' WHERE autoid = rec.autoid;
     END IF;

     IF INSTR(UPPER(REC.SYMBOL),'_WFT') > 0 THEN
       IF REC.REFERENCEID IS NULL THEN
        /* p_err_code := -100800; --File du lieu dau vao khong hop le
          p_err_message:= 'System error. Invalid file format';*/
          UPDATE TBLSE2240 SET deltd='Y' , errmsg =errmsg ||'Error: CK WFT phai nhap ma dot phat hanh!' WHERE autoid = rec.autoid;
       END IF;
     END IF;
ELSE
          p_err_code := -100800; --File du lieu dau vao khong hop le
          p_err_message:= 'System error. Invalid file format';
          UPDATE TBLSE2240 SET deltd='Y' , errmsg =errmsg ||'Error: Custody code invalid!' WHERE autoid = rec.autoid;
          --RETURN;
END IF ;

 --1.8.2.5: Thue quyen
    IF rec.caqtty011 < 0 OR rec.caqtty021 < 0 THEN
        UPDATE TBLSE2240 SET deltd='Y' , errmsg = errmsg ||'Error: CA Quantity invalid!' WHERE autoid = rec.autoid;
    END IF;

    IF rec.taxrate011 < 0 OR rec.taxrate021 < 0 THEN
        UPDATE TBLSE2240 SET deltd='Y' , errmsg = errmsg ||'Error: Tax rate invalid!' WHERE autoid = rec.autoid;
    END IF;

    IF rec.DEPOTRADE < rec.caqtty011 + rec.caqtty021 THEN
      UPDATE TBLSE2240 SET deltd='Y' , errmsg = errmsg ||'Error: CA Quantity invalid > Total Quantity!' WHERE autoid = rec.autoid;
    END IF;
    --

    END LOOP;
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
exception
when others then
    rollback;
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_FILE_TBLSE2240;

--3.
PROCEDURE PR_FILE_TBLSE2245(p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
v_count NUMBER;
v_codeid VARCHAR2(20);
BEGIN

v_codeid:= '';
v_count:=0;
--Cap nhat autoid
UPDATE tblse2245 SET autoid = seq_tblse2245.NEXTVAL;
-- CHECK MA CK
    FOR REC IN
    (SELECT * FROM TBLSE2245 )
    LOOP
    IF rec.symbol IS NOT NULL THEN
        select count(codeid) into v_count from sbsecurities WHERE symbol = rec.symbol;
        IF v_count = 0 THEN
          UPDATE TBLSE2245 SET deltd='Y' , errmsg =errmsg||'Error: Symbol not found!' WHERE autoid = rec.autoid;
          --RETURN;
        else
            SELECT codeid INTO v_codeid  FROM sbsecurities WHERE symbol = rec.symbol;

            IF length(v_codeid) > 0 THEN
        --Cap nhat codeid
                UPDATE tblse2245 SET codeid= v_codeid, acctno = afacctno || v_codeid  WHERE autoid = rec.autoid;
            ELSE
                UPDATE TBLSE2245 SET deltd='Y' , errmsg = errmsg || 'Error: Symbol invalid!' WHERE autoid = rec.autoid;
          --RETURN;
            END IF;

        END IF;
    ELSE
          UPDATE TBLSE2245 SET deltd='Y' , errmsg = errmsg || 'Error: Symbol invalid!' WHERE autoid = rec.autoid;
          --RETURN;
    END IF;
--Check so luu ky
IF rec.custodycd IS NOT NULL THEN
     SELECT count(custodycd) INTO v_count FROM cfmast WHERE custodycd = rec.custodycd;
     IF v_count = 0 THEN
          UPDATE TBLSE2245 SET deltd='Y' , errmsg =errmsg ||'Error: Custody code invalid!' WHERE autoid = rec.autoid;
          --RETURN;
     END IF;
     --Check so tieu
     SELECT count(acctno) INTO v_count FROM afmast WHERE acctno = rec.afacctno;
     IF v_count = 0 THEN
          UPDATE TBLSE2245 SET deltd='Y' , errmsg = errmsg ||'Error: afacctno invalid!' WHERE autoid = rec.autoid;
          --RETURN;
     END IF;
     --Check  tieu khoan co phai thuoc so Luu ky
     SELECT count(acctno) INTO v_count FROM afmast af, cfmast cf WHERE  af.custid = cf.custid
     AND cf.custodycd = rec.custodycd AND af.acctno = rec.afacctno;
     IF v_count = 0 THEN
          UPDATE TBLSE2245 SET deltd='Y' , errmsg = errmsg ||'Error: afacctno invalid!' WHERE autoid = rec.autoid;
          --RETURN;
     END IF;

ELSE
        UPDATE TBLSE2245 SET deltd='Y' , errmsg = errmsg ||'Error: Custody code invalid!' WHERE autoid = rec.autoid;
          --RETURN;
END IF ;

    --1.8.2.5: Thue quyen
    IF rec.caqtty011 < 0 OR rec.caqtty021 < 0 THEN
        UPDATE TBLSE2245 SET deltd='Y' , errmsg = errmsg ||'Error: CA Quantity invalid!' WHERE autoid = rec.autoid;
    END IF;

    IF rec.taxrate011 < 0 OR rec.taxrate021 < 0 THEN
        UPDATE TBLSE2245 SET deltd='Y' , errmsg = errmsg ||'Error: Tax rate invalid!' WHERE autoid = rec.autoid;
    END IF;

    IF rec.amt + rec.depoblock < rec.caqtty011 + rec.caqtty021 THEN
      UPDATE TBLSE2245 SET deltd='Y' , errmsg = errmsg ||'Error: CA Quantity invalid > Total Quantity!' WHERE autoid = rec.autoid;
    END IF;
    --

END LOOP;


    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
exception
when others then
    rollback;
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_FILE_TBLSE2245;


--4.
PROCEDURE PR_FILE_TBLCI1141(p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
v_count NUMBER;
v_bankacctno varchar2(20);
v_glaccount varchar2(30);
BEGIN
v_bankacctno :='';
v_glaccount :='';
v_count:=0;
--Cap nhat autoid
UPDATE tblci1141 SET autoid = seq_tblci1141.NEXTVAL;
-- CHECK MA BANK
    FOR REC IN
    (SELECT * FROM TBLCI1141 )
    LOOP
    IF rec.bankid IS NOT NULL THEN
        SELECT count(shortname)  INTO v_count  FROM banknostro WHERE shortname = rec.bankid;
        IF v_count > 0 THEN
        --Cap nhat bankacc,glacc
            SELECT bankacctno INTO v_bankacctno FROM banknostro WHERE shortname = rec.bankid;
            SELECT glaccount INTO v_glaccount FROM banknostro WHERE shortname = rec.bankid;
            UPDATE TBLCI1141 SET bankacctno = v_bankacctno,  glmast = v_glaccount WHERE autoid = rec.autoid;

        ELSE
          UPDATE TBLCI1141 SET deltd='Y' , errmsg =errmsg ||'Error: Bank code invalid!' WHERE autoid = rec.autoid;
          --RETURN;
        END IF;
     ELSE
          UPDATE TBLCI1141 SET deltd='Y' , errmsg =errmsg ||'Error: Bank code invalid!' WHERE autoid = rec.autoid;
          --RETURN;
     END IF;
--Check so luu ky
IF rec.custodycd IS NOT NULL THEN
     SELECT count(custodycd) INTO v_count FROM cfmast WHERE custodycd = rec.custodycd;
     IF v_count = 0 THEN
          UPDATE TBLCI1141 SET deltd='Y' , errmsg =errmsg ||'Error: Custody code invalid!' WHERE autoid = rec.autoid;
          --RETURN;
     END IF;
     --Check so tieu
     SELECT count(acctno) INTO v_count FROM afmast WHERE acctno = rec.acctno;
     IF v_count = 0 THEN
          UPDATE TBLCI1141 SET deltd='Y' , errmsg =errmsg ||'Error: afacctno invalid!' WHERE autoid = rec.autoid;
          --RETURN;
     END IF;
     --Check  tieu khoan co phai thuoc so Luu ky
     SELECT count(acctno) INTO v_count FROM afmast af, cfmast cf WHERE  af.custid = cf.custid
     AND cf.custodycd = rec.custodycd AND af.acctno = rec.acctno;
     IF v_count = 0 THEN
          UPDATE TBLCI1141 SET deltd='Y' , errmsg =errmsg ||'Error: afacctno invalid!' WHERE autoid = rec.autoid;
          --RETURN;
     END IF;

ELSE
        UPDATE TBLCI1141 SET deltd='Y' , errmsg =errmsg ||'Error: Custody code invalid!' WHERE autoid = rec.autoid;
          --RETURN;
END IF ;


END LOOP;


    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
exception
when others then
    rollback;
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_FILE_TBLCI1141;

PROCEDURE PR_FILE_TBLCI1137(p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
v_count NUMBER;
BEGIN
v_count:=0;
--Cap nhat autoid
UPDATE tblci1137 SET autoid = seq_tblci1137.NEXTVAL;
-- CHECK MA BANK
    FOR REC IN
    (SELECT * FROM TBLCI1137 )
    LOOP
--Check so luu ky
IF rec.custodycd IS NOT NULL THEN
     SELECT count(custodycd) INTO v_count FROM cfmast WHERE custodycd = rec.custodycd;
     IF v_count = 0 THEN
          UPDATE TBLCI1137 SET deltd='Y' , errmsg =errmsg ||'Error: Custody code invalid!' WHERE autoid = rec.autoid;
          --RETURN;
     END IF;
     --Check so tieu
     SELECT count(acctno) INTO v_count FROM afmast WHERE acctno = rec.acctno;
     IF v_count = 0 THEN
          UPDATE TBLCI1137 SET deltd='Y' , errmsg =errmsg ||'Error: afacctno invalid!' WHERE autoid = rec.autoid;
          --RETURN;
     END IF;
     --Check  tieu khoan co phai thuoc so Luu ky
     SELECT count(acctno) INTO v_count FROM afmast af, cfmast cf WHERE  af.custid = cf.custid
     AND cf.custodycd = rec.custodycd AND af.acctno = rec.acctno;
     IF v_count = 0 THEN
          UPDATE TBLCI1137 SET deltd='Y' , errmsg =errmsg ||'Error: afacctno invalid!' WHERE autoid = rec.autoid;
          --RETURN;
     END IF;

ELSE
        UPDATE TBLCI1137 SET deltd='Y' , errmsg =errmsg ||'Error: Custody code invalid!' WHERE autoid = rec.autoid;
          --RETURN;
END IF ;


END LOOP;


    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
exception
when others then
    rollback;
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_FILE_TBLCI1137;


PROCEDURE PR_FILE_TBLCI1138(p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
v_count NUMBER;
BEGIN
v_count:=0;
--Cap nhat autoid
UPDATE tblci1138 SET autoid = seq_tblci1138.NEXTVAL;
-- CHECK MA BANK
    FOR REC IN
    (SELECT * FROM TBLCI1138 )
    LOOP
--Check so luu ky
IF rec.custodycd IS NOT NULL THEN
     SELECT count(custodycd) INTO v_count FROM cfmast WHERE custodycd = rec.custodycd;
     IF v_count = 0 THEN
          UPDATE TBLCI1138 SET deltd='Y' , errmsg =errmsg ||'Error: Custody code invalid!' WHERE autoid = rec.autoid;
          --RETURN;
     END IF;
     --Check so tieu
     SELECT count(acctno) INTO v_count FROM afmast WHERE acctno = rec.acctno;
     IF v_count = 0 THEN
          UPDATE TBLCI1138 SET deltd='Y' , errmsg =errmsg ||'Error: afacctno invalid!' WHERE autoid = rec.autoid;
          --RETURN;
     END IF;
     --Check  tieu khoan co phai thuoc so Luu ky
     SELECT count(acctno) INTO v_count FROM afmast af, cfmast cf WHERE  af.custid = cf.custid
     AND cf.custodycd = rec.custodycd AND af.acctno = rec.acctno;
     IF v_count = 0 THEN
          UPDATE TBLCI1138 SET deltd='Y' , errmsg =errmsg ||'Error: afacctno invalid!' WHERE autoid = rec.autoid;
          --RETURN;
     END IF;

ELSE
        UPDATE TBLCI1138 SET deltd='Y' , errmsg =errmsg ||'Error: Custody code invalid!' WHERE autoid = rec.autoid;
          --RETURN;
END IF ;


END LOOP;


    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
exception
when others then
    rollback;
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_FILE_TBLCI1138;


--select * from tblci1101
--5.
PROCEDURE PR_FILE_TBLCI1101(p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
v_count NUMBER;
BEGIN
v_count:=0;
--Cap nhat autoid
UPDATE tblci1101 SET autoid = seq_tblci1101.NEXTVAL;
--Check so luu ky
FOR REC IN
    (SELECT * FROM TBLCI1101 )
LOOP
IF rec.custodycd IS NOT NULL THEN
     SELECT count(custodycd) INTO v_count FROM cfmast WHERE custodycd = rec.custodycd;
     IF v_count = 0 THEN
          UPDATE TBLCI1101 SET deltd='Y' , errmsg =errmsg ||'Error: Custody code invalid!' WHERE autoid = rec.autoid;
          --RETURN;
     END IF;
     --Check so tieu khoan
     SELECT count(acctno) INTO v_count FROM afmast WHERE acctno = rec.acctno;
     IF v_count = 0 THEN
          UPDATE TBLCI1101 SET deltd='Y' , errmsg =errmsg ||'Error: afacctno invalid!' WHERE autoid = rec.autoid;
          --RETURN;
     END IF;
     --Check  tieu khoan co phai thuoc so Luu ky
     SELECT count(acctno) INTO v_count FROM afmast af, cfmast cf WHERE  af.custid = cf.custid
     AND cf.custodycd = rec.custodycd AND af.acctno = rec.acctno;
     IF v_count = 0 THEN
          UPDATE TBLCI1101 SET deltd='Y' , errmsg =errmsg ||'Error: afacctno invalid!' WHERE autoid = rec.autoid;
          --RETURN;
     END IF;

ELSE
        UPDATE TBLCI1101 SET deltd='Y' , errmsg =errmsg ||'Error: Custody code invalid!' WHERE autoid = rec.autoid;
          --RETURN;
END IF ;
END LOOP;

    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
exception
when others then
    rollback;
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_FILE_TBLCI1101;


--select * from tblci1187
--6.
PROCEDURE PR_FILE_TBLCI1187(p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
v_count NUMBER;
v_CUSTODIANTYP varchar2(1);
BEGIN

   v_count:=0;
   v_CUSTODIANTYP :='';
--Cap nhat autoid
UPDATE tblci1187 SET autoid = seq_tblci1187.NEXTVAL;
--Check so luu ky
FOR REC IN
    (SELECT * FROM TBLCI1187 )
LOOP
IF rec.custodycd IS NOT NULL THEN
     SELECT count(custodycd) INTO v_count FROM cfmast WHERE custodycd = rec.custodycd;
     IF v_count = 0 THEN
          UPDATE TBLCI1187 SET deltd='Y' , errmsg =errmsg ||'Error: Custody code invalid!' WHERE autoid = rec.autoid;
          --RETURN;
     END IF;
     --Check so tieu khoan
     SELECT count(acctno) INTO v_count FROM afmast WHERE acctno = rec.acctno;
     IF v_count = 0 THEN
          UPDATE TBLCI1187 SET deltd='Y' , errmsg =errmsg ||'Error: afacctno invalid!' WHERE autoid = rec.autoid;
          --RETURN;
     END IF;
     --Check  tieu khoan co phai thuoc so Luu ky
     SELECT count(acctno) INTO v_count FROM afmast af, cfmast cf WHERE  af.custid = cf.custid
     AND cf.custodycd = rec.custodycd AND af.acctno = rec.acctno;
     IF v_count = 0 THEN
          UPDATE TBLCI1187 SET deltd='Y' , errmsg =errmsg ||'Error: afacctno invalid!' WHERE autoid = rec.autoid;
          --RETURN;
     END IF;

     --check tai khoan co thuoc thanh vien khac hay khong
     select count(CUSTATCOM) into v_count from cfmast  where  CUSTATCOM ='Y' and custodycd = rec.custodycd;

     if v_count > 0 then
            UPDATE TBLCI1187 SET deltd='Y' , errmsg ='Error: Noi luu ky khong hop le!' WHERE autoid = rec.autoid;
     end if;

ELSE
        UPDATE TBLCI1187 SET deltd='Y' , errmsg =errmsg ||'Error: Custody code invalid!' WHERE autoid = rec.autoid;
          --RETURN;
END IF ;


END LOOP;

    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
exception
when others then
    rollback;
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_FILE_TBLCI1187;

--select * from tblse2287
--7.
PROCEDURE PR_FILE_TBLSE2287(p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
v_count NUMBER;
v_codeid varchar2(10);
BEGIN
v_codeid:= '';
v_count:=0;
--Cap nhat autoid
UPDATE tblse2287 SET autoid = seq_tblse2287.NEXTVAL;
-- CHECK MA CK
    FOR REC IN
    (SELECT * FROM TBLSE2287 )
    LOOP
    IF rec.symbol IS NOT NULL THEN
        select count(codeid) into v_count from sbsecurities WHERE symbol = rec.symbol;
        IF v_count = 0 THEN
          UPDATE TBLSE2287 SET deltd='Y' , errmsg =errmsg||'Error: Symbol not found!' WHERE autoid = rec.autoid;
          --RETURN;
        else
            SELECT codeid INTO v_codeid  FROM sbsecurities WHERE symbol = rec.symbol;

            IF length(v_codeid) > 0 THEN
        --Cap nhat codeid
                UPDATE TBLSE2287 SET codeid= v_codeid, acctno = afacctno || v_codeid  WHERE autoid = rec.autoid;
            ELSE
                UPDATE TBLSE2287 SET deltd='Y' , errmsg = errmsg || 'Error: Symbol invalid!' WHERE autoid = rec.autoid;
          --RETURN;
            END IF;

        END IF;
    ELSE
          UPDATE TBLSE2287 SET deltd='Y' , errmsg = errmsg || 'Error: Symbol invalid!' WHERE autoid = rec.autoid;
          --RETURN;
    END IF;
--Check so luu ky
IF rec.custodycd IS NOT NULL THEN
     SELECT count(custodycd) INTO v_count FROM cfmast WHERE custodycd = rec.custodycd;
     IF v_count = 0 THEN
          UPDATE TBLSE2287 SET deltd='Y' , errmsg =errmsg ||'Error: Custody code invalid!' WHERE autoid = rec.autoid;
          --RETURN;
     END IF;
     --Check so tieu
     SELECT count(acctno) INTO v_count FROM afmast WHERE acctno = rec.afacctno;
     IF v_count = 0 THEN
          UPDATE TBLSE2287 SET deltd='Y' , errmsg =errmsg ||'Error: afacctno invalid!' WHERE autoid = rec.autoid;
          --RETURN;
     END IF;
     --Check  tieu khoan co phai thuoc so Luu ky
     SELECT count(acctno) INTO v_count FROM afmast af, cfmast cf WHERE  af.custid = cf.custid
     AND cf.custodycd = rec.custodycd AND af.acctno = rec.afacctno;
     IF v_count = 0 THEN
          UPDATE TBLSE2287 SET deltd='Y' , errmsg =errmsg ||'Error: afacctno invalid!' WHERE autoid = rec.autoid;
          --RETURN;
     END IF;
      --check tai khoan co thuoc thanh vien khac hay khong
     select count(CUSTATCOM) into v_count from cfmast  where  CUSTATCOM ='Y' and custodycd = rec.custodycd;

     if v_count > 0 then
            UPDATE TBLSE2287 SET deltd='Y' , errmsg ='Error: Noi luu ky khong hop le!' WHERE autoid = rec.autoid;
     end if;


ELSE
        UPDATE TBLSE2287 SET deltd='Y' , errmsg =errmsg ||'Error: Custody code invalid!' WHERE autoid = rec.autoid;
          --RETURN;
END IF ;


END LOOP;

    -- KIEM TRA KHACH HANG DO DA TON TAI TRONG HE THONG CHUA

    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
exception
when others then
    rollback;
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_FILE_TBLSE2287;

--select * from tblse2203
--8.
PROCEDURE PR_FILE_TBLSE2203(p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
v_count NUMBER;
v_codeid varchar2(20);
V_QTTY NUMBER;
BEGIN
v_codeid:= '';
v_count:=0;
V_QTTY:=0;
--Cap nhat autoid
UPDATE TBLSE2203 SET autoid = seq_tblse2203.NEXTVAL;
-- CHECK MA CK
    FOR REC IN
    (SELECT * FROM TBLSE2203 )
    LOOP
      IF rec.symbol IS NOT NULL THEN
        select count(codeid) into v_count from sbsecurities WHERE symbol = rec.symbol;
        IF v_count = 0 THEN
          UPDATE TBLSE2203 SET deltd='Y' , errmsg =errmsg||'Error: Symbol not found!' WHERE autoid = rec.autoid;
          --RETURN;
        else
            SELECT codeid INTO v_codeid  FROM sbsecurities WHERE symbol = rec.symbol;

            IF length(v_codeid) > 0 THEN
        --Cap nhat codeid
                UPDATE TBLSE2203 SET codeid= v_codeid, acctno = afacctno || v_codeid  WHERE autoid = rec.autoid;
            ELSE
                UPDATE TBLSE2203 SET deltd='Y' , errmsg = errmsg || 'Error: Symbol invalid!' WHERE autoid = rec.autoid;
          --RETURN;
            END IF;

        END IF;
     ELSE
          UPDATE TBLSE2203 SET deltd='Y' , errmsg = errmsg || 'Error: Symbol invalid!' WHERE autoid = rec.autoid;
          --RETURN;
     END IF;
--Check so luu ky
   IF rec.afacctno IS NOT NULL THEN
     SELECT count(acctno) INTO v_count FROM afmast WHERE acctno = rec.afacctno;
     IF v_count = 0 THEN
        UPDATE TBLSE2203 SET deltd='Y' , errmsg =errmsg ||'Error: afacctno invalid!' WHERE autoid = rec.autoid;
          --RETURN;
     END IF;
     ELSE
        UPDATE TBLSE2203 SET deltd='Y' , errmsg =errmsg ||'Error: Custody code invalid!' WHERE autoid = rec.autoid;
          --RETURN;
   END IF ;

  --Moi TK, CK chi co mot dong
    select count(afacctno) into v_count from TBLSE2203 where afacctno = rec.afacctno
    and symbol = rec.symbol and qttytype = rec.qttytype and fileid = rec.fileid;
    IF v_count > 1 THEN
      UPDATE TBLSE2203 SET deltd='Y' , errmsg =errmsg ||'Error: Afacctno,symbol,qtty type  is duplicate!' WHERE afacctno = rec.afacctno
      and symbol = rec.symbol and qttytype = rec.qttytype and fileid = rec.fileid;
      --RETURN
    end if;

  --SO LUONG CK GIAI TOA

   V_QTTY:=0;
   SELECT NVL(SUM(QTTY),0)  INTO V_QTTY FROM SEMASTDTL WHERE DELTD='N' AND STATUS='N'
   AND QTTYTYPE = REC.qttytype AND   ACCTNO = REC.AFACCTNO ||v_codeid ;

   IF REC.TRADEAMT > V_QTTY THEN
        UPDATE TBLSE2203 SET deltd='Y' , errmsg =errmsg ||'Error: Quantty  invalid!' WHERE autoid = rec.autoid;
        --RETURN
   END IF;



END LOOP;

    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
exception
when others then
    rollback;
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_FILE_TBLSE2203;

PROCEDURE PR_FILE_TBLRE0380(P_TLID        IN VARCHAR2,
                            P_ERR_CODE    OUT VARCHAR2,
                            P_ERR_MESSAGE OUT VARCHAR2) IS
  V_COUNT      NUMBER;
  V_CFSTATUS   VARCHAR2(1);
  V_RESTATUS   VARCHAR2(1);
  V_AFACCTNO   VARCHAR2(10);
  V_CUSTID     VARCHAR2(10);
  V_CUSNAME    VARCHAR2(500);
  V_RECUSTID   VARCHAR2(30);
  V_REACTYPE   VARCHAR2(10);
  V_REFULLNAME VARCHAR2(100);
  V_REROLE VARCHAR2(10);
  V_REROLEOLD VARCHAR2(10);
  V_STRCUSTOMERID VARCHAR2(10);
  V_check0380 NUMBER;
  V_REACCTNOOLD VARCHAR(20);
BEGIN

  V_COUNT := 0;
  --Cap nhat autoid
  UPDATE TBLRE0380 SET AUTOID = SEQ_TBLRE0380.NEXTVAL, CUSTODYCD = UPPER(CUSTODYCD);
  --CHECK DU LIEU.
  FOR REC IN (SELECT AUTOID,
                     CUSTODYCD,
                     AFACCTNO,
                     CUSTNAME,
                     FROMDATE,
                     TODATE,
                     AMT,
                     REACCTNO,
                     RECUSTNAME,
                     REROLE,
                     ORGREACCTNO,
                     REACTYPE,
                     DELTD,
                     STATUS,
                     ERRMSG,
                     DES,
                     FILEID
                FROM TBLRE0380) LOOP
     -- Ktra ngay bat dau phai nho hon ngay ket thuc va ngay bat dau phai lon hoan bang ngya hien tai
                Select count(*) into V_COUNT
                from dual where rec.fromdate<rec.todate and rec.fromdate>=getcurrdate;
                if V_COUNT=0 then
                    UPDATE TBLRE0380
                       SET DELTD  = 'Y',
                           ERRMSG = ERRMSG || 'Error: Gia tri ngay khong hop le!'
                     WHERE CUSTODYCD = REC.CUSTODYCD;
                  end if;

        IF LENGTH(REC.FILEID) > 20 THEN
            UPDATE TBLRE0380
             SET DELTD  = 'Y',
                 ERRMSG = ERRMSG || 'Error: Cot FieldId khong dc lon hon 20 ky tu!'
           WHERE AUTOID = REC.AUTOID;
        END IF;

        IF LENGTH(REC.DES) > 200 THEN
            UPDATE TBLRE0380
             SET DELTD  = 'Y',
                 ERRMSG = ERRMSG || 'Error: Truong mieu ta khong dc qua 200 ky tu!'
           WHERE AUTOID = REC.AUTOID;
        END IF;

        --Ktra ma MG, ma KH co ton tai ko
        IF REC.REACCTNO IS NULL OR REC.CUSTODYCD IS NULL THEN
          UPDATE TBLRE0380
             SET DELTD  = 'Y',
                 ERRMSG = ERRMSG || 'Error: Ma moi gioi hoac so luu ky khong duoc de trong!'
           WHERE AUTOID = REC.AUTOID;
        ELSE

          --Ktra co khai bao trung kh trong file khong
          SELECT COUNT(1)
            INTO V_COUNT
            FROM TBLRE0380
           WHERE CUSTODYCD = REC.CUSTODYCD;

          IF NVL(V_COUNT, 0) > 1 THEN
            UPDATE TBLRE0380
               SET DELTD  = 'Y',
                   ERRMSG = ERRMSG || 'Error: So luu ky trung trong file!'
             WHERE CUSTODYCD = REC.CUSTODYCD;
          END IF;

      --Ktra trang thai Kh va MG co hop le khong  (trang thai hop le la A)
      BEGIN

        SELECT STATUS, CUSTID
          INTO V_CFSTATUS, V_CUSTID
          FROM CFMAST
         WHERE CUSTODYCD = REC.CUSTODYCD;

        SELECT COUNT(ACCTNO) INTO V_COUNT FROM AFMAST
        WHERE CUSTID = V_CUSTID AND STATUS = 'A';

      EXCEPTION
        WHEN OTHERS THEN
          V_CFSTATUS := 'C';
          V_COUNT := 0;
      END;

      BEGIN
        SELECT STATUS, CUSTID, ACTYPE
          INTO V_RESTATUS, V_RECUSTID, V_REACTYPE
          FROM REMAST
         WHERE ACCTNO = REC.REACCTNO;
      EXCEPTION
        WHEN OTHERS THEN
          V_RESTATUS := 'C';
      END;

      /*IF (V_CFSTATUS <> 'A' OR V_RESTATUS <> 'A') THEN*/
      IF (V_CFSTATUS <> 'A' AND V_COUNT = 0) THEN
        UPDATE TBLRE0380
           SET DELTD = 'Y', ERRMSG = ERRMSG || 'Error: Trang thai khach hang hoac trang thai moi gioi khong hop le!'
         WHERE AUTOID = REC.AUTOID;
      END IF;
        --Thong tin kh

        --Kiem tra quy dinh su dung loai hinh
        BEGIN
            SELECT RE.STATUS INTO V_RESTATUS FROM RECFDEF RE, RECFLNK LNK
            WHERE RE.REFRECFLNKID = LNK.AUTOID
            AND RE.REACTYPE = SUBSTR(REC.REACCTNO, 11, 4)
                AND LNK.CUSTID = SUBSTR(REC.REACCTNO, 1, 10)
                AND GETCURRDATE BETWEEN RE.EFFDATE AND RE.EXPDATE;
        EXCEPTION
        WHEN OTHERS THEN
          V_RESTATUS := 'C';
        END;

        IF (V_RESTATUS <> 'A') THEN
        UPDATE TBLRE0380
           SET DELTD = 'Y', ERRMSG = ERRMSG || 'Error: Trang thai quy dinh su dung loai hinh khong hop le hoac da het het han!'
         WHERE AUTOID = REC.AUTOID;
      END IF;

        SELECT SUBSTR(REC.REACCTNO, 1, 10) INTO V_RECUSTID FROM DUAL;

        SELECT MAX(AF.ACCTNO), MAX(CF.FULLNAME)
          INTO V_AFACCTNO, V_CUSNAME
          FROM AFMAST AF, CFMAST CF
         WHERE AF.CUSTID = CF.CUSTID
           AND AF.STATUS = 'A'
           AND CF.CUSTODYCD=REC.CUSTODYCD;
        --Thong tin MG
        if(V_CUSNAME is null) then
            UPDATE TBLRE0380
           SET DELTD = 'Y', ERRMSG = ERRMSG || 'Error: Chua khai bao tieu khoan hoac trang thai tieu khoan khong hop le!'
         WHERE AUTOID = REC.AUTOID;
        end if;

        BEGIN
            SELECT CFMAST.FULLNAME, TYP.REROLE
              INTO V_REFULLNAME, V_REROLE
              FROM RECFDEF RF,
                   RETYPE  TYP,
                   RECFLNK CF,
                   CFMAST
             WHERE RF.REACTYPE = TYP.ACTYPE
               AND RF.REFRECFLNKID = CF.AUTOID
               AND CF.CUSTID = CFMAST.CUSTID
               AND TYP.REROLE IN ('BM','RM')
               AND CF.CUSTID||RF.REACTYPE=rec.REACCTNO;

        EXCEPTION
        WHEN OTHERS THEN
          V_REFULLNAME := 'X';
          V_REROLE := 'X';
        END;

          IF V_REFULLNAME = 'X' AND V_REROLE = 'X' THEN
            UPDATE TBLRE0380
               SET DELTD = 'Y', ERRMSG = ERRMSG || 'Error: Khong tim thay thong tin moi gioi voi vai tro BM hoac RM!'
             WHERE AUTOID = REC.AUTOID;
          END IF;
          --Check cac dk cua 0380

          --Check cac thong tin moi gioi cu xem co trung vai tro la BM hoac RM voi thong tin moi hay khong
          BEGIN
            SELECT COUNT(REA.REACCTNO) INTO V_COUNT
                    FROM CFMAST CF, REAFLNK REA, AFMAST AF, RETYPE RET
                    WHERE AF.ACCTNO = REA.AFACCTNO
                        AND AF.CUSTID = CF.CUSTID
                        AND CF.CUSTODYCD = REC.CUSTODYCD
                        AND SUBSTR(REA.REACCTNO, 11, 4) = RET.ACTYPE
                        AND REA.STATUS = 'A'
                        AND RET.REROLE IN ('BM','RM')
                        AND RET.REROLE = V_REROLE;

            SELECT COUNT(REA.REACCTNO) INTO V_check0380
                    FROM CFMAST CF, REAFLNK REA, AFMAST AF, RETYPE RET
                    WHERE AF.ACCTNO = REA.AFACCTNO
                        AND AF.CUSTID = CF.CUSTID
                        AND CF.CUSTODYCD = REC.CUSTODYCD
                        AND SUBSTR(REA.REACCTNO, 11, 4) = RET.ACTYPE
                        AND REA.STATUS = 'A'
                        AND RET.REROLE IN ('BM','RM');
          EXCEPTION
          WHEN OTHERS THEN
            V_COUNT := 0;
            V_check0380 := 1;
          END;

          IF NVL(V_COUNT, 0) = 0 AND V_check0380 > 0 THEN
            UPDATE TBLRE0380
               SET DELTD = 'Y', ERRMSG = ERRMSG || 'Error: Vai tro cua moi gioi cu khong trung voi vai tro cua moi gioi moi!'
             WHERE AUTOID = REC.AUTOID;
          END IF;

        --Kiem tra xem khi chuyen thi co chuyen ve dung moi gioi cu hay khong
        BEGIN
            SELECT COUNT(REA.REACCTNO) INTO V_COUNT
                    FROM CFMAST CF, REAFLNK REA, AFMAST AF, RETYPE RET
                    WHERE AF.ACCTNO = REA.AFACCTNO
                        AND AF.CUSTID = CF.CUSTID
                        AND CF.CUSTODYCD = REC.CUSTODYCD
                        AND SUBSTR(REA.REACCTNO, 11, 4) = RET.ACTYPE
                        AND REA.STATUS = 'A'
                        AND RET.REROLE IN ('BM','RM')
                        AND RET.REROLE = V_REROLE
                        AND SUBSTR(REA.REACCTNO, 1, 10) = SUBSTR(REC.REACCTNO, 1, 10)
                        AND (REC.FROMDATE BETWEEN REA.FRDATE AND REA.TODATE
                        OR REC.TODATE BETWEEN REA.FRDATE AND REA.TODATE
                        OR (REC.FROMDATE < REA.FRDATE AND  REC.TODATE > REA.TODATE));
        EXCEPTION
          WHEN OTHERS THEN
            V_COUNT := 1;
          END;

        IF NVL(V_COUNT, 0) > 0 THEN
            UPDATE TBLRE0380
               SET DELTD = 'Y', ERRMSG = ERRMSG || 'Error: Khong duoc chuyen trong cung 1 moi gioi trong cung khoang thoi gian hieu luc'
             WHERE AUTOID = REC.AUTOID;
          END IF;

        --fill thong tin vao TBLRE0380
        UPDATE TBLRE0380
           SET AFACCTNO = V_AFACCTNO,
               CUSTNAME = V_CUSNAME,
               RECUSTID = V_RECUSTID,
               REACTYPE = V_REACTYPE,
               RECUSTNAME= V_REFULLNAME,
               REROLE=V_REROLE
         WHERE AUTOID = REC.AUTOID;


    END IF;

  END LOOP;
  PLOG.DEBUG(PKGCTX, ' finish ');
  P_ERR_CODE    := 0;
  P_ERR_MESSAGE := 'Sucessfull!';
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    P_ERR_CODE    := -100800; --File du lieu dau vao khong hop le
    P_ERR_MESSAGE := 'System error. Invalid file format';
    plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
    RETURN;
END PR_FILE_TBLRE0380;

PROCEDURE PR_APR_FILE_TBLRE0380(P_TLID        IN VARCHAR2,
                            P_ERR_CODE    OUT VARCHAR2,
                            P_ERR_MESSAGE OUT VARCHAR2) IS
    v_strDesc       varchar2(1000);
    v_strEN_Desc    varchar2(1000);
    l_err_param     varchar2(500);
    v_strCURRDATE   varchar2(20);
    V_STRCUSTOMERID varchar2(20);
    L_txnum         VARCHAR2(20);
    V_check0380     NUMBER;
    l_txmsg         tx.msg_rectype;
BEGIN

  SELECT TXDESC,EN_TXDESC into v_strDesc, v_strEN_Desc FROM  TLTX WHERE TLTXCD='0380';
        SELECT TO_DATE (varvalue, systemnums.c_date_format)
                   INTO v_strCURRDATE
                   FROM sysvar
                   WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    SELECT systemnums.C_BATCH_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO L_txnum
              FROM DUAL;
        l_txmsg.msgtype:='T';
        l_txmsg.local:='N';
        l_txmsg.tlid        := P_TLID;
        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                 SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
          INTO l_txmsg.wsname, l_txmsg.ipaddress
        FROM DUAL;
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txcompleted;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'AUTO';
        l_txmsg.reftxnum    := L_txnum;
        l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.BUSDATE:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.tltxcd:='0380';

        FOR REC in (
                      SELECT * FROM tblRE0380 tbl
                      WHERE nvl(tbl.deltd,'N') <> 'Y' and nvl(tbl.status,'A') <> 'C'
                )
            loop
                SELECT systemnums.C_BATCH_PREFIXED
                         || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                  INTO l_txmsg.txnum
                  FROM DUAL;
                    -- Tao giao dich 0380
                        --06    ?n ng?  C
                             l_txmsg.txfields ('06').defname   := 'TODATE';
                             l_txmsg.txfields ('06').TYPE      := 'C';
                             l_txmsg.txfields ('06').value      := rec.TODATE;
                        --30    Di?n gi?i   C
                             l_txmsg.txfields ('30').defname   := 'T_DESC';
                             l_txmsg.txfields ('30').TYPE      := 'C';
                             l_txmsg.txfields ('30').value      :=  NVL(REC.DES,v_strDesc);
                        --03    S? ti?u kho?n   C
                             l_txmsg.txfields ('03').defname   := 'ACCTNO';
                             l_txmsg.txfields ('03').TYPE      := 'C';
                             l_txmsg.txfields ('03').value      := rec.AFACCTNO;
                        --88    S? TK luu k?   C
                             l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                             l_txmsg.txfields ('88').TYPE      := 'C';
                             l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
                        --31    TKMG g?c nh? cham s? C
                             l_txmsg.txfields ('31').defname   := 'ORGREACCTNO';
                             l_txmsg.txfields ('31').TYPE      := 'C';
                             l_txmsg.txfields ('31').value      := '';
                        --02    Tham chi?u m?i?i    C
                             l_txmsg.txfields ('02').defname   := 'RECUSTID';
                             l_txmsg.txfields ('02').TYPE      := 'C';
                             l_txmsg.txfields ('02').value      := rec.RECUSTID;
                        --10    Gi?r? di?u ch?nh hoa h?ng   N
                             l_txmsg.txfields ('10').defname   := 'AMT';
                             l_txmsg.txfields ('10').TYPE      := 'N';
                             l_txmsg.txfields ('10').value      := rec.AMT;
                        --08    T?kho?n m?i?i   C
                             l_txmsg.txfields ('08').defname   := 'REACCTNO';
                             l_txmsg.txfields ('08').TYPE      := 'C';
                             l_txmsg.txfields ('08').value      := rec.REACCTNO;
                        --07    Lo?i h? m?i?i   C
                             l_txmsg.txfields ('07').defname   := 'REACTYPE';
                             l_txmsg.txfields ('07').TYPE      := 'C';
                             --l_txmsg.txfields ('07').value      := rec.REACCTNO;
                             l_txmsg.txfields ('07').value      := rec.REACTYPE;
                        --09    Vai tr?C
                             l_txmsg.txfields ('09').defname   := 'REROLE';
                             l_txmsg.txfields ('09').TYPE      := 'C';
                             l_txmsg.txfields ('09').value      := rec.REROLE;
                        --05    T? ng?  C
                             l_txmsg.txfields ('05').defname   := 'FRDATE';
                             l_txmsg.txfields ('05').TYPE      := 'C';
                             l_txmsg.txfields ('05').value      := rec.FROMDATE;
                        --90    T?ch? t?kho?n   C
                             l_txmsg.txfields ('90').defname   := 'CUSTNAME';
                             l_txmsg.txfields ('90').TYPE      := 'C';
                             l_txmsg.txfields ('90').value      := rec.CUSTNAME;
                        --91    T?m?i?i   C
                             l_txmsg.txfields ('91').defname   := 'RECUSTNAME';
                             l_txmsg.txfields ('91').TYPE      := 'C';
                             l_txmsg.txfields ('91').value      := rec.RECUSTNAME;
                     --Check cac dk cua 0380
                    --Lay thong tin kh
                   SELECT CUSTID
                    INTO V_STRCUSTOMERID
                    FROM CFMAST CF
                   WHERE CF.CUSTODYCD = rec.custodycd;
                  --Ki?m tra kh?du?c khai b?tr?ng
                  --M?i customer ch? c?i da 1 ngu?i gi?i thi?u, 01 BR hoac 01 AE & RM
                  SELECT COUNT(LNK.AUTOID)
                    INTO V_check0380
                    FROM REAFLNK LNK,
                             REMAST  ORGMST,
                             RETYPE  ORGTYP,
                             REMAST  RFMST,
                             RETYPE  RFTYP
                   WHERE LNK.STATUS = 'A'
                         AND ORGMST.ACTYPE = ORGTYP.ACTYPE
                         AND LNK.REACCTNO = ORGMST.ACCTNO
                         AND LNK.AFACCTNO = V_STRCUSTOMERID
                         AND (RFTYP.REROLE = ORGTYP.REROLE OR
                             (RFTYP.REROLE IN ('BM', 'RM') AND ORGTYP.REROLE IN ('BM', 'RM')))
                         AND RFMST.ACTYPE = RFTYP.ACTYPE
                         AND RFMST.ACCTNO = rec.reacctno
                                AND (  (LNK.FRDATE <=rec.fromdate  AND LNK.TODATE >= rec.fromdate)
                             OR (LNK.FRDATE <= rec.todate AND  lnk.todate >= rec.todate  ) );
                   IF  ( V_check0380 > 0) THEN
                           UPDATE TBLRE0380
                             SET DELTD = 'Y', ERRMSG = ERRMSG || 'Error: Dubplicate setup!'
                           WHERE AUTOID = REC.AUTOID;
                  END IF;
                    --Ki?m tra kh?cho ph?v?a l??i?i v?a l?ham s??
                   IF REC.REROLE='DG' THEN
                             select count(1)  INTO V_check0380
                             from reaflnk rl , retype rty , recflnk rcl
                              where substr(rl.reacctno, 11, 4) = rty.actype And rl.refrecflnkid = rcl.autoid
                                    and  rl.status='A' and rty.rerole <>'DG' and rl.afacctno= v_strCustomerID
                                    and rcl.custid =rec.RECUSTID;
                            IF  ( V_check0380 > 0) THEN
                                UPDATE TBLRE0380
                                 SET DELTD = 'Y', ERRMSG = ERRMSG || 'Error: Not have include RM, DG!'
                               WHERE AUTOID = REC.AUTOID;
                             END IF;
                       ELSE
                          select count(1)  INTO V_check0380
                          from reaflnk rl , retype rty , recflnk rcl
                           where substr(rl.reacctno, 11, 4) = rty.actype And rl.refrecflnkid = rcl.autoid
                          and rl.status='A' and rty.rerole ='DG' and rl.afacctno=  v_strCustomerID
                          and rcl.custid = rec.RECUSTID;
                                   IF  ( V_check0380 > 0) THEN
                                     UPDATE TBLRE0380
                                       SET DELTD = 'Y', ERRMSG = ERRMSG || 'Error: Not have include RM, DG!'
                                     WHERE AUTOID = REC.AUTOID;
                                   END IF;
                     END IF;
                         -----end check dk 0380-------
                          SELECT COUNT(1)  INTO V_check0380
                           FROM  tblRE0380 tbl
                      WHERE AUTOID = REC.AUTOID AND  nvl(deltd,'N') <> 'Y' ;
                      IF (V_check0380>0) then
                    BEGIN
                        IF txpks_#0380.fn_batchtxprocess (l_txmsg,p_err_code,l_err_param) <> systemnums.c_success
                        THEN
                           plog.error(pkgctx,'got error 0380: txpks_#0380.fn_batchtxprocess: ' || p_err_code);
                           ROLLBACK;
                        END IF;
                    END;
                    end if;
                    update TBLRE0380 set status = 'C' where autoid = rec.AUTOID;
                    insert into TBLRE0380HIST (select * from TBLRE0380 WHERE autoid = rec.AUTOID);
            end loop;
        ---insert into TBLRE0380HIST select * from TBLRE0380 WHERE fileid = p_txmsg.txfields(c_fileid).value ;
        ---delete from TBLRE0380 WHERE fileid = p_txmsg.txfields(c_fileid).value ;
  PLOG.DEBUG(PKGCTX, ' finish ');
  P_ERR_CODE    := 0;
  P_ERR_MESSAGE := 'Sucessfull!';
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    P_ERR_CODE    := -100800; --File du lieu dau vao khong hop le
    P_ERR_MESSAGE := 'System error. Invalid file format';
    RETURN;
END PR_APR_FILE_TBLRE0380;


PROCEDURE CAL_INSERT_CUSTOMERLIST (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
BEGIN

        /* Formatted on 22-Aug-2013 9:31:00 (QP5 v5.126) */
        INSERT INTO CUSTOMERLIST_HIST (autoid,
                                       fullname,
                                       address,
                                       email,
                                       phone,
                                       evaluation,
                                       resourceinfo,
                                       notes,
                                       importdate,
                                       backupdate)
            SELECT AUTOID, FULLNAME, ADDRESS, EMAIL, PHONE, EVALUATION, RESOURCEINFO, NOTES, IMPORTDATE, SYSDATE
                    FROM CUSTOMERLIST;
    DELETE FROM CUSTOMERLIST;
    /* Formatted on 22-Aug-2013 9:34:56 (QP5 v5.126) */
    INSERT INTO customerlist (autoid,
                          fullname,
                          address,
                          email,
                          phone,
                          evaluation,
                          resourceinfo,
                          notes,
                          importdate)
        SELECT seq_customerlist.nextval,FULLNAME, ADDRESS, EMAIL, PHONE, EVALUATION, RESOURCEINFO, NOTES, sysdate
                FROM CUSTOMERLISTTEMP;
     DELETE FROM CUSTOMERLISTTEMP;
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';


exception
when others then
    rollback;
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END CAL_INSERT_CUSTOMERLIST;

PROCEDURE PR_FILE_TBLCFCHGBRID(p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
    v_count     NUMBER;
BEGIN

    --Cap nhat autoid
    UPDATE tblcfchgbrid SET AUTOID = SEQ_tblcfchgbrid.NEXTVAL, CUSTODYCD = UPPER(CUSTODYCD);

    FOR rec IN (SELECT * FROM tblcfchgbrid)
    LOOP

        IF (LENGTH(REC.FILEID) > 20 OR REC.FILEID IS NULL) THEN
            UPDATE tblcfchgbrid
             SET DELTD  = 'Y',
                 ERRMSG = ERRMSG || 'Error: Cot FieldId khong duoc null hoac lon hon 20 ky tu!'
           WHERE AUTOID = REC.AUTOID;
        END IF;

        SELECT COUNT (*) INTO v_count FROM tblcfchgbrid WHERE custodycd = rec.custodycd;
        IF v_count > 1 THEN
            UPDATE tblcfchgbrid
             SET DELTD  = 'Y',
                 ERRMSG = ERRMSG || 'Error: So luu ky bi trung!'
           WHERE AUTOID = REC.AUTOID;
        END IF;

        SELECT COUNT (*) INTO v_count FROM cfmast WHERE custodycd = rec.custodycd;
        IF v_count = 0 THEN
            UPDATE tblcfchgbrid
             SET DELTD  = 'Y',
                 ERRMSG = ERRMSG || 'Error: So luu ky khong ton tai!'
           WHERE AUTOID = REC.AUTOID;
        END IF;

        SELECT COUNT (*) INTO v_count FROM cfmast WHERE custodycd = rec.custodycd AND brid = rec.obrid;
        IF v_count = 0 THEN
            UPDATE tblcfchgbrid
             SET DELTD  = 'Y',
                 ERRMSG = ERRMSG || 'Error: Ma chi nhanh cu khong dung!'
           WHERE AUTOID = REC.AUTOID;
        END IF;

        IF rec.obrid = rec.nbrid THEN
            UPDATE tblcfchgbrid
             SET DELTD  = 'Y',
                 ERRMSG = ERRMSG || 'Error: Ma chi nhanh cu trung ma chi nhanh moi!'
           WHERE AUTOID = REC.AUTOID;
        END IF;
        SELECT COUNT (*) INTO v_count FROM brgrp WHERE brid = rec.nbrid;
        IF v_count = 0 THEN
            UPDATE tblcfchgbrid
             SET DELTD  = 'Y',
                 ERRMSG = ERRMSG || 'Error: Ma chi nhanh moi khong ton tai!'
           WHERE AUTOID = REC.AUTOID;
        END IF;

        IF rec.txdate <> getcurrdate THEN
            UPDATE tblcfchgbrid
             SET DELTD  = 'Y',
                 ERRMSG = ERRMSG || 'Error: Ngay thuc hien phai la ngay hien tai!'
           WHERE AUTOID = REC.AUTOID;
        END IF;

        IF rec.txdate IS NULL THEN
            UPDATE tblcfchgbrid
             SET DELTD  = 'Y',
                 ERRMSG = ERRMSG || 'Error: Ngay thuc hien khong duoc de trong!'
           WHERE AUTOID = REC.AUTOID;
        END IF;

    END LOOP;

    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
EXCEPTION
WHEN OTHERS THEN
    ROLLBACK;
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_FILE_TBLCFCHGBRID;
-- begin --1.5.7.0
PROCEDURE PR_FILTERREGPRODUCT (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
v_count NUMBER;
v_basketid varchar2(100);
v_symbol varchar2(100);
v_IRATIO varchar2(50);
BEGIN
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
    update registerproduct_temp set autoid = SEQ_REGISTERPRODUCT_TEMp.Nextval;
    --check trang thai tai khoan
    update registerproduct_temp r
    set r.status ='E', deltd = 'Y',  r.ERRMSG = r.ERRMSG|| 'Trang thai tai khoan khong hop le. '
    where exists (select * from cfmast cf where cf.status in ('C', 'N') and cf.custodycd = r.custodycd);
    -- check ton tai thong tin tai khoan/tieu khoan
    update registerproduct_temp r
    set r.status ='E', deltd = 'Y', r.ERRMSG = r.ERRMSG|| 'Thong tin tai khoan khong hop le. '
    where not exists (select 1 from cfmast cf, afmast af
                      where cf.custid = af.custid and cf.custodycd = r.custodycd and af.acctno = r.afacctno);
    -- check trung tieu khoan
    update registerproduct_temp r
    set r.status ='E', deltd = 'Y',  r.ERRMSG = r.ERRMSG|| 'Trung thong tin. '
    where  exists (select 1 from registerproduct_temp
                      where afacctno= r.afacctno and autoid <> r.autoid);
    -- check loai hinh tieu khoan phai thuoc nhung loai hinh cho phep
    update registerproduct_temp r
    set r.status ='E', deltd = 'Y',  r.ERRMSG = r.ERRMSG|| 'Khong ton tai san pham. '
    where  not exists (select 1 from allcode where cdname ='PRODUCCODE' and cdtype ='LN' and cdval = r.producttype);
    -- check trang thai dang ky hien tai
    update registerproduct_temp r
    set r.status ='E', deltd = 'Y',  r.ERRMSG = r.ERRMSG|| 'Tieu khoan da dang ky. '
    where  exists (select 1 from RegisterProduc  where producCode = r.producttype and afacctno = r.afacctno );

    -- 1.5.7.3|MSBS-1931: Validate sbType in B, N
    UPDATE registerproduct_temp r
    set r.status ='E', deltd = 'Y',  r.ERRMSG = r.ERRMSG|| 'Loai lich khong hop le. '
    WHERE NVL(r.sbtype, 'x') NOT IN ('B','N');
exception
when others then
    rollback;
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_FILTERREGPRODUCT;

PROCEDURE PR_REGPRODUCT (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
l_txmsg               tx.msg_rectype;
p_errcode  varchar2 (200);
p_errmsg varchar2 (500);
p_fullname varchar2(200);
l_err_param varchar2(300);
v_strCURRDATE varchar2(20);
BEGIN
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
    --check trang thai tai khoan
    update registerproduct_temp r
    set r.status ='E', r.ERRMSG = r.ERRMSG|| 'Trang thai tai khoan khong hop le. '
    where   r.status <> 'E' and exists (select * from cfmast cf where cf.status in ('C', 'N') and cf.custodycd = r.custodycd);
    -- check ton tai thong tin tai khoan/tieu khoan
    update registerproduct_temp r
    set r.status ='E', r.ERRMSG = r.ERRMSG|| 'Thong tin tai khoan khong hop le. '
    where  r.status <> 'E' and  not exists (select 1 from cfmast cf, afmast af
                      where cf.custid = af.custid and cf.custodycd = r.custodycd and af.acctno = r.afacctno);
    -- check trung tieu khoan
    update registerproduct_temp r
    set r.status ='E', r.ERRMSG = r.ERRMSG|| 'Trung thong tin. '
    where  r.status <> 'E' and  exists (select 1 from registerproduct_temp
                      where afacctno= r.afacctno and autoid <> r.autoid);
    -- check loai hinh tieu khoan phai thuoc nhung loai hinh cho phep
    update registerproduct_temp r
    set r.status ='E', r.ERRMSG = r.ERRMSG|| 'Khong ton tai san pham. '
    where  r.status <> 'E' and  not exists (select 1 from allcode where cdname ='PRODUCCODE' and cdtype ='LN' and cdval = r.producttype);
    -- check trang thai dang ky hien tai
    update registerproduct_temp r
    set r.status ='E', r.ERRMSG = r.ERRMSG|| 'Tieu khoan da dang ky. '
    where  r.status <> 'E' and  exists (select 1 from RegisterProduc  where producCode = r.producttype and afacctno = r.afacctno );

    -- goi GD 0018
       SELECT TO_DATE (varvalue, systemnums.c_date_format) INTO v_strCURRDATE
       FROM sysvar
       WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
       l_txmsg.msgtype:='T';
       l_txmsg.local:='N';
       l_txmsg.tlid        := p_tlid;
       l_txmsg.offid       := p_tlid;
       SELECT SYS_CONTEXT ('USERENV', 'HOST'), SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
         INTO l_txmsg.wsname, l_txmsg.ipaddress
       FROM DUAL;
       l_txmsg.off_line    := 'N';
       l_txmsg.deltd       := txnums.c_deltd_txnormal;
       l_txmsg.txstatus    := txstatusnums.c_txcompleted;
       l_txmsg.msgsts      := '0';
       l_txmsg.ovrsts      := '0';
       l_txmsg.batchname   := 'DAY';
       l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
       l_txmsg.busdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
       l_txmsg.tltxcd:='0018';
    for rec in (select * from registerproduct_temp
               where status = 'P' and deltd = 'N' and autoid is not null) loop
       --Set txnum
       SELECT systemnums.C_OL_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO l_txmsg.txnum
              FROM DUAL;
       l_txmsg.brid        := substr(rec.afacctno,1,4);
       begin
       select c.fullname into p_fullname
       from cfmast c where custodycd = rec.custodycd;
       exception when others then
         p_fullname := '';
       end;
       --PRODUCCODE
        l_txmsg.txfields ('01').defname   := 'PRODUCCODE';
        l_txmsg.txfields ('01').TYPE      := 'C';
        l_txmsg.txfields ('01').VALUE     := rec.producttype;
        --1.5.7.3|MSBS-1931: Them SbType
        l_txmsg.txfields ('02').defname   := 'SBTYPE';
        l_txmsg.txfields ('02').TYPE      := 'C';
        l_txmsg.txfields ('02').VALUE     := rec.SBTYPE;
        --FULLNAME
        l_txmsg.txfields ('04').defname   := 'FULLNAME';
        l_txmsg.txfields ('04').TYPE      := 'C';
        l_txmsg.txfields ('04').VALUE     := p_fullname;
        --ACCTNO
        l_txmsg.txfields ('05').defname   := 'ACCTNO';
        l_txmsg.txfields ('05').TYPE      := 'C';
        l_txmsg.txfields ('05').VALUE     := rec.afacctno;
        --DESC
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').VALUE     := rec.description;
         --CUSTODYCD
        l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
        l_txmsg.txfields ('88').TYPE      := 'C';
        l_txmsg.txfields ('88').VALUE     := rec.custodycd;
        SAVEPOINT A;
        BEGIN
          IF txpks_#0018.fn_autotxprocess (l_txmsg,
                                           p_errcode,
                                           l_err_param
             ) <> systemnums.c_success
          THEN
             plog.debug (pkgctx, 'got error 0018: ' || p_errcode );
             ROLLBACK TO SAVEPOINT A;
             p_errmsg:=cspks_system.fn_get_errmsg(p_errcode);
             plog.error(pkgctx, 'Error:'  || p_errmsg);
             plog.setendsection(pkgctx, 'PR_REGPRODUCT');
             update registerproduct_temp r set status = 'E', deltd = 'Y',errmsg = p_errmsg
             where autoid = rec.autoid;
         ELSE
             update registerproduct_temp set status = 'C' where autoid = rec.autoid;

         END IF;
        END;
    end loop;
    --end GD0018
exception
when others then
    rollback;
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_REGPRODUCT;

PROCEDURE PR_FILTERDELPRODUCT (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
v_count NUMBER;
v_basketid varchar2(100);
v_symbol varchar2(100);
v_IRATIO varchar2(50);
BEGIN
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
    update CANCELPRODUCT_TEMP set autoid = SEQ_CANCELPRODUCT_TEMP.Nextval;
    --check trang thai tai khoan
    update CANCELPRODUCT_TEMP r
    set r.status ='E', deltd = 'Y',  r.ERRMSG = r.ERRMSG|| 'Trang thai tai khoan khong hop le. '
    where exists (select * from cfmast cf where cf.status in ('C', 'N') and cf.custodycd = r.custodycd);
    -- check ton tai thong tin tai khoan/tieu khoan
    update CANCELPRODUCT_TEMP r
    set r.status ='E', deltd = 'Y',  r.ERRMSG = r.ERRMSG|| 'Thong tin tai khoan khong hop le. '
    where not exists (select 1 from cfmast cf, afmast af
                      where cf.custid = af.custid and cf.custodycd = r.custodycd and af.acctno = r.afacctno);
    -- check trung tieu khoan
    update CANCELPRODUCT_TEMP r
    set r.status ='E', deltd = 'Y',  r.ERRMSG = r.ERRMSG|| 'Trung thong tin. '
    where  exists (select 1 from CANCELPRODUCT_TEMP
                      where afacctno= r.afacctno and autoid <> r.autoid);
    -- check loai hinh tieu khoan phai thuoc nhung loai hinh cho phep
    update CANCELPRODUCT_TEMP r
    set r.status ='E', deltd = 'Y',  r.ERRMSG = r.ERRMSG|| 'Khong ton tai san pham. '
    where  not exists (select 1 from allcode where cdname ='PRODUCCODE' and cdtype ='LN' and cdval = r.producttype);
    -- check trang thai dang ky hien tai
    update registerproduct_temp r
    set r.status ='E', deltd = 'Y',  r.ERRMSG = r.ERRMSG|| 'Tieu khoan chua dang ky. '
    where not exists (select 1 from RegisterProduc  where producCode = r.producttype and afacctno = r.afacctno );
exception
when others then
    rollback;
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_FILTERDELPRODUCT;

PROCEDURE PR_DELPRODUCT (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
l_txmsg               tx.msg_rectype;
p_errcode  varchar2 (200);
p_errmsg varchar2 (500);
p_fullname varchar2(200);
l_err_param varchar2(300);
v_strCURRDATE varchar2(20);
BEGIN
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
   --check trang thai tai khoan
    update CANCELPRODUCT_TEMP r
    set r.status ='E', r.ERRMSG = r.ERRMSG|| 'Trang thai tai khoan khong hop le. '
    where exists (select * from cfmast cf where cf.status in ('C', 'N') and cf.custodycd = r.custodycd);
    -- check ton tai thong tin tai khoan/tieu khoan
    update CANCELPRODUCT_TEMP r
    set r.status ='E', r.ERRMSG = r.ERRMSG|| 'Thong tin tai khoan khong hop le. '
    where not exists (select 1 from cfmast cf, afmast af
                      where cf.custid = af.custid and cf.custodycd = r.custodycd and af.acctno = r.afacctno);
    -- check trung tieu khoan
    update CANCELPRODUCT_TEMP r
    set r.status ='E', r.ERRMSG = r.ERRMSG|| 'Trung thong tin. '
    where  exists (select 1 from CANCELPRODUCT_TEMP
                      where afacctno= r.afacctno and autoid <> r.autoid);
    -- check loai hinh tieu khoan phai thuoc nhung loai hinh cho phep
    update CANCELPRODUCT_TEMP r
    set r.status ='E', r.ERRMSG = r.ERRMSG|| 'Khong ton tai san pham. '
    where  not exists (select 1 from allcode where cdname ='PRODUCCODE' and cdtype ='LN' and cdval = r.producttype);
    -- check trang thai dang ky hien tai
    update registerproduct_temp r
    set r.status ='E', r.ERRMSG = r.ERRMSG|| 'Tieu khoan chua dang ky. '
    where not exists (select 1 from RegisterProduc  where producCode = r.producttype and afacctno = r.afacctno );
    -- goi GD 0019
    SELECT TO_DATE (varvalue, systemnums.c_date_format) INTO v_strCURRDATE
       FROM sysvar
       WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
       l_txmsg.msgtype:='T';
       l_txmsg.local:='N';
       l_txmsg.tlid        := p_tlid;
       l_txmsg.offid       := p_tlid;
       SELECT SYS_CONTEXT ('USERENV', 'HOST'), SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
         INTO l_txmsg.wsname, l_txmsg.ipaddress
       FROM DUAL;
       l_txmsg.off_line    := 'N';
       l_txmsg.deltd       := txnums.c_deltd_txnormal;
       l_txmsg.txstatus    := txstatusnums.c_txcompleted;
       l_txmsg.msgsts      := '0';
       l_txmsg.ovrsts      := '0';
       l_txmsg.batchname   := 'DAY';
       l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
       l_txmsg.busdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
       l_txmsg.tltxcd:='0019';
    for rec in (select * from CANCELPRODUCT_TEMP
               where status = 'P' and deltd = 'N' and autoid is not null) loop
       --Set txnum
       SELECT systemnums.C_OL_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO l_txmsg.txnum
              FROM DUAL;
       l_txmsg.brid        := substr(rec.afacctno,1,4);
       begin
       select c.fullname into p_fullname
       from cfmast c where custodycd = rec.custodycd;
       exception when others then
         p_fullname := '';
       end;
       --PRODUCCODE
        l_txmsg.txfields ('01').defname   := 'PRODUCCODE';
        l_txmsg.txfields ('01').TYPE      := 'C';
        l_txmsg.txfields ('01').VALUE     := rec.producttype;
        --FULLNAME
        l_txmsg.txfields ('04').defname   := 'FULLNAME';
        l_txmsg.txfields ('04').TYPE      := 'C';
        l_txmsg.txfields ('04').VALUE     := p_fullname;
        --ACCTNO
        l_txmsg.txfields ('05').defname   := 'ACCTNO';
        l_txmsg.txfields ('05').TYPE      := 'C';
        l_txmsg.txfields ('05').VALUE     := rec.afacctno;
        --DESC
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').VALUE     := rec.description;
         --CUSTODYCD
        l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
        l_txmsg.txfields ('88').TYPE      := 'C';
        l_txmsg.txfields ('88').VALUE     := rec.custodycd;
        SAVEPOINT B;
        BEGIN
          IF txpks_#0019.fn_autotxprocess (l_txmsg,
                                           p_errcode,
                                           l_err_param
             ) <> systemnums.c_success
          THEN
             plog.debug (pkgctx, 'got error 0018: ' || p_errcode );
             ROLLBACK TO SAVEPOINT B;
             p_errmsg:=cspks_system.fn_get_errmsg(p_errcode);
             plog.error(pkgctx, 'Error:'  || p_errmsg);
             plog.setendsection(pkgctx, 'PR_REGPRODUCT');
             update CANCELPRODUCT_TEMP r set status = 'E', deltd = 'Y',errmsg = p_errmsg
             where autoid = rec.autoid;
         ELSE
             update CANCELPRODUCT_TEMP set status = 'C' where autoid = rec.autoid;

         END IF;
        END;
    end loop;
    --end GD0019
exception
when others then
    rollback;
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END PR_DELPRODUCT;
-- end 1.5.7.0
-- 1.5.7.6|iss:1970
PROCEDURE PR_FILTERCFTRFLIMIT (
     p_tlid          in varchar2,
     p_err_code      out varchar2,
     p_err_message   out varchar2
  )
IS
BEGIN
   -- Cap nhat dinh danh cho cac row
   UPDATE CFTRFLIMIT_TEMP SET autoid = SEQ_CFTRFLIMIT_TEMP.nextval;

   UPDATE CFTRFLIMIT_TEMP SET status = 'E', errmsg = 'CUSTODYCD bat buoc khong duoc de trong'
   WHERE status = 'P' AND (custodycd IS NULL OR length(TRIM(custodycd)) = 0);

   UPDATE CFTRFLIMIT_TEMP tmp SET status = 'E', errmsg = 'CUSTODYCD khong ton tai tren he thong'
   WHERE status = 'P'
   AND NOT EXISTS (SELECT cf.custodycd FROM cfmast cf WHERE cf.custodycd = tmp.custodycd);

   UPDATE CFTRFLIMIT_TEMP tmp SET status = 'E', errmsg = 'CUSTODYCD trang thai khong hop le'
   WHERE status = 'P'
   AND EXISTS (SELECT cf.custodycd FROM cfmast cf WHERE cf.custodycd = tmp.custodycd AND cf.status IN ('C', 'N'));

   UPDATE CFTRFLIMIT_TEMP SET status = 'E', errmsg = 'MAXTOTALTRFAMT phai la so nguyen va lon hon hoac bang 0'
   WHERE status = 'P' AND (maxtotaltrfamt < 0 OR MOD(maxtotaltrfamt, 1) <> 0);

   UPDATE CFTRFLIMIT_TEMP SET status = 'E', errmsg = 'MAXTOTALTRFAMT_1 phai la so nguyen va lon hon hoac bang 0'
   WHERE status = 'P' AND (maxtotaltrfamt_1 < 0 OR MOD(maxtotaltrfamt_1, 1) <> 0);

   UPDATE CFTRFLIMIT_TEMP SET status = 'E', errmsg = 'REMAXTRFAMT phai la so nguyen va lon hon hoac bang 0'
   WHERE status = 'P' AND (remaxtrfamt < 0 OR MOD(remaxtrfamt, 1) <> 0);

   UPDATE CFTRFLIMIT_TEMP SET status = 'E', errmsg = 'MAXTRFAMT phai la so nguyen va lon hon hoac bang 0'
   WHERE status = 'P' AND (maxtrfamt < 0 OR MOD(maxtrfamt, 1) <> 0);

   UPDATE CFTRFLIMIT_TEMP SET status = 'E', errmsg = 'MAXTRFCNT phai la so nguyen va lon hoac bang hon 0'
   WHERE status = 'P' AND (maxtrfcnt < 0 OR MOD(maxtrfcnt, 1) <> 0);

   p_err_code := 0;
   p_err_message:= 'Sucessfull!';
EXCEPTION WHEN OTHERS THEN
   rollback;
   p_err_code := -100800;
   p_err_message:= 'System error. Invalid file format';
END;

--1.7.1.1|iss:2222
PROCEDURE PR_INT_CHANGE(p_tlid in varchar2, p_err_code out varchar2, p_err_message out varchar2)
IS
v_busdate date;
v_count   number;
BEGIN
  SELECT to_date(varvalue,systemnums.c_date_format) INTO v_busdate
  FROM sysvar
  WHERE varname = 'CURRDATE' AND grname = 'SYSTEM';
  update tblintchange
  set autoid = seq_tblintchange.nextval;
  update tblintchange
  set txtime = to_char(sysdate,systemnums.C_TIME_FORMAT);
  --plog.debug(pkgctx,'bat dau cap nhat thong bao loi');
  UPDATE TBLINTCHANGE SET TLID = p_tlid, txdate = v_busdate;
  update tblintchange
  set deltd='Y', errmsg = 'Thieu du lieu: ' ||
        CASE
            WHEN fileid IS NULL OR fileid = '' THEN ' [FILEID] trong '
            WHEN custodycd IS NULL OR custodycd = '' THEN ' [CUSTODYCD] trong '
            WHEN AFACCTNO IS NULL OR AFACCTNO = '' THEN ' [AFACCTNO] trong '
            WHEN LNTYPE IS NULL OR LNTYPE = '' THEN ' [LNTYPE] trong '
            WHEN RATE1A IS NULL OR RATE1A = '' THEN ' [RATE1A] trong '
            WHEN RATE2A IS NULL OR RATE2A = '' THEN ' [RATE2A] trong '
            WHEN RATE3A IS NULL OR RATE3A = '' THEN ' [RATE3A] trong '
            WHEN CFRATE1A IS NULL OR CFRATE1A = '' THEN ' [CFRATE1A] trong '
            WHEN CFRATE2A IS NULL OR CFRATE2A = '' THEN ' [CFRATE2A] trong '
            WHEN CFRATE3A IS NULL OR CFRATE3A = '' THEN ' [CFRATE3A] trong '
            WHEN AUTOAPPLYNEW IS NULL OR AUTOAPPLYNEW = '' THEN ' [AUTOAPPLYNEW] trong '
            WHEN ALLLNSCHD IS NULL OR ALLLNSCHD = '' THEN ' [ALLLNSCHD] trong '
            WHEN FDATE IS NULL OR FDATE = '' THEN ' [FDATE] trong '
            WHEN TDATE IS NULL OR TDATE = '' THEN ' [TDATE] trong '
            WHEN CUSTODYCD NOT IN (SELECT CUSTODYCD FROM CFMAST WHERE STATUS='A' ) THEN ' [CUSTODYCD] khong hop le '
            WHEN AFACCTNO NOT IN (SELECT AFACCTNO FROM AFMAST WHERE STATUS ='A') THEN ' [AFACCTNO] khong hop le '
            WHEN LNTYPE NOT IN (SELECT ACTYPE FROM LNTYPE WHERE STATUS ='Y' AND APPRV_STS = 'A') THEN ' [LNTYPE] khong hop le '
            WHEN AUTOAPPLYNEW <> 'N' THEN ' [AUTOAPPLYNEW] khong hop le '
            WHEN ALLLNSCHD NOT IN ('Y','N') THEN ' [ALLLNSCHD] khong hop le '
            WHEN RATE1A < 0 THEN ' [RATE1A] < 0 '
            WHEN RATE2A < 0 THEN ' [RATE2A] < 0 '
            WHEN RATE3A < 0 THEN ' [RATE3A] < 0 '
            WHEN CFRATE1A < 0 THEN ' [CFRATE1A] < 0 '
            WHEN CFRATE2A < 0 THEN ' [CFRATE2A] < 0 '
            WHEN CFRATE3A < 0 THEN ' [CFRATE3A] < 0 '
            WHEN to_date(FDATE,'DD/MM/RRRR') > TO_DATE(TDATE,'DD/MM/RRRR') THEN ' FDATE, TDATE khong hop le  '
            ELSE 'Chua dinh nghia'
        END
  WHERE
  fileid IS NULL OR fileid = ''
  OR custodycd IS NULL OR custodycd = ''
  OR AFACCTNO IS NULL OR AFACCTNO = ''
  OR LNTYPE IS NULL OR LNTYPE = ''
  OR RATE1A IS NULL OR RATE1A = ''
  OR RATE2A IS NULL OR RATE2A = ''
  OR RATE3A IS NULL OR RATE3A = ''
  OR CFRATE1A IS NULL OR CFRATE1A = ''
  OR CFRATE2A IS NULL OR CFRATE2A = ''
  OR CFRATE3A IS NULL OR CFRATE3A = ''
  OR AUTOAPPLYNEW IS NULL OR AUTOAPPLYNEW = ''
  OR ALLLNSCHD IS NULL OR ALLLNSCHD = ''
  OR FDATE IS NULL OR FDATE = ''
  OR TDATE IS NULL OR TDATE = ''
  OR CUSTODYCD NOT IN (SELECT CUSTODYCD FROM CFMAST WHERE STATUS='A' )
  OR AFACCTNO NOT IN (SELECT AFACCTNO FROM AFMAST WHERE STATUS ='A')
  OR LNTYPE NOT IN (SELECT ACTYPE FROM LNTYPE WHERE STATUS ='Y' AND APPRV_STS = 'A')
  OR AUTOAPPLYNEW <> 'N'
  OR ALLLNSCHD NOT IN ('Y','N')
  OR to_date(FDATE,'DD/MM/RRRR') > TO_DATE(TDATE,'DD/MM/RRRR')
  OR RATE1A < 0 OR RATE2A<0 OR RATE3A <0 OR CFRATE1A <0 OR CFRATE2A <0 OR CFRATE3A<0;

  update tblintchange set deltd='Y', errmsg ='Thong tin khach hang khong hop le'
  where autoid not in (select tb.autoid
                      from tblintchange tb, cfmast cf, afmast af, aftype at,
                           (SELECT  * FROM afidtype WHERE objname='LN.LNTYPE' ) afi
                      where tb.custodycd = cf.custodycd
                      and tb.afacctno = af.acctno
                      and cf.custid = af.custid
                      and af.actype = at.actype
                      AND at.actype=afi.aftype(+) --1.7.2.7 join ca lntype phu
                      AND( tb.lntype = at.lntype OR tb.lntype=afi.actype )
                      );
  --check trung du lieu
  for j in (select CUSTODYCD, LNTYPE, AFACCTNO
          from tblintchange
          group by CUSTODYCD, AFACCTNO,LNTYPE
          having count(1) > 1)
  loop
    for k in (select * from tblintchange
             where custodycd = j.custodycd and lntype = j.lntype and afacctno=j.afacctno)
    loop
      update tblintchange set deltd ='Y',errmsg = 'Trung du lieu'
      where ((fdate between k.fdate and k.tdate)
      or (tdate between k.fdate and k.tdate)
      or (fdate > k.fdate and tdate < k.tdate)
      or (fdate < k.fdate and tdate > k.tdate))
      and autoid <> k.autoid
      and autoid in (select autoid from tblintchange where custodycd = j.custodycd and lntype = j.lntype and afacctno=j.afacctno);
    end loop;
  end loop;

  -- check du lieu co trong bang hist?
  --trong cung 1 ngay lay du lieu lan import gan nhat
  --them dong moi co fdate=v_busdate
  update tblintchangehist set status = 'C'
  where autoid in (select ih.autoid
                  from tblintchange i, tblintchangehist ih
                  where (i.txdate = ih.txdate
                        or (i.txdate >= v_busdate and i.fdate<=ih.tdate)
                        )
                  and i.custodycd = ih.custodycd
                  and i.afacctno = ih.afacctno
                  and i.lntype = ih.lntype
				  and ih.status = 'A');

  --luu du lieu vao bang hist
  insert into tblintchangehist
  select * from tblintchange where status='A' and deltd <> 'Y';

  EXCEPTION
   WHEN OTHERS THEN
       ROLLBACK;
         plog.setendsection(pkgctx, 'PR_INT_CHANGE');
         p_err_code := errnums.C_SYSTEM_ERROR;
         p_err_message := 'SYSTEM_ERROR';
END PR_INT_CHANGE;
--end 2222
-- MSBS-2235 1.7.3
PROCEDURE PR_CFLN_PREFERENTIAL(p_tlid in varchar2, p_err_code out varchar2, p_err_message out varchar2)
IS
v_busdate date;
v_count   number;
BEGIN
  SELECT to_date(varvalue,systemnums.c_date_format) INTO v_busdate
  FROM sysvar
  WHERE varname = 'CURRDATE' AND grname = 'SYSTEM';
  update TBCFPREFERENTIAL
  set autoid = TBCFPREFERENTIAL_SEQ.nextval;
  --plog.debug(pkgctx,'bat dau cap nhat thong bao loi');
  UPDATE TBCFPREFERENTIAL SET TLID = p_tlid, txdate = v_busdate;
  update TBCFPREFERENTIAL
  set deltd='Y', errmsg = 'Thieu du lieu: ' ||
        CASE
            WHEN fileid IS NULL OR fileid = '' THEN ' [FILEID] trong '
            WHEN FDATE IS NULL OR FDATE = '' THEN ' [FDATE] trong '
            WHEN TDATE IS NULL OR TDATE = '' THEN ' [TDATE] trong '
            WHEN LNID IS NULL OR LNID = '' THEN ' [LNID] trong '
            WHEN CUSTODYCD  IS NULL OR CUSTODYCD  = '' THEN ' [CUSTODYCD] trong '
            WHEN AFACCTNO IS NULL OR AFACCTNO = '' THEN ' [AFACCTNO] trong '
            WHEN LNTYPE IS NULL OR LNTYPE = '' THEN ' [LNTYPE] trong '
            WHEN CUSTODYCD NOT IN (SELECT CUSTODYCD FROM CFMAST WHERE STATUS='A' ) THEN ' [CUSTODYCD] khong hop le '
            WHEN AFACCTNO NOT IN (SELECT ACCTNO FROM AFMAST WHERE STATUS ='A') THEN ' [AFACCTNO] khong hop le '
            WHEN LNTYPE NOT IN (SELECT ACTYPE FROM LNTYPE WHERE STATUS ='Y' AND APPRV_STS = 'A' and actype in (
                                                                                                            select ln.actype
                                                                                                                from lntype ln , aftype af, afidtype ai
                                                                                                                where ln.actype=ai.actype
                                                                                                                and af.actype=ai.aftype
                                                                                                                and ai.objname='LN.LNTYPE')) THEN ' [LNTYPE] khong hop le '
            WHEN LNID NOT IN (SELECT LNID FROM LNTYPEXT WHERE  APPRV_STS = 'A') THEN ' [LNID] khong hop le '
            WHEN FDATE > TDATE THEN ' FDATE, TDATE khong hop le  '
            ELSE 'Chua dinh nghia'
        END
  WHERE
  fileid IS NULL OR fileid = ''
  OR custodycd IS NULL OR custodycd = ''
  OR AFACCTNO IS NULL OR AFACCTNO = ''
  OR FDATE IS NULL OR FDATE = ''
  OR TDATE IS NULL OR TDATE = ''
  OR LNID IS NULL OR LNID = ''
  OR CUSTODYCD NOT IN (SELECT CUSTODYCD FROM CFMAST WHERE STATUS='A' )
  OR AFACCTNO NOT IN (SELECT ACCTNO FROM AFMAST WHERE STATUS ='A')
  OR LNTYPE NOT IN (SELECT ACTYPE FROM LNTYPE WHERE STATUS ='Y' AND APPRV_STS = 'A')
  OR LNID NOT IN (SELECT LNID FROM LNTYPEXT WHERE APPRV_STS = 'A')
  OR FDATE > TDATE;
---
  update TBCFPREFERENTIAL set deltd='Y', errmsg ='Thong tin khach hang khong hop le'
  where autoid not in (select tb.autoid
                      from TBCFPREFERENTIAL tb, cfmast cf, afmast af, aftype at,
                           (SELECT  * FROM afidtype WHERE objname='LN.LNTYPE' ) afi
                      where tb.custodycd = cf.custodycd
                      and tb.afacctno = af.acctno
                      and cf.custid = af.custid
                      and af.actype = at.actype
                      AND at.actype=afi.aftype(+)
                      AND( tb.lntype = at.lntype OR tb.lntype=afi.actype )
                                         );
--check trung du lieu
  for j in (select CUSTODYCD, LNTYPE, AFACCTNO
          from TBCFPREFERENTIAL
          group by CUSTODYCD, AFACCTNO,LNTYPE
          /*having count(1) > =1*/)
  loop
    for k in (select * from ( select * from TBCFPREFERENTIAL
                              union all
                              select * from TBCFPREFERENTIALHIST where status='P' and deltd <> 'Y')
             where custodycd = j.custodycd and lntype = j.lntype and afacctno=j.afacctno)
    loop
      update TBCFPREFERENTIAL set deltd ='Y',errmsg = 'Trung du lieu'
      where ((fdate between k.fdate and k.tdate)
      or (tdate between k.fdate and k.tdate)
      or (fdate > k.fdate and tdate < k.tdate)
      or (fdate < k.fdate and tdate > k.tdate))
      and autoid <> k.autoid
      and custodycd = j.custodycd and lntype = j.lntype and afacctno=j.afacctno;
    end loop;
  end loop;
--check trung du lieu
  for j2 in (select CF.CUSTODYCD, CF.LNTYPE, CF.AFACCTNO
          from CFPREFERENTIAL CF, TBCFPREFERENTIAL TB
          WHERE CF.CUSTODYCD= TB.CUSTODYCD
          AND TB.AFACCTNO=CF.AFACCTNO
          AND CF.LNTYPE=TB.LNTYPE
          AND CF.LNID=TB.LNID
          AND CF.STATUS='A'
          GROUP BY CF.CUSTODYCD, CF.LNTYPE, CF.AFACCTNO
           --having count(1) > 1
          )
  loop
    for k2 in (select * from CFPREFERENTIAL
             where custodycd = j2.custodycd and lntype = j2.lntype and afacctno=j2.afacctno AND status='A')
    loop
      update TBCFPREFERENTIAL set deltd ='Y',errmsg = 'Trung du lieu'
      where ((fdate between k2.fdate and k2.tdate)
      or (tdate between k2.fdate and k2.tdate)
      or (fdate > k2.fdate and tdate < k2.tdate)
      or (fdate < k2.fdate and tdate > k2.tdate))
      and autoid <> k2.autoid
      and custodycd = j2.custodycd and lntype = j2.lntype and afacctno=j2.afacctno;
    end loop;
  end loop;

  update TBCFPREFERENTIALHIST set status = 'C'
  where autoid in (select ih.autoid
                  from TBCFPREFERENTIAL i, TBCFPREFERENTIALHIST ih
                  where (i.txdate = ih.txdate
                        or (i.txdate >= v_busdate and i.fdate<=ih.tdate)
                        )
                  and i.custodycd = ih.custodycd
                  and i.afacctno = ih.afacctno
                  and i.lntype = ih.lntype
                  and ih.status='A');

  --luu du lieu vao bang hist
  insert into TBCFPREFERENTIALHIST
  select * from TBCFPREFERENTIAL where status='P' and deltd <> 'Y';
---
  EXCEPTION
   WHEN OTHERS THEN
       ROLLBACK;
         plog.setendsection(pkgctx, 'PR_CFLN_PREFERENTIAL');
         p_err_code := errnums.C_SYSTEM_ERROR;
         p_err_message := 'SYSTEM_ERROR';
END PR_CFLN_PREFERENTIAL;
--
--

PROCEDURE PR_CFLN_PREFERENTIAL_APPROVE(p_tlid in varchar2, p_err_code out varchar2, p_err_message out varchar2)
IS
v_busdate date;
v_count   number;
BEGIN
   FOR rec_ln  IN
     (
         SELECT * FROM TBCFPREFERENTIALHIST WHERE STATUS='P' AND DELTD <> 'Y'
     )
   LOOP
     INSERT INTO CFPREFERENTIAL ( AUTOID,CUSTODYCD,AFACCTNO,LNTYPE,LNID,FDATE,TDATE,STATUS)
     VALUES (rec_ln.AUTOID,rec_ln.CUSTODYCD,rec_ln.AFACCTNO,rec_ln.LNTYPE,rec_ln.LNID,rec_ln.FDATE,rec_ln.TDATE,'A');

    --UPDATE TBCFPREFERENTIAL SET STATUS='A' WHERE AUTOID = rec_ln.AUTOID;
    UPDATE TBCFPREFERENTIALHIST SET STATUS='A', APPROVEID = p_tlid  WHERE AUTOID = rec_ln.AUTOID;
    /*INSERT INTO TBCFPREFERENTIALHIST
    SELECT * FROM TBCFPREFERENTIAL WHERE STATUS='A' AND AUTOID= rec_ln.AUTOID;*/
  END LOOP;


  EXCEPTION
   WHEN OTHERS THEN
       ROLLBACK;
         plog.setendsection(pkgctx, 'PR_CFLN_PREFERENTIAL_APPROVE');
         p_err_code := errnums.C_SYSTEM_ERROR;
         p_err_message := 'SYSTEM_ERROR';

END PR_CFLN_PREFERENTIAL_APPROVE;
---- MSBS-2235 1.7.1.3

PROCEDURE PR_CFTRFLIMIT (
     p_tlid          in varchar2,
     p_err_code      out varchar2,
     p_err_message   out varchar2
  )
IS
   l_txmsg    tx.msg_rectype;
   v_cdate    date;
   v_errcode  varchar2(20);
   v_errparam varchar2(300);
BEGIN
   UPDATE CFTRFLIMIT_TEMP SET status = 'E', errmsg = 'CUSTODYCD bat buoc khong duoc de trong'
   WHERE status = 'P' AND (custodycd IS NULL OR length(TRIM(custodycd)) = 0);

   UPDATE CFTRFLIMIT_TEMP tmp SET status = 'E', errmsg = 'CUSTODYCD khong ton tai tren he thong'
   WHERE status = 'P'
   AND NOT EXISTS (SELECT cf.custodycd FROM cfmast cf WHERE cf.custodycd = tmp.custodycd);

   -- Thuc hien duyet
   v_cdate           := getcurrdate;
   l_txmsg.msgtype   := 'T';
   l_txmsg.local     := 'N';
   l_txmsg.tlid      := p_tlid;
   l_txmsg.off_line  := 'N';
   l_txmsg.deltd     := txnums.c_deltd_txnormal;
   l_txmsg.txstatus  := txstatusnums.c_txcompleted;
   l_txmsg.msgsts    := '0';
   l_txmsg.ovrsts    := '0';
   l_txmsg.batchname := 'DAY';
   l_txmsg.brid      := '0001';
   l_txmsg.txdate    := v_cdate;
   l_txmsg.BUSDATE   := v_cdate;
   l_txmsg.tltxcd    := '0012';

   select txdesc into l_txmsg.txdesc from tltx where tltxcd = '0012';
   select SYS_CONTEXT ('USERENV', 'HOST'), SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
   into l_txmsg.wsname, l_txmsg.ipaddress
   from DUAL;

   FOR rec IN (
      SELECT tmp.*, cf.fullname FROM CFTRFLIMIT_TEMP tmp, cfmast cf
      WHERE tmp.status = 'P' AND tmp.custodycd = cf.custodycd
   ) LOOP
      -- Create txnum
      select systemnums.C_BATCH_PREFIXED || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
      into l_txmsg.txnum from DUAL;
      -- Reset txime
      l_txmsg.txtime    := to_char(sysdate, 'hh24:mi:ss');

      -- Set field
      l_txmsg.txfields ('88').defname := 'CUSTODYCD';
      l_txmsg.txfields ('88').type    := 'C';
      l_txmsg.txfields ('88').value   := rec.custodycd;

      l_txmsg.txfields ('31').defname := 'FULLNAME';
      l_txmsg.txfields ('31').type    := 'C';
      l_txmsg.txfields ('31').value   := rec.fullname;

      l_txmsg.txfields ('14').defname := 'MAXTOTALTRFAMT';
      l_txmsg.txfields ('14').type    := 'N';
      l_txmsg.txfields ('14').value   := rec.maxtotaltrfamt;

      l_txmsg.txfields ('23').defname := 'MAXTOTALTRFAMT_1';
      l_txmsg.txfields ('23').type    := 'N';
      l_txmsg.txfields ('23').value   := rec.maxtotaltrfamt_1;

      l_txmsg.txfields ('15').defname := 'REMAXTRFAMT';
      l_txmsg.txfields ('15').type    := 'N';
      l_txmsg.txfields ('15').value   := rec.remaxtrfamt;

      l_txmsg.txfields ('16').defname := 'MAXTRFAMT';
      l_txmsg.txfields ('16').type    := 'N';
      l_txmsg.txfields ('16').value   := rec.maxtrfamt;

      l_txmsg.txfields ('17').defname := 'MAXTRFCNT';
      l_txmsg.txfields ('17').type    := 'N';
      l_txmsg.txfields ('17').value   := rec.maxtrfcnt;

      l_txmsg.txfields ('30').defname := 'DESC';
      l_txmsg.txfields ('30').type    := 'C';
      l_txmsg.txfields ('30').value   := '';

      begin
         if txpks_#0012.fn_batchtxprocess (l_txmsg, v_errcode, v_errparam) <> systemnums.c_success then
            update CFTRFLIMIT_TEMP set status = 'E', errmsg = v_errcode where autoid = rec.autoid;
         else
            update CFTRFLIMIT_TEMP set status = 'A' where autoid = rec.autoid;
         end if;
      end;
   END LOOP;

   p_err_code := 0;
   p_err_message:= 'Sucessfull!';
EXCEPTION WHEN OTHERS THEN
   rollback;
   p_err_code := -100800;
   p_err_message:= 'System error. Invalid file format';
END;


--KB 20200908
PROCEDURE PR_FILE_CFCOMPARE2FILE(p_tlid in varchar2, p_err_code out varchar2, p_err_message out varchar2)
IS
v_count         number;
v_count1        number;
L_FULLNAME    VARCHAR2(1000);
L_CUSTODYCD   VARCHAR2(1000);
L_IDCODE      VARCHAR2(1000);
L_ADDRESS     VARCHAR2(1000);
L_SEX         VARCHAR2(1000);
L_MARRIED     VARCHAR2(1000);
L_MOBILE      VARCHAR2(1000);
L_OPNDATE     DATE;

BEGIN
    FOR rec IN
    (
        SELECT * FROM CFCOMPARE2FILE WHERE F_IDCODE IS NOT NULL
    )
    LOOP
    BEGIN
        SELECT count(*) INTO v_count FROM cfmast WHERE instr (rec.f_idcode,idcode ) > 0 AND status <> 'C' AND LENGTH(idcode) >= 6;
        IF v_count >= 1 THEN
            SELECT max(FULLNAME) FULLNAME, max(CUSTODYCD) CUSTODYCD, max(CASE WHEN country <> '234' THEN nvl(tradingcode,idcode) ELSE idcode END ) IDCODE, max(ADDRESS) ADDRESS, max(SEX) SEX, max(MARRIED) MARRIED, max(MOBILE) MOBILE, max(OPNDATE) OPNDATE
                INTO L_FULLNAME, L_CUSTODYCD, L_IDCODE, L_ADDRESS, L_SEX, L_MARRIED, L_MOBILE, L_OPNDATE
            FROM cfmast
            WHERE instr (rec.f_idcode,idcode ) > 0 AND status <> 'C' AND LENGTH(idcode) >= 6;
            UPDATE CFCOMPARE2FILE SET status = 'Y',
                    FULLNAME = l_fullname,
                    CUSTODYCD = L_CUSTODYCD,
                    IDCODE = L_IDCODE,
                    ADDRESS = L_ADDRESS,
                    SEX = L_SEX,
                    MARRIED = L_MARRIED,
                    MOBILE = L_MOBILE,
                    OPNDATE = L_OPNDATE
            WHERE f_autoid = rec.f_autoid;
            --COMMIT;
        END IF;
      EXCEPTION
       WHEN OTHERS THEN
           UPDATE CFCOMPARE2FILE SET status = 'Loi idcode' WHERE f_autoid = rec.f_autoid;
           --COMMIT;
    END;
    END LOOP;
    --COMMIT;
    FOR rec1 IN
    (
        SELECT * FROM CFCOMPARE2FILE WHERE status IS NULL AND f_birthdate IS NOT NULL AND f_fullname IS NOT NULL AND status <> 'C'
    )
    LOOP
    BEGIN
        SELECT count(*) INTO v_count1 FROM cfmast WHERE instr (rec1.f_fullname,fullname ) > 0 AND instr (rec1.f_birthdate,to_char(dateofbirth,'RRRR')) >0;
        IF v_count1 >= 1 THEN
            SELECT max(FULLNAME) FULLNAME, max(CUSTODYCD) CUSTODYCD, max(CASE WHEN country <> '234' THEN nvl(tradingcode,idcode) ELSE idcode END ) IDCODE, max(ADDRESS) ADDRESS, max(SEX) SEX, max(MARRIED) MARRIED, max(MOBILE) MOBILE, max(OPNDATE) OPNDATE
                INTO L_FULLNAME, L_CUSTODYCD, L_IDCODE, L_ADDRESS, L_SEX, L_MARRIED, L_MOBILE, L_OPNDATE
            FROM cfmast
            WHERE instr (rec1.f_fullname,fullname ) > 0 AND instr (rec1.f_birthdate,to_char(dateofbirth,'RRRR')) >0 AND status <> 'C';
            UPDATE CFCOMPARE2FILE SET status = 'Y',
                    FULLNAME = l_fullname,
                    CUSTODYCD = L_CUSTODYCD,
                    IDCODE = L_IDCODE,
                    ADDRESS = L_ADDRESS,
                    SEX = L_SEX,
                    MARRIED = L_MARRIED,
                    MOBILE = L_MOBILE,
                    OPNDATE = L_OPNDATE
            WHERE f_autoid = rec1.f_autoid;
            --COMMIT;
        END IF;
      EXCEPTION
       WHEN OTHERS THEN
           UPDATE CFCOMPARE2FILE SET status = 'Loi fullname' WHERE f_autoid = rec1.f_autoid;
           --COMMIT;
    END;
    END LOOP;
    --COMMIT;

  EXCEPTION
   WHEN OTHERS THEN
         plog.setendsection(pkgctx, 'PR_FILE_CFCOMPARE2FILE');
         p_err_code := errnums.C_SYSTEM_ERROR;
         p_err_message := 'SYSTEM_ERROR';

END PR_FILE_CFCOMPARE2FILE;
--End KB 20200908

-- initial LOG
BEGIN
   SELECT *
   INTO logrow
   FROM tlogdebug
   WHERE ROWNUM <= 1;

   pkgctx    :=
      plog.init ('cspks_filemaster',
                 plevel => logrow.loglevel,
                 plogtable => (logrow.log4table = 'Y'),
                 palert => (logrow.log4alert = 'Y'),
                 ptrace => (logrow.log4trace = 'Y')
      );
END;
/
