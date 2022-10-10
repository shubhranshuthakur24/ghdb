-- meta.currency definition

-- Drop table

-- DROP TABLE meta.currency;

CREATE TABLE meta.currency (
	currencyid int4 NOT NULL,
	currency_name varchar(30) NULL,
	currency_code varchar(30) NULL,
	symbol varchar(5) NULL,
	country varchar(25) NULL,
	rate_to_usd float8 NULL,
	countryid int4 NULL,
	inserted_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT currency_lkp_pkey PRIMARY KEY (currencyid)
);