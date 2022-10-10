-- meta.meeting_questionnaire definition

-- Drop table

-- DROP TABLE meta.meeting_questionnaire;

CREATE TABLE meta.meeting_questionnaire (
	meeting_questionnaireid serial4 NOT NULL,
	question varchar NOT NULL,
	meeting_typeid int4 NOT NULL,
	answer jsonb NULL,
	inserted_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT survey_qa_pkey PRIMARY KEY (meeting_questionnaireid)
);


-- meta.meeting_questionnaire foreign keys

ALTER TABLE meta.meeting_questionnaire ADD CONSTRAINT meeting_questionnaire_meeting_type_fk FOREIGN KEY (meeting_typeid) REFERENCES meta.meeting_type(meeting_typeid);