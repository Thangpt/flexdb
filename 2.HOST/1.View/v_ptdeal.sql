CREATE OR REPLACE FORCE VIEW V_PTDEAL AS
select PT."ORGORDERID",PT."CODEID",PT."CUSTODYCD",PT."SYMBOL",PT."BORS",PT."NORP",PT."AORN",PT."PRICE",PT."QTTY",PT."REFCUSTCD",
PT."MATCHPRICE",PT."MATCHQTTY",PT."TXDATE",PT."CONFIRM_NO", PT."CANCELLING", NVL(cpt.xinhuy,'N') CANCELREQUEST,NVL(cpt.huytt,'---') CANCELSTATUS,
NVL(cpt.timestamp,'---') TIMECALCEL, OM.FOORDERID
        from (   SELECT ORGORDERID,CODEID,CUSTODYCD,SYMBOL,BORS,NORP,AORN,PRICE,QTTY,REFCUSTCD,MATCHPRICE,MATCHQTTY,TXDATE,
                             CONFIRM_NO,'No' CANCELLING
                             FROM IOD WHERE IOD.DELTD <> 'Y' AND  NORP='P'
                             and orgorderid not in (SELECT ORDERNUMBER FROM CANCELORDERPTACK WHERE SORR='S' AND isconfirm ='N')
                             union
                             SELECT ORGORDERID,CODEID,CUSTODYCD,SYMBOL,BORS,NORP,AORN,PRICE,QTTY,REFCUSTCD,MATCHPRICE,MATCHQTTY,TXDATE,CONFIRM_NO,'Yes' CANCELLING
                             FROM IOD WHERE IOD.DELTD <> 'Y' AND  NORP='P'
                             and orgorderid  in (SELECT ORDERNUMBER FROM CANCELORDERPTACK WHERE SORR='S' AND isconfirm ='N')
                             ) pt,
                             (SELECT * FROM (
                             SELECT  c.timestamp, i.orgorderid ORDERNUMBER,'Y' XINHUY ,
                               case
                                 when status='S' and isconfirm='N' then 'Xin huy'
                                 when status='C' and isconfirm='Y' then 'DT tu choi'
                                 when status='S' and isconfirm='Y' then 'So tu choi'
                                 when status='A' and isconfirm='Y' then 'Chap nhan huy'
                                 else '----'
                               end HuyTT
                              FROM CANCELORDERPTACK C, IOD I   WHERE C.SORR='S' and C.side='S'
                                  and i.norp='P' and i.deltd<>'Y' and i.bors='S'
                                  and trim(c.confirmnumber)=trim(i.confirm_no)
                              union all
                              SELECT c.timestamp, i.orgorderid ORDERNUMBER ,'Y' XINHUY ,
                               case
                                 when  isconfirm='N' then 'DT Xin huy'
                                 when isconfirm='Y' and status='C' then 'Tu choi huy'
                                 when isconfirm='Y' and status='A' THEN 'Chap nhan huy'
                                  when isconfirm='Y' and status='S'  then 'So tu choi'
                                 else   '----'
                               end HuyTT
                              FROM CANCELORDERPTACK C, IOD I
                                  WHERE c.SORR='R'
                                  and i.norp='P' and i.deltd<>'Y' and i.bors='B'
                                  and trim(c.confirmnumber)=trim(i.confirm_no)) cpt
                                  --WHERE ROWNUM=1
                                ORDER BY timestamp DESC
                                  ) CPT, newfo_ordermap OM
       WHERE pt.ORGORDERID = cpt.ORDERNUMBER(+)
        AND pt.ORGORDERID = OM.BOORDERID(+)
       ORDER BY pt.ORGORDERID,NVL(cpt.timestamp,'---')
;

