-- meta.unique_program_code definition

-- Drop table

-- DROP TABLE meta.unique_program_code;

CREATE TABLE meta.unique_program_code (
	upid int4 NOT NULL DEFAULT nextval('meta.user_referral_referral_codeid_seq'::regclass),
	upcode varchar NOT NULL,
	CONSTRAINT user_referral_pk PRIMARY KEY (upid)
);