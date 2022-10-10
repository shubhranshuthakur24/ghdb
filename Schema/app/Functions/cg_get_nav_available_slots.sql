CREATE OR REPLACE FUNCTION app.cg_get_nav_available_slots(availability_id integer)
 RETURNS TABLE(slot integer[])
 LANGUAGE plpgsql
AS $function$
begin
	return QUERY 
		select
			a.available_slot
		from
			app.nav_availability a
		where
			a.nav_availabilityid = availability_id;
	
end;
$function$
;
