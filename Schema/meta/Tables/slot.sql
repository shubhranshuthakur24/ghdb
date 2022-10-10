-- meta.slot definition

-- Drop table

-- DROP TABLE meta.slot;

CREATE TABLE meta.slot (
	slotid int4 NOT NULL,
	date_part float8 NULL,
	slot_start_time text NULL,
	slot_end_time text NULL,
	CONSTRAINT slot_pk PRIMARY KEY (slotid)
);