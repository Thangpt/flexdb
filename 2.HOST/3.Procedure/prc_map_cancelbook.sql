CREATE OR REPLACE PROCEDURE prc_map_cancelbook
   IS
   V_COUNT NUMBER(10);
   V_SQL varchar2(500);
BEGIN
         dbms_output.put_line(' start '||to_char(sysdate,'hh24:mi:ss'));
         --Dua cac lenh moi vao bang ket qua khop lenh tam thoi.
        INSERT INTO STCCANCELORDERBOOKTEMP
                SELECT * FROM STCCANCELORDERBOOKBUFFER S WHERE  NOT EXISTS
                (SELECT ORDERNUMBER FROM STCCANCELORDERBOOK WHERE ORDERNUMBER =S.ORDERNUMBER);


        --Cap nhat STCCANCELORDERBOOK cho nhung lenh da duoc map (o bang STCCANCELORDERBOOK)
        INSERT INTO STCCANCELORDERBOOK
                SELECT * FROM STCCANCELORDERBOOKTEMP WHERE ORDERNUMBER IN
                (SELECT ORDERNUMBER FROM STCORDERBOOK);


        --Xoa nhung DEAL trong STCCANCELORDERBOOKTEMP ma co ban ghi trong STCCANCELORDERBOOK
        DELETE FROM STCCANCELORDERBOOKTEMP S WHERE EXISTS
                (SELECT ORDERNUMBER FROM STCCANCELORDERBOOK WHERE ORDERNUMBER=S.ORDERNUMBER);


        --Xoa di nhung DEAL khop lenh trong STCTRADEBOOKEXP ma khong xuat hien trong STCTRADEBOOKTEMP
        DELETE FROM STCTRADEBOOKEXP S WHERE  NOT EXISTS
                (SELECT REFCONFIRMNUMBER FROM STCTRADEBOOKTEMP WHERE REFCONFIRMNUMBER =S.REFCONFIRMNUMBER);
                 
        DELETE FROM STCCANCELORDERBOOKEXP S WHERE  NOT EXISTS
                (SELECT ORDERNUMBER FROM STCCANCELORDERBOOKTEMP WHERE ORDERNUMBER =S.ORDERNUMBER);
                

        --Day vao trong STCORDERBOOKEXP nhung lenh exception moi
        INSERT INTO STCCANCELORDERBOOKEXP SELECT * FROM STCCANCELORDERBOOKTEMP S WHERE  NOT EXISTS
                (SELECT ORDERNUMBER FROM STCCANCELORDERBOOKEXP WHERE ORDERNUMBER=S.ORDERNUMBER);

        dbms_output.put_line(' finnish '||to_char(sysdate,'hh24:mi:ss'));
   EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
END;
/

