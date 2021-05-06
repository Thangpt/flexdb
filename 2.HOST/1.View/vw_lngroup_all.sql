CREATE OR REPLACE FORCE VIEW VW_LNGROUP_ALL AS
select trfacctno,
            sum(oprinnml+oprinovd+ointnmlacr+ointdue+ointovdacr+ointnmlovd) t0amt,
            sum(nvl(ls1.in_t0amt,0)) in_t0amt,
            sum(nvl(ls1.ovd_t0amt,0)) ovd_t0amt,
            sum(prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd) marginamt,
            sum(prinovd+intovdacr+intnmlovd+feeintovdacr+feeintnmlovd + nvl(ls.dueamt,0) +intdue + feeintdue) marginovdamt,
            sum(decode(lnt.chksysctrl,'Y',1,0)*(prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd)) margin74amt,
            sum(decode(lnt.chksysctrl,'Y',1,0)*(prinovd+intovdacr+intnmlovd+feeintovdacr+feeintnmlovd + nvl(ls.dueamt,0) +intdue + feeintdue)) margin74ovdamt
        from lnmast ln, lntype lnt,
                (select acctno, sum(nml) dueamt
                        from lnschd
                        where reftype = 'P' and overduedate = getcurrdate
                        group by acctno) ls,
                (SELECT ln.acctno,
                            sum(CASE WHEN lns.reftype = 'GP'
                                        THEN
                            (case when mintermdate >= getcurrdate then   (lns.nml + lns.ovd + lns.intdue + lns.intovd + lns.feedue + lns.feeovd + lns.intovdprin + lns.intnmlacr
                                    + lns.feeintnmlacr + lns.feeintovdacr + lns.feeintnmlovd + lns.feeintdue + lns.nmlfeeint + lns.ovdfeeint + lns.feeintnml + lns.feeintovd ) else 0 end)
                            else  0
                            END )  in_t0amt,
                            sum(CASE WHEN lns.reftype = 'GP'
                                        THEN
                            (case when mintermdate < getcurrdate then   (lns.nml + lns.ovd + lns.intdue + lns.intovd + lns.feedue + lns.feeovd + lns.intovdprin + lns.intnmlacr
                                    + lns.feeintnmlacr + lns.feeintovdacr + lns.feeintnmlovd + lns.feeintdue + lns.nmlfeeint + lns.ovdfeeint + lns.feeintnml + lns.feeintovd ) else 0 end)
                            else  0
                            END )  ovd_t0amt
                        FROM lnschd lns, lnmast ln ,lntype lnt
                        WHERE lns.acctno = ln.acctno
                            AND ln.actype = lnt.actype
                        group by ln.acctno
                ) ls1
         where ftype = 'AF'
                and ln.actype = lnt.actype
                and ln.acctno = ls.acctno(+)
                and ln.acctno = ls1.acctno(+)
        group by ln.trfacctno;

