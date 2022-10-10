-- meta.mail_type definition

-- Drop table

-- DROP TABLE meta.mail_type;

CREATE TABLE meta.mail_type (
	mail_typeid int2 NOT NULL,
	mail_type varchar(20) NULL,
	inserted_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT mail_typeid_pk PRIMARY KEY (mail_typeid)
);