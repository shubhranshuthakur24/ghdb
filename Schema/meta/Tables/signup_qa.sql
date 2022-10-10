-- meta.signup_qa definition

-- Drop table

-- DROP TABLE meta.signup_qa;

CREATE TABLE meta.signup_qa (
	signup_qaid int4 NOT NULL,
	question text NOT NULL,
	answer jsonb NULL,
	inserted_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	is_active bool NULL DEFAULT false,
	CONSTRAINT signup_qa_pkey PRIMARY KEY (signup_qaid)
);