-- Start of DDL Script for Package Body HOSTMSTRADE.PCK_ORS_API
-- Generated 03-Feb-2020 15:16:33 from HOSTMSTRADE@FLEX_111

CREATE OR REPLACE 
PACKAGE pck_ors_api IS
  FUNCTION fn_get_error_message(p_errorcode IN VARCHAR2) RETURN VARCHAR2;
  FUNCTION fn_get_country_code(p_boval IN varchar2) RETURN varchar;
  FUNCTION fn_get_AccountInfo(p_id   IN VARCHAR2,
                              p_from IN NUMBER,
                              p_size IN NUMBER,
                              p_latestchange IN VARCHAR2 DEFAULT 'N') RETURN CLOB;
  FUNCTION fn_get_list_usercareby(p_afacctno IN VARCHAR2) RETURN CLOB;
  FUNCTION fn_get_seinfo_lst(p_id         IN VARCHAR2,
                             p_symbollist IN VARCHAR2,
                             p_from       IN NUMBER,
                             p_size       IN NUMBER) RETURN CLOB;
  FUNCTION fn_get_CiInfo(p_id   IN VARCHAR2,
                         p_from IN NUMBER,
                         p_size IN NUMBER) RETURN CLOB;
  FUNCTION fn_get_customersinfo(p_id           IN VARCHAR2,
                                p_from         IN NUMBER,
                                p_size         IN NUMBER,
                                p_latestchange IN VARCHAR2 DEFAULT 'N')
    RETURN CLOB;
  FUNCTION fn_getSecurities_Info(p_symbol IN VARCHAR2,
                                 p_from   IN NUMBER,
                                 p_size   IN NUMBER) RETURN CLOB;
  FUNCTION fn_getBeneficiaries(p_afacctno     IN VARCHAR2,
                               p_from         IN NUMBER,
                               p_size         IN NUMBER,
                               p_latestchange IN VARCHAR2 DEFAULT 'N')
    RETURN CLOB;
  FUNCTION fn_getcfsign(p_custodycd IN VARCHAR2) RETURN CLOB;
  FUNCTION fn_getotright(p_custodycd IN VARCHAR2) RETURN CLOB;
  PROCEDURE fn_getUserLogin2(pv_json_input IN VARCHAR2, pv_json_output IN OUT VARCHAR2);
  FUNCTION fn_getUserLoginInfo(p_userName IN VARCHAR2) RETURN CLOB;
  PROCEDURE pr_checkTradingPWD(pv_json_input IN VARCHAR2, pv_json_output IN OUT VARCHAR2) ;
END;
/


CREATE OR REPLACE 
PACKAGE BODY pck_ors_api IS

  pkgctx        plog.log_ctx;
  logrow        tlogdebug%rowtype;
  ownerschema   varchar2(50);
  databaseCache boolean;

  FUNCTION fn_get_error_message(p_errorcode IN VARCHAR2) RETURN VARCHAR2 IS
    l_error_message VARCHAR2(2000);
  BEGIN
    SELECT errdesc
      INTO l_error_message
      FROM deferror
     WHERE errnum = p_errorcode;
    RETURN '{"ErrorCode": "' || p_errorcode || '", "ErrorMessage": "' || l_error_message || '"}';
  EXCEPTION
    WHEN OTHERS THEN
      RETURN '{"ErrorCode": "' || p_errorcode || '", "ErrorMessage": "Loi chua duoc dinh nghia!"}';
  END fn_get_error_message;

  FUNCTION fn_get_country_code(p_boval IN varchar2) RETURN varchar IS
    l_count  number;
    l_return varchar2(10);
  BEGIN
    select count(*)
      into l_count
      from allcode
     where cdname = 'NATIONAL'
       and cdname = 'CF'
       and cdval = p_boval;
    If l_count > 0 then
      select max(cdcontent)
        into l_return
        from allcode
       where cdname = 'NATIONAL'
         and cdname = 'CF'
         and cdval = p_boval;
    else
      l_return := p_boval;
    End if;
    return l_return;
  END fn_get_country_code;

  FUNCTION fn_get_allcode(p_cdtype IN VARCHAR2,
                          p_cdname IN VARCHAR2,
                          p_from   IN NUMBER,
                          p_size   IN NUMBER) RETURN CLOB IS
    l_header_msg        CLOB;
    l_detail_msg_format VARCHAR2(4000);
    l_detail_msg        CLOB;
    l_detail_msg_tmp    VARCHAR2(4000);
    l_cdtype            VARCHAR2(200);
    l_cdname            VARCHAR2(200);
    l_count             NUMBER;
    l_fromrow           NUMBER;
    l_size              NUMBER;
    l_limit             NUMBER;
    l_hasMore           VARCHAR2(50);
  BEGIN
    plog.setbeginsection(pkgctx, 'fn_get_allcode');
    l_cdtype            := NVL(p_cdtype, '%');
    l_cdname            := NVL(p_cdname, '%');
    l_detail_msg_format := '{"object":"code", "type":"<$cdtype>", "name":"<$cdname>", "value": "<$cdval>" ,"content": "<$cdcontent>"}';
    l_detail_msg_tmp    := '';
    l_detail_msg        := '';
    l_count             := 0;
    l_fromrow           := p_from;
    l_size              := LEAST(1000, p_size);
    l_limit := CASE
                 WHEN l_fromrow = 0 THEN
                  l_size + 1
                 ELSE
                  l_size + l_fromrow
               END;
    l_hasMore           := 'false';
    FOR rec IN (SELECT *
                  FROM (SELECT ROWNUM idrow, a.*
                          FROM (SELECT allcode.*
                                  FROM allcode
                                 WHERE cdtype LIKE l_cdtype
                                   AND cdname LIKE l_cdname
                                 ORDER BY cdtype, cdname, lstodr) a)
                 WHERE idrow >= l_fromrow
                   AND idrow < l_limit + 1) LOOP
      IF l_count >= l_size THEN
        l_hasmore := 'true';
        EXIT;
      END IF;
      l_detail_msg_tmp := l_detail_msg_format;
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp, '<$cdtype>', rec.cdtype);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp, '<$cdname>', rec.cdname);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp, '<$cdval>', rec.cdval);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,
                                  '<$cdcontent>',
                                  rec.cdcontent);
      IF l_count = 0 THEN
        l_detail_msg := l_detail_msg_tmp;
      ELSE
        l_detail_msg := l_detail_msg || ',' || l_detail_msg_tmp;
      END IF;
      l_count := l_count + 1;
    END LOOP;
    plog.setendsection(pkgctx, 'fn_get_allcode');
    RETURN '{"object":"list", "totalCount":' || l_count || ' , "hasMore":' || l_hasMore || ', data: [' || l_detail_msg || ']}';
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'fn_get_allcode');
      RETURN fn_get_error_message('-1');
  END fn_get_allcode;

  FUNCTION fn_get_AccountInfo(p_id   IN VARCHAR2,
                              p_from IN NUMBER,
                              p_size IN NUMBER,
                              p_latestchange IN VARCHAR2 default 'N') RETURN CLOB IS
    l_header_msg      VARCHAR2(4000);
    l_basketid        VARCHAR2(20);
    v_strcurrdate     VARCHAR2(20);
    l_actype          VARCHAR2(20);
    l_customizefee    VARCHAR2(20);
    l_odfeerate       odtype.deffeerate%TYPE;
    l_json_msg_data   CLOB;
    l_json_msg_format VARCHAR2(4000);
    l_count           INTEGER;
    l_hasmore         VARCHAR2(20) := 'false';
    l_json_msg        CLOB;
    l_maxsize         INTEGER := 1000;
    l_id              VARCHAR2(20);

    CURSOR c_otright(l_custid VARCHAR2) IS
        SELECT LISTAGG(TO_CHAR(VIA), ',') WITHIN GROUP(ORDER BY VIA) via,
               LISTAGG(authtype, ',') WITHIN GROUP(ORDER BY VIA) authtype, cfcustid, authcustid
        FROM otright o, cfmast cf,
             (SELECT TO_DATE(varvalue,'dd/mm/rrrr') currdate FROM sysvar WHERE varname = 'CURRDATE' AND grname = 'SYSTEM') sy
        WHERE deltd = 'N' and NVL(authtype,'x') <> 'x' AND NVL(via,'x') <> 'x'
        AND cf.custid = o.cfcustid AND cf.custid = o.authcustid
        AND cf.custid = l_custid
        AND o.via IN ('A','O','M') -- chi lay kenh FDS su dung
        GROUP BY cfcustid, authcustid;
    v_otright        c_otright%ROWTYPE;
  BEGIN
    plog.setbeginsection(pkgctx, 'fn_get_AccountInfo');
    l_id := NVL(p_id, '%');
    --"marginLimit":<$MARGINLIMIT>, "t0Limit": <$T0LIMIT>,
    l_json_msg_format := '{"object": "account", "custID": "<$CUSTID>", "account": "<$ACCOUNTNO>", "custodyID": "<$CUSTODYID>", "fullName": "<$FULLNAME>", "brid": "<$BRID>", "reBMacctno": "<$REBMACCTNO>", "reRDacctno": "<$RERDACCTNO>", '
                      || '"afType": "<$AFTYPE>", "status": "<$STATUS>", "basketID": "<$BASKETID>", '
                      || '"groupLeader": "<$GROUPLEADER>", "autoadvance": "<$AUTOADVANCE>", "faxNumber": "<$FAXNUMBER>", "phoneNumber": "<$PHONENUMBER>", "mobile": "<$MOBILE>", '
                      || '"mobilesms": "<$MOBILESMS>", "identityNo": "<$IDENTITYNO>", "dateofbirth": "<$DATEOFBIRTH>", "address": "<$ADDRESS>", "iddate": "<$IDDATE>", "idplace": "<$IDPLACE>", '
                      || '"custtype": "<$CUSTTYPE>", "idtype": "<$IDTYPE>", "idexpired": "<$IDEXPIRED>", "email": "<$EMAIL>", "sex": "<$SEX>", "country": "<$COUNTRY>", "careby": "<$CAREBY>", '
                      || '"pin": "<$PIN>", "tradetelephone": "<$TRADETELEPHONE>", "tradeOnline": "<$TRADEONLINE>", "authType": "<$AUTHTYPE>", "via":"<$VIA>", "vat": "<$VAT>","broker":';
    l_header_msg      := '';
    l_json_msg_data   := '';
    l_count           := 0;
    l_maxsize         := LEAST(l_maxsize, p_size);
    SELECT varvalue
      INTO v_strcurrdate
      FROM sysvar
     WHERE grname = 'SYSTEM'
       AND varname = 'CURRDATE';
    FOR rec IN (SELECT *
                  FROM (SELECT ROWNUM rnid, af.*
                          FROM (SELECT af.custid, af.acctno, cf.custodycd, cf.fullname, af.actype,
                                       DECODE(cf.idtype,'009',cf.tradingcode,cf.idcode) idcode,
                                       af.status, af.mrcrlimitmax, af.advanceline, af.groupleader,
                                       af.autoadv autoadvance, cf.fax, cf.phone PHONENUMBER, cf.mobilesms,
                                       cf.mobile, TO_CHAR(cf.dateofbirth, systemnums.C_DATE_FORMAT) dateofbirth, cf.address,
                                       TO_CHAR(DECODE(cf.idtype,'009',cf.tradingcodedt,cf.iddate),systemnums.C_DATE_FORMAT) iddate,
                                       cf.idplace, trim(cf.custtype) custtype, TO_CHAR(cf.idexpired, systemnums.C_DATE_FORMAT) idexpired, cf.idtype, cf.email,
                                       cf.sex, a1.cdcontent country, af.careby, cf.pin, af.tradetelephone,
                                       CASE WHEN (cf.custtype = 'B' AND cf.country = '234') OR substr(cf.custodycd,4,1) = 'P' THEN 'N' ELSE 'Y' END vat, cf.brid    --hotfix 20200203
                                  FROM afmast af, cfmast cf, allcode a1
                                 WHERE af.custid = cf.custid
                                   AND af.acctno LIKE l_id
                                   AND a1.cdname = 'NATIONAL' AND a1.cdtype = 'CF' AND a1.cdval = cf.country
                                   AND cf.status <> 'P' -- khong lay tai khoan cho duyet
                                   AND p_latestchange = 'N'
                                 UNION ALL
                                 SELECT af.custid, af.acctno, cf.custodycd, cf.fullname, af.actype,
                                       DECODE(cf.idtype,'009',cf.tradingcode,cf.idcode) idcode,
                                       af.status, af.mrcrlimitmax, af.advanceline, af.groupleader,
                                       af.autoadv autoadvance, cf.fax, cf.phone PHONENUMBER, cf.mobilesms,
                                       cf.mobile, TO_CHAR(cf.dateofbirth, systemnums.C_DATE_FORMAT) dateofbirth, cf.address,
                                       TO_CHAR(DECODE(cf.idtype,'009',cf.tradingcodedt,cf.iddate),systemnums.C_DATE_FORMAT) iddate,
                                       cf.idplace, trim(cf.custtype) custtype, TO_CHAR(cf.idexpired, systemnums.C_DATE_FORMAT) idexpired, cf.idtype, cf.email,
                                       cf.sex, a1.cdcontent country, af.careby, cf.pin, af.tradetelephone,
                                       CASE WHEN (cf.custtype = 'B' AND cf.country = '234') OR substr(cf.custodycd,4,1) = 'P' THEN 'N' ELSE 'Y' END vat, cf.brid    --hotfix 20200203
                                  FROM afmast af, cfmast cf, allcode a1,
                                       (SELECT distinct key_value FROM intraday_change_event WHERE table_name = 'CFMAST' AND table_key = 'CUSTID') e
                                 WHERE af.custid = cf.custid
                                   AND af.acctno LIKE l_id
                                   AND a1.cdname = 'NATIONAL' AND a1.cdtype = 'CF' AND a1.cdval = cf.country
                                   AND cf.status <> 'P' -- khong lay tai khoan cho duyet
                                   AND cf.custid = e.key_value
                                   AND p_latestchange = 'Y'
                                 ORDER BY acctno) af)
                 WHERE rnid >= p_from
                   AND rnid <= p_from + l_maxsize + 1) LOOP
      l_count := l_count + 1;
      IF l_count > LEAST(l_maxsize, p_size) THEN
        l_count   := l_count - 1;
        l_hasmore := 'true';
        EXIT;
      END IF;
      l_header_msg := l_json_msg_format;
      l_header_msg := REPLACE(l_header_msg, '<$CUSTID>', rec.custid);
      l_header_msg := REPLACE(l_header_msg, '<$ACCOUNTNO>', rec.acctno);
      l_header_msg := REPLACE(l_header_msg, '<$CUSTODYID>', rec.custodycd);
      l_header_msg := REPLACE(l_header_msg, '<$FULLNAME>', rec.fullname);
      l_header_msg := REPLACE(l_header_msg, '<$AFTYPE>', rec.actype);
      l_header_msg := REPLACE(l_header_msg, '<$STATUS>', rec.status);
      l_header_msg := REPLACE(l_header_msg, '<$MARGINLIMIT>', rec.mrcrlimitmax);
      l_header_msg := REPLACE(l_header_msg, '<$T0LIMIT>', rec.advanceline);
      l_header_msg := REPLACE(l_header_msg, '<$GROUPLEADER>', rec.groupleader);
      l_header_msg := REPLACE(l_header_msg, '<$AUTOADVANCE>', rec.autoadvance);
      l_header_msg := REPLACE(l_header_msg, '<$FAXNUMBER>', rec.fax);

      l_header_msg := REPLACE(l_header_msg, '<$PHONENUMBER>', rec.PHONENUMBER);
      l_header_msg := REPLACE(l_header_msg,'<$MOBILE>',rec.mobile);
      l_header_msg := REPLACE(l_header_msg,'<$MOBILESMS>',rec.mobilesms);
      l_header_msg := REPLACE(l_header_msg, '<$IDENTITYNO>', rec.idcode);
      l_header_msg := REPLACE(l_header_msg, '<$DATEOFBIRTH>', rec.dateofbirth);
      l_header_msg := REPLACE(l_header_msg, '<$ADDRESS>', rec.address);
      l_header_msg := REPLACE(l_header_msg, '<$IDDATE>', rec.iddate);
      l_header_msg := REPLACE(l_header_msg, '<$IDPLACE>', rec.idplace);
      l_header_msg := REPLACE(l_header_msg, '<$CUSTTYPE>', rec.custtype);
      l_header_msg := REPLACE(l_header_msg, '<$IDTYPE>', rec.idtype);
      l_header_msg := REPLACE(l_header_msg, '<$IDEXPIRED>', rec.idexpired);
      l_header_msg := REPLACE(l_header_msg, '<$EMAIL>', rec.email);
      l_header_msg := REPLACE(l_header_msg, '<$SEX>', rec.sex);
      l_header_msg := REPLACE(l_header_msg, '<$COUNTRY>', fn_get_country_code(rec.country));
      l_header_msg := REPLACE(l_header_msg, '<$CAREBY>', rec.careby);
      l_header_msg := REPLACE(l_header_msg, '<$PIN>', rec.pin);
      l_header_msg := REPLACE(l_header_msg, '<$TRADETELEPHONE>', rec.tradetelephone);
      l_header_msg := REPLACE(l_header_msg, '<$VAT>', rec.vat);
      l_header_msg := REPLACE(l_header_msg, '<$BRID>', rec.brid);
      l_actype := rec.actype;
      BEGIN
        SELECT basketid
          INTO l_basketid
          FROM afsebasket
         WHERE autoid =
               (SELECT MAX(autoid)
                  FROM afsebasket
                 WHERE effdate <= TO_DATE(v_strcurrdate, 'DD/MM/YYYY')
                   AND expdate >= TO_DATE(v_strcurrdate, 'DD/MM/YYYY')
                   AND actype = l_actype);
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          l_basketid := '';
      END;
      l_header_msg := REPLACE(l_header_msg, '<$BASKETID>', l_basketid);

      --get onlineTrading Information
      OPEN c_otright(rec.custid);
      LOOP
        EXIT WHEN c_otright%NOTFOUND;
        FETCH c_otright INTO v_otright;
        l_header_msg := REPLACE(l_header_msg, '<$TRADEONLINE>', 'Y');
        l_header_msg := REPLACE(l_header_msg, '<$AUTHTYPE>', v_otright.authtype);
        l_header_msg := REPLACE(l_header_msg, '<$VIA>', v_otright.via);
      END LOOP;
      CLOSE c_otright;
      l_header_msg := REPLACE(l_header_msg, '<$TRADEONLINE>', 'N');
      l_header_msg := REPLACE(l_header_msg, '<$AUTHTYPE>', '');
      l_header_msg := REPLACE(l_header_msg, '<$VIA>', '');

      -- Chi Lay Ma Moi Gioi Voi API Get TT 1 TK
      IF p_latestchange = 'N' THEN
        FOR rec_re IN (SELECT rem.acctno REACCTNO, afl.afacctno, rerole
                       FROM retype ret, remast rem, reaflnk afl
                       WHERE ret.actype = rem.actype AND rem.acctno = afl.reacctno
                       AND rem.status = 'A' AND afl.status = 'A'
                       AND ret.rerole IN ('BM','RD')
                       AND afl.afacctno = l_id)
        LOOP
          IF rec_re.rerole = 'BM' THEN
            l_header_msg := REPLACE(l_header_msg, '<$REBMACCTNO>', rec_re.REACCTNO);
          ELSIF rec_re.rerole  = 'RD' THEN
            l_header_msg := REPLACE(l_header_msg, '<$RERDACCTNO>', rec_re.REACCTNO);
          END IF;
        END LOOP;
      END IF;
      l_header_msg := REPLACE(l_header_msg, '<$REBMACCTNO>', '');
      l_header_msg := REPLACE(l_header_msg, '<$RERDACCTNO>', '');

      l_header_msg := l_header_msg || fn_get_list_usercareby(rec.acctno) || '}';
      IF l_count = 1 THEN
        l_json_msg_data := l_header_msg;
      ELSE
        l_json_msg_data := l_json_msg_data || ',' || l_header_msg;
      END IF;
    END LOOP;

    l_json_msg := '{"object":"list", "totalcount":' || l_count ||
                  ', "hasMore": ' || l_hasmore || ', data: [' ||
                  l_json_msg_data || ']}';

    plog.setendsection(pkgctx, 'fn_get_AccountInfo');

    IF p_id IS NOT NULL THEN
      IF l_count = 0 THEN
        RETURN fn_get_error_message('-100078');
      END IF;
    END IF;
    IF p_id IS NOT NULL THEN
      RETURN l_json_msg_data;
    ELSE
      RETURN l_json_msg;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'fn_get_AccountInfo');
      RETURN fn_get_error_message('-1');
  END fn_get_AccountInfo;

  FUNCTION fn_get_list_usercareby(p_afacctno IN VARCHAR2) RETURN CLOB IS
    l_user_list CLOB;
    l_careby    cfmast.careby%TYPE;
    l_count     INTEGER;
  BEGIN
    plog.setbeginsection(pkgctx, 'fn_get_list_usercareby');
    BEGIN
      SELECT cf.careby
        INTO l_careby
        FROM cfmast cf, afmast af
       WHERE af.custid = cf.custid
         AND af.acctno = p_afacctno;
    EXCEPTION
      WHEN OTHERS THEN
        l_careby := NULL;
    END;
    l_count := 0;
    IF l_careby IS NOT NULL THEN
      FOR rec IN (SELECT DISTINCT tlname
                    FROM tlgrpusers gu, tlprofiles tl
                   WHERE gu.tlid = tl.tlid
                     AND gu.grpid = l_careby) LOOP
        IF l_count = 0 THEN
          l_user_list := '"' || rec.tlname || '"';
        ELSE
          l_user_list := l_user_list || ', "' || rec.tlname || '"';
        END IF;
        l_count := l_count + 1;
      END LOOP;
    END IF;
    l_user_list := '[' || l_user_list || ']';
    plog.setendsection(pkgctx, 'fn_get_list_usercareby');
    RETURN l_user_list;
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'fn_get_list_usercareby');
      RETURN fn_get_error_message('-1');
  END;
  FUNCTION fn_get_seinfo_lst(p_id         IN VARCHAR2,
                             p_symbollist IN VARCHAR2,
                             p_from       IN NUMBER,
                             p_size       IN NUMBER) RETURN CLOB IS
    l_header_msg        CLOB;
    l_detail_msg_format VARCHAR2(4000);
    l_detail_msg        CLOB;
    l_detail_msg_tmp    VARCHAR2(4000);
    -----
    l_json_msg_data          CLOB;
    l_json_msg_format        VARCHAR2(2000);
    l_json_msg_format_ending VARCHAR2(20);
    l_count                  INTEGER;
    l_hasmore                VARCHAR2(20) := 'false';
    l_json_msg               CLOB;
    l_maxsize                INTEGER := 1000;
    l_id                     VARCHAR2(20);
    l_trade_cgd              semast.trade%TYPE;
    l_symbolLst              VARCHAR2(30);
  BEGIN
    plog.setbeginsection(pkgctx, 'fn_get_seinfo_lst');
    l_id := NVL(p_id, '%');

    l_json_msg_format        := '{"object":"se", "account": "<$ACCOUNT>", "stock" : [';
    l_json_msg_format_ending := ']}';
    l_detail_msg_format      := '{"symbol": "<$SYMBOL>", "tradable": <$TRADABLE>,  "avlwithdraw": <$AVLWITHDRAW>, "blocked": <$BLOCKED>}';

    l_detail_msg_tmp := '';
    l_detail_msg     := '';

    l_header_msg    := '';
    l_json_msg_data := '';
    l_count         := 0;
    l_maxsize       := LEAST(l_maxsize, p_size);
    FOR i IN (SELECT *
                FROM (SELECT ROWNUM rnid, af.*
                        FROM (SELECT *
                                from afmast af
                               WHERE af.acctno LIKE l_id
                               ORDER BY af.acctno) af)
               WHERE rnid >= p_from
                 AND rnid <= p_from + l_maxsize + 1) LOOP
      l_count := l_count + 1;
      IF l_count > LEAST(l_maxsize, p_size) THEN
        l_count   := l_count - 1;
        l_hasmore := 'true';
        EXIT;
      END IF;
      l_header_msg := l_json_msg_format;
      l_header_msg := REPLACE(l_header_msg, '<$ACCOUNT>', i.acctno);
      FOR rec IN (SELECT se.afacctno account,
                         CASE
                           WHEN sb.refcodeid IS NULL THEN
                            sb.symbol
                           ELSE
                            sb2.symbol
                         END symbol,
                         CASE
                           WHEN sb.refcodeid IS NULL THEN
                            sb.codeid
                           ELSE
                            sb.refcodeid
                         END codeid,
                         se.trade tradable,
                         se.blocked blocked,
                         NVL(ca.exercisedCA, 0) exercisedCA,
                         NVL(ca.unexercisedCA, 0) unexercisedCA,
                         NVL(ca.stockDividend, 0) stockDividend,
                         NVL(ca.cashDividend, 0) cashDividend,
                         CASE
                           WHEN sb.refcodeid IS NULL THEN
                            inf.currprice
                           ELSE
                            sb2.currprice
                         END currprice,
                         NVL(se.withdraw, 0) waitforwithdraw,
                         se.acctno,
                         sb.refcodeid,
                         se.costprice costprice_bo,
                         se.dcrqtty,
                         se.dcramt,
                         se.ddroutqtty,
                         se.ddroutamt,
                         NVL(ca.exercisedCAValue, 0) exercisedCAValue
                    FROM semast se,
                         sbsecurities sb,
                         securities_info inf,
                         securities_info sb2,
                         (SELECT mst.codeid,
                                 schd.afacctno,
                                 SUM(CASE
                                       WHEN mst.catype = '014' THEN
                                        schd.qtty
                                       ELSE
                                        0
                                     END) exercisedCA,
                                 SUM(CASE
                                       WHEN mst.catype = '014' THEN
                                        schd.pqtty
                                       ELSE
                                        0
                                     END) unexercisedCA,
                                 SUM(CASE
                                       WHEN mst.catype <> '014' THEN
                                        schd.qtty
                                       ELSE
                                        0
                                     END) stockDividend,
                                 SUM(CASE
                                       WHEN mst.catype = '010' AND
                                            schd.status = 'S' THEN
                                        schd.amt
                                       ELSE
                                        0
                                     END) cashDividend,
                                 SUM(CASE
                                       WHEN mst.catype = '014' THEN
                                        schd.qtty
                                       ELSE
                                        0
                                     END * mst.exprice) exercisedCAValue
                            FROM camast mst, caschd schd
                           WHERE mst.camastid = schd.camastid
                             AND mst.deltd <> 'Y'
                             AND schd.deltd <> 'Y'
                             AND mst.status <> 'C'
                             AND schd.status NOT IN ('C', 'W', 'E', 'R')
                           GROUP BY mst.codeid, schd.afacctno) ca
                   WHERE sb.codeid = se.codeid
                     AND se.afacctno = ca.afacctno(+)
                     AND se.codeid = ca.codeid(+)
                     AND sb.codeid = inf.codeid
                     AND sb.refcodeid = sb2.codeid(+)
                     AND sb.sectype NOT IN ('004', '014')
                     AND se.afacctno = i.acctno
                     AND INSTR( ',' ||NVL(p_symbollist,REPLACE(inf.symbol,'_CGD'))|| ',',',' ||REPLACE(inf.symbol,'_CGD')|| ',') >0
                     --AND inf.symbol LIKE l_symbolLst
                     --AND sb.refcodeid IS NULL
                   ORDER BY DECODE(NVL(sb.refcodeid, 'xxx'), 'xxx', 0, 1)) LOOP
        l_detail_msg_tmp := l_detail_msg_format;
        IF rec.refcodeid IS NOT NULL THEN
          l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,
                                      '<$SYMBOL>',
                                      rec.symbol);
          l_detail_msg_tmp := REPLACE(l_detail_msg_tmp, '<$TRADABLE>', 0);
          l_detail_msg_tmp := REPLACE(l_detail_msg_tmp, '<$DF>', 0);
          l_detail_msg_tmp := REPLACE(l_detail_msg_tmp, '<$MORTGAGED>', 0);
          l_detail_msg_tmp := REPLACE(l_detail_msg_tmp, '<$AVLWITHDRAW>', 0);
          l_detail_msg_tmp := REPLACE(l_detail_msg_tmp, '<$T0>', 0);
          l_detail_msg_tmp := REPLACE(l_detail_msg_tmp, '<$T1>', 0);
          l_detail_msg_tmp := REPLACE(l_detail_msg_tmp, '<$T2>', 0);
          l_detail_msg_tmp := REPLACE(l_detail_msg_tmp, '<$BLOCKED>', 0);
          l_detail_msg_tmp := REPLACE(l_detail_msg_tmp, '<$EXERCISEDCA>', 0);
          l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,
                                      '<$UNEXERCISEDCA>',
                                      0);
          l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,
                                      '<$STOCKDIVIDEND>',
                                      0);
          l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,
                                      '<$CASHDIVIDEND>',
                                      0);
          l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,
                                      '<$WAITFORWITHDRAW>',
                                      0);
          l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,
                                      '<$CURRPRICE>',
                                      rec.currprice);
          l_detail_msg_tmp := REPLACE(l_detail_msg_tmp, '<$SECUREDQTTY>', 0);
          l_detail_msg_tmp := REPLACE(l_detail_msg_tmp, '<$SELLREMAIN>', 0);
          l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,
                                      '<$COSTPRICE_BO>',
                                      rec.costprice_bo);
        END IF;
        l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,
                                    '<$SYMBOL>',
                                    rec.symbol);
        l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,
                                    '<$TRADABLE>',
                                    rec.tradable);
        l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,
                                    '<$AVLWITHDRAW>',
                                    rec.tradable);
        l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,
                                    '<$BLOCKED>',
                                    rec.blocked);
        l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,
                                    '<$EXERCISEDCA>',
                                    rec.exercisedCA);
        l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,
                                    '<$UNEXERCISEDCA>',
                                    rec.unexercisedCA);
        l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,
                                    '<$STOCKDIVIDEND>',
                                    rec.stockDividend);
        l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,
                                    '<$CASHDIVIDEND>',
                                    rec.cashDividend);
        l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,
                                    '<$WAITFORWITHDRAW>',
                                    rec.waitforwithdraw);
        l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,
                                    '<$CURRPRICE>',
                                    rec.currprice);
        l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,
                                    '<$COSTPRICE_BO>',
                                    rec.costprice_bo);

        BEGIN
          SELECT mst.trade
            INTO l_trade_cgd
            FROM semast mst, sbsecurities sec
           WHERE mst.codeid = sec.codeid
             AND refcodeid = rec.codeid
             AND mst.afacctno = rec.account;
        EXCEPTION
          WHEN OTHERS THEN
            l_trade_cgd := 0;
        END;
        l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,
                                    '<$WAITFORTRADE>',
                                    l_trade_cgd);

        IF rec.tradable + rec.blocked + rec.exercisedCA + rec.unexercisedCA +
           rec.stockDividend + rec.cashDividend +
           rec.waitforwithdraw + l_trade_cgd > 0 THEN
          IF l_detail_msg IS NULL THEN
            l_detail_msg := l_detail_msg || l_detail_msg_tmp;
          ELSE
            l_detail_msg := l_detail_msg || ',' || l_detail_msg_tmp;
          END IF;
        END IF;
      END LOOP;

      l_header_msg := l_header_msg || l_detail_msg ||
                      l_json_msg_format_ending;

      IF l_count = 1 THEN
        l_json_msg_data := l_header_msg;
      ELSE
        l_json_msg_data := l_json_msg_data || ',' || l_header_msg;
      END IF;

    END LOOP;

    l_json_msg := '{"object":"list", "totalcount":' || l_count ||
                  ', "hasMore": ' || l_hasmore || ', data: [' ||
                  l_json_msg_data || ']}';
    plog.setendsection(pkgctx, 'fn_get_seinfo_lst');
    IF p_id IS NOT NULL THEN
      IF l_count = 0 THEN
        RETURN fn_get_error_message('-100078');
      ELSE
        RETURN l_json_msg_data;
      END IF;
    END IF;
    RETURN l_json_msg;
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'fn_get_seinfo_lst');
      RETURN fn_get_error_message('-1');
  END fn_get_seinfo_lst;

  FUNCTION fn_get_CiInfo(p_id   IN VARCHAR2,
                         p_from IN NUMBER,
                         p_size IN NUMBER) RETURN CLOB IS
    l_header_msg         VARCHAR2(4000);
    l_json_msg_data      CLOB;
    l_json_msg_format    VARCHAR2(4000);
    l_count              INTEGER;
    l_hasmore            VARCHAR2(20) := 'false';
    l_json_msg           CLOB;
    l_maxsize            INTEGER := 1000;
    l_id                 VARCHAR2(20);
    l_totalsecured       NUMBER(20, 0);
    l_filledsecured      NUMBER(20, 0);
    l_unfillsecured      NUMBER(20, 0);
    l_bonusmoney         NUMBER(20, 0);
    l_ordernav           NUMBER(20, 0);
    l_ordernav2          NUMBER(20, 0);
    l_senav              NUMBER(20, 0);
    l_netaccountvalue    NUMBER(20, 0);
    l_marketvaluesec     NUMBER(20, 0);
    l_stockDividendValue NUMBER(20, 0);
    l_exercisedCAValue   NUMBER(20, 0);
    l_currdate           DATE;
    l_advpurchaseinday   NUMBER(20, 0);
    l_advamt             NUMBER(20, 0);
    l_overamt            NUMBER(20, 0);
    l_aamt               NUMBER(20, 0);
  BEGIN
    plog.setbeginsection(pkgctx, 'fn_get_CiInfo');

    l_id              := NVL(p_id, '%');
    l_json_msg_format := '{"object":"ci", "account": "<$ACCOUNT>", "availableBalance": <$BALDEFOVD>}';
    l_header_msg      := '';
    l_json_msg_data   := '';
    l_count           := 0;
    l_maxsize         := LEAST(l_maxsize, p_size);
    FOR rec IN (SELECT *
                  FROM (SELECT ROWNUM rnid, ci.*
                          FROM (SELECT ci.acctno, getbaldefovd(ci.afacctno) baldefovd
                                  FROM cimast ci
                                 WHERE ci.afacctno LIKE l_id
                                 ORDER BY ci.afacctno) ci)
                 WHERE rnid >= p_from
                   AND rnid <= p_from + l_maxsize + 1) LOOP
      l_count := l_count + 1;
      IF l_count > LEAST(l_maxsize, p_size) THEN
        l_count   := l_count - 1;
        l_hasmore := 'true';
        EXIT;
      END IF;

      l_header_msg := l_json_msg_format;
      l_header_msg := REPLACE(l_header_msg, '<$ACCOUNT>', rec.acctno);
      l_header_msg := REPLACE(l_header_msg, '<$BALDEFOVD>', rec.baldefovd);
      l_currdate   := getcurrdate;

      IF l_count = 1 THEN
        l_json_msg_data := l_header_msg;
      ELSE
        l_json_msg_data := l_json_msg_data || ',' || l_header_msg;
      END IF;
    END LOOP;

    l_json_msg := '{"object":"list", "totalcount":' || l_count ||
                  ', "hasMore": ' || l_hasmore || ', data: [' ||
                  l_json_msg_data || ']}';

    plog.setendsection(pkgctx, 'fn_get_CiInfo');
    IF p_id IS NOT NULL THEN
      IF l_count = 0 THEN
        RETURN fn_get_error_message('-100078');
      END IF;
    END IF;

    IF p_id IS NOT NULL THEN
      RETURN l_json_msg_data;
    ELSE
      RETURN l_json_msg;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'fn_get_CiInfo');
      RETURN fn_get_error_message('-1');
  END fn_get_CiInfo;

  FUNCTION fn_get_customersinfo(p_id           IN VARCHAR2,
                                p_from         IN NUMBER,
                                p_size         IN NUMBER,
                                p_latestchange IN VARCHAR2 DEFAULT 'N')
    RETURN CLOB IS
    l_header_msg         clob;
    l_custodyid          cfmast.custodycd%TYPE;
    l_fullname           cfmast.fullname%TYPE;
    l_idcode             cfmast.idcode%TYPE;
    l_iddate             VARCHAR2(20);
    l_idexpried          VARCHAR2(20);
    l_address            cfmast.address%TYPE;
    l_account_list       clob;
    l_json_msg_data      CLOB;
    l_json_msg_format    VARCHAR2(2000);
    l_json_msg_format_af VARCHAR2(2000);
    l_json_msg_af        VARCHAR2(2000);
    l_count              INTEGER;
    l_hasmore            VARCHAR2(20) := 'false';
    l_json_msg           CLOB;
    l_maxsize            INTEGER := 1000;
    l_id                 VARCHAR2(20);

    CURSOR c_custInfo(l_id VARCHAR2, v_from NUMBER, v_to NUMBER, v_lastchane  VARCHAR2) IS
        SELECT *
          FROM (SELECT ROWNUM rnid,
                      cf.custid, cf.custodycd, cf.fullname,
                      DECODE(cf.idtype,'009',cf.tradingcode,cf.idcode) idcode,
                      TO_CHAR(DECODE(cf.idtype,'009',cf.tradingcodedt,cf.iddate),'dd/mm/rrrr') iddate,
                      TO_CHAR(cf.idexpired, 'DD/MM/RRRR') idexpired,
                      cf.address, cf.fax, cf.mobile, cf.mobilesms, cf.idplace, a1.cdcontent COUNTRY,
                      TO_CHAR(cf.dateofbirth, 'dd/mm/rrrr') dateofbirth,
                      cf.phone, cf.idtype, cf.status, cf.email, cf.sex, cf.custtype, 'Y' tradetelephone, cf.pin,
                      cf.activests, CASE WHEN (cf.custtype = 'B' AND cf.country = '234') OR substr(cf.custodycd,4,1) = 'P' THEN 'N' ELSE 'Y' END vat, cf.brid,    --hotfix 20200203
                      cf.careby
                  FROM (SELECT distinct key_value FROM intraday_change_event WHERE table_name = 'CFMAST' AND table_key = 'CUSTID') cf_change,
                       allcode a1, cfmast cf
                 WHERE cf.custodycd LIKE l_id
                   AND a1.cdname = 'NATIONAL'
                   AND a1.cdtype = 'CF'
                   AND a1.cdval = cf.country
                   AND cf.status <> 'P'
                   AND cf.custid=cf_change.key_value -- khong lay tai khoan cho duyet
                   AND v_lastchane = 'Y'
               UNION ALL
               SELECT ROWNUM rnid,
                      cf.custid, cf.custodycd, cf.fullname,
                      DECODE(cf.idtype,'009',cf.tradingcode,cf.idcode) idcode,
                      TO_CHAR(DECODE(cf.idtype,'009',cf.tradingcodedt,cf.iddate),'dd/mm/rrrr') iddate,
                      TO_CHAR(cf.idexpired, 'DD/MM/RRRR') idexpired,
                      cf.address, cf.fax, cf.mobile, cf.mobilesms, cf.idplace, a1.cdcontent COUNTRY,
                      TO_CHAR(cf.dateofbirth, 'dd/mm/rrrr') dateofbirth,
                      cf.phone, cf.idtype, cf.status, cf.email, cf.sex, cf.custtype, 'Y' tradetelephone, cf.pin,
                      cf.activests, CASE WHEN (cf.custtype = 'B' AND cf.country = '234') OR substr(cf.custodycd,4,1) = 'P' THEN 'N' ELSE 'Y' END vat, cf.brid,    --hotfix 20200203
                      cf.careby
                  FROM allcode a1, cfmast cf
                 WHERE cf.custodycd LIKE l_id --cf.custodycd = l_id
                   AND a1.cdname = 'NATIONAL'
                   AND a1.cdtype = 'CF'
                   AND a1.cdval = cf.country
                   AND cf.status <> 'P'
                   AND v_lastchane = 'N') tbl
        WHERE rnid >= v_from
          AND rnid <= v_to;

    CURSOR c_afInfoByCustid(l_custid VARCHAR2) IS
        SELECT af.acctno||' - '||af.actype||': '||at.typename acctno
          FROM afmast af, aftype at, mrtype mrt
         WHERE af.custid = l_custid
           AND af.status = 'A'
           AND af.actype = at.actype
           AND at.mrtype = mrt.actype
        ORDER BY decode(mrt.mrtype, 'N', 1, 'L', 2, 3);
    CURSOR c_otright(l_custid VARCHAR2) IS
        SELECT LISTAGG(TO_CHAR(VIA), ',') WITHIN GROUP(ORDER BY VIA) via,
               LISTAGG(authtype, ',') WITHIN GROUP(ORDER BY VIA) authtype, cfcustid, authcustid
        FROM otright o, cfmast cf,
             (SELECT TO_DATE(varvalue,'dd/mm/rrrr') currdate FROM sysvar WHERE varname = 'CURRDATE' AND grname = 'SYSTEM') sy
        WHERE deltd = 'N' and NVL(authtype,'x') <> 'x' AND NVL(via,'x') <> 'x'
        AND cf.custid = o.cfcustid AND cf.custid = o.authcustid
        AND cf.custid = l_custid
        AND o.via IN ('A','O','M') -- chi lay kenh FDS su dung
        GROUP BY cfcustid, authcustid;

    v_custInfo   c_custInfo%ROWTYPE;
    --v_custInfoByCustid c_custInfoByCustid%ROWTYPE;
    v_afInfo     c_afInfoByCustid%ROWTYPE;
    v_otright    c_otright%ROWTYPE;
  BEGIN
    plog.setbeginsection(pkgctx, 'fn_get_customersinfo');
    l_json_msg_format := '{"object": "customer", "custID": "<$CUSTID>", "accountNo": [<$ACCOUNTS>], "custodyID": "<$CUSTODYID>", "fullName": "<$FULLNAME>", "identityNo": "<$IDENTITYNO>", "brid": "<$BRID>", '
                      || '"idtype": "<$IDTYPE>", "issuePlace": "<$ISSUEPLACE>", "issueDate": "<$ISSUEDATE>", "expiryDate": "<$EXPIRYDATE>", "address": "<$ADDRESS>", "phoneNumber": "<$PHONENUMBER>", '
                      || '"fax": "<$FAX>", "mobile": "<$MOBILE>", "phoneNumber": "<$PHONE>", "mobilesms": "<$MOBILESMS>", "email": "<$EMAIL>", "country": "<$COUNTRY>", "dateofbirth": "<$DATEOFBIRTH>", "status" : "<$STATUS>", '
                      || '"sex": "<$SEX>", "custtype" : "<$CUSTTYPE>", "tradetelephone": "<$TRADETELEPHONE>", "pin": "<$PIN>","activests": "<$ACTIVESTS>","vat": "<$VAT>","tradeOnline": "<$TRADEONLINE>","authType": "<$AUTHTYPE>", "via":"<$VIA>", "careBy":"<$CAREBY>"}';
    l_json_msg_format_af := '{"accountNo": "<$ACCTNO>"}';
    l_id            := NVL(p_id, '%');
    l_json_msg_data := '';
    l_count         := 0;
    l_maxsize       := LEAST(p_size, l_maxsize);
    OPEN c_custInfo(l_id, p_from, p_from + l_maxsize + 1, p_latestchange);
    LOOP
      FETCH c_custInfo INTO v_custInfo;
      EXIT WHEN c_custInfo%NOTFOUND;

      l_count := l_count + 1;
      IF l_count > LEAST(p_size, l_maxsize) THEN
        l_hasmore := 'true';
        l_count   := l_count - 1;
        EXIT;
      END IF;
      l_header_msg := l_json_msg_format;

      l_account_list := NULL;
      OPEN c_afInfoByCustid(v_custInfo.custid);
      LOOP
        FETCH c_afInfoByCustid INTO v_afInfo;
        EXIT WHEN c_afInfoByCustid%NOTFOUND;
        l_json_msg_af := l_json_msg_format_af;
        l_json_msg_af := REPLACE(l_json_msg_af, '<$ACCTNO>', v_afInfo.acctno);
        l_json_msg_af := REPLACE(l_json_msg_af, '<$ACCTNO>', '');
        IF l_account_list IS NULL THEN
          l_account_list := l_json_msg_af;
        ELSE
          l_account_list := l_account_list || ', ' || l_json_msg_af;
        END IF;

      END LOOP;
      CLOSE c_afInfoByCustid;

      l_header_msg := REPLACE(l_header_msg, '<$CUSTID>', v_custInfo.custid);
      l_header_msg := REPLACE(l_header_msg, '<$CUSTODYID>', v_custInfo.custodycd);
      l_header_msg := REPLACE(l_header_msg, '<$FULLNAME>', v_custInfo.fullname);
      l_header_msg := REPLACE(l_header_msg, '<$IDENTITYNO>', v_custInfo.idcode);
      l_header_msg := REPLACE(l_header_msg, '<$ISSUEDATE>', v_custInfo.iddate);
      l_header_msg := REPLACE(l_header_msg, '<$ISSUEPLACE>', v_custInfo.idplace);
      l_header_msg := REPLACE(l_header_msg, '<$EXPIRYDATE>', v_custInfo.idexpired);
      l_header_msg := REPLACE(l_header_msg, '<$ADDRESS>', v_custInfo.address);
      l_header_msg := REPLACE(l_header_msg, '<$PHONENUMBER>', v_custInfo.phone);
      l_header_msg := REPLACE(l_header_msg, '<$FAX>', v_custInfo.fax);
      l_header_msg := REPLACE(l_header_msg, '<$MOBILE>', v_custInfo.mobile);
      l_header_msg := REPLACE(l_header_msg, '<$MOBILESMS>', v_custInfo.mobilesms);
      l_header_msg := REPLACE(l_header_msg, '<$COUNTRY>', v_custInfo.country);
      l_header_msg := REPLACE(l_header_msg, '<$DATEOFBIRTH>', v_custInfo.dateofbirth);
      l_header_msg := REPLACE(l_header_msg, '<$PHONE>', v_custInfo.phone);
      l_header_msg := REPLACE(l_header_msg, '<$IDTYPE>', v_custInfo.idtype);
      l_header_msg := REPLACE(l_header_msg, '<$STATUS>', v_custInfo.status);
      l_header_msg := REPLACE(l_header_msg, '<$EMAIL>', v_custInfo.email);
      l_header_msg := REPLACE(l_header_msg, '<$SEX>', v_custInfo.sex);
      l_header_msg := REPLACE(l_header_msg, '<$CUSTTYPE>', v_custInfo.custtype);
      l_header_msg := REPLACE(l_header_msg, '<$ACCOUNTS>', l_account_list);
      l_header_msg := REPLACE(l_header_msg, '<$TRADETELEPHONE>', v_custInfo.tradetelephone);
      l_header_msg := REPLACE(l_header_msg, '<$PIN>', v_custInfo.pin);
      l_header_msg := REPLACE(l_header_msg, '<$ACTIVESTS>', v_custInfo.activests);
      l_header_msg := REPLACE(l_header_msg, '<$VAT>', v_custInfo.vat);
      l_header_msg := REPLACE(l_header_msg, '<$BRID>', v_custInfo.brid);
      l_header_msg := REPLACE(l_header_msg, '<$CAREBY>', v_custInfo.careby);

      --get onlineTrading Information
      OPEN c_otright(v_custInfo.custid);
      LOOP
        EXIT WHEN c_otright%NOTFOUND;
        FETCH c_otright INTO v_otright;
        l_header_msg := REPLACE(l_header_msg, '<$TRADEONLINE>', 'Y');
        l_header_msg := REPLACE(l_header_msg, '<$AUTHTYPE>', v_otright.authtype);
        l_header_msg := REPLACE(l_header_msg, '<$VIA>', v_otright.via);
      END LOOP;
      CLOSE c_otright;
      l_header_msg := REPLACE(l_header_msg, '<$TRADEONLINE>', 'N');
      l_header_msg := REPLACE(l_header_msg, '<$AUTHTYPE>', '');
      l_header_msg := REPLACE(l_header_msg, '<$VIA>', '');

      IF l_count = 1 THEN
        l_json_msg_data := l_header_msg;
      ELSE
        l_json_msg_data := l_json_msg_data || ',' || l_header_msg;
      END IF;

    END LOOP;
    CLOSE c_custInfo;


    l_json_msg := '{"object":"list", "totalcount":' || l_count ||
                  ', "hasMore": ' || l_hasmore || ', data: [' ||
                  l_json_msg_data || ']}';

    plog.setendsection(pkgctx, 'fn_get_customersinfo');
    IF p_id IS NOT NULL THEN
      IF l_count = 0 THEN
        RETURN fn_get_error_message('-100078');
      END IF;
    END IF;
    IF p_id IS NOT NULL THEN
      RETURN l_json_msg_data;
    ELSE
      RETURN l_json_msg;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'fn_get_customersinfo');
      RETURN fn_get_error_message('-1');
  END fn_get_customersinfo;

  FUNCTION fn_getSecurities_Info(p_symbol IN VARCHAR2,
                                 p_from   IN NUMBER,
                                 p_size   IN NUMBER) RETURN CLOB IS
    l_header_msg             CLOB;
    l_detail_msg_format      VARCHAR2(4000);
    l_detail_msg             CLOB;
    l_detail_msg_tmp         VARCHAR2(4000);
    l_json_msg_format_ending varchar2(20);
    l_json_msg_data          CLOB;
    l_json_msg_format        VARCHAR2(2000);
    l_count                  INTEGER;
    l_hasmore                VARCHAR2(20) := 'false';
    l_json_msg               CLOB;
    l_maxsize                INTEGER := 1000;
    l_id                     VARCHAR2(20);
  BEGIN
    plog.setbeginsection(pkgctx, 'fn_getSecurities_Info');
    l_json_msg_format := '{"object":"Securities_Info", "sec_info": [';

    l_detail_msg_format      := '{"symbol": "<$SYMBOL>" ,"symbolNum": "<$SYMBOLNUM>", "fullname": "<$FULLNAME>", "cfidcode": "<$CFICODE>", '
                             || '"exchange": "<$EXCHANGE>", "board": "<$BOARD>", "price_ce": "<$PRICE_CE>", "price_fl": "<$PRICE_FL>", '
                             || '"price_rf": "<$PRICE_RF>", "qttysum": "<$QTTYSUM>", "fqtty": "<$FQTTY>", "status": "<$STATUS>", '
                             || '"tradelot": "<$TRADELOT>", "tradeunit": "<$TRADEUNIT>", "parvalue":"<$PARVALUE>"}';
    l_json_msg_format_ending := ']}';
    l_id                     := NVL(p_symbol, '%');
    l_header_msg             := '';
    l_json_msg_data          := '';
    l_count                  := 0;

    l_detail_msg_tmp := '';
    l_detail_msg     := '';
    l_maxsize        := LEAST(l_maxsize, p_size);

    FOR rec IN (SELECT *
                  FROM (SELECT ROWNUM rnid, sec.*
                          FROM (SELECT SB.SYMBOL,
                                       CASE
                                         WHEN SB.TRADEPLACE = '001' THEN
                                          to_char(SB.SYMBOL)
                                         ELSE
                                          'HNX'
                                       END SYMBOLNUM,
                                       IE.FULLNAME,
                                       CASE
                                         WHEN SB.SECTYPE = '001' THEN
                                          'ES'
                                         WHEN SB.SECTYPE = '006' THEN
                                          'DB'
                                         WHEN SB.SECTYPE = '007' THEN
                                          'MM'
                                         WHEN SB.SECTYPE = '002' THEN
                                          'EP'
                                         WHEN SB.SECTYPE = '003' THEN
                                          'DC'
                                         WHEN SB.SECTYPE = '005' THEN
                                          'FF'
                                       END CFICODE,
                                       CASE
                                         WHEN SB.TRADEPLACE = '001' THEN
                                          'HSX'
                                         ELSE
                                          'HNX'
                                       END EXCHANGE,
                                       CASE
                                         WHEN SB.TRADEPLACE = '001' THEN
                                          'HSX'
                                         WHEN SB.TRADEPLACE = '002' THEN
                                          'HNX'
                                         WHEN SB.TRADEPLACE = '005' THEN
                                          'UPC'
                                         ELSE
                                          ''
                                       END BOARD,
                                       SE.CEILINGPRICE PRICE_CE,
                                       SE.FLOORPRICE PRICE_FL,
                                       SE.BASICPRICE PRICE_RF,
                                       0 QTTYSUM,
                                       0 FQTTY,
                                       SB.HALT STATUS,
                                       TRADELOT,
                                       TRADEUNIT,
                                       sb.parvalue
                                  FROM SBSECURITIES    SB,
                                       SECURITIES_INFO SE,
                                       ISSUERS         IE
                                 WHERE SB.CODEID = SE.CODEID
                                   AND IE.ISSUERID = SB.ISSUERID
                                   AND SB.SECTYPE IN ('001',
                                                      '002',
                                                      '003',
                                                      '005',
                                                      '006',
                                                      '007')
                                   AND SB.TRADEPLACE IN ('001', '002', '005')
                                   AND sb.symbol LIKE l_id
                                 ORDER BY SE.CODEID) sec)
                 WHERE rnid > p_from
                   AND rnid <= p_from + l_maxsize + 1) LOOP

      l_count := l_count + 1;
      IF l_count > LEAST(l_maxsize, p_size) THEN
        l_count   := l_count - 1;
        l_hasmore := 'true';
        EXIT;
      END IF;

      l_detail_msg_tmp := l_detail_msg_format;
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp, '<$SYMBOL>', rec.symbol);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp, '<$SYMBOLNUM>', rec.symbolnum);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp, '<$FULLNAME>', rec.FULLNAME);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp, '<$CFICODE>', rec.CFICODE);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp, '<$EXCHANGE>', rec.EXCHANGE);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp, '<$BOARD>', rec.BOARD);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp, '<$PRICE_CE>', rec.PRICE_CE);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp, '<$PRICE_FL>', rec.PRICE_FL);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp, '<$PRICE_RF>', rec.PRICE_RF);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp, '<$QTTYSUM>', rec.QTTYSUM);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp, '<$FQTTY>', rec.FQTTY);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp, '<$STATUS>', rec.STATUS);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp, '<$TRADELOT>', rec.TRADELOT);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp, '<$TRADEUNIT>', rec.TRADEUNIT);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp, '<$PARVALUE>', rec.parvalue);
      IF l_detail_msg IS NULL THEN
        l_detail_msg := l_detail_msg_tmp;
      ELSE
        l_detail_msg := l_detail_msg || ',' || l_detail_msg_tmp;
      END IF;
    END LOOP;
    l_json_msg_data := l_json_msg_format || l_detail_msg ||
                       l_json_msg_format_ending;
    l_json_msg      := '{"object":"list", "totalcount":' || l_count ||
                       ', "hasMore": ' || l_hasmore || ', data: [' ||
                       l_json_msg_data || ']}';
    plog.setendsection(pkgctx, 'fn_getSecurities_Info');

    IF p_symbol IS NOT NULL THEN
      RETURN l_json_msg_data;
    ELSE
      RETURN l_json_msg;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'fn_getSecurities_Info');
      RETURN fn_get_error_message('-1');
  END fn_getSecurities_Info;

  FUNCTION fn_getBeneficiaries(p_afacctno     IN VARCHAR2,
                               p_from         IN NUMBER,
                               p_size         IN NUMBER,
                               p_latestchange IN VARCHAR2 DEFAULT 'N')
    RETURN CLOB IS
    l_header_msg                CLOB;
    l_header_acctno_msg         CLOB;
    l_detail_msg_format         VARCHAR2(4000);
    l_detail_msg                CLOB;
    l_detail_msg_tmp            clob;
    l_detail_msg_acctno         CLOB;
    l_detail_msg_acctno_tmp     varchar2(4000);
    l_detail_msg_acctno_format  varchar2(4000);
    l_json_msg_data             CLOB;
    l_json_msg_format           VARCHAR2(2000);
    l_json_acctno_format        varchar2(200);
    l_json_msg_format_ending    varchar2(20);
    l_json_acctno_format_ending varchar2(20);
    l_count                     INTEGER;
    l_hasmore                   VARCHAR2(20) := 'false';
    l_json_msg                  CLOB;
    l_maxsize                   INTEGER := 10000;
    l_id                        VARCHAR2(20);
    l_sql                       VARCHAR2(2000);
  BEGIN
    plog.setbeginsection(pkgctx, 'fn_getBeneficiaries');
    l_id                     := NVL(p_afacctno, '%');
    l_header_msg             := '';
    l_json_msg_data          := '';
    l_count                  := 0;
    l_detail_msg_tmp         := '';
    l_detail_msg             := '';
    l_maxsize                := LEAST(l_maxsize, p_size);
    l_json_msg_format        := '{"object": "Beneficiaries", "listaccount": [';
    l_json_msg_format_ending := ']}';
    l_detail_msg_format      := '';
    l_header_msg             := l_json_msg_format;
    l_json_acctno_format        := '{"afacctno": "<$AFACCTNO>", "info": [';
    l_json_acctno_format_ending := ']}';
    l_detail_msg_acctno_format  := '{"ciaccount": "<$CIACCTNO>", "ciname": "<$CINAME>", "custid": "<$CUSTID>", "bankacc": "<$BANKACC>", "bankacname": "<$BANKACNAME>", "bankname": "<$BANKNAME>", "type": "<$TYPE>", "custname": "<$CUSTNAME>", "idcode": "<$IDCODE>", "issueplace": "<$ISSUEPLACE>", "issuedate": "<$ISSUEDATE>", "bank_code": "<$BANK_CODE>", "branch_code": "<$BRANCH_CODE>", "branch_name": "<$BRANCH_NAME>"}';


    FOR i in (SELECT *
                FROM
                (
                  SELECT af.acctno afacctno,
                         af.custid cfcustid,
                         ROWNUM rnid
                  FROM afmast af, cfmast cf
                  WHERE af.custid = cf.custid AND cf.status <> 'P' AND p_latestchange = 'N' AND acctno like l_id
                  AND EXISTS (SELECT 1 FROM cfotheracc cfo WHERE cfo.afacctno = af.acctno)
                  UNION ALL
                  SELECT af.acctno afacctno,
                         af.custid cfcustid,
                         ROWNUM rnid
                  FROM afmast af, cfmast cf
                  WHERE af.custid = cf.custid AND cf.status <> 'P' AND p_latestchange <> 'N'
                  AND EXISTS (SELECT 1 FROM intraday_change_event
                               WHERE table_name = 'CFOTHERACC'
                                 AND table_key = 'CFCUSTID'
                                 AND key_value = af.custid
                               )
               )
               WHERE rnid >= p_from
                 AND rnid <= p_from + l_maxsize + 1) LOOP
      l_count := l_count + 1;
      IF l_count > LEAST(l_maxsize, p_size) THEN
        l_count   := l_count - 1;
        l_hasmore := 'true';
        EXIT;
      END IF;
      l_detail_msg_tmp            := l_detail_msg_format;
      l_detail_msg_acctno         := '';
      l_header_acctno_msg         := l_json_acctno_format;
      l_header_acctno_msg         := REPLACE(l_header_acctno_msg,
                                             '<$AFACCTNO>',
                                             i.afacctno);
      FOR rec IN (SELECT ot.autoid,
                         ot.ciaccount,
                         ot.ciname,
                         ot.custid,
                         ot.bankacc,
                         ot.bankacname,
                         ot.bankname,
                         ot.TYPE,
                         '' custname,
                         ot.acnidcode idcode,
                         ot.acnidplace issueplace,
                         ot.acniddate issuedate,
                         ot.acnidcode bank_code,
                         '' branch_code,
                         ot.citybank branch_name
                    FROM cfotheracc ot
                   WHERE afacctno = i.afacctno) LOOP
        l_detail_msg_acctno_tmp := l_detail_msg_acctno_format;
        l_detail_msg_acctno_tmp := REPLACE(l_detail_msg_acctno_tmp,
                                           '<$CIACCTNO>',
                                           rec.ciaccount);
        l_detail_msg_acctno_tmp := REPLACE(l_detail_msg_acctno_tmp,
                                           '<$CINAME>',
                                           rec.ciname);
        l_detail_msg_acctno_tmp := REPLACE(l_detail_msg_acctno_tmp,
                                           '<$CUSTID>',
                                           rec.custid);
        l_detail_msg_acctno_tmp := REPLACE(l_detail_msg_acctno_tmp,
                                           '<$BANKACC>',
                                           rec.bankacc);
        l_detail_msg_acctno_tmp := REPLACE(l_detail_msg_acctno_tmp,
                                           '<$BANKACNAME>',
                                           rec.bankacname);
        l_detail_msg_acctno_tmp := REPLACE(l_detail_msg_acctno_tmp,
                                           '<$BANKNAME>',
                                           rec.bankname);
        l_detail_msg_acctno_tmp := REPLACE(l_detail_msg_acctno_tmp,
                                           '<$TYPE>',
                                           rec.TYPE);
        l_detail_msg_acctno_tmp := REPLACE(l_detail_msg_acctno_tmp,
                                           '<$CUSTNAME>',
                                           rec.custname);
        l_detail_msg_acctno_tmp := REPLACE(l_detail_msg_acctno_tmp,
                                           '<$IDCODE>',
                                           rec.idcode);
        l_detail_msg_acctno_tmp := REPLACE(l_detail_msg_acctno_tmp,
                                           '<$ISSUEPLACE>',
                                           rec.issueplace);
        l_detail_msg_acctno_tmp := REPLACE(l_detail_msg_acctno_tmp,
                                           '<$ISSUEDATE>',
                                           rec.issuedate);
        l_detail_msg_acctno_tmp := REPLACE(l_detail_msg_acctno_tmp,
                                           '<$BANK_CODE>',
                                           rec.bank_code);
        l_detail_msg_acctno_tmp := REPLACE(l_detail_msg_acctno_tmp,
                                           '<$BRANCH_CODE>',
                                           rec.branch_code);
        l_detail_msg_acctno_tmp := REPLACE(l_detail_msg_acctno_tmp,
                                           '<$BRANCH_NAME>',
                                           rec.branch_name);
        IF l_detail_msg_acctno IS NULL THEN
          l_detail_msg_acctno := l_detail_msg_acctno_tmp;
        ELSE
          l_detail_msg_acctno := l_detail_msg_acctno || ',' ||
                                 l_detail_msg_acctno_tmp;
        END IF;
      END LOOP;
      l_header_acctno_msg := l_header_acctno_msg || l_detail_msg_acctno ||
                             l_json_acctno_format_ending;
      l_detail_msg_tmp    := l_header_acctno_msg;
      IF l_detail_msg IS NULL THEN
        l_detail_msg := l_detail_msg || l_detail_msg_tmp;
      ELSE
        l_detail_msg := l_detail_msg || ',' || l_detail_msg_tmp;
      END IF;
    END LOOP;
    IF p_afacctno IS NOT NULL THEN
      IF l_count = 0 THEN
        l_header_acctno_msg := l_json_acctno_format;
        l_header_acctno_msg := REPLACE(l_header_acctno_msg,'<$AFACCTNO>',p_afacctno);
        l_json_msg_data := l_header_msg || l_header_acctno_msg || l_json_acctno_format_ending || ']}';
      END IF;
    END IF;
    IF p_afacctno IS NULL OR l_count > 0 THEN
    l_header_msg    := l_header_msg || l_detail_msg ||
                       l_json_msg_format_ending;
    l_json_msg_data := l_header_msg;
    l_json_msg      := '{"object": "list", "totalcount":' || l_count ||
                       ', "hasMore": ' || l_hasmore || ', data: [' ||
                       l_json_msg_data || ']}';
    END IF;

    plog.setendsection(pkgctx, 'fn_getBeneficiaries');


    IF p_afacctno IS NOT NULL THEN
      RETURN l_json_msg_data;
    ELSE
      RETURN l_json_msg;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'fn_getBeneficiaries');
      RETURN fn_get_error_message('-1');
  END fn_getBeneficiaries;

  FUNCTION fn_getcfsign(p_custodycd IN VARCHAR2) RETURN CLOB IS
    -- chua lay thoi han chu ky
    l_header_msg             CLOB;
    l_detail_msg_format      CLOB;
    l_detail_msg             CLOB;
    l_detail_msg_tmp         CLOB;
    l_json_msg_format_ending CLOB;
    l_json_msg_data          CLOB;
    l_json_msg_format        CLOB;
    l_count                  INTEGER;
    l_hasmore                VARCHAR2(20) := 'false';
    l_json_msg               CLOB;
    l_maxsize                INTEGER := 1000;
    l_id                     VARCHAR2(20);
  BEGIN
    plog.setbeginsection(pkgctx, 'fn_getcfsign');
    l_json_msg_format        := '{"object":"cfsign", "custodycd": "<$CUSTODYCD>", "signinfo" : [';
    l_json_msg_format_ending := ']}';
    l_detail_msg_format      := '{"autoid": "<$AUTOID>", "valdate": "<$VALDATE>", "expdate": "<$EXPDATE>", "custid": "<$CUSTID>", "custname": "<$CUSTNAME>", "signature": "';

    l_id             := NVL(p_custodycd, '%');
    l_header_msg     := '';
    l_detail_msg_tmp := '';
    l_detail_msg     := '';
    l_header_msg     := '';
    l_json_msg_data  := '';
    l_count          := 0;
    IF p_custodycd IS NOT NULL THEN
      l_count      := l_count + 1;
      l_header_msg := l_json_msg_format;
      l_header_msg := REPLACE(l_header_msg, '<$CUSTODYCD>', p_custodycd);
    ELSE
      RETURN fn_get_error_message('-100078');
    END IF;
    FOR rec IN (SELECT cs.autoid,
                       cf.custodycd,
                       cs.signature,
                       cf.custid,
                       cf.fullname,
                       TO_CHAR(cs.valdate, systemnums.C_DATE_FORMAT) valdate,
                       TO_CHAR(cs.expdate, systemnums.C_DATE_FORMAT) expdate
                  FROM cfsign cs, cfmast cf
                 WHERE cf.custodycd = p_custodycd
                   AND cs.custid = cf.custid) LOOP
      l_detail_msg_tmp := l_detail_msg_format;
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp, '<$AUTOID>', rec.autoid);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp, '<$CUSTID>', rec.custid);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,'<$CUSTNAME>',rec.fullname);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,'<$VALDATE>',rec.valdate);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,'<$EXPDATE>',rec.expdate);
      --l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,'<$SIGNATURE>',rec.signature);
      l_detail_msg_tmp:=l_detail_msg_tmp || rec.signature || '"}';
      IF l_detail_msg IS NULL THEN
        l_detail_msg := l_detail_msg || l_detail_msg_tmp;
      ELSE
        l_detail_msg := l_detail_msg || ',' || l_detail_msg_tmp;
      END IF;
    END LOOP;

    l_header_msg := l_header_msg || l_detail_msg ||
                    l_json_msg_format_ending;

    IF l_count = 1 THEN
      l_json_msg_data := l_header_msg;
    ELSE
      l_json_msg_data := l_json_msg_data || ',' || l_header_msg;
    END IF;
    RETURN l_json_msg_data;
    plog.setendsection(pkgctx, 'fn_getcfsign');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'pck_ors_api.fn_getcfsign');
      RETURN fn_get_error_message('-1');
  END fn_getcfsign;
  FUNCTION fn_getotright(p_custodycd IN VARCHAR2) RETURN CLOB IS
    -- chua lay thoi han chu ky
    l_header_msg             CLOB;
    l_detail_msg_format      CLOB;
    l_detail_msg             CLOB;
    l_detail_msg_tmp         CLOB;
    l_json_msg_format_ending CLOB;
    l_json_msg_data          CLOB;
    l_json_msg_format        CLOB;
    l_count                  INTEGER;
    l_hasmore                VARCHAR2(20) := 'false';
    l_json_msg               CLOB;
    l_maxsize                INTEGER := 1000;
    l_id                     VARCHAR2(20);
  BEGIN
    plog.setbeginsection(pkgctx, 'fn_getotright');
    l_json_msg_format        := '{"object":"otright", "custodycd": "<$CUSTODYCD>", "otrightInfo" : [';
    l_json_msg_format_ending := ']}';
    l_detail_msg_format      := '{"autoid": "<$AUTOID>", "custid": "<$CUSTID>", "authcustid": "<$AUTHCUSTID>", "fullname": "<$FULLNAME>", "idcode": "<$IDCODE>", "address": "<$ADDRESS>", '
                             || '"mobile":"<$MOBILE>", "valdate":"<$VALDATE>", "expdate":"<$EXPDATE>", "serialtoken":"<$SERIALTOKEN>", "serialnumsig":"<$SERIALNUMSIG>","asgntype":"<$ASGNTYPE>", "authtype":"<$AUTHTYPE>", '
                             || '"via":"<$VIA>", "viadesc":"<$VIADESC>"}';

    l_id             := NVL(p_custodycd, '%');
    l_header_msg     := '';
    l_detail_msg_tmp := '';
    l_detail_msg     := '';
    l_header_msg     := '';
    l_json_msg_data  := '';
    l_count          := 0;
    IF p_custodycd IS NOT NULL THEN
      l_count      := l_count + 1;
      l_header_msg := l_json_msg_format;
      l_header_msg := REPLACE(l_header_msg, '<$CUSTODYCD>', p_custodycd);
    ELSE
      RETURN fn_get_error_message('-100078');
    END IF;
    FOR rec IN (SELECT OT.AUTOID,
                       (case when OT.cfCUSTID <> OT.AUTHCUSTID then OT.AUTHCUSTID else OT.cfCUSTID end) CUSTID,
                       OT.AUTHCUSTID,
                       CF.FULLNAME,
                       CF.IDCODE,
                       CF.ADDRESS,
                       CF.MOBILE,
                       TO_CHAR(OT.VALDATE, systemnums.C_DATE_FORMAT) VALDATE,
                       TO_CHAR(OT.EXPDATE, systemnums.C_DATE_FORMAT) EXPDATE,
                       A1.CDCONTENT ASGNTYPE,
                       decode (ot.authtype, 2, '{'||cf.custodycd||'{' || ot.authtype || '{' || cf.mobilesms || '}}}',
                                            3, '{'||cf.custodycd||'{' || ot.authtype || '{' || cf.mobilesms || '}}}',
                                            '') SERIALTOKEN,
                       ot.serialnumsig,
                       ot.via,
                       a2.cdcontent viadesc,
                       ot.authtype
                FROM otright OT, cfmast CF, allcode A1, allcode a2
                WHERE (CF.CUSTID = OT.AUTHCUSTID AND CF.CUSTID = OT.cfCUSTID)
                AND OT.DELTD = 'N'
                AND A1.cdtype = 'CF' AND A1.cdname = 'AUTHTYPE'
                AND A1.cdval = (CASE WHEN OT.AUTHCUSTID = CF.CUSTID THEN 'OWNER' ELSE 'AUTHORIZED' END)
                AND a2.cdtype = 'CF' AND a2.cdname = 'VIATYPE' AND ot.via = a2.cdval
                AND cf.custodycd = p_custodycd
                AND ot.via IN ('A','O','M') -- chi lay kenh FDS su dung
                ORDER BY ot.via
 ) LOOP
      l_detail_msg_tmp := l_detail_msg_format;
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,'<$AUTOID>', rec.autoid);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,'<$CUSTID>', rec.custid);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,'<$AUTHCUSTID>',rec.authcustid);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,'<$FULLNAME>',rec.fullname);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,'<$IDCODE>',rec.idcode);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,'<$ADDRESS>',rec.address);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,'<$MOBILE>',rec.mobile);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,'<$VALDATE>',rec.valdate);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,'<$EXPDATE>',rec.expdate);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,'<$SERIALTOKEN>',rec.SERIALTOKEN);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,'<$AUTHTYPE>',rec.authtype);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,'<$SERIALNUMSIG>',rec.serialnumsig);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,'<$VIA>',rec.VIA);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,'<$VIADESC>',rec.VIADESC);
      l_detail_msg_tmp := REPLACE(l_detail_msg_tmp,'<$ASGNTYPE>',rec.ASGNTYPE);

      IF l_detail_msg IS NULL THEN
        l_detail_msg := l_detail_msg || l_detail_msg_tmp;
      ELSE
        l_detail_msg := l_detail_msg || ',' || l_detail_msg_tmp;
      END IF;
    END LOOP;

    l_header_msg := l_header_msg || l_detail_msg ||
                    l_json_msg_format_ending;

    IF l_count = 1 THEN
      l_json_msg_data := l_header_msg;
    ELSE
      l_json_msg_data := l_json_msg_data || ',' || l_header_msg;
    END IF;

    plog.setendsection(pkgctx, 'fn_getotright');
    RETURN l_json_msg_data;
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'fn_getotright');
      RETURN fn_get_error_message('-1');
  END ;

  PROCEDURE fn_getUserLogin2(pv_json_input IN VARCHAR2, pv_json_output IN OUT VARCHAR2)
  IS
    l_json_msg_format        CLOB;
    l_json_err_format        CLOB;
    l_count                  INTEGER := 0;
    l_hasmore                VARCHAR2(20) := 'false';
    l_json_msg               CLOB;
    l_json_data              json;
    v_userName               VARCHAR2(1000);
    v_passWord               VARCHAR2(4000);
    v_via                    VARCHAR2(10);
    v_isCheckPass            VARCHAR2(10);
  BEGIN
    plog.setBeginSection(pkgctx,'fn_getuserlogin2');
    l_json_data := json_parser.parser(UPPER(pv_json_input));
    v_userName    := json_ext.get_string(l_json_data, 'SUSERNAME', 1);
    v_passWord    := json_ext.get_string(l_json_data, 'SPASSWORD', 1);
    v_via         := json_ext.get_string(l_json_data, 'VIA', 1);
    v_isCheckPass := json_ext.get_string(l_json_data, 'ISCHECKPASS', 1);

    l_json_msg_format  := '{"object": "userlogin", "ErrorCode": "0", "userName": "<$USERNAME>", "handPhone": "<$HANDPHONE>", "loginPWD": "<$LOGINPWD>", "tradingPWD": "<$TRADINGPWD>", "sex": "<$SEX>", '
                       || '"authType": "<$AUTHTYPE>", "status": "<$STATUS>", "loginStatus": "<$LOGINSTATUS>", "lastChanged" : "<$LASTCHANGED>", "numberOfDay": "<$NUMBEROFDAY>", '
                       || '"isReset": "<$ISRESET>", "isMaster": "<$ISMASTER>", "loginFail": "<$LOGINFAIL>", "loginFailMax": "<$LOGINFAILMAX>", '
                       || '"custID": "<$CUSTID>", "fullName": "<$FULLNAME>", "custodycd": "<$CUSTODYCD>", "email": "<$EMAIL>", "isBanking": "<$ISBANKING>", "isLocal": "<$ISLOCAL>", "tokenID": "<$TOKENID>", '
                       || '"cfmastStatus": "<$CFMASTSTATUS>", "userLoginStatus": "<$USERLOGINSTATUS>", "lastLogin": "<$LASTLOGIN>", "serialnumsig": "<$SERIALNUMSIG>"}';
    l_json_err_format  := '{"object": "userlogin", "ErrorCode": "-107", "ErrorMessage": "[H107]: Ten dang nhap hoac mat khau khong dung"}';

      FOR rec IN
    (
      SELECT * FROM (
        SELECT U.USERNAME,U.HANDPHONE,U.LOGINPWD,U.TRADINGPWD TRADEPWD,ot.AUTHTYPE,U.STATUS,U.LOGINSTATUS,
               TO_CHAR(U.LASTCHANGED,systemnums.C_DATE_FORMAT) LASTCHANGED,
               TO_CHAR(U.LASTLOGIN,systemnums.C_DATE_FORMAT) LASTLOGIN,
               U.NUMBEROFDAY,U.ISRESET,U.ISMASTER,
               CF.CUSTID,CF.FULLNAME,CF.CUSTODYCD,CF.EMAIL,
               '' ISBANKING,'' ISLOCAL,
               --CASE WHEN ot.authtype IN ('1', '2') THEN '{'||cf.custodycd||'{' || ot.authtype || '{' || cf.mobilesms || '}}}' ELSE '' END TOKENID,
               CASE WHEN ot.authtype = '1' THEN '{KBSV{SMS{' || cf.mobile || '},EMAIL{' || cf.email || '}}}'
                    WHEN ot.authtype = '2' THEN '{'||cf.custodycd||'{' || ot.authtype || '{' || cf.mobilesms || '}}}'
                    ELSE '' END TOKENID,
               ot.SERIALNUMSIG,
               CF.STATUS CFMASTSTATUS, U.STATUS USERLOGINSTATUS, cf.sex
          FROM USERLOGIN U, cfmast CF, otright ot
         WHERE U.USERNAME = CF.USERNAME
           AND U.USERNAME = UPPER(v_userName)
           AND (U.LOGINPWD = LOWER(v_passWord) OR NVL(v_isCheckPass, 'Y') = 'N')
           AND cf.custid = ot.cfcustid AND cf.custid = ot.authcustid
           AND ot.via IN ('A', v_via)
           AND U.STATUS <> 'E'
           AND ot.deltd = 'N'
         ORDER BY decode(via, 'A', 2, 1))
      WHERE ROWNUM = 1
    ) LOOP
      l_count := 1;
      l_json_msg_format := REPLACE(l_json_msg_format,'<$USERNAME>',rec.USERNAME);
      l_json_msg_format := REPLACE(l_json_msg_format,'<$HANDPHONE>',rec.HANDPHONE);
      l_json_msg_format := REPLACE(l_json_msg_format,'<$LOGINPWD>',rec.LOGINPWD);
      l_json_msg_format := REPLACE(l_json_msg_format,'<$TRADINGPWD>',rec.TRADEPWD);
      l_json_msg_format := REPLACE(l_json_msg_format,'<$AUTHTYPE>',rec.AUTHTYPE);
      l_json_msg_format := REPLACE(l_json_msg_format,'<$STATUS>',rec.STATUS);
      l_json_msg_format := REPLACE(l_json_msg_format,'<$LOGINSTATUS>',rec.LOGINSTATUS);
      l_json_msg_format := REPLACE(l_json_msg_format,'<$LASTCHANGED>',rec.lASTCHANGED);
      l_json_msg_format := REPLACE(l_json_msg_format,'<$NUMBEROFDAY>',rec.NUMBEROFDAY);
      l_json_msg_format := REPLACE(l_json_msg_format,'<$LASTLOGIN>',rec.LASTLOGIN);
      l_json_msg_format := REPLACE(l_json_msg_format,'<$ISRESET>',rec.ISRESET);
      l_json_msg_format := REPLACE(l_json_msg_format,'<$ISMASTER>',rec.ISMASTER);
      l_json_msg_format := REPLACE(l_json_msg_format,'<$LOGINFAIL>','');
      l_json_msg_format := REPLACE(l_json_msg_format,'<$LOGINFAILMAX>','');
      l_json_msg_format := REPLACE(l_json_msg_format,'<$CUSTID>',rec.CUSTID);
      l_json_msg_format := REPLACE(l_json_msg_format,'<$FULLNAME>',rec.FULLNAME);
      l_json_msg_format := REPLACE(l_json_msg_format,'<$CUSTODYCD>',rec.custodycd);
      l_json_msg_format := REPLACE(l_json_msg_format,'<$EMAIL>',rec.EMAIL);
      l_json_msg_format := REPLACE(l_json_msg_format,'<$ISBANKING>',rec.ISBANKING);
      l_json_msg_format := REPLACE(l_json_msg_format,'<$ISLOCAL>',rec.ISLOCAL);
      l_json_msg_format := REPLACE(l_json_msg_format,'<$TOKENID>',rec.TOKENID);
      l_json_msg_format := REPLACE(l_json_msg_format,'<$CFMASTSTATUS>',rec.CFMASTSTATUS);
      l_json_msg_format := REPLACE(l_json_msg_format,'<$USERLOGINSTATUS>',rec.USERLOGINSTATUS);
      l_json_msg_format := REPLACE(l_json_msg_format,'<$LASTLOGIN>',rec.LASTLOGIN);
      l_json_msg_format := REPLACE(l_json_msg_format,'<$SERIALNUMSIG>',rec.SERIALNUMSIG);
      l_json_msg_format := REPLACE(l_json_msg_format,'<$SEX>',rec.sex);
    END LOOP;
    IF l_count = 0 THEN
      pv_json_output := l_json_err_format;
      plog.setendsection(pkgctx, 'fn_getuserlogin2');
      RETURN;
    END IF;
    pv_json_output := l_json_msg_format;
    plog.setendsection(pkgctx, 'fn_getuserlogin2');
    RETURN;
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'fn_getuserlogin2');
      pv_json_output := fn_get_error_message('-1');
  END fn_getuserlogin2;
  FUNCTION fn_getUserLoginInfo(p_userName IN VARCHAR2) RETURN CLOB
  IS
    l_json_msg_format        CLOB;
    l_json_err_format        CLOB;
    l_count                  INTEGER := 0;
    l_hasmore                VARCHAR2(20) := 'false';
    l_json_msg               CLOB;
  BEGIN
    plog.setBeginSection(pkgctx, 'fn_getUserLoginInfo');
    l_json_msg_format := '{"object": "userlogin", "ErrorCode": "0", "loginFail": "<$LOGINFAIL>", "loginFailMax": "<$LOGINFAILMAX>", "lastLoginFail": "<$LASTLOGINFAIL>"}';
    l_json_msg_format := REPLACE(l_json_msg_format,'<$LOGINFAIL>','');
    l_json_msg_format := REPLACE(l_json_msg_format,'<$LOGINFAILMAX>','');
    l_json_msg_format := REPLACE(l_json_msg_format,'<$LASTLOGINFAIL>','');
    RETURN l_json_msg_format;
    plog.setendsection(pkgctx, 'fn_getUserLoginInfo');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'fn_getUserLoginInfo');
      RETURN fn_get_error_message('-1');
  END fn_getUserLoginInfo;
  PROCEDURE pr_checkTradingPWD(pv_json_input IN VARCHAR2, pv_json_output IN OUT VARCHAR2)
  IS
    l_json_msg_format        CLOB;
    l_json_err_format        CLOB;
    l_count                  INTEGER := 0;
    l_hasmore                VARCHAR2(20) := 'false';
    l_json_msg               CLOB;
    l_json_data              json;
    v_userName               VARCHAR2(1000);
    v_passWord               VARCHAR2(4000);
  BEGIN
    plog.setBeginSection(pkgctx,'pr_checkTradingPWD');
    l_json_data := json_parser.parser(pv_json_input);
    v_userName    := json_ext.get_string(l_json_data, 'userName', 1);
    v_passWord    := json_ext.get_string(l_json_data, 'tradingPWD', 1);
    l_json_msg_format  := '{"object": "userlogin", "ErrorCode": "0", "custid": "<$CUSTID>"}';

      FOR rec IN
    (
      SELECT CF.CUSTID FROM USERLOGIN U, cfmast CF
      WHERE U.USERNAME=CF.USERNAME AND CF.STATUS='A'
      AND U.USERNAME=UPPER(v_userName) AND U.TRADINGPWD=LOWER(v_passWord)
    ) LOOP
      l_count := 1;
      l_json_msg_format := REPLACE(l_json_msg_format,'<$CUSTID>',rec.CUSTID);
    END LOOP;
    l_json_msg_format := REPLACE(l_json_msg_format,'<$CUSTID>','');
    pv_json_output := l_json_msg_format;
    plog.setendsection(pkgctx, 'pr_checkTradingPWD');
    RETURN;
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'pr_checkTradingPWD');
      pv_json_output := fn_get_error_message('-1');
  END;
BEGIN
  --get current schema
  SELECT SYS_CONTEXT('userenv', 'current_schema')
    INTO ownerschema
    FROM DUAL;

  databaseCache := false;

  FOR i IN (SELECT * FROM tlogdebug) LOOP
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  END LOOP;

  pkgctx := plog.init('txpks_msg',
                      plevel     => NVL(logrow.loglevel, 30),
                      plogtable  => (NVL(logrow.log4table, 'Y') = 'Y'),
                      palert     => (logrow.log4alert = 'Y'),
                      ptrace     => (logrow.log4trace = 'Y'));

END;
/


-- End of DDL Script for Package Body HOSTMSTRADE.PCK_ORS_API

