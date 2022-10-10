-- app.nav_availability definition

-- Drop table

-- DROP TABLE app.nav_availability;

CREATE TABLE app.nav_availability (
	nav_availabilityid serial4 NOT NULL,
	availability_date date NULL,
	navigatorid int4 NULL,
	booked_slot _int4 NOT NULL DEFAULT '{}'::integer[],
	available_slot _int4 NOT NULL DEFAULT '{}'::integer[],
	inserted_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	updated_by int4 NULL,
	CONSTRAINT nav_availability_pkey PRIMARY KEY (nav_availabilityid)
);


-- app.nav_availability foreign keys

ALTER TABLE app.nav_availability ADD CONSTRAINT nav_availability_navigator_fk FOREIGN KEY (navigatorid) REFERENCES app.navigator(navigatorid);