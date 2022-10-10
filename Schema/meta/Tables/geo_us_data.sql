-- meta.geo_us_data definition

-- Drop table

-- DROP TABLE meta.geo_us_data;

CREATE TABLE meta.geo_us_data (
	state_fips int4 NULL,
	state varchar(100) NULL,
	state_abbr varchar(2) NULL,
	zipcode varchar(5) NULL,
	county varchar(38) NULL,
	city varchar(16) NULL
);