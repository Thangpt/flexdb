CREATE OR REPLACE PACKAGE AUTO_CALL_TRANSAC as
--  procedure auto_call_txpks_0048(pv_reqid number, pv_vsdtrfid number);
  procedure auto_call_txpks_2246(pv_reqid number, pv_vsdtrfid number,busdate DATE,tlid VARCHAR2);
  procedure auto_call_txpks_2231(pv_reqid number, pv_vsdtrfid number,busdate DATE,tlid VARCHAR2);
  procedure auto_call_txpks_2294(pv_reqid number, pv_vsdtrfid number,busdate DATE,tlid VARCHAR2);
  procedure auto_call_txpks_2201(pv_reqid number, pv_vsdtrfid number,busdate DATE,tlid VARCHAR2);
  procedure auto_call_txpks_2266(pv_reqid number, pv_vsdtrfid number,busdate DATE,tlid VARCHAR2);
  procedure auto_call_txpks_2265(pv_reqid number, pv_vsdtrfid number,busdate DATE,tlid VARCHAR2);
  --procedure auto_call_txpks_8894(pv_reqid number, pv_vsdtrfid number);
  procedure auto_call_txpks_8816(pv_reqid number, pv_vsdtrfid number,busdate DATE,tlid VARCHAR2);
  procedure auto_call_txpks_8879(pv_reqid number, pv_vsdtrfid number,busdate DATE,tlid VARCHAR2);
  procedure auto_call_txpks_2248(pv_reqid number, pv_vsdtrfid number,busdate DATE,tlid VARCHAR2);
  --procedure auto_call_txpks_2249(pv_reqid number, pv_vsdtrfid number);
  --procedure auto_call_txpks_0059(pv_reqid number, pv_vsdtrfid number);
  procedure auto_call_txpks_2290(pv_reqid number, pv_vsdtrfid number,busdate DATE,tlid VARCHAR2);
  --procedure auto_call_txpks_3380(pv_reqid number, pv_vsdtrfid number);
  --procedure auto_call_txpks_2245(pv_reqid number, pv_vsdtrfid number);
end AUTO_CALL_TRANSAC;
/

CREATE OR REPLACE PACKAGE BODY AUTO_CALL_TRANSAC as
  pkgctx plog.log_ctx;
  logrow tlogdebug%rowtype;
  -- Private variable declarations
/*procedure auto_call_txpks_0048(pv_reqid number, pv_vsdtrfid number) as
    l_txmsg       tx.msg_rectype;
    v_strcurrdate varchar2(20);
    l_strdesc     varchar2(400);
    l_tltxcd      varchar2(4);
    p_err_code    varchar2(20);
    l_err_param   varchar2(100);
    l_sqlerrnum   varchar2(200);
  begin
    for rec0 in (select req.*, code.tltxcd, code.searchcode, code.filtername
                   from vsdtxreq req, vsdtrfcode code
                  where req.msgstatus in ('C', 'R', 'W')
                    and req.status <> 'C'
                       --                    and req.msgstatus = 'W'   -- cac msg chua hoan thanh giao dich
                    and req.trfcode = code.trfcode
                    and code.status = 'Y'
                    and code.type in ('CFO', 'CFN')
                    and req.reqid = pv_reqid) loop

      -- nap giao dich de xu ly
      l_tltxcd       := '0048';
      l_txmsg.tltxcd := l_tltxcd;
      select txdesc into l_strdesc from tltx where tltxcd = l_tltxcd;
      l_txmsg.msgtype := 'T';
      l_txmsg.local   := 'N';
      l_txmsg.tlid    := systemnums.c_system_userid;
      select sys_context('USERENV', 'HOST'),
             sys_context('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;
      l_txmsg.off_line  := 'N';
      l_txmsg.deltd     := txnums.c_deltd_txnormal;
      l_txmsg.txstatus  := txstatusnums.c_txcompleted;
      l_txmsg.msgsts    := '0';
      l_txmsg.ovrsts    := '0';
      l_txmsg.batchname := 'DAY';
      l_txmsg.busdate   := getcurrdate;
      l_txmsg.txdate    := getcurrdate;
      select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;
      select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
      l_txmsg.brid := rec0.brid; -- can sua lai them brid trong vsdtxreq de fill lai gt vao day
      for rec in (select a4.cdval fntypeid, a4.cdcontent fntype, cf.custodycd,
                         cf.fullname, cf.idcode, cf.iddate, cf.address,
                         cf.idexpired, cf.mobile phone, cf.email,
                         rq.txdate voucherdate, rq.objkey vouchernumber,
                         cf.nsdstatus cfstatusid,
                         \*rq.adtxprocess sendstatusid,*\
                         \*a2.cdcontent sendstatus,*\
                         rq.msgstatus msgstatusid, a3.cdcontent msgstatus,
                         rq.rqtype rqtypeid, a5.cdcontent rqtype,
                         (case
                           when trflogdtl.fldval = 'OACK' then
                            'C'
                           else
                            'R'
                         end) cfstatus,
                         -- errmsg,
                         rq.refcode, rq.times, '' autoid, rq.reqid, cf.custid,
                         cf.idtype
                    from vsdtxreq rq, cfmast cf, allcode a1, \*allcode a2,*\
                         allcode a3, allcode a4, allcode a5, vsdtrflog trflog,
                         vsdtrflogdtl trflogdtl
                   where rq.objname in ('0047', '0059')
                     and cf.nsdstatus = a1.cdval
                     and a1.cdtype = 'SA'
                     and a1.cdname = 'NSDSTATUS'
                        \*                     and rq.adtxprocess = a2.cdval
                        and a2.cdtype = 'SY'
                        and a2.cdname = 'YESNO'*\
                     and rq.msgstatus = a3.cdval
                     and a3.cdtype = 'RM'
                     and a3.cdname = 'TXMSGSTATUS'
                     and 'N' = a4.cdval
                     and a4.cdtype = 'RM'
                     and a4.cdname = 'FNTYPE'
                     and rq.rqtype = a5.cdval
                     and a5.cdtype = 'RM'
                     and a5.cdname = 'RQTYPE'
                     and (rq.msgstatus in ('C', 'R') \*and rq.boprocess <> 'Y'*\
                         and cf.nsdstatus in ('A', 'P'))
                     and trflog.referenceid = to_char(rq.reqid)
                     and trflogdtl.refautoid = trflog.autoid
                     and trflogdtl.fldname = 'STATUS'
                     and (cf.custodycd = rec0.msgacct or
                         cf.custid = rec0.msgacct)
                     and rq.reqid = pv_reqid)

       loop
        --tx content
        --01    CUSTID     C
        l_txmsg.txfields('01').defname := 'CUSTID';
        l_txmsg.txfields('01').type := 'C';
        l_txmsg.txfields('01').value := rec.custid;
        --03    CUSTODYCD     C
        l_txmsg.txfields('03').defname := 'CUSTODYCD';
        l_txmsg.txfields('03').type := 'C';
        l_txmsg.txfields('03').value := rec.custodycd;
        --05    REQID     C
        l_txmsg.txfields('05').defname := 'REQID';
        l_txmsg.txfields('05').type := 'C';
        l_txmsg.txfields('05').value := rec.reqid;
        --06    REFCODE     C
        l_txmsg.txfields('06').defname := 'REFCODE';
        l_txmsg.txfields('06').type := 'C';
        l_txmsg.txfields('06').value := rec.refcode;
        --08    CONFSTATUS     C
        l_txmsg.txfields('08').defname := 'CONFSTATUS';
        l_txmsg.txfields('08').type := 'C';
        l_txmsg.txfields('08').value := rec.cfstatus; -- COMPLETE
        --09    AUTOID     C
        l_txmsg.txfields('09').defname := 'AUTOID';
        l_txmsg.txfields('09').type := 'C';
        l_txmsg.txfields('09').value := pv_vsdtrfid;
        --11    FNTYPE     C
        l_txmsg.txfields('11').defname := 'FNTYPE';
        l_txmsg.txfields('11').type := 'C';
        l_txmsg.txfields('11').value := rec.fntypeid;
        --12    TXNUM     C
        l_txmsg.txfields('12').defname := 'TXNUM';
        l_txmsg.txfields('12').type := 'C';
        l_txmsg.txfields('12').value := rec.vouchernumber;
        --13    TXDATE     D
        l_txmsg.txfields('13').defname := 'TXDATE';
        l_txmsg.txfields('13').type := 'D';
        l_txmsg.txfields('13').value := rec.voucherdate;
        --15    FULLNAME     C
        l_txmsg.txfields('15').defname := 'FULLNAME';
        l_txmsg.txfields('15').type := 'C';
        l_txmsg.txfields('15').value := rec.fullname;
        --16    IDCODE     C
        l_txmsg.txfields('16').defname := 'IDCODE';
        l_txmsg.txfields('16').type := 'C';
        l_txmsg.txfields('16').value := rec.idcode;
        --17    IDTYPE     C
        l_txmsg.txfields('17').defname := 'IDTYPE';
        l_txmsg.txfields('17').type := 'C';
        l_txmsg.txfields('17').value := rec.idtype;
        --18    ADDRESS     C
        l_txmsg.txfields('18').defname := 'ADDRESS';
        l_txmsg.txfields('18').type := 'C';
        l_txmsg.txfields('18').value := rec.address;
        --19    EXPDATE     D
        l_txmsg.txfields('19').defname := 'EXPDATE';
        l_txmsg.txfields('19').type := 'D';
        l_txmsg.txfields('19').value := rec.idexpired;
        --20    PHONENUMBER     C
        l_txmsg.txfields('20').defname := 'PHONENUMBER';
        l_txmsg.txfields('20').type := 'C';
        l_txmsg.txfields('20').value := rec.phone;
        --21    EMAIL     C
        l_txmsg.txfields('21').defname := 'EMAIL';
        l_txmsg.txfields('21').type := 'C';
        l_txmsg.txfields('21').value := rec.email;
        --22    TIMES     C
        l_txmsg.txfields('22').defname := 'TIMES';
        l_txmsg.txfields('22').type := 'C';
        l_txmsg.txfields('22').value := rec.times;
        --23    RQTYPE     C
        l_txmsg.txfields('23').defname := 'RQTYPE';
        l_txmsg.txfields('23').type := 'C';
        l_txmsg.txfields('23').value := rec.rqtypeid;
        --24    IDDATE     D
        l_txmsg.txfields('24').defname := 'IDDATE';
        l_txmsg.txfields('24').type := 'D';
        l_txmsg.txfields('24').value := rec.iddate;
        --30    DESC     C
        l_txmsg.txfields('30').defname := 'DESC';
        l_txmsg.txfields('30').type := 'C';
        l_txmsg.txfields('30').value := l_strdesc;

        begin
          if txpks_#0048.fn_batchtxprocess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success then
            rollback;
            --  RETURN;
          end if;
        end;
      end loop;
      if nvl(p_err_code, '0') = '0' then
        -- Tr?ng th?CRBTXREQ
        if l_txmsg.txfields('08').value = 'C' then
          update vsdtxreq
             set status = 'C', msgstatus = 'F' --boprocess = 'Y'
           where reqid = pv_reqid;
        else
          update vsdtxreq
             set status = 'R', msgstatus = 'F' --boprocess = 'Y'
           where reqid = pv_reqid;
        end if;

        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      else
        -- neu giao dich loi: danh danh trang thai loi de lam lai bang tay
        update vsdtxreq
           set status = 'E', msgstatus = 'E', boprocess_err = p_err_code
         where reqid = pv_reqid;
        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      end if;

    end loop;
  exception
    when others then
      l_sqlerrnum := substr(sqlerrm, 200);
      insert into log_err
        (id, date_log, position, text)
      values
        (seq_log_err.nextval, sysdate, 'AUTO_CALL_TXPKS_0048', l_sqlerrnum);
  end auto_call_txpks_0048;*/

  procedure auto_call_txpks_2246(pv_reqid number, pv_vsdtrfid NUMBER , busdate DATE, tlid VARCHAR2) as
    l_txmsg       tx.msg_rectype;
    v_strcurrdate varchar2(20);
    l_strdesc     varchar2(400);
    l_tltxcd      varchar2(4);
    p_err_code    number(20);
    l_err_param   varchar2(1000);
    l_sqlerrnum   varchar2(200);
    l_effect_date date;
  BEGIN
    -- Lay ngay hieu luc hach toan TRADDET.98A.ESET tu dien xac nhan cua VSD
    -- FLDNAME la VSDEFFDATE
    begin
      select to_date(fldval, 'YYYYMMDD')
        into l_effect_date
        from vsdtrflogdtl
       where refautoid = pv_vsdtrfid
         and fldname = 'VSDEFFDATE';
    exception
      when others then
        l_effect_date := getcurrdate;
    end;
    --Lay thong tin dien confirm
    for rec0 in (select req.*
                   from vsdtxreq req
                  where /*req.msgstatus in ('C', 'W')
                       --and req.status <> 'C'
                    and*/ req.reqid = pv_reqid) loop

      -- nap giao dich de xu ly
      l_tltxcd       := '2246';
      l_txmsg.tltxcd := l_tltxcd;
      select txdesc into l_strdesc from tltx where tltxcd = l_tltxcd;
      l_txmsg.msgtype := 'T';
      l_txmsg.local   := 'N';
      l_txmsg.tlid    := tlid ;
      select sys_context('USERENV', 'HOST'),
             sys_context('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;
      l_txmsg.off_line  := 'N';
      l_txmsg.deltd     := txnums.c_deltd_txnormal;
      l_txmsg.txstatus  := txstatusnums.c_txcompleted;
      l_txmsg.msgsts    := '0';
      l_txmsg.ovrsts    := '0';
      l_txmsg.batchname := 'DAY';
      l_txmsg.busdate   := busdate;
      l_txmsg.txdate    := getcurrdate;
      select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;
      select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
      l_txmsg.brid := rec0.brid; -- can sua lai them brid trong vsdtxreq de fill lai gt vao day
      for rec in (select distinct fn_get_location(cfmast.brid) location,
                                  sedeposit.senddepodate txdate,
                                  to_char(sedeposit.senddepodate,
                                           'YYYY/MM/DD') txdate1,
                                  a4.cdcontent tradeplace, semast.actype,
                                  semast.acctno, sym.symbol, sym.parvalue,
                                  semast.codeid, semast.afacctno, custodycd,
                                  semast.opndate, semast.clsdate,
                                  semast.lastdate, a1.cdcontent status,
                                  semast.pstatus, a2.cdcontent irtied,
                                  a3.cdcontent iccftied, ircd, costprice,
                                  sedeposit.depositqtty senddeposit,
                                  sedeposit.depositprice depositprice,
                                  sedeposit.description description,
                                  sedeposit.autoid autoid, cfmast.custid,
                                  costdt, sedeposit.senddepodate pdate,
                                  sedeposit.rdate, cfmast.fullname,
                                  cfmast.address, cfmast.idcode, depotrade,
                                  depoblock, a5.cdcontent cd_qttytype,
                                  sedeposit.typedepoblock qttytype,
                                  sedeposit.wtrade wtrade, ci.depolastdt,
                                  (semast.afacctno ||
                                   nvl(sym.refcodeid, sym.codeid)) acctno_updatecost/*, sedeposit.vsdcode*/
                                   ,sedeposit.caqtty011,sedeposit.caqtty021,sedeposit.taxrate011,sedeposit.taxrate021
                    from semast, cfmast, sbsecurities sym, cimast ci,
                         vsdtxreq rq,
                         (select *
                             from sedeposit
                            where status = 'S'
                              and deltd <> 'Y') sedeposit, allcode a1,
                         allcode a2, allcode a3, allcode a4, allcode a5

                   where semast.senddeposit > 0
                     and a1.cdtype = 'SE'
                     and a1.cdname = 'STATUS'
                     and a1.cdval = semast.status
                     and semast.custid = cfmast.custid
                     and a2.cdtype = 'SY'
                     and a2.cdname = 'YESNO'
                     and a2.cdval = irtied
                     and nvl(a5.cdtype, 'SE') = 'SE'
                     and nvl(a5.cdname, 'QTTYTYPE') = 'QTTYTYPE'
                     and sedeposit.typedepoblock = a5.cdval(+)
                     and sym.codeid = semast.codeid
                     and a3.cdtype = 'SY'
                     and a3.cdname = 'YESNO'
                     and a3.cdval = semast.iccftied
                     and a4.cdtype = 'SE'
                     and a4.cdname = 'TRADEPLACE'
                     and a4.cdval = sym.tradeplace
                     and sedeposit.acctno = semast.acctno
                     and semast.afacctno = ci.acctno
                     and rq.refcode = sedeposit.autoid
                     and rq.reqid = pv_reqid
                     and rq.objname = '2241') LOOP
                       plog.ERROR(pkgctx, 'VAO 2');
        --01    CODEID     C
        l_txmsg.txfields('01').defname := 'CODEID';
        l_txmsg.txfields('01').type := 'C';
        l_txmsg.txfields('01').value := rec.codeid;
        --02    AFACCTNO     C
        l_txmsg.txfields('02').defname := 'AFACCTNO';
        l_txmsg.txfields('02').type := 'C';
        l_txmsg.txfields('02').value := rec.afacctno;
        --03    ACCTNO     C
        l_txmsg.txfields('03').defname := 'ACCTNO';
        l_txmsg.txfields('03').type := 'C';
        l_txmsg.txfields('03').value := rec.acctno;
        --04    DEPOBLOCK     N
        l_txmsg.txfields('04').defname := 'DEPOBLOCK';
        l_txmsg.txfields('04').type := 'N';
        l_txmsg.txfields('04').value := rec.depoblock;
        --05    AUTOID     N
        l_txmsg.txfields('05').defname := 'AUTOID';
        l_txmsg.txfields('05').type := 'N';
        l_txmsg.txfields('05').value := rec.autoid;
        --06    DEPOTRADE     N
        l_txmsg.txfields('06').defname := 'DEPOTRADE';
        l_txmsg.txfields('06').type := 'N';
        l_txmsg.txfields('06').value := rec.depotrade;
        --07    PDATE     C
        l_txmsg.txfields('07').defname := 'PDATE';
        l_txmsg.txfields('07').type := 'C';
        l_txmsg.txfields('07').value := rec.pdate;
        --08    QTTYTYPE     C
        l_txmsg.txfields('08').defname := 'QTTYTYPE';
        l_txmsg.txfields('08').type := 'C';
        l_txmsg.txfields('08').value := rec.qttytype;
        --09    DEPOSITPRICE     N
        l_txmsg.txfields('09').defname := 'PRICE';
        l_txmsg.txfields('09').type := 'N';
        l_txmsg.txfields('09').value := rec.depositprice;
        --10    SENDDEPOSIT     N
        l_txmsg.txfields('10').defname := 'QTTY';
        l_txmsg.txfields('10').type := 'N';
        l_txmsg.txfields('10').value := rec.senddeposit;
        --11    PARVALUE     N
        l_txmsg.txfields('11').defname := 'PARVALUE';
        l_txmsg.txfields('11').type := 'N';
        l_txmsg.txfields('11').value := rec.parvalue;
        --12    SQTTY     N
        l_txmsg.txfields('12').defname := 'SQTTY';
        l_txmsg.txfields('12').type := 'N';
        l_txmsg.txfields('12').value := rec.depoblock + rec.depotrade;
        --13    RDATE     D
        l_txmsg.txfields('13').defname := 'RDATE';
        l_txmsg.txfields('13').type := 'D';
        l_txmsg.txfields('13').value := rec.rdate;
        --14    WTRADE     N
        l_txmsg.txfields('14').defname := 'WTRADE';
        l_txmsg.txfields('14').type := 'N';
        l_txmsg.txfields('14').value := rec.wtrade;
        --15   WTRADE     N
        l_txmsg.txfields('15').defname := 'CIDFPOFEEACR';
        l_txmsg.txfields('15').type := 'N';
        l_txmsg.txfields('15').value := FN_CIGETDEPOFEEAMT(rec.afacctno,rec.codeid,l_effect_date,getcurrdate,rec.depoblock + rec.depotrade);
        /*--22    M?SD   C
       l_txmsg.txfields ('22').defname   := 'VSDCODE';
       l_txmsg.txfields ('22').TYPE      := 'C';
       l_txmsg.txfields ('22').value      := rec.VSDCODE;*/
        --ACCTNO_UPDATECOST
        l_txmsg.txfields ('23').defname   := 'ACCTNO_UPDATECOST';
        l_txmsg.txfields ('23').TYPE   := 'C';
        l_txmsg.txfields ('23').VALUE   := REC.acctno_updatecost;
        --30    DESC     C
        l_txmsg.txfields('30').defname := 'DESC';
        l_txmsg.txfields('30').type := 'C';
        l_txmsg.txfields('30').value := l_strdesc;
        --32    DEPOLASTDT     C
        l_txmsg.txfields('32').defname := 'DEPOLASTDT';
        l_txmsg.txfields('32').type := 'C';
        l_txmsg.txfields('32').value := rec.depolastdt;
        --33    DEPOLASTDT     N
        l_txmsg.txfields('33').defname := 'CIDFPOFEEACR';
        l_txmsg.txfields('33').type := 'N';
        l_txmsg.txfields('33').value := FN_CIGETDEPOFEEACR(rec.afacctno,rec.codeid,l_effect_date,getcurrdate,rec.depoblock + rec.depotrade);
        --88    CUSTODYCD     C
        l_txmsg.txfields('88').defname := 'CUSTODYCD';
        l_txmsg.txfields('88').type := 'C';
        l_txmsg.txfields('88').value := rec.custodycd;
        --90    FULLNAME     C
        l_txmsg.txfields('90').defname := 'CUSTNAME';
        l_txmsg.txfields('90').type := 'C';
        l_txmsg.txfields('90').value := rec.fullname;
        --91    ADDRESS     C
        l_txmsg.txfields('91').defname := 'ADDRESS';
        l_txmsg.txfields('91').type := 'C';
        l_txmsg.txfields('91').value := rec.address;
        --92    IDCODE     C
        l_txmsg.txfields('92').defname := 'LICENSE';
        l_txmsg.txfields('92').type := 'C';
        l_txmsg.txfields('92').value := rec.idcode;
        
        --hotfix quyen
        --16   CAQTTY011     N
        l_txmsg.txfields('16').defname := 'CAQTTY011';
        l_txmsg.txfields('16').type := 'N';
        l_txmsg.txfields('16').value := rec.caqtty011;
        
        --17    TAXRATE011     N
        l_txmsg.txfields('17').defname := 'TAXRATE011';
        l_txmsg.txfields('17').type := 'N';
        l_txmsg.txfields('17').value := rec.taxrate011;
        
        --18    CAQTTY021     N
        l_txmsg.txfields('18').defname := 'CAQTTY021';
        l_txmsg.txfields('18').type := 'N';
        l_txmsg.txfields('18').value := rec.caqtty021;
        
        --19    TAXRATE021     N
        l_txmsg.txfields('19').defname := 'TAXRATE021';
        l_txmsg.txfields('19').type := 'N';
        l_txmsg.txfields('19').value := rec.taxrate021;
        --
        begin

          if txpks_#2246.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success then
            rollback;
            --RETURN;
          end if;
        end;
      end loop;
      if nvl(p_err_code, 0) = 0 then
        update vsdtxreq
           set status = 'C', msgstatus = 'F' -- boprocess = 'Y'
         where reqid = pv_reqid;

        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      else
        -- neu giao dich loi: danh danh trang thai loi de lam lai bang tay
        update vsdtxreq
           set status = 'E', msgstatus = 'E', /*boprocess = 'E',*/
               boprocess_err = p_err_code
         where reqid = pv_reqid;
        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      end if;

    end loop;
  exception
    when others then
      l_sqlerrnum := substr(sqlerrm, 200);
      insert into log_err
        (id, date_log, position, text)
      values
        (seq_log_err.nextval, sysdate, 'AUTO_CALL_TXPKS_2246',
         l_sqlerrnum || dbms_utility.format_error_backtrace);
  end auto_call_txpks_2246;

/*  procedure auto_call_txpks_3380(pv_reqid number, pv_vsdtrfid number) as
    l_txmsg       tx.msg_rectype;
    v_strcurrdate varchar2(20);
    l_strdesc     varchar2(400);
    l_tltxcd      varchar2(4);
    p_err_code    number(20);
    l_err_param   varchar2(1000);
    l_sqlerrnum   varchar2(200);

  begin
    --Lay thong tin dien confirm
    for rec0 in (select req.*
                   from vsdtxreq req
                  where req.msgstatus in ('C', 'W')
                       --and req.status <> 'C'
                       --and req.msgstatus = 'W'
                    and req.reqid = pv_reqid) loop

      -- nap giao dich de xu ly
      l_tltxcd       := '3380';
      l_txmsg.tltxcd := l_tltxcd;
      select txdesc into l_strdesc from tltx where tltxcd = l_tltxcd;
      l_txmsg.msgtype := 'T';
      l_txmsg.local   := 'N';
      l_txmsg.tlid    := systemnums.c_system_userid;
      select sys_context('USERENV', 'HOST'),
             sys_context('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;
      l_txmsg.off_line  := 'N';
      l_txmsg.deltd     := txnums.c_deltd_txnormal;
      l_txmsg.txstatus  := txstatusnums.c_txcompleted;
      l_txmsg.msgsts    := '0';
      l_txmsg.ovrsts    := '0';
      l_txmsg.batchname := 'DAY';
      l_txmsg.busdate   := getcurrdate;
      l_txmsg.txdate    := getcurrdate;
      select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;
      select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
      l_txmsg.brid := rec0.brid; -- can sua lai them brid trong vsdtxreq de fill lai gt vao day
      for rec in (select vw.*
                    from v_ca3380 vw, vsdtxreq rq
                   where rq.refcode = vw.autoid
                     and rq.reqid = pv_reqid
                     and rq.objname = '3387') loop
        --01    M??ch CA   C
     l_txmsg.txfields ('01').defname   := 'AUTOID';
     l_txmsg.txfields ('01').TYPE      := 'C';
     l_txmsg.txfields ('01').value      := rec.AUTOID;
--02    M?? ki?n   C
     l_txmsg.txfields ('02').defname   := 'CAMASTID';
     l_txmsg.txfields ('02').TYPE      := 'C';
     l_txmsg.txfields ('02').value      := rec.CAMASTID;
--03    S? Ti?u kho?n   C
     l_txmsg.txfields ('03').defname   := 'AFACCTNO';
     l_txmsg.txfields ('03').TYPE      := 'C';
     l_txmsg.txfields ('03').value      := rec.AFACCTNO;
--04    M?h?ng kho?ph?b?   C
     l_txmsg.txfields ('04').defname   := 'SYMBOL';
     l_txmsg.txfields ('04').TYPE      := 'C';
     l_txmsg.txfields ('04').value      := rec.SYMBOL;
--20    M?h?ng kho?s? h?u   C
     l_txmsg.txfields ('20').defname   := 'SYMBOLDIS';
     l_txmsg.txfields ('20').TYPE      := 'C';
     l_txmsg.txfields ('20').value      := rec.SYMBOLDIS;
--05    Lo?i th?c hi?n   C
     l_txmsg.txfields ('05').defname   := 'CATYPE';
     l_txmsg.txfields ('05').TYPE      := 'C';
     l_txmsg.txfields ('05').value      := rec.CATYPE;
--40    Tr?ng th?  C
     l_txmsg.txfields ('40').defname   := 'STATUS';
     l_txmsg.txfields ('40').TYPE      := 'C';
     l_txmsg.txfields ('40').value      := rec.STATUSCD;
--36    S? TK luu k?   C
     l_txmsg.txfields ('36').defname   := 'CUSTODYCD';
     l_txmsg.txfields ('36').TYPE      := 'C';
     l_txmsg.txfields ('36').value      := rec.CUSTODYCD;
--11    S? lu?ng   N
     l_txmsg.txfields ('11').defname   := 'QTTY';
     l_txmsg.txfields ('11').TYPE      := 'N';
     l_txmsg.txfields ('11').value      := rec.QTTY;
--19    SL? mua kh?n?p ti?n   N
     l_txmsg.txfields ('19').defname   := 'NMQTTY';
     l_txmsg.txfields ('19').TYPE      := 'N';
     l_txmsg.txfields ('19').value      := rec.NMQTTY;
--10    S? ti?n   N
     l_txmsg.txfields ('10').defname   := 'AMT';
     l_txmsg.txfields ('10').TYPE      := 'N';
     l_txmsg.txfields ('10').value      := rec.AMT;
--13    S? lu?ng li?quan   N
     l_txmsg.txfields ('13').defname   := 'AQTTY';
     l_txmsg.txfields ('13').TYPE      := 'N';
     l_txmsg.txfields ('13').value      := rec.AQTTY;
--12    S? ti?n ? mua   N
     l_txmsg.txfields ('12').defname   := 'AAMT';
     l_txmsg.txfields ('12').TYPE      := 'N';
     l_txmsg.txfields ('12').value      := rec.AAMT;
--08    S? TK SE   C
     l_txmsg.txfields ('08').defname   := 'SEACCTNO';
     l_txmsg.txfields ('08').TYPE      := 'C';
     l_txmsg.txfields ('08').value      := rec.SEACCTNO;
--09    S? TK SE li?quan   C
     l_txmsg.txfields ('09').defname   := 'EXSEACCTNO';
     l_txmsg.txfields ('09').TYPE      := 'C';
     l_txmsg.txfields ('09').value      := rec.EXSEACCTNO;
--15    M?nh gi?i?quan   N
     l_txmsg.txfields ('15').defname   := 'EXPARVALUE';
     l_txmsg.txfields ('15').TYPE      := 'N';
     l_txmsg.txfields ('15').value      := rec.EXPARVALUE;
--07    Ng?th?c hi?n quy?n DK   C
     l_txmsg.txfields ('07').defname   := 'ACTIONDATE';
     l_txmsg.txfields ('07').TYPE      := 'C';
     l_txmsg.txfields ('07').value      := rec.ACTIONDATE;
--30    M?   C
     l_txmsg.txfields ('30').defname   := 'DESCRIPTION';
     l_txmsg.txfields ('30').TYPE      := 'C';
     l_txmsg.txfields ('30').value      := rec.DESCRIPTION;
--66    L?KQM   N
     l_txmsg.txfields ('66').defname   := 'ISRIGHTOFF';
     l_txmsg.txfields ('66').TYPE      := 'N';
     l_txmsg.txfields ('66').value      := rec.ISRIGHTOFF;
--21    S? lu?ng hi?n th?   N
     l_txmsg.txfields ('21').defname   := 'TRADE';
     l_txmsg.txfields ('21').TYPE      := 'N';
     l_txmsg.txfields ('21').value      := rec.QTTYDIS;
--06    Ng?dang k? cu?i c?ng   C
     l_txmsg.txfields ('06').defname   := 'REPORTDATE';
     l_txmsg.txfields ('06').TYPE      := 'C';
     l_txmsg.txfields ('06').value      := rec.REPORTDATE;
--22    M?h?ng kho?  C
     l_txmsg.txfields ('22').defname   := 'CODEID';
     l_txmsg.txfields ('22').TYPE      := 'C';
     l_txmsg.txfields ('22').value      := rec.CODEID;
--41    Tr?ng th?m?i   C
     l_txmsg.txfields ('41').defname   := 'NEWSTATUS';
     l_txmsg.txfields ('41').TYPE      := 'C';
     l_txmsg.txfields ('41').value      := 'S';
--14    M?nh gi? N
     l_txmsg.txfields ('14').defname   := 'PARVALUE';
     l_txmsg.txfields ('14').TYPE      := 'N';
     l_txmsg.txfields ('14').value      := rec.parvalue;

        begin

          if txpks_#3380.fn_batchtxprocess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success then
            rollback;
            --RETURN;
          end if;
        end;
      end loop;
      if nvl(p_err_code, 0) = 0 then
        update vsdtxreq
           set status = 'C', msgstatus = 'F' --boprocess = 'Y'
         where reqid = pv_reqid;

        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      else
        -- neu giao dich loi: danh danh trang thai loi de lam lai bang tay
        update vsdtxreq
           set status = 'E', msgstatus = 'E' \*boprocess = 'E'*\,
               boprocess_err = p_err_code
         where reqid = pv_reqid;
        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      end if;

    end loop;
  exception
    when others then
      l_sqlerrnum := substr(sqlerrm, 200);
      insert into log_err
        (id, date_log, position, text)
      values
        (seq_log_err.nextval, sysdate, 'AUTO_CALL_TXPKS_3380',
         l_sqlerrnum || dbms_utility.format_error_backtrace);
  end auto_call_txpks_3380;*/

  procedure auto_call_txpks_2231(pv_reqid number, pv_vsdtrfid number,busdate DATE,tlid VARCHAR2) as
    l_txmsg       tx.msg_rectype;
    v_strcurrdate varchar2(20);
    l_strdesc     varchar2(400);
    l_tltxcd      varchar2(4);
    p_err_code    number(20);
    l_err_param   varchar2(1000);
    l_sqlerrnum   varchar2(200);
    l_status      char(1);
  begin
    plog.setbeginsection(pkgctx, 'auto_call_txpks_2231');

    for rec_debug in (select req.*
                        from vsdtxreq req
                       where req.reqid = pv_reqid) loop
      plog.info(pkgctx,
                'Req:' || pv_reqid || '::msg status' || rec_debug.msgstatus);
    end loop;

    --Lay thong tin dien confirm
    for rec0 in (select req.*
                   from vsdtxreq req
                  where /*req.msgstatus in ('N','R', 'W')*/
                   /* and*/ req.reqid = pv_reqid) loop

      -- nap giao dich de xu ly
      l_tltxcd := '2231';
      plog.info(pkgctx,
                'Req:' || pv_reqid || '::vsdTrfId' || pv_vsdtrfid ||
                'with tltxcd:' || l_tltxcd);

      l_txmsg.tltxcd := l_tltxcd;
      select txdesc into l_strdesc from tltx where tltxcd = l_tltxcd;
      l_txmsg.msgtype := 'T';
      l_txmsg.local   := 'N';
      l_txmsg.tlid    := tlid;
      select sys_context('USERENV', 'HOST'),
             sys_context('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;
      l_txmsg.off_line  := 'N';
      l_txmsg.deltd     := txnums.c_deltd_txnormal;
      l_txmsg.txstatus  := txstatusnums.c_txcompleted;
      l_txmsg.msgsts    := '0';
      l_txmsg.ovrsts    := '0';
      l_txmsg.batchname := 'DAY';
      l_txmsg.busdate   := busdate;
      l_txmsg.txdate    := getcurrdate;
      select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;
      select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
      l_txmsg.brid := rec0.brid; -- can sua lai them brid trong vsdtxreq de fill lai gt vao day

      for rec in (select distinct fn_get_location(cfmast.brid) location,
                                  actype, semast.acctno, sym.symbol,
                                  sym.parvalue, semast.codeid,
                                  semast.afacctno, custodycd, semast.opndate,
                                  clsdate, semast.lastdate,
                                  a1.cdcontent status,
                                  a4.cdcontent tradeplace, semast.pstatus,
                                  a2.cdcontent irtied, a3.cdcontent iccftied,
                                  ircd, costprice,
                                  sedeposit.depositqtty senddeposit,
                                  sedeposit.depotrade, sedeposit.depoblock,
                                  sedeposit.typedepoblock,
                                  sedeposit.depositprice depositprice,
                                  sedeposit.description description,
                                  sedeposit.autoid autoid, cfmast.custid,
                                  costdt, cfmast.fullname custname,
                                  cfmast.address address,
                                  cfmast.idcode license,
                                  sedeposit.senddepodate pdate,
                                  sedeposit.txdate,
                                  sedeposit.typedepoblock qttytype,
                                  sedeposit.depositprice price
                    from semast, cfmast, sbsecurities sym, vsdtxreq rq,
                         (select *
                             from sedeposit
                            where status = 'S'
                              and deltd <> 'Y') sedeposit, allcode a1,
                         allcode a2, allcode a3, allcode a4,
                         (select *
                             from tllog
                            where txstatus = '1'
                              and deltd = 'N'
                              and tltxcd = '2241'
                           union all
                           select *
                             from tllogall
                            where txstatus = '1'
                              and deltd = 'N'
                              and tltxcd = '2241') log
                   where semast.senddeposit > 0
                     and a1.cdtype = 'SE'
                     and a1.cdname = 'STATUS'
                     and a1.cdval = semast.status
                     and semast.custid = cfmast.custid
                     and a2.cdtype = 'SY'
                     and a2.cdname = 'YESNO'
                     and a2.cdval = irtied
                     and sym.codeid = semast.codeid
                     and a3.cdtype = 'SY'
                     and a3.cdname = 'YESNO'
                     and a3.cdval = semast.iccftied
                     and a4.cdtype = 'SE'
                     and a4.cdname = 'TRADEPLACE'
                     and a4.cdval = sym.tradeplace
                     and sedeposit.acctno = semast.acctno
                     and log.msgacct = semast.acctno
                     and rq.refcode = sedeposit.autoid
                     and rq.reqid = pv_reqid) loop
        --01      M?h?ng kho?         C
        l_txmsg.txfields('01').defname := 'CODEID   ';
        l_txmsg.txfields('01').type := 'C';
        l_txmsg.txfields('01').value := rec.codeid;
        --02      S? Ti?u kho?n           C
        l_txmsg.txfields('02').defname := 'AFACCTNO ';
        l_txmsg.txfields('02').type := 'C';
        l_txmsg.txfields('02').value := rec.afacctno;
        --03      S? t?kho?n            C
        l_txmsg.txfields('03').defname := 'ACCTNO   ';
        l_txmsg.txfields('03').type := 'C';
        l_txmsg.txfields('03').value := rec.acctno;
        --04      S? CK HCCN              N
        l_txmsg.txfields('04').defname := 'DEPOBLOCK';
        l_txmsg.txfields('04').type := 'N';
        l_txmsg.txfields('04').value := rec.depoblock;
        --05      S? t? t?ng              N
        l_txmsg.txfields('05').defname := 'AUTOID   ';
        l_txmsg.txfields('05').type := 'N';
        l_txmsg.txfields('05').value := rec.autoid;
        --06      S? CK TDCN              N
        l_txmsg.txfields('06').defname := 'DEPOTRADE';
        l_txmsg.txfields('06').type := 'N';
        l_txmsg.txfields('06').value := rec.depotrade;
        --07      Posted date             C
        l_txmsg.txfields('07').defname := 'PDATE    ';
        l_txmsg.txfields('07').type := 'C';
        l_txmsg.txfields('07').value := rec.pdate;
        --08      Lo?i ?i?u ki?n          C
        l_txmsg.txfields('08').defname := 'QTTYTYPE ';
        l_txmsg.txfields('08').type := 'C';
        l_txmsg.txfields('08').value := rec.qttytype;
        --09      Gi??n                 N
        l_txmsg.txfields('09').defname := 'PRICE    ';
        l_txmsg.txfields('09').type := 'N';
        l_txmsg.txfields('09').value := rec.price;
        --10      S? l??ng                N
        l_txmsg.txfields('10').defname := 'QTTY     ';
        l_txmsg.txfields('10').type := 'N';
        l_txmsg.txfields('10').value := rec.depoblock + rec.depotrade;
        --11      M?nh gi?              N
        l_txmsg.txfields('11').defname := 'PARVALUE ';
        l_txmsg.txfields('11').type := 'N';
        l_txmsg.txfields('11').value := rec.parvalue;
        --30      M?                   C
        l_txmsg.txfields('30').defname := 'DESC     ';
        l_txmsg.txfields('30').type := 'C';
        l_txmsg.txfields('30').value := l_strdesc;
        --90      H? t?                 C
        l_txmsg.txfields('90').defname := 'CUSTNAME ';
        l_txmsg.txfields('90').type := 'C';
        l_txmsg.txfields('90').value := rec.custname;
        --91      ??a ch?                 C
        l_txmsg.txfields('91').defname := 'ADDRESS  ';
        l_txmsg.txfields('91').type := 'C';
        l_txmsg.txfields('91').value := rec.address;
        --92      CMND/GPKD               C
        l_txmsg.txfields('92').defname := 'LICENSE  ';
        l_txmsg.txfields('92').type := 'C';
        l_txmsg.txfields('92').value := rec.license;

        begin
          if txpks_#2231.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success then
            rollback;
          end if;
        end;
      end loop;

        if nvl(p_err_code, 0) = 0 THEN
        update vsdtxreq
           set status = 'R', msgstatus = 'R' --boprocess = 'Y'
         where reqid = pv_reqid;
        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid; --l_txmsg.txfields('09').value;
      else
        -- neu giao dich loi: danh danh trang thai loi de lam lai bang tay
        update vsdtxreq
           set status = 'E', msgstatus = 'E'
               --boprocess = 'E'
              , boprocess_err = p_err_code
         where reqid = pv_reqid;
        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      end if;

    end loop;
    plog.setendsection(pkgctx, 'auto_call_txpks_2231');
  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'auto_call_txpks_2231');
  end auto_call_txpks_2231;

  procedure auto_call_txpks_2294(pv_reqid number, pv_vsdtrfid number,busdate DATE, tlid VARCHAR2) as
    l_txmsg       tx.msg_rectype;
    v_strcurrdate varchar2(20);
    l_strdesc     varchar2(400);
    l_tltxcd      varchar2(4);
    p_err_code    varchar2(20);
    l_err_param   varchar2(20);
    l_sqlerrnum   varchar2(200);
  begin
    plog.setbeginsection(pkgctx, 'auto_call_txpks_2294');
    --Lay thong tin dien confirm
    for rec0 in (select req.*
                   from vsdtxreq req
                  where /*req.msgstatus in ('N', 'R', 'W')*/
                       --and req.status <> 'C'
                       --and req.msgstatus = 'W'
                     req.reqid = pv_reqid) loop

      -- nap giao dich de xu ly
      l_tltxcd       := '2294';
      l_txmsg.tltxcd := l_tltxcd;
      select txdesc into l_strdesc from tltx where tltxcd = l_tltxcd;
      l_txmsg.msgtype := 'T';
      l_txmsg.local   := 'N';
      l_txmsg.tlid    := tlid;
      select sys_context('USERENV', 'HOST'),
             sys_context('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;
      l_txmsg.off_line  := 'N';
      l_txmsg.deltd     := txnums.c_deltd_txnormal;
      l_txmsg.txstatus  := txstatusnums.c_txcompleted;
      l_txmsg.msgsts    := '0';
      l_txmsg.ovrsts    := '0';
      l_txmsg.batchname := 'DAY';
      l_txmsg.busdate   := busdate;
      l_txmsg.txdate    := getcurrdate;
      select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;
      select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
      l_txmsg.brid := rec0.brid; -- can sua lai them brid trong vsdtxreq de fill lai gt vao day
      for rec in (select distinct semast.acctno, sym.symbol, semast.afacctno,
                                  sewd.withdraw withdraw, semast.codeid,
                                  sym.parvalue, seinfo.basicprice price,
                                  cf.idcode license, cf.idplace licenseplace,
                                  iddate licensedate, cf.address,
                                  semast.lastdate selastdate,
                                  af.lastdate aflastdate,
                                  nvl(semast.lastdate, af.lastdate) lastdate,
                                  cf.custodycd, a1.cdcontent tradeplace,
                                  cf.fullname, sewd.txdate, sewd.txnum,
                                  sewd.txdatetxnum/*, sewd.BLOCKWITHDRAW,
                                  SEWD.WITHDRAW+SEWD.BLOCKWITHDRAW sumqtty*/
                    from semast, sbsecurities sym, afmast af, cfmast cf,
                         allcode a1, securities_info seinfo,
                         sewithdrawdtl sewd, vsdtxreq rq
                   where sym.codeid = seinfo.codeid
                     and a1.cdtype = 'SA'
                     and a1.cdname = 'TRADEPLACE'
                     and a1.cdval = sym.tradeplace
                     and cf.custid = af.custid
                     and sym.codeid = semast.codeid
                     and semast.afacctno = af.acctno
                     and (semast.withdraw > 0/* OR SEMAST.BLOCKWITHDRAW > 0*/)
                     and semast.acctno = sewd.acctno
                     and sewd.status = 'A'
                     and rq.refcode = sewd.txdatetxnum
                     and rq.reqid = pv_reqid
                     ) loop
        --05    Ng?TH GD xin r?t   D
     l_txmsg.txfields ('05').defname   := 'TXDATE';
     l_txmsg.txfields ('05').TYPE      := 'D';
     l_txmsg.txfields ('05').value      := rec.TXDATE;
--06    S? CT c?a GD xin r?t   C
     l_txmsg.txfields ('06').defname   := 'TXNUM';
     l_txmsg.txfields ('06').TYPE      := 'C';
     l_txmsg.txfields ('06').value      := rec.TXNUM;
--04    M?h?ng kho?  C
     l_txmsg.txfields ('04').defname   := 'SYMBOL';
     l_txmsg.txfields ('04').TYPE      := 'C';
     l_txmsg.txfields ('04').value      := rec.SYMBOL;
--90    H? t?  C
     l_txmsg.txfields ('90').defname   := 'CUSTNAME';
     l_txmsg.txfields ('90').TYPE      := 'C';
     l_txmsg.txfields ('90').value      := rec.FULLNAME;
--02    S? Ti?u kho?n   C
     l_txmsg.txfields ('02').defname   := 'AFACCTNO';
     l_txmsg.txfields ('02').TYPE      := 'C';
     l_txmsg.txfields ('02').value      := rec.AFACCTNO;
--03    T?kho?n ch?ng kho?  C
     l_txmsg.txfields ('03').defname   := 'ACCTNO';
     l_txmsg.txfields ('03').TYPE      := 'C';
     l_txmsg.txfields ('03').value      := rec.ACCTNO;
--10    KL ch?ng kho?xin r?t   N
     l_txmsg.txfields ('10').defname   := 'AMT';
     l_txmsg.txfields ('10').TYPE      := 'N';
     l_txmsg.txfields ('10').value      := rec.WITHDRAW;
/*--14    KL ch?ng kho?hccn xin r?t   N
     l_txmsg.txfields ('14').defname   := 'BLOCKWITHDRAW';
     l_txmsg.txfields ('14').TYPE      := 'N';
     l_txmsg.txfields ('14').value      := rec.BLOCKWITHDRAW;*/
/*--55    T?ng KL ch?ng kho?xin r?t   N
     l_txmsg.txfields ('55').defname   := 'SUMQTTY';
     l_txmsg.txfields ('55').TYPE      := 'N';
     l_txmsg.txfields ('55').value      := rec.SUMQTTY;*/
--07    Key   C
     l_txmsg.txfields ('07').defname   := 'TXDATETXNUM';
     l_txmsg.txfields ('07').TYPE      := 'C';
     l_txmsg.txfields ('07').value      := rec.TXDATETXNUM;
--92    CMND/GPKD   C
     l_txmsg.txfields ('92').defname   := 'LICENSE';
     l_txmsg.txfields ('92').TYPE      := 'C';
     l_txmsg.txfields ('92').value      := rec.LICENSE;
--95    Ng?c?p   D
     l_txmsg.txfields ('95').defname   := 'LICENSEDATE';
     l_txmsg.txfields ('95').TYPE      := 'D';
     l_txmsg.txfields ('95').value      := rec.LICENSEDATE;
--97    ?a ch?   C
     l_txmsg.txfields ('97').defname   := 'ADDRESS';
     l_txmsg.txfields ('97').TYPE      := 'C';
     l_txmsg.txfields ('97').value      := rec.address;
--30    Di?n gi?i   C
     l_txmsg.txfields ('30').defname   := 'DESC';
     l_txmsg.txfields ('30').TYPE      := 'C';
     l_txmsg.txfields ('30').value      := 'Hủy xác nhận xin rút chứng khoán do TT từ chối';


        begin
          if txpks_#2294.fn_batchtxprocess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success then
            rollback;
          end if;
        end;
      end loop;

        if nvl(p_err_code, 0) = 0 THEN

            update vsdtxreq
               set status = 'R', msgstatus = 'R' --boprocess = 'Y'
             where reqid = pv_reqid;

          -- Tr?ng th?VSDTRFLOG
          update vsdtrflog
             set status = 'C', timeprocess = systimestamp
           where autoid = pv_vsdtrfid; -- l_txmsg.txfields('09').value;
        else
          -- neu giao dich loi: danh danh trang thai loi de lam lai bang tay
          update vsdtxreq
             set status = 'E', msgstatus = 'E'
                 --boprocess = 'E'
                , boprocess_err = p_err_code
           where reqid = pv_reqid;
          -- Tr?ng th?VSDTRFLOG
          update vsdtrflog
             set status = 'C', timeprocess = systimestamp
           where autoid = pv_vsdtrfid;
        end if;
    end loop;
    plog.setendsection(pkgctx, 'auto_call_txpks_2294');
  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'auto_call_txpks_2294');
  end auto_call_txpks_2294;

  procedure auto_call_txpks_2201(pv_reqid number, pv_vsdtrfid NUMBER ,busdate DATE, tlid VARCHAR2) as
    l_txmsg       tx.msg_rectype;
    v_strcurrdate varchar2(20);
    l_strdesc     varchar2(400);
    l_tltxcd      varchar2(4);
    p_err_code    number(20);
    l_err_param   varchar2(1000);
    l_sqlerrnum   varchar2(200);
    l_effect_date date;
  BEGIN
    -- Lay ngay hieu luc hach toan TRADDET.98A.ESET tu dien xac nhan cua VSD
    -- FLDNAME la VSDEFFDATE
    begin
      select to_date(fldval, 'YYYYMMDD')
        into l_effect_date
        from vsdtrflogdtl
       where refautoid = pv_vsdtrfid
         and fldname = 'VSDEFFDATE';
    exception
      when others then
        l_effect_date := getcurrdate;
    end;

    --Lay thong tin dien confirm
    for rec0 in (select req.*
                   from vsdtxreq req
                  where /*req.msgstatus in ('C', 'W')
                    and req.status <> 'C'*/
                       --and req.msgstatus = 'W'
                     req.reqid = pv_reqid) loop

      -- nap giao dich de xu ly
      l_tltxcd       := '2201';
      l_txmsg.tltxcd := l_tltxcd;
      select txdesc into l_strdesc from tltx where tltxcd = l_tltxcd;
      l_txmsg.msgtype := 'T';
      l_txmsg.local   := 'N';
      l_txmsg.tlid    := tlid;
      select sys_context('USERENV', 'HOST'),
             sys_context('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;
      l_txmsg.off_line  := 'N';
      l_txmsg.deltd     := txnums.c_deltd_txnormal;
      l_txmsg.txstatus  := txstatusnums.c_txcompleted;
      l_txmsg.msgsts    := '0';
      l_txmsg.ovrsts    := '0';
      l_txmsg.batchname := 'DAY';
      l_txmsg.busdate   := busdate;
      l_txmsg.txdate    := getcurrdate;
      select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;
      select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
      l_txmsg.brid := rec0.brid; -- can sua lai them brid trong vsdtxreq de fill lai gt vao day
      for rec in (select distinct fn_get_location(af.brid) location,
                                  semast.acctno, sym.symbol, semast.afacctno,
                                  sewd.withdraw withdraw,/* sewd.blockwithdraw, */semast.codeid,/*sewd.withdraw + sewd.blockwithdraw sumqtty,*/
                                  sym.parvalue, sewd.price price, cf.fullname,
                                  cf.idcode license, cf.iddate, cf.idplace,
                                  cf.address, semast.lastdate selastdate,
                                  af.lastdate aflastdate,
                                  confirmtxdate lastdate, cf.custodycd,
                                  a1.cdcontent tradeplace, sewd.txdatetxnum,
                                  sewd.txdate, sewd.txnum,
                                  semast.acctno acctno_updatecost,ISSU.fullname ISSFULLNAME
                    from semast, sbsecurities sym, afmast af, cfmast cf,
                         allcode a1, securities_info seinfo,
                         sewithdrawdtl sewd, sbsecurities sb, vsdtxreq rq,
                         ISSUERS ISSU
                   where sym.codeid = seinfo.codeid
                   AND SYM.ISSUERID = ISSU.ISSUERID(+)
                     and a1.cdtype = 'SE'
                     and a1.cdname = 'TRADEPLACE'
                     and a1.cdval = sym.tradeplace
                     and cf.custid = af.custid
                     and sym.codeid = semast.codeid
                     and semast.afacctno = af.acctno
                     and (semast.withdraw > 0/* OR SEMAST.BLOCKWITHDRAW > 0*/)
                     and semast.acctno = sewd.acctno
                     and sewd.status = 'A'
                     and seinfo.codeid = sb.codeid
                     and rq.refcode = sewd.txdatetxnum
                     and rq.reqid = pv_reqid) loop
        p_err_code := 0;
        --05    Ng?TH GD xin r?t   D
     l_txmsg.txfields ('05').defname   := 'TXDATE';
     l_txmsg.txfields ('05').TYPE      := 'D';
     l_txmsg.txfields ('05').value      := rec.TXDATE;
--06    S? CT c?a GD xin r?t   C
     l_txmsg.txfields ('06').defname   := 'TXNUM';
     l_txmsg.txfields ('06').TYPE      := 'C';
     l_txmsg.txfields ('06').value      := rec.TXNUM;
--01    M?h?ng kho?  C
     l_txmsg.txfields ('01').defname   := 'CODEID';
     l_txmsg.txfields ('01').TYPE      := 'C';
     l_txmsg.txfields ('01').value      := rec.CODEID;
--02    S? Ti?u kho?n   C
     l_txmsg.txfields ('02').defname   := 'AFACCTNO';
     l_txmsg.txfields ('02').TYPE      := 'C';
     l_txmsg.txfields ('02').value      := rec.AFACCTNO;
--03    S? ti?u kho?n ch?ng kho?  C
     l_txmsg.txfields ('03').defname   := 'ACCTNO';
     l_txmsg.txfields ('03').TYPE      := 'C';
     l_txmsg.txfields ('03').value      := rec.ACCTNO;
--10    S? lu?ng   N
     l_txmsg.txfields ('10').defname   := 'AMT';
     l_txmsg.txfields ('10').TYPE      := 'N';
     l_txmsg.txfields ('10').value      := rec.WITHDRAW;
/*--14    S? lu?ng r?t HCCN    N
     l_txmsg.txfields ('14').defname   := 'BLOCKWITHDRAW';
     l_txmsg.txfields ('14').TYPE      := 'N';
     l_txmsg.txfields ('14').value      := rec.BLOCKWITHDRAW;*/
/*--55    T?ng KL ch?ng kho?xin r?t   N
     l_txmsg.txfields ('55').defname   := 'SUMQTTY';
     l_txmsg.txfields ('55').TYPE      := 'N';
     l_txmsg.txfields ('55').value      := rec.SUMQTTY;*/
--11    M?nh gi? N
     l_txmsg.txfields ('11').defname   := 'PARVALUE';
     l_txmsg.txfields ('11').TYPE      := 'N';
     l_txmsg.txfields ('11').value      := rec.PARVALUE;
--09    Gi? N
     l_txmsg.txfields ('09').defname   := 'PRICE';
     l_txmsg.txfields ('09').TYPE      := 'N';
     l_txmsg.txfields ('09').value      := rec.PRICE;
--07    Key   C
     l_txmsg.txfields ('07').defname   := 'TXDATETXNUM';
     l_txmsg.txfields ('07').TYPE      := 'C';
     l_txmsg.txfields ('07').value      := rec.TXDATETXNUM;
--90    H? t?  C
     l_txmsg.txfields ('90').defname   := 'CUSTNAME';
     l_txmsg.txfields ('90').TYPE      := 'C';
     l_txmsg.txfields ('90').value      := rec.FULLNAME;
--91    ?a ch?   C
     l_txmsg.txfields ('91').defname   := 'ADDRESS';
     l_txmsg.txfields ('91').TYPE      := 'C';
     l_txmsg.txfields ('91').value      := rec.ADDRESS;
--92    CMND/GPKD   C
     l_txmsg.txfields ('92').defname   := 'LICENSE';
     l_txmsg.txfields ('92').TYPE      := 'C';
     l_txmsg.txfields ('92').value      := rec.LICENSE;
--95    Ng?c?p   D
     l_txmsg.txfields ('95').defname   := 'LICENSEDATE';
     l_txmsg.txfields ('95').TYPE      := 'D';
     l_txmsg.txfields ('95').value      := rec.IDDATE;
/*--36    Chi nh?   C
     l_txmsg.txfields ('36').defname   := 'BRNAME';
     l_txmsg.txfields ('36').TYPE      := 'C';
     l_txmsg.txfields ('36').value      := '';*/
/*--35    T?ngu?i d?t l?nh   C
     l_txmsg.txfields ('35').defname   := 'TLFULLNAME';
     l_txmsg.txfields ('35').TYPE      := 'C';
     l_txmsg.txfields ('35').value      := rec.FULLNAME;*/
/*--37    T?c?ty   C
     l_txmsg.txfields ('37').defname   := 'ISSUERSNAME';
     l_txmsg.txfields ('37').TYPE      := 'C';
     l_txmsg.txfields ('37').value      := rec.ISSFULLNAME;*/
--30    Di?n gi?i   C
     l_txmsg.txfields ('30').defname   := 'DESC';
     l_txmsg.txfields ('30').TYPE      := 'C';
     l_txmsg.txfields ('30').value      := l_strdesc;
--96    Noi c?p   C
     l_txmsg.txfields ('96').defname   := 'LICENSEPLACE';
     l_txmsg.txfields ('96').TYPE      := 'C';
     l_txmsg.txfields ('96').value      := rec.idplace;
/*--29    S? s? c? d?  C
     l_txmsg.txfields ('29').defname   := 'SSCD';
     l_txmsg.txfields ('29').TYPE      := 'C';
     l_txmsg.txfields ('29').value      := '';*/
--12  SO TK UPDATE GIA VON
      l_txmsg.txfields ('12').defname   := 'ACCTNO_UPDATECOST';
      l_txmsg.txfields ('12').TYPE   := 'C';
      l_txmsg.txfields ('12').VALUE   := REC.acctno_updatecost;
        begin
          if txpks_#2201.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success then
            rollback;
          end if;
        end;
      end loop;

      if nvl(p_err_code, 0) = 0 then
        update vsdtxreq
           set status = 'C', msgstatus = 'F' --boprocess = 'Y'
         where reqid = pv_reqid;

        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;

      else
        -- neu giao dich loi: danh danh trang thai loi de lam lai bang tay
        update vsdtxreq
           set status = 'E', msgstatus = 'E'
               --boprocess = 'E'
              , boprocess_err = p_err_code
         where reqid = pv_reqid;
        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      end if;

    end loop;
  exception
    when others then
      l_sqlerrnum := substr(sqlerrm, 200);
      insert into log_err
        (id, date_log, position, text)
      values
        (seq_log_err.nextval, sysdate, 'AUTO_CALL_TXPKS_2201', l_sqlerrnum);
  end auto_call_txpks_2201;

  procedure auto_call_txpks_2266(pv_reqid number, pv_vsdtrfid number,busdate DATE, tlid VARCHAR2) as
    l_txmsg       tx.msg_rectype;
    v_strcurrdate varchar2(20);
    l_strdesc     varchar2(400);
    l_tltxcd      varchar2(4);
    p_err_code    number(20);
    l_err_param   varchar2(1000);
    l_sqlerrnum   varchar2(200);
    l_effect_date date;
    l_messagetype VARCHAR2(10);
  begin
    plog.setbeginsection(pkgctx, 'auto_call_txpks_2266');
    -- Lay ngay hieu luc hach toan TRADDET.98A.ESET tu dien xac nhan cua VSD
    -- FLDNAME la VSDEFFDATE
    begin
      select to_date(fldval, 'YYYYMMDD')
        into l_effect_date
        from vsdtrflogdtl
       where refautoid = pv_vsdtrfid
         and fldname = 'VSDEFFDATE';
    exception
      when others then
        l_effect_date := getcurrdate;
    end;

    --Lay thong tin dien confirm
     for rec0 in (select req.*, cf.custodycd, SUBSTR(req.trfcode,0,3) msgtype
                   from vsdtxreq req, cfmast cf, afmast af
                  where /*req.msgstatus in ('C', 'W')*/
                     req.boprocess = 'N'
                       --and req.status <> 'C'
                       --and req.msgstatus = 'W'
                    AND cf.custid = af.custid
                    AND af.acctno = req.afacctno
                    and req.reqid = pv_reqid) loop

      -- nap giao dich de xu ly
      l_tltxcd       := '2266';
      l_txmsg.tltxcd := l_tltxcd;
      select txdesc into l_strdesc from tltx where tltxcd = l_tltxcd;
      l_txmsg.msgtype := 'T';
      l_txmsg.local   := 'N';
      l_txmsg.tlid    := tlid;
      select sys_context('USERENV', 'HOST'),
             sys_context('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;
      l_txmsg.off_line  := 'N';
      l_txmsg.deltd     := txnums.c_deltd_txnormal;
      l_txmsg.txstatus  := txstatusnums.c_txcompleted;
      l_txmsg.msgsts    := '0';
      l_txmsg.ovrsts    := '0';
      l_txmsg.batchname := 'DAY';
      l_txmsg.busdate   := busdate;
      l_txmsg.txdate    := getcurrdate;
      /*select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;*/
      select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
      l_txmsg.brid := rec0.brid; -- can sua lai them brid trong vsdtxreq de fill lai gt vao day

      plog.debug(pkgctx, 'l_txmsg.txnum:' || l_txmsg.txnum);
      IF rec0.msgtype = '542' THEN
        BEGIN
      for rec in (select seo.autoid, seo.txnum, seo.txdate, seo.acctno, seo.trade, seo.blocked, seo.caqtty,
                         seo.strade, seo.sblocked, seo.scaqtty, seo.ctrade, seo.cblocked, seo.ccaqtty,
                         seo.recustodycd, seo.recustname, seo.deltd,
                         seo.status, seo.codeid, seo.price, seo.outward, seo.id2255,
                         seo.trtype, seo.qttytype,seo.vsdmessagetype, cf.fullname, cf.custodycd, af.acctno afacctno,
                         sec.symbol, se.costprice, seo.acctno acctno_updatecost,
                         seo.srightoffqtty, seo.Scaamtreceiv, seo.Scaqttydb, seo.srightqtty, seo.Scaqttyreceiv
                   from sesendout seo, cfmast cf, afmast af,
                         sbsecurities sec, semast se, vsdtxreq rq
                   where substr(seo.acctno, 0, 10) = af.acctno
                     and af.custid = cf.custid
                     and sec.codeid = seo.codeid
                     and se.acctno = seo.acctno
                     and seo.strade + seo.sblocked + seo.scaqtty + seo.srightoffqtty + seo.scaqttyreceiv + seo.scaqttydb + seo.scaamtreceiv + seo.srightqtty > 0
                     and deltd = 'N'
                     and rq.refcode = seo.autoid
                     and rq.reqid = pv_reqid
                     AND seo.vsdmessagetype = '542'
                  ) LOOP

        select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;

        --15    S? TKCK update gi??n   C
        l_txmsg.txfields('15').defname := 'ACCTNO_UPDATECOST';
        l_txmsg.txfields('15').type := 'C';
        l_txmsg.txfields('15').value := rec.acctno_updatecost;
        --16    T?ng s? lu?ng   N
        l_txmsg.txfields('16').defname := 'PRICE';
        l_txmsg.txfields('16').type := 'N';
        l_txmsg.txfields('16').value := rec.price;
        --18    AUTOID   N
        l_txmsg.txfields('18').defname := 'AUTOID';
        l_txmsg.txfields('18').type := 'N';
        l_txmsg.txfields('18').value := rec.autoid;
        --05    S? LK   C
        l_txmsg.txfields('05').defname := 'CUSTODYCD';
        l_txmsg.txfields('05').type := 'C';
        l_txmsg.txfields('05').value := rec.custodycd;
        --02    S? TK ghi N?   C
        l_txmsg.txfields('02').defname := 'AFACCTNO';
        l_txmsg.txfields('02').type := 'C';
        l_txmsg.txfields('02').value := rec.afacctno;
        --03    S? TK CK ghi N?   C
        l_txmsg.txfields('03').defname := 'ACCTNO';
        l_txmsg.txfields('03').type := 'C';
        l_txmsg.txfields('03').value := rec.acctno;
        --90    H? t?  C
        l_txmsg.txfields('90').defname := 'CUSTNAME';
        l_txmsg.txfields('90').type := 'C';
        l_txmsg.txfields('90').value := rec.fullname;
        --07    Ch?ng kho?  C
        l_txmsg.txfields('07').defname := 'SYMBOL';
        l_txmsg.txfields('07').type := 'C';
        l_txmsg.txfields('07').value := rec.symbol;
        --01    M?h?ng kho?  C
        l_txmsg.txfields('01').defname := 'CODEID';
        l_txmsg.txfields('01').type := 'C';
        l_txmsg.txfields('01').value := rec.codeid;
        --10    S? lu?ng giao d?ch   N
        l_txmsg.txfields('10').defname := 'TRADE';
        l_txmsg.txfields('10').type := 'N';
        l_txmsg.txfields('10').value := rec.strade;
        --06    S? lu?ng CK phong t?a   N
        l_txmsg.txfields('06').defname := 'BLOCKED';
        l_txmsg.txfields('06').type := 'N';
        l_txmsg.txfields('06').value := rec.sblocked;
        --13    S? lu?ng CK CA   N
        l_txmsg.txfields('13').defname := 'CAQTTY';
        l_txmsg.txfields('13').type := 'N';
        l_txmsg.txfields('13').value := rec.scaqtty;
        --23    S? LK ngu?i nh?n   C
        l_txmsg.txfields('23').defname := 'RECUSTODYCD';
        l_txmsg.txfields('23').type := 'C';
        l_txmsg.txfields('23').value := rec.recustodycd;
        --24    T?ngu?i nh?n   C
        l_txmsg.txfields('24').defname := 'RECUSTNAME';
        l_txmsg.txfields('24').type := 'C';
        l_txmsg.txfields('24').value := rec.recustname;
        --12    T?ng s? lu?ng   N
        l_txmsg.txfields('12').defname := 'QTTY';
        l_txmsg.txfields('12').type := 'N';
        l_txmsg.txfields('12').value := rec.sblocked + rec.strade;
        --14    Lo?i di?u ki?n   C
        l_txmsg.txfields('14').defname := 'QTTYTYPE';
        l_txmsg.txfields('14').type := 'C';
        l_txmsg.txfields('14').value := '002';
        --30    Di?n gi?i   C
        l_txmsg.txfields('30').defname := 'DESC';
        l_txmsg.txfields('30').type := 'C';
        l_txmsg.txfields('30').value := l_strdesc;

        --RIGHTQTTY
        l_txmsg.txfields ('19').defname   := 'RIGHTQTTY';
        l_txmsg.txfields ('19').TYPE   := 'N';
        l_txmsg.txfields ('19').VALUE   := REC.SRIGHTQTTY;
        --RIGHTOFFQTTY
        l_txmsg.txfields ('20').defname   := 'RIGHTOFFQTTY';
        l_txmsg.txfields ('20').TYPE   := 'N';
        l_txmsg.txfields ('20').VALUE   := REC.SRIGHTOFFQTTY;
        --CAQTTYRECEIV
        l_txmsg.txfields ('21').defname   := 'CAQTTYRECEIV';
        l_txmsg.txfields ('21').TYPE   := 'N';
        l_txmsg.txfields ('21').VALUE   := REC.SCAQTTYRECEIV;
        --CAQTTYDB
        l_txmsg.txfields ('22').defname   := 'CAQTTYDB';
        l_txmsg.txfields ('22').TYPE   := 'N';
        l_txmsg.txfields ('22').VALUE   := REC.SCAQTTYDB;
        --CAAMTRECEIV
        l_txmsg.txfields ('17').defname   := 'CAAMTRECEIV';
        l_txmsg.txfields ('17').TYPE   := 'N';
        l_txmsg.txfields ('17').VALUE   := REC.SCAAMTRECEIV;
          --VSDMESSAGETYPE
        l_txmsg.txfields ('97').defname   := 'VSDMESSAGETYPE';
        l_txmsg.txfields ('97').TYPE   := 'C';
        l_txmsg.txfields ('97').VALUE   := REC.VSDMESSAGETYPE;
        begin
          if txpks_#2266.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success then
            rollback;
          end if;
        end;
      end loop;
      END;
      ELSIF rec0.msgtype = '598' THEN
        BEGIN
      for rec in (select seo.autoid, seo.txnum, seo.txdate, seo.acctno, seo.trade, seo.blocked, seo.caqtty,
                         seo.strade, seo.sblocked, seo.scaqtty, seo.ctrade, seo.cblocked, seo.ccaqtty,
                         seo.recustodycd, seo.recustname, seo.deltd,
                         seo.status, seo.codeid, seo.price, seo.outward, seo.id2255,
                         seo.trtype, seo.qttytype,seo.vsdmessagetype, cf.fullname, cf.custodycd, af.acctno afacctno,
                         sec.symbol, se.costprice, seo.acctno acctno_updatecost,
                         seo.srightoffqtty, seo.Scaamtreceiv, seo.Scaqttydb, seo.srightqtty, seo.Scaqttyreceiv
                   from sesendout seo, cfmast cf, afmast af,
                         sbsecurities sec, semast se
                   where substr(seo.acctno, 0, 10) = af.acctno
                     and af.custid = cf.custid
                     and sec.codeid = seo.codeid
                     and se.acctno = seo.acctno
                     and seo.strade + seo.sblocked + seo.scaqtty + seo.srightoffqtty + seo.scaqttyreceiv + seo.scaqttydb + seo.scaamtreceiv + seo.srightqtty > 0
                     and deltd = 'N'
                     and cf.custodycd = rec0.custodycd
                     AND seo.vsdmessagetype <> '0'
                  ) LOOP

        select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;

        --15    S? TKCK update gi??n   C
        l_txmsg.txfields('15').defname := 'ACCTNO_UPDATECOST';
        l_txmsg.txfields('15').type := 'C';
        l_txmsg.txfields('15').value := rec.acctno_updatecost;
        --16    T?ng s? lu?ng   N
        l_txmsg.txfields('16').defname := 'PRICE';
        l_txmsg.txfields('16').type := 'N';
        l_txmsg.txfields('16').value := rec.price;
        --18    AUTOID   N
        l_txmsg.txfields('18').defname := 'AUTOID';
        l_txmsg.txfields('18').type := 'N';
        l_txmsg.txfields('18').value := rec.autoid;
        --05    S? LK   C
        l_txmsg.txfields('05').defname := 'CUSTODYCD';
        l_txmsg.txfields('05').type := 'C';
        l_txmsg.txfields('05').value := rec.custodycd;
        --02    S? TK ghi N?   C
        l_txmsg.txfields('02').defname := 'AFACCTNO';
        l_txmsg.txfields('02').type := 'C';
        l_txmsg.txfields('02').value := rec.afacctno;
        --03    S? TK CK ghi N?   C
        l_txmsg.txfields('03').defname := 'ACCTNO';
        l_txmsg.txfields('03').type := 'C';
        l_txmsg.txfields('03').value := rec.acctno;
        --90    H? t?  C
        l_txmsg.txfields('90').defname := 'CUSTNAME';
        l_txmsg.txfields('90').type := 'C';
        l_txmsg.txfields('90').value := rec.fullname;
        --07    Ch?ng kho?  C
        l_txmsg.txfields('07').defname := 'SYMBOL';
        l_txmsg.txfields('07').type := 'C';
        l_txmsg.txfields('07').value := rec.symbol;
        --01    M?h?ng kho?  C
        l_txmsg.txfields('01').defname := 'CODEID';
        l_txmsg.txfields('01').type := 'C';
        l_txmsg.txfields('01').value := rec.codeid;
        --10    S? lu?ng giao d?ch   N
        l_txmsg.txfields('10').defname := 'TRADE';
        l_txmsg.txfields('10').type := 'N';
        l_txmsg.txfields('10').value := rec.strade;
        --06    S? lu?ng CK phong t?a   N
        l_txmsg.txfields('06').defname := 'BLOCKED';
        l_txmsg.txfields('06').type := 'N';
        l_txmsg.txfields('06').value := rec.sblocked;
        --13    S? lu?ng CK CA   N
        l_txmsg.txfields('13').defname := 'CAQTTY';
        l_txmsg.txfields('13').type := 'N';
        l_txmsg.txfields('13').value := rec.scaqtty;
        --23    S? LK ngu?i nh?n   C
        l_txmsg.txfields('23').defname := 'RECUSTODYCD';
        l_txmsg.txfields('23').type := 'C';
        l_txmsg.txfields('23').value := rec.recustodycd;
        --24    T?ngu?i nh?n   C
        l_txmsg.txfields('24').defname := 'RECUSTNAME';
        l_txmsg.txfields('24').type := 'C';
        l_txmsg.txfields('24').value := rec.recustname;
        --12    T?ng s? lu?ng   N
        l_txmsg.txfields('12').defname := 'QTTY';
        l_txmsg.txfields('12').type := 'N';
        l_txmsg.txfields('12').value := rec.sblocked + rec.strade;
        --14    Lo?i di?u ki?n   C
        l_txmsg.txfields('14').defname := 'QTTYTYPE';
        l_txmsg.txfields('14').type := 'C';
        l_txmsg.txfields('14').value := '002';
        --30    Di?n gi?i   C
        l_txmsg.txfields('30').defname := 'DESC';
        l_txmsg.txfields('30').type := 'C';
        l_txmsg.txfields('30').value := l_strdesc;
         --RIGHTQTTY
        l_txmsg.txfields ('19').defname   := 'RIGHTQTTY';
        l_txmsg.txfields ('19').TYPE   := 'N';
        l_txmsg.txfields ('19').VALUE   := REC.SRIGHTQTTY;
        --RIGHTOFFQTTY
        l_txmsg.txfields ('20').defname   := 'RIGHTOFFQTTY';
        l_txmsg.txfields ('20').TYPE   := 'N';
        l_txmsg.txfields ('20').VALUE   := REC.SRIGHTOFFQTTY;
        --CAQTTYRECEIV
        l_txmsg.txfields ('21').defname   := 'CAQTTYRECEIV';
        l_txmsg.txfields ('21').TYPE   := 'N';
        l_txmsg.txfields ('21').VALUE   := REC.SCAQTTYRECEIV;
        --CAQTTYDB
        l_txmsg.txfields ('22').defname   := 'CAQTTYDB';
        l_txmsg.txfields ('22').TYPE   := 'N';
        l_txmsg.txfields ('22').VALUE   := REC.SCAQTTYDB;
        --CAAMTRECEIV
        l_txmsg.txfields ('17').defname   := 'CAAMTRECEIV';
        l_txmsg.txfields ('17').TYPE   := 'N';
        l_txmsg.txfields ('17').VALUE   := REC.SCAAMTRECEIV;
          --VSDMESSAGETYPE
        l_txmsg.txfields ('97').defname   := 'VSDMESSAGETYPE';
        l_txmsg.txfields ('97').TYPE   := 'C';
        l_txmsg.txfields ('97').VALUE   := REC.VSDMESSAGETYPE;
        begin
          if txpks_#2266.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success then
            rollback;
          end if;
        end;
      end loop;
      END;
      END IF;

      if nvl(p_err_code, 0) = 0 then
        update vsdtxreq
           set status = 'C', msgstatus = 'F' --boprocess = 'Y'
         where reqid = pv_reqid;

        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;

      else
        -- neu giao dich loi: danh danh trang thai loi de lam lai bang tay
        update vsdtxreq
           set status = 'E', msgstatus = 'E'
               --boprocess = 'E'
              , boprocess_err = p_err_code
         where reqid = pv_reqid;
        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      end if;

    end loop;
    plog.setendsection(pkgctx, 'auto_call_txpks_2266');
  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'auto_call_txpks_2266');
  end auto_call_txpks_2266;

  procedure auto_call_txpks_2265(pv_reqid number, pv_vsdtrfid number,busdate DATE, tlid VARCHAR2) as
    l_txmsg       tx.msg_rectype;
    v_strcurrdate varchar2(20);
    l_strdesc     varchar2(400);
    l_tltxcd      varchar2(4);
    p_err_code    number(20);
    l_err_param   varchar2(1000);
    l_sqlerrnum   varchar2(200);
  begin
    --Lay thong tin dien confirm
    for rec0 in (select req.*, cf.custodycd, SUBSTR(req.trfcode,0,3) msgtype
                   from vsdtxreq req, cfmast cf, afmast af
                  where /*req.msgstatus in ('N', 'R', 'W')*/
                     req.boprocess = 'N'
                       --and req.status <> 'C'
                       --and req.msgstatus = 'W'
                    AND cf.custid = af.custid
                    AND af.acctno = req.afacctno
                    and req.reqid = pv_reqid) loop

      -- nap giao dich de xu ly
      l_tltxcd       := '2265';
      l_txmsg.tltxcd := l_tltxcd;
      select txdesc into l_strdesc from tltx where tltxcd = l_tltxcd;
      l_txmsg.msgtype := 'T';
      l_txmsg.local   := 'N';
      l_txmsg.tlid    := tlid;
      select sys_context('USERENV', 'HOST'),
             sys_context('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;
      l_txmsg.off_line  := 'N';
      l_txmsg.deltd     := txnums.c_deltd_txnormal;
      l_txmsg.txstatus  := txstatusnums.c_txcompleted;
      l_txmsg.msgsts    := '0';
      l_txmsg.ovrsts    := '0';
      l_txmsg.batchname := 'DAY';
      l_txmsg.busdate   := busdate;
      l_txmsg.txdate    := getcurrdate;

      select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
      l_txmsg.brid := rec0.brid; -- can sua lai them brid trong vsdtxreq de fill lai gt vao day
      --DungDT: neu la dien tu choi cua 598 thi revert toan bo giao dich cua tk
      IF rec0.msgtype = '598' THEN
        BEGIN
      for rec in (select seo.autoid, seo.txnum, seo.txdate, seo.acctno, seo.trade, seo.blocked, seo.caqtty,
                         seo.strade, seo.sblocked, seo.scaqtty, seo.ctrade, seo.cblocked, seo.ccaqtty,
                         seo.recustodycd, seo.recustname, seo.deltd,
                         seo.status, seo.codeid, seo.price, seo.outward, seo.id2255,
                         seo.trtype, seo.qttytype,seo.vsdmessagetype, cf.fullname, cf.custodycd, af.acctno afacctno,
                         sec.symbol, se.costprice,
                         seo.srightoffqtty, seo.Scaamtreceiv, seo.Scaqttydb, seo.srightqtty, seo.Scaqttyreceiv
                   from sesendout seo, cfmast cf, afmast af,
                         sbsecurities sec, semast se
                   where substr(seo.acctno, 0, 10) = af.acctno
                     and af.custid = cf.custid
                     and sec.codeid = seo.codeid
                     and se.acctno = seo.acctno
                     and seo.strade + seo.sblocked + seo.scaqtty + seo.srightoffqtty + seo.scaqttyreceiv + seo.scaqttydb + seo.scaamtreceiv + seo.srightqtty > 0
                     and deltd = 'N'
                     and cf.custodycd = rec0.custodycd
                     AND seo.vsdmessagetype = rec0.msgtype
                     ) LOOP
        select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;
        --01    M? ch?ng kho?n   C
        l_txmsg.txfields('01').defname := 'CODEID';
        l_txmsg.txfields('01').type := 'C';
        l_txmsg.txfields('01').value := rec.codeid;
        --02    S? TK ghi N?   C
        l_txmsg.txfields('02').defname := 'AFACCTNO';
        l_txmsg.txfields('02').type := 'C';
        l_txmsg.txfields('02').value := rec.afacctno;
        --03    S? TK CK ghi N?   C
        l_txmsg.txfields('03').defname := 'ACCTNO';
        l_txmsg.txfields('03').type := 'C';
        l_txmsg.txfields('03').value := rec.acctno;
        --05    S? LK   C
        l_txmsg.txfields('05').defname := 'CUSTODYCD';
        l_txmsg.txfields('05').type := 'C';
        l_txmsg.txfields('05').value := rec.custodycd;
        --06    S? lu?ng CK phong t?a   N
        l_txmsg.txfields('06').defname := 'BLOCKED';
        l_txmsg.txfields('06').type := 'N';
        l_txmsg.txfields('06').value := rec.sblocked;
        --07    Ch?ng kho?n   C
        l_txmsg.txfields('07').defname := 'SYMBOL';
        l_txmsg.txfields('07').type := 'C';
        l_txmsg.txfields('07').value := rec.symbol;
        --10    S? lu?ng giao d?ch   N
        l_txmsg.txfields('10').defname := 'TRADE';
        l_txmsg.txfields('10').type := 'N';
        l_txmsg.txfields('10').value := rec.strade;
        --12    T?ng s? lu?ng   N
        l_txmsg.txfields('12').defname := 'QTTY';
        l_txmsg.txfields('12').type := 'N';
        l_txmsg.txfields('12').value := rec.strade + rec.sblocked;
        --13    S? lu?ng CK CA   N
        l_txmsg.txfields('13').defname := 'CAQTTY';
        l_txmsg.txfields('13').type := 'N';
        l_txmsg.txfields('13').value := rec.scaqtty;
        --18    AUTOID   N
        l_txmsg.txfields('18').defname := 'AUTOID';
        l_txmsg.txfields('18').type := 'N';
        l_txmsg.txfields('18').value := rec.autoid;
        --23    S? LK ngu?i nh?n   C
        l_txmsg.txfields('23').defname := 'RECUSTODYCD';
        l_txmsg.txfields('23').type := 'C';
        l_txmsg.txfields('23').value := rec.recustodycd;
        --24    T?n ngu?i nh?n   C
        l_txmsg.txfields('24').defname := 'RECUSTNAME';
        l_txmsg.txfields('24').type := 'C';
        l_txmsg.txfields('24').value := rec.recustname;
        --30    Di?n gi?i   C
        l_txmsg.txfields('30').defname := 'DESC';
        l_txmsg.txfields('30').type := 'C';
        l_txmsg.txfields('30').value := l_strdesc;
        --90    H? t?n   C
        l_txmsg.txfields('90').defname := 'CUSTNAME';
        l_txmsg.txfields('90').type := 'C';
        l_txmsg.txfields('90').value := rec.fullname;
        --RIGHTOFFQTTY
        l_txmsg.txfields ('14').defname   := 'RIGHTOFFQTTY';
        l_txmsg.txfields ('14').TYPE   := 'N';
        l_txmsg.txfields ('14').VALUE   := REC.SRIGHTOFFQTTY;
        --CAQTTYRECEIV
        l_txmsg.txfields ('15').defname   := 'CAQTTYRECEIV';
        l_txmsg.txfields ('15').TYPE   := 'N';
        l_txmsg.txfields ('15').VALUE   := REC.SCAQTTYRECEIV;
        --CAQTTYDB
        l_txmsg.txfields ('16').defname   := 'CAQTTYDB';
        l_txmsg.txfields ('16').TYPE   := 'N';
        l_txmsg.txfields ('16').VALUE   := REC.SCAQTTYDB;
        --CAAMTRECEIV
        l_txmsg.txfields ('17').defname   := 'CAAMTRECEIV';
        l_txmsg.txfields ('17').TYPE   := 'N';
        l_txmsg.txfields ('17').VALUE   := REC.SCAAMTRECEIV;
        --RIGHTQTTY
        l_txmsg.txfields ('19').defname   := 'RIGHTQTTY';
        l_txmsg.txfields ('19').TYPE   := 'N';
        l_txmsg.txfields ('19').VALUE   := REC.SRIGHTQTTY;
          --VSDMESSAGETYPE
        l_txmsg.txfields ('97').defname   := 'VSDMESSAGETYPE';
        l_txmsg.txfields ('97').TYPE   := 'C';
        l_txmsg.txfields ('97').VALUE   := REC.VSDMESSAGETYPE;
        begin
          if txpks_#2265.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success then
            rollback;
          end if;
        end;
      end loop;
      END;
      ELSIF rec0.msgtype = '542' THEN
        BEGIN
         for rec in (select seo.autoid, seo.txnum, seo.txdate, seo.acctno, seo.trade, seo.blocked, seo.caqtty,
                         seo.strade, seo.sblocked, seo.scaqtty, seo.ctrade, seo.cblocked, seo.ccaqtty,
                         seo.recustodycd, seo.recustname, seo.deltd,
                         seo.status, seo.codeid, seo.price, seo.outward, seo.id2255,
                         seo.trtype, seo.qttytype,seo.vsdmessagetype, cf.fullname, cf.custodycd, af.acctno afacctno,
                         sec.symbol, se.costprice,
                         seo.srightoffqtty, seo.Scaamtreceiv, seo.Scaqttydb, seo.srightqtty, seo.Scaqttyreceiv
                   from sesendout seo, cfmast cf, afmast af,
                         sbsecurities sec, semast se, vsdtxreq rq
                   where substr(seo.acctno, 0, 10) = af.acctno
                     and af.custid = cf.custid
                     and sec.codeid = seo.codeid
                     and se.acctno = seo.acctno
                     and seo.strade + seo.sblocked + seo.scaqtty + seo.srightoffqtty + seo.scaqttyreceiv + seo.scaqttydb + seo.scaamtreceiv + seo.srightqtty > 0
                     and deltd = 'N'
                     and rq.refcode = seo.autoid
                     and rq.reqid = pv_reqid
                     ) LOOP
        select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;
        --01    M?h?ng kho?  C
        l_txmsg.txfields('01').defname := 'CODEID';
        l_txmsg.txfields('01').type := 'C';
        l_txmsg.txfields('01').value := rec.codeid;
        --02    S? TK ghi N?   C
        l_txmsg.txfields('02').defname := 'AFACCTNO';
        l_txmsg.txfields('02').type := 'C';
        l_txmsg.txfields('02').value := rec.afacctno;
        --03    S? TK CK ghi N?   C
        l_txmsg.txfields('03').defname := 'ACCTNO';
        l_txmsg.txfields('03').type := 'C';
        l_txmsg.txfields('03').value := rec.acctno;
        --05    S? LK   C
        l_txmsg.txfields('05').defname := 'CUSTODYCD';
        l_txmsg.txfields('05').type := 'C';
        l_txmsg.txfields('05').value := rec.custodycd;
        --06    S? lu?ng CK phong t?a   N
        l_txmsg.txfields('06').defname := 'BLOCKED';
        l_txmsg.txfields('06').type := 'N';
        l_txmsg.txfields('06').value := rec.sblocked;
        --07    Ch?ng kho?  C
        l_txmsg.txfields('07').defname := 'SYMBOL';
        l_txmsg.txfields('07').type := 'C';
        l_txmsg.txfields('07').value := rec.symbol;
        --10    S? lu?ng giao d?ch   N
        l_txmsg.txfields('10').defname := 'TRADE';
        l_txmsg.txfields('10').type := 'N';
        l_txmsg.txfields('10').value := rec.strade;
        --12    T?ng s? lu?ng   N
        l_txmsg.txfields('12').defname := 'QTTY';
        l_txmsg.txfields('12').type := 'N';
        l_txmsg.txfields('12').value := rec.strade + rec.sblocked;
        --13    S? lu?ng CK CA   N
        l_txmsg.txfields('13').defname := 'CAQTTY';
        l_txmsg.txfields('13').type := 'N';
        l_txmsg.txfields('13').value := rec.scaqtty;
        --18    AUTOID   N
        l_txmsg.txfields('18').defname := 'AUTOID';
        l_txmsg.txfields('18').type := 'N';
        l_txmsg.txfields('18').value := rec.autoid;
        --23    S? LK ngu?i nh?n   C
        l_txmsg.txfields('23').defname := 'RECUSTODYCD';
        l_txmsg.txfields('23').type := 'C';
        l_txmsg.txfields('23').value := rec.recustodycd;
        --24    T?ngu?i nh?n   C
        l_txmsg.txfields('24').defname := 'RECUSTNAME';
        l_txmsg.txfields('24').type := 'C';
        l_txmsg.txfields('24').value := rec.recustname;
        --30    Di?n gi?i   C
        l_txmsg.txfields('30').defname := 'DESC';
        l_txmsg.txfields('30').type := 'C';
        l_txmsg.txfields('30').value := l_strdesc;
        --90    H? t?  C
        l_txmsg.txfields('90').defname := 'CUSTNAME';
        l_txmsg.txfields('90').type := 'C';
        l_txmsg.txfields('90').value := rec.fullname;

        --RIGHTOFFQTTY
        l_txmsg.txfields ('14').defname   := 'RIGHTOFFQTTY';
        l_txmsg.txfields ('14').TYPE   := 'N';
        l_txmsg.txfields ('14').VALUE   := REC.SRIGHTOFFQTTY;
        --CAQTTYRECEIV
        l_txmsg.txfields ('15').defname   := 'CAQTTYRECEIV';
        l_txmsg.txfields ('15').TYPE   := 'N';
        l_txmsg.txfields ('15').VALUE   := REC.SCAQTTYRECEIV;
        --CAQTTYDB
        l_txmsg.txfields ('16').defname   := 'CAQTTYDB';
        l_txmsg.txfields ('16').TYPE   := 'N';
        l_txmsg.txfields ('16').VALUE   := REC.SCAQTTYDB;
        --CAAMTRECEIV
        l_txmsg.txfields ('17').defname   := 'CAAMTRECEIV';
        l_txmsg.txfields ('17').TYPE   := 'N';
        l_txmsg.txfields ('17').VALUE   := REC.SCAAMTRECEIV;

        --RIGHTQTTY
        l_txmsg.txfields ('19').defname   := 'RIGHTQTTY';
        l_txmsg.txfields ('19').TYPE   := 'N';
        l_txmsg.txfields ('19').VALUE   := REC.SRIGHTQTTY;
          --VSDMESSAGETYPE
        l_txmsg.txfields ('97').defname   := 'VSDMESSAGETYPE';
        l_txmsg.txfields ('97').TYPE   := 'C';
        l_txmsg.txfields ('97').VALUE   := REC.VSDMESSAGETYPE;
        begin
          if txpks_#2265.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success then
            rollback;
          end if;
        end;
      end loop;
      END;
      END IF;
      if nvl(p_err_code, 0) = 0 then
        update vsdtxreq
           set status = 'R', msgstatus = 'R' --boprocess = 'Y'
         where reqid = pv_reqid;

        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid; -- l_txmsg.txfields('09').value;
      else
        -- neu giao dich loi: danh danh trang thai loi de lam lai bang tay
        update vsdtxreq
           set status = 'E', msgstatus = 'E'
               --boprocess = 'E'
              , boprocess_err = p_err_code
         where reqid = pv_reqid;
        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      end if;

    end loop;
  exception
    when others then
      l_sqlerrnum := substr(sqlerrm, 200);
      insert into log_err
        (id, date_log, position, text)
      values
        (seq_log_err.nextval, sysdate, 'AUTO_CALL_TXPKS_2265',
         l_sqlerrnum || dbms_utility.format_error_backtrace);
  end auto_call_txpks_2265;

  procedure auto_call_txpks_8816(pv_reqid number, pv_vsdtrfid number,busdate DATE, tlid VARCHAR2) as
    l_txmsg       tx.msg_rectype;
    v_strcurrdate varchar2(20);
    l_strdesc     varchar2(400);
    l_tltxcd      varchar2(4);
    p_err_code    number(20);
    l_err_param   varchar2(1000);
    l_sqlerrnum   varchar2(200);
  begin
    --Lay thong tin dien confirm
    for rec0 in (select req.*--, rl.funcname
                   from vsdtxreq req--, vsdtrflog rl
                  where /*req.msgstatus in ('N', 'R', 'W')*/
                       --and req.status <> 'C'
                       --and req.msgstatus = 'W'
                     req.reqid = pv_reqid
                    /*AND req.reqid = rl.referenceid*/)
    loop

      -- nap giao dich de xu ly
      l_tltxcd       := '8816';
      l_txmsg.tltxcd := l_tltxcd;
      select txdesc into l_strdesc from tltx where tltxcd = l_tltxcd;
      l_txmsg.msgtype := 'T';
      l_txmsg.local   := 'N';
      l_txmsg.tlid    := tlid;
      select sys_context('USERENV', 'HOST'),
             sys_context('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;
      l_txmsg.off_line  := 'N';
      l_txmsg.deltd     := txnums.c_deltd_txnormal;
      l_txmsg.txstatus  := txstatusnums.c_txcompleted;
      l_txmsg.msgsts    := '0';
      l_txmsg.ovrsts    := '0';
      l_txmsg.batchname := 'DAY';
      l_txmsg.busdate   := busdate;
      l_txmsg.txdate    := getcurrdate;
      select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;
      select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
      l_txmsg.brid := rec0.brid; -- can sua lai them brid trong vsdtxreq de fill lai gt vao day
      for rec in (

                  select fn_get_location(af.brid) location, cf.custodycd,
                          c.codeid, c.symbol, c.parvalue, a.afacctno, b.*,
                          cf.idcode, a4.cdcontent tradeplace
                    from semast a, seretail b, sbsecurities c, afmast af,
                          cfmast cf, allcode a4, vsdtxreq rq
                   where a.acctno = b.acctno
                     and a.codeid = c.codeid
                     and b.qtty > 0
                     and b.status = 'S'
                     and af.acctno = a.afacctno
                     and af.custid = cf.custid
                     and a4.cdtype = 'SE'
                     and a4.cdname = 'TRADEPLACE'
                     and a4.cdval = c.tradeplace
                     and rq.refcode = b.txnum
                     and rq.reqid = pv_reqid
     ) loop
        --03    S? t?kho?n SE   C
        l_txmsg.txfields('03').defname := 'SEACCTNO';
        l_txmsg.txfields('03').type := 'C';
        l_txmsg.txfields('03').value := rec.afacctno;
        --04    Ng?l?p Ti?u kho?n   D
        l_txmsg.txfields('04').defname := 'TXDATE';
        l_txmsg.txfields('04').type := 'D';
        l_txmsg.txfields('04').value := rec.txdate;
        --12    Lo?i di?u ki?n   N
        l_txmsg.txfields('12').defname := 'PARVALUE';
        l_txmsg.txfields('12').type := 'N';
        l_txmsg.txfields('12').value := rec.parvalue;
        --05    S? giao d?ch   C
        l_txmsg.txfields('05').defname := 'TXNUM';
        l_txmsg.txfields('05').type := 'C';
        l_txmsg.txfields('05').value := rec.txnum;
        --30    M?   C
        l_txmsg.txfields('30').defname := 'DESC';
        l_txmsg.txfields('30').type := 'C';
        l_txmsg.txfields('30').value := l_strdesc;
        --02    S? Ti?u kho?n b?  C
        l_txmsg.txfields('02').defname := 'AFACCTNO';
        l_txmsg.txfields('02').type := 'C';
        l_txmsg.txfields('02').value := rec.afacctno;
        --01    M?h?ng kho?  C
        l_txmsg.txfields('01').defname := 'CODEID';
        l_txmsg.txfields('01').type := 'C';
        l_txmsg.txfields('01').value := rec.codeid;
        --11    Gi? N
        l_txmsg.txfields('11').defname := 'QUOTEPRICE';
        l_txmsg.txfields('11').type := 'N';
        l_txmsg.txfields('11').value := rec.price;
        --10    Kh?i lu?ng   N
        l_txmsg.txfields('10').defname := 'ORDERQTTY';
        l_txmsg.txfields('10').type := 'N';
        l_txmsg.txfields('10').value := rec.qtty;

        begin
          if txpks_#8816.fn_batchtxprocess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success then
            rollback;
          end if;
        end;
      end loop;
      if nvl(p_err_code, 0) = 0 then
        update vsdtxreq
           set status = 'R', msgstatus = 'R' --boprocess = 'Y'
         where reqid = pv_reqid;

        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      else
        -- neu giao dich loi: danh danh trang thai loi de lam lai bang tay
        update vsdtxreq
           set status = 'E', msgstatus = 'E'
               --boprocess = 'E'
              , boprocess_err = p_err_code
         where reqid = pv_reqid;
        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      end if;

    end loop;
  exception
    when others then
      l_sqlerrnum := substr(sqlerrm, 200);
      insert into log_err
        (id, date_log, position, text)
      values
        (seq_log_err.nextval, sysdate, 'AUTO_CALL_TXPKS_8816',
         l_sqlerrnum || dbms_utility.format_error_backtrace);
  end auto_call_txpks_8816;

/*  procedure auto_call_txpks_8894(pv_reqid number, pv_vsdtrfid number) as
    l_txmsg       tx.msg_rectype;
    v_strcurrdate varchar2(20);
    l_strdesc     varchar2(400);
    l_tltxcd      varchar2(4);
    p_err_code    number(20);
    l_err_param   varchar2(1000);
    l_sqlerrnum   varchar2(200);
    l_effect_date date;
  BEGIN
    -- Lay ngay hieu luc hach toan TRADDET.98A.ESET tu dien xac nhan cua VSD
    -- FLDNAME la VSDEFFDATE
    begin
      select to_date(fldval, 'YYYYMMDD')
        into l_effect_date
        from vsdtrflogdtl
       where refautoid = pv_vsdtrfid
         and fldname = 'VSDEFFDATE';
    exception
      when others then
        l_effect_date := getcurrdate;
    end;

    --Lay thong tin dien confirm
    for rec0 in (select req.*
                   from vsdtxreq req
                  where req.msgstatus in ('C', 'W')
                       --and req.status <> 'C'
                       --and req.msgstatus = 'W'
                    and req.reqid = pv_reqid) loop

      -- nap giao dich de xu ly
      l_tltxcd       := '8894';
      l_txmsg.tltxcd := l_tltxcd;
      select txdesc into l_strdesc from tltx where tltxcd = l_tltxcd;
      l_txmsg.msgtype := 'T';
      l_txmsg.local   := 'N';
      l_txmsg.tlid    := systemnums.c_system_userid;
      select sys_context('USERENV', 'HOST'),
             sys_context('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;
      l_txmsg.off_line  := 'N';
      l_txmsg.deltd     := txnums.c_deltd_txnormal;
      l_txmsg.txstatus  := txstatusnums.c_txcompleted;
      l_txmsg.msgsts    := '0';
      l_txmsg.ovrsts    := '0';
      l_txmsg.batchname := 'DAY';
      l_txmsg.busdate   := l_effect_date;
      l_txmsg.txdate    := getcurrdate;
      select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;
      select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
      l_txmsg.brid := rec0.brid; -- can sua lai them brid trong vsdtxreq de fill lai gt vao day
      for rec in (select cf.custodycd, substr(b.desacctno, 1, 10) afddi,
                         c.codeid, c.symbol, c.parvalue, a.afacctno, b.txdate,
                         b.txnum, b.acctno, b.price, b.qtty, b.status,
                         b.desacctno, b.feeamt, b.taxamt, b.sdate, b.vdate,
                         cf.idcode, a4.cdcontent tradeplace,
                         case
                           when ci.corebank = 'Y' then
                            0
                           else
                            1
                         end iscorebank,
                          b.qtty *
                                b.price / 100 *
                                (select to_number(varvalue)
                                   from sysvar
                                  where varname = 'ADVSELLDUTY') tax,
                         ci.depolastdt, nvl(pit.qtty, 0) pitqtty,
                         nvl(pit.aright, 0) pitamt2, cf.fullname,
                         to_char(b.txdate, 'dd/mm/yyyy') || b.txnum accref
                    from semast a, seretail b, sbsecurities c, afmast af,
                         cfmast cf, allcode a4, aftype afty, cimast ci,
                         vsdtxreq rq,
                         (select orgorderid orderid, sum(qtty) qtty,
                                  sum(aright) aright
                             from sepitallocate
                            group by orgorderid) pit
                   where a.acctno = b.acctno
                     and a.codeid = c.codeid
                     and b.qtty > 0
                     and b.status = 'I'
                     and af.acctno = a.afacctno
                     and af.custid = cf.custid
                     and a4.cdtype = 'SE'
                     and a4.cdname = 'TRADEPLACE'
                     and a4.cdval = c.tradeplace
                     and af.actype = afty.actype
                     and af.acctno = ci.acctno
                     and to_char(b.txdate, 'DDMMRRRR') || b.txnum =
                         pit.orderid(+)
                     and rq.refcode = b.txnum
                     and rq.reqid = pv_reqid) loop
        --06    S? tham chi?u   C
        l_txmsg.txfields('06').defname := 'ACCREF';
        l_txmsg.txfields('06').type := 'C';
        l_txmsg.txfields('06').value := rec.accref;
        --30    Di?n gi?i   C
        l_txmsg.txfields('30').defname := 'DESC';
        l_txmsg.txfields('30').type := 'C';
        l_txmsg.txfields('30').value := '';
        --88    S? TK luu k? b?  C
        l_txmsg.txfields('88').defname := 'CUSTODYCD';
        l_txmsg.txfields('88').type := 'C';
        l_txmsg.txfields('88').value := rec.custodycd;
        --02    S? TK b?  C
        l_txmsg.txfields('02').defname := 'AFACCTNO';
        l_txmsg.txfields('02').type := 'C';
        l_txmsg.txfields('02').value := rec.afacctno;
        --03    S? TK SE  b?  C
        l_txmsg.txfields('03').defname := 'SEACCTNO';
        l_txmsg.txfields('03').type := 'C';
        l_txmsg.txfields('03').value := rec.acctno;
        --10    Kh?i lu?ng   N
        l_txmsg.txfields('10').defname := 'ORDERQTTY';
        l_txmsg.txfields('10').type := 'N';
        l_txmsg.txfields('10').value := rec.qtty;
        --19    Thu? b?CK quy?n   N
        l_txmsg.txfields('19').defname := 'PITAMT';
        l_txmsg.txfields('19').type := 'N';
        l_txmsg.txfields('19').value := rec.pitamt2;
        --14    Thu?   N
        l_txmsg.txfields('14').defname := 'TAX';
        l_txmsg.txfields('14').type := 'N';
        l_txmsg.txfields('14').value := rec.tax;
        --18    CK quy?n   N
        l_txmsg.txfields('18').defname := 'PITQTTY';
        l_txmsg.txfields('18').type := 'N';
        l_txmsg.txfields('18').value := rec.pitqtty;
        --04    Ng?l?p Ti?u kho?n   C
        l_txmsg.txfields('04').defname := 'TXDATE';
        l_txmsg.txfields('04').type := 'C';
        l_txmsg.txfields('04').value := rec.txdate;
        --05    S? ch?ng t?   C
        l_txmsg.txfields('05').defname := 'TXNUM';
        l_txmsg.txfields('05').type := 'C';
        l_txmsg.txfields('05').value := rec.txnum;
        --11    Gi? N
        l_txmsg.txfields('11').defname := 'QUOTEPRICE';
        l_txmsg.txfields('11').type := 'N';
        l_txmsg.txfields('11').value := rec.price;
        --01    M?h?ng kho?  C
        l_txmsg.txfields('01').defname := 'CODEID';
        l_txmsg.txfields('01').type := 'C';
        l_txmsg.txfields('01').value := rec.codeid;
        --12    M?nh gi? N
        l_txmsg.txfields('12').defname := 'PARVALUE';
        l_txmsg.txfields('12').type := 'N';
        l_txmsg.txfields('12').value := rec.parvalue;
        --07    S? TK mua   C
        l_txmsg.txfields('07').defname := 'AFACCTNO2';
        l_txmsg.txfields('07').type := 'C';
        l_txmsg.txfields('07').value := rec.afddi;
        --22    Ph?D l?   N
        l_txmsg.txfields('22').defname := 'FEEAMT';
        l_txmsg.txfields('22').type := 'N';
        l_txmsg.txfields('22').value := rec.feeamt;
        --60    L?K ng?h?   N
        l_txmsg.txfields('60').defname := 'ISCOREBANK';
        l_txmsg.txfields('60').type := 'N';
        l_txmsg.txfields('60').value := rec.iscorebank;
        --90    H? t?  C
        l_txmsg.txfields('90').defname := 'CUSTNAME';
        l_txmsg.txfields('90').type := 'C';
        l_txmsg.txfields('90').value := rec.fullname;
        --08    S?TK SE  mua   C
        l_txmsg.txfields('08').defname := 'SEACCTNO2';
        l_txmsg.txfields('08').type := 'C';
        l_txmsg.txfields('08').value := rec.acctno;
        --15    Thu? TNCN   N
        l_txmsg.txfields('15').defname := 'TAXAMT';
        l_txmsg.txfields('15').type := 'N';
        l_txmsg.txfields('15').value := rec.taxamt;
        begin
          if txpks_#8894.fn_batchtxprocess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success then
            rollback;
          end if;
        end;
      end loop;

      if nvl(p_err_code, 0) = 0 then
        update vsdtxreq
           set status = 'C', msgstatus = 'F' --boprocess = 'Y'
         where reqid = pv_reqid;

        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;

      else
        -- neu giao dich loi: danh danh trang thai loi de lam lai bang tay
        update vsdtxreq
           set status = 'E', msgstatus = 'E'
               --boprocess = 'E'
              , boprocess_err = p_err_code
         where reqid = pv_reqid;
        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      end if;

    end loop;
  exception
    when others then
      l_sqlerrnum := substr(sqlerrm, 200);
      insert into log_err
        (id, date_log, position, text)
      values
        (seq_log_err.nextval, sysdate, 'AUTO_CALL_TXPKS_8894',
         l_sqlerrnum || dbms_utility.format_error_backtrace);
  end auto_call_txpks_8894;*/

  procedure auto_call_txpks_8879(pv_reqid number, pv_vsdtrfid number,busdate DATE, tlid VARCHAR2) as
    l_txmsg       tx.msg_rectype;
    v_strcurrdate varchar2(20);
    l_strdesc     varchar2(400);
    l_tltxcd      varchar2(4);
    p_err_code    number(20);
    l_err_param   varchar2(1000);
    l_sqlerrnum   varchar2(200);
  begin
    --Lay thong tin dien confirm
    for rec0 in (select req.*
                   from vsdtxreq req
                  where /*req.msgstatus in ('C', 'W')*/
                       --and req.status <> 'C'
                       --and req.msgstatus = 'W'
                    req.reqid = pv_reqid) loop
      -- nap giao dich de xu ly
      l_tltxcd       := '8879';
      l_txmsg.tltxcd := l_tltxcd;
      select txdesc into l_strdesc from tltx where tltxcd = l_tltxcd;
      l_txmsg.msgtype := 'T';
      l_txmsg.local   := 'N';
      l_txmsg.tlid    := tlid;
      select sys_context('USERENV', 'HOST'),
             sys_context('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;
      l_txmsg.off_line  := 'N';
      l_txmsg.deltd     := txnums.c_deltd_txnormal;
      l_txmsg.txstatus  := txstatusnums.c_txcompleted;
      l_txmsg.msgsts    := '0';
      l_txmsg.ovrsts    := '0';
      l_txmsg.batchname := 'DAY';
      l_txmsg.busdate   := busdate;
      l_txmsg.txdate    := getcurrdate;
      select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;
      select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
      l_txmsg.brid := rec0.brid; -- can sua lai them brid trong vsdtxreq de fill lai gt vao day
      for rec in (

                  select fn_get_location(af.brid) location, cf.custodycd,
                          b.desacctno afddi, c.codeid, c.symbol, c.parvalue,
                          a.afacctno, to_char(b.txdate, 'dd/mm/yyyy') txdate,
                          b.txnum, b.acctno, b.price, b.qtty, b.status,
                          b.desacctno, b.feeamt, b.taxamt, b.sdate, b.vdate,
                          cf.idcode, a4.cdcontent tradeplace,
                          case
                            when ci.corebank = 'Y' then
                             0
                            else
                             1
                          end iscorebank,
                           b.qtty * b.price / 100 *
                                 (select to_number(varvalue)
                                    from sysvar
                                   where varname = 'ADVSELLDUTY') tax,
                          ci.depolastdt,
                          fn_get_retailsell_caqtty(b.qtty, b.acctno) pitqtty,
                          round(fn_get_retailsell_cavat(b.qtty, b.acctno) *
                                (case
                                   when b.price > c.parvalue then
                                    c.parvalue
                                   else
                                    b.price
                                 end) / 100) pitamt, cf.fullname,
                          to_char(b.txdate, 'dd/mm/yyyy') || b.txnum accref,
                          (a.afacctno || nvl(c.refcodeid, c.codeid)) db_acctno_updatecost,
                          (substr(b.desacctno, 1, 10) ||
                           nvl(c.refcodeid, c.codeid)) cd_acctno_updatecost
                    from semast a, seretail b, sbsecurities c, afmast af,
                          cfmast cf, allcode a4, aftype afty, cimast ci,
                          vsdtxreq rq
                   where a.acctno = b.acctno
                     and a.codeid = c.codeid
                     and b.qtty > 0
                     and b.status = 'S'
                     and af.acctno = a.afacctno
                     and af.custid = cf.custid
                     and a4.cdtype = 'SE'
                     and a4.cdname = 'TRADEPLACE'
                     and a4.cdval = c.tradeplace
                     and af.actype = afty.actype
                     and af.acctno = ci.acctno
                     and rq.refcode = b.txnum
                     and rq.reqid = pv_reqid)

       loop
        --01    M?h?ng kho?  C
        l_txmsg.txfields('01').defname := 'CODEID';
        l_txmsg.txfields('01').type := 'C';
        l_txmsg.txfields('01').value := rec.codeid;
        --19    Thu? d?u tu v?n   N
        l_txmsg.txfields('19').defname := 'PITAMT';
        l_txmsg.txfields('19').type := 'N';
        l_txmsg.txfields('19').value := rec.pitamt;
        --02    S? TK b?  C
        l_txmsg.txfields('02').defname := 'AFACCTNO';
        l_txmsg.txfields('02').type := 'C';
        l_txmsg.txfields('02').value := rec.afacctno;
        --88    S? TK luu k? b?  C
        l_txmsg.txfields('88').defname := 'CUSTODYCD';
        l_txmsg.txfields('88').type := 'C';
        l_txmsg.txfields('88').value := rec.custodycd;
        --22    Ph?D l?   N
        l_txmsg.txfields('22').defname := 'FEEAMT';
        l_txmsg.txfields('22').type := 'N';
        l_txmsg.txfields('22').value := rec.feeamt;
        --32    Ng?chuy?n ph?K d?n h?n g?n nh?t   D
        l_txmsg.txfields('32').defname := 'DEPOLASTDT';
        l_txmsg.txfields('32').type := 'D';
        l_txmsg.txfields('32').value := rec.depolastdt;
        --15    Thu? TNCN   N
        l_txmsg.txfields('15').defname := 'TAXAMT';
        l_txmsg.txfields('15').type := 'N';
        l_txmsg.txfields('15').value := rec.taxamt;
        --14    Thu? chuy?n nhu?ng   N
        l_txmsg.txfields('14').defname := 'TAX';
        l_txmsg.txfields('14').type := 'N';
        l_txmsg.txfields('14').value := rec.tax;
        --11    Gi? N
        l_txmsg.txfields('11').defname := 'QUOTEPRICE';
        l_txmsg.txfields('11').type := 'N';
        l_txmsg.txfields('11').value := rec.price;
        --05    S? ch?ng t?   C
        l_txmsg.txfields('05').defname := 'TXNUM';
        l_txmsg.txfields('05').type := 'C';
        l_txmsg.txfields('05').value := rec.txnum;
        --04    Ng?l?p Ti?u kho?n   C
        l_txmsg.txfields('04').defname := 'TXDATE';
        l_txmsg.txfields('04').type := 'C';
        l_txmsg.txfields('04').value := rec.txdate;
        --10    Kh?i lu?ng   N
        l_txmsg.txfields('10').defname := 'ORDERQTTY';
        l_txmsg.txfields('10').type := 'N';
        l_txmsg.txfields('10').value := rec.qtty;
        --03    S? TK SE  b?  C
        l_txmsg.txfields('03').defname := 'SEACCTNO';
        l_txmsg.txfields('03').type := 'C';
        l_txmsg.txfields('03').value := rec.acctno;
        --60    L?K ng?h?   N
        l_txmsg.txfields('60').defname := 'ISCOREBANK';
        l_txmsg.txfields('60').type := 'N';
        l_txmsg.txfields('60').value := rec.iscorebank;
        --18    CK quy?n   N
        l_txmsg.txfields('18').defname := 'PITQTTY';
        l_txmsg.txfields('18').type := 'N';
        l_txmsg.txfields('18').value := rec.pitqtty;
        --12    M?nh gi? N
        l_txmsg.txfields('12').defname := 'PARVALUE';
        l_txmsg.txfields('12').type := 'N';
        l_txmsg.txfields('12').value := rec.parvalue;
        --07    S? TK mua   C
        l_txmsg.txfields('07').defname := 'AFACCTNO2';
        l_txmsg.txfields('07').type := 'C';
        l_txmsg.txfields('07').value := rec.afddi;
        --23    S? TK b?update gi??n   C
        l_txmsg.txfields('23').defname := 'SEACCTNO';
        l_txmsg.txfields('23').type := 'C';
        l_txmsg.txfields('23').value := rec.desacctno;
        --28    S? TK mua update i??n   C
        l_txmsg.txfields('28').defname := 'SEACCTNO2';
        l_txmsg.txfields('28').type := 'C';
        l_txmsg.txfields('28').value := rec.desacctno;
        --06    S? tham chi?u   C
        l_txmsg.txfields('06').defname := 'ACCREF';
        l_txmsg.txfields('06').type := 'C';
        l_txmsg.txfields('06').value := rec.accref;
        --90    H? t?  C
        l_txmsg.txfields('90').defname := 'CUSTNAME';
        l_txmsg.txfields('90').type := 'C';
        l_txmsg.txfields('90').value := rec.fullname;
        --08    S?TK SE  mua   C
        l_txmsg.txfields('08').defname := 'SEACCTNO2';
        l_txmsg.txfields('08').type := 'C';
        l_txmsg.txfields('08').value := rec.desacctno;
        --30    Di?n gi?i   C
        l_txmsg.txfields('30').defname := 'DESC';
        l_txmsg.txfields('30').type := 'C';
        l_txmsg.txfields('30').value := l_strdesc;
        --16    Ph?K chua d?n h?n   N
        l_txmsg.txfields('16').defname := 'DEPOFEEACR';
        l_txmsg.txfields('16').type := 'N';
        l_txmsg.txfields('16').value := 0;
        --17    Ph?K d?n h?n   N
        l_txmsg.txfields('17').defname := 'DEPOFEEAMT';
        l_txmsg.txfields('17').type := 'N';
        l_txmsg.txfields('17').value := 0;
        begin
          if txpks_#8879.fn_batchtxprocess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success then
            rollback;
          end if;
        end;
      end loop;
      if nvl(p_err_code, 0) = 0 then
        update vsdtxreq
           set status = 'C', msgstatus = 'F' --boprocess = 'Y'
         where reqid = pv_reqid;

        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      else
        -- neu giao dich loi: danh danh trang thai loi de lam lai bang tay
        update vsdtxreq
           set status = 'E', msgstatus = 'E'
               --boprocess = 'E'
              , boprocess_err = p_err_code
         where reqid = pv_reqid;
        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      end if;

    end loop;
  exception
    when others then
      l_sqlerrnum := substr(sqlerrm, 200);
      insert into log_err
        (id, date_log, position, text)
      values
        (seq_log_err.nextval, sysdate, 'AUTO_CALL_TXPKS_8879',
         l_sqlerrnum || dbms_utility.format_error_backtrace);
  end auto_call_txpks_8879;
  procedure auto_call_txpks_2248(pv_reqid number, pv_vsdtrfid number,busdate DATE, tlid VARCHAR2) as
    l_txmsg       tx.msg_rectype;
    v_strcurrdate varchar2(20);
    l_strdesc     varchar2(400);
    l_tltxcd      varchar2(4);
    p_err_code    number(20);
    l_err_param   varchar2(1000);
    l_sqlerrnum   varchar2(200);
    l_effect_date date;
    v_custodycd   VARCHAR2(500);
    v_count       NUMBER;
    V_ERROR       VARCHAR2(10);
  begin
    plog.setbeginsection(pkgctx, 'auto_call_txpks_2248');
    plog.info(pkgctx, 'process req id:' || pv_reqid);
    -- Lay ngay hieu luc hach toan TRADDET.98A.ESET tu dien xac nhan cua VSD
    -- FLDNAME la VSDEFFDATE
    begin
      select to_date(fldval, 'YYYYMMDD')
        into l_effect_date
        from vsdtrflogdtl
       where refautoid = pv_vsdtrfid
         and fldname = 'VSDEFFDATE';
    exception
      when others then
        l_effect_date := getcurrdate;
    end;
    V_ERROR := '0';
    --Lay thong tin dien confirm
    for rec0 in (select req.*
                   from vsdtxreq req
                  where /*req.msgstatus in ('C', 'W')*/
                       --and req.status <> 'C'
                       --and req.msgstatus = 'W'
                req.reqid = pv_reqid) loop

      -- nap giao dich de xu ly
      l_tltxcd       := '2248';
      l_txmsg.tltxcd := l_tltxcd;
      select txdesc into l_strdesc from tltx where tltxcd = l_tltxcd;
      l_txmsg.msgtype := 'T';
      l_txmsg.local   := 'N';
      l_txmsg.tlid    := tlid;
      select sys_context('USERENV', 'HOST'),
             sys_context('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;
      l_txmsg.off_line  := 'N';
      l_txmsg.deltd     := txnums.c_deltd_txnormal;
      l_txmsg.txstatus  := txstatusnums.c_txcompleted;
      l_txmsg.msgsts    := '0';
      l_txmsg.ovrsts    := '0';
      l_txmsg.batchname := 'DAY';
      l_txmsg.busdate   := busdate;
      l_txmsg.txdate    := getcurrdate;

      select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
      l_txmsg.brid := rec0.brid; -- can sua lai them brid trong vsdtxreq de fill lai gt vao day
      for rec in (select fn_get_location(substr(a.afacctno, 1, 4)) location,
                         replace(a.acctno, '.', '') acctno, a.symbol,
                         replace(a.afacctno, '.', '') afacctno, a.dtoclose, a.codeid, a.parvalue,
                         a.selastdate, a.aflastdate, a.lastdate, a.custodycd,
                         a.fullname, a.idcode, a.typename, a.tradeplace,
                         a.sendpbalance, a.sendamt, a.sendaqtty, a.rightqtty,
                         a.qtty, /*a.BLOCKDTOCLOSE,*/ (/*a.BLOCKDTOCLOSE+*/a.DTOCLOSE) SEQTTY
                    from v_se2248 a, vsdtxreq rq, cfmast cf, afmast af
                   where 0 = 0
                        /*and substr(rq.refcode, 1, 4) || '.' ||
                        substr(rq.refcode, 5, 6) || '.' ||
                        substr(rq.refcode, 11, 6) = a.acctno*/
                     and cf.custid = af.custid
                     and af.acctno = rq.afacctno
                     and a.custodycd = cf.custodycd
                     and rq.reqid = pv_reqid
                  ) LOOP
     select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;

/*        --08    S? lu?ng CK giao d?ch   N
     l_txmsg.txfields ('08').defname   := 'DTOCLOSE';
     l_txmsg.txfields ('08').TYPE      := 'N';
     l_txmsg.txfields ('08').value      := rec.DTOCLOSE;*/
/*--09    S? lu?ng CK HCCN   N
     l_txmsg.txfields ('09').defname   := 'BLOCKDTOCLOSE';
     l_txmsg.txfields ('09').TYPE      := 'N';
     l_txmsg.txfields ('09').value      := rec.BLOCKDTOCLOSE;*/
--10    S? lu?ng   N
     l_txmsg.txfields ('10').defname   := 'QTTY';
     l_txmsg.txfields ('10').TYPE      := 'N';
     l_txmsg.txfields ('10').value      := rec.SEQTTY;
--16    SLCK CA ghi gi?m   N
     l_txmsg.txfields ('16').defname   := 'CAQTTYDB';
     l_txmsg.txfields ('16').TYPE      := 'N';
     l_txmsg.txfields ('16').value      := rec.SENDAQTTY;
--88    S? TK luu k? b?  C
     l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
     l_txmsg.txfields ('88').TYPE      := 'C';
     l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
--90    H? t?  C
     l_txmsg.txfields ('90').defname   := 'CUSTNAME';
     l_txmsg.txfields ('90').TYPE      := 'C';
     l_txmsg.txfields ('90').value      := rec.FULLNAME;
--02    S? Ti?u kho?n   C
     l_txmsg.txfields ('02').defname   := 'AFACCTNO';
     l_txmsg.txfields ('02').TYPE      := 'C';
     l_txmsg.txfields ('02').value      := rec.AFACCTNO;
--01    M?h?ng kho?  C
     l_txmsg.txfields ('01').defname   := 'CODEID';
     l_txmsg.txfields ('01').TYPE      := 'C';
     l_txmsg.txfields ('01').value      := rec.CODEID;
--03    S? t?kho?n   C
     l_txmsg.txfields ('03').defname   := 'ACCTNO';
     l_txmsg.txfields ('03').TYPE      := 'C';
     l_txmsg.txfields ('03').value      := rec.ACCTNO;
--14    SL Quy?n mua chua ?   N
     l_txmsg.txfields ('14').defname   := 'RIGHTOFFQTTY';
     l_txmsg.txfields ('14').TYPE      := 'N';
     l_txmsg.txfields ('14').value      := rec.SENDPBALANCE;
--15    SL Ch?ng kho?CA   N
     l_txmsg.txfields ('15').defname   := 'CAQTTYRECEIV';
     l_txmsg.txfields ('15').TYPE      := 'N';
     l_txmsg.txfields ('15').value      := rec.QTTY;
--17    S? ti?n CA   N
     l_txmsg.txfields ('17').defname   := 'CAAMTRECEIV';
     l_txmsg.txfields ('17').TYPE      := 'N';
     l_txmsg.txfields ('17').value      := rec.SENDAMT;
--18    S? quy?n bi?u quy?t   N
     l_txmsg.txfields ('18').defname   := 'RIGHTQTTY';
     l_txmsg.txfields ('18').TYPE      := 'N';
     l_txmsg.txfields ('18').value      := rec.RIGHTQTTY;
--11    M?nh gi? N
     l_txmsg.txfields ('11').defname   := 'PARVALUE';
     l_txmsg.txfields ('11').TYPE      := 'N';
     l_txmsg.txfields ('11').value      := rec.PARVALUE;
--30    M?   C
     l_txmsg.txfields ('30').defname   := 'DESC';
     l_txmsg.txfields ('30').TYPE      := 'C';
     l_txmsg.txfields ('30').value      := l_strdesc;
        begin
        IF V_ERROR = '0' THEN
          if txpks_#2248.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success then
             V_ERROR :='-1';
            --rollback;
            --RETURN;
          end if;
        END IF;
        end;
      end loop;
      --if nvl(p_err_code, 0) = 0 THEN
    end loop;
    --KT DA THUC HIEN HET 2248 CHUA
      SELECT dtl.cval INTO v_custodycd FROM vsdtxreqdtl dtl WHERE dtl.reqid = pv_reqid AND dtl.fldname = 'CUSTODYCD';
      SELECT COUNT(*) INTO v_count FROM v_se2248 WHERE custodycd = v_custodycd;
    IF v_count = 0 AND V_ERROR ='0' THEN
       update vsdtxreq
           set status = 'C', msgstatus = 'F' --boprocess = 'Y'
         where reqid = pv_reqid;
       update vsdtrflog
           set status = 'C', timeprocess = systimestamp
       where autoid = pv_vsdtrfid;
      --COMMIT;
        plog.error(pkgctx, 'GOI 2249');

        --auto_call_txpks_2249(pv_reqid,pv_vsdtrfid);


        -- Tr?ng th?VSDTRFLOG

      else
        -- neu giao dich loi: danh danh trang thai loi de lam lai bang tay
        update vsdtxreq
           set status = 'E', msgstatus = 'E'
               --boprocess = 'E'
              , boprocess_err = p_err_code || '-GD2248'
         where reqid = pv_reqid;
        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      end if;
   plog.setendsection(pkgctx, 'auto_call_txpks_2248');
  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
         plog.setendsection(pkgctx, 'auto_call_txpks_2248');
  end auto_call_txpks_2248;

/*  procedure auto_call_txpks_2249(pv_reqid number, pv_vsdtrfid number) as
    l_txmsg       tx.msg_rectype;
    v_strcurrdate varchar2(20);
    l_strdesc     varchar2(400);
    l_tltxcd      varchar2(4);
    p_err_code    number(20);
    l_err_param   varchar2(1000);
    l_sqlerrnum   varchar2(200);
    l_effect_date date;
    l_custodycd   VARCHAR2(50);
    l_custname    VARCHAR2(500);
    V_COUNT       NUMBER;
    V_BRID        VARCHAR2(10);
    V_ERROR       VARCHAR2(10);
  begin
    plog.setbeginsection(pkgctx, 'auto_call_txpks_2249');
    plog.error(pkgctx, 'VAO XULY 2249');
    --plog.info(pkgctx, 'acctno:' || p_afacctno);
    SELECT DTL.CVAL, VSD.BRID INTO l_custodycd,V_BRID FROM VSDTXREQDTL DTL, VSDTXREQ VSD
    WHERE DTL.FLDNAME = 'CUSTODYCD' AND DTL.REQID = pv_reqid AND VSD.REQID = DTL.REQID;
     l_tltxcd       := '2249';
      l_txmsg.tltxcd := l_tltxcd;
      select txdesc into l_strdesc from tltx where tltxcd = l_tltxcd;
      l_txmsg.msgtype := 'T';
      l_txmsg.local   := 'N';
      l_txmsg.tlid    := systemnums.c_system_userid;
      select sys_context('USERENV', 'HOST'),
             sys_context('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;
      l_txmsg.off_line  := 'N';
      l_txmsg.deltd     := txnums.c_deltd_txnormal;
      l_txmsg.txstatus  := txstatusnums.c_txcompleted;
      l_txmsg.msgsts    := '0';
      l_txmsg.ovrsts    := '0';
      l_txmsg.batchname := 'DAY';
      l_txmsg.busdate   := getcurrdate;
      l_txmsg.txdate    := getcurrdate;
      select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
        --Set txnum

      l_txmsg.brid := V_BRID;
      V_ERROR := '0';
      -- lay thoong tin kh
      FOR rec IN
        (
          SELECT cf.custodycd, cf.fullname, af.acctno  FROM cfmast cf, afmast af
          WHERE cf.custid = af.custid
          AND CF.CUSTODYCD = l_custodycd
          ) LOOP
            \* SELECT systemnums.C_OL_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO l_txmsg.txnum
              FROM DUAL;*\
                select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;
      --acctno
      l_txmsg.txfields ('02').defname   := 'ACCTNO';
      l_txmsg.txfields ('02').TYPE   := 'C';
      l_txmsg.txfields ('02').VALUE   := rec.acctno;
      --DESC
      l_txmsg.txfields ('30').defname   := 'DESC';
      l_txmsg.txfields ('30').TYPE   := 'C';
      l_txmsg.txfields ('30').VALUE   := l_strdesc;

      --CUSTODYCD
      l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
      l_txmsg.txfields ('88').TYPE   := 'C';
      l_txmsg.txfields ('88').VALUE   := rec.custodycd;
      --CUSTNAME
      l_txmsg.txfields ('90').defname   := 'CUSTNAME';
      l_txmsg.txfields ('90').TYPE   := 'C';
      l_txmsg.txfields ('90').VALUE   := rec.fullname;

      begin
      IF V_ERROR = '0' THEN
          if txpks_#2249.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success THEN
             V_ERROR :='-1';
            --rollback;
            --RETURN;
          --ELSE
             --auto_call_txpks_0059(l_custodycd);
             --RETURN;
          end if;
       END IF;
        end;
      END LOOP;
     --KIEM TRA XEM DA DONG HET CAC TIEU KHOAN CHUA
     --COMMIT;
     SELECT COUNT(*) INTO V_COUNT FROM CFMAST CF, AFMAST AF
     WHERE CF.CUSTID = AF.CUSTID
     AND CF.CUSTODYCD = l_custodycd
     AND AF.STATUS <> 'C';
     --NEU DA DONG HET TIEU KHOAN THI GOI 0059 DE DONG TAI KHOAN
     IF V_COUNT = 0 AND V_ERROR = '0' THEN
       plog.error(pkgctx, 'GOI 0059');
      auto_call_txpks_0059(pv_reqid, pv_vsdtrfid);
     ELSE
       update vsdtxreq
           --set status = 'E', msgstatus = 'E'
               --boprocess = 'E'
            SET boprocess_err = p_err_code || '-GD2249'
         where reqid = pv_reqid;
        -- Tr?ng th?VSDTRFLOG
       \* update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;*\
     END IF;
     plog.setendsection(pkgctx, 'auto_call_txpks_2249');
  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
         plog.setendsection(pkgctx, 'auto_call_txpks_2249');
  end auto_call_txpks_2249;*/

/*  procedure auto_call_txpks_0059(pv_reqid number, pv_vsdtrfid number) as
    l_txmsg       tx.msg_rectype;
    v_strcurrdate varchar2(20);
    l_strdesc     varchar2(400);
    l_tltxcd      varchar2(4);
    p_err_code    number(20);
    l_err_param   varchar2(1000);
    l_sqlerrnum   varchar2(200);
    l_effect_date date;
    l_custid      VARCHAR2(50);
    l_custodycd VARCHAR2(50);
    V_ERROR     VARCHAR2(10);
  begin
    plog.setbeginsection(pkgctx, 'auto_call_txpks_0059');
    --plog.info(pkgctx, 'custodycd:' || p_custodycd);
     SELECT DTL.CVAL INTO l_custodycd FROM VSDTXREQDTL DTL WHERE DTL.FLDNAME = 'CUSTODYCD' AND DTL.REQID = pv_reqid;
     l_tltxcd       := '0059';
      l_txmsg.tltxcd := l_tltxcd;
      select txdesc into l_strdesc from tltx where tltxcd = l_tltxcd;
      l_txmsg.msgtype := 'T';
      l_txmsg.local   := 'N';
      l_txmsg.tlid    := systemnums.c_system_userid;
      select sys_context('USERENV', 'HOST'),
             sys_context('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;
      l_txmsg.off_line  := 'N';
      l_txmsg.deltd     := txnums.c_deltd_txnormal;
      l_txmsg.txstatus  := txstatusnums.c_txcompleted;
      l_txmsg.msgsts    := '0';
      l_txmsg.ovrsts    := '0';
      l_txmsg.batchname := 'DAY';
      l_txmsg.busdate   := getcurrdate;
      l_txmsg.txdate    := getcurrdate;
      select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
        --Set txnum
 \*   SELECT systemnums.C_OL_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO l_txmsg.txnum
              FROM DUAL;*\
                  select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;
      SELECT cf.custid INTO l_custid FROM cfmast cf WHERE cf.custodycd = l_custodycd;

      l_txmsg.brid := substr(l_custid,1,4);

      --CUSTID
      l_txmsg.txfields ('03').defname   := 'CUSTID';
      l_txmsg.txfields ('03').TYPE   := 'C';
      l_txmsg.txfields ('03').VALUE   := l_custid;
      --DESC
      l_txmsg.txfields ('30').defname   := 'DESC';
      l_txmsg.txfields ('30').TYPE   := 'C';
      l_txmsg.txfields ('30').VALUE   := l_strdesc;
      --CUSTODYCD
      l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
      l_txmsg.txfields ('88').TYPE   := 'C';
      l_txmsg.txfields ('88').VALUE   := l_custodycd;
      --SENDTOVSD
      l_txmsg.txfields ('99').defname   := 'SENDTOVSD';
      l_txmsg.txfields ('99').TYPE   := 'C';
      l_txmsg.txfields ('99').VALUE   := 'N';
      begin

          if txpks_#0059.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success THEN
             V_ERROR := '-1';
            --rollback;
            --RETURN;
          end if;

        end;
     if nvl(p_err_code, 0) <> 0 THEN
        plog.error(pkgctx, 'LOI 0059');
\*
        update vsdtxreq
           set status = 'C', msgstatus = 'F' --boprocess = 'Y'
         where reqid = pv_reqid;
        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;*\
      --else
        -- neu giao dich loi: danh danh trang thai loi de lam lai bang tay
        update vsdtxreq
           set --status = 'E', msgstatus = 'E'
               --boprocess = 'E'
               boprocess_err = p_err_code || '-GD0059'
         where reqid = pv_reqid;
        -- Tr?ng th?VSDTRFLOG
        \*update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;*\
      end if;

     plog.setendsection(pkgctx, 'auto_call_txpks_0059');
  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
         plog.setendsection(pkgctx, 'auto_call_txpks_0059');
  end auto_call_txpks_0059;*/

  procedure auto_call_txpks_2290(pv_reqid number, pv_vsdtrfid number,busdate DATE, tlid VARCHAR2) as
    l_txmsg       tx.msg_rectype;
    v_strcurrdate varchar2(20);
    l_strdesc     varchar2(400);
    l_tltxcd      varchar2(4);
    p_err_code    number(20);
    l_err_param   varchar2(1000);
    l_sqlerrnum   varchar2(200);
  begin
    plog.setbeginsection(pkgctx, 'auto_call_txpks_2290');
    plog.info(pkgctx, 'process req id:' || pv_reqid);
    --Lay thong tin dien confirm
    for rec0 in (select req.*
                   from vsdtxreq req
                  where /*req.msgstatus in ('N','R', 'W')*/
                       --and req.status <> 'C'
                       --and req.msgstatus = 'W'
                    req.reqid = pv_reqid) loop

      -- nap giao dich de xu ly
      l_tltxcd       := '2290';
      l_txmsg.tltxcd := l_tltxcd;
      select txdesc into l_strdesc from tltx where tltxcd = l_tltxcd;
      l_txmsg.msgtype := 'T';
      l_txmsg.local   := 'N';
      l_txmsg.tlid    := tlid;
      select sys_context('USERENV', 'HOST'),
             sys_context('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;
      l_txmsg.off_line  := 'N';
      l_txmsg.deltd     := txnums.c_deltd_txnormal;
      l_txmsg.txstatus  := txstatusnums.c_txcompleted;
      l_txmsg.msgsts    := '0';
      l_txmsg.ovrsts    := '0';
      l_txmsg.batchname := 'DAY';
      l_txmsg.busdate   := busdate;
      l_txmsg.txdate    := getcurrdate;

      select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
      l_txmsg.brid := rec0.brid;
      plog.info(pkgctx, 'process req id:' || pv_reqid);-- can sua lai them brid trong vsdtxreq de fill lai gt vao day
      for rec in (select a.*
                    from v_se2290 a, vsdtxreq rq
                   where 0 = 0
                     and rq.afacctno = a.afacctno
                     and rq.reqid = pv_reqid) LOOP
        select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;

        --02    S? Ti?u kho?n   C
        l_txmsg.txfields('02').defname := 'AFACCTNO';
        l_txmsg.txfields('02').type := 'C';
        l_txmsg.txfields('02').value := rec.afacctno;
        --03    T?kho?n ch?ng kho?  C
        l_txmsg.txfields('03').defname := 'ACCTNO';
        l_txmsg.txfields('03').type := 'C';
        l_txmsg.txfields('03').value := rec.acctno;
        --04    M?h?ng kho?  C
        l_txmsg.txfields('04').defname := 'SYMBOL';
        l_txmsg.txfields('04').type := 'C';
        l_txmsg.txfields('04').value := rec.symbol;
        --05    Tr?ng th?  C
        l_txmsg.txfields('05').defname := 'STATUS';
        l_txmsg.txfields('05').type := 'C';
        l_txmsg.txfields('05').value := rec.status;
        --06    S? du ch?ng kho?  N
        l_txmsg.txfields('06').defname := 'TRADE';
        l_txmsg.txfields('06').type := 'N';
        l_txmsg.txfields('06').value := rec.trade;
        --10    SL CK chuy?n ch? d?  N
        l_txmsg.txfields('10').defname := 'DTOCLOSE';
        l_txmsg.txfields('10').type := 'N';
        l_txmsg.txfields('10').value := rec.dtoclose;
        --11    SL CK phong t?a ch? d?  N
        l_txmsg.txfields('11').defname := 'DTBLOCKED';
        l_txmsg.txfields('11').type := 'N';
        l_txmsg.txfields('11').value := rec.DTBLOCKED;
        --14    SL Quy?n mua chua ?   N
        l_txmsg.txfields('14').defname := 'RIGHTOFFQTTY';
        l_txmsg.txfields('14').type := 'N';
        l_txmsg.txfields('14').value := rec.sendpbalance;
        --15    SL Ch?ng kho?CA   N
        l_txmsg.txfields('15').defname := 'CAQTTYRECEIV';
        l_txmsg.txfields('15').type := 'N';
        l_txmsg.txfields('15').value := rec.qtty;
        --17    S? ti?n CA   N
        l_txmsg.txfields('17').defname := 'CAAMTRECEIV';
        l_txmsg.txfields('17').type := 'N';
        l_txmsg.txfields('17').value := rec.sendamt;
        --18    S? quy?n bi?u quy?t   N
        l_txmsg.txfields('18').defname := 'RIGHTQTTY';
        l_txmsg.txfields('18').type := 'N';
        l_txmsg.txfields('18').value := rec.rightqtty;
        --16    SLCK CA ghi gi?m   N
        l_txmsg.txfields('16').defname := 'CAQTTYDB';
        l_txmsg.txfields('16').type := 'N';
        l_txmsg.txfields('16').value := rec.sendaqtty;
        --30    M?   C
        l_txmsg.txfields('30').defname := 'DESCRIPTION';
        l_txmsg.txfields('30').type := 'C';
        l_txmsg.txfields('30').value := l_strdesc;
        
        -- hotfix thue quyen
        l_txmsg.txfields('19').defname := 'PITQTTY';
        l_txmsg.txfields('19').type := 'N';
        l_txmsg.txfields('19').value := rec.pitqtty;
        --
        
        begin
          if txpks_#2290.fn_batchtxprocess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success then
            --rollback;
            plog.setendsection(pkgctx, 'auto_call_txpks_2290');
          end if;
        end;
      end loop;
      plog.info(pkgctx, 'pp_err_code:' || p_err_code);
      if nvl(p_err_code, 0) = 0 then
        update vsdtxreq
           set status = 'R', msgstatus = 'R' --boprocess = 'Y'
         where reqid = pv_reqid;

        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid; --l_txmsg.txfields('09').value;
      else
        -- neu giao dich loi: danh danh trang thai loi de lam lai bang tay
        update vsdtxreq
           set status = 'E', msgstatus = 'E'
               --boprocess = 'E'
              , boprocess_err = p_err_code
         where reqid = pv_reqid;
        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      end if;

    end loop;
    plog.setendsection(pkgctx, 'auto_call_txpks_2290');
  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
         plog.setendsection(pkgctx, 'auto_call_txpks_2290');
  end auto_call_txpks_2290;
end AUTO_CALL_TRANSAC;
/

