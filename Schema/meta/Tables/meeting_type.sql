-- meta.meeting_type definition

-- Drop table

-- DROP TABLE meta.meeting_type;

CREATE TABLE meta.meeting_type (
	meeting_typeid serial4 NOT NULL,
	meeting_type_name text NOT NULL,
	inserted_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT meeting_type_pkey PRIMARY KEY (meeting_typeid)
);