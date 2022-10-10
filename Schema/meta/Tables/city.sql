-- meta.city definition

-- Drop table

-- DROP TABLE meta.city;

CREATE TABLE meta.city (
	id int4 NOT NULL,
	city text NULL,
	state text NULL,
	lat float4 NULL,
	lng float4 NULL,
	timezone text NULL,
	CONSTRAINT city_pkey PRIMARY KEY (id)
);
CREATE INDEX city_name ON meta.city USING btree (city);