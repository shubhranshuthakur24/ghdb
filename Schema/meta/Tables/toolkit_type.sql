-- meta.toolkit_type definition

-- Drop table

-- DROP TABLE meta.toolkit_type;

CREATE TABLE meta.toolkit_type (
	toolkit_typeid serial4 NOT NULL,
	toolkit_type_name text NOT NULL,
	inserted_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT toolkit_type_pkey PRIMARY KEY (toolkit_typeid)
);