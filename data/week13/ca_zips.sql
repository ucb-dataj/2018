CREATE TABLE ca_zipcodes
(
  gid integer,
  zcta5ce10 character varying(5),
  affgeoid10 character varying(14),
  geoid10 character varying(5),
  aland10 double precision,
  awater10 double precision,
  geom geometry(MultiPolygon)
)
WITH (
  OIDS=FALSE
);
