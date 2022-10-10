-- app.toolkit definition

-- Drop table

-- DROP TABLE app.toolkit;

CREATE TABLE app.toolkit (
	toolkitid serial4 NOT NULL,
	title text NOT NULL,
	info text NOT NULL,
	toolkit_typeid int4 NOT NULL,
	inserted_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	inserted_by int4 NULL,
	updated_by int4 NULL,
	media_formatid int4 NULL,
	media_url varchar NULL,
	duration int2 NULL DEFAULT 0,
	toolkit_status int4 NULL,
	CONSTRAINT toolkit_pkey PRIMARY KEY (toolkitid)
);


-- app.toolkit foreign keys

ALTER TABLE app.toolkit ADD CONSTRAINT toolkit_toolkit_type_fk FOREIGN KEY (toolkit_typeid) REFERENCES meta.toolkit_type(toolkit_typeid);