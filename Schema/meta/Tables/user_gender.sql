-- meta.user_gender definition

-- Drop table

-- DROP TABLE meta.user_gender;

CREATE TABLE meta.user_gender (
	user_genderid int2 NOT NULL,
	gender_name varchar NULL,
	CONSTRAINT user_gender_pkey PRIMARY KEY (user_genderid)
);