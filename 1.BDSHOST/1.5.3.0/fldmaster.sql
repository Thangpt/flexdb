DELETE fldmaster WHERE fldname = 'VIATYPE';
insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CF', 'VIATYPE', 'CF.OTRIGHT', 'VIATYPE', 'VIATYPE:', 'VIATYPE:', 11, 'C', null, null, 3, 'SELECT  CDVAL VALUECD, CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''CF'' AND CDNAME = ''VIATYPE'' ORDER BY LSTODR', null, null, 'Y', 'N', 'Y', null, null, 'N', 'C', null, null, null, null, null, null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);

DELETE fldmaster WHERE objname = 'CF.OTRIGHT' AND DEFNAME = 'TOKEN';

insert into FLDMASTER (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CF', 'TOKEN', 'CF.OTRIGHT', 'TOKEN', 'TOKEN', 'TOKEN:', 12, 'T', null, null, 100, null, null, null, 'Y', 'Y', 'N', null, null, 'N', 'C', null, null, null, null, null, null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);

DELETE fldmaster WHERE objname IN ('1130','1111') AND DEFNAME = 'MACADDRESS';

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '95', '1130', 'MACADDRESS', 'Mac Address', 'Mac Address', 14, 'C', null, null, 50, null, null, '<$MACADDRESS>', 'N', 'N', 'N', null, null, 'N', 'C', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);

insert into fldmaster (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM)
values ('CI', '97', '1111', 'MACADDRESS', 'Mac Address', 'Mac Address', 31, 'C', null, null, 50, null, null, '<$MACADDRESS>', 'N', 'N', 'N', null, null, 'N', 'C', null, null, null, null, '##########', null, null, null, null, 'T', 'N', 'MAIN', null, null, null, 'N', null, 'Y', null, 'N', null, null, null);

UPDATE fldmaster SET fldlen = 80 WHERE objname = 'CF.CFMAST' AND fldname = 'MOBILE';

COMMIT;
