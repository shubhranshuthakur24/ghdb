-- meta.disease definition

-- Drop table

-- DROP TABLE meta.disease;

CREATE TABLE meta.disease (
	diseaseid serial4 NOT NULL,
	disease_name text NOT NULL,
	inserted_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT disease_pkey PRIMARY KEY (diseaseid)
);