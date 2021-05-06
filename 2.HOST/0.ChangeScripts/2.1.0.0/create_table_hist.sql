

CREATE TABLE bl_odmasthist AS SELECT * FROM bl_odmast WHERE 0=1;
create index BL_ODMASThist_BLORDERID_IDX on BL_ODMASThist (BLORDERID);
create index BL_ODMASThist_FOREFID_IDX on BL_ODMASThist (FOREFID);
alter table BL_ODMASThist add constraint BL_ODMASThist_PK primary key (AUTOID);

CREATE TABLE bl_maporderhist AS SELECT * FROM bl_maporder WHERE 0=1;
create index IDX_BL_MAPORDERhist_BLORDERID on BL_MAPORDERhist (BLORDERID);
create index IDX_BL_MAPORDERhist_HFTORDERID on BL_MAPORDERhist (HFTORDERID);
alter table BL_MAPORDERhist add constraint BL_MAPORDERhist_PK primary key (MAPID);

CREATE TABLE bl_autoorderplanhist AS SELECT * FROM bl_autoorderplan WHERE 0=1;
create index IDX_bl_autoorderhist_BLORDERID on bl_autoOrderPlanhist (blorderid);
