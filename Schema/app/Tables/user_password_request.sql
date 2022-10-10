-- app.user_password_request definition

-- Drop table

-- DROP TABLE app.user_password_request;

CREATE TABLE app.user_password_request (
	user_password_requestid serial4 NOT NULL,
	userid int4 NULL,
	generated_key text NULL,
	generated_time timestamptz NULL,
	is_valid bool NOT NULL DEFAULT true,
	inserted_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT user_password_requestid_pkey PRIMARY KEY (user_password_requestid)
);


-- app.user_password_request foreign keys

ALTER TABLE app.user_password_request ADD CONSTRAINT user_password_request_users_fk FOREIGN KEY (userid) REFERENCES app.users(userid);