CREATE OR REPLACE FORCE VIEW VW_SE2245 AS
((SELECT reqid, refmsgid, objname, rcvdate, rcvtime, trfcode, objkey, txdate, afacctno, msgacct, notes,
            msgstatus, vsd_err_msg, createdate, re.tlid, tlname, autoconf,
            sb2.codeid, blockedqtty, tradeqtty, effdate, recustodycd, cf.fullname, re.description,
            sb2.parvalue, re.inward, sb2.symbol, re.reftxnum, re.reftxdate
       FROM sbsecurities SB1, sbsecurities sb2, cfmast cf,
            (SELECT req.reqid, flog.refmsgid,  TRUNC (flog.timecreated) rcvdate, TO_CHAR (flog.timecreated, 'hh24:mi:ss') rcvtime,
                    req.objname, req.trfcode,
                    req.objkey,
                    TO_DATE (req.txdate, 'DD/MM/RRRR')
                        txdate, req.afacctno, req.msgacct,
                    req.notes, a1.cdcontent msgstatus,
                    req.vsd_err_msg,
                    TO_CHAR (req.createdate, 'hh24:mi:ss.')
                        createdate, req.tlid, tl.tlname,
                    a2.cdcontent autoconf,
                    dtl.symbol symbol, dtl.symboltype,
                    CASE WHEN dtl.sectype = '2' THEN dtl.qtty ELSE 0 END blockedqtty,
                    CASE WHEN dtl.sectype = '1' THEN dtl.qtty ELSE 0 END tradeqtty,
                    dtl.effdate effdate,
                    dtl.recustodycd recustodycd,
                    dtl.inward inward,
                    vcd.description description, reftxnum, reftxdate
               FROM vsdtxreq req, vsdtrfcode vcd, allcode a1,
                    tlprofiles tl, allcode a2,
                    (SELECT referenceid, refmsgid, timecreated,
                            MIN (autoconf) autoconf,
                            MAX (autoid) autoid
                       FROM (SELECT *
                               FROM vsdtrflog flog
                              WHERE INSTR (flog.funcname, '.ACK') = 0)
                     GROUP BY referenceid, refmsgid, timecreated) flog,
                     (SELECT  req.reqid,
                            MAX(CASE WHEN vdtl.fldname = 'SYMBOL' THEN vdtl.fldval
                                 WHEN vdtl.fldname = 'SYMBOL_CGD' THEN vdtl.fldval  || '_CGD'
                                 ELSE '' END) symbol,
                            MAX(CASE WHEN vdtl.fldname = 'QTTY' THEN TO_NUMBER(REPLACE (vdtl.fldval, ','))
                                 ELSE 0 END) qtty,
                            MAX(CASE WHEN vdtl.fldname = 'VSDEFFDATE' THEN TO_DATE(vdtl.fldval,'RRRR/MM/DD')
                                 ELSE null END) effdate,
                            MAX(CASE WHEN vdtl.fldname = 'CUSTODYCD' THEN vdtl.fldval
                                 ELSE '' END) recustodycd,
                            MAX(CASE WHEN vdtl.fldname = 'SYMBOLTYPE' THEN vdtl.fldval
                                 ELSE '' END) symboltype,
                            MAX(CASE WHEN vdtl.fldname = 'SECTYPE' THEN vdtl.fldval
                                 ELSE '' END) sectype,
                            MAX(CASE WHEN vdtl.fldname = 'REFCUSTODYCD' THEN substr(fldval, 1, 3)
                                 ELSE '' END) inward
                      FROM vsdtrflogdtl vdtl, vsdtrflog lg, vsdtxreq req
                    WHERE req.reqid = lg.referenceid AND lg.autoid = vdtl.refautoid
                    GROUP BY req.reqid) dtl
              WHERE     a1.cdtype = 'SA'
                    AND a1.cdname = 'NSDSTATUS'
                    AND a1.cdval = req.msgstatus
                    AND a2.cdtype = 'SY'
                    AND a2.cdname = 'YESNO'
                    AND a2.cdval = NVL (flog.autoconf, 'Y')
                    AND req.tlid = tl.tlid(+)
                    AND req.reqid = flog.referenceid(+)
                    AND req.reqid = dtl.reqid
                    AND req.trfcode = vcd.trfcode
                    AND vcd.tltxcd = '2245'
                    AND req.msgstatus = 'C') re
      WHERE sb1.symbol = re.symbol AND re.recustodycd = cf.custodycd
      AND CASE WHEN re.symboltype LIKE '%NORM%' THEN SB2.codeid ELSE SB2.refcodeid END = SB1.codeid

  )
)
ORDER BY reqid desc;

