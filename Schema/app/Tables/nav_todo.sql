-- app.nav_todo definition

-- Drop table

-- DROP TABLE app.nav_todo;

CREATE TABLE app.nav_todo (
	nav_todoid int4 NOT NULL DEFAULT nextval('app.todo_list_todo_listid_seq'::regclass),
	userid int4 NULL,
	inserted_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	inserted_by int4 NULL,
	updated_by int4 NULL,
	todo_list_info text NULL,
	is_done bool NULL DEFAULT false,
	is_archive bool NULL DEFAULT false,
	completion_date timestamptz NULL
);


-- app.nav_todo foreign keys

ALTER TABLE app.nav_todo ADD CONSTRAINT nav_todo_users_fk FOREIGN KEY (userid) REFERENCES app.users(userid);