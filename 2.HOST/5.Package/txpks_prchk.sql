CREATE OR REPLACE PACKAGE txpks_prchk
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


  FUNCTION fn_AutoPRTxProcess(p_txmsg in out tx.msg_rectype,p_err_code in out varchar2,p_err_param out varchar2)
  RETURN NUMBER;

  FUNCTION fn_prAutoCheck(p_xmlmsg IN OUT varchar2,p_err_code in out varchar2,p_err_param out varchar2)
  RETURN NUMBER;

  FUNCTION fn_prAutoUpdate(p_xmlmsg IN OUT varchar2,p_err_code in out varchar2,p_err_param out varchar2)
  RETURN NUMBER;

  FUNCTION fn_txAutoCheck(p_txmsg in  tx.msg_rectype, p_err_code out varchar2)
  RETURN NUMBER;

  FUNCTION fn_txAutoUpdate(p_txmsg in  tx.msg_rectype, p_err_code out varchar2)
  RETURN NUMBER;

  FUNCTION fn_txAdhocCheck(p_id IN VARCHAR2,
              p_acctno IN VARCHAR2, p_codeid IN VARCHAR2,
              p_refid IN VARCHAR2,
              p_qtty IN NUMBER, p_amt IN NUMBER,
              p_brid IN VARCHAR2,
              p_type in VARCHAR2, p_actype IN VARCHAR2,
              p_txnum IN VARCHAR2, p_txdate IN DATE,
              p_deltd IN VARCHAR2,
              p_err_code out varchar2)
  RETURN NUMBER;

  FUNCTION fn_txAdhocUpdate(p_id IN VARCHAR2,
              p_acctno IN VARCHAR2, p_codeid IN VARCHAR2,
              p_refid IN VARCHAR2,
              p_qtty IN NUMBER, p_amt IN NUMBER,
              p_brid IN VARCHAR2,
              p_type IN VARCHAR2, p_actype IN VARCHAR2,
              p_txnum IN VARCHAR2, p_txdate IN DATE,
              p_deltd IN VARCHAR2,
              p_err_code out varchar2)
  RETURN NUMBER;

  FUNCTION fn_getExpectUsed(p_PrCode VARCHAR2) RETURN number;

  FUNCTION fn_SecuredUpdate(p_dorc varchar2, p_amount NUMBER, p_acctno VARCHAR2, p_txnum varchar2, p_txdate date,
                  p_err_code OUT VARCHAR2)
  RETURN NUMBER;
  FUNCTION fn_AfRoomLimitCheck(p_afacctno in varchar2, p_codeid in varchar2, p_qtty in NUMBER, p_err_code in out varchar2)
  RETURN number;
  FUNCTION fn_ResetPool(p_err_code in out varchar2)
  RETURN NUMBER;
END;
/

CREATE OR REPLACE PACKAGE BODY txpks_prchk
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;
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

FUNCTION fn_getVal(p_amtexp IN varchar2)
RETURN FLOAT
IS
    l_sql varchar2(500);
    CUR             PKG_REPORT.REF_CURSOR;
    l_EntryAmount FLOAT;
BEGIN
    l_sql := 'select ' || p_amtexp || ' from dual';
    OPEN CUR FOR l_sql;
       LOOP
       FETCH CUR INTO l_EntryAmount ;
       EXIT WHEN CUR%NOTFOUND;
       END LOOP;
       CLOSE CUR;
    RETURN l_EntryAmount;
END fn_getVal;


FUNCTION fn_BuildAMTEXP(p_txmsg IN tx.msg_rectype,p_amtexp IN varchar2)
RETURN VARCHAR2
IS
  l_Evaluator varchar2(100);
  l_Elemenent  varchar2(20);
  l_Index number(10,0);
  l_ChildValue varchar2(100);
BEGIN
   plog.setbeginsection (pkgctx, 'fn_BuildAMTEXP');
    l_Evaluator:= '';
    l_Index:= 1;
    While l_Index < LENGTH(p_amtexp) loop
        --Get 02 charatacters in AMTEXP
        l_Elemenent := substr(p_amtexp, l_Index, 2);
        if l_Elemenent in ( '++', '--', '**', '//', '((', '))') then
                --Operand
                l_Evaluator := l_Evaluator || substr(l_Elemenent,1,1);
        elsif l_Elemenent in ( 'MA') then
                --Operand
                l_Evaluator := 'GREATEST(' || l_Evaluator || ',0)';
        elsif l_Elemenent in ( 'MI') then
                --Operand
                l_Evaluator := 'LEAST(' || l_Evaluator || ',0)';
        else
                --OPERATOR
                l_ChildValue:= p_txmsg.txfields(l_Elemenent).value;
                l_Evaluator := l_Evaluator || l_ChildValue;
        End if;
        l_Index := l_Index + 2;
    end loop;
   plog.setendsection (pkgctx, 'fn_BuildAMTEXP');
   RETURN l_Evaluator;
EXCEPTION
WHEN OTHERS THEN
    plog.error (pkgctx, '[SQLERRM] ' || SQLERRM); --Log trace exception
    plog.error(pkgctx,'row:'||dbms_utility.format_error_backtrace);
    plog.setendsection (pkgctx, 'fn_BuildAMTEXP');
    RETURN '0';
END fn_BuildAMTEXP;


FUNCTION fn_parse_amtexp(p_txmsg IN tx.msg_rectype,p_amtexp IN varchar2)
RETURN FLOAT
IS
    l_value varchar2(100);
BEGIN
    IF length(p_amtexp) > 0 THEN
        IF substr(p_amtexp,0,1) = '@' THEN
            l_value:=replace(p_amtexp,'@');
        ELSIF substr(p_amtexp,0,1) = '$' THEN
            l_value:= replace(p_amtexp,'$');
            l_value:= p_txmsg.txfields(l_value).value;
        ELSE
            l_value:= fn_BuildAMTEXP(p_txmsg,p_amtexp);
            l_value:= fn_getVal(l_value);
        END IF;
    END IF;
    RETURN l_value;
END fn_parse_amtexp;

--Get avl Account PoolLimit khi Poolchk ='N'
FUNCTION fn_getAvlAccountPoolLimit(p_acctno VARCHAR2, p_amount number)
RETURN number
IS
    l_count NUMBER;
    l_amt number;
    l_parameters varchar2(4000);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_getAvlAccountPoolLimit');
    l_parameters:=('p_acctno:' || p_acctno || ' p_amount:' || p_amount);
    select count(1) into l_count
      from cfmast cf, afmast af
      where cf.custid = af.custid
      and af.acctno = p_acctno and cf.custatcom = 'Y'
      and af.poolchk='N'; --GianhVG Chi check neu tai khoan can check pool
    if l_count>0 then
        select count(1) into l_count
            from afmast af, aftype aft, mrtype mrt, lntype lnt
            where af.actype = aft.actype and aft.mrtype = mrt.actype --and mrt.mrtype = 'T'
            and aft.lntype = lnt.actype(+) and af.acctno = p_acctno;
        if l_count>0 then
            select
                 nvl(adv.avladvance,0)
                        + mst.balance
                        + af.poollimit
                        - mst.odamt
                        - mst.dfdebtamt
                        - mst.dfintdebtamt
                        - mst.depofeeamt
                        - NVL (advamt, 0)
                        - nvl(secureamt,0)
                        - ramt
                        - nvl(dealpaidamt,0)
                        - p_amount
                into l_amt
            from cimast mst inner join afmast af on mst.acctno = af.acctno
                left join (select * from v_getbuyorderinfo where afacctno = p_acctno) al on mst.acctno = al.afacctno
                left join (select sum(depoamt) avladvance,afacctno from v_getAccountAvlAdvance where afacctno = p_acctno group by afacctno) adv on adv.afacctno=MST.acctno
                LEFT JOIN (select * from v_getdealpaidbyaccount p where p.afacctno = p_acctno) pd on pd.afacctno=mst.acctno
            where mst.acctno = p_acctno;
            return l_amt;
        end if;

    end if;
    plog.setendsection (pkgctx, 'fn_getAvlAccountPoolLimit');
    RETURN 0;

EXCEPTION WHEN OTHERS THEN
    plog.error (pkgctx, '[Paramters] ' || l_parameters); --Log trace exception
    plog.error (pkgctx, '[SQLERRM] ' || SQLERRM); --Log trace exception
    plog.error(pkgctx,'row:'||dbms_utility.format_error_backtrace);
    plog.setendsection (pkgctx, 'fn_getAvlAccountPoolLimit');
    RETURN 0;
END fn_getAvlAccountPoolLimit;



FUNCTION fn_AfRoomLimitCheck(p_afacctno in varchar2, p_codeid in varchar2, p_qtty in NUMBER, p_err_code in out varchar2)
RETURN NUMBER
IS
l_remainqtty number;
l_remainamt number;
l_basicprice number;
l_mrrate    number;
l_margintype char(1);
l_chksysctrl    char(1);
l_roomchk   char(1);
l_parameters varchar2(4000);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_AfRoomLimitCheck');
    begin
      l_parameters:=('p_afacctno:' || p_afacctno || ' p_codeid:' || p_codeid || ' p_qtty:' || p_qtty);
    exception when others then
      l_parameters:='';
    end;
    p_err_code:=systemnums.c_success;
    begin
    select roomchk into l_roomchk from semast se where afacctno = p_afacctno and codeid = p_codeid;
    exception when others then
        l_roomchk:='Y';
    end;

    if l_roomchk = 'N' then --Check room dac biet
        SELECT mr.mrtype, nvl(lnt.chksysctrl,'N') chksysctrl
            INTO l_margintype, l_chksysctrl
        FROM afmast mst, aftype af, mrtype mr, lntype lnt
        WHERE mst.actype = af.actype
          AND af.mrtype = mr.actype
          and af.lntype = lnt.actype (+)
          AND mst.acctno = p_afacctno;
        if l_margintype in ('S','T')  then
            --Chi check Room he thong voi tai khoan Margin, tai khoan T3 khong check
            select nvl(se.selimit - fn_getUsedSeLimitByGroup(se.autoid),0) into l_remainqtty
                from afselimitgrp af, selimitgrp se
                where af.refautoid = se.autoid
                and af.afacctno = p_afacctno
                and se.codeid = p_codeid;

            if l_remainqtty < p_qtty then
                 p_err_code:='-100524';        --Vuot qua nguon.
                 plog.debug(pkgctx,'PRCHK: [-100524]:Loi vuot qua nguon dac biet cua chung khoan:'||p_err_code);
                 return p_err_code;
            end if;

            plog.setendsection (pkgctx, 'fn_AfRoomLimitCheck');
        end if;
    end if;
    plog.setendsection (pkgctx, 'fn_AfRoomLimitCheck');
    RETURN systemnums.C_SUCCESS;
EXCEPTION when others then
    plog.error(pkgctx,'error:'||p_err_code);
    plog.error (pkgctx, '[l_parameters] ' || l_parameters); --Log trace exception
    plog.error (pkgctx, '[SQLERRM] ' || SQLERRM); --Log trace exception
    plog.error(pkgctx,'row:'||dbms_utility.format_error_backtrace);
    plog.setendsection (pkgctx, 'fn_AfRoomLimitCheck');
    p_err_code:=errnums.c_system_error;
    RETURN errnums.C_BIZ_RULE_INVALID;
END fn_AfRoomLimitCheck;
-- Check this function - IF IS FALSE --> Pool/Room: RETURN SUCCESSFUL!
FUNCTION fn_IsPRCheck(p_txmsg IN tx.msg_rectype, p_acctno VARCHAR2, p_prcode VARCHAR2, p_prtype VARCHAR2, p_actionType VARCHAR2)
RETURN BOOLEAN
IS
    l_count NUMBER;
    l_parameters varchar2(4000);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_IsPRCheck');
    begin
      l_parameters:=('p_acctno:' || p_acctno || ' p_prcode:' || p_prcode || ' p_prtype:' || p_prtype || ' p_actionType:' || p_actionType);
    exception when others then
      l_parameters:='';
    end;
    /*
    ---- CUSTATCOM?
    */
    select count(1) into l_count
    from cfmast cf, afmast af
    where cf.custid = af.custid
    and cf.custatcom = 'Y'
    and af.acctno = substr(p_acctno,0,10);
    if not l_count > 0 then
        RETURN FALSE;
    end if;

    /********************************************************
    -- Khong CHECK voi TK luu ky ben ngoai Cty CK va TK giai ngan.
    ********************************************************/
    SELECT count(1) INTO l_count
    FROM cfmast cf, afmast af
    WHERE af.custid = cf.custid
        AND (substr(cf.custodycd,0,3) = (SELECT varvalue FROM sysvar WHERE varname = 'COMPANYCD' AND grname = 'SYSTEM')
            or substr(cf.custodycd,0,3) = (SELECT varvalue FROM sysvar WHERE varname = 'REPO_PREFIX' AND grname = 'SYSTEM'))
        AND NOT EXISTS (SELECT 1 FROM lntype WHERE ciacctno = af.acctno AND ciacctno IS NOT NULL)
        AND af.acctno = substr(p_acctno, 0, 10);
    IF l_count = 0 THEN
        RETURN FALSE;
    END IF;


    /********************************************************
    -- KHONG check Room voi cac giao dich sau NEU khong phai tai khoan Credit Line.
    ********************************************************/
    -- removed
    /********************************************************
    -- KHONG check Pool voi cac giao dich sau NEU khong phai tai khoan Credit Line.
    ********************************************************/
    IF p_prtype = 'P' AND p_txmsg.tltxcd in ('1107','1108') THEN
        SELECT count(1) INTO l_count
        FROM afmast af, aftype aft, mrtype mrt
        WHERE af.acctno = substr(p_acctno,0,10) -- lay ra so tieu khoan.
        AND aft.actype = af.actype
        AND aft.mrtype = mrt.actype
        AND mrt.mrtype IN ('S','T');

        IF l_count = 0 THEN
            RETURN FALSE;
        END IF;
    END IF;

    /********************************************************
    -- KHONG check Pool voi cac giao dich dat lenh tren TK Margin Loan
    ********************************************************/
    -- removed
    /********************************************************
    -- KHONG check Pool/Room voi giao dich tao deal vay DF tren TK Margin Loan
    ********************************************************/
    IF p_txmsg.tltxcd in ('2670') AND p_actionType = 'C' THEN

        SELECT count(1) INTO l_count
        FROM afmast af, aftype aft, mrtype mrt
        WHERE af.acctno = substr(p_acctno,0,10) -- lay ra so tieu khoan.
        AND aft.actype = af.actype
        AND aft.mrtype = mrt.actype
        AND mrt.mrtype IN ('L');

        IF l_count <> 0 THEN
            RETURN FALSE;
        END IF;
    END IF;
    plog.setendsection (pkgctx, 'fn_IsPRCheck');

    RETURN TRUE;
EXCEPTION WHEN OTHERS THEN
    plog.error (pkgctx, '[l_parameters] ' || l_parameters); --Log trace exception
    plog.error (pkgctx, '[SQLERRM] ' || SQLERRM); --Log trace exception
    plog.error(pkgctx,'row:'||dbms_utility.format_error_backtrace);
    plog.setendsection (pkgctx, 'fn_IsPRCheck');
    RETURN FALSE;
END fn_IsPRCheck;

--Get by Careby Group.
FUNCTION fn_getCurrentPR(p_txmsg IN tx.msg_rectype, p_PrCode IN VARCHAR2, p_PrTyp IN VARCHAR2, p_AfAcctno IN VARCHAR2, p_CodeID IN VARCHAR2)
RETURN number
IS
    l_ExpectUsed number(20,0);
    l_AvlPR number(20,0);
    l_CIAvlAmount number(20,0);
    l_CodeID varchar2(20);
    l_TempValue number(20,0);
    l_parameters varchar2(4000);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_getCurrentPR');
    -- Truong hop: nguon co the khong xai den. DO tai san khach hang du de thuc hien
    begin
       l_parameters:=('p_PrCode:' || p_PrCode || ' p_PrTyp:' || p_PrTyp || ' p_AfAcctno:' || p_AfAcctno || ' p_CodeID:' || p_CodeID);
    exception when others then
      l_parameters:='';
    end;
    select fn_getExpectUsed(p_PrCode) INTO l_ExpectUsed from dual;

    SELECT prlimit - prinused - l_ExpectUsed
        INTO l_AvlPR
    FROM prmaster WHERE prcode = p_PrCode;

    IF p_PrTyp = 'P' THEN
        IF substr(p_txmsg.tltxcd,0,2) IN ('26','77')
            OR p_txmsg.tltxcd IN ('1115','1116') THEN
            -- Giao dich cho vay truc tiep. Khong quan tam den so du khach hang. (26XX: DF; 77XX: Repo)
            l_CIAvlAmount:= 0;
        ELSE
            begin
                SELECT CASE WHEN mrt.mrtype = 'L' THEN 0
                            ELSE GREATEST(ci.balance + nvl(adv.avladvance,0) - nvl(od.secureamt,0) - ci.dfdebtamt - ci.dfintdebtamt - ci.odamt - ci.depofeeamt,0) END
                    INTO l_CIAvlAmount
                FROM cimast ci, afmast af, aftype aft, mrtype mrt,
                    (SELECT afacctno, sum(depoamt) avladvance FROM v_getaccountavladvance WHERE afacctno = p_AfAcctno group BY afacctno) adv,
                    (SELECT afacctno,secureamt FROM v_getbuyorderinfo WHERE afacctno = p_AfAcctno) od
                WHERE ci.afacctno = adv.afacctno(+) AND ci.afacctno = od.afacctno(+)
                    AND ci.afacctno = af.acctno AND aft.actype = af.actype AND aft.mrtype = mrt.actype
                    and ci.afacctno = p_AfAcctno;
            exception when others then
              l_CIAvlAmount:=0;
            end;
        END IF;

        l_AvlPR:=greatest(l_AvlPR + nvl(l_CIAvlAmount,0),l_AvlPR,0);
    ELSIF p_PrTyp = 'R' THEN
        l_AvlPR:=greatest(l_AvlPR,0);
    ELSE
        RETURN 0;
    END IF;
    plog.setendsection (pkgctx, 'fn_getCurrentPR');
    return l_AvlPR;
exception when others then
    plog.error (pkgctx, '[l_parameters] ' || l_parameters); --Log trace exception
    plog.error (pkgctx, '[SQLERRM] ' || SQLERRM); --Log trace exception
    plog.error(pkgctx,'row:'||dbms_utility.format_error_backtrace);
    plog.setendsection (pkgctx, 'fn_getCurrentPR');
    return 0;
END fn_getCurrentPR;


/**
* Cap nhat gia tri nguon du tinh theo xu ly dac biet. Ham goi di theo giao dich.
**/
FUNCTION fn_SecuredUpdate(p_txnum VARCHAR2, p_txdate DATE, p_deltd VARCHAR2,
                p_dorc varchar2, p_amount NUMBER,
                p_acctno VARCHAR2, p_codeid varchar2, p_prtyp VARCHAR2, p_type VARCHAR2, p_actype VARCHAR2, p_brid VARCHAR2, p_refid VARCHAR2,
                p_err_code OUT VARCHAR2)
RETURN NUMBER
IS
l_count NUMBER;
l_parameters varchar2(4000);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_SecuredUpdate');
    begin
      l_parameters:=('p_txnum:' || p_txnum || ' p_txdate:' || p_txdate || ' p_dorc:' || p_dorc || ' p_amount:' || p_amount
                   || 'p_acctno:' || p_acctno || ' p_codeid:' || p_codeid || ' p_prtyp:' || p_prtyp || ' p_type:' || p_type
                   || 'p_actype:' || p_actype || ' p_brid:' || p_brid || ' p_refid:' || p_refid);
    exception when others then
      l_parameters:='';
    end;
    p_err_code:=systemnums.c_success;

    --Kiem tra theo san phan l_actype, l_type, l_brid
    FOR rec IN
    (
        SELECT DISTINCT pm.prcode, pm.prname, pm.prtyp, pm.codeid, pm.prlimit,
                pm.prinused, pm.expireddt, pm.prstatus
        FROM prmaster pm, prtype prt, prtypemap prtm, typeidmap tpm, bridmap brm
        WHERE pm.prcode = brm.prcode
            AND pm.prcode = prtm.prcode
            AND prt.actype = prtm.prtype
            AND prt.actype = tpm.prtype
            AND pm.codeid = decode(p_prtyp,'R',p_codeid,pm.codeid)
            AND pm.prtyp = p_prtyp
            AND prt.TYPE = p_type
            AND tpm.typeid = decode(tpm.typeid,'ALL',tpm.typeid,p_AcType)
            AND brm.brid = decode(brm.brid,'ALL',brm.brid,p_brid)
    )
    LOOP
        IF p_deltd <> 'Y' THEN
            IF p_dorc = 'C' THEN --Tang nguon: ~ giam nguon du tinh su dung
                INSERT INTO prinusedlog (prcode, prinused, deltd, last_change, autoid, txnum, txdate, ref)
                VALUES (rec.prcode, -p_amount, 'N', SYSTIMESTAMP, seq_prinusedlog.NEXTVAL, p_txnum, p_txdate, p_refid);
            ELSE --Giam nguon: ~ tang nguon du tinh su dung
                INSERT INTO prinusedlog (prcode, prinused, deltd, last_change, autoid, txnum, txdate, ref)
                VALUES (rec.prcode, p_amount, 'N', SYSTIMESTAMP, seq_prinusedlog.NEXTVAL, p_txnum, p_txdate, p_refid);
            END IF;
        ELSE
            UPDATE prinusedlog
            SET deltd = 'Y'
            WHERE txnum = p_txnum AND txdate = p_txdate;
        END IF;
    END LOOP;

    plog.setendsection (pkgctx, 'fn_SecuredUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION when others then
    plog.error(pkgctx,'error:'||p_err_code);
    plog.error (pkgctx, '[l_parameters] ' || l_parameters); --Log trace exception
    plog.error (pkgctx, '[SQLERRM] ' || SQLERRM); --Log trace exception
    plog.error(pkgctx,'row:'||dbms_utility.format_error_backtrace);
    plog.setendsection (pkgctx, 'fn_SecuredUpdate');
    p_err_code:=errnums.c_system_error;
    RETURN errnums.C_BIZ_RULE_INVALID;
END fn_SecuredUpdate;


/*
-- Check if p_dorc = 'D'.
-- Update temporary secured
*/
FUNCTION fn_SecuredUpdate(p_dorc varchar2, p_amount NUMBER, p_acctno VARCHAR2, p_txnum varchar2, p_txdate date,
                p_err_code OUT VARCHAR2)
RETURN NUMBER
IS
l_count NUMBER;
l_IsMarginAccount varchar2(1);
l_amt number(20,4);
l_actype varchar2(10);
l_BrID varchar2(10);
l_preexecamt number;
l_parameters varchar2(4000);
l_IsFO varchar2(1);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_SecuredUpdate');
    begin
      l_parameters:=('p_dorc:' || p_dorc || ' p_amount:' || p_amount || ' p_acctno:' || p_acctno || ' p_txnum:' || p_txnum|| ' p_txdate:' || p_txdate);
    exception when others then
      l_parameters:='';
    end;
    p_err_code:=systemnums.c_success;
    l_preexecamt:=0;
    BEGIN
        SELECT NVL(ISFO,'N') INTO l_IsFO FROM AFMAST WHERE ACCTNO = p_acctno AND EXISTS (SELECT varvalue FROM sysvar WHERE varname = 'FOMODE' AND varvalue = 'ON');
    EXCEPTION when others then
        l_IsFO := 'N';
    END;


    select count(1) into l_count
    from cfmast cf, afmast af
    where cf.custid = af.custid
    and af.acctno = p_acctno and cf.custatcom = 'Y'
    and af.poolchk = 'Y'; --GianhVG neu Poolchk ='Y' thi moi cap nhat Pool

    if l_count > 0 then

        --Lay LNTYPE default gan vao AFTYPE.
        select count(1) into l_count
        from afmast af, aftype aft, mrtype mrt, lntype lnt
        where af.actype = aft.actype and aft.mrtype = mrt.actype and mrt.mrtype = 'T'
            and aft.lntype = lnt.actype(+) and nvl(lnt.chksysctrl,'N') = 'Y' and af.acctno = p_acctno;

        --Neu Tieu khoan khong danh dau bat buoc tuan thu he thong hoac ko phai lai tieu khoan margin -> Khong can hach toan nguon.
        if l_count = 0 then
            l_IsMarginAccount:='N';
        else
            l_IsMarginAccount:='Y';
        end if;

        -- <<Get afprinusedlog amount
        begin
            select nvl(sum(preexecamt),0) into l_preexecamt
            from afprinusedlog
            where afacctno = p_acctno;
        exception when others then
            l_preexecamt:=0;
        end;
        delete afprinusedlog where afacctno = p_acctno;
        -- >>Get afprinusedlog amount

        -- Sau khi giai toa ky quy chung khoan mua: chi giai toa pool tuong ung voi gia tri chung khoan from -amount den zero.
        if p_DorC = 'C' then
            select
                least(-least(nvl(adv.avladvance,0)
                        + mst.balance
                        - mst.odamt
                        - mst.dfdebtamt
                        - mst.dfintdebtamt
                        - NVL (advamt, 0)
                        - nvl(secureamt,0)
                        - ramt
                        - mst.depofeeamt
                        - (p_amount-l_preexecamt) ,0),

                        (p_amount-l_preexecamt) )
                into l_amt
            from cimast mst
            left join (select * from v_getbuyorderinfo where afacctno = p_acctno) al on mst.acctno = al.afacctno
            left join (select sum(depoamt) avladvance,afacctno from v_getAccountAvlAdvance where afacctno = p_acctno group by afacctno) adv on adv.afacctno=MST.acctno
            where mst.acctno = p_acctno;
        else
            select
                least(-least(nvl(adv.avladvance,0)
                        + mst.balance
                        - mst.odamt
                        - mst.dfdebtamt
                        - mst.dfintdebtamt
                        - NVL (advamt, 0)
                        - nvl(secureamt,0)
                        - ramt
                        - mst.depofeeamt
                        ,0),

                        (p_amount-l_preexecamt))
                into l_amt
            from cimast mst
            left join (select * from v_getbuyorderinfo where afacctno = p_acctno) al on mst.acctno = al.afacctno
            left join (select sum(depoamt) avladvance,afacctno from v_getAccountAvlAdvance where afacctno = p_acctno group by afacctno) adv on adv.afacctno=MST.acctno
            where mst.acctno = p_acctno;
        end if;

        if l_amt > 0 then
           select actype, substr(acctno,1,4) into l_actype, l_BrID from afmast where acctno = p_acctno;
             FOR rec_pr IN (
                    SELECT DISTINCT pm.prcode, pm.prname, pm.prtyp, pm.codeid, pm.prlimit,
                            pm.prinused + fn_getExpectUsed(pm.prcode) prinused, pm.expireddt, pm.prstatus
                    FROM prmaster pm,  prtype prt, prtypemap prtm, typeidmap tpm, bridmap brm
                    WHERE pm.prcode = brm.prcode
                        AND pm.prcode = prtm.prcode
                        AND prt.actype = prtm.prtype
                        AND prt.actype = tpm.prtype
                        AND pm.prtyp = 'P'
                        AND ((prt.TYPE = 'AFTYPE') or (l_IsMarginAccount = 'Y' and prt.TYPE = 'SYSTEM'))
                        AND pm.prstatus = 'A'
                        AND tpm.typeid = decode(tpm.typeid,'ALL',tpm.typeid,l_actype)
                        AND brm.brid = decode(brm.brid,'ALL',brm.brid,l_BrID)
                           )
             LOOP
                if p_dorc = 'D' then
                    if l_amt > (rec_pr.prlimit - rec_pr.prinused) And l_IsFO = 'N' then
                        p_err_code:= '-100522';
                        plog.setendsection (pkgctx, 'fn_SecuredUpdate');
                        RETURN errnums.C_BIZ_RULE_INVALID;
                    end if;
                end if;

                insert into prinusedlog (prcode,prinused,deltd,last_change,autoid,txnum,txdate)
                values(rec_pr.prcode, (case when p_dorc = 'C' then -1 else 1 end)*l_amt, 'N', SYSTIMESTAMP, seq_prinusedlog.nextval, p_txnum,p_txdate );
             end loop;
         end if;
    else
        --p_dorc varchar2, p_amount NUMBER, p_acctno VARCHAR2, p_txnum varchar2, p_txdate date,

        --Xu ly neu Poolchk='N' thi check theo afmat.poollimit
         l_amt:=fn_getAvlAccountPoolLimit(p_acctno, 0);
         if l_amt <0 And l_IsFO = 'N' then
             p_err_code := '-100522'; --Vuot qua nguon.
             plog.debug(pkgctx,'PRCHK: [-100522]:Loi vuot qua nguon tien:' || p_err_code);
             plog.setendsection(pkgctx, 'fn_txAutoAdhocCheck');
             RETURN errnums.C_BIZ_RULE_INVALID;
         end if;
    end if;
    plog.setendsection (pkgctx, 'fn_SecuredUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION when others then
    plog.error(pkgctx,'error:'||p_err_code);
    plog.error (pkgctx, '[l_parameters] ' || l_parameters); --Log trace exception
    plog.error (pkgctx, '[SQLERRM] ' || SQLERRM); --Log trace exception
    plog.error(pkgctx,'row:'||dbms_utility.format_error_backtrace);
    plog.setendsection (pkgctx, 'fn_SecuredUpdate');
    p_err_code:=errnums.c_system_error;
    RETURN errnums.C_BIZ_RULE_INVALID;
END fn_SecuredUpdate;


FUNCTION fn_getExpectUsed(p_PrCode VARCHAR2) RETURN number IS
l_ExpectUsed number(20, 0);
l_AvlPR      number(20, 0);
l_parameters varchar2(4000);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_getExpectUsed');
    begin
      l_parameters:=('p_PrCode:' || p_PrCode );
    exception when others then
      l_parameters:='';
    end;
    BEGIN
      SELECT nvl(sum(prinused),0)
        INTO l_ExpectUsed
        FROM prinusedlog
       WHERE prcode = p_PrCode;
    EXCEPTION
      WHEN OTHERS THEN
        l_ExpectUsed := 0;
    END;
    plog.setendsection (pkgctx, 'fn_getExpectUsed');
    return l_ExpectUsed;
exception
when others then
  plog.error (pkgctx, '[l_parameters] ' || l_parameters); --Log trace exception
  plog.error (pkgctx, '[SQLERRM] ' || SQLERRM); --Log trace exception
  plog.error(pkgctx,'row:'||dbms_utility.format_error_backtrace);
  plog.setendsection (pkgctx, 'fn_getExpectUsed');
  return 0;
END fn_getExpectUsed;

/**
* Cap nhat gia tri nguon du tinh theo xu ly dac biet. Ham goi di theo giao dich.
**/
FUNCTION fn_txAutoAdhocUpdate(p_txmsg in tx.msg_rectype, p_err_code out varchar2)
RETURN NUMBER
IS
l_AfAcctno varchar2(10);
l_AfAcctno2 varchar2(10);
l_AcType varchar2(4);
l_Type varchar2(10);
l_count NUMBER;
l_IsSpecialPR NUMBER;
l_CodeID varchar2(6);
l_OrderID varchar2(20);
l_UsedAmt NUMBER;
l_UsedQtty NUMBER;
l_TotalUsedQtty NUMBER;
l_CurrDate DATE;
l_sumexecqtty NUMBER;
l_execqtty NUMBER;
l_matchamt NUMBER;
l_trade NUMBER;
l_AIntRate NUMBER;
l_AMinBal NUMBER;
l_AFeeBank NUMBER;
l_AMinFeeBank NUMBER;
l_qtty NUMBER;
l_BrID  varchar2(4);
l_IsMarginAccount char(1);
l_amt number;
l_ExecType varchar2(2);
l_NumVal1 number;
l_NumVal2 number;
l_fomode    VARCHAR2(10);
l_afmode    VARCHAR2(10);

BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAutoAdhocUpdate');
    l_UsedAmt:=0;
    l_UsedQtty:=0;
    l_CurrDate:= to_date(cspks_system.fn_get_sysvar('SYSTEM', 'CURRDATE'),systemnums.c_date_format);
    l_AIntRate:= to_number(cspks_system.fn_get_sysvar('SYSTEM', 'AINTRATE'));
    l_AMinBal:= to_number(cspks_system.fn_get_sysvar('SYSTEM', 'AMINBAL'));
    l_AFeeBank:= to_number(cspks_system.fn_get_sysvar('SYSTEM', 'AFEEBANK'));
    l_AMinFeeBank:= to_number(cspks_system.fn_get_sysvar('SYSTEM', 'AMINFEEBANK'));

    SELECT nvl(varvalue,'OFF') INTO l_fomode FROM sysvar WHERE varname = 'FOMODE';

    IF p_txmsg.tltxcd in ('1140','1131','1189') THEN -- Nap tien qua quy
        -- Xu ly Room:
        if p_txmsg.deltd <> 'Y' then -- Normal Transactions
            if fn_markedafpralloc(p_txmsg.txfields('03').value,
                            null,
                            'A',
                            'T',
                            null,
                            'N',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
            -- Xu ly Pool: -- Tang nguon
            if fn_SecuredUpdate('C', to_number(p_txmsg.txfields('10').value), p_txmsg.txfields('03').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        else -- Reverser
            if fn_markedafpralloc(p_txmsg.txfields('03').value,
                            null,
                            'A',
                            'T',
                            null,
                            'N',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
            -- Xu ly Pool: -- Tang nguon
            if fn_SecuredUpdate('D', to_number(p_txmsg.txfields('10').value), p_txmsg.txfields('03').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        end if;
    elsIF p_txmsg.tltxcd in ('2200','2202','2232','2242','2243','2244','2250') THEN -- Rut chuyen chung khoan

        -- Thuc hien giai toa chung khoan da danh sau theo giao dich.
        if p_txmsg.deltd <> 'Y' then -- Normal Transactions
            SELECT nvl(af.isfo,'N') INTO l_afmode FROM afmast af WHERE acctno = p_txmsg.txfields('02').value;
            IF l_fomode = 'OFF' OR l_afmode = 'N' THEN
                for rec in
                (
                    select nvl(sum(case when restype = 'M' then prinused else 0 end),0) prinused,
                            nvl(sum(case when restype = 'S' then prinused else 0 end),0) sy_prinused
                    from vw_afpralloc_all
                    where afacctno = p_txmsg.txfields('02').value and codeid = p_txmsg.txfields('01').value
                )
                loop
                    INSERT INTO afpralloc (AUTOID,AFACCTNO,PRINUSED,CODEID,ALLOCTYP,ORGORDERID,TXDATE,TXNUM,RESTYPE)
                        VALUES(seq_afpralloc.nextval,p_txmsg.txfields('02').value,
                            -least(to_number(p_txmsg.txfields('10').value), rec.sy_prinused),p_txmsg.txfields('01').value,'M',null,
                            p_txmsg.txdate, p_txmsg.txnum,'S');
                    INSERT INTO afpralloc (AUTOID,AFACCTNO,PRINUSED,CODEID,ALLOCTYP,ORGORDERID,TXDATE,TXNUM,RESTYPE)
                        VALUES(seq_afpralloc.nextval,p_txmsg.txfields('02').value,
                            -least(to_number(p_txmsg.txfields('10').value), rec.prinused),p_txmsg.txfields('01').value,'M',null,
                            p_txmsg.txdate, p_txmsg.txnum,'M');
                end loop;
            -- Xu ly Room:
            END IF;

            if fn_markedafpralloc(p_txmsg.txfields('02').value,
                            null,
                            'A',
                            'T',
                            null,
                            'Y',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        else -- Reverse Transactions
            -- Xu ly Room:
            if fn_markedafpralloc(p_txmsg.txfields('02').value,
                            null,
                            'A',
                            'T',
                            null,
                            'N',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        end if;
    elsIF p_txmsg.tltxcd in ('2242','2245') THEN -- Nap nhan chung khoan
        -- Xu ly Room:
        if p_txmsg.deltd <> 'Y' then -- Normal transactions
            if fn_markedafpralloc(p_txmsg.txfields('04').value,
                            null,
                            'A',
                            'T',
                            null,
                            'N',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        else -- Reverser transactions
            if fn_markedafpralloc(p_txmsg.txfields('04').value,
                            null,
                            'A',
                            'T',
                            null,
                            'N',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        end if;
    elsIF p_txmsg.tltxcd in ('2246','2203','2252','2253') THEN -- Nap nhan chung khoan
        if p_txmsg.deltd <> 'Y' then -- Normal transactions
        -- Xu ly Room:
            if fn_markedafpralloc(p_txmsg.txfields('02').value,
                            null,
                            'A',
                            'T',
                            null,
                            'N',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        else --Reserver Transactions
            if fn_markedafpralloc(p_txmsg.txfields('02').value,
                            null,
                            'A',
                            'T',
                            null,
                            'N',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        end if;
    elsIF p_txmsg.tltxcd in ('1141') THEN -- Nap tien tu ngan hang
        if p_txmsg.deltd <> 'Y' then -- Normal Transaction
            -- Xu ly Room:
            if fn_markedafpralloc(p_txmsg.txfields('03').value,
                            null,
                            'A',
                            'T',
                            null,
                            'N',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
            -- Xu ly Pool: -- Tang nguon
            if fn_SecuredUpdate('C', to_number(p_txmsg.txfields('10').value), p_txmsg.txfields('03').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        else -- Reverser Transactions
            -- Xu ly Room:
            if fn_markedafpralloc(p_txmsg.txfields('03').value,
                            null,
                            'A',
                            'T',
                            null,
                            'N',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
            -- Xu ly Pool: -- Tang nguon
            if fn_SecuredUpdate('D', to_number(p_txmsg.txfields('10').value), p_txmsg.txfields('03').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        end if;
    elsIF p_txmsg.tltxcd in ('1101','1100','1111','1110','1133','1670','1132','1184','1185','1188') THEN -- Rut tien
        if p_txmsg.deltd <> 'Y' then -- Normal Transactions
            -- Xu ly Room:
            if fn_markedafpralloc(p_txmsg.txfields('03').value,
                            null,
                            'A',
                            'T',
                            null,
                            'Y',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
            -- Xu ly Pool: -- giam nguon
            if fn_SecuredUpdate('D', to_number(p_txmsg.txfields('10').value), p_txmsg.txfields('03').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        else -- Reserver Transactions
            -- Xu ly Room:
            if fn_markedafpralloc(p_txmsg.txfields('03').value,
                            null,
                            'A',
                            'T',
                            null,
                            'N',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
            -- Xu ly Pool: -- giam nguon
            if fn_SecuredUpdate('C', to_number(p_txmsg.txfields('10').value), p_txmsg.txfields('03').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        end if;

    elsIF p_txmsg.tltxcd in ('1114') THEN -- Tu choi UNC
        if p_txmsg.deltd <> 'Y' then -- Normal Transactions
            -- Xu ly Room:
            if fn_markedafpralloc(p_txmsg.txfields('03').value,
                            null,
                            'A',
                            'T',
                            null,
                            'N',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
            -- Xu ly Pool: -- giam nguon
            if fn_SecuredUpdate('C', to_number(p_txmsg.txfields('10').value), p_txmsg.txfields('03').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        else -- Transactions
             -- Xu ly Room:
            if fn_markedafpralloc(p_txmsg.txfields('03').value,
                            null,
                            'A',
                            'T',
                            null,
                            'Y',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
            -- Xu ly Pool: -- giam nguon
            if fn_SecuredUpdate('D', to_number(p_txmsg.txfields('10').value), p_txmsg.txfields('03').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        end if;

    elsIF p_txmsg.tltxcd in ('1107','1108','1136') THEN -- Rut tien
        if p_txmsg.deltd <> 'Y' then -- Normal transaction
            -- Xu ly Room:
            if fn_markedafpralloc(p_txmsg.txfields('03').value,
                            null,
                            'A',
                            'T',
                            null,
                            'Y',
                            'Y',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
            -- Xu ly Pool: -- giam nguon
            if fn_SecuredUpdate('D', to_number(p_txmsg.txfields('10').value), p_txmsg.txfields('03').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        else -- Reserver Transaction
            -- Xu ly Room:
            if fn_markedafpralloc(p_txmsg.txfields('03').value,
                            null,
                            'A',
                            'T',
                            null,
                            'N',
                            'Y',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
            -- Xu ly Pool: -- giam nguon
            if fn_SecuredUpdate('C', to_number(p_txmsg.txfields('10').value), p_txmsg.txfields('03').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        end if;
    elsIF p_txmsg.tltxcd in ('8890') THEN -- Sua lenh

        if fn_markedafpralloc(p_txmsg.txfields('03').value,
                        null,
                        'A',
                        'T',
                        null,
                        'N',
                        'Y',
                        to_date(p_txmsg.txdate,systemnums.c_date_format),
                        p_txmsg.txnum,
                        p_err_code) <> systemnums.C_SUCCESS then
            plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;
        if p_txmsg.deltd <> 'Y' then -- Normal Transactions
            if to_number(p_txmsg.txfields('18').value) > 0 then
                -- Xu ly Pool: -- giam nguon
                if fn_SecuredUpdate('D', to_number(p_txmsg.txfields('18').value), p_txmsg.txfields('03').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                    plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                end if;
            elsif to_number(p_txmsg.txfields('18').value) < 0 then
                -- Xu ly Pool: -- tang nguon
                if fn_SecuredUpdate('C', abs(to_number(p_txmsg.txfields('18').value)), p_txmsg.txfields('03').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                    plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                end if;
            end if;
        else -- Reverser Transactions
            if to_number(p_txmsg.txfields('18').value) > 0 then
                -- Xu ly Pool: -- giam nguon
                if fn_SecuredUpdate('C', to_number(p_txmsg.txfields('18').value), p_txmsg.txfields('03').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                    plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                end if;
            elsif to_number(p_txmsg.txfields('18').value) < 0 then
                -- Xu ly Pool: -- giam nguon
                if fn_SecuredUpdate('D', abs(to_number(p_txmsg.txfields('18').value)), p_txmsg.txfields('03').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                    plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                end if;
            end if;
        end if;
    elsIF p_txmsg.tltxcd in ('3384') THEN -- Dang ky quyen mua
        if p_txmsg.deltd <> 'Y' then -- Normal Transactions
            -- Xu ly Room:
            if fn_markedafpralloc(p_txmsg.txfields('03').value,
                            null,
                            'A',
                            'T',
                            null,
                            'Y',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
            -- Xu ly Pool: -- giam nguon
            if fn_SecuredUpdate('D', to_number(p_txmsg.txfields('10').value), p_txmsg.txfields('03').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        else -- Reverser Transactions
            -- Xu ly Room:
            if fn_markedafpralloc(p_txmsg.txfields('03').value,
                            null,
                            'A',
                            'T',
                            null,
                            'N',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
            -- Xu ly Pool: -- giam nguon
            if fn_SecuredUpdate('C', to_number(p_txmsg.txfields('10').value), p_txmsg.txfields('03').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        end if;
    elsIF p_txmsg.tltxcd in ('1120','1130','1134') THEN -- chuyen khoan noi bo
        if p_txmsg.deltd <> 'Y' then -- Normal transactions
            -- Xu ly Room:
            --1. TK chuyen
            if fn_markedafpralloc(p_txmsg.txfields('03').value,
                            null,
                            'A',
                            'T',
                            null,
                            'Y',
                            (case when p_txmsg.tltxcd = '1134' then 'Y' else 'N' end),
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
            --2. TK nhan
            if fn_markedafpralloc(p_txmsg.txfields('05').value,
                            null,
                            'A',
                            'T',
                            null,
                            'N',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
            -- Xu ly Pool:
            --1. TK chuyen:
            if fn_SecuredUpdate('D', to_number(p_txmsg.txfields('10').value), p_txmsg.txfields('03').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
            --2. TK nhan:
            if fn_SecuredUpdate('C', to_number(p_txmsg.txfields('10').value), p_txmsg.txfields('05').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        else -- Reserver Transactions
            -- Xu ly Room:
            --1. TK chuyen
            if fn_markedafpralloc(p_txmsg.txfields('03').value,
                            null,
                            'A',
                            'T',
                            null,
                            'N',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
            --2. TK nhan
            if fn_markedafpralloc(p_txmsg.txfields('05').value,
                            null,
                            'A',
                            'T',
                            null,
                            'N',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
            -- Xu ly Pool:
            --1. TK chuyen:
            if fn_SecuredUpdate('C', to_number(p_txmsg.txfields('10').value), p_txmsg.txfields('03').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
            --2. TK nhan:
            if fn_SecuredUpdate('D', to_number(p_txmsg.txfields('10').value), p_txmsg.txfields('05').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        end if;

    elsIF p_txmsg.tltxcd in ('5540') THEN -- tra no LN: bao lanh, margin
        if p_txmsg.deltd <> 'Y' then -- Normal transactions
            -- Xu ly Room:
            if fn_markedafpralloc(p_txmsg.txfields('05').value,
                            null,
                            'A',
                            'T',
                            null,
                            'N',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        else -- Reverser Transactions
            -- Xu ly Room:
            if fn_markedafpralloc(p_txmsg.txfields('05').value,
                            null,
                            'A',
                            'T',
                            null,
                            'N',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        end if;

        -- Xu ly Pool: Giao dich tra no. Thuc hien luon ko Du tinh
    elsIF p_txmsg.tltxcd in ('8804') THEN -- khop lenh
        if p_txmsg.deltd <> 'Y' then -- Normal Transactions
            -- Xu ly Room:
            if p_txmsg.txfields('83').value <> 'B' then
                SELECT nvl(af.isfo,'N') INTO l_afmode FROM afmast af WHERE acctno = p_txmsg.txfields('04').value;
                IF l_fomode = 'OFF' OR l_afmode = 'N' THEN
                    for rec in
                    (
                        select nvl(sum(case when restype = 'M' then prinused else 0 end),0) prinused,
                                nvl(sum(case when restype = 'S' then prinused else 0 end),0) sy_prinused
                        from vw_afpralloc_all
                        where afacctno = p_txmsg.txfields('04').value and codeid = p_txmsg.txfields('80').value
                    )
                    loop
                        INSERT INTO afpralloc (AUTOID,AFACCTNO,PRINUSED,CODEID,ALLOCTYP,ORGORDERID,TXDATE,TXNUM,RESTYPE)
                            VALUES(seq_afpralloc.nextval,p_txmsg.txfields('04').value,
                                -least(to_number(p_txmsg.txfields('11').value), rec.sy_prinused),p_txmsg.txfields('80').value,'M',null,
                                p_txmsg.txdate, p_txmsg.txnum,'S');
                        INSERT INTO afpralloc (AUTOID,AFACCTNO,PRINUSED,CODEID,ALLOCTYP,ORGORDERID,TXDATE,TXNUM,RESTYPE)
                            VALUES(seq_afpralloc.nextval,p_txmsg.txfields('04').value,
                                -least(to_number(p_txmsg.txfields('11').value), rec.prinused),p_txmsg.txfields('80').value,'M',null,
                                p_txmsg.txdate, p_txmsg.txnum,'M');
                    end loop;
                    -- Lenh ban cam co.
                    if fn_markedafpralloc(p_txmsg.txfields('04').value,
                                    null,
                                    'A',
                                    'T',
                                    p_txmsg.txfields('03').value,
                                    'N',
                                    'N',
                                    to_date(p_txmsg.txdate,systemnums.c_date_format),
                                    p_txmsg.txnum,
                                    p_err_code) <> systemnums.C_SUCCESS then
                        plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                        RETURN errnums.C_BIZ_RULE_INVALID;
                    end if;
                END IF;
                -- Xu ly Pool:
                if fn_SecuredUpdate('C', to_number(p_txmsg.txfields('10').value)*to_number(p_txmsg.txfields('11').value)*to_number(p_txmsg.txfields('15').value)/100, p_txmsg.txfields('04').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                    plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                end if;
            end if;
        else -- Reverser Transactions
            -- Xu ly Room:
            if p_txmsg.txfields('83').value <> 'B' then
                if fn_markedafpralloc(p_txmsg.txfields('04').value,
                                null,
                                'A',
                                'T',
                                p_txmsg.txfields('03').value,
                                'N',
                                'N',
                                to_date(p_txmsg.txdate,systemnums.c_date_format),
                                p_txmsg.txnum,
                                p_err_code) <> systemnums.C_SUCCESS then
                    plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                end if;
                -- Xu ly Pool:
                if fn_SecuredUpdate('D', to_number(p_txmsg.txfields('10').value)*to_number(p_txmsg.txfields('11').value)*to_number(p_txmsg.txfields('15').value)/100, p_txmsg.txfields('04').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                    plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                end if;
            end if;
        end if;

    elsIF p_txmsg.tltxcd in ('8808','8811','8852') THEN -- Giai toa lenh mua
        if p_txmsg.deltd <> 'Y' then -- Normal Transactions
            -- Xu ly Room: (RELEASE ROOM)
            if fn_markedafpralloc(p_txmsg.txfields('05').value,
                            null,
                            'A',
                            'T',
                            p_txmsg.txfields('03').value,
                            'N',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
            -- Xu ly Pool:
            if fn_SecuredUpdate('C', to_number(p_txmsg.txfields('11').value), p_txmsg.txfields('05').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        else -- Reversal Transactions
            -- Xu ly Room: (RELEASE ROOM)
            if fn_markedafpralloc(p_txmsg.txfields('05').value,
                            null,
                            'A',
                            'T',
                            p_txmsg.txfields('03').value,
                            'N',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
            -- Xu ly Pool:
            if fn_SecuredUpdate('D', to_number(p_txmsg.txfields('11').value), p_txmsg.txfields('05').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        end if;
    elsIF p_txmsg.tltxcd in ('2242') THEN -- nhan chuyen khoan chung khoan
        if p_txmsg.deltd <> 'Y' then -- Normal Transactions
            -- Xu ly Room:
            if fn_markedafpralloc(p_txmsg.txfields('04').value,
                            p_txmsg.txfields('01').value,
                            'A',
                            'T',
                            null,
                            'Y',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        else  -- Reversal Transactions
            -- Xu ly Room:
            if fn_markedafpralloc(p_txmsg.txfields('04').value,
                            p_txmsg.txfields('01').value,
                            'A',
                            'T',
                            null,
                            'N',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        end if;
        -- Xu ly Pool:
    elsIF p_txmsg.tltxcd in ('8884') THEN -- dat lenh sua
        if p_txmsg.deltd <> 'Y' then -- Normal Transactions
            --Danh dau room
            if fn_markedafpralloc(p_txmsg.txfields('03').value,
                        null,
                        'A',
                        'T',
                        p_txmsg.txfields('04').value,
                        'N',
                        'N',
                        to_date(p_txmsg.txdate,systemnums.c_date_format),
                        p_txmsg.txnum,
                        p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;

        else -- Reversal Transactions
            --Danh dau room
            if fn_markedafpralloc(p_txmsg.txfields('03').value,
                        null,
                        'A',
                        'T',
                        p_txmsg.txfields('04').value,
                        'N',
                        'N',
                        to_date(p_txmsg.txdate,systemnums.c_date_format),
                        p_txmsg.txnum,
                        p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        end if;

    elsIF p_txmsg.tltxcd in ('8876','8874') THEN -- dat lenh mua
        if p_txmsg.deltd <> 'Y' then -- Normal Transactions
            --Danh dau room
            if fn_markedafpralloc(p_txmsg.txfields('03').value,
                        null,
                        'A',
                        'T',
                        p_txmsg.txfields('04').value,
                        'N',
                        'N',
                        to_date(p_txmsg.txdate,systemnums.c_date_format),
                        p_txmsg.txnum,
                        p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
            -- Xu ly Pool:
            if fn_SecuredUpdate('D',
                        to_number(p_txmsg.txfields('11').value) * to_number(p_txmsg.txfields('12').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value)
                        , p_txmsg.txfields('03').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        else -- Reversal Transactions
            --Danh dau room
            if fn_markedafpralloc(p_txmsg.txfields('03').value,
                        null,
                        'A',
                        'T',
                        p_txmsg.txfields('04').value,
                        'N',
                        'N',
                        to_date(p_txmsg.txdate,systemnums.c_date_format),
                        p_txmsg.txnum,
                        p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
            -- Xu ly Pool:
            if fn_SecuredUpdate('C',
                        to_number(p_txmsg.txfields('11').value) * to_number(p_txmsg.txfields('12').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value)
                        , p_txmsg.txfields('03').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        end if;
    elsIF p_txmsg.tltxcd in ('8882') THEN -- Huy lenh mua thong thuong
        if p_txmsg.deltd <> 'Y' then -- Normal Transaction
            if fn_markedafpralloc(p_txmsg.txfields('03').value,
                        null,
                        'A',
                        'T',
                        p_txmsg.txfields('08').value,
                        'N',
                        'N',
                        to_date(p_txmsg.txdate,systemnums.c_date_format),
                        p_txmsg.txnum,
                        p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
            -- Xu ly Pool:
            if fn_SecuredUpdate('C',
                        to_number(p_txmsg.txfields('11').value) * to_number(p_txmsg.txfields('12').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value)
                        , p_txmsg.txfields('03').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        else -- Reversal Transactions
            if fn_markedafpralloc(p_txmsg.txfields('03').value,
                        null,
                        'A',
                        'T',
                        p_txmsg.txfields('08').value,
                        'N',
                        'N',
                        to_date(p_txmsg.txdate,systemnums.c_date_format),
                        p_txmsg.txnum,
                        p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
            -- Xu ly Pool:
            if fn_SecuredUpdate('D',
                        to_number(p_txmsg.txfields('11').value) * to_number(p_txmsg.txfields('12').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value)
                        , p_txmsg.txfields('03').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        end if;
    elsIF p_txmsg.tltxcd in ('5566') THEN -- giai ngan LN: bao lanh, margin; Buoc xu ly batch, khong thuc hien, vi sau do se duoc danh sau lai.
        if p_txmsg.deltd <> 'Y' then -- Normal Transactions
            if fn_markedafpralloc(p_txmsg.txfields('05').value,
                        null,
                        'A',
                        'T',
                        null,
                        'N',
                        'N',
                        to_date(p_txmsg.txdate,systemnums.c_date_format),
                        p_txmsg.txnum,
                        p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        else -- Reversal Transactions
            if fn_markedafpralloc(p_txmsg.txfields('05').value,
                        null,
                        'A',
                        'T',
                        null,
                        'N',
                        'N',
                        to_date(p_txmsg.txdate,systemnums.c_date_format),
                        p_txmsg.txnum,
                        p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        end if;

    elsIF p_txmsg.tltxcd in ('5567') THEN -- tra no giai ngan LN: bao lanh, margin; Buoc xu ly batch, khong thuc hien, vi sau do se duoc danh sau lai.
        if p_txmsg.deltd <> 'Y' then -- Normal Transactions
            if fn_markedafpralloc(p_txmsg.txfields('05').value,
                            null,
                            'A',
                            'T',
                            null,
                            'N',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        else -- Reversal Transactions
            if fn_markedafpralloc(p_txmsg.txfields('05').value,
                            null,
                            'A',
                            'T',
                            null,
                            'N',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        end if;
    elsIF p_txmsg.tltxcd in ('8809') THEN -- khop lenh manual
        if p_txmsg.deltd <> 'Y' then -- Normal Transactions
            -- Xu ly Room:
            if p_txmsg.txfields('83').value = 'S' then
                SELECT nvl(af.isfo,'N') INTO l_afmode FROM afmast af WHERE acctno = p_txmsg.txfields('04').value;
                IF l_fomode = 'OFF' OR l_afmode = 'N' THEN
                    for rec in
                    (
                        select nvl(sum(case when restype = 'M' then prinused else 0 end),0) prinused,
                                nvl(sum(case when restype = 'S' then prinused else 0 end),0) sy_prinused
                        from vw_afpralloc_all
                        where afacctno = p_txmsg.txfields('04').value and codeid = p_txmsg.txfields('80').value
                    )
                    loop
                        INSERT INTO afpralloc (AUTOID,AFACCTNO,PRINUSED,CODEID,ALLOCTYP,ORGORDERID,TXDATE,TXNUM,RESTYPE)
                            VALUES(seq_afpralloc.nextval,p_txmsg.txfields('04').value,
                                -least(to_number(p_txmsg.txfields('11').value), rec.sy_prinused),p_txmsg.txfields('80').value,'M',null,
                                p_txmsg.txdate, p_txmsg.txnum,'S');
                        INSERT INTO afpralloc (AUTOID,AFACCTNO,PRINUSED,CODEID,ALLOCTYP,ORGORDERID,TXDATE,TXNUM,RESTYPE)
                            VALUES(seq_afpralloc.nextval,p_txmsg.txfields('04').value,
                                -least(to_number(p_txmsg.txfields('11').value), rec.prinused),p_txmsg.txfields('80').value,'M',null,
                                p_txmsg.txdate, p_txmsg.txnum,'M');
                    end loop;
                    if fn_markedafpralloc(p_txmsg.txfields('04').value,
                                    null,
                                    'A',
                                    'T',
                                    p_txmsg.txfields('03').value,
                                    'N',
                                    'N',
                                    to_date(p_txmsg.txdate,systemnums.c_date_format),
                                    p_txmsg.txnum,
                                    p_err_code) <> systemnums.C_SUCCESS then
                        plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                        RETURN errnums.C_BIZ_RULE_INVALID;
                    END if;
                END IF;
                -- Xu ly Pool:
                if fn_SecuredUpdate('C', to_number(p_txmsg.txfields('10').value)*to_number(p_txmsg.txfields('11').value)*to_number(p_txmsg.txfields('15').value)/100,
                        p_txmsg.txfields('04').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                    plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                end if;
            end if;
        else -- Reversal Transactions
            -- Xu ly Room:
            if p_txmsg.txfields('83').value = 'S' then
                if fn_markedafpralloc(p_txmsg.txfields('04').value,
                                null,
                                'A',
                                'T',
                                p_txmsg.txfields('03').value,
                                'N',
                                'N',
                                to_date(p_txmsg.txdate,systemnums.c_date_format),
                                p_txmsg.txnum,
                                p_err_code) <> systemnums.C_SUCCESS then
                    plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                end if;
                -- Xu ly Pool:
                if fn_SecuredUpdate('D', to_number(p_txmsg.txfields('10').value)*to_number(p_txmsg.txfields('11').value)*to_number(p_txmsg.txfields('15').value)/100,
                        p_txmsg.txfields('04').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                    plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                end if;
            end if;
        end if;
    elsIF p_txmsg.tltxcd in ('2652') THEN -- Nop bo sung chung khoan
        -- Xu ly Room:
        SELECT nvl(af.isfo,'N') INTO l_afmode FROM afmast af WHERE acctno = p_txmsg.txfields('04').value;
        IF l_fomode = 'OFF' OR l_afmode = 'N' THEN
           for rec in
           (
               select nvl(sum(case when restype = 'M' then prinused else 0 end),0) prinused,
                       nvl(sum(case when restype = 'S' then prinused else 0 end),0) sy_prinused
               from vw_afpralloc_all
               where afacctno = p_txmsg.txfields('03').value and codeid = p_txmsg.txfields('01').value
           )
           loop
               INSERT INTO afpralloc (AUTOID,AFACCTNO,PRINUSED,CODEID,ALLOCTYP,ORGORDERID,TXDATE,TXNUM,RESTYPE)
                   VALUES(seq_afpralloc.nextval,p_txmsg.txfields('03').value,
                       -least(to_number(p_txmsg.txfields('12').value)+to_number(p_txmsg.txfields('22').value)+to_number(p_txmsg.txfields('75').value), rec.sy_prinused),p_txmsg.txfields('01').value,'M',null,
                       p_txmsg.txdate, p_txmsg.txnum,'S');
               INSERT INTO afpralloc (AUTOID,AFACCTNO,PRINUSED,CODEID,ALLOCTYP,ORGORDERID,TXDATE,TXNUM,RESTYPE)
                   VALUES(seq_afpralloc.nextval,p_txmsg.txfields('03').value,
                       -least(to_number(p_txmsg.txfields('12').value)+to_number(p_txmsg.txfields('22').value)+to_number(p_txmsg.txfields('75').value), rec.prinused),p_txmsg.txfields('01').value,'M',null,
                       p_txmsg.txdate, p_txmsg.txnum,'M');
           end loop;
            -- Xu ly Room:
            if fn_markedafpralloc(p_txmsg.txfields('03').value,
                            null,
                            'A',
                            'T',
                            null,
                            'N',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            END if;
        END IF;
    elsIF p_txmsg.tltxcd in ('2673') THEN -- Tao deal vay DF
        -- Xu ly Room:
        SELECT nvl(af.isfo,'N') INTO l_afmode FROM afmast af WHERE acctno = p_txmsg.txfields('03').value;
        IF l_fomode = 'OFF' OR l_afmode = 'N' THEN
           for rec in
           (
               select nvl(sum(case when restype = 'M' then prinused else 0 end),0) prinused,
                       nvl(sum(case when restype = 'S' then prinused else 0 end),0) sy_prinused
               from vw_afpralloc_all
               where afacctno = p_txmsg.txfields('03').value and codeid = p_txmsg.txfields('01').value
           )
           loop
               INSERT INTO afpralloc (AUTOID,AFACCTNO,PRINUSED,CODEID,ALLOCTYP,ORGORDERID,TXDATE,TXNUM,RESTYPE)
                   VALUES(seq_afpralloc.nextval,p_txmsg.txfields('03').value,
                       -least(to_number(p_txmsg.txfields('12').value)+to_number(p_txmsg.txfields('13').value), rec.sy_prinused),p_txmsg.txfields('01').value,'M',null,
                       p_txmsg.txdate, p_txmsg.txnum,'S');
               INSERT INTO afpralloc (AUTOID,AFACCTNO,PRINUSED,CODEID,ALLOCTYP,ORGORDERID,TXDATE,TXNUM,RESTYPE)
                   VALUES(seq_afpralloc.nextval,p_txmsg.txfields('03').value,
                       -least(to_number(p_txmsg.txfields('12').value)+to_number(p_txmsg.txfields('13').value), rec.prinused),p_txmsg.txfields('01').value,'M',null,
                       p_txmsg.txdate, p_txmsg.txnum,'M');
           end loop;
       END IF;
    elsIF p_txmsg.tltxcd in ('2674') THEN -- Giai ngan DF
        -- Xu ly Room:
        if fn_markedafpralloc(p_txmsg.txfields('03').value,
                        null,
                        'A',
                        'T',
                        null,
                        'N',
                        'N',
                        to_date(p_txmsg.txdate,systemnums.c_date_format),
                        p_txmsg.txnum,
                        p_err_code) <> systemnums.C_SUCCESS then
            plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;
    elsIF p_txmsg.tltxcd in ('8895','8897') THEN -- 8895: chuyen lenh mua, 8897: sua lenh mua
        if p_txmsg.deltd <> 'Y' then -- Normal Transactions
            --  Xu ly Room:
            --1. Xu ly tieu khoan chuyen.
            if fn_markedafpralloc(p_txmsg.txfields('07').value,
                            null,
                            'A',
                            'T',
                            p_txmsg.txfields('03').value,
                            'N',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
            --2. Xu ly tieu khoan nhan.
            if fn_markedafpralloc(p_txmsg.txfields('08').value,
                            null,
                            'A',
                            'T',
                            p_txmsg.txfields('03').value,
                            'Y',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;

            --- Pool:
            ---- Xu ly tieu khoan chuyen:
            if p_txmsg.tltxcd = '8895' then
                if fn_SecuredUpdate('C',
                        (to_number(p_txmsg.txfields('14').value) + to_number(p_txmsg.txfields('15').value)) * to_number(p_txmsg.txfields('10').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value),
                        p_txmsg.txfields('07').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                    plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                end if;
            end if;
            if p_txmsg.tltxcd = '8897' then
                if fn_SecuredUpdate('C',
                        to_number(p_txmsg.txfields('11').value) * to_number(p_txmsg.txfields('10').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value),
                        p_txmsg.txfields('07').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                    plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                end if;
            end if;
            ---- Xu ly tieu khoan nhan:
            if p_txmsg.tltxcd = '8895' then
                if fn_SecuredUpdate('D',
                        (to_number(p_txmsg.txfields('14').value) + to_number(p_txmsg.txfields('15').value)) * to_number(p_txmsg.txfields('10').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value),
                       p_txmsg.txfields('08').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                    plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                end if;
            end if;
            if p_txmsg.tltxcd = '8897' then
                if fn_SecuredUpdate('D',
                        to_number(p_txmsg.txfields('11').value) * to_number(p_txmsg.txfields('10').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value),
                        p_txmsg.txfields('08').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                    plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                end if;
            end if;
        else
            --  Xu ly Room:
            --1. Xu ly tieu khoan chuyen.
            if fn_markedafpralloc(p_txmsg.txfields('07').value,
                            null,
                            'A',
                            'T',
                            p_txmsg.txfields('03').value,
                            'N',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
            --2. Xu ly tieu khoan nhan.
            if fn_markedafpralloc(p_txmsg.txfields('08').value,
                            null,
                            'A',
                            'T',
                            p_txmsg.txfields('03').value,
                            'N',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;

            --- Pool:
            ---- Xu ly tieu khoan chuyen:
            if p_txmsg.tltxcd = '8895' then
                if fn_SecuredUpdate('D',
                        (to_number(p_txmsg.txfields('14').value) + to_number(p_txmsg.txfields('15').value)) * to_number(p_txmsg.txfields('10').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value),
                        p_txmsg.txfields('07').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                    plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                end if;
            end if;
            if p_txmsg.tltxcd = '8897' then
                if fn_SecuredUpdate('D',
                        to_number(p_txmsg.txfields('11').value) * to_number(p_txmsg.txfields('10').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value),
                        p_txmsg.txfields('07').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                    plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                end if;
            end if;
            ---- Xu ly tieu khoan nhan:
            if p_txmsg.tltxcd = '8895' then
                if fn_SecuredUpdate('C',
                        (to_number(p_txmsg.txfields('14').value) + to_number(p_txmsg.txfields('15').value)) * to_number(p_txmsg.txfields('10').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value),
                       p_txmsg.txfields('08').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                    plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                end if;
            end if;
            if p_txmsg.tltxcd = '8897' then
                if fn_SecuredUpdate('C',
                        to_number(p_txmsg.txfields('11').value) * to_number(p_txmsg.txfields('10').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value),
                        p_txmsg.txfields('08').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                    plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                end if;
            end if;
        end if;
    elsIF p_txmsg.tltxcd in ('8896','8898') THEN -- 8896:Chuyen lenh khop ban; 8898:Sua loi lenh ban
        if p_txmsg.deltd <> 'Y' then
            --  Xu ly Room:
            --1. Xu ly tieu khoan chuyen.
            if fn_markedafpralloc(p_txmsg.txfields('07').value,
                            null,
                            'A',
                            'T',
                            p_txmsg.txfields('03').value,
                            'Y',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
            --2. Xu ly tieu khoan nhan.
            if fn_markedafpralloc(p_txmsg.txfields('08').value,
                            null,
                            'A',
                            'T',
                            p_txmsg.txfields('03').value,
                            'N',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;

            --  Xu ly Pool:
            --1.    Xu ly tieu khoan chuyen:
            if p_txmsg.tltxcd = '8896' then
                if fn_SecuredUpdate('D',
                       (to_number(p_txmsg.txfields('14').value) + to_number(p_txmsg.txfields('15').value)) * to_number(p_txmsg.txfields('10').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value),
                       p_txmsg.txfields('08').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                    plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                end if;
            end if;
            if p_txmsg.tltxcd = '8898' then
                if fn_SecuredUpdate('D',
                       to_number(p_txmsg.txfields('11').value) * to_number(p_txmsg.txfields('10').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value),
                       p_txmsg.txfields('08').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                    plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                end if;
            end if;


            --2. Xu ly tieu khoan nhan:
            if p_txmsg.tltxcd = '8896' then
                if fn_SecuredUpdate('C',
                       to_number(p_txmsg.txfields('15').value) * to_number(p_txmsg.txfields('10').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value),
                       p_txmsg.txfields('07').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                    plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                end if;
            end if;
            if p_txmsg.tltxcd = '8898' then
                if fn_SecuredUpdate('C',
                       to_number(p_txmsg.txfields('11').value) * to_number(p_txmsg.txfields('10').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value),
                       p_txmsg.txfields('07').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                    plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                end if;
            end if;
        else -- Reversal Transactions
            --  Xu ly Room:
            --1. Xu ly tieu khoan chuyen.
            if fn_markedafpralloc(p_txmsg.txfields('07').value,
                            null,
                            'A',
                            'T',
                            p_txmsg.txfields('03').value,
                            'N',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
            --2. Xu ly tieu khoan nhan.
            if fn_markedafpralloc(p_txmsg.txfields('08').value,
                            null,
                            'A',
                            'T',
                            p_txmsg.txfields('03').value,
                            'N',
                            'N',
                            to_date(p_txmsg.txdate,systemnums.c_date_format),
                            p_txmsg.txnum,
                            p_err_code) <> systemnums.C_SUCCESS then
                plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;

            --  Xu ly Pool:
            --1.    Xu ly tieu khoan chuyen:
            if p_txmsg.tltxcd = '8896' then
                if fn_SecuredUpdate('C',
                       (to_number(p_txmsg.txfields('14').value) + to_number(p_txmsg.txfields('15').value)) * to_number(p_txmsg.txfields('10').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value),
                       p_txmsg.txfields('08').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                    plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                end if;
            end if;
            if p_txmsg.tltxcd = '8898' then
                if fn_SecuredUpdate('C',
                       to_number(p_txmsg.txfields('11').value) * to_number(p_txmsg.txfields('10').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value),
                       p_txmsg.txfields('08').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                    plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                end if;
            end if;


            --2. Xu ly tieu khoan nhan:
            if p_txmsg.tltxcd = '8896' then
                if fn_SecuredUpdate('D',
                       to_number(p_txmsg.txfields('15').value) * to_number(p_txmsg.txfields('10').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value),
                       p_txmsg.txfields('07').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                    plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                end if;
            end if;
            if p_txmsg.tltxcd = '8898' then
                if fn_SecuredUpdate('D',
                       to_number(p_txmsg.txfields('11').value) * to_number(p_txmsg.txfields('10').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value),
                       p_txmsg.txfields('07').value, p_txmsg.txnum, p_txmsg.txdate, p_err_code) <> systemnums.c_success then
                    plog.setendsection(pkgctx, 'fn_txAutoAdhocUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                end if;
            end if;
        end if;
      -- Xu ly dac biet.
    END IF;

    plog.setendsection (pkgctx, 'fn_txAutoAdhocUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION when others then
    p_err_code:=errnums.C_SYSTEM_ERROR;
    plog.error(pkgctx,'error:'||p_err_code);
    plog.error (pkgctx, '[SQLERRM] ' || SQLERRM); --Log trace exception
    plog.error(pkgctx,'row:'||dbms_utility.format_error_backtrace);
    plog.setendsection (pkgctx, 'fn_txAutoAdhocUpdate');
    RETURN errnums.C_BIZ_RULE_INVALID;
END fn_txAutoAdhocUpdate;

/**
* Kiem tra nguon theo xu ly dac biet. Ham goi di theo giao dich.
**/
FUNCTION fn_txAutoAdhocCheck(p_txmsg in tx.msg_rectype, p_err_code out varchar2)
RETURN NUMBER
IS

l_count number;
l_maxdebt number;
l_amt number;
l_amt2 number;
l_actype varchar2(4);
l_type varchar2(100);
l_BrID  varchar2(4);
l_IsMarginAccount char(1);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAutoAdhocCheck');
    p_err_code:=systemnums.C_SUCCESS;
    IF p_txmsg.tltxcd in ('2200','2202','2232','2242','2243','2244','2250') THEN
        begin
            select
                sum (nvl(pr.prinused,0)* least(nvl(rsk2.mrpriceloan,0), sb.marginrefprice) * nvl(rsk2.mrratioloan,0) / 100)
                - sum((se.trade - nvl(sts.execsellqtty,0) + nvl(od.buyqtty,0) + nvl(sts.execbuyqtty,0)
                    - (case when se.codeid = p_txmsg.txfields('01').value then to_number(p_txmsg.txfields('10').value) else 0 end)) * least(nvl(rsk2.mrpriceloan,0), sb.marginrefprice) * nvl(rsk2.mrratioloan,0) / 100)
                ,
                sum (nvl(pr.sy_prinused,0)* least(nvl(rsk1.mrpriceloan,0), sb.marginprice) * nvl(rsk1.mrratioloan,0) / 100)
                - sum((se.trade - nvl(sts.execsellqtty,0) + nvl(od.buyqtty,0) + nvl(sts.execbuyqtty,0)
                    - (case when se.codeid = p_txmsg.txfields('01').value then to_number(p_txmsg.txfields('10').value) else 0 end)) * least(nvl(rsk1.mrpriceloan,0), sb.marginrefprice) * nvl(rsk1.mrratioloan,0) / 100)

                into l_amt, l_amt2
                from (select se.afacctno, se.codeid, af.actype, se.trade from semast se, afmast af, aftype aft, mrtype mrt
                        where se.afacctno = af.acctno and af.actype = aft.actype and aft.mrtype = mrt.actype and mrt.mrtype = 'T') se,
                     securities_info sb,
                     afserisk rsk1,afmrserisk rsk2,
                    (select afacctno, codeid,
                        sum(case when duetype = 'SS' then qtty - decode(status,'C',qtty,aqtty) else 0 end) execsellqtty,
                        sum(case when duetype = 'RS' then qtty - decode(status,'C',qtty,aqtty) else 0 end) execbuyqtty
                        from stschd
                        where duetype in ('SS','RS') and afacctno = p_txmsg.txfields('02').value and deltd <> 'Y'
                        group by afacctno, codeid) sts,
                    (select afacctno, codeid,
                        sum(case when exectype = 'NB' then remainqtty else 0 end) buyqtty
                        from odmast
                        where exectype = 'NB' and afacctno = p_txmsg.txfields('02').value and deltd <> 'Y'
                        group by afacctno, codeid) od,
                    (select afpr.afacctno, pr.codeid, sum(nvl(afpr.prinused,0)) prinused, sum(nvl(afpr.sy_prinused,0)) sy_prinused,
                       max(nvl(pr.roomlimit,0)) - sum(nvl(afpr.prinused,0)) pravllimit
                           from (select afacctno, codeid, sum(case when restype = 'M' then prinused else 0 end) prinused,
                                    sum(case when restype = 'S' then prinused else 0 end) sy_prinused
                                   from vw_afpralloc_all
                                   where afacctno = p_txmsg.txfields('02').value
                                   group by afacctno,codeid) afpr, vw_marginroomsystem pr
                           where afpr.codeid(+) = pr.codeid
                           group by afpr.afacctno, pr.codeid
                        ) pr
                where se.afacctno = p_txmsg.txfields('02').value
                and se.afacctno = sts.afacctno(+) and se.codeid = sts.codeid(+)
                and se.afacctno = od.afacctno(+) and se.codeid = od.codeid(+)
                and se.afacctno = pr.afacctno(+) and se.codeid = pr.codeid(+)
                and se.actype = rsk1.actype(+) and se.codeid = rsk1.codeid(+)
                and se.actype = rsk2.actype(+) and se.codeid = rsk2.codeid(+)
                and sb.codeid = se.codeid
                group by se.afacctno;
        exception when others then
            l_amt:=0;
            l_amt2:=0;
        end;
        if (l_amt > 0 and l_amt2 > 0) then
            p_err_code:= '-100523';
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;
    ELSIF p_txmsg.tltxcd in ('8876','8874') THEN

        select count(1) into l_count
        from cfmast cf, afmast af
        where cf.custid = af.custid
        and af.acctno = p_txmsg.txfields('03').value and cf.custatcom = 'Y'
        and af.poolchk='Y'; --GianhVG Chi check neu tai khoan can check pool

        if l_count > 0 then

            l_maxdebt:=to_number(cspks_system.fn_get_sysvar('MARGIN','MAXDEBT'));
            --Chi danh dau voi tai khoan Margin, co tuan thu muc he thong.
            select count(1) into l_count
            from afmast af, aftype aft, mrtype mrt, lntype lnt
            where af.actype = aft.actype and aft.mrtype = mrt.actype and mrt.mrtype = 'T'
            and aft.lntype = lnt.actype(+) and nvl(lnt.chksysctrl,'N') = 'Y' and af.acctno = p_txmsg.txfields('03').value;

            if l_count = 0 then
                l_IsMarginAccount:='N';
            else
                l_IsMarginAccount:='Y';
            end if;

            select
                least(-least(nvl(adv.avladvance,0)
                        + mst.balance
                        - mst.odamt
                        - mst.dfdebtamt
                        - mst.dfintdebtamt
                        - mst.depofeeamt
                        - NVL (advamt, 0)
                        - nvl(secureamt,0)
                        - ramt
                        - nvl(dealpaidamt,0)
                        - to_number(p_txmsg.txfields('11').value) * to_number(p_txmsg.txfields('12').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value),0),

                        to_number(p_txmsg.txfields('11').value) * to_number(p_txmsg.txfields('12').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value))
                into l_amt
            from cimast mst
                left join (select * from v_getbuyorderinfo where afacctno = p_txmsg.txfields('03').value) al on mst.acctno = al.afacctno
                left join (select sum(depoamt) avladvance,afacctno from v_getAccountAvlAdvance where afacctno = p_txmsg.txfields('03').value group by afacctno) adv on adv.afacctno=MST.acctno
                LEFT JOIN (select * from v_getdealpaidbyaccount p where p.afacctno = p_txmsg.txfields('03').value) pd on pd.afacctno=mst.acctno
            where mst.acctno = p_txmsg.txfields('03').value;
            plog.debug(pkgctx,'l_amt:'||l_amt);
            if l_amt > 0 then
                select actype, substr(acctno,1,4) into l_actype, l_BrID from afmast where acctno = p_txmsg.txfields('03').value;

                 FOR rec_pr IN (
                        SELECT DISTINCT pm.prcode, pm.prname, pm.prtyp, pm.codeid, pm.prlimit,
                                pm.prinused + fn_getExpectUsed(pm.prcode) prinused, pm.expireddt, pm.prstatus
                        FROM prmaster pm,  prtype prt, prtypemap prtm, typeidmap tpm, bridmap brm
                        WHERE pm.prcode = brm.prcode
                            AND pm.prcode = prtm.prcode
                            AND prt.actype = prtm.prtype
                            AND prt.actype = tpm.prtype
                            AND pm.prtyp = 'P'
                            AND ((prt.TYPE = 'AFTYPE') or (l_IsMarginAccount = 'Y' and prt.TYPE = 'SYSTEM'))
                            AND pm.prstatus = 'A'
                            AND tpm.typeid = decode(tpm.typeid,'ALL',tpm.typeid,l_actype)
                            AND brm.brid = decode(brm.brid,'ALL',brm.brid,l_BrID)
                               )
                 LOOP
                    if l_amt > least(rec_pr.prlimit,l_maxdebt) - rec_pr.prinused then
                       p_err_code := '-100522'; --Vuot qua nguon.
                       plog.debug(pkgctx,'PRCHK: [-100522]:Loi vuot qua nguon tien:' || p_err_code);
                       plog.setendsection(pkgctx, 'fn_txAutoAdhocCheck');
                       RETURN errnums.C_BIZ_RULE_INVALID;
                    end if;
                 end loop;
            end if;
        else
            --Xu ly neu Poolchk='N' thi check theo afmat.poollimit
            l_amt:=fn_getAvlAccountPoolLimit(p_txmsg.txfields('03').value, to_number(p_txmsg.txfields('11').value) * to_number(p_txmsg.txfields('12').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value));
            if l_amt <0 then
                p_err_code := '-100522'; --Vuot qua nguon.
                plog.debug(pkgctx,'PRCHK: [-100522]:Loi vuot qua nguon tien:' || p_err_code);
                plog.setendsection(pkgctx, 'fn_txAutoAdhocCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        end if;
    elsIF p_txmsg.tltxcd in ('8895') THEN
        select count(1) into l_count
        from cfmast cf, afmast af
        where cf.custid = af.custid
        and af.acctno = p_txmsg.txfields('08').value and cf.custatcom = 'Y'
        and af.poolchk='Y'; --GianhVG Chi check neu tai khoan can check pool;

        if l_count > 0 then

            l_maxdebt:=to_number(cspks_system.fn_get_sysvar('MARGIN','MAXDEBT'));
            --Chi danh dau voi tai khoan Margin, co tuan thu muc he thong.
            select count(1) into l_count
            from afmast af, aftype aft, mrtype mrt, lntype lnt
            where af.actype = aft.actype and aft.mrtype = mrt.actype and mrt.mrtype = 'T'
            and aft.lntype = lnt.actype(+) and nvl(lnt.chksysctrl,'N') = 'Y' and af.acctno = p_txmsg.txfields('08').value;
            --Neu Tieu khoan khong danh dau bat buoc tuan thu he thong hoac ko phai lai tieu khoan margin -> Khong can hach toan nguon.
            if l_count = 0 then
                --return systemnums.C_SUCCESS;
                l_IsMarginAccount:='N';
            else
                l_IsMarginAccount:='Y';
            end if;


            select
                least(-least(nvl(adv.avladvance,0)
                        + mst.balance
                        - mst.odamt
                        - mst.dfdebtamt
                        - mst.dfintdebtamt
                        - mst.depofeeamt
                        - NVL (advamt, 0)
                        - nvl(secureamt,0)
                        - ramt
                        - nvl(dealpaidamt,0)
                        - (to_number(p_txmsg.txfields('14').value)+to_number(p_txmsg.txfields('15').value)) * to_number(p_txmsg.txfields('10').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value),0),

                        (to_number(p_txmsg.txfields('14').value)+to_number(p_txmsg.txfields('15').value)) * to_number(p_txmsg.txfields('10').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value))
                into l_amt
            from cimast mst
            left join (select * from v_getbuyorderinfo where afacctno = p_txmsg.txfields('08').value) al on mst.acctno = al.afacctno
            left join (select sum(depoamt) avladvance,afacctno from v_getAccountAvlAdvance where afacctno = p_txmsg.txfields('08').value group by afacctno) adv on adv.afacctno=MST.acctno
            LEFT JOIN (select * from v_getdealpaidbyaccount p where p.afacctno = p_txmsg.txfields('08').value) pd on pd.afacctno=mst.acctno
            where mst.acctno = p_txmsg.txfields('08').value;
            plog.debug(pkgctx,'l_amt:'||l_amt);
            if l_amt > 0 then
                select actype, substr(acctno,1,4) into l_actype, l_BrID from afmast where acctno = p_txmsg.txfields('08').value;

                 FOR rec_pr IN (
                        SELECT DISTINCT pm.prcode, pm.prname, pm.prtyp, pm.codeid, pm.prlimit,
                                pm.prinused + fn_getExpectUsed(pm.prcode) prinused, pm.expireddt, pm.prstatus
                        FROM prmaster pm,  prtype prt, prtypemap prtm, typeidmap tpm, bridmap brm
                        WHERE pm.prcode = brm.prcode
                            AND pm.prcode = prtm.prcode
                            AND prt.actype = prtm.prtype
                            AND prt.actype = tpm.prtype
                            AND pm.prtyp = 'P'
                            AND ((prt.TYPE = 'AFTYPE') or (l_IsMarginAccount = 'Y' and prt.TYPE = 'SYSTEM'))
                            AND pm.prstatus = 'A'
                            AND tpm.typeid = decode(tpm.typeid,'ALL',tpm.typeid,l_actype)
                            AND brm.brid = decode(brm.brid,'ALL',brm.brid,l_BrID)
                               )
                 LOOP
                    if l_amt > least(rec_pr.prlimit,l_maxdebt) - rec_pr.prinused then
                       p_err_code := '-100522'; --Vuot qua nguon.
                       plog.debug(pkgctx,'PRCHK: [-100522]:Loi vuot qua nguon tien:' || p_err_code);
                       plog.setendsection(pkgctx, 'fn_txAutoAdhocCheck');
                       RETURN errnums.C_BIZ_RULE_INVALID;
                    end if;
                 end loop;
             end if;
         else
            --Xu ly neu Poolchk='N' thi check theo afmat.poollimit
            l_amt:=fn_getAvlAccountPoolLimit(p_txmsg.txfields('08').value, to_number(p_txmsg.txfields('14').value)+to_number(p_txmsg.txfields('15').value)) * to_number(p_txmsg.txfields('10').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value);
            if l_amt <0 then
                p_err_code := '-100522'; --Vuot qua nguon.
                plog.debug(pkgctx,'PRCHK: [-100522]:Loi vuot qua nguon tien:' || p_err_code);
                plog.setendsection(pkgctx, 'fn_txAutoAdhocCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
         end if;
    elsIF p_txmsg.tltxcd in ('8897') THEN
        select count(1) into l_count
        from cfmast cf, afmast af
        where cf.custid = af.custid
        and af.acctno = p_txmsg.txfields('08').value and cf.custatcom = 'Y'
        and af.poolchk='Y'; --GianhVG Chi check neu tai khoan can check pool
        if l_count > 0 then

            l_maxdebt:=to_number(cspks_system.fn_get_sysvar('MARGIN','MAXDEBT'));
            --Chi danh dau voi tai khoan Margin, co tuan thu muc he thong.
            select count(1) into l_count
            from afmast af, aftype aft, mrtype mrt, lntype lnt
            where af.actype = aft.actype and aft.mrtype = mrt.actype and mrt.mrtype = 'T'
            and aft.lntype = lnt.actype(+) and nvl(lnt.chksysctrl,'N') = 'Y' and af.acctno = p_txmsg.txfields('08').value;
            --Neu Tieu khoan khong danh dau bat buoc tuan thu he thong hoac ko phai lai tieu khoan margin -> Khong can hach toan nguon.
            if l_count = 0 then
                --return systemnums.C_SUCCESS;
                l_IsMarginAccount:='N';
            else
                l_IsMarginAccount:='Y';
            end if;

            select
                least(-least(nvl(adv.avladvance,0)
                        + mst.balance
                        - mst.odamt
                        - mst.dfdebtamt
                        - mst.dfintdebtamt
                        - mst.depofeeamt
                        - NVL (advamt, 0)
                        - nvl(secureamt,0)
                        - ramt
                        - nvl(dealpaidamt,0)
                        - (to_number(p_txmsg.txfields('11').value)) * to_number(p_txmsg.txfields('10').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value),0),

                        (to_number(p_txmsg.txfields('11').value)) * to_number(p_txmsg.txfields('10').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value))
                into l_amt
            from cimast mst
            left join (select * from v_getbuyorderinfo where afacctno = p_txmsg.txfields('08').value) al on mst.acctno = al.afacctno
            left join (select sum(depoamt) avladvance,afacctno from v_getAccountAvlAdvance where afacctno = p_txmsg.txfields('08').value group by afacctno) adv on adv.afacctno=MST.acctno
            LEFT JOIN (select * from v_getdealpaidbyaccount p where p.afacctno = p_txmsg.txfields('08').value) pd on pd.afacctno=mst.acctno
            where mst.acctno = p_txmsg.txfields('08').value;
            plog.debug(pkgctx,'l_amt:'||l_amt);
            if l_amt > 0 then
                select actype, substr(acctno,1,4) into l_actype, l_BrID from afmast where acctno = p_txmsg.txfields('08').value;

                 FOR rec_pr IN (
                        SELECT DISTINCT pm.prcode, pm.prname, pm.prtyp, pm.codeid, pm.prlimit,
                                pm.prinused + fn_getExpectUsed(pm.prcode) prinused, pm.expireddt, pm.prstatus
                        FROM prmaster pm,  prtype prt, prtypemap prtm, typeidmap tpm, bridmap brm
                        WHERE pm.prcode = brm.prcode
                            AND pm.prcode = prtm.prcode
                            AND prt.actype = prtm.prtype
                            AND prt.actype = tpm.prtype
                            AND pm.prtyp = 'P'
                            AND ((prt.TYPE = 'AFTYPE') or (l_IsMarginAccount = 'Y' and prt.TYPE = 'SYSTEM'))
                            AND pm.prstatus = 'A'
                            AND tpm.typeid = decode(tpm.typeid,'ALL',tpm.typeid,l_actype)
                            AND brm.brid = decode(brm.brid,'ALL',brm.brid,l_BrID)
                               )
                 LOOP
                    if l_amt > least(rec_pr.prlimit,l_maxdebt) - rec_pr.prinused then
                       p_err_code := '-100522'; --Vuot qua nguon.
                       plog.debug(pkgctx,'PRCHK: [-100522]:Loi vuot qua nguon tien:' || p_err_code);
                       plog.setendsection(pkgctx, 'fn_txAutoAdhocCheck');
                       RETURN errnums.C_BIZ_RULE_INVALID;
                    end if;
                 end loop;
             end if;
            -- Xu ly dac biet.
         else
            --Xu ly neu Poolchk='N' thi check theo afmat.poollimit
            l_amt:=fn_getAvlAccountPoolLimit(p_txmsg.txfields('08').value, to_number(p_txmsg.txfields('11').value)) * to_number(p_txmsg.txfields('10').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value);
            if l_amt <0 then
                p_err_code := '-100522'; --Vuot qua nguon.
                plog.debug(pkgctx,'PRCHK: [-100522]:Loi vuot qua nguon tien:' || p_err_code);
                plog.setendsection(pkgctx, 'fn_txAutoAdhocCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        END IF;
    end if;
    plog.setendsection (pkgctx, 'fn_txAutoAdhocCheck');
    RETURN systemnums.C_SUCCESS;
EXCEPTION when others then
    p_err_code:=errnums.C_SYSTEM_ERROR;
    plog.error(pkgctx,'error:'||p_err_code);
    plog.error (pkgctx, '[SQLERRM] ' || SQLERRM); --Log trace exception
    plog.error(pkgctx,'row:'||dbms_utility.format_error_backtrace);
    plog.setendsection (pkgctx, 'fn_txAutoAdhocCheck');
    RETURN errnums.C_BIZ_RULE_INVALID;
END fn_txAutoAdhocCheck;

/**
* Cap nhat gia tri nguon du tinh theo xu ly dac biet. Ham goi Adhoc.
**/
FUNCTION fn_txAdhocUpdate(p_id IN VARCHAR2,
            p_acctno IN VARCHAR2, p_codeid IN VARCHAR2,
            p_refid IN VARCHAR2,
            p_qtty IN NUMBER, p_amt IN NUMBER,
            p_brid IN VARCHAR2,
            p_type IN VARCHAR2, p_actype IN VARCHAR2,
            p_txnum IN VARCHAR2, p_txdate IN DATE,
            p_deltd IN VARCHAR2,
            p_err_code out varchar2)
RETURN NUMBER
IS
l_count NUMBER;
l_TotalUsedQtty NUMBER;
l_AcType varchar2(4);
l_sumexecqtty NUMBER;
l_trade NUMBER;
l_UsedQtty NUMBER;
l_UsedAmt NUMBER;

l_CurrDate  DATE;
l_ClearDate DATE;
l_AIntRate NUMBER;
l_AMinBal NUMBER;
l_AFeeBank NUMBER;
l_AMinFeeBank NUMBER;
l_brid varchar2(4);
l_parameters varchar2(4000);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAdhocUpdate');
    begin
      l_parameters:=('p_id:' || p_id || ' p_acctno:' || p_acctno || ' p_refid:' || p_refid || ' p_qtty:' || p_qtty|| ' p_brid:' || p_brid
                           || ' p_type:' || p_type || ' p_actype:' || p_actype|| ' p_txnum:' || p_txnum|| ' p_txdate:' || p_txdate|| ' p_deltd:' || p_deltd);
    exception when others then
      l_parameters:='';
    end;
    p_err_code:=systemnums.C_SUCCESS;
    l_CurrDate:= to_date(cspks_system.fn_get_sysvar('SYSTEM', 'CURRDATE'),systemnums.c_date_format);
    l_AIntRate:= to_number(cspks_system.fn_get_sysvar('SYSTEM', 'AINTRATE'));
    l_AMinBal:= to_number(cspks_system.fn_get_sysvar('SYSTEM', 'AMINBAL'));
    l_AFeeBank:= to_number(cspks_system.fn_get_sysvar('SYSTEM', 'AFEEBANK'));
    l_AMinFeeBank:= to_number(cspks_system.fn_get_sysvar('SYSTEM', 'AMINFEEBANK'));

    l_TotalUsedQtty:=0;
    IF p_id = 'SELLORDERMATCH' THEN
/*
    --Fire this event BEFORE increase match qtty ON odmast.
    --p_refid IS ORDER ID.
    --p_qtty IS match quantity
    --p_amt IS match amount
*/
        --Xac dinh deal ban.
        SELECT sum(execqtty) INTO l_sumexecqtty
        FROM odmast
        WHERE txdate = l_CurrDate AND exectype IN ('MS','NS') AND execqtty > 0
        AND afacctno = p_acctno AND codeid = p_codeid;

        select substr(p_acctno,1,4) into l_brid from dual;

        l_sumexecqtty:=l_sumexecqtty - p_qtty;
        -- Over deal
        FOR rec_ovd IN
        (
            SELECT dfqtty, nml, ovd, df.actype, (dfqtty + blockqtty + rcvqtty + carcvqtty + rlsqtty) orgqtty,
            rlsqtty, rlsamt,
            (dfqtty + blockqtty + rcvqtty + carcvqtty) remainqtty
            FROM dfmast df, lnschd ls, securities_info sb
            WHERE df.lnacctno = ls.acctno AND ls.reftype = 'P' AND df.dfqtty > 0
            AND df.afacctno = p_acctno AND df.codeid = p_codeid
            AND sb.codeid = df.codeid
            AND ((flagtrigger = 'T' OR sb.basicprice <= df.triggerprice) OR (ls.overduedate <= l_CurrDate))
            order BY CASE WHEN flagtrigger = 'T' OR sb.basicprice <= df.triggerprice THEN 0
                            WHEN ls.overduedate < l_CurrDate THEN 1
                            WHEN ls.overduedate = l_CurrDate THEN 2
                            ELSE 3 END,
                     ls.overduedate
        )
        LOOP
            IF l_sumexecqtty >= 0 THEN
                l_sumexecqtty:=l_sumexecqtty - rec_ovd.dfqtty;
            END IF;
            if l_sumexecqtty < 0 AND p_qtty > l_TotalUsedQtty then  -- Gia tri khop roi vao deal ban bi canh bao
                l_UsedQtty:= least(p_qtty - l_TotalUsedQtty, CASE WHEN l_TotalUsedQtty = 0 THEN -l_sumexecqtty ELSE rec_ovd.dfqtty END);
                l_UsedAmt:= greatest((rec_ovd.nml + rec_ovd.ovd) - ((rec_ovd.nml + rec_ovd.ovd + rec_ovd.rlsamt)
                                                            / rec_ovd.orgqtty
                                                            * (rec_ovd.remainqtty - l_UsedQtty)),
                                    0);
                l_TotalUsedQtty:= l_TotalUsedQtty + l_UsedQtty;

                --room: l_UsedQtty
                IF fn_SecuredUpdate(p_txnum, p_txdate, p_deltd,
                            'C', l_UsedQtty, p_acctno, p_codeid, 'R', 'DFTYPE', rec_ovd.actype, l_brid, p_refid, p_err_code)
                    <> systemnums.c_success THEN
                    p_err_code:=errnums.c_system_error;
                    plog.setendsection (pkgctx, 'fn_txAdhocUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                END IF;
                --pool: (rec_ovd.nml + rec_ovd.ovd) - (rec_ovd.nml + rec_ovd.ovd + rec_ovd.rlsamt) / rec_ovd.orgqtty * (rec_ovd.remainqtty - l_UsedQtty)
                IF fn_SecuredUpdate(p_txnum, p_txdate, p_deltd,
                            'C', l_UsedAmt, p_acctno, p_codeid, 'P', 'DFTYPE', rec_ovd.actype, l_brid, p_refid, p_err_code)
                    <> systemnums.c_success THEN
                    p_err_code:=errnums.c_system_error;
                    plog.setendsection (pkgctx, 'fn_txAdhocUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                END IF;
            END IF;
        END LOOP;
        -- normal trade
        IF l_sumexecqtty > 0 OR p_qtty > l_TotalUsedQtty THEN
            SELECT trade INTO l_trade FROM semast WHERE afacctno = p_acctno and codeid = p_codeid;
            l_sumexecqtty:=l_sumexecqtty - l_trade;
            l_TotalUsedQtty:=l_TotalUsedQtty + least((p_qtty - l_TotalUsedQtty),l_trade);
        END IF;
        -- normal deal
        IF l_sumexecqtty > 0 OR p_qtty > l_TotalUsedQtty THEN
            FOR rec_nml IN
            (
                SELECT dfqtty, nml, ovd, df.actype, (dfqtty + blockqtty + rcvqtty + carcvqtty + rlsqtty) orgqtty,
                    rlsqtty, rlsamt,
                    (dfqtty + blockqtty + rcvqtty + carcvqtty) remainqtty
                FROM dfmast df, lnschd ls, securities_info sb
                WHERE df.lnacctno = ls.acctno AND ls.reftype = 'P' AND df.dfqtty > 0
                AND df.afacctno = p_acctno AND df.codeid = p_codeid
                AND sb.codeid = df.codeid
                AND flagtrigger <> 'T' AND sb.basicprice > df.triggerprice AND ls.overduedate > l_CurrDate
                order BY ls.overduedate
            )
            LOOP
                IF l_sumexecqtty >= 0 THEN
                    l_sumexecqtty:=l_sumexecqtty - rec_nml.dfqtty;
                END IF;
                if l_sumexecqtty < 0 AND p_qtty > l_TotalUsedQtty then  -- Gia tri khop roi vao deal ban bi canh bao
                    l_UsedQtty:= least(p_qtty - l_TotalUsedQtty, CASE WHEN l_TotalUsedQtty = 0 THEN -l_sumexecqtty ELSE rec_nml.dfqtty END);
                    l_UsedAmt:= greatest((rec_nml.nml + rec_nml.ovd) - ((rec_nml.nml + rec_nml.ovd + rec_nml.rlsamt)
                                                                / rec_nml.orgqtty
                                                                * (rec_nml.remainqtty - l_UsedQtty)),
                                        0);
                    l_TotalUsedQtty:= l_TotalUsedQtty + l_UsedQtty;
                    -- Tim nguon.
                    --room: l_UsedQtty
                    IF fn_SecuredUpdate(p_txnum, p_txdate, p_deltd,
                                'C', l_UsedQtty, p_acctno, p_codeid, 'R', 'DFTYPE', rec_nml.actype, l_brid, p_refid, p_err_code)
                        <> systemnums.c_success THEN
                        p_err_code:=errnums.c_system_error;
                        plog.setendsection (pkgctx, 'fn_txAdhocUpdate');
                        RETURN errnums.C_BIZ_RULE_INVALID;
                    END IF;
                    --pool: (rec_ovd.nml + rec_ovd.ovd) - (rec_ovd.nml + rec_ovd.ovd + rec_ovd.rlsamt) / rec_ovd.orgqtty * (rec_ovd.remainqtty - l_UsedQtty)
                    IF fn_SecuredUpdate(p_txnum, p_txdate, p_deltd,
                                'C', l_UsedAmt, p_acctno, p_codeid, 'P', 'DFTYPE', rec_nml.actype, l_brid, p_refid, p_err_code)
                        <> systemnums.c_success THEN
                        p_err_code:=errnums.c_system_error;
                        plog.setendsection (pkgctx, 'fn_txAdhocUpdate');
                        RETURN errnums.C_BIZ_RULE_INVALID;
                    END IF;
                END IF;
            END LOOP;
        END IF;

    ELSIF p_id = 'BUYORDERMATCH' THEN
-- Margin Loan Matching Order
/*
    --Fire this event BEFORE increase match qtty ON odmast.
    --p_refid IS ORDER ID.
    --p_qtty IS match quantity
    --p_amt IS match amount
*/
        --chi xet cho margin loan thoi.
        BEGIN
            SELECT aft.dftype INTO l_actype FROM afmast af, aftype aft, mrtype mrt
            WHERE af.actype = aft.actype AND aft.mrtype = mrt.actype AND mrt.mrtype = 'L' AND af.acctno = p_acctno;
        EXCEPTION WHEN OTHERS THEN
            plog.setendsection (pkgctx, 'fn_txAdhocUpdate');
            RETURN systemnums.C_SUCCESS;
        END;

        -- Xac dinh so tien du tinh giai ngan cho lenh khop margin loan.
        l_UsedQtty:= p_qtty;
        SELECT p_amt * (1 + nvl(odt.deffeerate,0)/100 - od.bratio/100) INTO l_UsedAmt
        FROM odmast od, odtype odt
        WHERE od.actype = odt.actype(+) AND od.exectype IN ('NB') AND orderid = p_refid;


        IF l_UsedAmt = 0 AND l_UsedQtty = 0 THEN
            plog.setendsection (pkgctx, 'fn_txAdhocUpdate');
            RETURN systemnums.C_SUCCESS;
        END IF;

        -- Tim nguon.
        --room: l_UsedQtty
        IF fn_SecuredUpdate(p_txnum, p_txdate, 'N',
                    'D', l_UsedQtty, p_acctno, p_codeid, 'R', 'DFTYPE', l_actype, l_brid, p_refid, p_err_code)
            <> systemnums.c_success THEN
            p_err_code:=errnums.c_system_error;
            plog.setendsection (pkgctx, 'fn_txAdhocUpdate');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;
        --pool: (rec_ovd.nml + rec_ovd.ovd) - (rec_ovd.nml + rec_ovd.ovd + rec_ovd.rlsamt) / rec_ovd.orgqtty * (rec_ovd.remainqtty - l_UsedQtty)
        IF fn_SecuredUpdate(p_txnum, p_txdate, 'N',
                    'D', l_UsedAmt, p_acctno, p_codeid, 'P', 'DFTYPE', l_actype, l_brid, p_refid, p_err_code)
            <> systemnums.c_success THEN
            p_err_code:=errnums.c_system_error;
            plog.setendsection (pkgctx, 'fn_txAdhocUpdate');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;

    END IF;

    plog.setendsection (pkgctx, 'fn_txAdhocUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION when others THEN
    p_err_code:=errnums.C_SYSTEM_ERROR;
    plog.error(pkgctx,'error:'||p_err_code);
    plog.error (pkgctx, '[l_parameters] ' || l_parameters); --Log trace exception
    plog.error (pkgctx, '[SQLERRM] ' || SQLERRM); --Log trace exception
    plog.error(pkgctx,'row:'||dbms_utility.format_error_backtrace);
    plog.setendsection (pkgctx, 'fn_txAdhocUpdate');
    RETURN errnums.C_BIZ_RULE_INVALID;
END fn_txAdhocUpdate;

/**
* Kiem tra nguon theo xu ly dac biet. Ham goi Adhoc.
**/
FUNCTION fn_txAdhocCheck(p_id IN VARCHAR2,
            p_acctno IN VARCHAR2, p_codeid IN VARCHAR2,
            p_refid IN VARCHAR2,
            p_qtty IN NUMBER, p_amt IN NUMBER,
            p_brid IN VARCHAR2,
            p_type in VARCHAR2, p_actype IN VARCHAR2,
            p_txnum IN VARCHAR2, p_txdate IN DATE,
            p_deltd IN VARCHAR2,
            p_err_code out varchar2)
RETURN NUMBER
IS
l_parameters varchar2(4000);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAdhocCheck');
    begin
      l_parameters:=('p_id:' || p_id || ' p_acctno:' || p_acctno || ' p_refid:' || p_refid || ' p_qtty:' || p_qtty|| ' p_brid:' || p_brid
                     || 'p_type:' || p_type || ' p_actype:' || p_actype || ' p_txnum:' || p_txnum || ' p_txdate:' || p_txdate|| ' p_deltd:' || p_deltd);
    exception when others then
      l_parameters:='';
    end;
    IF p_id = '######' THEN
        NULL;
    END IF;
    plog.setendsection (pkgctx, 'fn_txAdhocCheck');
    RETURN systemnums.C_SUCCESS;
EXCEPTION when others then
    plog.error(pkgctx,'error:'||p_err_code);
    plog.error (pkgctx, '[l_parameters] ' || l_parameters); --Log trace exception
    plog.error(pkgctx,'row:'||dbms_utility.format_error_backtrace);
    plog.setendsection (pkgctx, 'fn_txAdhocCheck');
    RETURN errnums.C_BIZ_RULE_INVALID;
END fn_txAdhocCheck;


FUNCTION fn_txAutoCheck(p_txmsg in tx.msg_rectype, p_err_code out varchar2)
RETURN NUMBER
IS
        l_tltxcd PRCHK.tltxcd%TYPE;
        l_type PRCHK.TYPE%TYPE;
        l_typeid PRCHK.typeid%TYPE;
        l_typefldcd PRCHK.typefldcd%TYPE;
        l_bridtype PRCHK.bridtype%TYPE;
        l_prtype PRCHK.prtype%TYPE;
        l_accfldcd PRCHK.accfldcd%TYPE;
        l_dorc PRCHK.dorc%TYPE;
        l_amtexp PRCHK.amtexp%TYPE;
        l_acctno varchar2(30);
        l_brid varchar2(4);
        l_actype varchar2(10);
        l_value number(20,4);
        l_busdate DATE;
        l_codeid  varchar2(10);
        l_limitcheck number(20,0);
        l_hoststs char(1);
        l_count NUMBER;
        l_IsMarginAccount varchar2(1);
        l_lnaccfldcd varchar2(20);
        l_lntypefldcd varchar2(20);
        l_lntype varchar2(4);
        l_amt number;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAutoCheck');

    -- EXCEPTION NO CHECK POOL/ROOM WHEN RUN batch.
    SELECT varvalue INTO l_hoststs FROM sysvar WHERE varname = 'HOSTATUS' AND grname = 'SYSTEM';
    IF l_hoststs = '0' THEN
        plog.setendsection (pkgctx, 'fn_txAutoCheck');
        RETURN systemnums.C_SUCCESS;
    END IF;
    -- END EXCEPTION NO CHECK POOL/ROOM WHEN RUN batch.

    IF fn_txAutoAdhocCheck(p_txmsg, p_err_code) <> systemnums.C_SUCCESS THEN
        plog.setendsection (pkgctx, 'fn_txAutoCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;

    -- Get busdate
    SELECT to_date(varvalue,'DD/MM/RRRR') INTO l_busdate FROM sysvar WHERE varname = 'CURRDATE' AND grname = 'SYSTEM';

    FOR i IN
        (
            SELECT a.tltxcd, a.chktype, a.type, a.typeid, a.bridtype, a.prtype, a.accfldcd, a.dorc, a.amtexp, a.typefldcd, a.lnaccfldcd, a.lntypefldcd
            FROM prchk a WHERE a.tltxcd = p_txmsg.tltxcd and a.chktype='I' AND a.deltd <> 'Y' ORDER BY a.odrnum
        )
    LOOP
        l_tltxcd:=i.tltxcd;
        l_type:=i.TYPE;
        l_typeid:=i.typeid;
        l_typefldcd:=i.typefldcd;
        l_bridtype:=i.bridtype;
        l_prtype:=i.prtype;
        l_accfldcd:=i.accfldcd;
        l_dorc:=i.dorc;
        l_amtexp:=i.amtexp;
        l_lnaccfldcd:=i.lnaccfldcd;
        l_lntypefldcd:=i.lntypefldcd;
        --plog.debug (pkgctx, 'kiem tra cho Pool room cho giao dich:' || i.tltxcd);
        --TK CHECK pool room. (CI OR SE account)
        IF NOT l_accfldcd IS NULL AND length(l_accfldcd) > 0 THEN
            IF instr(l_accfldcd,'&') > 0 THEN
                l_acctno:= p_txmsg.txfields(substr(l_accfldcd,0,2)).value || p_txmsg.txfields(ltrim(substr(l_accfldcd,3),'&')).value;
            ELSE
                l_acctno:= p_txmsg.txfields(l_accfldcd).value;
            END IF;
        END IF;

        --Lay tham so chi nhanh. SBS don't use this parameter.
        IF l_bridtype = '0' THEN        --noi mo hop dong
            l_brid:= substr(l_acctno,0,4);
        ELSIF l_bridtype = '1' THEN     --noi lam giao dich
            l_brid:=p_txmsg.brid;
        ELSIF l_bridtype = '2' THEN     --careby tieu khoan.
            BEGIN
                SELECT tl.brid INTO l_brid
                FROM afmast af, tlprofiles tl
                WHERE af.tlid = tl.tlid AND af.acctno = substr(l_acctno,0,10);
            EXCEPTION WHEN OTHERS THEN
                l_brid:= substr(l_acctno,0,4);
            END;
            l_brid:=nvl(l_brid,substr(l_acctno,0,4));
        END IF;

        --Lay ma loai hinh san pham.
        IF NOT l_typeid IS NULL AND length(l_typeid) > 0 THEN
            -- get XXTYPE FROM XXMAST WHERE XXACCTNO = l_typeid
            IF l_type = 'DFTYPE' THEN
                SELECT actype INTO l_actype FROM dfmast WHERE acctno = p_txmsg.txfields(l_typeid).value;
            ELSIF l_type = 'LNTYPE' THEN
                SELECT actype INTO l_actype FROM lnmast WHERE acctno = p_txmsg.txfields(l_typeid).value;
            ELSIF l_type = 'CITYPE' THEN
                SELECT actype INTO l_actype FROM cimast WHERE acctno = p_txmsg.txfields(l_typeid).value;
            ELSIF l_type = 'SETYPE' THEN
                SELECT actype INTO l_actype FROM semast WHERE acctno = p_txmsg.txfields(l_typeid).value;
            ELSIF l_type = 'AFTYPE' THEN
                SELECT actype INTO l_actype FROM afmast WHERE acctno = p_txmsg.txfields(l_typeid).value;
            end if;
        elsif not l_typefldcd is null and length(l_typefldcd) > 0 then
            --Get ACTYPE direct FROM Transactions.
            l_actype:= p_txmsg.txfields(l_typefldcd).value;
        END IF;
        --lay amount
        IF length(l_amtexp) > 0 THEN
            l_value:= fn_parse_amtexp(p_txmsg,l_amtexp);
        ELSE
            l_value:= 0;
        END IF;
        --lay CodeID.
        l_codeid:= substr(l_acctno,11,6);

        --Lay LNTYPE tu [LNACCFLDCD] or [LNTYPEFLDCD]
        if length(trim(l_lnaccfldcd))>0 then
            begin
                select actype into l_lntype from lnmast where acctno = p_txmsg.txfields(l_lnaccfldcd).value;
            exception when others then
                l_lntype:='XXXX';
            end;
        end if;
        if length(trim(l_lntypefldcd))>0 then
            begin
                l_lntype:= p_txmsg.txfields(l_lntypefldcd).value;
            exception when others then
                l_lntype:='XXXX';
            end;
        end if;
/*
        plog.debug(pkgctx,'l_prtype:'||l_prtype);
        plog.debug(pkgctx,'l_codeid:'||l_codeid);
        plog.debug(pkgctx,'l_type:'||l_type);
        plog.debug(pkgctx,'l_actype:'||l_actype);
        plog.debug(pkgctx,'l_brid:'||l_brid);
        plog.debug(pkgctx,'l_busdate:'||l_busdate);
        plog.debug(pkgctx,'l_acctno:'||l_acctno);
*/

/*
        SELECT count(1) into l_count
            FROM prmaster pm, prtype prt, prtypemap prtm, typeidmap tpm, bridmap brm
            WHERE pm.prcode = brm.prcode
                AND pm.prcode = prtm.prcode
                AND prt.actype = prtm.prtype
                AND prt.actype = tpm.prtype
                AND pm.codeid = decode(l_prtype,'R',l_codeid,pm.codeid) --neu la room chung khoan, lay codeid chung khoan tu giao dich. Nguoc lai
                AND pm.prtyp = l_prtype
                AND prt.TYPE = l_type
                AND pm.prstatus = 'A'
                AND tpm.typeid = decode(tpm.typeid,'ALL',tpm.typeid,l_actype)
                AND brm.brid = decode(brm.brid,'ALL',brm.brid,l_brid);
        IF l_count = 0 THEN
            -- Khong thuoc nguon. Tra ve ma loi.
            p_err_code:='-100535';        --Vuot qua nguon.
            plog.debug(pkgctx,'PRCHK: [-100535]:Khong thuoc loai nguon nao?:'||p_err_code);
        END IF;
*/
        --Danh dau pool
        --Neu Tieu khoan khong danh dau bat buoc tuan thu he thong hoac ko phai lai tieu khoan margin -> Khong can hach toan nguon POOL SYSTEM.
        select count(1) into l_count
        from afmast af, aftype aft, mrtype mrt, lntype lnt1
        where af.actype = aft.actype and aft.mrtype = mrt.actype and mrt.mrtype = 'T'
            and aft.lntype = lnt1.actype(+) and af.acctno = substr(l_acctno,0,10)
            and ((nvl(lnt1.chksysctrl,'N') = 'Y' and nvl(lnt1.actype,'ZZZZ') = l_lntype)
                or
                exists (select 1 from afidtype afi, lntype lnt2
                        where afi.actype = lnt2.actype and afi.objname = 'LN.LNTYPE' and afi.aftype = aft.actype and lnt2.actype = l_lntype and lnt2.chksysctrl= 'Y'));

        if l_count = 0 then
            l_IsMarginAccount:='N';
        else
            l_IsMarginAccount:='Y';
        end if;

        --Kiem tra theo san pham: l_actype; l_type; l_brid; l_codeid (chi xai cho tai khoan tien)
        FOR rec IN
        (
            SELECT DISTINCT pm.prcode, pm.prtyp, pm.codeid, pm.prlimit,
                    pm.prinused
            FROM prmaster pm, prtype prt, prtypemap prtm, typeidmap tpm, bridmap brm
            WHERE pm.prcode = brm.prcode
                AND pm.prcode = prtm.prcode
                AND prt.actype = prtm.prtype
                AND prt.actype = tpm.prtype
                AND pm.codeid = decode(l_prtype,'R',l_codeid,pm.codeid)
                AND pm.prtyp = l_prtype
                AND (prt.TYPE = l_type
                        or (prt.type = 'SYSTEM' and l_IsMarginAccount = 'Y' and l_prtype = 'P'))
                AND tpm.typeid = decode(tpm.typeid,'ALL',tpm.typeid,l_actype)
                AND pm.prstatus = 'A'
                AND brm.brid = decode(brm.brid,'ALL',brm.brid,l_brid)
        )
        LOOP
            --CHECK: IF IS FALSE --> RETURN SUCCESSFUL!
            IF NOT fn_IsPRCheck (p_txmsg, l_acctno, rec.prcode, l_prtype, 'C') THEN
                plog.debug(pkgctx,'fn_IsPRCheck:FALSE;');
                CONTINUE;
            END IF;

            --GianhVG check cho truong hop khong check nguon he thong, check nguon dac biet
            if l_prtype='P' then --Kiem soat pool theo tieu khoan
                select count(1) into l_count
                from cfmast cf, afmast af
                where cf.custid = af.custid
                and cf.custatcom = 'Y'
                and af.poolchk = 'N'
                and af.acctno = substr(l_acctno,0,10);
                if l_count>0 then
                    --Xu ly neu Poolchk='N' thi check theo afmat.poollimit
                    l_amt:=fn_getAvlAccountPoolLimit(substr(l_acctno,0,10), l_limitcheck);
                    if l_amt <0 then
                        p_err_code := '-100522'; --Vuot qua nguon.
                        plog.debug(pkgctx,'PRCHK: [-100522]:Loi vuot qua nguon tien:' || p_err_code);
                        plog.setendsection(pkgctx, 'fn_txAutoAdhocCheck');
                        RETURN errnums.C_BIZ_RULE_INVALID;
                    end if;
                    CONTINUE;
                end if;
            end if;
            -- get limitcheck remain ON pool/room
            l_limitcheck:=fn_getCurrentPR(p_txmsg, rec.prcode,rec.prtyp, substr(l_acctno,0,10), l_codeid);
            plog.debug(pkgctx,'Limit check:'|| l_limitcheck);

            -- Thuc hien kiem tra nguon.
            IF l_dorc = 'D' THEN -- Giao dich lam giam, check nguon kha dung
                IF p_txmsg.deltd <> 'Y' THEN -- normal transactions
                    IF l_value > l_limitcheck THEN
                        IF l_prtype = 'P' THEN
                            p_err_code:='-100522';        --Vuot qua nguon.
                            plog.debug(pkgctx,'PRCHK: [-100522]:Loi vuot qua nguon tien:'||p_err_code);
                        ELSE -- reverse transactions
                            p_err_code:='-100523';        --Vuot qua nguon.
                            plog.debug(pkgctx,'PRCHK: [-100523]:Loi vuot qua nguon chung khoan:'||p_err_code);
                        END IF;
                        plog.setendsection (pkgctx, 'fn_txAutoCheck');
                        RETURN errnums.C_BIZ_RULE_INVALID;
                    END IF;
                END IF;
            ELSIF l_dorc = 'C' THEN -- Giao dich lam tang, truong hop DELETE kiem tra nguon.
                IF p_txmsg.deltd <> 'Y' THEN -- normal transactions
                    NULL;
                ELSE -- reverse transations
                    --Neu xoa giao dich ghi tang, phai kiem tra nguon truoc moi cho xoa.
                    IF l_value > l_limitcheck THEN
                        IF l_prtype = 'P' THEN
                            p_err_code:='-100522';        --Vuot qua nguon.
                            plog.debug(pkgctx,'PRCHK: [-100522]:Loi vuot qua nguon tien:'||p_err_code);
                        ELSE
                            p_err_code:='-100523';        --Vuot qua nguon.
                            plog.debug(pkgctx,'PRCHK: [-100522]:Loi vuot qua nguon chung khoan:'||p_err_code);
                        END IF;
                        plog.setendsection (pkgctx, 'fn_txAutoCheck');
                        RETURN errnums.C_BIZ_RULE_INVALID;
                    END IF;
                END IF;
            END IF;

        END LOOP;

        -- Check for System Room:
        -- << BEGIN
        if l_prtype = 'R' then
            -- 1. Get Current Avail Room:
            select greatest(syroomlimit - syroomused - nvl(sy_prinused,0),0) into l_limitcheck
            from securities_info se, (select codeid, sum(prinused) sy_prinused from vw_afpralloc_all where restype = 'S' group by codeid) vw
            where se.codeid = vw.codeid(+) and se.codeid = l_codeid;
            -- 2. Check on PRCHK Rules:
            IF l_dorc = 'D' THEN -- Giao dich lam giam, check nguon kha dung
                IF p_txmsg.deltd <> 'Y' THEN -- normal transactions
                    IF l_value > l_limitcheck THEN
                        p_err_code:='-100523';        --Vuot qua nguon.
                        plog.debug(pkgctx,'PRCHK: [-100523]:Loi vuot qua nguon chung khoan:'||p_err_code);
                        plog.setendsection (pkgctx, 'fn_txAutoCheck');
                        RETURN errnums.C_BIZ_RULE_INVALID;
                    END IF;
                END IF;
            ELSIF l_dorc = 'C' THEN -- Giao dich lam tang, truong hop DELETE kiem tra nguon.
                IF p_txmsg.deltd <> 'Y' THEN -- normal transactions
                    NULL;
                ELSE -- reverse transations
                    --Neu xoa giao dich ghi tang, phai kiem tra nguon truoc moi cho xoa.
                    IF l_value > l_limitcheck THEN
                        p_err_code:='-100523';        --Vuot qua nguon.
                        plog.debug(pkgctx,'PRCHK: [-100522]:Loi vuot qua nguon chung khoan:'||p_err_code);
                        plog.setendsection (pkgctx, 'fn_txAutoCheck');
                        RETURN errnums.C_BIZ_RULE_INVALID;
                    END IF;
                END IF;
            END IF;
        end if;
        -- END >>
    END LOOP;
    plog.setendsection (pkgctx, 'fn_txAutoCheck');
    RETURN systemnums.C_SUCCESS;
EXCEPTION when others then
    p_err_code:='-1';
    plog.error (pkgctx, '[SQLERRM] ' || SQLERRM); --Log trace exception
    plog.error(pkgctx,'error:'||p_err_code || dbms_utility.format_error_backtrace);
    plog.setendsection (pkgctx, 'fn_txAutoCheck');
    RETURN errnums.C_BIZ_RULE_INVALID;
END fn_txAutoCheck;


FUNCTION fn_txAutoUpdate(p_txmsg in tx.msg_rectype, p_err_code out varchar2)
RETURN NUMBER
IS
        l_tltxcd PRCHK.tltxcd%TYPE;
        l_type PRCHK.TYPE%TYPE;
        l_typeid PRCHK.typeid%TYPE;
        l_typefldcd PRCHK.typefldcd%TYPE;
        l_bridtype PRCHK.bridtype%TYPE;
        l_prtype PRCHK.prtype%TYPE;
        l_accfldcd PRCHK.accfldcd%TYPE;
        l_dorc PRCHK.dorc%TYPE;
        l_amtexp PRCHK.amtexp%TYPE;
        l_acctno varchar2(30);
        l_brid varchar2(4);
        l_actype varchar2(10);
        l_value number(20,4);
        l_busdate DATE;
        l_codeid varchar2(10);
        l_IsSpecialPR NUMBER;
        l_count NUMBER;
        l_IsMarginAccount varchar2(1);
        l_lnaccfldcd varchar2(20);
        l_lntypefldcd varchar2(20);
        l_lntype varchar2(4);

BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAutoUpdate');

    plog.debug(pkgctx, 'fn_txAutoAdhocUpdate: begin');
    IF fn_txAutoAdhocUpdate(p_txmsg, p_err_code) <> systemnums.C_SUCCESS THEN
      plog.setendsection (pkgctx, 'fn_PRTxProcess');
      RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;
    plog.debug(pkgctx, 'fn_txAutoAdhocUpdate: end');

    SELECT to_date(varvalue,'DD/MM/RRRR') INTO l_busdate FROM sysvar WHERE varname = 'CURRDATE' AND grname = 'SYSTEM';

    FOR i IN
        (
            SELECT a.tltxcd, a.chktype, a.udptype, a.type, a.typeid, a.bridtype, a.prtype, a.accfldcd, a.dorc, a.amtexp, a.typefldcd, a.lnaccfldcd, a.lntypefldcd
            FROM prchk a WHERE a.tltxcd = p_txmsg.tltxcd and a.udptype='I' AND a.deltd <> 'Y' ORDER BY a.odrnum
        )
    LOOP
        l_tltxcd:=i.tltxcd;
        l_type:=i.TYPE;
        l_typeid:=i.typeid;
        l_typefldcd:=i.typefldcd;
        l_bridtype:=i.bridtype;
        l_prtype:=i.prtype;
        l_accfldcd:=i.accfldcd;
        l_dorc:=i.dorc;
        l_amtexp:=i.amtexp;
        l_lnaccfldcd:=i.lnaccfldcd;
        l_lntypefldcd:=i.lntypefldcd;

        --TK CHECK pool room. (CI OR SE account)
        IF NOT l_accfldcd IS NULL AND length(l_accfldcd) > 0 THEN
            IF instr(l_accfldcd,'&') > 0 THEN
                l_acctno:= p_txmsg.txfields(substr(l_accfldcd,0,2)).value || p_txmsg.txfields(ltrim(substr(l_accfldcd,3),'&')).value;
            ELSE
                l_acctno:= p_txmsg.txfields(l_accfldcd).value;
            END IF;
        END IF;

        --Lay tham so chi nhanh.
        IF l_bridtype = '0' THEN        --noi mo hop dong
            l_brid:= substr(l_acctno,0,4);
        ELSIF l_bridtype = '1' THEN     --noi lam giao dich
            l_brid:=p_txmsg.brid;
        ELSIF l_bridtype = '2' THEN     --careby tieu khoan.
            BEGIN
                SELECT tl.brid INTO l_brid
                FROM afmast af, tlprofiles tl
                WHERE af.tlid = tl.tlid AND af.acctno = substr(l_acctno,0,10);
            EXCEPTION WHEN OTHERS THEN
                l_brid:= substr(l_acctno,0,4);
            END;
            l_brid:=nvl(l_brid,substr(l_acctno,0,4));
        END IF;

        --Lay ma loai hinh san pham.
        IF NOT l_typeid IS NULL AND length(l_typeid) > 0 THEN
            -- get XXTYPE FROM XXMAST WHERE XXACCTNO = l_typeid
            IF l_type = 'DFTYPE' THEN
                SELECT actype INTO l_actype FROM dfmast WHERE acctno = p_txmsg.txfields(l_typeid).value;
            ELSIF l_type = 'LNTYPE' THEN
                SELECT actype INTO l_actype FROM lnmast WHERE acctno = p_txmsg.txfields(l_typeid).value;
            ELSIF l_type = 'CITYPE' THEN
                SELECT actype INTO l_actype FROM cimast WHERE acctno = p_txmsg.txfields(l_typeid).value;
            ELSIF l_type = 'SETYPE' THEN
                SELECT actype INTO l_actype FROM semast WHERE acctno = p_txmsg.txfields(l_typeid).value;
            ELSIF l_type = 'AFTYPE' THEN
                SELECT actype INTO l_actype FROM afmast WHERE acctno = p_txmsg.txfields(l_typeid).value;
            end if;
        elsif not l_typefldcd is null and length(l_typefldcd) > 0 then
            --Get ACTYPE direct FROM Transactions.
            l_actype:= p_txmsg.txfields(l_typefldcd).value;
        END IF;

        IF length(l_amtexp) > 0 THEN
            l_value:= fn_parse_amtexp(p_txmsg,l_amtexp);
        ELSE
            l_value:= 0;
        END IF;

        --lay codeid chung khoan.
        l_codeid:= substr(l_acctno,11,6);

        --Lay LNTYPE tu [LNACCFLDCD] or [LNTYPEFLDCD]
        if length(trim(l_lnaccfldcd))>0 then
            begin
                select actype into l_lntype from lnmast where acctno = p_txmsg.txfields(l_lnaccfldcd).value;
            exception when others then
                l_lntype:='XXXX';
            end;
        end if;
        if length(trim(l_lntypefldcd))>0 then
            begin
                l_lntype:= p_txmsg.txfields(l_lntypefldcd).value;
            exception when others then
                l_lntype:='XXXX';
            end;
        end if;

        --Danh dau pool
        --Neu Tieu khoan khong danh dau bat buoc tuan thu he thong hoac ko phai lai tieu khoan margin -> Khong can hach toan nguon SYSTEM.
        select count(1) into l_count
        from afmast af, aftype aft, mrtype mrt, lntype lnt1
        where af.actype = aft.actype and aft.mrtype = mrt.actype and mrt.mrtype = 'T'
            and aft.lntype = lnt1.actype(+) and af.acctno = substr(l_acctno,0,10)
            and ((nvl(lnt1.chksysctrl,'N') = 'Y' and nvl(lnt1.actype,'ZZZZ') = l_lntype)
                or
                exists (select 1 from afidtype afi, lntype lnt2
                        where afi.actype = lnt2.actype and afi.objname = 'LN.LNTYPE' and afi.aftype = aft.actype and lnt2.actype = l_lntype and lnt2.chksysctrl = 'Y'));
        if l_count = 0 then
            l_IsMarginAccount:='N';
        else
            l_IsMarginAccount:='Y';
        end if;

        --GianhVG check cho truong hop khong check nguon he thong, thi khong danh dau nguon
        if l_prtype='P' then --Kiem soat pool theo tieu khoan
            select count(1) into l_count
            from cfmast cf, afmast af
            where cf.custid = af.custid
            and cf.custatcom = 'Y'
            and af.poolchk = 'N'
            and af.acctno = substr(l_acctno,0,10);
            if l_count>0 then
                CONTINUE;
            end if;
        end if;
        --Kiem tra theo san phan l_actype, l_type, l_brid
        FOR rec IN
        (
            SELECT DISTINCT pm.prcode, pm.prname, pm.prtyp, pm.codeid, pm.prlimit,
                    pm.prinused, pm.expireddt, pm.prstatus
            FROM prmaster pm, prtype prt, prtypemap prtm, typeidmap tpm, bridmap brm
            WHERE pm.prcode = brm.prcode
                AND pm.prcode = prtm.prcode
                AND prt.actype = prtm.prtype
                AND prt.actype = tpm.prtype
                AND pm.codeid = decode(l_prtype,'R',l_codeid,pm.codeid)
                AND pm.prtyp = l_prtype
                AND (prt.TYPE = l_type
                        or (prt.type = 'SYSTEM' and l_IsMarginAccount = 'Y' and l_prtype = 'P'))
                AND pm.prstatus = 'A'
                AND tpm.typeid = decode(tpm.typeid,'ALL',tpm.typeid,l_actype)
                AND brm.brid = decode(brm.brid,'ALL',brm.brid,l_brid)
        )
        LOOP
            --CHECK: IF IS FALSE --> RETURN SUCCESSFUL!
            IF NOT fn_IsPRCheck(p_txmsg, l_acctno, rec.prcode, l_prtype, 'U') THEN
                plog.debug(pkgctx,'fn_IsPRCheck:FALSE;');
                CONTINUE;
            END IF;

            --Thuc hien cap nhat nguon:
            IF l_dorc = 'D' THEN -- Ghi giam nguon
                IF p_txmsg.deltd <> 'Y' THEN -- normal transactions
                    UPDATE PRMASTER SET PRINUSED=NVL(PRINUSED,0)+ l_value WHERE PRCODE= rec.prcode;
                    INSERT INTO PRTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                    VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),rec.prcode,'0004',l_value,NULL,p_txmsg.deltd,'',seq_PRTRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || p_txmsg.txdesc || '');
                ELSE -- reverse transactions
                    UPDATE PRMASTER SET PRINUSED=NVL(PRINUSED,0)- l_value WHERE PRCODE= rec.prcode;
                    update PRTRAN set deltd='Y' where txnum=p_txmsg.txnum and txdate= TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT);
                END IF;
            ELSIF l_dorc = 'C' THEN --Ghi tang nguon.
                IF p_txmsg.deltd <> 'Y' THEN -- normal transactions
                    UPDATE PRMASTER SET PRINUSED=NVL(PRINUSED,0)- l_value WHERE PRCODE= rec.prcode;
                    INSERT INTO PRTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                    VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),rec.prcode,'0003',l_value,NULL,p_txmsg.deltd,'',seq_PRTRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || p_txmsg.txdesc || '');
                ELSE -- reverse transactions
                    UPDATE PRMASTER SET PRINUSED=NVL(PRINUSED,0)+ l_value WHERE PRCODE= rec.prcode;
                    update PRTRAN set deltd='Y' where txnum=p_txmsg.txnum and txdate= TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT);
                END IF;
            END IF;

        END LOOP;


        -- Update for System Room:
        -- << BEGIN
        if l_prtype = 'R' then
            -- 1. Update on PRCHK Rules:
            IF l_dorc = 'D' THEN -- Ghi giam nguon
                IF p_txmsg.deltd <> 'Y' THEN -- normal transactions
                    UPDATE securities_info SET SYROOMUSED=NVL(SYROOMUSED,0)+ l_value WHERE CODEID= l_codeid;
                ELSE -- reverse transactions
                    UPDATE securities_info SET SYROOMUSED=NVL(SYROOMUSED,0)- l_value WHERE CODEID= l_codeid;
                END IF;
            ELSIF l_dorc = 'C' THEN --Ghi tang nguon.
                IF p_txmsg.deltd <> 'Y' THEN -- normal transactions
                    UPDATE securities_info SET SYROOMUSED=NVL(SYROOMUSED,0)- l_value WHERE CODEID= l_codeid;
                ELSE -- reverse transactions
                    UPDATE securities_info SET SYROOMUSED=NVL(SYROOMUSED,0)+ l_value WHERE CODEID= l_codeid;
                END IF;
            END IF;
        end if;
        -- END >>
    END LOOP;
    plog.setendsection (pkgctx, 'fn_txAutoUpdate');
    RETURN systemnums.C_SUCCESS;
exception when others then
    plog.error(pkgctx,'error:'||p_err_code);
    plog.error (pkgctx, '[SQLERRM] ' || SQLERRM); --Log trace exception
    plog.error(pkgctx,'row:'||dbms_utility.format_error_backtrace);
    plog.setendsection (pkgctx, 'fn_txAutoUpdate');
    Return errnums.C_BIZ_RULE_INVALID;
END fn_txAutoUpdate;

FUNCTION fn_AutoPRTxProcess(p_txmsg in out tx.msg_rectype,p_err_code in out varchar2,p_err_param out varchar2)
RETURN NUMBER
IS
   l_return_code VARCHAR2(30) := systemnums.C_SUCCESS;

BEGIN
   plog.setbeginsection (pkgctx, 'fn_AutoTxProcess');
   IF fn_txAutoCheck(p_txmsg, p_err_code) <> systemnums.C_SUCCESS THEN
        RAISE errnums.E_BIZ_RULE_INVALID;
   END IF;
   IF fn_txAutoUpdate(p_txmsg, p_err_code) <> systemnums.C_SUCCESS THEN
        RAISE errnums.E_BIZ_RULE_INVALID;
   END IF;

   plog.setendsection (pkgctx, 'fn_AutoTxProcess');
   RETURN l_return_code;
EXCEPTION
   WHEN errnums.E_BIZ_RULE_INVALID
   THEN
      FOR I IN (
           SELECT ERRDESC,EN_ERRDESC FROM deferror
           WHERE ERRNUM= p_err_code
      ) LOOP
           p_err_param := i.errdesc;
      END LOOP;
      plog.setendsection (pkgctx, 'fn_AutoTxProcess');
      RETURN errnums.C_BIZ_RULE_INVALID;
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_param := 'SYSTEM_ERROR';
      plog.error (pkgctx, SQLERRM);
      plog.error(pkgctx,'row:'||dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'fn_AutoTxProcess');
      RETURN errnums.C_SYSTEM_ERROR;
END fn_AutoPRTxProcess;

FUNCTION fn_prAutoCheck(p_xmlmsg IN OUT varchar2,p_err_code in out varchar2,p_err_param out varchar2)
RETURN NUMBER
IS
   l_return_code VARCHAR2(30) := systemnums.C_SUCCESS;
   l_txmsg tx.msg_rectype;
BEGIN
   plog.setbeginsection (pkgctx, 'fn_PRTxProcess');
   plog.debug(pkgctx, 'xml2obj');
   l_txmsg := txpks_msg.fn_xml2obj(p_xmlmsg);
   IF fn_txAutoCheck(l_txmsg, p_err_code) <> systemnums.C_SUCCESS THEN
        plog.setendsection (pkgctx, 'fn_PRTxProcess');
        RAISE errnums.E_BIZ_RULE_INVALID;
   END IF;

   plog.debug(pkgctx, 'obj2xml');
   p_xmlmsg := txpks_msg.fn_obj2xml(l_txmsg);
   plog.setendsection (pkgctx, 'fn_PRTxProcess');
   RETURN l_return_code;
EXCEPTION
WHEN errnums.E_BIZ_RULE_INVALID
   THEN
      FOR I IN (
           SELECT ERRDESC,EN_ERRDESC FROM deferror
           WHERE ERRNUM= p_err_code
      ) LOOP
           p_err_param := i.errdesc;
      END LOOP;      l_txmsg.txException('ERRSOURCE').value := '';
      l_txmsg.txException('ERRSOURCE').TYPE := 'System.String';
      l_txmsg.txException('ERRCODE').value := p_err_code;
      l_txmsg.txException('ERRCODE').TYPE := 'System.Int64';
      l_txmsg.txException('ERRMSG').value := p_err_param;
      l_txmsg.txException('ERRMSG').TYPE := 'System.String';
      p_xmlmsg := txpks_msg.fn_obj2xml(l_txmsg);
      plog.error (pkgctx, SQLERRM);
      plog.error(pkgctx,'row:'||dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'fn_prUpdate');
      RETURN errnums.C_BIZ_RULE_INVALID;
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_param := 'SYSTEM_ERROR';
      plog.error (pkgctx, SQLERRM);
      plog.error(pkgctx,'row:'||dbms_utility.format_error_backtrace);
      l_txmsg.txException('ERRSOURCE').value := '';
      l_txmsg.txException('ERRSOURCE').TYPE := 'System.String';
      l_txmsg.txException('ERRCODE').value := p_err_code;
      l_txmsg.txException('ERRCODE').TYPE := 'System.Int64';
      l_txmsg.txException('ERRMSG').value :=  p_err_param;
      l_txmsg.txException('ERRMSG').TYPE := 'System.String';
      p_xmlmsg := txpks_msg.fn_obj2xml(l_txmsg);
      plog.setendsection (pkgctx, 'fn_prUpdate');
      RETURN errnums.C_SYSTEM_ERROR;
END fn_prAutoCheck;


FUNCTION fn_prAutoUpdate(p_xmlmsg IN OUT varchar2,p_err_code in out varchar2,p_err_param out varchar2)
RETURN NUMBER
IS
   l_return_code VARCHAR2(30) := systemnums.C_SUCCESS;
   l_txmsg tx.msg_rectype;
BEGIN
   plog.setbeginsection (pkgctx, 'fn_PRTxProcess');
   plog.debug(pkgctx, 'xml2obj');
   l_txmsg := txpks_msg.fn_xml2obj(p_xmlmsg);
   IF fn_txAutoUpdate(l_txmsg, p_err_code) <> systemnums.C_SUCCESS THEN
      plog.setendsection (pkgctx, 'fn_PRTxProcess');
      RAISE errnums.E_BIZ_RULE_INVALID;
   END IF;

   plog.debug(pkgctx, 'obj2xml');
   p_xmlmsg := txpks_msg.fn_obj2xml(l_txmsg);
   plog.setendsection (pkgctx, 'fn_PRTxProcess');
   RETURN l_return_code;
EXCEPTION
WHEN errnums.E_BIZ_RULE_INVALID
   THEN
      FOR I IN (
           SELECT ERRDESC,EN_ERRDESC FROM deferror
           WHERE ERRNUM= p_err_code
      ) LOOP
           p_err_param := i.errdesc;
      END LOOP;      l_txmsg.txException('ERRSOURCE').value := '';
      l_txmsg.txException('ERRSOURCE').TYPE := 'System.String';
      l_txmsg.txException('ERRCODE').value := p_err_code;
      l_txmsg.txException('ERRCODE').TYPE := 'System.Int64';
      l_txmsg.txException('ERRMSG').value := p_err_param;
      l_txmsg.txException('ERRMSG').TYPE := 'System.String';
      p_xmlmsg := txpks_msg.fn_obj2xml(l_txmsg);
      plog.setendsection (pkgctx, 'fn_prUpdate');
      RETURN errnums.C_BIZ_RULE_INVALID;
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_param := 'SYSTEM_ERROR';
      plog.error (pkgctx, SQLERRM);
      plog.error(pkgctx,'row:'||dbms_utility.format_error_backtrace);
      l_txmsg.txException('ERRSOURCE').value := '';
      l_txmsg.txException('ERRSOURCE').TYPE := 'System.String';
      l_txmsg.txException('ERRCODE').value := p_err_code;
      l_txmsg.txException('ERRCODE').TYPE := 'System.Int64';
      l_txmsg.txException('ERRMSG').value :=  p_err_param;
      l_txmsg.txException('ERRMSG').TYPE := 'System.String';
      p_xmlmsg := txpks_msg.fn_obj2xml(l_txmsg);
      plog.setendsection (pkgctx, 'fn_prUpdate');
      RETURN errnums.C_SYSTEM_ERROR;
END fn_prAutoUpdate;

FUNCTION fn_ResetPool(p_err_code in out varchar2)
RETURN NUMBER
IS
v_currdate  date;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_ResetPool');
    p_err_code := systemnums.c_success;
    v_currdate := getcurrdate;
    for rec in
    (
        select  pm.prcode, pm.prname,prinused, sum(lns.nml+lns.ovd) curprinused
        FROM prmaster pm,  prtype prt, prtypemap prtm, typeidmap tpm, bridmap brm,
            afmast af ,lnmast lnm, lnschd lns, lntype lnt --prchk prk, aftype aft, mrtype mrt,
        WHERE pm.prcode = brm.prcode
            and lnm.ftype NOT IN ('DF')
            AND pm.prcode = prtm.prcode
            AND prt.actype = prtm.prtype
            AND prt.actype = tpm.prtype
            AND pm.prtyp = 'P'
            AND lnm.actype= lnt.actype
            --AND af.actype = aft.actype AND aft.mrtype = mrt.actype
            AND (prt.TYPE = 'AFTYPE'
            or (prt.type = 'SYSTEM' and nvl(lnt.chksysctrl,'N') = 'Y' AND lns.reftype IN ('P')))
            AND pm.prstatus = 'A'
            AND tpm.typeid = decode(tpm.typeid,'ALL',tpm.typeid,af.actype)
            AND brm.brid = decode(brm.brid,'ALL',brm.brid,af.brid)
            and af.acctno = lnm.trfacctno and lnm.acctno = lns.acctno
            and lns.reftype in('P' ,'GP')
            AND v_currdate < pm.expireddt
            and af.poolchk = 'Y'
        group by pm.prcode, pm.prname,prinused
    UNION ALL
        SELECT pm.prcode, pm.prname,prinused, 0 curprinused  FROM prmaster  pm
        WHERE  pm.prcode NOT IN (
                                select  pm.prcode
                                FROM prmaster pm,  prtype prt, prtypemap prtm, typeidmap tpm, bridmap brm,
                                    afmast af ,lnmast lnm, lnschd lns, lntype lnt--prchk prk, aftype aft, mrtype mrt,
                                WHERE pm.prcode = brm.prcode
                                    and lnm.ftype NOT IN ('DF')
                                    AND pm.prcode = prtm.prcode
                                    AND prt.actype = prtm.prtype
                                    AND prt.actype = tpm.prtype
                                    AND pm.prtyp = 'P'
                                    AND lnm.actype= lnt.actype
                                    --AND af.actype = aft.actype AND aft.mrtype = mrt.actype
                                    AND (prt.TYPE = 'AFTYPE'
                                    or (prt.type = 'SYSTEM' and nvl(lnt.chksysctrl,'N') = 'Y' AND lns.reftype IN ('P')))
                                    AND pm.prstatus = 'A'
                                    AND tpm.typeid = decode(tpm.typeid,'ALL',tpm.typeid,af.actype)
                                    AND brm.brid = decode(brm.brid,'ALL',brm.brid,af.brid)
                                    and af.acctno = lnm.trfacctno and lnm.acctno = lns.acctno
                                    and lns.reftype in('P' ,'GP')
                                    AND v_currdate < pm.expireddt
                                    and af.poolchk = 'Y'
                                group by pm.prcode, pm.prname,prinused)
    )
    LOOP
      IF (REC.PRINUSED >rec.curprinused) OR (REC.PRINUSED <rec.curprinused)   THEN
        update prmaster set prinused = rec.curprinused where prcode= rec.prcode;
        --Them Log vao bang log
        insert into prmasterlog (PRCODE, PRNAME, PRTYP, CODEID, PRLIMIT, PRINUSEDOLD,PRINUSEDNEW, EXPIREDDT, PRSTATUS)
               SELECT PRCODE, PRNAME, PRTYP, CODEID, PRLIMIT, rec.PRINUSED ,REC.curprinused, EXPIREDDT, PRSTATUS
               FROM PRMASTER
               WHERE PRCODE=REC.PRCODE;
      END IF;
    end loop;
    plog.setendsection (pkgctx, 'fn_ResetPool');
    RETURN systemnums.C_SUCCESS;
EXCEPTION when others then
    plog.error(pkgctx,'error:'||p_err_code);
    plog.error(pkgctx,'row:'||dbms_utility.format_error_backtrace);
    plog.setendsection (pkgctx, 'fn_ResetPool');
    p_err_code:=errnums.c_system_error;
    RETURN errnums.C_BIZ_RULE_INVALID;
END fn_ResetPool;

BEGIN
      FOR i IN (SELECT *
                FROM tlogdebug)
      LOOP
         logrow.loglevel    := i.loglevel;
         logrow.log4table   := i.log4table;
         logrow.log4alert   := i.log4alert;
         logrow.log4trace   := i.log4trace;
      END LOOP;
      pkgctx    :=
         plog.init ('txpks_prchk',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END;
/

