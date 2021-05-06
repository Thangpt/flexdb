alter table KBCHALLENGE_OUT add  
(fullname  VARCHAR2(1000),
 typename  VARCHAR2(200),
 email     VARCHAR2(200),
 status    VARCHAR2(2) default 'C');
