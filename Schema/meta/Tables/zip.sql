-- meta.zip definition

-- Drop table

-- DROP TABLE meta.zip;

CREATE TABLE meta.zip (
	id int4 NOT NULL,
	zip text NULL,
	city_id int4 NULL,
	lat float4 NULL,
	lng float4 NULL,
	timezone text NULL,
	timezoneid int4 NULL,
	CONSTRAINT zip_pkey PRIMARY KEY (id)
);


-- meta.zip foreign keys

ALTER TABLE meta.zip ADD CONSTRAINT zip_city_id_fkey FOREIGN KEY (city_id) REFERENCES meta.city(id);
ALTER TABLE meta.zip ADD CONSTRAINT zip_timezoneid_fkey FOREIGN KEY (timezoneid) REFERENCES meta.timezone(timezoneid);