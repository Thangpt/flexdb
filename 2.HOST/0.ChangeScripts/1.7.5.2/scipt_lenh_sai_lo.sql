--Scrpt lấy lệnh sai lô
SELECT od.*, sb.tradeplace
                 FROM ODMAST od, securities_info seif, sbsecurities sb, ood ood
                WHERE od.CODEID = seif.CODEID
                  AND seif.codeid = sb.codeid
                  and od.orderid=ood.orgorderid
                  and ood.oodstatus='N'--Chua gui So
                  and od.remainqtty > 0
          AND od.ORSTATUS not in ('6','5','7')--lenh da het hieu luc
                  and  ( -- cac lenh sai lo
                           (CASE
                             WHEN sb.tradeplace = '001' or
                                  (sb.tradeplace in ('002', '005') and
                                  od.orderqtty > seif.TRADELOT) THEN
                              Mod(od.orderqtty, seif.TRADELOT)
                             ELSE
                              0
                           END) <> 0
                         );

                       
--Script lấy lệnh ngoài giờ sai lô
SELECT bo.*
                 FROM borqslog bo, securities_info seif, sbsecurities sb
                WHERE bo.description = sb.symbol
                  AND seif.symbol = sb.symbol
                  and bo.rqstyp='APL'
                  and bo.status='P'
                  and  (CASE
                               WHEN sb.tradeplace = '001' or
                                    (sb.tradeplace in ('002', '005') and
                                    bo.msgqtty > seif.TRADELOT) THEN
                                Mod(bo.msgqtty, seif.TRADELOT)
                               ELSE
                                0
                             END) <> 0;
