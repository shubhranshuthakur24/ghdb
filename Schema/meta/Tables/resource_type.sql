-- meta.resource_type definition

-- Drop table

-- DROP TABLE meta.resource_type;

CREATE TABLE meta.resource_type (
	resource_typeid serial4 NOT NULL,
	resource_type_name text NOT NULL,
	inserted_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT resource_type_pkey PRIMARY KEY (resource_typeid)
);