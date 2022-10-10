-- app.loved_one definition

-- Drop table

-- DROP TABLE app.loved_one;

CREATE TABLE app.loved_one (
	loved_oneid serial4 NOT NULL,
	care_giverid int4 NOT NULL,
	inserted_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	inserted_by int4 NULL,
	updated_by int4 NULL,
	first_name varchar NULL,
	last_name varchar NULL,
	zipcode varchar(5) NULL,
	genderid int2 NULL,
	ethnicityid_old int4 NULL,
	signup_qaid int4 NULL,
	signupq_ans jsonb NULL,
	dob date NULL,
	diseaseid jsonb NULL,
	relationshipid int2 NULL,
	medicare_advantage varchar NULL,
	health_insurance varchar NULL,
	primary_care_physician varchar NULL,
	hospital varchar NULL,
	phone text NULL,
	pharmacy varchar NULL,
	medication varchar NULL,
	profile_pic_url text NULL,
	long_term_insurance varchar NULL,
	priorities text NULL,
	more_info text NULL,
	allergy varchar NULL,
	ethnicityid _int4 NOT NULL DEFAULT '{}'::integer[],
	medicaid varchar NULL,
	mental_condition varchar NULL,
	physical_condition varchar NULL,
	CONSTRAINT love_done_pkey PRIMARY KEY (loved_oneid)
);


-- app.loved_one foreign keys

ALTER TABLE app.loved_one ADD CONSTRAINT loved_one_care_giver_fk FOREIGN KEY (care_giverid) REFERENCES app.care_giver(care_giverid);
ALTER TABLE app.loved_one ADD CONSTRAINT loved_one_relationship_fk FOREIGN KEY (relationshipid) REFERENCES meta.relationship(relationshipid);
ALTER TABLE app.loved_one ADD CONSTRAINT loved_one_signup_qa_fk FOREIGN KEY (signup_qaid) REFERENCES meta.signup_qa(signup_qaid);
ALTER TABLE app.loved_one ADD CONSTRAINT loved_one_user_gender_fk FOREIGN KEY (genderid) REFERENCES meta.user_gender(user_genderid);