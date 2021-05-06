CREATE OR REPLACE FORCE VIEW V_LOOKUP_ICCF AS
SELECT distinct AM.ACCTNO, AF.ACTYPE, EV.MODCODE, IC.EVENTCODE VALUECD, IC.EVENTCODE VALUE,EV.EVENTNAME DESCRIPTION, IC.PERIOD
FROM AFMAST AM, AFTYPE AF,CITYPE CI,ICCFTYPEDEF IC,APPEVENTS EV
WHERE AM.ACTYPE=AF.ACTYPE AND AF.CITYPE=CI.ACTYPE AND CI.ACTYPE=IC.ACTYPE AND IC.EVENTCODE=EV.EVENTCODE AND IC.MODCODE = EV.MODCODE AND IC.MODCODE ='CI' AND IC.LINE = 'Y' AND IC.DELTD = 'N'
UNION ALL
SELECT distinct AM.ACCTNO, AF.ACTYPE, EV.MODCODE, IC.EVENTCODE VALUECD, IC.EVENTCODE VALUE,EV.EVENTNAME DESCRIPTION, IC.PERIOD
FROM AFMAST AM, AFTYPE AF,SETYPE SE,ICCFTYPEDEF IC,APPEVENTS EV
WHERE AM.ACTYPE=AF.ACTYPE AND AF.SETYPE=SE.ACTYPE AND SE.ACTYPE=IC.ACTYPE AND IC.EVENTCODE=EV.EVENTCODE AND IC.MODCODE = EV.MODCODE AND IC.MODCODE ='SE' AND IC.LINE = 'Y' AND IC.DELTD = 'N'
UNION ALL
SELECT distinct AM.ACCTNO, AF.ACTYPE, EV.MODCODE, IC.EVENTCODE VALUECD, IC.EVENTCODE VALUE,EV.EVENTNAME DESCRIPTION, IC.PERIOD
FROM AFMAST AM, AFTYPE AF,REGTYPE RE,ICCFTYPEDEF IC,APPEVENTS EV
WHERE AM.ACTYPE=AF.ACTYPE AND AF.ACTYPE=RE.AFTYPE AND RE.ACTYPE=IC.ACTYPE AND IC.EVENTCODE=EV.EVENTCODE AND IC.MODCODE = EV.MODCODE AND IC.MODCODE =RE.MODCODE AND IC.LINE = 'Y' AND IC.DELTD = 'N'
UNION ALL
SELECT distinct AM.ACCTNO, AF.ACTYPE, EV.MODCODE, IC.EVENTCODE VALUECD, IC.EVENTCODE VALUE,EV.EVENTNAME DESCRIPTION, IC.PERIOD
FROM AFMAST AM, AFTYPE AF,ICCFTYPEDEF IC,APPEVENTS EV
WHERE AM.ACTYPE=AF.ACTYPE AND IC.ACTYPE = AF.ACTYPE AND IC.EVENTCODE=EV.EVENTCODE AND IC.MODCODE = EV.MODCODE AND IC.MODCODE ='CF' AND IC.LINE = 'Y' AND IC.DELTD = 'N';

