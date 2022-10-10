-- app.users definition

-- Drop table

-- DROP TABLE app.users;

CREATE TABLE app.users (
	userid serial4 NOT NULL,
	first_name varchar(60) NULL,
	last_name varchar(40) NULL,
	phone varchar(18) NULL,
	email varchar(50) NULL,
	user_typeid int2 NULL,
	countryid int2 NULL,
	profile_pic_url varchar(500) NULL DEFAULT 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFghe9NlnM-gPygO1pbXIp3QDflsCer36gLxnfHQWqVXSamYNUshZe6mbW98mFYAw4Hl0&usqp=CAU'::character varying,
	firebase_userid varchar(120) NOT NULL,
	otp int2 NULL,
	otp_timestamp timestamptz NULL,
	is_otp_verified bool NULL DEFAULT false,
	last_login timestamptz NULL,
	api_key text NULL,
	user_genderid int2 NULL,
	inserted_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	bio text NULL DEFAULT 'Deep calm breaths, Know that my best is enough.'::text,
	verification_token text NULL,
	is_email_verified bool NULL DEFAULT false,
	languageid int2 NULL,
	zipcode varchar NULL,
	user_dob date NULL,
	ethnicityid _int4 NULL DEFAULT '{}'::integer[],
	ethnicityid_old int4 NULL,
	upid int4 NULL,
	notification_status bool NOT NULL DEFAULT true,
	lang_id varchar NOT NULL DEFAULT '{}'::character varying,
	timezoneid int4 NOT NULL DEFAULT 74,
	CONSTRAINT users_pkey PRIMARY KEY (userid)
);