-- meta.meeting_preference definition

-- Drop table

-- DROP TABLE meta.meeting_preference;

CREATE TABLE meta.meeting_preference (
	p_id serial4 NOT NULL,
	p_type varchar NULL,
	inserted_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT meeting_preference_pkey PRIMARY KEY (p_id)
);