CREATE OR REPLACE FUNCTION app.check_slot_availability(user_id integer, nav_id integer, availability_id integer, slot_id integer)
 RETURNS TABLE(count bigint)
 LANGUAGE plpgsql
AS $function$
begin
	return QUERY 
		select 
			count(*) 
		from app.nav_availability a 
		where navigatorid = nav_id and nav_availabilityid = availability_id 
		and array[slot_id] <@ booked_slot ;
	
end;
$function$
;
