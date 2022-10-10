-- app.navigator definition

-- Drop table

-- DROP TABLE app.navigator;

CREATE TABLE app.navigator (
	navigatorid serial4 NOT NULL,
	bio text NULL,
	languageid int4 NULL DEFAULT 1,
	inserted_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	inserted_by int4 NULL,
	updated_by int4 NULL,
	userid int4 NULL,
	is_active bool NULL,
	weekly_schedule _int4 NOT NULL DEFAULT '{}'::integer[],
	date_range int4 NULL,
	meeting_url varchar NULL,
	relationshipid int4 NULL,
	diseaseid _int4 NOT NULL DEFAULT '{}'::integer[],
	expertiseid _int4 NOT NULL DEFAULT '{}'::integer[],
	reportid int4 NULL,
	CONSTRAINT navigator_pkey PRIMARY KEY (navigatorid)
);


-- app.navigator foreign keys

ALTER TABLE app.navigator ADD CONSTRAINT navigator_relationship_fk FOREIGN KEY (relationshipid) REFERENCES meta.relationship(relationshipid);
ALTER TABLE app.navigator ADD CONSTRAINT navigator_users_fk FOREIGN KEY (userid) REFERENCES app.users(userid);