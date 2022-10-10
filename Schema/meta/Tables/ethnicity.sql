-- meta.ethnicity definition

-- Drop table

-- DROP TABLE meta.ethnicity;

CREATE TABLE meta.ethnicity (
	ethnicityid serial4 NOT NULL,
	"name" text NOT NULL,
	inserted_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT ethnicity_pkey PRIMARY KEY (ethnicityid)
);