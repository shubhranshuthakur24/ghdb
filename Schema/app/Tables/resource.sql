-- app.resource definition

-- Drop table

-- DROP TABLE app.resource;

CREATE TABLE app.resource (
	resourceid serial4 NOT NULL,
	title text NOT NULL,
	info text NOT NULL,
	navigatorid int4 NOT NULL,
	resource_typeid int4 NOT NULL,
	inserted_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	inserted_by int4 NULL,
	updated_by int4 NULL,
	resource_tagid jsonb NULL,
	eligibility varchar NULL,
	email varchar NULL,
	website_url varchar NULL,
	media_url varchar NULL DEFAULT 'https://d2poqm5pskresc.cloudfront.net/wp-content/uploads/2019/10/Digitally-Transforming-Healthcare-Lifecycle.jpg'::character varying,
	banner_pic_url varchar NULL,
	media_formatid int4 NULL,
	duration int2 NULL,
	md_info text NULL,
	statusid int2 NULL DEFAULT 1000,
	CONSTRAINT resource_pkey PRIMARY KEY (resourceid)
);


-- app.resource foreign keys

ALTER TABLE app.resource ADD CONSTRAINT resource_navigator_fk FOREIGN KEY (navigatorid) REFERENCES app.navigator(navigatorid);
ALTER TABLE app.resource ADD CONSTRAINT resource_resource_type_fk FOREIGN KEY (resource_typeid) REFERENCES meta.resource_type(resource_typeid);