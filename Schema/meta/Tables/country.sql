-- meta.country definition

-- Drop table

-- DROP TABLE meta.country;

CREATE TABLE meta.country (
	countryid int4 NOT NULL,
	country_name varchar(120) NOT NULL,
	sortname varchar(3) NULL,
	phone_code varchar(4) NULL,
	CONSTRAINT country_pk PRIMARY KEY (countryid)
);