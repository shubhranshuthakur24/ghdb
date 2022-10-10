-- meta.relationship definition

-- Drop table

-- DROP TABLE meta.relationship;

CREATE TABLE meta.relationship (
	relationshipid serial4 NOT NULL,
	"name" text NOT NULL,
	inserted_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT relationship_pkey PRIMARY KEY (relationshipid)
);