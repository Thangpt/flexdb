CREATE OR REPLACE PROCEDURE re_convert is
     v_currdate date;
 v_txnum VARCHAR2(10);
  v_prevdate date;
 v_nextdate date;
BEGIN
-- tao custid cho moi gioi
    select to_date(varvalue,'DD/MM/RRRR')into v_currdate
    from sysvar where grname ='SYSTEM' and varname ='CURRDATE';
    select to_date(varvalue,'DD/MM/RRRR') into v_prevdate from sysvar where grname ='SYSTEM' and varname ='PREVDATE';
    select to_date(varvalue,'DD/MM/RRRR') into v_nextdate from sysvar where grname ='SYSTEM' and varname ='NEXTDATE';

   FOR REC IN
      (
        SELECT  A.BRID||'94'||LPAD(seq_CONVERT.NEXTVAL,4,'0')  CUSTID,  A.* FROM
          (
        SELECT 'A' STATUS, NVL(BD.BRID,'0001') BRID
        , SUBSTR( (bd.ten),  INSTR( (bd.ten) ,' ',-1,1 ))  SHORTNAME ,  (bd.ten) FULLNAME ,SUBSTR( (bd.ten),  INSTR( (bd.ten) ,' ',-1,1 ))  MNEMONIC
        ,to_date('01/01/2000' ,'dd/mm/yyyy') DATEOFBIRTH,'001' IDTYPE, ''IDCODE ,
          to_date('01/01/2000' ,'dd/mm/yyyy')  IDDATE,  '' IDPLACE
          ,  '' ADDRESS1 , '-----' PHONE ,'' MOBILE,
          '' FAX ,'' EMAIL   , '234'  COUNTRY , '' CUSTODYCD ,to_date('01/01/2000' ,'dd/mm/yyyy')  OPNDATE ,''DESCRIPTION,
          '001' SEX ,  'I' CUSTTYPE, '0001' actype,'001' AFTYPE, bd.makh
          from bd01cv  bd WHERE  LENGTH(nvl(soluuky,'x')) <10
      )A
      )
    LOOP

        INSERT INTO CFMAST
          (CUSTID,SHORTNAME,FULLNAME ,MNEMONIC , DATEOFBIRTH,IDTYPE,IDCODE,IDDATE,IDPLACE,IDEXPIRED,ADDRESS,PHONE,MOBILE  ,FAX,EMAIL,COUNTRY,PROVINCE , POSTCODE,RESIDENT,CLASS,GRINVESTOR,INVESTRANGE,TIMETOJOIN,CUSTODYCD,STAFF,COMPANYID,POSITION,SEX,SECTOR,BUSINESSTYPE,INVESTTYPE,EXPERIENCETYPE,INCOMERANGE,ASSETRANGE,FOCUSTYPE,BRID,CAREBY,APPROVEID,LASTDATE,AUDITORID,AUDITDATE,MARGINLIMIT,TRADELIMIT,ADVANCELIMIT,REPOLIMIT,DEPOSITLIMIT,MORTAGERATE,LANGUAGE,BANKACCTNO,BANKCODE,VALUDADDED,ISSUERID,DESCRIPTION,MARRIED,REFNAME,PHONE1,FAX1,TAXCODE,INTERNATION,OCCUPATION,EDUCATION,CUSTTYPE,STATUS,PSTATUS,INVESTMENTEXPERIENCE,PCUSTODYCD,EXPERIENCECD,ORGINF,TLID,ISBANKING,PIN,  USERNAME, MRLOANLIMIT, RISKLEVEL, EXPDATE, VALDATE, TRADINGCODE, TRADINGCODEDT, LAST_CHANGE, OPNDATE, CONTRACTCHK)
        VALUES
        ( REC.CUSTID ,REC.SHORTNAME ,REC.FULLNAME  ,NULL ,REC.DATEOFBIRTH ,'001',REC.IDCODE,REC.IDDATE,REC.IDPLACE ,TO_DATE('01/01/2020','DD/MM/YYYY'),REC.ADDRESS1,REC.PHONE,REC.MOBILE  ,REC.FAX,REC.EMAIL,rec.COUNTRY,'--' ,   NULL,'002','001','001','001','001',REC.CUSTODYCD,'005',NULL,'001',REC.SEX,'001','009','004','002','001','001','001',NULL,'0001',NULL,v_prevdate,NULL,NULL,0,0,0,0,0,0,'001',NULL,'000',NULL,NULL,REC.DESCRIPTION,'002',NULL,NULL,NULL,NULL,NULL,'001','002',REC.CUSTTYPE,'A','P',NULL,NULL,'10000',NULL,NULL,'N',NULL,NULL, 0.0000, '', null, null, '', null, '', null, 'Y');

          update bd01cv set custid =rec.custid where bd01cv.makh= REC.makh;

    END LOOP;

    FOR REC IN (SELECT CF.CUSTODYCD,CF.CUSTID FROM CFMAST CF )
      LOOP
        UPDATE bd01cv SET CUSTID = REC.CUSTID WHERE soluuky = REC.CUSTODYCD;
      END LOOP;
    ---convert------------
    Select to_date(varvalue,'dd/mm/yyyy') into v_currdate
     FROM SYSVAR WHERE VARNAME='CURRDATE';
    DELETE recflnk;
    FOR VC IN(
        SELECT B.ten, B.makh, TO_DATE(B.ngayhl,'DD/MM/YYYY') EFFDATE, TO_DATE(B.ngayhhl,'DD/MM/YYYY') EXPDATE,
              TO_NUMBER(REPLACE(B.hanmuc,',','')) mindrevamt,
             TO_NUMBER(REPLACE(B.LUONG,',','')) MININCOME ,
               TO_NUMBER(nvl(B.tile,0)) MINRATESAL,
               B.phong, B.soluuky, B.cmnd, B.custid
        FROM BD01CV B WHERE b.ten is not null)
    LOOP

         INSERT INTO recflnk(autoid, custid, isautotrf, afacctno, effdate,
                           expdate, mindrevamt, minirevamt, minincome, taxrate,
                           balance, pstatus, status, minratesal, saltype,brid)
                  VALUES(seq_recflnk.nextval,VC.CUSTID,'N','',VC.EFFDATE,
                        VC.EXPDATE,VC.mindrevamt,0,VC.minincome,0,
                            0,'P','A',VC.minratesal,'0',substr(VC.custid,1,4));
    END LOOP;

    Delete recfdef;
    For vc in(select rcl.autoid refrecflnkid,
                       b2.ma reactype,
                       TO_DATE(B2.ngayhl,'DD/MM/YYYY') EFFDATE,
                       TO_DATE(B2.ngayhhl,'DD/MM/YYYY') EXPDATE,
                       b2.thutu odrnum,
                       b2.cohanmuc isdrev,
                       b1.custid
                from bd02cv b2,BD01CV b1, recflnk rcl, RETYPE RTY
                where b1.makh = substr(b2.taikhoan,1,5)
                and b1.custid=rcl.custid
                AND B2.MA=RTY.ACTYPE
                AND RTY.RETYPE='D')
    Loop
            INSERT into recfdef(autoid, refrecflnkid, reactype, effdate, expdate,
                               odrnum, pstatus, status, isgroup, isdrev, isrfc,
                               afstatus,opendate)
                        values(seq_recfdef.nextval,vc.refrecflnkid,vc.reactype,vc.effdate,vc.expdate,
                                vc.odrnum,'P','A','N',VC.isdrev,'N',
                                '',v_currdate);
    End loop;

   DELETE reaflnk;
    FOR VC IN(select rcl.autoid refrecflnkid,
                       rcl.custid||rdcu.reactype reacctno,
                       af.acctno afacctno,
                       TO_DATE(nvl(B3.fdate,'01/01/2012'),'DD/MM/YYYY') frdate,
                       TO_DATE(nvl(B3.tdate,'01/01/2035'),'DD/MM/YYYY') todate,
                           b3.soluuky,
                        rdcu.reactype actypecu

                from bd03cv b3,BD01CV b1, recflnk rcl, cfmast cf, afmast af,
                     recfdef rdcu, retype rtcu
                where b1.makh = b3.moigioi
                and b1.custid=rcl.custid
                and b3.soluuky=cf.custodycd
                and cf.custid= af.custid
                and rcl.autoid=rdcu.refrecflnkid
                and rdcu.reactype=rtcu.actype
                and rtcu.retype='D'
                and b3.tkmght=b3.moigioi||rdcu.reactype
               )
    LOOP
    SELECT    '8080'
          || SUBSTR ('000000' || seq_batchtxnum.NEXTVAL,
                     LENGTH ('000000' || seq_batchtxnum.NEXTVAL) - 5,
                     6
                    )
         INTO v_txnum
         FROM DUAL;
       INSERT INTO reaflnk(autoid, txdate, txnum, refrecflnkid, reacctno,
                           afacctno, frdate, todate, deltd, clstxdate, clstxnum,
                           pstatus, status)
        VALUES(seq_reaflnk.NEXTVAL,v_currdate,v_txnum,VC.refrecflnkid,VC.reacctno,
                            VC.afacctno,VC.FRDATE,VC.TODATE,'N',NULL,NULL,
                            'P','A');
    END LOOP;
     DELETE REMAST;
    INSERT INTO remast( acctno, custid, actype, status, pstatus, last_change,
       ratecomm, balance, damtacr, damtlastdt, iamtacr,
       iamtlastdt, directacr, indirectacr, odfeetype,
       odfeerate, commtype, lastcommdate, dfeeacr, ifeeacr,
       directfeeacr, indirectfeeacr)
    SELECT RL.custid||RD.reactype ACCTNO,
           RL.custid,
           RD.reactype,
           'A' STATUS,
           'P' PSTATUS,
           SYSDATE LAST_CHANGE,
           0 RATECOMM,
           0 BALANCE,
           0 DAMTACR,
          v_currdate damtlastdt,
           0 iamtacr,
          v_currdate iamtlastdt,
           0 directacr,
           0 indirectacr,
           RTY.odfeetype,
           RTY.odfeerate,
           NULL COMMDATE,
           v_currdate LASTCOMMDATE,
           0 dfeeacr,
           0 ifeeacr,
           0 directfeeacr,
           0 indirectfeeacr
    FROM recflnk RL, recfdef RD, RETYPE RTY
    WHERE RL.autoid=RD.refrecflnkid
     AND RD.reactype=RTY.actype;


     DELETE REGRP;
     --TAO NHOM
     FOR VC IN(select B5.NHOM,seq_regrp.NEXTVAL autoid, 1 grplevel, NULL prgrpid, B5.TENNHOM fullname, B1.custid custid, B5.loaihinh actype,
                        TO_DATE('01/01/2012','DD/MM/YYYY') EFFDATE,TO_DATE('01/01/2035','DD/MM/YYYY') EXPDATE,
                         0 mindrevamt, TO_NUMBER(REPLACE(B5.DINHMUC,',','')) minirevamt, TO_NUMBER(REPLACE(B5.LUONG,',','')) MININCOME,
                         0 BALANCE,'P' PSTATUS, 'A' STATUS, TO_NUMBER(REPLACE(B5.LUONGDINHMUC,',','')) minratesal, '0' SALTYPE
                   from  bd05cv B5, BD01CV B1
                WHERE B5.mamoigioi=B1.makh)
     LOOP
            INSERT INTO   regrp( autoid, grplevel, prgrpid, fullname, custid, actype,
                               effdate, expdate,mindrevamt, minirevamt, minincome,
                               balance, pstatus, status, minratesal, saltype)
                VALUES  (VC.autoid, VC.grplevel, VC.prgrpid, VC.fullname, VC.custid, VC.actype,
                           VC.effdate, VC.expdate, VC.mindrevamt, VC.minirevamt, VC.minincome,
                           VC.balance, VC.pstatus, VC.status, VC.minratesal, VC.saltype);
            UPDATE BD05CV B
            SET B.AUTOID=VC.AUTOID
            WHERE B.nhom=VC.NHOM;
     END LOOP;
     -- UPDATE prgrpid
     FOR VC IN(SELECT B5.*,  B5P.AUTOID  prgrpid
                FROM BD05CV B5, BD05CV B5P
                WHERE B5.NHOMCHA=B5P.NHOM )
     LOOP
            UPDATE REGRP R
            SET R.prgrpid= VC.prgrpid
            WHERE R.autoid=VC.AUTOID;
     END LOOP;


     -- TAO TK MG CHO TRUONG NHOM
     delete remast where actype in (select actype from regrp);
     INSERT INTO remast( acctno, custid, actype, status, pstatus, last_change,
       ratecomm, balance, damtacr, damtlastdt, iamtacr,
       iamtlastdt, directacr, indirectacr, odfeetype,
       odfeerate, commtype, lastcommdate, dfeeacr, ifeeacr,
       directfeeacr, indirectfeeacr)
    SELECT RL.custid||Rl.actype ACCTNO,
           RL.custid,
           Rl.actype,
           'A' STATUS,
           'P' PSTATUS,
           SYSDATE LAST_CHANGE,
           0 RATECOMM,
           0 BALANCE,
           0 DAMTACR,
           v_currdate damtlastdt,
           0 iamtacr,
           v_currdate iamtlastdt,
           0 directacr,
           0 indirectacr,
           RTY.odfeetype,
           RTY.odfeerate,
           NULL COMMDATE,
           v_currdate LASTCOMMDATE,
           0 dfeeacr,
           0 ifeeacr,
           0 directfeeacr,
           0 indirectfeeacr
    FROM regrp RL,  RETYPE RTY
    WHERE  Rl.actype=RTY.actype;

     DELETE regrplnk;
     FOR VC IN(select '1' autoid,b5.autoid refrecflnkid, b1.custid||b4.loaihinh reacctno,
                  b1.custid,   to_date(nvl(b4.fdate,'01/01/2012'),'DD/MM/YYYY') frdate, to_date(nvl(b4.tdate,'01/01/2035'),'DD/MM/YYYY') todate,'N' DELTD, NULL clstxdate, NULL CLSTXNUM,
                  'P' PSTATUS, 'A' STATUS
                from bd04cv b4, bd05cv b5, bd01cv b1
                where b4.nhom=b5.nhom
                   AND b4.moigioI=b1.makh )
     LOOP
        SELECT    '8080'
          || SUBSTR ('000000' || seq_batchtxnum.NEXTVAL,
                     LENGTH ('000000' || seq_batchtxnum.NEXTVAL) - 5,
                     6
                    )
         INTO v_txnum
         FROM DUAL;
        INSERT INTO regrplnk( autoid, txdate, txnum, refrecflnkid, reacctno,
                           custid, frdate, todate, deltd, clstxdate, clstxnum,
                           pstatus, status)
                  VALUES (seq_regrplnk.NEXTVAL, v_currdate, v_txnum, VC.refrecflnkid, VC.reacctno,
                           VC.custid, VC.frdate, VC.todate, VC.deltd, VC.clstxdate, VC.clstxnum,
                           VC.pstatus, VC.status);
     END LOOP;
    COMMIT;
--EXCEPTION
  --  WHEN OTHERS THEN
    --    return ;
END; -- Procedure
/

