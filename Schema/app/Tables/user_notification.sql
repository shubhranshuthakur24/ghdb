-- app.user_notification definition

-- Drop table

-- DROP TABLE app.user_notification;

CREATE TABLE app.user_notification (
	user_notificationid serial4 NOT NULL,
	userid int4 NOT NULL,
	title text NOT NULL,
	body text NOT NULL,
	notification_typeid int2 NOT NULL,
	delivered bool NULL DEFAULT false,
	notification_data jsonb NULL,
	inserted_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	is_archive bool NULL DEFAULT false,
	updated_by int4 NULL,
	red_flag bool NOT NULL DEFAULT true,
	CONSTRAINT user_notification_pkey PRIMARY KEY (user_notificationid)
);
CREATE INDEX user_notification_userid_idx ON app.user_notification USING btree (userid);


-- app.user_notification foreign keys

ALTER TABLE app.user_notification ADD CONSTRAINT user_notification_users_fk FOREIGN KEY (userid) REFERENCES app.users(userid);