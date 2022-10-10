-- meta.timezone definition

-- Drop table

-- DROP TABLE meta.timezone;

CREATE TABLE meta.timezone (
	timezoneid int4 NOT NULL,
	abbreviation varchar(5) NULL,
	description varchar(69) NULL,
	offset_from_utc varchar(12) NULL,
	CONSTRAINT timezone_pk PRIMARY KEY (timezoneid)
);