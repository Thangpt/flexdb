-- Start of DDL Script for Table HOSTUAT.CFCOMPARE2FILE
-- Generated 08/09/2020 2:06:20 PM from HOSTUAT@FLEXUAT

CREATE TABLE cfcompare2file
    (f_autoid                       VARCHAR2(100 BYTE),
    f_type                         VARCHAR2(1000 BYTE),
    f_shortname                    VARCHAR2(1000 BYTE),
    f_fullname                     VARCHAR2(1000 BYTE),
    f_birthdate                    VARCHAR2(1000 BYTE),
    f_country                      VARCHAR2(1000 BYTE),
    f_idcode                       VARCHAR2(1000 BYTE),
    f_iddate                       VARCHAR2(1000 BYTE),
    status                         VARCHAR2(1000 BYTE),
    deltd                          VARCHAR2(1000 BYTE),
    errmsg                         VARCHAR2(1000 BYTE),
    fullname                       VARCHAR2(1000 BYTE),
    custodycd                      VARCHAR2(1000 BYTE),
    idcode                         VARCHAR2(1000 BYTE),
    address                        VARCHAR2(1000 BYTE),
    sex                            VARCHAR2(1000 BYTE),
    married                        VARCHAR2(1000 BYTE),
    mobile                         VARCHAR2(1000 BYTE),
    opndate                        DATE)
/





-- Indexes for CFCOMPARE2FILE

CREATE INDEX cfcompare2file_fullname_idx ON cfcompare2file
  (
    f_fullname                      ASC
  )
/

CREATE INDEX cfcompare2file_date_idx ON cfcompare2file
  (
    f_birthdate                     ASC
  )
/

CREATE INDEX cfcompare2file_idcode_idx ON cfcompare2file
  (
    f_idcode                        ASC
  )
/



-- End of DDL Script for Table HOSTUAT.CFCOMPARE2FILE
