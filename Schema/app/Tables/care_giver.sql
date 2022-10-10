-- app.care_giver definition

-- Drop table

-- DROP TABLE app.care_giver;

CREATE TABLE app.care_giver (
	care_giverid serial4 NOT NULL,
	navigatorid int4 NULL,
	userid int4 NOT NULL,
	inserted_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamp NULL DEFAULT timezone('utc'::text, now()),
	inserted_by int4 NULL,
	updated_by int4 NULL,
	saved_toolkit _int4 NOT NULL DEFAULT '{}'::integer[],
	notes varchar NULL,
	assessment_status varchar NULL DEFAULT 'incomplete'::character varying,
	assigned_resource _int4 NOT NULL DEFAULT '{}'::integer[],
	timezoneid int4 NULL DEFAULT 152,
	is_archive bool NOT NULL DEFAULT false,
	CONSTRAINT care_giver_pkey PRIMARY KEY (care_giverid)
);


-- app.care_giver foreign keys

ALTER TABLE app.care_giver ADD CONSTRAINT care_giver_navigator_fk FOREIGN KEY (navigatorid) REFERENCES app.navigator(navigatorid);
ALTER TABLE app.care_giver ADD CONSTRAINT care_giver_users_fk FOREIGN KEY (userid) REFERENCES app.users(userid);