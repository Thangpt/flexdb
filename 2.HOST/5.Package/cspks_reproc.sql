CREATE OR REPLACE PACKAGE cspks_reproc
IS
    /*----------------------------------------------------------------------------------------------------
     ** Module   : COMMODITY SYSTEM
     ** and is copyrighted by FSS.
     **
     **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
     **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
     **    graphic, optic recording or otherwise, translated in any language or computer language,
     **    without the prior written permission of Financial Software Solutions. JSC.
     **
     **  MODIFICATION HISTORY
     **  Person      Date           Comments
     **  FSS      20-mar-2010    Created
     ** (c) 2008 by Financial Software Solutions. JSC.
     ----------------------------------------------------------------------------------------------------*/
 PROCEDURE pr_reCALREVENUE(p_bchmdl varchar,p_err_code  OUT varchar2);
 PROCEDURE re_change_cfstatus_af;
 PROCEDURE re_change_cfstatus_bf;
 PROCEDURE re_changerev(acclist in  varchar2,rate in varchar2,gor in varchar2,ip in varchar2, tlid in varchar2, brid varchar2);
 FUNCTION fn_re_getcommision(strACCTNO IN varchar2,   P_REVENUE NUMBER)  RETURN  number;
 FUNCTION fn_re_gettax(strcustid IN varchar2, p_BASEDACR number)  RETURN  number;
 PROCEDURE pr_reCALFEECOMM(p_bchmdl varchar,p_err_code  OUT varchar2);
END;
/
CREATE OR REPLACE PACKAGE BODY cspks_reproc
IS
   -- declare log context
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

---------------------------------pr_OpenLoanAccount------------------------------------------------
  PROCEDURE pr_reCALREVENUE(p_bchmdl varchar,p_err_code  OUT varchar2)
  IS
     v_currdate date;
     v_err VARCHAR2(10);
     v_rfmatchamt number(20,4);
     v_rffeeacr number(20,4);
     v_matchamt number(20,4);
     v_feeacr number(20,4);
     v_lmn number(20,4);
     v_DISPOSAL number(20,4);
     v_autoid number;
     v_grpautoid number;
     v_leadreacctno varchar2(14);
     v_count number;
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_reCALREVENUE');
     -- Tinh Doanh so hang ngay cho moi gioi
   Select TO_DATE (varvalue, systemnums.c_date_format) into v_currdate
    From sysvar
    Where varname='CURRDATE';

    RE_change_cfstatus_BF;

    --Backup reinttran sang reinttrana
    INSERT INTO REINTTRANA
    SELECT * FROM REINTTRAN
    WHERE TODATE<=TO_DATE(v_currdate,'DD/MM/RRRR');
    DELETE FROM REINTTRAN
    WHERE TODATE<=TO_DATE(v_currdate,'DD/MM/RRRR');
    --Cap nhat lai REMAST
    UPDATE REMAST SET DAMTACR=0,IAMTACR=0,DFEEACR=0,IFEEACR=0 , drfmatchamt=0,drffeeacr=0,dlmn=0,ddisposal=0
    WHERE STATUS='A';

    --- Tinh doanh so, doanh thu truc tiep
     Delete reinttrantemp;
     -- Tinh doanh so vao bang tam
     For vc in
            (Select ret.actype,sb.sectype,sb.tradeplace, re.refrecflnkid, re.reacctno,
                               sum(od.execamt) matchamt,
                               sum(decode(rem.odfeetype,'F',od.execamt *rem.odfeerate/100,od.feeacr)) feeacr,
                               max(rem.DAMTLASTDT) DAMTLASTDT,
                               max(rem.odfeetype) odfeetype,
                               max(rem.odfeerate) odfeerate

              From reaflnk re, odmast od, recfdef red, retype ret, remast rem, sbsecurities sb
              Where re.status='A' and re.deltd<>'Y'
                  and re.frdate<= v_currdate and v_currdate <= re.todate
                  and od.deltd<>'Y'
                  and od.txdate = v_currdate
                  and re.afacctno=od.afacctno
                  and od.execamt >0
                  and re.refrecflnkid = red.refrecflnkid
                  and substr(re.reacctno,11,4)=red.reactype
                  and red.effdate<= v_currdate and  v_currdate < red.expdate
                  and red.reactype=ret.actype
                  and ret.retype='D'
                  and re.reacctno=rem.acctno
                  and sb.codeid=od.codeid
                  and (    (ret.rdisposal = 'N')
                        or (ret.rdisposal = 'Y' and   od.ISDISPOSAL = 'N')
                       )  -- khong tinh doanh so lenh xu ly
              Group by ret.actype,sb.sectype,sb.tradeplace,re.refrecflnkid, re.reacctno
              Order by re.refrecflnkid,ret.actype,re.reacctno,sb.tradeplace,sb.sectype)
     LOOP

        -- Tinh phi giam tru
        Select   nvl(SUM( DECODE(RF.CALTYPE,'0001',RF.RERFRATE,0)*VC.MATCHAMT/100),0)  --  GIAM TRU DOANH SO

               , nvl(SUM( DECODE(RF.CALTYPE,'0002',RF.RERFRATE,0)
                          * decode(vc.odfeetype,'F',vc.odfeerate*vc.matchamt/100,VC.FEEACR)
                          /100),0) --  GIAM TRU DOANH thu
               INTO v_rfmatchamt, v_rffeeacr
        From
            (Select rerftype,caltype, min(stt) stt
               From(
                    Select rf.*,
                             CASE
                                              WHEN RF.SYMTYPE <>'000' AND RF.TRADEPLACE <>'000' THEN 0
                                              WHEN RF.SYMTYPE = '000' AND RF.TRADEPLACE <>'000' THEN 1
                                              WHEN RF.SYMTYPE <>'000' AND RF.TRADEPLACE ='000' THEN 2
                                              WHEN RF.SYMTYPE ='000' AND RF.TRADEPLACE ='000' THEN 3
                                            END STT
                    From rerfee rf
                    Where rf.refobjid=VC.ACTYPE
                              and (VC.TRADEPLACE=RF.TRADEPLACE OR RF.TRADEPLACE='000' )
                              AND (vc.sectype=RF.SYMTYPE OR RF.SYMTYPE='000')
                    )
              Group by rerftype,caltype
              ) A,
              Rerfee rf
         Where A.rerftype=rf.rerftype
           and A.caltype=rf.caltype
            and (VC.TRADEPLACE=RF.TRADEPLACE OR RF.TRADEPLACE='000' )
            AND (vc.sectype=RF.SYMTYPE OR RF.SYMTYPE='000')
           and rf.refobjid=vc.actype
           and (CASE
                              WHEN RF.SYMTYPE <>'000' AND RF.TRADEPLACE <>'000' THEN 0
                              WHEN RF.SYMTYPE = '000' AND RF.TRADEPLACE <>'000' THEN 1
                              WHEN RF.SYMTYPE <>'000' AND RF.TRADEPLACE ='000' THEN 2
                              WHEN RF.SYMTYPE ='000' AND RF.TRADEPLACE ='000' THEN 3
                            END ) = A.stt;
       Insert into reinttrantemp(actype,tradeplace,sectype,acctno,matchamt,feeacr
                    ,rfmatchamt,rffeeacr,DAMTLASTDT )
       values(vc.actype,vc.tradeplace,vc.sectype,vc.reacctno,vc.matchamt,vc.feeacr,
                    v_rfmatchamt,v_rffeeacr,vc.DAMTLASTDT);



     End loop;
 -- Cap nhat vao REMAST
     For vc in
         (Select acctno,
               sum(matchamt) matchamt,
               sum(feeacr) feeacr,
               sum(rfmatchamt) rfmatchamt,
               sum(rffeeacr) rffeeacr,
               max(damtlastdt) damtlastdt
          From reinttrantemp
          Group by acctno)
      Loop
            -- Tinh tong gia tri phat vay bao lanh
                v_lmn:= 0;
                Select  nvl(sum(l.nml + l.ovd),0) into v_lmn
                From lnschd l , lnmast m, reaflnk rl , retype typ
                Where l.reftype='GP'
                and l.rlsdate = v_currdate --(Select TO_DATE (varvalue, 'dd/mm/yyyy')    From sysvar    Where varname='CURRDATE')
                and l.acctno = m.acctno
                and m.trfacctno = rl.afacctno
                and rl.status='A' and rl.deltd<>'Y' and rl.frdate<= v_currdate and v_currdate <= rl.todate
                and substr(rl.reacctno,11,4) = typ.actype
                and typ.rlmn='Y'
                and rl.reacctno=vc.acctno;
            -- Tinh tong gia tri lenh giai chap
               v_DISPOSAL:= 0;
                Select  nvl(sum(od.execamt),0) into v_DISPOSAL
                From odmast od, reaflnk rl  , retype typ
                Where  od.txdate = v_currdate --(Select TO_DATE (varvalue, 'dd/mm/yyyy')    From sysvar    Where varname='CURRDATE')
                and od.deltd <>'Y'
                and od.isdisposal = 'Y'
                and od.afacctno = rl.afacctno
                and rl.status='A' and rl.deltd<>'Y' and rl.frdate<= v_currdate and v_currdate <= rl.todate
                and substr(rl.reacctno,11,4) = typ.actype
                and typ.rdisposal='Y'
                and rl.reacctno=vc.acctno;


            Insert into reinttran(autoid, acctno, inttype, frdate, todate,
                      icrule,irrate, intbal, intamt,rfmatchamt,rffeeacr,lmn,disposal)
               values(SEQ_REINTTRAN.NEXTVAL,vc.acctno,'DBR',vc.DAMTLASTDT,v_currdate,
                      'S',1,vc.matchamt,vc.feeacr,vc.rfmatchamt,vc.rffeeacr,v_lmn,v_disposal);
            Update remast
            Set damtacr = vc.matchamt, -- Doanh so trong ngay
                dfeeacr = vc.feeacr,   -- Doanh thu trong ngay
                directacr = nvl(directacr,0) + vc.matchamt, -- Doanh so luy ke
                directfeeacr = nvl(directfeeacr,0) + vc.feeacr, -- Doanh thu luy ke
                damtlastdt = v_currdate,
                drfmatchamt = vc.rfmatchamt, -- Giam tru doanh so trong ngay
                drffeeacr   = vc.rffeeacr,   -- Giam tru doanh thu trong ngay
                rfmatchamt = nvl(rfmatchamt,0) + vc.rfmatchamt, -- Giam tru doanh so luy ke
                rffeeacr   = nvl(rffeeacr,0) +  vc.rffeeacr ,    -- Giam tru doanh thu lu ke
                dlmn = v_lmn, -- Gia tri phat vay bao lanh trong ngay
                lmn = nvl(lmn,0) + v_lmn , -- Gia tri phat vay bao lanh luy ke
                ddisposal = v_DISPOSAL , -- Tong gia tri lenh giai chap trong ngay
                disposal = nvl(disposal,0) + v_DISPOSAL -- Tong gia tri lenh giai chap luy ke
            where acctno=vc.acctno;


          --begin chaunh
          --cap nhap doanh thu vao nhom lien quan den moi gioi

          begin
          select g.autoid, g.custid || g.actype   into v_grpautoid, v_leadreacctno
          from regrp g, regrplnk l where l.refrecflnkid = g.autoid and l.status = 'A' and g.status = 'A'
          and l.reacctno = vc.acctno;
          exception when others then
            v_grpautoid:= 0;
          end;

          if v_grpautoid <> 0 then

              Insert into regrpbm(autoid , grpautoid, leadreacctno,reacctno, matchamt,feeacr, lmn,
                                           disposal ,frdate, todate,status,rfmatchamt,rffeeacr)

                       values(seq_regrpbm.nextval,v_grpautoid,v_leadreacctno,vc.acctno,vc.matchamt,vc.feeacr,v_lmn,
                                           v_DISPOSAL,vc.DAMTLASTDT,v_currdate,'A',vc.rfmatchamt,vc.rffeeacr);
          end if;

          --update lai tong doanh so theo nhom lien quan den moi gioi den ngay hom nay
          v_autoid := 0;
          begin
            select autoid into v_autoid from regrpbmcom r
            where r.grpautoid = v_grpautoid and v_leadreacctno = r.leadreacctno and reacctno = vc.acctno
            and status = 'A' and commdate is null;
          EXCEPTION when others then
            v_autoid := 0;
          end;

          ---kiem tra xem co phai BM khong?
          select count(*) into v_count
          from retype where actype = substr(vc.acctno,11,4) and rerole in ('BM','RM');
          if v_count = 0 then
            v_autoid := -1; --khong phai BM
          end if;

          if v_autoid = 0 then
            Insert into regrpbmcom(autoid , grpautoid, leadreacctno,reacctno, matchamt,feeacr, lmn,
                                       disposal ,frdate, todate,commision,salary,commdate,status,rfmatchamt,rffeeacr)

                   values(seq_regrpbmcom.nextval,v_grpautoid,v_leadreacctno,vc.acctno,vc.matchamt,vc.feeacr,v_lmn,
                                       v_DISPOSAL,v_currdate,v_currdate,0,0,null,'A',vc.rfmatchamt,vc.rffeeacr);
          elsif v_autoid <> -1 then
            update regrpbmcom set
                matchamt= nvl(matchamt,0) + vc.matchamt,
                feeacr = nvl(feeacr,0) + vc.feeacr,
                lmn = nvl(lmn,0) + v_lmn,
                disposal = nvl(disposal,0) + v_DISPOSAL,
                todate = v_currdate,
                rfmatchamt = nvl(rfmatchamt,0) + vc.rfmatchamt,
                rffeeacr = nvl(rffeeacr,0) + vc.rffeeacr
            where autoid = v_autoid;
          end if;
          --end chaunh

      End loop;
    -- ket thuc tinh doanh so truc tiep


    -- Tinh doanh so, doanh thu gian tiep
    For VC in (
            Select rg.custid||rg.actype reacctno,
                    rgl.DAMTACR,
                    rgl.dfeeacr,
                    rgl.drfmatchamt,
                    rgl.drffeeacr,
                    rgl.dlmn,
                    rgl.ddisposal,
                    v_currdate IAMTLASTDT
            From REGRP rg,
             (Select rgl.refrecflnkid, sum(rm.DAMTACR) DAMTACR,
                                       sum(rm.dfeeacr)dfeeacr,
                                       sum(rm.drfmatchamt) drfmatchamt,
                                       sum(rm.drffeeacr) drffeeacr,
                                       sum(rm.dlmn) dlmn,
                                       sum(rm.ddisposal)  ddisposal
              From REGRPLNK rgl, remast rm, retype ret
              where rgl.reacctno=rm.acctno
                   and rgl.frdate<=v_currdate and v_currdate<=rgl.todate
                    and rgl.deltd<>'Y'
                    and rgl.status='A'
                    and rm.status='A'
                    and rm.actype=ret.actype
                    and ret.retype='D' and ret.rerole in ('RM','BM')
               Group by  rgl.refrecflnkid     ) rgl
            Where SP_FORMAT_REGRP_MAPCODE( rgl.refrecflnkid) like SP_FORMAT_REGRP_MAPCODE(rg.autoid)||'%'
     ) Loop
       Insert into reinttran(autoid, acctno, inttype, frdate, todate,
                      icrule,irrate, intbal, intamt,rfmatchamt,rffeeacr,lmn,disposal)
               values(SEQ_REINTTRAN.NEXTVAL,vc.reacctno,'IBR',vc.IAMTLASTDT,v_currdate,
                      'S',1,vc.DAMTACR,vc.dfeeacr,vc.drfmatchamt,vc.drffeeacr, vc.dlmn, vc.ddisposal);
        Update remast
        Set iamtacr = nvl(iamtacr,0) + vc.DAMTACR,
            ifeeacr = nvl(ifeeacr,0) + vc.dfeeacr,
            indirectacr = nvl(indirectacr,0) + vc.DAMTACR,
            indirectfeeacr = nvl(indirectfeeacr,0) + vc.dfeeacr,
            IAMTLASTDT = v_currdate,
            inrfmatchamt = nvl(inrfmatchamt,0) + vc.drfmatchamt,
            inrffeeacr = nvl(inrffeeacr,0) + vc.drffeeacr,
            inlmn = nvl(inlmn,0) + vc.dlmn,
            indisposal = nvl(indisposal,0) + vc.ddisposal
        where acctno=vc.reacctno;
     End loop;
     ---- Tinh Doanh so cho MG cham so ho
     For vc in(
              Select  re.refrecflnkid, re.reacctno,re.orgreacctno,
                               sum(od.execamt) matchamt, sum(od.feeacr) feeacr
              From reaflnk re, odmast od, recfdef red, retype ret, remast rem
              Where re.status='A' and re.deltd<>'Y'
                  and re.frdate<=v_currdate and v_currdate <= re.todate
                  and od.deltd<>'Y'
                  and od.txdate = v_currdate
                  and re.afacctno=od.afacctno
                  and od.execamt >0
                  and re.refrecflnkid = red.refrecflnkid
                  and substr(re.reacctno,11,4)=red.reactype
                  and red.effdate<= v_currdate and  v_currdate < red.expdate
                  and red.reactype=ret.actype
                  and ret.retype='D'
                  and re.reacctno=rem.acctno
                  and (    (ret.rdisposal = 'N')
                        or (ret.rdisposal = 'Y' and   od.ISDISPOSAL = 'N')
                       )  -- khong tinh doanh so lenh xu ly
                  and ret.rerole = 'DG'
              Group by re.refrecflnkid, re.reacctno,re.orgreacctno
               order by re.refrecflnkid,re.reacctno,re.orgreacctno)
     Loop
            -- Tinh tong gia tri phat vay bao lanh
                v_lmn:= 0;
                Select  nvl(sum(l.nml + l.ovd),0) into v_lmn
                From lnschd l , lnmast m, reaflnk rl , retype typ
                Where l.reftype='GP'
                and l.rlsdate = v_currdate --(Select TO_DATE (varvalue, 'dd/mm/yyyy')    From sysvar    Where varname='CURRDATE')
                and l.acctno = m.acctno
                and m.trfacctno = rl.afacctno
                and rl.status='A' and rl.deltd<>'Y' and rl.frdate<= v_currdate and v_currdate <= rl.todate
                and substr(rl.reacctno,11,4) = typ.actype
                and typ.rlmn='Y'
                and rl.reacctno=vc.reacctno
                and rl.orgreacctno = vc.orgreacctno;
            -- Tinh tong gia tri lenh giai chap
               v_DISPOSAL:= 0;
                Select  nvl(sum(od.execamt),0) into v_DISPOSAL
                From odmast od, reaflnk rl  , retype typ
                Where  od.txdate = v_currdate --(Select TO_DATE (varvalue, 'dd/mm/yyyy')    From sysvar    Where varname='CURRDATE')
                and od.deltd <>'Y'
                and od.isdisposal = 'Y'
                and od.afacctno = rl.afacctno
                and rl.status='A' and rl.deltd<>'Y' and rl.frdate<= v_currdate and v_currdate <= rl.todate
                and substr(rl.reacctno,11,4) = typ.actype
                and typ.rdisposal='Y'
                and rl.reacctno=vc.reacctno
                and rl.orgreacctno = vc.orgreacctno;
            v_autoid:=0;
            For rec in (
                         Select autoid
                         From rerevdg r
                         Where r.reacctno = vc.reacctno
                            and r.orgreacctno = vc.orgreacctno
                            and status = 'A'
                            and commdate is null)
           Loop
                v_autoid:= rec.autoid;
           End loop;
           IF v_autoid = 0 THEN
                Insert into rerevdg(autoid , reacctno,orgreacctno, matchamt,feeacr, lmn,
                                    disposal ,frdate, todate,commision , salary , commdate ,status)

                values(seq_rerevdg.nextval,vc.reacctno,vc.orgreacctno,vc.matchamt,vc.feeacr,v_lmn,
                                    v_DISPOSAL,v_currdate,v_currdate,0,0,null,'A');
           Else
               Update rerevdg
               Set matchamt = nvl(matchamt,0) + vc.matchamt,
                   feeacr = nvl(feeacr,0) + vc.feeacr,
                   lmn = nvl(lmn,0) + v_lmn,
                   disposal = nvl(disposal,0) + v_DISPOSAL,
                   todate = v_currdate
               Where autoid=v_autoid;
           End if;

     End loop;--Tinh Doanh so cho MG cham so ho

     -- Tinh Doanh so moi gio chung voi DFS
     For vc in(
              Select  RET.ACTYPE, SB.sectype,sb.tradeplace,re.refrecflnkid, re.reacctno, rem.reacctno orgreacctno
                   ,sum(od.execamt) matchamt,
                    sum(od.feeacr) feeacr
              From reaflnk re, recfdef red, retype ret,
                   (select r.reacctno,r.afacctno
                    from reaflnk r, retype t, recfdef rd
                    where r.status ='A'
                          and  substr(r.reacctno,11,4) = t.actype
                          and t.rerole='RD' and t.retype='D'
                          and r.refrecflnkid=rd.refrecflnkid
                          and substr(r.reacctno,11,4)=rd.reactype
                          and rd.effdate<= v_currdate and  v_currdate < rd.expdate
                    )rem,
                    odmast od, sbsecurities SB
              Where re.status='A' and re.deltd<>'Y'
                  and re.frdate<=v_currdate and v_currdate <= re.todate
                  and re.refrecflnkid = red.refrecflnkid
                  and substr(re.reacctno,11,4)=red.reactype
                  and red.effdate<= v_currdate and  v_currdate < red.expdate
                  and red.reactype=ret.actype
                  and ret.retype='D'
                  and ret.rerole in ('BM','RM')
                  and re.afacctno=rem.afacctno
                  and od.deltd<>'Y'
                  and od.txdate = v_currdate
                  and re.afacctno=od.afacctno
                  and od.execamt >0
                  and (    (ret.rdisposal = 'N')
                        or (ret.rdisposal = 'Y' and   od.ISDISPOSAL = 'N')
                       )  -- khong tinh doanh so lenh xu ly
                  and sb.codeid=od.codeid

              Group by RET.ACTYPE, SB.sectype,sb.tradeplace,re.refrecflnkid, re.reacctno,rem.reacctno
              order by RET.ACTYPE, SB.sectype,sb.tradeplace,re.refrecflnkid,re.reacctno,rem.reacctno)
     Loop
        v_rfmatchamt:=0;-- Giam tru doanh so
        v_rffeeacr:=0;-- Giam tru doanh thu
        Select   nvl(SUM( DECODE(RF.CALTYPE,'0001',RF.RERFRATE,0)*VC.MATCHAMT/100),0)  --  GIAM TRU DOANH SO

               , nvl(SUM( DECODE(RF.CALTYPE,'0002',RF.RERFRATE,0)*VC.FEEACR/100),0) --  GIAM TRU DOANH thu
               INTO v_rfmatchamt, v_rffeeacr
        From
            (Select rerftype,caltype, min(stt) stt
               From(
                    Select rf.*,
                             CASE
                                              WHEN RF.SYMTYPE <>'000' AND RF.TRADEPLACE <>'000' THEN 0
                                              WHEN RF.SYMTYPE = '000' AND RF.TRADEPLACE <>'000' THEN 1
                                              WHEN RF.SYMTYPE <>'000' AND RF.TRADEPLACE ='000' THEN 2
                                              WHEN RF.SYMTYPE ='000' AND RF.TRADEPLACE ='000' THEN 3
                                            END STT
                    From rerfee rf
                    Where rf.refobjid=VC.ACTYPE
                              and (VC.TRADEPLACE=RF.TRADEPLACE OR RF.TRADEPLACE='000' )
                              AND (vc.sectype=RF.SYMTYPE OR RF.SYMTYPE='000')
                    )
              Group by rerftype,caltype
              ) A,
              Rerfee rf
         Where A.rerftype=rf.rerftype
           and A.caltype=rf.caltype
            and (VC.TRADEPLACE=RF.TRADEPLACE OR RF.TRADEPLACE='000' )
            AND (vc.sectype=RF.SYMTYPE OR RF.SYMTYPE='000')
           and rf.refobjid=vc.actype
           and (CASE
                              WHEN RF.SYMTYPE <>'000' AND RF.TRADEPLACE <>'000' THEN 0
                              WHEN RF.SYMTYPE = '000' AND RF.TRADEPLACE <>'000' THEN 1
                              WHEN RF.SYMTYPE <>'000' AND RF.TRADEPLACE ='000' THEN 2
                              WHEN RF.SYMTYPE ='000' AND RF.TRADEPLACE ='000' THEN 3
                            END ) = A.stt;
         --  dbms_output.put_line('v_rffeeacr = '||v_rffeeacr);
         --  dbms_output.put_line('v_rfmatchamt = '||v_rfmatchamt);
           -- Tinh tong gia tri phat vay bao lanh
           v_lmn:= 0;
            -- Tinh tong gia tri lenh giai chap
           v_DISPOSAL:= 0;
            v_autoid:=0;
            For rec in (
                         Select autoid
                         From rerevdg r
                         Where r.reacctno = vc.reacctno
                            and r.orgreacctno = vc.orgreacctno
                            and status = 'A'
                            and commdate is null)
           Loop
                v_autoid:= rec.autoid;
           End loop;
           -- begin ver: 1.5.0.2 | iss: 1773
           --Insert into rerevdgall(autoid , reacctno,orgreacctno, matchamt,feeacr, lmn,
           --                         disposal ,frdate, todate,commision , salary , commdate ,status,rfmatchamt,rffeeacr)

           --     values(seq_rerevdgaLL.nextval,vc.reacctno,vc.orgreacctno,vc.matchamt,vc.feeacr,v_lmn,
           --                         v_DISPOSAL,v_currdate,v_currdate,0,0,null,'A',v_rfmatchamt,v_rffeeacr);
           -- Luu lai tradeplace 
           Insert into rerevdgall(autoid , reacctno,orgreacctno, matchamt,feeacr, lmn,
                                    disposal ,frdate, todate,commision , salary , commdate ,status,rfmatchamt,rffeeacr, tradeplace)

                values(seq_rerevdgaLL.nextval,vc.reacctno,vc.orgreacctno,vc.matchamt,vc.feeacr,v_lmn,
                                    v_DISPOSAL,v_currdate,v_currdate,0,0,null,'A',v_rfmatchamt,v_rffeeacr, vc.tradeplace);
           -- end ver: 1.5.0.2 | iss: 1773
           IF v_autoid = 0 THEN
                Insert into rerevdg(autoid , reacctno,orgreacctno, matchamt,feeacr, lmn,
                                    disposal ,frdate, todate,commision , salary , commdate ,status,rfmatchamt,rffeeacr)

                values(seq_rerevdg.nextval,vc.reacctno,vc.orgreacctno,vc.matchamt,vc.feeacr,v_lmn,
                                    v_DISPOSAL,v_currdate,v_currdate,0,0,null,'A',v_rfmatchamt,v_rffeeacr);
           Else
               Update rerevdg
               Set matchamt = nvl(matchamt,0) + vc.matchamt,
                   feeacr = nvl(feeacr,0) + vc.feeacr,
                   lmn = nvl(lmn,0) + v_lmn,
                   disposal = nvl(disposal,0) + v_DISPOSAL,
                   rfmatchamt = nvl(rfmatchamt,0) + v_rfmatchamt,
                   rffeeacr = nvl(rffeeacr,0) + v_rffeeacr,
                   todate = v_currdate
               Where autoid=v_autoid;
           End if;
     End loop;-- Tinh Doanh so moi gio chung voi DFS


    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_reCALREVENUE');
  EXCEPTION
  WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.error (pkgctx, dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_reCALREVENUE');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_reCALREVENUE;
PROCEDURE re_change_cfstatus_af is
     v_currdate date;
     v_dmday number(10);
     v_check number(10);
BEGIN
    Select to_date(varvalue,'dd/mm/yyyy') into v_currdate
    From sysvar
    Where varname='CURRDATE' and grname='SYSTEM';
    Begin
        Select to_NUMBER(varvalue) into v_dmday
        From sysvar
        Where varname='DMDAY' and grname='SYSTEM';
    EXCEPTION
    when OTHERS then
        v_dmday:=360;
    End;
    /*   -- Chuyen tu moi -> cu
        For vc in (Select cf.custodycd,cf.lastdate,cf.activedate,cf.dmsts,cf.afstatus
                From  CFmast cf
                Where  dmsts='N' and afstatus='N' and activedate + v_dmday + 1 <= v_currdate) loop

         Update Cfmast
         Set afstatus = 'O'
         where custodycd = vc.custodycd;
         insert into changecfstslog(txdate,custodycd,olddmsts,oldafstatus,oldlastdate,oldactivedate,
               newdmsts,newafstatus,newlastdate,newactivedate)
         values(v_currdate,vc.custodycd,vc.dmsts,vc.afstatus,vc.lastdate,vc.activedate,
               vc.dmsts,'O',vc.lastdate,vc.activedate);

         -- Chuyen doi tk moi gioi cu/moi
         For rec in(SELECT r.autoid, r.txdate, r.txnum, r.refrecflnkid, r.reacctno,
                       r.afacctno, r.frdate, r.todate, r.deltd, r.clstxdate, r.clstxnum,
                       r.pstatus, r.status, r.furefrecflnkid, r.fureacctno
                     From reaflnk r,afmast af, cfmast cf, retype rty
                     WHERE r.status='A'
                      And r.afacctno= af.acctno
                      and af.custid=cf.custid
                      and substr(reacctno,11,4)=rty.actype
                      and rty.rerole in ('BM')
                      And cf.custodycd =  vc.custodycd)
         Loop
                insert into reaflnk(autoid, txdate, txnum, refrecflnkid, reacctno,
                   afacctno, frdate, todate, deltd, clstxdate, clstxnum,
                   pstatus, status, furefrecflnkid, fureacctno)
                          values (seq_reaflnk.nextval,rec.txdate,rec.txnum,rec.furefrecflnkid,rec.fureacctno,
                   rec.afacctno,v_currdate,rec.todate,rec.deltd,null,null,
                   rec.pstatus,rec.status,rec.refrecflnkid,rec.reacctno);

               Update reaflnk
               Set  status='C',
                    clstxdate=v_currdate
               Where autoid = rec.autoid
                    and  reacctno=rec.reacctno
                    and  afacctno=rec.afacctno
                    and   status='A';

               --Kiem tra da ton tai tk moi gioi tuong lai chua
                v_check:=0;
                Begin
                    Select count(custid) into v_check
                    From remast
                    Where status='A' and ACCTNO=rec.fureacctno;
                EXCEPTION when OTHERS then
                     v_check:=0;
                End;
                If v_check=0 then
                     INSERT INTO REMAST (ACCTNO,CUSTID,ACTYPE,STATUS,PSTATUS,
                                        LAST_CHANGE,RATECOMM,BALANCE,DAMTACR,DAMTLASTDT,
                                         IAMTACR, IAMTLASTDT,DIRECTACR,INDIRECTACR,ODFEETYPE,ODFEERATE,COMMTYPE,LASTCOMMDATE)
                     SELECT  rec.fureacctno ACCTNO ,substr(rec.fureacctno,1,10) CUSTID,substr(rec.fureacctno,11,4) ACTYPE, 'A' STATUS,'' PSTATUS,
                                         sysdate LAST_CHANGE, RATECOMM, 0 BALANCE, 0 DAMTACR, v_currdate DAMTLASTDT,
                                         0 IAMTACR , v_currdate IAMTLASTDT , 0 DIRECTACR, 0 INDIRECTACR, ODFEETYPE,ODFEERATE,COMMTYPE,v_currdate  LASTCOMMDATE
                     FROM RETYPE WHERE ACTYPE=substr(rec.fureacctno,11,4);
                End if;
                ----------------

         End loop;
     End loop;
     */

     -- Rut tieu khoan khoi moi gioi khi het han
     update reaflnk
        set status='C',
            clstxdate=v_currdate
        where status='A' and todate<v_currdate;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        return ;
END; -- Procedure
PROCEDURE re_change_cfstatus_bf is
     v_currdate date;
     v_dmday number(10);
     v_olddmsts VARCHAR2(1);
     v_oldafstatus varchar2(1);
     v_oldlastdate date;
     v_oldactivedate date;
     v_newdmsts VARCHAR2(1);
     v_newafstatus varchar2(1);
     v_newlastdate date;
     v_newactivedate date;
     v_check number(10);
      v_close BOOLEAN;
BEGIN
    Select to_date(varvalue,'dd/mm/yyyy') into v_currdate
    From sysvar
    Where varname='CURRDATE' and grname='SYSTEM';
    Begin
        Select to_NUMBER(varvalue) into v_dmday
        From sysvar
        Where varname='DMDAY' and grname='SYSTEM';
    EXCEPTION
    when OTHERS then
        v_dmday:=360;
    End;
    -- Cac tk co gd trong ngay
    For vc in (Select distinct cf.custodycd, cf.lastdate,cf.activedate,cf.dmsts,cf.afstatus
            From iod i, cfmast cf
            where i.deltd<>'Y'
            and i.custodycd=cf.custodycd)
    Loop
     /* v_olddmsts:=vc.dmsts;
      v_oldafstatus:=vc.afstatus;
      v_oldlastdate:=vc.lastdate;
      v_oldactivedate:=vc.activedate;
      v_newdmsts:=vc.dmsts;
      v_newafstatus:=vc.afstatus;
      v_newlastdate:=v_currdate;
      v_newactivedate:=vc.activedate;
      If vc.dmsts='Y' then
         -- Danh dau thuc
         Update cfmast cf
         Set dmsts='N',
             activedate =  v_currdate
         Where cf.custodycd=vc.custodycd;
         v_newdmsts:='N';
         v_newactivedate:=v_currdate;
         -- Chuyen tu khach hang cu ->kh moi
         If vc.afstatus='O' then
             Update Cfmast
             Set afstatus = 'N'
             where custodycd = vc.custodycd;
             v_newafstatus:='N';
             For rec in(SELECT r.autoid, r.txdate, r.txnum, r.refrecflnkid, r.reacctno,
                       r.afacctno, r.frdate, r.todate, r.deltd, r.clstxdate, r.clstxnum,
                       r.pstatus, r.status, r.furefrecflnkid, r.fureacctno
                     From reaflnk r,afmast af, cfmast cf, retype rty
                     WHERE r.status='A'
                      And r.afacctno= af.acctno
                      and af.custid=cf.custid
                      and substr(reacctno,11,4)=rty.actype
                      and rty.rerole in ('BM')
                      And cf.custodycd =  vc.custodycd)
              Loop
                   Insert into reaflnk(autoid, txdate, txnum, refrecflnkid, reacctno,
                   afacctno, frdate, todate, deltd, clstxdate, clstxnum,
                   pstatus, status, furefrecflnkid, fureacctno)
                          values (seq_reaflnk.nextval,rec.txdate,rec.txnum,rec.furefrecflnkid,rec.fureacctno,
                   rec.afacctno,v_currdate,rec.todate,rec.deltd,null,null,
                   rec.pstatus,rec.status,rec.refrecflnkid,rec.reacctno);

                   Update reaflnk
                   Set  status='C',
                        clstxdate=v_currdate
                   Where autoid = rec.autoid
                        and  reacctno=rec.reacctno
                        and  afacctno=rec.afacctno
                        and   status='A';
                  --Kiem tra da ton tai tk moi gioi tuong lai chua
                    v_check:=0;
                    Begin
                        Select count(custid) into v_check
                        From remast
                        Where status='A' and ACCTNO=rec.fureacctno;
                    EXCEPTION when OTHERS then
                         v_check:=0;
                    End;
                    If v_check=0 then
                         INSERT INTO REMAST (ACCTNO,CUSTID,ACTYPE,STATUS,PSTATUS,
                                            LAST_CHANGE,RATECOMM,BALANCE,DAMTACR,DAMTLASTDT,
                                             IAMTACR, IAMTLASTDT,DIRECTACR,INDIRECTACR,ODFEETYPE,ODFEERATE,COMMTYPE,LASTCOMMDATE)
                         SELECT  rec.fureacctno ACCTNO ,substr(rec.fureacctno,1,10) CUSTID,substr(rec.fureacctno,11,4) ACTYPE, 'A' STATUS,'' PSTATUS,
                                             sysdate LAST_CHANGE, RATECOMM, 0 BALANCE, 0 DAMTACR, v_currdate DAMTLASTDT,
                                             0 IAMTACR , v_currdate IAMTLASTDT , 0 DIRECTACR, 0 INDIRECTACR, ODFEETYPE,ODFEERATE,COMMTYPE,v_currdate  LASTCOMMDATE
                         FROM RETYPE WHERE ACTYPE=substr(rec.fureacctno,11,4);
                    End if;
                    ----------------
               End loop;
         End if;--vc.afstatus='O'
        insert into changecfstslog(txdate,custodycd,olddmsts,oldafstatus,oldlastdate,oldactivedate,
               newdmsts,newafstatus,newlastdate,newactivedate)
        values(v_currdate,vc.custodycd,v_olddmsts,v_oldafstatus,v_oldlastdate,v_oldactivedate,
               v_newdmsts,v_newafstatus,v_newlastdate,v_newactivedate);
      End if; --   vc.dmsts='Y'
  */
     -- Cap nhat ngay gd cuoi cung
     Update CFMAST cf
     Set lastdate = v_currdate
     where cf.custodycd = vc.custodycd;
    End loop;
   /*
    -- Danh dau ngu
    insert into changecfstslog(txdate,custodycd,olddmsts,oldafstatus,oldlastdate,oldactivedate,
               newdmsts,newafstatus,newlastdate,newactivedate)
    select v_currdate txdate , custodycd,dmsts,afstatus,lastdate,activedate,
           'Y',afstatus,lastdate,activedate
    from cfmast cf
    where cf.lastdate + v_dmday <= v_currdate
         and dmsts='N';
    Update cfmast cf
    Set dmsts='Y'
    Where  cf.lastdate + v_dmday <= v_currdate
         and dmsts='N';
   */
    -- Rut tieu khoan khoi MG CSH  khi  MG ko care tieu khoan do nua
    For vc in(Select * from reaflnk where status='A' and orgreacctno is not null)
    Loop
         v_close:=true;
         For rec in(select * from reaflnk
                   where reacctno=vc.orgreacctno
                           and afacctno=vc.afacctno
                           and  status='A')
         Loop
                v_close:=false;
         End loop;
         if v_close then
            update reaflnk
            set status='C',
            clstxdate = v_currdate
            where autoid=vc.autoid;
         end if;
    End loop;

   COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        return ;
END; -- Procedure
PROCEDURE re_changerev(acclist in  varchar2,rate in varchar2,gor in varchar2,ip in varchar2, tlid in varchar2, brid varchar2) is
 v_currdate date;
BEGIN
    Select to_date(varvalue,'dd/mm/yyyy') into v_currdate
    From sysvar
    Where varname='CURRDATE' and grname='SYSTEM';

    If gor = 'REMISER' THEN
        Update REREVLOG
        Set status = 'C'
        where instr(acclist,'|'||AUTOID||'|')>0 and gor='R';
        insert into rerevlog(
                             txdate,
                             tlid,
                             status,
                             Custid ,
                             rate,
                             gor,
                             ip,brid,
                             AUTOID
                            )
         Select  v_currdate txdate,
                  tlid,
                 'A' status,
                 custid,
                to_number(rate) rate,
                'R' gor,
                ip,brid,
                AUTOID
         From recflnk
         Where instr(acclist,'|'||AUTOID||'|')>0;
    ELSE
        Update REREVLOG
        Set status = 'C'
        where instr(acclist,'|'||AUTOID||'|')>0 and gor='G';
        insert into rerevlog(
                             txdate,
                             tlid,
                             status,
                             Custid ,
                             rate,
                             gor ,ip,brid,
                             AUTOID
                            )
         Select  v_currdate txdate,
                  tlid,
                 'A' status,
                 custid,
                to_number(rate) rate,
                'G' gor,
                ip,brid,AUTOID
         From regrp
         Where instr(acclist,'|'||AUTOID||'|')>0;
    END IF;
    COMMIT;

END; -- Procedure
FUNCTION fn_re_getcommision(strACCTNO IN varchar2,P_REVENUE NUMBER)
  RETURN  number
  IS
  l_COMMISION  number(20,4);
  l_BASEDACR  number(20,4);
  l_AUTOID    number(20,0);
  l_ACTYPE    VARCHAR2(4);
  l_RULETYPE  VARCHAR2(10);
  l_PERIOD    VARCHAR2(10);
  l_ICTYPE    VARCHAR2(10);
  l_DELTA    number(20,4);
  l_FLAT    number(20,4);
  l_ICRATE    number(20,4);
  l_MINVAL    number(20,4);
  l_MAXVAL    number(20,4);
  l_FLRATE    number(20,4);
  l_CERATE    number(20,4);
  v_baseacr number(20,4);
  v_revenue number(20,4);
BEGIN
  l_COMMISION :=0;
  l_BASEDACR:=P_REVENUE;
    --GET REMAST ATRIBUTES
    SELECT  TYP.ACTYPE,
    IC.AUTOID, IC.RULETYPE, IC.PERIOD, IC.ICTYPE, IC.ICFLAT, IC.ICRATE, IC.MINVAL, IC.MAXVAL, IC.FLRATE, IC.CERATE
    into  l_ACTYPE, l_AUTOID, l_RULETYPE, l_PERIOD, l_ICTYPE, l_FLAT, l_ICRATE, l_MINVAL, l_MAXVAL, l_FLRATE, l_CERATE
    FROM REMAST MST, RETYPE TYP, ICCFTYPEDEF IC
  WHERE MST.ACCTNO = strACCTNO AND MST.ACTYPE=TYP.ACTYPE
    AND IC.MODCODE='RE' AND IC.EVENTCODE='CALFEECOMM' AND IC.ICCFSTATUS='A' AND IC.ACTYPE=MST.ACTYPE;

  if l_RULETYPE='S' OR l_RULETYPE='F' then
    if l_ICTYPE='F' then
      l_COMMISION := l_FLAT;
    elsif l_ICTYPE='P' then
      l_COMMISION := l_ICRATE/100*P_REVENUE;
      if l_COMMISION < l_MINVAL and l_MINVAL>0 then
        l_COMMISION := l_MINVAL;
      end if;
      if l_COMMISION > l_MAXVAL and l_MAXVAL>0 then
        l_COMMISION := l_MAXVAL;
      end if;
    end if;
  elsif l_RULETYPE='T' then
  l_DELTA:=0;
   Begin
    SELECT DELTA INTO l_DELTA
    FROM ICCFTIER WHERE MODCODE='RE' AND EVENTCODE='CALFEECOMM' AND ICCFSTATUS='A'
      AND ACTYPE=l_ACTYPE AND l_BASEDACR>=FRAMT AND l_BASEDACR<TOAMT;
   EXCEPTION
   when OTHERS then
       l_DELTA:=0;
   End;
    l_COMMISION := (l_ICRATE+l_DELTA)/100*P_REVENUE;
    if l_COMMISION < l_MINVAL and l_MINVAL>0 then
      l_COMMISION := l_MINVAL;
    end if;
    if l_COMMISION > l_MAXVAL and l_MAXVAL>0 then
      l_COMMISION := l_MAXVAL;
    end if;
  elsif l_RULETYPE='C' then
     v_baseacr:=P_REVENUE;
     v_revenue:=P_REVENUE;
     l_COMMISION:=0;
     l_DELTA:=0;
     Begin
         SELECT count(1) into  l_DELTA
         FROM ICCFTIER WHERE MODCODE='RE' AND EVENTCODE='CALFEECOMM' AND ICCFSTATUS='A'
         AND ACTYPE=l_ACTYPE;
     EXCEPTION
     when OTHERS then
       l_DELTA:=0;
     End;

     IF l_DELTA=0 then -- khong khai bao tier
         l_COMMISION:= (l_ICRATE/100)* P_REVENUE;
     Else
         For vc in(SELECT framt, toamt,delta
                   FROM ICCFTIER WHERE MODCODE='RE' AND EVENTCODE='CALFEECOMM' AND ICCFSTATUS='A'
                   AND ACTYPE=l_ACTYPE
                   --and framt >=p_BASEDACR
                   ORDER BY framt ) loop
             If v_baseacr >0  then
                l_COMMISION:=l_COMMISION + ((l_ICRATE+vc.DELTA)/100 ) *  (least(v_baseacr,vc.toamt  - vc.framt) / P_REVENUE)*P_REVENUE;

                /*dbms_output.put_line(' framt = '||vc.framt);
                dbms_output.put_line(' toamt = '||vc.toamt);
                dbms_output.put_line(' l_ICRATE = '||l_ICRATE);
                 dbms_output.put_line(' DELTA = '||vc.DELTA);
                dbms_output.put_line(' reate = '||(l_ICRATE+vc.DELTA)/100);
                dbms_output.put_line(' DS = '||least(v_baseacr,vc.toamt  - vc.framt));
                dbms_output.put_line(' COMM = '||((l_ICRATE+vc.DELTA)/100 ) *  (least(v_baseacr,vc.toamt  - vc.framt) / p_BASEDACR)*P_REVENUE);
                */
                v_baseacr:=v_baseacr-least(v_baseacr,vc.toamt  - vc.framt);
             End if;
         End loop;
     end if;
  end if;

    RETURN l_COMMISION;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
FUNCTION fn_re_gettax(strcustid IN varchar2, p_BASEDACR number)
  RETURN  number
  IS
  l_TAX  number(20,4);
  l_BASEDACR  number(20,4);
  l_AUTOID    number(20,0);
  l_ACTYPE    VARCHAR2(4);
  l_RULETYPE  VARCHAR2(10);
  l_PERIOD    VARCHAR2(10);
  l_ICTYPE    VARCHAR2(10);
  l_DELTA    number(20,4);
  l_FLAT    number(20,4);
  l_ICRATE    number(20,4);
  l_MINVAL    number(20,4);
  l_MAXVAL    number(20,4);
  l_FLRATE    number(20,4);
  l_CERATE    number(20,4);
  v_baseacr number(20,4);

BEGIN
  l_TAX :=0;
  l_BASEDACR:=p_BASEDACR;
    --GET  ATRIBUTES
    SELECT  ic.ACTYPE,
    IC.AUTOID, IC.RULETYPE, IC.PERIOD, IC.ICTYPE, IC.ICFLAT, IC.ICRATE, IC.MINVAL, IC.MAXVAL, IC.FLRATE, IC.CERATE
    into  l_ACTYPE, l_AUTOID, l_RULETYPE, l_PERIOD, l_ICTYPE, l_FLAT, l_ICRATE, l_MINVAL, l_MAXVAL, l_FLRATE, l_CERATE
    FROM recflnk MST, RETAX  IC
  WHERE MST.custid= strcustid
       AND MST.taxTYPE=IC.ACTYPE
       AND IC.MODCODE='RE' AND IC.EVENTCODE='RETAX' AND IC.ICCFSTATUS='A' ;

  if l_RULETYPE='S' OR l_RULETYPE='F' then
    if l_ICTYPE='F' then
      l_TAX := l_FLAT;
    elsif l_ICTYPE='P' then
      l_TAX := l_ICRATE/100*l_BASEDACR;
      if l_TAX < l_MINVAL and l_MINVAL>0 then
        l_TAX := l_MINVAL;
      end if;
      if l_TAX > l_MAXVAL and l_MAXVAL>0 then
        l_TAX := l_MAXVAL;
      end if;
    end if;
  elsif l_RULETYPE='T' then
  l_DELTA:=0;
   Begin
    SELECT DELTA INTO l_DELTA
    FROM ICCFTIER WHERE MODCODE='RE' AND EVENTCODE='RETAX' AND ICCFSTATUS='A'
      AND ACTYPE=l_ACTYPE AND l_BASEDACR>=FRAMT AND l_BASEDACR<=TOAMT;
   EXCEPTION
   when OTHERS then
       l_DELTA:=0;
   End;
    l_TAX := (l_ICRATE+l_DELTA)/100*l_BASEDACR;
    if l_TAX < l_MINVAL and l_MINVAL>0 then
      l_TAX := l_MINVAL;
    end if;
    if l_TAX > l_MAXVAL and l_MAXVAL>0 then
      l_TAX := l_MAXVAL;
    end if;
  elsif l_RULETYPE='C' then
     v_baseacr:=p_BASEDACR;

     l_TAX:=0;
     l_DELTA:=0;
     Begin
         SELECT count(1) into  l_DELTA
         FROM ICCFTIER WHERE MODCODE='RE' AND EVENTCODE='RETAX' AND ICCFSTATUS='A'
         AND ACTYPE=l_ACTYPE;
     EXCEPTION
     when OTHERS then
       l_DELTA:=0;
     End;

     IF l_DELTA=0 then -- khong khai bao tier
         l_TAX:= (l_ICRATE/100)* l_BASEDACR;
     Else
         For vc in(SELECT framt, toamt,delta
                   FROM ICCFTIER WHERE MODCODE='RE' AND EVENTCODE='RETAX' AND ICCFSTATUS='A'
                   AND ACTYPE=l_ACTYPE
                   --and framt >=p_BASEDACR
                   ORDER BY framt ) loop
             If v_baseacr >0  then
                l_TAX:=l_TAX + ((l_ICRATE+vc.DELTA)/100 ) *  (least(v_baseacr,vc.toamt  - vc.framt) );

                /*dbms_output.put_line(' framt = '||vc.framt);
                dbms_output.put_line(' toamt = '||vc.toamt);
                dbms_output.put_line(' l_ICRATE = '||l_ICRATE);
                 dbms_output.put_line(' DELTA = '||vc.DELTA);
                dbms_output.put_line(' reate = '||(l_ICRATE+vc.DELTA)/100);
                dbms_output.put_line(' DS = '||least(v_baseacr,vc.toamt  - vc.framt));
                dbms_output.put_line(' COMM = '||((l_ICRATE+vc.DELTA)/100 ) *  (least(v_baseacr,vc.toamt  - vc.framt) / p_BASEDACR)*P_REVENUE);
                */
                v_baseacr:=v_baseacr-least(v_baseacr,vc.toamt  - vc.framt);
             End if;
         End loop;
     end if;
  end if;

    RETURN l_TAX;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
PROCEDURE pr_reCALFEECOMM(p_bchmdl varchar,p_err_code  OUT varchar2)
  IS
      v_currdate date;
      v_nextdate date;
      v_lastday number(20);-- Ngay lam viec cuoi cung cua thang
      v_BMdays number(20);-- So ngay hoat dong cua moi gioi
      V_commdays number(20);  -- So ngay cua ky tinh hoa hong
      v_lastcustid varchar2(20);
      v_disacr number(20,4);  -- Dinh muc cua moi gio, bi tru dan sau khi phan bo cho tai khoan moi gioi
      v_disdirectacr number(20,4);-- Phan doanh so dc tinh hoa hong cua tk moi gioi (= Doanh so - Dinh muc)
      v_revenue number(20,4); -- Doanh thu cua tai khoan mg
      v_commision number(20,4);-- Hoa Hong cua tk moi gio
      v_mindrevamtreal number(20,4);-- Dinh muc truc tiep thuc te = Dinh muc truc tiep * So ngay MG hoat dong / So ngay cua thang
      v_minirevamtreal number(20,4);-- Dinh muc gian tiep thuc te = Dinh muc gian tiep * So ngay MG hoat dong / So ngay cua thang
      v_rffeeacr number(20,4);   -- Phi giam tru theo doanh thu phan bo
      v_rfmatchamt number(20,4);  -- phi giam tru theo doanh so phan bo
      v_groupcommision number(20,4); -- Hoa hong cua nhom
      v_memcommision number(20,4); -- Hoa hong cua truong nhom phu
      v_reacctno varchar2(14); --tai khoan moi gioi
      pkgctx plog.log_ctx;
      l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      v_strDesc varchar2(1000);
      v_strEN_Desc varchar2(1000);
      v_strOrgDesc varchar2(1000);
      v_strEN_OrgDesc varchar2(1000);
      l_err_param varchar2(300);
      v_perioddate date;
      v_autoid number;
      v_DSFCOM number;-- Phan hoa hong da tra cho DSF khau tru vao doanh thu cuar SP
      v_MGCOM number;  -- phan hoa hong moi gioi khong bi tinh phi DSF

  BEGIN
    plog.setbeginsection(pkgctx, 'pr_reCALFEECOMM');
     SELECT TO_DATE (varvalue, systemnums.c_date_format)
               INTO v_currdate
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    SELECT TO_DATE (varvalue, systemnums.c_date_format)
               INTO v_nextdate
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'NEXTDATE';
   --Xac dinh ngay cuoi cung cua thang
    select to_number(to_char(max(sbdate),'DD')) into v_lastday from sbcldr where  to_char(sbdate,'MM/YYYY')= to_char(v_CURRDATE,'MM/YYYY') and cldrtype ='000';

    delete recommision WHERE COMMDATE=v_currdate;
    v_lastcustid :='ZZZZZ';
    v_disacr :=0;
    -- Tinh Hoa Hong Truc Tiep
    For vc in (select rcl.autoid,
                       rcl.custid,
                       RCL.effdate ,
                       RCL.mindrevamt, -- dinh muc doanh so truc tiep
                       rcl.minirevamt, -- dinh muc doanh so gian tiep
                       rcl.minincome , -- luong toi thieu
                       rcl.minratesal, -- ti le huong luong toi thieu khi ko hoan thanh dinh muc
                       rcl.saltype,    -- Kieu tinh luong toi thieu
                       rcd.reactype,
                       rty.rerole,
                        -- Chi RM,BM chiu dinh muc
                       Case when
                           rty.rerole in ('RM','BM') then rcd.isdrev
                           else 'N'
                       end  isdrev, -- Co chiu luat dinh muc hay khong
                       rcd.odrnum ,-- thu tu phan bo dinh muc
                       rm.acctno, -- tk moi gioi
                       rm.directacr, -- Doanh so truc tiep
                       rm.directfeeacr,-- Doanh thu truc tiep
                       rm.indirectacr,-- Doanh so gian tiep
                       rm.indirectfeeacr,-- Doanh thu gian tiep
                       rm.odfeetype, -- Cach tinh dua tren phi thuc thu hay phi co dinh M/F
                       rm.odfeerate, -- ti le phi co dinh
                       rm.rfmatchamt, -- Giam tru doanh so
                       rm.rffeeacr, -- Giam tru doanh thu
                       rm.lmn, -- Gia tri phat vay bao lanh
                       rm.disposal, -- Gia tri lenh giai chap
                       nvl(rlog.rate,0) revrate, -- ty le dieu chinh dinh muc
                       icd.period,
                       icd.periodday,
                       icd.perioddate,
                       RCD.ISPAYDSF

                from recflnk rcl, recfdef rcd, retype rty, remast rm,
                (select * from rerevlog where status='A' and gor='R'  )  rlog,
                (SELECT actype, period, periodday,
                        to_date((case when periodday>v_lastday or periodday<1 then v_lastday else periodday end)  || '/' || to_char(v_CURRDATE,'MM/RRRR'), 'DD/MM/RRRR') perioddate
                FROM iccftypedef ic
                WHERE ic.EVENTCODE='CALFEECOMM'
                   and ((ic.period ='M' and to_char(v_CURRDATE,'MM') <> to_char(v_NEXTDATE,'MM')) --Monthly, Ngay cuoi thang
                            or (ic.period ='S'
                                and to_date((case when periodday>v_lastday or periodday<1 then v_lastday else periodday end)  || '/' || to_char(v_CURRDATE,'MM/RRRR'), 'DD/MM/RRRR')>=v_CURRDATE
                                and to_date((case when periodday>v_lastday or periodday<1 then v_lastday else periodday end) || '/' || to_char(v_CURRDATE,'MM/RRRR'), 'DD/MM/RRRR')<v_NEXTDATE
                                ) --Ngay hien tai la ngay lam viec gan ngay thu lai co dinh nhat
                       )) ICD
                where rcd.refrecflnkid=rcl.autoid
                and rcd.reactype=rty.actype
                and rty.retype='D' --and rty.rerole in('RM','BM','RD')
                and rcl.custid=rm.custid
                and rcd.reactype=rm.actype
                and rty.actype= icd.actype
                and rcl.autoid = rlog.autoid(+)
                order by decode(rty.rerole,'RD',0,1),rcl.custid, rcd.odrnum
                -- Tinh HH cho DSF truoc, SP tinh sau
                )
    Loop
        If v_lastcustid <> vc.custid then
            v_lastcustid :=vc.custid;
            -- Dinh muc thuc te = Dinh muc khai bao * so ngay hoat dong cua moi gioi / so ngay cua ky tinh hoa hong
            If vc.saltype='1' then -- tron thang
                V_commdays:=LAST_DAY(v_currdate)  - trunc(v_currdate,'MM') + 1;
                v_BMdays:=V_commdays;
            Else -- tinh theo ngay thuc te
               IF vc.period = 'M' then-- tinh hang thang
                    V_commdays:=LAST_DAY(v_currdate) - trunc(v_currdate,'MM') + 1;
                    v_BMdays:=LAST_DAY(v_currdate) - greatest(vc.effdate,trunc(v_currdate,'MM')) + 1;
               else              -- tinh vao ngay co dinh
                    V_commdays:=vc.perioddate - ADD_MONTHS(vc.perioddate,-1);
                    v_BMdays:=vc.perioddate - greatest(vc.effdate,ADD_MONTHS(vc.perioddate,-1)+1 ) +1 ;
              End if;
            End if;
            v_disacr :=vc.mindrevamt * (1 + vc.revrate/100) * v_BMdays / V_commdays;
            v_mindrevamtreal:=v_disacr;
        End if;
        v_DSFCOM:= 0;
        If vc.rerole  in ('BM','RM') AND VC.ISPAYDSF = 'Y' then
        -- Neu la SP thi phai tru HH da tinh cho DFS
           For rec in(
                   Select sum(
                                 (r.feeacr - r.rfmatchamt - r.rffeeacr)* c.commision
                               / (c.directfeeacr-c.rfmatchamt - c.rffeeacr+0000000.1)
                               ) DSFCOM
                   From   rerevdg r, recommision c
                   Where   r.reacctno=vc.acctno
                          and r.status='A'
                          and r.commdate is null
                          and r.orgreacctno = c.acctno
                          and c.commdate = v_currdate
                          and c.directfeeacr > 0
                  )
            Loop
              v_DSFCOM:= nvl(rec.DSFCOM,0);
            End loop;
            For rec in(
                   Select r.autoid,(r.feeacr - r.rfmatchamt - r.rffeeacr)* c.commision
                               / (c.directfeeacr-c.rfmatchamt - c.rffeeacr+0000000.1) DSFCOM
                   From   rerevdg r, recommision c
                   Where   r.reacctno=vc.acctno
                          and r.status='A'
                          and r.commdate is null
                          and r.orgreacctno = c.acctno
                          and c.commdate = v_currdate
                          and c.directfeeacr > 0
                  )
             Loop
                        Update rerevdg set commision = rec.DSFCOM ,
                               status ='C',
                               commdate = v_currdate
                        Where autoid= rec.autoid;
            End loop;
        End if;
        -- Tinh hoa hong dua tren dinh muc doanh thu
         If  vc.isdrev ='Y' then
            v_disdirectacr:=GREATEST(vc.directfeeacr - v_DSFCOM - vc.rfmatchamt - vc.rffeeacr  -v_disacr,0);--  doanh thu phan bo

        Else
            v_disdirectacr:=vc.directfeeacr- v_DSFCOM - vc.rfmatchamt - vc.rffeeacr;
        End if;


        v_revenue := vc.directfeeacr- v_DSFCOM - vc.rfmatchamt - vc.rffeeacr;

        v_commision :=fn_re_getcommision(vc.acctno,v_disdirectacr);

      /*  dbms_output.put_line('----------');
        dbms_output.put_line(' acctno= '||vc.acctno);
        dbms_output.put_line('   v_revenue ='||v_revenue);
        dbms_output.put_line('   v_commision = '||v_commision);  */

        Insert into recommision(autoid,refrecflnkid, custid, mindrevamt,minirevamt, minincome,
                   minratesal, saltype, reactype, isdrev, odrnum,
                   acctno, directacr, directfeeacr, indirectacr,
                   indirectfeeacr, odfeetype, odfeerate, commdate,
                   disdirectacr, disrevacr,revenue,commision,retype,
                   mindrevamtreal,minirevamtreal,bmdays,commdays,rfmatchamt,rffeeacr,disrfmatchamt,disrffeeacr,lmn,disposal,revrate,DSFCOM)
        Values(seq_recommision.nextval,vc.autoid, vc.custid, vc.mindrevamt,vc.minirevamt, vc.minincome,
                 vc.minratesal, vc.saltype, vc.reactype, vc.isdrev, vc.odrnum,
                 vc.acctno, vc.directacr, vc.directfeeacr, vc.indirectacr,
                 vc.indirectfeeacr, vc.odfeetype, vc.odfeerate, v_currdate,
                 v_disdirectacr, DECODE(vc.isdrev,'Y',v_disacr,0),v_revenue,v_commision,'D',
                 v_mindrevamtreal,0,v_BMdays,V_commdays,vc.rfmatchamt,vc.rffeeacr,v_rfmatchamt,v_rffeeacr,vc.lmn,vc.disposal,vc.revrate,v_DSFCOM );

        If  vc.isdrev ='Y' then
              v_disacr:=v_disacr - LEAST(v_disacr,vc.directfeeacr - vc.rfmatchamt - vc.rffeeacr);
        End if;
    End loop;
 dbms_OUTPUT.PUT_LINE(' TINH XONG HH TT');

    -- Tinh Hoa Hong Gian Tiep
   For VC in (select   rcl.autoid,
                       rcl.custid,
                       rcl.mindrevamt, --dInh muc doanh so truc tiep
                       RCL.effdate ,
                       rcl.minirevamt,
                       rcl.minincome , -- luong toi thieu
                       rcl.minratesal, -- ti le huong luong toi thieu khi ko hoan thanh dinh muc
                       rcl.saltype,    -- Kieu tinh luong toi thieu
                       rcl.actype,
                       'Y' isdrev, -- Co chiu luat dinh muc hay khong
                        0 odrnum ,-- thu tu phan bo dinh muc
                       rm.acctno, -- tk moi gioi
                       rm.directacr, -- Doanh so truc tiep
                       rm.directfeeacr,-- Doanh thu truc tiep
                       rm.indirectacr,-- Doanh so gian tiep
                       rm.indirectfeeacr,-- Doanh thu gian tiep
                       rm.odfeetype, -- Cach tinh dua tren phi thuc thu hay phi co dinh M/F
                       rm.odfeerate, -- ti le phi co dinh
                       rm.inrfmatchamt, -- Giam tru doanh so
                       rm.inrffeeacr, -- Giam tru doanh thu
                       rm.inlmn, -- Gia tri phat vay bao lanh
                       rm.indisposal, -- Gia tri lenh giai chap
                       nvl(rlog.rate,0) revrate, -- ty le dieu chinh dinh muc
                       icd.period,
                       icd.periodday,
                       icd.perioddate
                from regrp rcl,  retype rty, remast rm,
                    (select * from rerevlog where status='A' and gor='G'  ) rlog,
                    (SELECT actype,period, periodday,
                            to_date((case when periodday>v_lastday or periodday<1 then v_lastday else periodday end)
                            || '/' || to_char(v_CURRDATE,'MM/RRRR'), 'DD/MM/RRRR') perioddate
                        FROM iccftypedef ic
                        WHERE ic.EVENTCODE='CALFEECOMM'
                        and ((ic.period ='M' and to_char(v_CURRDATE,'MM') <> to_char(v_NEXTDATE,'MM')) --Monthly, Ngay cuoi thang
                            or (ic.period ='S'
                                and to_date((case when periodday>v_lastday or periodday<1 then v_lastday else periodday end)  || '/' || to_char(v_CURRDATE,'MM/RRRR'), 'DD/MM/RRRR')>=v_CURRDATE
                                and to_date((case when periodday>v_lastday or periodday<1 then v_lastday else periodday end) || '/' || to_char(v_CURRDATE,'MM/RRRR'), 'DD/MM/RRRR')<v_NEXTDATE
                                ) --Ngay hien tai la ngay lam viec gan ngay thu lai co dinh nhat
                            )
                    ) ICD
                where rcl.custid=rm.custid
                and rcl.actype=rm.actype
                and rcl.actype=rty.actype
                and rty.retype='I'
                and rty.actype=icd.actype
                and rcl.autoid=rlog.autoid(+)
                order by rcl.autoid, rcl.custid)
     Loop

         -- Dinh muc thuc te = Dinh muc khai bao * so ngay hoat dong cu moi gioi / so ngay cua ky tinh Hoa hong
            If vc.saltype='1' then -- tron thang
                V_commdays:=LAST_DAY(v_currdate)  - trunc(v_currdate,'MM') + 1;
                v_BMdays:=V_commdays;
            Else -- tinh theo ngay thuc te
               IF vc.period = 'M' then-- tinh hang thang
                    V_commdays:=LAST_DAY(v_currdate) - trunc(v_currdate,'MM') + 1;
                    v_BMdays:=LAST_DAY(v_currdate) - greatest(vc.effdate,trunc(v_currdate,'MM')) + 1;
               else              -- tinh vao ngay co dinh
                    V_commdays:=vc.perioddate - ADD_MONTHS(vc.perioddate,-1);
                    v_BMdays:=vc.perioddate - greatest(vc.effdate,ADD_MONTHS(vc.perioddate,-1)+1 ) +1 ;
              End if;
            End if;
            v_disacr :=vc.minirevamt * (1 + vc.revrate/100) * v_BMdays / V_commdays;
            v_minirevamtreal:=v_disacr;

        --
        for llc in (
                    select  r.autoid,((r.feeacr - r.rfmatchamt -r.rffeeacr) * c.commision
                            / (c.directfeeacr-c.rfmatchamt - c.rffeeacr+0000000.1)) T_BRGBM
                    from regrpbmcom r, recommision c
                    where r.reacctno = c.acctno and r.leadreacctno = vc.acctno
                    and r.grpautoid = vc.autoid and r.status = 'A'
                    and c.commdate = v_currdate and r.commdate is null
                    and c.directfeeacr > 0
                   )
        loop
                 update regrpbmcom set
                 commision = llc.T_BRGBM,
                 status = 'C',
                 commdate = v_currdate
                 where autoid = llc.autoid;
        end loop;

        v_DSFCOM := 0;
        v_MGCOM := 0;

        --hoa hong DSF cua moi gioi thuoc nhom co ISPAYDSF = 'Y'
        begin
           SELECT nvl(sum((m.feeacr - m.rfmatchamt - m.rffeeacr) * nvl(d.commision,0)
                   /
                   (c.directfeeacr-c.rfmatchamt - c.rffeeacr+0000000.1)),0) into v_DSFCOM
           FROM
           REGRPBMCOM M, --doanh thu moi gioi theo nhom
           recommision c, --tong doanh thu cua moi gioi
           (select reacctno, sum(commision) commision from  rerevdg where commdate = v_currdate group by reacctno ) d,-- doanh thu tra dsf
           recfdef rc, recflnk rl
           WHERE M.REACCTNO = c.acctno and c.acctno = d.reacctno
           and c.commdate = v_currdate and m.commdate = v_currdate
           and rc.refrecflnkid = rl.autoid and rl.custid || rc.reactype = c.acctno and rc.ispaydsf = 'Y'
           and m.grpautoid = vc.autoid and m.leadreacctno = vc.acctno;
        exception when others then
            v_DSFCOM:=0;
        end;

        --hoa hong MG khong giam tru DSF, ISPAYDSF = 'N'
        begin
            select sum(nvl(m.commision,0)) into v_MGCOM
            from regrpbmcom m, recflnk rl, recfdef rd
            where m.commdate = v_currdate
            and rl.autoid = rd.refrecflnkid and m.reacctno = rl.custid || rd.reactype and rd.ispaydsf = 'N'
            and m.leadreacctno = vc.acctno and m.grpautoid = vc.autoid;
        exception when others then
            v_MGCOM:= 0;
        end;

        v_disdirectacr:=GREATEST(vc.indirectfeeacr-vc.inrfmatchamt- vc.inrffeeacr - v_disacr - v_DSFCOM - v_MGCOM,0);

        v_revenue := v_disdirectacr;

        v_commision:=fn_re_getcommision(vc.acctno,v_revenue);
        v_groupcommision := v_commision;
        /*-- Phan bo hoa hong cho cac truong nhom phu
        For rec in (Select r.custid, r.rate, r.minincome
                    From regrpleaders R
                    Where r.status ='A'
                      and r.grpid = vc.autoid  )
        Loop
                v_reacctno :=rec.custid||vc.actype; -- Tai khoan moi gioi cua truong nhom phu
                v_memcommision := v_groupcommision * rec.rate /100;
                v_commision:= v_commision - v_memcommision;
                Insert into recommision(autoid,refrecflnkid, custid,mindrevamt, minirevamt, minincome,
                   minratesal, saltype, reactype, isdrev, odrnum,
                   acctno, directacr, directfeeacr, indirectacr,
                   indirectfeeacr, odfeetype, odfeerate, commdate,
                   disdirectacr, disrevacr,revenue,commision,retype,
                   mindrevamtreal,minirevamtreal,bmdays,commdays,inrfmatchamt,inrffeeacr,
                   disrfmatchamt,disrffeeacr,inlmn,indisposal,revrate,grpcommision)
                 Values(seq_recommision.nextval,vc.autoid, rec.custid, vc.mindrevamt,vc.minirevamt, rec.minincome,
                         vc.minratesal, vc.saltype, vc.actype, vc.isdrev, vc.odrnum,
                         v_reacctno, vc.directacr, vc.directfeeacr, vc.indirectacr,
                         vc.indirectfeeacr, vc.odfeetype, vc.odfeerate, v_currdate,
                         v_disdirectacr, v_disacr,v_revenue,v_memcommision,'I',
                         0,v_minirevamtreal,v_BMdays,V_commdays,vc.inrfmatchamt,vc.inrffeeacr,
                         v_rfmatchamt,v_rffeeacr,vc.inlmn,vc.indisposal,vc.revrate,v_groupcommision);

                 Update remast a
                 SET   last_change = sysdate,
                       iamtlastdt = sysdate,
                       indirectacr = nvl(indirectacr,0) + vc.indirectacr,
                       lastcommdate = sysdate ,
                       indirectfeeacr = nvl(indirectfeeacr,0) + vc.indirectfeeacr,
                       inrfmatchamt = nvl(inrfmatchamt,0) + vc.inrfmatchamt,
                       inrffeeacr   = nvl(inrffeeacr,0) + vc.inrffeeacr ,
                       inlmn        =nvl(inlmn,0) + vc.inlmn ,
                       indisposal   = nvl(indisposal,0) + vc.indisposal
                 Where acctno = v_reacctno;

        End loop;*/
         -- Hoa hong con laij cua truong nhom chinh
        Insert into recommision(autoid,refrecflnkid, custid,mindrevamt, minirevamt, minincome,
                   minratesal, saltype, reactype, isdrev, odrnum,
                   acctno, directacr, directfeeacr, indirectacr,
                   indirectfeeacr, odfeetype, odfeerate, commdate,
                   disdirectacr, disrevacr,revenue,commision,retype,
                   mindrevamtreal,minirevamtreal,bmdays,commdays,inrfmatchamt,inrffeeacr,
                   disrfmatchamt,disrffeeacr,inlmn,indisposal,revrate,grpcommision, DSFCOMREDUCTION, BRCOMREDUCTION)
         Values(seq_recommision.nextval,vc.autoid, vc.custid, vc.mindrevamt,vc.minirevamt, vc.minincome,
                 vc.minratesal, vc.saltype, vc.actype, vc.isdrev, vc.odrnum,
                 vc.acctno, vc.directacr, vc.directfeeacr, vc.indirectacr,
                 vc.indirectfeeacr, vc.odfeetype, vc.odfeerate, v_currdate,
                 v_disdirectacr, v_disacr,v_revenue,v_commision,'I',
                 0,v_minirevamtreal,v_BMdays,V_commdays,vc.inrfmatchamt,vc.inrffeeacr,
                 v_rfmatchamt,v_rffeeacr,vc.inlmn,vc.indisposal,vc.revrate,v_groupcommision,v_DSFCOM, V_MGCOM );
     End Loop; -- TINH HOA HONG GIAN TIEP
 dbms_OUTPUT.PUT_LINE(' TINH XONG HH gT');
    --- Chia hoa hong cho moi gio cham soc ho
  /*
    For vc in(  Select rr.autoid,rr.reacctno,rr.orgreacctno,
               rr.feeacr - rr.rfmatchamt-rr.rffeeacr dgfeeacr,
              sum(rc.directfeeacr-rc.rfmatchamt - rc.rffeeacr ) directfeeacr,
               sum(rc.commision) commision, MAX(RC.COMMDAYS) COMMDAYS, MAX(RC.BMDAYS) BMDAYS
                from rerevdg rr, recommision rc
                where
                     rr.status='A' and rr.commdate is null
                    and rc.commdate =v_currdate
                    and substr(rr.orgreacctno,1,10) = rc.custid
                    and rc.retype='D'
                group by  rr.autoid,rr.reacctno,rr.orgreacctno,rr.feeacr - rr.rfmatchamt-rr.rffeeacr
                )
    Loop
             v_autoid := 0;
             For rec in(
                Select autoid
                from recommision
                where acctno=vc.reacctno and commdate =v_currdate
               )
             Loop
                v_autoid := rec.autoid;
             End loop;
            IF v_autoid <>0 then
                Update recommision
                Set commision = commision + vc.dgfeeacr * vc.commision / (vc.directfeeacr + 0.00000001)
                Where autoid = v_autoid;
            Else
                For rec in(
                        select rcl.autoid,
                               rcl.custid,
                               RCL.effdate ,
                               RCL.mindrevamt, -- dinh muc doanh so truc tiep
                               rcl.minirevamt, -- dinh muc doanh so gian tiep
                               rcl.minincome , -- luong toi thieu
                               rcl.minratesal, -- ti le huong luong toi thieu khi ko hoan thanh dinh muc
                               rcl.saltype,    -- Kieu tinh luong toi thieu
                               rcd.reactype,
                               -- Chi RM,BM chiu dinh muc
                               Case when
                                   rty.rerole in ('RM','BM') then rcd.isdrev
                                   else 'N'
                               end  isdrev, -- Co chiu luat dinh muc hay khong
                               rcd.odrnum ,-- thu tu phan bo dinh muc
                               rm.acctno, -- tk moi gioi
                               rm.directacr, -- Doanh so truc tiep
                               rm.directfeeacr,-- Doanh thu truc tiep
                               rm.indirectacr,-- Doanh so gian tiep
                               rm.indirectfeeacr,-- Doanh thu gian tiep
                               rm.odfeetype, -- Cach tinh dua tren phi thuc thu hay phi co dinh M/F
                               rm.odfeerate, -- ti le phi co dinh
                               rm.rfmatchamt, -- Giam tru doanh so
                               rm.rffeeacr, -- Giam tru doanh thu
                               rm.lmn, -- Gia tri phat vay bao lanh
                               rm.disposal, -- Gia tri lenh giai chap
                               nvl(rlog.rate,0) revrate -- ty le dieu chinh dinh muc
                        from recflnk rcl, recfdef rcd, retype rty, remast rm,
                        (select * from rerevlog where status='A' and gor='R'  )  rlog
                        where rcd.refrecflnkid=rcl.autoid
                        and rcd.reactype=rty.actype
                        and rty.retype='D'
                        and rcl.custid=rm.custid
                        and rcd.reactype=rm.actype
                        and rcl.autoid = rlog.autoid(+)
                        and rm.acctno = vc.reacctno )
                Loop
                        Insert into recommision(autoid,refrecflnkid, custid, mindrevamt,minirevamt, minincome,
                                   minratesal, saltype, reactype, isdrev, odrnum,
                                   acctno, directacr, directfeeacr, indirectacr,
                                   indirectfeeacr, odfeetype, odfeerate, commdate,
                                   disdirectacr, disrevacr,revenue,commision,retype,
                                   mindrevamtreal,minirevamtreal,bmdays,commdays,rfmatchamt,rffeeacr,disrfmatchamt,disrffeeacr,lmn,disposal,revrate)
                        Values(seq_recommision.nextval,rec.autoid, rec.custid, rec.mindrevamt,rec.minirevamt, 0,
                                 rec.minratesal, rec.saltype, rec.reactype, rec.isdrev, rec.odrnum,
                                 rec.acctno, rec.directacr, rec.directfeeacr, rec.indirectacr,
                                 rec.indirectfeeacr, rec.odfeetype, rec.odfeerate, v_currdate,
                                 0, 0,0,vc.dgfeeacr * vc.commision / (vc.directfeeacr + 0.00000001),'D',
                                 rec.mindrevamt,0,VC.BMDAYS,VC.COMMDAYS,rec.rfmatchamt,rec.rffeeacr,rec.rfmatchamt,rec.rffeeacr,rec.lmn,rec.disposal,rec.revrate);
                End loop;
            End if;
            Update rerevdg
            Set commision = vc.dgfeeacr * vc.commision / (vc.directfeeacr + 0.00000001)
            where status='A' and commdate is null and  reacctno=vc.reacctno and orgreacctno=vc.orgreacctno;
    End loop;-- Chia hoa hong cho moi gioi cham soc ho
    */
 dbms_OUTPUT.PUT_LINE(' TINH XONG HH CSH');
    -- Sinh giao dich chot hoa hong
     SELECT TXDESC,EN_TXDESC into v_strOrgDesc, v_strEN_OrgDesc FROM  TLTX WHERE TLTXCD='0320';
     SELECT TO_DATE (varvalue, systemnums.c_date_format)
               INTO v_strCURRDATE
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := systemnums.c_system_userid;
    plog.debug(pkgctx, 'l_txmsg.tlid' || l_txmsg.tlid);
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := p_bchmdl;
    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd:='0320';

    For rec in (select * from recommision r
                where r.commdate=v_currdate
                  and(  r.commision<>0 or r.directacr<>0 or r.indirectacr<>0 )
                  AND TXNUM IS NULL)
    Loop
                     v_strDesc:= v_strOrgDesc;
                    --set txnum
                    SELECT systemnums.C_BATCH_PREFIXED
                                         || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                                  INTO l_txmsg.txnum
                                  FROM DUAL;
                    l_txmsg.brid        := substr(rec.ACCTNO,1,4);

                    --Set cac field giao dich
                    --03   C   so tai khoan moi gioi
                    l_txmsg.txfields ('03').defname   := 'REACCTNO';
                    l_txmsg.txfields ('03').TYPE      := 'C';
                    l_txmsg.txfields ('03').VALUE     := rec.ACCTNO;

                    --20   C   custid moi gio
                    l_txmsg.txfields ('20').defname   := 'RECUSTID';
                    l_txmsg.txfields ('20').TYPE      := 'C';
                    l_txmsg.txfields ('20').VALUE     := rec.custid;

                    --21   C   RECUSTNAME moi gio
                    l_txmsg.txfields ('21').defname   := 'RECUSTNAME';
                    l_txmsg.txfields ('21').TYPE      := 'C';
                    l_txmsg.txfields ('21').VALUE     := '';

                    --10   N   AMT hoa hong
                    l_txmsg.txfields ('10').defname   := 'AMT';
                    l_txmsg.txfields ('10').TYPE      := 'N';
                    l_txmsg.txfields ('10').VALUE     := rec.commision;

                    --11   N   DIRECTACR doanh thu truc tiep
                    l_txmsg.txfields ('11').defname   := 'DIRECTACR';
                    l_txmsg.txfields ('11').TYPE      := 'N';
                    l_txmsg.txfields ('11').VALUE     := rec.DIRECTACR;

                    --12   N   INDIRECTACR doanh thu gian tiep
                    l_txmsg.txfields ('12').defname   := 'INDIRECTACR';
                    l_txmsg.txfields ('12').TYPE      := 'N';
                    l_txmsg.txfields ('12').VALUE     := rec.INDIRECTACR;

                    --13   N   DIRECTFEEACR PHI truc tiep
                    l_txmsg.txfields ('13').defname   := 'DIRECTFEEACR';
                    l_txmsg.txfields ('13').TYPE      := 'N';
                    l_txmsg.txfields ('13').VALUE     := rec.DIRECTFEEACR;
                    -- 14
                    l_txmsg.txfields ('14').defname   := 'INDIRECTFEEACR';
                    l_txmsg.txfields ('14').TYPE      := 'N';
                    l_txmsg.txfields ('14').VALUE     := rec.INDIRECTFEEACR;
                                 -- 22
                    l_txmsg.txfields ('22').defname   := 'RFMATCHAMT';
                    l_txmsg.txfields ('22').TYPE      := 'N';
                    l_txmsg.txfields ('22').VALUE     := rec.RFMATCHAMT;
                    -- 23
                    l_txmsg.txfields ('23').defname   := 'RFFEEACR';
                    l_txmsg.txfields ('23').TYPE      := 'N';
                    l_txmsg.txfields ('23').VALUE     := rec.RFFEEACR;
                    -- 24
                    l_txmsg.txfields ('24').defname   := 'LMN';
                    l_txmsg.txfields ('24').TYPE      := 'N';
                    l_txmsg.txfields ('24').VALUE     := rec.LMN;
                    -- 25
                    l_txmsg.txfields ('25').defname   := 'DISPOSAL';
                    l_txmsg.txfields ('25').TYPE      := 'N';
                    l_txmsg.txfields ('25').VALUE     := rec.DISPOSAL;
                    -- 26
                    l_txmsg.txfields ('26').defname   := 'INRFMATCHAMT';
                    l_txmsg.txfields ('26').TYPE      := 'N';
                    l_txmsg.txfields ('26').VALUE     := rec.inRFMATCHAMT;
                    -- 27
                    l_txmsg.txfields ('27').defname   := 'INRFFEEACR';
                    l_txmsg.txfields ('27').TYPE      := 'N';
                    l_txmsg.txfields ('27').VALUE     := rec.inRFFEEACR;
                    -- 28
                    l_txmsg.txfields ('28').defname   := 'INLMN';
                    l_txmsg.txfields ('28').TYPE      := 'N';
                    l_txmsg.txfields ('28').VALUE     := rec.inLMN;
                    -- 29
                    l_txmsg.txfields ('29').defname   := 'INDISPOSAL';
                    l_txmsg.txfields ('29').TYPE      := 'N';
                    l_txmsg.txfields ('29').VALUE     := rec.inDISPOSAL;

                    --30   C   DESC
                    l_txmsg.txfields ('30').defname   := 'T_DESC';
                    l_txmsg.txfields ('30').TYPE      := 'C';
                    l_txmsg.txfields ('30').VALUE :=v_strDESC;

                    BEGIN
                        IF txpks_#0320.fn_batchtxprocess (l_txmsg,
                                                         p_err_code,
                                                         l_err_param
                           ) <> systemnums.c_success
                        THEN
                           plog.debug (pkgctx,
                                       'got error 0320: ' || p_err_code
                           );
                           ROLLBACK;
                           RETURN;
                        END IF;
                   END;
                   Update recommision
                   set txnum=l_txmsg.txnum,
                       txdate=l_txmsg.txdate
                   where autoid=rec.autoid;
                    -- Cap nhat lai bang dieu chinh dinh muc
                   Update rerevlog set status='U' where status='A' and autoid=rec.refrecflnkid;
       End loop;  -- Sinh giao dich tra hoa hong
 dbms_OUTPUT.PUT_LINE('SINH GD CHOT  HH XONG');
       -- tinh luong co ban cho moi gio
        Delete resalary where commdate=v_currdate;
        /*Moi MG truc tiep BM,RM chi co mot dong trong resalary
          Moi MG truc tiep DG co mot dong trong resalary
          Moi MG gian tiep co mot dong trong resalary
        */
        For vc in(
             Select rc.COmMDATE,RC.CUSTID,rc.retype,rc.mindrevamt,RC.minirevamt,
            RC.minincome,RC.minratesal ,RC.saltype ,rc.mindrevamtreal,rc.minirevamtreal,rc.bmdays,rc.commdays,

             SUM(directacr) directacr,
             SUM(directfeeacr) directfeeacr,
            SUM(indirectacr) indirectacr,
            SUM(indirectfeeacr) indirectfeeacr,
            SUM(revenue) revenue,
            SUM(commision) commision,
            SUM ( RFMATCHAMT) RFMATCHAMT,
            SUM(RFFEEACR) RFFEEACR,
            SUM(LMN) LMN,
            SUM(DISPOSAL) DISPOSAL,
            SUM (INRFMATCHAMT) INRFMATCHAMT,
            SUM(INRFFEEACR) INRFFEEACR,
            SUM(INLMN) INLMN,
            SUM(INDISPOSAL) INDISPOSAL,
            Case
                 WHEN  rc.retype = 'D' AND rc.minratesal>0 then
                  rc.minincome * LEAST(1,GREATEST(rc.minratesal/100,sum(rc.directfeeacr)/(rc.mindrevamtreal+0.00001))) * rc.bmdays /rc.commdays
                 WHEN  rc.retype = 'D' AND rc.minratesal=0 AND sum(rc.directfeeacr)>=rc.mindrevamtreal then rc.minincome* rc.bmdays /rc.commdays
                 WHEN  rc.retype = 'D' AND rc.minratesal=0 AND sum(rc.directfeeacr)<rc.mindrevamtreal then 0

                 When  rc.retype='I' AND rc.minratesal>0 then
                       rc.minincome * LEAST(1,GREATEST(rc.minratesal/100,sum(rc.indirectfeeacr)/(rc.minirevamtreal+0.00001))) * rc.bmdays /rc.commdays
                 When  rc.retype='I' AND rc.minratesal= 0 AND sum(rc.indirectfeeacr)>=rc.minirevamtreal then rc.minincome * rc.bmdays /rc.commdays
                 When  rc.retype='I' AND rc.minratesal= 0 AND sum(rc.indirectfeeacr)< rc.minirevamtreal then 0
            End Salary,
            'N' ISDG
            from recommision rc, retype rty
            where rc.commdate=v_currdate
             and rc.reactype=rty.actype
            AND  (rc.retype='I'
                   or
                   rc.retype='D' and rty.rerole in('BM','RM','RD')
                   )
            GROUP BY  RC.COMmDATE,RC.CUSTID,rc.retype,RC.mindrevamt,RC.minirevamt,
            RC.minincome,RC.minratesAL,RC.saltype ,rc.mindrevamtreal,rc.minirevamtreal,rc.bmdays,rc.commdays
            Union all
             Select rc.COmMDATE,RC.CUSTID,rc.retype,rc.mindrevamt,RC.minirevamt,
            RC.minincome,RC.minratesal ,RC.saltype ,rc.mindrevamtreal,rc.minirevamtreal,rc.bmdays,rc.commdays,

             SUM(directacr) directacr,
             SUM(directfeeacr) directfeeacr,
            SUM(indirectacr) indirectacr,
            SUM(indirectfeeacr) indirectfeeacr,
            SUM(revenue) revenue,
            SUM(commision) commision,
            SUM ( RFMATCHAMT) RFMATCHAMT,
            SUM(RFFEEACR) RFFEEACR,
            SUM(LMN) LMN,
            SUM(DISPOSAL) DISPOSAL,
            SUM (INRFMATCHAMT) INRFMATCHAMT,
            SUM(INRFFEEACR) INRFFEEACR,
            SUM(INLMN) INLMN,
            SUM(INDISPOSAL) INDISPOSAL,
            Case
                 WHEN  rc.retype = 'D' AND rc.minratesal>0 then
                  rc.minincome * LEAST(1,GREATEST(rc.minratesal/100,sum(rc.directfeeacr)/(rc.mindrevamtreal+0.00001))) * rc.bmdays /rc.commdays
                 WHEN  rc.retype = 'D' AND rc.minratesal=0 AND sum(rc.directfeeacr)>=rc.mindrevamtreal then rc.minincome* rc.bmdays /rc.commdays
                 WHEN  rc.retype = 'D' AND rc.minratesal=0 AND sum(rc.directfeeacr)<rc.mindrevamtreal then 0

                 When  rc.retype='I' AND rc.minratesal>0 then
                       rc.minincome * LEAST(1,GREATEST(rc.minratesal/100,sum(rc.indirectfeeacr)/(rc.minirevamtreal+0.00001))) * rc.bmdays /rc.commdays
                 When  rc.retype='I' AND rc.minratesal= 0 AND sum(rc.indirectfeeacr)>=rc.minirevamtreal then rc.minincome * rc.bmdays /rc.commdays
                 When  rc.retype='I' AND rc.minratesal= 0 AND sum(rc.indirectfeeacr)< rc.minirevamtreal then 0
            End Salary,
            'Y' ISDG
            from recommision rc, retype rty
            where rc.commdate=v_currdate
             and rc.reactype=rty.actype
            AND  rc.retype='D' and rty.rerole in('DG')
            GROUP BY  RC.COMmDATE,RC.CUSTID,rc.retype,RC.mindrevamt,RC.minirevamt,
            RC.minincome,RC.minratesAL,RC.saltype ,rc.mindrevamtreal,rc.minirevamtreal,rc.bmdays,rc.commdays)
        Loop
            insert into resalary( autoid, commdate, custid, retype, mindrevamt, minirevamt,
                                   minincome, minratesal, saltype, directacr,
                                   directfeeacr, indirectacr, indirectfeeacr, revenue,
                                   commision, salary,mindrevamtreal,minirevamtreal,bmdays,commdays,
                                    RFMATCHAMT,RFFEEACR,LMN,DISPOSAL,INRFMATCHAMT,INRFFEEACR,INLMN,INDISPOSAL,TAX,ISDG)
                        values(  seq_resalary.nextval,vc.commdate, vc.custid, vc.retype, vc.mindrevamt, vc.minirevamt,
                               vc.minincome, vc.minratesal, vc.saltype, vc.directacr,
                               vc.directfeeacr, vc.indirectacr, vc.indirectfeeacr, vc.revenue,
                               vc.commision, vc.salary,vc.mindrevamtreal,vc.minirevamtreal,vc.bmdays,vc.commdays,
                                vc.RFMATCHAMT,vc.RFFEEACR,vc.LMN,vc.DISPOSAL,vc.INRFMATCHAMT,vc.INRFFEEACR,vc.INLMN,vc.INDISPOSAL,0,vc.ISDG);
        End loop;
         dbms_OUTPUT.PUT_LINE(' CHIA LUONG XONG');
         --- Chia luong cho moi gio cham soc ho
        For vc in(  Select rr.autoid,rr.reacctno,rr.orgreacctno,rr.feeacr - rr.rffeeacr - rr.rfmatchamt matchamt, rs.directfeeacr -rS.rffeeacr-rs.rfmatchamt directacr, rs.salary
                            from rerevdg rr,  resalary rs
                    where
                         rr.status='A' and rr.commdate is null
                        and rs.commdate =v_currdate
                        and substr(rr.orgreacctno,1,10) = rs.custid
                        and rs.retype='D'
                        and rs.directfeeacr -rS.rffeeacr-rs.rfmatchamt >0
                    )
        Loop
                Update resalary
                Set salary = salary + vc.matchamt * vc.salary / (vc.directacr + 0.00000001)
                Where custid=substr(vc.reacctno,1,10) and commdate =v_currdate and retype='D' and isdg='Y';

                Update rerevdg
                Set salary = vc.matchamt * vc.salary / (vc.directacr + 0.00000001),
                    commdate = v_currdate,
                    status = 'C'
                where status='A' and commdate is null and  reacctno=vc.reacctno and orgreacctno=vc.orgreacctno;
        End loop;-- Chia luong cho moi gioi cham soc ho

        -- tinh thu TNCN
        For vc in( Select rs.custid, sum(decode(rt.taxtype,'001',rs.commision,rs.commision + rs.salary)) income
           From resalary rs, recflnk rc, retax rt
           where  rs.custid= rc.custid
            and rc.taxtype = rt.actype
            and rs.commdate = v_currdate
            group by rs.custid)
        Loop
            update resalary
            set tax = fn_re_gettax(vc.custid,vc.income)
            where custid = vc.custid and commdate= v_currdate;

        End loop;

        -- end of tinh thue tncn
        dbms_OUTPUT.PUT_LINE(' TINH XONG LUONG  CSH');
    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_reCALFEECOMM');
  EXCEPTION
  WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.error (pkgctx, dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_reCALFEECOMM');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_reCALFEECOMM;
-- initial LOG

BEGIN
   SELECT *
   INTO logrow
   FROM tlogdebug
   WHERE ROWNUM <= 1;

   pkgctx    :=
      plog.init ('cspks_reproc',
                 plevel => logrow.loglevel,
                 plogtable => (logrow.log4table = 'Y'),
                 palert => (logrow.log4alert = 'Y'),
                 ptrace => (logrow.log4trace = 'Y')
      );
END;
/
