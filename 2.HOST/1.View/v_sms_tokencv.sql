CREATE OR REPLACE FORCE VIEW V_SMS_TOKENCV AS
SELECT USERNAME , TOKENID  TOKEN
FROM userlogin WHERE TOKENID IS NOT NULL 
ORDER BY USERNAME;

