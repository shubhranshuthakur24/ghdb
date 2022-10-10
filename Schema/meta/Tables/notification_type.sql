-- meta.notification_type definition

-- Drop table

-- DROP TABLE meta.notification_type;

CREATE TABLE meta.notification_type (
	notification_typeid int2 NOT NULL,
	notification_type varchar(20) NULL,
	inserted_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	lag_time int4 NULL,
	CONSTRAINT notification_typeid_pk PRIMARY KEY (notification_typeid)
);