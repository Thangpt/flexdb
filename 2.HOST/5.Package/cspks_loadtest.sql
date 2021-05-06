CREATE OR REPLACE PACKAGE cspks_loadtest
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
     **  FSS      20-mar-2010    Created
     ** (c) 2008 by Financial Software Solutions. JSC.
     ----------------------------------------------------------------------------------------------------*/
PROCEDURE sp_Load_gen1140(p_account varchar,
                            p_amount number,
                            p_err_code  OUT varchar2,
                            p_err_message out varchar2);
PROCEDURE sp_Load_gen2245(p_account varchar,
                          p_symbol varchar,
                            p_amount number,
                            p_err_code  OUT varchar2,
                            p_err_message out varchar2);
PROCEDURE  sp_LoadUAT_InitData (pv_numAccount number,
                                pv_numAmount number,
                                pv_numQuantity number);
PROCEDURE  sp_LoadUAT_PlaceOrder (p_startAccount varchar2,p_NumAcc number, p_NumOrder number);
PROCEDURE  sp_LoadUAT_Reset_PlaceOrder;
PROCEDURE sp_Load_genUserLogin(p_afacctno varchar);
PROCEDURE  sp_LoadUAT_Init_Sec_CA (pv_NumAccount number,
                                pv_startAccount varchar2,
                                pv_Symbol varchar2,
                                pv_numQuantity number);
PROCEDURE sp_LoadUAT_matching_order (v_offTllogfld varchar2 default 'Y');
PROCEDURE sp_Full_matching_order (v_offTllogfld varchar2 default 'Y');
END;
/

CREATE OR REPLACE PACKAGE BODY cspks_loadtest
IS
   -- declare log context
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

-- initial LOG


PROCEDURE sp_Load_genUserLogin(p_afacctno varchar)
IS
      l_txmsg               tx.msg_rectype;
Begin
    plog.setbeginsection(pkgctx, 'sp_Load_genUserLogin');
    for rec in (
        select cf.custodycd, cf.custid, af.acctno from afmast af, cfmast cf
        where af.custid= cf.custid and af.acctno = p_afacctno
    )
    loop
        delete from userlogin where USERNAME=rec.custodycd;
        INSERT INTO userlogin (USERNAME,HANDPHONE,LOGINPWD,TRADINGPWD,AUTHTYPE,STATUS,LOGINSTATUS,LASTCHANGED,NUMBEROFDAY,LASTLOGIN,ISRESET,ISMASTER,TOKENID)
        VALUES(rec.custodycd,NULL,genencryptpassword('123456'),genencryptpassword('123456'),'N','A','O',sysdate,999,sysdate,'N','N','TOKEN1');

        UPDATE AFMAST SET TRADEONLINE='Y' WHERE acctno=rec.acctno;
        delete from otright where AFACCTNO=rec.acctno and AUTHCUSTID = rec.custid;
        INSERT INTO otright (AUTOID,AFACCTNO,AUTHCUSTID,AUTHTYPE,VALDATE,EXPDATE,DELTD,LASTDATE,LASTCHANGE)
        VALUES(seq_otright.nextval,rec.acctno,rec.custid,'0',TO_DATE('2000-05-18 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),TO_DATE('2033-05-18 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),'N',NULL,sysdate);

        delete from otrightdtl where AFACCTNO=rec.acctno and AUTHCUSTID = rec.custid;
        INSERT INTO otrightdtl (AUTOID,AFACCTNO,AUTHCUSTID,OTMNCODE,OTRIGHT,DELTD)
        VALUES(seq_otrightdtl.nextval,rec.acctno,rec.custid,'ADWINPUT','YYYY','N');
        INSERT INTO otrightdtl (AUTOID,AFACCTNO,AUTHCUSTID,OTMNCODE,OTRIGHT,DELTD)
        VALUES(seq_otrightdtl.nextval,rec.acctno,rec.custid,'ISSUEINPUT','YYYY','N');
        INSERT INTO otrightdtl (AUTOID,AFACCTNO,AUTHCUSTID,OTMNCODE,OTRIGHT,DELTD)
        VALUES(seq_otrightdtl.nextval,rec.acctno,rec.custid,'MORTGAGE','YYYY','N');
        INSERT INTO otrightdtl (AUTOID,AFACCTNO,AUTHCUSTID,OTMNCODE,OTRIGHT,DELTD)
        VALUES(seq_otrightdtl.nextval,rec.acctno,rec.custid,'COND_ORDER','YYYY','N');
        INSERT INTO otrightdtl (AUTOID,AFACCTNO,AUTHCUSTID,OTMNCODE,OTRIGHT,DELTD)
        VALUES(seq_otrightdtl.nextval,rec.acctno,rec.custid,'DEPOSIT','YYYY','N');
        INSERT INTO otrightdtl (AUTOID,AFACCTNO,AUTHCUSTID,OTMNCODE,OTRIGHT,DELTD)
        VALUES(seq_otrightdtl.nextval,rec.acctno,rec.custid,'CASHTRANS','YYYY','N');
        INSERT INTO otrightdtl (AUTOID,AFACCTNO,AUTHCUSTID,OTMNCODE,OTRIGHT,DELTD)
        VALUES(seq_otrightdtl.nextval,rec.acctno,rec.custid,'ORDINPUT','YYYY','N');
        INSERT INTO otrightdtl (AUTOID,AFACCTNO,AUTHCUSTID,OTMNCODE,OTRIGHT,DELTD)
        VALUES(seq_otrightdtl.nextval,rec.acctno,rec.custid,'GROUP_ORDER','YYYY','N');
        INSERT INTO otrightdtl (AUTOID,AFACCTNO,AUTHCUSTID,OTMNCODE,OTRIGHT,DELTD)
        VALUES(seq_otrightdtl.nextval,rec.acctno,rec.custid,'SMARTALERT','YYYY','N');
        INSERT INTO otrightdtl (AUTOID,AFACCTNO,AUTHCUSTID,OTMNCODE,OTRIGHT,DELTD)
        VALUES(seq_otrightdtl.nextval,rec.acctno,rec.custid,'MARKETALERT','YYYY','N');
        INSERT INTO otrightdtl (AUTOID,AFACCTNO,AUTHCUSTID,OTMNCODE,OTRIGHT,DELTD)
        VALUES(seq_otrightdtl.nextval,rec.acctno,rec.custid,'COMPANYALERT','YYYY','N');
    end loop;
    plog.setendsection (pkgctx, 'sp_Load_genUserLogin');
EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on sp_Load_genUserLogin');
      ROLLBACK;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'sp_Load_genUserLogin');
      RAISE errnums.E_SYSTEM_ERROR;
END sp_Load_genUserLogin;

PROCEDURE sp_Load_gen1140(p_account varchar,
                            p_amount number,
                            p_err_code  OUT varchar2,
                            p_err_message out varchar2)
  IS
      l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      l_err_param varchar2(300);
      v_recvcustodycd varchar2(300);
      v_recvCUSTNAME    varchar2(300);
      v_recvLICENSE varchar2(300);

  BEGIN
    plog.setbeginsection(pkgctx, 'sp_Load_gen1140');

    SELECT TO_DATE (varvalue, systemnums.c_date_format)
               INTO v_strCURRDATE
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := systemnums.C_ONLINE_USERID;
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
    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd:='1140';

    --Set txnum
    SELECT systemnums.C_OL_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO l_txmsg.txnum
              FROM DUAL;
    l_txmsg.brid        := substr(p_account,1,4);


    -- Lay thong tin khach hang
    SELECT CF.custodycd, CF.fullname, CF.idcode
    INTO v_recvcustodycd, v_recvCUSTNAME, v_recvLICENSE
    FROM CFMAST CF, AFMAST AF
    WHERE CF.custid = AF.custid AND AF.acctno = p_account;

    --Set cac field giao dich
    --03   ACCTNO     C
    l_txmsg.txfields ('03').defname   := 'ACCTNO';
    l_txmsg.txfields ('03').TYPE      := 'C';
    l_txmsg.txfields ('03').VALUE     := p_account;
    --10   AMT         N
    l_txmsg.txfields ('10').defname   := 'AMT';
    l_txmsg.txfields ('10').TYPE      := 'N';
    l_txmsg.txfields ('10').VALUE     := round(p_amount,0);
    --30   DESC        C
    l_txmsg.txfields ('30').defname   := 'DESC';
    l_txmsg.txfields ('30').TYPE      := 'C';
    l_txmsg.txfields ('30').VALUE :='Chuyen tien Loadtest';


    --88  CUSTODYCD   C
    l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
    l_txmsg.txfields ('88').TYPE      := 'C';
    l_txmsg.txfields ('88').VALUE :=v_recvcustodycd;
    --90  CUSTNAME    C
    l_txmsg.txfields ('90').defname   := 'CUSTNAME';
    l_txmsg.txfields ('90').TYPE      := 'C';
    l_txmsg.txfields ('90').VALUE :=v_recvCUSTNAME;
    --91  ADDRESS     C
    l_txmsg.txfields ('91').defname   := 'ADDRESS';
    l_txmsg.txfields ('91').TYPE      := 'C';
    l_txmsg.txfields ('91').VALUE :='';
    --92  LICENSE     C
    l_txmsg.txfields ('92').defname   := 'LICENSE';
    l_txmsg.txfields ('92').TYPE      := 'C';
    l_txmsg.txfields ('92').VALUE :=v_recvLICENSE;
    --93  IDDATE      C
    l_txmsg.txfields ('93').defname   := 'IDDATE';
    l_txmsg.txfields ('93').TYPE      := 'C';
    l_txmsg.txfields ('93').VALUE :='';
    --94  IDPLACE     C
    l_txmsg.txfields ('94').defname   := 'IDPLACE';
    l_txmsg.txfields ('94').TYPE      := 'C';
    l_txmsg.txfields ('94').VALUE :='';
    --95  FULLNAME    C
    l_txmsg.txfields ('95').defname   := 'FULLNAME';
    l_txmsg.txfields ('95').TYPE      := 'C';
    l_txmsg.txfields ('95').VALUE :=v_recvLICENSE;

    BEGIN
        IF txpks_#1140.fn_autotxprocess (l_txmsg,
                                         p_err_code,
                                         l_err_param
           ) <> systemnums.c_success
        THEN
           plog.debug (pkgctx,
                       'got error 1140: ' || p_err_code
           );
           ROLLBACK;
           p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
           plog.error(pkgctx, 'Error:'  || p_err_message);
           plog.setendsection(pkgctx, 'pr_placeorder');
           RETURN;
        END IF;
    END;
    commit;
    p_err_code:='0';
    plog.setendsection(pkgctx, 'sp_Load_gen1140');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on sp_Load_gen1140');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'sp_Load_gen1140');
      RAISE errnums.E_SYSTEM_ERROR;
  END sp_Load_gen1140;


PROCEDURE sp_Load_gen2245(p_account varchar,
                          p_symbol varchar,
                            p_amount number,
                            p_err_code  OUT varchar2,
                            p_err_message out varchar2)
  IS
      l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      l_err_param varchar2(300);
      v_recvcustodycd varchar2(300);
      v_recvCUSTNAME    varchar2(300);
      v_recvLICENSE varchar2(300);
      v_codeid varchar2(10);
      v_tradeunit number;
      l_sectype varchar2(20);
      l_custid varchar2(20);
      l_count number;
  BEGIN
    plog.setbeginsection(pkgctx, 'sp_Load_gen2245');

    SELECT TO_DATE (varvalue, systemnums.c_date_format)
               INTO v_strCURRDATE
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := systemnums.C_ONLINE_USERID;
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
    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate:=to_date('12/03/2012','DD/MM/RRRR');--to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd:='2245';
    select codeid  into v_codeid from sbsecurities where symbol =p_symbol;
    v_tradeunit:=10000;
    --Set txnum
    SELECT systemnums.C_OL_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO l_txmsg.txnum
              FROM DUAL;
    l_txmsg.brid        := substr(p_account,1,4);


    -- Lay thong tin khach hang
    SELECT CF.custodycd, CF.fullname, CF.idcode
    INTO v_recvcustodycd, v_recvCUSTNAME, v_recvLICENSE
    FROM CFMAST CF, AFMAST AF
    WHERE CF.custid = AF.custid AND AF.acctno = p_account;


    SELECT count(*) INTO l_count
    FROM SEMAST
    WHERE ACCTNO= p_account || v_codeid;

    IF l_count = 0 THEN
         BEGIN
             SELECT b.setype,a.custid
             INTO l_sectype,l_custid
             FROM AFMAST A, aftype B
             WHERE  A.actype= B.actype
             AND a.ACCTNO = p_account;
         EXCEPTION
             WHEN NO_DATA_FOUND THEN
             p_err_code := errnums.C_CF_REGTYPE_NOT_FOUND;
             RAISE errnums.E_CF_REGTYPE_NOT_FOUND;
         END;
         INSERT INTO SEMAST
         (ACTYPE,CUSTID,ACCTNO,CODEID,AFACCTNO,OPNDATE,LASTDATE,COSTDT,TBALDT,STATUS,IRTIED,IRCD,
         COSTPRICE,TRADE,MORTAGE,MARGIN,NETTING,STANDING,WITHDRAW,DEPOSIT,LOAN)
         VALUES(
         l_sectype, l_custid, p_account || v_codeid,v_codeid,p_account,
         TO_DATE(  l_txmsg.txdate , systemnums.C_DATE_FORMAT ),TO_DATE(  l_txmsg.txdate ,   systemnums.C_DATE_FORMAT ),
         TO_DATE(  l_txmsg.txdate , systemnums.C_DATE_FORMAT ),TO_DATE(  l_txmsg.txdate ,   systemnums.C_DATE_FORMAT ),
         'A','Y','000', 0,0,0,0,0,0,0,0,0);
    END IF;
    --Set cac field giao dich
    --00   FEETYPE     C
    l_txmsg.txfields ('00').defname   := 'FEETYPE';
    l_txmsg.txfields ('00').TYPE      := 'C';
    l_txmsg.txfields ('00').VALUE     := 0;
    --01   CODEID     C
    l_txmsg.txfields ('01').defname   := 'CODEID';
    l_txmsg.txfields ('01').TYPE      := 'C';
    l_txmsg.txfields ('01').VALUE     := v_codeid;
    --03   INWARD     C
    l_txmsg.txfields ('03').defname   := 'INWARD';
    l_txmsg.txfields ('03').TYPE      := 'C';
    l_txmsg.txfields ('03').VALUE     := '001';
    --04   AFACCT2     C
    l_txmsg.txfields ('04').defname   := 'AFACCT2';
    l_txmsg.txfields ('04').TYPE      := 'C';
    l_txmsg.txfields ('04').VALUE     := p_account;
    --05  ACCT2       C
    l_txmsg.txfields ('05').defname   := 'ACCT2';
    l_txmsg.txfields ('05').TYPE      := 'C';
    l_txmsg.txfields ('05').VALUE     := p_account || v_codeid;
    --06  DEPOBLOCK   N
    l_txmsg.txfields ('06').defname   := 'DEPOBLOCK';
    l_txmsg.txfields ('06').TYPE      := 'N';
    l_txmsg.txfields ('06').VALUE     := 0;
    --09  PRICE       N
    l_txmsg.txfields ('09').defname   := 'PRICE';
    l_txmsg.txfields ('09').TYPE      := 'N';
    l_txmsg.txfields ('09').VALUE     := v_tradeunit;
    --10   AMT         N
    l_txmsg.txfields ('10').defname   := 'AMT';
    l_txmsg.txfields ('10').TYPE      := 'N';
    l_txmsg.txfields ('10').VALUE     := round(p_amount,0);
    --11   AMT         N
    l_txmsg.txfields ('11').defname   := 'AMT';
    l_txmsg.txfields ('11').TYPE      := 'N';
    l_txmsg.txfields ('11').VALUE     := 10000;
    --12  QTTY        N
    l_txmsg.txfields ('12').defname   := 'AMT';
    l_txmsg.txfields ('12').TYPE      := 'N';
    l_txmsg.txfields ('12').VALUE     := round(p_amount,0);
    --13  DEPOFEEACR        N
    l_txmsg.txfields ('13').defname   := 'DEPOFEEACR';
    l_txmsg.txfields ('13').TYPE      := 'N';
    l_txmsg.txfields ('13').VALUE     := 0;
    --14  QTTYTYPE       N
    l_txmsg.txfields ('14').defname   := 'QTTYTYPE';
    l_txmsg.txfields ('14').TYPE      := 'C';
    l_txmsg.txfields ('14').VALUE     := '002';
    --15  DEPOFEEAMT        N
    l_txmsg.txfields ('15').defname   := 'DEPOFEEAMT';
    l_txmsg.txfields ('15').TYPE      := 'N';
    l_txmsg.txfields ('15').VALUE     := 0;
    --30   DESC        C
    l_txmsg.txfields ('30').defname   := 'DESC';
    l_txmsg.txfields ('30').TYPE      := 'C';
    l_txmsg.txfields ('30').VALUE :='Chuyen chung khoan Loadtest';
    --31   TRTYPE        C
    l_txmsg.txfields ('31').defname   := 'TRTYPE';
    l_txmsg.txfields ('31').TYPE      := 'C';
    l_txmsg.txfields ('31').VALUE :='001';
    --32   DEPOLASTDT        C
    l_txmsg.txfields ('32').defname   := 'DEPOLASTDT';
    l_txmsg.txfields ('32').TYPE      := 'C';
    l_txmsg.txfields ('32').VALUE :='';

    --88  CUSTODYCD   C
    l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
    l_txmsg.txfields ('88').TYPE      := 'C';
    l_txmsg.txfields ('88').VALUE :=v_recvcustodycd;
    --90  CUSTNAME    C
    l_txmsg.txfields ('90').defname   := 'CUSTNAME';
    l_txmsg.txfields ('90').TYPE      := 'C';
    l_txmsg.txfields ('90').VALUE :=v_recvCUSTNAME;
    --91  ADDRESS     C
    l_txmsg.txfields ('91').defname   := 'ADDRESS';
    l_txmsg.txfields ('91').TYPE      := 'C';
    l_txmsg.txfields ('91').VALUE :='';
    --92  LICENSE     C
    l_txmsg.txfields ('92').defname   := 'LICENSE';
    l_txmsg.txfields ('92').TYPE      := 'C';
    l_txmsg.txfields ('92').VALUE :=v_recvLICENSE;
    --99  AUTOID      C
    l_txmsg.txfields ('99').defname   := 'AUTOID';
    l_txmsg.txfields ('99').TYPE      := 'C';
    l_txmsg.txfields ('99').VALUE :='';

    BEGIN
        IF txpks_#2245.fn_autotxprocess (l_txmsg,
                                         p_err_code,
                                         l_err_param
           ) <> systemnums.c_success
        THEN
           plog.debug (pkgctx,
                       'got error 1140: ' || p_err_code
           );
           ROLLBACK;
           p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
           plog.error(pkgctx, 'Error:'  || p_err_message);
           plog.setendsection(pkgctx, 'pr_placeorder');
           RETURN;
        END IF;
    END;
    commit;
    p_err_code:='0';
    plog.setendsection(pkgctx, 'sp_Load_gen2245');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on sp_Load_gen2245');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'sp_Load_gen2245');
      RAISE errnums.E_SYSTEM_ERROR;
  END sp_Load_gen2245;


PROCEDURE  sp_LoadUAT_InitData (pv_numAccount number,
                                pv_numAmount number,
                                pv_numQuantity number)
is
v_CIAmount number;
v_SEAmount number;
v_symbols varchar2(500);
p_err_code  varchar2(500);
p_err_message varchar2(500);
v_sql varchar2(1000);
begin
v_CIAmount:=pv_numAmount;
v_SEAmount:=pv_numQuantity;
v_symbols:='SSI,VND,SHB,ACB,BVS,KLS,VNM,FPT,STB,SBS,DPM,SCR,PVI,PRUBF1,HNM,AGC,PPC,BVH,MSN,PVX,NTB,HQC,EIB,REE,LGC,HBB,PVL,PGS,VCG,TNG,'; --30Ma CK
/*begin
    v_sql:='drop table LOAD_ACCOUNT;';
    EXECUTE IMMEDIATE v_sql;
    v_sql:='CREATE TABLE LOAD_ACCOUNT (custodycd varchar2(10),
                         afacctno varchar2(10),
                         user_online varchar2(50),
                         trading_pass varchar2(50),
                         login_pass varchar2(50));';
    EXECUTE IMMEDIATE v_sql;
exception when others then
    v_sql:='CREATE TABLE LOAD_ACCOUNT (custodycd varchar2(10),
                         afacctno varchar2(10),
                         user_online varchar2(50),
                         trading_pass varchar2(50),
                         login_pass varchar2(50));';
    EXECUTE IMMEDIATE v_sql;
end;*/
for rec in
(
    select * from (select af.*, cf.custodycd from afmast af, cfmast cf, aftype aft, mrtype mrt
    where af.status ='A' and af.actype = aft.actype and aft.mrtype = mrt.actype-- and mrt.mrtype ='T'
    and af.custid= cf.custid
    and cf.custodycd like '091C%'
    order by acctno) where rownum <=pv_numAccount
)
loop
    insert into LOAD_ACCOUNT (custodycd,afacctno,user_online,trading_pass,login_pass)
    values (rec.custodycd, rec.acctno, rec.custodycd,'123456','123456');
    --Gui tien vao cac tai khoan active
    cspks_loadtest.sp_Load_gen1140(rec.acctno,v_CIAmount,p_err_code,p_err_message);
    for recSymbol in (
        select symbol from sbsecurities where instr(v_symbols,symbol)>0
    )
    loop
        --Do chung khoan
        cspks_loadtest.sp_Load_gen2245(rec.acctno, recSymbol.symbol,v_SEAmount,p_err_code,p_err_message );

    end loop;
    --Gen tai khoan Margin
    cspks_loadtest.sp_Load_genUserLogin (rec.acctno);
end loop;

/*--Set up loai hinh 0017 thanh loai hinh Margin
update aftype set mrtype ='0002', lntype ='8001' where actype ='0017';
--Set up chung khoan Margin tang he thong
delete  from securities_risk where codeid in (select codeid from securities_info where  instr('SSI,VND,SHB,ACB,BVS,KLS,VNM,FPT,STB,SBS,DPM,SCR,PVI,PRUBF1,HNM,AGC,PPC,BVH,MSN,PVX,NTB,HQC,EIB,REE,LGC,HBB,PVL,PGS,VCG,TNG,',
symbol)>0);
insert into securities_risk
select codeid, 100000000 mrmaxqtty,0 mrratiorate,0 mrratioloan, 100000 mrpricerate, 100000 mrpriceloan,'Y' ismarginallow
from securities_info where instr('SSI,VND,SHB,ACB,BVS,KLS,VNM,FPT,STB,SBS,DPM,SCR,PVI,PRUBF1,HNM,AGC,PPC,BVH,MSN,PVX,NTB,HQC,EIB,REE,LGC,HBB,PVL,PGS,VCG,TNG,',
symbol)>0;
--Gen thong tin Margin vao Afserisk

begin
if cspks_saproc.fn_ApplySystemParam(p_err_code) <> 0 then
    commit;
end if;
end;
--Cap nhat thong tin Room chung khoan
update securities_info set marginrefprice=basicprice, marginprice=floorprice, syroomlimit=100000000;*/

commit;
end;

PROCEDURE  sp_LoadUAT_Init_Sec_CA (pv_NumAccount number,
                                pv_startAccount varchar2,
                                pv_Symbol varchar2,
                                pv_numQuantity number)
is
v_CIAmount number;
v_SEAmount number;
v_symbols varchar2(500);
p_err_code  varchar2(500);
p_err_message varchar2(500);
v_sql varchar2(1000);
begin
for rec in
(
    select * from (select af.*, cf.custodycd from afmast af, cfmast cf
    where af.status ='A'
    and af.custid= cf.custid
    and cf.custodycd like '091C%' and custodycd >=pv_startAccount
    order by acctno) where rownum <=pv_numAccount
)
loop
    cspks_loadtest.sp_Load_gen2245(rec.acctno, pv_Symbol,pv_numQuantity,p_err_code,p_err_message );
end loop;
commit;
end;


PROCEDURE  sp_LoadUAT_Reset_PlaceOrder
is
begin
    delete from tllog where txnum like '80%';
    commit;
    delete from tllogfld where txnum like '80%';
    commit;
    delete from odmast where orderid like '80%';
    commit;
    delete from ood where orgorderid like '80%';
    commit;
    delete from iod where orgorderid like '80%';
    commit;
    delete from stschd where orgorderid like '80%';
    commit;
    delete from rootordermap;
    commit;
    delete from afpralloc;
    commit;
    delete from fomast where tlid='6868';
    commit;
    delete from buf_od_account where orderid like '80%';
    commit;
    delete from log_od_account;
    commit;
    delete from fomast where orgacctno not in (select orderid from odmast );
    commit;
end;

PROCEDURE  sp_LoadUAT_PlaceOrder (p_startAccount varchar2,p_NumAcc number, p_NumOrder number)
is
    v_symbolsBUY VARCHAR2(500);
    v_symbolssell VARCHAR2(500);
    v_currdate varchar2(50);
    p_err_code  varchar2(500);
    p_err_message varchar2(500);
begin
    v_symbolsBUY:='SSI,VND,SHB,ACB,BVS,KLS,VNM,FPT,STB,SBS,';
    --v_symbolsBUY:='ACB,BVS,KLS,SHB,VND,'  -- HA
    --v_symbolsBUY:='SSI,VNM,FPT,STB,SBS,'  -- HO

    v_symbolssell:='DPM,SCR,PVI,PRUBF1,HNM,AGC,PPC,BVH,MSN,PVX,';
    select varvalue into v_currdate from sysvar where varname='CURRDATE';
    --NTB,HQC,EIB,REE,LGC,HBB,PVL,PGS,VCG,TNG,'; --30Ma CK
    for rec in
     (
         select A.*, rownum AAA from (select af.* from afmast af, cfmast cf, aftype aft, mrtype mrt
        where af.status ='A'
        and af.custid= cf.custid and af.actype = aft.actype and aft.mrtype = mrt.actype --and mrt.mrtype = 'T'
        and cf.custodycd like '091C%' --and af.acctno =p_startAccount--'0001126869'-->=p_startAccount
        order by acctno) A where rownum <=p_NumAcc
     )
     LOOP
        if floor (rec.AAA/2) * 2 = rec.AAA then
            v_symbolsBUY:='SSI,VND,SHB,ACB,BVS,KLS,VNM,FPT,STB,SBS,';
            v_symbolssell:='DPM,SCR,PVI,PRUBF1,HNM,AGC,PPC,BVH,MSN,PVX,';
        else
            v_symbolsSell:='SSI,VND,SHB,ACB,BVS,KLS,VNM,FPT,STB,SBS,';
            v_symbolsBuy:='DPM,SCR,PVI,PRUBF1,HNM,AGC,PPC,BVH,MSN,PVX,';
        end if;
        FOR I in 0..p_NumOrder
        LOOP
            FOR RECSYM IN (
                SELECT (CASE WHEN INSTR(v_symbolsBUY , symbol)>0 THEN 'NB' ELSE 'NS' END) EXECTYPE, SYMBOL, BASICPRICE/1000 BASICPRICE
                FROM SECURITIES_INFO WHERE INSTR(v_symbolsBUY || v_symbolssell , symbol)>0
            )
            LOOP
                fopks_api.pr_PlaceOrder('PLACEORDER',
                        '0001',
                        '',
                        rec.acctno,
                        RECSYM.EXECTYPE,
                        RECSYM.symbol,
                        100,
                        RECSYM.BASICPRICE,
                        'LO',
                        'T',
                        'A',
                        'T',
                        '',
                        'Y',
                        v_currdate,
                        v_currdate,
                        '0001',
                        p_err_code,
                        p_err_message
                        );
            END LOOP;
            commit;
        END LOOP;

     END LOOP;
end;

PROCEDURE sp_LoadUAT_matching_order (v_offTllogfld varchar2 default 'Y')
IS
   v_tltxcd             VARCHAR2 (30);
   v_txnum              VARCHAR2 (30);
   v_txdate             VARCHAR2 (30);
   v_tlid               VARCHAR2 (30);
   v_brid               VARCHAR2 (30);
   v_ipaddress          VARCHAR2 (30);
   v_wsname             VARCHAR2 (30);
   v_txtime             VARCHAR2 (30);
   v_txdesc             VARCHAR2 (30);
   v_strduetype         VARCHAR (2);
   v_matched            NUMBER (10,2);
   v_ex                 EXCEPTION;
   v_err                VARCHAR2 (100);
   v_temp               NUMBER(10);
   v_mtrfday               NUMBER(10);
   v_refconfirmno       VARCHAR2 (30);
   v_RemainQtty         NUMBER(10);

   Cursor c_SqlMaster Is
        SELECT OD.ORDERID,OD.CODEID,SEC.SYMBOL,OOD.CUSTODYCD,OD.AFACCTNO,OD.SEACCTNO,OD.CIACCTNO,
        (case when od.exectype ='NB' then 'B' else 'S' end) BORS,
        'N' NORP, OD.NORK AORN,
        --B.BSCA BORS,B.NORP,OD.NORK AORN,
        OD.QUOTEPRICE EXPRICE, OD.ORDERQTTY EXQTTY, round(od.remainqtty/2,-2) QTTY,OD.QUOTEPRICE PRICE,'' REFORDERID, '' CONFIRM_NO,
        OD.BRATIO,OD.CLEARDAY,OD.CLEARCD, OOD.CUSTODYCD || '.' || (case when od.exectype ='NB' then 'B' else 'S' end) || '.' || SEC.SYMBOL || '.' || round(od.remainqtty/2,-2) || '.' || OD.QUOTEPRICE  DESCRIPTION
        FROM ODMAST OD,SBSECURITIES SEC,OOD, load_account ld
            WHERE OD.ORDERID=OOD.ORGORDERID AND OD.AFACCTNO = ld.afacctno
            AND OD.CODEID=SEC.CODEID AND SEC.TRADEPLACE in ('001','002')
            and OD.remainqtty>0 and OD.execqtty =0 and round(od.remainqtty/2,-2)>0;

   Cursor c_Odmast(v_OrgOrderID Varchar2) Is
   SELECT REMAINQTTY,EXECQTTY,EXECAMT,CANCELQTTY,ADJUSTQTTY
   FROM ODMAST WHERE TIMETYPE ='G' AND ORDERID=v_OrgOrderID;
   vc_Odmast c_Odmast%Rowtype;

   Cursor c_Odmast_check(v_OrgOrderID Varchar2) Is
   SELECT REMAINQTTY,EXECQTTY,EXECAMT,CANCELQTTY,ADJUSTQTTY
   FROM ODMAST WHERE ORDERID=v_OrgOrderID;

BEGIN

   --0 lay cac tham so
   v_brid := '0000';
   v_tlid := '0000';
   v_ipaddress := 'HOST';
   v_wsname := 'HOST';
   v_tltxcd := '8814';


  For i in c_SqlMaster
  Loop

    --Cap nhat cho GTC
       OPEN c_Odmast_check(i.ORDERID);
       FETCH c_Odmast_check INTO VC_ODMAST;
        IF c_Odmast_check%FOUND THEN
            v_RemainQtty:=VC_ODMAST.REMAINQTTY;
        END IF;
       CLOSE c_Odmast_check;

       If v_RemainQtty >= i.QTTY THEN

             SELECT    '8800'
                  || SUBSTR ('000000' || seq_batchtxnum.NEXTVAL,
                             LENGTH ('000000' || seq_batchtxnum.NEXTVAL) - 5,
                             6
                            )
             INTO v_txnum
             FROM DUAL;

             SELECT TO_CHAR (SYSDATE, 'HH24:MI:SS')
              INTO v_txtime
              FROM DUAL;


              SELECT varvalue
                INTO v_txdate
                FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';


            v_txdesc := i.CUSTODYCD||'.'||i.BORS||'.'||i.SYMBOL||'.'||i.QTTY||'.'||i.PRICE;
  --1.TLLOG
            INSERT INTO tllog
                    (autoid, txnum,
                     txdate, txtime, brid,
                     tlid, offid, ovrrqs, chid, chkid, tltxcd, ibt, brid2, tlid2,
                     ccyusage, txstatus, msgacct, msgamt, chktime, offtime, off_line,
                     deltd, brdate,
                     busdate, msgsts, ovrsts, ipaddress, wsname,
                     batchname, carebygrp, txdesc
                    )
             VALUES (seq_tllog.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), v_txtime, v_brid,
                     v_tlid, '', '', '', '', '8814', '', '', '',
                     '00', '1', i.ORDERID, i.PRICE, '', '', 'N',
                     'N', TO_DATE (v_txdate, 'dd/MM/yyyy'),
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '0', '0', v_ipaddress, v_wsname,
                     'DAY', '', v_txdesc
                    );

        if v_offTllogfld<>'Y' then
  --2.TLLOGFLD
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '03', i.ORDERID, 0
                    );
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '04', i.AFACCTNO, 0
                    );
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '05', i.AFACCTNO, 0
                    );
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '06', i.SEACCTNO, 0
                    );
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '07', i.REFORDERID, 0
                    );
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '08', '', 0
                    );
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '09', i.CLEARCD, 0
                    );

            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '10', '', i.PRICE
                    );
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '11', '', i.QTTY
                    );

            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '12', '', i.EXPRICE
                    );
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '13', '', i.EXQTTY
                    );
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '14', '', i.CLEARDAY
                    );
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '15', '', i.BRATIO
                    );
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '16', i.CONFIRM_NO, 0
                    );
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '17', '', 0
                    );

            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd,
                     cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '30',
                     v_txdesc, 0
                    );

            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '80', i.CODEID, 0
                    );
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '81', i.SYMBOL, 0
                    );
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '82', i.CUSTODYCD, 0
                    );
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '83', i.BORS, 0
                    );
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '84', i.NORP, 0
                    );
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '85', i.AORN, 0
                    );
        end if;
  --3.AFTRAN
            --Thuc hien tran
            INSERT INTO aftran
                    (acctno, txnum,
                     txdate, txcd, namt, camt, REF,
                     deltd, autoid
                    )
             VALUES (i.AFACCTNO, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '0088', i.PRICE * i.QTTY, '', '',
                     'N', seq_aftran.NEXTVAL
                    );

  --4.ODTRAN
            INSERT INTO odtran
                    (acctno, txnum,
                     txdate, txcd, namt, camt, REF,
                     deltd, autoid
                    )
             VALUES (i.ORDERID, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '0028', i.PRICE * i.QTTY, '', '',
                     'N', seq_odtran.NEXTVAL
                    );
            INSERT INTO odtran
                    (acctno, txnum,
                     txdate, txcd, namt, camt,
                     REF, deltd, autoid
                    )
             VALUES (i.ORDERID, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '0013', i.QTTY, '',
                     i.CIACCTNO, 'N', seq_odtran.NEXTVAL
                    );
            INSERT INTO odtran
                    (acctno, txnum,
                     txdate, txcd, namt, camt, REF,
                     deltd, autoid
                    )
             VALUES (i.ORDERID, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '0034', i.PRICE * i.QTTY, '', '',
                     'N', seq_odtran.NEXTVAL
                    );
            INSERT INTO odtran
                    (acctno, txnum,
                     txdate, txcd, namt, camt, REF, deltd,
                     autoid
                    )
             VALUES (i.ORDERID, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '0001', 0, '4', '', 'N',
                     seq_odtran.NEXTVAL
                    );
            INSERT INTO odtran
                    (acctno, txnum,
                     txdate, txcd, namt, camt,
                     REF, deltd, autoid
                    )
             VALUES (i.ORDERID, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '0011', i.QTTY, '',
                     i.CIACCTNO, 'N', seq_odtran.NEXTVAL
                    );

  --5.AFMAST


            UPDATE afmast
             SET dmatchamt = NVL(dmatchamt,0) + i.PRICE * i.QTTY
             WHERE acctno = i.AFACCTNO;


  --6.IOD
            INSERT INTO iod
                    (orgorderid, codeid, symbol, custodycd, bors, norp,
                     txdate, txnum, aorn, price,
                     qtty, exorderid, refcustcd, matchprice, matchqtty, confirm_no,
                     txtime
                    )
             VALUES (i.ORDERID, i.CODEID, i.SYMBOL, i.CUSTODYCD, i.BORS, i.NORP,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), v_txnum , i.AORN, i.EXPRICE,
                     i.EXQTTY, i.REFORDERID, '', i.PRICE, i.QTTY, i.CONFIRM_NO,
                     v_txtime
                    );
  --7.ODMAST
           --Cap nhat Odmast
           UPDATE odmast
           SET execamt = NVL(execamt,0) + i.PRICE * i.QTTY,
               execqtty = NVL(execqtty,0) + i.QTTY,
               matchamt = NVL(matchamt,0) + i.PRICE * i.QTTY,
               porstatus = porstatus || '4',
               orstatus = '4',
               remainqtty = remainqtty - i.QTTY
           WHERE orderid = i.orderid;

            if i.BORS = 'S' then
                -- quyet.kieu : Them cho LINHLNB 21/02/2012
                -- Begin Danh sau tai san LINHLNB
                INSERT INTO odchanging_trigger_log (AFACCTNO,CODEID,AMT,TXNUM,TXDATE,ERRCODE,LAST_CHANGE,ORDERID,ACTIONFLAG, QTTY)
                VALUES( i.AFACCTNO,i.CODEID ,i.price * i.QTTY ,v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),NULL,systimestamp,i.ORDERID,'M',i.QTTY);
                -- End Danh dau tai san LINHLNB
            end if;

/*           INSERT INTO stctradeallocation
                        (txdate, txnum,
                         refconfirmnumber, orderid, bors, volume, price, deltd
                        )
                 VALUES (TO_DATE (v_txdate, 'dd/MM/yyyy'), v_txnum ,
                         i.CONFIRM_NO, i.ORDERID, i.BORS, i.QTTY, i.PRICE, 'N'
                        );*/
   --8.Tao lich thanh toan
        SELECT COUNT (*)
        INTO v_matched
        FROM stschd
        WHERE orgorderid = i.ORDERID AND deltd <> 'Y';

        IF i.BORS = 'B' THEN  --Lenh mua
                select typ.mtrfday into v_mtrfday
                from odmast od, odtype typ
                where od.actype=typ.actype and od.orderid=i.ORDERID;
                --Tao lich thanh toan chung khoan
                 v_strduetype := 'RS';

                 IF v_matched > 0
                 THEN
                    UPDATE stschd
                       SET qtty = qtty + i.QTTY,
                           amt = amt + i.PRICE * i.QTTY
                     WHERE orgorderid = i.ORDERID AND duetype = v_strduetype;
                 ELSE
                    INSERT INTO stschd
                                (autoid, orgorderid, codeid,
                                 duetype, afacctno, acctno,
                                 reforderid, txnum,
                                 txdate, clearday,
                                 clearcd, amt, aamt,
                                 qtty, aqtty, famt, status, deltd, costprice,cleardate
                                )
                         VALUES (seq_stschd.NEXTVAL, i.ORDERID, i.CODEID,
                                 v_strduetype, i.AFACCTNO, i.SEACCTNO,
                                 i.REFORDERID, v_txnum,
                                 TO_DATE (v_txdate, 'DD/MM/YYYY'), i.CLEARDAY,
                                 i.CLEARCD, i.PRICE * i.QTTY, 0,
                                 i.QTTY, 0, 0, 'N', 'N', 0,
                                 GETDUEDATE(TO_DATE (v_txdate, 'DD/MM/YYYY'),i.clearcd,'000',i.clearday)
                                );
                 END IF;

                 --Tao lich thanh toan tien
                 v_strduetype := 'SM';

                 IF v_matched > 0
                 THEN
                    UPDATE stschd
                       SET qtty = qtty + i.QTTY,
                           amt = amt + i.PRICE * i.QTTY
                     WHERE orgorderid = i.ORDERID AND duetype = v_strduetype;
                 ELSE
                    INSERT INTO stschd
                                (autoid, orgorderid, codeid,
                                 duetype, afacctno, acctno,
                                 reforderid, txnum,
                                 txdate, clearday,
                                 clearcd, amt, aamt,
                                 qtty, aqtty, famt, status, deltd, costprice, cleardate
                                )
                         VALUES (seq_stschd.NEXTVAL, i.ORDERID, i.CODEID,
                                 v_strduetype, i.AFACCTNO, i.AFACCTNO,
                                 i.REFORDERID, v_txnum,
                                 TO_DATE (v_txdate, 'DD/MM/YYYY'), v_mtrfday,
                                 i.CLEARCD, i.PRICE * i.QTTY, 0,
                                 i.QTTY, 0, 0, 'N', 'N', 0,
                                 GETDUEDATE(TO_DATE (v_txdate, 'DD/MM/YYYY'),i.clearcd,'000',v_mtrfday)
                                );
                 END IF;


        ELSE  --Lenh ban

        --Tao lich thanh toan chung khoan
         v_strduetype := 'SS';

         IF v_matched > 0
         THEN
            UPDATE stschd
               SET qtty = qtty + i.QTTY,
                   amt = amt + i.PRICE * i.QTTY
             WHERE orgorderid = i.ORDERID AND duetype = v_strduetype;
         ELSE
            INSERT INTO stschd
                        (autoid, orgorderid, codeid,
                         duetype, afacctno, acctno,
                         reforderid, txnum,
                         txdate, clearday,
                         clearcd, amt, aamt,
                         qtty, aqtty, famt, status, deltd, costprice, cleardate
                        )
                 VALUES (seq_stschd.NEXTVAL, i.ORDERID, i.CODEID,
                         v_strduetype, i.AFACCTNO, i.SEACCTNO,
                         i.REFORDERID, v_txnum,
                         TO_DATE (v_txdate, 'DD/MM/YYYY'), 0,
                         i.CLEARCD, i.PRICE * i.QTTY, 0,
                         i.QTTY, 0, 0, 'N', 'N', 0,
                         GETDUEDATE(TO_DATE (v_txdate, 'DD/MM/YYYY'),i.clearcd,'000',i.clearday)
                        );
         END IF;

         --Tao lich thanh toan tien
         v_strduetype := 'RM';

         IF v_matched > 0
         THEN
            UPDATE stschd
               SET qtty = qtty + i.QTTY,
                   amt = amt + i.PRICE * i.QTTY
             WHERE orgorderid = i.ORDERID AND duetype = v_strduetype;
         ELSE
            INSERT INTO stschd
                        (autoid, orgorderid, codeid,
                         duetype, afacctno, acctno,
                         reforderid, txnum,
                         txdate, clearday,
                         clearcd, amt, aamt,
                         qtty, aqtty, famt, status, deltd, costprice, cleardate
                        )
                 VALUES (seq_stschd.NEXTVAL, i.ORDERID, i.CODEID,
                         v_strduetype, i.AFACCTNO, i.AFACCTNO,
                         i.REFORDERID, v_txnum,
                         TO_DATE (v_txdate, 'DD/MM/YYYY'), i.CLEARDAY,
                         i.CLEARCD, i.PRICE * i.QTTY, 0,
                         i.QTTY, 0, 0, 'N', 'N', 0,
                         GETDUEDATE(TO_DATE (v_txdate, 'DD/MM/YYYY'),i.clearcd,'000',i.clearday)
                        );
         END IF;
        END IF;

        --Cap nhat cho GTC
       OPEN C_ODMAST(i.ORDERID);
       FETCH C_ODMAST INTO VC_ODMAST;
        IF C_ODMAST%FOUND THEN
             UPDATE FOMAST SET REMAINQTTY= VC_ODMAST.REMAINQTTY - i.QTTY
                                ,EXECQTTY= VC_ODMAST.EXECQTTY + i.QTTY
                                ,EXECAMT=  VC_ODMAST.EXECAMT + i.PRICE * i.QTTY
                                ,CANCELQTTY=  VC_ODMAST.CANCELQTTY
                                ,AMENDQTTY= VC_ODMAST.ADJUSTQTTY
              WHERE ORGACCTNO= i.ORDERID;
        END IF;
       CLOSE C_ODMAST;

   COMMIT;
   END IF;
End Loop;

   EXCEPTION
       WHEN v_ex  THEN

       ROLLBACK;
       INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, ' MATCHING_ORDER_HA ', v_err
                  );

       COMMIT;
END;


PROCEDURE sp_Full_matching_order (v_offTllogfld varchar2 default 'Y')
IS
   v_tltxcd             VARCHAR2 (30);
   v_txnum              VARCHAR2 (30);
   v_txdate             VARCHAR2 (30);
   v_tlid               VARCHAR2 (30);
   v_brid               VARCHAR2 (30);
   v_ipaddress          VARCHAR2 (30);
   v_wsname             VARCHAR2 (30);
   v_txtime             VARCHAR2 (30);
   v_txdesc             VARCHAR2 (30);
   v_strduetype         VARCHAR (2);
   v_matched            NUMBER (10,2);
   v_ex                 EXCEPTION;
   v_err                VARCHAR2 (100);
   v_temp               NUMBER(10);
   v_mtrfday               NUMBER(10);
   v_refconfirmno       VARCHAR2 (30);
   v_RemainQtty         NUMBER(10);

   mv_dbltrfbuyext      number(20,0);
   mv_dbltrfbuyrate      number(20,4);
   mv_strtrfstatus      VARCHAR2(1);

   Cursor c_SqlMaster Is
        SELECT OD.ORDERID,OD.CODEID,SEC.SYMBOL,OOD.CUSTODYCD,OD.AFACCTNO,OD.SEACCTNO,OD.CIACCTNO,
        (case when od.exectype ='NB' then 'B' else 'S' end) BORS,
        'N' NORP, OD.NORK AORN,
        --B.BSCA BORS,B.NORP,OD.NORK AORN,
        OD.QUOTEPRICE EXPRICE, OD.ORDERQTTY EXQTTY, od.remainqtty QTTY,--round(od.remainqtty/2,-2) QTTY,
        OD.QUOTEPRICE PRICE,'' REFORDERID, '' CONFIRM_NO,
        OD.BRATIO,OD.CLEARDAY,OD.CLEARCD,
        OOD.CUSTODYCD || '.' || (case when od.exectype ='NB' then 'B' else 'S' end) || '.' || SEC.SYMBOL || '.' || od.remainqtty || '.' || OD.QUOTEPRICE  DESCRIPTION,
        af.trfbuyext, af.trfbuyrate
        FROM ODMAST OD,afmast af,SBSECURITIES SEC,OOD--, load_account ld
            WHERE OD.ORDERID=OOD.ORGORDERID --AND OD.AFACCTNO = ld.afacctno
            AND OD.CODEID=SEC.CODEID AND SEC.TRADEPLACE in ('001','002')
            and OD.remainqtty>0 --and OD.execqtty =0 --and round(od.remainqtty/2,-2)>0
            and od.afacctno = af.acctno
            and od.txdate =getcurrdate
            and exectype in ('NB')--in ('NS','NB')
            and od.afacctno ='0101921636';
            --and od.orderid ='8000270312000200';


   Cursor c_Odmast(v_OrgOrderID Varchar2) Is
   SELECT REMAINQTTY,EXECQTTY,EXECAMT,CANCELQTTY,ADJUSTQTTY
   FROM ODMAST WHERE TIMETYPE ='G' AND ORDERID=v_OrgOrderID;
   vc_Odmast c_Odmast%Rowtype;

   Cursor c_Odmast_check(v_OrgOrderID Varchar2) Is
   SELECT REMAINQTTY,EXECQTTY,EXECAMT,CANCELQTTY,ADJUSTQTTY
   FROM ODMAST WHERE ORDERID=v_OrgOrderID;

BEGIN

    -- 1. Set common values

      v_brid := '0000';
      v_tlid := '0000';
      v_ipaddress := 'HOST';
      v_wsname := 'HOST';
      v_tltxcd := '8804';
   mv_dbltrfbuyext:=0;
   mv_dbltrfbuyrate:=0;
   mv_strtrfstatus:='Y';

      For i in c_SqlMaster
      Loop

   mv_dbltrfbuyext:=i.trfbuyext;
   mv_dbltrfbuyrate:=i.trfbuyrate;

   IF mv_dbltrfbuyext > 0 THEN
        mv_strtrfstatus:='N';
   END IF;

       OPEN c_Odmast_check(i.ORDERID);
       FETCH c_Odmast_check INTO VC_ODMAST;

       IF c_Odmast_check%FOUND THEN
            v_RemainQtty:=VC_ODMAST.REMAINQTTY;
       END IF;
       CLOSE c_Odmast_check;

       If v_RemainQtty >= i.QTTY THEN

             SELECT    '8080'
                  || SUBSTR ('000000' || seq_batchtxnum.NEXTVAL,
                             LENGTH ('000000' || seq_batchtxnum.NEXTVAL) - 5,
                             6
                            )
             INTO v_txnum
             FROM DUAL;

             SELECT TO_CHAR (SYSDATE, 'HH24:MI:SS')
              INTO v_txtime
              FROM DUAL;


              SELECT varvalue
                INTO v_txdate
                FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';


            v_txdesc := i.CUSTODYCD||'.'||i.BORS||'.'||i.SYMBOL||'.'||i.QTTY||'.'||i.PRICE;
  --1.TLLOG
            INSERT INTO tllog
                    (autoid, txnum,
                     txdate, txtime, brid,
                     tlid, offid, ovrrqs, chid, chkid, tltxcd, ibt, brid2, tlid2,
                     ccyusage, txstatus, msgacct, msgamt, chktime, offtime, off_line,
                     deltd, brdate,
                     busdate, msgsts, ovrsts, ipaddress, wsname,
                     batchname, carebygrp, txdesc
                    )
             VALUES (seq_tllog.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), v_txtime, v_brid,
                     v_tlid, '', '', '', '', '8814', '', '', '',
                     '00', '1', i.ORDERID, i.PRICE, '', '', 'N',
                     'N', TO_DATE (v_txdate, 'dd/MM/yyyy'),
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '0', '0', v_ipaddress, v_wsname,
                     'DAY', '', v_txdesc
                    );


  --2.TLLOGFLD
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '03', i.ORDERID, 0
                    );
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '04', i.AFACCTNO, 0
                    );
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '05', i.AFACCTNO, 0
                    );
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '06', i.SEACCTNO, 0
                    );
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '07', i.REFORDERID, 0
                    );
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '08', '', 0
                    );
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '09', i.CLEARCD, 0
                    );

            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '10', '', i.PRICE
                    );
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '11', '', i.QTTY
                    );

            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '12', '', i.EXPRICE
                    );
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '13', '', i.EXQTTY
                    );
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '14', '', i.CLEARDAY
                    );
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '15', '', i.BRATIO
                    );
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '16', i.CONFIRM_NO, 0
                    );
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '17', '', 0
                    );

            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd,
                     cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '30',
                     v_txdesc, 0
                    );

            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '80', i.CODEID, 0
                    );
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '81', i.SYMBOL, 0
                    );
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '82', i.CUSTODYCD, 0
                    );
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '83', i.BORS, 0
                    );
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '84', i.NORP, 0
                    );
            INSERT INTO tllogfld
                    (autoid, txnum,
                     txdate, fldcd, cvalue, nvalue
                    )
             VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '85', i.AORN, 0
                    );

  --3.AFTRAN
            --Thuc hien tran
            INSERT INTO aftran
                    (acctno, txnum,
                     txdate, txcd, namt, camt, REF,
                     deltd, autoid
                    )
             VALUES (i.AFACCTNO, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '0088', i.PRICE * i.QTTY, '', '',
                     'N', seq_aftran.NEXTVAL
                    );

  --4.ODTRAN
            INSERT INTO odtran
                    (acctno, txnum,
                     txdate, txcd, namt, camt, REF,
                     deltd, autoid
                    )
             VALUES (i.ORDERID, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '0028', i.PRICE * i.QTTY, '', '',
                     'N', seq_odtran.NEXTVAL
                    );
            INSERT INTO odtran
                    (acctno, txnum,
                     txdate, txcd, namt, camt,
                     REF, deltd, autoid
                    )
             VALUES (i.ORDERID, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '0013', i.QTTY, '',
                     i.CIACCTNO, 'N', seq_odtran.NEXTVAL
                    );
            INSERT INTO odtran
                    (acctno, txnum,
                     txdate, txcd, namt, camt, REF,
                     deltd, autoid
                    )
             VALUES (i.ORDERID, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '0034', i.PRICE * i.QTTY, '', '',
                     'N', seq_odtran.NEXTVAL
                    );
            INSERT INTO odtran
                    (acctno, txnum,
                     txdate, txcd, namt, camt, REF, deltd,
                     autoid
                    )
             VALUES (i.ORDERID, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '0001', 0, '4', '', 'N',
                     seq_odtran.NEXTVAL
                    );
            INSERT INTO odtran
                    (acctno, txnum,
                     txdate, txcd, namt, camt,
                     REF, deltd, autoid
                    )
             VALUES (i.ORDERID, v_txnum,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), '0011', i.QTTY, '',
                     i.CIACCTNO, 'N', seq_odtran.NEXTVAL
                    );

  --5.AFMAST


            UPDATE afmast
             SET dmatchamt = NVL(dmatchamt,0) + i.PRICE * i.QTTY
             WHERE acctno = i.AFACCTNO;


  --6.IOD
            INSERT INTO iod
                    (orgorderid, codeid, symbol, custodycd, bors, norp,
                     txdate, txnum, aorn, price,
                     qtty, exorderid, refcustcd, matchprice, matchqtty, confirm_no,
                     txtime
                    )
             VALUES (i.ORDERID, i.CODEID, i.SYMBOL, i.CUSTODYCD, i.BORS, i.NORP,
                     TO_DATE (v_txdate, 'dd/MM/yyyy'), v_txnum , i.AORN, i.EXPRICE,
                     i.EXQTTY, i.REFORDERID, '', i.PRICE, i.QTTY, i.CONFIRM_NO,
                     v_txtime
                    );
  --7.ODMAST
           --Cap nhat Odmast
           UPDATE odmast
           SET execamt = NVL(execamt,0) + i.PRICE * i.QTTY,
               execqtty = NVL(execqtty,0) + i.QTTY,
               matchamt = NVL(matchamt,0) + i.PRICE * i.QTTY,
               porstatus = porstatus || '4',
               orstatus = '4',
               remainqtty = remainqtty - i.QTTY
           WHERE orderid = i.orderid;



           INSERT INTO stctradeallocation
                        (txdate, txnum,
                         refconfirmnumber, orderid, bors, volume, price, deltd
                        )
                 VALUES (TO_DATE (v_txdate, 'dd/MM/yyyy'), v_txnum ,
                         i.CONFIRM_NO, i.ORDERID, i.BORS, i.QTTY, i.PRICE, 'N'
                        );
   --8.Tao lich thanh toan
        SELECT COUNT (*)
        INTO v_matched
        FROM stschd
        WHERE orgorderid = i.ORDERID AND deltd <> 'Y';

        IF i.BORS = 'B' THEN  --Lenh mua
                select typ.mtrfday into v_mtrfday
                from odmast od, odtype typ
                where od.actype=typ.actype and od.orderid=i.ORDERID;
                --Tao lich thanh toan chung khoan
                 v_strduetype := 'RS';

                 IF v_matched > 0
                 THEN
                    UPDATE stschd
                       SET qtty = qtty + i.QTTY,
                           amt = amt + i.PRICE * i.QTTY
                     WHERE orgorderid = i.ORDERID AND duetype = v_strduetype;
                 ELSE
                    INSERT INTO stschd
                                (autoid, orgorderid, codeid,
                                 duetype, afacctno, acctno,
                                 reforderid, txnum,
                                 txdate, clearday,
                                 clearcd, amt, aamt,
                                 qtty, aqtty, famt, status, deltd, costprice, cleardate
                                )
                         VALUES (seq_stschd.NEXTVAL, i.ORDERID, i.CODEID,
                                 v_strduetype, i.AFACCTNO, i.SEACCTNO,
                                 i.REFORDERID, v_txnum,
                                 TO_DATE (v_txdate, 'DD/MM/YYYY'), i.CLEARDAY,
                                 i.CLEARCD, i.PRICE * i.QTTY, 0,
                                 i.QTTY, 0, 0, 'N', 'N', 0, getduedate(TO_DATE (v_txdate, 'DD/MM/YYYY'),i.CLEARCD,'000',i.CLEARDAY)
                                );
                 END IF;

                 --Tao lich thanh toan tien
                 v_strduetype := 'SM';

                 IF v_matched > 0
                 THEN
                    UPDATE stschd
                       SET qtty = qtty + i.QTTY,
                           amt = amt + i.PRICE * i.QTTY
                     WHERE orgorderid = i.ORDERID AND duetype = v_strduetype;
                 ELSE
                    INSERT INTO stschd
                                (autoid, orgorderid, codeid,
                                 duetype, afacctno, acctno,
                                 reforderid, txnum,
                                 txdate, clearday,
                                 clearcd, amt, aamt,
                                 qtty, aqtty, famt, status, deltd, costprice, cleardate,trfbuydt,trfbuysts, trfbuyrate, trfbuyext
                                )
                         VALUES (seq_stschd.NEXTVAL, i.ORDERID, i.CODEID,
                                 v_strduetype, i.AFACCTNO, i.AFACCTNO,
                                 i.REFORDERID, v_txnum,
                                 TO_DATE (v_txdate, 'DD/MM/YYYY'), v_mtrfday,
                                 i.CLEARCD, i.PRICE * i.QTTY, 0,
                                 i.QTTY, 0, 0, 'N', 'N', 0, getduedate(TO_DATE (v_txdate, 'DD/MM/YYYY'),i.clearcd,'000',greatest(v_mtrfday,mv_dbltrfbuyext)),
                                least(getduedate(TO_DATE (v_txdate, 'DD/MM/YYYY'),i.clearcd,'000',mv_dbltrfbuyext),getduedate(TO_DATE (v_txdate, 'DD/MM/YYYY'),i.clearcd,'000',i.clearday)),mv_strtrfstatus, mv_dbltrfbuyrate, mv_dbltrfbuyext
                                );
                 END IF;


        ELSE  --Lenh ban

        --Tao lich thanh toan chung khoan
         v_strduetype := 'SS';

         IF v_matched > 0
         THEN
            UPDATE stschd
               SET qtty = qtty + i.QTTY,
                   amt = amt + i.PRICE * i.QTTY
             WHERE orgorderid = i.ORDERID AND duetype = v_strduetype;
         ELSE
            INSERT INTO stschd
                        (autoid, orgorderid, codeid,
                         duetype, afacctno, acctno,
                         reforderid, txnum,
                         txdate, clearday,
                         clearcd, amt, aamt,
                         qtty, aqtty, famt, status, deltd, costprice,cleardate
                        )
                 VALUES (seq_stschd.NEXTVAL, i.ORDERID, i.CODEID,
                         v_strduetype, i.AFACCTNO, i.SEACCTNO,
                         i.REFORDERID, v_txnum,
                         TO_DATE (v_txdate, 'DD/MM/YYYY'), 0,
                         i.CLEARCD, i.PRICE * i.QTTY, 0,
                         i.QTTY, 0, 0, 'N', 'N', 0,getduedate(TO_DATE (v_txdate, 'DD/MM/YYYY'),i.CLEARCD,'000',0)
                        );
         END IF;

         --Tao lich thanh toan tien
         v_strduetype := 'RM';

         IF v_matched > 0
         THEN
            UPDATE stschd
               SET qtty = qtty + i.QTTY,
                   amt = amt + i.PRICE * i.QTTY
             WHERE orgorderid = i.ORDERID AND duetype = v_strduetype;
         ELSE
            INSERT INTO stschd
                        (autoid, orgorderid, codeid,
                         duetype, afacctno, acctno,
                         reforderid, txnum,
                         txdate, clearday,
                         clearcd, amt, aamt,
                         qtty, aqtty, famt, status, deltd, costprice,cleardate
                        )
                 VALUES (seq_stschd.NEXTVAL, i.ORDERID, i.CODEID,
                         v_strduetype, i.AFACCTNO, i.AFACCTNO,
                         i.REFORDERID, v_txnum,
                         TO_DATE (v_txdate, 'DD/MM/YYYY'), i.CLEARDAY,
                         i.CLEARCD, i.PRICE * i.QTTY, 0,
                         i.QTTY, 0, 0, 'N', 'N', 0,getduedate(TO_DATE (v_txdate, 'DD/MM/YYYY'),i.CLEARCD,'000', i.CLEARDAY)
                        );
         END IF;
        END IF;

/*        --Cap nhat cho GTC
       OPEN C_ODMAST(i.ORDERID);
       FETCH C_ODMAST INTO VC_ODMAST;
       IF C_ODMAST%FOUND THEN
             UPDATE FOMAST SET REMAINQTTY= REMAINQTTY - i.QTTY
                                ,EXECQTTY= EXECQTTY + i.QTTY
                                ,EXECAMT=  EXECAMT + i.PRICE * i.QTTY
              --WHERE ORGACCTNO= i.ORDERID;
             WHERE ACCTNO= VC_ODMAST.FOACCTNO;
        END IF;
       CLOSE C_ODMAST;

*/       COMMIT;
       END IF;
   End Loop;

  -- CLOSE c_SqlMaster;

   COMMIT;                                -- Commit the last trunk (if any)

   EXCEPTION
       WHEN v_ex  THEN

       ROLLBACK;
       INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, ' MATCHING_ORDER_HA ', v_err
                  );

       COMMIT;
END;

BEGIN
   SELECT *
   INTO logrow
   FROM tlogdebug
   WHERE ROWNUM <= 1;

   pkgctx    :=
      plog.init ('cspks_loadtest',
                 plevel => logrow.loglevel,
                 plogtable => (logrow.log4table = 'Y'),
                 palert => (logrow.log4alert = 'Y'),
                 ptrace => (logrow.log4trace = 'Y')
      );
END;
/

