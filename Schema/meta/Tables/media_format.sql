-- meta.media_format definition

-- Drop table

-- DROP TABLE meta.media_format;

CREATE TABLE meta.media_format (
	media_formatid int4 NOT NULL DEFAULT nextval('meta.toolkit_format_toolkit_formatid_seq'::regclass),
	format_name text NOT NULL,
	inserted_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT toolkit_formatid_pkey PRIMARY KEY (media_formatid)
);