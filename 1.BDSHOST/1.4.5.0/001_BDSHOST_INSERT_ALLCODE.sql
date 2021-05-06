-- SELECT * FROM ALLCODE WHERE CDNAME='CATYPE' AND CDVAL='028'  and cdtype='CA';
DELETE FROM ALLCODE WHERE CDNAME='CATYPE' AND CDVAL='028';
insert into ALLCODE (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('CA', 'CATYPE', '028', 'Chi trả lợi tức chứng quyền', 28, 'Y', 'Payout of the warrant certificate');

-- SELECT * FROM ALLCODE WHERE CDNAME='TYPERATE' and cdval='V' and cdtype='CA';
delete FROM ALLCODE WHERE CDNAME='TYPERATE' and cdval='V' and cdtype='CA';
insert into ALLCODE (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('CA', 'TYPERATE', 'V', 'Chia theo giá trị/(CP,CW)', 2, 'Y', 'By value/(share,CW)');


COMMIT;
