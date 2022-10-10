-- meta.resource_tag definition

-- Drop table

-- DROP TABLE meta.resource_tag;

CREATE TABLE meta.resource_tag (
	resource_tagid serial4 NOT NULL,
	tag_name text NOT NULL,
	inserted_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT resource_tagid_pkey PRIMARY KEY (resource_tagid)
);