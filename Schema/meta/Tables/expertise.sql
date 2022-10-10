-- meta.expertise definition

-- Drop table

-- DROP TABLE meta.expertise;

CREATE TABLE meta.expertise (
	expertiseid int4 NOT NULL DEFAULT nextval('meta.area_of_expertise_id_seq'::regclass),
	"name" text NOT NULL,
	inserted_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT area_ofexpertise_pkey PRIMARY KEY (expertiseid)
);