CREATE OR REPLACE FUNCTION app.add_availability(user_id integer, slot_lable text, slot_date character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

DECLARE
	nav_id int := (select navigatorid from app.navigator where userid = user_id);
	slot_array int[] := ( select array_agg(asarr) from (
	select asarr::int from (
		select substring(unnest(weekly_schedule)::text for 1) ws, unnest(weekly_schedule) asarr from app.navigator where navigatorid =nav_id)a
		where ws=(select case date_part when 0 then 7 else date_part end from EXTRACT(DOW FROM slot_date::date) )::text
	except 
	select unnest(booked_slot) as asarr from app.nav_availability where availability_date = slot_date::date and navigatorid=nav_id)t );
		

BEGIN

	perform * from app.nav_availability a where availability_date = slot_date::date and navigatorid = nav_id;
--	if not found then
	if not found and array_length(slot_array, 1) is not null and nav_id is not null then
			INSERT INTO app.nav_availability
			(availability_date, navigatorid, booked_slot , available_slot)
			VALUES(slot_date::date, nav_id,'{}', (case when slot_array IS NULL THEN '{}'::int[] ELSE slot_array END));
	
--	elseif nav_id is not null and array_length(slot_array, 1) is not null then
--		update app.nav_availability 
--		set available_slot = (case when slot_array IS NULL THEN '{}'::int[] ELSE slot_array END)
--		where availability_date = slot_date::date and navigatorid = nav_id and array_length(available_slot,1) IS NULL;
	end if;
		
END;

$function$
;
