CREATE OR REPLACE PACKAGE txpks_#8874ex
/**----------------------------------------------------------------------------------------------------
 ** Module: COMMODITY SYSTEM
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      21/10/2009     Created
 **
 ** (c) 2008 by Financial Software Solutions. JSC.
 ** ----------------------------------------------------------------------------------------------------*/
IS
FUNCTION fn_txPreAppCheck(p_txmsg in out tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppCheck(p_txmsg in out tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
END;
/
CREATE OR REPLACE PACKAGE BODY txpks_#8874ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;
FUNCTION fn_txPreAppCheck(p_txmsg in out tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    l_STATUS varchar2(1);
    l_PP number(20,4);
    l_PPse number(20,4);
    l_AVLLIMIT number(20,4);
    l_margintype            CHAR (1);
    l_actype                VARCHAR2 (4);
    l_groupleader           VARCHAR2 (10);

    l_advanceline number(20,4);
    l_mrratiorate number(20,4);
    l_marginrefprice number(20,4);
    l_marginprice number(20,4);
    l_mrpriceloan number(20,4);
    l_orderprice number(20,4);
    l_deffeerate number(10,6);
    l_chksysctrl varchar2(1);
    l_ismarginallow varchar2(1);
    l_total_trft0amt number(20,0);

    l_avlroomqtty number;
    l_avlsyroomqtty number;
    l_avlqtty number;
    l_avlsyqtty number;
    l_PP0_add number;
    l_IsLateTransfer number;
    l_T0SecureAmt number;
    l_PPSE_BL NUMBER;
    l_T0count NUMBER;
    l_CheckBlackList NUMBER;
    l_aprT0 NUMBER;
    l_cimastcheck_arr txpks_check.cimastcheck_arrtype;

    l_roomchk   char(1);


    l_strTRADEPLACE varchar2(30);
    v_MaxSameOrd NUMBER;
    l_count      NUMBER;
    l_strAFACCTNO varchar2(30);
    l_strEXPDATE varchar2(30);
    l_strEXECTYPE varchar2(30);
    l_strMATCHTYPE varchar2(30);
    l_strPRICETYPE varchar2(30);
    l_dblQUOTEPRICE number(30,9);
    l_dblORDERQTTY number(30,4);
    l_strCODEID    varchar2(30);
    l_CheckAFBlackList NUMBER;
    l_Custatcom VARCHAR2(10);
    l_sectype VARCHAR2(10);
    l_strSYMBOL VARCHAR2(20);
    
    l_deal      VARCHAR2(2);
    l_advanceline1 number(20,4);
    l_t0loanrate   NUMBER;

BEGIN
   plog.setbeginsection (pkgctx, 'fn_txPreAppCheck');
   plog.debug(pkgctx,'BEGIN OF fn_txPreAppCheck');
   /***************************************************************************************************
    * PUT YOUR SPECIFIC RULE HERE, FOR EXAMPLE:
    * IF NOT <<YOUR BIZ CONDITION>> THEN
    *    p_err_code := '<<ERRNUM>>'; -- Pre-defined in DEFERROR table
    *    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    *    RETURN errnums.C_BIZ_RULE_INVALID;
    * END IF;
    ***************************************************************************************************/
    IF p_txmsg.deltd = 'N' THEN

        --ThanhNV 1/8/2016 Kiem tra chong trung lenh HNX.
       l_strCODEID := p_txmsg.txfields('01').value;
       plog.debug(pkgctx,'l_lngErrCode: l_strCODEID' || l_strCODEID);
       BEGIN
            SELECT TRADEPLACE, sectype INTO l_strTRADEPLACE, l_sectype FROM SBSECURITIES WHERE CODEID= l_strCODEID;     --1.5.6.0
       EXCEPTION
       WHEN no_data_found THEN
            plog.debug(pkgctx,'l_lngErrCode: ' || errnums.C_OD_SECURITIES_INFO_UNDEFINED);
            p_err_code := errnums.C_OD_SECURITIES_INFO_UNDEFINED;
            RETURN  p_err_code;
       END;

       --begin 1.5.6.0 - chan lenh PLO, MTL,MAK, MOK voi TPDN
      if l_strTRADEPLACE in ('002','005') and l_sectype='012' and trim(p_txmsg.txfields('27').value) in ('MTL','MAK','MOK','PLO') then
          p_err_code := '-700110';
          plog.setendsection (pkgctx, 'fn_txPreAppCheck');
          RETURN errnums.C_BIZ_RULE_INVALID;
        end if;
      --end 1.5.6.0

       IF l_strTRADEPLACE = errnums.gc_TRADEPLACE_HNCSTC OR  l_strTRADEPLACE = errnums.gc_TRADEPLACE_UPCOM  THEN
           --Lay tham so max order trung nhau trong ordersys.
            Begin
                SELECT sysvalue INTO v_MaxSameOrd FROM ordersys_ha WHERE sysname ='MAXSAMEORD';
            Exception When OTHERS Then
                v_MaxSameOrd:=20;
            End;
            --Lay tong so lenh trung nhau:



            l_strAFACCTNO := p_txmsg.txfields('03').value;
            l_strEXECTYPE := p_txmsg.txfields('22').value;
            l_strMATCHTYPE := p_txmsg.txfields('24').value;
            l_strPRICETYPE := p_txmsg.txfields('27').value;
            l_dblQUOTEPRICE := p_txmsg.txfields('11').value;
            l_dblORDERQTTY := p_txmsg.txfields('12').value;

            plog.debug(pkgctx,'l_lngErrCode: l_strAFACCTNO ' || l_strAFACCTNO ||
                                           ' l_strCODEID ' || l_strCODEID ||
                                           ' l_strEXECTYPE ' || l_strEXECTYPE ||
                                           ' l_strMATCHTYPE ' || l_strMATCHTYPE ||
                                           ' l_strPRICETYPE ' || l_strPRICETYPE ||
                                           ' l_dblQUOTEPRICE ' || l_dblQUOTEPRICE ||
                                           ' l_dblORDERQTTY ' || l_dblORDERQTTY);


            SELECT COUNT(*) into l_count FROM ODMAST WHERE CODEID= l_strCODEID
            AND AFACCTNO IN (SELECT ACCTNO FROM AFMAST WHERE CUSTID=(SELECT CUSTID FROM AFMAST WHERE ACCTNO= l_strAFACCTNO ))
                                                       AND PRICETYPE = l_strPRICETYPE
                                                       AND EXECTYPE=   l_strEXECTYPE
                                                       AND DELTD = 'N'
                                                       AND (PRICETYPE IN ('MTL','MAK','MOK','ATC')
                                                                OR (
                                                                PRICETYPE NOT IN ('MTL','MAK','MOK','ATC') AND QUOTEPRICE = l_dblQUOTEPRICE * 1000
                                                                )
                                                            )
                                                       AND MATCHTYPE =  l_strMATCHTYPE
                                                       AND ORDERQTTY  = l_dblORDERQTTY
                                                       AND REFORDERID IS NULL
                                                       AND TXDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT);
             plog.debug(pkgctx,'l_count '||l_count || ' v_MaxSameOrd '|| v_MaxSameOrd );
            IF  l_count > v_MaxSameOrd -1 THEN
                plog.debug(pkgctx,'l_strAFACCTNO '||l_strAFACCTNO || ' Ma CK '|| l_strCODEID ||' Vuot qua so lenh trung nhau');
                p_err_code := -95046;
                RETURN  p_err_code;
            END IF;

       END IF;
       --ThanhNV End.


       SELECT mr.mrtype, af.actype, mst.groupleader, mst.deal, cf.t0loanrate
            INTO l_margintype, l_actype, l_groupleader, l_deal, l_t0loanrate
        FROM afmast mst, aftype af, mrtype mr, cfmast cf
        WHERE mst.actype = af.actype
            AND af.mrtype = mr.actype
            AND mst.custid = cf.custid
            AND mst.acctno = p_txmsg.txfields('03').value;


        select af.advanceline, nvl(rsk.mrratioloan,0),nvl(rsk.mrpriceloan,0), nvl(lnt.chksysctrl,'N'), nvl(rsk.ismarginallow,'N'), af.trfbuyrate * af.trfbuyext,
                    (nvl(b.buyamt,0) * af.trfbuyrate/100)  + (case when af.trfbuyrate > 0 then nvl(b.buyfeeacr,0) else 0 end)
            into l_advanceline, l_mrratiorate,l_mrpriceloan, l_chksysctrl, l_ismarginallow, l_IsLateTransfer, l_T0SecureAmt
        from afmast af, aftype aft, lntype lnt,
            (select * from afserisk where codeid = p_txmsg.txfields('01').value) rsk,
            (select * from v_getbuyorderinfo where afacctno = p_txmsg.txfields('03').value) b
        where af.actype = aft.actype
        and aft.lntype = lnt.actype(+)
        and af.actype = rsk.actype(+)
        and af.acctno = b.afacctno(+)
        and af.acctno = p_txmsg.txfields('03').value;
        
   ----
   
        --1.5.8.9 MSBS-2055
              IF l_deal = 'N' THEN
                  SELECT ROUND(least(nvl((ci.balance-NVL(b.secureamt,0)) + NVL(ADV.avladvance,0) + v_getsec.senavamt - 
                          NVL(ci.ovamt,0),0) * l_t0loanrate /100,nvl(v_getsec.SELIQAMT2,0)))
                  INTO l_advanceline1
                  from cimast ci inner join afmast af on ci.acctno=af.acctno
                  left join
                  (select * from v_getbuyorderinfo where afacctno = p_txmsg.txfields('03').value) b
                  on  ci.acctno = b.afacctno
                  LEFT JOIN
                  (select sum(depoamt) avladvance, sum(paidamt) paidamt, sum(advamt) advanceamount,afacctno, sum(aamt) aamt from v_getAccountAvlAdvance where afacctno = p_txmsg.txfields('03').value group by afacctno) adv
                  on adv.afacctno=ci.acctno
                  LEFT JOIN
                  (SELECT * FROM v_getsecmargininfo_ALL) v_getsec
                  ON ci.acctno = v_getsec.afacctno
                  where ci.acctno = p_txmsg.txfields('03').value;
              ELSE
                 l_advanceline1 := l_advanceline;
              END IF;

        -- Bao lanh danh cho lenh trong qua khu:
        select nvl(sum(sts.trft0amt),0)
            into l_total_trft0amt
        from stschd sts
        where sts.afacctno = p_txmsg.txfields('03').value and sts.duetype = 'SM' and sts.deltd <> 'Y' and trfbuysts <> 'Y' and trfbuyrate * trfbuyext > 0;
        -- Bao lanh cap trong ngay:
        l_advanceline:=greatest(greatest(least(l_advanceline,l_advanceline1),0)-l_total_trft0amt, 0); --1.5.8.9 MSBS-2055

        l_CIMASTcheck_arr := txpks_check.fn_CIMASTcheck(p_txmsg.txfields('03').value,'CIMAST','ACCTNO');
        l_PP := l_CIMASTcheck_arr(0).PP;
        l_AVLLIMIT := l_CIMASTcheck_arr(0).AVLLIMIT;
        l_STATUS := l_CIMASTcheck_arr(0).STATUS;
        -- DUCNV THEM TRANG THAI P VAN CHO DAT LENH
        IF NOT ( INSTR('ATP',l_STATUS) > 0) THEN
            p_err_code := '-400100';
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;

        SELECT SB.SECTYPE,sei.symbol INTO l_sectype,l_strSYMBOL
        FROM SBSECURITIES SB, securities_info sei
        WHERE SB.CODEID = p_txmsg.txfields('01').VALUE
        AND sb.codeid = sei.codeid;
        -- CHECK CHI CHO PHEP DAT MUA TREN TIEU KHOAN THUONG VOI SECTYPE = '011'
        IF l_sectype = '011' THEN
          IF l_margintype <> 'N' AND l_margintype <> 'L' THEN
              p_err_code := '-100129';
              RETURN errnums.C_BIZ_RULE_INVALID;
          END IF;
        END IF ;

       --check ma chung quyen dao han
       if fn_check_cwsecurities(l_strSYMBOL) <> 0 then
                p_err_code:='-100128';
                RETURN errnums.C_BIZ_RULE_INVALID;
       end if;

        --CHeck ck thuoc blacklist
        SELECT nvl(COUNT(*),0)INTO l_CheckBlackList FROM blacklistsymbol bl, sbsecurities sb WHERE sb.codeid =p_txmsg.txfields('01').value AND sb.symbol=bl.symbol AND bl.status = 'A' AND Effdate<=getcurrdate;
         l_aprT0:=0;
        --Check co luu ky o cty hay ko
        SELECT cf.custatcom INTO l_Custatcom FROM cfmast cf, afmast af WHERE cf.custid = af.custid AND af.acctno = p_txmsg.txfields('03').value;

        --Check co uu tien mua CK Blacklist ko
        SELECT count(*) INTO l_CheckAFBlackList
        FROM blacklistsymbol b, afblacklistsymbol a, sbsecurities sb
        WHERE a.refsymbol = b.symbol AND a.afacctno = p_txmsg.txfields('03').value
            AND b.symbol = sb.symbol AND sb.codeid = p_txmsg.txfields('01').value;

        --Gia tri bao lanh cap trong ngay
        IF l_CheckBlackList>0  AND l_advanceline >0 AND l_Custatcom = 'Y' AND l_CheckAFBlackList = 0 THEN
            p_err_code := '-100145';
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;
        --End CHeck ck thuoc blacklist

        if l_margintype not in ('S','T') THEN
           /* --00 Ktra Co dung BL phe duyet mua CK blacklist khong.
            IF l_aprT0>0 THEN
              IF NOT (ceil(to_number(l_PP))-l_aprT0>=to_number(ROUND(p_txmsg.txfields('96').value*p_txmsg.txfields('12').value*p_txmsg.txfields('11').value*p_txmsg.txfields('13').value*p_txmsg.txfields('98').value/p_txmsg.txfields('99').value,0))) THEN
                p_err_code := '-100145';
                RETURN errnums.C_BIZ_RULE_INVALID;
                END IF;
              END IF;
            --end 00*/
            IF NOT (ceil(to_number(l_PP)) >= to_number(ROUND(p_txmsg.txfields('96').value*p_txmsg.txfields('12').value*p_txmsg.txfields('11').value*p_txmsg.txfields('13').value*p_txmsg.txfields('98').value/p_txmsg.txfields('99').value,0))) THEN
                p_err_code := '-400116';
                RETURN errnums.C_BIZ_RULE_INVALID;
            END IF;
        else

            select marginrefprice, marginprice into l_marginrefprice, l_marginprice from securities_info where codeid = p_txmsg.txfields('01').value;
            --select fn_getmaxdeffeerate(p_txmsg.txfields('03').value) into l_deffeerate from dual;
            select deffeerate/100 into l_deffeerate from odtype where actype = p_txmsg.txfields('02').value;

            if (l_chksysctrl = 'Y' and l_ismarginallow = 'N') or l_IsLateTransfer > 0 then
                l_PPse:=l_PP + l_advanceline - l_T0SecureAmt;
                -- l_PPSE_BL:=l_PP + (l_advanceline-l_aprT0)  - l_T0SecureAmt;
                IF NOT ceil(l_PPse) >= to_number(ROUND((1 + l_deffeerate)*p_txmsg.txfields('96').value*p_txmsg.txfields('12').value*p_txmsg.txfields('11').value*p_txmsg.txfields('98').value,0)) THEN
                    p_err_code := '-400116';
                    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                END IF;
            else
                if l_chksysctrl = 'Y' then
                    --if l_PP > 0 then
                        --l_PPse:= l_PP / (((1 + l_deffeerate - l_mrratiorate/100 * least(l_marginrefprice, l_mrpriceloan) /(to_number(p_txmsg.txfields('11').value) * to_number(p_txmsg.txfields('98').value)) )) / (1 + l_DefFeeRate)) + l_advanceline - l_T0SecureAmt;
                        -- HaiLT thay doi cho y/c MR008 cua Phase2 MSBS
                        l_PPse:= (l_PP+ l_advanceline - l_T0SecureAmt) / (((1 + l_deffeerate - l_mrratiorate/100 * least(l_marginrefprice, l_mrpriceloan) /(to_number(p_txmsg.txfields('11').value) * to_number(p_txmsg.txfields('98').value)) )) / (1 + l_DefFeeRate)) ;
                      --  l_PPSE_BL:= (l_PP+ (l_advanceline-l_aprT0) - l_T0SecureAmt) / (((1 + l_deffeerate - l_mrratiorate/100 * least(l_marginrefprice, l_mrpriceloan) /(to_number(p_txmsg.txfields('11').value) * to_number(p_txmsg.txfields('98').value)) )) / (1 + l_DefFeeRate)) ;
                    --else
                     --   l_PPse:=l_PP + l_advanceline - l_T0SecureAmt;
                    --end if;
                else
                    --if l_PP > 0 then
                        --l_PPse:= l_PP / (((1 + l_deffeerate - l_mrratiorate/100 * least(l_marginrefprice, l_mrpriceloan) /(to_number(p_txmsg.txfields('11').value) * to_number(p_txmsg.txfields('98').value)) )) / (1 + l_DefFeeRate)) + l_advanceline - l_T0SecureAmt;
                        l_PPse:= (l_PP + l_advanceline - l_T0SecureAmt) / (((1 + l_deffeerate - l_mrratiorate/100 * least(l_marginrefprice, l_mrpriceloan) /(to_number(p_txmsg.txfields('11').value) * to_number(p_txmsg.txfields('98').value)) )) / (1 + l_DefFeeRate));
                     --   l_PPSE_BL:=(l_PP + (l_advanceline-l_aprT0) - l_T0SecureAmt) / (((1 + l_deffeerate - l_mrratiorate/100 * least(l_marginrefprice, l_mrpriceloan) /(to_number(p_txmsg.txfields('11').value) * to_number(p_txmsg.txfields('98').value)) )) / (1 + l_DefFeeRate));
                    --else
                     --   l_PPse:=l_PP + l_advanceline - l_T0SecureAmt;
                    --end if;
                end if;
                plog.debug('LINHLNB:l_mrratiorate:'||l_mrratiorate);
                plog.debug('LINHLNB:l_marginprice:'||l_marginprice);
                plog.debug('LINHLNB:l_mrpriceloan:'||l_mrpriceloan);
                plog.debug('LINHLNB:Price:'||p_txmsg.txfields('11').value);
                plog.debug('LINHLNB:l_advanceline:'||l_advanceline);
                plog.debug('LINHLNB:l_deffeerate:'||l_deffeerate);
                plog.debug('LINHLNBl_PPse:'||l_PPse);
                plog.debug('LINHLNBl_PP00:'||l_PP);

                 --GianhVG them code xu ly cho Room dac biet
                begin
                    select nvl(roomchk,'Y') into l_roomchk from semast se
                    where se.afacctno = p_txmsg.txfields('03').value and se.codeid = p_txmsg.txfields('01').value;
                exception when others then
                    l_roomchk:='Y';
                end;
                if l_roomchk ='N' then
                    --Kiem soat theo Room dac biet.
                    if txpks_prchk.fn_afRoomLimitCheck(p_txmsg.txfields('03').value, p_txmsg.txfields('01').value, to_number(p_txmsg.txfields('12').value), p_err_code) <> 0 then
                        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                        RETURN errnums.C_BIZ_RULE_INVALID;
                    end if;
                else

                    -- Room
                    begin
                    select greatest(r1.syroomlimit - r1.syroomused - nvl(u1.sy_prinused,0),0) avlsyroom,
                           greatest(r1.roomlimit - nvl(u1.prinused,0),0) avlroom
                            into l_avlsyroomqtty, l_avlroomqtty
                    from vw_marginroomsystem r1,
                    (select codeid, sum(case when restype = 'M' then prinused else 0 end) prinused,
                                sum(case when restype = 'S' then prinused else 0 end) sy_prinused
                        from vw_afpralloc_all
                        where codeid = p_txmsg.txfields('01').value
                        group by codeid) u1
                    where r1.codeid = u1.codeid(+)
                    and r1.codeid = p_txmsg.txfields('01').value;
                    exception when others then
                        l_avlsyroomqtty:=0;
                        l_avlroomqtty:=0;
                    end;

                    --AvlQtty
                    begin
                    select greatest(nvl(l_avlsyroomqtty + nvl(sy_prinused,0),0) - nvl(least(trade + receiving - EXECQTTY + BUYQTTY,l_avlsyroomqtty + nvl(sy_prinused,0)),0),0) avlsyqtty,
                            greatest(nvl(l_avlroomqtty + nvl(prinused,0),0) - nvl(least(trade + receiving - EXECQTTY + BUYQTTY,l_avlroomqtty + nvl(prinused,0)),0),0) avlqtty
                           into l_avlsyqtty, l_avlqtty
                      from
                      (select se.codeid, af.actype,se.afacctno,se.acctno, se.trade + se.grpordamt trade, nvl(sts.receiving,0) receiving,nvl(BUYQTTY,0) BUYQTTY,nvl(od.EXECQTTY,0) EXECQTTY,  nvl(afpr.prinused,0) prinused, nvl(afpr.sy_prinused,0) sy_prinused
                          from semast se inner join afmast af on se.afacctno =af.acctno
                          left join
                          (select sum(BUYQTTY) BUYQTTY, sum(EXECQTTY) EXECQTTY , SEACCTNO
                                  from (
                                      SELECT (case when od.exectype IN ('NB','BC')
                                                  then (case when (af.trfbuyext * af.trfbuyrate) > 0 then 0 else REMAINQTTY end)
                                                          + (case when nvl(sts_trf.islatetransfer,0) > 0 then 0 else EXECQTTY - DFQTTY end)
                                                  else 0 end) BUYQTTY,
                                                  (case when od.exectype IN ('NB','BC') then REMAINQTTY + EXECQTTY - DFQTTY else 0 end) TOTALBUYQTTY,
                                              (case when od.exectype IN ('NS','MS') then EXECQTTY - nvl(dfexecqtty,0) else 0 end) EXECQTTY,SEACCTNO
                                      FROM odmast od, afmast af, (select orgorderid, (trfbuyext * trfbuyrate) * (amt - trfexeamt) islatetransfer from stschd where duetype = 'SM' and deltd <> 'Y') sts_trf,
                                            (select orderid, sum(execqtty) dfexecqtty from odmapext where type = 'D' group by orderid) dfex
                                         where od.afacctno = p_txmsg.txfields('03').value and od.afacctno = af.acctno and od.orderid = sts_trf.orgorderid(+) and od.orderid = dfex.orderid(+)
                                         and od.txdate =(select to_date(VARVALUE,'DD/MM/RRRR') from sysvar where grname='SYSTEM' and varname='CURRDATE')
                                         AND od.deltd <> 'Y'
                                         and not(od.grporder='Y' and od.matchtype='P') --Lenh thoa thuan tong khong tinh vao
                                         AND od.exectype IN ('NS', 'MS','NB','BC')
                                      )
                           group by seacctno
                           ) OD
                          on OD.seacctno =se.acctno
                          left join
                          (SELECT STS.CODEID,STS.AFACCTNO,
                                  SUM(CASE WHEN DUETYPE ='RS' and nvl(sts_trf.islatetransfer,0) = 0 AND STS.TXDATE <> (SELECT TO_DATE(VARVALUE,'DD/MM/YYYY') FROM SYSVAR WHERE GRNAME='SYSTEM' AND VARNAME='CURRDATE') THEN QTTY-AQTTY ELSE 0 END) RECEIVING
                              FROM STSCHD STS, ODMAST OD, ODTYPE TYP, (select orgorderid, (trfbuyext * trfbuyrate) * (amt - trfexeamt) islatetransfer from stschd where duetype = 'SM' and deltd <> 'Y') sts_trf
                              WHERE STS.DUETYPE IN ('RM','RS') AND STS.STATUS ='N'
                                  AND STS.DELTD <>'Y' AND STS.ORGORDERID=OD.ORDERID AND OD.ACTYPE =TYP.ACTYPE
                                  and od.orderid = sts_trf.orgorderid(+) and sts.afacctno = p_txmsg.txfields('03').value
                                  GROUP BY STS.AFACCTNO,STS.CODEID
                           ) sts
                          on sts.afacctno =se.afacctno and sts.codeid=se.codeid
                          left join
                          (
                              select afacctno, codeid,
                                  nvl(sum(case when restype = 'M' then prinused else 0 end),0) prinused,
                                  nvl(sum(case when restype = 'S' then prinused else 0 end),0) sy_prinused
                              from vw_afpralloc_all
                              where codeid = p_txmsg.txfields('01').value and afacctno = p_txmsg.txfields('03').value
                              group by afacctno, codeid
                          ) afpr  on afpr.afacctno =se.afacctno and afpr.codeid=se.codeid
                      ) se,
                      afmast af, afserisk rsk,securities_info sb
                      where se.afacctno =af.acctno and se.codeid=sb.codeid
                      and se.codeid=rsk.codeid (+) and se.actype =rsk.actype (+)
                      and se.afacctno = p_txmsg.txfields('03').value and se.codeid = p_txmsg.txfields('01').value;
                    EXCEPTION when others then
                        l_avlsyqtty:=l_avlsyroomqtty;
                        l_avlqtty:=l_avlroomqtty;
                    end;

                    if l_chksysctrl = 'Y' then
                        l_PP0_add:= least(least(l_marginrefprice, l_mrpriceloan) * l_mrratiorate /100 * l_avlqtty,
                                            least(l_marginprice, l_mrpriceloan) * l_mrratiorate/100 * l_avlsyqtty);
                    else
                        l_PP0_add:= least(l_marginprice, l_mrpriceloan) * l_mrratiorate/100 * l_avlsyqtty;
                    end if;
                    plog.error('LINHLNBl_PP0_add:'||l_PP0_add);

                    plog.error('LINHLNBl_PPse0:'||l_PPse);
                    l_PPse:=least(l_PPse,l_PP + l_advanceline - l_T0SecureAmt + l_PP0_add);
                  --  l_PPSE_BL:= least(l_PPse,l_PP + (l_advanceline-l_aprT0) - l_T0SecureAmt + l_PP0_add);
                    plog.error('LINHLNBl_PPse:'||l_PPse);
                end if;

                IF NOT ceil(l_PPse) >= to_number(ROUND((1 + l_deffeerate)*p_txmsg.txfields('96').value*p_txmsg.txfields('12').value*p_txmsg.txfields('11').value*p_txmsg.txfields('98').value,0)) THEN
                    p_err_code := '-400116';
                    RETURN errnums.C_BIZ_RULE_INVALID;
                END IF;
            end if;
            /* --00 Ktra Co dung BL phe duyet mua CK blacklist khong.
                IF l_aprT0>0 THEN
                  IF NOT (ceil(l_PPSE_BL)>=to_number(ROUND((1 + l_deffeerate)*p_txmsg.txfields('96').value*p_txmsg.txfields('12').value*p_txmsg.txfields('11').value*p_txmsg.txfields('98').value,0))) THEN
                    p_err_code := '-100145';
                    RETURN errnums.C_BIZ_RULE_INVALID;
                    END IF;
                  END IF;
                 --end 00*/
        end if;

        IF NOT (to_number(l_AVLLIMIT) >= to_number(p_txmsg.txfields('96').value*p_txmsg.txfields('12').value*p_txmsg.txfields('11').value*p_txmsg.txfields('98').value+p_txmsg.txfields('40').value)) THEN
            p_err_code := '-400117';
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;

        if not cspks_odproc.fn_checkTradingAllow(p_txmsg.txfields('03').value, p_txmsg.txfields('01').value, 'B' , p_err_code) then
            Return errnums.C_BIZ_RULE_INVALID;
        end if;

    END IF;
    plog.debug (pkgctx, '<<END OF fn_txPreAppCheck');
    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'fn_txPreAppCheck');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txPreAppCheck;

FUNCTION fn_txAftAppCheck(p_txmsg in out tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    l_lngErrCode number(20,0);
    l_err_param varchar2(1000);
    l_count number(20,0);
    l_strCUSTID varchar2(30);
    l_strCODEID varchar2(30);
    l_strACTYPE varchar2(30);
    l_strAFACCTNO varchar2(30);
    l_strCIACCTNO varchar2(30);
    l_strAFSTATUS varchar2(30);
    l_strSEACCTNO varchar2(30);
    l_strCUSTODYCD varchar2(30);
    l_strTIMETYPE varchar2(30);
    l_strVOUCHER varchar2(30);
    l_strCONSULTANT varchar2(30);
    l_strORDERID varchar2(30);
    l_strBORS varchar2(30);
    l_strContrafirm varchar2(30);
    l_strContrafirm2 varchar2(30);
    l_strContraCus varchar2(30);
    l_strPutType varchar2(30);
    l_strEXPDATE varchar2(30);
    l_strEXECTYPE varchar2(30);
    l_strNORK varchar2(30);
    l_strMATCHTYPE varchar2(30);
    l_strVIA varchar2(30);
    l_strCLEARCD varchar2(30);
    l_strPRICETYPE varchar2(30);
    l_strDESC varchar2(300);
    l_strTRADEPLACE varchar2(30);
    l_strSYMBOL varchar2(30);
    l_strMarginType varchar2(30);
    l_strBUYIFOVERDUE varchar2(30);
    l_strAFTYPE varchar2(30);
    l_dblCLEARDAY number(30,4);
    l_dblQUOTEPRICE number(30,9); --Sua lai de nhap duoc 6 so sau dau phay
    l_dblORDERQTTY number(30,4);
    l_dblBRATIO number(30,4);
    l_dblLIMITPRICE number(30,4);
    l_dblAFADVANCELIMIT number(30,4);
    l_dblODBALANCE  number(30,4);
    l_dblODTYPETRADELIMIT number(30,4);
    l_dblAFTRADELIMIT number(30,4);
    l_dblALLOWBRATIO number(30,4);
    l_dblDEFFEERATE number(30,4);
    l_dblMarginRate  number(30,4);
    l_dblMarginRatio number(30,4);
    l_dblSecuredRatioMin number(30,4);
    l_dblSecuredRatioMax number(30,4);
    l_dblTyp_Bratio number(30,4);
    l_dblAF_Bratio number(30,4);
    ml_dblSecureRatio number(30,4);
    l_dblRoom number(30,4);
    l_dblTraderID  number(30,4);
    l_blnReversal boolean;
    l_strHalt char(1);
    l_strCompanyFirm varchar2(50);
    l_dblTradeLot number(30,4);
    l_dblTradeUnit number(30,4);
    l_dblFloorPrice number(30,4);
    l_dblCeilingPrice number(30,4);
    l_dblTickSize number(30,4);
    l_dblFromPrice number(30,4);
    l_dblMarginMaxQuantity  number(30,4);
    l_dblBfAccoutMarginRate number(30,4);
    l_dblAfAccoutMarginRate number(30,4);
    l_dblLongPosision number(30,4);
    l_dblBuyMinAmount number(30,4);
    l_dblSellMinAmount number(30,4);
    l_dblCheckMinAmount number(30,4);
    l_strPreventMinOrder varchar2(30);
    l_strTRADEBUYSELL  varchar2(30);
    l_strOVRRQD varchar2(100);
    l_strSETYPE varchar2(10);
    Pl_REFCURSOR   PKG_REPORT.REF_CURSOR;
    l_index VARCHAR2(6);
    l_dblAvlLimit number(30,4);
    l_ISMARGIN varchar2(1);

    v_strORDERTRADEBUYSELL  Varchar2(10);
    l_strControlCode Varchar2(10);
    v_strTemp  Varchar2(100);
    v_strSysCheckBuySell Varchar2(100);


BEGIN
   plog.setbeginsection (pkgctx, 'fn_txAftAppCheck');
   plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppCheck>>');
   /***************************************************************************************************
    * PUT YOUR SPECIFIC RULE HERE, FOR EXAMPLE:
    * IF NOT <<YOUR BIZ CONDITION>> THEN
    *    p_err_code := '<<ERRNUM>>'; -- Pre-defined in DEFERROR table
    *    plog.setendsection (pkgctx, 'fn_txAftAppCheck');
    *    RETURN errnums.C_BIZ_RULE_INVALID;
    * END IF;
    ***************************************************************************************************/
    ---------------------------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------------------------
    l_lngErrCode:= errnums.C_BIZ_RULE_INVALID;
    p_err_code:=0;
    plog.debug(pkgctx,'Delete: ' || p_txmsg.deltd);
    if p_txmsg.deltd='Y' then
        l_blnReversal:=true;
    else
        l_blnReversal:=false;
    end if;
    if l_blnReversal then
        --Xoa giao dich thi check
        SELECT count(1) into l_count FROM ODMAST WHERE TXNUM=p_txmsg.txnum AND TXDATE=TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT) AND ORSTATUS IN ('1','2','8');
        if l_count<=0 then
            plog.debug(pkgctx,'l_lngErrCode: ' || errnums.C_OD_ODMAST_CANNOT_DELETE);
            p_err_code := errnums.C_OD_ODMAST_CANNOT_DELETE;
            return l_lngErrCode;
        end if;

    else
        --Make giao dich thi CHECK
        plog.debug(pkgctx,'GET FLD');
        /*FOR i IN p_txmsg.txfields.FIRST .. p_txmsg.txfields.LAST
        LOOP
            l_index := lpad(i,2,'0');
            plog.debug(pkgctx,'l_index: ' || l_index);
            IF p_txmsg.txfields(l_index).defname = 'CODEID' THEN
                plog.debug(pkgctx,'CODEID: ' || p_txmsg.txfields(l_index).value);
                l_strCODEID := p_txmsg.txfields(l_index).value;
            ELSIF p_txmsg.txfields(l_index).defname = 'ACTYPE' THEN
                plog.debug(pkgctx,'ACTYPE: ' || p_txmsg.txfields(l_index).value);
                l_strACTYPE := p_txmsg.txfields(l_index).value;
            ELSIF p_txmsg.txfields(l_index).defname = 'AFACCTNO' THEN
                plog.debug(pkgctx,'AFACCTNO: ' || p_txmsg.txfields(l_index).value);
                l_strAFACCTNO := p_txmsg.txfields(l_index).value;
            ELSIF p_txmsg.txfields(l_index).defname = 'TIMETYPE' THEN
                plog.debug(pkgctx,'TIMETYPE: ' || p_txmsg.txfields(l_index).value);
                l_strTIMETYPE := p_txmsg.txfields(l_index).value;
            ELSIF p_txmsg.txfields(l_index).defname = 'EXPDATE' THEN
                plog.debug(pkgctx,'EXPDATE: ' || p_txmsg.txfields(l_index).value);
                l_strEXPDATE := p_txmsg.txfields(l_index).value;
            ELSIF p_txmsg.txfields(l_index).defname = 'EXECTYPE' THEN
                plog.debug(pkgctx,'EXECTYPE: ' || p_txmsg.txfields(l_index).value);
                l_strEXECTYPE := p_txmsg.txfields(l_index).value;
            ELSIF p_txmsg.txfields(l_index).defname = 'NORK' THEN
                plog.debug(pkgctx,'NORK: ' || p_txmsg.txfields(l_index).value);
                l_strNORK := p_txmsg.txfields(l_index).value;
            ELSIF p_txmsg.txfields(l_index).defname = 'MATCHTYPE' THEN
                plog.debug(pkgctx,'MATCHTYPE: ' || p_txmsg.txfields(l_index).value);
                l_strMATCHTYPE := p_txmsg.txfields(l_index).value;
            ELSIF p_txmsg.txfields(l_index).defname = 'VIA' THEN
                plog.debug(pkgctx,'VIA: ' || p_txmsg.txfields(l_index).value);
                l_strVIA := p_txmsg.txfields(l_index).value;
            ELSIF p_txmsg.txfields(l_index).defname = 'CLEARCD' THEN
                plog.debug(pkgctx,'CLEARCD: ' || p_txmsg.txfields(l_index).value);
                l_strCLEARCD := p_txmsg.txfields(l_index).value;
            ELSIF p_txmsg.txfields(l_index).defname = 'CLEARDAY' THEN
                plog.debug(pkgctx,'CLEARDAY: ' || p_txmsg.txfields(l_index).value);
                l_dblCLEARDAY := p_txmsg.txfields(l_index).value;
            ELSIF p_txmsg.txfields(l_index).defname = 'CONTRACUS' THEN
                plog.debug(pkgctx,'ContraCus: ' || p_txmsg.txfields(l_index).value);
                l_strContraCus := p_txmsg.txfields(l_index).value;
            ELSIF p_txmsg.txfields(l_index).defname = 'CONTRAFIRM' THEN
                plog.debug(pkgctx,'Contrafirm: ' || p_txmsg.txfields(l_index).value);
                l_strContrafirm := p_txmsg.txfields(l_index).value;
            ELSIF p_txmsg.txfields(l_index).defname = 'PUTTYPE' THEN
                plog.debug(pkgctx,'PutType: ' || p_txmsg.txfields(l_index).value);
                l_strPutType := p_txmsg.txfields(l_index).value;
            ELSIF p_txmsg.txfields(l_index).defname = 'DESC' THEN
                plog.debug(pkgctx,'DESC: ' || p_txmsg.txfields(l_index).value);
                l_strDESC := p_txmsg.txfields(l_index).value;
            ELSIF p_txmsg.txfields(l_index).defname = 'ORDERID' THEN
                plog.debug(pkgctx,'ORDERID: ' || p_txmsg.txfields(l_index).value);
                l_strORDERID := p_txmsg.txfields(l_index).value;
            ELSIF p_txmsg.txfields(l_index).defname = 'CONSULTANT' THEN
                plog.debug(pkgctx,'CONSULTANT: ' || p_txmsg.txfields(l_index).value);
                l_strCONSULTANT := p_txmsg.txfields(l_index).value;
            ELSIF p_txmsg.txfields(l_index).defname = 'VOUCHER' THEN
                plog.debug(pkgctx,'VOUCHER: ' || p_txmsg.txfields(l_index).value);
                l_strVOUCHER := p_txmsg.txfields(l_index).value;
            ELSIF p_txmsg.txfields(l_index).defname = 'LIMITPRICE' THEN
                plog.debug(pkgctx,'LIMITPRICE: ' || p_txmsg.txfields(l_index).value);
                l_dblLIMITPRICE := p_txmsg.txfields(l_index).value;
            ELSIF p_txmsg.txfields(l_index).defname = 'BRATIO' THEN
                plog.debug(pkgctx,'l_dblBRATIO: ' || p_txmsg.txfields(l_index).value);
                l_dblBRATIO := p_txmsg.txfields(l_index).value;
            ELSIF p_txmsg.txfields(l_index).defname = 'ORDERQTTY' THEN
                plog.debug(pkgctx,'l_dblORDERQTTY: ' || p_txmsg.txfields(l_index).value);
                l_dblORDERQTTY := p_txmsg.txfields(l_index).value;
            ELSIF p_txmsg.txfields(l_index).defname = 'CONTRAFIRM2' THEN
                plog.debug(pkgctx,'Contrafirm2: ' || p_txmsg.txfields(l_index).value);
                l_strContrafirm2 := p_txmsg.txfields(l_index).value;
            END IF;
        END LOOP;*/

        --Make giao dich thi check
        l_strCODEID := p_txmsg.txfields('01').value;
        l_strACTYPE := p_txmsg.txfields('02').value;
        l_strAFACCTNO := p_txmsg.txfields('03').value;
        l_strTIMETYPE := p_txmsg.txfields('20').value;
        l_strEXPDATE := p_txmsg.txfields('21').value;
        l_strEXECTYPE := p_txmsg.txfields('22').value;
        l_strNORK := p_txmsg.txfields('23').value;
        l_strMATCHTYPE := p_txmsg.txfields('24').value;
        l_strVIA := p_txmsg.txfields('25').value;
        l_strCLEARCD := p_txmsg.txfields('26').value;
        l_strPRICETYPE := p_txmsg.txfields('27').value;
        l_dblCLEARDAY := p_txmsg.txfields('10').value;
        l_dblQUOTEPRICE := p_txmsg.txfields('11').value;
        l_dblORDERQTTY := p_txmsg.txfields('12').value;
        l_dblBRATIO := p_txmsg.txfields('13').value;
        l_dblLIMITPRICE := p_txmsg.txfields('14').value;
        l_strVOUCHER := p_txmsg.txfields('28').value;
        l_strCONSULTANT := p_txmsg.txfields('29').value;
        l_strORDERID := p_txmsg.txfields('04').value;
        l_strDESC := p_txmsg.txfields('30').value;
        l_strContrafirm := '';
        l_strContraCus := '';
        l_strPutType := '';
        l_strContrafirm2 := '';

        /*l_strCIACCTNO := l_strAFACCTNO;
        l_strSEACCTNO := l_strAFACCTNO || l_strCODEID;

        --kIEM TRA TAI KHOAN se co ton tai hay khong
        SELECT count(1) into l_count FROM SEMAST WHERE ACCTNO=l_strSEACCTNO;
        if l_count<=0 then
            --Neu khong co thi tu dong mo tai khoan
            SELECT TYP.SETYPE, af.custid into l_strSETYPE, l_strCUSTID FROM AFMAST AF, AFTYPE TYP WHERE AF.ACTYPE=TYP.ACTYPE AND AF.ACCTNO= l_strAFACCTNO;
            INSERT INTO SEMAST (ACTYPE,CUSTID,ACCTNO,CODEID,AFACCTNO,
                            OPNDATE,LASTDATE,STATUS,IRTIED,IRCD,
                            COSTPRICE,TRADE,MORTAGE,MARGIN,NETTING,
                            STANDING,WITHDRAW,DEPOSIT,LOAN)
                            VALUES (l_strSETYPE, l_strCUSTID, l_strSEACCTNO , l_strCODEID , l_strAFACCTNO ,
                            p_txmsg.txdate,p_txmsg.txdate,'A','Y','001',
                            0,0,0,0,0,0,0,0,0);
        end if;*/

        -- Sua lai, lenh GTC van phai check cac d/k nhu lenh thong thuong
        -- TheNN, 24-Apr-2012
        /*if p_txmsg.txfields('20').value='G' then
            --Lenh GTC khong phai check
            plog.debug(pkgctx,'Leng GTC: ');
            Return systemnums.C_SUCCESS;
        end if;*/
        l_dblALLOWBRATIO:=1;

        plog.debug(pkgctx,'abt to check ODTYPE exists or not');
        begin
            SELECT TRADELIMIT,BRATIO/100,DEFFEERATE/100
            into l_dblODTYPETRADELIMIT,l_dblALLOWBRATIO,l_dblDEFFEERATE
            FROM ODTYPE WHERE STATUS='Y' AND ACTYPE=l_strACTYPE;
        EXCEPTION
        WHEN no_data_found THEN
            plog.debug(pkgctx,'l_lngErrCode: ' || errnums.C_OD_ODTYPE_NOTFOUND);
            p_err_code := errnums.C_OD_ODTYPE_NOTFOUND;
            return l_lngErrCode;
        END;


        plog.debug(pkgctx,'abt to check AFMAST exists or not');
        begin
            l_strCIACCTNO := l_strAFACCTNO;
            l_strSEACCTNO := l_strAFACCTNO || l_strCODEID;
            SELECT af.CUSTID,af.STATUS,af.TRADELINE,af.ADVANCELINE,af.BRATIO,af.MRIRATE,af.MRIRATIO,mrt.MRTYPE,MRT.BUYIFOVERDUE,af.ACTYPE AFTYPE, case when mrt.mrtype = 'T' and nvl(lnt.chksysctrl,'N') = 'Y' then 'Y' else 'N' end
                into l_strCUSTID,l_strAFSTATUS,l_dblAFTRADELIMIT,l_dblAFADVANCELIMIT,l_dblALLOWBRATIO,l_dblMarginRate, l_dblMarginRatio,l_strMarginType,l_strBUYIFOVERDUE,l_strAFTYPE, l_ISMARGIN
            FROM AFMAST af,AFTYPE aft, MRTYPE mrt, lntype lnt
            WHERE ACCTNO= l_strAFACCTNO  AND af.ACTYPE=aft.ACTYPE and aft.MRTYPE=mrt.ACTYPE and aft.lntype = lnt.actype(+);
        EXCEPTION
        WHEN no_data_found THEN
            plog.debug(pkgctx,'l_lngErrCode: ' || errnums.C_CF_AFMAST_NOTFOUND);
            p_err_code := errnums.C_CF_AFMAST_NOTFOUND;
            return l_lngErrCode;
        end;

        --Kiem tra tai khoan Margin neu bi qua han va l_strBUYIFOVERDUE="N" thi khong cho dat lenh mua
        If (l_strEXECTYPE = 'NB' Or l_strEXECTYPE = 'BC') And l_strBUYIFOVERDUE = 'N'  Then
            SELECT count(1) into l_count FROM CIMAST CI WHERE OVAMT >0 AND CI.ACCTNO= l_strCIACCTNO;
            if l_count>0 then
                plog.debug(pkgctx,'l_lngErrCode: ' || errnums.C_MR_ACCTNO_OVERDUE);
                p_err_code := errnums.C_MR_ACCTNO_OVERDUE;
                return l_lngErrCode;
            end if;
        End If;
        --Kiem tra tai khoan CI co ton tai hay khong
        plog.debug(pkgctx,'abt to check CIMAST exists or not');
        begin
            SELECT (BALANCE-ODAMT) into l_dblODBALANCE FROM CIMAST WHERE ACCTNO=l_strCIACCTNO;
        EXCEPTION
        WHEN no_data_found THEN
            plog.debug(pkgctx,'l_lngErrCode: ' || errnums.C_CI_CIMAST_NOTFOUND);
            p_err_code := errnums.C_CI_CIMAST_NOTFOUND;
            return l_lngErrCode;
        end;
        --kIEM TRA TAI KHOAN se co ton tai hay khong
        SELECT count(1) into l_count FROM SEMAST WHERE ACCTNO=l_strSEACCTNO;
        if l_count<=0 then
            --Neu khong co thi tu dong mo tai khoan
            SELECT TYP.SETYPE into l_strSETYPE FROM AFMAST AF, AFTYPE TYP WHERE AF.ACTYPE=TYP.ACTYPE AND AF.ACCTNO= l_strAFACCTNO;
            INSERT INTO SEMAST (ACTYPE,CUSTID,ACCTNO,CODEID,AFACCTNO,
                            OPNDATE,LASTDATE,STATUS,IRTIED,IRCD,
                            COSTPRICE,TRADE,MORTAGE,MARGIN,NETTING,
                            STANDING,WITHDRAW,DEPOSIT,LOAN)
                            VALUES (l_strSETYPE, l_strCUSTID, l_strSEACCTNO , l_strCODEID , l_strAFACCTNO ,
                            p_txmsg.txdate,p_txmsg.txdate,'A','Y','001',
                            0,0,0,0,0,0,0,0,0);
        end if;

        --Kiem tra ma khach hang co ton tai hay khong
        plog.debug(pkgctx,'abt to check CFMAST exists or not');
        begin
            SELECT CUSTODYCD into l_strCUSTODYCD FROM CFMAST WHERE CUSTID=l_strCUSTID;
        EXCEPTION
        WHEN no_data_found THEN
            plog.debug(pkgctx,'l_lngErrCode: ' || errnums.C_CF_CUSTOMER_NOTFOUND);
            p_err_code := errnums.C_CF_CUSTOMER_NOTFOUND;
            return l_lngErrCode;
        end;
        plog.debug(pkgctx,'abt to check SBSECURITIES exists or not');
        begin
            SELECT HALT,TRADEPLACE,SYMBOL into l_strHalt,l_strTRADEPLACE,l_strSYMBOL FROM SBSECURITIES WHERE CODEID= l_strCODEID;
        EXCEPTION
        WHEN no_data_found THEN
            plog.debug(pkgctx,'l_lngErrCode: ' || errnums.C_OD_SECURITIES_INFO_UNDEFINED);
            p_err_code := errnums.C_OD_SECURITIES_INFO_UNDEFINED;
            return l_lngErrCode;
        end;
        If l_strHalt = 'Y' Then
            p_err_code := errnums.C_OD_CODEID_HALT;
            return l_lngErrCode;
        end if;
        If (l_strTRADEPLACE = errnums.gc_TRADEPLACE_HCMCSTC Or l_strTRADEPLACE = errnums.gc_TRADEPLACE_HNCSTC) And Length(Trim(l_strCUSTODYCD)) = 0 Then
            p_err_code := errnums.C_OD_LISTED_NEEDCUSTODYCD;
            Return l_lngErrCode;
        End If;
        If l_strTRADEPLACE = errnums.gc_TRADEPLACE_HCMCSTC And (l_strEXECTYPE = 'NB' Or l_strEXECTYPE = 'NS') Then
            --Tham so ham Check TraderID
            SELECT FNC_CHECK_TRADERID( l_strMATCHTYPE ,substr(l_strEXECTYPE ,2,1), l_strVIA ) TRD into l_dblTraderID FROM DUAL;
            If l_dblTraderID = 0 Then
                p_err_code := errnums.C_OD_TRADERID_NOT_INVALID;
                Return l_lngErrCode;
            End If;
        End If;
        --Check contra sell order when place buy order (2PT)
        If (l_strTRADEPLACE = errnums.gc_TRADEPLACE_UPCOM) And (l_strMATCHTYPE = 'P') And (l_strPutType = 'N') Then
            select varvalue into l_strCompanyFirm from sysvar where grname ='SYSTEM' and varname='COMPANYCD';
            --Neu la lenh Upcom thoa thuan cung cong ty phai kiem tra
            If l_strEXECTYPE = 'NB' Then
                If (l_strContrafirm2 = l_strCompanyFirm Or l_strContrafirm2 = '') Then
                    l_strContrafirm2 := l_strCompanyFirm;
                    If l_strContraCus <> '' Then
                        SELECT COUNT(ROWNUM) into l_count FROM ODMAST OD,OOD OUTOD
                        WHERE OD.orderid = OUTOD.orgorderid AND OD.orstatus IN ('1','2','8')
                        AND OUTOD.oodstatus IN ('N','S') AND OD.orderid =  l_strContraCus  AND OD.EXECTYPE='NS'
                        AND OD.matchtype='P' AND OD.CODEID=l_strCODEID  AND OD.QUOTEPRICE=(l_dblQUOTEPRICE) * 1000
                        AND OD.ORDERQTTY= l_dblORDERQTTY  AND OD.PUTTYPE='N' AND OD.CODEID IN (SELECT CODEID FROM SBSECURITIES WHERE TRADEPLACE= l_strTRADEPLACE );

                        If l_count<=0 Then
                            p_err_code := errnums.C_OD_CONTRA_ORDER_NOT_FOUND;
                            Return l_lngErrCode;
                        End If;
                    Else
                        p_err_code := errnums.C_OD_CONTRA_ORDER_NOT_FOUND;
                        Return l_lngErrCode;
                    End If;
                End If;
            End If;
        End If;

        plog.debug(pkgctx,'abt to check SBSECURITIES_INFO exists or not');
        begin
            SELECT TRADELOT,TRADEUNIT,NVL(RSK.MRMAXQTTY,0) MRMAXQTTY,nvl(BMINAMT,0) BMINAMT,nvl(SMINAMT,0) SMINAMT,FLOORPRICE,CEILINGPRICE,CURRENT_ROOM,TRADEBUYSELL
            into l_dblTradeLot,l_dblTradeUnit,l_dblMarginMaxQuantity,l_dblBuyMinAmount,l_dblSellMinAmount,l_dblFloorPrice,l_dblCeilingPrice,l_dblRoom,l_strTRADEBUYSELL
            FROM SECURITIES_INFO INF, SECURITIES_RISK RSK WHERE INF.CODEID= l_strCODEID  AND INF.CODEID=RSK.CODEID(+);
            /*--Kiem tra voi lenh mua sau khi dat ty le margin tai khoan khong duoc nho hon ty le ban dau
            --hoac ty le sau khi dat phai lon hon ty le truoc khi dat
            If (l_strEXECTYPE = 'NB' Or l_strEXECTYPE = 'BC') And l_strMarginType <> 'N' Then
                -- 1.
                plog.debug(pkgctx,'GETACCOUNTMARGINRATE:' || l_strAFACCTNO || p_txmsg.txdate);
                GETACCOUNTMARGINRATE(pl_refcursor,l_strAFACCTNO,to_char(p_txmsg.txdate,'DD/MM/YYYY'),0,0,0,'','');
                loop
                    FETCH pl_refcursor
                         INTO l_dblBfAccoutMarginRate,l_dblAvlLimit;
                    EXIT WHEN pl_refcursor%NOTFOUND;
                end loop;
                plog.debug(pkgctx,'Before Margin rate:' || l_dblBfAccoutMarginRate);

                plog.debug(pkgctx,'GETACCOUNTMARGINRATE(acct:' || l_strAFACCTNO || ' date: ' || p_txmsg.txdate || ' Qtty:' || to_char(l_dblORDERQTTY) || ' Price' || to_char(l_dblQUOTEPRICE * l_dblTradeUnit) || ' ratio:' || to_char(100 + l_dblDEFFEERATE * 100) || ' Symbol:' || l_strSYMBOL);
                GETACCOUNTMARGINRATE(pl_refcursor,l_strAFACCTNO,to_char(p_txmsg.txdate,'DD/MM/YYYY'),l_dblORDERQTTY,l_dblQUOTEPRICE * l_dblTradeUnit, 100 + l_dblDEFFEERATE * 100,l_strSYMBOL,'');
                loop
                    FETCH pl_refcursor
                         INTO l_dblAfAccoutMarginRate,l_dblAvlLimit;
                    EXIT WHEN pl_refcursor%NOTFOUND;
                end loop;
                plog.debug(pkgctx,'After Margin rate:' || l_dblAfAccoutMarginRate);
                If (l_dblAfAccoutMarginRate < l_dblBfAccoutMarginRate) And l_dblAfAccoutMarginRate < l_dblMarginRate Then
                    p_err_code := errnums.C_MR_ACC_MRRATE_UNDER_IRATE;
                    Return l_lngErrCode;
                End If;
                if l_ISMARGIN = 'Y' then
                    -- 2. For Margin TT74
                    plog.debug(pkgctx,'GETACCOUNTMARGINRATE_FOR_MR:' || l_strAFACCTNO || p_txmsg.txdate);
                    GETACCOUNTMARGINRATE_FOR_MR(pl_refcursor,l_strAFACCTNO,to_char(p_txmsg.txdate,'DD/MM/YYYY'),0,0,0,'','');
                    loop
                        FETCH pl_refcursor
                             INTO l_dblBfAccoutMarginRate,l_dblAvlLimit;
                        EXIT WHEN pl_refcursor%NOTFOUND;
                    end loop;
                    plog.debug(pkgctx,'Before Margin rate:' || l_dblBfAccoutMarginRate);

                    plog.debug(pkgctx,'GETACCOUNTMARGINRATE_FOR_MR(acct:' || l_strAFACCTNO || ' date: ' || p_txmsg.txdate || ' Qtty:' || to_char(l_dblORDERQTTY) || ' Price' || to_char(l_dblQUOTEPRICE * l_dblTradeUnit) || ' ratio:' || to_char(100 + l_dblDEFFEERATE * 100) || ' Symbol:' || l_strSYMBOL);
                    GETACCOUNTMARGINRATE_FOR_MR(pl_refcursor,l_strAFACCTNO,to_char(p_txmsg.txdate,'DD/MM/YYYY'),l_dblORDERQTTY,l_dblQUOTEPRICE * l_dblTradeUnit, 100 + l_dblDEFFEERATE * 100,l_strSYMBOL,'');
                    loop
                        FETCH pl_refcursor
                             INTO l_dblAfAccoutMarginRate,l_dblAvlLimit;
                        EXIT WHEN pl_refcursor%NOTFOUND;
                    end loop;
                    plog.debug(pkgctx,'After Margin rate:' || l_dblAfAccoutMarginRate);
                    If (l_dblAfAccoutMarginRate < l_dblBfAccoutMarginRate) And l_dblAfAccoutMarginRate < l_dblMarginRatio Then
                        p_err_code := errnums.C_MR_ACC_MRRATE_UNDER_IRATE;
                        Return l_lngErrCode;
                    End If;

                end if;
            End If;*/
            --Kiem tra voi lenh mua sau khi dat tong khoi luong long chung khoan margin khong duoc vuot qua MRMAXQTTY
            /*plog.debug(pkgctx,'Check max quantity' );
            If (l_strEXECTYPE = 'NB' Or l_strEXECTYPE = 'BC') And l_strMarginType <> 'N' And l_dblMarginMaxQuantity > 0 Then
                GETMARGINQUANTITYBYSYMBOL(pl_refcursor,l_strSYMBOL);
                loop
                    FETCH pl_refcursor
                         INTO l_dblLongPosision;
                    EXIT WHEN pl_refcursor%NOTFOUND;
                end loop;
                plog.debug(pkgctx,'Check max quantity' || l_dblLongPosision );
                If l_dblMarginMaxQuantity < l_dblLongPosision + l_dblORDERQTTY Then
                    p_err_code := errnums.C_MR_OVER_SYS_LONG_POSSITION;
                    Return l_lngErrCode;
                End If;
            End If;*/
            --'Kiem tra chan min,max amount
            plog.debug(pkgctx,'Check min amount');
            select varvalue into l_strPreventMinOrder from sysvar where grname ='SYSTEM' and varname ='PREVENTORDERMIN';
            plog.debug(pkgctx,'Check min amount' || l_strPreventMinOrder);
            If l_strPreventMinOrder = 'Y' Then
                If (l_strEXECTYPE = 'NB' Or l_strEXECTYPE = 'BC') Then
                    l_dblCheckMinAmount := l_dblBuyMinAmount;
                Else
                    l_dblCheckMinAmount := l_dblSellMinAmount;
                End If;
                If l_dblQUOTEPRICE * l_dblORDERQTTY * l_dblTradeUnit < l_dblCheckMinAmount Then
                    p_err_code := errnums.C_OD_ORDER_UNDER_MIN_AMOUNT;
                    Return l_lngErrCode;
                End If;
            End If;
            If l_dblTradeUnit > 0 Then
                l_dblQUOTEPRICE := Round(l_dblQUOTEPRICE * l_dblTradeUnit, 6);
            End If;
            --Kiem tra lenh mua nha dau tu nuoc ngoai co con ROOM
            plog.debug(pkgctx,'Check room custodycode:' || l_strCUSTODYCD);
            If l_strEXECTYPE = 'NB' And (substr(l_strCUSTODYCD, 4, 1) = 'F' Or substr(l_strCUSTODYCD, 4, 1) = 'E') Then
                If l_dblORDERQTTY > l_dblRoom Then
                   p_err_code := errnums.C_OD_ROOM_NOT_ENOUGH;
                   Return l_lngErrCode;
               End If;
                null;
            End If;
            --Kiem tra khoi luong co chia het cho trdelot hay khong
            plog.debug(pkgctx,'Check tradelot:' || l_dblORDERQTTY);
            If l_dblTradeLot > 0 And l_strMATCHTYPE <> 'P' Then
                If l_dblORDERQTTY Mod l_dblTradeLot <> 0 Then
                    p_err_code := errnums.C_OD_QTTY_TRADELOT_INCORRECT;
                    Return l_lngErrCode;
                End If;
            End If;
            --Kiem tra voi lenh LO thi gia phai nam trong khoang tran san
            plog.debug(pkgctx,'Check floor ceiling:' || l_dblQUOTEPRICE || ' floor:' || l_dblFloorPrice || ' Ceil:' || l_dblCeilingPrice);
            --If l_strPRICETYPE = 'LO' Then --HNX_update|iss 1785
                If l_dblQUOTEPRICE < l_dblFloorPrice Or l_dblQUOTEPRICE > l_dblCeilingPrice Then
                    p_err_code := errnums.C_OD_LO_PRICE_ISNOT_FLOOR_CEIL;
                    Return l_lngErrCode;
                End If;
            --End If;--HNX_update|iss 1785
            --Voi lenh LO, stop limit thi kiem tra tick size cua gia
            plog.debug(pkgctx,'Check ticksize:' || l_dblQUOTEPRICE);
            If l_strPRICETYPE = 'LO' Or l_strPRICETYPE = 'SL' Then
                SELECT count(1) into l_count FROM SECURITIES_TICKSIZE WHERE CODEID=l_strCODEID  AND STATUS='Y'
                       AND TOPRICE>= l_dblQUOTEPRICE AND FROMPRICE<=l_dblQUOTEPRICE;

                if l_count<=0 then
                    --Chua dinh nghia TICKSIZE
                    p_err_code := errnums.C_OD_TICKSIZE_UNDEFINED;
                    Return l_lngErrCode;
                else
                    SELECT FROMPRICE, TICKSIZE into l_dblFromPrice,l_dblTickSize
                    FROM SECURITIES_TICKSIZE WHERE CODEID=l_strCODEID  AND STATUS='Y'
                       AND TOPRICE>= l_dblQUOTEPRICE AND FROMPRICE<=l_dblQUOTEPRICE;
                    If (l_dblQUOTEPRICE - l_dblFromPrice) Mod l_dblTickSize <> 0 And l_strMATCHTYPE <> 'P' Then
                        p_err_code := errnums.C_OD_TICKSIZE_INCOMPLIANT;
                        Return l_lngErrCode;
                    End If;
                end if;
            End If;
            /*--Kiem tra chung khoan khong duoc vua mua vua ban trong ngay
            plog.debug(pkgctx,'Check trade buy/sell:' || l_strTRADEBUYSELL);
            If l_strTRADEBUYSELL = 'N' Then
                If l_strEXECTYPE = 'NB' Or l_strEXECTYPE = 'BC' Then
                    SELECT COUNT(*)  into l_count FROM ODMAST WHERE CODEID= l_strCODEID  AND AFACCTNO IN (SELECT ACCTNO FROM AFMAST WHERE CUSTID=(SELECT CUSTID FROM AFMAST WHERE ACCTNO= l_strAFACCTNO ))
                    AND (EXECTYPE='NS' OR EXECTYPE='SS' OR EXECTYPE='MS') AND DELTD = 'N' AND EXPDATE >= TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT) AND REMAINQTTY+EXECQTTY>0;
                Else
                    SELECT COUNT(*) into l_count FROM ODMAST WHERE CODEID= l_strCODEID  AND AFACCTNO IN (SELECT ACCTNO FROM AFMAST WHERE CUSTID=(SELECT CUSTID FROM AFMAST WHERE ACCTNO= l_strAFACCTNO ))
                    AND (EXECTYPE='NB' OR EXECTYPE='BC') AND DELTD = 'N' AND EXPDATE >= TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT)  AND REMAINQTTY+EXECQTTY>0;
                End If;
                If l_count > 0 Then
                    --Bao loi khong duoc mua ban mot chung khoan trong cuang 1 ngay
                    p_err_code := errnums.C_OD_BUYSELL_SAME_SECURITIES;
                    Return l_lngErrCode;
                End If;
            End If;*/

             --Kiem tra chung khoan khong duoc vua mua vua ban trong ngay
             -- quyet.kieu : Ghep them phan mua ban chung khoan cung phien theo thong tu 74

--Rao lai cho TT203
/*
          Select VARVALUE Into v_strORDERTRADEBUYSELL from sysvar where GRNAME ='SYSTEM' and VARNAME ='ORDERTRADEBUYSELL' ;

          If v_strORDERTRADEBUYSELL = 'N'  Then
               -- quyet.kieu : khong duoc phep dat lenh cho ( check tat ca cac loai lenh )
               -- kiem tra tat ca cac loai lenh( LO, ATO , ATC ) neu co lenh nguoc chieu chua khop thi khong cho dat lenh

                If l_strEXECTYPE = 'NB' Or l_strEXECTYPE = 'BC' Then
                    SELECT COUNT(*)  into l_count FROM ODMAST WHERE CODEID= l_strCODEID  AND AFACCTNO IN (SELECT ACCTNO FROM AFMAST WHERE CUSTID=(SELECT CUSTID FROM AFMAST WHERE ACCTNO= l_strAFACCTNO ))
                    AND (EXECTYPE='NS' OR EXECTYPE='SS' OR EXECTYPE='MS') AND DELTD = 'N' AND EXPDATE >= TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT) AND REMAINQTTY >0;
                Else
                    SELECT COUNT(*) into l_count FROM ODMAST WHERE CODEID= l_strCODEID  AND AFACCTNO IN (SELECT ACCTNO FROM AFMAST WHERE CUSTID=(SELECT CUSTID FROM AFMAST WHERE ACCTNO= l_strAFACCTNO ))
                    AND (EXECTYPE='NB' OR EXECTYPE='BC') AND DELTD = 'N' AND EXPDATE >= TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT)  AND REMAINQTTY >0;
                End If;

                If l_count > 0 Then
                   -- Khong cho phep dat lenh cho khi dang co lenh doi ung chua khop
                    p_err_code :=errnums.C_OD_ORTHER_ORDER_WAITING;
                    Return l_lngErrCode;
                End If;

         End if ;

            If l_strTRADEBUYSELL = 'N' Then
                If l_strEXECTYPE = 'NB' Or l_strEXECTYPE = 'BC' Then
                    SELECT COUNT(*)  into l_count FROM ODMAST WHERE CODEID= l_strCODEID  AND AFACCTNO IN (SELECT ACCTNO FROM AFMAST WHERE CUSTID=(SELECT CUSTID FROM AFMAST WHERE ACCTNO= l_strAFACCTNO ))
                    AND (EXECTYPE='NS' OR EXECTYPE='SS' OR EXECTYPE='MS') AND DELTD = 'N' AND EXPDATE >= TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT) AND REMAINQTTY+EXECQTTY>0;
                Else
                    SELECT COUNT(*) into l_count FROM ODMAST WHERE CODEID= l_strCODEID  AND AFACCTNO IN (SELECT ACCTNO FROM AFMAST WHERE CUSTID=(SELECT CUSTID FROM AFMAST WHERE ACCTNO= l_strAFACCTNO ))
                    AND (EXECTYPE='NB' OR EXECTYPE='BC') AND DELTD = 'N' AND EXPDATE >= TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT)  AND REMAINQTTY+EXECQTTY>0;
                End If;
                If l_count > 0 Then
                    --Bao loi khong duoc mua ban mot chung khoan trong cuang 1 ngay
                    p_err_code :=errnums.C_OD_BUYSELL_SAME_SECURITIES;
                    Return l_lngErrCode;
                End If;

            Elsif l_strTRADEBUYSELL = 'Y' And l_strTRADEPLACE = errnums.gc_TRADEPLACE_HCMCSTC Then

                 Begin
                   Select VARVALUE into v_strSysCheckBuySell from sysvar where GRNAME ='SYSTEM' and VARNAME ='TRADEBUYSELL';
                 Exception When OTHERS Then
                   v_strSysCheckBuySell:='N';
                 End;

                 If v_strSysCheckBuySell ='N' Then

                                      --Lay thong tin phien
                                      Select sysvalue into l_strControlCode  from ordersys where sysname ='CONTROLCODE';

                                      --Neu dat LO thi check d?? ATC doi ung o phien 2 va LO, ATC doi ung o phien 3.
                                      --Neu dat ATO thi check LO, ATO d?i ?ng.
                                      --?t ATC th?heck ch?n ATC, LO d?i ?ng
                                      If l_strPRICETYPE IN ('LO') And l_strMATCHTYPE <> 'P'   Then

                                            If l_strControlCode ='O' Then
                                                v_strTemp:='ATC';
                                            Elsif l_strControlCode ='A' Then
                                                v_strTemp:='LO,ATC';
                                            End if;

                                      ELSIF l_strPRICETYPE IN ('LO') And l_strMATCHTYPE = 'P'   Then --Lenh thoa thuan thi chan tat ca lenh doi ung.

                                            v_strTemp:='LO,ATO,ATC';

                                      Elsif l_strPRICETYPE IN ('ATO') Then
                                            v_strTemp:='LO,ATO';
                                      Elsif l_strPRICETYPE IN ('ATC') Then
                                            v_strTemp:='LO,ATC';
                                      End if;

                                    If l_strEXECTYPE = 'NB' Or l_strEXECTYPE = 'BC' Then

                                         SELECT COUNT(*)  into l_count FROM ODMAST WHERE CODEID= l_strCODEID
                                         AND AFACCTNO IN (SELECT ACCTNO FROM AFMAST WHERE CUSTID=(SELECT CUSTID FROM AFMAST WHERE ACCTNO= l_strAFACCTNO ))
                                         AND INSTR(v_strTemp,PRICETYPE)>0
                                         AND (EXECTYPE='NS' OR EXECTYPE='SS' OR EXECTYPE='MS') AND DELTD = 'N'
                                         AND EXPDATE >= TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT) AND REMAINQTTY>0;
                                     Else
                                         SELECT COUNT(*) into l_count FROM ODMAST WHERE CODEID= l_strCODEID
                                         AND AFACCTNO IN (SELECT ACCTNO FROM AFMAST WHERE CUSTID=(SELECT CUSTID FROM AFMAST WHERE ACCTNO= l_strAFACCTNO ))
                                         AND INSTR(v_strTemp,PRICETYPE)>0
                                         AND (EXECTYPE='NB' OR EXECTYPE='BC') AND DELTD = 'N'
                                         AND EXPDATE >= TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT)  AND REMAINQTTY >0;
                                     End If;
                                     plog.debug(pkgctx,'v_strTemp: ' || v_strTemp);
                                     If l_count > 0 Then
                                         --Bao loi khong duoc mua ban mot chung khoan trong cuang 1 ngay
                                         p_err_code :=errnums.C_OD_BUYSELL_SAME_SECURITIES;
                                         Return l_lngErrCode;
                                     End If;
            End if; --Sysbuysell
        Elsif l_strTRADEBUYSELL = 'Y' And l_strTRADEPLACE = errnums.gc_TRADEPLACE_HNCSTC Then
        --Neu san HNX thi chi check thoan thuan
          Begin
             Select VARVALUE into v_strSysCheckBuySell from sysvar where GRNAME ='SYSTEM' and VARNAME ='TRADEBUYSELL';
           Exception When OTHERS Then
             v_strSysCheckBuySell:='N';
           End;

           If v_strSysCheckBuySell ='N' And l_strMATCHTYPE = 'P'   Then
               v_strTemp:='LO,ATO,ATC';
           End if;
           If l_strEXECTYPE = 'NB' Or l_strEXECTYPE = 'BC' Then

                 SELECT COUNT(*)  into l_count FROM ODMAST WHERE CODEID= l_strCODEID
                     AND AFACCTNO IN (SELECT ACCTNO FROM AFMAST WHERE CUSTID=(SELECT CUSTID FROM AFMAST WHERE ACCTNO= l_strAFACCTNO ))
                     AND INSTR(v_strTemp,PRICETYPE)>0
                     AND (EXECTYPE='NS' OR EXECTYPE='SS' OR EXECTYPE='MS') AND DELTD = 'N'
                     AND EXPDATE >= TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT) AND REMAINQTTY>0;
                 Else
                     SELECT COUNT(*) into l_count FROM ODMAST WHERE CODEID= l_strCODEID
                     AND AFACCTNO IN (SELECT ACCTNO FROM AFMAST WHERE CUSTID=(SELECT CUSTID FROM AFMAST WHERE ACCTNO= l_strAFACCTNO ))
                     AND INSTR(v_strTemp,PRICETYPE)>0
                     AND (EXECTYPE='NB' OR EXECTYPE='BC') AND DELTD = 'N'
                     AND EXPDATE >= TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT)  AND REMAINQTTY >0;
                 End If;
                 plog.debug(pkgctx,'v_strTemp: ' || v_strTemp);
                 If l_count > 0 Then
                     --Bao loi khong duoc mua ban mot chung khoan trong cuang 1 ngay
                     p_err_code :=errnums.C_OD_BUYSELL_SAME_SECURITIES;
                     Return l_lngErrCode;
                 End If;
        End if;
      -- End kiem tra chung khoan khong duoc vua mua vua ban trong ngay
*/

--Them check mua ban theo TT 203


-- Bat dau kiem tra lenh doi ung

    IF NOT fnc_pass_tradebuysell(l_strAFACCTNO,p_txmsg.txdate,l_strCODEID,l_strEXECTYPE,l_strPRICETYPE,l_strMATCHTYPE,l_strTRADEPLACE,l_strSYMBOL) THEN
    -- Khong cho phep dat lenh cho khi dang co lenh doi ung chua khop
        p_err_code :=errnums.C_OD_ORTHER_ORDER_WAITING;
        plog.setendsection (pkgctx, 'fn_txAftAppCheck');
        Return l_lngErrCode;
    END IF;

-- Ket thuc chan lenh doi ung


        EXCEPTION
        WHEN no_data_found THEN
            plog.debug(pkgctx,'l_lngErrCode: ' || errnums.C_OD_SECURITIES_INFO_UNDEFINED);
            p_err_code := errnums.C_OD_SECURITIES_INFO_UNDEFINED;
            Return l_lngErrCode;
        end;

       /* plog.debug(pkgctx,'l_strOVRRQD1: ' || l_strOVRRQD);
        --Kiem tra vuot han muc yeu cau checker duyet
        If l_dblQUOTEPRICE * l_dblORDERQTTY > l_dblODTYPETRADELIMIT Then
            l_strOVRRQD := l_strOVRRQD || errnums.OVRRQS_ORDERTRADELIMIT;
            p_txmsg.ovrrqd := l_strOVRRQD;
        End If;*/

        plog.debug(pkgctx,'l_strOVRRQD2: ' || l_strOVRRQD);
        If l_dblBRATIO < l_dblALLOWBRATIO Then
            l_strOVRRQD := l_strOVRRQD || errnums.OVRRQS_ORDERSECURERATIO;
            p_txmsg.ovrrqd := l_strOVRRQD;
        End If;
        /*
        plog.debug(pkgctx,'l_strOVRRQD3: ' || l_strOVRRQD);
        --Neu vuot qua han muc giao dich cua HD
        SELECT SUM(QUOTEPRICE*ORDERQTTY) AMT into l_count FROM ODMAST WHERE AFACCTNO=l_strAFACCTNO;
        If l_dblQUOTEPRICE * l_dblORDERQTTY + l_count > l_dblAFTRADELIMIT Then
            l_strOVRRQD := l_strOVRRQD || errnums.OVRRQS_AFTRADELIMIT;
            p_txmsg.ovrrqd := l_strOVRRQD;
        End If;
        */
        --Kiem tra neu gia tri ung truoc vuot qua han muc ung truoc trong hop dong thi yeu cau checker duyet
        /*If (l_strEXECTYPE = 'NB' Or l_strEXECTYPE = 'BC') And l_strMarginType = 'N' Then
            SELECT SUM(QUOTEPRICE*REMAINQTTY*(1+TYP.DEFFEERATE/100)+EXECAMT) ODAMT into l_count
            FROM ODMAST OD, ODTYPE TYP
            WHERE OD.ACTYPE=TYP.ACTYPE
            AND  OD.AFACCTNO= l_strAFACCTNO
            AND OD.TXDATE= TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT)
            AND DELTD <>'Y' AND OD.EXECTYPE IN ('NB','BC') ;
            if l_dblQUOTEPRICE * l_dblORDERQTTY + l_count > l_dblAFADVANCELIMIT + l_dblODBALANCE Then
                p_err_code := errnums.C_OD_ADVANCELINE_OVER_LIMIT;
                Return l_lngErrCode;
            End If;
        End If;*/
        plog.debug(pkgctx,'l_strOVRRQD4: ' || l_strOVRRQD);
        If length(Trim(Replace(l_strOVRRQD, errnums.OVRRQS_CHECKER_CONTROL, ''))) > 0 And (length(p_txmsg.chkid) = 0 or p_txmsg.chkid is null) Then
            p_err_code :=errnums.C_CHECKER1_REQUIRED;
        Else
            If InStr(l_strOVRRQD, errnums.OVRRQS_CHECKER_CONTROL) > 0 And (Length(p_txmsg.offid)  = 0 or p_txmsg.offid is null) Then
                p_err_code :=errnums.C_CHECKER2_REQUIRED;
            End If;
        End If;
    end if;
    if p_err_code =errnums.C_CHECKER1_REQUIRED or p_err_code =errnums.C_CHECKER2_REQUIRED then
        FOR I IN (
           SELECT ERRDESC,EN_ERRDESC FROM deferror
           WHERE ERRNUM= p_err_code
        ) LOOP
           l_err_param := i.errdesc;
        END LOOP;
        p_txmsg.txException('ERRSOURCE').value := '';
        p_txmsg.txException('ERRSOURCE').TYPE := 'System.String';
        p_txmsg.txException('ERRCODE').value := p_err_code;
        p_txmsg.txException('ERRCODE').TYPE := 'System.Int64';
        p_txmsg.txException('ERRMSG').value := l_err_param;
        p_txmsg.txException('ERRMSG').TYPE := 'System.String';

    end if;
    ---------------------------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------------------------
   plog.debug (pkgctx, '<<END OF fn_txAftAppCheck>>');
   plog.setendsection (pkgctx, 'fn_txAftAppCheck');
   RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'fn_txAftAppCheck');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAftAppCheck;

FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txPreAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txPreAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC PROCESS HERE. . DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    plog.debug (pkgctx, '<<END OF fn_txPreAppUpdate');
    plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
       plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txPreAppUpdate;

FUNCTION fn_txAftAppUpdate(p_txmsg in  tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    l_return_code number(20,0);
    l_count number(20,0);
    l_strCUSTID varchar2(30);
    l_strCODEID varchar2(30);
    l_strACTYPE varchar2(30);
    l_strAFACCTNO varchar2(30);
    l_strCIACCTNO varchar2(30);
    l_strAFSTATUS varchar2(30);
    l_strSEACCTNO varchar2(30);
    l_strCUSTODYCD varchar2(30);
    l_strTIMETYPE varchar2(30);
    l_strVOUCHER varchar2(30);
    l_strCONSULTANT varchar2(30);
    l_strORDERID varchar2(30);
    l_strBORS varchar2(30);
    l_strContrafirm varchar2(30);
    l_strContrafirm2 varchar2(30);
    l_strContraCus varchar2(30);
    l_strPutType varchar2(30);
    l_strEXPDATE varchar2(30);
    l_strEXECTYPE varchar2(30);
    l_strNORK varchar2(30);
    l_strMATCHTYPE varchar2(30);
    l_strVIA varchar2(30);
    l_strCLEARCD varchar2(30);
    l_strPRICETYPE varchar2(30);
    l_strDESC varchar2(300);
    l_strTRADEPLACE varchar2(30);
    l_strSYMBOL varchar2(30);
    l_strMarginType varchar2(30);
    l_strBUYIFOVERDUE varchar2(30);
    l_strAFTYPE varchar2(30);
    l_dblCLEARDAY number(30,4);
    l_dblQUOTEPRICE number(30,9); --Sua lai de nhap 6 so sau dau phay
    l_dblORDERQTTY number(30,4);
    l_dblBRATIO number(30,4);
    l_dblLIMITPRICE number(30,4);
    l_dblAFADVANCELIMIT number(30,4);
    l_dblODBALANCE  number(30,4);
    l_dblODTYPETRADELIMIT number(30,4);
    l_dblAFTRADELIMIT number(30,4);
    l_dblALLOWBRATIO number(30,4);
    l_dblDEFFEERATE number(30,4);
    l_dblMarginRate  number(30,4);
    l_dblSecuredRatioMin number(30,4);
    l_dblSecuredRatioMax number(30,4);
    l_dblTyp_Bratio number(30,4);
    l_dblAF_Bratio number(30,4);
    ml_dblSecureRatio number(30,4);
    l_dblRoom number(30,4);
    l_dblTraderID  number(30,4);
    l_blnReversal boolean;
    l_strHalt char(1);
    l_strCompanyFirm varchar2(50);
    l_dblTradeLot number(30,4);
    l_dblTradeUnit number(30,4);
    l_dblFloorPrice number(30,4);
    l_dblCeilingPrice number(30,4);
    l_dblTickSize number(30,4);
    l_dblFromPrice number(30,4);
    l_dblMarginMaxQuantity  number(30,4);
    l_dblBfAccoutMarginRate number(30,4);
    l_dblAfAccoutMarginRate number(30,4);
    l_dblLongPosision number(30,4);
    l_dblBuyMinAmount number(30,4);
    l_dblSellMinAmount number(30,4);
    l_dblCheckMinAmount number(30,4);
    l_strPreventMinOrder varchar2(30);
    l_strTRADEBUYSELL  varchar2(30);
    l_strOVRRQD varchar2(100);
    l_strFEEDBACKMSG varchar2(1000);
    l_strBRID varchar2(30);
    l_strTXDATE varchar2(30);
    l_strTXNUM varchar2(30);
    l_strTXTIME varchar2(30);
    l_strTXDESC varchar2(300);
    l_strCHKID varchar2(30);
    l_strOFFID varchar2(30);
    l_strDELTD varchar2(30);
    l_strEFFDATE varchar2(30);
    l_strMember varchar2(200);
    l_strFOACCTNO varchar2(200);
    l_strTraderid varchar2(30);
    l_strClientID varchar2(30);
    l_strOutPriceAllow varchar2(30);
    --</ TruongLD Add
    l_strTLID VARCHAR2(30);
    --/>
    l_strSSAFACCTNO varchar2(10);
    Pl_REFCURSOR   PKG_REPORT.REF_CURSOR;
    --<QuyetKD add update HNX
     l_dblQuoteQtty number(30,4);
     l_strPtDeal varchar2(20);
    --/>
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    ---------------------------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------------------------
    --</ TruongLD Add
    l_strTLID := p_txmsg.tlid;
    --/>
    l_strBRID :=p_txmsg.BRID;
    l_strTXDATE :=p_txmsg.TXDATE;
    l_strTXNUM :=p_txmsg.TXNUM;
    l_strTXTIME :=p_txmsg.TXTIME;
    l_strTXDESC :=p_txmsg.TXDESC;
    l_strOVRRQD :=p_txmsg.OVRRQd;
    l_strCHKID:= p_txmsg.CHKID;
    l_strOFFID:= p_txmsg.OFFID;
    l_strDELTD :=p_txmsg.DELTD;
    l_return_code:=errnums.C_BIZ_RULE_INVALID;
    p_err_code:=0;
    if p_txmsg.deltd='Y' then
        l_blnReversal:=true;
    else
        l_blnReversal:=false;
    end if;
    l_strCODEID := p_txmsg.txfields('01').value;
    l_strACTYPE := p_txmsg.txfields('02').value;
    l_strAFACCTNO := p_txmsg.txfields('03').value;
    plog.debug (pkgctx, 'l_strAFACCTNO' || l_strAFACCTNO);
    l_strTIMETYPE := p_txmsg.txfields('20').value;
    l_strEFFDATE:= p_txmsg.txfields('19').value;
    l_strEXPDATE := p_txmsg.txfields('21').value;
    l_strEXECTYPE := p_txmsg.txfields('22').value;
    l_strNORK := p_txmsg.txfields('23').value;
    plog.debug (pkgctx, 'l_strNORK' || l_strNORK);
    l_strMATCHTYPE := p_txmsg.txfields('24').value;
    l_strVIA := p_txmsg.txfields('25').value;
    l_strCLEARCD := p_txmsg.txfields('26').value;
    l_strPRICETYPE := p_txmsg.txfields('27').value;
    l_dblCLEARDAY := p_txmsg.txfields('10').value;
    plog.debug (pkgctx, 'l_dblCLEARDAY' || l_dblCLEARDAY);
    l_dblQUOTEPRICE := p_txmsg.txfields('11').value;
    l_dblORDERQTTY := p_txmsg.txfields('12').value;
    l_dblBRATIO := p_txmsg.txfields('13').value;
    l_dblLIMITPRICE := p_txmsg.txfields('14').value;
    l_strVOUCHER := p_txmsg.txfields('28').value;
    plog.debug (pkgctx, 'l_strCONSULTANT' || l_strCONSULTANT);
    l_strCONSULTANT := p_txmsg.txfields('29').value;
    l_strORDERID := p_txmsg.txfields('04').value;
    l_strDESC := p_txmsg.txfields('30').value;
    l_strMember:= p_txmsg.txfields('50').value;
    l_strContrafirm := '';
    l_strTraderid := '';
    l_strClientID := '';
    l_strOutPriceAllow := p_txmsg.txfields('34').value;
    l_strContraCus := replace(p_txmsg.txfields('71').value,'.','');
    l_strPutType := replace(p_txmsg.txfields('72').value,'.','');
    l_strContrafirm2 := replace(p_txmsg.txfields('73').value,'.','');

    l_dblQuoteQtty:= p_txmsg.txfields('80').value;


    If l_strMATCHTYPE ='P' then
        l_strPtDeal:= p_txmsg.txfields('81').value;
        else
        l_strPtDeal:=null;
    end if;

    begin
        l_strSSAFACCTNO:=p_txmsg.txfields('94').value;
    exception when others then
        l_strSSAFACCTNO:='';
    end;

    plog.debug (pkgctx, 'l_strORDERID' || l_strORDERID);
    If l_strTIMETYPE = 'G' And substr(l_strORDERID,1, 2) <> errnums.C_FO_PREFIXED Then
        --Neu la lenh Good till cancel, ma la lenh dat
        If l_blnReversal Then
            SELECT count(1) into l_count FROM FOMAST WHERE ACCTNO =l_strORDERID  AND STATUS <> 'P';
            If l_count > 0 Then
                --Khong the xoa lenh nay
                p_err_code := errnums.C_ERRCODE_FO_INVALID_STATUS;
                Return l_return_code;
            End If;
            --Xoa giao dich
            DELETE FROM FOMAST WHERE ACCTNO =l_strORDERID ;
        Else
            --Day lenh vao FOMAST
            --Lay ra ma chung khoan
            l_strSYMBOL:='';
            SELECT SYMBOL into l_strSYMBOL
            FROM SBSECURITIES WHERE CODEID =l_strCODEID ;

            l_strFEEDBACKMSG := l_strDESC;
            INSERT INTO FOMAST (ACCTNO, ORGACCTNO, ACTYPE, AFACCTNO, STATUS, EXECTYPE, PRICETYPE, TIMETYPE,
                MATCHTYPE, NORK, CLEARCD, CODEID, SYMBOL,
                CONFIRMEDVIA, BOOK, FEEDBACKMSG, ACTIVATEDT, CREATEDDT, CLEARDAY, QUANTITY, PRICE, QUOTEPRICE,
                TRIGGERPRICE, EXECQTTY, EXECAMT, REMAINQTTY,EFFDATE,EXPDATE,BRATIO,VIA,OUTPRICEALLOW,TXNUM,TXDATE, QUOTEQTTY,LIMITPRICE)
                VALUES ( l_strORDERID , l_strORDERID, l_strACTYPE, l_strAFACCTNO,'P',
                 l_strEXECTYPE, l_strPRICETYPE, l_strTIMETYPE, l_strMATCHTYPE,
                 l_strNORK, l_strCLEARCD, l_strCODEID, l_strSYMBOL,
                'N','A', l_strFEEDBACKMSG,TO_CHAR(SYSDATE,'DD/MM/RRRR HH:MM:SS'),TO_CHAR(SYSDATE,'DD/MM/RRRR HH:MM:SS'),
                 l_dblCLEARDAY , l_dblORDERQTTY , l_dblLIMITPRICE , l_dblQUOTEPRICE , 0 , 0 , 0 ,
                 l_dblORDERQTTY ,TO_DATE( l_strEFFDATE ,  systemnums.C_DATE_FORMAT ),TO_DATE( l_strEXPDATE , systemnums.C_DATE_FORMAT),
                 l_dblBRATIO , l_strVIA , l_strOutPriceAllow , p_txmsg.txnum ,
                 TO_DATE( p_txmsg.txdate,  systemnums.C_DATE_FORMAT ),l_dblQuoteQtty,l_dblLIMITPRICE);
        End If;
        Return systemnums.C_SUCCESS;
    End If;
    --Lenh today hoac Intemediate or cancel
    --Hoac lenh GTC tu dong day vao he thong
    if l_blnReversal then
        plog.debug (pkgctx, 'l_strORDERID2' || l_strORDERID);
        SELECT COUNT(1) into l_count FROM ODMAST WHERE REFORDERID =l_strORDERID ;
        If l_count > 0 Then
            --khogn the xoa lenh nay
            p_err_code := errnums.C_OD_ODMAST_CANNOT_DELETE;
            Return l_return_code;
        End If;
        --Kiem tra lenh co dc xoa hay khong
        plog.debug (pkgctx, 'txnum,txdate: ' || p_txmsg.txnum || p_txmsg.txdate);
        SELECT COUNT(1) into l_count FROM ODMAST
        WHERE TXNUM=p_txmsg.txnum  AND TXDATE=TO_DATE( p_txmsg.txdate , systemnums.C_DATE_FORMAT)
        AND ORSTATUS IN ('1','2','8');
        plog.debug (pkgctx, 'l_count: ' || l_count);
        If l_count <= 0 Then
            --Khong dc xoa lenh nay
            plog.debug (pkgctx, '11');
            p_err_code := errnums.C_OD_ODMAST_CANNOT_DELETE;
            plog.debug (pkgctx, '12 ' || l_return_code);
            Return l_return_code;
        End If;
        --Xoa giao dich
        plog.debug (pkgctx, 'p_txmsg.txnum.txdate2' || p_txmsg.txnum || p_txmsg.txdate);
        UPDATE ODMAST SET DELTD='Y' WHERE TXNUM=p_txmsg.txnum  AND TXDATE=TO_DATE( p_txmsg.txdate , systemnums.C_DATE_FORMAT);
        UPDATE OOD SET DELTD='Y' WHERE TXNUM=p_txmsg.txnum  AND TXDATE=TO_DATE( p_txmsg.txdate , systemnums.C_DATE_FORMAT);
    else
        --Make giao dich
        l_dblALLOWBRATIO := 1;
        SELECT TRADELIMIT,BRATIO into l_dblODTYPETRADELIMIT,l_dblTyp_Bratio  FROM ODTYPE WHERE STATUS='Y' AND ACTYPE=l_strACTYPE ;
        l_dblALLOWBRATIO:=l_dblTyp_Bratio/100;
        SELECT CIACCTNO,CUSTID,STATUS,TRADELINE,ADVANCELINE,BRATIO
        into l_strCIACCTNO,l_strCUSTID,l_strAFSTATUS,l_dblAFTRADELIMIT,l_dblAFADVANCELIMIT,l_dblAF_Bratio
        FROM AFMAST WHERE ACCTNO=l_strAFACCTNO;
        l_strSEACCTNO := l_strAFACCTNO || l_strCODEID;
        l_dblALLOWBRATIO:=l_dblAF_Bratio/100;
        SELECT CUSTODYCD into l_strCUSTODYCD FROM CFMAST WHERE CUSTID= l_strCUSTID;
        SELECT TRADELOT,TRADEUNIT,FLOORPRICE,CEILINGPRICE,SECURERATIOMAX,SECURERATIOTMIN,CURRENT_ROOM,SYMBOL
        into l_dblTradeLot,l_dblTradeUnit,l_dblFloorPrice,l_dblCeilingPrice,l_dblSecuredRatioMax,l_dblSecuredRatioMin,l_dblRoom,l_strSYMBOL
        FROM SECURITIES_INFO WHERE CODEID=l_strCODEID;
        If l_dblTradeUnit > 0 Then
            l_dblQUOTEPRICE := Round(l_dblQUOTEPRICE * l_dblTradeUnit,6);
            l_dblLIMITPRICE := Round(l_dblLIMITPRICE * l_dblTradeUnit,6);
        End If;
        If Length(l_strMember) > 0 Then
            l_strCUSTID := l_strMember;
        End If;
        SELECT TO_CHAR(SYSDATE,'HH24:MI:SS') into l_strTXTIME FROM DUAL;
        if l_strTIMETYPE <> 'G' then
            l_strMember:='';
        ELSE --lENH gtc
            BEGIN
                SELECT FOACCTNO INTO l_strMember FROM rootordermap WHERE ORDERID=l_strORDERID;
            EXCEPTION WHEN OTHERS THEN
                l_strMember:= l_strMember;
            END;
        end if;
        -- GET FOACCTNO
        BEGIN
            SELECT FOACCTNO INTO l_strFOACCTNO FROM rootordermap WHERE ORDERID=l_strORDERID;
        EXCEPTION WHEN OTHERS THEN
                l_strFOACCTNO:= '';
        END;

        if p_txmsg.tltxcd='8870' then
        INSERT INTO ODMAST (ORDERID,CUSTID,ACTYPE,CODEID,AFACCTNO,SEACCTNO,CIACCTNO,
                                         TXNUM,TXDATE,TXTIME,EXPDATE,BRATIO,TIMETYPE,
                                         EXECTYPE,NORK,MATCHTYPE,VIA,CLEARDAY,CLEARCD,ORSTATUS,PORSTATUS,PRICETYPE,
                                         QUOTEPRICE,STOPPRICE,LIMITPRICE,ORDERQTTY,REMAINQTTY,
                                         EXECQTTY,STANDQTTY,CANCELQTTY,ADJUSTQTTY,REJECTQTTY,REJECTCD,VOUCHER,
                                         CONSULTANT,CONTRAFIRM, TRADERID,CLIENTID,PUTTYPE,CONTRAORDERID,CONTRAFRM, TLID,QUOTEQTTY,PTDEAL)
                         VALUES ( l_strORDERID , l_strCUSTID , l_strACTYPE , l_strCODEID , l_strAFACCTNO , l_strSEACCTNO , l_strCIACCTNO
                                         , p_txmsg.txnum ,TO_DATE( p_txmsg.txdate ,  systemnums.C_DATE_FORMAT ), l_strTXTIME
                                         ,TO_DATE( l_strEXPDATE ,  systemnums.C_DATE_FORMAT ), l_dblBRATIO , l_strTIMETYPE
                                         , l_strEXECTYPE , l_strNORK , l_strMATCHTYPE , l_strVIA , l_dblCLEARDAY , l_strCLEARCD ,'1','1', l_strPRICETYPE
                                         , l_dblQUOTEPRICE ,0, l_dblLIMITPRICE , l_dblORDERQTTY ,0,0,0,0,0,0,'001', l_strVOUCHER
                                         , l_strCONSULTANT , l_strContrafirm , l_strTraderid , l_strClientID , l_strPutType , l_strContraCus , l_strContrafirm2, l_strTLID,l_dblQuoteQtty,l_strPtDeal);
        elsif p_txmsg.tltxcd='8874' then
        --Ghi nhan vao so lenh
        --  quyet.kieu : Tam thoi chi sua trong 8874 da nhe
                        INSERT INTO ODMAST (ORDERID,CUSTID,ACTYPE,CODEID,AFACCTNO,SEACCTNO,CIACCTNO,
                                         TXNUM,TXDATE,TXTIME,EXPDATE,BRATIO,TIMETYPE,
                                         EXECTYPE,NORK,MATCHTYPE,VIA,CLEARDAY,CLEARCD,ORSTATUS,PORSTATUS,PRICETYPE,
                                         QUOTEPRICE,STOPPRICE,LIMITPRICE,ORDERQTTY,REMAINQTTY,EXPRICE,EXQTTY,SECUREDAMT,
                                         EXECQTTY,STANDQTTY,CANCELQTTY,ADJUSTQTTY,REJECTQTTY,REJECTCD,VOUCHER,CONSULTANT,FOACCTNO,PUTTYPE,CONTRAORDERID,CONTRAFRM, TLID,SSAFACCTNO,QUOTEQTTY,PTDEAL)
                         VALUES ( l_strORDERID , l_strCUSTID , l_strACTYPE , l_strCODEID , l_strAFACCTNO , l_strSEACCTNO , l_strCIACCTNO
                                         , p_txmsg.txnum ,TO_DATE( p_txmsg.txdate ,  systemnums.C_DATE_FORMAT ), l_strTXTIME
                                         ,TO_DATE( l_strEXPDATE ,  systemnums.C_DATE_FORMAT ), l_dblBRATIO , l_strTIMETYPE
                                         , l_strEXECTYPE , l_strNORK , l_strMATCHTYPE , l_strVIA
                                         , l_dblCLEARDAY , l_strCLEARCD ,'8','9', l_strPRICETYPE
                                         , l_dblQUOTEPRICE ,0, l_dblLIMITPRICE , l_dblORDERQTTY , l_dblORDERQTTY , l_dblQUOTEPRICE , l_dblORDERQTTY ,0,0,0,0,0,0,'001', l_strVOUCHER
                                         , l_strCONSULTANT , l_strFOACCTNO , l_strPutType , l_strContraCus , l_strContrafirm2, l_strTLID,l_strSSAFACCTNO ,l_dblQuoteQtty,l_strPtDeal);
                        --Ghi nhan vao OOD
                        INSERT INTO OOD (ORGORDERID,CODEID,SYMBOL,CUSTODYCD,
                                         BORS,NORP,AORN,PRICE,QTTY,SECUREDRATIO,OODSTATUS,TXDATE,TXNUM,DELTD,BRID)
                         VALUES ( l_strORDERID , l_strCODEID , l_strSYMBOL , l_strCUSTODYCD ,'B', l_strMATCHTYPE
                                         , l_strNORK , l_dblQUOTEPRICE , l_dblORDERQTTY , l_dblBRATIO ,'N',TO_DATE( p_txmsg.txdate ,  systemnums.C_DATE_FORMAT ), p_txmsg.txnum ,'N', l_strBRID );

        elsif p_txmsg.tltxcd='8875' then
                        INSERT INTO ODMAST (ORDERID,CUSTID,ACTYPE,CODEID,AFACCTNO,SEACCTNO,CIACCTNO,
                                         TXNUM,TXDATE,TXTIME,EXPDATE,BRATIO,TIMETYPE,
                                         EXECTYPE,NORK,MATCHTYPE,VIA,CLEARDAY,CLEARCD,ORSTATUS,PORSTATUS,PRICETYPE,
                                         QUOTEPRICE,STOPPRICE,LIMITPRICE,ORDERQTTY,REMAINQTTY,EXPRICE,EXQTTY,
                                         EXECQTTY,STANDQTTY,CANCELQTTY,ADJUSTQTTY,REJECTQTTY,REJECTCD,VOUCHER,CONSULTANT,FOACCTNO,PUTTYPE,CONTRAORDERID,CONTRAFRM, TLID,SSAFACCTNO)
                         VALUES ( l_strORDERID , l_strCUSTID , l_strACTYPE , l_strCODEID , l_strAFACCTNO , l_strSEACCTNO , l_strCIACCTNO
                                         , p_txmsg.txnum ,TO_DATE( p_txmsg.txdate ,  systemnums.C_DATE_FORMAT ), l_strTXTIME
                                         ,TO_DATE( l_strEXPDATE ,  systemnums.C_DATE_FORMAT ), l_dblBRATIO , l_strTIMETYPE
                                         , l_strEXECTYPE , l_strNORK , l_strMATCHTYPE , l_strVIA
                                         , l_dblCLEARDAY , l_strCLEARCD ,'8','9', l_strPRICETYPE
                                         , l_dblQUOTEPRICE ,0, l_dblLIMITPRICE , l_dblORDERQTTY , l_dblORDERQTTY , l_dblQUOTEPRICE , l_dblORDERQTTY ,0,0,0,0,0,'001', l_strVOUCHER , l_strCONSULTANT , l_strFOACCTNO , l_strPutType , l_strContraCus , l_strContrafirm2, l_strTLID,l_strSSAFACCTNO );

                        INSERT INTO OOD (ORGORDERID,CODEID,SYMBOL,CUSTODYCD,
                                       BORS,NORP,AORN,PRICE,QTTY,SECUREDRATIO,OODSTATUS,TXDATE,TXNUM,DELTD,BRID)
                        VALUES ( l_strORDERID , l_strCODEID , l_strSYMBOL , l_strCUSTODYCD ,'S', l_strMATCHTYPE
                                       , l_strNORK , l_dblQUOTEPRICE , l_dblORDERQTTY , l_dblBRATIO ,'N',TO_DATE( p_txmsg.txdate ,  systemnums.C_DATE_FORMAT ), p_txmsg.txnum ,'N', l_strBRID );
        elsif p_txmsg.tltxcd='8876' then
                        INSERT INTO ODMAST (ORDERID,CUSTID,ACTYPE,CODEID,AFACCTNO,SEACCTNO,CIACCTNO,
                                         TXNUM,TXDATE,TXTIME,EXPDATE,BRATIO,TIMETYPE,
                                         EXECTYPE,NORK,MATCHTYPE,VIA,CLEARDAY,CLEARCD,ORSTATUS,PORSTATUS,PRICETYPE,
                                         QUOTEPRICE,STOPPRICE,LIMITPRICE,ORDERQTTY,REMAINQTTY,EXPRICE,EXQTTY,SECUREDAMT,
                                         EXECQTTY,STANDQTTY,CANCELQTTY,ADJUSTQTTY,REJECTQTTY,REJECTCD,VOUCHER,CONSULTANT,CONTRAFIRM, TRADERID,CLIENTID,FOACCTNO,PUTTYPE,CONTRAORDERID,CONTRAFRM, TLID,SSAFACCTNO)
                         VALUES ( l_strORDERID , l_strCUSTID , l_strACTYPE , l_strCODEID , l_strAFACCTNO , l_strSEACCTNO , l_strCIACCTNO
                                         , p_txmsg.txnum ,TO_DATE( p_txmsg.txdate ,  systemnums.C_DATE_FORMAT ), l_strTXTIME
                                         ,TO_DATE( l_strEXPDATE ,  systemnums.C_DATE_FORMAT ), l_dblBRATIO , l_strTIMETYPE
                                         , l_strEXECTYPE , l_strNORK , l_strMATCHTYPE , l_strVIA
                                         , l_dblCLEARDAY , l_strCLEARCD ,'8','8', l_strPRICETYPE
                                         , l_dblQUOTEPRICE ,0, l_dblLIMITPRICE , l_dblORDERQTTY , l_dblORDERQTTY , l_dblQUOTEPRICE , l_dblORDERQTTY ,0,0,0,0,0,0,'001', l_strVOUCHER , l_strCONSULTANT , l_strContrafirm , l_strTraderid , l_strClientID , l_strFOACCTNO , l_strPutType , l_strContraCus , l_strContrafirm2, l_strTLID,l_strSSAFACCTNO );
                         INSERT INTO OOD (ORGORDERID,CODEID,SYMBOL,CUSTODYCD,
                                        BORS,NORP,AORN,PRICE,QTTY,SECUREDRATIO,OODSTATUS,TXDATE,TXNUM,DELTD,BRID)
                        VALUES ( l_strORDERID , l_strCODEID , l_strSYMBOL , l_strCUSTODYCD ,'B', l_strMATCHTYPE
                                        , l_strNORK , l_dblQUOTEPRICE , l_dblORDERQTTY , l_dblBRATIO ,'N',TO_DATE( p_txmsg.txdate ,  systemnums.C_DATE_FORMAT ), p_txmsg.txnum ,'N', l_strBRID );

        elsif p_txmsg.tltxcd='8877' then
                        INSERT INTO ODMAST (ORDERID,CUSTID,ACTYPE,CODEID,AFACCTNO,SEACCTNO,CIACCTNO,
                                         TXNUM,TXDATE,TXTIME,EXPDATE,BRATIO,TIMETYPE,
                                         EXECTYPE,NORK,MATCHTYPE,VIA,CLEARDAY,CLEARCD,ORSTATUS,PORSTATUS,PRICETYPE,
                                         QUOTEPRICE,STOPPRICE,LIMITPRICE,ORDERQTTY,REMAINQTTY,EXPRICE,EXQTTY,
                                         EXECQTTY,STANDQTTY,CANCELQTTY,ADJUSTQTTY,REJECTQTTY,REJECTCD,VOUCHER,CONSULTANT,CONTRAFIRM, TRADERID,CLIENTID,FOACCTNO,PUTTYPE,CONTRAORDERID,CONTRAFRM, TLID,SSAFACCTNO)
                         VALUES ( l_strORDERID , l_strCUSTID , l_strACTYPE , l_strCODEID , l_strAFACCTNO , l_strSEACCTNO , l_strCIACCTNO
                                         , p_txmsg.txnum ,TO_DATE( p_txmsg.txdate ,  systemnums.C_DATE_FORMAT ), l_strTXTIME
                                         ,TO_DATE( l_strEXPDATE ,  systemnums.C_DATE_FORMAT ), l_dblBRATIO , l_strTIMETYPE
                                         , l_strEXECTYPE , l_strNORK , l_strMATCHTYPE , l_strVIA
                                         , l_dblCLEARDAY , l_strCLEARCD ,'8','8', l_strPRICETYPE
                                         , l_dblQUOTEPRICE ,0, l_dblLIMITPRICE , l_dblORDERQTTY , l_dblORDERQTTY , l_dblQUOTEPRICE , l_dblORDERQTTY ,0,0,0,0,0,'001', l_strVOUCHER , l_strCONSULTANT , l_strContrafirm , l_strTraderid , l_strClientID , l_strFOACCTNO , l_strPutType , l_strContraCus , l_strContrafirm2, l_strTLID,l_strSSAFACCTNO );
                        INSERT INTO OOD (ORGORDERID,CODEID,SYMBOL,CUSTODYCD,
                                        BORS,NORP,AORN,PRICE,QTTY,SECUREDRATIO,OODSTATUS,TXDATE,TXNUM,DELTD,BRID)
                        VALUES ( l_strORDERID , l_strCODEID , l_strSYMBOL , l_strCUSTODYCD ,'S', l_strMATCHTYPE
                                        , l_strNORK , l_dblQUOTEPRICE , l_dblORDERQTTY , l_dblBRATIO ,'N',TO_DATE( p_txmsg.txdate ,  systemnums.C_DATE_FORMAT ), p_txmsg.txnum ,'N', l_strBRID );

        end if;
    end if;

    plog.debug (pkgctx, '<<END OF fn_txAftAppUpdate');
    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
       plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAftAppUpdate;

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
         plog.init ('TXPKS_#8874EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#8874EX;
/
