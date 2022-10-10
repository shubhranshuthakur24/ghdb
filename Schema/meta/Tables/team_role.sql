-- meta.team_role definition

-- Drop table

-- DROP TABLE meta.team_role;

CREATE TABLE meta.team_role (
	roleid serial4 NOT NULL,
	role_name varchar NOT NULL,
	CONSTRAINT team_role_pk PRIMARY KEY (roleid)
);