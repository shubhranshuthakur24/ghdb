-- app.care_team definition

-- Drop table

-- DROP TABLE app.care_team;

CREATE TABLE app.care_team (
	team_id serial4 NOT NULL,
	team_name varchar NOT NULL,
	care_giverid int4 NOT NULL,
	inserted_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamp NULL DEFAULT timezone('utc'::text, now()),
	inserted_by int4 NULL,
	updated_by int4 NULL,
	CONSTRAINT team_n_pkey PRIMARY KEY (team_id)
);


-- app.care_team foreign keys

ALTER TABLE app.care_team ADD CONSTRAINT care_team_care_giverid_fkey FOREIGN KEY (care_giverid) REFERENCES app.care_giver(care_giverid);