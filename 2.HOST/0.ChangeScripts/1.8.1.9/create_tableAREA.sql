create table AREA
(
  areaid      VARCHAR2(4) not null,
  areaname    VARCHAR2(400),
  description VARCHAR2(1000),
  CONSTRAINT area_pk PRIMARY KEY (areaid)
);
