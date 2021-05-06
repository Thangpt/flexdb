BEGIN
for rec in 
  (
  SELECT custodycd,afacctno,txdate,round(sum((realass + BALANCE) - (DEPOFEEAMT + T0AMT + MRAMT)),4) AVGNAVED
            FROM(select cf.custodycd,v.afacctno ,v.txdate, sum((v.trade + v.mortage + v.TOTALRECEIVING - v.SELLMATCHQTTY + v.TOTALBUYQTTY)*se.avgprice) realass,
                       max(T0AMT)T0AMT, max(MRAMT) MRAMT, max(v.balance + v.avladvance) BALANCE,
                       max(v.depofeeamt) DEPOFEEAMT
                from (SELECT * FROM tbl_mr3007_log 
                WHERE txdate between to_date('01/01/2020','DD/MM/RRRR') and getcurrdate
                ) v, 
                (select * from securities_info_hist where histdate between to_date('01/01/2020','DD/MM/RRRR') and getcurrdate
                )se, cfmast cf
                where cf.custodycd = v.custodycd
                and v.codeid=se.codeid
                and v.txdate=se.histdate
                group by cf.custodycd,v.afacctno,v.txdate )
            WHERE (realass + BALANCE) - (DEPOFEEAMT + T0AMT + MRAMT) > 0
            GROUP BY custodycd,afacctno,txdate
            
  )
 LOOP
   UPDATE log_sa0015 lg 
   SET lg.navamt_ed=rec.avgnaved
   WHERE lg.txdate=rec.txdate and lg.afacctno=rec.afacctno;
   END LOOP;
COMMIT;
END ;
