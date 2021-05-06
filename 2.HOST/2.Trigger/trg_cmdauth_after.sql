CREATE OR REPLACE TRIGGER "TRG_CMDAUTH_AFTER"
 AFTER
  INSERT
 ON cmdauth
REFERENCING NEW AS NEWVAL OLD AS OLDVAL
 FOR EACH ROW
DECLARE
    l_count NUMBER;
    l_autoid    NUMBER;
    l_oldvalue  varchar2(50);
BEGIN
    -- Chi log neu thong tin thay doi khac voi thong tin da log truoc do
    SELECT NVL(max(autoid),0)
    INTO l_autoid
    FROM rightassign_log rl
    WHERE rl.logtable = 'CMDAUTH' AND RL.authtype = :NEWVAL.AUTHTYPE AND RL.AUTHID = :NEWVAL.AUTHID
        AND RL.cmdcode = :NEWVAL.CMDCODE AND RL.cmdtype = :NEWVAL.CMDTYPE;
    IF L_AUTOID > 0 THEN
        SELECT count(autoid)
        INTO l_count
        FROM rightassign_log rl
        WHERE rl.autoid = l_autoid AND rl.cmdallow || rl.strauth <> :NEWVAL.CMDALLOW || :NEWVAL.STRAUTH;
        -- THONG TIN PHAN QUYEN THAY DOI THI MOI LOG
        IF L_COUNT > 0 THEN
            -- LAY THONG TIN PHAN QUYEN CU
            SELECT rl.cmdallow || rl.strauth
            INTO l_oldvalue
            FROM rightassign_log rl
            WHERE rl.autoid = l_autoid;
            INSERT INTO rightassign_log(autoid,logtable,brid,grpid,authtype,AUTHID,cmdcode,cmdtype,cmdallow,
                strauth,tltype,tllimit,chgtlid,chgtime, OLDVALUE, NEWVALUE)
            VALUES (seq_rightassign_log.NEXTVAL, 'CMDAUTH', '', '', :NEWVAL.AUTHTYPE, :NEWVAL.AUTHID,:NEWVAL.CMDCODE,:NEWVAL.CMDTYPE,
                :NEWVAL.CMDALLOW,:NEWVAL.STRAUTH,'','',:NEWVAL.SAVETLID,SYSTIMESTAMP,l_oldvalue,:NEWVAL.CMDALLOW || :NEWVAL.STRAUTH);
        END IF;
    ELSE
        -- CHUA CO DONG NAO TRONG LOG THI LOG VAO
        INSERT INTO rightassign_log(autoid,logtable,brid,grpid,authtype,AUTHID,cmdcode,cmdtype,cmdallow,
            strauth,tltype,tllimit,chgtlid,chgtime, OLDVALUE, NEWVALUE)
        VALUES (seq_rightassign_log.NEXTVAL, 'CMDAUTH', '', '', :NEWVAL.AUTHTYPE, :NEWVAL.AUTHID,:NEWVAL.CMDCODE,:NEWVAL.CMDTYPE,
            :NEWVAL.CMDALLOW,:NEWVAL.STRAUTH,'','',:NEWVAL.SAVETLID,SYSTIMESTAMP,'',:NEWVAL.CMDALLOW || :NEWVAL.STRAUTH);
    END IF;


END;
/

