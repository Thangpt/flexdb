CREATE OR REPLACE PACKAGE cspks_toolparallel
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
    PROCEDURE sp_Tool_InitOneTime;
    PROCEDURE sp_Tool_Init_UpdateData;
    PROCEDURE sp_Tool_FillOrder(p_AutoNS2MS varchar2 default 'N');
    PROCEDURE sp_Tool_AutoAdvanceNS (p_amount number);
    PROCEDURE sp_Tool_AutoAdvanceNS_Bank (p_amount number);
END;
/

CREATE OR REPLACE PACKAGE BODY cspks_toolparallel
IS
   -- declare log context
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

-- initial LOG
PROCEDURE sp_Tool_InitOneTime
is
begin
    plog.setbeginsection(pkgctx, 'sp_Tool_InitOneTime');
    /*insert into odmastcv_par_hist select od.*, SYSTIMESTAMP from ODMASTCV_PAR od;
    delete from ODMASTCV_PAR;
    insert into odmastcv_par
    select cv.*,'P','' from odmastcv cv;*/
    commit;
    plog.setendsection(pkgctx, 'sp_Tool_InitOneTime');
EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on sp_Tool_InitOneTime');
      ROLLBACK;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'sp_Tool_InitOneTime');
      RAISE errnums.E_SYSTEM_ERROR;
end sp_Tool_InitOneTime;

PROCEDURE sp_Tool_Init_UpdateData
is
begin
    plog.setbeginsection(pkgctx, 'sp_Tool_Init_UpdateData');
    /*insert into odmastcv_par
    select cv.*,'P','' from odmastcv cv where order_no not in (select order_no from odmastcv_par);*/
    commit;
    plog.setendsection(pkgctx, 'sp_Tool_Init_UpdateData');
EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on sp_Tool_Init_UpdateData');
      ROLLBACK;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'sp_Tool_Init_UpdateData');
      RAISE errnums.E_SYSTEM_ERROR;
end sp_Tool_Init_UpdateData;

PROCEDURE sp_Tool_AutoAdvanceNS (p_amount number)
is
    p_err_code varchar2(100);
    p_err_message varchar2(1000);
begin
    plog.setbeginsection(pkgctx, 'sp_Tool_AutoAdvanceNS');
    for rec in (
                    select distinct custodycd, afacctno from (SELECT
                       AF.ACCTNO AFACCTNO,exectype ,NORP,SB.CODEID,SB.SYMBOL,OD.orqtty ,OD.orprice/1000 orprice,
                       getdate (TO_DATE(OD.clearday,'DD/MM/YYYY')) TXDATE,
                       CF.CUSTID,OD.VIA,OD.price_type, od.ismagin ismargin, cf.custodycd,order_no
                    FROM (SELECT order_no,account_no, code,  exectype, norp, orqtty,   orprice,  clearday,type VIA ,price_type,ismagin
                           FROM  odmastcv_par
                           WHERE status = 'R' and exectype ='NB'
                           GROUP BY  account_no, code,exectype, norp, orqtty,
                                orprice,clearday,type ,order_no,price_type, ismagin
                         ) OD,sbsecurities SB,AFMAST AF,CFMAST CF
                    WHERE OD.CODE =SB.SYMBOL
                    AND OD.account_no = CF.CUSTODYCD
                    AND CF.CUSTID = AF.CUSTID
                    AND LENGTH (clearday)>1)
        )
    loop
        update cfmast set t0loanlimit=2*p_amount where custodycd = rec.custodycd;
        fopks_api.pr_Allocate_Guarantee_BD
        (   rec.custodycd,
            rec.afacctno ,
            p_amount ,
            '0001',
            '',
            p_err_code,
            p_err_message
        );
        if p_err_code='0' then
            update odmastcv_par set errmsg= errmsg || ' -Cap BL- OK' where account_no= rec.custodycd;
        else
            update odmastcv_par set errmsg= errmsg || ' -Cap BL- ' || p_err_message where account_no= rec.custodycd;
        end if;
    end loop;
    commit;
    plog.setendsection(pkgctx, 'sp_Tool_AutoAdvanceNS');
EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on sp_Tool_AutoAdvanceNS');
      ROLLBACK;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'sp_Tool_AutoAdvanceNS');
      RAISE errnums.E_SYSTEM_ERROR;
end sp_Tool_AutoAdvanceNS;


PROCEDURE sp_Tool_AutoAdvanceNS_Bank (p_amount number)
is
    p_err_code varchar2(100);
    p_err_message varchar2(1000);
begin
    plog.setbeginsection(pkgctx, 'sp_Tool_AutoAdvanceNS_Bank');
    for rec in (
                    select distinct custodycd, acctno afacctno from (
                        select cf.custodycd, af.acctno from fomast fo, afmast af, cfmast cf
                        where fo.status ='W'  and fo.afacctno = af.acctno and af.custid = cf.custid
                    )
        )
    loop
        update cfmast set t0loanlimit=2*p_amount where custodycd = rec.custodycd;
        fopks_api.pr_Allocate_Guarantee_BD
        (   rec.custodycd,
            rec.afacctno ,
            p_amount ,
            '0001',
            '',
            p_err_code,
            p_err_message
        );
        if p_err_code='0' then
            update odmastcv_par set errmsg= errmsg || ' -Cap BL- OK' where account_no= rec.custodycd;
        else
            update odmastcv_par set errmsg= errmsg || ' -Cap BL- ' || p_err_message where account_no= rec.custodycd;
        end if;
    end loop;
    commit;
    plog.setendsection(pkgctx, 'sp_Tool_AutoAdvanceNS_Bank');
EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on sp_Tool_AutoAdvanceNS_Bank');
      ROLLBACK;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'sp_Tool_AutoAdvanceNS');
      RAISE errnums.E_SYSTEM_ERROR;
end sp_Tool_AutoAdvanceNS_Bank;

PROCEDURE sp_Tool_FillOrder(p_AutoNS2MS varchar2 default 'N')
IS
    l_txmsg               tx.msg_rectype;
    p_err_code varchar2(100);
    p_err_message varchar2(1000);
    ERROR NUMBER;
    ERRORMSG VARCHAR2 (2000);
    l_exectype varchar2(10);
    l_codeid varchar2(20);
    l_pp number;
    l_dftrading number;
    l_custatcom char(1);
    l_trade number;
    l_mortage number;
    l_blocked number;
    l_status char(1);
    l_dfmortage number;
    PV_REFCURSOR PKG_REPORT.REF_CURSOR;
Begin

    FOR REC IN
    (
        SELECT
           TO_CHAR (getdate (TO_DATE(OD.clearday,'DD/MM/YYYY')),'DD/MM/YYYY')||LPAD(seq_fomast.NEXTVAL,10,0) ACCTNO,
           '8080'|| TO_CHAR (getdate (TO_DATE(OD.clearday,'DD/MM/YYYY')),'DDMMYYYY')||LPAD(seq_oDmast.NEXTVAL,6,0) ORDERID,
           AF.ACCTNO AFACCTNO,exectype ,NORP,SB.CODEID,SB.SYMBOL,OD.orqtty ,OD.orprice/1000 orprice,
           getdate (TO_DATE(OD.clearday,'DD/MM/YYYY')) TXDATE,
           CF.CUSTID,OD.VIA,OD.price_type, od.ismagin ismargin, cf.custodycd,order_no
        FROM (SELECT order_no,account_no, code,  exectype, norp, orqtty,   orprice,  clearday,type VIA ,price_type,ismagin
               FROM  odmastcv_par
               WHERE status <> 'A'
               GROUP BY  account_no, code,exectype, norp, orqtty,
                    orprice,clearday,type ,order_no,price_type, ismagin
             ) OD,sbsecurities SB,AFMAST AF,CFMAST CF
        WHERE OD.CODE =SB.SYMBOL
        AND OD.account_no = CF.CUSTODYCD
        AND CF.CUSTID = AF.CUSTID
        AND LENGTH (clearday)>1

    )
    LOOP
        plog.setbeginsection(pkgctx, 'sp_Tool_FillOrder');
        l_exectype:= rec.exectype;
        l_codeid:=rec.CODEID;
        l_status:='A';
        if l_exectype<> 'NB' then
            begin
                select a.trade - nvl(b.secureamt,0), a.mortage, a.blocked,nvl(df.sumdfqtty,0) - NVL (b.securemtg, 0) dfmortage
                into l_trade, l_mortage, l_blocked, l_dfmortage
                        from semast a, v_getsellorderinfo b,
                        (SELECT afacctno,codeid, sum(dfqtty) sumdfqtty FROM dfmast GROUP BY afacctno, codeid) df
                        where a.afacctno = rec.afacctno and a.codeid = rec.codeid
                        AND acctno = b.seacctno(+)
                        AND df.afacctno(+) = a.afacctno AND df.codeid(+) = a.codeid;
            exception when others then
                l_trade:=0;
                l_mortage:=0;
                l_blocked:=0;
                l_dfmortage:=0;
            end;
        end if;
        --Xac dinh loai lenh
        if rec.ismargin ='Y' and rec.exectype<> 'NB' then

            --Kiem tra xem trang thai Mortage co du chung khoan de dat lenh hay khong.
            --Neu khong du dat lenh ma trade du dat lenh thi chuyen loai lenh sang thanh NS
            begin
                select sum(dftrading) into l_dftrading from v_getdealinfo
                where codeid =l_codeid and afacctno = rec.AFACCTNO
                group by afacctno,codeid;
            exception when others then
                l_dftrading:=0;
            end;
            if l_dftrading>= REC.orqtty then
                l_exectype:= 'MS';
            elsif l_trade >= REC.orqtty then
                l_exectype:= 'NS';
            else
                l_status:='R';
                update odmastcv_par set status ='R',
                errmsg='Thieu so du chung khoan ban cam co (' ||
                    'Trade:' || l_trade || ' - ' ||
                    'dfmortage:'  || l_dfmortage || ' - '||
                    'Mortgage:'  || l_mortage || ' - '||
                    'Blocked:' || l_blocked || ' - '||
                    'DFTrading:' || l_dftrading || ')'
                where order_no= rec.order_no;
                l_exectype:= 'NS';
            end if;
        end if;
        if p_AutoNS2MS='Y' and l_exectype= 'NS' THEN
            if l_trade < REC.orqtty then
                l_exectype:= 'MS';
            end if;
        end if;

        --Neu tai khoan luu ky ben ngoai thi voi lenh mua thieu tien --> cap bao lanh
        --Voi lenh ban thieu chung khoan thi cap them chung khoan
        select custatcom into l_custatcom from cfmast where custid = rec.custid;

        if l_custatcom ='N' then
            if l_exectype ='NB' THEN
                --Kiem tra va cao bao lanh tien
                select  af.advanceline + ci.balance- NVL (secureamt, 0) into l_pp
                from afmast af, cimast ci, v_getbuyorderinfo v
                where ci.acctno = rec.afacctno and ci.acctno = v.afacctno(+)
                    and ci.acctno = af.acctno;
                if l_pp < REC.orqtty * REC.orprice * 1000 * (1+0.4/100) THEN
                    --Goi giao dich cap bao lanh tien
                    fopks_api.pr_AllocateAVDL3rdAccount
                    (   rec.custodycd,
                        rec.afacctno,
                        REC.orqtty * REC.orprice * 1000 * (1+0.4/100),
                        '0001',
                        '',
                        p_err_code,
                        p_err_message
                    );
                end if;
            else
                l_exectype:='NS'; --Tai khoan luu ky ben ngoai khong co lenh cam co
                --Kiem tra va cap bao lanh chung khoan
                if l_trade < REC.orqtty then
                    --Goi giao dich cap bao lanh chung khoan
                    fopks_api.pr_AllocateStock3rdAccount
                    (   rec.custodycd,
                        rec.afacctno,
                        rec.symbol,
                        REC.orqtty - l_trade,
                        '0001',
                        '',
                        p_err_code,
                        p_err_message
                    );
                end if;
            end if;
        end if;
        if l_status='A' then
            fopks_api.pr_placeorder ('PLACEORDER',
                                    REC.CUSTID ,
                                    '' ,
                                    REC.AFACCTNO,
                                    l_exectype,
                                    REC.SYMBOL ,
                                    REC.orqtty ,
                                    REC.orprice ,
                                    REC.price_type ,
                                    'T' ,
                                    'A' ,
                                    REC.VIA ,
                                    '' ,
                                    'Y' ,
                                    '' ,
                                    '' ,
                                    '0001',
                                    p_err_code,
                                    p_err_message
                                    );
            if p_err_code <> '0' then
                if REC.exectype='NB' then
                    update odmastcv_par set status ='R', errmsg='Thieu so du tien'
                    where order_no= rec.order_no;
                else
                    update odmastcv_par set status ='R', errmsg=
                        'Thieu so du chung khoan (' ||
                        'Trade:' || l_trade || ' - ' ||
                        'dfmortage:'  || l_dfmortage || ' - '||
                        'Mortgage:'  || l_mortage || ' - '||
                        'Blocked:' || l_blocked || ')'
                    where order_no= rec.order_no;
                end if;
            else
                update odmastcv_par set status ='A', errmsg='Lenh day OK'
                    where order_no= rec.order_no;
            end if;
        end if;

        plog.setendsection (pkgctx, 'sp_Tool_FillOrder');
    END LOOP;

    plog.setendsection (pkgctx, 'sp_Tool_FillOrder');
EXCEPTION
  WHEN OTHERS
   THEN
      plog.error (pkgctx,'got error on sp_Tool_FillOrder' || dbms_utility.format_error_backtrace);
      ROLLBACK;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'sp_Tool_FillOrder');
      RAISE errnums.E_SYSTEM_ERROR;
END sp_Tool_FillOrder;


BEGIN
   SELECT *
   INTO logrow
   FROM tlogdebug
   WHERE ROWNUM <= 1;

   pkgctx    :=
      plog.init ('cspks_ToolParallel',
                 plevel => logrow.loglevel,
                 plogtable => (logrow.log4table = 'Y'),
                 palert => (logrow.log4alert = 'Y'),
                 ptrace => (logrow.log4trace = 'Y')
      );
END;
/

