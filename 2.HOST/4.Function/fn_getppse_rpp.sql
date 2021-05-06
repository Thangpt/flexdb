CREATE OR REPLACE FUNCTION fn_getppse_rpp
    (p_afacctno IN VARCHAR2,
    p_symbol in varchar2,
    p_quoteprice in number,
    p_via in varchar2 default 'O',
    P_TYPE in varchar default '1')
    RETURN number
  IS
    l_DefFeeRate number(20,8);
    l_count number;
    l_AvlLimit number;
    l_MarginType varchar2(1);
    l_ChkSysCtrl varchar2(1);
    l_RskMarginRate number(20,8);
    l_RskMarginPrice number(20,0);
    l_IsMarginAllow varchar2(1);
    l_MarginPrice number(20,0);
    l_MarginRefPrice number(20,0);
    l_SysMarginRate number(20,8);
    l_Advanceline number(20,0);
    l_Trft0amt number(20,0);
    l_FloorPrice number(20,0);
    l_quoteprice number(20,0);
    l_pp0 number(20,0);
    l_ppSE number(20,0);
    l_pp0Ref number(20,0);
    l_ppSERef number(20,0);
    l_codeid varchar2(10);
    l_IsLateTransfer number(10);
    l_avlroomqtty number;
    l_avlsyroomqtty number;
    l_avlqtty number;
    l_avlsyqtty number;
    l_PP0_add number;
    l_RskMarginRate_in_basket number;
    l_RskMarginPrice_in_basket number;
    l_TradeLot number(20,0);
    l_T0SecureAmt number(20,4);
    l_SecType varchar2(100);
    l_Aftype varchar2(4);
    v_ci_arr txpks_check.cimastcheck_arrtype;
    l_getpp_arr txpks_check.getpp_arrtype;
    l_roomchk   char(1);

    l_trademax number(20,0);
    l_t0loanrate  NUMBER;
    l_deal        VARCHAR2(2);
    l_isstopadv   varchar2(10);
BEGIN
    l_isstopadv := cspks_system.fn_get_sysvar('MARGIN','ISSTOPADV');
    l_RskMarginRate_in_basket:=0;
    l_RskMarginPrice_in_basket:=0;


    /*v_ci_arr := txpks_check.fn_CIMASTcheck(p_afacctno,'CIMAST','ACCTNO');
    begin
        select v_ci_arr(0).pp, v_ci_arr(0).PPREF
        into l_pp0, l_pp0Ref
        from dual;
    exception when others then
        l_pp0:=0;
        l_pp0Ref:=0;
    end;*/
    l_pp0:=0;
    l_pp0Ref:=0;
    l_getpp_arr:=txpks_check.fn_getpp(p_afacctno);
    l_pp0:=l_getpp_arr(0).pp;
    l_pp0Ref:=l_getpp_arr(0).PPREF;

    if p_symbol is null or p_symbol='' or length(p_symbol)=0 or p_symbol=' ' then
       IF P_TYPE='1' THEN
             return  l_pp0;
       end if;
     end if;

    select se.marginprice, se.marginrefprice, se.floorprice, se.codeid, se.tradelot, sb.sectype
        into l_MarginPrice, l_MarginRefPrice, l_FloorPrice, l_codeid, l_TradeLot, l_SecType
    from securities_info se, sbsecurities sb
    where se.codeid = sb.codeid and se.symbol = p_symbol;

    select actype into l_Aftype from afmast where acctno = p_afacctno;

    begin
       SELECT deffeerate/100
       into l_DefFeeRate
       FROM (   SELECT a.deffeerate, b.ODRNUM
               FROM odtype a, afidtype b
               WHERE     a.status = 'Y'
                     AND (a.via = p_via OR a.via = 'A') --VIA
                     /*AND a.clearcd = l_build_msg (indx).fld26       --CLEARCD
                     AND (a.exectype = l_strEXECTYPE           --l_build_msg (indx).fld22
                          OR a.exectype = 'AA')                    --EXECTYPE
                     AND (a.timetype = l_build_msg (indx).fld20
                          OR a.timetype = 'A')                     --TIMETYPE
                     AND (a.pricetype = l_build_msg (indx).fld27
                          OR a.pricetype = 'AA')                  --PRICETYPE
                     AND (a.matchtype = l_build_msg (indx).fld24
                          OR a.matchtype = 'A')                   --MATCHTYPE
                     AND (a.tradeplace = l_build_msg (indx).tradeplace
                          OR a.tradeplace = '000')*/
                     AND (instr(case when l_SecType in ('001','002','011') then l_SecType || ',' || '111,333'
                                     when l_SecType in ('003','006') then l_SecType || ',' || '222,333,444'
                                     when l_SecType in ('008') then l_SecType || ',' || '111,444'
                                     else l_SecType end , a.sectype)>0 OR a.sectype = '000')
                     /*AND (a.nork = l_build_msg (indx).fld23 OR a.nork = 'A') --NORK*/
                     AND (CASE WHEN A.CODEID IS NULL THEN l_codeid ELSE A.CODEID END)=l_codeid
                     AND a.actype = b.actype and b.aftype=l_Aftype and b.objname='OD.ODTYPE'
                     --order BY A.deffeerate, B.ACTYPE DESC
                     ORDER BY CASE WHEN (SELECT VARVALUE FROM SYSVAR WHERE GRNAME = 'SYSTEM' AND VARNAME = 'ORDER_ORD') = 'ODRNUM' THEN ODRNUM ELSE DEFFEERATE END ASC -- lay theo ordnum cua afidtype
             ) where rownum<=1;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
        begin
            select nvl(fn_getmaxdeffeerate(p_afacctno),0) into l_DefFeeRate from dual;
        exception when others then
            l_DefFeeRate:=0;
        end;
    END;
/*    begin
        select nvl(fn_getmaxdeffeerate(p_afacctno),0) into l_DefFeeRate from dual;
    exception when others then
        l_DefFeeRate:=0;
    end;*/

    if p_quoteprice is null then
        l_quoteprice:= l_FloorPrice;
    else
        l_quoteprice:= greatest(p_quoteprice,l_FloorPrice);
    end if;

    select mrt.mrtype, nvl(chksysctrl,'N'), (af.trfbuyext * af.trfbuyrate)
        into l_MarginType, l_ChkSysCtrl, l_IsLateTransfer
    from afmast af, aftype aft, lntype lnt, mrtype mrt
    where af.actype  = aft.actype and aft.lntype = lnt.actype(+) and aft.mrtype = mrt.actype and af.acctno = p_afacctno;

    if l_MarginType = 'T' then

        begin
            select rsk.mrratioloan/100, rsk.mrpriceloan, rsk.ismarginallow
                into l_RskMarginRate, l_RskMarginPrice, l_IsMarginAllow
            from afmast af, afserisk rsk
            where af.actype = rsk.actype and af.acctno = p_afacctno and rsk.codeid = l_codeid;
        exception when others then
            l_RskMarginRate:=0;
            l_RskMarginPrice:=0;
            l_IsMarginAllow:='N';
            l_RskMarginRate_in_basket:=null;
            l_RskMarginPrice_in_basket:=null;
        end;

        BEGIN
          SELECT cf.t0loanrate, nvl(af.deal,'Y') INTO l_t0loanrate,l_deal FROM cfmast cf, afmast af
          WHERE cf.custid = af.custid AND af.acctno = p_afacctno;
        exception when others then
            l_t0loanrate:=0;
            l_deal:='Y';
        END;

        if l_ChkSysCtrl = 'Y' then
            if l_IsMarginAllow = 'N' then
                l_RskMarginRate:=0;
            else
                l_MarginPrice:= least(l_MarginPrice, l_MarginRefPrice, l_RskMarginPrice);
            end if;
            select (1-to_number(varvalue)/100) into l_SysMarginRate from sysvar where varname = 'IRATIO' and grname = 'MARGIN';
            l_RskMarginRate:=least(l_RskMarginRate,l_SysMarginRate);
        else
            l_MarginPrice:= least(l_MarginPrice, l_RskMarginPrice);
        end if;
    else
             IF P_TYPE='1' THEN
             return  l_pp0;
            ELSE
              l_trademax:= trunc(Floor(l_pp0 / (l_quoteprice* (1+l_DefFeeRate)))/l_TradeLot)*l_TradeLot;
              return  l_trademax;
            end if;

    end IF;

    --1.5.8.9 MSBS-2055
    select round(decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) + nvl(balance,0)- nvl(odamt,0) - nvl(dfdebtamt,0) - nvl(dfintdebtamt,0)  - nvl (overamt,0) -nvl(secureamt,0) +
           /*nvl(af.advanceline,0)*/
           CASE WHEN l_deal = 'N' THEN greatest(least(ROUND(least(nvl((ci.balance-NVL(b.secureamt,0)) + decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) + v_getsec.senavamt -
                NVL(ci.ovamt,0),0) * l_t0loanrate /100,nvl(v_getsec.SELIQAMT2,0))),af.advanceline),0) ELSE af.advanceline END
           - nvl(trft0amt,0) - nvl(trft0addamt,0) -nvl(trfsecuredamt,0) - nvl(ramt,0) - nvl(depofeeamt,0) + AF.mrcrlimitmax+nvl(AF.mrcrlimit,0) - dfodamt,0),
        CASE WHEN l_deal = 'N' THEN greatest(least(ROUND(least(nvl((ci.balance-NVL(b.secureamt,0)) + decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) + v_getsec.senavamt -
        NVL(ci.ovamt,0),0) * l_t0loanrate /100,nvl(v_getsec.SELIQAMT2,0)))
        ,af.advanceline),0) ELSE af.advanceline END advanceline,
        nvl(b.trft0amt,0), (nvl(b.buyamt,0) * af.trfbuyrate/100)+(case when af.trfbuyrate > 0 then nvl(b.buyfeeacr,0) else 0 end)
        into l_AvlLimit, l_Advanceline, l_Trft0amt, l_T0SecureAmt
    from cimast ci inner join afmast af on ci.acctno=af.acctno
        left join
        (select * from v_getbuyorderinfo where afacctno = p_afacctno) b
        on  ci.acctno = b.afacctno
        LEFT JOIN
        (select sum(depoamt) avladvance, sum(paidamt) paidamt, sum(advamt) advanceamount,afacctno, sum(aamt) aamt from v_getAccountAvlAdvance where afacctno = p_afacctno group by afacctno) adv
        on adv.afacctno=ci.acctno
        LEFT JOIN
        (select * from v_getdealpaidbyaccount p where p.afacctno = p_afacctno) pd
        on pd.afacctno=ci.acctno
        LEFT JOIN
        (SELECT * FROM v_getsecmargininfo_ALL) v_getsec
        ON ci.acctno = v_getsec.afacctno
        where ci.acctno = p_afacctno;

    --plog.debug('PPSE.pr_getppse:'||l_RskMarginRate||'-'||l_MarginPrice||'-'||l_quoteprice||'-l_DefFeeRate:'||l_DefFeeRate||'-'||l_Advanceline||'-'||l_Trft0amt);
    if /*l_pp0 > 0 and*/ (1 - l_RskMarginRate * l_MarginPrice/l_quoteprice) <> 0 and l_IsLateTransfer = 0 then
        --l_ppSE:=l_pp0 / ((1 + l_DefFeeRate - l_RskMarginRate * l_MarginPrice/l_quoteprice)/(1 + l_DefFeeRate)) + greatest(l_Advanceline - l_Trft0amt,0) - l_T0SecureAmt;
        l_ppSE:=(l_pp0+ greatest(l_Advanceline - l_Trft0amt,0)) /
              ((1 + l_DefFeeRate - l_RskMarginRate * l_MarginPrice/l_quoteprice)
              /(1 + l_DefFeeRate))  - l_T0SecureAmt;
    else
        l_ppSE:=l_pp0 + greatest(l_Advanceline - l_Trft0amt,0) - l_T0SecureAmt;
    end if;
    if /*l_pp0Ref > 0 and*/ (1 - l_RskMarginRate * l_MarginPrice/l_quoteprice) <> 0 then
        l_ppSERef:=(l_pp0Ref+ greatest(l_Advanceline - l_Trft0amt,0)) /
                       ((1 + l_DefFeeRate - l_RskMarginRate * l_MarginPrice/l_quoteprice)/(1 + l_DefFeeRate)) ;
    else
        l_ppSERef:=l_pp0Ref + greatest(l_Advanceline - l_Trft0amt,0);
    end if;

    --GianhVG them code xu ly cho Room dac biet
    begin
        select nvl(roomchk,'Y') into l_roomchk from semast se
        where se.afacctno = p_afacctno and se.codeid = l_codeid;
    exception when others then
        l_roomchk:='Y';
    end;
    --Neu check theo Room chung he thong
    if l_roomchk ='Y' then
        -- Room
        begin
            select greatest(r1.syroomlimit - r1.syroomused - nvl(u1.sy_prinused,0),0) avlsyroom,
                   greatest(r1.roomlimit - nvl(u1.prinused,0),0) avlroom
                    into l_avlsyroomqtty, l_avlroomqtty
            from vw_marginroomsystem r1,
            (select codeid, sum(case when restype = 'M' then prinused else 0 end) prinused,
                        sum(case when restype = 'S' then prinused else 0 end) sy_prinused
                from vw_afpralloc_all
                where codeid = l_codeid
                group by codeid) u1
            where r1.codeid = u1.codeid(+)
            and r1.codeid = l_codeid;
        exception when others then
            l_avlsyroomqtty:=0;
            l_avlroomqtty:=0;
        end;

        --AvlQtty
        begin
            select greatest(nvl(l_avlsyroomqtty + nvl(sy_prinused,0),0) - nvl(least(trade + receiving - execqtty + buyqtty,l_avlsyroomqtty + nvl(sy_prinused,0)),0),0) avlsyqtty,
                   greatest(nvl(l_avlroomqtty + nvl(prinused,0),0) - nvl(least(trade + receiving - execqtty + buyqtty,l_avlroomqtty + nvl(prinused,0)),0),0) avlqtty
               into l_avlsyqtty, l_avlqtty
            from
            (select se.codeid, af.actype,se.afacctno,se.acctno, se.trade + se.grpordamt trade, nvl(sts.receiving,0) receiving,nvl(sts.TOTALRECEIVING,0) TOTALRECEIVING,nvl(BUYQTTY,0) BUYQTTY,nvl(TOTALBUYQTTY,0) TOTALBUYQTTY,nvl(od.EXECQTTY,0) EXECQTTY,  nvl(afpr.prinused,0) prinused, nvl(afpr.sy_prinused,0) sy_prinused
              from (select * from semast where afacctno = p_afacctno and codeid = l_codeid) se
                inner join (select * from afmast where acctno = p_afacctno) af on se.afacctno =af.acctno
              left join
              (select sum(buyqtty) buyqtty, sum(TOTALBUYQTTY) TOTALBUYQTTY, sum(execqtty) execqtty , seacctno
                      from (
                          SELECT (case when od.exectype IN ('NB','BC')
                                      then (case when (af.trfbuyext * af.trfbuyrate) > 0 then 0 else REMAINQTTY end)
                                              + (case when nvl(sts_trf.islatetransfer,0) > 0 then 0 else EXECQTTY - DFQTTY end)
                                      else 0 end) BUYQTTY,
                                 (case when od.exectype IN ('NB','BC') then REMAINQTTY + EXECQTTY - DFQTTY else 0 end) TOTALBUYQTTY,
                                 (case when od.exectype IN ('NS','MS') then EXECQTTY - nvl(dfexecqtty,0) else 0 end) EXECQTTY,SEACCTNO
                          FROM odmast od, afmast af, (select orgorderid, (trfbuyext * trfbuyrate) * (amt- trfexeamt) islatetransfer from stschd where duetype = 'SM' and deltd <> 'Y') sts_trf,
                                        (select orderid, sum(execqtty) dfexecqtty from odmapext where type = 'D' group by orderid) dfex
                             where od.afacctno = p_afacctno and od.afacctno = af.acctno and od.orderid = sts_trf.orgorderid(+) and od.orderid = dfex.orderid(+)
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
                      SUM(CASE WHEN DUETYPE ='RS' and nvl(sts_trf.islatetransfer,0) = 0 AND STS.TXDATE <> (SELECT TO_DATE(VARVALUE,'DD/MM/YYYY') FROM SYSVAR WHERE GRNAME='SYSTEM' AND VARNAME='CURRDATE') THEN QTTY-AQTTY ELSE 0 END) RECEIVING,
                      SUM(CASE WHEN DUETYPE ='RS' and STS.TXDATE <> (SELECT TO_DATE(VARVALUE,'DD/MM/YYYY') FROM SYSVAR WHERE GRNAME='SYSTEM' AND VARNAME='CURRDATE') THEN QTTY-AQTTY ELSE 0 END) TOTALRECEIVING
                  FROM STSCHD STS, ODMAST OD, ODTYPE TYP, (select orgorderid, (trfbuyext * trfbuyrate) * (amt - trfexeamt) islatetransfer from stschd where duetype = 'SM' and deltd <> 'Y') sts_trf
                  WHERE STS.DUETYPE IN ('RM','RS') AND STS.STATUS ='N'
                      AND STS.DELTD <>'Y' AND STS.ORGORDERID=OD.ORDERID AND OD.ACTYPE =TYP.ACTYPE
                      and od.orderid = sts_trf.orgorderid(+) and sts.afacctno = p_afacctno
                      GROUP BY STS.AFACCTNO,STS.CODEID
               ) sts
              on sts.afacctno =se.afacctno and sts.codeid=se.codeid
              left join
              (
                  select afacctno, codeid,
                      nvl(sum(case when restype = 'M' then prinused else 0 end),0) prinused,
                      nvl(sum(case when restype = 'S' then prinused else 0 end),0) sy_prinused
                  from vw_afpralloc_all
                  where codeid = l_codeid and afacctno = p_afacctno
                  group by afacctno, codeid
              ) afpr  on afpr.afacctno =se.afacctno and afpr.codeid=se.codeid
            ) se,
            afmast af, afserisk rsk,securities_info sb
            where se.afacctno =af.acctno and se.codeid=sb.codeid
            and se.codeid=rsk.codeid (+) and se.actype =rsk.actype (+)
            and se.afacctno = p_afacctno and se.codeid = l_codeid;
        EXCEPTION when others then
            l_avlsyqtty:=l_avlsyroomqtty;
            l_avlqtty:=l_avlroomqtty;
        end;


        if l_ChkSysCtrl = 'Y' then
            l_PP0_add:= l_RskMarginRate * l_MarginPrice * LEAST(l_avlsyqtty,l_avlqtty);
        else
            l_PP0_add:= l_RskMarginRate * l_MarginPrice * l_avlsyqtty;
        end if;

        l_PPse:= least(l_PPse,l_pp0 + greatest(l_Advanceline - l_Trft0amt,0) - l_T0SecureAmt + l_PP0_add);
        l_ppSERef:= least(l_ppSERef,l_pp0Ref + greatest(l_Advanceline - l_Trft0amt,0) + l_PP0_add);


    end if;


    -- Lay min voi han muc:
    l_ppSE:= least(l_ppSE,l_AvlLimit);
    l_ppSERef:= least(l_ppSERef,l_AvlLimit);


    IF P_TYPE='1' THEN
     return  l_ppSE;
    ELSE
      l_trademax:= trunc(Floor(l_ppSE / (l_quoteprice* (1+l_DefFeeRate)))/l_TradeLot)*l_TradeLot;
      return  l_trademax;
    end if;

EXCEPTION WHEN others THEN
    RETURN 0;
END;
/
