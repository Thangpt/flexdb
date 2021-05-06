CREATE OR REPLACE TRIGGER trg_afmast_after
 AFTER
  INSERT OR UPDATE
 ON afmast
REFERENCING NEW AS NEWVAL OLD AS OLDVAL
 FOR EACH ROW
DECLARE
    v_afacctno   VARCHAR2 (20);
    v_errmsg     VARCHAR2 (10000);
    v_count      Number(20);
    v_policycd_old   varchar2(20);
    v_policycd_new   varchar2(20);
    
	  l_custodycd varchar2(20);
    l_mobile varchar2(20);
    l_datasource varchar2(10000);
    l_afchallenge VARCHAR2(100);
    l_fullname VARCHAR2(1000);
    l_typename VARCHAR2(1000);
    l_sex VARCHAR2(20);
BEGIN
    IF fopks_api.fn_is_ho_active
    THEN
        /*v_afacctno := :newval.acctno;
        msgpks_system.sp_notification_obj('AFMAST',
                                          :newval.acctno,
                                          v_afacctno);*/
        IF :newval.status = 'A' AND :newval.status <> :oldval.status
        THEN
            INSERT INTO ol_log (acctno,
                                status,
                                logtime,
                                applytime)
            VALUES (:newval.acctno,
                    'N',
                    SYSDATE,
                    NULL);
        END IF;

        --Log trigger for buffer if modify advancedline
        -- TheNN, 04-Feb-2012
        IF (   :newval.advanceline <> :oldval.advanceline
            OR :newval.autoadv <> :oldval.autoadv
            OR :newval.mrcrlimitmax <> :oldval.mrcrlimitmax
            OR :newval.mrcrlimit <> :oldval.mrcrlimit)
         --  AND :newval.status <> :oldval.status
        THEN
            fopks_api.pr_trg_account_log (:newval.acctno, 'CI');
        END IF;

        --End Log trigger for buffer
		-- 1.7.1.8 Gui mail dang ky thanh cong cuoc thi KB-Challenge
        IF :newval.status = 'A' AND
           nvl(:oldval.status,'x') NOT IN ('A', 'B') AND
           INSTR(nvl(:oldval.pstatus,'x'), 'A') = 0
        THEN
           SELECT varvalue INTO l_afchallenge FROM sysvar WHERE grname = 'SA' AND varname = 'AFCHALLENGE';
           SELECT typename INTO l_typename FROM aftype WHERE actype = :newval.actype;

           IF trim(l_afchallenge) = trim(:newval.actype) THEN
              -- Do some things
              SELECT cf.custodycd, cf.fullname,
                     CASE WHEN cf.sex = '001' THEN 'Ông'
                          WHEN cf.sex = '002' THEN 'Bà'
                          ELSE 'Ông(Bà)'
                     END
              INTO l_custodycd, l_fullname, l_sex
              FROM cfmast cf WHERE cf.custid = :newval.custid;

              l_datasource:='select ''' || l_sex || ''' sex, ''' || l_fullname ||''' fullname, ''' || l_custodycd || ''' custodycd, ''' || :newval.acctno || '-' || l_typename || ''' acname from dual';
              nmpks_ems.InsertEmailLog(:newval.email, '2301', l_datasource, :newval.acctno);
           END IF;
        END IF;

        IF     :newval.status = 'A'
           AND :oldval.status NOT IN ('A', 'B')
           AND INSTR (:oldval.pstatus, 'A') = 0
        THEN
            INSERT INTO t_fo_event (autoid,
                                    txnum,
                                    txdate,
                                    acctno,
                                    tltxcd,
                                    logtime,
                                    processtime,
                                    process,
                                    errcode,
                                    errmsg)
            VALUES (seq_fo_event.NEXTVAL,
                    '',
                    '',
                    :newval.acctno,
                    'OPNACCT',
                    SYSTIMESTAMP,
                    '',
                    'N',
                    '',
                    '');
        ELSIF :newval.status IN ('N', 'B', 'C') AND :oldval.status = 'A'
        THEN
            INSERT INTO t_fo_event (autoid,
                                    txnum,
                                    txdate,
                                    acctno,
                                    tltxcd,
                                    cvalue,
                                    logtime,
                                    processtime,
                                    process,
                                    errcode,
                                    errmsg)
            VALUES (seq_fo_event.NEXTVAL,
                    '',
                    '',
                    :newval.acctno,
                    'CLOSEACCT',
                    'P',
                    SYSTIMESTAMP,
                    '',
                    'N',
                    '',
                    '');
        ELSIF :newval.status IN ('A') AND :oldval.status = 'B'
        THEN
            INSERT INTO t_fo_event (autoid,
                                    txnum,
                                    txdate,
                                    acctno,
                                    tltxcd,
                                    cvalue,
                                    logtime,
                                    processtime,
                                    process,
                                    errcode,
                                    errmsg)
            VALUES (seq_fo_event.NEXTVAL,
                    '',
                    '',
                    :newval.acctno,
                    'CLOSEACCT',
                    'A',
                    SYSTIMESTAMP,
                    '',
                    'N',
                    '',
                    '');
        ELSIF     :newval.actype IS NOT NULL
              AND :oldval.actype IS NOT NULL
              AND :newval.actype <> :oldval.actype
        THEN
            INSERT INTO t_fo_event (autoid,
                                    txnum,
                                    txdate,
                                    acctno,
                                    tltxcd,
                                    cvalue,
                                    logtime,
                                    processtime,
                                    process,
                                    errcode,
                                    errmsg)
            VALUES (seq_fo_event.NEXTVAL,
                    '',
                    '',
                    :newval.acctno,
                    'CHGAFTYPE',
                    'A',
                    SYSTIMESTAMP,
                    '',
                    'N',
                    '',
                    '');
           /*--Kiem tra neu tai khoan co no thi goi Gen su kien dong bo ROOM xuong FO:
           SELECT count(1) INTO v_count FROM cimast WHERE afacctno  = :newval.acctno AND odamt >10;
           IF v_count >0 THEN
               INSERT INTO t_fo_event (autoid,
                                    txnum,
                                    txdate,
                                    acctno,
                                    tltxcd,
                                    logtime,
                                    processtime,
                                    process,
                                    errcode,
                                    errmsg)
                    VALUES (seq_fo_event.NEXTVAL,
                            '',
                            '',
                            :newval.acctno,
                            --p_txmsg.tltxcd,
                            '0111',
                            systimestamp,
                            '',
                            'N',
                            '',
                            '');
            END IF; */
        END IF;
        --IF :newval.advanceline > 0 THEN

           BEGIN
             SELECT policycd INTO v_policycd_new FROM aftype WHERE actype = :newval.actype;
             SELECT policycd INTO v_policycd_old FROM aftype WHERE actype = :oldval.actype;
           EXCEPTION WHEN OTHERS THEN
             v_policycd_new:='A';
             v_policycd_old:='A';
           END;
           IF v_policycd_new <> v_policycd_old THEN
               INSERT INTO t_fo_event (autoid,
                                        txnum,
                                        txdate,
                                        acctno,
                                        tltxcd,
                                        CVALUE,
                                        logtime,
                                        processtime,
                                        process,
                                        errcode,
                                        errmsg)
                        VALUES (seq_fo_event.NEXTVAL,
                                '',
                                '',
                                '',
                                'CHGDEFRULE',
                                '',
                                systimestamp,
                                '',
                                'N',
                                '',
                                '');
            END IF;
       -- END IF;
    END IF;
END;
/
