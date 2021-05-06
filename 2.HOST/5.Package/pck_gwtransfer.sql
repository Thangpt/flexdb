CREATE OR REPLACE PACKAGE pck_gwtransfer
  IS
--
-- To modify this template, edit file PKGSPEC.TXT in TEMPLATE
-- directory of SQL Navigator
--
-- Purpose: Briefly explain the functionality of the package
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- ---------   ------  ------------------------------------------
   -- Enter package declarations as shown below


     PROCEDURE pr_PutbatchProcessB2C;
     FUNCTION Correct_ReMark(v_Remark IN nvarchar2,v_leng in NUMERIC) RETURN nvarchar2;
     PROCEDURE pr_PutbatchProcessC2B;
     PROCEDURE pr_PutbatchProcessC2B_BIDV;
     PROCEDURE pr_Complete_PutbatchC2B;
     PROCEDURE pr_CreateFileCheck(F_DATE IN  VARCHAR2,T_DATE IN  VARCHAR2 );
     PROCEDURE pr_TCDTBANKREQUEST1104(p_refcode IN varchar,p_err_code  OUT varchar2);
     PROCEDURE PR_TCDTBANKREQUEST1204(P_REFCODE  IN VARCHAR,P_ERR_CODE OUT VARCHAR2); --1.8.2.1:Chỉnh sửa thu chi điện tử với BIDV
     PROCEDURE pr_TCDTRECEIVEREQUEST1141(p_AUTOID IN varchar,p_err_code  OUT varchar2);
     PROCEDURE pr_C2BRETURNMONEY;
     PROCEDURE pr_genbankrequest(pv_err_code in out varchar2, pv_autoid in varchar2 );
     PROCEDURE PR_DELETEBANKREQUEST(pv_err_code in out varchar2, pv_autoid in varchar2 );
     PROCEDURE PR_MSBUPDATESTATUS(pv_err_code in  varchar2, pv_batchid in varchar2 );
END; -- Package spec
/
CREATE OR REPLACE PACKAGE BODY pck_gwtransfer
IS
  pkgctx   plog.log_ctx:= plog.init ('txpks_txpks_auto',
                 plevel => 30,
                 plogtable => true,
                 palert => false,
                 ptrace => false);

--
-- To modify this template, edit file PKGBODY.TXT in TEMPLATE
-- directory of SQL Navigator
--
-- Purpose: Briefly explain the functionality of the package body
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- ---------   ------  ------------------------------------------
   -- Enter procedure, function bodies as shown below

  FUNCTION Correct_ReMark(v_Remark IN nvarchar2,v_leng in NUMERIC)
   RETURN  nvarchar2 IS
    v_Result nvarchar2(500);
    v_strIN nvarchar2(500);
    BEGIN
    v_strIN:=SUbstr(translate(v_Remark , ' ~ ` - # ^ * _ < > ;  { } [ ] |\',' '),0,v_leng) ;
    v_Result := fn_banhgw_convert_to_vn(v_strIN);
    RETURN v_Result;
    END;



   PROCEDURE pr_PutbatchProcessB2C
    IS
      -- Enter the procedure variables here. As shown below
      v_errcode NUMBER;
      V_COUNT number;
     ---------------
      v_rqsautoid varchar2(30);
      v_txnum varchar(10);
      v_txdate varchar(20);
      v_status varchar(3);
      v_errmsg varchar(250);
      v_custodycd varchar(20);
      v_afacctno varchar(20);
      l_bankacctno  varchar(50);
      l_glmast varchar(50);
      l_bankid varchar(20);
      v_REFID varchar(23);
      v_rqssrc varchar(23);
      v_rqstyp  varchar(23);
      v_strBANKID varchar(100);
      v_strHOSTSTATUS varchar(100);
      ---------------------
      v_strAfStatus char(1);
      l_count number;
---

Cursor C_AFACCTNO_MS(v_Custodycd Varchar2) IS
SELECT nvl(Min(AF.ACCTNO),'NULL') ACCTNO
FROM AFMAST AF, CFMAST CF , aftype aft , mrtype mrt
WHERE CF.CUSTID=AF.CUSTID AND AF.STATUS in ('A')
and AF.actype = aft.actype
and aft.mrtype =mrt.actype
and mrt.mrtype ='T'
AND CF.CUSTODYCD=v_Custodycd;


Cursor C_AFACCTNO_UT(v_Custodycd Varchar2) IS
SELECT nvl(Min(AF.ACCTNO),'NULL') ACCTNO FROM AFMAST AF, CFMAST CF WHERE CF.CUSTID=AF.CUSTID AND AF.STATUS in ('A') AND  defbankrece='Y' AND CF.CUSTODYCD=v_Custodycd;

Cursor C_AFACCTNO_NM(v_Custodycd Varchar2) IS
SELECT nvl(Min(AF.ACCTNO),'NULL') ACCTNO FROM AFMAST AF, CFMAST CF WHERE CF.CUSTID=AF.CUSTID AND AF.STATUS in ('A') AND CF.CUSTODYCD=v_Custodycd;

Cursor C_CHECK_AFACCTNO(v_Custodycd Varchar2) IS
SELECT nvl(Min(AF.ACCTNO),'NULL') ACCTNO FROM AFMAST AF where  AF.STATUS in ('A') AND af.ACCTNO =v_Custodycd;


Cursor C_BANKINFO(v_BankID Varchar2) IS
SELECT nvl(Min(BANKACCTNO),'NULL')BANKACCTNO, nvl(Min(GLACCOUNT),'NULL') GLACCOUNT FROM BANKNOSTRO WHERE shortname=v_BankID;



   BEGIN

   /*Select varvalue into v_strBANKID from sysvar where GRNAME='BANKGW' and VARNAME ='DEFAULTBANKID' ;*/ --Comment by ManhTV
   Select varvalue into v_strHOSTSTATUS from sysvar where varname ='HOSTATUS';
   if v_strHOSTSTATUS ='0' then
                return ;
                end if ;
       FOR rec IN
       (   SELECT mst.autoid,rqssrc,rqstyp,txdate,
                  rqs_REFID.cvalue REFID, UPPER(rqs_ACCTNO.cvalue) custodycd, rqs_AMOUNT.nvalue AMOUNT,rqs_DESCRIPTION.cvalue DESCRIPTION,
                  nvl(rqs_SACCTNO.cvalue, 'NULL') SACCOUNT
            FROM borqslog mst, borqslogdtl  rqs_REFID, borqslogdtl  rqs_ACCTNO,
                 borqslogdtl  rqs_AMOUNT, borqslogdtl rqs_DESCRIPTION,borqslogdtl  rqs_SACCTNO
            WHERE rqstyp in('CRA','CRI') AND status = 'P' AND rqssrc = 'MSB'
            AND rqs_REFID.autoid = mst.autoid AND rqs_REFID.varname = 'REFID'
            AND rqs_ACCTNO.autoid = mst.autoid AND rqs_ACCTNO.varname = 'ACCTNO'
            AND rqs_AMOUNT.autoid = mst.autoid AND rqs_AMOUNT.varname = 'AMOUNT'
            AND rqs_DESCRIPTION.autoid = mst.autoid AND rqs_DESCRIPTION.varname = 'DESCRIPTION'
            AND rqs_SACCTNO.autoid = mst.autoid AND rqs_SACCTNO.varname = 'SACCOUNT'
            AND ROWNUM <= 10
            ORDER BY mst.autoid
       )
       LOOP
                v_custodycd:=rec.custodycd;
                v_rqsautoid:= rec.AUTOID;
                v_REFID :=rec.REFID;
                v_rqssrc :=rec.rqssrc;
                v_rqstyp:=rec.rqstyp;
                l_bankacctno :=rec.saccount;

                if v_strHOSTSTATUS ='0' then
                return ;
                end if ;

                 --1. Check thong tin REFID
                If LENGTH(rec.REFID) <> 23 or SUBSTR(rec.REFID,0,2) <>'BO' then
                 v_errcode:=-660050;
                 v_errmsg:='INVALID REFID FORMAT!';
                 end if;

                 --2. Check so tien phai lon hon khong
                 if to_number(rec.AMOUNT) <0 then
                 v_errcode:=-660053;  --khong thay afacctno
                 v_errmsg:='Amount less than 0!';
                 end if;

                 Select count(*) into V_COUNT from borqslog where requestid=rec.REFID;
                 IF V_COUNT > 1 THEN
                        v_errcode:=-660051;
                        v_errmsg:='DOUBLE REFID!';
                        RAISE errnums.E_BIZ_RULE_INVALID;
                 END IF;



                --3. Lay so tieu khoan nhan tien
                     -- quyet.kieu CHECK Xem ben BANK day sang du lieu gi l?USTODYCD hay l?FACCTNO
                     -- neu l?USTODYCD thi thu tu uu tien nhan tien se la
                     -- 1. MS
                     -- 2. TK dang ky nhan tien
                     -- 3. ngau nhien
                     -- Neu la tieu khoan thi cap nhat vao tieu khoan dich danh luon
                IF substr(v_custodycd,0,3) ='091' THEN
                   l_count := 0;
                   -- begin ver: 1.5.0.2 | iss: 1752
                   BEGIN
                      SELECT count(AF.ACCTNO) INTO l_count
                      FROM AFMAST AF, CFMAST CF , aftype aft , mrtype mrt
                      WHERE CF.CUSTID=AF.CUSTID
                        AND AF.actype = aft.actype
                        AND aft.mrtype = mrt.actype
                        AND mrt.mrtype = 'T'
                        AND CF.CUSTODYCD = v_custodycd
                        AND AF.STATUS = 'A';

                        IF l_count >= 1 THEN
                            SELECT min(AF.ACCTNO) INTO v_afacctno
                              FROM AFMAST AF, CFMAST CF , aftype aft , mrtype mrt
                              WHERE CF.CUSTID=AF.CUSTID
                                AND AF.actype = aft.actype
                                AND aft.mrtype = mrt.actype
                                AND mrt.mrtype = 'T'
                                AND CF.CUSTODYCD = v_custodycd
                                AND AF.STATUS = 'A';
                        ELSE
                            l_count := 0;
                        END IF;
                   EXCEPTION WHEN OTHERS THEN
                      l_count := 0;
                   END;

                   IF l_count = 0 THEN -- Neu khong co tai khoan MS thi moi chuyen sang luat uu tien voi tk thuong
                         --2 Neu khong co MS thi lay tieu khoan UT
                      OPEN C_AFACCTNO_UT(v_custodycd);
                         FETCH C_AFACCTNO_UT INTO v_afacctno;
                      CLOSE C_AFACCTNO_UT;

                      IF v_afacctno='NULL' THEN
                         --3. Neu kho thay UT
                         OPEN C_AFACCTNO_NM(v_custodycd);
                         FETCH C_AFACCTNO_NM INTO v_afacctno;
                         CLOSE C_AFACCTNO_NM;

                         IF v_afacctno='NULL' THEN
                            v_errcode:=-660052;  --khong thay afacctno
                            v_errmsg:='Cannot found afacctno!';
                            RAISE errnums.E_BIZ_RULE_INVALID;
                         END IF;
                      END IF;
                   END IF;
                      --Add by ManhTV
                      --Lay ra ds cac tieu khoan MS, uu tien nop tien vao tk MS truoc:


                      --BEGIN
                      --   FOR I IN (SELECT AF.ACCTNO, AF.STATUS FROM AFMAST AF, CFMAST CF , aftype aft , mrtype mrt
                      --                 WHERE CF.CUSTID=AF.CUSTID
                      --                      AND AF.actype = aft.actype
                      --                      AND aft.mrtype =mrt.actype
                      --                      AND mrt.mrtype ='T'
                      --                      AND CF.CUSTODYCD=v_Custodycd
                      --                 ORDER BY AF.ACCTNO)
                      --   LOOP
                      --      l_count := l_count + 1;
                      --      plog.debug(pkgctx,'l_count := ' || l_count ||', afacctno := '|| i.acctno || ', status := '|| i.status);
                      --      IF i.status = 'A' THEN-->neu gap tieu khoan MS trang thai Active thi thoat khoi vong lap.
                      --         v_afacctno := i.acctno;
                      --         EXIT;
                      --      ELSE --Truong hop co tieu khoan MS nhung trang thai khac Active.
                      --         v_afacctno := 'NULL';
                      --      END IF;
                      --   END LOOP;
                      --EXCEPTION WHEN OTHERS THEN
                      --    v_errcode:=-660052;  --khong thay afacctno
                      --    v_errmsg:='Cannot found afacctno!';
                      --    RAISE errnums.E_BIZ_RULE_INVALID;
                      --END;
                      --End Add.

                      --1. Lay tieu khoan MS
                      /*OPEN C_AFACCTNO_MS(v_custodycd); --Comment by ManhTV
                      FETCH C_AFACCTNO_MS INTO v_afacctno;*/

                      /*Truong hop co tai khoan MS nhung deu o trang thai khac Active thi bao loi cho khach hang, ko xu dung luat uu tien nua*/
                      --IF l_count > 0 AND v_afacctno ='NULL' THEN
                      --   v_errcode:=-660054;  --Trang thai tieu khoan MS khong hop le
                      --   v_errmsg:='MS afaccount not active';
                      --   RAISE errnums.E_BIZ_RULE_INVALID;
                      --END IF;

                      --IF l_count = 0 THEN -- Neu khong co tai khoan MS thi moi chuyen sang luat uu tien voi tk thuong
                         --2 Neu khong co MS thi lay tieu khoan UT
                      --   OPEN C_AFACCTNO_UT(v_custodycd);
                      --   FETCH C_AFACCTNO_UT INTO v_afacctno;
                      --   Close C_AFACCTNO_UT;
                      --         IF v_afacctno='NULL' THEN
                      --            --3. Neu kho thay UT
                      --            OPEN C_AFACCTNO_NM(v_custodycd);
                      --            FETCH C_AFACCTNO_NM INTO v_afacctno;
                      --            Close C_AFACCTNO_NM;
                      --                  IF v_afacctno='NULL' THEN
                      --                     v_errcode:=-660052;  --khong thay afacctno
                      --                     v_errmsg:='Cannot found afacctno!';
                      --                     RAISE errnums.E_BIZ_RULE_INVALID;
                      --                  END IF;
                      --         END IF;
                      --END IF;
                      --Comment by ManhTV.
                          /*IF v_afacctno='NULL' THEN
                                --2 Neu khong co MS thi lay tieu khoan UT
                                OPEN C_AFACCTNO_UT(v_custodycd);
                                FETCH C_AFACCTNO_UT INTO v_afacctno;
                                    IF v_afacctno='NULL' THEN
                                         --3. Neu kho thay UT
                                         OPEN C_AFACCTNO_NM(v_custodycd);
                                         FETCH C_AFACCTNO_NM INTO v_afacctno;
                                             IF v_afacctno='NULL' THEN
                                                  v_errcode:=-660052;  --khong thay afacctno
                                                  v_errmsg:='Cannot found afacctno!';
                                                  RAISE errnums.E_BIZ_RULE_INVALID;
                                             END IF;
                                    END IF;
                          END IF;*/
                -- end ver: 1.5.0.2 | iss: 1752
                ELSE
                 -- Chac chan la tieu khoan roi, chi can check xem Tieu khoan co OK ko
                     OPEN C_CHECK_AFACCTNO(v_custodycd);
                     FETCH C_CHECK_AFACCTNO INTO v_afacctno;
                     Close C_CHECK_AFACCTNO;
                        IF v_afacctno='NULL' THEN
                         v_errcode:=-660052;  --khong thay afacctno
                         v_errmsg:='Cannot found afacctno!';
                         RAISE errnums.E_BIZ_RULE_INVALID;
                         END IF;
                 END IF;

                 --4. Lay thong tin ngan hang
                 /*Add by ManhTV*/
                 l_bankid := 'NULL';
                 l_glmast := 'NULL';
                 BEGIN
                    SELECT b.shortname, b.glaccount INTO l_bankid, l_glmast FROM banknostro b where b.bankacctno = l_bankacctno and rownum = 1;
                 EXCEPTION WHEN OTHERS THEN
                    v_errcode:=-660059;  --Khong tim thay thong tin Banks trong he thong
                    v_errmsg:='Cannot found BANKINFO!';
                    RAISE errnums.E_BIZ_RULE_INVALID;
                 END;
                 IF l_bankid ='NULL' THEN
                    v_errcode:=-660059;  --Khong tim thay thong tin Banks trong he thong
                    v_errmsg:='Cannot found BANKINFO!';
                    RAISE errnums.E_BIZ_RULE_INVALID;
                 END IF;
                 v_strBANKID := l_bankid;
                 /*End add*/


                 /*OPEN C_BANKINFO(v_strBANKID);
                    FETCH  C_BANKINFO INTO l_bankacctno,l_glmast;
                    IF l_bankacctno='NULL' THEN
                     v_errcode:=-660059;  --Khong tim thay thong tin Banks trong he thong
                     v_errmsg:='Cannot found BANKINFO!';
                     RAISE errnums.E_BIZ_RULE_INVALID;
                    END IF;*/ --Comment by ManhTV

                 plog.debug(pkgctx, 'AFACCTNO := '|| v_afacctno);
                 --5. Gen giao dich nhan chuyen khoan 1141
                 txpks_auto.pr_ReceiveTransfer(v_afacctno ,v_strBANKID ,l_bankacctno,l_glmast ,rec.refid ,rec.AMOUNT ,rec.DESCRIPTION ,v_errcode  ,v_txdate  ,v_txnum );
                --6. XU LY LOI
                IF v_errcode=0 THEN
                    v_status:='C';
                ELSE
                    BEGIN
                        SELECT ERRDESC INTO v_errmsg FROM DEFERROR WHERE ERRNUM=v_errcode;
                    EXCEPTION
                    WHEN OTHERS THEN
                        v_errcode:= -99999;
                        v_errmsg:='UNDEFINED ERROR!';
                    END;
                    v_status:='E';
                END IF;
                --7. Cap nhat da xu ly
                UPDATE BORQSLOG
                SET ERRNUM = v_errcode, ERRMSG = v_errmsg, STATUS = v_status, TXDATE= v_txdate, TXNUM=v_txnum
                WHERE autoid = v_rqsautoid;
                --8. Cap nhat vao bang de chuyen qua ngan hang
                INSERT INTO GW_UPDATETRANS (AUTOID,RQSSRC,RQSTYP,FUNCTIONNAME,DIRECTION,REFID,STATUS,ERRNUM,PROCESS)
                VALUES(seq_GWUPDATETRAN.nextval ,rec.RQSSRC,rec.RQSTYP,'UPDATETRANSACTIONSTATUS','C2B',REC.REFID,v_status,v_errcode,'N');
                COMMIT;

       END LOOP;


   EXCEPTION
      WHEN errnums.E_BIZ_RULE_INVALID THEN
          UPDATE BORQSLOG SET ERRNUM = v_errcode, ERRMSG = v_errmsg, STATUS = 'E'
          WHERE autoid = v_rqsautoid;
       --9. Cap nhat vao bang de chuyen qua ngan hang
           INSERT INTO GW_UPDATETRANS (AUTOID,RQSSRC,RQSTYP,FUNCTIONNAME,DIRECTION,REFID,STATUS,ERRNUM,PROCESS)
           VALUES(seq_GWUPDATETRAN.nextval ,v_RQSSRC,v_RQSTYP,'UPDATETRANSACTIONSTATUS','C2B',v_REFID,'E',v_errcode,'N');
      WHEN OTHERS THEN
        v_errmsg:= SQLERRM;
        UPDATE BORQSLOG SET ERRNUM = '-1', ERRMSG = 'Error in process: ' || v_errmsg, STATUS = 'E'
        WHERE autoid = v_rqsautoid;

   END;


      PROCEDURE pr_PutbatchProcessC2B
    IS
      v_errcode NUMBER;
      v_status varchar(3);
      v_errmsg varchar(250);
      v_strbatchid  varchar(23);
      v_strTRANSACTIONID  varchar(23);
      V_COUNT number;
      v_strRemark VARCHAR2(500);
      v_strHOSTSTATUS varchar(23);
      v_strBENEFCUSTNAME  VARCHAR2(100);
      v_amttcdtmax number;
      v_banklist   varchar2(100);
      v_vpbamt     number;

   BEGIN

   v_banklist := '';
   for rec in
     (select * from bankgw_auth_info where bankmode = '1')
   loop
     v_banklist := v_banklist||'|'||rec.bank_no;
   end loop;
   v_banklist := v_banklist||'|';

   V_COUNT:=0;
   Select varvalue into v_amttcdtmax from sysvar where varname ='TCDTLIMIT';
   Select varvalue into v_vpbamt from sysvar where varname ='VPBANKLIMIT';
   Select 'BI' || to_char(sysdate,'yyyyMMddhhMMssSSS') into v_strbatchid from dual;
   Select varvalue into v_strHOSTSTATUS from sysvar where varname ='HOSTATUS';
   if v_strHOSTSTATUS ='0' then
                return ;
         end if ;

   FOR rec IN
       (
            select * from (
            Select (Case when ( SUBSTR(a.bankid,0,INSTRC(a.bankid,'.') -1)='302' ) OR a.bankid ='302' then 1 else 2 end) TYPE ,
            a.ACCTNO ,a.BENEFCUSTNAME, replace(replace( benefacct,' ',''),'.','') ACCOUNT,AMT AMOUNT,nvl(SUBSTR(a.bankid,0,INSTRC(a.bankid,'.')-1),a.bankid) BANKCODE,
            SUBSTR(a.bankid,INSTRC(a.bankid,'.')+1,LENGTH(a.bankid) -INSTRC(a.bankid,'.')) BANKBRANCHCODE , --benefbank BANKNAME ,
            Correct_ReMark(A.Citybank,100) BANKNAME,
            --SUBSTR(b.txdesc ,INSTRC(b.txdesc,'/')+1,LENGTH(b.txdesc)-INSTRC(b.txdesc,'/'))  REMARK,
            SUBSTR(b.txdesc,1,200) REMARK,
            a.TXNUM,a.TXDATE , c.bankacctno acctnosum  from CIREMITTANCE a , Tllog b , banknostro c
            WHERE rmstatus='P' and a.deltd ='N'
            AND (a.txnum = b.txnum and a.txdate = b.txdate)
            AND LENGTH(a.bankid) > 0
            and
            ( instr(v_banklist||'|202',substr(a.bankid,1,3))= 0 and EXISTS(select varvalue from sysvar where grname='SYSTEM' AND VARNAME='TCDTBIDV' and varvalue='1')
             or
             (instr(nvl(v_banklist,' '),substr(a.bankid,1,3)) = 0 and EXISTS(select varvalue from sysvar where grname='SYSTEM' AND VARNAME='TCDTBIDV' and varvalue='0'))
            )
            and c.branchid = '0001' --decode(substr(a.ACCTNO,1,4),'0002','0001',substr(a.ACCTNO,1,4))
            and c.glaccount in ('MSBDD','MSBHCM')
            and b.txstatus=1
            and nvl(b.txdesc, ' ') not like 'QSDCN%' --chaunh: khong lay gd quet so du cuoi ngay
            and (a.txnum || a.txdate) not in ( Select (b.txnum || b.txdate)from gw_putbatchtrans b )
            --and (SUBSTR(a.bankid,0,INSTRC(a.bankid,'.') -1)='302' OR a.bankid ='302' ) -- hotfix chuyen tien
            and length(a.bankid)>1 AND replace(replace( benefacct,' ',''),'.','') NOT IN (SELECT bankacc FROM cfotheraccblacklist)
            --AND ROWNUM <= 10
            AND (substr(a.bankid,1,3) = '302'
            OR EXISTS (SELECT * FROM TCDTCASHLIMIT WHERE BANK_NAME = 'MSB' AND A.AMT >=CASH_FROM AND A.AMT <= CASH_TO))
            --chaunh: lay tai khoan tong phan quet so du cuoi ngay
            union all
            Select (Case when ( SUBSTR(a.bankid,0,INSTRC(a.bankid,'.') -1)='302' ) OR a.bankid ='302' then 1 else 2 end) TYPE ,
            a.ACCTNO ,a.BENEFCUSTNAME, replace(replace( benefacct,' ',''),'.','') ACCOUNT,AMT AMOUNT,nvl(SUBSTR(a.bankid,0,INSTRC(a.bankid,'.')-1),a.bankid) BANKCODE,
            SUBSTR(a.bankid,INSTRC(a.bankid,'.')+1,LENGTH(a.bankid) -INSTRC(a.bankid,'.')) BANKBRANCHCODE , --benefbank BANKNAME ,
            Correct_ReMark(A.Citybank,100) BANKNAME,
            --SUBSTR(b.txdesc ,INSTRC(b.txdesc,'/')+1,LENGTH(b.txdesc)-INSTRC(b.txdesc,'/'))  REMARK,
            SUBSTR(b.txdesc,1,200) REMARK,
            a.TXNUM,a.TXDATE , c.bankacctno acctnosum  from CIREMITTANCE a , Tllog b , banknostro c
            WHERE rmstatus='P' and a.deltd ='N'
            AND (a.txnum = b.txnum and a.txdate = b.txdate)
            AND LENGTH(a.bankid) > 0
            and
            ( instr(v_banklist||'|202',substr(a.bankid,1,3))= 0 and EXISTS(select varvalue from sysvar where grname='SYSTEM' AND VARNAME='TCDTBIDV' and varvalue='1')
             or
             (instr(nvl(v_banklist,' '),substr(a.bankid,1,3)) = 0 and EXISTS(select varvalue from sysvar where grname='SYSTEM' AND VARNAME='TCDTBIDV' and varvalue='0'))
            )
            and c.glaccount in ('MSBQSD') --lay tai khoan tong QSDCN
            and c.branchid = '0001' --decode(substr(a.ACCTNO,1,4),'0002','0001',substr(a.ACCTNO,1,4))
            and b.txdesc like 'QSDCN%'
            and b.txstatus=1
            and (a.txnum || a.txdate) not in ( Select (b.txnum || b.txdate)from gw_putbatchtrans b )
            --and (SUBSTR(a.bankid,0,INSTRC(a.bankid,'.') -1)='302' OR a.bankid ='302' ) -- hotfix chuyen tien
            and length(a.bankid)>1 AND replace(replace( benefacct,' ',''),'.','') NOT IN (SELECT bankacc FROM cfotheraccblacklist)
            AND (substr(a.bankid,1,3) = '302'
            OR EXISTS (SELECT * FROM TCDTCASHLIMIT WHERE BANK_NAME = 'MSB' AND A.AMT >=CASH_FROM AND A.AMT <= CASH_TO))
            --end chaunh
            )
            where rownum <= 10

       )
   LOOP

        V_COUNT:=V_COUNT+1;
        v_strTRANSACTIONID :=v_strbatchid || lpad(to_char(v_count),4,'0');
        v_strRemark :=Correct_ReMark(rec.REmark,200);
        v_strBENEFCUSTNAME := UPPER(Correct_ReMark(rec.BENEFCUSTNAME,100));

       --1. Day xuong database cho day len GW , trang thai se la W
        INSERT INTO GW_PUTBATCHTRANS (AUTOID,TXNUM,TXDATE,BATCHID,TRANSACTIONID,FUNCTIONNAME,DIRECTION,TYPE,ACCTNO,BENEFCUSTNAME,ACCOUNT,AMOUNT,BANKCODE,BANKBRANCHCODE,BANKNAME,REMARK,STATUS,ERRNUM,ERRMSG,PROCESS,ACCTNOSUM)
        VALUES(seq_PUTBATCHTRANS.nextval,rec.TXNUM,TO_DATE(rec.TXDATE,'DD/MM/RRRR'),v_strbatchid,v_strTRANSACTIONID,'PUTBATCH','C2B',rec.TYPE,rec.ACCTNO,v_strBENEFCUSTNAME,rec.ACCOUNT,rec.AMOUNT,rec.BANKCODE,rec.BANKBRANCHCODE,rec.BANKNAME,v_strRemark,'P',0,NULL,'N',rec.acctnosum);

       --2. Danh dau trong CIREMITTANCE la da duoc day xuong GW_PUTBATCHTRANS cho boc len GW
        Update CIREMITTANCE CI Set rmstatus='W' where CI.txnum=Rec.txnum and Ci.Txdate =rec.txdate;
        COMMIT;

    END LOOP;


   EXCEPTION
      WHEN errnums.E_BIZ_RULE_INVALID THEN
         -- UPDATE BORQSLOG SET ERRNUM = v_errcode, ERRMSG = v_errmsg, STATUS = 'E'
         -- WHERE autoid = v_rqsautoid;
       --9. Cap nhat vao bang de chuyen qua ngan hang
           --INSERT INTO GW_UPDATETRANS (AUTOID,RQSSRC,RQSTYP,FUNCTIONNAME,DIRECTION,REFID,STATUS,ERRNUM,PROCESS)
           --VALUES(seq_GWUPDATETRAN.nextval ,v_RQSSRC,v_RQSTYP,'UPDATETRANSACTIONSTATUS','C2B',v_REFID,'E',v_errcode,'N');
           null;
      WHEN OTHERS THEN
      null;
        v_errmsg:= SQLERRM;
         -- UPDATE BORQSLOG SET ERRNUM = '-1', ERRMSG = 'Error in process: ' || v_errmsg, STATUS = 'E'
       --   WHERE autoid = v_rqsautoid;
       Null;
   END;


   --chaunh begin
    PROCEDURE pr_PutbatchProcessC2B_BIDV
    IS
      v_errcode NUMBER;
      v_status varchar(3);
      v_errmsg varchar(250);
      v_strbatchid  varchar(23);
      v_strTRANSACTIONID  varchar(23);
      V_COUNT number;
      v_strRemark VARCHAR2(500);
      v_strHOSTSTATUS varchar(23);
      v_strBENEFCUSTNAME  VARCHAR2(100);
      --1.3.0.4: chuyen tien 2 tk
      v_tltxcd VARCHAR2(4);

   BEGIN
   V_COUNT:=0;

   Select 'BI' || to_char(sysdate,'yyyyMMddhhMMssSSS') into v_strbatchid from dual;
   Select varvalue into v_strHOSTSTATUS from sysvar where varname ='HOSTATUS';
   If v_strHOSTSTATUS ='0' then
                return ;
   End if ;
   FOR rec IN
       (    Select (Case when ( SUBSTR(a.bankid,0,INSTRC(a.bankid,'.') -1)='302' ) OR a.bankid ='302' then 1 else 2 end) TYPE ,
            a.ACCTNO , replace(replace( benefacct,' ',''),'.','') ACCOUNT,AMT AMOUNT,nvl(SUBSTR(a.bankid,0,INSTRC(a.bankid,'.')-1),a.bankid) BANKCODE,
            SUBSTR(a.bankid,INSTRC(a.bankid,'.')+1,LENGTH(a.bankid) -INSTRC(a.bankid,'.')) BANKBRANCHCODE , --benefbank BANKNAME ,
            Correct_ReMark(A.Citybank,100) BANKNAME,
            --SUBSTR(b.txdesc ,INSTRC(b.txdesc,'/')+1,LENGTH(b.txdesc)-INSTRC(b.txdesc,'/'))  REMARK,
            Correct_ReMark(b.txdesc,100) REMARK,
            a.TXNUM,a.TXDATE  ,
            Correct_ReMark(a.BENEFCUSTNAME,100) BENEFCUSTNAME,
            b.tltxcd
             from CIREMITTANCE a , Tllog b
            WHERE rmstatus='P' and a.deltd ='N'
            AND (a.txnum = b.txnum and a.txdate = b.txdate)
            AND LENGTH(a.bankid) > 0
            and ((substr(a.bankid,1,3) = '202' --chi lay BIDV
                 and exists (select varvalue from sysvar where grname='SYSTEM' AND VARNAME='TCDTBIDV' and varvalue='1'))
                 OR EXISTS (SELECT * FROM TCDTCASHLIMIT WHERE BANK_NAME = 'BIDV' AND A.AMT >= CASH_FROM AND A.AMT <= CASH_TO)
                 )
            and b.txstatus=1
            and (a.txnum || a.txdate) not in ( Select (b.txnum || b.txdate)from tcdtbankrequest b )
            and length(a.bankid)>1 AND replace(replace( benefacct,' ',''),'.','') NOT IN (SELECT bankacc FROM cfotheraccblacklist)
            AND ROWNUM <= 10
       )
   LOOP
       --1.3.0.4: chuyen tien giua 2 tklk
       v_tltxcd := CASE WHEN rec.tltxcd='1201' THEN '1204' ELSE '1104' END;

       INSERT INTO tcdtbankrequest (REQID,OBJNAME,TRFCODE,TXNUM,TXDATE,ACCTNO,ACCOUNT,AMOUNT,BANKCODE,NOTES,STATUS,BENEFCUSTNAME)
       VALUES(seq_tcdtbankrequest.nextval,v_tltxcd,'HOLD',rec.TXNUM,TO_DATE(rec.TXDATE,'DD/MM/RRRR'),rec.ACCTNO,rec.ACCOUNT,rec.AMOUNT,'TCDT'/*rec.BANKCODE*/,REC.REMARK,'P',rec.BENEFCUSTNAME);
       --2. Danh dau trong CIREMITTANCE la da duoc day xuong GW_PUTBATCHTRANS cho boc len GW
        Update CIREMITTANCE CI Set rmstatus='W' where CI.txnum=Rec.txnum and Ci.Txdate =rec.txdate;
        COMMIT;

    END LOOP;


   EXCEPTION

      WHEN OTHERS THEN
      null;
        v_errmsg:= SQLERRM;

   END;
   --chaunh end


 PROCEDURE pr_Complete_PutbatchC2B
    IS
      -- Enter the procedure variables here. As shown below
      v_errcode NUMBER;
      --V_COUNT number;

      ---------------------
      v_status varchar(3);
      v_errmsg varchar(250);
      v_strbatchid  varchar(23);
      v_strTRANSACTIONID  varchar(23);
      V_COUNT number;
      v_strRemark VARCHAR2(500);

      l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      l_err_param varchar2(300);
      v_strbankacctno varchar2(300);
      v_fullnameBank varchar2(300);
      v_GLmap varchar2(300);
      v_BANKACCNAME varchar2(300);
      v_POTXNUM varchar2(100);
      v_strREFID varchar2(100);
      v_strAutoID varchar2(100);
      v_strBANKID varchar2(100);
      v_strHOSTSTATUS varchar2(100);


   BEGIN
   /*Select varvalue into v_strBANKID from sysvar where GRNAME='BANKGW' and VARNAME ='DEFAULTBANKID' ;*/ --Comment by ManhTV
   Select varvalue into v_strHOSTSTATUS from sysvar where varname ='HOSTATUS';

   V_COUNT:=0;

   Select 'BI' || to_char(sysdate,'yyyyMMddhhMMssSSS') into v_strbatchid from dual;
   /*Select bankacctno,fullname,glaccount,ownername INTO v_strbankacctno,v_fullnameBank,v_GLmap,v_BANKACCNAME from banknostro where shortname=v_strBANKID;*/

   FOR rec IN
       (    SELECT GWU.status, GWU.REFID REFID,FN_GET_LOCATION(af.brid) LOCATION, SUBSTR(af.brid,1,4) BRID, CF.FULLNAME,T1.TLNAME MAKER,T2.TLNAME OFFICER,
                   CF.CUSTODYCD , CD1.CDCONTENT DESC_IDTYPE, CF.IDCODE,
                   AF.ACCTNO ,CF.CUSTID, RM.TXDATE, RM.TXNUM, RM.BANKID,RM.BENEFBANK,RM.CITYEF,RM.CITYBANK,
                   RM.BENEFACCT, RM.BENEFCUSTNAME, RM.BENEFLICENSE, RM.BENEFIDDATE, RM.BENEFIDPLACE, RM.AMT, RM.FEEAMT,AF.ACCTNO || ' : ' ||TL.TXDESC DESCRIPTION,
                   RM.FEETYPE,CF.IDDATE,CF.IDPLACE,CF.ADDRESS,A1.CDCONTENT FEENAME,  '' GLACCTNO,  '' POTXNUM, '' POTXDATE, '' BANKNAME, '' BANKACC, '001' POTYPE,
                   GWP.ACCTNOSUM
               FROM CIREMITTANCE RM, AFMAST AF, CFMAST CF, ALLCODE A1,  ALLCODE CD1,(SELECT TLID, TLNAME FROM TLPROFILES UNION ALL SELECT '____' TLID, '____' TLNAME FROM DUAL) T1,
               (SELECT TLID, TLNAME FROM TLPROFILES UNION ALL SELECT '____' TLID, '____' TLNAME FROM DUAL) T2,
               (SELECT * FROM TLLOG WHERE TLTXCD in('1101','1108','1111','1185') AND TXSTATUS='1') TL , gw_putbatchtrans GWP , gw_updatetrans GWU
               WHERE CF.CUSTID=AF.CUSTID AND RM.ACCTNO=AF.ACCTNO AND RM.DELTD='N' AND RM.RMSTATUS='W' AND TL.TXNUM=RM.TXNUM AND TL.TXDATE=RM.TXDATE
               AND CD1.CDTYPE='CF' AND CD1.CDNAME='IDTYPE' AND CD1.CDVAL=CF.IDTYPE
               AND A1.CDTYPE='SA' AND A1.CDNAME='IOROFEE' AND A1.CDVAL=NVL(RM.FEETYPE,'0')
               AND (CASE WHEN TL.TLID IS NULL THEN '____' ELSE TL.TLID END)=T1.TLID
               AND (CASE WHEN TL.OFFID IS NULL THEN '____' ELSE TL.OFFID END)=T2.TLID AND  0 = 0
               AND RM.TXNUM =  GWP.TXNUM and RM.TXDATE = GWP.TXDATE
               AND GWP.transactionid = GWU.REFID
               AND GWP.direction ='C2B'
               AND GWU.direction='B2C'
               AND GWU.functionname='UPDATETRANS'
               --AND GWU.status =0
               and GWU.PROCESS='N'
       )
       LOOP
      ------------------------------------------------------


   v_strREFID := REC.REFID;

    if v_strHOSTSTATUS ='0' then
                return ;
     end if ;
  /*Add by ManhTV*/
   SELECT bankacctno,fullname,glaccount,ownername INTO v_strbankacctno,v_fullnameBank,v_GLmap,v_BANKACCNAME
        FROM banknostro WHERE bankacctno = rec.acctnosum;
  /*End Add*/
   if Rec.STATUS <>'0' then
   -- Neu ngan gang bao co loi
        UPDATE GW_UPDATETRANS SET PROCESS ='Y' WHERE  RQSSRC='MSB' AND DIRECTION='B2C' AND FUNCTIONNAME='UPDATETRANS' AND   REFID = V_STRREFID;
        UPDATE GW_PUTBATCHTRANS SET STATUS ='E' , errnum =Rec.status  WHERE FUNCTIONNAME ='PUTBATCH' AND DIRECTION ='C2B' AND TRANSACTIONID= V_STRREFID;
        Update CIREMITTANCE CI Set rmstatus='E' where CI.txnum=Rec.txnum and Ci.Txdate =rec.txdate;
        COMMIT;
        return;
   end if ;

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
    l_txmsg.batchname   := 'INT';
    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd:='1104';

    --Set txnum
    SELECT systemnums.C_BATCH_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO l_txmsg.txnum
              FROM DUAL;
    l_txmsg.brid        := substr(REC.ACCTNO,1,4);

   -- p_txnum:=l_txmsg.txnum;
   -- p_txdate:=l_txmsg.txdate;

  --Set cac field giao dich
    --03   ACCTNO          C
    l_txmsg.txfields ('03').defname   := 'ACCTNO';
    l_txmsg.txfields ('03').TYPE      := 'C';
    l_txmsg.txfields ('03').VALUE     := REC.ACCTNO;
     --91   ADDRESS         C
    l_txmsg.txfields ('91').defname   := 'ADDRESS';
    l_txmsg.txfields ('91').TYPE      := 'C';
    l_txmsg.txfields ('91').VALUE     :=  REC.ADDRESS;
     --90   CUSTNAME        C
    l_txmsg.txfields ('90').defname   := 'CUSTNAME';
    l_txmsg.txfields ('90').TYPE      := 'C';
    l_txmsg.txfields ('90').VALUE     :=REC.FULLNAME;
     --04   ACCTNO          C
    l_txmsg.txfields ('04').defname   := 'CUSTODYCD';
    l_txmsg.txfields ('04').TYPE      := 'C';
    l_txmsg.txfields ('04').VALUE     := REC.CUSTODYCD;
     --03   ACCTNO          C
    l_txmsg.txfields ('92').defname   := 'LICENSE';
    l_txmsg.txfields ('92').TYPE      := 'C';
    l_txmsg.txfields ('92').VALUE     := REC.IDCODE;
        --03   ACCTNO          C
    l_txmsg.txfields ('67').defname   := 'IDDATE';
    l_txmsg.txfields ('67').TYPE      := 'C';
    l_txmsg.txfields ('67').VALUE     := REC.IDDATE;

    --02   BANKID          C
    l_txmsg.txfields ('06').defname   := 'TXDATE';
    l_txmsg.txfields ('06').TYPE      := 'D';
    l_txmsg.txfields ('06').VALUE     := REC.TXDATE;

    --07   BANKID          C
    l_txmsg.txfields ('07').defname   := 'TXNUM';
    l_txmsg.txfields ('07').TYPE      := 'C';
    l_txmsg.txfields ('07').VALUE     := REC.TXNUM;

    --06   GLMAST          C
    l_txmsg.txfields ('81').defname   := 'BENEFACCT';
    l_txmsg.txfields ('81').TYPE      := 'C';
    l_txmsg.txfields ('81').VALUE     := REC.BENEFACCT;

    --10   AMT          N
    l_txmsg.txfields ('05').defname   := 'BANKID';
    l_txmsg.txfields ('05').TYPE      := 'C';
    l_txmsg.txfields ('05').VALUE     := REC.BANKID;

    --30   DESC            C
    l_txmsg.txfields ('10').defname   := 'AMT';
    l_txmsg.txfields ('10').TYPE      := 'N';
    l_txmsg.txfields ('10').VALUE     :=REC.AMT;


    --82   CUSTODYCD   C
    l_txmsg.txfields ('32').defname   := 'CITYBANK';
    l_txmsg.txfields ('32').TYPE      := 'C';
    l_txmsg.txfields ('32').VALUE     := REC.CITYBANK;



    --92   LICENSE         C
    l_txmsg.txfields ('33').defname   := 'CITYEF';
    l_txmsg.txfields ('33').TYPE      := 'C';
    l_txmsg.txfields ('33').VALUE     :=REC.CITYEF;
    --93   IDDATE          C
    l_txmsg.txfields ('80').defname   := 'BENEFBANK';
    l_txmsg.txfields ('80').TYPE      := 'C';
    l_txmsg.txfields ('80').VALUE     :=REC.BENEFBANK;
    --94   IDPLACE         C
    l_txmsg.txfields ('30').defname   := 'DESC';
    l_txmsg.txfields ('30').TYPE      := 'C';
    l_txmsg.txfields ('30').VALUE     :=REC.DESCRIPTION;
      --94   IDPLACE         C
    l_txmsg.txfields ('82').defname   := 'BENEFCUSTNAME';
    l_txmsg.txfields ('82').TYPE      := 'C';
    l_txmsg.txfields ('82').VALUE     :=REC.BENEFCUSTNAME;
      --94   IDPLACE         C
    l_txmsg.txfields ('83').defname   := 'RECEIVLICENSE';
    l_txmsg.txfields ('83').TYPE      := 'C';
    l_txmsg.txfields ('83').VALUE     :='';
      --94   IDPLACE         C
    l_txmsg.txfields ('95').defname   := 'RECEIVIDDATE';
    l_txmsg.txfields ('95').TYPE      := 'C';
    l_txmsg.txfields ('95').VALUE :='';

        --94   IDPLACE         C
    l_txmsg.txfields ('96').defname   := 'RECEIVIDPLACE';
    l_txmsg.txfields ('96').TYPE      := 'C';
    l_txmsg.txfields ('96').VALUE :='';
      --94   IDPLACE         C
    l_txmsg.txfields ('98').defname   := 'POTXDATE';
    l_txmsg.txfields ('98').TYPE      := 'C';
    l_txmsg.txfields ('98').VALUE     := REC.TXDATE;
      --94   IDPLACE         C
    l_txmsg.txfields ('08').defname   := 'BANKACC';
    l_txmsg.txfields ('08').TYPE      := 'C';
    l_txmsg.txfields ('08').VALUE :=v_strbankacctno;
      --94   IDPLACE         C
    l_txmsg.txfields ('09').defname   := 'IORO';
    l_txmsg.txfields ('09').TYPE      := 'C';
    l_txmsg.txfields ('09').VALUE     :=REC.FEETYPE;

            --94   IDPLACE         C
    l_txmsg.txfields ('15').defname   := 'GLMAST';
    l_txmsg.txfields ('15').TYPE      := 'C';
    l_txmsg.txfields ('15').VALUE     :=v_GLmap;
      --94   IDPLACE         C
    l_txmsg.txfields ('85').defname   := 'BANKNAME';
    l_txmsg.txfields ('85').TYPE      := 'C';
    l_txmsg.txfields ('85').VALUE     :=v_fullnameBank;
      --94   IDPLACE         C

      SELECT NVL(MAX(ODR)+1,1) INTO v_strAutoID  FROM
                  (SELECT ROWNUM ODR, INVACCT
                  FROM (SELECT TXNUM INVACCT FROM POMAST WHERE BRID = REC.BRID ORDER BY TXNUM) DAT
                  ) INVTAB;

    v_POTXNUM := REC.BRID || LPAD(v_strAutoID,6,'0');

    l_txmsg.txfields ('99').defname   := 'POTXNUM';
    l_txmsg.txfields ('99').TYPE      := 'C';
    l_txmsg.txfields ('99').VALUE     := v_POTXNUM;
      --94   IDPLACE         C
    l_txmsg.txfields ('86').defname   := 'BANKACCNAME';
    l_txmsg.txfields ('86').TYPE      := 'C';
    l_txmsg.txfields ('86').VALUE :=  v_BANKACCNAME;
       --94   IDPLACE         C
    l_txmsg.txfields ('17').defname   := 'POTYPE';
    l_txmsg.txfields ('17').TYPE      := 'C';
    l_txmsg.txfields ('17').VALUE :=REC.POTYPE;
    BEGIN
        IF txpks_#1104.fn_autotxprocess (l_txmsg,
                                         v_errcode,
                                         l_err_param
           ) <> systemnums.c_success
        THEN
           plog.debug (pkgctx,
                       'got error 1104: ' || v_errcode
           );
           ROLLBACK;
           RETURN;
        END IF;
    END;
    v_errcode:=0;
    plog.setendsection(pkgctx, 'pr_Complete_PutbatchC2B');
      -----------------END-----------------------------------
        UPDATE GW_UPDATETRANS SET PROCESS ='Y' WHERE  RQSSRC='MSB' AND DIRECTION='B2C' AND FUNCTIONNAME='UPDATETRANS' AND   REFID = V_STRREFID;
        UPDATE GW_PUTBATCHTRANS SET STATUS ='C' WHERE FUNCTIONNAME ='PUTBATCH' AND DIRECTION ='C2B' AND TRANSACTIONID= V_STRREFID;
        COMMIT;
    END LOOP;


   EXCEPTION
      WHEN errnums.E_BIZ_RULE_INVALID THEN

        UPDATE GW_UPDATETRANS SET PROCESS ='Y' WHERE  RQSSRC='MSB' AND DIRECTION='B2C' AND FUNCTIONNAME='UPDATETRANS' AND   REFID = V_STRREFID;
        UPDATE GW_PUTBATCHTRANS SET STATUS ='E' WHERE FUNCTIONNAME ='PUTBATCH' AND DIRECTION ='C2B' AND TRANSACTIONID= V_STRREFID;
        COMMIT;

      WHEN OTHERS THEN

        UPDATE GW_UPDATETRANS SET PROCESS ='Y' WHERE  RQSSRC='MSB' AND DIRECTION='B2C' AND FUNCTIONNAME='UPDATETRANS' AND   REFID = V_STRREFID;
        UPDATE GW_PUTBATCHTRANS SET STATUS ='E' WHERE FUNCTIONNAME ='PUTBATCH' AND DIRECTION ='C2B' AND TRANSACTIONID= V_STRREFID;
        COMMIT;
        v_errmsg:= SQLERRM;
       Null;
   END;


   PROCEDURE pr_CreateFileCheck(
   F_DATE IN  VARCHAR2,
   T_DATE IN  VARCHAR2
   )
    IS
      v_TotalB2C          VARCHAR2(25);
      v_TotalB2C_Success  VARCHAR2(25);
      v_TotalB2CAMT       VARCHAR2(25);
      v_TotalC2B            VARCHAR2(25);
      v_TotalC2B_Success    VARCHAR2(25);
      v_TotalC2BAMT         VARCHAR2(25);
      v_TotalC2BN            VARCHAR2(25);
      v_TotalC2BN_Success    VARCHAR2(25);
      v_TotalC2BNAMT         VARCHAR2(25);
      v_TotalC2BL            VARCHAR2(25);
      v_TotalC2BL_Success    VARCHAR2(25);
      v_TotalC2BLAMT         VARCHAR2(25);
      v_errmsg            VARCHAR2(200);

   BEGIN

             Delete from  GW_TRANSCHKFILE ;


            --1 BANH GUI SANG NGAN HANG
             Select count(*) into v_TotalB2C
             from borqslog
             where rqstyp in('CRA','CRI') and  rqssrc='MSB'
             and txdate >= TO_DATE (F_DATE, 'DD/MM/YYYY')
             and txdate <= TO_DATE (T_DATE, 'DD/MM/YYYY');

            --2. Nhung giao dich thanh cong---
            Select count(*) into v_TotalB2C_Success
            from borqslog where rqstyp in ('CRA','CRI') and  rqssrc='MSB'
            and status ='C'
            and txdate >= TO_DATE (F_DATE, 'DD/MM/YYYY')
            and txdate <= TO_DATE (T_DATE, 'DD/MM/YYYY');

            --3. Tong Tien cua cac giao dich thanh cong
            Select SUM(msgamt) into v_TotalB2CAMT from borqslog where rqstyp in('CRA','CRI')
            and  rqssrc='MSB'
            and status ='C'
            and txdate >= TO_DATE (F_DATE, 'DD/MM/YYYY')
            and txdate <= TO_DATE (T_DATE, 'DD/MM/YYYY');

            INSERT INTO GW_TRANSCHKFILE (STT,TRANS_CODE,TRANS_NAME,TOTAL_TRANS_MSBS,SUCCESS_TRANS_MSBS,TOTAL_AMOUNT_MSBS,TOTAL_FEE_MSBS,FROM_DATE,TO_DATE)
            VALUES('1','B2C','Tu MSB sang MSBS',v_TotalB2C,v_TotalB2C_Success,v_TotalB2CAMT,'0',F_DATE,T_DATE);

            ----MSBS chuyen sang BANK ===============================
            Select count(*)  into v_TotalC2B from
              (
                Select * from gw_putbatchtrans
                union all
                Select * from gw_putbatchtrans_hist
              )
            where direction ='C2B' and functionname ='PUTBATCH' and process ='Y' and  status <>'P'
            and txdate >= TO_DATE (F_DATE, 'DD/MM/YYYY')
            and txdate <= TO_DATE (T_DATE, 'DD/MM/YYYY');


            Select count(*) into v_TotalC2B_Success from
            (
                Select * from gw_putbatchtrans
                union all
                Select * from gw_putbatchtrans_hist
             )
            where direction ='C2B' and functionname ='PUTBATCH' and process ='Y' and  status ='C'
            and txdate >= TO_DATE (F_DATE, 'DD/MM/YYYY')
            and txdate <= TO_DATE (T_DATE, 'DD/MM/YYYY');

            Select  nvl(SUM(AMOUNT),0) into v_TotalC2BAMT from
            (
                Select * from gw_putbatchtrans
                union all
                Select * from gw_putbatchtrans_hist
            )
            where direction ='C2B' and functionname ='PUTBATCH' and process ='Y' and  status ='C'
            and txdate >= TO_DATE (F_DATE, 'DD/MM/YYYY')
            and txdate <= TO_DATE (T_DATE, 'DD/MM/YYYY');

            INSERT INTO GW_TRANSCHKFILE (STT,TRANS_CODE,TRANS_NAME,TOTAL_TRANS_MSBS,SUCCESS_TRANS_MSBS,TOTAL_AMOUNT_MSBS,TOTAL_FEE_MSBS,FROM_DATE,TO_DATE)
            VALUES('2','C2B','Tu MSBS sang BANK',v_TotalC2B,v_TotalC2B_Success,v_TotalC2BAMT,'0',F_DATE,T_DATE);

            ----3. MSBS chuyen sang BANK NOI BO ===============================
            Select count(*)  into v_TotalC2BN from
            (
                Select * from gw_putbatchtrans
                union all
                Select * from gw_putbatchtrans_hist
            )
            where direction ='C2B' and functionname ='PUTBATCH' and process ='Y' and  status <>'P' and type='1'
            and txdate >= TO_DATE (F_DATE, 'DD/MM/YYYY')
            and txdate <= TO_DATE (T_DATE, 'DD/MM/YYYY');


            Select count(*) into v_TotalC2BN_Success from
            (
                Select * from gw_putbatchtrans
                union all
                Select * from gw_putbatchtrans_hist
            )
            where direction ='C2B' and functionname ='PUTBATCH' and process ='Y' and  status ='C' and type='1'
            and txdate >= TO_DATE (F_DATE, 'DD/MM/YYYY')
            and txdate <= TO_DATE (T_DATE, 'DD/MM/YYYY');

            Select  nvl(SUM(AMOUNT),0) into v_TotalC2BNAMT from
            (
                Select * from gw_putbatchtrans
                union all
                Select * from gw_putbatchtrans_hist
            )
            where direction ='C2B' and functionname ='PUTBATCH' and process ='Y' and  status ='C' and type='1'
            and txdate >= TO_DATE (F_DATE, 'DD/MM/YYYY')
            and txdate <= TO_DATE (T_DATE, 'DD/MM/YYYY');

            INSERT INTO GW_TRANSCHKFILE (STT,TRANS_CODE,TRANS_NAME,TOTAL_TRANS_MSBS,SUCCESS_TRANS_MSBS,TOTAL_AMOUNT_MSBS,TOTAL_FEE_MSBS,FROM_DATE,TO_DATE)
            VALUES('3','C2BN','Tu MSBS sang BANK NOI BO',v_TotalC2BN,v_TotalC2BN_Success,v_TotalC2BNAMT,'0',F_DATE,T_DATE);

            ----4. MSBS chuyen sang BANK LIEN NGAN HANG ===============================
            Select count(*)  into v_TotalC2BL from
            (
                Select * from gw_putbatchtrans
                union all
                Select * from gw_putbatchtrans_hist
            )
            where direction ='C2B' and functionname ='PUTBATCH' and process ='Y' and  status <>'P' and type='2'
            and txdate >= TO_DATE (F_DATE, 'DD/MM/YYYY')
            and txdate <= TO_DATE (T_DATE, 'DD/MM/YYYY');


            Select count(*) into v_TotalC2BL_Success from
            (
                Select * from gw_putbatchtrans
                union all
                Select * from gw_putbatchtrans_hist
            )
            where direction ='C2B' and functionname ='PUTBATCH' and process ='Y' and  status ='C'  and type='2'
            and txdate >= TO_DATE (F_DATE, 'DD/MM/YYYY')
            and txdate <= TO_DATE (T_DATE, 'DD/MM/YYYY');

            Select nvl(SUM(AMOUNT),0) into v_TotalC2BLAMT from
            (
                Select * from gw_putbatchtrans
                union all
                Select * from gw_putbatchtrans_hist
            )

            where direction ='C2B' and functionname ='PUTBATCH' and process ='Y' and  status ='C'  and type='2'
            and txdate >= TO_DATE (F_DATE, 'DD/MM/YYYY')
            and txdate <= TO_DATE (T_DATE, 'DD/MM/YYYY');

            INSERT INTO GW_TRANSCHKFILE (STT,TRANS_CODE,TRANS_NAME,TOTAL_TRANS_MSBS,SUCCESS_TRANS_MSBS,TOTAL_AMOUNT_MSBS,TOTAL_FEE_MSBS,FROM_DATE,TO_DATE)
            VALUES('4','C2BL','Tu MSBS sang BANK Lien ngan hang',v_TotalC2BL,v_TotalC2BL_Success,v_TotalC2BLAMT,'0',F_DATE,T_DATE);


   EXCEPTION
      WHEN errnums.E_BIZ_RULE_INVALID THEN
           null;
      WHEN OTHERS THEN
      null;
   END;


PROCEDURE pr_TCDTBANKREQUEST1104(p_refcode IN varchar,p_err_code  OUT varchar2)
  IS
  v_strCURRDATE DATE;
  v_strDATEFEE DATE;
  v_strCOMPANYCD varchar2(10);
  v_Result  number(20);
  l_txmsg   tx.msg_rectype;
  v_errcode NUMBER;
  l_err_param varchar2(300);
  v_POTXNUM varchar2(20);
  v_strAutoID varchar2(100);
  v_strHOSTSTATUS varchar2(100);

BEGIN
    plog.setbeginsection (pkgctx, 'pr_TCDTBANKREQUEST1104');
    plog.debug (pkgctx, '<<BEGIN OF pr_TCDTBANKREQUEST1104');

    p_err_code:= systemnums.C_SUCCESS;

    Select varvalue into v_strHOSTSTATUS from sysvar where varname ='HOSTATUS';
     if v_strHOSTSTATUS ='0' then
                return ;
        end if ;

    --GET TDMAST ATRIBUTES

    SELECT VARVALUE || '%' into v_strCOMPANYCD FROM SYSVAR  WHERE VARNAME='COMPANYCD';

    SELECT TO_DATE(VARVALUE,'DD/MM/YYYY') into v_strCURRDATE FROM SYSVAR  WHERE VARNAME='CURRDATE';

    for rec in (
           select CR.reqid, cr.txdate, cf.custodycd, cr.acctno afacctno, cf.fullname, cf.address, cf.idcode, cf.iddate,
              fn_gettcdtdesbankacc(substr(cr.acctno,1,4)) BANKACC,
              fn_gettcdtdesbankname(substr(cr.acctno,1,4)) BANKNAME,
              fn_gettcdtdesbankname(substr(cr.acctno,1,4)) BANKACCNAME,
              fn_gettcdtdesbankacc(substr(cr.acctno,1,4)) GLMAST, NVL(ci.BANKID,'') BANKID, cr.Account RECACCTNO,
              bm.BankCode recbankcode, bl.BankName recbankname,
              bl.regional recbankcity, cf.fullname recacctname, '' RECEIVLICENSE, '' RECEIVIDDATE, ci.feetype,
              ci.amt, ci.feeamt, ci.txnum,
              getcurrdate POTXDATE, '001' POTYPE, CR.ERRORDESC NOTES
          from TCDTBankRequest cr, cfmast cf, afmast af, ciremittance ci, CRBBANKMAP bm, CRBBANKLIST bl
          where cf.custid = af.custid and cr.acctno = af.acctno
              and to_char(cr.txdate,'dd/mm/rrrr')||cr.txnum = to_char(ci.txdate,'dd/mm/rrrr')||ci.txnum
              and substr(cr.Account,1,3) = bm.BankId
              and bm.BankCode = bl.BankCode
              and cr.status = 'W'
             -- and cr.refcode = p_refcode
    )
    loop

        plog.debug (pkgctx, '<<BEGIN OF pr_TCDTBANKREQUEST1104_ IN LOOP');
        UPDATE TCDTBankRequest SET STATUS = 'C' WHERE REQID = REC.REQID;

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
        l_txmsg.batchname   := 'INT';
        l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.busdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.tltxcd:='1104';

        --Set txnum
        SELECT systemnums.C_BATCH_PREFIXED
                         || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                  INTO l_txmsg.txnum
                  FROM DUAL;
        l_txmsg.brid        := substr(REC.afacctno,1,4);


      --Set cac field giao dich

       --06  TXDATE          D
        l_txmsg.txfields ('06').defname   := 'TXDATE';
        l_txmsg.txfields ('06').TYPE      := 'D';
        l_txmsg.txfields ('06').VALUE     := rec.TXDATE;

        --04  CUSTODYCD       C
        l_txmsg.txfields ('04').defname   := 'CUSTODYCD';
        l_txmsg.txfields ('04').TYPE      := 'C';
        l_txmsg.txfields ('04').VALUE     := rec.CUSTODYCD;

        --03  ACCTNO          C
        l_txmsg.txfields ('03').defname   := 'ACCTNO';
        l_txmsg.txfields ('03').TYPE      := 'C';
        l_txmsg.txfields ('03').VALUE     := rec.AFACCTNO;

        --90  CUSTNAME        C
        l_txmsg.txfields ('90').defname   := 'CUSTNAME';
        l_txmsg.txfields ('90').TYPE      := 'C';
        l_txmsg.txfields ('90').VALUE     := rec.fullname;

        --91  ADDRESS         C
        l_txmsg.txfields ('91').defname   := 'ADDRESS';
        l_txmsg.txfields ('91').TYPE      := 'C';
        l_txmsg.txfields ('91').VALUE     := rec.ADDRESS;

        --92  LICENSE         C
        l_txmsg.txfields ('92').defname   := 'ADDRESS';
        l_txmsg.txfields ('92').TYPE      := 'C';
        l_txmsg.txfields ('92').VALUE     := rec.IDCODE;

        --67  IDDATE          C
        l_txmsg.txfields ('67').defname   := 'IDDATE';
        l_txmsg.txfields ('67').TYPE      := 'C';
        l_txmsg.txfields ('67').VALUE     := rec.IDDATE;

        --08  BANKACC         C
        l_txmsg.txfields ('08').defname   := 'IDDATE';
        l_txmsg.txfields ('08').TYPE      := 'C';
        l_txmsg.txfields ('08').VALUE     := rec.BANKACC;

        --85  BANKNAME        C
        l_txmsg.txfields ('85').defname   := 'BANKNAME';
        l_txmsg.txfields ('85').TYPE      := 'C';
        l_txmsg.txfields ('85').VALUE     := rec.BANKNAME;

        --86  BANKACCNAME     C
        l_txmsg.txfields ('86').defname   := 'BANKACCNAME';
        l_txmsg.txfields ('86').TYPE      := 'C';
        l_txmsg.txfields ('86').VALUE     := rec.BANKACCNAME;

        --15  GLMAST          C
        l_txmsg.txfields ('15').defname   := 'GLMAST';
        l_txmsg.txfields ('15').TYPE      := 'C';
        l_txmsg.txfields ('15').VALUE     := rec.GLMAST;

        --05  BANKID          C
        l_txmsg.txfields ('05').defname   := 'BANKID';
        l_txmsg.txfields ('05').TYPE      := 'C';
        l_txmsg.txfields ('05').VALUE     := rec.BANKID;

        --80  BENEFBANK       C
        l_txmsg.txfields ('80').defname   := 'BENEFBANK';
        l_txmsg.txfields ('80').TYPE      := 'C';
        l_txmsg.txfields ('80').VALUE     := rec.recbankname;

        --82  BENEFCUSTNAME   C
        l_txmsg.txfields ('82').defname   := 'BENEFBANK';
        l_txmsg.txfields ('82').TYPE      := 'C';
        l_txmsg.txfields ('82').VALUE     := rec.recacctname;

        --83  RECEIVLICENSE   C   S? gi?y t? KH th? hu?ng
        l_txmsg.txfields ('83').defname   := 'RECEIVLICENSE';
        l_txmsg.txfields ('83').TYPE      := 'C';
        l_txmsg.txfields ('83').VALUE     := rec.RECEIVLICENSE;

        --95  RECEIVIDDATE    C
        l_txmsg.txfields ('95').defname   := 'RECEIVIDDATE';
        l_txmsg.txfields ('95').TYPE      := 'C';
        l_txmsg.txfields ('95').VALUE     := rec.RECEIVIDDATE;

        --81  BENEFACCT       C
        l_txmsg.txfields ('81').defname   := 'BENEFACCT';
        l_txmsg.txfields ('81').TYPE      := 'C';
        l_txmsg.txfields ('81').VALUE     := rec.RECACCTNO;

        --32  CITYBANK        C
        l_txmsg.txfields ('32').defname   := 'CITYBANK';
        l_txmsg.txfields ('32').TYPE      := 'C';
        l_txmsg.txfields ('32').VALUE     := rec.recbankcity;

        --33  CITYEF          C
        l_txmsg.txfields ('33').defname   := 'CITYBANK';
        l_txmsg.txfields ('33').TYPE      := 'C';
        l_txmsg.txfields ('33').VALUE     := rec.recbankcity;

        --09  IORO            C
        l_txmsg.txfields ('09').defname   := 'IORO';
        l_txmsg.txfields ('09').TYPE      := 'C';
        l_txmsg.txfields ('09').VALUE     := rec.feetype;

        --10  AMT             N
        l_txmsg.txfields ('10').defname   := 'AMT';
        l_txmsg.txfields ('10').TYPE      := 'N';
        l_txmsg.txfields ('10').VALUE     := rec.amt;

        --12  TRFAMT          N
        l_txmsg.txfields ('12').defname   := 'TRFAMT';
        l_txmsg.txfields ('12').TYPE      := 'N';
        l_txmsg.txfields ('12').VALUE     := rec.amt + rec.feeamt;

        --11  FEEAMT          N
        l_txmsg.txfields ('11').defname   := 'FEEAMT';
        l_txmsg.txfields ('11').TYPE      := 'N';
        l_txmsg.txfields ('11').VALUE     := rec.FEEAMT;

        --13  VATAMT          N
        --l_txmsg.txfields ('13').defname   := 'VATAMT';
        --l_txmsg.txfields ('13').TYPE      := 'N';
        --l_txmsg.txfields ('13').VALUE     := rec.vat;

        --07  TXNUM           C
        l_txmsg.txfields ('07').defname   := 'TXNUM';
        l_txmsg.txfields ('07').TYPE      := 'C';
        l_txmsg.txfields ('07').VALUE     := rec.TXNUM;

        --98  POTXDATE        D
        l_txmsg.txfields ('98').defname   := 'POTXDATE';
        l_txmsg.txfields ('98').TYPE      := 'D';
        l_txmsg.txfields ('98').VALUE     := v_strCURRDATE;

        --99  POTXNUM         C
       SELECT NVL(MAX(ODR)+1,1) INTO v_strAutoID  FROM
                   (SELECT ROWNUM ODR, INVACCT
                   FROM (SELECT TXNUM INVACCT FROM POMAST WHERE BRID = substr(REC.afacctno,1,4) ORDER BY TXNUM) DAT
                   ) INVTAB;

        v_POTXNUM := substr(REC.afacctno,1,4) || LPAD(v_strAutoID,6,'0');

        l_txmsg.txfields ('99').defname   := 'POTXNUM';
        l_txmsg.txfields ('99').TYPE      := 'C';
        l_txmsg.txfields ('99').VALUE     := v_POTXNUM;

        --17  POTYPE          C
        l_txmsg.txfields ('17').defname   := 'POTYPE';
        l_txmsg.txfields ('17').TYPE      := 'C';
        l_txmsg.txfields ('17').VALUE     := rec.POTYPE;

        --30  DESC            C
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').VALUE     := rec.NOTES;

        --96  RECEIVIDPLACE   C
        l_txmsg.txfields ('96').defname   := 'RECEIVIDPLACE';
        l_txmsg.txfields ('96').TYPE      := 'C';
        l_txmsg.txfields ('96').VALUE     := '';

        BEGIN
            IF txpks_#1104.fn_autotxprocess (l_txmsg,
                                             v_errcode,
                                             l_err_param
               ) <> systemnums.c_success
            THEN
               plog.debug (pkgctx,
                           'got error 1104: ' || v_errcode
               );
               p_err_code:=v_errcode;
               ROLLBACK;
               RETURN;
            END IF;
        END;


    end loop;



    commit;
    plog.debug (pkgctx, '<<END OF pr_TCDTBANKREQUEST1104');
    plog.setendsection (pkgctx, 'pr_TCDTBANKREQUEST1104');

EXCEPTION
WHEN OTHERS
   THEN
      plog.error (pkgctx, SQLERRM|| dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_TCDTBANKREQUEST1104');
END pr_TCDTBANKREQUEST1104;

--1.8.2.1:Chỉnh sửa thu chi điện tử với BIDV
PROCEDURE PR_TCDTBANKREQUEST1204(P_REFCODE  IN VARCHAR,
                                 P_ERR_CODE OUT VARCHAR2) IS
  V_STRCURRDATE   DATE;
  V_STRHOSTSTATUS VARCHAR2(100);
  V_DESC          TLTX.TXDESC%TYPE;
  L_TXMSG         TX.MSG_RECTYPE;
  v_errcode       NUMBER;
  l_err_param     varchar2(300);
BEGIN
  PLOG.SETBEGINSECTION(PKGCTX, 'pr_TCDTBANKREQUEST1204');
  PLOG.DEBUG(PKGCTX, '<<BEGIN OF pr_TCDTBANKREQUEST1204');

  P_ERR_CODE := SYSTEMNUMS.C_SUCCESS;
/*
  SELECT VARVALUE
    INTO V_STRHOSTSTATUS
    FROM SYSVAR
   WHERE VARNAME = 'HOSTATUS';
  IF V_STRHOSTSTATUS = '0' THEN
    RETURN;
  END IF;

      FOR REC IN (SELECT CR.TXDATE,
                         CR.TXNUM,
                         TC.DCUSTODYCD,
                         TC.DACCTNO,
                         CFD.FULLNAME,
                         CFD.IDCODE    LICENSE,
                         CFD.IDDATE,
                         TC.CCUSTODYCD,
                         TC.CACCTNO,
                         CFC.FULLNAME  CUSTNAME2,
                         CFC.IDCODE    LICENSE2,
                         CFC.IDDATE    IDDATE2,
                         CR.AMOUNT,
                         CR.OBJNAME,
                         CR.REQID,
                         TC.BRID
                    FROM TCDTBANKREQUEST  CR,
                         TCDT2DEPOACC_LOG TC,
                         CFMAST           CFC,
                         CFMAST           CFD
                   WHERE TO_CHAR(CR.TXDATE, 'dd/mm/rrrr') || CR.TXNUM =
                         TO_CHAR(TC.TXDATE, 'dd/mm/rrrr') || TC.TXNUM
                     AND CR.ACCTNO = TC.DACCTNO
                     AND TC.DCUSTODYCD = CFD.CUSTODYCD
                     AND TC.CCUSTODYCD = CFC.CUSTODYCD
                     AND CR.STATUS = 'W'
                     AND CR.OBJNAME = '1204') LOOP

              PLOG.DEBUG(PKGCTX, '<<BEGIN OF pr_TCDTBANKREQUEST1204_ IN LOOP');
              UPDATE TCDTBANKREQUEST SET STATUS = 'C' WHERE REQID = REC.REQID;

              SELECT TO_DATE(VARVALUE, SYSTEMNUMS.C_DATE_FORMAT)
                INTO V_STRCURRDATE
                FROM SYSVAR
               WHERE GRNAME = 'SYSTEM'
                 AND VARNAME = 'CURRDATE';

              V_DESC := FN_GEN_DESC_1204('',REC.DCUSTODYCD,REC.CCUSTODYCD);

              L_TXMSG.MSGTYPE := 'T';
              L_TXMSG.LOCAL   := 'N';
              L_TXMSG.TLID    := SYSTEMNUMS.C_SYSTEM_USERID;
              SELECT SYS_CONTEXT('USERENV', 'HOST'),
                     SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15)
                INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS
                FROM DUAL;
              L_TXMSG.OFF_LINE  := 'N';
              L_TXMSG.DELTD     := TXNUMS.C_DELTD_TXNORMAL;
              L_TXMSG.TXSTATUS  := TXSTATUSNUMS.C_TXCOMPLETED;
              L_TXMSG.MSGSTS    := '0';
              L_TXMSG.OVRSTS    := '0';
              L_TXMSG.BATCHNAME := 'INT';
              L_TXMSG.TXDATE    := V_STRCURRDATE;
              L_TXMSG.BUSDATE   := V_STRCURRDATE;
              L_TXMSG.txdesc    := V_DESC;
              L_TXMSG.TLTXCD    := '1204';

              --Set txnum
              SELECT SYSTEMNUMS.C_BATCH_PREFIXED ||
                     LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
                INTO L_TXMSG.TXNUM
                FROM DUAL;
              L_TXMSG.BRID := REC.BRID;

              --Set cac field giao dich

              --06  TXDATE          D
              L_TXMSG.TXFIELDS('06').DEFNAME := 'TXDATE';
              L_TXMSG.TXFIELDS('06').TYPE := 'D';
              L_TXMSG.TXFIELDS('06').VALUE := REC.TXDATE;

              --07  TXNUM          D
              L_TXMSG.TXFIELDS('07').DEFNAME := 'TXDATE';
              L_TXMSG.TXFIELDS('07').TYPE := 'C';
              L_TXMSG.TXFIELDS('07').VALUE := REC.TXNUM;

              --88  DCUSTODYCD       C
              L_TXMSG.TXFIELDS('88').DEFNAME := 'DCUSTODYCD';
              L_TXMSG.TXFIELDS('88').TYPE := 'C';
              L_TXMSG.TXFIELDS('88').VALUE := REC.DCUSTODYCD;

              --03  DACCTNO          C
              L_TXMSG.TXFIELDS('03').DEFNAME := 'DACCTNO';
              L_TXMSG.TXFIELDS('03').TYPE := 'C';
              L_TXMSG.TXFIELDS('03').VALUE := REC.DACCTNO;

              --31  FULLNAME        C
              L_TXMSG.TXFIELDS('31').DEFNAME := 'FULLNAME';
              L_TXMSG.TXFIELDS('31').TYPE := 'C';
              L_TXMSG.TXFIELDS('31').VALUE := REC.FULLNAME;

              --92  LICENSE         C
              L_TXMSG.TXFIELDS('92').DEFNAME := 'LICENSE';
              L_TXMSG.TXFIELDS('92').TYPE := 'C';
              L_TXMSG.TXFIELDS('92').VALUE := REC.LICENSE;

              --96  IDDATE          C
              L_TXMSG.TXFIELDS('96').DEFNAME := 'IDDATE';
              L_TXMSG.TXFIELDS('96').TYPE := 'D';
              L_TXMSG.TXFIELDS('96').VALUE := REC.IDDATE;

              --89  CCUSTODYCD       C
              L_TXMSG.TXFIELDS('89').DEFNAME := 'CCUSTODYCD';
              L_TXMSG.TXFIELDS('89').TYPE := 'C';
              L_TXMSG.TXFIELDS('89').VALUE := REC.CCUSTODYCD;

              --05  CACCTNO          C
              L_TXMSG.TXFIELDS('05').DEFNAME := 'CACCTNO';
              L_TXMSG.TXFIELDS('05').TYPE := 'C';
              L_TXMSG.TXFIELDS('05').VALUE := REC.CACCTNO;

              --93  FULLNAME        C
              L_TXMSG.TXFIELDS('93').DEFNAME := 'CUSTNAME2';
              L_TXMSG.TXFIELDS('93').TYPE := 'C';
              L_TXMSG.TXFIELDS('93').VALUE := REC.CUSTNAME2;

              --95  LICENSE2         C
              L_TXMSG.TXFIELDS('95').DEFNAME := 'LICENSE2';
              L_TXMSG.TXFIELDS('95').TYPE := 'C';
              L_TXMSG.TXFIELDS('95').VALUE := REC.LICENSE2;

              --98  IDDATE2          C
              L_TXMSG.TXFIELDS('98').DEFNAME := 'IDDATE2';
              L_TXMSG.TXFIELDS('98').TYPE := 'D';
              L_TXMSG.TXFIELDS('98').VALUE := REC.IDDATE2;

              --10  AMT             N
              L_TXMSG.TXFIELDS('10').DEFNAME := 'AMT';
              L_TXMSG.TXFIELDS('10').TYPE := 'N';
              L_TXMSG.TXFIELDS('10').VALUE := REC.AMOUNT;

              --30  DESC            C
              L_TXMSG.TXFIELDS('30').DEFNAME := 'DESC';
              L_TXMSG.TXFIELDS('30').TYPE := 'C';
              L_TXMSG.TXFIELDS('30').VALUE := V_DESC;

              BEGIN
                IF TXPKS_#1204.FN_AUTOTXPROCESS(L_TXMSG, V_ERRCODE, L_ERR_PARAM) <>
                   SYSTEMNUMS.C_SUCCESS THEN
                  PLOG.DEBUG(PKGCTX, 'got error 1204: ' || V_ERRCODE);
                  P_ERR_CODE := V_ERRCODE;
                  ROLLBACK;
                  RETURN;
                END IF;
              END;

      END LOOP;

  COMMIT;
  */
  PLOG.DEBUG(PKGCTX, '<<END OF pr_TCDTBANKREQUEST1204');
  PLOG.SETENDSECTION(PKGCTX, 'pr_TCDTBANKREQUEST1204');

EXCEPTION
  WHEN OTHERS THEN
    PLOG.ERROR(PKGCTX, SQLERRM|| dbms_utility.format_error_backtrace);
    PLOG.SETENDSECTION(PKGCTX, 'pr_TCDTBANKREQUEST1204');
END PR_TCDTBANKREQUEST1204;
-- end

PROCEDURE pr_TCDTRECEIVEREQUEST1141(p_AUTOID IN varchar,p_err_code  OUT varchar2)
  IS
  v_strCURRDATE DATE;
  v_strDATEFEE DATE;
  v_strCOMPANYCD varchar2(10);
  v_Result  number(20);
  l_txmsg               tx.msg_rectype;
  v_errcode NUMBER;
  l_err_param varchar2(300);
  v_POTXNUM varchar2(20);
  v_strAutoID varchar2(100);

  v_count number;
  v_afacctno varchar2(10);
  l_bankid varchar2(100);
  l_glmast varchar2(100);
  --1.8.2.1: chuyen tien lien ngan hang
  v_custodycd tcdtreceiverequest.transactiondescription%TYPE;
  v_fullname tcdtreceiverequest.transactiondescription%TYPE;
  v_subtran tcdtreceiverequest.transactiondescription%TYPE;
  v_count_check NUMBER;

BEGIN
    plog.setbeginsection (pkgctx, 'pr_TCDTRECEIVEREQUEST1141');
    plog.debug (pkgctx, '<<BEGIN OF pr_TCDTRECEIVEREQUEST1141');
    p_err_code:= systemnums.C_SUCCESS;
    --GET TDMAST ATRIBUTES
    SELECT TO_DATE(VARVALUE,'DD/MM/YYYY') into v_strCURRDATE FROM SYSVAR  WHERE VARNAME='CURRDATE';
    SELECT VARVALUE || '%' into v_strCOMPANYCD FROM SYSVAR  WHERE VARNAME='COMPANYCD';

    SELECT TO_DATE(VARVALUE,'DD/MM/YYYY') into v_strCURRDATE FROM SYSVAR  WHERE VARNAME='CURRDATE';


FOR recCRB in (select * from tcdtreceiverequest where status = 'N' )
loop

    plog.debug (pkgctx, '<<BEGIN OF pr_TCDTRECEIVEREQUEST1141_ IN LOOP recCRB');
    v_afacctno:='ZZ';
    --1.8.2.1: KH chuyen tien lien ngan hang toi TK tong KBSV
    v_custodycd:=REPLACE(recCRB.KEYACCT1,'K','C');
    v_fullname:=recCRB.Keyacct2;

    SELECT COUNT(1) INTO v_count_check FROM (SELECT v_custodycd TEXT FROM dual) WHERE REGEXP_LIKE(TEXT, '(091)(C|c|f|F)([0-9]{6})');

    IF v_count_check = 0 AND length(v_custodycd) <> 10 THEN

      SELECT COUNT(1) INTO v_count_check
        FROM (SELECT recCRB.Transactiondescription TEXT FROM dual)
       WHERE REGEXP_LIKE(TEXT, '^.*( )*(091)(C|c|f|F)([a-zA-Z0-9]{2})([0-9]{4})( )*.*$');

       IF v_count_check <> 0 THEN
          --v_subtran:=REGEXP_SUBSTR(recCRB.Transactiondescription, '\.( )*(091)(C|c|f|F)([0-9]{6})( )*,.*-');
          v_custodycd:= upper(REGEXP_SUBSTR(recCRB.Transactiondescription, '(091)(C|c|f|F)([a-zA-Z0-9]{2})([0-9]{4})'));
         -- v_fullname:= TRIM(REGEXP_REPLACE(REGEXP_SUBSTR(v_subtran, ',.*-'), '^,|-$', ''));
         -- iss: 2487 voi chuyen tien lien ngan hang: dien giai tra ra chi dam bao co so tai khoan
         BEGIN
            SELECT UPPER(fn_BanhGW_convert_to_vn(FullName)) INTO v_fullname FROM cfmast WHERE custodycd=v_custodycd;
         EXCEPTION WHEN OTHERS THEN
            v_fullname:=recCRB.Keyacct2;
         END;
       END IF;

    END IF;
    --2021.01.0.02:iss:2618: neu trong dien giai co tieu khoan - hach toan tieu khoan do
    FOR rec IN (
      SELECT cf.custodycd||aft.prodtype AFACCTNO, af.acctno FROM afmast af, cfmast cf, aftype aft
      WHERE af.custid = cf.custid
        AND cf.custodycd = v_custodycd
        AND af.status = 'A'
        AND af.corebank <> 'Y'
        AND af.actype = aft.actype
        ORDER BY af.acctno DESC
      )
      LOOP
        IF instr(UPPER(recCRB.Transactiondescription),rec.AFACCTNO) > 0 THEN
          v_afacctno := rec.acctno;
        END IF;
        EXIT WHEN v_afacctno <> 'ZZ';
      END LOOP;
   --

    IF v_afacctno ='ZZ' THEN
    --uu tien chuyen tien vao tai khoan margin, neu khong co thi chuyen vao tai khoan thuong
      For vc in(
                    select NVL(min(af.acctno),'ZZ')  afacctno
                    from cfmast cf, afmast af, aftype aft, mrtype mrt
                    where cf.custid = af.custid and af.actype = aft.actype
                    and af.status = 'A'
                    and aft.mrtype = mrt.actype and mrt.mrtype = 'T'
                    and af.corebank<>'Y'
                    --1.8.2.1: KH chuyen tien lien ngan hang toi TK tong KBSV
                    AND  CF.CUSTODYCD =  v_custodycd
                    AND  UPPER(fn_BanhGW_convert_to_vn(cf.FullName)) = v_fullname

                    )
      Loop
            v_afacctno:=vc.afacctno;
      End loop;
        -- ko co tk MR thi tim tk bat ky
       IF   v_afacctno ='ZZ' then
          For vc in(
                      select NVL(min(af.acctno),'ZZ') afacctno
                      from cfmast cf, afmast af
                      where cf.custid = af.custid  and af.status = 'A' and af.corebank<>'Y'
                      --1.8.2.1: KH chuyen tien lien ngan hang toi TK tong KBSV
                      AND CF.CUSTODYCD = v_custodycd
                      AND UPPER(fn_BanhGW_convert_to_vn(cf.FullName))= v_fullname
                   )
          Loop
              v_afacctno:=vc.afacctno;
          End loop;
       End if;
     END IF;
    --
    IF v_afacctno<>'ZZ' then

            For rec in (
                        SELECT
                         cr.autoid, CF.CUSTODYCD, AF.ACCTNO AFACCTNO, CF.FULLNAME, CF.MNEMONIC, CF.ADDRESS, CF.IDCODE, CF.IDDATE, CF.IDPLACE,
                            fn_gettcdtdesbankacc(substr(AF.ACCTNO,1,4)) BANKACC,
                            fn_gettcdtdesbankname(substr(AF.ACCTNO,1,4)) BANKNAME,
                            fn_gettcdtdesbankname(substr(AF.ACCTNO,1,4)) BANKACCNAME,
                            CR.AMOUNT, CR.TRNREF REFNUM, CR.TRANSACTIONDESCRIPTION,
                            cr.desbankaccount
                        FROM tcdtreceiverequest CR, CFMAST CF, AFMAST AF
                        WHERE  CR.AUTOID = recCRB.AUTOID
                            AND CF.CUSTID = AF.CUSTID
                            AND AF.STATUS ='A'
                            AND CR.status = 'N'
                             --1.8.2.1: KH chuyen tien lien ngan hang toi TK tong KBSV
                            AND CF.CUSTODYCD = v_custodycd
                            AND UPPER(fn_BanhGW_convert_to_vn(cf.FullName)) = v_fullname
                            AND AF.COREBANK <> 'Y'
                            and af.acctno = v_afacctno
            )
            Loop

                plog.debug (pkgctx, '<<BEGIN OF pr_TCDTRECEIVEREQUEST1141_ IN LOOP rec');


                 BEGIN
                         SELECT b.shortname, b.glaccount INTO l_bankid, l_glmast FROM banknostro b where b.bankacctno = rec.desbankaccount;
                 EXCEPTION WHEN OTHERS THEN
                            update tcdtreceiverequest set status = 'E' , errordesc = 'Khong tim thay banknostro' where autoid = recCRB.AUTOID;
                            exit;
                 END;




                update tcdtreceiverequest set status = 'C' where autoid = recCRB.AUTOID;

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
                l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
                l_txmsg.busdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
                l_txmsg.tltxcd:='1141';

                --Set txnum
                SELECT systemnums.C_BATCH_PREFIXED
                                 || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                          INTO l_txmsg.txnum
                          FROM DUAL;
                l_txmsg.brid        := substr(REC.afacctno,1,4);


              --Set cac field giao dich

                --82  CUSTODYCD   C
                l_txmsg.txfields ('82').defname   := 'CUSTODYCD';
                l_txmsg.txfields ('82').TYPE      := 'C';
                l_txmsg.txfields ('82').VALUE     := rec.CUSTODYCD;

                --00  AUTOID      C
                l_txmsg.txfields ('00').defname   := 'AUTOID';
                l_txmsg.txfields ('00').TYPE      := 'C';
                l_txmsg.txfields ('00').VALUE     := rec.AUTOID;

                --03  ACCTNO      C
                l_txmsg.txfields ('03').defname   := 'ACCTNO';
                l_txmsg.txfields ('03').TYPE      := 'C';
                l_txmsg.txfields ('03').VALUE     := rec.AFACCTNO;

                --90  CUSTNAME    C
                l_txmsg.txfields ('90').defname   := 'CUSTNAME';
                l_txmsg.txfields ('90').TYPE      := 'C';
                l_txmsg.txfields ('90').VALUE     := rec.FULLNAME;

                --91  ADDRESS     C
                l_txmsg.txfields ('91').defname   := 'ADDRESS';
                l_txmsg.txfields ('91').TYPE      := 'C';
                l_txmsg.txfields ('91').VALUE     := rec.ADDRESS;

                --92  LICENSE     C
                l_txmsg.txfields ('92').defname   := 'LICENSE';
                l_txmsg.txfields ('92').TYPE      := 'C';
                l_txmsg.txfields ('92').VALUE     := rec.IDCODE;

                --93  IDDATE      C
                l_txmsg.txfields ('93').defname   := 'IDDATE';
                l_txmsg.txfields ('93').TYPE      := 'C';
                l_txmsg.txfields ('93').VALUE     := rec.IDDATE;

                --94  IDPLACE     C
                l_txmsg.txfields ('94').defname   := 'IDPLACE';
                l_txmsg.txfields ('94').TYPE      := 'C';
                l_txmsg.txfields ('94').VALUE     := rec.IDPLACE;

                --02  BANKID      C
                l_txmsg.txfields ('02').defname   := 'BANKID';
                l_txmsg.txfields ('02').TYPE      := 'C';
                l_txmsg.txfields ('02').VALUE     := l_bankid;

                --05  BANKACCTNO  C
                l_txmsg.txfields ('05').defname   := 'BANKACCTNO';
                l_txmsg.txfields ('05').TYPE      := 'C';
                l_txmsg.txfields ('05').VALUE     := rec.BANKACC;

                --06  GLMAST      C
                l_txmsg.txfields ('06').defname   := 'GLMAST';
                l_txmsg.txfields ('06').TYPE      := 'C';
                l_txmsg.txfields ('06').VALUE     := l_glmast;

                --10  AMT         N
                l_txmsg.txfields ('10').defname   := 'AMT';
                l_txmsg.txfields ('10').TYPE      := 'N';
                l_txmsg.txfields ('10').VALUE     := rec.AMOUNT;

                --31  REFNUM      C
                l_txmsg.txfields ('31').defname   := 'REFNUM';
                l_txmsg.txfields ('31').TYPE      := 'C';
                l_txmsg.txfields ('31').VALUE     := rec.REFNUM;

                --30  DESC        C
                l_txmsg.txfields ('30').defname   := 'DESC';
                l_txmsg.txfields ('30').TYPE      := 'C';
                l_txmsg.txfields ('30').VALUE     := rec.TRANSACTIONDESCRIPTION;

                plog.debug (pkgctx, '<<BEGIN OF pr_TCDTRECEIVEREQUEST1141_ CAll 1141 ' || recCRB.AUTOID);

                BEGIN
                    IF txpks_#1141.fn_autotxprocess (l_txmsg,
                                                     v_errcode,
                                                     l_err_param
                       ) <> systemnums.c_success
                    THEN
                       plog.debug (pkgctx,
                                   'got error 1141: ' || v_errcode
                       );
                       p_err_code:= v_errcode;
                       update tcdtreceiverequest set status = 'E' , errordesc = v_errcode where autoid = recCRB.AUTOID;
                    END IF;
                END;

                EXIT;

            end loop;
    Else ---v_afacctno<>'ZZ'
        update tcdtreceiverequest set status = 'E' , errordesc = 'Khong tim thay TK' where autoid = recCRB.AUTOID;
    END IF;
 End loop;
    Commit;
    plog.debug (pkgctx, '<<END OF pr_TCDTRECEIVEREQUEST1141');
    plog.setendsection (pkgctx, 'pr_TCDTRECEIVEREQUEST1141');

EXCEPTION
WHEN OTHERS
   THEN
      plog.error (pkgctx, SQLERRM|| dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_TCDTRECEIVEREQUEST1141');
END pr_TCDTRECEIVEREQUEST1141;

--begin chaunh
PROCEDURE pr_C2BRETURNMONEY
    IS
      -- Enter the procedure variables here. As shown below
      v_errcode NUMBER;
      --V_COUNT number;

      ---------------------
      v_status varchar(3);
      v_errmsg varchar(250);
      v_strbatchid  varchar(23);
      v_strTRANSACTIONID  varchar(23);
      V_COUNT number;
      v_strRemark VARCHAR2(500);

      l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      l_err_param varchar2(300);
      v_strbankacctno varchar2(300);
      v_fullnameBank varchar2(300);
      v_GLmap varchar2(300);
      v_BANKACCNAME varchar2(300);
      v_POTXNUM varchar2(100);
      v_strREFID varchar2(100);
      v_strAutoID varchar2(100);
      v_strBANKID varchar2(100);
      v_strHOSTSTATUS varchar2(100);


   BEGIN
   /*Select varvalue into v_strBANKID from sysvar where GRNAME='BANKGW' and VARNAME ='DEFAULTBANKID' ;*/ --Comment by ManhTV
   Select varvalue into v_strHOSTSTATUS from sysvar where varname ='HOSTATUS';

   V_COUNT:=0;

   Select 'BI' || to_char(sysdate,'yyyyMMddhhMMssSSS') into v_strbatchid from dual;
   /*Select bankacctno,fullname,glaccount,ownername INTO v_strbankacctno,v_fullnameBank,v_GLmap,v_BANKACCNAME from banknostro where shortname=v_strBANKID;*/

   FOR rec IN
       (    SELECT GWU.status, GWU.REFID REFID,FN_GET_LOCATION(af.brid) LOCATION, SUBSTR(af.brid,1,4) BRID, CF.FULLNAME,T1.TLNAME MAKER,T2.TLNAME OFFICER,
                   CF.CUSTODYCD , CD1.CDCONTENT DESC_IDTYPE, CF.IDCODE,
                   AF.ACCTNO ,CF.CUSTID, RM.TXDATE, RM.TXNUM, RM.BANKID,RM.BENEFBANK,RM.CITYEF,RM.CITYBANK,
                   RM.BENEFACCT, RM.BENEFCUSTNAME, RM.BENEFLICENSE, RM.BENEFIDDATE, RM.BENEFIDPLACE, RM.AMT, RM.FEEAMT,AF.ACCTNO || ' : ' ||TL.TXDESC DESCRIPTION,
                   RM.FEETYPE,CF.IDDATE,CF.IDPLACE,CF.ADDRESS,A1.CDCONTENT FEENAME,  '' GLACCTNO,  '' POTXNUM, '' POTXDATE, '' BANKNAME, '' BANKACC, '001' POTYPE,
                   GWP.ACCTNOSUM
               FROM CIREMITTANCE RM, AFMAST AF, CFMAST CF, ALLCODE A1,  ALLCODE CD1,(SELECT TLID, TLNAME FROM TLPROFILES UNION ALL SELECT '____' TLID, '____' TLNAME FROM DUAL) T1,
               (SELECT TLID, TLNAME FROM TLPROFILES UNION ALL SELECT '____' TLID, '____' TLNAME FROM DUAL) T2,
               (SELECT * FROM TLLOG WHERE TLTXCD in('1101','1108','1111','1185') AND TXSTATUS='1') TL , gw_putbatchtrans GWP , gw_updatetrans GWU
               WHERE CF.CUSTID=AF.CUSTID AND RM.ACCTNO=AF.ACCTNO AND RM.DELTD='N' AND RM.RMSTATUS='W' AND TL.TXNUM=RM.TXNUM AND TL.TXDATE=RM.TXDATE
               AND CD1.CDTYPE='CF' AND CD1.CDNAME='IDTYPE' AND CD1.CDVAL=CF.IDTYPE
               AND A1.CDTYPE='SA' AND A1.CDNAME='IOROFEE' AND A1.CDVAL=NVL(RM.FEETYPE,'0')
               AND (CASE WHEN TL.TLID IS NULL THEN '____' ELSE TL.TLID END)=T1.TLID
               AND (CASE WHEN TL.OFFID IS NULL THEN '____' ELSE TL.OFFID END)=T2.TLID AND  0 = 0
               AND RM.TXNUM =  GWP.TXNUM and RM.TXDATE = GWP.TXDATE
               AND GWP.transactionid = GWU.REFID
               AND GWP.direction ='C2B'
               AND GWU.direction='B2C'
               AND GWU.functionname='UPDATETRANS'
               --AND GWU.status =0
               and GWU.PROCESS='N'
       )
       LOOP
      ------------------------------------------------------


   v_strREFID := REC.REFID;

    if v_strHOSTSTATUS ='0' then
                return ;
     end if ;
  /*Add by ManhTV*/
   SELECT bankacctno,fullname,glaccount,ownername INTO v_strbankacctno,v_fullnameBank,v_GLmap,v_BANKACCNAME
        FROM banknostro WHERE bankacctno = rec.acctnosum;
  /*End Add*/
   if Rec.STATUS <>'0' then
   -- Neu ngan gang bao co loi
        UPDATE GW_UPDATETRANS SET PROCESS ='Y' WHERE  RQSSRC='MSB' AND DIRECTION='B2C' AND FUNCTIONNAME='UPDATETRANS' AND   REFID = V_STRREFID;
        UPDATE GW_PUTBATCHTRANS SET STATUS ='E' , errnum =Rec.status  WHERE FUNCTIONNAME ='PUTBATCH' AND DIRECTION ='C2B' AND TRANSACTIONID= V_STRREFID;
        Update CIREMITTANCE CI Set rmstatus='E' where CI.txnum=Rec.txnum and Ci.Txdate =rec.txdate;
        COMMIT;
        return;
   end if ;

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
    l_txmsg.batchname   := 'INT';
    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd:='1104';

    --Set txnum
    SELECT systemnums.C_BATCH_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO l_txmsg.txnum
              FROM DUAL;
    l_txmsg.brid        := substr(REC.ACCTNO,1,4);

   -- p_txnum:=l_txmsg.txnum;
   -- p_txdate:=l_txmsg.txdate;

  --Set cac field giao dich
    --03   ACCTNO          C
    l_txmsg.txfields ('03').defname   := 'ACCTNO';
    l_txmsg.txfields ('03').TYPE      := 'C';
    l_txmsg.txfields ('03').VALUE     := REC.ACCTNO;
     --91   ADDRESS         C
    l_txmsg.txfields ('91').defname   := 'ADDRESS';
    l_txmsg.txfields ('91').TYPE      := 'C';
    l_txmsg.txfields ('91').VALUE     :=  REC.ADDRESS;
     --90   CUSTNAME        C
    l_txmsg.txfields ('90').defname   := 'CUSTNAME';
    l_txmsg.txfields ('90').TYPE      := 'C';
    l_txmsg.txfields ('90').VALUE     :=REC.FULLNAME;
     --04   ACCTNO          C
    l_txmsg.txfields ('04').defname   := 'CUSTODYCD';
    l_txmsg.txfields ('04').TYPE      := 'C';
    l_txmsg.txfields ('04').VALUE     := REC.CUSTODYCD;
     --03   ACCTNO          C
    l_txmsg.txfields ('92').defname   := 'LICENSE';
    l_txmsg.txfields ('92').TYPE      := 'C';
    l_txmsg.txfields ('92').VALUE     := REC.IDCODE;
        --03   ACCTNO          C
    l_txmsg.txfields ('67').defname   := 'IDDATE';
    l_txmsg.txfields ('67').TYPE      := 'C';
    l_txmsg.txfields ('67').VALUE     := REC.IDDATE;

    --02   BANKID          C
    l_txmsg.txfields ('06').defname   := 'TXDATE';
    l_txmsg.txfields ('06').TYPE      := 'D';
    l_txmsg.txfields ('06').VALUE     := REC.TXDATE;

    --07   BANKID          C
    l_txmsg.txfields ('07').defname   := 'TXNUM';
    l_txmsg.txfields ('07').TYPE      := 'C';
    l_txmsg.txfields ('07').VALUE     := REC.TXNUM;

    --06   GLMAST          C
    l_txmsg.txfields ('81').defname   := 'BENEFACCT';
    l_txmsg.txfields ('81').TYPE      := 'C';
    l_txmsg.txfields ('81').VALUE     := REC.BENEFACCT;

    --10   AMT          N
    l_txmsg.txfields ('05').defname   := 'BANKID';
    l_txmsg.txfields ('05').TYPE      := 'C';
    l_txmsg.txfields ('05').VALUE     := REC.BANKID;

    --30   DESC            C
    l_txmsg.txfields ('10').defname   := 'AMT';
    l_txmsg.txfields ('10').TYPE      := 'N';
    l_txmsg.txfields ('10').VALUE     :=REC.AMT;


    --82   CUSTODYCD   C
    l_txmsg.txfields ('32').defname   := 'CITYBANK';
    l_txmsg.txfields ('32').TYPE      := 'C';
    l_txmsg.txfields ('32').VALUE     := REC.CITYBANK;



    --92   LICENSE         C
    l_txmsg.txfields ('33').defname   := 'CITYEF';
    l_txmsg.txfields ('33').TYPE      := 'C';
    l_txmsg.txfields ('33').VALUE     :=REC.CITYEF;
    --93   IDDATE          C
    l_txmsg.txfields ('80').defname   := 'BENEFBANK';
    l_txmsg.txfields ('80').TYPE      := 'C';
    l_txmsg.txfields ('80').VALUE     :=REC.BENEFBANK;
    --94   IDPLACE         C
    l_txmsg.txfields ('30').defname   := 'DESC';
    l_txmsg.txfields ('30').TYPE      := 'C';
    l_txmsg.txfields ('30').VALUE     :=REC.DESCRIPTION;
      --94   IDPLACE         C
    l_txmsg.txfields ('82').defname   := 'BENEFCUSTNAME';
    l_txmsg.txfields ('82').TYPE      := 'C';
    l_txmsg.txfields ('82').VALUE     :=REC.BENEFCUSTNAME;
      --94   IDPLACE         C
    l_txmsg.txfields ('83').defname   := 'RECEIVLICENSE';
    l_txmsg.txfields ('83').TYPE      := 'C';
    l_txmsg.txfields ('83').VALUE     :='';
      --94   IDPLACE         C
    l_txmsg.txfields ('95').defname   := 'RECEIVIDDATE';
    l_txmsg.txfields ('95').TYPE      := 'C';
    l_txmsg.txfields ('95').VALUE :='';

        --94   IDPLACE         C
    l_txmsg.txfields ('96').defname   := 'RECEIVIDPLACE';
    l_txmsg.txfields ('96').TYPE      := 'C';
    l_txmsg.txfields ('96').VALUE :='';
      --94   IDPLACE         C
    l_txmsg.txfields ('98').defname   := 'POTXDATE';
    l_txmsg.txfields ('98').TYPE      := 'C';
    l_txmsg.txfields ('98').VALUE     := REC.TXDATE;
      --94   IDPLACE         C
    l_txmsg.txfields ('08').defname   := 'BANKACC';
    l_txmsg.txfields ('08').TYPE      := 'C';
    l_txmsg.txfields ('08').VALUE :=v_strbankacctno;
      --94   IDPLACE         C
    l_txmsg.txfields ('09').defname   := 'IORO';
    l_txmsg.txfields ('09').TYPE      := 'C';
    l_txmsg.txfields ('09').VALUE     :=REC.FEETYPE;

            --94   IDPLACE         C
    l_txmsg.txfields ('15').defname   := 'GLMAST';
    l_txmsg.txfields ('15').TYPE      := 'C';
    l_txmsg.txfields ('15').VALUE     :=v_GLmap;
      --94   IDPLACE         C
    l_txmsg.txfields ('85').defname   := 'BANKNAME';
    l_txmsg.txfields ('85').TYPE      := 'C';
    l_txmsg.txfields ('85').VALUE     :=v_fullnameBank;
      --94   IDPLACE         C

      SELECT NVL(MAX(ODR)+1,1) INTO v_strAutoID  FROM
                  (SELECT ROWNUM ODR, INVACCT
                  FROM (SELECT TXNUM INVACCT FROM POMAST WHERE BRID = REC.BRID ORDER BY TXNUM) DAT
                  ) INVTAB;

    v_POTXNUM := REC.BRID || LPAD(v_strAutoID,6,'0');

    l_txmsg.txfields ('99').defname   := 'POTXNUM';
    l_txmsg.txfields ('99').TYPE      := 'C';
    l_txmsg.txfields ('99').VALUE     := v_POTXNUM;
      --94   IDPLACE         C
    l_txmsg.txfields ('86').defname   := 'BANKACCNAME';
    l_txmsg.txfields ('86').TYPE      := 'C';
    l_txmsg.txfields ('86').VALUE :=  v_BANKACCNAME;
       --94   IDPLACE         C
    l_txmsg.txfields ('17').defname   := 'POTYPE';
    l_txmsg.txfields ('17').TYPE      := 'C';
    l_txmsg.txfields ('17').VALUE :=REC.POTYPE;
    BEGIN
        IF txpks_#1104.fn_autotxprocess (l_txmsg,
                                         v_errcode,
                                         l_err_param
           ) <> systemnums.c_success
        THEN
           plog.debug (pkgctx,
                       'got error 1104: ' || v_errcode
           );
           ROLLBACK;
           RETURN;
        END IF;
    END;
    v_errcode:=0;
    plog.setendsection(pkgctx, 'pr_Complete_PutbatchC2B');
      -----------------END-----------------------------------
        UPDATE GW_UPDATETRANS SET PROCESS ='Y' WHERE  RQSSRC='MSB' AND DIRECTION='B2C' AND FUNCTIONNAME='UPDATETRANS' AND   REFID = V_STRREFID;
        UPDATE GW_PUTBATCHTRANS SET STATUS ='C' WHERE FUNCTIONNAME ='PUTBATCH' AND DIRECTION ='C2B' AND TRANSACTIONID= V_STRREFID;
        COMMIT;
    END LOOP;


   EXCEPTION
      WHEN errnums.E_BIZ_RULE_INVALID THEN

        UPDATE GW_UPDATETRANS SET PROCESS ='Y' WHERE  RQSSRC='MSB' AND DIRECTION='B2C' AND FUNCTIONNAME='UPDATETRANS' AND   REFID = V_STRREFID;
        UPDATE GW_PUTBATCHTRANS SET STATUS ='E' WHERE FUNCTIONNAME ='PUTBATCH' AND DIRECTION ='C2B' AND TRANSACTIONID= V_STRREFID;
        COMMIT;

      WHEN OTHERS THEN

        UPDATE GW_UPDATETRANS SET PROCESS ='Y' WHERE  RQSSRC='MSB' AND DIRECTION='B2C' AND FUNCTIONNAME='UPDATETRANS' AND   REFID = V_STRREFID;
        UPDATE GW_PUTBATCHTRANS SET STATUS ='E' WHERE FUNCTIONNAME ='PUTBATCH' AND DIRECTION ='C2B' AND TRANSACTIONID= V_STRREFID;
        COMMIT;
        v_errmsg:= SQLERRM;
       Null;
   END;
--end chaunh


--dang ky
PROCEDURE pr_genbankrequest(pv_err_code in out varchar2, pv_autoid in varchar2 )
is
    v_cusname varchar2(100);
    v_batchid varchar2(23);
    v_idcode varchar2(50);
    v_custodycd varchar2(10);
    v_count number;
    v_TRANSACTIONID varchar2(23);
    v_countautoid number;
begin
    --kiem tra tai khoan co tai khoan tien khong, tai khoan co hoat dong khong
    select count(1) into v_count from cimast ci, msbbankrequest m where ci.acctno = m.cusacctno and m.autoid = to_number(pv_autoid) and ci.status = 'A';
    if v_count< 1 then
        pv_err_code:= -100102 ; --tieu khoan tien khong ton tai
        return;
    end if;
    --end
    --kiem tra xem da co trong log chua ?
    select count(1) into v_countautoid from msbbankrequest_log where refautoid =to_number(pv_autoid);
    --neu chua co: tao moi
    if v_countautoid = 0 then
        --moi lan chi chuyen 1 tai khoan sang MSB
        v_batchid:= 'BR' || to_char(sysdate,'yyyyMMddhhMMssSSS');
        v_count:=0;
        /*select count(1) into v_count from MSBBANKREQUEST_LOG where batchid=v_batchid;*/
        v_TRANSACTIONID := v_batchid || lpad(to_char(v_count + 1),4,'0');
        insert into MSBBANKREQUEST_LOG ( AUTOID ,
        REFAUTOID,
        BATCHID,
        TRANSACTIONID,
        STATUS , --P: cho duyet, A: duyet, C: da gui sang ngan hang, R: huy
        BANK_STATUS , --W: cho gui, S: da gui, A: thanh cong, R: huy, E: loi
        CREATEDATE ,
        CUSTODYCD,
        CUSACCTNO ,
        cusname,
        cusidcode,
        BANKACCTNO ,
        BANKID     ,
        BANKORGNO  )
        select seq_msbbankrequest_log.nextval,
                to_number(pv_autoid),
                v_batchid,
                v_TRANSACTIONID,
                'A',
                'W',
                to_date(getcurrdate,'DD/MM/RRRR'),
                cf.custodycd,
                af.acctno,
                fn_BanhGW_convert_to_vn(nvl(cf.fullname, cf.shortname)),
                cf.idcode,
                r.bankacctno,
                r.bankid,
                r.bankorgno
        FROM msbbankrequest r, cfmast cf, afmast af WHERE AUTOID = pv_autoid and af.custid = cf.custid and af.acctno = r.cusacctno;
        pv_err_code:= 0;
    else -- neu da co trong log: update trang thai
        update msbbankrequest_log set bank_status = 'W', status = 'A' where refautoid = to_number(pv_autoid);
        pv_err_code:= 0;
    end if;
exception when others then
    pv_err_code:= -1;
end;

--huy dang ky
PROCEDURE PR_DELETEBANKREQUEST(pv_err_code in out varchar2, pv_autoid in varchar2 )
is
    v_count number;
    v_status varchar2(1);
begin
    delete msbbankrequest_hist where autoid = to_number(pv_autoid);
    --chi luu log lai tieu khoan dang ky gan nhat
    delete msbbankrequest_hist where cusacctno in (select cusacctno from msbbankrequest where autoid = to_number(pv_autoid));
    --ghi vao hist
    select count(1) into v_count from msbbankrequest_log where refautoid = to_number(pv_autoid);
    if v_count <> 0 then
        /*select bank_status into v_status from msbbankrequest_log where autoid = 'pv_autoid';
        if bank*/
         insert into MSBBANKREQUEST_hist
         select autoid, 'R',pstatus||'A', createdate, activedate, sysdate, cusacctno, bankacctno, bankid, bankorgno
         from msbbankrequest where autoid = to_number(pv_autoid);
         --update trang thai log
            --neu chua gui, hoac dang ky khong thanh cong thi dat trang thai bank_staus = 'R' tu choi
            --neu da gui, hoac dang ky thanh cong thi dat trang thai bank_status = W va trang thai status = 'R'
         update msbbankrequest_log set status = 'R',  bank_status = 'R'
         where refautoid = to_number(pv_autoid) and bank_status in ('W','E');
         update msbbankrequest_log set status = 'R' , bank_status  = 'W'
         where refautoid = to_number(pv_autoid) and bank_status in ('C');
    end if;
    pv_err_code:= 0;
exception when others then
    pv_err_code:= -1;
end;

--xu ly message loi do msb tra ve
PROCEDURE PR_MSBUPDATESTATUS(pv_err_code in varchar2, pv_batchid in varchar2 )
is
    v_count number;
    v_status varchar2(1);
    v_autoid varchar2(10);
begin
   --truong hop ngan hang tra ve ma loi
   --chi can update lai trang thai ngan hang cho duyet
   if pv_err_code <> 3 then
    update msbbankrequest_log set bank_status = 'E', status = 'P', errnum = to_number(pv_err_code) where batchid = pv_batchid;
    update msbbankrequest set status = 'P', pstatus = pstatus || 'A' where autoid in (select refautoid from msbbankrequest_log where batchid = pv_batchid);
   else --neu ma loi = 3: da co tai khoan nay trong ngan hang thi coi nhu gui dang ky thang cong.
    update msbbankrequest_log set bank_status = 'C', errnum = to_number(pv_err_code) where batchid = pv_batchid;
   end if;

end;

END;
/
