-- meta.task definition

-- Drop table

-- DROP TABLE meta.task;

CREATE TABLE meta.task (
	taskid int4 NOT NULL,
	navigatorid int4 NOT NULL,
	care_giverid int4 NOT NULL,
	inserted_at timestamptz NULL,
	updated_at timestamptz NULL,
	inserted_by int4 NULL,
	updated_by int4 NULL,
	task_info text NULL,
	is_done bool NULL,
	task_completion_datetime timestamptz NULL,
	is_navigator_owner bool NULL,
	assign_to int4 NULL,
	is_archive bool NULL
);