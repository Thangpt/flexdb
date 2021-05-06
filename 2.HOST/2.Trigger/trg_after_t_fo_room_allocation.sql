CREATE OR REPLACE TRIGGER trg_after_t_fo_room_allocation
 BEFORE
  INSERT
 ON t_fo_room_allocation
REFERENCING NEW AS NEWVAL OLD AS OLDVAL
 FOR EACH ROW
begin
INSERT INTO afpralloc (AUTOID,AFACCTNO,PRINUSED,CODEID,ALLOCTYP,ORGORDERID,TXDATE,TXNUM,RESTYPE,FOMODE,FOORDERID)
VALUES(seq_afpralloc.NEXTVAL,:newval.acctno,(CASE WHEN :newval.doc = 'D' THEN :newval.qtty ELSE - :newval.qtty END),
    (SELECT codeid FROM sbsecurities WHERE symbol = :newval.symbol),'M',
    /*(SELECT boorderid FROM newfo_ordermap WHERE foorderid = :newval.orderid AND txdate = getcurrdate)*/
    null,getcurrdate,
    '',(CASE WHEN :newval.roomid = 'UB' THEN 'M' ELSE 'S' END),'Y',:newval.orderid);

:newval.executetime := SYSTIMESTAMP;
:newval.status := 'C';
END;
/

