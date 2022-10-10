-- meta."language" definition

-- Drop table

-- DROP TABLE meta."language";

CREATE TABLE meta."language" (
	languageid serial4 NOT NULL,
	"name" text NOT NULL,
	inserted_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT language_pkey PRIMARY KEY (languageid)
);