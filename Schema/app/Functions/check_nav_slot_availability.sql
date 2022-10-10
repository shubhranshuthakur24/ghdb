CREATE OR REPLACE FUNCTION app.check_nav_slot_availability(user_id integer, availability_id integer, slot_id integer)
 RETURNS TABLE(count bigint)
 LANGUAGE plpgsql
AS $function$
declare
nav_id int := (select navigatorid from app.navigator where userid = user_id);
begin
	return QUERY 
		select 
			count(*) 
		from app.availability a 
		where navigatorid = nav_id and id = availability_id 
		and slot_id in (select jsonb_array_elements(a.book_slot)::int);
	
end;
$function$
;
