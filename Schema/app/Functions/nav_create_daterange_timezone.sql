CREATE OR REPLACE FUNCTION app.nav_create_daterange_timezone(user_id integer, timezone_id integer, daterange integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
begin
	
	update app.navigator
	set 
	date_range = daterange,
	updated_by = user_id,
 	updated_at = now() 
	where userid = user_id; 
	update app.users 
	set timezoneid =timezone_id 
	where userid = user_id;
	
end;
$function$
;
