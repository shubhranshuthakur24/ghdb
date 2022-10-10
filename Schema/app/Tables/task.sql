-- app.task definition

-- Drop table

-- DROP TABLE app.task;

CREATE TABLE app.task (
	taskid int4 NOT NULL DEFAULT nextval('app.navigator_task_navigator_taskid_seq'::regclass),
	inserted_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	inserted_by int4 NULL,
	updated_by int4 NULL,
	task_info text NULL,
	is_done bool NULL DEFAULT false,
	task_completion_datetime timestamptz NULL,
	is_navigator_owner bool NULL,
	assign_to int4 NULL,
	is_archive bool NULL DEFAULT false,
	userid int4 NOT NULL,
	CONSTRAINT navigator_task_pkey PRIMARY KEY (taskid)
);


-- app.task foreign keys

ALTER TABLE app.task ADD CONSTRAINT task_fk FOREIGN KEY (userid) REFERENCES app.users(userid);
ALTER TABLE app.task ADD CONSTRAINT task_fk_1 FOREIGN KEY (assign_to) REFERENCES app.users(userid);