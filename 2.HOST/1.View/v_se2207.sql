CREATE OR REPLACE FORCE VIEW V_SE2207 AS
SELECT mst.ITEM, mst.ITEM SYMBOL, MST.ACCTNO ACCTNO, mst.CUSTODYCD, mst.fullname, mst.refullname, trunc(mst.trade) trade,trunc(mst.receiving) receiving ,
        trunc(mst.secured) secured, trunc(mst.basicprice) basicprice,trunc(mst.COSTPRICE) costprice,
        trunc (mst.PROFITANDLOSS) PROFITANDLOSS,  mst.PCPL, trunc(mst.COSTPRICEAMT) COSTPRICEAMT,
        trunc(mst.MARKETAMT) marketamt,
        mst.receiving_right,mst.receiving_t0,mst.receiving_t1,mst.receiving_t2,mst.receiving_t3, --T2_HoangND them truong receiving_t0
        trunc(mst.trade) +  trunc(mst.secured) + mst.receiving_right + mst.receiving_t0 + mst.receiving_t1 + mst.receiving_t2 + mst.receiving_t3 SUM_QTTY,
        mst.refrecflnkid
FROM (
            select item, acctno, custodycd, fullname,refrecflnkid, refullname, trade, receiving, secured, basicprice,
                    costprice,
                    (basicprice - costprice) * (trade + ca_sec + receiving) PROFITANDLOSS,
                    DECODE(round(COSTPRICE),0,0, ROUND((BASICPRICE- round(COSTPRICE))*100/(round(COSTPRICE)+0.00001),2)) PCPL,
                    costprice * (trade + receiving) COSTPRICEAMT,
                    basicprice * (trade + receiving + secured + ca_sec)  MARKETAMT, RECEIVING_RIGHT, receiving_t0, receiving_t1, receiving_t2, receiving_t3
            from
            (
                SELECT TO_CHAR(SB.SYMBOL) ITEM, SDTL.AFACCTNO ACCTNO, sdtl.CUSTODYCD, cf.fullname, r.refullname, r.refrecflnkid,
                    SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED TRADE,
                    nvl(sdtl_wft.wft_receiving,0) CA_sec,
                    SDTL.receiving + nvl(od.B_execqtty_new,0) receiving,        --T2_HoangND
                    nvl(od.REMAINQTTY,0) secured,
                    SEC.BASICPRICE,
                    round((
                        round(sdtl.COSTPRICE) -- gia_von_ban_dau ,
                        *(SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED + SDTL.RECEIVING  ) --tong_kl
                        + nvl(od.B_execamt,0) --gia_tri_mua --gia tri khop mua
                        ) / (SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED
                        + SDTL.RECEIVING + nvl(od.B_EXECQTTY,0) + 0.000001 )
                        )  COSTPRICE,
                    nvl(od.B_execqtty_new,0) + SDTL.RECEIVING - SDTL.SECURITIES_RECEIVING_T0 - SDTL.SECURITIES_RECEIVING_T1 - SDTL.SECURITIES_RECEIVING_T2 + nvl(sdtl_wft.wft_receiving,0) RECEIVING_RIGHT,
                    SDTL.SECURITIES_RECEIVING_T0 receiving_t0,
                    SDTL.SECURITIES_RECEIVING_T1 receiving_t1,
                    SDTL.SECURITIES_RECEIVING_T2 receiving_t2,
                    SDTL.SECURITIES_RECEIVING_T3 receiving_t3
                FROM  cfmast cf, SBSECURITIES SB, SECURITIES_INFO SEC, BUF_SE_ACCOUNT SDTL
                left join
                (select seacctno, sum(o.remainqtty) remainqtty, sum(decode(o.exectype , 'NB',  o.execamt ,0 )) B_execamt
                    , sum(decode(o.exectype , 'NB',  o.execqtty ,0 )) B_execqtty, SUM(CASE WHEN o.stsstatus <> 'C' THEN (decode(o.exectype , 'NB',  o.execqtty ,0 )) ELSE 0 END)  B_execqtty_new
                from odmast o
                where deltd <>'Y' and o.exectype in('NS','NB','MS')
                and o.txdate =(select to_date(VARVALUE,'DD/MM/YYYY') from sysvar where grname='SYSTEM' and varname='CURRDATE')
                group by seacctno
                ) OD on sdtl.acctno = od.seacctno
                left join
                (select afacctno, refcodeid, trade + receiving - SECURITIES_RECEIVING_T1 - SECURITIES_RECEIVING_T2 wft_receiving
                from buf_se_account sdtl, sbsecurities sb
                where sdtl.codeid = sb.codeid and sb.refcodeid is not null
                ) sdtl_wft on sdtl.codeid = sdtl_wft.refcodeid and sdtl.afacctno = sdtl_wft.afacctno
                 inner join
                (
                 select substr(r.reacctno,1,10) recustid, r.afacctno , cf.fullname refullname, r.refrecflnkid
                 from reaflnk r, retype rt, cfmast cf
                    where r.frdate <= getcurrdate and nvl(r.clstxdate, r.todate - 1) >= getcurrdate
                    and rt.actype = substr(r.reacctno,11,4) and rt.rerole = 'BM' and substr(r.reacctno,1,10) = cf.custid
                    --and exists (select 1 from reuserlnk where refrecflnkid = r.refrecflnkid and tlid = '<TELLERID>')
                ) r on sdtl.afacctno = r.afacctno
                WHERE SB.CODEID = SDTL.CODEID and sb.refcodeid is null
                and sdtl.custodycd = cf.custodycd
                AND SDTL.CODEID = SEC.CODEID
                and SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED + SDTL.receiving+SDTL.SECURITIES_RECEIVING_T0+SDTL.SECURITIES_RECEIVING_T1+SDTL.SECURITIES_RECEIVING_T2+SDTL.SECURITIES_RECEIVING_T3 + nvl(od.REMAINQTTY,0) + nvl(sdtl_wft.wft_receiving,0)>0
     )
) MST
;

