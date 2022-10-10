-- app.user_device definition

-- Drop table

-- DROP TABLE app.user_device;

CREATE TABLE app.user_device (
	deviceid serial4 NOT NULL,
	userid int4 NULL,
	"token" text NULL,
	device_notification_token text NULL,
	meta jsonb NULL,
	device_channelid int2 NULL,
	is_active bool NULL,
	inserted_at timestamptz NULL,
	updated_at timestamptz NULL,
	app_version varchar(6) NULL,
	CONSTRAINT device_pkey PRIMARY KEY (deviceid),
	CONSTRAINT user_device_un UNIQUE (userid, device_channelid)
);


-- app.user_device foreign keys

ALTER TABLE app.user_device ADD CONSTRAINT user_device_device_channelid_fk FOREIGN KEY (device_channelid) REFERENCES meta.device_channel(device_channelid);
ALTER TABLE app.user_device ADD CONSTRAINT user_device_users_fk FOREIGN KEY (userid) REFERENCES app.users(userid);