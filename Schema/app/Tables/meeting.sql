-- app.meeting definition

-- Drop table

-- DROP TABLE app.meeting;

CREATE TABLE app.meeting (
	meetingid serial4 NOT NULL,
	navigatorid int4 NOT NULL,
	care_giverid int4 NOT NULL,
	meeting_typeid int4 NOT NULL,
	inserted_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	inserted_by int4 NULL,
	updated_by int4 NULL,
	nav_availabilityid int4 NULL,
	nav_note varchar NULL,
	is_archive bool NULL DEFAULT false,
	cancel_reason text NULL,
	cancelled_by int4 NULL,
	slotid int4 NULL,
	questionnaire jsonb NOT NULL DEFAULT '[]'::jsonb,
	preference_id int4 NULL DEFAULT 1,
	CONSTRAINT meeting_pkey PRIMARY KEY (meetingid)
);


-- app.meeting foreign keys

ALTER TABLE app.meeting ADD CONSTRAINT meeting_care_giver_fk FOREIGN KEY (care_giverid) REFERENCES app.care_giver(care_giverid);
ALTER TABLE app.meeting ADD CONSTRAINT meeting_meeting_type_fk FOREIGN KEY (meeting_typeid) REFERENCES meta.meeting_type(meeting_typeid);
ALTER TABLE app.meeting ADD CONSTRAINT meeting_navigator_fk FOREIGN KEY (navigatorid) REFERENCES app.navigator(navigatorid);
ALTER TABLE app.meeting ADD CONSTRAINT meeting_preference_id_fkey FOREIGN KEY (preference_id) REFERENCES meta.meeting_preference(p_id);