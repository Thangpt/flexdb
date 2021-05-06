BEGIN
  INSERT INTO CI1018_LOG(TLTXCD_FILTER,TLTXCD,TXDESC,TXNUM,BUSDATE,TXDATE,CUSTODYCD,ACCTNO,CUSTODYCDC,ACCTNOC,AMT,MK,CK,BRID,TLBRID,TLID,OFFID,BANKID,COREBANK,BANKNAME,TRDESC,TXTYPE,CREDIT,DEBIT)
    SELECT A.*,
          CASE WHEN txtype <> 'D' THEN amt else 0 END Credit,
          CASE WHEN txtype <> 'C' THEN amt else 0 END Debit FROM (
        SELECT tl.tltxcd tltxcd_filter,
            tl.tltxcd  ,tl.txdesc TXDESC,tl.txnum,tl.busdate ,tl.txdate
            ,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc
            , tl.msgamt amt
            ,nvl(mk.tlname,'AUTO') mk
            ,nvl(ck.tlname,'AUTO') ck,nvl(AF.brid,'') brid,nvl(tl.brid,'') tlbrid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID
            ,'' bankid,af.corebank,'' bankname,tltx.txdesc TRDESC
            , CASE WHEN tl.tltxcd = '1170' THEN 'D'
                   WHEN  tl.tltxcd in ('1179') THEN 'C'
              END txtype
        FROM tllogall TL,afmast af,cfmast cf ,tltx, tlprofiles mk,tlprofiles ck
        WHERE tl.msgacct = af.acctno AND af.custid = cf.custid
        AND tltx.tltxcd = tl.tltxcd
        AND  tl.tlid = mk.tlid(+)
        AND  tl.OFFID =ck.tlid(+)
        AND tl.tltxcd IN('1170','1179') AND tl.TXDATE >= TO_DATE ('01/09/2019','DD/MM/RRRR')
        )A
        WHERE substr(a.custodycd,4,1) <> 'P'
        ORDER BY A.TLTXCD ,a.busdate,A.TXNUM;
END;


