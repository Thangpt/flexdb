CREATE OR REPLACE FORCE VIEW V_LOOKUP_ICCFTYPE AS
SELECT EV.modcode,AM.ACCTNO, AF.ACTYPE, IC.EVENTCODE VALUECD,IC.EVENTCODE VALUE,EV.EVENTNAME EN_DISPLAY,'IRATE: '||ICRATE||'-MIN:'||MINVAL||'-MAX:'||MAXVAL DESCRIPTION,ICRATE,MINVAL,MAXVAL
FROM AFMAST AM, AFTYPE AF,CITYPE CI,ICCFTYPEDEF IC,APPEVENTS EV
WHERE AM.ACTYPE=AF.ACTYPE AND AF.CITYPE=CI.ACTYPE AND CI.ACTYPE=IC.ACTYPE AND IC.EVENTCODE=EV.EVENTCODE AND IC.LINE = 'Y' AND IC.DELTD<>'Y' AND IC.MODCODE=EV.MODCODE;

