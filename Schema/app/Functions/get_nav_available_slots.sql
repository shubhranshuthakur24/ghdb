CREATE OR REPLACE FUNCTION app.get_nav_available_slots(availability_id integer)
 RETURNS TABLE(slot integer[])
 LANGUAGE plpgsql
AS $function$
begin
	return QUERY 
		select na.available_slot  
		from
			app.nav_availability na
		where
			na.nav_availabilityid  = availability_id;
	
end;
$function$
;
