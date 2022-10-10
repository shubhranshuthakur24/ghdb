-- meta.device_channel definition

-- Drop table

-- DROP TABLE meta.device_channel;

CREATE TABLE meta.device_channel (
	device_channelid int2 NOT NULL,
	channel_type varchar(10) NULL,
	CONSTRAINT device_channel_pkey PRIMARY KEY (device_channelid)
);