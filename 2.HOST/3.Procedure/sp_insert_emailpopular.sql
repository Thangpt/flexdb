CREATE OR REPLACE PROCEDURE sp_insert_emailpopular(pv_emailid in varchar2, pv_subject in varchar2, pv_attachment in varchar2, pv_bodyhtml in varchar2)
IS
  v_strEmailid  varchar2(10);
  v_strSubject  varchar2(200);
  v_strAttachment  varchar2(200);
  v_strBodyhtml  varchar2(32000);
  v_clobTemp CLOB;
BEGIN
    v_strEmailid := pv_emailid;
    v_strSubject := pv_subject;
    v_strAttachment := pv_attachment;
    v_strBodyhtml := pv_bodyhtml;
    /* Formatted on 16-Aug-2013 14:32:13 (QP5 v5.126) */
    INSERT INTO emailpopular (emailid,
                              subject,
                              attachment,
                              bodyhtml)
      VALUES   (v_strEmailid,
                v_strSubject,
                v_strAttachment,
                empty_clob());
    SELECT bodyhtml INTO v_clobTemp FROM EMAILPOPULAR WHERE EMAILID =v_strEmailid for update;
    v_clobTemp := v_strBodyhtml;
    UPDATE EMAILPOPULAR SET bodyhtml = v_clobTemp WHERE EMAILID = v_strEmailid;
    COMMIT;
EXCEPTION
   WHEN OTHERS THEN
        BEGIN
            raise;
            return;
        END;
END;
/

