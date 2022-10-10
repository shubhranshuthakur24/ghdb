CREATE OR REPLACE FUNCTION app.nav_create_availability_old(user_id integer, slot_date character varying, slots integer[])
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
	nav_id int := (select navigatorid from app.navigator where userid = user_id);
	slot_array int[] := ( select array(
	select unnest(slots) 
	except 
	select unnest(booked_slot) as asarr from app.nav_availability where availability_date = slot_date::date and navigatorid=nav_id) );
BEGIN

	perform * from app.nav_availability a where "availability_date" = slot_date::date and navigatorid = nav_id;
	if not found and array_length(slot_array, 1) is not NUll then
			INSERT INTO app.nav_availability
			(availability_date, navigatorid, booked_slot, available_slot)
			VALUES(slot_date::date, nav_id,'{}', slot_array);
	elseif slot_array is not null then
		update app.nav_availability 
		set available_slot = slot_array
		where "availability_date" = slot_date::date and navigatorid = nav_id;
	end if;	
END;
$function$
;
